Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CB1D51E
	for <patches@lists.linux.dev>; Mon, 30 Oct 2023 21:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CxAhAPpL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698700719; x=1730236719;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lY4jmUjEk7T/UuvZJKnhuq6mtYMiLEdNLwaCINd2TFs=;
  b=CxAhAPpLA4vkqEHF9Q0+HuIDD/W4kqk0rYnfZT+pEh3suase8tVNrRJ7
   kmuvyaqTNGp69JPUZWb9tJp3uHf/AoxRLfj+Wp3CDWoes+ojFvt0Id+Cc
   0d69Rnyzvnx8FFKmtVVKhDcQsgdV6IeM70f3MRq9NbcgtpfY5GgIQdL7V
   zw73pRJcrLiqC0aw7baO+vm0v8F8qt1A/Yr2yUmkoQkQYEeJMOgRVobzS
   b6RBjPEpA+VkDOngYWVD9F0s0cBj/SkatWErK7Vr+bQKl9AdrC7eZcSBv
   7S8zRLuj5WWJk9FbN2ZcJwhmWMEEoArAwYKRbMpUmQ2lG3cbNMuihDLP+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="368373125"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="368373125"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 14:18:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="884005638"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="884005638"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 14:18:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 14:18:37 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 14:18:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 14:18:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 14:18:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQzBUxPfvkgKSPJXZ0fZXeI/H0sNZKi0qQar18XksHeq/2SE8SJs+X3lX00U2G+0MuZIwAsLdXtle2/1UPZF6REukcQiwAGm3rMItGbNmpxPKrEyu83j/eL76aeRSuAxCZiLVSP3UegkpdbxD38bw6McXXNioJVJ0oAKuJPy/CWFdNbqXx75qQ8fSTtDWEV6QsXVwO8hcBDdKBzS344hOgsZ4sm33tdTF/LBpEqV2c3U3ixFhp5bd1wFExcPJla4DyDIFbo4O0xYq0At7UMbI/F3VS4AiIgFeofecibVeUqKt61Sz9VzYTGQhEnjSezwzlfXOhePU5m2d7Kz3gtUig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzE5+sTnn3HRIpBncnvU15oHXU7jDW+ITsG73cchzdo=;
 b=l8edvkEZwXfSVCGyKlCDSGQ8DZzLDpApywISN3ZMYskAa6JMuPcpIzy5BQEtsnihhHxhnMA+0DYsjfUMlre9gI8dpJdjYQYevWyQVX3XFtuxD605vsC75kAn73r2uBXzKeogsLQ82HmgKBNIo53AIgH9m+yt0Ie71mD61x1JkPTOKdH9RKRlBLAvnB8LCi7Obpvs/Bzg9o+3KiRnW5zsxu9/dHdNYDGIeiytGa42jxWkfgSCoTlXiILlzBBbUHMtri0zPEZrp+D1vtMUpLN28SWDkU/GN9koc19/ypHrTvaS3nglxN4tW8Oswfcv2/RYRyI7Y+q8WzgdECcn0p4woQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB7070.namprd11.prod.outlook.com (2603:10b6:510:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Mon, 30 Oct
 2023 21:18:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5%5]) with mapi id 15.20.6933.028; Mon, 30 Oct 2023
 21:18:34 +0000
