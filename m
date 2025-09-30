Received: from MA0PR01CU009.outbound.protection.outlook.com (mail-southindiaazolkn19010002.outbound.protection.outlook.com [52.103.67.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D9F25FA0F
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.67.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246133; cv=fail; b=Otl+veilahSjHdEfj6rGH5B+YToLbxsV83Z1CqJ/vZ2IPHi/KpydmCjXetOiqkhxRZCmxnBkqbNEYbsjJpPf5RJSw8lJIkOstp+FDamDA4O91EobDZRjMpAMnh2QNW1XaL1m6uZQG8+dqhk8NXGtQPJ/+oJfEVB9xwdSuSKO+ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246133; c=relaxed/simple;
	bh=QIgTCuBvzEbarJczkLMGrRKF45lAAjzSNaKWJBqqsQI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iGVu5fq7G5tVPzir75s4ixdSyLuHH+Q5AyYSE2M4u7iM8P71D9QCPwid6oAFDEdJQJTTAVYqMEbGAK+u2AYIybx2fWf7gRHpYXN2zVttjiwj07pJEK+Vanq00Ke1wVe1qv6OZTotxo1yGu99glN/F4Q0HZeAJSEJTxqz0k1V3vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=BGydBDp7; arc=fail smtp.client-ip=52.103.67.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="BGydBDp7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aiwXjF9pr4p2ue1xmSfrs1hUZ65QdhaVOE+vdeW28tDTpAZRc7Y/txTJXYGbhjFEw5gUS0oFHrX4OBNyHKllIKIZxYLsHMl/3IGruM/TDZRfKZgbgk54IymiIOsgfdASIeEdjllPO4AtURt0opDj/0l9hFI0HmmuIqZ2dHD78LHuc0cqRDbNUyJWaeCa6jfxR35b6D1DUq/18ZxMWJP6xlg2oDcNiLJ2mm4+rgH+74bHMnhkayq1ZRVWlvzlAz1AM8M7bayx+GSn90ZeVr3C+AM7DwltNf253KNAysM5mCWCQX1w1G5CnK/ssaBX0/mI2yxKaJdeeCok0wPXcBtIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIpS2fow/UiAJ/c9MqkoGAX/5OxxNnTvwv42Re168ow=;
 b=j+lcP2HYOxsKbT58FCDY0503yurXGnUS/HUQNIxMDypuhSvHmdTJZACdiLgyYtFbwx0VdKV+10R9sKPmEl3Gssk84ccEPhAgH38E04jBPTLTHRcsIL6Cvywk9WNFKZO5lmgwuyUZrxKVXc7YA/A3xBZjm4yhvMrI9pSCLoV+DMrTH9z3Ryb9GxEejT5zIJhBouXuLdSq5OT7V+FYwCUlEpTcQpSFDhOhDQxfkayYPE7lI8/fiPTZ6FogmGB9AU5dm3aOqKmu5KzE/XKeZ9r1yce22pl2mwfrbWhdqVN12vA3ROOEQFv12W1Ae+Ln3C8dXhfm8KGOEvFbLFVJESbuCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIpS2fow/UiAJ/c9MqkoGAX/5OxxNnTvwv42Re168ow=;
 b=BGydBDp7QhQ2sntu/3Cv4rp1veLUtHUCFgsfxLsoBZ049/j+24zD3E5xhZaNCu3l1q4iaxkyXC9taENP+kYUd57wD9jTS43mWOuclJYDwcQeESmgzGuwukJgKPDGgvnDAoou94UbLcTG0dExFxsgwuDEbTEPd1RgN5QU+y+Gt+3WGbGkZKglX/CmBnXyMzzaMCOcRpIcKyCc3LHe2WcMy9OzlPAwda5KbDAuTzsIEId/cwZ3N1cq7LGh1BW33YN9Bmtwqt1ZrwzguYPWFLfo1aq6UYr3gNgZs+Rh66Kz/h6Cy/UoUaOuD3KI1i39pLJXe46ZXc8WLGaTbtXNUjHEDA==
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18) by PN2PR01MB10190.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:1f2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 15:28:35 +0000
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::418:72df:21ec:64ff]) by MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::418:72df:21ec:64ff%6]) with mapi id 15.20.9160.008; Tue, 30 Sep 2025
 15:28:35 +0000
Message-ID:
 <MAUPR01MB11546532BF910CEA7CF054BE2B81AA@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
Date: Tue, 30 Sep 2025 20:57:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 11/89] HID: multitouch: support getting the tip state
 from HID_DG_TOUCH fields in Apple Touch Bar
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Benjamin Tissoires <bentiss@kernel.org>,
 Kerem Karabay <kekrby@gmail.com>, Jiri Kosina <jkosina@suse.com>,
 Sasha Levin <sashal@kernel.org>
