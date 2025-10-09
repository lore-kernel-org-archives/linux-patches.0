Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24211270EBB
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 20:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760041791; cv=fail; b=IaxhSZj2JFElJ/ge8lextkOQK6C6eP9ZjvuTFQt1hJ72LXjz3LN6yHyFI3P1rwwvsCss+Rdjt+0D0OU4CqYdSEuLgGmXWfroh4caYRZo7ftEgHcGY9pKAw2MRg0Rqqen59n7WGfJY8fXn4e53ZYcBJOL0l6blkQFXpbOmKSh+ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760041791; c=relaxed/simple;
	bh=VuhG2KzeaA3QVAK3ckTiL7jFUtW6cVSOgAzNP0WeKDw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qTtfHFoWdpXngUH3rF0YBJttni52dHtGaj79y9tctbLBChORPgCQv4JcnNQXllB2f7fyLHfL7Bd3nbNOPMaujd57u8+4fmuhxiQJ2sSSy1kFiYZyJRZLpc0P5Hhw0eNFNTVZpD2SzOg4MTOEXXoItUWIQUkFXWmFnrJKQoZFkWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLQa1hwt; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLQa1hwt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760041790; x=1791577790;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VuhG2KzeaA3QVAK3ckTiL7jFUtW6cVSOgAzNP0WeKDw=;
  b=dLQa1hwtcM35hHrCBWS3PK8WbweluXQpmLNb/j9HObqRCX3p4uLD2At1
   cs7K14mNnwUHANcUIjB51PLhg18Y2JDqwU4VQe66mC0IQ0xI+80IINy/U
   KsjGJWW2Xv5q/NR7d+t+6fFHpucOtEmoylN744LPh5/emYdZj0g0HbWto
   LxtSS5CLpyIIQpa9dZmZgqVc5UXqQ54e6oo+w/QhBLsJzyBcZoUqzh6Q1
   QCPDtS3Tmhc+6HLzDfjZI+cUhuJlXM0GUW8NshfdB07XR4ENvCZ0JyCWs
   uqiIZpw2GiZNGnfb0Q8oLJQba0hegG/Phae3UaqQHH6eiXdMspZ0MOLRw
   Q==;
