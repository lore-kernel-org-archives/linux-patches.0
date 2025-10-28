Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010058.outbound.protection.outlook.com [40.93.198.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB3D2C21F2
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 16:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761667345; cv=fail; b=jaAjN/hL6H9nKfIy0EBnZcYjqXDgJGL1sj4Zoc72kbvMZiUYhuo9mMZLA7Q/1lcsfK3WaOkS3kmeRMXp32MXL+60rdPXywDdCMdeduHSSzkBIYJfvvXRcYlDBWugwoHdtHcv0iwIxIvbT0Oup/44nPf+rPD/u77fpLVrrqO6AFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761667345; c=relaxed/simple;
	bh=sqNqJc52T6iSaq4//Tm2pYsALVCDyVlb4EngOqR6nEs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=niB/qYVuQ5qlYPQWKlkfCIXxQZ28HhMk9eR0GNuLSGfvyQ0GISINFEojyirw+LFl3ZAfRpJ48DmlRhycg50v+1aBc2DJ/0STzcjXj70CBQih3EExi575JYF57J1ttbCeuTvEwvToVzJ1zyle5O2hmRkl53OcacA8h3TUe6ocspA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qYz6ipsc; arc=fail smtp.client-ip=40.93.198.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qYz6ipsc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=te3g83s6C8I1XkTt3vRwIW6xcbaiXe4UKJp7Jmu2cW2v8AeONmk/cCY5hfIZn7JNinKBnGr3GSgJgXgm8YTStVjPMGS9vvDMmt6NYHKrW6s89QcUMfCyCTskg2qHvdiaAJRkKYxw49Utkd18evZhHm/HyxMUiITzd5PmrTZIZMcGAVjzbZ0DIFrwccu2im+KwtjGbOyO32RS8bPmK7xxZ5Yf7TUP06/1vau5nPBLSR9I+kM0f52Xx2KBjwcWcHSxxNkAWGnDALL1go4GPne+ERLumr+g1f3/BxxNMxQZbhGCsqlFErL6+CFIIOuGxNYVRtaTX6+/Z93gtdh5qKcCfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqePOJRpIeyIc28Ox2D3xpNyYaVWo14scK51BZJZgqY=;
 b=c4JmkipWKIB1r/CfZsfQCYoAp8HYjd3MZYLV2YWbMkTdEBqnaVC+G8VF9kMla/oKBSoRfS0BQzMRVGD9jE8HQnURe80Unjg1aEDoBUdFfuvzeOfwt6lDcTNKnU0BdnpwGk4UXzquJygup33bN67CYzkJmU6YE2OxEM57mwZp7TmfvJ4gJxRUccmGjeHnbHFbNQ2lOiM1kbGVV3mMHhyYhbXI6VDnGlhyHxL3t1I6/lAQ7MhVyqmIkuF+I2/wAIL/xJl/E/dhZ+tUkWj1dXIBULw8ifEdiVZlAOz6RmZE+IWSL7Xf1xLONG+uYrqC/w6zH9I8b2t6X4FiUbq4v1FnOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqePOJRpIeyIc28Ox2D3xpNyYaVWo14scK51BZJZgqY=;
 b=qYz6ipscA2jAmBijfBobZ8vT6vx5KnJqLHZVr+Z3pTYF/nlq/fKZfDTFR/s2qalN2uCau3TogWRgwrOu/t8fHp6goT2KOF5DIuw2IgHXo5hI6RsqoL4wzW0rTEBtsiGcyut8kaYn8w9lKiu/OTZCi9BKKN3eQ3fLSYzu7b/XpLM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by BN5PR12MB9463.namprd12.prod.outlook.com
 (2603:10b6:408:2a9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 16:02:15 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 16:02:15 +0000
Message-ID: <35885923-f617-4994-8fa0-d5c042238c15@amd.com>
Date: Tue, 28 Oct 2025 11:02:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 151/157] x86/resctrl: Fix miscount of bandwidth event
 when reactivating previously unavailable RMID
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Babu Moger <babu.moger@amd.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Reinette Chatre <reinette.chatre@intel.com>
References: <20251027183501.227243846@linuxfoundation.org>
 <20251027183505.344460318@linuxfoundation.org>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <20251027183505.344460318@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::12) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|BN5PR12MB9463:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a200741-6e46-4357-ae1b-08de163b5cf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXZ1RkV6YVlIcy80VWVTbVd2OXc4bDd4Mjk0cVppMDdWWGFDbFAyRzFqazBj?=
 =?utf-8?B?ejRzR2Z2NGg5YkxPZlhNMi9IdEQ5cjB5MnlFYlhlR1UrNjcrRDdzQURSaFdO?=
 =?utf-8?B?ekJvNzBFSUJFUDFVNEVpWHZrQWUyKytRSG13b3NLbkFXc0tzT2EwQkVSbGVj?=
 =?utf-8?B?YUdDQjRvb1dLMDhhQjlKSXFlWlFPRm5zNmtwRHlqS2RQbUtwRC9DOE5mK3VY?=
 =?utf-8?B?bjJDTUcyeDNZWXZIWlo4aFdXNk9kRmxVQS8yUUU1bU5oOUlqTE5lTEtCVjNh?=
 =?utf-8?B?SjcyLzhMRlZ5QVVhczBMeVJVR1NodW40Q1NkZ3o2cThFeGlqNGtOUzh4NzM3?=
 =?utf-8?B?KzRkMnRwdElMSG5OYkIwV3EzZ1dkaEdrUDNBK0UvVm9qL1ZjbiszY0NLNkdx?=
 =?utf-8?B?Yjl1TXlQMXAvNUpISUFvWjNpcWgwTy8zcjBpTlIrTXlOLzVmZXJPeVBXcjE0?=
 =?utf-8?B?SDVoTFVkelc0NndMcDNDQ0VnM0lSYUZEYXJuWXVKUUQ5SkdyQkROYmlKZldL?=
 =?utf-8?B?S2FEMmloSjR6a3gwMG1aTnJ1R3RvOEpBOTBpc3ppZzVOZERRMEgxZlRlbVFV?=
 =?utf-8?B?aDZmQVBqOWdmcXhqSHJ1VlhrMGNlU2FVVE5yUFBjTU5Lb3RNWTh3bDBFRll2?=
 =?utf-8?B?bm9rOW5XcEsya0JFam9iV0tMb1BzK0hlVG9ncTlIK1V6bGQyN2RlRHF1U0d3?=
 =?utf-8?B?UzFVcGhUc0N0V2ZFZS9NZHplMXdVR2NhUU1QLzNnZE80VkhSL0RZUzY4Rmo4?=
 =?utf-8?B?WWs2M3NaNUh1NzNrc0JpWEEvNXEycmlSL3dWMjVwRkFyRTRsdjBUSFF0SE03?=
 =?utf-8?B?ZHQzVkdvWnlVeGtNbXR3eUZvT2k1OS9oanJWRVpmZ3NUWU8ySnpCd1lGeXhm?=
 =?utf-8?B?Y0NRN1drQW5NSStqb3JxVjA5emJZalpyZEhleEV3NnJGNGF6RXR4aUE2Z3cv?=
 =?utf-8?B?R2lrWUJOOGZUOHloSWZtZkhYa0pkWFU4WVRrb3FXbU1uNVgvVVQvSmxuMlJR?=
 =?utf-8?B?Y1RubXUrbkpRUFhBbnZJSGVETlhHRDE5S3lOcWQyMVR2ekNVTEhBeUZURjVR?=
 =?utf-8?B?bGhrRGJKOFpYbEZrR0FJRVA5dFdpTHUyNUh0REprV3ZpTkxnSHBRTm03MENu?=
 =?utf-8?B?ZlM1YUNTTTZzbmRTOG5lbWNFSlI1UExtMkV4d1dBVWdqdlZBM1VTSE9BNkNw?=
 =?utf-8?B?RTByOU5jNWRNSXUxOU92OVZ5S0s1V0pvalhGUUpUckplZnphUDhIajRXd25Z?=
 =?utf-8?B?MDVGejdJVDVjSVJhaEN1SHVXajcrN0R1YTZiNlZJaVpONGZieGdwMVFQUlZr?=
 =?utf-8?B?NFFhY0ZzUDlWa0ZSaU5scVBxUk94R24zY3RrM1RtWmprdldtWmpYVlhoT2JL?=
 =?utf-8?B?clpSUkdXOFhlUDBpRWZUTE1lcUtnV09vS2t4NExKYVd2Q2pxRVJDWmFGSDNh?=
 =?utf-8?B?djJKWlM3dEh2Wk9LVnY0Y08reFdJbWFESTNSMFpySyt4V1ROVFNRbVJ1OU1n?=
 =?utf-8?B?eXhSVThIT01mYWVDVjREaTVldUFjbjhRUFVsVCs1SGVhL1o4cGo3VXptMHNN?=
 =?utf-8?B?NDlzUGVTOEFDZzlvZ1dVUlJ6bExid2h5a0VVQ1ZqMURxYUZpSHVORldmdXB6?=
 =?utf-8?B?VUVEWDZZWHlKUnJ4ZHQ1eTZ6a21GQWdhM2R6TkZnVXAwWjlYOGF6bWZZRHFN?=
 =?utf-8?B?eHo1aytTaElhcTBYOUluVXZKUFRqOTdaSUNnbEFmc3BYMWV0ZUZzNVpwRHMv?=
 =?utf-8?B?NUNUZVpTM1NVMFZ1T05RVml3RjYwQ01NSzRIOW9DQU5uelVkc3duaUdkT3Y4?=
 =?utf-8?B?V1QyUW5HYlJ3dzAvMVJEQkJ3blh1WVRpYnAxWGM3N3lDbVc3MkZFOUVzTjhk?=
 =?utf-8?B?dGNDTG9Oa29mdXdqSnBzTWc4VGtmN2JpL1FUZGtvQ2hTQm1nRHVVRXZXUUNI?=
 =?utf-8?B?Ujk0dXBYS3EzWWVwUTFOR2pjV2g0Z3JVSEdJR2l1U1dkVHpDVjYzaUJQV3hk?=
 =?utf-8?B?N0YrRUpwejJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTFGQm5uKzFQMStNazJjOVppTDZaZ21jRk0vdm41ais0OEZpeUp1VjlKZTYw?=
 =?utf-8?B?VWEydTZlZG5sZWYvWGxrMWloYkxXUmNyZFNiNjZrczRuMGR4aHAwdC9QQjNS?=
 =?utf-8?B?UENvT3NCSFBSb0tyRTkwSnFJOU9GMDM1WDNXVnBwTlBIMWh2ZFBTa1pMWWFK?=
 =?utf-8?B?cnlCNGp5S29xbWhGUUk5U0h3ZnlTeWtDajVXb1NNWjM3Rlg4MERIVGx6Z25z?=
 =?utf-8?B?MTIvcndyRUFtemQ4MzRKSHlDMjZxWEpEWGxkbDFKU1JRbG5hb3lPVHppZENr?=
 =?utf-8?B?alVSVWM4QloxUWN6bVNjNXNpc0pFQlFianZuR3VlR2hrQ254NE9mWDBnU2ZO?=
 =?utf-8?B?UjAvNHdxQmFPcExJQnZkOEZUMGtnZkoyV210bUpjUkRodkpCSjVOUDlPak9R?=
 =?utf-8?B?YXJYQzFEWlRoaHdUa2h4QzE3K2pVR3JONXhQK1lBLzZINW1zbG5ZSFdGbmM5?=
 =?utf-8?B?NStzUk9WTmRPdmlHOGpYM1c1NG9OeTgrdXErN0lFd1NBbkd4cUZPeFhmcjh5?=
 =?utf-8?B?U2FmZHlnOFYwbk5iOGtETzFRTnhtMzlXNWFSNHFzUStnRU45YXR2MDdBZEZX?=
 =?utf-8?B?cWpvc016b3pja1pQN2EweCs2a3N3U0xJODdpcGZFMFZhK3lSOEZ2cEtoQzFI?=
 =?utf-8?B?YWJSTERCY3JnMHFJbnJhODgyZ1BOWTQxcmdJUy9OQmdhNDAweE5DVUFiRGx3?=
 =?utf-8?B?SnB6RUh6ZWZlZXhlL2RRaEFsbFBSVUIzRCtWcStCWGlnUUxXVVBwYThXUkxB?=
 =?utf-8?B?eWRyMU82aUZldVpDUnZlWDhkbldUUmFUelptdi9iaEZGSzNEaldwK1ZFY1BB?=
 =?utf-8?B?VnlDaTh1Qk1TYmI1ZCtucDNJdFl4VmF1VTcwWndoeElhcWtUQnIwRmNPM0Rq?=
 =?utf-8?B?RFo3c1NHZnF0THdJVi81R0cvUmd4eDEvODlPcUJ1THdBMVBNYTEveTMrSlNt?=
 =?utf-8?B?ZDgvczVuZ1lmUXhnTVoxYlVPbklCS1YvZnFWN29yWXZTUkx3QkwyVmZPdXNq?=
 =?utf-8?B?VzdYdUdOTXhtTitKR3FhQ3ZjeklraHhyWlJnc3VLMjZpbDZvejE5UDJ1UE5u?=
 =?utf-8?B?ZkFESXNHSE9NbVRqUTdhbUwvQUVTVDAwY2hWdFZDRmFaVHREY2ttYWUrK1Bv?=
 =?utf-8?B?QnZzUVE4eVluSkROczhYNVFEamIzaktZOGY0STg4OEdob3lDUmtqSDFaZVRk?=
 =?utf-8?B?ZXpBWVhvQVZ0QzZTdzVNUFlzMEZSQTYveWhjZ1JnK0ZFei9keE9qYVJvWFdB?=
 =?utf-8?B?VGhzWXl5REtEZjhnSUhwN0pURGFvck1ESzg2NTNuOXF5VlNaa0xrZnFhRTh2?=
 =?utf-8?B?TGF5b1QveCswQmROSUJrVHZwT1p3SlFqNUo4bHdPZnhHMmo4MDNIUHI1MXA5?=
 =?utf-8?B?TTBiS2VBUG9ZYVFrakZLK294bW5nV3lYeTRYL2dFd0RsNENwTzZsdldtYm5D?=
 =?utf-8?B?amhQZUFCdit6TkVuM3M2TDZNaThjOXJ1Vnl3ZW11a1BKdHFnR2p5VURCRm5L?=
 =?utf-8?B?WWhOcnh3YVU3RnBJOG1LNFFPcHVGaUp4dnZLVFhBM3RUVE5ib1VLSjZvbGxO?=
 =?utf-8?B?WFR3eDNkdytpblNvSk5IUy9adzBLaVlzQXNYbTF5dTVmNCtHMVJlWFBxellW?=
 =?utf-8?B?Wm1QYThpZDM0SFhIMU9ncWdNL3dwdEtaazV2TDJkZlQzZmRFcS8vU1RGd3hG?=
 =?utf-8?B?TTZ1U2twb1czTnVtYTBoWVhsUENqY2RPTkF2NkZEaGw3WHA1aWlwbEc1V0hC?=
 =?utf-8?B?SXZiZGk0Yk04OElqVXJKUzgyaEM5eDFvQWMvRmVJY2FyaWE3NGRxeHdxNlJq?=
 =?utf-8?B?YkYvcVpXSktnTHJRenpxSU4rTDBrZk82ZXU5Wnpvd243SGh0MTRZTFVXT2Ns?=
 =?utf-8?B?bDZWMk50YXlaQ1RBZnlLaE1WQlpPanNGSjNVcnFkWEN0TnRxR0RzOWhJQ2NS?=
 =?utf-8?B?Rkp2RzdoaDBaSHZIdzZjaXRWYnNlaWgwTDgyVWpWMzYxY2J1SitFQm5DeGFQ?=
 =?utf-8?B?MEdMcVc1MDBmZVF0YytXVFZibGFmZ1NPNG1vZC9udWdDM1BZcDZNMndUVVhO?=
 =?utf-8?B?c2hGL3dqcW5rR0lSTGMrMEU0dE5hRExsVnpGZ3Z4TUZkVEtFeTg0TVRERWlX?=
 =?utf-8?Q?HHQ0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a200741-6e46-4357-ae1b-08de163b5cf1
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:02:15.4841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXId12FGIKtqn2KOqULXKKwOeewuWC/acQksCDwfpGnkRnK0xVAAbqreE1jk2Tl7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9463


