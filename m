Received: from PNYPR01CU001.outbound.protection.outlook.com (mail-centralindiaazolkn19010000.outbound.protection.outlook.com [52.103.68.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609C245010
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.68.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245859; cv=fail; b=PP5BTVtw6buZdgryh8NvwkSbyJ9OZVdcISaXVYb664D0kNTnuefnlcDEtX//bdxUGYKRjACBlLgA4IDtvOFBIy9Tj0jBPlWAPtXo14BMrGQwOijxajI7yCHIIE0dvA39QlTJaP9sAjiF75GT1eBzoZsAN5EJR87nn+a0kA4WNOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245859; c=relaxed/simple;
	bh=AGZlqO9cdHu/FBLZl6KsMgY1QWmTwpwNPkdpILhGgo8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h68zZ3JhYWH6lTfncsr9qClwTrVLipWonV3oelFxmy54z0LIpjTM2iKsg5djLGbClhCaZouJ0IC1S9Sv0vIMHtzgfyIP4+mawnrPuDDSwnBO8emWT7h58FdSgsyvgt0l7/hSssjEl89mypXsbOG9WDmsUHU9qMXI62FLN3ANCpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=PrQ1c1uD; arc=fail smtp.client-ip=52.103.68.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="PrQ1c1uD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U4NseJ6mymKWzkxd2MZeWBFvHNY9ZeawvHFGiuMxHUjHHD3rf/HAA+fS/pDszJwCA+PA/LQaV58h71eY/5Jywg5BDzDlqldGBKPODEt9OGscmAAQNawaVrsvzKnRb6Eh1heCzwa78QHhrROwT1ze1IhY06zcogDHQHNxdr9ZoqEX7Nf8D0viUKWkryXLNoqEBOJYPZuGvFvOeLbYBkLE9JtSLjtRABnUcM7Q8oNOZ9NKzdDqvXGuCa8stwERGRKl5mLf1CQ6Pk2m8wnNxlGufgQegS3U30+Kqrxor4poy3nIVkzxTVJyGVbteIfuANelDVeB0xpcTIYB9cos91FsUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLj9+cBuYuojD78cZ7hkD+GfMsZTKtv5Ij0wUlDHg4w=;
 b=R0QmSY/UP466m/x9wViyZ3FRHqm0HKglEaqxYlvjnuI2z+hm5Cbzth1fFSgWO+iWaia3ese01hml5gfyOu8kLASWbug5Ll+dM2gRE/MTKKGr6D78auhD1UbUAijcRNWtkuGqrO2DEfQ9e8S9u0Mw8h8GuomUwuLA/VuDZu+ycTUqPuwJAy/rzmObSptp4wMgxFu+ZUqvuRBx9qcOig8Wh1XVqqEvTJldPMfqzBrrEiIv0HECShf0R2Rgeti0JS1H//Fjr0CkE1wuo9e+dLCzFSjohF8pTFh978EvK/ikq9zph2vsYFL6mnAyO1I5VYTc0iUFQG2oRpMiFrhW4Mpy7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLj9+cBuYuojD78cZ7hkD+GfMsZTKtv5Ij0wUlDHg4w=;
 b=PrQ1c1uDiNPjjsfZAy2uh9DNu+99hQHqDdeeBxvQj6YlDerji/QwjlxvrDpGZW2DwlElhdhGPSaIbIryNpnOeUR4atyy88/7vZU2A5CvjsLZ6HIToHfqRCKLQp2Gi6btSF7KERsUDCWKzQBKhME2/Zdm+bzWrxkjqFWhyx/7ZknR96WtO3HZm3bPQ4TNubsUYk4Fr+ZPvbtACFVLeFKw4VKH4QotyoR2Yz8EqefYJ5vaXRDeWDta3MiscGASTuCd3o7EEkdcUN6fsM8RUxxWGBwNUDhqfTxUOe+C5BQOiK/J9y+87qSNnb9mjzdMHKmn/ctoR3jTSzSPhIPebfSFSw==
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18) by PNZPR01MB10908.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Tue, 30 Sep
 2025 15:24:11 +0000
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::418:72df:21ec:64ff]) by MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::418:72df:21ec:64ff%6]) with mapi id 15.20.9160.008; Tue, 30 Sep 2025
 15:24:11 +0000
