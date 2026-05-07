Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93D01A316E
	for <patches@lists.linux.dev>; Thu,  7 May 2026 20:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778185308; cv=fail; b=qPxhI5MyNxStdbAsizvhaS0tz5B6wFQvUMc5KnESLFVgK/FtwroMAlXl8WuKba/jIGexMBDYNcz3JSTl+6n7w1XUOGhAQsAvHpaEb+1PH35NkwNQRnR0x80YoXKaegYOUpnWGWx1Z1a/ce+VcG0zhG8MhmzpkX8m5ltxFxNXTks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778185308; c=relaxed/simple;
	bh=+DEBHH5mel2nSgh2D8AlTpPjx94ATIgFmLj1NJYVJmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b8fIQN5qWAxYD6dessJ4kB/K2YaLOeXI2Ne+nx2GOHXVhMV3U3bZBQDrrlWlilP5Q8NXRntnLAWQ7aOxatbsuhSaSFBwB3IYH7KCd6OweuSJX/HU2iTfI3+JnUHwhoScNFMjdfDWO9A0hm5FJ8ebjuTfDoqE24PVNPyVsMUi1/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=By7ePTRn; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="By7ePTRn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778185306; x=1809721306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+DEBHH5mel2nSgh2D8AlTpPjx94ATIgFmLj1NJYVJmA=;
  b=By7ePTRn8cKMV043Py+TSWr6MXx6mQCg8hFBxxpyYkoLM0VYp9rOGQuE
   vXiVIE/wle+U64bJL4nLaVEPOepkrMumPf1Avzs5p1V7XrCUXn7G+URrQ
   u3wjtqpqlh5poVtmS6HFuEpW8lIIo1WtcAvl3yZVrwIslWmbGCxpW38eJ
   KOzMMZu5KqKtGmpCwCzx4PZvNBi9svZybKgyYt0ACKx+VAvqrwiIWjYUY
   zhpvIoX+BWfY7mAF5rs69HP4h1yfBS3Daqtlb8QbXAGS1df2oYxqQANS9
   8Sp2DzvvwEFYQFVlV0PXS5NOEt9oQ9xVgRD+HGEtzHcoBIRVWqriGy9pS
   w==;
