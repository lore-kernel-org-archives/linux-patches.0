Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011042.outbound.protection.outlook.com [52.101.52.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9D3244675;
	Fri,  2 Jan 2026 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767369264; cv=fail; b=mWgTm1BS1HdPTmJIziya80uauCOlqDQx4s5wwibTlMzAovl5rixsk6LqBs3xE6sxCJkmaqfzLuRrE8rXY5k7xrbXSuZQWztZ8KP6JYpKg7Cg41CxSjaCsORZF/VWOfvTk3FQHqsGyKEwSFRUu5xFqaPCC6BOlG/zo7K1KEiYd8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767369264; c=relaxed/simple;
	bh=Jwy6FghVflF33wfmZF9S6dbqv2Wk27Jv8rH8zdbO648=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KN5pzTvPycJopFi5TrZVUyApCfsm5ztRJNTDH+DiygOcauE2RSwTXEWkkDoY/Pq00hs8KZBphdcM2EPEEnIzUKc0AkansRe1rnrN99SmNT7EJTvveKdX3YuFGHAGM8zqVo79jYalr/YS9RP72pCuu1w5GjwJeEqVp0hpf1B1Q1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n+d2g3lF; arc=fail smtp.client-ip=52.101.52.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n+d2g3lF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nUEpxuvZKWBiWmRsM8WNjn/F1VdDeEtCwoHFDMM7AxKE6QqcWBq/Dd7HUUxAKYVOjBAy5wqtJHeKrdAfnCxrh0YN6U8qKKsS3C+ux9GPuLgS55rYsJM2BDa/5JWTnnIYwsFzkprH7uuGOKtXes4KUhp83BM2aEB/nO/kziSN82f4wIXrYpZRviOFB1KVqLR8CNEFUzn1jNPhzo0EfUyupoTOUF8sK4J1M/ebZ2xJNox4XPqk1UyS1Sea+RT9cZ60I0j2e+KP0Vo62fkyaT4fm4QdEC1/ZSey64mdYc5HRAQ/eSRG8WK18y9ubSAynNlmTEshcTccYx2gnRki8LifBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jwy6FghVflF33wfmZF9S6dbqv2Wk27Jv8rH8zdbO648=;
 b=ubnSGuBLQ+/6grTGkl/Hy497dlp5mT8gmfcZioE77ZfGlh4IVzrM0lYwIOT0cTGETjWEpneeeAlrnq4WiKF8w9X5Rms0s9hO/D5GgwVlSOnlKOysMe58FZ9JF/I31uvaXqtOpSBvHr8sM2omzpknxFmHZaFf9ojukp+G8npU7WqP02DTJUjdRFR+wrdHPCJMbS/zQhrZqGxpC+wmCdv4qVLmORgWn5WYfpP7CM8xF5nZyvOM9xBPXoPV5SL2M/s7dEkemwTMMkI5nmOgi1t8Rq1pLcThK2ZYL8l4MrblWFHmB8gOdeMqZkqjo8GMBF3zaABGTj803lWXSNgrRtzPag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jwy6FghVflF33wfmZF9S6dbqv2Wk27Jv8rH8zdbO648=;
 b=n+d2g3lFd6jRQjWPoXI1PosBYPsh1pTC21A9TaImmdSE26WE/hQT3a4z+XB5jyB3YoDJTxJrWzYo/OgO0QMyT14GJ4UdeH4u0uDMHSZHrDAbc8b80lWLZ7Skq34IC732LhXljvDpnPS+KkJ/cw+t2Oi34Nn7UHnOw3QUdo8zcsGcbgiDbpMsfToalNx6c5EpxMgdpWZPBLs6kwvk3uCLT37+TSQ6Pr0yUBjedqHX8JQwS15taAmBq2UFHHfBHgPHt59I9FIqcnt13BF5L+VWJH1QSpcHb308yZIZY1qxWv3MRWID+RZ5VwqVzr6g76x0fiq+hXr2P8T645RZ2QU1cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS4PR12MB9708.namprd12.prod.outlook.com (2603:10b6:8:278::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 15:54:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 15:54:16 +0000
Date: Fri, 2 Jan 2026 11:54:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <20260102155415.GB125162@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aUW78ZV2D5aM75yN@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUW78ZV2D5aM75yN@Asurada-Nvidia>
X-ClientProxiedBy: BLAP220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS4PR12MB9708:EE_
X-MS-Office365-Filtering-Correlation-Id: aebc54be-6415-4eac-eb9c-08de4a172ec3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cw2F7j7zpB1TRotKzV4dUgzn2QRY1Z9jyGvDFnQATuGoTqHuD41yyNLTNTmo?=
 =?us-ascii?Q?puJ8h5CHakYUGjJiTrEwyevkqi+MZvv2eEcYkExCABgluzHGoMIPWgYB3e4z?=
 =?us-ascii?Q?ZPghqi5YYgt3v3d4D0LhimDRBS/PYpD9VowmBdNN/QhbvCWNJDzCzCze+//I?=
 =?us-ascii?Q?SDtpMqt2V3ia4TCrxTBXI0vBNuMaBiOoAKOOTBzYBCrHVJjGy6LjTAJf3JQp?=
 =?us-ascii?Q?tUcWax312lk96BBwthZo45QraW3VhZItsoeF97ui530bOjjSqP2DLYUPKkKh?=
 =?us-ascii?Q?XkaZylf81piEQSqmGjE0bmHIGLCL1Muqcy6uAEg/uCTDgwy59OMTBwFDYgb/?=
 =?us-ascii?Q?mr++TsVzMW3LDg9CgdaVRdt+Z8xChbRgI4KrOPCL1TA9CgkZKYofKMFOhn8t?=
 =?us-ascii?Q?QvC3fU6sEJ++i+zBV0CMu0JxOd6FcKm89geR2S+Chyu09F8EOfn20ZjlMncd?=
 =?us-ascii?Q?kg6kTjBUh/tuEAw+uQf56forpkbUqanTbVcf3SLQ705FiLhzrC0Ph4mIgGqQ?=
 =?us-ascii?Q?xexcs8FxEtZhAiM6mgfJZpxOxHIY4AnGhQ0CdbgSRspUolgUknBjlDzwGTjn?=
 =?us-ascii?Q?2dEZIeohJDtMoAuSNe6V78Jq0i5GkGkOH8BMzJ9cwjUznuSCJ8Ocgxbe/F8K?=
 =?us-ascii?Q?xLdpfr0kYLm4zIqZVrSCk82HbSRszHP+8tascZyQV3Aka3YlcjJznD4g1xIo?=
 =?us-ascii?Q?iOI4ABACulOyiv1y01IjLrfGAjUifvlSaC1kD2cFgSv5Ljdr2+YvMGi2LvUr?=
 =?us-ascii?Q?wVCPjdRSoQGWqbj2cuXlm0C9QgYCRBDkDO8sstfjNmFcIdXrtIU51MzVA7AG?=
 =?us-ascii?Q?35Hs3YY5j9zwGecgM3X1D/K1FOYck3ImzgWN2cLqnjI7NdSQmur/ej0oORzJ?=
 =?us-ascii?Q?NI8ypG7j3+2jCZDjIOjSWAC1GbOOmIkytI35SGm4QeW7VlJbT4Q/8QmEfmMv?=
 =?us-ascii?Q?u6FLS3ENbiuGuzH7PwAzMcrU1TG/g8L6JPH7WUOMmNeIxN5MFP+d2eKzQ8QN?=
 =?us-ascii?Q?trte2xZW0Nim60H/8w5d3orWp91doANufa/ZxNbwVTkFT0esnDy3ovYKDXGd?=
 =?us-ascii?Q?G0h+sfPucYoj0xvSYu/ByHNFe4rH8lIHSNO/vS4OcEsEIripLx6tgJsuumPt?=
 =?us-ascii?Q?2SoByGjPsTE2PU9T8rNiTyDuyrHGgE07sJmmP38IL5/iU2e7V2TKlt1hAiDg?=
 =?us-ascii?Q?A0pxfVvrvCnNMrJETlzFT12G1O39u7UXWNAehO9gE2ryC4pnTfNtPm8qnN7T?=
 =?us-ascii?Q?DNfimNBIvg3/OQ5fc8EqlKFucheGp9rLsMQKDPNtnPXBK5Eqmwvy2j6wp0Es?=
 =?us-ascii?Q?9nRxTCxjSxZMVQguhu/CHY5KjVIsFcmL3PFZj2yhidXAOCx/gE7EzKng9weR?=
 =?us-ascii?Q?C/B0c9ppDKG4CIHeOf7VHNPQpBhAOmmfgjEKvZCdcN9pCt1tMZdMwQQICYlV?=
 =?us-ascii?Q?eqEL6H+eDjGJaKYXw7W4+nkZo3isTq/r?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WuBnLhkNsk1soGwXLynPRLWbJgVPXJaG1NB1qHRO5RH7+HBCqqzTSOOPkDen?=
 =?us-ascii?Q?ST9cQapOB4iYQ/dcn9DSAtogIutsuVOckVpzRGY1mwnrefjcHMm4v9Lz93d6?=
 =?us-ascii?Q?XFpiE+sojdhRi4OF3rtrB3gMWhHywv4IdZ1+dYK66RyWdsR/SXhr2CgzuDNx?=
 =?us-ascii?Q?8oC19yh2NZ7dZchuttFPq7MPgtkmd9tTtxwJvAz38ECGSIX6pe1w2ipXSaBC?=
 =?us-ascii?Q?hw5S/nEZYimk9Q4v49WiaML/5SltY4i7WhdDe9yfb66BJOvrcynq4SQmsvBx?=
 =?us-ascii?Q?BkUnu+VbCh+opQwt2r0AMsUjCpV23/8NlJNFSJ7DwmIAk2aNE5ROQQkk+tv4?=
 =?us-ascii?Q?IVuWlqqR+BilGrQMmCLSXas4dzb8RGo6g4EQl9DZxcgeW4j9vKkQuTSfV3GC?=
 =?us-ascii?Q?6S/hLq3ApYNifRS3ZuyLUkHG0AXuqdqTCQSqN8+/lqqTYr2nNGyNUapqPV43?=
 =?us-ascii?Q?C2RTkFmfY/7xrGEw8sBeQX5Q5YxR3b83VgKgJkNIXGUPR3BY7lkVlmPXvjNI?=
 =?us-ascii?Q?ix/uk6OMrYiLZmGTO0HYZSxf0SMAaM/xTjC7ihQF2nH26Ir4oGFl2CWTzE8k?=
 =?us-ascii?Q?XAj4P0oDKif4uphKvov7n7hiwpoOJzgOp/DliU5OZPiU2mfu1oblJVxGg53A?=
 =?us-ascii?Q?2k7TqxY/wg0KvTTBrl2Cprtj5azXnYWEq4EB6PHLETF0bXzoIMPlN2LqPxAK?=
 =?us-ascii?Q?2ZvF6yST4XEI5yReXAYXK8m0N7uqjQpkpuTdIOCKd6ZQ+UNkHY9MADHVz6hK?=
 =?us-ascii?Q?hIhjHb4BMCnaBeh3ZBjAP//yuqVZGVGs14sKrc20WuQ4kYOGMDNeasm0Hymk?=
 =?us-ascii?Q?Hn6iBXNTnNMjlhhb6sw986/DZJqOvgGv6sVeB31J7dua11ycQ7M/sNSkwNfL?=
 =?us-ascii?Q?ReTJLYRqKEKtMNIVaQ0cD+Qn+cq2t2Rbn7ClBBBiGixbzqkSCDDcStzXBLiJ?=
 =?us-ascii?Q?ICB0C45ccwmH+WSwYAdSklX5DEqC8CUOpUJq6lD02BTOCXjy6wLXzm3eLVDH?=
 =?us-ascii?Q?CCMJA5Tb8AC53lhsCm12f7j3LJN2C+eIGfOMX1F38FFkjFk0nykWceNJMOni?=
 =?us-ascii?Q?UElWTh18vlevIdkbPjhby/0UXhX9dajBqllXglLCHHOkEV79ev/mE97N57JI?=
 =?us-ascii?Q?XN804GtyKcOQp2CQZoKjqovnz5RiCnShorjOwZZHlsVm7qXrlBf8ff1OCrhz?=
 =?us-ascii?Q?RqgGFXL4DRgsWqBp3QJHYohoR0Rj86rmx9SNRVju97HzMx3MbTCF3ZE0X0Wd?=
 =?us-ascii?Q?RSwL6WhyJi65ZMORuoe6N+kgu4ED5octnxxwx6oFt+YZ9LlDYfqt/I+QZZPT?=
 =?us-ascii?Q?oKo6sNGTMIUAymhBrGbQNM5P6sC4UzUmjxSutZNqKbJsmuHOnKtvkFJbgKT5?=
 =?us-ascii?Q?idwQb/ZmGhVVspCL3YFwsOFRRCARk2wdPAk9WmlB1HZqXAgiZRBQPn/vXTug?=
 =?us-ascii?Q?0VX8k9OqdweLtT8dkHrn/rb7TzJIEv3P2KJNPXLCusYcbH+YWlJ+w0UFnC7S?=
 =?us-ascii?Q?LIQUkDS4bno7FHzK4muk76YOVzdPqtWKysqQR4BYggwoOB6+PSZwnxI3GC4D?=
 =?us-ascii?Q?dzkZVi8wS6oSnbf0M9sESDG+RXeEHv+EUKNy5C5uN8A3pmp0rLiMBlL8KUkg?=
 =?us-ascii?Q?oUvMQ/8QDMd0ROWNKrKcUvo4PdDfSP/VF+mS5Pv6tivViNgNeQRzcKLKaCHm?=
 =?us-ascii?Q?SSxlwnBM7KP8sK/5TkVi3cSDny9esLWcau3Q7zfnQBFXhzC2UNlPDxEwheTT?=
 =?us-ascii?Q?USlRluHirA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebc54be-6415-4eac-eb9c-08de4a172ec3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 15:54:16.5461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsbbWIpWyf8Rnzmtn0Zed0UtFxEkzz83ebv0ShSIEHrZIHBnALrgqrvtTila7+Ca
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9708

On Fri, Dec 19, 2025 at 12:56:17PM -0800, Nicolin Chen wrote:
> Again, my intention is to avoid iterating the array since merge
> and unref functions are already doing that in their first loops.

It is not a performance path, and double iterating like this is much
easier to implement with clearer error flows.

Jason
