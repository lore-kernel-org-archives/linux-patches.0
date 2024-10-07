Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2082.outbound.protection.outlook.com [40.107.100.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE771D6DCE;
	Mon,  7 Oct 2024 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323009; cv=fail; b=hiCo+ZgA3Jk/KiTOGgInOpaDPY4Yv1ajVg3mccndsOz5v0jKnR0eg13c/pw15q3SPP3YiNtzP6iSl2otwssmaGCUPn1PYEs3IJmonC2sN7++aW+Gf7mrzQDt8oETzTr0nQ9O/DceGSPRpESLsX6MZUWDbchJAW835e0LZb0DsGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323009; c=relaxed/simple;
	bh=rENpS5qT9gK0St2KNbdRdQKW71GnC9XVgpEa+wCixns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VszEk2DqVcUMcH8RH/hvOuTRmfTjXIUAxbiiJOw9ti0bUgFB32fxLM0lQPM6KdgRiykEcHsc2jgYHWzNmjCBCZbvtJ0pbMmi99Ox494x79Yhe4vI68u01UpMnkEGbAv3LEYcTWTs0a2UUb1Qxw9p8T/iQWixzc0YuAKD1kXmjJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NKs7Pqx+; arc=fail smtp.client-ip=40.107.100.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NKs7Pqx+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPQ9A8lG2gg1HH+nZ0U2J8H8SlL0yeQpG+Vkkc9XNEKrqfPzGIleeSBCdGrHZCZ4bw5MsoO2IrbJGmxJRVmONj4sWfvMS52jlJKeHSCzlt0dykkImW5OhLunDgVS6o46Usk9WZ0z7CPMj/JbrxbJ1Yxtjrhi9vcLP8sfm5uI3TRsrmU+0vqV2GHlz+hNYDmS7Jbv8Gf6UrRHdcIim5VRwaZe4+MIJIeQK7/GVgZfv1QA62ngtNzU8S4ii80SLcZ72F5lo6a7+If11RiU9rgiA9qeIfKBj64E14aLnUSGSX+ktBUN5yTII5aWhlJgk5m0E1n9yNPMkOE/h3kJGTYhTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwxBJ7SS7rJv5PazIHyCOhehomu7lxutMzzsbAtPd4Y=;
 b=XnOTrAyT6ovD9+cIzpobRQoxTZ3DgqCkcRRxYsSU0WCsCGGVgdKDu/5+miu9iRHMhYczlbiLgRxvBxQC6qWUjHsAVRRNNsr8NTG4hEukR8d0Q0RbXmg+WLa5+bnKkOGQeKg01ztzvQveAARkGdhxVgS3CK+4hGTsgk4dSGkZrgBmMzRwjUwCwn2ErtG1h60MoSHmv7KM/7n1FATPPDKRaLCPCEHKebSzvjvCh8qnSK1n6allj112oGmf5UtI2fdHkMuefVHtovCAFBaItgNH8RGyOOOVwionHkuahWO2CseNlWjvvsWFzbKMY2t50n0VexEHyQb6oU0bijQQMqwpYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwxBJ7SS7rJv5PazIHyCOhehomu7lxutMzzsbAtPd4Y=;
 b=NKs7Pqx+8IpHOhRcdmdOAQpb/RXKyA/SYp44Io4s9OPqUGRNAsKUKoTVKXgYU1AKCzhY5syzvWauOx0VxkLHCqQgGnaSowJWZzEZO/PcxvkjuH2hAn+HPm57leknnWtCC/OoXokClscHUrliqyPMcJkZ6e0ILXKULn6w3AZlVEuRKvIhCKbrXN5+wroqU6HrfKnfXzqtxEZzWjfy/wgLjFyDIo9bnt/AZ6ajaOxtMi0KUydlZy2EDTC3m07W63r/7XjpLBsR5ZjgQw8AKBLIWgIU1CwCP+8o9N0Bmo5zVGnzZbuiz4sT2H0yBVD3lrP6KYoFncZ/oH7bBjzCCZZ49g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7725.namprd12.prod.outlook.com (2603:10b6:8:136::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Mon, 7 Oct
 2024 17:43:24 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8026.020; Mon, 7 Oct 2024
 17:43:24 +0000
Date: Mon, 7 Oct 2024 14:43:22 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v9 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <20241007174322.GC1365916@nvidia.com>
References: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <20240702145705.GA4135@willie-the-truck>
 <20240709193905.GL107163@nvidia.com>
 <20240906140853.GA17187@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906140853.GA17187@willie-the-truck>
X-ClientProxiedBy: BL0PR0102CA0072.prod.exchangelabs.com
 (2603:10b6:208:25::49) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 47ec1f89-bc6f-49c5-8aea-08dce6f78aaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vg1RR+CaTz41+4zpHkcz4w6SnKChMJTzEJUv9IsodsNX2RXnvymkVNLlfWFn?=
 =?us-ascii?Q?W63ttrG87MFsqH62qW/Ra7oOvo1kiBA/xt3w2RY5LLZVxHvfwFdbQ59FX+KJ?=
 =?us-ascii?Q?9Pd6Rzo2aivX/nSX/Ij8dwz953nm0h7FRyOngEkqqMEBzpc+FNpyFVkbJQSl?=
 =?us-ascii?Q?Ym824sw3vunU0k1IMoBgRMfQ+Mumbc+RjxJiubWBh4T2nVzp5ci4hNGUX79/?=
 =?us-ascii?Q?FAVIABTw6bsv7xN+/LB6c+e/YNUZDmFYFH4cGzasNOxR252M4wJyC3iPRZUV?=
 =?us-ascii?Q?16buat9cWMWnxjeeIeRAcU3HkLJgHAKcXA8Bj+RCOy4QBu5XNr/6V4tlVgFL?=
 =?us-ascii?Q?4VCIix/QHN2wngCej52KDWN32jXZb2XJmpeC3B9XY9pQT/r6qJOVSd+BAb9R?=
 =?us-ascii?Q?lc5uiDqyxC9ER76n+Q2U2i2lQgzNjK+yQ14qs9NUY1QBGFwOzIuTUqAqRc7O?=
 =?us-ascii?Q?EyowmTOqOtSf0smaTRrqpvMgt5KvkPgt6I65gcaTXPCDsqWx/ZTMR2afWJ/t?=
 =?us-ascii?Q?oRgL5cjq3CRsYaH0jMBsMhHVNPRM61Pc4rD4Yk7lYysEHaFZAIwKG0WzC/r/?=
 =?us-ascii?Q?DEpvPzPxxOy/pmMjnoCtV3QUqA3DnfeSZsw2o1w2F6+4aJ9tmtLzs71go83W?=
 =?us-ascii?Q?+XhCKTTPrurWqIkGjYg2K5fi241awTCb0v1IXoNklWt91Lm4tCQ0Yg+cETBr?=
 =?us-ascii?Q?GbgiVS4f/eMrgqvMFcNMfyjpO9IyEYPtJx4tx0Q7ckS+u8gE+6eizslYEnwR?=
 =?us-ascii?Q?IHSLkvus2CmXxPL1vqwQDX3T0bUMbSUqec2R6JeiqaA2rhJyBay6MRuGV+1O?=
 =?us-ascii?Q?CnxNFAqHFmgMZ7sQORkTXG7iKg6clg0bS9Hgru6BANU5i30B1VjWBejeY/ya?=
 =?us-ascii?Q?OYa0caUepde7RBic7uJdtW80Z259pfwuBNMEzBuj+zqO2SzxFL0IHmbMW7Ev?=
 =?us-ascii?Q?wu+FuskkN57Bq3i9IGwUpj9n5xoFqbZz5sHKFci/5BNUxflJoHO46mLsDof6?=
 =?us-ascii?Q?gaWwIf2MDqXFt8PGJJeCiNANxhWCFmToZBxfitLcjeljyIsKKTGpBfSxEHLO?=
 =?us-ascii?Q?WNtmIga+sjIdJioFKkGEFoK8Jmi2jKX9vMduVc4jlYVtxi+u52awqa4cYjOh?=
 =?us-ascii?Q?/Rg/p2BVQsO6A3ohxPH9gIR2LhJ9+Esw7hahXYhWh5J7gnlZcsPeCxeKCebE?=
 =?us-ascii?Q?IA0Ayun7jbUbhFvOejbSnblez4MGMzMiqWBkDQuOEdw10U/RK/hDJqchZPrl?=
 =?us-ascii?Q?hmOhVyO8Pgl7rzM0W0yWHyIJ0Y8mDL22C/7CaSR/Jw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o/EC9APNDy4J6kWglR785bRKzYRb3IhFjckg6CkOwaUXhsdTWpJZfXHRTlti?=
 =?us-ascii?Q?MBkSFUSiTZ+4CU3J4m2Q3HZzJmuwaLgu0jlLWb9np6GmH+rfVQAlcuhtKcA9?=
 =?us-ascii?Q?KV1YtpvkGQFYtbqkHyZ/8b9kWoYVdnDtrOESG+62E3nSpXnnH+EpgKfiGB+A?=
 =?us-ascii?Q?1piFj6S5tCYSR9X6+TNIgu0LKF85qRcy6YdXsQ7AmUHHb4graOaP0IChh1Xc?=
 =?us-ascii?Q?tl/Xv+tnKwAFCEwfk7OeihcmqQClANt8Nryt9fec4XCp3azpovb1G0lqe+Cs?=
 =?us-ascii?Q?zJ/ImxSVp7FOnvGFMZ5NFPSNZg0JLKoVgKqZUPiwcgdGY0cQbhIvfx97CV7U?=
 =?us-ascii?Q?QpQKM6i6t9MtlqmxH3r+/pjVt0qeiDfdKhn5/vMQLRxM8DjvMdRK2QM3MGgu?=
 =?us-ascii?Q?UWv+wrohkSn769GCLIPvAAfGSPH4j/UZNRerB9RifgVcgH5KvMuGb289oHIm?=
 =?us-ascii?Q?iGKee9saG93M+0V/9HgJ2wnQuVZbI6xOtc5W7miP/gMu+gYhaLn6IAzr9tZY?=
 =?us-ascii?Q?jWrNhgDT+nnn3bm7s69/aZJiwXnkQp61WLK3u+G9uWFABIxmlsnI1DUIvhh+?=
 =?us-ascii?Q?adjiVDuPRizAV8aBMRK0pdC7lyOqtns58AFt1YVobIA9KPD//8EinIhojPu1?=
 =?us-ascii?Q?t24Tx7eOlVtU1CSrxi9+BW2oS28llin5KL4G8kWcYi3lFeqWhxwKTJRuFQZu?=
 =?us-ascii?Q?T2PYLA0QZX9I6URPAfXXh9LlctHAUXRFhkUjdbN0pQqbzagLZQHp53yenQPY?=
 =?us-ascii?Q?GbT6Zhkk0svipaw/mTi4vnAWJJNlKW+EkcWPg/cTyPgIufdgvhzn/HSjFLp/?=
 =?us-ascii?Q?TQ3MYQ7Z3vLgMmVnZjJ5LVwV+kHPI1Uv5vV+pZs4GM8IRBNzffP/HR+aHG9q?=
 =?us-ascii?Q?848kf05n9WkTdFASDAjoS5WmMvW7hXMLA3jnAAKuH/hqzFbRzTiNzQq8BAST?=
 =?us-ascii?Q?LfLkVcSwGmliiRoGFo44JVnqh8pCkG4lfy57+3XM96O8NcEjRp48W9RNPszV?=
 =?us-ascii?Q?1KKeBoStAYjWMu89VLy0R2i03NAdHLdB4Ptt2QuaAvmL/qNGpSVlWFQ6Zdy5?=
 =?us-ascii?Q?PzIfdX1cL6QOfsTUQkplQepCcOnqOq4b2Lpa7gmczipYq/iuLjw5VFR9rvRm?=
 =?us-ascii?Q?dqx+6rFqa6lD2KbvGVqFeAJjHbuVB8L5Mk4GJCHyta7EVE2pH9mULiSOlsZx?=
 =?us-ascii?Q?IK+D9teeA+wGijlfid7Pxs06WbxTGxPgMHPM7dP3/xw2THWj2L8IHUSNsn+4?=
 =?us-ascii?Q?qDcr3+umSkwCOFhuy+QMyUUpM+LGpD2hI+3oIxXXI2rlRCWcxE+sqTFal6tE?=
 =?us-ascii?Q?dqCCgmW6++U7xMeELDDgj/g/fEo3H0dpzghISB/jThB6DT1+ZIBjzU8KqFdr?=
 =?us-ascii?Q?NGoDhXjoqCCxdnCwpLrVwlFzUlWt2D37ehEo3BCZ4BjQXUfy9htdJWWGOcYY?=
 =?us-ascii?Q?+Crvq0H+e54nCw5oDcOEKGh1E0cOO6Cc7CDjT+KqWwjA/lvoYbrA1/WO2hL+?=
 =?us-ascii?Q?A+EkoofX58fjNhOk/rYYk4bzimtmp/uED35JRXfPN7YK5sRdZqPldwk/cRsH?=
 =?us-ascii?Q?ech1/pIAgrsGOgQCA9I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ec1f89-bc6f-49c5-8aea-08dce6f78aaf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2024 17:43:23.9502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blQiEcQxvjr4moK4wnfDlLDlx+dMR1MCwaiw4mykWdq/qddntVwQgYBFfU5zP59t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7725

On Fri, Sep 06, 2024 at 03:08:54PM +0100, Will Deacon wrote:

> - We have a bunch of comments around 'arm_smmu_asid_lock' that refer
>   to arm_smmu_share_asid(), which no longer exists.

So, we can go ahead and put back the BTM support in the pre-existing
slightly racy form. I think we can turn it on for guest support by
operating it only if there is no S2 support in HW which would make it
justified.

Or we could delete the 'arm_smmu_asid_lock' for now.

My idea to fix the race goes through making the domains sharable
across instances because that will change the invalidation in a way
that lets double invalidation happen during the ASID change.

I was planning to wait for that, but it looks like it will be more
time. It is linked to the viommu work which needs to go first.

> - arm_smmu_attach_dev() takes/drops/re-takes the devices_lock indirectly
>   when it calls arm_smmu_attach_prepare() and arm_smmu_attach_commit().

This isn't retaking a lock, the operation being locked ran to
completion, we just need to run two operations..

> - arm_smmu_attach_dev() takes/drops 'arm_smmu_asid_lock' via
>   arm_smmu_domain_finalise()) and then re-takes it before the attach.

finalize won't be called from arm_smmu_attach_dev() very soon, they
are unrelated operations.

> Please note, I'm not saying that there's a bug here, just that it would
> be easier to work with if we had some documentation and lock ordering
> assertions.

There are more assertions than there was now, I think most of the new
code has them already, excluding the group mutex.

Jason
