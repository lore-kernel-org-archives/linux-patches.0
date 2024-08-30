Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45A920EB;
	Fri, 30 Aug 2024 00:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976403; cv=fail; b=UjYKsTxO0XBW3JQJ4XCjINX86YaQUBOOaZO9sn4b8sdkEzTf5qL8pTAQx0z5mDfp6gveMYJ6FIfYMKQq+x2V5a6l8lvmq+CGFaG9O/xfvOsOFAvnpAHm+hQOk8et7KHJhvpq6iSEuLuKDOaLBWFXlCYkb7jdVkhdV2CJd6bNY2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976403; c=relaxed/simple;
	bh=58eZizpKpETIVV3McZpa5mpVA2vEUAvNnd515zXpVqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZYNJldbm0cRTJIzy+xHsxw6K/rDLams+ZsjrMN+zoXMxw2WetVsCC80gEEBAxeNfLIX8cpxsdzbgGjJLaCkdUsmytTRod3ir3ObwbZBejFW8lfxg39dYgLcPFn7nV37VPMbUQLkdUTQeGcNoNzPk+LNwReXCn94fb6B8aU6hGJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DLJuL1xE; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DLJuL1xE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=onsxmvDBeGcTqHJWW3HbeHCOCs6WaC/TVEQikJqlkW5t1IjXA73nptkLFijnl+d6OQoRsClDm2byGNA8l/yYStt6vNN4mr5WLTF0haTUOx2kqcWKhd1UT8vxocuojekbkeKywL4Hjr/sR5U6gCwSb13PnAIRKldv2nQH4QJom/IHt4aNHjkuoHNmzj9IuCBRxUhXl2N3sR1Q6OzDdFA/3+VPYOD3usZzyC2+1CiqD2d4IMhVm0I4gUwDum++21jQZHdgfrT9EY/8L/FhD3SaxyrByGvPMPdA4U9QL5U3o6H3MOUGyV8BRo2oLucK38xImtpR/GPp6UdNyazhLgAYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqKTSWLrnv3BE2zAOdR3KTRdDZToM5hpDjbbgYZ0w3s=;
 b=hvdNRB4PSuKDZTFy5wgLOKQH86KK6XvB8CM3NDnrY4Nn4ObSSvEykUHt/L+0UVBLESJDJZTqoBxS+F3EjVC+Vuqzcj2if0D5C3SjLKE04cOxI3G0AJldsNJJGNSEDkhT4wSYnh2s/vuXk0nXihAyOrNu68Cg8rnM2Je46vNuDv3bj48hLAcrDORP5UmJ3CMItbTdlubpPSyx/EkDYZ4EvOd5Ltn3iAphXL7t5GurYHDOgVpf93CrS7vbZi0WgXfyFfECI0ouCsVbC67AV21kLDLl/sSXvQnoWCVjsuCpSObc3fScI8cs2qUD9gQGU6FTRLr5N4GagLmNyz5sVTB1tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqKTSWLrnv3BE2zAOdR3KTRdDZToM5hpDjbbgYZ0w3s=;
 b=DLJuL1xEturRUfpNYsXox7CohQ/xLtMI+9UOi/oPfVTXusUPKJBvWEH9bvpdzInRU2/5XjYzXgdmpEk7luYbVp2HABNy4u3x0zFpQibauYUE/0wyIDehoCH5cIpU3AKCerrbKKIL26CRnsN/a0ok10zfu+HQNThSFyVaE9JXqrFT0I1Gmn3KYQY7rxJN8TUhSROrB4BF8FJpYAQweiPF+LcVa6KpkAPZHvJtJY7d0m9r/h4DEGKqFj2UUPaNo7TnMXfradJIWEkHhE0HEC7rDcJEQCYHmRyG1//cPh9h0BoCAlk3gVt327miOhd8doyHoM0WRv7AHPMz0H6niZPAeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:32 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 14/14] iommu/amd: Do not set the D bit on AMD v2 table entries