X-CSE-ConnectionGUID: 2vN15km3RgOFRfXBRuLYHQ==
X-CSE-MsgGUID: QrYdI2LdT86FwcqFJzgysA==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="90250816"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="90250816"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 13:21:46 -0700
X-CSE-ConnectionGUID: 9lJhUdTuRiC7tdw3FktcOg==
X-CSE-MsgGUID: CDWO/T3fRdSg4NpneTtviQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="230172070"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 13:21:46 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 13:21:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 13:21:45 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.40)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 13:21:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bg2RSmuKEsvzVua96Md/g9FOeGLaKg9KvSkxaJES/emT8smhfrKhrjJvp9F/U0GtMhVGcWKmCU6QmHPmQkycOK2YA8vd/BmNLhil7rSGksF71IqQchq6/sMJIAImdyNCi89OQhOs/dOt8mqbtc2Z/NwKPGyTEAMnMYv8AUBsW5nlyWUbc1mB2cs3LlsnigR9ZNeotccOVTd7X6z/kHi7Q0BerqcxNHGxbleOXsTmUQchO+d3CGMCEs5yRARln28VZdKN9cD86uuKIQ2X9m+pZHxS/0GlVtlOqn02ZAZaTmWV5E15Ok1cj43c7nnw5BEgmHfeOKioz0YDjjWdQqZcpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DEBHH5mel2nSgh2D8AlTpPjx94ATIgFmLj1NJYVJmA=;
 b=YL7QClSu6pZaNUP7qbdKXsmmnEXTsRGhEiNrYEdW1702Jagu0DYIsm3HqWf13Tj7a3wFP5A6804qKMlcE+49Przr0yCpRWpjZhdRtJOvw6XiEYlhNTL1HZb5+9r2LFADjTtxH8EzcwSce8tujIxoLvlQY4lh/yyiflDqB3757tOsarbBBIxQ/rrU2xyrbWhtfTvX0reLcyDiPbFiYVOxTuQ4VFJDii8xnFNpgk/DWgAWjtFqFU7flLI1Bob4xjIwsqMcryKTqjobJVhv018kDWcfvk+vFrVrUcb+EEAc9j1J3stQVZqxrn1gU8w1zbrQCQCxE3ScKgmVmzs+tGq8NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB7933.namprd11.prod.outlook.com (2603:10b6:208:407::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 20:21:40 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 20:21:40 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
 failure
Thread-Topic: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
 failure
Thread-Index: AQHc3l6U3I54ABGSeEWTFmaqajKP2LYDAQnw
Date: Thu, 7 May 2026 20:21:40 +0000
Message-ID: <SJ1PR11MB608328558224E6587CA6F0BBFC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260507201730.16509-1-tony.luck@intel.com>
In-Reply-To: <20260507201730.16509-1-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA0PR11MB7933:EE_
x-ms-office365-filtering-correlation-id: 52d649d2-01b0-466d-393d-08deac763f56
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003|38070700021|921020;
x-microsoft-antispam-message-info: nfQf0CXChaJUgjD842ctuVbsZhh50gpOHRelPhIKr9fwrby1coKOIu60bkxm0U4g/2SnROFNZaYUVEbJBXhlFBBcdSxsnyWhHokWdT1JJKjy67EKrnRFmss6frp5M2B1RnFh6munSltMIBb5Fjn9nBG0nS78QlDBBd3IM3ozhz01NIzYChAywNWCXW+ellXCsMHWHvmuZZpg6CKjnQOLrYeK9iLcbZvGvBjFA4YJBZFFTQctCblf+BHVQltt7HoMPwfXp01FJlQFpTmYBRIvP4lqeOGfbTlrdQ5TEsKegeuUbPRmwPLlDVpg9X0YUGYV98Yu/iSAcRxTXlNtcZueCgHCkd8Pjx39yQVy5E7JzTehMUzau68HuTVwuYDPAosvX2JYZ5dnCi4Cv1pV6KOE/sDeivPUdHmLHKpZbtFFhtB405S3BzdJkUXZ7bjryxbEQ3Bpry+Pf4r4Lzze2r3oeQXdYOfi9Eh9uORL6IyC6uKw1BfXgkxB0MzIWT82cQrA/WdQcaWxw8QRi2Mp+v5cojKpVCC785gS2ytdZVSwZfAal9ozlRW+ogdyQccdzCjb6+6PJEcXS0BFzy390YZ8U+KfD1L2NjdU9kq+C0bgGmMQD2n3ls+a3xvAj5J/KVcZCh8gnrdP5oaZ6n1jiAKzvFTGAlRSqg0ptZgs5UAnsFccO1JN67oYDz6qzSYOaUIbOwjkEv4TVr++WfSLWCOp7/PokqgxcbIKRAW3K3FRf7U0ERAZ5zPYVojFz6BGJxa0u+3XdZh+G/XESd/GkqZM/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rVEcT0ojL/LqmYvOz1z0D6gtU4AqvsRtJb6OmdH5BaNhR/5IU8R8Cp3vvolv?=
 =?us-ascii?Q?luMgh3BPJ69OF5FeIA+kE65kKlltxi5mS3oryuiiAkdymQ8QhqqLXDmXwssl?=
 =?us-ascii?Q?9iw0RD82WH0zFztJb9trPxmzDHkKEb5ZaLYQNhFcstiO4+ILrfkXGAUwzBYS?=
 =?us-ascii?Q?HMaQJAmDWozcN1Hgv/mcEXsVZzdXDzP0m39Otrk9HwQ39sT/Jy+J0DQGys4n?=
 =?us-ascii?Q?E/p60VdVa5tkRF1duYHEJHFcP9s7++CRrKTDq5X4t3BoLxX6ar44ZIzP3k0W?=
 =?us-ascii?Q?vpbFtg7lMFfRpxISz82u3NOgyB+w5XCZ1ndkFgElCEwoTp5t/W4IHrizVJWi?=
 =?us-ascii?Q?yIEiKyTc04Fwqd4kJFiqMDYmGXtWyAep/3jGCwOzDV0gHIzNcH3I0J1FNg5o?=
 =?us-ascii?Q?x8r9JWsKRPVIg0zWKi+kMtZA49X5zPDFZ/Hw47Nax6CC/jT43GAZHANG/joS?=
 =?us-ascii?Q?JbEAYozlV1Xe/ux2rGxHevH9YOlx54oOAtCvYxy+AD8VnDQJhbwlz/EEr22D?=
 =?us-ascii?Q?H47BHvMaEUUsa03Sw8nI2N819nL+yCOTKWx5Df73wRgEjduPBMD/DYuY7d0d?=
 =?us-ascii?Q?THi22JLf644P1HCO5Up477IaGHqijYTZPf6q7GEg2/WFzh0RM8TJwG+jXl2q?=
 =?us-ascii?Q?PZPMGPg0NjpkdYx6CTZxZbDj3Ie9OPoLQJEmJrVFpgQ3aXpOoN21lxnrNPyp?=
 =?us-ascii?Q?L7a92exmYcsPEciqNKMGW0/Q1VHBqN+Wx8lrISmmmAdAh5qH7gdlD4GMJp6Z?=
 =?us-ascii?Q?NqW+2fCB5o21iz554VZEbgbqVkmkqMhvfERN6p/fE+KZsB7F5TZfX/Tklfdy?=
 =?us-ascii?Q?umOYRMxSQ3/mYEvxihxvS0dIOKvpZopb3mzdFgPNk8eI4+dXVmklG3W179eu?=
 =?us-ascii?Q?IKPcctub2mDxRnGMVkqUOWbQ4Qp/2BbRDk4MVg+Nur11/F1aWdgm0TIM6v/I?=
 =?us-ascii?Q?Y9dwWVuOFaTNuceAxwQmnou8g5rPV5NTK3yLVxtI63vsPphmPi0QRu4eHwHD?=
 =?us-ascii?Q?j4k/QSehigua928Lw9VtrPK44Opd6/Vel5jTb21+gayZwCBUeefRjtkzqJX2?=
 =?us-ascii?Q?CJIYQwgXc8vCa8+UF9qb15wn7Z/JMnqZW1Sox/Luch/2lOy4G+Ibs0yRXlA2?=
 =?us-ascii?Q?2QR5WGrpGLaU9NAmYiEWoX7IIl8Ny0jTTPswhKJ7HZLzc+DhlvJ775gvuJcV?=
 =?us-ascii?Q?uHGE/pwKBxT6C8V6i1MU1R6HvhyeJxLl9qGGrlJ3yEHcEdvguC8SJd91/VPm?=
 =?us-ascii?Q?d50wWVXdqN284l0ZqtVEX0sQVNhMwC3nCTAnxlllFFwjKdpnZkY4O8Knwdxt?=
 =?us-ascii?Q?r+UANuIOFufpf6p3vygXuNvJUCd97wB2TEU67gTf1AM+03iHxDTW3wxqIk1e?=
 =?us-ascii?Q?6pmyB13vwoxxenkSyxaxBS81NLrBCd7NXguCoWGfStZ4s+xNWUQ86tM91Bi0?=
 =?us-ascii?Q?WVEEeZxN+8P4MT8svSoS0mcuCZ1rEdWwI9JOugPfRM9T+ssGwH4Q8J5AG4vh?=
 =?us-ascii?Q?VX0156qCCbC/ttnH63x80nT7Fsr0Ui268fjxHeBbGwsnFa+c/8UY4ZCW5g3d?=
 =?us-ascii?Q?6zP9vl7nQnYPJmIx9Z/PgVl1TjJfQMp6euh3Ke17LkYpr/yD7xp9qH5RLFZA?=
 =?us-ascii?Q?uE074aDaXqzF+L4xJcPLylruDjtHHNRFfJzliB3Pcy/zHX3F+NIVmOmBFygn?=
 =?us-ascii?Q?5oYJA3tJfacFLNMCrwZjAXS71n0Fv1D7rAQqU3G6YzEmjaZe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: X0S4g+tFNOfKOj5VdMpDAYti5ZtLeVcYqPJcmXVHVctVp5VygTsuF8zwTvg6sYvYQMIIgAcC6uJrvnd+Yx+C6HQ/DR9df8IcSyZxNMjlsx1YYyOlJwkyWNfA8z332+wGbXWcX4OSsI2C+aCvnUXc2do4GxImS7Z2Bf3wzBFaKbQeKPO0X5Iut0ptW727JPXeKnf3pUpPipiqGBnMHk3bhuUBf7wvGKZz9gqxysoItzXX/H7DzKQk0kJNqGUAM6BrP2+eiS4fz0WyaABPkeVsQtQzIV658bV1eMN0qjX1Ot267bbndaYERMXG+BjTE6+6pGGbNuHDVYtdWoMVbxqH9A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d649d2-01b0-466d-393d-08deac763f56
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 20:21:40.1411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 58F8/N+T6GSsbnxvpM08cjB5syC7UTh04fSci8ljuv8Ywvibk3XAC2WJu4VeZJuT5TZM/3ddeYnm2S9gG1SF1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7933
X-OriginatorOrg: intel.com

> Did I really need AI to help, no. But I wanted to see if it can at least
> save me from some typing. Here's the prompt I used (contains just as
> much typed content as this change!)

Bother ... trusted AI again.=20

fs/resctrl/rdtgroup.c:2883:17: error: implicit declaration of function 'mon=
_put_kn_priv' [-Wimplicit -function-declaration]

:-(

-Tony
