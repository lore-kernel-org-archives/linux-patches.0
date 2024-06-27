Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F362B1A2FCE
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 23:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719531187; cv=fail; b=mAaTMZvWQA1DrYFfG5xxt5cIc+ImPqPQp2sOC1qbv7Txlt0yJyvlKCEVt7caFWQefOETZQHwTctrhy/TQaj4katSEsPnTIRAM/9NwV39nSpPZikvspUHQu+6gLk0fyIfqWq5dqZab5N1X/HoEJN0aJ6alSWNM3Se4XVr4Ua+2nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719531187; c=relaxed/simple;
	bh=zT3YRSMD4R0BRXBDiiXkzLgqLflK4oBMz3Qg4cZkjx0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S039Qvq5X4PxYRqywz5I0Oqp0ZI3h/X/Z7JU3YSiKJPLIb181LDRrGnN/BxlGsnNu1ZNsbWzTKRXJT8ORC6ZZsu4Wx58YTr1ud5O+C/qrVfe8JJHp1DF+6jwa43ukz8oaWvmBUzyTaDwy6W4i1l/+Hs05x1miWyLThuglgV9gr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uvk1TzEp; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uvk1TzEp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719531186; x=1751067186;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=zT3YRSMD4R0BRXBDiiXkzLgqLflK4oBMz3Qg4cZkjx0=;
  b=Uvk1TzEpLhJDRQXluTtlVazFqkQXiBgpvfnCRZ2XQDUuFEo82VDd1VLM
   FSCD6aFmf0R5s/AJoK1sfHyDcyi3t9QTO7hL4be6n+FCXMQ3uBTBTcSuT
   6j/KPMgwexhk8a84w0++zT2k93OoUKR1CRGnzzPTicpVDm7u0lfjJYqHY
   m4PLYBB5pKKJi2CqXytI9u4JibkdBbLK0y0/5CcmQ8kzPXiDkO4IRYgTR
   Vky+5Zik8Z8wxVRxkiKHAR4FL9tg3yw7jCC4Xl1cZ29iNWHbZiIPudxy4
   1Ak5wsoSBkMfaA9RWyE8kSdHZDWBtkBNBPIyCp1Bi1cj/3noFlVRcTfcB
   g==;
X-CSE-ConnectionGUID: WUE3Sk6nRv+w7jwHv4HMQw==
X-CSE-MsgGUID: IUx45xIgSUWOuBys4CmsMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16517818"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16517818"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 16:32:49 -0700
X-CSE-ConnectionGUID: y3cE/KtkQ8+S2LpAXuzOlA==
X-CSE-MsgGUID: hPToxf41TdGkGTtTDos1Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="44465049"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Jun 2024 16:32:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 16:32:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 16:32:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 27 Jun 2024 16:32:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 27 Jun 2024 16:32:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNWMyYRcImjWFAGUaGJ7xTsErIulYMbUqb6nHL9Z0Bgc6iDd+I1chGU6Mibpt0YllSF9OZdQzqO8+kVmBBqKsP3S4UG7vgTCRnAHWL3n6N4P0iSGyTv9NbpQwiq8eMZkYzT+nanOCMdb70Yn3pD55fBtzmuKElhD9fdXSWgRo0uQilrYrjneYVUTaSWqtdOGJ2uksTUr//T54l7FX3ANBVRL+dibtVLoa7l/vheq6sI81lTIwCN7jzimLM0WGQ/2xgWtQbEjZnjko/V3Bj5cDy2Xx5pbbJRrIgVj4NzySpcZtUE0Q2sWD0MmTa5LEWQYFne9i0UBg1hvx7qxO2eDwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAH/IIMVuk/SU5/NFYRO6mq5f1yVSXVJE1NzKqnB/pg=;
 b=EMwBHKelTu9CZvfi17O/wzV9sXu5nu2iG5uveSvZqgJ6w9AvcC9H8aTcAdqG4rxIiiTLcRZKY1xfIantyFfvw84zRPna4AoUkpb/oph3WbIjLHmhM3TkqISr09PVszWOg2YTFY+DkbP49tbYGGtPDtRRrJgMASPaUs40SSfx9Ku32SWpueO2dISPN7C9wgSYb4Oq1sWuJmc1CM6vBNmicUVWHqy7CfLpmGqex/I/phAV6V+PLcJiD9F6a+2HocKj4nx+SbBRZYNzMClqVJQz6YDWea5kCKpNE26HwbaM1IeofHOxb7yPrsto3bD7+2SzCFpJoKt0t6Xygtyk5VBIYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by PH7PR11MB6651.namprd11.prod.outlook.com (2603:10b6:510:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Thu, 27 Jun
 2024 23:32:39 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44%7]) with mapi id 15.20.7698.025; Thu, 27 Jun 2024
 23:32:39 +0000
