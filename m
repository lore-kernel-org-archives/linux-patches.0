Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B038152DF1;
	Wed, 12 Jun 2024 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718194169; cv=fail; b=LU6b2fJLFKa/RJnp1m3TiKXlw/JGgxuuantT8Q8pVGocZkfvFDhRN12BmxTTxHHg48ejtAZIE1Mnd+9gLsM32IFi5nPKfTgL1Gmk2BOh4kvkZGCSKq8HvhWzcxatUeJ6BhI+CmiL4ArH9gGV31n4lx9DtgEV3TmSaLgxnNTvP7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718194169; c=relaxed/simple;
	bh=H5724rKNVexwuS6/7GLIoOdGxZzIKyuFjpKaXTqevI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dJ+Y8QYRLL+JmTQVVaU6m62vsCwFfKMo4lp8uHmoBSDXlIlvhEvbM7pFuNBbrL3tRJp+zup73GAeTw8x9B6vyQ0otM0G0LRr6fS3sfbB0zDApGrpIidKMymljhiQNVVEUrjbM5oHKTPu9VFAGuX4aRBZs7l1Lasrp5mhDT0O3pE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rvDXSmNz; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rvDXSmNz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYiEIzzAr9TU2mwYUjYfLBCkpLcTg4nbEKkYJ99GalkFMpvSv19r6zFYlec7637w43arVd/an01wOpSnxwLJmElWOvVDvx7AlN+0SRZo2hIrNldNjb+Woq51G75tTLVZUobq9a32whFYNK/2rCSQ4UVhcnsdjeQOeqz5nywUvAvE8JEy5CtjcRFlIdJxDcGhidRbLNdYi4P2VGGCvqPdrbuY1E+1bD2v40XPBfIbglzhN3YDQZG8yd0JRvJwIqJvQnWQ3bs4v5lDKa+N/PjCG7+T9mfSTZfDUOlsPn0L5oj/Im4n7rFFEzdUIu+44zXJxNp3JO65/vnJ+a2Fn7tSHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLkwcLWhNeVYWUhxEsVauPI9OR5HSG/8ue1mLqq8+eM=;
 b=e1IgMaDLXKaHCXdIagE4MAGWFIzg0WRUMtDcoPu3j4hjY3CEKxCGIzVN6USZ1MtpMVISiAGG+VKSA+J7/nz22ATGpW17lXrKfWMF8Z8FaSQRZIaCUBHupm357KBOoFKf/Z7lxdUU3VCjxHmxq96YizZdPPvF7PgA8E9Ke4IUcYvIJOHD/jGFHmWbkDIpc26dXAAaeLphdrk3Uw0kPzOLDS87W7fUJycGLZHkHcvaeEJAWCReK+riNawWxfXW9eJavoBA4TelWYjd3HEy37GkbjlgyrCzodnAqo4h5pEruOIL3gFMs3WlLcw5E6GpyjRL+S++UkZAvOMdp6+cseVMcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLkwcLWhNeVYWUhxEsVauPI9OR5HSG/8ue1mLqq8+eM=;
 b=rvDXSmNz2rZdoQkkBtkpLtODx8euPbtV51285E75SI+5E3HDq9/wG4hGfImUCeQjAZ8S2Dinu+QzE0UrqV5UxnH9BsiA/GkG6V1UlrO6vw6AO9ho69re1rTa0QBXg98EN6sD6eZfvvRRlg0F0NH3YQQVyqLMOQT+c/VCXqMa4ruB9bQacA3MluwhJyYEQqAZUamuNhFAQg9bw4X/2Xg3qlZZlmJvRyakKxm1OfzUodS/UEtaiasZG8SzEeVbUtn3Cnnh0htuAmn2ZZ+ITu+Qn71ccUDbLC3pPhd92e9vWjs6sFkGYVOzdcgDtrQ0SyNvSF8mDotHBIIKjlxfVAV6gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB7109.namprd12.prod.outlook.com (2603:10b6:510:22f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 12:09:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 12:09:21 +0000
Date: Wed, 12 Jun 2024 09:09:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Daniel Mentz <danielmentz@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 03/10] iommu/arm-smmu-v3: Add
 arm_smmu_strtab_l1/2_idx()
