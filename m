Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EE063CA;
	Tue, 21 Nov 2023 01:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rJhstroi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lp5oe69053roy4dHCjundp991C6vcTqxppHtpjsvuP/ADWPkh0c+GKUQpP2ajHod4eJjZnjkQkOGzRn+bDryP9OLhSaamADTzhRvfqkzUXRnOV6TWJ7/2pIsJboDROmSvWMWFmjhBg9sLDWaLxmwEtrouO7VRelAzGW3zjyHUBOjwD19HcoUVSrLKoqsBVY63BoeqfmONa+Lx7BpMbe/7vuo4FZmZxPEZY8LFBuoaBVAf1cSlB6Fc8BA/NltLysEp1Z4F8hFc0HNYH39zpuNm2zGcyYwC9lzsNgc5WC6SX8ILTqgTCrQkE+0G6AeCUn6BnwK+kB1Qeyuvl8+3NFB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1HIxQjhyGJC7Fw1w4TDToNQAWSMrJAHxyCTe4X9/0no=;
 b=WmIWZq2oJcKPW4uKz8aNR0rdn5Tg2kLuloJo3BAiH1AI9ase465LIlHbRqnsJISA7TV4F8uKEVoepnYYJL96Rih0KV+URhDahJ+XdTED6jDiOgFfjyNoW9km8k5dU8EmPR38Ezv7mbMD7p0cNLHf0rsnz3z/T4+DB/QVrYCH1axQckznfq3unUqTNYiPIbmZCWbLFU6IRdEyw0qaGSXC4eiMRDUt/hAQ5qQvY6iEjBEQqy27OVnl3+4BPBkDZve4KXScLmPOhd3AYdLCKJtEQ9c+Vo63ts8lDWJZkbH6xtEy/CR3JtHB5QeaiuXiSgotj52kvuijOzMzdNzvVkHBgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HIxQjhyGJC7Fw1w4TDToNQAWSMrJAHxyCTe4X9/0no=;
 b=rJhstroiNRmEtfq9ptYaYGSKElbivXdvFiR/aY+4U3uBHirCERiZJDYhCEej7SBXuSh5IhsGn1AZMvM2+Q7tFbVL8ihjdQ5/efVghLapchfvEFtOzHVaHggDocaDRE7FXkYPQQaHkxvEGzzs1YAdYkF0Tc7K6Xvg8pC60Mlr6inlXiqc4mWx6a+9K/8w3wQyvwJ3hUNeTxSpI2c+h6UKrXXVjBs0NJf8iIgzsd1yH1nT3GiaHP0XvlXpjpt0yiQ67f98zN1CbGvqz8f6J+h+8t9mz7yn9mey9Dl/WjoS8+Nh5H6CmgoDVyPiVkxlz03X7kAxTxoo0xBbz/LIRhjOaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5917.namprd12.prod.outlook.com (2603:10b6:408:175::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.26; Tue, 21 Nov
 2023 01:28:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 01:28:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	syzbot+7574ebfe589049630608@syzkaller.appspotmail.com,
	syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH rc 0/2] Do not UAF during iommufd_put_object()
