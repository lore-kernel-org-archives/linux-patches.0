Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491DC2E738E
	for <patches@lists.linux.dev>; Thu, 28 May 2026 16:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984744; cv=fail; b=BMwEntvnnxYj5GriGPfqo+v3PwwwBhyTp0aKW841/nS/wYKAmnGJl29wUSSBl75zJHxDfwpT6FIEMMX+cttg8eIbJ9JcOhL3bN5VnQQn3MoJEBFaFtqFwX7OEicMwMElf1jZBAdkqXftFj7HyObvb9GmAzaoYjiC9HjVjmZjOGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984744; c=relaxed/simple;
	bh=9ibeMNL362cV7XgCaaqfQM0YZLunNIUA1+WcTt74/r4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ACESV2vW6GFzPf6EZ1vA9uZrO0I6Yf29/E6tic1X34IlwVUbM+dKNJdm3lKzvKBC8WV9rpdGbRIuJk3UxiMU/WVTzR1eY0ZlM5ADHqeO+Rd9NjRkNFHmE61dC7fwZgAS1eY6xWJObM7grBCcmWVCF8yb8eUqvXfe/lOF2Au+4aU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hG70TulC; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hG70TulC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779984742; x=1811520742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9ibeMNL362cV7XgCaaqfQM0YZLunNIUA1+WcTt74/r4=;
  b=hG70TulCrmZ+a7Ou689nHJA4QLt1Q8BzRCpIiPKbJs6GYFTjkP5XcbH8
   aSQLWaP4NN50rfIgAE6J4UE94jJKR0pu/eyh7Oj6sGdwWSBoeL0igcZ1w
   jzzktbl+XE0REk7aSrhXG+TJTI/mVF29XZiw8q6o5XUAnf2MPdaKEUwMd
   DHBINMLOHELa0QtDRR0GTKRQ0SSgZaSJUIjfrmrlpZwjLHtFb6QvPdo9B
   YyYAfFKJIAaublziF8vVGsP0D0bdZ8rJxQnnzSGCvbeQfli67L4NDU2ph
   BpSl4HCymKuLz+A8BXhba0LBhi5mCuHh7AoL9kAAg3pBjP2Rxqr8zAi8a
   w==;
