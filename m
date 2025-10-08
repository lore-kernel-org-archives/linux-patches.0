Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3262580D7
	for <patches@lists.linux.dev>; Wed,  8 Oct 2025 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759943564; cv=fail; b=fJq2uPYF4rpDxIletRCcH29V2LxdCYgo3BuICwlY5MojK3XjouMHl0+o7rNxS5u8kF3WiWDF1Z2dNLVuinBerkVz1wRjngW6yPC57OcTTPTPuATFaihC+YDO6Tpa723onYUBKKda2y7F6Ti9WbI8yUjZq0RxqWuPrg+lVvtmdz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759943564; c=relaxed/simple;
	bh=EPBt/dn0TtetXK2jeHmAaduxI7tlUPxU16ta7xWLR1E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NHH57FqMHluXqsQLxdJA/573+GWEHudWIxF/gMbBbvrPI2M44607Egh4vOCXbaTXhpa5XqIglV6zH7gExIeV6Y1tRQ0Po/8WY5xKbmjMy0ovY2gPemcCf/Xre9x5Ccp2wPK1EI2o+YnkHU+3uCR+DsDlXFj1iW91p6gsWm2oEhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQAHkKDn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQAHkKDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759943563; x=1791479563;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EPBt/dn0TtetXK2jeHmAaduxI7tlUPxU16ta7xWLR1E=;
  b=BQAHkKDnZToK7DZh5I1VmAb9KC1RAipSJs+BhlMnkSYytiRtOHe9i4Hw
   iWP5SMTOfWzoaaw8+xiagtwx+V4r2DmNPbEkeKDDZt1L0gR2tScsQrcSV
   LIRIV2oRMqVBDN+UFGuthNFkP7L+rWJ2WV4l+f8CoxCh+kzRjLCHWGkn4
   GHo5UlRBfOTsJA3kIFkBeq+BmGDuMIwJ+OuYJbl9gnzTMNx7SYAuV1oii
   QgXiQDSEL1HVoRjziTWa2fbxDCL0aZquqqm5wA9rR3G4H3tW+UqXInhcR
   keGp7/7MdfJg1AmxZhjaQ4jmpPnxTKg0+wviWVhTn8oqx0eI+yio+VTzJ
   g==;
