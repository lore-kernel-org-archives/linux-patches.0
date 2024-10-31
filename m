Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14F07A15A
	for <patches@lists.linux.dev>; Thu, 31 Oct 2024 11:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730375983; cv=fail; b=Y0AeRXUb7D8FsBWiYoSKl/zT1L7DcWkoz9Uk9AY7QHAtgYD/TOEtu86J03g71GmIk9NmQW4NAmueRrrLY4QjrLZxYkBFEpMEujQ/kBHbfmIK27H1Qy8MVs+Zg8vdNk1mcupufqp5iFitBzOhXlJSN2aLZgk1Cdvrued+FIIcbTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730375983; c=relaxed/simple;
	bh=aT6QUvSw/Y1QrGgFFqc3l7z0qhnYj7XlHbxPq+TMzcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FpUH/Sh0U0Zy3929kVBCZHo35v1sqnF7llCYiWoYUj+ZZdzNLrm/EtZ1clpv/OpoLB40X/0Oxmk72avbpys600LdJLhph3inYFeML9lpOJzDfP2uOjSd3i7QeHBGHqkADiXr351iMYW0hGZVcKCFYxoadwJ6dWNPlvQoyAjJqOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KfMRV80W; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KfMRV80W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJQsfu+KqagtqGCA8GNhiN75vWha+6IdXHZNWV/Is+DJcIYJoH/K88FB9nSo/Z1zrbJ6wh+zGx+BGiiuSHTrRjbgzCdx5oxdmuQ3AyTvO5k4MkIk0UBT0yc1vo5hQTX+b6qes1uNjC51TpfCv6Vc/trg7AmCjSSgEy78jS7JMa8uMUXZzUeD/VM4xxNIDsDMxCXvhRo2ZfOHTaAxG3efzFvj/rezB6E/EpT+IO4+RtTfmIbVT40hBTo+ndIUlMvR7iVR7Ol85IA6fyaXjN2yhH0X16IUvhjFpc+m9lJ29DrGrZfsllsfpuNcSu3Ci/VmPUsG7p1niFFcMila0LYU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMDJHDA5tCd2GoubyZuU/oUxFosg5i5sWOlvzY9InUw=;
 b=sRxSm5Nt8oFkzunhnQ9mCG8UA932XYT9Hwa2ArdW5MS/32eT1KHaY8LQE11OUeRI0toEDqVgOh08xDswP/36kgGb5JGTj7V8X6yS7uKB6bXB2LeOzyhGsnCjdYudL84Ss0QGpKEbk4CcNQRmaIw7SRNVKaqTFPTbLpPsTrC/+U5obh6+wmuLFZ4knK9IN+z2SMdyTJBUj5fvv1SOp6df9WuSP+8Balk17lzlp2V/J7GZsW24dqH1ZYSbthYu8Xx1CZsJkMFc/73ZOnatArxRTdixflESxmtBftyKRJymdWL+TykOYkF1Oz7Yh1frufS3m6OYnpaGOgwsS+u++6lZPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMDJHDA5tCd2GoubyZuU/oUxFosg5i5sWOlvzY9InUw=;
 b=KfMRV80WohDtXABbIx7POFRUARZwbcGRPFbJ/mkvXjTBqrorR/nHoHlgxJrkxsTGqLfuA2j7nvTmv6BSbzVAhp0XyZm+cLkp5Z9KWM41C+8AMh8lDLZfGcnN4eSo5FxWiq27B3i//pV3ZoN8bXBZT/0Xl353O+W0k7JQazN1qrGkh92XkNIJv1cVLteR+yKWZycDKFNxt7xguMSwsYfZ5gwl4YMtWjhR0rbZemCmeicb+lR+OyMc+Bf7UxCF0ipO3+qs2rriCWTA0INqI59vwviO6VgAeiQk3Idhf3dy3oYuCLBsvy/5meJNN+HEn2yK6S4SxkGXoy0f9KfsMoi52Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB9523.namprd12.prod.outlook.com (2603:10b6:208:595::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.23; Thu, 31 Oct
 2024 11:59:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 11:59:38 +0000
Date: Thu, 31 Oct 2024 08:59:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, kevin.tian@intel.com,
	corbet@lwn.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
	will@kernel.org, robin.murphy@arm.com, dwmw2@infradead.org,
	shuah@kernel.org, iommu@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	baolu.lu@linux.intel.com, eric.auger@redhat.com,
	jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
	shameerali.kolothum.thodi@huawei.com, smostafa@google.com,
	yi.l.liu@intel.com, aik@amd.com, patches@lists.linux.dev
Subject: Re: [PATCH v6 00/10] iommufd: Add vIOMMU infrastructure (Part-2:
 vDEVICE)
