Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8AE231A36;
	Tue,  8 Apr 2025 16:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131265; cv=fail; b=DKgEJjszOjytjpisSSACHWIiFQoxHWfwzd5ReapAfGeMyJi7yb/RCSe+8rW2PcDByItagj7F/DesWPDxVQYjC+lIU2Pwy284c0X7kzF0+T2k9TzgLIXaVCWuOfMb+EpXPfPfOZhxitwM6PY/Y7NcZfxt46b6JkcQZYavXxWI8Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131265; c=relaxed/simple;
	bh=hVACmUkJtwsvCJei1T+OSC4qLsQf5UArOsvGHumYGpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HRr1e7szriPPtD60fzfUdJgkb+N46a91kw4Rj/nOLFhu4rpUp9s/3cwNZ+SC3yDqu43bs0QijLuu6563Y9FJn40aizCCe5lRHvHa+0RfsPtkWLx0CePGrzJn5KfXWqkzxDyf12zZNdYD5Yet6i5BbCR1Qapq9R1cgXWoJNJnQts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U3vLSWQa; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U3vLSWQa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fB1LhVKY6hx5cjaEP5H/8sf+wXS+uJT+fdILIaKZ5f+JP8VtrfX6V97zGGqePPKs3Dj6Uf7bKgAi1gB/CDwumZqqTXDmCzDZyjXRC1VUdGWRUPsX8aVMktqePOk+KGqCXClMhUBVs0sfiomNK9sNCmjQ+6/bYL994QH3Bd/1aObdcYQjA0xAhV9uLa0/c/9UtbXN8baikNK76FT7p/zzaMoPPViGlCoPSot1Rz47QH/+R0byMEsC61CmpMfpat46R4PoTuA6Ao0Lx0S+/8nao6vr6YGK0KUzW8i9Vlpv6FnGZBo6iRKmWFclrj2em6k5g68UYEA8QNevwcR/hUM3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwFk0D8FoZgApc1TBMPuA0y4Iyrqc65M667er3YkgnA=;
 b=s1LxNWkDp4pcnnZa9y3oEFXPlCLDCt74pJCRfavnfGIeUHy3M64G8OXVM1nvf2xk5RG3CbYQStYDbl7D8DbmsIqHWJdyHE24ntdn7tFxIYIoy/ItgJJzQp2GiGqgl8NJsj18YUoOYYx7sZR9DtAxHtz3uo860HfzEHKGVzAtOt7sPvd2spOa6zXC9AGpoY/sC4AO+fghO0WtxRLR2Q4iydpmaiX6jnNR8f3hBmO7rk8igLPLjX+kMHdl6UlX4oqDR2wQrWx0a34+esRs3vS1pQp4sxVuHHtuowCGOEzz+89wFolCj5itER/WLeBdHkJ/OGs/ox9rvNjmGxmmki4S0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwFk0D8FoZgApc1TBMPuA0y4Iyrqc65M667er3YkgnA=;
 b=U3vLSWQaNtDLoChO3WaG5hD2WMiFjv1KNtwxbspqCy78liuSh/jE3doIDWaw46WW6XoHymEd2UInsJTPso984tboFkP1isISwhDrQDhLNc1ByB9c4rb/IC03IZ6PgEuXyuVQYzxqSpClvag5osFCkyi+42s+NBVUVpopLOxn/dxHOCO7s8nFeE2JZSDYWjFBakuEFiU+UUZF1bK9nFW7Q5adli3Zctiphv5KJ4U5OpeCayJshSoyISYGMGSUkROndC20iQx4H573lyUSl569FGFDEPkgecJ3xLezUH9vo3JaxCXGkEGhS7L97QAnJHMOwYwj4VhFpDydC9n5YxMkvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:15 +0000
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
Subject: [PATCH v4 06/23] iommu/pages: Remove iommu_free_page()
Date: Tue,  8 Apr 2025 13:53:54 -0300
Message-ID: <6-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:208:32d::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a16a21e-ae6a-4eb8-fa30-08dd76bdfd84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MmnpfiRcxYJwrxyx/qE54zOyZmCCnat2fxaNK7Jv7mhHqt45Nh2IXY02WB1t?=
 =?us-ascii?Q?RfVJz2rzf1Dsg0UTFJ0BCwv2hl+J8YHvhgDg/DgV5tXqX33kfBjqidO5eawh?=
 =?us-ascii?Q?pwQDfL5r69b/8epUwxGAm7TlBooO5yW7bN+M5POClamQmog7BfqcUNF9v5Ad?=
 =?us-ascii?Q?qFQI4EoEQtsOcZbnwGz8bycRxzXVRjfiiK+kPGwiQ2T5F0DxM0UpyrYODKfy?=
 =?us-ascii?Q?bUne3d44+g3pncV0Iw8VrBIe02Uzi42MmLfjVUYp2QnbbuELKYtyNWObxA/J?=
 =?us-ascii?Q?V130ie5PU+xrX2dGTZGwZNYtH8YaPyE2xWELl7h0+iY3hxEXmrawNGIVxCgj?=
 =?us-ascii?Q?Q3v7rspoZA1lKkIEREeIPm01wWsdvl/SevsHH3HeBdXQZecXIbQam6j6N8gk?=
 =?us-ascii?Q?1flQH7xDtHPRfgrl7ChUKwhPQmvsG0roPUFTVcGGp8QGDnpZy27YToe0+8N9?=
 =?us-ascii?Q?yScUrtCqKWAlxj1yEzwGm3abXbqKM86FWS8/fIpfacJRJ7gOnE6uq31Pudtd?=
 =?us-ascii?Q?9sld1Lbe4U2LBXyL7xc5+985E/SIXPpdZXk4cYkwJC0XzK+rkCd+VIjeKK13?=
 =?us-ascii?Q?N13GwY9swQmeMz4ZSL9wWdlDQNad8siTtxHcuE9+4bV7SuFKR4LjXAGqXGjY?=
 =?us-ascii?Q?YYPrmP2/+kOzw3s6eglMvnpL8o7PaGq2LzRAR5x5/2v/UNkTprUD1ZAVbfUA?=
 =?us-ascii?Q?DNylnUuvtTBTQ17J27KpTiJX9blT44pD61OkHGME0KoEBOQS9QroGpDk/Qmw?=
 =?us-ascii?Q?RFp60QnmFfYutsBY+AfhgocLFN6cdUQt/jS1eij1474ZEKnWDp28Mvxv7LxZ?=
 =?us-ascii?Q?ckC60EyduZMDXrF5cgmx4l1Rw2ISK8wtBK/WjdGHAiEOP1ZITvQUjXyR3Nh1?=
 =?us-ascii?Q?Dl+T5A62yII0SfV2yMpEH4KeEF1H5UXqbeO4jseALFGaVKsXtRzgfENb54cu?=
 =?us-ascii?Q?EYjv8NOZVlzdLo6HHodgkHmVS1w6ZRlHpkCxryp8/JQRBvuxsQi3VjXwgr30?=
 =?us-ascii?Q?0J7wJRQF7hleQic95oU1NHCvFsg9iLckT4aIfedCB24tFXkFwEHncuu07qjU?=
 =?us-ascii?Q?6uzf1gPiSpcGz83Q7tZwQ4TNw1OkNjG84l2NTQ7UxSfMm2cQlt6pcjAnKW3f?=
 =?us-ascii?Q?FioSLQT/QgbX85vKZU01fCij0UVUIgSiC+HI5tbCm9haZKCIuG3X2PKC+ZDu?=
 =?us-ascii?Q?ML2xFAdetWIoMtFRBKAx46fw48MGwb9G4W5njNyDjcI2WabO3IgD24RjyF3g?=
 =?us-ascii?Q?XzyYzG7QNwgNCIzlSppXHPm+6dbWRS2HTLDLf+5c5u95bE75kx6M+wYIC+VW?=
 =?us-ascii?Q?uU9otm6DPn7wlgiGaxleuDQMSfj4/nbkFCf3IqwS+WZ4eAHKWFAV7ouiKYYS?=
 =?us-ascii?Q?hDLF+gdoehzjS9i7NwMlCL2hY7y8nrwLq1oOqZzOosPsWmJYH8Mi7L1uR508?=
 =?us-ascii?Q?g5N845dOT+BkTpSZ7l7keeXkGt2SvKtyT/TVuUOrt5dbveQdzXuB8w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fcqN/TZVpsPBC4EX7X7pa2LxYMyTtaLNBGnLHULKoCLpWNXRtWZxSG121PjM?=
 =?us-ascii?Q?go66Ydx+Cz/e/B8HHpu2byqyCcQ1FIw/bcqcWG0ib12ckyKSd6QZWe+q5HyZ?=
 =?us-ascii?Q?D/+1B0rUXPa/dWzKLUag8F7PcX85ciA/mRB2N8Xy8fA68GoNJos5vqyY1Y08?=
 =?us-ascii?Q?xCvywpOWgE1LsYWjmZEpdfkperwe4t/kRbBL8tiPMevAY280bgFNdWNM3j/+?=
 =?us-ascii?Q?N17MEEAs/r6L27qDwrO5LXRwpj57bSaptTcJuAEzz+lFhny8o6zeUG1F0xy0?=
 =?us-ascii?Q?cn7MIIHAboFthZ/pC02goMLGBfFGc3H+jlF3FSjYkXYk7bqzlXysMhF0ELrA?=
 =?us-ascii?Q?dDtAR4YsFecq6Rvyuc8EMxkE9cYiLISPO/hi2zEnqXroggIY9W2rtqjIomhs?=
 =?us-ascii?Q?2Y9Bp31QX55Mm9Rb2R+cx5c8Z2ERP4sNpeStYLn0LbKg15AzmbNY4VP51ci0?=
 =?us-ascii?Q?oX+5+rwuvQE25iYjsmjb/JHHF3s1CIiCON1AzkTVc/61OE4HGz49h195Keu3?=
 =?us-ascii?Q?j4ZQEUg0EbG2nPu0QLJIcQBhpCMWvVF6AY0d1nxQ9d36TGx4StwA29FaJz/B?=
 =?us-ascii?Q?6v93c3mlrRrrXw2cBW92/mW5T9vAyCNQyi6YGcJTsCY8dK5I+hnKRjuMYTST?=
 =?us-ascii?Q?xwBdnagS2rdrmPizYXGiEY79Ni3EGQkoHVDXtQLCa7oTu2XBZrlwSqp8HhPt?=
 =?us-ascii?Q?IWagX1A5SuJGI9Tz6/PJasrTjl2RN5HFDMItQXls5FuQOkpwyC+mQMBd9Mmm?=
 =?us-ascii?Q?y+hToTYiXFwUedUb0cyBowSv1YOceSMvbADHqSLJ+pg8r7qe5i9096NttA+m?=
 =?us-ascii?Q?p5NNM/1riujrfUHroUufC9yJPsHvMV9FL7AOuolv8CkymsefHpk5DsTCt96+?=
 =?us-ascii?Q?5kmBjjcAaYkldhA1hN0an0ehf0kyDvCbSS3iWon+bxGg0Os06h/KrTo77ULw?=
 =?us-ascii?Q?WSSoFpW+2APR3wgzAuXFtKSUfQp0wwvBCGg/SLrACwl7bJbur/t2m7mZUG7N?=
 =?us-ascii?Q?vQAAhHpoAeLbMZ/+Wg/0/Hlkdk/u6IElQnJ9iPstza4Dayr4XL7Dt5FtVEwZ?=
 =?us-ascii?Q?MI/zx+XAN0aJ8AcpX4FrwtXwJ9gFnKGj2GTKF9R0raTyPK6qR0GVn5fGf6rP?=
 =?us-ascii?Q?kU+KtJLu0zWA84+TVtGiWxXRz1HINVyjH4qKi1eaYdDVw7Mu1euKyEiyJ8EL?=
 =?us-ascii?Q?m+pzYZqpmGueG0Ciw3AU1sAmwQlKmcy6KqLWWEmEqHLDFGxC5gbXAkepMIMw?=
 =?us-ascii?Q?5ysFBIGAXdfiwI9sCqal1Fx5aDXgVpGLgnhKCvqoGtoaPuhvhjonM/xZjuqc?=
 =?us-ascii?Q?n9y4X4P1tb9ETogOTZTbjCaLXJka8bfPeCd199XD6MM5pySw1zOUv085rDNn?=
 =?us-ascii?Q?L53g+rALbDeb52m+Mv18Y8hEihFrfHZ3AvRCmUJpuBgT+DDYYM8XDLww+fBn?=
 =?us-ascii?Q?ZDrwcgCkm3HCXDXd+xzkVqTnl1E2NFitI03pOEfxdTMujj801+0I5tJNW4CL?=
 =?us-ascii?Q?6vtSXfDyWydsCt9mk4im2ItR28E+iEs1sqF7H0jCKumKhTXbFtzJSTZBh6SZ?=
 =?us-ascii?Q?U977BeMR7iEht+VFSK8YQS+n1bQoNk3VGr7dezW/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a16a21e-ae6a-4eb8-fa30-08dd76bdfd84
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:13.6126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUXtRDBUVMK8eGJNnjYAjj06BEaIhUUJK15adUy2iw5MtGTvPgQEOAwm7CtpraPb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Use iommu_free_pages() instead.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c          |  2 +-
 drivers/iommu/amd/io_pgtable.c    |  4 ++--
 drivers/iommu/amd/io_pgtable_v2.c |  8 ++++----
 drivers/iommu/amd/iommu.c         |  4 ++--
 drivers/iommu/intel/dmar.c        |  4 ++--
 drivers/iommu/intel/iommu.c       | 12 ++++++------
 drivers/iommu/intel/pasid.c       |  4 ++--
 drivers/iommu/iommu-pages.h       |  9 ---------
 drivers/iommu/riscv/iommu.c       |  6 +++---
 drivers/iommu/rockchip-iommu.c    |  8 ++++----
 drivers/iommu/tegra-smmu.c        | 12 ++++++------
 11 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 69aad383f97e10..b5415dd19426ae 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -946,7 +946,7 @@ static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
 static void __init free_cwwb_sem(struct amd_iommu *iommu)
 {
 	if (iommu->cmd_sem)
-		iommu_free_page((void *)iommu->cmd_sem);
+		iommu_free_pages((void *)iommu->cmd_sem);
 }
 
 static void iommu_enable_xt(struct amd_iommu *iommu)
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 26cf562dde11f9..42d9e6746dee28 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -146,7 +146,7 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
-	iommu_free_page(pte);
+	iommu_free_pages(pte);
 
 	return ret;
 }
