Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73FB1A0BFA
	for <patches@lists.linux.dev>; Fri, 20 Dec 2024 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734694640; cv=fail; b=EDoSE1TWfF9IDKi6Z0NgMk1+b8YtqIhRmvM9PhGosuwVJ9YKeMKBz6y9pVOB2iJHMnYwhrCtk+8wShF43MJQkGXhx0Cjkgbonvd8RL3OVPuDupbJdbqfcm/TtPLqUOJRfBT0Z/7z7MsF03pITJR+LKX1AZBWm/tRsQdPG3r0sHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734694640; c=relaxed/simple;
	bh=7Kz+eWekF58j5+0HWFLt35Ph38sB8nAdNLcBMegksXw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pt9k3PITIDWTnFd2eFVEZx4Ti/TL0Z9Jz7tCtW1Qj7P3OluCeWOpUubmUROQ3MuYI1rjylCvawaMpK12p2i8pb/d95tQZTQArHFYchiTFuBLyuYRTBx4DOzilaAwbRaN5wGp9dPAuOAO6oWWdUwUlF4wgUbC5LSjq+IDPReZR7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VqC779mZ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=r73jF9aD; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VqC779mZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="r73jF9aD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1734694638; x=1766230638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7Kz+eWekF58j5+0HWFLt35Ph38sB8nAdNLcBMegksXw=;
  b=VqC779mZ/fKuHwHmWf0rqcv4EVYgWCaQD7ux8q4AblXAehDFn3T8iU+y
   dvdI+c2Cu1xBVN3taKH2RuvYAR47lLyfZy8ACXU425ZzqSTaecnAUhfh6
   ywHeHkufWtgJ+Eh3bvy8zd+xkrpxuSXn15A0Di7Pi8vSIsQBx4unNfjzo
   aWDc4sjlA7yVqkRRFlQttibPkp6JVKSUjqxCncmKz5eJOeaZfAWBj7KEh
   brldl1c4fwW+IaRaV1oghpF6s6TNUcS34q80oJVO+bnCs0eLmmI670G7J
   z7OX7oXcrqyNjQxlv2IxaUJfh10X+6M6WEoLYQawvPMkB98L4ZHfqoaH9
   w==;
X-CSE-ConnectionGUID: F1YQmKUoS2qb0iRU4g3oWQ==
X-CSE-MsgGUID: i5fNVMHXTVamA6RovdmqWA==
X-IronPort-AV: E=Sophos;i="6.12,250,1728921600"; 
   d="scan'208";a="33664788"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2024 19:37:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9tHmLKcRRp0CKIWagKtWpAYoImHFc3SCOIODbeICz2nqseKg1VQF2oPiWOQgyqUlXq9UvZqTkBhfd2YgkPINlRR7MSvJQH/91jQs96asowDzFmPzD2A4DuFB5+1mlg+8yj15dsIEHDOM18ZY+WbaTbWjz6B6SKlMBn1c48q4JfhYBF5/JUqys+2OnBw9jCnOw/0tXJhRWehdvQISNhBC0uBDBKvr8La0gZifBu3xrINsXSNSAxKkpx9PQT+ZSrkoPPfATCoORUKjrOpa1etUW6vuSQpaR+x9D8dqwz88x4rHG7YFai+LyYRoG6B4TLCVntpmZd/v/a/VImVN4v5SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hixvd1IDq1HNDdqm7KUopO8i4e1A+b3MGwUcS/TqxX4=;
 b=X72hN/QHdjq+2G/+4alVHWHlooDoFZekfYU+8vmmJWfJVP4Uj5RBrEG1BeRj6glukaWAHQ6g4CS2xAFWnoTeIKoh36n1XU/mMVc8o37R0s7xFmlaMWb6INtOx37RjopiiSmTZjk0q4gwxLf1vXy5+4Ut+y3NSWntR8PXNjZnvA8QHILbxGoIogcZTtu6nGpOMtQEinc2/a7YWTTDNrmFqS4khjcqe8f0VUaGL1aeggY9aAdFd0pFcKQyIp46/7Eltpz2ygmJCJvN5ONr7N8MVeWEJVvunNHE9BxNN2MoGJtCGPYHsgApFd/ES50kuovSo42PSO7RZxp4iX41lrMkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hixvd1IDq1HNDdqm7KUopO8i4e1A+b3MGwUcS/TqxX4=;
 b=r73jF9aDLQZ1AQRsS6ucDybQG4YuK044tQpocFxMPrRpz3pBoQ8Gk9JqfhQpCan0m+GxMcSaZGWmJB32dLMPd4B4Kk6HPqhAvDOZxfZq7BV2sB61Qte8ZMD4ooj6E2ujDaxL7IsajWC4+1uvdfTOmP9IUg5SiLXX+20oocHRgEs=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO1PR04MB9650.namprd04.prod.outlook.com (2603:10b6:303:271::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.17; Fri, 20 Dec
 2024 11:37:04 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%6]) with mapi id 15.20.8272.013; Fri, 20 Dec 2024
 11:37:03 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "martin.wilck@suse.com" <martin.wilck@suse.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>
