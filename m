Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEBC1CFB9
	for <patches@lists.linux.dev>; Fri, 31 May 2024 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717171272; cv=fail; b=Cci+IuHP5dHAx1HWuz2viQ4hLuizGvjGkoc2RS02sXYRf2msjKMvv3YmyHzX5eKZaqmEUFAsOO7zrrKjKJKsNZxXXntkVxBRxGsgOAigJ+DpJOegkdsZYPd6uGAGJQMDcGbTwhWp/nDjMpj4zCDaxcSs2FC3UXX1pyP9tvmn1rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717171272; c=relaxed/simple;
	bh=rQIzTM4kcfNaZcy+NA/yysaqgTvewb/cmJ6M2zVfvh4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=egCqr2L6jz5Y2cs05Zinoh2EiO5vlrlbFaOH7Mk4tQNuGvenkBK8m48HMF1Yjw/CqGsCL40fi3/gnyNhdMOB1+Bv/Y1I8g8RkFQ4X7jY3m3NRYwKfBqglIX/4AAFIpddc8PyO2awjhEwg0ASVjtqaELtyzLSt6CgO/7vbjqPrsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bq4SRpsc; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bq4SRpsc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717171271; x=1748707271;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rQIzTM4kcfNaZcy+NA/yysaqgTvewb/cmJ6M2zVfvh4=;
  b=Bq4SRpsc0+BT+4nIHfXoaBceW8TjK0oc8dIqdeyNSk6sA0ShmeHCk5aN
   aNt2slkU/C9LQfBjcNq+U+d4vKMP8DqUWeEt4XzYtrfILi9HaUCCht/4w
   YBdI09yzGE5XOUWFmuYbz4HQopZ4gx7kktp7zlWnQHr/mEA7XdNTggppi
   o/M9r3Kpd5Gc0+KmAejuxnCFI/CZBbljeJ3ysYKTKxEzAnTiF5OiofNf2
   QiDodEnKk+Bwtx9sdk63MuQ/2P2SkLuwbxonfM4qWpu4cJpbJrpRlvxUY
   ac69KJ1QrRXb6O6kgES52e8oF3Ya1i82NHMedv0zlHmT18R3AxemHAQrg
   Q==;
