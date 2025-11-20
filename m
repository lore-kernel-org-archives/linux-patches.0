Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D9C2E8B81
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763667228; cv=fail; b=JjQTItDQq4HwUyeKHIcLfFeCaTrlJ2Jd0gJUNFnQHpYqndKPTMFQVU44cm6XjsgSAiyMP6uL9SahIiGvDN2C+WlrpD9oMhzp2BAVQBEScBJ7iBeNgfMc+v7WDJw9R15059pPmzn0ImbighPHRKSvSxdXHRFGGpbhNtSYfsXvU4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763667228; c=relaxed/simple;
	bh=wsr9WZyRPNG9BOQ9yla/7NLVAkCqtyx98e9NHOlOrH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gsKB49s7CmN4f47uA1SxbsjDOjORGw7BWO9okSI1mJpO7XW6c2UAgbXdpcjj0/jqvR48QVXYLt5rTsqHoJOp72PIvIs1Ce8sp0SY6S6pR0rMbH1JHGBGYbGByNGcYWmqve+zWLIZNtG8ZnHGDEGH8Za741qfjYFeYCsmUy2X50k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FQK2w/IK; arc=fail smtp.client-ip=40.93.195.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FQK2w/IK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pDryw0To+8svUHznXpM8FAwP0w89LBJs0mo8ZGY/QrAHFWfs1WDeta/HmxpudHlbW/GPaMAb9YIS/1QUjf632o0qFivy1xmLszv1AqA0HWHS/zqxVa5tXJBSxqmkYLZophXMr5X/OK7YPs0Vyo58/IM9UYeWDri15OqgqLgKlF0HfxOvEQbehfjEk4Nn6I3cKXJ4X0szEbPP/c3u+tTKdmMnVXWgDH6FNCs/hmNIIcZz2OJZXcCiwCcltMfjRJRjG+mw2+X+9qrPdokVMGV+ymJzNIKhKj5N/CrKpJcO5qNBz/1vZ9N9s75NBL0aM8aQljMorr1clfTT/CVk+a0Qhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKiiufGe7FZGjk0TaQHPi2OMB3fgz+OechjkACDRud8=;
 b=wS9HSH3gE+4KLrhPvTTaYA1iYYJDfpQ4+WQBGMcVvLgxZ710Ln++Z6CK7Zarq9Qlp6lRe/G3RjgnBMSCTgjkCt2pmxRr6j6C3i7xLGJ4+EI9BPEwjYn0yJUuBZMsk8JWILysxecnmyeSOKJTGU0UHsp3eY4nJyYTq3cvdnSy38iR4urvWhFHuTpyCYWN79+gRmyi6//LGio2iy3Wvi2GpfmmhX69Yg17HgGqZUP2vxfRJrn9QqU0V63YHFOM5t2MnMO5gJaUZ3z6fRsj5M0d8LwnogDZ2J1FA41eN19NavMXkGtfnXisGoHub8QrPyXao7PngfyzT7HCoI/oCid9sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKiiufGe7FZGjk0TaQHPi2OMB3fgz+OechjkACDRud8=;
 b=FQK2w/IKK2/sXJYT7Yi3E22j5wieXHl91KwTV9f8sY3ZW6OIW/1pBl6Qgd3ani8gk13qqktMEFFmponfxsjl33PIMl5aTG3gQ0uxIh1XubC1i0NxUgGtoovOUK8btD5m7svM3lMEaInMtyAB70c6HnXc/oiXZOfWkb3fmbxFOPA9sloUw9bQJpISxg4NSn5uWbJfSrW+yHPLl0iqjIglaXeSVKdUJCGHf4mHPrYjuQ8xJgIvuziSyzZ0i4YPWOIwtOaLBcVwRSeHO2iEDQCB1ArO7zwzWJgY1MtBUDo0DVH5Wbhwb80cdGecY0pVTouXNxUCUfQBSO15mYJSvVBLYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 19:33:39 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 19:33:39 +0000
Date: Thu, 20 Nov 2025 12:40:53 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH] powerpc/pseries/svm: Make mem_encrypt.h self contained
Message-ID: <20251120164053.GD153257@nvidia.com>
References: <0-v1-672b61acd916+1449-ppc_mem_encrypt_jgg@nvidia.com>
 <0951c9b6-4252-46e5-a260-0e42365c5018@csgroup.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0951c9b6-4252-46e5-a260-0e42365c5018@csgroup.eu>
