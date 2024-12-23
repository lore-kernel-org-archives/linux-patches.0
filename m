Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACAF1922CC
	for <patches@lists.linux.dev>; Mon, 23 Dec 2024 09:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734946684; cv=fail; b=WoqazCTSn2fQSRcU929P4iozqVbZ6EBKYZjUic/I/DUZbweOEggQUImynURu+WXnTlueCQKC8vNk4qLPtXOtCY1kK4YzACIpMsPF3YYdOVejYDPQB7Kua9TZ05uhF/S35a1gTW/BLeKVZGEYH7zjlhtnIyJnaoSZVbavpXF4J8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734946684; c=relaxed/simple;
	bh=Z1v6vhEOai2hI9WmQ4cpDn0Ue4jPlPrF5lHlIQw4O8E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kY/hi0Pidp90DJyhWr9czXe5ZwkXY/XKdRZJqiKFu4MtoSIpJolkN4Z+uW2PwkOpwCghpOnwItoyfbCNOmMZiGzf1y03MPYxinaPY1SBpWuhyBYeOSUL9WV7IRD4yme0fhjReuyy8FFa4JiFN8z7MESuPK9eoFdK6K8KQoSW7cQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=od7lHLnx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UwiGtf8A; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="od7lHLnx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UwiGtf8A"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1734946682; x=1766482682;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=Z1v6vhEOai2hI9WmQ4cpDn0Ue4jPlPrF5lHlIQw4O8E=;
  b=od7lHLnxOkXUyolGK+CX5dIM2zxtbY+3Y6YUjX85kLNJzctJLcv+VYXC
   2XJg3THWHmZB7SNUTOuKEPR0YuugLjVRBgD07R643/J1N2lU+pDsDEcy4
   NBVZNhccvjUOS4Dw4vpAS/yGLKC5Ptqg9AMf4gDcPV+teF1nPbBwxVwRO
   2hDerrkuYjAa9nJoQsygbxjatLVQaTApZpYq485HYKNfHYAtf+yRXUyU4
   /TuXJvdgSOJDNAe/+5meI9gVToVfgiamvWL/FtYUzYEHM9FiFVG2h4hmO
   MU0EXsl/TmxI7WAnOPuW3DYEySoOQLJ0qNKoFtGLScnvI64KI5drDFMgx
   Q==;
X-CSE-ConnectionGUID: A003r66OQzOgFF/Quuughg==
X-CSE-MsgGUID: iJnOxv4lQbqToz+md2WKIw==
X-IronPort-AV: E=Sophos;i="6.12,256,1728921600"; 
   d="scan'208,223";a="33833761"
