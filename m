Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2715D39D3D0
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 20:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715108; cv=fail; b=RGO5Co3zYjq1iPFLnMEeLVAEoibYxn8ZsZnNKwSXNkqIzAeq6iUT06IZNBQiDF8WiJ+MhNUkTNVX1+0EDWele+jGnGbHQPdbVz2sJQLRplA/DoSX7l3mNkxMnnO1du0FRL/j41xekX1JpIdKnWL/ChLKztAgXK6aWsX6ip7TYYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715108; c=relaxed/simple;
	bh=ljRpMrVswNxRqvcSYORin6IOB5WtPIbL8AVFiTx2cp0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mX7xhIAHqsZXcW+aHxiRpUqXukMjhiLovQhiYQiufzmpEmSIhTbyntOmIoZhFO1eWI0lrMG+vUIEr3Rjr1gp6c80RSupiU7/OAxzyAovRt5UdKFla5gxvAPiuqTvvyzLwjwEDW88hHN8wvksaaA4KERdEoA8YeVpARBum3bnN5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SDFmduNZ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SDFmduNZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783715106; x=1815251106;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ljRpMrVswNxRqvcSYORin6IOB5WtPIbL8AVFiTx2cp0=;
  b=SDFmduNZ9ARLHhjn6B5UEXP1UJ2Yna7I4PQWjvsIJAfLUCGlb3hPPvt6
   W7rKJGGlZPVCN16Oo5pvPqgVVSf/VFy7myPJa2UVpssx2rnN8sp72JPsI
   Bc38u0ghaK+p1p5qM41kxl7VR/YCkF+P6RGWB/kt3PzsEJB3n19babJxm
   4BjBvz/zey3+biny+zE+GmLHLC6T0U6kNwjSRmNRZ1ePOPb196wHKUXdg
   tQ63EAaev2S61z2vfvFw141/qE7XVBt78sl8Oze5/WEKTglJE/gX5YTKb
   RO4Mb2tDRQgKAqyvo/7krVPxifF/I9VNBzoabrYS3Qxno6oXeAXzEuLtR
   g==;
X-CSE-ConnectionGUID: LV9F1srTTdeU562x/i9swQ==
X-CSE-MsgGUID: HHTlGDdNQ3qXY9AFws/ioA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="83538122"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="83538122"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:25:05 -0700
X-CSE-ConnectionGUID: JeUYPoADSo2TcU5mtewFQQ==
X-CSE-MsgGUID: MRXAr60IRFylBUa+vPuDvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259302460"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:25:05 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:25:04 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 13:25:04 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.62) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:25:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ev3j2IiXJKebw9pdJE9F5+YvFP3q11mtpwGNehJmYqbzja5lu7Cm5TzOEbxkZ87KXT9GETFYIFAl5Dh0x+CyVS6oDDIgEKaq0uVHTCpiy3ALOJBiHNX2DsXHPzJdP54xTcWsf5UiJ0qpT7qVXYPU30HpJLfDecLyfbDs8GBXPsY5+xkSFR6aAJr1mPhPKl/8pS8Ul2VJdJVR75LjWHFwyViDvDrw6JFSfMVi4yHmMI2V00U7QyUCkLO4B572tw6klfWdEyTvO0cZaWbQtaS0VTarVWuG1HFzdKaAEk8eUC4ZMZrGBBubQF8NXDTrNbK1O6l9ZZTduJNmGRsMDWBuUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tB8u4AiNoJ9EK8UjrDbmozxlrXshZOYo4iFhCqokXmw=;
 b=G8+1xiyu4U+VX1qjQzZowbna7w08ks471f2+1607as4lt1vP6OFi99u1YwixI5cceqYMy2eGlogoy8EM6/DxB3Y6RdAoeH6YYex6rV2EpAlV7w+ZAA8+3SPC28rKk3SxVIbdXp16VmftCC29/ZJm5t4LTAPHKpv1uiAG+OtuEZK8dOlCEVazJmMzhy6xJNILJD3Nhoj+PKrVqberFQwg8DYQ2DpD6J2x5YoVsnHQZ7fGgmUR13HnepIeuJmf8nMpbRoMVBm5NGxuPP12KCw6Lo38w/p6+rVGwEtff48UW2osJtyDJO+zl2GNDrf6ZT+qjJQztjfuoMDY8TgBTgrqTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA3PR11MB9063.namprd11.prod.outlook.com (2603:10b6:208:57d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Fri, 10 Jul
 2026 20:25:00 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 20:25:00 +0000
Date: Fri, 10 Jul 2026 13:24:58 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 01/12] platform/x86/intel/{pmt,vsec}: Prevent unbind
 via sysfs
