Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB8C135415
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 15:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740343; cv=fail; b=rzS2UelOCtpVGqsYRKHpQy7IzoO0mqVGvadg+EP5U8dZSgZ9aIflted+y0nlHzR3OLcLyH0eB3mILrxHUFBvFqNjthQfn8tBwmB6GB5nBFfXP0qVb9IstqpMCjOwoW0UEzEA7JMC537um4k1dY9LDIKBmDO1654K1uZsMj4q0hQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740343; c=relaxed/simple;
	bh=2AhIblw7F18dwPuWfWPNpBUTsNynvYmlAQ5K2qKmutM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b7T7DAcuUfCkQbGDT95Z5gmzgzCfmbACbf/u2kWlaXFQc5gWXlh3GwGkXMBRcLjoGVk4VvHRaf0LD6EoKp73c+3mtn9MCt4RiqSuHGQZgMuNZFPgwONbr01+fHmFAmmOOEOClk6bXnK4/QtIREoaxRy1db7uGpB2uS+eO1kEQyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ebVfoxBK; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ebVfoxBK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709740342; x=1741276342;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2AhIblw7F18dwPuWfWPNpBUTsNynvYmlAQ5K2qKmutM=;
  b=ebVfoxBKlhH3/3GJtt6GmDVDQr9fhZrMF1fPPp4wAMhMuxPkc0WVaNzM
   SgmwjavR+ZAjk/RTINMtvZtrwvBfcil1+PmoBTJF/cC0Cjl+6Ri9gq+Ka
   FcUlZZDxyXhRhkKWKRaajB1wx8qLGdVKe9wZKxDuvrEXufCWfitoYJllu
   Zt/3ppx/ScYOz6ukLng70GoQyXV05beDhGrJHM6LQoXG42Q2+qCT/8o4v
   A+Qup5X+aXY83yEHdN+jnhcgYfMDNg8DbMJiZtiwmkYNufnSsZIcOURZ1
   7bBCXaafHM5RlvGB7CyxS6L35Brqf1wt4TNNWIO+ssa4FVS93j5mfVZHB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4223419"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="4223419"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 07:52:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="9664367"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 07:52:21 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 07:52:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 07:52:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 07:52:19 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 07:52:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRWH5gTcD+puFJU/GtFNFGWicKjos0hbNNmG8SRM/jW/Iw7W9l8FwUDWHGogq15XJWQ7xmxaH1bbppCPEIjcM8koQg6ttacLJ4RZJDFd6oedZkyojAkJFoFwAJNPafTuTGt/s29UUfDqjaFaATvwbCVrNEDti41+HOteqxbFccs+JHGt0xFYYX19t9vRshaTOz8vtZTdmOLZ0EeJnbM/JrMbZT0L0jX0bVCf+y7SO5VXmbVNdME0LZi9+SJlY9xQE5lMdpIQbRwapOA5yAuRsK2Ilc1DIZ56k/R4fv2eJOxzE+iS14HOG6SqqcwDGKCM412x1vGjalRVn8b/fkblfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFmTOyrYgQxkgSiThOu04KOQAfeDykbJ+m/QDjkvaVc=;
 b=ONFfDJtxENaaZUXXQLf7VCe0L8dAPk7yjJWiadUsk/4r4iwjlt9DnlK/AR4vvL4nMtel9tCxoPGFkzoyu6d17EscWSrhxRgQvDFlID8r4XtQ4VjDEOjpK3cybvofbAm3P9ZpHJj/yTQfGfftjtJ+RKxjDpW2dKM4RkoNn5vz3DjiR4dn/UAYozlI4w7IGgnZde4d5/azb7gSE/oh5M/NC7RZVsqAZZkm5t7F5UACvCffh9QC3pZcOwxPTBT+KXXxTwpT4mK99i/iH43YTmDLpesiBHYm2rveRGugU1imki4KNxKbw3p41oih8O1W7IGDHStiGBt3rMnODgviduc6Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by SA2PR11MB5049.namprd11.prod.outlook.com (2603:10b6:806:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 6 Mar
 2024 15:52:17 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::f082:826a:7761:7aca]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::f082:826a:7761:7aca%2]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 15:52:17 +0000
Message-ID: <a5eedd1f-3a26-44f4-91a3-3d0c1ee0bb3e@intel.com>
Date: Wed, 6 Mar 2024 16:50:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 128/215] x86/boot: Robustify calling startup_{32,64}()
 from the decompressor code
Content-Language: en-US
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, Alexander Lobakin <alexandr.lobakin@intel.com>,
	Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jirislaby@kernel.org>, "Linus
 Torvalds" <torvalds@linux-foundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
 <20240304211601.130294874@linuxfoundation.org>
 <E57FF738-3527-45F3-891D-FD54E6E7E217@zytor.com>
 <2024030523-parted-situated-8749@gregkh>
 <5F305A61-B247-4C0F-B220-633504C72774@zytor.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <5F305A61-B247-4C0F-B220-633504C72774@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: WA2P291CA0045.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1f::19) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|SA2PR11MB5049:EE_
