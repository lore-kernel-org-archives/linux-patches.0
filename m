Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EC93CE0AF;
	Wed, 13 May 2026 23:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716682; cv=fail; b=L+iu3/SVUaf2/qpWYOptcBVG8b7b2TntlqCbVxqchmpvI8de5DqH+1gEzLwJGe+B3JYA3gFAIQFGEUNepKIMqHqfS95shStjqFzQVkYTUKcRt4KTlLGfPJfIaD6+Ohw6WYHo9MmKOsB11kwwSdJhXJsTi9S+95M+mD8jMzXz7HE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716682; c=relaxed/simple;
	bh=Fst+U/ns+nhXp/R9R1Z6ytab3THScb6D7Q2IlwhyUtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=InbUYqJCfacaYiH+7lI0IgZJcFN49ywrSJuF2ylOh1eef9/4xzZqDBNQelBeUhXuPdXOicrmARRwLjthFrWFTRamxLuQmVpx471GrCAIu3j8G/r2NoLlBwMA/Y3ulvimoHYVqZIUB5LAUaDh05F5el9IsDv4fsxVCQiH/KW+SLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZUX3wbjM; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZUX3wbjM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hr2NxhrGWFRT0ua+LREaKq2zK9qsfvujTQm2MFI99xiqZoUbhXhbU8UNY1PJ32Q7qmTTb5w0K9gJ/lOpt97269E+iJkSQ6TCCEPAseS4VtzompWzP+dC9cQsTIiPcho6C2jwIpTJk3I1Xihp65XlUZ16LGL4u1NBbVNC/cQZ82DE+nqN9llUdi+Fjhyk3JuYE6KwIVIBpdmACoK0Q3n7z8FtjqJnTfXtie0z82b4/N0Tna6nivqR76clcFKs5rmlfsyan40OWilu23zZsMtC89LBxfKF47xVdrRUXi4SrlnMGJ/1ySUmjKdfQafUwvrW/zlsifL+8FLmQabfuoeu1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUYO7MRnr3RIJyGgfiLnwbA1gI149KSTiEC+L2FbyN4=;
 b=YxiDkeYaXryLNi7IWKN7RhC2mRDfnnxBJrzitCHvordl4z4e6tOO4LToMtFudYIHdZUQVbJdwjVqYHD6RBrMCqY5Q6++Nl2e5SnN+Uv5h9zTjzLb4tFAob7aGrxVOj6szJYB0ez4S8UdV9Gvox+w/ueA4Q4hUi70ur7ci3LjGKShWB1lWS2FW+U4nkj0jRubx3fnkJ7kvmU1nTTbjx935n5LcvVWSzexFRspmlcKTtpYNX6pcq7lUisXvwHLpqFsReBKyts/eJihtJKmfSDo/o6JJtKHOZ/yykqFyJkmLbibzKpxI8tlbfsvNR7GuTQp4Wk7mmXdvR/s/yJUzDvCxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUYO7MRnr3RIJyGgfiLnwbA1gI149KSTiEC+L2FbyN4=;
 b=ZUX3wbjMuwXtpwAH6rA21MZgjogEsP1uH/T0MJR4CV82U9p93haONH2QmJL9FyfC5uAwCPGjcTpPSviU2s9J+GCH60o7+Br/TUUM0h+KlJZTTjSgFUFTV1JN6YahNGYzNRWmbEjBOscI+/F+Xi/Tnvk3YGWrS7Q1/l3dtrg6XhtS192sW16lonvhE9nqZJzIuQMoK1OKlM9NxDwS6w5086VwZuAbrb/wTN3XOeixMYJTPIm85ZBCK0tcbP/PkyZWCfddd0jDDR80YhHlH7sb3q8whcB6f8y5C/c/GcBJPdHqalVLAYD8XFQeEmP+pOSdZdursB2sEAI+OkYyafmmRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 5/9] iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from arm_smmu_cmdq_build_cmd()