Date: Mon, 20 Nov 2023 21:28:24 -0400
Message-ID: <0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0074.namprd06.prod.outlook.com
 (2603:10b6:5:336::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: f42a2131-cfbe-49dc-b5f6-08dbea3129c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hv0TbnrcO5roV9esotVTUy3CaK2ZNIlWwmp6s2aL8fy8BQxbmeXxohQBpRYaSGz6W8Ifkgsmax7mgbW50YCieK+zWHcjJD4I+PbtVcNdeEQfsSuWkypFx841R/WnTgoGxLeWoE4PS2nItPipokP3TTPsrBRUuDpt2cs+JDVyTgRDDW4VBkW44DrkjXZkQytEu+hiERyqI2MU5AGwIk463ezoP2lhC2UiAnJB4GOVZv2lP4c3AEkPw7Bkw/zHJ3piEKrbD8Bzqv2Fuz6ObDqxbGMttDFzLqZUBxGNCoK81peCSGpcWwapb1k9jfSSegvqLQg/XEU0vD/WNYs93kjS3is2ygudnwTKKB8f+VJ8MFlqArcLVFsuX22g911vy/G0owQxGiGLVTISJVk9jB2vdiggyG1HRiEf2Rj+zaVgqjdTWbdFFLu4ccjy51VkS2kdKTQwdmhrzuJijYDadFYsQePldIAAToiHZmXgr7tj9UUwfYdqAReBQg1x9zuw6bpD8eQ8sOAlM1eHpfzNDWPR2TG/uC5WotMyNgzOQYlx6aFo8/NIviY5Sq54XNa0mJVByjleEtqmZ5j15J0du6f9EQAF/hfG3WNQ03Vl1AFAgAY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(39860400002)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(4326008)(41300700001)(36756003)(5660300002)(86362001)(7416002)(4744005)(2906002)(6512007)(6506007)(2616005)(26005)(83380400001)(6486002)(478600001)(6666004)(8676002)(8936002)(316002)(6916009)(38100700002)(66946007)(54906003)(66476007)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6U1S+aPityIdEmLWVi91MJBgK2AC9fv3r5MI4xH5FMeJbwXnzLsquVKpcc7C?=
 =?us-ascii?Q?SCjRwhOTCatkvH9yty0BQAe1kWBFo0MmGUy7kuRWilQ7GB/znBNP4HXEgKYx?=
 =?us-ascii?Q?cpzRvL21RkvVvyMEq3mhCRksDs1GXM4ZyL2a+xPpP+lPMtcIKY893nAWah9B?=
 =?us-ascii?Q?b+sLhGB5siZbpc1qEBiySlMlJDpoEzRBydqQPl2h3IQExjQNA1WTwkKRGxt/?=
 =?us-ascii?Q?ZHik/DDQReC3kOpMEBvHBSQ/2HJGa092FO/xHOCWGSoW3lCtxBcwImdQfd0M?=
 =?us-ascii?Q?i/QmAMoXtX75WnZXGFTHB/I6dMGz5hHIgtBzUIzSbpDPtEbNiEB4Ue3GC0lc?=
 =?us-ascii?Q?bRQord9ykOGefHlqSq3SHh3nN0Nd2DPRftOMcB2tQarfpFSt8p//jo1Cs9TB?=
 =?us-ascii?Q?pqzfAyTOA82UOphPpRWYcDpaKJs2po/zEYsIGVThCqhk3gVrz86lVEztbNAC?=
 =?us-ascii?Q?BJo8Rm5Vt9AldF6b5/5xvakqC/LuQdEb6P9iBv+iwSwCIXCttXnD3VTODgrb?=
 =?us-ascii?Q?WV8s4d1uH62JfN6MFDX40XAMVeJ1l6TgS0eljXk7LA5XXTEzDGcEw1UVpvZ+?=
 =?us-ascii?Q?j3mSpd9UJ6Db9bRUxRaIm5x46m31mIAdkYNZh4WWlXbWht7Yji3Wrj768NiK?=
 =?us-ascii?Q?7ZNTAbssxHtQryt8Pt068dnRw2BRW9aXV1h+nco1JSXcm2eI/GKBnkTgb/Ej?=
 =?us-ascii?Q?zVVDKpZ1S+qcZyRPuqmntG0MOMSLdMnD6LnPM6xVBq1oBDkDE6OSLB8GN0RC?=
 =?us-ascii?Q?jjqJP3saE7wsy3WHnSaWEXi0dF87E2zjVztVV9ahHUDWHitZQKuG39ZGecaF?=
 =?us-ascii?Q?JxEqU9oPhmIvEp7G6BzuRiX3tLYLAA05cldlM45hNB5CMfzEvrkZbVkWZXC5?=
 =?us-ascii?Q?Vq9U6ntWrR52kXkAUrfIEBG9M8f6RiAfRRJsJCsEtYr0NnFUQ7Ti4xMLyNdo?=
 =?us-ascii?Q?5h1Od/BRUgDHS+2W+1+bWNSj9AyAuXh/DbjoIjpNRDS2SR7nlBx+zY+G1kvg?=
 =?us-ascii?Q?dBPvCm9rosCVZtblB81ZuS29eribruZhqvyVcSarsCLYDS9IloLz/UAndj/1?=
 =?us-ascii?Q?iFpCrmNoJFu9LKM8FLdBHOi59OVIllsIcF5YocK3xt/qoXkNpbSeUeu1385z?=
 =?us-ascii?Q?/pdTQG1tAgx85AlicYgq4qt0VcJ4UXTu4qDsYw6gECwo6z5zxsTwVlF/6wcU?=
 =?us-ascii?Q?3z3l/SAwuqCj67uO4bX7MPeUMUSfTtOJK/ydJCPZJik5eLMIi8CZ2Wx5avVh?=
 =?us-ascii?Q?EAoxG+R1cmary+CZTh35Sz7jaNqvTjAtbsr7Dr6wazy8SVTvt/NNhUtjWQkl?=
 =?us-ascii?Q?obe+jOyL1ZCIt0je2h2y8mug1gPyhT6sJUu29p3xrsaTEbA59hBRDSeKmKN9?=
 =?us-ascii?Q?VMixfKFT981zsZLa59qlZg6hEJdgADCMnDv7RgJUDOEb4sbSRXNptlH1nhOZ?=
 =?us-ascii?Q?oe3mueqIwU/W40F2KrwfEaXiqk9Ai4XD4ucch8DQY7cZG4v+zXQW8U8hHBVk?=
 =?us-ascii?Q?XC58KvbQU8HfIzq2AFCcSecZskQmc1YqqumrraHFL/DckVAxwzRCcj6jM3nr?=
 =?us-ascii?Q?PjJvX3cvSfhegkU/klMdlXemFTjT+YBTMYx4Rcnp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42a2131-cfbe-49dc-b5f6-08dbea3129c6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 01:28:27.9158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ip6ei4MP5Spvo8t6DlygtimPQBKgydY8tGD9CLtQgtJC1RtV4tBxgGKca81P4xc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5917

The mixture of kernel and user space lifecycle objects continues to be
complicated inside iommufd. The obj->destroy_rwsem is used to bring order
to the kernel driver destruction sequence but it cannot be sequenced right
with the other refcounts so we end up possibly UAF'ing.

Fix it by using two refcounts and a wait queue to sequence the destruction
process.

Jason Gunthorpe (2):
  iommufd: Add iommufd_ctx to iommufd_put_object()
  iommufd: Do not UAF during iommufd_put_object()

 drivers/iommu/iommufd/device.c          |  14 +--
 drivers/iommu/iommufd/hw_pagetable.c    |   8 +-
 drivers/iommu/iommufd/ioas.c            |  14 +--
 drivers/iommu/iommufd/iommufd_private.h |  51 ++++++---
 drivers/iommu/iommufd/main.c            | 131 ++++++++++++------------
 drivers/iommu/iommufd/selftest.c        |  14 +--
 drivers/iommu/iommufd/vfio_compat.c     |  18 ++--
 7 files changed, 136 insertions(+), 114 deletions(-)


base-commit: 98b1cc82c4affc16f5598d4fa14b1858671b2263
-- 
2.42.0

