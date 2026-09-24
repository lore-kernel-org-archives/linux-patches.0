Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B32B4BF941
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282605; cv=fail; b=OOC+BIjbkyZPEqbO4r2e1YBY1RNQfzz6zaFQS3XwlmnjUygIyE/1rj9cGRSLHwogpIi+R66FN1TbB9PPjZNV2LVkKwnzNhkkDe909db+aJGXT0Fo6XDn0iwgcqI1ry/IagT/IE4Uh64pcC/VzfxHcoh5LrSvsbviwnyfNq5crtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282605; c=relaxed/simple;
	bh=RkiL40eXb5S0vWUCxNXQCl5YZsi75vk22KWBu/pN1cY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d/5fXU2jHZWPgUUPC9uAz0HXCADbdL5PNgsdIWvPVi+IHjPGmOxh9u2uuOKxbL5isAPoQb3iXzHOOO7FiksLzWDg+8Ru+rkaGNsCjUBLLF0Enp5d2DUFL0oPXgANz0DEO4sz28oJY9bfYx+5yEuYAM/hHhNL8WjCLOdcKHY3OlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lvg7mpaS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lvg7mpaS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790282604; x=1821818604;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RkiL40eXb5S0vWUCxNXQCl5YZsi75vk22KWBu/pN1cY=;
  b=lvg7mpaSRynp6hDSXTgFibOzs+Oxi38TL+KRd5YhZp3n3Y1hNT/L9W7g
   odZ7t0biUjppZF9szqLpYKSD1ZRRVBF7LXGk1SKQZUBTcmLely/ZsfT34
   uzPwtmLQgolRgzDQw/XQgbSqlSG2lUjGmzx/b52p87Y1IFANod5Z+nYse
   u7c5FZ5TK4Hbborbf0ceJ7EkjwJUSi4IN9xmxdXqEO0ZzXyK5XhMyO+Y4
   bbFXynKMvMzh3tj/c2qMDHmVwcu5Cp10QWhHJN5V5BTKb4LTUSW+kIYKm
   4FEnnmdSUhFI9hE0XvoGMSca2bHFPJXOzHQZ2vvpr3V5H+DDK8ofDhYpN
   A==;
