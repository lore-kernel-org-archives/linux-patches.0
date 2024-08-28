Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3861076034;
	Wed, 28 Aug 2024 06:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724826163; cv=fail; b=ev6ye8KuBy+UQpj4efc8I7ijzljzQW3USldef3Yq3/2TQM1dK9Z5UVKQgd1y4uDAOcLJLUvqTylzAuvFDNxyc0Umd7jO7m8yJL73d6XvlmmvYx/mOCrpIA5CYsU1Aoozip6wRGP6m8CfBz7g1L8cK9JSZ6eB4YzRuThqPB2dPJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724826163; c=relaxed/simple;
	bh=CeacM9sT24O/ckiYtgU0/W3gVxiMqiUlM3yuFzx19i0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BOQKPHObFdrpGeU5WuGqBAH91hFtYm1MyGawShfmeAgpDgrQ/DYITidhHRGGJVo7FdxcW3XfZh4i33FYckICYK1RoRMi6uHCB5ci3t41v/P310m05L1wTFKNcjcVJFdRZ2smwmI7m6t1AG9B42i0yZnTcRtyFnK20r3BJUz33Kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WNUmQ5ny; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WNUmQ5ny"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pn7o2g0jqGsqjKjvfvF6vqM9ZsdkhSBP+vHmc+sbfbXkj/x5Xs+Ayr9fktHu6tTiLsbt9X/llY7hPkEitqhKyanX4YQKFDuvxz7Y3/cKozwuA6NvTLv1LWaSMELdkkwOPzwWoBhVl2jm46HTQFWUzVRkPR8rQ4N75nYGTw4P1q4BlkIujZQ9wCeM/qCrmHe06mmT/PHpyExLfhg1zqQxjmLInqn1YobN5K3kz1lV2RFK0VupdW1m5vTxQPycLv7J2p9jWLIMVfC7ZOiMMDh5yxx+f1OgR119ldRfFiwp1pKJMdHIJcbQO0lGZB/OM4DZ4CYwF8ljbMHDzhwkhaOx7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjdZyo0i2n17LSJcLxo5N2MHcIAf8+CPnJ3PNVL3xYg=;
 b=Qh0kEoGmKzWSngi7EsP55wBtFnuWUI3zdYohZWuZyC9aAiMoSN3iEazN6W7ud497c7V7+Xk0NV9GRY3JfFcUzPccChIY1IC++kd4aM6RcqE9PzrqP+UuZjwEol8ER1XV9hJ79EpDgmdi4PIBuwEbgjJ4hC/aHg/AwGJiOj1oPs40SZyJiu7S3C6hFv1d81i9uaoYviXHz/zENR6Ag5cvsQEFKgT7jk0V/rjXQQZ53Q5OAa4MkBGYwz4TwVuFGXTBInNJgw8o6idO90619BsMqz5d0iay2lT/07mhQSYlWYAErHgpYgQBwmvmFULY/IGAOnIEW7TBCULIRYdj0QPldg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjdZyo0i2n17LSJcLxo5N2MHcIAf8+CPnJ3PNVL3xYg=;
 b=WNUmQ5nyCPBw1z3pENG0mxdWqiLZAguwjZmz5NR8gpq0DTNN4aSi9DA+k5Kjs+jl5gnxVe8bMZkwVisvAR45A6aUEYccf2hsIGCxWaBFFwLDE9p/W5lIJcMgdDFmTLCdEkwAXZqYJ9jRtJGIPc5LXo53acTkfK1y6b65hqZse2w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Wed, 28 Aug
 2024 06:22:37 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:22:37 +0000
