Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7065B3093AB
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 12:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756210879; cv=fail; b=AwB/PjwO/aOv6C/0k+zvNWuJN+sVxUKF7GJStzbiaJfDDEs7LdZQ/DYHGGEWKru1wmzwTyTHuoBibszFQOpeOmEJM7DHl7YndXtPaYCoJuxJ5Z4E1vArZoPZFByZTTEgp78R4hfsGtguTEeoUqTjMNEUQ6Cn3djCSjY5EVgF8wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756210879; c=relaxed/simple;
	bh=GTFeyp2YlIbzc6iSW3XSfL4DDBD8dBvYYkhLusqdgDA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ks03gUlNsuPPX/5i7rYYwy4V7HV+NNr0t9tbhYFO6OY3bdFPMB+C6LUWrKU2WmRUwFbGZbLAi8q/Y7y6NsFoE9ADnB7Dkk7Y1OERqynqrRX91N+PC77m4u7c9AKRj20fJtM8RyLkskhV4sMWxTidATZuQtv8zkRpMF+sb37fCE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=apDlvsOk; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="apDlvsOk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756210878; x=1787746878;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=GTFeyp2YlIbzc6iSW3XSfL4DDBD8dBvYYkhLusqdgDA=;
  b=apDlvsOkfEq/Y0gaTWvLaIG+EbO0KsUYQqZxj91YDCEuG4ShWGAUC+Uf
   8wvApBHYlVSbVxR7M1fWRDI9AL3MsR3njd+989oIXGsobd4mR/oqmVZ6S
   gU/7nCdfYW161LgwfYySoArI6rWF45fL+GOiiw3IKoqAHNGQbTnEGtip1
   efProHie8ffx71TNvHmTocDCXhRijXEBkNVKv8c4DHLG9kmpLehfb2XiK
   IW+5k2hmETCNDti5gqBlEidwnSNHq9dqSWFA/W2iZMloEyuruhs678Hoq
   1TKqmm3a/mkr9M4PaeT3Ze7iTysl57RqMgxscWSGSSduPX6PfTm2AXLe5
   A==;
X-CSE-ConnectionGUID: Ew7/WKLlS96HnyxG2uPKpQ==
X-CSE-MsgGUID: e1P8mJGmRui+mUd9aXEw0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62275770"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62275770"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 05:21:18 -0700
X-CSE-ConnectionGUID: 1uI7ml/qSZaTOOPRyJeNXQ==
X-CSE-MsgGUID: nIVIbMhdRtaRFjS5NYnIpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="206725254"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 05:21:17 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 05:21:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 05:21:16 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.83) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 05:21:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtoqV4HocOGCg7SBV/NIwRtXXKvK24uWPxCJ+uzpZI2wKUfx9jfg8uj/LyI+DANVNNZn7g5LQbgJSOZGdGAdyKqw+MVamJwBXVnbxmK+cFM2+Gqv4Q/yJcvNshobOOMWASg043pts+ypoOx1SE7BYrwCB97RrcjPTd7JJG6zXlEIASAo8qLj1UhUHcZ0TrFFABs4upOzaYGyNgGYrVmjjPJuTVHY6bxQgCb1wk+mBtm+8p/ScZyIuUZiXeC4Bin+eHtYxaUwHe7x53eirnNwyZZa+ypLHZW5IkM65EFN4wydyOYKbvqcvBpVNDFR9r/VxLRVE9fQInhQ24qqWFkRjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMK7/zOE8ywVeXbgvopYYrnU32RWbYXybQy4GvPjEsE=;
 b=mUoXXSbfB8Kq6JO8F89yJuoKR61bMX98cEOmKfwILkSvtLYqwq+pmVpT/kfrRibsytMTKV5QM7H6mk7gqEtFFX3zSjRAEai9q5lca8OyvdMFAhuOi8g5lk40yM0SAZu+XpW1+PWqFRoLMIr2nmruHBWG3ySKPcev4jGRn5iz4xzsBn40dIU5UpQUFygG+TZvwA0vn/xrpnQgTM8POa28qOZJlA97Gqa6T0hCWhwDP/MVk0tSEFxX1Bg3JXYgOIAlbfo/AWf2MzrJhGoupZf1Phe9Zi+3hBJlbEkPYMkxAeIsoS/kQrhRV2SahljuS+P0euC6bO0V8rSxmwlnedzElQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB4845.namprd11.prod.outlook.com (2603:10b6:a03:2d1::10)
 by MN2PR11MB4632.namprd11.prod.outlook.com (2603:10b6:208:24f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.22; Tue, 26 Aug
 2025 12:21:14 +0000
Received: from SJ0PR11MB4845.namprd11.prod.outlook.com
 ([fe80::8900:d137:e757:ac9f]) by SJ0PR11MB4845.namprd11.prod.outlook.com
 ([fe80::8900:d137:e757:ac9f%5]) with mapi id 15.20.9052.017; Tue, 26 Aug 2025
 12:21:14 +0000
Date: Tue, 26 Aug 2025 15:21:08 +0300
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Ville
 =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>, Jani Nikula
	<jani.nikula@linux.intel.com>, Jani Nikula <jani.nikula@intel.com>, "Sasha
 Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.16 293/457] drm/dp: Change AUX DPCD probe address from
 DPCD_REV to LANE0_1_STATUS
