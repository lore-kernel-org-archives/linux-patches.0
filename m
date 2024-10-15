Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460F91AF0CE
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998434; cv=fail; b=gDFFu+JFMO4tm32ceqakJYcdqhckFM0f9Mtxb7Rk0p/OyvzTGvawpcWWPqzN4CnLSRmbJHEqRT8GLg3OruVdcZdncVUTmTecBDHCxzvY+vNiBJrVYcVwQ/lchwOuyeFctxELA54oe/dHb7tCW1abqka8hUh44JJ5BB62LT6q6uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998434; c=relaxed/simple;
	bh=adUX66Bn2CZiZjnePN91yXRufK85h7ilviJycUDYq0k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FtGZi86ky9UM+hr90erZXKu7j+6Q7m0y6qIj6O0m6hbQOtbMtGyn0PNargJ23B3jFKbngwEBiWx3FWY/n2sF9kD5FDs99DH9EGDTAHs2M0+q4tqIEcIhP083lHg11hmPUMtkq33G0d+0U1lPZciwYbUsrAqqBjrWdhTzn7xgN6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=f04SL8f1; arc=fail smtp.client-ip=40.107.20.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="f04SL8f1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sjXWTuHdIwp2VXkWbJqT+aqx91VsNDasAM5wljZwCFD/o9d5ch32IFl3avrw7Tb5m3ZbNVqaq1vmBD+PXzLfKnEMtzaDBCzDQ/qKcdHzZZJzTKqTHPwRdhZzkZk+/ECs+L7hWzHBVM+F3E8TiAJGintR+vMnlYNDF+b+OJQFJK28bS7vKp0wxeXFDgvvMtYCZQKv/arftvyGdY5Nbi54UEO4Pjy7X8EB9RYEeCD6LcvyjD9wXEc7V3GveB2yLUgs2PJybgL4WANvK8hkmZQnM9RuHKHN0jdImurBUvYP7vtCgSB6V/Mk6+mIu+/jqVtv3Gc1AYqrlbXg5auVoC+bUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adUX66Bn2CZiZjnePN91yXRufK85h7ilviJycUDYq0k=;
 b=U2MGetpFcHo6OnjChA698e9ClWkhjT1HWMwFKiaT1z8xzPxsOh7eiJznH4ekygBWCMAhXWyzB7Ah5T2BWUkdyWuLu/mlXHaYdibItG61EKiEt9ovj8GriYhUd4hzBEHcqUjydhBwi06MLQInrOGvzT+ZgBeSmm07hPxqjvyacVtGdFhxm271B0Mp0ORY9jSCcAd3fpxAlgcXg0dLYhja87nfRci4hO6f/rS6BK99sR73lz1FBZdSOx5yJD+teJ+DaMTzsmm7juCYbihAEJGcoQlaTc3rL7r6OK8xDGSp0Sr97Y7v3Aq15w1YeHQOJ+gLIG3eUCoAMNno0aHuLGJLLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adUX66Bn2CZiZjnePN91yXRufK85h7ilviJycUDYq0k=;
 b=f04SL8f1Tu7FCig0TcSyvgbVVK8Aiop66IzQCdItAoIYE/b5LNbaLMqXtKNxj8NNrZu+h+SR38sa/YiGdSm6Z+oQ4/PAu7o7CRb9pwjuL+qQMsuKABZt0aE2xVNvk6Xjo2C6C7FPAMBrK+8EvkDb7UYr/gl3aaBB2sgZYNhY/XHitnH/a8lAM3K/54Ogr0QfwGlngpd4psPTj4wPtRIWvAekJI84cdiXnWU36vdL55xjiqkmG8fkpPJHhTTEVtid6pn2I3soMVP59+3PA8r6d9hhbf0WR6wxOVB339P8cqQVziHVsmD1hnGthwI1O1ZGimH+fHVdAoSohV6ELd2fOQ==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by AS4PR10MB5821.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:510::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Tue, 15 Oct
 2024 13:20:29 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%5]) with mapi id 15.20.8069.009; Tue, 15 Oct 2024
 13:20:29 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "axboe@kernel.dk"
	<axboe@kernel.dk>
