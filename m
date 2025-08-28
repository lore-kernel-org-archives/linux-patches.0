Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389BD285411
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756412105; cv=fail; b=bfo5NSOCY99jU0P09x4hGTJ9s7NyW8ZtYCvziQbKqmkhVYQOBZSF17dSJBxpU2ix/NRfTCD9SOcZ/+yHe3A3L1ywLBV1MWgGwS22j10FqG5M2V2SA23gNvwwcEokvA+mgv88u3etgWpBU6wMsYzomkuTQxIEFnL2iNwoEnt8Y4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756412105; c=relaxed/simple;
	bh=Stf9D9uyatuXV5Uro43cTlJ/J39cG2VPvYtpcdbjJQ0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kbBWHHFoFtfWPW6UlGUP/+qsGA54Yl5WUwMpEDV82rWprtYzvUkDapFnG2FCcR671zJrvFVHTmZMuUcgzxptl+VQbZosg/RMN9Lp6QU3r9XMQRZUoViSrBeavvOM77Or/U3R5U1Hmvv7n593AF/NvkSrQhuCcCVKND6Ibaajth0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5xp+oFr; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5xp+oFr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756412104; x=1787948104;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Stf9D9uyatuXV5Uro43cTlJ/J39cG2VPvYtpcdbjJQ0=;
  b=N5xp+oFrLgO42vimF1/LERo25SIZyMGTyVAlZ8iiXGGpZkj0CzxJcHQu
   Qgpkx9c/CNBTJSrK42+s3pUMgkvIhrKyzx8OvC0c5qvxqKXRDo4HfWxBM
   6hUjria/FvCo7y/tDz1v3Jp2+qYM/UET/pdUbRx2t4RjYXBVKvV4Vt5OB
   PFgYwSq5ApAcHR85DcbVpErntSfe5oM0k+I7+cOf8voMwquKWU8N7UHz5
   I0cwjHwwAuniba1PTTSPUhHu/6K3VkgDvUXh0UoUqpuqFwtOF6v7wZCoR
   4mGZdIcFizBKypiAXD8ndJuzJB2k8GMh/nlaaTQ44L+XcFL0PljHpXaXQ
   g==;