Received: from mail-westus2azlp17010006.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([40.93.10.6])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2024 17:37:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e7syq7e57b9J7Fx+ZaenZGa7yw7MCgxGxtrRJq0GXM28JqQxFBWJm9zCAognI1yl4d0fcrTl1OM+4LqqAZnGtfgk7l3l3eZuWIOuvrnPNkeyxIN8sBYCoi1io+FKlohyixRStqBqBth9YTIEeX5uj7UzmyaNtIY9acGi8TYKbdhGRdi1QDoMUdQ/YnJwQZrNt6J33ZI1hGHMeGIlwUX0XTBayLSsst+ODJdOoE7kY6FwcCI68qpwG/miLNcSKxM6rbfDvKB2UmIjwFpSlnSzYl/OXhaeG00iCUxiq7q3zBLPoqr8pUwea6D2Bpxn/g+rOrH/O8v0xA0ApJqtX3zrFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=px/hry/PGlgPoqfeYmKX1qbSTWJfD/5HAPN5l+GeOaM=;
 b=BjS9F3IGZ517c2k86Ymt4TonJCFDzeC5B+axVWsEu1C93eiQGtvVFkmia7mnOEPC3mA9JOOXsgyaNmf5F200bahJhrFIg4auGyk1YRMCtGkJ46a8ySNPgDSi294j35eaoek9Tu+p/gKPxxNo8O0317Lw/cGg/RTWY1NmGQw/DHX3Mb7ogqeazlN7aGzOoje7cS9FnAeqjkW1vFBuNfLYq+mvUMlN7tfLAueplJrVdqxOwjQa+EJwobD59P+0GYQ68ofHDclcXlh/X5kVY4TfxSD0tXVrKY+t8XNjtMWj+JBlaMWquv0jycqJ8NAY7SIWFEfXybQscMjcXcr9dDWmyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=px/hry/PGlgPoqfeYmKX1qbSTWJfD/5HAPN5l+GeOaM=;
 b=UwiGtf8AxGPpM+OAfulytgXK9PWDYhfE+WwGrkd30oVOaJa7qqDslaXPIKbA666neGRcoOSIcF0alcvym2eE9leX81RbzCC275pUb2LckNTrd0X6gX18/ffr/Nm/SFKoGyrFMhQoSh6niISYWBGpea33SwWCQ2Dgo/mtuEGz9P0=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6294.namprd04.prod.outlook.com (2603:10b6:a03:1e5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.21; Mon, 23 Dec
 2024 09:37:49 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%6]) with mapi id 15.20.8272.013; Mon, 23 Dec 2024
 09:37:48 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests 1/4] common: add and use min io for fio
Thread-Topic: [PATCH blktests 1/4] common: add and use min io for fio
Thread-Index: AQHbUT8Rg8K3Z8UZvEifQs20WYF9JLLzmiiA
Date: Mon, 23 Dec 2024 09:37:48 +0000
Message-ID: <dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4@oktw5u5q6jki>
References: <20241218112153.3917518-1-mcgrof@kernel.org>
 <20241218112153.3917518-2-mcgrof@kernel.org>
