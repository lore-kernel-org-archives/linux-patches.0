Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4966763D
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738927456; cv=fail; b=ozXSmJFul7H4LcADNt6b0AfuqejvGPeatOKolRFfuXq1L5Z0Q1ybodFUQSU3NcF3JBajQbI1zB/GWFiRBEuQK1Ej9/bMjST125aFa16bKhy8wkhmB8bkQlw69li2xNb0CSNdgZp2KQ/S4iGoB4bhQsesLL4iGA6uGGrI9aF6oi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738927456; c=relaxed/simple;
	bh=7BP5nBogf8KDP8+bD2sK0gEOfTQGmjph9M7wKSPE6AA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iP4BEgtrmSpAxwBGaI8zIcvbNpGgkSxBtOtByF3rs/Pfl039RHTlOQfwgpc8SonrlQgpNPidgTupSXBhFa76mWQ6HuzQ+0rWZu8O6QJKEuh+4MST6oVjfJJzZzPOQLGASSX39WCMXbPU458SaINMcUS5LAbQFgX9PHTx4ZhpWag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=f/ISGHOa; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Nu4eVf+K; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="f/ISGHOa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Nu4eVf+K"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738927454; x=1770463454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7BP5nBogf8KDP8+bD2sK0gEOfTQGmjph9M7wKSPE6AA=;
  b=f/ISGHOakBHURJhZYnGRy/ou6Dq+1W1gxFuPnLMq5n3oOeFvpor+z58w
   YCfxHFd2QaEYzqyMmijqMRxi3j8ZkM5WabR6BaHXwVG6tAp8yOOn1LBLT
   1GQrAYWuPpv6h5aRWNPyLseI/2iUmXtOqEiQUlHvaxrLK2ew48OxSA9tc
   6j88RAFttr+t1Fh0V6D6RatPV6/nlcayKhKOZ4o7E40W3QgJMIRhYr7TY
   zP2ybBvbO3Em4k5yY0hbFGSEyWp744Q9i3dA/WgtcSvfZBw3+brParrGy
   kZ1qPvvuAw1X5KSwlpkoxIiNHDwWH2xqlmDCnAtem1qh4yvz2b28n8yoP
   Q==;
X-CSE-ConnectionGUID: 5WvXS6hzQKmvmaFOBPtwJw==
X-CSE-MsgGUID: scpnqA+fQyqMlKr6R5+vdA==
X-IronPort-AV: E=Sophos;i="6.13,266,1732550400"; 
   d="scan'208";a="37272694"
Received: from mail-westusazlp17012038.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.38])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2025 19:24:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dy6dtngGBZ7g2D0e58E8lwv+Sy5ItqO3oduX0orwH/OvjNVIcX/oewlAlLeMEk2pNh/FVBcqMkEmekfvBBqurNe6M4louFrTS3NJsS+HFg/A4jfia695tlSZlQIt4TOqeHXf/O46009h6OqnSWHxZFZFv0GEIpbYQDifqSypP0KDTz6FMlKcVuR1lxIcr3v9e49F67LATfM9k+aJKV3aigvNIatoztXwb63krUXKKjXsEZdZU0aOr0wwWCX7gZjCEhmUmTY4Zi+NfAHGHDZjXh29ZNt6hvnK0lYhtzDC6ijmWC2OcBN48g2BeXu7xrAcRstXc+2O25wv29MEk8Etbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYY3Evjr2kaC9KYKKINWJ6hv8TrV1rZTWGAEeanw6hs=;
 b=WQr33DyoodXpRVkxE6SHt5RQERJjq7A1NrDrB5UiqPNA4B/qeecJLyGCi6Ytjoig4v8xvxj8lR4ul974rqIZ1Wpsnv4LxXDhUTwKfUFaket2ldAcoPDJsa6RsyVjtG2VyTOgjx92Ag1VKanWURFPaBauptwVsSF87lA1L5GT4F6FXw7w4zrREQDJd+hrcLQPxrmQ5lUs3e1S6gyv9FVV204K4PMpFmXBq9NFwLL3hfH4A37d6m3y1lZErPGW6oDU97ZFBoZT2xNBw59eg8Dlv3Skh1ZD0Od4F2zY82KN6FX5g8THSfYvZwRv3PUt70LKFVC/UY4v0M4VfVC0eT23EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYY3Evjr2kaC9KYKKINWJ6hv8TrV1rZTWGAEeanw6hs=;
 b=Nu4eVf+KZ3yKCXtU6qdd/48kvGvjAwqqO5Ww5f6wwrJdKI+SeSlmrsqEWtYes4sf5zouovnjHJaXPAFSr6ebF1Dl2a8SJtG3/wNysd63A0wgAThP7e8sGgQyAP5uGIqzFzaSUu2WcBDoUPgfta/c2GQdPTbXY7n48nfJeJkG4TQ=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6427.namprd04.prod.outlook.com (2603:10b6:5:1e8::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.21; Fri, 7 Feb 2025 11:24:11 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 11:24:11 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v2 0/4] enable bs > ps device testing
