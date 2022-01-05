Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57171173
	for <patches@lists.linux.dev>; Wed,  5 Jan 2022 01:52:41 +0000 (UTC)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 204KIKhx032184;
	Tue, 4 Jan 2022 17:52:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Vruz+/v3coPfnQnAT09Wj8MsMlqul4hpJjy8vfarN9U=;
 b=e7VCJzqGW3Ikj0rmYQJQR+9ACAUeoNLmX7cFcrbFWUDVf7ndMZHZOVzThKRnsmcN5Lb0
 s0wxdqR60I+XlMAeXcx8ce9N8j7et7XTwoq+78DYGP+qVJ2R9mskmOeHfuYGWdDGzhvR
 B5AQNqegUj8gD9jeQyTtq+D9fSUvB4tGpU4= 
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dct1a32j5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Jan 2022 17:52:26 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 17:52:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEuTcqKbnQyxqY86hG4S+V6ip+yq/vRovzxEWEI3jYabzx9NOHTW2hEGfbGxf25bvIcglwyY9LlpzUAbyrCsb3uR6qQorKUQi29ylExUBuKsJHOnfEt+PsxpvR4g9ArCugPPcNPmV2Vynwx+x9HzzRjPWcisHbabGzn7tyVLpMPqUo2aZf8UnJHki8gERHPlvz5XMkfi4mY5p+jorVKuGKfptgBYq1J02cTx8WYilOcxCdbmezuNZZgbnkN1PI6WS4ONRBPcCHLvGH06oDI1ogC5lwIFRpqpKb+2UZXHLodosPnlB6n7yqshQjzOjvmP3JsdTkh8OH/FLUpLsXNaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vruz+/v3coPfnQnAT09Wj8MsMlqul4hpJjy8vfarN9U=;
 b=e90B6WdDT4ERu31q2SsYluzI3DTHM5T+TfvoUCToK1ZAV6SyYKM0IaUPJaGPLHkAiIFk4Wz/EZ6CO1xUb0YRpAU2YhMZk3mVdbyKSYJefVjg3WU4sY3wzZgEfsHnUAk/eDANW14iPheJ8ecJskeQOhPXcJ8Rq4bCBeAFzvMPemBP2dlVBB0J2i+sH8kUiX8yfcz6wNEHT4qTHg4O/3+b03CmIz0yqRBfxBvhs29qVWe17akcqfVlFRtFQXVNLvCOyH9LpHQfZP+TwmP3LxP7ujqIEfHAnnk8ISFkK7Rmu29AR9tlkygqyeYbVomgAWC2vVhqlODylph8aJl3xPtQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY3PR15MB5012.namprd15.prod.outlook.com (2603:10b6:a03:3cb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 01:52:24 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 01:52:24 +0000
Date: Tue, 4 Jan 2022 17:52:19 -0800
From: Roman Gushchin <guro@fb.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hyeonggon
 Yoo <42.hyeyoo@gmail.com>, <patches@lists.linux.dev>,
        Julia Lawall
	<julia.lawall@inria.fr>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v4 20/32] mm/slab: Convert most struct page to struct
 slab by spatch
