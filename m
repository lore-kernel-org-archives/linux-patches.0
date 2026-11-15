Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785451;
	b=BzSw8LkjVeAJWNP5XP9M0EcRKvrG6a8wc0MAAX3uVvE9QAT23e5Qq3zV3LCi3ThuLlDP
	 ELWS3BDrT5jWAro5nNnVnvSw4uqzEvout0FVElJmlhaB8LYw7fiIUZ0PJI3aIcQNb6DkZ
	 sdLMXyj0inNCErVqrdb3jXsJ4CwnhQ5VKcJ+lTiv2kw4PDOBo8Uy6AaTWmqVWzfHnRr81
	 7YbJ4A8Oour/YRhsOrx38XlK2vR6LhiDmbKagdI+ZVJTPZuFbSx4ZjbJ9BJMYtnFdoPlF
	 uvyiJre5yjB9sGui11LOrh8WGst/cDqhOL/88x8MtHkFzmR5OdyNN/GFSBEI87efamQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785451;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=FsvS6wFqINj6b6MMstrOw40ouHhx/b6arNqWXry+p3Y=;
	b=SRCumE8S1MyMTL6fHdRe0xzJErxyuc+lubAVmxYtCLDq2yfPWqsITvAr658pa6rGToC6
	 y/dqM2jMfd01D1nHgUar183JoI2IZW0SWNQ9aPZN5DwBjLsiagVt1kK7Q1akge7R0DcBK
	 uJ+lhoyIeMXT/pkGW/q3VhKDDeMytfveEcdnfHVK+ceGrFc2SPv42D3ajs0D3ckvHvgCO
	 pTS+XbSzqmwY2Wtm3fSb/UI6jYgEOqOS3vlmRNXZfblv4eU+pHjVdq30Av4GfNKP7C2gQ
	 W5maXG6fbWNBFmvcHKvIf+RXeDr/DcDMYGHFdu511M6BLZye/rg6WsQ10Yq35xxu44A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W6iuby07;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C57606A881;
	Sun, 15 Nov 2026 23:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35C57606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W6iuby07
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QX1CJWtqFwH3lB+sIBu+U8t5qEeJexU0Bn269RI9+uDaxB0+KDQgQ5OQYQrMy6EJAtK27tUsa4mcEFcZjGfbczpnptraSHK9QX2dj61yaX0PdHk3/6QfqKO319+daMom1E1A89+8iMoQ8HGY3he6BHmmh9kN4q80v6fSiB/S8exi1WU4JN/SS33wJDD1yFeTQrjJnAddhvCOk09bNdrAN5EiTAp+td8CmPROeWAJB4TLdvzXBpRrG4H9isVEkOYnkCX4KwBhT5kT5Hg1imMC3ERzSqmEAhGQ9obNimCT2UnlFJ+ZqsyOF4r1b+ArVs/34u7kYqpoKA86D9SdU1ktEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsvS6wFqINj6b6MMstrOw40ouHhx/b6arNqWXry+p3Y=;
 b=KiYBwvEIncRUJmUXMJvtjs0JXjnhR1vEGKivs2cNO93hUaOJDwD/+RPZhDjQ+xy6LGS4FYxrP/rYuDsVDnuco/mIeKjAB/UC+8upI/h61yeR3KBHaC4cky0BEjfe2dRPKblZMa75sWyX46TmAgaAKUg4d1oeY6qNyGytn7VQUDwDiGHC6ar4IsJ3+3YziLjsDSKyHaXlnS1sZ8ZdOw0EcUfS9cOGQf7YKVbd6DZb4KxgQs3Lo2fJ6nYVXi7DZH8Cq8VU57aKiTeIDdi2ubvdI8QnEZ+ZV0qdTGajgGYCYV3+460Ut00VMUHJ04voJW5WDpQVeDhc400c/wLJi2YmZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsvS6wFqINj6b6MMstrOw40ouHhx/b6arNqWXry+p3Y=;
 b=W6iuby07dslUzB4J7q6RcZO8BmjbZZN0DmS0qbalPtH6w4Jl+cXHkMVmkIGr/ADCBhCh1bpaO3YvGx+61wundza3q2E9Zb/7xAmlvEQrpREi4S4xzCHr4pVVCWxqidosvwd3Ubo+dS4q8XQbrkJLPGkc8+QcbG8Gz6OhjedoBA5ntZziNLgotlMLVAMzTrYkJuRsMHil6M54N37sULQyadxI0NlnBWnRX9k4cOc22S0paIvf2n/CTwns1bgG5WGWmGgcL1NCDxLwXMuR3kB3JYETz2ZqTlKd6jrQ318SaunYvL8H8Myg3lJq9dXOh4c4cnCKHG8e3Gsxfq65RYWpCg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 03/13] iommupt: Remove the sanity check for pt_num_items_lg2() at the top level
