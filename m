Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5B74D7946
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351434; cv=fail; b=nn2O0049Puqod0XO+Y2y3RgbjeJgAf8AUmy1BmMHRumn1pjT7PgYO3C+j6AuhQGzx41X+dVO6aKQKyv1K3jf5oftWkIbBzBI1EaAn/Zp/V+hOeGQOMZ2qIe9emeE1TJKsa02Qc9Q8Qx/CJqZOsignF7FHWM67M4qq3zaQkIzX8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351434; c=relaxed/simple;
	bh=RdZMXOTWmgQwjCJXjAL/it9eMUFW9AEnuRD7u/6CIbQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F6//42OfdeyqjDMtvZ+1ZNAd1/qQTsc7duRO+qHsOYthLrbk7dXovQLD68o0zQSQp9NUcuwkzDqUZ5X76HOJu5r5FdbLkEdtXVsSEdfc/blQJk2IZ0FqZnUzAyv10oBux5PJrsFTQeXwirZPprpOidAAtKhLohhXIdEKhqXmBIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iOcHfoa0; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iOcHfoa0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790351432; x=1821887432;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=RdZMXOTWmgQwjCJXjAL/it9eMUFW9AEnuRD7u/6CIbQ=;
  b=iOcHfoa0vFYEBIRFkE4LuQOnZ6XmM9GZpolciuLSpHFLuS0QxScE7KwM
   ZtTQu573Ot/9Q3D750VIzy6wHDiTBv6Y4Lk4Rkk6WQESOVzPrgrkq4f+m
   mUNWMoI9OBJJFe6KpbO0xe9XbaO3mkuwUirscwPrS/HhafSOgCCi5VT7T
   O4ifKEO0Y0szER6ZWdhIIMFHPbOjvUPfnnKkYVoBVBcgWGij1yxpScCjm
   9TMU++GbDBimbN5sZJeUvMGTv85g+ArDeEdBPMQA+9ydA7p6XfrrZ7iEl
   9ZsQYYxFLby4mbqgL0rGJK9Of9Oa4aiPTTIZSiov8g05q601TtnWWLd30
   A==;
X-CSE-ConnectionGUID: LX4G4ZGGS/+gATe+z2IRdQ==
X-CSE-MsgGUID: PeU/GqcHSmma298W8e7PHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="101311371"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="101311371"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 08:50:31 -0700
X-CSE-ConnectionGUID: Vhy40p5eTZqap90aduiejQ==
X-CSE-MsgGUID: rcw1BN3MSoSmIPbM3EGozg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="273586342"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 08:50:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 08:50:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 25 Sep 2026 08:50:29 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.42)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 08:50:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rx6vRVaiMouPPQCRsjVVWBQbzsPpwyBk+keWZz59xHLeI42SxY81lN1wGIDvAXBExltdcsDSb/zjxpu/oY5QUKORgZg5B5Xt768hUJ249/Ll+HZ0LEopfp8Kdc9dEZu3FII5rL9OGbVrpImWgTSnvu0dBDNYN6Ge7u0o51+YxbMpsxP/ElOkuh5xOug/SYuX1Nylhfn0IE38uRM7gqnZ0GjyVUx9mt3IUB0rCvJSZs02TjcrsYU7jjLdYAmFabrMiu9Vwj9oFNEC9JKdeRZknvrodjM0h+HOq4kFh9zrepCgftO+6K35BkWvprXSLp2+T8GzT2CzzFf69Iw20AijOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VaHSVFGiY8P0hwbpm9IrEiF2KESVQOqQxW+C95/yvc0=;
 b=RljFdUIj/6OwN561WLXn4MeFjzpIDft3TMfsJN3dpqrwsOiLw9J9usejVhipA0QQ/AD11X/TXP//KZGR39SX7ljGiBa0TK+ErZBcjlDZA5RWHOKC1nT+4QSK8DMfCixOOqtxYXNN78KkIsuPaNKg+wsn2yslESJHqEADcBcYwBIuWEj9EJAuODpjbDe3NN+aCAVpn03IYes9J5WshNR+VD+m5DQy0z2qml6BUkmn5j6J7uae9qKUYtQDhQw1S+nQc0WWxuEVGLoj3LOn2M9pfu3cMo/opJBynryROdPANY3We4cqj/MG9cMuWHglD9MNRxZ08qOChe12ECM6GmYnTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS7PR11MB7949.namprd11.prod.outlook.com (2603:10b6:8:eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 15:50:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 15:50:26 +0000