References: <20250930143821.852512002@linuxfoundation.org>
 <20250930143822.336923936@linuxfoundation.org>
Content-Language: en-US
From: Aditya Garg <gargaditya08@live.com>
In-Reply-To: <20250930143822.336923936@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0028.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:178::6) To MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18)
X-Microsoft-Original-Message-ID:
 <6d25533b-13d6-4aec-a0dc-7cf57283c209@live.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MAUPR01MB11546:EE_|PN2PR01MB10190:EE_
X-MS-Office365-Filtering-Correlation-Id: c5fbb107-f0d1-4e4b-6b25-08de00360592
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|8060799015|461199028|5072599009|6090799003|41001999006|15080799012|23021999003|40105399003|440099028|3412199025|4302099013|10035399007|1602099012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlNXUllWTTBvcmxoWUZhTWl1UmV1N0N3SnR1WDNGejUrY0FFYXllbzZzVnhl?=
 =?utf-8?B?Tlp4UmdUbGVoTUJYN0NFam1iendoZThqcm1UMVpOZGZMc3ViYXA2MFJ5L3dk?=
 =?utf-8?B?Sy9WZW95ZkNoQzJ2UzhsMTc2clpCT3NETWNkZGVoL2laR2RHa0VUYU5MNXo1?=
 =?utf-8?B?M3hUcEJyOXkvNDUwRC9tdExDNFY4M3N5YTZUQnJuQTA2aDJIWlBGeFVqZFR2?=
 =?utf-8?B?TE9QZldRbnBiS2YzL3dsVW0wMUpxdU5SNHpMTHlGVHNDNEJ3SzR0V2JkcFl4?=
 =?utf-8?B?dmxHSGR3R1RvdDdac2RZK1JickRjK0FXVUp1cnY0TlhjQzhqYVRYbWVSdGw3?=
 =?utf-8?B?U3lMMGRwZVNrdjhvMFBwZDhDeG10OTdicXdDYnU5blpSdXRCT2grMXlOUjNL?=
 =?utf-8?B?YitKOGU4NW1kbTlpRWJkQXNIZy8zL2ZkUVh6Wm5ZOU0xOWw1MjZ3bEJ5SG55?=
 =?utf-8?B?LzdSTzAvc0xVUTRuQ0J5Vk5EZmpMVUtRb2xGQmFyOGZWNUxyMUFKOW4zVUt1?=
 =?utf-8?B?S3ZjZHJDc0VObDJHcjAyV0tEQ1R3cVU0cGt2M1cweUlYKzBDNy9rYmxUUGx1?=
 =?utf-8?B?cW9QMldCMzBDYVpxUm1TcXl1UzhNWEI3N2ZFNDJvbU9BaVJtd1NRM0t2bSsy?=
 =?utf-8?B?QWJIYjFGL0thVTFIQkVrcUZYVk9zK3pRWWpBZEd1SW5xc0h1dFhBR05EbVNQ?=
 =?utf-8?B?L2xTTVZNbTNPZ0swd2tPL2QyckF6VHdLYklmQWxWYWl5RHlDM2lSOFV2OTJp?=
 =?utf-8?B?RzdnODBHdUcxTmt0c0R1dHRhbzd4Z2liODBnbXhkTkRNd2lZRTEyREZFaE5D?=
 =?utf-8?B?a1BWT0Y3disxUlVNUUNLMzdabXM2blA5WkNNQ0o2dXYzaXhiTFI1N2F4U21G?=
 =?utf-8?B?UDZMUW9zc1NqdmJISndCeFRTT1BMTHQ5dnQ4VTY1UWlVbEJWSWNiaytoS3BG?=
 =?utf-8?B?YllBOVdkaVdib0lrK3plaWE3aVY5anVWRXMwUjBFNWdhWTk5UXZ0N3NaV2Va?=
 =?utf-8?B?aEdQUHBaYldDMm4yYjN2SVNJTDdiM1hacmlCZDd0OUNxTWdXR3MvVnF2SlR1?=
 =?utf-8?B?byt0ZkpIMVpuY0EzL3JONk81L0NGb24xNmhaeXY5UFg3OGRDUTRyb1VTa2h4?=
 =?utf-8?B?UWFrRUx2SEhyK2U1TjJKMExOZEQ5bGx6VXZITm1Lbk02YVVkNzdpZ3pKc05o?=
 =?utf-8?B?aVRuT3lCeFcrSGpwbzY2eWdxblpsUmI4b09MS3NqUERuZHNFTFgrbmpMcVF5?=
 =?utf-8?B?ZkJpVEczaFIvM0RxSzJhdVNVVWtpSnlGcWF4aGtmbHlwN0REbDhUbitvMWVN?=
 =?utf-8?B?TGtHamJ5NDBCVTIxbzZtd2JTRXJROVd1M3luU2lZc0ZPNUZBRk5xYmgxMHVX?=
 =?utf-8?B?OEIweENoQkpuVDZXRzBNb2VpV0xoVFlYREw5OCt3ZmYyUzVveFlqbTdJd1U3?=
 =?utf-8?B?MHh1WjBpWUxvL3VjR0trRUFCakNadDlaVlpNdGIvMUx0cTJoVXduU0ZPemZh?=
 =?utf-8?B?Qm1wUmE0MS9xVzk4VGs3bVAzRnJFSlhLRW5DS1VtclFoWUFwYW1JeThQYUwx?=
 =?utf-8?B?UG9KQ1ozOU1QbEdnTEFMQmVDNkNwYWNUT1JwZEdWSnRwaUowRk9OaE5maE1X?=
 =?utf-8?B?OERHTndvRTgrTjVWcEZ5UTMwQ3Jlek5LQ3hUc1U0QnBZYk1sRnJJV05OVGpX?=
 =?utf-8?B?QlVLMEpQNzJ5MEVSdllkMFZCTzBzTGlXVk56TWkyTWFqaFhXSnd6Q2kvejEv?=
 =?utf-8?Q?VyNgBzaRPe26X+1Vcs=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wi9xbmR0dzhlSDdIaWxtYVZsWHUwVTU0WDE0VkN0Z0trUkN3NjlhWi81WlVt?=
 =?utf-8?B?cWRDQXBwczFNTEJqa1ZLTzJqTlRlL3hCNmNoSUNCWlN6SmsreVlnSFAvMmRP?=
 =?utf-8?B?VWk0d0YvRlpyV2tKaHEwRitTOFIwRUNLazRYZUR2eVFPOCtJUGFZK2dQWm5T?=
 =?utf-8?B?dEdEWkRNcFMxVUVGeXVKWGkyVUVVUG9KNStteHFJQWE3c3cxQThiZE5VZ0hs?=
 =?utf-8?B?UEUrTE1VbWp5b2taM1ZxYU90RmpzM2Nzd0N5THNYRzdOWFIyaXdhTWpRVVF6?=
 =?utf-8?B?TVBPR0ZqeUNQUXdaLzMwazIvR0JIem4zcUw3b3BBK3FaQnNCUGRtMHBPOERQ?=
 =?utf-8?B?d3YvWmdyak9LOUVnQ05ubjZzR3RUUzFDeHhpOFNlVmlWZUtTZmJhR3RKZFJl?=
 =?utf-8?B?QS9aZFNrdGc5K3RReWE0ZnNUam5EL2l5Y1BQM1JMYk5jenlkZWpGR0NvVjF2?=
 =?utf-8?B?SURvYitXV3ZBMVpHUWQwcW5YV3lEZG9ETk1KWjdKSFd1MW95dnluZ1hSUmNu?=
 =?utf-8?B?YnpSaCtNbWZ2NEpndHd6L3lETDE5ZEh5SGcyb3Q0T0cxai9ndTlUZytZeTI4?=
 =?utf-8?B?L2RMTlJZc05rUUlWYUV0bUg1VVpUM0JxKzhqdEU4cEtXSnUwVXNJSjY4dFNm?=
 =?utf-8?B?bEJaVXJ6SmpwRFA3bmxHVzZVMzNjTFkzRHE5VG5hRUwvVDFwdUhTd0xtMkhN?=
 =?utf-8?B?YUJaWTcyc3M3cFhjTVgxZE5XOURNZ2FmdlZ4S3ZTcC9mMDFjeXZxN2VUY1Jz?=
 =?utf-8?B?OVcvZXY4VkNGWERrS29XaE9nZjdhSk9Nc1I5VDk2WmNIa0g4SXo1dFZaMlR2?=
 =?utf-8?B?aVVOVm9MNy9HaEozTUJGLzRRUWYvQjdkcUVCUVF2QUovVUFtYzRvV0IwSy8z?=
 =?utf-8?B?Zy9LV09KdXJIV0ZBTGJVZDB1OS9CZGlPTzBmazJldG9Fa1ZPaWdXZU1SeHh4?=
 =?utf-8?B?eVhPM3pIdzE5ekJhTUdiTmFMOHF1WVNGczZFUWV3TzNVNjhXT0U0eGF3WnVo?=
 =?utf-8?B?eG9WNjFDME9VOGV3UW9nR2dZSkkrYkVNOHA0MUlBL3NyRytjdHJLcU4zMFpD?=
 =?utf-8?B?RlRkalJLMG9vUXFNdTFsdHNzbmU3WTdiZFYwZmV0MXN5bnZrOG5vb3E2MWRT?=
 =?utf-8?B?VUMwSCtjZEZycW1Ta2QxbmNNQTQ2L05YaThoK3FkT1FkdHFqQis5U0x3YUhE?=
 =?utf-8?B?bXQ1K2lkelVJbTVUQ3FJUTNiV2hIdCtlaE04MktEZCtXQ2puQitZVEs4YjJl?=
 =?utf-8?B?d3dreU5KZEtSdkNwaFpTaFRyeE1PcTBtcWFneVBuWS84aGZ5RElhbEg0RktO?=
 =?utf-8?B?d08vRUhYMkJMbWszcEF1RTlNTkxlWWczTStzWjVrVExBNTBOUkZDODZ4RmVp?=
 =?utf-8?B?YVRLdXJGcnB6UWxWeXVqRStlOUpVUlVweUYyeENsMEE0QlBuS1pNRFNUTlkr?=
 =?utf-8?B?bU5sTy8weGxQelhOUm9aN2FrSFlKaFM3b2VwMGNXTVF2ajRYRS9wYVo1UVM3?=
 =?utf-8?B?Qi9jS1ZFTXNBRlpwbExPZVJxbUMzd2RRZ1JKWnlhNStoaG5GWDUvdWhQNlZ0?=
 =?utf-8?B?a3NzcE5UYVNwbGhqMUtTMk9oWUxUaitpQmx1cGF4SFBmcGpLRVUrVEk5N2ls?=
 =?utf-8?B?UmJsTk1QeElHOS93Vy9jQ01GR3RacWhRVitMamNXMnVObjkxeFlPeWdpZWU3?=
 =?utf-8?B?bExyVDI3TWQvaStUTHpIRGxLbmdxS094SHhaZitnbzBVSlBZdUR2aW9TbXRx?=
 =?utf-8?Q?aoHehh1do2jCL78r2BXUm8WIdva6g+j8dpx+886?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-6aa33.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fbb107-f0d1-4e4b-6b25-08de00360592