In-Reply-To: <20241218112153.3917518-2-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6294:EE_
x-ms-office365-filtering-correlation-id: 348d3546-a8b9-4037-54ed-08dd233576b1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?sTz8M+4JqJS5xBB1TcFLijx8M+6D9q66xpyWfaokLT1mPZ8AgoRdcEJWY50L?=
 =?us-ascii?Q?5cQ57AmNFYmzjqJWr4RaaNWT2PgB38CpKz1nocWt1IE33xbZKtaTnTmhocON?=
 =?us-ascii?Q?T0uyWrH3XhmSEPVUBRK85znQezB98NFS8Y2kGL4CxWin5ylQ1o/+5ptAYTq8?=
 =?us-ascii?Q?dkh6R6odOKVRU0E8aYMsZj4Co8585EH9ln9Fur1Tfrfh5/PyAhBaAYmUmg/2?=
 =?us-ascii?Q?whBLEhBA3IojKb40rAMyTECOUmNyixlr/X4i+BmcD41ophDg2dUwOlCL/4Aj?=
 =?us-ascii?Q?D3FJXWkO65rcBZJWD3V964ziq2Zy27uJA9ZU1FQzkpF+ylykghZTPwATSyzE?=
 =?us-ascii?Q?ugS/WTtPp712hR5TZheDtF0hrkUjoFwWoSPVdt83tQakkmZU2uOyXkClW+ae?=
 =?us-ascii?Q?fMxE2PqahFBcPYvSyt7fINEiuMyV4zU6eA930uU7AkJxCa0iDYxDJwrQ9b3D?=
 =?us-ascii?Q?loIMDVQv2GmD7v8OG4JJbB9vyYOLm4Kuj2nC8WRNkIbia+1bmqccVVc+MBoW?=
 =?us-ascii?Q?YeGDrjKeaC8KCiNohYKpwOUhTbljHaH+1fadAcBoIFAIqbe1rlHN74xfPIQ6?=
 =?us-ascii?Q?OdnWcKHc6XKTFDshxv8EjDtcmihDkMGZyDD3lZYU27d8aj6FywFqFE71D6Zq?=
 =?us-ascii?Q?scWcjlLEZSTJDXbt4oblYkxZAOXnf2rRFo2q3lJICW1RSIDfhR3NJJqeeSJw?=
 =?us-ascii?Q?+2r9VPCIS3cqit+Z+CcJNP9jTglyEu7GdFlT/nI9OJQfnZWBPxOc9WZUMTYH?=
 =?us-ascii?Q?E5KoxF8zgOOAZV5uwZicyT2KAfNBnFX9Q3hA3x2pwAlP8SVCaekcz9VkxtvT?=
 =?us-ascii?Q?IN2FieUAImy4l591jMMl8nymP2MtJNMzpC+9SybAKcYjFNdJWQrBQuFpSRfm?=
 =?us-ascii?Q?ii8dH7eCxV6ElCPrrT+KA6xEgoP3LcbRx+xTLElPQe9P8go1PhZCoGEmPqsS?=
 =?us-ascii?Q?Ro2bPGdpzDQXrPlvUGD2zzjnYx7NtE1Z77VjTWCP/3RMNIy/iI4QLnsjC9OD?=
 =?us-ascii?Q?qJaa+r5bQEzApvAtEg4gGaywOb4CkO3ix10OT9+rtd/hWsc+k7Xq7GSZiUVH?=
 =?us-ascii?Q?lomDNVIBywLcfsvt4W4TMpykaYiqz2ecl9egWsEPyyESOvYHXQgIuhkiAz3O?=
 =?us-ascii?Q?VaVbYiW+1fbyrFXEfO2f9iBD4HIkO0td42WbsRS5FSjHRcEyIx73mB4lBxjx?=
 =?us-ascii?Q?bgAh2tE2Fp69im451GsR5uO790LrMd6auCQMNQfLwnBRl7gSHHggXAbRIwXt?=
 =?us-ascii?Q?vP3iicjIcy2c7q/eWBrUQCgQCUcO68kyMiB7Wu+/fQ3lDUrAyiWdQR96g2NT?=
 =?us-ascii?Q?TXimpTc8+AB3ZSZiJ+0tZo6wXhJOpq2kuiGC2tQtWYKP4QdjbwsahrpS3F+X?=
 =?us-ascii?Q?16iZjLa7LPTJfHXU5yZpF+4pPZ56kTwzgoAeyRzruBqtwSff+sdU3YD/yWlP?=
 =?us-ascii?Q?Utiaal63RCeUG+HHs/j0V4pH5SaizBSu?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?HzA5NXgc2P8ISRroC6c97JsNdmVeJ3RLab0boklkIL1EHUPu5PMibAOVIbLg?=
 =?us-ascii?Q?iY4RcYsl8JZNIwJSXyxGyCLLrP/Vmh3i9e8IzFPP6/yxsU2281Eqye40Ugem?=
 =?us-ascii?Q?BlYKtKJOUeaR297ox183Ks5kPCNnRRnLQi51tprIPkBk5ZJyVEt/nBmnpHU6?=
 =?us-ascii?Q?FYq/MswUNeFHW8Wcj9KWC001fkMn+Hsy36JR84SXwc7tGfxLNbtacRhEpZMS?=
 =?us-ascii?Q?pWaRCZrMKh5RF2DP2aXyR+Mwy+J9mMSpVZTX6th73mTtdycXC6AC7myKyb6z?=
 =?us-ascii?Q?1p6oGvQ8Ao2My/SKZ4FFPI2yWm3tLZNvopu6m5QPy1MSzTivf3rnbwruDWnA?=
 =?us-ascii?Q?iz7M6QjRgUKAhbBiDCXa4zZfiaiqjKC97CtazrRCKZkYkW5Lt7zlPHBhGy7I?=
 =?us-ascii?Q?MTajoaBReG64cp3Eae2bSznv4uA1pxze4grtuN+iwVXAo8elChDHrQDzf66Q?=
 =?us-ascii?Q?YLU2PrXl59s7/wJK7F48cFhUy9hoSvCO+/uIjCKcy/gN7gK+sekt6btr+RV+?=
 =?us-ascii?Q?WN2Hxdx+Za6f2qVk6eEEW03oaZU6aU3GFECcwSXCG4FS5OWoQum1M+XQWmb5?=
 =?us-ascii?Q?n8fRc9xBvypM7cU/mMibo69qDmlNSNiLBr7omSK55Xxa3ZHdnyokzGBBINbe?=
 =?us-ascii?Q?BNL9YuOztfRPDYz92RtHQH97fCuM63qFlLICO4hyjo3tDDJqUjedDVpET/S4?=
 =?us-ascii?Q?U73NeeWv0KYb0nC2SYd1nuzxOQCGI3cFWLmhrtkR81zJc6yBuUG3BYfyYMc1?=
 =?us-ascii?Q?MFvm6SuUd6E3cwiuIJPAKbGcXlyNQSf/Kdv8KZVi56Qn4mIsvDweFdUxWO0+?=
 =?us-ascii?Q?T3ViVTK2KiPc1d4WaheW4Z1pGu0OkUNKZf3cwS81evCtfxMtuNSFz2V+nL5W?=
 =?us-ascii?Q?YFmSKlYp442aDy5foQsZKoGT/zprPznqMgVoWZy95i7JPTrM2bKAgZr0FhX+?=
 =?us-ascii?Q?oB2LX3KGBTLU6pfF20wAw586kmx4c9nFUMBPwKojAicUFdXvzRY4PyzMAeAn?=
 =?us-ascii?Q?7BfYOYbYJpPdR0tomqFH7lqQNIWFA+QTDvyCpXaeVvV5UFodNI/SljB/ZKlR?=
 =?us-ascii?Q?D0zwBBSx6Ap0Ssse8URquqxNHpxQlerocPqcR9H+NYWSvtA1SX8KgYjcAnKB?=
 =?us-ascii?Q?gKrRZbRAmIQwiphcct87J7h6fjdB9WdSbymvfL2eEqGvuqcOnE/9fGqdVzqM?=
 =?us-ascii?Q?N8FP9cK/NizyECiCJ1fpe62FHTKsZz4tW3+DB7QMjdYMT/0njmy+0uFH8dvw?=
 =?us-ascii?Q?Hy/c5SgswTioifH/ogjg3M3obiHyFjf/uZ3QrgQph4zXZ0ehi5XhkfW44hxA?=
 =?us-ascii?Q?D+gpXBVeALkDKohpUvtya7jiNWRJcsEPlQOcoyg+TT3saNKfZ7x62lIKeCmA?=
 =?us-ascii?Q?uTcmEga42YB6+M2hgLWnvgHSi1J8x7sD19ZFRuGc9d3Y2il0R1bn7lOsMkdg?=
 =?us-ascii?Q?KtBxG37uxSfSnJoavrk+/p3306cIMKFNoCuqWef6f2Y4vA/0nZTA3LH2kB9u?=
 =?us-ascii?Q?98wEOG0PejOhsK2XfwkUZKk8CRqVzRv1evkkLvNUiCtxJP/tZyDRKhGhp9pr?=
 =?us-ascii?Q?VthXcGmHFtpEASCz6RkUACWZGF4ADJNYC3lNHJAzMZSwlgVvGzuAJsbUBYME?=
 =?us-ascii?Q?ppTLMNfdXWWy2v4uRAvd+y8=3D?=
