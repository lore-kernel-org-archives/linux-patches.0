Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652EB3456C
	for <patches@lists.linux.dev>; Wed,  8 Nov 2023 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C7gp0x6O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699462820; x=1730998820;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=vdCCw2ZkvuoisaKXVmLylfpmcS58dJIO9DrR543ChcI=;
  b=C7gp0x6OjzreVmfFpOb7F4zE8llMaa6Og3ThGLPyRxdvr/n7PmuVzE7p
   04PZ5Wza848KjIYF6YD8kkUyt6Aj1d03gTNhkXFfPCRGFd6m2cnjwS3wS
   yx60slOtuMmtjfwN/q+xUbDUnObzJ2SbYEJh4fA/QBKrg/GALH4wk+p6O
   PTCGPf9pYMhWva/n7Y6lA3Laedcm7cv8fW1+pMEtGiletkAe2bUaxx36v
   Ny+bZ8YuuKG96UsQiHA13kGVaEvfEbhV5+8KpTKCjI7me2s53MNcjaEW8
   YzSqdUK64Dn8AtYwMV9mfg5zTuSCpQM82LFF26dH9h0HhbGvlsOX24hns
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="380202371"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="380202371"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 09:00:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="833541437"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="833541437"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2023 09:00:19 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 8 Nov 2023 09:00:19 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 8 Nov 2023 09:00:18 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 8 Nov 2023 09:00:18 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 8 Nov 2023 09:00:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3ErSSpkQzTl3ng7bThx92Pw5F45Z6c5TdW0tPI7F4qUIrpi+AyOicgt8MHsB7UzFGKDIU65ll46xePSTZtJ7Vu92wLNi31T4aCJZ7OmxNZp5pKhUn7fNadQvmynKfwVe9eEYpVJGO9kcSPYlmc3B7W8Cc1HUWHLWFBZOaPcsTFGyCnygag8AUWWU9M0ytb9QQQ+KNiEnwEn7c+zS9phZHpi/J+Y3OUBHxKB2YgBeqiO1t4Uxe6h6Wk+qaOxOB5L8PYQRz2pZ3daCzlXpm4uid+84hT0YB74seSVHn+lKZ036BrtY1t5198At7UHZxjksw8J8v0W2gqyjgo1IwaZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RR6JewtS5BF0T/3d/KIzGtb2ax5j1uVUOJX9FWD7b7k=;
 b=a8XK9dY+/IkS66uJkRXOfGvW6hovOXDMb9YLEXXtjx8bmB1uiTAl5+ZXPEAmfF+rlpm65KJwLkVt/SmYQOWOjf4nSVjqH413l10qW/6NRoF/TCIwAarZ0FIUI46MoYE2bETIQs04AiuwPVzN6G0dJOK+tpxzYMo+91Olo0+g4Cpr7G36fr20zbcBSj7PnvwF1IbrwGQ5Ny4KE/VrGXC3m8ExNFICiIQ80+rUClG9fkMJHnbKhk8Mien32mutdorWsS7XBJcur31BqNYEhOShpstonRY6IMvcvOenZNHs2HMkE+P1QYlpnhizSstWeNjb9hSrfiMBzgQ9Uzu0S73QTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7558.namprd11.prod.outlook.com (2603:10b6:8:148::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Wed, 8 Nov
 2023 17:00:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%6]) with mapi id 15.20.6954.021; Wed, 8 Nov 2023
 17:00:16 +0000
References: <20231009130116.329529591@linuxfoundation.org>
 <20231009130118.189922269@linuxfoundation.org> <8734xg2seb.fsf@intel.com>
 <2023110837-maturity-clean-6e78@gregkh>
User-agent: mu4e 1.8.11; emacs 28.3
From: Johnathan Mantey <johnathanx.mantey@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, "David S. Miller"
	<davem@davemloft.net>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 062/131] ncsi: Propagate carrier gain/loss events to
 the NCSI controller
