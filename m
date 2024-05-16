Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36FA2D054
	for <patches@lists.linux.dev>; Thu, 16 May 2024 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715849903; cv=fail; b=GBfRI/ruUtnEMm68KHx8ekWZEZONqP6oAtx6iMVc+ikLcWT3NhFPhE8ljGpci7VsDQW92W19aICdVP4BlJJXUE8PR3o2o66FelBtqYJH6aQGk4x4zK+CB/rdGYHC/G+NWQZBzdR7lhPOC18xGSzeF9p/qqokNqgSC8gg0MXGG3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715849903; c=relaxed/simple;
	bh=/g8LI4WAnHTSLPi+rC+pTdC9dHGpzMujh1erEtOVb0c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D87flypLiGw2M55c38sXIn7mKUQQJoHNYRaGB++oW3qPwVEctHjF9uVG4tBvCSGnIq8cQjONqLyhNsPLYWyswo65ZemLBmk8bq5q6lbUU8KhWxYuYpFOV4gOQdFVpkgV8REG3ea7VxzX211pz2xpoMAsM5zUR3PMpHVQFSL4Kbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TkmSYS9+; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TkmSYS9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715849900; x=1747385900;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/g8LI4WAnHTSLPi+rC+pTdC9dHGpzMujh1erEtOVb0c=;
  b=TkmSYS9+W/lXO4XLf5jpa4zKeavokRQeqkard1ESSK6b7oyBTJQIjajT
   3TBJhlNoH4Inz2a4quEHPhEYGyAR3bl/kBCwfgyGMkBvb4UtJtYupXs7l
   kZEz2Hn8aBtcS4rmZlY4rsdOMGI4dEl/xAu4jziG5rrXJR17c5hNF+Aug
   pSYcLSQxsEpIHLq9uTjYd5RvgJZJ5jxS+bbhRIZuUEkavkNcsVBhKpNCg
   WkpSllyIJ1X3SqqRTBNKvOXVvyKgo+8djcra8qOynYJs4gLHXu6uU41fx
   UigR/bjm2iX3NqA1Li6qMvtJz2huJa6q5+tDs/1yVdFDZSwrphujdA4C8
   g==;
