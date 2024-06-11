Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6794215B0F1;
	Tue, 11 Jun 2024 02:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718073404; cv=fail; b=dvfT7XdDE8hwU5L1jmsqPRf5SFneC08t5rAMDAkliasD3z0jNrl9lmHIfhC+MQ/WugTCDHGULGZqe5NidEtMMtuPPbcL58ORMs3GJ6499Kv/ia9B9sCvl+Q6+Se+XtViapopXMj5tOW86xtprpJ4s3tnlBuOfr6FITklOd+Cjhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718073404; c=relaxed/simple;
	bh=hOtd+J/1LZx7je+e5Zw/DnIjoBUXlCGgh54/QIHDG8w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBO2fk59zHPPYUJZdKQ6ovZXbawdVviMcHLHPBmhWIyi2anMQzS/VTw3iZONiyAMf42gmNH53+mF+6m0offUoJQkOVThuHCUG4b2bPVIeX2tr8ynmgQwOEdqWxkhYFQ++wUBKPURN6hTnBH9WeLj3FRp0j+wxDCjhkCVjeRBcbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Li4bhDrd; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Li4bhDrd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8Abag48+FOFFlZxAw1VYQxKSYKWa6gCWBur9wri7cgqYqPWR+05m4V1BmBfPYwwrYvX8SWWwPUoFwDLSxbGs/sjiCcjy3IfgGAAnom6L82HGkVxph0Pnd3Mx4M6uqdD8pBotZzj/eT1/hckzmIeI8ntpOEEkU3/1TaFIRvEjgBj5okk/OqNbHVgt6xtEK/fzgMnFpfskYsqfhOf0/XH+AOAGz/Hpy12iJ/s3oJrseOo/dRubdH7uQ5ln5xpVDWpDmHkbXcEUo8xzuzvoD3WPiHoEJLAy/6H8+j4Jk28ms8EFM96+cn4wBZExsG+CjUOYL70srbzFBMXpIHSrgDm7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpFlWgr/jPL42ohPcYhhBZP1VC0hK/aEGXXFvDj6PD8=;
 b=lgojX4SD9LZKMqG+7WhN1ZECJLdOaAsgph2vXapu05Xgk+Zl8BimHCmTS8DbrQQo9VZ3LsZ7lgxZ4rbAG/dpYKQUhXTcPy+H63onsDrPJ2pi7F8IuJD1mS/QsFId/lJN6FiLuLN4bChdkOxW56a0Ab2dDI60WTEdPZdzTIIqiQQM2jbWeRLZFfu6gGexeQ5FEGnSMRyfRuF9t1Sd5FviuW/awntP1GJlNFJK2qIFGIxlhrOuZLpj4ztHa8FhP7KOGIRekGor1OE/49xc7xxtv9FJi+NUItOU5tJsT1z42/NEzNKJfs7aB3N9W+el+7VFBvy42RpsEfuRgfcyZAikVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpFlWgr/jPL42ohPcYhhBZP1VC0hK/aEGXXFvDj6PD8=;
 b=Li4bhDrdS8YRztI1bmoitb/o9eQ27ffzJ/EBm2ZZ6OBOkmiilw4944nYSwqHWg2Q2rkiiFhNO8Huf+05e+oLhs6/svyKM0y4B6hQP3QG+gXTmdicQvulvuKvFEWLb40USKObm7RTZoewJZo3PxYRmaVlrHnQbSq3rL2VBTxkESeJa7e7qH15DxkDkZ/NIbdv85HHN/MlPOALXkHVYtXQVZpgagYA0dTkEaE9+4oC2EK8+s/g+yQXeDmwwkjZG/KkwmHdKvCP4Die2VD5tzu9UrPXMgvLT2iuVjnTmgvw94iqFJEmSXBc0h6z+OPtz0v44A9HsiB6r49OS7jEsU98Ow==