X-CSE-ConnectionGUID: iTSOekbHRB2xK+1EGX1xVw==
X-CSE-MsgGUID: olpVEZmkTTenJHOYGJHb8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="61329334"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="61329334"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 13:15:04 -0700
X-CSE-ConnectionGUID: 5qCwcItKRWuyBFdDgFV/Pg==
X-CSE-MsgGUID: TslNXFzQRd2eeVY0loZRkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170108579"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 13:15:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 13:15:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 13:15:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 13:15:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIK2r1+Outg4hxwwlcIVWJX4muE33sWpNTd1iApyX6Fdo3cLH9i/zahKny3mdQNNckSBpvscIR9PdHTSbUSFFTtS/OZccsWhBWJOeqZtEzBEUY4+srH2egZDZ+/kgyVQyASZOvSkd9stY/FoY/Hw0c97WLa3+ctKfsZ8TD4V+XJ4UB567h0oXSx4mzryYuJ4N8asYsJeSQVTLPR5FDcQ7O316MNdk3+zuGsA/M0Q9rb5Svwph0TihGfHhQX5AwS2TGHaQ8r6dKaL2URGQQXkd3dVc7GRPPg22iVXsvdGWgCEjoZn2gZWctxXjU8mQ4XL1vzAYnve0YHJv3E3fp1OqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1H0BR9IQCs4F6Cb89bsJEi/AzDHib62aOlRUfxWAcQ=;
 b=jjyVkDVlVJ7Cldqqa6CaDPERYPj2G795y4rDQRohPPz68WFajdBUzPNbYhx6sdCNxdgV72+auvfjazBimDhk4FgIrqAUA2APm8HH2UTSu+4FBoj0yEAgEL3Or3+3VHU7fo5Oyao65V6h6wdw3IXiSOnMbQSUCZp7nfs/eetEDHPaDWSos0FgsZZaF/HXRsR3Kx4+OVtOs0ZQNX0lX10jPIdr7pFfroPP33adq3mnRzNNX80I+CrGhOUSl6CUSR4ceTQQeUZXPxnFBzbe92Ef/xUBJXuU6gZQJp+Zn71krvjDZdGDIrp2r6SNQNvZYIn0b8d/BVRtkR8RSXv9b4hm/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7407.namprd11.prod.outlook.com (2603:10b6:8:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 20:14:59 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 20:14:59 +0000
Date: Thu, 28 Aug 2025 13:14:57 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Message-ID: <aLC4wVQiBDHW_Jte@agluck-desk3>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
 <SJ1PR11MB6083A9FDABF6F33456CD14A4FC34A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aKzhsOWp2TlFF5mK@agluck-desk3>
 <d06e81db-1669-4a6c-ba75-67fe15c53303@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d06e81db-1669-4a6c-ba75-67fe15c53303@intel.com>
X-ClientProxiedBy: SJ0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::20) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7407:EE_
X-MS-Office365-Filtering-Correlation-Id: 4167e274-f7e6-463d-2f59-08dde66f9041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?s+vhEy+6dbTr6xFFNBtYjLPumpcGBEP/gyAPn4fH+p2GY3Mau3Lr+cY7drF1?=
 =?us-ascii?Q?D7IoBDPIjRG6wQsMIjU+fvgHTKvSXSkuLON0d/Z/EQTJNYcU1NE7B1EQf1+I?=
 =?us-ascii?Q?BY3BtgdTpzn/XyQ0yA32pbAWrIGm7fnujbh5UG9UJG/8BTaKvHLaCeI6VbG/?=
 =?us-ascii?Q?7Jvx3CUk6vKFGLPxBfwps63jHdDFihENx7uXAc4Pe7OJBHxPNiQTe42SWj2v?=
 =?us-ascii?Q?L7kwuMLDpgqgKLKlHen6GZofjL0CTYx4kP59vAzP9MnH/ZH7f3yM2u5Yrzcm?=
 =?us-ascii?Q?mhl0xjcuHahSAT/6ncn7Wo6BpIrEwVhlLBleMK1nzZHu24l4RKMMtK/uGKtV?=
 =?us-ascii?Q?Ah4YrCtJ2vS9yw1cdkoU42+Kvd5ohvBgYbH/QNsl5ZIwXT6fVG5PP2Zd3ipl?=
 =?us-ascii?Q?XCogAmYkR2b8lsQwKxVgkwVWIDcFbKI5FNEEzhYue/rfEYGgiC3wb7pxknkX?=
 =?us-ascii?Q?e492YAqp8ngEeXQqLeZdYlLRtgU7wPbDY5WdKLdMbyQWk6S3D6x+1COl6X0h?=
 =?us-ascii?Q?RNrlPoW0kXdqkqUY5BfNlV687BN3/Es5EkmReh37W+SYNze66XjPPSxV4+N4?=
 =?us-ascii?Q?w5AZpJWm7n15Z9+zKxu6Kksr9LmvlP16BDs8ZhWFMf6TBTB1iR6Micxsjc5W?=
 =?us-ascii?Q?qa11Mvhq0Fg/pmoVkyUqfVYWaJcab6GkviwasSRZUTZ6/UMLUxyOSMJaxsiC?=
 =?us-ascii?Q?JOhjtp821naOpweQSazjc8FGW5jjQcGJCKjz5F/WOyAC472nakbSzHKhTvMm?=
 =?us-ascii?Q?E+HbkHGyRFwm5h7LOGSKwSUOQucZw1JAkx55BupfIPC6+UTwiRsj9TYsqusY?=
 =?us-ascii?Q?Kb6/9lMrRXtKQEQ9be0a77cR4hxEuZRw4nPh20h4WItXWPEGXtQSj41z1uGK?=
 =?us-ascii?Q?ocOaDWf72yQ+fkGdFUqE18tWQXx/B3sa1gDnhvFDh/mGKEpHsTHqm2pT0xEK?=
 =?us-ascii?Q?eF9tbYXAHOmQmI74d+hQicG5Buv9L8zN+J5BSKkxcL/h4IHhUQxfK4Ep5siv?=
 =?us-ascii?Q?wBfNoyiKEeBrXeIMixutp8yrtLvXcTvQjom18qHqHG3Z38ASajO8JsRqvg95?=
 =?us-ascii?Q?O3Z/GXxqQQ6l8zIPSYvs0jYTBD85jvuH5ORl4LOK+EcRuJ6kfaCbzanbsZue?=
 =?us-ascii?Q?yg3XC3aReTlwQrBEBYf0rKn9eezYXH9en6Ok3DKttAk6DDIBtvhphjHJOFlu?=
 =?us-ascii?Q?NprEK5DT4nnpetB2MrM3DKO8pCojdg+RvUnXO5eVnvFu5YBfb4AcGpBSdaHz?=
 =?us-ascii?Q?LXr0LDxu15x+/1ZW/mL5DdKYwJnukdqq4ekyNS1JsBiIedkzdAWl5IMMVKLr?=
 =?us-ascii?Q?vCSQkCFpnpCrz+Du+0KjSPSZv8aRVvfUjt2gKd9yJdt9JUwozjh/DDUQFtFa?=
 =?us-ascii?Q?/Ik3pPEk4lUoF+OarwR9kO+aSdcw53qmXjc5YdHwlfuQtc9qKmD60GZpKGzN?=
 =?us-ascii?Q?V7MD3xDDT/s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NvF2mEUW6wXvod1PF/gbQmVVMYkGEI78/HRwZQCg+38WXWSO4hrKqwbvMy2O?=
 =?us-ascii?Q?JRmhc4TwJ41bZTv5qjvnzAsRlb3MMgLEKYzOG9x35JS4c44KbMoOe7yCNGmI?=
 =?us-ascii?Q?Vk9oj0Uo6gYvOpdokgpPcx2O3KAazKyTYmRhUdFBHvdVq8hZNjtfLcTysjAt?=
 =?us-ascii?Q?9VBRm3+S7DwfNmnvKaiaAvicb23QPWg909+tly8hsFCjP1X8+WIR+69J/qzv?=
 =?us-ascii?Q?nf4mrLxz1X9RqDsZsk1OQn6e5OnbNzXBiOa9oR7yBzyRgLI9VkUydPVlslcM?=
 =?us-ascii?Q?YH4yh30bYw8u9d3Gxvd9gjdSnnCwdMA6VuDcUGIIb91xgxJT7rXpanYIRHP5?=
 =?us-ascii?Q?hd8HaLEDjfbI9f6/S0IPS+JBKdgClukO6aXxdkx4jVCI8xEFDdCoird+NhTL?=
 =?us-ascii?Q?aNO3C2/MTrssE9HcSe2IdnjwoiJaHvG6uUJiH3o1ORT1ChUzDz8YHpyzosb3?=
 =?us-ascii?Q?xwWOZhv85jv3DWYlIjqZH76TpAHQjHG4W9uiKoJUcCz7Ht+X/Qc52Kmzb5Ny?=
 =?us-ascii?Q?kcIR75JczFZV7eNCJmYFOF2BNYv/4Ip1B6JhjuDrYSmbtF/MwDP9sbIZ23IT?=
 =?us-ascii?Q?EZ0CZ2f5lOCBp/W99KZwHwsyPn24uzCrSQ0HbCzENnfPGd80FnkMtnSdu0Am?=
 =?us-ascii?Q?Qo/yzhC15K2//Kj0+6bDCFSpugU54efgJJX9wyiUFOdxPA0vJ4VP2dUYPBf6?=
 =?us-ascii?Q?q52dXCyGmo/iiDYbVRaPGm9KZ13K/FnpR7nvvNftMg+21HeAM0wAZU6etXAy?=
 =?us-ascii?Q?VF6PT5zSaCLBuNhdajGZwV9cvTBNRFq/TkukWWoZg+5Zpy3r+rXpS0kMbb92?=
 =?us-ascii?Q?2Xr29TUCgBfQJyc7Mtb+oFOeVTMsI9OncwCGAaP2R2XJkyrT4mVHoTxuAszv?=
 =?us-ascii?Q?5Z8JQfOkLaFxQpJrimoIZynOs+5a4s3kuWmN+i8yL4N0cwDpztXWaZAG34Vu?=
 =?us-ascii?Q?lCroAdI/Z4GtPd2jB1ouv6IQwIsfMM1+DwSi1eDJ90lRZdV5zp28G/TQ+5dG?=
 =?us-ascii?Q?0ugvI8OmDUnF068Ydt4jn9BFMZ/K5D0DG2TgHoQDVC4dpfCbIib2Ui3uZJjF?=
 =?us-ascii?Q?i9F89/yjT/AW/6aD1P8dg2k8qJj9E0yahtLO/a3zeJMP2YYHOfRFYgZFe30A?=
 =?us-ascii?Q?KeZ7HvH+6sqpwNwad5j5P+kwo1b+E1BrkdD2fnLhnQUlREDD9efOEM3Xj90P?=
 =?us-ascii?Q?GPnb1FFRcnFupyJ0Y0NO/2vPbe00/fpZtosU8yxX4NTHGUNsA5cdwXRfZEtx?=
 =?us-ascii?Q?wWiHJVWrS7QqqLmkjShRZjyofG/5pK37qts6if41FNMwfBvj+lGq5IKitCPh?=
 =?us-ascii?Q?bqjEN52fCycQ0b4Ho1t9K519JTW1ehfbBPyBkAxUy7nGacJFZzecobW3s1m8?=
 =?us-ascii?Q?QtRnw/wIbxXVznbfmmuq/Gav5+XrPYz8jBEeQx+35n1W/Y/ggAbUVgFTXEii?=
 =?us-ascii?Q?x1H0UmJ1eoHmPNbegrECuWAjCHxddSIfmMZy+cgI9n0Oa/DyrCI75o30sk9t?=
 =?us-ascii?Q?uUjlH+08KDDsEGFYNIPpRbQJzf3TM37xojzlSTghVP+NSoP4LaRfCpc+F8lB?=
 =?us-ascii?Q?a9zAfKQzHsrF+CRssVTdqnRpleyq+7rqi31Dy86O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4167e274-f7e6-463d-2f59-08dde66f9041
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 20:14:59.3857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2AnQPzUgGG8mWApZvehryYef1KQrqhPkKsaSnEz9YMPcXtWOGtaho6n/km6VPo63IApJ75QmiVAT/ASz46MrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7407
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 09:45:41AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/25/25 3:20 PM, Luck, Tony wrote:
> > On Fri, Aug 15, 2025 at 03:47:17PM +0000, Luck, Tony wrote:
> >>> I think this series is close to being ready to pass to the x86 maintainers.
> >>> To that end I focused a lot on the changelogs with the goal to meet the
> >>> tip requirements that mostly involved switching to imperative tone. I do not
> >>> expect that I found all the cases though (and I may also have made some mistakes
> >>> in my suggested text!) so please ensure the changelogs are in imperative tone
> >>> and uses consistent terms throughout the series.
> >>>
> >>> If you disagree with any feedback or if any of the feedback is unclear please
> >>> let us discuss before you spin a new version. Of course it is not required
> >>> that you follow all feedback but if you don't I would like to learn why.
> >>>
> >>> Please note that I will be offline next week.
> >>
> >> Reinette,
> >>
> >> I took one fast pass through all your comments. I think they all
> >> look good (and I believe I understand each one). Thanks for all
> >> the suggestions.
> >>
> >> I'll try to keep (better) notes on what I change as I work through
> >> each patch so I'll have a summary of any areas that I'm unsure
> >> about for you to read when you get back before I post v9.
> >>
> >> Enjoy your time away.
> > 
> > Reinette,
> > 
> > I've completed a longer, slower, pass through making changes to prepare
> > for v9.  Summary of changes per patch below. I didn't disagree with any
> > of your suggestions.
> 
> For me the item that I expected may need discussion is the use of
> active_event_groups that no longer exists in v9.

