Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F14830E0F7;
	Mon,  8 Sep 2025 15:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757345960; cv=fail; b=QMrWdnfiymrCmR7dx+Ua2eq+gGt4eZ6S/qd9TkpxpWkel+9fYqjKf8eYJs7uSKJDa8mDTtWMNFcZ4qgn0yosREezDNnQ3QhdpKZ1PeJk4me/f1ul3Ix7I2tuwZ+uZbV0Hz8LX5fxZgT/oTYNHpz/kDUQsoyF6Yug2glOudAEkN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757345960; c=relaxed/simple;
	bh=I1OH9kZQNXVbA14sfyoHVW6aOJTsAtEP8qZoMnZpgdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nX4Z0loXdafdVKF/pS21veSNDbaXrqhFpEuYLCRD1BBIeltJMpr4pSSaGss/aS1gfAOnqxqCXntVh9FuJGD00kCq1q7tD8AzAhJNoeYp5Ewpvxpo8aFUUSzzEyZ+TnnG/Z8eDow44Yn49Vc7SERt2Zc1dNuYufo5dgMgtuaxjes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lX237lfR; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lX237lfR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=naAX4jAvfJcBRypilvNqsV4roVvQ6r6fG2ZrqF3Ld9A78e1mJNIaX6s7AG+g/0dSLiGzrbUjEE7crrnzpmSIUN4KYnFe9NTT63aMkrFCh8RkS6w6B0bFKHEphodu3gUDBgw1tPL4eD+gu/ROt2HioMAQqqd8Vi1venGNVXrqUcjxwEcB6nqhyyYTdgqJV5We2F/KjRFsuuuzUgf6kd3EHZ75JC0HPHCIyg37TsMgp7S29qOEIT0Sn10uWjBcIRVs32JV63CIELy8A0uILzmlEg5I8TgnAv0xQf+7Vb/nJ3z6vOJkAF0zoNspCmobgzbe5JZaNgMrVY3MM4a1O+wmJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1OH9kZQNXVbA14sfyoHVW6aOJTsAtEP8qZoMnZpgdY=;
 b=GK0L/bjsQ1NyCDPS4BqY/+/yEpU8wClp4IL7yNF2teuVc1Gf/SdTeeSlnyWkYcS7RmAMIIOBW3Ee/Oc8I8YSGT/mBNAmtDBi9tNYXl08TBb7EYCtv2UjXTAPQ4Kn7WDOPa3XwI37UAa3HnFS5TDVjVCHS5JSRKfg1n8d7jh5Bcf6EDAgiIzEG7UO8YaCx6x4cKOUaD6idIwjFDwlhOidqa+cqWMXOteMPoNK9gMbyLmbhO1dqGPbjeEM12Muxlxf8fIQaI7OU/aB6sNW7IbOLMe0Kc+w6Jq+lGbzFM4YF4nCqNDvahF+NksCBpt6yY6S95YVF5jDtAogA6MhamM1nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1OH9kZQNXVbA14sfyoHVW6aOJTsAtEP8qZoMnZpgdY=;
 b=lX237lfRkluNwr1FjgYYqbtLTenABjIGUYH4A0Kb5TL149WWfjw3B0whBcj6+Y/Pm8SuPT6GTTFnFps4OCOjDFWP56lzyvYkeMPbyorQgof7bkDvrHuaPt0CC85z9DZrX77wMK66mLY0HftAomJ9qVusuiLKkVstK5CvHsg0l728QOeR1+M0uIB3pIiZ4+Zll4X/geFIXg5ORFaiW7QGyFOYajHR50cFJjUkwuBV5F/sqywi7C4KQjXb5dWrUKH8jdPo7HyIRQdx4GxG/TRfGJx7hGQDw6OegHkB6jQT1vvnP4TQhTCeWsC6OY77U23CXR10XF/RYCBotpIw+U17Lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15)
 by CY8PR12MB8362.namprd12.prod.outlook.com (2603:10b6:930:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 15:39:13 +0000
Received: from BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2]) by BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2%6]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 15:39:13 +0000
Date: Mon, 8 Sep 2025 12:39:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based
 arm_smmu_domain_inv_range()
