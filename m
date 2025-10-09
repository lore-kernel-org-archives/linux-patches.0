Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6BA1D5CDE
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760045493; cv=fail; b=A/cBG9QZNhUxea6bAXg41UrjGteOdBzuuEYFfVLdvtkpdA+3hgZ7hHfyC7Bq0R9tFcOrfUQ0h3CSdckX/hAfCSYGtGI1LLVlGhNl2ZTJE1oqNtheehmz2Dezh0gv7PQZHU6VG9VCLXlnxpiBOFnrpyimWust1BWf9xRnfRiO5H4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760045493; c=relaxed/simple;
	bh=N/iNHahfMDdjjBgqRgCNhfA9nbIKWN5koC/XEIvLH2M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dNP6gfYToAqUbyIB5pH4qKIxABttIHAQflo5kLG7AzOCYD6i1zjnK4sxbGsILD7GkuyH3GEx/Oc8EvfVhasSHsgysvQGovLbK+NCGs1nJGZ24Udm2fsm+32lhol83PaJ+5sMmMqlJDZC4jmGERbvJfgRbOOtvUD1MAg5cj5X7bQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ft8QuAMj; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ft8QuAMj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760045492; x=1791581492;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N/iNHahfMDdjjBgqRgCNhfA9nbIKWN5koC/XEIvLH2M=;
  b=ft8QuAMjsbEZxOO3qJBUroFhxnnP4gbKZkOf6MQJFOIawo1qXYFL+Esj
   tR4x2GifyctHTtj6keDAd9P86OpEkq4mdAQrd3fL9z40mVhph5lZApXaX
   ZiuD36sfDpP++DplcIRoEpLYVj+EZfaJ4tijpAXl0nvFg985d2zOGdyhU
   NTIBA7oq2qQfyM4lvTJC/AIfZ5sd+qGwF8cgLYqkIznIazyhEF68XrRAQ
   PcWMSexAuYPLkwoywoQ3ppvxMCRz+Mnznh5WXW61ieOO3TOfJuNkmKZ5B
   kJjPLAg4D8Y92tZW+w5BoDMVm2y/EW7W8zKi78PH381baQhl+Xjynwqj4
   g==;
X-CSE-ConnectionGUID: vBx9mzajStmfViqz/B6yUg==
X-CSE-MsgGUID: q0Dj+B1ySpCipX9W05F4Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="73698985"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="73698985"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 14:31:21 -0700
X-CSE-ConnectionGUID: BoG5oILAQga3VrJ4hWNd5A==
X-CSE-MsgGUID: 2xkQ69OsS92Gilz0PJ9jHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="185936241"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 14:31:20 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 14:31:19 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 14:31:19 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.7) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 14:31:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y3b4180roj5vDLHlRxRnBCfgtmEinYPWM637ngs4jryBm4XYLOE4C/37o5ijzwGzH3eyIXznDoQJUYc9lXFbMuYdgiwFjcUEe5aURt/rJzsS1lOunu8W4TMbNmKh3DvZcc8EuwHtSp/T6DxXePMTTyBdiU76Rf/yiJJ/h5sanje2t0xqno86qPgb6cE+xhZqm+OgqRMUrQJWEkP2WIU45JFoLgpmtd8ey4mtQNHmzp3Lmubp2sDd5CmlCqHfiojDmYl8fGQ9Z4Qqx7BMzBJ/pg5LMLTqqrke4HRLF0hOpjc4ppm7yJXDXBLeK5KQmIdRfKtkC1cELEUgJHWw29nrMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/iNHahfMDdjjBgqRgCNhfA9nbIKWN5koC/XEIvLH2M=;
 b=sRQBg7QzreTIqB2RKxmqPiS/0YMYlf1nTs8aetgcOk/LuobMhgONn6DKs93WxCwm/oESncrjBNmoE2Vd58TMqAFupbPZr+jvfTpiZ3gi1aH0IWzgdUOGnWrV9YzpIvwXQHJvATAGLGjynC/j4vZdvVBcOMQsu66PpcAjHjlqPZS3ElaWT7bNEV9AI7wjfDZAfO1Kj0h1g52ooEzYnUGJZkUvuzZySfXupK1kEpZ9jPRPOmuLMM0rtGcfNBdo3qh1+Snvp2LHNPuTydi5vJ4FQyd1XQbLmDEHVlv/fqXGQLuIA/ZtWB9m0heMBQJ5XGp8b5mW6O0dn4gX4D9GvWd5JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Thu, 9 Oct
 2025 21:31:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Thu, 9 Oct 2025
 21:31:16 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Thread-Topic: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Thread-Index: AQHcLleU0msvp58alkOhnd7F/4XHxrSxJp6AgASphYCAAsCpAIAAQ86AgAAP+ACAAANVEIAAQMGAgAEDuwCAAC3RgIAADelg
