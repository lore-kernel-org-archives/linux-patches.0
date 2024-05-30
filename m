Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF394D8CF
	for <patches@lists.linux.dev>; Thu, 30 May 2024 22:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717109381; cv=fail; b=eSltnla+USEWElS1o1C3a+rJv3+pFEmLzn8/7Dkw5SFVTVYIBd7dKClUPaIMw7/+lOax5Cw+jmGFtijaFtlG4GqLSq4wBpuCtIR5Wbg5uMz5sXrJL4l3gA/t9LCjroz6xhGVX9nXUWOK5bQZiXIRpV5xiySOiiVREOMyq/ufEkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717109381; c=relaxed/simple;
	bh=w+K56TYsgqeIv+Zgl+5rHtmm7pFiCRLVoaqGzWsUKR0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kHQArS5Ws+a2rUtO+Wv1DM6y/kCtMdZdGBpt3muaFBtOlDU0+7A8XqysGtS/AcPVTOSsdx4ia8G60l+7gVD51rscbRZCVXkRL0OPkYdLt2TQ9h1E7vsxu/2/DyEYD2tdv/XAlNgYqDUyOKACakY17fDz8Ens5z7bD73oNywVX14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AOw7zs4L; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AOw7zs4L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717109380; x=1748645380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w+K56TYsgqeIv+Zgl+5rHtmm7pFiCRLVoaqGzWsUKR0=;
  b=AOw7zs4LG8Pu3zROxIL4GHtFdNs8DiexejYKaQhgKFGp1gmK4heyp5qE
   dqNILSKRLVRK56huWf40Y9ZzKb9w4zbqZjt86e3cfmbW1LVFiAp7ej3xZ
   x27x4oNSyu+MAh0AseZzIiSGGkhscbU8BTYmDZSDY5+xKDNK6oHTSg2D+
   DaoDOitpcgtmCgeSD1FFuEXbu3Dtwp32RePiswBudU6qTq/gb67/WvkZ8
   zh69dnarlCmnc2axbyECz5xkpzq8KrOlPuNy0Y/3LgjPJecyPF6CPJE5l
   waBmLRCYe6K1pPTHuZUec6RmVM445K7ZTTi5o4OaAgjd2zHPj9pBO2qla
   w==;
X-CSE-ConnectionGUID: R8TilbI9R6in4aCL8ZquMg==
X-CSE-MsgGUID: mA2k4/JSSqWaU7GARctSdA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="39020634"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="39020634"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 15:49:39 -0700
X-CSE-ConnectionGUID: rxOuO9XcRCiaU9ec+4Jo6g==
X-CSE-MsgGUID: aKzHI3G+SHGB+j1AWRbkew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="36003465"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 15:49:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 15:49:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 15:49:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 15:49:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0N99BnUjW5qo2bnt33OyDtjZdULbJudR4CBohAqjPE/IdHzCbAhpy6IFGYXEOSFlGzQVb+Lyl/zhmiGZiFvDQqNYBqtJJXaLYrstmrlO/JsEDTfkQkHNvI5dkVHKHqKYlXAhdeVs6TuxxLIaoToZjrsqSF2TOo4F9fm/lXHH7V+pdalCIZ52f/FXu6Kw8YGsHN53yJDCpSddT/d0vLZoS3j2+e5oFi0oobomOP1U9pPThy/4uX9pypa7yubPtz5CLKNByzJVuaJvjpdcwSsVTd2tGkHeR0OjIfI+xhQ0gfNqE02kdEoJ2UVaCuBlx3+trLvm9UxXJbZUzhbRIRtwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+K56TYsgqeIv+Zgl+5rHtmm7pFiCRLVoaqGzWsUKR0=;
 b=ZzGI9O5YiR93+TpWDzyPrRnOFNyLU7/R0tCtBnsoh7iXQ6C4UTtn2VvA3CIw/RF0BkeJhdMJcC68fPeMiAGm9p0MGpcfQBaTzoThSv/QrA+wMO0PxMcQw7y51iyVolsRMXoxtyeSf7SpyvyLme0x7oop0HGBCbwJCmXwMzfrsAALTwLkrlcsYAfm2JQ1wqQCw1nZvMfAZ2ErOkaiucuHen1EzKVxD1r8FX0FjLJy6cUAclgbe9XQOMtrS3A0H4HVYl27EAT7jYRKDF+e2u26cvhTtsuOBSwJ0DJ05lBMYORsfHCcfESzzCUl1DCk4jhLB3yVFrI0uFQqrNwgKtSgyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 22:49:31 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7633.018; Thu, 30 May 2024
 22:49:31 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
