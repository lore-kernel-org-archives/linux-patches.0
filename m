Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FDA1B424F
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758119800; cv=fail; b=OT9XuQA6ZEJ2dvs2IcLpVWwnSjoEE4lxe5Hho2rmqjX8rwFqDYe5D5ns1vP2x2ZLcehSdT95Ujn1Jc3qq8a4ks3GdasPdD5wRwB0wKVARkpmChvMdvB8ItJlGlcdjWRhu5TY2G6ZXDa5ncLX+gL/7n0x8yfvl16Jl1GP0UDn0A4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758119800; c=relaxed/simple;
	bh=Bqno6KSxu5C+IDuiGKKTcxOoNlm8j3MTfmXYbOhXRhg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=of1LCUS5SmvH6EH1q812/9HVfnhz1tbOCCPac44VUOvE95XZ6GnMFlWo5KGppjEVLshocQhNhwPB0w8RR8PrlrNuW3JjybqXERXaKrxUt1f6TnAVs/tqVDZun3S6vADOqNTZ63Za7JiyOL+SblvrMpZv6cxZvi9OrvFS++QmEh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e75DNwT1; arc=fail smtp.client-ip=52.101.56.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e75DNwT1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7EUruwDYvyS2qVfRPJm+7JzjXKepbNosTnKGw5TOtvlg9jrvdnhZ/KglQMbhnj4njOruBlbynrBJ9QrYLQwWtOnYmnBO0af43FHn6l/z4jnpcrcinGjY6eowhC+tzKV/Nl/AOnSwtHLH1fqiM1ptEeXb7VbtX0Ckhvt/zJYW3Jt5iJaIu9bigqx3zyqt+z7rzAmoP1IKVUuXLvUIZfVwVdIeSHeMFiq65SxRmVqEZowNZJG64xKUjqWaQ1A7X1SKJ3CV6W96awqxahuqPUwDFxmPy89XJar1DPY0hmpSyiCNIs/RCMLlaDiirrqk5XhBHIVukkSkILjpliPt8VAIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bqno6KSxu5C+IDuiGKKTcxOoNlm8j3MTfmXYbOhXRhg=;
 b=wEhv0PygEKZXZiNGug1Amgzk2rkOihW3K68n7RpilimbD/tHGAmBWxOY7syZDp1r0j+1G5qhn8ZoU2e/T+wFvd0g4DmqYD4+0W8bxhAEgU1I/WvgkWDpbDc98wQ6f1aA+yYhlzV0PV/GV5t7VkHoridlmOk9Jts2KHDamjV2XL9tHnyYbZhjBN50YBngUAfSYL0J/0TbA2RGpD3UqFWU/+VgxiSEaI4TrI7x1Z/1HoHpEzXJsXdAgGir9ga5FeIkCdSbpOurozWCefk94mRsLSmqxeJ49/8txNv/KnoQ8acVCUkA0hQcIaSvTjDjwfIQiLPbA56dR7FM6v8NW/LR+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bqno6KSxu5C+IDuiGKKTcxOoNlm8j3MTfmXYbOhXRhg=;
 b=e75DNwT1CjdxyYMUizcQ86zEAgDh7A81T2XsBKGWWp9wc2DC41qb/GwdDRy1eZtMn4OqYd0Tzo12oTwWgHuIidexChKJOEvcqWCOunQHNdtUmwiXf7ekCJL2G4xEwyhcE9ZfEBF0alsFjiD3QiHDPnUYd9kWsY/luaFuvsRaoGE=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DS7PR12MB8202.namprd12.prod.outlook.com (2603:10b6:8:e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 14:36:32 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%7]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 14:36:32 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "cao, lin"
	<lin.cao@amd.com>, "Prosyak, Vitaly" <Vitaly.Prosyak@amd.com>, "Koenig,
 Christian" <Christian.Koenig@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.12 140/140] drm/amdgpu: fix a memory leak in fence
 cleanup when unloading
Thread-Topic: [PATCH 6.12 140/140] drm/amdgpu: fix a memory leak in fence
 cleanup when unloading
Thread-Index: AQHcJ9ITf72eJF2pgU+VOw+q7TTqmLSXcSVw
Date: Wed, 17 Sep 2025 14:36:32 +0000
Message-ID:
 <BL1PR12MB5144DD691B4246E3F70302BCF717A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250917123344.315037637@linuxfoundation.org>
 <20250917123347.745396297@linuxfoundation.org>
