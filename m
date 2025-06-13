Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E7D347D5;
	Fri, 13 Jun 2025 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822330; cv=fail; b=JHlIzK33iPVKOiq8UYGod6YTZGR4p6p71oOd22OuLJl/6yhl+ElxRAIZZbI4MgTrv+DrALxjhQiyJvW3gA+S3W/7tZEzBL9MHmN3S+iasIu4sluhhD69xaSYkwJ9X0/4QcB6bXFxcj5UBadLLbMdXIpjymNY26amVF/ysLjjqnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822330; c=relaxed/simple;
	bh=GkPbDDW3Q4JQtMLtQ75vJ87oFfDrZi4Gg+v8TP7QQsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K/4PB6Im2jgIOkl/GqQNX0lwnHqog2eYS7LXXfjIcqppodOklkH9Er2cCXx3l4vBiFh8ZoYZO3UnCy+RUhTSZLu/bJi3JInvxHzRo+Cla2+9sg0oqeJ/YBPF4GJ/7yoe3kbbwzPWao7/VHEtTMqsxS/XE9856EfbjIED5ZdqGRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LF1bY8Ql; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LF1bY8Ql"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DZqDqYJqAoiDD4eFF46TQMeR9UMMfUdX63AaBVdmc2spUsmv+vBrzaF8pS2XpFHzkyacbl+G8I5SW6Sq0G+IgcaOJ0k7hM+CFyn2HnjV6uy9Uhwb76/Le1ZyQqEj7zsbqiJa55OkG4SVrCoM4xDx8aVpAFnB3aXBY6v1F82UJqfBpU9UYX/KCj+To7xwczWTEzXC7M52uOAypTf5tnImfH57qzE//Vh5CyWC4NdyaVhsFqtrSmSGMlqwqYRsM/kiB9PWI8PdYZhwULbx+NyIxIGDNuG0hHygNpxMFr9sV7Ycfd99alFwfw5ndtFYz+H9cJ2tqSo23BEDcbHgvVAzOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i13DgxYpxhpGgsgH3zFniKzIgPxRoE64KU7ECSy/GQ=;
 b=Y4Esc47o5vcTY0jtA/bvvaQwASwDOxbeLIFT80rPh66oPMEztVj801ixBBGrPhDro9wOWvmBcez48TzVo/g9ets+QZHig2wE26SGPLrpli13QpKhNPL1jBYW+Ior1aOi2uEmLIVYc4ZjTsV1RSQiLnL13iC53dcGwSEe2xmfIvlIGfFf6TwhfwcOKuEVpPoThPVzIbjSSMfHPemDtsHL4VoNm+bYgp0BctmOg/0lay2g4B81pG4NgiY3FJC2U+mFELskww9NJcKwjQvjJ3vmoH4rAiecNhBY2rBncf2pYuHQFwKdZ0MkiwoTPmflxVwAG+F+oT/p87E4nZhN+iWiXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i13DgxYpxhpGgsgH3zFniKzIgPxRoE64KU7ECSy/GQ=;
 b=LF1bY8QlmRN1Q35MyX33dop28U6PVcHm8HwmdswgrPWDa59pqZCvAG3UJ2UgGJVIjVEmluOQP6T24TrGEiuO96VCUp3sQ/YrXdVv+BzvrDe2OJmIf/bbYamd7eL8RVo9OWg6hAs6ZZrr1QSHALJyThXE57E3difNztljSDKVsKWFPNyXY1yUfb02OIO9Yv5gFMJNNhW0AtQYWK2mUM3fqQpnDSz6bvzt95kodsvRaahbMrd5jjMRLliqCHCvkAY50j5qk5yTd9tXozlobwDp3nk5jVYUOmKGmD1Zl5zYsjfBm0g4v4n4TukuSLkLo9aBPgBohXM1IzIKLnV/t/EPgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9221.namprd12.prod.outlook.com (2603:10b6:510:2e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Fri, 13 Jun
 2025 13:45:24 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:45:24 +0000
Date: Fri, 13 Jun 2025 10:45:22 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 06/12] iommufd/selftest: Implement
 mock_get_viommu_size and mock_viommu_init
