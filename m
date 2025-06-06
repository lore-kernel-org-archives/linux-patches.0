Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325C1DE2AD
	for <patches@lists.linux.dev>; Fri,  6 Jun 2025 23:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254145; cv=fail; b=qKxZVF+WKiuTOeIu24WkNDs/x5objUBhvBdc1Aj7iJLCbIIvTf6E+4r6JOuWeiW5gahIAnx7pkrcYJcQ/gzFUg8+F6Nne8j2Nrw3Ts7sCdEpiYCIyXCticoR4vuzjDhaIklTDD/W9mNsnhiwzaXr2ZttWCM7fuqti3+3bm2GU2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254145; c=relaxed/simple;
	bh=Beqx6JGri22vqZt9xXKU23D1cBu6WEtHfDfh32P7/6E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GqajCt/EQ/LkZHOGB8BU/3HNYbvnQL/wTt9baCm9CaXStfD67SRGycHEzfigFIF3+rMHTdfmwafDSkuNAD96a1ckOHmRtnk4ahVyNE1Uom3zDdfugxXKdpwtpZBJ0XScHoM2exRMJ0PvZ5HKoxjtUrhOfoozUMgH5ivx36RZJw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BnG1yXok; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BnG1yXok"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpYQnK6hCwcOMq7Ab+gwDcr1DdRvpr9dBY7nFZjJMakrsWfNYkLc28wFXiOYgA+YBAzuYE3N6BMNGVEaC8VP6KxDiJUdEXWWCk0/tAi6ECepL5o3wJwRPuVjuBoHhAqLfvbyXWZGGBXca8x6rO74ycNCiJkJZq0uUPsbtDvL+JBMHym7JEZVMlyTW3deqafw/1Rl5k66Oloc4W4nPMXptjhhq4CKWjZiIhRuLXQ96PCNQbNa2/9/E82AYnkfPXoHQikgoMAZ07indrZaZa/Nwi3KrANXUe4c+wGYL5Vp8z5QNI6iXLcllLdXA6XjE70E6/EoezBtfMIpNpUmEg5kTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCCtb/t98C0E1bQzmNM8m9A2wY8GUqfxkYz6QwsRRTM=;
 b=njgnIdUTc1rzbuQ2uvug8EYn8EA8JMpIy+9QQsMk1HLvF5g51OEu1+Oin9CEv9tqdnqFaWZm9CSyuwUhltLhwawXYrLsuIiCEwABWJwnTJEuOG3Uh8ojdd7ZylHUN5vp9vBUriMXH1SEUGMfaZ+zsNHRGQG2e7ykbw52C7u1A5TxuN+Qwg5lv6bF++dortQ41KiqevwABhaO3YL434dDoJknWibUYhRoCLNLkNryE6mbOnFc4SNx7Mt1T/rWSoDrBHpzYnLtkRq8Ui3vrrocd5t20ZOu47W2+AawQV0iDLvDiX1l1f3QvyjKECqyjXHMG4UIWUUFDobn6MC7W1n2lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCCtb/t98C0E1bQzmNM8m9A2wY8GUqfxkYz6QwsRRTM=;
 b=BnG1yXokpJeuUdc2BbGl45RCvBi92RUD9OIg6r/Mm72g+jprue/LxR6iRYQcoZrl4LpNhdHx6DXacX4FlQ5Julv1qtrt8V9XmNI1fXsOxsQl13ABpMgNvYZoIj2goxuoqRhqfopBEp/ms99eNTBItFu527AnJa9fTb/MJl/vsz1Uo4etl03kDJnM8o5is6LQmuR7apff2rxEl8wrJBYNLSYnVg0LhZpIf5OazD6rKNRHNIKmvf7xEUe6cHqIoFjalS99ldd82vBAceZrmaOHaG6Ub+pjE/wxOYB5rmgG1ajMIfSVN5iaobDmHFTJvrAjk01HmSBWscST7ESNwtP/LA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 SN7PR12MB7249.namprd12.prod.outlook.com (2603:10b6:806:2a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Fri, 6 Jun
 2025 23:55:40 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8792.034; Fri, 6 Jun 2025
 23:55:39 +0000
Message-ID: <f963081e-9cbb-4d8e-b978-b6092394a330@nvidia.com>
Date: Fri, 6 Jun 2025 16:55:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/29] x86/resctrl: Add energy/perf choices to rdt boot
 option
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-25-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250521225049.132551-25-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:a03:331::19) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|SN7PR12MB7249:EE_
X-MS-Office365-Filtering-Correlation-Id: c1d6fc24-43d5-4011-53d1-08dda555a386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0hLZmowczVEYnpQUWs0clY5WG42VnhDRExLRVVNdWVUeGwvdDU5R1hDK2dY?=
 =?utf-8?B?aEhBcnpWQlhlQkl4MmV4anhrbjNjNXdIY1VCZHdabDVOTys2dzJLRnRyS1Vv?=
 =?utf-8?B?bHc2T0ZpN09GQy9qOGpsNUh0MFZqQlB5YVkyVzdmVGJ2ZldBc2VvT0FkKzIw?=
 =?utf-8?B?a09ETzIwUmxjOW1VdFFGZnlNRjJSWTRVK01qME9Odmx0ZW5BRy83Kzl4aEI2?=
 =?utf-8?B?V3c0Lzk1UDhsTmEzQS91R0pqMlhpbWdKOG8rQ2dPQ0k5ZWFPSlFZTmpjOGtz?=
 =?utf-8?B?NnFZQ3FrZW52T2FJdGhBcDFoUW1qZFpILzVlRzVveG1jdjErQ1hMaXN4UDQ1?=
 =?utf-8?B?S2ljQlAzNUF5ZHhFTlpwdGFJbTJUOC83VlBkd21SNFVXangwT2gyVUczdmpL?=
 =?utf-8?B?ZmhuV20rd283UlJCRXNTSGVXSitoUzFTaXNTOU1QM2toaDU1L0QyYVRFVklo?=
 =?utf-8?B?YzhVRjJiandOc1dqOHlOWmpFTkhZZkZHZ0s3S2RxdzlSRFhzQzRoVWxWNVp6?=
 =?utf-8?B?dndJNnllWCtOampKS1F0eVNTdXhrdXdTSFRlbCtWMEhzTGdrOHZJdVk1SWl4?=
 =?utf-8?B?eWQrTWdBdWV0WUoxQi9nNkFidnJhaE5vUmd4SjY5MFhMQnZWekFNY25SZ3Zu?=
 =?utf-8?B?WXdEK1RJdGZTelRaN0RVVktzcHlGRTNya2VFanM1cGQrNjhqeXFOcVI5SlBa?=
 =?utf-8?B?eStNVVJ6K29DelZudi9QN0pDUDYrb2ZEWXc1azcwTGZFeXV3dThIQmppaWMx?=
 =?utf-8?B?RFhNaFBHM0xQVWh2QThpTWJyNHh4RE1NSkFvTXg5c1hhWUNlNkFqRi9ja3Fa?=
 =?utf-8?B?aHMzS0RnVkhHYlJ2aXUrRnNSK3RVa0t4RENTMERuNERXL3dQbjRuRE5jeFdB?=
 =?utf-8?B?UXVTdmVocjFmc1pJbHhSOFdZUFhWOHJkWVJGT3d4UTUwL0NtaVJJc1F0UUtS?=
 =?utf-8?B?eUlxcmlDNWhpM0F1NmI5SjE0N2RBTzMyRTh5eTA3d0VvdVFNdnFWbnRvV3pz?=
 =?utf-8?B?aUdSZVN2cHNZdWlzUTZiTFNtazQ5eUJKNmJGV0Izb05QSy9jN1RuTVNiRFhl?=
 =?utf-8?B?VnYwdGVaU01LNWg2TzloTlNYb1Q2Wi8vR2FYcTFvNnBMRGVCUUk4S2s4NFM5?=
 =?utf-8?B?dDdMSlcwaFBmMEJqZWNlbjFEWDl1K2p6bklRWGl4Mk5CWWhRTWplZUthbDR4?=
 =?utf-8?B?QVgwMnJYeCtuaE9BRGJLaS9tR0tzMFZBMXdXUzRPZTRDZkdhTUJRZzFCODRQ?=
 =?utf-8?B?azNoRUE0ODM1MGJKSlNnSWdmMjN3UUh1Y1BRMzJQcmV3S0pjSzRudFhac0ho?=
 =?utf-8?B?bnhodzhZUTY5RU4yV3VZdXVXVDNZUjA4MlplWWk3Mm1WMUgxU05vZmhIRzBa?=
 =?utf-8?B?RVIwSGFVbnh5dUpETkFCWjRKUmovRjFDVnhkUFBMaEFRUDhaMXE0Y0pPQm5F?=
 =?utf-8?B?aGV0aDJRcG1Hb0I2Nm93cmlVTkw1TkU5YlV4MEFHT05GTGVPbm9USnpiMDNP?=
 =?utf-8?B?UytJcjlSTEk5MC95SWExeVlBS2FSVXVUcWJtMHlRRDgzb1ZCb1B2T0VDcnIv?=
 =?utf-8?B?bGtJQmRWUjFwTmNJR2FMSVVVS3ZvTEtDMmFRSWJpdExwMUwyWm5HQkZabmJ0?=
 =?utf-8?B?OUFPVFNmcThaWGZvMGY5RS9GbmJpWFFycGpOOVFmNU11SnBIQUtzODZCVElJ?=
 =?utf-8?B?cTR4V2NNK0NkMnBZVzl0MGhCS0pXKzVxcjVxdHJRTno5dDJVRmh2b0p1TFNm?=
 =?utf-8?B?bDlvQithQzdSUnA2QVB4RlA3dXhCdnc0RmFGUkxmWDI4YXR2c2xhcXVRbkN2?=
 =?utf-8?B?aDZlWWhpak53allNa3hWNFJic203c0k2QW0zTko2VmJVUFZXL1ZkL0FKNG41?=
 =?utf-8?B?QXlXckwxTkRqQktMcUMyUXZIU2VkRUZSMGlUTGxHUkJ1ZXdZNWRJclVZbGNa?=
 =?utf-8?B?RFoxNVFnL0hWSkNmLzgxdk5TaHM5ZXdFaWMwSmMvRytMU3FFVG1mYzB6TDRo?=
 =?utf-8?B?N0hUblhra1lnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFRNMjgwSFRrQm5JbUJ0a2FXZ2huUXoxclpscnZpRERmTDIzRW9HVE15RjZ0?=
 =?utf-8?B?c25sc1ZaZVdiM29ncm92bWp4cC9qK1FFbXdIT1BWOFFoYk9Fdm1XeS9rOExa?=
 =?utf-8?B?dE5vWjRjbTA2dE1pUWdKK24wQkZ3YWZETThCazJZUUxGRDBESm9PL0JCRXk1?=
 =?utf-8?B?alB4NnB6bEVnYndxVHk4RDVnbnF2clkyQ21JcmxPdjNCaDNxa2NJbUJ2dkto?=
 =?utf-8?B?TVJrdjBoeHpFS2VGZjZzWmdqTnVPcERpd012cE9YcW9tR3RZbE4xeXltM2k4?=
 =?utf-8?B?M3FhMURoUXhvT05pMWFmcjl1U2YxcXJXTk8xbFAwOUxLRmNON25Mcy9IN25M?=
 =?utf-8?B?NlpSNFdzRHFiWVdobkRVeWxud05FUmFwb1hvSGkwcExJQzFnOWpnekM4Z1ZZ?=
 =?utf-8?B?WXpDRUtEL0NYYUE4WVk5azlranJzcjhJTXFLcjM3YmZ3L2s3eDBZd3F3Z3pn?=
 =?utf-8?B?ZzNKa1MrajQrMkZnK043RlVvekJEN2t5RFFaMDFxT01CUW85cXM5RjcySDRY?=
 =?utf-8?B?cFl5UCtTSUVZSnJTTmxpc2h6VzlJMzVlTlRqVFlucnB6aXg4UGNrM2dPamgv?=
 =?utf-8?B?TGxXMVg4QWxUdG9TOUFLaGxaRnlaT2crb0ZUM0RVdjl2ZU5kM3lXWmorVGpu?=
 =?utf-8?B?N05qTDMvbWVBUDBxRTdGb1c3dmg5SzREOXdOUWJBbUZ2ZVNkMFluRlczb1Mx?=
 =?utf-8?B?RXF1SExYUjhkRXR6bGZqTVBlUVV3WHREYVhlUW1OT2g3ZmpDYWZyUUlHZldY?=
 =?utf-8?B?MEhlY3RTc2dTNXlwWk1hTTFLRFJWcVdia2MxN3daeVVHSzR0dlRMRU1KTHlG?=
 =?utf-8?B?OG45RFJxZ0JQVVdHNmtySU4wME1GL1lZNDhTTVBzZ2xwOC9YTVNnbnErMFc2?=
 =?utf-8?B?M04wVmNMNjZyUFFpdnN0dlp5NVA5S3NUTGhzK25WQmV1Y3NNUXhYUHU1a2ky?=
 =?utf-8?B?a0M2YnZVMG9PSzB4Q29Selo2QlRpMjJZMjB2ZmJtaTM2S3dCU2V6RWNlenJ3?=
 =?utf-8?B?cVVJZklLQWZCVW9EUnBiVlh4TUt5K2VrS054anN6TzVqLzZ3VTNuTVBieDFa?=
 =?utf-8?B?aW1zRW80T1B0TnB1bWMveWkwKzhqZ3E1d3B0WVBJNVk3c2dkSktYcTFxMWU2?=
 =?utf-8?B?VmFoWW1ZNEhLZHdZaFRPcUhqcU01NWJ5V1Q4L1hCb3EwdkN3V0lLd1ZBaCt0?=
 =?utf-8?B?VkVHejV1d3dzazFXUWYzbTQ1U0p5UG9LaHRwK2dqUUo5T3hrZEE1ekpZckRC?=
 =?utf-8?B?YTlZYWZxdG9tcDE3Q1JIbytaMnVxeXg3RWZJcVlUTTVsUTBEbk0wckQ1WDdU?=
 =?utf-8?B?eWlCKzErdXg2aVl1YnlEaXRnbENXbjhIeTZSVUJZRnRhOVR6c2ppZ0FreFB4?=
 =?utf-8?B?QmZhNlRuUzltZUlIQVdOcC93MHNDWVRmYk9pSnhxcmpuOTNGQ1JKNFUrSFY4?=
 =?utf-8?B?ZFJZRHFRUDYvZjhUeW41d0Q3QmhLZnBjb0dHdkN0VXljWEk0d1BZaWJXcVZE?=
 =?utf-8?B?Zy9saDJ2U2l1ZU1sQUZHWVlHbWtPK1N4Y0lpcGN4V0dZOW5MZGpRSnhFWDkv?=
 =?utf-8?B?RW03Q3VFQTRPSkVzTVBqUlVkOTBrWHVsR3VibDZxcW0zS21NV1ZVK2lpMjlm?=
 =?utf-8?B?VFl0blRQZDJIa2VGQmRwbVBZdVFURG44WTRQOTJEZjJYaHdFaVNSVERSSnlS?=
 =?utf-8?B?ZCtTRy8rdEc3a1hQa0pNQkZJUHNKVm92RjV3L1pRRmEwQVFGK3VUeXBqVjRV?=
 =?utf-8?B?UTRMTVhZQlVXU28ydElNaUlwNHZnSXk3aVArK0p0dDg0cUxZdHNnL1dJMEVM?=
 =?utf-8?B?bHFGQWFLT2RnTmlOSXkvMzF1YVU5QlhpREpnNGh5NXJjNGwxRjRCb1dyUUFE?=
 =?utf-8?B?QzBQQzVkK1VYUzFhdVRzb1kwTVozYzhLLzlZS0E1TG5qQ0ZyeDQ3azNSb3B5?=
 =?utf-8?B?c0FQZjc2ZlFMemorSkNzRG5QSWJ3Sks5ZzJSOVVuTGZsWnluSDg0bmtKRGFJ?=
 =?utf-8?B?bGkzMW1pN0R4WWxXdFBYTkFMaFhiTUhNblc1K0dFUCt4dDRXeTQzbk11OCtD?=
 =?utf-8?B?MVpGTDJOa09JNkI3NHNzc0g1ZXVCNzlkK1dOYURCaFFNa0lVMzgyclJUTHNW?=
 =?utf-8?Q?6D48Zrv/pNmUlIMR0fjkogbwm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d6fc24-43d5-4011-53d1-08dda555a386
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2025 23:55:39.3799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IyrbxAsDBBZMfQpIK25Lr/uv188NgZOvvuzpSL/Qr2lJ5BcGv0wwFvaqehBg6/LLWt9/uXvz+wVAtViUN16xPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7249

