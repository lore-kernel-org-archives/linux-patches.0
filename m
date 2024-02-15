Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1457351A
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=65.109.113.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714328508; cv=fail; b=CamECi1Qqkqn+drmjBKKOl8oixFw/+sSFdceZC4Tl6PZzgUzvnh0iTeQChzrn1TxoQiJGMfmurQ4f/Nnm+TySR36FwtUa6nJn6FW0hgdZZvMXNuWVDVRsxN0j5CgbiXpSSdqUnjlv0hQAHRzXF4qvyvMAc+THeYG1buhNd56tpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714328508; c=relaxed/simple;
	bh=jkFXbZlr6oCfQ/Vn/aTqpKXGbpGu6/LeGQDRAm6knTI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CghSHpXY3x5zRznBL2qjbMGfDJ3ONH0S+t/Gdy/v5vDaKNd6WevPtYln5E2lX4Fio0UCYoPg/mwrKatbdX+NisRXgWAX2d27vWqdlYfX/LPVrBEHa7BkIHsHNbEIMvixKpE5IfA58SypkArNpwLtvCEstRrAz8cOF+IiKDfOP2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lenovo.com; spf=pass smtp.mailfrom=alien8.de; dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b=ECOB19nL; arc=fail smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lenovo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b="ECOB19nL"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 550B140E00B2
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JK_0vxeqJvLk for <patches@lists.linux.dev>;
	Sun, 28 Apr 2024 18:21:38 +0000 (UTC)
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3613240E0249
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:36 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Sun, 28 Apr 2024 20:21:35 +0200
Resent-Message-ID: <20240428182135.GDZi6Tr8YyN4Q2UFjU@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from mail.alien8.de
	by mad with LMTP
	id mFIrDfO0zWX/jxQAc81XFw
	(envelope-from <SRS0=tIKR=JY=lenovo.com=ahuang12@kernel.org>)
	for <bp@alien8.de>; Thu, 15 Feb 2024 06:53:39 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1E77740E00B2
	for <bp@alien8.de>; Thu, 15 Feb 2024 06:53:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nO7QFQMk7HPf for <bp@alien8.de>;
	Thu, 15 Feb 2024 06:53:32 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id C733740E01B5
	for <bp@alien8.de>; Thu, 15 Feb 2024 06:53:23 +0000 (UTC)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 94699CE24A0;
	Thu, 15 Feb 2024 06:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id E6A7BC43390; Thu, 15 Feb 2024 06:53:14 +0000 (UTC)