X-MS-Exchange-CrossTenant-AuthSource: MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 15:28:35.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB10190



On 30/09/25 8:17 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kerem Karabay <kekrby@gmail.com>
> 
> [ Upstream commit e0976a61a543b5e03bc0d08030a0ea036ee3751d ]
> 
> In Apple Touch Bar, the tip state is contained in fields with the
> HID_DG_TOUCH usage. This feature is gated by a quirk in order to
> prevent breaking other devices, see commit c2ef8f21ea8f
> ("HID: multitouch: add support for trackpads").
> 
> Acked-by: Benjamin Tissoires <bentiss@kernel.org>
> Signed-off-by: Kerem Karabay <kekrby@gmail.com>
> Co-developed-by: Aditya Garg <gargaditya08@live.com>
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hid/hid-multitouch.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index be2bbce25b3df..39a8c6619876b 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -819,6 +819,17 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  
>  			MT_STORE_FIELD(confidence_state);
>  			return 1;
> +		case HID_DG_TOUCH:
> +			/*
> +			 * Legacy devices use TIPSWITCH and not TOUCH.
> +			 * One special case here is of the Apple Touch Bars.
> +			 * In these devices, the tip state is contained in
> +			 * fields with the HID_DG_TOUCH usage.
> +			 * Let's just ignore this field for other devices.
> +			 */
> +			if (!(cls->quirks & MT_QUIRK_APPLE_TOUCHBAR))
> +				return -1;
> +			fallthrough;
>  		case HID_DG_TIPSWITCH:
>  			if (field->application != HID_GD_SYSTEM_MULTIAXIS)
>  				input_set_capability(hi->input,
> @@ -889,10 +900,6 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  		case HID_DG_CONTACTMAX:
>  			/* contact max are global to the report */
>  			return -1;
> -		case HID_DG_TOUCH:
> -			/* Legacy devices use TIPSWITCH and not TOUCH.
> -			 * Let's just ignore this field. */
> -			return -1;
>  		}
>  		/* let hid-input decide for the others */
>  		return 0;


Same here: https://lore.kernel.org/stable/MAUPR01MB11546CD5BF3C073E67FEE70BCB81AA@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM/
