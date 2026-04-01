Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011032.outbound.protection.outlook.com [52.101.52.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F097405AD2;
	Wed,  1 Apr 2026 12:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048339; cv=fail; b=vGV3DPjvHwm1/5/yy24D2AJeVCdeKRkkVPxXNoswnrgcpuaoP0Wwz01vHsjeX5XUh1m1AolgCw5WonkLkQHXgHuL8VCz6EJRSHWgKsPJkphPfFWhth0w2tNZeARkUBcTksqtTOIJjgOmn8BT3sJJMsLGwv0Arjuflri/hPn/4Tw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048339; c=relaxed/simple;
	bh=iRvSg2X5oF+wex5OLrs7/ynRUevh5KTOF8iDw5s+bIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ECRwGDuqoAj8NvCdmUFIYRhHmRjoiK2BnVVfrDCYgbZDNIyY4hGRKTvIk/MBttxq4UjAr9fXWBz2dJ1zDkIVZJzo8Udhq7K6HFin92G0ebLIcpP945E8wOc+Uc9jWmgi4JkMB+JwOZ5kah0CqCdpE6AS9RJ+SbN3cLlPyWlXVyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Iqmn9va4; arc=fail smtp.client-ip=52.101.52.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Iqmn9va4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=joBN8NzTHhwAvsKv/6WkFEDO1lS+GSbE4jJc2SvR7BV3Z0yOCbK1pgkEIpzJTDzNicMEsjnaIPFdR4S6S18eGV59JjHh8Oag/ri+NYduOXOHJ737ZkEBjZNxVbLUDJXEPNh60WFt3RqYa+TnrZ7y2Nn8G01iyPy+u75VdaBKU9AX8zPlTz8n6YfWZjkYAPNEZWbZf1HeHzRShr+lhgz5XRSYJUnZ870RhAOKCEfmcti3rK3iyG9BbhDEmdB/4wv9OvSpgrlPH1UZybWK+ngkbDKt99oASyUSyeEeehHu9URU7FnDAcpHFv4WweuI/XZoEdY0aE+bGujBhsFtnW0Snw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRvSg2X5oF+wex5OLrs7/ynRUevh5KTOF8iDw5s+bIc=;
 b=MqObNlCGMWhQ+cc48nSi3DKypHZ58hpbcPcbbN8PciFgXlnRu0KVN1tD8+ny8eezix71h7U3btktNEc0j6tkUfS3aLYCD4AEkMv3OsBHNDbPfBrOEHmURNUbjdar4980PuaUPQTbY/ZZWscW3zBbDcfJrfTYCJPT4FeJROno/eYgokGMV99QrOfMTZFbj0VKuQxdtRfkmSISaklZD1pFsew0GGI9xv6dL9UlmH5dstAmspCVhHR3aupVFkOG+gEuK4RUY1AQHUpKWYvSreWH4A0a95ktZmjSpNT3f0L4rBx8dSGStRZFLxfywojMjVM0fQV72sp7uzjbU+ucWXTFkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRvSg2X5oF+wex5OLrs7/ynRUevh5KTOF8iDw5s+bIc=;
 b=Iqmn9va4ePHAQKUQmxcxPxUWVSxpAvrtQwP9oBXjZC5MYyY4TX37DJTv7eLh1oRtMwL9efv6SXnTd2KodVOFD7sdZPrxE6jC1cLqv0RJXq8FVNWkEfRF2Poj03kC9Qfup20vrlRsh5JLEaIR8DnAJbOj2UKLnBimkpWjbpe4REHne0kzv3hWFDK1BGXTr9ynU/7Cu6RA5AVwHD20gmb+JCOQidBi86c4ps8iCfMcohL5XodeVMM34oYZzTthOOUbPklHd8pzpkK8rgsyWSwRBms/Vp700i3YD2k0PICLy9XSV+ywMo/1DjGn4fplVwicBwG09T/6ViW2ade5fTcfpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7322.namprd12.prod.outlook.com (2603:10b6:806:299::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 12:58:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 12:58:51 +0000
Date: Wed, 1 Apr 2026 09:58:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Neal Gompa <neal@gompa.dev>, Orson Zhai <orsonzhai@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Samuel Holland <samuel@sholland.org>, Sven Peter <sven@kernel.org>,
	virtualization@lists.linux.dev, Chen-Yu Tsai <wens@kernel.org>,
	Will Deacon <will@kernel.org>, Yong Wu <yong.wu@mediatek.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Jon Hunter <jonathanh@nvidia.com>, patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
Message-ID: <20260401125850.GZ310919@nvidia.com>
References: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
 <ac0AKyvHMYHlqL5i@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac0AKyvHMYHlqL5i@google.com>
X-ClientProxiedBy: BN9PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:408:fc::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 72902b0a-31dc-414d-a8a1-08de8fee6c47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4UJx0E8KWXxHEMICwrNdAVkp7OhhenLehH8KTzh8t3iQRG/tWO1nlu9J3SRNRLZ2A7NjVBobHuZbnwSaS7nTbw9EcGUj/PmUG6ZI9EvKOYkreohgt1GJ8+W65G8MZeJ5pOHARfPgUkKIyT4DLp4hymC9k0ycY0LN5uI+uXoWZFidLBXRdSjERD6/ww8DfDf1Wu8vloxs7B2cst/QR5lzcHSPmNR4bPZ8bBfUfHggjHwV0vL2EupyNjQXesXUXQlk0otCsXnWQx2CLvPr6LkjkBnzv0pSwbbU18W+/zvT/KPTi9V34zAoFrTagoCLyAb2YVNwcP6iBBPbJBtj6orijRT0bjG+tAYwn5OKSTKahLbRts4NkAepxVvxQURv5UHSFLczGYTc5SDokMYdz6nx/x0EAoELXahIdSjGQ+F6+cHDQSgIdUE+INFxOcaMUsJZll7e6YGxmmhRhVusOqkjiyfE+AhD2o48LE7s4SlccUn0lWzyLFMHcwVZljfK6hTgLM2DCm/8vamVKqaXeGq4FkU/aNbK9OSJAvrJq6ajuNyhY0fL4vj+QGKBPgW5gKLCEiw3sFFdNBzTU4jUAS3aIrr84YjE4Qovnz9C6kwaymFwaGc0A9UxrctuT/RUDGs393ZMRsWG8Gb+R/WVZfQrpYqyy8EOxhx1FRyhobwwAVJB9Vu4A2xM2+igY52IiEp8mojRcvXIt0lAiLgKBaltj0FwI1y7QPsg/2Z1dxwMUDc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p3wbNsyZlG8XYPWHQx9nS9eGLdJD980HE2+h3I70baHz8agh2DJoXgjKQRaG?=
 =?us-ascii?Q?lOsAH8d07sLCQgP+yFBBn8453tQCUJ7Yvt1OGC/0wMWkCq6S7eGi6MRIu1vg?=
 =?us-ascii?Q?mAOCAEDyNfgvqTttEZT0sRxP3h17aIkxVl5giSKfqkhCM1PCtnbw57lz2Jw8?=
 =?us-ascii?Q?ZUrvTZJqLQr+y1SJTS3y27/v4g90o9SDkxFdyLBLoSXRL7MbgaHY0IvKx1zZ?=
 =?us-ascii?Q?p8BG3+NY0TN2Zj3hePBnM2qlchWD/HWsgRoiTs73VXqyMbtIRnwtdMY2Yj96?=
 =?us-ascii?Q?xYTK5zbCl/T7LcUX7S3Rx3bC40jP1R8m9IfMpA7kb2MVTzoyiBQZ6vFSgRC4?=
 =?us-ascii?Q?QflEMutZMWvmXTfaZ2ZQn5ycluCLibrtlGKdZnV1SiGKs4G+QCUdmXOmgltH?=
 =?us-ascii?Q?Ms2uuez/BftatZMsizsNfJW6vu/e5GHAUXjJE9mOTcgYdq4rMVQE3EdBz+fw?=
 =?us-ascii?Q?hWeynXyMJZ93+s931SP7hkcB7U0Yz17UmaMXJ25u4s1QTY4FcaUUp9KtQcFP?=
 =?us-ascii?Q?xmoM5VNwJ7fAZ2TEHOGq/xsghsvka5Acov+OhZHaBZn52nwXs+obCUrk3nsT?=
 =?us-ascii?Q?jksm4etXBwuzKEGRUMjrPH8uvrKT17plpQlhveAsnv4UVDDkTHu2306rUW8D?=
 =?us-ascii?Q?lbeVB6fkqVDc0HY6QlIYGNGI8GHBrzG+DOYjnbejqWvrIvdbwy6CmJycY3cH?=
 =?us-ascii?Q?Yei+0bH2fPLkb3e/A8ctkRtgX6mcwvpGwGyml5bCJlS9p5AxTLfG1EY/kw+5?=
 =?us-ascii?Q?pkUWRm5EsI/leVbLzAC0qlXp3qsqhtCCwes0dJ0JJAVofyCHjrQOc/x3wV8c?=
 =?us-ascii?Q?iZ6GsGzx5VaU3EOZlKYTvkowA4pFUvpsTIYb8czXSsrFevrPs63HeCj4pb6g?=
 =?us-ascii?Q?4BnaWt/2mz0yK7ZkrZ1GqUHwxv6+sMWTpOVpgGgWkCXSKzOgHIgt+4/xEUxY?=
 =?us-ascii?Q?z0Z/9/nHQpEdudvXV0M7CLYkTdVyhnrBYckmuxL7ZY+Yc0V4Eep7fEsnIWMP?=
 =?us-ascii?Q?jgvA/tJdpU2+LR/9mJf3O83sa64LUunv2W8AICcuxlad+pylx7SDmaXJgRwo?=
 =?us-ascii?Q?YnwCg7kwwI64K5uwvMvN/0WqJMGhC1D5MCf7+u+pOWX95GhYbLfAdH9y9Bom?=
 =?us-ascii?Q?ZSAutN/dMST3sESGjZ5Uf7pm/Y/idR/oAlnHS+znlQoixQBFP9KTw/GGTmgB?=
 =?us-ascii?Q?3CKSiP1mbnWsAt4wq+WPA3LCgqgFtaXLsyNAmL04HzRQBkIOBwazlxSunNNa?=
 =?us-ascii?Q?RLwxHyl6kbI95p/YTsmZfZOO/aeTFR3dts2BGoa4XccJOmA9wganzIP08jlD?=
 =?us-ascii?Q?o9bkqEc0l6HgeUSf7Un28bsrvthnB8g0rEWHZli1bhAyLxoHhVXO/XyilZEd?=
 =?us-ascii?Q?RXR2eEws0ybUxsQTge6LnRedaChu1qw+RuisK0HZAEE8RZx5DGOHPGgPw2OQ?=
 =?us-ascii?Q?wLHRTZ8Eh/En6usoxHe/NzcMGf+uiTVCtkt8woDU5rKk1tQBYsujuVG2xhAR?=
 =?us-ascii?Q?gQ3yzIYXa3qNnkWzCSS86qAN1vowhc31PE5JvwjZu7yiJBfVF64JOASB3Jos?=
 =?us-ascii?Q?IXxUlW1F2NYrskmkQUofVr5/toVTuHuUCyGwnCvZWcNOelO58n3JVit+c9MB?=
 =?us-ascii?Q?VT8pTsRTboSKMWuwYIEXfg8tkVHftxs7j5Xa6ThJIT10j8WBPkZIRwH88/BL?=
 =?us-ascii?Q?bfyc75GzKqtD2CwsiwBWhJhC60fo4i1JhZT47dmLLj1HGFUU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72902b0a-31dc-414d-a8a1-08de8fee6c47
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 12:58:51.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G34U7eBhHK8zZIUrrohGinMZLSJr2Ti8+0M0ATW6PziKkhNm31/1szIUFRH74VMQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7322

On Wed, Apr 01, 2026 at 11:23:23AM +0000, Pranjal Shrivastava wrote:

> I was wondering if, as a longer-term direction, having an explicit flag
> for these drivers to indicate they always require a sync would be a
> cleaner way to handle this than the trivial population?

My first thought was to just set the gather to start=0,end=ULONG_MAX
but it turned out to be trivial to just set the right gather parameters
and it looks like it is basically the same cost..

Adding a flag would mean we have to test the flag on the other case
where we don't use this flow, which doesn't seem good either.

Jason
