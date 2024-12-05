Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C2021C179;
	Thu,  5 Dec 2024 15:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413224; cv=fail; b=LMjYk6+Q+fpRhUt9J8MtByj5dR3zJdUNKfGK+L5LU23bPKk25suFt0mbP4a1QOJ3W97b05CBZlWwUJNgcQuODXHLcGPBlv5j+yy3pjzw7mNGJjWJipttxzzsJLmKku/toTqmXVqlTtyi/yIIiYMz4uJ2A25M2CriV6HKI0YN4uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413224; c=relaxed/simple;
	bh=ex+FEnPr6WQLWY2cs+GgBNlZwY6MwpvOBay6x1tLf0s=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ap1Ns8kHs5TV9xlhl41LQV99Z3FgeLCeTjF5MDmASRIFiGFTWGSVytxe/GtUn+U/HMLsyfRa1YMWW+pmBKVzQkPdwAATRhGcyEArz/apvmg0mKJpA7wnmbgXeAH5Ku3T6SYMEQODRX/adwv6UJGIi/Dq7tbWjNp5shC02mwniiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hMI+YVKe; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hMI+YVKe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVtSTJh0Z3mLLzEMlZs2t/2vhvFDTD57bKuGzWq7/ja8E79G7cAeksuzgqZvr5CuqeZe69C8I89bK8Fg7z0Uv2AgC4ROLvGdbzDpe2vAvsYq7fvTZ2zhSJ6iQsMhG5PsnF5q5XoJoBuLT34i5MejUHf8OrlgXwYQV9fc5Sm4xdcwlmY9p2NsZ30h5iklWxTKQIpAFLmtMOTux65CJzgvkI+S8eYo1l7XtJRLy4HIA4PMoYqrf075vY3WS8Boo92MICYrwsYsuamSjNkMzKyGpmvvZdUUc03+6Pzq+vSLuTWslbyOG//pJcbhDDNmKYtrrMPpHHDmvxEFZvwyw/V+bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TPvgyTw3LZW4e0wTKdQTd3s8HG+STLY+zBXPkj4Tik=;
 b=MOEJQbGK+qu/H6to5c425425bPDB7+NC+cStY/+Z0QcdxD04+9T/unadIYrE3jF3i4VQs/eOx7nAZ4tcKSAldhBNTAY4WffJxIAnq+KickpxJJz3ew+F1uHJVqqGCzEi5zfgjB3GhwtdAopgsAKJIJF5Box6xlSK8x8DA9kSJbI8FlVCXb3A24PaftzuPozOXhMJa+cKg27GStMjwrKoL1LZl1tTVhCGu55UDxXfMyx9io4O8Ec0kJ8ulKAK3J8NjWmy1MwUA+/xvUFrRo1UljCiXdMcGQg7xlfUp1lP7Mx1WZy31t7CusoOHw2VbiUbOivS3Y8HRjeeUH0yu8MWbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TPvgyTw3LZW4e0wTKdQTd3s8HG+STLY+zBXPkj4Tik=;
 b=hMI+YVKej9A9WRCW3r9VZVM9iS3HX3WIHTGZlZ6BBS/sCIt+4Wesznts+nuxLO1mYtMk6vplE5djXF3ndpk1B9Xy07pG7SZ2b9lPBGCiqt+0gjsj4IOxfO2fV1lwUyFhsHaZzh6ifWphp4zhQNBs04mAObzagViR3zcHDHrCqZOu1Xs1GXikNgjq6urgLRlmzugpiFvX2FLqGChW2bBT1mVLpCRZjdqjlqtRr1HOOi3bPdYHB+p6ziy9up2Kj/Nbb7kp/dBcW5a+EASCRR7/kYUlvi7AnPxtyj5mVeXxsisFpxtEF/FYPmFyO29loSQfwMAOb0PDCTOXTSY6sCg54A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH2PR12MB4248.namprd12.prod.outlook.com (2603:10b6:610:7a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 15:40:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 15:40:17 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH] iommu/arm-smmuv3: Update comments about ATS and bypass
