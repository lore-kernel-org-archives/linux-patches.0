Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5014D38DF2
	for <patches@lists.linux.dev>; Mon, 20 Nov 2023 22:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dJQXJtUU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700518625; x=1732054625;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zJJOACX2N6ebGpdpSoiwhp4yjdlQlKIFnBsVzh1pAbY=;
  b=dJQXJtUUxXXEGEktsn/Azs1PBaJXXZMYSNQkpXWvBqm4UZkdqPwYgItW
   5YC+xiSgBCyXLdFjljoWrXDJZs5Wm49oz5CS4bu0eY7GLfMzGtcpKQjOS
   v9XFHfPxygpbQyDQkIjOpSE4Wg1sVFZiEO5AixlD9JOx//x7TXgJ/6pbG
   Au+Z/gNDovFwOiwJzLVIVlqXeLdmynZD5v1Tfu4Wg4H8Vp4vuH1ITXPou
   9bBJRxLRPAQV1xd3BoPkMpuQvYgB3WkDiO4myLe1RDGX0QG13lowLl1ph
   Ub2ncnD0psc1lrpVA1ow1c980AhzN4svr8d+db9ldV1aGdczN/Sr5l4Gp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="391498350"
X-IronPort-AV: E=Sophos;i="6.04,214,1695711600"; 
   d="scan'208";a="391498350"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 14:17:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832419411"
X-IronPort-AV: E=Sophos;i="6.04,214,1695711600"; 
   d="scan'208";a="832419411"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Nov 2023 14:17:03 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 14:17:02 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 14:17:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 20 Nov 2023 14:17:02 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 20 Nov 2023 14:17:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfDrVwuNLq7ek/dMRgzlj5zncMQ80C33xlzDTwSzjPMJAVjWoxKG3k/d7F+OThVwq9Ta+/wRoABbIHGzdtHOQSxrF5Hiahv9AqTT5zYW+iqj7pR+HdPjHu+3feZIDiv4mnbQHuPl3hcLMq0ZNsgS/yytu/+wSdepHozBqEIMh5DjNNsoTQ5fabWbFAl7cwBYnyD82sSq1TDgERPC5ClI2FNT8AWftd++Pmu7GDRLO+FZcEPA9BwWEEyN0yCAlPiKHdgMsl40KIz/u4As5NqcaimnRjSWSxfBGpm1Aio0tVW5upr28RT26xq9+nGT15vURhd9rt97IiN/AExnRBMZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFli8ipKUHxeyriUCVzxmQGQB2hJkL6Rv7b6qqAe8oU=;
 b=CnWZsXsLs9lGp3NsZ1oPt83cpe6o8LLmhQZqT4/V7ymIi2YIwzxfeQwP+TiIURzSipGaYxbiBq4sMVbtPrRBoEHHpnKEX7/iX/Upkl8OWo98weu7KUyA9Gcz4reI8j5qt1LOmO4paIrvGo0Dc+RyZahZaaUby3jjmcKwIOuWU2i8JGSTpk8vdFlMlGCJTCsVlsu0dNeZMKOr1loFo+tKG0z5kGyHTndRJo8Vt9GmOHdiWHE7VrCfflyL6GmPKzWr2uOpJHik1swFjXtTODmWwxJlbHQscs38XevERhCfev+iOiaLxIUMbg/N4ZvCCFHAnoFNM7GJ4XF/hBMGGKHdoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8222.namprd11.prod.outlook.com (2603:10b6:208:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.27; Mon, 20 Nov
 2023 22:16:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5%5]) with mapi id 15.20.7002.019; Mon, 20 Nov 2023
 22:16:59 +0000
