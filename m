Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013055.outbound.protection.outlook.com [40.107.201.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5E037B02E;
	Tue, 29 Sep 2026 14:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691627; cv=fail; b=YfyXUfoZA2io0sakq8Y0MwcbCayCgOydU1zIBQvhFLgDfyDgPV9Ic0lHPBwZrByGEa2xVf+y487C329YngfAicPM+tMoC7ko6/QRfFTuB2d2rJOCw7+YWIw7N5TrTuYMGXs4V3Fd5eJ69+h8GnSB1Cb33Evga/5h7/+k+cEYzdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691627; c=relaxed/simple;
	bh=/yQU8Y0Ex70T/gAmBawtTxrXcz4FXXsm8ToxQpL6GMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eK6Di9wE45/hNiOEHv8vqbenSKvB5v3m50G2g8b7P0Bl2oE4V4aCGdEza1iOjuJOLqe3koiWzZirLEf2wlS6E+NVL/z5YGIrNuZ7H/pPhdsLnR5q62Tm8WF5ge0H2BMO6NqXUyW8mBOI56noDtbgYnUXjEOqC6Yp0QV7QjHRocY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qWagKXmV; arc=fail smtp.client-ip=40.107.201.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qWagKXmV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8rdHzOhlMlBvdMnIvaftuG/tsf6z8RpJgZs4wrPQCNvGxFNnJ3rN0N65wLxVCL799ZZFHJ5obtvi13wufXV2M2op3AXuR558hdVpXV9dGXNMPgHAQ1VQiXAW3QnF2wi1OW+weY9MPfmHPFbV+CZx+0esN0l1523TiosljwL2NY/WhbHU40iZ31yE3Z/2I1DwwoWg+lmXUEwFGsQiHGS+PDGA8ufelkSVJ6JcG6M/8x0ibrc6KS5hh1ODmGbNQjujV+D0V7KBbxk1sfLhM/zGP0L6DzZwWbmd8VBwueDcHMHtdtiOL/hu2FCnYI/78xkhiKpHZnV0S8Gku74n//NZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIOCmutbwd8F2t+MiX36pDWhxX0/jkdB2DenpWMn1KA=;
 b=CCoVui84PnTFyJm5kyE5Ij2XJGD7Yn6P6N9uRPE1M0S5xBqTnigGUIS0TNlSLfCTW3AFyO+d8JTXWdbupWt868iMYaM2RBI6ND5jQJWfyKV4ej2J6KKTmNw/pLiNvLNzEcqS98Qfeo1zh82bbK1YBuRrHOd50y4zNFYMZZB+ecbrBdDlV+85gQcdxJSzIIaItYmKnzUkI9UqGy9cwRFiHe6ImR7kCCLhAl8Vi4mKnWQN5hBqq3LPvkReD8vKiTa88VgyMxpw1eaUacAcH8RNBIbXx26TeGiw28WjiwUCHoovNptp/5cYtsRdeAizZGzMH8CBXuf8UcN9tSTyzRAemQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIOCmutbwd8F2t+MiX36pDWhxX0/jkdB2DenpWMn1KA=;
 b=qWagKXmVI3XOcmaDwoP487ELCHxbHSHLMwjU5NQE5RLk1//Hai92lxASB5yQJpucNfInzqy/qJfMMbpObtsd5w3IpE/ikUSRNzoxqP1HjSSzgO1Geu4e0quyfSjXWgUG4ztJRHilnU1M5jDNc47Aont0U2t3jvKXHIVpbSBFxJ4qjCCgM7K3xWdLUm0YecjxoKPrMpjZaFbldVXZF6YJcZ88XxDfhZ/kHDgDQQhqKskEWPZWON079OZWkikqU1njPbfoz80JeVlSvz0guudNKbu5VvG0QkzUlJvGwilUv504YiozsEpnYmHCnXLfb6I+nhbea2Cnto2wbxNNxR8NYw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV5PR12MB9825.namprd12.prod.outlook.com
 (2603:10b6:408:2ff::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 14:20:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.024; Tue, 29 Sep 2026
 14:20:20 +0000
Date: Tue, 29 Sep 2026 11:20:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/9] iommupt/kunit: Skip test configs without
 supported features
Message-ID: <20260929142018.GM1616761@nvidia.com>
References: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
 <2-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
 <arr1SdQI-s46qG20@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arr1SdQI-s46qG20@google.com>
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV5PR12MB9825:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ee491ff-43d8-4e77-d47c-08df1e34cafb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|22082099003|18002099003|11063799006|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	omLk/jHcBBJQdIhkNFJn/P8YeDsWcFfYawtsdqKXq06R/xm8Y2Ap2S5WTfqrjKpnqNHgXTQnJ9pfuPau2tNexFEMJYrfDFSPMiP03kagpFWKh/kkXbFMITT0QIYIitCrtU9cV2VOFWw8aYZBE7HiLOS7DE5ZFqzfX1baaTJ30Rnp0HXdef7bKZfDW8x06OCbKj+d3hMAHobQwUZZYfzri3xEJZFl1MSPDjTdpLxzEl5JZ414eI3NLF8C4SpAiQqoD6lyaH19e376SLDtmu6pXBnTftyFbHmEaKNIsBQRnraJdG4gAx6tboVOmiZJTuKbexjAFpBTA+RRDy5eA+6KB1a1m/06jX/pNa7T2fvTPUM+kW2Xq2MsRoNEFpUBeifmdpi71uzuN9ZzNdN9HzuaOO98U6kzyNStWzQO0lLR3L1xUiDPDeUmaE2+gP4MTRZQUiXKBEJFfMit28l0OoOJZKTeRgGh9N6/Py8aRPEld6P+FrRAjM+XZPSagCrqwydBodLyFehs2sGtE7iNuqxIKjoUZpgW9ZlMrKBeXK7XR5IIbI9TCPbQA92gQG2E/awA9/JYj/F6qYd1EZ7DQYYdWMVh++DcgcOL2ZigaUNpkOEFNrO1q06ZLr+d6RTvLo4XSPHxWQE7cCUHYtMsvot5Cmp1xtGC+I6RyYohunmr+Go=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SGRIrSz7cvMzsgnH11jP7XcqxXq5mVje5Dex4QhNpbd9JIzd4HwmaqEnaWWg?=
 =?us-ascii?Q?vlHO2JJ/gY62PoZ+TadSjJ3761Y59O58AJ/X99/euGBmypDXENYGFYqOZ2te?=
 =?us-ascii?Q?cA5EXNGgNTvK3KDyXMLoy7MFOI/wLu4N8l8rnA4ktA1uM031C7A0SFfJNUMM?=
 =?us-ascii?Q?EIlHJ2kWmWn9VOAp3U/N+oDV40cP25nsVn/wDoQao1WLnwZBJP0/u6YNF3DA?=
 =?us-ascii?Q?Rt4ej+iTGdkYSrsW4k/+++H0Bhe8elYv9CiedJsOdy5CVZnb47U/4yQDxSrI?=
 =?us-ascii?Q?d0Q/+zj4dqk6nxz5R8ddraASgLRvUv0ABUFb5lBhGhnWyBQ8zKbPE5O2Z7P1?=
 =?us-ascii?Q?29n5VhfTxQoNet9oWLkBTPZyuhrQNzCq5AocV4d5kH91r6pMivTf+dnEAqhg?=
 =?us-ascii?Q?ZpCLd5aQ7KsfTgM7XwBIZ6UIrnPHPSQ7UVe0BuiOAd2fqZnoiXRLJtgBPgqy?=
 =?us-ascii?Q?TQNtm/xANxT8A8aSlzTZY4TdQUJpBQmtG/x32s8EmbT7+irQ7POAa98Sb6sQ?=
 =?us-ascii?Q?LckXJTlnG4384SFgSrC8Ic1Rvl8AKtXkAQdKH9hO4KD9MLtjp5abQM4DjW9u?=
 =?us-ascii?Q?vCf7vRZhE6wHNMaMazpTGgh0iP2F3LyS8IyQ7BF9PY1I0Zzux+Fud9X44rV1?=
 =?us-ascii?Q?pRWBKsddti9LQC187aE4QenmPCp1drcdzRmyhw5Kbdf61jspnwz7HAmiYvsG?=
 =?us-ascii?Q?GJHG8CqpOSLe6+fXaJsUeG6bzqRWYACazh5D9MmxhC9w05ljqWH93LjjYRHu?=
 =?us-ascii?Q?iI57iYETybZ1VhjZ4eXZWn3lYVzajN0YbF6O32sz/GrmuNXQDuOYujF81Jct?=
 =?us-ascii?Q?YmTOkeC2A91RCpEWLwrFsskN3rBilC3Ao6NQUvh4Vb36nhwzuiQGXY4Aoyx/?=
 =?us-ascii?Q?aIND+u0D6R+gaqHxP0+pRSKdDZgvtUG1jpsdKNDhAlm+wE7H9ecfFukaZjZH?=
 =?us-ascii?Q?YILvBe3d47nKVwFUgxuwB09U8T6EorP1nAX9TEn/LXj2dogHKIKj/n5PvwBr?=
 =?us-ascii?Q?Bsa15+CZ7CAU6GVfquQOGBH4AKy35h4xOeFicgWpowkU0o4qKQXnqaj0m+hQ?=
 =?us-ascii?Q?JqnfiJVpqzwTT22j5oZhuuIpy2IVkSptEp3RQ56d/9UWjuCPduUbVEFFsYX3?=
 =?us-ascii?Q?vKyorJDrdCfpBj7zKNSCVBtC4mn/vS4oNBIYjWYiTvd+6EpafL6ysmjmF5YK?=
 =?us-ascii?Q?VkN3C/QdH3EO1biu6/ob6QFLUwyDFJwoow53hYXuX2qEIaClYaUXdP0u+zMT?=
 =?us-ascii?Q?aVMj1tv94jctzmJASQiPCsxC37TGrBN2NN06HZu+kjx9WkfSfgxYluARqlBU?=
 =?us-ascii?Q?PIvuYB9c2DxH+1QgcIsOriGdDELqPdh/Bqa3xICOrR4ID2g58b6EMNxc5XyG?=
 =?us-ascii?Q?ritcVUPSdhXkH9xtZg+JykQ/vW2ByBwTZUp1PyiHsUX2AvILTl1gE8L9jZYH?=
 =?us-ascii?Q?itunLQumwdP2R+MpOGavVZd+XMyjyQzs6X5vuiviU2ALoOsvsJNFXfTm+LAf?=
 =?us-ascii?Q?Y4B4bwk01NVE47su7a4Orq5bXTCkuYnHr3OFjcoUr26wzWK8d47FPE43SWaT?=
 =?us-ascii?Q?kmcSnFrO9M5Gkib8GDBOFrDQh8uzmpyLq+lhiu/jS/rRwUc7XETG5YMjtdV2?=
 =?us-ascii?Q?9ANnxTNxNYs08gyVvWgPBmzA5jth/Qc2Bd31+b3wFUWJiqVUKCU4L9oBkqap?=
 =?us-ascii?Q?yXOQxXDYDtoK9BAQbDkD2I9XIkc8zFVI6pnv8Tj9cAJWIfOn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee491ff-43d8-4e77-d47c-08df1e34cafb
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 14:20:20.3487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WJT1Z2wmX+Pp7x4zqDMnbYltp0lJpGzWlLuTj1CA6EZ8LX8BLjRSind9xjnl9zn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9825

On Mon, Sep 28, 2026 at 11:16:25PM +0000, Pranjal Shrivastava wrote:
> I can't quite build this as I can't find this macro:
> 
> drivers/iommu/generic_pt/fmt/../kunit_iommu.h:129:35: error: use of undeclared identifier 'KUNIT_PT_SUPPORTED_FEATURES'
>   129 |         if (priv->cfg.common.features & ~KUNIT_PT_SUPPORTED_FEATURES)
>       |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>   CC      drivers/tty/tty_port.o
>   CC      drivers/clk/clk-fixed-factor.o
>   AS      arch/arm64/lib/strrchr.o
> 1 error generated.
> make[5]: *** [drivers/iommu/generic_pt/fmt/Makefile:30: drivers/iommu/generic_pt/fmt/kunit_iommu_armv8.o] Error 1
> make[4]: *** [scripts/Makefile.build:551: drivers/iommu/generic_pt/fmt] Error 2
> 
> Am I missing a series it was defined in? Can't find anything on lore,
> but I did find a commit on your github [1] that is supposed to preclude
> this, I guess?

Oh, there is a patch in my pile I didn't realize was needed, I'll add
it to this series. The github has it:

 iommupt/kunit: Do not test INCOHERENT on anything but x86

Thanks,
Jason