Message-ID: <20250908153911.GC789684@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <8c4c5aec144f65cfd1fcef2eafb395876dac97ec.1755131672.git.nicolinc@nvidia.com>
 <20250827184923.GC2206304@nvidia.com>
 <aLvs8WrxEHpykCT/@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLvs8WrxEHpykCT/@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0072.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::11) To BL1PR12MB5753.namprd12.prod.outlook.com
 (2603:10b6:208:390::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_|CY8PR12MB8362:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc69d12-86d6-4759-d671-08ddeeeddc6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+UB6nSPDf6wU0LjgeMyScsjJJPukIsWNUX4GxOGFKNtJmHf1R9lT146RzjJD?=
 =?us-ascii?Q?71tbuPalROfLirDWSPNinouwWITFcXIxBBTJC4jm5udxPiszMoIg8TomixKk?=
 =?us-ascii?Q?c/S+ggnChiHs1bca/DnCtdpGoexwd6ZGF6IAc1Ttl8TDl60FnbGFIE1bSm31?=
 =?us-ascii?Q?a5bPCA7AucwQLVOPHYJ6CbOzBxfl5ic1qA7xEfmhC9Wi6xCxm6C3to9DNq8s?=
 =?us-ascii?Q?7uFTRjVB1SY85Vi0E1u7kSyOMWBvHkrdJ92ol0AV9RkjWWBIqF2cMR+Nq71V?=
 =?us-ascii?Q?dNwczOnnPLoSF0LZFfzAK20CZMDTRQHYWnEZWNfwV1CHOOhvFLvcjb38gJAy?=
 =?us-ascii?Q?vDbjHV91Livu6yv1mQrJBit7jNYcvdYAqOHPXJfHdgRzeSHxIzKZgmyYatJ0?=
 =?us-ascii?Q?07v+Vac7Vp8Y/+vpJbFRUzoKBVDMA80vZrnL/vbjoo0KdIr6LvBfBXvKbN4g?=
 =?us-ascii?Q?TCHjpIrCpOQzaMc8dpVzoLYAQZ4y8BWc/2JRaYvM5XnC56l36R3VXgNXApfd?=
 =?us-ascii?Q?RMEtgMkZs+DjA/g6uBS88rwf4bjwzQhs9DoSE3HNBPgjqEtin3lpStxUy1cz?=
 =?us-ascii?Q?YHA4uKJXwS/qFtFigJxZWqH1d+4PMzpes0qhRcubXbA8YePePXz7XLluFqHZ?=
 =?us-ascii?Q?A+MnYHFS1F1kWc+wbZZGSZK04e6mbHp7YKdBnnSxvgn0+KubpxqDwed/7nMC?=
 =?us-ascii?Q?C4PqbcHqoVYn1aXnGszTTvwgjgOKECKjBlwP/pgEXTqB656OwQlsuOWfnaLj?=
 =?us-ascii?Q?ux7sdxsjHcK5Cmn5J6JNKHhRLeVyy07kYulOBOnyrG0/jBID6QjyUIdpTFKi?=
 =?us-ascii?Q?FQHzBS9dFpBsbFz7oOR1l7h0h6W04mtD3SstHWgJeATMUwK9gn38rY6MkvrP?=
 =?us-ascii?Q?lk8fJtPFBjMqI+3mRH/QQFBTk+4HV6EcZevoEDejt7JoeBF/QzzxHLXxb9sV?=
 =?us-ascii?Q?Lx+iuO9GcYCx0AuvHZAU0P3QxVhZRgg/2nKtGswMYqT9fnwbR05+xVpngfGT?=
 =?us-ascii?Q?DkFRQMqCq61NIn4OT87kaHWKg/DRUja9Wj5kktM/7b/AmJkNDDzlJPWtKJAN?=
 =?us-ascii?Q?aI01HhGa94p0tqWf09OGacEBfX6jwRl0PjFgFx6opDasVafSVRgs3ianAXTy?=
 =?us-ascii?Q?114oo9f5ePFfXWfm4O6ay/d+FuihUM1P+6+tTlOndkqYqQNA8AXCHPiKCSDI?=
 =?us-ascii?Q?uRkw/79YeGTme11y6xQAXraCzlRY+ao8AC33q3PSuqjZKXj+NtuJB16hksLO?=
 =?us-ascii?Q?ypb8sTr9cphfbrx+Qio+EwQmygD6rPz9XO0ASLhqmCJ4snJY2e3QffMfhqPh?=
 =?us-ascii?Q?MWgjSyPdVd2jKluYVPu6T57+9OtoyIYZAEsWuFdejUWogf+t2OgSY8ix8Bo6?=
 =?us-ascii?Q?W+1DfMY7JXoQ6w7/BKU4IalN61vBf8i9Qw4po+u5B+drZAqB0iVpFhEGlofL?=
 =?us-ascii?Q?2VkAXoDc+CG5jf+aScUBj2FwxoMWp6a5YpZJuTHtkfsgzi2Fvr1XeQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+pn+yYC0bExRCrchG/C0aRGR3MM6L65yaQWszoUsDwjfqsN6Nm0IfGiK+2I2?=
 =?us-ascii?Q?3SMc+5RhbCBzu2hvSzS2VSTiLPNoVrK6WOxca5UVvvg2jV85Et2V/c9JLHDM?=
 =?us-ascii?Q?t6+OjV7xofxGKFUWft49d7VwpzaG2JT3G8ggl+Gaem18ERYxqg3P+YOluNBp?=
 =?us-ascii?Q?qogLNv0Lcxbe3A5cg4lhVD3RgyBYRhf0e1sHQSnrtoXHdHaHPFU5RC/9NcQy?=
 =?us-ascii?Q?XByhvhley6a6RhQCtk0cuO9crbmZqAFlHqt1Hpsh7AxxJU5Ri8autHX34CBY?=
 =?us-ascii?Q?9qsa+rf5c55b2lBSEKijBWbL9Ww96Fxc0V7AFZE/vfbC32segUGImlSxlPZR?=
 =?us-ascii?Q?x1ocezWXP0DNxKQ0e54Bu9DIVI86hE0X9DKPpmFe0/rgyDcpPdufCKEmYHp2?=
 =?us-ascii?Q?FA7hWMiQaLsT2kscQ5QQ5FfRpu2wn1ZqJPCG0z+lCYObgWbPROP93R7/dCKR?=
 =?us-ascii?Q?1iXNDrbC7BAi/aJ4hKHCPkBqb+GE85aiJU5JdmScISCq6qstS+QmH0CUrRlY?=
 =?us-ascii?Q?OvOygsag27BgwRUc2AoBlKgEes0EIDuHL+rRjgoneN03o9MYooXAZkaAkzSB?=
 =?us-ascii?Q?Dm05B5ydSC4ZaHIZRZIIbpEN3GWxDhGsxmeadfurvkXpaILdkqD20ecARX7y?=
 =?us-ascii?Q?ICnQMqDVBqT/RbTI2a2r3J2VqoQiJOQ17S04p65kzfoZTp1CSDFPMXdIkpxL?=
 =?us-ascii?Q?nZn3uHJ7WBOUqPUuczTwWw8GS9NHtJ50OTvDycCi+krJ3DzpnuzCp0Q5gxiV?=
 =?us-ascii?Q?Uxdy1wL6sTMxbVc4iurOrCVJ4Dgyzl+0hGYLAutu/P8xYAVfCwclrME5FBcP?=
 =?us-ascii?Q?Y1qpSOQzfSa3r1sZRDO9Y29BVs9gGfoj7+J+InAAADgSzHjQ/G3rZXfqnaK+?=
 =?us-ascii?Q?ZyS/tvCMk8taB38Qd5vFQXPDPAMQZh81B4rADeSIA3Na/SHmeu1LJHwgcdGe?=
 =?us-ascii?Q?b+YW123dWmniITZTaSd6o6WzG+UgZHRb2mMj+HmFO5nCak0wUBXWMret2r6s?=
 =?us-ascii?Q?0Wa3BQxRGl2f7isigwPcii52wjFBbkQX93YQopS52r3Ux4azTbrG4ZbFwDkd?=
 =?us-ascii?Q?8cVVArQxnxLJNvVQJ5UgtZ8Ob8Ps+8I37cx+iPTWM+S4nKfhRGe9d4n/b5T+?=
 =?us-ascii?Q?zU2H+xGYdwZliSVRZVjXIuY8KPoRt36bZBhc1SmWakJIb4QXAgOVRceJBPwp?=
 =?us-ascii?Q?V6Nwm0HagE63b23iZhT/MZgVpHGNFnRPytcpbhWFtNaNYbBJLTzxCqwlUUcr?=
 =?us-ascii?Q?1X2J60x5uN8T3+R5niJx+bTp7B5S4kwk+wOwRjiZ7szD2VKHijuJnI1ETALG?=
 =?us-ascii?Q?pBk+LhUT0QEdnBi7EZWAA5NTtPsoiIKpl9rODn/QQ6tzaitxuTjZVbsStvWe?=
 =?us-ascii?Q?+mAJJGGLixtv2qYjt3avYYxVQA/ZK0AnsnObU3F6VlsL3racTV65HvzKKL7Y?=
 =?us-ascii?Q?XjH1iJ4qKzIxBBh255SyQRoSjUeQZdtuNbfOp2cBMmnb9Awty9nMm4KaKBtV?=
 =?us-ascii?Q?n87WH/XxtPtYUDpH6bcCUxdovyPttLuqKZCsg/B98Es0mnEPQDiuSTpAIPL/?=
 =?us-ascii?Q?7V2II1gIYLSgP6zm2+A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc69d12-86d6-4759-d671-08ddeeeddc6a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:39:13.1575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ab6QBonWX2HWK7q0VRmQXtn/FG+jawYMvj8ig6Zz1vAvOXP+BdQfFhtWEdXof8W1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8362

On Sat, Sep 06, 2025 at 01:12:33AM -0700, Nicolin Chen wrote:

> I know that performance-wise, this piece will be a quick respin,
> as the attach side releases the lock very fast. It still looks
> a bit complicated. And practically, it would respin even if the
> attachment removes a non-PCI device, right?

If you are paying the cost of taking the lock then it should become
fully locked and consistent.

Jason
