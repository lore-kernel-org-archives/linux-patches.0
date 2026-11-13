Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794598303;
	b=cH124u3syLZPkf01kkkoVshVPk5ogCOASCFb1cICWSBKiAXb/kjVjF577b+E2sMNJ7st
	 bRbnPhPjIM7AkaYY0tlWTIihL7Bl1oCdd3e7PYA9K5OZP63wQtGr9m5qd9a8YtjQ4tyWT
	 L9P6183QROVUDefZgULoD/7dM7rHSCIyLgaVqfmGSGEYWlp96KMn59hmDJrVbAJLd/POE
	 mjGtTQCkMx2CtY8ifvQqdyZ/f/+ZSEbE1pz2AMN6RPfeWp8DvaRq7TKG2ZCbNewGvdLIz
	 958wlCeBtl7D0mEjiGxiU8kzbnWuy67i8ZqmYxPgGoC6eVjfAOiVN15EeXksJ04KBQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598303;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=XEQ8716OiTb6LdwdY1JgBbs+xQjuuETIkD2FtAm+2gI=;
	b=XdYKZvvKBPDKh6OdysiXF7VJJcfK6i+YfOUASxrL50nfgy7bE5H0LIihF1fcagcmFARw
	 s7iwB4VxnHndDXEHXxylqxNa6TfdO9fP2hC2dgYcWUQh2Q8SDaBE7gR38pQQIJ1AdxLSA
	 FlrTTUL54aZutyDoMlM/ESzfbge2f0xykVSDSES25B8N5umf3jN2LRwds18c3q/SbmhJZ
	 DYcv2sSf/L9AOcG0bOy6r5/vfZcda6pDVn0x4i2zkAOB6V6CjyvPGXcHSC9SvWszxEnl8
	 +fzlbxwKSpkni1W98Lw2qTtEJ3YNuYQiYwxfE0VPNOO4FRLl0vLt2QoYj3Q62WjWcvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rN6aXeYH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.13
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010013.outbound.protection.outlook.com [52.101.56.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B7F606A333;
	Fri, 13 Nov 2026 19:31:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88B7F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rN6aXeYH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyuvwJdKGQNCF3V1reO8/KorEGwjAWHK/HX9eh+TlllqRHP1ahbVBQTbw3tkukmAq4KdJUjeHPlO6ZHjNmaxcKpoGx0wH61E81adOeplelkLJdFUUHRf5itkplCZ2WdRwkWpd/wP9HF69bUaFIYLNQspmIoTiBxqeMNqF4l7XFkbG4qrQLfnmzVCu3nXOuEyd4895d/oNdhKL9SSDKZqRIq8QHuTnhhIeJe/QHRdb8i65RNTSYGZrKedNXJYD8R+2Gzux3gFv45E0kzxrUdVaMjAFRBt/41n927dVu6Z+AFsTvIV3BhTKiI+FaT7/wXwe4mfkptonueNqUZoEOG+JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEQ8716OiTb6LdwdY1JgBbs+xQjuuETIkD2FtAm+2gI=;
 b=NLNiDJVSfPvomHiHwRiG0EbWoXMcT2fYTY+ST4kwJjXllQuLG9Krv9yAc4XIELBVfHUiyMGYng4nui5yb3QvgHEWjXeH/EzRBh7SIdTI9EIUtNoddBEdcn6RA2q4Q2qrnYsY6aRj7sPLV+F9Gv+qZBcj2BSwmCR8+eDKQpAy90TcZtUS8Dlhh7RfvZR5+VdOvFsuuEI89PCzISLDNm3OYwf5UvIqvEvGhCJoVLPpcMOxhBGTKNSLa/C36c3jCNsZtCZtzV1ouT6gqEmxEhY3dviV2kFz1DF1DkPo5QkSI5mswBC2gjnOfgSeSf+TBpmUjpBWVsGoDsljfvV12Tu5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEQ8716OiTb6LdwdY1JgBbs+xQjuuETIkD2FtAm+2gI=;
 b=rN6aXeYHO2yv8lXP/+eYfkEWumM+DN/sNUGnTb3V9do5tYnXKKmfw2OM7Xi7q06N/ah4zt7Y4r/RqWNa0FAZ24WIiIE7rONV3D9waKfJTiFTvbzaW6AI2/dvQIvOdd0ad3g2ugDIyCIe02QJCb/tvSLnboaXTrLI7leOa4L0eNoR0X4aHCC3bb7tXkONUXg6Pp0q/R5X7sfCdia67xRg+HFePZjEamgrtIFE1dMBDdv+FW8IfskxGnBHr9fn79Gz7cXTRP3oHKGzzcLcNfDo1rOc5gA0vpqf8JBxFC7Mf9tka7G2hFufVH0FH4BMtzTtyT0tMoivopk10j8ivRQsNw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM6PR12MB4043.namprd12.prod.outlook.com
 (2603:10b6:5:216::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 19:12:22 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 19:12:22 +0000
Date: Fri, 13 Nov 2026 15:12:20 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261113191220.GC3706007@nvidia.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <yq5abj7tm7q4.fsf@kernel.org>
 <20261113145249.GA3706007@nvidia.com>
 <yq5a5wy0n0up.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a5wy0n0up.fsf@kernel.org>
X-ClientProxiedBy: YT3PR01CA0032.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::31) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM6PR12MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: c28a18aa-d82c-457e-c3e5-08df41ba0b34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|10067099003|4143699003|11063799006|56012099006|261022105027099003|261022075727099003|261026140227099003|261026121527099003|261021135927099003|261021121427099003|261028144727099003|261102123227099003|261102130727099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	nmETY0s+iC4a8SvEUj77zusi710pdS6UWLjBvT+ycA+TZf4yFqRXSf9g27H376ONleG20qCr+SfGP25RK8tiejym1ucYe5cIFoOpsl3iZwVyXWVChuixuDNcROBLI6v2dcOBWsKFPlq0TUSymhsWy/CsioCdK8LHRm8kBp8aHx3/CTO6RlPJ6awKr/DjOIT5hCGnIv3A8DMJwBdjRGRho7kqfVrW15s5PVMaFNf8IijstF+p7eRPBaakCXDy7d8udxuWc21DG4Iv2/BjY9Yo2tNlbArgZR6pGB5Xj8P+YKh76Z/OpcyGOcPBTR8uAEHy19Bw/YfHC7gJjqyQtNFOAcpLaciAbceu2AcWt+PEh5F040j72U5yqb01srIrXJRrNdNNpzJZ7lNmHrVZXI6k6fy6WYv52pne/FWzEQ+/9JZDUbDAM69xc4sKz9V34oEKCvuz6ChZPwG7QYClopGN/d2YGUhLJ99bgnSINXSsQ+yBm9COXuUm1IuHI4Ke1+81JEbL69J3gdWg2Wf89lp41eaFErFc/4mHlva1GcBVU2SuYtjD11uRrGbw95EMyhdrvyXByPC5JFiUMNX0UySOTBFFK06Z1drp00/1zQkNDR2WQ3PfWptrvQG3fRko89iyYQqQfeGmpZKp04qKZ2VcNCHdmeI4HOYgIrbje8Rqx34=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(261021135927099003)(261021121427099003)(261028144727099003)(261102123227099003)(261102130727099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AQiVn2Aevc+cV0sbvJt59KajnY0rGfRf5wAkX9C1W6zgG46tmb0ZTmCEY/GL?=
 =?us-ascii?Q?B60RsCCZjxEirFQLyiReMM57GEBWGwh0Bvd67ygjiiIYsQjwQIu3Hhb8pXi/?=
 =?us-ascii?Q?2uPLhQzCMaFvJ55XSVTQe/QfOghYt6qt6+5FhzDwijW0pIXe7mbKylTfsN93?=
 =?us-ascii?Q?NpGCyzAb+4kyHH2ORrZZvHP4k2hBkLoyL8RgcIzoHKxbYaA4XdRxmrrzTJ8H?=
 =?us-ascii?Q?HypjRFDDi/hLiGnYBBGoSGDdoNFFDj9PIyVI1FTUfG0+xhKct8Rf9BMkbvbT?=
 =?us-ascii?Q?q5cBOx7oFZPUckUvha/ePfANftQXrpz1J6J52+2UcKZpaoWtI1hC3YPPNLH4?=
 =?us-ascii?Q?klYS6MjNMwkCidgLY2I71CpPp+bMEVrzCVdomJZGo8TGsi/pv0/AKuxEb7pu?=
 =?us-ascii?Q?uCe807d3r8yO47zFkOlaOmn8RHAch1KMgd0TyAd5BI6ee4szogqi53k4hoiO?=
 =?us-ascii?Q?56SNqd2mADfGALVE1bAtR5Ax5IyB01q5/qpTENNRI0nOWYYLjQHW9G5hX2Ul?=
 =?us-ascii?Q?IcgqHoPOFzjpl+750cDRUB8lTU115GKD4XkBBI5T4Kbj38pgAbC19WJqVAl8?=
 =?us-ascii?Q?2mfe/vc3KEogGJ0MRQ3ctBPl+ZkVUBMObm3jr5E39407Udt6vTiX5Ndzvn1v?=
 =?us-ascii?Q?S2t4dpR4wpg4rpBkbCPhmcvQqXg5ccZp9rIQWK/pgeOO2QnhIh3Xz/08hAzY?=
 =?us-ascii?Q?Zj2Floqn2y7hTXyzAw6np0YqWNZsez9z+WNxblIgKaC7FApvSrYmI4HoPVnW?=
 =?us-ascii?Q?Myd8hKNr/+Z5L5WocOjaEVnibgLXfEaRUOP0KwFzwMZPQqTqpRReq88SxCkw?=
 =?us-ascii?Q?8hp6/JfAKMwG8lOG27M5eXF4RFCMICW0yPk1wYD84+Rh2AdRtCxISoFH5PCV?=
 =?us-ascii?Q?B2V5Re2BK5emL/oqfCX3WT3VVNScQXsxMxtQFT7PQcol77uzrQBHxOS/j4Jn?=
 =?us-ascii?Q?WAUNCZST5K3gfUtsZvHMfU99gCrIe717bTeu1NNAUzudkHSO+wund7guY7T2?=
 =?us-ascii?Q?vXGvUDvcMSQ6ITEnk5+YKcv6cQhAa0L9+g0rI3YNrgDT0AzwOO2K7SUAqN0J?=
 =?us-ascii?Q?FwsLMVMn3NTgjFjphjgE+GbAlWN8Ftk8rRSYzYLSv+9xTfRH3Nn3q+7v5u1Q?=
 =?us-ascii?Q?y5dDhVjXZuy608sN59Hnyq9se8EDW4QY8ChsDS8F7kBAjLk1flC8UBTfIkSr?=
 =?us-ascii?Q?JF18PvYTjY9N84PEek2VuuH8wBqiRQ9pzTKf5AdCpniMl44MeePI/jStt9eO?=
 =?us-ascii?Q?GPRoEWo5mkzTg+ukS2WGiQJGlsWwbwBK7toGuy9WdGQX6CsVkijaj2zQiZXS?=
 =?us-ascii?Q?9CPNHMhuhXF78qCDdS2mMs8XtWQRaq4ObQrjVpWyRQldENgNczH1ypnI/BR0?=
 =?us-ascii?Q?sUrP1PHBY8zrgdYti/iaZHTogrh39nnE7UY9iDtQnFr6qGpLkCvyqLM4FNtC?=
 =?us-ascii?Q?IbED9Oe6bUOVmb3iACHLEGl94YlZPHmxWe/17DwwN93//5OG40WuGbivhhR8?=
 =?us-ascii?Q?xPIEz2T4qr5NSK1PweTjiUdQcbTzOBA79oPho/KPpDU2ZU5X+19XYm06jcXY?=
 =?us-ascii?Q?nF88amvrSbI26P5trPefOhvAUQ+fXn28I3mR3sqtuRx8paKpJVN/lSl/oopM?=
 =?us-ascii?Q?tLMIQGpJvk8wyeIypD+Z02nCFfetrzJ7qSjUXlHbZwj3AWOmBDUMFg4rObaD?=
 =?us-ascii?Q?iSsZ1VPnKOcfuDXBSe/V4TsZosDGhBV9jivvbTjTLV/YDIyH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28a18aa-d82c-457e-c3e5-08df41ba0b34
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 19:12:21.8865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQTeL/FOf/TRyzxbSAwtbjCzmxodZGdZ9zmB1gR4l0shg6+kOyFoiNKancz1PScW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043

On Fri, Nov 13, 2026 at 10:08:06PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Fri, Nov 13, 2026 at 02:24:59PM +0530, Aneesh Kumar K.V wrote:
> >> Jason Gunthorpe <jgg@nvidia.com> writes:
> >> 
> >> > On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:
> 
>  [ ... 153 lines skipped ... ] 
> 
> > IMHO, leave everything alone as is today. We can make it work well
> > enough as is.
> >
> > Make a ECN for a 1.3 opt in broadly like the above that fits better
> > into how I sketched the kernel uAPI. Do this once we all agree to the
> > new uAPI. The kernel will always try to use this new mode if RMM
> > supports it and userspace gets a better 1.3 experiance.
> >
> 
> This would be the below sequence right?

Yes


> Host                              RMM                              Device
> |                                 |                                  |
> | RMI_PDEV_CREATE(No slot)        |                                  |
> | NEW: enable multikey flow       |                                  |
> |-------------------------------->|                                  |
> |                                 |                                  |
> | RMI_PDEV_COMMUNICATE loop       |                                  |
> |-------------------------------->|                                  |
> |                                 | GET_VERSION / VERSION            |
> |                                 |<-------------------------------->|
> |                                 | GET_CAPABILITIES / CAPABILITIES  |
> |                                 |<-------------------------------->|
> |                                 | NEGOTIATE_ALGORITHMS / ALGORITHMS|
> |                                 |<-------------------------------->|
> | Cache VCA exported by RMM       |                                  |

Again it should be individual messages get their own cache_object_id
so we get a transcript not a VCA concatination we can't break up.

> |<--------------------------------|                                  |
> |                                 |                                  |
> |              Require MULTI_KEY_CONN_RSP = true                     |
> |                                 |                                  |
> |                                 | GET_DIGESTS / DIGESTS            |
> |                                 |<-------------------------------->|
> | NEW: cache complete discovery   | Retain DIGESTS in signing        |
> | messages exported by RMM        | transcript                       |
> |<--------------------------------|                                  |

And this is just more cache_object_id's following the transcript
pattern

> |                                 |                                  |
> | NEW: request certificate slot 0 |                                  |
> |-------------------------------->|                                  |
> | RMI_PDEV_COMMUNICATE loop       | GET_CERTIFICATE(slot 0) /        |
> |-------------------------------->| CERTIFICATE response chunks      |
> |                                 |<-------------------------------->|
> | Cache chain exported by RMM     | Check against slot 0's digest    |
> |<--------------------------------|                                  |
> |                                 |                                  |

Yes, ideally, but it would also be workable to just fetch them all
without a request.

> | NEW: request certificate slot 1 |                                  |
> |-------------------------------->|                                  |
> | RMI_PDEV_COMMUNICATE loop       | GET_CERTIFICATE(slot 1) /        |
> |-------------------------------->| CERTIFICATE response chunks      |
> |                                 |<-------------------------------->|
> | Cache chain exported by RMM     | Check against slot 1's digest    |
> |<--------------------------------|                                  |
> |                                 |                                  |
> |             Discovery complete; waiting for public key             |
> |             Chains and DIGESTS are good                            |
> |                                 |                                  |
> | Extract slot S's leaf key       |                                  |
> | RMI_PDEV_SET_PUBKEY(key S)      |                                  |
> |-------------------------------->|                                  |

And here we need to to pass key, slot and certificate hash (I think).
If we want to keep the design that RMM doesn't hold all the slots in
memory.

Most likely RMM would hash GET_DIGESTS and hold that. You'd change the
RHI to also pass the transcript not the VCA so that that the guest can
get the DIGESTS message and check it to that hash. Then the guest
checks every certificate chain against that digest.

> |                                 |                                  |
> | RMI_PDEV_COMMUNICATE loop       | KEY_EXCHANGE(slot S)             |
> |-------------------------------->|--------------------------------->|
> |                                 | KEY_EXCHANGE_RSP                 |
> |                                 |<---------------------------------|
> |                                 | Verify signature using key S     |
> |                                 | over:                            |
> |                                 |   VCA                            |
> |                                 |   DIGESTS                        |
> |                                 |   slot S's chain hash            |
> |                                 |   key-exchange messages          |
> |                                 |                                  |
> | NEW: cache complete             |                                  |
> | KEY_EXCHANGE request and        |                                  |
> | KEY_EXCHANGE_RSP, with signature|                                  |
> |<--------------------------------|                                  |
> |                                 |                                  |
> |                                 | FINISH / FINISH_RSP              |
> | Relay                           |<-------------------------------->|
> |                                 |                                  |
> |                         PDEV_READY                                 |
> |                  Secure session established                        |

Yes

So, it is not a very big change to RMM, but it makes a big improvement
compared to what my previous email has for current RMM.

As a spec extension as part of a comprehensive upgrade to support 1.3
multikey, a little down the road.

Jason