Date: Sun, 15 Nov 2026 19:30:33 -0400
Message-ID: <3-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:32b::16) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: 994a86b9-bf90-4e9b-6d72-08df43707879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261021123027099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GPSeK4vVsGZtwQwuxs49iD0jhV0wTNxLzEld8U3jgIBER7CG9pPb5DrwmukSDBMsHVT36NeLZlmoI25uqde4Lj1SeXa0MBoxDIZjUHOLi9Ga93K/mfWrDxrYbJTW9HOBgTDOb7d0zIz7oKtPxfRYHM7UK5xHP96oDKxmvIz64SLD6+I9ppzesseXpu/R4lxeoPMgp+QR0/OM66JrrfRvUq5exCP+6oqXXxEjrYzEJpPgkIK/1RbON4K9OlpSKZcNsNT2pgCO65jp7OHNTiUDPQGpdfyiQbSqL91AkNYiva8BHFWTC2tr6Rsdm4NtjvOAP50bCXt2nX4GUsJrB+ACMbdVkbS8YWRnMGmSkxbpHnr5BurvmIJ7gKUYcc00nhLr8nEDuTtFIRdqR3Yst3zszdzjLEl+vE5pRNBUGB8XMpzthPaSEO6OqohCgWuqcVFYPTXL9y/xavOz4eQ4uSVxRrJdbOoeW81W4RrgcJpREY97UNPbCkqw2SSHFjCdFTsxFLr0YzFD4DiFwq8eJHZaImx7G1yu9uRV96lM4juPfKkkJn78MRfPi4lz2pwXJ4JLdbrHTTUe1oJHURPSrJXTkzK8dMceH/wDjAPTA7XzKexm0F9o/v1LxUah7fIPgwLLs6sEHTV6Iu8lQTNjjcgePmFruX/81C+cBqti9WgdDag=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rb6i7PiXoD1yntRwrI89/zwJU4JZNHz7RUzXybdLm0Em+cTCMwK21qci6GUP?=
 =?us-ascii?Q?FGik12wJ1aXO84mpbyKbCIJKsErOAiHDu+0rsFzvbFpt6/C4VefdYygeOXvs?=
 =?us-ascii?Q?apojp+unZGU26/DgJgWX+J+lQ6h6U1wR+ALLPpkZqtT0MzkzF5Az2Bk1rJ1D?=
 =?us-ascii?Q?lwlL3GwimN05k0dvd3IaolUO1M0igkgTJze1cq0zA73ThDXGRPZEUqYQcNW+?=
 =?us-ascii?Q?L7H06+oQ51F+k5NaD18jsBgVfL7erITeg9Uqz6QyIvjo0FBr6DDHk2BxbHSq?=
 =?us-ascii?Q?sl8CaHd1gDp60Gizt9PK56DB/edq2NrbnSHBLBJXR4s37fislZM4iG9mEhI4?=
 =?us-ascii?Q?uKOywDPLDPGFM8pjyczB1MkcYoIjBPu2n5BHGGs3r0PmCpweJukwP+D9RzQc?=
 =?us-ascii?Q?AJT7sD0n8cVUrYnrKXA3SLcLid5VPLeYzp+lFyM1xNP/QUZcQFD/K13VgVKH?=
 =?us-ascii?Q?DxnOk8u1kjUDedi/yRJVQC4VWOOlWWwNrvkJIJ4YWi7ISgKJHVIU6P/9aNY+?=
 =?us-ascii?Q?OVugngAtsszwpOV0gUEqaJeZQMAS31Yp8ORsneeBJRfE6NqkCvuR4XKo4l36?=
 =?us-ascii?Q?1sjNWpuKF3LQ6LlaouR6kUWkIltMSYVHKOHmIoDg8kAgitO7GKqO/eVoAgC7?=
 =?us-ascii?Q?9iscUUqzR6n/7htRIQu066LdUSa8r5nrcpm7NRmDL7s+8xF3u/AsTTjuODqA?=
 =?us-ascii?Q?Y2bE9LjN3or6VurcFs6T2+Y0RAPRN2TlUatifvBwWsXKrWzN2Kh9eSr3JIaY?=
 =?us-ascii?Q?cmJzRkkk4R03tipwfT8TkWTsjfHrwFUJc4WLPhFGscDFBVemdLOJzF1F/6sf?=
 =?us-ascii?Q?RnLJiXhWRGWNCOwPQAVBKANfzDLiHmd9uBBZ4y1er2mCxVH953N/pa+X72d8?=
 =?us-ascii?Q?UQng2TcpxDdto4NGWhgrBJPXTVC/M+jJJXdcnnd7bJTMrnpEe+tPBYlNna1k?=
 =?us-ascii?Q?45AiRuUlR0S+mSuBm3N9vSs4Bx/AxwmcPfz+Po9qnkDRgn2cGWyPQCfuda3x?=
 =?us-ascii?Q?dahmewpgXuOzFbmz0zGZkL/keoCVU5gulcFsq4jZpj8bf3xf7mRS06sUjXQn?=
 =?us-ascii?Q?biXdG4mrhjgW++UL86z+M3XulVPJhr/xpIYR3+RILYfy1UZPl22e0qbLf64y?=
 =?us-ascii?Q?Mte/f6Pd5d4XMRoJRDlsX95HB7DJe+3Vbvz6a7RL8rHx4aeZep/OywVudE5b?=
 =?us-ascii?Q?5hzXCJQ9NKq+VNe9eo+fAyjt3bHbczEHlLE9tTLvuGP40n0CIP37lxpx3yfa?=
 =?us-ascii?Q?tpl0Qmus4PYEg4Rd78TEOMMMMG1a1zM0+p9UgD9VUwy3gk0grNRUB1BOVIJJ?=
 =?us-ascii?Q?rcCgZvby+grzWO9/YBU8jFrFAGd5U41UVnVmi4SkOHDb+ohCoUaFITlraEug?=
 =?us-ascii?Q?vocAwAPsUUdaSI95/hDvKpNWuHuHoPmmafupGrC+lKdSqsDUstO/JZ3a/302?=
 =?us-ascii?Q?7AHDbP3uuwMEodHi1ChGIsktvl6UUb+kLkfzHle8KM8HqtVP+CkV+pK5CcHf?=
 =?us-ascii?Q?4zPR4Vc11KZAnzDk/jJ2WkZry5xH6Dc/N+YPqzLaO1enJCaaUfKUMOTWSO3l?=
 =?us-ascii?Q?ikfEE1ZCenJ6Utk+nQpxwmgSEuh02GpfTLwPTxT/LfIHJzNrbZRj8pJXXFst?=
 =?us-ascii?Q?aaw8rsVQS/MPKZ/cBCVg4xTgd+aWerN6uTix6VCidtV5qnUoEcAVoMmUJGNY?=
 =?us-ascii?Q?ur7ZJ+xjgrnIHNJuJJbmi55e3OVsMzhyJALQY+rxQh69ykYP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 994a86b9-bf90-4e9b-6d72-08df43707879
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:44.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/jbnfUdqlGAojxJRq/3E2lHGpZyzdomWwe3kDNWhMN8pPPqtYyh7iB+07GSJK9L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

