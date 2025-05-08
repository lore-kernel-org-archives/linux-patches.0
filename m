Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B755F15687D
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675150; cv=fail; b=Sxe3FUpJaO5a6qVwm0wxB5EmkeJVl3zdtbqxkXT9gEtDZgoCQCsaCjovoihXOJB1i0mQ6ZYSc5lVUUNWoYtPX6FnagM3FhivmzaG8hNBKJlLkl6MdoQ5GkU2IUWC7ZplfX3Wuxl1Uu7AE8yTkX2Ndyssd1Tf3xKLwf9XF/clGuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675150; c=relaxed/simple;
	bh=OvOEoNeW30Vlo9AX166+aA7a66xVkvLuITrN0zaj6ks=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d02a0JQFRDqq4VqVjVh6JvpFiMvCYI1+pRJ2WHRYVSsJ4m1XfjPB9I7sl9saY24Ry7p+AbhyeNhqeHTo0/GGlAMC6UrrgNZpwcz5zEehk5FpEGQsxVVElGUd5SQ/3x/gK4iRLjmijUUNJu8W6jk2jP1qzgvQ+0D6jPty/ePeZ5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CHOUoR0N; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CHOUoR0N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675146; x=1778211146;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OvOEoNeW30Vlo9AX166+aA7a66xVkvLuITrN0zaj6ks=;
  b=CHOUoR0NyBHngT5dFDcIJCIXwKQWRMXdfSQq76KVHCJ5mHOG6FGTTf5a
   MbDdcMiPS099Gld2kFRs7dDSfkyOgTRCO1n6Cxh8HcW3uQqmKGJv3a3gR
   5VNYL7F2WMcNiel/CpY6RtxAm/3yEVylrHFeRvQOxgJiUuDnLQEplpE7H
   pZOxYZSzDcr1v07ejTdfqzBWZqk9bTjxChqKlbqXR1v/HM5VWP+zI3TF4
   ayi0xYlVOx+/xCPdFFvQrJN3DW0yf8HMra/3eFf9mH1SfM+xVKM9hU+C5
   +rZU6/Ds2u+AzGmIA6MiSLCZocFNB7oasL9AybIhhBQNPcucIc5ggwGvf
   w==;
