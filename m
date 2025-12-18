Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A436331232
	for <patches@lists.linux.dev>; Thu, 18 Dec 2025 10:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766054665; cv=fail; b=YV5fsR7zJiZcecVtkfgPtpNp0jT70MSOuiuJvVX72snrK77wM0cudKtObtX0tS0XYIThZbkJK6+jZlZrtJ0g8Vopym+cHjqO5qNdushw5x88KGw40JJQ0fdNVnfQeaW21ka4dcBAy0IGMYdOR1FCTeVo3EooySXjQ/BMWR7wbhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766054665; c=relaxed/simple;
	bh=f2AvSPhCuKNJzFJw+tmVFK+gCkbw3ZHeTwiPwCyqOOg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iJ19SMzXy9pwxFw7qC+Wxgi+gtiEbdi+GMYkgHT9XbpwWkbAiL6wS5IR+/os3YyFzNYUyKpPEeu6yGh/hs7DwZnWwJEiaLpJFE4r5rb5QFEwiYKWFjBmFX+FuEmyiy4mFUxaGtcJk2hy+TRS2VtoAhAw36uSVylh6C8ScIfjchk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=awPrhCZS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=hP6mbHSW; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="awPrhCZS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hP6mbHSW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1766054662; x=1797590662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f2AvSPhCuKNJzFJw+tmVFK+gCkbw3ZHeTwiPwCyqOOg=;
  b=awPrhCZSF858wHI7tE+taDyg39pIOjdJ7uJdQwvhCRuo3DEjR7VE9j08
   tUNuLEnJoeA/UYywLBkqzrUGLA5n8CruTFkCuhTGZGPm8q9nB72PjWP9a
   KLr49jHyHTWk4T+7RWKR8fsUUOz7O4Y6dRBRw/moUTYId9zGZHPnFhr7/
   UrcDP0/1mJ5RgjjGCNLYoXrBaRATDFWxxS/GVE/hwK+WOGBoyN0U5Sun9
   klWHc+VDCe5uKhqVy4dY4cRjOURKkYmx79nuXbf5UUzl83cF75QrMqt1S
   HcXBIElazZ4B3FXuqpVp0NMwDcQNP8t7ffnt4uGZTOhlbCa2LfauAHm6B
   Q==;
X-CSE-ConnectionGUID: Onui6cg+RYGWuRIa03rtzQ==
X-CSE-MsgGUID: h/crwDzYRS+/oN7BrhWWWw==
X-IronPort-AV: E=Sophos;i="6.21,158,1763395200"; 
   d="scan'208";a="134100571"
