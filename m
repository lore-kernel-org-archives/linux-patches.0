Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFA63D
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738927581; cv=fail; b=BZGhm7aqOx9Q6zNJXEJdRc4uFsBn5a92j8Fk46rI2sOhkXXAFSfmT05Bkm8CvOQrLtLEKwioUfoKbg/04GaW7z9/hu7g/iFiZF1M0Pa+YPBOoITJt/CpGKPybdnMMtOoS1WTVBFarU4j+kvyWt28CJ2JMxUg1u5m4atTJZcUqZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738927581; c=relaxed/simple;
	bh=fsVWE/A6cciBs3tfDE8vx/R1OyiYWo7BPg/WOS1YBcg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mHArpN9QVfOtB/uVykmexHfYxybXJHcQQrMHiK3PBzkmamIzm3TpUFjxSh7do4uyQui0LZz6gNxNBvlLZKfMLbmMuMKZ6A4pMzVpUBl/CCoJatcfQ2bKFn1oKjTsVmVf4xmZYGU6E+U9+D30v4OVOVil2DT0LxW88zLl3MpwJVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nv5WqWDW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=mPYseYg+; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nv5WqWDW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mPYseYg+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738927579; x=1770463579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fsVWE/A6cciBs3tfDE8vx/R1OyiYWo7BPg/WOS1YBcg=;
  b=nv5WqWDWK/LHM5WUrgjQz9pNW8HzW4+gHQNa0R/1tF421ULQlpeT0YpT
   CcFjrqC3rlB7xC1QfCW/msv7rVQ9iu2yJzxNlkXYgYjVXmoKXsJ4Q30Nc
   2f/mLs/sldk/1rxS7ALFOWTVgafSNVuYKYFyZCmIdEs3nKVW4weMgP4oE
   0dVLkZgLnhrFLtanKqyYxiNXRpp1QwRiV80wTo87jzDFxqDG+tx7/UGDi
   7lqHZqrovh4DC7HU7mVrFg1jPgrw8cvkYYpkj0DbHQNj2LCpmtA3utg0p
   dRy36l82AMQIC73TG6n5l+OjpLq5Yse/UJPlgg1H9Dq1+kt+L9BMCebk6
   Q==;
X-CSE-ConnectionGUID: tnsOjDDgS+iQdHY7yJL0Tg==
X-CSE-MsgGUID: xFQggy00R5qxZnde/IG9GQ==
X-IronPort-AV: E=Sophos;i="6.13,266,1732550400"; 
   d="scan'208";a="39101218"
Received: from mail-northcentralusazlp17010003.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.3])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2025 19:26:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RPtku1Gui+Zkv804H0LL9BkvE4tGMbTP3ah2bcCRGnLPScc7KvcD5B9COgXrMRkWBDWm5WVgJPbSQXxuw6Azr56FozTvyMji/BtLfote3HMdhmsVAFLpI8lh4n19nicRu6z4pjsW6N1prK/2bYAI3D0L6m4H9I2bTPrz/Q/vEHF7UkWfX3Y76rYsy+vy1SqNiP6LifHaVlyNZrPg38wIasWvjszpK0/kC6O0sM+Zh8vpTfg+QoIKHS4yUJ11g9I1bomYrN6g87Xw3K6q+tlTwDHcvjFFEGNPaAClYOXH/lz7Tfo9aL2pr7+5OpJvmmktK5X3XHBYpKiVVnAhQs5qPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JRpnjgfEj0IHtMhKC8YBrYoBgqBAngulp0j2Xqt4l0=;
 b=S02POAQLdjKGWOHVzcLguuuJxl9XCCynsJJNRxnfcJzR2iTUUvb63oJzS2CCKKBKKPeKDzdx1QvKhokEVWOKU8ymtRUloKoSCcUvg7qXHVO7KxHMDjVGIWdKhMwGsGWcvmNx0fSOgNpgBphXYookbQZBl5tCCKzojZCxCVz+TbW7/uFIj2YaVUEjG+s2mpZ37Sp9iU5QTMK9n5qHDo0FKeh8b2OGOF0rEyU3SO1ZGoymeRI89HVhc6ZQDIDnpkI9eeFVFmKPT0pOVtywslx3FPi47q2plIRRFru3RY+KGbIO2zvg/s2AL5CtPfqh/Lxie0CiO/4FFO+Ch5QXbDL39Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JRpnjgfEj0IHtMhKC8YBrYoBgqBAngulp0j2Xqt4l0=;
 b=mPYseYg+r9ow7WwjWkMJI9v7x8m5R8PQe757fKZLuM9eqMUbEPGUetRpRJQRvF5I4ebvopUaKwB1h+OtrIcrJLaxCiNLXzrCC9L7aozE/sURf24bLmqyM/S0PrzLpddbRkY8VzJRP5pmVj6QGKPk77330oH7zbohWCe3vPzhpWU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6427.namprd04.prod.outlook.com (2603:10b6:5:1e8::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.21; Fri, 7 Feb 2025 11:26:17 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 11:26:17 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v2 1/4] common: add and use min io for fio
