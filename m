Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A42C233929
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108186; cv=fail; b=sOOOG12DNr/dH2DucTfKu0eylZWUHU5MR0d5Q5wbsRTcC3C5DUW/ltq75gLLit+JP5k+pW2SfyVK4+lObobIVb9/zhxYG7z3zLzPHrZkQ4ljI68A1ImZHOzP+DVIFJwJJJQvBCat5BcmrXi0nEyXZD1SRnAbO+4Xy50TF2PTWwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108186; c=relaxed/simple;
	bh=2rWdy9GH49oR7yyprrLX3yUhHWbqq4zFXaBVyrZo0E0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OvYnWnOzFGtQsqbHM1P8bxCeNjQHCvJyp6uBV8NdFUvbeyRbv6ZceZBvaHUtKqWl974wprZ+2b51PVofqJDNxS9m7owrwU2bC3qFEdCKsEIqIQ0KzwKknueRJwJVdQilCGiWelcXWwade89nEhjSlVXeC+gKwW8RjQv8h72ThD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BLIBHs0i; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BLIBHs0i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781108185; x=1812644185;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2rWdy9GH49oR7yyprrLX3yUhHWbqq4zFXaBVyrZo0E0=;
  b=BLIBHs0iJ2kQjbGcFcAN/dz6OUN3uYhCb+kM+GkTbEG8rtwWYrsEqkrF
   VBtfjDGA5JVU5zdLG+VWccF9oc0L0I9wFfI9Izpg4Qx2ar+8KoNEpPzhQ
   8MREBOa6NG/lYex+R6nc+Hjbjz/OAm7OYyUDV/Zd9ch9zA8q3FarITf7W
   6Ht7kYjTX3CBFSKb3g9NivvsvM7wYHT/s+ra92QGzLslQfP9MNwd6wfNS
   ZP8RV4Y4CvShUjuu8ZK4iWww4aCj5jd+4EfVYVnG4TBRNrZdE2smkcPO0
   ZlKFJHB5aXCRFYFL94gQC1guMTVyc0RacsqeEphIAp4raTErhb7hQyqKC
   A==;
X-CSE-ConnectionGUID: AF1tglgtSM2DbUKOtcHfZw==
X-CSE-MsgGUID: EJJq2zxDRdS5Hl9aXtLkCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81754026"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81754026"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:16:24 -0700
X-CSE-ConnectionGUID: 4/3/jYCKSeWtoV5pm/odaA==
X-CSE-MsgGUID: nJjQzyynRx2Nuk7UebxrjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="251300696"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:16:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:16:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 09:16:21 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:16:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cmUUzgt3egtlzbqL93finNhnT8EbB8rSR3gtb6mowC+NsQT8bYqU9dzK7LnWLrMPbBJbEHtAKfcL+RqhsDCZLP5ezY1r9QRLHc8mAkq4xMUx8FfvLd00dEZAHXNeliFH9rZjC+/OJ5WIz4eBwq3B4K1PQqPuLVRMnjZzaNxMowG40GA4R7jBaFvk5Xn9GojQfz6HJAf1vQw3FP1Pfgo/SpD895jUstlJMCfm+WxDj/L/Qzvi4dA/45zMiHkq9vzHZ1RbuXVf9iglYqavy594hgv7nviQKrYx1S8AzgF1GuLb9nu88MAJzxlRjfYhtnVus53XaW1/2YPHGHoFUMvFzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7srHxSeD8XexBvWzNmDkrKTk7+TZdVR4POdKuCA0B94=;
 b=jkotSW1gNg3Gi1FZi3fASpxhhm05Eyh8B95k2HnlpMTQarSORC+1uacJJzBhhbTkm4O+z/PAIudo0aLLC+/l8iX0uiZmAigUCv5ICVZ4a5pmoz51k53a34AjO9Khwrn+lw+UZMbrfMuzwuE5GyI3dNEms9wPdn8n5ZSN7LrbKmUG3NiQD/P1HdTaZnxFiynjuQeL80YKdQPfo5ZiGVG6FiXG7ugnkY7vIE0kwYAp4kBkbMNbwyYK8ira3oYVW4lesdwI55Ktiw6OAZymGNmEA0o1G7TRrb+tGXPqMNCldg4HrJdZ+5B4UDNiJQJpd08+fGkYZ6XcnEn0A/94fZpSWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV4PR11MB9465.namprd11.prod.outlook.com (2603:10b6:408:2da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 16:16:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 16:16:12 +0000
Date: Wed, 10 Jun 2026 09:16:11 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 12/14] fs/resctrl: Call architecture hooks for every
 mount/unmount