Received: from mail-westcentralusazon11010030.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.30])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Dec 2025 18:44:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JiPbOBahec1Dq4/e2jdTPLp6gpdFYuhRuO6lMRecE/W2hriAZTzCdlQ4IzesHuMyD/4c/B4DvdRt9cmfqBH0G90/Pe+gHTXVKA7qV02l5X9+JJ2WLcs0up2CAVFBpLjOD8A5e2bJ6lDfvC7aNgmGjsbCWThnlzVWG8cK2Wza+nP+XOdrJutlf0qVNu+QtA14o4ggiePH0C68Tgq2HJnegwR2+fUu1udBYCPfcVA/R22aX9fuw9Dsoz8uxhzjmjDnkFEtjkHtuOdGTKcoVco29wCjufhSlBWApRnJUsSZ7ovvoDs/9X5chstvtyWjtfPbB60L1vuyBymsS9AlMCDu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2AvSPhCuKNJzFJw+tmVFK+gCkbw3ZHeTwiPwCyqOOg=;
 b=CCigF8fF9l9sS8YuHtzfBjLSqP8GzQRAHUTDlYkK5QGfg2I4xeXSmpPmUMONxMi9uIj+FU/uR/KtNJJfK6DfXBTBvJ0sKUdGKPeq6YhlM9/CWr9O2ACF/DpKb4B/DF2MtFPpgyER54SRaBbZyMjscMwzodV8obFjN4jzPba9CLuZtOeUCi1uVpPHDH/EFsNBA2ix6Q7I8fdbeb499GVgjrfDjB1luN1YkZQUjv2fhknIdPfOWJVxqqfDwj5QF6yTb8k4rfWi97ITf3A/xx2e84oNy1CXk+OWJ319r2GG5bIFLUXlay7i1gnugDDz/LqFThj6hO63Dil300QrHaXHEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2AvSPhCuKNJzFJw+tmVFK+gCkbw3ZHeTwiPwCyqOOg=;
 b=hP6mbHSWJYg1DqjAhn2ZB8jUjfIQpwK+bl2+kZKopKPlc4joD2e0aOzq0MUsTbEAbUkL5hiapQJDZd619QgoYGY4OLb3r5SJNYplU4bh7vPyQSLglyvrhTY1iQl8y7t5XrLbu6HK5HeAScxXEbAs54cv7PcoTxnogGkW2zuwb44=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CYYPR04MB9029.namprd04.prod.outlook.com (2603:10b6:930:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 10:44:13 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 10:44:13 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>, "sw.prabhu6@gmail.com" <sw.prabhu6@gmail.com>,
	"kernel@pankajraghav.com" <kernel@pankajraghav.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Topic: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Index: AQHcXverMdISXcicTESRwucSMTRsk7UnWJCA
Date: Thu, 18 Dec 2025 10:44:13 +0000
Message-ID: <87dc463f-58af-41f8-9019-7cd89c969f53@wdc.com>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
 <20251126171102.3663957-2-mcgrof@kernel.org>
In-Reply-To: <20251126171102.3663957-2-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CYYPR04MB9029:EE_
x-ms-office365-filtering-correlation-id: 80322805-5ece-4727-80d2-08de3e22626f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SXc4YkFXcTJBU3Z2bG9mUXloQ3g0bkIyZkdsS3pLOW9HNlEvZTBJMFNueno0?=
 =?utf-8?B?NVgzTkoxdVZCSnFiQ1g3ZisxbHZJOWt3ZlVVSk1DbWVtR253alhwM1VTUlkz?=
 =?utf-8?B?OTlDdlQyMEo1b0lhNElBSGRqNG9Nb1A3V1dVdjV1QjZQaFVGd1E3aURJMEpa?=
 =?utf-8?B?Ti9EWWpHcVBhTHVURTY3MGhVeVBZRDBSSzFzVG1iK042ci9GemgvTWxyMk8w?=
 =?utf-8?B?aGpIVEIxeTRSNUxOSUVmQURqZDYraGpabktpV2x3WWZuR3crc3hwYTl6TFR0?=
 =?utf-8?B?c3Z5dEVSSVNiNTdNejJQT3RydjB6a3RHSUNzQTRKMVN1L3g2Y0JLN0puRE0r?=
 =?utf-8?B?R3oxV25hOU1kRjYzUVBDSlJuUS9pVUNDQkV0a05KVnFmMDFrMWdyczc4WGNi?=
 =?utf-8?B?NGNGR1l1TVVmeWRzOTNHV0phNzhEM1dwcVBjZ1hIMmlaRjBncEU5YjFjOURW?=
 =?utf-8?B?TEJvc0tkWEs0dTF4QWE5Q2NONnNBRDNoQ3hRZzlGQ3lhMCtiYllsSGFUUVoy?=
 =?utf-8?B?WUxFZnJZZDRhUmdYcmVibHgwSDJqUmJocXlSai9IZDUzUitqTE5tSTJOSUNl?=
 =?utf-8?B?OHZpbkZWeHJwZzNUeTlVUTAyaGhtQmJ2NW4zT0lHWC85L1lENmVjd0ZaN2kz?=
 =?utf-8?B?eWl3ZzVJTjJGaENWS3JqdVZVR0Z2Y0NoYUdCVnhhSkxJYVBWNEJrOThXRFdi?=
 =?utf-8?B?M0RsWVo3TTdCSDRaUmFicENuQThJU1ZDNUZDZlo5MnNYOU5WVEtkeG5ObXpE?=
 =?utf-8?B?UURkbWRyc2k4SGJ3VmdyN1VtaDZiSFJPNWxMbXhBUDFZc1RIOXNSWmFqSFY1?=
 =?utf-8?B?NVhuUWlCM0h1WE5nMjZUS2diYlpESTZSZTFLa3h4TjRCVjE5eVoxdkNYSjBo?=
 =?utf-8?B?NW82VkdQVmYzV3QwNUphNlNIV3JYakF6SjRaTnVmR1pxZXBvczFYNGp5cEx1?=
 =?utf-8?B?M1JKbTgvdysyWGNYMUlHS3A1WUVkZHVEZ0U2ME56Q01MNTRhcHo0VWxLd1Yr?=
 =?utf-8?B?dy9IZU85SUFVTWFxVmlRRzhIZHhZV2JzNzJtM3hOa1J2bVZ2SXQ5UlZPQTQ2?=
 =?utf-8?B?SDJwODA3S0RkNUJrS3NnR2tJMzRZa21xMmdBVThLOTQzOFh5ak1haW9PSUZC?=
 =?utf-8?B?STFPaTBqVVB1cjhxUWh0L0tGSWc1TndBMzI3RWlNbU84eTJlbFY3MDRDN3ZR?=
 =?utf-8?B?KzhzaUVuN2ZhWlJKV0ltcldhbXFuNGc3cVF6RDgwV2lJTk9FbVZzcGR1UkdX?=
 =?utf-8?B?N2FqM25vSFkvWTV6UnByRTMzb01LbExyWTdlWjQ4U2FOUlhFeWdJVTJyZGRD?=
 =?utf-8?B?a2RWcDRxNU5DeTN1UHo5OWdpWTR3ejVGMmo4MDNHcDRrUjlwY0JEQWFiNkw2?=
 =?utf-8?B?TnJubzFReEIyeEgyNU8wTlNoQ2N2T2lZdTJSdkZJRFRWa0JucFErVVZMa21R?=
 =?utf-8?B?MGhtcFRIcW13c1RiKy80SHZyUmZhVXNxak10S3VBclprKys5N2MvQUZldTRW?=
 =?utf-8?B?Q0xFbi9PQ0xNM09NeDNSYnZIVkE5SWg3Y1g1YURZNjBGT1YwVDhtK3JPSGpp?=
 =?utf-8?B?V1ZzS1dKQ0NzeERxS1RHMVROK0ZxYXVneWQ3Ty9XcUk1UG01S0p5N2FzdXd2?=
 =?utf-8?B?ODFnZ3hIcmJGRlVrMDh4cVV5K3pyOXM5UmZQbS9LTnpMLzBSVzl1YVlXV2pa?=
 =?utf-8?B?cEprRVBYRlQyc1d2VUJ1TFpSTml2aS83ZFFRQkV2c3JsbVNjYkptblEvZ1JX?=
 =?utf-8?B?Wmp2V2FEOWthcXloTmR0MWYzcUtWZVhOcmxHZ1ptYnR5WE9tZkFvZzEzQXdF?=
 =?utf-8?B?UCt0ZHl2UFVZRDZlQVk5aXYzelYwVlhWWGdVZG1adW8zK2ZIUHg3Ymh5V1Vp?=
 =?utf-8?B?ajlENmVCMjBpek9ZWWh5VVcwcVlsNHhacHZPMXhvYmZJbDFoZTV0UnVFcDFs?=
 =?utf-8?B?UTc4YVErY3pyUzNNTE9UektMNHlkL1c1ZXR5Y2NXK2pXamE4R1haU2FYMHE2?=
 =?utf-8?B?RHlJQXlrcjlhVG43VDZOelBxa1grdktsVlZTOXhzZDlVS0EwM25nTDREMVRu?=
 =?utf-8?Q?xOXYAA?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjV3NFRDcCtqeTZTbzVkMUNEK29WYmQvcTdqeUx2SW4vaS94MnhyRjlLQmxh?=
 =?utf-8?B?WnVSOUhCd1dIRVJQYkxPTTBnWUFIamV4K0gvcGlXV240YlVwR0I3VEo3b1Nn?=
 =?utf-8?B?eEZzRDFFcnJQSGZGRWJsSW50VmhUSW1CVXBRV3dxdkI0dGpKNmZZUXJKQXRU?=
 =?utf-8?B?WmpMUDQ1Rkl4Y0I0N0MxaHNkZzlVQ1d6ZmtQVDdJelFBdFladkk0bXkvMU9W?=
 =?utf-8?B?bHlZYVZ2bVY4QXc0WmUvc1Q2dEZ5OWw3c0ttdTUzdUwxSU1KU0x0OS9KenFP?=
 =?utf-8?B?OVhRT2Nnbzk5aUZtbWdaV3QvK052aGkxMmFmQnl6TzBWU1JJU0dCQXNKR0k5?=
 =?utf-8?B?NThWRXVzQ3Q4TmtQSHZHV1FKdlkwaE5DdzRMV0U4RVo4RWhacGM2QzRZeVM0?=
 =?utf-8?B?QTZZM0kwRmRZTjVoUW14aGdCd3pWMVZ5Y2t6b1B5NlZwUWZMcnU0MHdUZTNH?=
 =?utf-8?B?eDIyUXZDVDFCdFVSeDMyOFp0U3R1NWxYa1ZndU1qdUgrQmI2MmdqWnVTdGow?=
 =?utf-8?B?dkdDcW1URTI0MXNNSzY1VjVmOVlaR0ptM29YaHlBVXZMWEg1SThkVXU0VWQ2?=
 =?utf-8?B?N3Z0SzI0YWlRRkFMdHkzNkQ2QmY0TEQ2amlJS0tQRzFtMGt1ZGVpQnIzVUo2?=
 =?utf-8?B?enNHWWd0TTJiNGJZT0U3cGdKaHpwQXA2SFhOOWhLTlFUNXdXTTJlZjliejc0?=
 =?utf-8?B?cU9ZRzIvaTQ0STZuRmZycEx6ak92MWRnUEI2ODF2OEozT0ZFaUFSQ0RXbzNn?=
 =?utf-8?B?UVlvSjhRcWdTTDlraTZIelFadkc1bnhtNTdQcWI0K0hCTXhpWDRoRUx2NUMv?=
 =?utf-8?B?V1hJcWVKMHBFc2JKZFlkNmtRQjJkU0NqN0lHLzVaWERnNnZLVGQ0QWkrL2hp?=
 =?utf-8?B?bllkUUtEcUdzTGxEYjhZU1hDK0xLQ0lWcjl2NUIxbk1ZSk1ZUW9DZ1dYbjVL?=
 =?utf-8?B?YktlN0hoR2ErWVBaYW1VdWdxZWt1MUVBT0JocTVUcnBSWmhKOVBpYXVTZXNS?=
 =?utf-8?B?VzlGTk9MYnVHRzJmYXk5T1ZHZndyVlNHT0xhVkpWODJReXg3ZE1nVHIxMFh1?=
 =?utf-8?B?TW9QaGUyUVBKTlo4eTlvM3Z5OGZtSU16QmVqQlhHdWRkTUZ4djA2M24xWlZw?=
 =?utf-8?B?TEs0TFpPdzIzWHZHS2pGQ1U2ZnVRc1dwRllDaGs4SjR5YUxmVUJFYzIrMCtl?=
 =?utf-8?B?dmVnYUxjS3ZNN1cvTFFUT25Ldy9oWFVCa24yREl6VDZkQW9HNnNhY0FBamtk?=
 =?utf-8?B?bEtrNDlHSUF5Z0VvOUVyTHkycmh2Nm1HTzRzRHRwcUpqU1hZZkFGUm0xMVRj?=
 =?utf-8?B?N0gxeXRXZFAxZEJuQ2Y0R1Ivc1dHcWxDbWVUSGlSenE3NW1GYUZ6SEYxT0po?=
 =?utf-8?B?cDNGeFVYNGF5ZFArRVdUZHRkR2xBNEpMOXRDZklKVmo5aEVldndyL1ZheFda?=
 =?utf-8?B?UUlWSkhmbjNNSHlPVWpKSGhQcFJsM3B6dXM2RmQ1TGFxZUhkUXYvRmh2VEJr?=
 =?utf-8?B?bTRkU0NsZGoyZjhDZTNycHhGR1JvU1ozZ3Y3TXRLUGtLUSsvM0J2ekYwUFVP?=
 =?utf-8?B?UUxBWkdiSDVCU2V0aHdNU1c1TjVpNjlvaHRqdVp4ZnFUNHdZOHBpakdlcGd1?=
 =?utf-8?B?V1BOOHBrS2NMQXZxbEY4VWx3YVhqSkJHSUFmL0JRaHhLL0ZXUEl0N3MzSzNq?=
 =?utf-8?B?bzhiczFqa1FGaFJHb2VCN1Q0c0ZUQ1MxcytaYWdvb3RwZkFJMkU3K2FUN2VU?=
 =?utf-8?B?Y0tXcE43UTBJRFYzeTlZbG5RT1RscXc1ZFZ6M2JqS2wzTDljYXJ5cDdhR0FY?=
 =?utf-8?B?NE5uYStnblFPQkZvM3hqeTVzMmpTeGJFY1RCNzh3YkpOOURKaXhkT3Z5STZG?=
 =?utf-8?B?VUZ1RDQzMWdQc0J4NU5vejNlR2hRbFNhOWRLbmVFaDNJNWNCYTdXY0Y5VzJr?=
 =?utf-8?B?elA2MUYxNytMNlJiRkdmZ3B1dCs4TE5JLzh0QXcwaktZTHlhZWVqbkpTRmo5?=
 =?utf-8?B?M21aMTIxTDl1TVJ4dkdSWmdQQWNxUGZoZDdBOWdxYWVqQ2s5ZWJFQkxsbFJJ?=
 =?utf-8?B?NG5Sbi9paXp5VWVxeXRQUENkM2daL0ZGTGZSU3JPaFZ4SkdPSXo4b2w3WmxS?=
 =?utf-8?B?NThKSG5pY1AwOE9BYmxCY1ZoR295bkJVRmhoMVVmMVJMYk4yK0NWK3p2ZDVl?=
 =?utf-8?Q?AW/p143a/5L1pxMJlaHOTSM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <135905C051BFDA46B86710264CA3B549@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sR5EKoQ2vnVElkmVUm2e6clXP5sfXzRbwD97RhvoaXFz4GCK3N58IofNOwnE1Y9euzgnM35TgUhB9ZtdqhQh6N/PHy/eDXhs2NBvBnZfn5qc+JtoP4OUsFzWGiV1J6l9NT+kgO3c3qCWxzzWv4ev29lG/G30SpI88lHzmVPA5PnMPtkurNDwFdbJdgn54njKNHmsvN+WCV+I9J6n7DPpuaG3b8DI5TnEHUtuDUuKSqYxxuZBA27CfJ8jqxBt0vYoGVkFc3VKA2sfXZf1ax73UfRf/epAd9dY6wOoUicoju1qnK56THvj2HEjd1ZANTrGNX4oY9G/h9PFaPw2PlHg/9HVU+OlpzIhTWyAa7SxP90nMs9bEaLL1+tcL9n0qRolBqQzSuKNUQ+OXWkHMJqDg4rOo1re53pAvxnnhFpUPrC9Felle2lscrOM4ddDPnynDJBsM38mnL+jcVtCdx254PX/QyPxWtAAg23hPNzdBK6vKl8Fb+rXTLY8xt51uMA1E/jzkgC1swTCRHldns0HjFlFpMGzlccKOhso/tZPHZmbQ3/Qel9VC99Hn31uDjZUVGAMf2ax69HI379g/AE0QK90l9C61yAGDJA8kFGr1sqsHKZS/yktcBJgCJjlGQRm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80322805-5ece-4727-80d2-08de3e22626f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 10:44:13.4207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9xmJ7/L8JfKriXvClr/SlJ3BtSSOvdTSRimVxsDOe9W1qlq365hpUsxA51IYLJQF3kHVUe9PJWHuBSUeGZ4fPZvaRjuXfasxYWHUeyiY06g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9029

T24gMTEvMjcvMjUgMjoxMSBBTSwgTHVpcyBDaGFtYmVybGFpbiB3cm90ZToNCj4gQSBsb25nIHRp
bWUgYWdvLCBpbiBhIGdhbGF4eSBmYXIsIGZhciBhd2F5Li4uDQo+IA0KPiBJIHJhbiBpbnRvIHNv
bWUgb2RkIHNjc2lfZGVidWcgZmFsc2UgcG9zaXRpdmVzIHdpdGggZnN0ZXN0cy4gVGhpcw0KPiBw
cm9tcHRlZCBtZSB0byBsb29rIGludG8gdGhlbSBnaXZlbiB0aGVzZSBmYWxzZSBwb3NpdGl2ZXMg
cHJldmVudHMNCj4gbWUgZnJvbSBtb3ZpbmcgZm9yd2FyZCB3aXRoIGVzdGFibGlzaGluZyBhIHRl
c3QgYmFzZWxpbmUgd2l0aCBoaWdoDQo+IG51bWJlciBvZiBjeWNsZXMuIFRoYXQgaXMsIHRoaXMg
c3R1cGlkIGlzc3VlIHdhcyBwcmV2ZW5pbmcgY3JlYXRpbmcNCj4gaGlnaCBjb25maWRlbmNlIGlu
IHRlc3RpbmcuDQo+IA0KPiBJIHJlcG9ydGVkIGl0IFswXSBhbmQgZXhjaGFuZ2VkIHNvbWUgaWRl
YXMgd2l0aCBEb3VnLiBIb3dldmVyLCBpbg0KPiB0aGUgZW5kLCBkZXNwaXRlIGVmZm9ydHMgdG8g
aGVscCB0aGluZ3Mgd2l0aCBzY3NpX2RlYnVnIHRoZXJlIHdlcmUNCj4gc3RpbGwgaXNzdWVzIGxp
bmdlcmluZyB3aGljaCBzZWVtZWQgdG8gZGVmeSBvdXIgZXhwZWN0YXRpb25zIHVwc3RyZWFtLg0K
PiBPbmUgb2YgdGhlIGxhc3QgaGFuZ2luZyBmcnVpdCBpc3N1ZXMgaXMgYW5kIGFsd2F5cyBoYXMg
YmVlbiB0aGF0DQo+IHVzZXJzcGFjZSBleHBlY3RhdGlvbnMgZm9yIHByb3BlciBtb2R1bGUgcmVt
b3ZhbCBoYXMgYmVlbiBicm9rZW4sDQo+IHNvIGluIHRoZSBlbmQgSSBoYXZlIGRlbW9uc3RyYXRl
ZCB0aGlzIGlzIGEgZ2VuZXJpYyBpc3N1ZSBbMV0uDQo+IA0KPiBMb25nIGFnbyBhIFdBSVQgb3B0
aW9uIGZvciBtb2R1bGUgcmVtb3ZhbCB3YXMgYWRkZWQuLi4gdGhhdCB3YXMgdGhlbg0KPiByZW1v
dmVkIGFzIGl0IHdhcyBkZWVtZWQgbm90IG5lZWRlZCBhcyBmb2xrcyBjb3VsZG4ndCBmaWd1cmUg
b3V0IHdoZW4NCj4gdGhlc2UgcmFjZXMgaGFwcGVuZWQuIFRoZSByYWNlcyBhcmUgYWN0dWFsbHkg
cHJldHR5IGVhc3kgdG8gdHJpZ2dlciwgaXQNCj4gd2FzIGp1c3QgbmV2ZXIgcHJvcGVybHkgZG9j
dW1lbnRlZC4gQSBzaW1wZSBibGtkZXZfb3BlbigpIHdpbGwgZWFzaWx5DQo+IGJ1bXAgYSBtb2R1
bGUgcmVmY250LCBhbmQgdGhlc2UgZGF5cyBtYW55IHRoaW5nIHNjYW4gZG8gdGhhdCBzb3J0IG9m
DQo+IHRoaW5nLg0KPiANCj4gVGhlIHByb3BlciBzb2x1dGlvbiBpcyB0byBpbXBsZW1lbnQgdGhl
biBhIHBhdGllbnQgbW9kdWxlIHJlbW92YWwNCj4gb24ga21vZCBhbmQgdGhhdCBoYXMgYmVlbiBt
ZXJnZWQgbm93IGFzIG1vZHByb2JlIC0td2FpdD1NU0VDIG9wdGlvbi4NCj4gV2UgbmVlZCBhIHdv
cmsgYXJvdW5kIHRvIG9wZW4gY29kZSBhIHNpbWlsYXIgc29sdXRpb24gZm9yIHVzZXJzIG9mDQo+
IG9sZCB2ZXJzaW9ucyBvZiBrbW9kLiBBbiBvcGVuIGNvZGVkIHNvbHV0aW9uIGZvciBmc3Rlc3Rz
IGV4aXN0cw0KPiB0aGVyZSBmb3Igb3ZlciBhIHllYXIgbm93LiBUaGlzIG5vdyBwcm92aWRlcyB0
aGUgcmVzcGVjdGl2ZSBibGt0ZXN0cw0KPiBpbXBsZW1lbnRhdGlvbi4NCj4gDQo+IFswXSBodHRw
czovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxMjMzNw0KPiBbMV0gaHR0
cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTQwMTUNCg0KTHVpcywg
dGhhbmtzIGZvciB0aGUgdjQgc2VyaWVzIGFuZCBzb3JyeSBmb3IgdGhpcyBzbG93IHJlc3BvbnNl
LiBQbGVhc2UgDQpmaW5kIG15IGNvbW1lbnRzIGluIGxpbmUuDQoNCj4gDQo+IFJldmlld2VkLWJ5
OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBM
dWlzIENoYW1iZXJsYWluIDxtY2dyb2ZAa2VybmVsLm9yZz4NCj4gUmViYXNlZC1ieTogQ2xhdWRl
IEFJDQoNClRoaXMgIlJlYmFzZWQtYnkiIHRhZyBpcyBpbnRlcmVzdGluZy4gQnV0IGl0IGRvZXMg
bm90IGxvb2sgd2lkZWx5IHVzZWQgDQphbmQgbWF5IG5vdCBiZSBzbyB2YWx1YWJsZSB0byBsZWF2
ZSBpbiB0aGUgY29tbWl0IGxvZy4NCg0KPiAtLS0NCj4gICBjb21tb24vbXVsdGlwYXRoLW92ZXIt
cmRtYSB8ICAxMSArLS0tDQo+ICAgY29tbW9uL251bGxfYmxrICAgICAgICAgICAgfCAgIDYgKy0N
Cj4gICBjb21tb24vbnZtZSAgICAgICAgICAgICAgICB8ICAgOSArLS0NCj4gICBjb21tb24vcmMg
ICAgICAgICAgICAgICAgICB8IDEyNiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ICAgY29tbW9uL3Njc2lfZGVidWcgICAgICAgICAgfCAgMTQgKystLS0NCj4gICB0ZXN0
cy9zcnAvcmMgICAgICAgICAgICAgICB8ICAgNCArLQ0KPiAgIDYgZmlsZXMgY2hhbmdlZCwgMTQ1
IGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2NvbW1v
bi9tdWx0aXBhdGgtb3Zlci1yZG1hIGIvY29tbW9uL211bHRpcGF0aC1vdmVyLXJkbWENCj4gaW5k
ZXggMTA4NGY4MC4uZDA4MjcwMCAxMDA2NDQNCj4gLS0tIGEvY29tbW9uL211bHRpcGF0aC1vdmVy
LXJkbWENCj4gKysrIGIvY29tbW9uL211bHRpcGF0aC1vdmVyLXJkbWENCj4gQEAgLTQsNiArNCw3
IEBADQo+ICAgIw0KPiAgICMgRnVuY3Rpb25zIGFuZCBnbG9iYWwgdmFyaWFibGVzIHVzZWQgYnkg
dGhlIHNycCB0ZXN0cy4NCj4gICANCj4gKy4gY29tbW9uL3JjDQoNClRoaXMgY29tbWl0IGNyZWF0
ZWQgYSBudW1iZXIgb2YgZGVwZW5kZW5jaWVzIGJldHdlZW4gY29tbW9uL3JjIGFuZCBvdGhlciAN
CmNvbW1vbi9YLiBUaGUgZGVwZW5kZW5jeSBhZGRlZCB0byBjb21tb24vbnZtZSB0cmlnZ2VyZWQg
YSBzaGVsbGNoZWNrIA0Kd2FybmluZyBTQzIxNzguIFRoaXMgd2FybmluZyBpdHNlbGYgaXMgbm90
IGR1ZSB0byB0aGlzIGNvbW1pdCwgDQooYWN0dWFsbHksIGl0IGlzIHNoZWxsY2hlY2sgYnVnKSwg
YnV0IG5vdyBJIHRoaW5rIHRoaXMgc2hvd3MgbGVzcyANCmRlcGVuZGVuY3kgaXMgdGhlIGJldHRl
ci4NCg0KSSBzdWdnZXN0IHRvIGFkZCB0aGUgbmV3IGhlbHBlciBmdW5jdGlvbnMgdG8gbm90IGNv
bW1vbi9yYyBidXQgdGhlIA0KImNoZWNrIiBzY3JpcHQuIFRoaXMgYXZvaWRzIHRoZSBuZXcgZGVw
ZW5kZW5jaWVzLiBJdCBhbHNvIHByb3ZpZGUgdGhlIA0KY2hhbmNlIHRvIHJlZmFjdG9yIF91bmxv
YWRfbW9kdWxlKCkgaW4gdGhlICJjaGVjayIgc2NyaXB0Lg0KDQo+ICAgLiBjb21tb24vc2hlbGxj
aGVjaw0KPiAgIC4gY29tbW9uL251bGxfYmxrDQoNClsuLi5dDQoNCj4gZGlmZiAtLWdpdCBhL2Nv
bW1vbi9yYyBiL2NvbW1vbi9yYw0KPiBpbmRleCBlYTkyOTcwLi41NTY1ODFmIDEwMDY0NA0KPiAt
LS0gYS9jb21tb24vcmMNCj4gKysrIGIvY29tbW9uL3JjDQo+IEBAIC03MzYsMyArNzM2LDEyOSBA
QCBfbWluKCkgew0KPiAgIAlkb25lDQo+ICAgCWVjaG8gIiRyZXQiDQo+ICAgfQ0KPiArDQo+ICtf
aGFzX21vZHByb2JlX3BhdGllbnQoKQ0KPiArew0KPiArCW1vZHByb2JlIC0taGVscCA+JiAvZGV2
L251bGwgfHwgcmV0dXJuIDENCj4gKwltb2Rwcm9iZSAtLWhlbHAgfCBncmVwIC1xICJcLVwtd2Fp
dCIgfHwgcmV0dXJuIDENCg0KRHVyaW5nIHRlc3QgcnVucywgdGhlIGxpbmUgYWJvdmUgcHJpbnRz
IG91dCB0aGUgZXJyb3IgbWVzc2FnZSwNCg0KICAgICJncmVwOiB3YXJuaW5nOiBzdHJheSBcIGJl
Zm9yZSAtIg0KDQpyZXBlYXRlZGx5LiBUaGUgc3VnZ2VzdGVkIGNoYW5nZSBieSBCYXJ0IGluIGhp
cyByZXNwb25zZSB3aWxsIGF2b2lkIHRoZSANCm1lc3NhZ2UuDQoNCj4gKwlyZXR1cm4gMA0KPiAr
fQ0KDQpJbmNsdWRpbmcgdGhpcyBwYXJ0LCBJIHRyaWVkIHRvIG1vdmUgdGhpcyBjb21tb24vcmMg
Y2hhbmdlcyBpbnRvIHRoZSANCiJjaGVjayIgc2NyaXB0LCBhbmQgZGlkIGEgZmV3IHRyaWFsIHJ1
bnMuIEl0IGxvb2tzIHdvcmtpbmcgZ29vZC4NCg0KSSdtIG5vdyByZXZpc2luZyB0aGlzIHNlcmll
cyBieSBteXNlbGYgdG8gcmVwb3N0IGFzIHY1IHRvIHJlZmxlY3QgbWF5IA0KY29tbWVudHMgYXMg
d2VsbCBhcyB0aGUgY29tbWVudHMgYnkgQmFydC4gSW4gY2FzZSB5b3Ugd2FudCB0byByZXNwaW4g
DQp0aGlzIGJ5IHlvdXJzZWxmLCBwbGVhc2UgbGV0IG1lIGtub3cuIFRoYW5rcyENCg0K