X-CSE-ConnectionGUID: JY3ZXu9tQi+9ZvA5On8Mwg==
X-CSE-MsgGUID: aZ0UZVGcTjOfhrOll/JY5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="84884194"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="84884194"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 13:29:49 -0700
X-CSE-ConnectionGUID: eGD3yKwzTKaJtdee7zGJGw==
X-CSE-MsgGUID: Ptaonh7lQieuk0RNBoHedQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="180755120"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 13:29:49 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 13:29:48 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 13:29:48 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 13:29:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rbOxpwlKropjP619RSv+q1te5j2gzf1HNPpCdL08zpma8I5vpTxVmCBNJbzm6kOBX3dAPy5aGYyLo9xWbF0yMCiM8jT9BYdtQZThkq/WRPT6r7JA1BQHMk8oI4h3TsEphQDNp+Gf1duRkRNEPBmt8KdUKa5tKcj38UEMuzv+UQgMeaP1o6odyjjd7VPxj3qbtISkXbKmMNRD8V6QwabWPn8Iq6It5yGrbKxTVLKHhZLgyi/AH4QKZ+Z1OB4BOrgrgZlIUUB0oCmk6ygSj8eMO+zD5gFSdzS5nRLkSPS75VeN3W78nZWzYuRuuZBzDdHMq12StddebkfM1SfQ4YqeBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mcjNzMXpdZq/hoCBtW2s2VtgOxSs9DgdUbGbJu6xPM=;
 b=XrbPyk8IXi/s+GoBeqLPlbucSXsiAufniECZUwQzJigwWXLuGX7md/95XfSazufkKI6L+9LF+B2vOV+Jb2rPWs9ODrIIt0ZRd9LaQOO0/RMvRMjDv9oZITWBmEIGioPWr+WYYEi2pCJ7HzR1shmWsCjPGASKSlwUI9cWnfvNPNjP9op68QqmG+Hs2e53Kr2GvvfvM+cQvuuY3i2Zuf7ciGxdvEuWiqTSnusV8YwTZUh7pvx04z29gz0371/NP/6fvlELZ8mr6EPgvR2xH5TN2RHMsMn97YJ/iDchjNlVRIHwy/O4Bt60/e2gkr3hoKT3BlidSOh7+i7tBugAbMn+DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF37F43E35D.namprd11.prod.outlook.com (2603:10b6:518:1::d16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Thu, 9 Oct
 2025 20:29:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 20:29:45 +0000
Message-ID: <6778a8af-5312-419e-a064-bcb6a495a207@intel.com>
Date: Thu, 9 Oct 2025 13:29:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
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
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aOf0yA1AWlzJLf8H@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:303:8c::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF37F43E35D:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b5025d-5aad-4656-33ce-08de077295cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WGhmY28xS1pqeU5ESGI0RUhvdnM0RWtsU1NoRDNycGVQU3pZZGVGeWIzTW52?=
 =?utf-8?B?OC9mcmpSeEhoeDhwTk9yRWVHMXR4OVRXRy9YdFZ6dU9IYW1zZ0hhR0QrN1Ir?=
 =?utf-8?B?S1JjMFM1aTVTRnNNK2NVZGhVMks1d3N1VVpkMVlCcUkvaFV1a0hpdzBiWWVw?=
 =?utf-8?B?VEJIaHNVdnhERWsycVFhbk9WNDUyUnpkeXFYYTFaSmhkSEx0QWxUUDI0aVRy?=
 =?utf-8?B?ZTJySG1TaVhyWWlGdzduemVzSC9MK0tVbmJhTWpDYVR4UEdOYURzV1ZWSzM5?=
 =?utf-8?B?VE9QMkFXUk14SU5tSnBGdkhhMzh4bDdyZnF3SlRITEtxd2txK3dlK1QzdnRr?=
 =?utf-8?B?T0w1dTNlNXJGUmFEWmpiSEtwUTlnbVliMjY4MTRqT0FjK0h6dURsK3FSWGp6?=
 =?utf-8?B?QUd1U2xHZ1lpMThDQ0g5N09MMmlpRU1xRk1xWklnQnlZYkljbFFMRi9XZzF0?=
 =?utf-8?B?SnVTVTRXNzFCYTlJc0kzN0lzaHBaMUYyMXNaSHNueVVoMlB0azZZNEhJbVBy?=
 =?utf-8?B?ZUpQdHQ0UjJjMWhMSnBoZ0lQaFJhUWI3TnoxVlFsOHNTVTZDdzVUY0w3OFpO?=
 =?utf-8?B?V25CeSs1ckYwSVl5MXZUc0FnbXM4RlUzR3NFcGJGdjFHeE1yNU9WNEN0T3Y2?=
 =?utf-8?B?Wm9DYWloVm1McTRydkUxVWVjKzc4d3QraHJnT2NPZVlGbnltdmF6UUI5VjYy?=
 =?utf-8?B?WU1uSmowVytsZGV0dVlKdHZpOXdmV2p0eGRNZktGR1BiN1I5dERNdWZrek1H?=
 =?utf-8?B?YVIvYTMyYzVZZnFJdXdsNGZKTFN5R3k0MGxJRHRQWHJqTXhFWUF3cUtwUGNl?=
 =?utf-8?B?R0NRWWJDTFFpRmZiUTJWbXhZcWhTT3I0NG9VYjFpeVd4NVlLM0Y2S1dWZ2pX?=
 =?utf-8?B?SHRNbkRxdkhpdVIyY2pwSDNWdDJtUE10MWdRaGtxdDhnL1didDlFUHEza1N3?=
 =?utf-8?B?dUxrSlVNek5Jc2xINXNOeWgyMWZNdDcrV0t4Zmh2UXV5SlFnTUlYQmp0SmtF?=
 =?utf-8?B?UHd3aVphR1pvVnNBbmFCU0l4SE9iSGpHeHhyRUtSV3plV2MzMFJaRFJPekha?=
 =?utf-8?B?dHQzbVFBKzVManY0Y2gvblFTdXlFRXhLaFZETDZDTFdhVTFpS3FIL0NPbWlv?=
 =?utf-8?B?OHl1VzFvUHJIT1VnZU1OYURvY2gxcGFiampLSThDc2FtQlhTNFptWnMwL2pQ?=
 =?utf-8?B?L2RHSlRNdzVnLzV2bjFCaVo1REdHTE5LSThCUEdON25JOEpEN2gwNkR4b1A0?=
 =?utf-8?B?M1pMRm5qUnFRaXRFaDhKcFowNlgvdWlwVUtrbEtvU3hDTlFleTdJMmdtMGtm?=
 =?utf-8?B?VE04L0R2eHVFb0xESk1pQW9OcFdqajZ4Wlpmc2lKT3JJOUQ1b1V3TkVwelAx?=
 =?utf-8?B?blZHR1cwT2FYZktNNEJadE9wdkZEWG1iR1Roa1F5eUwzVVVpUS9EUVlqdVVM?=
 =?utf-8?B?RGV5blJEZE9jNFlkSzJMRlg5dkFyZ0doaFNnUmUyK255Lyt4d0hUSjFiN3dL?=
 =?utf-8?B?VXF4VmxiUFJ4QnE5SmdwRHViQW5wdGs0eW1Da2VIWHdlR0tBUTQxVE1PUCtS?=
 =?utf-8?B?S25ELzZlbUhEZWw3ZlY1ZVZqZ3FrTmpmdFIrSkFyMzFRNURrS3RrQi8rbWJZ?=
 =?utf-8?B?RXUvWkpwOU5EdlBScU9QTWhNamhtR1lSUnNJTExON2swR1JZTTRPbHJyMmF0?=
 =?utf-8?B?VWxmTkw2cE1BYkZQMUdzSkhOQTJacmpxV1dxM2N6VS82NXZXNVJEbCtoMnJE?=
 =?utf-8?B?VW0zWXRXcjMxRUNKc3JxbVpBMERSN25Gc2d0dU5Hd0JtTEZTaGVaaWFZZms2?=
 =?utf-8?B?OTlCaXgyNmNITWExWGczK2FEdjNpSGpicU0zSXNTOWVXaTMraU9VdVRiaXdq?=
 =?utf-8?B?Z0lXK0hHV2dBay9yRTlKNXhsZlZBd0hkems1VnRvbFBlalZZN0M0a2pvb1No?=
 =?utf-8?Q?9Q4S3KmycZxgHXh5RJ/JWM0WrHYrqYtQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3ZtT2ZiL010TThKUU5HTnRxQUZkWTB0aFYyQVdaaUR4UmsrZU9GcVdGQ1h3?=
 =?utf-8?B?ZHlhS2VaUHpjUmtzS1RlN3FNeWl0azVscld6RjVQcStIT0JsUHo2aWYvaUFr?=
 =?utf-8?B?dkNiWGJwUkQ0KzJMcWF5Ti9JVW1QTGNSUElEdGRlcm1OZ1RBV29wYlU5aVFs?=
 =?utf-8?B?bHV0SU5LM3hmQXZNQms3ZXYrUngwSklhdWhXL1dHVnpGMnRsdDR6SzNkNjgz?=
 =?utf-8?B?WG5VSEk0eG16aVdQN0lVQUtYY0xRK0toaFNaOHNGWnBsSTN0WkJUdHhGcmpr?=
 =?utf-8?B?Wng2TjZmTW1jbUJpMHIyaTNBcUd3S2FuT3h6NmNtdXpLZ0JNWUJCWTBxNmN5?=
 =?utf-8?B?OEtGSkFQYWQxaStrUkZsVytjS09SNENMVWttU2JXRWk5b3JHek5sc0xOSXJ0?=
 =?utf-8?B?a1pUNkF4cDBDd2FvVnhnUXVsTlp6UHZXQ08yMmJiakR3K1VzVXlDWlBHb3ln?=
 =?utf-8?B?cVJReUg2RW1GakJuRGtDYjhPV1RDTmVKcHB0TXlWZ0lkOWNNdXdPR3czcWxZ?=
 =?utf-8?B?MFZML3Z3Z2xFQ2NVZEsrNHRPNjlPRVkxZGVxMzN5R252elVrd0hJK2g5Qys1?=
 =?utf-8?B?MElmVlpGS0E2NjFodFJZcEtSdFNyV2xFdEtLbHRpRlJvZ1crSC9jMFQ3SmZ6?=
 =?utf-8?B?VWY3N3MrYnAxK0FDQVRraGR0bnpQUXFLUzE5MkZ0ejZsRFBweHNuWnh5bmo5?=
 =?utf-8?B?dTdMelJoa0VSMkVoSUkyMjFwWXc0RTN6dExCUVQzTndNSWtJalZTUk1WcjdI?=
 =?utf-8?B?dlRpL3JyREFsY2VKQTNlZkRMcFNkeXhUTm41VXhFOXJXTXhXNkorcjlYMW5W?=
 =?utf-8?B?Z0pyd0pPTFJEaFBzNkpudEJ4VzlyeVR2OWlBdUZHeEpYYUZJNU1pTEFaTFVq?=
 =?utf-8?B?U0ovbVZ5V0RiRGNyMVlURGRFVW1SNFFnUUZDME1lUTZjcUUxdmlvME9DQnRH?=
 =?utf-8?B?RUFlcU9ESkU2aFg5OTlIQkhyUU9qK050TkRVbUQzZ3Nub0c5bmNpaU9qTXM2?=
 =?utf-8?B?eFhoejBrbFU3cFJiWWlJL1Vsak0xSUJZVzFSWVFCRjVDRWxabS9BditEMURF?=
 =?utf-8?B?MjdFUVNBMFBaK1RKQlR3YVgrME1IZFpVS1U5STgxZmhIeUF5SmladjllTytR?=
 =?utf-8?B?cmIwV3RHSzhCUS96QnB1VzREUWdsT1VkeWN4UnZIazVEQ2M0T1BnSnZYZXF5?=
 =?utf-8?B?eG85NlVpODd4K3k1ZUxySERnaUZOek1LOWZCTittUyt3MkhMbjNJVUtiN0ps?=
 =?utf-8?B?bHRiMFBSVlZJMW11TFo1SnB4eng2RFBIL1dyL2hPOUI1UzEyOXNNU2ZXYTBE?=
 =?utf-8?B?QzJGQ2pUa3BhamVjbDh3aDlJNlJXTTMwbEduVXowTkNWS3BwOExVUnpzR1Vr?=
 =?utf-8?B?Qm1JODBKeWpOVnFTMHdrdmYvR3E1YUFUN0gra2pha0lHUHo1T3EyM0dDVHBi?=
 =?utf-8?B?ditFcDVYT1lzQWtWOVJzY21YNFo0RHFHdG9rZmt5ampjUU93UmZoZUNJTnhC?=
 =?utf-8?B?Z2tXWlRNTDZ4S0pkR09LRGNJeGdBdXVRbys1eWhPTXV4YTM3aFhPcEViOE0v?=
 =?utf-8?B?amphaThpdVI5dTZ6bENYbWZXUGtkNDZJTUNlalUxNjhZY0wvTzdQc0tHUm5X?=
 =?utf-8?B?dTRmSjlEYys4c2JVd2c3SmtCOVB1UENwMlBOTWhtWm53akZVYVpCbklrMXBR?=
 =?utf-8?B?cHlsVkxPaUFZRC9VaW5OYlVnZ0k3ZTNXMjhjcWVaTjNMVDNaeXBwUUt3Zy83?=
 =?utf-8?B?N0hmYjVLeXFMZ3I2NkJEdXlVZkFXc2pGZDlOOFI3VUN0V3lDN1BiZ1F1S2ls?=
 =?utf-8?B?bDBjbkhHMkZTODNLOXY4cFJycHZhTnFsSnVpZGpFMGVIOEQ0eXBqQTlaYXFq?=
 =?utf-8?B?RE5Kb1VkREJGMmRCNitCK0RMckJ3WnZsUHRzSEZBMWVKVzg5YlpSeTlDMnZs?=
 =?utf-8?B?bkR5Ymd2REYzQzhGcFEyUHRiUVMwRlZnUjluVlh2aWxOZEE0UGM0UzY0QnZ2?=
 =?utf-8?B?Nm94T2hFUVlBcGpwQ1MvR1NMcGhSMzhMa2ZFTnE3SmpmLzgySTZxczI0djRK?=
 =?utf-8?B?M01NSWltQ2k4VHQyNmIzS3hYejc2eDY3ZTg5YmUyZzRUd1EvTS8rSG11Mllq?=
 =?utf-8?B?dlVBQUx1TDl4WWJwT05KMGRqOTVoVXBWZnZaZXRqWkpIZHo1bGR2VmRvbUNk?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b5025d-5aad-4656-33ce-08de077295cc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 20:29:45.6147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7eLSvvz4g7qJSsTf56E7UGfcIFaGzyb/7iWIOQ6ZvGZYNSXVaOtNZ8I4TLD2lBdaE+PbQKeGA/6NEzNOmqiIb8HjT7fVzhgK7sPBc8o4XEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF37F43E35D
X-OriginatorOrg: intel.com

Hi Tony,

On 10/9/25 10:45 AM, Luck, Tony wrote:
> On Wed, Oct 08, 2025 at 07:16:07PM -0700, Reinette Chatre wrote:
>> Understood. This is not about correctness but making the code easier to understand.
>> What I am aiming for is consistency in the code where the pattern
>> in existing flows use the resource ID as check to direct code flow to resource
>> specific code. In the above flow it uses the monitoring scope. This works of course,
>> but it is an implicit check because the L3 resource is the only one that currently
>> supports the "node" scope and does so when SNC is enabled. 
>> My preference is for the code to be consistent in patterns used and find doing so
>> makes the code easier to read and understand.
>>
> Reinette,
> 
> Should I address this "only one that currently" issue now? Maybe by
> adding a bool "rdt_resource:snc_mode" so the implicit
> 
> 	if (r->mon_scope == RESCTRL_L3_NODE)
> 
> changes to:
> 
> 	if (r->snc_mode)
> 
> There are only two places where SNC mode is checked in this way. The
> others rely on seeing that mon_data::sum is set, or that rr->hdr is
> NULL. So it seems like a very small improvement.

This is not about SNC mode or not but instead about this code being L3
resource specific. 

I see the mon_data::sum and rr->hdr checks as supporting a separate
feature that was introduced to support SNC - it should not be used as
a check for SNC support even though it currently implies this due to SNC
being the only user. Could we not, hypothetically, even use these properties
in the region aware MBM work?

> If we ever add a node scoped resource that isn't related to SNC, it
> would be needed at that point. But I'm not sure why hardware would
> ever do that.

Right. This is not about just what is needed to enable this feature but
about making the code easy to follow for those that attempt to understand,
debug, and/or build on top.

Reinette