X-CSE-ConnectionGUID: UHJioBtVTQOcDrSp8U+AnQ==
X-CSE-MsgGUID: Fou2F/E1R6C+ZY0o2XfMsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48305539"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="48305539"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:32:25 -0700
X-CSE-ConnectionGUID: VzMeYhqeTlamvVZaog0iYg==
X-CSE-MsgGUID: 3eXhX/NrTd+23El+qo8yxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="167214884"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:32:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:32:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:32:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:32:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kp9huxd08Ad4nA59D4Ns11o2oYVdUDp43h/xsj/ZUff62HqB+DNA9PVz/ZoPEKvCwWaGoD0QEnCPiiSudPMqGqJUoDzKMgK8lm4he6lvmpvtpYbeY3vGk/GhvgXoKhK7jSA2Ox4NTsC2Og8AuJ0hfJC/eMxwDUkCW5vPMRn0yVuViRELsbd8zIUtP2GlYc0DJRpg+RXA9Ren3tpVxwJyo4V+KQnz2hXYMFf5Yv9BDCNVgMYGk6xt9O7YJCrRZ1CgMX3+JeVizbwYNXldC5xyPSKofMl3bW523Nau8GE6AFO+m5O0Y+r34GwsIz+bUxhmGX4oYTkQgoUbFfmk8+G7Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9AkevmRE/k8U0Z9gYkEWsbFITfVylbUKzA6SKxjfZg=;
 b=C/04kjZrBQ4gF0Pb3zFq9FCRXl23aW6c1hfMnzZq6SNyy+Ss2VWkvZKwx1xmXLHqOkcTRuZNunIn8xZR43azz8dCvXtsUGibWNo3kz4ozZavr9Lla8FkYL/e1/VxOzbkk0kRHiF+gZKbAAW6L9oKqrOWOnCIDl/L01Q4nzLhEhmTAZuOLob4NQKbt1+l1VaLwemaP0lgsb3z3aUuKGk8yf05Wj8LNYIgErcGI+abcQo02/ZkSS8vsd35m/z9HEuViM6Xzj0FjwKnHja1E+JG0yQKUeom5cZGet4pdRCZmvQS4OPzg+d9i3XR2RsPlmF340HGmbQ4zomQfQMSShns9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8513.namprd11.prod.outlook.com (2603:10b6:a03:56e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:32:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:32:20 +0000
Message-ID: <72330b7a-5159-47ce-81e1-28458e4a5719@intel.com>
Date: Wed, 7 May 2025 20:32:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/31] fs/resctrl: Set up Kconfig options for telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:a03:180::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: 6823ae68-ae95-46d3-1a66-08dd8de0f05c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UHh2TkRlM0NWSHljYkpuWlFwdzM2NW5URzEraytGN1I1M1prV3dGUkpmd0xN?=
 =?utf-8?B?anRJT3kzTjlGR1lpWUEwN29kMXF4SVFDZ2RMS3NZNDdVSTBsRVZzVG5BSVBp?=
 =?utf-8?B?V0lGZFFWYitLNlJkSnFHb24xNHE3V3lZRERRYmllR1BSNEppazZqVnhxSE1h?=
 =?utf-8?B?ejlybHpBNlYvL2U0MGhDY0NNTjhmMU84VGNDK0F1dXhDNDNPVU05VFNhZjJX?=
 =?utf-8?B?ZlppT24rYmd6bjhxL2h4S3BrbVg5M3ZKVmxmSXRqeEJvc1dLQTNLK1ZlWHpB?=
 =?utf-8?B?NUpQL2RqbWtHRXUzVjJ1SzZXMjBZYnhDdHNLb2JHRkZZQW4wTm1XSGJQYnA2?=
 =?utf-8?B?L2c1VGxYYVphZkI0d21yUktzbVdPSnM4M2xVVnZVWEJ3MTBKVlhXd2phS2Ex?=
 =?utf-8?B?ZDlzdGNoMFU1S2MzSVhOU0VONHczd1RhbmdmM25Vei9aQTZEUE8vVmU4Z21h?=
 =?utf-8?B?UXk0L252UjNnTkJDWmo1clFveWkwdkhXUTZnS1I1VHh5R2JWeTFVbllrYUY2?=
 =?utf-8?B?VXBmOHBSV0diSHU0RlZyZm83NlgxbzdIblR6OEdNQU5obFdpaFZFZTY3Y2Q5?=
 =?utf-8?B?NGJMd3JTLzl5dDBrTUozb2J3cmRKVFllVUlxc0hnN3pQcGtGV0tTcUdzQVJZ?=
 =?utf-8?B?YzhpMTFzWUlmTUdVS1B4MmdOM3U0OEpQZkNtV3RKL3pDNXdWRHJIZGUzQTls?=
 =?utf-8?B?SmpPb2F4YmlYS1kvaWxMY3BqNWVBSGxGMXRwemtvWEVjWi9mWE1wakJLbEtr?=
 =?utf-8?B?NWlSQkFDSy9yVHBzaVZEendjei9qY2xSeWRGVUJWMHdXVG9YdXZ2MGM3VkZ5?=
 =?utf-8?B?N0orV01sYXY2Q0o5RVhoWFpIUTFncG5PMmRsbmYxWVNKeGhNckJrem1pNzZy?=
 =?utf-8?B?ckNXcnRPNDIrSU9ZeUtyQTd3bHA3NmVPbktkQWhYUS95cmdVTGd1RUlZQjZG?=
 =?utf-8?B?STAxWWQvYVl5VlhnQURNNG1leWJmQmlka3l3bnlLcmxqWlgySUp6VnhMRU43?=
 =?utf-8?B?cGc0K3JqbzZZbXczRmZ0Q2sxak9NTm1XNTBrL0d2OW03OVBjeHltRGRnN1E1?=
 =?utf-8?B?cXMwYVJ6R3RQZVhud2lpZ2tXaDMwV1dqQjNrTHpvaXZPK1UxZ2hnL1RoNUd0?=
 =?utf-8?B?SHY5a2NKUkc1c3hib3dmZ0JsYTJGS0FWZUpxY2p1MEprU1BYRVl3VHBEVFBZ?=
 =?utf-8?B?VkdnQ2RObHhvaktVU1JvQmFYckhSWEMyK29KU3R6ZTVqYlpiL0RYdmx5Q0Ru?=
 =?utf-8?B?bTZuS3BBbE9uYTVOZUlJZGFBSTJxUmpPdkdyMWE5Nlg5bERaQklDN1FQUEoz?=
 =?utf-8?B?d1BZLy9XaHltVUszeDA4WEpvN2g3a0tpazlMK3lnbnpzUlhUL2RRVzhjTnQr?=
 =?utf-8?B?eEhZb2dBd3puVE4zSEo1UEdDbGE3eEVhaWpSRk96STVWeGhXNVhrV0FPeXh1?=
 =?utf-8?B?QjQ0Y2VSTmpkOUs3UFlhWHJIdFlReWUvQWNRTFZ1TUtCK2xOV3RTdlphc3BT?=
 =?utf-8?B?OEJ2RkYvbWdsaXFCWXFRWWIzamlET1hFdkliUXBWSnMzTjBCSUJyWFlsQXBN?=
 =?utf-8?B?SXlkR0pZQjFkRExnbUhkYUdUZkllTGJDNmFKV0xmMFpVVEpneU5YME80dDdI?=
 =?utf-8?B?Vi9VRDRKWHN2UmtTaXlqNG1sRnlVY08zc3ZtbWpiYnVFM1hoaW1PZnoyVFhu?=
 =?utf-8?B?NGthZVhiRHQ3aDRjaGdva016WWp0TmIwalczbWYwQUl1S013NmwzOXlacTVp?=
 =?utf-8?B?VnV3SVJwSVZ6Nm9ESUtqbzJUOUJROHJSU25FTC9yd21DeVY1K3BsbDBXMHl0?=
 =?utf-8?B?M3RpMVpWZzBlYitVWUNwcDVpQ21QNG9QZHo2Ky9JUHNOZmtwamJZekxoTVZX?=
 =?utf-8?B?azlUK2c1REJWU3A5eHRyT0R3aWhCMjdidUh3SEhHOEJhU2lnNkx6QThWb2RO?=
 =?utf-8?B?RkxsaW91Wno0ODFHWG9TdGtjdDVRa0pJWS9Ib0ZPZVdxVFEvRXJWUlkxcit1?=
 =?utf-8?B?M2VLS3lCMWFBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUJkZkVPU0pkeENoSHgzS0VYZFVCVjFZQXhvRWFyVE9FZFJZMXJZOU9yZjdC?=
 =?utf-8?B?Rlhjb25qaUNqTUxFdkcwbkswK3lHKytPU25UQStFM2YyMGQwOElBUmRKK3Bk?=
 =?utf-8?B?MytiUnVlTjFzWWtxVWZBZ2krbE9kTVpsWlUzTDNDMHBmak0rYVMrdjJrT3hm?=
 =?utf-8?B?ajFKMnYxUFhuNXdBRGQwWGJOQkNRMUJpMVpCWkRUMGEyaWQvVlRDR0JYMUE5?=
 =?utf-8?B?K1F2dGY5T3p5K25zaXlUQUx0czI3MEZrWWFmeUFjSEFMVjNBWDVoRzVXZGIr?=
 =?utf-8?B?TS82RXVEZUoyazJBeGV0WFQxdFo4S3pxakRsc1VnQXdVSGhYMnIvUWtCRHZI?=
 =?utf-8?B?a2tsdm1NbVNBcHhXTVgvOXNJKzZ0SHljUVBSMGFEdnd5ZkRaVmk4dk1UY0Rh?=
 =?utf-8?B?dmxZV21aaWlXeEdXeXR2WnoxNzNFRWJJc0h0K2toQzh4dnNDY2JvVHpsZXZ1?=
 =?utf-8?B?bVZyb0tSVnVmTG9vVjhwdHRLT2d0enU1bXA0enZrVXUvNi9CZmxrbXEvZ2lv?=
 =?utf-8?B?RE96L0hoMjJObk9PcEt0TGg3T1B6VnJoTGxOZkUrTzBWcy9ySkd1NVhEazVq?=
 =?utf-8?B?R09ZaW90b1MwWWZGU0ZRR1UyN0tpdm5hUk1iZzJLOFMyeGFOdnhyNGNEZWFs?=
 =?utf-8?B?OEpsUTFYdklXbUFtdmtuaUJkcW1wcDNqb2hpZ2s1SEYyZmZhRHBocGdLNmk5?=
 =?utf-8?B?RVBFYkRieHU3Q284V1RORmJxNTh0WVluUXhHeGJWUGV1OHQ5eTFWcGJOVThr?=
 =?utf-8?B?QTlrbGtTcHdQUXRpeGowVis5WjhVL0FPdjF2aG4rajJQNXFBK0gxOVo2NFQx?=
 =?utf-8?B?NEkvY3g4RnpuclBSdTVud0FteHlVK1BRWGhkRnNLNHNKTU84UUg3K2t6aDJm?=
 =?utf-8?B?eUpINWFKdFY0NGlRUXo0RktKQTZRUEFpYzhDN0xNVGpkSW95d25yYlc0Mzd2?=
 =?utf-8?B?TzlvN3dISFZhV29DQmdWQ3JSMG94TlFXSUJ3amVzclJmMWxqNDhKZk1PY1RO?=
 =?utf-8?B?V21aRGtiU2Z1YUZBNlhwUjhhMXVVaXNYcVRWRnlQMElNN29KMWx3UmdGVVVY?=
 =?utf-8?B?bTRXOGZpS0FKU1hXZjVXTFFkbTJVN2NDRmJCWUw3ejZhWjMvVFJYeUx2emht?=
 =?utf-8?B?RE1FWWRZRmFHQ2E3aGdoUlZuN2owZG9Ddy80UEdkZlVWUnVkTldrL2UwQTlm?=
 =?utf-8?B?cGtDNFBnWkVDNjB3UDRWWHorOGRTaFdKQmZiU2JmRE5VVm5mcXY3dGhhLzVE?=
 =?utf-8?B?UXp4dEh6cnVJTkUxenV2MEt3YlhkQnIyTVQrV214YkZBekxhOXRjdXBvVjRo?=
 =?utf-8?B?djYvOStNbkRqYTRZWmJ1eGhXMGp6SGFLc01KZDQvSEtBVTZzMGV5VjNvbVhu?=
 =?utf-8?B?a25waHFERDVwN052d2lNcG9uRjM1YkhzMTVjalZzWXd4cGl5SUtYM3FvQ1FO?=
 =?utf-8?B?ZTlaRDJwQlZ3OXcxSVJzOE05SUJJallpVHU1YUNMd2M0L1pWYmFaRnU1eUsr?=
 =?utf-8?B?a013aTRVKzlEQ1p0dVVmUnBEdE1mWXBsMzViclVZZHViZjJWODcrSzJ4b1Y3?=
 =?utf-8?B?U0F4OWUrTmtJajlMcCtza2ZGK25DRG9OWHN6K2F5QSszd3JxN04xS2Nmc1E3?=
 =?utf-8?B?OFJHMUIzWFdEOVJLdFdBanpucFVIK0ltb0VKdEdnSUF2MUkxRUFxalJYQjRG?=
 =?utf-8?B?TkRVWUliQ2hHbjdwNnMyRTNmU3ZtT0dmQTRMaXBlR3VWSnp0MklIRmxINmZW?=
 =?utf-8?B?K0ZsdlF6SGc2OGdueG9KcEo4R1VndUN1RUF6ektEdGRwcGRyT25jQVUrWk1Y?=
 =?utf-8?B?cXJlaGhTSUUyM1p2MmhscDQ5MDJTMHJsNWN6eG04ckF3aitQZFdTdEhkQUsy?=
 =?utf-8?B?b3lmMVdrM0dScFZmRnErNGJZb2kwcmhISTU4RExZbDZ4dHBDS3dSZHVUeUQ4?=
 =?utf-8?B?S2djNFlzVnRJL2JJV2NBaDJsSWFYNUp2Q2wxSklibHorZHNINXFDTWdLRHUz?=
 =?utf-8?B?N2ZjVVhXY3hQZlhjK3hHSjd2L2VUK0VsVG5mYXdidStuZ3lrblFTbEZzZVNj?=
 =?utf-8?B?UUU2TlJqN3o4T3k1YmZ0YStBTjBiVXc1UlNON2loVXRTNjdPNEZFQnZEbUtR?=
 =?utf-8?B?UHBUempxSnprWERSYUZjV2dteUFnRnNpSU5FVjRaQlU3bEg3T2ZKbXVjejcz?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6823ae68-ae95-46d3-1a66-08dd8de0f05c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:32:20.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZno7boZYgk97/py2VLjwDRnC8CGbm9INtV9m1bi2feLHPMVTC0alBo5mi93Ns4ASCVpQzNvsT5r5uzGI2138bafoVLEHbKTcoLBvnPS6GY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8513
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> Intel RMID based telemetry events are counted by each CPU core
> and then aggregated by one or more per-socket micro controllers.
> Enumeration support is provided by the Intel PMT subsystem.
> 
> N.B. Patches for the Intel PMT system are still in progress.
> They will define an INTEL_PMT_DISCOVERY Kconfig symbol that
> will be one of the dependencies. This is commented out for
> now. Final version will include this dependency.
> 
> arch/x86 selects this option based on:

