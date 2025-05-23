Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67661CB518
	for <patches@lists.linux.dev>; Fri, 23 May 2025 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015884; cv=fail; b=ZAMqIVT0pXIVEilvr1rKVjToU82kR50JgRDSk4PrFVFffkjSwRpO0CON+RnJmCeL/eAIz4J+dgdm2F4H8Vu23NsajbjiYAzmzWlIQzGHm38V9yLkKkE/XyHLzfhUo7Nfifw588UcCul1LE1rXEpBvb/B42yZBzu86OfuBIgge8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015884; c=relaxed/simple;
	bh=TNC29SzR/vRPZZ/LfqvfYdX98YrHfpQ8RFlphrExKVo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uortVa/HRV89EYfo47akuOjCxFWpjjLXb7eWWYJxuRBpNEm10cn8iH+qYM1QSPUEZ99Ww0tIF5wKJxGrtYfSmJqoJ5c/JIXVQJoVJOQ0VT4yzlHTj/CpjAb/7sg7h1xvwPNN7RUsZGQb0C/1UoIBbk8A5JqnYVrjo0ZSw11sjNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oK+PH3zI; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oK+PH3zI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748015883; x=1779551883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TNC29SzR/vRPZZ/LfqvfYdX98YrHfpQ8RFlphrExKVo=;
  b=oK+PH3zI+DdhCDumG5NqKj8ckfTgsFVqrege3oKFBhdkpUYtHqiqCLPN
   PdZc/YcERoSdJdyyRgDCtMwdTixetMYi1HG3Kt3UOA3hTWnZkwSVIUtWg
   NeEpglOG7PVji0U0qpXSvFQj5RqNDt108ucce3lOKJzvH9bAGBg2uQTaX
   ThGN+zDcR0fU39uJjTqNqyak+MYqZvqaQluBNuUAl7EnbVQK2v/U37Bmh
   EXkyrprlgx+Fr1xxdiBAJyUXolHiep8U2QT3JjiZ1Cc/hWqVjA5ardFRl
   XnXC72IDfJa3KbrjTy2OLzph9WxuxRdlQ5tlS6+r4juE79vNLb2DM40bm
   w==;
X-CSE-ConnectionGUID: SEIwLys1TFO8O0VTlFZryw==
X-CSE-MsgGUID: uIE8740qS0GuaK6GD5NoxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="60730315"
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="60730315"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 08:57:15 -0700
X-CSE-ConnectionGUID: E0ZsHyu6Syi3/cXt73pBrA==
X-CSE-MsgGUID: N041mueGR9yu6R8WTpNbgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="145917171"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 08:57:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 May 2025 08:57:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 23 May 2025 08:57:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.79) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 23 May 2025 08:57:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7EC8FTMPGSkAATCtSqo65bpevlgfqz111qPw7JpaybnyG79F8ElI/7hDeevj7fDGklrBBauAUMit+M1Vq6JObr4OnPO9o70vwHWe0toH4Pd3iylaAyDbKG/wGy7fo648m6natzzxLeXgkiFWrOgVAUK+fcbMmcAonox2gELrntuP61aFJku+xtCzgt5eiu8Ge1WASgM4rOBVweU4W8nC2fZeAOUEIyicUE6C6PZYdy6EPyfYhw8IW3tC7eo1ccVOH4F6P2lQPF+6pOJiiqI7FJcbi4JPl4SKhZEOcYctxC0apDvfTLErRZmBZoIzbLkZ0X3qi/FqHrJ4+jqn5iZxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNC29SzR/vRPZZ/LfqvfYdX98YrHfpQ8RFlphrExKVo=;
 b=pEFtRwIW7cgE7UOy19TpBMwwV4CSh9thBpxbSJrUEZvq0CKhNL58zT2Xex55aKcJAQk8T/ne+eJImv5Jez7EpUrwCuOzhAwMh01V4TQRuFW4x4S3qoKrRgyBoujCE6ozNDUEO+gRfhCSEW7djXK5j4mrD2e4jVJmie+DnuDrTDTKBq6LwcxW7M8G4k+7XGstBdN2Z5O0MIc4qdsyjuHpDcbzQRaqFdu03xgyhailinlbn3ibARONkqKg7RdaDMjWDeqEmWV2U/Y6YslRNi0amKNOxQ+NU4p3KRtxO2OPRBY0hFCbX+UOxvAKFy9U4oYVMFPb+34NqXIEZyJKcqC8hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ5PPF57F27BA08.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Fri, 23 May
 2025 15:57:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8722.031; Fri, 23 May 2025
 15:57:12 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, James Morse <james.morse@arm.com>, "Babu
 Moger" <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, "Dave
 Martin" <Dave.Martin@arm.com>, "Keshavamurthy, Anil S"
	<anil.s.keshavamurthy@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v5 04/29] x86,fs/resctrl: Prepare for more monitor events
