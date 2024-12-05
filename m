Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8070421C18D;
	Thu,  5 Dec 2024 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413416; cv=fail; b=qs1oeaQi9bHHIocinjAH4Lzc7v/pV43RK8wwrmmppVyLFVE0Hhb8gX0U7uBecuK3F09jybVwJj9M5k3YIjHmBjbacX2dNMt8JFkXH9gzxdBUiL/tm9Bq59ZCPEZnYHb/cuk46o7Jg6HU7gM+v/jw0nK+Ex0bWmOIO5+wZY4sBGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413416; c=relaxed/simple;
	bh=u1O/gSLqo5yHsKIF3vcrWbS4wA+HYQ/Gyfu5BNDXO80=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=T+L+eUfXAHnZm8dMj5MsmmLwFLozR65+D63BKkVPH1h2SHkKK7L57uBB2YjtChvXMzoXKSjDt9JX9u8LeCjkHKCZYXgWiJr/EnzF8KrQQBbl/DP1yKqciolJq4iw371l7Ux8Xi6h9UTFNBKlb5Zg91Rsh19h5gx1Zsoe6vB/PHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ro4JaWP9; arc=fail smtp.client-ip=40.107.223.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ro4JaWP9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DqciTvhxmFZPQkgyhsH4blrF4YVRf7j5M3TdoYz4BbugymOx0Tx0vm8SHyN1z8CsMTrLNP45Z4/Sps1PiEm1TeEBI3/gjDOdRiarvr3NykdET67qwGzmffFbkZFn9nJa1R4O9sLI469C0c+dkAeoeQGJLWlmuod1BqLkQRluwIBOiFEyPPPsGuVypdnvFrYxIsE0MJAapywSz3TZePHtlrrTneflLiTLAZ9SI6jrUfPDw9MkPHA5O9RKeSkdpwssoHcPIO/VbppZAHBu3ZE3DbxVnjOZ7FnHAUiKYPND6rObFc+Yp6llSyH50RcwykLczDb6RBC080CJ21P9vvMAig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Noav2HQUcHZJiki1tCQMOrsO96l8F8V4icPDsKUliqc=;
 b=ZGyFw+aKi2/ROIbhVNI0nDPIdqFq4FmcinusqMyQH18XMTcHUDeFailtXawfyRx97qoycD9cmLqWxHVyclWkwPthH3NKdmKIdU+gtn6xTdR2t9N+bHVZcY7UGZwTUxExODCG7zKdaAW2uKkVahE9PWyWjFSdWOgkdAjiX2GQMGlct9JqxPsDtQdEEBQJIPJEe8nMDG5nTW+3bHd97gF+gtv4aJreUBLMSSTDN0cxN8d2KnjWwvq4yqH2pO/MtqIF/M4wnNkZZfV7OHEQOrG0eaKR8412rmNS+IPA0EGNGzig6artqZSnzKFl3ufde2HvITSE/3qhLWkr9Zt10ooiiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Noav2HQUcHZJiki1tCQMOrsO96l8F8V4icPDsKUliqc=;
 b=ro4JaWP9tq2Hbx6KBpJYJ0oT2EvUFearC2YaiHZFpmo1rShM3+l29wcgFNFNRxrq3MPeIv4FEKJPUgF0XhWdBEl0NuMlNmxi4BYUo5a8POryv8Grmyzn5/Y2883Z5YVG66EuC01VUyyxRi4ssTq3Es7nCavY5PffyGBsKcFJEKRLr976T3ts7dQqTALVU+pt9GZKB0sbd0vvVKsLa8UL3TG7CJMdFeln1SmTAjwfuhxIk8aqH2bvMFzt17yVZU9NpDqZ01oyhhwk5mNu6u1xKNzkxS7TECJxl9qZqmh24A8wtQVIvcgKduonkeb0Wq0O+z6cIwX/9DZGBwoJFzcl5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 15:43:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 15:43:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 0/3] iommu/arm-smmuv3: Update domain_alloc_paging_flags()