Thread-Topic: [PATCH blktests v2 1/4] common: add and use min io for fio
Thread-Index: AQHbd1gxYtxQ/HP/C02dmu8iHNOFd7M7t4MA
Date: Fri, 7 Feb 2025 11:26:17 +0000
Message-ID: <rxgvw6zkrqqoyahgr54hcnbpi3dwgw6ataiy466rcmlmwmhrso@sdf55fwqxddk>
References: <20250204225729.422949-1-mcgrof@kernel.org>
 <20250204225729.422949-2-mcgrof@kernel.org>
In-Reply-To: <20250204225729.422949-2-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6427:EE_
x-ms-office365-filtering-correlation-id: 19384bac-66cf-43d3-11e2-08dd476a3cfb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?+JRWTu9uLEc8/Kh8WEBuEGSaWf3f77nmBZjqJPUsAUK37NNggLMxNRWr+BXa?=
 =?us-ascii?Q?k0JV7hnfhGBU2pCl9DvN2SnFH0QD67aiwyeoMTREl9WO/Gf57rmC0NTUCwlp?=
 =?us-ascii?Q?6BLxkeusqQ+y7ChpS7icYzJpwPHAijqtM57eXDOgHEP6loNFq2vkQHrpOVIm?=
 =?us-ascii?Q?eNGm+3hULXq6X8L4bCwGAfA1YKEKL5H2uk4l74/d18pD5XjLYVpHg90IXfku?=
 =?us-ascii?Q?T1ott5CPxH0RJB4sMS6EjMiQulSYyVuhJp0Y0sOBObSPdWDxmGkXtZLQPR/E?=
 =?us-ascii?Q?RWv2G7lUf7n4AGBn44xmrThbvZbrFaEee5IisaR83uSnDg67MKkpnrbazK4S?=
 =?us-ascii?Q?Ca/yDkBvf1FkNlctfO5Boqaplw5hJ4alMlHOq0+cygo/aBlya45pCAr5D97U?=
 =?us-ascii?Q?TZLHF0B/aIJHVCyZYswkm3apvp2yJ/h6bPMqbJcIXagb+CaeNsVooTkKA69e?=
 =?us-ascii?Q?kql8MexUiOOvnY7CaJGHDrx7P5PRL7H5TRNGzUec+WNpEst3nQfdStj1Whtz?=
 =?us-ascii?Q?XowAPGuqN0lbVmoT7P8iJX0do5HzmTHUOv+MVuaRouu9xV9PizbIiJ+e3nDI?=
 =?us-ascii?Q?MCVJH/s3fOTXNi3UpdDHqY9NQ3So/EqGdHvzl3+ySi9aYEoICc/dektLYZu5?=
 =?us-ascii?Q?R/Ht120Rmog87bBiQmU3LmoBKvXqJTcf1nKoDBOrI9DgdWDO1HAEbIXlo2ts?=
 =?us-ascii?Q?MOGq9CtD8ccrKXgp9ugpPRnluEH72ckgnZ6KTrLPjqXjqj+OXi/tMc5s6OEo?=
 =?us-ascii?Q?hFAl7T1HG9Q4GQ1yWWhvbyBhztEL/yFaF+9YrVKEOtMV58XiVDf+A7NeThTM?=
 =?us-ascii?Q?UyqtpIDLyIi/queyz69vIbMbDQoFPLucD+APeqvKcmdomZTTTPQnCQAPGigf?=
 =?us-ascii?Q?9jbBzFuCJRjNYRRM+mlFlVeY2HxSs0ds+4yuI7PO+8r/ZjoAs1JW1Ic9Lm0+?=
 =?us-ascii?Q?X4ZpUnwzNTjf8CRoH5KZHKmCPn0PgZkfKkRdsSZgoY7VI4bOCNOncROMGcnl?=
 =?us-ascii?Q?g6+AGa7zuvC2ZyT50teVugdQcAUvWvlwcVfNnS8TCDDNc/lV9U2ac6SaQdJQ?=
 =?us-ascii?Q?yTJo6bVIfVMT5kqJY32kxFfN51dEbz5EN+rarfJnxnLqkjPnEnQMopjvnu/F?=
 =?us-ascii?Q?CGX9L5OXU9yzn2desYSl4iRJz+5C9tfJn+OCBQ+VrhOBnXrax3gi0t0XnHWE?=
 =?us-ascii?Q?LPj5J7jiYHlfFWpYOgCX4OUjOKCajgj6h3pLDLXNHqRA5/qJGIf3OPFH5Xm+?=
 =?us-ascii?Q?YwHb/3aSJpsASwmlIbo3GoOwfSfsJOkHj0MaVsWYvkiZvryi9Rb3e+mFukhW?=
 =?us-ascii?Q?JbUR8ICJz70Fo4dj2trvgFvRSbhsNSoQX110DdT9xIlcJoRWtJQ4uwGKfq0w?=
 =?us-ascii?Q?kF1XNsiTcgmAvcsypM3C5/k96uMY3dc5wQfIPHAGpQYbRkpSth2E2Km8Taxu?=
 =?us-ascii?Q?GgshsqhYoRWapyO1Suc+4l2GfWwpaVYT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?oaYQbjBBgLkbbz7c1NEj4K2nsOo/JXLmaujA/eQ1HUvy6GrQ6/11Fh6dqjuz?=
 =?us-ascii?Q?HcM/yXTdmf3hMiwhLnDwVtBwF4+0/ZawTW/dFDV45TVTkxIFB5LGrfFFMGTp?=
 =?us-ascii?Q?RnXedZ1Svdoj6H2ro/selOKq71DnoG2f7/uBoYFK4ojSfdaWhzDE8y2Z/7Ot?=
 =?us-ascii?Q?6VlzyijO8vWQeeYBOfVUSvDnCpfke5Zhhwu22+LVbPBNYmZuXos7+A+860R7?=
 =?us-ascii?Q?jyt/4nDB3ZKz/nLfsJiueiMFHjjRAD3hRzM60Pl2h3lV1I0INIehg0/+Kxe4?=
 =?us-ascii?Q?C9YdcuJEb55vuSuHS1CXtNFG1VrsiOCP9odCjV5HeoTjI2YLw4jSyBiOLBSu?=
 =?us-ascii?Q?9R/FyxltVUWd5YPTXFlWuMYs21mxbqiMokkax0jSQReEvxhTLAj6bXOd+1Xv?=
 =?us-ascii?Q?Lepe9qbJgyCmhi1b+zGhjVA4XiyIvX/yx5vYokdqpy34PcdhWCoF5qt2bEBo?=
 =?us-ascii?Q?VAx5ERISqT2Tpr8kagADG9fEjw6elPON53+fgbylOPg4dYqNnYE7VbwbJ3pN?=
 =?us-ascii?Q?OJcLmQLCZ0vL7aBf1GuSTUm0R4Mfx76NWordHIRqiqdNJLUxUiRJbuah2aGF?=
 =?us-ascii?Q?HzCaClA+WEUsu0pLMxvUzu7tEoTUAQgfRwqfb55k7cQ64ivc4fRCLxAXiVLD?=
 =?us-ascii?Q?3Vfe5DNg0BMYugw4SoKuSHx6quQkP14T+cVqMB73qbw3OG8nav07JJyRADWM?=
 =?us-ascii?Q?F9EHjDsAmj26rYD09GUdHxamglMQOXxGVfxoLC3xIW9YvEIYa2mqc2WiBGNa?=
 =?us-ascii?Q?KP7/Ok3J3C3mARrs1OkH8x1+Z7fl/R8mNp55dyQIH/Z+RykrzB+5ghrZ0NvW?=
 =?us-ascii?Q?RY7cAtzmZsDzE3UPei4c/ReyJVUKs0dGdXlwyeZZIgouObnGJBBaSvSbEquj?=
 =?us-ascii?Q?P+JQxEDt4f+XO9R9wtXWCgvdWjukLLYgWkKiRBIe3/D1XmmM6/c0hXx4ESig?=
 =?us-ascii?Q?76rZT+8wmXwhPqs2KFkBQNjEsyZb5T/jXoyFUAwZYkKAhgLH71cXrYmHKug5?=
 =?us-ascii?Q?LZ0MEU6Dz9791+PLo+GkV0kXzrpEU2R98MU8JpetwChpGbi5aHHKc1IaXdS3?=
 =?us-ascii?Q?WOOZo41Qm4Na7ol/62JLtpZj1KJKBZLqQd01Z48CRU0So/gRxcHCjtPWEtN/?=
 =?us-ascii?Q?Vlp0EAOkUoluxrrwQw3yXFl7LyaKmrfGo1O0kxtRHJtrXG3uoO6O3YuBiXWP?=
 =?us-ascii?Q?1ztqHKmfIyOK+rHlfCQ4UtMb0b8aMQfAJtNU0xxhhQMdnVY4qiwPlVxVGO2X?=
 =?us-ascii?Q?WRLprjH1zzvOyWv1oG/idihp/TLxO+NngM5TUxQitUGnuHThZzQ8m3AFL8u3?=
 =?us-ascii?Q?VGoI7QsGOf5bee4BFIXYDe0HLmEwJ4hwPvfG7HRA7wcYP8vVn7bPceHadaS0?=
 =?us-ascii?Q?JgO1UK3EwCknKva+d4n6b3AkJUFa5jp3ndeBXugzevwEOaglpTj6CLB1hYOi?=
 =?us-ascii?Q?m8Z+H4El1YfKQReHFUpUJzKvlLIOxx99GNxO9DaWdd7m1NnBRhu/YGhe7MJd?=
 =?us-ascii?Q?2JQDwXLJblfW/RsknzojwHgruI9Vq3lHORObP1k1aGb/wHph/laeUKnp6Emu?=
 =?us-ascii?Q?eQnsUGrG7Zb1Z9umL/e8DA2on/JQa0sZ0QzUOChDCTTWmwa+AJR8fd8hyWuS?=
 =?us-ascii?Q?PwM8mkT2sv4FXxauNMj4zDk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <409B2F5525C8BB469F1F9864F2F01DF6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JH/9XE/RQParqoHGDKvwavMHERVBfNYEzcHjqX85lHPHG43l4SXJw6cru0k9+pRNZxuY8iH6tw5t103GY0aFFLd8jopVnopmBbS8pxeZm595ga/Cgeue09yEL4yDDf8cLtXJlUd5bJffrD4K/YO1rPPoEidI5PmUQdHtpoxzqeaffysDzJ9OG3r9E+OauGJc9n30D5G4raEHM2JfXhi/67YGTtyTSfz6FDyFQDI5BHuJu6iM9i19H1qBPfYzN2k4BF/4NsUSS1GMvlITSkFGcMCV4ESyfTWyIGlfCWi+SP/YxTseoX8Fv4AKYjKZVYo7EeBY1L28pPlVOFHMtWxGN4ogddSweJvfmMBYtpq6sdCNi1XZdZbD/oe5tRd2pM4TarHCjVsTV9XEVC66P0SH2HdNIuX4fBOSEFmIA2xsA3c2xISJljYfTwEr+ph+XjPo1zp7sdZIVV0i+Rftsi8BPpLY5vHaljnShaRkQ9Wy8n9tfA1a2x8spMo4XUiQtATXQn2KxHexOgNVN9KOGthQ65F44vX4a3mgV2Hiy4QkN/Xoc+0g0y0LEiZqH24TLPmGX8NuuchGrlVinKZtBj3eyVEg5z17i+sIq9dvwy5J1doMktRAG44pMAU5CkE+LsPk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19384bac-66cf-43d3-11e2-08dd476a3cfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2025 11:26:17.1437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oiNPib6T7OXwrKZbqbD5I0BGLQN3BprTf7y9kPddZxuaIGPnhiqU2JkR+ya+DUPstkCMDZDo3A/HoqP25W1Ca+ufAQTHHJwJTJTSInEzks8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6427