Message-ID: <aimNy_V00OjS-UG2@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-13-tony.luck@intel.com>
 <a22cf368-4a60-4d80-a262-cd4f724c8fbc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a22cf368-4a60-4d80-a262-cd4f724c8fbc@intel.com>
X-ClientProxiedBy: SJ0PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:334::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV4PR11MB9465:EE_
X-MS-Office365-Filtering-Correlation-Id: f336924f-7d66-40b4-ffd0-08dec70b96e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: jE9NzklW+Whx4kKcJ+kqgqTLSqmUwQalStUDxbcmPreJ0i6DfiZvNPl6TY8z564JqNLz8aSqsxc23edEcSUK7XP6kvEyclWQVCHeveNwBG6xj+XwXTRpkrdjtVhcKX30Zwsg7CMRiucMuEqHSLR5WzqO+c9IZ9KHObxUxPQf24/B8CWzS13knfNIYDLxLXuHK+QP8q66UbVAME/rrs+EGDGB//QJHN8RsLJl3jOVptp7yiFwHezHwlIhuW467cPiQ1ZfkiAc+NzpdFHnqOQ3aZT0EUri+uQ7nWOGvRY69og1NEwKtUVot/KMhDaIU+pQnXB6o7naGSHvoF+/9OrXy/LK95JP48c7L0Wpl3Ss3z7rbv3riLZRJGCjCy5ASEUw88qmiiU4E1FeFlkb1OqqdLsoiW6M0TXM1vc+GrAdWVo81zAbhIi80aYSZ5Wg6rJsqjGCbJ9yS3hZeE+iPVNdspZx9nFpaJmMCgWSWzSZSnPwJ7aekcafBn5GEiPiP7RqftCi/YlAbrblV3hrJ3H9U/Ty0TStOiyxDZboR69NegMI7+MpAqxMb24sSs0fXebqPfaE9ekifsmfvpiyCj7CM+khkbk6cs5R4v1arRUwcbNMrXsotbriI243ZMfsL3Wkjg58a49vcUjKxfU2AvduD6V69mhXXnFKgnKlYEOzq2H/SZcPbEZk0OMxCYArTTRD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l7xnzUhefBVx7oPsPbah3hosAnow6EX3enFTx+NJuvkZCpGd1nVEpxBwg3HI?=
 =?us-ascii?Q?YBq/fbcc4yyF+Jalmx2bK0CiHO2gFlykjAPpdEtzOPtIijCeaBO+4YGK5B5Y?=
 =?us-ascii?Q?fFRYzw1Uq+ou8c4gf2BJlU+R9dqsnKUHtPSnR6tT78hvQCzGJwOV0SfF0SiY?=
 =?us-ascii?Q?EtkXYAA9gw7V9H7hZ7CN61My/CapGkytu+1rJmGT61tFTfvl/IzU7IY9JduT?=
 =?us-ascii?Q?ZK7ecw7bv1hcGMvT4AGUA8FoUQBwjJvJVRu8A4ucrIOQlRMxHGXuZ9cWlE9E?=
 =?us-ascii?Q?t4v5sn91qeybxLRYkyNlkiUCzMFbwrnjrkHFYsDqlldegOwkAjA3cmj1x8Ue?=
 =?us-ascii?Q?blkovsiNNMWWHI2LlrxpSBdl93sM+kWR2o4h1guk7LvK5KP5/1kP/Vwxt1RI?=
 =?us-ascii?Q?BNkXfVLBGbwFuy+tameXthghR5sIeTqgsuEzmpHUSwhObhKoHCWQQ79ioFBN?=
 =?us-ascii?Q?vjrxI4+XxLMsl86kB1kOuLlbJFNX5pjzQaNwt0x2+c7lmChGNxL5FFuAjTUl?=
 =?us-ascii?Q?5L16IaCdlnxU1vFnpZKTraB7izZNyJKYaIj56THTCZQxUweQzD41GQ8Hk4HB?=
 =?us-ascii?Q?5SSatO0rpfbMSV9DMmIMGIXig2wgTtMdpiANg8oTkKRerfmdozdZHla9Uc2x?=
 =?us-ascii?Q?j5I8zY3QHdv88zmdqTvKO5OIkQGutAI8xpGOLI4w6MkPAGkJAtg/IcyDzhzJ?=
 =?us-ascii?Q?lKFIDnWrK8Kr4YJWDag2PdzBGj5aDwjMamJV0pA8q3ZBI8U+v3OvVKsXhxKO?=
 =?us-ascii?Q?f5iA52E2UsW/B9PgQj27nK6Et7TQwUmHmwj2iaxYv4W64Fb9aGm1xvhGTGGs?=
 =?us-ascii?Q?z4TTc7Gyi/vEjxGty/XGAQ7f8nb6ZwIjI3Sx1zCWENTEFv6Nh9LnZXPkNTsz?=
 =?us-ascii?Q?wXO9cQSTrvnCT6qiX6HvOt6mO/fA8vUb3VpXHkYkEwlridYzEpeYKMIS/aPf?=
 =?us-ascii?Q?92ksgJ80fd6llKmiDlgTI8gP5SxwAiEOP5VVgxRAxvJYbQG3CA56bGkgFPuG?=
 =?us-ascii?Q?aB6jkf0x/4CtKsPV2Upfi1sH/ENGbJBAJp89p7tL6zbzSPYC0I46dQHxNoKH?=
 =?us-ascii?Q?kRBhRKSbCq1LPcIUPn7xASb99zYN8gM77/To0DlCwHHfTQeXiWBN93qpNlG9?=
 =?us-ascii?Q?a7ZZp5a6RgRPoPO+RFxF7AeNLloZvzRTXGJ0jLTPcomRuW730cAeI8wLWov2?=
 =?us-ascii?Q?YDF+rWEnIQ/nQe+ObyPBJ3raYV4XAss7Xo0nI9PSIFEuHhdxKwOMiTQKQh5Q?=
 =?us-ascii?Q?f2JA+wsaKZvwVye9duX84l/8qyF6hT7bGlHCY65+E59BupIqf7HuiuSB/Tq6?=
 =?us-ascii?Q?t7Xavsd5eVUabm9NWss8AHw9jZt98F9MnVA2OiF4LkzUpmZJozg4pv07w5Ca?=
 =?us-ascii?Q?HVp5Z+WrIY7w5vh0IX/j1Bqu4z4y3EkKLHqG1Xhdh/H45u/cQvMD+94GpHwm?=
 =?us-ascii?Q?6BPS98usfo5x12t3EI2I36GA9j+yxoGAFqH+aLN1KgnBsE4AtPusHSesLuc3?=
 =?us-ascii?Q?YUWc6b6wgskW/cMeGFduHQ01bPPxhPIJHwuxjUCOWNhAvzvRMmJ1BHL1v44c?=
 =?us-ascii?Q?T4OKJrqTHu/priZ6DZvAqVljBwia73TMYvhjxY7ihsuP4mGEIOytgzKd8s7s?=
 =?us-ascii?Q?t/FtZyxjeXK5xGYz886ifZpBJcT1uNruMzlujknvFsW9oGWkooRWpD3TwTP2?=
 =?us-ascii?Q?6RvsB70ouwg19XK6CjTtncR5/uuv65QYzyhEXi9A1evB1vS9QJL0RdMPCp4C?=
 =?us-ascii?Q?GouGkPOfiw=3D=3D?=
