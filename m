Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92E22592
	for <patches@lists.linux.dev>; Wed,  8 Nov 2023 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WeZv0oYT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699456197; x=1730992197;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=nR9plCYEQAe8R4sPS9z8XIm02TO3KmD0RJSZNfs6Mfg=;
  b=WeZv0oYT02ZQmzrN6pfGALJMHTA7Dk3LYuZX7JZ4mzICPH3vvfMFZOpH
   TJ21Hj7HYqcMchYfvvNqWpqCDpCT0e9tEaQsanJ95hxd1eiaeoBO50XeN
   7IhnrvrVbz3qS05LlzWDBGwSu0gtUVfHhIsn6FmbvzKTH7wr20vOBWr/y
   0kIpjImy2lMu/wUeYldWl+6k7BsJ0hFXYSEFRsHchXKlGc0wsuqqbBGsL
   CqonpOmpaiApY1PIiV+IzbGm0f1exIwsVz58yyvIJpVrhTjXTh/s5esUr
   Xlh+i4VAy5VVMdkNHyZBsyyXG834kpertZWNJL8Uvn2Wh84XjlZCyaNyR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2812255"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="2812255"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 07:09:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="833513103"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="833513103"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2023 07:09:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 8 Nov 2023 07:09:53 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 8 Nov 2023 07:09:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 8 Nov 2023 07:09:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GL6MLxAD5Gx3SkZOG6LX0kzk0reyDurGK0lu5Ppjgq3Nt9HCcY2GsHjla0oB84Na52DyW2IuwSFl5zaszeyH6Wfl5RmfR2IRBBNXR58TA80Lj8OWYiPrl4zfVfXE7IjWVYk+wJHC5qngwre8h7+K9g8/iLyBuxdreoXdHdb966kem68/+pIYImMypnkJ9mSKTaq6qpq65qgyDX7tn+/M94gsIlyO8bx0MgkCWAqvK1R79DAy3b8JoQeErcYKCcTHpCXBC8R/Vt+1FBTeQP3xyxL1nwd5RrD22Qz040hugC+a41S0hGQnyvJtT4moDcihUNY7asqkee4nyK4Psr8f6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOrQ4mGQE7GS4qqKI02pFaoKS3eISBPeNKJ6G8FMVmM=;
 b=YcQreH7b7YvV7CRMwJmC+duiH6HzohE+tq6wGVBgoJfu4KhmXchKIp9O1B10XVgwhJxj4CE33B8emqyV6OwKiC6gPbXyPAyQn+b1XPybuy+W47lYPhUipuMwfn6d4sdggoGujQztfiYkJnvCeW/3EPs2SqKVKhcfQMQiXYbRvtINmHdiBqas86m8I6QNMH2o8whDEyzzRRde2XY1qTun4RXPX3jRM1brfVkmSrXp9NoTiHBeyPSzl9zrGHBwPrdsSZfElgGt6u6EaFrRMOazuujUPwNnJFriTWGYhmdnfO0NVCWDAN5cTglz5UkdRPZYge6rsD0vwvWOq3UjcUhjFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5425.namprd11.prod.outlook.com (2603:10b6:610:d0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Wed, 8 Nov
 2023 15:09:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%6]) with mapi id 15.20.6954.021; Wed, 8 Nov 2023
 15:09:51 +0000
References: <20231009130116.329529591@linuxfoundation.org>
 <20231009130118.189922269@linuxfoundation.org>
User-agent: mu4e 1.8.11; emacs 28.3
From: Johnathan Mantey <johnathanx.mantey@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, "David S. Miller"
	<davem@davemloft.net>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 062/131] ncsi: Propagate carrier gain/loss events to
 the NCSI controller