Message-ID: <alFVGpIUl2Fh0ZLG@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-2-tony.luck@intel.com>
 <e2a74402-791f-493e-9824-a5e4aec61b87@intel.com>
 <ak_dQX9j-hmtm7W6@agluck-desk3>
 <8c627385-b6d4-469d-bf99-b1cdf606bccc@intel.com>
 <alAO2icyy4TKDH-g@agluck-desk3>
 <alElbgUs0ntsmiKm@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alElbgUs0ntsmiKm@agluck-desk3>
X-ClientProxiedBy: SJ0PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA3PR11MB9063:EE_
X-MS-Office365-Filtering-Correlation-Id: 756580b4-803b-4915-4aa8-08dedec150e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|5023799004|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: NYs+B2FzRjYQL0tehrq5yRoFiACUyTAcEKJ1hRNX3NgPy+3W/Kp5IOTEswISqAIQupWJsmU++nP+uYWz5CTh56C3/z3TnQnuaIQ/0zw1gXXEh1TuU0KtcTTvt82auxL2LAGbKeWNESSW4Zk79ryScVaXH4bJmO6BajBFD1dwAqXTP1xr7zsiFPNqPHSo8mL+MO+Wm2ewSgqI9Ng5Q5SumoQxhJctgO8dTsNfgqm+h9KHUW5HR9AxzJ21aeZ3CiHaQTmLeJv2Cl3X83SKPdo7N7mnQByF8PV6bdlTP6wxXZvx55D+15rdr5nDQKwMqudAJQOc8prHTTfPwUZV1lO7smR+VavzO8KxLBeVyZXei1sobCAiaVGetkBKgj+6Byo3CdSsMAk91J/jJg/zPwuWM5Mq4leV7MJUmgVCT+qyikOmo/6bKs7MJV2Js2Bgo3Dd54FSE/SyE7J0079M7cETIxvcplZq45K+ngWVG8c7FcUq7tkG+zJ4gBdX+Yuu6R0hqW73wyIUD5do7vSS7TuqZRbMnIQ27hT5lmAh6VXecNOjmJl4KnD/eYMXXpsdNlyFV15sacaq91n8yqdz71ITrZZlqZqbta9iHYNYB6J0/tCd/3AhMdIB6twNLBb7UUioFYqdqHhT2zxaXnggC3WnwuiBjOh8PnkYmVBCYdlpwl0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(5023799004)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6nyZHufRCFUUgLcj4d6C0WMA5rLgm3DaYmy4+ftZtxPKRtTmjWlMGERTFkKO?=
 =?us-ascii?Q?G43wvux4kj6dWcQPZoKOoX4gGUVYMlBht87QRSvZ53dZAKsXXNUizRhDMXsA?=
 =?us-ascii?Q?y8kQ2dshCjaceecAryLsCp8yO62RRKZr6+mv+7f63M/K5IKgXPXgPlS4tAnd?=
 =?us-ascii?Q?zjLNd8bgJsW8/kxpjGpj7117yxs9+Q+dy2lDH5pfR5vibsVEwZc0veg8p1lO?=
 =?us-ascii?Q?gIPtr1BwAgGJjuvkczEtzrQUxEfdD8/sp7iDKJNbWjdSdRtAE3KW2+DdBqhQ?=
 =?us-ascii?Q?AelBIV7LTXjsokcJ1QslFkVXq44pj9aU5oWxEWbHHongqsI3LM+0yqQbXZyW?=
 =?us-ascii?Q?1/8QFzgqBPfnKPMG2Rq/8UhoIUXjJTaTf2whNCY9L189C1jXJegcdEs+BwuN?=
 =?us-ascii?Q?9RcFVeekA+P22TIDjq0UgFiM+bC/vUuZtDTC0xYRADsd4MqECMm/n1SxjzZC?=
 =?us-ascii?Q?snOytFzBrDSO0LZn0mnZn7gvPefIB7XSM0WSpcq4X1cxPXUkceKVweWyxp9v?=
 =?us-ascii?Q?HA/8K5pyO2m9myQfEjby/I+F5b/13a/iVCXbhsXuOgIKhzVZV+rgTDvMBIKo?=
 =?us-ascii?Q?VYeM5AhhOuLPBxDRQJbrNT6URjZC0SUKCQtfsjNFXn/ngkZ7cTLisYW1Sqf2?=
 =?us-ascii?Q?q8ErzVvSZIb/pUWsoawi5m63htBKZYV8g4dPXhKAaJl8Kknsy0KhRDZoF1XT?=
 =?us-ascii?Q?05hIDDOq5YeSuk5iD52v3MTU12MkTRvoDcW60eUUqSLvmFhcmcff1YqBuD+j?=
 =?us-ascii?Q?RHdeqXR5PWNdQd65HSUFon2Xd2f5D4Hv5Ti332oekKTmtqGFx43zoat2p3qr?=
 =?us-ascii?Q?Ht7vB3eLK8HYjmUgsBbUwBGS/RRpezaixSQ2zWmHhvtNCU4zYTBGxaf9vp3I?=
 =?us-ascii?Q?UshtlMM7V5wGda/aevcKj61bQIVdNRmgLKA4GqqtCsiwGxZyC475+6FQAcv3?=
 =?us-ascii?Q?rOD63aswig+Vfq9fyjkbbRPHVc+uTOx5fNFPD4C0qRuA/Zsg8oTIl4kxnoUD?=
 =?us-ascii?Q?EkfiGyZeMhLmOU/2nPt/TFpF0sus1EeeEIw09h6T1ZRzv6LCGlRrpkPlk/nI?=
 =?us-ascii?Q?q9rZ2wfuHM7vApQzgYe54iq+ps4M/JT6daaZGfRbmoTY2aiCe158+dKq5Ksp?=
 =?us-ascii?Q?bcLedDg2/8qX8sZ3c7K69Qdd14aOLMS1LnnhQSovgXe8zHv4sZ3wI6JbN1Nu?=
 =?us-ascii?Q?WYfEdLex7Jqc/6lmWNBO+/Lk2voMDE7esXJOzf4KLgjAzemOpfB4gZUOxQHP?=
 =?us-ascii?Q?/pmKCfsiDMDhrXPNHqf1yW+K41tUYA90zGbjBklR6hLVoW9eIZn0hA+QkI6K?=
 =?us-ascii?Q?9eDfHoU6kCmeDegDDkeun6kBjqET8tzt89nd/YYxFyn1qgTsg8W754ubQ8vg?=
 =?us-ascii?Q?9FJ5p21H1z32pN7MFXaCqrOnkaoUwPher1UaAc1JuGxmvImSha7+cP0S3qJN?=
 =?us-ascii?Q?BK1U3RQpOKsjUQJqjqnRPzWcbmUVmYiEpsetubQwSiZ0w7lSbeDf+clf7yu4?=
 =?us-ascii?Q?iUaOw7BoJh9G1DpTazPRliWUad1CnhUjkAANk2nKka+HaiK8tYxrN1gMVy/m?=
 =?us-ascii?Q?4VnHRBJ1/7ctM4l3BI9gq1NY56HUV6blM3fqrt2+MOhe97pP4b63Jik6AqW4?=
 =?us-ascii?Q?dTMZnVPeSEDNq6N1wH32ivuDiUCmtXwz3fhkDJ3w9+K8EKmnNlQRy5WC/a0M?=
 =?us-ascii?Q?aKo9U2fw5q3HcQQw43IXg14kiWvlDaVOzOmAQ2NJ7mRSXFkwSNwXTT9tUrJZ?=
 =?us-ascii?Q?R7WNrs/4dA=3D=3D?=
