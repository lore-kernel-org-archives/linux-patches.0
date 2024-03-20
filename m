Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EDE1EB27;
	Wed, 20 Mar 2024 12:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710939234; cv=fail; b=sO21/cXqSZKkFttGJ9VhlBAlLLOpIZQd5HhuZ6XvT2zjhWykgD6hsS40U7eFkNIk6cS3ox3B14+LxYZ59a804UJYu6YiZYV+irGjmbsGIAc62vxqSiLc2l4AZt7JMrILTNnllfacPTfEms3Oj4vG4TYbWEl9qxovnodcqv/Mt6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710939234; c=relaxed/simple;
	bh=vxSiuDF2oMugJ4MrhLzzvRM0Bet05BR6VrrAscXPWys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qbpXYwcCCrKwQqWJx3NKbj9YpoUQGNDVABi5G5HaC/lF8pBSHm47OSje/HeWmOh40fArx3hl+wrRJHIYeXzQXt/f0tFdcyGOj7W8QlnttzGvqTGnZlnNHTSoVcncObEJANkXWBZkjBOI/S/5VfNlgcqgvGQsi+V9OsiZEh5Kiac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oo8PP/rJ; arc=fail smtp.client-ip=40.107.220.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oo8PP/rJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAQbMMX1aQ0qyBaXKPRU2zNQD/uWw9MD+0j8C9Ngwr60/VLhqqDW5UGS18OvhBZzcw2O3OA6YlRKJDBJr8jmOPuvGBAqyFx/cCIs7NoEY2zunh0raipADS2wNElILTPfJSHN3i/deBpqpWMyVxlQ7mhk9+4NrlI6WEaIHAKjKdtx5vKDkblRhsr6564TlYbKt4dRReqphRU5cPFxCN28dT2tmfpi+3JyXMvxQVsK9Qmmwizg165UobdgRYcIUGdiTJTQh1N6B/H9QLGhPST9+eGzIRdSKIl7IfO/hHIOfG3iFeYI8eXg5P6kbqa84T2ajMYkoWXgH+E26NEAKzGafQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OuMQYT9cxu037K9EcINjUTF8uJP0oy02O7qGibVG8s=;
 b=ZPwyontwUwUuqHi7ik+yxoAgOh74yZPpmk0SwR0pC8ntVR6tHhiHxCe5pceDmG4cffU3LYGxUEgr4Bs2qgDl3ohprX9PPH8a5OQOwSWoSL6S9gN3DmoZmfpYjz6ADiIGfUiqDeEGk1nWkRpPDMta+ByozspbKZEsJMFwSKV+wKSXTCgEv4Q8Oe4UqrtAaZedI1jddVuXfdm0lOJJ/pteBRa9E8Ecpgl3Os2acfgF3dDjc0cvmxO+m1RrL0D7gQLZMh2S7laAFnMa/5ZvK7goZY24upUFp1ezIx8dst1uBT8qH22o12nYuF2UNnE2OlxByCnfBPb0HOGUkoLvuxuGrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OuMQYT9cxu037K9EcINjUTF8uJP0oy02O7qGibVG8s=;
 b=oo8PP/rJNvmjHAJavdf0OpTOzN8CMFb/GGTIxZECp4HGvZx5UrmPCDPPeXwZYHmez/MGQjyNDT1iVECcu3ibNJjVmsbwCPMyeyzDa8QFW4bvPxUHI2W/HjgqCuRVHL+C7DNxa0zjR5wV2wSYWjxsSyZznc+FelfmxxRka0/chEKQtnd+XriNccBVXYPz9+VwRt6DxM7MzezRmbZE4as09Ko3K0jObAl2SNTWra4Hh0KNphETmZmqaK+OB6IBwzGgH0lb752E9rLvKF8d6qYIndZw9wSrHTBLFRe+36PbAG6iGxlLZdAWRCe0Y4kL3HG8dR+AdBGBL7TIGPOWnoRvWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6658.namprd12.prod.outlook.com (2603:10b6:510:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 12:53:44 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 12:53:43 +0000
Date: Wed, 20 Mar 2024 09:53:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 15/27] iommu/arm-smmu-v3: Add ssid to struct
 arm_smmu_master_domain
