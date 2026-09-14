Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011030.outbound.protection.outlook.com [52.103.39.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA005446060
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 11:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.39.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385564; cv=fail; b=jdMVxk1TngXNvQy5DuH0vu6Doa/MpiddFAaVD4cMYATVUPy1mQLIp41WiIIri5NXHsoqkPnVTRXYuGE1adsGRwZie4kV3Kur0SoifAGvtP0zlJ22w2NL80gURNGbW/fnJ220mYYbCOtKMq4GpAZU3uQUwEwal+gIlSPDyUix9TE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385564; c=relaxed/simple;
	bh=OoS9TIRHT2ywDAoosR79SfIYtHwUWc2/KkCcopnYpo0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oI0n4jY9w4DHnVfMN0sjt0jyDvcfuMndNKWe/vAEoWvFiFRSr11iZOuQJkh12gFontr40CzHSC9GdWWBOGskZ8jwA1m+01TZrI3uPNhWAEnq8WkYd4PtwcpwiC7cb6e8C9HOiNPigmj4LyIySXZOniBK9dBlbua25QbwyUfJ4Kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=uIDlO/Nl; arc=fail smtp.client-ip=52.103.39.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="uIDlO/Nl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IrLN7cmyKfpJSvScnZnxGO6gQ3ZyUaoirSHlJjfGgvI3VyO4H6PEYUeWbWZM/q7EIw+D5NgEl8Z8rPhgT9QAMPQ7FSG7KUBUOA6wKcjXoH30EzxcHtdWykP9ugwAOgmLoEMLZRF5iRGSoctamD7pHDauZXC4lKfIU7F67ckAbTNQKUYuhkatH/vnoORn3e4eng+4TBzvkJUnB1XuRcQTt+eKue104PzfchFUwjCucWCWnEVa5l2K21hyR9PnFeWgnz0PxTt+Mm3QfJAV2KdGuTzZumOEJWQwwCp83jwLBbZ7SSULdCwPSCz0JMqr14takTZvfYZkkz7vXV3UjLrDsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoS9TIRHT2ywDAoosR79SfIYtHwUWc2/KkCcopnYpo0=;
 b=ogj2OuH9nEm6zVnhvO/bw2AYUa4ZWlmsgT6aZBA06vmqsSUlWqzkTfTd8jn8noKjMxP4zGB6f5hCtGlGlbiQgUjFZiOKtnkv4jtF5dv93jya2awebkiFjqm/C91Kcay7MYBZiqqp8D3RkBlZyzJE+tbUhIyTfaLDDT252ZhnPrGyNpnutexv29tT6skl5RfAV0UaGQYz+3Qpv8ewJNsO4YwFsi9FdV4REn/4002C25XYqXMOBRWOdNScdNFj/GMcyhycKhvGdObGWdmX9F8jbdeAg4VJGDHex3qGP0a8g5bdHQrOh5PpQ8szOf6CacLGrN0+i6t57bx5H3a4qnkwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoS9TIRHT2ywDAoosR79SfIYtHwUWc2/KkCcopnYpo0=;
 b=uIDlO/Nl07UwN/RUnbQXVPYXYvd/AFTcBMDp4AhzxdoGiH4WCrw/8UOqQIf2spt6nAIiL90LSA0PL9nmmILyHcg+s4GJPW9BTrmgLrZZ0K2Nc7ILsyA9rlRmDlxI7FbBzOzTGaN2vvU42omGkMdF1Pv/3yOdwd4exuexAAqN5H0sQUQkf8K3IYurmRcatWWROWeGz6xf0Iq27ajUzPTQ7rbfcfIqargaCMaK6zOAZMC0bdk+fvKc6QsPxUMqqqG7fZ3wsfZqIqwJaldlh53zJjBqr1Xm1hNhA8tzQBvyvTSQoO1gGPSNwAK2c4xaXi16b+3EdMn2n3Q+WNdsFvG0EQ==
Received: from GV1PR08MB8497.eurprd08.prod.outlook.com (2603:10a6:150:81::22)
 by AM8PR08MB6483.eurprd08.prod.outlook.com (2603:10a6:20b:315::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Mon, 14 Sep
 2026 11:32:35 +0000
Received: from GV1PR08MB8497.eurprd08.prod.outlook.com
 ([fe80::705b:d4a3:1c1f:b9a2]) by GV1PR08MB8497.eurprd08.prod.outlook.com
 ([fe80::705b:d4a3:1c1f:b9a2%5]) with mapi id 15.21.0428.004; Mon, 14 Sep 2026
 11:32:34 +0000
Message-ID:
 <GV1PR08MB8497A49470CF9120A7C93A11C5BB2@GV1PR08MB8497.eurprd08.prod.outlook.com>
Subject: Re: [PATCH 6.18 0286/1518] leds: st1202: Stop pattern sequence
 before reprogramming
From: Manuel Fombuena <fombuena@outlook.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Lee Jones <lee@kernel.org>, Sasha Levin
	 <sashal@kernel.org>
Date: Mon, 14 Sep 2026 12:32:33 +0100
In-Reply-To: <20260912065629.952461393@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
	 <20260912065629.952461393@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-ClientProxiedBy: LO4P123CA0569.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::9) To GV1PR08MB8497.eurprd08.prod.outlook.com
 (2603:10a6:150:81::22)
X-Microsoft-Original-Message-ID:
 <0eff6978fbe2407d006b53de1250bf40f069e8dc.camel@outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR08MB8497:EE_|AM8PR08MB6483:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c713264-96fc-45e6-bf88-08df1253df07
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|6090799003|19110799012|24021099003|5072599009|25010399006|4140399003|15080799012|37011999003|16041099003|23021999003|440099028|3412199025|4302099013|1602099012|40105399003|53005399003|2607281247196008|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekt5bXJOSzVOYVJxc3g0NzljMzFpbXA0Umk3amZOMDZCWHpMRG51Y2o4bnBB?=
 =?utf-8?B?eTRpZzl4MStyK0REMWlTUVRoMnh4bUd2SXVsYnYyWkZwdE9pejhCUUZzODVw?=
 =?utf-8?B?SkNiUVlxWmJxWlhEL2l1L2Rmem1XVGNZRUdCSU55L3JNcmk1NEtSbWhOOE9k?=
 =?utf-8?B?amZxSFZIRHZ4bDhURDJNYUpwSk4vVHF1cW9mOG5xYWFpbTVsdDZMRFBMbGZR?=
 =?utf-8?B?YXkzaDdZMmQ4ZHZtbGRMeXNuOVNmY3lqU09QZUc4OUdReXBlU0ErVy9oalJp?=
 =?utf-8?B?aStoelJ3WnFaZTVhbVZLSHI4Q1JpY3NqSVFONDFHL2Q3bTZKb2RRN2RremFY?=
 =?utf-8?B?Z0QrMDlCQ3ZGVkF4VG81cXI1Q3UveW1MeE1hVW9xTnlrLzdLdms2bmZ1OXMy?=
 =?utf-8?B?bG4waHJiTGwvSG5oRElqSU1jUmU3bXhOTDVGSmszOE96Q2VPWkdLSUJydFkx?=
 =?utf-8?B?Sy92L3gzczhlaTlxbWNuS1d5bHJaUWxDdFB5M3ExQWJnSEh5dnJaVUIvVzRq?=
 =?utf-8?B?UURyejY0MGpSU1duRXNEMEFka1hzZVhra2pYRDNQZkFqQmhMOUl1UU1vNlR2?=
 =?utf-8?B?eWo1MXRYWlBBSDF5VnV2SUtpSXcvZXYvL2tnR0R5WUZhQmZHUXRyUWJYTjBz?=
 =?utf-8?B?SW0rbmdoeHk3Z3NqQnlScXAwSEhZbDg5RVF5ZDAwaDNGTytXZ2JTdTJ2RXRG?=
 =?utf-8?B?ZFhpVWlXeXMrSTJoWStzSEZTSnlyYUpVS1hWVk5UMFhWU05RVkFwR3YrTEVM?=
 =?utf-8?B?Y2VHNEVHTlB2TWM0clI0aVVydlRlTHlPWXV6SHVaaFBMQ0dHR3UxZU1lOFQ0?=
 =?utf-8?B?ejRWc2haVVM3R3pJSzBKd2VWZHVBV3ZsTk9hcVRTbml3WmhpeTdQcllpTHFn?=
 =?utf-8?B?VnQ2N0xKUXhNRXpTb1JlY0dZN09Sb05JMGg0Y0pRMTBKcU00dTUzLyt5blVZ?=
 =?utf-8?B?WUlZV2hIbkdMTS9QV0dkWld2SVRCdWxVSFZuaEhFMnpMOExlNHk0ODcxdEl1?=
 =?utf-8?B?QW5FeHh0ODZYanlQaW14SHJPYXd0SFJXTWo0MUFBVFVORFlRcXpMSlVqZnFU?=
 =?utf-8?B?SmZoVGg4RUlOYUtoM1VuVjBTME5CUGZCaVIrK2ZjMnlvZmt1U3ljSFg4dk40?=
 =?utf-8?B?dzBwbWhHKytCcUhOUlJMV1BzTXFpWGxDTjZjMlRwUUVrUWZqOUtEbXpUL2VY?=
 =?utf-8?B?SmxnZVhvT25tNjFyYjk1RlJpSFZiVFJUSlFUREIvaWVpRFhZdEdZT2lzL3A1?=
 =?utf-8?B?RW96dUEwSTRzUFdkMkowWFNaZlAxUlRDQ3ZjWndQRStVVkNSM1ppZTNTOHh2?=
 =?utf-8?B?STdrVldXSDN4NzJKV3ZiWEdTMmp6MG5ndE5mTmlVSitwTFUrWUZ3c3VHckEy?=
 =?utf-8?B?RFkrREgzUXo1NkNJd3p4RHNSb1VISnM0dkpndEp5S2Z0UVhIemRPbEJrSnBr?=
 =?utf-8?B?YStjb0VMaUNUcStoaFRpQlFNdUFXbUYxOUEvNmRBPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDN0MDNBRXJ1WG9YTDFRL294dEYyM3Jlelc0a0QveHZYVFVVeHBkeXBBZk9L?=
 =?utf-8?B?dXU4a3RUK0FydzdOWVdlS09xU2J2YWxlNkdXemhQNlFONnkycXJ0ZVBUMnVl?=
 =?utf-8?B?dG9yRGhZSGtNVWRDMDlVTEVGZkovSTVIakZkMVZUa0JWbGxyd3Rkdm94ZEpz?=
 =?utf-8?B?VE1wdExVUFlkb0s4eDF6YjQzQkdOK3VUVUZkc2lDQW1Lc1I2OXc5Z2J4WE5C?=
 =?utf-8?B?MEV0RVZ2RjZteGpKSHVYdHpUQ3YvMDVVZzVIQ2VoWWY3SjRiSFpydGtOU1lE?=
 =?utf-8?B?bGkwa0VGOFlYT1Q5SDFpbE9BUllrZ1F4ZnYxVy9SVVRJclkzNkZqVUxBdDZh?=
 =?utf-8?B?VTVZYzBoY0dqRmhUQlZocy9pWkQ0Skd4TzBJWGhEODc3UXprOVNRYlBXNmtZ?=
 =?utf-8?B?ZEl1NVZuUDMvVG9wM2lKM3orVi9KVEtSMFdyWVhTdDBSZ0JadENhVm1tT2hx?=
 =?utf-8?B?NndkQkxoVjBRdUdaNm5zUFhNb2MyV0dEQWQ1clNBNkM5czQ0N1VhbENqNmVt?=
 =?utf-8?B?YUNVU3JEcGtaSmhNbi9KTUs0SHBJVEdteHUyWXVPM3ZkSzF6UVRiNW9YK0NZ?=
 =?utf-8?B?T3JQaFFWYjJvL1RTWTgxTEZzR1k2V1A5VUlGbzVqSnY4eWhTTlF0U2k2YnNB?=
 =?utf-8?B?RTFabG0vcUExU2ZDN0tFNnM5MkRjd2FsYUlMcGYwQWZCRTNLM2YrTFU1Tnpn?=
 =?utf-8?B?L3A5dDZPM1YveUdIM3p6UkhVemMwUGFORGQ3V0VQSjVQUU9Eak5UWVdTZVEz?=
 =?utf-8?B?MFAxZGR2UEd6VUkzRktBWjZEMndGNTJQb3ViVm03VGsrYW9jdDBmdEhQa05U?=
 =?utf-8?B?UzUyd05wV3R4SjJacU5xY0Y4QXFKZHJzRHhLL3BmdHI5ZkpvWTNrZ2tNeU9D?=
 =?utf-8?B?UjVPcVJCbHVVNGZkT3BrRnByTFhmeHZIZkpPaHYvSVVkYzZUS0xwUUgrdWN1?=
 =?utf-8?B?U2YybFBTUTNwT0tUc2hpN1dCZFh3TUxKQXAyNmp6QVcvZm9jdlNqV25lZFFs?=
 =?utf-8?B?RnNQZ09jQzZuZllkbVNZT2hJKzFXeXJzcHlhSUQrQ2pJS0VHT0FDNWxWQWdk?=
 =?utf-8?B?VWhMN3ErM21QbVgrN3ZzTUJLanJicWtVYXZKUWtoYk9CMHVEUXZhWG95bkJQ?=
 =?utf-8?B?ZUV3SHVZZ3NDZ3k1RDdDQ3ZOVXVYQTYwbm8xOE1pekxtT0M4MTNaYllUTkhK?=
 =?utf-8?B?RnJxeUhHSjhOSVJYVEZoV1RFTGpKOTdiWlcwdjMzYVZLNDRDMXpDY3V5Y1Qx?=
 =?utf-8?B?ZnlVZE1PeGZyQ083SlBYMit5WDd2WnRRMmNmVEEvVnkydU52cXFvRXUzODJL?=
 =?utf-8?B?TXA1aFVhaEJMOWw3Z0pmS0txZXluTFdmWTZuOUhzQmFQK2lEbEtCd1hTUGhH?=
 =?utf-8?B?bnE4Z3UzZjNvem5DeFBEdFcrWDVZVFFpeVppRDI3RHZxb21TRmp1a1RRb2lx?=
 =?utf-8?B?Szk4L1ZGdkNzWWhmUVpkSEgwckhGL3RXRTJrSG1WaTl3WU9QUDBSMTdURFFo?=
 =?utf-8?B?bkcwVE05K2Y3UXB1QkFpd2lxRC9zbXRKdE5rOEVnYlF2U1RzVEZjK1ZDTnpV?=
 =?utf-8?B?bzgwMlpoT3F4WUVTS3BOeklBNmxpSWQrVGU4UzQ1T2kwdmhhV1RFVXgvR0VM?=
 =?utf-8?B?bUYzcVBoZVFTQjMwVVpvYUhhMGFCYmlxZHo3YmdzeGJnUnpyZ2JuSmk3a3RG?=
 =?utf-8?B?V2c4QTlEeGo2a29jN3NkSVdoMW9TNWg5eVVtUmFNaDJrL29keDBxYllHTlFt?=
 =?utf-8?B?bDhtdjRlUnRHUThVYjFJcEtHWVpOZExpWE00NHJ5aFViU3FIekx6eEV1RktX?=
 =?utf-8?B?ajJSSEptZXVMNjdaZUp3OEpHS1FKcWxqT2RKNmx5U0hSODZRM0gxa05nTjZx?=
 =?utf-8?B?NHlDZlozR1dUcEQ4OE13bEZUMUsrWHpyOThQNk55eGhWTlMzVUY3Zk1Ba1NX?=
 =?utf-8?Q?hvXAbZR9KshvCmm6qR8P2cDOf70Bvnl6?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c713264-96fc-45e6-bf88-08df1253df07
X-MS-Exchange-CrossTenant-AuthSource: GV1PR08MB8497.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 11:32:34.7139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6483

On Sat, 2026-09-12 at 08:40 +0200, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.=C2=A0 If anyone has any objections, please let =
me
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

https://lore.kernel.org/stable/20260912065629.952461393@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065629.974560223@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065630.019803443@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065629.997401117@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065630.042235793@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065630.064405951@linuxfoundation.org=
/T/#u
https://lore.kernel.org/stable/20260912065630.087651021@linuxfoundation.org=
/T/#u

--=20
Manuel Fombuena
