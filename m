Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73873B38B4
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 16:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781886241; cv=fail; b=glnn4f7Ri3m1yAeDLZkJBlvEeZD8IcUjxTfzIfnziRqwr5knuvmCGRefU81pDR8fk7yAE45eW+vsGIYg1xsbTx1E1d1j2tuaiqqsXcC99NovF8ewE2/hPXRBW22Ie8hpMdxmaxusRFmrgJoqtZTw7QLxIxqI13LlcCkuG5DIGHE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781886241; c=relaxed/simple;
	bh=B3lekm7aqLrENr7WngqQWOOhSTuOtIanXxxl77QxxlM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=B6ggY7K9Y09Dt0mFw1FZvwooO6q+IL1KhkCGKtu2qIj1uO6T0XMH4FAnD2Gbt2MPDaWtJ+pqjxbOFUP7KY8+oGrCdwDUJheB1DGmauguLCwk1Tq6NwvBKYuBvH3+YXBohm0JiugqFB0TO+MQ6qDXmQipm5V+RCDwG27t0ZyoI2M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; arc=fail smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AAB1F000E9
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 16:23:58 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 19 Jun 2026 17:23:56 +0100
Resent-Message-ID: <ajVtHI06q8QS83AZ@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 61D8E2051A
	for <broonie@sirena.co.uk>; Fri, 19 Jun 2026 14:35:10 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8276B601E3
	for <broonie@sirena.co.uk>; Fri, 19 Jun 2026 14:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 4D9BC1F00A3A; Fri, 19 Jun 2026 14:35:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.113
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1781879709;
	b=sLsbmSZ6jA7DS4VlQTPEoxTt4Sb+aqZYlegh8SZFmUW7JnCdWkkOWrcZs6nWMqxz6a3/
	 zlYdhqmjnn6LB0Xcj/3FiDijYyfwihUf+7499624TuaW1xmbD+eDZxUABkcyvuvFjMxUH
	 YiUH891fv5FXD7TZGl3ptBvpg0tC/o4Dbc3MUAeLxlXctiu1AblRJ0SQsVh5rvkXPtxvu
	 6iwZeoG4BvMY1keVPj4WKzV7oRh8yYlgzwX6sNfJPsG4u6pcM+h90haV6+qSLCtNsMEg2
	 JZzBAfTM2N4aDLwKZcRyFhoMhqyzYS6r6H8GzYFjVNqzNxZinsa1Uu0/YGTMMD3PKwg==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1781879709;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BwkoWUaPBCG3mieKH63tLU8wvWycuE/mcLAwuYAKo+w=;
	b=yQGlnKFvKlfU+eYmqQ+Btq7JWTOfohAksCOiceC7ElpA0gkefyobF9lDyJZDaC5emzyX
	 ssCOTC86hA/RgB3m2E2zWI0lHwDuKuenKu+iipbvvWPtFVidYsbHorjmgWwnMQsxxTrM/
	 t4iIEz2r04JsW1pdOZJ6trzovYB66UiOiJ0mVDUIx7mKosQ+eshRSN1UOaPhde+nTjVoq
	 u9SB0rVpNHygt74yVjnk0w50y0Bdohqq1FYTW/Y2jLV8Bmud05RpNcc3FT0r6RWbjiq1H
	 60dQdevsfdEp5mR/FmdeTwSiUFb5zOC6DPBRpXUa2Cj6tXKP9XzXYg85Mwq9I2dCbyg==
ARC-Authentication-Results: i=2; smtp.kernel.org; dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.113
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BF451F000E9;
	Fri, 19 Jun 2026 14:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 7BF451F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXqZPV4+b+fKDdtjBsSd6YiUrE4mdB7CkJ4terQCRLVeCu7FawAfHAEn0eCGjOjS1Ws6NaUTaHe187prqxzvGqyEQpKS/tLgRP+hP5XpvsnkLx9fY3yEfg/q4PUz7vIlVFil1BHYKYE9/0shGEyNWgxYIg7ikXGw1xEl9zeX4cLEX43K0wsI6V0b6fmrUzp7G0xcGmt7MQngLyZo7jDAgiIvYrettsDLa6YFCsn+ZT+PZjS0g/wE3l7VoN+7zHo4dTGCpdr6flib1/ZJgxombU2RJkg+kX1Z3bTcyC2MGNIA6lJ9ei2PW0veoXuJWpAuXiqGc1Yz6iYy7PnvXgPuQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwkoWUaPBCG3mieKH63tLU8wvWycuE/mcLAwuYAKo+w=;
 b=JIt7ScGluPwCbep1vDRHIkc0rAEc9LcPn9OuAnram7eopMC9rJFqLmzy7tN/wngiS4Fftx3mC5jYwva9p9Yt62C0fdZOkgBpMAV+HcvUcuEIBpttRIO5DmGkb2lWTr3Z05TO2fAIhTpTUfdJ7z1i0UK+kKCBYiyYrtDm+k1OeWbyAJ5BspApw9m+2MumX4cTLSnyAk2d/EpNm4oQWpZhbQNPe+tkg4mVzK/MHnReprBDZFhnH8l6YA9rSW1LmGc3pkdIbSfw81LRYswfpdJQPEdd2y1BImd69JZkNy2a4PiN5O63S5sW2/sYj1+IafmUbFgkhotAclmekKJfz2Rt7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:17::6) by ZQ4PR01MB1330.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:16::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.21; Fri, 19 Jun
 2026 14:34:53 +0000
