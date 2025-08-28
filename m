Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7403130F550;
	Thu, 28 Aug 2025 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756384646; cv=fail; b=Zr1ecoj6A+as9rWB7mJjrafxADKDKNya80A6eka/8YbIt75O9WiRE2jCf4+JkL37izewvFDa727e17EfLmCc6h5AfNZq/ZXMBeEHT0t6Ggd62WPMcZWsPjXwdshq3qS94stjIn9itMI+auxmiIA+Rpldmp5/sbiSAzWI8ksoUow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756384646; c=relaxed/simple;
	bh=zExq7cAEHGPOux/Iu6lXGeLtcxQ5w4AD3UAerLOWH5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j24CJ8f7uWAsA8BjuPxwXSwhRAdPmWA19EPTPGdHWVKjIrIxfpXuWlH+sqnkZo2naEFnm4yP+8AKWVv9pazj0CUPd7ak0raP5RSjrwyBWqyCE7xu5SQedcfNl/zqy/N9qjK5fXtZLGYYqYSZbfrvKCKMjze8iVipEIgbmSl+WEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V7FtC4xE; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V7FtC4xE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTfdFNCSxAFrzH+LUW13bmN5dC9+sq+qD8rbWrdisCMmK0KrB9YO4gYIwUPmfrHSogyHloks8DqxkDzMdFenzCy3dBrhlShCmA8NRLcIttjcNpC0F3xA0sMkaQPiRcomJ/X2aUK3UHLN41BDPGEqs2t9JHicwz850wyPGNjwv5wecID4u14SMjE8xAsfQp8OZBu3fdXWYzbRWL4IZVXG7fCXukL3TdSiqH0xAmclVhXJ6qAHV4dg9nfx+nuytxJ3s/vHwjBXAaHwB17YZutyQI8Rzg338cWbhGgCFP2jfnxhvMvm2y2PHto5D2GaLm6EpKQYat9mNkaU6xQixpA45w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRa4UKrjz/zenTOgWq5B3uLiu+fJ2j6ZnpGBv8ez3FQ=;
 b=dnF6JxsGdzXAjT9NrABOfMMHt6W2FJYtJA8u3ZORSehrg47c9MY0IrffHFgTwBPnuMzV9kFdOih4Ihf1iZI4sEUkzTgO+Q7b8ZRZAe/LH5ojcw3bLKqP7tfiw1rpDb/Zk6Lm6pAcc3muFOjiTnPrYRfdOzc8e92J/ZZs3jEwIi0rt/mK/GvwkgIsNLYMHdFHYsMrtXNFWQlMvLYZC2Rsq958B3g9T7iBekcsB1SwWiK8n99WimV2dZPKLJUKmTZvtRvqofg/ykj4tEYGj9HCj0R4wPRpFP7c5EGkDWOJx1Dyvj/qV5i+5j8mlrLn6KNgYgSQO1yJVrnQ5M5KjJlcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRa4UKrjz/zenTOgWq5B3uLiu+fJ2j6ZnpGBv8ez3FQ=;
 b=V7FtC4xEmKZRC3XbIemCqmkLZalzOqAzyCh8OyBW7WzzKRc0nd/kInvdEmU709pIB/zJ4JDIP2mSVNRjWIRcEnul7D2eFe0rXppv0LjMxjNTUUNeZwkO0/ANBzPnxnk+eylMx48JdxX6GxeCqNdtKQgyu/dq2EfZTFOMG/fumD5no0MByyDa0HDU5V5n1jUkYiacZ7vv+gzy6VAffcEmd03jyMDep3ia1hZclAL6GWR5y8ueDexhtBOgsh2uN9Bo2P22wNO9FS83dPTN0NjCtpcWNpu/tiHzIIf863m9aEblPJKma6OdvkV39q6uQ3dvOzeIszwgLTcC1UaWGAlsgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS4PR12MB9587.namprd12.prod.outlook.com (2603:10b6:8:282::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 12:37:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.010; Thu, 28 Aug 2025
 12:37:15 +0000
Date: Thu, 28 Aug 2025 09:37:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 4/8] iommu/arm-smmu-v3: Introduce a per-domain
 arm_smmu_invs array
Message-ID: <20250828123713.GA7333@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
 <20250827164804.GA2206304@nvidia.com>
 <aK8+FvkbpB9G9YA+@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK8+FvkbpB9G9YA+@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR20CA0032.namprd20.prod.outlook.com
 (2603:10b6:208:e8::45) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS4PR12MB9587:EE_
