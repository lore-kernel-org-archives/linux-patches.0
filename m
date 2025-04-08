Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F8B23C8AF;
	Tue,  8 Apr 2025 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131273; cv=fail; b=LlW+IS7vT8T/RdhbtqlLO42NunN++Vgo7jioJXWZmA7WWw4E5bqiPSH6LXPus2+rLxnF91/3YQbY1lgWd/zyeHxF+6Obd+Wt5tRWCRlcdyhnsuqVnXmif41/26J25ZejSSs8hywS3HoJ5Dyblrssy4RR1VL504miAEekWdYp1Ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131273; c=relaxed/simple;
	bh=JlnbcxNqhs2Forf0o3w7wx56j95ABcPtHE9tLfD8xzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MIxm+ja9I+PNOC6R1cIi9vbJZfAsxkRdN9UaYIKjDUBkwr3bTRnHhRgVPr1SWayH+lWg68WoEG+tRRtiuwUz8Yyyg2fW89ioCF+4Xp5YO/mDJnDewxC/XZSmK5faaYowm0Vk4ls8xSfiSRxsPodoFQunEt5SQ2V4YjxpRW8ZY0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q8gfJJhA; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q8gfJJhA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2xBvxQ3hVWQ+GEHvUdXrPET78zu0QfXqivAuvCohFJqSDxmjBrwqo7pS4MPV8Y99ixbWfTobkaCgHPw5lIAQYEt8d+Yvgdk1/xkq+TdOa4hGOzpvJRoO5Ei4B2oXCpOBLSgX7iUF5YAP1nH7U+cTmDPF+ZjFwJD60CbxMoX14CWAbL83FGSdkksnzQTZEAtIW3hHPsTaFnn56u7F+s47+Iaqjm9w+AeqdyHg90CUqWx/npQkcVn6lEJIHihPm1b3gdvVMHWuJDNXnFyk0MhmdKMmNkvj+WCxZY/8jeGgiqpSbYNz+rIS/yaRG9U5CeljEKap+YLdyLydNgcHrt01g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgTEvV7v3q40KTL5MdLmBUliyzoqF5VO/B9uqMhOrRk=;
 b=oKacMqbMBokix+DktkeQxKy96DHv1QwYTYbmzbLrzrwyXHJjjtwrQPNqOiEMqJQvq73EqiDGTAOMy+FZGTkguNEGJvOGJGs8D2W+ewrY5u0/8N5Vb+davsclrggNlpYjlEStYqq/r0VE3Klg+HahbohkkXyt5kfDlr4MbDxUv599g9V8m1eaGLkXR+7zMWYJgpkxJJ/rS0Rq51XuvCTd56vsE0wjYNZhk7fRg/4PWaD0rFLNzR4piZ80TRcJbwAnUhXFXNU394ZoCcgS8drMoItCwdQ6eaBxKBvx40zybgrAYxVG02lce0UvwmTomnD/mnUSTLoH7/fp8LgJ0TH0sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgTEvV7v3q40KTL5MdLmBUliyzoqF5VO/B9uqMhOrRk=;
 b=Q8gfJJhAKdSmjBR7XciDHGYwPx1r8NSeIaOThNlRp65OvIBklqSvSAmKPWssxroSb/Wp5F0hu1CxcE1/daV6MJmy1KoOuYObApYtScv9z3Koc7NczjrSYTR754l2/pVbx6TXx05XIB7HazLXZ5Dg2EzzGHWkN8fH3bkZ8iU8bfVA+dPtgJ8Jua+4UXT7RCJ95lcUTFJDNNgbshGPJyXsNWXOItJz0sUfUi5CNYe7VzYxIDvczlU4IcvgVbGRDGFwdqBPL9fEZFFLmJFb+3kfZfZzPscKGeaSQtf5Tmi2aUmNVpkyTzuE88CtfTH90wF5qXBYli8OiKcaODuGWrDCew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:24 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Neal Gompa <neal@gompa.dev>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 21/23] iommu/pages: Remove iommu_alloc_page_node()
