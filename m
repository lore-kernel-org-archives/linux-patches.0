Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2075.outbound.protection.outlook.com [40.107.212.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CBA20A5E9;
	Fri, 10 Jan 2025 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526913; cv=fail; b=NbeAwICq+MwftX8TDxUs2N6PNgdqvnwLtevKcVPl4CPhz7V8amXiEsKVjZtiRsUTpLfxcN8QX2Y6wYV9G8IGZjKtjmbkYHyyqmtYxw3eLAQcvJkIKJuroggMErH7jf8jZ7lgwIYKtpbrPCyvXyV7b/EvlIanmk1Apj+je23pPF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526913; c=relaxed/simple;
	bh=ho+plxG0CuDQc7oKLi9CdsyFbr8WDXaXVVfufrohGqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lQDMGylqElgAI18egNDzxX2faK8cxQ5X+DvnmIhjqjGK/qDLLD4kEIacXOaIZNTHnmyYfUH46MV4ZfC9q2ozTRPmsAEYwiqejI7OkEqSPNz3DruE8oLMPFVopuU5oeeAxkeGwjGbx+1FsdD4r2uSZ3sEEgnWuS2vwjxDvOSLe5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tq075ztE; arc=fail smtp.client-ip=40.107.212.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tq075ztE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b6AgLwIZlVLIB7xqiQxpPHRxYsXJU7w7OhEVW1bKC6b9ExcVR5k7WdO1pqzRIEcR2d7oYAfTrx42dRJwPt+hMTxZB87H9pOSZ84SHayAbLj1qQhPW9UUWxnafel0Ntyv5iXbFzIjJjrWDRLxSHsgvxyRosrnL5EWWvbt2luqg6SBAyDiLPBREtn0x5ZG6XbnJ2H7FQ4rtZvmnBMjc6y/1qEkTKqGKr7S+fWR+pKn53plvWyTolJOwRjjcb2P19h/ZV7Xirrw184O6oyEGhH4KVGi/+sCneiebuop+Ghb5ZzzOu6ck+1yXMERJE//nW9Retv9PujqK/vDYGHRSw6q5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFMznhAlpd07uSz41ceh5PdssPzVNE3SjKgZZVSZucU=;
 b=lOl31MPtasHGl4M4uryBnKiKJ6fiWRs23enHsdKhMWJ+BwpPgBiRZQWTdg5f9EY9xyAnRjGirM44plpLanfCUR1tZtRcyUWKzf2m+0QdY7TkqIcNaWl4RBqj5rDrTy0JePViIOmJLyYEbEyK0CYz8ylFRzJmCIlHPK9KtmjEQoAxQDVV9YL1W0Yp0lzadg/NUdBJMVX9L1vYNBC680p0oepkgSUuXmAS12igoiv5Untz2jEFu3Kr2ereh9u/AMYyaHoMNmrYJwTHEhfFPjWrmN19o+IRZNn9ZDNYAhm1VPfbm4gAMQ1PbbvgqEsylDaBAbbKJEMAjXsfAKfiDo2GMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFMznhAlpd07uSz41ceh5PdssPzVNE3SjKgZZVSZucU=;
 b=Tq075ztE9u6P/CDc6W4j3/7wWWaYNgFTcvWP4hv0uES/7mm7ELS8/ejhTVwRqf5wsRBjaOnZPjJnno3TkpRt9Iis6YEeLoFSFUx/GRvRKy1D1ZFf6ceCRtR+Q6Rb84ZS6ynwRrvEuPrc5nP07TPvu28a0MAzuQ4hGJih1FuOXOPrIfv0XRipn7AR22VPo/3/iJrcQYHILPrsr9rNIDBvcY53OH83gUK2dGOKQi2J6bu39vX/icXlOzyqRRHCK4vVoV73GHbXCf/CnSGVbXsEO4eqxyBOK8tDLIhxFKukqX5l9DHHqLyelp6QfbpZQpXHAibMGeoMHYq4aIINAHyBLg==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 SJ1PR12MB6193.namprd12.prod.outlook.com (2603:10b6:a03:459::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 16:35:08 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 1/7] iommu/amd: Remove unused amd_iommu_domain_update()
Date: Fri, 10 Jan 2025 12:34:59 -0400
Message-ID: <1-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:408:e5::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|SJ1PR12MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f43a866-2b6a-45bd-6deb-08dd3194bdac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sJHDYVRSqDriwoUK4N1/otJxpqRL44ijzU2KavVHXz6+H+t5L682kAragDrY?=
 =?us-ascii?Q?ivPqXBsdPiErr9YNIsIeHXuhnMj/Ew0fCO3DqFyCFxm3pu1TDt7L8uithPYx?=
 =?us-ascii?Q?OhCU3HCIkrqMEKiT8pTfxKo2f089n+yRs9gH8iUBG+ixg2S0Qn5Kl9kV+fnr?=
 =?us-ascii?Q?XwZ2fBPKv3cMMsGMbyRUVAGY8ADqp5NcsXlRwb1ynUmygFmMJMwdjtMfVAA3?=
 =?us-ascii?Q?ySRq7z2924jlhIjGU0pMAl1rbbvJl++CB7qzPSF89Jo/JkneKckWx7ezsVMR?=
 =?us-ascii?Q?/AKU3rUDFBepOvdZM691S+OaiAHja1yJdfKrHxYCQwLB2+XsGGdeBVcjDDVr?=
 =?us-ascii?Q?9NOsoYRykFe83WB/4unbTdOBBL1Jnc0r5Ic+1KsLZFjaTusBlzXdo990LeVu?=
 =?us-ascii?Q?cgdtSNJIbt8QVJ1XRw5EzALSVv8O8GxeAsTetgpG1JpV5bMhc+87nRdJRFUs?=
 =?us-ascii?Q?HUVBKx7ItgETX5ch5nULtvW6oMmVrlB1L8z0sYMGcdpt/tsIIpaC1MrUQK3J?=
 =?us-ascii?Q?5RKeyqMeBTmwWT6xIlCjDmIMeS+cYFKi/rrIWR1Qylc47xsnvXd+8OZjTtDE?=
 =?us-ascii?Q?VzOz6kdOmh+JVWLb4+gZPb0Yk6JVVo3PCCZx3WCFjOCo+VcAi2JJ520snw9z?=
 =?us-ascii?Q?9jYMSZTIZABaOALnm/SaGe8R8RZaXh0AANkPfYqdPflET+YFYQDtUaBbqnMG?=
 =?us-ascii?Q?Sq1d5vJk63rMAREgKWrvDDe8qMyrDA6xUGa4XWjYITDl/xzFvfQ7BjvERkjV?=
 =?us-ascii?Q?7bKTyKLX2+NWXF3/UpLliE5bwmz2BWlMyBZ45iVEA+mA9FoSmQ6Hz+TVz59n?=
 =?us-ascii?Q?OMBaurhi7L0ygyR/GpAQluow1BYt+J/Oyq7z7dHkJP0ZtM4BG+l9ZrrJP9O1?=
 =?us-ascii?Q?MANSRMFs8t7OX0FhAUqlJmy1y4eARQV3vDR/hGGbXXq7bbUfDOQiO4A2Ylw7?=
 =?us-ascii?Q?CrUXZQjolvVukO3d0NaZI75tuXZO3KtuE7Jac3SrwqW61crFnwbQbdMYY/Qa?=
 =?us-ascii?Q?/c3BU4q3GQNZJ7TjALOXmvUzDfmKMlOIQE5PEflsKOuRuOmzjuKNebbgeyVU?=
 =?us-ascii?Q?BZs7FqyfSgV4CqvNjSS9ttysRBdNGOGCjp7sZ50SFR5QSKT94tTpaCtj8/Wb?=
 =?us-ascii?Q?2Xedq4NBoV2xxXRDUBViSUNNp6bWiT5YBhwLOssfIGtgN9WIrQ47t6zSxC7B?=
 =?us-ascii?Q?unsHQHzGYobA2h3akFq/NnzIOt6tjad05oGb4/kYpklTwiaaH8h6BoswxEw3?=
 =?us-ascii?Q?emirIyk4n52ohnmxcx04CqYjZiaFVGBjyzh97gmFqZatsffIg24XO/JL4TvN?=
 =?us-ascii?Q?WAKX5oyN0CD76YUXXJpNyZrI7r6On1+m+2jb4JQgU7PkxLPgdclsABUCbJQ7?=
 =?us-ascii?Q?F3L1qXl63laDGdgfGGNDj8tnRZr0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+UnNyvEYvDoH+aqLkKppABqYqvNR4VZqQfX6IwTwi3MTSvIDZDqmYjP2pm+Z?=
 =?us-ascii?Q?Er+LXsxjAGccEYOQUi4Sf4N9YOewWRaAHWIQHBJG5t9gLGI9HrW+ICyLgRhX?=
 =?us-ascii?Q?CItSgecGNZPo63YCu/CBEVgpck8kKq7Bsxon937D5vohykyVPwqZ90OyLKST?=
 =?us-ascii?Q?GeHTQAiZtK4ua6xzaMAV7+451MIoosCq8wg+IkF3jTCl+Z+t8DZ+nkIUTuYz?=
 =?us-ascii?Q?dzzp8dPHo43yK6kTshQ4cnS5yBgkj3+SYrCDUPE4XeLmyRJHbQfYzCNtSwAW?=
 =?us-ascii?Q?XLDSt1mQiH01i2UY+mkcS0wfVbggdhlTBW3yAursNQFaToGhKM2BYaVC9x/x?=
 =?us-ascii?Q?PV7HaebJNes8sEto4gjeg3Bgkqk9bQrtC+qJDflyXUkMQ5uM38NWUg4OXrv7?=
 =?us-ascii?Q?FHRF6rK8Fn7rqFHdycjEfefGRYKQ3vPpdzZ7Z+8TYyzN0j6t5JqtrGDg61H6?=
 =?us-ascii?Q?G66+a0VRugwQI9NCunpXgU2qqjLRQouws709RZ1BFtInM2xz3Sf9XXHgAyqP?=
 =?us-ascii?Q?sp7ObXkSYfBJluT24YnQUbfuyNBqzMtJ16+q/+cii2bkUAoFs0kRjg13G/JM?=
 =?us-ascii?Q?y6i3dY/EnJ4wOzYON/hY/h6m/3CjRA4GggMykNlunT9LlfkgcewaGW5oZoGd?=
 =?us-ascii?Q?nYbQIg9BPz2nkEX84W3kfwgmHVk/DLKlA1E9sPkFdaBWC1245Q7mHQIB3GN4?=
 =?us-ascii?Q?zq5sxezAeqU+nHQfjCAkKXhQskEGVIMaSApzUVkXg5VU9AMdnYlHckXkWwxo?=
 =?us-ascii?Q?UZU9pUx+qp67aX1XHFW/oPuy64VDp+SzMGjbJhIJjzUWpNsYhHv+qsSM+TSF?=
 =?us-ascii?Q?NeytnIybjckEJR2PQI9j9zA08KIx4H5tSZGNtPC74q3scMFDJl5QShlbAAEH?=
 =?us-ascii?Q?FZ6IE0+2PwXu5eGyNjEyrCm44zLtQNG5opLhwpGOIT29KNAREhT4oTr2OfUN?=
 =?us-ascii?Q?+Fztzk3mhfHgGvNuc9ZNFAPeSbYQqTzb+toC0SdGAgtdLUV7Uvgzn4dlTaJr?=
 =?us-ascii?Q?ANQrp4xMO7EatWXTzZnNYov2vopdc6mb12RB79yxtVddXBns3/29GaWypxNT?=
 =?us-ascii?Q?wjzbC7oZ7Cpaag8fR+mfsv6MQlejzu61i/zy+uE6masmMfI/c9EeG7FVQUYh?=
 =?us-ascii?Q?ZFFIeq8VLNMHwcpS1sOGO7nW6V9MdFGtiHpYj/pHi7u4xGNaKwfj8xxc6XfQ?=
 =?us-ascii?Q?yBfw1DXMPIpf4Z5S9P6YtQS4B2+cu4Mq+bWuQDZVJ2A2R4XxmXLyPrcmUSQk?=
 =?us-ascii?Q?5hbGCi4NHRWApTsmOhtb4qoDjOXDXmU5ZoWpU/HWnqNyx3z/JUCh4xwV4pI2?=
 =?us-ascii?Q?TmpuwZ9mkDvULGs651DbLGju2I75h0kxtvxuBdCm+9MnkDk7jmzWTw3ks8bY?=
 =?us-ascii?Q?jErGpDHiPBexUxdrtSCV7div9KXHcpX5zjYOsCh8vNK16u+4GQBXOYG/Fqbp?=
 =?us-ascii?Q?MIqUCmwDMzoFTFrobFzCnhkpJab5lCWi4TXHrPdlZkzaWCzJuYZ5m6zJV7OS?=
 =?us-ascii?Q?zmWvesZqv601tCfRVKzCPrLvkMZSuBY5852EQ1IKzcu6ZeuaMpOVoNIFcP2i?=
 =?us-ascii?Q?vSFQcAnQHevjNM1cK28dViAWbeXYRCdfsm3JQp7n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f43a866-2b6a-45bd-6deb-08dd3194bdac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:06.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUFo5EyzepoWcIgnQoZfLwZMSXw0OvYWvIqptxWs7sidioO2FICBruC9NnVghwcT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6193

From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

All the callers have been removed by the below commit, remove the
implementation and prototypes.

Fixes: 322d889ae7d3 ("iommu/amd: Remove amd_iommu_domain_update() from page table freeing")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h | 1 -
 drivers/iommu/amd/iommu.c     | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index c4cd272b31f4fd..cdbfa5f096dd81 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -88,7 +88,6 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_update_and_flush_device_table(struct protection_domain *domain);
-void amd_iommu_domain_update(struct protection_domain *domain);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 20177e18eb0d6d..93093f1c5c287e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1766,15 +1766,6 @@ void amd_iommu_update_and_flush_device_table(struct protection_domain *domain)
 	domain_flush_complete(domain);
 }
 
-void amd_iommu_domain_update(struct protection_domain *domain)
-{
-	/* Update device table */
-	amd_iommu_update_and_flush_device_table(domain);
-
-	/* Flush domain TLB(s) and wait for completion */
-	amd_iommu_domain_flush_all(domain);
-}
-
 int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag)
 {
 	struct iommu_dev_data *dev_data;
-- 
2.43.0

