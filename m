Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D193FB7C7
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783702903; cv=fail; b=AwnbChl3QmeSXfCdm6RJYXlsGDbyN0e5/vKKVFz0EpaHvoztyL/3vsNJOSkBwTLEJ/f2QLMVADQbYV4QZnRyoKHNcz6H7XwYWbOnF+9gKMIwEZGPgN7K7/HCytiDLzRaUMQFRPT09RLUOLo13QO9PI5d2Mw3BY1GnMJiiE+prXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783702903; c=relaxed/simple;
	bh=cNmhtc/DNPEtY4W/K7nTmRtyFn6kLxIrHqUecuF4XlU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A8AIT3ubZZDglJ+qqoVKbYcKWJPlr22/zLuRX/oWQFkrD+Gljm/I2WsXqFeWdJtQZc/LEMj64NNawAMjdHR5puhz+voLeojX7BLiEoTSKlIkSp6pVCAkNT3wMTbNwVdwEwdQq9JQkRz3cC1w39OEIpmdHTV2ykpHomC4O//AZjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=imcwT8tr; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="imcwT8tr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783702902; x=1815238902;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cNmhtc/DNPEtY4W/K7nTmRtyFn6kLxIrHqUecuF4XlU=;
  b=imcwT8trqxrQ4E8qqOMNOQ5wi4YQPgqvZLzllaOk8oOQ7kI0N+amMVyF
   PBDenLe3msBO/WIp+J6QSfuinNu4p5dfMwTl1sEgm67NmNA8Rdr5ZMFtq
   sMFrLbBr2H32aTcfEz192T3iD2wr7ixK98iusn/5r9rsszLHsufME5vwF
   EKUmWZ7AuL9NUaQnbqs8mGO7P90ixhIdQAzRz97FHCrBiDaqjEgMRfez4
   qy98Qy8vWDT/ZvJIzS8+NYLsikoFEXAyBpFSnQhAVL2kEnLYokssKyRfz
   VCGjlCIcZU6rrxp5ouy7sWRxjyWdeeWNmrrMKoTcMI+0qV4jbrFzwceYP
   A==;
