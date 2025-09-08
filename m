Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71161F4C99;
	Mon,  8 Sep 2025 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757345772; cv=fail; b=jwYXK/9Cj6tXc+mxO0rQvoUowECUEK7vdY4wbEFZjhd7NnP9M0D0kMVw2YGPx+ev4U7zgXGDpi2xh/0fmO6HZG7z9gQJZrYUQOrkNMyk5HsxllE62kFX09qto0pUTov/rFaYQH2skXWU6mFnnxKVJUvcf5klcmpih7CuOk4bpZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757345772; c=relaxed/simple;
	bh=ltsprN7ID4FnXifLZ0rw/GR+p0HHzXN+5mYETwp7438=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XqH8Gz+32TGePpXXV9wgZZJQYk3HL114EHYuTe+uBX+r5vWuNIAoCJOQTHq5jpIbQePRc4qScoRKVXzDS94mUPoJmOSgTsi/FQpYwILa5NrQXu1HTLjWCu7+Vk3I6h7nFBCIWjkTp5hdZyRzcq4Kvh/tvdpVRS+CDZw83R9lvv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nsSfTPCF; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nsSfTPCF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVl9EJu9XiCgsi+Qbt1ag4iS6PHq6tCeIH/bUKNRtpuM7q1RDsoQ7UNcePnvqU2qs+U72yPd9pazcOQa/b4U2xE7hbrC7RIU8g1ERn3xveVjqpxKVtpf6xwjA0AaQtyrhdzD8wu4pkVaA25KE3RbZjBhsW1aBMpPdqXNjt6BI1C+KTXw2XSjaIQwCWNYBeLHZ15XpIhRTpM0onMx/QXlRy18sqfpPMCCoc/es8rCA9eXay3IAWjeRTKLlt9Uc6QedpKJMGQ1UyTYfi4F4KgIUa0NkM0sG34jVrj/I01F2ZXxypAfc6/bHQq5mouTjiRSaefh/8mUebN13sCTU3Kj9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAhTMtl4QhwrnpsEulXBwzvBUBMT8F32XlXR89f8he0=;
 b=vBO8HDJMwVK/RIWAI/4+oU7BGmD/MPY2q6qdWf+cxm2c69+Izn5trSqCuYLWUpJ3R6gKwCbscw3z0qB8qaAMoB/E9RpaNgA4ObRDzxubKmw6t2IBUnMjqkSKI4WOtFnkZZerSkpKn8M2zBcSqFmcyWhzHbHR4Ydq+tEFx64TaDMPL/j8c2ibsVg9JkZkmIUq/z7VduH7hWwxoYCa1j5gVMtMPvjm9+4p7j+Dr281GT52c1lILd6QsYvdJ2C2C/Nh5cgNbTxaeIp4/awVDYsws3VKt7GD7JHptEcwlgpoTnxzYvJGJmYmzQodx5NGoH25xalTx6F4nQzkCbhUiC5G9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAhTMtl4QhwrnpsEulXBwzvBUBMT8F32XlXR89f8he0=;
 b=nsSfTPCFGJOKJecpnGLQhKgJFKihNzKaRstDJIV+wj8/z5KDmQaZ7F3znnsSkg8C9L2k3bBwF614Zrk/AcNf+eEsDOEBRaRvVbnaE3X+XF3yMkcAdehC/D5VWliD6yRfg6i1Af0fiJ1e5ECW9nzdwmT/uRK6JjlDljKJ4izRz+9oSKJhRJNbmNMQrnT+zlRxgZ4SPtNA1EtSaC3WzxMaSmdpOF2elvqzcKM7/aPL6HdjjFGmhn9LOToEOSHJ701iMsHyXF88T82RQ5SXpnyfpovKz4PB/vLqY0GxSlhbTNVwb1rY4AWLqdv4RrHzSCC7f7TCjTQz9e4/fsePgZczXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15)
 by MW4PR12MB6851.namprd12.prod.outlook.com (2603:10b6:303:20b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 8 Sep
 2025 15:36:06 +0000
Received: from BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2]) by BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2%6]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 15:36:05 +0000
Date: Mon, 8 Sep 2025 12:36:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 5/8] iommu/arm-smmu-v3: Pre-allocate a per-master
 invalidation array
