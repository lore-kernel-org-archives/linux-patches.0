Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66C72FF644
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763398342; cv=fail; b=SSOpT885OMl30cSKyzu2zmDy86TZ29drDlKhsJO/actr1p5qXr9xwesn4jrJX12xYhaWjBiQkWkCQMLSTx1vBS9/fA19ZkeKoRGW2EWX13dfY/lDwsdCnpLhredSS2GgBwtFnUR3y54uSvzhi7y+uy6imFuV6E0jyYfd2OguSmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763398342; c=relaxed/simple;
	bh=DhdGX672+ROiRtUdq5DHcncTEEvcD6C8mxjjSVvQNrc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pn/5RP2YLFBfgfG3HNgjZqHnUokbAewJOchAEg9tYvK3DGe99xLUpasb+BENae3w6UWkZHS2anK1siSoeU9mD+/nQlpuAINnhhEtLLTvEfRfhDGZZsj+xH5grM7qlShvOXMQ4YsAWFusg23x5BpoJSdyf6rVLE4JNtsL+VeMqxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e7pD5sva; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e7pD5sva"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763398340; x=1794934340;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DhdGX672+ROiRtUdq5DHcncTEEvcD6C8mxjjSVvQNrc=;
  b=e7pD5svaqaH73No/nfL2YZmhYrvNkxsyWUsp3yokHw0sMohmPI3WM0Nu
   CzwgWMEFMPWP7LRsyTBQxJPBCeBbVXW5zR7N7f4yh5fh+LM4meH8V12Bc
   NTOzeV46UhgqgV+YoenBBYRWtUTl9Xp7AlRxfmgu9X2J7lUjXjmWJg7pL
   37gNQRlQyXJgG2naaM2M/+D7h2tNzJKbQOS8xz9d5nLJOHlZ+NMkA+Qa/
   Hl7CfOz/DVGOtSwMOZd92BejvUSNqFTzx7cyHpKopvBdtSOq/QHbBS0TX
   zIJ4Se77/k1jIoFlvvlVG5mBDe95WDKnRTHINjpAVnhSerRqpIVH4M8aO
   w==;
