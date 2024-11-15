Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E229218E047;
	Fri, 15 Nov 2024 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731688352; cv=fail; b=OrBscisrJU62nq3/jtI+oSGFrqtvTS2OwEbQRssv7ZwTxjJ8GGQieU4LYG2QIYiXKfkBLE6/j0qrqlsS1TwobRSE6N/vifli4xuqry11Y6Z6tmf0KLkc8G5BkfLduqn4odIBVi80AYNBcRfMdii4Re9zXtN0v+PQWqiTuTGxv8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731688352; c=relaxed/simple;
	bh=tOqKq6p4PXTXPbHiAcdR3Qm2+JSbkJ1LmT6+aPNzulM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ofj/NGVd17/B3TMfEHnCT0gpBqJdEKcQgghMoQkgBQhMLTeg8Z7EkOyTO8OlVwASe9qDM/Ii66OJjYZcDld/hwGy4GcG8P7uUAbhYxOOqaiUsBvBgOPc6ieDCGo+ZskNH7uBACmBCx6QB83Ow4xISysr0xz8NKj09NkmwkxRqPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ov8f+Tc/; arc=fail smtp.client-ip=40.107.95.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ov8f+Tc/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y0DJkUbMfjiZBI5U8pfbn+9u/SPnP8gLY8rm5CVWXcZoKNgcdilDNe25DYMWLwXSIl2km/7/NtV9phZaiCLYOUlIbt1L1TJJseanlzmHqsM8lvVAeZ+iXXPMoyv260DceHvrM+DNWbFJvz+ZZEjThd451lauit1v2ihaSgnthGYFYIbkis3T4XiO2GQsnC1SZLgMrJPMuVTUNjRHkt9rBIQJ6/9Vrqg+phdyTG3NmdB+MDBN7WS5UX56Lrojgn2OcYrU3JVQVmV36XTyPn8YNFWuOiVT1ntL4pVBZ5dnbm2XaTiwZMeQbZdOnR5SJ5wywxb8y+rfIPIkgDobRDO1iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HacAFD1+YITzVfRKypbihtl8ZEl3EkcsQ5+3xSLATCc=;
 b=ZP+NXpypPHlnvGgzquz1lUxqSIuQ4rvPwDV7vKTTSXlwTCOlc33bdwwOyoZurrSAF4GAsXHohnY7QSZ68XdpyIENPX3IOLFLIZLCiMkzSg6aivJfHOzyq779ZYt1B7erK1x9CbxDuWOiallgyE0EZNn7z9LBM4FNYq9SDQPxE4eOjXFgFJxSKkkzVDTowFQmxKrv0mNGuw1xKO9NDP9ppa/1VIbws341y1q6EmXKQYGRaJ56XaFPqrKONVIQGLkK3o5xVU1CKUHZoLENlJowFWAbY7IU46cZ57Z8Z0pt85JHlZ3K7piHXtb02uPmFXrSSTrFaxbvXZat7wb61gIvcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HacAFD1+YITzVfRKypbihtl8ZEl3EkcsQ5+3xSLATCc=;
 b=ov8f+Tc/S+Q7mdEIjK2fFBwVnPx+2vC2Cuw4uExACDRQBAQOqEB+ZRAojY2seQH/9/9xJKD1EW2ZlLbhQG5ZL/XyymQT9unVyPZvxp/w88EoejDBrA4CjRODhDD47k9Omn935hdm3SxURqXJNcTFA58kB5y7a8tASdDlZx1vNTOzI3VLyljEnrwcSSQOClTiP5EZ5zzGLUElyo8vptGcYdFESvSe2knAIFlLmWdai/PQAbMjwooanmnrHkqGDS0VWUE9W5JTOiPIzagRk56kaBpEBtVsmnQoWqOskaG6SnfAKOlyB305IFBq0TcqF6l5/55yjWZh5YwyD4PnlSVejA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by PH7PR12MB6657.namprd12.prod.outlook.com (2603:10b6:510:1fe::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 16:32:26 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%6]) with mapi id 15.20.8158.019; Fri, 15 Nov 2024
 16:32:26 +0000