Content-Type: multipart/mixed;
	boundary="_002_dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4oktw5_"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xsJunjIqxE1we413RyHilC/lH6uutZb1MjfaOm50ZapYdhRYy8Vbv2YN0FI1DWPPcaTDRHyYp0YXbK9j/qB/MSbSncepPeXhqNj/pG6sKrF030s40o+E9cMnxAwFljXGkV9At/M3NqzpNUGV1Qn/g0FZuYnSWXiLOORzSrmF0qT+N/zvZ7kZleDh+Iu3mhVDhcc5qPgoLKUDZpIRKfbQ7g6Kvn8lLHyzEw0IfVe8kjJgmPRViQiKKWEkLV1Mhaabek5xnau4WULsN2oNanC3IdmTo7c5YRx/kwHF2nO+CIdO6GK238nYNREWMoJKO55GGCGJcAByL0hWB8RTIJ7KPqNK1AAgKMR2FaIHcWD49oAaf7frQxE7x7R9Y8w/RVt4Wz5YvsM8rTIQaPSffY5WS9tLJc8sH122OKN8IpTOVgPp4kP4YTxnkkQr9q2p5uuCMOd3su9xMCrOMSRB9hUzdlRaYCHsfRa1g8gZuPZDZi2QYRl4xjRljyxjqE4eKwlN0TSFjNlT7FGtMmCit38RoBGSznge5iS3dsibj+EC+pLypHLCvZ1+cwNkMFzfaayzF0j/s38qNU5EdclfuDbHV5Fb3Iws1zLCThxr9RQ2IL0uGG+bpIxz1odkE1ZvSVMA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 348d3546-a8b9-4037-54ed-08dd233576b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2024 09:37:48.7627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddcigAVRTK+Qe5jsk7PbzzgraN1KvcwEs0aGiMqCfNysib1Gyvt3xpwMawk5q8cboYEnIbzQapogeOlrCx+cBfS+mfs8VjSiayEdzsjeaPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6294

