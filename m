Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8EA2CCC9;
	Thu, 12 Jun 2025 04:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749704253; cv=fail; b=kXrdRpH/ue2LaF6IqeexLOK33WRzeMFQmbNxDofvHyepH3e5ZH151VOs5E/s7vvahB2o3RGtQd4Hj6vU1deYu8KPl9C9zzbp6gqVoMXT2VIOjOA+/iklQtgzB53bhcECkqarKZCrOcXfTgwSPkJEJXwCVdUdpReE8HBLGxCnaug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749704253; c=relaxed/simple;
	bh=gWQzH8z5N07tFtdYVUAFzhk5YYneq+ROcBK2ERlNOPM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NcYbafh6PoZ6yyTYijnc4yVpHmdp8tf8M3X6GASS8tzELu0TsLerJbQGKEd7VDtsgND10nuFhQe6dXSfQmrKYerizBtZCbq5UAGd3EsULJ1iSs+ou1pWqmgeKhc8Hm3BDOkLgk4eJDDWRrN0mFNhoddbr29ZpzkW3lBROu/h+Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5H/AwooX; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5H/AwooX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pspt+PKk24semOuFXr3WBUtK0Khx/ZZ+UcSvQSNsycw2E14gtCodhjLFe8epZtNrbg7qEJa5YwkPCSXD+pWgNx93eH4S6X79bWdwIxKgx/mqOACZpt9pwoO7xTKW6bw/yBwT7jT7SP2qpg/bVU8OPaGev8UdjeAFwRwZssnyhMSLZmnNoKi8Nqj4nTvJ/tlZ7eEMmY34I7winDt/nSZ9VMSLkpYED1XZfnDnffyRVoeMflu1nnFf5cdW1e0CpfEDpw6bohOTVjLo7gqB5IR4TNAaYhJaxQEj54aJJwIvLOM2LTmMOz0UPvNyMNMtZi4f/rq/q9C7vgyBO1yfxnBrZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPLjw5PTyXGHCSmiGjfvA73/qojJ0nQmLERyyqyr+AY=;
 b=H9Ezqxc+C5dB/FJtY1lZKbjzQrDFAykcHMPvm9QjISDsQAjSgwsgh9JOwwUs1kkOkxT2QQNvLtQSQNVPsVA4P24sSFIjYZn5sMeHGXMgjlrBHrxM75nsgafn6/a83XKLAb8HXYsMVtKmZs/qwHgJPll4w4q/H2+N339HHmdW6ztT4pemC2xozJplMMrmD7dyOXBqFnC4g52pZkMBD+znCx2GjDWqVDPLQObdcHBdzeno/sbftkoJgpNDsOLIxV8qp61oygp9uBZUDvcBbaqJQ9Wp5jvIwYdD3Acd6qdXDuHGOKjphyJpP71+48yz0AEIPGWG3DQ0jLKiScq8sv7JTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPLjw5PTyXGHCSmiGjfvA73/qojJ0nQmLERyyqyr+AY=;
 b=5H/AwooXeR8Nb4EDoBGQWVHSwoC60mvCX9jLwQX0bH8HhIHRHCG8lrhanuPtCvWimIqMxzidtNa00Ay502mJjHZcjMDTzDzZkdibpojLlbKXja2AbSW2xx33bbOcTMAj3FjHYeKuaKsiTZF/y4ZJ3jTwa1m/1aUWW6ytSc/1Oj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB8873.namprd12.prod.outlook.com (2603:10b6:a03:53d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Thu, 12 Jun
 2025 04:57:29 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 04:57:28 +0000
Message-ID: <434ce0b9-e562-47de-80a3-ffa111f598fc@amd.com>
Date: Thu, 12 Jun 2025 10:27:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommu/amd: Fix geometry.aperture_end for V2 tables
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Joerg Roedel <jroedel@suse.de>, Jerry Snitselaar <jsnitsel@redhat.com>,
 patches@lists.linux.dev,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
 <d5a653df-9b43-4f13-8b1b-c3268c356592@amd.com>
 <20250424140613.GR1648741@nvidia.com>
 <8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com>
 <20250528115708.GQ61950@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20250528115708.GQ61950@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0159.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::20) To IA1PR12MB6043.namprd12.prod.outlook.com
 (2603:10b6:208:3d5::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB8873:EE_
X-MS-Office365-Filtering-Correlation-Id: bb809e08-f1eb-43d3-8086-08dda96da109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2Vob2lSUFdrMEE4LzRmVGcrd2c4YmY3MkQySnhNY2p6YnhUbUE4QUtaUWJp?=
 =?utf-8?B?UUR3MlNzNktjdWxpa01EUTR1bHlSenFkMXFIK3JQQytQMHkrMjUwb2U4dWFV?=
 =?utf-8?B?QmNIdytWMG5ycEl2QzZ0b2hWdlNBRjkvbzZvd0ZWc0MwNDZtaVQ4ekZBQXlR?=
 =?utf-8?B?Zmo5SFdDYmcwMS9MY3A3MlRtdFZkckFhTEVDOGN4TVFnZmRwaHBKVm1lZXNB?=
 =?utf-8?B?UUZJazBMTm9abmFaaFN3Z0lYa2ZGRUdYVEJ6NGM4UUo1Y1IwanJGZlp5UHd4?=
 =?utf-8?B?dmcwd0l5OEs3SUlTZG8xSTFoUlljbURLSFo5UUJQd1hIcFgzMTdlQS9sMXBM?=
 =?utf-8?B?RkdUR1NQcGVmVSs2a0N6VFQ5RXg3V2ozb2dVSGwyZzJtejUrQ1NaMCtZVk16?=
 =?utf-8?B?cVQySWYwSWJHT3lmWmdMMEtlMzBhZ2NYa2JXWmhZRlh4bFg2RmNROVlrZyts?=
 =?utf-8?B?elBHeitpcHdhTDcwTTI0TXJxdDdZZXdwd2YySnhWNk1XWnRjenU3VDJJL3JY?=
 =?utf-8?B?MEpYQ3l4YXhHS3RESzRvYmtKcTA3WlNoMXpzb2RIMUxTYmdZcmx3UGc5OHlD?=
 =?utf-8?B?U0c1V0NkR3JudlQycVEwb09KZHV3bk5hSXZtVWMzSWx3dDAxVWJWTDZzSU1x?=
 =?utf-8?B?SklRVnVhQXRqT1JlUjFIVnlQeFIzS0NET05UVE9RV2xERHhPNjJHTGpNblFq?=
 =?utf-8?B?YnYvWFVXRUtSMTZHNXVMV2F5czhkd2ljQ09ZU1VuTFRrTTI3RWpJVnFsMFBu?=
 =?utf-8?B?WHJUbWhWdkZRL045ZUJsVXUvQXpxU3pLTStxY1MwclhwaGZoc2N3bUpENGJR?=
 =?utf-8?B?bHl6TWJmVDRGcVJWelR2SmRVemI5NWFjSVF5QSszdjNYTHE4ZWQ4RlVLS2c3?=
 =?utf-8?B?TTVwYXE3MUdjbkY1Rk8vWW5rM2ZtM2Y5WFRhMEFLV0EvZlhpWmwyeDVpZ2pa?=
 =?utf-8?B?L3E1QVBLdFNxakwwYVNsTjEvRVBBN3BuMktLY09qangzREk4TDBwVll4STlV?=
 =?utf-8?B?cGNsYWF2MFUrNisyWW9sWldOZTMyWkwvY1lXeHhMYWdxcVBpK0hDRENLc3FX?=
 =?utf-8?B?VE81eXRRWGhYZkduSnRPcHkxZitkS0xoZHorWVE4UFZnaTN6TlQxOVJpK3Zx?=
 =?utf-8?B?bmJzTHNVbDcwSGYwc25PZDhWbExWSWpZT2lDRXVoL21kRHlPUXhFd2lBeFVL?=
 =?utf-8?B?eTBOenJMUG5MRU9TbWM3ME4weGpncnhTNHlQR1JPWHYvQTBJMUY2cEZpUFpK?=
 =?utf-8?B?WWMzRDlwaTlObHZyQkZuMjRMOTVxVHllZ1VOT1k3MXg4cm9PdDJZb1B1OG1E?=
 =?utf-8?B?ejUzSThMSW00L1VOR0JkekRjNHEwVWtDZEtOM2NwNzdFNWU5eWIzM3orQ3N2?=
 =?utf-8?B?akxBaFc1K2pZK1ZoSXRzNTlVa3kxTG55QWsrRks2QTA0R3o2bHE0UnRWcnJk?=
 =?utf-8?B?bGZGOWh3ejlPWldFSTVLcHJJNm1RZ3MrUmsxNEl5NnRVREE0MXRDcjlVQXQz?=
 =?utf-8?B?Z1dKd05tek9qdTRyT0p2SmFCYzN6UTRoT2pGN0JjeFZ4dldUckpDbkFYTVp5?=
 =?utf-8?B?U0VsTERaeXN1ZkdKYzh3MWJ4WVlYVUNtVGFheFNPd0ovWXgxeGhDV1F2M0tX?=
 =?utf-8?B?cTdKdDlNVWZRR1FLcEkwVCs5SHcxekYycGxvUzI5ZDh3WHV2eUNCU2lZUkNG?=
 =?utf-8?B?aVdPZjF3QzErMzJEWHpYY3FXTXFWa2JsRHFabDNHdStIQm9ZaVFQRGYrUFd0?=
 =?utf-8?B?M3Q5ZHYyNXd2emRjOHQ4VGhadFFWR1l6clpJMVNqcDFOazhOYVBNVGlXNHFV?=
 =?utf-8?B?eHlqVGJ0YlZyaUlNUG5xNmdZSlk5Q3dhS2NaeGRzTXYwSVpiQkVPeDA3aTBW?=
 =?utf-8?B?UFI3MmM4ak8wTU5yQUJhMFNQNVBrbFhPL3JNa3FFS0tTejI5MHJSYVBYRWVF?=
 =?utf-8?Q?eYhY5YYiN7c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3lkbjd2MCtvM3NhSlVUdFZDY1h4cVJ4VjZ3aWN5NVNCZ3ZLdHZGemRVeTBo?=
 =?utf-8?B?SXg1WkZQZ2ZtZGQyamhPc0RyQmM3YzFrcm5kQkZKMUM3anhTZ0crTEVPQUhB?=
 =?utf-8?B?clNmb0NJOTgwWm9JcVZFUUZaSlBYbEtQWXQvbTFVM0pzR1BpWmt0enlWMmZV?=
 =?utf-8?B?SHJPeTdxdzAwaDdEK1pCem42U3doc20vaFpYRFFaUUxCcGpPaEhDc3IwcDdY?=
 =?utf-8?B?T1JZTzh0WFp2WjVLckdDYUcrWkJWZExRNjJPcE5pWmdxSWhwdCtkK2l5UkJ1?=
 =?utf-8?B?bkFSYno4ME1uUDJ0NisrQWVFdk0xNk9TUjhKZDA3WG5OM1RDcUtPbG1XbGpw?=
 =?utf-8?B?cVBTdjk2T3dmYnAxM3JaVit4SEFYVlNycGtVbDZyRUkwZ3VpQmpKYUhQczlt?=
 =?utf-8?B?SEFnNU5wYm05SWY1VEJKRFgrY0dzdW5uZWFrejVxMURKZVRmT29nQk9PMnJt?=
 =?utf-8?B?ZE1EbDRLMDdRMXNLU04rNDdua0d5VzhlNXhqbktSakVsMXNvMjJYSFJPaFhI?=
 =?utf-8?B?djNPQ3I0ZU1MeTFTR09yayszWkNqQ2oxcVdxYzhRT1pSdDNmdDJqMEhTVUdM?=
 =?utf-8?B?di9SdVlnTG5YV3NudmRSYVRuc1YyMUhnN0hsMWZySllpeGFpMVlaLzhVY1B3?=
 =?utf-8?B?RjExOFE4ZDkwMEhUVjF5ZEw1Ym5PUCtIUFV1NjcvNmkwc2R5NlF0Vk1NTGlw?=
 =?utf-8?B?Q1VtYnZwVWNxNHhWSEc5VEl6NnFZNmFkUzN0clJlbTl2SkhoK3FnM05pRFRp?=
 =?utf-8?B?TkFyMnZhOG95bnhRbm5uUm9LSEFSSEkwVHV6L0dvNFhxTGgwcXpROGovUUow?=
 =?utf-8?B?VVg5TklyN2k2dDRLL3UrOTNaRC9aY0J3anBGZnN4cFplK0wwazFmZ3gyUGFI?=
 =?utf-8?B?V3kzQkVZK2hkZ3MyQStyRzgwQXRGdXNqNHNucW5ReVd0aW1zaVVrMFlwNlMx?=
 =?utf-8?B?VlFGSEoxY1RCbnMxakg4aTZUbEl2OVgyMUtGUDREMG4zWXFxSFZuMnExWXEw?=
 =?utf-8?B?azk5c29pZjl0aW5PUlNYdnA2RUMyRkcyR2JlUU5LYWhxdThZeXIxRXovREtM?=
 =?utf-8?B?M0VZLzlpb21JdUI3UllWeCswbDRFdlYrS1pBOXlTRkRVS3JGMHJiVEs2cERY?=
 =?utf-8?B?WkZBTm83cTBNQXhaLzFtRFNubDdRemRiMTJZYmd4WlFVNEsvd09FMTExVlBD?=
 =?utf-8?B?cEswL1RmVTN0OFJjVUZYdFl0YUo1b2UwNEUrNnR6dlUyVFkvSVJaczdYSkxR?=
 =?utf-8?B?UVBmcnZFREplUGs1aTBEOVhkWnRESWJ2MDFkWnJRc09xcG42S3Q0QjN2MGNv?=
 =?utf-8?B?elNmWS9PTHNia3N2N1RLcDdYZGZZaXFvaVRMSWhZeFF1bjlKMnVBZHVTVEJ5?=
 =?utf-8?B?SDBVUDFHdCtGSnB3MEdkR05iYUsvbkw4dE4wc05wKzluOENLWjUwOFUwTDlL?=
 =?utf-8?B?N3pEQmE3WnRFUGErVDIyd0lBTkFVYjlaeUo5RlFhWGlsR0NWUUNOTHdFT2M4?=
 =?utf-8?B?WlRQTW1qbnB2aHYwa09NMVVFVDZNZjdsRGlRSFcrNFJlanNHd2EyYlRpZ1RN?=
 =?utf-8?B?L2pCUTJVUFFLeXRGRlZjU09oZndCaFpaTkZWdzd5WGhYT3JTandrUlo3WUlp?=
 =?utf-8?B?N29lZUlYRmZFeHhvMzE5UXBvTWU2TWk2WEtsT2FvK0k0R3pRcVpmbjJCUWt5?=
 =?utf-8?B?MnZMbUExajk2S1A3RkI1bEJKNUZ3STZPUnREOThRbHYvblo5NHIwemtsR2gx?=
 =?utf-8?B?NzR4RWxBZG9hc2krcXRYSGJSVWM5WnAwUitQV05Qd053OTV6MVpkNnlzZE1V?=
 =?utf-8?B?ME1seFpzQ2ppaUlmUWtWcGI2R1FtRG00UkFaOHV2QXpUaFJGcnFDZW55dEdH?=
 =?utf-8?B?VzM4R0VxWVMvLzBqdGlhd1o3dzNEVlV5UGVzcWRUWFBqZ2t1dHk2VkdJYVNz?=
 =?utf-8?B?V0FLamFJOTlDN25HaGpJeWRId05HYUUxcjRqeGR4TzZEVFc1Y0FMNEw4N29B?=
 =?utf-8?B?d3NZM2ZSVUlMVE1lR3IzTG9rNlJDZ1VMRHRUbU5wSStvWllTaWlCM0VpWDlB?=
 =?utf-8?B?cFMvalVyNUgwbkdWNGtEcHRGQVFoMXJzOEo0YUlvcTNWZTliYllhVkZWcDh1?=
 =?utf-8?Q?Oc28JcCK6Jb6Y7+WeP6mQCxcy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb809e08-f1eb-43d3-8086-08dda96da109
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6043.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 04:57:28.4500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbFhOX8yLaaRM/eCvi+vEc84lrY84bgoRKK0mmDITQzXvja+lZI89Kyby8a2vdE0XNEE9tmYDpKqm7scJ26YmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8873

Jason,


On 5/28/2025 5:27 PM, Jason Gunthorpe wrote:
> On Wed, May 28, 2025 at 02:17:56PM +0530, Vasant Hegde wrote:
>>> Yes, it should use bit 56 for address translation, that is part of the
>>> page table architecture.
>>
>> I have checked with HW architects.
>>
>> In DMA API mode (PASID=0), IOMMU HW does not use canonical
>> addresses. 
> 
> Do you really mean PASID=0 but still using a AMDv2 table with the
> GCR3? That seems wild that only PASID0 would break the normal rules
> for x86 page tables...

Right . AMD V2 (guest page table) with PASID zero (DMA API Mode).

> 
> We already know AMDv1 is different and that is documented, and it only
> works on PASID0.
> 
>> It's safe to use bit 56 (5 level page table) -OR- bit 47 (4 level
>> page table) for address translation (we don't need sign
>> extension). 
> 
> But does it validate that the upper bits are zero or does it ignore
> them? As I mentioned previously ignoring them breaks ATS.

I believe HW will validate and handle ATS requests properly.

> 
>> However when PASID is *enabled* (PASID != 0), then IOMMU
>> expects canonical address bit[63-57] should match bit[56]. Otherwise
>> it will abort the request.
> 
> Okay that's great at least.
> 
> But this is a pain.. Since iommu_domains don't act differently
> depending on what PASID they are linked to we have to use the least
> common denominator, meaning we should disable use of the top bit
> entirely, and disable use of sign extension.

That should be fine. We can limit to `page level - 1` bits.

> 
>> I have requested spec writer to add details in the spec.
> 
> Yes please, this special behavior for PASID0 is very shocking.

yep!

-Vasant

