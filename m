Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010000.outbound.protection.outlook.com [52.103.33.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B9443A81
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 11:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386284; cv=fail; b=gm0PyWy8dBm85EwhF0yGUZV7TdYcpryz4irQE4QmdA3lGKR8Fq/S5kiy8L7Csk7n0ji8BjhdlamSLhi1mVz9VuIXOoYXidd42vMNaxLj/As43RlOEAqK8A5OYJEXn1B47uULmgW6bIZyvMyncXZYHS/KrZNsbyAXPIi46OSW5ZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386284; c=relaxed/simple;
	bh=p+HvZNIcFkdRPaAMcT2bYnUwiI1yR7ECFp+H2Tsjog0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YbqdXixVHJQR/MxXmldweS4+9joQj825zdnz+FWkgT//ixd9wwJTHecdcu4hRU8AqnQstAaG0KVCraDOzsFaUmcZb0B+K+GIuCjwytG+jbo7fU3sZDYfrTnDb7k0M+OYgioxpHcg/se53QfBThUeDf0ia0t5x9An+iSwTm2AZVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ZfvtS0u0; arc=fail smtp.client-ip=52.103.33.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ZfvtS0u0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ww2k/OYWQb7h/m5IGK1YmwDFhoKKJCMnkqWaJWSj/wvX6L56Vhb2Fo6t3yo/902EqJ9hATL8PC4TnIZ+CT9VOO5U9OniKNB57aW2VdkRbze5xPUMOU5qxMr/mPxqgyHpq3W3EcwPnDlxld1Z7OKfG5JVAUmedwdo4a3gNR/T7UkBrgUzhSNLojmnrMBSnBooWgfNrmANCHHjhIELYIxV1RwK4p3PgxGLf5rKbJSRjjELKhKVSAuEXhQ5X+i5ikhNCXXGU6FrvsHrP7reFJpqcHS/S9edpVq04H26nq0WAXlTMXOE3DAvup9oFQXtVrcqXS5neMOuk8Il5nbEsRmdhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+HvZNIcFkdRPaAMcT2bYnUwiI1yR7ECFp+H2Tsjog0=;
 b=VbpwAfywyJn9+MEwoI5FMV5POQVpwdKinNoig3jjHGWPBLPkqNUuVSfkwlWqQBKBUG1fFZcA2FtP4MRBvmaaX495Hm0MjlSlhJmMtuCTx02YB+a65mpVrcXzILaSBfJkSF+WOrYq7l9rijZBEVpHSXgHlqgs6cvpu+/9SmIafS2/bHdV8bpu7lMAawQH7vZ3OI4va5OVyBUvtAIWiGEN4PfUzw78ml2hc0tClqpwgA4YUUzajqhOJNgQ2iRPtaAj/5ec5I20lfxJRWWNYOFwUiL+Q0++NaiWcYOdteSOsZ4C34XR0XP/tLcD4h+CJTIskwwajwtObQ9Oa4HeDYCkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+HvZNIcFkdRPaAMcT2bYnUwiI1yR7ECFp+H2Tsjog0=;
 b=ZfvtS0u0bKGvsSxPGzPhzh2liYwJskFswZCRJNX7/FQh4eqJ+CTmOK3q078z9mo9WLtzwIPCsC9ktIXnlipED912+ZdaKGo+dLNrpmRL/kMhfkqgoup4vPTBFyyIwkXA0wQXNHb8m+YAstqzS0jFC4/FmO0hustvFKTOKM51Czs6McsDs93UulgnlD+RCpiDFeib8G1nUSSzYshmulvhhVEtfeutkbT5zjMzNDAemTRcUInQ57OP9Kkb6S5w5ByXb43WAYdLuh/5O0xpHGISDnebdM1A3P0yufAk35G+A3nbvIFHcQRLT7MhzCgnAbCNHfolkfKR5Yd0Ry385p8ALQ==
Received: from GV1PR08MB8497.eurprd08.prod.outlook.com (2603:10a6:150:81::22)
 by PAWPR08MB10117.eurprd08.prod.outlook.com (2603:10a6:102:361::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Mon, 14 Sep
 2026 11:44:39 +0000
Received: from GV1PR08MB8497.eurprd08.prod.outlook.com
 ([fe80::705b:d4a3:1c1f:b9a2]) by GV1PR08MB8497.eurprd08.prod.outlook.com
 ([fe80::705b:d4a3:1c1f:b9a2%5]) with mapi id 15.21.0428.004; Mon, 14 Sep 2026
 11:44:39 +0000
Message-ID:
 <GV1PR08MB84973FE9321D2874451D5DBDC5BB2@GV1PR08MB8497.eurprd08.prod.outlook.com>
Subject: Re: [PATCH 7.2 0292/1815] leds: st1202: Stop pattern sequence
 before reprogramming
From: Manuel Fombuena <fombuena@outlook.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Lee Jones <lee@kernel.org>, Sasha Levin
	 <sashal@kernel.org>
Date: Mon, 14 Sep 2026 12:44:37 +0100
In-Reply-To: <20260912065655.809856076@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
	 <20260912065655.809856076@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-ClientProxiedBy: PR3P189CA0031.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::6) To GV1PR08MB8497.eurprd08.prod.outlook.com
 (2603:10a6:150:81::22)
X-Microsoft-Original-Message-ID:
 <d90374ae5da2eca0789455b44b005cee9ce57653.camel@outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR08MB8497:EE_|PAWPR08MB10117:EE_
X-MS-Office365-Filtering-Correlation-Id: cf586262-d3ec-402b-1f8a-08df12558efa
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|15080799012|51005399006|23021999003|37011999003|6090799003|19110799012|5072599009|25010399006|8060799015|40105399003|1602099012|10035399007|2607281247196008|440099028|3412199025|4302099013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmUyV2tMRWdRMWw2RjlPb3lyWUs4eU5zaVhvYU9yWitRaUxYYVNBN2htRWVx?=
 =?utf-8?B?RllxbXg3dFp5UTgyYUlIRVBCMWZ3akVscVBwN1lLOTBNaE92dWk5aGd5clUr?=
 =?utf-8?B?RmNERytPL253aHc1SHVYMlc5alJqOTJYekRwajd2MTVXcFlqYk9LaDJzMVBY?=
 =?utf-8?B?MWJ0Y0VGTkoxTkpvYS9XaldZSnVBMGVsWDZiOEFFMlUvYkVVSHQyL1EyTnBp?=
 =?utf-8?B?MXkzS1I2aVFOK1BMOVBpdGVCYzhUZUxFc1lsVUxGMEU3VUJJWG10NmxqYWdl?=
 =?utf-8?B?RTdSaDFHTUJiSGpLSmhvbitacllYcS8rRmVDQXJCMVgyUXVtUndFK2Q0NU1v?=
 =?utf-8?B?cDdDNWtnTG9VMS9XcUQwV2dwVStXcUZMUTU2RVJFNDNjVEM3eUFCTk1JdjRr?=
 =?utf-8?B?MGdzUS9XQUJleUdnVlpCaHQ4OFVvVW1NVlJZMGhqdmhITnZZbVMvUllRb0ZH?=
 =?utf-8?B?VVM4UlpxZy8wRkovRVB2dm5tRlhTVk1IcGZTYllqWVZCVm1vNHJsVU83S2VY?=
 =?utf-8?B?YUZ6N2RzZVZ0czRDY2xhT1RUQUZJT2M3bnd6bjdVbCtVZ3ZCQkdNUG50NHdL?=
 =?utf-8?B?ZEdHakRCU2ZTOGxld1hZazNDYXRJZ0thQWp1M3I3TU1zSUcwaXFnK1FPTFpp?=
 =?utf-8?B?Myt2WTYxc3FhU0dsMU5KMTBudXlkaG04K3dLa0ZOWHBBVkUyQTFNNFYrVlJ2?=
 =?utf-8?B?SHBhWmdjckdMMGFwdGprQ214cno4NWFqVnA3ZDJ5UWo3eFV1dWdOa3Z6VGJM?=
 =?utf-8?B?SVNVYURpSDZHMjVvMFhpQXBXNkxRc2s5SlR1NVY1TFJyWVQxTmYycUxDNDJ4?=
 =?utf-8?B?RWZsd2l4T2pqS0JiQldSbXVaUGZuWG5NWUIxZlNjbEMrSkw0SkxEUFd2K3lG?=
 =?utf-8?B?Z1Npa3hMclpHM25wVldIMVVYTXE2WlB1SEpJU2FzSEg3U2NlM1JzcFgzMzdv?=
 =?utf-8?B?ci9CV2FXZ1BmVVhmZHR3M0JOaHBhQkRrRTRLMHM3aStkb0RKTFVDcHBsRjJK?=
 =?utf-8?B?cEttVWtJRWE4M1I2d3RFeEl2L3QvckdRK3ROUXVqYTZxT2xjMFpybWFFdkE4?=
 =?utf-8?B?Q3ZIelBqSWxodVlpWmlkRzN1ZHhlQ3lRVGtXNnZ4ZzFqd1MwczRqUUZEd1Yz?=
 =?utf-8?B?SDlHRTVFOVdqemsvWE1keW9PbDEzNUZwYjdKWi84RnlleHVlaEZPU2ZmU1Nj?=
 =?utf-8?B?ZG5iejNEckVuSTIvekpoOWZHU3dQMk00d3dsa3FZOTVxeldweVB5Y1Zib2VD?=
 =?utf-8?B?ekpkbE5OdHhwQkxDZGVlRW5sUjdiWWthWGlXR2s2M2lYektDZ0V4UXZMR2VI?=
 =?utf-8?B?U1VVYmJ5S00rQ00yYzRLSXczMElpQ2pkbmVDa3Z2LzdrZXdxUWx3SHFLbkx4?=
 =?utf-8?Q?0dUQtiJRtPmdUtZ9YnBt+iAGQMXsikrA=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGdMTW5UUkNuY08yRzZ6THdEZEFWeGF2YzdBSzNiZ01ycDZXT2Q3MWZTREpt?=
 =?utf-8?B?ZEJYYzlueGlYRkFKdXRBUVZyUlo0VW1xWHZHZXdXdTZ6czduL2tuM3RnazVQ?=
 =?utf-8?B?YWprNUdTRTk2dGlVTi9oRVpINHdHSjlVQXVXbkJjZjRFczUxNkQvQ0FBcUVK?=
 =?utf-8?B?TzdGNTI0SE9ka1FLaHBVS1JqcVdEcFBCb0xDejgzOTVaeU9lbDcvT0RIWmNq?=
 =?utf-8?B?bzFJR1p0MEtqZmRtRG85VU1pQ2hOQVlqZ1ducnVGOXN0VkR4dGpHaHZLTG9X?=
 =?utf-8?B?SzY1eE9Fc3EzdUMvSGF5ZjR6c21FOXJTVEpjQTRKYTJudExRNE9nZm93M2Rq?=
 =?utf-8?B?RUNBNG5LcmY2VnQ2MEtGeTIwZkVkSWl2aW9UV3M2a21WNVNrK1NoNStuaWE1?=
 =?utf-8?B?dFJJVHg4N0piRzdXTEFzRVllSS9aTXNSUW5sNlhwcWVBTi9GTlBRSUpwekNy?=
 =?utf-8?B?NzhXWGJUeDNUbnoxVnRhS0FtME5hejR0NUJ3OE85NUFTbGxwYVlkbW0zNkRi?=
 =?utf-8?B?YWY4V0k5eEh0Mms0UkxFcUVBbCt6ditvWm9uQjRDUVg5WjhtSi9GbnNIWGFG?=
 =?utf-8?B?TktSNnF2SjlDbmxoaUxSMUtudDV2WitmZEh6aXArV2pEZGJOMTNrMnJHRkdh?=
 =?utf-8?B?SmFmV0c3anR2dFZUUXFNNmtoQ1dYODNWdVlRTUpSalFKdU1OOWwvek41Tld6?=
 =?utf-8?B?SGFhRUpaVExoaVQyRjZVdDhWR0N6Q1IwRFhWdm9wOUR3YmxmNWNEUnBEMFhy?=
 =?utf-8?B?U1JpbVUvdUs4QXB6M0t5TmpyOFdzTGRKb3RqZER5ZVBINjJ5SUpKOGZrZjRl?=
 =?utf-8?B?dG9HdFJ6MmNUM1dNTG5NU1pJbExWVVNtZTVEU1RFYTFjb3RKamdMZUdqVTds?=
 =?utf-8?B?QWtFQ3lkZXhadEQ4Y1VMb1h3cEpXVGlnZkg0eENXeUhwQW81cmhCbG9rQTgz?=
 =?utf-8?B?eWVadnAydDgxd2FackxmOXUrczZRM3Jhem9DZXB3VXQwNXRNcDFDUzBpd1JS?=
 =?utf-8?B?aWZYTnNod21UcmxKS21zamE5ZXRhemw3Rzdsa0pqQ3ZUamZwVVNWdUN0WjZV?=
 =?utf-8?B?NlZvYlp1YlNkWklYVTlJNCtINWlHMi81aEsxdXQ0dThLSzVsMlBMNGsxSGlx?=
 =?utf-8?B?NThtaDMzcllyVmNSRUtEV1pzcUkrL2ZrS3R0QXVCa25OYUFCNjh5UTlxdk5Y?=
 =?utf-8?B?dmtPeCtmVnlHdngyazZVTWxzYzZwK2R2cVpoTENsbHN6dml3cS9ETFdQSy9n?=
 =?utf-8?B?Y3hCR2h4K3hwZHN2R0VDSDBUUjhHZmg1MmQwRStlSi9uNlE3THVBYmwwMStu?=
 =?utf-8?B?UGNYTFpEZmg5Y09Xc1ZES2F1WW8xcWRZTE1DL2U5bGx1czVqcG9aaXV2Mnl0?=
 =?utf-8?B?VWRXV290eVFYT2lOMFlTR2xubDdUSzFSOElvYjZveXVYRmVDVXMwZENSbm9P?=
 =?utf-8?B?bXdwODdvTDlsem5mY0crS09VV2RabkRkMHJRd3N2RzNubzBrSnRGaDZQQ2tT?=
 =?utf-8?B?LzJWOGloVkxVdjRaTjh0eW1hL0ZyaUtNOTlnbEk5aGxaR2JYRmVDcE9LQWY5?=
 =?utf-8?B?WTZ1WHRUK0hmdDdrSXNDQXFveHI1amdYS2p1NW1ab09tWFNUTit5ZEtQTkEw?=
 =?utf-8?B?RXNlTVFMQXFQV21vM1JoNlo4RFZmWDRFL0JON3dvOCtFRWQwSzNDdFIwLzFK?=
 =?utf-8?B?WFkwZytueFlERGZSZVhraE5BSy9IVHlYZjdXcWZJRTkzajN4R1g1MGJxOXFw?=
 =?utf-8?B?MHF2TUNLN1djZzJyQmdPTC9WRFQ0U0NJNXhFV1g0Wmtqa1I0bnB2NmVGZk1V?=
 =?utf-8?B?cjJRODBPS05vUnBjZ3VnbmdLYWJBQ01NQmhXWGRaNzYrTW81bDBpcXJyb1dt?=
 =?utf-8?B?VmN1Vno1N1FaUm1BY0xsSG0yN3BBcjFpWHdSMXNhTEFsY1dVWk5Fckttb1pK?=
 =?utf-8?Q?MPasp+V2hjX6r2b0ZyOhzCRu0gyv2p8o?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf586262-d3ec-402b-1f8a-08df12558efa
X-MS-Exchange-CrossTenant-AuthSource: GV1PR08MB8497.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 11:44:39.3169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10117

On Sat, 2026-09-12 at 08:34 +0200, Greg Kroah-Hartman wrote:
> 7.2-stable review patch.=C2=A0 If anyone has any objections, please let m=
e
> know.
>=20
> ------------------
>=20
> From: Manuel Fombuena <fombuena@outlook.com>
>=20
> [ Upstream commit 9c019a8cb95d820e0bd03e75cfbad2c5b13941b7 ]
>=20

Please note that this patch was part of the following series:

https://lore.kernel.org/all/GV1PR08MB8497C0B898789BB73ACE6EE3C5F52@GV1PR08M=
B8497.eurprd08.prod.outlook.com/

The testing I carried out on real hardware included the complete series,
including upstream commit fd2529ba8fb44cd4b56f1069363b949644b42cec,
"leds: st1202: Validate pattern input before stopping the sequence".

That patch did not carry a Fixes: tag, as I considered it an improvement
rather than a fix in its own right.

I do not anticipate any issues with the series being applied without
that commit, but I have not tested that configuration. I therefore
wanted to make you aware of this, in case you consider it advisable to
backport fd2529ba8f as well.

The same applies to all of the following proposed backports, including
this one. I am not going to respond to each individually, to avoid
unnecessary mailing list traffic:

https://lore.kernel.org/stable/20260912065655.809856076@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065655.833961377@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065655.878387982@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065655.855974619@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065655.900583086@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065655.923720976@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065655.945941789@linuxfoundation.org=
/T/#u

--=20
Manuel Fombuena
