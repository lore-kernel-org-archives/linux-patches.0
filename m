Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672A51D5178
	for <patches@lists.linux.dev>; Thu, 25 Dec 2025 12:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766664316; cv=fail; b=EALdAQmYUjUo/2HixYcOZ0o0FmCdV8Y+4vnMU3PmiouKAm5uNn7+amRYztiA/YGk1cTdR/pt9ZxByFl+NYW//5H0OhG7N9+2V/Tep2tXNugkYLrYwcV1RIAIYSS8sG/GhKTeMj/zztTUSQUw3wPvMh5XBX+plW1PLqFa/Y0axHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766664316; c=relaxed/simple;
	bh=TE0nLziMGk01SjzaL5r6SpJySHA9nzx1YKZhqHwIqM8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OkaU8YYT5rJy2J8lwkjSXsr6tVltik4HU8K/3AE7n/3t1Rh2ItofqxvM/B+16xVjYzvyBVBD1VwMdv0TRvqFoZlT9pb+csz06fHg33Bgv0ug4WpwOFnIV2PdRNcji6SJmP0EurVVtNL+yGIDqsvnJQtHNUVog+drEYOpZU1mPdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gQqZD8T0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=NXK90NIe; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gQqZD8T0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NXK90NIe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1766664315; x=1798200315;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TE0nLziMGk01SjzaL5r6SpJySHA9nzx1YKZhqHwIqM8=;
  b=gQqZD8T0dEhAB+EaL/NlrIsE5rAdiW7FKs7fxlnKj77MWtN7BVfjnY2x
   zNiwfLBHAnXxUQ6ucIiAOz6ieuNUAjcmPZqyOvsSnNrz5jXOqkuD90ZgC
   AuVY0EuBw0/X6vJaxuJLkmlRAd/bOqzd0KQaclRyfVu16IEb4r3GApsto
   PnjBClELZLOtO78T61WsLZwMerZjTBjE84mT5FTAWFUj6j6tS6TUQ2ula
   ZNMViV9Qis8oxXLTk4y4w4UBDZAc1cnaGzybX8CJPp0v8sHkn9k0fvhJo
   oJGU9rNZtYKWD6RE/5OeSCpRhQY9rp6QndAiW1oF/eHEnhBJKl0ASnQuI
   g==;
X-CSE-ConnectionGUID: lOkgCQKUTOGFivxEenCrXA==
X-CSE-MsgGUID: hVqdBEVmTuWwZooJSIfJxw==
X-IronPort-AV: E=Sophos;i="6.21,176,1763395200"; 
   d="scan'208";a="137740331"