Date: Thu, 29 Aug 2024 21:06:23 -0300
Message-ID: <14-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0903.namprd03.prod.outlook.com
 (2603:10b6:408:107::8) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: 7617a6b4-b79a-4e09-a2f8-08dcc88796cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RS4H88WI+wMXBF4/Jb7gIhAZluvhY36M0njzFk570Nnawxc4HLBuulO/qwPJ?=
 =?us-ascii?Q?0O1NilZMbFY77eLAfdbVyMhwz5+HrNngoTBUehP+as9EfRiy+4NKzzjVk4kJ?=
 =?us-ascii?Q?Rfz6Jb/wiTK0tALfpgiGOoCI3WYwCfpmxDTw4N01gpjagLA1tsq+018HFOmf?=
 =?us-ascii?Q?UpRQI9a6oJP1YahVl+8/gzOxjh7MJGQ3NYjZgiN5UgbYucGiACpfoz1OBtWw?=
 =?us-ascii?Q?VsKUt/5Gdm4yiutphhvoEvwbr2M9bcwe2k/jP6XXpnXK+K1klWoO7PbkPFUz?=
 =?us-ascii?Q?0DQIhgDOHeqv3SKWmm3o9izCBjIqMTfp1rDcjgYpSILJ+6TwrMVzYaMyJtB8?=
 =?us-ascii?Q?On+iSqCWbYABXiHEE12MNsFWAkb7gNRNSimNngVto4HsuJa/NXK8bFlLzM87?=
 =?us-ascii?Q?XZDgB88T3HXVjSCiEBILX+K+CFBr1gMNTRHyrT1O/JdZo/wvQa3Uu/Bdq5/S?=
 =?us-ascii?Q?r7TT9c6Z7xhhfRNf+Vs6fqQBZXE4kO5UMG+MAglwsToGn9//NPvVrzKewGfp?=
 =?us-ascii?Q?JJ9nWaPJ3hJ725FyvePDEweiuu8qrk1krPGhoU/Z/UttgrszxoMfPnrYkDAS?=
 =?us-ascii?Q?tdW50bLRtwfh1sItTU8ToZSmqLhY2SmSbJ3uU0sOPpx00Iq6EGzFDLzdW/Ee?=
 =?us-ascii?Q?VceJ59i1Y57fHVsLeXvVERIBTn4w9/Fkvg55PkhIoUXmvJhl16AW0Ml69wJa?=
 =?us-ascii?Q?5VhaJBhVyixIuu3O5S+pA/CoXtHc3nX75/u4hCJJlqjXgVCQzc7pmivSwuRD?=
 =?us-ascii?Q?LzeGM0nOGVEBRIz61FtD/jG2pJL8b6n57b6WEJEiGCWj2cxka/u6FQMEDtIC?=
 =?us-ascii?Q?M1Cl4gtGThfGmz96Oh+pfiEbDmLpkHhj2wgFMQ8KXQwcgBm9zGmypveu5B2b?=
 =?us-ascii?Q?2YSISahhFILYQGpOozpLuLYOad4BQorVqiEBAL//PkdQvks3hP2wqDq/WW7U?=
 =?us-ascii?Q?TxIRVQ9hm7+9mckybRTc9aeZTJ4dw9dD03qT2FQeLb+B1+Ga6+gvDvUPNid/?=
 =?us-ascii?Q?+1y8e+nXgt/xQNq7ymdH8WcDp0tWBgeXh0Xr1UQg9Sj53ViZqsv1fmVJK/fY?=
 =?us-ascii?Q?SnI8yzzq2gg0ppbBzomxEqqWHJ27Kl6HCvzQ0ofGQLXVkQ3zMnj8AgvXOfzU?=
 =?us-ascii?Q?YQeWvVOz31vzed7tbvt6ZUwFGBWAAx6N4/dNxsGI57ZrXWV4ae9zQPiv3++Z?=
 =?us-ascii?Q?xqp0kEBoAO5J8sXt6+g1XRCcQ0rvuY11YNrDzPImPkAYbfyZMOtaz8bUvotD?=
 =?us-ascii?Q?whNRJk42EgiNKukKQ9Wqf7cVet/0gurBpA42IveBZq0Cjl11xDqJdE8Mc1nq?=
 =?us-ascii?Q?7CvgU9KdYxPMo66NBDGHzsNffgCWNDFpYauReaP9SESi5w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JYyofVsWwI26ea8t/zQ5c91Sx9A2gLztu+oAiGcSJ0UKzqTHukBIunNxcrEP?=
 =?us-ascii?Q?3cMpiZfObpMvKqcBg2bErurSzSkVGPsYUjCQJVh4Hq9f/f559U13AcDJ+r0K?=
 =?us-ascii?Q?0dpiVQrCQzv7fM3F3quKlYAxmzS4OGeOB2BXjEM1rCaHC/2ZSsfGfpTHH3Ep?=
 =?us-ascii?Q?i+WB3W5Gg51TGXQHzGBOBuyHvT6Wl/iYW0RuMMjeVEo97FkV7dMMGilNnfHR?=
 =?us-ascii?Q?R146IuqdKpNTo4euzcoI0fTxOKywbSea44KDAkz8sLCCqFY18kpHJV+OwBu/?=
 =?us-ascii?Q?zyILv6zeEBA+JBP8eht3rNQEOyCg7byCXqkNgo3ss0LoAXJIzjnOS6uJTTOn?=
 =?us-ascii?Q?TrZwgZH/NqzO1z36GQRi9/gp1rEY9OOUifY0IFEf0muQwBpIL1eOVYvLoFkt?=
 =?us-ascii?Q?W1Ovxsnjle+8QlmVSVivEdkxdy4nWxnt1Y/SmUXFNPZpPWwYpZ1M1m8yF2Lg?=
 =?us-ascii?Q?yVQiPLHGuF/RS3448KxO39kQSOSuxI/cwnO+vtFUoUl/piLf3cVjyvZz+G9u?=
 =?us-ascii?Q?dsnCnbtBbT/jtiVBcSaR+4f5Y8fBsLSiuhRVjRqaMh91XoAuqwdykYhvupnl?=
 =?us-ascii?Q?lV91l316iiwcIhyIX6Be9aVqL9z0XqkkPKTr7G1Eel3muC6iB/xw13JeOYpw?=
 =?us-ascii?Q?vhvgKhimtY6UQ78krd3W40vPN+HRkoM3nNSsaqiSnZHB0DNNSHeAIJKiFvLr?=
 =?us-ascii?Q?mHDso7MXPHA2vkm+bvIa+PdDygy9W/MP32THDWLxaTAC8PKF96jEtMogVm6B?=
 =?us-ascii?Q?DhHCjcrjuKIUUjOg6Ri8yaQNnnvoNzs2GUWduZK5O1Plu8K8AOySEu3sMBg+?=
 =?us-ascii?Q?1Hs7QS1DDTnQNxMRRbm1PwDya6MgNUrbRaVaTk9/85E8HD2fP5ctTnfjRuF2?=
 =?us-ascii?Q?nYekxTkgMAe9t+Om0lTl16F+YXtoSe8YjcmDIkEX4hXE/U0NNjFf29j8ozA2?=
 =?us-ascii?Q?6XBWeDo9nusrKxZaQrlcnmYGmumQRd1/VmE+bL6ZR02DCU6b+8qCcudKz8wy?=
 =?us-ascii?Q?tU9/gAuOG/eP8t7gPdPZaYv44N35sQA1Xwag51XX8GdqtmAMzU1SvcO+7ylg?=
 =?us-ascii?Q?/hDi5y99+xTEc0AuHbqpXx/jl8Mc9dOCIv74Ofvysv508LlrxVaLVNuZYCt/?=
 =?us-ascii?Q?qkqYbkiQ7eLJvh/4ZoDUGHyfSvgqxKUv6CTEhJHR/Fi+L0xweuz1R244BIhE?=
 =?us-ascii?Q?HjW2eGz4JSjt1Vfm7Wu/nkv1JkdnKdd/yDqePl0e9m53XrLT4I0zNKdgv2kD?=
 =?us-ascii?Q?phAUY+f59uwnhzWX1YiYFxwcImIr30O8aDR3DN8+XhnQOodRYLdLwt2CUeWM?=
 =?us-ascii?Q?Rf3IijPfdB/7AYKS/sktDKL9q6FK2psIDy6CWQWjKwjWB6G+2uce1VRZhbBn?=
 =?us-ascii?Q?rgmeUpyl6N1w0KFzXqnGbuqll3lJfgJWPg/fsnEYx8ruSO+jFAsSBVoAfNus?=
 =?us-ascii?Q?PafX/GmZUd9YtpfgaumweZ/DGAwOqfuJTUMZJxq5W4jclbZ2yoCvkjewnmAy?=
 =?us-ascii?Q?uEFfFazMhvMAmLImEEL08LPFQ8TxwrATUIucO+9Tqk+wh3jO25iylUKenl3A?=
 =?us-ascii?Q?8nJE1NOkY9cAkh2GfIHd1svMEMsstqQRmSHRo+Rz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7617a6b4-b79a-4e09-a2f8-08dcc88796cf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:25.7133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wT0lXBl5KOSwMlkvkSpxfuARxs63RUmRlGpRq7uf47JDLaiQBkAaer0iJfp872mb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

The manual says that bit 6 is IGN for all Page-Table Base Address
pointers, don't set it.

Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 77cc1b4a3f0225..25b9042fa45307 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -51,7 +51,7 @@ static inline u64 set_pgtable_attr(u64 *page)
 	u64 prot;
 
 	prot = IOMMU_PAGE_PRESENT | IOMMU_PAGE_RW | IOMMU_PAGE_USER;
-	prot |= IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
+	prot |= IOMMU_PAGE_ACCESS;
 
 	return (iommu_virt_to_phys(page) | prot);
 }
-- 
2.46.0

