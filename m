Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE53C2627E5
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739532542; cv=fail; b=Pvf553TCCNdxXXQ7lJhR5tOiTE2CnFE6ayHu5oAcU09WnnulN9LbonWFnsuz9wb7R82Nkj6NucURIce2FoVDZF63zc6pk/JKqdahjlzr07jzFFuM8+r549lod3Vj5vpXZsKieel9HwiUegeYWp78+Kp9h5Y+rZ09qNbFa8GTUNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739532542; c=relaxed/simple;
	bh=wE4fbUD1GIK7lo5w49C9TTWYmRmicOlDP/qqim3H55M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oN3E5w2Alu2bQMS78Gw1cY6ksgYxCZ0vRwGGpj4lhdBzcmcIEdHunNxXxbhIq/mFFfigV7c7A2F2YoeMyMb/o0+vslNynmb7Hmn6h9wyBeN7u4OVddsSQ9FVQwr7O0PVPO2TcAlWDzus7/+wBlQnAyHezwOxR13Hoqm2cAW+rbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c+UlLx9T; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Ayfu5EwY; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c+UlLx9T";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Ayfu5EwY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739532541; x=1771068541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wE4fbUD1GIK7lo5w49C9TTWYmRmicOlDP/qqim3H55M=;
  b=c+UlLx9T9FDL/up3sWBBcIGvt7sV/ev2F6KJqAkHiemxhEzaz+FKE6Sm
   +qflXJB4hWt/HoFJ/Kw/Ub6RVQ+F9ql2DMH/IJq6p/thMadcbK9qBP4UR
   yZ7L4/I9oU31h3fqCTGZuRlwEHsgN5FK+NDQ6vEjE0b8Z8LACI30c1lYK
   48GWATcpOF8X6otHUAu/faBW8mFjOdcQDgzyJEWBWqJFod0mRWbSOYFje
   yAaKKbJPcSe/C33vWUA70zR8p2UYRujG8kvTU0BWhxT7hxwjJVyzruEN4
   PLSSz8qQKEKWQTWlWg7SpzedUHhnEJb6dbVZJ9av8QR/BI16Rv0NVk21P
   A==;
X-CSE-ConnectionGUID: NMfBHcnARmu7DiQgqruYXQ==
X-CSE-MsgGUID: D3KylkatQzmUoDzZosr/fQ==
X-IronPort-AV: E=Sophos;i="6.13,285,1732550400"; 
   d="scan'208";a="37915388"
Received: from mail-eastus2azlp17010020.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.20])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2025 19:28:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eHPi/3R6wb6RDMiyUSXeB+mqJClCDMJiaCox7BLjW/dlTqNGC6vNiom4kscN8FCoMJnmSx1INd+rwMxSPfW+83z/5DZ4+pIJsYqjn2uMdn6cREMMfaToj34AkjTCTteCJuKYnMdGI+llOGnhvxwfUUFHPkuXJBPk3p6JfLlwwM3zsJ7NTnguX6y1FYnVzzzcwnhanPmZsBZ5KHSju7gpAOmzdih9rmB5W4Xk9Yddeb3HMDcVSt1QU1ieyxsDUePyw6AcB5wFz4BGNrT4H981xvrGKKFqzwoHcjpNM5Y8Jqv5BHwVwH6zoY+7VZYDa6Jk6apQfAG8I+ZtHayEhzKzHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIwJyl4MVUM52KaZahttGglgF4SnkcT4qvq+j/1cWIg=;
 b=pRWYCsYDi1iY2mrDkKeHXxODbup3nuZs8ZHrO9Yk6owzw1oiYp0VcFa8nza0xNSgJWmKVsN5m7EI3yXrFkxhLxmmLPJa1sD16v4LsFyFMjQEgQLYt9b2b2poQ7hKOlJpd+yt6Wn+anxBEpnRqwlzQTny+8kdoeCBlm5HB7AjIloJT7WEE6Z5ZcfGFz2ruHOSpnZTg1EVVSLF0ID4/8d/UOPgv1pzXKETpmGAEVf71IQMwoJOJA3ycsEyuf6oIZJLeGxoKTi8Ie/ecFZXOXP7GEtKNPKcFznAtGRbWC+9otS0HGqbLI03IP/mlwvHVwmGHyBvtkcrgCxybZ1ux7yUHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIwJyl4MVUM52KaZahttGglgF4SnkcT4qvq+j/1cWIg=;
 b=Ayfu5EwYw93tMISAie94F8/RNxbY0LH5s0wkLZF1cyKaA9ils/JhP8c+4kmqR7TYpYuWkzUHKuCB2oPgKglFnOeo6S4hvTkgA+XBF5mRuRY03PXUh1JNgV0qs3iO6Ijpfwh4/B/SjpEpNHdMfvS4uAIxall02VxpD6Ot2tb2mAg=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SN7PR04MB8718.namprd04.prod.outlook.com (2603:10b6:806:2e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 11:28:57 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8445.016; Fri, 14 Feb 2025
 11:28:56 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v3 6/6] common/xfs: add _test_dev_suits_xfs() to
 verify logical block size will work
