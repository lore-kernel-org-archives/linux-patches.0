Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8011C4C63E;
	Wed, 22 Nov 2023 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pWBD3pTJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0f8n7tzvilX5ix+OXgVYQ1Sa4B0XgLAI6X6fkKzuR9G2tOgo2Kgt6QX5N8Os5YLdYC4MK/HaSy/jaa65mGGO2ff1YKdGIj96ROOB+uTanBxlmfbZkLA2KEU4dKb0yKCbBBlrCdUfpPl7dzXq2ioJKJgZom1mPXaTtzPxbWsq1EdnYVY7V1OettOtB4Yk3Hux/DnSMzZe3HLbP3hcdKh9p9DqAOuC9v68fP7tZZ6izZGTjS02hfKQq3WGXoOGTzwbDbOgBmkv30XRXr6cofsMcvuQVEIrKiNcC5mbmsD6fwzIe46HyTqam4VJvIPqr54mZ42xGlr+C2ZEyUYV7WeNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsTc6zmqHsvuwDq7tnBsW4rFYCgAFEqnoHwM7cqZJBY=;
 b=PVCbPF64+eNUSWitn5id4OhXDYhNmOWXNTlo7euwWeye5LKCyYtqzIxcuNckKS/bqkBwLz00riu7hUcASFFPsjgiVW/LsFb2EE+dOkL8d4csl/lIWUfFH+PDUnD7TSxKtW6rMCw+5VPVIeoHOh/2pucj4vKMhTDnSel9eHJgdW3uvOYE1IxIMw9dkSd0/YhiBxQOnBs6v70r7TJKDaQ1riU1ONtTHq2KarynG2Jja/NuMv4Im9Fh6N9xZG9VwV6LJDoVE0IQVCXiPjBe7LPoC7MC3n8hFtpJlpAgpXH4Mah1zmFcv9zGhW03jmldpczG7vsy6wpFkMIwNFvDJe6OnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsTc6zmqHsvuwDq7tnBsW4rFYCgAFEqnoHwM7cqZJBY=;
 b=pWBD3pTJv6zZSy2zwsgzrcG7umlEtEQjX53GGBVL7Bs209eoMUzeNkRNxI2gCMbfwecIykkZzJdybzOYTRaJrvb+G3Jp/vEB4wntT7cFFfH6IqIgUaIHWJ6snIJ7VJKNxbfhC4jj9lOD/Aoww99qG7lnzdZznZ0Xkocu4/7O838l+WEMq8A1HRFyl3jcutpclZHBMpglpkzbDQsgKXaqrY3tALdjB+1yI1aDnU5e3Dnux5acz4ZzQmM593BMR5FqL4xRvXNEgpkHc0I1xpOcgtKgWlKCUY1ei+RyJdo7h+gnO8yefxqYBNMaSilu3CoqFOLUb6dNLKedWwqXrFitYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN6PR12MB8489.namprd12.prod.outlook.com (2603:10b6:208:474::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Wed, 22 Nov
 2023 13:13:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Wed, 22 Nov 2023
 13:13:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	syzbot+7574ebfe589049630608@syzkaller.appspotmail.com,
	syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH rc v2 0/2] Do not UAF during iommufd_put_object()