Date: Fri, 25 Sep 2026 08:50:25 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 15/25] x86,fs/resctrl: Handle systems where AET is
 the only resource
Message-ID: <araYQUCPvnBH_Qlj@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-16-tony.luck@intel.com>
 <39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com>
 <arW6xlQWVWkixiWe@agluck-desk3>
 <110d2c7f-8354-4d25-aff8-cd5ceb46334b@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <110d2c7f-8354-4d25-aff8-cd5ceb46334b@intel.com>
X-ClientProxiedBy: SJ0PR05CA0135.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::20) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS7PR11MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f4a44af-d6f5-4f0c-d645-08df1b1cb798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|11063799006|4143699003|10067099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: f77vpOIvUJk7wm/pjFbYMs7XifAZPgIvfAtHjYbolSaNmhseKvFt/WMJsBYiYgtENriY4Lvxy3ZAvMZUC4lyOwDJl61C0vMaOC/Hbec5ZazmXEVz8URl/vvkR0jBQEnqqYyXAM5NBObPB1/vQdyPIkSM3wJI43lr8/eQmGK6Mh99r8VeY1dXbqECpfjszI0xe9b0hl7RvoidekjEMzXGYz3s3gEzNIHjpPc7CwTfna9vpUiBKYpX52Mdk9jtAJ+cL8iRjjbfBrJ1zZuxEBvIgWhDZv7JTpBWmV3KwbPAGatn0O5FKIWqKwrKTFq4FxmyyGh2o+01tJGU+Ve20w/PQcgyGR8/9jAftpnCGvhPkSPp1bmz9cz/anoFsHB64bIeecj6YbSkoduHL8xG9RLYygSrqdm5//Mu5iYhmxnL/YcnvkqncT7uBMfAN+18Wk8DBQ5fVW0aOnbBXUT2cY4fUeBKfcaIqE0/7fJEsz0txv1epMIQfcH9yuvJWvPKA0apjB5dt/GHDZb82jxnGbRIhzoxqmzLPYg4A4w5h6yqkjq0R/Hh4BNR9oEO3q3bdamjaQITZzzcFZbU7Py46qI6pZZfa1urvGceVJ0i479WOKgATGXO+VNhwIkb59GyQCAZa18vY13cMZeBC2MlZZe/h/YOrcVSvu2cz9F/FRO7GcQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(11063799006)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?XEPXWTNSK8LCYGD3NJ4+LjXtpJwQ7GFu8C8P0/O0xMJRHU4KKNyvWLMbK1?=
 =?iso-8859-1?Q?5lfRSIdoRxFoF+k7C2O7zcR7dN+6Brh850oPCwu9SYzWPdShCU2DjSXhYQ?=
 =?iso-8859-1?Q?ck2lIHw6oP2ct72Si5qLrBIEsKgzWyM8rbXULfJH43CnAX/3R5VwPt8ku9?=
 =?iso-8859-1?Q?IHwpVL9DBSKInbh5PnM+D4+nVB4HfF6433K1BrJU5BtdMpFj1y2xY8eAeH?=
 =?iso-8859-1?Q?Gh9c7x5l8k3hbwF4wdy82Ro2mSyuxu4WgxdZIsMNMmRPgNyI26+2NiEQUT?=
 =?iso-8859-1?Q?aJNZEfyP2sWutx23nouhdv3FE/tEYag0S1owvM90pm6jlr3uqT4kQ0YlZH?=
 =?iso-8859-1?Q?bcPcxn1PR9dd1NemULqNftZgW8dCLhuSLKdcKdESAoR8Y0MMY84iULoeqi?=
 =?iso-8859-1?Q?1O70kKdy90ZLTo6Xfs5W6BhtIBIpkKmJNlg+z8KEyOmzpiu3FVTi7zlbfd?=
 =?iso-8859-1?Q?T0/fY6a2ykL3xNbK2vkZqKmIojiZtzXulPgJN5LG9P3K/1kINAKwPHRLk9?=
 =?iso-8859-1?Q?BhdeYQlOUQvGd0r5Cbr1cgAGublbDuQjgjZR1HDYSqvAc0aLslwkvZ+ofF?=
 =?iso-8859-1?Q?KrJHLanhfbGsQFCKeOMcF57V5a7ebIjbnVbZ62cR4etx2eI2FQGbDG/pTj?=
 =?iso-8859-1?Q?i+lu2pQ+OTJ7P8J/khtid6HkKyRUTGuOM21Tmbmj3ajbiqV7tURZZht2iB?=
 =?iso-8859-1?Q?+L87YxDdzvvg57UfK3EnlBoBzNOBOI+Q+Hrv7YZZHywAHmoJPnmTd2Z3Ln?=
 =?iso-8859-1?Q?qe+AF9n72AUqiVhY4zZ5y/154rFEp2cAgbKZ5ybCchO3RV7f15Aa0ZTNU/?=
 =?iso-8859-1?Q?tOaT+xyvHZuymG4ioVKSGAn+7nPvHVO6ea+GI4lyLUtYzxzXmKQ7Vj0rdD?=
 =?iso-8859-1?Q?ofK4fD/aULdcGCfuUtYBXWQC80ZhcLYZZe19TfDvDKe7Lli3WcYgluU0bg?=
 =?iso-8859-1?Q?1K0G9UnmzpyWgO0al3bZw1VzuzpcuEFFGKMEmh8XULt/a2ZikB3nQQCkQx?=
 =?iso-8859-1?Q?UJVPWTGqOadNR/ovZhGmoweBsyq2q0IYvADnOeCC0Wa+EpmP7RBUHRp/Ca?=
 =?iso-8859-1?Q?pk1hA+hWSW6qngIe1Yk7/k++nuTRMcRDE3Zs7XrO0GGHB8SILXHr0aZUQ0?=
 =?iso-8859-1?Q?b3K5e4LVJRkKbJYixhJl+qUVDHeXro2+FJMzHNBwlqNu0yrJzuBZ9MWX1W?=
 =?iso-8859-1?Q?8uhhjVlzVJWbl0dO5dUI0gUMPhkSp0dEp0v+Y2YEr1EJHqj8gN1uNxyZ8R?=
 =?iso-8859-1?Q?36k5T/Hjs31EaD+zRovuJPvxGZztZ83Zr/3qaN2Vp3w9PnKsw4ZPHrcH3W?=
 =?iso-8859-1?Q?N8VgAVBFdNfvIje+6AZfcgrQeUAhGwy491kdWPiyRE/BwTiiY3z3z9fi4C?=
 =?iso-8859-1?Q?HkoUNT6bFv6DxbZV1WUs0kyt+iuaEeW6OBvvtQooZ69nF8a3J4i4e2qKKZ?=
 =?iso-8859-1?Q?ytB6sD+dwoef/xqhcCrEq50Ya/vvSXpNpMhCn2Jsm0hB0+DHjveuah08Tu?=
 =?iso-8859-1?Q?hH1KbA1WTGTnfudSRXdSj2F123vrJqXhgnWmbsiIP1rOjQ1HGof5L6BORj?=
 =?iso-8859-1?Q?9ZJe1FNaL158TkUV50g/4FCni2geUcfSQYeW0y+AvJqNPosgwBKGRdeBd0?=
 =?iso-8859-1?Q?rogNFEL/GqxRxRwqXf2RLf7Of7aNiojRWrEbC4rPJEadOR0aKz96ph7KLV?=
 =?iso-8859-1?Q?yQmB6u/QR0w33YSlFp54K63j9ZWGm2e1b3y7uCZq3D80b/Xmbeyb8a3O7O?=
 =?iso-8859-1?Q?QJYrMb+N8e/hRoorQgWuiQWLzCDTYz/Z/hXWebeG92AjFCa53sV88+ulFk?=
 =?iso-8859-1?Q?wg4bxJy0Yg=3D=3D?=
