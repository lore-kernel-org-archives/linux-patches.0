Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E60841D652
	for <patches@lists.linux.dev>; Tue, 22 Sep 2026 20:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109236; cv=fail; b=fmNA9+aoRk/fa/eV8K1Czg4YzlxRAldRPSiq5aDYpPfJPsPmjAU7/m8Dkl6LVxa4kpKrYlqPW1FMzRIH1KiC84rYk/1lezrsw8lsyvgCRf66ZT0UObC/2+bUapUIqBTjlI4Jt5kqjaOdbmYnOsPlbJdHgUrK5QEE0xVj7laaBdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109236; c=relaxed/simple;
	bh=c8PpByDXF7BHrisg7ANIetMu74f+xElt7cpXZR3Q6dA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AvoB+8huX1q+Ngz34Ahgmmk++st+ps3sZN/tC+ZN6Ye1GUaHmNGqSJ7706h0khvc4+G9djBdAE8LffH49Ee3w1t4IIa7876dHSeqi3vuLiiSxotC/dCP6jxS9d4C9M/b/Ygr4Lnf8KAMh5JduncJXCiu0sRr/NyY2Y5CipIazQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2lHTvuJ; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2lHTvuJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790109228; x=1821645228;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c8PpByDXF7BHrisg7ANIetMu74f+xElt7cpXZR3Q6dA=;
  b=j2lHTvuJERTPKtYbxCVu4Z8+SxeIZHFZT+2INaDxdG6ZLZJ7KazBE8Dq
   Oc2TgGH9pHV3jhk+KXYBB2oRAG7WxzC2lLafR23t6pcV8D4VqqGGxXKQd
   Ka/zDhDEn6DVsa3pe6o5RSSTbeBHN5ZfUuFpvJ/BRISM5oQuw1Asu6bzV
   TuYJ0CDOov/wyFads8svieK2NiAm8V7MdO7YO4EWGFiqwMYoiqlejTCYi
   LwL0+7kyziB88/d7OCaAWvgndblQm6D5iDkLeYvsev+KpanF3cMRPmsCR
   UUPETyDoI6weDU0ArZ/YcJyQBX6eVFALyyqisZ4lrTu61gjS1MJUMdlmo
   Q==;
X-CSE-ConnectionGUID: O+di3lSLQbiXUoGWidxesg==
X-CSE-MsgGUID: 4nfhPub6Rha71GhUhmAxfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="94579700"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="94579700"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 13:33:38 -0700
X-CSE-ConnectionGUID: 5LB7zDKVSHi9k0/5xbLCKw==
X-CSE-MsgGUID: p2ucUGOYToCZYkLyNaSp/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="4579764"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 13:33:38 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 13:33:38 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 22 Sep 2026 13:33:38 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.39) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 13:33:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g9C033nLJadO7A37PqvvP9efLgAeNXbn4Cs+9HSNRm78Cns/tqEcYP4AVlEOvTT+s662LGO8JEFqHtd3ZAUGbhvPO7Aj8EIwanFd0DXiT+tEppBmdi0sCxdZ5Z0JVbdr4VbJfcrGHcWbyASaMnlE61uAhc4RDCuZvy3J9Mx4oqf0DzCUWb/ln8bvD3XG3DfkcIcqOq9GRlb2sncfKdGUMUu+Je6NbgyXADPV7s+4VYjZgCBOE/LEHw+kEgSdUdMTswUP2hS8A9lstpg5jJqo2jZq+c7K2u/oM7kwNjMOIGHXFVvm0ZzC0fM+hfXvHpey1O3pil5TvkTl2gRtRVJe/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1tin5FDAijXu4LiOpcYZf1CHI6z3uZbmBJgb5SsA0IU=;
 b=BnotSp3lF/gg8Q6hlVDWVwHBperd4pscgP6VfzaU0SSRjHcV1V60V8qRCnk58oW3MSLPohbjMf3dzu1c8ACQtshJ5NnB9AEEXMBD0DevyhWKCQJLH9VACpvHtgZ40XyBaxohSUFQRF+TBY4e9664OLaSLZxT181+5QFnnafnGuQ/okNXveosFWNHCezor+CllRh5WbrJ4DKX9Ehnyoa5XScAscPCpdzjkOQjG5chL+1knXXx4tJ4V3FC6MY8WP4Lg0paIbI6zdLyk8AdfnaJbgvfHip2BEMdHPxvIvIm0eSZelpg6jPiGnkBDzQagSPC7UftKoL0bfZuoonGRmiUGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7337.namprd11.prod.outlook.com (2603:10b6:930:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 20:33:33 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 20:33:32 +0000
Date: Tue, 22 Sep 2026 13:33:30 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E
 Box <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 09/25] fs/resctrl: Remove redundant calls to
 resctrl_{alloc,mon}_capable()
