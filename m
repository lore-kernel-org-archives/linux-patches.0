Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1842F433E;
	Thu, 10 Jul 2025 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171740; cv=fail; b=cm4zuun0pAl/5iJmOWt86Uq7D19fT2mWR5yfbBWTMy6Jeq2h9trYDawfjidL+PwCuYnV1iywwJcVszZWL85tPltGZ4Y48w4s8LroTDB10n3HnBh5XvF6swYoLol0py5OMZlw01BdP4EULfYKocn5CMDSPgvTUGwXcPoIAzNLV8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171740; c=relaxed/simple;
	bh=fYmzWogEM+VLti8zKa1QiDMI50xC7J/WwwNFyZX1394=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+q/DgoLsPnB9CY4Blr067NGUnfEgxUI9HXeSFXZreCrrc5P9vDGmOja8tEcYfnle3OStBRlpNjaN8Oa3Y/rse+ZGATFuYEl2nebtSa2WbMqk8klUPqongGwcnyqa5m47XATMm31i0R020JeqSyO+wFaP2diUsLarSpSx006Vuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O/36DwfK; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O/36DwfK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RA/gXhpZj3BU3iiOnJDHy2H+LTfH/n0XSSkSrbIOAGcYCzL0l6pjyXTAOA+DVYZu3xMjlNEQYyAfocQzNTk+i3AE6wWdpEZrr7uXFDZm4MzK51f7uhky7MlBfdtl6XQWyuAmiBuSg7gVhv8SCOG/E3AjLXc1FQyRGwad5zGVnPdq5PKuepchTL8lvoQnQzUdjT0m0DorMu/VTYQfC/FoubNjW0qlv+iKnaoTxvLiwUwwIYOU2djIIK92HO5DH4F+VVMT+fAkWMQgu+3lHM5eCu2FSDn4Zr6LKUo9jjYcOG8cvaxFrYqXHbP6+ctT40l2lp5t376VLC/RX44Yrtn3fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gakyte3kABT5zH9O9xxmnRysibDMsvl4FBVAP1uw5wk=;
 b=khyeHgwhu4oLel6OfVDN9I0VczTpgs8XsNyULGE4skwEpNdc9I2/EcwDAd1iYLnq4PiJMOsGpbAUiUf8rvGv8KENRQBg1W8hOOy3qeNR8D9cQ9E+9FQEgjqoIQpIA+24QmoDaHpQyTq1LtYN++avSCLyPIa/A2gqDoMqVj82vbLgBbLGvM4GeOKwSbviXxON3SfWGk5HQGFd3DHvcDBuQfq+fBUKyksSjbDUP8Nx9Kq+X9eeTxE2NDqMoYe/guIKl54mBxg2U0/ezL7BoXShxhKvL65GT/0xKTjW79yEnOAtHVpTD0V+s5sBB0W7grJGFTfRGK4vHtlwTxk5hnD7dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gakyte3kABT5zH9O9xxmnRysibDMsvl4FBVAP1uw5wk=;
 b=O/36DwfK98tE3HTX16TZoehwR967KLQXEzRx8Nw3NzLuhKvOBItMR/LunyIsi9Gr6AZFbAKAcVCItXoKrgEumqVVc+Ope6PAFMQgARh+4bj+mOtGqJp/p+fEb6BnPL7W/K6srAm0nwbj2XtF4U3QJOEFkbIPP6QcFS5uANXC3PtmsfdJo58pJ4dgPggqfOPqzYfUVP7av0eJDUI8/n1E3dAGH3R0woWMzFqc0u+jXi6o0gLOzHt30ogqyR8XNpz2Qd6RiOvQ3qdCzOAjB0/XEiIEsyXmxbFnqP6E5w3xdURvQzBTlGCcwNX+P0I62+FWEdXRwngmGcJ39BvG85i4kg==
Received: from MW3PR05CA0010.namprd05.prod.outlook.com (2603:10b6:303:2b::15)
 by DS2PR12MB9589.namprd12.prod.outlook.com (2603:10b6:8:279::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Thu, 10 Jul
 2025 18:22:12 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:303:2b:cafe::18) by MW3PR05CA0010.outlook.office365.com
 (2603:10b6:303:2b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.7 via Frontend Transport; Thu,
 10 Jul 2025 18:22:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Thu, 10 Jul 2025 18:22:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 10 Jul
 2025 11:22:02 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 10 Jul
 2025 11:22:01 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 10 Jul 2025 11:22:00 -0700
Date: Thu, 10 Jul 2025 11:21:59 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"praan@google.com" <praan@google.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v2 13/14] iommufd: Introduce iommufd_object_alloc_ucmd
 helper