Message-ID: <20250613134522.GE1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0325.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9221:EE_
X-MS-Office365-Filtering-Correlation-Id: 8913db40-f258-469e-995c-08ddaa808c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gVwv7v1MVr0MHZgjikYqN9v16NPz50QJPGiEz02rUQrHTYCWWRYEwpID284M?=
 =?us-ascii?Q?OIUNnR+RqeGea3MGhcUO8qcvYO76GiPIozhRpnVU3gCavxiMOAdgDWVFyCkr?=
 =?us-ascii?Q?N+0zbBWOP3NvgyQvtOIjWXdkB5Vu2GWuxsPtTj9lLf4lCZ02nLp/V+QI4j+u?=
 =?us-ascii?Q?LPiqVu43M5Gp5laKBhQxZZlW2mYEgTk48j02FID9znGKk9UJLi8EL4xH33K9?=
 =?us-ascii?Q?IHHDkIcoMvsCXt5RKp+qa/Ne4kL9teRqoiAAGXrR1uG13MHMQvy7hry+Cwc6?=
 =?us-ascii?Q?MPUOc2F6qlhIY3+jiNBHGuI+SDAvt33/wAJlzp9jAvVc0/IUPb3GIBmnluPf?=
 =?us-ascii?Q?jWzHx5J+wr7q1zhUgihm/k9qjfF/P0yvg+KFVDZpPndulGtOQEJl29+STsSu?=
 =?us-ascii?Q?gVmNcj1m7iqqdSmU/zI8JwWbdBa8sJzidn5tJH8P3Anz3qOEh+fFk5VlMisL?=
 =?us-ascii?Q?5AzvNk9cppBZ7E6LyHaM5HzxOzwjq0c/VgAKKr+j5g2XttuWOndyB42GY3A7?=
 =?us-ascii?Q?EsIxofjpyMHIA9HF2O9HkAX9yerdSAk8b/S9XYMx0jvDI530p08/ft18C3Nn?=
 =?us-ascii?Q?THp4Y74MDXSeQg5rzWMfX/A1XDcnWPDsKl8M6CG8RsFBgMB5Wz1593pw6uGM?=
 =?us-ascii?Q?oqg1E4nuFYhW6im3shYKvjYHS5CeZaGy4y7SexGWR/5RzZS4oVKvOj40CuF/?=
 =?us-ascii?Q?lSgE8l8DvnujoFUFabQWnu93Q/kbTMSrr8LFj+D6WJXQ7VWNtE2AnNjtAklQ?=
 =?us-ascii?Q?GYVx8jMiT9vEy4a2sJSJLQ+qJ2+r4BZT0svstkTD1zJbbceRhgQCJFganhnZ?=
 =?us-ascii?Q?1Ee1hxeYuclCVOuGCk5Ln0ByFTZ4ULLNQR8XVRzm+wtEX5heQQp/6PzfpF37?=
 =?us-ascii?Q?aYwJ3UuZW8Wz09HplsGYrGOMY/B8SXLKV9K1Kv34Wfk9beSGkud4VyLAMm+n?=
 =?us-ascii?Q?J7pgUcaeRW8ygRNNMkGbhLmPyo8uzEGhjN+6tbfUmWvLOA51GgqGifyAAOuc?=
 =?us-ascii?Q?tHVC6w2WeUFgPRPvK/csU7GxkrHM1R5gdtp490+OCnlb7QrBWMUwA3sgJb4K?=
 =?us-ascii?Q?OJKQyc+DFY7lP1U2jvuQRANIiUCgfCWtHB1UyUY1PYbLwGHmVCRkMvQcVmFC?=
 =?us-ascii?Q?671WucSc9IYaDeHV4ZJwKgMNAG+ckvpmO3nYp9c7dkM9rJEAP20xyYUMV15I?=
 =?us-ascii?Q?TzC1B78vFBp/MtVNSljdnixglROeIiD4XF3yJAXNzECo00b9TYDPM2x57G5c?=
 =?us-ascii?Q?vNSfYHyviy3gph6zkBKfTQKacpbr2dfDpBNUW8NfbYjV9/9b5dj9UVECAmMj?=
 =?us-ascii?Q?RiNGAGk18edNRgmsi/W2KoN67rXDnPwlK/ejyTvb9pCaptqvl9y1SM03qyDf?=
 =?us-ascii?Q?7sm3IM+LpnseYHBZX9Z5FkiPnJwZDx53jaLnHuFqEW8G0NwrUQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nNOwega/UFdM97fbIIhOUaSeAoACB1TbmrHVFBPegxmxNaCKM98SO9QOt5zc?=
 =?us-ascii?Q?c7MhZllbYJm/oswV3j+1/Bz+NrFsoGZJhv/2N8EDHoWlWLQbLwWVBkknDkSm?=
 =?us-ascii?Q?lfU5PDv4kr6AwrcUq1km95bAZ+5+lwuwNcwQf0bBxb4vwGKy5/kPJyoOzW6e?=
 =?us-ascii?Q?7O/N54AQ5k+D4ABcqVVXdJ5WqVhilZ7HkiGDKF0utZp68DtIwyl2UgDCmgyI?=
 =?us-ascii?Q?q4IriMI0G4ihCWj3QNBIgUXPuf0JNzRAm1nXHvB+k58QbIOc65ynfEUR/UzJ?=
 =?us-ascii?Q?V+zijSAi+hb+Duj9QgSQeT3KZcTk0G+jVrMv0mupstFGbdmtefNhSWsDamN0?=
 =?us-ascii?Q?DaV4KvXkEXCm0kvALqXcrzQsOhoquKk6iLIk9R+N7KY+j25vx+d0ceK7cCDF?=
 =?us-ascii?Q?lVMoEHGAgoSUW1SE8GptpwT7w2dmG09/dOEmoYlIRoWI7M09hs6WLAUYQk5A?=
 =?us-ascii?Q?Vdo+W4tEgNGaFOSUNyHexxBEOfwq6k6gltmGttxYmcr5ifo5dHecTqXqRJ9K?=
 =?us-ascii?Q?aFtCbeB8BvNfBHjWORQnqkCM1JTAy5NGmsGpeeP6r++ghFp/Uh7qNxKcTFC6?=
 =?us-ascii?Q?QJpQP/bLObqpw1cgL9Lp+PlSNRQhopSUJwyZJvLi4IVslawu9buxjGkrp/BC?=
 =?us-ascii?Q?T2Ch2loDOB6dUY2aiyekpCQdMESfc8a7MXUOhJB+R+yL1DNBZJC+QBtMxOT3?=
 =?us-ascii?Q?QQ/YBxmVLrBMvU1WpSSb4SoWEyb7zQeQyEDetmLbMs/hJka9KG9KeqjVzWsv?=
 =?us-ascii?Q?zADtPH6aAzjYAjQniwnVlUdL0d/cyybv4Fu2ML9UX83CykeHoNwhY18C8ZW2?=
 =?us-ascii?Q?s1ey0cjUjP5X+Gag9R3i5wqtjGGw5xJyvzP2IMZsKsRNyNpg4bsrz0CrPGuz?=
 =?us-ascii?Q?IyanMu3Rig6Wk/bgKs8ozOEZ0Qma+OiAqGJTSho6wDr27mgtuCDc6fOGYJV7?=
 =?us-ascii?Q?SEXHLXuoRY6fguORvR6zyBjggdw1Ih6P8rtCjzpTL3T0l1geh1F75LbDCxNx?=
 =?us-ascii?Q?ajoe57lyBMhjm8CABpr0iSk/qMkE+K6b4Vx78THdWCwRJX7JUHyRSwfIcpd3?=
 =?us-ascii?Q?wpGSyB3zXtT78jBWSx4XL+0cgvXqI1VA8qk4CxqYSu4gBaB2zUsqhCv0LY5O?=
 =?us-ascii?Q?RynjOSNkOWmF024os4VrTfDjnyCU79UTBZ9ogMPgV/onGGJ3q3XI/kQXHhCK?=
 =?us-ascii?Q?LJE4ksUdLYxRvEEF+s9tnPTcGF6rqR35wZhCacR5i67CBmZ10DU1/pBKhSaw?=
 =?us-ascii?Q?bxHPnka7V9jWdttXWDaMd3MTcDgauk3BfMnhbX6DvJGtmViCRiviXs4qSG87?=
 =?us-ascii?Q?Nhj6FiQbmZO/XKy4ds6ZUPPGDK+She+8Pzr+8DdJEhfjlJtpY9ueswBD4VWh?=
 =?us-ascii?Q?MSXxc+aviNy8mCwMZN0VCH64zKWsNjFoNSf+NW7ARYUOCwCPO2Z1KYETyLim?=
 =?us-ascii?Q?ta3VVKBZuHHw42VkpNYcGes03Z1W2OpERKGg+9WOzwBYchpuDYNR3wHlzfv5?=
 =?us-ascii?Q?LgOgSn7rkLmwdQkrROdSuv/3widvLlrXXZIYB5yB9mT2BvRKI4elKcl/qD2C?=
 =?us-ascii?Q?ZsxdNYcNLONiNFxbjfp0enphWQoQFWS5lyjXNX/e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8913db40-f258-469e-995c-08ddaa808c2a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:45:24.4044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6WnkOd35e44YYSve1oeUk5FXuEc+Sft3n5Sk55fdT2eUIEh6WEQLp1r0lLrrDEG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9221

