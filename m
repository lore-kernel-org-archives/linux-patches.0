Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA25235375;
	Tue,  8 Apr 2025 16:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131276; cv=fail; b=oVXXNryWmnEAUuBZvu7DRnrwVH1qbJuAQ4THtoa6hKa/OSSbUJKKdd5ly9+TOURFt0W3kHysCCcpLhndv3UrZEMbZ45lpPNT98hRjpN8X8CQUhB82Vy2Ry7QpBVu6GLlzTwhbbPjfkGWlKAsXQRwJ8hO6DV6pp2PdPQPB9sFpa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131276; c=relaxed/simple;
	bh=lJi0ntug5gJCFv/E/eo5Mt80TEJhmSuCHCEY4rZTPHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JFZSqKXzp0ICozYH5euzElBrelefO24F9Y+tKnGFOJNdeHDEKmpKgIpfESs81zBEl/EXFXSCQeMRxNsSv4H9uYIXMdwP/BNRNufnkQF8NveBvkM8TnHEaK7AXm0N2O+oN1GEINBu4Q0cDXeY0tYfEr7XMFtKAA5XftCrjFSZDGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=deWOYAf8; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="deWOYAf8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIupMjmU8xWWuRk23A/MjoEkmtXcgu0Iz2v+Q4Bvt9bSFc2IUhfAQFg/+ieOazIjVHWkjp0xqXnVqsq0QBKL0t8lGOX1BuCj8stCg/1z12HXWnHTaERyisYZVHWg6OyUqhISvDVC4nkdlhosZdkI02b1Kn4aBg6KZg6X+78rTA9whwKwVydZU5/tUm/FODmBGzpbFt3bubWAIhX3yUBElhNESyht6+jZ2dJDgv6Ddauzx7MlNOfKq+DGiJ5tbAMQnK7F4QHLtfqr+RmVcvxEcSuiZ/Nl+y5TTUF+zs871/C8OU9RtVEQDH+GWEHyAgY6Y8kTG+/qJLyOdWJZJGxYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8WErc2pnUE7qzKEaC24MbHlg2fGkssemXiFi6+jzP8=;
 b=hDsvRPGYUUaT8AWY47KXhoo0IY6eL+tUUaoptIB3IIQP51+3Llo7ZrDuQtuoLRUpU1PTI//1IqEQ+fK1o+oZZrVg4QAsuZBPMFuZe1qj43LK8yKewOMYgeLBC1xj0JZAsz/HxI/mhcihI+DWb8WBgrwiZrzRzhNRnTWeNm6o0m9iKnhBtJfr5kDRx35EvHmxecvmb7Ue+rlhl0lD2MmSFrftIWosKwmQA6iJmZeCdKhRFfhFSKHtvSXRGm9hb31UTf+pqMFKnPEEYwvKh1OTZKlHTcEp9hisK91vItNcCNp4WeRwifmKqRYHe8j8T/OJ54EZjmWd0MbxO37wgXrLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8WErc2pnUE7qzKEaC24MbHlg2fGkssemXiFi6+jzP8=;
 b=deWOYAf8O2guxp97cnnbBeiLIW6QF5GS+6zi4Ekh6hlIOWnKk2/tXqdOhxdTGqxXuB3fMd8L1nU0DjuLZmkpE7Raq2bAaAjdz+Iqia9V5z0UREyKsJ3m7B4fH3eLxPsJwvXpzY0ojM5o4O/d9WTkimcLc1BkLKA46Zjg20dbwxHn9z5XOnVYlQKRaQpBtWmI+2WzsNYx6mD2RKllGtM9adp3UlVppmR+bNg2ED2ZcOtFiHSpLXwftLFAPYKxPz4WKwqETInsLEcOSThH3c5VLGVlZhGgEAVWJCku68rodukBOIA/1vlTunuQhZEN+Z6VS0m+6hMIxYxyLDDkHjA0xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:22 +0000
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
Subject: [PATCH v4 05/23] iommu/pages: Remove the order argument to iommu_free_pages()
Date: Tue,  8 Apr 2025 13:53:53 -0300
Message-ID: <5-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR12CA0016.namprd12.prod.outlook.com
 (2603:10b6:408:60::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc25c4f-7d41-46b9-ca86-08dd76bdff72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8LuOf0JddaPS19C5S55Ks1r/8ev9BGBhlBID4K7BK2hdFKD/gLbLzTSwjOYz?=
 =?us-ascii?Q?E444a2r0i7gnLJTWWEXehyM0MvC7hjDTug7J5b7LDN1yrASWdHSU2tRFXJvi?=
 =?us-ascii?Q?Oyoczrllbbz1E+9uMhyWf8YVZ9+LC5ICtuo9lhqR5oRFDWvmcGzcMRX66plr?=
 =?us-ascii?Q?CtJHa3rpdEfvwvXIE0AqgWkRfodO3yZ7cDN/4Fn9J9huqqJ9i72G0zp0q4ZI?=
 =?us-ascii?Q?n/szUdwADA8y2H951HdzPgGifalb2LAd//bZxZONiH2Yt7moncJBqmt8LF2c?=
 =?us-ascii?Q?fWMkjuieO97izzjQ1NLaigxL5gVHHOEBIqFSMiJO1YOcIwH+in5J+D1Ul2Bn?=
 =?us-ascii?Q?s4ZMY23GyhD3C/vbAJ9tfMX/FYrQH5qdl5rCg+oXfV0hz9PVk6MN+v//A5R5?=
 =?us-ascii?Q?5xGzBrrOJPgaJQx4qArcg4cGwiYI0JyNunQv084EfsEyJ2KHFwnhgcF6veiK?=
 =?us-ascii?Q?IkmZcalIvzHykC/uCt+alGmASixnp4gDWoWBmYuSYsSXGJW0f+w34yF51R62?=
 =?us-ascii?Q?g3j7pHZqeXp2GZyrRhE1KxDIrRm6ITPLNdkXTp6m0nS8Zzn15sFlg89N80zg?=
 =?us-ascii?Q?jPzpbQfyMxkuQZz+Tj6SY7pw7NH9/oJ4CQPY6z1xCrABQfyZNsudVwmf3yi9?=
 =?us-ascii?Q?bXGBU/d8xm9b0myp5Sjn2o0Gr+l6g4Kdt0C2xI1m++EvBFDmdZlPEKuNLCrY?=
 =?us-ascii?Q?7CHDCVDHcdwRlcsUt/vm6TDk3IqJzrSLwVtkR14Y2/glcvrZr3zb2O+fOcNZ?=
 =?us-ascii?Q?37xAu/czew8BemlqfCQTybA7YVbPF9ik/9OQd+cBpeDneqInvCB3I0FctWIh?=
 =?us-ascii?Q?GzhD9UFR4snuHEMwNe1W1h/MWTVflEs9YMRCV+xHDBnr9syW0ckSO75cOyfp?=
 =?us-ascii?Q?POUV/MdwNNUSpAChG5KFocYXGxcvHbmgj+0JyyM63HzDb4DgQayxuftXmLew?=
 =?us-ascii?Q?lt29LPEHTAk0QzZFqRs7obE/HYQH+HTNw2aPjdFc0P/0lv7/QMEIRJ5NkpIs?=
 =?us-ascii?Q?HI4dejkgz1a78NRzuIxeBlxBMLHj2P2/sFWvQ9MIwHNx1HpFT6LI8IkatP3e?=
 =?us-ascii?Q?7bMCSoOTafPYE32M2/7/aSXgkeikNmCyk4pz7TBuQdH51TpE/bMUe/tG/u8z?=
 =?us-ascii?Q?qm9+cKgGWL7mq102rTcqdoEwWmTUiJrOLf1Pf3L4muE7J5StY/pnxGkod+wM?=
 =?us-ascii?Q?ddlPYLXKhHYzDDgUujC8mjZmOWCCNIE+ngPe6lVI81o7fGFl3VJM8p3BrUQj?=
 =?us-ascii?Q?VyIsikfc67hRDOX7gK6UeKjUQ/wlrZdnxGycBWXdws7+bIio0ggcJHaIpR7Q?=
 =?us-ascii?Q?63DQXCOInyKL2p+oX/01yZjsGdTsrG7ddbZqQCMcpzm+F5oaH3jwp7woj21/?=
 =?us-ascii?Q?So2msWixRrk1jiwJFCUn2QwIyXymkiibLerRjMoov8RCjn82N7WIyCPkx8pd?=
 =?us-ascii?Q?pttrywNh7WS6rIoibAxl2i5dtFcQubpRYoy4qoiI+FoZ13EoEgO8/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a0aFDw/DFK0imIFKmhxTCbZQ0jSdY27Hqhh5qq7bdWg6oe9I4udfthODOTD7?=
 =?us-ascii?Q?XB5aM1FDV+X33t0PaqC8YGcuoOsWR9lKToGzpY4jJC2SQZqFN9IZI4ZmwAlG?=
 =?us-ascii?Q?KxxyfztJI9iqUwU2FrLULgo7G6Y4gqwjyATFPIV5fP10ZLwq0I4035ViLuz/?=
 =?us-ascii?Q?crq1+fu1QNSHSnZor9HyLa2Uz0aD/yCdpMwf9mh8nuDdLK1ILXj6ZCPRQCWF?=
 =?us-ascii?Q?U8IHh2eTRhqka8GZ5FTUgPxRyEW1wB1qUtyQPx8THvESG5+MjEx+E4MVGdjL?=
 =?us-ascii?Q?4Ki0nbmaiUnTkAknw8lvfMXrZOUdH3pz2gSSsJDfDKLOlfFh1fj9VNfM91LC?=
 =?us-ascii?Q?XkU94eT1JxVXHJGPEc4WdZc0D+IOOUdUOEdbRbpgJwFunvRKVXItNM0IhA+s?=
 =?us-ascii?Q?AdmLrZORCPH4xyoiAHAN9IwqTObWtpvRVUGXiB3bo2QGlV3WYwvFPc+Gu/Bq?=
 =?us-ascii?Q?7P6VvLRr0Fnb8E+mPN/6dDMtbvNnSikCF1MIuXYz3nWm8PC8H6ar61vuPOIb?=
 =?us-ascii?Q?XEbYOlfJvRGRZxGxUVxbnWlZ6wo/nseILmAK97uVmVaezzJ3ppR/n3/dh3uv?=
 =?us-ascii?Q?+fMQ3PKVyIT30Nm8Dpw9jh7YZu0/B1woUOPQmTwI+UhJ6zrebZBAryDS+SqX?=
 =?us-ascii?Q?Op36E2mdkA9OfsEl5nmXVoiUtMpjX5KyOd6IYhT4rF4st/DQdqQ5p8f76qk9?=
 =?us-ascii?Q?8pDslcadLct/aO0ZUR3kDfw3UhA4b7u2Jjyy3BXW34S/R36gpbGonPNaqZUH?=
 =?us-ascii?Q?nykvSXizzWQ2TSBUN0oM0U5mA9QfT+h4zXwkGIwT9RuBOzDRxamLKBzfCNzJ?=
 =?us-ascii?Q?3q/HJrgWePUoaKBJSKGSxGM9JxbufxY8Bd1jqtYh45jj+aWTo198oquWMoDe?=
 =?us-ascii?Q?1tRMRWq8pMvjsQTuE/APCb73VZ16mL7oB1RGWWr+dfB+9ATd/8Az3r3TIokx?=
 =?us-ascii?Q?y7nuoISXflOeWa+dx8HHZAcRwb2SqDGZ4AqaW9t+C2brxl/AS2WQ9IbvprVv?=
 =?us-ascii?Q?k5CA15kamQwrayJo3wOo6k5jsCVQRzBOw+pZ8xG726YpOMudWPCV+VNeKho2?=
 =?us-ascii?Q?CE3RdTXT9Rr43JpfPLiWgvuVlVZDnEC3F4ELoqDgnlA87wIzHtBLf+6pNQvH?=
 =?us-ascii?Q?4nc1phfXyqQm9UWB2g4Is1+7kfPOzsq5hIUFfbJC1tN3tHHl8baLux63Mnk8?=
 =?us-ascii?Q?NTOrd+ieaDwnzaqatdTclToCOleL9HxpqBGSl5XllR4POTFVBu9D0Kg5zQdl?=
 =?us-ascii?Q?S9xk2w6gdntqP+4wnDYxuVy3jTtAYiw3Kw8BQBtHoJDh0FTBkRnO+oibLguk?=
 =?us-ascii?Q?AmaGmDPReyH0umCmQSvAcHkO1mAKYJjidf4gETuhi/3RogGcOFO6gBzbtMAd?=
 =?us-ascii?Q?b/fgCilDyhV/EbHq3l2oH56wv7V5xXgY1PoV0RTUcmbqM+yh7XZX+oBa3G0i?=
 =?us-ascii?Q?Xia+/lSthozntwf9BDwxTBvfJYn9o3EdtNHVK2EF+MNThhNSJ+DTOGN5nYvi?=
 =?us-ascii?Q?BAirtkQmw2iMPVzK/tmdXp39jcXIL9FKkh3Bo+MHu6duy48HhkWl3b2rjFxl?=
 =?us-ascii?Q?SeAk5x1pEI2M4miFV1RSsMFY/8GuOOJTNeNklOk0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc25c4f-7d41-46b9-ca86-08dd76bdff72
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:16.7510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0FboWi2cskBMxPzA//WJiLri3I2qMLQ2L2k9JIXj1I6As868PR9tOO7JG7Rk4Ox
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Now that we have a folio under the allocation iommu_free_pages() can know
the order of the original allocation and do the correct thing to free it.

The next patch will rename iommu_free_page() to iommu_free_pages() so we
have naming consistency with iommu_alloc_pages_node().

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c            | 28 +++++++++++-----------------
 drivers/iommu/amd/iommu.c           |  2 +-
 drivers/iommu/amd/ppr.c             |  2 +-
 drivers/iommu/exynos-iommu.c        |  8 ++++----
 drivers/iommu/intel/irq_remapping.c |  4 ++--
 drivers/iommu/intel/pasid.c         |  3 +--
 drivers/iommu/intel/pasid.h         |  1 -
 drivers/iommu/intel/prq.c           |  4 ++--
 drivers/iommu/io-pgtable-arm.c      |  4 ++--
 drivers/iommu/io-pgtable-dart.c     | 10 ++++------
 drivers/iommu/iommu-pages.h         |  9 +++++----
 drivers/iommu/riscv/iommu.c         |  6 ++----
 drivers/iommu/sun50i-iommu.c        |  2 +-
 13 files changed, 36 insertions(+), 47 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index dd9e26b7b71848..69aad383f97e10 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -644,8 +644,7 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->dev_table,
-			 get_order(pci_seg->dev_table_size));
+	iommu_free_pages(pci_seg->dev_table);
 	pci_seg->dev_table = NULL;
 }
 