X-CSE-ConnectionGUID: rC4JLPlfTQSd8c+N/9oy0Q==
X-CSE-MsgGUID: aSE5SSPUQLuBke/pAf4TtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="65996011"
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="65996011"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 10:12:42 -0700
X-CSE-ConnectionGUID: sWSQMTdwSyGP/W3n5OC//w==
X-CSE-MsgGUID: H1XF9s00Qxe1F+b7yyu2LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="180420259"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 10:12:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 10:12:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 10:12:41 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 10:12:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XAc5fUo/SjEN47sK9GSJL+e8lyzcwojlcav937PTnbempd16mw7Itr8ablglLWOn+wwSMMxcolRogeHJVtgvdrb/zAUcavGGXoJ8rzdJ6hDVGSgZksc/68CKc/paTG5YPrmxQ+UALeOvNV6d8FG/QXPQ+8X7ViCAUcBfIdRskUIT9iCiE8JDZ/ziqRdb8h0uWTY7V7fUFMa98UgJrAALT6Z0usQurTy/dIETM8WYK/NZUx5ZgazxuMEv/xgtjV/LXgrgGmoXmXxKeGWL9uh+DYLI8Wcn5NhjkmRQ5cxuyQOkY0WqMxfnGdzeRadMRr4KnavrntaWDhIyeY6UWp7I6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fv1wAkaCKGbXOsDTs4ud4natSAYIR06Id0EgMlDgemY=;
 b=KKSA5XSAjMypAAwJOPCTRMZ35E0xpr4rcZlJ81YFlmqEQjctoQeCwsfhIHleL8qwdNX8u7QwOGz0jidPh6ytRnrltxdqHCXxhPnaMFrshEkiz+sPtxMYyTHZ5/jwvOSn+vDgr5rIN7uvGNILOtpxqpyDhL8r0V1D26NBN0PBFXMhvsB3QhTwaw9+Jx5pKGaXXeun1K2G/vJadhxyaeAkTpuY98AZOde+qRhQ4SHIK34n9GpuySTD/jqPuH1erjmHGO9ZLhOCavQmgTlD851j2UyAzXn/L2Py6MpnK4I2l/um7BS2F544l2TNUKgsdIrO+1Lmhjx4RlQcKgEr3Vrlzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB8855.namprd11.prod.outlook.com (2603:10b6:8:257::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 17:12:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 17:12:38 +0000
Message-ID: <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
Date: Wed, 8 Oct 2025 10:12:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aORMZ6NUXMpECHU6@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0195.namprd03.prod.outlook.com
 (2603:10b6:303:b8::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB8855:EE_
X-MS-Office365-Filtering-Correlation-Id: 922dacab-8ace-4303-8144-08de068de209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Smh2MS9RN09vN3FPdERuR1cvZ0pvQzRYb0x0VWpHdWUyVGNsYWtPL3N0QXM2?=
 =?utf-8?B?cWxnK01rUGtadEtlWC9zRjY4WmZnSTZvM0JjTnJrRnBDOHJjK3N5RFlhcFN0?=
 =?utf-8?B?ZHhXTlFHTDhwL0dBNnU1Q2VhR3NPN2JrWklJdFJkK2tCVkt2MnBpTGlmMUNQ?=
 =?utf-8?B?b0Z2Rmc3T1VDL1lOcDZYQk5iR1luS0tsWkd5MTc3OERTREwveXB6aXBXR3ZB?=
 =?utf-8?B?S28ydnVPUWFkZzJSUisrcHFodFdLd0RVN014NE5zQlhwZms4SlVlZndXeXhT?=
 =?utf-8?B?TlVhd3ZycEJaWG5yNlpKSERkS3Z2OTRBc2FraEl3WmFqV09xNWpXbmR0QjNV?=
 =?utf-8?B?NFc0dTNucFNsV1F2NGZDY0xMSEdJdHg0OFBFMDlOL0p4UngyOGNUYm8yQkxN?=
 =?utf-8?B?L1J2dUlNbGpvWnpZcGVyTjVnZ0FrdjhIbW1HT0JHc0pnVTNKK0dlUGFwaURW?=
 =?utf-8?B?b2xhbnNkV2piR0RTWnFyWm9rVzZWRW1Td3IzdWZsQ1J5eVEyOW9XcmwwRGwz?=
 =?utf-8?B?bzZBcmJjQkVEdlpKMVVvUVJsQXU5VEp2Vkl5R1pid0gvK0ZpZnJ2b3pmMlkr?=
 =?utf-8?B?MFV2cGpYaWVNdUJUdS9BT0FyM2QxemZja1BoQWwvRXRVS1lvSjZkQkV2WE9I?=
 =?utf-8?B?cnZFd1VsdGwramZIUVg4aGhiNzBsSmR3TzJ4MnlWb3FKOVhnME12QlpFbExo?=
 =?utf-8?B?RGdxVmtYdkhxMEwvdHc2TzN5V3FKK0E1NTluTHdJNnJwZXZmdFdrRmFneGRm?=
 =?utf-8?B?ZWp4cTBoRFVhK21SaW5GY00zeG9hcTJWbXZwalcraFpWMk50S2V0YjhsYzdk?=
 =?utf-8?B?WUJjd2NudTVwYzZ3VkZuSTNnNXEvZisvS282OGdDTFBQUGRzVTI0RWtwTG95?=
 =?utf-8?B?OGE0MmhHUWRzTUxCSE0zMjVCbDhTcEZBQTZKR3FZblFKbExFQVJSMUNHUjhR?=
 =?utf-8?B?S2tmWUw4TXcrN01iNjVtMThCa3pkRzhod3VPSE42dHRVQTl1Vk9wZFU1eW50?=
 =?utf-8?B?M0VidVFrUTAyMzN0ZEV3L04rTWJteFNqQmpBOEFhaFhzc1A5NzVrYXZscjJo?=
 =?utf-8?B?elVqT2p0Wkt3dkViYU52NzI0TXA3Uk9sdi9pSndzRUpwNHU1c3dzMDEwZFNE?=
 =?utf-8?B?MGZWUSsrWFBmQng1dHZvd0hkMGh1NkVDUTc4QlozNnJjc0tLTDBRWEFKN1FL?=
 =?utf-8?B?T0xmWGNvL0NUcmh4a3JRVC9hRmpMQXkzN0tPMzcyR0JkSHdxWUdCTUtyaXBq?=
 =?utf-8?B?WWNLNVVkMHJxekh6M0x0L1dwMk9JY2Q5Tk95T1lCTzVJdGZPN1k5WEdQcFJi?=
 =?utf-8?B?b2hwRmVlYnZHTE9xditOUHFpZTlTQkhKU1c1WnJSakRSc0xHQWloZENGYzE1?=
 =?utf-8?B?VE5tN3lkMFNNUFRqVFM4NnAxWGo5Mk1qdzhtbmNFUmpqdkJLT0FhZWJKU2pv?=
 =?utf-8?B?dXJFamVrYXU0b0k0eDZxNVBCWWVZdGNxUXZzdjdabFJ2MlpITmJGcU5xd0xN?=
 =?utf-8?B?d2o3ellSa05rZjRNbk8vVGhCRGxERjQvVkRhZlErVkhkUXQrcng4VXZ1d0Fo?=
 =?utf-8?B?TlZqU2RVb1FKYU8vd3NIcHN2dUxsT2thWGdqRU9aak1SQ0NUYllDNmNZNyt2?=
 =?utf-8?B?cVgxU1JBVnp4alFKWGJSUU10WjNqTDZjU2xhNXN5OGNvWTRJaFZ4K3JHT2x4?=
 =?utf-8?B?RFFJM2pFVlNsdFdGelJVNHIvQXduNkVoYXprNlF5OFFFa1N6MGs5M1QwbjAz?=
 =?utf-8?B?akZjM2Q5VWxQditCbWlsY3UyRUFHSWpVM1ZLSkJndlA4eHRTdDhMNVlWemdj?=
 =?utf-8?B?QkNRc1RzN0JJREgwSnYrdmVuc0YzY0x4bUpOeVNWdXlrTkdjb1RBelI4TGF2?=
 =?utf-8?B?aERtNkhZQ2hqdnlJRWIySmp2VTAwZnB1ZnNQNzA5YnR1SkFsWFVTaDhvMm1R?=
 =?utf-8?Q?bIrkBESBEzVZWx8C+D9TnhH/fH4aIQTL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDE4T0FaWGV2aG03QjMwV25aRFplUFZ0eUtLMzlRRDg0cklYRVZISUFkcWg1?=
 =?utf-8?B?SlZTSTRyY0l3MVJZL3BVM21va2JFc2JBY0pXT1hsRm9NYkIvR2dCT2sza2ts?=
 =?utf-8?B?SGRPMksydEVycTRsNGhRa0ZLcUlOUzBWNFNOL1hwQ1dDK05SZUNSV1Y4OVF2?=
 =?utf-8?B?NkgzTnoyUTBDYnBabGQ2WkxwRFZJS1V1VDVIY2dnME5yenlaTHdmZXhGeXNX?=
 =?utf-8?B?NURXYkgxUmJkcHNUc084eUxmL2dRYW5wemsrZjhIU3l1R2YzOXdQVnFSMWpW?=
 =?utf-8?B?OEdwSXhOOTU0ODRTTERKWlUycXRabktCRVBiaVhZSE5Na3FvZUJlK2dMd1Zj?=
 =?utf-8?B?eHJ3UjNQZWVVdytXcXhWNVIraWF4Z3c0K2NZUGZMcmJUbHlQV2hXbnRKQmhC?=
 =?utf-8?B?RStYNEc5bnBQOVF4R1k2REJMUzNIeCtnNUdSeEs0V3hXa1ZES3N3S2gxemlD?=
 =?utf-8?B?aTA2RldsQkhJNjlPd2JPR0oxdjZFclZuZ09MMytUanhHcjFxZTdyVWJlc3pT?=
 =?utf-8?B?TXZhTW5VdTVLS0haSGJPcGQvZG0vNHAvSW1IS21Oenl3QTNhOHFvaGVGOHls?=
 =?utf-8?B?UnBjN2VEZTV4QVAvTXh0M2RWSTd6NWxSRWg5UHJLbExaK1U3Mi8rb0N6MTZy?=
 =?utf-8?B?QjFaamowL3E1RG5zclBDUyszWlpXcU9FN3pBekIwMFRIejZVUlFNLzVEYWhE?=
 =?utf-8?B?dGFqWG55dkNaYkg4bmM4elRCbUtud1EyMWdkdkpVNlN1eGx4dFE0b2pObmcy?=
 =?utf-8?B?VVVESldpZS9DcU04eEtVS3NLZjN2L3pscWN0U2JFckxtTGJMVjlvd2hyMm54?=
 =?utf-8?B?cjhkTFF1czJESTJaRXdONFZ0Y1VWZ3FqcjBOYVovRlU3ZDFvTGd0eUU0RGhs?=
 =?utf-8?B?UzQzNFdYb1A1YWlkVnR4bmRjbXZ1YkZYY2F2TzhQZGVpVEJzRzR2c0FGUXE3?=
 =?utf-8?B?L0NxdTlYLytHdDhGTWlhYUdkNVVVOFBKSFIvZER1NzArVTFRQ1k4Y2xZNFk3?=
 =?utf-8?B?Ky9vRXhmMzNlR2Z2ZUJmamYwY1pST2d1ZnRIV2lSQXNsWXo3eStFNXZZRFlZ?=
 =?utf-8?B?VkkwNFFaSzRlUmppYlVFTXlOYnEzRSsremlxV0NsS01kYU5wTEdLUjJLQkxR?=
 =?utf-8?B?aFpialIydzJDNGJ2M3lqT05KaTJ5N1pDOXlSVklLSE80cU9iYmFGTitiYzRB?=
 =?utf-8?B?eHhzNFdMeUJybEs2Vy91WElOY1VxS2U4MG8ycmJYMGZ2ZUY1a3diRTYzNG5z?=
 =?utf-8?B?KzdTcTRuQnAyQVVwZk1keGNYZmNmQ0htelVMaHBWVWtiRndMVytTSTFrT1hJ?=
 =?utf-8?B?UTFuWGovUVdkYjBpQ29OenZFUGJteGx4ZG9uWUhyOWdGV0pGUGR4OU5PUWVK?=
 =?utf-8?B?OWFHdFAyQXBMUlhHc0w4WUl6THZud25sakkwMjh0b0F3VnBBZGFYTk1pSGZ4?=
 =?utf-8?B?UEVZejA4M1pNV29wc1NkWnhvTXh1K0xtckFnWUU1NnUxOTAzbmVsWEdvS2R0?=
 =?utf-8?B?ZUh4WmFya1kzK0tmNVpCdFkvMnpMSVF1bmdJQ2pDb3JIS2p5OEEzQ3FweWFY?=
 =?utf-8?B?REVYY3A4dEQyRGp2Tm1PNGJycTlrdVZyUXFWMWRLUytOem03a2dQb2pFNDFV?=
 =?utf-8?B?Q2xJZThjVkd4SS83d2dpNWsyS3ErTlZXdDNOYkxsclZJaGcrMTVlc1phUHQy?=
 =?utf-8?B?VVhHSFBpMDJ3Z0xLd2VqWmVHUXI5SEJ3QWt2OHdXYlNwKzVjMGZiTWw2ZXBC?=
 =?utf-8?B?eUxaeXNnV0JyaTkxTG9ZVkM5Z29HMnIyMXR5R3RqSE82MDRZQlhEUVlackMr?=
 =?utf-8?B?VUhoUGZ1cGtqc2trbldpcDdyOWgxTjdKd1plVUk3bEFRUmRSUEgrN0xGUlYv?=
 =?utf-8?B?RHNjVjlPRFp2QVd5WUpvY0JYdTk2MTBCVnp1TjhWU2ZEbnZrTXExRkhIbERa?=
 =?utf-8?B?bGJiNWJaVzFVY1B2MjZkMXRoNDBCbWxFYU1oUWRURGw3MmpOWEg0Y3NpQjBF?=
 =?utf-8?B?aDhjbXQ1Njh3Mmpaa3VuTjZKSFdRVG9MaVBmRHBDaVZ1OEFxajh5ZjhSZDhS?=
 =?utf-8?B?MlpTQnJ2NnpiODhCNlo3N2RRUFRsMGpZMFA3ZW9FNFZyWTZ5aTJNVWRCdURJ?=
 =?utf-8?B?V3RNS2hybUNsVGNHUzNhNEFia3lsb2IvaXhZWWZyU251RUVFTUJwa3lzeGlW?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 922dacab-8ace-4303-8144-08de068de209
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 17:12:38.6940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wO2HubYRG1NuIOOXvcx9ialMKuCXqdMk9SCzynGCycMkIhPFPukYP91ds4jhfwS3aXmEk6JDL9o3ndeFG3lkTjiHqCNDifxURWp2HS/fX/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8855
X-OriginatorOrg: intel.com

Hi Tony,

On 10/6/25 4:10 PM, Luck, Tony wrote:
> On Fri, Oct 03, 2025 at 04:58:45PM -0700, Reinette Chatre wrote:
>> On 9/25/25 1:03 PM, Tony Luck wrote:

>>> @@ -3253,7 +3267,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>>  		ret = rdtgroup_kn_set_ugid(kn);
>>>  		if (ret)
>>>  			goto out_destroy;
>>> -		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);
>>> +		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
>>>  		if (ret)
>>>  			goto out_destroy;
>>>  	}
>>
>> mkdir_mondata_subdir(), similar to __mon_event_count(), is now unreasonably
>> complicated. Just like in that earlier change this inconsistently adds 
>> RDT_RESOURCE_L3 checks, not to separate L3 code but instead to benefit PERF_PKG
>> enabling to reach the handful of lines needed by it. 
>> Here too I think the best way forward is to split mkdir_mondata_subdir().
>>
>> rmdir_mondata_subdir_allrdtgrp() may also do with a split ... most of the
>> code within it is dedicated to SNC and mon_rmdir_one_subdir() only exists
>> because of SNC ... any other usage can just call kernfs_remove_by_name(), no?
>>
>> SNC is already complicated enabling and I think that PERF_PKG trying to wedge
>> itself into that is just too confusing. I expect separating this should simplify
>> this a lot.
> 
> Ok. Splitting these makes sense. I'm terrible at naming. So I
> tentatively have:
> 
> static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> 				struct rdt_domain_hdr *hdr,
> 				struct rdt_resource *r, struct rdtgroup *prgrp)
> {
> 	lockdep_assert_held(&rdtgroup_mutex);
> 
> 	if (r->mon_scope == RESCTRL_L3_NODE)
> 		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
> 	else
> 		return mkdir_mondata_subdir_normal(parent_kn, hdr, r, prgrp);
> }
> 
> and:
> 
> static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> 					   struct rdt_domain_hdr *hdr)
> {
> 	if (r->mon_scope == RESCTRL_L3_NODE)
> 		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
> 	else
> 		rmdir_mondata_subdir_allrdtgrp_normal(r, hdr);
> }
> 
> Better suggestions gratefully accepted.

It is not quite obvious to me how it all will turn out from here with the
addition of support for PERF_PKG. By just considering the above I think
that it helps to match the naming pattern with partners,
for example rmdir_mondata_subdir_allrdtgrp() as you have that matches
mkdir_mondata_subdir_allrdtgrp() that is not listed here. The problem is
that the new rmdir_mondata_subdir_allrdtgrp() is L3 specific while 
mkdir_mondata_subdir_allrdtgrp() remains generic. I thus think that it may make
the code easier to follow if the L3 specific functions have _l3_ in the
name as you established in patch #8. So perhaps above should be
rmdir_l3_mondata_subdir_allrdtgrp() instead and then there may be a new
rmdir_mondata_subdir_allrdtgrp() that will be the new generic function
that calls the resource specific ones?

This could be extended to the new mkdir_mondata_subdir() above where
it is named mkdir_l3_mondata_subdir() called by generic mkdir_mondata_subdir()?

Reinette



