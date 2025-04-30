Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010020.outbound.protection.outlook.com [52.103.72.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4222609D0
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028259; cv=fail; b=TNwci7g8BrR0GTXjJKqfTmngn1EdmWRUhSWJencf0R/A8y9Y0ZO/wAUgkdYxByYNN4SXApKwVCOjVlyoMDs5lg0v4mK0KMqBurMTXKNWiOv5YhRxFukd1+vDvcQr4Gw8MZioz6VS/otxAV0nmYkodNxnHaoh6JLckLy4/Ezfidc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028259; c=relaxed/simple;
	bh=HSFJwg9aDEEWdRXRDwlwIiTIJreppDrqGBkJ0tfveBA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IfdTXgq4WVdElh/j6Dk+41DVBg2qwVznveANe3ITVt/yUbZ5QN+8zfP7cLCL+eA5xhgQnsuqO5bw61BiwKOYgpVni5OvUoW9jpwfMAYDeASnLF18vS/Jo5Z9C4jmOvQ/sn1/lYVYKXujunAvWdb2a1K9V3/wO9YK75c8pPjFDDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=YIDCeRJa; arc=fail smtp.client-ip=52.103.72.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="YIDCeRJa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IA9pNmJJ0pfTtOwWh/UrIJ2UGqRiEZlinEMN2VSsjBqdgxj1AGFGUyMrM3U0j0T+yFzbnbs3xDkrWcdjJgAeYQDwe0pL0p9YHUkcmAzAYIPpJ0WOSUtMJtxvbScShR35eq7oNqGUgoIhfSEObMFFbRWM30gypSbd8nHEJnfm7BdbAl1NuKGuQiicP4452H/iOLd7hWuzpwx0pyPuBmJ94PaqgiPu3u8qsa1RmAsgr64fWE1k/JHxkDg4ROG3yDfj78rEot/QYivaz4lSDb5iBIOyq8MK9Cs6iJKB73dxFX0riPw34cybwEdBmgeB2d19ldtaC3TdPZj3Ckamt0WjdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSFJwg9aDEEWdRXRDwlwIiTIJreppDrqGBkJ0tfveBA=;
 b=q0zcw0bSGOVtoY1VvqnI1ZMDKyo/oLCfWOGWwg3XRmXdPHge/w4pBBukJ6uq+o9WdW6Zt5kTqaaf71iDrmmm5LEjxWbTIZKctfcsUWBQZl2ewZaNnh81Q77/MKiPyUdGcg1KG0E2a0jk2GoxG175XlEIxaAsQtspq9qKTxJb7BOoHH/x/G3TORwUscuO8JfDKRegyDzpkxfC6jq0vCvMmQr/w00KaEihiU2Q//rosLUlIz6y0CR16fMD8e9cpz/UEbYt3HUJgmFNPmr64o8F9N2BK2Y7fNoVt65QlgvZYNCLJariRswRYcbNmnEaCTtql7k8bbVjaUbLGieAvwpcEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSFJwg9aDEEWdRXRDwlwIiTIJreppDrqGBkJ0tfveBA=;
 b=YIDCeRJaGLR3a/eqm6gC6pwKb+R2wG29x32c1H2iMAR4G5hyRq7n/lc6EDXV5Oo0G8K993OKEV9PJ4S29xWJT9k7EUFFXCMjSGjqfTPWriTf7ny6YSROHCYo6/AqhbYgqaOFxHYh7UPRjFoQceqPh97q9oSPCDgs0hwZpfCYO2IqrobzxCmGR1CamtwTI+QEGa8YeiOCw4La+PA5m9PD9v1l4NWUnhlJt/JAooMp5C17/zR/RuebsEiRJDPK38VdG/iyAovOrrcaO3FlEkSbHPXXCnvtDSf/l/HyFQ6VmoR7tEfCXbtreRUIgXGwZAkrFntyeKPzYprY2iObHJGUcQ==
Received: from ME3P282MB4082.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:184::13)
 by SYBP282MB4231.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Wed, 30 Apr
 2025 15:50:52 +0000
Received: from ME3P282MB4082.AUSP282.PROD.OUTLOOK.COM
 ([fe80::329f:5812:bf5a:3472]) by ME3P282MB4082.AUSP282.PROD.OUTLOOK.COM
 ([fe80::329f:5812:bf5a:3472%3]) with mapi id 15.20.8699.019; Wed, 30 Apr 2025
 15:50:52 +0000