--_002_dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4oktw5_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5EC63CE9054C3D4EABEB2CEC95F29214@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

Hi Luis, thanks for this patch. Please find my comments in line.

On Dec 18, 2024 / 03:21, Luis Chamberlain wrote:
> When using fio we should not issue IOs smaller than the device supports.
> Today a lot of places have in place 4k, but soon we will have devices
> which support bs > ps. For those devices we should check the minimum
> supported IO.
>=20
> However, since we also have a min optimal IO, we might as well use that
> as well. By using this we can also leverage the same lookup with stat
> whether or not the target file is a block device or a file.
>=20
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  common/fio |  6 ++++--
>  common/rc  | 10 ++++++++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/common/fio b/common/fio
> index b9ea087fc6c5..5676338d3c97 100644
> --- a/common/fio
> +++ b/common/fio
> @@ -192,12 +192,14 @@ _run_fio() {
>  # Wrapper around _run_fio used if you need some I/O but don't really car=
e much
>  # about the details
>  _run_fio_rand_io() {
> -	_run_fio --bs=3D4k --rw=3Drandread --norandommap --numjobs=3D"$(nproc)"=
 \
> +	local test_dev_bs=3D$(_test_dev_min_io $TEST_DEV)

Some of the test cases that calls _run_fio_rand_io  can not refer to $TEST_=
DEV
e.g., nvme/040. Instead of $TEST_DEV, the device should be extracted from t=
he
--filename=3DX option in the arguments. I suggest to introduce a helper fun=
ction
as follows (_min_io is the function I suggest to rename from _test_dev_min_=
io).

# If --filename=3Dfile option exists in the given options and if the
# specified file is a block device or a character device, try to get its
# minimum IO size. Otherwise return 4096 as the default minimum IO size.
_fio_opts_to_min_io() {
        local arg dev
        local -i min_io=3D4096

        for arg in "$@"; do
                [[ "$arg" =3D~ ^--filename=3D ]] || continue
                dev=3D"${arg##*=3D}"
                if [[ -b "$dev" || -c "$dev" ]] &&
                           ! min_io=3D$(_min_io "$dev"); then
                        echo "Failed to get min_io from fio opts" >> "$FULL=
"
                        return 1
                fi
                # Keep 4K minimum IO size for historical consistency
                ((min_io < 4096)) && min_io=3D4096
                break
        done

        echo "$min_io"
}

With this, the desired block size 'bs' can be obtained like this:

    bs=3D$(_fio_opts_to_min_io "$@") || return 1


> +	_run_fio --bs=3D$test_dev_bs --rw=3Drandread --norandommap --numjobs=3D=
"$(nproc)" \
>  		--name=3Dreads --direct=3D1 "$@"
>  }
> =20
>  _run_fio_verify_io() {
> -	_run_fio --name=3Dverify --rw=3Drandwrite --direct=3D1 --ioengine=3Dlib=
aio --bs=3D4k \
> +	local test_dev_bs=3D$(_test_dev_min_io $TEST_DEV)
> +	_run_fio --name=3Dverify --rw=3Drandwrite --direct=3D1 --ioengine=3Dlib=
aio --bs=3D$test_dev_bs \
>  		--iodepth=3D16 --verify=3Dcrc32c --verify_state_save=3D0 "$@"
>  }
> =20
> diff --git a/common/rc b/common/rc
> index 0c8b51f64291..884677149c9e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -387,6 +387,16 @@ _test_dev_is_partition() {
>  	[[ -n ${TEST_DEV_PART_SYSFS} ]]
>  }
> =20
> +_test_dev_min_io() {

I guess the word "test_dev" in this function name implies $TEST_DEV, but
this helper function is called not only for $TEST_DEV, but also for other
devices. I suggest simpler name _min_IO for this function.

> +	local any_dev=3D$1
> +	if [ -c  $any_dev ]; then
> +		if [[ "$any_dev" =3D=3D /dev/ng* ]]; then
> +			any_dev=3D"${any_dev/ng/nvme}"
> +		fi
> +	fi
> +	stat --printf=3D%o $any_dev

According to "man stat", "%o" prints "optimal I/O transfer size hint". Then=
 it
is not super clear for me that it returns minimum I/O size. Instead, how ab=
out
to refer to the sysfs queue/minimum_io_size attribute? The following script=
 will
do that. It relies on the patch attached, which introduces another new help=
er
function _get_sysfs_path.

_min_io() {
        local any_dev sysfs_path

        any_dev=3D$(realpath "$1")
        if [[ -c "$any_dev" && "$any_dev" =3D~ ^/dev/ng ]]; then
                any_dev=3D"${any_dev/ng/nvme}"
        fi
        sysfs_path=3D"$(_get_sysfs_path "$any_dev")"
        cat "${sysfs_path}/queue/minimum_io_size"
}

--_002_dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4oktw5_
Content-Type: text/plain; name="0001-check-factor-out-_get_sysfs_path.patch"
Content-Description: 0001-check-factor-out-_get_sysfs_path.patch
Content-Disposition: attachment;
	filename="0001-check-factor-out-_get_sysfs_path.patch"; size=1525;
	creation-date="Mon, 23 Dec 2024 09:37:48 GMT";
	modification-date="Mon, 23 Dec 2024 09:37:48 GMT"
Content-ID: <0C8BE78FB6C9A74FAB447F40F74078A9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSA5ZDkxYzA1MjhmNjVkMDFlMjBiNGQzMjZhYWIyY2M2M2YzMzA0NTU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3
YXNha2lAd2RjLmNvbT4NCkRhdGU6IE1vbiwgMjMgRGVjIDIwMjQgMTU6Mjc6MzQgKzA5MDANClN1
YmplY3Q6IFtQQVRDSF0gY2hlY2s6IGZhY3RvciBvdXQgX2dldF9zeXNmc19wYXRoKCkNCg0KVGhl
IGZvbGxvd2luZyBjaGFuZ2UgcmVxdWlyZXMgdGhlIGNvZGUgdG8gZ2V0IHN5c2ZzIHBhdGggZnJv
bSB0aGUgYmxvY2sNCmRldmljZS4gU3VjaCBjb2RlIGFscmVhZHkgZXhpc3RzIGluIF9maW5kX3N5
c2ZzX2RpcnMoKS4gRmFjdG9yIG91dCBpdA0KdG8gdGhlIG5ldyBmdW5jdGlvbiBfZ2V0X3N5c2Zz
X3BhdGgoKS4NCg0KU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hp
cm8ua2F3YXNha2lAd2RjLmNvbT4NCi0tLQ0KIGNoZWNrIHwgMTkgKysrKysrKysrKysrKysrLS0t
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvY2hlY2sgYi9jaGVjaw0KaW5kZXggZGFkNWU3MC4uNmY4MDEwZiAxMDA3NTUN
Ci0tLSBhL2NoZWNrDQorKysgYi9jaGVjaw0KQEAgLTY0NCwxNyArNjQ0LDI4IEBAIF9ydW5fZ3Jv
dXAoKSB7DQogCXJldHVybiAkcmV0DQogfQ0KIA0KLV9maW5kX3N5c2ZzX2RpcnMoKSB7DQotCWxv
Y2FsIHRlc3RfZGV2PSIkMSINCitfZ2V0X3N5c2ZzX3BhdGgoKSB7DQorCWxvY2FsIGRldj0iJDEi
DQogCWxvY2FsIHN5c2ZzX3BhdGgNCi0JbG9jYWwgbWFqb3I9JCgoMHgkKHN0YXQgLUwgLWMgJyV0
JyAiJHRlc3RfZGV2IikpKQ0KLQlsb2NhbCBtaW5vcj0kKCgweCQoc3RhdCAtTCAtYyAnJVQnICIk
dGVzdF9kZXYiKSkpDQorCWxvY2FsIG1ham9yPSQoKDB4JChzdGF0IC1MIC1jICcldCcgIiRkZXYi
KSkpDQorCWxvY2FsIG1pbm9yPSQoKDB4JChzdGF0IC1MIC1jICclVCcgIiRkZXYiKSkpDQogDQog
CSMgR2V0IHRoZSBjYW5vbmljYWwgc3lzZnMgcGF0aA0KIAlpZiAhIHN5c2ZzX3BhdGg9IiQocmVh
bHBhdGggIi9zeXMvZGV2L2Jsb2NrLyR7bWFqb3J9OiR7bWlub3J9IikiOyB0aGVuDQogCQlyZXR1
cm4gMQ0KIAlmaQ0KIA0KKwllY2hvICIkc3lzZnNfcGF0aCINCit9DQorDQorX2ZpbmRfc3lzZnNf
ZGlycygpIHsNCisJbG9jYWwgdGVzdF9kZXY9IiQxIg0KKwlsb2NhbCBzeXNmc19wYXRoDQorDQor
CWlmICEgc3lzZnNfcGF0aD0kKF9nZXRfc3lzZnNfcGF0aCAiJHRlc3RfZGV2Iik7IHRoZW4NCisJ
CXJldHVybiAxDQorCWZpDQorDQogCWlmIFtbIC1yICIke3N5c2ZzX3BhdGh9Ii9wYXJ0aXRpb24g
XV07IHRoZW4NCiAJCSMgSWYgdGhlIGRldmljZSBpcyBhIHBhcnRpdGlvbiBkZXZpY2UsIGN1dCB0
aGUgbGFzdCBkZXZpY2UgbmFtZQ0KIAkJIyBvZiB0aGUgY2Fub25pY2FsIHN5c2ZzIHBhdGggdG8g
YWNjZXNzIHRvIHRoZSBzeXNmcyBvZiBpdHMNCi0tIA0KMi40Ni4yDQoNCg==

--_002_dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4oktw5_--
