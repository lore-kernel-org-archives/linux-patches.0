Received: from ZRZP278CU001.outbound.protection.outlook.com (mail-switzerlandnorthazolkn19011024.outbound.protection.outlook.com [52.103.55.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA337204A
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 19:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.55.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204765; cv=fail; b=gLXo1M6o7VvK8EKL7UqIystlPdUJTWKiixRPljbTeZVCyZmuaG4whN5FSOO0YeN9BrguqZ/MRGNLDMC46LdvClshmm7dfqY40J34Q0wB/doS7yzW9F4vkEw4aMg6dc7fGMsn9Qvehf+utJYd3Vdc3jAojsMsiZm/Vq97MneZI8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204765; c=relaxed/simple;
	bh=qSpoTB0vmJqiuYBG/791DpMhud3bQWif0ihh1jpLDTA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ivCXmWID2YWREdAY0Maw0ODYC5Lg95MRdp92ZRfKct67oPXeXMjdTOgSzY4Kzu039msqBLc+PgssADIidPuuZ2mUEDe8Gr34HoI6hfjaVN1kAFKYvDR8BOroaGX5BewfM+D83dM7t7En22cnbGGXhasfY6IlTEm12OgyzZj90V0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=outlook.de; spf=pass smtp.mailfrom=outlook.de; dkim=pass (2048-bit key) header.d=OUTLOOK.DE header.i=@OUTLOOK.DE header.b=XEvgRzHQ; arc=fail smtp.client-ip=52.103.55.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=outlook.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=OUTLOOK.DE header.i=@OUTLOOK.DE header.b="XEvgRzHQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uk47K4zVPDDtec2Fn/DcqIRsKS2rgGeSjeQ6yHzIpUGxQHnSdElYd152y1WXL64NzIKPi+2CO2AUZwu7wOb66Eq7wyVqZucHlC72Cesv+Ywt25TVA/7xBZE9fsFFj42xMTlPVXb6m9cWpL3G1mZqAJ3Ve2R+ejDmBCvPVFokkSTUa4mMZj8R16gfZyYgfcfKkkXeeQy39AtyqzxJvESM/z8yKtLm/+jh9Kmb3CDmc2JkoK2v6TfA+hgmfCyI/4wt846IusufIp4tfzpG2crwm8mCOQnM2fYRMHNpd6DnBA8WhWEdcpV5eH3sijJyUnjyZ+jZiAva/Kb3SrO5wOeLVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEQCTujUeur+FvOP8pCgPy3vaNS+D5ccOYEDdJdm9WQ=;
 b=NjIs4tgtbg3B8Vl6hZEbEEA5gJXJA0fQe8544bvUx8D//KrsNRmEgUUi/A2SUpAvZejx4RbJBSJ6h+G+A+5YfaOMeUuzpcg3YMWgWFyC+5GiV7pEpR2XbBEunwOSMRxbrdXSdKbEDWvibOqz3UYAbnMBx1e+OLx0J4I93pRSk/V7/7IaTg2p5HQMPWlkaka51A60E8pvHHI5RzMZOosRWC3x+42vXd760DYlntV+M0lp5Ga3Rd8Gtz/9A9I+jtojM40P43r0mGwO4brcf1GdlQB5YRN9iRuYRwUroa5OTYYxrYXh96iugtR0OmV/Yd09qdJCSdu1k4yfKHI/ygAMFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.DE;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEQCTujUeur+FvOP8pCgPy3vaNS+D5ccOYEDdJdm9WQ=;
 b=XEvgRzHQgV4NKgDE4yKPNdUWpqhk45d+pTZuMq6aIjUSU5rGPqZEG9DNP3Wboqzk7i447NVR56xCdoq6f5HLdRsPNSR2XivITFql3bckH40wYmtmAb/WgVDA+Ogq68MwyqdBXWr+lh4hMU4/70KujXYhO7YRyvgm2nBhnjVM6IxaX3RS2gyuPQFRb+6vLMqBRSMBOmaoMQSOwt97nzjVNHPlZWs5Yu/S+zNHGZcFQAjAT72o5HSHqfJM5Odl7wEfEL5DfOGYpD6nj3/QXuTdyrAK99PHVKtEFcEOf8EO2V0aqi0kuN0/PWbhe/P6lHL61ZU/VOWCvgLZ9QvSCdgtog==
Received: from GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:6d::20)
 by ZRH2PFFACDFBD91.CHEP278.PROD.OUTLOOK.COM (2603:10a6:918::231) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 19:32:38 +0000
Received: from GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM
 ([fe80::b016:f6d4:f122:deee]) by GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM
 ([fe80::b016:f6d4:f122:deee%4]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:32:38 +0000
Message-ID:
 <GV0P278MB17776D742D3B76BD758F8A8FB1A92@GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM>
Date: Mon, 31 Aug 2026 21:32:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.18] ALSA: hda/tas2781: clear cali_data.total_sz
 when calibration read fails
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Philipp Oster <philippdev5396@outlook.de>, Takashi Iwai <tiwai@suse.de>,
 shenghao-ding@ti.com, kevin-lu@ti.com, baojun.xu@ti.com, sen@ti.com,
 perex@perex.cz, tiwai@suse.com, linux-sound@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-380-sashal@kernel.org>
Content-Language: en-US
From: Philipp Oster <philipp-oster.05@outlook.de>
In-Reply-To: <20260831133314.4125787-380-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::15) To GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:6d::20)
X-Microsoft-Original-Message-ID:
 <12863b1a-c24e-475b-b949-eee5ba11d2f6@outlook.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV0P278MB1777:EE_|ZRH2PFFACDFBD91:EE_
