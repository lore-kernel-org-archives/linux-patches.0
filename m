Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6496215FD1B
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718986025; cv=fail; b=mNt7gVCbkSWur+a0oGf+yXi3HDEW87LeltADeQLNXigMBibEBiXzbWMALGJRMjds6hotp4309/IlLooeDeBjl+qmd4g7wc7CfQ8/A9aQ/syhOAGD2Sw6LF7eg4JsSD8KL27Gct8o5McP1xtPYfJ6rHUm1atP4YcVZn46i26yCNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718986025; c=relaxed/simple;
	bh=PCfpogaHks1vICXEwiYNyME4XlwhEm6l68Od5PxNvLQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=il+UPRWjLXWkS6T98g6pSHidDRAr4tponVhpPnIHy7Lc7sD/nfe050upUKzZ3yxRhTkgtGgR5f9oU0DjYJrz/SJdIfNLBSUtg5+bZgxVeV6n+9ImePIcmv1f5ffxe/qI3JeCuk0Vp0Af5hX7EkNzVdWylcevyu3KlWg5V+QT5u0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8rjB5uo; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8rjB5uo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718986024; x=1750522024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PCfpogaHks1vICXEwiYNyME4XlwhEm6l68Od5PxNvLQ=;
  b=b8rjB5uoUZrTSexaYbCC/exdi2Ukwidn5B4YSPGHBtuI7SX010mvsKBC
   emYMaspVjxZQXOBjMOW9oexVKWwSqQlxPTyg87lBAMWJ4FY+L0buaRQtw
   z+WD2dOBCPa0/P+Avn7y6Fa+2+dTolt2+C4vyPtNcjZYmmhuOM5fIS2T9
   mzlh3T9wXybzVPCD4H8SaxsdJCjRsEfbyXLLp942lSO7i8zHF3zI9xHBS
   aVtDth/YJ/GFaCmCnX9o15e3tDm2PbCnN7r3FOP4kOkhqCldS1/xLqSd6
   5Y4htLCH0bzhErB7kh/IVeYhwwpdt8IdOco1nA1m7gUia+B9IsZGW26RL
   w==;
