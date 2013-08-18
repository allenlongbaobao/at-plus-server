/*
 * Created by Wang, Qing. All rights reserved.
 */

module.exports <<< 
	server:
		port: 3000
	mongo:
		host: \localhost
		port: 27017
		db: \at-plus-test 

	# --- 联系人通讯方式校验配置 --- #
	communication-channels-validation:
		im:
			type-white-list: ['QQ', 'MSN', 'GTALK'] # 这里需要进一步加入所有可能的IM提供商，或者改用黑名单？