Thread-Topic: [PATCH v5 04/29] x86,fs/resctrl: Prepare for more monitor events
Thread-Index: AQHbyqLS5Hh79ReWPUS2+G8Oc2vF0rPf7N8AgABz+JA=
Date: Fri, 23 May 2025 15:57:12 +0000
Message-ID: <SJ1PR11MB6083946F00E5DA47754AC7D9FC98A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-5-tony.luck@intel.com>
 <CALPaoCj8yfzJ=5CkxTPQXc0-WRWpu0xKRX8v4FAWFGQKtXtMUw@mail.gmail.com>
In-Reply-To: <CALPaoCj8yfzJ=5CkxTPQXc0-WRWpu0xKRX8v4FAWFGQKtXtMUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ5PPF57F27BA08:EE_
x-ms-office365-filtering-correlation-id: d16a27cc-4a7b-4a6e-d630-08dd9a127b0d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RC9uMlFkaFhCZTVrVzhGSzdJc050QjlCanlnWXY3aDFJODk5NmNSSzhlMGg0?=
 =?utf-8?B?cWhqY3pYeEdmL2crVjdkTVhSSWh6eHNpdjQ5VGlxY1FxQURWQXFveENHSDJX?=
 =?utf-8?B?WWFEZ1FqRmcrUm5YbWtyZGRlMFNCQ2RLaDNVMStmN3FwVUM5QzZjcEN0OEl5?=
 =?utf-8?B?QmVDZExUdy9oaGQ4Y0IvQnNtcXRrZkt1UkFFMks3aW9sVWFwWC9zcGs2OCsx?=
 =?utf-8?B?Q1pkYzVwKzdVNFd6bS9PeTFibXhnQ0RTT3BmRy8wUGx4aERXbDY1WTQxbGRs?=
 =?utf-8?B?OXVDV2x1b3R0TnI2V2R2cTE4SHdoY1VyQnhBVTRTdDlaaFZwU09PM05LclZJ?=
 =?utf-8?B?dHlGdEpMMVNKMzE5WC9XMWdqbVJ0dDNGL3IyOHltVkRmQUM3M2ZFWjRZZkJk?=
 =?utf-8?B?OENNRzhQSjNwM04yb2YyYnVoQms4RDVmRjhqb0J6Tll4eU9yUWxHejJwdnpK?=
 =?utf-8?B?a2hPcy9zOHBrS3MrV0duenUyZU0vQmttSUFHN2xZNThmWUlpQUNXTlNUbEFp?=
 =?utf-8?B?MzI5YkwyZHBacHorSVdUN3ZYUHdRcHVBM1htUGFNU3dzT1VtMjdQSW5KQnhB?=
 =?utf-8?B?SjU4eXZmSmw3OTBHc0NqVWxFK0dLMDFwYnlaazdUdEd6b1kyeFE0WTJBVGRL?=
 =?utf-8?B?Tms1TDZBZzBPUFNXK1dyZlJYNmY1Rk5GNUUvMzBGNHJrcEgxVS85S1NESmh0?=
 =?utf-8?B?cVZMUnZDRHE2bW50SWVnaVhKaXVlR1ZLNHVPZkIzL01zV3lER3M4azVqU29s?=
 =?utf-8?B?U0lwUi9EOVM3MGhUYkJveEZoY2VJZWVEeC9aS3RwL0llY09lcGx2bC9JSThZ?=
 =?utf-8?B?MlBrZ0FoVHJYM1kwVGc1Y0VoY0Nib3lTb1FMMXJvdGRiSEZtRThucjlWSHQr?=
 =?utf-8?B?YVhzdzNRWFowdmJVYWZJd3FDZmxpUlpkSXhDREpWaEdsTmU3blJTbTJET1VY?=
 =?utf-8?B?a2NRTHhPVXRxY2hyT2hhME13OUpxOW4xSExSYklSOFNjcWM3L0ovRTQ4S3ZJ?=
 =?utf-8?B?TE9QTkhNZzVFWjkxNEdBWlNTOWpZSmFwajNmanRGTGdWdTZGMHcvOHBoOUlu?=
 =?utf-8?B?L0prMUQ1bDNKenFlUTdxbWdOcDNuMnk3Z3Y0VGFOMGVMd3pvQlhKVUlBdXZC?=
 =?utf-8?B?R3RuQVpIb1ZyM2ExUWtOZnh1VHFTbEVMT3JCcDNEekVoYmpGTGkyZlJsU2JY?=
 =?utf-8?B?cHFndlpLdEViYVoyTG9DaGpPN1dSTVhYZDZ3L1BwZG5vOUlHZCsvVVFmQlFJ?=
 =?utf-8?B?RFdsSWo1R29JWGhzdmFHNGZxVkc2YW5iak5ESm5VQnpQVjdOTmt0MHk5UFNw?=
 =?utf-8?B?QVRzSWVwaWRzUWFOK09ESkV2VnM2SFNTYUV2VC9OdHozOWIvOUZkNkpIUDZE?=
 =?utf-8?B?UnFMdUR0aXc1YlNHcW5qamx0azU2NlpiK0NSV0txTi9wdnJMa3Z6QSs2dElZ?=
 =?utf-8?B?ck1sWUtOYzV1VkxvTGVCZU5ZYnd4M2hQdWY5UVgwQU8yYi9LTUUzUXE0bFpK?=
 =?utf-8?B?bnRVVzU2UjJoVmdUaWtBYjNscjVDTEhtUGplL0xvNlh0VWdXUy9uSXU5Vzl2?=
 =?utf-8?B?aUVZNWJUMC90QTcxakxoYm5pc2xsclNjMFZycUhyMnM0OGh5R2lSdW9HeUoz?=
 =?utf-8?B?QXdUMjJhc3pFSlJjNHA0OFZ1cDdnSWg0akFjdWFvekNHL3hpV2VaR3RYOVZy?=
 =?utf-8?B?MU9zSWxla29YVEhGbEhDTUVXKzJ2NjFkTGpJTGhNRVZzUldiM3MzVkplMDdU?=
 =?utf-8?B?Y3hwUzdxbHV3TEloWXh0a1E2MkJSaU0wdjVxQmZPb09rdG9nbXlaYXVvMnBT?=
 =?utf-8?B?SWFkdzZQTlZ2TDRPVWdjNFpIYXF6L0lRWHJ2WXBkQ255bE9Bb25XQVV3bGs3?=
 =?utf-8?B?b0Qra3RpWDQzd3VqRzdWNndlS0ZOUXI2dXpnOVRNS0M5bEpPditQb0RUK0dy?=
 =?utf-8?B?YlFRb0ZqeTFHa0txR2NYLzJFa3QyYk9VOUEzNkdtK2ZiWDZZMjJvdUxsRm5D?=
 =?utf-8?B?TzNBZUw1Vzd3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUplZitOTTJpYnkyZ1dOanNIaWlxdmRqZUMwamxQUDFhMExxcEVTWDJmQzJx?=
 =?utf-8?B?U3AraDBGRzh1ZERBQ1JyTll1UXNFOFlsT0ZYQ2p1OFpYU2M5d1N0aVFtaDdF?=
 =?utf-8?B?Vm56VllMR1lHQlUwbkpUcUU3K09WaEpCMDdJTlZwRk5DbjFLWWlKeWhlMVNV?=
 =?utf-8?B?ajFIQUxhUmNtM0xWZDZGTDFUcDRUcU82Yzd1WlYwU1dGQUR0YlZxV0RqL3Vx?=
 =?utf-8?B?VEEvUS84Zms5OXB0VENlUmhRUjcxMGgrVlE2Q1ZublZsMEhrZHlMYXRMSXh6?=
 =?utf-8?B?dnZCY25qaE1kZmUxUGlyczlXVUg1WEx5N2RWSjZGY2FwV1VkaDVOd3ZOSHI3?=
 =?utf-8?B?WSs0blhOUjBjSndaR1N2Y3hWcy9DcGNxaXRUUDZ6K3gvZUNTMFhwTFRueDdN?=
 =?utf-8?B?azBWWUl2VnBka2ZSZlZBMWxpaGxKOFRtSjYySEdhN0VNMGRqMFhZRkJmc1Ir?=
 =?utf-8?B?Q292azNQbVp3VElZY1E2Z28xYnh6MjlLTWRTdlJZWVk3K0V1dTIrY2dFeWxy?=
 =?utf-8?B?Zlk0MCt1T25SUXgrTnlKVEk2Tkc0ZkdoS2JsbTJsSVR4ajVwWkg2UGJRMktR?=
 =?utf-8?B?T3B1OTE0L0pwY1o3QkhyWTh0TnorV2Qzb2tBVmlKSFk3b1VsQ1hRR3IrSTky?=
 =?utf-8?B?T3hWeDQzYlhHeGsrZHZNRk4vNkZkY0VMY2hCeWRseGxJd3RhYjcycWg3eEc4?=
 =?utf-8?B?VkJ0bWQ3ZWxsSW1TcWE0UHlGemx5MUk0MlhxZVozcVRVdzF1aEIwTWJYbldi?=
 =?utf-8?B?Zzk5UmNsc01SU09rVXVTajJPcllJZm9Hd1FzQy9HTHdPVFg3b1dSVndtZEI3?=
 =?utf-8?B?amJ3Yk1NbkVZWUNqdm5PRGJDdGFTUXpqWUNycjBCaHRJVkFVM0tiTSt2eWFx?=
 =?utf-8?B?alAyL0xMOGlyMUVLdWVXeU1mRjI1bXkzNmN1dlpCS2xadDRMWGk4bm5YV05q?=
 =?utf-8?B?YUIvVU1yNUpxSmtldXBjM2JPNlNpekM3V2FZK2NIOW55K3B2VFU3M3NHRUJm?=
 =?utf-8?B?eFE2MEVoY0tGRUhjT0ZESzRMQlpIaUd5TVFpMEJVcmNnMmU0dFlZamV5WjYx?=
 =?utf-8?B?bXdQZ0dNYUJGS1JjbUFDS2tEeDZ3RkZQRThuZFR2dHhGYk4vQ0FGN1R2by9v?=
 =?utf-8?B?V3lLRkNlUjljRi9jVWczc0ZKYy9NSGd1OFJEMGtranh1VFBDYnBoaHZ5SDdJ?=
 =?utf-8?B?Qit3ODg5ZFhxNFFqOGRXRUVpeW40anh1b3c4ckZDems4c3pGUldRMGdROWRn?=
 =?utf-8?B?aW92dmdOYkNKN3FXNFo0M0Uxd04xN0VLcm00UzE1VGNnNkptLzUxOFlBTG13?=
 =?utf-8?B?TWZrSmY4eVY2R243T3BpblhLTHA5S2ZTNWdOSG9SUCtvUGFMQ0VNWDBZMVN1?=
 =?utf-8?B?blQrcHU0TW5Pdk5VT3l5RkdmQ3JBYUJhU1J3eGNwSlIza25lb1lzUTcyVmRj?=
 =?utf-8?B?NjFVTTJLaDlsTFVNdi9YYTV5eTZkeThscVMvaXFkcGJrV0diYXVOZXpGbEVy?=
 =?utf-8?B?Nmk4WStkcmNaV0Q1b0s5SytGeURoc2ttK05sYm14bDdDT2NyZFJqbU9QWGtB?=
 =?utf-8?B?bUdRTkViOFBnSC9BMW1TZ3pUQ2J1Q2NLblNKUXBxcTVHODBhU0cxR2Vhcm9S?=
 =?utf-8?B?eDFsdWxZbkY0YkJIdTRWeVZHcXdDNldEakU4TllvTUFIQ3RIb05yYXFJcnFj?=
 =?utf-8?B?UlptVkVxREwya29GdmRzVUcwRTU3RWhTRjhueVpkQ0dYMnBTeWVZYUFHZ05a?=
 =?utf-8?B?QkFzR3R4T2gxUENFTEgvMmhWck56ZzJDdW93dEFjWi91YTRWV3JXSGR2dTJZ?=
 =?utf-8?B?THRKVlc4eG9SSzExU0thUGt1MDFjOE5GOW9OWGZ0dmtESXdaOGx6ZHc4S2Jq?=
 =?utf-8?B?eVhvVnVsbVh3OXBaWlhPTU9Xd0s5SG94SEMwOTFuVHBiVUppU3A5dGtyRVlS?=
 =?utf-8?B?Z3dwZTI5WHNQNFNtZ2d1L0VWZGZqVW1FZFVieTh4TTZvNXk2RHRld2ZiQkl5?=
 =?utf-8?B?L2J1cmxhMWtnRFNwbzlIeU1hN1VLa0FkbHZEQlZCWGxYZVB4a212akowb0pI?=
 =?utf-8?B?T2ltTzVxR3pzUE5YcUwxVElKVFozMlpVSGVFbFZrUGZJZFpTbXB6M1ZrYitV?=
 =?utf-8?Q?/SVHdZ2adPscZjLMORHjH5Piu?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d16a27cc-4a7b-4a6e-d630-08dd9a127b0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 15:57:12.0913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aoLtbY+vabHbYdM03dCngv4Zpv/WQ8Vouorvv7P1rvf5DODtr/7lenfX5vjqm/kNtQN2aqEurFncYsTGum8CEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF57F27BA08
