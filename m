Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2069.outbound.protection.outlook.com [40.107.212.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA89C1DC1B2
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730125061; cv=fail; b=Pc0k1+Q5HKtakMu0XMxlE72pO1YC3xhe1Vp58r+yrZhLH7mg7pqCIzgpKyILyhZOa+lOxPnoCqIWVHAFUzgecbJhKraRc1VKbEhEHnFWRYzJTOHWT/ks8c8U4Zk4ASKx/MrwDIb5j3YVVzDEks8ypOLKD6l4MT9AanVMpmlS2SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730125061; c=relaxed/simple;
	bh=P9WVVi1TN1t0bxF3rZ9o2gKm5V1V8Muhrx3hJ2ZHaD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hUEO7p8Fvpx2zUA+VV1V4c4zB+yQ371Q6/O7Vops37wa4FYFPs2niiCMJqOYYLzqQMtnjmGr008bTlTfHHCtNMECQkknig+EfxIOPtsGcuaID3nHu36syXCWskQYW6fxkU+BxCwZAb16e+81rW2h2mvZbwbKPm58nL1pFS4/QBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i0LuVf1y; arc=fail smtp.client-ip=40.107.212.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i0LuVf1y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVqGh84HKuFv6S6h6lb+xQQeHuOC7qyj/DYzixKH2HTu+NskqioPUTs6+C/KEbBs8SfznItVCTXTk1PShE7+sXRIJLec2PTgKI7Mj82Q4IDJ+ZIP5BkKQwuiWOOwbbmVS2Y3yDTszhjsWOlU/EalTWF6dUf0B2MyXSsl83RU33wF8dmml463AJEGkiImmnGxzSLnxtQ0A3VTG/G8nflFVhGmnDRIgzGRYJ869QJ6mPw4A4S4hIWRWr1M3kTeCvJa/BJ47o9/whqrEC9XPOUR/PPNThMnsxkpU/P1DE2qgwRuVE0yBptx2qMRHaWJe1oPNIZ7WpvmrRReTGLToH9hdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tbr8xWXEAsGn8XE+3EXL1/BYRbTxBxe8MoPo1mYh14=;
 b=KDSJmL1MAbdKfse8SoxVqrUweJ5CVy7YCB3A09e2racXK5P1lhJiUUyE6jURT7VUgg9KEMDl5/hrAy6mMB+kp6tdgbqhZmYWbpKTUO1tQml/9k3CiDa6ipXXS5DjwvfGAu0gURY0VHAWmR6XqmJxsk80iGSruGM5Y02WiZpEXGd7JRXYrPX8umsGjIhk+/bJuGF6IwWEzCgJmt75OVTiOhSDQG5W32ISfwwM/MU+IrMXEVNxUVY675whEsHdT67LLdo1fV6bct8RxSbSLZDxD1ZEFFPVqyCHCcwCOcDFEcg9qMYfj87lMsL999WghJecr1himIOpW0hTfShFoCEsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tbr8xWXEAsGn8XE+3EXL1/BYRbTxBxe8MoPo1mYh14=;
 b=i0LuVf1yM2B9EexrLMpaLJrstoeTH1ZgwYT4dfjGiMdMlDssmTH4cevQx3+UXingc3NQIwBcmklqi5dDvl4iuUwyS2ASp70An7pMnDKRJIMh9NDlmPFdulzrgfwNJhARvpVT6/C/y6HaY2bng4P+ufEbD8657XBtdoFzfH1Fgy5sUKg6fUbnZ+cA8h/n4DDFEJcw9J08LMSCk49ZIrO9gro36kpg4hM+9fpR79p0Pn3Nu55eAOy/mNHKCQM6LU/BCqqGu7zuUiwMG9eke3dcFpCR52Qw3H7aojOiJoc5/l3hy3dCnmJsV7ebUhsFCtH7GXj6M6pJ7sV3jNc9jc5G+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8019.namprd12.prod.outlook.com (2603:10b6:8:14e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Mon, 28 Oct
 2024 14:17:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 14:17:28 +0000
Date: Mon, 28 Oct 2024 11:17:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"dwmw2@infradead.org" <dwmw2@infradead.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	"mdf@kernel.org" <mdf@kernel.org>,
	"mshavit@google.com" <mshavit@google.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"smostafa@google.com" <smostafa@google.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>, "aik@amd.com" <aik@amd.com>,
	"zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v5 00/13] iommufd: Add vIOMMU infrastructure (Part-2:
 vDEVICE)
Message-ID: <20241028141726.GQ6956@nvidia.com>
References: <cover.1729897278.git.nicolinc@nvidia.com>
 <BN9PR11MB5276FFE90D75B2146674E0BC8C4A2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276FFE90D75B2146674E0BC8C4A2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0042.namprd20.prod.outlook.com
 (2603:10b6:208:235::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b521b4b-66a5-433e-985d-08dcf75b40a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gFxztfmIVuqN2qXKQ21u8xXL6pHgvZn4dDM27VuN+m++XUp17kQwkt8cWLJU?=
 =?us-ascii?Q?okqz0sk3ltgGK/vtkERxXmorbKwz3pv0Ch2snt/UGT8wCDGceLE4mwq4qpjg?=
 =?us-ascii?Q?N1uEoETwVaOtdsOuzI/pITFVDPsoEjA7wlhivQZ996hpe9H2oQEwe2Jk/FCD?=
 =?us-ascii?Q?glcAWYg4rpARpMEeylFpGz0Li8bU9ewnAi0/WyLkmEEaZHmwtDj8bpc2xj2X?=
 =?us-ascii?Q?iog4RKZO5cj9Xld9ew1tEd/c5EMmEFMa/j8CsDaw6FNk2Td2xKjRLB5TMBet?=
 =?us-ascii?Q?U6KTq4Y4fy0KhH1iwCdr1djsRWcN0ksdYNybWWjiyAJxNfzn1EpoyyXS49YD?=
 =?us-ascii?Q?5yYoV3c8pOouxEj970jaqPK6BLk7P+bQRqpvQ1zpOnBTSyCUqfnQslGUPaZO?=
 =?us-ascii?Q?GCugBwZ6+cvXYaAFK7qfdCBeWC+2pm7piI6lktw6YGn+XXp68jBUlqPPOqnK?=
 =?us-ascii?Q?EtgBTzuyBn7BS8wca2SnozPmG2O23WsI9ETfHyAIBiabnRVgzqfWZQjPbDZF?=
 =?us-ascii?Q?rY3Fzb8x1D/8c5N8Z4/D5eNqPjv3E0iVtc06sUhnYnNDQ5VTeyKhUrxNJSWK?=
 =?us-ascii?Q?/BC0GUQmd/HqOWWsannOFlaXhTp3P7QV79ZOaowaKGhukIPBzKIUpxOS1SCT?=
 =?us-ascii?Q?qiGaW3Cwg0XqfsoXx8o2e8dhYQDp/9EA/MtWT2IhQCnvh++vgGY6rN3NJbBj?=
 =?us-ascii?Q?KnaHnKFtuPrkJtBdrjPeeBszdVZGrq4eAt4W0Yhv1q3E6bOZgaduju6yjpsv?=
 =?us-ascii?Q?waBUUoKNrEMKpRkIAEdCWslfsoX1Mg0by7uWag+zZs2lM/gqvFi4e83LJY+v?=
 =?us-ascii?Q?frsLPD7R66toFKmY6F3sMjURrqBHxwV8JKskPdoidQVHYvE8Z53yktINbNeR?=
 =?us-ascii?Q?dU3lxP13pra1G9cjux/96VriA235sgHheZEsN8bJvwT0lAPBYxDYavqiRDiA?=
 =?us-ascii?Q?Umwxp/p2Bj78Kpv8YzbU/6+3NjCeLr+hmR794FlL+5midtWaB0xUK4fvTz1B?=
 =?us-ascii?Q?dvFEG5nPuu+ofgMKq4xYY4C5oPrEwYVS8DcRA8WFCZpfCwQgFj1eu3A3qUqW?=
 =?us-ascii?Q?I6AQCx0rmNqiEmezpDOPHzdgyzTFL3in57Z9ZDKOEGdSYb9kHhJvPNGYFZ8v?=
 =?us-ascii?Q?U2uFLu8sEMxLcNTDiFloCG/VZLBjRKtKmSmj0kLrvVMB1t5Y8AIj2zS/Fyiv?=
 =?us-ascii?Q?zn+5VzjlDwIjy2EKCePSfwkzgIg6vbF72aQ/f9K/HdwmYkvKBEgpPPmIQ0nJ?=
 =?us-ascii?Q?NgH6oOcZ6ESQxSFjtf+k+oWp33m6d+pa7ay94soKxt3IEYqAigojRY/MtxT+?=
 =?us-ascii?Q?AGhFv2YKc6bteyhV11lopQQz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rcs/0YxtllxYRSKp80OdJ9OAG3zQCQt2RjXQYiNWsXQOO7rEhdnwAuLVpV11?=
 =?us-ascii?Q?oq3N5myKkBvYTv57Zqc10JX69srDsHiV7aDA0fgSeoX92ENdNVsVzGpGvcMM?=
 =?us-ascii?Q?XmAc5qM9gNDkqnV0+4CfuGDCFbePnA7K57vF3ee97K9305u28MGmajINvFI4?=
 =?us-ascii?Q?Sr1cEC2hhiGCMuplntu2aplzyf77+LOf5ApXYNNrddUVXHljcflUoE2zdc9u?=
 =?us-ascii?Q?MKXb0Y7iRv3stqcsUpLneqXyX4qx/SFWAjuQrqSey1hg+6PkJSfNsyCL2Ip8?=
 =?us-ascii?Q?Bwuhx+vT/pLO7b8Ca8xpz+mYs1AxQ4MccLZNV1Pkgwu21e/SIykMYqPmioy+?=
 =?us-ascii?Q?+OOpeQw57MA+fDxq5jJDcjH310pkQB2Ma1uKbf+ogIElPpDGrWqZbjz9t69w?=
 =?us-ascii?Q?jJwPCNIebiTcA/ix8APyoEoK3AbhxQxERFUeNR0pZYpp1FS9NK5E4TaWe/A4?=
 =?us-ascii?Q?WdCD3Vu9WuYoX8IPZ4uUkMyU+M4EfEKhfBNhl5bxRmxzXrSB9N+FiC0bcoHZ?=
 =?us-ascii?Q?bumMi/Z6XtUZwgoFHhMDhcvnOdqwSVjmXEdrDxX4KZEH78g/sKEfl+l/+Mlr?=
 =?us-ascii?Q?S+gMSsaLrzrv59hJIi2mfpafkzMnsYOzRQc7tptLqwXCqh8LBit/xkTRHWy2?=
 =?us-ascii?Q?jSor/5UKFhHDKZEC2HIc/+qI5eUCjDlgmlkD+v6fUYfIWga0ooRuBB4kSzXQ?=
 =?us-ascii?Q?eBu9oDd2nTkqUDAUtPj2ff4dpjRxUZo6utxL2CWb9+nLlBlnqi479EnXREEL?=
 =?us-ascii?Q?eAGLGTisnNoXKWEHDEwDSYXufo9sxmhd+l5pdvsg1jOHp2wpyzE570sdchXr?=
 =?us-ascii?Q?HIjS0EObtPQf0Mux15jiyWYXcmYxJ91KdixQefWXA0leea6546kN3DF8RwM7?=
 =?us-ascii?Q?81ktLkR87HUm2UdotjRg79C3I6OYWPXR4qTPHfd1VMI/H2X07eDuLIrKfu+g?=
 =?us-ascii?Q?xybyIqzTD0wrLE4JGFj+f1lkSL2a+PKMgkKygLB01ePfnAWr6E2Nz7ODp17x?=
 =?us-ascii?Q?qotuUF6SOcX0u67gFFf1lzRUuejCTGNJi1T0TemH2eNQUTdZCDOEOeP3WvWo?=
 =?us-ascii?Q?cNaLsE/7Pq3MZwkqr4nnq8D7T3fThXY5orP4Fp50EjlJWbsxC/eRu0E+CIsQ?=
 =?us-ascii?Q?zS8M+qdEh3O/MQ5H2m8i+zGfgtodA6423twdd15ukd+Gol9+Z1jJuW7v01t0?=
 =?us-ascii?Q?dzqBA7ow0lHJBc+FuwxRDbvUZT+DZVT2xCqqkEUo5pH57UL0QkgYSTffoUe4?=
 =?us-ascii?Q?ETTQect3fQ7675W6R4Tmh5r+PBg4SRsBIJ4ASKWfhtN0nhBm0LPyMdjDP0mN?=
 =?us-ascii?Q?9F2/ma6h26xTveRdxDq13LilobfVi+65EuMR/XJ7dpB5qZLawZEwa/wL6IXU?=
 =?us-ascii?Q?IkTb0fKv5kLe7NBtK43tHvpElurAlz5SK4E8fCqHjUN7gSzN8vgQxvZ9wjQC?=
 =?us-ascii?Q?pdF5QV5TuV6UxndX/jH3AesVCcgQnUB/kU9ApLxFZSanX0hx9IdinPMKvBxa?=
 =?us-ascii?Q?ouzwDzKUUlxYAIoIsb0W5RguphVdMkjvm6YoV46Y9bMRekvEjiSJcmihvoBO?=
 =?us-ascii?Q?U7I+LQ5/FEdzHfS7aPKq+Y3tJOglLno/eN4wcli5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b521b4b-66a5-433e-985d-08dcf75b40a2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 14:17:28.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +12qLM91FsV7WlHjv39QIkXzXZMHAEjwqmQAaeIFCiWshRRMVNAuiod/5fCTb0rD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8019

> > to
> > a Context Table. This virt_id helps IOMMU drivers to link the vID to a pID
> > of the device against the physical IOMMU instance. This is essential for a
> > vIOMMU-based invalidation, where the request contains a device's vID for a
> > device cache flush, e.g. ATC invalidation.
> 
> probably connect this to vCMDQ passthrough? otherwise for sw-based
> invalidation the userspace can always replace vID with pID before
> submitting the request.

You can't just do that, the ID in the invalidation command has to be
validated by the kernel.

At that point you may as well just use the vID instead of inventing a
new means to validate raw pIDs.

VT-D avoided this so far because it is pushing the invalidation
through the device object and the device object provides the ID
directly. No IDs in commands, no switching devices during a command
batch.

Jason
