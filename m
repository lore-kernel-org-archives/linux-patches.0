Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9899274425
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919010; cv=fail; b=mC9I79pytBebWlkK0f4AU74OrfcjqJRLXvAyo15jbvMonC9Pf9IGx8Tvnm2LB+keAR3uSdrsFJTdY4DZvTstTmjW6MHBYbvKy11a3Hi+OqHma9grAhn6iZCSadeSkedKIkXjpIZJ698OZul+76tqa4ToYewixj/CoPl2oT6Arlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919010; c=relaxed/simple;
	bh=IjqBd4q+0BIcA8XkTGG8m0176x3ujAScLbUhMbRe7J4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xty7nWEA5gPN72abNfBLvZRNMDfKy1dUaCYSQ9cX5n/XaVx8/4f1nCYiNeqDAUOvT5WFvgONpicYy8sa2nmtU9BSYvVpwTTGfX4LqHl3z4bVvK2ZMcZl29JYzbKOmgJz9nu0rQKOUPKLfyVsisk14jzyWJTQIaMigab6iNyX3PY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JDKsb99L; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JDKsb99L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718919009; x=1750455009;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IjqBd4q+0BIcA8XkTGG8m0176x3ujAScLbUhMbRe7J4=;
  b=JDKsb99LjDlBX6NUlRoQK94nmJDZctV/fyEokgMrRObceFl559teEuuu
   p6amJo9VwGGRCyuzrjVNPnFD9wJupjYwxn4Wo61G+vwa6HTskHVSLTDYA
   vAQjlNArS6KoYFwfqebdqhV8qcZFYZTWFeZ9nm0v+nakuhNz0hKEAL8ET
   EFhI6HdlWyJkoY+LnA70vf+RgdiaYVHsTLAqaVAiVrhj7oo9A4HZxwDhr
   TCfHIezZC4NJVuC3uemx1AtTTJtAWwjRbBnGiWJlKNKhCE6+eaDF6K1RD
   ZKcuu/NlR0qtqNfYH8IRIhOdMGxtgc0ONZ+aJHfvJbStF94oZP1IG4K7E
   A==;
