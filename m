Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2063.outbound.protection.outlook.com [40.107.22.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96E71FC7C0
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998458; cv=fail; b=FZyX3pr5R9yxJn7kM0AJ9aChVxJbUYFkFeMbHm49/dYsVFm5JsO5PhHy1m/wHqyewQbwD2Wx7yzomAlZVUGRpuDy2UPaulmOBEUf4M+2kg6LnDCMtV/d5fE8R4DgznzgJcf/ppCK/6HKFW2JqAfTKf1iupSV2/mYb06ozuL8kB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998458; c=relaxed/simple;
	bh=rSI2nhnOqYgwQmYBCAf/xdO/I+IYE4wE8TnOfkpvEIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ioCL94A2xg2BVu/dcQD4X7Cg69qiunbCbeYMPSgUiHzm4MBml6ogO2Kn2ODXzYKRPJ7XTwU+iQ+9+IPFGEcTLpKvMIB3uegNcRZXPhCOyd7WH/XGrPWLwFeXJNARgtL9q7gHj9PcnDBqx0SRT3ch0hbkyDl9whzjHLbPUYatnpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=DmjQhcWE; arc=fail smtp.client-ip=40.107.22.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="DmjQhcWE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyHjSC1AvVDkqb4+TGyb6IAC7KIzrVmswhVIYg3wfy48lmSM+2+hVvP17CnKwTqTimGMWqqPc2SQttZG+QWeB5OtAMTMqCaV+Wy18XnwmPW/tkysbPvgQEQCIZCo1Y17uewIlaeUFZtQ+i+rkq5RW++HcfFP6e7FvCDb5GdqhRmZxXhKXJMRbLBtPT8+eD9NTzSkfNdaw95z1HKls1qKXHjpRIsC+kzdDo8kihsyhdZP8Z2dTESGS3y4Tgwhkf/w0OOz2otnNGQxbpTg5bm2MKQdXIRJSZ4ytlR1eqzMlDMObZrS6ebIugMyPFtdGuVdn0T2KImTdcfNz7jC2NhE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSI2nhnOqYgwQmYBCAf/xdO/I+IYE4wE8TnOfkpvEIk=;
 b=RJSajhMXQ2PvhGL1y9mhHufLJNb6BlzZhYHmS4twUM+X6J84zVIIDJyxnJy2hM0aaXJ3fgDE7sYKux2U41NZUWTwBEz/vXi/Q7clsC27O3xLh1W8W5oR47QAhB/tQgivK6hP8ul4uSui2FyoRzpk50+L+d9+lJIyEhjfVFuKlQok4+tYoqUHBlh3Va/NQkZYB5n0nCj3UmYTy3vQbvHFjnnxn3lPwaYSBSO6d4VSBezXGHIoPDEK0+oGP7cElRrkII6gobWoGGQD0r5QrFLe97slfkexHA8a9lphbwzgPlRUl9Wnk3q3hnDgUSNZ2iTsASRRRDUNB+8rGGOk2DPuBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSI2nhnOqYgwQmYBCAf/xdO/I+IYE4wE8TnOfkpvEIk=;
 b=DmjQhcWErJ88bImaLys4B4cpzE96MtzfHxGv3s/TrikBzSe+GB2vLeBAAEB42kFqtxEpDqXCeyPD6nHM9XVYWQHHk2tokIdhcPuqZLtmOvI29hfu5Kef3sCOItnUWUbrFG/JQS463unoop4KVTLUkpp9zaCz+sfh73PnCNiB6TvbImWhle6U506UM1yOLGUew+wdUJtbWSljR2TR+QXI4YsnfLSMGTxBRTVaMNsNfEf9BhN537ztScyJmmQ+1niI7Se+fTl01kJeKIIwGdIwpEHkiaiH9AkBR/Iv+g1uPrX0vskCbJr9UWNjCTQj8l51yPu746JiheWxEhOX9shVbQ==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by AS4PR10MB5821.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:510::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Tue, 15 Oct
 2024 13:20:53 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%5]) with mapi id 15.20.8069.009; Tue, 15 Oct 2024
 13:20:53 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "axboe@kernel.dk"
	<axboe@kernel.dk>
Subject: Re: [PATCH 5.10 259/518] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Thread-Topic: [PATCH 5.10 259/518] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Thread-Index: AQHbHwNQCu/NIhc1hUivG6TF+06L9rKHzBiA
Date: Tue, 15 Oct 2024 13:20:53 +0000
Message-ID: <be695585c466c53cf4192858fcebcfe15d19ee93.camel@siemens.com>
References: <20241015123916.821186887@linuxfoundation.org>
	 <20241015123926.983629881@linuxfoundation.org>
