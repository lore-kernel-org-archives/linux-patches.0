Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393021D88B4
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 00:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765931336; cv=fail; b=ZITkRi+420G2gaIK11sRg8rvi364RkynQFg2TAjvG62TEx1iqnayBSeAiBgddkqgH6EezLGxsBcQ2f1O+HfZgy1TYIG7uTh8/N2HVERy/sktMpG8CpEKRqnWryykwF7Y75MQQNLsHkzhLDvaW0jBC5BhsnQ3jI3fefd1EoF/m4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765931336; c=relaxed/simple;
	bh=HU6FujU5AsrZGkUXP0gGC3Cmh5iX6GfvsosbuOLzq84=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UxpABc5ZMXH0FygzuICQM1/kWoye29S0yct/jK0aHV7quz3uWMYmr0JG2f2GQBaS44OAJf/eESePyyCitsQy4Kru+/aFgTFE7qOU86nqE3uN05FtIAbIN6T7XJoqwYKJMxQZ3bhE5BcoSYcheV8n5Oh1IZmK8zCiNpaA1JZfMi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RHmHgB+M; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RHmHgB+M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765931335; x=1797467335;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HU6FujU5AsrZGkUXP0gGC3Cmh5iX6GfvsosbuOLzq84=;
  b=RHmHgB+MW795Ts4cHWABo8iUez5qm5z+koTcbZPofaLZEqqHecDpEIOo
   HVukYhWkGrS8Z07oXqANhBQqNlb+iN2YVK9RFaXrzEQ/5Sn7w+4+7ym5o
   rs1D9DMwl0/yOvPUVV2wGzFHs9CBor3AtR2qAXFZkB/Iram2oh6VMevUo
   Nakx/n7jj5v+mOFFUT3uRlxXQS1nuPoE/NX8+z80G7iWYwgK7a9nOtw/k
   rso0uUXZgAIY5LWU5ti2kGLWIQnalLauZUxX0S6GL1F54wy5Gt3/f6RqZ
   EHUPyVWtAVgQ2HQihQKrlSFh21TKed/OZUCfsY3bcGpTI07pkkeeuzJ06
   A==;
