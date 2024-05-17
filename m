Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C831FC8
	for <patches@lists.linux.dev>; Fri, 17 May 2024 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715969858; cv=fail; b=dDY8k0e3juB895euQbNBKtCQ0DoV8fKl7j0FMAp5KGtC4/9JhXoRZvuK/SCUrWqxWkyrxqwbzQf7ZB3BVCv6620t5kyv4sZ3n+iWx1bMNS4YlOjbWs0CZmayYtXia1UIGBLVev4TC6sBRc8vBATYWY7zZoQ6CuTvGff+nSH8g+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715969858; c=relaxed/simple;
	bh=UxrMVfj/v5mka9m6jH+oWK7h3vLNMAsB8288fZzLbP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uAftj4YPV8QGcd7B+itTCMaXiBxyfVwrfLi9INjE4sdC3FCuOLnJ5RQ7XP7HDhJqUsFqUrcRuQQVJ1pHGNQWArUQZiP8G7PhWm7qtFfxt4EnLl6TE3ipDAFGxhk4NJq+HkfaGn9lWfIBNtOZ5O4XIy2MG+tLtnH/KRl8fWg8RTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BsFlC/n9; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BsFlC/n9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715969857; x=1747505857;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UxrMVfj/v5mka9m6jH+oWK7h3vLNMAsB8288fZzLbP8=;
  b=BsFlC/n9o2oKoz/PCKvBnvcOABqZDw4e/G7DiUDgCEavWb/H/4444Zuy
   ylRwx8x/ytTH6hTPQtkT+cxhIQsyumPQeJuhxCk0m6khbije2mcukXG4v
   KgZKg52BnOaRtATmnRoSgE9h2CYDBOKvUx+2NvoFiT8uudfjw1ZiFExZY
   Ayq1NqxP4nvEtDOcO76sxYcNiAWeMETXZSn/GfC4QG3DhqVitzjYRJzAK
   6eCXOaIPZNQ9nlwKJSZMcCwS6D24QkK0FgaqdTusWEU9MO/fg8/41JTro
   I7ZSP0beQGkV87vXvJFOeyeoQPH8WByd5pKeRAUfYcv0MgfCu+YuluUM+
   A==;
