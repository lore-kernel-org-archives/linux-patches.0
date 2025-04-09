Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D4813C9A3
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 02:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744166872; cv=fail; b=RNTMDasCh83p+jpmSGwNbORGA8hvb9EYsteFPTchYImw7bFGkEVoEb/wmbLOa66Cn4xEUHfA/kACkYwxqfkRysIdScb85bFUpQ+4IyDrwdmTiLWAgLGux0gFFoX85ek0DElBuAgFPsH39N6IdNAaFx8W0cK8hiBSfyMbHDnQCzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744166872; c=relaxed/simple;
	bh=lFG5m2BqF6uVjE+pS2amI8H4OQpjAOSgPftAO/z0UjA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZUbPMQEq5sJ4gl+IJ1S5L06a8gS9+5aYHmTZb4cXOurXjNhawdlLKrBKZsd4lXloFATEZbuaDNwLyM7Hk51r0Dhd18JydfEQytzti2jzjQcDBi4Gu/f4ZIiGI0Ex4IyVfDVL5cqlM4FCXYQ1iI3tB9egqIm+kp1HedQwrpITXvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YxT7g1LG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=T1cMIYvg; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YxT7g1LG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="T1cMIYvg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744166870; x=1775702870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lFG5m2BqF6uVjE+pS2amI8H4OQpjAOSgPftAO/z0UjA=;
  b=YxT7g1LGXrZzUkFf/YExRWAcVNG+5LiITi4mzbhT8PpxO4PWi2TuFWRD
   Stziw55dw63xtBFZeO1ZYFG8NZzt3sTcgCUrltnOUTk5v/BBs6/j5ILFp
   QtA1tNN8vXItM3SMmwA5xBEJ3/uNfLxV35NCO+t8HdssQvZEewSgsTyGe
   amiMidXwbMVU7T+rd9aLq/HcfBX1ldLK2kYGDbJHun1wn7MnLUHl9HYnu
   1MApxs4Y7qk6sfSUc77yWCAHzsTTTd7CrP2em8vYOjdDUVwCYaT8MmIyr
   PHnK6MsKI6ETeN1s25ELYJoAF3TahO2wCFdXxvIyI0dlC9mCKdUoAaCyS
   g==;
X-CSE-ConnectionGUID: ah4Nwo1hRkmqXyQmHeioNw==
X-CSE-MsgGUID: JxiOCVvKRiSMCyXdIVObrA==
X-IronPort-AV: E=Sophos;i="6.15,199,1739808000"; 
   d="scan'208";a="73771005"
Received: from mail-dm3nam02lp2047.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.47])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2025 10:47:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nxICCOFg0mo+bCKJ7Q4kxRn8QV1aJOtqHw32bALor3FrdLLpIwOvWkO/2leR+/ZV0ETqHIFiEv/zvfs153hcvS/3keMbGWEvx6DWIRg9ep0F+YQpeOAprsX5Tdq8qpdcNb3RiWL0ETSVS+qBsMyYZ3AUtZD5ZWu5AJhTRYXmZWYqEtx2dr2bs2cHq4StzQjhcfBbRyy5MxJw8+B1byiapt7xznwUKn1R9lDkT6N9M5wos8cqYfJBQKi/VtP+kvFzQU8TskoePBaNzubd3wIrEg4IFgcchhVDPMwZhQFb3u2RhTgqb3gNIpTJbmTPjM+7C+xe2VXgD9W/xmHoA6coFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUZGEAbprc4dPxx+LtB6Oc2AoNtg98hT7ZAK7vofcEg=;
 b=Opn0KqhAYmbFOYvqCYVutCh66TfHhJPj7PjL31k6GV3itOpwIHvN2u3co/2iF26laDth4cZbEem87tIwZoBoTFAvEOzGorYMq1mCD3zgVZMqO0jMxmTwWwoZWLJJgbPz2PHB8tC4LgHg7nAhI3eSiFZPImaR/tyuBAuJ18lBSeqHldtARALeb0akOaIR02aaMNfItW3D4o6shPZC/FFuVWGIuE+Vpd1/Gsq3tDE53Waxt9REfAZOoadlrnOlwAyinOqI3muhQmh0Pgaxk8De+mwrFSQAX2HB9z1sJgymzexKCSSvYEv4BEimHAp4zeNS4QH/Iv36C5EMWVz/DB0mGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUZGEAbprc4dPxx+LtB6Oc2AoNtg98hT7ZAK7vofcEg=;
 b=T1cMIYvgyJowZBxvx1vKIM6VvqISF5SqzkvPvGt0JnWJAsEMPvO9jepjwG3R/dEm6YHMBR2PTxq5gRBHla8i9hW/eOG96DCKEnnfifFQN+IgYP5ErRYVgxpc9bDR2Lfky0OgHZ/opEdld9AsuBYJP2FwTxT4I7988RBzIHEwt+g=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY1PR04MB9585.namprd04.prod.outlook.com (2603:10b6:a03:5b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Wed, 9 Apr
 2025 02:47:46 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 02:47:46 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Bart Van Assche
	<bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>, Chaitanya Kulkarni
	<kch@nvidia.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Jens Axboe
	<axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 157/731] null_blk: generate null_blk configfs
 features string