@@ -222,7 +222,7 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 
 			/* pte could have been changed somewhere. */
 			if (!try_cmpxchg64(pte, &__pte, __npte))
-				iommu_free_page(page);
+				iommu_free_pages(page);
 			else if (IOMMU_PTE_PRESENT(__pte))
 				*updated = true;
 
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index a56a2739630591..f5f2f53273786d 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -121,10 +121,10 @@ static void free_pgtable(u64 *pt, int level)
 		if (level > 2)
 			free_pgtable(p, level - 1);
 		else
-			iommu_free_page(p);
+			iommu_free_pages(p);
 	}
 
-	iommu_free_page(pt);
+	iommu_free_pages(pt);
 }
 
 /* Allocate page table */
@@ -159,7 +159,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 			__npte = set_pgtable_attr(page);
 			/* pte could have been changed somewhere. */
 			if (!try_cmpxchg64(pte, &__pte, __npte))
-				iommu_free_page(page);
+				iommu_free_pages(page);
 			else if (IOMMU_PTE_PRESENT(__pte))
 				*updated = true;
 
@@ -181,7 +181,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 		if (pg_size == IOMMU_PAGE_SIZE_1G)
 			free_pgtable(__pte, end_level - 1);
 		else if (pg_size == IOMMU_PAGE_SIZE_2M)