Date: Wed, 8 Nov 2023 07:08:21 -0800
In-Reply-To: <20231009130118.189922269@linuxfoundation.org>
Message-ID: <8734xg2seb.fsf@intel.com>
Content-Type: text/plain; format=flowed
X-ClientProxiedBy: SJ0PR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:332::32) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH0PR11MB5425:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d47b8c4-f9b8-4d40-f274-08dbe06cc192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V80wWr8vttJjuO0OgzXW9nKcytP0DTOqJBrHW3ICnEpdneOdV0GJSnoWfC8gRFNkiNZfKB+n6TPcILAOlSHriCNltC3i7F5p4YOIqydGaZxj4TZhbYZ+jNUgo9qHL9HxLPyeMsuLUFWeZTsjnzDGf5qTqo60mXyjmsA6XpmNqKbvfre6qRKm8fuq3VO8E0mT2KpR6cUWKIHz8/zPcmdD7X+BBG0ZijGlST7tQ3RQmT6DJ3bVJcawX3vA0USy5B5WkBO+h79UkGUr82+i7JUSvUXenAN6ZRwBmMWR5qj62RJBzB8tU7fc4ZUJwAtAc+Mb6IwtnC0n2NrQlRdlFKbD5cIGz/c1A7LeO2tofv9HyiJub3sM4XoYiRZVORv/+g7yqDgF4xxGP5UAl9nKvI92CPHTkyh36rKVcd31bmPsYcuuQD3kItKA1SVI/zdwRbHz1TDIT2gD779+8IdkVHgl/6GNV4+epJGwhObEYhZVbrnOEteiXvswhjrSBuvOv6RZ7Xky6ipqjQSpHJTKwIZFH/DZOiuLj/DriQ0ZeS/yJ61MGZI6DSFx/TZ90vNWv3NT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(2906002)(41300700001)(6916009)(478600001)(66946007)(54906003)(316002)(38100700002)(8676002)(66476007)(4326008)(36756003)(8936002)(66556008)(6486002)(86362001)(5660300002)(82960400001)(2616005)(6666004)(6506007)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+7j5kq0Hy+yJQJH4QHN83q/+DCi0LEtqVYzBs/saW7pqG2Oe0aabDXsFxJaL?=
 =?us-ascii?Q?bgXx6/FC8SlVIYs/Lj/fTZF/l/FpT78eQAmkWxltUFR87F7HApzZVkNMiNk7?=
 =?us-ascii?Q?i4hTo8SFx7U7ms/VVuNaMKEaevQGtcIBua5rggerZSEE7ie4uDYv6mijSr9F?=
 =?us-ascii?Q?aZlpnXD6sfADaF8MFoNQf+J7P0pejVlYjHUq9xfp+mtgFck5zeQVCTd21FFE?=
 =?us-ascii?Q?2NQDMQ0MUO8tjKvtkr1vxv7aZ5babhxKzb2Hk0uJh9dLwGOkS67WbnDaVjZM?=
 =?us-ascii?Q?Aogu+fw+cX62+fmq4qkkgEc5Hx6fDWfwTEQM7vFJ7WtEglmBhJ2T3u2d7Kul?=
 =?us-ascii?Q?ps7zNt4Ltj6Xe4Of1ualdH97G4zDjbczgsw3hBfWUqWIkj4EWtgNqyLHWbYD?=
 =?us-ascii?Q?Eib+xDfyiof74ZVu1NP6qFxm3NoLPuaq9yivWn38Ag2JV6oMMfspsUboSyEk?=
 =?us-ascii?Q?Mee5ZMllHb4aBY61sjrFzBZcxAAWh/BOGojtM9H7dOPHQlnZM7OQsw/Pfc0X?=
 =?us-ascii?Q?cw/C7PIxdhBAoMN588v1gNdwz3PQooAtTnufe9M/vkIodp1g2uXg84737KbW?=
 =?us-ascii?Q?B8p276u1yCNFu/xjdS6WwWX75B6SDKh0ireL3ECuK0WMNEDD6tPReSxwYeQe?=
 =?us-ascii?Q?QigT3x+mzZjDbAYpliVqF5+WuMjQOwiJaguKVXol1EUwY1DqakzA0XsIxvLk?=
 =?us-ascii?Q?H0kpQQ2pD3qaqHH8Y/ky7m5/3XF/Pg425Nug4NhcGUVdi3ByOL+up8iccpuB?=
 =?us-ascii?Q?jWvNwhYJei5YAr01gR1+SaAj1nGDl2qN1FYN6Lqi1FjHztIHwc6uXWLW71/7?=
 =?us-ascii?Q?Vt8ls9beV3x87fEM9N4yPioxpWVNP1ACSrI5ZAg4PQcsNcNsSQ3ETnIuDUYv?=
 =?us-ascii?Q?30bGpJ238itlnpX5znXUR9VCU1rxmxjn+BtHryopsjCJSd6HaF9nL+8IULkb?=
 =?us-ascii?Q?fjaAP8SKyI3hYJ1YVJaG772wIE0fn27zSyh9OIIcKQr2nBEf+hOzyoANkmGo?=
 =?us-ascii?Q?n2qhxrqxy0Sy5DWQ1OOLcprCnVLslMBvUUoQVSy/8XHQYHyPvXDiNOsG1LnB?=
 =?us-ascii?Q?Y82b0x7ytfD6eZGBcPfLo88i05w3z6kG5x8kHwX2TvZAHb41k7Eb7HEPybjf?=
 =?us-ascii?Q?osg+JO2Bf41SZrPHOtiPMQviLWu2DAUyqeIhnaYJWEzPwg6VbUoAoCnkEgac?=
 =?us-ascii?Q?7J2VQfUXF8fWZSCZG9JhONyQYbgoyaQRVciRov8hCGnrcN1p0oXiJhcz5z39?=
 =?us-ascii?Q?hc90m1qANFZgGje1Q162SjVLODDg69j3retL+TJ7VLd/u01g9R7QRbHqpnOP?=
 =?us-ascii?Q?NLI1YdBYgP4DPk8nStXnWcbawMkXR4JeDHtX83Ox8PF0tF8e8Ys5F87yLlnA?=
 =?us-ascii?Q?0mZMqZC8sX46crdUR/vfbfAuZMbO7OSsoNIHZ3KBYYfw/TVJamdjBPXiNDND?=
 =?us-ascii?Q?6gjcrivlaidMo+/LD9R5xZn8GbqPQAN6C+Eq6/Yjs043b34uxmXh0XSM+dZQ?=
 =?us-ascii?Q?n2WInpSTYkT+ot5amSjGjknEv1DTWCTPNHzKxPdngteUmoHU7jtPkA4jq2bO?=
 =?us-ascii?Q?eNI7bPP/BYcYhg65lQOTdWD9b6mKsLezmSPdTNNyl8yz7l/rhIRDoiE06f8c?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d47b8c4-f9b8-4d40-f274-08dbe06cc192
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 15:09:51.3616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kew0IVeLFDN1fI1JPYc9dHMXzWOmHNHBN3K476eLSQmiEmh4ho+/HlTjzUxLQTHK2tkzKYzqcS1lu7OSvSF4Ic9Ku9T5tmcEJnp0cXC4u2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5425
X-OriginatorOrg: intel.com


Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> 5.4-stable review patch.  If anyone has any objections, please 
> let me know.
>

