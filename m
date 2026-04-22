Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C783446C5
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 22:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776895866; cv=fail; b=kMmhOUmXpZ+gag1ppI9M1MCDs5mTiXbNSK2qAa2OiYyIiBPW2vZO98XpvnjhN6Sg+C/Sk5g7s2Bl4Q9D0Kh50qMhplFXDvglybwZftQSHWeIR1PWUnljNAvZ8gfuyziRQ54TmTnMBCFkr6kZ/N2sCM6f/WdLzy70JMEJBNwO5lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776895866; c=relaxed/simple;
	bh=MiLBJWrj2DJtRTp5XpDf54t9s1d9cNvF6ZLpt40WrlY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PQIRvTe42HYxMPXinT+ieWVIXxsH4lvrei3ssg9rbDBxKJbv7ldFSB11mDAzMshV6Ccejgf51WDzzdfnkDJoEjevG6pYUXWfyCkKIRtJiYDRF/Llw3i43lmO7RtcfCHnANNFhc2VwOB97RK86dt8/5lh9X3pd9D/5Gppb1qLCU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=db1SmbLG; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="db1SmbLG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776895865; x=1808431865;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MiLBJWrj2DJtRTp5XpDf54t9s1d9cNvF6ZLpt40WrlY=;
  b=db1SmbLGHhiJbX5aoFf89zEo6KvUfubJl5PXD1Dj/sL6JylokbkTZS+h
   HHUbXIVUitmM8IlIYUG6q3etKMJHYQ8G27qDv7VwiD+MAIKgEwRLUQ+9W
   vcYijI8w9UK7AVDwUKGBM5WVfajWHpFNBDpM0Duf9zn1B4ORso1+a+RSu
   rGUsL4vE26RrfZMC6Z3njD2z75aq//xYFFFt8lL4SBJ3aHj5a3kk2WXZd
   /qcO9uNP+VkO092eglDquLFlOgXN6dA76UnbV8+YB3XyQsHEDmWdHyHIa
   HrVeAWEkuiz2dlTQ9hdoIWV5TR6HWqlqw6bjnfl6hFuD7rHMOAvQe5+oj
   w==;