X-MS-Office365-Filtering-Correlation-Id: a8d31623-9097-4611-b7de-08df07969da3
X-MS-Exchange-SLBlob-MailProps:
	obhAqMD0nT+6TxoHw5fNkboUl/ASnSn2LmeGhYQLxU+9Aa4jbCTplNRvKtcN/qIwt5tlfzhjhCs91twFv5CcITUaIZ42cITG79g57LWWQbFmTMR4WJfukxTS1M45844Qq7CeX7gtE1HKNwuijwmGL/sjuOuI9CTSe+DwcaHY3Xzj+QmFSbeNj1k6fOLDCbhE3QTJ7NFGlPUalwRum7P66Wl38klnN1YqI3L4i4uqpO2PpcvLZ9FFCoT3WJqQx7zoQpg8qEzfkw06qfP/59f2EDnJIU+Sslx4c1+l+10ZWKlcQ88sUhAe2vDJtCCOxGvzcIAON6VThRRV1Z72/B0ntOY8YhQgEmYXCACNS/C0EeFXAiIhtdKNNS68lOmQeWBYZ7+/uPJbYmLVPgNikOI/1RWM+XrWan9Xkf/pMRpbhz2SCTYPYOyY4btgq/VEGnDyDL2pxlVGSi0Qv1rHh6xMqYvep0c3IJuKYCE5pTEna7aazd0NapyptoGOFdoi3NGZpN8kJ2PU5ZT+MXQW1jZ9JdePiuGoshgHXdyZylX+ezDlyZ9vCkv+8o7aqyis89bPzVhKwNvv2Ip2YS2Gr56IBHncM4NRwRlT6WtJxHJPvcr4y+0zPAFo7raISERol7PyrVy1PmXkbjW/FIwGaW2UvUnnR9QJZ/IZlDWVWmaun8OHUJov8SR8rmutbcCeFxmbD5Bx0IC8NpBHgd6PLaqs8prR/fGT6uJx3VSuxJJG79tKgxCrtrTklcQwPFQFYNY8RxBFgA1En+fkuQ/bj82CHGUECYGYjsy0H/gql5vIu2OsMK56jy8jCM3cgGMg3XjD
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|19110799012|23021999003|25031999004|39105399006|24021099003|15080799012|41001999006|6090799003|4140399003|25010399006|5072599009|40105399003|41105399003|1602099012|10035399007|18071099003|2607281247196008|12091999003|56899033|3412199025|440099028|4302099013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFpLSDdnbWhxbmpzQXB1NjFEcStOYW45bGdMVXUxdE5KeVJPU3NtY2JtZ0wy?=
 =?utf-8?B?ZzhvTlNva2dvSXkvdzBpN0lJQnZEdGl4dFJ5RHBmRXAyQ2c5Mlo3Vytad2RI?=
 =?utf-8?B?SWZVV2dJOHZYV2VoUHVTV3BQNGExWXY3SmdySXoxOHpzZ00xN0N5TEc1ZnJw?=
 =?utf-8?B?V2Q5WTBhTzhvNS9rZzlkeDNIbkNZTUYrakJmS05IOUpXc0NRS0UzQjNWMTR5?=
 =?utf-8?B?Mm9JemNLKzV6Vi9MWE1zajlzWlhJb0E2d2RXNy9hTVFCcnRRaGd1WmtNN2p3?=
 =?utf-8?B?N1l6aTFjZ2ZVKzg1MlIyeE96Q3grRkgrY1p6SlVZQk9VbDR2UUphazBKL2Zu?=
 =?utf-8?B?ekJmWFhtQnFMa1BHREdrTHNpSjhjeHhPTnZvc3ZnK0x3UTFRNXZGbEM4dTNn?=
 =?utf-8?B?Kzh1Q01raEpGVlpMaVp2WE5ZZmY0T29wSnM3UUx3VHJqZ2kzejVSNlF4ZG9O?=
 =?utf-8?B?U1QzTjF0Mnc5T2F4TW5CbW54ZEpNaGpGS3hvSHNFMHl2OTJ5WmJGNDdsb052?=
 =?utf-8?B?OFd4d0ErOUVCL2xvRFhPY0J0MGNHaStRVHJvM1REbi9HejZ0TnF0amt3RVV5?=
 =?utf-8?B?b1JISEtRQndUSVl4d1ZTbUJyelZtd00yWnZ0MVVsbUZBcWlER1NpNkFNcGhV?=
 =?utf-8?B?QURHQ1VEQ2tjMFNxQWZnTloxN3ducHE5aFZBUE15K1dhalp3NkhnOGFoYnZr?=
 =?utf-8?B?MEdVT1pRdzBIQUhFcTM3K1F1c1hqU3pUSUQyQk9LbkRvNkJ5ZUdBWE93Nkx1?=
 =?utf-8?B?d0dZT3NLU1d1aXB0dVRNQWp2SmtuejJnRVlaR3hMY091ODB0N0lPdmZjNUhy?=
 =?utf-8?B?Y25jcWpoc0s3U1U2THdOdnJXeFBFQTg0RmNjQWJvZUNURW1zT2wrNCtWblR0?=
 =?utf-8?B?a0pLMWdhSXRJLzU1SWRielJMV2FMeUtxVUJzUUt3V3VVU3hUOWp4MVFnTFdw?=
 =?utf-8?B?bHFnQ0JJancyMGZPdHlqQktFNmxBa3VVZXM3clVuMjcvcGk2Y0ZDVG5GWllj?=
 =?utf-8?B?YXp0NmhwQzVrVlBuY3VnSUo0MmZDR3FUU2t0Z2h2Zyt4a3dxUU9tc3h1ejJv?=
 =?utf-8?B?TEtvbmptcllkSU9qUVQ1dWZnV3h4RGNZbU9yM3VQWkIyWDNIajBvc244eEhj?=
 =?utf-8?B?Ny8waDg0dTg4NW8zVG9JRElWdUZrbnNMNXo1MDNCNG1OcEFzYUh5SXA2K1dH?=
 =?utf-8?B?SEhIN2EyaTRtUzI2UE5NUWNZNlRpeXNKL09IR0NNU002ZzQ1WTVBWWQvTXRH?=
 =?utf-8?B?Zmhqc2J1VExFT3lsOWdGczJCMkk4KzZXbnJXYlRGTU1zdEg2R2VocFJCbi91?=
 =?utf-8?B?RE53U2g3ZDFGZmJGano4Vnk0ZVRXRk45R0pPYlJNdzh2ckxRemdEOHRQc1ZV?=
 =?utf-8?B?cm5GUmhuN2x2V3BidDY2bHhFTURtOGJGMFB6RXVHMXdiRmFEc29XVHN1KzFj?=
 =?utf-8?B?Z3B4VXp0Z0t2a25VNGZzbXJmK3V6WnhZT2poei8yZlZicDlWYjJwQWw2ZG5Y?=
 =?utf-8?B?S2FtTUQrd2JqSjhNSmFqZ1M0K25ZWEZ3eTN0VjVDRjB1Zno3eVp6UkpDQmdx?=
 =?utf-8?Q?GNwx7O9/VVsipCtE4Q/DvayXk=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTgxdmlXK1U3ZE5MMG51dTRGRS9tcFBBOXg1SFQ4OXNjbStnTzJrbmtrMG1K?=
 =?utf-8?B?QkxzYVFhcG5kSUUweDdvWHBIOUFtSDljZ0JFRzhSR0YrTUEvd2plT09RdXdN?=
 =?utf-8?B?MDN0Z3Awc0M4ZStPZHFZRVZpRkRyQ0l3OU84Y1dOVGhZaWszWlcvbFcvSE1P?=
 =?utf-8?B?MDE2VlI3SDJIQ0crN3I1c0c5ZXhRR1N4d3dHQkZqd21DbDVtYmNxd3ozUjR5?=
 =?utf-8?B?M2xHeHZiZE1OYmtQNFdWUGhUT0ZJYVYyZllMT29mdmZYd3FxYjZoTDBycUk5?=
 =?utf-8?B?SzFHZEFIckhsQmE2NmIyZ1RjVkFpSUIzcDlZcUpTaHlhK0xjQTliSTl5TmdV?=
 =?utf-8?B?YWZKMDdoeXo2Z21Idit0Y1NEM3JMOEt4aXE4OUtCN2JDQll5SGZGUURNcWdH?=
 =?utf-8?B?ZDBiemxVUExQSWpVb2V3TEwyT09rYUYrRVBGV0xnSm5ZRDYwb0VYWU14TGlS?=
 =?utf-8?B?L1Y1T2JtWWxoN3RuNGJXcEpLeUQ3ZlBWeVBaUFN0MHVrNm1SRi9oUUltcGNS?=
 =?utf-8?B?TVZodzBBY0ZGblRheldFL1BYMlI0aVNqcEZ4V3YrUmt1OERtV05oazRJVWZu?=
 =?utf-8?B?US9HenRpT3RSTkI4OG5sWElCYUtmYzBRLzJQN1QyS0t0dVF2UDAyTktGOVNj?=
 =?utf-8?B?b21KYVpJUTdPa28vMUNJWVUwMkNRVE5HRU04cWsxV1BHeGFqSjYyVmJuTDN6?=
 =?utf-8?B?SzBVTi9lN3JJVVFuL1FibVNvMXdXWllmVHdaNlB1ZzE5MmIrWDY0c2toTHpm?=
 =?utf-8?B?cDlxY21wQWFjSHl6alo1ek9PaDJGUEFnRjRmbGZqRERyMFQ3NHUzVExKdHd0?=
 =?utf-8?B?MXBwb09ZbEQ1RzBaOGNvRDkwQU5mR2EvZkJsSUtyazJzRzRoRFJtTVk4blUv?=
 =?utf-8?B?c0MxOTBrdzFLWTVtS3pZOU1QbU9XR0puYXNabUF3T2JtQmZMM25sODF1Rzkw?=
 =?utf-8?B?cnB5UGRBUDJUaXVKY2swM0lOeENGWGxhWDJrMkQxS2JLdVZpZGVNQjdmckxv?=
 =?utf-8?B?Q0RJNlpXS040SlRhK0I0S2ZLT3pBMDA4N1c3blJIMW1rd3Y3ZnNLRTRsNE5o?=
 =?utf-8?B?R1l5Y204WDQwTEVMZmFFdmw0MXcvdkhZNzM2cmpCZlI3UHB5SDgzTHk2aHJH?=
 =?utf-8?B?MENkZFUyK0FRbzFCU0tUQjlxSENabW1zWGNObTlyWHhZSnQ5K2Nlbm9YQ0Ni?=
 =?utf-8?B?YndIM2pjWXJlNkQvakJnVHRWZlk1UXJibmNwZ0o1RldoVnBwZkV3Q29KUy9h?=
 =?utf-8?B?eDdhdXJpNnBqUkU3dko3RE9PY1I0L2RsMlQyYjEzQU9TWkgvbHZMK3hUbm9l?=
 =?utf-8?B?S3lrOEZ4aG9UTnV6NHY2dHMvUWdpKzlpQ1ZTeXg2RmUraGNqUm9vbVozU3dI?=
 =?utf-8?B?M3piUGZDaFdkclV4ZVBKZDkveWFQSngwZkwwQzJqcWZ0cHI3b2NMM1FhQnlY?=
 =?utf-8?B?dWtUcUVBdkxvcFg5ZkpXU1d4VCtvV050alFBWTdFSzZHZkQzT1ZMZWFlaUFF?=
 =?utf-8?B?K0dOVVJuRVVSRkFKQ0MyOVFmaTFaT2tOWllPdEI4ZnFwL0tEQU1aMlJMbTVW?=
 =?utf-8?B?R1Vva1JqUnhzamFJdFlYT1ZZWktTZm5VR1pQY2FuUkU1Q3NSamZnMTg4UUQr?=
 =?utf-8?B?SkgzdnJOV29URVBTZmEreDVWUVF4Y3ZhQXhJY3UyZWw3Z1FENE1TV25SVm13?=
 =?utf-8?B?R1FOTWRCWGRrZzJ2U296OU1OR2xvQWFhaXlaMDRSN2tjeXA4MjRzdkN0VWZk?=
 =?utf-8?B?NG5jRnd2SE02REdkQm5FQTV0MUxFNVBaR0dmNWdLVTRnMXFjRUhPNENBZzg0?=
 =?utf-8?B?QlIvTlhzWXpNV3pVQW1ITVBZbEJzMFdyM3RVVXkyYnd1YVpqbHVaM3FjZ1Uw?=
 =?utf-8?B?THlhaC84Nk04OE8rMW9EM08yeGFlT2loM2hyN3Q5UEhMUUZ2c2NCMkk5WU11?=
 =?utf-8?B?Y1BBMVM0YWQ5cEZ5cjlMMmpYN1IxdjlzR0drWFJncTVEZDNrbmZuZ3RuN20w?=
 =?utf-8?B?aVdkSkQ1V3lnPT0=?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-b8459.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d31623-9097-4611-b7de-08df07969da3