@@ -662,8 +661,7 @@ static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->rlookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_pages(pci_seg->rlookup_table);
 	pci_seg->rlookup_table = NULL;
 }
 
@@ -682,8 +680,7 @@ static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_se
 static inline void free_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
 	kmemleak_free(pci_seg->irq_lookup_table);
-	iommu_free_pages(pci_seg->irq_lookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_pages(pci_seg->irq_lookup_table);
 	pci_seg->irq_lookup_table = NULL;
 }
 
@@ -707,8 +704,7 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 
 static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->alias_table,
-			 get_order(pci_seg->alias_table_size));
+	iommu_free_pages(pci_seg->alias_table);
 	pci_seg->alias_table = NULL;
 }
 
@@ -817,7 +813,7 @@ static void iommu_disable_command_buffer(struct amd_iommu *iommu)
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
+	iommu_free_pages(iommu->cmd_buf);
 }
 
 void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
@@ -829,7 +825,7 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 	if (buf &&
 	    check_feature(FEATURE_SNP) &&
 	    set_memory_4k((unsigned long)buf, (1 << order))) {
-		iommu_free_pages(buf, order);
+		iommu_free_pages(buf);
 		buf = NULL;
 	}
 
@@ -873,14 +869,14 @@ static void iommu_disable_event_buffer(struct amd_iommu *iommu)
 
 static void __init free_event_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