Message-ID: <arLmGkoLVFixPa3V@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-10-tony.luck@intel.com>
 <7c80c9c1-051c-4ba7-bc4a-d4fce7b263e4@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7c80c9c1-051c-4ba7-bc4a-d4fce7b263e4@amd.com>
X-ClientProxiedBy: SJ0PR03CA0211.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: f09d0084-914a-4a96-1855-08df18e8c49d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|56012099006|11063799006|22082099003|18002099003|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info: uRszpxMuZkXcxUKUe2G3cE+ecCwA06i4pGJ1QL8B4214w2iYYP6mqUjWuUvkgLL0v8rKAYNijXYbD+EynLVCXf3m1G3ZIjJF47qvu9gWUqzDtO7G1FfkmuqZGSJkx2+/+XTN4tnIfn06BdLoyx7jFDB/BgbN8i6gOCN3cMfsSo1ikbBDCpPDvmGDc+7vrCKc9taCWpY4PreKG67IJe/yb+JQH3DVk2k6wplgRR/AXhrooi6RCpFyKReFCeECo+yzoqCiPY8qw7yxIVZOzT/aw2AXoGnSzJ/s3C8IHV7jSz8UebhNCYoXL008awUdilmeFxetUB8rI8Mxc3/5LODDb3lDUhFWK/+GixVQw8awt/9Qm+ci7eH4pndiJMrwC0ZLYFD0yYRfuw0WGwFyQ6MAN7mpvmWTfd1hb64AHSAZ/we/pKUMEK756V7RgcYzOusAi6fGntRDl/Xy/CDgZCwWe6Zk34v8wN/i8hpat6akB5afPiykszxD7R1DhdP8+mmWfR7f+jIslJvxUiWzuM5cEZFxr1UySsPWNHfL0kyT+kwd5KBWbWUh9dO9tEfk6TVUzmYRe/M207V80BcdVfQCf1KIuk0aKh4zfz7ZF8G/gqVNcoiOHDNCEvy2u2Jy/KSnI1lgMcZbN175843PJyfCFOVrTD2VPUu4+p4wdAEJNeo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xMvkEOkVVjATgJf5XzQOk6LL5tDWF7HjU0TEfdeNs51Ow2lUX4V3YPtyyIfn?=
 =?us-ascii?Q?sOSc+j11+WN4WS0O8joXBwWgCKw2kZfS9rGjuJrDNx+6HCl3AWa8KI9lKTVl?=
 =?us-ascii?Q?cVHstOH1dvNu5BbTmLMNUHwwIhihzZxthg91hd+jnIs7jB6JLTfQ70luskRD?=
 =?us-ascii?Q?6NMO4QlUYBk+je9w+VlCj6VDXRJrCcdofPTJNrUQ204vxmtPvDD+Gq7r58Qo?=
 =?us-ascii?Q?joKEWT+JK615xPKHFxDydCiAHpCbH5JSkeG8LRrl8irJyuYiH/RXjS8l1iHK?=
 =?us-ascii?Q?aL+UUGqtBPN9DIA9MLvvP6DRitdu5SlOVNSWCkr5hwqgAYIUOKUGF6Mnb2R4?=
 =?us-ascii?Q?vz2KoYd0/PN1dypPDjouF31O6AN7AiLjDGcmdITg5xVnH+Qu6ptBQCKrIN53?=
 =?us-ascii?Q?UyGi16U/wFhOgVGLntt9AfJbZrFwPPleOuWGXsz08Lo+TYpAa/6i1kg7W19I?=
 =?us-ascii?Q?GLREpRl2U9E91eUTj70DFzaDVpahLRfAc0TEkUZByhhxXB3BDbb24IVpUvis?=
 =?us-ascii?Q?4stJO5kGzDXD6eFKkbq88oUM1lF9EgLz4g3Nf5U3FpzWOu199FRoUw8KoSwM?=
 =?us-ascii?Q?oiLK+szHMAxJIIRPNISsQIFi3zNaDH8+12Bv6ap9vG2tGOUNTgQvcPECi+/b?=
 =?us-ascii?Q?wG6xhNS5mw+mRjntH0hiRfeGqvOpyIW0haQJ9FuvgWN9lM39qVGyhlP4iIIN?=
 =?us-ascii?Q?xvbyHOKCyGaXOnFTpOJxYP9jV+IBtRsKsyMT6UXEy+mtb8HUomBPGSmADIPV?=
 =?us-ascii?Q?7eFvfTlAq12x43xxzDZ4ZSp4Z3NFAytjWlwYoSwLH4MpmQ1IKyQDIXLFe/6H?=
 =?us-ascii?Q?v3Yf08UO+wF9p4qgbMY0AcPOhbwzV8bSzEhATD4FsZyLhVpGIRehU6EouvPh?=
 =?us-ascii?Q?qKc/TQFn0Ez/bjJzwTos/wzY114UmFfC9XRm4DpJ7rWaUtrXKSXEFTrARXwP?=
 =?us-ascii?Q?SNs2qbDwtuIt32fN30Pn7LOrrg7VrqWUmlmZFZrBLiN+QS7xDbhXBMiKWlVu?=
 =?us-ascii?Q?MN/VgkFtiwd41QIFGcwbPNlH9sG1/xFsNUP/aNZa96cSwiLn7Nfol52/JmOo?=
 =?us-ascii?Q?r6PmmOxDABbrwysXuUDqdnZRRS7p6OD0dlLFNBudcxC5ui3mpr5XQBlgARxI?=
 =?us-ascii?Q?HgrJXf5NgqvOGjy8sApLBvGdBgures3V6/tVlEQ+e/kJVa6MD7HZ/gszOeld?=
 =?us-ascii?Q?v43Wid3vxj4OjMK4uO0GR5v2UQ19S1NzkWgQxJKy+uGDHdOZKP4aGGe3C7MF?=
 =?us-ascii?Q?8XJwtvj3AnW/KBzv084ZFEzGYQ7T5XcBjkQ8/kYlRgU5CvG22Zx2froCbyNQ?=
 =?us-ascii?Q?tpuxsfy2RMH7StSekGbLHrSbEXRZ+hRMxKqEGC20mlFQteY3L6IKY9jGJici?=
 =?us-ascii?Q?XyHZxTTVJSUrX/y8exaqd/Do8rRg7fCci4MFQ4i/58m8Ia4fdncmsh2/E8ma?=
 =?us-ascii?Q?4uJ6f4cHQ8pJVynNpzv5shIq2akQUOH3Zb5DtLFQtHYcWimw5IRIoUkFpj0X?=
 =?us-ascii?Q?1wAZm/uvo9a9aiztXQfxcBMHqcG+fxqrxBo5Gm2Iq2gOe+ntChQBcRA6ICH4?=
 =?us-ascii?Q?OjT4G4cQtfSb8WyRVGW7ipLWjiLsUqiCw3oSKI7qwkXZ6t16YB3pOC/lEmR0?=
 =?us-ascii?Q?+A8YclwFIOkSrRQsR7kqbI4poBGwCWsilqbv3d3/I8dWb9MzjhIZeKcdYimS?=
 =?us-ascii?Q?HTqJmkVQ1JNH3sPl8bI6Avs4EDACOIbd5Yq8iFxtjBhQouXdbBTP1Zlny/Ou?=
 =?us-ascii?Q?VatKGFz2Hw=3D=3D?=
