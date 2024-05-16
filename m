Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168D4147C74
	for <patches@lists.linux.dev>; Thu, 16 May 2024 21:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715894855; cv=fail; b=s6t81rD1i43J97sWOUdQ2R8/4VKSn6COXw/+8ip8zdjsgXL09tk5xabzENqiJ5P19Gg6vsWQ7My0wdmw0pqExzLq3umVbBCe6/4kfTzWCCO13YGN5lfU6lBDB0LaXRMqaTddwvcdolqgqm/9i+DluDWZVRCKs/Vd54bhrWx6W14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715894855; c=relaxed/simple;
	bh=6WOEHirIJZL5kvsm61yBEDZatpIZzNL4kmCs1uDrHng=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BtFSyTRW8Cmadrjajc3vD8Sh617tR+0fATn6vz9bzuYOn+niBO9nllT7BoqwJgEI1sFTvbVThyuQuSKOURwlI1xpsRFi2q6mmlP8MU2q+7Kz/2hExgrJ1msa3xYDrAISO/x3Rsvy7Pfx7K4qSTbD+c2d1anaRwUf1fI6cgnRnic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B2thtxl6; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B2thtxl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715894854; x=1747430854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6WOEHirIJZL5kvsm61yBEDZatpIZzNL4kmCs1uDrHng=;
  b=B2thtxl6LFpQCgBUD5zICOKbJ9VThUrdzJKb2Iyux/tgXxe+LKEHLfrK
   fesRhaIFeUJ4+Y0nhl9enWyUjjpyGzRtx3cW5QHuPzo/q4N8/GfHSfbrJ
   mJWmhMF9jdftXDGo9vfQyQtp4ajr77qQNxTkOUqnTdnMHESpoXnLKIhdW
   htdSixsXHaV2gsXJlv5/azuWyoZaNop+XfeC6ZOJgCzdAxR6WNK0otLxR
   38bktSen6A2mHCT7hZZWkw4cNRsr3e6qMY6kpbevFB4zcDcZbrgtNOBYV
   IR4QF6ILbtZwc0ZUY347xKHoRZ8xh5ZlWgwRgPELI/AeqLrG8hOqQAoEB
   A==;
