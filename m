Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692EC139CEC
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918008; cv=fail; b=f9+PW/bDL9692NOz6locZ2Fafk3xsgUjQdmysU/Des59d7J0TzjCtt3jpqISGMA3762b3fyepeOD38j//vAkLvnCI+8iGYuf3uXtVBspIdm44aIWXNz9JqwyI9z2bfmkcZDKkPG3fLaM5yOqDpBm9h+DUGPGS9B9Ufp2tN5sgdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918008; c=relaxed/simple;
	bh=JZ2qtiCUPZZMmNcadcwOPTUXDsLWs540P16aQOJmpio=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XmleWdlaU59gSGvK+LdGWm8A9TP0P//1Y02jRbrZx0LoHMqp5dQh2OpAplkM/o3UTVqVSgiuZVMJWS6C1HkZEu53TBqeXchCgSTctiJPLsecvv5DLP+0sUd2SnwIiAtBeRtkWfDzMYFe/vjdv0J37UWwqmRrRLWnH8sSIN9QSms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=epLlO/wD; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="epLlO/wD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918005; x=1750454005;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JZ2qtiCUPZZMmNcadcwOPTUXDsLWs540P16aQOJmpio=;
  b=epLlO/wDdWWcub5iEOhxNnHyVXX2+N/nHuBEkSILoPSymKxBoilqeNcf
   71/jNOxP0S79S767AOesDtley/OzeKE2r7Lg7eyuWeGuM7XVXGsBkP0OE
   IdkgpHHLKN+o7rkmtJ6pnvUF3NJONxO5cTxx3DYW8zxDANMp8pXeOSycF
   aqHDikZTF3MKjtQgwOfov22PGk83h+1WGc4A0ODFzG0qjpPsKUpI+Goeg
   w3XYTcb5SMwnZ08PjmbsjXX7kJZHiapYVwb1MXtOo51rgYv970EwgTnlR
   vpSSDVJAutqIIhWDxU95WTmNBubKNUrVZG0RVmC5UM/caZ6d0398TPw6j
   w==;