This was ill conceived, the existing formats work OK because they
happen to support pt_num_items_lg2() at the topk  level. However the
documentation is clear that is not permitted because ARMv8 has
concatenated top levels and we do not want to calculate an exact
pt_num_items_lg2() for the top level special case.

The logic to compute the number of items of the top level is shown in
pt_top_memsize_lg2() which is:

	num_items_lg2 = common->max_vasz_lg2 - pt_table_item_lg2sz(&pts);

Which is pointless to try and sanity check.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 837d835e4fad8e..0360a02479e3f6 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1193,20 +1193,6 @@ static int pt_init_common(struct pt_common *common)
 		     PT_FORCE_ENABLED_FEATURES))
 		return -EOPNOTSUPP;
 
-	/*
-	 * Check if the top level of the page table is too small to hold the
-	 * specified maxvasz.
-	 */
-	if (!pt_feature(common, PT_FEAT_DYNAMIC_TOP) &&
-	    top_range.top_level != PT_MAX_TOP_LEVEL) {
-		struct pt_state pts = { .range = &top_range,
-					.level = top_range.top_level };
-
-		if (common->max_vasz_lg2 >
-		    pt_num_items_lg2(&pts) + pt_table_item_lg2sz(&pts))
-			return -EOPNOTSUPP;
-	}
-
 	if (common->max_oasz_lg2 == 0)
 		common->max_oasz_lg2 = pt_max_oa_lg2(common);
 	else
-- 
2.43.0

