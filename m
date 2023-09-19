Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5265038BD0
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 08:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695110757; x=1726646757;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fooGanHQFdDQGfbrg0xgseprS5Fy2iPs8FWb1fp71Yw=;
  b=hpdU66JX2BcxOr4yMzdU9vIbuv2OmBuBZ/FEvSa/DJqFn6m2GmLVREHR
   uAsG+uKgDEd6lpjAMVs993H0SfAnaMTyLGooDnHz8p1HnSwG2nNwUk7U6
   XZrTFCdIwqugmFpA8KvFvOL3lQylcO5wSGrhZy72jjRP9mB7gxHvcCm87
   Yg+e8iAnueJq62vLjcK+Hwy1x2wxQYoJ9QpbChlb42ldS2dIenf5t9e80
   yArjzfa9mUYOP+ZlQVJFq+7TFEUlsmQrdTjTR8Ha4oAUK1DBfzmgp+5Ro
   Xif945cBfRd7r8PPzhParPlwCKttm3tkxs8AxRh4H/QxXJH6u5500mQEe
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="377190515"
X-IronPort-AV: E=Sophos;i="6.02,158,1688454000"; 
   d="scan'208";a="377190515"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 01:05:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="749378717"
X-IronPort-AV: E=Sophos;i="6.02,158,1688454000"; 
   d="scan'208";a="749378717"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Sep 2023 01:05:56 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 19 Sep 2023 01:05:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 19 Sep 2023 01:05:55 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 19 Sep 2023 01:05:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qa3XBypxI38OG+y7DDVhwcFdrj2kQ4exJuKzdlikZRJ+2JYwQPRy+JLo/ag4nDjI973/YHfRQv8VI9pnc8lLR3AUL/D+KeGindXr64kkQLw+lipEWIomxJOITRCZzt/eJ5PFqWIuBgX1PLAgrH6k0Oa5UqFwKDMfw8D7nVFPlZ8rWWzmGKwBEoQaCrCvOqRqHsWIbPzO9IFtMgRpsaI95bkBz8YVI6Zm3rzpw/hfqQcxyzjVHruhQueoR/wooMZ11HLjOi49dbuZucI1f96zWR1I9WTy8POm5Ly2u+L2CtXEgmr42nuppSdXoKXaWakE2dCsKkbLtsRtcotMpOAqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDWAv87OZnOEgNABKGsc2oPZ89pNJzBtKC3zOs8JzOA=;
 b=fFIPecZivQT1RzrQ1uS2b+k13FMFBv+sKxqfHG7YpoRO2Fvtp30gNQ0Ubk2n5b8xT2zR/vTvrNAV9LC3S3iTap2YF4YovHzOpFgNTT34MbW6cPcMOBlf7GMHEHgemJBmW1XgA0mnF2SIO831q0gZdXEhc07Ke78/ZRbTY6Dodi5loif3RSyL7iCMluCRL5eapGDkk7oM4KAiD+rtcknZWIDnvbsaaqg2Kfy1uLpJNWyXJwmZPKKkd84NXn9b1qaCN06rQp4Ezqqk74J+9bVYNn4AgohAAIIk4Yhoo/UKQalMnrg2w40aa5xrGd5jjfhsvEAYVWXjWnXixcaq+1BL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6304.namprd11.prod.outlook.com (2603:10b6:208:3c0::7)
 by PH7PR11MB6401.namprd11.prod.outlook.com (2603:10b6:510:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Tue, 19 Sep
 2023 08:05:53 +0000
Received: from MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::7edc:de45:7f2d:9ade]) by MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::7edc:de45:7f2d:9ade%4]) with mapi id 15.20.6792.026; Tue, 19 Sep 2023
 08:05:52 +0000
Date: Tue, 19 Sep 2023 15:56:24 +0800
From: Feng Tang <feng.tang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jay Patel <jaypatel@linux.ibm.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mm/slub: simplify the last resort slab order
 calculation