Thread-Topic: [PATCH blktests v2 0/4] enable bs > ps device testing
Thread-Index: AQHbd1gxnhFtcdW2rUembOjdnuykobM7tuuA
Date: Fri, 7 Feb 2025 11:24:10 +0000
Message-ID: <ny65lqco7qjaahrthyvmlgz26jb3w7jsqxdm6c7vz4qni2x2jd@n2v2jfxwicyh>
References: <20250204225729.422949-1-mcgrof@kernel.org>
In-Reply-To: <20250204225729.422949-1-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6427:EE_
x-ms-office365-filtering-correlation-id: 59309f99-f8ee-47b1-78ac-08dd4769f1f2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?+Sebulxx2K1K66qgLsPNq40sxPL8yu+oAdYULzjAMKjJkNcHNeXY17jCOokU?=
 =?us-ascii?Q?lu83ODIRrBZ0spjYUeiy/+sF8hBX3sD+g5Y/16oMCClcLAKNZzmXg9CBjLRK?=
 =?us-ascii?Q?ZEXUJFjHbh7M0zwp9UayJIkoTy3vHMBKIccJRrAL2VMtZ+aMh4z1CO4wL6oU?=
 =?us-ascii?Q?Cv9F75Lcrwv2cyXx7bZq6ksM/B0psXL0xedzTUBriFBhtoo82Z4BGIyj6G4F?=
 =?us-ascii?Q?ARNnwADoQZVTIod3gz4udOSVKo/NZVWaWrc55qaDzxqkUDgV7JU67g5OC+AB?=
 =?us-ascii?Q?iI7+7FPcPmqkI8t0R5DB8//an9evnt6NFX8m2dKyiOqQ50gkJ4AB9iud+gVz?=
 =?us-ascii?Q?xsKzjsohWnNOXTYbcIALzC1+HvZmceyKyWmI5rLOCixo0siM6RKMqPXEAeHQ?=
 =?us-ascii?Q?a+qq1CD4lloTrplK1XmJ8qc1PquELYOvoYG6e6ognzOqEXAkfN12aKn0mwS3?=
 =?us-ascii?Q?SyaKkwNxRou0i3sjFHq7KFJZDbW9ECdq1abnm2axsQC0EGXmwthuqlUmMVMj?=
 =?us-ascii?Q?meMTZyA+AFiMTGqPBS7dhIUgqNhVecpOrEpFMZNebiPdoHxfbJIA2B1xiKu4?=
 =?us-ascii?Q?CfgNZ3Ho2MPqcxmtwcKp3QWFTgclecQ9e4WvuoAFChGwNYQvuU1ugXdWXuPj?=
 =?us-ascii?Q?qQanVQUrNocm2VXOSgd7QhdI9jDKJDGnI9xQfGpzASxTHKj+uzkQCJpzC9Er?=
 =?us-ascii?Q?VaENbUk5yEvOIkUCTDJSjX81V+xWrXFWKoyQ9xTOL7FQz7pGX0hmccoGV1XS?=
 =?us-ascii?Q?P6T4Wan5AloWrFkvHEJ4bb+CYSFcC0dkwEhJKGF291rLoI+M3i0RNhtpgsGe?=
 =?us-ascii?Q?L+GfXAnOtfqg4v9d6mOxQBzOO4pZS01wtK6W2HaBuvFQyP/g2dAmi21hNPOs?=
 =?us-ascii?Q?HBcHH6iyH97NHx/hgnr/dYv696kgV739ma9BJjSsaSCSHRF+k14KHSTJaHq6?=
 =?us-ascii?Q?YYdn2AXIg6imltvMre2KAYm2JzGdku/fpTu1U7cbDUCWLYjHzyDhP7r1m5q9?=
 =?us-ascii?Q?ifgKGsLb5CiDrvXgAFGT0vXJz8VdgaE3jkJdrngN2EWjR5YaeuXa8gGrJvvj?=
 =?us-ascii?Q?Lnq8tFfhyLD0yFtdO1MKeuIs35TzODlF/YeUhrMh3E+eYAFyDKXOkCJ5nFtt?=
 =?us-ascii?Q?VZL0U0Gv5x73vgdqOuGbcL/CNaogMQko9nCFIKft4BOXJoBDUBF99QKQIJAV?=
 =?us-ascii?Q?r8eaDj3Z+5vxpOOlZkRMshZT5VLf4JQRkbNSCIoCwflfWQGQhqwYSPMZLOFD?=
 =?us-ascii?Q?nXuqcy/h+uwVV1p6usGDrKgO3+G3khNcvSUjCQZDYKozDqz+KR7u9YNAuUAd?=
 =?us-ascii?Q?OXwYlwrlhBd2Gzo8ei4+R8OTaoWmwxNAeLfrW/5bIH44xPyEdfRhAW1G3Fkx?=
 =?us-ascii?Q?QdA85xLPLQ39uxeNU/zzLLzJnOHcLKkpKMWkzsMzHLkEj9bFgA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vk9zWmNK5PjuD3ZE3v+B3nre2vRuGKdnWZr5FpQACuTxOU2iAb6fOgxVNU/k?=
 =?us-ascii?Q?KU8KLh6kE9M7crp0R7Wl7Q0aMt9Ca0ZGa7uYkEIuVGc5bOc22MVKJNy/erei?=
 =?us-ascii?Q?74hA4bSUDmVBXe+xH2LNOTO/Xgw5uRaLLG9aPT9tSHNzZStyn+QxuuUWE4k6?=
 =?us-ascii?Q?qbdc+4aMEsbg1LltDQEsDJkoQEj+doT57Sj2wMK/6dCm7tuJ5+3Bz69+gy/i?=
 =?us-ascii?Q?F0OdimA1xnWijBkA3Xjv7Yy3l0XqKfJOLazucLFoe/qAYzxKuAVQboURtQ3R?=
 =?us-ascii?Q?lMatpG6LTAEwnbdpJi4p3dizbl10zPfNTiMfsAhXcECIWDAOKdHLG0CGIrbB?=
 =?us-ascii?Q?F7Oj4c/gR5mr8FnTR879pJ+UaR/EksPTqG0zdZwZ/CmHFVQ7huHHHForO5Gb?=
 =?us-ascii?Q?78xuZ/wj2sdEMmQG5uXMq/yeHJ5jPplTHZ/uop2F5ZzAiB8XYLfjlnyZPTR+?=
 =?us-ascii?Q?Gu1jzX+bRGf8NEjwHEmuMdaveQ4Jzq4Z6dfWfRdY7ZhbEelT/WrNWvsMPpFn?=
 =?us-ascii?Q?1sIkYv/etnACyt0w4TlxcI04YiP1xe0/SL3aW/Sq0Stvt68Nd99M9AaHisaS?=
 =?us-ascii?Q?HjfHxEKa42MmU5jEl+wG5VKn+/qna7QXnBvWuxcPMRInqHCHgyKooyBY85OU?=
 =?us-ascii?Q?2xHzVIXcuHww+kB9nPqNVTittdrvctkdT8dRK2dGQQmIYdWvJr4NDM7jA2Pr?=
 =?us-ascii?Q?VVmOw9GDTXdaOf4gNC8TrMS/ZhBAf/r7w123NIuEwd6JDCR2r7dCPvkOb7h6?=
 =?us-ascii?Q?k/F4JMyzBAWmkSYnHhm3I+sCT1VCDOWZ/HDgywIkQZABFikRwXaJPn2e3+/q?=
 =?us-ascii?Q?f8/bcUwXszZvLkZkGsJqyLckzMvqeLrqV2ORa/OEwhGxY4kqtz1HH+hqn0Gs?=
 =?us-ascii?Q?P8AVhobxFmRyD2xnJD914qi7flEelb6+B5JWT03MmFZ85co+AxZtu95Khdbz?=
 =?us-ascii?Q?BUwY2uvype9kcuJqSYDDfoJ3JEEOV96DReNaS2lwMWn9Sm7d4SndjfAO2Td/?=
 =?us-ascii?Q?GiIXRfe45OYAKvytctraEgHBwnXkl2o9WfWtimwM8TTBTXlFiaJIObDdyoCl?=
 =?us-ascii?Q?cpwx1iUWHNvM0xfu7/OtlUoXgywSb6M6TuXdkvFlbL+7NxDsrMIeiyxRF7Kq?=
 =?us-ascii?Q?0l0AGocE+SFxE7zYmQxBx5LuiUyOFV5dRTPGwaWBb4kP3pNbqtSf6xMtXNqF?=
 =?us-ascii?Q?JiQstw75xvtYaPe/BJcI9eb1c2xZxXYyyvVC5DMLo3stXy1hjS2RrrMteidM?=
 =?us-ascii?Q?9ResITghWgkq8TTRzPuaUXFt2MAjNKTFFW6bRPBlVxg5taPqege6AtO0tyZp?=
 =?us-ascii?Q?q2MLx16lFFWMmHIJn/euYGd1T7mRO84hBerwEXKCQepbH56eUrNBYzZjM3sV?=
 =?us-ascii?Q?cRyIQZJUxwn9yn+ctOUGkIkHCdO9fRCIfJpD9ed00mB6ViFpQKQP6AzJImQE?=
 =?us-ascii?Q?kLGi/84+gG8o4ojQkZAs4wlKtaH2XTxZSbvteYkngKuMC6TQHXhuEG7syoqI?=
 =?us-ascii?Q?g/K5maQMBjpB7+NmDei1DQU3RPudPbIXBWBv/LuM2C/477BwMZA5pWSwCWiC?=
 =?us-ascii?Q?vXbgFHvqW3J9K0Udtwtw8SEzp/772kY8Fg3x2Q8DUxsglcPnQy+f5anXKtAP?=
 =?us-ascii?Q?pwGQr9MBL2Y4Ag1ie76I+yQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B1E5E0BD56F3EB438D8615C8ED54DEDF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OgEPGqMNYcgUew+x/sbXPlta8Lly1C3qSqbJXPuyhq9gOaINbby5VgurHQngcL4f7OYkFV5mXjfZGOpWHPpUpuAwf7U1hMwlC6UMu+H7Dg465tOx1tY5faO80HNVbmz1g9B0JU4huNYWGZbNTijlyHAUtMerDP6S5ZeQ914/QNS76J0CeIskpqND5hDVgTGyHrD6STvKE2RT7L7VFoYW6wlG+2YJxvp3iBOWfZgAzCUF8EQgVo1cECE5QCsr0ekBugwXczxzmE2OJadhGm4gB6g8TO5HGAUWv1kmAdO8JlfvBHMVAyh2gw10SKCrdAggApxg159/Kis5gZPm6qVYfu7KCmDAEiqpAns4Kjm/kqCqoR4DdLz8/utclW1inANvP6y+cJbJlEcUrT4xWpG0H/9ymcY+3IveSTBorTzjyLRX/4QlGCeMkITw/+zvKrLVRTodxASCkKfmi3V3DfuBb6JSletRO1y0emuyo/eqbUldNcP9KwmYRUWVzwpszBVEuptcTOsAoG1QtlobRKuYqKZqxa/BQEDJb+CDowh9o4koJ6b/CPQD0zzrku7H8wdDJouTQbzAx7wd7Mwaaj5PohDCqN6lF221k+3/DZ5OE/ib6TS4xXm7QwlvczM3Rucd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59309f99-f8ee-47b1-78ac-08dd4769f1f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2025 11:24:11.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: btcimYOEAXusz6WNeiAPQbgXr4CoS27bcsmdG0y4JuUMwtotA+exYM+wTNUMsoMWbXafL30bu1RiS3ir1kK6uhti4/qjtF0IfL9Xr7hTuoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6427

