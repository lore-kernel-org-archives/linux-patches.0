Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8D35675B
	for <patches@lists.linux.dev>; Thu, 11 Jun 2026 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781212952; cv=fail; b=ALiF2XJTEWkSGqLNWF2+v5sqi4l7lrmIl5IZiYS6SJQrPQQdh/kc9BStR7npoaQfOYelj5/SsYdUMdBC3wM5E1PPh/vERyjtYIX4V5qJX2DYBxuNM83cvgvaVmgpEZwndtJv6ZqeMfzWj/n33CjlF79sGbI6QJJ7yJjXNniZDhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781212952; c=relaxed/simple;
	bh=difp0gdZvpuEdfjjis+VDlDjyaUEoYEStqfKwRN4r4M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SRghSXz9AMtN5jLarMru1TzwcjvKmInExTd7sbBTdGDg7OFOAzpN1dqUs3Ku2/3dAlGTVI0VTX4Vc5WobuAOcykrln/+Kw+g1PAr4AYhBH7kxvUq27nohK6pplOKL9t2jJd0QbYUBMknXr2BulQicoVHjZPHXmDx9HaqP07t8WI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TwNDx9Or; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TwNDx9Or"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781212951; x=1812748951;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=difp0gdZvpuEdfjjis+VDlDjyaUEoYEStqfKwRN4r4M=;
  b=TwNDx9Or71MIWoP+1gqHoffb0WwDSh81lGd9A1Oi/1Z2zbx1XSQ5FLCY
   IkGFrQwcuamGDqt+zT3QYlYJvlesED1Q2x8YuNANI/8G7eJV6Sq8KujyV
   HPE6L/eNOKvPpFKOngKenjurUVaXpyn7LRC3qKZvO8Lk4daB7dRd8bjEt
   XsaIua2138HUbJqahUYTTR2RQ+xerlFXVcOYDYHyCkGP3FdL95ljv96PZ
   msTNQctxUFa1Dqj8PfU5qNuezW1hQ3DmhfxMAu8axc/shWUQ1ENGvk6GY
   WS0KeBGIN4EpfGsdkUYCwvNyjwcQrt3s6o5JbyV4nJObFD/Nt9CkLLBxD
   w==;