Message-ID: <51315d97-97fd-48fb-8410-d80c55b4b5ce@amd.com>
Date: Wed, 28 Aug 2024 11:52:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] iommu/amd: Move allocation of the top table into
 v1_alloc_pgtable
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <1-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <1-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0206.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::17) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: 918fce0a-ed8e-4031-9a81-08dcc729cfbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0Z1bVExdjZhSHhUNVJCMWZ6TzdBOWtyRUY3enUvdmt1bUEvbktMQkh0d2E2?=
 =?utf-8?B?dnc1NHdqU3ExTXZKeklITUhVcjg4RU5UdzVRREJlRUtza3VoQW1hWmM5eVFo?=
 =?utf-8?B?aFk4S0RiNUpvb0pTRTQzempyOUo5MzRHT0pGVkdpZHlCWGNvNkR6N2pURzlt?=
 =?utf-8?B?OU5zaU9DRUprTFREek9KNDBhQnFkMXRNckZOWXpRVEhWaW1RWGcvd2dnZEta?=
 =?utf-8?B?SjBMbHZ3SjFZSTBjZkR3WTlGZVdPQmgyNFVoV1BrZUkrdUI3Y1JtVnZaZzJr?=
 =?utf-8?B?MVZ3OXdRdS83d095VG5RclNxRlB1VzgzK1RTWVZJaTVQUTMvaXMwL3NLVFhD?=
 =?utf-8?B?eHRJREtKQUh2VXZtSDdzdjcxb1FEQmUyVXVkdVdmVTBkaDRNeHpma2pTbHVV?=
 =?utf-8?B?bUxZQlVLTWtIb0lWTm4zYXJRd1AxdkR1R3JCRGFLK1ZPTnZOSmxtb2dJSDNE?=
 =?utf-8?B?TkJhZmp3aWh6WXJzclMxUDBKT3M1cnlIR2dBL3h6alVnSnF5cVBmK3ExVWc3?=
 =?utf-8?B?aDR1dkx2ZldBenBOOXR4dTQ3SmJPTWl2Z2dVM3paaEsvbmxyMnE4Q2JEMWdV?=
 =?utf-8?B?ZDFQcmd1c1hMMnZqalVpYlhXK21WTlE2U3ZJWW5nNmRPVFJpT2orREY0cW5u?=
 =?utf-8?B?MDJmUWJjVjVKRnFUaklVUVVra0picjJUOGdyWWY5Q015YVlLaDB6TFpyZEMr?=
 =?utf-8?B?RWZMeDlBOTd2Q0loY0Z1RXBMWjBGaTc4UlBKMk5RckxXb2Jnb1QveUhaU1ZS?=
 =?utf-8?B?TmFqbndNQ0Iwdzh6WkkwWGxEeDFpOTdEZEhwOHFKSEVVTkFzeXMyczBvWEJa?=
 =?utf-8?B?QUxBMmpOVG1OckRnb2F4bEY3a2xQQzlFdlBoSWEvdFU2WmRIUUdsUXNmSTEy?=
 =?utf-8?B?NERqMHh4NXVhQ0lxVHJzZkU0UkJ3YmFTUkxBU04wbHZaK1NsbTBRaWoxR3Fo?=
 =?utf-8?B?b0ZZTitRZktBaWRFWTZkS29DMXpMRmF3YnRRTnE4WmE2UzMwNTZlelN1V3Vw?=
 =?utf-8?B?VHpvTFRIVERuR3UyOGY1Nm1DdUZsMFAyb3dMRzZrSmFQQkdQTmlSSVVLSWZi?=
 =?utf-8?B?ZDRNL0NRa2VVbWdtdm1LNm9UeEFBeU9TbHFIMjlCaVJEMFRlT3p1L0hlT1ZM?=
 =?utf-8?B?Z3hyQ3JQTzAwdWNIYVNDL0FNQmwzWHFrL2orVjB4MWsvNnNyTmhMR0hzaWxz?=
 =?utf-8?B?ZjNLMUhNNmRROFdpejNaU3Z6TUVvY3dZelQ1YlkySzBaUVZFOVgwVUZCUmc3?=
 =?utf-8?B?WTBzZUdhbnhnUWFiYjFhZlFWY0RjZklPcWlweXV2cEhGQWRwRGErUWhPUHFD?=
 =?utf-8?B?eDZ3WjlXTEtYeVJjclIzUEJ0eEpQUFVFeENCOGdwYnA0amp6eGpzWXd1cFhl?=
 =?utf-8?B?QkZ2UFlISHkrNXo2Z2E0SjRtamZMS1krbDAyRWR4VXd4a3N2UkZhV1JNMjZH?=
 =?utf-8?B?OSs3SVorTTYvTllPampiWlV5c3lQajBRT0dERjFUdG1jajVkaDZTZkRJS3dM?=
 =?utf-8?B?U20zZzRwK3pKK1hJNmpneFBhcnRWNmxlZmtlZElUckUrNzlNdXNLUG4vb3Fo?=
 =?utf-8?B?c0hnSTIxZEN5b1ZYREhpMnAvWnZXN1FCVjUrZ3BYQ283elJ6NzZJc1Brcy80?=
 =?utf-8?B?L3BlTXhvZEVLYVVOUS9KL0RhSHV0QTJuNkpFUjZ5MFFUWU1IQ1doR3ovWWJZ?=
 =?utf-8?B?dkdnVHZENm16ZE0rRVE3MVl4REFhVjNKU3FkaW41eW9ZTVVCZldESUhrZkhS?=
 =?utf-8?B?YXdtTlUybUFuZ2VQOVFlOS9tL09VdUxKd05EU1lGZVgxYVZFTGRhSU1ZbmVj?=
 =?utf-8?B?cTF0UlljcFRVTUZZOEhCdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1duaHpEcDZMdGJmOWQrUTA5alVrSitkcUV2U2RGOWJsL2IxWGl1MVhxd1BO?=
 =?utf-8?B?NnJlZGRYemxhTUF2SEtRald1TEFOcCtIWTJqUVZVUjlKbEFRZmtpTC9RVkxP?=
 =?utf-8?B?SUpEREdXMW5xZnhMeDg0M2dHcWNrZ2lTWG53bzNoZ0FKL29VTDZZM2c1a3JT?=
 =?utf-8?B?emFaZTlraDVvOU16SUZMOG11R0ZMeEpHUzVtbGovOXp6bGYrVGFIa3RhU3pR?=
 =?utf-8?B?ZDJ5TmFiWjc0VDVsditqRXFpRmVxUkN3eVVjcndUMEt4U1pnaktJbXRGZkZ5?=
 =?utf-8?B?a0dWZ0t2cXl1SFBkaTMwRnlZTTdEMFAyemk4V1plckxESTVGdXZLZDlPbWdT?=
 =?utf-8?B?YTNuanpEY1lNOE5PQmp2QVJrdldYQlN4dmxJU01yVFVxY0pMN2hSTzQ4bUs5?=
 =?utf-8?B?TUM3OFhEeEl3ZzFPQmdFT1VRbi9SMDVhWFdPanNxdDZ3RGVkQ0lCRkhFQ3V3?=
 =?utf-8?B?WFJFSW5TL0lNbDA3NlVFTHNsZGFjU2s0WXBRR3k0MEhLQkdtdS9iQ3QzbVdU?=
 =?utf-8?B?dmZ4NnVvVVlaRWhlNlF5dGFOODRackU4R0pMVXhTMnlwL0JpNWE2K2FnU3hi?=
 =?utf-8?B?ZjU1dzVPMmJpVVRZMTBPaUZubFNEelkwcFJ2RE1JSVIrMDZMbWhENURKN1ZI?=
 =?utf-8?B?RlEwclc3UXo1QW4yaGZKbE9Kdy9VZjdVenhMek4zOW9zcG1na3pSa2ZTREo1?=
 =?utf-8?B?Q0h6emVKR096eExZSDNLNGk5eWVRQmFIbndqSGlBSXdNL1hWdDV0RzJvOWpH?=
 =?utf-8?B?UlRhb0Y2bmFCL1BmQlpvbStMWUxNVnI0Nkd4a2laU2RGbHFjMEJFK2tRUnRx?=
 =?utf-8?B?UW9TeDZXMFhzWnRMTHVBNVNKQXlUYkNGa1RzazVveWxrZlJQaitNOUc4QWpm?=
 =?utf-8?B?ODlBWUVtYlVZbmhLM0Via3BxUWZoUTlydVVGTlRlM2xSRTZYcVZXNzByY01F?=
 =?utf-8?B?NGI3TVVYWnRtdlE4OVFqVG1KZ3UraldzMzBCMzZlWTc3SmZaeklnSmc3bG9G?=
 =?utf-8?B?eEsxM0s4eFN6cFYyaGVxdm50WVFLbW9GRFJiVitPc2ZRWDdCV1l3eWh5a3JD?=
 =?utf-8?B?L3lhc2JZMnhRUlhTdXdWMEl1bkpXSG9zdFAyQWMxc25WVnljRkpObURqRmRn?=
 =?utf-8?B?YlZZRmRHWFJMa2hQQ1VhQWE5dFducno3b0ltSERLYnRzQm5oRWZKaU1qZVR2?=
 =?utf-8?B?OUZYNFdYS2ZPNENsQjg2NWIwdzJBbXRCbFhxd3Y1QTdUV3V0dXYyU2hMai84?=
 =?utf-8?B?Z2ZRVVlzMkNuaSsxUVByV2paUG5nd29PUjc2QjgrNmZHN2ZaeWZqWTJkL1Rx?=
 =?utf-8?B?VFV2QzRVa0ZXbHZ1SkEvemlPZ20xQThhUFM0dURkVEU3TU5CTVJLRGdnRTlk?=
 =?utf-8?B?RnNmTEk3OEJ1SmxUMlhQYUdCc01QQUlCSHhieTZRZ1c3Q3UvS1RSVzRoK0lT?=
 =?utf-8?B?RFNldUtwTDBXQ0pZSyt5RGFBK1hnZERJdmZEMUlrRVNkTklIWGNDV085QTNR?=
 =?utf-8?B?MElUcXRwWkdkdWs5VC9ISmFDc0lnNXl2eUlzWGNyckZJcUdjQU1qR2RuY3FC?=
 =?utf-8?B?ZFBzR3NBUG9wNjEzeFE3blpXVVFLaWJiUWdjTEU3ODc3L1dIWTVuUjB3RGxW?=
 =?utf-8?B?ZHFoVjU0MDRCbE5sK3lCdWFUMzRGV0hjYWR3SDFLU0pTNWs3VVl5aVl1MjM0?=
 =?utf-8?B?ZjV1WDl2bm41bFVsMnI4MUd2c25zWFB3VGExQzlnZEZUbWdOVjJLN01rOGFo?=
 =?utf-8?B?WFAwRDBuRWFQUU1hdFVaZDBFZlNicWRrR3NzaEc3dDZQUE92NkpDMkx3bXAv?=
 =?utf-8?B?Y0NXRm11bERuTkpNcVVjSkptNGhUdGc5Mks0MkVhZFdEQk9MUG9YNWZ5c1Zv?=
 =?utf-8?B?dTd6SVk1R1o3VUhEM3NKS3A5aG5MaEkxMnlyZVNMSW1kVGtIVHJzTkhldk0y?=
 =?utf-8?B?WjY1cGVINHR4M3J1Y3NSZVAyd0ZtWFNwVUZlTzcrUnhwSmVGMlg0a2V6aUdC?=
 =?utf-8?B?RUprTmZIWHF4WFpXQWFodUNqM1dQa1Jqc3VULy9ST2NBT1JMOHpQR2dRVmY2?=
 =?utf-8?B?QWp1TFpDUDhRSVA4VmdlL1N3bVdIdXk5NkFxZGhUbE1HWFlrckNkVFN1WXJp?=
 =?utf-8?Q?J5b4Guq1AFjsClsAjE3f2cc59?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 918fce0a-ed8e-4031-9a81-08dcc729cfbd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:22:37.5685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vWy0dfVBPReW9aHl+kYNO/PF21ndSmLYmFjUbsosDHfXnCi++fRYj6TqzbydVP7AsMQk/9P5mdmW7bwZ0x1hXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> All the page table memory should be allocated/free within the io_pgtable
> struct. The v2 path is already doing this, make it consistent.
> 
> It is hard to see but the free of the root in protection_domain_free() is
> a NOP on the success path because v1_free_pgtable() does
> amd_iommu_domain_clr_pt_root().
> 
> The root memory is already freed because free_sub_pt() put it on the
> freelist. The free path in protection_domain_free() is only used during
> error unwind of protection_domain_alloc().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

