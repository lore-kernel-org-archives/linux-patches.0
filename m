Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A883CAE93;
	Tue, 14 Apr 2026 23:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776209773; cv=fail; b=ZTJynixlgIJaxyaMDdmpLJLCqKbSEj4utgYrVlgltrDQbI/9SGryV4ZnKgdT56HCaE0cIBoOH/YDYQaB/1SjhHxoamb0QgFNj90VZ3fRfiD08wWIHHLmuA+AACHjxgBwE61GtPAPhM+njXHMIAwOy8X/az+RQfqli6e70BbLlTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776209773; c=relaxed/simple;
	bh=MS4ksocNkAghTca7ZFM6zVIb3niYK+wdrmmHAtQC5H0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XOSVzMVHVv6V6yVYHzcTLIZrRZWlx8EDlg6/yFshwfNiJ7mTlQRoZ8HQXzdyIAAb1eEMeqBuXxLJC1m62U9xrnlUDEgt15nlhG9ZbprblQEz+oy/NSEFmhF97ajsp1aTfVEAKNxzbt/v06QQZp9mTLbbpR/riRoLt6LTTLNHkgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ihod5wVg; arc=fail smtp.client-ip=40.93.196.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ihod5wVg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJYyjG6ObEYCUXlQNIVpNaUSvhO2mvoSZYbqwQht23zgj+z0rK4QXa4CTfJu2PKi2xKc4gtW1c83Hgwuq5POIwR2IA00rHrlssYcKc+1+C/rnH4174tfokHSZH6T1wP5+7jkuWbRc4sx3Efzc4rY3Z3ORg16fngvAQH+Bi/OjfNJaNekd4g1sYgOTmVEnoQL+DLBfu50V5VhC1fACD07D2q3LW/ogUPOxt63ZeDMJKAnNExyHILCgdheu4iRNOdKvszzidXY06GKMnEQMKTjH9VL9Gxb5XbIASb6HifiAnuMHMKK+zYNtff9paPoBjLDgno461GL7uaLBHHj2uN0/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9JwxEgo5il0cnoCNjP+oLbLkU6w41cqepBLD7xzSxM=;
 b=aj8QJkOVwVoUHnigNXWiRWPRpvYGzFy4hYX29ddDd4b7ncIrgWhmBfNZRC8qdJCcNxb45xT1OvIPYRHN5mmtoldwG9NvwuHczCB6qLxC8z+zT8lSOIKGCN3byuqUYYSIt3ZQyJ757suuvimhtCZUE6dOKEcYdednQFdHtPjIttBtsHGbb4bKGQnf0pqVmOALsM+amsoVl3yzeSx9YvAxOHQze9fV2h2fssgTaN0k1KtJFKqPeOOFpKbQ3b7X3/NXg0rk/7rd6aMYO6LKj7ZNHrtrjPC02FTUqJLNSwt1zfwMb2+FQvAO5JtAuOzpXUPQvtPUnGXrB0DY+9AcMwyR3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9JwxEgo5il0cnoCNjP+oLbLkU6w41cqepBLD7xzSxM=;
 b=ihod5wVg9Fgr5XlZ5WWXrea2x9pSP2Ll7l8xDReAqyiwkHMLShdox3jlsfrkXIlzH67uj6X+TytnKODVcs1/1ffu3j6d94nb1hXD8vjbIxCJWYA0ggv9STniVVAcUngn4QcKjtZQnzBN6x82UlxbUUzIsVt0+gtqbRrJFFrlBHEiA/JtamG/tMtJy8bUtKahP9rfS1mWaKc9QeMoUeBNShGnn9akUJloJTdNNW6XuSP9rwhiYxWVq4Ed4AFwLgZyvjz4kQxK2ooapMxDfpYxZsBJ5aAbOhZvEDPEyKU9Uar+wJDYOEZW3vrad0HFQPKYmJr8ahRczbhEc4JgzwyUCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH0PR12MB7012.namprd12.prod.outlook.com (2603:10b6:510:21c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Tue, 14 Apr
 2026 23:36:08 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9818.017; Tue, 14 Apr 2026
 23:36:08 +0000
Date: Tue, 14 Apr 2026 20:36:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, joro@8bytes.org, patches@lists.linux.dev,
	robin.murphy@arm.com, suravee.suthikulpanit@amd.com,
	wei.w.wang@hotmail.com, will@kernel.org, kpsingh@kernel.org,
	josef@toxicpanda.com
Subject: Re: [PATCH v1 1/1] iommu/amd: Don't split flush for
 amd_iommu_domain_flush_all()
Message-ID: <20260414233607.GK2588311@nvidia.com>
References: <20260414210626.2097722-1-wnliu@google.com>
 <20260414210626.2097722-2-wnliu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414210626.2097722-2-wnliu@google.com>
X-ClientProxiedBy: BL1P221CA0010.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::14) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH0PR12MB7012:EE_
X-MS-Office365-Filtering-Correlation-Id: 368fada7-29b4-4ed6-02f2-08de9a7e9ab5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KwuuY9XSe45N/V0DYA/bIYc6mgjed8GXNVs+rvme14CnKKsi71wJXyPvunJAjiJGkYdZqX4V1MQwczYJqwknfijxSo6xEuei0ADxbSPjqnlNzjW9QXE7LaNfDvYR7LY2GxSDrGMGsugDLd1cC4dvZkmkXF0nOaFc51qbb97E+GOAVd+UsauXODiyppL39fuFWKszFiWkniUVt4FRtWVC/i+k9ZKmr9F/XqLT5GYPNBwWY5CytQUXpM4xY4SxxiRlGFgFP9MiLIBvZ0Yc2ps/OU15XTCxp3HBXxZDYzMU+seiE+iw5LPm5OOP1/hjFEMnN5R0Y0Qsso5abcq7rkZ/5W+6PqdMNaBd0I/Ea0jfKNglHJeM2z7BtpkkX7SesUwAbWdcIlcc+oqkkm5GkL9p7/5OeuW+4Ljla+tyMarCrpwkBorVCt+CRbibEUbbXJOWGajvQf4pTqvE/J3ZBZ6/0r0QSzNOlnBcJUbzHxVEfKzKjxJLEjodoVKl+qHAKtTEgnS3v5E58Usej9KTmQ1AK/jrgg4TuFClOOya1q+r4oKZlj3NAvFlFnPl/L46tGA+1I9mrApbODuQqv95XYSQW6+pU8YI6knp/RSNsFOAVzQzp156EWovGsePIIrmdRaKUkskj0iNSfBnIf8ZNPtr2Kq8BSyCiyv0M4gIaK1v2cCQS+MvLKC2RZOxIsCv11JmcSCwxKwdXupyWW9i8VrdIGsi/rLMAEI0ZCcDsC63fz4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1od0axmuCmLgjpSi88Zq38LV0XT3N8ov/Zv7IbuxvWXFvYhNukjplrbavw28?=
 =?us-ascii?Q?9COWnS4fhW9vbZYGI4lidux59+J2zvZeY18LN4zMPGEMOsRXLzMSygLlrBqm?=
 =?us-ascii?Q?RMntmHkMbvtgZx3teb5c4bL2cFfQyp8LfzGrXhnC0nIdfSuEQ+XYA2YmNrM8?=
 =?us-ascii?Q?MEwx/Gj1929+PHUjEmL9H5imeOgvUNjt3DIUp7LJlbmgR4UhS1S192l1CICD?=
 =?us-ascii?Q?H/rWagojxxu3sFpnYU5T6ceDjeqIQRyWTMYAondtmHsD6hwMDz/kZQrxBO6Q?=
 =?us-ascii?Q?jPmrg6b9nKbQ24GCGBbe56mlMRrK05ljddGgA35jOdApyj/Usu8y/lt+ffRj?=
 =?us-ascii?Q?MUcuNEnz9v0N/CD4mT8wBDTmFJ/D+AECU/kx/Gik/hoDUCsu9HUGDBeJznRb?=
 =?us-ascii?Q?SdwtUCAHp3t1JAtWPz8PdtwH1xCzc0V0w3CBfwh7E3zniBAXgQdMvxo6V5nq?=
 =?us-ascii?Q?ruF/XRE9sTvnbdrTkKQdnZPo2VN0JrwtztlfAs03zTdd8sJhLBK8WWbbb/KI?=
 =?us-ascii?Q?DvOpBu3n+3QbyU4Nm5QgFOpslOCcoENMtTaQuHE/PYxitfrgI6/as3KeLNXr?=
 =?us-ascii?Q?D8T4HcZDoHlA/ftJmOtF9Bz0/S5B/T+rHLZE61gM9u0SUYgJOGt15ajDVHsV?=
 =?us-ascii?Q?LY+POEl/Ld84Wodk7UWXn2CWAAXFQUW1JPhLhYHlpavjskyMN0t4RowH9fQI?=
 =?us-ascii?Q?uZiqKAm8n5fyHUcvVfK1asDtqdJDJRvtCIuekkWE1Sh/mm/DUuUaLvVQvSj2?=
 =?us-ascii?Q?RWdahd5cX6aOGzszuWPV8MfyWT4ZjI+ghZSAy609fvvKr5DlrHqERWBjs3nr?=
 =?us-ascii?Q?dsJ9h0Bu/cpL0+2cQDIn7BBtxki/uD2+qfmrr2ZN2edfltkU9b04CBe9uCOH?=
 =?us-ascii?Q?Yd/OEIM7GyKv1rphf3OjiRU32W1Zy0M9MWKYnQX2Z2wCxVw86ZI/Dffp+CyD?=
 =?us-ascii?Q?XrlFiBqqEe34sIRZC84GPysDR8y/PTtBR7B8Irq21D9kCzcfOC5aY/a/1Kno?=
 =?us-ascii?Q?EbBKLs9ox89o7TFAWjEvrUzHa0OEHJdNB56VlvOhpdbYIDpn4dB7Lf40qU7T?=
 =?us-ascii?Q?7dz0cgUJuivgqnIdH4KdgmMraPl/Dd2+gBgeOE5L6arxmprv3xnFzz1JWqqe?=
 =?us-ascii?Q?ZYSJbHpZpKOzwe9lPZh9xkZHOELQzU9SxYOneD3IZJXn2D+h7chtHLmlPfva?=
 =?us-ascii?Q?SZD0sZmxeZGIlM3tNy3NydNgBmf/eBa4nF56QVAgxlz0aMnTQcpymCbhNJ1z?=
 =?us-ascii?Q?7Y7zHR+xbxeW8HxsOghxjK95Z7yrtzPpp+sJmiXUDDveGI8RfLIVc9kMZucT?=
 =?us-ascii?Q?8JJ7D/2BsTJIIPjd+3BF3VffZVuHqQwkurnpc1Yw77PS0OfYu/SGYwcrKMbA?=
 =?us-ascii?Q?rfLoG6UF8p5h8m0uWyw/DNKujYs40yKTQ6TYlGDjkPPKgO8le55GU76Q/4We?=
 =?us-ascii?Q?F7D+ZHsNSyR0FkPmobNpoqC0NnKqTFKcUl3FJRkh7guT2f+6KC1Z01w3foCu?=
 =?us-ascii?Q?DZGeI3ztdfz/69T8EeKpjgZIm8v6sisJeSPHJCogPdXlZbbTIh3Ih2BeYke7?=
 =?us-ascii?Q?lLnZELVXd+j4iOlLW0Wcv1WJT8X/JJcu9HGqXIxcIg2E4pZJrRijp47XihlW?=
 =?us-ascii?Q?q38kkfAxgXUem/D1gBueHMMs85TGdrqK74ddJgMUwQBlo0QoM5Hb4cxpwyHl?=
 =?us-ascii?Q?mJ5oRpwdRbO0JvwAYDYZcbFqkDCiqsFZZqLRg6QXkwQkGdfE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368fada7-29b4-4ed6-02f2-08de9a7e9ab5
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 23:36:08.6441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBNG+k7kicMMw44AnAxorK77oXlyvtN0Hw8EGbxwWAss2IllcOf7W/9arLl9mB4e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7012

On Tue, Apr 14, 2026 at 09:06:26PM +0000, Weinan Liu wrote:
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 760d5f4623b5..bcec8721d228 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1769,7 +1769,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>  {
>  	lockdep_assert_held(&domain->lock);
>  
> -	if (likely(!amd_iommu_np_cache)) {
> +	if (likely(!amd_iommu_np_cache) ||
> +		size == CMD_INV_IOMMU_ALL_PAGES_ADDRESS) {

This is better as size >= (1ULL<<52)

Which is the break point where it switches over to full invalidation
anyhow, there is no sense then in doing the special np flow..

Otherwise

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