Date: Wed, 8 Nov 2023 08:48:08 -0800
In-Reply-To: <2023110837-maturity-clean-6e78@gregkh>
Message-ID: <87y1f818pu.fsf@intel.com>
Content-Type: text/plain; format=flowed
X-ClientProxiedBy: MW4P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::16) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: 37e4c772-4b43-4359-6fcf-08dbe07c2e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfrARbPbYd1oGtpi+WI7VIX3UDI8+VmgKd+4zUfmpwMK+sgT1c5jZR54JzWQ7EDzdTWG4o717xupClbfRXDVKPG+H9vsD4MJtpAkMduQ8IKaQ414Nm/WJ0Oy0oFgbNraOgMclgquPQ+ICQEEv5T5jrKHwOHhwxPlX6CbkwyyM7XRkLXucbwnHQsnGVJI8+M8ZgcdwQJQN3AWTK2HovzCF8eypD2VOWVxd5bnce4yrVc2WJVqTXaeuxa4tuAzvA2kuL5fu+krx+2AivDpyo0yd9yAQav68j0xlV0ji1Nul8kQkPEPtdYQkhQph9IoqYCsudoELu9Z1SMosdYskxVatJHt0o3hPU+MdmQUdsAaaNaeMEIySqvjTeYDPmI4U20mKPrPXzK1RFPdq9Gu3kkhtLffx3+eb+vMYpab20R1fKj8Qv/uGradEhpkCldxmU960a0Cwo3p5otkqOrsc7feHpH4vPn4iBy9MMgUAoLbLjkMPR7KljnFpV1QAaZ5mLC/Gz4xNVL3Ux0tVL7h15bGA68cPeYCWBcugD9c21A14hBS4OhRapbWMZtwDrtW9jg2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(376002)(346002)(39860400002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(66556008)(6666004)(6506007)(2616005)(6486002)(478600001)(6512007)(38100700002)(36756003)(86362001)(82960400001)(5660300002)(54906003)(66476007)(66946007)(41300700001)(83380400001)(26005)(2906002)(8676002)(4326008)(316002)(6916009)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qrrO3pEHdhub4wZjiM0yvTaeHHIMQ/iATz7EXUq6U8QRD1UCizM4wYysksYB?=
 =?us-ascii?Q?r8RXQd3xxn0bP/KriFB1vz/FCMbKRezDpT2XYto2I+DPfMiLFeKqFLBeUgei?=
 =?us-ascii?Q?JXSoihkmaL/2Kr9m15v9hap9kMfoMn4IGL3xEAITFLXHkhqj4aMOYQ+1lbbF?=
 =?us-ascii?Q?DnA52/5HbiLXjbBIhJT4Or/OOQPtNdNKwWYwt53JD+o+VRPODFIe4Foaza0x?=
 =?us-ascii?Q?s4bnphZns3K6PQzQcsn/wh4O3bss4GuX1AolAoLnAvxLe7jGRHvLvg5WWrkL?=
 =?us-ascii?Q?9zR+egg0sDJaDUzglY2p0qSOGF89e06dk9zUs2Fou3sud66SAsZDyOin5hKj?=
 =?us-ascii?Q?U2TJcni3QEDa6Jx1QKSkKF2VcAZaZ5BW7io6au660KBAzv8nBJlHO6tdUFPq?=
 =?us-ascii?Q?bOlkvPnthuu/Elb2+QCF9pLajGARcyBZ6aVEjitztojI/KLf2tfMov62T3jl?=
 =?us-ascii?Q?YUKivrEh1Qet59FinAsuVWs48LGFuI4U111h1FXmrtAxp2KQruwnA8wJgOyY?=
 =?us-ascii?Q?y0Ikp7U8M9Ohj5rY71Z+QHWfARWfYBPei9GxQM+D41p5mD9wc9pVRXl8ezh+?=
 =?us-ascii?Q?1PcyPtQmdwxTWzRC3LA0aZfQ8ZMGDIeJsXtowwfreabAuwW4GThd2rJ0ejE9?=
 =?us-ascii?Q?ueol8oTEsMjxTx5/eF2q3iyRIQCaY8zbwFgg9y/W2ugUweOv0ZtFI4Fatq13?=
 =?us-ascii?Q?o/GmynrVTjuyh4yQ5xqtlS6L05nAMyPFfk6SfYRyEXyEiBjgnFF9LF37LXYn?=
 =?us-ascii?Q?xv5qBoy4yskv9TnFWEs5s3BCS49JCwjNlv6ondn4RmsrzNM6PqcaeophLYzL?=
 =?us-ascii?Q?1yRCmg53kB6nrxEKzzv47aKJuyfYmUd5eHyxht44a6EHD9nqHOFbDmewmyVY?=
 =?us-ascii?Q?+cWTy5oLSr+T5uyesW0p19aYVDaaDmcF3Y9H+okL2s5Z4DIZVHr1tZYQle9C?=
 =?us-ascii?Q?P+gwmk7f0bRt8NN9BjcvDbDcLuyj1tni+x9+oZ8lQAg5iCTJOqIY5MCpP+S/?=
 =?us-ascii?Q?DXXTaph0iqO6/dZU/TEy2ZX2h56og9Ke60KHTmuH6G+0BEQDat8HjuTVDmy0?=
 =?us-ascii?Q?xyUndZrnJiF0T5gG4kiENifWrLYhV7YF3bdnxhX+UHzVtKxBWhXijD1q+eCI?=
 =?us-ascii?Q?fGge8+Mfju9Q0SQoayr5DfKi9Kjwb/E9A90boY0a07sNhDEoGua1QXh6H6Tk?=
 =?us-ascii?Q?qYl+59igiczOKiqq4ViLSrnfpPqCEOg25gcLjaEuSGCk+iB/jAer2Fz/vA4u?=
 =?us-ascii?Q?KvMaGBrN1SgI1hoWHXNX6H0x+wjD4lgCHh31O2bfg7ojdy/dh1TQlZoNSPXp?=
 =?us-ascii?Q?PZDQ+UNSJ7fkIfB2hzudANwLWC1nzcymdONz3KFcyqtBNhP/NRjccua1oqEZ?=
 =?us-ascii?Q?0AWonBIfrtDIqi4Ai64BT0ePx1yOoscA5QdpTvqo/Z91syqUM0iPtFTDLZz8?=
 =?us-ascii?Q?1NnxF9e5L5aI/otAIWUu2RkvEpu25xqj8cLaJHmx4BrE9aOxXYlKUV+LBwE2?=
 =?us-ascii?Q?hC4a5XQ+AQz3rTGDNV3ME9AvttoizcuLVA1vQK0/365FJ86aOi4RE28Y+1Da?=
 =?us-ascii?Q?AC02sISkzracSYT5W+/4hfTuw0Fo589p6Q8sstajDYMn7QJrCLJoRa5AWJh/?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e4c772-4b43-4359-6fcf-08dbe07c2e3c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 17:00:16.2477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +FoM+Q1HJhw7Di4bQM72MP8QEPZSr0DEt7iV4WddzCN6fvg0k4Ql+Hekl9WKWAwy2It06UFYzbN3XJ8JTy+20czilHXkFSwyHpxs7qJ90+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7558
X-OriginatorOrg: intel.com


Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Nov 08, 2023 at 07:08:21AM -0800, Johnathan Mantey 
> wrote:
>> 
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> 
>> > 5.4-stable review patch.  If anyone has any objections, 
>> > please let me
>> > know.
>> > 
>> 
>> I have discovered an undesirable side effect caused by this 
>> change. If it
>> isn't too late, I'd like to see this change set dropped.
>
> And what is that side effect?
>
> This is already in the following released kernels:
> 	5.4.258 5.10.198 5.15.134 6.1.56 6.5.6 6.6
> so please, fix this in Linus's tree and tag the fix for the 
> stable
> backports as well and all will be good.
>

The problem discovered:
The network link between the BMC NIC reports NO-CARRIER when the 
carrier is lost from one of the secondary network ports.
Restoring carrier on the secondary network port does not restore 
CARRIER state on the BMC shared interface.
Carrier loss and gain on the BMC NIC should only be due to 
removal/insertion of a network connection to the RJ45 shared by 
the BMC and host OS.

> thanks,
>
> greg k-h


-- 
Johnathan Mantey