Date: Thu, 27 Jun 2024 18:32:37 -0500
From: Lucas De Marchi <lucas.demarchi@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Rodrigo Vivi <rodrigo.vivi@intel.com>, Jani Nikula
	<jani.nikula@intel.com>, Dave Airlie <airlied@gmail.com>, "Vetter, Daniel"
	<daniel.vetter@intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	<tursulin@ursulin.net>, Francois Dugast <francois.dugast@intel.com>,
	<stable@vger.kernel.org>, <patches@lists.linux.dev>, Matthew Brost
	<matthew.brost@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Message-ID: <wouigp72ijw5yoc534fg6zdgniyzw4ph54z5c75geizsyj67ud@tmvbqkflcbsf>
References: <20240619125609.836313103@linuxfoundation.org>
 <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk>
 <2024061946-salvaging-tying-a320@gregkh>
 <ZnqyFRf9zPa4kfwL@intel.com>
 <2024062502-corporate-manned-1201@gregkh>
 <87ed8ldwjv.fsf@intel.com>
 <2024062537-panorama-sled-3025@gregkh>
 <ZnsUKiEiZEACancl@intel.com>
 <2024062517-elderly-rocky-cb20@gregkh>
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2024062517-elderly-rocky-cb20@gregkh>
X-ClientProxiedBy: MW4PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:303:b6::17) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|PH7PR11MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: ee813fe8-b585-4352-1d83-08dc97016f34
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|27256017;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?3+HsJhcAkmIqxmJ0Pewr/EWakKb6W4S2FgAcbS/lXfsInxgnqpHwa/orHM?=
 =?iso-8859-1?Q?RJpqi5zdg69yf7GMhav/zUgEcpq1enNZNHPNYOb7MKRzgNUzHSJltiPWsF?=
 =?iso-8859-1?Q?ESmug20T9zc/FjG67wDRAy2huC6M70O+NNQdg6twY3iO2nmMGtoeb1VQ0c?=
 =?iso-8859-1?Q?695gfgcDMqPmYLW7rMyWcQVR/2pqC/jcJ0xCFgs3fl4CY7apVhkrumsCY3?=
 =?iso-8859-1?Q?SjPpGvMVRAA+a5p9OxtgLdD9Cp7tfY9VDEzw8leQJSL6KBi1lON2BXR/vn?=
 =?iso-8859-1?Q?b8g0xLQxOPQXkYEEU8sjLSgUcD8igrdTdCuBuUGcGv8B3lLO2CYH3hZaV0?=
 =?iso-8859-1?Q?AaHzvKgmx4LLrvXIjeI0nj6RbtPpDw78U72WR8psa3ECqYCDxkuTX8oW3o?=
 =?iso-8859-1?Q?EIfPeBi2Rq5dlKXNyYOY12pG2w5rBlwswLN1ObfHHsycLl8l02oewY5QKo?=
 =?iso-8859-1?Q?wXblGeo9hLL2jAEQyVb0bq2Hsc4KJR71tLdaH2qbAejy3ApT3Dz9RRKbH1?=
 =?iso-8859-1?Q?UYUUeIAiRuqOorPkJaOg1gmqTW9xdai14PynEXzrJ6/5GS/KuBHXXtmtgp?=
 =?iso-8859-1?Q?lVc9sFERvjM1YtSVJOvB9GgCOOOq3f1CZ4IffvHqxO8c1lzGTlxspiEkgV?=
 =?iso-8859-1?Q?9AdRBIQpQtQFbvvQT/i2D8TVOqSNnWDSP3RUsprS0yaX9yuoTSO3mhyy+i?=
 =?iso-8859-1?Q?BOGeJOc4nI6LiHOf3/N6Dsdbc8Y49gFBMQpZzfH18EJ3fDxEydpCeMxUyh?=
 =?iso-8859-1?Q?pmvLv1yylLshG7c6jdZInZi5hPJ6FSWTuZeZ1Ond01ky9cYl+qqm9PRM1Q?=
 =?iso-8859-1?Q?xn/qCjmcy4TX3z/xqQkdqpBe8Z60hWty4//pvZBJSjYBw1ZEGCmxX2df+C?=
 =?iso-8859-1?Q?1trYAWJlgzM8W9AJgBPAFjLmxYLkFspieXDiiF097nY46DE6Ct3OZQQett?=
 =?iso-8859-1?Q?CTRh7Kt4C4v2rcZHeVJLNn4EYkSfuoTUNyn9CRt67q/UOVgJlqKp8Uor2w?=
 =?iso-8859-1?Q?0UQrYP/iGibOc2Cp88XotWZtGeM+3ORdesVnnBusc5WziIspbj/gtU+7fO?=
 =?iso-8859-1?Q?7xezfAxxgwfeNLM8YwNX/EBKDVwic8PixFFtqQDvBnUx7GrNYQ8vHGoywI?=
 =?iso-8859-1?Q?55rHntqYV9B3NOg7iXXYcax4uw2Nto3k7VIDJxRITEwGBbpzTbh6vLX3qK?=
 =?iso-8859-1?Q?B4GZZy/Mv2wDSEX3p7dB18kmjbGGMWC5X8F21KT80oE7ZP8jzF6EimeR2B?=
 =?iso-8859-1?Q?ieDNcPBwDoJ9gEvpgfOotU/E612hLpvefElndS5e+8n3JLKodfqjz+9noO?=
 =?iso-8859-1?Q?ueYP9UahBeAyZmCl7+aKyAPJn/MzUx/p1NoOLSEZGEqItzfT7drmJIJJwV?=
 =?iso-8859-1?Q?7bYvyRyCq6icEmlJfNKkNe8WufWCW9x+iO+PbrXrGYi9ngildsl8HYYGI6?=
 =?iso-8859-1?Q?GZLpvF8Q6tP1NX50niLBEH4HQF3w2yyrPzzTiw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?zAvTYTfxetY3+H9LRan8IGELDWWiDZpAZnm2cAgRuI53nJMk/Rgc9LQd25?=
 =?iso-8859-1?Q?Th4FCJREPI6P0+SdXUChNHGowV2kNwadZtIAZc+B6mO9Brxis6LmhkN7TY?=
 =?iso-8859-1?Q?9cnGKV+egudFqNBXevZaYOE6oI0F4DEOeY0cAlAEI0tLpkpJPHIaUT9y0M?=
 =?iso-8859-1?Q?gkaGYMfcJkOwMwClBKBIX244QrfgDyfV78bbFPXYvexKgmce91Cz9ViCsA?=
 =?iso-8859-1?Q?tKBrHTWWq6x2Vbyp7D3QuKQcgAjhWcYex29/cWaApHXip2nj4yu9u3rFAf?=
 =?iso-8859-1?Q?TQ6n/5Ex2JKaqIL7t6nqABTzkjAdafTkJ6wj2adivCTZUqvIrar7pmXLFb?=
 =?iso-8859-1?Q?Wr0C8475gX1Moxsi+IgomhBdon6/xp/u8W5tfr76w7qBBuGH3mhAg1Hm0s?=
 =?iso-8859-1?Q?Br2KyOKwMAoE152IFWvOSN+sIfJvKOhMmOmR68DToFnd4AE3JEUAWC7qJ6?=
 =?iso-8859-1?Q?Y02jeZjhmtJEYHuOuobfM2Hp4fCNN7SZGnGMT3y3IQsUancJJW3SENNJzE?=
 =?iso-8859-1?Q?u3o+BDACxsLCeWjAr9jvKt43Pd2sKHNaJmQ0MqPqXOjAx8QKmgEnOdWznr?=
 =?iso-8859-1?Q?3ORxdMIZ6ZrF6ZxPOhr2HYsHzzVM4Qoost8RbE8KNjpGfWxuWW8a2cRnjN?=
 =?iso-8859-1?Q?FindKOtnbnhGWXYAsuRshcmI3WkrnaYLFgKRW6y2hZfrvYVGZbr1Rzk5Gw?=
 =?iso-8859-1?Q?+/AyOM/wi4tWnRvXp25jZkAf18NyP8Tp4CKhTUwtPhXitH1mr6/pZgU3or?=
 =?iso-8859-1?Q?63xOSkuVLtjHtBrxLRdUJVWHrj8DQNN8bXJl0u2xkj7+/7HYkUNAyoFSeW?=
 =?iso-8859-1?Q?iDnjHtcwT1lRaWWbBLjpp4Hy4FpuysAktskJzdzGIIZE+9K6JBxH2L1Igb?=
 =?iso-8859-1?Q?OBTEdb5nRY3m5CvJpiFmqaa8f4WbEJ6tF3TUcCBBbkcTabxwyB2WFufYZx?=
 =?iso-8859-1?Q?16ALzhArhW4SPJNILajLRswZAnYBIpmmAI75+sZl11EU/VOLPJI1fkrlwo?=
 =?iso-8859-1?Q?WlS3XCZZiCzE70HhGmpi5lDuJoOCNeriXum0AxWxWVdSSm0gA3hbbVbCty?=
 =?iso-8859-1?Q?DsrC8ioRPH43ewAOsrttK1YEQ2xagPaqvpfJxgeGHP30ivsuno+mJs3o4D?=
 =?iso-8859-1?Q?doLrVislhRLtBzIoZsAoziK7cJ+MDngoV+lkwHiRYud8G6WuYhCUPSz0n1?=
 =?iso-8859-1?Q?sWFu8h2ys8PumNuB78Q4PKndk4sksJ7zug7VkjSrnHM6uCsmROtxp5l32r?=
 =?iso-8859-1?Q?WGu/H1rdW+BT9Ky812MpumgiQzsuqoTb0P4cN00QwMLhMrPp7he8clXKOT?=
 =?iso-8859-1?Q?nn7QSm6eQ5c03C0F8vgPv+CYvWMwdTPkKQL7GRke+xqOnqf0ZQoJxdVECO?=
 =?iso-8859-1?Q?2kMJm+QKYsLke7F5u5eK4I9oFv8NUz9owYoL/3fUerxo1r0rl4ytlJDh1G?=
 =?iso-8859-1?Q?XQRvUw7ZISqyw3sl7NUR7uJfVRMCjkI5JTnLFiRdFrA4nNVj1kr6dKHUCp?=
 =?iso-8859-1?Q?CUjogxkHmkS6dZ22+6tlONBjLflffNUXFP+pUgVd/d3E8EPjDz7PduvDFR?=
 =?iso-8859-1?Q?uU+qoQxhBZZbFJXVogdawtGJ5LYQMCm/S9OXAGZLHUoOKqfNIgWeyoeshr?=
 =?iso-8859-1?Q?hy0BRn5nllAv3S2ITEo1YsbPvKrQ+5BzEUOffZtRRXwuIW5eSZ0u6O8A?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee813fe8-b585-4352-1d83-08dc97016f34
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 23:32:39.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LMKPqC7Npg1Lc4l0tcpYhwHd1H4w63oylrU54iIF5Sr+ZoQmHzbcIrMXWaoQ0bMObKxRJEC9Rw1/roVrr26WIUOMFK31GoKXvS1Lf4s1FU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6651
X-OriginatorOrg: intel.com

