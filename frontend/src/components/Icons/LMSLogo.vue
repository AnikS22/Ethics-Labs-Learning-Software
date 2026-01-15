<template>
	<img
		src="/assets/lms/images/lms-logo.png"
		alt="Ethics Labs"
		class="ethics-labs-logo"
		:style="{ width: width || '80px', height: height || 'auto' }"
	/>
</template>

<script setup>
defineProps({
	width: {
		type: String,
		default: '80px',
	},
	height: {
		type: String,
		default: 'auto',
	},
})
</script>

<style scoped>
.ethics-labs-logo {
	object-fit: contain;
}
</style>
