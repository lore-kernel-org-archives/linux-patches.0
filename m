Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E749E1E9B1A;
	Tue, 30 Sep 2025 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759233356; cv=fail; b=VbLPGXQponde6q/8fGbr/PGvf8x9d0svSsH9c32s0X/JHoUTndK5pelLRsthJQfNE2qJ9iF+FH5uNeA25yWWPMJ/4jwiVnR0xvbTtWGGUxpHnVBdTn8hNJcWvszq5i4599FvSzkVK7xoE2YyOm2YzPYGW0NVGqJ6AoEEIFJPu7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759233356; c=relaxed/simple;
	bh=dzGsDWVej7o/6Ak9Lq/zUN1ROuHGJMSUiYvdcuQKH74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bnudeDL5P2L7JrTQjY1rRGmsPAs+hVPoafwuEToRmZmKZYmfrS7mapuaN3B86xGO3YAy6bhn05tiwour3jXn7FJfFagNDk4FYLAk+HRWqKpHrZv/L+3TeZ5dWGnDcngzwp5XpXuO3c2njAp61poWeY9HLgou5EPftaUR/9Ia9Pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kL6oJ0lz; arc=fail smtp.client-ip=52.101.48.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kL6oJ0lz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PThlKleYlxpCNwbmtn9d2bZsiTBcg7Cry04bo4FWFkE8fYA/2G7BmdEgf04YrjW0OqDld0MIU3qWo0w+8u7+8M7675ZETtrwvSaVforizRN7ofeGNhC7dKW+nHDcrFXnuAJzlP4jrQMhozRg3EVyMwxu0tVALRGRDE2+lLhPb7f57TvYfC7jR/xPAyI50SXyDDu1jIUHQHpmz2TpQprBw+LrlRfmg8h4rxfFajeKNnUff7MW0/9lVqHLhHw5pgcSHwgDul1Vlu6B+Si6vuVti1mEpGFiT4rwEKYkHdkXX2szcHuA0RpLsvUz28AAOG8/8nwjjQZHHRjHMlYrpE+isw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZODfRXjDA6v09p+KxrBV/Rzo8UHeNRGKXL+qBvR7zU=;
 b=UspvPwqA1RMWZY662mRBrKQonew6kRk8DzuIvZMm6aPq2MqBS29t+xnwnn53NGZmi3LRjAeXTE1IehEiuV78TmL1fSdPHZhC5BN0eXAFn0cwppAKYv/fmH5y9Y3hmrUT5cyq4+3Bn+TTejiOo1syL3W50MboOwjFM6Jk11arXtEgry2GCUFJluzTZeTbFbQg9BimJKwlyWN6sLc4fdhMCDjnAm/7hu8sVExDi8go0niTK01TzndNW6WoMabeY8h0UTApPq//wiJY8MdcDijFVFhOjD4UovkNgapX5kDu+bRGzlYeRmE56HTFg7LYFYgXvHfe9bMJpb0sK0n2oqBzpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZODfRXjDA6v09p+KxrBV/Rzo8UHeNRGKXL+qBvR7zU=;
 b=kL6oJ0lzAMikIS56rZentZUAX7hylVcq/1c3xF9ZlMLxT6Kq+iG+0gEonkcfwUbVrJ6UjlNzEu0NkNlq5RZHnEuJWYEcHbJRgdCYAJUeNc9zCdp9b9qMw8qzLNcKEf9ov2YRaPFhpFPPMlqGnWLEUn1S3Qhcg4ELXG7naUrDodb5Y7Qe4eVLf+O4T6QIF47oe0sNlEXZT5VNJJRCy5e09TFsJr11vuwvK9ch2bvRxVC2lxMuq7rRjUvktLmJ8liwzojXIKrTI49uwUtyf1cLVQPbJlli8yOm0QkIsT6ks2ccBir48uJyRFmxXQPdAIgsAkJMLjG3Wvuvt5wSPjZSXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Tue, 30 Sep
 2025 11:55:50 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 11:55:50 +0000
Date: Tue, 30 Sep 2025 08:55:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 5/8] iommu/arm-smmu-v3: Pre-allocate a per-master
 invalidation array
Message-ID: <20250930115540.GF2942991@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <f5f635077b791b27b46ea41b5c86a52fd4549a44.1757373449.git.nicolinc@nvidia.com>
 <20250924213230.GQ2617119@nvidia.com>
 <aNrZ8z92CXs+J1pH@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNrZ8z92CXs+J1pH@Asurada-Nvidia>