Message-ID: <aK2mtD6GSxzzmF_d@ideak-desk>
Reply-To: <imre.deak@intel.com>
References: <20250826110937.289866482@linuxfoundation.org>
 <20250826110944.623704248@linuxfoundation.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250826110944.623704248@linuxfoundation.org>
X-ClientProxiedBy: DB8P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::26) To SJ0PR11MB4845.namprd11.prod.outlook.com
 (2603:10b6:a03:2d1::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4845:EE_|MN2PR11MB4632:EE_
X-MS-Office365-Filtering-Correlation-Id: f700b451-1a75-47de-410c-08dde49b0ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?CfccHypsaeNs6om/BH6Hq8Em/Cqg0hftFO+tyvGGCyOu6z+yNkzQd6naWQ?=
 =?iso-8859-1?Q?SNE8fomlUr4ie4ALR8kog1cE2/VMZ95n2wEcKO6gpVYn/mN5ekjFsYAHcq?=
 =?iso-8859-1?Q?fJN/NAsWt/BQMdtQRWg8xq2YzP3pLLRgLglcTz7FahZ8QJ925hp2nr3SVM?=
 =?iso-8859-1?Q?bjcBg0UotcNL3XKW7sC33WICcMPtz0/IuSSfJaswdfevKZxErbsdT0rwTW?=
 =?iso-8859-1?Q?Lsy/IzacQwfc/SY6ru7FXKtCL3IxFncaMUiIlqpPlU3abop4oZldBkC12N?=
 =?iso-8859-1?Q?fGqDuIjnDk7zHocVbfgcsjW4+9bB2n3SOen6BiYM3GJfEKv7V9e93hNI0b?=
 =?iso-8859-1?Q?bMoRwss+vYgFKuMjqxzyR77KR6kYAN8dPeUd+uNbQyHgMuBNyGgJzbbY6S?=
 =?iso-8859-1?Q?Tpl12Jllp4nHOXW6vGuE2r9TheKCSFtdbMQxbcMEMk65BCJAmD+++BZte6?=
 =?iso-8859-1?Q?Wtxn2JdHCwRvdtgK+oeVCJ7bAWryuICbVrscSBXHD+WqD2/2tl3tykQI24?=
 =?iso-8859-1?Q?IMt1E9297iZB4sePepoCt797plkcgX4xdO+3UxDu9c0DIRykB32NesZcFQ?=
 =?iso-8859-1?Q?6sDFcmKDO09gEyL7S5kDmKrL8eakLdw8rIi5dx/4R2eZDe4ncuzd0MAQDX?=
 =?iso-8859-1?Q?+azb7YlLfCDu9Cfb4yuX+Q0Lms/48q4kYFkqeyHeU4ZsKnI2FqfHTT66+e?=
 =?iso-8859-1?Q?QtjR1I0boR0eiq4wfOTug/FgcqENSwFJCfq4zLHZAnrMgAsM7gxKe6lkQv?=
 =?iso-8859-1?Q?G5SsyXE13W9Fu2GbHUVVp5EgR8YptoyoK0QsNi2FLPkxwypzyKu83omJgU?=
 =?iso-8859-1?Q?FyuWuanZWJNJmLCXN8C/vVfQQFNHnPX9JdwcP6T2LNnE+ZQROWIvJBetf2?=
 =?iso-8859-1?Q?BOs6H/ySDDvaprzh2P36MjpQEFxGGBl5+GxX69G9dpBDaMcNYH+sdbH9I4?=
 =?iso-8859-1?Q?R5n6f1BJGAqqxSUdX4M2l3H85OSemARSkdS8Eq1EHBzYjY9uaHpnU19Q5n?=
 =?iso-8859-1?Q?wy39xji540JV1V4fhFoGtp17jnJQFO4mpYpscl+roHjaUiG7jk+uMfMaGj?=
 =?iso-8859-1?Q?ZgDJH1EwUKAiMfJGgM4z2vvwXLDYtLBFdugkk6UmwBpqI945ds375Rew/c?=
 =?iso-8859-1?Q?TcB2LkwUyi+UAyo8K+lVf6ljzBL4qxhEJt05XszSf5HE+e0qSmq5i7xZ+q?=
 =?iso-8859-1?Q?XZo0wxhPVIeFC2lnhbQvO1kvO9Z8RnGCjY9LzgnCwR+6qqF2LFBaR3T0y8?=
 =?iso-8859-1?Q?ugB6wE6RrI7R4myOdbdPStiRPxVqUoldc/fMIc3fkWGZR3fafcQ9jAJEiU?=
 =?iso-8859-1?Q?y2x6A5X6/ZQsKTFHdxMNZ7+ijl8sOZA2C7CtJUFKBBn6rn35ZcdZIYQ8po?=
 =?iso-8859-1?Q?tvn1rzjEnUP+JjgpJJwmdgozNQ/zo7FNEIDL6eihTIB1YhPPpW7zwgMWtg?=
 =?iso-8859-1?Q?HRJAhqihuFTvJMpJdqqrJbqn539t9AVOI1YqAarPVyFQxvbWhlXnz8dy95?=
 =?iso-8859-1?Q?o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4845.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?QE3FsQOMtBJxIHZwzQwI/qCwAghAih+RLPBhIThqcXROVjTuJnMix5uFPL?=
 =?iso-8859-1?Q?J2GmaNM/mSlVE7FdWMVMbVVU4f0ElbaqmxN4IYoyxnxF6qUmY04wIH7/FN?=
 =?iso-8859-1?Q?GfjEb/rsDqyLLqDm9ryNm2a2ouvrw4fueuQj/Kk9ilylymjQFWpwJkhKTU?=
 =?iso-8859-1?Q?ZDcWqhuGpwHbYHRW2PyJQ9lxgZzPDVFbf/MKs3u8V+VulUJaGtcHfWkli5?=
 =?iso-8859-1?Q?xFTwjoaqimoTm1FIpXu07OvPK4zt2aMEcPGSxBNszAisiAmLFDXmqtyfLG?=
 =?iso-8859-1?Q?O9IFlYblR5UTxIILxrwsc56Aa794/+k3wQdfkzow6TaV22859muYyd3xIm?=
 =?iso-8859-1?Q?rQxBWh4WWLSC+EliXbc++yCs8X9JBwayWYmMn5KdxakQPit81jQG6xl8XM?=
 =?iso-8859-1?Q?it8b/t8N4iXOO+6nKhKY6dGvAGzUrU4rryrVHxHPM0qleWPoreqJLTQusB?=
 =?iso-8859-1?Q?kosFt90UhKDFe2AiHtq3UJm2/FvIG4R08JYtGP1vxI+KIki0xCXQlojFI9?=
 =?iso-8859-1?Q?6ty8mz38zwrK5yRz20QJ+aYmVfcKzDJQSKfkpvDu5AFdm87wlfxmool1O2?=
 =?iso-8859-1?Q?ZFcHpP/lWXXxDi5k0GQJTmcldR735ug75bcHPxDj8TqY06DUYmoKtw1F2W?=
 =?iso-8859-1?Q?F3xQJiWWq9GtLoH44Gp/9T273FOUAsOAa/RvcJk3EDjY6rRLJdQ8kBsh+I?=
 =?iso-8859-1?Q?TmNdgg/+KsaScQhCtD/vaYOjM6TZ2Qybj3ipcosEqTldpiuik+myVjAYZA?=
 =?iso-8859-1?Q?KfanPClxpuFist1hbNqZWCbeuktyJYbUl6naLH6FEUgqVt1TkU51a6jGfP?=
 =?iso-8859-1?Q?e0VyPCPUN3b9uY0pk59YnTj+dgygh/aYsxA5hK7PDs8xyXNgz93Jo9YeJG?=
 =?iso-8859-1?Q?uxqhFGIVOS0xPTOWltrHz1HUxCmBbZOOGK6BDUFVqFftbVkGB3O0U6WIff?=
 =?iso-8859-1?Q?+/0K/Ip1gr08ZBBh15aT+iubxQB4BKglzdMGyy5m1axZt2Sf3c1A99HCM8?=
 =?iso-8859-1?Q?5jbDaG218aUAImrCbDohfK9cV2sVooIwCv1kGTUFJGYU7hisdFP4q/+qm6?=
 =?iso-8859-1?Q?UZ/Fy5sS8GELiZ1lJLtPuGgaQ6kc5CbzRlhi3g3VAp7pmmG4MGijdGdnT6?=
 =?iso-8859-1?Q?OovDNfH1JiUQfz9eAE2KaJt9rjmmOS/u7s9URicENg9zcroR76/bCfMmsz?=
 =?iso-8859-1?Q?ae6rHGwAOWEoyn58DBg9xO4VLeqmSnh2BvGgsg4ab1Okh0eC7mEGWq/aio?=
 =?iso-8859-1?Q?mNHD95B/BZylaswfxX1GL3QYg3DYj2ehXujskb8P5Cim6A4fseQo9wYmY+?=
 =?iso-8859-1?Q?Q67o0uYjkSpaR6bWqCuH1odMk/BUF5XmBaiM2LCObi6orfytCZyhp1VjaL?=
 =?iso-8859-1?Q?HhnVVM995Ql0WbMLX830xojBLDA89iUDdicsLC/Gef+/WpFM+U90HWM84r?=
 =?iso-8859-1?Q?wC4BYs3nRk2QY906FBqDpkJnWhX9fHijhRTCWuhhlmuCFPUmBvZRCZUNxE?=
 =?iso-8859-1?Q?0CcdWJ1ekTWdx7wABZBNsuth37UT8rq4eDSHV11ARoqZq1MBN8nEGiKpSv?=
 =?iso-8859-1?Q?+v7tFIlMisgzwTRDb70SdTMg1l4dvokDMFYRrd01VOxK6R/r9w1OHp3dFd?=
 =?iso-8859-1?Q?us0tcCXbY4+mNVcifhW/qraYIychhyTER7Fdcsog5erGG0JagGFPLLjIiQ?=
 =?iso-8859-1?Q?zvv/Wo08BUw2jtQ9mX6v6z8NGY0FprEJlYFePVds?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f700b451-1a75-47de-410c-08dde49b0ca0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4845.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 12:21:14.0865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FR9UgXn7KpbjHS9NUdyI2KbLYWtwTUjNH+AeEMRUP/ogiWet0k0nlgYYhgATEzXmffiHOpybnsKG6+gdd55Dug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4632
X-OriginatorOrg: intel.com

Hi Greg,

could you please drop this patch from all the stable tree queues? I got
a review notification now for the 6.12 and 6.16 stable tree, but I also
see the patch in all the stable queues (5.4, 5.10, 5.15, 6.1, 6.6, 6.12,
6.16). The change would cause a regression which I described at

https://lore.kernel.org/all/aKwQfhfSu5aCUktw@ideak-desk
and
https://lore.kernel.org/stable/aGaiASySvb3BVXlM@ideak-desk

Thanks,
Imre

On Tue, Aug 26, 2025 at 01:09:37PM +0200, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Imre Deak <imre.deak@intel.com>
> 
> [ Upstream commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f ]
> 
> Reading DPCD registers has side-effects in general. In particular
> accessing registers outside of the link training register range
> (0x102-0x106, 0x202-0x207, 0x200c-0x200f, 0x2216) is explicitly
> forbidden by the DP v2.1 Standard, see
> 
> 3.6.5.1 DPTX AUX Transaction Handling Mandates
> 3.6.7.4 128b/132b DP Link Layer LTTPR Link Training Mandates
> 
> Based on my tests, accessing the DPCD_REV register during the link
> training of an UHBR TBT DP tunnel sink leads to link training failures.
> 
> Solve the above by using the DP_LANE0_1_STATUS (0x202) register for the
> DPCD register access quirk.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Acked-by: Jani Nikula <jani.nikula@intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> Link: https://lore.kernel.org/r/20250605082850.65136-2-imre.deak@intel.com
> [ DP_TRAINING_PATTERN_SET => DP_LANE0_1_STATUS ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/display/drm_dp_helper.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/gpu/drm/display/drm_dp_helper.c
> +++ b/drivers/gpu/drm/display/drm_dp_helper.c
> @@ -725,7 +725,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
>  	 * monitor doesn't power down exactly after the throw away read.
>  	 */
>  	if (!aux->is_remote) {
> -		ret = drm_dp_dpcd_probe(aux, DP_TRAINING_PATTERN_SET);
> +		ret = drm_dp_dpcd_probe(aux, DP_LANE0_1_STATUS);
>  		if (ret < 0)
>  			return ret;
>  	}
> 
> 