Message-ID: <20240320125341.GC1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <15-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV24fgg97mpfiTfeppUEPhSDoQN54BG0GRNi1pw3hDdBeqw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV24fgg97mpfiTfeppUEPhSDoQN54BG0GRNi1pw3hDdBeqw@mail.gmail.com>
X-ClientProxiedBy: SA1P222CA0036.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6658:EE_
X-MS-Office365-Filtering-Correlation-Id: 353768be-74aa-4073-2d7a-08dc48dcc5f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YUH+j6424I+MJMArkuVzkD3bykPg8oKBhtpq19zJM1LrnQX/JOefV9o59zn3Ekq1yqXhCOp14FaKryBZ/YHrE6EWd1KaUFbF3s6EA5EoaYykhYJPybIBYuVTv7QlzSE24VIMf7qUThH790AmI7Eswc/B2kCF5EMSm0eG1Q5EDyyCIZJSIlcwQimmC8be19vOIDWPc0XW32MJ8Nj3uoJ+GlrUnYydi1vvydEuYZgjndItNDvEle4gdVtK1XMbOZvMZKRgJ2/aVWj+JCpfqwtYXEAGCfq46bsJ/JSijBgkHtzYbLBik+8L3gZBSYvWz0EGbktVJpxg7cQjQoV8dpa0ED7OOyA25C+iUE4I17kKpiL3v2YQzrKR0ZEmvXfXJEeU69JcOtZHpiCVI5lvyazhRVJPCJAznc6uDaqkZfsHgAKVxrXoQxYchwwCPhje7xNfwPF0P6dOeKprVHaKIOaEgDAo2onJPS+I8pJWZ4lCosouyqlbMK7s775BjOpOrR0NcVtp1Z7DfwsQhIZ4ZXAoW0TGAUclRiq9xguxgGWz7DP2Hm/TB/xa/ZbJ9e6mcLs49H0B1/AJkIqiDln67T542HUvs27eRYsZKlcA9sZEzb4JGOW0HgiVp6j3DuaGIqZzXKKB+QvGSMddwRubpAZh6w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JgbiNF/pfHMKpC39EmkwqHvmOiUnNqKUGXajpV6H7iP9457Kt08X2m0k9KVg?=
 =?us-ascii?Q?nDD/nC02hCdnikO6cG+bD6HkQ/IfTG6Prh5VMuco3Wm5I2QlOvVjfZwLGRgz?=
 =?us-ascii?Q?X9yG1eo56v++hT+EUueDNSWSlZH4d9HP6UvBhIPoydio8kSexpqgkRWKxj3t?=
 =?us-ascii?Q?FpUKUQIqWUNV1/kJfno3vRlp50ugshjMo5FPD8zKErMcfDiEEPDtJ5GJJhIX?=
 =?us-ascii?Q?SQ5r50YPzYX94CRhYhRLNforwJQcVJYcJin4Zsaisy2TSRsclcAnrR7fVVs9?=
 =?us-ascii?Q?poRI4MBSO4KpQh7QKKXNwKOAfO/jHpMDVqN8p7D3uv6MymRg+cbD696PQqvJ?=
 =?us-ascii?Q?1W4pp21GV80p220kdjNWm53FArzYNUaAr5mX2AgPKOhdd3z3U22ezDrRYATQ?=
 =?us-ascii?Q?wpwlMGbO598R0PAhBoMEhJu1zINJ52AR4bGlLZUx2wn4Wb99iJCpCA0l0Yn8?=
 =?us-ascii?Q?6U7F8q9UM6lnymAXfgnMq56mWKOJdzIIanvhaMemScjVoqO04xAcdtKn1hu3?=
 =?us-ascii?Q?gMQGdPYq58gHlY47NpjVF5jqlIUophXaYcAKjAXpjRroBiREuE9inYLVYt8n?=
 =?us-ascii?Q?SGmakTPSXJBMWIsnZnbjnDkplSYY4WAussxOPPTGn+U7holPxR2nHiWWcBZ5?=
 =?us-ascii?Q?O2XpIy9e8L+CanZo6GRoDlvGioO8wYmCC8Q4RZG484WoRK/JCShcptcS5hCC?=
 =?us-ascii?Q?u3P5v5QDXg9juaF2M15yBfavcFutHOftvgFgyFTmsV6mLmrg0sWLeQDkEch9?=
 =?us-ascii?Q?UfT/Tn8lzYmW6XV/4XU7BD7caqAIO7p19ZqwR4D6PofKvl6xI6l5JnXFg3Kx?=
 =?us-ascii?Q?9lWxP89DtjdsuIEGXQh0+yxpDzS+WkD5vCWswsGYbzZA4glxsYTR7hbdG/UV?=
 =?us-ascii?Q?0/K0WGwOcs5veRmllWZ5mIetifLCz6B5i0FIAuODgl4bj3Tdsz5UlEr+In7I?=
 =?us-ascii?Q?mqbPGDKKtdOERi1JvlYc6yDboL2CFALA1Lb/2eJjKYTaVM3aLKXgyh8YYIYQ?=
 =?us-ascii?Q?yqBzg2+9GOUe9mw2e8jQXQ1/vbPy6Jn//SMao2OUDgWS44NaVnNJ/HvjC+Ot?=
 =?us-ascii?Q?ZMDYCDFOLxZwM15Xe/3/34ieglwkIyIPLPF5wG8VhWdL42P/iVk2DxCk5UHI?=
 =?us-ascii?Q?g9ZEs1ezoiUH1q87YSxCoNoNrx3ZSqTnVNh9rEkPlNVmhOflVZ7Ouv3mNK2u?=
 =?us-ascii?Q?XofxZCxmLj7kU+tG4oxLgxT5kERe8GRdybNaaq0ii6NdxWVkfSaNA/arsZ23?=
 =?us-ascii?Q?jefALugl+2mOC0fsRFOTahGL8mtk2ePwxyg7R7kmXEYYCC/Vj6E+0yY6RH7l?=
 =?us-ascii?Q?wVLdRXLAW1U/JnwPDyDsN7CAdAT+/WaXNTTzj91nEOgpUkP9TwbGpgB5UVri?=
 =?us-ascii?Q?uBY1oXyRRlVCQVsisDSTqQWESsxqrl4ynEoTB7pHuU0+JKZ5Brsa6i0YqBjz?=
 =?us-ascii?Q?37pnLOT57apNiPf0R1bMOUmNOFiceWzbFlV3R6mKOEIngr2om/er64hnEmKE?=
 =?us-ascii?Q?ACqV2XKoCy541UDMiCM7lvKZLmCq4SgGtG5uV7Q/rf4JlxZGkRwQSUurx+o6?=
 =?us-ascii?Q?2+9/B+9wYFFDAFIuczZVNYRgIMxEzjsfj34aTjYQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353768be-74aa-4073-2d7a-08dc48dcc5f2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 12:53:43.2005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mfSxKICzQ+IqoopC054O54zi8toCqMyn4sU7Qh8vxB6Ulpf0iCaebdyC7AkL48wo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6658

On Tue, Mar 19, 2024 at 09:31:17PM +0800, Michael Shavit wrote:
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > @@ -738,6 +738,7 @@ struct arm_smmu_domain {
> >  struct arm_smmu_master_domain {
> >         struct list_head devices_elm;
> >         struct arm_smmu_master *master;
> > +       u16 ssid;
> >  };
> 
> SMMU_IDR1.SSIDSIZE may be up to 20 according to the spec. The value
> read from this register is used to populate iommu.max_pasids as well
> as to compute the smmu/master ssid_bits fields so u16 is insufficient
> here.

Right, that should be ioasid_t

Thanks,
Jason
