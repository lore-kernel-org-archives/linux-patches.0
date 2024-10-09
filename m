Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02olkn2070.outbound.protection.outlook.com [40.92.50.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D017E918
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 07:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.50.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728459581; cv=fail; b=dWlEKNwln3CXBE+wZcBYrg1MsaPpGcBiCR0Th2U/kPJA8iBUzyIXVuuswmo6V8BFjjR8yDmLm0E8FSLYIdy423TINCTiV6M10XJzGFw5Bh0WBslQ9ZQK/igld8wY1gRMCo7+FqOSvUQGwPbiwbOKMmUEDcEtC1J6U/hrSQ2CJbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728459581; c=relaxed/simple;
	bh=QtStiprJVDcWW5fWw/wM+wxb5yTw7AQCDXuVsiR/iuk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gsYTurjqZCAUHjurOeH9Wu7LSLAM1N0FzUd7vR5YXpzddCw8Gg5CfkxEfg6yQUrZLzhB1LcbmtkQOzWC+DKsPU5iSZmD2SFHFFL+lx38w4MsiE11bp/ijVAbmdcMYsO7ApEwrqrq7Z+rfCquQ8G0gAJ9jQgcjYngh93y4gtaXDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=jBLRqYre; arc=fail smtp.client-ip=40.92.50.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="jBLRqYre"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LC/q61pPw+wI8Aylm1P0yxLa9EGQTVJyhD6dD/dvi9IiPsa/QR5cminoOMLdPTtpCGIyI5HzT9YfR/KPpCzDbLFlXDcIdfUctJ7kNnuOi3bO7vhfYwRwv5UOgDbYylfnPhBxMas/vejJrIaUHgbAo8j5jo+71SY+GcM8sUIkPBbYRbHmcQtnigQ5tWrAMyLI6YdLk0liJiuFOegdmLJyZYT3Ba4tDQgdedPzfi3lHQe53Rj9l3FAJVchG74a5OR9nrlf4OIZUKFUfupG3u0LBmPfr6OY6xo/7U5n91xQ2YfH1E/5Ee92PDa+7hn3zwkB28tJFapGdZ2o+ObKNVz4BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLS5sjNTSXLEKqfjywVrjArSEmDGdDXM+5q222KIh74=;
 b=LG70xJpZC4D/m5UfB/z6bezrRDrLWcaP4t9I5i2GQ/cJT+lezzcX2vArRf7PKry8DudABEkI/TCM8ypXrw3NhLGQCOZQRpe2s74Y74WcBOaj9u2/ecKALfz148UTBML4pqpPPY2M9yznSQ3AK88kZ0Ktv87NKBeGHe5u0yf1MgftWklG7Z50aMLp3MqbVQiZBuOIbcU6W5lQSrlMaYexqysio0oajfk55rXa4I+vx1oKHfHRdLhLAXuAUU/nIgvgKeB9TTj9iC5oOJaXFl5GPWN5khNjFeWdbilFsYhzSQm9ffkl5RcckgQ4csqBuk1FP88Bv5S6vMVRxHGKQjrbQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLS5sjNTSXLEKqfjywVrjArSEmDGdDXM+5q222KIh74=;
 b=jBLRqYre6KasfRwaTjme1vL5cjyyQU/YpEUvFrPCJx6ijRzg8/WwkbIGt8AkOpxzhWmfaL/LtOzqR3LetCQEduiOrLZDreNsb0ZAqOgkGNb9XzQxLHjJ4mAlv6EFhF70MUgA4amDiJxABtO8hYs5NLR73wb9POgVSGFMxkp17cln3u0nzjnokb4Xc30PwfocbVcQmN0EhsrlPrjMf/g6a5bMjnzdK5IVaH8UaMdEmT7VbvTEMABinFqfG2fN2DVCtwMZ6YOaY7UTVDjCvA0zn8I4ax7XhDHsRY3OEbkqlE8sAKuBNgeIX0GqSvGv74eFv5IZuFnoLtLZoFPxEoeCSA==
Received: from AS8P190MB1285.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e0::21)
 by DB8P190MB0730.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 07:39:36 +0000
Received: from AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 ([fe80::5307:a61:337b:f3fb]) by AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 ([fe80::5307:a61:337b:f3fb%4]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 07:39:36 +0000
Message-ID:
 <AS8P190MB1285F4418478B4EDF611467DEC7F2@AS8P190MB1285.EURP190.PROD.OUTLOOK.COM>
Date: Wed, 9 Oct 2024 00:39:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 109/386] ALSA: usb-audio: Support multiple control
 interfaces
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
 Sasha Levin <sashal@kernel.org>
