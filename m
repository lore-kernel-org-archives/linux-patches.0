Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAAA241103;
	Tue, 10 Jun 2025 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749580482; cv=fail; b=ZfPDd17L1RikSNIRztXS+aMLT6VUCt95GQcbrbCK2cLQ1hIBx86lk8PLWT2//CDlyXZFUQAQJ4Y8Oznqx/Sg/aZ6+V1u+KExURE6WSIQpX830+7PObnk5S7vhMUY7vQRdwuAiGPRi9Bv3fr3HVN3oFA+BDKI2VN4fPQBhgTl7YA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749580482; c=relaxed/simple;
	bh=dyQBDrU3ETlYA/renZb8+igE533aeheL6cekvz21of8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tdmnNbsB7ZXEfGuVK6ZOW50bvHmpMzUCGDZKOS6Z0Vz8nHbifh8fyAnSdwvw2hSh4diRF4c2QV06nLq8lRqVjuQTFO4VeI9wzGToY2XqMX5jtapGSR8WMaAXa+cV1EZoUR/4VtrKmPvkDrYp8kN7wavkKphrx03rjDN5meLOCCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SFX6XB2O; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SFX6XB2O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P3WjrWfu8wPMGw9iyko13VxLh4AJwCQ8d5ZHJuMQ1G5O/Gnzy7bvPhqpJm2sX1tXPW58KBEabF1AL85CFd8+DIAyfr0U27SfvViX5M+lirKIaulWtS0ucz2xcdXWxZW7dg3mXuxbYo/M6FNEUilvGxAfBr2zBgVFuYR2LDlah1zIumzdoCIi9G+TD5o/5kbHNXIJ5kbAGRANI2WpPNHu6Y9jkqqlSGbJh9cM0c7h0X0M2TpFQUSELJXa1EctStkuAP/S4Wf4WrymqhnrwXHPoPx1EFymDSGJrv63vEk5/FoduM9TCpPiao8BmvA2TVwSZTkLnkargnaWezJq3CauKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0EHqZjavyPjE/wqUckPlVilro3PB9aTxSFSg7csqU8=;
 b=G1eTYjBVm8mPFErqh5mdwL/5BbSLlTtNwqbBLp+5m7Y08FHSeVgziAzH6Jn1DCccj/JxgRMPRD0idqtMBOKaq2JA8GEJe2HHh1mWc9so5mpe9WusUKrp0DnUQJ14zwGXEDB/uLwdz+vkJCIuhI3qr/QphfDUO7XG9kEkpDJnLErywxtX5I0KXGfistI2aWZOVD7PL34knrdQxCzEUFDKm+DAH4hPJTE8OgEdIuSDAWhMc3ahB22HEkwXv/yCkeETZI7FQKNsnnEwQiKyGKPoUhtcZw8KPOJs4rAs0/rLtnD6x1X/6GVsfepvV0O4eY1nRRJewyyN+5V8l9m0AQTPEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0EHqZjavyPjE/wqUckPlVilro3PB9aTxSFSg7csqU8=;
 b=SFX6XB2OaTfTX6VAYw9enB0FXwr6QjG2ly0jLiqFFc55rt3hXCtR9FBroz/ykhwTcZ05fsccA6Fp5SUIFndkUbfNOBqeAcMovz6N0AN7x9npHBexsqFo11pGZrfrAWbhqTmu39357O+Reyle/06/4w33AaK0cRVeuwrsiaakJcNVdx4eKd00VyqiChzqjHvBBimC/ZGIRLDXLn8ystUHYI3+0Lvi3dxfKsOVAt8cmovNH521T/H6TkhTY4bcSzYENSZiG2T+QrONefhSzBCg+WRdU6P8768Y2pV2hdzffW8sGCLNJcUaiE+AbvtVnrOy5YYtk6LPE+5ub3i5uneTgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB9513.namprd12.prod.outlook.com (2603:10b6:806:45c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Tue, 10 Jun
 2025 18:34:37 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Tue, 10 Jun 2025
 18:34:36 +0000
Date: Tue, 10 Jun 2025 15:34:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 1/7] iommu/vtd: Lift the __pa to
 domain_setup_first_level/intel_svm_set_dev_pasid()