On Mon, Jun 09, 2025 at 10:13:29AM -0700, Nicolin Chen wrote:
> Sanitize the inputs and report the size of struct mock_viommu on success,
> in mock_get_viommu_size().
> 
> The core will ensure the viommu_type is set to the core vIOMMU object, so
> simply init the driver part in mock_viommu_init().
> 
> The mock_viommu_alloc() will be cleaned up once the transition is done.

Note the addition of the missed s2_parent store

> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/selftest.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index 4d5dca8027b1..b0de205a2303 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -772,6 +772,29 @@ static struct iommufd_viommu_ops mock_viommu_ops = {
>  	.cache_invalidate = mock_viommu_cache_invalidate,
>  };
>  
> +static int mock_get_viommu_size(enum iommu_viommu_type viommu_type,
> +				struct device *dev, size_t *viommu_size)
> +{
> +	if (viommu_type != IOMMU_VIOMMU_TYPE_SELFTEST)
> +		return -EOPNOTSUPP;
> +	*viommu_size = VIOMMU_STRUCT_SIZE(struct mock_viommu, core);
> +	return 0;
> +}
> +
> +static int mock_viommu_init(struct iommufd_viommu *viommu,
> +			    struct iommu_domain *parent_domain)
> +{
> +	struct mock_iommu_device *mock_iommu = container_of(
> +		viommu->iommu_dev, struct mock_iommu_device, iommu_dev);
> +	struct mock_viommu *mock_viommu = to_mock_viommu(viommu);
> +
> +	refcount_inc(&mock_iommu->users);
> +	mock_viommu->s2_parent = to_mock_domain(parent_domain);
> +
> +	viommu->ops = &mock_viommu_ops;
> +	return 0;
> +}

The patches will read better if you add the call logic for init along
side alloc based on init or alloc ops being non-NULL in the prior
patch and then have these driver patches replace alloc with init.

Duplicating alloc into init and leaving both makes the patch harder to
check.

But the change looks right

Jason