References: <20241008115629.309157387@linuxfoundation.org>
 <20241008115633.732179368@linuxfoundation.org>
From: Karol Kosik <k.kosik@outlook.com>
In-Reply-To: <20241008115633.732179368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:907:1::36) To AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e0::21)
X-Microsoft-Original-Message-ID:
 <999944e4-8f15-4d1d-b69e-715e70199978@outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P190MB1285:EE_|DB8P190MB0730:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f10553-9341-4b45-31e6-08dce83585dd
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|8060799006|19110799003|6090799003|461199028|15080799006|7092599003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	TTA+dyp5XzJcKTBsoEenU6t8NW9WMKqDz5Tao4FY9lWsshuOJYA1Zie2/2dn1KczCdQiCQdgFV5VkQ+uAwqVoO31avdmiAuQJ7qISBwegZqx5SNRUQTBmb7ezmVsZ2vTBSXWOEnD84s0zugx53WSzTdLx0SU39PlbCDvX2yrZF9uSq4GvyM1rF+J6j5XGeUzNCrxBa8A90oBe+EfTOaq+zpV30cLsFcH1U6S/lo0+OUKsSGb2YCRybeXVqDzcgPWrSf2g2KcsfCRBDIlQpjQ0vQtXIr6Od1M4GLRQf0cLug+ZJZJyAWvGuEzOatrupMYr3W1QoiZNXr9qmA5QtGQxHxuXm+3oLo5G2FOtqEACnFzt1oO+gfXNpZ3KbbtxkvdCVNKVtDuMN0hl7sSStaFnB2OQLvM85CeI0XqKXMCcg9wUmNFMyA8qLNz0vObP3EkkFreOBJHVGK4jEwpKzaFCDT5mSni6oPwWI8v4AcrTVqVkz83JHtlqTabDiwfhvDttYv/LnXOnzIZuAXIIbTla8AU9aRW3PW95TSwHD/yxFUT0e7Oz9m96y3CczNQzhoPcnej5R74zwd41JlN+tnXn3B9L8uwoGpd4Atdvn/Lvo/av39C7KAlsd1XUl9uO/PjFPEG1G0HV+MiATTF62egHQ/HZ1ErgJDph+8Y5IymTdXtdfZNLT4kBMsfXPorvn+0kgKNTiVRCJDTgPEIYaj4OlyMkSIlxLyplCmbdFlCH10XGoErPhUoazdWbcizYKYTn1nY/WyPHrh3zx68zNlmfA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTMyRHAzWHZtVGFpQmtqcUpIbllRV3dGSDhzMWFKOXlIRVpNZkgrQnc0eisz?=
 =?utf-8?B?N2lxY1lwNFNNVUNvb01vL3NNaHZxQXhJRC95UVhmb0ZIMVU5d3h0NVlyQ2Zn?=
 =?utf-8?B?SmlCazFhY2ZzOUFIK3pCeFVaUmU4aEp0QXpSb1phcnMveUp4TWM3L2F3emxO?=
 =?utf-8?B?NkdVQittdDIrbUZsRmpLVWhIczRDaUJFOXI4ZHg1c0ZDM1E5ampQQWJtV2d0?=
 =?utf-8?B?RHprWUJtVFJWdUI0M2J0bkduQU00T3N4SGlZQWo3elg4M1ovYTFUN3pMVlN2?=
 =?utf-8?B?ckZ4MHlRaEwvNnhpT0F6VnBaQlo1bFRxaEtnL091dS9veGRkK1p3RjBLaDdU?=
 =?utf-8?B?dVpTZzh1aUppRVBzSTFJSnorZFRyRnVXeWNkb1YvT3Z1cmRKcTZLcWl1Ujcx?=
 =?utf-8?B?S3NSaVJDYTFncUtjUVhSdlM5c0MrbS82Wk5PaW9RbUxON3Z0UTJlWmZXalVu?=
 =?utf-8?B?WkNneGo4eSt0V0lqbis1cE8xaGd1VGE3WHVhVHJhTTg4MlZBOXBFWk1hRXVa?=
 =?utf-8?B?dlRLbjlJejU3RVJqby9lQ0RpUzNjUGs4UjA5WVNLRjIvMGNyNHF2SFNRbVNX?=
 =?utf-8?B?RGs5SWQ1cXhIVXpValJtdlJGc3hTWjl4bEt1NnIzbjlRbUZ2ZTRIb3l3SW85?=
 =?utf-8?B?ZDdua0o2WGhhcy9wczNRTWJ0aUxOaDBNYnlHRGdpRzd2TXFLZzAyUDVBcU1x?=
 =?utf-8?B?R3J2VXptOWtLVDArQkp0ZnlmOVRMUG56Q2NRV0NvcXNITmlqWGhJZW1hTEZm?=
 =?utf-8?B?SXJaKzdHdVJsZWNkMjhkajIzLzlNT3ZsaCtWZndVbERkOG43MVErQ1JESEds?=
 =?utf-8?B?N3lKSGhnL1k4UFNDcm9DdHJqblU4bUdWUXlXdlIzY1ZjaGhrRkxMUVRMSXJK?=
 =?utf-8?B?Z1NXS0VKR3lXN2xnL0JuZURqMG5jdXZrUjlyYXk5SWtDdEZNeTB2dlVJMTAy?=
 =?utf-8?B?OUEyV3lMWmx1MTdScnNHeHJ6OEdOZ3JZV0JQS0NFZGdTWXI1aVVNcWlLRW95?=
 =?utf-8?B?eVNhZ0NBclh1bDdOUzJGNE9jYjlpZFgrWGxPbktkNXI3T2lCRzVTam9IeHJ4?=
 =?utf-8?B?UDNzbVpLNjl2UkhzbzVRVlBnSjhZRmxYemIzenFjQ0FyMHlxZXpqZE5DblZE?=
 =?utf-8?B?Smk3S2Z3VWRlbWRLRG9WellUSGFHemh2U3c2RE5EZlJmVGF0cWtROTIxSlYx?=
 =?utf-8?B?ckhzQ2J0SHJGam0zNmpaTUVUOHdLenlGeWRIc096QmlxQXlpNkY5cngybm1s?=
 =?utf-8?B?aUVOdTZ0UHZkL1NrTkttUW80ajAxemc0NXJrSERXUXRTNzJDemFOeDY5R2NP?=
 =?utf-8?B?K1l1c3hsZzcxYjI5c3lIUkFFMkVHRnZYYkpYY3VlTHVSTGZPQ245WExYZFRM?=
 =?utf-8?B?N0Z0TFpza1JMV0d3T1hpZHgzbGdyODZVdmpOY2NXdFlkRnN1TStxZzBXVlFj?=
 =?utf-8?B?KzJvUitPMXNSZENJUlkwZnNDWW5RUDFTMXJmOW80L0dDZFlodjYyY2dkL2c5?=
 =?utf-8?B?VnhHNnZ0aTlhTjB1dlJ1dGQvV3p1dUxVaHFOMnE0WFNwZmk2d3U2cVk2b0lU?=
 =?utf-8?B?UWJJWlcwMmxZK0F0cjJZRzdVSzB1bm42VkRCbWNvUDBxZi9VbEFWVXdhb25X?=
 =?utf-8?B?Mm0wKzdIcndLWnNKUDlRcDRhdFlnTWVMdllJcUpPb2EydGlpanlCU0J2L1NC?=
 =?utf-8?B?RlJ5RzhPNjZ1Y3pvZmRCVk9SSjQ0djhhS2ExZWhTRE1SRlpmdWJUNDJWS21o?=
 =?utf-8?Q?K45WFQ7wmcAPw+UMng=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f10553-9341-4b45-31e6-08dce83585dd
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 07:39:36.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P190MB0730



On 10/8/24 05:05, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Karol Kosik <k.kosik@outlook.com>
> 
> [ Upstream commit 6aa8700150f7dc62f60b4cf5b1624e2e3d9ed78e ]
> 
> Registering Numark Party Mix II fails with error 'bogus bTerminalLink 1'.
> The problem stems from the driver not being able to find input/output
> terminals required to configure audio streaming. The information about
> those terminals is stored in AudioControl Interface. Numark device
> contains 2 AudioControl Interfaces and the driver checks only one of them.

Please postpone (or skip) merging my patch to 6.6 due to regression.

I'm sorry for the disruption caused by this commit. Fix for this problem will be sent
for review shortly, after I re-run all tests, and I aim to get it into 6.12-rc3.

Regards,
Karol Kosik
