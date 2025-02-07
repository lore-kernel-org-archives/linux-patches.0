Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2AC1DED70
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929514; cv=fail; b=GU/7LzwkldxeED69Ape4yLID9JucfyBb0I7JMv9sBb3Qxg2bUDUcxAVej02CFwpA5AmLtD//iBmID/2SWDZVJ8xSqGr3t7Wj6nMmcSxTigPxChgwx+oPR4s2K6QTLXZBSdJpOryLYn6s2as4O6nhKTqdXko6+hVWCIHjx8lT4pM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929514; c=relaxed/simple;
	bh=bQjr+mNMBrXEdKNxfy7/6EWYzkEUbvcq++FZ0wRmaNE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RZHSU41WwObvSU9j5lJyj9znZ8JVJvdChNmFQCqIKfIV5lyzqsKjYxTvmZpoP3MLqjI6jtDiqoyMfWmX8toOXRE1KP960G10zlRcKTsXKy/84lAljpRSjTdzWs0dFwV2r7OtjOMk2z1KBvmerIvvvnrlcOd8jGdJZ/5TSqL1/2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QnQOC1M8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HomNzC63; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QnQOC1M8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HomNzC63"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738929513; x=1770465513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bQjr+mNMBrXEdKNxfy7/6EWYzkEUbvcq++FZ0wRmaNE=;
  b=QnQOC1M8wH07GbjV/60AyyF2edVtrxdwPhySCs2aitOIPxFAN7s/3PAx
   ulMQopBcHyd8nuVZ/BAntmmNcDjXXCVEN00OjPTrFo7eAD5EeGzRXbuLk
   wJQFWM8TIY9jwhnqyYYRlL9PD5XaAsqK9p4rQElgjjFiS7WvVSAXszE6u
   S1X+c6ZaDXfp02+v6BU5wtt9XOSdE3Zk0HdbEb7/jXBB7KqVhp3S36ouX
   XxRCub6uhT0zV7s/k+KLf8CoEmO+h48qiHDSazpI6UXpuAiOcSmZpAZlE
   Kgzsian3nAXe3kb3dOKqVns68qFfzOw3rCcCyv0h3awQeSqaT32SwAEZ5
   w==;
X-CSE-ConnectionGUID: J38ZIbd/SbelbQt3Jjb58A==
X-CSE-MsgGUID: IF2GFya4Qomke2b4cjyLAA==
X-IronPort-AV: E=Sophos;i="6.13,267,1732550400"; 
   d="scan'208";a="37274617"
Received: from mail-bn7nam10lp2049.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.49])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2025 19:58:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rx0iREq0lWOGVt6jHA+E5ILslhxBDFX2uKBjCMz3HBhm2G+ggYDAy96TM5T51mDr1oLk7ekasAg4qt519QHMgQfXS+FRKVrgCf5CBkK8SICSgHIqTEbEoyIh9ny2u6qcB1zoE4l1uWO8lYD5nFLXOwR2UHqfsJuF3z0DimhgzudGVcHsaoTtm6r4iI1kH0yoEdK9zM6pe3eCqCRfBdGnRuijH/8qgioAP1v1d57422ByUC0z1seiCXrIsjF5HyjdykWJmUKnGmHMWMgHXtvRD4/3xFuWWtO9MMxXcdGOesoiuhA2YkE7rWsO0WvyXRdtCmJ8zKrZr5d+1rrXxHTKYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04el7OMvry0S0QUnJf5hnqsiowSjE0R1z2JB0jjGaKI=;
 b=lDaeuWBGTIS/HVZadaJPQis5awRab7D5u4V5P2sVbmZDOEd7ggQ1YxylffKKOho+Pvla8HIzUExIK4GZDU2dsAlQb0lsmd+g6tuZPqvOGeWOYmdEU8EMofdjMyCrOb1EgOxm4hSua3bWeSYbtJhkzV0TXB54yCE2/teX91xkxS28TSi3K+IY7sEP8v/KbwrT1apaTesxp2hnZPREYmWqPzQ0Ofe8OnY+qHMe163okrGJ6DGFvox0u+576+xwXqqAvfAvIAP23yKA1yO3jdZ9/yLwIs7+TLFYpy2MR1/v1JN67sZqIEWjrQqUlND+jQ10Isk3rCcKgCEusQHI03Q9IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04el7OMvry0S0QUnJf5hnqsiowSjE0R1z2JB0jjGaKI=;
 b=HomNzC63suk4OX0/7L2WRGRuyBwRA2TSYRuiXNuAnIwTFs3ZSwKRmsXGST+O8ry0gBWSuiVla1Tw9Q/XuF68FBPxGNrNyYIBW3Ayn6uFiWG3SESTbxQrS6uHf53Huh/+yewCTdsTpx62hfJv85+a0RPfx3Ga7HXFqMKZH49sL0A=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB8290.namprd04.prod.outlook.com (2603:10b6:a03:3f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 11:58:29 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 11:58:29 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v2 4/4] common/xfs: check for max supported
 sector size
