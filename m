Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012071.outbound.protection.outlook.com [40.107.200.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8E33F5AB
	for <patches@lists.linux.dev>; Tue, 26 May 2026 16:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779812113; cv=fail; b=CAOIK2CvQnWt9AsiJbd2atVYSFRPv3SYxULH/AN6HidvZTmt06DDiHl81L7wh1II2nfkE1kYbhR8KAdkmYVGs7XZb9EXAkHR5SYVTd/RZGjnLl4jI2D5sxbjdwkcXmuD4mLn/k/sc2CghonDmnAP858/Ot3n/EUdsgvxNTy+UMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779812113; c=relaxed/simple;
	bh=CMJLTLxtDDcbyG5cHH6tHalOtzTG01O5N7jfAUfA8Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TfgK4tFt+bfeWOpc9KWgBfcx4R39M5t2K/j+MazqxlC1sGT7ZOetZSRtBJPvQ9wK7TXWoEX3h2iiet6XHEXL1xorsRi+ekJlhEkNwsY7HuYyAXGbkczAAK6TE0v8f9p+c+TNo16bTr9FKMtOpx8uW6TreYOU30N+Qh7V8LaT50s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JCWN4V/p; arc=fail smtp.client-ip=40.107.200.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JCWN4V/p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+nkXJkCfHXpRxMZ07CnJsOOk1eU8wyY+MOs+kFBEroCef0iNwi4PNeJAGuDZ9TV7OXC1L8HTAjWNtdBJcK5j+y4wykI7WuPzSCyj+YfWVn9k+YeEMMIVu4Qiyp6APIaA3W33zRkBGS+mQidPztj068uBpKG2HzhG+x7JN8nOnpU2dDslxYCuDqc4pJelR84GQUJkpkX/GpIpLSaASu4w5hFooW5BKWG45C5/APFkJqA21bjfx9rCwT0QsTo0Yxrul3Cfadv3BWDQMLcwbJvK65PQxZYiu95NBUNBLG1o1K6InqgTxts/0p1xWp7NJYb0/JqxoraejEF9DtyCDKToA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=he6ApBcCXqTcwiHP83igeVPT6TpWtcImW5+YaAqvA1Q=;
 b=Tj+nYEN4iCa+6n/pClPDOGFLdV3mDELfjbD6+rltlOu+HxboBY6blGCpbuZuNlnn6zQ3l+d6t4ucdp7GVMx9qT+ImQZJzZTq8xYe3Mk0EEcuwMUlk1uwagK5/Z0bagyWV/5f1T8dkMX1YaHqUYdFLQb9eDlH87ghI5Ro+pPC1uY6dVtu6f4v7/Z5aC99eyHGNG2UzfJWGl9qtj/Kw5fUZQ+ihNGYswKiv06Z5CCYFw3ExDHXYKlcoJHLuB5XPS/FFx52nGLTOeY8BDiqYPjIh8yM8aNh7LX6F+mz5RUHHKF+l5DqKOkjZaCqyhN5eNUeDjIjv1721OpsTfORoHm9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=he6ApBcCXqTcwiHP83igeVPT6TpWtcImW5+YaAqvA1Q=;
 b=JCWN4V/p0DOnSjnB8SY0TeZ1DmLXsnMqFd91Y1HPpDkYFn/f8NS5DpKMWsGMVPEk9fvgJ6x18o4u0NWOC5ZNoQPCeKI5DY5pGwrbscZZL3vmTHBqRd6Svipqu7dofNmY+jmI8VZ1B1KDKwfEbY088mXvc9A8StHSS9accOQkbqhddJgYB0GbYohkvFH6HTkSlWeKKOUiPOVT7HYrxWpgfLF7e4uNCFtr3U3FHu3PgBqGuTCKYEboXk+iEBfffUOJWnZxA+KqJaBzpQbe1o/wHfIgGKeXjWYi/KyVjcJ0Xd9y30MgX6GkT4ISjJWKtcuq9n9pR6jAPRraORqkAYp2/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS4PR12MB9748.namprd12.prod.outlook.com (2603:10b6:8:29e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Tue, 26 May
 2026 16:15:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0071.010; Tue, 26 May 2026
 16:15:08 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Long Li <longli@microsoft.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	patches@lists.linux.dev
Subject: [PATCH 0/2] Remove stack ib_udata's
Date: Tue, 26 May 2026 13:15:04 -0300
Message-ID: <0-v1-922fa8e828ba+f7-ib_udata_stack_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:408:141::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS4PR12MB9748:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c516b89-ce84-49e6-23ed-08debb41f478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099006|921020|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	2aXYp4qSLQlwPpZCMPMJ+uvuo6sKoXU1iB+AWHElF4RWIXbSPkLjVRY5H5MyhofKuwo67ORKjywjRhkIJMgX9A4989mKAD87BApUf0GUNKAPznLX0lAxsnW2ZlNnEjjXjEqxeiDG+cBSl2M0/rn0LqJ0bzNCbN8zHqpHwjlyMaD1G7IPGTNqCLfAqjHsJiMjTK/SguHRlGUTE9NK5BA5cdlVzq0u6IrVD7AxsBLjNphrR+TAnWZ24mUWbmA3RVuYltq9cClDTrRgj25VDDUDpWRPT/SmGUSoWGFv18JrrpUUYRxh/jnoasqbkyOMHbPvEhqj6zfGqoB/+pID0ERt3SDb3wiu/fsqyvQjmYuK+uHp8CL1cyKNX3J933as+EN0NnzVIomuPosiIx7sZ/7WLuU6Dc9t0ZYM5y6BHHbHutY6PW9bSusKbY8WKkld0zYbqIGUy7YeG+7ZK7uHMt2QBe60+NwjTi/uuD47xS2IaO5PZNkIqvXLX9H6Q3O8y0nbpKL8Oi8rVNqd8DKUamZd6xrR7XggYUwNZGOrpA7HG7jJ+UeFZ/DwS1pfVBhUPKu6ImsDpnXdRQfT9qXMzuTnBeIy1+N7/Kmuuz60kJwnuQke02zfOySOYgLUlN6xpgCf/ncnzLT5Jqddtz6dVow8ujRCB2RrmJ8P2vp0WocTGvO5cGxP6960R1P7GEi1WijP0E7Z5/qZmHKqtv5hg2DrpvVhqQ5OMzVWaQ18MSxmcMw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099006)(921020)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cWRBrCvPuBZ3lY3+D3Ebda1srPA2NvJ1epUQTXvY8TvIvNTzUZDrgKkOdv1p?=
 =?us-ascii?Q?BPt84v03YsgYbFQRPU6woQa/UjpWen8vghWvmDVZdDLsKU1nnNm5NMT5Xxu9?=
 =?us-ascii?Q?/GowX29CWDmCf/HBahqS7h/WeHWv7oePatHB1XP10R9asxWY11eqO1JmD2MQ?=
 =?us-ascii?Q?SXCPMOzQcYa3tLs8KdzMeGMMpVJRzwRSdp3yfOzF+pWo+sGnjzczDgd0i+jY?=
 =?us-ascii?Q?u0RIvjJVYO9JQCrwffwxIrTyvFkDhpAwr+U6qd0IsV1wpEXOfJ8z1PXQDgNe?=
 =?us-ascii?Q?fj1HV9f+YO3AjK6sZmNB+uJ5sQut9ms2jjxPTdsPAfdaxUKjyliprICNwbMY?=
 =?us-ascii?Q?pvv3MwiaHkaSxs3X4xd6fHpGAiFUQEAgOuV0I3Zor/kkg1bKftyZCQBMWcnC?=
 =?us-ascii?Q?2k+RZZyi+M1Z8sEB+YCn/Yvr2bmslTFFsdGfL1wIn4B5+fTbDgXJFuoJ3gqY?=
 =?us-ascii?Q?YtIJswgNpjbupe6lW2ssY9lU7w0WUcCQGnfkW32Rq8uL9HpDHRtM15unJfaD?=
 =?us-ascii?Q?eWaMYHw0Dp+M2cz1gi5m/DYRopfA86Ix9o8NNeqA/tcakEALx0trh8TRMonF?=
 =?us-ascii?Q?dFiZaOlREwzRT1DTJ5cy4ngEdXtqExoaWNjxipfRkvDHFi0SuUhpfeCah3zm?=
 =?us-ascii?Q?fUlJb6j4Pmuxu6DUjAcuxp+R8GWdkU61xAhhVNoJvu/008Fl3sBVbVY0dBbQ?=
 =?us-ascii?Q?uS3tWVOd/rb+xG32LTm8pAhkYPpi0U6UtUT1LI0tCLi/zmr3KQVPY9B6p6c4?=
 =?us-ascii?Q?eX/+x+mqlg/TO2o6BEF+asSdpUgeMjwSmR3mRhqlBJSJy5TOHvGhq9JWCsbJ?=
 =?us-ascii?Q?IhevxuSBGOiM3p3OeHUs0uPndRUlVkQhaHek9MuH5Wg4LDCptxRAqM/PureL?=
 =?us-ascii?Q?CtCrQLS5a2Ttwbco9gQX7ZLM3EBDlbgb+DWZBXWdGyp0GFZZP1U74vo8RmFT?=
 =?us-ascii?Q?q+qMw1uzGJ5C+Mt8Vpvp52UK7wB1Mm/9Gj4uZn6rg+nJ8yf8rUS8IISNP77e?=
 =?us-ascii?Q?ykFKcrb5dyjIdJ+k648O6Z1+/WPXTGVuSpN1a7MplB0mwApk1AZdNlajOr/A?=
 =?us-ascii?Q?PKMFPtGYPgtQA2Zv8PILbROvK6U1r1NIDJNgOiFwkxL7yjZZI5UmpL4WtSuu?=
 =?us-ascii?Q?X5SeCcbLK5aeQDOkXXfPdXKxDi/zH/Vk0SGT9icGjMBzUh62Ln6StdAlUSAc?=
 =?us-ascii?Q?VCxNaRDEjLumZ7nT8bhj2kWTsCz3kjwtudcWsRRjS0RcedQxgOrSdwWmagkk?=
 =?us-ascii?Q?lPqZSIZOsi6ZDWB80qFINC3giit4g65tDH83yQ4chlM7zSDWmUPED5jpIFhK?=
 =?us-ascii?Q?C9Njxu0fUhIz/61GfmWEFz9GoTYgTNj0MHewzwm2Nk8K3MTeZvPqILoPTlzz?=
 =?us-ascii?Q?gnjy5gNCxKTwPYqcn236+jPC5Vw3tCmjpGXFqiop0sz2itDR5cyj8OOneelw?=
 =?us-ascii?Q?9R7ws7PuS3JKUTRJF2QO2T0WMMB5JYW2X3fq0Emj5LFIg92l13C00MLU3hMq?=
 =?us-ascii?Q?Yo1HjBCTj3dYtsqLvmWLqtz9SF5w/fsl8HOAm/uJWyNEbUcH9Pdkyef8MVfb?=
 =?us-ascii?Q?D4VmLDDsKjYoKofBEEGGObTxohOBP+tDrX4CNPpY1GtfVaOjAdEswPzQSMLm?=
 =?us-ascii?Q?F9y6DCbhi125NC5Ly80KuQMY/8JOM5a5b+8LEOQu0zm/2s+dlJKeFUeehNJN?=
 =?us-ascii?Q?um1po03GCGcNqakxd085tnBq+SnIONmgoyDeo+wTDS1hhIH0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c516b89-ce84-49e6-23ed-08debb41f478
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 16:15:08.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Si6SWvfeASMeRuYOxDsAWXaSmkQX29jUj7UZLGzvhk5op+hV6E1kKmkur43qg20o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9748

Sashiko pointed out these are dangerous, and the create_qp() one is in
fact a bug. The query_device is just ugly old code.

Remove the stack ib_udata's from both places.

Jason Gunthorpe (2):
  RDMA/core: Don't make a dummy ib_udata on the stack in create_qp
  RDMA: Update the query_device() op

 drivers/infiniband/core/core_priv.h           |  2 +-
 drivers/infiniband/core/device.c              |  3 +--
 drivers/infiniband/core/ib_core_uverbs.c      | 12 +++++++++++
 drivers/infiniband/core/rdma_core.h           |  7 +++++++
 drivers/infiniband/core/uverbs_cmd.c          | 14 +------------
 drivers/infiniband/core/uverbs_std_types_qp.c |  3 +--
 drivers/infiniband/core/verbs.c               | 20 ++++++++++---------
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  5 ++++-
 drivers/infiniband/hw/cxgb4/provider.c        |  8 +++++---
 drivers/infiniband/hw/erdma/erdma_verbs.c     |  9 +++++++--
 drivers/infiniband/hw/hns/hns_roce_main.c     |  7 ++++++-
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  7 ++++++-
 drivers/infiniband/hw/irdma/verbs.c           |  8 +++++---
 drivers/infiniband/hw/mana/main.c             |  7 ++++++-
 drivers/infiniband/hw/mlx4/main.c             | 13 ++++++------
 drivers/infiniband/hw/mthca/mthca_provider.c  | 13 +++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |  8 +++++---
 drivers/infiniband/hw/qedr/verbs.c            |  7 ++++++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |  8 +++++---
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |  8 +++++---
 drivers/infiniband/sw/rdmavt/vt.c             |  9 ++++++---
 drivers/infiniband/sw/rxe/rxe_verbs.c         | 14 ++++---------
 drivers/infiniband/sw/siw/siw_verbs.c         |  8 +++++---
 23 files changed, 124 insertions(+), 76 deletions(-)


base-commit: fd9482545e37fb6b7e04b588ad2bd80a2779776c
-- 
2.43.0