X-OriginatorOrg: intel.com

PiA+ICBzdGF0aWMgaW50IGFyY2hfZG9tYWluX21ibV9hbGxvYyh1MzIgbnVtX3JtaWQsIHN0cnVj
dCByZHRfaHdfbW9uX2RvbWFpbiAqaHdfZG9tKQ0KPiA+ICB7DQo+ID4gLSAgICAgICBzaXplX3Qg
dHNpemU7DQo+ID4gLQ0KPiA+IC0gICAgICAgaWYgKHJlc2N0cmxfaXNfbW9uX2V2ZW50X2VuYWJs
ZWQoUU9TX0wzX01CTV9UT1RBTF9FVkVOVF9JRCkpIHsNCj4gPiAtICAgICAgICAgICAgICAgdHNp
emUgPSBzaXplb2YoKmh3X2RvbS0+YXJjaF9tYm1fdG90YWwpOw0KPiA+IC0gICAgICAgICAgICAg
ICBod19kb20tPmFyY2hfbWJtX3RvdGFsID0ga2NhbGxvYyhudW1fcm1pZCwgdHNpemUsIEdGUF9L
RVJORUwpOw0KPiA+IC0gICAgICAgICAgICAgICBpZiAoIWh3X2RvbS0+YXJjaF9tYm1fdG90YWwp
DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+ID4gLSAgICAg
ICB9DQo+ID4gLSAgICAgICBpZiAocmVzY3RybF9pc19tb25fZXZlbnRfZW5hYmxlZChRT1NfTDNf
TUJNX0xPQ0FMX0VWRU5UX0lEKSkgew0KPiA+IC0gICAgICAgICAgICAgICB0c2l6ZSA9IHNpemVv
ZigqaHdfZG9tLT5hcmNoX21ibV9sb2NhbCk7DQo+ID4gLSAgICAgICAgICAgICAgIGh3X2RvbS0+
YXJjaF9tYm1fbG9jYWwgPSBrY2FsbG9jKG51bV9ybWlkLCB0c2l6ZSwgR0ZQX0tFUk5FTCk7DQo+
ID4gLSAgICAgICAgICAgICAgIGlmICghaHdfZG9tLT5hcmNoX21ibV9sb2NhbCkgew0KPiA+IC0g
ICAgICAgICAgICAgICAgICAgICAgIGtmcmVlKGh3X2RvbS0+YXJjaF9tYm1fdG90YWwpOw0KPiA+
IC0gICAgICAgICAgICAgICAgICAgICAgIGh3X2RvbS0+YXJjaF9tYm1fdG90YWwgPSBOVUxMOw0K
PiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+IC0gICAgICAg
ICAgICAgICB9DQo+ID4gKyAgICAgICBzaXplX3QgdHNpemUgPSBzaXplb2Yoc3RydWN0IGFyY2hf
bWJtX3N0YXRlKTsNCj4NCj4gc2l6ZW9mKCpod19kb20tPmFyY2hfbWJtX3N0YXRlc1swXSk/DQo+
DQo+IFRoZSBwcmV2aW91cyBjb2RlIGRpZG4ndCBhc3N1bWUgYSB0eXBlLg0KPg0KPiA+ICBzdGF0
aWMgaW50IGRvbWFpbl9zZXR1cF9tb25fc3RhdGUoc3RydWN0IHJkdF9yZXNvdXJjZSAqciwgc3Ry
dWN0IHJkdF9tb25fZG9tYWluICpkKQ0KPiA+ICB7DQo+ID4gICAgICAgICB1MzIgaWR4X2xpbWl0
ID0gcmVzY3RybF9hcmNoX3N5c3RlbV9udW1fcm1pZF9pZHgoKTsNCj4gPiAtICAgICAgIHNpemVf
dCB0c2l6ZTsNCj4gPiArICAgICAgIHNpemVfdCB0c2l6ZSA9IHNpemVvZihzdHJ1Y3QgbWJtX3N0
YXRlKTsNCj4NCj4gSGVyZSB0b28uDQoNClBldGVyLA0KDQpUaGFua3MgZm9yIGxvb2tpbmcuIEkg
d2lsbCBmaXggYm90aCBwbGFjZXMgZm9yIG5leHQgdmVyc2lvbi4NCg0KLVRvbnkNCg==
