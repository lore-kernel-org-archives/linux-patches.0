Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7A84206F;
	Tue, 16 Apr 2024 20:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713300550; cv=fail; b=aTV+n+hQ7F4ZcPZHFj8Jxj7HNZ5a9jUqlDemSHRXoAUN7inJZegcOKDDX7qdx7DncsnzR8SSRZNcFXHFsBnDL2A0AYAiS8UWnVcSRkNeefygnrFwBe4MzGaj8NR9hp6BeuidKncNpfSzsD85M2tvZ4dmRKCTAuob7bMRa4DQYOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713300550; c=relaxed/simple;
	bh=C/bewpWOI57NZQdeU4U4qa1BvVbEok8gQLT31J+49Xs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XWqwh+z9S09O+16cTmuqKelXlAbbwjgc9Lwbb5g6sl9DA+7g7l6HK+DX6Wle5ArJYlxBMRd4Gv82xlh+2+oikq7GYWoJrMKCax9/fgNafTzT57cx5cku4zdxik3y1xYtahGP6NJruRIxtHpOcrdnOGB/aKQx84TzlxKx/LQt2uI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mEtzbByb; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mEtzbByb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3X6F0FfFU07ZegYE8iEj8vRB0qceFEHzyhD5pY8LC1gvM6KsKUFRtWqAKCRYZlZl8dO+MhaLcsv/xSkoRgOL81oNEVgsuSFktkQjNxoA2T7SS9ooCZgX2d+DKLnjGH4HCaAXZ3hVmm+Ee7vmLl2L//hlkLrWJ2x+BufMjChfkQz5SbUlChJUBEQPKbXypVcWikv6/CDmJvDg5vfj5OAW4fWoklDYlElosk8SFkyeh0nDQ9TCpHnCuLMYM4DXQOxhWwafTvEy/2ZjK55aIi/zLAC0UsexILHHzzhF6odRjr7i1b0x+JMn7djdk69lZ8EhxaUn+SmIATji82X4whb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WI1ikrV1KMYVaSJX7BGhRDYJKs37R5qU0DVRsCZttWE=;
 b=fyP5olMTy8fNsqJCXj0hjY9BV429orATRztlNfSQ28BpqpAIaR2JBCqjv5G+iDzahhw2iELH82gDw36v66nsZkkYnPzfVRKQOoZPUNsALgtdURM1DtDcBryJSh7ic1CRtHY7tgbXqUjZQtud1dVcYVpA4xviHFVRQK2TXJifl9V6A7Al4GhfhI2lP4Wk2lYMWf7bopPSp17nzvzQ6HNwj6OKirmgxSaTLoCegOcYvTbJ6cTZ8ygwKGq9fmwwdDlXFH3HrRCN0VJemO5VN+Nc2PGZ+xIKXojOmRkPFevbjVTFvt03ioA/wd6xjUwAbbpbPXD4aY358t+j/IPa2ye/+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WI1ikrV1KMYVaSJX7BGhRDYJKs37R5qU0DVRsCZttWE=;
 b=mEtzbByb/QFEWJ48NStVbgDv1l+ohot67G2uqTkKTGWHeY0qso57c0KO7QykVGATB5CZh3dNx/7t0RcflW1J1Set8XvnfEhTtLSDP55bumxQK5ou12zr+xrEf/r8KVx3gzQDmoX4IEU0JuDMHmhNPafKuSbQ/cIRX6d6ET8fuvLXbkDgLOziIzJAQHa6IAxxaOC9wMVny60gryBUKZGkp3DCINSOxbiujRWbvTW5WbPle1e0+sGBUyngZs7WkBiYowK4j39Yv1ipoTqku4mNJMeYuzlFcl40eCBGe97pk2h0fyYkFfwKy0x0yE2jLZDjwwxFnleeVaKDLGiHO/6qQQ==
Received: from MN2PR20CA0036.namprd20.prod.outlook.com (2603:10b6:208:e8::49)
 by DS0PR12MB7769.namprd12.prod.outlook.com (2603:10b6:8:138::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 20:49:05 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:208:e8:cafe::3a) by MN2PR20CA0036.outlook.office365.com
 (2603:10b6:208:e8::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26 via Frontend
 Transport; Tue, 16 Apr 2024 20:49:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Tue, 16 Apr 2024 20:49:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 16 Apr
 2024 13:48:43 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 16 Apr
 2024 13:48:43 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Tue, 16 Apr 2024 13:48:42 -0700
Date: Tue, 16 Apr 2024 13:48:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 2/9] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <Zh7kKB5okuKcc7W2@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|DS0PR12MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c057f1a-302f-4758-6e6c-08dc5e56a754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	31OiNucTNeJ7s3yg1b8l4lTO7tsmh/q+UX2AzeGHD0fJSh58ZC5VGnakaZhzasE6bORsB9MDBTIEZxJTGzLRJlhVzTp3hzZEhbGf0/gC3CSNElaIhq/UVc8uErE31szbYfPn2tMMvSv+GIhJc0bH8luBarh0Ipsg0YV3Gqm5EoH3V+hbVkVMtPrdlkpf2LB60rHpUZ2HFRt34l58o2N0zVVmREdhCT6iRJLlnsqetAJsXm9vDl5j0WZEmvwJ1wppsibYnhGBNphnS1xccZrB9IgDhMNqmV6onZY4KSCNhM1wSo2zIa6VGV4X5MtbjxR+HL7AuVXu9e+k6d2rOuSvl7KbtDAQITUh4ceSEDBExuTIcLmKuI7peZrHpEcvNVIcyVnf2mPCHBBwltWCBqi8Uig6osrq5SHzmH1yRpZaabIQdrY+H7k88XMKwHpDE1vER7DAhn5htln1LXYvgdN9774xSBF+6CsLkZXeybruX87pGwOBsTxVX+dxTzA1h5MTgOAoQOkwhWmmwl8zLPFXUtTnjLOxOyrvFlf4s+9gvWO166v2oOjLqfFnVfOd7Xq4iJ/owXVle9eDZamnLHyklORNC4y3zzdd3lLSmH2Tiix+4SWhA9CMcBDVWEPtBJjhITiBR86FhcvkklDjKdP4aRnM4cs5ACYH/9IfAmbazD/rK182EwqGmm94ygaPeb9s4dfYE7EgAorldwr/a+ew7183p4WmLKzZouRVSprq4pOS4pxnZ8hLlFtsLAPDDYfN
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 20:49:04.5263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c057f1a-302f-4758-6e6c-08dc5e56a754
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7769

On Tue, Apr 16, 2024 at 04:28:13PM -0300, Jason Gunthorpe wrote:
> CD table entries and STE's have the same essential programming sequence,
> just with different types.
> 
> Have arm_smmu_write_ctx_desc() generate a target CD and call
> arm_smmu_write_entry() to do the programming. Due to the way the target CD
> is generated by modifying the existing CD this alone is not enough for the
> CD callers to be freed of the ordering requirements.
> 
> The following patches will make the rest of the CD flow mirror the STE
> flow with precise CD contents generated in all cases.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