In-Reply-To: <20250917123347.745396297@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-09-17T14:36:09.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DS7PR12MB8202:EE_
x-ms-office365-filtering-correlation-id: cec504f0-3527-4570-0c8f-08ddf5f798ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?OUZhbUN4SXhnWkFFd0RXaFdENWlZVXhNTGRjeVNMYkVPOGVyYXhhbEtCYXpP?=
 =?utf-8?B?MC84TnZHazE3MmpZMk9Ec0NaUG1EVkI4Z0M5KzNMa04vRFBPaXRvYzNlcTVi?=
 =?utf-8?B?TjhQSlV4SThOL1pyM2hlYi9FLzY3S3dOTHJ2eEpOamdNYUNQWEtnd0xhdHFT?=
 =?utf-8?B?OE96Q3hPUUNmendSOExmbzg3dDJMRG0rZDc5b2R2T25LcVhFOW13U1V6ZjVL?=
 =?utf-8?B?V2NrRDVNeHNnYUN1WEVPb1JvczRiY1BPckVrREFKRGJJZzI1RWFSKzlwdHhZ?=
 =?utf-8?B?R1UrZSt3aG1UVXZ2d1AzQ3ZzOGY0RmRRRUpjaTJTVW50MVc0R1RPUXZsSFhU?=
 =?utf-8?B?QU9NTmlwdWVhN2wwelN3SE1XaGpzWmxBMFRIaVo5RUlPZXRGRElpOXBheXNJ?=
 =?utf-8?B?S3FCWG1CMzJBZk80YlhMZ2dMdFh5OUhoUFZTOEtTWmcrZ2dPdzczRmRYaVlR?=
 =?utf-8?B?L2dVT0k1aU4rMGJ0ZmRGZTlqaEpOcVZ1bEVKS2tEditvd3hmb2Y0WXAxTFBs?=
 =?utf-8?B?bmFZakdXVUQwa2JyTDNFU1ZJNUU1WTd3Q3NRZmR2ZUI1b3lrT2o1SWdpaUdO?=
 =?utf-8?B?Q0RPSVZYZU1sYko1TUQ4QWRqYktzSW95cVBEUjYxT0tHUTV5VGF0WWkzaGpN?=
 =?utf-8?B?amZNQlJ2NFROMy9wekloWmUyOVV3dkdkY0JOSWdsRm4yLzY3M0ZJUUFaVUQv?=
 =?utf-8?B?cGhKRys0UnQwaS9DbFd6RkRnZVpVOVlZTTVDWlNYeUMxQUNBcVc5VVVIMU9X?=
 =?utf-8?B?TEhETzB1TFBzdXZXc0JaSmdIYWUyVmFvZ3B6aUVVZitkbFA5czk2aFR1ZmJ6?=
 =?utf-8?B?d3R5S1hnMnNUc2E3K1I3YTlCcml4d1RCWjVOV1ROeEJDM2d4bHV3ZTJOdFpm?=
 =?utf-8?B?aGRwR2F2VGJoTVFDYURoblJ2Ti9XQmtaK1Y3bVlob2V6WDI4aDRwZEpGWWhE?=
 =?utf-8?B?Q3k0QWNONVl0ZUNTMkJSblh4UnAyR1hlcXluenh4V3VIdkxkVld2Ti9vN0t2?=
 =?utf-8?B?ZVVaUGc0Qjc2aHVuSHFQalpCZWZIbllTYnVmSnBwQkF1c0g1LzlsdW5GUDAr?=
 =?utf-8?B?TFltVVZTTG1RS1NtVGtEL2QxdmVoTE1BZmdkeURBZGxnRjN5OENXSjVhVmE3?=
 =?utf-8?B?ckQ4NEF3bGMrY2c3dTNoNFhnMUZXOWxvNGV4bSttU2R6OHo0a0Y2ZUkrRXhC?=
 =?utf-8?B?ZlpBVzEwSGYxR0kzVUs3NHI4WFovbnJFYW5ZT25iUEZtUUkyZlkya2U0YTJt?=
 =?utf-8?B?RkMyeDBqSHBOQ3lGUE85RFlKTkluUFRpS3FOUFE0bmdpL052U0pRdEtOWEJU?=
 =?utf-8?B?WlZQZmpiNVVlT0pncEphUW9VVzVMNHB4VG1ZSVVQbWY3bHlHQlYwSlJrbjhV?=
 =?utf-8?B?OXRxZVpMM2dhVE5oaW1Cc0x3Skh6cG5YZmdBQjhTMkh1Tkl6QmdGVDVQQzhm?=
 =?utf-8?B?ak9Iek5WQXZzeWVBT0FJMThNUGt0aHJYYWxIZ1lXUWZLV0tjMWJnaTUzZnJC?=
 =?utf-8?B?MG0zVGRtUm02VmpJa0V3YkRMOC9WTjJmREVmcXIrbkZIV0RCb3hmMzFuVG10?=
 =?utf-8?B?WkZvekVvbkhTRkZiZm9mRmgzUnB6Q1lGSCtISWw4bXZFdTVOa2NFQWFxTkFz?=
 =?utf-8?B?QlRCV0J0ejU2S0pqNUpjZzIxSnZWTGFwa0pGeFVXWHVGeVdLZUNZWitPV2Nq?=
 =?utf-8?B?SzNna2c3ejlVQWE2T3lGYkNNYjVYV1ZvRW9aNHlKSjdDb0dhdE9pd21YamNw?=
 =?utf-8?B?T1FtbVhTTHdmc0pMVkx5S3l3T0Z6NjZKOWp0cFlhRWtjUDhrNDF2eS9DaEpn?=
 =?utf-8?B?VVZuU21XVVZtWnoyN3FyQ0JwRUFRQ2lPenNCTzVtemwzODE4SzBPQmxiL0xC?=
 =?utf-8?B?OExSSFVFbG1CN1daeVIyNlNMcUtFZTlmRTI0MGllREhocXVhcHVVSXlLd1dS?=
 =?utf-8?B?UE1pZGRkblBZZkI4M0hXcHJkNmEvcnVSa1l0Q05VT3BxSTFVNmtZU0FXd01B?=
 =?utf-8?B?ak9tT3BUODR3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TWE4eDJDQkJ1SWwrVGZaNmNWeWpDeFNHc084MVYwNndYOThsdzV3c0dObER1?=
 =?utf-8?B?Si84dmlCOWV0MzR6WEVtdklqaTV2SDUzdGhUVDdpaUtlMkpvR1RXVmd6S1BF?=
 =?utf-8?B?QlRmc245K1pNOElWRFhYVmE5YzkxUVpKTnY1eFBUL1c1U0lOUVRPUTJEdWo2?=
 =?utf-8?B?SXlKVEpGMFRGUTNSNXFmWG4vT0h5WVppVVVhM1JQaFNNcm9zK3M0RHBNSGZ3?=
 =?utf-8?B?dWIwNHNxN2FiY2p2ekVrMUFsWFYyMEdzalM0SHhORk1pUjZpNE84QTF0RmF6?=
 =?utf-8?B?eXZ6anEvZFNuT0o3SnRkb3pNUlVxUFNKdHdhSDFHamUwTE9YU29Wa0trL3Q1?=
 =?utf-8?B?TlM0Z3k2U25RRjZhNlpKQTlDOXJVOFdyRENjeGVpU1AvZTRhWUpCRkZiamhy?=
 =?utf-8?B?YTNNaG9zSnFERjVLeTVwTEpkNjZFWlVpNEo3eGJwYVl1eVRDRzI1Rm1ESzl5?=
 =?utf-8?B?K3VibkVrb2hVb0J5SGh4UXNWSkhXM25DOTJMYmJmZnllYlNSZFl1TUFUN0pv?=
 =?utf-8?B?NzZraENHYlFweVZCQm1KMGxtVWlHSmljN3cwMm9HTzI4S2VndTRrVzIxNDVT?=
 =?utf-8?B?U3BTdXJITEFwVzZEMkxPaEdGK1dVaXp3WlU3dExwRjZoeG9udHpCU0tBbmlT?=
 =?utf-8?B?RDFhTm8vN2prbGQwLyt6Q2RqUWpmRmlOTk5mdlYzNzYrSG5vVm15OHMyMWFC?=
 =?utf-8?B?dDdMbnp2czZQMjZqT0FTRUh4UUVVMW9MM3hHK1V0d0VqSENqc2owL1FWYUNn?=
 =?utf-8?B?ZytocEdYZ1hWZjR2Wk5hemRZek9zZUs0eUt6MHFGNERNYTFxTEdjenBRc2Qz?=
 =?utf-8?B?amtuSVZmaG1OcEtNNmwvaXBobGl4ZjA4YzE2U3BZeXZkcWJvaEdpWGJzb0xn?=
 =?utf-8?B?dDlNNzRHQjNLVnhlQ25Ycjc4Y2gyZDd2d1E1T3MxZ2xtSER4N042VmZqUUEr?=
 =?utf-8?B?SmxPdG5heDV5U25DbWxTK0xFQlpDbUhXL2Ewb1FIQ21iZ0JzeFVBR1lpTXZ4?=
 =?utf-8?B?TjlLeVo1Y3pPY1pMR0hUNnYxNDZ1cDR1VWZ4eCtoOUZTZ1RLVmFOZVZsNlUr?=
 =?utf-8?B?TVpUSUZ5Ti8wUHY5ak5ZY2ZteTRBUlhLRys5K2lzMUtZUTFFZi93Sm9KZU94?=
 =?utf-8?B?Y3FDbVl0WTFXakViaE5kOVhXYVVtdWkwVkpLMGFYWVQzdjN0WkhUYXp0TU4r?=
 =?utf-8?B?Zy9qb0ZoWHZubXh0Y01CSnRhdlFZQ2FHc0hyTmJEZmErcW5jWmhmd2xPZnBy?=
 =?utf-8?B?R1JJVHV4RVkrUVBPSXdPb0JPcGRXN2hLcXh2Q29ka0orNXJkNUJsWnVObWEv?=
 =?utf-8?B?bHgyOXlMK2dPWHNyUFA5MGROd2p2V2RONFZiQzNEb20reVRBYi96U1UvNzV5?=
 =?utf-8?B?S0VNcEFOakFibXFlL1Fxc0FwMkQyeFVaWllmdVBQdS82eHhQUjh4S2ljR2hE?=
 =?utf-8?B?dXhnUU11ZVQrV0l2cGhKSWQrQzRJRkhBM0d2ZHArUG9VOW5STEZaSWU2ZEZT?=
 =?utf-8?B?Z0hqZktTbnlpemt1ZS9MUS84MjFmeXM5TEtlOUIwT1daMEF4TGJVUmNNSmxi?=
 =?utf-8?B?VmZ5Tis1M1kwMUFNeDFwV3FxZnB4bk9Pd09Dd2dadHhjVWE2TWVJNklKcG8w?=
 =?utf-8?B?SGdRQkd5S0JtalpmTFY3Y2h0RTl1V3ovb1NMK01mcEdvZWRieXZpVHZsY1BK?=
 =?utf-8?B?Z3ZhQXVDWFB5YmFGK1lQRFdOb3Q3RVd5ZUpReGRzSVNqYmlqTnRjYjlSL0Nw?=
 =?utf-8?B?SlZNMks4RG4yR3VmeDhkeFozNUhsN2ErYnlzQ0NCY1JVbEhWY1kydjlqdDJm?=
 =?utf-8?B?aWZlVytnUmhuNitmeFBaaG9IRUJmQmhVSFNDd1lRbExsSWtmSkFBYzkvcDdP?=
 =?utf-8?B?TzJ6LytNUkZNVytGY1NSeUVwVmpndDZYcmVOZUlCd1M2enBuN2poeWpOS3lU?=
 =?utf-8?B?YTdzakgwenkwcXp4d3RyYjc0cXZxWlhVbjFFZlhQYzU5RFNzZ1hmYnNWay9s?=
 =?utf-8?B?MDNsYk1reTVGY2I3RDJzbVlnemZ2aFUrT0ZLWXJCNys3cmtZR21jdGk0aFR4?=
 =?utf-8?B?aHpETWl0S3l6Mk1TdWlRYVR4NnZJS3BNODRaZTNaRjRJcndvRm5kMjRkVXNz?=
 =?utf-8?Q?jpf4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec504f0-3527-4570-0c8f-08ddf5f798ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2025 14:36:32.3506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8jnUAnmUUO6cbgiUudUPE3adSEUOdru3XS6a9t8cmAJVqLLc5OI5a69voFsjXkElCKetXa3pWequl81YIkK3ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8202

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNk
YXksIFNlcHRlbWJlciAxNywgMjAyNSA4OjM1IEFNDQo+IFRvOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+IENjOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3Jn
PjsgcGF0Y2hlc0BsaXN0cy5saW51eC5kZXY7DQo+IGNhbywgbGluIDxsaW4uY2FvQGFtZC5jb20+
OyBQcm9zeWFrLCBWaXRhbHkgPFZpdGFseS5Qcm9zeWFrQGFtZC5jb20+OyBLb2VuaWcsDQo+IENo
cmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+
IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwu
b3JnPg0KPiBTdWJqZWN0OiBbUEFUQ0ggNi4xMiAxNDAvMTQwXSBkcm0vYW1kZ3B1OiBmaXggYSBt
ZW1vcnkgbGVhayBpbiBmZW5jZSBjbGVhbnVwDQo+IHdoZW4gdW5sb2FkaW5nDQo+DQo+IDYuMTIt
c3RhYmxlIHJldmlldyBwYXRjaC4gIElmIGFueW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBsZWFz
ZSBsZXQgbWUga25vdy4NCj4NCj4gLS0tLS0tLS0tLS0tLS0tLS0tDQo+DQo+IEZyb206IEFsZXgg
RGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4NCj4gY29tbWl0IDc4MzhmYjVm
MTE5MTkxNDAzNTYwZWNhMmUyMzYxMzM4MGMwZTQyNWUgdXBzdHJlYW0uDQo+DQo+IENvbW1pdCBi
NjFiYWRkMjBiNDQgKCJkcm0vYW1kZ3B1OiBmaXggdXNhZ2Ugc2xhYiBhZnRlciBmcmVlIikgcmVv
cmRlcmVkIHdoZW4NCj4gYW1kZ3B1X2ZlbmNlX2RyaXZlcl9zd19maW5pKCkgd2FzIGNhbGxlZCBh
ZnRlciB0aGF0IHBhdGNoLA0KPiBhbWRncHVfZmVuY2VfZHJpdmVyX3N3X2ZpbmkoKSBlZmZlY3Rp
dmVseSBiZWNhbWUgYSBuby1vcCBhcyB0aGUgc2NoZWQgZW50aXRpZXMNCj4gd2UgbmV2ZXIgZnJl
ZWQgYmVjYXVzZSB0aGUgcmluZyBwb2ludGVycyB3ZXJlIGFscmVhZHkgc2V0IHRvIE5VTEwuICBS
ZW1vdmUgdGhlDQo+IE5VTEwgc2V0dGluZy4NCj4NCj4gUmVwb3J0ZWQtYnk6IExpbi5DYW8gPGxp
bmNhbzEyQGFtZC5jb20+DQo+IENjOiBWaXRhbHkgUHJvc3lhayA8dml0YWx5LnByb3N5YWtAYW1k
LmNvbT4NCj4gQ2M6IENocmlzdGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4N
Cj4gRml4ZXM6IGI2MWJhZGQyMGI0NCAoImRybS9hbWRncHU6IGZpeCB1c2FnZSBzbGFiIGFmdGVy
IGZyZWUiKQ0KDQoNCkRvZXMgNi4xMiBjb250YWluIGI2MWJhZGQyMGI0NCBvciBhIGJhY2twb3J0
IG9mIGl0PyAgSWYgbm90LCB0aGVuIHRoaXMgcGF0Y2ggaXMgbm90IGFwcGxpY2FibGUuDQoNCkFs
ZXgNCg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0Bh
bWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVy
QGFtZC5jb20+IChjaGVycnkgcGlja2VkIGZyb20NCj4gY29tbWl0IGE1MjVmYTM3YWFjMzZjNDU5
MWNjOGIwN2FlODk1Nzg2MjQxNWZiZDUpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+
IFsgQWRhcHQgdG8gY29uZGl0aW9uYWwgY2hlY2sgXQ0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBM
ZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFy
dG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUv
ZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3JpbmcuYyB8ICAgIDMgLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMyBkZWxldGlvbnMoLSkNCj4NCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
YW1kZ3B1X3JpbmcuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVf
cmluZy5jDQo+IEBAIC00MDAsOSArNDAwLDYgQEAgdm9pZCBhbWRncHVfcmluZ19maW5pKHN0cnVj
dCBhbWRncHVfcmluZw0KPiAgICAgICBkbWFfZmVuY2VfcHV0KHJpbmctPnZtaWRfd2FpdCk7DQo+
ICAgICAgIHJpbmctPnZtaWRfd2FpdCA9IE5VTEw7DQo+ICAgICAgIHJpbmctPm1lID0gMDsNCj4g
LQ0KPiAtICAgICBpZiAoIXJpbmctPmlzX21lc19xdWV1ZSkNCj4gLSAgICAgICAgICAgICByaW5n
LT5hZGV2LT5yaW5nc1tyaW5nLT5pZHhdID0gTlVMTDsNCj4gIH0NCj4NCj4gIC8qKg0KPg0KDQo=