+	iommu_free_pages(iommu->evt_buf);
 }
 
 static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
-	iommu_free_pages(iommu->ga_log, get_order(GA_LOG_SIZE));
-	iommu_free_pages(iommu->ga_log_tail, get_order(8));
+	iommu_free_pages(iommu->ga_log);
+	iommu_free_pages(iommu->ga_log_tail);
 #endif
 }
 
@@ -2789,8 +2785,7 @@ static void early_enable_iommus(void)
 
 		for_each_pci_segment(pci_seg) {
 			if (pci_seg->old_dev_tbl_cpy != NULL) {
-				iommu_free_pages(pci_seg->old_dev_tbl_cpy,
-						 get_order(pci_seg->dev_table_size));
+				iommu_free_pages(pci_seg->old_dev_tbl_cpy);
 				pci_seg->old_dev_tbl_cpy = NULL;
 			}
 		}
@@ -2803,8 +2798,7 @@ static void early_enable_iommus(void)
 		pr_info("Copied DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
-			iommu_free_pages(pci_seg->dev_table,
-					 get_order(pci_seg->dev_table_size));
+			iommu_free_pages(pci_seg->dev_table);
 			pci_seg->dev_table = pci_seg->old_dev_tbl_cpy;
 		}
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index be8761bbef0ffb..b503d01e3b8008 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3246,7 +3246,7 @@ static struct irq_remap_table *alloc_irq_table(struct amd_iommu *iommu,
 	spin_unlock_irqrestore(&iommu_table_lock, flags);
 
 	if (new_table) {
-		iommu_free_pages(new_table->table, order);
+		iommu_free_pages(new_table->table);
 		kfree(new_table);
 	}
 	return table;
diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index 7c67d69f0b8cad..e6767c057d01fa 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -48,7 +48,7 @@ void amd_iommu_enable_ppr_log(struct amd_iommu *iommu)
 
 void __init amd_iommu_free_ppr_log(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->ppr_log, get_order(PPR_LOG_SIZE));
+	iommu_free_pages(iommu->ppr_log);
 }
 
 /*
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 69e23e017d9e5f..8c14073febf07a 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -932,9 +932,9 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	return &domain->domain;
 
 err_lv2ent:
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_pages(domain->lv2entcnt);
 err_counter:
-	iommu_free_pages(domain->pgtable, 2);
+	iommu_free_pages(domain->pgtable);
 err_pgtable:
 	kfree(domain);
 	return NULL;
@@ -975,8 +975,8 @@ static void exynos_iommu_domain_free(struct iommu_domain *iommu_domain)
 					phys_to_virt(base));
 		}
 
-	iommu_free_pages(domain->pgtable, 2);
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_pages(domain->pgtable);
+	iommu_free_pages(domain->lv2entcnt);
 	kfree(domain);
 }
 
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index ea3ca520391962..6866b4e6284842 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -612,7 +612,7 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 out_free_bitmap:
 	bitmap_free(bitmap);
 out_free_pages:
-	iommu_free_pages(ir_table_base, INTR_REMAP_PAGE_ORDER);
+	iommu_free_pages(ir_table_base);
 out_free_table:
 	kfree(ir_table);
 
@@ -633,7 +633,7 @@ static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
 			irq_domain_free_fwnode(fn);
 			iommu->ir_domain = NULL;
 		}
-		iommu_free_pages(iommu->ir_table->base, INTR_REMAP_PAGE_ORDER);
+		iommu_free_pages(iommu->ir_table->base);
 		bitmap_free(iommu->ir_table->bitmap);
 		kfree(iommu->ir_table);
 		iommu->ir_table = NULL;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 7ee18bb48bd469..58a13366b41c7d 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -67,7 +67,6 @@ int intel_pasid_alloc_table(struct device *dev)
 	}
 
 	pasid_table->table = dir;
-	pasid_table->order = order;
 	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
 	info->pasid_table = pasid_table;
 
@@ -100,7 +99,7 @@ void intel_pasid_free_table(struct device *dev)
 		iommu_free_page(table);
 	}
 
-	iommu_free_pages(pasid_table->table, pasid_table->order);
+	iommu_free_pages(pasid_table->table);
 	kfree(pasid_table);
 }
 
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 668d8ece6b143c..fd0fd1a0df84cc 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -47,7 +47,6 @@ struct pasid_entry {
 /* The representative of a PASID table */
 struct pasid_table {
 	void			*table;		/* pasid table pointer */
-	int			order;		/* page order of pasid table */
 	u32			max_pasid;	/* max pasid */
 };
 
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index 5b6a64d968502f..9859bcbd425e16 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -340,7 +340,7 @@ int intel_iommu_enable_prq(struct intel_iommu *iommu)
 	dmar_free_hwirq(irq);
 	iommu->pr_irq = 0;
 free_prq:
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_pages(iommu->prq);
 	iommu->prq = NULL;
 
 	return ret;