X-Exchange-RoutingPolicyChecked: YeVjx+dgPKFqiLWg0OrYeNqBWaZfwKg4HNld2DY9T81jpwf/AWRxaoALuh43USDTegGrXGyENZDgc9sS/eT5E8Q+w45nJJ9o4BIdeXG99nITeYaJc3h6TSpiNZOV0Uq6OJELMggUrKcAvPjKenKgp5wjfr7kY8Flyrpje2Qx5GNvAlSW2H5IevOFVa4zr3aeaiEicYQF9nFATZGmt9uEVUWUovJh+CSZkGsUW30LpIutMyjjRo8ScpK8ZrJ/t59yzIoHbYOk/fD2PjSOssXtuIDTeSDRd6t8LvelZ6Hwp1VPa6fKnWDm9clbLC4sT0rEyMltD0/92o58rxk8zn/n6w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4a44af-d6f5-4f0c-d645-08df1b1cb798
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 15:50:26.5576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcGhl4gS0QzmWu/JXHAb5PgZ0Oy2cyPnjddQIGTjZHX9DLDh3T6Dls85bc3OFA+cIhykioyd6XQ2pih/Ug+RHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7949
X-OriginatorOrg: intel.com

On Fri, Sep 25, 2026 at 07:37:20AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/24/26 5:06 PM, Luck, Tony wrote:
> > On Thu, Sep 24, 2026 at 01:41:48PM -0700, Reinette Chatre wrote:
> >> On 9/16/26 4:13 PM, Tony Luck wrote:
> 
> >>> @@ -1001,27 +1001,29 @@ static __init bool get_rdt_mon_resources(void)
> >>>  
> >>>  	/* Any of the L3 monitoring features? */
> >>>  	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
> >>> -		return false;
> >>> +		goto skip_l3_feature_checks;
> >>
> >> This goto looks unnecessary. Why not just "return true"? Even so, this 
> >> also changes behavior from the previous version in a way that is not clear
> >> to me. I was expecting this to consider the number of RMIDs supported by the system,
> >> now that this function added:
> >>
> >> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> >>
> >> Should this be:
> >>
> >> 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
> >> 		return pqr_assoc_num_rmid > 1;
> >>
> >> Although ... looking at this closer it does look strange for pqr_assoc_num_rmid
> >> to be 1, thus reflecting that the system supports one RMID, when zero may be more
> >> accurate?
> > 
> > If X86_FEATURE_CQM_LLC is set, then monitoring is supported and the system
> > must support at least one RMID. I don't see a need to insist on more than one
> > RMID as a precondition for using resctrl. It wouldn't be super interesting
> 
> My suggestion was not to use "more than one RMID as a precondition". By copying the
> relevant code not shown in the hunk
> 
> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> 
> I aimed to highlight that if the system returns zero then pqr_assoc_num_rmid
> will contain 1. The "pqr_assoc_num_rmid > 1" is thus not a check for "more
> than one RMID" but instead a check that the system did not return zero.

