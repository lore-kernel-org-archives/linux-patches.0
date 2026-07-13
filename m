Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010006.outbound.protection.outlook.com [52.101.46.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1F33E37A;
	Mon, 13 Jul 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783972550; cv=fail; b=Gct+5vd1bYWbF365dXYwq8BzEt7YVegcJCEWd1h5IcZl0FmLVMZDTjyxtwgS/xW35bohWYrcvU+PGZXRUqMS8JFab5bzVcs+VwloyWozzsAw7BZih6dX0fJxwoPMwzzNLQubBHfemqZyfhxoAiZbMGuZLklWZOk8cRV3dfPWLWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783972550; c=relaxed/simple;
	bh=VFUTuLljZdtY3tot8xRzkC8wWsKCNzaX+mwUcrhaSto=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mrswz/s/l8DrJ/4MmGReIaxIHZ2uesdiQQjqt1JFRgn6nBjK0b/gf8MV/qy8CC1F3XDRWvsZadN7+FVs+F0wOKfH2MgVymIvazGqFhqUPXVcTj0GEer/DapUYSxMam2FwCRc9qpxjtD3ON/Z4ZmN7akM6/SyBDbxYNVyvhBQBp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sqF3r6ZN; arc=fail smtp.client-ip=52.101.46.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sqF3r6ZN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAXHHrn3JaFDLfFmh2iGMCOm6cyX9XLY4mr3NnG+RsMs0mcE6cehOoRAv38fBo/Sjh11TV7TVk9TYJxmR4T1laa9t7QsgVBSIedNzM0thiNfT23rZ8DYN69gv6+hZxRwGOCTdfkpx6aU8WtVTN9fTHonqU+QSvpviTTbRSDBYXWgkGw/whVqW7mZX/bMGj9QlrutSwaYCpx+Wl6rLhjsv2VUfYcFzRcyzfD8cnhwnGxvhHtiESHMEuv7vI/N+5xDO5bshhxdPX4Ekg8bNale9+zJlbchcZJNAKNu8qxs21yWCe8O4hsmmLwficpdQ8PWwz1WmSeCEQ1oTTTP4SUJsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2Bh+txTBN0DRy4IHblZ38/2cL9Sd+zIlrTnqdR0njs=;
 b=KskRbwMghvKnYhFDskae7pcAiQ1GSsgEsReVHsns9gmsyOLfab/Ezw3YUpljTN8O0Zet5nn2MdlJT8/cDjnvR3exfa7L2vjVn6xs+v7kQS553OYlLgECMAoRq8g2H4vpVuiwZeaOqtJjhY0+Diapm7GfH2iAihJls3OFivffMeLeGe1dsTLBaAI6Hi7jYeGxQdwwGPr6NWnDwZ9oYHkKBr9tqxlcB/ZRZHuwZQuVH4aAHluzZd8VXNLF9JpK5A2W+Nzozq/09OSC3pXqqvnjQ95KF6z23v2l3bQNozoLpYfCCSZW7PEz+Pf+jre4crG6eipizH6BAk05w0zgtLh3/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2Bh+txTBN0DRy4IHblZ38/2cL9Sd+zIlrTnqdR0njs=;
 b=sqF3r6ZNhZm75cYFEF+vVgkWA8log/mkhcRDGNKhuRuyF59RwFDlv0PvGkaJWNwyi/x6SIjqICTBDUSXopGeBEOzE42+PAn6btGg9ae55Tcmw/oILHyrnyAPGMbS50Il/7fmABiA7Q9uK3eOCLx0Wc0IBVBX1tYUk/xXIIHdCns8210ZlEZic1nc5RIwIpm5oDrFofoO43rgeYMC/0es89nEUqn3MmD82iFs2JypQ+1Z0gZDChRLXxoCv0/mkzkcKroDnpfnyOlNE7FvjaHl19tEzgZsP02l3OqWUm39d5bgbq14mQEnvHVNTEYDqO1upDnl2pMS7nRfKk7yLo6iSg==
Received: from SJ0PR03CA0294.namprd03.prod.outlook.com (2603:10b6:a03:39e::29)
 by BN7PPF683A477A9.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Mon, 13 Jul
 2026 19:55:44 +0000
Received: from SJ1PEPF000026C9.namprd04.prod.outlook.com
 (2603:10b6:a03:39e:cafe::15) by SJ0PR03CA0294.outlook.office365.com
 (2603:10b6:a03:39e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Mon,
 13 Jul 2026 19:55:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000026C9.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Mon, 13 Jul 2026 19:55:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 13 Jul
 2026 12:55:15 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 13 Jul
 2026 12:55:14 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 13 Jul 2026 12:55:13 -0700
Date: Mon, 13 Jul 2026 12:55:11 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>, "Robin
 Murphy" <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, "Aneesh Kumar
 K.V (Arm)" <aneesh.kumar@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	<patches@lists.linux.dev>, Peiyang He <peiyang_he@smail.nju.edu.cn>, Xu Yilun
	<yilun.xu@linux.intel.com>
Subject: Re: [PATCH] iommufd/selftest: Simplify iommufd_device_remove_vdev()
Message-ID: <alVCn344G6l2lYXe@nvidia.com>
References: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C9:EE_|BN7PPF683A477A9:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a1979b1-5d6b-47e7-1791-08dee118b97c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|376014|82310400026|13003099007|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pYLNkWqFvDKEdb8rBbr3ws6JXgGPaqlE/NtcSlKEZPtPWEttEFmwXmH78iGWy5iKdMlr28/xuAicGVaqczSeBjK8yaBdLB6kbczfnpMvCHOr6sjPD59gsGD1JLzOjQzXOg1rryKV4iiI3Ts1EnYpcSzrFoW9WgmDCUoo+1mc1Pc2Ct7W2XfIDYryzvRo/mnVw77tt52hyLAbBZb7osUuAwXESYHLRnqzS2BkxLQxs51dUKgw7B/WRewrGS9LP3+ygl9TE9J9JP/7bx1eHIx9Kk4esY/EbWCltOnMYpFFPSnKAADgPuMeiIzsJArQovHjEkwWXxqbjSBm0VQnkRhndlmidhz8ts/DjSpd0HX1fxX6i2qMPY3aZuBhFRvIdw68MXfim51p/m/AEE1uf8v/NSNBjGDu2QhQU0w/F4K8bdBTyOeL78ZDjM5byWw//PgvdosID+PcH5H81suxRjZ5NOYlCYhW/xyZoW9URWSGTDcHbpk/YjbIZWytaa3mvWCUlwrV5h07k/AbWw+mR23F8RrmStatDSSwl+Ahxdg5+6oe5/WnVzYtnNjVJ40iHvrGij9r2i+jwfGpaXt9N190HXG7uobl54QFNHPs6VnWnmu8qdCu/lbTMHnB0+CSKyp+S7afdp2K0NwwbrMqt3Y3o83IkVo5P4SbuxLN8c3UrZjklRgifTiym1K7K1v71iX/7pyVEtwxEyRYS6+LwAqb/Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(376014)(82310400026)(13003099007)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gCroAxbxLbzuS6UDkcdlcQg/jSKtWtudp18Rd9fFqQaXk2jkrsfIUSRvuvuoXdbFVYP8mm/0DfAl+eFewVZmwf533D/ZJw3d7JzmW8x2kDjJ43h6ivL/Oi8zfHvqnBXja8uMRj45Pm1wroUrC4SI7YvB6jj3plrFEcTLPulS/RxqQkJLcvVy46bny+1QlZZ1oSRambJMQeYw2kcs0wYM5fQUaI2tJW12stbQDmJWrbrG8bAiN/sPkVZ5EZdx/K9ujG091+tX2HmW4XRg4LLjqE+SaFBupmtyO+256zCTKTlY1/nwP7ZahNvDmRVkM17ERzamUV6dm4r7ZufhHMVDiQnvo3yORBcSfr6xgLwiJmW5X4uYhT+dSZW7/Scw1Grij30ewPuowoA0tVq+g6ykbSC+Ii6sIdFwOHiXaoFXYBk41LBYuzaGrxwP/lIpCmi8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 19:55:43.8217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1979b1-5d6b-47e7-1791-08dee118b97c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF683A477A9

On Mon, Jul 13, 2026 at 02:25:11PM -0300, Jason Gunthorpe wrote:
> Peiyang reports that this function indirectly includes a fault injection
> point through iommufd_get_object() that was intended to cover the uAPI use
> of object IDs, not in places like this that cannot fail.
> 
> On deeper inspection this can be written using a dedicated helper to
> obtain a users refcount relying entirely on the xa locking instead of
> going through the whole get/put scheme. The new helper doesn't need the
> fault injection point.
> 
> Fixes: 850f14f5b919 ("iommufd: Destroy vdevice on idevice destroy")
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/r/870BB9ADBBEDDD1A+37c5bfab-ad32-4fc5-a302-57c81a8432b5@smail.nju.edu.cn
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
