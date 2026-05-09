Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF632DB79F;
	Sat,  9 May 2026 19:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778355781; cv=fail; b=JPE+NI52vwfimsjc3RH8yHwdMWBrOHH9qLsiMegIEpXE0nZDbp9XM7k4/M7o1VtSjMSPKKyZ/QF7t9Vs2ZoGFeE+Y0TpPDXJBXmYbjZC0txyWipn7XCqiO/NnbjLPf9eg/T2jE7KIAM1Jx+JN1lu8pFoWlSZeasZJQsJR8cfsOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778355781; c=relaxed/simple;
	bh=3vYH1IiY8usg4HB1Tmp7YV2g4KQ+EBJ7utUpVTfqHIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BUoU4Zi56OZy/N2rtw9IcBu4LJ9f4kWlr7VoSlt8OQUdqhNKBnd2HYpAgEf6D4w99sE+g0JpKU1MspI1v0laNt+1fNIhiiWwsta3LrNQBFf0VwoNndtuvFNukK8QrnBb/3fX0NgAT7GQCw1HOVsJzoXTEdc/cBu486ye2zuNL5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l9qHF4GG; arc=fail smtp.client-ip=52.101.193.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l9qHF4GG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dyR9zdaPU2+QKmaNbH0+/9KoOXqZmhZZEfMGhaEdAPnkmB+snmYz5AwWo2raQR0MwxIqyn9rLCEW84/9P8A5YwLT6iBW/xNd4/dhsptpgGA15NNnXVIBu3u5Hk0X/EuSotgAVDMkL/CPDi2xaw6pcpZWlxJANqkTRAR6AFjZGWy3VzP3orEmagH+S6oXVLF0ucOTT3IZLuVTXcB3j/AkDXky58DEx/VFReUckTu3m4iEsWbRaOpV4CsfFu3Ob1PFzsHZGSgjaTwgKCCufQdNSeXgT+acjy8JJsH+O3CS71xql0SPwfuQST+mLE/oZJRyZBqfw8Oslv3m7fSjtvLBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WQAHJeilCfwyRK6Gmb+bmsoga3ZbAyGxFKbnkcuoRE=;
 b=C2Yb5Pr0AvzKNtOn1FvpCITu/ZM2dcH2j547q21aAXwMTg5CqBwlhFucEOvskhggBZv9vohzDS1jBwqWmYV2/t3m0GVoeluX9cTu/RPfGHYqJx+IBGFuLap5r2u7XxyswEPI3UizGJMUqEu2CqXKS/P1baRfB5dfp2OYGC3R2N8bLnEZw1yyHz8KfVoWnkcQ3vYdrS5L3ddAy5VFdoCfEd3yDhNaKTLcWqPD0GyV3p1Y05OHy1YFuUN9kd3VcWDRuiBGhbmth3hkkjGUwXBJB2VxPL7fUAovbxzXIM4lc50oPZDA3eTQUB4HbDlYXN3SLulpOaATnhLHnxpxWiLx7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WQAHJeilCfwyRK6Gmb+bmsoga3ZbAyGxFKbnkcuoRE=;
 b=l9qHF4GGrMB4zhXcp/wPI8UCZxxV7txQlWJQKRaC99CG3tpDJOLHiWi54yTyUJ71xWz1uu2fa4Y520Mhd4yrVReZA6Tlok9DxrnJcU6zmBs3lvbFoq0HjvXh96qEom9v0LoeejLHxdVDxitw65EihwbPW+dCYcGbscCnYAdtzXSndYzUmkf88JunFykoEp4ZFk9Ok3LSGgkVDaqUwM7B75giLNLFCj1U4dDyMKYlpAgXeZfADHE7wu6d2FcFSQf84m/Y8E/ze78cH7DSrCdsJwDPNUUnsd3HSZea2nm9Bypkhfwr86CVNCQX8wkV/CMPaZtarqffgZcztz2m41Xp2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9133.namprd12.prod.outlook.com (2603:10b6:408:188::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.19; Sat, 9 May
 2026 19:40:55 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.019; Sat, 9 May 2026
 19:40:55 +0000
Date: Sat, 9 May 2026 16:40:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Josua Mayer <josua@solid-run.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Samiullah Khawaja <skhawaja@google.com>,
	Rabeeh Khoury <rabeeh@solid-run.com>,
	Yazan Shhady <yazan.shhady@solid-run.com>,
	Jon Nettleton <jon@solid-run.com>,
	Mikhail Anikin <mikhail.anikin@solid-run.com>
Subject: Re: [PATCH v3 2/2] iommupt: Avoid rewalking during map
Message-ID: <20260509194053.GM9254@nvidia.com>
References: <2-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
 <321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com>
X-ClientProxiedBy: YT4PR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV8PR12MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: 68cb3ac6-6b53-47c8-845e-08deae02e28a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	2bOS0Xka04Jr/ykSMiLLBSDr4PiBmban3gHIwwMEqIWMO3k4znhfmHdkBaoyaUaMj4fAllioGkED4fLlhGRPOtaGGT2DIJzh9Q3FpXOqd02u7ORCD49V7BXNiSFIJn0sK5I7aJw20msdwsBNxjXFj4zk3EX8tnGxe+vdwheL8RUlepvkuCRhxkNmX1+BrF+0NQlwWlFAZs4S/6aqb8lfenOpdXyDzqhy9J2MvPxPXadjgHAPZD0Ic8G5TcCKOAtq0JpOXVgcclna6DhBEDXXe7e5TKX2V3LvX43kcJLrGOV9iIFlJKOarVEGeOZtB17UoBmhgOy4SJaJrgXKv7jm/1ud/Dyp0R6bPUmxb6prpdF7XX8TdK1FaQxD/1w61NL/vxGGXKr+eez1rzlJSRQhTm1MSbEuX7TX17xiqOoKX1YVjd5RXpT3Q2KKi0iorgKpvzhZHuyjZP0Ocvlr4QgxAl3o7t1uibfvaYDwyVEuUTJkaqY6P8dJXXoiswiiJeAe8mBqE86RbDfFCSeFASKYicSUTY2pMQkwCJUcHTjANNkaBk0c7c9JpCCO0iHN/ySc9G+I7JNQd96d4qb6U8acyo2P8qpuvmeN9D/a1qCBgKRiD9L73qk6t29n8tOEREZRJ26aiqJpCKUZw/7Ev9qbDZqppjba0iZ5lSfQ1iYdDvY+/k/Y0gCUMJP7/AyOvx2n
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qtc4WySBuwBkIUg3Y1aGzamynQ5swj+mMxqgT0ZL/CxAXGqKO5bBVsVfqHrY?=
 =?us-ascii?Q?eM+XtV8j45ViLoDoPbjC9LP8kC9WE2PWqvjZyyDMXi7zBq5zGHsw8zIHinkL?=
 =?us-ascii?Q?oc66XHU8yVi14rgSA9FmK2cR/OiD8d/plslPGOBdSgeSK0Qu1SRkvLQ09Oti?=
 =?us-ascii?Q?4eTUPJhnsG6ErXrYnkUFRx0D+1XQ+BB7z+MwS5OvaVBof/3+pMuV2ugNfJph?=
 =?us-ascii?Q?AFWSmR4x6cs6fwlucf6NICRenyZdEYR89Vbc1UP6eqUJ95YTIqe8W9OIk6ln?=
 =?us-ascii?Q?au4kU/+FeFGzpeo4lb0PQV9AUkRrjK0LmiIbpjaAKns+STD2G5EGhCd0z8h1?=
 =?us-ascii?Q?1DZmlDBobWpUwOWALlMUaxrARwu95qspEe4vCJtD4cKbKAMyKaqOWeGrJziu?=
 =?us-ascii?Q?RRfJEjI2PNL38GLtlpd0qiN8sGoYKzpdWktMtAEY0kQirrED6jGrQiP22ElU?=
 =?us-ascii?Q?9TeyQyXwQQpZy+1eZ49B7ZyXPU93B0hqirkjqy+vFYLhHkFpwfu0hf5wMOPz?=
 =?us-ascii?Q?hDOyoOpu8mZ+HAiAV+U/Glr2i8yLsRfZdZM8ABsWFy+pYY9HheUHg9shUu+m?=
 =?us-ascii?Q?b9ZBmaCEZlQro5EYk/yQPa8WL7onP1U+wtR/AdiGO8H/wWAdcf0xaBLgqpbN?=
 =?us-ascii?Q?I+RlgZEWtHWgHCDycLqVzog5jFywS5XAn4WEws0hUyOdpayTI8myamc0Zpt+?=
 =?us-ascii?Q?VrPutUlVPbJwYCQPg8I6WPDIB355HyUWjClLfd+gGnlHQBFPB7eu8gw0jIpy?=
 =?us-ascii?Q?EE/alDjPZ5TqVUfjw6HlX3cazqxSDAd+N5GuCk2md7ydWCWtCz93B3qukQxx?=
 =?us-ascii?Q?o6ASQbu6NVeix/250yWRB54+heuI5k5ch2+FpZLYS1VmdsAQQdrjEE3ME0hG?=
 =?us-ascii?Q?9VnHYG+m7Cxkpf47rANIuIT8oy0HDLYe834C9HJ004M4zdYBxqZYE9VtHu8v?=
 =?us-ascii?Q?GI2Ha7cPaAPMwgZZkGb40Dvv6g7gebg3c3czCXRfp9rwDugUm65kfOu1ClxO?=
 =?us-ascii?Q?kpqhuBhQvVZ+P6cn3Vqw7JHvBL+KukSKQ3b9M0Mx43+4NxyvGkZXYmodx3PW?=
 =?us-ascii?Q?YZA8wW8uNpEfAg6wiN6uvyqBCyING6nexOGaoJjxBU3tu7Q4A/TkpSXiz6/J?=
 =?us-ascii?Q?/wWA9hcllGlN18CwDYsn5i3quIcgYdsypnaxeTa9QQwtMqpHX/5TgeCBQS3P?=
 =?us-ascii?Q?r5vdcgFc04La0jiIWcMu5bDKir4jrSesQrb6CxSrBZCWCV/q+4Nuaq4kQjSS?=
 =?us-ascii?Q?H4Gt5TsjkNLmcjzAbk2ajb0EDhU57gwmzp2pdJw5MCdMRSheykWs255x9kZF?=
 =?us-ascii?Q?iEnUDCp3bZDxSOdw303dhJsVtGV0woU6GUo5mfFsK+pbzB75I346OyNT2jQc?=
 =?us-ascii?Q?h6ug9roeCxhOYU0fr9ZJ1mHil2WQoyeqvDVFSApreXt7QRu5XHpGjFvP7Q7W?=
 =?us-ascii?Q?PLVEp7ii2UGyM6fZynZMQ2QJ3GzUbkaWlwsdeu05gWia8Kxx+QP0xAxeQmHK?=
 =?us-ascii?Q?PRrJ94Z40Lb8GW5dZD4iKCYb4L0L4TAdBvSsOkWWmNG73Tgxi0cXGmOSj+KX?=
 =?us-ascii?Q?m3blgB0vz43OQNhNnGTE9CB2u4MV88HFKTmvkdcv8Cr8cfFR9fBkUhIOZGKe?=
 =?us-ascii?Q?+Sv5yPC86D6Kox+c4saKzEntVi/ll0NSXXeiMYKO4bEPAXgr1o+0tW1cXmzD?=
 =?us-ascii?Q?YximlO10O2r0/mD1IvVxJFPjQopVaUK9r0RP7b2rwyokKTij?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cb3ac6-6b53-47c8-845e-08deae02e28a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 19:40:54.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yM8uSKrVEFCvuJYMTNImR0DaN2iL8eM03EkK5w8DM1/SxH0pMwuhsh4Vj5Td1Apt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9133

On Sat, May 09, 2026 at 05:41:02PM +0000, Josua Mayer wrote:
> This patch has landed in v7.1-rc1 and introduced a regression on the
> arm64 SolidRun LX2160A Clearfog-CX board.
> 
> Since d6c65b0fd621 ("iommupt: Avoid rewalking during map"),
> boot now stalls - printing many smmu errors.
> 
> Please find attached full boot logs for reference:
> 
> - good.txt @ 99fb8afa16ad
> - bad.txt @ d6c65b0fd621
> - config.txt: .config from the build
> 
> Is there any advice how to deal with this?

Does this help?

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2669,7 +2669,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
                return 0;
        }
        ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
-       if (!ret)
+       if (ret)
                return ret;
 
        trace_map(iova, paddr, size);

Although it would be surprising your system triggers a ret!=0 while
booting successfully, that could by why it wasn't noticed in any
testing so far..

Jason