X-CSE-ConnectionGUID: +FKAtTwNQlKIkJn08vofoA==
X-CSE-MsgGUID: sGXgrC7zQFirRS+qjhFp4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="85452002"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="85452002"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 16:28:55 -0800
X-CSE-ConnectionGUID: ztAyjbimTU+qm/SPVd2+sA==
X-CSE-MsgGUID: 8YDWIniKTr6C1lr2456Yhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="197447154"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 16:28:54 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 16:28:53 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 16:28:53 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 16:28:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OU0DkBwc1HgiKSa47mtEOz54l586AM1l2YJ1K05I5lbAV2u1KgBSv7OfWmQBybWw3JBc6itsEAC1M8FFVa3R3vkvixTCTOvwMhQDKSgIWB6P1sspMsyFlKTbEmVJBvzxk/eRJSzvRGSh0rlLhEupYhqbofvfDm6Z1BvIk/NxZ2LJ2ILM1NwLJ3/GaIhOTb9RdW1+Y5gD9kIbUOlfavSJ3Jd7mROtXZLFOgxqfI6AHJkQk7UIJYFSzaMoZ8dxaru+qfh8h51hNKL36BzZQ444O/9nh+YbQCOeQvYyQiJOT+7dzBpAV7LJq+jSL2JKnwhA/ysij7G96WMKRYiyNW3mvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/c+UHsNo7YlFTK/eEaGN9S2c1RsqHUvjZM1rTC7I8XA=;
 b=MORYOSkGSF2hcVi+/SVNs36wcf0wS5ESKRpPRcxjejLkpHBtJgJsR+676Ujj7cVAoWoLA/FxOUSL3/vymzCVHr5Wcf+aXrUega3ljUL6TZKg6fWZ2IceaSXYCgKDzgA40KlSR9/byUBJroKjQ6mxD776BU3emInvvBQJVbvl2sHaIL98TkmV4hizr7MEjYYeBzrZMhvMRXVq5ei9gGqMcsyKOSAADf3BWJv/Bj0iyaQ9nImwaZNK2tDvwdapLZ3pICglHMbkTmyXS88H9nj2Tt2cVwhjqDohzbgDNhuhtt5n7ZUL1wXbLlQx/6PhHfx7VJDmBw0+VR4E5zf6vh/Pdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BN9PR11MB5306.namprd11.prod.outlook.com (2603:10b6:408:137::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 00:28:50 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 00:28:50 +0000
Date: Tue, 16 Dec 2025 16:28:49 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <bmoger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Message-ID: <aUH5QZ7_7WCRWY3Y@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <aQJkIqj--nHzUzUb@agluck-desk3>
 <9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com>
X-ClientProxiedBy: SJ0PR13CA0187.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::12) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BN9PR11MB5306:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e22ed0a-7873-47db-c05b-08de3d03402f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WuBirEtcj3AgmZ5zE82715OWLhXy9KbJdnB65PW9+u722KxmZ6yKWDO96jbl?=
 =?us-ascii?Q?jMSxGBmfi8Z7X++9HhTJsAylTjAEB0QVUXrhLW3E5gEF7/EVixwDBrCP5o8Y?=
 =?us-ascii?Q?6W1+NrR/spxr30Q9RS6oo2wd5mFL+FlRyjU6cS0aKTourJjmAc9lffDGwY8r?=
 =?us-ascii?Q?WREFbw+RyDgGm2nIfYAUuCQodc7msr0teCIm3vcVneE9ZG66biiz5lF1haTU?=
 =?us-ascii?Q?zDtYIX1JGiJ0vezRj3hS/a6CCFUKi466mS6nSg7AijGDDHLFXC+Y7e5z8CQE?=
 =?us-ascii?Q?AEBpDKPGFjTpJ8EPEd7TnNRnS2JlG6hPj14ulIQ0G6cbpesDhtf6P9Y9kUMy?=
 =?us-ascii?Q?Vq7wjAtwYREn+fWj8MNtQXq8Lne1LsqvCcpBvU5/A7trsAMDDIwvwPpzyyVs?=
 =?us-ascii?Q?TWmZghWEIG9P/o2heKuMc/TAq4dcC/y5Ib6OJfvCEFkheQII+Ume5nTIP5PY?=
 =?us-ascii?Q?e0JTObZOCQ/NyxIbyf46D7ut56yNAGe79BXh6yH7Z939FVO6+tL8HFnjLIUO?=
 =?us-ascii?Q?7M2AYdbRZTMF+QrcN89kQpRhHfKJDr+dmBT3KJmKcWNqr76gidZcsDIi1JUd?=
 =?us-ascii?Q?JbRPLJhd9rujUjTlSS87QgwWh2pDTIjssynzji8g6pBO1PzSyKdVL9AXdzZd?=
 =?us-ascii?Q?8w7Nm1qRNsr/xydivo1UyNqKplKq6I7ALJwqaVp6RXJU+cBTOnW94AxgmwmB?=
 =?us-ascii?Q?gEZvs83UyQ9bHskD2CGIeMrnCKPMWYz072iRIEbzso0sOmXbFm9n5ZD+VYDd?=
 =?us-ascii?Q?fHYdiHO3kTEgeVpQtAsQ/xKBaSZtirgzbvWv/7vCXgvyosVGGTuQqc1+5CQ7?=
 =?us-ascii?Q?h/hbuTRPnBPqN1TrXarSpDqjt2bb6/ssxnKehk6Z9gcYkBeKSjB5YkQ/FoRF?=
 =?us-ascii?Q?5mwzUNHKrehzxhoI5n4UMnh4GU05O+QxwUNylXGGP6OQHOSEsS61SrIW+zvz?=
 =?us-ascii?Q?s/FawH/UsI8PJ7qrGydNCzsEMLNUNEnBEu/LzbW3BpBmCSeZiJ4/IH4u2jfD?=
 =?us-ascii?Q?I7FfXqgtMYODFksrAxtJhC6QkMUnDs0UsDg0sJdxxb2wTU2XLcFaIRE2nZMl?=
 =?us-ascii?Q?4QKCsNXmhQKA0ZxUrKfQyQtTOFBzNszM/mLU5DetcZaAbQCbQOJcN1n6S38S?=
 =?us-ascii?Q?i3F1kgblDwDIMo6Byg15AjKWtYrNDpHwSULJjbNsn0VPctHNRYQFaUtnx/Pl?=
 =?us-ascii?Q?PnXm2FoP+mAFlU7ZcmRt1RScquZJ/FHoP4nTo/XsiRglnB1582VO89VAJ8JT?=
 =?us-ascii?Q?L0tTu1LXwCWAVh5NhO4Pe8Ur08fttYJFcYhJj/W4EceomqJGMTwcNLL/vXAh?=
 =?us-ascii?Q?8J+bv5zotm4geZ8m72GAptarpJmvZ+q+EYkAGCw9M356zjZ2kjjje+MLdxqp?=
 =?us-ascii?Q?LyjYyeRg4t/Z8Ey52ujRkysKWnokpnzjC3QFdYtDFKZX82hweDUiV7m7j60w?=
 =?us-ascii?Q?nKvR1o37AQDnl2AY9T5ZgTE+m/Cm0XsMR9+C47YwHRYIhAqraKUt+Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DNWJJS4ZbKCZDy9NxUGmmOOOV2Z+UGXZQFBtN5+DUPnBvDzB9g4N2/QT7Bde?=
 =?us-ascii?Q?L5C8TP/YXgNW6qFSiwOnvy+SDe3KR1AfJgtMUu5hRKtbRmhEbkZT+AUAm1qr?=
 =?us-ascii?Q?3QP2If/L5gOS5b0M8KNNCLM1RJwtKV33lXv5hUXc0+5N44X6GEDVLw2RMcWO?=
 =?us-ascii?Q?g3LVzRferJfEU82SN+fS9iCgOvLXDHhJAGLGD8BjeUqUpgxrVMWQ/JzvWaif?=
 =?us-ascii?Q?ASejLXHjMf+0Q03Hxw1aPEXlaBAGusWlHuvkZlaKIt6JQRSKUTqXFUh/WYYy?=
 =?us-ascii?Q?cm6H7BmOzNZ52bcYaL6ZFpovJceuTUH3LOIfEDEG4K8KNzPbXZkv0A3WxZeW?=
 =?us-ascii?Q?uF37wNzyesXnG620ImnG+sFKqSQJUXzskIUQJ3gZjdP5CoQ65ROyESQo1oHC?=
 =?us-ascii?Q?j0ech/5UG6o0zIaeT4xbm63Nt/pp65kff/Pn66YIYdObzkhMmRxwWd4qJiQe?=
 =?us-ascii?Q?Jh6urh7BkosVXPtQTIYMiH3us+GGT8JpJHsDV82dOXo+TCQWGtpmlpWfiGnd?=
 =?us-ascii?Q?M2JsnTZbOWn6xoCV8OADjQNXD4E0bQGPNGbh5F7+vIaJhRD/oWYl7sUnGspw?=
 =?us-ascii?Q?o34E8pIelF19w0BA6H5qeP9QYS128qmuxqSGqN62uJ48a5xsWbioYSB5k7mJ?=
 =?us-ascii?Q?3fZzVmc3rbQKciNhdVo1PO6xPz9HJKgcFLKVxoyxv3IST8SIFlSjjW0bongu?=
 =?us-ascii?Q?X3ule8MbVhFjcxq8iM1OBoiGbdOk2vdjoivJsIHXflg1/lhumIAglA8IzFYz?=
 =?us-ascii?Q?qM2Q2X1DHXFJuA/YnvxTsS/5mjP5YaT7Lw67m/jlQbcesrAVkv3frD5LnJV1?=
 =?us-ascii?Q?iMvycxkbLIbLDrMb42bsgclKdW62HAP9KR/bY9NqrlRpNg/9byy3hAH8lzCx?=
 =?us-ascii?Q?hirC2SgfzE94nai/qoTjTNKpfwUTqdCFqJecX+2MVQ/VV+pamy9RWRgsBgHA?=
 =?us-ascii?Q?46sPXsgFYwM8FgQO5TbEzpxiQ6SamOpdNOGEYY9QeS2yHUADJzvmGhc4zvFJ?=
 =?us-ascii?Q?DMz2Hz5hRo8S6GdGA/p/60K46xc9cfSFyALaDSQJVmKzgpYnqGedV17ufTGV?=
 =?us-ascii?Q?C9dIDJIj2eNWcaURP1dljdUa9dghN3UuRTvMWdypLZJMV6y3QGBtRbWvO33Q?=
 =?us-ascii?Q?PrLJ1ysb39OeDQsXcT2/EdWmW85Ger2JW97hkSRIE2UymozEFwmlUtci8Sl/?=
 =?us-ascii?Q?dZBKkXZffkl0xEm5eTjWFrfMKSE+TdjGaxrE2pW/1BMTPqjqGBuf5V1FlCuB?=
 =?us-ascii?Q?Q6mXlIvqCRewGcQ+gYCXvjQT78Fq6B2SqQKQ3pgfzJnrxfJyeDG6NM9KpwQf?=
 =?us-ascii?Q?IGItx5cGQN5wJMloheM8MNMO7wUnj5U3tTJ77ef4eMRafyuhWqGlZCPhTmoo?=
 =?us-ascii?Q?LMk7GNJHYcm4k2S9NJ0zTVIqYJAT5YDjfOZLgdIB33vmVu+JsFCYcBGjW+8R?=
 =?us-ascii?Q?nT4Q0HseM0YiQ3XGihvoAMXpS85XBp370dbsVfkwEPKnoha1qo7HVPOOsznH?=
 =?us-ascii?Q?UI7hbuewI8GeFoxHpvecKJAgwvER19IFZHq8kB0quWBIX60HgLkNiYZ69GbC?=
 =?us-ascii?Q?asPooWrLZdY5NTC/ehrSwoOj6g131gPoJvF06YbE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e22ed0a-7873-47db-c05b-08de3d03402f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 00:28:50.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZaAamKbXsf+VVFSGYVDRe06BYZPlO63kjNFYlaKO39RXwNjtvISpMEe5fwJbKxjsPvCac1hhIyI6tNDs4Ssv2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5306
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 09:33:56AM -0600, Moger, Babu wrote:
> Hi Tony,
> 
> On 10/29/2025 1:59 PM, Luck, Tony wrote:
> > I took a stab at applying the AET patches on tob of Babu's v10
> > SDCIAE series https://lore.kernel.org/all/cover.1761090859.git.babu.moger@amd.com/
> > 
> > There are only a couple of easy to resolve conflicts.
> > 
> > I pushed a branch with v6.18-rc3 + SDCIAE + AET here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git sdciae-aet
> > 
> 
> I ran your code on my AMD system. It appears to be working fine.
> I don't have the hardware that supports these features. It would be helpful
> to list the resctrl interface files (files in info directory and files each
> group) and give an example of how it looks in the system that supports these
> features. It can be in cover letter or resctrl.rst file as well. It will
> also help to review the code.