On Tue, Jun 25, 2024 at 10:12:05PM GMT, Greg Kroah-Hartman wrote:
>On Tue, Jun 25, 2024 at 03:02:02PM -0400, Rodrigo Vivi wrote:
>> > > >> >
>> > > >> > > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
>> > > >> >
>> > > >> > Would help out here, but it doesn't.
>> > > >>
>> > > >> I wonder if there would be a way of automate this on stable scripts
>> > > >> to avoid attempting a cherry pick that is already there.
>> > > >
>> > > > Please tell me how to do so.
>> > > >
>> > > >> But I do understand that any change like this would cause a 'latency'
>> > > >> on the scripts and slow down everything.
>> > > >
>> > > > Depends, I already put a huge latency on drm stable patches because of
>> > > > this mess.  And I see few, if any, actual backports for when I report
>> > > > FAILED stable patches, so what is going to get slower than it currently
>> > > > is?
>>
>> My thought was on the stable scripts doing something like that.
>>
>> For each candidate commit, check if it has the tag line
>> (cherry picked from commit <original-hash>)
>
>Right there, that fails with how the drm tree works.  So you are going
>to have to come up with something else for how to check this.  Or fix
>your process to make this work.
>
>Look at the commits tagged for stable in the -rc1 merge window.  They
>don't have the "cherry picked" wording as they were not cherry picked!
>They were the "originals" that were cherry picked from.
>
>> if so, then something like:
>>  if git rev-parse --quiet --verify <original-hash> || \
>>     git log --grep="cherry picked from commit <original-hash> -E --oneline >/dev/null; then
>>             echo "One version of this patch is already in tree. Skipping..."
>> 	    # send-email?!
>>         else
>>             #attempt to apply the candidate commit...
>>
>> > > > Normally you all tag these cherry-picks as such.  You didn't do that
>> > > > here or either place, so there was no way for anyone to know.  Please
>> > > > fix that.
>>
>> I'm afraid this is not accurate. Our tooling is taking care of that for us.
>
>Then your tooling needs to be fixed.
>
>> > > To be fair, this one seems to have been an accident. The same commit was
>> > > cherry-picked to *two* different branches by two different people
>> > > [1][2], and this is something we try not to do. Any cherry-picks should
>> > > go to one tree only, it's checked by our scripts, but it's not race free
>> > > when two people are doing this roughly at the same time.
>>
>> Also I don't believe there's anything wrong here. It was a coincidence on
>> the timing, but one is
>> drm-xe-next-fixes-2024-05-09-1
>> and the other
>> drm-xe-fixes-2024-05-09
>>
>> both maintained by different people at that time.
>>
>> >
>> > any cherry-pick SHOULD have the git id referenced when they are
>> > cherry-picked, that's what the id is there for.  Please always do that.
>>
>> Original commit hash is 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de
>> 50aec9665e0b ("drm/xe: Use ordered WQ for G2H handler")
>
>And that's not in Linus's tree.
>
>> drm-xe-next-fixes-2024-05-09-1
>> has commit 2d9c72f676e6 ("drm/xe: Use ordered WQ for G2H handler")
>> which contains:
>> (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
>> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>>
>> drm-xe-fixes-2024-05-09
>> has commit c002bfe644a2 ("drm/xe: Use ordered WQ for G2H handler")
>> which contains:
>> (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
>> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
>
>Ok, but again, the original is not in Linus's tree.

current workflow is:

All patches go to drm-xe-next which may be targeting the next kernel
release or the next->next. Then the fixes (and less frequently, other
commits which are not important here) are cherry-picked by maintainers
to the current or next kernel release. In other words, the cherry-pick
always targets a version 1 less than the original patch.

couple of issues I see:

1) original commit not being in Linus's tree

If you are traversing the branch and you have a "Fixes: XXXX" where XXXX
is from a previous release, you will most likely see the "cherry picked
from <original>" *before* the <original> commit showing up in that tree.

Examples looking at the most recent fixes in Linus's tree with

	$ git rev-parse origin/master
	6d6444ba82053c716fb5ac83346202659023044e

	$ git log --format="%h %s%n%(trailers)" -n3 --grep "^Fixes:" \
		6d6444ba82053c716fb5ac83346202659023044e \
		-- drivers/gpu/drm/xe

d21d44dbdde8 in v6.10-rc5, fixes aef4eb7c7dec from v6.9
but f0ccd2d805e55e12b430d5d6b9acd9f891af455e is not in any tag.

2470b141bfae in v6.10-rc4, fixes 975e4a3795d4 from v6.8
but 6800e63cf97bae62bca56d8e691544540d945f53 is not in any tag.

cd554e1e118a in v6.10-rc4, fixes 0698ff57bf32 from v6.10-rc3
but b321cb83a375bcc18cd0a4b62bdeaf6905cca769 is not in any tag.

Without a change in the workflow, I don't think you can rely on the
original commit hash being present in Linus's tree, unless you wait one
entire kernel release cycle.

2) Duplicate commits with "cherry picked from ... "