Subject: Re: [PATCH 5.15 364/691] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Thread-Topic: [PATCH 5.15 364/691] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Thread-Index: AQHbHvkFehudOzoKYEyfozMG7U2lg7KHzA4A
Date: Tue, 15 Oct 2024 13:20:29 +0000
Message-ID: <d55cbb574f8e69f4168b4e7be6caa8dd41362152.camel@siemens.com>
References: <20241015112440.309539031@linuxfoundation.org>
	 <20241015112454.792741046@linuxfoundation.org>
In-Reply-To: <20241015112454.792741046@linuxfoundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2+intune 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|AS4PR10MB5821:EE_
x-ms-office365-filtering-correlation-id: 0a120852-ca85-41fd-7b3f-08dced1c238c
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RmE5dGxnd2UyN3U4ZERraHc1YXhLVmFvMzE3alBZZFZ4Mmw5Q25GRDRNbmRC?=
 =?utf-8?B?ZEIwQlN2dWx2Zjl0ckZVUGxuZ2ZPclNBZnQvZjJ1WUwvdkk3emFsQU0xRDl1?=
 =?utf-8?B?V01iRFE3WEM5TlNIVks5TVBTYy9vVGgxMjE5N1pLWlRqc1hscFVJclE3aUti?=
 =?utf-8?B?elcvM3JnWVZMY2c0K3pZaERlRm5XVjczSWRSTFB3ZDJvU0ZwUzZPZE9Qc0xS?=
 =?utf-8?B?THdDVFROSXBvS0trVmRLdE5LQTNMUk1BdFZYZnJVb0RrVTJENFZ4Rzg1YXpW?=
 =?utf-8?B?TnJRcjJJQXdMOCtHUXNzY1dzWURVUnJMbzgxTEpQQUNJZXE1Z3FjMmtDUlhh?=
 =?utf-8?B?d2hFK05XZDlvY0VuNk1VRmZ5bnR6Y3NWZWJhYlNDc25pSzFMTXI0NXpaWld4?=
 =?utf-8?B?YitrRmlxMjZJaG1pemowNWVFdTVXYW9Jcm9TcjVja2dRcWRWNFdqd3M2dTg4?=
 =?utf-8?B?NnhYQnZQcWJQcmRxbCtxNUo5bUM5c2hIUjJQWStjZDVaQUJQSGV4dHR6VWs4?=
 =?utf-8?B?ZWtIeDZPT09VUWdWZi9RMVgyeVhpVHA5SFU3c1A0NzNGUFR1TEI2eUc1a0R5?=
 =?utf-8?B?eCt0VS9oM1NPZWgxMFNEK08xNzA5YWU2dWhaTGZDUk80OFdmZm8zS1JxdTFi?=
 =?utf-8?B?M2FEOWtBMFROOXRKZTZ5K21xN1ZWdm1Ta0dPdXFJaE5HeUk4V3VQU2NzTVBU?=
 =?utf-8?B?NmlTdWJGTENucElBSmcvOHF5QllqakEvRXQ0dVdaWTBCcnpidCtWb3BYT1lM?=
 =?utf-8?B?dlE3em85VGczWWUzb2NOR1dJT1FGYmNCZ2w0Sk5ncHVCUDFoQ053bDJ1TmZx?=
 =?utf-8?B?R0tlUjF4UHZxUE4xZUZKSjI0NmhjV2g3SFovSzZ0elpBZVd6cGVTNFVNNkk4?=
 =?utf-8?B?eWd2OVN0eFdNanI3cXY1OHpVNlVqeDd6RGJlUFZqNkRmVkg1L05xZ2E1MGh5?=
 =?utf-8?B?VC9vOEhpcFdXR2hndWZ3T0VUSXJCNUZMb0xHTnZHS3hXMjNZcEhib0NVUG51?=
 =?utf-8?B?M2Vjd253bVFGb2ZWbDBUQzNKZ1FkWGRMTUgrclc0TWVadzZCL0xURFU4dE1s?=
 =?utf-8?B?cGVtdmpVVEc5SURKZUh0eGw4M2NRekpjL3NkbDArK2ViejJvOEZUVFNVOHJB?=
 =?utf-8?B?VFhHOTMwMm9tckI2ZGhZY3lFM0VGRmlPMWRSTi9IMmIzdmlyWDFFZmZBdWhu?=
 =?utf-8?B?b3FydHYrQ0t3N2czMCsrVkNvTlV2SUQ1Z1B5M2RERVZYWXlycWJxaUJxYXM5?=
 =?utf-8?B?eUpQV1hteC9QT2xDaXYxbTlwdkZRa2UrUmJCa3ZRcFlIeTlmNnhNcW9jL3J4?=
 =?utf-8?B?cEdwajZMZ0VKbXYvenZyTndIKzFLV240emxOUDEydG1oOU10Ym43Y3NDRHUy?=
 =?utf-8?B?dWhuYndUV0t5NmFMZTZvNGt3Q080bTM2YkxWNTV3aXpFcGcweDk2aTJydi81?=
 =?utf-8?B?SkdPZ25wbUhWV0hMU3N6SThkQmNlamh5ZXFYemp3dzlwSXkvcDNsQ2tVeVlG?=
 =?utf-8?B?SlMycVE4Rm1BRG5lK2JCMy9USkNWVktvaER2cHNYRHllRmlibDJiRVdBMk1h?=
 =?utf-8?B?dXRNV0NHV1pYMUZ3ekttWVlXSVo5ZGlIWU5OU2lNMVZaRG9Eem92RVRMcXhQ?=
 =?utf-8?B?ZUJWcmtOWno5MGZYcnIvSVJoVzJxTkdiZFJSakhpb1N3WG5CTzRlamJTWG1q?=
 =?utf-8?B?Q1BhZlZJenAxWktYZjB0SW5sWkpHdVlSZ3U5TjlZM3IyWUhzY1l2ZVYrTUcr?=
 =?utf-8?B?SWx1VEk0aGt5OEoyR3dVa2RTbEkvdURvY0JGS3FGRjB5STZJU0tLL2g0NmZG?=
 =?utf-8?B?Njk4YjRLb2hFeXlFTjZxUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUUwMHpNNUJMVW5hVzFqaUlTR0M3bW81T056OWlBOS9iQ1pkMGJVQ21MRVZZ?=
 =?utf-8?B?RzBOZ0dDUGNZZTdZNVhUL2ZHTXFQdlNmUWwzNFlDU2hwMHU4ZWxIR292R0J5?=
 =?utf-8?B?NWxQSTZ2Qm4wWVdONFRZeThzbFZhSVFFRWVPQ1grQUVtUWJ6dUhYSUxjN1ll?=
 =?utf-8?B?RnB4MUJadzFuNFhDa0FObEVqU0t1dS9aSEhuR2lhOHJSTzBYWTJqL0VNdXFB?=
 =?utf-8?B?a0dybk9CN28rTDJKV1NtbE1ER0F5c0o2Y3lCNXRuODZPRG5vWEhzcklKYWxt?=
 =?utf-8?B?SFJwOGsyMmhRUDBOdk9uSWhjNCtjYUJ2S3NhSVZJdHFzWkF5aTgxVHRiU3h4?=
 =?utf-8?B?QTJOaHNXUW5VZnR4U3U2OEZTZk10MklqN2hQT2h4ZjJaZ2o4OTh0bEw0UVdt?=
 =?utf-8?B?cmZXMStPNGI0M2ZhL3lFZTdRR0o5bE0yYTlYYTVaTHA0WHJkRCtNUzFpRGZS?=
 =?utf-8?B?b2R6L2k3Rnp6QU5nditzaWZIV3l3aWkzUmgwb250TEg0NFFyNmt2WGNWWENK?=
 =?utf-8?B?RGl2THRKbWtZcWkzaldZTnZFV0NXSGVPWjVHZjlKbVl4MWpEVTNQNGVITFMz?=
 =?utf-8?B?KzRsS1I0eHlFRWJ2Z2JrajlxYjdRdnlvaVYyV2g2S0tUd3YvTzF1L1hTenJN?=
 =?utf-8?B?NWFWZ25TaGNheG44YU9Yd3gxdVdVd0Uwd21ZcnFCRDZFZTZRT3UrN1ZOTE9O?=
 =?utf-8?B?K3BDdndLWVVkQ093YXFFRC81dzhaVnEzaHBWeFdsMG5waHovQzhHQ3VCT3JM?=
 =?utf-8?B?WkVLci83bE15YXQ4dlQ2M3p1SDhBcUZPRGxsbzN3aWlncUt1SEYwejJBSjYv?=
 =?utf-8?B?OWluOUYzNXMydXBKaXNWNXJkYnY1Q2dMUHlxdkdDOHkvUlMrTGcxTE15ejgw?=
 =?utf-8?B?RkU5YUtaUjcwOHRQV2E0K0lCeTNSNGlncUJsWU9NV3BMYS8vYTV5MkxaRG5w?=
 =?utf-8?B?NWV6SjgxVktLM0Iyak1tZHE3SEhiVjZxY0hEeW0xaUpFOUtMWkNCL3c4VlQy?=
 =?utf-8?B?dzUvU3pRYWtnSk1CZVExdXVRV2M0WG5zL3VPR3dGNmI0V1Mrb01DazBnc0pl?=
 =?utf-8?B?MVZjM0FER3RyU043WDZKVjFtckw0d25hNm1SUHRiL0hHSmcybkhLUS8xdklh?=
 =?utf-8?B?Y1RIQk5VRmlCbnJxckNpTU8wTTlqTjhVdmVLdlRVa2pibEtNVEhvVnZYajB2?=
 =?utf-8?B?aitWdStvSUZwWlV0Ny96SFlreW9BTDdsamJ6dG9sVHRYNjJ4SHp5UkhUaUFJ?=
 =?utf-8?B?T25RR29jTTg4bUk4ODZhVTJNV3JxUW1qTC9ld3Y5ZysyYS9iUCsyTGFKbk0x?=
 =?utf-8?B?UXdCaVkwWTBuckZQVkQrV0J0dGZLVWhGN2QvSzh1L05wWFJmbTR5YVRINTRt?=
 =?utf-8?B?ZlB4SWN2L0RSd2J3d1FRY0lnQXRpblN3Sm9uc1I2RG16S2kvUEhuY0FiYzNi?=
 =?utf-8?B?Nk4ybTBacTRvU2ZjY2R0Wm5kTnR2dXVWRzFBc2ZRN1VtRjFMdWQ5d0tOOXht?=
 =?utf-8?B?aWNhazRPQmpYcHZ3Wis3QktCMXFqUSs2eVVzVVdnYXJXSkpHQktRQllacHh4?=
 =?utf-8?B?a09qaFJjc2VuVHpyRXd2WFo3Q1JqOXIzWFh3Q0dvYWt6cExiL2E4QWFpRmls?=
 =?utf-8?B?L1A4Q1RaSDlUSmh5QldQY0loUG4zdGZ0ME1SamltTnplcFFMaU1EWjUzV0h2?=
 =?utf-8?B?VnNnQ3Y4OWtMdEp4blo1RU92UTVSMmEyNmRhdTk5K29na2tycXJUdkk3azJv?=
 =?utf-8?B?NEU5Qlk1QzIxbmJaVVJiOWd4RzdlTE1uRk1HRyt0UUVFcXlYNFh6NTNYUkFX?=
 =?utf-8?B?R3F1bnA5TTJDS3RMTlNmb1k1QzRoa1VDMi9LejhBSGFIQ0h0L1BHWWx3WGZo?=
 =?utf-8?B?SkQ1OWJmNmplRWlQUjVyNTJMdWd6TTN6Y3kxVm9iS0EzSnFIT1c0M21MS1lP?=
 =?utf-8?B?TXgxZUVEQ2FBNURDck5TM2dwamlvNDZTRlNVNGJQM01INDF2WkhFZDRpYnU5?=
 =?utf-8?B?MHdwN3JvbmVGV2M2akplWSs3ZDQ5R1hGZDFPREQxbWlrYStOYURRaFBudUpz?=
 =?utf-8?B?NDltcUVuS3RsaG5KNitYdGUybkRLRDhiQVUyeHhuQWF3QXpWbi8xaDYrczlG?=
 =?utf-8?B?WU1mZSswajZUaEpzaEFvUFY4Nm5EYi9UTXZJRzI3V2lFUFVpZ3dEVFVta2JS?=
 =?utf-8?Q?6hIf4dywv0Vxb4Pmh5kW+bg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <007CAB10A1556348B4AA85B728E589B4@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a120852-ca85-41fd-7b3f-08dced1c238c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 13:20:29.0684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I3cMrPFevPGLKqVoO3wYijlZQ7EL10LtXnSVp14X1AcRdbkMo0IJINTsvEaL/McAXlUt2t+DZGrTpeuV4IAqCRiGzoII6EN1V4FnUhUDuPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR10MB5821