Date: Thu,  5 Dec 2024 11:43:26 -0400
Message-ID: <0-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 9752d590-f5d7-4a50-c674-08dd154391a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pnTUj3Ba3ZkK6YYicH1ZmbmlY0ZxQWEhNd5roo0fdI9o6Mfz9CsmziINR7eE?=
 =?us-ascii?Q?QRGvdS82kxYx6esBcyYNwEdtgypex+MsHxiU3vA0L2QodKm9NvTJx5TgXilT?=
 =?us-ascii?Q?/sLOq3YwTkoGm6Z87c8HCDnqVO8qCFniz3Pur9CQ41BKjY3Iok5IczTXYcxi?=
 =?us-ascii?Q?hzEwvjx7tUECSUXKY+DmptIrQryUUpZQsMOMzlVC6lrqEDs9SDB5qy3bScsD?=
 =?us-ascii?Q?ZLMbos2qQjiP0AtALbHfzOnDLOyjSuBj+F35ELIs69LBUaolWP17VkbLSGqE?=
 =?us-ascii?Q?3HMq8BT2yRJtP3Qy5n0fz2usgdwa/Pz5tjGLHTYGSU7C49gUu9Lf9Dopn5Ku?=
 =?us-ascii?Q?UQGv3Md1kUxRHala8D5/rB2yFNYqdb8RDbN336WdB1DbSE/VY9FOVZcrDKNI?=
 =?us-ascii?Q?g/aKLXxZdNDVJwx/HRSczzggBv1EJw+v0TyVRgZdJvO80PwfIBdLRydrPpkZ?=
 =?us-ascii?Q?Cqq4S/Qnb2/zNV2JYW7IW5usk8RL/Kd6fH6gx/GFL3DbhmoWFACs4BxCFUCM?=
 =?us-ascii?Q?k3XgQdjoM6vG1f2LvE+rE9sp9giOg6g/6uW0xSMOg1vEVwYx17NfBbuieETw?=
 =?us-ascii?Q?nijPLJq5DSYLxFvp2Dk1kaGXOYZGBRzbBxXlqwUfIQ/M414QbxwcJYaGaANk?=
 =?us-ascii?Q?2U4O2rqwUU/548sYKPF1291UernpelhY0Qimu3hH9758KdhE1rgebdmxcDbs?=
 =?us-ascii?Q?hvAQKe7FDcz2ntqTG06CjcyeQwRrnbCLSaeotfZXshb2IGIeeOFluUuAssr8?=
 =?us-ascii?Q?YeNXn5WjO9kKaBV2XJiyuqGFxkX1H5hCiMJYFMqSwu7WjnLOklGXAs2QlTGV?=
 =?us-ascii?Q?dRQoGuK0TS9068gbyv+j6qbbl7y85J6px5uUJ7m0X30dVE/NepDM8NhHFq2s?=
 =?us-ascii?Q?HZngWTHG2NZxwAKbyahgow29yQP+6hLGZb/x5vBjpHCXE0TSGdnpvRjQxdkm?=
 =?us-ascii?Q?HX+opOvwfJEZ2VVky84UyesdBtumX/o4c2AIEGjvYdD5kRYs4Tuz3zV9WdoP?=
 =?us-ascii?Q?pkh0YUWlznXDjnPNAEP4DMZZkSNManJhemB3JaRosskgQswEbzXoFSjxDSAc?=
 =?us-ascii?Q?1GUomkyy9huW8PCAClQrvWlBYeVGXRpJTS6RAFPJ8BFoW17JjYYFbMSJyuz2?=
 =?us-ascii?Q?84wKIcOwnEC9OyX+XXJ4ZhI3IU7hQzR8N6NJ/NZnvI3Vj60dyxnJYjS4F3CY?=
 =?us-ascii?Q?pL+KoWMu6zItllZcd2paj7331Y7FaH8svWAjmva2GSgbMQkOYY8dan0rEd8V?=
 =?us-ascii?Q?0UtppLaB8Kcj0cLS8anaUwKokgVVrcbhWS3RNACy/1Qg+LMiB1OpVFIHf/uk?=
 =?us-ascii?Q?8VWtPS9Fcm09NpTdUDtLyc16fCk06Y6goEdCCACMboEElA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bT5l9LcR32E3yYjJKdS/V1xv1teoZNz56qTFg26dExjSA1G/XObCbVEsfH8h?=
 =?us-ascii?Q?Qk5xgAeHUuvbD4Ppi/K/83qdpKDs52OdfWjdaDV7IBNUVkQBbc/N4p66KnyN?=
 =?us-ascii?Q?R5iRdmzXO0Uzn18gLWCZmzv1xckbJdgMwASAMoqVKTnaj8yNWlIfb3f1/1Ip?=
 =?us-ascii?Q?HYJlDMG26KaBAgIzsF8SVkYvbLfA/JGVRmxrWTgmkSgh0B8RY5GDjwtfvPEp?=
 =?us-ascii?Q?0cKXLqJXniAb3cXR0zHaij+OFVgXVyHMP27rSEYYmDQrnbkFZRilmOlyWgI3?=
 =?us-ascii?Q?0DgMc0vwhpE35s2RdHnSWez8GCN9EcB0U/CcQWJKEd8uspZAQcKqDG9GzjUN?=
 =?us-ascii?Q?TGDf0QYKOhDkDkrnBRQ7aoeNgCt5GWR970sY/tGWRIifhBCpyFlnbYXhuvnf?=
 =?us-ascii?Q?khUBHOVyPoFvL5Bx3q5qPCDNzZMmu8bLTn5wAviA8ZdDmQNCi/JHtSTkaIdO?=
 =?us-ascii?Q?L7QDva7I7r6P8ZJeqXeNsguwbdWxRZ145WHBe4WEz17+px2VheWkDaBIKrxh?=
 =?us-ascii?Q?ukJO8TR6qeQ0J0QUzCdEK8z2z37gFsvPQ1PMo0mVL2GRQnKdDY3FGsfPi+SV?=
 =?us-ascii?Q?nqTHFDvGX70r7+ptXiuyRRXfGypmg5fudhc4LXsPC9khAn4//tv93QEIhrTV?=
 =?us-ascii?Q?0UFZig2D3IAdU+tpi+BYqwt189OKb62XG8TLdgJUMQwEqm+nllbywkfwkUkv?=
 =?us-ascii?Q?0pREyzowbeUXwKLjKneECUBW4sVcnCc6HuDtLO9SSSw+GiBN0i2t0l9xRtqw?=
 =?us-ascii?Q?LMA3Jm7DHzLG1WByjOppzGYLQ05pqX1I4g4AEeiSYNKMr6mPWNDbpeJF7pIU?=
 =?us-ascii?Q?YerUKscVZTrptvpqqxh7IxYPiH/9CZE0a3xD0OSRniHQrwck5Big8awixQPD?=
 =?us-ascii?Q?tiLsrNsq75Ns/GZiHOf/DLbMGU4fe00nj61F+NKAWGTvftJJ6tVtlA6bjJy3?=
 =?us-ascii?Q?Pt0mdA+KeEzL3I/YGXybl3wM81wsnpdkn10kS+j4WujeAEKbPdnpNOAKn1ou?=
 =?us-ascii?Q?gaJfeyPhgAojoV68EhdKOKy3InkIXvlZ0a6cknwN3twYYrSCxzX7VsmiC2vR?=
 =?us-ascii?Q?nNx2+lYJIVDH6uD2ZMhJPwsnPXyAgq4PKeV8C1y6OzZQTd1N/1aJIqnaUDnj?=
 =?us-ascii?Q?nkVrO8QubFxQRBQRe6+dH/XQyVsdPl5mvRWDXItxrzmvjRopWR5ahUTy0rMQ?=
 =?us-ascii?Q?nfGL2bE6GwzNC0H9cw3BjwLVORYnRFCX+S/6/QxvfsuJ2l3QVbG/8LwNyDB6?=
 =?us-ascii?Q?JiPXm9nX8jR+xLma7ZzodK5inWUkH7k+B7UX/IRUvTRdNhQW6brPMp/3JzUt?=
 =?us-ascii?Q?pr5C60JB3gX7pr4utRy8rpVoOD8v2AH0VYEWXporCU1O/O7dcNs8wQmhxM7J?=
 =?us-ascii?Q?asfGW7wbXb01cpWKArjKXx2gu3QknyCTMmuoIis/ARbO6BXbpZyWyP0L+LfL?=
 =?us-ascii?Q?S2bAmTTN29g3o0sd3MpP2nmHE5b835/39wu3NUilflNdWITLLb96DRAnjAQm?=
 =?us-ascii?Q?U2rzQgDIkGtP+5z8qUcTone1N8IW6l1NZ3gT9GmL18lHbkVjgiCVyGTO0GrS?=
 =?us-ascii?Q?vHCISkXxtAIT8oTswDkefLYlPZxWP6rT2ZMKLe1d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9752d590-f5d7-4a50-c674-08dd154391a9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 15:43:30.8542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwyxdfwM/GzbuKBpbzS31BZQaiJgY8eDUf6Q18lKuzPoq1quCnIdtzevA0Xrmm39
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789

The last cycle saw the removal of the NULL device during domain allocation
and the introduction of domain_alloc_paging_flags(). Update smmuv3 to this
new design.

Jason Gunthorpe (3):
  iommu/arm-smmu-v3: Remove arm_smmu_domain_finalise() during attach
  iommu/arm-smmu-v3: Make domain_alloc_paging_flags() directly determine
    the S1/S2
  iommu/arm-smmu-v3: Remove domain_alloc_paging()

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 88 +++++++--------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 28 insertions(+), 61 deletions(-)


base-commit: 121ea6330bec79ce3376959196360ca7114c7ee7
-- 
2.43.0