Message-ID: <20250908153604.GB789684@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <2b55869f698340d5791210b9a7e542f81ad20bcb.1755131672.git.nicolinc@nvidia.com>
 <20250826195641.GB2151485@nvidia.com>
 <aLvmgXW8BpAyXMVV@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLvmgXW8BpAyXMVV@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::22) To BL1PR12MB5753.namprd12.prod.outlook.com
 (2603:10b6:208:390::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_|MW4PR12MB6851:EE_
X-MS-Office365-Filtering-Correlation-Id: 4224be93-8068-47ab-02a2-08ddeeed6cc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Sltn51kZL08+9x/JDBZwanDkScgntWmCIF1SRsHPCDwk8P5yc5RYqMBJopmb?=
 =?us-ascii?Q?x1JVpii/GZTox7lKD2yy2pWR0YKpxI+kZ9A8pVb3Le3PrKLX6/TisnbOoN57?=
 =?us-ascii?Q?4y9jWwBgHpGR83p5pZpHA+Adi/weYkRaAyUMhwbdP3nBpWN2Sh0hs/3zqfbe?=
 =?us-ascii?Q?zqYr706R0lX6o83EuGfqsk9v8rFDoc8HIz0tpToGLyIN7UR4mvUxsVsa6s3o?=
 =?us-ascii?Q?1dvR3styxxHZHI8BKaDDFfAfEq7+nd/GaJYzAp/OQ/J2f66pLobjGfVblNmW?=
 =?us-ascii?Q?ljt3Y5Q1Lke6E0CRZH7W2/b9MaUoRDAKjNG2gmimjQN82SpWVEfiO77MXSZC?=
 =?us-ascii?Q?qEc2cs4xK/5TIuhi5VgNJPjGw3zF19cqnhunxANtymsONNQmKK3NY18eMpqG?=
 =?us-ascii?Q?HBJca5i3/9Vojq887/jZ1p5QItiCXDc2Gz6RN0gPbd2X2uFZpARCmGQSnrH3?=
 =?us-ascii?Q?fYk3ndGbkN2GMB2XH6NCmL8ADf08A5+drKhFwVWAdqO1BQNpKa56IKfXAZj+?=
 =?us-ascii?Q?7QR7DfxO9YhYxFHXLaqxx12uY9EqINHcO72G1ddmjbZosVvo2fYF4tZz2lLJ?=
 =?us-ascii?Q?V+wl9dMI+eU9hW/GaQtHiJIee++jprqhSlJXbhdatfwMhQ7HnKRx+lcmm3wB?=
 =?us-ascii?Q?O/piTAeNWlaaaW//R6LRoRCPoccEhOnaVhq2500DB4oC6Deu2g4IsRhgOmg0?=
 =?us-ascii?Q?BaB6BEP5tUHfhcExXX9DqSNMCb4L+Tpmtm9TAHUEHWAdgBy/s+jLVW4udOtB?=
 =?us-ascii?Q?Lh7xymF0p64L1T2fYrR+Nz808A1hSVgkyx/Ma4tR4+0YXyyrhmc99QVEU1DT?=
 =?us-ascii?Q?8MuNxa3kkVvJ3stz5JRuB8UQ55lSmRsymJOVvRAlg/B+QPZTZQG8tCmInwAS?=
 =?us-ascii?Q?hOc7bO0tC9f9OuItT7/dE9GRUhYiVNUPj0gC6EcBgaxxR7oP5hC86K4v1AYZ?=
 =?us-ascii?Q?oLvXgSMkh1lZebsVHn79c/8FV7jf1iAvHs4jHzhfWiAH5sKgH3vTgfa/MWRk?=
 =?us-ascii?Q?YH4L/oJheuSCOMiuWJK0+DcERB+/SBpW1fEsbTX4LCX66C7Cxs3wqVuClKIm?=
 =?us-ascii?Q?LDG/yA8IaMwi4Y2hu/+ef9wIXF5ZUN6yr3x88lE5j14E/osnyQdCdJviNHlV?=
 =?us-ascii?Q?U8qAram/d6rxc7hQXNuaZ6Zlan27dc2DpnwDNInVzoP0x/Hytp3cARI/iJSG?=
 =?us-ascii?Q?NbD/li0bmYKKmSueWdV/UbXzZpj+rWuPKia4218N3YBya/0zc1OJdiTYz5Vn?=
 =?us-ascii?Q?qf3ohTAxMrXRwuGECntHf6fBhrhX7U3yxDqmFyRCDbzlCl8pVBAWC3aA5obt?=
 =?us-ascii?Q?tivfH42PpO6SGsWmLclylyd7bNaAu+KqGe68jjb5YDxt/KnC7N8M2Lwya+1X?=
 =?us-ascii?Q?ILMUr4YbiJPffpRcYfDOavv91fU40aangl++N5HhJ5SSju/v9lKJwOwqMUNT?=
 =?us-ascii?Q?WIHvDm1/v7Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0dzwkzOrOGS22Ap6YZWwZ0mjR5ES0V9Ejy3T5fRv4QOBSCV2CS4W54DBT/wo?=
 =?us-ascii?Q?eku3YoDFPhw5RAbf6mDY7JLURGpDyvELIbvteV6xNhiAyPnFPZ7lhfkEh/kO?=
 =?us-ascii?Q?6yVXO0hL7ZOU1HcwrY3/E0etQbjy653kfl92QWS3U9vjecnFvhRj/58dJug4?=
 =?us-ascii?Q?az1/KgW8Zp/nXi5PG2kmDM9YizQWh3FUf/fj6+TP31oARMHTUoUYyITbrBl0?=
 =?us-ascii?Q?OUvjo2HAIqeCo4SkOT+JhWq16aWmb8dKDFWsgq6+JTqPcDntL1krHLAqJsnu?=
 =?us-ascii?Q?oysWFT0HbqJX5XqrEcq6Cw4UaB9Qbs08GldorTMUB2Avqi4Z1H5l8xLlLh/9?=
 =?us-ascii?Q?JKevrGirbvDWqbx3UT+UQVgBCCqRYg81bkN4m4nX9eYhdEOc00BGSL+TscL7?=
 =?us-ascii?Q?1mTp9Dop6P8973Oktpt2xu/LfUnknmcTgY49sJrkIz0W9VuBt+vpJ3uY8GGI?=
 =?us-ascii?Q?AIApPR2VOjLDUaRmloAG+VNYk17Wuz6yc6Q9Owy2X9k/4BNMYngeRlv5sWR9?=
 =?us-ascii?Q?WQfVC//iS22MHMGqAgANtSO3zxc/Fb5LdHdmjrBYiHFuz+58KMPZWHi8snkn?=
 =?us-ascii?Q?9rtFx+ZFRP8dGWwepRivDDGfBCoh0mOy1Z3OvgLi4hd3cBeI/4/KxLfUE6PN?=
 =?us-ascii?Q?lV3nage4+zyCPbdPRy2cZNm7kg7hJ4nszk1QfjDrRnFvcx/o0ejRhssHuhZ0?=
 =?us-ascii?Q?RSOoSCmP7SQjvdriBcUtPneVgUF/v5Xld6T+PYZa27MMRIRzjC37MeRcdx9l?=
 =?us-ascii?Q?Y7LL71+R2FHncxvdEt1ypYCfdaAQtvH/POa7MK3r26glTrL61GPO0S7jznDu?=
 =?us-ascii?Q?T6pLuhJmXaqTIDrxDitSgWdKzGrJTtovLEoEHD1CsiUNumBb6/pdMrfxWG9Q?=
 =?us-ascii?Q?6bhwEzfWP9N/uqzH3SY7XdN1nAyzboApVlOUIR6Rla9GjAx1MYrs5w0eOmE/?=
 =?us-ascii?Q?IIjOPESKUYGKmrFfTdcW9+d8rX67liNg1JoGfKjSejoPjPorqJ4UJ4HHn2hp?=
 =?us-ascii?Q?U7fGuh4ko7VJ+P3cHNI7O748qcE7KSD2fFfurnrrPKGR8nHfFxdNFXeMxG4Y?=
 =?us-ascii?Q?btJo+x0AxRCKazergGQWAVkwjwbAW6jcbMY5vJYphHA9r+HeqzL6KQYEkxlx?=
 =?us-ascii?Q?gHds5ax1rn/k3LEzoOMN5/39Bzw5jMryMp8NpjYNp7YJwOUWv0LNIQKpO17v?=
 =?us-ascii?Q?l5ceVRVwluazF2x8Pu1NGooP8vzNTY0JqIwJUBz3T0vuD+ad847La18Mg+OP?=
 =?us-ascii?Q?85AzY3gLgnvVekD+1sfZcb3BOHvzZpIxyGRZBf++N9WYktd7IUv8SmcYXMTq?=
 =?us-ascii?Q?84uemk1RAPf+3JXLroKbFWfoVjN4fJhsQMgZBgMu/+MPqz224NoIhDM6uJ5+?=
 =?us-ascii?Q?XKghs+dVbLmhpOSFEDlrxUaHpJspL5IT+rJWw/QkxidXoWo4iMn+rkDmqo6A?=
 =?us-ascii?Q?PfKFilZ9i1zvn/ziufqmIwPTLEpKFXLRcl/sA+8ugRmPxIhKiA5RgHDnTJXD?=
 =?us-ascii?Q?oQ+hVS+7i8ZltMDEKx4mnqFK1uxlLAajUPNV1MPFtLtetq8agayWVAbiy+av?=
 =?us-ascii?Q?g1Es8zZOvMtNLV/AAdU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4224be93-8068-47ab-02a2-08ddeeed6cc6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:36:05.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hq/N7lbHSYSDsgLcQkSQ4QZ1Dr6bhqnc7bHcTtbl36DwcuEaZDG987bj3eEJbbtg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6851

On Sat, Sep 06, 2025 at 12:45:58AM -0700, Nicolin Chen wrote:
 
> One thing that I noticed is that group mutex alone isn't enough,
> because there can be two arm_smmu_build_invs() calls during the
> same attach_dev callback. And the second one would overwrite.

Well the group mutex is what makes it non-concurrent. Two things using
it sequentially within the same thread are a different issue

Jason
