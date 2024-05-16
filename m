Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAC014D44D
	for <patches@lists.linux.dev>; Thu, 16 May 2024 15:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715874784; cv=fail; b=VflKCypqyTQqmK+QUE4MFngYnFsnO2sLoM39UwrDsXzwiZw0wZBhVUx4tkK9soZBC3dQZP+oPY8mS7xqzyLxgXRc6ZaSwBDNV40rl3qTGa3qFwIDNvXbC4jtBWqc7i+OBaMVKhrGkeN/LLOCFiTj48U1RqL1eIxKhEFOnasaaIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715874784; c=relaxed/simple;
	bh=lOlw0lnDMblu7WIwxRkQA+wreQAPKpNu3TfEB2ZdNCQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V7+Oo7O08qbbpEoozyCPNbX/i2We5aXi/c8TSuJ8G8Q4Y1y4xFRLjxwUT08jjsg0AId9Hx3TCYJaeYQYk9sedf1+/QHp6GEqgK36fJmpeub+uRfRXBrRTNqRTy3fRIM9HfHkS30zY18WYzqnxmC1wFPabm/pC4hhkiZ9vbcoEio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cFCcnT+8; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cFCcnT+8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715874783; x=1747410783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lOlw0lnDMblu7WIwxRkQA+wreQAPKpNu3TfEB2ZdNCQ=;
  b=cFCcnT+8I3u1ycRNiO6cNBzFSLN14XMK4/iGdDakY/FdX4IjGv+lojrI
   DeNQpqTrCixiGUixySBPvLHZiJBixoL1f/gMQk/L29HiQ+Wj5T9Qmvfoa
   al+IrCQtgfI+H7wrQGAis1extDHJjOlX/hhANqsTZlqa/O3x9CdXoj5OV
   YnqbktVIoRr1ieCIu1ARgEN7sD/D6ih3KUFnA4p/zUqLstgThYWlOA1a0
   BXjkxOxxdM86qGvlM4FuyYNJ5QPLWx/mUvGqvpUZoWh8J5JC5ewGSDZ4J
   B5HWNaKyIJ2oMXFcxFHPX5l/2MYHAvDdZXqQNLGZpFNcchfZctbt+cnX9
   Q==;
