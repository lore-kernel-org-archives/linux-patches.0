Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0758C1A840A
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 13:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752672409; cv=fail; b=FEujLZxIu87E6a1XyWG+SX6TPwieL0NkobbQwyWRelQDeOu4LulfJociqM4VjQhM7lh7N9Q29xZxv1EC+VZWdwfpNtphyxdDK0hyOOtBfP/qiSfYglFXvJMQ+8C6xrPCtCzJeaUqH57iVfrdN9RJbDSS5z6YKRxEwq8sP46RkHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752672409; c=relaxed/simple;
	bh=2woRELVHNVyshBDQlp+XBscfMnl0ayZXPRlzVywt9vc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BEJKyQxh2ONPk6sGVa6eyXTLbzAXX1r+wfZe8JbYRjrBK72Up621It2JWK/RALcElFewAjxTnwlAN6f8QrHfigVjIXe0vwVCAhwaM9TCZlkvjsZ21kFnYHG7bHPGAr6OiXAAgZx830s90H/Jl2eIIQx2Sc5LxajhTsprAoOtHms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kIuSWZWO; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Rh9Ezuy+; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kIuSWZWO";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Rh9Ezuy+"
X-UUID: 80d9d2a4624811f08b7dc59d57013e23-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=2woRELVHNVyshBDQlp+XBscfMnl0ayZXPRlzVywt9vc=;
	b=kIuSWZWO8po3+Rwliz2x4mSVFB2NNduTfjga2WZ23MgYvYdicQsVY+2zXDDbypRz2JMJ4lkC+f6j77ds5AjRQzFFSJP/huZpkmNJNWopTT0Z/tQ8fHbKCtNcfPDfWzvpFom2DCPKaXShqjspCHW29C8qDTo9yU+oxIk/o4135bU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:bd198fad-a419-402c-9d03-b8eba753ea6f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:6e29f299-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 80d9d2a4624811f08b7dc59d57013e23-20250716
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 47054400; Wed, 16 Jul 2025 21:26:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 16 Jul 2025 21:26:37 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 16 Jul 2025 21:26:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtX6OdnhvfrMqwlfZwtAJ46xZjpIlMUuZuR8ES/10nOGGvxkaK0chAwqV71oYHnM51KHCz48DsJnstc1v7b8PAlFemt6zKy7+qORIkHsqqwKjwyiU0GXfo2upfLNXWGdCsylwuRrZUVHdJMCQuF6pcrce3wLfBf/8/8iy9qCA3IJP/+w0V8PZQRbl8D+aFjtBgxLkhqnAylvpnzVDZSnFVvEGKnnKvlQccM8foDYn79Im32Bk3TiA8gKnfaHogRlad/H61XBt6Mql2EqFaoEgu4ozeoGepLhW0BvxB1uOvLbXcjE6UakcnApxcJdQHp7eZd6HNDcX//xcr92pJK+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2woRELVHNVyshBDQlp+XBscfMnl0ayZXPRlzVywt9vc=;
 b=t25YO+YThP+8DAqh88Fo5jwzrggXyh7Y7SdSUVp6vIE77XoOFxjbOWlIfk2/EGWWRghgJvgddjdqjnNBUnTekFJJgcSPqdDx67rlPApRj3oGVjzLgeH8wwKSc7RJqGoGVxl0NxWTtZaqAFBKXdhSQI1G1oYuT8sX4B/SCIbImhi0KlP+d5MC9tixP620JUY818hW6CJ8d1HPyt1Nok+p7SeoM5UsAxjt/lhYNvzH42DoCPmqOHq2YVs2aQ1pv5pnSAosBDIrEUBhBavyux5/U2c5AVCPhV8lahOCZ/T+XP2R89utwXNaPnpiQh/9E+9vZpKsebG56O6z9SAF+fRq2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2woRELVHNVyshBDQlp+XBscfMnl0ayZXPRlzVywt9vc=;
 b=Rh9Ezuy+tfae/Hz/zlLm5RwfA6URurh6ypuxMKd4FUQWRJf/i8HFlLn7BQWmle+ab/7AoZm8i+FZgOwijc/PMGiRZ44Lu3XtOKkgU5fZ8PZoZq7NG6TNbLAn8wNz050solydTjpzKVUloWjmfLQrjgko28biJj8hZX40qEGlMlw=