Date: Thu,  5 Dec 2024 11:40:15 -0400
Message-ID: <0-v1-f27174f44f39+27a33-smmuv3_ats_note_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0797.namprd03.prod.outlook.com
 (2603:10b6:408:13f::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH2PR12MB4248:EE_
X-MS-Office365-Filtering-Correlation-Id: 397ee47f-5eae-4683-60f7-08dd15431e21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jOj1yS7QyVzrM7jThCJZ6hV9vV68/zHXmWncW+gEQLDcDXX54l+CERKL9IhL?=
 =?us-ascii?Q?kHdLPrdIfbjaUS7fxHUbfG6ECEJlDcEUzjSkYrBfEN98Q6Se8eKGVCwawn3D?=
 =?us-ascii?Q?5NV+bfdP9KwETI2L8yIQOeY7avqe2kIyF+j9FbdFfvkfxMibbgWAUKB4meT7?=
 =?us-ascii?Q?EjK8GMYGgUUvISWodFtYMBk+AtECZyll//p1wANdbJQ7UTEtXb301A3C7uR2?=
 =?us-ascii?Q?EJeZZZI4sywYhs4AUwrxv+tJa7H68Y+uYJYxdQb3n0rLg/zUIqeG0A+cty1m?=
 =?us-ascii?Q?LkTEWH1In1+P3GjCydhHZRCFaUaoA3NhGk+nNMG/0fambESr0T9+2kmV2yn2?=
 =?us-ascii?Q?qEVZk64OGNCH2TFj8NJJ3Zhn3KklHCc8H1rVfNb80+s0i8N6tT/vbPmrQODT?=
 =?us-ascii?Q?hrLGwfcy4Ayr7WqT2cRXgyBO0F24AxO+TrAnSpxa/gdRCSXmrqH5o2zizIib?=
 =?us-ascii?Q?YM7dGjcXizlUq0UugVzJy4ZoM94AnAcGu766YByrSqbVlENM4HlE9hH9q3NH?=
 =?us-ascii?Q?GRKaFVJcdb5x9OmjaitdxWmwg0jbABQQI+0nZ4S/aWm0PbDpWsMTiYeIT4Jk?=
 =?us-ascii?Q?qXaqrgiBzX4iDqroHsywJWGSzipibxJYuIgWvdjj3UskQQpMuIpQcoB2hCSY?=
 =?us-ascii?Q?gpuGaFrl+EudWUFBgwLJRvpdYB3VplQ9yGYLQF1+TN1SNH5YypcEI3b2kutm?=
 =?us-ascii?Q?OaJ8ohMFLePzKQWWwrlcLgavnxrLqUq4nHk5mUoycnARk3YLwVaoGYSAO3Ii?=
 =?us-ascii?Q?b7mY4GrZSyG04o/aKhFL0B7+1pepLFcCXZY+Jn/c9B+kmjF7E29yHgGkgQT8?=
 =?us-ascii?Q?fSLPDQmok3pGDEQJ9rplf28CvKx2luQ2+MxTkk6cWSMJavV52z/pNM++HpIQ?=
 =?us-ascii?Q?RQ8C/rE/RUi72vq7sf79uYR0vgGZgAhAKAb38Vndo0wWwq+b6QMHulKxdznM?=
 =?us-ascii?Q?BNpF2ocDPCVL6YUdSouLLj8SKScu0sKbOk1YF+h+AVBXDLaC2LaEQjGqQyxr?=
 =?us-ascii?Q?CbyFh9tRfgxhrbTFEsXI5VB/EpdYEUYBp5lDEgIja2OFrtKuE6zRAcqIqhIz?=
 =?us-ascii?Q?5i4qpCV/rBONWL9rl9pqht6ahD8CJdLEGxd5SYFV2vB5GYlCWT3ac/kQNs3y?=
 =?us-ascii?Q?Ndw0weCrPNhzpPA/jy9c1EjxO3wzO7aTf9pltBGMLkWnbrpgQ9zXMQhVFAsx?=
 =?us-ascii?Q?F5QqYrH25A/spYdqOvLD4XcgD0atXX/9mBZoIn4VJ9bEB1tSGJQ+elO9QwU6?=
 =?us-ascii?Q?zDMLC5miOa2Rx1MUtK/W1HwPxtLVInvSOTFupQ7MupgmNS85Z1QmRRrn0npT?=
 =?us-ascii?Q?c/SbuzyAFl5EWtJm2ebTK5b+sRFyGFIm2yMUxWd+Mo4gOA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KCqJjRyW+TME/iDW13+tKzoYca5Ve8BCDz3NCZJAdiXkDvWK1pM1fdprviA5?=
 =?us-ascii?Q?J13WiLX1Zxxa5bbKskBG7hKIRC6ZbwxaXvYtHafF5DmKFCj6PfZsOk3K5cdF?=
 =?us-ascii?Q?eL08QiWABGD0sa5+kyZCmFlAAACRrL4HRqFpYlkO4X86zMwsFjKY7qbn3juX?=
 =?us-ascii?Q?kjfeTwT51AWfQN3pGVMA3aJ5k09VuN+l6mk9W8r5owg3JVgB1+124dmZrTD6?=
 =?us-ascii?Q?+id1EXP3PhAmuLh622vPAwhsrNYD4l8nulYnw8DsxBkulbSbSh9y7mub59an?=
 =?us-ascii?Q?Ls5AlMTMRqfwpxlM7XWWH3FX0xFfbUIQekLYmETXUBdoq/dIhSDq5xWMKJAw?=
 =?us-ascii?Q?Ntr63ca3IpFcvcKW2ofPzJiucYKuu1XrOBrYbO3Rcko+BM4ytLayvSJIuZLi?=
 =?us-ascii?Q?g/kQvA/DGpngp537QEwI6JqW0+bUZdDewOTEgtDtm8ABMrfLXA1fmAE95QN/?=
 =?us-ascii?Q?570XFZ1l+1eJOLUFgeFaR0ISkCG3uqqhNyTF2dY1+q+/5p1Mk40ufZGV2uh6?=
 =?us-ascii?Q?3B72KZ6Rqyh758CnEm/B9SYDKFQai8eo3iq2HyUpLZ8uQ0xZGIN+W4X9U8Mo?=
 =?us-ascii?Q?byjQnNYP6N5eialXIbHsb+w9wj5uEfs/N46baLC8HaJFZXW3skJLS3JrZglb?=
 =?us-ascii?Q?wgCb+FgKh36lOSZ5hufWyal2FZ8GqVX8VSWOyFUWqIbX3guVG1jACDJtv4wO?=
 =?us-ascii?Q?DR1wVeJEOg2HZGZp1hPzal9HOxmaQiAMkWq1kaN99ihRmev5hr+NPf00TYOO?=
 =?us-ascii?Q?GTUhrI6s+qUYq2oQIOcf64SCQFqLEqA/2C8IJSgJPnr6KvdPq8ITti9+/bMN?=
 =?us-ascii?Q?z8VqY/6t0nKZ7v4tn1198Wbm1PLX2Qb0z5HvnhY8swIDIZhKE0snQz35jeJP?=
 =?us-ascii?Q?mA5hYa3ru/BU7i2PImMMP5gV/RFWR5HEuv9wz3U9X1SCvVudO1oP/0plU2V9?=
 =?us-ascii?Q?I9q1LeL7Pe4kY4CHWXTBY7tjh7+EsaDMeLYiLbxZW9aJvq2/1SAhGJ60J/Dc?=
 =?us-ascii?Q?XKj0BD0UgZ19OAFgQmJkiTqCeqdWPtbii/oU3nkaagHPvmPDHJ2mFWZdrcty?=
 =?us-ascii?Q?z28y6zGuOZxezrFqfBtEEU8WB6Dd2EcmxKxNpTa13+nu0n2KZOQ6Jckk/eyi?=
 =?us-ascii?Q?0WG9x32K5lcZjPa1NlDB25bu3nKXHHgHYRM8uGiyqJnYwqG4MdcTrF7c2+wZ?=
 =?us-ascii?Q?9HiO8MKRdDere+eW5+xgmfOKWb/2SmqF+599f/D0zca3cFlhbY14JrGCCZ+x?=
 =?us-ascii?Q?mqaXhbN/iEpMMeR92XjWXbPmxgrRcBsIjT13pastpg2VW7/cp63o4W4SZZkB?=
 =?us-ascii?Q?k2kFIEFqw5NtBDTlJow+E+UnNWPfcf0tMJB98LiCPvfWRUu78TZ4U2nttY99?=
 =?us-ascii?Q?OnuCVK2pKhp659M5KW1DaqF//hVD/k2JCoEuDPYPVjq1LsOug3Vhm+KXnk5G?=
 =?us-ascii?Q?XtZzy+vyFu0qxMtvpHgZT9TcQ+NMJpvN4/HLGJFvfzn0Tv7+kcRFpqllQOXc?=
 =?us-ascii?Q?i3shGvY9HaTQ7qEN2FZblHdXGQfgmcdmQHRxpyDZ8h7U7WNZmiw9e+wn/nwZ?=
 =?us-ascii?Q?0ZEfvPOiglJWRK9tI564cypf+F/C6RwfkwJkyhhZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397ee47f-5eae-4683-60f7-08dd15431e21
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 15:40:17.0609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IMGpQAIKygXhT2XiNK+I6u73owcvaDe1cUHHibJossTUNbU3eVtd346uMAHSkFz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4248

The SMMUv3 spec has a note that BYPASS and ATS don't work together under
the STE EATS field definition. However there is another section "13.6.4
Full ATS skipping stage 1" that explains under certain conditions BYPASS
and ATS do work together if the STE is using S1DSS to select BYPASS and
the CD table has the possibility for a substream.

When these comments were written the understanding was that all forms of
BYPASS just didn't work and this was to be a future problem to solve.

It turns out that ATS and IDENTITY will always work just fine:

 - If STE.Config = BYPASS then the PCI ATS is disabled

 - If a PASID domain is attached then S1DSS = BYPASS and ATS will be
   enabled. This meets the requirements of 13.6.4 to automatically
   generate 1:1 ATS replies on the RID.

Update the comments to reflect this.

Fixes: 7497f4211f4f ("iommu/arm-smmu-v3: Make changing domains be hitless for ATS")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e4ebd9e12ad468..7605b264fbf983 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2745,9 +2745,14 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * Translation Requests and Translated transactions are denied
 		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
 		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
-		 * (IHI0070Ea 5.2 Stream Table Entry). Thus ATS can only be
-		 * enabled if we have arm_smmu_domain, those always have page
-		 * tables.
+		 * (IHI0070Ea 5.2 Stream Table Entry).
+		 *
+		 * However, if we have installed a CD table and are using S1DSS
+		 * then ATS will work in S1DSS bypass. See "13.6.4 Full ATS
+		 * skipping stage 1".
+		 *
+		 * Disable ATS if we are going to create a normal 0b100 bypass
+		 * STE.
 		 */
 		state->ats_enabled = !state->disable_ats &&
 				     arm_smmu_ats_supported(master);
@@ -3070,8 +3075,10 @@ static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	if (arm_smmu_ssids_in_use(&master->cd_table)) {
 		/*
 		 * If a CD table has to be present then we need to run with ATS
-		 * on even though the RID will fail ATS queries with UR. This is
-		 * because we have no idea what the PASID's need.
+		 * on because we have to assume a PASID is using ATS. For
+		 * IDENTITY this will setup things so that S1DSS=bypass which
+		 * follows the explanation in "13.6.4 Full ATS skipping stage 1"
+		 * and allows for ATS on the RID to work.
 		 */
 		state.cd_needs_ats = true;
 		arm_smmu_attach_prepare(&state, domain);

base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
2.43.0