Message-ID: <20241031115937.GD10193@nvidia.com>
References: <cover.1730313494.git.nicolinc@nvidia.com>
 <CABQgh9GYOgBJwRhvsWpPwS4vgDzCvXCAUxc8DQy8ObHAOvpbRQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9GYOgBJwRhvsWpPwS4vgDzCvXCAUxc8DQy8ObHAOvpbRQ@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB9523:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e3eed58-7a15-48de-5082-08dcf9a37ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J9cVVFTX23734i4M7zyFRBWa/91xhEckrAi4lAAJP06wJuYyfbeTAv9Rm8O+?=
 =?us-ascii?Q?9CPOkPjshuE+tScAbtOR8m9t+s2Is/uBGC9+ltzyLAHNok2SZ4MYBnsVwrP+?=
 =?us-ascii?Q?VVmQ9SAJazDt4ztyvj3YYTZGi90K33iVyaRF4/GNTmzduwp1IXTvOCzbp5Cl?=
 =?us-ascii?Q?m3wQS0KPsyQCMghTy6T7dpDCWtwTJIILN5GAwB1n7FDsQtrFN7RUEqrxiKyh?=
 =?us-ascii?Q?kLXHdZlE/ryhRb3PL57TDFKn7nIyMWtH0Xjbqj6G49UyDWP3j0MD3MJtCzOQ?=
 =?us-ascii?Q?vPjtvwM7rfrVwDXfCFYtfeNwBShy8MbsS1qREIQBukd2JD/hL4L/dQMbMjbC?=
 =?us-ascii?Q?+Zq968zgcLC4SZKGMUKHTlg49o2TICCRfv/I4dhocA86kY1uraQ4eUSxb0Y0?=
 =?us-ascii?Q?hmOz2I+Fp3RRztcUrdB6oB1mCt3q5/HK6Uj+u3wSiQKWrlItrJGqQ5J3Ch7Z?=
 =?us-ascii?Q?0hsJ318eZ5oW7/2ZX67JvIe0Wb7C1sjeFK6/wjooAmsZ1YGve9YRTC9rmTx3?=
 =?us-ascii?Q?43CYOY9wXtoKnAta6BwX5hzixd3SBrIfkgCYh7Jrs2iSJZQgBUUyNKoOq+5F?=
 =?us-ascii?Q?WZx0nuuT6YYjAqK+W7IwO9+24zSYmgaAA2VhBd0HOuyjbGjEEdVJ2OW9n0pz?=
 =?us-ascii?Q?8lYjNB9SnXLe++TEpnJ8dW1Z2ttibAAS0nYws4nsr9Zg7bE+Wrb+BIfKxJx6?=
 =?us-ascii?Q?rvaUeFMpSulXNqUDm0Qch3Y4M9QVU5+6Sk6J0pc+oWnmuZWh5jFLpzZvnlmL?=
 =?us-ascii?Q?ECqPQrCzMbPeKQL8ksXCHkVWcCwKNh938MYO6PNXROsiQrnjS9m1/SCvKDtY?=
 =?us-ascii?Q?JQrInzDjjhf3tFjoQgONjPXk64RFt0XMUvrSCO/IEGoj6GPW4qw1QzM3yknL?=
 =?us-ascii?Q?YRRDzazhtd5VMhgVp6HliWLIs7255p0aOo9G9ekNEM60TVJxOp3FW3wIN35f?=
 =?us-ascii?Q?X/HSPt4MwUmc1aGuSVs4AuNQ7PtQcbgf/ngMDMY/QFK/Nf3vsJuvDZ5qRfmo?=
 =?us-ascii?Q?vUt2q8JM8OF2dKiwnEkhHAqJOVghZX4tFtMwYgj2e6r+SRtyhZZ4bVwsh6Tb?=
 =?us-ascii?Q?rQzjWTtixocmTwEuXgAIgyr0Sgd/diDDegjX33pJxiB97BUvkcIerJxhIj1G?=
 =?us-ascii?Q?UBuEC/qQSeeiRTHekqkpF0AkW79iUZ4x1W99F5pNoYys0gerfj+efXKXoLw7?=
 =?us-ascii?Q?Y7tZlPadKUcNLghAwUrRmclGk6Ah5QZj9rKR6E9a/jK7UtxFG6+Wx1eCxcdv?=
 =?us-ascii?Q?oFAUhLIJ1SY4HSyAZRSAkRMs3F3UkL8NCDbrSDBaeUqG6Uwjc/2e/lUuJTCb?=
 =?us-ascii?Q?7zVAy5SeqcJByazAgz5XMuAj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gkkcUnmLK1UWIaynPmaZbnYAwXhABQ1HkGgSYdH4TvDZf2Z6D6B6khqQDa9O?=
 =?us-ascii?Q?KAMeUyvg/T57B+4ZZQrHlssbRE73Svpwtnyti1AkAlK9cuYrzCuVF/qDFDTL?=
 =?us-ascii?Q?hZ9HmCbyULB/yd6PR2kmm/JprCUDQZnQ8m18UU5JsKBsiIc0DHzLgSXC5YsT?=
 =?us-ascii?Q?BEucFCfXpIcp6lU07un3SjjWT+3vs5JgNr+DHSyNMUDr+QmWw7eU930R/pYE?=
 =?us-ascii?Q?bUD9AvGivmMYp0n2yTl5GQIRDgGbHLBeoqINk58p6xaMWDFNrvO5EInanKf/?=
 =?us-ascii?Q?NlpUYufT5WMLnSg/qswBwSnk/HCWkKrk96ZROJDRTyWsBvkgcN7W9qLqxpJO?=
 =?us-ascii?Q?p25lwlc7bwLOtOQaAdgxEcIcyIRnYx+RyQFmib7K4cQVcmOxGY5NZ1FeNOWj?=
 =?us-ascii?Q?HOvZQPWGMdhgZP4izlSqIU/i5t0nlXTvFdlWbquX/wRbY792SAFR5pMT4O4m?=
 =?us-ascii?Q?jhnaVICtVE1bCANUkBSNW7We9WeAuD7vayb42bfTTX73W2hSH/EQ6AoZGEZJ?=
 =?us-ascii?Q?a+72qEH1d4ayD9mFLIyVufxLS+aeAnOvzi1g8gw8pilCEFtwkMCH5zeXKNno?=
 =?us-ascii?Q?xzCp11OiPWzzVOxux8HtR2a4o9KWJX1Y+ca/JAp3WAY8BHxrXTguiUSNDQPA?=
 =?us-ascii?Q?0eBePb3LY5K4eTlPo2I2gtlBoUxcB1cNtk9Afi9L9Bex5TivyHsUpWZTeA/x?=
 =?us-ascii?Q?5+2FjMbWqb3yFmyGbwrn/hDoZST/TSA7mbisv01SSfOXBy56mJSF2+8QkcBi?=
 =?us-ascii?Q?vKVkMegV0y/oztUYwGzI60kMk50cXVcIR1Vm5GR0ioQkYknwb/1pLXAVRD1+?=
 =?us-ascii?Q?uFLSSP5HimoTc8z7ek8MSxjpE3km+rWeM8pDpEi6GZzwEeykuVyTntLT0qN1?=
 =?us-ascii?Q?aTOyoqXkpeuI/IMBjvivqsefE8VI7dG61MfU6PN79Nuwe6uhp/s6ETVbhGAt?=
 =?us-ascii?Q?MVBBStgh6hpBuh35DnYWOe+E6eG2sXBBACY5PKgbor2qYRXIbuqCTnX8/CAZ?=
 =?us-ascii?Q?qom0QUJ5FcEK03VmM7ExYvjV2T/xbmB77jHsC+NNQaIutvv+WjBrCdqrNYUs?=
 =?us-ascii?Q?OMONKsJsNr8Kws8/TFfNCUhZXfVsekTnqlHJjfOBvM2vOYPVzgizo+gJsi7w?=
 =?us-ascii?Q?Bb5iUXDSEYlwxbfq180gvwC3TNlLnlJTcmxmudXHLf1A6BVMT3J8BdYUvEje?=
 =?us-ascii?Q?nBxmK/pHOyCJcA3YWGz33ZSo39O5zySKZXj+jxxxYCE3bvTON7dUqYiE4pfq?=
 =?us-ascii?Q?kzWCMnzLl99W4pggqOJfTITt1yvAhD7IO/41uXGKL1s9yfRfVeOkl4Gj1ca/?=
 =?us-ascii?Q?rzJdHONEzCE337EKrClD1pLIz5DgzPXizOak6xFCgBZTTyrdZRs3640K06KG?=
 =?us-ascii?Q?xOKwmfS2mu9BhGgCo2PTx0WI/SLG+M5gKlRiBeo0vKPjBr+QWh6G+FAj7cIh?=
 =?us-ascii?Q?MYD9D33PR6F/rkAptdRXlNDzIc2Ag10agJ6UhJfjE70JUk0EUuxPuvsmDxTR?=
 =?us-ascii?Q?RU0EaiW78P3NhwQS8R+srVAdmC5KrZfzfsPD9b0iAAY3/Y8oThq5V7/6RZC7?=
 =?us-ascii?Q?qo6Zl/RaI3TvU0qbGpc8RZWBGvsd5pkS8IJhSi1Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3eed58-7a15-48de-5082-08dcf9a37ed6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 11:59:38.4192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7VG5r3ZvHyeBSZefR/SrCtTKkDMNAv6ANY0tIAw92nfeOiF7YUneSH2jp+e69Gk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9523

On Thu, Oct 31, 2024 at 02:28:12PM +0800, Zhangfei Gao wrote:

> > As for the implementation of the series, add driver support in ARM SMMUv3
> > for a real world use case.
> >
> > This series is on Github:
> > https://github.com/nicolinc/iommufd/commits/iommufd_viommu_p2-v6
> > (QEMU branch for testing will be provided in Jason's nesting series)
> 
> Thanks Nico
> 
> I tested on aarch64, functions are OK.
> 
> But with some hacks
> https://github.com/Linaro/linux-kernel-uadk/commit/22f47d6f3a34a0867a187473bd5ba0e0ee3395d4

Hmm, it seems like we should permit IOMMU_HWPT_FAULT_ID_VALID domain
creation on ARM?

Jason