Received: from BL0PR0102CA0047.prod.exchangelabs.com (2603:10b6:208:25::24) by
 BL3PR12MB6618.namprd12.prod.outlook.com (2603:10b6:208:38d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 02:36:38 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:25:cafe::7a) by BL0PR0102CA0047.outlook.office365.com
 (2603:10b6:208:25::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 02:36:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 02:36:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:36:22 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:36:22 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 19:36:21 -0700
Date: Mon, 10 Jun 2024 19:36:20 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 06/10] iommu/arm-smmu-v3: Remove strtab_base/cfg
Message-ID: <Zme4JE0wWP3v2P0L@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <6-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|BL3PR12MB6618:EE_
X-MS-Office365-Filtering-Correlation-Id: c9b95ace-cb6e-446d-5066-08dc89bf51a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8CW4BbmfMpCD3kDIkJSG+0LPdrU2znHq7ZzixYs1+mFC3ZJWdBRcfSK+gsSD?=
 =?us-ascii?Q?LXsDMmKYyQwuP/MDuRlhZ1m2WhjY2EAJvO2cFXM8shxtutROEw+fPzLsQwqd?=
 =?us-ascii?Q?Wezd6AiklIujU3KTI3bOy+XZRY5TFuOSZP0SANW56jSXKjubY+6ONeFpHvle?=
 =?us-ascii?Q?A6qUtyDCZQKQqbj2IyV/Veq/or1+1ab1EbywpF3wqou3oSQiY8RXHlAFQlBW?=
 =?us-ascii?Q?tGDBGvEdHJ1shPqNsa43+xozmY65Ww+tUwt5x42Pjj4h9QLXxRR+R82zAl9H?=
 =?us-ascii?Q?NL5U7Q27cuj+jeiofCqIHkfWeDXZdEMHj7ghnMXRZtLCmWjI4QO6lcCoYV0s?=
 =?us-ascii?Q?bs9XsybIiO0X6e4iwPJ7ednizpbWFiGe3SKXNdz4yyEylo4EdLPkw/y/3eDH?=
 =?us-ascii?Q?O5PqXEEsNTAq2bmNuMqlO6U3PAq+/doX3wHeTYvyJy9RdOBJhVL6AHaDhPvV?=
 =?us-ascii?Q?APMpUe/aPG64E02ltXSV4LOL01jA9tSO4GsFhjHsi6GHJVEVAYBbGZZUIdCR?=
 =?us-ascii?Q?aqBEZK2V98GDJGOlOyq4nZRDit+dJEGcKExCCoeQemRwGrAeypGHVw9bDpfO?=
 =?us-ascii?Q?n31ojZAl4JYXOJM1IjX4Lx466K0GnRxkAXnBLiis3AcsfotSvZi/KiPeffVH?=
 =?us-ascii?Q?cI83hkp0v0EGsK+wHc+NIwU2l3syAymx79M7TtTTnRM7ivKSdCBK/lnwmud8?=
 =?us-ascii?Q?ak1LcGZsbsVVzKe2lB3r89Yy19zj4yNq1dp7yBn9URB9yz03I7rFGlJ2csep?=
 =?us-ascii?Q?Vj65+5UX1VZD/GZfouelWn0c5igyH+4jAtTRE9xSyYrQXbztV1k9/b/RXD3U?=
 =?us-ascii?Q?gWlKgv8RO9O5LaI6b2338RvPo2wC8jE5RnqMD4Xl7d5AEB5FFU0YvQlDiwGb?=
 =?us-ascii?Q?/T68pQ8RvJ/tlN00ZEVgcbghsHSJ9eOLWH4JmaGDdy2qmduBVBLgYqOHMtux?=
 =?us-ascii?Q?8n6yKepnHe6NNv2wAk6PzwnmI1MwRR14I6G69lLJeb5wtT4M8pjSYSgZ17N2?=
 =?us-ascii?Q?zqk/eQEJfsxlcwkSgj6uEGLNCaNN2BfVeJ1L9xt5bOcxcnf+aDSBDbP+rrP8?=
 =?us-ascii?Q?PYm9FebqGjzCgso02FnyDm5GxXnZeytAHbVtEoziTaGRqG97RD3vwRQjwK4v?=
 =?us-ascii?Q?cKUbzlTifgPVgHHa3WbuHsubXpLmrjlNaw9L91qf3bjumLlypSNS/a+r7iIN?=
 =?us-ascii?Q?Bzed9G+SOEHvnQ2oTu6CRPu0Ybhp+xfz2Hz7GATOZu9bjdXNMM7u9/IGIAJ4?=
 =?us-ascii?Q?ny/rnEeKud99+ahIdhzsVytgUDL2i9DXePbWZ/LuUfPr8bYyEgbdwisH1cov?=
 =?us-ascii?Q?RKMssYvZ9UOXN7XABEeLqgvRBzj7iXMl3K+MSPa3tyCiFeAWEYOOzyZ0ydqp?=
 =?us-ascii?Q?uvLEEC6RXLRZIgsVZRT5ADKppxFOE0PbRbPQwCnzZ5BpCTkiNw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 02:36:37.9087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b95ace-cb6e-446d-5066-08dc89bf51a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6618

On Mon, Jun 10, 2024 at 09:31:15PM -0300, Jason Gunthorpe wrote:
> These values can be computed from the other values already stored in the
> config. Move the calculation to arm_smmu_write_strtab() and do it directly
> before writing the registers.
> 
> This moves all the logic to calculate the two registers into one function
> from three and saves an unimportant 16 bytes from the arm_smmu_device.
> 
> Suggested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