T24gVHVlLCAyMDI0LTEwLTE1IGF0IDEzOjI1ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6Cj4gNS4xNS1zdGFibGUgcmV2aWV3IHBhdGNoLsKgIElmIGFueW9uZSBoYXMgYW55IG9iamVj
dGlvbnMsIHBsZWFzZSBsZXQKPiBtZSBrbm93LgoKVGhpcyBwYXRjaCBpcyBidWdneSBhbmQgbXVz
dCBub3QgYmUgY2hlcnJ5LXBpY2tlZCB3aXRob3V0IGFsc28gaGF2aW5nOgoKYTA5YzE3MjQwYmQg
KCJpb191cmluZy9zcXBvbGw6IHJldGFpbiB0ZXN0IGZvciB3aGV0aGVyIHRoZSBDUFUgaXMKdmFs
aWQiKQo3ZjQ0YmVhZGNjMSAoImlvX3VyaW5nL3NxcG9sbDogZG8gbm90IHB1dCBjcHVtYXNrIG9u
IHN0YWNrIikKCkJlc3QgcmVnYXJkcywKRmVsaXggTW9lc3NiYXVlcgoKPiAKPiAtLS0tLS0tLS0t
LS0tLS0tLS0KPiAKPiBGcm9tOiBGZWxpeCBNb2Vzc2JhdWVyIDxmZWxpeC5tb2Vzc2JhdWVyQHNp
ZW1lbnMuY29tPgo+IAo+IFRoZSBzdWJtaXQgcXVldWUgcG9sbGluZyB0aHJlYWRzIGFyZSB1c2Vy
bGFuZCB0aHJlYWRzIHRoYXQganVzdCBuZXZlcgo+IGV4aXQgdG8gdGhlIHVzZXJsYW5kLiBXaGVu
IGNyZWF0aW5nIHRoZSB0aHJlYWQgd2l0aAo+IElPUklOR19TRVRVUF9TUV9BRkYsCj4gdGhlIGFm
ZmluaXR5IG9mIHRoZSBwb2xsZXIgdGhyZWFkIGlzIHNldCB0byB0aGUgY3B1IHNwZWNpZmllZCBp
bgo+IHNxX3RocmVhZF9jcHUuIEhvd2V2ZXIsIHRoaXMgQ1BVIGNhbiBiZSBvdXRzaWRlIG9mIHRo
ZSBjcHVzZXQgZGVmaW5lZAo+IGJ5IHRoZSBjZ3JvdXAgY3B1c2V0IGNvbnRyb2xsZXIuIFRoaXMg
dmlvbGF0ZXMgdGhlIHJ1bGVzIGRlZmluZWQgYnkKPiB0aGUKPiBjcHVzZXQgY29udHJvbGxlciBh
bmQgaXMgYSBwb3RlbnRpYWwgaXNzdWUgZm9yIHJlYWx0aW1lIGFwcGxpY2F0aW9ucy4KPiAKPiBJ
biBiN2VkNmQ4ZmZkNiB3ZSBmaXhlZCB0aGUgZGVmYXVsdCBhZmZpbml0eSBvZiB0aGUgcG9sbGVy
IHRocmVhZCwgaW4KPiBjYXNlIG5vIGV4cGxpY2l0IHBpbm5pbmcgaXMgcmVxdWlyZWQgYnkgaW5o
ZXJpdGluZyB0aGUgb25lIG9mIHRoZQo+IGNyZWF0aW5nIHRhc2suIEluIGNhc2Ugb2YgZXhwbGlj
aXQgcGlubmluZywgdGhlIGNoZWNrIGlzIG1vcmUKPiBjb21wbGljYXRlZCwgYXMgYWxzbyBhIGNw
dSBvdXRzaWRlIG9mIHRoZSBwYXJlbnQgY3B1bWFzayBpcyBhbGxvd2VkLgo+IFdlIGltcGxlbWVu
dGVkIHRoaXMgYnkgdXNpbmcgY3B1c2V0X2NwdXNfYWxsb3dlZCAodGhhdCBoYXMgc3VwcG9ydAo+
IGZvcgo+IGNncm91cCBjcHVzZXRzKSBhbmQgdGVzdGluZyBpZiB0aGUgcmVxdWVzdGVkIGNwdSBp
cyBpbiB0aGUgc2V0Lgo+IAo+IEZpeGVzOiAzN2QxZTJlMzY0MmUgKCJpb191cmluZzogbW92ZSBT
UVBPTEwgdGhyZWFkIGlvLXdxIGZvcmtlZAo+IHdvcmtlciIpCj4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmfCoCMgNi4xKwo+IFNpZ25lZC1vZmYtYnk6IEZlbGl4IE1vZXNzYmF1ZXIgPGZlbGl4
Lm1vZXNzYmF1ZXJAc2llbWVucy5jb20+Cj4gTGluazoKPiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9yLzIwMjQwOTA5MTUwMDM2LjU1OTIxLTEtZmVsaXgubW9lc3NiYXVlckBzaWVtZW5zLmNvbQo+
IFNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KPiBTaWduZWQtb2Zm
LWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPgo+IC0t
LQo+IMKgaW9fdXJpbmcvaW9fdXJpbmcuYyB8wqDCoMKgIDUgKysrKy0KPiDCoDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiAKPiAtLS0gYS9pb191cmluZy9p
b191cmluZy5jCj4gKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwo+IEBAIC01Niw2ICs1Niw3IEBA
Cj4gwqAjaW5jbHVkZSA8bGludXgvbW0uaD4KPiDCoCNpbmNsdWRlIDxsaW51eC9tbWFuLmg+Cj4g
wqAjaW5jbHVkZSA8bGludXgvcGVyY3B1Lmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9jcHVzZXQuaD4K
PiDCoCNpbmNsdWRlIDxsaW51eC9zbGFiLmg+Cj4gwqAjaW5jbHVkZSA8bGludXgvYmxrZGV2Lmg+
Cj4gwqAjaW5jbHVkZSA8bGludXgvYnZlYy5oPgo+IEBAIC04NzQ2LDEwICs4NzQ3LDEyIEBAIHN0
YXRpYyBpbnQgaW9fc3Ffb2ZmbG9hZF9jcmVhdGUoc3RydWN0IGkKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiDCoAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHAtPmZsYWdzICYgSU9SSU5HX1NFVFVQX1NRX0FG
Rikgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3Ry
dWN0IGNwdW1hc2sgYWxsb3dlZF9tYXNrOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGludCBjcHUgPSBwLT5zcV90aHJlYWRfY3B1Owo+IMKgCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gLUVJTlZB
TDsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChj
cHUgPj0gbnJfY3B1X2lkcyB8fCAhY3B1X29ubGluZShjcHUpKQo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3B1c2V0X2NwdXNfYWxsb3dlZChjdXJyZW50
LCAmYWxsb3dlZF9tYXNrKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGlmICghY3B1bWFza190ZXN0X2NwdShjcHUsICZhbGxvd2VkX21hc2spKQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBnb3RvIGVycl9zcXBvbGw7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgc3FkLT5zcV9jcHUgPSBjcHU7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB9IGVsc2Ugewo+IAo+IAoKLS0gClNpZW1lbnMgQUcsIFRlY2hub2xvZ3kKTGlu
dXggRXhwZXJ0IENlbnRlcgoKCg==