Hi, Tony,

On 5/21/25 15:50, Tony Luck wrote:
> Users may want to force either of the telemetry features on
> (in the case where they are disabled due to erratum) or off
> (in the case that a limited number of RMIDs for a telemetry
> feature reduces the number of monitor groups that can be
> created.)
>
> Unlike other options that are tied to X86_FEATURE_* flags,
> these must be queried by name. Add a function to do that.
>
> Add checks for users who forced either feature off.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   .../admin-guide/kernel-parameters.txt         |  2 +-
>   arch/x86/kernel/cpu/resctrl/internal.h        |  4 +++
>   arch/x86/kernel/cpu/resctrl/core.c            | 28 +++++++++++++++++++
>   arch/x86/kernel/cpu/resctrl/intel_aet.c       |  6 ++++
>   4 files changed, 39 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index d9fd26b95b34..4811bc812f0f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5988,7 +5988,7 @@
>   	rdt=		[HW,X86,RDT]
>   			Turn on/off individual RDT features. List is:
>   			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
> -			mba, smba, bmec.
> +			mba, smba, bmec, energy, perf.
>   			E.g. to turn on cmt and turn off mba use:
>   				rdt=cmt,!mba
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 42da0a222c7c..524f3c183900 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -167,6 +167,10 @@ void __init intel_rdt_mbm_apply_quirk(void);
>   
>   void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>   
> +bool rdt_is_option_force_enabled(char *option);
> +
> +bool rdt_is_option_force_disabled(char *option);
> +
>   bool intel_aet_get_events(void);
>   void __exit intel_aet_exit(void);
>   int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index f07f5b58639a..b23309566500 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -797,6 +797,8 @@ enum {
>   	RDT_FLAG_MBA,
>   	RDT_FLAG_SMBA,
>   	RDT_FLAG_BMEC,
> +	RDT_FLAG_ENERGY,
> +	RDT_FLAG_PERF,
>   };
>   
>   #define RDT_OPT(idx, n, f)	\
> @@ -822,6 +824,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
>   	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
>   	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
>   	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
> +	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
> +	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),

Boot options "energy" and "perf" are PMT event groups level. Other boot 
options are individual event level.

E.g. "!perf" forces off all 7 PMT PERF events.

e.g. "uops retired" event has an erratum but all other PERF events work 
fine. Disabling "perf" group disables all PERF events. Is "!perf" a 
useful boot option?

Is there any consideration to have boot options at PMT event group level 
instead of individual PMT event level like legacy events?

[SNIP]

Thanks.

-Fenghua