X-CSE-ConnectionGUID: Q0jz3WA7SoylSwoVDe6czg==
X-CSE-MsgGUID: B54AsAKSSzOJibqciUgR6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="108559588"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="108559588"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:43:23 -0700
X-CSE-ConnectionGUID: HJhhPoC5QtK9aC3cRA+v2Q==
X-CSE-MsgGUID: dbjHX+KXRdGQsVl9Q3GPRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="303663896"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:43:22 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:43:21 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:43:21 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.66) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:43:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFptQpaZtLwiR09bJ3qlEANsyqjYvNKcVcV4oK+2FMh64zmuFo9bOlVclR/ygvv4amWSSpxw/lbupa6fklIaSxJWpL7ezwUrzHSVjGmCfiHWanvpV8MiUr3dU5MYAttbkafktmCYtQTEBLf/InqnRlwnhyO2p9BDi5E7xO/YLX0Le8mdcJbfU4A8LjuZ76idMsASCUVavq4b6c7LQwrpOVyeDfsR93bcpbk0w6Kn4sdLns+aHaIVLfDSbQgyu2u6AmNDMlhTtN0wqdyyhqn/FZcICrFwO79aT9hwon2yUHyTwINqwgDCHFH67Hh7G3ixrbEqUqfVugejbLGnE8LRvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtA0DaOVflqxW3PeL+R4nzc8usD9SkYkR8Dr390ZFA4=;
 b=UOci+1Ih/ZzLz+6eFi85aHck2SKS6Pwd3evr9N+Nr/ASG9MpIQrSPD0TJycv7mOjLZ31i1RjbB4nu1n7GUxkfxH6X/Sr2QsctP6a9o0mZaaKtJ4MzSPyY6LAFSJiFy2Swv5sgUoBT80tTM/gMxqh/7IuI+EkBttwzkczQwdEVmz7hkbiQybbhvXNYum8ioeQ+kGfdk1aOeuHYUT+ak2UV9aCJBpSYOByzo6gvOSI7yi1724IKKwzk/UlTHnnKMuZaggAJ6RGj6PaYnB3km5Dynp1yQifmo+dd/OjG7AxtVRSzNBzCnePUrEqeYMfkXIflQcKAfP/PFyVvfCq+aGy2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB9509.namprd11.prod.outlook.com (2603:10b6:806:47e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:43:20 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:43:19 +0000
Message-ID: <bee6fe64-6562-406a-b8b9-b544a0de96de@intel.com>
Date: Thu, 24 Sep 2026 13:43:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 16/25] x86/resctrl: Add PMT registration API for AET
 enumeration callbacks
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-17-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::31) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB9509:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f8e4509-3931-4f2a-4810-08df1a7c7791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|18002099003|56012099006|6133799003|22082099003|4143699003|11063799006|921020;
X-Microsoft-Antispam-Message-Info: EOqsgAIwMrxqmlWg3gvchkEmQwuBMuyWMti04LEVA1Jhzf2A3z9E983CiSUz8PfLLiEZQTXcDSUAE0j1aU/wzYXLzwlAPmzvAuZbzCaNLWW5d+oDyROrxohm7qgnNkBu4a6Ebq5rshqy4WG11RuYLWnA9ucnni9NabIk7m4/OIsm+5KzlCIxgSNBl2GoG3rCwj5AUqRoCx/IafRg0QSZl+NyMjEDiGXbOzr1uyfmZiqe87hU6FbjX6N7YgFESLdypHATAVVQ/r8ecGRPY9te1NrZmYDnju6zSdw/6SH48kPi1nS9usPY4K+aKS+KOsnl2EXHdfkpov7Hl80ysVJxdZLIyFIkuR9chgVfcElbU4cmkQaUMPFnzBT9TD7YjPw53J6F08yofCRA7DM81JsSuxMTSSWSJKLtVkbpRRvWjOMujCHlFPIWf6PU63SgxxG7M/wTwPjEVCKQ87GIKKQO8n26VPbq9pQ9tKemxshBdOv6tqRCxfwF/xTXeTmD2hK08jGLD3/zU3qlY++w2DZNJDjRHj1EhdK9wMggh8aoMVkrGoTvljdrwU5zfQcKZmnhlDKObERm7U2ZSUxV5kAff/sJoQgI1BIUhwtTfk0f03x1LsxaLacNGZTSVxPhqHuC0YHK8H4nQQwRlxozCT/pF7LgGuCTxCeICt4fgZx5dWfsly36bmGQQY+HhL3UdlbWd4DoFK02fW8lBFUhX7fx0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(18002099003)(56012099006)(6133799003)(22082099003)(4143699003)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWV2dlZ3NGNTZFBDalk5b1gzM3hJYmo5L2lLdW0xUldhdnF2Z3psanpuVUFn?=
 =?utf-8?B?eUxHeEt3WXF2TElJcS9hMkpwdlFqTG95NGJ1cFMrQ0F5dzdrMEllT25jcUVC?=
 =?utf-8?B?QWxUY1plaUt4REp4bFJ0V3BERUlpYWRrengrdEtrMmxybjludWZ1eXFURHpt?=
 =?utf-8?B?RXZCT3FnNnFOT0NtSk40eGEzenBqY2JRK1E4WktGVjBTeENyL2hnT2VEa21W?=
 =?utf-8?B?SzRWTDhTVTdqQVJqTnNacmtFdlprYUdTUVV5Y2dDbzJRb1U0ZlN4MEprakdj?=
 =?utf-8?B?Ym12QjhBcnNpT2dkK2l6RnFYTkd1YkNKc2NFMW9hZUhyK0RTbjZSSHB0SXNz?=
 =?utf-8?B?eUV2UldpVXUwWEV5dzRaaEtkc1F4ZnlKY21QdmNBTmkySDNacUdERUF4bGha?=
 =?utf-8?B?bkNoRDhJKzl2Q294WTFWY3J1ZzlncU1YdU50UnY5THRoeUhGOHdidFh3ZDcr?=
 =?utf-8?B?Nzk3azh4ZE1YYy9OOFd4K3ZaYWh4ckd2MVFPUExwdzhJYnpCUDlkalUzNTZS?=
 =?utf-8?B?dnRweEtNeGdZODhNY0pndDhUR2theHphM3FsOXBFK2s1ZUFGSmMzUmtIaVhY?=
 =?utf-8?B?VnFSOHFBeHZLSkpRNkFGRzUxd01UT0lMSE5rSWxCcXhCVEN3Qis4a3dYbXZ5?=
 =?utf-8?B?VC9wN25DRkM4ZGY0YjNyMDkrRlZNUWlEUkViRDdDWFd6SS9XMU5vcENHbzVJ?=
 =?utf-8?B?ZitUT1BaTm1USC8xTDBwZTNiNzZwYTZVM2NQRmZKdkpkRE5qckpxeWtEcDU0?=
 =?utf-8?B?S052TkZ5Z2NHNHR0U2FsZzl6Q3B5NFEvNkdzdkRWbUMyNzJkMU1FcEtYQkRW?=
 =?utf-8?B?ak4rY3pySVRXMVpQL3Qzdjc5UXkrTlh0T1oxaWxVa0dtek91OVovdG82UDRi?=
 =?utf-8?B?b254R1NqR2s4cEdITVZ4T1gzeUxiSXRDWlMzTzBXamVCYWtjN3VvaWYyVXYy?=
 =?utf-8?B?eFRmNTlZdmUvUENraVNqdDg1ZmR3dzVHNVlBZUIxOGtqOGFZajdIMktnNWlX?=
 =?utf-8?B?YkNjaDNIWnQ0V21yZnk4dFZuaUZqeStYV2k3cmE3dHZtNlZyYnZQS0c2RUJJ?=
 =?utf-8?B?RkNmNVU3K3oyN2JxTi8vcml6anFpT285aU84QVFZdXVjd3NVKzFibUNYaTFy?=
 =?utf-8?B?Q3lkUktNNFlvanZ3YUVPakNrMjRQSW9jSG1hSFEzNm9RSE13OUdSNXREU1Ix?=
 =?utf-8?B?Z3VYMEc5MDFORkRudTA1VG0rVTlKeWZDNzRZcXdXcElKRW4rWElJTWpraWtG?=
 =?utf-8?B?cjdEbkxUL1V0UlFyeEdCS0NjVGk1QkticllWcU9tMFBjUWVzeldZK3Z0bkkw?=
 =?utf-8?B?MW51R25iVjNHODl3WUNlZ0lHZ1Z5UVZqVFhqNlpRR0JPenRITTlMUGllYTR4?=
 =?utf-8?B?dExpSWltWldISm1FbWUrbjlRYmVKVERQWG9UMUxtUHppYm41VFMzUU8zcFEy?=
 =?utf-8?B?WGNtSjE5UDE4eTBQYThCcHQyWkVneUJNQ3B1NWJKVlpyK1JmeWtaWHVwRnN2?=
 =?utf-8?B?MVlBRFJnNTlHRmhPb1ZkZE12TmNVL1gxY1hNK2xIbkRUTk52WUw2NU5JVGlh?=
 =?utf-8?B?QVVKZmYxdlpBY1k0Q2tSKzhpYkpHRTlNa0Vzdzd4UU9EVVI0SklaaGdKMEtZ?=
 =?utf-8?B?NmxPMTluNzR4ZXVMQ2M3VlVDNEJJeTlHNnRreWZyckg1MC9ueU9pa2JjUnpi?=
 =?utf-8?B?eWJuaTBwM3pWTGN6Ri80SkxORDhxd3N1MnYzY09VVVJUMjNkZzF5S1Awa2ZG?=
 =?utf-8?B?ZWRyaWhzMERMd01IZlFra09XVmN1SmlJdk42NkFQY1lRNGljWVRHZWpidnVo?=
 =?utf-8?B?aDQ0QktGZTNUWTJqOFNucjRyeVkySzlZejEwditBQlF2SjR0LytPcmoyaDk1?=
 =?utf-8?B?ZGJmSUlBY1JiZ1hqdXlPT2RpbHVVZGlGWVlvZmErUFg0MzAyQU9jbTVRamVK?=
 =?utf-8?B?WDVSS0lHckV0RUhTbW0rY3FWUDNCUE1LbFlycmVYUUtKWXFMMnFjQ002SDZ6?=
 =?utf-8?B?Um5GalRiQk1Feit0Y0s0NUlZNmhXSWcvTUNaaThoeTZ1QWMreWo5b1hteFdD?=
 =?utf-8?B?eE1JdHZKd3pobnRkNGpoK0Rwd2JPYk04Q2dobGVtZVRYcjMvV050TlVwd0xL?=
 =?utf-8?B?T3kxd3YxSkk5N0gzUmZINERNVnJsbjIwTTZvUmhpM1lRdURpOW5zTUpWaDlj?=
 =?utf-8?B?UmF6dEJLWUpLN1RLb2dUaDZyMzJyWHM1MER2Z1F3eWRDTGNUNkU5QXdEUGVj?=
 =?utf-8?B?bGJNbjE0WWRJcWp1QTFpaVFwNU81RzBGd3dIMWtIeHlkWnRNN0RtQUU3WUti?=
 =?utf-8?B?Y2RZbys4N0FnbGFoaG8vdTlVeXc3UHRidWg5eUJwa3c2cCtyOUVzM1lyVzNT?=
 =?utf-8?Q?xCpHqf1wb4yLHYQM=3D?=