Message-ID:
 <MAUPR01MB11546CD5BF3C073E67FEE70BCB81AA@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
Date: Tue, 30 Sep 2025 20:53:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 07/73] HID: multitouch: Get the contact ID from
 HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Benjamin Tissoires <bentiss@kernel.org>,
 Kerem Karabay <kekrby@gmail.com>, Jiri Kosina <jkosina@suse.com>,
 Sasha Levin <sashal@kernel.org>
References: <20250930143820.537407601@linuxfoundation.org>
 <20250930143820.858284690@linuxfoundation.org>
Content-Language: en-US
From: Aditya Garg <gargaditya08@live.com>
In-Reply-To: <20250930143820.858284690@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0074.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::10) To MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18)
X-Microsoft-Original-Message-ID:
 <5d241189-79ce-4b67-90f6-3d1a62b91e19@live.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MAUPR01MB11546:EE_|PNZPR01MB10908:EE_
X-MS-Office365-Filtering-Correlation-Id: a471b6e5-4456-4e72-a64c-08de003567cf
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|6090799003|19110799012|15080799012|23021999003|461199028|5072599009|51005399003|440099028|40105399003|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TU1neXJKdTZBa2gwVVBmUmM0UmxqMC9SU28renBLU3JTWWpBTDhYRVl0K0c5?=
 =?utf-8?B?d25XVE9RUTMwVXIyQVQ5TlNPcHhNYThFVFdBTHRoQXhWRCt1dFUzd3hMM052?=
 =?utf-8?B?UXpwWk02dk1pU3NlVU5xNDY2NWcxdE42UjVGS2d1aTdPaTl2bERnUmhyWGhP?=
 =?utf-8?B?OTBpMTJCNWlaRWthR0JNRWthSngrd0sxYndCNHRiaVlLSFlwMlBaRkdYT2hq?=
 =?utf-8?B?U3JHMTdHd2FPaUpxRnZTS3hDYTcxend2c0lRTEhtMnY1MTQ5THV3SjB2bTRR?=
 =?utf-8?B?YXNHUlJxZkNOb0Y0WVA0ZmlKUE1PcmdkOFg1R0IyVFJqVHFtVTljQUIvL3Ix?=
 =?utf-8?B?MGF3QXA1NFN6NkdHcUpSMW5hOERXeGRwVVBjZXZrRzgzSWVOby9mNktSTkVV?=
 =?utf-8?B?V01kTXNSdEZIUWZmM1JNTEVmVHdicWMreFdRZDlzNGNFOVFWU2FNdTg5WVY5?=
 =?utf-8?B?MHZ1dytuT2c5ZWw3NmsvUkdMMnkyNzNRT3F2R2NkR2tkYm9xSXcvMXQ4WjJx?=
 =?utf-8?B?dmpUMnVzcVFHMXN0dEtyN0dCL3ZybkhSZWVkdDFwWlQ3bjdxODR1T2QyQVox?=
 =?utf-8?B?Z3RLa1hOQ01CUDNyRmhSSWxwaWtUeUFsZG5hV1FCYlhTVGJwWWw5UEZ2Q3JT?=
 =?utf-8?B?ZGRKTHZQemFFUjcwS0FlUWJhTFRNdjh3NFFHVmQ3UDU4YlNtWjFLS0NmRlFD?=
 =?utf-8?B?Zk9NekhGc2ZxZkRmT3pmVFlMc3VkUHNkUElxRlU4QVMzL3F2Qnd2QkFKSzFu?=
 =?utf-8?B?WjVJME1yR1JlM3dFU3FzVjc2WG56VGlHVnlXWG1uSkx1czE0dFl6RVR4U0xK?=
 =?utf-8?B?S0x1TEs5a28xQjJhZll6V0o4VXd2QTc4NlpEa0FDcmJhc3dnSFBITkdRdy9u?=
 =?utf-8?B?TGtRWEdzdW1vVFlNTUV5TWwzQzBjOVZOTm5FK1RqaDYxYkdwOGhrSVppa2I1?=
 =?utf-8?B?MG42UmhVZGtRYW14QzNkeHlXNUluWUE2ZTNuUGxWQTIzL2JjcGFhUGlLZ2VG?=
 =?utf-8?B?L1FNM2tRV0plU2xLcXVJNitKeUpkOGpZTzI0TTJBbG9HZHlKK0lHL3ZPWTdk?=
 =?utf-8?B?bVdYZXBKT213YmxLR21qOE80L3NHY0hFL0ZtMFBhYjNnT2JEMmgydGVKWURx?=
 =?utf-8?B?cjYxRU5rMjQxQkZ3a1Z3VUk4ZzdOMzJxbVdPb0JEVmFBeStpY3VFTHRPN1FO?=
 =?utf-8?B?SGtBN09mUytsRHJDcmVtOGZlSmh4UGFVZjIxT0ptbnh6UlRseU9iRFBFbVEr?=
 =?utf-8?B?b3h0dzQyS2hmdTk2OWZ5bG9uRXAvSjAwYmVyM0I2Y1RDZHJ2SzhOR2tmemht?=
 =?utf-8?B?WFpYY21lbjA0disrVnQwN1gweFBJNzRNa2tabnVLMkIvUGF1Z0djVEFQUzZT?=
 =?utf-8?B?S2liMjdDTEEyS0J4SHV1NmVWZnFSUldJTnhvb2lKUkVEemhjZEowdi95YVVs?=
 =?utf-8?B?Tm1aZ3FjeU9JNDhZUUlJUytHSjJ2NGEyVm0yRWxodVlmL2RVUUVCNFlhcjBv?=
 =?utf-8?B?cjBKRVZ3ZXZVeWZrS0d3RVFXWUVTRUlMQkpyanN3eE5rb2xNTnhVb2VjVWhz?=
 =?utf-8?B?U3BmT0kxaE5xSWhmTkVmMEVJZFBUb0VBYnpOMm1pb1Y4WWE0NVVGR0NsZWRi?=
 =?utf-8?B?K0l6ZS91Wk5aN3ZtLzBBbHZVWFdhUUE9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEw1QjZZZUVaampTTW5vOWJMU2RTVWx5elRSVmlkeDBtYU9jalFGT2FETkFB?=
 =?utf-8?B?Q3FuN3BqK2RjWjkxS1BnM1dLaGxubjlkZHJYTGlwM1BaNTRPUWNYWTFlZmM1?=
 =?utf-8?B?b1hZTWpCb28xQ2pjQ3EyYmN4eVlRMFZUQnhQckJxR1YxeVJld1h4NHRkSzJ0?=
 =?utf-8?B?WERCRGhCMEQxejFnM2ZLRGRuZVJYNTZ3WFBRSEVYdlpVNUZjUExsNVlQUUxs?=
 =?utf-8?B?L3pVZE1RT0ZMZXZUdzRsTENFNktPTVFJL1N3LzhwWjdhSDkvQWlNOUtVMmpw?=
 =?utf-8?B?YllvNUp4czBDNzVhZHpZdktlMzVVWi9LV1hWV3ZjWUp6aHcxMGcvOHhlaW1E?=
 =?utf-8?B?b1Z1VFk1Uy9CUUZZQklOZEVjYjFHeGk3eFEzWDZNaWM3ajI3MmxEaU50T05S?=
 =?utf-8?B?TGR3RVB5UHZiQVM0eTlNdmhwYzNiZmhRb0xnZ2JSL0ZyZ0pDaVpqSkNtMzV4?=
 =?utf-8?B?cXNDUmRFK2QxTzh0L01vaENrSVNERGcyM0F5OGxSZUFDc2QxUDczb0RvRXlV?=
 =?utf-8?B?enR1YW5sVkJMNkV2V3oyeks3NWtZZ0p2Sm84T1BCWlhybUs2d1c3aFVmR09x?=
 =?utf-8?B?amRqYnpKNlRJSkdoUVdUN0IwWVg2cXlYa1AvRmJwTXJwKzRyODN6VWNrYldB?=
 =?utf-8?B?dkVTU09Tb3EzZ0lSbUlac014VHFWK2pRaDlDN0ltY2RFTGxwc0EwdFlXUDdi?=
 =?utf-8?B?dU81b3JrbWt1YzFPU2R6OU80T0cxTmQvMHRoNUpNaEgvanF6L1FzN2w5bEEy?=
 =?utf-8?B?alBnVEFNOGxPLzJkV2FCYWlXME5QTlc2bTdZa3F5UFJRSFdzNW5SZWZlcjZZ?=
 =?utf-8?B?Uk9XeDViZGxQb1JxcXFxMG0yVm55cnFRbWZHNUlCcElaeU14dWxISUhYVVhD?=
 =?utf-8?B?QkhQclhRbkVkUTM3dXd6dE1ESnZzdE44eHNYK25ZOUQ4WkRGYnVVdVE3d0Rs?=
 =?utf-8?B?MFJLNzRvRU15eEUvaVJ5NkhQWVJmK1NSRzBkY2QrZkZURm5DRGxhWVZ6ZG1x?=
 =?utf-8?B?QU0vaEJQUVJSamcvNUI1VUpNbDNLMVJZdEZLa2JqVTF0TmM0SVl6cGJvTm5n?=
 =?utf-8?B?eWcvdUxVc29FbXRJRUtCM0Z6bzFjdXY1NmpBZFc0eGdPL2wwbTJSYXp3UnFG?=
 =?utf-8?B?enBkWWFZZURRdWd1alNQZFRQazAvcDlXbWhTd3VsMkgxSmNWTXZLOGtNN0xJ?=
 =?utf-8?B?QU9oN2c5WWVqL1hGbG1nRk9hUHVpSDRzUlJLcWJBL0tBRjFHVWVVUVJ5TGxs?=
 =?utf-8?B?cjgyWjJwZ2JPc1ZRMHV0RC80T3B1Q0tMb0ZEME5mNEVROFJpOVNHYlIrWVRK?=
 =?utf-8?B?TXozeFY5NW0vcnNxVzA4OUI1T1Z3NVQyekdpZkVRU3p6dDdVOHBwejVKU1dy?=
 =?utf-8?B?aWFtdzIzUzdDYkRxY3B3NjNUVWpJeDZZcWxhSnB4UlcrUDFXU2wvNmxFbFNH?=
 =?utf-8?B?clRGV1JnS2IyQVpTTXFTNUVVdEpKSjAxRWgzWFcvZmc3VWcyazdnUWM2ZVRJ?=
 =?utf-8?B?TU91QWlGK0l4RXE5SWdidTFyamU0R3V5dkJwSGFKOU9haUNRb0I0U2dhK2p0?=
 =?utf-8?B?NS9GcFJYOHJYWkREZjdjcXc3R0ZjdzNQaGdxaVI2b01Wb005SjdINlBDV1E5?=
 =?utf-8?B?em5ZMWJSVmMwcVRubzRRaTVvWmZDd2RQWU12clJCN3h1dkZUL3I3M3RpUEJU?=
 =?utf-8?B?eE1seDhqWXBrUjg3eVJ4YlhvcHllNXNGVzVuUzdjbi9rY3FWbFJpVGN0YTFN?=
 =?utf-8?Q?jv9D2IpjPqvzzCbSLeTnUIXmAzJINvc7UYEARLZ?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-6aa33.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a471b6e5-4456-4e72-a64c-08de003567cf
X-MS-Exchange-CrossTenant-AuthSource: MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 15:24:11.0613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB10908



On 30/09/25 8:17 pm, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kerem Karabay <kekrby@gmail.com>
> 
> [ Upstream commit f41d736acc039d86512951f4e874b0f5e666babf ]
> 
> In Apple Touch Bar, the contact ID is contained in fields with the
> HID_DG_TRANSDUCER_INDEX usage rather than HID_DG_CONTACTID, thus differing
> from the HID spec. Add a quirk for the same.
> 

All these hid-multitouch patches were a part of appletbdrm driver upstreamed since kernel 6.15.

Due to 2 different trees, and some delay in review by hid maintainers, these got upstreamed in 6.17.

So, in case you wish to backport to stable, IMO, backport only till 6.15, which in practicality is just 6.16 as of today.