X-CSE-ConnectionGUID: Obno28NFSLizX0tuFtsWXQ==
X-CSE-MsgGUID: GGec1ivSTy+/XMX4I73VNA==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13561951"
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="13561951"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 09:01:11 -0700
X-CSE-ConnectionGUID: 3SGAJ15ZSkONainMlyWGPQ==
X-CSE-MsgGUID: b+hSzC96SBGQKjv8szpsqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="36308284"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 09:01:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 09:01:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 09:01:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 09:01:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 09:01:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPmx8c99zogCUemKbVfayEum75qQ2wVObIit9FNC23dUeLT5kg0fi6g5DDSuRlskSu8GWTOzQ24YmejPZ67aujRCgDvQUk76SHnDw4gTJMF1SIaL1Uf9tCP8SCK2poepXM4qdvSv9FU57hMvbZmZu1mIuPBJ9uQX3XQ1Fsmf7k028JoQAHNzK9x7fGoK9xE3YIvOyYMIlKfPDA4J8X+pjLB09r/MIvHt8Nt8xx8RpZ19do8C9lqwCvfBQZdMv80wo1RA7onoIZzP3MCnEREfy5uHyEPT8T8dOt6KzhlVjDpExiqX6ajjVBQudi7SRCas01KDK+NZOnW/llLFGMyV/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmstawKHDh4npeDaqzLnBLVmSAsjhXuntec6qmLXfgA=;
 b=dnW4ERBQcP+prwz3AT+Kea531LWVDzZfx4mV/0PhR+96BEmPA70MiEOt84qUwVau9fs+DnK1tIkfIoi7MbBER80IbPQh0DP8Iy+gRDleLKArAIChugxU+GNnjqAMnL8x40SWJdyQVH2tovdXFw5o3uA7ECWSgJFJ4zggPERGUVf+Y8u6wMCJPLWs+h8kK4VJMufJ4wqLhn1+jIFvtyK8eTdI7VDQ9gT8BqAcCPQwx9Ij6DRZuFmaNmR9oo6lFv5loJz+e15568NRqT4Wf9Wxdx9SY8SMF9GWpH92M9kgHrxcLVBjxsXBqNoLCrqbTB+6Wnn3MgBeQlCbUU/NttcSkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB8039.namprd11.prod.outlook.com (2603:10b6:510:25f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Fri, 31 May
 2024 16:01:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Fri, 31 May 2024
 16:01:07 +0000
Message-ID: <050c64b3-20b3-4db6-b782-f5124ebaab31@intel.com>
Date: Fri, 31 May 2024 09:01:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 08/20] x86/resctrl: Prepare for new Sub-NUMA Cluster
 (SNC) monitor files
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-9-tony.luck@intel.com>
 <fe9a4cd5-f74d-4c89-8667-8b5b1841b84e@intel.com>
 <ZlkZG5bgsU6hY0Ok@agluck-desk3.sc.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZlkZG5bgsU6hY0Ok@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:303:16d::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB8039:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d2dca1-7724-425c-b474-08dc818ae19e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K2dGd1FIUlVwWDlJcGdBYllwbUpoRlRFTVFWSE4vaGRmdU1OR2NNZDJkOE9P?=
 =?utf-8?B?bmdvZmZXeGFJc0cweHB1QWl6SGVZZ0FsVk1DVS9EY2p2K1hWMnM5WDRVSGxU?=
 =?utf-8?B?dk85K0xLWkt2UUFiUUlVb2JETW40QUlQakFrNTNsbGZtWmxOU09GdjJOWFpX?=
 =?utf-8?B?VWF4WWpvOUd4cUYzUHhZK1VXQVlvYnVKOHF2MWFtV05kMG9vc3ROUDR2bWI3?=
 =?utf-8?B?VjBJSElFUjVTNXU3VTJTRmpaSXdKUk1WcG8xK3d5VldxMFE2WlVyQW96R3BB?=
 =?utf-8?B?VlZHU1A4R0tzdVRGMVlmZ3FtZjl0cjc3ZjdDNWlJSHg5SGV0QTNuU1RRUGJq?=
 =?utf-8?B?MmRwQ3FPR0dlRlk3YmJiclRJTXo1V1o4OFd2cGRhVEtzbEp2RWlrQzFGU2d0?=
 =?utf-8?B?bW0rbkxMakd6QzQzUTdhaldnbCttQWFEV0k3elZmMWFzbndxTW85bkJFV1ZQ?=
 =?utf-8?B?WWpIS2szM3BrbFEyaWQydy9tUm9yU2hnaUVOMXliQ1pCb1hhbWg3TURCekR5?=
 =?utf-8?B?OCtDNitFVFZONWlXWDdOK2FSSzVaTXkxWEkyTXM4R2ozRVQ3VG0wSnhhb013?=
 =?utf-8?B?TmFWb3JvYWNmSjdPZ0tEZURZTjIyREh3dDRHb05XYnAzQ3ZLWGVpcGRUTE5G?=
 =?utf-8?B?TGlaeXBaK0tZRm9yL2Z2VE9sdmR5ajFMckQ5ZmlWdnMwK3Q0TURRaGk2TGRB?=
 =?utf-8?B?blFjTVlIODFweDdTU2FyUDZYZ2RZMU9PbzFvVlZpUm41WFFBL2R2b2xSdFIv?=
 =?utf-8?B?SFMwT3ZMa3NUZUdlUk5wRXNSRjBsYVNNZ3h1V3dCaUh0b0dNdFNwTk1lZlRQ?=
 =?utf-8?B?YkNFaGpQa3hFVmxRUlRXQWFDVTRzSHJXUm5nblBaTUo0eVFIeGdSdjVWek1x?=
 =?utf-8?B?OGxCeW5aSm14Q1o4RXZTY3pBNUdhNk9KZWdRcTVMUkV1dGgyZGpyKzd0U3A0?=
 =?utf-8?B?SWhuV3NWNmJJeEJMMU1za2U1dEJvVnNTb0JYYnhsQm5BQUhRTTFvMmZ4VWxT?=
 =?utf-8?B?NVJpZnZnTE1xMmsxODl1aXJma01qSDJBZDIvYzlscmhDZEZMNmNnMGlPNmtm?=
 =?utf-8?B?QnJQSVhVVFNheHkrQ1RaY2F6MDNSNG1yYWwyRFJjenJtaGY0MEU5Uk1GNVpF?=
 =?utf-8?B?Nlh6SVFSd2FlYUZwT0pyNXJUa2FlNlpzdzZSNUhKOGYvS2xGdTd6b3p4UzBH?=
 =?utf-8?B?ZE5KTUFEUkNuK0UwOUxvSjRGN3VyV0o2L25PQ25SK1VNakR2MVpya2VuZkFw?=
 =?utf-8?B?UDlySmsyYXJwMDFYTWpna2tDb1FXM2Y0d1VPd1h1aUZ4a3l6UmJNOXFaNDVL?=
 =?utf-8?B?R1V3djV5c05YdDF4V1FjSlpISEJQbVFDZnRIcXRlclZreDNjUWNwWjltcFh6?=
 =?utf-8?B?dlIrQ0ZMd1dwVSs3Qjk2Mlhmb3krNDhPL3JxK0dHVDd5M0o0N21UVE5OZC9V?=
 =?utf-8?B?M3c0cVJpeTI5MlN6a0ZUQmpTTlpNQXhraWFKQkR2NFdPSXhVTnE2MWZmSGVV?=
 =?utf-8?B?RTBKc3Rva056amJuaW1HUktEcmNoQXdVSTk4Wnd5YWczODB3anY1R0hoR3Av?=
 =?utf-8?B?djVTWHFGcEhUUzd2V05HQW14bXJFOU9sOVN4NmZZdnpzZ0Nlemc1eXJBRDFE?=
 =?utf-8?Q?lKHGbQjTf7l+KkrNefdIPSVjYnMCN0ZWoSmD2UitHxLc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2xEZlNBbTBkTjduUWpuSTF0eHh2QUt5cFF4SGhTRktabWMzSmg1ZVBrN3VE?=
 =?utf-8?B?eDFNaWRkU2ptcEo1dUwxZmZyZ2w5TGVGMUlZS0YxUmhyeGN6RG81NzBqNFpH?=
 =?utf-8?B?TFQ5dlVTK29ubXh2MFJjckp0N2RDaGROcUtyRXlaV25JYklNM05QQUd0MVIz?=
 =?utf-8?B?dHlBWjBieStBWmpIUDV1UXNUblE2QXE3TGVrK05sYnNSS3lodkN1LytqeHFO?=
 =?utf-8?B?cjgweTVhdTNDVVVXSXFydnFlYmtZWXZmR2c5YjluQ25CN2NFTW1mUW12bUlm?=
 =?utf-8?B?VEpMdkZxbjBCZGhzUjlQeUNLakpaNVZSNCtMSjFMUGVBL0o0Y0ZUL3RFejZ4?=
 =?utf-8?B?aWZWSGZuRDlMUlpPVEpzWFhER0lySEFVaWgvbmtFQUloeDcxTjNPbUdtRGRt?=
 =?utf-8?B?dFlveFNDWkttejloYVl3RnZENHZTQk5NY2Q1bDBiY3hMeEY2SWNwQjlCU0xn?=
 =?utf-8?B?OGV3Y2o1RlhUWHkxcXdyR1ZlS3NpZW9DZFpnMlZJK2VZRDA2Nm04T2U4T25L?=
 =?utf-8?B?TC9zRDJ4NHlRVU9RalVheW9RdiswNDBIcVk0eUlTbmZIUENIbTNOK3c5VnpC?=
 =?utf-8?B?ZjJySVJlL3VZbGpvcHROSEZxNU8xZlA1K2xvelA1YVJBUXprL1M0MXhtM1Nq?=
 =?utf-8?B?ejZnVXRwWnkyVWhIQnpMY1E1MmxmUkFhczJJVm95T3BsUFJ4Tm9xMDNrL0tq?=
 =?utf-8?B?TllEa08rZ0MvYm1XQ3huS2tFc0lVeDNmdUc0SzFTdjBHZ0hpQ29ITDNtUHhi?=
 =?utf-8?B?YzNMay9LR0J5bEtzci9mM0VJNTNraUNoOTEwTC9oNUZuSFRPcGtnQkRjSzl6?=
 =?utf-8?B?eEVrMGZEQXczaWRQdGNLOHZJdjF1TWpBejlhVTZsRytBLzQ2VFpqRDlYOXQ5?=
 =?utf-8?B?UHVtM2h2dXBDQ2gxMDRLcnBSTlVOSU5hRVFzcjc3VHB6bkx1RE5WWmNpUERr?=
 =?utf-8?B?VTRqMCtDS1U4c1QyeFFMUnBnd1ljMklxTUlOMzI4T2EvdWNsY0xVcmhycE1m?=
 =?utf-8?B?ZGgrS295ZGNHK3BWVE01Ri9KQVdyVWNkZzlGb1hVZng3UTJGMEFLVk9heHkv?=
 =?utf-8?B?TUFDMDZpTmEvajFtV3lITkQ2M3pXQUhzd08xeHNRemRsRnArQmRNZm4wZXVD?=
 =?utf-8?B?SDF2RDIxazY0OFBNejFjQVRuQnJRTVpHeXo2NlVIbEQ1L1NzSStTYlcrL3gr?=
 =?utf-8?B?OTl5Q1h0anBiT0dTb0pxNVVJb2VOTGFCU1F4cW01KzNwWWpPdHVPUHY4V3N4?=
 =?utf-8?B?NW9NSmV0M1lWdXQyV1BsSnVvaG9DSDVNVDdFRXRsdGRzMFIzNnBEcVJmMk40?=
 =?utf-8?B?TmNhWnNidGxOWHBacDk0Tk9TZ0IxajF3MEd2aS9IUVNDRVI1Tlp2eHcxTGg2?=
 =?utf-8?B?d205ZlRTZVF1L0Nwa3VSQjhuMzJzK3AvOUlhdVNudFhNYVgycVI4ZktQU1lM?=
 =?utf-8?B?QWYyeVV2ZzQ5Q1Q4S2VpbFR6UWRGTU5uakNwZzc3anZJUXVNL0EzRGNmTVBW?=
 =?utf-8?B?Q2FVZWtBWUs3aFFxcjMvZFhScXEvMUpYWVJEeFVRSmhpK3BGdmtaZ1g4UGNK?=
 =?utf-8?B?cWRrc2dpYVJtWkZCY1AwNWZIa0pZc2ZZWGgwMDlwMkQrMlNyaGNyYlpWQVZr?=
 =?utf-8?B?c2JNQ0JDaUtIMFVYTlVNUGhKT2xwWWFJSWNCa3ZqQVZSMy95Q05vaVdCSnV1?=
 =?utf-8?B?M0x4b01TL3o2cmhXVkpYTlpuWU8rdWp4SDhQTUJjUzdBNFBIbENUbTU2Nngz?=
 =?utf-8?B?VUE0aXRSdFU1Yy9sOTF6bTdkTG9rSDg4SDh4ajVuK3h6OTh5R0RURVcybDRv?=
 =?utf-8?B?ejA0MEFRTiswNno2eVVrK0RwYk8xMDFwaE8zUGY0UXhtdmpUNWUrSlZibFdo?=
 =?utf-8?B?MEdvTjQ1UFRBUnFSY0trb0dzL0l6clR4Y3ZJbmNEZjhmZWxGNDVYcVBSZTJr?=
 =?utf-8?B?U2NaOFhLdUgzd2NGQWIyRCtaNGN6NlVGSWx1TEQ2ZWdrcWRWd1pleHdvSjVo?=
 =?utf-8?B?TVB5SGdwRjVSUzVMUWVDdFhpQWFheXhKMTlmNGhKdmVXa1ZYeFBSdmVrTHBk?=
 =?utf-8?B?UWkxMkRROVovZkpFNXVZTVRWZ3pPYXk4NENtMTdaUmVtNGtVY2g1ZlhHNlVn?=
 =?utf-8?B?dFhOY1NTQWc5SDlPNFVBbTlkT0NGUlNpS0NCd3ZDcjJLbkdnNVJjRnJBcUFK?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d2dca1-7724-425c-b474-08dc818ae19e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 16:01:07.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkKo7yiHk50lF04I6r1TuBDg1tSASa0ZTswlGP0YIDYcl2fp1EhzT10aAT08FVoGn4AmkOhGwlbLZMFhCt9uPlpe92p31I+HiGv9RPXa1zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8039