Message-ID: <aHAEx5fWopk2ndqX@Asurada-Nvidia>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>
 <aG3+s8rzcjeKazG8@yilunxu-OptiPlex-7050>
 <BN9PR11MB52769CFD429C3E8E0918674A8C48A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52769CFD429C3E8E0918674A8C48A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|DS2PR12MB9589:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd27d45-4e0d-4c67-8232-08ddbfdeb096
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2xWfeQNam20XmMv3OjbIljTUFEcwleYGpWSqsX9oTfYVle8gf1Y66wiFV0Pd?=
 =?us-ascii?Q?m9tx1q/dn1rfOLubCNu4hI09vE+4FalzaVVWi55yrCNXCbQ0jixwpLr347B/?=
 =?us-ascii?Q?jIU9LTgENwHKlNQ5uIbe9pES/mEjl61ks75LSEJtz2WVP2j+aSwMrLp94CWe?=
 =?us-ascii?Q?8fp0KZ6uZkOB2h6CdIPyHGEWlkTDzo8oKeFqZXRevKN2QL4GnQKI7OUAuBX9?=
 =?us-ascii?Q?AIFgopfC1vf7+mDKaaUgE4CK2SjJGmogTCSYyCNiUTHaq7DfS+sUd9Itg+2d?=
 =?us-ascii?Q?ANKo5aA8k6TNEO89iK58CIJvhubzXkfs1GAUYPoUeBoDJ72kj3nDokYdErdB?=
 =?us-ascii?Q?xtMfqIg4+j12TJmN7uWAoHliZsCnu5YOFEKw4jDE3ycTF0hkYl2tHVIccts6?=
 =?us-ascii?Q?Ao5/UmzZvBZlWkKm4yVGALlcXefp0QgJuabVUmdWQwLjfhB2Aoamf6LzrSFc?=
 =?us-ascii?Q?K1L9fM7BRAscLZtAdZjwXtymMouGMGDjmtdHarqM78YqQrFi72M6WdrizIhY?=
 =?us-ascii?Q?wqI92I7hlUh0P09s4vMt1Ra8vuPWj16UCslyHol4NWjEKI1opBXwPzpWzFew?=
 =?us-ascii?Q?rG0gLmPccxIBZYt1f8DjeOhex+7EZgm2ou7NUrxhdIGs9S/b/K/+96UjL0/T?=
 =?us-ascii?Q?NHLgUq5pzcVhNPJOnFisAa69WkWj4/M+fXVSov21GnvnnLAWdhOqQCWjCIDV?=
 =?us-ascii?Q?jZbLQ2zjsdCkGjbDhxvYOcXV9khmNB5HywBfpn47ZuLIew21eJFZv7bRKDpm?=
 =?us-ascii?Q?xF9XV+LuYbXL9Ce1nNu62PmQB0RVq8d1DBN990FUaluA+jQrNPRRdqqEtAOS?=
 =?us-ascii?Q?fo0EYvKQawSkHlRK+a7jprwCeoplKEIlFYvfsW1ZdBlacfWjfur2zxtRhevL?=
 =?us-ascii?Q?mrtXvMsdQWbm66SRu2obrZKW9eSI8h6asxY+ao7PcNJH6DBOX1kytb8olLJe?=
 =?us-ascii?Q?Zyq9CuCDdgKaAdGJyK97iGhuPI9TF1udO0rRCMT6QBUaaN4nV+/McDvBi5Cd?=
 =?us-ascii?Q?Add7cIo9ztujEhffCGkz3PetXTQgGV3iVexefQo228njAaK9Y+s0FR0dn+h5?=
 =?us-ascii?Q?c+7I/q5yatF7+XMlEJsLV7q6/Ult1uLJdVb6/A6sN+n0X83+eUknTRFGAAy/?=
 =?us-ascii?Q?CSEnMM+S9ozvkqy8eV16gSpnFhwqHIGUVv3tngE0qZq7dv8q6pGezvU2f6U+?=
 =?us-ascii?Q?R9pSFQELkECx4rWU3HXZr3VAH+fez6YGf7Gk5c1cg3qCUZ6YAP/rAzSVy3M4?=
 =?us-ascii?Q?biJ+Eo0yvMvhdj4fAVh83J9EYvmBAWuK5ztSz12hh9VVmiv8iB4CiKHG5Q/T?=
 =?us-ascii?Q?EqHy6mYVtfiUsZ8p+MTQHf9sXzLMV3O4w/lXIZe0qssrSSCbB8AozlD0POr0?=
 =?us-ascii?Q?trEamuvKzDYnQgI/lB9amCMI4pSVTJQUPC2BtihFtQ4UblqS2tyrfhixry6o?=
 =?us-ascii?Q?wa4ABZk/XcVFiSUeXat5OyXlP3fws1mXwB/+x99sM6XFEErTC1gqGuJNsW7n?=
 =?us-ascii?Q?dXobb8u83dKD0NceFDABcel/SiLq/qhJQ+MW?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 18:22:12.1986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd27d45-4e0d-4c67-8232-08ddbfdeb096
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9589

On Thu, Jul 10, 2025 at 05:32:13AM +0000, Tian, Kevin wrote:
> > From: Xu Yilun <yilun.xu@linux.intel.com>
> > Also explicitely assert iommufd_object_alloc_ucmd() and abort can't be
> > used at the same time.
> > 
> > in _iommufd_object_alloc_ucmd():
> > 
> > 	if (WARN_ON(iommufd_object_ops[type].abort))
> > 		return ERR_PTR(-EFAULT);
> > 
> 
> but this check sounds necessary.

Let me send a patch for this.

Thanks
Nicolin
