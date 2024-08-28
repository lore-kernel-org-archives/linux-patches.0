Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C1215696E;
	Wed, 28 Aug 2024 06:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724826460; cv=fail; b=i4di24p1WVqqjPSqioWNAkgkMdAN5Gd9rBD06/SvcfbV0kkzmOQzL6zoxzcQuYUkNTt+8U08LrI81SpLrLjugBpRclX0qhhhMQZe05jCIoy/ZD34vA7Z9R4jyHIer3MMJ76+MOCmIGCYUjnkgfsXsUuXzlH9vIJDzAOeFxarWdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724826460; c=relaxed/simple;
	bh=LizCei56uY28SH+P4JIA7WgMpyi67orjRKTO+UCEpVQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cqXNJYH1G84QF6KjWz3db+vmZ1550dEGLzWh9Y0fRUdqz/YYBn9vjV2CyitrfKRZF0A2sPLTKqANTX4CV9JmMUx+v8Vmg++ONW8SUlt5eIRB1oMLWH5CsCXopCBvjiQg55Eqiv1+bafCFilNQKaQOdG/k395vgRIsxIJ9k+Hvls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=inLSbe3z; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="inLSbe3z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXkq1MB7t3oDlPxOt2co/TnOz+2htpMiU6b7TkvdarJdKDyXYG9aE6PD2kpEFhAvJPGitpDVVFkbYX+K2/h3NeIl+E+7DvlyxWSAhvxV4ciR8yRZ0zw8nTBqnjKpVta/sJ8qdRebLZVDhikTCHtAB61I1+OIhOkdJib17izMynI9aglxhDhZBA50Mtln+FH7MH98/q6Q1i109+Aw0iC42/i08iPkC7GVU/LwUcxsA3lS4O6xCbrw73BNMx2xJyvyWW68LCIdXvsZ8OHKGL+LyGna4fW5u1tIwHAxbga5cax0Og6IcORErcxKp7Dn7Cwrj3lawuu0CUrYQwP7CwDZDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFLLbYn5nnj10DTN+mhCEH8hFNmdown/oMf0RjbIjx4=;
 b=Q3TaSAwaL3Ubtfx/kdnqH1qYuNKphaLVIzYYlRD1Rs4ZOtHJDwLPNTbKiFH20wY0PAHk69DioQsrnc8KKaePUYsZatSdjDP49gnfnDKSy9aS7iLX8FzB69BKzBz86rdOVnmw+6HJ91/leZq35T+Ca9IiwkcGL3kQ+Ja8b7nnJmOBf+ZAzs4iZ+Lnr1CsCSxBpkZ93lZeREwPpjx2uWjjCqmDBaHQNSgxbJhUIDndTieZUbilI09UyXKEDF/mVaFWx87ESHJOpy+KTHALK3Apr1rEob4Xoirqv+q3cVRTNL5k6oQveVglDF7FglpzqJ6KyK+ukeCZVr7TkDYf9BxDaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFLLbYn5nnj10DTN+mhCEH8hFNmdown/oMf0RjbIjx4=;
 b=inLSbe3zxnbqeautlO+yUY52jWWqUJ+Ct3h+2QoHmm8oJombI0dKkMwPGQI8DSa8WpXr/OMyE8KikxyGDWrk6guAJZ+2bS0TkLA0k5mngjwW9iSUJyqFAsiL6YklIOpxoWDVHB0hzA1zTx+wIykUYg4H4RMka7h+F4CppcBCjNU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Wed, 28 Aug
 2024 06:27:35 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:27:34 +0000