X-MS-Exchange-CrossTenant-AuthSource: GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:32:38.3293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRH2PFFACDFBD91

Author here — the backport looks correct to me, please take it.

The fix was developed and tested on a Lenovo Yoga 7 14ARB7 (two TAS2563 on
I2C, ACPI INT8866) whose factory calibration was never written to UEFI, so
tas2563_save_calibration() hits the EFI_NOT_FOUND path on every boot.

I re-verified today that the bug is still live in shipping stable kernels:
with the stock module from Fedora's 7.1.8 kernel the woofers stay silent,
and with the same module rebuilt with this patch all four speakers play.
I have had to carry this as an out-of-tree rebuild across seven kernel
updates since July, so the backport is very welcome here.

One practical note for anyone hitting this: the bad state persists in the
amplifier registers, so swapping back to a fixed module at runtime is not
enough — the machine needs a reboot to reinitialise the TAS2563s.

Thanks,
Philipp

Am 31.08.26 um 15:26 schrieb Sasha Levin:
> From: Philipp Oster <philippdev5396@outlook.de>
>
> [ Upstream commit b6016332b8899a9775addf9b630b0a53a849c8ed ]
>
> tas2563_save_calibration() assigns cali_data.total_sz before it reads the
> per-device calibration data from EFI, but its error paths return without
> clearing it again. cali_data.cali_reg_array is left all zero, because the
> function returns before the register addresses are assigned.
>
> On the first playback tasdev_load_calibrated_data() does
>
> 	if (!data || !cali_data->total_sz)
> 		return;
>
> which passes, since total_sz is still non-zero. It then issues five
> 4-byte bulk writes to p->r0_reg, p->r0_low_reg, p->invr0_reg, p->pow_reg
> and p->tlimit_reg, all of which are 0. Register 0 decodes to book 0 /
> page 0 / register 0x00, so the auto-incrementing block write zeroes
> registers 0x00 to 0x03. Register 0x03 is PB_CFG1, which holds AMP_LEVEL,
> so the amplifier gain is set to its minimum and the speaker stays silent.
>
> This is reproducible on a Lenovo Yoga 7 14ARB7 (two TAS2563 on I2C,
> ACPI INT8866) whose factory calibration was never written to UEFI, so the
> EFI read fails with EFI_NOT_FOUND. The two woofers driven by the
> amplifiers are silent while the tweeters driven directly by the ALC287
> play. Reading the amplifier registers over i2c shows PWR_CTL = 0x00
> (active) and the TDM slots correctly programmed by the RCA profile, but
> PB_CFG1 = 0x00. With this change PB_CFG1 keeps its power-on default of
> 0x20 and both woofers play.
>
> tas2781_save_calibration() in tas2781_hda.c already clears total_sz on
> failure; do the same for the TAS2563 variant.
>
> Signed-off-by: Philipp Oster <philippdev5396@outlook.de>
> Link: https://patch.msgid.link/20260720-tas2781-calfix-v1-1-3a5fa6ad90bc@outlook.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> LLM Generated explanations, may be completely bogus:
>
> # Stable Backport Analysis: ALSA hda/tas2781 calibration `total_sz` fix
>
> **Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`)
>
> ---
>
> ## PHASE 1: COMMIT MESSAGE FORENSICS
>
> ### Step 1.1: Subject line
> **Record:** `[ALSA: hda/tas2781]` `[clear]` — clear stale
> `cali_data.total_sz` on TAS2563 EFI calibration read failure.
>
> ### Step 1.2: Tags
> **Record:**
> - **Signed-off-by:** Philipp Oster `<philippdev5396@outlook.de>`
>    (author)
> - **Link:** `https://patch.msgid.link/20260720-tas2781-calfix-v1-1-
>    3a5fa6ad90bc@outlook.de`
> - **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
> - No `Fixes:`, `Cc: stable`, `Reported-by:`, `Tested-by:`, `Reviewed-
>    by:`
>
> Notable: maintainer merge, detailed hardware reproduction, no
> syzbot/fuzzer signal.
>
> ### Step 1.3: Body analysis
> **Record:**
> - **Bug:** `tas2563_save_calibration()` sets `cd->total_sz` before EFI
>    reads; error paths return without clearing it. `cali_reg_array` stays
>    zero because register addresses are assigned only on success.
> - **Symptom:** On first playback, bogus bulk writes to register 0 zero
>    `PB_CFG1` (AMP_LEVEL); woofers silent, tweeters (ALC287) still work.
> - **Trigger:** Lenovo Yoga 7 14ARB7 (two TAS2563/INT8866), factory
>    calibration absent from UEFI (`EFI_NOT_FOUND`).
> - **Root cause (author):** Stale non-zero `total_sz` makes downstream
>    calibration load proceed with zero register addresses and zeroed data.
> - **Precedent:** `tas2781_save_calibration()` already clears `total_sz`
>    on failure.
>
> ### Step 1.4: Hidden bug fix?
> **Record:** Yes — explicit functional bug fix disguised as a small
> error-path correction. Not cosmetic cleanup.
>
> ---
>
> ## PHASE 2: DIFF ANALYSIS
>
> ### Step 2.1: Inventory
> **Record:**
> - **File:** `sound/hda/codecs/side-codecs/tas2781_hda_i2c.c` (+3 lines)
> - **Function:** `tas2563_save_calibration()`
> - **Scope:** Single-file, surgical (3 error paths)
>
> ### Step 2.2: Code flow per hunk
> **Record:**
> | Hunk | Before | After |
> |------|--------|-------|
> | snprintf failure | `return -EINVAL` with stale `total_sz` |
> `cd->total_sz = 0; return -EINVAL` |
> | EFI `get_variable` failure | same | same fix |
> | `total_sz != offset` mismatch | same | same fix |
>
> Normal success path unchanged; `is_user_space_calidata = true` and
> register assignment still only on success.
>
> ### Step 2.3: Bug mechanism
> **Record:** **Logic / state-consistency bug** — invalid calibration
> state (`total_sz > 0`, zero `cali_reg_array`, zeroed `data`) left after
> partial EFI read failure. Downstream `tasdev_load_calibrated_data()` can
> issue bulk writes to register address 0, corrupting `PB_CFG1`.
>
> **Note:** Commit message cites `if (!data || !cali_data->total_sz)
> return;` in `tasdev_load_calibrated_data()`. That exact guard is **not
> present** in this 6.18.44 tree; the user-space calibration path is gated
> by `is_user_space_calidata`. The failure mode is still plausible if
> `is_user_space_calidata` is true with unset registers, or if related
> mainline logic differs. The `total_sz = 0` cleanup matches the
> established `tas2781_save_calibration()` pattern regardless.
>
> ### Step 2.4: Fix quality
> **Record:** Obviously correct, minimal, mirrors existing
> `tas2781_save_calibration()` behavior (`tas2781_hda.c:228-230`). Very
> low regression risk.
>
> ---
>
> ## PHASE 3: GIT HISTORY
>
> ### Step 3.1: Blame
> **Record:** Buggy `tas2563_save_calibration()` present since file
> introduction at merge `5d324e5159d9e` (6.18-rc8 era). `git blame` shows
> error paths never cleared `total_sz`.
>
> ### Step 3.2: Fixes: tag
> **Record:** N/A — no `Fixes:` tag.
>
> ### Step 3.3: Related file history
> **Record:** Related stable commits in this tree:
> - `819268882628f` — skip UEFI calibration quirk (ASUS ROG Xbox Ally X)
> - `00d880c469b75` — TAS2563 `speaker_id` init fix (Yoga 7 class
>    hardware)
> - `3646c928bb77c` — speaker ID retrieval refactor
>
> Standalone fix; not part of a multi-patch series.
>
> ### Step 3.4: Author
> **Record:** Philipp Oster — first-time contributor to this subsystem in
> this tree; patch merged by Takashi Iwai.
>
> ### Step 3.5: Dependencies
> **Record:** None. Applies standalone to `tas2563_save_calibration()`
> only.
>
> ---
>
> ## PHASE 4: MAILING LIST / EXTERNAL RESEARCH
>
> ### Step 4.1–4.5
> **Record:**
> - `b4 dig` without commit hash failed (no commit in tree yet).
> - Lore/patch.msgid.link blocked (Anubis 403 / bot protection).
> - Could not retrieve review thread or stable nominations from lore.
>
> **Inferred from commit:** Hardware-tested on Lenovo Yoga 7 14ARB7;
> maintainer (Iwai) merged.
>
> ---
>
> ## PHASE 5: CODE SEMANTIC ANALYSIS
>
> ### Step 5.1: Key functions
> **Record:** `tas2563_save_calibration()`,
> `tasdev_load_calibrated_data()`, `tasdevice_dev_bulk_write()`
>
> ### Step 5.2: Callers
> **Record:**
> - `tas2563_save_calibration` → called from `tasdevice_dspfw_init()` via
>    `hda_priv->save_calibration()` (return value **ignored**)
> - `tasdev_load_calibrated_data` → called from
>    `tasdevice_select_tuningprm_cfg()` on first DSP config load during
>    playback
>
> ### Step 5.3: Callees
> **Record:** `efi.get_variable()`, `devm_kzalloc()`,
> `tasdevice_dev_bulk_write()` / `regmap_bulk_write()`
>
> ### Step 5.4: Reachability
> **Record:** Triggered at audio init/playback on machines using TAS2563
> HDA path (INT8866 ACPI). Lenovo Yoga 7 14ARB7 (`0x17aa:0x3870`) is in
> this tree. User-visible without special privileges.
>
> ### Step 5.5: Similar patterns
> **Record:** `tas2781_save_calibration()` already does
> `cali_data->total_sz = 0` on EFI failure. TAS2563 variant was missing
> the same cleanup.
>
> ---
>
> ## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)
>
> ### Step 6.1: Buggy code present?
> **Record:** **Yes.** `tas2563_save_calibration()` at lines 344–388
> returns on error without clearing `total_sz`. INT8866/TAS2563 and Yoga 7
> 14ARB7 quirk present since 6.18-rc8.
>
> ### Step 6.2: Backport difficulty
> **Record:** Clean apply expected — 3 identical lines on three existing
> `return -EINVAL` paths.
>
> ### Step 6.3: Related fixes already present?
> **Record:** `tas2781_save_calibration()` already clears `total_sz` on
> failure. This specific TAS2563 fix is **not** yet in the tree.
>
> ---
>
> ## PHASE 7: SUBSYSTEM CONTEXT
>
> ### Step 7.1: Subsystem / criticality
> **Record:** `sound/hda` — TAS2781 side-codec driver. **IMPORTANT**
> (laptop audio on specific Lenovo hardware).
>
> ### Step 7.2: Activity
> **Record:** Actively maintained in 6.18.y (multiple tas2781 stable
> backports already landed).
>
> ---
>
> ## PHASE 8: IMPACT AND RISK
>
> ### Step 8.1: Who is affected
> **Record:** Users of Lenovo Yoga 7 14ARB7 and other INT8866/TAS2563 HDA
> laptops missing factory UEFI calibration data.
>
> ### Step 8.2: Trigger conditions
> **Record:** Boot + first playback when EFI calibration variables are
> absent (`EFI_NOT_FOUND`). Reproducible on affected factory configs per
> commit message.
>
> ### Step 8.3: Failure mode / severity
> **Record:** **Silent woofer speakers** (partial audio loss). **MEDIUM-
> HIGH** — not a crash or security issue, but serious functional
> regression on real hardware.
>
> ### Step 8.4: Risk vs benefit
> **Record:**
> - **Benefit:** HIGH for affected laptop users
> - **Risk:** VERY LOW (3-line error-path cleanup, established pattern)
> - **Ratio:** Strongly favors backport
>
> ---
>
> ## PHASE 9: FINAL SYNTHESIS
>
> ### Step 9.1: Evidence summary
>
> **FOR:**
> - Real, reproducible hardware bug (silent woofers on Yoga 7 14ARB7)
> - Fix mirrors proven `tas2781_save_calibration()` pattern
> - Minimal, surgical, maintainer-merged
> - Affected hardware and driver code exist in 6.18.44
> - Ignored `save_calibration()` return makes stale state especially
>    dangerous
>
> **AGAINST:**
> - Commit message references a `total_sz` guard in
>    `tasdev_load_calibrated_data()` not found in this tree (mechanism
>    partially unverified statically)
> - Lore review thread inaccessible
> - Narrow hardware scope (TAS2563 HDA + missing UEFI cal)
>
> **UNRESOLVED:** Exact static path to bulk-write-to-register-0 in 6.18.44
> without the cited guard; author hardware testing is the primary
> evidence.
>
> ### Step 9.2: Stable rules checklist
> 1. Obviously correct and tested? **PASS** — mirrors existing code;
>     hardware-tested per commit
> 2. Fixes real bug affecting users? **PASS** — silent speakers on Lenovo
>     Yoga 7 14ARB7
> 3. Important issue? **PASS** — significant functional audio failure
>     (MEDIUM-HIGH)
> 4. Small and contained? **PASS** — 3 lines, one function
> 5. No new features/APIs? **PASS**
> 6. Can apply to local tree? **PASS** — code present, clean apply
>     expected
>
> ### Step 9.3: Exception category
> **Record:** Hardware-specific driver bug fix for existing
> TAS2563/INT8866 support (similar to other tas2781 stable backports).
>
> ### Step 9.4: Decision rationale
> This is a clear omission in error handling for TAS2563 UEFI calibration
> reads. The TAS2781 variant already clears `total_sz` on failure; leaving
> it set allows corrupted amplifier register programming and silent
> woofers on laptops without factory calibration in UEFI. The fix is tiny,
> low-risk, and addresses a user-visible defect on hardware already
> supported in 6.18.44.
>
> ---
>
> ## Verification
>
> - **[Phase 1]** Parsed subject, tags, body; no syzbot/stable tags
> - **[Phase 2]** Diff: +3× `cd->total_sz = 0` in
>    `tas2563_save_calibration()` error paths
> - **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` → bug since
>    5d324e5159d9e; related tas2781 stable commits found
> - **[Phase 3]** Confirmed `tas2781_save_calibration()` clears `total_sz`
>    at `tas2781_hda.c:228-230`
> - **[Phase 4]** `b4 dig` / lore / patch.msgid.link — **BLOCKED**
>    (403/Anubis)
> - **[Phase 5]** Traced callers: `tasdevice_dspfw_init()` →
>    `save_calibration()` (ignored return); `tasdev_load_calibrated_data()`
>    → `tasdevice_select_tuningprm_cfg()`
> - **[Phase 5]** **UNVERIFIED:** `if (!data || !cali_data->total_sz)`
>    guard in `tasdev_load_calibrated_data()` — not found in 6.18.44
> - **[Phase 6]** Buggy code confirmed in tree; Yoga 7 14ARB7 quirk at
>    `alc269.c:7449`; INT8866 at `tas2781_hda_i2c.c:681-688`
> - **[Phase 6]** Fix not yet applied in tree
> - **[Phase 8]** Failure mode: silent woofers; severity MEDIUM-HIGH;
>    benefit/risk favors backport
>
> **YES**Those three background `git log -S` searches timed out or errored
> — broad history searches on this repo are slow. The needed context was
> already gathered with narrower commands:
>
> - **`tas2563_save_calibration`** and **INT8866/TAS2563 HDA support**
>    have been in the tree since the `tas2781_hda_i2c.c` introduction
>    around the 6.18-rc8 merge (`5d324e5159d9e`), confirmed via `git blame`
>    and `git show`.
> - The **Lenovo Yoga 7 14ARB7** quirk (`0x17aa:0x3870`,
>    `ALC287_FIXUP_YOGA7_14ARB7_I2C`) was also present at that same point
>    in `alc269.c`.
>
> That was enough to support the backport verdict: **YES** for 6.18.44.
>
>   sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
> index ebfc08b5fb283..ea80fd774bf24 100644
> --- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
> +++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
> @@ -356,6 +356,7 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
>   			if (ret < 0 || ret >= sizeof(var8) - 1) {
>   				dev_err(p->dev, "%s: Read %s failed\n",
>   					__func__, var8);
> +				cd->total_sz = 0;
>   				return -EINVAL;
>   			}
>   			/*
> @@ -373,6 +374,7 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
>   				dev_warn(p->dev,
>   					"Dev %d: Caldat[%d] read failed %ld\n",
>   					i, j, status);
> +				cd->total_sz = 0;
>   				return -EINVAL;
>   			}
>   			bedata = cpu_to_be32(*(uint32_t *)&data[offset]);
> @@ -384,6 +386,7 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
>   	if (cd->total_sz != offset) {
>   		dev_err(p->dev, "%s: tot_size(%lu) and offset(%u) mismatch\n",
>   			__func__, cd->total_sz, offset);
> +		cd->total_sz = 0;
>   		return -EINVAL;
>   	}
>   
