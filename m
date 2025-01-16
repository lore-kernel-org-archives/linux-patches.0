Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8F615252D
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 07:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737011837; cv=fail; b=odShNPfAZ6C36L6sdrQU6F/9T+zItbiB5TaTEmynAOfgy+rg1XbEEmH/7Z7LwzaqclWGSC8DPbpD5gSWzyYMWTlc+ZPbvsrtnSsCYrGRizvjI2Xc0f3m+SosM41TKQCk2n+9lq+Om3LwoCJjGZ3aLjBwnVeZ60z9FTZBZ6/6PdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737011837; c=relaxed/simple;
	bh=oCvFYWQXJo9fR18ovnU8/OzF9EZ7yHbt/j9hzJuMEz0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rcAkXEm9HSWCixWHZphjiIG3kToFGj0feimHaR7hbFn/cMRCarJCBAlP0tdgnVk2ixnWmb8SjarPqT2+MjDiF/JvMaQRlGbb1PdS9dVOaPqCVtmPaD5z0W0rJagAdEaj1gXhj7MiYGe3ktPzQpE8qTszaf+uZiFIdQK/m60yFwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XMauU3ZF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nl3JzEQ/; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XMauU3ZF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nl3JzEQ/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737011835; x=1768547835;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oCvFYWQXJo9fR18ovnU8/OzF9EZ7yHbt/j9hzJuMEz0=;
  b=XMauU3ZFwXjiKVPb7lycASAVvVFaqRZwKuG8y0z6RY+MVqV9Rfofa/PP
   SFXGDnu6IIJpchLkYcFIHWO0m7YwulUDwl4tNFynzUET3iCRJmPNM5dWq
   OnfVf8A5Zg3O5pX0g8Qq0HkEmHI/W2WiOiTk+DWsEzb+PSqppw3fWTQF6
   KrPt3ZIuLTngSqZUILc4gRCfr1VwBHrLT8BdosKT/jQ1arBxITMQ+x3A8
   kFZSRBnG1WBpOtwVHFE+J2rYOJcZyXHacLd1rjLH0Nz7Dr4ViFIFcS7/0
   p8xzNjfuOXBRhxNmpu/o9dzB0xJ1dGm5E2IKZTiD+grkGbUNfwvJHcwr/
   Q==;
X-CSE-ConnectionGUID: 06h3sJp8Q2SXJOz8/6A1QA==
X-CSE-MsgGUID: 4QGZTbvlTmGA6A1LU0OTVw==
X-IronPort-AV: E=Sophos;i="6.13,208,1732550400"; 
   d="scan'208";a="36575338"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.10])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jan 2025 15:17:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKDw6+r4hF1cZPFEN2o4tGy/G5OAtSkqB8HYBNFl5ZT6MOEI3V5w5FjYLRWIJQxGO6Qig8fyn29A4KU0IeK/A2qvusM29PmORKSbHBOOx7MwlScI92ncpvuCBFcxyUftZXuNwCKlyIctE41aVIe9mqt40klvdms7ZHCN6PLqMowvyzzRo+otOV16hXF8FBxVMT9O6PetMh9ivU2Iy74Swkt8OWVH+bkuLfpev18xDK7qtSE82fIYOfYoPoK336l1iqFVj+6BUaQdI8s4CDq5yLFIFILq7ljuek238YCivdYAvSq7gahD9cNVNiESLBDRJrhNND87J0ZpsDYUg5bTTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzxQzZNJzvOHDthpej9c78dK8pux5Uwp4irckVUuun0=;
 b=f9cA6xvaPUiWRBQpJNzUC2npMqwCqLoyIwcfaCyN9WzkJTVrcn+j67xBtmN74kmmO7Jara4rMWFex61GWEq18fBYFIWzY6dXE2xA5LQonHBRhn1Bx+HDTU69y3K5/Q7Dh9KyLy6zPKuXhLqfaWe9kK2FxDd90ZH7V1JUO0uXsHsTFOriu9i6LtxxoMnpmOtl/EFxwebVFx4cFCLVEJq9i9tJCSLZM/H+9pBOwWBBT8QO8MN6asAOBdJAGq1ubV+0eizxrUhQR4KLJRsO0NEGAZ1VUPBQwyxLHFoahZOTdSLVT0nFK5A/wLz9nhNiPo/miAu8hsNdc6a/u2u5qmnlXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzxQzZNJzvOHDthpej9c78dK8pux5Uwp4irckVUuun0=;
 b=nl3JzEQ/Qh+1jn8Xj4EXKVaRnIIFYUZ49wDr8+eD15xgwThWspEcwXAE717BmertKlcc9F6ZF9w3JwARyTSN2ZNQEednofjUQCrrIQ/HD1zMzVD7O4/zSHgSlKxTk1M0yFnkw71HKVAYKYqWwI+4v7Pn5zTpj5LAd3FNeVlTBdQ=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB7677.namprd04.prod.outlook.com (2603:10b6:a03:327::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 07:17:06 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%5]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 07:17:06 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Martin Wilck <martin.wilck@suse.com>