Date: Fri, 15 Nov 2024 12:32:24 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] iommu/arm-smmu-v3: Improve uAPI comment for
 IOMMU_HW_INFO_TYPE_ARM_SMMUV3
Message-ID: <20241115163224.GZ35230@nvidia.com>
References: <0-v1-191e5e24cec3+3b0-iommufd_smmuv3_hwinf_jgg@nvidia.com>
 <BN9PR11MB527626CD708AAAC3473F7BF98C242@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527626CD708AAAC3473F7BF98C242@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0348.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::23) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH7PR12MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dda5363-4dac-415a-acf2-08dd059316e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zOzDVQ8k4N1VKIUPt+FKR8f0wWdhA3bvg1lRTnn8j/iENuF0rL/+uIFvKKjL?=
 =?us-ascii?Q?XL5/9R3G9yQRFQKJslniqOpZ4Ez2cnOoGvbTlZITZV04dCb9UiQYq29N3Axq?=
 =?us-ascii?Q?pfs3Lj4nQsmC+FL309/XQ8rbYDKlHXqVUnm/uE4MONf6TAPQuDJzuifDdkiF?=
 =?us-ascii?Q?wURaIBovTPBQobEasPBa2s109vfNVYV3l5w8yWnLRtjQIm8j3YMM1dEs+WqG?=
 =?us-ascii?Q?2lJY1LdcUBev5Xnrh6gNO8Sf81pja/V/aupBN1KJb2PZJkInDRyyZHZsIAe5?=
 =?us-ascii?Q?eUdhIgaeRlbg90GHm/Uaoe786iujllAm176qwsvMaUuw++tsurpHH+1trEuk?=
 =?us-ascii?Q?1ZwirKoLZjXmasgUMRJOggXgZKGmrq9EVIqpcP9hbqNsZLdQdCnyvjACmwPn?=
 =?us-ascii?Q?CWJpARZkJMJsKIx5Vkh59MW2jZPd+pCR3Oe4XeobFqQekoKf+bZYD1X24Fel?=
 =?us-ascii?Q?PWEsBiCx3xIsSfJhJXme2IXBZnQui1w2CXH3n8WM5PlhKKjRSP7bV3HWCQVq?=
 =?us-ascii?Q?ubC/P7mRl/hkKHP/zFRYuS+GW404f3FbZC4qo8U+ww4Lc9PsLP7r8lmoLl+/?=
 =?us-ascii?Q?Qth1TeCqHNb7pqSge5Y1rzP0SzBDyXrQjXMV3Zg5aqf5AroPfQ+L8xKoeNCI?=
 =?us-ascii?Q?4QkWVrFmO8IxgnoI39bLdoxq/p72EEzjiOS9eKd59/xW9KpvykHVleLHfkfb?=
 =?us-ascii?Q?g7Hch7+al0HPw9NOeGX5ubu/C5bxBo/2hasA0Ckqv/Kc7i4gHhlQEST9ssW9?=
 =?us-ascii?Q?XJmMvo1C+R4v7Zo9xYAsDmnPu4k3UKE/ZS0XfflqbNZGlvmCxzcTH+apeBtr?=
 =?us-ascii?Q?KqVVnPEZZ51MibzPbsNJlunTjNlho09FpZx9Py/ZPfG2Zxs1cpIaNkYpaWUM?=
 =?us-ascii?Q?PK7UQYnHljm1PjslA0JGTQ0mtzzKoJ0sSgZHcaW+L8SvTladsR/2tNZF5I33?=
 =?us-ascii?Q?8YKJyZlTNyNT1Q7hrjOC9EBiOh3qJ+4/rTyR+qY7tiT/RdKuUsEN+vLXcjIQ?=
 =?us-ascii?Q?XNynWH6Mz8eNO5sOj3z+Go7tqqVWL/wgmBmlFF9ZFj9ZCXfhlCW434mveUVT?=
 =?us-ascii?Q?hn2qpU7eXJ8+g+gjmsnwqDH5iAZT1DwDsYUnup3iZmYM+xWvwVTt2Z5k14D3?=
 =?us-ascii?Q?13r//EeLxHTC2Egca9IyYc9CgJyL9Q3mFdlAne7jDr7JP1Eh1ggCElfLf+GP?=
 =?us-ascii?Q?US6gB8Ub8FicqJ5NUorcWWkXe260cnE7Bg30X6CQPKQFk0YNXM8nd5aQaPrG?=
 =?us-ascii?Q?D1xgsXX/7RsQ4nFs6ZMkslTqqKc+SNk+4SdzB5PEj0DOrpvfMtOvgqRfzIqX?=
 =?us-ascii?Q?sF/n220bYUw8ElBSAR3kwzS7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iMWqQvFfhBthKawmc0+r5OXIRZUF2UDlJW7D6hUnCddLC97cdhIrxsHFhS3B?=
 =?us-ascii?Q?OCUqi44/iJyii0D9C5OKVBOwjwYUubgAWCxriNQQelvkChsdvStw3C7YMgFw?=
 =?us-ascii?Q?5KzcwCMkJJOiNJcRP69mM0mF6AbEsx1r9UzpopgcIJeHwwJzk9PXFaIJSt2y?=
 =?us-ascii?Q?8+gcg70NqhkwmRlT2kIwqnmyOlxHsd2XL3JU2mOYi8acS2MkUOUx9BUc6e+s?=
 =?us-ascii?Q?FK4MIihYj4xLPZdcHxwXm6K1MuKrUeBPtSYkFs8VV/KYhXXd3GDq8U5Gu2v+?=
 =?us-ascii?Q?y93V/x5ygjgu5E+pmrisGy7KQPLkYtBC6MKfy8Er6kZdokZddbm5LFU/3HkY?=
 =?us-ascii?Q?jBmb9NcWtl9TxH2cYDNVDHkL5WqC8dI6lkiUSIgxjNrwhNMONai7XRhWZ7XZ?=
 =?us-ascii?Q?FsoVJgqoC8k8AlItCdZNt08DmIrb4WP64XP5RkFvyoiOe7G8Yp0Fmv5aAZB3?=
 =?us-ascii?Q?MfP6txUkiIzM2XZWN7lBVxCVlzvdabMUwr+1358zdwfjcEK79zOY2uUsXbAx?=
 =?us-ascii?Q?KoDyGQpAtxAnpFskmr3zHz8g4Y2y/i5JxgrlCPFuhIFd8/upePUXgZhleC3Y?=
 =?us-ascii?Q?qOD8WpX12EwZLS7qnXltiFm81rWWK1AQXSEZZrCIn1MGqYfG5MHlKRKOahX+?=
 =?us-ascii?Q?VdVvekFPjwsxcy3dDp/Yj8PvGwXG2JUn5fYDIG5oVKNhMviFqeQLPJXTbLGr?=
 =?us-ascii?Q?bwzcg6yVarq6dB+w5zdCop4T7JNeWuwH2jne0Q+mpSt7CfnSu6R68vhj41ss?=
 =?us-ascii?Q?MVoet1VQsvRHGhs0Sq4ztpirCdxFosvgCv8WCsOUJhwprNv9KZzAcvhWP186?=
 =?us-ascii?Q?xveJn7IkebDJG+dGD1QodRkasqXaeTE0R0nPOEHOru4Ft6IkHGCpzKnUzUoc?=
 =?us-ascii?Q?N5W/rEx04ZGJSH7e9cieWKLww+RtqnQmdAR5FN9s2hScc1kmZJe56akkj1Nz?=
 =?us-ascii?Q?pQR3bloyaA7c8a47bSKvD/JU35C7OR21Rdugz9rQOz+n/0jQKTpgghUyQ8Cw?=
 =?us-ascii?Q?EC75o1NKUJgFfjdcGLRzFpVUF4UlQ+8WNyq8YDB6hmxeGkARtG4Pwc72zG2u?=
 =?us-ascii?Q?mRm8jFCCqipeaAAMWN1FYyGwcxf5+Ky32PEuoqjI3G5VRjOysmRD5XGSlpLS?=
 =?us-ascii?Q?1163mPjiNePbPAJu2fyEPv7lAaGjp5/0/8xLzCu4OTWca2H80FgYgOh1l5/o?=
 =?us-ascii?Q?1T5PISc1IFaCKICbrfwRI7CihAuFmDDyMRoNwGHohoFS+nbpeWmO5SK3SlYc?=
 =?us-ascii?Q?94nVbQW2cudAnUXUP3JY36q3tttYstXpHIBqX26EjIoMJ5wQCz2S5YBhSxkF?=
 =?us-ascii?Q?jLIJZ2rZAosOq24zqiHG4FGnMy9NV43c1wC5Wpao/E8rH7k3xkCK64W8cY4R?=
 =?us-ascii?Q?OYi+f3qsJoT2fBUQ5sveeRpG+HUaLRj5NKAfobT6i1vlRv+3GfdFGW7xtYKJ?=
 =?us-ascii?Q?Hn6HeDfWXUe16DI/M01cGYjiqStmAIw1ay9wDc3DGm7CLPdfh8fgCVjNMZs6?=
 =?us-ascii?Q?mCNi2OjiE0T3r23beLzxLvD6muWGA0PPqGyV6fMgQoO1AP87C88LQDhywEnr?=
 =?us-ascii?Q?B3u0yA9tRmyxocMfpQE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dda5363-4dac-415a-acf2-08dd059316e3
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 16:32:26.0486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlRdahRhNSPQM+s1gy+YUx04V36Sc5FycEw8y91FDzYyqnLmxrZ4/Bs54QQlCP6n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6657