Message-ID: <ZQlUKJXKYYY5fxL4@feng-clx>
References: <20230908145302.30320-6-vbabka@suse.cz>
 <20230908145302.30320-7-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230908145302.30320-7-vbabka@suse.cz>
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To MN0PR11MB6304.namprd11.prod.outlook.com
 (2603:10b6:208:3c0::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6304:EE_|PH7PR11MB6401:EE_
X-MS-Office365-Filtering-Correlation-Id: 273ec09c-af3c-45c2-743a-08dbb8e73e3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhPyWJvyBNyd1YRkOOok9W+9vWonnC6Ph8YxY4onn2JLV06ViBzRktJTdNkbyqapMlc6WxG4jiimlrCGHgRwXAkThUGbcd3l7zcwtmALhT4STqHxb2D8nbzD40o1pCl5eskIeTXFIT7uscebzwbyKJyG/wc1bthy9V0KVxRIuuoATqIRZnqDbwhwJpCPbsSk/CKsNNxDVwcozBMSo8n1281y6IxSDOz92TYFuGxe9vqj04YVq1MvikZx9wihNSZ6a1yLy4+7jN+x1SlpHv/hldnN59iNV2GoOgY/3uVEar7sLIIUvnEFvipfNG8VC+SAKmvrhJS3iuqe1P7tzPIM28JrC++4SFrib4In/3BQL9UX5NR2jf+QfvlLlm3rejFYWfxA4fn6vnMl16NB/OEU0JcNF4m2iV4SsaeM5ZMFcDj0WzC6AjoVC0YFLouIxzat1BzbX1M6jnbB1GHYViSwICERSRduWp2wz67LvHrOGUd3WkcoTjWPwM/eS+MbLTO5vgawiAdhXHjWqbfwkGhvLez67Ju/sgHhUYgbkUf6nVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6304.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(136003)(396003)(376002)(39860400002)(346002)(186009)(1800799009)(451199024)(8936002)(5660300002)(966005)(316002)(478600001)(7416002)(82960400001)(6666004)(4326008)(44832011)(8676002)(38100700002)(2906002)(33716001)(9686003)(6512007)(6486002)(66556008)(66476007)(66946007)(6506007)(54906003)(6916009)(83380400001)(86362001)(41300700001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HXbEkI/AkjB9NQwRl8j9ur93tZDeAWr1qTUklAZ053bZk0c+BnTsK9jGaSDa?=
 =?us-ascii?Q?4o++OOvp3zyeYrVoiEAn8m76bv8cyh4TcePOYiCs+EVYRCNnvmAkXoEpPugg?=
 =?us-ascii?Q?iUvd2bG7X7sbokWKmHdq6PiSrCRSrhC3l3KECg1lhsFgle1Z1tvv6a7tMWbg?=
 =?us-ascii?Q?egNnjXYYP+dgIXRpTujOzMvFznY5OiCWcWN11zwUZRYjbIEE2n3oHUxqgWus?=
 =?us-ascii?Q?l6x7q2Q7h56FnWHxm6176s6RzWCCEhgYFQAu0YEOs3iGeJPqz43vkGGUncnp?=
 =?us-ascii?Q?nMGNwpaRKTiuib8gFQxy8dgy/CC9JmR9T/o5NeBezVk9jRfo2yz4ByDBM6Zt?=
 =?us-ascii?Q?IuiRp5LbiN7HCzdJbcgazBZ5PDIegfbWlHJx5l4mBrczy5r2cRexoFxRl65r?=
 =?us-ascii?Q?35H7hCQ3tu0VTe26EFsnL2LVZs5qp+F2pNXWamZxbWgyBCnuCt3hAN8sb/9S?=
 =?us-ascii?Q?fG0/6UJk+N3XD7LPux9G2qXPOdmKFYEpzFAhKiu4pYCtr81NZUZC8WS7Mr3y?=
 =?us-ascii?Q?v3nTM1A1Pesu6nezQ4TcqhxOpA3Y//Cw9tLjh+sttnjCO7nfmNrMgo77u+Dc?=
 =?us-ascii?Q?yMaJ2oprQxlGwfhGRGH3PU1umgDpSap6in5JGfCuOFncUHZaDggjdnv8c1zV?=
 =?us-ascii?Q?0Y5IV/QZgifAYBco8mF9xnGO3RPr17BfL0FWt3uOq8D5ll4aiV6LoQa09L7z?=
 =?us-ascii?Q?M4YHZPpr2z87wB2IVvLZwNwujIE3pbE2bOhYvorAt3NjDBjTlluUBNYqG/oW?=
 =?us-ascii?Q?GIKtxP32pXugi+Uju4jtCKMWfxLrZ7FcXtLeJRgt4ZnjQWxcHzIdGCF4qEaf?=
 =?us-ascii?Q?iIju1Bc88bkQkFDPZXTtkqAzgB6tDmbg2a/JA/4yVEwTzcB9Sme3uXkftRa8?=
 =?us-ascii?Q?42/qxob/Hm99P/iJJ79PyPal7WlZFjo89eLIoEQEKIpLrnOFILiQjdndUgh8?=
 =?us-ascii?Q?ZFRvW6ucXHu3T+eiguWQ1Q//rAhg9BoOFXL/hb3+6v3Wx1uFJm89gd3M4Ddj?=
 =?us-ascii?Q?rAYyeJDs9N3b5LQSEkhxhfNwsWhdv4MgnfrK/HqSp2qtphvY8VVSJotGouGB?=
 =?us-ascii?Q?jRsISNt7/dGIO7cd17vwXpsSF+vZJrOFyQlGrMZ83l4bvLx7bZDEy6tOv7OU?=
 =?us-ascii?Q?6QapCHmPSC6DtjyZxTfHMXyjoCm/kBJRCrWJTRa70gEUQC185XCgCAi6y3Yl?=
 =?us-ascii?Q?ECigmPaQL8mVvOmRbB49oSdHLCpmBsc5c0CWMN8R0wsaJFy4tsqAC2k0OG0O?=
 =?us-ascii?Q?jMmwiq9KTendhAOLamPF2Tf6yBOICj5dT4/Q6sG0uCSlu6GaTCIL2apqsjnC?=
 =?us-ascii?Q?7lBfXR/P1sfo/Mta6EtPdL/LuyTbuuu3pZxrzG/aQ+wzQ0fhVUCdb/xROvnX?=
 =?us-ascii?Q?Cas5468UQGoteqmFOCUR5F0QJSGF93tdNnPHn/RndtyuOTRDILFw8W8g/V6H?=
 =?us-ascii?Q?XvcyOptZSZkYYH0SX/F2nLJ70vXCgyqt1XvcoOyDj8md89IhpqUwLRbcU1pR?=
 =?us-ascii?Q?y9cHvd8aaEHT9QEmpuhyGn94h22jwOfr0K3mafKQ66uWcdgz0S5V3QcsQ0c8?=
 =?us-ascii?Q?Nu+URlS6qsclurmpbS1MkIk4c7B5Zqm5bk5nCB2g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 273ec09c-af3c-45c2-743a-08dbb8e73e3b
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6304.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2023 08:05:52.8019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b64QL5ja+7SdWlaeYXQVQGsdWrRIQL+31IrPyaiUnvq3BgcI5GpCd8jiBhAfet7uH1lgsDlJHxKCpzuJp/vUcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6401
X-OriginatorOrg: intel.com

Hi Vlastimil,

On Fri, Sep 08, 2023 at 10:53:04PM +0800, Vlastimil Babka wrote:
> If calculate_order() can't fit even a single large object within
> slub_max_order, it will try using the smallest necessary order that may
> exceed slub_max_order but not MAX_ORDER.
> 
> Currently this is done with a call to calc_slab_order() which is
> unecessary. We can simply use get_order(size). No functional change.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f7940048138c..c6e694cb17b9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4193,7 +4193,7 @@ static inline int calculate_order(unsigned int size)
>  	/*
>  	 * Doh this slab cannot be placed using slub_max_order.
>  	 */
> -	order = calc_slab_order(size, 1, MAX_ORDER, 1);
> +	order = get_order(size);


This patchset is a nice cleanup, and my previous test all looked fine. 
And one 'slub_min_order' setup reminded by Christopher [1] doesn't
work as not taking affect with this 1/4 patch.

The root cause seems to be, in current kernel, the 'slub_max_order'
is not ajusted  accordingly with 'slub_min_order', so there is case
that 'slub_min_order' is bigger than the default 'slub_max_order' (3).

And it could be fixed by the below patch 

diff --git a/mm/slub.c b/mm/slub.c
index 1c91f72c7239..dbe950783105 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4702,6 +4702,9 @@ static int __init setup_slub_min_order(char *str)
 {
 	get_option(&str, (int *)&slub_min_order);
 
+	if (slub_min_order > slub_max_order)
+		slub_max_order = slub_min_order;
+
 	return 1;
 }

Though the formal fix may also need to cover case like this kind of
crazy setting "slub_min_order=6 slub_max_order=5" 

[1]. https://lore.kernel.org/lkml/21a0ba8b-bf05-0799-7c78-2a35f8c8d52a@os.amperecomputing.com/

Thanks,
Feng

>  	if (order <= MAX_ORDER)
>  		return order;
>  	return -ENOSYS;
> -- 
> 2.42.0
> 
> 