X-CSE-ConnectionGUID: 1M6w0ts8SauwRjvlCEHYRQ==
X-CSE-MsgGUID: j6nEuj+5QvSMR8L2apTYEA==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="15994920"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="15994920"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 11:17:37 -0700
X-CSE-ConnectionGUID: nnzm+A6XQ2WKdtXxSpAf1Q==
X-CSE-MsgGUID: YrtY40jgR/GafbuXjEVcaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="32481602"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 11:17:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 11:17:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 11:17:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 11:17:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 11:17:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVQKAicoL7/q1aZ2xqVu6HX3rv2bSwuHEhkMP3WH1c8dMAh1rXLEuWy42yMmhOX9TfHXgeX++Szu0JCcM1V2CSWuivOUBTg0LHPDqlT+q8KMke5REsZELxjJnWJVIZ2DvCyq6BxGM/tWfwUnBoHtZVT/5wmvgjYW9Opf/79F4dMbEqbND15aoi9a9M7hbfNqbZCRaxT4zznKFlZQ7PSuTQbdFYEJICPz4M45MBb60mF3TkPubZkQcTAdHQ/1dmJ/bPvIXTbnBZs0wFaOg2eStu9G5P6UWfCVpvmSWtIKuKqpAnxwns/TTNGFaYJc15R2EjCFnwhJFV/sYQYW++w9OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxrMVfj/v5mka9m6jH+oWK7h3vLNMAsB8288fZzLbP8=;
 b=HyGOkeCxm1ce4gtdrcn6/gQtgRMvnzY7/VmRelkOevcg9hxiKXHERWy+ZY65LMFio5xSX7fjgdGczNumXiexYJuxdfma558dFEyFZVJ/L9aWK1RUhJQjxLuj3jFzbGeqXNiTnTd9JBmCVi7ACjWyo4bC6LobdkMabVg0I5Yh8CbaXqnGjHQoGiFbr1DVFnOj3wGC7+vckqEB00dKiwecPQTqg7r2+bwdJ6HthF1NBf60d+7bQyp9Ajj5yH4SGuxCDwQVGpBmdQXqEXx34puR9botmvaox/VIc0ldSP7Jc/E0EgNUrfLFUP62wAgbRQ6mA4ZqLCnD89DG2DuSulOZcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN2PR11MB4678.namprd11.prod.outlook.com (2603:10b6:208:264::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 18:17:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 18:17:26 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Dave Hansen" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Uros
 Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Arnd Bergmann" <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>, "Thomas
 Renninger" <trenn@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>, Andi Kleen
	<ak@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHap65BNQUQc7djfEG+qeIcEyvEqbGbgbkAgAAwIoCAAAqgwA==
Date: Fri, 17 May 2024 18:17:26 +0000
Message-ID: <SJ1PR11MB60837E7CD8952271654EA379FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240516162925.79245-1-tony.luck@intel.com>
 <20240517144312.GBZkdtAOuJZCvxhFbJ@fat_crate.local>
 <863D0F06-1217-4C94-B2CA-816FC4ABB103@zytor.com>
In-Reply-To: <863D0F06-1217-4C94-B2CA-816FC4ABB103@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MN2PR11MB4678:EE_
x-ms-office365-filtering-correlation-id: de674ac9-569d-4f3a-d263-08dc769d9b61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?aVZHemRDaktYeEpjMzNoTUJ3K3RwTGdQdzBOZytxOS81NFQ4aklZT2J2MVpx?=
 =?utf-8?B?QkUwWURDRzF5Y2hnMzRJSEIwbm0yak9Cc3Y4Q3hWWi9vdDQ0aDNUakJEMEdT?=
 =?utf-8?B?VGNRTmN5c3oydXFCSHprWVAxbkVkTkU4Qy9kTGljK0pNblEwbFN0Ui9nOUc0?=
 =?utf-8?B?MXFqNkJBb1dYdEg4cU5YQS82T2grbHN3UVkwd0dDWVpCU2NyME5rVVlYUDJ1?=
 =?utf-8?B?Z1QzRFc2S0lDZjBtUnlsQmtLS0dROUVSUVQ3L3kzNkgzNXp6VlZyZUQ4cERD?=
 =?utf-8?B?dUxab2JaM1dEcHU5SlhIOHZKMnRYZFhNbVBnbkF2K0JFSHB4V0s3UDZZelpy?=
 =?utf-8?B?VlJEclpHdndFYkNjazkrblJoTFF0czdENnhNWGdiYVpURzgwTTVhTTgzQ0dM?=
 =?utf-8?B?Y0t2aWZZZXJUbFFzN1pNZUJ3Z2RXcWQyTVJ5dm5zaHZWbDZTK2hFRjBoQk5E?=
 =?utf-8?B?aDVvTlZ2b3NwdVM3TTRiQXAwREJXbFdWeVlRb1Q2T3ZuVnAvYldjL1dodytE?=
 =?utf-8?B?Ykx6U1hTWXo5K0hMbzNrZ0k5Uk9mdFFwamlCV2pMMitKVTBUcHAwN3B0NU5V?=
 =?utf-8?B?c2VFdkxIZXIxaEd1ZFd3clY2bVltUmQrV21WRHhoY1JOdk1yaFhlb01ubFRU?=
 =?utf-8?B?N0xZV1MwOFlwZEltaWF5MlVFK2MwcW84Y0s3aitPem0vK0RhTW5vOTBIdkFq?=
 =?utf-8?B?T1VGUXBVRnhtMGo3TWRzSGJvL2RFalp4R2NTeU11RHpCVUlDTjgxZFhpMjFG?=
 =?utf-8?B?ZzUvRWVCNFJrSTEzRnpGdlNZTW1sWnlRQitwYjRqMHovMVVjbXpMdkx0RkFZ?=
 =?utf-8?B?SHZYM2MyYXp6b2JDR2E3S3ZCRkZuc1pTc3V5VjJLaThEcnlSR2c3MjNnRzZW?=
 =?utf-8?B?RVU5QTl0V2x6L2VNZVVudEhvWDJiekpYWG84OW1FTFRVanV1L3lnYk1Sb0Vm?=
 =?utf-8?B?S3FRY1E1cUtPeDZmeHVHdHBHelpsZWRac1RFbHVpR2djL2hIMGtmRTlZa0VY?=
 =?utf-8?B?dkZTMVdqdytrTWI1VGUyN1VMUXJFZzNvcEh3aWNnQnRBQkllekF4MTZoMnVK?=
 =?utf-8?B?RnhaNlRjSGZFN1krMy9xcTF4dldEQ1RsMkRzb1Awb05hODQ3dnl0dG1pWmda?=
 =?utf-8?B?Rmp1LzNWKytBbHRIMnZPVFBVb0xYKzMwVnhON0diSW5Bb01DdWhySmRiT1Rv?=
 =?utf-8?B?dytaTkljOXllcThKdTEwUDlQT0FOeEZlRnk5WDc4cHlRUjNlRFhicFdGU05S?=
 =?utf-8?B?VzFxZml3T1d2UjRFdm5waS9oTTB4RmRoRzBjbDNLMjhHc1dKMk5HOTBITWFv?=
 =?utf-8?B?bS9UUEE5OVJteXdrRDRvc043dHQra010SUhzUzhzanhtQ3Y2ZHJmbzBYeVZo?=
 =?utf-8?B?TGJLRmd2ZmRZVWtyb1cvaUJEUDl0eFYyemlnY25hZG1KcGRoR0hQQkV6cGI3?=
 =?utf-8?B?cVBsQnNXZlAzdmExaWRoTDFHTUNxd3JkYkJmRDlHV01VME5WK2xhRVJnKyt1?=
 =?utf-8?B?SUFMbG4yN0diSTUra0RiTE8vakJxNDRyRmsrTWR4aWw5M01Xa1NGazh4bTZW?=
 =?utf-8?B?dldXYk52aHY1bDZ2aFhpTGFBOURSYTZVRzRkL2pCbDIwSm9EZ1lFWEZLVFh0?=
 =?utf-8?B?MjIzd3ViQW1WWEY1RHloaTd6SDMrSmJ6ZmJueHdXM0VJb01BM2hkVHRzNkFx?=
 =?utf-8?B?bCsrY2NrNHdSZi9BdG13VVY1VnV6WGdHY0JNZ1V6L1dGanNpRU4ybmNqZVZU?=
 =?utf-8?B?WGp5bDA4cVJHYmtxT0d2NFFCSnUwR0E0UFRTSVRodHg5SG5IRnUyTEtGMVVB?=
 =?utf-8?B?Y0VIcGxHMWFnZDdLT0pUdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zi9TdHlDbzZ1ZDlvKzRWdVo5cGFQU3ozZS9NMnNDU1NJY1RSVnpjYkQ0c1BJ?=
 =?utf-8?B?dEpMWWQrWTNXT0x1NFZmN2ZaWktqRjBPWmJUQTZpVnFyRkRuSE5QM3BpNE5X?=
 =?utf-8?B?WXRrYXJ1Q1BRd1NuR1U5TnI1cG5RanRyRTJMWWtaSng1bGJXbndmeTFiZjlU?=
 =?utf-8?B?YjZadmpYSTV5WG9xVEZOZXFGUWdaR1NGU1ZLcUVNcFhZeGliNWZZdWYwS0Q4?=
 =?utf-8?B?Zk9wV1QwYnZBNG9mTWZ5RERBUDhULzJjTjcwVkhpVnMrSzROTVVURGdCSzJv?=
 =?utf-8?B?YnVyY21ubFJQWUZuTlo0NUZETlFLc0swNVFYSisydmN3V01kQzZhYkJYS0Q3?=
 =?utf-8?B?TVdlc0hwOGVmYlUxK1MzdWtGVVdGaW1nK2ZiNlRUS2pKT2R6VjNiRkhFZ2N5?=
 =?utf-8?B?VUI1N20vcjQvbUhsR0xsZmdUQTJ0a1ZnT1NxckFFQ3J5ZFFaOUNyNHRVKzA1?=
 =?utf-8?B?bkpGcm42T3VlTnpzblUrQkVSTE1yRnRCV2MyckVkRWQzbXlaWC9OczF3QlUv?=
 =?utf-8?B?QTY1QjB4MTdHNG1NbnE3S3NXb212dkxkNkdmZ0IzZUhaOXdiMU84bEg5cHJh?=
 =?utf-8?B?Y0F4UU40dTVFeGF4V2YrcGRRbzhBYlhOMFhzYVYvODU1OGhxU3ZsV21sMHJB?=
 =?utf-8?B?REZoRzRLQWZPeHF0c09qdjQwcnNHV2FEeS96VXpOYVpsaUtPc1ljRnVhR1h1?=
 =?utf-8?B?bGRlNWh3N3hLWVFLeUZ5YUE0cUdlTWxZNTNsUzRSbHMxbGpxbStqWG0rTWVP?=
 =?utf-8?B?S1BETnJpZkhoLzFjRi8rQ1oyVmRFdTZnY1ZKd05SZ1ZPNDJaTEJTNjhwTERs?=
 =?utf-8?B?cjhJOHYxL2pqUlViS1FyMjhkUUdBUjBtK0hpT2ZjaFg4ai9jKzEvbWRmK1ZC?=
 =?utf-8?B?L3BCV0VWdXpoREZJL3pDU0ZmZU84L0R1N09yYjhmZkJJRkhJa2liOGhPK0dX?=
 =?utf-8?B?N1BFN1UvM2F0a2ltTlY2QUttSDJCeE8zWXVOSWc3RGtJTnJCd2pXL1RKd1NU?=
 =?utf-8?B?L0IzMGNGUmc4OFRBdEg2MHZNNS9uYVFPTW1BTS83VE9tMHJlV3l3VDhSdk81?=
 =?utf-8?B?d0hQcWFmTVowbmcvb2hDMEJtUndtSFdkTUJ4Y0FDdUhoRWE4WFo1TUNoMTFo?=
 =?utf-8?B?aFFZVEtPcmJnMy9XWjcvaWlwVEZadXZXMll1MWY4ZGozcnFCY2ExVC9KazM3?=
 =?utf-8?B?QkdERHB3REQzY2JySXJLQlN4MDExejVqcFA5WXZJRnBLQmtyV0Z6MkN3MGR4?=
 =?utf-8?B?ZGJScFBWQVQ0Q0J5eGxrNEZlcjBSM3VtL1UzOGhUTFRXTzZweFdzeU9NNUx6?=
 =?utf-8?B?UjhIN0xpU08yRGYxaVk0Y1N6Sm1OaGZDM1RIYVJrS00ybG56YVpUd3lqeU13?=
 =?utf-8?B?cHdTb0tzamd2QndJR0JzT3FYM2N4Y2VBYS9RenVKbW42SURFaWpnNW5xejZj?=
 =?utf-8?B?Nm51VC9KNUpJeGVIb2MxUFBIOU9vNUdnL3VqUGJidXg2YWI4UkpOdjA1elp3?=
 =?utf-8?B?R3hYeFpwcHFPcUpTTWN3eXVOaVRyS3ZEYmpFb1pJWVNEdmQweHlVYldLSkhK?=
 =?utf-8?B?Sk9LVkNrSElxTkZETlpoWUlMSzljSVFDWEY3bXNGRk9xVzBrSWhXUCtPUmxN?=
 =?utf-8?B?cWNTblBQNDQ0L1pqZUVvQjJjb1VDaGlWdVRPTjhwcDVQaU1oWGdHQXo3eDA2?=
 =?utf-8?B?YmJDaHFPNC9VSHBDSTY1eGlkcFN1Uzd1c2NlME1Ld0FFMVd6bE52aDB5WG5Y?=
 =?utf-8?B?WFM4MWxSbHA1OUlDR1l6MWtrNGtOZXp2Wkd2bm85cHllb251M3FBZmNsWW9u?=
 =?utf-8?B?RFNiTWFLWCtoZDdzRDR0UUkveWFKQVJVTmgzdFVMSjR6RU1JVGtoTHJGUVho?=
 =?utf-8?B?b3BHT0YyY0JFZWY5VWt5ak1YeVZRMk41QWVMVDVXL2R6SERRbEY0K3BVZjdU?=
 =?utf-8?B?SWo4ekVRTUNNK0c3R3BFWTc4VE1HbHhDUWNISzFqNDBNM1lRL093OWRXYkVK?=
 =?utf-8?B?SXArTnE0dUgrdWVvNTNPbW0wUFl0Qy9FSlY0eTIyelMyL3pUODhxOXY0SjQz?=
 =?utf-8?B?TDIyV1lDUjlHUHdieXY1ajZnTFMvdGhBMjdIVHo5Qmo2V0Y3Yjhaa3doMHRX?=
 =?utf-8?Q?h1A5UduUd1jjRFIz2jitSq9K/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: de674ac9-569d-4f3a-d263-08dc769d9b61
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 18:17:26.8354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lq/S3EYeVsooSEQs/RNY1ZVzNeC2xNfNee3wXnSAHmPKYAugEmhkorMBmvsM+J7MEWQxfJnycpKXmEQIeEDg9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4678
X-OriginatorOrg: intel.com

PiBJJ20gY29uZnVzZWQuIFdoeSBub3Qgc2ltcGx5IHVzZSBzYXkgLTEgZm9yIHdpbGRjYXJkIHZl
bmRvciBtYXRjaCwgLTIgZm9yIG5vIHZlbmRvciBJRCAobm8gQ1BVSUQgb3Igb3RoZXIga25vd24g
cHJvYmluZyBtZWNoYW5pc20pIGFuZCAtMyBmb3IgdW5yZWNvZ25pemVkIHZlbmRvciAodmVuZG9y
IGRldGVjdGFibGUgYnV0IG5vdCBrbm93bi4pDQoNCkl0IHdhcyByZWFsbHkgY29udmVuaWVudCB0
byBoYXZlICIwIiBiZSB0aGUgd2lsZGNhcmQgZm9yIGFsbCBvZiB2ZW5kb3IsIGZhbWlseSwgbW9k
ZWwsIHN0ZXBwaW5nLCBmZWF0dXJlIGJlY2F1c2UgdXNlcnMgb2YgeDg2X21hdGNoX2NwdSgpIGNv
dWxkIGp1c3QgaW5pdGlhbGl6ZSB0aGUgZmllbGRzIHRoZXkgY2FyZWQgYWJvdXQgaW4gdGhlIHN0
cnVjdCB4ODZfY3B1X2lkIGFuZCBoYXZlIHRoZSBjb21waWxlciBtYWtlIHRoZSByZXN0IGJlIDAg
YXV0b21hZ2ljYWxseS4NCg0KQnV0IFg4Nl9WRU5ET1JfSU5URUwgYmVpbmcgemVybyBoYXMgYWx3
YXlzIGJlZW4gYSB0aG9ybiBpbiB0aGF0IHNjaGVtZS4NCg0KLVRvbnkNCiANCg==