-			iommu_free_page(__pte);
+			iommu_free_pages(__pte);
 	}
 
 	return pte;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b503d01e3b8008..fe31166ced94b7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1812,7 +1812,7 @@ static void free_gcr3_tbl_level1(u64 *tbl)
 
 		ptr = iommu_phys_to_virt(tbl[i] & PAGE_MASK);
 
-		iommu_free_page(ptr);
+		iommu_free_pages(ptr);
 	}
 }
 
@@ -1845,7 +1845,7 @@ static void free_gcr3_table(struct gcr3_tbl_info *gcr3_info)
 	/* Free per device domain ID */
 	pdom_id_free(gcr3_info->domid);
 
-	iommu_free_page(gcr3_info->gcr3_tbl);
+	iommu_free_pages(gcr3_info->gcr3_tbl);
 	gcr3_info->gcr3_tbl = NULL;
 }
 
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index e540092d664d27..14bc39b2cdd528 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1187,7 +1187,7 @@ static void free_iommu(struct intel_iommu *iommu)
 	}
 
 	if (iommu->qi) {
-		iommu_free_page(iommu->qi->desc);
+		iommu_free_pages(iommu->qi->desc);
 		kfree(iommu->qi->desc_status);
 		kfree(iommu->qi);
 	}
@@ -1714,7 +1714,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 
 	qi->desc_status = kcalloc(QI_LENGTH, sizeof(int), GFP_ATOMIC);
 	if (!qi->desc_status) {
-		iommu_free_page(qi->desc);
+		iommu_free_pages(qi->desc);
 		kfree(qi);
 		iommu->qi = NULL;
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6e67cc66a204c6..0877bc6d8094e7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -571,17 +571,17 @@ static void free_context_table(struct intel_iommu *iommu)
 	for (i = 0; i < ROOT_ENTRY_NR; i++) {
 		context = iommu_context_addr(iommu, i, 0, 0);
 		if (context)
-			iommu_free_page(context);
+			iommu_free_pages(context);
 
 		if (!sm_supported(iommu))
 			continue;
 
 		context = iommu_context_addr(iommu, i, 0x80, 0);
 		if (context)
-			iommu_free_page(context);
+			iommu_free_pages(context);
 	}
 
-	iommu_free_page(iommu->root_entry);
+	iommu_free_pages(iommu->root_entry);
 	iommu->root_entry = NULL;
 }
 
