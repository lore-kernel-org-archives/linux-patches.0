Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.125.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794377413;
	b=K4iqAVk3zArS/XKnR1vmgHk34ZXHocCfij91tGscp5xe9BUsesQu9DwXM3OF5mx6YpNI
	 mBLgcTWKTCQWzOBUgzc9Q2pFtJyVI/EN4j990hw4mm0hTPr1OBr1eQmwShbRNzrutglqB
	 dg332b4huDd6r1nW1Bu0TzcAYg5krZxemb9Zd2RGXsVerFLNUh1IKJg76+Sah1Rb8eBrO
	 dHG9f/oQz/ZlqAD3ogf39bvns7hEH3uoUhoK5UcaxAUQhTFh8N8FJgOfa7Kke1GVlzL4k
	 IfQmGu59J+RaxxS2kmSMOaov3C4VOrZ+b5ES5gsEcyLW1PHSdpbWMG7oF5yVkc3w28A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794377413;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=P55nXapHe+gQA2MoFYiOLdT7HM6qGHQUl+VLA7EuxDM=;
	b=y7FYUHmEyrVC5F+bOyN2NsNexGwG6rq3oHBJtcgWr8upZ9niNW3rZc3bNpFtbAlSs2kE
	 tZxv/QJvIhUtSIrBvO3eaifIWC6mwAQKgp++cx6Mnd1hPe2X0HKPvKNscE3m84pIrCr07
	 APBMHqdGeBcRIKdgYFKzKYKHBrgC4O+nVly3pzUPqRmnQ99F8AuwjkpJjcbo/mWs0fgUg
	 W+nSUIqISfGFb9Kux3T/TcbVBqOCFvTt5wHBoHhGyBFJjHp0+oHquu0TAXxXJxfxtol1e
	 sIOdpVSUx7SHnx3Xo8jlMYWUgxwm7s6NfbZqVKw69EuTHZFSIsUCai36f793833IIPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=Mj3fHU5q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.125.56
Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11011056.outbound.protection.outlook.com [52.101.125.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB442606A327
	for <patches@lists.linux.dev>; Wed, 11 Nov 2026 06:10:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB442606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=Mj3fHU5q
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ir6GS1sIVIArL/rUlRDcqHgVCqdGx6OXenHOYK8Vprc2nmzwbQNAXeOBlCK6sjO0cfC0sMPIUnTlKPQ03xh8H4rww0qlV3rRYtIJBBp6/9XceHSaoLSpBYy+qfuLG3XTyot1WL2o1cuHp9NGy0vs+rv5Bdz+Lz8cu8HhNC6sEHfwXn3/vZSSLGVr95dy4J29IefQt0q/dr5muwvWrPFjkjvZO0oJNRDOxoBjZ2oE6RDx+6qUcc9J9YwxK9WCd8Hpi+utVUk0a+7WEExuxJmfLZ0Q393ClbqY2Yt37cklyg/ohF/LoeoaKf4E1sEnVtpK+g+oXI4ht4q9Gdu8ghccJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P55nXapHe+gQA2MoFYiOLdT7HM6qGHQUl+VLA7EuxDM=;
 b=pgUdLXx6jVdQ7ieuD8LIxZ3039NwXoVf3NJStS/mmJm5OGtaELu0hgWUvvpDGSH4uKQ+JwT/o2k9lIagFeKn8/SmBpXtAhs8KokqjJClpN+LnFutoF5yQjoxgKLswgmO2O4GC9j5rv4pMjrGShvOzSzqm/PXTBGL11UBxDCaw7hszqf/wkdpjJVytxKrLYRF3kxWrhd9xtSZ7JqNdJxkoX6ULvc/EzhCHPTOKIQ3Mz40kr40ooMWnIu/KzMHn+IqetQvEZ44qpA/P8ejWccF8JSj0B3ewvahgBKq5pMk0fUP7ymZUuhwscEpp7/6Q5gOzuaVakeVb5CVjaYWnt5cXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P55nXapHe+gQA2MoFYiOLdT7HM6qGHQUl+VLA7EuxDM=;
 b=Mj3fHU5q91uY07A7KA8G3lKZK9Hu9Qt6UUOd3thHQiqyuecrcH7Fh7GUJpCeR7Ufqg/bw2bY1Ap2SBiLEw8PGSgJ/1mbZ0JJ8JPagheQXZUMu3U1oTYcdO26KtnL1WxfDnuV05tz2i6vUWaElT1Y4RKWkZa01z18yNAjxG7emZIiTiuUaStABJgRp0bHcsumNoUwwkq0Xy3Axkhv+xsFCuVODKRDdSuuCAoKd/7Ve5H7FV1a2CeoXD5buBN7nCiJoCCzG3/t57McHEtMUDVZ1QgdHMzGeTG34V27JloNk26BLNFLQYsKCgydaCVekMY3wqiKdLk1Q7CyjJvscWJ5KA==
Received: from TY4PR01MB16930.jpnprd01.prod.outlook.com
 (2603:1096:405:338::19) by OS7PR01MB14714.jpnprd01.prod.outlook.com
 (2603:1096:604:39c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 06:10:08 +0000
Received: from TY4PR01MB16930.jpnprd01.prod.outlook.com
 ([fe80::38bc:7870:6f23:a957]) by TY4PR01MB16930.jpnprd01.prod.outlook.com
 ([fe80::38bc:7870:6f23:a957%4]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 06:10:08 +0000
From: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
To: Reinette Chatre <reinette.chatre@intel.com>, "ben.horgan@arm.com"
	<ben.horgan@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "fenghuay@nvidia.com"
	<fenghuay@nvidia.com>, "ruanjinjie@huawei.com" <ruanjinjie@huawei.com>
CC: "tony.luck@intel.com" <tony.luck@intel.com>, "yu.c.chen@intel.com"
	<yu.c.chen@intel.com>, "babu.moger@amd.com" <babu.moger@amd.com>,
	"fustini@kernel.org" <fustini@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH v3 0/8] arm_mpam: resctrl: Separate MPAM domains
Thread-Topic: [PATCH v3 0/8] arm_mpam: resctrl: Separate MPAM domains
Thread-Index: AQHdcMqqlF4QvSS8sU+8MtyTaXYJfbcoZH/l
Date: Wed, 11 Nov 2026 06:10:08 +0000
Message-ID:
 <TY4PR01MB16930662726889E62E09F19D88B712@TY4PR01MB16930.jpnprd01.prod.outlook.com>
References: <cover.1794283825.git.reinette.chatre@intel.com>
In-Reply-To: <cover.1794283825.git.reinette.chatre@intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-11-11T06:09:59.848Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY4PR01MB16930:EE_|OS7PR01MB14714:EE_
x-ms-office365-filtering-correlation-id: cff13f13-575f-4ea3-903c-08df3fba7017
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|22082099003|18002099003|10067099003|1580799027|11063799006|261028144727099003|261009223027099003|261026140227099003|261102123227099003|56012099006|261022105027099003|261021121427099003|261026121527099003|38070700021;
x-microsoft-antispam-message-info:
 yZzzwLskzLP0EI8La5JUNZLgPiSyqDwKr8qxHyop52aIpRMgUfh6LSvC1yocxOw/dl9sQosQ8ESgDsiCiNyl6m4lpHBlgFCes9u8ew5tIesF0nLTTlvwScdf8upQWTTXntt2cQR1NWygiFVsue7RY/KWuu30DEiSMY+3Lwt5+JDmbMKU8k3sl84JXpr74X0KvJLFFqfztk1ilP0SSJpGbYzyVNM5flCbQ7I2ZXNzUwk0D8hjxbsW5KFQfaTCRi/G+H9oY+NJNULsigJi576JeTtu/7ygGrZGpzsoBrTS3meG/bLzfBVwnAndsmtSfCipxkXX+fC5go6LXe3AXscnIEqx6oAW8GHdVErfuTgIahc/drkV4dZHzpJS3AIV7aRc8/lw3TGx5rzx+OAU92wi2GoFopn0iMXWZtaRexjxsHrp2hLDjSzIM48mjMeoDLdmkp1ksqwPl4nUrsOhnuvMxtXN4R+WO+PVH51M8Usx/0uX2TwH+Oe3SAjr3mlY/81Ol6H1le5VD38lbzacqNHDSnMvpzsC+qHRa62g8zTGZaNSfeQACONETFevhJ1W11cPJq94kxfXDdVqlNH7NxHyuMPObzL5trLjQMRwxbvb+a4ug4zdRIqrKpM4o933ndXl88VCJUxOI5ii6Nd1EDTh8Bx5epVI3EF+VVkzowmCFOO/m1yMGOzuI2mRlugo1f9aa6WUOLZwF3/2WCq2UW6aflEJeA3WT5XPH/vjX0vVysJk3AhepxUiJgu7EeeWMO1G
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY4PR01MB16930.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(22082099003)(18002099003)(10067099003)(1580799027)(11063799006)(261028144727099003)(261009223027099003)(261026140227099003)(261102123227099003)(56012099006)(261022105027099003)(261021121427099003)(261026121527099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?TStVUDA2NzlvUXRNLzlzWWVSdiszWkRpMjR6WlFpczE0SlFuSVZWVzJp?=
 =?iso-2022-jp?B?Y3gxOGpHUGZsUUJuM1hoMStvVTloOEI3dTE1VUFYWVhzRjJtc25Qd0tJ?=
 =?iso-2022-jp?B?dEkrTElMUG1LQUY5bjBNa3RRR2FBRXZIWjRsY0pTYjU0TkZzSitCUEZB?=
 =?iso-2022-jp?B?ZTE4RURZS0N3Z1FYVHpnakpTRW43NGIwM3ZWMTIxa04vN1IzaDduUXc3?=
 =?iso-2022-jp?B?Q2VsVXA0cS8rWklDK3VJQnR4TEtOMU5iN3lvZFRyUWh2M3VjejhCL0dO?=
 =?iso-2022-jp?B?T3JyT2pkME5xL05GckE1eUZZNktoSGdBVDNzWUFVVk0wSlA1K3pRYnk1?=
 =?iso-2022-jp?B?aWpBM3pkSGNlVE9rQlp4STJNQ3paZXhWQUlDZVc1SEFJaDB1Q0Yyak4v?=
 =?iso-2022-jp?B?LzY0cG1scHNxOXpwN3JqcWtxaGtyOXliRUtOT3ZId2l4SGo1R1RuN1Zm?=
 =?iso-2022-jp?B?OGpCTU13K0k1aW85QzJtamVCa1FaOUR0NGw2SGdZSG1XeW9MS0Y1SkZs?=
 =?iso-2022-jp?B?R0hKc3VkVVJKalpJVXNIUEJYSm82aTFTVDVaSy90TnZicndCYTB0eFFq?=
 =?iso-2022-jp?B?dC9zRGRnSUZlR003R1BBUmlUSmtaZ0IvL3Nydk9IQ25zbjBYVFppQVNm?=
 =?iso-2022-jp?B?ZWxXNGVYbi96c3BCWWoxdWFvdmdteTA3bE5GcXQzemF4TWp6R0RYZlc3?=
 =?iso-2022-jp?B?NHJHMG5PK3h6SnBBTzJ0RGZWWkFudVR3OU95N0xyd3Ywdk5KRWRlanVk?=
 =?iso-2022-jp?B?UmhaMEFLTVlxMnFsM3psWTQwU0tVb1pDME5JVVZjN0s1bjB5OW9KaW9u?=
 =?iso-2022-jp?B?MGlKSEJ2bDFMTk9IbDFZeWJsWDJSZFVLZ3FpMHRuQldjN1BpMkVId2k5?=
 =?iso-2022-jp?B?S0lURzN6VEtEV1lJdUlpM0oxQkpNM3JyYjdiMmxvdk1NdUh4RjhTQWVq?=
 =?iso-2022-jp?B?VFZ5SzhtTTZkeVcrY1NTc2N6bzUyNmhFcm9TdEJtcnNoOXhsdnliOVRj?=
 =?iso-2022-jp?B?RTBHTG9XTStGd0R1R2RReDNFb1NHS1ZBa053bXNvT2ovcnhaYkN4bjB3?=
 =?iso-2022-jp?B?dW9vajFxbDh3b1dsREI3eEVXaUxxWXY1QldFMFlVWTBXVlM0WnMxdjdT?=
 =?iso-2022-jp?B?RDRVdWE5KzQxUHd0ZUlPb256TGJ3dU5LZHRLd2Y0SWJ5bTN2OStKang2?=
 =?iso-2022-jp?B?bzg2WnN0MU9uV3U1NVRZMUpaQ3AwSHU5KytRbEFhazFWRXk3dUVqY0RD?=
 =?iso-2022-jp?B?V2FkWGtwWCtNYTQ3MmxWdGY0MGV3VE0yWEVJcm9XN0lVU25CYWFpY2xJ?=
 =?iso-2022-jp?B?TUlCT2wrN2lONW5XOFFCaTJOenBhYklLMHowUitLQ0xEaEx4SnZTcGcx?=
 =?iso-2022-jp?B?eXRLMDhvWXE2NGFsSGhkazlpUjJCczMwSFpuMkxIYUdJdjhNOVhvM1Qw?=
 =?iso-2022-jp?B?am14RmFGcFlFT0ppK0pzNS9NcDI1YmcxNjNxNWJ5NkhQTFhDanl6MktU?=
 =?iso-2022-jp?B?UGVMYWNOYVFmYUU5REZLTUdudHJlSlh3QUJlTUd5NXhEMnNpakhQeklV?=
 =?iso-2022-jp?B?dXdtbkt3OVZmVUMyV2VtTU9QeVNZc3dFR3pYc0h1QU1sOXVZajFabTNV?=
 =?iso-2022-jp?B?Z3FSYzZNYWovdGdLZWdlNloraGxoR2lYUkdZZzZ3RHFDeGhKL3d5b1h2?=
 =?iso-2022-jp?B?OVVJd0lnN0JqS3VMekFkVTlOWTY5bmxKcDlSZ1hKRUxMYlRDR1I1V1lR?=
 =?iso-2022-jp?B?VGZiQk1JTXpzZUZUVmJUaUthNkVJak9nMGpodmUwamZyWG1TQ3RsQVR3?=
 =?iso-2022-jp?B?UDFpcXd5ZnFBUGlyQzk5Z0NXM3VUZ1owT1A1Q2kzejNvZzYyZ3lWVkUx?=
 =?iso-2022-jp?B?NjdaNkJMRHd4d041SWNJcFVNdkJFRWExS2Q3ZURXMFZ6SDlDY3FnU1ZR?=
 =?iso-2022-jp?B?YWFOdVZSZXZ6RFRJTU95QlRicFd0NTl1dXNQbHNhZlpDZ0szZWtjTHI3?=
 =?iso-2022-jp?B?SjAxTlZxOTRaQU04bnMwZUsrNTI4bVpPWk5zaURBQ0l1NkU2OUxiclYw?=
 =?iso-2022-jp?B?UTZxeWZmR25DTEI0Z2FhWWhYZGd5ZkE2czBBSk5mY1kxa0UrK1lOTDVo?=
 =?iso-2022-jp?B?OFFOeDlDc1VLYlhwZ0N0NDNRdVJiNGQ5TXdzY1FLMFo2VCt1K2FxN1I5?=
 =?iso-2022-jp?B?L2EvSVA0R25DOEYydExxNTZMS0Q4Q2lYUWlIY3cyMFJBNFNtWm1IWEtu?=
 =?iso-2022-jp?B?MDhkNlFRZkQySTdVMzJsaXAyaVhZNk1idS9FTlMwd2tmbDR2aWIzVWVL?=
 =?iso-2022-jp?B?VlZoQUhkOU5FR2MxdmZRWFFRZmhQY1RUUFdxR01zSTVtRnB6Tm1WTW1H?=
 =?iso-2022-jp?B?SEhRRjU2VjByRTlhY3Q5YjBHUWUzd3AxS1dPNkduWVlWeFZGOUNKR05m?=
 =?iso-2022-jp?B?cFhadW9lc3JlM1B0K0RPdUx1d3RKcE05dVpXUngreUF4Y28vby9kTXA3?=
 =?iso-2022-jp?B?ZU9ZZDlJN3UwbkJaVm5UclJXNGE1ZEFINVlhQT09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	BHv4XUlJzSN1M9mR/jtRG8foNM6hkqBmverCB7DVinoA9v2HQiE3cHMF5gpl/FtrBT5BF+miKH5xMQeTQWhXy4QotmPEksWTl/dQ1yF7zDkVu7ONZzjdk+PIrJtTdy5wTcz2WMZxDOinhr5fCTXEZDiaHklkm7bU1mf6uuG2DNRLNSNRAzUhWF/BWDrf6NqkngV4nfpsJ2ST8FucYpX6vUlR++PsVkIwFWcSW73Vq9ecL8RuVUJmETLrqb/TiqOQ6+1zFjlJJyTKYnCxD7BoKvcd8F4nzPLdbDVK40435ausHE83htyDJfNgC/9tMj/180a9W1zpLEfvx4cufzDWXw==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY4PR01MB16930.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff13f13-575f-4ea3-903c-08df3fba7017
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2026 06:10:08.6376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 27tsIwzu7N9hBkHj8Js0GRlIwLC7ZFQ6H9PiSZ9U9Sz63uP7v41KJKKmENwMq31VFadLQDCVdbJ4jKgmfBUtjfG5ApHow6ISfFixzxo051w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB14714

Hi Reinette,=0A=
=0A=
Thank you for the explanation regarding mpam_resctrl_domain_insert(). I und=
erstand.=0A=
=0A=
I have reviewed this patch series, and it looks good to me.=0A=
I also tested it on both Grace and the Fujitsu monaka simulator, =0A=
and everything is working as expected (no issues found).=0A=
=0A=
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>=0A=
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>=0A=
=0A=
Best regards,=0A=
Shaopeng TAN=
