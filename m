Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BE21366
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 17:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435157; cv=fail; b=E0Ub8DGMX+Ho8dWUurZ69WKJISp30LJpz/5Vo7rEYD7U6ROYa1ZZkouIYAIUcf1YAUr+jAhO6dQR62f7R4fEVV+S5KiJD6ZZMCLBxlXmq03C8VY4qLqa+dP7gy+v6umWRionDOnM/3My4U6gEYBRHBkLzQf0Walln73ygYCnufE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435157; c=relaxed/simple;
	bh=Qk65BQj1GClbYWbCKmmJC94cfneFwfBTpt8+NzyPfV4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cq3eCgY/UoURu3FIMbcd40fvtTsJSiRqUppMJGVWL0xMxpNzbol/PuwCO9uNfrd0Cwg1qHsl/74LI9nYMNVZEgMRBeYAd7shVIqHB8i/mDrrMCCsXmpXLVLCWtOqJ0rMQvAazvD+8PBE2j19jGY9PfMsm049d5OH67TW+rxt+d0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OcsBmmp8; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OcsBmmp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717435156; x=1748971156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qk65BQj1GClbYWbCKmmJC94cfneFwfBTpt8+NzyPfV4=;
  b=OcsBmmp8N5U32sgf3cZoP/7v33uZD+LI5Bit88WmLmA/mMUqkoGVzKK/
   MvwPPv+R8Xmg9Ig3euFxwZ4RMNuGXxnFZR4qvzCN7OyEEeskvU0324JI4
   98iuMi3rPvOobPZMWNjvYDcc0scXWx0c/9QSjnP8zTHB9u6TRCMJBCDR6
   U1ScE1d4gWJKkiNb7qtuqDI87hd8ps5PP4PYWsfYnqwF913fQ0jf7fc0p
   Ioyq4UGbSZqsaUrrVqiWQPi8HWvItRSQYcnMvwydiErY7Izf9N9Au5t5S
   zZiqA9LSIAuHNn7p1v50O17ZTvsUq/LnBf8B+vzowxD29V9DpFhgOG9lz
   A==;