Received: from mail-northcentralusazon11013012.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Dec 2025 20:05:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hV3gtjWPJssKGZRpJop+PQiLyiaKLx1VBPdljYeCn+fLAuCPkMPFOl5Qxu6TIa5W9glfpFYM0Pisq/9ZOA72w0pha8wQ36mA5iKkhl59ij/z2IJfbRPzV/y/3Oyh+HQPj/noI72WKXzT7EvxNvwPJb+8zgGk5QNB1pdWKwAAX1zVlGs8gjUks5VBrEi534+lNUkNY4bU7HAcs+X2YDu3VECxHKD1bNpv4aE0Bgy9eGwrWdaqdCdsScyi7Q682OVoZ9cMT8HDfeq2fSv4nUd2iZrldIwbLkIIkOhlGegRBwUZ3b7acQcVcQrSPEZH3TlHGcDBX/p0/Pr69CTWb2PndQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTXiWIkZzdALgxt7OtySCT5w4b5BguN5CpYQrpdChoo=;
 b=cFul8DhI0qNobNYPUeU4V5L/osb94SHjIBWH5VOpzxFCRnl+24/P2A2Aros/QsV2lo7LXCJWAQzgdsXtBA3/vcqvSJgh1XUkKTZb9szdNFJItnzHPSn8ezNRPH2dU+ghzaq6vLQU0Ny3F7Brhd+uVuCgLj4XYTTd/imNBHhwB8Q8gVGg4JnXJSDjZ6dKVLPe7CizjG/xJdv64ZWb4vj5Sya4M8nRt6gUmnH+4/Ts0p9G/r4NuEn2HiY/rHiwZ7a0ErofXedYv8uy1AVEuhGrDyVW8dY7SfWvQFjV6FnAczJOIiT0OtRadU3wjiAQo6Mx5uFb1othXVnu60tocsNDgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTXiWIkZzdALgxt7OtySCT5w4b5BguN5CpYQrpdChoo=;
 b=NXK90NIeLJ8Z9dYuFuMuGJELKuEZodlMDQVY4oQmdi8jhjBvDwkOhEu7aC0hd5L08zvY9Vql4VyPCrIK9DcsH54fU8wBHW0q6dUdRRR8MN4Ot6aZxyBtIwjk7lBjAjbcmi+ONdILlS6TTnPdeBnp6ENhQsDw4QyXRfsVqYFhiI0=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LV8PR04MB8958.namprd04.prod.outlook.com (2603:10b6:408:180::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Thu, 25 Dec
 2025 12:05:11 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9456.008; Thu, 25 Dec 2025
 12:05:10 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>, "sw.prabhu6@gmail.com" <sw.prabhu6@gmail.com>,
	"kernel@pankajraghav.com" <kernel@pankajraghav.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Topic: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Index: AQHcXverMdISXcicTESRwucSMTRsk7Uyb36A
Date: Thu, 25 Dec 2025 12:05:10 +0000
Message-ID: <aU0nXPx638RKJAjw@shinmob>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
 <20251126171102.3663957-2-mcgrof@kernel.org>
In-Reply-To: <20251126171102.3663957-2-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|LV8PR04MB8958:EE_
x-ms-office365-filtering-correlation-id: d34ca0c2-5b2a-440e-ce05-08de43adda9b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1CSSU+gwBbkvGpl01mnYALGYUvfMJ8mkPrBR4+lbBvTXv3kKkXLloZQhxAkG?=
 =?us-ascii?Q?bDB6DBjaWYxg1NqYHqXG85TyF/tuHfx3zYcRV66aQaSi+KXhy5phcnG68X+b?=
 =?us-ascii?Q?wJTW24NWQUFR3rXEglm7y+Bh+H3N+MgXXpuUt0sxxBeoOCRHWM41525Nc4LX?=
 =?us-ascii?Q?o1ExaLQfjmBr683Av4o1rAr+CgwwVZWiRq/t2L1dwz6RqgVTnWIEUpGOpI+j?=
 =?us-ascii?Q?eVdvPTRY3XAyTNoUDigZR/cm5OPVmTdhmy9uQXBdErWmhKUJ8oZx6W+M4153?=
 =?us-ascii?Q?/cumhmH7wcb35Xfv7uI/sZLI+9jncyCo9tAq+R0vyDThaehi9K2s7ES03mos?=
 =?us-ascii?Q?eIXGnSK34Yk0eJzph0tRgakGGCOWk5R4uSJmqzTwoDMJYbBTqtfOw/WCaSol?=
 =?us-ascii?Q?+jLJo17ZkhbBmEzChEHlx9+dcdnqwPApMAUt5hfpzbAPAw8HyADApM1YjsX0?=
 =?us-ascii?Q?sZyQ3nmoZJS5tNg4rfgRCqaw+Javq3akgj84OfLzEGJr433b89p+TKNcz+yz?=
 =?us-ascii?Q?Bi7+RvQ2zmC7soAOJAgAtmnrU6baWamC+ncsCuSkxSKxjJcZKDdlW6eimjY2?=
 =?us-ascii?Q?WExITOnwVB9E+AQSWsDVxTxm0+gE7SxO8tIhvHvOc6843t7/H97E4iOlloPB?=
 =?us-ascii?Q?cDHNE1IeszM8X7XNGEtc8dnX1Qr5ZhN9iixVrbNteanoAzakHuIX82ZpygVc?=
 =?us-ascii?Q?5AxN+liHr3cDAOokiHIhdnky5hkYIhodhahIfedjTaqfAbGQFwoZM/f+xnBu?=
 =?us-ascii?Q?VauY0MoE7jEwNVwB3Z1S+wRsvYtvP0lWRDeefupwRtiTi7FYCV+oSg26fji0?=
 =?us-ascii?Q?WfYCZMM6Oj5us6D7Zj0+gLIrTmmxTnCaai8h63jDWa1ANkshkwj/VgrMBkf/?=
 =?us-ascii?Q?UEyzMk3WX1NBNXVVGObYzz88MhGYqFc8rlV0vsbWPUvE3+Q3/TAfUQTwYISY?=
 =?us-ascii?Q?0eURaWUSxqLG5amSlRN7Jxnp9a5aD2DcWMdPdWzKiNf7kYyoN335D20yl7Ia?=
 =?us-ascii?Q?48iprs+Urn+g+rsmqNKDrwY+/IbQCmFqn0Pxuo0xjMe4G7uvIQuR3NAawMdV?=
 =?us-ascii?Q?eytSz17/df5of0u5umeDfIapXOUlecKwVstskjgPJ2s9btJL81LX+pJzwibX?=
 =?us-ascii?Q?FPNlcklwlz7/KeBuVE3uI9mwcMOKOkxXheB2XRAH51004ePZ6fN24gAn6SCN?=
 =?us-ascii?Q?w4xJlRfTzwNDv8x/FPeXpEOB0m0Pkf9LF2R6W6RU3kKm5J68jxReqju80H8x?=
 =?us-ascii?Q?/23bMEZrbb95zQn5uIY2P5g4+xo+TfSBibXyUyrqcJJFSR8C8rmjlVvUSEOR?=
 =?us-ascii?Q?LmDFvykGR18qUU4i6Y0/05ISZ7Lmcz6SbS0bni8sacHmXJOyBGwC1DpisA7c?=
 =?us-ascii?Q?eSmajkPYMPd3zEbyrBKpqqEiTC6QUfkDEQhnf6/KmIDtT33G/RvMipULJvJ9?=
 =?us-ascii?Q?f7LJmeoKZW60XzC5DgXsJmiSBoFUc01yBM39SgNiouLLmdPxmfSVTZZo0meK?=
 =?us-ascii?Q?9bBo0X+iT5pDD/GNTlmdMp2fI+Z0Qf46ysyF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?sRd84VaUhH7KO7+jFPgJs9MUQewpr5VJ1D3n2GBNdnkXjjWrHpCeyRFEhGry?=
 =?us-ascii?Q?5Yj5a/h7rw/3wVNGNrUVZZn16HmDS78LAvnoE/yIiq0VtXu0WvypQL07BoBu?=
 =?us-ascii?Q?54tPOoZM2gWoAbMLVQh0dN16nCMz+Wdnz+l9jAmH4kOcnDaQikQHoSz4rQzX?=
 =?us-ascii?Q?vqolK+iJl+zorximUHrZIRhFCJc7I2IXt3kImFhPXswvX9EuyBoHj4TjTWYg?=
 =?us-ascii?Q?WgmK8FAhehGyVkPv3EPYcMD3kZ3FmsvJkfMHcxjupd7O5/feN0eydn3hlti4?=
 =?us-ascii?Q?c3xfC4SuypvPStHTbre9E45VU5IFLWUG+LXSEify5gufY4uQ9ZEVAc8ULr6Q?=
 =?us-ascii?Q?FgbYtoweVJI3hguBhlH/uSOc0jUhthucReVxthNFf2UNIjd+F6X2/dEh+uo7?=
 =?us-ascii?Q?lVwTdWKXUKryntEKGdO7DI4tIveafw2Wt6nGN5q8Y5YuaXRuVLZvFkctqUlS?=
 =?us-ascii?Q?oLXYhApsKEvQX6c7KQLXfv13psPgegN44cLlNMRMnCruav6pIAVJ48HxQ2sr?=
 =?us-ascii?Q?VztoA7KE98KDGZZbCTANtYvKpHu2MFenVs2EzFK0UxYNrsm6rjgWKSslc0C1?=
 =?us-ascii?Q?yB4ghDq/0jdMiz0UkO+zvElhL21qLQbAx2SnJMlztsJF6vnK7HrwLUZE6588?=
 =?us-ascii?Q?Pynnnb84rKzNPfzGEcSAbjAAkDyE/fxLJfsj0tVWlrZBi/HLqv+H4+aL4XGv?=
 =?us-ascii?Q?eE+bAoHV7y/E79gj+skljlzYEdkbrHEWArlANq+EFSvA7RsuE9qWUCN5u9/j?=
 =?us-ascii?Q?OUYPqmY1vY9guyeBtPy8sHCpY8icrxjOrJF591CHiEJtwJZ4HOQOgjMwNgui?=
 =?us-ascii?Q?K3MBBQGf1KEm17cd6plPYOMcFuwbMDUKifNCdyY1ZD5OGBSK4SIb5g3Wyfie?=
 =?us-ascii?Q?qJuTaurARyBX8Hom7vnYDIlM1VAGtACrs2MARJxbenEmOYA1FhlkLkjHO3lG?=
 =?us-ascii?Q?fJNWLVZqQiTLWejNNdYZdJBEBeUZgzvooHIEZF/mTLsMvuyaxBuLdpLgxHq0?=
 =?us-ascii?Q?DRkzyoY+yJd9qxq0JFiFiQevd6qhW8o3P10Ll1r0FqfiGboseqTcvM/oJSfS?=
 =?us-ascii?Q?cFnpvKyBQY1OYcW4pDtU+4MgOnbLPoArHgN7TvxNCLqBWzX7CuYxZJjoMGeg?=
 =?us-ascii?Q?XSi5mk1kQL3k1c/dUjXMpOU41vXHJ4+LBeVYKLpTojP6JXo4QET5/Fda/9Br?=
 =?us-ascii?Q?/5YfSxfdioSfUCKs2ZzIwcHjs3tVaq66e6+XrtJCDoQOdH/u9RWub9y5fEDB?=
 =?us-ascii?Q?8Q8dyvhgk78g5eAVvceKWamzMfvuK2D26QRcBcxMPC5oo7aFrKbYB6Fe+MS6?=
 =?us-ascii?Q?2qfOQpB+rho5g7wrMD2MiDEGTI/whpc8u3D3Z5obnbXtAnp2SfNtzhMo9yKe?=
 =?us-ascii?Q?dnxoN/ZOAbrNxQOItUc9CuQ1sl1SSz4Ze7Rpk7XgETrkxchSg9maaghR3a1o?=
 =?us-ascii?Q?8WPCTioqyKZ7LHVBMX74TMYVP653E40l86jYnsT+TxqpwxzMA0kzPQO7ZuIH?=
 =?us-ascii?Q?0OQHNxbYHfw4JhOtkSdT7uQbGv/tIYev8w1jBrgBOprKrulxpwjeI2bWm6yx?=
 =?us-ascii?Q?kQMNYfSK0VZSmR4Meh61Tf5ZbcblsHqjp8pd4J6dV2ogfSShUoYTRUXbBPxd?=
 =?us-ascii?Q?SHhM0OXeth7Ug+Z8BGEdNtNWbyl0SNmAeiqtjX8IBrEu49DwAcuqLpcr447t?=
 =?us-ascii?Q?MFlA7H9eNkLA66GMivmJwXTyEoCHtFFXm9gFYHckbsxrL64Zqu6VqFjRAUBw?=
 =?us-ascii?Q?GpM0ra4Y0nq8E7+AaR5DE4/jbqQ0LBY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9BA0D10D219D5447860EAA47CA390C74@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o2ejINl73Rm/PqfraDb/wJie0Kfb5RGTR8kHZvFf/b27bITKcr0bdkgyt9NjDe3TeSXiI4sD8dO01X7WtTVQXjx2PV8gO1UkwRDQ1EpiDDelDGiiTMFKEQ4XCs97eUhoWsRf5KPU4OhCSRkWf394eZKUOQEVwpJFSHWp68+6dRarL/er8HPCFA4EtO8qLlH1GZEWy6yHy475A3zCHwCh5nfAIHNLRUxU3KHbshdDVjWiWFJCjznKWnBkYv51phYHuAZb2/DE3vQ63ae77GNR56M3gbvFUsKC23B4sKRAqfArz/TSk1018L7zsFO86gJqCxsbQHYKhL0YDbBLmngiHKNhRFGdhzSOCbdYJWIQkAdBukT3Tp15cxVq6JyjrJPpOfnr4KHXRaZCUr0m2N5rv5u+50VnBDCJ6loBKr6H9VWMrgQVuKzsMHUFB1XmEOAlepOe35WlfANH2CVXaEAPatd+Nfy/OLfUuQxP7qeL13GVujDAOG+8WE54Rlvg/OzPdQ6MtpeLuMeRUMpPSugXhz1/mwM05JJq5/F+1UXQj76ABmek1Z2rMueKa0oFhe7RLkQxk238C2zyODNyUsmUxG5+yNkrjiwlI5fvPUsRFLfFaVxt8Kyt0+wUQhM7GdWJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34ca0c2-5b2a-440e-ce05-08de43adda9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2025 12:05:10.8996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y+djuvHpzkNah8IDL0xl6L/wQXrUa5XrunaArMJ//Etf48hKGGBrk0+tndRHbNpyHzmCG8Z1T7SCLW8MQ2KCY7/CRwm3Bs9Wd4vbtacsgVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8958

On Nov 26, 2025 / 09:11, Luis Chamberlain wrote:
[...]
> diff --git a/common/rc b/common/rc
> index ea92970..556581f 100644
> --- a/common/rc
> +++ b/common/rc
[...]
> +# Tries to wait patiently to remove a module by ensuring first
> +# the refcnt is 0 and then trying to remove the module over and over
> +# again within the time allowed. The timeout is configurable per test, j=
ust set
> +# MODPROBE_PATIENT_RM_TIMEOUT_SECONDS prior to calling this function.
> +# This applies to both cases where kmod supports the patient module remo=
ver
> +# (modprobe --wait) and where it does not.
> +#
> +# If your version of kmod supports modprobe --wait, we use that instead.
> +# Otherwise we have to implement a patient module remover ourselves.
> +_patient_rmmod()
> +{
> +	local module=3D$1
> +	local max_tries_max=3D$MODPROBE_PATIENT_RM_TIMEOUT_SECONDS
> +	local max_tries=3D0
> +	local mod_ret=3D0
> +	local refcnt_is_zero=3D0
> +	# Since we are looking for a directory we must adopt the
> +	# specific directory used by scripts/Makefile.lib for
> +	# KBUILD_MODNAME
> +	local module_sys=3D${module//-/_}
> +
> +	# Check if module is built-in or not loaded
> +	if [[ ! -d "/sys/module/$module_sys" ]]; then
> +		return 0
> +	fi
> +
> +	# Check if this is a built-in module (no refcnt file means built-in)
> +	if [[ ! -f "/sys/module/$module_sys/refcnt" ]]; then
> +		return 0
> +	fi
> +
> +	if [[ -n $MODPROBE_HAS_WAIT ]]; then
> +		local timeout_ms=3D$((MODPROBE_PATIENT_RM_TIMEOUT_SECONDS * 1000))
> +		modprobe -r --wait=3D"${timeout_ms}" "$module"

While I evaluated this patch, I noticed that the modprobe command above can
return zero status code, even when it fails to remove the target module. I =
will
add a follow-up patch to the v5 series to check the reference count even wh=
en
the command above success to catch such cases.

Also, I will replace the short option -r with the long option --remove for
script readability and stability.

> +		mod_ret=3D$?
> +		if [[ $mod_ret -ne 0 ]]; then
> +			echo "kmod patient module removal for $module timed out waiting for r=
efcnt to become 0 using timeout of $max_tries_max returned $mod_ret"
> +		fi
> +		return $mod_ret
> +	fi=
