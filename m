Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065301E492;
	Mon, 16 Jun 2025 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750076891; cv=fail; b=qVprH8NBYpCqrPdyHP83ASgDVyv3dcT0ZqBQvtIWwNRZ2aTm4ID1aOxHxKBtdz1a/1sGvdE/T8TGw7LYU6L7d7Ys0fE2CsU+atn5sqTZalDHDplqQSsqnqFL/Zt5sMgpYdwNklQ/O8ziGkxvezf0f5bSXn4FwqXDqX5XBsp1t/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750076891; c=relaxed/simple;
	bh=sqX1ymzikeA8GTam48yIgKNpCw8GQuXqDDH8rnqgxnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QzGTZ4dnxKEONeg7l3CTPtaDw1YAZKl9xVd9V+yl8P8Np+LtBgjAU4oIRbWWK/Q8E4wKyojtvnGvk7WdAWM2wwIox5zViZSzQKUeSsrRYto7d5LY3BeHgGcimAYSeiY/d1D6ose41fb7c9J3gd9enZxifNMQFYgI7C9R2zPY0Lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z2iBNSvP; arc=fail smtp.client-ip=40.107.237.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z2iBNSvP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gVlInCzVGpioDQzGQpohp9u7JJAmfITGyzFzjgQjZHkX9t0kao/EHbbfPL5p4fRMo9YKq7aijvyDnNJFhncgAN03q3h5JnUgto85Dje3zg5OHQkUY3SJtvO/r7lYL3RkZHeB8Sixw+A15V64Y1rHJBLQL9m6Z9nLhFgo6lLvZRWRrVakZh5+1nOqItzL0RRD92FFVhxd6L8I8dmZYJeTPunlpML3MQbKLm/dK7ZBGch2VXHsnvIes+X3I+FnLweD2ch3wp2NxwCytlRl2WBc56feFG1Odo3poygv3pceucrhe6kxlT7AzejinwS8a/usxI0FZwm/GrD/AQEezPz+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GbdLCa9hOXxMNEHftkixHwrEtFTqvFdI0M7EY6BxmI=;
 b=G/ZWauHdiA0yDtqyiLRzi3X2R3Kn0HTcTfcD8q44i7jQGBlNf0+ou2ANQrPOVtHCGOKjUdU3U2/IxIIffN2+0RlLW5P/FrCRZCDdpNS2wYDLlW+9uUHktdwtc2+GLxVns2a4HyNok/rNCWGouCfPz1XvtW2FzJlVNgbuXuoRrwsaB/Np+E2ykavHRLDqx1uNoYW7xdQg/r1NJgvPUixZ8CL9S5K+JbRiFATm153ZrkzKxJv/THaIcPzBN12URci/2E0zCledeZuVB7dlq+iQgQRuZSWHAMfqAIhj3p6Yij9OvegkVTcIEP+AUygA6PzViQtyct8tqNL4hB/PJVAFAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GbdLCa9hOXxMNEHftkixHwrEtFTqvFdI0M7EY6BxmI=;
 b=Z2iBNSvPIJ+RRSdwLASMlOZ1HRE0RfXMP00BbUcEbx68x9VIEwD9P/Bp3o0hKpil/Cn/9BdSnBfOVe/qlnfqjlwcdQBHNkKe4MqSv8NlDKK1QAd5xRvaaj8xO7Nnabs0ao+cG7yMD6n518MOGXtYEup08EALmK2C2Cf9bMWaFgPT97fjIqRXCLBEjmESL05ZiQj8DVyhvs9h2N3WEAUXPTS4zfF8MTpoYvOBdfEk/XhCLjBfSNqIgiTv9obkhPPWGN+kUsH2TLEUTthnoAN3643lmslZe8K7WFub1dWGjiQBJmeOgxG7e/AQs/qJ4+nfWBOqq6m+i/vrETjIoYpUzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 12:28:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:28:06 +0000
Date: Mon, 16 Jun 2025 09:28:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 05/14] iommufd: Return EOPNOTSUPP for failures due to
 driver bugs