Message-ID: <5f7fa4e8-4bce-4bf4-a557-6993ae5f2e4c@intel.com>
Date: Mon, 30 Oct 2023 14:18:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/8] x86/resctrl: Prepare for new domain scope
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Babu Moger
	<babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20231003213043.13565-1-tony.luck@intel.com>
 <20231020213100.123598-1-tony.luck@intel.com>
 <20231020213100.123598-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20231020213100.123598-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0367.namprd04.prod.outlook.com
 (2603:10b6:303:81::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 3db11dd6-8382-4a33-9c22-08dbd98dc646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fE14zqDZXbZFzWQmdxbxiEDyS/V1tudAGrYwvJLXB9zAo8TcvCtb6YR/oznDfEfLLq+tAuinXJw4ArWbj5EkJN9stklCzb4n/hgqrYJDvkZYFMUbWKL05uofxTT9bSqy1wjvr5GN4jPpcQ8jpbCTr3cvbxTT6ttDjxYJYrt+jJ4Q50PoPzwQMvhDXwUrYpE+Gtm7toz1vU7Uk8cPPgoRjrxLTG78i7MLXJpo+ZwtL2j00RA31Lfnp5Ad2p59l1+FLYxnfhwsvB0PIUjYHlKSxy+V8hhlkPY9mWw5o48E3AVTyP/X3BSQEf5IsRjUeabKnO9WTCl/1IvQiW/T/94Cf+ti+SdTbe/scxQzkZwbc+LnbPGXPUolymm05cMhs7ApUMs4lxaCLvY+tjee/ZK5z7FszsnGPDok2QRhE74/z1zVr61fd2A0vItdoKIPOOad1beMKgDUbl8R7Ax2brQH75kBcvLyt2Qmp+a3m+VlYteinHTvt2KbpnWGr+UeL0YtCPCKo+zDAnRqFqH/p+X41YBiz7Ix5fxKEUV6ABmiBK04Fa8IZutzqFVZTNZeteGWJVbiwiP85X0gkdNZAO3IfZkNy1bsEP5iUYfQPCErBsHvaTzERzHVt8qMroGPGvc7z50ZXzgayz85upff0ebZ7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(136003)(366004)(346002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(31686004)(2616005)(26005)(6512007)(53546011)(82960400001)(31696002)(36756003)(86362001)(38100700002)(7416002)(2906002)(83380400001)(5660300002)(478600001)(6506007)(6666004)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(316002)(54906003)(44832011)(6486002)(41300700001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUVCekR5ckFXRmdML1B0cjZuZ3dTYUNYNzZCUngyb0ZDeTQ5SzhKK3I0dkxM?=
 =?utf-8?B?QzdSclJEb1pWOGZiZlovVHJTV3Y4SVg0aEhwaXI5ajdBNUtiaWp4VTV5WXpN?=
 =?utf-8?B?N2pMUU5nK3BXM1NkWlVPMTJyR0grSlloaktyNmIreEJZUzVwSEVLZ0cwdVFU?=
 =?utf-8?B?ZlplUUtiT2hCVUZ6V1NxcmhkaDl3QWd2c3Nsdk1uWndjT0I4MUQ0dW9yMWhE?=
 =?utf-8?B?azBVNThiQm5hQXh1aWlZeUZSUW50NzhQbFpyaE5TOGNhVTFUYlFla0xrbUtB?=
 =?utf-8?B?NVdNNEJLWUp3TktPUjZhelp2eXJQcFNJNitHTjJLSU5ualh4cDVqdlpwVXlZ?=
 =?utf-8?B?bjl0bGFoWk1VMERxRjF3aDF3WjBZSXN6OTF2OFBCVzQySUcyOUlBUUFST2xI?=
 =?utf-8?B?MXB2NkF1cVk4SGJDT05teWd1eFNkdm1qRU5zcE0xeE81U0RoUEVQRHFlaW9t?=
 =?utf-8?B?MkMrSXBjblc0a2dlVGNNZDdUNVd0MDJtUytQR3IwWWlzY1FXTVo4RzVWRmE3?=
 =?utf-8?B?QlhVS0VSQmNiVFhQZm81MVVvbjFxUERTM21peTBZSC95SGZ5OUhOVmVMNzhx?=
 =?utf-8?B?cEhybnd5OWVDMzAwMzFTVnZqZzdDeWtjYlpyUzkwUG1ka2FPRmFWZTZUTEpO?=
 =?utf-8?B?UDY1MGJEQy9DblZFVEJreExJa2Z2Q2xhMzJZVGR0VEhhWmNzSWhjN1JNYnRx?=
 =?utf-8?B?VkV0elo4cEpKWFdBSklVRjBIbi9ZaEdNdy9qYkNVYXR6QklDK2Fqckk1S0dF?=
 =?utf-8?B?N0szMHFnS0xlSFA1eW5EcEovbGpudjlXQ0Z3Uml3YzZibys5M0JCb21xTmdX?=
 =?utf-8?B?YUJRMFh6alh6K1Y0QmV2YmZEQmE2ZWs1KzdxK0labTdKTlQyUDIxclRoUDND?=
 =?utf-8?B?NWx2a0lpYmVpelM0YkgwQjVVZy9yK1dlQndKYjkyYUE3ejVkWVJuOVJWMHlz?=
 =?utf-8?B?RkQvT1AvWnc2VXdIT0NXNGNzem5RZHJ3ZTRrUDBoSitFMkMxbHdBYnJlQWo4?=
 =?utf-8?B?ZjYzTjZRQll1dWJSRzkrNU1QZG5kcTFudHh4Z0YyZDlrYVJlL013TmovWkhj?=
 =?utf-8?B?V0ZTczQwZ0tpTHh2YTA3R2hEckR6dFkzVTVnK2xoNE04ZmRlY1ZwcUg0Mkdm?=
 =?utf-8?B?NmNZNENyUTRISjB6SnRYMmxUWE4vU1VBek4ySGtoVkNVZ2FtcDFvTEh3a3JC?=
 =?utf-8?B?WS9GN0VkNTNES211Z1JHV1dKWVNxS1ptQUJKZGlKOTN3cVg1MlVVaEpIMU5r?=
 =?utf-8?B?a1ZvREJEcmJmMDcyVGFmakVhWXEvRGVRU05aSVBla1EvMUdGTlBRK1FXY3Rm?=
 =?utf-8?B?M2FKQkw1amN0MTB1dnlwaElieUxGZ2lDWDFKUUdGRkppQXN3YzhTNlJUZFJy?=
 =?utf-8?B?SlpaZVlhZlVRNUdDeGp1VFpIU0ViQ3hWZUtVR2pJWmkrVkVEZGtLai9zaHgw?=
 =?utf-8?B?cHRhWi9rdFF4WU9IZ3F6UmlMbjNReTVMNm1kNGtnb21maUZpVUtja0piTHpM?=
 =?utf-8?B?dE9Mc1EwdkZEd3NyVndXWHZNZEZLQWg2dURUTGEzdXpDcVhlTEVPa2tpYWtJ?=
 =?utf-8?B?VzBCTGJsV2ZHS3NZZWY1MjM0Sk9aQzJjZTNmdGF3ekRCcDBKVW1vRDZUMk5n?=
 =?utf-8?B?TXY5S3hDZDFDbzJ6OG1nVHhvOHJYYlNJbGwvOTdrRmNLU0dacUVpTDZUOEt0?=
 =?utf-8?B?bnpUSEtYOEs0dWVwN2hGMXpjTHBya3Zna1lXSUY0RFNhV200Z0VaY2gzSldP?=
 =?utf-8?B?OTgyS3dqa3lRV0NoR3RmZjI5NGJ1dGFjRCtBM1VMSEc0b0FrSGU3VTRIczlh?=
 =?utf-8?B?SkJWRm5yQVBCT2NjV2tsOU9JQXoxWERITFg1Wk4zMTRFMjRoT01MaXFFR3M5?=
 =?utf-8?B?NlhpdS8yeDZvWlVlTVhjcVlQTzNqa2JZVUZrWDRmeDduOUQveGR0WitGeWtS?=
 =?utf-8?B?OVhub29tTWh1TnNEUWMrY2ZldC80eWZ5MUxHYUtMQnhLb0JBNTB6eFhkdlM4?=
 =?utf-8?B?Vm1sSjkvSmZDMUVpVTFSTkc2Zy9XV0ZpTnQxTm13TmZ2SGRtdkhMWXNrNDdo?=
 =?utf-8?B?Qzd6WlVNK2srblRsdWQrOE9nZXNWWEZSUlRkMXhtVFo1UzBxRVdtMjl1RnFR?=
 =?utf-8?B?TDNFOVo3RElhUjNybGlsQktUMWNZZlJVMmRMam5wUVROaUtSWW5qWms2WFlI?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db11dd6-8382-4a33-9c22-08dbd98dc646
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 21:18:34.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UeOntD3WZ1ZehT1WxWXwdKkTxgL3sXSJ6RqQc/Kx+OMmxpREsvdwXY5W+SgxlpDXDAFn1PPlxIJCrR6LlyK/+wRFNJcswQ/jAf9Q8YDZQMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7070
X-OriginatorOrg: intel.com

Hi Tony,

On 10/20/2023 2:30 PM, Tony Luck wrote:

...

> @@ -506,12 +519,17 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_domain *hw_dom)
>   */
>  static void domain_add_cpu(int cpu, struct rdt_resource *r)
>  {
> -	int id = get_cpu_cacheinfo_id(cpu, r->cache_level);
> +	int id = get_domain_id_from_scope(cpu, r->scope);
>  	struct list_head *add_pos = NULL;
>  	struct rdt_hw_domain *hw_dom;
>  	struct rdt_domain *d;
>  	int err;
>  
> +	if (id < 0) {
> +		pr_warn_once("Can't find domain id for CPU:%d scope:%d for resource %s\n",
> +			     cpu, r->scope, r->name);
> +		return;
> +	}
>  	d = rdt_find_domain(r, id, &add_pos);
>  	if (IS_ERR(d)) {
>  		pr_warn("Couldn't find cache id for CPU %d\n", cpu);

From what I can tell the original implementation relied on implementation of
rdt_find_domain() to do error checking of the id value, printing the above pr_warn()
if id was found to be invalid. In your change the error checking on id is moved
earlier yet this original behavior is maintained. How could rdt_find_domain()
possibly fail for this reason at this point?

> diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> index 8f559eeae08e..8c5f932bc00b 100644
> --- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> +++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> @@ -292,10 +292,14 @@ static void pseudo_lock_region_clear(struct pseudo_lock_region *plr)
>   */
>  static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
>  {
> +	int scope = plr->s->res->scope;

enum resctrl_scope ? 

>  	struct cpu_cacheinfo *ci;
>  	int ret;
>  	int i;




Reinette