@@ -745,7 +745,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 			tmp = 0ULL;
 			if (!try_cmpxchg64(&pte->val, &tmp, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
-				iommu_free_page(tmp_page);
+				iommu_free_pages(tmp_page);
 			else
 				domain_flush_cache(domain, pte, sizeof(*pte));
 		}
@@ -858,7 +858,7 @@ static void dma_pte_free_level(struct dmar_domain *domain, int level,
 		      last_pfn < level_pfn + level_size(level) - 1)) {
 			dma_clear_pte(pte);
 			domain_flush_cache(domain, pte, sizeof(*pte));
-			iommu_free_page(level_pte);
+			iommu_free_pages(level_pte);
 		}
 next:
 		pfn += level_size(level);
@@ -882,7 +882,7 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
-		iommu_free_page(domain->pgd);
+		iommu_free_pages(domain->pgd);
 		domain->pgd = NULL;
 	}
 }
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 58a13366b41c7d..b616aaad03ba24 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -96,7 +96,7 @@ void intel_pasid_free_table(struct device *dev)
 	max_pde = pasid_table->max_pasid >> PASID_PDE_SHIFT;
 	for (i = 0; i < max_pde; i++) {
 		table = get_pasid_table_from_pde(&dir[i]);
-		iommu_free_page(table);
+		iommu_free_pages(table);
 	}
 
 	iommu_free_pages(pasid_table->table);