Message-ID: <20240612120918.GX19897@nvidia.com>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <3-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <CAE2F3rBJxj=zFmtdGddMdPy9HXVP-cu+MtjaJhrJpjux_GZ6KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE2F3rBJxj=zFmtdGddMdPy9HXVP-cu+MtjaJhrJpjux_GZ6KQ@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0086.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: 34d9b116-4350-43f1-1802-08dc8ad87df4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|1800799016|366008|376006|7416006;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3JXTnpETHcybk9LT0xBRWIvQ2RsMy9RYndLTnkxUDhGTFhXQW5DM1RKV1pE?=
 =?utf-8?B?UDlFT2ZaekxwUjhnZVNaNGc3RHpOcUlkME5CeDZ4QUt5ek5VTVJDTGx0UzV1?=
 =?utf-8?B?MUJwbHh0NHpzZHVOb0p2WWF0d0dkOUVQRDg5V2FDY3ZCNUN2ajRWOEx3YXBz?=
 =?utf-8?B?V2dWQ2VUVkswLy9vc243M1hld05kWWpHaG5OeUl3eE8zSnJoRHZSd3Z3VE9I?=
 =?utf-8?B?NjRhVUhXZHR2Tlo0MDVwQzZSSjErVzhIRVZEYUxoNURpWVg1MXg1L2V3REhH?=
 =?utf-8?B?TndnWldHcDRtcVg4VXdoTGt5RVd0NWs1dDVLMVpJc2lsNWMvRk9ubHNqTytO?=
 =?utf-8?B?bjd4RzhWZGVweFEwWXh5c3Y2NzJHRUt5eXU4NkFlU1dLakEyQ2E1UVpIanRv?=
 =?utf-8?B?Q1pkaE9jK3hlZHdYS2pINkNTbVh5eTZwRTFCcVNJRFNtT3NZeG1KT2pXd0hG?=
 =?utf-8?B?NXZwbS9ReVhPdVdraDV2cXptSE5HLzgwRVBWbnVVM2VIc1BSL29penZnOUFH?=
 =?utf-8?B?d0JINmZZbnlOVmp1M3BvY0ZrS1BtRmlJY1JhS1lkQ0FFNnVsNlNENGdCbVlJ?=
 =?utf-8?B?cnVINVBCTXZ3YTBDNUI0TTFIQmx6S2tycjBVcXRnb0VuQ1BzSzEzQzdOSzZT?=
 =?utf-8?B?K1RlQlZxUGZ5b0Uydys2L21GdDJzL1FPSnJnZ0hLSzNhL1o4aGVWQW5WaGlm?=
 =?utf-8?B?VURWeUtrVDQ2cVdrZ1d5S0JraEk0bzVORTBtU3J6T1lqbWFrTUNjR3VlNXcx?=
 =?utf-8?B?bmRrVjVCL0psU3h5dHdoZEdWNEFoSkJZdmhQQXM1TTl2VDVia1RvV3QrVVcx?=
 =?utf-8?B?ZjljTEFGamtZQXRCVi9MaHRtWDNNMDlKUlZ4ZUZWbis4WE84eUIyZXk0eUVy?=
 =?utf-8?B?MVc5ZEM0TmlITlVuRm1DZ0JMSEVuTldtVU9HaWFnclkwS1I4L2hNbVh0T2hJ?=
 =?utf-8?B?ZWdqb01KbGJBeldSNlU5T0RmbTJmK2dXTmQrM3U0S3hGSnVOYXRkMjV6ajZY?=
 =?utf-8?B?bnZQWFI2aWJseFpxZmhUUTZXSlJRVVNuU1hMT0RsYjBYcVZNZUJyZ3hWbXh0?=
 =?utf-8?B?YVJqQjV6dXZwc0xLSzNkUWpVeXIrb1hyeW11VzdYQTFiYkxRcko0alpYYmVx?=
 =?utf-8?B?VzEyQy92V0N4V1krWC9tWmI0S0dqR2dYbG9Pd2o3MTFJd3VyZHVJWmdZWWJ5?=
 =?utf-8?B?ZUNLVVNnQXU5c0E0blUxTjFGZ0VLZEpLV3M3REhuQVFFZXJHdHQ4NWlzN3VL?=
 =?utf-8?B?WlhnQlFsYlBRQURIN1FJM3hCMHhjTjhFTkRjWWJFTW84NFBKOEQwUmUvWktq?=
 =?utf-8?B?MUwyUHA3bStDVXh3Z2h3Szk5Y0lrRGdvWUw5NEMwYWUybXE3bFJtVzd5TUlI?=
 =?utf-8?B?OVh1SlArYzR0NjdrME1ERW94ZGIzSXdVaUlEaGNCRVhEajROMXM3UmlOYWxu?=
 =?utf-8?B?aFhSNEJhbHQ1cjBYNG5wbzBhMHBsTVh6MUF5U1hsOG5JMVFNV1J3WHFXVnhG?=
 =?utf-8?B?V3NsaHl4QW9qNk9mTVJRMlE3YWJuaStoM3BIV2VGNmRvbDUzRXJxSkVNRklp?=
 =?utf-8?B?aEw4U3E5VlZiaUg2UEg3enp1cUlBU0ltNmYreXh0SFQ3OGVoaWNtNWdnZmcw?=
 =?utf-8?B?MSt3T1I1TG5vc0tMNmZ6b25iUVBvck9MZUR0MkVaUjYwUzhObjRYeURESTR1?=
 =?utf-8?B?WEQwdVpWTGk4ZUJqOHhQWnQ2cG9qQUxFWkNVQzB0dkQ1NktCSkNRVm5GRUdZ?=
 =?utf-8?Q?01tSCecDDuBRy3NSXw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(376006)(7416006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0lFd0VQUFJuWVJ4MUlhLzA2N0RralJUT25lYzB5UjlmL0pRWHdwSVdEY3RJ?=
 =?utf-8?B?eVB0ZVJuY2FxSHBTbUx2ZDAva3pqejRPZDJONzhWQlpaODBWTTgra09jbVhP?=
 =?utf-8?B?dmdaUGdibk56UWFyU0p1Ny9oejJzUEtFbG02cy9pU3dBVXB0Rk9DdXh0Q0Vl?=
 =?utf-8?B?cVZ4UEFlV1dEY0pwYUhjVEM5UFNJODBXbU1xTC9pQkt6bUVkNVFIR2EzaVV1?=
 =?utf-8?B?bkN1ckxMcHVRTUtnZDlaTnhpd0krdkxQNjV4M0VEL29vQ21NR3pRNHE1MWM0?=
 =?utf-8?B?NFM5bXYvckRpY1ZlZytibUFWRitaQ0M3a1JGeTBxcTh1QWxmWGZJbmFneWdU?=
 =?utf-8?B?Qk8zbE9iOHROZHowVXdNYjJjL0NEWWN4T0l2bnZhQ2NGVmJabURKM3JsM3Va?=
 =?utf-8?B?b3g3N2xrazVTWVF3U2dMTXNuWlA1Mm0xZHAvQkh3bXZEYjJZeFhWVGV1VE45?=
 =?utf-8?B?a2RpcG1od1VYKys0ck1nakMvN005VkhRRUZqbEwycmxqb3RiNytyR0xsOFJi?=
 =?utf-8?B?SG1vKzQvV0FWMTRkZ01WN2VyVjVFakhBK0tROEJZbDZtbFQ2RUdsSmI0NGh1?=
 =?utf-8?B?blQrazVMMU16S2o3bkNlQmtJemkwLzRuR3NtaEN1NXh2L1RPbnJjV1dlakNz?=
 =?utf-8?B?NjNRaEVONGRCWGJnM29KRnQ3M0RzWEo0eCtoSEU2THRTaEE4aGhXb0l1R2lD?=
 =?utf-8?B?NDM2WmNwaXlHb1dzTW53Wm9LbXFCdW9PdVZJR2lGWHFMRmFScXhPU285UTgr?=
 =?utf-8?B?R05zcElzV0xvZG5BMitFd1gwSTJXTVc4T25oSXQ1aFMxbTBtTUtLcTVFT0lh?=
 =?utf-8?B?MUMvbVJqeGVYbHc5MG1RdXJwN0lNWTBZRWpOMTRuMDFGYnBjOGwyNnMraytK?=
 =?utf-8?B?djlYQ3lSaGFnZGZaUUlyZVdRNmtmTEVKTS9kL2JHcXhwWGFVbks0N1pyZXpl?=
 =?utf-8?B?RGJQbVBCYzRtMG1QV2VXUjBwdWlOckNjbjQvTklNbFUvNm9zRXRQM0wzV2U0?=
 =?utf-8?B?U3hrVk1CK3lxVVovdTdyMmxidFpGRnRESnpMWENZVitwZFBOL1ZkdXIrUTBp?=
 =?utf-8?B?RWozTGwzTEFIdEgvUHc2Z2tDeWpCSjZML3pDTGVXUEhhVk11QlVkYlFMNUdw?=
 =?utf-8?B?R1RqeC9POGtqcWFXK3NWb1N5cCsrQnNuUHZNOW9lT0pCanJoMEgvRDhONVAy?=
 =?utf-8?B?dHhQcXhXSlNRdkNaNWpnY3k0QjhVK0Z5NkJENlI0UzdGYmRIVGc4Mkc5Tjlj?=
 =?utf-8?B?Y05rMVpJSUpRN00remJuSktZaDdmZ3RNd25uWk82ZkN3TldTU3pvVUpibnJo?=
 =?utf-8?B?aGdZNi9GMDcrZ1VYMjlZbVpkbnBNWENXYmZsSDF0QUVyZnIyeFNrMk5xN1BC?=
 =?utf-8?B?L3gxMzdxaXV3VitpS2Z3VHc5U05pNlNRZGdWbTNDdC9MTmJjbG1GS21mQjBW?=
 =?utf-8?B?T0daRjNmVURhSDFuckdCNFVnK3hlaVZJWHFrMlA1cUlTdEMrNEVjMUhyeXRt?=
 =?utf-8?B?Y1ZkUUp0SWdQbmR2aFRqT1Erckc5UGgwWk44TlFrRzBqQVpDbGQ0elc0TWc2?=
 =?utf-8?B?V0haVEFuYnFBN2p3N29SUVJEejh4NjZVeHE4VkdlT0lRR0RtQldtd1U1WFVW?=
 =?utf-8?B?VWZmYWdiSk9NMEpCQWZFazd5dXVnamxUTlQxb0d2OHYxUkdwR24vOGw1WDBk?=
 =?utf-8?B?UlA2Z0FBMTJNc3FMTEJMU1B6NXNGUWFNYjVuVzNVdkdxZnlJUHNKTC9jZDhw?=
 =?utf-8?B?VXpmOG5FZlNzRndKOVVCVC90amJ6VFF2WTN5dndsQTMzZ1EvdVltUzNDd3BH?=
 =?utf-8?B?d1EvM3BXb0FCb1lQYUM1b1FleGU2bXNlNzN5TkdveGFYSHR3MnVrM2laNFht?=
 =?utf-8?B?RExRdXdQQUxyRjZNRVNVelp3TGN0THBqV2lMK0tXUFdNWW5MUXptQU5XRHZ0?=
 =?utf-8?B?aEZhbjF3RlNDUUxOV09xUWZGNERRSjA0LzNVTEQrb0VhK0M2L3FucWRQV3Z2?=
 =?utf-8?B?SkJ2K2swS0ZkRnpMbHNMUHFvcXFrRGR4K3F1bVVhMTZ4NFRZVjBPMHdYdnVJ?=
 =?utf-8?B?Rzdlekk5M2ppMGt4MGdKc2ZzNHhnT3pjOVRyVFg5SG1jZWkrSmtNWTVjbjhZ?=
 =?utf-8?Q?Iimh0sfekEY9mhEFK7UeHsohj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d9b116-4350-43f1-1802-08dc8ad87df4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 12:09:21.1558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2OJ7V6IB38Rr0DOub4UxC3dqTTxwA0Tbic427aA4w5VaYR9gJnaTcs/PiKqDeTQJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7109

On Tue, Jun 11, 2024 at 05:30:53PM -0700, Daniel Mentz wrote:
> On Mon, Jun 10, 2024 at 5:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >                 dev_warn(smmu->dev,
> > -                        "2-level strtab only covers %u/%u bits of SID\n",
> > -                        size, smmu->sid_bits);
> > +                        "2-level strtab only covers %u/%u of SIDs\n",
> > +                        cfg->num_l1_ents * STRTAB_NUM_L2_STES,
> > +                        1 << smmu->sid_bits);
> 
> Does this mean it'll change from printing
> 
> "2-level strtab only covers 25/32 bits of SID"
> 
> to
> 
> "2-level strtab only covers 33554432/4294967296 of SIDs"?
> 
> I think that's less helpful. I would prefer printing the values in
> bits.

Sure

> > +#define STRTAB_NUM_L2_STES (1 << STRTAB_SPLIT)
> > +#define STRTAB_MAX_L1_ENTRIES (1 << 17)
> 
> Consider adding some extra white space to nicely align these #defines
> with the rest of this .h file.

I presonally dislike the random vertical alignments, but sure

Thanks,
Jason
