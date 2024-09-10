Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9513C12CD96;
	Tue, 10 Sep 2024 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725997463; cv=fail; b=ZcIQM7WQG3uTK2lP9B4XZ8NcsvvTNnfkOlUP5Q4EbKksYIBQzwr8tsrZfpJ1BhTVbJU2uDXLwstohRaUd6sNZEaF3PgKahPX6kDdaCLbNo5hM3+Bx0IZA/ibnfApDW5KsEf3S9yLNzlZ2EYKx/ld5/Ym/QnfezWKkgsmRxxKo9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725997463; c=relaxed/simple;
	bh=Sz7aOUeR/R7YSnHKhyTDxewuBFY/ZxtR/ItN/o3x2MY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BCW14aWBcv3hs/aEnmRmoFxL94rJpVpMLEreiRoBRKvRy3A838fqBdAsg258g1tESzmNZbjyRlRxpr3pf/WSfayD7kE5UBU5LWf4sVDQLWlHWA1yLXqQZ31pJenygzKDmVb//BHXLEYKptEfHkRR0z918UB3l8bZtQG04WYlVrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HkQ8UFOs; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HkQ8UFOs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWTzQtkTi0idS5C5NSW4+hUUNEwMnaKSx37C84QcRBTKRjmgWHFMgSx0yUkgptMBYz97Vy2pk3fPyB44BL42jqKvTnT3O8NOuwx2nYHm+0xtlaLfUoc0IazzdveEkJM4nJuaDpCV67DtmZzTWFQL40IgMEMlAIuSaY0IHK9fFAi+kAqTaWW9+OLaTZkBWpmkX1Ltiq7xmjaTrBlkNp9elDmLpx+dlOshtC5T8egGQg9GzLtcX6wfoOJlXqxq/dC+o4V1DIipCPLEnJXUJ9cRzCUPWAPSmwQ6/JUCgJI8/9m1TLKCmzejsbK/Ar9GXubk5zI0S7Z6DpCCqkaKL7zdKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkStFpXmvzaxNiKG7oKn8tOUtZHwAWOfR7cPF+4akuw=;
 b=xnUUX+pg5P5rLCHpLeV1qKX0VMhM8uEQI2OfRAGnG/uJBTv5Cm85Oig9aSlsiiljqcAYa8IkVMIaqGXraPIPAqT0F6eHxSfl6rn3O4wUwkE8W8JVStiJz4CxzrwfjX4vMJt2mbCpQTkrBFhp5Y94pj0B7209QkGoy3JIwMphhLBGRBzF+ON7lXmSjFi9QU8ZrMjOrO4bDENQL1QGBjmGiFjtWnB7LO03CKkfp26Yglf1yNGNDwrop1EwfDXzHPToEJPgI85S3sGhEhX0d/TGiquRUg1O46D/h90EypOoufAGkx/yN/PYcj9jFW91BSnLe1TXeImYf+gQUlrkTBidjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkStFpXmvzaxNiKG7oKn8tOUtZHwAWOfR7cPF+4akuw=;
 b=HkQ8UFOseolZHCvcb0qQSGKMKlouZ8y4ctHoaoXbBL4hBh//MQ370r4ZohHTbzMBy3ZwSO4OHNlRDOF02t+tH/4WpwWJFQvchPypcz2BEYW+MCA4klnNXUcwAnaMbwu6p7rq1vETEhd4fUoYf7Hp7NBsDtlvB3W+Uh2lnhMWekyqPFdnM6uNl+1XEBSDiZXs3TTX+QnJlJ/01U3lN4mey1wW4mAzSWWjvsJwzXT4PR/iWs6kr2RU6sVpQEFFgS6r2FQmhmd1eymk6n0UibaBgLsXsIPsLrsZzN0jXjTiSXjEuP4tRGMKOPgj8A64VUGeX3DvfTm9lOv1gpJy152PJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7789.namprd12.prod.outlook.com (2603:10b6:510:283::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Tue, 10 Sep
 2024 19:44:18 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%5]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 19:44:18 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Eliav Bar-ilan <eliavb@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH rc] iommu/amd: Fix argument order in amd_iommu_dev_flush_pasid_all()