Date: Thu, 9 Oct 2025 21:31:16 +0000
Message-ID: <SJ1PR11MB608328747C28F736C6DD5FCFFCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
 <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
 <aObUZU8rnWIDR_tH@agluck-desk3>
 <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
 <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
 <e536ea0b-c466-4381-b92b-993be92fe65e@intel.com>
 <aOf0yA1AWlzJLf8H@agluck-desk3>
 <6778a8af-5312-419e-a064-bcb6a495a207@intel.com>
In-Reply-To: <6778a8af-5312-419e-a064-bcb6a495a207@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA0PR11MB4525:EE_
x-ms-office365-filtering-correlation-id: 720eca0c-d00b-4149-a549-08de077b2e22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SzhtODFnK1RYaGUzQzl1N1pTVmlpZFhMSG5lTU9BbjJKZXBOWWI2THp5eC8r?=
 =?utf-8?B?Ui9EcjRvaE5pWVRmUUJTL0c1YVFmb3ZKRk5VUCs0d2N3Q2t6NFUya0pRaHRP?=
 =?utf-8?B?QldVM0Q5T0FRQ0lSNTNFZzA5RFNwK0JrYnV0clYwYjNQVGZjYko0WXN6clRr?=
 =?utf-8?B?L0RKbmtWZnZFRFBtWG1Dd294aTJSRnRpMFJBdHgyMjhscTYzU0F1YzBheE1W?=
 =?utf-8?B?djJRdjRMeXREbWxxMmdCVzQ0cHBRQ09WTVdwVHhkRGpVNWk1elY1VVg2em9H?=
 =?utf-8?B?RWFKUjJpQ3BOektseTd1bTZMYWRxd0x1dXUwWHcwYUJFbG9jd0gyckEwcUY5?=
 =?utf-8?B?cVBZQnFJdkx4cnVPWDJTaG1mdDVrakhwVlh3L0JRbG9sNFgwL0VVY2draHRJ?=
 =?utf-8?B?SGVIWE5GN1ZmTkhqNWhwdk9iSjUyL0tzVWo3TlhveXV4SGVvdUJOWENrZEtY?=
 =?utf-8?B?K3lyMzlrQk1TWFNpSy96cjBRaU85SE1ab2lsdFBVZWlyOHNGSVhqS0RNMTJV?=
 =?utf-8?B?K0ZEK0VMQjJlVEpuQ1N5SCt6ajJzMkxldU1wZVE4ckxTZnJiMGZST1Jkbk9k?=
 =?utf-8?B?Z3V1L2lydStmVXZjM1dKS0pKS0lxUTZDeTVHbmpSbGZHMW1jbXh1YWVpZlVv?=
 =?utf-8?B?SGI4cHg3b29PSzJHdzRpRFdzR3Uxam9YOW5SM3lGTWtFN2V0QzIyR25UeVJt?=
 =?utf-8?B?cnhTS084YVZBdXRQeVdmWDYyckszMjliUnRrUS9NVHNVcER3bnN6QlVlZTUx?=
 =?utf-8?B?T2dDNEtpUWMwUVJhK3paUFREWWNXdlUzUDBrektteUYxVnpwaThKY1RiNDA2?=
 =?utf-8?B?Y0t3elFKYmUrRkdLaDltMDYzT0w0T01FbXFEYmV4UDUvbkR3UjZrMUs5UDlF?=
 =?utf-8?B?Q1FyTzNvSjJEVXB6WUI1VEFNbmFzNTF4ZTV4M3dsazBIR1dxSE9wL01oWXh5?=
 =?utf-8?B?QVRXMUlxV0RZeGthd3E1TzN0UnNXcHdna2JkRlFRajlQQnpCOHlhYkhCLzVJ?=
 =?utf-8?B?TGJwUGx3S0VNSXRJeFpJMi8ranZ0bGJiWmp2NzBLZDJyeU53Y0x0VXE0bGl5?=
 =?utf-8?B?RnhuMkNJRFdKL2RlZWFkS1JZRW01cW9ucml0ajNvOWtVd2tKcXh6cnhmVDFW?=
 =?utf-8?B?SUgxa2thNkhweGJ3WlhqRGc4TGJDMi82aUt4dGdEVFlQSGh5djIxWXpqSTRq?=
 =?utf-8?B?TmlJdVoxWkJWbHVTbGM4LzF1WXpoSUl1V1FZZm11RFg1UWQxOFcvc25hWHU3?=
 =?utf-8?B?c202aGRqT0xrK2J5NktaUFNrS3VkdE0yT1lIY1RzZE5Eb1RSTFRQR2tzU2pk?=
 =?utf-8?B?djM4RE8vUGtuZmVNbENNRkxIMENOZHpMTjgrVFVTbFpMMG9PK1g2d1VuZXZl?=
 =?utf-8?B?QzBKeW5EWkJmL1VWb0RBbGhQTnIvV01mZmNvalFGVm5abnlMV1lycGd0am4r?=
 =?utf-8?B?SFBOQmJnS3FyemlFRjVtM2xPVG1zcUZjOGZhVUZWWlB1NWxMK1YrOG9ETEgz?=
 =?utf-8?B?UzA0WVhtc3VzbHIvVGl1REhVdjVBVGVvYUh2WGg4ek1KaU5nWllISGU2aWc3?=
 =?utf-8?B?aEFQaGJFRDRqcGtjd0lpZGZHLzNCZkQyTS9ZQTVROStJb1BTc0F3OW5neG55?=
 =?utf-8?B?L1dNYkFvZTlKdE1LOGhHUFFESWlabXJLa0YvQVc1M3RhUUxTenFKem5iaW5a?=
 =?utf-8?B?eWJJL2FHeWtTT2lnQzhaU3g0Y3VXZE8yUDNRbE9UeGZ3U3J6UWg0TjMvMGxN?=
 =?utf-8?B?eUVQT3VYZ1g0TGcvd0FxUHE2ME5RajhORWhFR2JjWlBZQXF2ZE5GeXdPdTht?=
 =?utf-8?B?RWRYV203OWFtM09aRTc3M1FmK0pVczl2NlZmYUVKVEpvY3NQVmRIbWxFcmFE?=
 =?utf-8?B?b2JkbnF5M2MrZE52czhFZTc0b1BPMEhoMkVaUGNUckZiK09iSGxYTlRlRUp3?=
 =?utf-8?B?V2ZUalIwR3E2ZDU3U0s1QnFBYjJZYldBZmFQejdoeFBCSzNzYzJaak12UlNu?=
 =?utf-8?B?T1ZmTkhua2k0SjJqVnF1MUthekM4ckV4b29qUXo3YUFEaGg0cW1icGcrcVV6?=
 =?utf-8?Q?AelAvP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjkzSHVpTGQyZjZRblkvUlprbjV5S1pzdkRzYXdQczBnY0ZEUWxyNGwyVmVq?=
 =?utf-8?B?R1d4QlErSm1WMGhtd0J5TTBhMXdnb0ljUUtzek51TXRQY05CdnhqTVlJQ0gv?=
 =?utf-8?B?ZlhBcXJlMnZ3ZzQraDhYOEYwb21LRGVCTElrYVdWRTRPdWRQczFqWDZYd1B5?=
 =?utf-8?B?OU1IOGx2ME1LNTdxU2MyM0lZcDFvMGZDbHI1cGUrQlBuWnZUaUxVMjlkeTFv?=
 =?utf-8?B?RGRzd1pzRmlPNGlKUTN0ZDJ5QnJpZDl0cGJiNmV6V1JEM2t4UnZVUVhFbXlN?=
 =?utf-8?B?OU5sT2dtQWZMVDZkWG1yanBTYVAyOVpPNkxVTjJxdmtoVFdvWkVLRHl2NC9j?=
 =?utf-8?B?Mnc3RHF1VVUvcnJSTS9nWm5PcjJ4Z3QrSk90bFFEQ0x3a3lJYVhxVnl0dnVV?=
 =?utf-8?B?bUpmV1lSVkEwZHhqczE2Uk5USXloemx2Qk9RMVgza2hrWUJkbktYK3cwdFRG?=
 =?utf-8?B?elh6SFlFKzk0ZDIwT2lJZWhZQlByWkVjZXk3bFkzYXREdlpaam9zRDJlOVBC?=
 =?utf-8?B?alU4cTd4di9vbXBEc28wcWxNUkVGRm1Bb3krS1JXRTY5UEpJWGVWY0UzRXA5?=
 =?utf-8?B?WHFzNDROdFd0d1gxNmNxaEIrUVRRck4rdjZiTXNuUThGZzl6KzVSTUllQU1R?=
 =?utf-8?B?cE9VbmYyUzkyNVB5cGdaczNDZjhTd2V3SGd2QmMzUGJUZDczTTY1OWhWSnJr?=
 =?utf-8?B?R3c1aEQ5VXdJcjNFK1YwN0k5aGJCNURzL1hnbWNXaEh1eFg3bktrcWsxNDBq?=
 =?utf-8?B?Z0hLT1B3VzhoYTN5dnl2WmZFQmtuTTFubENFUVc0SXRnenhXUjFxNGJYYkI0?=
 =?utf-8?B?NWMxcEgzSTA4UDBuMEpBTzZpRnF4bVA1ckx2R1NXeUs2UWRkTnpHb2ZwZjc5?=
 =?utf-8?B?QmNvVHhYMmZuckZyeWtYL2REN09ZcUE1elo4d09GY0VNdlBxSUIreFcrMThH?=
 =?utf-8?B?NUtHcXV3UmhrTFFHeG5uaUwwUFFtUmNjQTZNYWljc0VSMTFoTXJaRWxxYXc0?=
 =?utf-8?B?SmU0bG1vc2V2UUk4SmhNaURKT2U0eWZpVEZIWWJJRUl6bXZaTklINHZFTWtt?=
 =?utf-8?B?a0dpdGpmNXlHaE14MXkvVDluZGM5S212T3hzS0ZKUldQVFltK2lUTkdyU2pw?=
 =?utf-8?B?MFhobXFtOEt1cm9ObFNqK3hFUFp5REVtWTJRVEJTVkRBa2FlMzAvbTdVY2Ft?=
 =?utf-8?B?eHhVcDA2ZjhRTm9PRjlOR2lBY1V5UDN0WHgvUjh2NTRYS1c5OFlrclJtVmNZ?=
 =?utf-8?B?VGFnWjRtZ2l2aVhsT3NFUlhMMXFhWDM5ZVU3bFR3cVdXUXVhL0prZUhRNHdG?=
 =?utf-8?B?VVdzUWVidkcwSW5FRU94QXI3UnVZckxCOUxXcFo2dTFIeituT29CU3AvQWh3?=
 =?utf-8?B?K2dhOHh3UEsrR0RtWThlaG9qbG1rWXc4RjgxZlBMNkY5VFlvYnFJd001bVhy?=
 =?utf-8?B?UkN6Yy9KTmhwY1FtZExnZDdlZUk4REU4SWVmTXRZSTIzSnJCRThZS3c4bk52?=
 =?utf-8?B?aE5EZXRJYWdNZG0xTTMwNjVFWWJvRW94T1llcVJhNEtCd0VnYkVDNVRUYXRs?=
 =?utf-8?B?K0xJczZaMkw0cjcyK1FxV0tXaG05R3NqZWtaRERPZnRaajFVYkZzYlZxdzQz?=
 =?utf-8?B?U3dKMzk0d1ozQkpZYnAreWFDMml0ZWtkNmdUSWZYek1wQ1owRDZmcXU1WGR4?=
 =?utf-8?B?VGhTbXcxdlREZzNGY2tLeCt2OFl6VnpLV2NxZlNndm1IWkpkVERyNnU3R2h3?=
 =?utf-8?B?WllNQVAwbk9SaFM2TVhGdnNTNmsvTUwrUkFDTHhHWVV4WHlZUEZmQlVVYjls?=
 =?utf-8?B?QWNDV2hidEVUZndqQWlUbWlURG1rQkdQdkwzYkJnOVZmc2tONlNoaUZHUzdh?=
 =?utf-8?B?V1ZEUEQvOXhsMlhTNTMwR08rMVFycVVjL0ZBTzlveE5JVmFPalBFRGU1Mk5m?=
 =?utf-8?B?ZTFkeENMQUowRmx0a1g4SVRsUUlUd092THhXWHpKSFY5V2ZwOTk2cklscjNQ?=
 =?utf-8?B?REZTVDhJdEhmS0ZYOWJpc2ZyWVF5aG5qQkJwaWNyQlFvay9sK3lZalZGUTFs?=
 =?utf-8?B?RG1XdXRYYWxObmt3VXRxS2l2L3pTc0FsK1lrL1dUR0Q2cXE3ajVnVmhWbmRo?=
 =?utf-8?Q?V6e5pWIifJi+muSgW5Lza13TZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 720eca0c-d00b-4149-a549-08de077b2e22
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2025 21:31:16.9424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzcXgdmEfJJfX0JgEFfFE61hWQCWyrQRNGrM5uF+CC7zYGH3aBOagzq2kQG8e48QN9qDYHZAnNfLd5aYpiEPfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com