Architecturally the cpuid_ebx(0xf) can legally return 0 meaning that the
system supports one RMID. Here's the description from SDM Volume 1 Table
21-38 "Leaf 0FH.00H Intel® Resource Director Technology (Intel® RDT) Monitoring":

	Register	Field Name	Description
	EBX[31:0]	MAX_RMID	Maximum range (zero-based) of RMID within
					this physical processor of all types.

This code path is only executed if the test for X86_FEATURE_CQM
succeeded. That should guarantee that leaf 0xF exists[1]. There's
no way for leaf 0xF to indicate zero RMIDs because the MAX_RMID
field gives a zero-based result.

So a test for "pqr_assoc_num_rmid > 1" really is checking that two or
more RMIDs are supported.

If you want resctrl to refuse to support a crazy system with only one
RMID, then the check should as soon as pqr_assoc_num_rmid is set:

	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;

	/* Systems with only one RMID can't usefully support resctrl */
	if (pqr_assoc_num_rmid == 1)
		return false;

> 
> > as all activity would be captured by that single RMID.  But it would be
> > keeping counts of events.
> > 
> > So you first instinct above to "just return true" seems reasonable.
> > 
> Reinette

-Tony

[1] Technically should check "cpuid_eax(0) >= 0xF" but it feels like only
a buggy h/w implementation would set X86_FEATURE_CQM on a platform that
didn't have leaf 0xF.