@@ -363,7 +363,7 @@ int intel_iommu_finish_prq(struct intel_iommu *iommu)
 		iommu->iopf_queue = NULL;
 	}
 
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_pages(iommu->prq);
 	iommu->prq = NULL;
 
 	return 0;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 7632c80edea63a..62df2528d020b2 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -300,7 +300,7 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, order);
+		iommu_free_pages(pages);
 
 	return NULL;
 }
@@ -316,7 +316,7 @@ static void __arm_lpae_free_pages(void *pages, size_t size,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, get_order(size));
+		iommu_free_pages(pages);
 }
 
 static void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index 06aca9ab52f9a8..c80ccc753b5e60 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -262,7 +262,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 		pte = dart_install_table(cptep, ptep, 0, data);
 		if (pte)
-			iommu_free_pages(cptep, get_order(tblsz));
+			iommu_free_pages(cptep);
 
 		/* L2 table is present (now) */
 		pte = READ_ONCE(*ptep);
@@ -423,8 +423,7 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 
 out_free_data:
 	while (--i >= 0) {
-		iommu_free_pages(data->pgd[i],
-				 get_order(DART_GRANULE(data)));
+		iommu_free_pages(data->pgd[i]);
 	}
 	kfree(data);
 	return NULL;
@@ -433,7 +432,6 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 static void apple_dart_free_pgtable(struct io_pgtable *iop)
 {
 	struct dart_io_pgtable *data = io_pgtable_to_data(iop);
-	int order = get_order(DART_GRANULE(data));
 	dart_iopte *ptep, *end;
 	int i;
 
@@ -445,9 +443,9 @@ static void apple_dart_free_pgtable(struct io_pgtable *iop)
 			dart_iopte pte = *ptep++;
 
 			if (pte)
-				iommu_free_pages(iopte_deref(pte, data), order);
+				iommu_free_pages(iopte_deref(pte, data));
 		}