Thread-Topic: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
Thread-Index: AQHasU09+z1pZCrgsEysN0tOrGVpr7GtQauAgAHS4imAAP4SG4AAUJcg
Date: Thu, 30 May 2024 22:49:31 +0000
Message-ID: <SJ1PR11MB60836D413A87A0351ABD90A2FCF32@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>
 <ZleODtL_6D-Q_OMX@agluck-desk3.sc.intel.com>
 <a4d37f57-328f-4456-92bc-5e6469d092c8@intel.com>
 <ZlirIUbLw8fLHe0j@agluck-desk3.sc.intel.com>
 <2a761266-e934-4740-bf15-95dbfe4e4d5d@intel.com>
In-Reply-To: <2a761266-e934-4740-bf15-95dbfe4e4d5d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH0PR11MB7471:EE_
x-ms-office365-filtering-correlation-id: 6e8d4eeb-b601-4a5d-7566-08dc80fac4e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TjNjMi9lVjQyd05yT2lKSG1uRGJsaEVVU01IakpxS3NmSTNVY3RtTTgzaHR5?=
 =?utf-8?B?VFc1NkZNbWhQTjBGMzkzUm1xbFdzelZid2VtQkN5eXp1L1I4MHU3M1QwVjQ5?=
 =?utf-8?B?Y1VzUUFwTWpXdTNNcWF6RWg2Z1JabFNKTmJjcDE3RlBxMkdZeTlOU1ltZmdx?=
 =?utf-8?B?YXhLWDRUOXM2OU96anJmZjJLVE8yT1BiemlkV3ExTlc4bnhVUG9ySk02VXNU?=
 =?utf-8?B?RmJ0eDh3dk1jcTEzT094M0l3MVFBclBxWHROVXJiRzlwZ1lac2c1ckQ5ZURG?=
 =?utf-8?B?WS8rSllpS2tvbGhmbkErZDlzbmhSNkFwTm41aFR6MnBiRlY5MXkwejR2Tlh3?=
 =?utf-8?B?cExLUDN1NmxYKzdiQ1ZwTUExenE5YUtKalNOMkFQUXFTeXNKelBDT2Yvcmx2?=
 =?utf-8?B?c0FBSldXWVUvNmVDM3VEd2FiUmdSYUJFWDY5Tk83KzE1YWtUVXh3c0lyNmZ5?=
 =?utf-8?B?NklyOU8yVjUvNzJvaUpnd0FPNXRjbzM5M3BkS2tVRmJ1eXVCMzhuT3U0U1BP?=
 =?utf-8?B?aFp4RXZ4YVk2QzVRSUNVY1N1Z05qeEJTRWdLVzZhUFhBUHhaaCttZVl5VjdX?=
 =?utf-8?B?aEVyRVhYdE9lcTl6cU5mK1Qva2YvOWUvU3FXYnlXMnJHQXM5ZnlGZEVXd2FJ?=
 =?utf-8?B?VEdhdnZ0OTBTVHhpaFgxK0IvWkJ3VWVZVjMxU2FuVXpkMmgvSnYxUE1PdWVF?=
 =?utf-8?B?dVk4M3dkcVlBU3AwMDA5N1RNNmxPMm5naDhJT3FuZk5nNWVQYXp3VnRwSTI3?=
 =?utf-8?B?VzhaMmgxbGRXWFd0ejN6aVRha1UzZ2llaTVyQm9uM3c4NjBET0wzWDRCbHNq?=
 =?utf-8?B?U0hRQTY0cTdPKzJtbStzRkt2RVJMd1NlSUk5RndaaEJBSUVBMGRublVvazhV?=
 =?utf-8?B?V0NndStPRWlpalpoemdVNTg5d2Y5d2gxUVlNb0MvVGNZMFp4NUpjVnMwc3BX?=
 =?utf-8?B?MDJzaklHVzlQTExFVjBrQkU4bXlJeXo3a1hUeWc5R0RvcEZzOHpLT3ROWEJv?=
 =?utf-8?B?VHQ4ekt3QWpxamo1WUdMZi9lYVR1OVVBTGdXT1Q0ZUxUaDM1TFB2Lzg3b3BT?=
 =?utf-8?B?eWxDbEZZZUp0bzlQeXlMZFJJQWJsTmcvRjVDZmlIRTV4b204QnYvTFA0aFFn?=
 =?utf-8?B?QTdWV3JtK2g5R2IzK2VFMzN3SkRZbzM2SmdpYjg5VFpyOVNFWndnOERZeGVx?=
 =?utf-8?B?WEc0eUJXelkzeFJiN0hIQ2x5L1hTQVA5LzFJQkoxR2JnNmJPRG8yTXo5akkw?=
 =?utf-8?B?bmZuLzRVdnhLVmxzOCt2QUFGdDdlNm81OWdSYVFDY2FlNHkveklCTXU3cVFD?=
 =?utf-8?B?NkpGcjlnbVo4S25aYmVxRkdPZHk5d21YMVVIdXluWXZZMkhCMmJ3N3VQazZV?=
 =?utf-8?B?V1dSUy9EYzlxMnJxMHppUjgyTlFiVWk3c0NSanJ3YTRHY3dWaEV0YmdJcFlr?=
 =?utf-8?B?VnYvMlB1Mjd3d0hRVjVqT0lrZktIaUt5T21GSjlELzdIU3JKdFd3VnoxNzVI?=
 =?utf-8?B?UVlDYVhIOFl3UVJOalRQa0YyRXp2RUdLQlRkY0tMVjVSTkRoT3IwQWp1UEZQ?=
 =?utf-8?B?K3MvN2EremNtdzlaU3g3MUpPSnZTV3VZZS9JbTU1UXF2aG1jNzFCSUxnY2Rn?=
 =?utf-8?B?L2ZnWFRZL3VSUnR4dHVETVFtaVJ0VHZETU9WRlRteS9NWHZ0b1VLVmhKNFpV?=
 =?utf-8?B?a0RZOUFOTC9ad2dDYnNSRitlY0ZRVytoQkpyQzJjbEYxaVQ4bnErYTZ6clhQ?=
 =?utf-8?B?dkptYUhVRVh1cHI5WXVsTkpiREZhRGNrcUo0RDd5eENuV1R6cFBmOEthZ1V3?=
 =?utf-8?B?aXN2dTdnbCsrZ1VHVVpxZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlE2c081WW8xTDlpTkgrazQ5aVhmNXd4OS9qaEs0bVR3S3lNM0NrWUlIMzYr?=
 =?utf-8?B?KzFad0VaeitjbTJ2c0tzR2w3NlFSM2NOUHRVRjlUYXRhdllFSjRBMldITG9J?=
 =?utf-8?B?TDZ6anJUYnRyQXhDUTZXR3NtU2o0R3lROFhNeU9NVCs3d08vSnJ5RTdLN1JC?=
 =?utf-8?B?ZWtzM3ZuOWVwSDhxTGd6VW8xTkkrcWx5cTdHWFBpVStaMDFTUWZaZkRKUkZN?=
 =?utf-8?B?Ni8yaWM5czVPRFFQNkR3RW5tUVQ4dEtKWGhFSDY3R2NiNVBrYk1BbnRVWitT?=
 =?utf-8?B?ZjQwQ043TGRKOW1xUWpqbDRIUHJMT1ZicGxqSlFORHZZb3BEVHpKVzA1cUFL?=
 =?utf-8?B?VHR6S0I1aVlvVE43bEtPVUNzZmNlbkluM2J2NFBOQUwrNjU1c0xHNXN1VlZ5?=
 =?utf-8?B?bXVHaEk2enpLZzBCeFVnRXpQaTVnSGRUOWo5YkFkNlpUbjBpNkYwRk93eURB?=
 =?utf-8?B?SkNoZGRtS1NuMUZ4ZUNVeW1CYi9UcTB4dThlMmYvL2pzVkd1K1lKQ0p3RUN6?=
 =?utf-8?B?MjdvdmlGWjBwVVpxbzJFSkpKdWVJUHNibEhRU3lvOFVkOU43d3p0Vyt2ZDRh?=
 =?utf-8?B?VmlyWnpLOFNsUE00Z0UwRXVZWHNBb3FVTXIxNEF1dVdwZVcyZEY3cmg5Q2gr?=
 =?utf-8?B?SUVBcmI3S3BvUStrZmRPYmc4aEs5QXRUQ05EL0d6MkFpdkJPcTFIclVlM0ZQ?=
 =?utf-8?B?L3pSWlFnYWZwbTRTWjg2dnVYNnIxVHJGclVxdHFZY0NqeDhuT0lDdWJWb2h4?=
 =?utf-8?B?Z09WRnpYK3pESGxFOWxXWTVFSm1iNmluOEhIMUM3Y04wbTl5dG8vSHRCUmdE?=
 =?utf-8?B?eVh3clArTm9iQmd6cmFtTG5SeExtRlh4RTBlT2hZa3pPcnlDVFVITStJV0Rp?=
 =?utf-8?B?Yk5KRVQ3MzdkemhzQmFVK3U3Mld4R3BJUzNXdjMwc2hDSGtzV1NTaEhUUlN5?=
 =?utf-8?B?aUtYNm5xQjJlQTJ5aFRrYnN4eHRNUXZ4djZIcXlXUldtSmtxUHdacFRZemI4?=
 =?utf-8?B?cmxoejA5UkcrZ003U2lmOWFyYkhwNERrTGNpeXBuV3Bidzk3VTN2bGZPWkx1?=
 =?utf-8?B?VFM5QWQvOStVdXZUL1daSFRJRWlWdXBSRFIwd0xUaE1wNlFvTjN2MmxQLzR2?=
 =?utf-8?B?TUt6L2RFRjF2QXJvQTl2SE1maWhJY203ZjJGMEQxNnNodGt0NUc5ZWR6b2o5?=
 =?utf-8?B?UTBvL3d1YWY1eHVGa2pWSDViTE0wQTAxWkxyRmNpa2xsVVR6WHdmYUIweXBt?=
 =?utf-8?B?dlc4WnZMZHlSaGJ4NHFKY1lZTHJ2R0tPRStXaFp6VGduSTJrVXdOOHdMMnNU?=
 =?utf-8?B?b0NNK2U4QjE1b3hsN0IvTTVzRU5weERja0tvQWNPL09razVCRW9YL0syV1RL?=
 =?utf-8?B?TWxOQWpQZlNsVnBqY0pWQXc5cVlHOU53YWVtZVpaTEpCdUxxMkkvc1lHNXhD?=
 =?utf-8?B?L0h0N0xUbEtwc0plbjU4U1A2N3hDL3Z4NmxMQzhjL3hvclVwZENIb2ZCY1dr?=
 =?utf-8?B?bEtIeUVyVjZ3all5dk1oWGZIazVTNmZRdU53NzgyQkNHSFQwK01OL3ZOY0ZT?=
 =?utf-8?B?SFY4L0ExSmJuK29JRHNBOFl2cjlNUGJEdEo5Y0R3bkR1bndWUVNOUlN3VjB5?=
 =?utf-8?B?dHF2bEpWcm1QRkY3TzEyUmtUUjdiT3pnTjJEN2s2bmsyeFV4b2RRd1hqMGpD?=
 =?utf-8?B?SnpwTlg3Z1d3anFNc29xaGUrZXExajJXSHN4Tm1PQi9kWlJ5S3RzdkhyTkdK?=
 =?utf-8?B?VE4xV21BNmpsMS9QdWlwdVdDbytaSzlaY25Ucis1U3FUTHZ5NDhOVW13R0oz?=
 =?utf-8?B?ZkFDRm4xb2gzemZrM0JMNEh6UU4wZVczbDZjeFEwUklrbXFvRHI1dUFBMXJv?=
 =?utf-8?B?RVJaNGl2aHZFamhCb0xNTXMrOU0vOHBoaEgyWHZtVWFuSit3RSs0ZEpvZWFU?=
 =?utf-8?B?T2JxK3lJam1GOWxoUGM1YnNPMWc1STBmaTNYbUFwc1pFOFRpdXQwdGFmd3pC?=
 =?utf-8?B?THk3MmI3VFYzK1BOSUFnRUNabzdnM2JRNFpsWUIzMUQzc3duY1lkTERTSFRB?=
 =?utf-8?B?UFRUdmp1UDY1MzVpdXIwaWtTOFNMUVFSOE5pWmlRZThhc010RDlmQlpFeGRW?=
 =?utf-8?Q?wUzTDHB8j2tAqPi2YkISjJzP2?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8d4eeb-b601-4a5d-7566-08dc80fac4e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2024 22:49:31.2961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UpDqV6YAL8HOoSU5xykYFlrxu2cUl8iJDacf6qoQntdnvENyq5NgP42lF8jjIk3bWIee2o355T/l8Y5k+3qZiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7471
