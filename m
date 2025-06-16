Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E7527713;
	Mon, 16 Jun 2025 12:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750078024; cv=fail; b=VcNL8W3IH3DPf2/62CjlzR2ay7h26wifW5I6i/Tz1kIKJoekU+9RGBfCNETn+3Ms+pDjI+CTs80RM+G8PCuinPANMDDjigKJ7wWoJ/hFBzWklVqFn3EVOSzxTUXxj6ShCOlRVHy+T0LHoT1a00cgqqPcNUHca0lls5dI+J6a0GM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750078024; c=relaxed/simple;
	bh=kGpbNFzP7NVzPP+pHEHWq0lP1SoXnUmE3WRF/+JioVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lAkbexNWOG/rcNxAi9NbPWzVjPBwM2qyn35ia115iGkg/niWWC1DQgwi28AF8v9Z2CYxRhvUXQkEfr5rHQm1W6piMegqcQ70VS0v15rVesRgaouTsRx8wOhgJv2FAyaDUZLiWnmdDaH9WN7x3xyJIkbNE2oGpSUfCCMXyeVRz0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XMHKEUHV; arc=fail smtp.client-ip=40.107.236.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XMHKEUHV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pcxaD1UbvbPKlG6V2sk+MFt6NeUsLMGT405z0usAKS8UO5jk0dVGz/5o9s1Fz0TL7OtjUCHEkzb8IblZOABQQ6NId9ps2MSFQklXgByBuy6MpkzdS9A8ypcKv55vhewFjgsouJ6O7Pk2nqkVUQg7gp97Z7wZMLdB6kS5CZD65IuU2qh04Gu9yjVpCmSpdEqbGZtxnYv3IeGmqtoj50cbm1lgqSkJmMAfDsPqmdwrlR48n9szBLs8g5p3I0tUDeIprKu10KFvKH74a+KXi9nxA5Ck3Zr3cQYM5fL/z0mbWwd5yVyo55hnCNNkWPPelvJZogv3pLR/h9UpmJXCdTqWSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RW5u4jvUnwi1qProw4iFyvs7a3MXqIKvqiYRMiyWpOo=;
 b=iwtbG2Ez8StwgfBrlx2gDL0zGcDno3ql4LYFp3pb2v831JIH7YdjQYL6SfSFia9M9+/RmeUunZNAkHQynxe2cTrYxE4lchwEwlZU0V/lp+HqXy19rBVUVbcyDuuRaIy7CFzLLkaXSlNVyzqPkriEuDh0/BfM1g6E34cnztUmzpyNzw8Li4m9pWlnhGvpUhadMweelGw2yZ0D7NLnesZPhjOkj2Wcsk5l0Hon7ow/ejU2V/he0ThZSKuL/sDiOtKBujZTkOafJhh7x5u4IO8Y7psWT8Q7c9sJ95EehWaKBC39pFSH47ta8Mkv1F/szihRjs93u495gyxK9aPWBh05LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW5u4jvUnwi1qProw4iFyvs7a3MXqIKvqiYRMiyWpOo=;
 b=XMHKEUHVZG+jejG2McBenAmBrXswscjNopsuP+gkRyD466hTFRuVQPHxIqiGbR50e1mn/qp2xNt8bYu87JHXkVOJ0WQmJMcWaxq2ifMGByXdrHwmSPnk8RKAF+mwgspNeZF/hyyE64pfuKYtKDCGdP/pMW9wC6Il3xle/l6KklGJtk4CXslQ/esm+xEVlofgts2b5x+EXpP1IqQfqNHAsTI73sVFFTvjsE5K2cAx/cveaSlG8GjEEW7rd+ieIPPlha0bBAP0N+QyX6tL3YNlV7GwpiBC1GDjZ3r7gsRaxkNZt+75Ue+1/zZvJpVo095DzujZtfhWx109Est/AsHa4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB9471.namprd12.prod.outlook.com (2603:10b6:806:458::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 12:46:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:46:58 +0000
Date: Mon, 16 Jun 2025 09:46:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 09/14] iommufd/selftest: Replace mock_viommu_alloc
 with mock_viommu_init
