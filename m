Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750C413DDAB
	for <patches@lists.linux.dev>; Fri, 17 May 2024 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715966966; cv=fail; b=qxDNjWrDMd7mGaGeXoClPNIvOZ5fOiVF8KBeXsdNg+3AlkMQvKdkkP16XOk9RYaU9c0p+9h9IUeZIWyzG+EKXf1JejkuHNshTkD0kjnXOMtYViQoMsQ/mCyu/R7DHH73QC9TgJOE5oSqgT6tM8GSF0ybYGTgdiITXdlm5+oHKLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715966966; c=relaxed/simple;
	bh=En7w5CCWTgGWBs1H4+YHGBka+W4bGBx1KJ9XTBAh19M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I2Pz56gAb0Pl6fXXguyx6CP75Y6HHfieuz+2YpWRkLdLxm00CoKAlYc4syZc4RXY19ergFdHonsaS5lHVaCGBQVruHYz9VV2YvDBHNpV5twZcEPlx7qdB82laCtuXEGtqFu3byQ6WBTYTurlSHyo4YJRqnKHVIMOU8oD8TjV6Us=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UAO+lUXj; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAO+lUXj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715966966; x=1747502966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=En7w5CCWTgGWBs1H4+YHGBka+W4bGBx1KJ9XTBAh19M=;
  b=UAO+lUXjNKPrCpxsMHYeiOTqqFDM1BxEB1XgSTw/BfOqynhYxWl40E5o
   cwtDX4fhh2dvMQxtGQkQjx0oX1WMCSHq3R03Hu3TnCZ+0m4dVLb8yUNZI
   0u/L4+FGuhUNxPBue9Grph8+oYNTqPZpag43t2C0BWds//uXZ+4cwVxuq
   TS0O5lguafQ6hQeNEsBc6B3fe+rm69OtQxDysZfCfmmcJ88cRCbChXtnJ
   g9PCeEhGNXruW5AtqRL0yNE6bX6t9iAeClxfgdaClk30tN5aXEXq9sV12
   ei8DspPC9qcb3ZBoex1THvAtPbBV40d2tGBjhmY7Bd+/v2PvoPqombL/z
   Q==;
X-CSE-ConnectionGUID: Vrx5uqbtR7KvX8jA7Oe5MQ==
X-CSE-MsgGUID: YLz0Jvw/TB6KsnzBwrCrug==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="15950993"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="15950993"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 10:29:25 -0700
X-CSE-ConnectionGUID: 0ykzVohqS/mYLs0ul1uXbg==
X-CSE-MsgGUID: 35tcEhLBRz2NVGt65q6LLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="36598835"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 10:29:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 10:29:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 10:29:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 10:29:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 10:29:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FP6y1fxNnPSEruidm6xh95bIDc/ksy5pH13vjS8KV/fbPeQ3q2nzNR9Hj7uuZd2qm2jivsKz/Q6AzFzcnREm1Ut8dr4Jmm1mFNg0xYfWZVKEolzxvpy9Qdget+Dh0nzWHDLHlu8g583cTfjbI9P81VV2x9yvFuevQyoG/I1qfLAtHna1knb2Lv64Mj4KV1VJFyLP1k07fX1UVT3RkYTdNkhWcLcs78SgzFfU070HCWSCO5nMP9A0DkPnIGiWiv5xdXDWe3NGVhPKWbzWFmVaxa7ZOUsABL6dL68F6A2R+3B8phKfC+TMNB0FweCx6q7/QjKR8AHOd5YF6dWSIB/WMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erke/nbmsPAMxnsGSdqkKcK2PwB5ZT1Sp2FJrYZBJh8=;
 b=MaLj0w6lHf/W37qEIm4NGS9ajT8pVbBNCtj01rJZQ5oRi9sLOrKvtmlvtLYtKRNCXkR1OWIoixu7+N5IRlGrBg1QBh0z0a3Cx2LD+ZOtXwz4a36jHdmRWNfTwJaAzWd4i/Jj7V+4MxV6TV0/7Ml6fQpzNr31vWzIs4N3A0bTX/z/srJAyMh8owopPVXu9H3ZX0cH/aUMr88CvpzBnKIwbLklYjnhYORH+uDus/6tJDTl9WTPZLgfAtKSomhCV7067y3ChL3pcI/fjqRFLjCLsewfc1iIKsTYP1hZIkIrwTn8vQ+PZwA7j/AOPVONnF/Qpq9hSHKYNO7XfeV6+9iVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 17:29:20 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 17:29:20 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
	<mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman
	<gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHaqH6zwUWGNcLDPEWX8DDSkF3v67GbrfGA