On Feb 04, 2025 / 14:57, Luis Chamberlain wrote:
> This v2 series addresses the feedback from the first series [0], namely:
>=20
>   - uses less device specific names
>   - checks for fio arguments --filename or --directory to extract the
>     min io target or path
>   - adds a new patch to verify the sector size will work before creating
>     a filesystem
>   - a diagram is provided to help easily disect why we use statx
>     blocksize, although not included in the docs we could later if
>     it helps

Thanks for this v2 series. I ran the tests, and they look working. Good.
I also ran "make check" and saw shellcheck warnings. Could you address them=
?

$ make check
shellcheck -x -e SC2119 -f gcc check common/* \
        tests/*/rc tests/*/[0-9]*[0-9] src/*.sh
common/fio:212:8: warning: Declare and assign separately to avoid masking r=
eturn values. [SC2155]
common/fio:213:16: note: Double quote to prevent globbing and word splittin=
g. [SC2086]
common/fio:218:8: warning: Declare and assign separately to avoid masking r=
eturn values. [SC2155]
common/fio:219:74: note: Double quote to prevent globbing and word splittin=
g. [SC2086]
common/xfs:16:8: warning: Declare and assign separately to avoid masking re=
turn values. [SC2155]
common/xfs:16:21: note: Double quote to prevent globbing and word splitting=
. [SC2086]
common/xfs:19:8: warning: Declare and assign separately to avoid masking re=
turn values. [SC2155]
common/xfs:19:33: note: Double quote to prevent globbing and word splitting=
. [SC2086]
common/xfs:32:53: note: Double quote to prevent globbing and word splitting=
. [SC2086]
tests/block/003:21:8: warning: Declare and assign separately to avoid maski=
ng return values. [SC2155]
tests/block/003:21:30: note: Double quote to prevent globbing and word spli=
tting. [SC2086]
tests/block/003:26:22: note: Double quote to prevent globbing and word spli=
tting. [SC2086]
tests/block/007:34:8: warning: Declare and assign separately to avoid maski=
ng return values. [SC2155]
tests/block/007:34:30: note: Double quote to prevent globbing and word spli=
tting. [SC2086]
tests/block/007:41:17: note: Double quote to prevent globbing and word spli=
tting. [SC2086]
tests/nvme/049:22:8: warning: Declare and assign separately to avoid maskin=
g return values. [SC2155]
tests/nvme/049:22:30: note: Double quote to prevent globbing and word split=
ting. [SC2086]
tests/nvme/049:27:8: warning: Quote to prevent word splitting/globbing, or =
split robustly with mapfile or read -a. [SC2206]
tests/nvme/049:42:42: note: Double quote to prevent globbing and word split=
ting. [SC2086]
tests/nvme/049:42:62: note: Double quote to prevent globbing and word split=
ting. [SC2086]
make: *** [Makefile:21: check] Error 1


I will comment on the 1st and 4th patches. Other than the shellcheck
warnings, the 2nd and 3rd patches look good to me.

>=20
> This goes tested against a 64k sector size NVMe drive, the patches for
> which will be posted soon rebased on v6.14-rc1.
>=20
> [0] https://lkml.kernel.org/r/20241218112153.3917518-1-mcgrof@kernel.org
> [1] https://docs.google.com/drawings/d/e/2PACX-1vQeZaBq2a0dgg9RDyd_XAJBSH=
-wbuGCtm95sLp2oFj66oghHWmXunib7tYOTPr84AlQ791VGiaKWvKF/pub?w=3D1006&h=3D929

I'm interested in the link [1]. I guess it is the diagram noted, isn't it?
But it looks like I can not access it. I just see a blank page.=