From: melanie nuggin <m.nuggin85@hotmail.com>
To: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject:
Thread-Index: AQHbueemXGRPfHn9w0aXy8wL5AAP9A==
Date: Wed, 30 Apr 2025 15:50:52 +0000
Message-ID:
 <ME3P282MB40823AAF5381D29F971738209D832@ME3P282MB4082.AUSP282.PROD.OUTLOOK.COM>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME3P282MB4082:EE_|SYBP282MB4231:EE_
x-ms-office365-filtering-correlation-id: 5b853c4d-0d71-49b3-1468-08dd87fec906
x-microsoft-antispam:
 BCL:0;ARA:14566002|8062599003|8060799006|19110799003|461199028|7092599003|15080799006|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?iucBluGBxA/Nd1EGqMPSfGubfn+qyuTH+qw31gMqQ0nWRvhG4MRqvii0K/gf?=
 =?us-ascii?Q?u5Ha7uTImrqc1hEZfcRshzCXY4ZTEQTa8OhEvHDbMqhGlLqyZNQFmYW9Ujxr?=
 =?us-ascii?Q?sCGbD34pOPpCkrMhEvyJVddGLTyPOwiNln3/fY/fkHFsUm23TAec+dfIXNIT?=
 =?us-ascii?Q?bLOtAalkcl9Df4FUjwKWtfvSHxCJoT+0WhBAy5xCyEE8JEJEuyy2EjPVx7H6?=
 =?us-ascii?Q?f8Y5lLhFGXwsq3nRdRWhTPiyuk10nefL2++INbqQ5VFNYA7dviz9N2cZHwrk?=
 =?us-ascii?Q?Ho0Y777V5ppoDYmJdOlEAfiP3jk4aCNg5gwLvMchvX6Z9V+t/tJXNDvnOh1f?=
 =?us-ascii?Q?8OIe3vl5mQI/PyD6NK+QKmI1a5q9ga0LNwEYPNAN90UQfDODRmderIoEvv+w?=
 =?us-ascii?Q?TyDZghehTdE4X8IbNPk6pDIbfHgxEFBztMRk7xfM+5P1zOoR0U8R1IdojcAH?=
 =?us-ascii?Q?v4KzI1wybzJ7CxQ5HJQ2koouLQIpjoTr9+GcgkFz2+H6prCCU4MKqI0GHp5h?=
 =?us-ascii?Q?O/Dtw3XMRuMCgVzmInywQVI4+jsGlhhvX5HiXm0gO9xwQwIN76j+xgp6bFEw?=
 =?us-ascii?Q?qLSR1qwhnWknDchqN1mn+f6maR3nG0Sxh/YFA7PhE2CQrajXhxszHFNzQtOW?=
 =?us-ascii?Q?GFcMm3cP8J6vVwo8aSZ0WhSO2dY4fKwuE8LmcEI5+LZ6zjDTpoq8B838iORM?=
 =?us-ascii?Q?wz8PZvqARgV3WIcc3tAoein7F810Es9X+qRstUCJK4P9NDNdzbnxgeqy96Lv?=
 =?us-ascii?Q?1dNbGte7LfhydoMIHCHQCX1Qrf3ef4jLhen9Z0NDd3NurBc7M67dVJ3b1le/?=
 =?us-ascii?Q?E4oKMuf2+rSnxq0aiUoVPeEwYZlvvR9MzuWFgr3E8elfoRPZ/ofLsqYi2u+r?=
 =?us-ascii?Q?Nw2+vpDUe11BfRdt5SPG0jz5dt093R4D4hy2PWrCPnIw2SlvT/lATiHOu3y0?=
 =?us-ascii?Q?TiR+9rc4q7nHyzp2eaOHm1m6QqK8gtF/mGkZSf7vaqwYk9FPy/Ul2oDFj6NU?=
 =?us-ascii?Q?atXxZVWKux1LiVlUYIu/B2gSn3GIlPbXM249PnkujEcTIx8u6uknfX/KnvPl?=
 =?us-ascii?Q?bPDkxNDHEu15zqubJTT0K5z6NOBW+1ANxwPTg/a0I3T/OGMoo+3xsWgbniBT?=
 =?us-ascii?Q?xkLmX1ZVtyci?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?HGUV+qCY7AMhVzGWFGoprInb+MQe9mSFaHRAhOzSAR7+aZW6IFoTXaZbWYP9?=
 =?us-ascii?Q?c1TahprHILoZZatb/ey+rsui9yxbjawFs7Dw7bcYqL5ZVifwXldyX8Im8KLI?=
 =?us-ascii?Q?FFVoFH2vmaG5MGzVlYrWaTa1lx2/1vzKSFc5lIGTeqwZwohFaomaMs/DaRXB?=
 =?us-ascii?Q?JJnwQAnYR4Se2CoLNxdpEOkxE96SE1OroSTjhtEVW/JJTaE6KoCrQ0gPNcC8?=
 =?us-ascii?Q?O5ct6XIATH47qFGLAOqoZ4h3knJHRVZwdpQnKfxpRCHc+tuhT9SlNo0u9MHY?=
 =?us-ascii?Q?r9R1R8UVBD0qrZeT/NbOphPnT2D7+unUnoIZruAdAVBaBZ2QX40hIWGuZhug?=
 =?us-ascii?Q?OJB+F+h5PukV3V04AxsBIunxCANPdzh+7tf4Nh8KhVWPJVoJYzGc/QeMkiQS?=
 =?us-ascii?Q?XQdEb9NxJE6sNTwQisqudaK+AAhwpgHpSlBICaT5QmOIZZTZY474l2hsqrCx?=
 =?us-ascii?Q?Al6xc9kC7sZsxJyC4Up5uh/G9wVAaBZjwl/OfQobKTXPMCAwAogy8vx3572N?=
 =?us-ascii?Q?vAWnbzGfBGeMm6Mny36EAyAH6oYYoMn5ETOiJebQEDOeaAc+2AmO/euBkpAv?=
 =?us-ascii?Q?1eNiOH3y7QYaxc0hfgAqSAvywnDnV5BApWl1qN6dLWpKJ453l37reGuGVmXN?=
 =?us-ascii?Q?RoQ9/c5Z50UAOWBouMtGpd0ZpPv9FFujERymarxZq5rnlKksl5t5FhHu+gsb?=
 =?us-ascii?Q?8S/cC9wPvUNY2QVSGoCGq80D8Z4svXc3Kmq0kz9EYXiWwwhQvIO3snFRtJol?=
 =?us-ascii?Q?QYUgGJWGWIv4NE9Yfmm+c3xmI1Jcantl4Vm01lykIc+PbE16HMjwXu2OSsiG?=
 =?us-ascii?Q?IapXkkgTiiFaatTC13qf29Akja4X0BR5yrhlxyNJciKpMO0ds5MUpYer8ZjF?=
 =?us-ascii?Q?9Ckatk8BE8UGQQePKW6i5bxzAtJlsQlCTbhh3mm4F9JjhSqImUwwwEAq5As9?=
 =?us-ascii?Q?A6uW55OtOnr5FRNIoKiVV9Xe8NlSHcSS5OCv+K1txKUbuJ4ew5GVZLqzb1hy?=
 =?us-ascii?Q?Ik503wSdZPFxLme/MtaaLRX903zN3J5NmOiN+GGR3+Yo5JMf6IaMH4WWsdXT?=
 =?us-ascii?Q?N7Idfzp34FcgTvaYK831wOrB3uAxsmlJEN4wem+wGo2EGhgG4pbWD977J+0R?=
 =?us-ascii?Q?pWK+cFlxqvpxqI7z3NVp4NE3YwCBQ2VCmFdCMJy93czWmDaXisAaLyvLZn0w?=
 =?us-ascii?Q?zfZbraEhZkHx+eI8wFup500dTn3j+y62sLGROa0pcllNqWVeFfDCcfh9I9E?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID:
 <C4C1C93E937C9F429804122BDC406266@sct-15-20-7719-20-msonline-outlook-722bc.templateTenant>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-7719-20-msonline-outlook-722bc.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME3P282MB4082.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b853c4d-0d71-49b3-1468-08dd87fec906
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 15:50:52.0506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYBP282MB4231

B
Melanie nuggin