In-Reply-To: <20241015123926.983629881@linuxfoundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2+intune 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|AS4PR10MB5821:EE_
x-ms-office365-filtering-correlation-id: f63d95a9-7f88-4a15-f41a-08dced1c3245
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?azV0bmhEc0liUUtNVUtpUlVzWW9DY29SSFU1a1Rod3RWKzQ3UVlGSStqV05G?=
 =?utf-8?B?dzJPTnFqd2RwcnBha21pazRRUmRZRGJZcGhQLzkxQ2xrK3c0MTJwS3VHd2RR?=
 =?utf-8?B?OUNtc2ZWcUtUc2xvOVlsdXZQYUdoUTB0NnR5SE84SmVid0l1UndKb1BkRUVC?=
 =?utf-8?B?R0VUcjVDMVQvN2pFczRIUU14dU91QjIzZUFTd3BqTWpyNzlQL29NMDRybGlw?=
 =?utf-8?B?Nlh2TUROMi9sOGF1NzdYRU5kNWEzR3dUYWN0OEZVWE9VS0hpc3JyMnZ0bEZy?=
 =?utf-8?B?di9YMlY5b3Z4NXp4ZjQ1dlo1OVQrNzNpTi9uN0h0WWNRbVM0aS93WVFqZk5E?=
 =?utf-8?B?OGhnUVhXU2xEUVVaNDUwMDd0VE1OSUo5L0lCK1NIRm1QMHhPT2hCVGN1Q3JW?=
 =?utf-8?B?Ukx6RmhZOG1lRVZzUnJMa2RFOTU1THVudW1PNE1LZXN2YmJFOUk5MkkzZHRQ?=
 =?utf-8?B?Tjh0ckJkT1VLRklDU1dnQ2dIRDZTRWtzbzVlbStibFZWSEwvbXgxUDNSNlMw?=
 =?utf-8?B?eW5lN1JUL0pyZ2VickJ5V1dQbFplRUs3eGlZY1g3SzNTTkZzWHRIeC91NGJi?=
 =?utf-8?B?Tlptc09ZVDQ1a1BxZlRlcStkM3NOSTFCTDVFRTl5UGFUbTlRNzNydjZYT0Nt?=
 =?utf-8?B?OFMrSXlTOHBaNTNpWlIwMU1PS1poT2hIR0Y3YnpTMU9nVFdHeEZ5WGJCWmN1?=
 =?utf-8?B?WUlzeGVEdGl0ZS9TSHVjOE02VFJSSVZ1QnRnQzU2R0FCRGxUaVZra0QwYnhK?=
 =?utf-8?B?KzRhTkE4SDZmK2l3U1ZvZzMzQjZraG5YemM3RFhiMEVHSktuOW9iY0g3R1FH?=
 =?utf-8?B?QjNaVE8xeTZlUGNvNjBPMDQ2Q1ZjdW85Ry9IeFhaZDk2RXRzVlN6dGM0YVhS?=
 =?utf-8?B?Y2VGbDZCWmM1a2kxRzd6ZjBwV3d3dUZsOHFlOUIrNmhwZExkYU9pY1Y5c24y?=
 =?utf-8?B?YnplY0I4RGNFNmNNWncrNmRtMzVSNk92SHVqdjhFcnFpUElRN1R2M2Zodjgv?=
 =?utf-8?B?dHBxSkZacTRNT1doVE5MSWFNV0szYWFKem5OUFNTMzVRWUc4cGxFNkt1SXdm?=
 =?utf-8?B?dzQrbXdNUmFjc3RQa0ZJc3BtLzdYQnRKYk5iQUVPWWdNeThkcGJ1ZGNnZFNo?=
 =?utf-8?B?ZHlTRHdWdGs5VUNOOXdiNUlieDlhYkp5Tks4OVlWTzE5Sm1veFVIMDE4cFYw?=
 =?utf-8?B?cm4yYXpiSS9IM0R2OTg0OGpFTFFBeEx1ODQzejRCQnEvbHRSSFFvZVY5SVJG?=
 =?utf-8?B?elYvbmFpTmIvTUUya01JY1F3MkZFTlFzYVFmZDdjZkFwbXBhRlpzcWZGRWJF?=
 =?utf-8?B?enpKQnVSRXJvbHg2VDFjYU1ZWUptS0lvOWZnTkgrNmNOVWlBb1RuZVNZbG9v?=
 =?utf-8?B?UUpHNXZnUTRXWXlxOXFXbFpmV3JkYnhlbzlSd3pMTXA2UVIxZEJBVVNMMDRN?=
 =?utf-8?B?T1gxaWh6QWxaTC9RdFdpOVlqSmRyRUppdENIa3VGVHZQRjZGRlhVYVBQcUJX?=
 =?utf-8?B?MEZqak1PNmxyMmc1U0xtdmVpVUIxbUtMUkFxb3l3T2ZGRC9ZZmJEVC9SWjlF?=
 =?utf-8?B?RHhWRXgvYUZidnlFbGVyUEJ4NEc0RHRCWTgrMWRMODQ1eWI5UC9hQVBjTEg3?=
 =?utf-8?B?aTVHeVdSQWRFVGJ1d3phalNjTEx5ZkFOTW4rVyt6Nm9xZ25xQnpXUGJiZ2Jk?=
 =?utf-8?B?MTQ4MWVuS3ZTbEt1Q3dYbkl6aXRuZnhheFBscVlZcE1Vc3FBU012MlVHODEz?=
 =?utf-8?B?U0lUekN6RDZhT1BVbFlob0d4MVVqTjZnK2Y0Q2xJMldMTVVnU2V4a3VCdVJx?=
 =?utf-8?B?Q0o3TTZCRjgxSkJEclJjZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NTBEZVNCN2RjSUpoek9FNFI3dTBvSDZUKzZFQy95d1Zrbm1HYzNVUWhKSno2?=
 =?utf-8?B?Tk0xbTJvS2pBcUZCT24xZ0ZEM3VTaFJCZmhoaG9pYW9PZUFEazBSeTAvVXQv?=
 =?utf-8?B?VndMdzFkVm1wUmVZT3d2akliaFFMRjl2cDZ0SGFKc0gva0hNQzBkbFU5UzZM?=
 =?utf-8?B?c0Z1aVZzQ3lDMlFjN0cwK2dQU2Y2M3ZzdGdXVEVzQ0FtdGdONEpsMFgyWEx5?=
 =?utf-8?B?aUxwdFl3ZWRzZGVObHo1cG50ZC9FOElFWk9ZdnVsYm8rNVBEZW1PeEh1eXpt?=
 =?utf-8?B?ckhFckplMGptQVRVRDFiU25wMWlrK3BFdlNyYko2TEpDTXk0V0R1T0FhY21y?=
 =?utf-8?B?Y3F6L09SNVdGYXlkK21UNm1yVThZcXo3TFpUQUYxYlN6eGpxYkdyWWg3akdJ?=
 =?utf-8?B?Z0pneWh3L0VFdmRVUkp0cWdrdmp3R0NHSmxYUW04cHRRNk9pWVRVaGw0d2du?=
 =?utf-8?B?UmxSSVFsbHg3UFgxUWNUK25mVVZFMUszVUdQb2tHL3BYbVRjaU5wTE5Id3NI?=
 =?utf-8?B?MFRUd2VhUzdqeDlLZGxvNEVoWUQ2LzBjY09jODBGSUYrUGRvZmtDSmxyRmw3?=
 =?utf-8?B?NjdwVEM4eFB6dzRaa0s5VjQzWU0wZzhYZDBuSFp2aUwrSHMyRVhDVzlpQUtC?=
 =?utf-8?B?VXVFZmtNbUxHaVBZQk1PMlJhaHNnLzNtWDVZMFVtOU5Bb0hscG56a0VsNkRE?=
 =?utf-8?B?a0I1bndPT09YVnZkK2g2NDl0OThUVzVUN2o0MEpHd0YvYTN6QW5zbm5EWWVN?=
 =?utf-8?B?YXFlcHBZOUxLTmVjOGF3T2ZRdFdKdzdNYVJWTGR6QUtlMnloQlJnSmNHUkpN?=
 =?utf-8?B?ZWVLN05GaGNuMzRnL01jMDNtNzFkL2RYb3N2UmJ4dVUwMHMvdmNKeEREUTgz?=
 =?utf-8?B?aEtkSWdaa1l2Kzh3TkRqMkc3UnpkNFBuMFBmS0ZMM2dtb3Y3MFkzeFU1SDJ3?=
 =?utf-8?B?ZzhHaDlpSHlpZGt1L24zQzkrOUplcGFsRndwVmh0K2lyZ2JXVnJGODVIVnBI?=
 =?utf-8?B?QWtpZVRMVy9jMXZGNVY3aGR2WGl2R3Y4V2lCejM3NDVaSFYyUEsyVUVSbXdC?=
 =?utf-8?B?OW9YWk5CY2VtTDY0RjFzalh5S0ovNWNKdTBheVZNSjhvTUQ5aGRFcUYrVzBM?=
 =?utf-8?B?MGRNcHN0TTJrdUJ3cHBJU05uRDNkbEh6K25PejkyVVR3Tmg2cm5iTTdvd0xD?=
 =?utf-8?B?NGo5UG9JRmtaUVk0TTRBd0Z4c2NmMW9Zc2YrQU92RkZNd2cxOWJodjNBQjdG?=
 =?utf-8?B?dlRYZXYxSEZhOXBMb3FSYUFualdtMFFUc0U2cmxmRFJwc1pUQWdRckx4WXFK?=
 =?utf-8?B?ZUJ3WEpEMmc1V1U0eGg2ejliOURkazRvbE5HM1pkbC9jekhGcXJNSTJmV2hJ?=
 =?utf-8?B?QzQzbWV2R1NsRHhQc2hTSXNRVTVwL2pOcGFtZE9PeDltUmJMc0EweXdZSFBC?=
 =?utf-8?B?aTBCc1VMSkhhcWZ6YlBnQ3pld3p2UmVVUnRqVklxOEZZWnRKdnpzaWdmZlZE?=
 =?utf-8?B?bVJ4UkZIVk5mT2h0TkE2UVJjSElwUXZjWXlyVXdza0FSMExJWmF4aTM5b3ZM?=
 =?utf-8?B?U2FxZm9WT0g4aXZmVTJ4SVpYa1VPNEZRUkR0NERWbFhoWkxNSDQ3anhqMFRH?=
 =?utf-8?B?VHIwQmNpOHZhSFNBTFBFajdqK00yaUttUVY5MWRhR1lRWlhOWm14ZURJWVV2?=
 =?utf-8?B?RHo0dnlRelJRdEQ1UDZVOER2dDZkZWhKYzdZU0R6ZlVJOVdLNjc2cUVnMTlF?=
 =?utf-8?B?SjZxd0VKeGtGbnR5alBsYXVSMVBMY0dwblRkdkYrM2sxWFZ0UzgrVXdTTlFR?=
 =?utf-8?B?Nm9hdFc4UWF6MERjZkxQU1cvdkQxYjVEVGZZTkZUMiszQStSWUZXSS9WS3o3?=
 =?utf-8?B?UkNUN2tFVVJBVTR4RFR4cTUrL1QzSWZaMzRFUUNudXN2blU0SVNKUnZmMHV5?=
 =?utf-8?B?enY5dm1paUhkRHVkK3l5VnFLT1NKZ0VpRmo1Q2RQVDY1ZHdjam1EZWdBbkhK?=
 =?utf-8?B?TTFMZ2EyWCtkRkJ2SVN6NC9jTlBIQW5iTXpJUlBLK3d2NG43UzVvb2VSQVFS?=
 =?utf-8?B?VFdRcnRpMk1Vd0xnOU5SM0g2dEx6ZkNZTEhuMDNISW80NmRsaEZLWWNTd3g1?=
 =?utf-8?B?a2dnV0hZMWpteXFMWnRWOTZSN2Q0VzFCalhnRlVrUkx1ZUJlTHdMTTY0VG9J?=
 =?utf-8?Q?oXjeB1fcjLca+BYn3tLQ/qQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACA0D2E23F47E74292A53E23D35612DA@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f63d95a9-7f88-4a15-f41a-08dced1c3245
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 13:20:53.8031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4uKcoQ5CP8HT2vtbIUtajyvFgGJQKDfWLBu9mEMFdpqDEI59PyPNJHTBufSI5qD6KYGP4hFiJeGQe9ko1l9r+1ln4YA352oSr4DyJRjpuFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR10MB5821

T24gVHVlLCAyMDI0LTEwLTE1IGF0IDE0OjQyICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6Cj4gNS4xMC1zdGFibGUgcmV2aWV3IHBhdGNoLsKgIElmIGFueW9uZSBoYXMgYW55IG9iamVj
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
Cj4gwqAjaW5jbHVkZSA8bGludXgvYnZlYy5oPgo+IEBAIC04NTcxLDEwICs4NTcyLDEyIEBAIHN0
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