X-Exchange-RoutingPolicyChecked: RrhqC8m3fsM0CL2kibL7r7vEw4XllmgONxateoY8BeAVmr6h1F8NxFjmdXMlUsH7HWyscMWCo7HRGvAT3mByrSlmRc968vWnzPJljvWRvkt1CyOIgBy1vAwdP0psZULPRlHv/acvYraHhqtpQtQQhM4p8mi599XRSHMjAwcQf5SPcvOzrP+QUzzN+PntjKKo7ZGtuo7RrmwUR6A7HS/jdRtasm+VdrUelOp8Vo43GzF5mgOynayHx69530q010qZNGvoEErR59jj+2hTo1YBimEfECw5UMSS27M9ydAmgE4yWpwCmYawgJM48+ndIhyBvYDb2ag5f2tKWsTLx0rJYQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 756580b4-803b-4915-4aa8-08dedec150e4
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 20:25:00.2887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkcVRnppq24ux9q3hqGwv5s4ltO4dEswvrlxWj7g5Brw/OeXrNaKbmMI545KYNBUW+7N/rk2mFTYgtKCEYI6Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9063
X-OriginatorOrg: intel.com

On Fri, Jul 10, 2026 at 10:01:34AM -0700, Luck, Tony wrote:
> On Thu, Jul 09, 2026 at 02:12:58PM -0700, Luck, Tony wrote:
> > On Thu, Jul 09, 2026 at 01:48:12PM -0700, Reinette Chatre wrote:
> > > Hi Tony,
> > > 
> > > On 7/9/26 10:41 AM, Luck, Tony wrote:
> > > > On Wed, Jul 08, 2026 at 03:45:03PM -0700, Reinette Chatre wrote:
> > > >> Hi Tony,
> > > >>
> > > >> On 7/1/26 2:35 PM, Tony Luck wrote:
> ...
> > > 
> > > A simpler solution would be ideal. It is not clear to me that there would be
> > > a page fault though. I looked around at what other drivers do and it seems that
> > > readq() may return all 1s in this scenario? Consider for example, how
> > > IXGBE_FAILED_READ_REG, PCI_ERROR_RESPONSE (note the comments above its definition),
> > > and PCI_POSSIBLE_ERROR are used. Some drivers just straight compare against -1 like
> > > the "if (readl(dev->bar + NVME_REG_CSTS) == -1)" in nvme_pci_enable().
> > > There is also this related snippet in Documentation/PCI/pci.rst: "Most x86 platforms
> > > will allow MMIO reads to master abort (a.k.a. "Soft Fail") and return garbage
> > > (e.g. ~0)." Handling ~0 may be even simpler?
> > 
> > The return of all 1s happens in the case that the underlying h/w has gone,
> > so the PCIe request to read the data is aborted. That's not what happens
> > here. When Linux uses ioremap() to set up a virtual address to access an
> > MMIO range the virtual address is allocated from the same virtual space
> > that vmalloc() uses. When that range is iounmap()'d the page tables are
> > invalidated. So any subsequent access gets a page fault (confirmed by my test).
> > 
> > But ... I ran my patch past an AI review and it pointed out the flaw.  The old
> > virtual address may be reallocated by a subsequent ioremap() or vmalloc()
> > call, at which point AET would begin accessing whatever memory/device was
> > now mapped to the virtual address.
> 
> New scheme. Change intel_pmt_get_regions_by_feature() enumeration to
> pass the physical address of the MMIO region instead of the virtual
> address mapping created by intel_pmt_dev_register().
> 
> Then intel_aet.c can use ioremap() to create an independent virtual
> mapping to the AET register region in MMIO space.
> 
> Then it doesn't matter if some unbind or remove operation tears down
> the virtual mapping. Resctrl can keep accessing the MMIO registers.
> 
> The MMIO space is "on package", so can't be physically removed in a
> hot plug operation. The PCIe device could be disabled, but that would
> only result in the 0xfffffffffffffff return value when trying to read
> the registers.
> 
> There's a flaw in every approach. The problem in this one is if Linux
> reprograms the PCIe device BAR registers to move to a different physical
> address, resctrl would be left using mappings to a stale physical
> address. I don't know how to judge if this is a real problem on
> production servers.

Digging back at my earlier assertion about complexity of handling
unbind from the parent driver of pmt_telemetry, some experimentation
showed that when unbind happens at that level, cleanup includes calling
pmt_telem_remove().

So I plan to add a new exported function from the AET code:

	intel_aet_pmt_notify_remove();

The pmt_telemetry driver will call this to let AET know that all the
MMIO virtual pointers are stale. When this happens reading any of the
AET event files will return -EINVAL (and the user will see "unavailable").

Initial PoC code for this seems to work. I'll clean it up and drop the
patches that set .suppress_bind_attrs = true;

> > 
> > > 
> > > Reinette
> > 
> > -Tony
> 
> -Tony

-Tony