Thread-Topic: [PATCH blktests v3 6/6] common/xfs: add _test_dev_suits_xfs() to
 verify logical block size will work
Thread-Index: AQHbfZBgfA7pUkYysEa9iLMuztqIFLNGrCMA
Date: Fri, 14 Feb 2025 11:28:56 +0000
Message-ID: <hlsyliihflkcwuzm5t4crza2jylr5x3szm4jx2ipyfhu27adxl@4fyh2yg2svcx>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <20250212205448.2107005-7-mcgrof@kernel.org>
In-Reply-To: <20250212205448.2107005-7-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SN7PR04MB8718:EE_
x-ms-office365-filtering-correlation-id: 5d50d4e0-c49b-4da0-3de6-08dd4ceac515
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?RLSGEkFSY/c61JxBGCsk19eJzUpeks40g+ckjV1aOTiqdnYS6cuddn0ZLIOP?=
 =?us-ascii?Q?JXBwtDJy9DgO+ExGswBsAe3NNTXjPK9eYvsgIEzd9xFPq3hPYWbtEbetCML1?=
 =?us-ascii?Q?5QuPT588zt3Duxwqv8ZW2gDBmte/ykyk78XMD8z4F2T8SIS93AW+gXSP5UzE?=
 =?us-ascii?Q?hi0zRlMkz7pIdT1jA/4l/LYsU4VcbQvgVjdik9RPqh35AljQmoKpSRWUHyQk?=
 =?us-ascii?Q?/9c2syWnvlV+lN4CBjejdfhcv4EQOKAw9erMYQSgbriDiKrMWAdZlZijmcAb?=
 =?us-ascii?Q?1X1wqVNwD4iGEe8zinXSRfSnTbganjiAVDA89Hgi1gJLlEIdqjoJK10oNovF?=
 =?us-ascii?Q?62Saq4/0aEANOKm95f1yZsBtSTVk2Fv31QJTjdsz7C2m4k5DXa2CzObc88yq?=
 =?us-ascii?Q?TZv9I5Tjtub/bPHIHwJcspPp1+km+nuwNyNg8LCztmwUjpuQ7U2C7zODBoiQ?=
 =?us-ascii?Q?FZ85Z+frVwEkEIOr12i5MR3eVfdes3FpUDPLjQ2nvih+7L0Da4IQntb87XU9?=
 =?us-ascii?Q?+nMqh0gelqBML0Hg8TZMwodyjwqvhuc8uDQnJZoXeonQU/MI0GVL8uXJ+ngG?=
 =?us-ascii?Q?Nufboah65tVKqBk9kiulIJCSlxfaQsaZ2tP9gsSJ0NI+r5lcbWWc3ExLmdy0?=
 =?us-ascii?Q?wN8sMyta8WcjgY0zqACxeFz53eesnlRJYhJKSL37qxCm+Fj+qvVeP4xNMNRT?=
 =?us-ascii?Q?3h0vlnmgXvN6avCYUE45UGgSqogYerILjFdMU+6O4X62LE5Ev+0dQ+zie9ru?=
 =?us-ascii?Q?EnhEZMNLppkI3GZvUfEsq8KWiWxw+nGJzT3AqyfaR140Pe86P2DDQ3SnfVAq?=
 =?us-ascii?Q?TTZd3BOKP0pJGIKQNOMAYpNQ1y6oSklZR8lz/RTHUNkiHhPoL8gC0btcFvF/?=
 =?us-ascii?Q?jf9qbiXpJFs7H6kIMgCNpJDltzuyB1yPeuk6WVwL9y0aLwIVS5YN0ZvBN7ws?=
 =?us-ascii?Q?vC0R8IrM4DQIc9IUvfeQ8cf2SiuAT8pObM30g2yl6lVM8IzeKUwnc45dZj+3?=
 =?us-ascii?Q?l+v8XGqwCTTcLGwnn/5PGKOM1pLAaRb3hdrLnvwvof9b6t6Af4BOjkjLs6B+?=
 =?us-ascii?Q?kEJOn1KvCzK38JyNsxS9YblWc2cHMmToN0xVWx1nGzuBx5pVkyDtDkqARim1?=
 =?us-ascii?Q?HX91qv/ijY9bNQuCdb1J0xY7ucPHqQo7IPg6LxzTZ0epNCznwWxmZIaMD20g?=
 =?us-ascii?Q?1YF6wcAROwXgF7hUXx6L4OmFD+RhVGy65cDy9ixIBtKdV+aKdO7InAgkoRBY?=
 =?us-ascii?Q?ZQI/czmRCBXLXqnm1i9V5JRXmoUMuQDFAr8D70igCveWxlFMyLHYCLU7CtJN?=
 =?us-ascii?Q?C3H515sAYh79lbaYF7kcl+X8HmQsk5prNfFF6bLy2RL6gxv/7IuQSajt8CJI?=
 =?us-ascii?Q?+npd3parlct8OA6Bh296X3Z6nFOho5ptd/otaRJKnDRMoOOhU7xOYKuOmAwg?=
 =?us-ascii?Q?igc0+YwCNaTkHMKo2lIECwaeycGHMlV0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vonryE5asFAQqE97afu0SIuUI6iOHZx5ik4dDF8q2Px2Q2xZN5mzCv3fUFuF?=
 =?us-ascii?Q?vTGBm2GtqW6Z8OUCVVJVQsdlizT5s8lE3519NOPlOBWavDYreqJE6jSnC0DE?=
 =?us-ascii?Q?s7STdId+y95fhiQ9ghZK6Pwn8BCxgY+Bo1JwsRsJ7RQ1+LFBapzZkIwv33TK?=
 =?us-ascii?Q?LmmV9Ym3KUiCP1bNMCBTJZxivmROfcIhBlozkOAZtFlQhCDDkpIBwOqmT11j?=
 =?us-ascii?Q?TaDBC4qBA4P48zcPX9IbbfDlqBKYuW2xwDm4o+jqYbQ4Pz6BwYeaoxbeRX28?=
 =?us-ascii?Q?toce7mJ6KBPldgesaZIVkXIX8pMHUgYDXzyHaBiWefunbJvb3E91JsmTpMGX?=
 =?us-ascii?Q?aDachgzQi1vMlEZMB5GgS3FPMrLCKaDDnAqo4pMbj+9s7gc2ZPMVfNx1op5W?=
 =?us-ascii?Q?Lj89m88iR4gdei1ALOX1fECCKZA+B07vQyzt/Lcmy3bqo1NV5fDsLkovohA9?=
 =?us-ascii?Q?HU03434q6IUiCaxK/ftZFlGztx45w8pqoZxj2LsMObjUWBcb++WtZMO0UV5T?=
 =?us-ascii?Q?OUc1Y8r/3Bq8j/+BJaSWforo7LTFNBhbH1EXE9H6Ch8dqBWvs1SZZ0CbkwrT?=
 =?us-ascii?Q?mDT1YXyEiVSi3RDN2sCktmuHyq2IVdea+N8UqnMDBmp5z78EZeqsborYbGze?=
 =?us-ascii?Q?MPdOxLtyTvyhnO4QcxOZyWSWyite4IIeFuYvLlAp2cbiCiz8LlUIEwf2f5Bh?=
 =?us-ascii?Q?YNc0vMEZLozhZethMEj/wsjjyT710aOnUe69RiR+CRHvKoLxEMIHEDUzidBR?=
 =?us-ascii?Q?FmHVA3pepX00K0bQ7KhjpDDQofvnULjRO07G3RpBeRKHSY/IokFKxknfKD2J?=
 =?us-ascii?Q?jsEcynuG1OYTZi+qY5m9hRs/2JOfctg7e/HNVHGt16bp/hvpw4nGbx4JRP48?=
 =?us-ascii?Q?SZgCLUlY/7oMPrepU9AfQahLAX3gwRwh4lxZkqUqt7zEKDQx7xR14uyrRM+7?=
 =?us-ascii?Q?xATtl/AC4QU0Hf7mEf3DqCoQUSjfo4KcUAhNjIwYw3lH4iwMZLG2W1sjljnS?=
 =?us-ascii?Q?1bcUc0jI5DMbIN4045QJsZLtGrq5A7uR1cDCaCwZXT7SsKBR1QYf2RFlQZKZ?=
 =?us-ascii?Q?XEKSZOxmdkKyEVETDFyLZ2x6Tko70JRUVEEq5pN80qicnswUu99l9RvCdCKK?=
 =?us-ascii?Q?FVnd4VQPuPxXDPSXEB9GPJittE+lXAMNShk3PRUov0XEFrZmvyk11t5JUk5h?=
 =?us-ascii?Q?A/dGtl7HoGGaO+5DDlYWujRyBpeSC59m67Rv6BpPJHMMRsuDKuNpb+Y8VySb?=
 =?us-ascii?Q?QZPYI1YKTa3pqQQgoPtkcwgDJZeWABa4bRjW1q1zP3dhtmfWhhOagJa4xo0U?=
 =?us-ascii?Q?3N5RmMKto02WZoOjMOKDe/qZAS8QD7MIPjSrhglEVJeJVnqg8yShim+npPpP?=
 =?us-ascii?Q?H34jb/0vmPfH9VIW07qaTSSP3nYaW05XCt+H+S1zVe9+5UbCHrJ0wrAJ6E8W?=
 =?us-ascii?Q?Udb8/Akb+Uow+A1LJzQ/yMPACHVyTjL5vbjADdjTyXxNy/JacFimrlsHG8sn?=
 =?us-ascii?Q?0n9U5pL9XpnPmT9Nij84GLagkCqw/QOA6ddl1s7YN8xy4+hKpviJwriCfb3t?=
 =?us-ascii?Q?VX8e98DyFFuYhqoJ6zoYtFoDO2Jw1pxbwA4FbcbKJhCzMyz7Vu0cPYPAhz9L?=
 =?us-ascii?Q?W08w8nSk6cjuNvdnTdtEEIc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8AD6D6DA378A874AAD9AC4A3EC463AA1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rea/M9yUb4NBuO22x2z+Qf/t576m3JdPij4/TdV4oHzrZfiP9d9FBLLiF8zeX5qgj0gv4wKxSoybk6iq56ghrgCEthHBYAIJwfYfmJmmxlc2D8gueDYVxFKMFu1M2Qkqw8o7edOvqUP5eXqjVA5rX7TqpRyVlCeaOv1ggfMDJwQoAarQBMj4UtqQtZBvPgJCCBZ2bf+2a/KCumnOJM1Pt0Ny+wPnAN4fKE0ovPegxYun5AJGqI0OxwGo0zlyoUIXeED6WX3Y+euUEOMifcpA/h1hYJnyz3TI2/dwiFvA/+3srYnk/CyCU+AS4PMdKmObHi98W/HJ3IoGJ8TIHZOJo8GhIYpnoShFmr6BDx5jGTl91MMudHYXN256qmG/zvT4TXhRf1G9h4V3kdpAGsXIRXW2D0qLBZWGJNpAR2FjADRqHNe33q2uqTIfAXfAX3g8lFWmL+WHATQzj8PtBgeJ9BAAlDklkaak731cYqN93SNYTk3yFQ2iIWo8kf+3orhfriGD8iSE2Vi6V7hd8+jWpl+yHw7YT5LP4sNC7wLwmOkF3xHo6Tpahp0jV1KDYxQQmW1EG2wgt6kUZ8db6ZOZH0qsSqN5Lq8PLHxqOdag4Re9VMDaF7EIext1I/Bx79JM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d50d4e0-c49b-4da0-3de6-08dd4ceac515
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 11:28:56.8557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rb3DjSWCEOWD7alnjzbmKJylAVkTYJWFslGqqWtNWF3yLo5If0sw4dDu6Gpy0LhwfiqeB2g/PLMs57pLbZ1cW75HL4z3SmLZHbGPjh4rI3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8718