X-Exchange-RoutingPolicyChecked: XZz+ynWfsgMeoI/SsqGGzwHRoH44MQk125LuUkH8ryqbZ2EJwlEIuyKdQGtI5SPjCnPrvabFwZtXMOmUjJuZiUa8/4ZB22vGw3AA20RbZ7rDabGOLPtSl15THzMvlD9wxJPJpzAYerzBP2oBEKOpVxF9TZSDTDa+xseou9ry/SgwItgvhD7Ae/2ptl1b0k76Bx5f3mBxQcOKoL1W7TE7JgpwU/optpGRALLebvOqyzTY33tQaF9/8ri2zi/p6Qw+j8I5RTese8m8w9AdlMD8j1oHoynbO61wTP1RsmF/hesvMd9fudzzM73RhOvSeNPzQ2l2eRAWTAmi/tiFCEvdIg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f336924f-7d66-40b4-ffd0-08dec70b96e8
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 16:16:12.4801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 617V+CXS6ECFXFKVLjau++N+rAu8qrWLtHddhePWB2wD45ni9ZgfAjP55506npd4a+53/AdUB8v5eORJA6e/VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR11MB9465
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:26:06PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > @@ -3147,6 +3148,10 @@ static int rdt_get_tree(struct fs_context *fc)
> >  out:
> >  	mutex_unlock(&rdtgroup_mutex);
> >  	cpus_read_unlock();
> > +
> > +	if (ret)
> 
> Can ret be zero here?

No. I'll remove the "if" check.
> 
> > +		resctrl_arch_unmount();
> > +
> >  	return ret;
> >  }
> >  
> 
> Reinette

-Tony
