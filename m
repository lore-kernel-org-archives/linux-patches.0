Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970B337E5C2
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784060951; cv=fail; b=guPXMCKHT6oPnh+eiRSt1HeChUByPtdxT1drM0mDhJ0x9rhJpMOVo+cdQ7tUsWpkXEipt3tYB/l+7WaUsRyy/K2u2CQpvYYHweKiQdxHxUhUMRTn+t2KCRiMK8r/xeMD7A22250Gl0pYWIGDFttbOxHX29wsN+ru+6s16KWik3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784060951; c=relaxed/simple;
	bh=bLHwg/HJx9SKjkI/p4vYssJpYi2LO6ea5zr5sfgLg9Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PNuYzSggIH3ZMCiRMc2lGrRTGDcoMyxNfF5DVIOaEVdAFBHWikeHp/fgwaDPYTiqaR5aInfQACdM72+ambmU81gNotZzTqZpfsTJULAspX8GpPLkYmHBstEGG79vt/b6G7sWT3Zgv/pa/pQwoSvh2jFKsl6VJaxMC0rzHhyFH+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mMpnqMUU; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mMpnqMUU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784060950; x=1815596950;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bLHwg/HJx9SKjkI/p4vYssJpYi2LO6ea5zr5sfgLg9Q=;
  b=mMpnqMUUbhGg5bQVPvZYuqLIQcKSxkUEFOe/6OxKuS1UVy7kvrATjlHL
   Jr9aTNUXp+XWsZz91So3THBrKItr2hA6XWKFSYHRJAQF0i/EiCNBoxp41
   Y1jssHUFh7IwT0lf81sKodpWsWvdHbchJ6AzCGqxj9eymUr3OCZuSUI/I
   5BlTtSV9A+lz36Iix1COqA8OC0b8O1a/ySikJRcDEr161f30WV/kfBIQL
   Y7kog6wfv56NS+JbIhbJDBTcMAT2XgCn8aACNM0eTUAWKpTHNzqAlXaf9
   5jjPg0u7eohZbwOVSwGfsJ/ZPNlfKwUFuSVMaq4H/7IqS+hJzGF+8koFM
   A==;