Portion of changelog seems to be missing ... what does "this option" refer to?

> 
> X86_64: Counter registers are in MMIO space. There is no readq()
> function on 32-bit. Emulation is possible with readl(), but there
> are races. Running 32-bit kernels on systems that support this
> feature seems pointless.

This seems to be the primary dependency that requires the use of
a Kconfig symbol.

> 
> CPU_SUP_INTEL: It is an Intel specific feature.

While this is an Intel specific feature it looks to me as though 
intel_pmt_get_regions_by_feature() will return -ENODEV if it is not supported.

I think there is benefit to have this code compiled as much as
possible. An alternative to this CPU_SUP_INTEL dependency may be to add a
vendor check in the pre-mount callback to match the other Intel vs AMD,
but this may not be necessary?


> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/Kconfig                       | 1 +
>  drivers/platform/x86/intel/pmt/Kconfig | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5a09acf41c8e..19107fdb4264 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -508,6 +508,7 @@ config X86_CPU_RESCTRL
>  	bool "x86 CPU resource control support"
>  	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
>  	depends on MISC_FILESYSTEMS
> +	select INTEL_AET_RESCTRL if (X86_64 && CPU_SUP_INTEL)
>  	select ARCH_HAS_CPU_RESCTRL
>  	select RESCTRL_FS
>  	select RESCTRL_FS_PSEUDO_LOCK
> diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
> index e916fc966221..3a8ce39d1004 100644
> --- a/drivers/platform/x86/intel/pmt/Kconfig
> +++ b/drivers/platform/x86/intel/pmt/Kconfig
> @@ -38,3 +38,10 @@ config INTEL_PMT_CRASHLOG
>  
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called intel_pmt_crashlog.
> +
> +config INTEL_AET_RESCTRL
> +	depends on INTEL_PMT_TELEMETRY # && INTEL_PMT_DISCOVERY
> +	bool
> +	help
> +	  Architecture config should "select" this option to enable
> +	  support for RMID telemetry events in the resctrl file system.


Reinette