Date: Tue, 10 Sep 2024 16:44:16 -0300
Message-ID: <0-v1-fc6bc37d8208+250b-amd_pasid_flush_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0003.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e82b235-8dc9-4f07-d098-08dcd1d0f555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GSFV1iuNZvA1oZoEctrPPgad36tKplCd9Xp9Yz3+duTTM99lZFXQg2fzA9wT?=
 =?us-ascii?Q?S+IDxM45D4MXlg8xh/KaauarhH4YIK/ZfnUm0YxRQKhCwcF0iyiI7mx+T7he?=
 =?us-ascii?Q?i+6pDmMFEFz272KLcfjZYf/JPWVuR2bXAerwJybFS6smHPqzS7HpwIDVgb8t?=
 =?us-ascii?Q?oTobpuWmJxvTspKZJsTx6qx6u6waYeFlc97c1sC2Ufqy0QuiG5Dbf/MoifMa?=
 =?us-ascii?Q?kbMkUtlicAqzudqBfNnw+i+0nxvKo+2Xvu9od2YlkXFJhd1UbOJwRA6pOnaG?=
 =?us-ascii?Q?Nnw9us4UUxoYvC/K22BPhsPn5JoNoW2t/XI/BJuOONWbk3vOcqxUoqS61Tah?=
 =?us-ascii?Q?EhqXta2Y82dQOw7ZuDJy8uzwWm7vBAQBQ2W+QlWPOFwo7PZhBiJCC3+//MZS?=
 =?us-ascii?Q?0iNmEZaRLWWGP03AIwPPGwbIiRQjWSv1+O1+BhAcGDxKb9DE6Gy1mDqCC1Di?=
 =?us-ascii?Q?amzwclxnlDiGSWf1rFgQQW6NkYbTkLKi4JMFHzvOimm+aMRI0kCrPBsVfi2z?=
 =?us-ascii?Q?jMHZsblUN6/t34GWHG46d3PlC48mjsTlDszpogCAskSy7DEFcu1HzcL92JDH?=
 =?us-ascii?Q?3e3tq6fHHRcyfsa67hB+5XDpf9F5y4hgaCu/iHswFPfbTUQ81fyhIpQxerTG?=
 =?us-ascii?Q?sg7udRqxxXXKK/kLvda4iq/HEnQZBypWJ5hJrfaX0jTUvuyjz2FZKczJTgPT?=
 =?us-ascii?Q?AE8Ztqhy3UcPSV6TXGoGN070y0LM7Fw9g9pGznjYn/Mg6y24gk4KjYcht4jQ?=
 =?us-ascii?Q?OZyG0eJvl1/qBoFpk231/0dudl3YpjYUSmQHRQO7o3/bID8dmTO+1q7DSUJC?=
 =?us-ascii?Q?3x6//m5vVkAmvOJ8U4C3ChQdhRpSpFJ4n92PXVm8N/NROu8iwxR/4TopV/yS?=
 =?us-ascii?Q?2oXJFLoWMh8AIKVLQuIgF5JLBMA6NBbNVvyQQZHngFkdQtxJIMNPlx92QpNd?=
 =?us-ascii?Q?cJu6WKBL8RftPYEybr7PybuIQFxb/JouoFqI+YsyoKTf3WzqNLuTcSPHfRet?=
 =?us-ascii?Q?qEJsq924mVle3co3ApgEvdRZO7kHUf30oNoaWpn8VqgOW0d5VGKNv4xK0230?=
 =?us-ascii?Q?QzjF1XdKIAbOtw42yASMleoWim8hfWkgarcolxh7jiigE9YCquCWKC57QD6M?=
 =?us-ascii?Q?RbidoWH/8LhhHYZwb2n9KPZGhEoh2mdSjWKtI+ghz+mR2ChNSUhdpTT4gMQE?=
 =?us-ascii?Q?Yg3sXbmjag9V4IiVUmrU85Fv1EdaRKgRCof23N0gz+vDUKl78YniUFtmJ9ao?=
 =?us-ascii?Q?BTEm+gUyRj4nW6O3j+m5N2qUvs8iStTgrRQ4+Xctel7u1t0VAHAeJo6IAwjl?=
 =?us-ascii?Q?DA2ALxkL9G1xo5q+RedlFxUPOEucB/7m5IHpN3fAbcu2xA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JSXRWJDvK0svLb5A+EHfTyTig4TMl+9jiX6icy2ByFoCLkygQfitCNX3IpEg?=
 =?us-ascii?Q?eAXd7Wf9TP+Nxu6AfW4FTZI9PwTfNlsWhoTf5dfkKvEM2iD31MxzK9PwJul3?=
 =?us-ascii?Q?FJIaSzBtjazWUBDoMDx/D5E2dFGpOXR6QeTqBd7zXorbnfgQL8/rNbTWesz7?=
 =?us-ascii?Q?MZtiHvYVZ9TV+OVz8zcjPATqTnyZx8D+5N5LvVACNg+Bx/WQdEjBlEW1xndf?=
 =?us-ascii?Q?Pv5UXNxKOJfL3L2cD7xH3EDObzbkuj/DSFkZxtE6Q6yq4jlmtlwMxzsRPoje?=
 =?us-ascii?Q?gdZF+5cCGiicncWZKJzjgeEIo+Unuxfb42QJfO5Gi6dD3xaTSjYUrABHU0fG?=
 =?us-ascii?Q?8gKUkf1oT2PxIXGchlOl/EU90ACSUvEIEtvWDJXNiddNeeBOsNp7C+mcVcHl?=
 =?us-ascii?Q?mAwNFUiOqhtyB5r0/e66NS2jmH9qWYawdILYtWkY4wX1Oklj5SwnhBDr5IXZ?=
 =?us-ascii?Q?X5D9LuUTlwrmtE8bLnooTNHZPBqP9Ic4bRJsdfisaiaYopn//gezrKhLV74t?=
 =?us-ascii?Q?3dTNcBEfLAVShcHpJKVl+kt2uj1Xh0WXBXrLsFFr0+5LpFMJf9NgCL8zDbto?=
 =?us-ascii?Q?1Bf81HjmhPY198VxXktOSI8jDpAAQE3ZELigddthZrAF1zNbhKI3FWuukIDi?=
 =?us-ascii?Q?pE0VNEGJ3+yM2AK7McapdPPOCuLvKesMbbrMNOV3ypEKl+YgeAD15fjfqLyS?=
 =?us-ascii?Q?fZI9Ui9oTAi9q5acuM+gU+E/u9rCT4OIRfqlIU5cgICPX5CwA2i2dUWbDVIQ?=
 =?us-ascii?Q?f37GDPrs7So3Jg15aNe+JFqGDzQUNorj3ZcLkRkHPUcdbMIxKoparHmObzKa?=
 =?us-ascii?Q?LNs58zSYF0WSgNCGUwiK5UArsLS3X8j0rdmnaJqS8L79eeBzYhMzap69quBX?=
 =?us-ascii?Q?DNBVrmvfXlI0ru1PBLQlwWABKecxBzzR4sTIqELUT3+42OiPzfxEloyAEk3Q?=
 =?us-ascii?Q?PB9zSUeF9uV+n7T3kwlBfotxKJEtOdoCuj7h4Spw6KDDdTp2dnzmmbIBEbG7?=
 =?us-ascii?Q?8l4oLYfMCieImRC9tBeA+MPKcZhb/x19+kAoIyOn5C1dyQQVHzddsdURjzYe?=
 =?us-ascii?Q?MPmLPsYi1iIhxl/S2m8tgEVGwlgCOV26pYdmqnpEBu/bs0nfPvhcI4Mt+AL9?=
 =?us-ascii?Q?amtnp8/T8kensZOwdLIdIzzzYhlqEjbF8Ml9lHX9BLNnlyKoV4PXTOGKQe0C?=
 =?us-ascii?Q?oUn5oPaaQApsbXKTNum+06WwBA+pU8+1r/o/hkwrg3DujjC3y1LELjXjgqxp?=
 =?us-ascii?Q?YQ/w9VpdsZhLC4t/tIDBb1+PWUm9Mn1oO40BJLGBDbcexMkO5kC9B7N7UVSg?=
 =?us-ascii?Q?lvlHwuWe6gMyHBQNSSu4dgE9nDjCK5NMPq5KevBIH7Fq9t/WmG4UFjF00fQY?=
 =?us-ascii?Q?l073GkGEeDIYWpxuTw84fF385+fNPswNP1MV5Vk+Ox4+rqy9qYVwgA1Y+gxg?=
 =?us-ascii?Q?FBUPXaCN2JhsdseQsmPgbW0Ca9rr5Yum4z4nTPJumvRGvDHlQwsomwfYZDuv?=
 =?us-ascii?Q?7WdCYHupjCRWIfHED+vXLhpshnkzbN6FI60yVu4DJZ2tczKrgeyCS3FbD/qQ?=
 =?us-ascii?Q?h43AogBXk+NQTiEdYxbMh1WG+BOh9VADIZANauB4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e82b235-8dc9-4f07-d098-08dcd1d0f555
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 19:44:18.0469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8E0p3QXsL7c1MpBco8pACmG3LrUqepQ68tStAJQZRbkfH5y3u8enDdCQHqgRZmXB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7789

From: Eliav Bar-ilan <eliavb@nvidia.com>

An incorrect argument order calling amd_iommu_dev_flush_pasid_pages()
causes improper flushing of the IOMMU, leaving the old value of GCR3 from
a previous process attached to the same PASID.

The function has the signature:

void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
				     ioasid_t pasid, u64 address, size_t size)

Correct the argument order.

Cc: stable@vger.kernel.org
Fixes: 474bf01ed9f0 ("iommu/amd: Add support for device based TLB invalidation")
Signed-off-by: Eliav Bar-ilan <eliavb@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

This was discovered while testing SVA, but I suppose it is probably a bigger issue.

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa25..6bc4030a6ba8ed 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1552,8 +1552,8 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 void amd_iommu_dev_flush_pasid_all(struct iommu_dev_data *dev_data,
 				   ioasid_t pasid)
 {
-	amd_iommu_dev_flush_pasid_pages(dev_data, 0,
-					CMD_INV_IOMMU_ALL_PAGES_ADDRESS, pasid);
+	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0,
+					CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
 }
 
 void amd_iommu_domain_flush_complete(struct protection_domain *domain)

base-commit: cf2840f59119f41de3d9641a8b18a5da1b2cf6bf
-- 
2.46.0

