import * as Vue from "https://cdn.jsdelivr.net/npm/vue@3.2.26/dist/vue.esm-browser.prod.js";

export function init(ctx, payload) {
    ctx.importCSS("main.css");

    const BaseSelect = {
        name: "BaseSelect",

        props: {
            label: {
                type: String,
                default: "",
            },
            modelValue: {
                type: [String, Number],
                default: "",
            },
            options: {
                type: Array,
                default: [],
                required: true,
            }
        },

        template: `
        <div>
          <label>
            {{ label }}
          </label>
          <select
            :value="modelValue"
            @change="$emit('update:modelValue', $event.target.value)"
          >
            <option
              v-for="option, value in options"
              :value="value"
              :key="value"
              :selected="value === modelValue"
            >{{ option }}</option>
          </select>
        </div>
        `,
    };

    const app = Vue.createApp({
        components: {
            BaseSelect: BaseSelect
        },

        data() {
            return {
                payload: payload
            };
        },

        template: `
        <div id="task-cell">
        <BaseSelect
            @change="handleConnectionChange"
            name="task"
            label="Select task"
            v-model="payload.task"
            :options="payload.tasks_list"
          />
        </div>
          `,

        methods: {
            handleConnectionChange({ target: { value } }) {
                ctx.pushEvent("update", value);
            }
        }
    }).mount(ctx.root);
}