Message-ID: <f8e46bd8-fc27-4bde-bdbe-daac8ed7f27a@intel.com>
Date: Mon, 20 Nov 2023 14:16:56 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/8] x86/resctrl: Prepare for new domain scope
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Babu Moger
	<babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20231031211708.37390-1-tony.luck@intel.com>
 <20231109230915.73600-1-tony.luck@intel.com>
 <20231109230915.73600-2-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20231109230915.73600-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:907:1::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a0cb683-ec1f-4172-f04d-08dbea1669d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vlETkOcXBdHasLflnx5DDjdppRES+ehCUFCNm1hFziX6PVZWmvCpTqpeiO37tTKcUQK9YHfSiRgPlZ+5TiSwUWmAKv6IzneTLzynCvsoPnyZYzH0qPAF8hLsMtK2V872YJmJuRgwzNMGNXYMTndanPLOXrHdXiilGwCLX+yQxOAjCObbb9aFDAwiI5nnX0Hv6YBUnA66AV/rVrdMDEJpewvwjLNZuGwAM6fJ7VSs+SJlUT24ZKxIqrJ5q46Eiidr4FKW1VOCKJVP2n7vOex834wP5LISYB4C3Vu7KeMgt1iLcqk+EbN1toev2d54oWortBlJ3Nj5iL1XvrMrmtye19aBknTVr/Yuc/GGs1lxMGpV9JQ9FcVsZyl7C2lU4ALcXVm5UPc+FOhTGo3hBvVqQRMOxJfkRDZ/e8DKp6qX90EiBIVL++8bebph1ZDwgDxZs4dWac2dIpjdUx8xUPY5i2TqtzS7iQIeTC4+8i9Lo5uonPRsKo+pjTZlk6bFo4ps+WSOMO6EbS8vcBdogZVYdzM2ig7fJMRpGKU9VzO6jzJvPLVDjkxUm6kq5X3IGc3bq4EuNm427cNqAOs2mIvCSfZcVQj8is/u8zt6wOTGJkFb7NEhul3nM28sSgSvyFM6XuNiW3+6NzvVj0L00M1bC4G1IP9cO0Fq8v7WhoIWT9nlpdHHxkXlnQoy3X0Y8MB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(230173577357003)(230922051799003)(230273577357003)(186009)(451199024)(1800799012)(64100799003)(2906002)(5660300002)(7416002)(44832011)(41300700001)(4326008)(8936002)(8676002)(31686004)(316002)(54906003)(66476007)(66556008)(110136005)(66899024)(86362001)(26005)(6486002)(478600001)(6512007)(6666004)(36756003)(53546011)(6506007)(2616005)(66946007)(83380400001)(38100700002)(31696002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlF0cDlnNzBuQ0RaR1gyU2hhaWlPeENFQ2tUY1lycWpkaXZaaHlkK1NWWGZl?=
 =?utf-8?B?K0ZsNkEwRE5wVkt3UDZqbnhvejFvYU44Y0FEN1dqeHlEVGt5ZG9IUEVUcXNV?=
 =?utf-8?B?OS9UVXl4Q0dGY2FmRGJUeExyQ09oSVFRMlpFVlorN0pmMTBuQkZhYUJ6cmhs?=
 =?utf-8?B?MnM2TG5hQmFBam03bGlSejdWWGs5dk9lWU8zcFkxd3lVZU5ncXVPR1dFNWpO?=
 =?utf-8?B?YnpJZ2dWYTJoT2dvTjZjcVBDVk0xU2JYZDZXcGtPdGc4QllSY04zRVJTQmZV?=
 =?utf-8?B?aGNjaHYyZU5PWEFwblRmQmdCMWFYTDFQTG03UktXK3RKM3lHOUxDVzZkTzBZ?=
 =?utf-8?B?VGRhVUlDRzdqVmU5UTAvMjgyVGsvTDI3LytlZmZERW5Cb2tuUFJpUE1sK0Vs?=
 =?utf-8?B?K241ZXFETnRjelNCZGxOZkZWZzBSK3pNTlovRk1QcFpnMXlqQ3Z4dlZjakVO?=
 =?utf-8?B?anRja1JNTmloUjI4NU5YUjExWGx5T2xEdXlobmJnWTNGUEZuWkxIZGpQZ0Q4?=
 =?utf-8?B?OUFIYURyeGUvSk1LdGlVSVd3LzJwLytWY2hsdS9kcnRIOUJLbjBBUnFUVUhF?=
 =?utf-8?B?U2dPendIRW9ZTUdLNzVHWGxuN2d4eng3WkphekRlK1dZOU9tVlMxb1hjeUt0?=
 =?utf-8?B?QmM1ZWd5MzF6NnNpd21KdktyWVFON3JrTzZCM3JvR0wvVzFlOW1LVUFlVmZO?=
 =?utf-8?B?UzNSOEtidDJ4NSt2RXJVMmltN2lhUTZWbzRDRnVtN0VOTGdjT0hjalRUY3FE?=
 =?utf-8?B?VHhYcTlzb1E1cUNOLzc3YmV4OC9kU2N2L3VXai9HL0MxYjVuMW1qNE9LRzdt?=
 =?utf-8?B?bHVMMFFpZmRyU2pwV2F2ZHY1OXVnWkJjZnA3c051cUI5UWxUMkx0YXB6cUVt?=
 =?utf-8?B?WGVlK3dnbzNQbytHNFd4NXE5eDZXbGs2UW9RU3lNbG8vZjlBL0tmT29tUXNP?=
 =?utf-8?B?S29SakNocC9SaThSTWx0Ykg1Z2dCaVlPVDNneXd5QVZoTTJyRUwwRGZHZmFR?=
 =?utf-8?B?RmpIZ1F4Tjg0N0xjMXQ4cEpxaklkRWl1TDRxdmdmZTFjeHNJeWplNG93akNS?=
 =?utf-8?B?czVkbXJ0UlpkYSt2K3JEWGY5VGZZS084T1pmTzU1b3VNeWp5RnN4NWJ0WUxr?=
 =?utf-8?B?YUE0N251N3BjaFpEelVQUGZ1KytFbmR3Y29FOVZYMlJQdnZOcUxuYU56NUc2?=
 =?utf-8?B?enIyVVBINkdYV054ZGhwM1dqUkpmN25GY0JXZmIyaUlpWUFUWDlUaGcwdWJU?=
 =?utf-8?B?NW93dE9PdUtwWUxwd1JYeFNBeDJGRXVkbjhHRy9RejV3MkFaOUpQMVpLcGVx?=
 =?utf-8?B?SWR0K0RuUHlpTWtRcm9oNEp4R1hXMXlmdUN5NWFKTCtxQ3hUQ0FSeU5WdnQ0?=
 =?utf-8?B?bE10MUlCM2JaM3did3BQUy9obTloUUMzOCtycGxnR3gyMXhJU0ViK1g4R1F2?=
 =?utf-8?B?YXhaaGJRZVYvVCtFTE5lWG41WHhIS3FLSXZuN2w3eWt3QldFL2xKczhVVmcz?=
 =?utf-8?B?eUxUeXNBdWtjWTk0Y1V4bXo0d0pCUXBBZ2kzT1k4LzBMZzlZaFFTVkJrK29n?=
 =?utf-8?B?RGJlOWJ3TTZ3VnQvcFFnWGY0RE9PT2I5SDcxMDZ4RFRCdE9oSkpnVHBEdjdp?=
 =?utf-8?B?NzBYTHNFT3RRZkVmOTgwR1JTSU1mbEM1Mk13Y21panVBZlpSQmdUVFQybDBR?=
 =?utf-8?B?Lys5RTRGUkx5c3dSRUVEWU5tYU52WlFKWDd1MkVTYjBNaEozSXNRc3NhWkFu?=
 =?utf-8?B?bGNBWDNucHhQdTZjcWFjUW5tdGxCZy9OeDdWNFJrQ0xWUlJIZWpjV1NGbzZC?=
 =?utf-8?B?bEI2N00yTWZ4RGNackI4OEZtOTc2bWVwcjNPaWNxZnBsc1p2cDVzblFnUDZj?=
 =?utf-8?B?R3VrTFRPUEtzUlpTQWNWajhIU2xpYXlJNEo1Z3VSQ0dXU005SFNoZDhBRTJG?=
 =?utf-8?B?NGZJT01BNTJobjJSNzdoRjFWeW5ZY1d1T1o5VHFBK2REVHl5MUNxOUlyMTBC?=
 =?utf-8?B?TGxRaEtrWnlrSnJxYWtuMGlqVG4zWnMzZEN4MkRXWnBQV0pkZW1Ddk51dytv?=
 =?utf-8?B?NFFxYXdiUXJhUityQ0lYZFlOeG9jclJ2Vzg3LytKS3BEbHF2aFVGOHBFSG5v?=
 =?utf-8?B?bkF0UHVNWTFmaXI2ZStaTUdaTnFmd1JpWk02dUQ1S00xcWV0eXBVTGorejMw?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a0cb683-ec1f-4172-f04d-08dbea1669d5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2023 22:16:59.0388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3we6aeDaHlZvi85L/dlmJLTdeMqvuX+bG+VZM5sc075DNpaXXUez6DzPqwdQxnZD+xi0kltccz14dfGTFj50YVgeIzmu2aVGVwUX/DSGR3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8222
X-OriginatorOrg: intel.com

Hi Tony,

On 11/9/2023 3:09 PM, Tony Luck wrote:
> @@ -556,13 +567,16 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
>  
>  static void domain_remove_cpu(int cpu, struct rdt_resource *r)
>  {
> -	int id = get_cpu_cacheinfo_id(cpu, r->cache_level);
> +	int id = get_domain_id_from_scope(cpu, r->scope);
>  	struct rdt_hw_domain *hw_dom;
>  	struct rdt_domain *d;
>  
> +	if (id < 0)
> +		return;
> +

Apologies for this late comment to this code that has been like this for
a few versions. Something must have gone really wrong if id < 0 so I do
not think a silent failure is ideal. Could the same warning as above be
included here? That is:

	pr_warn_once("Can't find domain id for CPU:%d scope:%d for resource %s\n",
		     cpu, r->scope, r->name);


If you agree, please do ensure that this change propagates to
domain_remove_cpu_ctrl() and domain_remove_cpu_mon() in patches that
follow, in which case the text is expected to adjust to "Can't find control
domain id" and "Can't find monitor domain id" respectively. (btw ... is
the switching between "Can't" and "Couldn't" intentional?)

With this change please feel free to include:
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