X-CSE-ConnectionGUID: ATQxw/rsQFCFPPeBhetS1w==
X-CSE-MsgGUID: io28M3pvRIKJhegIETSmwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65336761"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="65336761"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 08:52:19 -0800
X-CSE-ConnectionGUID: Zok9SP0HReqGbGeXkUyjww==
X-CSE-MsgGUID: 1MZ0wUp2QHO5Sd22Ku/N2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="190301380"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 08:52:18 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 08:52:18 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 08:52:18 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.22) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 08:52:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qYI/gijQ/vu/9ncFM5ATW2g2MT9vhFigUUnP6cLpQUUTnc2gkD2S3a2rZLcqcqjhXqjUJrbSsdSaAARmoZKf4nc/bwK55lPzeapwIoQAJqMA3nB6YvxD7ux1cG8wUlJOCHe005fLTd0NUz6j1HYMsCj+wNDyVstxqum5o0Znnb8NfG2LEJIAOEmcNeSgns7S/8jnQ5ACrE6g9RtBR7uJ9moDRSUPiDXthGRjr0uaXhvIR7JLg1CVnC0CiogFZ07UG+60xFm38dMduafFiUBRNokY1YU9LsB0XwJBuPaW/JPZjXp/tkR9qocPQ/IjjhF5cvdwRdWzTNF3m29Mhc9S1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhdGX672+ROiRtUdq5DHcncTEEvcD6C8mxjjSVvQNrc=;
 b=TPV4CK/JGPfW/Sq7DT9LoaJZAz4oh8rIlvFWToc+IC8D/Rom/l2+a7Q4wkVzjJeG0yYPDy47xPj2uzpmr2pjhm2iFER+qrtfdb0NaZa/CRTFvuRistuXnr1Imr8NAKEShY3qnGEMqD2Ex9DNRN7RRWFWdXRBxQFE0CWQwxVsII9gPXPb5cz06LCtbFCPGw/oD1dh4aGolB0if7LenVRJXQgJ1En9p2LsrO/oyD4ueftSSxVJK12XfwW3dOFwr+ZeWsb6W5XS8ngfh4PwEUYYFWig5a6GNQXcDxLx4ebzpZWa09jeV8eGNCLnuU5ofL5gWeHmM6PADeU1GQB3+ZLlvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB8829.namprd11.prod.outlook.com (2603:10b6:208:59b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 16:52:09 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 16:52:09 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Drew Fustini <pdp7pdp7@gmail.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Topic: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Index: AQHcSPAYySEZmJcLb0uXaCTwnPhdjbT1rNKAgAGE+WA=
Date: Mon, 17 Nov 2025 16:52:09 +0000
Message-ID: <SJ1PR11MB6083B1C8D6D9EF5B44AFE2DCFCC9A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251029162118.40604-1-tony.luck@intel.com> <aRoLSz6or2UK4tDu@x1>
In-Reply-To: <aRoLSz6or2UK4tDu@x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA1PR11MB8829:EE_
x-ms-office365-filtering-correlation-id: 436cba2b-60f8-4a4c-6fbd-08de25f9a615
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?oAv0xUnOuX5cmbYeUU6VU4a1O/DM4XK3akYHPa0/sBqBo3tmdclnSP94FGCi?=
 =?us-ascii?Q?kIz4XctobpJK2mTtZLIeNqyoeaH44O1SlHIiZKXcZ8nEPO3mEzx15C9jRPnu?=
 =?us-ascii?Q?YrgU83TFtw8VcZ/DFR8RZ9UYrv4jNavDwwYDrtxDrRWdYHGsJl/rKRq8nWZs?=
 =?us-ascii?Q?lDQMSr8+XlbyLjW760OVI4FW5WP/VRRZ/ryTZ4M6gyLiSbsilrbHTEUELi2K?=
 =?us-ascii?Q?5k37UEcDWV+OqLbV75Z20wlBPXISsApZFCe27jToFUnR6wkkB76l5rrfxCUC?=
 =?us-ascii?Q?o69W2Ty6Fa5ET/bkoyFM49LB6cODJO0WACUiXJ3iCmqnGa/G6F+84A8dXMaT?=
 =?us-ascii?Q?NY7GrfYBZXeGuJu2EVyOXjUcjncs7iT8DBnbh/1ZnslOfXGvxgxc1jx2Ocuy?=
 =?us-ascii?Q?5ZIsRhQhaDd7sxNeKX+lkJSF+MaETCiVuda5/fMCz28UIKcarLTytU5UEUsK?=
 =?us-ascii?Q?CBh1d7E/k8yEv6HInVc+JS/O/n9oO1r0twBBqPR/jjuLC/MicSZjyzX8eO2i?=
 =?us-ascii?Q?M7Y8MRMoNdu92DxMD8So3JT9OhnV7SF86V/FoXFOnQIkG/Eyf/v9z696cVxD?=
 =?us-ascii?Q?NcaIdFeFpyYi6AwhFjPnMnujFotgfRjFqk9g/8PvyUXUv7HXuNvsXcySVdtl?=
 =?us-ascii?Q?LGN8qcNirTmOklhH+wC4YVtXJD9PqCljRoFCM2Zbqnus6nYxDQNM5zwpxHcC?=
 =?us-ascii?Q?G5AHyPwK/DqhjQ9Bt4+/fWWklOi0AnoHlI13uRaTopI2L7npAMX5NuEljj53?=
 =?us-ascii?Q?/Ks4k8zDibhjF3NhamA6GdRHnlDgwFjXZ7mRwjb/slgjcgswD1cZ4Tawy7H/?=
 =?us-ascii?Q?8XNR4SbNGFG7f0UkX/7inMfXrOqsNtVRVVxuMb4pNgaOZfoKKGdDn3nXcHTO?=
 =?us-ascii?Q?b7/0lYWvWWZk6yniusK6rI5d9T3ykbWFOveOQJ0zwDwLGgYd2AU11ZtU1Mc3?=
 =?us-ascii?Q?SLCO3/Hll7MP65OIOBqTM+BpalInc+He77M7z3Xah8Gz0/Ig7t0mGnlT82dN?=
 =?us-ascii?Q?yChyuYWpNm86WCURTSu9pGH5SjTQXQTbdJ79X2Vgjanjm2VI/RMNszaj2AgZ?=
 =?us-ascii?Q?Ni9lg0afhxxb4tdYpBbNcv60LVr8/m96JayijwZOocgdlo3PNGP3XfT540Ty?=
 =?us-ascii?Q?OcvkRBWjjzMZxH7gF4idUc0sWxJS0IHM151kruvjEe1Fl9geVLyVE7sDTqG8?=
 =?us-ascii?Q?tLTZoPa6UTHkecxlPGN2q/E1+vtH8PZ7fWoQmiuNZ+mQaSioJcxx7LeLwiaW?=
 =?us-ascii?Q?3mdjmI72lbInYR10n8ZylmHaOJmsMx/E+IGiffJ7vmtNJKbi7qwhILRYy5h/?=
 =?us-ascii?Q?na7/ZFbTUvRzhimi8sFFLgTirXzixBZ/32DUjHgHoEzQw7CIN5nW2YHnOT44?=
 =?us-ascii?Q?kRkm0f0j/gHWYorUG4sG3UoRhlaNJq2IhKIXdJimR2uuc8+vRXwQyeXK5Keg?=
 =?us-ascii?Q?FRjSxee4XNMLhiDQoTSMKuQsRy95E9Zf75zmoriavPdTSFbJg7NNywjY++6V?=
 =?us-ascii?Q?PhnQrjLa4y1KrFQaLq9O2Z77hYSw4bUFhVP4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ocLVgQO6IO7+sQYeeUYOaIfbsz78M9Rj1BK3r6MiV1UIZMFEATX5EqIDbjpU?=
 =?us-ascii?Q?euxMMwRIjb4Rv/+Qq+6sjdHKvMDoqFs/6jYKayvbdCpmgQ50YfBkjeMrdx/e?=
 =?us-ascii?Q?kwryDM3gzVd+QALOARkXMjW6Gzkn9Dw3SZACmFVcVtw34EXJb2AjbhlJUPeh?=
 =?us-ascii?Q?Bm9yUgAIounT5/o8R6sTJOt9Rdg0rJsmnXBv538ybtUO1MIEIB1mkUA1HNrU?=
 =?us-ascii?Q?iqfOT4l/cbopCFFPfBw7TB17KJmNuaBa+WcyNYfeSAskSwZK5UbKwe44q9MB?=
 =?us-ascii?Q?72+GHiFcSGK3YW1kf/Q2KQvFnThUQOPX8utLYjilH2MGr3OBBTkVpP35qwiQ?=
 =?us-ascii?Q?+k1cn8CrzuSd+5b6yKzpAYrG9cooAhX+az2U0EyWNtZxZ/gHmZyJ9AIdJKkh?=
 =?us-ascii?Q?S60XQuDef0+QMguUBq5wburvMr3QstXpr91/w4/d+u7AHU+SkJHUegJZhcXO?=
 =?us-ascii?Q?l92mme3/be+9g6ONk44KQuFbaPMvE6CUYqUt7u3FJVcZQQqKicHnF4xQ/NId?=
 =?us-ascii?Q?D+ok7rgSCN8FHCMyhrBeW3jVoCQ9NrSrsFg86JzVtXtMeOaBTUj5YM7/r6ix?=
 =?us-ascii?Q?TtJ7rDLqIZY9dQtkKwtkybjerd03+0h7v8zGR/GWS1cXh6D+A+pyiaWR7sYc?=
 =?us-ascii?Q?gzzlhglv9Hb38ONRNu/XVe+x/SRhBly2QH2PBCnBzlziBlkDo39xZVvqozHY?=
 =?us-ascii?Q?euGc+g69PqGLJXSsgBQGGUjBwcCvSQ8WjFPvoFtpCqKHE7vWFerGhozW5GrG?=
 =?us-ascii?Q?KM9x+4y2kO7D2MM4VPF9ojFzo79Pb62rI97Ua3GNq0BDnRn+Im7iuae45Iyy?=
 =?us-ascii?Q?I9HPH9VBg4/oebINZlDmeV7pk3qbuRESvCFs9tjQMrbi35CvsWGQKhs6MkoE?=
 =?us-ascii?Q?zN3szVgisB2OEhQOH8B86/5tjq5uTZt/vDYjMtddESlk+Zb/Vujhr75XOQxR?=
 =?us-ascii?Q?YKTXyJCExn/txhv7/1uuw5yc5NNDSbPfneAxXpjonK9MePnhHFe4lkviJPUF?=
 =?us-ascii?Q?8vHMUi/xqbZZlQZVAO84P3PlmSZvOxK5IjiY9nkbLLf20zTaxHDHTa7KC1yj?=
 =?us-ascii?Q?0qffAE1PvAm1B0NgTXt9Q/pbYVekPnnC/CiZNtd3Osf8h2eD4RLXIg8pzT2/?=
 =?us-ascii?Q?Qcuo5sxDLAVugzWZzmxbQLxpijulSrqELgR/k1Wg848XQo6C8ATMO2rqQaxk?=
 =?us-ascii?Q?qZ2wB7HtT2nqO4Q+Scs+4siq4F6Ayn5JJwy7Osqj/2ZARfWe8U+PSNygAv4R?=
 =?us-ascii?Q?qw8U2JvK4QHc2VQMXxNmDEA7i/gVxxIFiObJ8X0Fp9zv7+W+nD2S3tz7ShZi?=
 =?us-ascii?Q?eXa9y+8Z8WZKJqVvspqHqAbdUN7a56Z5kYJ601c2RUv9FLvAKRutyvCExRYd?=
 =?us-ascii?Q?lGafAh91ajM1ACyYACen7iVWvYTNeVH06rnDJJCLcF7xGbg8OEPZOmQeCfhp?=
 =?us-ascii?Q?chqVH6l4VUzWEZunBtRC18LsnfTNOEwyJoeJq8zPTcJMxFE/rz6b2AWueJU8?=
 =?us-ascii?Q?qFTpJefSL+jg966rW21Bfhc2A0tPOWeGcPx7Zk6HjmMLQwF/EvsVQHU2mizr?=
 =?us-ascii?Q?ijLqKz1bI0ZHZScjZ5jmdeoXMROkPJ2MAJN9n+Sd?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 436cba2b-60f8-4a4c-6fbd-08de25f9a615
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 16:52:09.6368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AhzYLd+LVicVjUvShhUH6CpXbI//+MI4bgklIrBgIZaWiT1dMzDqeMfeEHo/RhFhfiVfnSUjN688EGWSZTGpdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8829
X-OriginatorOrg: intel.com

> > On Intel systems that support per-RMID telemetry monitoring each logica=
l
> > processor keeps a local count for various events. When the
> > MSR_IA32_PQR_ASSOC.RMID value for the logical processor changes (or whe=
n a
> > two millisecond counter expires) these event counts are transmitted to
> > an event aggregator on the same package as the processor together with
> > the current RMID value. The event counters are reset to zero to begin
> > counting again.
>
> Do you have any suggestion of which Xeon parts I should be looking for
> if I want to try out this feature?
>
> I'm looking at bare metal hosting providers for an Intel server that I
> can try out features like SNC and this. I look up the parts on ARK but
> it shows yes/no for RDT which is not very specific. I'm hoping to do
> something better than just hoping cpuinfo has what I want once the
> machine is provisioned :)
>

Drew,

Telemetry monitoring based on RMIDs is only present on Clearwater Forest
systems today. Those haven't been released into the wild yet.

-Tony