Yes. It was removed as part of the refactor to drop the pkg_mmio_info[]
array.

> 
> > 
> > The bulk of the changes are small, and localized to each patch. The
> > exception being removal of pkg_mmio_info[] which dropped patch 18 (which
> > just counted regions prior to allocation of pkg_mmio_info[]) and patch
> > 19 (which finished filling out the details.
> > 
> > discover_events() is now named enable_events(), since there are almost
> > no "steps" involved, it doesn't have a header comment. The name now
> > describes what it does.
> > 
> > Theoretically skip_this_region() might find some regions unusable, while
> > others in the same pmt_feature_group are OK. To handle this I zero the
> > telemetry_region::addr so that intel_aet_read_event() can easily skip
> > "bad" regions.
> 
> This is a significant change that simplifies the implementation a lot. 
> Even so, it is concerning that resctrl takes liberty to reach in and modify
> INTEL_PMT_TELEMETRY's data structure for its convenience though. Could the
> changelog motivate why it is ok and safe to do so? Should something like
> this not rather be done with a helper exposed by subsystem (INTEL_PMT_TELEMETRY)
> to be able to track such changes?

I can update the commit message to explain. I did check how the INTEL_PMT_TELEMETRY
code handles intel_pmt_put_feature_group(). It just does kref_put() on
pmt_feature_group::kref which results in a call to
pmt_feature_group_release() which simply does a kfree() for the
structure. So it doesn't care if I modify any fields (except for kref!)

If INTEL_PMT_TELEMETRY did care, it would have marked the return pointer
from intel_pmt_get_regions_by_feature() as "const".

If that isn't sufficient, can you expand on your thoughts about a helper
in the INTEL_PMT_TELEMETRY subsystem?

> Reinette

-Tony