X-CSE-ConnectionGUID: 4SQI2IGgQLawszTAENzqFA==
X-CSE-MsgGUID: loaJ9DnLRMi9HpD1w1+P4w==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="24594032"
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="24594032"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 10:19:15 -0700
X-CSE-ConnectionGUID: TvrO1s+pTx2qTxZ3kopcVg==
X-CSE-MsgGUID: 1OGGUc92R0CPjqtQJpZH/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="37395170"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 10:19:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 10:19:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 10:19:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 10:18:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lu9/1DVfsdCp/aRx3kkiKm9x0v8LxURDTGlUMYRh4PFbeoz8/WiGplNOwSQp7SrGq3NaitFOmMRIll7PXf23MgoPbgrJjqegIewHYExtoK29nzhdF4CQJiLsv2chjznm9gr1RDOMyUsR8IU7jM4oN0JAOgSf6J1SOk51evWc75/zqLqZZbhqyOGccrePZVuP79Bof8+Pjaayh6WI2h1EKdDgW8AAoelBRfV9ytJQkLFGojlN2jz6tlLUd3gURUMEIu5FnRuuguXA1EeuZQFwKFktofU2TSl2JKe7J2ZPPQy9/noIZjORC60B021qMdN4AqAN6ep/KUmw7OM711PeFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qk65BQj1GClbYWbCKmmJC94cfneFwfBTpt8+NzyPfV4=;
 b=W5KBTW0ohPZ39GeNaHVloJj6FmXCmfb0jbPs3LOCdcMR6LT29+psKHlenhooS4/HTjD5Gl6SVNZNBVtL08TWPvnx7OUrXpItC8EhTOm2iUTuTy/W2eDmfI1EY38tPxG+IedFdZqs427e+bmDyuIyHNBB4Cny6BpU4VFUeLKB7GCP0dlRFub6ITfK8c37J/xG1x6dH2mIUf+16WR52GZdu05FY5J4Hz5pKyS79NyFqCLcuDc782kpmVerY0ZPYxRFrWKf2NFFBOeH3D8GgBm6QSV5SVTp74uIZtKnJ969unCrTNTL6yWEepErQjjra1bQLZj1JZ3Fxn2G7Cy6XhLllg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB6376.namprd11.prod.outlook.com (2603:10b6:8:c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Mon, 3 Jun
 2024 17:18:37 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7633.018; Mon, 3 Jun 2024
 17:18:37 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Chatre, Reinette"
	<reinette.chatre@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton
	<akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, "Yu,
 Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
Thread-Topic: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
Thread-Index: AQHas5TJu5kY85ZCbU+0NVdjwIAZ0rG2Rn0AgAABmACAAAR34A==
Date: Mon, 3 Jun 2024 17:18:37 +0000
Message-ID: <SJ1PR11MB608311F25E4B0B789E54866AFCFF2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <22569491-1b29-4b3d-8e9c-a5d10b73b6ab@intel.com>
 <20240603170106.GHZl320tVKXp2HyUfb@fat_crate.local>
In-Reply-To: <20240603170106.GHZl320tVKXp2HyUfb@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB6376:EE_
x-ms-office365-filtering-correlation-id: 79eae119-f9fd-4bbb-037d-08dc83f134ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WkxKckQ2YTdNQ1F1QnRLbXBSQThzTGovMGZkVXF6ajJQcmVRVFFyTldmdTdB?=
 =?utf-8?B?eTNLRWpIMjFZK0hiYVMxS01DRFcxcldybFp6c3NaNlV0ZTN3YXpoWWZEa1M4?=
 =?utf-8?B?NG9pRW1xZHgyWFJzanNYejFWOTRqVWt1bTZ2N3B6enFjZ2ZTYkZZbFNQM0s0?=
 =?utf-8?B?aG8xREFhMVJPOWZiSlBQQ28ycklTOThYUVZGbmM5VEhGZUNXTHNSODZIbXl3?=
 =?utf-8?B?NmJlazVNMGlvR25ML2FLREIwZTdpWmVRK01rdUplWXZHcFQyYS9PZmpaZms1?=
 =?utf-8?B?R3A3REFPVGpJS0t6M1J6amk4TXB5SE9JQ2ZHT3ErMjlCS3BnR1AyWlpONUVr?=
 =?utf-8?B?UUphdFZWS3c2dUIwNFlZY0dLdlUvSXYrMFJvSDAyVGtkMTNUdnZsUEVmbHpy?=
 =?utf-8?B?Y3c4TGllRnBUdnorNGR6TUs5UWxLaHg5ZFY3bXBWR1lSUkRGT2I2bS9vVUtH?=
 =?utf-8?B?YldoQUVaYk1mSHFDdFVGbzNCb1dGMVhIcllVcnd5UzRPamR1cFp5MWhKSUVj?=
 =?utf-8?B?WjdOMEdaeDNjbDh1bmNUWXFJWjhqNzB3a0ROYllKYm1LdFRzMDU5QUdGSHky?=
 =?utf-8?B?NmlQeHhsMHRmbHN4eStXTzc2T1hIWkhOWWNPcE1EWC9SbndaUVp0N3I1dU5O?=
 =?utf-8?B?cDEzb0ZzdnhUWGxwK1JlQjVqSWRERjQ3NVhHWkJIU2Ywc3pCV0gxeldwRmd3?=
 =?utf-8?B?aWRwNWxVREo2VkI1eW5TM0Q5ZC9MVmlqZjJ1SzVqUHhKYnRaOGxsaGJaS2Qw?=
 =?utf-8?B?cGZnZmI1bW90djRZWEY1djBycm53QVBaaWJQY2FlNzI0dnNUYWJBcTY1V1Zo?=
 =?utf-8?B?OVg1b2d3T2dMNGFMdDZLMzJOalplR29EQWdVQzRXU3Z4MXVNejBEckhRTHBr?=
 =?utf-8?B?bEk5OFZsQ2VIUjlRRzNFTGpuSTZyTUU2WHBSa2YvNGZ1Y1dEek9PVVRmSVpF?=
 =?utf-8?B?RlFOcGxESVdvUWhVZHNtSGRSMVpFQ0lDY29wVFptWllvZEJnRTA5NTErUHc4?=
 =?utf-8?B?WXJpd2VLbW5zSXBBSkVKeXpQenl0ais3QVRWUEZiWDE3cWlXeTNRay9MQXpj?=
 =?utf-8?B?NlZiS0F0OW1tTWFLMXF3YXIyRmNBUXVoa0FaTnVxMHl4T0U5MWd3aUhYL05H?=
 =?utf-8?B?QWEvVmg1eWkwNWROTzFIZmJKOHNxYWNtRUtCa2tSRFA2ZDhyNDgvZUwzUXBG?=
 =?utf-8?B?L1hLVHo0WjFjd09CM1JrU1hFMzVnLy9oVWc1TUgyenJDNWdzTzloekZGL3pS?=
 =?utf-8?B?dDROWXhUczBtRFFwU1U2cy93czh2SzdkWkh2cDUxbS9jR1lDOTRhQUN6ZGtw?=
 =?utf-8?B?VnNHSFFiMWYvbjhzamNNbkpuazhVUG1uQnpRSmQvaFJRaG9nMVExTnJha3NU?=
 =?utf-8?B?aUl1bkkrdlQ1ZEJSWEhFakRvOXN5ZWsycEthTFdKdnROM0V2L2Z2Nlp1QUhl?=
 =?utf-8?B?eWQrY2tjSWZYekFjZnRMTmhvVllaQW5JNGpwU0RoNGNXZHFYZjhjY3I0QWVZ?=
 =?utf-8?B?VlczUy9EY1NyaWJobS9hWWxQb1h6dTd2NXBiOHR0VWt0VWN5QnJUeVk3R1N6?=
 =?utf-8?B?ZmIxTU03SzdkVmFUSWtHMlVZOUpMTzI1S3J2MUc1amw3RXk1a011bDBaeUtw?=
 =?utf-8?B?NEw0WVZuY1RXRFFGVkQ2N3NnN2FEMVYvRm1tS1c2cHphcWpVS0pxYWJ5eDJh?=
 =?utf-8?B?b25USTNrZFBLbk5qckRFUG9iU2dkT2p1eXFsT0VsZDcxRW5JblVDTktBeDZx?=
 =?utf-8?B?K1M5eVhsSEFvemZDcjJUMEYxN1kxRW56MUVaeVR3a0hodVNhVjZ6VGRCYmNE?=
 =?utf-8?B?Y1pUSXQrWXg1aEg2UGpkdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXhwcUJHcEtLZTE2aEFYa2oxNzNBbFFmUXRHekhpZGdhOHl1cE91NW9HM2Ro?=
 =?utf-8?B?dHlFQy9kNVQxR24zWloyU21SNGNFSy9qUTFObEtnSHNiR0xDSVRCcHpHWk9t?=
 =?utf-8?B?VGRDdktCOVlIL25qc2xTcnlsa0VhR29nMzVaMU1nbXQxRHd1TVBOb2x6VFhH?=
 =?utf-8?B?eWh6NnlYMERIbTVjRTIvT2svWmJnbmVWakFEckdkV3o0ZVg0OVVjYm4rRDVK?=
 =?utf-8?B?MFk3cVMvMkZ4bjdxTmNvOGtvenYrZFd6ZHFadjd1Qk1kSTIrbXgvaUdNbEhr?=
 =?utf-8?B?QW9mdjVubG1kTnBtSDYrZ3E2V21UZitHdEwxQmlGNy92aFdZUkd3Tzl5Nmdi?=
 =?utf-8?B?emdyQjdENVpMMDJUSGxNYWk5Kzg4dDBCU0VmWHNjaWJjTzU4SFkvTTlsNlFn?=
 =?utf-8?B?Z3dlQnNJS1JPS0NLRHBYNVo0V0ZYZXFwbWRhNmVXRTZ4L25XdG9BV2kvbTl4?=
 =?utf-8?B?ZWRjRmc5SkRDSTdBV2cwK3pyQUU3ZlBnVTlvSzdqdmYwWVF2TVdZbHFCQWVn?=
 =?utf-8?B?bmVIVU4wWkZRSUpmR29IRnpJWTZ0MmRVL0pTMHhCYVlFV1pIS1ovOFozSVJ2?=
 =?utf-8?B?alB6UE1XZ0NoMEYzaE4zRGdUbzFIWWlhOVRNaHZudGR4QldidlFvNXlVYk9K?=
 =?utf-8?B?NTVvN0V3OTdxaFVIaDdLczNjaTdaT3ZIcVVVVmFmaHJydERDYTMyU0g2VmVJ?=
 =?utf-8?B?cjNtN0pOc1FMT0R1VGZWNE1PczJTMDlsYTk2SytrNkphdEN1ODNPc0k0Yk1t?=
 =?utf-8?B?clRWbTQvR0VPTHFNTzlIQmtxckRoQlhQcDNiTXExUnl6ZVc4ZTNWblE0MnJH?=
 =?utf-8?B?RHI4UjVuaE1pWXUwY2l5MlR4cTVHTTZOVHdZenMxTk1qODVMZW5NNyt1N1M5?=
 =?utf-8?B?RWJWeDl4dTc0Tm9HVTJoUWlhTjFtTENqTUh4U0dNYXA0bStVSzlpdFV1dkpJ?=
 =?utf-8?B?S1NUWjRxUkYwR1RxRDdkclRjbVo0MmFlL0kwMGN0NmM1L0YvRGJWT2FsdFM5?=
 =?utf-8?B?TTJLYlNPTnNnZURVQ0J6eUF0TjFlVlFHQU5ST3doMXkrOHB1Z1B1Y2l1V3Zs?=
 =?utf-8?B?aUJTZjVnTEtQVnBiWkR3Z0lKYzZUUndiZDZvU2VVTXFlQXJhZ3BqMnJVZisx?=
 =?utf-8?B?M1dOemRWMWlHK1YxN1NLRnhPc21vcjU4a3AxYit4aXVHVDFrRmR5eWkwcjBV?=
 =?utf-8?B?QWNtazFWbmYzQVZkdzFyNHE4LzJPdVowNkFNTy9YZDNoYXdKMmdHQjE4WDJX?=
 =?utf-8?B?VVhJc2pHeUFYQklXMVVjaEx5Q2FGbE1JdGtHWUVTenBjbm0xTnRsNkhlb0ZN?=
 =?utf-8?B?VEkvekhEU3p0MXlvcm83MUljYm83aUFtaCtXRVBSbHRQbW9YZ21JTWFkYjM5?=
 =?utf-8?B?OXlpbkR3SzBNMS9rUk5uZkJCRzlOUEQxcWMrVndvSEVVcXBFZlU4T2phbmlz?=
 =?utf-8?B?UHgvVE03TlJqaVZaWlMwZGZwUkZCejN5TmxOWldDZ3BjeXgxL3JKWHJFN3V1?=
 =?utf-8?B?V3hzMmpDYUtVcUFhOE5nL3l6RDduS3Fhc2x6ZUpnenRMT21STnpCRFNTVUs3?=
 =?utf-8?B?MysrVEFqaDEwZGdqSzJrNkFTdDUvWXdEd1B1bUZTcFUyYzlkd2dQUmZhaWhz?=
 =?utf-8?B?MXpQdUQ5dkxJeGI3U0NFOEZQRURoellaQ2Z4MDFLMDNZRDI3VnZnT2FBWTJD?=
 =?utf-8?B?Y01QaFpUMFdHM0JUN0FwRk43RVZua2JlWFpRK3pEQUl3MWxmaFozRTU4RnVn?=
 =?utf-8?B?UTBRNFlnd2JNUndHaTNyRytSNHBwUkU4aTJzUXFWa05QZ2NnWGRhUUNlbEhW?=
 =?utf-8?B?S0dlYVd3cEJPNnMzVTFTUE5TZjhvdG16VXJQVDFOWURadnVHUVR2enZwUXk3?=
 =?utf-8?B?OFdNQTk3b1Q5SU5yellnaUV6aFJEa3hYMDhLSGVtdU4yQXNCSFVodU8zbzRY?=
 =?utf-8?B?OU9PYlhzT2Q1L2ZwRjBWUkZ4eWNMcGxCVE45WnVXa2Y0WnA1NFo2UlcwQmVi?=
 =?utf-8?B?bE05WndZVVRLTk5yOE0xd1NPV0Y2ODIzOXpWQ2dKVUxwS1BOOWI4SHZtQktj?=
 =?utf-8?B?bzFibHJTQWlFV0ZBdzV4bVdaSUJGRWRibVFsZzZvQUFiQkNVTm1qRUNleW1M?=
 =?utf-8?Q?PVXS3KfmemS+7T8cwhlZEIYj0?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 79eae119-f9fd-4bbb-037d-08dc83f134ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2024 17:18:37.7806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3psTtW4WAcU58OYGzWepi0vLhm/YtP0BPpgvHjNC8TlZMJ5jPEkp3wXmkrb5Zfhjk5GzhVl0eErWcOh3Sd4Zzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6376
X-OriginatorOrg: intel.com

PiBJJ2QgcHJlZmVyIGlmIHJlc2N0cmwgcGF0Y2hlcyBnbyBvbmx5IHRocm91Z2ggdGlwIHNvIHRo
YXQgdGhlcmUncyBubw0KPiB1bm5lY2Vzc2FyeSBoZWFkYWNoZXMgd2l0aCBtZXJnaW5nIGFuZCBj
b29yZGluYXRpb24uDQoNClRoZSB0d28gcmVzY3RybCBwYXRjaGVzIGRlcGVuZCBvbiB0aGUgcGF0
Y2ggdG8gPGxpbnV4L2NhY2hlaW5mby5oPg0KU28geW91J2QgbmVlZCB0byB0YWtlIHRoYXQgcGF0
Y2ggdGhyb3VnaCB0aXAgeDg2L2NhY2hlIGFzIHdlbGwuDQoNCi1Ub255DQo=