X-CSE-ConnectionGUID: mxQAFYkCShqK+czSXZ8KOA==
X-CSE-MsgGUID: OpRRR4gIQIWMat18Fg8OBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="85939888"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="85939888"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 14:22:31 -0700
X-CSE-ConnectionGUID: +brnF8WmTJqUjzzJnC+DNQ==
X-CSE-MsgGUID: p9diNdnPSiu0943DEbmtAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="248509352"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 14:22:31 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 14:22:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 11 Jun 2026 14:22:30 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.65) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 14:22:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dOjrqWcb3TxfS1n4VA3PjPu9EAwxonrsjql15SZvrQDFhEGw9jUu/QswcqroL9Rb3kP//orR42UOLLSNHPOLfSe8D6T8lMV2U9yTvHIRnNeiujci8SFeWVfSquRVUFfAddhAxMxFoaOKY/cLpomSZmUcppGNiaZz751Wb0IZDbeFAWlKWVW1Z12q0GarEzHG8pxe+xPBLT1mswNSFsTMWrj+wSfAZ0wsyEndw/n+0MBUqoaIRk6lrtZvcMzmDv4NWfOiT+zYJoOTp28TYetyCHgenUQgv2rG0Ah1UiAUJdwaLCPtq/3HWxQKtX1J51U0JT6rQRaGdyzlQl1etxZm/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n20mnnrmcCfZ9OG1Myc+o4SCZyAX01XBEm8gZcblpls=;
 b=BQK3hvVc2wnCdr+yoHyQzXujsLyywMS6XQGAlTJzGW9z/ISkoC6OU0VoBeYxgtpecUPNpUJg8hgbJSSMGVDf0hQtD5zsQzW57x1mW/uEv7Ni0na0TNHtcBuj48RfD1GpScBSxuq8zDaSUMiYzB6qBR6Ig8knHdsa/lZKIOeWVKhwhG+rOWS6DJLf568lMfrF6QRcF8dU8vHjI7e6WjB9tX5mejyh4lKemtmLLcW+zFZ8Fn0ICXiMqwpDtetpAvhsfjSCT9C3Kym3LeK3KjNH47CDcSkPgQZ0UC6uVWjuixhavONMk00nnHwB/0QPVyQv5deic64MSK0hsn4dWcWX4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CH3PR11MB8752.namprd11.prod.outlook.com (2603:10b6:610:1c2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 21:22:25 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 21:22:25 +0000
Message-ID: <84004bd5-db4d-4abc-a676-6565abf6320d@intel.com>
Date: Thu, 11 Jun 2026 14:22:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
 <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
 <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <a1dd1858-a6d1-4760-9181-ca30de3a1510@intel.com>
 <aingld8Hoz-x5MTj@agluck-desk3> <air33e4js_onwUik@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <air33e4js_onwUik@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:303:6b::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CH3PR11MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fcdd667-a4a9-444c-6cba-08dec7ff8871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: zUvSUFm/HJ/LX7wo2OmKRqhhLqlfm1AaJWb0gW3H/EcXpVLl0jw3vfEEnYmZjZ+k52zu9kCTMiUrEfjdGUBSe+p5xqiqShxcyg7Nmd0KXoS1B/HgmSJHES65l9nIod0ETfG800b7Teqe3+aCLK9GjjYSSIkgY/d5pE12hfEwjeUMd/05aGyfOTR7305C1RQMZEp5NY8Z8n36E8bze1ajxdnD2a4Q+ZDydsWUCNHT/+TzYErb/Xojn9ejsOgTZoZaGy4PNFhR8pS44c6dmtfOja7rECNws3Qvi1/M8JZ9XaiXF/OoT2YGszWDYHD4cRZAz8HKSKFcRZTtI4/6LGs2ZXvAYl1MHDPIBLy7T1koce03QjIoShUPdFbmbKhrW5mgSaXVGbjZNIfyLISTTFfK/NRFRRHo0O93VpCxl5OMYKIyVS0lQBngU6SRT0JAtuDvtMnUr3ogoLLeAluBbq+c75mzYTg7aYx0V3XPKLT303NBmwjKddxfUjwYec29w8ztmk8djebJH6AK7jZ/45KuWtgEv7kA/BHv1AWghTkJ163JFuh+OjFrVbaKCyuv+Uu28zYkPUUiW+ejux01WhBo1SV93AvmLTLIhHg/8hzejg3W9vbsAcB35o6PgXK0iBUdjV9Bd712WwjM5hEo+XsNJ6m5Yceks4rUaF8nVgls4/ezfJcytvIIJidD6jych/6f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2lTZVlVZW5tOGFHQ0J3TnU5bEtLZUxzeXYwZ1d4ZFhiS091Rk41bWRMTjJ6?=
 =?utf-8?B?OVVEMDFMTFZKbU85K095UDhVZWY4ZHJTNmJMREN3RUxiN2hTZ1M3aFVrQ256?=
 =?utf-8?B?QXB1WEtRSWpEdDlkUlMrQ2Y1RXE4ZFUzRDM4NzJLSjI5U2xva3NKR1VUTFBn?=
 =?utf-8?B?L1orOW1Ta0N1TFJzeW1RcmRjekMrckxzVjJqdGRZdXRHRU9YendKQk5ZSXhF?=
 =?utf-8?B?cGhVV212elpFUnd1QWdzWVVGSUtDYzhDemVwMTdXSFhYMHdqT3M1N2diT0wy?=
 =?utf-8?B?QWtZYTA2ZlZBbkM0THl5TVBMUzdtcmM3dk4xTVhpa3NHR2ttSEk4QXZaeWFZ?=
 =?utf-8?B?R2JaQVZoejBYOXpUYzNJTjdwVjB0dlVjQktCUVd0dHozRVlTUzAyWmVwRVJu?=
 =?utf-8?B?QTAzaGNzcytGQTlIRDdzbHdNR055SlljUEV2dm1CdDFzYS8yOURVRDdZMllF?=
 =?utf-8?B?YTdSOTBKQW96TmxFeTMraUJWcjdiV1BWNEtBZyt5bnBVaGgzT0IrRDdYNndZ?=
 =?utf-8?B?Mnc2emRHZWFwYkJhc3dPNUhhNzZpS3hjUzd3bitnYllLdWdEcndhb2N6ZlFm?=
 =?utf-8?B?NUVuQlFQeG1SZkdNUUxWNzQxTXdlSDdtNXBqTFNidnl4VjJwdHZ5dGo5ZVZM?=
 =?utf-8?B?aS9BaGhEK1AvRnpTOTIwSmtwZWFhY2xzaDFWZ0tXWENwbHVEZ1N6dzM3NlNm?=
 =?utf-8?B?ZCtSQ3dpNnkvS1JTYVRwQ3dUTHpvVWpucTBhZlhDZDlkRWpZcUcycWQ5OHJa?=
 =?utf-8?B?Y3dLRUxXKzB3Z2FQd3hTblViWmloMUxDTVMrSWI0UXY2bEdtdDdtVWhsNkpJ?=
 =?utf-8?B?aTZsd2k4K0xYUVdRZ1ZLOGZPWWQ5dFcxaytzUGFqUXFyQ1FOdFVraHRmZzY3?=
 =?utf-8?B?UmtVeU1KQzk4ZC9UMFJ4OGp1TUNDODR3RkR1d0VCRGtoWUtROEU0eFRsUnFW?=
 =?utf-8?B?Z1RuZFRJRnVWTFZDOWxETWNDUnBOYm52ZDlWb2FuYitEbnA1WFhiNkRFYXhD?=
 =?utf-8?B?U1hrcDBrQUc1Rk5BMnY3em5sN0krcEVBQ0pQRWZXMHJCUkZya3l3ODJYZ0gy?=
 =?utf-8?B?SEVsL1FQc3BXSjJvZlUwTkxKMXc4Z2hseThJZUZtVEM2cmt4Rk5KN2theDFD?=
 =?utf-8?B?a2xpU1BSbmtFaGxoOVpGRGZxUDl5L0FJUmg0WlNseXpUL3ZFOWRZeXpVMHg3?=
 =?utf-8?B?QkwzTWdWSGFhdEI4WlZOZkdsWWU4K2MyNkRwdTRBV0VEUE1MN2RTMnhKdzYz?=
 =?utf-8?B?RjdmVDR3UVU5UGFCZ3F2b2pFdG1tRFJYZGhqTHdhVFJIZWVyQmZleE9td0k1?=
 =?utf-8?B?Mk9IVGkzN1VNMUtzV1B0MWg1R1U5SUgwVml1VWx2WkMvbER2UHhOKytFTkFI?=
 =?utf-8?B?K0xwdVpXVVdTMklqWHFZWG1nZE9JU0k2clQzRzVlWlgySklITEVWdlZpd3VE?=
 =?utf-8?B?N1BYUnAxL0NDYU5wZGlQaFZBODZQZnI3RWttZnhyOG8xWG5kTnhFVWpXd1ow?=
 =?utf-8?B?NEEyU0FTWndLbW9mSGY2VVg5eGdmMThiY2xlL3Y0Ynh4RVlvUFJSSFRRNVoz?=
 =?utf-8?B?Zmc4cDFrZ0NyYkhFMkZ6L0FjTjRFdTNIWlczMVU1T1BRbHUzREdzNVNCYWdu?=
 =?utf-8?B?R0hneXNSYTYwOXlURFZBOTZkSWhOYU53V0N2N0JLcTE4Q1FHV2FjQ1g3T1Qw?=
 =?utf-8?B?d1E4MDBtUTVhSUJJc3hKcVVnWmU5RjJ4NzZZTFdNUUJCbkVGYjVwUEsxaEhH?=
 =?utf-8?B?TFBEeXppcGUycWZ2aElPZDYxbGIzNWxTZEkyMzdEM0cyK2N5bmEzSVBGK09L?=
 =?utf-8?B?eEtETUszZjJTVkx2bktReU1DM2hMZ1JsczlNb3dsTHl0MkFuSUtNbE42a0Zw?=
 =?utf-8?B?TjBqcmwvSGc3ZC9qRDhUc0xmMnVJRmtrcWE2bXdoa2x1SkpLYlgrMUhpYWk5?=
 =?utf-8?B?ZjRFU0RYWllBMXdUMWJTdHBWc1ZyUkU1blRETzNhaUN4WkVLT0FKUkhjUWVn?=
 =?utf-8?B?UGZKTjVCdUJXV2R2VDE4V01WTStLYmNuZ3JkbHFFVG1rZUhyWVNrNHVEbU9s?=
 =?utf-8?B?SkFiSjl0SnFWNjFnZVB1NDZKS2tselZRV3JvUXNUQkwvUFpkS2ZZQTB1OUU0?=
 =?utf-8?B?RXVhOVZhdmxtTm94YlpDRHZWd1F6RmNVSENZNGw0V2xMR3gvb1d0cmRxWWkw?=
 =?utf-8?B?MXNsbG05TmphZms2aFJnMDNVWlN0UXhaUDVvZUtnWUsxVUdYUml0YUlxR2dG?=
 =?utf-8?B?bW82NmgwR2VLSXljdGVqaVRseTFCNG9aekpxRk1vKzlCQlFSTE1YN3YvS3Er?=
 =?utf-8?B?NmVORzM5V2JwUTB6NWtRbm8rMFo1UUdXcUlPVE9GOHZOUG16RlBBVjBzdmhS?=
 =?utf-8?Q?WYZbROY/yLF/6ins=3D?=
X-Exchange-RoutingPolicyChecked: DwpOgJY8cXNA+evIrBch8IhuMKLpABL8EoP4kaFoK9vjAvXf56GjhEnYb2bnSBRQgIOgOBcDmTeeSm3VaPBgVGEGjOGkXHrq+G52Wj1cGG1Z9N9CP3EavL8MrfNxFv1RaB/vYQmaU7rvgtYnx5c2hVbGgqTmX/SfQmZmzMqk4g22/4y0OEZw/MaejbyaAcw3T5WTkR9UAKMVwoNXwVjhMLM3opaGuDl/iiMliz5owNCosbVkDUwfyrY4SgHuYwaadZncYWCoMQXrRIv1fAx3XQngx0YUb2mzNUs6Szy4n/KTBI5aTDvbVXSIdnDki0ZX1N2GjEzZzYLRtOcccaaf9A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fcdd667-a4a9-444c-6cba-08dec7ff8871
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 21:22:25.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZFyxcGlpIEaHkB+WrJxSt07pJh02IR31PVCXpS2XlZz+sz6fprEGohAE50tU8Am0wGCVMHz7yNfRb/wPePaA063qjlY2NJKtSZb9bxHKcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8752
X-OriginatorOrg: intel.com

Hi Tony,

On 6/11/26 11:01 AM, Luck, Tony wrote:
> With renamed variable, and comment. Is this clearer?
> 
> 
> /*
>  * intel_aet_register_enumeration() provides the value of "THIS_MODULE"
>  * from the the pmt_telemetry module. Note that this is NULL when
>  * CONFIG_INTEL_PMT_TELEMETRY=y so it serves as a flag to decide whether
>  * try_module_get() and module_put() need to be called.
>  */
> static struct module *pmt_is_a_module;
> 

Using a single variable to contain both data and state has caused problem in
the past. Could it be helpful to create two utilities, for example get_pmt()
and put_pmt() although naming is not at issue at the moment, that contains
and makes obvious these "is INTEL_PMT_TELEMETRY a module or not" checks? These would
then be no-op when INTEL_PMT_TELEMETRY=y. This would simplify the code in the
callers by containing this logic and not rely on callers doing this check so
many times.

Even so, it is not clear to me how the AET lifetime will look like since 
INTEL_PMT_TELEMETRY's .remove() may be called at other times so resctrl
may need other hooks that could replace this module handling.

Reinette