X-ClientProxiedBy: BL1PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::26) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: e5d5cb3c-04c8-41a7-77b3-08de286bb505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?18TI5bf4y/4fbK79bOAm3YgJ7tG2u3Q49b3upk17yW1eDm9/erTXeLh1LYqx?=
 =?us-ascii?Q?C41dqMP8kYm7SOJ05l7OtUhhDOzTNmP/Q7Hw8aOk/j96G9cOzsE8u8JhHm2u?=
 =?us-ascii?Q?8RYu7xYskdAxPFLxxUU5JviUGZH/CteNMZhRJaTmKy0d11gSOyk9N4IdiYFM?=
 =?us-ascii?Q?adXRQRxVsEbMgkSRRl5nl0cwn5weHeoEnogkgKgjy5/x+3k76zQ6j3TxPdjU?=
 =?us-ascii?Q?C/lKOa2gHXdy9ZjbUTTHuQ2fqKs9AvZC85/5S21ZgTedx1UHla3XaJmIvpRC?=
 =?us-ascii?Q?uOIkMwUZ5L09PnSS25Pqqv/dbg7x6l0/br7WySoCYIY+rxKk1N1ytj6G3tbS?=
 =?us-ascii?Q?fA8nZt5XvgXcrbwqktwHA9GFZAGs0oujOl54hbO8Nbtxos1uxLG12zDsMjzK?=
 =?us-ascii?Q?TUUoNYCqTaM0c9df164vT4q1T4vOJzcmpYTM9jJIu0cklOB++iDvExj5NzSh?=
 =?us-ascii?Q?waqfk+QnCQ+ncCWURvw8yUvAD03QxdFs7D+taqOWU8zzoFSmmUmciZnxfpBT?=
 =?us-ascii?Q?JCiFvrfyC0gVimV8JFyNqL+JVts2ZyvbCDqhhkp14rvGCMzgNJEWq3bj3hkC?=
 =?us-ascii?Q?fefzGOVSPIooH7iol6v74xPTp76rmkkGd6ju6e8EIK0XwA5ksJASXqjs3qn4?=
 =?us-ascii?Q?kgSAGFLmapSvBIAk7z6JupyFG8lYiSoABenew8SxaAlVuya9EXzuvlhpQ0fg?=
 =?us-ascii?Q?hm3cjapt2xuu+KqR2JGdDKzHGXujqgl6TVcfbZ64jvrc+FpYWT6RXaJ+uAkx?=
 =?us-ascii?Q?YtdqbuGr5nknKHBN+zvN36j8C+UOHf5QexGST0VvhXPVXrI8NalpiD+dkp+/?=
 =?us-ascii?Q?VdtwEjdJrMI0wv7VWq+WGuufMwh8qEzX4Vw9K/1Zhl9+fpuea3FwI6zzWjZP?=
 =?us-ascii?Q?vQ+U/ufXWDxT2KVbQt/80LK5ogtAp0BBG7p1yalo0YNQhUYNFPZWaqXVETBO?=
 =?us-ascii?Q?WKdyM706DZkECMJNuMnZz6X5RA8S4SxBKnNL6sNuVTZKlIaJUx5R+tEhtp00?=
 =?us-ascii?Q?vRsWX1FyqqHyTD779k7kLUyUkcDmGDEhNRrJhtHcmje15J2/5vHRd9fBn2c1?=
 =?us-ascii?Q?YRzaf5rLYmgrhg5MC5zutZZhoi6VqMNgz/1PAFiCCY16L+NFzkZxMwJBUYuu?=
 =?us-ascii?Q?RRpyqqt1RuT2AVVY8797qf4IQYF+OnGpMc/Cv0xFDay0SYBo7HUK7ZEeBgYJ?=
 =?us-ascii?Q?48HNLDCI/wmlEUfsmr17y8VV/FQsTmIWzl5nf6OHY1tLCLU+vboTltU9TUgw?=
 =?us-ascii?Q?FHyJv/+OIYLddL9yBOEsGVVQqb7+fxqchivkurkRbuDp+3pFX3rznNIvg8ji?=
 =?us-ascii?Q?RhX3I0YZINfoHcm5PYrCsVoYEd66IhhwizQu7N8l9ZKp32ZB+j84ouyRK9dq?=
 =?us-ascii?Q?FL+W1O8g5UvA9FLRkz5XGn0nFaM0touMnjZumVt9ti6JWXjHR7EfUhzAATWP?=
 =?us-ascii?Q?6Z4MCzapwCT6FN2EnnO3HVkb1lt2hqQb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tzr7m+dbOG5WvnOiBIoth7vdO0HwXQHifoQv7RSQsrhFPvAy19XGtOBRMj6M?=
 =?us-ascii?Q?Uo7Aisgml2d9hLit798fWPEh7vwxci8JpY02ymm3sZOfWaspkWUaUPqfXGXy?=
 =?us-ascii?Q?bIurO7osnbUdEXFiejNSNxQKQXO7pWIwVY4uXaEU5TiITWMBlsuoHEhsaivu?=
 =?us-ascii?Q?DIKbHdYbGh/FU0KpI/wcVNwwqctJ7jJH6iXf623CtetOSUNroLL35D8y3lkZ?=
 =?us-ascii?Q?zRhgbumaqmqXqElmXmZwkZpPM+CIR1ukHSs3OpMPRdSi0Cj8JOfgW4vTRO1x?=
 =?us-ascii?Q?3pkuQKSnbKlBlA073Cd9KDL1zat4Hfa6dbqjWk/iM3Ep+j99Q1DI0QZvebRz?=
 =?us-ascii?Q?8Na7NpKCcSpB+3qk/JluNxURuCf4j5iSuWfPiE7kcsuMr6tIFMYuQghQq8dE?=
 =?us-ascii?Q?/XC6hRmTCJIF3MJwjtPWV+G/ucGpFAijgaOdvsQFYsOSVoZyOu4oYkuaqYlf?=
 =?us-ascii?Q?75xnzqyFJ6FpB+2/r1WDVRaSg4SLn/8H4hCNZ4MeerRow2FfC3rrG8c7GlJf?=
 =?us-ascii?Q?+e4+GHgIujhESTQFxP9Uj7ambG0dr5R5zcHuIAaYsNLD9RJAEpeaBD0V9Aye?=
 =?us-ascii?Q?gkW2QuYCfE5dsAPPTtgbAEikOZI5bKjjxngeiwtIOUbPMSVH/0xxGV0G/Y0c?=
 =?us-ascii?Q?fXiajGknaLB8W6zsWqPNNwVfkri2WanR19LM62Pwcm6/CNpBx3zIgpT7pb67?=
 =?us-ascii?Q?/1ctbiiRHL5GmoD3B0tBaFuE/GiUziynDIMiarB6R2kRzS+D2rReVrUJq5ey?=
 =?us-ascii?Q?CBn6cxbgz9ekx8rmg0yuecnKCGI7sSPTfB+xxl9AMMPxUi8Nx82JFgIPZoR+?=
 =?us-ascii?Q?KGjFjFFAa4Fjcc408X2u8mcPEDhQTUqr2thLP12uer991IkM2cNGAR/WPIBR?=
 =?us-ascii?Q?K5SjdDeIogzHbUL0PM8nnu56tab9xQjs7U4PQ8C3nTuktNMBsTowfqkuxFfX?=
 =?us-ascii?Q?+tsPZrsHJlEv9/486tx37MCTpa95TPY+rsvGVqNfQVm++nm81Fy0BE7esH5y?=
 =?us-ascii?Q?n3A6LVIUWX/Pf9C9XeaW9HDdG/ZkHFgK8DYF4jkgRi7eC48YCc7cAYnFXwHY?=
 =?us-ascii?Q?kKgO1MeEnbbBbT/6GCAaifQCP81sAzzMOD3evrvJdQyCL39El9pTzILy9U0i?=
 =?us-ascii?Q?FtqY6HzVKmCpgp8DfIwT5w8ScZFAcR6DWVIwJpX2+g2XRsmLOgcpw+NpWH8D?=
 =?us-ascii?Q?5lKoeyZU/eV3Echr6cxfm2csA9vddShQYRZaCtyveW76qDhD9DY+EgNWIrxx?=
 =?us-ascii?Q?d1v8j8XmxrFMhgjzyr5RvwiXH7zF+V/k9qWjm380SWfKxZY0HeJ3ZTTpbbuI?=
 =?us-ascii?Q?KjsTVS3s1YRSXoW3h3COtTJ55gJPfBjsRMsaT+f0fkwECt2Zpq0bqc2HAGzp?=
 =?us-ascii?Q?fWgX6rcfW6Tk9RZGCHwl2lNCCG9qThIbS+H+eCZfMzNsjwlu+0rCaS1qX4N6?=
 =?us-ascii?Q?cBZ+PhNyJSAGndMIX4dQKWj4O+DArupZUZz0/YlBgZjH0O259N7BuFNYRGY1?=
 =?us-ascii?Q?aYVNT+Jw8+eHAH61+55X1aLoAKVvcWyCaHaEbbMx5ynV77623+OhU6Ax1UOX?=
 =?us-ascii?Q?b0Ojed7luraWXpEx8xA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d5cb3c-04c8-41a7-77b3-08de286bb505
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 19:33:39.9132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsDxXRXQ+drbZacN446a/k1HhOpXUq4zAF/0pXKikRibB0YljiZiRv8xp4Cf7gL9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7709

On Thu, Nov 20, 2025 at 04:09:14PM +0100, Christophe Leroy wrote:
> > diff --git a/arch/powerpc/include/asm/mem_encrypt.h b/arch/powerpc/include/asm/mem_encrypt.h
> > index 2f26b8fc8d297c..e355ca46fad933 100644
> > --- a/arch/powerpc/include/asm/mem_encrypt.h
> > +++ b/arch/powerpc/include/asm/mem_encrypt.h
> > @@ -9,6 +9,9 @@
> >   #define _ASM_POWERPC_MEM_ENCRYPT_H
> >   #include <asm/svm.h>
> > +#include <linux/types.h>
> 
> Why do you need linux/types.h ? Isn't the below forward declaration enough ?

For bool:

> > +
> > +struct device;
> >   static inline bool force_dma_unencrypted(struct device *dev)
                   ^^^^^^

Jason