-		iommu_free_pages(data->pgd[i], order);
+		iommu_free_pages(data->pgd[i]);
 	}
 
 	kfree(data);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 26b91940bdc146..88587da1782b94 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -105,11 +105,12 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 }
 
 /**
- * iommu_free_pages - free page of a given order
+ * iommu_free_pages - free pages
  * @virt: virtual address of the page to be freed.
- * @order: page order
+ *
+ * The page must have have been allocated by iommu_alloc_pages_node()
  */
-static inline void iommu_free_pages(void *virt, int order)
+static inline void iommu_free_pages(void *virt)
 {
 	struct page *page;
 
@@ -127,7 +128,7 @@ static inline void iommu_free_pages(void *virt, int order)
  */
 static inline void iommu_free_page(void *virt)
 {
-	iommu_free_pages(virt, 0);
+	iommu_free_pages(virt);
 }
 
 /**
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8f049d4a0e2cb8..1868468d018a28 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -48,14 +48,13 @@ static DEFINE_IDA(riscv_iommu_pscids);
 /* Device resource-managed allocations */
 struct riscv_iommu_devres {
 	void *addr;
-	int order;
 };
 
 static void riscv_iommu_devres_pages_release(struct device *dev, void *res)
 {
 	struct riscv_iommu_devres *devres = res;
 
-	iommu_free_pages(devres->addr, devres->order);
+	iommu_free_pages(devres->addr);
 }
 
 static int riscv_iommu_devres_pages_match(struct device *dev, void *res, void *p)
@@ -80,12 +79,11 @@ static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu, int order)
 			      sizeof(struct riscv_iommu_devres), GFP_KERNEL);
 
 	if (unlikely(!devres)) {
-		iommu_free_pages(addr, order);
+		iommu_free_pages(addr);
 		return NULL;
 	}
 
 	devres->addr = addr;
-	devres->order = order;
 
 	devres_add(iommu->dev, devres);
 
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 8d8f11854676c0..6385560dbc3fb0 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -713,7 +713,7 @@ static void sun50i_iommu_domain_free(struct iommu_domain *domain)
 {
 	struct sun50i_iommu_domain *sun50i_domain = to_sun50i_domain(domain);
 
-	iommu_free_pages(sun50i_domain->dt, get_order(DT_SIZE));
+	iommu_free_pages(sun50i_domain->dt);
 	sun50i_domain->dt = NULL;
 
 	kfree(sun50i_domain);
-- 
2.43.0