X-Exchange-RoutingPolicyChecked: aN2mVUBSGky9czsOARNpJHQiEn3EHbaVhMBiPo+Aj/dCy2HhCYVePAdsc1JNtIfHuiJXu8D3CXbNrw4IqeytP+QwM1D6vGFfefO4b86GN/OoSTx4DBjrCDAUsTaxcn7xTuf8cD6gbjon3dms+n01EFCbGxzhq2xuWuAgZ3MO1INKJeFLclySR/6/WbLgLrkeKkYQuCHzhx9v7NsgoqvlkzgbkaIpXGzMmMOJUigRgNs80QCzbdOd0avhCad1CRGvPVqKyl5KjmBebU30v1oCYZzx+zwn983utAD+tYdQsL8ZD9B8a9xCM5pxSpBDuToCL13JHSPCKbpHUglAJl0RlA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8e4509-3931-4f2a-4810-08df1a7c7791
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:43:19.5437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVvI9My4X+PnvW2XZZWN3+h+KOUFSIp0qATAbBaFBXtMU4pRWbE4a56pvCVPQ1yN0a5edT/zFGJJEQEXHjkxozTS0VJmHcGwp0c6wNuYlU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9509
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module. 

This is not accurate context because at this point pmt_telemetry is still
required to be built in when AET is in use. The inaccurate context makes
this seem like a bugfix.

> Add, and
> export, register/unregister functions so the PMT module can supply/clear

nit: To keep things simple please always use the same term when referring
to the same thing. For example, so far the series used pmt_telemetry module
and now it switches to PMT module. 

> enumeration callback functions when loaded/unloaded.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
Reinette