Thread-Topic: [PATCH 6.14 157/731] null_blk: generate null_blk configfs
 features string
Thread-Index: AQHbqHcAw6P6W4up3UKX7HGS3tmv47OaopyA
Date: Wed, 9 Apr 2025 02:47:46 +0000
Message-ID: <ttwnzohgi7cwocpeu7ckjliv4ufg2hajvkx43nkygzj7i23ea3@hr4aul3pclz4>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104917.927471463@linuxfoundation.org>
In-Reply-To: <20250408104917.927471463@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY1PR04MB9585:EE_
x-ms-office365-filtering-correlation-id: 84b8954b-fef0-4655-a817-08dd7710e8dc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?IMQAO9zoXQJsroYKj9h0ZCg1hfXpFtG1ZvdboaQ+9Kvv4dCk1MSU4IL8srr1?=
 =?us-ascii?Q?g+2cIfSoydYAiuzC1JO0rrKsN9oaWitz0bVoqfEA/uuLH3jN0Qd4aCluile1?=
 =?us-ascii?Q?feFuEIQD0PUTFjC568BJf0h8MG3Gw+23qyUMJWd7rpl1zylG/9BYhGmqMUnJ?=
 =?us-ascii?Q?YOkGcvYrH3DNpkpFm43H95K9x8tZ/zZgRUt0k5IT7i1+NVqfpBttakfM/+d3?=
 =?us-ascii?Q?V560xhuXEHl32x8U2rrj90+vq+C4QcL1mTo3T0Cde7eSCbPd7WvTjZK/R4T8?=
 =?us-ascii?Q?dEC2VBLSGZj5sIYIuorTsgqsmVXg+uOyqvQByHJAdoJWuJXzOqMdiidJw3ux?=
 =?us-ascii?Q?icEUwy8o1sVodvTVkScZIM7OhbC0RU/uk7EczXvxUGuHYdoXWovMh0hSwTRG?=
 =?us-ascii?Q?8wIGCP+mqKPk7ulnuqEN/I+X5XiKkBnEwK+fZeURyaRoGEjpcGXfmI3mau6/?=
 =?us-ascii?Q?0TVS5ffjUHgyUGeK1OAgKzocc8qQc2BHtePZAiKfDZTToshEhbgRHKQ6eyfK?=
 =?us-ascii?Q?jvWQ4JaVqSjCpBcHECWHrwHVpacch9fITLLoviAxhfHu+uOyy+mOGLTWpxbT?=
 =?us-ascii?Q?/SqQrEM6lNKH+2n6TRUR+VlkpW9ntlZhNHwXmurOlUa88grJq7sbPZuD5GoW?=
 =?us-ascii?Q?b8FvEHBLKHNYEmh5qvdjTjc1yjIz3MSAto0g4dqzUs+AYTfh3YJrJdzPyi1v?=
 =?us-ascii?Q?VA2AS7WlT/KjaoQFZTiCfPq/ze1m7tsCmEcDOVxRcSaQ3oZ15/teWnBaakv7?=
 =?us-ascii?Q?OO78QgK5lSv+l7udF1jlCbK2ZwCFWQgVK8Sdrw2kp2A19cheUGRlbkMTAlyg?=
 =?us-ascii?Q?UxXcLw9joEpTpfEMxtcEgroj8hskfD+XMsHPIq0WOildu6/rVVzcoSLv2o6+?=
 =?us-ascii?Q?rJyiRRczFN+j7Et8+0LHiK57wWkfwSq3/DM1lJlM2GE5q6kXVjYl5qLZI9nP?=
 =?us-ascii?Q?HVsTAIAQyv47vC8wRL8ms7aT8qMp6XpJrfuxBKXkdpgCST7Ov4HmjSAJyB6k?=
 =?us-ascii?Q?jFo/vnVE3rQSxMpEQn9R3PTnqh1qaLptR9y/dqx5uk+BkRYumZV19/qgsGi1?=
 =?us-ascii?Q?k9vcAbkYFWWKHsFNRP2hoTavjPXJdvnPNqWZ46jic9KH7ifpZfZdf9P8Whcp?=
 =?us-ascii?Q?OpVCmuNrv3upUUmGJFrLgJEVYy0fVswAzaT+wgQMqLklUq9u+z4/4qf19WfM?=
 =?us-ascii?Q?ruNJjUE1HOzz6KLJArpsdXRs6o0YogYAXPf0+nPQHkIsT+3XA1+jIbUrXvgE?=
 =?us-ascii?Q?31hRIxZhlrotxuT3eFiRv6/XHxXQ3my9t0pXRVbuG5wQNlgNHCljctKmr3Om?=
 =?us-ascii?Q?MnicDa8zPfFJPVyy0BOhwmMDg2QEczt8vL0ofSZaASwbzn+NngDrNm4z9+th?=
 =?us-ascii?Q?ZYmjvuxdpT/1gsQBuZD9X1+p9J8hLEteU+mzXFUZZjIcAKkbvBLly3CQs9XH?=
 =?us-ascii?Q?LIVXVi14fITccQvi9ci2ZXkfo0AQlNIU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zvKVYWtOL+837h0RVeJgKaenNFh/8BNSf4+/gHGLDP2DCGOyDYFRVWD+46b3?=
 =?us-ascii?Q?969ETq3tpYqxcx7NEBbP26s5WMMH+WTgEM4slJ2jlpGdC7473mvKLkq6Gb2c?=
 =?us-ascii?Q?wm6WWaBNCB7dAznf7bChIOmp0+CyyXJPRyunUM8fJXHvFzbcqZgDPoRlyN23?=
 =?us-ascii?Q?fJufhfje4WTsfEq6kIxx5BRoFhz3ac3THCFj3kcxcQL9VFNiITNQkxq5TnyI?=
 =?us-ascii?Q?0GjFC0wwdu3CnvWAmeZRrCY87nu8q+E0xg3oxTjLKYM++4MUZnlG59qIoDZt?=
 =?us-ascii?Q?38LR7Qzr/j4lLcGrTghvCQR25IPYk5pDDz0D1BTQWkvpFzubc4aODLwqyzKb?=
 =?us-ascii?Q?kJW3resvmvu5jK6Z8u61bAmL5Q6Up5CXzzrK1AMuaBlfUj9xUON4ExA2lgvF?=
 =?us-ascii?Q?3RVvkcbXFBWpNT3IZ3hPvHcviIKor4b0ZgHQcFFw+hpgyl4jepmaT1qEbfH0?=
 =?us-ascii?Q?fbc08OxbrN0YzUr6ML7BHpQ9BqYGTZZRX/0UmoI2cWTEgc8bVADX5OgQG+CF?=
 =?us-ascii?Q?MIpogtUKPZg6VnE5CCCGy/M/9HOSao5Ki3HcTjpzjsEWg4Muz7f3WGEZmgTK?=
 =?us-ascii?Q?6XRqIjGulQkp1qf81KC/YcUU3zmAFPsz9U1Nv4F6tpCg7uNx/OkH0q8pkjQD?=
 =?us-ascii?Q?qFaLk85MFRvFy8MuiyFnvM7TBJLkwfWXaChwXRA0hGHd6XyJRzQm5+dIGUJX?=
 =?us-ascii?Q?phLoiWWy873dEpVi9X2pN11cFWMuzGnFhu2G0xAsyO4phN0BKR5CTNWaEyDW?=
 =?us-ascii?Q?lMHQvsv+c6RcNYrTeBTyNzTCTlyIBIjQvvk7RNOhgY6d4OAxIHK7rdyPA6qQ?=
 =?us-ascii?Q?8eIcBwSQLNZoVOYYiBnKFyHgIREgJVp4tU2TDegVkPGwW+Me23dLReBSti2n?=
 =?us-ascii?Q?01BQujQ5JRaIuPCfATdZn16OfDMVcDobW4h1e4PL08U/5KBwjeogjJJrTFaD?=
 =?us-ascii?Q?DislQXbeT9W9f+eoK/z7N+z0zT/eNM3q25DNKYTi00g/2DDf+fshLD6GO+jJ?=
 =?us-ascii?Q?3u6mDUasg4KB/KgG68PGOPpdwiE4rZMjSnHqg1g2fV7aq2axJhCfak0Cq2s6?=
 =?us-ascii?Q?FVyiH2glZcw9HJHIiNMNT4rAbuHyXuB76mNPtVEdlanwYRplK47lQUQ1Nuwx?=
 =?us-ascii?Q?k/JCPbYscy035Xhk2qOe9wfF4QIpFsClde8P+I7FtTrxM4zjIQt3prAHSiSD?=
 =?us-ascii?Q?PXNPpA1rERurAOeF4VKdADZm88MafXlcGhUGpH1CUyYE1cM6gbWBCetYV5eD?=
 =?us-ascii?Q?4LnBklNfHwCprmhuv22Y6KYuCosKLN+2n+5CgAfCYmLDIeagawna7zpXGZ/I?=
 =?us-ascii?Q?0kBwK6nKQlL5dcdarShItD69pmYab4nqnuiOG1OlOlSmNnfFzlK841jY8J4M?=
 =?us-ascii?Q?0zQyjmZzDBKAkJr752OF1JKOv/cVA3XSvr/Ap9wiBRzy0xtzi7ZGGcSRYKWv?=
 =?us-ascii?Q?9o+KTqr02ZOfYaLvjqcRRYTBuzhUN5lU1CLG0SGHfxJesQXPN6cKdQLGMfBU?=
 =?us-ascii?Q?Xf8057ZR6AuzXubd4Nsk7TmAGF0hWTgQaV4SJYd8yBXtOffkFT7NnyGx3eD8?=
 =?us-ascii?Q?zBfe3comXjS/+J8NMGIjzppvRRHl7flpHSBcbWEPeyDFgnHBbAkSiGx+SSlS?=
 =?us-ascii?Q?niaQtsanCDvDz1JOaLRsEdE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <70C82A4A5339634290524835A1032C11@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FVQVw6TqQ/G9ZNtXaiJgxqdbK0zTjrDB8jCEsTQCIsIWf6oaMmVcbDIggSXQ0UOOBqzLPXSA7u0BbN6SFQ0DnlqX79oxCg95cvFdeioNoS/IRUMTr5qmqUxIH7nLqCy7FAVlPcAcqLOV2rVkha5v/2XDPEacS3VVXA2awYzc1Hbv6NJtYJ4a8Y2xGbT0cK5rQDP8GS/BB0SkPRSW2LzZYOg7JJLIPgsZxnxjL/7n3+uJQrervUlSHe0pISY9HDhmfGsUiyJo/F/CLjiuQMEsQrdweLbaXhczTsk9iP2CbrVm1/Pxui/DPfyzwXHzbch8SvhxaiDG0G7fHAMp4kSdmVelb1B6NBuQtTb8vnOXni1kjJe2EJKrw/XMV4m2vGgLo4aXt98y9N9RJyNduu8GQ1yNOW+6uE59sMxJMTxVLtoHkM92uljOyZZzMXYb8LG1qE9FdIz+RtMYWyBo/nYTsrgoB254q2lEJ2MRMddVh466qwbb7SGfXgu9HVTmboi3hZ4eF/CzEJndgsJbB/lXPjYB3+SD1YwA18Qbsp7J+qa/37OWfBS/Zkwzheri5e8StT2eY0I/tGja2VXOdV6HUw+Wq+UdmU5PxkuNVYGGrNCW6DLfZGpQOZJwlErxqZpc
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b8954b-fef0-4655-a817-08dd7710e8dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 02:47:46.6335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fd0pIf5sUyQViX2pwlMV/qBmT0Nvn//BPkX1h3QHZ5U5GOlJvbeuJRG9HQbayajT319Ep9b9oE22CzNFhnbb5WZNuVBJgSbW5ztPyKfuY0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9585

On Apr 08, 2025 / 12:40, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>=20
> [ Upstream commit 2cadb8ef25a6157b5bd3e8fe0d3e23f32defec25 ]
>=20
> The null_blk configfs file 'features' provides a string that lists
> available null_blk features for userspace programs to reference.
> The string is defined as a long constant in the code, which tends to be
> forgotten for updates. It also causes checkpatch.pl to report
> "WARNING: quoted string split across lines".
>=20
> To avoid these drawbacks, generate the feature string on the fly. Refer
> to the ca_name field of each element in the nullb_device_attrs table and
> concatenate them in the given buffer. Also, sorted nullb_device_attrs
> table elements in alphabetical order.
>=20
> Of note is that the feature "index" was missing before this commit.
> This commit adds it to the generated string.

This patch and the following 3 patches for null_blk add a new feature for
debugging. I don't think they meet the criteria for backport to stable
kernels. I suggest to drop them.=