X-CSE-ConnectionGUID: bROAqnuQT8yurERmHVBh3w==
X-CSE-MsgGUID: FzlH/fGcShmY72VBaJbHlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="68366656"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="68366656"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:12:20 -0700
X-CSE-ConnectionGUID: +PxxJEdrS6uziJkXZU3rvA==
X-CSE-MsgGUID: fr92JyamR4GGAmI00JKEQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="280701936"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:12:20 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:12:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 09:12:19 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:12:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRjonN2Njg8i5b2OfuShvs85YsIZ329TrsCYwRzSZ2RtkqVoABlm/UjQ3B8Ohf6tvL3dP5TN44iuhSY84Nq0ZY118NPw0c/B814cqcY4padycrA1wG/UZm4jtMwtial+/q+F6mqSYS7+Lqvb+r9iM/JqkOD/t4zCkeOSjv5t5e5D0yIq5Gklx+miOmeZ9GvxESLuiEK8Bvvoh2489autFG39nvyMv4IDT4X8KInDmgAy7Q3lpZHedNzVV8Ku4Gtc8zwMKbClCwzxYWZR6lg8ZzrblhmyQTaE3Uw2z3mis5OWtKUclYqhOnSSe21YIQFdSOs/93uYbDHaAQvHAWRlFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bwbx1RsLwEjKllaR5cGhrxcFLljK4mrymvXPgKH5lmo=;
 b=hD+triTJD+fJrhNuvl3434ODBr1yP+fXNDezw6HMqSiz6Ham1DC8dvEb6Hbk54h9WvmAnqU074yADivCSGJcg0Iet08Evs4Xw+s8BJvVhAFEemIcZGNI92hamZr1EXcJYbNo5Pu96D1XEnSls6QCGwmlPAAhRmn1npJt+3U6FSrooJJWerwLw2AZfuumBkJr2915Nvv0vKU1JQQhDxK4NAtgf1fgQWI/bikutoV58/XTnABarddGbtuRoYiko5vV6QP/3VUpbeKBjITQQwy+Asg3tF72XU6MpN7nXh/JCaONNVq9Nbt/i0tnk3oDilWtSF13V439vfCBq8LjRRNTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LVUPR11MB9857.namprd11.prod.outlook.com (2603:10b6:408:38b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 16:12:18 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 16:12:17 +0000
Message-ID: <9ea1986a-a88f-4224-b530-252e0f5cbfd0@intel.com>
Date: Thu, 28 May 2026 09:12:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] fs/resctrl: Fix UAF from worker threads when
 domains are removed
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:303:83::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LVUPR11MB9857:EE_
X-MS-Office365-Filtering-Correlation-Id: baae1326-a2c2-48fe-a471-08debcd3e356
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|11063799006|6133799003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 1lRm+SJx0RQcIZihYqMY6OAkq3rLwHGZN/kgooZYvaBD67H+FnC0Vmm7FKSFLTVvwnjUQfW4CL+FYU3J1mm4tqrGPSfakvUqpwK3QZ208aWY6udadS3AK81mBLFVVMpTKev+adLiqGR4Y/Z/YemV6Us6LZpx5St02l9QEw6oZf7rKgkYfYN4+XeRX7RICuwj657uYQkIj8KHV0se1iRzOtpmID5kDJzZg1l4WQeZK+xFT+vpAzrGhcwesezEXfztVmG+RSxidDjNZTRZutNzcN8F++1F8Phdm7DDeZbEiLLryMzGqFcRGsmIbrVimVUC54IOp1qDFVo1ChoF+uUwn3oyNplBsDiU8Ygy3cyoWeUWxQZ7Jx9fboGI+p6KzX4sFrjmdFc1Xih+ANZMhwr8PrMeRNWPbZgnVYBPgkjJn4TWtQhB6R46S1oNHmTDQ82zjnUOQZ6D9KPsQLexzTAvfLAs8ES1fCuoSilV4swEvaWIcy0yzXPDRFS9ypFzXPlwMpqUWoc91XwAm/zuENt7XRE6b8k88inrdDF3ju1Qg6W8Ah+qv1dkLqWU436U+sqlo1gujO1AudB0YmLefyLjJd3B+9ZigpsflxPl2I7J4q+CH8vEPzOULkpdGohTFPe9YzHe1heBfwVsXGwbD8qjKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(11063799006)(6133799003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2pDc2lPU1NNQ3NKbnBsK0VHTVlhdzZidCs1M0pUWkt1TkV2SXc2bklzL2lw?=
 =?utf-8?B?QUtFNFJOZ3paUmRMR25ZckFhamova2xNdUQ1aVpFSDczdlphaitTOUxBclVi?=
 =?utf-8?B?aVpGbXZVOWd4aTdCK0tqcFg0cll6eTc2Qm1menM0RFBEUkRIWE8wQm0zZHMx?=
 =?utf-8?B?dkVnUjB1S3dDMkJxRXR5cnhqZ01GaDZIS3JrYjhIWm5lcmpSMEdQZjlPSWhX?=
 =?utf-8?B?VE5qdnp1MENHNDdZRE1XZ09nWVZiYzRBQWFJRmJVd3EzUXFuc29DbDdyc3Z3?=
 =?utf-8?B?UER5dEIzZyt4UExLZ0pVQVVoQVNMdFRpL2Z4UVh3TDNtcXA5bWk1WjBmWUt2?=
 =?utf-8?B?TU10R0xuOVE1aHFQeE5ITjNDRCtFNjhvd09zZjg3YnJWTUcvR01lN2xNSEhK?=
 =?utf-8?B?dXBUbVlDa013OGV5SDFMQ0cxMFRuUFF1UDIwa3BvakQ1SENNZng3VlgxeW1o?=
 =?utf-8?B?SEtCKzBDRW5ZUkJrZUh3M25rRktIVlhBVFJsZVFJYXRrTi8yZ1pRUURrV0xB?=
 =?utf-8?B?MXpFUFJJdHJLeWI0M1RLbnZTQUh2bis5anl0WTJUaUNsL05EeE5laTU0alNs?=
 =?utf-8?B?WjJvZ1k1L2NKdnoxM3lJWXNTajVjc0VUUVhCRkFTdnkyTkVVWll4ZkorZUFX?=
 =?utf-8?B?a1dRKzVBZHpteEF5N3ZMb2luSzk2d3NJeHh4UXFQQlNSNnNrZ05IeTNoSUlF?=
 =?utf-8?B?T2dnV281cll2VGtZWjJxemZwTnhqdlRuV1J2anRHRXlzb09tRXFia1FYVDlW?=
 =?utf-8?B?TE5xSnMzN2VUcURBUTQ2VFJpVENGU1ZQRjhtQ210LzlXVzdrNFpQNlZwV1VX?=
 =?utf-8?B?ZVdRYVJmL1o2RDRNc3NPVEtWMWV1TWo5Y1JuRTZQTnJzU3RRMjVjS2RhTWZo?=
 =?utf-8?B?QUV0VXdWbFEzalFnRGZ4RmExcm5iaWRwNDVZVnM3bE1haFllZDBNRnlBeTdx?=
 =?utf-8?B?RFIzNnY0d0hkMmJ5Z1k1YUJ4UTJDbG5aaXRpY3p0eTBpSStsNjFkMU9Ub1M4?=
 =?utf-8?B?STFhRytNRktRMmZBL3Q0em03cldjNUFYM1ZIYzJJWTBTaWs3a2pTM01yWDFJ?=
 =?utf-8?B?Tm56RHV5SCs1QTViMVN4TklVZCtVZ0JJMnJjM1NZMG40Q0lwaDI0UGFtZTRT?=
 =?utf-8?B?UG5aU0IyUFF4ZVhqL1RCMWt2U3RrM2N4WmZkU0xEaEMrNENickRzMHVLRUpE?=
 =?utf-8?B?bHpqQTkwbHlzWTZqK3FtSlI1Rld5ekZ1Wlk4dERzVEtjMUdweWQ4Z0Q2U1hL?=
 =?utf-8?B?bkg2K2U5RjlzSzZqMXhDZkVQOFdKUmZYNE4zOUlDNXBiSXdwNlhyaGNVSjNr?=
 =?utf-8?B?dHBHQXN4WUhOc2VqYlB3MUxXYVN2REdaM244MUtKN0lMWGVEc2phdGFYREl1?=
 =?utf-8?B?ZForOS9mUTlkRTlzOFE3TEY4SjdiZWN4aDdnczdGeXNBUUtKMXVwc3BEV0xH?=
 =?utf-8?B?WUFmdzlzWnpnekJzc25JUjRMVGZ0Q1l3MjdSUGttT3hYelBoOFVoU1kwWXlY?=
 =?utf-8?B?TFJLL25qbkVPNVBHTTErMmN1NWV4Z1hvckNVQmRCaW1NaGpqQXdFaDZFdWJq?=
 =?utf-8?B?UjVTdmd4VTdDb01UbmVydVA3VjJWQThtQm1haG5oL1gxN014VGVtNHoxdUlK?=
 =?utf-8?B?T0ZHbFhkMG8yMWlSS2J0amMzV2h5WGNFelFIWllQUmxqZlhvRHBWZ3orODJN?=
 =?utf-8?B?WmRyQ2dRcjRZUTh4VG5SdVZPZ2tWblZ4ZDBEZXdFekNhc04yTzBmK2NEQzd1?=
 =?utf-8?B?U2lobFpYbEoyN1NKSUFVZHFKTlBzNzRaWURuclM3Wm5oL3hNcEgxMUw0K0ow?=
 =?utf-8?B?dWRYS25zZWg4VTVhajk4NzFEcWtsbk9aN2wzaGxVTEU4TDhkUzlaVVF6MTIy?=
 =?utf-8?B?MkM1YTRpTzNQRU50NkJLZGkwV0g3dGk3aTF0ODlsUWY2NGlGRUxZQzlZVDlG?=
 =?utf-8?B?TENvcHBYRjB4UEp1MjJsSmUwditLbyt5VDJSVzNEd1NXMVJWRWgwN055ZjlQ?=
 =?utf-8?B?MmtXU3JjUkE0bCtIcklDM0ZrblU4S2VhY29DV29QWkI4YmtNT2RNZDI5Mlhk?=
 =?utf-8?B?QWdIUnozMHJrZGZoRlNCb1hrQlhvZU40bExyS3NzanhDSlVSd2pUYnQxbTN3?=
 =?utf-8?B?S1FMQjdaQ2hKMmZyOHQ5MkthRk83Y1A4ZEZNdFMyR0pzOHpVd1YwSXhzY2tG?=
 =?utf-8?B?emFjZnJUMjk1QUxGOVUwNlYybEJyakhnQTRtTmp5TDBLb2VKV3dBbnRvUTBS?=
 =?utf-8?B?eCttbmd2RUlGUkNWTGdDN3NJdVlXbTljVWx6WThtdHNsazAwL0dPNFhnbE5m?=
 =?utf-8?B?ckRmd3VWdDlUUzVtK2Z3MTdZMVJmL016VlNBbTR6Nk9tdEd5SnAybkFYbDdB?=
 =?utf-8?Q?aDBnf9Q68NDwhLxI=3D?=
X-Exchange-RoutingPolicyChecked: hpQ8RohpKUTZqVkps2LkBHVaCAZ6RJ+C+nCrPefDi0rHrzn0pSdzbOLyvGmAAtSfJMvtkqoi1GE78DLe84Q/MZGPCT/kmLAwAeWbZEkl1emhDnhwPGxLLitfvBo2IfdOj6O/NWubP9/RTk8HFwJrleveNmdDRBLdZF6mU7CPu+M4hGJyv7EEDDxrYZN1BljWIx29sqTKsq5Kg4jR/jYtUdOc5GqBHDq8wrNnM2sHszc9aVNsLTCGy5i911fnRDxkxHHU9rHuTIepxATcNHAx/gl0ED7hqATPO4aKadMA7333d+Bq83Us6rZvZJ+MxNlJv7blKCnYW/M5s2fPa8ZBSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: baae1326-a2c2-48fe-a471-08debcd3e356
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 16:12:17.4766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pTRGWrju3nWr6ZwpIZHjY0tqkKqG7x3Oyh/TfKXqkvQjPRudw0lfw7w/9b/588oRnbW+A/0gTDip29eQ+Mg+9gDwN7HvQw7ymdldOeiga3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR11MB9857
X-OriginatorOrg: intel.com



On 5/22/26 12:15 PM, Reinette Chatre wrote:
> @@ -841,7 +860,10 @@ void mbm_handle_overflow(struct work_struct *work)
>  	struct list_head *head;
>  	struct rdt_resource *r;
>  
> -	cpus_read_lock();
> +	/*
> +	 * Safe to run without CPU hotplug lock. Work is guaranteed to be
> +	 * canceled before the domain structure is removed.
> +	 */
>  	mutex_lock(&rdtgroup_mutex);
>  
>  	/*

I resubmitted the last three patches of series to obtain Sashiko review [1] and
respond to that feedback here:

Sashiko: "Could running this worker without the hotplug lock trigger lockdep splats
and expose the architecture backend to races against CPU hotplug?"

No.

Sashiko points out that the MPAM resctrl_arch_get_config() and resctrl_arch_update_one()
hooks contain lockdep_assert_cpus_held() and since these hooks are called via mbm_handle_overflow()
it seems that this could trigger lockdep splats.

Recent commit f52abe650241 ("fs/resctrl: Disallow the software controller when MBM counters are assignable")
established that MPAM does not support the software controller and these hooks will
thus not be called from overflow handler.

Reinette

[1] https://sashiko.dev/#/patchset/cover.1779834897.git.reinette.chatre%40intel.com