Message-ID: <YdT500mbkNtAeM+B@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-21-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-21-vbabka@suse.cz>
X-ClientProxiedBy: MW3PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:303:2a::10) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf51396b-aeca-4c31-358e-08d9cfee051b
X-MS-TrafficTypeDiagnostic: BY3PR15MB5012:EE_
X-Microsoft-Antispam-PRVS: <BY3PR15MB5012350B01ED45BE854EFAE0BE4B9@BY3PR15MB5012.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C8Oz7HWVacyZz1wIcD4b/p3MOPJ2kdmGrUPEDPQtDD4++Ru84S+JAhPh7V0DiIMRaZyJQCCmWEZ0Nuj1HkhEXCGKSFQ3AgtmJFpHXXb5+VQA8XxZ6FN0gaRM4HSOobdpgqoW0atu7JQACDXm0pjMPngM7lPf/XgJOkxQ/ecEVdP9SGCljY4oBj/7ZghcpjpgJtldNKxFYyHotyVil17BPQ/AzIWFzYNFGO2WjESfuil2ptiImNUr2jaL5sps+Hl/83d22eX94kUsO8apd/WRJ9Nvc4Uew8R40JbIUg3PQsLISRdbkyLMxQS6/VU+XahuEPe6Xl7kHoUZNftDqFdu6+1EnMYUf/8RfXec7IB+mEwmPILjzFtOsdAuu8J1+UwbIirvcsGZxQupxrrrS9/W2h22Tv2Bzx1hsNatzaQpwfGZga8HRbDHdaqoEuKMVIB5zw5Xai3H3SeGK6MmbLr5ILAb6j0jKPmAXY1wKAI1ocWHEtme8Nx/+NLtXAppKMeeCXZu4/4r9cGcUnZICdWDiKd6gPhHyAloz5XMAzvFJI20hOL+e1VhWfEeqlNDRmtz5071axre/lqlXrsb2+rXo70anhKAvIY7gKYeYDTBMokZLJ56mrAHyqCJkperY6IUTFTVOZ75tccIOoaDPUXG2hzAZKXFa9JIHIgMFwk+73aOcYqqWZP4cDJE6R4ZhMhC++kOFp0fN0rh+7yEaSlmJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(6916009)(316002)(2906002)(52116002)(4326008)(8676002)(9686003)(6666004)(66556008)(66476007)(7416002)(508600001)(8936002)(5660300002)(6486002)(186003)(38100700002)(66946007)(6506007)(86362001)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvByNWxSE6JrCN55AH0jZtjEeYRtOuWMfv7kKDiXKvLnIzdYs0mkbhLwufhi?=
 =?us-ascii?Q?oyjhBq10RP+MaU3fvBdVJl4hwHT9h+4oNIce9WYLFK6hF3bJQl3J5KKO4ZDT?=
 =?us-ascii?Q?GEbEMsMea11dX9CmU17O0YJcmf1Syyt6MTqXXKQZGmpsB3qo0ZNN3czmcqf7?=
 =?us-ascii?Q?WBPEHbhj8qY47JRd0Xra9b1Dj0YLBdqEFBkIfI1PKXkGeQm/cFARHGh4Pswm?=
 =?us-ascii?Q?Sm4vKV/EOHetOypNRM08emQDGThb9UJWk1ZILFs91WV9kAyJSTYHAyDFI9nN?=
 =?us-ascii?Q?YJ6ygjBe9phjiG8iGdQ9UH1Pv+ppLabDtoChNShYxXp63boAwDIkSTyMyzOz?=
 =?us-ascii?Q?2RqCrjteRgoSuLrLJ0EfSSkigNHvwB5bn/v93f3QFajfHqLu07cChWDGbaRn?=
 =?us-ascii?Q?wZEGmN/E5t7HGfF15eRoeTth3CnLkfqa9vCCXUdUlXgJyUrXejxDSL+tHe4n?=
 =?us-ascii?Q?e9znYi59izH07W5ktAG7ahcYToPEYNPUyamzAlFJ+HmPaJIuhrv/nkqLU7D3?=
 =?us-ascii?Q?XS/vmJhc3HvvmfLNxL0jL3VN5EOvAybtiMoxQC8GR6lwFAAaQatBJ8ZcQWNn?=
 =?us-ascii?Q?44E6uGxbA3qBVtq2/i3mamcUVUQriaAnuMThvb1rMtBDWlbrsCf2pQYnxmJ9?=
 =?us-ascii?Q?jhKPXNXUGNS5wwUnT2CIQUXpit4iBV9f+L/aBC9jAAI5sXCUUtBQZmSpi9XF?=
 =?us-ascii?Q?D4PiyT3mzgIX+lOqcl8nIgr1Nh7IWGOxoB2DUaw90ocgs3RzEyfp5Ll03dWf?=
 =?us-ascii?Q?iuEa0uVSLFOx1J+G/bU2r/tDXsLECybDGOtXdB6JfQGD/DV9SyJ739Wq+iQ7?=
 =?us-ascii?Q?UhIGZOQZaiaL3mO+GKN7LP+kDWScx3k9VTigBhHIU9gY/kjZQPoCQ6AmYr1B?=
 =?us-ascii?Q?4hYsOZGrpZl0clqZCTm4mPxsThFy9qIZLVz8EqL5stqVJ4fy04Za8oN8ARZu?=
 =?us-ascii?Q?q488fNfuYqE/nRG2NJcWRRQkyJT/6Fu798F/CY2+D8C9j6zN3f+Tx5YLaYyv?=
 =?us-ascii?Q?1laBzWVrdbocSytcbH4KW7bLHej3C+cL4fFgsLUPu36Kxq1woBLATtzb6V1c?=
 =?us-ascii?Q?m+cY/2i87WJp4MIW/ROVtfWybvTkPWW+Pw4f6Qk3itD+hzTs7xjaFZ6b69qy?=
 =?us-ascii?Q?z1/Hg/lg+pJtjmLBZojbBi/pi+ArWGy7NSLFsnccQ1JeY+6y9J73PX+W+ruW?=
 =?us-ascii?Q?ubndV/vtDcSzcV2qVr/px2XLGygVecJ0MwzFuSkEdmg/pufQSS3ZZoWJ9WWq?=
 =?us-ascii?Q?SXc9QosHRjBtUiFb/EeVyAWGJWVWr4XnUdtW6F5p8azNQ7foyVMo2TQgdWoA?=
 =?us-ascii?Q?5RauN/7B3WyDxDVBwZ47uKFriaDrSca3FNmLEg+Kkl3vvfGesAH3+Gy5QwCQ?=
 =?us-ascii?Q?bsimlxK9owsYHktB4+SSSRSPV61NM8FTIdq498wyhCNixrM6BpTMAr1RC9Rd?=
 =?us-ascii?Q?FWD/ornkVun+AUY++b4ThPNyJTadMr2xHp7R4ca0YszxqRLca8dzldQ9/vzS?=
 =?us-ascii?Q?XCnqvoiMExn2RhTJA2B1HqlYfaKdqHSElRPDB9q/v/9CX6eir3NgUg+gG2lj?=
 =?us-ascii?Q?cWMAEfkhk0+OQi47t2vwyvKR3qMPLfe3/PPykLeO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf51396b-aeca-4c31-358e-08d9cfee051b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 01:52:24.6814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YvtPpmjf4KT0L2B/GQJwNRJLgleZSvWNDztAM5QRFGvxpkxyxQe/zrRQjexo+O3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB5012
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 8PJl2F43IdNyZaRgnj8Qxzn1Rng3-el9
X-Proofpoint-ORIG-GUID: 8PJl2F43IdNyZaRgnj8Qxzn1Rng3-el9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_11,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxlogscore=681
 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201050010