X-OriginatorOrg: intel.com

Hi Tony,

On 5/30/24 5:26 PM, Tony Luck wrote:
> On Thu, May 30, 2024 at 01:21:01PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/28/24 3:19 PM, Tony Luck wrote:
>>> When SNC is enabled monitoring data is collected at the SNC node
>>> granularity, but must be reported at L3-cache granularity for
>>> backwards compatibility in addition to reporting at the node
>>> level.
>>>
>>> Add a "ci" field to the rdt_mon_domain structure to save the
>>> cache information about the enclosing L3 cache for the domain.
>>> This provides:
>>>
>>> 1) The cache id which is needed to compose the name of the legacy
>>> monitoring directory, and to determine which domains should be
>>> summed to provide L3-scoped data.
>>>
>>> 2) The shared_cpu_map which is needed to determine which CPUs can
>>> be used to read the RMID counters with the MSR interface.
>>>
>>> This is the first step to an eventual goal of monitor reporting files
>>> like this (for a system with two SNC nodes per L3):
>>>
>>> $ cd /sys/fs/resctrl/mon_data
>>> $ tree mon_L3_00
>>> mon_L3_00			<- 00 here is L3 cache id
>>> ├── llc_occupancy		\  These files provide legacy support
>>> ├── mbm_local_bytes		 > for non-SNC aware monitor apps
>>> ├── mbm_total_bytes		/  that expect data at L3 cache level
>>> ├── mon_sub_L3_00		<- 00 here is SNC node id
>>> │   ├── llc_occupancy		\  These files are finer grained
>>> │   ├── mbm_local_bytes		 > data from each SNC node
>>> │   └── mbm_total_bytes		/
>>> └── mon_sub_L3_01
>>>       ├── llc_occupancy		\
>>>       ├── mbm_local_bytes		 > As above, but for node 1.
>>>       └── mbm_total_bytes		/
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>    include/linux/resctrl.h                   |  2 ++
>>>    arch/x86/kernel/cpu/resctrl/internal.h    | 21 +++++++++++++++++++++
>>>    arch/x86/kernel/cpu/resctrl/core.c        |  7 ++++++-
>>>    arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  1 -
>>>    arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  1 -
>>>    5 files changed, 29 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>>> index 64b6ad1b22a1..d733e1f6485d 100644
>>> --- a/include/linux/resctrl.h
>>> +++ b/include/linux/resctrl.h
>>> @@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
>>>    /**
>>>     * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
>>>     * @hdr:		common header for different domain types
>>> + * @ci:			cache info for this domain
>>>     * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
>>>     * @mbm_total:		saved state for MBM total bandwidth
>>>     * @mbm_local:		saved state for MBM local bandwidth
>>> @@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
>>>     */
>>>    struct rdt_mon_domain {
>>>    	struct rdt_domain_hdr		hdr;
>>> +	struct cacheinfo		*ci;
>>>    	unsigned long			*rmid_busy_llc;
>>>    	struct mbm_state		*mbm_total;
>>>    	struct mbm_state		*mbm_local;
>>> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
>>> index 135190e0711c..eb70d3136ced 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/internal.h
>>> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
>>> @@ -2,6 +2,7 @@
>>>    #ifndef _ASM_X86_RESCTRL_INTERNAL_H
>>>    #define _ASM_X86_RESCTRL_INTERNAL_H
>>> +#include <linux/cacheinfo.h>
>>>    #include <linux/resctrl.h>
>>>    #include <linux/sched.h>
>>>    #include <linux/kernfs.h>
>>> @@ -509,6 +510,26 @@ static inline bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
>>>    int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
>>> +/*
>>> + * Get the cacheinfo structure of the cache associated with @cpu at level @level.
>>> + * cpuhp lock must be held.
>>> + */
>>> +static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
>>> +{
>>> +	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
>>> +	int i;
>>> +
>>> +	for (i = 0; i < ci->num_leaves; i++) {
>>> +		if (ci->info_list[i].level == level) {
>>> +			if (ci->info_list[i].attributes & CACHE_ID)
>>> +				return &ci->info_list[i];
>>> +			break;
>>> +		}
>>> +	}
>>> +
>>> +	return NULL;
>>> +}
>>> +
>>
>> This does not belong in resctrl. It really looks to partner well with existing
>> cache helpers in include/linux/cacheinfo.h that already contains get_cpu_cacheinfo_id().
>> Considering the existing naming get_cpu_cacheinfo() may be more appropriate.
> 
> Reinette,
> 
> The name get_cpu_cacheinfo() already exists and does something different
> (returns a "struct cpu_cacheinfo *" rather than a "struct cacheinfo *").

Indeed, it is even used by get_cpu_cacheinfo_id() as well as a few
other places in resctrl.

> 
> How does this look for the change to <linux/cacheinfo.h> ... add a new
> function get_cpu_cacheinfo_level() and then use it as a helper for the
> existing get_cpu_cacheinfo_id()
> 
> -Tony
> 
> ---
> 
> diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
> index 2cb15fe4fe12..301b0b24f446 100644
> --- a/include/linux/cacheinfo.h
> +++ b/include/linux/cacheinfo.h
> @@ -113,10 +113,10 @@ int acpi_get_cache_info(unsigned int cpu,
>   const struct attribute_group *cache_get_priv_group(struct cacheinfo *this_leaf);
>   
>   /*
> - * Get the id of the cache associated with @cpu at level @level.
> + * Get the cacheinfo structure for cache associated with @cpu at level @level.
>    * cpuhp lock must be held.
>    */
> -static inline int get_cpu_cacheinfo_id(int cpu, int level)
> +static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
>   {
>   	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
>   	int i;
> @@ -124,12 +124,23 @@ static inline int get_cpu_cacheinfo_id(int cpu, int level)
>   	for (i = 0; i < ci->num_leaves; i++) {
>   		if (ci->info_list[i].level == level) {
>   			if (ci->info_list[i].attributes & CACHE_ID)
> -				return ci->info_list[i].id;
> -			return -1;
> +				return &ci->info_list[i];
> +			return NULL;
>   		}
>   	}
>   
> -	return -1;
> +	return NULL;
> +}
> +
> +/*
> + * Get the id of the cache associated with @cpu at level @level.
> + * cpuhp lock must be held.
> + */
> +static inline int get_cpu_cacheinfo_id(int cpu, int level)
> +{
> +	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
> +
> +	return ci ? ci->id : -1;
>   }
>   
>   #ifdef CONFIG_ARM64

This looks useful to me from resctrl perspective. Having it can already
benefit resctrl by replacing the open coded ones in pseudo_lock_region_init()
and rdtgroup_cbm_to_size().
We have previously [1] been able to include a cacheinfo change in a resctrl
series by clearly identifying it as such.

Reinette

[1] https://lore.kernel.org/all/20200708163929.2783-1-james.morse@arm.com/