X-CSE-ConnectionGUID: WKkH3ppJS86ZgFIsrCdsGQ==
X-CSE-MsgGUID: S8hkDLfBS/K0mG4qMX9kgA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22525875"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="22525875"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 01:58:19 -0700
X-CSE-ConnectionGUID: AUQQesfFSNW825XMxzUuHA==
X-CSE-MsgGUID: 5k6aogFARdqcM84E/STqwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="31289319"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 01:58:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 01:58:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 01:58:17 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 01:57:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BENL6eYjkJmPACtzOpOxzSAGwC7+t3nQ1hFn1W1/3EfNvUhnLFiXlcWFd78WZFmQVqeWGIkiTNV7NndDP+OeMzJsD8dv00905XLz2l7vFpKrczoixp40q9w3fi45jpNphwLoV84/YFHT4ubA+72sjELKQppMYK0AnOj0i+J10L1Q/tjjRMPzow+TbFYLp9UI8rXg/jifo+Mm0ftjRyowCLLnOwQfePQbxM1T0fjtzNQUCNoY+oR41uqbj3HFr3mM9A0j2oG/UWAUOXu+PcdAcN5CwfFBUqKvicYK38PcJ9DVD5Otiv10l4267SyKGZg5WENox+Ii5fEMAutSFQ4kPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFvb+mU0JzPnw4FDo8l+bs2f2v263AAiTWggq6XeC54=;
 b=U6/GV1dt2iZYIQSfJT7RcwFG4DJy8z67t6vZnf91rUefiAQdv4tilwFxoKAxG9uEvETrirDA50cdnaoIjxmcLsI3ETv/np+N2h63wk/AmCa6nOUma2jKKjB1j/77aSW8S21/YRasW+m7HsOcVqmLV/0iVHvlaCgHgWfLrcYMnp/3XZAeLBV/jYL3rUiYqgu0kZ/FFogtYp+7U05y57rFgEFtV10SDopui0yJ4nZ9oFHPLjwS52mScnzLV/Gr2aYuw1fUM+n4jGrqquaCpYun1sb7Z0aWyxywC38EmdMSMdOjTO41elenboHpO/TSkA1JPJM3LsJWMysr7FRqGQzmzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6231.namprd11.prod.outlook.com (2603:10b6:208:3c4::15)
 by DS0PR11MB8668.namprd11.prod.outlook.com (2603:10b6:8:1b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Thu, 16 May
 2024 08:57:35 +0000
Received: from MN0PR11MB6231.namprd11.prod.outlook.com
 ([fe80::a137:ffd0:97a3:1db4]) by MN0PR11MB6231.namprd11.prod.outlook.com
 ([fe80::a137:ffd0:97a3:1db4%3]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 08:57:35 +0000
Date: Thu, 16 May 2024 10:57:21 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "James
 Morse" <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v18 17/17] x86/resctrl: Update documentation with
 Sub-NUMA cluster changes
Message-ID: <az7n7nj6bl5ixyb2xxdoxtjaye4kbhm2bw6sdz63h2btvo3n7a@bo4hlxxtu4nf>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-18-tony.luck@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240515222326.74166-18-tony.luck@intel.com>
X-ClientProxiedBy: DU2PR04CA0316.eurprd04.prod.outlook.com
 (2603:10a6:10:2b5::21) To MN0PR11MB6231.namprd11.prod.outlook.com
 (2603:10b6:208:3c4::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6231:EE_|DS0PR11MB8668:EE_
X-MS-Office365-Filtering-Correlation-Id: cc18a993-e3aa-4a4b-c30f-08dc75863aa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Zu6A4x2el7j3x6+uUOZrjavpz669+Kb1/2u3TgDvWTV6ZPgBAhJkLjJGPG?=
 =?iso-8859-1?Q?LHx2go1bEENXK3XxbT7Ks+3BG2T9YnCKfqXvv0CnZjoR9dji7QFSZ/X5R0?=
 =?iso-8859-1?Q?qt/txYXCvlJ40BvVbIrkULydJ2N0rRESc1aDA8z4ux3Uka0MYAo0OFGZ10?=
 =?iso-8859-1?Q?8JAHS8i3PC9gsiht8cwh/T+7dOgIfpcAK7aVjntWSRGKDxT6bCmE8pMRHF?=
 =?iso-8859-1?Q?T5nEFzSsMKJ7+sOoqfl2RONZgVGH+DaPBcetgbGKnson/Fu6/COMlIuy0u?=
 =?iso-8859-1?Q?RVnkoqV7zvae/9ap9agKbn0ENzZlv/3zWlLx8WqOPYbDjAEBImKwlp0n6C?=
 =?iso-8859-1?Q?PTJkwcs9L5lCXlUwkAnq2WyP9lZAxT4bHWq3kZRiSKATpWKEqk2B2wgIoi?=
 =?iso-8859-1?Q?jumC58E55V04F1+c8Vf+hctC0iADU5GfS8z5t5TXxNPUJFCaYpJ/IOVijB?=
 =?iso-8859-1?Q?kFG7Krnj3AOn2hslBLIR+i/lZ515IU1CapNC1D6ZCqm2VybfRPt2x9Mtsg?=
 =?iso-8859-1?Q?mXcmtcv4QM6Z/pncRfmmTLe90uVaK/qa1sX41tAKKEA2RWqXAmCeHTrY7g?=
 =?iso-8859-1?Q?8vEfhFw/9292qiLyYYszehLBW5CgysGtLpH0PHQODa7KvCK/k6mrkEzMor?=
 =?iso-8859-1?Q?7+mS4G08odPGOQstVByJR0ToIPf8oFnJ6khn3YvZkl+thfJBMZMajYImTC?=
 =?iso-8859-1?Q?OxqYC64LdrcnJp5pFEabf3f239jJHZd0y5l1QE4eUHmTEhJ9TCmtmiU9rb?=
 =?iso-8859-1?Q?EGXh7G1GdBIJRQzwc7wGPpynjDfBLrrnIaQ3Y8XxzemfMg1s05ZDwq0Zdu?=
 =?iso-8859-1?Q?oDQ08xbmpnLaptJCodhJmjeBKZA8Ysd7QhUjZ5NFJYj9TDUp7m9GOKMdo4?=
 =?iso-8859-1?Q?UKVufet36bdjoy7TJb8aOPCOMzoQB45xgXEhk3apPj9qL8m9jeN+paoKNH?=
 =?iso-8859-1?Q?iBVRROL+pmBLocfS8W+H1yk1J+rkRYsRIRDFk1at0h19lEsqcaRuyV3uYS?=
 =?iso-8859-1?Q?K5mpSV9v9LpRUwXrJJOPimSz/9vS4OalRv6GfEOCtV1YNKC3e9NKUKfUuj?=
 =?iso-8859-1?Q?1Yq+Huzxkv0KZRVNSj32MrdfTj17AwH+Wan8On5plda3iJ+yIMjPHl8XZ8?=
 =?iso-8859-1?Q?21CLspMB/hSmWw5QJE0JaHUCL3kVRfnT8Y+IbBTeGrdoaQahtRDJAhPQgx?=
 =?iso-8859-1?Q?By9vAPQYkl3q/yCJw3jDNhH4nUu3U9fQh4icQ+0gcJWVxYIOdlFdgdpKwF?=
 =?iso-8859-1?Q?Bf+CLfH1UroKIl1XBTtO7m1F7r9ZUBfGyPh8eW8ECSUu3m7lIZs361keT7?=
 =?iso-8859-1?Q?uvh3xaBthfbqifkAFZTt5Tl5tQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6231.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?kwzyre1YDd2m45X39SPLWqevxrKAIBv8J2JMp7Q7JAc+9DCyLz0Mh7fzr8?=
 =?iso-8859-1?Q?HBVU724PC2qBH/hKBo91VCAvLpTwLsLiB5PbFQSZ0ZwMg9uWRpSQx4oIeO?=
 =?iso-8859-1?Q?5SrcnhoMelcI/Da/AkccFHvVKpdAOh2WVdYF0bfGfTcs3Vbxl11paUNaO2?=
 =?iso-8859-1?Q?QZzB32vYheo2RDtmNzttl7FDqF8kjFJs/VEdZ1RmAfrQ+advcAB/nmBgyJ?=
 =?iso-8859-1?Q?3odhSF4lhAGlKOGwxeSqLoAeFgnBhmuS1J7iLGf/0PGnH0iSWwxC3FFpjs?=
 =?iso-8859-1?Q?nDYJkt/3X3G5dtgNxWINyNXUEKzKtvrtQZ5MJusxQAS14UDZMtuQNM0+J5?=
 =?iso-8859-1?Q?pR1pkoUbHgKhv9t7ddEmcyQixMWj8V6bcmedjLcyzi5AMGltqD0tvs+KP/?=
 =?iso-8859-1?Q?gBQgYOxPpCkcKQ39IMbGEq9y4ihMIJ2OeDAe62SaJCjlNudacTu7rSpQZ9?=
 =?iso-8859-1?Q?CrOeiaJXoJwzC8uvNPTP36XHGN5QUwMBAKoAhJNvZlTtzbMj6WGyQYBE9U?=
 =?iso-8859-1?Q?zfenQxB6n94jcmAjhMTZ/Xm4dVhEwQOCo+HAuAJ3huUT1WFrCFzX1fV03v?=
 =?iso-8859-1?Q?RdxUasycWzUtXtj1hDqSo7gc2RsdrKGQpP3oHxx6uwh6I3e1TQ+DzL05pF?=
 =?iso-8859-1?Q?5oSMjK/vOvSfX7jjIOOFAVlc5fwgjTL5knc/GTR8pEILAi4BKGGNUlS7yr?=
 =?iso-8859-1?Q?RSjc0TSC5HCpAv/X0sBkwHdcaYfxKKJ+AstgZYKXNEVR5IwqwClBscPWUH?=
 =?iso-8859-1?Q?RJPiVr73a+aDvkTT9a87Eloi2ml3UFeOCAKVcMZvzpHxFfMNJfdWTJ5H7r?=
 =?iso-8859-1?Q?UqxgIiIuqQA/SV06L5RLTZez8CWbG2xvOGZ0xL+gaQOmJHtT58kP61Tm5X?=
 =?iso-8859-1?Q?Ob3dRNlZi35ClNHenOS6vs03uIuT0sLu7aIb9wDxhWOvrRTvMdq0C3xEll?=
 =?iso-8859-1?Q?YTxvvAntpVLtjaq8J7WHD57YuBz50IGqIP+fyfKeYCYvNfDnLEDU30nP1E?=
 =?iso-8859-1?Q?TaeD+i5kC2iuOiLwgSUIeE44uh4yoov7s8+ur6CttPElI2tMg0Y9TLi3hR?=
 =?iso-8859-1?Q?glBQ21x3Sdmv/gTlxU+u7NgaoTnW5rtl+7AOC0b8/n7cm512dtAcmLQzDi?=
 =?iso-8859-1?Q?IlKdVqLZQ1gOQMT2yCheLUc8BFEEjsDDZ9DZ0MQ6tjWReH8c+9+LJsMPUd?=
 =?iso-8859-1?Q?iwjnsNTgWzz4wV/Q2hjshF1eflzdxKgQ3IsYlK4LujEO+XBOsAoF4aKZEb?=
 =?iso-8859-1?Q?QlPWEJAS+8cjWF81K+cauGs/7cfg9tFtILLPkB/iAEB+0dfUSf6x+lAPLp?=
 =?iso-8859-1?Q?3da/rbTiLfPgsIUkW/eZ3PDSxom5qu2bl24qp37QYr/yctdmj0EHiSDDF6?=
 =?iso-8859-1?Q?chTwFEnvhPJIKqbfaTDSpKlOGU6uSLoh6L2QPHLL6v8hba27hlc1TJXHBd?=
 =?iso-8859-1?Q?FQOmZ3pP0F2sioDw9C5IosNphk4vf65pmQfafXDaGMzcdOJZebk+1hPAW/?=
 =?iso-8859-1?Q?vKqzUfM4Ehduw87iRFMpgTstafKTi+KrnjuU9uRlmHKmy0Yrj9AKMl+/Qr?=
 =?iso-8859-1?Q?aNN4zjXDcHVNhpUdVxseaeomD0fwQI1Q7anko/7+R3ze+DshzUZHqszliP?=
 =?iso-8859-1?Q?dQh4Bvky6LVXbyIcVPOfUWCS6rhqRxCbWsN9EUTumBtRuvSPp5G0L+fcGs?=
 =?iso-8859-1?Q?MJhNFQV05BF5tuqguBo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc18a993-e3aa-4a4b-c30f-08dc75863aa9
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6231.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:57:35.1893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8EskTCcjBaueGqUVJ7WF0k69zCIdKJ4BUs3ofnUoSjsjL6xEEiEBRf3NvSMYI5L4KjxZ4dJ38ibR+lv170a6mgXRuorq9oJ9mSpmQ9TqoLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8668
X-OriginatorOrg: intel.com

On 2024-05-15 at 15:23:25 -0700, Tony Luck wrote:
>*** This patch needs updating for new files for monitoring ***

Is this note here by accident? New files seem to be mentioned in the patch.

>
>With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
>per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
>their name refer to Sub-NUMA nodes instead of L3 cache ids.
>
>Users should be aware that SNC mode also affects the amount of L3 cache
>available for allocation within each SNC node.
>
>Signed-off-by: Tony Luck <tony.luck@intel.com>
>---
> Documentation/arch/x86/resctrl.rst | 17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>
>diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
>index 627e23869bca..401f6bfb4a3c 100644
>--- a/Documentation/arch/x86/resctrl.rst
>+++ b/Documentation/arch/x86/resctrl.rst
>@@ -375,6 +375,10 @@ When monitoring is enabled all MON groups will also contain:
> 	all tasks in the group. In CTRL_MON groups these files provide
> 	the sum for all tasks in the CTRL_MON group and all tasks in
> 	MON groups. Please see example section for more details on usage.
>+	On systems with Sub-NUMA (SNC) cluster enabled there are extra
>+	directories for each node (located within the "mon_L3_XX" directory
>+	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
>+	where "YY" is the node number.
> 
> "mon_hw_id":
> 	Available only with debug option. The identifier used by hardware
>@@ -484,6 +488,19 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
> each bit represents 5% of the capacity of the cache. You could partition
> the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
> 
>+Notes on Sub-NUMA Cluster mode
>+==============================
>+When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
>+nodes much more readily than between regular NUMA nodes since the CPUs
>+on Sub-NUMA nodes share the same L3 cache and the system may report
>+the NUMA distance between Sub-NUMA nodes with a lower value than used
>+for regular NUMA nodes.
>+The top-level monitoring files in each "mon_L3_XX" directory provide
>+the sum of data across all SNC nodes sharing an L3 cache instance.
>+Users who bind tasks to the CPUs of a specific Sub-NUMA node can read
>+the "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes" in the
>+"mon_sub_L3_YY" directories to get node local data.
>+
> Memory bandwidth Allocation and monitoring
> ==========================================
> 
>-- 
>2.44.0
>

-- 
Kind regards
Maciej Wieczór-Retman