X-CSE-ConnectionGUID: cZrVa23DTvSLYTLQb3I9pA==
X-CSE-MsgGUID: 9Qg/4lU3QWaV++oAU3FfyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16073830"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16073830"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:30:08 -0700
X-CSE-ConnectionGUID: ulrrhBMkTDysAjd7M1bhow==
X-CSE-MsgGUID: xqXN9fJGRh22Eb9ds75khQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="46899297"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:30:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:30:07 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:30:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:30:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:30:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muD4bgjBsydevMUmNg5yJWL8PAI15iQtA5t2i0v6ACmUvUmyWa0eFooUooTNua15vLE+xwNh6cSIvSwsIX3ir9TrmD+b9TRRq+8/g9wyadn+xfifvlt49U+2wlQFCOnff+CGF8iEPmHICGI1W4djGGBJHK2vfxt41RJK+hIpEyRJg7ThLs3ax6CrtjneMmqO1xyxTcTokfDM2cDehEhEDwqqNA2JJ8yYzpb2ZcIBsC09lsb7HSsdBnmvluWgWUkvdiFIJHoLnIFwETEsLqKx8MhVARWv+aToOWPzJGuyNrqYbY4rTr1kqSTsK9whTxN9dWPa2x9KWVuASe4FhVhBzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/40vYfXg5jW05E/e6OE8lSD8g51prhVP8Xw1ApIh0FA=;
 b=eREPJqZOWtyH+BNg1ZmyyMrEbocd35NtcVdNDtyxH+jWkffxfuoqhJ9MOIOz20kX/JbvO+lyCqEucg9fV6yhXCdNyBmTjpWJh0L/PqtaTasTnyUL7CieVw6INKCcGINMinv8Vh7We9PPHouJ1S2ekvy2ZxmCHFheigbUMNBLNEcRvlXtkY+IeKZEVvFzsMxVwMAn1wLywIyHdM/nklKLpwSreste7XiBrE3fRAeEz1sUm/J8oA0J4eGjVo6h21tdZ4kMtUQvnAWO+VBZQdafYXHV+tSrY+gmb9uHGOqrLsVnhx388ORO+PoSfReBHUYyyUIBcd0nthNHA1yEyflrag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5200.namprd11.prod.outlook.com (2603:10b6:a03:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:30:05 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:30:05 +0000
Message-ID: <407b1851-9d19-4d44-ac73-677a75ae22e3@intel.com>
Date: Thu, 20 Jun 2024 14:30:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 12/18] x86/resctrl: Create Sub-NUMA Cluster (SNC)
 monitor files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-13-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240610183528.349198-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: c95aa6fd-4df3-437e-f6ca-08dc917026a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MUl3UjRjZ1pGY29UUjBrbTVOOUV5Q0o2OWdxSUpKNmdBUlB6RjFMQ01Kc0lm?=
 =?utf-8?B?a0xnd2lzQTVkTXZybTJPenRQUXNXNUw5UXFyN1lsVkhEckVLUUROeTBPNlVL?=
 =?utf-8?B?WkxEOG5ldzNrNktVaWc1bEk2WmdrOXVTM1ZxaFRXeFgzUGJSM2Q2cHVINjdE?=
 =?utf-8?B?aThNRjlqUnQ5Sk93NWVzYWp5Y2NITjNJUDY3Sk9XSmVqY3FlSkpTOGRFZnJs?=
 =?utf-8?B?ZUJFQVRha3duZlQ5NVZrc1dCSktRQ01NUkU1UjN0SDNOZzdyOGowbUZIMSsy?=
 =?utf-8?B?V2FGcGNIajJ4K0d0NCtqd2JsbXcvcUhsWlh6R3ZIbXdVNVJ4WHpoS0ZlQjVR?=
 =?utf-8?B?ektEQXVVM3VRV293UEZjekpFanU0QitFUDh4VThsZ2hqT1hQcmtVc1crTXFX?=
 =?utf-8?B?a2txMmM0cGRUTnNuS1lvM2xId2F1aVpNU2ZJK3AzWm5wMkZMelJUcXlBR0Y2?=
 =?utf-8?B?WEZ6eEhJWkthMk0wMndQTDIxUDIzL3krZ3l4bHlDd2k0U05lR3dya1Era252?=
 =?utf-8?B?Z0ZnL0JoUE9HL1J0ZENQRk52clRyK2VkaGp2NzRtSEhvZXNhT0k5UXd2NU43?=
 =?utf-8?B?MkRoMk43bmRVbGpUcmNoeWMzaSttRTZDaExtRXFKbnBTa2Y5b2RzN3hlV2Nt?=
 =?utf-8?B?TkxDUkNZVVV2djNwTXBRNGxBcjZvZDBUOUZWWDVyUjJDOS9sbnloOUJobEp5?=
 =?utf-8?B?Qlg1WXRDWTlSYWxsMGFuZHNRdmtIR1VZZEhsRkdtN1pMaU1wc2JYUGpJVFlp?=
 =?utf-8?B?ekMwSC80M1M3aVdtamh5NzAvZFllZnZ1VTVsT0dFemJ6VFpTb3J0Rk1hOCsx?=
 =?utf-8?B?RnViYlBJQWpITFZ1MjVjSFZ5WkJBRG11Nm1mb01vbndMMitRVE80S0NQSEdD?=
 =?utf-8?B?d3QreXVqUmtXblVnU1oxODFYaXlyMVE2cjdYUS9iN055YWR3bGplYlJQUlBJ?=
 =?utf-8?B?MFpTNkszMituV2xEa2loTVB4d044UnFKdGtqR1A4SUl4OGkwSzhkL1lDSDhu?=
 =?utf-8?B?c3M5MDUweWRINnFyRnc2MUFIc1lRSFJGRlFVWFJhb1gzaTFnNi9UaHljdE4w?=
 =?utf-8?B?Z2t6STIrZUo4b1haemZ1Uk9xTExwb3BSeFh2cnFKOGN6VURQU0RHdVlmM2Z6?=
 =?utf-8?B?SGl4TkEwdFdjRXgzMDVydmo0cjYvY2NZeFJRVFV3U0ZwcEtUSG00K0xlOGM1?=
 =?utf-8?B?YnFtTm5VSmtJc3ZlenVjb2oyTXRSdlhFcnVMZUtUTU0xQ0lMYUlBRlJtNWhT?=
 =?utf-8?B?ekMyV0N2bTJnSHRnMEc3bFk4TFJJNFhqMm9hUXpYNzFyU1djU3puMXNOYTBr?=
 =?utf-8?B?ckxxT2lIUlpzM1pZcFdwSHYxT1M4MUlYZHVSOTVNSExFMkhlVnN2VFpSMmtN?=
 =?utf-8?B?eGtvNEtYMG4yVlNuZ1gvMWJvVitCUjdWOXR2U0JaMklHbElXK1Z1WWpCZlpt?=
 =?utf-8?B?a0lqd0Z6YnpadmUvTlFjM2MrS2lRRHEvdjNzYUlOVzV0a2xBaCtlSjdRY3Rt?=
 =?utf-8?B?VVN1amFGTDJ2RTZCd3N5WS82aHEzNkgxQUllTE5OcStkWXJqb09PQktRakRi?=
 =?utf-8?B?NEwydU9EeWt5UnlQZ0dlN1Y4Z3JQYUdNZ2tKYUQ0L2MySXlkdW8xY05Oa2tZ?=
 =?utf-8?B?VVpyZ2RJSHlCMDZNZVJEWmJNZWtaNXFyUUUrNlFuYVR1QzY2NUlDdXR3UFB2?=
 =?utf-8?B?Q0lNVUx2VGNRKy9VclhFeDljQXozNUdZR3VVM2c3TWlRcGdjYVhlWXYvUkp5?=
 =?utf-8?Q?RyOWYaJKhQuHC25XZP2hgXtZx+o7eFNaEIx0tqN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEVxNEZmUWRVcFZtQmhKZ1ozVWpWTnB4YmVSQzVEN2swUVZZMkpJcXdaUzh6?=
 =?utf-8?B?Y2NFbWpjVmc4Ri9kVDFDY3V3WC81ZTR2R0dZOE44bEg5MDNvYSt3dGR4bWJz?=
 =?utf-8?B?RFNKT05GejczeGlkaEVBa3A3eWlrR015Q0lTK1hXYjVSTmxEOVdidWlQaWFO?=
 =?utf-8?B?cjJPWXkyRFBEQUltNFBha05admhFYnRFNmJvZlZHWFFaa3ZqK2hqWkxhUm9S?=
 =?utf-8?B?NEo0OUpPN1AyRHlsbmRXV3o0cjU3UTdjOHAyamFOdnRHWC9qUWV1aDV1QWRJ?=
 =?utf-8?B?SmtIcDFaVVJzcVdKVk5WYXdrb0RrSEhuZjhBeHN5aXFEdTcxemdzaWs4SytX?=
 =?utf-8?B?czVBVkRMNUU2angxU0J6K0h6Z1ByN2dHcEJncVRaSzJXS2kzZERZaXRCZ1lv?=
 =?utf-8?B?cHdWWWlRSGdwUXBObi9oaTk5SldreHhPd1h3aGdRa1B3d0kwY1pSTGk1S2l6?=
 =?utf-8?B?ZTdFK2tuWDNKVWNnSkJJT3Vla05kUTZGMUQ5ZGROYjJOc0RndWpzZlFzemk2?=
 =?utf-8?B?QTBjTEcxVXN1YzIxQzFMbkp2aFk1WUYyMFhNTFhQOVFUSTlrUmh0b2hleExS?=
 =?utf-8?B?T1FVVmxTQjNpeEpkMU9WbGszYjBMRElUdk9ZelJRNTQ2dVNnbXFDc1U3S1hx?=
 =?utf-8?B?UjQ0SUJpb0xRbFJUb1EwNzdEREJSQW9QdUd6UFNKWEhaL2RFMk1wZTNabG80?=
 =?utf-8?B?M2VORis0ZWFvWU9Xalh5Y2w0Q1hPbWZEZWZXcjlBZytRWnpMd08yOWwyT3J2?=
 =?utf-8?B?M1hpTDE4cmYyWDg2Qnc0cGhBa3JwQkNUMEZMcE5pcHhGR0hJWnFFUkVJbXc1?=
 =?utf-8?B?TFVLby9ESWxaNG9kd3lyWnJkeWpSOFFjeVlrSVh4UUtLOHdNRnhNN0EyNmR5?=
 =?utf-8?B?c1RQdFpOQWZDSllSQXRVOVJBSFlvTFJ3M01Qd2ZWYnFWeUM1b2R5Q0VNcmly?=
 =?utf-8?B?UmlJMXhCTzh5S1BZUGRBUWFZTHdxQ2cxcFBwekh6VDJoTzFzMHRDcUtwTEk5?=
 =?utf-8?B?UldBRXJlVWRwZmFYRHBNZEFyeVlkV0tmajBqQ21TMWdNQTdPbHZybksvZE95?=
 =?utf-8?B?TUdNTnBOSURTY2RMVWhrV0RSWVVJVG1oMjVya2RWaEN5TmpabFVuSGlRb1hh?=
 =?utf-8?B?b3RnUGRSaW8yWVgyamFXekUrRkk0TUhKYXk2NlY1K056OVNTRlMzNkY5YWgv?=
 =?utf-8?B?QUE2d1UzSUphY0ZHNWJrM1dxYkpzQWZVVkFMTVBHVGJiWERwbnRZZFE2MUIr?=
 =?utf-8?B?c003d0U3RDZqS2syZkJ6R2xIRVlHUXJ1dVl3cjM5dEJzRDVQTXFiRStGN2pM?=
 =?utf-8?B?Y0x2cWZXUGIrUFQxZ0FyOUtLZTNlSmwwL2VIaFVGY1k3bDBYdG1PUUp1MmNz?=
 =?utf-8?B?ZlRHVmpWSzF5Ym84bFNmOW9CZzh3bTJzdjNDcE1TWk9zUzFXNDVWdTdNZ1Rw?=
 =?utf-8?B?ZmNYemhZQ1lpckRTQmFWeUtsUHljdDJ3TFdVZ2dUT0U0OER5NlVWK2sveDBS?=
 =?utf-8?B?RUFvSHBhZFptTk14N1NPaEZ0Q1luN1N0cWtLMWpJbm1ERFdBYlN1OVJlYlNF?=
 =?utf-8?B?ekJjL05zOTRmcitTZ1JhM0NSVWFpbEFTYmJLWDFycEtjKzRwMTMwNGJrY2pW?=
 =?utf-8?B?dnhLSnU4RDFOcUNHY0hhaVZvbGczR2I3cXZWMXp4RXpIUEtaL3hObm1kNWlE?=
 =?utf-8?B?SUs5QXVkbnRkZWxrQlhEVkxsa3BVSE82SHh0N3VLeEEvMDRKNlJVMVNvZ08y?=
 =?utf-8?B?b2VXSzllYmEvanNqRHdUdFpCeGVvODZJeWxJRzZHYlk5REFBZnJGNkoxVkFJ?=
 =?utf-8?B?TlBrQ1JPNldFOFUwS3FOQUhhdFRsc0hHRG9aVzV6TlFjSWE2RDVrcWlxZ3Z5?=
 =?utf-8?B?MVF6WEpHeE9TaXZrL2syb0tvaWgrK0NDdzdWZlBEQWRhckpCQnFFL2pXblRK?=
 =?utf-8?B?VFVnSk9LZk4ya0EyT1ArbUVJWDYzWGFGT2hTV0JHUE1SOHBYa1cySFc2eFZF?=
 =?utf-8?B?b0l5NXl1SUY1Y3ZTdGZydFF0VXZCdUpobExPRUlacVdkMUxiNDZ2VWdxVHJp?=
 =?utf-8?B?YXFoRTcvaUUyWnFpRUFLekpCbThaVmV5TXN4YXNWd3NxNHdndk1kQlRJdDRn?=
 =?utf-8?B?cWNhM0oxMWpkMERVZ25WV0oxWEJvczhDdkpabXE5SURHdCsrQW9vKzNaRzQ1?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c95aa6fd-4df3-437e-f6ca-08dc917026a8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:30:05.1541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJ4nyIxVkOab256YFH4S/y/c0fkED2ozYYs0QNMzKw6BGi2/kXY55I62sgtbBJM2yDjJIYUHXT1ViWMNQsiQr1GHR0vmDp+uqhVqikYkgv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5200
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> When SNC mode is enabled, create subdirectories and files to monitor
> at the SNC node granularity. Legacy behavior is preserved by tagging
> the monitor files at the L3 granularity with the "sum" attribute.
> When the user reads these files the kernel will read monitor data
> from all SNC nodes that share the same L3 cache instance and return
> the aggregated value to the user.
> 
> Note that the "domid" field for files that must sum across SNC domains
> has the L3 cache instance id, while non-summing files use the domain id.
> 
> The "sum" files do not need to make a call to mon_event_read() to
> initialize the MBM counters. This will be handled by initializing the
> individual SNC nodes that share the L3.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 62 +++++++++++++++++++-------
>   1 file changed, 46 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 66acbad1c585..fc7f3f139800 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3022,7 +3022,8 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   }
>   
>   static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> -			     struct rdt_resource *r, struct rdtgroup *prgrp)
> +			     struct rdt_resource *r, struct rdtgroup *prgrp,
> +			     bool do_sum)
>   {
>   	union mon_data_bits priv;
>   	struct mon_evt *mevt;
> @@ -3033,14 +3034,15 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   		return -EPERM;
>   
>   	priv.u.rid = r->rid;
> -	priv.u.domid = d->hdr.id;
> +	priv.u.domid = do_sum ? d->ci->id : d->hdr.id;
> +	priv.u.sum = do_sum;
>   	list_for_each_entry(mevt, &r->evt_list, list) {
>   		priv.u.evtid = mevt->evtid;
>   		ret = mon_addfile(kn, mevt->name, priv.priv);
>   		if (ret)
>   			return ret;
>   
> -		if (is_mbm_event(mevt->evtid))
> +		if (!do_sum && is_mbm_event(mevt->evtid))
>   			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
>   	}
>   
> @@ -3051,23 +3053,51 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   				struct rdt_mon_domain *d,
>   				struct rdt_resource *r, struct rdtgroup *prgrp)
>   {
> -	struct kernfs_node *kn;
> +	struct kernfs_node *kn, *ckn;
>   	char name[32];
> -	int ret;
> +	bool snc_mode;
> +	int ret = 0;
>   
> -	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
> -	/* create the directory */
> -	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> -	if (IS_ERR(kn))
> -		return PTR_ERR(kn);
> +	lockdep_assert_held(&rdtgroup_mutex);
>   
> -	ret = rdtgroup_kn_set_ugid(kn);
> -	if (ret)
> -		goto out_destroy;
> +	snc_mode = r->mon_scope != RESCTRL_L3_CACHE;

I think that testing that it _should_ be of particular scope will be
easier to understand than testing what it should not be. Can this instead
be a positive check of:
	snc_mode = r->mon_scope == RESCTRL_L3_NODE;

> +	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);