Received: from mx0a-00823401.pphosted.com (mx0a-00823401.pphosted.com [148.163.148.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C44D8C433C7
	for <x86@kernel.org>; Thu, 15 Feb 2024 06:53:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C44D8C433C7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=lenovo.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=lenovo.com
Received: from pps.filterd (m0355088.ppops.net [127.0.0.1])
	by m0355088.ppops.net (8.17.1.24/8.17.1.24) with ESMTP id 41F5TKsX000521;
	Thu, 15 Feb 2024 06:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	DKIM202306; bh=M1BgfQfIiSz4gIuIbe6sbwIyT+AsMNK7sxVpLPev/mU=; b=E
	COB19nLDIt3rWHnjBtosSwlSVtuPmcv3tz0RsioKNXBoPGMZZC6+7YU43S/94hqs
	aeG/OteRjGjYN+3N2VoamZ4sC4SIb8a+qQ/22uvVxchu7rTMLXRtH5G2JzaEFMhs
	nb+DHwSJXaVopQlhpl9hTxJ9/C66xJ8J2hfloiOiSsjKTJzWQMamMa2aGtzk/4dU
	neM7aUrit2x8al4nMXiA52f5E4fSp3XKWjw2fCugN9+IC/j7Pq6vT4ENC4lqeu7x
	vD0L/5U25B8d39Me5M8OWSc4U5U1vNgKhKvhxRQxHohPVAW9M3nKO6YTb0ZY1MDl
	YAbYaWZbuyEXi2vi27Ekw==
Received: from apc01-psa-obe.outbound.protection.outlook.com (mail-psaapc01lp2041.outbound.protection.outlook.com [104.47.26.41])
	by m0355088.ppops.net (PPS) with ESMTPS id 3w93f70w3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Feb 2024 06:53:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlUVYLu1YqKU9K+5wV8W9qktBcuPluXgjdt3e4spmnRJ36OgHUI/joIep7z5U1Oo0Ul9NzRbHPI5qppVfqqGHNh3kSXPRR5RGh/igipmFQu6YxW4QZqFx6Ed3XfZ5vbP1Za6Zj0Lbstp3UPK/fDWwao3dy2w3aTj7k7+8WaY0eeut/+0P/3yQ6xZKNlN1xSiN9hCZ+eDCohAIAjcCIIuKm2A7JU0leKWw2n4CUhXd50zdzjDz3CYWEVGoQmPnkzJ0Quh6Bews+1imokDINtF9qrt00ucc6N+gLxIheNN6rZtW+srezXCz7AJdwM86Yd4ynxt93iREXMiK1pH9PUfFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1BgfQfIiSz4gIuIbe6sbwIyT+AsMNK7sxVpLPev/mU=;
 b=RM9ljM+T9emDnkY2or5AnpgFXtyNlhgzy8XZBofsnfDg43mCDtO+8m7qaN+g/NgfXpIb07KtDTpno3dkP0F0OrzPxqnwZiopcdm2b5bk7PRz2maGwzOwacXGiFpQ/EKQQfFQCC+1GneiYJTrhEtWGZbb5jjWnYOGH2KDwS1iyf62TzPe9dQeq02sYuPvU7SliKLNeRU0PlDS2a7ZuhmPGVUyMjVK7u+XxBjtWN7mmLmkBekqBxaD7BppwBSTc8xJKl0B99PaaWQX6s3aTYT1Ajx30ED2Ff3Y3i8RkoWKwZt5+Mp/f6waJ7XRWZCWijxeHI+9gCDxufXwYp8JCqi0IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lenovo.com; dmarc=pass action=none header.from=lenovo.com;
 dkim=pass header.d=lenovo.com; arc=none
Received: from TYZPR03MB6192.apcprd03.prod.outlook.com (2603:1096:400:130::9)
 by OSQPR03MB8460.apcprd03.prod.outlook.com (2603:1096:604:277::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26; Thu, 15 Feb
 2024 06:53:02 +0000
Received: from TYZPR03MB6192.apcprd03.prod.outlook.com
 ([fe80::1c2e:b442:1a8c:efc3]) by TYZPR03MB6192.apcprd03.prod.outlook.com
 ([fe80::1c2e:b442:1a8c:efc3%7]) with mapi id 15.20.7270.036; Thu, 15 Feb 2024
 06:53:01 +0000
From: Adrian Huang12 <ahuang12@lenovo.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Adrian Huang
	<adrianhuang0701@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        Adrian Huang
	<adrianhuang0701@gmail.com>
Subject: Re: [PATCH] x86/apic: Fix APIC MSR access error when x2apic is
 disabled
Thread-Topic: [PATCH] x86/apic: Fix APIC MSR access error when x2apic is
 disabled
Thread-Index: AQHaX9ueNT0pS31h2UeprXT6U0p3Qw==
Date: Thu, 15 Feb 2024 06:53:01 +0000
Message-ID: 
 <TYZPR03MB61928B8AE3F14E86069BDE6BB34D2@TYZPR03MB6192.apcprd03.prod.outlook.com>
References: <20240130145601.7063-1-adrianhuang0701@gmail.com>
 <87eddggvlh.ffs@tglx>
In-Reply-To: <87eddggvlh.ffs@tglx>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6192:EE_|OSQPR03MB8460:EE_
x-ms-office365-filtering-correlation-id: aa16812c-1785-4033-8d11-08dc2df2c0b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 RrB5gePhEB1eifZcKvwSm7/pst6cV1WjByGdGwFQgQzQ1C/c0Bddgkcr+n7SEJCmvBgDhfulqmmbOD3PvN4olGMAxaoevwD/2wsFg03p1CmoJ2Neqz8CEzPfMOJAld2i0H+tw+HxES2DM2uNW1575gYHmQpbBcnVhdhtbZkqkzm1v43Jbb29yoKPLMczRpyZfUXLM4vyt7r6EjitydwLeaJC1x+N1FHUpDWS+iMWwVrj/wYVYq2PcZQZjBwSomnD6LqMnii5CMVFxI1PkyRH25fjKHBG90BKfb+GbiR+eUzGuTvnZ854y800RGskoAkPYJLBJ0ToL6U/93OuZ91+y+8u7yZOjSeaT6KzVUkBtZtG00GmpzzuZUwUGZpgvI4+oiYGQmmsbAHuKCi8NxJKHaNhBpu9seTWDK7AzXMS+zSdENh92DJjM6Sk8y9dvBJJudEbdSli6yzmvciKm4q+rM5ar5NVcy9WOVoIDRJIg30Wn3mBEtZuZsk9Ee7pOa4jsnY+lL5DZnkSZCQhRAPXo9piu0WbLZUFUxGIeMvnEYY7KLyk1LIBW6C7hGxVaH/OZ5DimRjltFGnZgyGkega1+sSqGKJWREHsBmAbla2Ot6hLC0nCaBexyvRQui4avvV
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6192.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(366004)(39860400002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(8936002)(8676002)(52536014)(2906002)(4326008)(5660300002)(66476007)(26005)(83380400001)(33656002)(38100700002)(122000001)(82960400001)(86362001)(38070700009)(66446008)(76116006)(54906003)(110136005)(316002)(64756008)(6506007)(66556008)(7696005)(66946007)(9686003)(478600001)(55016003)(71200400001)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?cWJI2Uv1zAaqu1W79dNOe2tlCyImvFXxFU7GXjZ40gMoCite2g9tet4YGjMp?=
 =?us-ascii?Q?OzW6wkD2myPtljzDRKbESocnbi8Zdh0zojeWo+wsTh8J5D9C2C3ibpF3EN/e?=
 =?us-ascii?Q?WUd4A3wRPdZAepQI5c9+FrKl1Selcp6NXKlKI6xKGlAGgxTJU4rTWjq1eesr?=
 =?us-ascii?Q?LIGfXKh6453hHWCyEBoAfSEK9wWTPNSKUi4ggpsFPIrYmsLJEKDChYMUjPz8?=
 =?us-ascii?Q?hkPWpkIGpIM/7hufjTs3GHwK9wlFkUtwMGEqHA+3y4PbWAg3eSPCZUxMsBzC?=
 =?us-ascii?Q?Z25PZUzPKi8XHVaE9DPrI2Yqv01nP2QGqPUq13xRJUYNz6j5gBeBb9w/Rje0?=
 =?us-ascii?Q?AZXahmRDb1WD+4db0gZSTY1osWipyQtA0jrCxOhFNMqhSarlYIKWZxe8Jgk7?=
 =?us-ascii?Q?2OIpThC+jYbZCH6i2hQ6LO/L4DKMCxAniJQlmYRLBi2DldGvJ2EPNUfFGjAZ?=
 =?us-ascii?Q?wYe1X0mZ2Gy4sKI8B+jmrkPen8TzfR47mHBn2E+2/tdMyxcrZ/501Enfz4QK?=
 =?us-ascii?Q?qkXnH2DHDNxN19oyyPb+0Q+cCBztYwZKhqP3iFcwocpEjH2W5kchGwPrEyyK?=
 =?us-ascii?Q?h65nXIDcU5xMV2dg859O7HNjss0h+fN+u9592mP8gooGjCJ+mPLi3XhOsijv?=
 =?us-ascii?Q?YJOOEBptFPJteSXmZwr4wciE65Ddl1GcCGvUWmCILRUOesukjLS3MT3qFhNY?=
 =?us-ascii?Q?1EhOqraFTLJ4RP0xeGJpDEfV1NrJnob2C3sQLWBNQ+g+77YKc1iGC0CB/Ecy?=
 =?us-ascii?Q?aB/mvsiqs2vPr9sBuCGfCfFJ2WgVErkAfNcqrHxAjKgGFDUvyAKSLtunWjOc?=
 =?us-ascii?Q?iKYCiCesT4p3UbalR9/DBTKWCOphg1ZW57N6Kbfxwf3Mv68bhU8uPnfZgb+F?=
 =?us-ascii?Q?Z9XbNgr0Pn1cojUt5l4Rwr1fovMY65Op7b4EL9f5C1K+t/n79uW0TRLo7Qha?=
 =?us-ascii?Q?QJs0Vy3f6j3auSgBTRHOGeT3UpQ82S+kmo0JLINFtq/ffA9A32v6EFAMawkL?=
 =?us-ascii?Q?rHQnqqv5HkXFmXKcYvz8onWf1kkmc+JuY91crcQnUy721r+UHyCrDi6s9krN?=
 =?us-ascii?Q?sPkFohAQfOAoCzR8JEHQtk+KyUcfAnwMAGnWw6o1joS7VkRam2Hec7V0kTcn?=
 =?us-ascii?Q?kKdLDLsKaQ4JBJh2mED9bRGlRHthDQKzcSxcEm5OZP30rSkrKj8o0PpegMmC?=
 =?us-ascii?Q?U49SdBXmy1G1Z4XW54p6/Fmf88zk2K68RePT0lz6cRPGgurbZ6dJRiuSUGb2?=
 =?us-ascii?Q?+D29ig12CfotmMe0ieMQd2p1pcUCTte5kR+VtQX+/rkdYQAXqAPBXeNRGXxw?=
 =?us-ascii?Q?p+LcwL5uQQPlHU715uKXJ+9BatvDRE6516eTUS4wofN70gWCZGZdBw+CwQEx?=
 =?us-ascii?Q?E/QFaF7G60khApWBnq/8CeZyhli+UYy++U3pJDvxUoTa0Ab4pmwgvzXTbA4F?=
 =?us-ascii?Q?OqGAgtfItrD4izCPEWD4GRJl1tMp4gEF6bRYDnmw2vDGEr3AlrOonOpTYhoT?=
 =?us-ascii?Q?8UdwVuwoxYk7swgs8ADB7eKVgeT/5s3KBHBGg5kwFJPLVBGLHEJDY1nR+3Hz?=
 =?us-ascii?Q?VJX3wZ+A08eYxE9Lnsi/0wYsjvUuGa8VYEJvpL3E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: lenovo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6192.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa16812c-1785-4033-8d11-08dc2df2c0b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2024 06:53:01.8234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UBQoieP3arzncAX+lonB0Q8pRYW7uQQvyLn/4+9V+CFx9uJl5zcEK/mfp07lil1ciUGZ7f5mBN3Ualz9bzpWEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8460
X-Proofpoint-ORIG-GUID: KZTUJh7srQkekXvboBq3UsmjiE6CuQZF
X-Proofpoint-GUID: KZTUJh7srQkekXvboBq3UsmjiE6CuQZF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_06,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=652 suspectscore=0 clxscore=1011 phishscore=0 spamscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=-20 reason=mlx
 scancount=1 engine=8.19.0-2401310000 definitions=main-2402150050
X-Rspamd-Queue-Id: C733740E01B5
X-Spamd-Result: default: False [-2.59 / 20.00];
	 TO_DN_EQ_ADDR_SOME(0.00)[];
	 RBL_SENDERSCORE_FAIL(0.00)[2604:1380:40e1:4800::1:query timed out];
	 FORWARDED(0.00)[x86@kernel.org];
	 TO_DN_SOME(0.00)[];
	 R_SPF_ALLOW(-0.20)[+ip6:2604:1380:40e1:4800::/64];
	 RBL_VIRUSFREE_UNKNOWN_FAIL(0.00)[2604:1380:40e1:4800::1:query timed out];
	 MAILSPIKE_FAIL(0.00)[2604:1380:40e1:4800::1:query timed out];
	 DKIM_TRACE(0.00)[lenovo.com:+];
	 DMARC_POLICY_ALLOW(-0.50)[lenovo.com,none];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 FORGED_SENDER(0.00)[ahuang12@lenovo.com,SRS0=tIKR=JY=lenovo.com=ahuang12@kernel.org];
	 FREEMAIL_TO(0.00)[linutronix.de,gmail.com,redhat.com,alien8.de,linux.intel.com];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 ARC_ALLOW(-1.00)[microsoft.com:s=arcselector9901:i=1];
	 ASN(0.00)[asn:54825, ipnet:2604:1380:40e0::/44, country:US];
	 FROM_NEQ_ENVFROM(0.00)[ahuang12@lenovo.com,SRS0=tIKR=JY=lenovo.com=ahuang12@kernel.org];
	 SPAMHAUS_FAIL(0.00)[2604:1380:40e1:4800::1:query timed out,2603:1096:400:130::9:query timed out];
	 R_DKIM_ALLOW(-0.20)[lenovo.com:s=DKIM202306];
	 BAYES_HAM(-0.59)[81.54%];
	 FROM_HAS_DN(0.00)[];
	 FORGED_SENDER_FORWARDING(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 PREVIOUSLY_DELIVERED(0.00)[x86@kernel.org];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2604:1380:40e1:4800::1:query timed out];
	 BLOCKLISTDE_FAIL(0.00)[2603:1096:400:130::9:query timed out,2604:1380:40e1:4800::1:query timed out];
	 NEURAL_HAM(-0.00)[-1.000];
	 RBL_NIXSPAM_FAIL(0.00)[2604:1380:40e1:4800::1:query timed out];
	 FREEMAIL_CC(0.00)[kernel.org,gmail.com];
	 RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Server: mad

> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c in=
dex
> 4667bc4b00ab..7fc6d5c2c38c 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1808,7 +1808,7 @@ void x2apic_setup(void)
>  	__x2apic_enable();
>  }
>=20
> -static __init void apic_set_fixmap(void);
> +static __init void apic_set_fixmap(bool read_apic);
>=20
>  static __init void x2apic_disable(void)  { @@ -1830,7 +1830,12 @@ static
> __init void x2apic_disable(void)
>  	}
>=20
>  	__x2apic_disable();
> -	apic_set_fixmap();
> +	/*
> +	 * Don't reread the APIC ID as it was already done from
> +	 * check_x2apic() and the apic driver still is a x2APIC variant,
> +	 * which fails to do the read after x2APIC was disabled.
> +	 */
> +	apic_set_fixmap(false);
>  }
>=20
>  static __init void x2apic_enable(void)
> @@ -2095,13 +2100,14 @@ void __init init_apic_mappings(void)
>  	}
>  }
>=20
> -static __init void apic_set_fixmap(void)
> +static __init void apic_set_fixmap(bool read_apic)
>  {
>  	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
>  	apic_mmio_base =3D APIC_BASE;
>  	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
>  		    apic_mmio_base, mp_lapic_addr);
> -	apic_read_boot_cpu_id(false);
> +	if (read_apic)
> +		apic_read_boot_cpu_id(false);
>  }
>=20
>  void __init register_lapic_address(unsigned long address) @@ -2111,7
> +2117,7 @@ void __init register_lapic_address(unsigned long address)
>  	mp_lapic_addr =3D address;
>=20
>  	if (!x2apic_mode)
> -		apic_set_fixmap();
> +		apic_set_fixmap(true);
>  }
>=20
>  /*

Confirmed that this patch fixes the issue. Thanks.

Feel free to add: Tested-by: Adrian Huang <ahuang12@lenovo.com>

-- Adrian