Date: Wed, 13 May 2026 20:57:44 -0300
Message-ID: <5-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0033.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb1cd3c-2777-401a-699b-08deb14b70d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	sQf0lFtIgQQAX9tj+30Hzm72Pg3DPzWeJMq8PzA3zoZcWx7P0Dvld0hIQNfnolHit5MYuJDVbUK9aL5y/mUB2L8NKhbTT3xDBS0XAZY9D/XC1WDZZBtCyu+WiJ+63vuswTAsvye/anTkUZDraoOxMlEevrsSCdw2BpeAprZsaaUJFIQA0P/elrqXHeakykBOg12aZt84p8vFhUJsJ1nF18cuqgnv5rcKj7wYFbk18RQUnybVrg4ym4yOyCnYY4rFH4EDBtb7yPY2f/Ij7Vixt7/y+vjt5UtOVw2wx9wM2JumyCyXUin1L7mNF8VVQv5qY3TK+PziFFOeZBCxVxD82Gxt55AY32ijrT6WxBhaoY8qHE1Oah1VktMG1imj9ChGT0V4CB9hTwPMp04rq5CiDSqhQ83FTNx/DjnUE7ytjqgFGoDYZSv4F+ZksAQZyCmS4ac8Ky7NDF/Wi2GsfkxRve8+/k7g4R0r/DuivWBYitlEpjiGbO7M9JO++0YpSgp6N7sqtBHOpjH6HuwTkDeYsfrsAiu1yuCXQjqi5prwz5rtCjX8+k9wcSR0Qiy5qXheH9bYtVnUl3SS9adrBfUo31j7G+57BtSeP6b5pTzD/lpfw6rlQl7eqdm0bAtWoDimOWg/uNko11RIvNWeLiak++ijRVVTPZ9NLpY4KZxHBhOpxRT5gHhA/F22kH6wYXfx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iLTkJtmwVGUNuVV04cLpMwUtYsJd8CQt4fmu3aDViOD5tgb4z+gSEFcTmOsj?=
 =?us-ascii?Q?1rBYjpLdXj9qs1r8iaymnc2wWr/Sxu+VHD21AUlDH6J2OjUEuczY9csGnAVu?=
 =?us-ascii?Q?5NmNmYWB2u2OdanREMpfDjh/rbgL7a3GtESpeeG3iKsSMdVa8wj0iKYrfMqh?=
 =?us-ascii?Q?EnowM2IGg7QB89SPADmU4JDxa6tkRdOlTPfJIw3XQ3Zs37NwSDfK/DnMZclR?=
 =?us-ascii?Q?JVAuAT2Zm9qHOL+Bk37n8UlJ86zWaQ/o5Xf2Uj+RI2dIxca82XIn/az8mttg?=
 =?us-ascii?Q?EaqHWWry30HWGh64DeCXLz1a//XECk4VO16vOeYyk6zAHnmthABEc43OqZhN?=
 =?us-ascii?Q?jSb6xCR5pml77xj6z3OZ3/h4m6oIpa8zIqnyO/GaR5eC3GgVk+Sw1gO030e1?=
 =?us-ascii?Q?hyO09QV8a+aHPjdMo9VTlrCeTDxhLTPXZi4mChRBbK9J9MXY5O2/uwcc6S2C?=
 =?us-ascii?Q?0Z2JNdaey+up4rOj3D3lpHv3dNvwNA17qtQvETaP1x7PvJmD1X5rRkA2mIEk?=
 =?us-ascii?Q?F9GSrgcqPvnVANjvHwe/oiEpNr+1OH+R/x9O/xEAC/35xz3R5J8F7/Zm/YrA?=
 =?us-ascii?Q?cuhQyvZRL4GHB0l2s4RLNhhueSmEymLpHI+sOVnfkAUhKZdVExQiq/kf/jYd?=
 =?us-ascii?Q?ALKM7LZb8M+KI2kyDNIzkfX00kWzBwBj3TvNghhPOsWsIC48C7BRH0khfttX?=
 =?us-ascii?Q?Km1J1d9p6hn/QoBSR3HbyRxKz04Pdrfuhe6nia93zc5+0NVoIgFNQWvJERew?=
 =?us-ascii?Q?l3khHxfhAKSDhIiJJJlCYBjV+dfIaIJjZ0dpOiTe0LpQkz9Thz+3413wiWXd?=
 =?us-ascii?Q?K7f3CTVG6gBBIr7/YfomTnt76lNeSzYf5XM5tjwJvPQyu7Ebf4mKFnfHZddm?=
 =?us-ascii?Q?AyuG/O8FvuaQ2vDP4qBj0HoHOnOYwFmbyC/PBfIuuWa+ULvepauywtKVGdvL?=
 =?us-ascii?Q?UYPkkSsKIu1snZsS8JATc0Kg8t0NIUifIDMA+h+wa87A7Gi2eGd7BERnzm7C?=
 =?us-ascii?Q?fwh74a152HjuwwU8zRXwX0dFTnEfzYenUiYYZ4cEhmkFYCrmYLd6v++pqyVK?=
 =?us-ascii?Q?yAMaDiFxuozf/m8Thn4IK3hzObtxe6f01lazC4AC5XotdZm3kTZhQ+6GH3Sc?=
 =?us-ascii?Q?eXELQd3uelC2e9icufEWcUHTyW5ekqLgFhWfqlOz1dyfR2h8HQnysBRO7ua5?=
 =?us-ascii?Q?yIpDtq0kzkhzJ7IUZAEmFSELQyNX0d+EMbvWHnJwwZsaayEGZyu4eamh9ITW?=
 =?us-ascii?Q?wgUZhr1sdhgK1LJcZJBjhrTaEsd/9Qmse7VWsQ5E03EqcFmmMV6I9i0c/Rjz?=
 =?us-ascii?Q?wxiDrJSZJGeWRsnxbh8dD+XTpuAQyBkrOZqQzFpWeybftqbxXF8TimhcDi15?=
 =?us-ascii?Q?uuR6tfAWW7CepeZ+zcNRemD0qcwfwe771m/P31gbJeVi0OVjkala2qMbtv7h?=
 =?us-ascii?Q?guOk3lEd40tcFRkNFtwsFcR7VFIG3FoAH4lDnMGz+841q6BPAvgsh2VJrn0G?=
 =?us-ascii?Q?3meZ7sPrUwz81e96Va4C3FEibVykS5JYHASasFqnJNejnRis7+4ju11PxOF+?=
 =?us-ascii?Q?bZ9d11lo1W6rYwfh1EFaVjpzRfbVCd7PjApcAECv/i2riVI3taEEGOBEiczn?=
 =?us-ascii?Q?Wh+WPjP2t8O+Cz4JTA/QiM3vLveUPsG7uq4/OUZABf6GU9zHrDRpVZgrdKhz?=
 =?us-ascii?Q?4M3L86lNIVbURTvxoCI/C/QuxPclILYnqDU7fMZGG6qMcjrD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb1cd3c-2777-401a-699b-08deb14b70d2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:51.2499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxigr3FLctj1v0fuSeM+ac9peb3exH1kCSZ7HJt38AeCslcubQNQ+WB3tA4M/j6/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

Nothing uses this, just dead code.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b3ef001ce80d23..ef0907b1a2204f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -290,9 +290,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
 		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
 		break;
-	case CMDQ_OP_CFGI_CD_ALL:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
-		break;
 	case CMDQ_OP_CFGI_ALL:
 		/* Cover the entire SID range */
 		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
-- 
2.43.0