X-Exchange-RoutingPolicyChecked: 4gLtoEmJUXaZUR0SYVfJ1xp3sikjuZu8+YWLtKKbVOBKkPdpNJRh5QRvmfNtg8tBXopbtNo6gOPySFZV3YD/2VYnK/9hXe61mXH9ReBejT4nYC0nx5PM47GGK9mOvFGFOrClfmB53JQsvYxyJnIoWJAXnCwlBf/FiazjTL38WA08FRjfba87WmDssJhfm5YXA+pWZkfXqXrzEAcZ7qfQrpI0f/khdXDs5rYFDFsAdcloyyhC1ciI9NkP217vyvsgcD4JvTIwILq4kTdfe4XNYsS3Wsm5r9Vxmug4TLgIBj4LEleYnXFvwKrRfjyoQkkZTB75tueXKbxnOe3B+PQ4Zg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f09d0084-914a-4a96-1855-08df18e8c49d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 20:33:32.1794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qN2AKolnzu8lf3YKxbgEYSeDv27VdxjB7TqPIizbrVXGHNnuPfQAEXKRMjx1PFgVEZL76qKCNSP1dRle5qwr4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7337
X-OriginatorOrg: intel.com

On Mon, Sep 21, 2026 at 12:45:18PM -0500, Babu Moger wrote:
> Hi Tony,
> 
> On 9/16/26 18:13, Tony Luck wrote:
> > resctrl_mon_capable() indicates whether any monitoring resources
> > are enabled on the system. It does this by scanning all resources.
> > 
> > Redundant calls to resctrl_mon_capable() in hot code paths should
> > be eliminated. There are two prime examples:
> 
> two -> three ?

Yes. The is_closid_match() was a recent addition and I forgot to update
the count when adding the new case.

Thanks for catching this.
> 
> Thanks
> Babu

-Tony
> 