X-CSE-ConnectionGUID: SAXL6KehT9uXux5x7eOsjA==
X-CSE-MsgGUID: TEv+1lC/RvqjSh5PeOPADA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="95918173"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="95918173"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 10:01:41 -0700
X-CSE-ConnectionGUID: z6JJUouDSeSNdtxfFbpA2Q==
X-CSE-MsgGUID: 59uGCd5vQC+gXikQKMJVcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254435090"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 10:01:41 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 10:01:40 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 10:01:40 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 10:01:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1KBRW+ZI982naKp1HTMciRuNQt/bOBBygae7YAKe/ADYoXZCPpToNN6W90CpELeIEUtedKHn3iwDOua6oiZYfoL2pSFyRNTiZHlobbWHgdWoShqsGadutPZXyI7S0BKv6Gx5EwMOAYmBkFcHHocfmoNxb6VJJe0nZqGfN5CCpM50thvww0mhHqPJUmH6uKi8CgL3JJY59dF5+djHSG/vvmHPk3EUrEq8AErG4UPWHuAROYMplaxxpB6qT2DMcjmFi+HcF5Gb8vbBImjQ5ArKjVc+U9CqHf14V6j2gJrRWV0nRibNnpXMQN5DXrTiWQXLol4dgRqLyRCeb66Og89FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/07SRK5ZPryMQ8Y/l6DZVvfjXo/GF05I6jVtUffk3E=;
 b=LrMSXHlHN5r47MtvjwyMlkRYAx+HoQ3lvELmXHFXOvNcVd4LATzhx0tBpZhgFznBmfF2Wr1AUn0lgVHMD+rvXytBbjM3UQJKmvGekgPKtmKeRX9y2dBWAQ9uAZ0cGrW+H7vLXCnLItLNia5tr6d0bupY4YPJaqNY2IMKFWgWrc6JH7/lKLlhWZDR70H7adRM1UJPrJvkuN0nEdCcfxgHK/cbUmSWDPjG0cllBSPZTWUJxgj7giBS3QaFnPdWoWyhdPbFZEd/xN19f1Yq1O59jmkzxhUeP4k2qveGZe/b9FLU0YJsuycqabNYTCVnWbOQWtJMMGJi0e3A246iAX+YnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH3PR11MB8444.namprd11.prod.outlook.com (2603:10b6:610:1ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Fri, 10 Jul
 2026 17:01:36 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 17:01:36 +0000
Date: Fri, 10 Jul 2026 10:01:34 -0700
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
Message-ID: <alElbgUs0ntsmiKm@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-2-tony.luck@intel.com>
 <e2a74402-791f-493e-9824-a5e4aec61b87@intel.com>
 <ak_dQX9j-hmtm7W6@agluck-desk3>
 <8c627385-b6d4-469d-bf99-b1cdf606bccc@intel.com>
 <alAO2icyy4TKDH-g@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alAO2icyy4TKDH-g@agluck-desk3>
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CH3PR11MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: df94fe1e-6576-4579-3f95-08dedea4e70e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|7416014|1800799024|18002099003|22082099003|56012099006|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info: VfwMO2S4abg13lYH0FKr1YrQbS/AkZct/dPGyosIxyEgYylz3uQVkXkBTvlz7E3ScxJ4RDHd0Ow/2WwODvHmJqxnraEHmbtkuCdPQZXpwKhwQjIY54cz/E51IiMiiFWaCvgkZxVrLveR018GshWlFDKtqF5dKMYzYJCvGzIOFtMI5D8sY3Foz8lwiEo+AYJHaHypgqAb7co+B0VWfPyoNnGCHA6G3pG6DxMWIcR2ez23SSrBGJ2exqbDrHrDnD78brExIn+UhacYEIpxyTzur8ryjM83g+WAsmz9Bdt8qEzqKgEFm4AhRELwlbCSMs7jPve6xhaCAiUX2CHqvG/k5OOgJwS7cBq44eV4iUaWc94Z12aSdPKQNDhIIxjVLFK8hOOX3yWbigdqKmlU8IqQRQQpoFulGWm8TSjZ4TIs+D2Eb4mSSrRY97rUcLrMU+zj/0Yl5F4yTF9yjzpcS2+Znwnjyj9fdoOeBxa7Qsuy1ST+wSDm2Lm4DpxdRXDnbo/4x0+bwbH1EP/FSnifZsmVQvGtK/L2fvtWNvfcbVJgOSbTt2p94ZcF1rc4iG/3xHj745GXiqJiHtjQoYhCqbletI18gbT8V5f9yzVl6cAUKnq/LaNqA41/pC6sN2tZSek3TVJmfn8crh6sKUou7DIzor1ILv7An7Mlv53t3SgjO6M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6PMqD7TZ8iTcCb+cunkEhRzmlIzocQxx2d7LQqU6VqFLtf5m9rcvTcaNmFEy?=
 =?us-ascii?Q?tmMgmglDYiJiQq/t2I8ZJxM8EiZNxuL1fSTEUa2MeMsCsEc92z9g0TVUBTeh?=
 =?us-ascii?Q?likeNg/p83sCOZ+pgSkpN2WiDvmbx+skeTHiVaUxpjh/VPWWgb17rwcMekhs?=
 =?us-ascii?Q?0oXPJUkVnd9n0sFaoXsb2gL1h5zzjhB62CmREJzkBnvWg7yKAGaT7UQQA537?=
 =?us-ascii?Q?5mbtu7GU6zSJSnXtA1j/KPqR+pZLB+/17rY4YrHKPSvBE/6dmnBjVHUIhvRq?=
 =?us-ascii?Q?FBwoJ9WwsnusdO1qAJIDjHdbFzXUPmxp5hqmBcyuE1YWL5/9T0qBmcIt8PTT?=
 =?us-ascii?Q?Mr/fDfm9/f/a1rDp4UZiJMNnM00Fgv45XBdq9nQeiBJwQaDhV0DGfwoYLged?=
 =?us-ascii?Q?dNhTKGSufDE735dRiQa2IUI2c7F171DrcVjmhP83OfvJaYcvOiqiNNFAlHyI?=
 =?us-ascii?Q?D6DBOciBlU29nFKIohiCMheLgVBwyZK5icthXZzabxNaPht/ytlHf3P40EIk?=
 =?us-ascii?Q?wxg0kiv/BPl6d8oJf2mo2K4cGgkycaqqHMgAU0rKtHrJPB0iKbtm/BFoXE06?=
 =?us-ascii?Q?vgCiRBbecI/MB/vjCQK+2VZlyRbslakvYjq9PZK1Dai37uHbX+CNltQpf1+U?=
 =?us-ascii?Q?sf6+/QlP3JCmlm04RSR2wgWmwhtBto+QaT8WJ2T1sK+rvKMyvtfHkBsz0Dyq?=
 =?us-ascii?Q?Qpv+5flfIznWuoJFt67brJf+gFDj7310/7StlXr9LDe2tpsYskbKLm5Cg+kH?=
 =?us-ascii?Q?TVtKKai71liGGasby5YPOv007SL20WBuiExsSipGt/eYk2TjenlYp3Vt0htM?=
 =?us-ascii?Q?/qxO+4HCOiL2XOtISRBxUUpJZG9v2Ox8zV+6WilLBl74ZZoCV/0qOG0dBE1r?=
 =?us-ascii?Q?LHUXnMjTPYjcjkRC0BI1NWZZaQxWjk771BEABWPC16PXfqWLZZCYKcidGmvg?=
 =?us-ascii?Q?IPkXAIbhiARuGkv2EIDsF4cUfJVTj+MNyezDybDuvBJvdX+cBb5TrjxdCtsX?=
 =?us-ascii?Q?1SBdJPHnfhSHcliiqqqgCQZNDbwcMlPXlImEPfffCzIdB4Hkr2YoNfVA5erM?=
 =?us-ascii?Q?4+I8tzI8e0Gz6zkxoldi1hSQ8PApnnFmPKZvFtAOkTIFedrFu/CrySIVnTQB?=
 =?us-ascii?Q?MFlJZVUZjfukBkAd22/QN2E7JrIf/+STqApYLw8j4OIXUKUEq8cI0b4EsjmF?=
 =?us-ascii?Q?7oiFNBW71ycSha3qqum1noqWep2kkLIL23NOVTCsU21Q+9GqJCoFk1WwA76e?=
 =?us-ascii?Q?c5iwucoIy3SJZEz1m8qKM4XNyAyRDjBFjGMCWKhYIcRaC3uiOEr1T4HQr3h9?=
 =?us-ascii?Q?Qs20u5aOupr3vSDUbIK5DaNCLBrwVyTMKdgRoNuc1HB5x0kub+GIXj7p3xTZ?=
 =?us-ascii?Q?tvshw+g6KfF5s7PJHoYsWsnaqzS7ju5wUqEacolhRQYaXSCissBdLyKXUoPu?=
 =?us-ascii?Q?imXitp4a6ziM+RPqehkEXLMUgF295VJSf8tmv1jlKGBI/Pge0YolcbFJU70S?=
 =?us-ascii?Q?Ik+KkRjXx0JLv4F93q04YZvyaBFjKwGSNdU70T1M1HDOnsPh5QRKHbe0oNBs?=
 =?us-ascii?Q?Pze0WsV5F3gtkX+kf/vHSEhdof5TG6opiBRWPwSwiwRQDhea5mlItQd8zVxl?=
 =?us-ascii?Q?6CO5CxHywxiPYlxtdUWlQ9JdFKI17iSVo0k5q8x98QT8mrPQCzWSrKgnUpDb?=
 =?us-ascii?Q?azBGGMy/3ufbbHy/DrjnpKxE8W2/hDssYEtolJ0wWDeDjlmBPRAiIZhWDecf?=
 =?us-ascii?Q?Za01nBaUHQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: pafNeo8+6O5RABHKc3R/TzmAQUGYOJk2xQGHNh2HRW9aVqnWOmqQ0ieBwXS/kTkUbcUkdJ9Wh6U1Eeyv1IXYa3tkpJanG/hhuyJOR7MJ8Ec2pLRuKudFM0yAyYqnF7ydwoi77pwlzWI4oTVVD37P1U54ii5t5COhbSI1Dd/t6EPDCIMeiC/4UfzotBlJvY+2qTdtoB/+NdRxONRvWNCGEqRcuXsCNOniqVVHJi98qBqML85EQ6f4yEoanl/DXcgIXFdt8hm7wruuawPGv9G/idPadHy0SkK/iCGg+I8uPIYZB3b9irfLDpYlc+asLSx/+hsocfmSjmTPdZ5vAS0jJg==
X-MS-Exchange-CrossTenant-Network-Message-Id: df94fe1e-6576-4579-3f95-08dedea4e70e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 17:01:36.7521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3OEFqgqsaW+8ND8fRFOi1ZQLo2YkF0KAFO4WsbseE/TYhm4L1zc1yrtk76rjNj0hl1m890IUXdXJw0XiZ2UPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8444
X-OriginatorOrg: intel.com

On Thu, Jul 09, 2026 at 02:12:58PM -0700, Luck, Tony wrote:
> On Thu, Jul 09, 2026 at 01:48:12PM -0700, Reinette Chatre wrote:
> > Hi Tony,
> > 
> > On 7/9/26 10:41 AM, Luck, Tony wrote:
> > > On Wed, Jul 08, 2026 at 03:45:03PM -0700, Reinette Chatre wrote:
> > >> Hi Tony,
> > >>
> > >> On 7/1/26 2:35 PM, Tony Luck wrote:
...
> > 
> > A simpler solution would be ideal. It is not clear to me that there would be
> > a page fault though. I looked around at what other drivers do and it seems that
> > readq() may return all 1s in this scenario? Consider for example, how
> > IXGBE_FAILED_READ_REG, PCI_ERROR_RESPONSE (note the comments above its definition),
> > and PCI_POSSIBLE_ERROR are used. Some drivers just straight compare against -1 like
> > the "if (readl(dev->bar + NVME_REG_CSTS) == -1)" in nvme_pci_enable().
> > There is also this related snippet in Documentation/PCI/pci.rst: "Most x86 platforms
> > will allow MMIO reads to master abort (a.k.a. "Soft Fail") and return garbage
> > (e.g. ~0)." Handling ~0 may be even simpler?
> 
> The return of all 1s happens in the case that the underlying h/w has gone,
> so the PCIe request to read the data is aborted. That's not what happens
> here. When Linux uses ioremap() to set up a virtual address to access an
> MMIO range the virtual address is allocated from the same virtual space
> that vmalloc() uses. When that range is iounmap()'d the page tables are
> invalidated. So any subsequent access gets a page fault (confirmed by my test).
> 
> But ... I ran my patch past an AI review and it pointed out the flaw.  The old
> virtual address may be reallocated by a subsequent ioremap() or vmalloc()
> call, at which point AET would begin accessing whatever memory/device was
> now mapped to the virtual address.

New scheme. Change intel_pmt_get_regions_by_feature() enumeration to
pass the physical address of the MMIO region instead of the virtual
address mapping created by intel_pmt_dev_register().

Then intel_aet.c can use ioremap() to create an independent virtual
mapping to the AET register region in MMIO space.

Then it doesn't matter if some unbind or remove operation tears down
the virtual mapping. Resctrl can keep accessing the MMIO registers.

The MMIO space is "on package", so can't be physically removed in a
hot plug operation. The PCIe device could be disabled, but that would
only result in the 0xfffffffffffffff return value when trying to read
the registers.

There's a flaw in every approach. The problem in this one is if Linux
reprograms the PCIe device BAR registers to move to a different physical
address, resctrl would be left using mappings to a stale physical
address. I don't know how to judge if this is a real problem on
production servers.
> 
> > 
> > Reinette
> 
> -Tony

-Tony