Subject: Re: [PATCH blktests] nvme/053: provide time extension alternative
Thread-Topic: [PATCH blktests] nvme/053: provide time extension alternative
Thread-Index: AQHbUT3oFmt53QtKakSPsBvMmvOfC7LvBH0A
Date: Fri, 20 Dec 2024 11:37:03 +0000
Message-ID: <53p73kfx7akmecsc3sofrmga7o7m32gg2lp7e44nacxgwarfoo@u74aepo5erqs>
References: <20241218111340.3912034-1-mcgrof@kernel.org>
In-Reply-To: <20241218111340.3912034-1-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO1PR04MB9650:EE_
x-ms-office365-filtering-correlation-id: 880c8337-2577-4860-76a6-08dd20eaa030
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?vrTD3mErQz0+pJIhVC1ajktgs0OV/IxYRuzf1rNxW4WKYOmL3hnzApGyLdqy?=
 =?us-ascii?Q?iC5yp0u+Gqxxb2SUy0BOCBYCMIdff19NGKes124Agf8dy3V/aE+S6kiuIlfo?=
 =?us-ascii?Q?ArHIKB7UjRSB0fmsdHlq1r033TkvYit6dwr2fxElSVgeBlF0tUZRi0SqTEAy?=
 =?us-ascii?Q?k1OJLLvrZzWYeXUSVyQayB69jBKeA4oDiXFmCW6FQ0AJ+3ejWdSz74WYi8D5?=
 =?us-ascii?Q?Bk+Y9SOjfQsjTpc0/Dius/eUucNF29AIMBvkq2eMcNbhwuxfarYzxYSfBol/?=
 =?us-ascii?Q?qo0/v66obuAdzmBTkp0XKP0FVCbDJGG086AGfB2QRxgy+v8PXh4gmv2h56yc?=
 =?us-ascii?Q?qlfPEZqk5P9njkdmvLXISXG01EOLTz1VazIrIqBcoRqnjRYN92rW5+A3vT00?=
 =?us-ascii?Q?Wlp8vEUfsvUlQWZul6+7QrcMD6RXRpj7YjODuu+fxWt+InjUKDJpU02lKSLK?=
 =?us-ascii?Q?4dfM0FYU5RGyRRR43tqNZO0B33vc8ys0AXZ9kDx+PtIgRNAbxowXPue67yX3?=
 =?us-ascii?Q?P1RKp7OT4WEW1RkzdPZPuIFHbgKCA3G0WennnAgtNhS4M+jaUjdzx4WOdDA1?=
 =?us-ascii?Q?rgX4ngXXIIoCQBd7unn2mqEi0JGdBsrmSDnPDeEzu6GdEheDTzu93yoYVEKz?=
 =?us-ascii?Q?SLPVWRFzM+zgMigGyBmURTJGVzw+8XqtqZxS9gqHRVnhmkkBntz1a92Gx3SJ?=
 =?us-ascii?Q?R3bfQ46/Vu5wA3ktwAwaAiyNd659nXutH510dW28nnYOrPlSRQcBe3OZAmOL?=
 =?us-ascii?Q?Az+z+l7WhJ6kF5/tSASHTkRS++dejDUuCFt4y1pQwGejFZqYuuwSdozSyPHT?=
 =?us-ascii?Q?AqhVXKVY4y6diaoaFtv0vYc0aJQ4RM+kZdUNKmO1PRRhV0gVvGMC76OdPrqr?=
 =?us-ascii?Q?rKE4wbSqJFTSA9vZ2PZGZdN+4lyhzhcRaON9CCLURxoqCxwS+EPk39FtMFpX?=
 =?us-ascii?Q?zMu7mSzYWjHCt4q8A1864ODMfCYz2hA6PRH0+Nxgey0IzBHJSK44gJJDdbqf?=
 =?us-ascii?Q?OkmsdVmf//Falzrit5V9tn9y+IVRWwqp9y1i/g3hxBeIXvYXbvS+SEm7yoD3?=
 =?us-ascii?Q?gP000jlnQ6Q2Zylf03bROSUfxrCCyMQPcwCxCFmTbfWJzhu+pMyNcsPT8dkq?=
 =?us-ascii?Q?wDJmu3ec+WFUqaQPL0RZUoXaPJQuXsRx12YhuqBNEa1VRxmKVRrQNhVTqK5h?=
 =?us-ascii?Q?aAab4sURBREgNcqYHYFOXnDqHKWwpX7triAXzQ5DsS7/VpispTjEtKrukFVF?=
 =?us-ascii?Q?PXUo/krRUCIZwJoKgStzOwCIkybAjpZtZ4VFOEZWGggqnA2B6KSyuIDBVa47?=
 =?us-ascii?Q?NrV4ouDCZY16At63K4kZlK931tgfaSKc2ZIQUtH9prxAiRdDSVgatvcdzXuq?=
 =?us-ascii?Q?UeKIJgpk5EnczSAsdIeBEH6wZAMWdDRwf48YzjjKSgTfquyf3KCn7RwR1c6D?=
 =?us-ascii?Q?pAlnPLNhnvZyxf5BXdymuH6avbwA/4qs5302LMGbPhW04h/9nGEIEA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?e8SKNtZo9n7OzUqLNT7LcrkaKjrtfqs7YCacZSYjDryNy3Zlfz4NhQStq2r/?=
 =?us-ascii?Q?HX1/kaRWnN2A+P3Yriv1YV6q4XX3u2xfb1DBZ/Hm9VZo/nVSqVXSIuQDWRdi?=
 =?us-ascii?Q?CapAeZDMbLdbvbXnPAZRkMsuPcIPfo3Q9uS2dWVuWys0KYg85PudFkj2Tiq/?=
 =?us-ascii?Q?bk6Dg8IJibr2+s7MA1Zgm5JcMWwtnUkEoL5fwdphz7DM0CrNopiMTG45COeW?=
 =?us-ascii?Q?a6HH4qjCrTT8fF+0XqHDwtjwtmYBCbDZFf13fbpr6gPABFAKlbPVSeePpC9I?=
 =?us-ascii?Q?+DHHNJQg5bBY4UuyMH+I9skDvoM3zWpMi+EVbuFPdhid0Y5/vprwjXcUkMxc?=
 =?us-ascii?Q?jaqTt6IdL+UG/a+B7W1N0M0O+jezinNZObmYCnnHALOVqZMRYFtJTiKdSJT8?=
 =?us-ascii?Q?vL99ykG+f74nncrEm5ahnqXD5YHUgm5F8OFflhC2UQ26TAiZQH9mmW70Le2+?=
 =?us-ascii?Q?pAZbAt4ldbpipuapeTlkkSi21ZHm7K81UIrxIxiQJp4LVfMz6YZSJv7JgRFX?=
 =?us-ascii?Q?ooPRl2PpyK47vM0M6BIHePQELCFFb/90axyUw8M4FB2jzPRAveYLQyvSWa26?=
 =?us-ascii?Q?xmqNPT6WUi6tNxqQ5X9TsNIp2pLNQ8tHejqNRJ9oBtpyNOUN12wytYM1WejC?=
 =?us-ascii?Q?4/uvidqZMFso6F1DP6mA3D/5OBXgcFL3PO+cBscY57FGvQHkDXee/5qg6AVn?=
 =?us-ascii?Q?y/3gRQTaDdtEtJtdpYiGAubSCWrd//9mOaiu1GbUYoIQ6aNhjokk6lYr0Iac?=
 =?us-ascii?Q?WEloWd33czcZgOjqf6vLUIkRim65Cnt1IQkIEMA5o+oMx5j9Hr3qVBl07XYJ?=
 =?us-ascii?Q?9PPh6MAteU1ez73Kg1kzbo7XaWNIqqFCxSIqGCjw5o3WSSwrrlODDHXQ92FD?=
 =?us-ascii?Q?LjB8MmzXDTNXyn6R2/bZDnZ5y7+BHu7Ts/LbFKEMlr4ITYnkzWfx/6MMd9Y6?=
 =?us-ascii?Q?wCluLEuhnDIhiGR49ObsEQAeMqerGIrv0SHl25DYfsE/te5Cz6DfuWLD2xkO?=
 =?us-ascii?Q?LR3kN3j7rkK+SnrWSPHQickd3brJ7ddxkljtFDJmuiAFv40arPf8019hiSiE?=
 =?us-ascii?Q?zqiTtfPdpp4jpmNlckbrzbDm80RMniogiX+ViOWrxVcrp4+2H4i0HoyPvnUR?=
 =?us-ascii?Q?ra0Cg96UBGzBpAsD4menwXe/cRvRdvsITBYzL7EX3qsLuOIoKwvwV57doJ9s?=
 =?us-ascii?Q?9TRmofLO2kmGTM3qvHKh5kImn0dL3ixeM5nNUurK+cE1/832X5v89chknflS?=
 =?us-ascii?Q?CSmxx0SqUhPj1qvt2yQoo9Vz8ZbuACAwHE06qXD3/qyZetBQ0qKTDMUBffFn?=
 =?us-ascii?Q?nlxK+cHzv4m98/Zkr7VWDVaW+LP8SqEQ+rzR3KcO+NMOMCF0kp8jTmiAE8Sg?=
 =?us-ascii?Q?t0yv4zfSJxVmlILpYiYd7h2tydE9ME9H+WooV0A/TAOGwBDG2yWAWaPsl8Ok?=
 =?us-ascii?Q?l1e9fyyw8wxf0x1kEEe18j0TVsfDq3P7AAJPO5LDq6gjZu1DHn8xqkN0hef6?=
 =?us-ascii?Q?MO4dLbtEiihQSTC4EHfphF2KQCw3eA+QEEvKYN6fSDfNE7IQoun7euPmoEhU?=
 =?us-ascii?Q?REm+nhFY73iXjm6bk5ubdmovGfKXOWm46mPdURMrp+RBSVK7PCHh17GDCwM3?=
 =?us-ascii?Q?aJ4DpW+Aelv025EfbOO+NGo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E440B8EB07593248BC16705E6CE39476@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EPpmheuWg6XIpnrGI4RpBtg9Kx/APXcRx1rUVmtvnIJtmRSK6MdUXCg1wim58VtGXCBaYC8mgZx0qxIRRwYM1VGBv9Kq0VQnop2YMiqS7JF2/ZEOCkbNSVVTOhOD4o53/EM28HVMHNqiKwyodQFjqStoHChMIqmUej1+oosvZmhWtVsudZXrmOBRvEFT3h7YC+CUsSdSGUN4A4efnNQI91ffq4QeFgMY/VIsukX1IS3mHN5ASY2kWhOcLyIPwuWdUdV+zxFoKgUDi1ih4pRF//2iieECkgzq4+8CQc5SFyvsTMbaIlfgi8hNgIZ9wpidpZo47Jr9PYv2FEgzBL4L3NBb1QVoG3WFqnpZTOhJxh92IrN6k6KFDUTPRfbf/aSG3dkhqkr9vH3t7W9AOtFPefGl4Q9hfoA7eWXcRgWqnXaykaBZSIV6slR+hMPE8KrGoFpmv2FnpyvXoW3zGV2T2mQ/c5HYlOgFsQWDPX9ZZyMLZYK0SKkf/7Ba8unYAHlAKf7WgMqOrDlWXOjvwyWzkGNu6lA3rfuKKL8fzFbmcgOPxePzsQ3MPOifibmndaCddayhldRsj1nzlvHfmWVIeoGKKc6HVxMvNobnxhG0ePkCxVTjkvrng/EoVtDuY6Op
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880c8337-2577-4860-76a6-08dd20eaa030
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2024 11:37:03.8399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVaB9ds0G0cUduDFLyzURCp6PsobKH7xnl9ClkJ+XNq36KNSatuFHxN7lyUzCTQ3jqUDI742mpx2EM6jc14dt5rEOXB0BRmf6aqbO/JXV98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB9650