On Feb 04, 2025 / 14:57, Luis Chamberlain wrote:
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
>  common/fio | 23 +++++++++++++++++++++--
>  common/rc  | 21 +++++++++++++++++++++
>  2 files changed, 42 insertions(+), 2 deletions(-)
>=20
> diff --git a/common/fio b/common/fio
> index b9ea087fc6c5..557150656b29 100644
> --- a/common/fio
> +++ b/common/fio
> @@ -189,15 +189,34 @@ _run_fio() {
>  	return $rc
>  }
> =20
> +_fio_opts_to_min_io() {
> +        local arg path
> +        local -i min_io=3D4096
> +
> +        for arg in "$@"; do
> +                [[ "$arg" =3D~ ^--filename=3D || "$arg" =3D~ --directory=
=3D ]] || continue
> +                path=3D"${arg##*=3D}"
> +		min_io=3D$(_min_io "$path")
> +                # Keep 4K minimum IO size for historical consistency
> +                ((min_io < 4096)) && min_io=3D4096
> +                break
> +        done
> +
> +        echo "$min_io"
> +}

Spaces are used for indent in the hunk above. Let's use tabs instead.

[...]

> diff --git a/common/rc b/common/rc
> index bcb215d35114..e12ecd025868 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -387,6 +387,27 @@ _test_dev_is_partition() {
>  	[[ -n ${TEST_DEV_PART_SYSFS} ]]
>  }
> =20
> +_min_io() {
> +	local path_or_dev=3D$1
> +        if [ -z "$path_or_dev" ]; then
> +		echo "path for min_io does not exist"
> +		return 1
> +	fi
> +
> +	if [ -c "$path_or_dev" ]; then
> +		if [[ "$path_or_dev" =3D=3D /dev/ng* ]]; then
> +			path_or_dev=3D"${path_or_dev/ng/nvme}"
> +		fi
> +	fi
> +
> +        if [ -e "$path_or_dev" ]; then
> +                stat --printf=3D%o "$path_or_dev"
> +        else
> +                echo "Error: '$path_or_dev' does not exist or is not acc=
essible"
> +                return 1
> +        fi
> +}

Same here, let's use tabs.=