Date: Wed, 22 Nov 2023 09:13:17 -0400
Message-ID: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN6PR12MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: a8584a8c-4474-4fb2-f2ea-08dbeb5ccd07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n8dcoOBzMBMeI22VFhiOm122s+QtzeVzpiChMLxEHwuIJ0coEHnIEB5CUM0WzY54ctOdWvUk75QRBXHESxcmV3aStvUlwLj+GFAztnGU0KZi7XXkAakscyase4X4RnzJm3LqS/UnikJGk30b/lAs1ToWV2f0Pc1Duku5YjpGE+OfrA2Qj0DarGaZnmALaDodNiZ9lZqoy5FDAmt6iNZQs/IhEfDyfeUcM6zAFPL0zhRwsMDJ/oEqfT16OhCrXoD4YT2sAWmuYiSTtBDZUsy5QUHfNk1mBsOFk4UrcCmFIoYEXauujhMpCScKbFh63M8ja691kYiEg2RaqwVELWKVlewMprs1wqUfpaDoCFwJpzlRKN37SZYlD4coLVs/cjBdJyXNwzdhGEGmpQGgkfKw1ei5Hkm2iFUMnu7scpWfIPqyp2S98mjDB0bCId3TeuOWglgn42U93DAS7R7Ehv9Nz/mKl1dhfnTlRRT+T5S/ZpgOZr7G4XGvgl+8MoO9EHYdhRlHa3rtndrvAeQx6p6lZFoMipXp2ACE4MBb8nVnW+Q41WgtcJHhKqZJQgmrEr0YRN6ZFwtgyfD4uvdREykdyqTSoRfm9YZc+FdN5YvMXS8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(4326008)(2906002)(6486002)(8676002)(41300700001)(8936002)(2616005)(966005)(26005)(66946007)(316002)(6916009)(66476007)(54906003)(66556008)(7416002)(5660300002)(6512007)(6506007)(6666004)(478600001)(83380400001)(38100700002)(86362001)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?difiCTolAYb7iN3VCPMigCfpDkMqlab5m0Z0mr4OeIJoUUEoWwD6ld9vdZV9?=
 =?us-ascii?Q?k+uTwtdOzbaY6zn7LN6k/DWhodckMk8WQuQl1DspAF39wkXiB6EF03v/f15p?=
 =?us-ascii?Q?Ma+lWPR7OlyFK9e4q5lkU6p2mTgWL3wT55bXVWkAn+odzrc7mP2O4/hAm8Hv?=
 =?us-ascii?Q?AxvRmOPfZxZbN4B74Fu5ehFZfrX5FGsbv8fJGqBBn7flOgALeJ4xoyL/3O4b?=
 =?us-ascii?Q?VlHW2EO7x7TatBcxMD6TQgFhU8ODt7pSjzahmz09NhI+JMgyqaX0lcr88p4t?=
 =?us-ascii?Q?paxc4aQuQj8FfLoEQQuyp5u00f5TbDfpMwBisoyxh8ANXU8bcRv8o1pCcaO+?=
 =?us-ascii?Q?/UtJPhKleOeL2S8bqihdbqnYU7xE0KL2D8tJkHq+CRHCIkRQoSw8xrPss71e?=
 =?us-ascii?Q?lvXoM+0QQZikdeHIEIY8bLI1wDzJEg6X6fN3j9KwASaZH/M/XtLY0Z+hSnOO?=
 =?us-ascii?Q?aHPnV+g3J8/fuT41hvOWJK0bwdBJQSN1xkRwy0w3CjtlrHKQbg3bHuKGP0Z5?=
 =?us-ascii?Q?x/m0lIqry5G6UvyaRbvKQaBAcwX8KGjO0X3M4o/ThHjYWQ5TJtK6XqvUKGio?=
 =?us-ascii?Q?948NpwsdO5JDBxVyI2eKjtm1h+NQp6HEUQt0MFEncNGdTgb8f7A7hAeDyzlJ?=
 =?us-ascii?Q?62p5MS4M8doXF2bsGoUX26WUSzsPPsruhQyNjlfsD4wEvFAoC930FAgqXo8K?=
 =?us-ascii?Q?ddaHYtxWBmzpGwE8FsR3kr8cO8MMOj76X4ymI3s5va5zKBVNf0SP/tZksJMS?=
 =?us-ascii?Q?Rw75Xd13x7436pONyPN/b2dPZsgSu6/+7JMFBNm/oIbgjbmfWIJdWhtmqBCr?=
 =?us-ascii?Q?oYvBIz8oLZ7O3esB4CsO9R22QnJ5HqwU5ZVyhqQSTXJWkS3+l0O5GCXXuBrF?=
 =?us-ascii?Q?mTDY5OIBWHN1Kg+BsbnHHmcjz/H0eV+Cbn/wi2QIuaZckTFvHyZRYtDbGecl?=
 =?us-ascii?Q?RbPFzYeUWN82bb3zFozqz2DncTv/JI+gFXvT6llTX8E4GW3PKvF4kE7atGzK?=
 =?us-ascii?Q?jlS2+gQVGz5oKUCTb3bEVzr/4KtWeSei3HHUa+wzvV6f7B4iKktoIFtNDQiz?=
 =?us-ascii?Q?8VJGZ5K3hYLqqqd6a8OA2yEI1YS4wzQdorGMhg9OGl2ed/bqFodiH6oNM8SQ?=
 =?us-ascii?Q?8L0pl86NWkbKUwwR8Rq4jHbH5V8BLra3eNCKAzQY+aEwbhCU/MfK5/xpSDo5?=
 =?us-ascii?Q?5cgGCNCJmKVKMnrbIVc+WcxwVZgVlKLo9cvHR9vgKLqsEYD7pAqI6ajO2/TA?=
 =?us-ascii?Q?T3NbyFx3v5UDqXVU1c46/E9zwwGKbIGOGf9OdamCQtGv43yONqjHBSbI4kmC?=
 =?us-ascii?Q?ZzVoM/PX70dvC49xHkWlVbfilEB9WO2eNaKvefZLAQuHAObgCDwihB8l8mID?=
 =?us-ascii?Q?MizxQdABKAu+2y240qEXt4hCuhH0nm4v7IIrRB48qHJMGYiQpnFCCx6ffb4C?=
 =?us-ascii?Q?9KPRaOSAVJxsrYgpzYaCwchuiYXro3F3X01gUSVcdB/d/exg4DhR1dN6tm8x?=
 =?us-ascii?Q?/XWqsBLYZU4ArQCVWJeJQsLMfCvKbMRnrSHbNjIn3imnIrnNA/Qt/749tzod?=
 =?us-ascii?Q?1hKnukhmpKoKt+2nRrJffrnF98wWuPXchL6qkX58?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8584a8c-4474-4fb2-f2ea-08dbeb5ccd07
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 13:13:21.3410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cauZ4wIYT3GlE9dmcg4XZJki+RGew5uvDEZu1flxKokI5eK4ugrTb6Q33xGjeN+J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8489

