Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2042.outbound.protection.outlook.com [40.107.102.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C7BD515;
	Tue,  9 Sep 2025 03:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757387781; cv=fail; b=t6SBqi2+q+FBdG//qUpSiYDNPUlddozczX9s6CehzSdRTQvH2jSUEk+e434HqgDYE7mb8sGzaokhiiJLEBMdmMKY76OBZcfrP1HmXMOCJLlYVHGzgSq9iJ+4JLKkCFK5BBeNVkA/gdZG/CBRlscaEQuHpz2e+6wg3Kf6EBfZI1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757387781; c=relaxed/simple;
	bh=y2b4mqgUeOdCWKjP8UmdoBnbRE+htKu1bs4jfYpP4EE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=puB+cIiu+DlGTAeS4EQKn+B4tdT6j9m6zpVv4QYmLZkGdvrsWCfsuxjt4lbgkPJnKrKf8AHRx32M3G/eLPC5BvUAeQsR5hCsWB8GlJ17MsqLSGxjGgzVFQzE5a/5yy+RvQgXr41YKOdYh5tGS641fDSk6+4CFMsuhNKS6gERadc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KFsKuZp5; arc=fail smtp.client-ip=40.107.102.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KFsKuZp5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dgmbsuu9hEM18rwhGfIfTkO2lyLdiJRkyOMTHU3z4tCt79C1kttITIR9TJvMvqL9URJyp/9ifMJFw+BBa0j+dzSl1J7T2jSwkEN6OkBhSDrQv2dJRX7zSUPqlCd1TNju64/14bRYsEc3t3Fbn447DJ9dntjMEBE/Qv/ix5RWrQ3z4x2CZJHmZ/25Fa9nDKl2UGHg9mLO5T8bP8Y6dLrba0CwNm338SMfZ49/oWYg5dsDkrxUUvVwgvZqw/HSae5gv3s4XivuTV+ov+fOoahW11du4sohZD37ps/CN9ZgMIP5Ke00jDH1M4OYUnYbEnhkHfYy1UZFo0ARFH0iVyvOwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2HpGfYFiTkL/EeXz817gNOceLAQ/hQlR2BHGghC0tQ=;
 b=Wi4JsNwzDZcIKnwzgrIW+/pCdmMajBXnSWRFk7azky3t5QqfQIbiS3aTn5AN2xUkMw1QLK99MuYXMvdAIyxpkPBUEf6OKk863SmyCQoMHiP7+KSFqNe066kQzWYuvfvQvmNZGR67/ye+tRBRkDqMI/qQHkYMmb+Bhf4TIJdl3IwMWFDaXg4i+UVMfvke1EAIlf+8ydn8GNCWmsC6p9xsyXtXbVzpMzglEymBXA7i23yl7BHABbD8jG51SpsGBExiID5KF15K17C8mVdcuzLEra7RhVAVmwG8n5SyypeF40fOTT0+7LS0NM9yLybNrCaoY/qDDnIrIRiMuMb77Jy+8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2HpGfYFiTkL/EeXz817gNOceLAQ/hQlR2BHGghC0tQ=;
 b=KFsKuZp5ELxhXgXAiGefY5Bn+P/YsnnSrufeTq+Ejr8egIXuSsv3OFlYZxO394v1iv3Lo8P8ctvCfMga0fpE7PcEis3s3/YoT6mcTBJ+uv6VE4xtNk2ITqB93GgxyR5wvfU3FLobGuKCeO7Iv/m915EfXUsyApZOUk2Ge6ED6s1NSrZo7AxPPMxCnuwTOx1dU2ZZ1O/lO4cH/DZtDf4uZYkIZ3DcC9T0MUjAW4Wj2/T2NqCD87VAw03exfDJA5moNRBztVrAL8dre/UvWxtyDpKHzcDT4VwuqY25QKihYMwn25LkC8QHLPA0wbuydbOJE85TsOL2gEHDAMUSzRhtIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB7247.namprd12.prod.outlook.com (2603:10b6:806:2bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 9 Sep
 2025 03:16:17 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 03:16:16 +0000
Message-ID: <d2852d21-60bf-4ca4-a0d2-e70c0c6dc010@nvidia.com>
Date: Tue, 9 Sep 2025 13:16:11 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rfcv2 1/8] iommu/arm-smmu-v3: Clear cmds->num after
 arm_smmu_cmdq_batch_submit
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, will@kernel.org,
 robin.murphy@arm.com
Cc: joro@8bytes.org, jean-philippe@linaro.org, miko.lenczewski@arm.com,
 peterz@infradead.org, smostafa@google.com, kevin.tian@intel.com,
 praan@google.com, linux-arm-kernel@lists.infradead.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <2f7f5fff38d43221fd60139323d23b258e34cf8d.1757373449.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <2f7f5fff38d43221fd60139323d23b258e34cf8d.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:a03:114::16) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: 03da0725-e70b-4d8f-4870-08ddef4f3d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmV1dWN1YnB4VmNQSldIWW1hZHJjN1RUUjFvNjRWcHNUR00xeDh1NnFEdWxy?=
 =?utf-8?B?dEcxQlc1T2dOcmFDeE5TeS9KNXp3VDRUTkxhUHpzSHV4MzcwVThyM1Y3UXMy?=
 =?utf-8?B?dUgwdStaVURhRkgxZ0lyZmw3RW9zSmdKT3U0RTQyNEJ2RjRzUW5hTVVzblZO?=
 =?utf-8?B?ci9ZNlZkMXdETnZYc3lNTFVRakZYSDNHUFlkWHJ1SzE4N01vNFBoTWdwa1ZK?=
 =?utf-8?B?TkVjUzhBTzh4VWpQRWpRN0lFT3BTTGdYZkFyTGVoUkhnYW1qTHRsMThJZ0NU?=
 =?utf-8?B?RG1TeEprNHJBQnU2TmQrNHhnZW9UNTdaQjhEWDhPKzFlMUVobVpSWk02MUtm?=
 =?utf-8?B?WE1kaWhqamRMREFqRkFXNXFhNlNvVUN3dDBuaEd2ZWRVUThudG54TkhONHd0?=
 =?utf-8?B?UWVZaG9tTlNwam5wR0tBZi81M3dtemRET29VS1QycFdva2I5b1ZqTjZuV0R0?=
 =?utf-8?B?TEVYWXBEakF0a0hUcUN0Z3RrK0k3MEM4MnFlVTZZQmdabC9PUkZOQXZXQ1BX?=
 =?utf-8?B?Qnk2cFQydHNrWit0enFycVNhNVZ6alZpRWFkYjRZME9GLzNpU1hzc3ZTalhE?=
 =?utf-8?B?MmlsRjBBNCs0eEdxbUxDc3NLUi9FSXY4TGExUFRxcGdsK1BiMG5XTmd1MGhp?=
 =?utf-8?B?TXhFSVlhTDdiTlJXU2s2R1lBaGJyRVpycXlXVG9qRGJmUy82M1ZjeHJDeTJI?=
 =?utf-8?B?VWRBbEExVjl3MjU1V2J6MktQQXYrUGY1MW1nT0E0VUx4NnF1eklJc081a0w4?=
 =?utf-8?B?RFJjOXV1UksrQkJZNTV0a1hKU2x6YVg3a2hJdHJDWERQYXpCOW4vVitpT1VD?=
 =?utf-8?B?OEhkQytYUlVSdy9xNlRuajJaN1B2L1BGUWMrMDdkYXN3WjdHM2l3dXNrdWxu?=
 =?utf-8?B?dlM0NldRZXVQMXFJS014c3lXS0lWb242d1F3UVI4NzJLdHNieWpjekFXQVZG?=
 =?utf-8?B?R0YzYmFVSUdsUXBsU2NPOG9BMWZqOS9jZ3g1eDc1NlVrYkpJNFp1ZDNWK1Y4?=
 =?utf-8?B?dDVnMU9CZXlIRGRhVEIzRG9xNW9pdG1XbW5YaStiSGNyZ3FvemdHUUxqbHFm?=
 =?utf-8?B?MTZtVTRYYmNwM0VGMHMyNjlGNDYvaERRZmlIWUlJZjZ0RVA2Y2pyQVByUEkv?=
 =?utf-8?B?T3pkcUJkdFhtOGxZQmVNb0U5ekZGVWR1RzFzMnF6UTBMbUVjSHl3bFB3cmJy?=
 =?utf-8?B?VjMrSlRCaEUzTTdoNG5GSytra3hsTmNtQnBxOHRncFBJRS9BUWtkanFzM1dG?=
 =?utf-8?B?ZEhmRXdjcVVZRzZqc1V0a1JweHBFQi9ycHJKY2h4Q1VoNElOM0tlMTFaTXdo?=
 =?utf-8?B?UjJ5QVNaU1FTOUwvQ1JFVjVNVGpyUUxFUk5lMEFzNmZ5bWpIbmY5bjJpR1hp?=
 =?utf-8?B?TjJrK3JJMEJlUGdhU29VWlZhVWhKRWNzQkY4bWk0Um83anh5b1o0UVVOOTRU?=
 =?utf-8?B?eDh5U1R5SXdTOG1mUlNLM2xUUXhHYm5FZW9TVlpHYlhxL2FGTEdaSmpIc0Va?=
 =?utf-8?B?eGQ4amR0QUtkeGxqUlN2OGpMU0FxeFF3cHAxWkxXeG1HQ1VYMTJBTVFoM1FS?=
 =?utf-8?B?MTdEUGJUVm5kdmdHcWE0NnZCR1hTcXh4Nk5JcUlsaitrM25pN2tCUUVBUUU3?=
 =?utf-8?B?UTMwdXhzbXNaM1ZtYlR1eGJqc2U4R3hISURDdW40TEJKMFdsQVhTNTlCRERF?=
 =?utf-8?B?Vjc5TUI0V0hGUXZ4TGYzWmZsSERIWXd4djlSblpMQmFzSEhJOG5FYVg5UnRv?=
 =?utf-8?B?Z1kyWkpxNjVFQmxQRCtWN3pWZzcyMW1hdEdzOTlrd2lxc1FMc09uNVpqR1du?=
 =?utf-8?B?UUROd1RuQzgvMm9EL05GazNjeVZMb0pYNEhQVnJDa2xVck5Wd2pRL2lRSlpy?=
 =?utf-8?B?OUJYQUgwMDVlRExKdzI2M2NqZUF1ZDg4d29kcWYzMWZMWFo1YzV5UTF4L0xU?=
 =?utf-8?Q?vbV3buLaFfQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUVkQnd2ODJQN0NLZDZlV2VIY2Y3ZVprYnJDYk43RXNBRVh2UmJmZTVYTGdw?=
 =?utf-8?B?Rk9RcHM1NEVpTndhdmxJczNCMzBzWHRmejhsWm1OcUN0M0VHenAya1Nabkdl?=
 =?utf-8?B?TmYvbCtuVkRSMVZNenZYVWk3c3NFRVFxSXFNbGZsb25IRGJFT0ZsNGpxSEhI?=
 =?utf-8?B?S2ZWQWZVV29kM1FnSktka1JWV1lYanZtRENENTRXeEJndFBjalU3UU9hWVJL?=
 =?utf-8?B?cEFaY1JLNzk1RC8zMnN3NWc0UU90eEVRbnRMeklQdjdSWUZ4Z3RXU3ZVcHRG?=
 =?utf-8?B?VVo4TFVEcW94Qlk4RXBnMWNJRVBHMXZWdDVCdmIzbzJTbnZvWVZJSzNsZ0pz?=
 =?utf-8?B?Z2VhajZLUmpETkpzalhtQis2SWdrdzNIL3loeS9qNENLYXVLVW91b3hXbWxR?=
 =?utf-8?B?QUZva2pEZm5ZNnYxRk8rSnVnUnhnSUx5UnVvRUd0RmYvRGFGMmJhYTBzckll?=
 =?utf-8?B?Q1lPRVZuVllSL0ZaN2FWV3FJQVJsYnU3QnlkTlE0S3krZkM5YXgvVjdVWGVj?=
 =?utf-8?B?WTN0NjZ1c0R2UHBmb2tnazdDak5CbjVxS2Zoa1hmSi9hUnhFUlovM3VXWUNJ?=
 =?utf-8?B?M1VzNlZXNUhUeWhnMmRFNVZHYnl3aytQTUQ4NmFvUVJYL2VNRlhaMERZVlha?=
 =?utf-8?B?eXJhRTR3dXo1Ti94VTI5YmY3VWdselNEanBuaUhuSHNRSUJsbnhPa0hRTFFF?=
 =?utf-8?B?NzdkOW1VVGRETHU1Tkw4alMzUkVyVVBzcEsxN2xteWFiZGt1M1UvYnkwZHVo?=
 =?utf-8?B?MmIwNW9pV2Z1SDh2aitsbVVGakwwdGw2OElRL3hpL1YrQWdVZ1N4SzVuL1NV?=
 =?utf-8?B?Sm5LSWJQUEUvalg5VDFqemRVQTViZVJZT1cvRkYyY1pBMmo2VGtJUFJQY2FU?=
 =?utf-8?B?cnRQalNtMktjQngxZVdCUFo5MWZJVEQ1ZmwyTnpDQkNGejZpeUw3ZXgrdDNz?=
 =?utf-8?B?V2NvQXlUODNHK0FHY1pQRTZaSXBjMUxzTUJMRDZQUG52MWRBMFNJZS9QNGtz?=
 =?utf-8?B?N0VkeXJZM0wwVm5QT1A3SFNwNU43RGIzRzZZbG1MVXU4VUJjTWlaUkdqeVIx?=
 =?utf-8?B?RU96Y3BWZnI1eWt2RzVtbUNPOW5CWGNBcCt0dWkwa0Z3YU93aWJEbG1pbEpK?=
 =?utf-8?B?WkpldlhSbm8yelVSWGtqUGRyMGx2MWQzRUtUWXZHMnd4VXNRVWxHNHpPNTBs?=
 =?utf-8?B?Z1lUVzVDanFKR2w3ZHliTGFYWTd5VmNDVVBRbUtjTkdYSWdSWlIwb05OaUl3?=
 =?utf-8?B?cmdIV0tGQk1BaTBFVU9ldXducGM2bTY0QnREazZONU1vQndudUZJNURUNnp0?=
 =?utf-8?B?RE5aUFk2R2V4VlhneTRzWkZpVE00L1VrdU9CS1lpRTVtaTBob0VaMlgvaWpQ?=
 =?utf-8?B?OUdjLzY4WEo5M1lhMWZFYnJxN044L3YxdVJRZFpmMTBYOTcvSU5EaWxFa2x4?=
 =?utf-8?B?SkNWcFk1a0piMFR3VFR4a0xtVXZWamppNzBybDhzOWtuS3dXN1JYalArbTFy?=
 =?utf-8?B?Q2VhUkZkR2Z2VXA0cHNTTk1YK3BtU2VDejJKdm81SHRMVit3N3ZFQk9zMVpl?=
 =?utf-8?B?RHBFYklXeCtpaTFnd3l1bkxyb3R4Vk1hdUY5SEg2QlFIclZ3ejdkWlpMelpw?=
 =?utf-8?B?QlZab3dka2NXMFI0Nys0VXlQTEZ3K3l6VWlpMzU0RzlSQThLd0RGOGo0TmM1?=
 =?utf-8?B?ZHMrbHpKTFRUbyswaW84TC8xaVI5YWpBVDAyNEV1UVdHblhKRXJ1OStsV0N4?=
 =?utf-8?B?NUlqUEFsVGt0bVFqZW1mTnl3dWNZMlRLWEt3OE9jQlB2eloydzFNM3dMalo1?=
 =?utf-8?B?SXBSRmlraTg1bTB1UW50RFo1ZFpHYklTUHAvellGU0lsTHVjSFJ3VWZoRk40?=
 =?utf-8?B?SzVRYjc0UnVLeVk3NjA3NExkQ1VzeFRyblpYdW9DMDJ6MWdubzZSTXd1WVFS?=
 =?utf-8?B?bTUxQWZyYy9zK0JNWWNuM2dxZDVaRFRYVWJ1b2doeG84QTN0RTVkRzk3M0dD?=
 =?utf-8?B?M1dMN3JqUk5zTFBOZ0FXUi9udHRoVDk2ZmFzSTBKMXpNK0VWNlZITnpLYWNu?=
 =?utf-8?B?dTVubUNyVkdiSjBucGpYRUlHL0xTcXZQUVNPMEdFeUNNOGY3S2FSLzRCdERM?=
 =?utf-8?Q?sveUwt3gNZsnqjHTjESm+UZ5r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03da0725-e70b-4d8f-4870-08ddef4f3d3e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 03:16:16.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m2KzPrH//jekzj06YfwO0E+2TxejV7w8z4QQUlMz6pHRccyIfU30u+H8zBqVhYsD1SQQaTYKf/Ujg6alJf9UHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7247

On 9/9/25 09:26, Nicolin Chen wrote:
> None of the callers of arm_smmu_cmdq_batch_submit() cares about the batch
> after a submission. So, it'll be certainly safe to nuke the cmds->num, at
> least upon a successful one. This will ease a bit a wrapper function, for
> the new arm_smmu_invs structure.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 2a8b46b948f05..cccf8f52ee0d5 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -974,11 +974,17 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
>  	cmds->num++;
>  }
>  
> +/* Clears cmds->num after a successful submission */
>  static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
>  				      struct arm_smmu_cmdq_batch *cmds)
>  {

Nit: arm_smmu_cmdq_batch_submit_clear()?

> -	return arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> -					   cmds->num, true);
> +	int ret;
> +
> +	ret = arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> +					  cmds->num, true);
> +	if (!ret)
> +		cmds->num = 0;
> +	return ret;
>  }
>  
>  static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused,

Acked-by: Balbir Singh <balbirs@nvidia.com>

Balbir