Reinette reminded me that I didn't provide the examples that I promised.


Here's what I plan to add to the v17 cover letter. Is this enough
detail?

-Tony


Examples:
--------

As with other resctrl monitoring features first create CTRL_MON or MON
directories and assign the tasks of interest to the group.

Energy events:
-------------

There are two events associated with energy consumption in the core.
The "core_energy" event reports out directly in Joules. To compute
power just take the difference between two samples and divide by the
time between them. E.g.

$ cat core_energy; sleep 10; cat core_energy
94499439.510380
94499607.019680
$ bc -q
scale=3
(94499607.019680 - 94499439.510380) / 10
16.750

So 16.75 Watts in this example.

Note that different runs of the same workload may report different
energy consumption. This happens when cores shift to different
voltage/frequency profiles due to overall system load.

The "activity" event reports energy usage in a manner independent
of voltage and frequency. This may be useful for developers to
assess how modifications to a program (e.g. attaching to a library
optimized to use AVX instructions) affect energy consumption. So
read the "activity" at the start and end of program execution and
compute the difference.

Perf events:
-----------

The other telemetry events largely duplicate events available using
"perf", but avoid of reading the perf counters on every context switch.
This may be a significant improvement when monitoring highly multi-threaded
applications. E.g. to find the ratio of core cycles to reference cycles:

$ cat unhalted_core_cycles unhalted_ref_cycles
1312249223146571
1660157011698276
$ { run application here }
$ cat unhalted_core_cycles unhalted_ref_cycles
1313573565617233
1661511224019444
$ bc -q
scale = 3
(1661511224019444 - 1660157011698276) / (1313573565617233 - 1312249223146571)
1.022