I find this to be too subtle and potentially confusing since it uses
d->ci->id interchangeable for both SNC and non-SNC mode. I understand
that in non-SNC mode the domain id will be the same as the cache id
but I would prefer that the code use the data structures as intended
instead of relying backdoor on assumptions. Something like:

	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);

> +	kn = kernfs_find_and_get(parent_kn, name);
> +	if (kn) {
> +		/*
> +		 * rdtgroup_mutex will prevent this directory from being
> +		 * removed. No need to keep this hold.
> +		 */
> +		kernfs_put(kn);
> +	} else {
> +		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> +		if (IS_ERR(kn))
> +			return PTR_ERR(kn);
>   
> -	ret = mon_add_all_files(kn, d, r, prgrp);
> -	if (ret)
> -		goto out_destroy;
> +		ret = rdtgroup_kn_set_ugid(kn);
> +		if (ret)
> +			goto out_destroy;
> +		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> +		if (ret)
> +			goto out_destroy;
> +	}
> +
> +	if (snc_mode) {
> +		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
> +		if (IS_ERR(ckn)) {
> +			ret = -EINVAL;
> +			goto out_destroy;
> +		}
> +
> +		ret = rdtgroup_kn_set_ugid(ckn);
> +		if (ret)
> +			goto out_destroy;
> +
> +		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> +		if (ret)
> +			goto out_destroy;
> +	}
>   
>   	kernfs_activate(kn);
>   	return 0;

Reinette