This only happened because it was cherry-picked in 2 branches, both for
current and for next kernel releases. This can only happen during the
last rcN as drm-xe-next-fixes is only used there. 

I think (2) is easier to fix: we should really add more checks in dim
to avoid that:  if a commit is a candidate to drm-xe-fixes it should
never be a candidate to drm-xe-next-fixes.

As for (1), I don't see how it could be fixed without a workflow change.
That would require committers to add the commits to the right branch
rather than relying on maintainers to cherry-pick them to the -fixes
branch after they are merged in drm-xe-next.  What dim could do is to
automate that for the committer and figure out the branch by itself
based on the 2 commit hashes.

For all the above I used drm-xe-* as example, but it applies to
drm-intel-* too.

Without the fix to (2) and workflow change from (1), this situation can be
avoided from the -stable scripts by checking if the commit or any
cherry-pick thereof is already in the stable tree:

	git merge-base --is-ancestor $original_commit HEAD
	git log -n1 --grep "^(cherry picked from commit $original_commit)"

the second search is very expensive though.... probably need to find a
way to limit the search space.

Lucas De Marchi

>
>So how am I do know that the cherry picked line was already in the tree?
>Added it twice is odd, but really, that's not the common failure here at
>all.  The real problem is the -rc1 window where there is NOT a commit id
>that can be matched up with (as it happening with a few commits here,
>and with lots of AMD patches now.)
>
>thanks,
>
>greg k-h