CC: Luis Chamberlain <mcgrof@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests] nvme/053: provide time extension alternative
Thread-Topic: [PATCH blktests] nvme/053: provide time extension alternative
Thread-Index: AQHbUT3oFmt53QtKakSPsBvMmvOfC7LvBH0AgB5sUwCAC7n9AA==
Date: Thu, 16 Jan 2025 07:17:05 +0000
Message-ID: <6jbvqdbxu6n6ons4txfk2qflldypuav6kn5oxtolfscymlijrd@ulml3o7lkm4p>
References: <20241218111340.3912034-1-mcgrof@kernel.org>
 <53p73kfx7akmecsc3sofrmga7o7m32gg2lp7e44nacxgwarfoo@u74aepo5erqs>
 <6f46c75da6f865b04d3038cae8d3bfc6460ad02f.camel@suse.com>
In-Reply-To: <6f46c75da6f865b04d3038cae8d3bfc6460ad02f.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB7677:EE_
x-ms-office365-filtering-correlation-id: c74f5a60-4d19-4e52-e283-08dd35fdc852
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?DyaXZ1SmWDoQK7/RIQL0W100auvEsWW8W3RCNsOlxLUy7LDGGKkLQ7ZAKI?=
 =?iso-8859-1?Q?BKGyCWquq8OuJdBVmW7h2EQJCryWIFY/Ys5IJ7xYyDLpUGlRbVAghviiJR?=
 =?iso-8859-1?Q?GcPTSovbyhJ2wEUWoFLg4fyG5yAb2ajRqXg7hzAOPa/fyUR6+55+fH5os5?=
 =?iso-8859-1?Q?y+fhntKt7xl2AXfVYW/VrtcbZUu/fqfYfrvPv1D3H9OQKr6zV6dQC2TGyp?=
 =?iso-8859-1?Q?0NK3LNd0GH6TrRT3ePEZRG7QgtCLPbMm5BTr1jTr4FxLkF1AvsHqx7Rlyk?=
 =?iso-8859-1?Q?pOEKGIxRN/SoyheI8WyTkmwsNOkc/Z65XdxOLFGSRpbrcF0K4oAWMTw6bc?=
 =?iso-8859-1?Q?o3wp1C29e0DARXbCvJbA3dgDH4Qk6hDGbkOiKr4f42gw+snvcdpj7bPwRY?=
 =?iso-8859-1?Q?EUUyTtJrJAXrlDhLkGx6WJmTa9v0PQnQJbP8KkTCrFhW56h3YB9WmlqImq?=
 =?iso-8859-1?Q?W28V0pzXCbJfxyTnSLja6iSjA9c15oqddrgjdGVxG/oIjiIoergUj1kNeW?=
 =?iso-8859-1?Q?uG3SiiMAqflTmMbQuPItvIbNiCtrB4dL6SvpBDZnssNtnX/X4KYD2bQAsw?=
 =?iso-8859-1?Q?zjzaZEVw3M2k2Bml8SiK7PbSaXHrCFDPY9KuMO4R7kf4GhK3B29OnWMZXi?=
 =?iso-8859-1?Q?JPN/5idLXhnBckUWzVrgwXu9DLhXRsPDp73i+nU5xxS9rR8TcM5UxKEJZK?=
 =?iso-8859-1?Q?2frlDmOxTSGJ9c7G2+HEDR10wAsn4Ay5HJISeGGjjnPeZ5Tve/2kCkEMnG?=
 =?iso-8859-1?Q?EUsKWaVy6KLyXE3pLMbTIqrltYsaw39FJBGI/7Lw9gPpkNmXPgN1e3lifk?=
 =?iso-8859-1?Q?rnuXLMH5+IN1k29Tb+5YXN60nsu/vkkyjsmtCR9vIl5BnSDUyc4y04ozP4?=
 =?iso-8859-1?Q?Nx5xLwD/zYbaTRlrHdNTqQMJFzY6Ig4EfLNw2WdV4hODuMwbjBKX41nZQQ?=
 =?iso-8859-1?Q?Mykz1sVaOaYgrqBjHcTCaD1OFaU3BslX5v8ATpUNhbVUI23sMmgOkL6UwQ?=
 =?iso-8859-1?Q?XP08OeL7ahUYAsq71zFplheUPShOo5O4wHi7Txfq/9zsim5rbyFEBvkha7?=
 =?iso-8859-1?Q?hJkAcmqo1Vm58KmlfgmKVFaEXS7jZ3/i7qnZvFEAHCo+UaE3F5t+ZKJegp?=
 =?iso-8859-1?Q?+K2vYQWWBNOBYOblz2oszCOHlDmKJgkKhSyw+6SB1dkGZtEJleMnnA8DQA?=
 =?iso-8859-1?Q?YLX9qq2Eeny7xb6dmtsQrMykpfDD/Q+R9qls1C10ui+Km8GI495sCzpvJ+?=
 =?iso-8859-1?Q?sfDyX/PHKMNPOD+qufU1Vopgzn+Ju4hqQs7d83tAuvcEMcrzSkOQwOB/1S?=
 =?iso-8859-1?Q?q/fNaqitLenmsGCtdKC15m7E47JuUN2vLEhBJ7mT5EqeJX9N/BBnKWZDZL?=
 =?iso-8859-1?Q?4FTT3onqfq9mEGE2WRMk8f4AZIYPppTHXZyLVNWhbGp8uVhCQ0gDs1C0gi?=
 =?iso-8859-1?Q?KhE2TBf0iUI1Nhsl+m+9U3zWKoYnKX96MSU0Y5iuJQal4GnNxGh2yXlUJn?=
 =?iso-8859-1?Q?IDd9pz2iUI/NQGwA3PD9Uc?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?S2q2/8DlaH0kFnuiZxJI/zJl21biRKdkjbms8rO2ocSxWCGj5iEBLEeapa?=
 =?iso-8859-1?Q?eKpIqpZFFkZnOvWxGHYkzGrhxFg/vLbwZI0nbHQOx8oDDg9cFeuV1uOuPe?=
 =?iso-8859-1?Q?oaLchA+iWs+2ropOAnRDshOPoQHIZAcB44JCNBpvWZfiuMcOT3aNKaoLzY?=
 =?iso-8859-1?Q?Bp+tdoq3A1JEtPENYN3z4vdyWymuRLE8jgbpkZMBdf6ED43oE6TnU+vdau?=
 =?iso-8859-1?Q?Z//a80nxf7mniy4lbb4s8ClsxHTLWyjYSHemdn4QSKFJO16TMDDetx3Ti9?=
 =?iso-8859-1?Q?UokyEkZZAjE0sVZLZb5oio2FOaiSobRhAVgwdA/KPvPgu5u6TwTLuc0soZ?=
 =?iso-8859-1?Q?DZb5UE8I4lBBwK/WM3GYmDpQmQNonfBgjtbgkmtw4thGlSDeqB5lbTYaKU?=
 =?iso-8859-1?Q?/rP0GR5WwP9Xbw35na+y+04Ac+wmkCgUgPlaXfDnX8sWJd7Ep7j4GqooJI?=
 =?iso-8859-1?Q?oSX8nF0WQnJ843T4yOimwTDfA3kLilgCOB6BzLFZSV61UhCNMa47f10s5d?=
 =?iso-8859-1?Q?dKBqeoKxu2nAbyiJZSeTzjM3HTazldNHdG8GOUeRI2I1G7n0cv+vgOBqEh?=
 =?iso-8859-1?Q?DNnMW+wnPIkhsmTiY4+2ZpC9v1nN1SWVitAnYQTVttOk4lZiUar2X7rj/3?=
 =?iso-8859-1?Q?qhU0MeJ2+DLRKi9RXhWPcPRgCDKdaoaVcKzjm5rP1DrgjziiXwIMdGP+ec?=
 =?iso-8859-1?Q?9ypZAqTfWDeoMQiR6wEjd4R2gR4ONTdCsC57UAMGKNWV+4iLpGj5J8TRqq?=
 =?iso-8859-1?Q?Av8mFwYAKFA6bgWGShzQQwpXCSfdMiJgBNWGlE2y3f2Nxv64AfxprdUSSr?=
 =?iso-8859-1?Q?7NLB16cZsV4E02TCMqTSj+GL6+gaKJtZ2KQJZmSWfMApnl5EpKNpI6Mx9J?=
 =?iso-8859-1?Q?ya0+oMidzhxCGravy38zBPq56PdjT0Q6cshmtnQ/qsvf/+kyjWwf8RpwqH?=
 =?iso-8859-1?Q?A+iaPyYNN2jouLavI/bMGTHfDvEp4RgTNFvuxVVyWBZnDYjFOOy5iVST4x?=
 =?iso-8859-1?Q?bpdBu1wvwmEm6kajM6roPxwmKypH4aEXczp07fjwM2j17teT+7mQ5O3uLM?=
 =?iso-8859-1?Q?iTM7PmQA7oj7wat8+UpTBe/Ns4gln+cHam6oid3Jtl88oWGE22a/k2uO9g?=
 =?iso-8859-1?Q?Ghi5Fk9AJkYOYbuDMJR4sJj/6/kij/Rct/9/q4K96lFKQ1PJ0hDQVUdRGO?=
 =?iso-8859-1?Q?PlbcAyTulaLYNFjbrAkMH2K5LHnxvJ4+FloA9So3AgyOHz0bZJtTO2qiT9?=
 =?iso-8859-1?Q?PBe+V1tIaZDnx4xj4cFuOvhpF33vSHUtjb+i9BJpuacu8/PTSzPZXy5ey0?=
 =?iso-8859-1?Q?wpsKTTDoJN4VC+lDv6JzUCYbxd4Kz73KT5DqdUUowaeQ35lUfpi+aF57by?=
 =?iso-8859-1?Q?dqUSpB0n4e7mLtCiOkYDWWKEkOYuxhA6/9MSorUc5c+oihOlFDzC6eDaYx?=
 =?iso-8859-1?Q?Q4yUO5jIbkxj4gYwQFeo8kyIZI3GWGK/DSP9LwJbX5AWo2gJ4ZVydZ2VBV?=
 =?iso-8859-1?Q?/nVelCWnpBA/V/Di7FkzKTtWHacZ3zFJakkZoDn8Te8QoZXReN/hj9jJCL?=
 =?iso-8859-1?Q?O2Lz9ZE/Vk6IAdfNHNg8J7WPmOLsy4x5CK1uYPTuYKBUXdpSTPWTxNot1W?=
 =?iso-8859-1?Q?+uUybfuz/aBoc7o0h0vpjk7v1GwPbNO1I1N1Zt4YZP+JCInW7KxHYUHh8u?=
 =?iso-8859-1?Q?Kvu/5fsrR/oK9/VH+G4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9ECCE5F6B6FCB141B437D2C9BA61950E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZHkDqzfdWgygHPWR0G3c+N2ij/68wgsx8gesPZbVM2RtQ8qDMtvrjWs+3ClvtXQieHlcpVv8GpPOyFxUi4I04QAYqAHSWxP60Y4p5dHflUMCvJRVV0F7QTVcveQf91ibpmMiDiUjot5x+gJWH4pcAB5ObUjuf78tOQWGBsdk+/vMKdG5nfUokN6oqFF1PI6xrEbFu1U+mthuCXVx1N6FdkepCBQfqiPGmyqvW+zsTw/vLenaM5/Si6ZE8FcSoeSOxSTVCrKg3ge5EiUgu36jfHku5bfGlzv2WnVs89Dd8gLHwhA91yq5kQxCPEJ2u2ji2BleVCJWR4ZeiuMyuy76qZJgdG173LGpUibyNm4Wxs+E3JE4+cUa7WJGhhWbT3FunPzFCvw8E9Ho+TbqInIWxfabdZ2fAmia6TmWYxsd8nZFvliS6F0Imvn6bVvkBNv7LdWHMvx6tJsDpNsseo/ZR2TUDKkO2dC7F98pWa7XxMkS8HHpRolL4c6P6JXDS4vYGqiWxFMmymezA9nxI/GSF0NZNuHxkIT4lj82a/bqMpZmtZh1P8GIsTJJNOm4wKC85IWDofvQuhwBSY/ol+1/JNRnl92Lvc8Qm08gyGne1zdj507tkpYPc0rvPREbagBp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c74f5a60-4d19-4e52-e283-08dd35fdc852
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 07:17:05.9753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x23yls30fGsLNcGEtDnm28tiP3BLpsyuRXAefXJ9tg3nes8t4MBxYH9iCFjUzCyTI/W1X4lJF+RwWhzjSB46UTH7EbzeXBVap9uVVuSje5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7677

On Jan 08, 2025 / 21:12, Martin Wilck wrote:
> On Fri, 2024-12-20 at 11:37 +0000, Shinichiro Kawasaki wrote:
> > On Dec 18, 2024 / 03:13, Luis Chamberlain wrote:
> > > I get this failure when I run this test:
> > >=20
> > > awk: ...rescan.awk:2: warning: The time extension is obsolete.
> > > Use the timex extension from gawkextlib
> >=20
> > get_sleep_time() {
> > =A0=A0=A0=A0=A0=A0=A0 local duration=3D$((RANDOM % 50 + 1))
> >=20
> > 	echo "$((duration / 10))"."$((duration % 10))"
> > }
> >=20
> > With this, we should be able to drop the awk script form the test
> > case.
> >=20
> > Martin, what do you think?
>=20
> Fine with me, and actually, nice. This way we don't need awk at all.
> Do you want me to submit a patch, or will you do it yourself?

Thanks for the response. I have prepared the fix patch, and will post it so=
on.=