X-FB-Internal: deliver

On Tue, Jan 04, 2022 at 01:10:34AM +0100, Vlastimil Babka wrote:
> The majority of conversion from struct page to struct slab in SLAB
> internals can be delegated to a coccinelle semantic patch. This includes
> renaming of variables with 'page' in name to 'slab', and similar.
> 
> Big thanks to Julia Lawall and Luis Chamberlain for help with
> coccinelle.
> 
> // Options: --include-headers --no-includes --smpl-spacing mm/slab.c
> // Note: needs coccinelle 1.1.1 to avoid breaking whitespace, and ocaml for the
> // embedded script
> 
> // build list of functions for applying the next rule
> @initialize:ocaml@
> @@
> 
> let ok_function p =
>   not (List.mem (List.hd p).current_element ["kmem_getpages";"kmem_freepages"])
> 
> // convert the type in selected functions
> @@
> position p : script:ocaml() { ok_function p };
> @@
> 
> - struct page@p
> + struct slab
> 
> @@
> @@
> 
> -PageSlabPfmemalloc(page)
> +slab_test_pfmemalloc(slab)
> 
> @@
> @@
> 
> -ClearPageSlabPfmemalloc(page)
> +slab_clear_pfmemalloc(slab)
> 
> @@
> @@
> 
> obj_to_index(
>  ...,
> - page
> + slab_page(slab)
> ,...)
> 
> // for all functions, change any "struct slab *page" parameter to "struct slab
> // *slab" in the signature, and generally all occurences of "page" to "slab" in
> // the body - with some special cases.
> @@
> identifier fn;
> expression E;
> @@
> 
>  fn(...,
> -   struct slab *page
> +   struct slab *slab
>     ,...)
>  {
> <...
> (
> - int page_node;
> + int slab_node;
> |
> - page_node
> + slab_node
> |
> - page_slab(page)
> + slab
> |
> - page_address(page)
> + slab_address(slab)
> |
> - page_size(page)
> + slab_size(slab)
> |
> - page_to_nid(page)
> + slab_nid(slab)
> |
> - virt_to_head_page(E)
> + virt_to_slab(E)
> |
> - page
> + slab
> )
> ...>
>  }
> 
> // rename a function parameter
> @@
> identifier fn;
> expression E;
> @@
> 
>  fn(...,
> -   int page_node
> +   int slab_node
>     ,...)
>  {
> <...
> - page_node
> + slab_node
> ...>
>  }
> 
> // functions converted by previous rules that were temporarily called using
> // slab_page(E) so we want to remove the wrapper now that they accept struct
> // slab ptr directly
> @@
> identifier fn =~ "index_to_obj";
> expression E;
> @@
> 
>  fn(...,
> - slab_page(E)
> + E
>  ,...)
> 
> // functions that were returning struct page ptr and now will return struct
> // slab ptr, including slab_page() wrapper removal
> @@
> identifier fn =~ "cache_grow_begin|get_valid_first_slab|get_first_slab";
> expression E;
> @@
> 
>  fn(...)
>  {
> <...
> - slab_page(E)
> + E
> ...>
>  }
> 
> // rename any former struct page * declarations
> @@
> @@
> 
> struct slab *
> -page
> +slab
> ;
> 
> // all functions (with exceptions) with a local "struct slab *page" variable
> // that will be renamed to "struct slab *slab"
> @@
> identifier fn !~ "kmem_getpages|kmem_freepages";
> expression E;
> @@
> 
>  fn(...)
>  {
> <...
> (
> - page_slab(page)
> + slab
> |
> - page_to_nid(page)
> + slab_nid(slab)
> |
> - kasan_poison_slab(page)
> + kasan_poison_slab(slab_page(slab))
> |
> - page_address(page)
> + slab_address(slab)
> |
> - page_size(page)
> + slab_size(slab)
> |
> - page->pages
> + slab->slabs
> |
> - page = virt_to_head_page(E)
> + slab = virt_to_slab(E)
> |
> - virt_to_head_page(E)
> + virt_to_slab(E)
> |
> - page
> + slab
> )
> ...>
>  }
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Cc: Julia Lawall <julia.lawall@inria.fr>
> Cc: Luis Chamberlain <mcgrof@kernel.org>

Looks good to me!

Reviewed-by: Roman Gushchin <guro@fb.com>