Received: from ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
 ([fe80::e7d4:256c:b066:850d]) by
 ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn ([fe80::e7d4:256c:b066:850d%5])
 with mapi id 15.21.0113.020; Fri, 19 Jun 2026 14:34:53 +0000
From: Changhuang Liang <changhuang.liang@starfivetech.com>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Changhuang Liang <changhuang.liang@starfivetech.com>
Subject: [PATCH v2 0/2] Add support for StarFive JHB100 SPI
Date: Fri, 19 Jun 2026 07:34:41 -0700
Message-Id: <20260619143443.22267-1-changhuang.liang@starfivetech.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0025.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:2::22) To ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:17::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ4PR01MB1202:EE_|ZQ4PR01MB1330:EE_
X-MS-Office365-Filtering-Correlation-Id: feeade77-5087-4590-9ca1-08dece0fed21
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|52116014|56012099006|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	GRpw+OVOExojwlYzqCxnMGMhFw/PSsgCnREOg+HANBIcpmsA8NqoUVhDRuBXJftgz3PlXWs+otI1kePedJCeWUHJMiHeyyCFl3uSsJiNLzNCpuQQsAmW/+VH1GtOvZ72wetIEu7Wagupsa2KZlqvV5Wbv9n/keSxtS5nLe1BWgk6Uoir7epr4nmpZ/a4kuVeYSCjECRjG9SzJWO91m2XsdUPJmTf18hOyqub/Hrr56sDME3UO+il8x2L4xp3zBONGg5eXnb69xWmS5GDpLzvvU0xVmVwBtTy1HGIyi/mJkPOWFO66L5ff0B2ty2uYOa6EMY7hKMY956BHUons016c9cjSnA0F/zVgeYlK0VrqxinsmT19TQwldVUJJdYTOk7KI1vPGXdhvbpWtb95NTxpzrmjQnJlONGBt04jr6RgTluvUVXDqf8UQ9/vWGka9cociirDf5A5ySvCEFg8mLlJE1Yx0bgugacO+IU49EPDEbLYbgk9WpFE4xDxmffBy6HkRZu8SRXLK9EOuXka/LID6/5ukp+0UAVcD+49aOhmJh9wWgdDJFxQxJDZAIhgMSs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(52116014)(56012099006)(18002099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v500js/K/YlIPSxDnmSra9Jw+tG5kPim0dAPD3ixDpkBE1chG/vpWWJbT4fv?=
 =?us-ascii?Q?SjdGTLcRoNfU+8CvDSgNK7O04b8DrGP1YlWDbrseUe1E5hh00pofMPpurvFs?=
 =?us-ascii?Q?7z2dNumEFcwhe6LAzq0/Lu2VnLZL/VtUFnLAbE9Z1hLMd8a5angFm7LaR7aA?=
 =?us-ascii?Q?sHTVkzIcad9Wih8gcrf0vpwt7C9Pdh2gdZmRxwl9WtM1SpsHMQb6pQixsWw9?=
 =?us-ascii?Q?QJ77XZPMsw4AgUPgN4Pvdp3lsNuVx/BXEg4YOlHvcIygkSq/qiox7u4Zx0Er?=
 =?us-ascii?Q?F1LGW+F5iHCXf3rGgmYYZ3a5dMN8+Zli6Ux81I5nqF7Jm6khi32eS7xY5n/a?=
 =?us-ascii?Q?AsO8Xq5Zb1wf5isuxco6gkAeZW0V/+R0Q4vNDOSwCkq5ZooxAMeQBDPfwY36?=
 =?us-ascii?Q?36b/dxFw5UYoKKE2UVFqvti4rFbcK+hLeO+Fp2WQdw4ar2bu1wNd9sz7SQDX?=
 =?us-ascii?Q?q3iqdptPZnSIiXAaxi8Kf2UvsCq/pkm4rYLNgQivP9412LWFcpdL0huv7s1a?=
 =?us-ascii?Q?iHxrlIp7fKDJnxiYO831x0Hxa4DG/+5x0NBPFbst95nja05p49wF2uXrF+Fs?=
 =?us-ascii?Q?HrBGerP2ScsaDFHmtS43NOvt3EmGzqmICyfplDgn/XHFvZKKQ81w3Hto9aE6?=
 =?us-ascii?Q?BrK1yU9MhmkjGIgkFuBCtc9fCDwmXIX3yF7iVx/Lg6G5IUvcucLpolD3m5qR?=
 =?us-ascii?Q?x2xPStyrYCZJk4S+hzFVMnW3E9lGlqJNPBBAaq3ad/xUam7UN7UpEIz0eMVb?=
 =?us-ascii?Q?pqCrs4xM8Uwhk71FOmSuFh0X3t16537yRfWbEdPuJbrQcZyUhA2UQ9/W9hnL?=
 =?us-ascii?Q?R6RMhWJPTCCzFzOIQDQu0x+dtOx4BcX1AzRQDJ+hdUD2pub9MBSyvIfdyT+Y?=
 =?us-ascii?Q?TyuM4kNCXkMpEPWNCEb5gCUlnecoFmE+7y9gzuQnSCM/rK07tHPDbQGT9FqF?=
 =?us-ascii?Q?ZcY9uYk1n+aSA9ctg5VnMnUg6qgkHcet5C9coulJLqY7EdXqYOhiJiGGdeE0?=
 =?us-ascii?Q?Pio8ls9QHo5DZcdV3Za2zZ1qCGIZPa44FQV/v5xcktzyXHO7BY+cwc3LwnmW?=
 =?us-ascii?Q?yn+DjySJ21EGDj/CDPV4fknDy1erigoPM/ep6OsbjOxBP/TcYsa1T18TUvj4?=
 =?us-ascii?Q?1i1EfO9Ci+qMi1XnNTwkFuYN3EJRUgp7eL/EzNPSC4fTOG3Bd0+6405n5C1L?=
 =?us-ascii?Q?9VtlArgWEL2ntYSIDT/PByNpFT8knRYWtMflVKxaiQBH6d8yzkqDqbaR0O9E?=
 =?us-ascii?Q?B394wrXwmGQQzz1v8KrMvbxx6DBa7891zJMfFGhBWynUF7K5jHGWeu6v8QE6?=
 =?us-ascii?Q?DvWSgpfKmGk30y0ozSwvdF91IkFPDuy4bOyal+ki2mRMrnlyG3CyZI/z5ssL?=
 =?us-ascii?Q?9QEv8lxQDbYdoCpNG6FUoFVcn5H5NhDk9d3gK7mkXE9s0XolKX1tEkojJAqN?=
 =?us-ascii?Q?BxAv4ShwFaXX59hGJchpFyBTvdR3gBWM/jz56DASiHi2PJRuRVkp2fjkLZBx?=
 =?us-ascii?Q?b/RH04SYjKefsJUPGwDlTCQFOHZbUcfbi34T7tIWu8Jz8Pk6HlLKZtpg5/SP?=
 =?us-ascii?Q?9HnLP1snb9IuggBNfXa+A/fkCDzqBIKaAe99bQA+rncUVLfPBwsnCVR04ms7?=
 =?us-ascii?Q?wUtaDKVU5zdIvQUDKOf50k8uThEEbUYZ4pQo7g8t9VEnEELYsa5IS8rfWxqo?=
 =?us-ascii?Q?BILWlGjhq1Riec3X6WatJOBnc5z4gn0aH0fhFyjgPPJ+59lmqus2xrRHxY+X?=
 =?us-ascii?Q?EbSNjLoOYEDCsfPOju323iN4zKsUYjYlBXLnqx/zQi+4/arJKJyN?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feeade77-5087-4590-9ca1-08dece0fed21
X-MS-Exchange-CrossTenant-AuthSource: ZQ4PR01MB1202.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 14:34:53.3049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haDKOo+4IsUdzJ6Xbvak0dxEk3buV1rw7jJwbAkx7f4cOB2FGb1fdrbcMSt8SbfSAUfTaLK6SnIHay0+TBJQ0GYdDBThsZLtMECliHD6atcRMGyrroQzYQCQjZaQCgLD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ4PR01MB1330

The StarFive JHB100 SPI is based on the Synopsys DesignWare SSI version 2.00.

changes since v1:
PATCH 1:
- Add "starfive,jhb100-spi" and support falling back to
  "snps,dwc-ssi-2.00a" or "snps,dwc-ssi-1.01a".
- using subject lines reflecting the style for the
  spi subsystem.

v1: https://lore.kernel.org/all/20260612125856.8530-1-changhuang.liang@starfivetech.com/

Changhuang Liang (2):
  spi: dt-bindings: snps,dw-apb-ssi: Add starfive,jhb100-spi
  spi: dw: Add support for snps,dwc-ssi-2.00a

 Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml | 6 ++++++
 drivers/spi/spi-dw-mmio.c                                  | 1 +
 2 files changed, 7 insertions(+)

--
2.25.1