X-CSE-ConnectionGUID: Z9+X2qE+TkyBsDGxHcOtMg==
X-CSE-MsgGUID: ZUDOD46ARlW5fxSdhq2rJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="15998820"
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="15998820"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 09:07:03 -0700
X-CSE-ConnectionGUID: 8ENN5EtyRB2k46GlHTsn3A==
X-CSE-MsgGUID: dJB9SpT+RBqiBmGnJ6yWrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="42728117"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jun 2024 09:07:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 09:07:02 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 09:07:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 09:07:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 09:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiNlxOFKtMBdLeWGDNyD+UdCwIn8wrFTKDb9A1FzY1tgP4YgGwrcHCm2ieWXxXXDqP93EFZjG24xnesAAYsc9UaDmwvb7vJBwoElIpDdMss8j3VNB/n42WiF/XsPtBVsiEygS+RVS6pxagMN407Qjhbi3qNqKBjflGvbz/TvTMtGqaDbmrFghMU9aBwo/wyHysyspMzbmi41Yza8zHBXl9OqADYU9vrjRqELTI+JqF1THqfzmxT1bXAnODa/uepiuvSr0g83m6gviDTpt0qonOxT6WKv8qP0mgI6O5DrTjYXAD2Ctovd8fcQByZQrYSB+14Cuna5zCwZzajytdb5qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCfpogaHks1vICXEwiYNyME4XlwhEm6l68Od5PxNvLQ=;
 b=CHHet0boOCngGTO4hwoBo2j9TBgAOlATiiqszL0NxMGELpCiDiCL1j8YLt9OPUYn/Xxj1Zt/70vWZxD6lXWRM6JhIYOhS1N0fYHgz81kFp9nPuNS1vzFcORT/kSgGjgc2uSIUa0taddrqqXj0BaGbVxw4N8g7p+IsvAyEITffdJxKCdJ4XDRcR1F3FJ6nND/cK5kRF/UKs1MV1hA0peJmplkafvuxqFG8jeIpbwHsv90tW7ms2htgxthg5fHeYNV4VVEokQPEghRZGIaOCc2JrqsS6h67QfHPamtDpwJATA5D+TJGCiLkHDUGIo2bVSXrH3SMZGxw13agGBDUF4Vlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS7PR11MB7835.namprd11.prod.outlook.com (2603:10b6:8:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 16:07:00 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 16:07:00 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v20 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
Thread-Topic: [PATCH v20 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
Thread-Index: AQHau2UDun5MbjmM/EypFZCVcSKIObHROS+AgAAUVTCAADjvAIAA6qhA
Date: Fri, 21 Jun 2024 16:07:00 +0000
Message-ID: <SJ1PR11MB6083DDC10766D10326BE7D6CFCC92@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-10-tony.luck@intel.com>
 <1bba8391-6ee3-48aa-935f-b9c08bee049b@intel.com>
 <SJ1PR11MB6083E7C6C3FB2345A2495480FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <cd5c42db-2dea-4a01-bf02-b4316b0ba11d@intel.com>
In-Reply-To: <cd5c42db-2dea-4a01-bf02-b4316b0ba11d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS7PR11MB7835:EE_
x-ms-office365-filtering-correlation-id: 1afc4cb9-899c-4bc9-10e5-08dc920c2ec9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015|921017;
x-microsoft-antispam-message-info: =?utf-8?B?aWlXZWhyZHV6eVlvSldzalhCVWk5U1ZVNVhrODFFUTVPanhxUHpsdDVOOGFN?=
 =?utf-8?B?L29yV2ZjS3RvL2NWUVgzemYxVGlDeFZyOGJWQ2RkU09yUjd1NHl4Rlc1Ym5z?=
 =?utf-8?B?ZFVNODQzWDh4Yjh5V0RlTm9VVU5TTWVXOXAxNVhPSHdqUlZEemlZRkdJVGw2?=
 =?utf-8?B?TGluOWIySE50Q1NWTmtrczB3R3FUN2UrWVpXWHZVbkE3Yy96MUcxZE1Ra0Nj?=
 =?utf-8?B?TjhRQ1BYTnpyaGpxVTY4WUZVWSt6YmwwYjByK0xNNjFDV1c2TlhuQmc3QkhH?=
 =?utf-8?B?WVl4QzI4cE55Y0FoWE42VmdrNTRONWh1Z2IwZFVFaE9MaUNoT1BtMlpzS3dW?=
 =?utf-8?B?V2toamN6SStDOHBUL2RDTFg3akI3LzRVYkFhRFVHbWtzWFU3SDNGbjFjK1dW?=
 =?utf-8?B?KzM1c1dleEM2REFuQlg1Mkh2dk0vZTAySXJqdVlRYXh4bmd4aGhUcXlPdE9j?=
 =?utf-8?B?U3RuaU5mcXV0S20wQXVYVDJsaFQyTlBkZXh5c0JzdlNIWkRvWFlVYUpHU0Rj?=
 =?utf-8?B?Y3M2aG54NldXVHprMzIyS0RHZXkyOHg0UUY0UEFpK3doYXc5cFpIYkVRakdY?=
 =?utf-8?B?YTNOR3ZqRno0VlVMTVJTZVF6OVJuVUJ2S3RURlg2RktHRGE2clRKSnFsQUs1?=
 =?utf-8?B?NHZFaWtnT09OeDFldGVGSmhGaS9XeFBRanY1Ymxsd0FNNUY2Y1Z6alhjelRO?=
 =?utf-8?B?czNPNDk5WXM1cGRSMEU3ZGkyd1R1anVQOTFzQSszdFBRTHdYQyt6YnJDUHVk?=
 =?utf-8?B?ZVRTN2FLc0psU3FRTmw2dEtHSi9GOVdKaEQ2bXpDWFd2azc4OTMxU25hOGJK?=
 =?utf-8?B?VTdUR1pxY0R2eVRjdytuVFRpQWFEUzVBVXVaeGRIdEV2M1VMTjdkSW9vZ2U4?=
 =?utf-8?B?bG45VVJubThidEQ5V2xhYytUWGZtc0pEYUFPZUlwMzlwUkJrZTA4VGdwUXJT?=
 =?utf-8?B?czB0cFZxcFFKRElseEo2OEJXdXhQOFBoRFNhQ2tIR1VtZ09JREtqN2JkWmNz?=
 =?utf-8?B?OEZSN1ZEeTFFYzZVWWxjaXBtMTlLazBXWGI1QnNVTjYvRi8yVXd3T3JUMmJS?=
 =?utf-8?B?VkZVbERmYnVlWlEvNUw3NzVvaitzSEE0QWR0bFRoMVBwaHYvL2dQVDk1MXM2?=
 =?utf-8?B?ZzFodUtNMWo5eWQwSmtXOWFGU1dmNnJ1TmhpcDZubTdLcFNFK2FFTGkxdTRW?=
 =?utf-8?B?R0VHeFNVMDhGeElhQVJqdXc4T3hiWjk2R1h5MXhjQVltUnJDSzdlbUl5VW1S?=
 =?utf-8?B?RlVSK1Y5Q0lMdVpycjc0VEdsSWtuS1JCcC9aRXpKL3FHcW9LVlBnK1NybXdi?=
 =?utf-8?B?MXk2SFZIaDI4VEtzaHp4U3NZMWVhamJ1dm50b05uMlJPZCtBdUtNb1VzMmRj?=
 =?utf-8?B?LzhWR2NXUGtOSytwZk1jWm1zK2ZhalRYMXlZampXbHZxNU5LUGtjSVZJR0Yx?=
 =?utf-8?B?WkJCc1B2YkhpWGhoM2xRdU9wTVYxSzFLN2ZadXV1WE1hMitFRmE2aXNxcmR0?=
 =?utf-8?B?TGE3dEJ2WFZ3UFVDMDVKUEF2Y0hqaXNCaFJRRXRPdkUzTHo1MjNaUkVQeFJ1?=
 =?utf-8?B?MzFYSFE3WXZRK2w1dGlmSUhKMmtkNkRTeGU2VXJvcU1wdU1ndWk1SlEzNzBv?=
 =?utf-8?B?SE5xUXppaE5ka1BrSU1Ja0xqZzVqNjMvakxrbGF6S2g5UWV1QXpreXNXcFlz?=
 =?utf-8?B?c3d5d3FmKy8yOFFYOWkrSE4wVUo0c2ovdDFxSjFJM3IrbHNodlpjS2ZpY1lK?=
 =?utf-8?B?M0hlbFdNSTRIMDB5NEtDcCtQcnJzY0VWY3dKS1hBbXB3L3phL0U0bW5VNkty?=
 =?utf-8?B?aDJjeFFJcmdkc2RCeStueVNGT3JPRUlkUFRDRFNzeTkwTHlPU1RlWXI2a2RB?=
 =?utf-8?Q?3pmD3NKe13VUr?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015)(921017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2hmeTI4aEREQ1Y1SU50SGZmanIrT3ovM01iNWxXV1V3R1E5R1JHSUsvcWhV?=
 =?utf-8?B?SFg0SS94SmRuU2YwQzNLK0t0b0pFOUxRcjZtWDZrVUVQN2dlU24wSFJBYlZo?=
 =?utf-8?B?bll3emFZZWk0N2IxL0pXbGRTNFkySkkyeSs1QjRYdXZKYW9PUnFHQU1SNG5Z?=
 =?utf-8?B?UldVSnFUc0lFNnk1bFlTemtSdURKd0hLN0U5VHJuQS8vVVpMMlFYYzFpeFZ2?=
 =?utf-8?B?dHByYmkvcFlaYVFVdThQNXlVNUNHcUNhSTdSRlBFeTNvcDNST3VWZmIxVHlm?=
 =?utf-8?B?NHBpbUVNeU95RkR4QmV2SHQ2WGtGdE9LdWp3T0tPU3lBZTkxSzZzcThHQkdD?=
 =?utf-8?B?bHNpZktIaWdJRm0rREVTbnlKaThVaFBiZTVLNU91SUJ0czJYZGtiejlTS296?=
 =?utf-8?B?QTJjYjZyUEhHL2w4Y2JhVXIrU1RoVUdadGdPTEVqZVBOOGNVbWFvRC9pR0g4?=
 =?utf-8?B?Mi9RVFo5ak93blNmWlRDTVpZbHNMeDlPc1hIWXM5ZG01TnFEVlR1b3JIcnJn?=
 =?utf-8?B?bVdVUGpEbUZCRWNsaCt6OWF1SndJWVcvc0R6QmhYd0xnWVJXN09ESS9Kdzhh?=
 =?utf-8?B?eWJoVGhVWjlmZkhvZWJIc2M4bGJlSEppUEFuNnhxcmxhcTNOejR3RlVaTHl6?=
 =?utf-8?B?aUVweSs0R1BNdUNXTDJYQTFMNyt5QnYwUWtZdnhlNmZGYkZKMVJ0TU00RWJQ?=
 =?utf-8?B?SXBranpBT2xxdUVqVjFVMmxkYXpaM0tneTAzdHhtcE9HSlJkTDBaL2RjUFBP?=
 =?utf-8?B?SGU0OS9UaG52dGJ6QTZFakpzUXo4WU9Mb2Z1VTZjN3VUa1BYY21qNUU2L0hS?=
 =?utf-8?B?c1dJci9lUVk2c21hN2tDb3p1Z3Y5RGRqaytWc1B0VmJEOVFjNGtRUjg0NEdp?=
 =?utf-8?B?cUJiNVJrcXFvWFBhbWR5ckpuM2lDZzVjbFhRZUVLQXlCMjRxd3pUSWE0ZDZs?=
 =?utf-8?B?TkhORm5PN3hQVi9MQ3Jjb2NRdVpDSFZvMVlpM3dnUkFQcEppTFdndXhKRUJk?=
 =?utf-8?B?M0s4VFRacTBvaTgyanFjMXcwZlExYW1rTVg1Vkt2RjJtczQySjZwMDRMQzJt?=
 =?utf-8?B?LzRYSCtMcWZ3bSt0UVZBNG1ERC9nVmtzR3ZhVmpmNkFLdnZkSHY1bzVQT01D?=
 =?utf-8?B?cm9vVlFhaTdmbGxXVXpwMSt0UHZqd050SmFlSGVEZGUzNDlQZHh6WDhxZjl6?=
 =?utf-8?B?bnZreEE0WWNJM1VTQXdYM1hjSXB5clROSVNSR3dJTUtMUENHNTkyNlJOdk9I?=
 =?utf-8?B?OFUxSFpIRjRqWkI1K0Rpd2h6dldFam5qMVp0cUc3U1RwdlJveFppelJRWUlQ?=
 =?utf-8?B?Q0N6SWVKTDUvbkRVb3pNMURGSkk4WDczU2xqcTNLVVVwdk1hT2Z3R0I2bHJw?=
 =?utf-8?B?NE8vVUhDb3doRHRNaTRiT1ZzbW5tMktDbmZEMXEwRDlqQlg1WGV6a2hXOEhz?=
 =?utf-8?B?dVRyZ3NTaU9jMm1pTGVLSVhOVno5QTNVTlEyWVM4cDhmRHpWZ2JzRWgvTy9X?=
 =?utf-8?B?YjZ6WXFCeXFPWFZ2cUV2Tm42V2N5OXpOVWxPU2JEVlYxN1laYThNdFNrV1lx?=
 =?utf-8?B?MlVYczBGTzFqZXQ5U052L1pIeW5qcU9WdllmKzMrMWxNMmtObUhxNW91dGE5?=
 =?utf-8?B?OUpONUVlYWZ2RkVnbFo1cEE5T0lpRkRaZ3hxSGpkU2IxZzNqeTJldTlDTFln?=
 =?utf-8?B?UnFmRWVMQzh3SGJ1a2xTNE45M0RMd1k5anJKL0hYWk04TUFhN0hQUTF1OEtM?=
 =?utf-8?B?YnZMam1NSUVkckRzbGw2clY3MTBuNUFVMXlORnRMc0tOS0x5WkNGaHBvYmFW?=
 =?utf-8?B?MEtQczRrOHhyS015TDBmSVBrSGF6N3M0d0ZEaERHQ2xPclpwcGdYZ0dlNWJ5?=
 =?utf-8?B?YjIvMlp5NTUxa0YzZVRHbDdBWFV4emQ0NXB3akFOUTJ2MDBxOTE5WUw5YnVq?=
 =?utf-8?B?N1kycy9TdUhCQzFqaUlEUmhyQkJ2NytqcEJZMGVjSWZ2SWFjay9hT3cxbDBL?=
 =?utf-8?B?Uk9JNlRqVE5zay9wMEp0R2J0WGpqNnVKK09lN3pmeTV4WW1wVnd1eWo3cUcv?=
 =?utf-8?B?UkFuVEt4TWIrR1lrdmJLY2FZdlRnSWxJNFFxOS9Ga3RBUHlubU11UElKQjBV?=
 =?utf-8?Q?z77T8lCWqrtMs08iuZh/rBHws?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afc4cb9-899c-4bc9-10e5-08dc920c2ec9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 16:07:00.1818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x1+VdZ8Mu83dlxGiXQ22HMH5k20pXmK7kIJO2ANlMUp4K3z3zHztQz/STf+D36YKFILROarm6dFQBbgCiOlzVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7835
X-OriginatorOrg: intel.com

PiBJIGRvIG5vdCB0aGluayB0aGVyZSBpcyBhIG5lZWQgdG8gaW50cm9kdWNlIG5ldyBzeW50YXgu
IEl0IHdpbGwgYmUgZWFzaWVzdA0KPiB0byBqdXN0IGhhdmUgYWxsIHNlbnRlbmNlcyBlbmQgd2l0
aCBhIHBlcmlvZC4gVGhlIGJlbmVmaXQgb2YgdGhpcyBpcyB0aGF0IGl0DQo+IGVuY291cmFnZXMg
dXNlZnVsIGZ1bGwgc2VudGVuY2UgZGVzY3JpcHRpb25zLiBGb3IgZXhhbXBsZSwgYmVsb3cgaXMg
YSBfZHJhZnRfIG9mDQo+IHN1Y2ggYSBkZXNjcmlwdGlvbi4gUGxlYXNlIG5vdGUgdGhhdCBJIHdy
b3RlIGl0IHF1aWNrbHkgYW5kIGhvcGUgaXQgd2lsbCBiZSBpbXByb3ZlZA0KPiAoYW5kIGNvcnJl
Y3RlZCEpLiBUaGUgZ29hbCBvZiBpdCBiZWluZyBoZXJlIGlzIHRvIGdpdmUgaWRlYXMgb24gaG93
IHRoaXMga2VybmVsZG9jDQo+IGNhbiBiZSB3cml0dGVuIHRvIGJlIHVzZWZ1bCBhbmQgY29uc2lz
dGVudC4NCj4NCj4gLyoqDQo+ICAgKiBzdHJ1Y3Qgcm1pZF9yZWFkIC0gRGF0YSBwYXNzZWQgYWNy
b3NzIHNtcF9jYWxsKigpIHRvIHJlYWQgZXZlbnQgY291bnQNCg0KU2hvdWxkIHRoaXMgZW5kIHdp
dGggYSBwZXJpb2QgdG9vPyAgSW4gdGhlIHJlc2N0cmwgY29kZSBhIGZldyBjYXNlcyB1c2UgIi4i
LA0KbW9zdCBkb24ndC4gU28gbm8gcGVyaW9kIG1hdGNoZXMgcmVzY3RybCBzdHlsZS4gQnV0IHRo
ZSBleGFtcGxlIGluDQpEb2N1bWVudGF0aW9uL2RvYy1ndWlkZS9rZXJuZWwtZG9jLnJzdCBkb2Vz
IGVuZCB3aXRoIGEgcGVyaW9kLg0KDQo+ICAgKiBAcmdycDogIFJlc291cmNlIGdyb3VwIGZvciB3
aGljaCB0aGUgY291bnRlciBpcyBiZWluZyByZWFkLiBJZiBpdCBpcyBhIHBhcmVudA0KPiAgICog
ICAgICByZXNvdXJjZSBncm91cCB0aGVuIGl0cyBldmVudCBjb3VudCBpcyBzdW1tZWQgd2l0aCB0
aGUgY291bnQgZnJvbSBhbGwNCj4gICAqICAgICAgaXRzIGNoaWxkIHJlc291cmNlIGdyb3Vwcy4N
Cj4gICAqIEByOiAgICAgICAgICBSZXNvdXJjZSBkZXNjcmliaW5nIHRoZSBwcm9wZXJ0aWVzIG9m
IHRoZSBldmVudCBiZWluZyByZWFkLg0KPiAgICogQGQ6ICAgICAgICAgIERvbWFpbiB0aGF0IHRo
ZSBjb3VudGVyIHNob3VsZCBiZSByZWFkIGZyb20uIElmIE5VTEwgdGhlbiBzdW0gYWxsDQo+ICAg
KiAgICAgIGRvbWFpbnMgaW4gQHIgc2hhcmluZyBMMyBAY2kuaWQNCj4gICAqIEBldnRpZDogV2hp
Y2ggbW9uaXRvciBldmVudCB0byByZWFkLg0KPiAgICogQGZpcnN0OiBJbml0aWFsaXplIE1CTSBj
b3VudGVyIHdoZW4gdHJ1ZS4NCj4gICAqIEBjaTogICAgQ2FjaGVpbmZvIGZvciBMMy4gT25seSBz
ZXQgd2hlbiBAZCBpcyBOVUxMLiBVc2VkIHdoZW4gc3VtbWluZyBkb21haW5zLg0KPiAgICogQGVy
cjogICBFcnJvciBlbmNvdW50ZXJlZCB3aGVuIHJlYWRpbmcgY291bnRlci4NCj4gICAqIEB2YWw6
ICAgUmV0dXJuZWQgdmFsdWUgb2YgZXZlbnQgY291bnRlci4gSWYgQHJncnAgaXMgYSBwYXJlbnQg
cmVzb3VyY2UgZ3JvdXAsDQo+ICAgKiAgICAgIEB2YWwgY29udGFpbnMgdGhlIHN1bSBvZiBldmVu
dCBjb3VudHMgZnJvbSBpdHMgY2hpbGQgcmVzb3VyY2UgZ3JvdXBzLg0KPiAgICogICAgICBJZiBA
ZCBpcyBOVUxMLCBAdmFsIGNvbnRhaW5zIHRoZSBzdW0gb2YgYWxsIGRvbWFpbnMgaW4gQHIgc2hh
cmluZyBAY2kuaWQsDQo+ICAgKiAgICAgIChzdW1tZWQgYWNyb3NzIGNoaWxkIHJlc291cmNlIGdy
b3VwcyBpZiBAcmdycCBpcyBhIHBhcmVudCByZXNvdXJjZSBncm91cCkuDQo+ICAgKiBAYXJjaF9t
b25fY3R4OiBIYXJkd2FyZSBtb25pdG9yIGFsbG9jYXRlZCBmb3IgdGhpcyByZWFkIHJlcXVlc3Qg
KE1QQU0gb25seSkuDQo+ICAgKi8NCg0KVGhpcyBhbGwgbG9va3MgZ29vZCB0byBtZS4gIFNpbmNl
IHlvdSBoYXZlIHN1cHBsaWVkIDk5JSBvZiB0aGUgY29udGVudCBmb3IgdGhpcw0KcGF0Y2ggaW4g
dGhlIHNlcmllcyBJIHNob3VsZCBhc3NpZ24gYXV0aG9yc2hpcCB0byB5b3UgKHdoaWNoIHJlcXVp
cmVzIHlvdXINClNpZ25lZC1vZmYtYnkgdGFnKS4gSXMgdGhhdCBPSz8gU2hvdWxkIEkgc3BsaXQg
aW50byB0d28gcGFydHM/IEZpcnN0IHRvIGFkZCB0aGUNCmtlcm5lbGRvYyAoYnkgeW91KS4gU2Vj
b25kIHRvIGFkZCB0aGUgbmV3IGZpZWxkIChieSBtZSkuDQoNCi1Ub255DQo=