Thread-Topic: [PATCH blktests v2 4/4] common/xfs: check for max supported
 sector size
Thread-Index: AQHbd1gx2OvsfQ6rEEe5jMVAleo9FLM7wIGA
Date: Fri, 7 Feb 2025 11:58:29 +0000
Message-ID: <7ug4nasddicvqix5wjw5mbvjurvgdxmmj6j7i5xgb4dlozswjd@okvt2f3qfj32>
References: <20250204225729.422949-1-mcgrof@kernel.org>
 <20250204225729.422949-5-mcgrof@kernel.org>
In-Reply-To: <20250204225729.422949-5-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB8290:EE_
x-ms-office365-filtering-correlation-id: eece4044-1672-49c3-9815-08dd476ebcc4
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?nkboge9CqbD81eWBn/dcP4zg9zoM516n144pp05EcmHqgxgyeP18MYmzM9DY?=
 =?us-ascii?Q?gB4MffjvgrQcBqASxfEodjraQpZ1R4p8Xe/7zRlaO5hEmMC1eWz/Vu8TnJSn?=
 =?us-ascii?Q?SUjwn2DdMeI8fBsOHZBBg6lCAqkOebxHCQCpfV6PHxB8ocYQ4z31vobW74WT?=
 =?us-ascii?Q?58TVJ+i9KgNRkvDKiEys11Zo1VisBWrM1xhUqkPJUEZgmNTz2q9r8J1Jwyzr?=
 =?us-ascii?Q?LkWIAbCGcpd/2N1DzqPUpOch7Nd4sUPctP1tiLOQd7+4ClRYOy+AeYfN2Pul?=
 =?us-ascii?Q?9DguYT8AvoUDbNCv4DtqUZ2M6x9qlciosa3Vd3KzUH3ZlPL1pVZElVBwH3Ex?=
 =?us-ascii?Q?WBf6Y3MErwoIzxppXRy40I/3SNNu90CJwkV30J1Iu8X+KHEvQMTRyOjoGGsq?=
 =?us-ascii?Q?DlwzgAiSQmGUJUl0zDGzTgYHcG6h3uXkmAX/SRGIEmL8P1gLRO6Ig9nxUohF?=
 =?us-ascii?Q?5zrFxCnZQLT1RDqXCP7MVk7c6avrbIAU7tnfTjzazyWjOol44ymRC0w/ZS3m?=
 =?us-ascii?Q?MsyNL1Ag2LkXB62U9WUtfLFw2oVxudiYstT+/P7MO92mMw/Tk1NDem3/5Afm?=
 =?us-ascii?Q?impSMzmZseL312/v7wrPijnSyTpua96Xw5clj1wMrg0KIi1qXDA+guSZZG0x?=
 =?us-ascii?Q?Oo3MHWEXR2+LWY88ZJi9Vdp0x87/qlXIpTrWfAyzCTu1FhUqlXZDpnt2oZo8?=
 =?us-ascii?Q?8m6EwYzPpHNIFODSIaSSMfhtFyxveJqF2v/1E6jPZj9efvoUM3Q+tLBh6RCp?=
 =?us-ascii?Q?Gp43seCeiRDoe6n87lcEWdXAQ1Sbm6rygqLguNW5oL9UH5ejTynXWbmR8Ena?=
 =?us-ascii?Q?tc8c2bxX05wQcbhK225hhMGvR8bbwWAWO/MCliv058kSCR8BYGdED8XK4UZU?=
 =?us-ascii?Q?LQRslkkjTfm2thkPiCXCqSdLfuCpJNiWoebCjJQWo4/yuoYu9KIFwpNm/KGs?=
 =?us-ascii?Q?43ZfrB+RcbkfjWvYjojlW4bG5+/VVmamBxFC3t+Rq81jvQjxX/KZdHVGe8yR?=
 =?us-ascii?Q?pHwLIOj3HYTh4BY5BlbeC1FqXm/sme+Iudlg0brA5s8prQWzkMvQ62dgqF+p?=
 =?us-ascii?Q?g6y/MuIzZC9JNtygX7WqRd2IHjhKc6nj12y4ZkdL60u+JpQFlg0f5/p75Xta?=
 =?us-ascii?Q?weNp+Q7SeJWd8apEbCh1KES+N6GZxARKuqEjpIaOBx8tQoQ/Od2Mz4nB8KiA?=
 =?us-ascii?Q?RelK9AoRDoh2KTawv83ujjDXAhD3bALqD504vbbgBaaPyExOhB/gDAkInzv2?=
 =?us-ascii?Q?NFB94CQb2VFoBa7Z/xqPugoeI/dPbxkk3Q7XRTYOkX8SwBtgDquAJ/m+wk5I?=
 =?us-ascii?Q?XKW1uJ4GVg0M2BfRJhb6TUElZTuLf1iTQ+BvIONzijYsx+nAa7oJeWkrW4fS?=
 =?us-ascii?Q?ilWN8oceLz+dWdNjorqi0nEoxRXLbyvK4xRGxMUvUZ2zlgHBwnz/y1utqYbm?=
 =?us-ascii?Q?05ryr0X9L+5y8ZeALwpoLNzZmNn412+L?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?VTtwmKudcIZx03oZMr8g+MkRaIjvA1TcM8F2KXJJ2uAtLkWYy3BUJCnEnm8v?=
 =?us-ascii?Q?yFlzXbZ+krQLkKJL6wHMRNUZ6886CZzqXwsElAM8P/HUQ2u9wCxkMAFUXIMW?=
 =?us-ascii?Q?RNys8+2cxitJ3M1fIsrcCjUrz+Bdue9/g9X8LxQjuS5ubIM2llIb6LdVShlQ?=
 =?us-ascii?Q?sYNN1JG1NZflJNII4FTD1QVGCu7DcUaEj4X6aoBTS4uw6R4y6kX4eymC3kWB?=
 =?us-ascii?Q?Q0aiqmJDqwtvLHwXLoy5xOpaiPlN5HjAyoEvvGuKOl5UAO2dBOiIzjqgdHr4?=
 =?us-ascii?Q?U5UahUFXrdIWL33e4blFJ630OsUIc/sz15gwV9nY8iJWQChfLW1vWAc93+U2?=
 =?us-ascii?Q?eRea2Ao6KSD+CKy4GBykHQAIDjgmTBCgcUQkyKNFdZng3p2rI64ek9Cb1YRD?=
 =?us-ascii?Q?YzIzYXaupAzcx5vH1/UD3SR4LUcU36BI35bkMc4Oi5Xn0QI5OGS2gOQnbv3a?=
 =?us-ascii?Q?YTn4U+jPNnUpXZ8FE4Hxa5JYNyCHWQFOjYGxlDA2g/LEmBQmJGUZoBNh2+kR?=
 =?us-ascii?Q?19T6RqQ9v5tzFmsEwU1nDrex7qOgNMA5Pknk/U8Xff/M8SMlGqCi2PKbZB2H?=
 =?us-ascii?Q?6julnRYcX4sake5Ua52W0Gj1cShEaVgqZuTXAzbLNCkf4Fb+rRcUN4HnnC4k?=
 =?us-ascii?Q?kv0nmQoGyXrxQDmGpx7Prh4waXVZSoGV1U6TBlnJEABTMiuWBVTqJ+gs/gwW?=
 =?us-ascii?Q?XfZtY7n2YgGd4QEmRmAF0F5spNsgkCrMIvenUzUZN5I9NiCyy5ps0jhsdpFA?=
 =?us-ascii?Q?I3/fUjb5vwXmVjly1CTsdSX4qloPknbM1vq09uOpGQrJNGuB0LEHyvpR9mjJ?=
 =?us-ascii?Q?NiX1hynC2oMg4DSbupwi7Q8JdRy0L3S1Cz9So4BKxHnGQhx9siZMXnXHtKbo?=
 =?us-ascii?Q?k0X0JjSmZa72svHYozcB+fFWnrHGma1eZkI+4dxI6r4bImIw0bqF794rU8Kt?=
 =?us-ascii?Q?3RZOnlvz1qrp7qDGxRQ2qt/u5OdTgyrMd/bTOZ9aJIHmBHGZRdFB8gs8d+Oh?=
 =?us-ascii?Q?u0OLlKJxBjfdaE7zrgOxoaYfq5A6fjgOUS5vxH3I/xeNmV1M9snv5AhIAlqv?=
 =?us-ascii?Q?1phePr+8aQZrzrz2vPgMHlZRph22JcGx8O1XWpdCpoUrqnnEqqC9rBvj1jCn?=
 =?us-ascii?Q?ugPBRbLjqYhH/9XOuA1t24lBhHM9XdsSg5xEeukvt/W/DC9PfUNj/AzOBHjl?=
 =?us-ascii?Q?5wklwnjSuVcbxhmGZn/kF2cVL8MDoO2TG3bqAJnWCuxwXPHPduyWGvoX7fx7?=
 =?us-ascii?Q?wiflefr3PaaKB2cDjOJJA0pd4MY9FMkuuN+M96Q+eKbVdAAZcwpdHA7U6m+B?=
 =?us-ascii?Q?NgLj4wMF6XMMbkOpCW/02Evz9YpYOX3iTCRPo04kb7Fvo/0Sn8SH/p1xQsZQ?=
 =?us-ascii?Q?wNP26Zz2C9jnxzlS0iGo9gvKtBoq2naC5F4XY8/DLwL8+k17jRKQAIUko06+?=
 =?us-ascii?Q?c4JkVxxXXVxIgvzxyc+s5E0CZdsYDBryEiUXxDfmc+NJDYw3ioS4sc6bXf5G?=
 =?us-ascii?Q?cVqorouEWgeYK8D5gPGModHQVdqb8f8xiwQuyj2mRSipt2Bf40alDHrwdibc?=
 =?us-ascii?Q?sH0iwjjYZ4U9Q+2Z/kdquXt2E3z3M/+IHYhQ8gtGzlB7qn5KksiF2ojjccrn?=
 =?us-ascii?Q?IvGtIQd54ms/sRBBXMQ3sSw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0248097202E36E4E89B671B6FF222CFC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3ZGvQjfU+btTKamf5IRkY/ocA9Zte3UUhmhXyIsY8Bdq7VxXSd5dljuZ7ePA4Ia9IpS/1WJbp/Y2irV7LMVkrv9dPivub7mXAFqnSbG0kpKEGB4bMmVAP1vlMLhN2O8jsYGyVE35HWk78MA13myyjlloqWIFCF+atzIg/vv+RRZaBLg95vRk5tVEjY8F86OA3yvXFBnjBUF8MNc4/9gKGc2ma1GGOOEH1+yxSJcmERmd0egJk0ICuSjJ2BDQLs4rzsheIhMOv2EQxTEXiSGqoPXlU8ihNJ1hAL2hrVjb/DO0JCQIoFcQ5ptzriX9KO/z59QCSBjzfASw6u0oC6JFfHJPzpSyIKxejbiMFFRgKD6pfjtrvAAn88BXj7HWYjhbNc6m/9hsb+L6GzK3Ov51Jy3/tT9GRGuZ+QRZaAUO3mDrCNwk/lEs3QFcMhbVO0/CaXANLLlZgfPwqMs6eDzVsG4Lo2wtcWWip1Bvfz4cOHLC4BO4EHbGPwBDQGTNkQNAPTBTksZbOe0ceSeK3AGJSbPgWQEgG6R2whPnX8FkFMpO7nDQ4nmZdzMhdjc0jj6S8LjoTkpULXnA8v4TuAUn7CPHK+5UkDxHOdaj4sveQr36X6xXzEYLksELKSnbCayB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eece4044-1672-49c3-9815-08dd476ebcc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2025 11:58:29.5419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oWBjlp+5tjRTt+z1eMlqPZQF5kp3GJmSN2bMY2zdh16436Dk6MUVM4NQGyC429oCkhvVSeg//fvGGR+ZgRirguZB/2kcygMHMO1fsjZpqMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8290

