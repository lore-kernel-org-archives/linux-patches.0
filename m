Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013041.outbound.protection.outlook.com [40.107.159.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7011531E3
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 09:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672485; cv=fail; b=am2a5nIdhXJ6fRZWNjcYSLf2JiRalRYa1GbB4vQ6siTuU4/7AHOqpKK8WHUWR2urS3/m4KdxDisffm/f84Qs3qMJY2RtCgIzaSLZVXKhHn8+m6/xCo+E9DVRAUuTyiYrBYuzncEdMeJT+bV7XnMW9122uNB5aVL8VAjhD3AZclw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672485; c=relaxed/simple;
	bh=DXof64md3swRq+2Hm3YdSOSjlPQViRGZLov1zbU1m0I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n6UqSxkbNkTTCmmEUjUVdTJ2x/uZ9G/0jpa86oz6fBUVGgXcQYGGQIC9eEPEvyIH0IvFDXTBdMHx5ah6qXYdMqUJSt4Q1qIl3xPIceE3yRem9CEawkA4X9PYfTnADp9ufbIg92gZq51dEfUDbrH+EtFLnu9jNou2axG1sCGUkhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cherry.de; spf=pass smtp.mailfrom=cherry.de; dkim=pass (1024-bit key) header.d=cherry.de header.i=@cherry.de header.b=UA4R0NoR; arc=fail smtp.client-ip=40.107.159.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cherry.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherry.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cherry.de header.i=@cherry.de header.b="UA4R0NoR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQ4M+SUtoPjayz8RP/kzu/v2NwsFFwCJqwRPsuxr+bYzi8ALxmiysl7C3t2/JYc68Rip/mtRsDBukRLeiQhwWg7TyIReauZLVUE6TrZXrr78mhAQwnWJwH/3YW9K14G1Rhjqtsax2CXr54VD0K/fbWnqcSrhh9cRxqhoDMdpX4QgRjFsULoLCSxZ8XINqvdBe5oERz6A0KVHdsswru5aCV2d4kv0M1kl74U7szYqlS17uKIYu9vzrTjFVcukKhMOUZ8GiWrqSqj7XFxGUSwVfPSS0oYqxpU4Y9rsacok/Su8F3PvB1gCwXAkKLkt4ERZuA3iJPeVanzUCo+AQ6Ty2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78mvDjpv8iAUD7jiDdqcoELNyNrmk4U8ysbkNC2hGnY=;
 b=ZTYEJasZ43BfHicANFfMZ1ktMQbI3BBkC9NyPUR/vNeSuxCYsw42wvhADxpn+goaWUmX6Mu0YWFhUqRkvmKmcdboM1/iBDL2Qmptz47044J5eCvWl3bDl+wEz/m75yEPpzTqHXoRQCwDe7EMeleW4Go6HFRfQXNCFB1inMtwZ9juO+vVZe8zg9HoX/LKHEwKfM4ByFaBo4JVP5xmlM4ow6y1u3zwgvmXZDdyckCfc0G7PuoJHKcbUnQk31UEsIsUmld3meX0J0zzrBiYvN+m7bXR90uBBEvjDnA8jYY/gqT3H4TjFDl73Yad/1v7ORARlvvDDGuGORv4Sr8PAYitpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cherry.de; dmarc=pass action=none header.from=cherry.de;
 dkim=pass header.d=cherry.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cherry.de;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78mvDjpv8iAUD7jiDdqcoELNyNrmk4U8ysbkNC2hGnY=;
 b=UA4R0NoRnYbG7M5nwgYiEZpeJauXR7MQnNpotI6JmCR86hiSA1ErXzBfGe/VlqrdDYfWbfYPt90vT9jum9/Tc0W1KMmVratYJpiTaWx5na0XQ7qCHudCDY82e4V3yqXo32V6AqbwFRIuk0VR7XKnBi9a6/pH7Z3lZMW52mn2V4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cherry.de;
Received: from AS8PR04MB8897.eurprd04.prod.outlook.com (2603:10a6:20b:42c::20)
 by AS5PR04MB10020.eurprd04.prod.outlook.com (2603:10a6:20b:682::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Mon, 23 Jun
 2025 09:54:38 +0000
Received: from AS8PR04MB8897.eurprd04.prod.outlook.com
 ([fe80::5ee:7297:93b4:a8d1]) by AS8PR04MB8897.eurprd04.prod.outlook.com
 ([fe80::5ee:7297:93b4:a8d1%6]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 09:54:38 +0000
Message-ID: <52f9ac88-da92-4e45-905e-8b4bd8d0b289@cherry.de>
Date: Mon, 23 Jun 2025 11:54:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 261/512] arm64: dts: rockchip: disable unrouted USB
 controllers and PHY on RK3399 Puma with Haikou
To: Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
 Heiko Stuebner <heiko@sntech.de>, Sasha Levin <sashal@kernel.org>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152430.161978386@linuxfoundation.org> <aFVBa4ID/6uxE47h@duo.ucw.cz>
Content-Language: en-US
From: Quentin Schulz <quentin.schulz@cherry.de>
In-Reply-To: <aFVBa4ID/6uxE47h@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P195CA0027.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::16) To AS8PR04MB8897.eurprd04.prod.outlook.com
 (2603:10a6:20b:42c::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8897:EE_|AS5PR04MB10020:EE_
X-MS-Office365-Filtering-Correlation-Id: 51bd9943-04eb-48b2-ee87-08ddb23bf7a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0dZZy9vdDBmN1JpVlFzdFZHd1RQM3NLdmtPazU4akQrWlQ1R1M5ekVTZDR6?=
 =?utf-8?B?dHVMdXc1SCs2SG9TTzA1ckk1Tis5Wmh0RExUSHluOFdEZGZzdkpVQTd2L1da?=
 =?utf-8?B?UGlBMUMwMFdqUEJIMTNqRlAzWS84S2FOeTFZZDhYVTZVTCtKSjJkYTd2K1J4?=
 =?utf-8?B?OVliT3BPRzlUTzhmRUFRTnAxbzdmVXkrdjVFRUZ3VE9QZEpoejQzaTNSekE5?=
 =?utf-8?B?ZmwzMXU3UXpLUVByY3AvQkJKNEtrU3hzaWN3blQ4S0NNczRNNi9lWFZlK3Ix?=
 =?utf-8?B?ZTZ1MVN4aTlPM01WMHZZSGlSaEFYUG5yUnRkYXB4cmxJTThiY1JsRU9YbmIz?=
 =?utf-8?B?bitKTkNKcStqUzUyTzQ0a3lYQzdRMVR4cHJ6dXc2M1M3Tjd2VGEwVmpYalEv?=
 =?utf-8?B?ekN2MitzWEJ5QTZVcEhEbFdHL0tlbzNTVDdkZnlFcjYyeFIyZGxSL1NMZXdw?=
 =?utf-8?B?Q2dJQmtvaU1pcjAyZjBWM3hwNklYWm5hcW1RSlg4bUZOSUxDSzlBbnBUZzVh?=
 =?utf-8?B?YkNOOEd2VEZMQjJMSVN5MTFZOUhqUlFaRzVkWHlEZzJ3cERGQkNVT2FWRUZy?=
 =?utf-8?B?dzcySGpMRGFCMUtuMmhKVjZvMUdEd2QzUlZrZ3QyN1c2RVZ4N1RCMVAzOEFz?=
 =?utf-8?B?UDBndmNRSitYTVZmZXhVcUhnMGlDMXdBV0tQb0tTN0d4L3lSN0htTnRUb0RW?=
 =?utf-8?B?OXdrQ2I0ZlYyVU9HR1QvSUF6dmtLbHorR1B4YkhXa05lOTFBT2FXTHdjOGlw?=
 =?utf-8?B?Ym0rTXdtV2xScmNmeFBlZEdmSWxpS3k3ZVJheWRFSUc2WC9qWEJYb2tLUG8r?=
 =?utf-8?B?Nmp0Zm5XRlMwaVoyeTkwV3lzUVYzc3N4c3E5WUlZS2JZbG90TFZ5UXNpbnhM?=
 =?utf-8?B?VnNqaWo1NjZDeVdnMDF0UEtyaC9SdlhOM2lmK0JNN0VTZDVweElOYkRBMm9G?=
 =?utf-8?B?cmFSWXlFb3FEdUd1ZlFhaE44WVYwN3VWMWFqYlB3M3hjZWt3VEhLWnJkUjNK?=
 =?utf-8?B?a0oydCtSZ0Jza1pBTWdldTUvY1k2N3ZrVjZCbW9Ba2Y3UUJIVWdlYm9rOC9I?=
 =?utf-8?B?TXZQRGxvR0k1c0paWHcyNll2YjBDUzgrc2xCUFArNVBVZFlvaEZicnNzdmlU?=
 =?utf-8?B?dXZDTkdEV01YRDhUV0F4ZjFnRUFZVHlDOVJFd2lZbGhrY1g0NVlOcmVhOXBs?=
 =?utf-8?B?aHo5eHJnN1N5MEVlbFpxcENwUXA4bm9rUEdGVmxVbEpCTE5zR0JuSXBHdURM?=
 =?utf-8?B?SEtrRGttNzQ3NUh5NktRNFA0WlJlUHEyb1hhL0tSUURFY0FBS0RFSW5VbTNj?=
 =?utf-8?B?NDhsTWVkWW1wVFV4bEJxM3BwdjdiZVkrSmlKU0QwUU9OR05YZFFiTFF3WWMr?=
 =?utf-8?B?bDNVT0ExcUpUeDFZZHg4Q1l0b3EvaXdQSldnenhUcktoMjV2bDRPT05aKzZ4?=
 =?utf-8?B?Z0Ywcyt6aHNzcnNGYklHTG9lVXBMMDZnNG5ValFkZStvZ0N1UDBic3g3Yk11?=
 =?utf-8?B?WEpNcHBNeWZUSmtMOWRYc3JkY3V3dWVoT2RFM2toQ25xbTNRT2lzaVYzS3dM?=
 =?utf-8?B?V1FMa2F6ak5mY2k2NVVSU3hGRG5BMjJRT1FnUDV1bW9zWnRCMDhLSENSb0Ry?=
 =?utf-8?B?SkR1bGNib2lpWHhEdG9jMlplMG1zYkgxbkJCTVRMZXBZSkdEZ24yVlJBdklp?=
 =?utf-8?B?a3ZFcmFPdkd2Y0NhYndlRitReEQydXNEaG9SbkhCWXVHQzUyZUw3dmVDUjAz?=
 =?utf-8?B?cHJYN3hsbmEwemhUWlp6Vkg2d3V0dnNGcUJJelhpZ09OWFA4a3pMSHJUeDRz?=
 =?utf-8?B?RFUwM1QxVlBnci9KenFzZ3lTWGFpVkNjVjh1aG5xOUVRYUtMazNPTitiNUEv?=
 =?utf-8?B?WUo1aTFmcUNJZTRESkdqRFV5WWNFQ0RoOGtEY1pBRmYwemkya2xQOERiRHRT?=
 =?utf-8?Q?/9APtOoeF5Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8897.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dis0SW1BNG05bjVlemhIT3NxSFVWc0Q2V0pZbW0vOWZTVVdmRzdKSUM2bFhi?=
 =?utf-8?B?eHg3TGZEWlVzZGpJaHRmY0FSU1JDZzNNMmM3dkJPeElmNWFLZkdZVnNJdFRq?=
 =?utf-8?B?ajdXNDhBcVhwNXRTcDY1SlUxTFR1THJrcU8yenpUMHZ0Rk9aWnpCampyUFp6?=
 =?utf-8?B?aC94b3Fwdmg2S1Q5SlM3U2tXNzEzT2lMRDVrRjVjSkgzeE5HbG5NTEVuZStF?=
 =?utf-8?B?U2pYYkwxT0Zpei9xYWh6d2VPSElTY3ZLVlR5MnNQNUVnVG9XRHl5T2l3a2RS?=
 =?utf-8?B?MnNvV3NZblVFbTRLU0FsRGV0aE8vcXV0c0NXZkVHL1dHMnc2dFZCUTdIbjVE?=
 =?utf-8?B?T1FHOGplWjFrVlZ0UHBCVDFMT095RXorblIwU0pUMHoxZW96S2xndk1VaFNJ?=
 =?utf-8?B?bU5nYlpaSVcxSVF6OFkrYUNKeU9uM2NhS0cwQUVMdXdrTzJmc0tkWUxhakhx?=
 =?utf-8?B?bHk1YWo0S251Mkg2cExQdGZibzhUc3BNVVUzM2VFdE5GcU45b2t6dGpMNjN5?=
 =?utf-8?B?NklkYzhZY0E4SS84VFBqNXgwR01IQkZzTytVZFhjL3k3ekpJWVU2NytxSTVv?=
 =?utf-8?B?R3JpZ1Uxa01Kc0VIQkdKTE50NW8weEdyajRJd1dCOEJHanlseEpDU3RzVjZM?=
 =?utf-8?B?bWx5TWw4Y0FwUEg2SVpRVUFOYTM4UldrMnMzdlhySTR3NU9BWmxWT2JJL1BL?=
 =?utf-8?B?a1MzWlROWmY0cXBmTDlHVGtLaWdtTDh6b25rMlZNUlBFK3FyeWFZRmtPSjRH?=
 =?utf-8?B?T3R4Y1RUMVlUY1lHbS8ybTUvM1loTmxWdkdBNGhhK1lYcDRlYzJqV1BhMlYr?=
 =?utf-8?B?NTB3NVB2ZE9yN0NXOHk1bW1PTkJ1djV4cHJoSGdQTHJ0TWg3K3p6d3hjZlNB?=
 =?utf-8?B?R2tmVFRiMG9iTUhTMFlnc08ydlF5NHFBOWFMMXJ6aUYzQVRMQnJwTTlMNFky?=
 =?utf-8?B?WWUxWlRLRVNUMGUwSUIrZHZldE1oZ0NheUhnODN0bzI1cEhWY1VXSmdUZHQ2?=
 =?utf-8?B?NVUxbThMWE11aTY3dGhVOTRKbGF3SmtSVHJxMVFuNHVSY1BEc1I3djV3M3NN?=
 =?utf-8?B?aVRtekZZWm9ReHhXeThpVEoxbVpVdlIrM2RlSnVZdXpGMVhGb0JnMjJVdzFR?=
 =?utf-8?B?VDR5a0hwN0xCZnVFN0xkZHhKc1hoRzgxaFRib3hIcDFnNU5RWkJMQXRKTlBz?=
 =?utf-8?B?N2w0RXQ2VTl3YVVpSHhDVzZIVnE3VTJlMGdqeWExZmFLbUFPamRvZUZBdG1E?=
 =?utf-8?B?QmhlTGpoRk9FYU11MnVVTFdPQVZhdll1b0JTbWNJeW55cVJYT2l3TEhWd2dZ?=
 =?utf-8?B?YXNoNFdJWHorMlh0Uml4VVZoZTFPbmZucWI3UDhOQWczeGt6emVIcDlqOFor?=
 =?utf-8?B?YlpmRGRWSGV5TXhvc1NZTTdIdjZhNjdvYWxPWi9WZTB2VFRGbG1sTkg3SlY2?=
 =?utf-8?B?QzdrMHNYOEdNMkk5cFdjaVdMSElhY2ZXcFlBb1piemJKQUQ5YjhJWktueERm?=
 =?utf-8?B?YSs3UUVtaThDeGtDWnpLYW5Gek8xb2FHZG1UVmJPVlBPMkcyZ2s3aStEY1NJ?=
 =?utf-8?B?cUYraDJidDUvY0NNRU9JMFB1SEYvL1Z5VVROOElkR1BlZmlVdGZSRXBYcHJP?=
 =?utf-8?B?TVY4MnhRYXVYMnVBSHdUNEVvLzZuTVptKzJCU0p3bzBWTnc1RTZ2M05UU2w5?=
 =?utf-8?B?WWRSQ0ttMHpnSXhObG90TU4vQUFwaHQxNTNGNFB5NlBsbFNNTE8zVUpJM3FX?=
 =?utf-8?B?NUJMNEowRExScUJLRzdsVTNaUVhsWnVMQlg0NUdJUWlxQUdHUnc3MlZ2cnlT?=
 =?utf-8?B?Sjd6S2JFTHdQeU00cnFZVE1JeFhkTC91VXhUcUVKWVBUYnh0MEt6SktycHN1?=
 =?utf-8?B?eE95RE9LWktxQVd4MElSZFhTbnJOZzFXakZRRXpjWFFhNTRTMmNmcVV4SFdX?=
 =?utf-8?B?Z1RJWjlGbktSbnpWYkNXR0EvVVI1VGpWS1JhS3M4dzBoTG5YMU1BQlFBRmhM?=
 =?utf-8?B?NVR5Y1dPRUd3T1h6VnhmanI2dmFRbHkrcmc0QUVGWjRyLy9xazVPLzE3OU44?=
 =?utf-8?B?TjlqOFV6NlF3azJjRzA4SnRSWlFsS0oyRkJJTEVsSGgwUDZZakx4Q0k1WWl6?=
 =?utf-8?B?aGMzK25KVi9SMDZZd2JaY0o0T08zblpoQ2M4dkZNU2lCWTUwQzIvMUF2MXY0?=
 =?utf-8?B?dmc9PQ==?=
X-OriginatorOrg: cherry.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 51bd9943-04eb-48b2-ee87-08ddb23bf7a2
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8897.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 09:54:38.5146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5e0e1b52-21b5-4e7b-83bb-514ec460677e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4x4shhumlSezf6cEvZNNGxLCtSk1G8tBpCGsfhl78LdZ+vpGs+ywt31K0laHuxpE1EXuY/6BSLu3qelnNPLxkHDtGEslZT/SKtlLLYVKLRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB10020

Hi Pavel,

On 6/20/25 1:09 PM, Pavel Machek wrote:
> Hi!
> 
>> No intended functional change.
> 
> So.. no reason to be in -stable, I guess.
> 

Would make it easier to backport other patches in the future where this 
would appear (or not) in the git context though and avoid conflicts.

I haven't gotten any data on that, but I assume that disabling unused 
IPs in the SoC should reduce power consumption, whether that's 
noticeable is a different thing :)

No strong opinion on whether to backport though.

Cheers,
Quentin