Message-ID: <20250616124656.GY1174925@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <993beabbb0bc9705d979a92801ea5ed5996a34eb.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <993beabbb0bc9705d979a92801ea5ed5996a34eb.1749882255.git.nicolinc@nvidia.com>
X-ClientProxiedBy: CY8P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:46::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB9471:EE_
X-MS-Office365-Filtering-Correlation-Id: 92e62a05-2d27-4ce2-3b87-08ddacd3e1c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hGJ3oyjom7iXzFE5Z1pZqUCeVGGAMjhjT0UPhxTKFOu7WD77gWkr9JbUxMI8?=
 =?us-ascii?Q?mzfxqIYWT/d/7AjmeXeXkKKQpbDUnQ7xQrSv/OlpZKUBH1uY6UQi+yO/ZzOU?=
 =?us-ascii?Q?VV2MDWVxGjvi1O8f2t3h7zcCXhQ4EP0AGOVzBSoUBFdVHNwb2PmD+w6HlhMv?=
 =?us-ascii?Q?mWIS9gXkrKSrBihQq0W4QIr90S+KaG47vyKpW6p7xFJsyB3PwV7q2JvM4jlt?=
 =?us-ascii?Q?qoCbhB7xhewX4EqEIWr8Zf1HJvnPx1/R9pXYpDRJQfTtFlkK0j/QIi870pol?=
 =?us-ascii?Q?yTQ0xWCmjgGSnlL4l9TBJQeC/XggexCRQUNI+lW/9frl85wsiTZGB/2l8FaP?=
 =?us-ascii?Q?Dq6HJ7RxGkDrUD871Fzeun1HFtOfrbEN+vtXg5bltYoXlN/gFxGNw1QSLiRj?=
 =?us-ascii?Q?+7MN9de3f0I7C62dQPFw57pexJ+pO4VJttioRvKgQHNyg7tzVmXrH9wtrg5d?=
 =?us-ascii?Q?S4A7UmLZMGcNyqU6CK3R1gi/lZCpkF/cihMwcMkCZnUjPzO5Y8ZqWMGVtNAa?=
 =?us-ascii?Q?UYdfpZun5I8jfyDXGlPCMiuSyNmW2FCJssiBO53JqYTUUq0+6lqmBnuOt8iL?=
 =?us-ascii?Q?xyBOS1LtMr7Cs3/UGoIcvt04VtJqWUlGWhC7IUabhFXvGG+sM918WxsUFBw7?=
 =?us-ascii?Q?IQQPKH1cMgoBWxlpm3GczulmASwZnRN+taH4pxuG5jNqScMDU6RwB9MQn4Qt?=
 =?us-ascii?Q?sFcYyTzyPh1Gz6iixUnE/gVp7AYhAuNgHXtB2F4ja1EsLC6QZlscqgU9d8Q3?=
 =?us-ascii?Q?l6LLWq7YJX33Jg+w8BDeYpVjlXZ5QsaGAFaRi9oXXhiTuiZ3RawB0eCkMQsz?=
 =?us-ascii?Q?uYr7szjuhsF5Joji29gU79I4k8FLuOq6S70lJ0pNiNgAegRMKU9uen+Gvj4y?=
 =?us-ascii?Q?pEM71VaGO4qSu6AdxBq0BqaMcUweWjVNIcNdKWPCLB+25gdBdyxXAGwziHdp?=
 =?us-ascii?Q?xZm4XR1pjIJ083ha/CadD+lbpCesemvJhzix7sPzG7MBZGcpZL6waKgOI+Bp?=
 =?us-ascii?Q?aa9Uv7NM9CiVdfvLtgSZtNit3/cegqQX7R2UwxBDavlnmGyU/1JZd3UJSQwx?=
 =?us-ascii?Q?XClGD+2kTmoSqtM3gSXlT2k+7JTsyGFT1H51UgksFfe5tTsG7qPLhti1ivQA?=
 =?us-ascii?Q?pEmhTv4asowWTqM7JpJKjlK43btYqX0ISrmoJl9xTPDWvap1qOvBcPDGR8vY?=
 =?us-ascii?Q?0wFV8M/nEWdyRLKahv8ug4dMbZWuI9hbcWo0qfPCun1L+ZbFNHp0k418UsHY?=
 =?us-ascii?Q?tEs+wQcEB0qmyVR2PpqTjk2rCN2o7qxYuR2H0GD5xxXgslimNXQPfKgLv4dj?=
 =?us-ascii?Q?/9mmTDSQkQtFYngAy9bZuK9Rz2hehKRT1nbHqiZVLzcsixnO/xxTRaDziifJ?=
 =?us-ascii?Q?ZmzMshY7QzSV4+XWpGcITXhytk8QrPMv3HXcZuFG257jkBTWYu/q2215X6vZ?=
 =?us-ascii?Q?4Dkv/NBX03o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9XIoalHnxe37tSHWmtODL6srfiNeP5/ZBZCN6jsrJ8WKH11AbyEzVp0pfFq7?=
 =?us-ascii?Q?KTcb5Z+1p38wooiePdoyjSsa/GWfO5SEhschW/0/v7WjKbzjd/eXQwDPV2wr?=
 =?us-ascii?Q?/zYX8wKgyVe+S04h9FsVVhkr7sMJGHMY2++0LsDUk3UFzpddChZ2RpqUndG5?=
 =?us-ascii?Q?K2J2RWgMnNvLQUu92I/Q/rh5IpUIQNssJG0M6kCck1pqpRQv/Pf1FZkNZYAM?=
 =?us-ascii?Q?Pfx1K7WY5np4DxxY3VkAmgMLSmi+Z1kvyjSXzoyNmdYzD/IO1DeVJeyw7dEG?=
 =?us-ascii?Q?revG1sgBdFkAhoFcgG3A4jITIEPNg2JWd+lnL22labaFQ2XlGNEDInKPKKLO?=
 =?us-ascii?Q?+hvG7FX9uL4AczvVXaiOhrlDpRJHuFpysnPYv7nB6SN5DtdlBfmmMlEbrwwI?=
 =?us-ascii?Q?b0Tx1cK3w20jruf6+iFviQjRkAy6/7VApEeHC/pRqPJ1v/Wc6XUek7ygcWrU?=
 =?us-ascii?Q?uSPJRrCwYCBV54w+2WsIMntzFIgLRVfSx4OFuxfjSa3zSH3Zq9QLMEA4ZvJ4?=
 =?us-ascii?Q?zHkKUUJ+38kNVc87ir3boeyYYadyyQNCMizBkpb7kXhTgb230s9ncDdwFSBL?=
 =?us-ascii?Q?Rt0zrYW8y8HUfwLebbRy/tzxZt8EKoUBreTrh4fpRBOXLz3G0AraF6bDdKBa?=
 =?us-ascii?Q?RcWE4vtp5kqnOhhr7irvJxWl/u4WWpjQ43GWulUt9MY2KYX4rhYWwwIEaaoE?=
 =?us-ascii?Q?+RaB0knE/4QUNPXoVXEyU+BUcxT7pVXtOKA2tPt58GOV43yi37K7Z4VuMbjO?=
 =?us-ascii?Q?Xin9ve/LCErUfKcxo698apJ/YUdbgZf6wP+YNhmYPnUu5jcY0S6OB+1Mobhs?=
 =?us-ascii?Q?D+v1oeQTMBbZJXIgEW6nO3b9cry+K/Wz67KN/3tyM9lkZKIhD8haPlyN1EIy?=
 =?us-ascii?Q?QP/vQM4LRvxVZJb3tx+AH/r0LEmZsbIlQH3QRNDw7QxqQsVoA6fhWU/tYAZb?=
 =?us-ascii?Q?AP9/nVh/rwB1CnriiXYQSdy0zxh5ZVD99Kz8uH3zyCmBt/+JcbgBanm/5sLa?=
 =?us-ascii?Q?nxgl9Z4cFFR0U9bNoZ0B6kUkdSuEajyJ7SCrS0xb0NJxRDawvO1A04rJHJoF?=
 =?us-ascii?Q?iE6LAzACysa8hPUvLaSv0ixX/hPAGIZS+UMGTr/bTed0uPMFT+4a6yhAkbBn?=
 =?us-ascii?Q?S01aA6NUPZk5CUhGD/MCI/gMxuLh9Jf6bqHF5whJUvdT9ZXg4wATvF9e73wQ?=
 =?us-ascii?Q?xZT1fot7hsDbD/Z6MTGLjgd7LOcw3BikJyDhVkm8A+hc1Oy9W25LiyKpt/zi?=
 =?us-ascii?Q?91CfVe49iPT3b2YVU9WXppiQGr45NzxZ92zrrsvcENzlUZGAamzINLuLCpDB?=
 =?us-ascii?Q?Ulg5x8XAgjU9aGVmB3RzoMQzLBV0QNpB7uy49TwhZ10vs8XxmHW/AcT/KWjE?=
 =?us-ascii?Q?iIlFvHlqT9GnZETTIel8NdgF2Dr8DarVzYM7qg5bj40UQpbLNbMoK+WMXfZL?=
 =?us-ascii?Q?YurrXaqolx/YRxC9zTXV7lrgh5v1dZftjOT8Rj3tSO1/7CTneESBOEKPcAKQ?=
 =?us-ascii?Q?9o4IAFPgibT69cPbhv/B9AGuXHTxbFiR8opKfGTaK/IJuUBeSIgjHK+93pv/?=
 =?us-ascii?Q?VpBZu1P9UuVjX/KvxJ2WN0/p0pBI6VfjqfJ14oVW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e62a05-2d27-4ce2-3b87-08ddacd3e1c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:46:58.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbynRTTGwlJJ2gkUQuRLwbICfYRs6hg4hbo1Gzz8Om5M44Ra4XxJuk9mVyoBTQ+u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9471

On Fri, Jun 13, 2025 at 11:35:21PM -0700, Nicolin Chen wrote:
> To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> are introduced.
> 
> Sanitize the inputs and report the size of struct mock_viommu on success,
> in mock_get_viommu_size().
> 
> The core will ensure the viommu_type is set to the core vIOMMU object, so
> simply init the driver part in mock_viommu_init().
> 
> Remove the mock_viommu_alloc, completing the replacement.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/selftest.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
