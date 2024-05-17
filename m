Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435F321D;
	Fri, 17 May 2024 19:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715975300; cv=fail; b=CidQkWNNrz8LAlrPa/0bro7/WmOnca2TjyLPg2UhaYmpI85D20OBjAlHGtnvVtT//iO646gh4hkMda4jF828G6x0OntzQa6yAabwYNLiu+pWZdbuiCGbr7eS86f1YnUJEyw1TbdqRbgucw8aOnsnBWBsSaQ8JOQ0B9Vcx+uaPME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715975300; c=relaxed/simple;
	bh=hYDqcYCatXaGTiLc94lIyaSL/0B2/wpgK7Xx1gcZlE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SPT3J9fC3E6K9gz8Hdx7HBme21zHp7zRljPfJXZzvKKzc6wWLV115hWfBcajxFTTCqwBmYLa2KZWy1GkCaC6g8hDLqiRsluT5/uY5apmrv3zMhEyAE0iwOLkpZYhKzZDljra+usGXtJLkiQopeGHe3DY2LMnGjQHntWdXvsDwEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c1G305Gi; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c1G305Gi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFEcZKUGb+rhO4jxfeVQ7N5zXjmRTSB4SY+4M+ws/DGkUkZYs79ls6STUL/BpXmXddNgzOfm//oAd+Vu8ZqxSaI01C837xS99us4rsOoQ1GifPjPmHnI7xKbZ/i4+L94JZoJvdlee5v+Qc76pU+zrKR5cD9bN2NxrFQ7kOHKQJLwUChO/g7fh5SZW8EhaNvNbvdldgsbM08pMCUvyUmefuWiZhv5Mn/VOlx/xmE2N8+AncNJHz7aqLvkywbhpTzIZBk/Ju2ZgHnsnW+tVbyczYrQokoV3tvER+ejXyFfkNPrATH7/Z0a48uzmZvZ7LcIT4OWRJ/D0N5DrwdLs6oZVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDU/g49qXvNuPixzvThtgnCRXDMO5lnQ/H/3itb6FNo=;
 b=OazwNPuTEOk9PW8HoH2bA6AKCEE2DO2xF5h0je4cLNLYhiq9ijYvEAAMBSQ7E0CyyJvaJ/w9gvofq6D+WIGEOgsllpGcWPW1CcHOUNW2iegUFlBgPXmjFm5dQ0hy3LZb3xAmeC1SYvGEO6k4t8e1ab0k1Fj6IBoBn7GXiWvQWodQiEgC/lj042LaOikbEmQ642qRAjKsUYzvP0QAgkiL5doW2gVjQ+GEvEEDMokATvZ//QM8xRp8Hl19plVRmFrZvF/yzifJV1BkZlJ2FIppOcHun6JneTgxVGLCStTg+/aBlesXva6P3An82a40184gZcHJXJVUyZRKwI5pVNIIPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDU/g49qXvNuPixzvThtgnCRXDMO5lnQ/H/3itb6FNo=;
 b=c1G305GiO2x1u3HbVHKnjOR8jeZ1bSy0vl38nUEUg9FJY99r+u/dsps0iwFkRX/htN1THqK+oayu8MiA3tRb/oi908PmDO+/ZubqG3toO/l7wwscgvo272RKZFHzylozfT4cmdEO0EO3w7UFkcTU4FPM1YdjW0g5JiJTU9eoz4cxAVLcXKm84xkBdeehYhPLgN0oi0cBKaWB7ITsbBLdG25EfAbjpQhFHZ2QAQr36n/VCKtPppXlx6O023+FvUw+pKiz6QFadQawZtboBwh+vGolcXPffqJkYLm5G1rAwyWmzr3UBtglOEFrfo0dq+OMBhBTBWAZYCAyHWaqBB3hyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB8769.namprd12.prod.outlook.com (2603:10b6:806:34b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 19:48:15 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 19:48:15 +0000
Date: Fri, 17 May 2024 16:48:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in
 the smmu_domain
Message-ID: <20240517194814.GA133219@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <10-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkKExvnPkHWjedAX@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkKExvnPkHWjedAX@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0465.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB8769:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d244852-a474-414f-3f35-08dc76aa4b11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lypEcxAXYiMW8AbhIKfIet4z1uflVkRxNrVieOaqcSlCLpjuE6q+yJyPwfyR?=
 =?us-ascii?Q?YfUAgYGfX9tc3QHljpnJ3MK3FgJd/MoBHSlALZNOzqycbhnny/JZAEIhPN3W?=
 =?us-ascii?Q?9XQI8GAhDtrguP5GeuwqJZmhJbxjU4IXA4TeS6rFvJ8FHgVHP6mkWEswd1n8?=
 =?us-ascii?Q?qjgwqr6o8++AV/2WQa+clCO9rKj5N4CU95hF4r1vYVd5/8m8PnCbueXe6y1w?=
 =?us-ascii?Q?vCtfBz1FFs/nXHXdIjXR6gKfqC29k1XnL2VtmsMICLNXOMdQ0g/KoeUyFqPR?=
 =?us-ascii?Q?qGIXyFDme8tTRqD7mXnUwS53rq8FyH9Tgj6dYTn0K1MUtY2PEJlKTQCKlKMK?=
 =?us-ascii?Q?MVSttG72PwwJTuaYFqAxIUm+OtShQe7HykMUj5uQxbo3aQpydQIFRT/wXtHg?=
 =?us-ascii?Q?4yX00JH0hk6ILmXWafNgBOSCUEnd0RJkrs+H6CAGfa6DQHyvtTMQFPJ5TgSs?=
 =?us-ascii?Q?defB4mHZrCkKrKkLhbcDalbEw4GAQD96NDfY77jdG9EHPRP/Jxnyc2b2ezL0?=
 =?us-ascii?Q?BplYSB9hkjMXICq7N+6avZvpnGGjd0FzudTJZ1zSfbazamDN932UDe3BgrRn?=
 =?us-ascii?Q?hAFhRQVDss5yj9RpjaA96vS6odEL828Rq1j9g0Fy4j1ZUNXO4NOGq3i6xToV?=
 =?us-ascii?Q?Iec5lJhy34OIoTLo8wpv+mmXmcoLeO9OQSBgt4MKKSWCd6vjjCkvm92EpRBN?=
 =?us-ascii?Q?HThZhN4sypLa+pF7vExOFYDT3+4kHUEpknLsuCsqEO6Ifqrs2ZwqRt8KFBNR?=
 =?us-ascii?Q?srKeKhIRzZqx+EWNj+9ZJd1U8IUj6XQmD52tHds1qHQ1nRdEbmj/vW5SaNea?=
 =?us-ascii?Q?jzhgUZd4kBiyocd57XxcDLQSM1Nxa+12KkS87JhtvSZd/f+FpuqDjGrSynje?=
 =?us-ascii?Q?l2wYFZKspaL6ikOdHNaZ+nn/VVsZXX4WQlncTv83zn+WmqlJ4smyygdvSuuO?=
 =?us-ascii?Q?4zpalFo7ZpqZwcr9EjDBxN+EO81DlUxyxP53RyIa9AmWJzR8SLdS2ozqJpg1?=
 =?us-ascii?Q?VLFNLfHdHpvM+GZKQFw3pcnRy2NzymG/kM8sG+8po6kQABF+lfykIHCmfzJ1?=
 =?us-ascii?Q?BOqj60UUPH320pc7WyXHJOUOZn9X9oo8WzokFCkyh5pv6Lpd46QtrmxlT6VB?=
 =?us-ascii?Q?nlS5R/R9tvhugf3JG6U9fbpeIUb4wq0RteOuEE3dut0BEyD6vMLNLxbdMgYx?=
 =?us-ascii?Q?h6pacQwKxjcG2ISyHwILiu+o7whGEfJWGuiHoIrXc+2+0SHRkNn1KhvW3/CE?=
 =?us-ascii?Q?gkskdK6CcXPGVaDaywmjgu4viWhemlAGZhIrFJKr2Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hdkWF6thuTU82NfKtOnnx5tVVV7xGZrKfwvSXnDEEPRGWXH4P/PkRwIYgdTv?=
 =?us-ascii?Q?N/c5V5ipSWREknzP1CfYISShCMROvW9j8hgrhu853bI/84X7oZY25l7RsO/X?=
 =?us-ascii?Q?ywxYmDZaHSi/7dYBNsvmVhmSgshozntz2ePszwIs/2kBuWdsIFDLzWOUzdJD?=
 =?us-ascii?Q?cm46ps1/1nE2MP8QPy1Efo8k3VdvuQj7IXBhBBnFk2AsD/llrO7ObQLophWB?=
 =?us-ascii?Q?SsZHoXJnxGOS7olI76uld98LmpK6xUJ1MUDA6NE7j8i8QHBw51WJhihuTe28?=
 =?us-ascii?Q?0gXXYRBbWD9f/4fPhYw+fujtHxchQ6RL/ThwbkI8inqJFnyw2yCFFOX617N9?=
 =?us-ascii?Q?vgVS9Qdk0uim2try6lRJFuHtfPbBeheq6ilrXrndKPBMqU+6bCSgkihF/yPU?=
 =?us-ascii?Q?fsHBlADziCbAS58F/mqI+f6uvYyHTUrQWCFCfUnTuuCabxF8gBjdjEb4ql2I?=
 =?us-ascii?Q?iBVeKuupMS+IFFiyRheboS8CyUICEdUtaBazENgNBGZmpzvEBh09/m0E6ViJ?=
 =?us-ascii?Q?he7pKPgRPk0FXPv2aM7nkBikLrYrYKkbQFspUxCHnH2igz4SR7s7QWZS3iuz?=
 =?us-ascii?Q?SGan/ezcMNy9MwdQDiwS+cz6NAKv9JC1Ac9O84W/Q5XfoXx0qO59q1qd1Ndu?=
 =?us-ascii?Q?yLNrZmt/D/tHBLO4G5RDMbThi064PxSaqpK6tz+LobJ6VUPS8NxHUH2pDb/5?=
 =?us-ascii?Q?uoNMS9VQKx89AOd6XgVndGWWrlJKpo2PMNbdr79tUtqivzVYXOoZfQ2Exw7k?=
 =?us-ascii?Q?O1UB5TnwOM1iwGScRowMNK2MBTXjmyDHCToNa3CePeM4VmWbuWVI84iG+23H?=
 =?us-ascii?Q?tTnInnvDYENVb+iiCnkiVn7GfhFsmg3AhYsLLznHRR0X3FAcZNT6TtflEY3T?=
 =?us-ascii?Q?dngo1AVsDavD3e8mldPIpURwMwj6WziXELTx8GfkaalpOmxfk7hxdZXZxXRH?=
 =?us-ascii?Q?b9hsprcgvqX4nozasBhiP/GjOxkB9izS5mz4Q+fnByYDTfuScZxVkD4hTKdR?=
 =?us-ascii?Q?zlWnrluC0Ub4jqucXd6gCT5s7vkGZEdj1goCqRvLVBJTa2FgyWjdulf9r3Q7?=
 =?us-ascii?Q?PfNefS50iKE00OSTtImEOLQiHFMNsqqty1d7bWDkp+HJL5DRfwEFJm9uLpA1?=
 =?us-ascii?Q?eknYuZaTXcvTV9u7rhooY51/o42HUjvEHb1HzlcL+R49zYyJQ3GP3XUNa4Hn?=
 =?us-ascii?Q?Y7bGHJ3aHK0Co9zvh1V9zrCGApxslq4Ua3bEHh4oQLYFmhMs/z3g3Id/js+z?=
 =?us-ascii?Q?JxAfi/eR8T0xq0KQk5H0hj5qqn5j7mMnKVKOSKqStqHqVT6XUeiMAoum5zMa?=
 =?us-ascii?Q?5HYv2t1OqpYDYWB58yNpt2GT7dN/qHxIIKx1Wr1gZAFFYQkDLoknY35pbmEo?=
 =?us-ascii?Q?sWm60w1uIYk/E34ULGAZ7woqV1tctrmlffR0N9l7cfg7cZQmUmjnhmRyE7px?=
 =?us-ascii?Q?WFxOLDpzlKcSn520vCweZjUTy/JZqCZKT42a8Q/td7xaxyuOWQzxLfdHoKM4?=
 =?us-ascii?Q?H9u1vV5JLWA6IhIUAdDxZx8/kIRY6NYXzbqNkCLGx5Sf40BgXO04ESbA35G/?=
 =?us-ascii?Q?Hqqcqjr4bayOJVBsgTqI06gOpDeeue14ocGwnPNQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d244852-a474-414f-3f35-08dc76aa4b11
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 19:48:15.6718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NVYPc33iCKkczn/UI/qCleBJ3BUzPPRHNatk8h3IRs8JNSGq/UJf/nByFRPLO7y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8769

On Mon, May 13, 2024 at 02:23:18PM -0700, Nicolin Chen wrote:
> >  static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
> >  {
> > -	kfree(mn_to_smmu(mn));
> > +	struct arm_smmu_domain *smmu_domain =
> > +		container_of(mn, struct arm_smmu_domain, mmu_notifier);
> > +
> > +	kfree(smmu_domain);
> 
> Would it be cleaner to refactor mn_to_smmu to mn_to_smmu_domain?

I usually like a few more usages before making macros..
 
> Otherwise, would it feel simpler by just
> 	kfree(container_of(mn, struct arm_smmu_domain, mmu_notifier));

Sure

Jason