On Feb 12, 2025 / 12:54, Luis Chamberlain wrote:
> mkfs.xfs will use the sector size exposed by the device, if this
> is larger than 32k this will fail as the largest sector size on XFS
> is 32k. Provide a sanity check to ensure we skip creating a filesystem
> if the sector size is larger than what XFS supports.
>=20
> Suggested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  common/xfs      | 11 +++++++++++
>  tests/block/032 |  3 ++-
>  tests/nvme/012  |  1 +
>  tests/nvme/035  |  1 +
>  4 files changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/common/xfs b/common/xfs
> index 226fdbd1c83f..1342a8e61f0b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -10,6 +10,17 @@ _have_xfs() {
>  	_have_fs xfs && _have_program mkfs.xfs
>  }
> =20
> +_test_dev_suits_xfs() {
> +	local logical_block_size
> +
> +	logical_block_size=3D$(_test_dev_queue_get logical_block_size)
> +	if ((logical_block_size > 32768 )); then
> +		SKIP_REASONS+=3D("sector size ${logical_block_size} is larger than max=
 XFS sector size 32768")
> +		return 1
> +	fi
> +	return 0
> +}
> +
>  _xfs_mkfs_and_mount() {
>  	local bdev=3D$1
>  	local mount_dir=3D$2
> diff --git a/tests/block/032 b/tests/block/032
> index fc6d1a51dcad..74688f7fca6e 100755
> --- a/tests/block/032
> +++ b/tests/block/032
> @@ -15,6 +15,7 @@ QUICK=3D1
>  requires() {
>  	_have_xfs
>  	_have_module scsi_debug
> +	_test_dev_suits_xfs

I don't think this check is needed.

_test_dev_suits_xfs() calls _test_dev_queue_get(), which works only for tes=
t
cases with test_device(). Then, it works for nvme/035. But does not work fo=
r
either block/032 or nvme/012, which prepares test target device in test(),
so they do not need the check.

>  }
> =20
>  test() {
> @@ -25,7 +26,7 @@ test() {
>  	fi
> =20
>  	mkdir -p "${TMPDIR}/mnt"
> -	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" >> =
$FULL || return $?
> +	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" >> =
"$FULL" || return $?
>  	echo 1 > "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/delete"
>  	udevadm settle
>  	umount "${TMPDIR}/mnt" || return $?
> diff --git a/tests/nvme/012 b/tests/nvme/012
> index f9bbdca911c0..f2727c06c893 100755
> --- a/tests/nvme/012
> +++ b/tests/nvme/012
> @@ -17,6 +17,7 @@ requires() {
>  	_have_loop
>  	_require_nvme_trtype_is_fabrics
>  	_require_nvme_test_img_size 350m
> +	_test_dev_suits_xfs

Same here.

>  }
> =20
>  set_conditions() {
> diff --git a/tests/nvme/035 b/tests/nvme/035
> index 9f84ced53ce6..14aa8c22956b 100755
> --- a/tests/nvme/035
> +++ b/tests/nvme/035
> @@ -14,6 +14,7 @@ requires() {
>  	_have_kernel_option NVME_TARGET_PASSTHRU
>  	_have_xfs
>  	_have_fio
> +	_test_dev_suits_xfs

This is the requirement check for TEST_DEV, so I suggest to move it from
requires() to device_requires().

>  }
> =20
>  device_requires() {
> --=20
> 2.45.2
> =