The mixture of kernel and user space lifecycle objects continues to be
complicated inside iommufd. The obj->destroy_rwsem is used to bring order
to the kernel driver destruction sequence but it cannot be sequenced right
with the other refcounts so we end up possibly UAF'ing.

Fix it by using two refcounts and a wait queue to sequence the destruction
process.

v2:
 - Use refcount_inc_not_zero in both places in iommu_lock_obj() for
   robustness
 - Move the wait_event_timeout sequence into
   iommufd_object_dec_wait_shortterm()
 - Consistently dec users on the bug path to give close() a chance to
   recover
 - Change the order so if users reaches zero then we clean the xarray and
   then unlock. Wait for shortterm to reach zero outside the lock
 - Make iommufd_object_remove() non-static and use inlines to call it in
   the various cases
 - Comments
v1: https://lore.kernel.org/r/0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (2):
  iommufd: Add iommufd_ctx to iommufd_put_object()
  iommufd: Do not UAF during iommufd_put_object()

 drivers/iommu/iommufd/device.c          |  14 +--
 drivers/iommu/iommufd/hw_pagetable.c    |   8 +-
 drivers/iommu/iommufd/ioas.c            |  14 +--
 drivers/iommu/iommufd/iommufd_private.h |  56 +++++++--
 drivers/iommu/iommufd/main.c            | 146 +++++++++++++-----------
 drivers/iommu/iommufd/selftest.c        |  14 +--
 drivers/iommu/iommufd/vfio_compat.c     |  18 +--
 7 files changed, 160 insertions(+), 110 deletions(-)


base-commit: 98b1cc82c4affc16f5598d4fa14b1858671b2263
-- 
2.42.0

