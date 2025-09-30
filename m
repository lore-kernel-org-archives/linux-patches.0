Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011018.outbound.protection.outlook.com [52.101.62.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE1922A4F6;
	Tue, 30 Sep 2025 20:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759263597; cv=fail; b=Fi7VZx2W41i769qIxiHnKecPcgBYEUsZJDXcuos1Xf+ccEy6K/zL/yvhpAnoKkv0O8iG4LbynoLK8F9Lx0oj0xVVEzYI460ZH8QJ17Rfwaxnt/LSLpFjQTkgkb5HZdwe0At2K4FrJAZqVMjUi7kOMcdeFhy5F2aMwnVbYWMOMJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759263597; c=relaxed/simple;
	bh=4gibM8brsWvuk3KgpV78U/Ih7UBE9Oe/CXqqFuZe/Tg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuYikd65tlals+fEL2MH+AxD+yASibv6yZVdpACEkQTaWXzvasMicvNjf0aguDHrHFFmGghUrMcZDPkvdOiZPdZ3W4ocC8ny8pKoX7KLXPS4oddNO2jSiRVfxu6oiMn//jmYGxMaPdqvi1n6LQySw2mknGq9TSMR6CKRFvh4xpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NJ5EVz3N; arc=fail smtp.client-ip=52.101.62.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NJ5EVz3N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IC1UhLrYkh/gwenr8fCRaYpS9CwHwbVhXUfNDcRuDP9YHqTNF/hzTPZ33eRA7q/qoOVrlLxvXBqSWFcUc14ZcpcafDwilsGnLESmofaitdaPDrZoZ9gxTldcndtNSNcosRNzcry4f7Q2U/4XkgemmYLzjiPNfYJ6kWo8anm5URHhYBKcXBw7ZVvz1wQkQfekLWdN4iEA4WOgFuwQxIn8o2ZtY8wHpQIrYHUZuvrGlTetq0CYCcoZgy7aP9lyI2G4R48Oucb8d2BFiuO8U1A/cGtvoEJfetJQtMQzPL4qV5YKRZdqJWf/hNaNaEwSUPX9x1UWMPP77jVv1FCQi+uaBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qm85m20QEh2L7COLxiYAs3enh0N/WnT++fwn0WIfer8=;
 b=FTAKZ8j1RYmgLG9QeqSPSKM4+l5L2LPVJcCaENGV6sL1wy7cKQJY5LydN+d6WnYockFTbFjKR+ejbC10xNxC3rUBrDaDS27C5tfn3IFslOyFJHr0m9O13SaNstnfZQ7A2LeeGVwqEy5s5ZKVcz7rXfx64/PVSZxYg134pdxLOqbFfYC1bZOIVrGgMz1kX4zZczo9rzypvMUVXsjGl7bzwRhB3Of7h6Ly8oQsTPScl/dhKCjFvMzpAG/sHvNPWdeXl7X6JIHvJoAo2WkYXjAKqTssYnip0D7SIfOBCjsbkII4lzDwDSgGqXAXjT9PTeYgAyqT08cffqgywKxDsB1LrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qm85m20QEh2L7COLxiYAs3enh0N/WnT++fwn0WIfer8=;
 b=NJ5EVz3N7WHUxEfuUk5V8Pmi2usEqcyhKg7y2azOI0F46gGL6C8n3wJnLwQI1akfOWDKlLe1zoaoUxoi+mVM1lGs5D9wI9EuU42x5zOXnGvavRqM8kNYZzIJmYqTfh9OJ6nqiGFNQsPH1wFkv4ODmg5EJ9Rabs4TZZgSqjJLnI/vaF/njGCqWWju0G3vhsJ0dvYSTLFWnDf7NQZfZ41rLT0oMtpffFd01yvSH09wruUpaLiKqufYwIKEEMLiCLVXuU+86Mlm8uXDbd+CK97mgCfFHCLIfbhcZ6d58dNS9wKJSbbejPTWs5zpzB+XBW184RN1l+cq0XO7z1qWVoPt4w==
Received: from BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23)
 by BL4PR12MB9724.namprd12.prod.outlook.com (2603:10b6:208:4ed::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Tue, 30 Sep
 2025 20:19:53 +0000
Received: from MWH0EPF000989E7.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::fd) by BY5PR16CA0010.outlook.office365.com
 (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.14 via Frontend Transport; Tue,
 30 Sep 2025 20:19:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000989E7.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Tue, 30 Sep 2025 20:19:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Tue, 30 Sep
 2025 13:19:32 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 30 Sep
 2025 13:19:32 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 30 Sep 2025 13:19:31 -0700
Date: Tue, 30 Sep 2025 13:19:29 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <aNw7UVaktL6/05b8@Asurada-Nvidia>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
 <20250924214215.GR2617119@nvidia.com>
 <aNrxjkUEEUzKU+za@Asurada-Nvidia>
 <20250930121200.GG2942991@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250930121200.GG2942991@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E7:EE_|BL4PR12MB9724:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6a4521-b918-4be7-24df-08de005eb68b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ci0GPifVwGrf1ZZSLZErqSrb6f7Bcd5UuKNGbca4VzLvbAy3rX6Li0ZEOWRj?=
 =?us-ascii?Q?A0bmpqmuq4x7SXJ99+CvkeKuwWw4o9EX6ALCzvwA+OvTFWoMkT0j6gkyOgKQ?=
 =?us-ascii?Q?aaEL6UO+944bh+bfJggEUHKuPhRasZJ1u7mDGa8UknHK+223Rl4//1fF6Mlo?=
 =?us-ascii?Q?9MGVJCr7GzSEJaavk/miNIK7WHU9UqxpP3auDx5M1Y97vwY8foUCmRUHVcQo?=
 =?us-ascii?Q?KiDK7eMO+unWv4TztQtUT9STUce6jIB3k/iYe8EDFGG4w0yBUY3aQ1YYszf4?=
 =?us-ascii?Q?PZw80DH9PVch+1Z0Yjt6/z/TR0twmsDQ6+n6/V/MPblZc7M6q6DxLTO4mX96?=
 =?us-ascii?Q?MxIKoJy/xJ/fVgldnNgvwLb4zxzVjbxpIcjSPsvbIremAMYlKmUaArXl/e4Z?=
 =?us-ascii?Q?jymcLUvtzm6+zikxros6I3ypEbtydkJziGr5LUJGA+Zl+RIPaPjeMTKPr2sM?=
 =?us-ascii?Q?5jH/EOM4eypYGI21j2KTvJAlqNK3vpWBP85Jz43HkVp/QhlfbTvvYQReg5jT?=
 =?us-ascii?Q?h5eQ5Oe/lR+wj37CS0W79APfDLqqj0l46KyHyLXMG65GoeZmomKP4CYJ5lLh?=
 =?us-ascii?Q?LvFwE0igCyB5N1ikzXhObGyI068CWouc1arYCRKhSnLxeBv/eEpGQkuxwsMN?=
 =?us-ascii?Q?0ZrPxHpuTeJHCLDXZG/9v7vR7qO87pHj0AwpTRKmEnAdjoDwI9pksE0MWd+H?=
 =?us-ascii?Q?Eew+8l4TJoHR6lFJw2fbmMfUWX3h7I0tNtXfKAT4GWsWeI3yLlX6/rRXXqq6?=
 =?us-ascii?Q?LJE2wQXLO2kmfsp4AmWG6D3KUrb8Rh0aibRUjFaLmLZ4/FOAugC9X9tg/zaC?=
 =?us-ascii?Q?pPT7w2+D6/UMBAG16OlQ3+FuBDbmk/3lUXHzE22UnTGFrklPIo8YBOna26im?=
 =?us-ascii?Q?L7rT+zEZUSLM+BpsJE1aidk7ycyWxWTGja/WJeAUL1fQ5m8bEOlQWzGDPfu+?=
 =?us-ascii?Q?Q9DWJLGWGC7dZX/akcZxvivV0+oK2nQSb0IS7QQ56qoAYg3rtrzbBFIQSswY?=
 =?us-ascii?Q?6gE+LP4shuSjSsstd/VuIN9yRfYfityVCMhyR5oVguo/yWUJLwYKz6XhvLdc?=
 =?us-ascii?Q?u2Jmp9unkBwMqCl19Yj8Z8zsdXlN3MM5a3xWHOKMF61+65HhEBPdnMAPhs6P?=
 =?us-ascii?Q?1TP/JoMtnOA81inpQD90cpcgzfnQb+i3ttYJJl7fn/TwJi7U65WUNSroeSFS?=
 =?us-ascii?Q?kIPCL38sRZ6f9w1IGqMQOOV1i8rwAzZUhwBUg16QBoMOKVfB43JTCn2g4pm9?=
 =?us-ascii?Q?yFwiKfjjMkxUNXHHklwtG9oexKH58Q19hbnejZSPEdPRia8zqUgSN7CyQoJ1?=
 =?us-ascii?Q?9BtApfcel37Vcl36j4R7HlRF4W0oYrQz6rGMtFiOs0egdw+4uj96AAiV3F53?=
 =?us-ascii?Q?DJt8I+eYv9dwHa94moOeWEwvuE1YSbq1ggzHuLXcyx7hqRjRGl5oRxj5Lk2r?=
 =?us-ascii?Q?OMt2vPzXs8Xp56VK9EJfCTadPi9e8IZcrurW/kH+NYKWPGihaEUNe+fefFbT?=
 =?us-ascii?Q?kzSwydjPBbP5YaKjLQmwG3EkLpS2pFY79nJKz36N+To6nfaCtq4gutVPYhl+?=
 =?us-ascii?Q?N1Yt9Fk1WciYhBMkd14=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 20:19:52.1140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6a4521-b918-4be7-24df-08de005eb68b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9724

On Tue, Sep 30, 2025 at 09:12:00AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 29, 2025 at 01:52:30PM -0700, Nicolin Chen wrote:
> 
> > > > +	if (!new_invs) {
> > > > +		size_t new_num = old_invs->num_invs;
> > > > +
> > > > +		/*
> > > > +		 * OOM. Couldn't make a copy. Leave the array unoptimized. But
> > > > +		 * trim its size if some tailing entries are marked as trash.
> > > > +		 */
> > > > +		while (new_num != 0) {
> > > > +			if (refcount_read(&old_invs->inv[new_num - 1].users))
> > > > +				break;
> > > > +			new_num--;
> > > > +		}
> > > 
> > > Would be nicer to have arm_smmu_invs_unref return the new size so we
> > > don't need this loop
> > 
> > The "new size" must be invs->num_invs subtracting the number of
> > the tailing trash entries. So, arm_smmu_invs_unref() would have
> > to have the same loop validating the tailing entries, right?
> 
> It doesn't need another loop, it just need to record the index of the
> last valid entry while it is doing its own loop. If it reaches
> invs->num_invs then that will be the new length.

arm_smmu_invs_purge() needs num_dels, while its fallback routine
needs num_invs (new size). This forces arm_smmu_invs_unref() to
return two numbers.

I see a cleaner way of handling this is to update invs->num_invs
inside arm_smmu_invs_unref():
----------------------------------------------------------------
@@ -1209,6 +1216,13 @@ size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
                        j++;
                }
        }
+
+       /* The lock is required to fence concurrent ATS operations. */
+       write_lock_irqsave(&invs->rwlock, flags);
+       /* Trim the size by removing tailing trash entries */
+       WRITE_ONCE(invs->num_invs, num_invs);
+       write_unlock_irqrestore(&invs->rwlock, flags);
+
        return num_dels;
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_unref);
----------------------------------------------------------------

So the caller would look like:
----------------------------------------------------------------
	num_dels = arm_smmu_invs_unref(old_invs, invst->new_invs);
	if (!num_dels)
		return;
 
	new_invs = arm_smmu_invs_purge(old_invs, num_dels);
	if (!new_invs)
		return;
----------------------------------------------------------------

Thanks
Nicolin
