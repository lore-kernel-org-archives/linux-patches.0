Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795545654;
	b=XjVMvPrpy205fLURXwqOCoYKrPxrmXWJBLMWlCdx2rpu0mPbZeV5TbqIgVloWjHfNNLl
	 yJC7pJ5OnqXaQjFSkkQQXcKECcZwnq17LlYmYCACMn1WeB/CyB5IPiH0DlYIQjOTm9/0F
	 +OpmG1wcfeXt+iuGsvZFcRBiXluljhRaPrS1mr/voNFPvYdVbJq4nzZ5fr/FJ1yz9MQNU
	 OfgK9Xq2MOJSMROB9icvYCXLS4gmIjKJ5hvPYhuZUofNjiBrLC0dbciOLOM87UMVKOi4O
	 VmhevityeYRoNN9IwG+Scp5s+HbiCxb34coejE6iNxtOobnN0LDoq1nL5tw61N7VZTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795545654;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=EsgBIeZ1tJhFAb5uFWxW5vXekj4HHokP7BHIQynCItw=;
	b=a2rr/IdQHwM1yLpqd7e3pb1kZDAeIw81T3wfJceYFWhmGyHecQGm4T+pZ8eppFOpD0S8
	 oOJWo+mP8GBb6dTZ5X3ez918TD6P9Od3efhKJ+xyXxY+9bdRcip9k5nzT6csixLw8LxY+
	 phbfzcYiswlw0+jYQDYZcnsBNjzeU0ueJa1qlHJkNyZsEmT5N7tFbXJ2YqshQzlOLFiHj
	 TBu0rhDd9Hi8mU0RZBtrjQtSkK6dHTuWvXVQCIz8lZ10NuEdI7i4TSvNcZX0ReCDA6gZI
	 8Y+B+ZYjwAa0ur8zuQmZ2Bl3QvbbTsN+5oHMzkjaY10HhkyFlQm6QTp5wrOdvvM+edA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DUuNyT9N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.2
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010002.outbound.protection.outlook.com [52.101.46.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04953606A32E;
	Tue, 24 Nov 2026 18:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04953606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DUuNyT9N
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ww195feTGU+CstVIqOSXL0Y0kHOZ4OAu0ZJHTm2Df2SefqM4AjqqhGkKQhWMhM9fvOhGFq+thzYRs16V5dmc8KqMeeXDnnrktungbU+oErdlnLbaKJ1elVHRhUUVtgNL+hkoFqU03xPIWcuUBnMOecpqgtlC/sD/b3kfE8q2LHEKE10t5cmuj9brJilDvCMaeHEiJyJoRhYoKKSurzfDro4AJ+7mSYT1D/DyppTYQ70vyyHr7YwB1YKJTk1fUAmC327NCbTdLGmWYOID/pIR3CIac/vFVQvPXSrVYp7ZHluMYJoMdKIB35hrfNPEKnqTNA8/gGCB8YkSzH58Wj+N7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EsgBIeZ1tJhFAb5uFWxW5vXekj4HHokP7BHIQynCItw=;
 b=RgHCakhqrSgYy7deeV7O0ymjGSjkd7x/cetnsgCqhjuWfC0n1T8x0t4/EaL18Cp5ZKVnyGTe3FlnddhrF4oJq04swGUtTcja3GJ8uURupHRlyB1AzjjJ/yb5YjVHq2PPGn0AjgLXB2q2revzKoOHIzIrvBJZfBTsRbOY/yQ9NQHt6o4hqscxDa4B5GCHScSzds7osaCoQLTGPuz8IMltKWRGI4fgSxUOWQogHjp1dyUqIbkiyuDb3asJsqWFbh1NLbi2YUY6s51G+XVw4v11pUJnXZnxnyan95b6b5pk9cnYhmo9EdyeNkyWW7Hp/84vs3t2PXvuWzUHAIaeEH1P5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsgBIeZ1tJhFAb5uFWxW5vXekj4HHokP7BHIQynCItw=;
 b=DUuNyT9NlsQdT2Uz+mL69S02LoTWTkRIxvwXO+Nle6LQTWWWg2Cgu4/5XQDkRuwudksEjT8UOpZziz927YS/oaeKgCR5GVjQeJMo1ZhEt9TqNwnTE0kYTMr8xvaJ4pDUfxraYZhe6OBILnGsDlNQa+zGQvjs3DDpa7Y6TxNjkLXip1hyf2EQ1sdNPOP7bJzcgHsTqI/gUEvlIPYmXZTttuNXN+6tx+mEeofoCnJ/M7MXoXUlIp7FAvWjDi1sd8iworrP8kE1IrODx3MlKw56rfjk4UkSfsa2x7ceRLVeh2V+9bQezgfDTUhsw7S3DcXVLJN8/++LMzLRSg3j/Rq3lQ==
Received: from BL1PR13CA0282.namprd13.prod.outlook.com (2603:10b6:208:2bc::17)
 by SJ1PR12MB6099.namprd12.prod.outlook.com (2603:10b6:a03:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 18:40:48 +0000
Received: from MN1PEPF000793FD.namprd05.prod.outlook.com
 (2603:10b6:208:2bc:cafe::4d) by BL1PR13CA0282.outlook.office365.com
 (2603:10b6:208:2bc::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Tue, 24
 Nov 2026 18:40:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF000793FD.mail.protection.outlook.com (10.167.249.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 18:40:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 10:40:19 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 10:40:18 -0800
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57 via Frontend
 Transport; Tue, 24 Nov 2026 10:40:17 -0800
Date: Tue, 24 Nov 2026 10:40:14 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-coco@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Bjorn Helgaas
	<bhelgaas@google.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, "Xu
 Yilun" <yilun.xu@linux.intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
	<steven.price@arm.com>, "Suzuki K Poulose" <suzuki.poulose@arm.com>, Lukas
 Wunner <lukas@wunner.de>, "Ashish Kalra" <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
	<driver-core@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v1 00/10] PCI/TSM: Support guest TSM drivers
Message-ID: <awXaDrmHAiTW3SA6@nvidia.com>
References: <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
 <yq5aik1n4iz3.fsf@kernel.org>
 <2026112429-expansion-wilder-a0c2@gregkh>
 <20261124131641.GE9566@ziepe.ca>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261124131641.GE9566@ziepe.ca>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF000793FD:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b40664d-71c3-4968-c593-08df4a5a751e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700016|23010399003|6133799003|22082099003|18002099003|3023799007|56012099006|4143699003|261028144727099003|261022105027099003|261021135927099003|261102123227099003|261021121427099003|261009223027099003|10067099003|261026140227099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	bOon2WxLgHVctToGfrDSf1YE0dFr7oTRVrQ+r8LNVjgue1GMHHsTOIBYnQNVRF5PzV9aGq+SUDIUiRYM3NNtG3AjdIXW86m2pA8KhAZBuUrykwVMHOthNF8r3h4ZfLJGD9idOnrzHqvhph90ds58w3qZJvKo8v8rWuZclqZt+cAf9kpXLkjZK37kQqjPtcUN5wNquv2uo1kLWGgtvIeJVfgEH+FjHTQxxuz3yu/XNuDDQanCYv5rBqHuoxsLBtDAlOUzzlmw4NE8sbff0Xa2iGmySMq0U/JBrqFy5x6hcFQlxL9QN104IOHgBmyemvw/PL6KzaNTduc3+LF2heMJe5Tghy049jrEgK1Mp8fu0J0f1LUb7h5/PHMIjuHNQhiK1eEg8ZKhJBLH1TnHcadv6lUf9gd/QODesMTbGhya0CZGnwd+GfYhHQwG2N1ihg+eAJDfMq2uSR+7Hys4oreeqCpgPBVVV0JDFISFaNDGu8ePbgBs/IkIk/2TX+RQZoIe53mt8Imsi0oYxk72sBwTW1MZYauu+MQjEN7QGZKhr4Yy4BX1cEOfn0S35m6iwMKvJT2++H/Jc6aj+IR496C9m3Ni5mgzOmQ2zTswox+pR4/rNHvuiLH+5XUVwvGLWrbGdWFo0Y3Jkh24oxTmUHwC9cCKqCiN7aLFfY2YrkmTiinmgPmUh2Fa163bNd/RDZgL/72mJxP7H5dfbrcKzjqLXg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700016)(23010399003)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(4143699003)(261028144727099003)(261022105027099003)(261021135927099003)(261102123227099003)(261021121427099003)(261009223027099003)(10067099003)(261026140227099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bfigPpq38q0KdssH7NkC5K0rSxSV6oSAsuweqmHouvZ3Xf/319ePmqO8FmBaAe/Kn8iEgYFghIvBAkdGSapA7nHYT4p1T2pzjWK5hYa9/+7TGaO2Gdex/El4D790TuUm6mbl0QcH80iUnUF+Ia1yys5UzsayjSmeWV5sSnaKLIIYzJfLOkNWct6gkhsuvT3rGsHOCzyICwaFQ34sWDwzg/FVpE6ok8MwyBqr4lLz8qFFBg8xeU+fa9cndvGwzXyIbNkr2wEd94LDBqDdd/6V8xbSnarBgXLe95EjoCHwOiECPbxGALvWA0UmKAuhFmitMtblROMcC0poSmN3W/t4mPzuMqV+UMNYAsbr3epSRJOS/W0clGu1s+KlLud8pup4LtromvqD0dY0KfaD/YeQ9IB5h1QBmkiRmN8Jem+XjyfP8oPDaKr5JkLtB/kcFNa5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 18:40:48.0566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b40664d-71c3-4968-c593-08df4a5a751e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF000793FD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099

On Tue, Nov 24, 2026 at 09:16:41AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 07:44:03AM +0100, Greg Kroah-Hartman wrote:
> > > @@ -617,6 +619,7 @@ enum struct_device_flags {
> > >  	DEV_FLAG_OF_NODE_REUSED = 7,
> > >  	DEV_FLAG_OFFLINE_DISABLED = 8,
> > >  	DEV_FLAG_OFFLINE = 9,
> > > +	DEV_FLAG_DMA_CC_PRIVATE = 10,
> > 
> > Again, NO!  No "cc" nonsense for device states please.  That's an insane
> > policy decision that will be driven by userspace crazyness, NOT
> > in-kernel stuff.  The kernel will give userspace the tools to enforce
> > this type of policy if someone so desires.
> 
> This may be the wrong place to put it, but this is not a *policy*.
> 
> This is a "DMA property" like dma_mask, coherent_dma_mask,
> bus_dma_limit, dma_range_map, dma_params and so on.
> 
> The name mirrors the DMA API name for a related idea:
> DMA_ATTR_CC_SHARED
> 
> Unlike the other DMA properties this one is changable dynamically
> depending on how the HW is configured. The TSM is in control of this
> HW block.
> 
> The userspace policy input is how to configure the HW, but once
> changed the DMA API switches to following the new HW parameters.
> 
> Nicolin, can you put this in its own patch with a good commit message
> so we can have a discussion where it should live?

Ack. I will make that in my v4.

Nicolin