X-ClientProxiedBy: SA0PR11CA0207.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::32) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 301cc5cb-08c6-4cb4-7e33-08de00184cf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lIcm8xLfG2TX/rb0Qf0JMY0Fz4nq84IPsRtbSXHjhJE9pue/87Rs8f8EIDw1?=
 =?us-ascii?Q?bwWVT7j6PyYMfrXgNjphgxVgRPO00aEIIexNL9Be3bch1gaW9f7EWW9GUJrS?=
 =?us-ascii?Q?xgOd9Z0VactKSanbLkEDsxjS0w8cjQ0j1Pqta3X70x03ia9797VqyLxOaVwj?=
 =?us-ascii?Q?Mx7+LnBUBmvCNgzeY2Oj+VPECAuv9DQQzTM+T9oWh9tgUs++sBTmo5gLYJO8?=
 =?us-ascii?Q?f41O/sxNIvFw9Nc5wulNxfj5FypeoSfbmyzUfwgYipXriw+v2HLV45YMDAJh?=
 =?us-ascii?Q?+kC+WtyumCgcZjboWUlwPv5Rb018T3T8V+fwUVtYX1XAWfs+TZI203mjL8Bc?=
 =?us-ascii?Q?Qcb42uIKt4r4dMnUwBTdMbwadzlrDo07nF2p7Tr/oVKFs7D7m6ln2HD3LS/C?=
 =?us-ascii?Q?9l9jPUkZ/a8qklzVbqKY/Pedig06n+S0jOmsqFWUgUGHknA+ObGAz/vTcYJC?=
 =?us-ascii?Q?lXbZpwVIgV/WPruvujt+UxqhDN9cGdR6+sMLbG98f5T+ceS/95gs7SuSyKLT?=
 =?us-ascii?Q?RnXQRUcOOfgPZAMV8Y25n0fHsG1bXaRp8UCiC9lG5ojNuv7Ef+g1H8sUG8xh?=
 =?us-ascii?Q?WKuv81NAdYLZ6zHQ2WjU5zaIYm13UctIwiVucE/Q8fHNh5okm08ka4yvTqUX?=
 =?us-ascii?Q?uVtwj7dHIQ0PzSPeEeGgJSvfnH5kHFWaXfBTy11pGH6EeHG3fUDWogUL95YU?=
 =?us-ascii?Q?UPZ0jFrqFaSDfaesLKaQfLE45U36GWvax7ibjFqXJ5XNDn9MXJA1YdUSXbcH?=
 =?us-ascii?Q?Oj+nyHg8ugyICyERAJkwe1Djlryw9kqi3MQEuSwzqYD0ruTMWLkzCxLfHT/g?=
 =?us-ascii?Q?PRsH6NBqC8fEvO412hajnGCAa7+wBUYnU/mIvUEE2Pg6yW+uLZxctSY7+HD2?=
 =?us-ascii?Q?Rdvco/mrIFnlkMR2hDgkszQv/pI4awpFTM/qY0SxKRM5eh/P5UuYfQiTiOJA?=
 =?us-ascii?Q?vyrDyrqU+9CC1JCiQJEAendWEvM4044t0dbeiSu2288h57MRAmW2QJRDB+DK?=
 =?us-ascii?Q?EUx7Ngd3Ke0wjEzTkrmkMA7QxkEHTFsfhdbuBiKspIAaad91bPfs5Nlv4Hbg?=
 =?us-ascii?Q?qncnnsexqYkp/XVmqYp5GMVT+HFdq3OZBgvufRgxVrWuCbHYheFEX3jl5wG5?=
 =?us-ascii?Q?S7aoXzV6wzxbIKwHVmo+idDHguGe0nWIinJzq16bPeJXanU7YuOEi99ZK9ev?=
 =?us-ascii?Q?sKzbewIlodEscHBKvcNK2F0PlgD8wcS5YmT/f2y8bKfGLbb5nw0WwZMqCKya?=
 =?us-ascii?Q?gx42a8SxH0BBrpnab577+nLdCrW38W75avPYh6w+2v/Li7CFoFHHyGx4uZkt?=
 =?us-ascii?Q?WeNgsDszy68MfvYON1M+uQ9qNYI4XQ1UI4hv8qNOlCKuZFnFeG8IzYNVnybg?=
 =?us-ascii?Q?kwGO8KUf//6is5joIO3yCRPahX25oerRl7iZ/Q1N61yDKrkMSCd7FsoAixFB?=
 =?us-ascii?Q?BEf8H146PiUo2Yz5r+P/3LFoZUe/F/Q8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WT3WTiM82ofbH/u7/mnGKvjv1E5towcvGac8how+WwFEGIWZ1CqleRAyeGTf?=
 =?us-ascii?Q?mkPT1BDaRClwa96cYPH3TYuCmNxi1KCLXQqfLoSHsGTg01d5HN00Ik619KYL?=
 =?us-ascii?Q?qbJqo1nVEqPjyXWXGcfvn/VRE+3nb4Yc7nzdXAa1BX545UC411IfaxCdiIQI?=
 =?us-ascii?Q?634Kx41vkA0OMKB4VANpy5mtenEFJFeQcKqZkTcnstirdrQ94AzuCBwA/nNP?=
 =?us-ascii?Q?H6Jnb6EGk+MgZ9oDjj+4nMOfAzsHBUESGTEmE7MYDCKHdbzC5ptlv6+ZR3Qo?=
 =?us-ascii?Q?VouQVKO1l22tFpb1Tw+wiO8kz4YXQe05FjLZU7/+732rK318cFqCKtQzm3oX?=
 =?us-ascii?Q?MJAVUmjkkyuFZosr7VKzL3oO0Sr0IH/Or39jflwrUkH/llrwlxCQNifTKWNQ?=
 =?us-ascii?Q?SEbhcaPdhivEm/Rb507u8JhM7xkd7DjwucD1x/v7RRmGKx8pTtb1dLS28fwn?=
 =?us-ascii?Q?INyJNeqFXNEqu4MUdhQnsx9Nzxs9/dKxB+Kz1RjoGi7JIEn1t5Pap25AKRnF?=
 =?us-ascii?Q?n/SVT9n+j8B4COku0vI+7X6xl379ujOkCz6GeACSzdca0txu89vGPpr+c8TL?=
 =?us-ascii?Q?mrTm2VQE+WEX9k8jgdSFWIM5m14V0txIc+CQgRmSdzovK/REeHU3klskrXl0?=
 =?us-ascii?Q?dZJE3C4Pw5krqWKflyEOL8v1ljj3DDjtL2GuARSGSlaxsPbyY48W3h3ywXm8?=
 =?us-ascii?Q?jdMp6kcRtZObIGyyLHME6sGzHd9jBks0twQQ5MX+ItHMFYtQPMo8A1EI0Q1N?=
 =?us-ascii?Q?TVaI2Q19BvzwM71aZv0bp+d+V6kIsR/FH/hgu0caVhXx2o8SehnFnSZVMdfl?=
 =?us-ascii?Q?Gvyz+KjicsJhrw/ni9czyWl/BrSb7dKt14q7eM9yZlnP8y12tfqmr/Od6K0d?=
 =?us-ascii?Q?8tev6p6pgt1jfyiCpmPj/52aGWmjpeEW0bHOW1b56HKr2MRxCSGEPKLYABG1?=
 =?us-ascii?Q?03SY4+0WsLRYQzF4usojWb6S7rDIKF4VsyFZ7VcbodJsRKjkrg0r876DyKei?=
 =?us-ascii?Q?YIZZBCsb47lRqmxIn/QxLSTsnjb9WQaziP1I81qalmoUInAqo/IgXQhEdqJ+?=
 =?us-ascii?Q?WKPVwPWeCcFH1WyPl9XXrxa+0FEVfE4klioIptAwx3Tn3ZzAQ0U+v29VyWv0?=
 =?us-ascii?Q?UgReN4GusvHe6w4tm0FSDurRgKbFhYd/rwnU34CEUTrBJDa4NgKNLTXgrLGm?=
 =?us-ascii?Q?2qRXXfkyLzJuXhYV+at4ZS8VxmWfzsvjlstCxVlmcmBVLv2/7T5L+luzKmHq?=
 =?us-ascii?Q?FFmfDteFrR4Nbogp9UVF8xlGP6lEK4lZ+id+JUVudiJp20+pULiO6wat4/qM?=
 =?us-ascii?Q?IZNOqk5mW5ghifxPak6uhlLFKh+nDWWnZHDqAruEUCQalEmMfo8myl7UdGwI?=
 =?us-ascii?Q?XcMNg8et5o630ipUkjQYIA6E65J+VpSRSZgWmkrL0n7XbsRqg8Xo8JIUeDs7?=
 =?us-ascii?Q?9uhJwlO5iH2hJSVAoxKZwm3dkUvaRr1BCNIv5PpeQjyDwIH8p+94VZbsn5D7?=
 =?us-ascii?Q?Lb8P4wYG1y+iqLEsst79uyU3LpYnR2h6cCoYyBjW6O+Bw3R/f7EcxSilEWHe?=
 =?us-ascii?Q?MYy9PKShF9AtY1PynyqeaglNIIsHUuUv9FB9jvCx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301cc5cb-08c6-4cb4-7e33-08de00184cf4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 11:55:50.5212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofbKQ1yaxcubIJoPBBJph6r9c5O4zakjQQeiufvx3zc/q1OnXjVL0z2bmUy6v9sj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

On Mon, Sep 29, 2025 at 12:11:47PM -0700, Nicolin Chen wrote:
 
> Hmm, I am not sure how it insures against anything concurrent.

Yes, not concurrent, just if someone is later looking at the IDs list
and expecting it to be in a certain order. I could not find such a
thing so I think it is safe.

Jason