X-CSE-ConnectionGUID: 5f7tZCVTTN+mqhSeCWgQOw==
X-CSE-MsgGUID: ZH2nnfuCTf6tmA/iBggsRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="33473933"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="33473933"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:13:25 -0700
X-CSE-ConnectionGUID: ImGOycAtR86jreki3Pko3A==
X-CSE-MsgGUID: 1ajpSEuQSU+SdssSVCz+Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="46719064"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:13:25 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:13:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:13:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:13:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfbpYuD5QMoGSBdiTJasPhaM7qP3izP8UYrQEu5qfEY0oEcAax/IREVshvu1dM5ZZ6zMPBCaSHf7B/6oa2Hfu7nOfmInZ4yS9PzA7q10uyo6zxDihFtedbYA1+Lk00Vi9kK2CfaONnqrFfnXA9Rr8vgM47wvXlFC+MMHAAsmQBHAB2pckymnORWQhO4qbi2tcmQNLe8l2FjpicR0pi4OvApi1yvQg3+YZx4fCaIVrZTlCv2UmX/16wTpKnZKXxpSLNklfe/MeXxQu4Wz1hiXrlWIwwDUfUtAt4J7/sfX9UJ6ht5Kfktr+mSg5lJS/8yc+UCJp3CVVnNylOroCfxdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ng7Rg4opEEtyi3sya2E3wHLICKK5dUtBgnULrejsXg=;
 b=nfTW+N5ahmwyvSJr8JXvNDCXvbu25k73eeHf8vVMNpoiVGPx87mrJHjX6Ep+SXWTtKCthCzyjBCXy6CU18dbuUxEqWspm/XVjnP++WUTNnGGXqYyPj1Yt+oXb2dg7dYh5WYMaYpKr2ICScVD+wQ6ix/0illThvb/cZc7bzCn+kRr5zNqAvDjKUrZMtG46ET60BsHrm9qE+cDZvYzbpJTihCaQYKVVG9dkG7YnmLSmY5+/BQCTVRUpW2xxuC9zoL5iRJT9iCz5GQIrMMg2Dg2r4CdfvjKRS+EPkXqfdpjlLjUo4SC+Y2F5uLl/Vqvxo33Ak2rNbqLInjMx9eohtVziA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6878.namprd11.prod.outlook.com (2603:10b6:510:22a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:13:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:13:16 +0000
Message-ID: <4f9ef07d-2930-4994-92e5-8a1dc4b047ad@intel.com>
Date: Thu, 20 Jun 2024 14:13:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 02/18] x86/resctrl: Prepare to split rdt_domain
 structure
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:303:8c::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: c4668a8c-9a08-404d-59d4-08dc916dcd98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Zm91dUgrR010Ti9qYzBnMmJTSjJZZ3Z6aVZHOXB0MFUzckp3SDNZeHV6d3hj?=
 =?utf-8?B?THpGZi9JQVR5ak4rTnZ6WW8zUGdaKzI5OFAxcDZzSmhOdVhxM2xoMkNPVFJM?=
 =?utf-8?B?TFpvdlNYYjNBV2JpL04wdjh4SUZrTUZqbDZOU0c0L2FxS3YwdFFSMUpUTlQ5?=
 =?utf-8?B?a0J5c2RlUWt1bW10aTBvcXFrbHB4NGxTdUdhOXYxZ0J4dVBXM09kQUJjUHk3?=
 =?utf-8?B?ZXpEbXZKUW9LUkJod1JpZDR1OWxyMTVKVjZjQzYzbEE5SS84N1N1WmQ1dVFv?=
 =?utf-8?B?TUQvR0ZiT1NybktFRkc5WGhGZThEcnlqdlB3VHMzeVpFQy95UUt3WXFpY2tW?=
 =?utf-8?B?Y3FQUmtwb1dGL25WTmxWYzl6NWoxZHBNN1Y2MnZoSHREZDNzSnk3cGVvWmFu?=
 =?utf-8?B?cDBMVUFoVDFOVXFyQytQRVUxc3RoZkQ5QlhjR3BFVW5tR24rS0xzZVczaHBn?=
 =?utf-8?B?RElJZnVPeHIxUE5zU1pEZ2ZDRmZMUWdQL1lOQ0ZQZWJ6Uy9icDRDeXJsdWNn?=
 =?utf-8?B?a09lMFBvZGhxV2kvVHJxTStyaHdUZ3JMbW5qZUpHanh4SWpOVGxUMWFFbUhW?=
 =?utf-8?B?aDdYTVRjbTB6dHluaHQ3UFE3bHl3cnpIaGhseG5NUzNrU3B3cmwwdGd5UHRY?=
 =?utf-8?B?YlZtZmpEcmNRVTNCdVJjUDJvcEZOTHRWTDhPL0ZVaGFHZHgwU1dtNmI2M3Q1?=
 =?utf-8?B?bGRyYklEeHBxRTBNZ3JYNHhLYVplZ2g2SjArQTR3UzJmTlBDWk5iSkFPQkF3?=
 =?utf-8?B?ZDdUN1AvaHY2Q1JvSm1nRDN4T0NkYnp6MmxJU3RXbjJaU0RrNDIrZ2VFMGkw?=
 =?utf-8?B?dy9EL0MydmVIQTUvTVBDaFZwZ2lIcEVuVEhFY3RER2FJSVRSZEl1ZUUvZEJB?=
 =?utf-8?B?ZXJhdVhSaGJYd3ZTcEZLdURyb2NMM2JxU0JMbGwzTlRKVkVaTjU3Ris0aFBw?=
 =?utf-8?B?TmRGOXZuNEtIZVhOVTdVWTFkdGhORjlZWjhCNG9kRXB4UFFqSVNGRkZtNC9R?=
 =?utf-8?B?VWdNYWxFTXBmTXFiNk9RS3d0MmVoSFkwek0wbFkzVHpJY3BmTGNPVVJ2aXVY?=
 =?utf-8?B?bUFDUElzNkhMNms3M0VrSkliYW54RTV2T0pGQmw0akx6ZnZtVzNlRFBERGM0?=
 =?utf-8?B?VHV4NHg4UUREVW5zS0JDakpGa3lDZDgwQUp3bGQ3amZPMmIrYStUK0JjNE01?=
 =?utf-8?B?THA3YmFLYktoVGZYMkwrdllaL083SktZc3EvanhDS0h2RHNFUG5NdWFWeUJx?=
 =?utf-8?B?RkJmUS9TZWsrQWVJRnoxK3E1OHVYSTA2Q25Ga1BaRFJVVVJrd3FieUZTcnlq?=
 =?utf-8?B?VjVmVGxyK2c4a2NuRjFBUFFmMDhXNmlZTndDc09kK0hjMmZWZmxTRmVEeXB4?=
 =?utf-8?B?SDBhYUpOaXp0bUt0QnliUWFXVjJ6OVYybjBMUDlCR2t3anJQb0hWajJjMnFr?=
 =?utf-8?B?enQveTIxNHFKMFJkZXFlQ2VIZS9JSFpaWmYyRFdBb3BuV0tOcURuOVN2dFBa?=
 =?utf-8?B?WlBHN2pteno2SEw1LzFSZ3hZS3VySWdId0w3dU1QcnpHNlcwcHpVMXZGVHFm?=
 =?utf-8?B?R2ZtVDk3cHZlNGplRVdHQUxUemVveUZwYU5oZ1VadXlnOGRMUnlQS0lYanNr?=
 =?utf-8?B?WDZpRVQvditwYjdieGliQ2pZQ20rdER2NWZXZWpaVDQ3MmI5RlQrWkx6S2ow?=
 =?utf-8?B?Q2lwRjlPTzIyVHBuRkkwK1NTMVFZY2QvTWNoTlQ2K1YvK1U1VDNQT0MyaUI5?=
 =?utf-8?Q?PTjwZjmeLoSzEtWewaLudew9YEV5tl6q+d1JDQJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmVXMmlmKzR0Nkt3QWFFQXpWU1V3aUh0T1c1VENLdkUvRFgreENiSVE1bmJj?=
 =?utf-8?B?anFGUkpObjQxNHJIZXhQd0lxZzRvMnhya1ltWldBY0QvM21rSWpIM3ZEaThr?=
 =?utf-8?B?bzZKZk1WZXpndTFYUlNOV21tUkUxUGhsc0JXWGh3VjBqSnZRUCt6SytwS2dp?=
 =?utf-8?B?UXZ2TmdjZzdqQzNFN0xkWWFqQXBERlNzaFo4SEVJWGFPQVJobnp0a1pLTW5L?=
 =?utf-8?B?S3pDdWMwSCttVG9lVTlxQnpqY2xMeG15NUtxYnJvMVBjNk05OHNtNTJpc0JI?=
 =?utf-8?B?dVFYK2NzS25OU0JzWlZLRDh6azdYaUdUOVI0RzVET1QrUXBxL01uNm9JY1Jj?=
 =?utf-8?B?QmRaQWRqRFJLa1FxWG9tdVdZNVRncnA3MGxIUHZEY2hLZ0NENy9aMmZtNTZ2?=
 =?utf-8?B?TFd1R0VORGxrRER3eWNFcTZHMUFYZnIrcEhrc3lpMHBlM0ZPMWZxUHRnMHFO?=
 =?utf-8?B?WUFoOGVPY3pJMUdndFgzT1lmREhSRVJGSFR4ZzdlZGZNMDh2dDZubWdKdis0?=
 =?utf-8?B?MVM5SWROaEZlUkhuejFNK1RCNGRkY01sOFdCcWU2RGR0aG1SM3hQY2dVYzYr?=
 =?utf-8?B?YmdLNDEzMEFXNEZnNUt2cjFMVWxVQ0Fud1ZHWDQxaDIxWHVIci82VnN0bGp5?=
 =?utf-8?B?M1BJbUNLSWszZ1N5cEdjY05QWVZ1WGNPdE1sZ2FSbENJSzYyR2F2YVNMR3B1?=
 =?utf-8?B?dFh2UkF3emowbk1UL2lqOUxldmE3aXp3cFlMK0s1WEJtNk5PRGJmQkxsS0ty?=
 =?utf-8?B?Ny9jQTFkRkxPLy9TQmQzY042SzM4cXo5Q3FTSDRhVWdmSmg3NUNGdTEwTm1j?=
 =?utf-8?B?VlhtdXVHbW1NNEZRam02TmRxZ2JMaVRnZEFaY2FHU1RnYm9hLzhzS1o4Z2hM?=
 =?utf-8?B?eTkySDBsK21KUWlLWnlSZ21kZ3NUakVFU1NIRUZQdHRObTRCSVVsL1V1TFcy?=
 =?utf-8?B?WnpyV0p1REltSmxoenBIdFBhd2hlLzMwcC9WaGsrQ1lmaU1HK0tRZ1JhblBI?=
 =?utf-8?B?dG9CZ2pEMFNISzJNRnZJWDhVYnNsZ282M1lVYXRlVGlnM2VjcVVzMlZFUWw1?=
 =?utf-8?B?ZXJrT204aGRFeC8zazhZTVdIR3M2Q2VDTTJKcjZmS2o1TVBjMjVNNm9MNzA0?=
 =?utf-8?B?Z3gyR25RSjlhWncwQm5YVnJ1dUhtU2t4Y0lJc3dld3A4VmFxZ3F6Y2N0dmlF?=
 =?utf-8?B?UlFlS2FlSEVtNkN5MU9FNzdmZUpodC9SV2EwZDFRWVZ5TWl4M0k1SWxFVFVT?=
 =?utf-8?B?SW9MRXZHdjRDeFRTT2NPaVZGdnpyNFkrbkp4d3FoZU9peXJBRURHU0d0aXFv?=
 =?utf-8?B?dE1zYUxMSGVOZ2J2NllMdkhtTkJjVVZKYzEyZlY1U1czMXRUWk9Lc2YrWnJG?=
 =?utf-8?B?OE1LU3I4dVNqZm9zTExPRjc4U1FGLy9oV2RmUnZVSmZZNWlWUFNLOTJib2Y5?=
 =?utf-8?B?cVI4aTdhT3ZrVzl2ajRrM2QyVC91ME8yN1dQL1FpbVdDMlRCZ1hIRHZaa2h1?=
 =?utf-8?B?eis3a0pFNHpXZmhTd3lHb1dOMzhXVklKS0VERVpIUmhVUzJyanIvOFU1aGl0?=
 =?utf-8?B?eGplMmZkbGRydnFTYUt4YkRsT3J0bFJQdEp6MHdhSEdLVEdKUTU2Q095WlBx?=
 =?utf-8?B?Ym1KbWpUanlLZlZVcFplUk9tdHhESjB6N3IvTThPVUlTZzVzWG9ZbFcwYTZo?=
 =?utf-8?B?UGQ3NjdJQ1gzL01NZDhwRVNHbm9pMVppSVhrYnR6Zmhod3hJZFRJalpTU3JF?=
 =?utf-8?B?SjFkRlY0Tm1SNXNMalhJRkE0NHJ0dDJUVHJrMWMyaFRyblc2SjFsOXJnYlZ5?=
 =?utf-8?B?ekU2dHpwUlRWSkZSbk90MmV5eHV4U1MzcFN0YlFjYitZMExmbmJyeWw4ODVG?=
 =?utf-8?B?QW8xS3pKWFFSU2JIa1Z5R090cnl3dS8xUHhxbVN1MzBNR3BibzNSdGgrOWpV?=
 =?utf-8?B?bzFMRVJUSjhkTnVTMDdWUVJ0V0tIRVpZRUNjTlpHaUdtb0xsdkFHdHdzSUc1?=
 =?utf-8?B?aTZiVmk1L1dxa0VVa2l6akZ3YWlGQmZvdjIrVllqZDNoUm9mT0xLS1doUWYz?=
 =?utf-8?B?YXBWc2s2QWgyOHJLVVpQVlloWVE4cDR4Um5yMFJOYlhHQ0tYZEFRZ2N1Tlps?=
 =?utf-8?B?Z2EwanVPOS8vTmJ4QVRYZEZyTzFmeG9lUktLd3lNbW0wM0hJUFF6V3d0Qktz?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4668a8c-9a08-404d-59d4-08dc916dcd98
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:13:16.7731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TY2vKrSoCpRVKwUTvG8Fhg6DKRKcksYzdp/vcpbsQ6FZL98o1Jf1GgE6JoPPtmSSCrldaiMf2qtMhxrfKwNBsJBplIq1lZZex/+kNQKs5rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6878
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> The rdt_domain structure is used for both control and monitor features.
> It is about to be split into separate structures for these two usages
> because the scope for control and monitoring features for a resource
> will be different for future resources.
> 
> To allow for common code that scans a list of domains looking for a
> specific domain id, move all the common fields ("list", "id", "cpu_mask")
> into their own structure within the rdt_domain structure.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