X-MS-Office365-Filtering-Correlation-Id: cefb4999-20ac-45b9-9e2b-08dde62f9e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?30+IIXB719DHAlLon+37A+z96JFl2+1rHP6JOAMeGJ6ptkPXOKnkQJ6A/Byn?=
 =?us-ascii?Q?Azy1vD+AnwFVKG1M+v1fDPaf61cf/slF30oy+VGsBTbnvn/SSpvnJs1tuaFv?=
 =?us-ascii?Q?RyObZAS+W3UnycDkAKmWd2RgOS9zoqAOpSaSf/GDNBmy7VP9HDTz3Yx9tq8W?=
 =?us-ascii?Q?fUfFutJt4gKgazrzrBtneEhAy9D0JBTNumftz6di9QsipjTpY1bnHInWRfwh?=
 =?us-ascii?Q?PDSWTdn3GBKmPDyfEBRd9mPdryWRat3UXObFj1rykbuif2IN5R48fPuQ+15B?=
 =?us-ascii?Q?ZGoPQ85AJ+2h/suj6G+Bwm6cmFVx5q9zmQ+TZFB2Cot6oEqiMM4gGQDtPGvs?=
 =?us-ascii?Q?iEcKrOjBPMqArLac0jtBwv/JMmeETwKIWaSQfqkkRV2eHnFCq1rUVfVaHSyQ?=
 =?us-ascii?Q?2s392Js9r+ZEWN4kbe+VGVdYFxEsqWeFOBrx0s7EqhEWtckZL4q4DYou29Sm?=
 =?us-ascii?Q?DZb5Hpek5o+QpanuhWPNF3zfXl6hgQ+1z/gq8PHxP6e4GYAbj5P3uw+DpSsN?=
 =?us-ascii?Q?s785cQyclQwCZFBuLch+LnTrnuqNlCuaHRSPS3x75cXVEBLPFgbGY4qoviDu?=
 =?us-ascii?Q?Fa0daWIQRFVUHwEM/aDOQ+0mAJca9+HKZ2YxpfUCWdw7IrazsXTLorvIRdcO?=
 =?us-ascii?Q?zxwieJXOSudDIIis8phpih0WPsvUOw4bd+mpijE27iy04wMXeN1mlm5Q2JFI?=
 =?us-ascii?Q?uXwGPSPc7w00DcdHnesEYsMnB4IadslsNusFZwUGmTmM1is3edeisPxnPUIh?=
 =?us-ascii?Q?FGjmLfsx6jJ9aHhnrslDx5uG4wMnwU+UWbsz//MKdmsAFHX/zi0t45Ek+Hi9?=
 =?us-ascii?Q?kwnKgbuysAEWq4eDI/UFZks6cgcfPgNTiCm4qNLpQOxOtWW5Ni5XR3zYQxFZ?=
 =?us-ascii?Q?6Rq3eWrPWlYINwDNEspnuBxF6kOi4Gs6a3yj4rCl71UmG8jRvi341H6A9Dj0?=
 =?us-ascii?Q?8PSPOXXLQtETI8mWIIg56doOkMos32NfNg89WXGztBd/7N31AXtjT2bJaaC/?=
 =?us-ascii?Q?M1tdqY6g8bjuvhUiGDKn4SPmRguZm55nWY5DdPOgga/nF08a+lVKALRo+IHa?=
 =?us-ascii?Q?s1BR88Wjt96nxMcfee/OckY98utL5bF81S82bxn1c3sA7fHJqDHcuRxqrfUu?=
 =?us-ascii?Q?3Ld97x4DqDmEGfJIpXKRksSKhOEssTHMRwATPw6z7oPFJSPFojGLWGGAiaDV?=
 =?us-ascii?Q?T59ykVOnXyHt7pxSOKWXw5H6OD6mj0QfBFuA0+RNex8OkeF2pmpm5/61AwZm?=
 =?us-ascii?Q?I565acc08vrdwLy5a+biFZ+pU4TVXKoeDh757oL4vCmxKFq64lFzuQLLPY5G?=
 =?us-ascii?Q?DgNV0rXwcy/DIYFt/0Ju+0Fx26glVST4Yb0qTHKMw/hKTcnEYP1Vx/MVhJvX?=
 =?us-ascii?Q?p54JSAdVwsJCY4AM/fHdIxoRF4An5J+1poHTsGa3APFzVQbxoX7KDb06iUo/?=
 =?us-ascii?Q?urOu1yBIgLc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sfZnzeGRDcgQaFG88mgi6pcY6iNQk4ZxuCAOjIcT4i51nyKmaMVxsoH1+rXB?=
 =?us-ascii?Q?gI9Y9p7Y+7OHgLF9PvVEa7fBsXUNgmxv/vtYTwFjniFGDO4IgvteIOWK+cKV?=
 =?us-ascii?Q?7/sPdfdvTJ5bvUL2uR8mi9vTrEJfRzcehEs/CXFW1OWLNbO+0MTuZTKAAeat?=
 =?us-ascii?Q?o63tXrymi2rGjHJsIUNt63vB9wQB7gkmZGQ8E5aWBMwNoTcAaWtEGrdRYSov?=
 =?us-ascii?Q?yQVLGmYrHazr2uZ/VHWOWp/UuOqAhzSr3wQYjztrvcutJCaaVFAQpzJq0Ggn?=
 =?us-ascii?Q?Ar+NpwVRafoc3DWdlXVgCcaA8HKM/QT1eew00b/v4Ld6QR+8NaVJ7aF+0kCP?=
 =?us-ascii?Q?I0jS5WBie6d0/QG4wxB8AbiWql7KRjLMPog8SEFxYqltjqw+ztszmGc9eDP0?=
 =?us-ascii?Q?Qz1e2D0slj3o44J2k1/6yGkTYYZXgITJrGTggn4ofqzJQ/36vg48PTS02jzD?=
 =?us-ascii?Q?b/4Ic+5u2o5Wab18+tU24jwb8L4hmBY+BYlzyR6sH9ZWYDwSM4FYw89UC7Xk?=
 =?us-ascii?Q?jFlJSXAQa1rBTEYwppCCvR6hgv7PRKCMje94gOtP/tJH0R7QNGdAFAO4s0Dv?=
 =?us-ascii?Q?N/6lboSs29qHs9cugwHv1xKbvD85epauznVLD5XKQlz/q76qekdZXlRLHtS4?=
 =?us-ascii?Q?pCd5m9qm9pByLT9yuCJpxo3W35/MP8eMjNa0JZi6USRfQ90KXdllwq3Os7vk?=
 =?us-ascii?Q?jWTsEQvTW3or2qfTBRCVn7po0z8RHY5QW6kdLGwytk/TrYsvn2F2hGY/Gd6i?=
 =?us-ascii?Q?mitf2wTwaZ66pmAtsl+YMNNb1MHh2l3pYTrLdlI60JEubJvr5+A4yJyv0uKZ?=
 =?us-ascii?Q?l4/rp4pmcWbKUMPI+84OOJq5w0JPA4LxsKMxKPMl2HLJ2q3luoCRIrTz5WCb?=
 =?us-ascii?Q?n00kBThMJKcrc2jp5I5vX1BBUwO8yKqje7w4OEYYQpcOOJVU8VKBLSyqPT6n?=
 =?us-ascii?Q?S5dD48qImtbUx4GsElpnIm3lDrtmI1TUkWlC6te/RAEFEfAJHD2Ms1+3iP3y?=
 =?us-ascii?Q?DDp1VGxyfitcQ38VDn0cCAH9clSSGt+l+q/V/jU3FzQ77mSclYITtPG4fxWC?=
 =?us-ascii?Q?SuJMr0E7RsfLUeTLeeNUY8ywxQoe1o7YJ643yyx+CsO4miGr8r1Dg9Zbyu7u?=
 =?us-ascii?Q?PUJfQJOai2Voxma+o/Nc/zSgZoKfS+gMdsjYCRbTIJ6Zl2DTRpEmb6BHTvUg?=
 =?us-ascii?Q?FDD8oU3M1Er0HTAOVq2INtKvnUmWCLeziOlz4LE4/5i8IJmF1pCcZFDiN7Oc?=
 =?us-ascii?Q?OAnUYtNjVitt0r2wy2ZuiLkg0hXU2QKqnqppcaJ61fO/v3v0zK3QPHEvbRro?=
 =?us-ascii?Q?Qu60dVE1m/EDwgekRqtCkG1bgLTeVSCAiQow5depGfFooOLvJeBhJsumX5+Q?=
 =?us-ascii?Q?Oef2EXI5SHa0dsvPKD3yyZvNqRYSxge50Zzgjq1QrjWRkI0xIRVORoN2sBaU?=
 =?us-ascii?Q?Vo7UrDZWDV5m+7GLrmG6+7OyqLX8D7832SoEZAQRvLUHqN/TwYWiYK+4kppG?=
 =?us-ascii?Q?yEOcejSHW3zBTvZqaBoc4vl9OpC65bhipaeK/ef5VUjGNZBKrFsj5uhAhbjb?=
 =?us-ascii?Q?aGLqIY/nldL/HVyhajQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefb4999-20ac-45b9-9e2b-08dde62f9e35
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 12:37:15.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nb9J0LoQfYRL2W4dkCZsTj9Rnq9sCDSA+2CamsP1iyCmSiot9qUL6RJUpw9tLq2p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9587

On Wed, Aug 27, 2025 at 10:19:18AM -0700, Nicolin Chen wrote:
> > Just always do decr, then have a simple function to compact the list
> > after the decr:
> 
> But the _dec function will always take the write lock, which seems
> to lose the benefit of using an RCU array?

The lock isn't needed, all it does is refcount dec which is atomic.

And all the lists are locked by the asid lock on the write side
anyhow.

> > If this returns NULL then just leave the list alone, it is OK to sit
> > there with the 0 users left behind.
> 
> Yea, it's better than waiting for the next _add function to compact
> the list.

I was thinking you could call the add function with an empty list
instead of adding another function..

> > No need for the complex _del function and the _decr function..
> > 
> > This also means the memory doesn't need to be preallocated and it
> > significantly simplifies alot of the logic.
>
> By "preallocated" you mean "master->scratch_invs"? 

No, I mean the second list of invalidations the old domain new list.

Jason