On Feb 04, 2025 / 14:57, Luis Chamberlain wrote:
> mkfs.xfs will use the sector size exposed by the device, if this
> is larger than 32k this will fail as the largest sector size on XFS
> is 32k. Provide a sanity check to ensure we skip creating a filesystem
> if the sector size is larger than what XFS supports.
>=20
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  common/xfs | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/common/xfs b/common/xfs
> index 8b068837fa37..dbae572e4390 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -15,11 +15,18 @@ _xfs_mkfs_and_mount() {
>  	local mount_dir=3D$2
>  	local bs=3D$(_min_io $bdev)
>  	local xfs_logsize=3D"64m"
> +	local sysfs=3D"/sys/block/${bdev#/dev/}"
> +	local logical_block_size=3D$(cat $sysfs/queue/logical_block_size)
> =20
>  	if [[ $bs -gt 4096 ]]; then
>  		xfs_logsize=3D"128m"
>  	fi
> =20
> +	if [[ $logical_block_size -gt 32768 ]]; then
> +		SKIP_REASONS+=3D("max sector size for XFS is 32768 but device $bdev ha=
s a larger sector size $logical_block_size")

Adding SKIP_REASONS here is not ideal, since this function is called from
test() or test_device(). It's the better to check the requirement in
requires() or device_requires(), before touching the test target devices.

If test() calls _xfs_mkfs_and_mount(), the test case should be able to
control the sector size smaller than 32k, so no need to check the
requirement. I think block/032 and nvme/012 fall in this category.

If test_device() calls _xfs_mkfs_and_mount(), it's the better to check the
requirement in device_requires(). Maybe we can add a helper function
_test_dev_suits_xfs() like below (untested) to common/xfs and call it from
device_requires(). I hope this will work for nvme/035.

_test_dev_suits_xfs() {
	local logical_block_size

	logical_block_size=3D$(_test_dev_queue_get logical_block_size)
	if ((logical_block_size > 32768 )); then
		SKIP_REASONS+=3D("sector size ${logical_block_size} is larger than max XF=
S sector size 32768")
		return 1
	fi
	return 0
}

> +		return 1
> +	fi
> +
>  	mkdir -p "${mount_dir}"
>  	umount "${mount_dir}"
>  	mkfs.xfs -l size=3D$xfs_logsize -f "${bdev}" -b size=3D$bs || return $?
> --=20
> 2.45.2
> =
