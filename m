Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705605336D;
	Wed, 18 Dec 2024 04:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734495574; cv=fail; b=E5rAcAajSfbUBm8Ttys/BqwrevR88SkVM6xwtQ4t1oNDdqeWJxHI95+lMKB7VCrw/WWteDLNAd8+6jyW03GfrGUkj0s8+AR6Iqf8BCHp7pr5dQl9hCcuhjUL3znJiYiFO0sWrq+htgA0CHIvoy1ZGMln04DXi73bOQZRL6V17Z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734495574; c=relaxed/simple;
	bh=OxNo0iCUEcE8LauvJDdFPTELiFoWI1f0kvPlNaEEgts=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qwMA/vfQRKtkgalo99xew0W8iHqh3Xu06vueha90soDesk3qjQf+S0+puOUF0UeCB3796k+LJAhT3W7FIe+jTcEz/PqyJFlJ0tVOPfP9oT8wTXuPKDe2ZW1uNcp5IBwHx14B1QpdfahmJmp7wi3rcZpCdOzTpOhbRGkMV/THwLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=kyyoVQtO; arc=fail smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="kyyoVQtO"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHGl4Pw002003;
	Wed, 18 Dec 2024 04:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LT8yLyVZ40/wQ9xuHsvjhB8P2URVoOHe5RqbBajEcfw=; b=kyyoVQtO8WX5cB5B
	VhtmY4fGrYcaaGrpmbs91dNdhs6MNoT5GocCl5YAfYX3g4NkYjYnp5t3i73oMaql
	fnlOqp2Q98jplI8KmQXyEp4bzklOHa6+iBJI87X6ErCDiGEaWUcIktQ5snto5Zv0
	3WiYSnzDop7gs1UNjoClsuWQ7Ub0y+yUaiVsVSBKcidiOqUOGmCDAKJhiiCfwNDK
	JKp5g9Gh1A3AhjVXte0FvNRDwhbg3miAJTyXOgeAtufQXOYteUvxD+5XdpzIaHX9
	z+8juvytKwH1mWR9y8eLcKULP4NpNF6YLqEJpm3yutIVb5V+X5mZlpbFVeCavULi
	J6gYIg==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010007.outbound.protection.outlook.com [40.93.13.7])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43kd4ascyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 04:19:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPERhC+h6FDcBi6TVZUuAAmZGtKDQmOT1bpoFIQLxrwQcMFiF1jX79TtTvPQgwHcSHOnKg992VoOY4v7707SwgOmwsS84QXK+j4W+HQU9MrIIBcpzvJS0ds21Y0pFCLdUPxBQxKFsK2jIYechVMfMzatXTafts6xbegihn3L8Qt6tq7kL9e1MjZX/e9RgXHcOrXvPOCHCWjjyr1mzpJoeGW3zeJ0WnksOEylxu7RNeTyOe33CnWIlpRhTzqRosNwrBELKyt2KFEoH23Bdl23uiECgJTFnf9Szz47+YiTzvD6FGn5klnnICR25xKNd4Vd4Aklvd95k073PVwlv2KWiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LT8yLyVZ40/wQ9xuHsvjhB8P2URVoOHe5RqbBajEcfw=;
 b=eLr46wpb6FgAwCa476Lq7YVE2w0jc6vZP7kZlXVyeCHPmOO44yAsChI1aVkuaPK1c+DPKm+fCokGm7EBpHNIqHgUv8BDpOUW9fiEOaoHrL2oNregQ3dKvWUpjfSiY5TSwWPS4WWUFR3bkBZvKxnR587ier2WeX1LEdvwGalGVI5tzyi/aXa8rD9dwjlHg4B9m50aeke+Nzi1z3QmzQXM4yOXw/8FU4CHqDlid2ynIg9EDOrcqveL0Blqit1Ffj4qSPr6yUcWkllJGgDh2djNoDl8HjVXQTRZ7tVUaGL7kqBtbXpzl+VACKL/cYmsPpxIPmYJNb+tRxmn8zLK5xa/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from CH3SPRMB0001.namprd02.prod.outlook.com (2603:10b6:610:153::20)
 by PH0PR02MB7830.namprd02.prod.outlook.com (2603:10b6:510:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 04:19:24 +0000
Received: from CH3SPRMB0001.namprd02.prod.outlook.com
 ([fe80::1e96:7417:cf8f:8102]) by CH3SPRMB0001.namprd02.prod.outlook.com
 ([fe80::1e96:7417:cf8f:8102%3]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 04:19:24 +0000
From: Brian Cain <bcain@quicinc.com>
To: Brian Cain <bcain@quicinc.com>, Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>
CC: "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] hexagon: Disable constant extender optimization for
 LLVM prior to 19.1.0
Thread-Topic: [PATCH v2] hexagon: Disable constant extender optimization for
 LLVM prior to 19.1.0
Thread-Index: AQHbPEJbPIGnXNO6vkOUZZyiHFPe1LLq3huAgACMmFCAACSnYA==
Date: Wed, 18 Dec 2024 04:19:23 +0000
Message-ID:
 <CH3SPRMB000129CE377EDA52BF102593B8052@CH3SPRMB0001.namprd02.prod.outlook.com>
References:
 <20241121-hexagon-disable-constant-expander-pass-v2-1-1a92e9afb0f4@kernel.org>
 <20241217174425.GA2651946@ax162>
 <DS0PR02MB102502302B8074AFA8BB1BAFEB8052@DS0PR02MB10250.namprd02.prod.outlook.com>
In-Reply-To:
 <DS0PR02MB102502302B8074AFA8BB1BAFEB8052@DS0PR02MB10250.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3SPRMB0001:EE_|PH0PR02MB7830:EE_
x-ms-office365-filtering-correlation-id: 2595a4b9-3f6b-4f6d-4975-08dd1f1b274e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?3CRre00P3Fh5qLaMI93C17VVGO07g1mRZMZrT/TG3YfjioooTbPfeQc8SBni?=
 =?us-ascii?Q?hlPAjB2HlvH3yc7Wbu5Dd9pmykMyHHkUxstS3SEIkFYXDAkE8kY9YfLMxutL?=
 =?us-ascii?Q?b4CEpTlHPEkHoNbrN5XbWSaaJtfJXObgYDzn0u1BHTqaOOjYNQ6yaTtntvA2?=
 =?us-ascii?Q?Qcj18E0I+ZyNYvWArLXQ2wOZuOKICwau/MtEWdEYkqRCr2f2oQ7a5aVssmGz?=
 =?us-ascii?Q?W24y1ClvHhCPnyVKnTDY4LL+JZm2oxFJZ03+PSaNHjSB8zv6LgaODFSN4nFY?=
 =?us-ascii?Q?UV7sQ9J1BT4tblneS8K5LT0g3Pz9GGEXq0jIwZ7fciNQ9GMutFJ16GjgFTEr?=
 =?us-ascii?Q?PMOyobuLSLR/lyqZNzKEq5hev+/2MksYHEQpYH8+3gndD2maNLCKLOzxoEMn?=
 =?us-ascii?Q?hoqRhA/VY2g2F1+qwHHr9ZxZL54yqqlOHLZ4OY+zu6rPhn+Zx3Is5G0kMmKb?=
 =?us-ascii?Q?tUEF8SV7xtbOoQD6FdiITLdN123QcL4D5WlRmCKbHIy6d7Age1i2kvKDc5ty?=
 =?us-ascii?Q?j7Ugn/qf44yijEk2lWT1FYs/MFL6o3LeGnkelCcIjSrxgRQq7GQEnECqs6jO?=
 =?us-ascii?Q?ibgrVPY8wA+FVlrVB60o/jiqTQf3Wbl1cEcQzzrnp3ho53vwzBO7HBVcz9sW?=
 =?us-ascii?Q?ycwNj5yQzw8gMpjyvyCIhjqQ5GxLn39noEvRi8o4NBoFD/zADQG3M3w1t5HH?=
 =?us-ascii?Q?wce8zUTN0VE8Mphg57jyQFucVN3vqVpgst4AnH4QK++c+3dUUz5YZTP1qVJp?=
 =?us-ascii?Q?fIYq6locr080v+gNVy9v5ZU387zs+AvIJYe5ME61yYH+0IW/oGkJxksMj2/3?=
 =?us-ascii?Q?mEjAX4S85IXWn7qYnmX57im7iiPozeK0UBZAQAqa+mDVDTuBOWP0ThXIQp/4?=
 =?us-ascii?Q?mk1pt/ReAEh7E4RtJjlT5IUE2Fa0a8BDeCRkLgFVPi69pZbqmBmqvsLyYSOR?=
 =?us-ascii?Q?d6cT2j60tS5hCKFFKTjdv3gccETUc5K05HeX7Fne3pLpZx0xfoEr/3XFVBlj?=
 =?us-ascii?Q?2lIGSYruGd9WwAYhAaGevzvcCfRcAhfkJPNd1294jftiz/aDRknGfVE8TIET?=
 =?us-ascii?Q?qEUDMEHxXWRywCalbrRlKcvwMQVT+tefJUkurulYmjTZD0A8V3StULeSJwmw?=
 =?us-ascii?Q?TkVIOaG/QNT7r6Dg6Ql2NaoYa5dLtlaxGobW3j3Woh/vW++tYPzrCwky6xaz?=
 =?us-ascii?Q?+hkyfX2fPL0IRAZxNV4OMMGlVPSc2LRQRFDNat3ExucSvHCuMRGGPaWOlxF4?=
 =?us-ascii?Q?15xgQRzI0O1LqZ0h5pMQQDBqo3u5pWY6T7CbDiNlWSChtXMwSCRhS9ZMSZHO?=
 =?us-ascii?Q?6Q6icGA4lfXr4YdbiTYk/GsTTvqOA66e5YIFw42QidluiB3f1eCnLzKS06Ml?=
 =?us-ascii?Q?sPU0MPpGs6wNAcIb660ShLZ+A6TMO0ZfmnyhbjiAgut6hxptbamVgT/7MsfK?=
 =?us-ascii?Q?HkoZxZUA4+oGehGcR6ltKBU+FyseNEOz?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3SPRMB0001.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uPB+22EgZ7IJHq09ovzu6tT7aaL7I4wzsuQzljJqBpDSYoYlIhcrJxOoGbo0?=
 =?us-ascii?Q?ol2Hj8oWhuQjSIQjaPwuNxu6PQqRtnjupHu/4PIC07/TvCNU/iNCKDHHSvDM?=
 =?us-ascii?Q?m8+hORsVGI3z8MYkL2NaY5U89EGqlbLrBLzuTFZ1dW6xSy2srrlgC3TUhYKP?=
 =?us-ascii?Q?7LRjY+qkV0wpMZ0XpEqo+bDpizgNJ3NpzSXfzHO+XoqVD5hMIYkupl2f0Eq2?=
 =?us-ascii?Q?MWK01Jniwt1vcPMWrzHTA7G2xqTt5X2f3ILMVxjhyFapTw6HIJ4BJZcjvoJo?=
 =?us-ascii?Q?igu/KKKRVLWuMgLG403XZC3uAVX2edmspYlyjCkpT0v42gHeAUDfyqocr+dj?=
 =?us-ascii?Q?1M01ul32g1iAPgLea8inhxMkKxrCl9cLPRrqbXwarrEzmhADHKOYajk5bjsv?=
 =?us-ascii?Q?fdQIattKw6YC7DONCrDyuyXpZCjljV8D3Lb2Bb0caz9L9MNFafh2ywHzJMDG?=
 =?us-ascii?Q?0mj+hwVwOzEFUQHt8gtCoalaVm93yuxRhDmMSB/VRACWL2gMiYghsMDH1HpI?=
 =?us-ascii?Q?Q79tbYW+dJgtBNq3tI9dHoPcwC4TMnmetwNs8LpSTxQKnOoTzLLSd7cU9PX9?=
 =?us-ascii?Q?NUyze1h/Rbrjw49yHFo/scWEtWoFnXFOLWj1fNRDbjXU9OUcvNB2kRrRI2LX?=
 =?us-ascii?Q?SGQ2n0nzIeMRsP+Pc6gtLINe2Ysepvg9Pf8qYI9FtJpyt62+hRWewTjkPU4t?=
 =?us-ascii?Q?Ocmk6ar136x9zCOs7Y2WvvroEFRFJwffzgnl093e0znUKEMmADXpUPWYNonx?=
 =?us-ascii?Q?VazNUIpktKf4ALpehoU/cHcwWyNzUpvsHlRAqHkJulvYq1bEfR897uytLd22?=
 =?us-ascii?Q?9l9U7tPWI3+I1zzNlzuyzc+gF3vvvw52uA/7FXVe7Fv0mvoDP4gExxB4WCAV?=
 =?us-ascii?Q?+14MFi1SXeCBm3EsERHwyQHIsOYDTIpOl/NhSbj7a2PWNWmdeYJ6dBVJqHAQ?=
 =?us-ascii?Q?zF0PmdMu+w97GUNcdTxWH8g567hdoC+/yjzjEBQBBAQaSOiaXahJ8VCZRKZ9?=
 =?us-ascii?Q?JonVzcIJ0m6MTmNF/75CqHLUPyoIPWZUqcwRnBYrp1zXQFis05iuqetonj1r?=
 =?us-ascii?Q?n6eOefFnaroqsXZ//g5mW6PtqDFkwWSX9nYWRJPXCusXCEw0U9PXR+dz5AeO?=
 =?us-ascii?Q?D2RAQhLBMpne9tTLxrWpuh4Ra30FIliroVclcVDRSgser4/rak6+8IKdiOQR?=
 =?us-ascii?Q?6QifybE+goq6KZlq8Yo/idAIECVTtsIycss250lq+ehYD5YBi6Q5++Ds7D+X?=
 =?us-ascii?Q?LoIiPCA3/2/WxpW68uIAl9+tYqxE/I2ODl+5Nay73izmeRnu3HwtPHya8DXZ?=
 =?us-ascii?Q?ZEVug4xjtd3XtSXKrrLlIfQYuuKeLx+c8/y8pv76RpGy4tDjL7jQW9p1d8mL?=
 =?us-ascii?Q?mxk3zI4oQl+XRivuydwZ6dld3tibDzxC7W3T72YrIqh33AShJGgqvGmvlrT+?=
 =?us-ascii?Q?jbYBz5qlmL0b+yQldjccFu0u0ujg8xZf5e6nlPNzkA9su5+l+SxUxU0AsbEb?=
 =?us-ascii?Q?WpubylQlMvQGkbJEJ2yxPjTVPE31s8HEfP/ydkOuod7KU0x8giuiMC+Fd7Kl?=
 =?us-ascii?Q?GNAQvjDYMbmB0+4iUsoJ5+zidRBj1eTinq1dmikC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xZvjLISQUMcl+wUy1xL8MiwkpQQpTECWx80pzu/MdQoQQSK0iroM00H+veZlHpmkd9EHiK5XC+4v/db5FDIemA069yTZBqzkBm8i5LzkyZfRmLcvs7YHEWelwH+TM5Vfe0TTVoN9pP2BnzOKvSbBwJXr2TJvkXwDTd3tk2b3ndkN5j/x/8nNc9fQtq2dwoun4ciCzWFEflMCe0K6yBaNTUctziSFMD+pAC7Z5lE3DBQvT95kj29nH4FaczzfGFqsAVfOk9AS55GhpKZC6qdWypmgNMx7vBIElcgl7FyzCMwMcNtwcb9iHBB88tLT+wQII1nwUbGBwEjMQccaGXYolEY9NgDWd7p8gfvcKAhY8Mk8yuiitmZ3srCfi1SzpeHArjFpJO47DWNauoZYinG7/5lSM625sTZ03tUvuq3kRKwQwXyoN+gcxGGNjh3NUC49rjTVkXPO5QWFp5bFMj23JLJGHdLTG1Wpeju0RB04mpCwEGTsn0W6kkbpSVR5542KBqjgp2beXp7t98VzYVytswU2jIYEGNl8rh89Acxb/obbMdOoLI9Rx/gTFh2auO9CG3JUeeCrPSZsSNv3SO5osXc8uav7NO/Ib9jtWJLGSIwIpvO8yTNLYTVvJuPcDZJt
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3SPRMB0001.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2595a4b9-3f6b-4f6d-4975-08dd1f1b274e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2024 04:19:24.0010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 637zOP2VVpn2cUSjJySpd/u56T1aWbDdVjGFhMVqUQOU/8/15MzL13tizYQLr3yBPGVe8C2JPb6IkQNx+797Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7830
X-Proofpoint-ORIG-GUID: oykO4wvg8iCizmPy71DX5BlcfslyCfxS
X-Proofpoint-GUID: oykO4wvg8iCizmPy71DX5BlcfslyCfxS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412180031



> -----Original Message-----
> From: Brian Cain <bcain@quicinc.com>
> Sent: Tuesday, December 17, 2024 8:11 PM
> To: Nathan Chancellor <nathan@kernel.org>; Andrew Morton <akpm@linux-
> foundation.org>; Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-hexagon@vger.kernel.org; patches@lists.linux.dev;
> llvm@lists.linux.dev; stable@vger.kernel.org; linux-kernel@vger.kernel.or=
g
> Subject: RE: [PATCH v2] hexagon: Disable constant extender optimization f=
or
> LLVM prior to 19.1.0
> >=20
> > -----Original Message-----
> > From: Nathan Chancellor <nathan@kernel.org>
> > Sent: Tuesday, December 17, 2024 11:44 AM
> > To: Brian Cain <bcain@quicinc.com>; Andrew Morton <akpm@linux-
> > foundation.org>; Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: linux-hexagon@vger.kernel.org; patches@lists.linux.dev;
> > llvm@lists.linux.dev; stable@vger.kernel.org; linux-kernel@vger.kernel.=
org
> > Subject: Re: [PATCH v2] hexagon: Disable constant extender optimization=
 for
> > LLVM prior to 19.1.0
> >
> >
> > Hi Linus,
> >
> > Could you apply this change [1] directly? Brian has reviewed it and I h=
ave
> > sent this patch twice plus another ping for application [2]. I would
> > like to stop applying this in our CI and some other people have hit it
> > as well.
>=20
> Nathan,
>=20
> I'm sorry.  You should not have to send these changes to Linus. I should =
have
> carried it in my tree and proposed it to Linus.
>=20
> I'll do that, if you don't mind.

I see it's landed.  Sorry, all.  I'll resolve to do a better job here.

> > [1]: https://lore.kernel.org/all/20241121-hexagon-disable-constant-
> > expander-pass-v2-1-1a92e9afb0f4@kernel.org/
> > [2]: https://lore.kernel.org/all/20241001185848.GA562711@thelio-
> 3990X/
> >
> > Cheers,
> > Nathan
> >
> > On Thu, Nov 21, 2024 at 11:22:18AM -0700, Nathan Chancellor wrote:
> > > The Hexagon-specific constant extender optimization in LLVM may crash
> on
> > > Linux kernel code [1], such as fs/bcache/btree_io.c after
> > > commit 32ed4a620c54 ("bcachefs: Btree path tracepoints") in 6.12:
> > >
> > >   clang: llvm/lib/Target/Hexagon/HexagonConstExtenders.cpp:745: bool
> > (anonymous
> namespace)::HexagonConstExtenders::ExtRoot::operator<(const
> > HCE::ExtRoot &) const: Assertion `ThisB->getParent() =3D=3D OtherB-
> >getParent()'
> > failed.
> > >   Stack dump:
> > >   0.      Program arguments: clang --target=3Dhexagon-linux-musl ...
> > fs/bcachefs/btree_io.c
> > >   1.      <eof> parser at end of file
> > >   2.      Code generation
> > >   3.      Running pass 'Function Pass Manager' on module
> > 'fs/bcachefs/btree_io.c'.
> > >   4.      Running pass 'Hexagon constant-extender optimization' on fu=
nction
> > '@__btree_node_lock_nopath'
> > >
> > > Without assertions enabled, there is just a hang during compilation.
> > >
> > > This has been resolved in LLVM main (20.0.0) [2] and backported to LL=
VM
> > > 19.1.0 but the kernel supports LLVM 13.0.1 and newer, so disable the
> > > constant expander optimization using the '-mllvm' option when using a
> > > toolchain that is not fixed.
> > >
> > > Cc: stable@vger.kernel.org
> > > Link: https://github.com/llvm/llvm-project/issues/99714 [1]
> > > Link: https://github.com/llvm/llvm-
> > project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
> > > Link: https://github.com/llvm/llvm-
> > project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
> > > Reviewed-by: Brian Cain <bcain@quicinc.com>
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > > Andrew, can you please take this for 6.13? Our CI continues to hit th=
is.
> > >
> > > Changes in v2:
> > > - Rebase on 6.12 to make sure it is still applicable
> > > - Name exact bcachefs commit that introduces crash now that it is
> > >   merged
> > > - Add 'Cc: stable' as this is now visible in a stable release
> > > - Carry forward Brian's reviewed-by
> > > - Link to v1: https://lore.kernel.org/r/20240819-hexagon-disable-
> constant-
> > expander-pass-v1-1-36a734e9527d@kernel.org
> > > ---
> > >  arch/hexagon/Makefile | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
> > > index
> >
> 92d005958dfb232d48a4ca843b46262a84a08eb4..ff172cbe5881a074f9d94
> > 30c37071992a4c8beac 100644
> > > --- a/arch/hexagon/Makefile
> > > +++ b/arch/hexagon/Makefile
> > > @@ -32,3 +32,9 @@ KBUILD_LDFLAGS +=3D $(ldflags-y)
> > >  TIR_NAME :=3D r19
> > >  KBUILD_CFLAGS +=3D -ffixed-$(TIR_NAME) -
> > DTHREADINFO_REG=3D$(TIR_NAME) -D__linux__
> > >  KBUILD_AFLAGS +=3D -DTHREADINFO_REG=3D$(TIR_NAME)
> > > +
> > > +# Disable HexagonConstExtenders pass for LLVM versions prior to 19.1=
.0
> > > +# https://github.com/llvm/llvm-project/issues/99714
> > > +ifneq ($(call clang-min-version, 190100),y)
> > > +KBUILD_CFLAGS +=3D -mllvm -hexagon-cext=3Dfalse
> > > +endif
> > >
> > > ---
> > > base-commit: adc218676eef25575469234709c2d87185ca223a
> > > change-id: 20240802-hexagon-disable-constant-expander-pass-
> > 8b6b61db6afc
> > >
> > > Best regards,
> > > --
> > > Nathan Chancellor <nathan@kernel.org>
> > >