X-CSE-ConnectionGUID: 04//nchsQ3i1N30j6T2XYQ==
X-CSE-MsgGUID: d1Z7NOuPTq6JEYTp/+h5nA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12235070"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="12235070"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 14:27:32 -0700
X-CSE-ConnectionGUID: JGtlCN4jTnCfVVs2nW+O6w==
X-CSE-MsgGUID: gdShALIUTrmJFHwhf5QXcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="32176590"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 14:27:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 14:27:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 14:27:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 14:27:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApJFKDmLvkrNntGHQVDYCCmBL3DEoNEvXIKJx3QXZ65iwF2zMumePtejxUHaBbx18oHZiB46ka0wq+fvqp5gNDdaSNuvv7RRF0sRC8nUMuIxmSirz3NyCfKty9yGGGnJCWMY81sykMCIZ4CIqMUuPm/Z5LoLJhx9V67BXEQsEIJC84zHwLYRWowwzWzUpmOVq+k4MyO/O/6L8XJc1ljRDskxr2Dx3TduwDC6HyV4tHOG4KmlZWG0VSbSVQZY+jD23Nsfq8LuojJGNgx5d3dP6+5AK1h4YwCXfR1Td6zE9m+EgdP66GAaPL8NxXHv++VEj+zSKE1qBp4dUEN23afFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WOEHirIJZL5kvsm61yBEDZatpIZzNL4kmCs1uDrHng=;
 b=f/hLcnLLIIBXaGcJHFTyIQtkGkFYlqPwa/6oHl8rH7Q6GPxGKfAKIbvmiPUEqUyYFOw8KWGsGQqfR+FDD2verkToEQkfmND+9zZsnRttLU2RZWhraoRvnLNP4Vq0/crvXT6E4jHel/jUBJoklVMOAQkltum6Keh/5Swp8Re78SlSyGO2+9I40kmnWhc/zIHEe3j/0c+nFNhZNev2kI2iJpm33wcIwExTOhPm46oqz5KdWUVJq18KZQnaPVVfR6LpFLDbWvn+uQWGkQNE0Mu3mKbmI2iox2nHybEh/oOUzzzICnP4Z/Bt4MxP/I058keyvMynVjgQDU5DyTkYoOXx7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6502.namprd11.prod.outlook.com (2603:10b6:8:89::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.26; Thu, 16 May 2024 21:27:29 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 21:27:29 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
	<mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Andi Kleen
	<ak@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHap65BNQUQc7djfEG+qeIcEyvEqbGaX5JA
Date: Thu, 16 May 2024 21:27:29 +0000
Message-ID: <SJ1PR11MB6083193368C84DA509A20747FCED2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240516162925.79245-1-tony.luck@intel.com>
In-Reply-To: <20240516162925.79245-1-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6502:EE_
x-ms-office365-filtering-correlation-id: f37a6113-bb1e-45cd-3dfc-08dc75eefd3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?SXzEll2wUlX1nka0wr7LkfvvQZwkJcS9xPnuBm7n3nw+4U4t49WXfKVVqZYa?=
 =?us-ascii?Q?W9P99QzTKI2gkKfHwkarRltmND/gIaaQgZqLX47eM8FMn1SzQlix1fqM60uN?=
 =?us-ascii?Q?GBqb7EVfN67uhYxThwkR7xw8xUvEq1s2TI/jd0tkihKO3icMR5nZ69QtX5Yh?=
 =?us-ascii?Q?4KVZqPgQRInjWBnbnKnStz+vAggc/KZjWKEFgxJMfoNmVg5vt+8y87WZ9qdT?=
 =?us-ascii?Q?MyXNtt0hnKt7UGSwjKpQvi5WNH99xcgNiEAySZ2tWAUwGFhth8uwPo4FLOlq?=
 =?us-ascii?Q?MwugIsho3KvAHqGzwTtfGsPNwQb/uhczgITt+RTBEUZLoFP9pNm9jm5MDJid?=
 =?us-ascii?Q?8SsMn4kfmQuHWvaPFZInuXorGkDbe3ZyPgN0Cdb/fGI2ov9aCKhek7StVo8L?=
 =?us-ascii?Q?t539Uku0FPYuSiNtiR+b9W/BDBAXIEn5uPH/x+FmvDBSTgB5GlCuTth/86Lq?=
 =?us-ascii?Q?wmU1HvBOZzm5rLWybETt05254vaU/k7mOlsoGRNyZ2Pj2u9oeXLZn0I/LOOu?=
 =?us-ascii?Q?7t3Xrsb91Dvg+JKsl26ieuR/zUfVXOESU1BlgDs7mwh/jmRKpAFyZjJ1TdiY?=
 =?us-ascii?Q?eyijsUtW7aC29ADUpfKkieXMnRTdrF4ahevvKM0e/6PuroxP3iNZ/V+ssyt2?=
 =?us-ascii?Q?AttbflSMYLJVKUz55GQZYA60TcMEecrZmk/4ZymX/Pe9GjWstTXVG+3XoGQL?=
 =?us-ascii?Q?CFikvjBfx36GG+coct3FRVollkNKbAn47hdG+mHFvY6U5AP3emAcPOf6kRIV?=
 =?us-ascii?Q?fwHaFSaYSPzfPp7FxUGzU/KbnlhxFvb5tyXVHQX46P91T3aL0jgbco6zHc8K?=
 =?us-ascii?Q?h4vTADn0SUraGKc/5qTHEhBUqxsAavOuw4HDtXRQO3yH6UKYIpwYWVrZvI2n?=
 =?us-ascii?Q?8meNJ3mwn3MDCp/m6K0IsehzDqByud/7aRY4p8y86jW5Hq3uFlJm7cgzj/Ff?=
 =?us-ascii?Q?BFUFxPghFkSzyLFVNIPrTME0s933MESZLljfnCkGZYmKGkkVkgqaM3EcdGrZ?=
 =?us-ascii?Q?ctnjMARifoXgnRLQt4/gQxI6+gKWHP1sjW3DCSyKDHnNi//ov0k/7qW+9cfQ?=
 =?us-ascii?Q?Am/kQgMZnNmuQUy0tyVo7ezLHzoyyWgbKs9ZwWAxmEsxWSXKUO7Z7ED7kl3y?=
 =?us-ascii?Q?wOmJnv51z7l4nai0md6IzepwBSiEKPuQwQ1G4ifF/rUWDh/1MALU64SpAayx?=
 =?us-ascii?Q?mOt5jLofybeuzBDEeZoLgt4eCq5qQMUeIccSCksSt3Hl7S4gsRrxwvccuGWl?=
 =?us-ascii?Q?tHzan+DHFIkCUQvP0YVvtZGkgY1rmF2cTq0vUrEPIUte/ncEmz5sgB84HdeQ?=
 =?us-ascii?Q?zJCDE723WD8GfMPanDEjyfHaTIxUMhaGI5QMboz2Dp3W0A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZNGId5hfittvPwK3X0E7BjB7fdGhAuI+v+dxDkW4onpwGFH7Mb7/yClvjGHE?=
 =?us-ascii?Q?Niw9ZlDpqhO64ZortRgzKSCxBRjOzSOLibzz8pdwzHOjw8VyGEHsUpk8ypAk?=
 =?us-ascii?Q?a7RBGtMvRVD8mC23ElPfvT87f2YgylnKrdVLElTninAFZjBPb6sBktU6xo0M?=
 =?us-ascii?Q?berMo6J0djalwVi1SEzisdBIib3xL8Sx8/UwlfF2Za6bZ+bb4ie8hoPzrmkk?=
 =?us-ascii?Q?nGSgzjRa+U746ri5sbN24qrZGTczhIs/m6dqsfON+v3P7ERA87mpuB2H3tWw?=
 =?us-ascii?Q?P7GEgnruG0YHCetynYyRVNR3QkBvcWZyOcHeCnlS+pq0HHR+FFf+xRSP87wT?=
 =?us-ascii?Q?Iv2MjgaiyEinsYlKBf7BTdXh0G0TV3Af8iW3466mFc0z8bXWXoOeWz1YZGp1?=
 =?us-ascii?Q?3rD6xAcq/9kEdghv+MMMKbbTbjJngyBBZMbjcmpqHZUfXPN5yMAO16t8i6Y5?=
 =?us-ascii?Q?7UJ9UL3dvpYCqf8uS6n6FgiB55hyszSDYIzqhveCiq2KKQZ/rIGI3uWNk1SP?=
 =?us-ascii?Q?NvzgY3tLevefWMfKSIfop9rIXiWsxfd6Fu4t7crWd3stYf1M7WRtYQE7RfNY?=
 =?us-ascii?Q?TLd8T7lTo6J2/8Ud8toDzwqNA+ZPbEyC5tTmFiKV90FuDe1RLs6pNszAxiyq?=
 =?us-ascii?Q?Blm3eVp01A9gk/805wlAzk0raPkyngnZQC1CCbM2uLkaPzJ6IW65YD14DOVQ?=
 =?us-ascii?Q?LWooIfqSk6eu64EI9BDV94dePfBpmgV+iOVqR1dq8nN6NOPoZNyiRj9XRZ2T?=
 =?us-ascii?Q?xcwN6cmJqrFgqoLmTki6U6AtSTcfanP9M8ZL1Hz7dXWLyuwWQbBFqVnNj+cs?=
 =?us-ascii?Q?SeV5kmuOMKo8KPrO00kKWAYrLb4hZRUnVJNXLfRtTIlVRp2CTYCVZoUegg1+?=
 =?us-ascii?Q?jVie/ZseT8YU79NcXVzdoUwYCwsNVOMfYfYC0zYrQF0vI5NzWw9e2pN1df9g?=
 =?us-ascii?Q?9alnLcVgkABDR7OjQKFakuQv4MLKbO4c3TL916FXJG2ShrJ6JyQFGjULmNHa?=
 =?us-ascii?Q?9LASkqOAfYumOaTwmKEgJ9L0SVxkLl3T1TYkOq7hPe2bP0UGROkPhcN7lQTQ?=
 =?us-ascii?Q?UbJ9Oyh43YpbgOOpJA656GiygOdRtjkobrSskAyGU+PYMEH/aTPDPmsz9cnO?=
 =?us-ascii?Q?AEOeSLVgjIWg1ky0OXlZv/mznPn3DtDG90LKGs4NqG96oZ87Brwdv7JMgx+S?=
 =?us-ascii?Q?h9Q9H9yJGP7rz4ZFgC1BvgphClNheF5mImBB+KeFc1b51agcKVy2RTTlk0v9?=
 =?us-ascii?Q?GA8h8F39HLP+9WBmBJc186fHcgSmwqv7d5WctmqfCaQ7nuCV+l40LaCe6JQ7?=
 =?us-ascii?Q?xrULIPH/GC59Owby/eDp5R7UtFZktxKIDc4ttGOEPEeCIU0GWEJRZ2ywXUun?=
 =?us-ascii?Q?BINK3YPQsksmESd2jYJwg4GNxJMsMsB7MIBy2ofbyVhCa/sRViE55tsHhEui?=
 =?us-ascii?Q?kK4bSPrqlHXkvYKzI4RlLIKK5WgVtXm/s7rMeB0jl7L7ar1h0jBA62egyeGR?=
 =?us-ascii?Q?T7I9NGZgW5IIxBgzdY4r3yiPwH1adHrLbsHlUCN9ONkpf04AGrbV9JgSXx4X?=
 =?us-ascii?Q?zIubXJaY+9K8HHcjbGSpXDsPWyw8z83KlH9eI5e/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f37a6113-bb1e-45cd-3dfc-08dc75eefd3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 21:27:29.0830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UrbQyhWUZzhakPbYHpfrinKzEOxZVqNxJ4hxoGjNVW5uqGxCelGgk4FE3AL3Y8V6EtijTv6fOYTkh8+Tw1fudg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6502
X-OriginatorOrg: intel.com

Couple of typos in this:

> Code in v.9 arch/x86/kernel/smpboot.c was changed by commit 4db64279bc2b

Should say v6.9

> [2] =3D { .vendor =3D 0, .family =3D 6, .model =3D 0x00, .steppings =3D 0=
, .feature =3D 0, .driver_data =3D 0 },

driver_data =3D 1 (not zero)

> [2] =3D { .vendor =3D 0, .family =3D 0, .model =3D 0x00, .steppings =3D 0=
, .feature =3D 0, .driver_data =3D 0 },

ditto.

-Tony