X-CSE-ConnectionGUID: hAojN9D0SlmhM1dq3qJGoQ==
X-CSE-MsgGUID: e13uej2xRDecvvyznLcHVQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12122861"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="12122861"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 08:53:00 -0700
X-CSE-ConnectionGUID: mP12yLcZT0eX65MJbDzQbQ==
X-CSE-MsgGUID: uOCd3zuwR+mKjjg9Cf0jog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="54691571"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 08:52:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 08:52:54 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 16 May 2024 08:52:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 08:52:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 08:52:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hx4BrmUskr6ckinnbmtY+jWXlLrKuQY1ChCJQgxmFCgdg6Hpz4L+q4/i8XhmS9zqJA+5FxdFNu6HQ2xHdBGt4b3+fqKQa8nxmCCvnj+I9R2LUD+GZSw7Pw+XnmqEeBEki8l4jApaCGU+kBHtYo7fDmINXKjr3d7XVMzrFA2srSh61G8xwrKYgIaSONUEJLtpartbX9VXmdETkz+QMNpyVfY/n7gS0YMuWlri1ubfsU9cohKHN2jq2bqAz6HHoMHj+dxnHsE2dvAaVO7bxwoXo0lhhMfMfb7YHkymuxSBBi7yyFXrvqmsIiHpDvHrXDCFnpcGYcc5AFxkOLbYtIJcVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOlw0lnDMblu7WIwxRkQA+wreQAPKpNu3TfEB2ZdNCQ=;
 b=lOOFWqSMjOsRgRrzEZtrAnWZxKSjGXGWtDXNpd4JQqd1SLxCoebB16BEGLqPvmzAtKw4cuec+hIckLgtcGqizDbqOMeA85lP1CHCKPB5UFRSiRN6ANlIzA0+p0raO/YagSXhqugOrzxRKmuCbRRd54VX2J+bAFZ4ajBN4Cy6QoXRppLButD6/tb8sPSsG9SmfTc7slogI+qW20ypmU6VW56EJZRKfnbyfaPF2KAXdbbfGVhAr9m4/Z3a0Dq5IzS5u8js167j0I0m+23v5HJ09hNpXI+VbI76Xe/ELu7dyr78OFHzUQbctkCQCDnanhKs+UYaXTDQbEQ9Io8TIriPHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW6PR11MB8438.namprd11.prod.outlook.com (2603:10b6:303:241::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Thu, 16 May
 2024 15:52:52 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 15:52:52 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "James
 Morse" <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v18 00/17] Add support for Sub-NUMA cluster (SNC) systems
Thread-Topic: [PATCH v18 00/17] Add support for Sub-NUMA cluster (SNC) systems
Thread-Index: AQHapxaK0NMfv5GFF06CTAGV84/rbbGZmKOAgABrC0A=
Date: Thu, 16 May 2024 15:52:51 +0000
Message-ID: <SJ1PR11MB60832486378FBB09225AA1B6FCED2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <6obc3orsktj4dcrl4nw3qo7o2dth3s5np6cyq6fllweq34iqlc@ku5cf7kigh4a>
In-Reply-To: <6obc3orsktj4dcrl4nw3qo7o2dth3s5np6cyq6fllweq34iqlc@ku5cf7kigh4a>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MW6PR11MB8438:EE_
x-ms-office365-filtering-correlation-id: 7015ab4b-7659-4f4d-9bd4-08dc75c03e51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?UQgYtZf9teeh8RmDvOqldbVSre6J+w1GFcVBd3OOKkChD66KMziEKI8V0l/o?=
 =?us-ascii?Q?yYZl+P4V0Sh5okB+wP4d91Ox/LXpDIvjxAPUwL1VVLdaal6AQqt/UePmpyyM?=
 =?us-ascii?Q?R7dzEKxXDEbgS9jxnVqv+qkcgSe2EqqtsrRfHsGgyI2gRVfnbOwSzGJ9bYUO?=
 =?us-ascii?Q?3fign5BaxPJMmqfk97WI0+VvCfszQuxANxCJWSLZbpM0TkQm843pZfbU05lN?=
 =?us-ascii?Q?mJm9aiobOD9tT5SmBBN3G0Om3e1BRCL/LGIdG60P78+JvarN6mFZ1LKlUb/N?=
 =?us-ascii?Q?1T4ilWf+U+Sh3zH8v9oRrFEokX5BQGLZcfj81+yG4LB1CYzjjQHrxAdyuRTs?=
 =?us-ascii?Q?IitCdeU8FA/bNylUafviZdx7ftptwJaxdVemLIjlEdH/qS77eRNZznqvciJc?=
 =?us-ascii?Q?yGapbpaodi1RrWAaF7x5v5XADg0jqzLpL20wurP11CETtdChMRDzEk9bX+d2?=
 =?us-ascii?Q?1XS1El9yrXaEAlUYlxShGoa0zAlUer6XojEcX7EaiTLAjsWjPPIujcNCqVgT?=
 =?us-ascii?Q?oB810CLxK7yTZbHNcmeRqSQl9/XmFAwU/sY1b2Ul13yiBJHXThCfuOsWZa3Q?=
 =?us-ascii?Q?e9mZZIH8mjr+O7evDU1bzr3IBS3nuHVnRBBmkQ9hUrP+5+yTzOjtfFSlTw76?=
 =?us-ascii?Q?BPonBRMM4Fc6vB0t7RF4k4DotjmzJUpwyx4AifN6fm4+I5ZP2QsuDVobzA5L?=
 =?us-ascii?Q?1zB3Y3bn8uHn4DmPgIx5dZtZu+GOmA3rm5294VP2eMbToNibOxBo0aK2g4wD?=
 =?us-ascii?Q?QKCO6wrO5SfPuUwzPEeligNVdSwotD5GYAyQZnQ2F19GPxeDWdZEWrMsY1Yv?=
 =?us-ascii?Q?36/GDPopYXEoM6WpMeS4VPypvQ+WO//JkiT8n9vJ7CKDVvz7M+cXswMtQsmL?=
 =?us-ascii?Q?RL/AJvAF0+OHIARc0JbDLGQJCXfOPbU4NJg66j34nqdjddpVuEuADJUNATq8?=
 =?us-ascii?Q?M9+HwQk947/6crp7xlEbL88qq30TLIb7BZYELN57cBIhxdMa7NM54CTZh74F?=
 =?us-ascii?Q?isNSnOGAoYlsoPgnnx/LUxNDxA1Gxx4ia3W3IS9w9GVF/8lMJ2f/av6PIh7o?=
 =?us-ascii?Q?2gSzkDPcOCKWx1psgasfkxBGw8/DRPHeI50rIvoLk/jMbgTraQEH5/r2XZTt?=
 =?us-ascii?Q?e7Aa5cVO6YbwMPbqJUJicMx4JSv4vKruIslZ44fTq5Zte6CK9kq7DlCCgpLS?=
 =?us-ascii?Q?0tz2sscQ+dbbigMB70EiQzLZ/OrbQiIpg32h2t8wyHGLoz0adv32uuDJuxKN?=
 =?us-ascii?Q?rVkO2K/bVfS80WBuPyehcOztfE3M9LVnFTq/84f2qX+6LG+uvwkKj0H+MxPi?=
 =?us-ascii?Q?nRdwOgTBTVjFtRSoCwFN5aE55MAuFt/ySxpnU1hMM4DYRQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8qJX1ch9nbZgeMlneVoq9RtCqPMSeIUMT0aPaN+ZVAaAfHBOuF0CKTuJspCu?=
 =?us-ascii?Q?z3O08O/gz96EiTPvv6iQNTbRp1hgJeTllhP8XdqhrLHpsaV/OmFCXoOHLORL?=
 =?us-ascii?Q?48Kl8ZIxPH8eNWQYfn1j5zkhcMl+jeG2Tucc5D7uYjf7DNOjhcW0PZNTlMXV?=
 =?us-ascii?Q?iq0LqmiuhYyIaHeov6jFloxwsTmTeDZEiEYn+vJ7Op6Kz8C7kt1Oro1r+CBw?=
 =?us-ascii?Q?g0LxYJo6sUJaDNtJ8DyyaZusSFxmt76E28tByOQ3kabnkvnIHA2oYznZYAsB?=
 =?us-ascii?Q?I8KD3Xz9FQFpzrb+LESBifpAZSuLQ3GWOFM0/aoRvFCP7VKRhxn+EQ+GX0iA?=
 =?us-ascii?Q?w2QGz4j/P2fTvg9RPiPRCKj3cuCX9Fla35d3dezPnW5zTZ8jh+0vqRkrtXyC?=
 =?us-ascii?Q?2u5yJYS0eBJaxBINNLMaBg6vuYhPfttDvanQB4HpYB3tM2bd+8b2nKAGwyMk?=
 =?us-ascii?Q?WQ42ozcqK0Q3IP29oMReVn27EooXDZY7CT1YlJ3Agar2HkYPf46IJCJih2xs?=
 =?us-ascii?Q?J6NiCRdAUYiqSNYhW+LTTOhxEYGsE/D3NdmWlRIsHQfLB534gr1ASVmBgzXh?=
 =?us-ascii?Q?/Asu2rWphri82MRX0l5O8SLrFDAFliR+fiosGBMQcLnpqCYr6OD/M0/Na3oE?=
 =?us-ascii?Q?/duSSP3rHmi0NAMsHGSWxw4VoC4T/9f4fjmHLKtfALSmK0jKWRTM4TxYyerY?=
 =?us-ascii?Q?UnbmMFtAYoPMmbNyrawT/n3hC/pn3v9oLX8TG1u08fb2Z5oK99Ux8n0fB8SR?=
 =?us-ascii?Q?D9DxghOZkKY2A0RDdrP96ycEtBJPiinyKpicgo1DUkAx1GfBQl7pVZT84D04?=
 =?us-ascii?Q?6gpH/FXWG/aKv6SDokw+VzHruSEFEgo+G6rjroATXK1h/hThgmea3KXFqIHZ?=
 =?us-ascii?Q?CUjs1qS9JB4QvEiCLBi71s9kZTolXpF7vFh1DN4mhpXcCW2p3hs9GryuSMZF?=
 =?us-ascii?Q?TBj5L0cswdC++Y1c/XRxYp73/qk1oTA3kjaM40E+skX7hnnaCFEKUJWSEGBN?=
 =?us-ascii?Q?eC2gvqIZXTRpwR2ioe7vUAEBvrFAY2a6AVCIIo2+xV6TvNKTVZe6WqxPLgNe?=
 =?us-ascii?Q?reWjn2gyHE8eeQqR53M+7yq0PzGAmu9vglt31RyC3KwSe2vEg43S7vV/x+/I?=
 =?us-ascii?Q?5sRsUICreyCkanpSNHa58qvgNk7D/FxTcAJ+dLXgaIMK4NdJ33MUBWcQnlgy?=
 =?us-ascii?Q?JCfbI3xw4xCNAWQFF2fUS/2yk1yyc7awVxRN9PBa24Zy329bOvnIX0XSL+Jh?=
 =?us-ascii?Q?ccQ6v0x06VV6nGSNRuS7C/odTF9Vh4a32/1HIl1U5PqKJTeMPUuNhtM1FFLI?=
 =?us-ascii?Q?pBiYp7J3IYNJEWg52bJe3qJfiK+nh5QJwU+NCg2M8CLp5Aht3z9rs1c/Cgbb?=
 =?us-ascii?Q?JBiuf7n5aLCQSY6rsPYaBcLHO9lJ25krJeBpCu9/LGWOBbeWoLjQ0JuxVp1h?=
 =?us-ascii?Q?AqUqf63YMQ8ZvxwlCyaQmfO+spH1/uOlA4HOfUpAyxbxa8byHt+u3ngR/j1Z?=
 =?us-ascii?Q?+fjeGvO/2TkjUnIkZ4tc7jSkaGfCINEaB5wooXW0pBpcmtx7AX3sp4vX4nwl?=
 =?us-ascii?Q?zLtYPxPqkTfRkMWETF0BcOqIAOucfI5olrJ5f5RI?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7015ab4b-7659-4f4d-9bd4-08dc75c03e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 15:52:51.8986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HhtA8urJy2Z3DT0YfD6SbqlYLbzI3DM+EDrAlOO4VnBvJC7sO9xDAzvztoAt+7U/BxO6RqD5HqOFaKKP6oTRNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8438
X-OriginatorOrg: intel.com

> Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

Thanks for testing. Also, for the fixups to commit messages in patches 15 &=
 17.

-Tony