Date: Fri, 17 May 2024 17:29:20 +0000
Message-ID: <SJ1PR11MB60832232588EE1CEBE96F64CFCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240517172134.7255-1-tony.luck@intel.com>
In-Reply-To: <20240517172134.7255-1-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6932:EE_
x-ms-office365-filtering-correlation-id: 680fc200-7ed6-41c5-9f90-08dc7696e2cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?VKCP0DOaNKGD5Nr9e9mLj1KtM2t4Dj2chKPoMo1F0RD08/LwXjwuyM1k0ifV?=
 =?us-ascii?Q?U++QF9HmuTSeU6d4jFNWlIuYHvMK6DBUsAmWoNUeOxjGUPACUPLMCn2FDq3i?=
 =?us-ascii?Q?mgmeO6rFIzChKQJh7Yq3gNQAhDc56vXtfsyKDASsxTWVUsxhQcgjxEsZHRSi?=
 =?us-ascii?Q?ZPKps4tkGEII+NH5cZTdDCgOp95vA2iIgOk3qYHE/NKC6FeDw4tVk5JrIKLu?=
 =?us-ascii?Q?AwVA46Ozl02Rqs5fQ9RPzl0de3UcA8CRUKPmAbxP+B5xzcTNP3WrZU+wkE8e?=
 =?us-ascii?Q?9+LAoiwsdv2T3666geazHktJd7KuBILPLRlzEPPmHDp4UeEwihToujbATHxh?=
 =?us-ascii?Q?1dmsKN9sxWPeHOkmbZE4a2UPrX4ADsaWtH7U77EZ1DWjZSb3wgfKr3mKv8si?=
 =?us-ascii?Q?rjSbaJdGNn8bGx+FOr7HSywjcoLnFtOfclDptkH2WKq6AWWJhoKtFf3EvdME?=
 =?us-ascii?Q?vP8hotxAncebmdg5afTnAAywd+6Zv4fXX5+Dky19om7IolYrEdD/P9WtT6SY?=
 =?us-ascii?Q?9/Ppe11y2O60ZIzx/YQqFgu+L/g4t7NWezhRulkWpQ0KwJhj8sxFRtOzALpx?=
 =?us-ascii?Q?PkBgKYJYzrUjPTtwzKlXRM84fnhjwZtG0tS16v+pzSRXT5Iwn8B91f8cQJmr?=
 =?us-ascii?Q?px4DXDOqT931rr9kSBZebV+WNwTUVxoUrUFdpk3QQlU4SDDwhQ6zw5/dwBra?=
 =?us-ascii?Q?FHJlcOSDUTROLsSO4pEkV+WruSbS0K24Me/QXO3QZFA285CUeQ+cStxghySk?=
 =?us-ascii?Q?YglagnyuCltc3QbttEwrsA7xQji3X+BhVGMm8/OuwhXD3M7VhqvGHq6D/0Sb?=
 =?us-ascii?Q?D8Bo45/ER+x3MSjQZNZJyUW4Dd70+RTkJEsMD4G5vFuxVzGvPZKbBPvp94QV?=
 =?us-ascii?Q?87469ExjMhUJ8aq5NjUgvduDsXlGqBzLmOct6wSjBL+EaUq/0kP2QLTguRJZ?=
 =?us-ascii?Q?gHlYYI1TlQPlLOvkZxITMAxCmPJeEErhVUjpYqmEAud3qDY8BKeebJAUU72D?=
 =?us-ascii?Q?20cL13BjjscI4mxTa5SqCdAgvZeaBRdkjaxYn9PlPKeD6wRnaQRQsjWCJvVi?=
 =?us-ascii?Q?VFce/wnyD9ptBrBmmZatkWpASykxXeNsQfKBvjEVcV37qHIdG0H7Hb33teHy?=
 =?us-ascii?Q?9WozVP+/JJjXUmgWwBjzrlG4da4h9TkYBTTpps0J6KAKnJUGaOdiNo3nNczO?=
 =?us-ascii?Q?bdmrsGpiR0Xj+uMxFxztfgSPoWsouWNs17EV3OYp8ehOrKI9mj00Qomilp8t?=
 =?us-ascii?Q?IMYzc9Go12Xs6+QQLUqRcqnHcAixH4UsmGuTZQSIVVpFS7BD6QVvvyxv7dBZ?=
 =?us-ascii?Q?r83fdwAxvAnOMVCt2xpcHbrSuDmLVPCK0kOp++YCXjaTtg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XpBqJtbtaQP/7TfCRN0IOQH8nFAicyvPAZFCnWYx5duiHmfe8HEzr7SUJ1N3?=
 =?us-ascii?Q?lfP4ePbC23D1LbqqV8oH5aIsKb09TPZrB9fvIi6LPX0fWbE8I9OMGYJ49jGT?=
 =?us-ascii?Q?m48paXkYm551CzG9/KlTPY7LWejmnJMlA37JFTQHJqHAA5eCq4CUjY/R9XbQ?=
 =?us-ascii?Q?uIoK/ad2cjm/8RNT1xTkNMHbzNHpkAgkTEwXe7/I5K/nX3PyeLwqwcIHDTai?=
 =?us-ascii?Q?qAYayloqwwC6IZbIa9Wl0ruf2xfKk5oHe5vpeEoNtPIcDMxmkG9G+wXbvPoR?=
 =?us-ascii?Q?JIG4IwJq9LiID6w/Qm1d2SiWb9C5R0V3xD2ba4M8pIhC36GctxMwU3cQx/md?=
 =?us-ascii?Q?WmNy1tlmYhcaa7vG4uBJOe2XXTGHNPWgtn98I03KJXH4KV6kpZLDWWslCIOw?=
 =?us-ascii?Q?dIR6QaBtVhujarbqyQGSyyWB4EI8ifrYdS2ErFQ5OtPBxBdOWw5nM+ST1MUK?=
 =?us-ascii?Q?RRLRMPwfN8WeTxJ+UH1o+gnvbPw38Fq+BF+gUorUhrQDwUOWtYGVjivw6Nmh?=
 =?us-ascii?Q?ePLOa3xntkRATgTK+LDAQV/96dXeX+Xui5toaiaPhwW1AcNnvFMGLSmqhyxU?=
 =?us-ascii?Q?gy8Gz6pKCrwdBaiMhZqJS198tC5tOp3aF1qyDvB6dflmvwXf6cZWnKcC/mj3?=
 =?us-ascii?Q?uQvZDyvF6wqWKP1dFdT65CS2AocVRlIHGBncfuJ7ZIAXdJYOaaJ7guQ4+uN9?=
 =?us-ascii?Q?KQWQ5jo0SYWbTIRxjf63IdmJgYsKnYif/ESu7t8wrIvaJlRLgikl3L0ConKH?=
 =?us-ascii?Q?fFPx5g+6KvzdxY3iUIeD1+NA0SO+Wyns9zOG+JCczYes8JS3XqQAGmlcyNuA?=
 =?us-ascii?Q?SEEV3SDWiVq3Z96zsyLwGMvMcDwdbXzGLt4FighHgmrq82qhb6WJ0e3ODgVs?=
 =?us-ascii?Q?gpWg+Uo1UQ92+j7+7e7xZIWJGXnXfgdLspMr9xpevr1RbYHwqXFHcnB4P1p3?=
 =?us-ascii?Q?fJ6sFQ30uAstOWkHvujIR/Vn44u3vmSZ3MeqW08T0pNw6NPH3P3hklDj8q8V?=
 =?us-ascii?Q?MgXGEQyIOCR6H1pK5dZztMe7ZTMFxavYZ2FNfXr9xrl8+LgIwbiNiVg3sm1/?=
 =?us-ascii?Q?brgF7L4BHp26vpuFg49/VY28OLd74No5zWyKYtibKa4ivLburJ58g2FkfYiU?=
 =?us-ascii?Q?ghN3u0HnBd9EKiCLdlUjlkPMMYkOdlknd0Wzo/6VOeM7r0FSIbI2ha+vgXYF?=
 =?us-ascii?Q?WF3WUuzdb+lq0HaM+OHwUJIqkzbvlF0CbQzsO2pxAYtQga91/cgStIUDpl6Y?=
 =?us-ascii?Q?rA7P4lmjMaVdAeNn74MpuOyE7+x+SGOxGJBAPtKKR333C8VxWvl6qbYTaT8u?=
 =?us-ascii?Q?JPpW4rztv2DqzVttV4qO/srEnMfppbhDFVZhpbiGBPSu51ZfbnnGk2iOKxPd?=
 =?us-ascii?Q?tSkXIEQ8fekE0F473E/hnQiwOk8jnbWELRiG7o43K/kPFHvaF1jHExIlKUa4?=
 =?us-ascii?Q?22A7JLYe7GQCCawkOKH8qFFWwryvzQqQ6M98zUdUt3WYhDnvwiFS/8EihEeB?=
 =?us-ascii?Q?N7pnYBIgSmayR4uwnD+zgRit72+0hy/6z4Y4sH6SbGDqdiLdjMeb75PPhk8K?=
 =?us-ascii?Q?hoh/azu9M+SGP/2t20aYIJWBSMAFgFF3A2qDnZ+P?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 680fc200-7ed6-41c5-9f90-08dc7696e2cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 17:29:20.1409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7U53yeH/M9k+oGCCZp9dMtOnBn2JJnjHrxMGOyQEH+7vFwZiAAJWJQlF2IDsjQlUTKKQ6xukQ0gAR5CkdZFk5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6932
X-OriginatorOrg: intel.com

> Changes since v1:
> 1) More detailed commit description.
> 2) Changed "Fixes" tag. Commit 4db64279bc2b merely revealed a twelve
>    year old gap in the implementation of x86_match_cpu().

Changes since v2:
Use fix suggested by Thomas & Boris that doesn't risk breakage from
changing the value of X86_VENDOR_INTEL #define.

-Tony
