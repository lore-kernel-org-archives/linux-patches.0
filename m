Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D98E545
	for <patches@lists.linux.dev>; Tue, 10 Jun 2025 00:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749515456; cv=fail; b=UPRrD+o5cgoVRoOWXxfULhjiShkL8FMz+EQMBSiodkWrc05aZlDAQz01SNn/MH2OpUCfj0PT7//t+2RG3XYqqOVJBnQz8y5Htdo977HVBxL9xM8RGX4goJxX1HroZPx+ykZSNF55ZpUNPJvYqe5VCJrSPQYqYstMz9UZINtJyVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749515456; c=relaxed/simple;
	bh=z72oVktT8qBZKas8Q2lMNEO/LhpepVI+FTnSH2XJoI8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HqkmQrnia6VMhauIe9f2/a3LF33REUuo43SF4/B36DQG4ZF3F8zFiKpXhVAj2RjnpoD0CLBbOAMcGogP/ob5RUMTOgbWS5SD7c1ZnsM9xosbK3/CYD2oLd4hyPbwdp8+M7lc+x+K4mNlnhgvSRnT7qsAAILiC/pauRogRJNQ+0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0o4tLhH; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0o4tLhH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749515455; x=1781051455;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z72oVktT8qBZKas8Q2lMNEO/LhpepVI+FTnSH2XJoI8=;
  b=B0o4tLhHrzFWhvVmCxTg9Ku5vQiczyUpN8S6INYRNTmr3A2j+PD+oxul
   b4sPu5LZnZAKnPHijQymMOa/WD2MgSo91h6QWmXooXMUmvWSUdmmJnkeO
   zoGk0JJ8s26myrzAOpkdjkDIfzOmmxSJhaKWp1y7471K0wQ9SGA/yBm4B
   tVTQH8+S2ks/p9xkSFK1+aIn/vPiLxFJ+sUTr0HzP0vqPpNgFtWW89qGu
   gef8DnfORP2BNWSLqbsVMJyu/DOci4WKkYARiCrsYAuQo6w9GgRcOXoKv
   ykoJyZhmFNZszjKiWl5H2xBC7VP2+2m5F9aHnMTncYcSNHjKdiQpcC5e1
   g==;