@@ -160,7 +160,7 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		tmp = 0ULL;
 		if (!try_cmpxchg64(&dir[dir_index].val, &tmp,
 				   (u64)virt_to_phys(entries) | PASID_PTE_PRESENT)) {
-			iommu_free_page(entries);
+			iommu_free_pages(entries);
 			goto retry;
 		}
 		if (!ecap_coherent(info->iommu->ecap)) {
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 88587da1782b94..fcd17b94f7b830 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -122,15 +122,6 @@ static inline void iommu_free_pages(void *virt)
 	put_page(page);
 }
 
-/**
- * iommu_free_page - free page
- * @virt: virtual address of the page to be freed.
- */
-static inline void iommu_free_page(void *virt)
-{
-	iommu_free_pages(virt);
-}
-
 /**
  * iommu_put_pages_list - free a list of pages.
  * @page: the head of the lru list to be freed.
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 1868468d018a28..4fe07343d84e61 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1105,7 +1105,7 @@ static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
 	if (freelist)
 		list_add_tail(&virt_to_page(ptr)->lru, freelist);
 	else
-		iommu_free_page(ptr);
+		iommu_free_pages(ptr);
 }
 
 static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
@@ -1148,7 +1148,7 @@ static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
 			old = pte;
 			pte = _io_pte_entry(virt_to_pfn(addr), _PAGE_TABLE);
 			if (cmpxchg_relaxed(ptr, old, pte) != old) {
-				iommu_free_page(addr);
+				iommu_free_pages(addr);
 				goto pte_retry;
 			}
 		}
@@ -1393,7 +1393,7 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	domain->pscid = ida_alloc_range(&riscv_iommu_pscids, 1,
 					RISCV_IOMMU_MAX_PSCID, GFP_KERNEL);
 	if (domain->pscid < 0) {
-		iommu_free_page(domain->pgd_root);
+		iommu_free_pages(domain->pgd_root);
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
 	}
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index af4cc91b2bbfc8..f1b49370dfa3d0 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -737,7 +737,7 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
 	pt_dma = dma_map_single(rk_domain->dma_dev, page_table, SPAGE_SIZE, DMA_TO_DEVICE);
 	if (dma_mapping_error(rk_domain->dma_dev, pt_dma)) {
 		dev_err(rk_domain->dma_dev, "DMA mapping error while allocating page table\n");
-		iommu_free_page(page_table);
+		iommu_free_pages(page_table);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1086,7 +1086,7 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
 	return &rk_domain->domain;
 
 err_free_dt:
-	iommu_free_page(rk_domain->dt);
+	iommu_free_pages(rk_domain->dt);
 err_free_domain:
 	kfree(rk_domain);
 
@@ -1107,13 +1107,13 @@ static void rk_iommu_domain_free(struct iommu_domain *domain)
 			u32 *page_table = phys_to_virt(pt_phys);
 			dma_unmap_single(rk_domain->dma_dev, pt_phys,
 					 SPAGE_SIZE, DMA_TO_DEVICE);
-			iommu_free_page(page_table);
+			iommu_free_pages(page_table);
 		}
 	}
 
 	dma_unmap_single(rk_domain->dma_dev, rk_domain->dt_dma,
 			 SPAGE_SIZE, DMA_TO_DEVICE);
-	iommu_free_page(rk_domain->dt);
+	iommu_free_pages(rk_domain->dt);
 
 	kfree(rk_domain);
 }
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 95e97d1e400468..7ad1b3c7c7fce2 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -303,7 +303,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->count = kcalloc(SMMU_NUM_PDE, sizeof(u32), GFP_KERNEL);
 	if (!as->count) {
-		iommu_free_page(as->pd);
+		iommu_free_pages(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -311,7 +311,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 	as->pts = kcalloc(SMMU_NUM_PDE, sizeof(*as->pts), GFP_KERNEL);
 	if (!as->pts) {
 		kfree(as->count);
-		iommu_free_page(as->pd);
+		iommu_free_pages(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -608,14 +608,14 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PT,
 				     DMA_TO_DEVICE);
 		if (dma_mapping_error(smmu->dev, dma)) {
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 			return NULL;
 		}
 
 		if (!smmu_dma_addr_valid(smmu, dma)) {
 			dma_unmap_single(smmu->dev, dma, SMMU_SIZE_PT,
 					 DMA_TO_DEVICE);
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 			return NULL;
 		}
 
@@ -656,7 +656,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 
 		dma_unmap_single(smmu->dev, pte_dma, SMMU_SIZE_PT,
 				 DMA_TO_DEVICE);
-		iommu_free_page(pt);
+		iommu_free_pages(pt);
 		as->pts[pde] = NULL;
 	}
 }
@@ -707,7 +707,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
 	 */
 	if (as->pts[pde]) {
 		if (pt)
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 
 		pt = as->pts[pde];
 	}
-- 
2.43.0