On 10/27/25 13:36, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Babu Moger <babu.moger@amd.com>
>
> [ Upstream commit 15292f1b4c55a3a7c940dbcb6cb8793871ed3d92 ]
>
> Users can create as many monitoring groups as the number of RMIDs supported
> by the hardware. However, on AMD systems, only a limited number of RMIDs
> are guaranteed to be actively tracked by the hardware. RMIDs that exceed
> this limit are placed in an "Unavailable" state.
>
> When a bandwidth counter is read for such an RMID, the hardware sets
> MSR_IA32_QM_CTR.Unavailable (bit 62). When such an RMID starts being tracked
> again the hardware counter is reset to zero. MSR_IA32_QM_CTR.Unavailable
> remains set on first read after tracking re-starts and is clear on all
> subsequent reads as long as the RMID is tracked.
>
> resctrl miscounts the bandwidth events after an RMID transitions from the
> "Unavailable" state back to being tracked. This happens because when the
> hardware starts counting again after resetting the counter to zero, resctrl
> in turn compares the new count against the counter value stored from the
> previous time the RMID was tracked.
>
> This results in resctrl computing an event value that is either undercounting
> (when new counter is more than stored counter) or a mistaken overflow (when
> new counter is less than stored counter).
>
> Reset the stored value (arch_mbm_state::prev_msr) of MSR_IA32_QM_CTR to
> zero whenever the RMID is in the "Unavailable" state to ensure accurate
> counting after the RMID resets to zero when it starts to be tracked again.
>
> Example scenario that results in mistaken overflow
> ==================================================
> 1. The resctrl filesystem is mounted, and a task is assigned to a
>     monitoring group.
>
>     $mount -t resctrl resctrl /sys/fs/resctrl
>     $mkdir /sys/fs/resctrl/mon_groups/test1/
>     $echo 1234 > /sys/fs/resctrl/mon_groups/test1/tasks
>
>     $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>     21323            <- Total bytes on domain 0
>     "Unavailable"    <- Total bytes on domain 1
>
>     Task is running on domain 0. Counter on domain 1 is "Unavailable".
>
> 2. The task runs on domain 0 for a while and then moves to domain 1. The
>     counter starts incrementing on domain 1.
>
>     $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>     7345357          <- Total bytes on domain 0
>     4545             <- Total bytes on domain 1
>
> 3. At some point, the RMID in domain 0 transitions to the "Unavailable"
>     state because the task is no longer executing in that domain.
>
>     $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>     "Unavailable"    <- Total bytes on domain 0
>     434341           <- Total bytes on domain 1
>
> 4.  Since the task continues to migrate between domains, it may eventually
>      return to domain 0.
>
>      $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>      17592178699059  <- Overflow on domain 0
>      3232332         <- Total bytes on domain 1
>
> In this case, the RMID on domain 0 transitions from "Unavailable" state to
> active state. The hardware sets MSR_IA32_QM_CTR.Unavailable (bit 62) when
> the counter is read and begins tracking the RMID counting from 0.
>
> Subsequent reads succeed but return a value smaller than the previously
> saved MSR value (7345357). Consequently, the resctrl's overflow logic is
> triggered, it compares the previous value (7345357) with the new, smaller
> value and incorrectly interprets this as a counter overflow, adding a large
> delta.
>
> In reality, this is a false positive: the counter did not overflow but was
> simply reset when the RMID transitioned from "Unavailable" back to active
> state.
>
> Here is the text from APM [1] available from [2].
>
> "In PQOS Version 2.0 or higher, the MBM hardware will set the U bit on the
> first QM_CTR read when it begins tracking an RMID that it was not
> previously tracking. The U bit will be zero for all subsequent reads from
> that RMID while it is still tracked by the hardware. Therefore, a QM_CTR
> read with the U bit set when that RMID is in use by a processor can be
> considered 0 when calculating the difference with a subsequent read."
>
> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
>      Publication # 24593 Revision 3.41 section 19.3.3 Monitoring L3 Memory
>      Bandwidth (MBM).
>
>    [ bp: Split commit message into smaller paragraph chunks for better
>      consumption. ]
>
> Fixes: 4d05bf71f157d ("x86/resctrl: Introduce AMD QOS feature")
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Reinette Chatre <reinette.chatre@intel.com>
> Cc: stable@vger.kernel.org # needs adjustments for <= v6.17
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
> (cherry picked from commit 15292f1b4c55a3a7c940dbcb6cb8793871ed3d92)
> [babu.moger@amd.com: Fix conflict for v6.1 stable]
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Tested-by: Babu Moger <babu.moger@amd.com>

Thanks

Babu Moger