Message-ID: <20250616122801.GU1174925@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <623bb6f0e8fdd7b9c5745a2f99f280163f9f1f5a.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <623bb6f0e8fdd7b9c5745a2f99f280163f9f1f5a.1749882255.git.nicolinc@nvidia.com>
X-ClientProxiedBy: ROAP284CA0335.BRAP284.PROD.OUTLOOK.COM (2603:10d6:10:f7::8)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: a5853781-93d9-4ffb-7017-08ddacd13e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QfUf5WpV5kFwfOflm9Q16arr7JGJjMEjdjPe36vlGs9psaYavky3IX+oM/Et?=
 =?us-ascii?Q?lSfDOdZ08zXLz6lV1ih8E4VPwawWZCAmSHa/KD0MWnGZSc74WxILBbF1LcRi?=
 =?us-ascii?Q?66NjrB/eJ2LO28EPiO6CzOQh9Hs7v5qkEiKM7sOC9/dDtOiavPRmQMvxcZTj?=
 =?us-ascii?Q?9rGpWgHK64UmUevXCgV5mbrOKeStIH7vkLRF3lhhyHbwaEHh0jkhz5HvCRnL?=
 =?us-ascii?Q?BtsZ3d+FD+UxTg3OzNjIfZHD69mVxa9MbnAMA8cZsvvCJwrvpRxLCj+Ih0dk?=
 =?us-ascii?Q?ghQetFR4qtMD0pkw7kiCgySzGYanEXKQ7B+0HsuaLlAwC07svh512xQl4PSL?=
 =?us-ascii?Q?MR5g3tcor9A4bblPCfVnPOP4MyAwG1y1imVjP0q+ABZMXNOsn/bc1S2pXyLD?=
 =?us-ascii?Q?+lJTBcRSEP6XSTbCTyiLXrWZnfRSEaGSFVWBJyM1uhGOH8Rp4r+5O7Wxr/FI?=
 =?us-ascii?Q?5V3jnn2M4B3mQyvgeBcAlc962/m3lpgSMp2+nGIXFT4Z9hYu8SVj47b0a60+?=
 =?us-ascii?Q?STPggFHX1DQPnF8PIXt79SofkTWhUqhlLk33mjRUif5O0au15qE0+hVbEX6d?=
 =?us-ascii?Q?c4g5Ln4YAq9B0qI3xf4d0H1kwqf4lyzNM+L/YjIjdHNV9dIQIQTP4tplMA9j?=
 =?us-ascii?Q?v+SaElcPNpztAC4US7zth6xZCV1T+YZPibQ5TmqN07ZrGggTZsvg+rXxBrfh?=
 =?us-ascii?Q?0CsrbdDQan4TW7dFm0rLAuQdyCocShM9/Bf1vrrzOUSTCCAEwv8yRWsKuOob?=
 =?us-ascii?Q?wdGGaqC/iRmiVHb0BemhrDGkUUGl14xHgJsB1PMFdBzrvqCRqsStK47t6nMk?=
 =?us-ascii?Q?iOxB1jsaYnzhf3G53Z2zB8oYPZvmlrp9GNhub7ZuBN4wgKrg1P2NxgguSMJu?=
 =?us-ascii?Q?AegHFFsEfIXIaQdeOqZx/3VzqGwgDHMPnv3JOVFRuR2gLWU7nRIE95s88pHG?=
 =?us-ascii?Q?Mpv/uArOUdAIcToTxKzbC45KQhixTwoqrqnH9oCcG+YBoh+82JCPwj09epur?=
 =?us-ascii?Q?jYVzOFrH1iAv0hADPTYrQGGuyh/Rz/dEtT0d5CZhdSk1vVKLr+w0mSxGN6l8?=
 =?us-ascii?Q?zL3jMzGRu57ihx13+OW1fTpNepQFIe6VmjUzJdPdGlSzzJwESUcfALE458xo?=
 =?us-ascii?Q?lANkq9xSdWjcdzoWRiE4bVlTHL0AZ0D8h+NQiIZTBafQ6XePyVeCgFbDrLGl?=
 =?us-ascii?Q?tN1WcW5JGnKDcKUKTaSuyV3085GOwxP6nrAvNhzAGdwxKfPH2tI6Us43obhw?=
 =?us-ascii?Q?YK1MRy71krcisI7mA1uBUvxB5Y6ZnBVnHvJZy98LF78Iop+I+qBZ4bkrLdDy?=
 =?us-ascii?Q?TNBhiD4jMn9gnD/z31dy14XbsE5obHO+qopVXamgCKojmhthmBi3kmd+FE5a?=
 =?us-ascii?Q?UGwjTkosrw2oybvM1nLgL6zcXToSzS1nx1+P8uYQ9sJ6y4z3UOQuZ1CNio36?=
 =?us-ascii?Q?FlpxLE1bYrk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OhNlJuRdnC/OMX4C8iWwWWa4fp5kZ5o+qtRsxKENMPKNbyK5yKsENaaAHpgj?=
 =?us-ascii?Q?xC/A1HQUWLM6t0ydFriQGI42YNY4mvZNF1gInG88BoFygrtcmxd6eJbCDkyX?=
 =?us-ascii?Q?23+Bj3yGa1qsJiaOpZov3fj3jY6JPhrqkSMQQwGHNZUMydEsN/0nSjD/uflt?=
 =?us-ascii?Q?TKO1SwnbPbH5LjmIzH+V60GTAhUHKIz4I2pjnpklpMbBdyNkWiR0zPY/rGLZ?=
 =?us-ascii?Q?eyQP3eK0aenF7QF0iKaCLjZzgNEtHN6GjHE6FzB9hdtYbW1plDYWGAYBtNh3?=
 =?us-ascii?Q?dh2y3FzEaxgs0w/f8mB1iHyZAoPzmXRLGf2S/jdUSg2oNddr4EVabwGHq0AG?=
 =?us-ascii?Q?a63+bG/dDbzgTEyyLLtG0z76KVSXbLcbOXKXiq4Iod+S4DWBLshyEtEdehfc?=
 =?us-ascii?Q?GZfQ9+0qqwNszngvCFm6/vmEZINWGMYvKBjqKrXLnnl3j81dTH0p02eyyLGE?=
 =?us-ascii?Q?DY74net0EKZdKKyB/rvWfwaqMdiN+JfOoE/q9Tdu386/wKzNuDWvlbzBFxF+?=
 =?us-ascii?Q?VRpGOHvJnlUrHIJXAjTsq4IT6gNMtSEpEVR4oXIE8+N1KPQQE5rDEZ2iSIt4?=
 =?us-ascii?Q?0R4HbShqL77yLU1yPQmUPtTtWOuC/sWykspGWqCIPYkLk6wgDX/GKkPIzYFH?=
 =?us-ascii?Q?6CtJZ91ITFYCr60g/4FouKSsMtkLxsvqRoS7sRtvdgiLw3MtpTshwIP+++X8?=
 =?us-ascii?Q?EtZOjVfP27sJM+HJ/b+7Z5b39iKK0qZpkqPBh1EpzslULGU5EECTIT06P6V1?=
 =?us-ascii?Q?O4Q1q+Py5zjMLL6IeUDor55LOwo4L6icA8vrx/E8sb8Bh0KESYP+/ZOzLYkR?=
 =?us-ascii?Q?YWqw+UMq3oniY7ryVafSbiwAX8UudPm0GglqKLn4JpRwNjwEgHXc3tZoD52E?=
 =?us-ascii?Q?xR5JhStCS6ywVCJul6NcO2faWZVW0eNyfw2L1tXERtlDfk7ayrG6gjDM39bU?=
 =?us-ascii?Q?0DOMfhhHM1shURtMs0P/PWgBNJCCCObZGbdfhmgLVuqmEiaVS8F8+3M4mlya?=
 =?us-ascii?Q?PI5zvl2UPT/t6tTeDkWQObBMJqB44NNF0mX8ozXuikP97pGm/or9TRyt135V?=
 =?us-ascii?Q?q46Mf3gLYXS6xMQhJJMokBPfDh9ZCRUY8WKbKwaJbfK6voOCbNAusUqzsNfw?=
 =?us-ascii?Q?MXo4na4hiksaKGbipx3hTrsevcuDUDKeHLxACdj7sM7WxcWP/B1RrwDDxf8r?=
 =?us-ascii?Q?2Xuz8a+enPSjkUty3VxxKeLCz9bdOi9NtURFw2o56V3NKN+gzFRVFeboejUk?=
 =?us-ascii?Q?WE4lh2+L8HrqYrMa5ZCFT7Un+u20V2w23iswKUS3q3RVRtlgdHJfHpB5konE?=
 =?us-ascii?Q?FqhtVhp6QhtMMPZ4mcsXWY94ILCGkyDYPa6qaSyUaYEwL936Ld1nZ9ZpvJpv?=
 =?us-ascii?Q?6LA/ifb6NW1LMYBBSzBAvsOhYawrJWzAUJAg+wXt03zXUgRz4sjpvA4bf3tA?=
 =?us-ascii?Q?6oklgXfp8tL49+Dj7eloTw5weJ9u97J5XXqMrGBDBSOqP+tjAWBg9jEDRE2N?=
 =?us-ascii?Q?i7Kz/nphxIhY7vsf+5pHs3FmMreWqWBGTZRU1RzAzPf4ZtsjzmeNDfYpoxBX?=
 =?us-ascii?Q?PhIR7zj8tDEe8z7W04Aka0ZW4mS5Ms4z2fMwtcOS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5853781-93d9-4ffb-7017-08ddacd13e9e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:28:06.5970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FStaesV38OimKDe5KtKKXk37PBwbdblLgAjfqqE4FE193vSZh7oxtTj+7DkIOSa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060

On Fri, Jun 13, 2025 at 11:35:17PM -0700, Nicolin Chen wrote:
> It's more accurate to report EOPNOTSUPP when an ioctl failed due to driver
> bug, since there is nothing wrong with the user space side.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/device.c       | 2 +-
>  drivers/iommu/iommufd/hw_pagetable.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