Message-ID: <a9cafe49-0b6f-48f0-aac5-19ef6a7375a6@amd.com>
Date: Wed, 28 Aug 2024 11:57:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/14] iommu/amd: Remove the
 amd_iommu_domain_set_pt_root() and related
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <5-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <5-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0254.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::20) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: 719a390c-4401-4158-db5c-08dcc72a8070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWs4SHFvUEZDYnB2N3UxOTQ2MUlKekJiNUswY3hlbzFtWTRqc0Zna2g1bkt1?=
 =?utf-8?B?TzEwVUxaZTBDSUtaTWJuVmlqazBsdnhuV01HNHRTbEtBbHpuU0ExYnYwWVRy?=
 =?utf-8?B?cE1PcUFKNDRMOWRBZldteUYxandyaUVhdWp3K01GZFJMT1JuRWxJbndGUUFz?=
 =?utf-8?B?ZEs2bFU0LzdlaEw2Z1J2enBIQ3VXajB5bUdjWlRrUHppbGp6WXJ0T0VzL2dB?=
 =?utf-8?B?VHBKckI1TzhSR3RHQlNZaGlKNmF2TUdKamVmTi9yWlRKV1kxRlkySzk0cHN1?=
 =?utf-8?B?Wkk1MW9GVW52WUpjYzU2QkZ6N0g0dXpmMmI4eGxtT3ZIS3B0WlNncjJBZVl4?=
 =?utf-8?B?QWdybGgyZjJjYk5PL2JmYkYxWC9Bcko2S1k0RzRiUTdKSXNoaGQxSzBYMHMx?=
 =?utf-8?B?VFE2Q3Z2NWpkZ2hJa2FzUThhM0xGSFl5N21zaGJhUi9yemtlanVsNFZrSjZy?=
 =?utf-8?B?aDh4Q3M2VjlCd1FpL0dKL0RRd1ZkTEFzK2ZHVERhM1kvZlg1Q053aFRwVGMv?=
 =?utf-8?B?ZkRpNXZPMENQRG9jdkxtZHhQekwwSms3OUVkdjVzRThUOXNXYnpqRkxwalM2?=
 =?utf-8?B?ZXFzVVFZRkl6TURCckNYUUVLSHkvcTJJYTFSblZBRGVrVVVXaWZldWhQVDZm?=
 =?utf-8?B?WWY0TnVNdjk2eGxzMU84cnpaUkppTnpLSDBWK05WN1NsNDFPMWdtL2FtTEIz?=
 =?utf-8?B?ZDk4MUt4Rnl2bjdpaUo1dmdqMnVqeTdKMHhxWWsvRzdxNld6aVhRSDB3Y1Fu?=
 =?utf-8?B?eUJEZWlSazNpSUNZTWlkaHRvSWc0SkJBdFM4NmZVYnBtYStVdTNxQTgrK1B3?=
 =?utf-8?B?enc1eWVVRUpyRzc4NmxobjZUQk52d09KdXRZWi9TZGVpTndQODFsQkhwcXN2?=
 =?utf-8?B?eUhVS2JSbWs0cTZ6eXdhRDZLODV6UmN1QnBPcythRUNDZzNzQ1Z5YWlINFAr?=
 =?utf-8?B?dEtBVXo5MGRnUTBNL1UxVmcrOUdmWFFUbFlqR1JNMGF6ai9ORkpqbnZ4THZB?=
 =?utf-8?B?U1BhYnNWY2RUTWVSR2s3d3BRRjRBQnBQSlF3L2NhK1Z3QWxLS0NSNWNFcVN1?=
 =?utf-8?B?azliMkJRanBvcDhBdWMvUlNuT2lybklYaHJtOFNKVDllYThpUUg1Rk1RQ0d5?=
 =?utf-8?B?TUFNTlhQaWJUR21xaldXMnF0Ty92MVk4dzU2dkR4Ti81R25ZNFVZVlRpUWM2?=
 =?utf-8?B?RVEvVlVVWk1YZmZMdmNkZmo4RlJaekNRVms1QVhrei9SSjU2aytFK1RHa1Qv?=
 =?utf-8?B?a2p2eGF5KzJkTkNjMlBReFVFMzJRU2tNdmhGUzlTTzdCc1ptMFpxdlFWeEUz?=
 =?utf-8?B?djgxMzlTQ2ZudzU4bEtJSkQvUmQrQ3BGZVFlTU52VTZlcVRLVTNzQU9qZ3pq?=
 =?utf-8?B?aVF4Q2o0ZjlOSjFHM1ltU2U4d3hlV3NmdGtlL2liTm9Gc0xTaS9ZOGRMenA5?=
 =?utf-8?B?SGRNRTRHT2RHNWlTOEFIa284cnM0RGovaGZ5ZmFob3RmdGsxV1RnZmdMVmM2?=
 =?utf-8?B?M0dSSnNWQWVUT08waU9yVWgxVkRheGowWXZUdzY4RC9oVGhyOXBVM3BjN04z?=
 =?utf-8?B?TjNwT2l0R3l6NmNqdHhPYXpsQVRiNTJyNEg4ZHFuN2N3Zy9wc0ZmbkpzOVVj?=
 =?utf-8?B?cDRnZ1JvaGExblVTK0VmRlVhQlc5dldldDIxd2RvNWpzUE9wa3B1Q1pHazc4?=
 =?utf-8?B?YTdFcGI1NFNWUHVEK1NtM0NENDFWWVdKcDBIa0FxTXVDdnVoMEJONXVvSzZB?=
 =?utf-8?B?UjlxVTBYUzcrbXZRQmdud09LTGlhTkNYTjIrUVI3UHYxeDJtTEZuUE0yUnNz?=
 =?utf-8?B?ZndLK3RsaWo4SWZETXFHUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTFucnVObk5EcjJMc1ZWNXdHUW9RNHpqcytOV1JUY3lSNXVxZ1k5NVMrNFpx?=
 =?utf-8?B?R2ZreVFnRmhJMjQrLytEVWQ4T1M2VTdENXVUaitaWmtWMXYrMFdhQ0VhSmNn?=
 =?utf-8?B?UkdvUFlheXdkZzdXYmppUVN3d25LTU03SVBhQWMvRWVmWTlBQm84Um9naUIz?=
 =?utf-8?B?TVAwckl4eU1rNDkyb1BVdmFaSWNGQ01OTmxJdlRYRG0wNFNrUS9jU04za3Jw?=
 =?utf-8?B?QWJpWUZSb29CZGdRaE5sbllTWmkxOVpkb2lNMHhsRS9CMVlqcTFsOEdGV3ZE?=
 =?utf-8?B?ZFZFQTFlZ25ieldIL21WZHFndDlSTllsZUF6c3pjSG9jaWJackVUekNhbEx2?=
 =?utf-8?B?UEVrTStuM3o0VUIzc3NoWGJ4QmY0MXdkdGZLN3VsUVJub0M0VStSazBScDQ0?=
 =?utf-8?B?b1QrMkZJZlVkdGNNdThyV2J6K1l5SUU1SHpTbjRyMTBMeDJTVUR3TFFuTm1H?=
 =?utf-8?B?QXFrVzlkMGFjenI0WkpoaWE2alMyZVd4ZTJaT3h4OHRZS1RGNWtWL3cyckxm?=
 =?utf-8?B?c2hjZVM5V2FTVmdrT09ld0ZsdVNsWVJZR1I2UkpjSC85VUpKN2dOZHJuTlU4?=
 =?utf-8?B?UmF0WHdpbnZ6THdSS0o5WlZRUVk0N2UzUWxwOFFxODVJcnVEbEhQVTdmZmQw?=
 =?utf-8?B?eXliL1hGUG1yN3pkM2pHdWFYMkhjeHlteUU3Ry9GM3l4S1R5QWNtZFQ3dEdS?=
 =?utf-8?B?RDNjbkZRZnNVbU4xSmI1cUc5M1R5ZHljdTlWNnh3WEoyaXlNemlONEFFdlJl?=
 =?utf-8?B?MlcwalhJSXRDdFZBN1FKSHEwN2NHZzdOZ3dSK3FTRm5Zd2RyekZzcWVzRXpP?=
 =?utf-8?B?QU9KaXlDVVFveUE2M0g3SXRiVWpLV0VKb1dvcVNreHpEWlMyNkhUOUZRcy9y?=
 =?utf-8?B?dFpsR1dubllXREhhZmhZYVB2RVdNWXBrUDBjTUY2U2IrVGhYNWxLdlgvWC9E?=
 =?utf-8?B?T0cyNXlCckF1Y0o3a2l6UWZXRFNyYnMxV25rY2VUMnNrVFd5TkNubUdKa0VW?=
 =?utf-8?B?SlJBQTFtVlVzU05Fc2c5YkRlc2lmek1BZ0xOYzBqMGhSeWVQL3BwSHZnd3Yy?=
 =?utf-8?B?MGE3QmF1Q2tHcDFack9WWGhvMmtnZmNyQWwvbXBoWlZPbnpJbVpnelpkU0F3?=
 =?utf-8?B?bEM5MUE4cmRqWnRSLzBOZG1Dd2dJR21XV1cyaTRTM3ZOMlNJenVqakYwUzh2?=
 =?utf-8?B?RXZGNmFUcDdYYTVkTzNJN2JDUFF5K2ZjOVpyZjJzaDZxUGZYcUNTcWpxV1ZX?=
 =?utf-8?B?Y3BYZDBWQlpBR2pGMVRHcStKT3BKcmtQanNMRjU0Si81RXpYSkNDZG1wUHkv?=
 =?utf-8?B?N3ZpZC9rNURZSm9NME0zOCtyNXNBU1U1SHBLdGRyVllxZDYzRThkR3dZdUxk?=
 =?utf-8?B?RXVoUEIvWnhXZmQ2RGVTN0dReU9CUGVlbFAxeXNFaElvb2JYWndxK3gxU1o5?=
 =?utf-8?B?TjhmRlROVHg4MmdJYmxTSnB2eXZOc2FmWlJzTVNFRi9yYjJRdSt0anhKOFVM?=
 =?utf-8?B?c1hKVVJGV0hmdkhlZU41U0lkN2ZaaUJ0QU9KbXhyS3c4ZUlZOExXOWVIN1Mx?=
 =?utf-8?B?R1FPaDEwUVZGV0FnRWREaXpEcGZMSC94cFRIR3BkOXpzSFdiYU0zUlcxcWdj?=
 =?utf-8?B?VEtNSW5yYWhZZ0VnMWZNSEZuM0NYZmFYa3pBbkpkMDl1MDRUc0N2VFZaM3BR?=
 =?utf-8?B?aVNUTDdtYjVTZU53b2YwWDl6S1NkYkh1aEZISmJ5MGNDa1RYaGtFeFMvWmU3?=
 =?utf-8?B?TFY5RjltdHBJRDJPV1dMWENFSlZ3UmNUQkJZL1pHMmlxYk8wNEI2OXZwYXhB?=
 =?utf-8?B?Wmw4MHdYUWZIZlg5a1RUU1F2UHdDaUIyTVZyaEVxemx0dUhoTWRQSkNVU3ZI?=
 =?utf-8?B?UEdpWlV6Njg1TkdrbWoyenNTQVFUSDFJUU81djBFSWN0Um9kQTNUdmk0azRQ?=
 =?utf-8?B?d090Nmg3OWY5YzQwdW5xTVJlTkNXcU02aVFhL2gyei8vUkxmTHpXVnd3R1V0?=
 =?utf-8?B?cVlSS3NIUis2dDFMekJ2bkJ5MkVyYVNrdHk4UVZTc3lacTZZaUpqYUlaUm81?=
 =?utf-8?B?SGIraGxIMEpLZGFkWjgyMEp1dC9lTzlVbmFCb0dGdm1mRkJacGErMHMrd250?=
 =?utf-8?Q?1/7ldZpE4+gprAbZbM96yeKwj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719a390c-4401-4158-db5c-08dcc72a8070
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:27:34.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5DtH2kk/OLYTtc6ejT0hQd/RkcEAjD1lpMZnR0janWlV0ueOFy88BuFoELX0i1HTxmXUjSAeGvY0MgbMofh+sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> Looks like many refactorings here have left this confused. There is only
> one storage of the root/mode, it is in the iop struct.
> 
> increase_address_space() calls amd_iommu_domain_set_pgtable() with values
> that it already stored in iop a few lines above.
> 
> amd_iommu_domain_clr_pt_root() is zero'ing memory we are about to free. It
> used to protect agains a double free of root, but that is gone now.

s/agains/against/

> 
> Remove amd_iommu_domain_set_pgtable(), amd_iommu_domain_set_pt_root(),
> amd_iommu_domain_clr_pt_root() as they are all pointless.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