Received: from SEZPR03MB7810.apcprd03.prod.outlook.com (2603:1096:101:184::13)
 by PUZPR03MB7209.apcprd03.prod.outlook.com (2603:1096:301:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 13:26:32 +0000
Received: from SEZPR03MB7810.apcprd03.prod.outlook.com
 ([fe80::2557:de4d:a3c7:41e8]) by SEZPR03MB7810.apcprd03.prod.outlook.com
 ([fe80::2557:de4d:a3c7:41e8%4]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 13:26:31 +0000
From: =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?= <Macpaul.Lin@mediatek.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>
CC: =?utf-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, Project_Global_Chrome_Upstream_Group
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"peter.griffin@linaro.org" <peter.griffin@linaro.org>,
	"conor.dooley@microchip.com" <conor.dooley@microchip.com>, "arnd@arndb.de"
	<arnd@arndb.de>, "will@kernel.org" <will@kernel.org>, "macpaul@gmail.com"
	<macpaul@gmail.com>, "openembedded-core@lists.openembedded.org"
	<openembedded-core@lists.openembedded.org>, Nicolas Prado
	<nfraprado@collabora.com>, =?utf-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?=
	<bear.wang@mediatek.com>, "sashal@kernel.org" <sashal@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "andre.draszik@linaro.org"
	<andre.draszik@linaro.org>
Subject: Re: [PATCH 6.12 2/2] arm64: defconfig: enable Maxim TCPCI driver
Thread-Topic: [PATCH 6.12 2/2] arm64: defconfig: enable Maxim TCPCI driver
Thread-Index: AQHb9jyk4qZzv2uKXkCC7OfMA5VfC7Q0jMkAgAAK/QCAACYtAA==
Date: Wed, 16 Jul 2025 13:26:31 +0000
Message-ID: <f1820496a5b54c0af0accbadf54a45b6969029ab.camel@mediatek.com>
References: <20250716102854.4012956-1-macpaul.lin@mediatek.com>
	 <20250716102854.4012956-2-macpaul.lin@mediatek.com>
	 <8698f842-a464-47b8-8c47-97cda016e227@linaro.org>
	 <2025071601-unwatched-chowtime-82ff@gregkh>
In-Reply-To: <2025071601-unwatched-chowtime-82ff@gregkh>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR03MB7810:EE_|PUZPR03MB7209:EE_
x-ms-office365-filtering-correlation-id: bf266c71-f1ba-4a6a-0f5e-08ddc46c609f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aXFwcUlrSDlablQ4NWVWeXVmT3JxQjdEc3FFS21rMzRkMk5iSjJmZm5HR2Ir?=
 =?utf-8?B?alhsOGp5OWo0R3hBSDVjOFVPVlUxeTFYc0FZYjJOWGJRUk5PV0dWM0p3TXpM?=
 =?utf-8?B?L1pBTFpPWDFGaFA5TndSNXBqYlhxWGNwb1F3Uk5MSUlIdjkyMUFERTJhSkxC?=
 =?utf-8?B?cHlSTVBKd2psSlNjZk9BMklhb1RObzM1SW5MRG9ZRyt0Wno0V1JHdThoRXVo?=
 =?utf-8?B?WFFqeWRPNWU5L2VtQ0M1N0Y3RjFDVUxEM2NRQmZ2d0gwK3F6VVJQOGcrR21t?=
 =?utf-8?B?UkN2NHl0VVZSRUkrZTdLdEg3UFllTzk2ejZZSXJ1aDVIcUJ0YWllZUN4bDRm?=
 =?utf-8?B?aFJaK21EZnhadVpldDFJYi9ERllHeFZpMm03ZFo1RnFKUElib2VJRUtvSG1K?=
 =?utf-8?B?RFlwbi9tSER0MjRtM284Q0tOaE9GK2dMYWpZRmJjai9ad1NpeTVJZ1czNEdz?=
 =?utf-8?B?YXNlQTdPUW5RSmtrUkw0eS9hSG90UFBNbldGeFg2M1FFRG9Hbk5Qek9JWDgy?=
 =?utf-8?B?NzNtTG9Rd3FmVjJqSjlPMFpIZ0t0cnM5aEZQcUNRYk9HN3NUaWFxaU1RTGpS?=
 =?utf-8?B?R1NhUVpBalpjeEpDZU1RV1JpNU1LOUx0eWM1aWl6MVpxTkRBNU0zOGN3R0tw?=
 =?utf-8?B?ZWZTbVUvWU9KZmVRbkRnTGtyT2FDRXpua2hlbmJwSkcwOGdjMGJ2K2dDODJZ?=
 =?utf-8?B?OFVFY0F4b1REdSt3Yms5Uy9DZFlCTmRmRjQ2aWxzOFhyQUZBUFhIN3BmOHdr?=
 =?utf-8?B?TUhaUG52ODVJWGZDb05mbUkzSldFdmp1K3FUMnRyVFJwd25YVk91TGhDVWts?=
 =?utf-8?B?ekw4VnhOcVlpbmFQaWZtQWUxQTZ4R0NTSlZobzlkWnp6bGhpL3RtY3prTXB2?=
 =?utf-8?B?bkgrZUNQSFpYMWtzNjB5UkZKWDFrMXZYWDR4RHMraUdBT0IzWFc4MWxlNG9I?=
 =?utf-8?B?bjh4S0NTVHRnREc2QkNPcWQzN0ZnRE4wZW84cDlQdDRPSWs2N1NURlpOYmZq?=
 =?utf-8?B?UmVOUHYxTkllZHFaN3lzVDBIK2VUcjQ4ZU42Tkd0U3lleTNVWmd5dHRzWkJ6?=
 =?utf-8?B?SVlpTUhpTy9pZmJUeDdtSjhuaDJ1RUFQS1ZUSUcxejMrSWdqNXl0SWRMVDZC?=
 =?utf-8?B?aWMreUdRQ3Qwd2pORmpBU09XR1RMMWpsRFFSTlRnSXRIeUdIemNrNUpXcmg5?=
 =?utf-8?B?VGZqeHAya2dtams2TzU1TDNjUDJWSHV4YldOakgwUzhHdUplM2VhWXJvalJY?=
 =?utf-8?B?TE9VQ1hjY25VY0NPalFHVnMwaGZxVFUxbWRYSWRHTDQ4Q0dSSlhGMmdWVUxN?=
 =?utf-8?B?QldhNXdrSm10cVRGdFZ3a01FUXZnc3loNnE1eks5L1NIZ2N2VFNPUlhvK1Iv?=
 =?utf-8?B?dVRDdzBtYU5udUtuTE96VkxWV21lMXR6aXcwYlJvYmVhSDBxR1Q0Rm9YVDAv?=
 =?utf-8?B?WVlHWFlDNS91QW5XM2NmWGEwMk9UY1ROUU01eFZoNHdsVWhUaGZUT3hOZHJH?=
 =?utf-8?B?eVhWV1BTYVBId2U4NTVGdVhyb2pkZ1dWeUtmNzJCazROWmhoRitRbFJPWENX?=
 =?utf-8?B?c0N0UmtydUdTUjJ4MXRrUnRpZ2t2M3laKzl1bWxYdFR6RkM3c3NDMlVMcWpZ?=
 =?utf-8?B?SUloWWQ4VEJiRmFIRnU1SWwrSS80Q3JmQTRaZnJ3YkcrOGJud0xVbXVDemRk?=
 =?utf-8?B?TExGdEptamtYNzErY0ozb1BrVm5za0dTQnUyWUdycXk4bUlCa3JwRG14SytF?=
 =?utf-8?B?SlFXVCtOQTA3K01qbEx6TW5UY1E1MnczR3BkRjVVUEpIVWZKWHV5QXUwRjJZ?=
 =?utf-8?B?TDJLd09BVUI5QXF5cnQ2czViaEpZRkZVUzVzdXRDbDFPSFdnYTg1dUtSeDlo?=
 =?utf-8?B?Y1phMkRza3VKMS9JZXR6WkVsUHlXaWUrQ0xBai9IZjF4MlpHWnNndlRuL3NX?=
 =?utf-8?B?dUVrcFgyTkwyT3Q0djMrSDlxazlmbWd0RXFZR2RSSklnNHBVVmpqbVYrTmY2?=
 =?utf-8?B?eENWSzYvS1h3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR03MB7810.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmRHQ2Z6VjBsYWxhcHBjaytxeUNqTlJJb3NCTXkxRmJvRFpheEUrNkszNmdQ?=
 =?utf-8?B?ZWpXazh6UGlvS2dPS09iMjFzTmNMVlpFbWtOUjlLMWFFRURBSkNHR0lDaGhD?=
 =?utf-8?B?YXVSeDBudndGWkpwODBnTkNteno3N1g2eDJHVGRsQnlPMlUvRnhaQWJsU3ZZ?=
 =?utf-8?B?b0M2QkxBK1ovMWhEVTBUY2NvbXhtNExSeVA5dDZYblV0cnhjcm1zN1BVL2Vi?=
 =?utf-8?B?NFBZbzlhRUZxYjJWQkdMWi92N3ptZXZjRmxUTEs0UnlBOHlhQXF5SVFuSXN4?=
 =?utf-8?B?a1R6ZXowS3VReEtDVGZhN0lPSkJvSjJXWk9RMEd2ZmlCMi9lTm5zaDgyS2Y4?=
 =?utf-8?B?VENtYkNmQ0FXNVY2SmI3NTZMWittekxONFRHT3dWb0xEOXNvRCtpVktQdERm?=
 =?utf-8?B?V09leXNXSnB6QnJGQisrb3N6dEtEakR5ZFBlVE5zeVZXam1tRW9kMFRaVTQy?=
 =?utf-8?B?Uzk2aXIvMWIyOGZTNjY3UGRjMGFLRzVGemF0eGt6cU55QUY3eUtQR3BUT0VG?=
 =?utf-8?B?NnZ3UENQK055ZTB0WHJBcHViRTN5SWlSSEFIczVqbmpBWWxHS29QWnk4UFVP?=
 =?utf-8?B?TFVNM1hiVk1hekIyamtTNitoUUpHa3MrQUF2WnQxaEkyUnlPcHN4ckowcmZt?=
 =?utf-8?B?eHBaOEJsN0Q5a3hpUG82RHhWNjIwRlloREltMW5EaWZJT1hSTzdIMXkyYWFN?=
 =?utf-8?B?M0g1SDVLNzgra3Q2Z0pIeVVFSkxLUVpsaFBQZWc0V0J4UWhaMlg4cDlkTEwy?=
 =?utf-8?B?MUE1TDRvUFlyMnRJczVUdWgrdXlnWmV5cy9Mdkoxa2kzM1g4WDlleXBHOTNu?=
 =?utf-8?B?NllhaWNNMHhYcHF5M2JsVkpvVFIweWNkL2ljbWpKY3ZLZGI5VkNNTWZ6Y3Vw?=
 =?utf-8?B?b0dlWHJYc25oaUI0TnlIY05MbWgrZ0NjVGpWVDRkTG5hcWpLNk5HOTZ2cHpZ?=
 =?utf-8?B?Sit4WXJ6VXlocnBxZUxQS0t1akN6UlYxWmV3V2pjRUlmZ2t3R2U4UVprQW41?=
 =?utf-8?B?YzBtSlpKTndoVkptajhOWnpBK0cwSWVLYXdTRFcwTXk2UE1SemhqR3VyNlNq?=
 =?utf-8?B?NHRZUkRIMmdjQWJRK0xlRklnZk5mdjZmb2hUSWk1Q0hkNm9WVnNCdFpOeHFt?=
 =?utf-8?B?eU9haVZCM3BOby9SeVNYL1d1Y2ZIN2REZEhFZFFkd2xpOTU0dWQzMVhZQW5h?=
 =?utf-8?B?cFl5NnJxZmFLZjU2b0N1NXcxc0xBaUFoL000MVkzRjV1cjRWamJwckhnbGdO?=
 =?utf-8?B?MWdyRE1Ja0FOMzhUUXdjaU0yeG9GOGVvcUZ1VnRvTkUrNDFwUTJ1dXVuTmgw?=
 =?utf-8?B?K0lxQktLTWdOMUE3b2pyYk5hV0tucUlWMmZscmJsbWxhVTVZSE1rZjhlVTRD?=
 =?utf-8?B?eVBzVVpEYWZrNy9tWGRGd09vUGJBREFGRUtIY283dlA2endPUFhsQi93WGJK?=
 =?utf-8?B?YWUvVWI2WS9pRjBaUHEvcDRhcllmcyt4U0I3dGJPeFdTakpqSWdSQ0JoSWtX?=
 =?utf-8?B?aEFRdDZXTGhDWVZCckxHbWFERjYwbi9idzNJSGlIRTQ2NmZnYzdUTzJaMFJp?=
 =?utf-8?B?bG1JbVVZbEx4RDFTakdhSjF2alVyb0VWL1RsZndQTzEzYlk3UTJHV1R0VVJm?=
 =?utf-8?B?a1pIeFhuUFpObkNQR3JveGpvNzlGbHNOSHRiTDJTcnY3eGxtK3RPY29SVkxL?=
 =?utf-8?B?RlJoYU5vck9oNnJ1UjBlaDRlc25qNjZXd2puYU9DNWkyVnNodHJoSGh2eEhQ?=
 =?utf-8?B?QjRSS0dnSVRTemZ3U2R4cXE1VnhPT3BucEx0M0lXem4weFpNN3dtMDRBVFNB?=
 =?utf-8?B?elgvb2dSMCtyRnRpU0VlUElRc3ZFdFNnRlBkME1HTlI5QXhaRjNObDBwdVdz?=
 =?utf-8?B?ajR0MTNaaWVLYk4rZ09ySnZJZllpTjFMMjhvYXBvWUM1ckExZ2MrWCsrbU5m?=
 =?utf-8?B?OGtvZi9TU0NNSi9jUnhQZU41cWdQcWtuVExyK0pyNk1UbXhrdjNZRmNBVk0x?=
 =?utf-8?B?Skp6c3Q2c0VncDJQV1locVR5MWJIOEZrZFB2TW5tbUtjV3FYWmU2M05wOW5q?=
 =?utf-8?B?VWdRYVNmMlFhT1MvQnRKRHJJMWNXdlZYQ3lQVmFGMTFoaUhoeWZlMXoxM3d6?=
 =?utf-8?B?dUpZSWVjakhaYm96RW9yVTdPSzhNZDNvRDhuOCttRjNicGRDc1Z6T24yMG9E?=
 =?utf-8?B?VWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E18C233300AE442A7364356732710BA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR03MB7810.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf266c71-f1ba-4a6a-0f5e-08ddc46c609f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2025 13:26:31.2830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DTXO6+6gbroaU7KCyyGGb6Pi/caLxdyjYKJnWgHUXS1U6xa5e01Eqv1/Nz/RIbTSdUj+m0OunDQBijHpnQf4W0vHKqAJzseZKZqgJWoDDsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7209

T24gV2VkLCAyMDI1LTA3LTE2IGF0IDEzOjA5ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBX
ZWQsIEp1bCAxNiwgMjAyNSBhdCAxMjozMDoyMFBNICswMjAwLCBLcnp5c3p0b2YgS296bG93c2tp
IHdyb3RlOg0KPiA+IE9uIDE2LzA3LzIwMjUgMTI6MjgsIE1hY3BhdWwgTGluIHdyb3RlOg0KPiA+
ID4gRnJvbTogQW5kcsOpIERyYXN6aWsgPGFuZHJlLmRyYXN6aWtAbGluYXJvLm9yZz4NCj4gPiA+
IA0KPiA+ID4gWyBVcHN0cmVhbSBjb21taXQgZDJjYTMxOTgyMmUwNzE0MjNhYjg4M2JjODQ5MzA1
MzMyMGI4ZTUyYyBdDQo+ID4gPiANCj4gPiA+IEVuYWJsZSB0aGUgTWF4aW0gbWF4MzMzNTkgYXMg
dGhpcyBpcyB1c2VkIGJ5IHRoZSBnczEwMS1vcmlvbGUNCj4gPiA+IChHb29nbGUNCj4gPiA+IFBp
eGVsIDYpIGJvYXJkLg0KPiA+ID4gDQo+ID4gPiBSZXZpZXdlZC1ieTogUGV0ZXIgR3JpZmZpbiA8
cGV0ZXIuZ3JpZmZpbkBsaW5hcm8ub3JnPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5kcsOpIERy
YXN6aWsgPGFuZHJlLmRyYXN6aWtAbGluYXJvLm9yZz4NCj4gPiA+IExpbms6DQo+ID4gPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9yLzIwMjQxMjAzLWdzMTAxLXBoeS1sYW5lcy1vcmllbnRhdGlv
bi1kdHMtdjItMS0xNDEyNzgzYTZiMDFAbGluYXJvLm9yZw0KPiA+ID4gU2lnbmVkLW9mZi1ieTog
S3J6eXN6dG9mIEtvemxvd3NraQ0KPiA+ID4gPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9y
Zz4NCj4gPiA+IEFja2VkLWJ5OiBDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAu
Y29tPg0KPiA+ID4gTGluazoNCj4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyNDEy
MzExMzE3NDIuMTM0MzI5LTEta3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnDQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogTWFjcGF1bCBMaW4gPG1hY3BhdWwubGluQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4g
PiBObywgdGhhdCdzIG5vdCBhIGZpeC4NCj4gDQo+IFllYWgsIGRlZmNvbmZpZyBjaGFuZ2VzIGRv
bid0IHJlYWxseSBtYWtlIHNlbnNlIGZvciBzdGFibGUgdXBkYXRlcyBhcw0KPiBldmVyeW9uZSBh
bHJlYWR5IGhhcyBhIC5jb25maWcgZmlsZSBmb3IgdGhlaXIgc3lzdGVtcyBieSBub3cgZm9yDQo+
IHRob3NlDQo+IGtlcm5lbCB2ZXJzaW9ucywgYW5kIGNoYW5naW5nIHRoZSBkZWZjb25maWcgd2ls
bCBub3QgY2hhbmdlIGFueXRoaW5nDQo+IGZvcg0KPiBhbnlvbmUuDQo+IA0KPiBTb3JyeSwNCj4g
DQo+IGdyZWcgay1oDQoNCkFoLCBJIHdhcyBkb2luZyBiYWNrcG9ydCBmb3Igc29tZSBrZXJuZWwg
b3B0aW9ucyBhbmQgc29tZSBkZXBlbmRlbmNpZXMNCnBhdGNoZXMgYmFzZWQgb24gY29kZSBkaWZm
LiBJIGZvcmdldCB0byBjaGVjayBpZiBlYWNoIGludGVybWVkaWF0ZQ0KcGF0Y2ggaGFkIGEgJ2Zp
eGVzJyB0YWcuIFNvcnJ5IGZvciBib3RoZXJpbmcuDQoNClRoYW5rcw0KTWFjcGF1bCBMaW4NCg0K