X-CSE-ConnectionGUID: XdaerxliQ1Co1k0QnbklSg==
X-CSE-MsgGUID: OKf8U4KIRt+ZarC3wlFsQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="63013624"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="63013624"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 17:30:54 -0700
X-CSE-ConnectionGUID: TS4RJU0ZRfS7vHvmfuaG+A==
X-CSE-MsgGUID: W15F0j9jSvK38iriYELL+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="177600190"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 17:30:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 17:30:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 17:30:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.85)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 9 Jun 2025 17:30:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gTvzy0r11Yl5eXoC+xaqFN2GzAYU0cy3pC+29RCq6eE7XIqQyqB/9PPv0qJZNOvx4vnc/Q3XeUbW//qzBE6h0iF1VPhgCJoK+GFI3xSRaRf58vuOURsSxnfDSFTgLmX33cTrdxdfIc6T6LfuAWnP5t46lXQRe920joa2hzIYHCAR6XNBU7bJGa3r/YjnS3w8FWgno/D6cBpBLkx6BeGL0Vue4DsAxpy1V7mY+utI/PuR/utCCbHrERmK71Iu74uJA3mCPq+iG2pzxyj/f5TQOgjIDy2cnsbBTk0WimjgIKQoZ4RbtmmdeK4o45Jug/+mBUAQrJVq+0HrprPcHy7PFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMCXs8dHBvlyNmdtvZo1MyDJS9r4hRUz3TELDUTLOE4=;
 b=B1sDwGPrgYgP1OkxwZSIGOY6TICqHSv1kDsrOyXox5oh1ClICXcbVlmp9mHOdZzTph4qErg1fCiwyK00K6C9LusVNuG5W/TU0H92MhXky9PCcKDRyqtYk8pXcnDPgZ79iGKhsYjKSsE2L8GJ5vKvQC9M3nb/3+oDaAdPjVbkbC+JWjpsbmaM/HDGvGtCeFEhSBUDsTNh0GmeUcBENo7lmh2j+zVFWuIZAwdE1ihI32NPXVJRLDDDwF6hd1xm541rYrxMgZ5gws1/Om9mvy4t02wmCIHtNpx1OGlGHLFPR7V6QHR2ZaoG4eA1DFZvFhou9nD+zmWt7yc1H1hMnUw45w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL1PR11MB5221.namprd11.prod.outlook.com (2603:10b6:208:310::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Tue, 10 Jun
 2025 00:30:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Tue, 10 Jun 2025
 00:30:36 +0000
Message-ID: <71a51672-4cc7-47eb-bbbb-a3195189becc@intel.com>
Date: Mon, 9 Jun 2025 17:30:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, "Chen, Yu C"
	<yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
 <aEIxzbuFybLBE3xt@agluck-desk3>
 <9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com>
 <aEMlznLgnn6bK9lo@agluck-desk3>
 <d2be3a4e-1075-459d-9bf7-b6aefcb93820@intel.com>
 <aEcsxjWroliWf3G0@agluck-desk3>
 <fb2396c1-3799-4d45-ae24-ce7e6f0d42e2@intel.com>
 <SJ1PR11MB60834D5E5D78CE229D04204FFC6BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB60834D5E5D78CE229D04204FFC6BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL1PR11MB5221:EE_
X-MS-Office365-Filtering-Correlation-Id: 4231e7b0-1e50-4ac3-44a0-08dda7b604a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YW92WGZKaWY2b0RoVVExS3IvaGhBb0xsSUhkdm1adlR1QmhGbUF6Q2o1MFRy?=
 =?utf-8?B?R1VpdU5wNkNWYlJwMmw3TWJIQkhGcjdtSmVWOGE3VU5MM1piQS8wUW4yNEw0?=
 =?utf-8?B?THRiQy9RWm1DNmUxSENaMUJFSmlzNEJXNytSc3FwT1pTLytmZ0JxVWVNYnJ4?=
 =?utf-8?B?SDByMDlOTmVDOHVjS081MlBVcEJoa2RidFVRQXFHNW1jelVObFZwSGJrM0tX?=
 =?utf-8?B?ZE9sWG8yYS9xY0w1NGNRemlQL2ZHczVxZ095YldTTzlxOForWkFtSlkrajVj?=
 =?utf-8?B?eFNJSWo1VndGN2ZEaGxuNnMxa2lleFdBSHlTSHlHTWd5cXAvSlpDWUZrclNv?=
 =?utf-8?B?NDVoVkFXLzRyOFdhMXYyWFZGSDUycFI5QjJYVytoamZUelZDbkorL0pnaHNM?=
 =?utf-8?B?cThHUmxacEt4bFEzeEY2bHRjb25PWXdZN2xubkJMREhVWi9WRm9QYjVxdXpP?=
 =?utf-8?B?ZnNubWNTWGJUSEsweE9SN3dYemEzNjJHK0MrU2w3ZnpDOTZ5SGQwQjRhVU9K?=
 =?utf-8?B?Q3R4dVZjd0MyVzlvTUkvdmVVcXUvQlpLTS9kMWM5SVR3TW1RSkVOQ3pYK1hr?=
 =?utf-8?B?TndxTjloazI0SXdMTFJVbS9NT0R1YkZ5WlVpYjFXWlBienhpSnNucFd3Yzh3?=
 =?utf-8?B?Ymw3V2tuYUNUVVZzSmdRQWFTWTVsamFUOXpkL3l5dmVsV3JwY0pzT0tRZzla?=
 =?utf-8?B?YVVtdGpEeVZtZnZCb3hLU2dLYWRmV1dsTmNVblBnSkFlcitmRXpKVDg1Vm11?=
 =?utf-8?B?SjVIc2tSdlFBT0k0WHJzbmN4dzRZY0dhRU9CZTlSYVlBZGhuSjl1WWU4OFgz?=
 =?utf-8?B?Vm83ZzRZemZiQjFGblJVMTJweUN2UGpWVkFuN3ZmdHBXejRabmFsYm5lOXJl?=
 =?utf-8?B?UFUzQXA1VVZVNUtIWklESjhUVkZiVVVTdEFmQ1VKcWpVRjVVOTV2WHZRN2lP?=
 =?utf-8?B?S0dIUWRySUtRaGY2eXFycmlmZ255Smtpdk95NUNGd0FCZWVLcFhOZ0lmemRz?=
 =?utf-8?B?ZXB6empOSGJRL2Y3MHh4dkowUjlYQ2R0WUFmQ3NzdmU5czAramw2ZVlyTjUr?=
 =?utf-8?B?N0RqVk44Tyt5MWcxV3U2WkhLL0NQcUNPZW5ySGllK29Ndmxwd3poWElVSjRs?=
 =?utf-8?B?a2pIc1AxcDNIdjloMmw1TGFvTzUvVXZFVE5EWC9VQnp4dmVpMm9CS1NwRzlN?=
 =?utf-8?B?SFNKNUR0RlV2Yk0vczZURnJkbDJZaFlxaVBrVTB6Mms1cDZXRVh1aHpqdGha?=
 =?utf-8?B?dGxlU3M0UkpyMGlNOWtVVGt0cW9vMlg0TkVoZXdWaitlcDFQZ3Rjd0xFaXl5?=
 =?utf-8?B?OVoyZXN3SG40OEVuck1FS1dhUVpnMUdqbVhkbHNNdmhxL21oci9xczRML2lB?=
 =?utf-8?B?ZThwWTk1b09ZcFpCWCtDaHJML2pMZ3BYK3VZNDhNdlc1SW5RRGtHWW5KbVBU?=
 =?utf-8?B?bXdNamRsRHR0SUJ2OGVNY2QxWjBRWE5yeTZPb0FoS1lGQWRRWWo5cmVWSjNl?=
 =?utf-8?B?U3NRRjRXenlBbkJLdFNIekxKL0taTXlxS2NRcTVxdFFHdnJlQ040MXlpeVRT?=
 =?utf-8?B?QWorVWhtcVlzbWJSVERtRUVYOXhjdUpWSnJ0WnVoMjM2MWtHY1RKbnZUdHda?=
 =?utf-8?B?c2hreG1zc1I4eE9FQTMxTnVkZG5aQkpSNitwQ2VIRHRPNjVxYWV0Mm5rV0lS?=
 =?utf-8?B?R0ZaMmQ2TUN1aDgzNEZRTHF5N0FlTENFd3BmU0hPQ240Tkt6bmM3aUk2YUdW?=
 =?utf-8?B?UWRjNncrNXEvOG92QmYvaXJVOEY1bjN1YWZnTHdramZLcXdLcDZXYUp5NmZ0?=
 =?utf-8?B?S0NXL0RWQm4zd3g3V2ZIbHlzaDY5ajlVM2NrMkgveFlJK2xOekFPUnNLeHU2?=
 =?utf-8?B?d0hwck9LV3pWNWp2NVdlUVJZU202L0FwVVBuU21DT0J6WWNnaDdxTTVyQWo4?=
 =?utf-8?Q?M/nAOo0TGD0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czZPTk1xcGxTMXVlTXZ0RU9jTEg2OW9LaVlveFRsMU0xd29wb2h6ZURKTGNm?=
 =?utf-8?B?b1B5dUlXOHlKVjdPZDFaMXB1TnRZZE1CYTdaWk1DWE9TcFp4T0ZPS3lWK2o4?=
 =?utf-8?B?dGhlbURzRnJLTjg5ajBnZzRBejhUY1hGeEpEYW9jUUpHb3VtT05FWGtOSC9D?=
 =?utf-8?B?TnljT3Y0Z2FmbGhVMDUxZzFEUnRzdlNyb3U0OHVrZEdIYk1jVzRoeE13NmFW?=
 =?utf-8?B?MjlZbFJ5MmdGcHZLQ05TaGNueUk1S2daaUpOMW5SSGR0YmdzcnNvKzNlbFNM?=
 =?utf-8?B?dldlSFQxYUMwNlU5bzRMWUgxUU9PcERwakpMdXJsMW4wcTVCSUVXMjhlYmls?=
 =?utf-8?B?S3lGY0d0YXVOUWJXSElNUjl2c1BqcGYrYm5QTU5YRkNzQmpyRWk3c1ozTzQr?=
 =?utf-8?B?WXRoS2IrWXBCdzdTTGJYSG5FV0VPRU4vQ1V4alRoNjh1aVN2czZiNC92Zm96?=
 =?utf-8?B?MHM4N29acUd3V21RMHcxWm8wb2I5MmZOMVQvYnIyakpxWGNETVlOMS9GUDhy?=
 =?utf-8?B?L2QrNW1JRktqQWF5ZjhUUDhDYUYvb1liSVkxSFBUdlRUVmtFUjY0TXpId2xi?=
 =?utf-8?B?Z1UxZTFScEJ4QjAraXJGNzBhb2NUZExnWUZrcUc1bUdmL0F4ZFQ2L1ppdUJL?=
 =?utf-8?B?dzRCbkFTbXlGM3AvbTFKZGpDSjBlN2ZscmJ0NlU5WmlYT3NCQ045eENJL3FO?=
 =?utf-8?B?cHQ2QTlLVDd1QlltK1hYaVpyWG0rcEJSTjlYVFFsK2R0dVk2M3dDSWd1emRa?=
 =?utf-8?B?NURDT3dTZ3d2c0ZIRS93WExUNGxVZFhZdHg0UXg4SUtVS1BvRktwYnkrcEVD?=
 =?utf-8?B?ZndpVW9zUERjM3BiR1VjTFZmZW5BZ3pWYXJEV29tczhKZ3NLbUVNTnVNSUlw?=
 =?utf-8?B?L2YzMW9LUlVrZk5yL1g0dGV5ZUp0d2pyQmRDYjNvRkR5MFJ2bzFTd1gxUjBw?=
 =?utf-8?B?VGxLdGpEaUo0c1lpSkFZcVovcmVvYkVYclgvNGkyVkxhSmZpdXJPZ3lyNUI5?=
 =?utf-8?B?em1YaUZjakI2bFJhbS9MUHIxcGl4YTVOZndsZFZJejVrZG5YckZ6dXZRTUQz?=
 =?utf-8?B?bmVlQnVWT0tEeUxyUWlnczBCVU5BWE5YM3M2WHY1Y01TQTR4cE5RdHBCVjIx?=
 =?utf-8?B?Q2pNU2FIYmNqbG9EbjA5OWc3VGlLbEF2SzNZbzZqdmVWeC9yN3hscER6V2pW?=
 =?utf-8?B?ei9BYzBseUFTTHhPWlBPTlMvMUpXRTdXTXVuaDVyVTBDRzlQZ0REWnkvbFZ3?=
 =?utf-8?B?UUNSVWNVVy85d0V4NG5WTnNQZUZnc3M0UjJCRlZTSjJlQkRLQkJyc1MrUW9P?=
 =?utf-8?B?TXpOSk0zS0V1WUJCTUkxMHZtQWcrNkNYNzN2ZVhQN1VBbnMrVmNmalBlemhX?=
 =?utf-8?B?T0NMTkJ4SXNBd2dJWklZc0lvM1pCQUlvb0JsUThxWmswWE5SVGlPbzk4THVq?=
 =?utf-8?B?V09OZjBqcW9uU01SVWZ2d2xSQUE1dDU2SUlCZDNIc2RSR1ZwVzdQdWFEMisy?=
 =?utf-8?B?aUVGMzNEMkNsaGdpSytkazlObDlMczRsYURjRGU3enAyUlB4RXdycDJPdkIz?=
 =?utf-8?B?VEEzMFR4VVVwVHYyVEo4RDZUOWhCdDRFWmNxZmdOb0hqM055cVdJL0E3ajNu?=
 =?utf-8?B?Z0hDRDY1YVpuMnJBUUdTZUN6UktEYXNqcEp3WjN1QVN5S3pHUkNkcjA5eHFm?=
 =?utf-8?B?MUVKZ0JjVThSdml0aml6M2QxUTdBNzNmQ2o0S1lNaDMrZ01yR085alI3aVBZ?=
 =?utf-8?B?b3dvZDk1cUE5eEc1cUNwUERzNG5UMGxBTXdGTGVhT2RXbVlJZndJK25RLzlH?=
 =?utf-8?B?bldHTkhwS2JOclRMdElFcXlpeUFIZDI3SDJqbWd5c29ad0hxd3BSNE55SkF3?=
 =?utf-8?B?cHVFb3lvdDJRZWo5S3UwVWV1WUtNa3NGSEJNZDh1ajNodk1iTjhWMHhHdUZ3?=
 =?utf-8?B?cFp3N0FBWk16dVFjTCs4bnhSaFpFSzRwY3QzbTNCZ2NtdlJBR216OEtsN2pK?=
 =?utf-8?B?by9aeWJUdERiK1VxQy8yc3VMQVg2ck14bUgvazk4dDdDdHVNQUg5RDIvRWtW?=
 =?utf-8?B?RFVxM29mcW1lYkphbnNXaHoxUW95YzkwdUhUYjJrQ0F2ZThCZDR5WE11MEVS?=
 =?utf-8?B?TnI0WUhLQ3EwV1MyYzJkRm5vODlmdFh0OVJJZ2tuMFF2YXc1eEM5RXVyV0g2?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4231e7b0-1e50-4ac3-44a0-08dda7b604a1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 00:30:36.1520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8slaAi8ZifsVuhdQEjYMgvN990/suIe7mB1tOyW1hzuYXnE0GKP47RZy2qT2Dj3VyM5k3o9UDXHJLoo/cjsv++60TeqPBXiA5Btq47Tfbms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5221
X-OriginatorOrg: intel.com



On 6/9/25 4:34 PM, Luck, Tony wrote:
> Reinette,
> 
> Trimming to focus on why I was confused by your message.
> 
>>> One possibility, that supports intended use while keeping the door open to support
>>> future resctrl fs use of the debugfs, could be  a new resctrl fs function,
>>> for example resctrl_create_mon_resource_debugfs(struct rdt_resource *r), that will initialize
>>> rdt_resource::arch_debug_info(*) to point to the dentry of newly created
>>> /sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON/arch_debug_name_TBD *if*
>>> the associated resource is capable of monitoring 
> 
> What exactly is this dentry pointing to? I was mistakenly of the impression that it was a directory.

Yes, it has been directory since https://lore.kernel.org/lkml/9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com/
If your impression was indeed that it was a directory then why did your patch not
create a directory?

I am now going to repeat what I said in https://lore.kernel.org/lkml/9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com/

> 
> Now I think that you intend it to be a single file with a name chosen by filesystem code.
> 
> Is that right?
Not what I have been saying, no.

> 
> If so, there needs to be "umode_t mode" and "struct file_operations *fops" arguments
> for architecture to say whether this file is readable, writeable, and most importantly
> to specify the architecture functions to be called when the user accesses this file.
> 
> With added "mode" and "fops" arguments this proposal meets my needs.
> 
> Choosing the exact string for the "arch_debug_name_TBD" file name that

This should be a directory, a directory owned by the arch where it can create
debug infrastructure required by arch. The directory name chosen and
assigned by resctrl fs, while arch has freedom to create more directories
and add files underneath it. Goal is to isolate all arch specific debug to
a known location.

Again, we need to prepare for resctrl fs to potentially use debugfs for its own
debug and when it does this the expectation is that the layout will mirror
/sys/fs/resctrl. Creating a directory /sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON
and then handing it off to the arch goes *against* this. It gives arch
control over a directory that should be owned by resctrl fs.

What I have been trying to propose is that resctrl fs create a directory
/sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON/arch_debug_name_TBD and hand
a dentry pointer to it to the arch where it can do what is needed to support its debugging needs.
Isn't this exactly what I wrote in the snippet above? Above you respond with
statement that you were under impression that it was a directory ... and then
send a patch that does something else. I am so confused. Gaslighting is
beneath you.

> will be given to any other users needs some thought. I was planning on
> simply "status" since the information that I want to convey is read-only
> status about each of the telemetry collection aggregators. But that feels
> like it might be limiting if a future use includes any control options by
> providing a writable file.

The file containing the debug information for this feature will be added within
the directory that we are talking about here.

Reinette