X-OriginatorOrg: intel.com

PiBidHcgLi4uIHRoZSBzdGF0aWMgY2hlY2tlciBJIHJhbiBkaWQgaGF2ZSBmb3VyIG90aGVyIGNv
bXBsYWludHMsIHRocmVlIGFib3V0DQo+IHVuaW5pdGlhbGl6ZWQgZGF0YSBhbmQgb25lIGFib3V0
IGRpdmlkZSBieSB6ZXJvLiBNb3N0IHByb2JsZW1zIGFwcGVhciB0byBiZQ0KPiBpbiBtYm1fdXBk
YXRlKCkgdGhhdCBkb2VzIG5vdCBpbml0aWFsaXplIHJyLnN1bWRvbWFpbnMgbm9yIHJyLmNpIGJl
Zm9yZQ0KPiBjYWxsaW5nIF9fbW9uX2V2ZW50X2NvdW50KCkuDQo+DQo+IFBsZWFzZSB1c2UgYXZh
aWxhYmxlIHRvb2xzIHRvIGNoZWNrIGNvZGUgYmVmb3JlIHBvc3RpbmcuDQoNCldoaWNoIHN0YXRp
YyBjaGVja2VyPyAgSSB0cmllZCBzbWF0Y2ggYW5kIGl0IG9ubHkgZmluZHMgb25lOg0KDQphcmNo
L3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwvcmR0Z3JvdXAuYzozMTI5IG1rZGlyX21vbmRhdGFfc3Vi
ZGlyKCkgZXJyb3I6IHVuaW5pdGlhbGl6ZWQgc3ltYm9sICdyZXQnLg0KDQpXaGljaCBpcyBhIGZh
bHNlIHBvc2l0aXZlIChidXQgSSBkb24ndCBmYXVsdCBzbWF0Y2ggZm9yIG5vdCB1bmRlcnN0YW5k
aW5nIHRoZSByZWxhdGlvbnNoaXANCmJldHdlZW4gdGhlIHR3byAiaWYiIGJsb2NrcyBpbiB0aGlz
IGZ1bmN0aW9uLg0KDQotVG9ueQ0KDQoNCg==
