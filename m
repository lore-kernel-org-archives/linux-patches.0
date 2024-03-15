Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1301426F;
	Fri, 15 Mar 2024 07:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710489182; cv=fail; b=pVH3FsL9T2DPzCtZSFtoiaaT2nAnX7adCJ6lt2YCPUwKIZ/CRtfhu+l9OMDlY/XHO+1ydopcYSDoZCsM5sYhrKqamGnm3JnHQ3FGXiTvkScTjAB8919Redp74iFqdSGYFRrNt3nzX94oXTV9ykeH1oYwXpDfVdHlpThmO/O0ezc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710489182; c=relaxed/simple;
	bh=8bk3v98nJ7WQTPJYEnlvwBckyp6v5j9Lc55teLyqd1o=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A07N9hjfdTLDrpyQNqSnvg/8tFdUgs4+UcpxnF8EtwC1Dq/Wi12YN/Z2NI07lVBDDboDgIaDHTIsZEj/L+0h3eW2OfIklMJZG1GLU9h1jiSBL8GuLZjirzWyQwpnk6UvTqbBpYVzWONKyy2ZZg22uzakUUaKH2V/PfdnqUEVy5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QI9EmOmD; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QI9EmOmD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hk6DUppbaI/Qoc2SIfVAgjoa9v4bc+Iu9HgFm8UjWzBvwbl6kuDlOOb+yTsMH2MbFeKGvxyEORnzqqsYfObEgBt9qJcWyUpy/v5NGMeJLvwuhc+EzrkRr4QhU/wTMufGQEzJd5VaNwsLwAvPBiJHTFeor/tAGYoRw7BSRDsbwPoPsqmcnXg9n+1sCYjVAaXpi3zReGpU3/RHw2WbtX2GwGcpxdQfyiolMk+XRHLf2sFyQSaQARrvnNbOiPArxddw8jdvMGO4vna+b0gxWScm/oOuHTbYbU3dWN+96VLl5u6Zvb6M18FD/HjViWaH/zfzToPQiTyiKJmbSSJoTrQPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bk3v98nJ7WQTPJYEnlvwBckyp6v5j9Lc55teLyqd1o=;
 b=i64T9L84rfwOWpNOi9IOE30Vy+IAEl9MJkcXdaf3Ewp0VQA6i+W8i+L9GD7tiYJduePMbJoCuo4ifaNs58ronPkc4U74QOEDrT3RKkKwJtpTPJpBu87n99BGEYfuToMEm8esxbKEsAWduEnnfM/v5wUF3CkQJpqemrRZbds0YotIhtydmrusVyCcoWMy7sQjqAG4M1s/piqH+Zo99yy2Zhidh0CItkEi6n1iqFlVhLfoNBF708yRbi1khiNLyFwg3+UqY2aZDMaU4MfPY5MXu14G+Jcnzdmf/RmTarMjje8UPpy6BdGyeqQqo2Rp0+KLy7eBOm5+v3cbuGTrYVBusQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bk3v98nJ7WQTPJYEnlvwBckyp6v5j9Lc55teLyqd1o=;
 b=QI9EmOmDgqlxihJcVuOzKCLKMo/0MIfxSJS2Yk3gE0FvmHc+W8RD3khQSSeDji4OXClIfJKs1/OiYvR2cHPNJmTxMlVGhEA7a7VqLlnBmJktcaut+52kA3hq6YbYxoH0V7V7nliyNG0LJEdpeaD9sLwlhgxz1WJp8sAKyaUP/LFSVuwjHyBN7iMVkaB9/YYJy2X2zd/5UWUe7gP/kmiacekpJZOguovfjXinNZAIHzlz2z0is9ZIVXsSgc6POVHKimXcjl1Greh1LYXyKbwdsJmMlENGjJSMsMMI4cRniOPPH49N6gfwmdxz3440y0qf4wXeqOlXhjnvDV9gwPZJHg==
Received: from SJ0PR13CA0130.namprd13.prod.outlook.com (2603:10b6:a03:2c6::15)
 by DS7PR12MB5936.namprd12.prod.outlook.com (2603:10b6:8:7f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.19; Fri, 15 Mar 2024 07:52:57 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::da) by SJ0PR13CA0130.outlook.office365.com
 (2603:10b6:a03:2c6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.8 via Frontend
 Transport; Fri, 15 Mar 2024 07:52:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Fri, 15 Mar 2024 07:52:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Mar
 2024 00:52:48 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Fri, 15 Mar 2024 00:52:47 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 00:52:45 -0700
Date: Fri, 15 Mar 2024 00:52:43 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <ZfP+S4CfTt2qvD6X@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|DS7PR12MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b278b22-19c8-4a4f-2334-08dc44c4ed80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5lJmj56pC96g7d7SrnDR4OrQRj8CaPjgUNNCr+O4YTdtnkskH5tg46jJ2rWTNir7XQizynj1N7iXRCrZy6MQK/Av9qN3X0mLptGBxAmVcFI7IaivMDCiBx/HqJSyhZZAAZ+MoHOesifoDWRuAgBm/Gbp0GtrOATOEA0alUBTeKatgJNZHfTFcg3EVWg55nUFPL2xxYfk0mciuImHAbbTu27z0Gyf763aWnjPw5WXBgq/IfFD/Z1sZ3QMbjgeuiGlX2v3HpgGP+Ye3RvpgrKVgPTd1w7KiHPB2hqr+IL+bUAqhrtG63ujeHxRX+ES8lXDi6WOqNgvu0dz8q5ef0Tua1jyOlmRL3O0djkudz1fMNlzP9kESgF3oQWbF/f/S7QVDLIgHaRXwEwhKn8AWf73TSIeHlTtQAAbGoK4jYhtxzlNxUsGoMY7/SQwtN+gUoqZU+oYEDoqZX1b23QSxJz+m7FueAlK9YYd1mgE2V2+7X9ffygPhjgxL+RLuqV9gwlgLY349kt7nTJkYLyFXlho2qTUxUt/AaojF5kuhyOTIw3o7byVC6G2SBq+d/aCQ3RSl7ag4aDTVwkI3jSg0CJuRhnkl2ZA+tVB6n+x83u20YcOuAXn9fHQMfU8+Cs+0SXQ9zbEcoGC5P6nwZQFCqPEEWL5shXI3EwFWjjkamz9z2bLAgWtdQF/mg8myo1VbhvOdUahlkvxSg1cOCFoQuZbnvt2P1YsxuoDBDpb/E4qNNmEkhIk+Nwf6hsbkfxaedze
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 07:52:56.7706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b278b22-19c8-4a4f-2334-08dc44c4ed80
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5936

On Mon, Mar 04, 2024 at 07:43:53PM -0400, Jason Gunthorpe wrote:
> CD table entries and STE's have the same essential programming sequence,
> just with different types and sizes.

Hmm.. I somehow remember that one of them was 4 qwords while
the other was 8? Yet now, in the final driver source code on
the smmuv3_newapi branch, they are both 8 qwords? Feels like
some of the statement and the change doesn't match with the
reality so well -- hopefully I am not missing something...

Thanks
Nicolin