Date: Tue,  8 Apr 2025 13:54:09 -0300
Message-ID: <21-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:32d::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 9565e244-52e5-40de-b08f-08dd76be019f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I+b9wUkTUZ8d+qB6Dlcw6IZCFaDLjrcyPfliNXgMaTH9BXfYT6sxADgi8Y/q?=
 =?us-ascii?Q?9QTNOJOyfn2fgCAz00NDL4mTEaeNjHktgZVEPHCliNKNQYYAJnY4jW4YUDwt?=
 =?us-ascii?Q?z4l9oWmkq0RpTrWuyCFTJwCbqptM15HV4qEVbwsGpgnWRlCY7F0rszbO4nlR?=
 =?us-ascii?Q?80Ywst89ddKVVKAZzpHuuL7UU7CK9tyEsrIkpqrFwRJhRYgaNhMXB92SNnEo?=
 =?us-ascii?Q?5TsxqdmKb/Da0UynTm+rDXwyrrWF3tH8a3GGDswOd4xSo3cKvbvpOj648jDe?=
 =?us-ascii?Q?aPLO8mdfzCTj/fNEoTUixu3n84loEJp43tQ7zsH8M+pVqUQ3hJmODrx+qwPZ?=
 =?us-ascii?Q?SBybnqeUuD+9IIdVLv9IYbg5ZyB0bZfgJmsGvXnRIz28OJq+X8DmwYlBZXjC?=
 =?us-ascii?Q?ZEF6QqaRTdi5bf2RgtIef/DYWMwRkQumL10Dp5ru8oSm0heXEwPfIKsP2JHC?=
 =?us-ascii?Q?V3HFpoO1rccXX2KOmns8YZFRAL0CPGFXQ/7qNvm7vmsLjPWoy+ryctRmAOkU?=
 =?us-ascii?Q?mD2BNXkni+Hm9qDLsT5sNQN+wPmk0GjLDgF0syaQbQRoV7v6C7pbg5vNMmoT?=
 =?us-ascii?Q?lK3N/M5vT/HZbxVa2KotkoY+C5j9E4VHjHqzD0wOctTzghozJihigZDxcQCP?=
 =?us-ascii?Q?UPnFKeErf72bEgBE5XgGJPTgMJTZSlfaQOKXI9Th52mxgTAPuudcR0Yw2eFs?=
 =?us-ascii?Q?CpAdKlkVHsiAqYhZPfR29VNUjVLrnPVoTs5kq46GSKYDLG/20i9j919M5RVW?=
 =?us-ascii?Q?LnU05oZfJev21a0Nsvp1C2uSbBKg3vURdS2SlDQBVV4kivHA1GobAVfMJTCW?=
 =?us-ascii?Q?n/2MuGD/opCfTZ+B1ttjuwv+42lwdqjGR48HXBZxNUzIUxb4JFdm1sqXDSH/?=
 =?us-ascii?Q?flSzuKct1jyFovw9dL3tUyb6ZsgvIIJWy59K1+3KX735Jb44fzcU6HZ/lh3J?=
 =?us-ascii?Q?KVR92nuj17sSlMPPKNiLJaXzYXNSC9tRA0/utq+QysQRe/WYCRCkz3cR9CHj?=
 =?us-ascii?Q?vYdjQ2w49vNr6JpM9wz2o230VAiHdvDq4tmexvM+Dnw0rkouXrT26PFNyLEN?=
 =?us-ascii?Q?aSGXFUzUNjRcWhZuhkrNwPCqak4JHT3D2P43uxUJdCWDOgCCH3a73UNOqeIj?=
 =?us-ascii?Q?KcwX5jpuT4j2ZnNfgT+UhI6QYQJgLcrQ0w9hFGGpA+dZRhdyxL7sL4qxtkVB?=
 =?us-ascii?Q?k2ICxnXiQV1snsASesoXAsAB74SDGD3h9hoDvbceriIOBTBfLgUJzl0PcsTg?=
 =?us-ascii?Q?vd3MalelpQSitkCKnhtVh03N4I1KXYCnglJihdCV0S7AecVxxWcsJ86UZeGw?=
 =?us-ascii?Q?WLN/q0BBC9N/woWGz9PtL3Mj6Ra9qkhRGPQcMtO1O0e0tOJ+nEMNU1HCMEmJ?=
 =?us-ascii?Q?YJPRrzSN3ir80SlU5vsWGXn3yLYjhTV9K3YQt9KD4Y4huNM1pB8K396SoXqJ?=
 =?us-ascii?Q?PW5bOO1secpgW7kSPl8XF17akeT2p+I4Pa7AJKGW5QuFU1SPuFVW+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a3m05McrdF3rZQOUAVegQwKDGHgZd3yBdVsPkWQqM+nb6fPJlSNt9ZIwiwOh?=
 =?us-ascii?Q?yQQrpAVKoui534nzu88MUsAZp8jZJ2aFtNxETNl1az/2xbt37LstbWxScCc6?=
 =?us-ascii?Q?pmfFBVbq9Vmf2GAdsaUa+iCAhYrs2bqOG9v6Ih4S7tET1STD7HQZHoxBPQrv?=
 =?us-ascii?Q?V9ivaS/k2G9j/1aKt8W9h40i9cXdfg2k/3U7nq4Mpx/h0uSHOnVSuYOcM5K8?=
 =?us-ascii?Q?Aum28a7qAz+JseKHoocQ1wzYccpR2F3ci+d/NElM102E1y58P5SQE69fDSJ7?=
 =?us-ascii?Q?q+BTj4A+SBf0PhQjwSpuWbyBfeGmHNvzBgnJCtD5VqJ7Bg/4I0pNav8hyUeI?=
 =?us-ascii?Q?UZgmJqR+/rcR0PyWTAX0L81Iie0iv6cgGw59Y1arr4OLgFcHf3kLmyxguW0i?=
 =?us-ascii?Q?/HpzQty+tfXye29f0OT+cy74dK5+waTYo9DNvQlWKSqXFVSC0XqWm9Mc4DGN?=
 =?us-ascii?Q?ek6hQgeOt6VvQgxvJidoGw9Rn4xP6V+QvwVCsR7re/C3Cia/RSSwNoq9+JhY?=
 =?us-ascii?Q?qGAYiIG6bGJKwlIOJL0wLAkdvaKws03tTyYzZX/5fNQICFzFSHRQz1S/YMFi?=
 =?us-ascii?Q?m2kT4wOitLL8h0Yf2u+DU3jK2AXL8bFhFgG1uaXK0QvxzQeEI8n+jFo9Mkjt?=
 =?us-ascii?Q?AN4kNPZlQS0Wcqu/nMWiNqDg/565U3eoO4QkZRoos1K67CEzj2lvDjZ0aYqH?=
 =?us-ascii?Q?X26zlEu06thhPU8VHRRxp+NWcv6hpaYPF/kiADHKbJVcjy2J4o1Mb7zNpHM2?=
 =?us-ascii?Q?73inZT9+98KnU0lbFg3vIEHiRjhfoJ8Hsvg6hk6ZAbnz1p/jJ8zD5RTCX58f?=
 =?us-ascii?Q?3Ltnx4dBH90Nb/PwybzcqPnn+C3rJAna5HPeh8vWQtFF9NH2/IyJx+jQNO03?=
 =?us-ascii?Q?AWkPqSdeNCnPGDEQumUpwZsWxFCg+N9Ytyn6LbtbHKXF1veNeiWkF71Tdwl4?=
 =?us-ascii?Q?7ZKovoUlHT0qzWYAlSZInhVO5YCkYnukOa/qNnGI23zYp8R6xk9hQZDWb79n?=
 =?us-ascii?Q?cyi65yYbmShG9aCSIFUZz6+niGKdNr9R5LeQ1uy62tzI117pXfijFp0pfETR?=
 =?us-ascii?Q?d06TMjnut1h6Ut07a10bCXun+QmpZ0oGSP2b2CCOpV9cGT4kpsZL8inMh+0Z?=
 =?us-ascii?Q?1nZ1PVRkBG0z+9mSJ6cUD7KeCu5Xlof3GjB6FzFVCpyG7VSuQcdaYMRQSd/u?=
 =?us-ascii?Q?4wWzJ/FlFETnKDqcKcnV+fdA0zpapZFDA2E0Wjknr38QYIHcXMxfxTAnzkLD?=
 =?us-ascii?Q?BbjmMJK5ie9fepJgLzoZ/2F3E1Za1vOMUOIcAi5JbVXMJj0t/mBk8QKl7RQ5?=
 =?us-ascii?Q?l9JPT9RkylM7ZoP3KLzGuQJGjbZQYPYsF+P/4yU4dKSywzCH7zoHaFFf6dq8?=
 =?us-ascii?Q?Of5WvbO/5j4wTVT000Nwjuk1LQ3Eh5OAED6TJN6IcEJa976v3NRVWCnpTQun?=
 =?us-ascii?Q?tblTMR3UdNdRQUZLMVT25Ff2YRf92yTGpyTxcj60/80zc3K98yU1ZT0GHH8T?=
 =?us-ascii?Q?7sjo1/1OIBNjIKuoPcj8AT7BeAqNUWoOUED9DeET3MzYp3zfnFu28vvgOluv?=
 =?us-ascii?Q?njfFQLd6DzYez+K8Z7ko+GK8fKG8yY+D/b2ePdSE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9565e244-52e5-40de-b08f-08dd76be019f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:20.3136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIg8U78JGqKPT/YJfZ4DywU2r1IuWQgGN5MZgqOMYJI+DDjVHLJWTR8mxVdMB4gp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