PiA+IFRoZXJlIGFyZSBvbmx5IHR3byBwbGFjZXMgd2hlcmUgU05DIG1vZGUgaXMgY2hlY2tlZCBp
biB0aGlzIHdheS4gVGhlDQo+ID4gb3RoZXJzIHJlbHkgb24gc2VlaW5nIHRoYXQgbW9uX2RhdGE6
OnN1bSBpcyBzZXQsIG9yIHRoYXQgcnItPmhkciBpcw0KPiA+IE5VTEwuIFNvIGl0IHNlZW1zIGxp
a2UgYSB2ZXJ5IHNtYWxsIGltcHJvdmVtZW50Lg0KPg0KPiBUaGlzIGlzIG5vdCBhYm91dCBTTkMg
bW9kZSBvciBub3QgYnV0IGluc3RlYWQgYWJvdXQgdGhpcyBjb2RlIGJlaW5nIEwzDQo+IHJlc291
cmNlIHNwZWNpZmljLg0KPg0KPiBJIHNlZSB0aGUgbW9uX2RhdGE6OnN1bSBhbmQgcnItPmhkciBj
aGVja3MgYXMgc3VwcG9ydGluZyBhIHNlcGFyYXRlDQo+IGZlYXR1cmUgdGhhdCB3YXMgaW50cm9k
dWNlZCB0byBzdXBwb3J0IFNOQyAtIGl0IHNob3VsZCBub3QgYmUgdXNlZCBhcw0KPiBhIGNoZWNr
IGZvciBTTkMgc3VwcG9ydCBldmVuIHRob3VnaCBpdCBjdXJyZW50bHkgaW1wbGllcyB0aGlzIGR1
ZSB0byBTTkMNCj4gYmVpbmcgdGhlIG9ubHkgdXNlci4gQ291bGQgd2Ugbm90LCBoeXBvdGhldGlj
YWxseSwgZXZlbiB1c2UgdGhlc2UgcHJvcGVydGllcw0KPiBpbiB0aGUgcmVnaW9uIGF3YXJlIE1C
TSB3b3JrPw0KPg0KPiA+IElmIHdlIGV2ZXIgYWRkIGEgbm9kZSBzY29wZWQgcmVzb3VyY2UgdGhh
dCBpc24ndCByZWxhdGVkIHRvIFNOQywgaXQNCj4gPiB3b3VsZCBiZSBuZWVkZWQgYXQgdGhhdCBw
b2ludC4gQnV0IEknbSBub3Qgc3VyZSB3aHkgaGFyZHdhcmUgd291bGQNCj4gPiBldmVyIGRvIHRo
YXQuDQo+DQo+IFJpZ2h0LiBUaGlzIGlzIG5vdCBhYm91dCBqdXN0IHdoYXQgaXMgbmVlZGVkIHRv
IGVuYWJsZSB0aGlzIGZlYXR1cmUgYnV0DQo+IGFib3V0IG1ha2luZyB0aGUgY29kZSBlYXN5IHRv
IGZvbGxvdyBmb3IgdGhvc2UgdGhhdCBhdHRlbXB0IHRvIHVuZGVyc3RhbmQsDQo+IGRlYnVnLCBh
bmQvb3IgYnVpbGQgb24gdG9wLg0KDQpSZWluZXR0ZSwNCg0KUmVnaW9uIGF3YXJlIE1CTSB3b3Jr
IHdpbGwgbmVlZCB0byBzdW0gdGhpbmdzIHRvIHN1cHBvcnQgbGVnYWN5IHJlc2N0cmwNCiJtYm1f
dG90YWxfYnl0ZXMiLiBCdXQgd2hpbGUgU05DIHN1bXMgYWNyb3NzIGRvbWFpbnMgdGhhdCBzaGFy
ZSB0aGUNCnNhbWUgY2FjaGUgaWQgaW5zaWRlIHRoZSBzYW1lIHJlc291cmNlLCB3ZSBtYXkgYmUg
c3VtbWluZyBhY3Jvc3MNCmRpZmZlcmVudCByZXNvdXJjZXMgKGFzc3VtaW5nIHdlIGdvIHdpdGgg
c2VwYXJhdGUgcmVzb3VyY2VzIHBlciByZWdpb24pDQpvciBzdW1taW5nIGFjcm9zcyByZWdpb25z
IHdpdGhpbiBhIGRvbWFpbiAoaWYgd2UgYnVuZGxlIHRoZSByZWdpb25zIGludG8gYSBuZXcNCnN0
cnVjdCByZHRfcmVnaW9uX21vbl9kb21haW4pLg0KDQpTbyBfX21vbl9ldmVudF9jb3VudCgpIHdp
bGwgbmVlZCB0byBnZXQgYWRkaXRpb25hbCByZWZhY3RvcmluZyBhbmQgaGVscGVyDQpmdW5jdGlv
bnMsIGFuZCBzdHJ1Y3QgbW9uX2RhdGEgYW4gYWRkaXRpb25hbCBmaWVsZCB0byBzYXkgdGhhdCB0
aGlzIG90aGVyDQoic3VtIiBmdW5jdGlvbiBtdXN0IGJlIHVzZWQuDQoNCi1Ub255DQo=