X-CSE-ConnectionGUID: aiB0pl4TRGmJNSTr0kivxg==
X-CSE-MsgGUID: PSFyFcO8R8yjolVtASsw6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="89248341"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="89248341"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 15:11:04 -0700
X-CSE-ConnectionGUID: IveHoyKzRtixv2Gy7JLq4Q==
X-CSE-MsgGUID: QDK+z54lTRy02KkWF4DAKw==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 15:11:04 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 15:11:03 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 15:11:03 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 15:11:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+9X1iqmue0gxRisNsK1DrQMpaUIoPyjxM0rMYnUlrm1UwpR3+WQZYB87r9TOOE8yWyvwZrJC2Kbe4LpgnIAypmPtYW4BgsanCCn5LvJtmIwp4UQchOR5kjr2t5uxVFGTF/Stead7uQR5/qSDkRB1IdJf/VouygH7paQb3CsrTTxFRJuIzZ/oOfmRqlnW51uy0vTtfUIy8us3Dtmlxy8tsV8952/LgAOtY49TlvEsJ1sU/eLnQAoqIiaKOSneAFSgZLHt95tkwrcQ59XQmhY+rsYRLOxKeAlB7FcQK2BoBTXb2vLxB8culJRBkSr+tAytPl7DLyu7GQ+XVqztN4rBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSjnjl3a16e38DNB1O2XXDmNRkFFNsZtB2MUZqRcT+U=;
 b=H+N+Eo+pnD1aNX27tUukse+K+BtyktlSdr+UyFzrq5pNVAsy5gr7Uh56rBIst4DH+GLEOjoOPiAJVG2VLw+7W7t1cmTh06K+J3n8hFrEAGT3/haSWXAqrhmdT3qEP9IDB9ybwzQ8GprQ46qOHA4fmUY7zgYCTJGliRl6sbZvCNw+06DcD36lIzDZx50z5+5A2YCwceU17tW81grufttrNYZmTUD6UEfFXBJqGczcuxhgX8ANbnn5R+5NuwzOAB+N5XI147SISLTulCr+vFokCzVEH9bNexUPJcCwESgBqdiPG0N1EIrGX1dhEIru0rQ8fgW0y5GIO6Xsu6026caFEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN0PR11MB5986.namprd11.prod.outlook.com (2603:10b6:208:371::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Wed, 22 Apr
 2026 22:11:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9846.014; Wed, 22 Apr 2026
 22:11:01 +0000
Message-ID: <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
Date: Wed, 22 Apr 2026 15:10:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
 <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
 <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:303:8e::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN0PR11MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fdce26f-4675-4242-749e-08dea0bc09ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: hncMOYSCKHrxg4gICCWgBtwzKqNj7p+3mZuyiUbR6z/v7ZFM4ZqJUlQRATCcuqgUIr5OOZ9UtuyHtuw3kNo5kYY1tZrqIZcn2MR2CW1h6lB/CHRdqWsyoe+Up0/nfqEwkXQOph3Re8oJeW1KTO1e/OEn4uuwo6qjNeR5aw/0/1CwxsTClJgZx76Q4WGd6Zhj6RTv39jybmZYANob5Y2DLUPLxb+F0org3Io6HbbQ9zGYlJMurRRU0E7ROAzF9wRKEeufmKs37978PIKX1NFBfPatSGnWYOGeqDx9a9XjE+boZOmOBT2Qagu1SdGrALgxJtdro+8xg2j8BPlrPsgm5CPbgmVy2udaJW7MbPFp2+mhI1HEslnmifu/6SweOZpAJC/FYBRwPvQVh/rEgrO/vD1grUqqe1SWSfaSsda1qM+0kx3tYZf96HfpWau4lMHjx/2HOC7+5b7yUDLr3OZ2LnAIVfLo4R1ZqGR3VLNOqUY2dUsbQUk1W6iX3nsgHogkey2NIfesVmSqsV+0emYTXTqxI8d6e03kPj86W4vBOdlXDFDuvyZnI/Gk36WXFhXqVSEyLbiF1+NWCc5FKkvA+asVKlR/L56jfnkzGCWWiEoIcxEBlgKihqREHa/00ClytUYHdqjzObISYmGlMHJwk+2F5tZOpablXMs1EUyEgShohXDFXjY10xw9EbCjl5F1hA0EW9VuU9QDWKZcbr30JiZU8/rXFgwCn9P9hZzJL3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUlMUU5oZ2xBZk0zZ2svWnorRFRBa3Vabnp0MkhVYWRYY2RxSVJXSHkvU0Uz?=
 =?utf-8?B?WlduZG1uWlNlaFo2Tm8xc2c5OW9lVFQ1alBaajhLYzFOckhSYURuVUxWWUV4?=
 =?utf-8?B?Rlh1dG9qYy9KTUx3Wm52eGJjTWtQN1ZoaDBycWIxTXlod3dhWSsyckxFZEpK?=
 =?utf-8?B?cW1jbU03VngyaFN2ZHVGdWZmTll0cWRaSitCSTRPc1p5bU5OWmJ3QlREeTJU?=
 =?utf-8?B?RnArS0pzbmE0YVdkcGRoTk5CSzJQTytMbGFPTUNBYWJnejI0c1d5VlNqUFZX?=
 =?utf-8?B?djNOZElKZG9sWGl0V0xaKzNOQWhCVmJUbzFmQW9Iakc0MC84dysrNVg0bitU?=
 =?utf-8?B?U3RxNjJmL0tlZnQzWFJIbk5mczNlS2VEVlRRcGJpczJZVVRwSng3dzExWVpY?=
 =?utf-8?B?dk5lUXgwekVHMDFvM2pJa3RVRnY5VVJrT2xuREFjQ0ozNVdJYXFFUHpST0Zu?=
 =?utf-8?B?SFUvSm9jM21tRVU4cDdxMHdsdGlxTXhmNGRZK0hJL3lDblh0akg1cU56WktW?=
 =?utf-8?B?alZ4TVUxOFQ4VTV3TDhNYmc1V0ZQaS9FU0htUWRqZWRDd3g0NlFRdUlMMXRD?=
 =?utf-8?B?d0E4RHZ4WEJFb24xdVJXZ09wTTcvTG04VHNRbDlXbXRHMHYwRDB3VUNqNkh3?=
 =?utf-8?B?OEdyOVdJTW1KaVV5UUhnRHBlaldkVFYvY0ZsdjBhRkVIVXhXOElqaXc2YkdH?=
 =?utf-8?B?TnN1aTcvRVFXekJYSWdHL1dzVUF5ZnZnZjc4Wis3SkhNK1ppN2d0cjk2K3VS?=
 =?utf-8?B?TnZMWmk1RWtuMHZWdjNUMFJSTGhHcGI4UUYzRm1aVVh2MkkzUG5hdHBabFRZ?=
 =?utf-8?B?UjBsazI5N3ZoQTc2MWlBYk9LeVhvS1ljK1NMQjdYSEorc2s1WkoyK2ZTRWRu?=
 =?utf-8?B?K2ovNFRLRkRydlMxVGE5dnNFYzNIYzZ6TDMyV1AyMHc0Nk01Y2xVbzVsS0NB?=
 =?utf-8?B?R1BGMjlDTnJqYlZuR0FCWDhJdnRxS0c3UStHY0dla1lITTNRcVo0WEx6OGxm?=
 =?utf-8?B?TGUyeUg4VzJkSTR6M2VUNDF6RnJHcTN0RU5KRkwyWUczanhCVDhCMXFoRUJ6?=
 =?utf-8?B?S1o3WnMxS2tEUmFMTkIycENieE5mL2NKY0xLQlJtUjl5VERSRWZVSytaZDM4?=
 =?utf-8?B?Vi9CZjE3ZUR3bWVUVVFRci8wTFF0WVJVR3VPd1FEcVk0UC9QQjByWFdNRHVR?=
 =?utf-8?B?Q2taMjllcGVmNXNwWk05L3VwazNMTlZyVitMQUVWZ3FQcVZYV29NNzJ1c3M1?=
 =?utf-8?B?SGRYZFEvSm9DN001S280ZnF1Mi9vVWVIaUR1cFNqWXVHMkg0UXFkV1JuZUhD?=
 =?utf-8?B?bXhhcWM5aXdRdEtTQ25RVVBzMmZQQ24rNFVmRnpyanVJQjlSUU1wVDV1V0pV?=
 =?utf-8?B?N2gyY21DK3pLYTY4bHk0Y2pPL0pMUU9PZU5pWmQrNEg5ZzA4V0ZGY2c1eVdh?=
 =?utf-8?B?bkVMdnZ6cnIxWVhORkhOVzR5TjcybzM5ck9TdDVZYXVycHptOHk2SFdVM0xs?=
 =?utf-8?B?N3l2cVYzcWsxRmtvaSs4R1k0K0FFcjJPSmpTZjhYTzJCWmNZOG9nQitYalFv?=
 =?utf-8?B?QjUvSStBTHk0KzlnQVdrNkR2ZDdqeHZOY2ErTEt4QzZlWVZOeVVtQ2lnTW9K?=
 =?utf-8?B?ZEorZ1RHc09jaTlFU2ZFTUJiUyt6dHJia0VWeUkzR0xTMU1NMVBtczkwVFBL?=
 =?utf-8?B?dVArQU9QSmhqUVJ4aGJnei9Objh5aHBXY2FhTm4waVlkWmhMaGtnMEtzTDdJ?=
 =?utf-8?B?N1RsVklFdUJLS0IzdlhIZmNOaHEyUU1yUTh5UkZVSkZsMWMxeFlRY0pjK3hm?=
 =?utf-8?B?RVB0aDFvQWdtNStwR1k2VEpoMEJUVWJORGxmZHJ4ZlpKTXJ2VHNnMjVMMzlN?=
 =?utf-8?B?eWRiZ0RhWDcwcXBLZWJZWHc0VmRkbDVLZUpweWRwR3lrcVJ6N1dJVmF2Unk4?=
 =?utf-8?B?aFRrUEFVajJibmJVb3V1RlgvSmlySktJUGw4NlBYMGZnN2VCRGxQU1M4eTd3?=
 =?utf-8?B?OENqL2JBVUNBRGVxa3g3dXp1OEQxU0FBaWlTVVpVaG9JWml2YzFSRmQxczYv?=
 =?utf-8?B?MVpudytlbys4UUVTTmdVVldXZURoaDM0SmJ6bDYrZW9adjB1aGNna3NJQ3hI?=
 =?utf-8?B?c1FadXJmUU1XdXZPakdYTllHMm1TcHF0Qkg1NWxNK1BqSjRKRTdwdGRUM2U2?=
 =?utf-8?B?QXFVTFozTXdBRWhUUUxXcHg4NmpXc0hqY2gzR08zb1JVNEV6cWpudkVCc3Bv?=
 =?utf-8?B?OFJwR1hMR2FkMm84ZDN6d2lDclEwRVo0L3FoNVpFNkdjVEZ6LzlzT0NHcnBr?=
 =?utf-8?B?YjA5VHJVY3RBcVF6amVBb01OK25kT1BLVDJ3a0dqU2dwdkVxL1BMeXZkaUVY?=
 =?utf-8?Q?SJ10sqflmuIUOGJ4=3D?=
X-Exchange-RoutingPolicyChecked: Uus3/ga3Y6vC5eYcPuu55B4JkTQNMP3df83ZIQT4/+wHaYbpmf8Zj5HaOan4dWxozfQp+tNChSNl7lwJi2wYj+Lccicxt9R2cjn7rGYndhXK82roVkbbzQtx8U0r7AdHOxpwmEAWUOLLRBc1OudhBnMLmB02eKx1Z4hLQfzfDyls9mRqzVdHiqA3gHRxU7or+qwWci1WoNONM4SbdTIZFUb02ClokZkuvH7I/wMvWeP581Cuv42G6VKAlWn2QFz234cZ2hpMIQZ/i3eMi8SR5sHEAW5DE+n8tPkPpokGpxt+ChTXBugspktxfmzz2JgPwTF5IUv8sA3GDI3BtsOdMA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fdce26f-4675-4242-749e-08dea0bc09ec
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 22:11:01.5227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uu1ZAN+N/bj4x4nz9J1lR/Auo/TbdA1SjQzBVXdspimNDCV+Jesd+hoeVH4/4slTRuOEU9rqXODokNrsIekm5B8EcJ/dm4WlkzqlMyO4ebQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5986
X-OriginatorOrg: intel.com

Hi Tony,

On 4/22/26 2:59 PM, Luck, Tony wrote:
>>> Seems OK. But to make sure that events are accessible, architecture will
>>> now have to "hold" the pmt_telemetry module regardless of whether
>>> resctrl file system is mounted.
>>
>> Could you please elaborate why this is required? if I understand correctly the
>> "hold" on the pmt_telemetry module will be done by itself between the
>> intel_pmt_get_regions_by_feature() and intel_pmt_put_feature_group() calls.
> 
> If architecture code runs completely asynchronously to resctrl mount/unmount

Since there is shared state that is managed via existing locks I do not see
architecture running completely asynchronously to resctrl mount/unmount.

> when would it be safe to call intel_pmt_put_feature_group()?

I think I am missing something here since I have been assuming all along
that intel_pmt_put_feature_group() is and will continue to be called from the
new unmount handler.

Reinette