Use iommu_alloc_pages_node_sz() instead.

AMD and Intel are both using 4K pages for these structures since those
drivers only work on 4K PAGE_SIZE.

riscv is also spec'd to use SZ_4K.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c    |  8 +++++---
 drivers/iommu/amd/io_pgtable_v2.c |  4 ++--
 drivers/iommu/amd/iommu.c         |  2 +-
 drivers/iommu/intel/iommu.c       | 13 ++++++++-----
 drivers/iommu/intel/pasid.c       |  3 ++-
 drivers/iommu/iommu-pages.h       | 13 -------------
 drivers/iommu/riscv/iommu.c       |  7 ++++---
 7 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 97ddadbcfb54d6..4d308c07113495 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -114,7 +114,7 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(cfg->amd.nid, gfp);
+	pte = iommu_alloc_pages_node_sz(cfg->amd.nid, gfp, SZ_4K);
 	if (!pte)
 		return false;
 
@@ -206,7 +206,8 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(cfg->amd.nid, gfp);
+			page = iommu_alloc_pages_node_sz(cfg->amd.nid, gfp,
+							 SZ_4K);
 
 			if (!page)
 				return NULL;
@@ -535,7 +536,8 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
-	pgtable->root = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
+	pgtable->root =
+		iommu_alloc_pages_node_sz(cfg->amd.nid, GFP_KERNEL, SZ_4K);
 	if (!pgtable->root)
 		return NULL;
 	pgtable->mode = PAGE_MODE_3_LEVEL;
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index f5f2f53273786d..b47941353ccbb8 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -152,7 +152,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 		}
 
 		if (!IOMMU_PTE_PRESENT(__pte)) {
-			page = iommu_alloc_page_node(nid, gfp);
+			page = iommu_alloc_pages_node_sz(nid, gfp, SZ_4K);
 			if (!page)
 				return NULL;
 
@@ -346,7 +346,7 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 	int ias = IOMMU_IN_ADDR_BIT_SIZE;
 
-	pgtable->pgd = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
+	pgtable->pgd = iommu_alloc_pages_node_sz(cfg->amd.nid, GFP_KERNEL, SZ_4K);
 	if (!pgtable->pgd)
 		return NULL;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index fe31166ced94b7..ed04d1471c2428 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1884,7 +1884,7 @@ static int setup_gcr3_table(struct gcr3_tbl_info *gcr3_info,
 		return -ENOSPC;
 	gcr3_info->domid = domid;
 
-	gcr3_info->gcr3_tbl = iommu_alloc_page_node(nid, GFP_ATOMIC);
+	gcr3_info->gcr3_tbl = iommu_alloc_pages_node_sz(nid, GFP_ATOMIC, SZ_4K);
 	if (gcr3_info->gcr3_tbl == NULL) {
 		pdom_id_free(domid);
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 4ca74a2b1a1109..7842e437fb170e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -397,7 +397,8 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 		if (!alloc)
 			return NULL;
 
-		context = iommu_alloc_page_node(iommu->node, GFP_ATOMIC);
+		context = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC,
+						    SZ_4K);
 		if (!context)
 			return NULL;
 
@@ -731,7 +732,8 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 		if (!dma_pte_present(pte)) {
 			uint64_t pteval, tmp;
 
-			tmp_page = iommu_alloc_page_node(domain->nid, gfp);
+			tmp_page = iommu_alloc_pages_node_sz(domain->nid, gfp,
+							     SZ_4K);
 
 			if (!tmp_page)
 				return NULL;
@@ -982,7 +984,7 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 {
 	struct root_entry *root;
 
-	root = iommu_alloc_page_node(iommu->node, GFP_ATOMIC);
+	root = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC, SZ_4K);
 	if (!root) {
 		pr_err("Allocating root entry for %s failed\n",
 			iommu->name);
@@ -2026,7 +2028,8 @@ static int copy_context_table(struct intel_iommu *iommu,
 			if (!old_ce)
 				goto out;
 
-			new_ce = iommu_alloc_page_node(iommu->node, GFP_KERNEL);
+			new_ce = iommu_alloc_pages_node_sz(iommu->node,
+							   GFP_KERNEL, SZ_4K);
 			if (!new_ce)
 				goto out_unmap;
 
@@ -3359,7 +3362,7 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 		domain->domain.geometry.aperture_end = __DOMAIN_MAX_ADDR(domain->gaw);
 
 	/* always allocate the top pgd */
-	domain->pgd = iommu_alloc_page_node(domain->nid, GFP_KERNEL);
+	domain->pgd = iommu_alloc_pages_node_sz(domain->nid, GFP_KERNEL, SZ_4K);
 	if (!domain->pgd) {
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index b616aaad03ba24..728da85a910068 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -147,7 +147,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 	if (!entries) {
 		u64 tmp;
 
-		entries = iommu_alloc_page_node(info->iommu->node, GFP_ATOMIC);
+		entries = iommu_alloc_pages_node_sz(info->iommu->node,
+						    GFP_ATOMIC, SZ_4K);
 		if (!entries)
 			return NULL;
 
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 4513fbc76260cd..7ece83bb0f54bb 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -114,17 +114,4 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
 	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
-/**
- * iommu_alloc_page_node - allocate a zeroed page at specific NUMA node.
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- *
- * returns the virtual address of the allocated page
- * Prefer to use iommu_alloc_pages_node_lg2()
- */
-static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
-{
-	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
-}
-
 #endif	/* __IOMMU_PAGES_H */
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8835c82f118db4..bb57092ca90110 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1144,7 +1144,8 @@ static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
 		 * page table. This might race with other mappings, retry.
 		 */
 		if (_io_pte_none(pte)) {
-			addr = iommu_alloc_page_node(domain->numa_node, gfp);
+			addr = iommu_alloc_pages_node_sz(domain->numa_node, gfp,
+							 SZ_4K);
 			if (!addr)
 				return NULL;
 			old = pte;
@@ -1385,8 +1386,8 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	domain->numa_node = dev_to_node(iommu->dev);
 	domain->amo_enabled = !!(iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD);
 	domain->pgd_mode = pgd_mode;
-	domain->pgd_root = iommu_alloc_page_node(domain->numa_node,
-						 GFP_KERNEL_ACCOUNT);
+	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
+						     GFP_KERNEL_ACCOUNT, SZ_4K);
 	if (!domain->pgd_root) {
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0