On Fri, Nov 15, 2024 at 08:27:12AM +0000, Tian, Kevin wrote:
> > - * a VMM is using this information to construct emulated copies of these
> > - * registers it should only forward bits that it knows it can support.
> > + * idr[0]: ST_LEVEL, TERM_MODEL, STALL_MODEL, TTENDIAN , CD2L,
> > ASID16, TTF
> > + * idr[1]: SIDSIZE, SSIDSIZE
> > + * idr[3]: BBML, RIL
> > + * idr[5]: VAX, GRAN64K, GRAN16K, GRAN4K
> >   *
> > - * In future, presence of required kernel support will be indicated in flags.
> 
> probably add a umbrella sentence to mark out following features not
> reported via IDRs

 *
 * The following bits in the vIDR should be obtained from other sources:
 * - S1P should be assumed to be true if a NESTED HWPT can be created

> 
> > + * - S1P should be assumed to be true if a NESTED HWPT can be created
> > + * - VFIO/iommufd only support platforms with COHACC, it should be
> > assumed to be
> > + *   true.
> > + * - ATS is a per-device property. If the VMM describes any devices as ATS
> > + *   capable in ACPI/DT it should set the corresponding idr.
> > + *
> > + * This list may expand in future (eg E0PD, AIE, PBHA, D128, DS etc). It is
> > + * important that VMMs do not read bits outside the list to allow for
> > + * compatibility with future kernels. Several features in the SMMUv3
> > + * architecture are not currently supported by the kernel for nesting: HTTU,
> > + * BTM, MPAM and others.
> 
> Not sure why HTTU etc. are remarked separately instead of appending to
> the list of E0PD etc. 

We know HTTU requires a kernel change, E0PD I think won't.

> there is a reason for kernel not reporting a certain feature now, no
> matter it's because the kernel hasn't supported it or supported it
> but just doesn't want to report. Knowing the difference doesn't help
> the business in VMM...

Right, it doesn't help the VMM, this is more guidance for future
people that might want to enable these things.

Thanks,
Jason