X-CSE-ConnectionGUID: 3dpuNarxRuyId43DzyYxXg==
X-CSE-MsgGUID: A16ZGDrJTq+pAR2ieACZ5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96057553"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="96057553"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 13:29:09 -0700
X-CSE-ConnectionGUID: C6xiRUTQRJS1hgoqtKMRMg==
X-CSE-MsgGUID: DIQYL503S6On1s1qH0BbQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="279240884"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 13:29:09 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 13:29:08 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 13:29:08 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 13:29:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7GJv8GLfhvqwX74sygwR7s6pWYs0J9tAVK2C1gJmygFO6/Ez9rp1qiPJTGB6gc3uQuDblOvLsDCldgJx8lT4QG3iyNTmDaJhsjRH0NUaea8rlp4zlPmY5KyK7BrPN+d4eDZL/mkmNJ6OUiwCqb/T1S/diU5jAgP2woeFSua3Rds/h+bIncgkZP97gWnT8zKgufu3QX0bXW9/XHv3KesZmW3ncF4ZwAPC5i6ahMnABYhyhOu0a0asnLw4o0/lIsU92Z8xWbCDxJgwGTYskE8qaYpd/7/khamgSdHOnK5p3QA+e7LFl6mvE28YWRuxwvk8aMRLlOCRu9flVEvYaxevQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwE35T9HvMS8MXZEHNg4YKm1VGJMjT45uUBgP0+xEzA=;
 b=PQSZ5SOt5i8hx3zhAFZd6jh4+nC4LH0iNcFH9WOSXic25Dsu2XoZ0FcDZ+u4jqSwnEEhuPkDl9s33xKGTtaM7i/Te6vA7vi/GGRAs53q9XYfR4w4bi627TJS7KxyamHBgrYw9fAFyM/RcpuwVRPshQ7Ku2dCLPuVRgCWTRT8RvG0oEYEhfNjuYJ/xlSsAx5DSyy/ColYYWNpOCWwUk80qpijgdJmr66ILXJaVVce8mYb1VS5TfItMnRaUbULQsG5GNczEE2z351/Ujy6Hrf8gXhhjPXgEJ5ETNIj93pflSENddQQAD3h8tslse0J3s3El7SweOJWckzwbcetf6Ot0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW5PR11MB5763.namprd11.prod.outlook.com (2603:10b6:303:19a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 20:29:01 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 20:29:00 +0000
Date: Tue, 14 Jul 2026 13:28:59 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
Message-ID: <alacCy4Ja4gF97PU@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
 <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
 <alZdWe-DACOtDwm0@agluck-desk3>
 <cbbf71f2-06a0-4833-a7b3-b8c6df440e93@intel.com>
 <alZ2-eJ3yXWHVelp@agluck-desk3>
 <4f0124ca-d4a5-40a3-9bc8-3a1e75ff576a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4f0124ca-d4a5-40a3-9bc8-3a1e75ff576a@intel.com>
X-ClientProxiedBy: SJ0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::34) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW5PR11MB5763:EE_
X-MS-Office365-Filtering-Correlation-Id: b11aa2c6-4f04-4c68-003d-08dee1e689fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|4143699003|3023799007|5023799004|11063799006|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: NsBN3Hl0k2Bam8lcXCGzdDZcvA6obw/gZWi42ynJhpqKrK4aWQFeV+nvNgtYWyxpnyDDD65ugkm7jK5mdGCkINpBGMJfVnXYVHSR7N1/58dVQpalPDr+FVFgmnM6O7mXQlX/uEE0z+GVZ00w4SifVHed3FrL/07/Q36YvULi32Fr9/iaxz9KLjMWT6o9XJAUBAaoXsZz1N/hKxfTwqRlyDYs8UUJqOJfQsVZdQxgSXxDYum5EFA6geQGf8nAzqzDEmp/WOyVaGs5VyJH0IsHQknkm0otNmB862GUdN1a+5kMoglWlvOnVo1VKmH4r816O/+lhe48EUhCLmYOtfRiN8FZbUjT79glccaf1jNSkGsVvSfyWX4bye6D2EYZufLBrFa5NAiY60xs/0s4GHZMmsUDt72KbYkR5N3x6PCpTN7xqODqHbkPxYICGMI1D596axW+rUwomEaQlCSAkGTEyZNB/7xakgBRwxmHL9cn49Dv+57JS1BMsnVCJwZVFYMeE/VU59rRQL1PkCao6q3ZVxE8Z/NjcRi1hf1ZvUCZVnlLQnyUzmOzkV32B/rXBGT4nMqBFNEt+Gq0Q+2j2omnXKuVHKsC/qEkkCloC72aWVHy8/SmN+Vg66CocGA8kNuv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(4143699003)(3023799007)(5023799004)(11063799006)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9J3GLmaAnKq5h3u0QrY0u7dvnYlcZg7JaPZENqngAHhTMsKk7wOIw5dKlEG?=
 =?us-ascii?Q?IjYic6Vid6YlLstHnfyGc7/wLLXIB9vzZSRFx9+tgKUthryRooVhWSDkOlBG?=
 =?us-ascii?Q?NcTYnU0gyQuW/J8kYo8MDUXlgnEhPyS7IT7eVgXENDOp2f2DOySTDV8xIpOj?=
 =?us-ascii?Q?gFAZrTHlp4cwIk7bEfaSWn7aSi/5PGs7XdplkoFVAnglINAOlsBeywCKqyJl?=
 =?us-ascii?Q?AUyG85bcGAC3wiFYeqmeH4Cz8hX3FX4n2wKZjCxFpkbLwjwdUmU9RHghP+GR?=
 =?us-ascii?Q?DWl3nwPVylvZTVtDbWfVyHaCINrHDRJKESSGpoVHlSWnWurNKpD8Zd77pxAr?=
 =?us-ascii?Q?lHayv3a9fRXAPPbbmKTii+SBMV7Dnc4hbskEP8zffeGiV4I/5O1dq2gpa8+W?=
 =?us-ascii?Q?SIWI+CaSi1kt5lpPqG4wSoMFz0GNuHhzXr+040WWVw5ja0/XwR2imjc1Q+Se?=
 =?us-ascii?Q?nDt8Iu/Uld4HTfrHc+aYwgLyJ5lx0Pp5iW3/f47uWXi7YPR+Vb6s2xdSoIKR?=
 =?us-ascii?Q?vjgY2Cfa6Z6+NGgIZyWedf80rc5LMt6+Adlk/zSURJVNv4B/BcwNyugbj9ub?=
 =?us-ascii?Q?P5acik9trQ6nfU72GgviroiCWsoTp1NwFfM0ZP/CkGhinysMA4bxOKTMmiDY?=
 =?us-ascii?Q?5DK1KSahNnZZ5G2HWwaXZr/OykVFrHbB/0AfEAZBJ3s3fnG/+mDrECnU2MD8?=
 =?us-ascii?Q?4v0ftuFPz8Ua3nb+aZrjMpdmPsez5GSXhxowfWSDDVz3kI0A3xApBA26Fkzz?=
 =?us-ascii?Q?ZyIIqpCe7nJVPBREopV1nn0JUeME33I5fV5I6MxvFDfSaduHWAHiTQHR+BBC?=
 =?us-ascii?Q?CK2lJ4pqIQCXa/Ak0oW5kQd5uCgw3bW6JEsAES0Azdkot3UHAbkJghDaY3ps?=
 =?us-ascii?Q?1Df/krwMBGxQ0XOZpScByJIx8vf28jyP3xG/SfZ4jS+jUXZmdsP49mErYsnm?=
 =?us-ascii?Q?U/hmdvoTf1i5QuRslP/gFviVLTYgYXHHhX/ONeYQ/3x4wRBiFf83uhUblq3t?=
 =?us-ascii?Q?nimSGIamo6ceY1MEkjRKbmhVZf9NlvCAxz2Ai9HvkzX+VZ7o/sJtvN6fDZmx?=
 =?us-ascii?Q?ruXvymVt5fPB4azWJ0a2JqJVeJZmdWKUGwva6r+sD80gJIwzTtfBlX27Ct88?=
 =?us-ascii?Q?srBJZp9hGlbvML8cojTJuG12zl5iD+3ooo2s7goUqhubqvwZ/ieml+Kj9Dk7?=
 =?us-ascii?Q?j//qsI/W+xqCfgWf5b4/bGTCT+hPK23cA9o0Ut9RUFgdOYIa8+fdfpp7V7az?=
 =?us-ascii?Q?Pm0U7LIyypm4sUjEKTja8tLVibkTxtS0/E8AcvoZVAfP4asfownGkFwWX621?=
 =?us-ascii?Q?47IaAnjHGIV3jkMDsiIznFZ2AKwZ9ewr/mqvN1JUeNsYEHbt636M2EAlwXnw?=
 =?us-ascii?Q?zVwhk5o3PqjPTK7O9ZWWs6lEkCR6AAsl97LgnCCuD8mAiYCr00hWI9Ju3+g0?=
 =?us-ascii?Q?tOzoKoRivCARNEs6kNAtluhqyY3tRZ3ZTj62ZAhcQ5FuH6llLzWZOe0j5j7N?=
 =?us-ascii?Q?l3P/r+75UAh/coRE8+izCKPdELTenXeeygjE1vgqEsEJV86fR+gjULCAFDDI?=
 =?us-ascii?Q?Lx7O9fhEJdoPYYjWoBBBJqwcM/3reMn+LuvwCbYD1+JJhg7R6oecMiNKhMzh?=
 =?us-ascii?Q?feIRCScAef34se9fDzjHfw5aG6hO1lib2QYHi4XBaUkBIw8W4V6XVsiug7jy?=
 =?us-ascii?Q?vaKh+NzezFWsNjg11Mnq5/J6BE+rEOsqXSzB2BRQPuHQeuz0WMHNjo/NiT6C?=
 =?us-ascii?Q?qkbwVpdH4w=3D=3D?=