X-MS-Office365-Filtering-Correlation-Id: fa2934c6-74bf-4b26-adf2-08dc3df5661d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CjMb+QeiJk1+EWparKlduONpyH/vq22XhND19nYQK6NRm+jHiyZQC3COaRJc5I/ovupq8e6l1TSWq2XbYpVsbS3gLP/JOHE1VyP8U/hyK3I0UgzSLrX1qjobRrL+/tsyU/NyT+PIghrcIKPjrSHT5zIgakneFD39QdX3aSNQLbLSzWBaWqqyj4fM1iIgPwNkJKmrnC7qwlki5NM2r1bcTr2l13ew9/0shPwZy4K1LPIoTS54QlpqUbdveKCMvzsWRPh2T0WO0iRAV7z5t2KdhoAmqShcKm6S89g4ikQhpL3hAKBSzEfnzw4T/y4n80vsXbPmm+OLaMmBY98+j4QKXdQXEKNWO8OlgeiLjd4WiV6GHmDOJWaJNcjuC0mQxBOhwruKUlDKVLwRh+mjV5CM3bWafqfZ9qa79z4tA0zNoqIL7JVmjAMC+u2Fm1/K5HbOB1SEOEE3ynbTuppw5xO52XZ8ttBCAtHK6vh/8RQs7S+awXgCrFS1xXS2+c5Jcb2sNqjRTpZdb6y/yIqRIbJ/u3stCH4UuyBLi7oHBafF4zqIqdp01nV1BNkQo6ITtYS77I76JSsy0pSEj5IU1nzoUFLNXDAHHFg9Dmk1oCSTrERKDI0wQiDCd8+QYxbbH75gf/a3go50V+kfFscqubef0To2+bExy1QhSzQ4b26Zpos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVRrdGdoTjU5R3U2Rzh0ME84WkJJRGs0MmdUb0VPZi9waE80ck5tMmhKZWtj?=
 =?utf-8?B?QXh3cjU0emVMUnpnY25JbGJxZGVDeEh5Nk5yR1FaQzdiR25sTUdneGp4TE1B?=
 =?utf-8?B?WWMweW9YNzQwVWdLN2FXcDVHbHdlcURTcjF0djVjbUtSYXArS3p4NmNJYUo4?=
 =?utf-8?B?QVd1ajhHY3dTUWRsS2dkVDZTL1IyZldIck80UVpMVjdyK1ZsRW5ZNHhHWlk4?=
 =?utf-8?B?TnVIZEdQL0xkdmtYWEtnTDhQZmwxS0lEVTBHeGx3SEVHZjF1Mi9LdFZweWs3?=
 =?utf-8?B?c3h1T2pDYklLaGxzWXFTTGJkQUVIUW81QXBWdmljNjNHRWpvek9yV0NRenh5?=
 =?utf-8?B?Y25GZTZLQ3QwZERwNTBoZnlzVk5uQ2xwaUtlakNBa0xvWkdVSWErZThyeUNa?=
 =?utf-8?B?cHNiN0ppejZvdWxZemxybVZGM2pUTzhNK2lITDNkR3lmZUlGQVcvRitxRVBo?=
 =?utf-8?B?amNVZThodGxEN3ZOZlBBMlVuQitraG5lclV4TVI0MTRVRG9JbVVoUzB4VDdK?=
 =?utf-8?B?R3BibzRieGFUbXYwSzFSZFVzM3dNZVRXMnJkK3MrMU91djdDMHkyU1pMWVkv?=
 =?utf-8?B?eFNJNGpDZUNWdmFPQ28rYjRoUmxWVUFLQ0cvQ1ZxYUpDbHpFSWQwalhHR2la?=
 =?utf-8?B?TFUrTjJWblVhZDNLeFJ5SURvZVErS3hrTGxTRXpUQnVqRU85Qjk3WmFDbzNW?=
 =?utf-8?B?WFhqcGRFMHBmZTY4QURDeThuVEQweGw4WVljL2lsZ0VhYWhWc3NDTHZoL2o3?=
 =?utf-8?B?aElIOG1iODNEL0RTVCt4MlREYkNPR0ZIemFqM09mMXVzc3ROMnM3ZXJOOWVm?=
 =?utf-8?B?VGFHcWMvSlU5cVdXR3oyUk9DYTRVQU9JNURIcWNvV1JRSzRjNnNVazRmbFJi?=
 =?utf-8?B?R0NPTDM5OWZBc2hiY0hrdDl0TWF1K1B6aGFTNzlTODFNS0QvU0tLTnRQWTB3?=
 =?utf-8?B?cEpudWphaHkzRERYTWowREI0Z0dEeHJoQ2x5MjdaWjJrWW1HWENYSVI1Nk9i?=
 =?utf-8?B?QnVuT2VPQmZvSWs4YzB3clhXc0NGNGRQQzFHenpOdDFuaGVzSjlSa2UyV1kx?=
 =?utf-8?B?SlB5Mk5ZdkhlZUpBY1RtWW9qRnB3VTYzN3prTEpsL2xYSlRpK1g5eHl4Z1R4?=
 =?utf-8?B?VWhIM3BFRGdwUkNJNHJjTkdNTEE5Ym1Xb0lSNHpjTk1mUVNrKyszY1cxUGo2?=
 =?utf-8?B?WTVjT2FrckR5ZFFkZWZ3YURkK0ZFVU44YlpmcVdEMmtXMlF2TTlmR3dNdkgr?=
 =?utf-8?B?dFQ4NzNmY1V4M0JMQzVVdEI3VEM1V3VUWWFkMk1PeEhyQUtRUTREcE1xUUdn?=
 =?utf-8?B?MWU5ZzRPQ1JmZUh6TjZQNWo0M2pqVTJmVnVRZUQ5WHF6cWJsSTlCS1JtUmpw?=
 =?utf-8?B?SXlydEFuZ3piVW9Wdll2VlhGdXRRS1ViUGdOY1FYQTFibGVEK1BqREJkODNt?=
 =?utf-8?B?VUxVai91RmxhWllzMDBQcUF0YmM4T0pYdU1nNytRaWo3MTJnb09ScG9XQzY1?=
 =?utf-8?B?cEFqZk04TVVLNkpZT3lISXYxNHFUVU9QbGNMTHg5Mlk5Q3FsZVR6OHRpWUFr?=
 =?utf-8?B?b1l6VW8rZUZBbHU3THpyaTVkaGdyMStLWTJPa3cyK2dJMFQrcy9veS82NUlv?=
 =?utf-8?B?MWd1OXhrN1dJdUtSVHVUYVgvR1RWcHBEYmZrelVhMXBLR09VYUFJWldLTmFp?=
 =?utf-8?B?ODZncmlRZkFIQ3V6aDFSaGk3TXVCS29helFLT3BTVmxGZHFOcGpUSnB2UmY5?=
 =?utf-8?B?YWpFNmxtTlBGTkpSM3dCbDcrK0lBS2tyQkM4dlBmdmhNWWFlMXh3NW1rWHdm?=
 =?utf-8?B?cEdjclkvalRRcHViQlBJNGxxUFBTNHl3SFFoekNuTVRKaE1JMjVXOHl0cDJK?=
 =?utf-8?B?TWY0QVdOdWNCZy9Bd3RZUnNLM1ZyMGt5WUhLdXpySis1eVRZYm5KckNJTEdL?=
 =?utf-8?B?S3BiYnhkamM1SjFWR0kwVHc2cHZMMXp2WGlBczJVMk55RlhTbGlNa21nejFP?=
 =?utf-8?B?WGg1MDFrT1BpMURNVGYxcStnSVBHOG9MUUtvSXpwL1ljMkh6WXdzenB2ekhD?=
 =?utf-8?B?UTZ4T0MyZjBjQUR6bkVIRU9FYW9QZFg2K09XclhwR09CcXZiQ0pNQTVHTEk1?=
 =?utf-8?B?a216NzJLald6TU9jWWhBOHVlYVorWEt1QzhDVzZaV0xESFI1NUtuWmhORDFt?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2934c6-74bf-4b26-adf2-08dc3df5661d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 15:52:17.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4TOrgZGjHlPPYT1KDD6oAREo8cetsjAs95G9t+gYLCeHmYmD85c2YWwF+Fs6nTzmnRL2Ff7UOmczOS06L6DQUwskz6e/ffsbRH8jRa5Pas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5049
X-OriginatorOrg: intel.com

From: H. Peter Anvin <hpa@zytor.com>
Date: Tue, 05 Mar 2024 07:39:06 -0800

> On March 4, 2024 11:36:53 PM PST, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> On Mon, Mar 04, 2024 at 02:42:35PM -0800, H. Peter Anvin wrote:
>>> I would be surprised if this *didn't* break some boot loader. ..
>>
>> As this has been in the tree since 6.3 with no reported errors that I
>> can find, I think we are ok.
>>
>> thanks,
>>
>> greg k-h
> 
> Well, boot loader breakage in the past has sometimes been reported a year or more later.

Could you please draft a possible scenario where this could happen?
I'm not able to do this.

> 
> #Pain

Thanks,
Olek