On Dec 18, 2024 / 03:13, Luis Chamberlain wrote:
> I get this failure when I run this test:
>=20
> awk: ...rescan.awk:2: warning: The time extension is obsolete.
> Use the timex extension from gawkextlib

Hi Luis, thank you for catching this.

> I can't find this extension either, so just use systime() and
> use system(sleep) for the sleep command.

FYI, here I share the link to the past discussion that resulted in the awk
script in nvme/053 [1]. In that discussion, Martin noted that

   'But the fork-and-exec to "awk" is slow.'

So I wonder if this system(sleep) in the awk while loop could be slow also.

Assuming this system(sleep) approach is slow and not preferred, I suggest t=
o go
back to the approach that the Martin's v1 patch took [2]. The while loop is
implemented with bash. The awk script was introduced for the float calculat=
ion
to get the random float number from 0.1 to 5.0. However, I think such
calculation can be done with bash as follows:

get_sleep_time() {
        local duration=3D$((RANDOM % 50 + 1))

	echo "$((duration / 10))"."$((duration % 10))"
}

With this, we should be able to drop the awk script form the test case.

Martin, what do you think?

[1] https://lore.kernel.org/linux-nvme/2cb6f86256803af00557f07e9573331c5111=
1953.camel@suse.com/
[2] https://lore.kernel.org/linux-nvme/20240822193814.106111-3-mwilck@suse.=
com/