I have discovered an undesirable side effect caused by this 
change. If it isn't too late, I'd like to see this change set 
dropped.

> ------------------
>
> From: Johnathan Mantey <johnathanx.mantey@intel.com>
>
> [ Upstream commit 3780bb29311eccb7a1c9641032a112eed237f7e3 ]
>
> Report the carrier/no-carrier state for the network interface
> shared between the BMC and the passthrough channel. Without this
> functionality the BMC is unable to reconfigure the NIC in the 
> event
> of a re-cabling to a different subnet.
>
> Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ncsi/ncsi-aen.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
> index 62fb1031763d1..f8854bff286cb 100644
> --- a/net/ncsi/ncsi-aen.c
> +++ b/net/ncsi/ncsi-aen.c
> @@ -89,6 +89,11 @@ static int ncsi_aen_handler_lsc(struct 
> ncsi_dev_priv *ndp,
>  	if ((had_link == has_link) || chained)
>  		return 0;
>  
> +	if (had_link)
> +		netif_carrier_off(ndp->ndev.dev);
> +	else
> +		netif_carrier_on(ndp->ndev.dev);
> +
>  	if (!ndp->multi_package && !nc->package->multi_channel) {
>  		if (had_link) {
>  			ndp->flags |= NCSI_DEV_RESHUFFLE;


-- 
Johnathan Mantey