X-Exchange-RoutingPolicyChecked: tPjAinJ71mnO0/YkkTxSYxaLHAhxL+b8b3wfRBLkMnBvfr7AnjaIXvJg4GwsQZ7RFSL4lNG7k29qT5p14iq7Gg9tZrxbj7zHDpwRnIQliadBvUJxFsphf9pZbtLKf/5cabsr42rynD8fAZ7G6zV9XFHDrffYAto1TYXT5Pkh63CXSPyp6vb4qxP9IyRf9TA0VlwMUyeGAwWUEOj6IjnhNVlLTOjGY6j3Pebas27g7SnzW4Hee4B48+MLFxjn0MkThNsIxNMUFTXzi5FXS5dc9Uqgs7sCdgT6UFgiDI0he9t4+3U4VU8a0CddTxcyP0kn0NfO3XKeT+vaxmtkzmzzkg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b11aa2c6-4f04-4c68-003d-08dee1e689fe
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 20:29:00.8679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USpiZAh3/S7X5Lm3q3N8RJu6iQdhWTvBG5QiBtETnHd7Xe1j8bsCjpzkprj68MKVdik+BNNIcfIP9cvz6V5vEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5763
X-OriginatorOrg: intel.com

Hi Reinette,

On Tue, Jul 14, 2026 at 11:16:53AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/14/26 10:50 AM, Luck, Tony wrote:
> > On Tue, Jul 14, 2026 at 09:45:04AM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> > 
> > ... trimming to open issue ...
> > 
> >>>> How much to rely on CPUID is not clear to me. The direction seems to
> >>>> be to move away from CPUID, which makes adding new CPUID dependencies
> >>>> less ideal? 
> > 
> > Where is this direction to move away from CPUID coming from?
> 
> This is the impression I got from the discussions during series that adds support for
> LLC occupancy monitoring via ERDT (https://lore.kernel.org/lkml/cover.1782866200.git.yu.c.chen@intel.com/).
> If ERDT is the future direction then I do not think resctrl should assume that the
> same data will always be available via CPUID also. With ERDT there is a separate
> per-domain maximum RMID that should be discovered via ACPI.

My view of system design today is that architects have a box full of Lego(TM)
bricks for features that they clip together. The bricks often have different
parameters - sized based on the maximum values across all systems where they
might be used.

In this case you end up with different components supporting different
numbers of RMIDs.

For RMID the absolute maximum usable value is defined by CPUID(0xF).EBX.
A WRMSR to IA32_PQR_ASSOC.RMID of any value greater than that will #GP
fault. So, while you might have an ERDT table saying that it supports 500
RMIDs, if that Lego brick is plugged into an SoC that has CPUID(0xF).EBX =
399, then you can only use 400 RMIDs, and the extra 100 counters on the ERDT
device will sit unused as there is no way for them to be accessed.

> >>> Here's my current work-in-progress version:
> >>>
> >>> u32 resctrl_arch_system_max_rmid_idx(void)
> >>> {
> >>> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> >>> 	u32 ret;
> >>>
> >>> 	/* CPUID provides maximum possible RMID value */
> >>> 	ret = cpuid_ebx(0xf) + 1;
> >>
> >> There is also boot_cpu_data.x86_cache_max_rmid initialized in resctrl_cpu_detect() that
> >> could be used directly? Looks like resctrl_cpu_detect() already scales the number of
> >> RMID down if needed when L3 monitoring is supported, but it does not take SNC into account.
> > 
> > I looked at that, but rejected it because it isn't adjusted for SNC.
> 
> Right. Neither is cpuid_ebx(0xf). Is it necessary for resctrl_arch_system_max_rmid_idx()
> to call CPUID every time or could it use the cached value in boot_cpu_data.x86_cache_max_rmid?

Yes. Necessary. See how boot_cpu_data.x86_cache_max_rmid is derived:

/* Runs once on the BSP during boot. */
void resctrl_cpu_detect(struct cpuinfo_x86 *c)
{
	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
		c->x86_cache_max_rmid  = -1;
		c->x86_cache_occ_scale = -1;
		c->x86_cache_mbm_width_offset = -1;
		return;
	}

On a theoretical platform that doesn't support X86_FEATURE_CQM_LLC or X86_FEATURE_ABMC
x86_cache_max_rmid will be -1.

In fact you can get this with boot argument of "clearcpuid=cqm_occup_llc"

I wonder if that test should really be for X86_FEATURE_CQM and thus
check CPUID(0x7).EBX[12]?

> >>> 	/*
> >>> 	 * if system is capable of L3 monitoring the maximum RMID value may
> >>> 	 * be lower that system maximum. Either because the L3 monitoring
> >>> 	 * feature supports fewer RMIDs (CPUID(0xF, 0x1).ECX), or because SNC
> >>> 	 * (Sub-NUMA Cluster) is enabled and divides RMIDs per cluster.
> >>> 	 */
> >>> 	if (r->mon_capable)
> >>> 		ret = r->mon.num_rmid;
> >>>
> >>> 	return ret;
> >>> }
> >>>
> >>> CPUID seems unavoidable in the case that the platform doesn't support
> >>> (or has disabled the various L3 monitoring events). In that case using
> >>
> >> Since L3 monitoring is the only CPUID supported monitoring resource I do not
> >> think cpuid_ebx(0xf) can be used if the platform does not support L3 monitoring.
> >> I expect that would mean that leaf 0x7 would indicate that monitoring is
> >> not supported which would make leaf 0xf invalid? Interestingly resctrl does
> >> not seem to consider X86_FEATURE_CQM from leaf 0x7 at all and just goes straight
> >> to leaf 0xf.
> > 
> > I disagree. The definition of IA32_PQR_ASSOC says:
> > 
> > 1) The MSR exists if either of CPUID.07H.00H:EBX[12] or CPUID.07H.00H:EBX[15] is set
> >    (in this case bit 12 for monitoring, It does appear to be a bug that resctrl is
> >    not checking bit 12 before looking at leaf 0xF).
> > 
> > 2) The supported width of the RMID field is Ceil(Log2 (CPUID.0FH.00H:EBX[31:0] +1))
> > 
> > So I believe that a theoretical system that supported AET (or some other
> > monitoring) but didn't support L3 monitoring, would have to set CPUID.07H.00H:EBX[12]
> > and provide the max RMID value in CPUID.0FH.00H:EBX[31:0].
> 
> I see. That would mean that CPUID would report a max RMID value while also reporting
> that there are no resources being monitored. I assume ERDT is an example of "some other
> monitoring" and it has its own per-domain max RMID that is separate from the different
> monitoring features. How do these different max RMID values relate? Should this
> architectural "get the max RMID" be expanded to also consider the per-RMDD maximum when
> ERDT support lands?

Yes, ERDT is an example of a monitoring resource enumerated by ACPI.

AET is enumerated via a combination of PCIe configuration space VSEC
entries and an XML file.

See above "Lego" explanation for why they don't factor into the "max RMID"
calculation.

> > 
> > For resctrl we have the practical case of booting with "rdt=!cmt,!mbmtotal,!mbmlocal"
> > to software disable all L3 monitoring.
> ack.
> 
> Reinette
> 

-Tony