Message-ID: <20250610183435.GA832440@nvidia.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <1-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0344.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB9513:EE_
X-MS-Office365-Filtering-Correlation-Id: 6276d25a-80de-47c3-7eee-08dda84d73c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P3Ev/GmyYlrX5L5ITLlymGQ7V9DZFZASusih8retJwCIjEIp4f60kGBmcows?=
 =?us-ascii?Q?/UmaVEH0xKkuDdiAPyztjSmZ57MYoa9OSRbphCU/JBbJ4lsImmeQGRc5ivgI?=
 =?us-ascii?Q?Jon+aAt2pfB/NQcoppFhiEdRzkQIeYBa0epso3WCs2P+m4HeHOivHTW35aY8?=
 =?us-ascii?Q?sCtMR+2l4CcyHeqdWtmi/e6LBn+2E5o04wV+u2QxghNv1YYVMWRd2FXVc44G?=
 =?us-ascii?Q?iaIJZ91fUNTdGmectypYKXBOv3KezPJ7vdT8GhdCXulgPehgvb4W/S5BD8pM?=
 =?us-ascii?Q?dWVOFZAbUI15FeQRhmV+t84HQlMQyoZssNLfgdlKa/lDuMjh3lc1fE5sFOjF?=
 =?us-ascii?Q?ti4SnQdOltTmbr+uh0XtEWvVkB3I/TaOEjMiX6wsOcd9cBYKGQaC9V9QaUHf?=
 =?us-ascii?Q?abV+y3S7I0z+9UQy7iW/a5V1Ii7QTPqtbY6HA2eCNVVxaB9qgE0oSI0NS7Pn?=
 =?us-ascii?Q?MGH1fbEY7Hl2E8tOL0uUwCo34zKRHTsPlkvO1FCgn4MlEgDdg350ApaBtLzL?=
 =?us-ascii?Q?iOCuRRJGe+sO4kTXiTeJshTa6a2TC2YQ93BhtCwOEfALD+eTj9Ezg6WTCqDh?=
 =?us-ascii?Q?yK6YF7DERHWh1YgSuSIZ6IqbRuQm6ZA2mAkqXF9YzNRFE7wwQrxX7ExbMGxa?=
 =?us-ascii?Q?EORCqpbzmoAN0/TnhSz/tp/kWx9bMMvIKOx1tyWpsbThMHhuGMOXpN6vJyI5?=
 =?us-ascii?Q?BWPd42popzSZMq1tJiiok9K7B8w7ezXAuf+/yHx3amUdd7m1/veGLWDA864J?=
 =?us-ascii?Q?Mfgw8A/pAX8SfjZUnGH7YjbeT4+7wWGnVyQBG/WlKNv1uoYe+HXQpoUEpIEw?=
 =?us-ascii?Q?qMDAfAQkBgNY/xgFYf169y/4p9dD6O96LTFboUqHu/F//+GYqAzibkLRk/Gx?=
 =?us-ascii?Q?bEohDJOQJtDxdTILiRoSCTrPjyd7VWbLJQWYTNb8sM++Q48UgBKlcCS+3Kc6?=
 =?us-ascii?Q?+evdGPgXh9OH3pNwV/mi496MBRE01gdDuEOx0/sI8iReQWWHJZgPh7p+9HYv?=
 =?us-ascii?Q?n/jzrSSdEdBH5+LE31aeM1Mc1hP9cPuohiTy4N2Dk+CfcekdpNGT49X4ThGU?=
 =?us-ascii?Q?/OlPo9NY0P6oIBb47McoVQ7wG8FJoqx4y5VWtLw8DWNbUzxVQQYwZf5ieEyf?=
 =?us-ascii?Q?LBhH7AJYk2kLfMe0P8k8MXttXYDkCBbwEhslCDs1YEfF2X39bZjqZJbad/VZ?=
 =?us-ascii?Q?8gCh73/XLeFnlx8spFttuq7Ilk+dtFriv5gfCOHewN+aeSItgkJPeMXSkXci?=
 =?us-ascii?Q?NsGqPywCtSHUocDio1qCL9n69+QNldPcLfHoJVsNbcUkOFEsjZEG9nAn76zx?=
 =?us-ascii?Q?+iB24eu+5BmuACuWwpSCPgLvHkuHLlhnzFMEmkazHPkaJApJhch/9XyDYAV/?=
 =?us-ascii?Q?NgMLX9CwK45VVdhI9GsF/T2C4PN5yQUR5BWX4UZOt1GmgfpCEcBWqTVIl9ut?=
 =?us-ascii?Q?AOjX80ZNmJI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ouBjRMChCkxNKlsaG1n0Apjrp/3wgsOttxBhjH3tyG/FQDA0UGdPR97KpRl9?=
 =?us-ascii?Q?Ay354ehspKnUILjLBeAmPUNKNkbHZ4VhgGjNJMPRETvu8YgWtqX5TmJd9AnI?=
 =?us-ascii?Q?b+CBRTfHFuqLjJ8NPbP7Bdbb5RkP/QpuQUG02gNEQEzv36Ynj0zd3m5DkY1C?=
 =?us-ascii?Q?Pdp0bDXJGEYzIC8cpRr3IMWekacXHAu/BCY6CC7xZ3VEARIrH8F/43nenaw6?=
 =?us-ascii?Q?1ZdE6pjOvN6uDcJCIauEUvPCq43ACJiiqMEIDn61UVDzI6Eq2ne+Utgq719H?=
 =?us-ascii?Q?pGR6sFCoVNbSxXTVfKaBJ4o34PjVHZF/k6rBJRBAN19OM3GwQNAJV5WFwSqe?=
 =?us-ascii?Q?5I9ppPSrdZazBfnMHAGYZbD3u/g5oO7Sq1Q+wcv8say1MgK/Azwr3rjsmq3T?=
 =?us-ascii?Q?rbGCB2S+fPSSTDzL+5nhSjTct/9XIDK1zyl4S+gYUKSCYdIqsPwCG331kvto?=
 =?us-ascii?Q?XDzf/M3DkPGXAv4YlbEk4IQn3StqWYTFN+IJ4L2MzdvKb5mKE5hKjqHtL+U0?=
 =?us-ascii?Q?nYkjtt6iR51TSTiAHWqVfk4n8pjGa5dBnGYYuFG1YBBtH/22JsUAedaKnIvF?=
 =?us-ascii?Q?6MXY8eNDi+teFaQLDY+n4GvrhHWUlmro+94x7pxRRc23e5s3DQHxaYRI+V2s?=
 =?us-ascii?Q?zUlpOPUA0pwh7ipbEzw7fPrN357wM0kQHrWRjz+KzahhjsE34lUhv7JQadcB?=
 =?us-ascii?Q?QrD4BMk7O83eLoYhe1jLo3B12NkXhzTNgfssTYde53Y1UghxP2UsSQIlKzWd?=
 =?us-ascii?Q?qoqEJXurSd4Ajg8hcDnjHLLQ0+LoRctOcRCsjfx6Na+ym3xehhxz4WOmB/EP?=
 =?us-ascii?Q?ojcGD8XoLnCSTaq951+C6oq710JFxFWGmUMiX4xfR9wj50MAVJ/idZ6DIDgq?=
 =?us-ascii?Q?hELovJSy3rlULBPhaT35ftEBQkxnaCuFg+mSE3F/HXsjqIJ4QVatqsXeYWEL?=
 =?us-ascii?Q?alldDiwA9MeCBVOPjLBhpg6KzIZOGa6wmLvLthnnG6Hc4MnAliGUtfdYEHuO?=
 =?us-ascii?Q?f78jbiY5RNRWf17QHXMcy/b6pZr+tvHZFJBxkycPPPSvtKahMvhqFBBMk864?=
 =?us-ascii?Q?Vhn/Z+fff+jleIFlH18nwToIYr7KeVop9b8rI1irVijX0chh4Nbj9bgop3tP?=
 =?us-ascii?Q?RGVm0kRWlHJdC5DcCTWSZhjZTWwb+3pSLyXhfKlkh1kCVt1oiVTsiIB1f1mt?=
 =?us-ascii?Q?zKh8FdW0r8iwErJO4RNrHFW/EqMHv+6g+HwnCMERC5/mkRmnHfC0x/SnCvv/?=
 =?us-ascii?Q?LrOLfzqppl9Gfj7Mw3vAozo02jndp7uHn1yQbwtPXOL3Soc0MmFUG1ve9uP5?=
 =?us-ascii?Q?nmpklXih/kEJA1YU/r+btx6Ex+xFVEey84np/A4kl5TnI675VEi/N2Mi1bsc?=
 =?us-ascii?Q?FZ+FxxFxU3K9jgi8nlnEoTO8UHbEx0hJIgozJHH5zNMuKw9pz0jNT9lSU4ST?=
 =?us-ascii?Q?AuZe+E0P4MHbdTm6NANNu7cdvyMUB/+1ujkfP2WCSBVd/b9wAsApUxJ09m9j?=
 =?us-ascii?Q?cmme9m1AcHnrWgLm29P62qaI12RTVIRxdb3JJkAl9cHrC0YNE0qKy8yRj37W?=
 =?us-ascii?Q?PL9XP/UhRLDQlbaq1tIAllTTsQWtiNBHAu86BJxc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6276d25a-80de-47c3-7eee-08dda84d73c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:34:36.6785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQU47xdALzWOuPIlH4J4tGV7lTXnOs6OzDSz0og/I37WQAXEFTZq2AFWK4GuPx6w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9513

On Mon, Jun 09, 2025 at 04:58:20PM -0300, Jason Gunthorpe wrote:
> Pass the phys_addr_t down through the call chain from the top instead of
> @@ -412,7 +413,7 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>  }
>  
>  int intel_pasid_replace_first_level(struct intel_iommu *iommu,
> -				    struct device *dev, pgd_t *pgd,
> +				    struct device *dev, u64 fsptptr,

0-day pointed out this should be 'phys_addr_t fsptptr'

Jason
