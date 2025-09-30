Received: from MA0PR01CU009.outbound.protection.outlook.com (mail-southindiaazolkn19010009.outbound.protection.outlook.com [52.103.67.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4123043B8
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.67.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246027; cv=fail; b=bF2t6vwsE9mk+OKVISovs/Kq8SCzoo1YLXDJMsVBA1XfriDoQGDYSxsPMgChRdcBr2LEn8RkoyGXbQcJ2wvY4YAfpZntIvG3jN2fbwB5N0g2asMC7XHELTLNygngRszmvju/0TCtjYAALvVaOZHjkDX28bdKa7TZDCJnyEqloDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246027; c=relaxed/simple;
	bh=FxshB83SLn3sHZgpHZBQFJ17EVwDWePKqlGLEZop0sI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YC09s8A6yq/Kdy3n1iVXs5ZKtJsSx2I/WSWM/jPGrLdSHoeoTNPaRK+HNnIW9aKdbqbLYnyLx7EqHVtJ7Ckk/y/GqI5in6HvJmMb15SmArZRqE+QZ6H4M1+v9wQb5vhYxSelgWsfShe2EuLQFxxIol0kOtsbdaym27+8OhCw2sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=Y7VRoMBw; arc=fail smtp.client-ip=52.103.67.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="Y7VRoMBw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDYLUznZnTEYR/y12g3W4exIgyY6Yd4bjVOuejVBcJhgvY8v1F2Y0YffH63R2Xz83hJhfuRRowo0e6zowWP7Mg2ZAjXpbE8bTVMmk4YUNWy4b8sdFuAOfYt4xMZ7fWO2zZNEQngpFqeWj0F9W60zT+QGbd6+pshTOPjwOBl9v1CPOL8i8FVAfRg+gOu4/hjG58ikGomr91Odub1wZJ+jK15+2Vzba9/TzqJwP2gWEEVENJh9QQ+P1J4Pq0JGx8eeCoj2W1bE9u0sJ4JaSo5166qumWPi41vPiwexDjgkV2bdwf0zoF14VJCaXAd1+/ABLf62AAEwFlxo6o+45ybsOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVxsvYnYUTFw0DT1cWuMFJMArXU8TuUBzR26IxDkJuE=;
 b=eOtkb1w778hf68d+cDzezcQurDz0+2fljFHDe9MZqp5NTX/AdslnX8ZAxgtwT+B7rlOeAkE56ioV+ET0UqnoDuKwOfRSElncoU6mF+eluBUiU6QWCXxm/0yGhIesnCNLIg+qbihjrR3Lifh8YYp/9R90HqRG6YDhpis1sDxxTcscZ0RhqLtZDHpRfrcse3lkUi90DCuz9lgK6aqrbk4f3voZNPyhxqOVWGVRtXMa0J1CCOgPagbNPPsZFYAv4MYnjZ0+Yvu7HJIMLCs9c0mThn9rbScZNURsGXlo4IQn14IVNyYJA0uiF+mgR45FRA4Gvy/aW7wmkB2goKW1pksXjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVxsvYnYUTFw0DT1cWuMFJMArXU8TuUBzR26IxDkJuE=;
 b=Y7VRoMBwIePabKaWIuCTtos0IDO7CvGb2xflmCoVl5xIthUVTkp0osry0vBVRfFosW2NylNnzfF6hGDrEUaPzQ15Fzs8W/YZlTZ6DJn5JAbrTvGKz7c/kEuPvvBo/n4elIRzZ63FJRGiIuwzuxAX0saeGmzTXhxpXyVZfBNe+RJCjfp5VpCAVBmRyOgYSkwV5IpsB11jtLy0ucF9MmUuLtnvJGR7XPwmQCByu/j1iRaW4fTbQ30/3WwRTxnxMvETc86KNwcX/FahkN9r+K7+LG/Kbkxi1boqRAboUwtziyQLL7mUpH8HaoQ0BT3Hlf6+u80wMCsptBelveqejuEvJw==
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18) by PNZPR01MB10908.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Tue, 30 Sep
 2025 15:26:58 +0000
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::418:72df:21ec:64ff]) by MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::418:72df:21ec:64ff%6]) with mapi id 15.20.9160.008; Tue, 30 Sep 2025
 15:26:58 +0000
Message-ID:
 <MAUPR01MB115466A50804989BD07C9A397B81AA@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
Date: Tue, 30 Sep 2025 20:56:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 09/91] HID: multitouch: Get the contact ID from
 HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Benjamin Tissoires <bentiss@kernel.org>,
 Kerem Karabay <kekrby@gmail.com>, Jiri Kosina <jkosina@suse.com>,
 Sasha Levin <sashal@kernel.org>
References: <20250930143821.118938523@linuxfoundation.org>
 <20250930143821.504615260@linuxfoundation.org>
Content-Language: en-US
From: Aditya Garg <gargaditya08@live.com>
In-Reply-To: <20250930143821.504615260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0078.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::16) To MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18)
X-Microsoft-Original-Message-ID:
 <5b372b21-9c5e-42bb-a0e9-4a7c2e98fa1e@live.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MAUPR01MB11546:EE_|PNZPR01MB10908:EE_
X-MS-Office365-Filtering-Correlation-Id: 58db19ab-c526-4569-999d-08de0035cb80
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|6090799003|19110799012|15080799012|23021999003|461199028|41001999006|5072599009|440099028|40105399003|4302099013|3412199025|10035399007|1602099012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TVVoNEFpb28vTVJ0bFNuWFRhQ25BUnVGdW81WTFEMWExcmVERGNJRDNsYnJx?=
 =?utf-8?B?ZzNjWXh1RjI0V3pmQzRFTEdlS3RPNDBvMng3ZlBmbjJJUWlPMFM2TDBpK3l4?=
 =?utf-8?B?Nzg5VlkvUm1SMjVqUGdndTZPZFpYNDYzZzJEbERzeVJyMEFkTTVQSlZ0b3k5?=
 =?utf-8?B?dGJ3Qk1jK2RNZU44RDZ2dzlMVi9JN3JGQmZsL0ZGbk1UMGlYNlExN1Fhb2Vp?=
 =?utf-8?B?N1ZYY2F2bmpHNGNUYjNrbDhlSmEvN004aTNKRXNTcTJUU1NmVzdvdHVCMTNr?=
 =?utf-8?B?TVk1ZTdTVW1HSGVXN0gxRFU3ZE5zbS9zT3pmeHJTYkhic3cxT2RPWjRQNlRi?=
 =?utf-8?B?ZXd1cHdBaVI5RTArM2Zmdm1MS2M5TE1KcGY3NXAxUkUyTWNKcXduTXBMWkVv?=
 =?utf-8?B?WlZlWkhSTWhNT3Rnc3lZUDFjdW82Yy9WV2sxTHVDQ2xwRXdDTXROUmh5bWI5?=
 =?utf-8?B?NFc5Z0F1bElvamVwQlNVdHBEYUppeDRMVjJkaDZCak50Y0d0MHIxdkRwYVVY?=
 =?utf-8?B?RHgvNWdmYkFNUitPVXYzYzRILzRQZnVWL0FoVnJlV3NPY2RzZzdXaTBSMDht?=
 =?utf-8?B?aXBoMkZOQmpoakFrTW5POXA3dDlkcjFOQVd3RHM4VThlSEl3NmhMM0lsZ1FE?=
 =?utf-8?B?UDVZbEdlQTNWa1B3VzJGaXF0OC9Gcy96Z3ZxS3ZGMUVWQkZtRWwrVnBhYjZB?=
 =?utf-8?B?WUdQaVVOcWptM1Vad20xUjUrWEtDZjhXS2pRUFQ0VTE3Yk9RVEd1SGlJOUNX?=
 =?utf-8?B?V243eFRmRnFLSFg4RHVCL0NWZW5mL2tIRklodTFRczd3dzlMcytCcFNLT3ls?=
 =?utf-8?B?V0RhQmxRVzd6UlVNRkZKSlg0QS9GWVp6UmxBVCtUd3VCMWVnN2twN0w5clBT?=
 =?utf-8?B?OW85bkpmQ2tIUlpudFdvQ0FsTDhtZzkvR2c5ZUpRbDQ2anNTZkREcEhZdUd1?=
 =?utf-8?B?TXlZWllGd1NJYnUzVG5jZzBObmFndlZWVGYrdEg4SlBJS0Y0aDliZXN3M1hZ?=
 =?utf-8?B?N09VeVBEblljVE82emd5ZjNWdnpIMzFvejdIRmZwWTZrbVQwMm5Ha0JMTGFY?=
 =?utf-8?B?NUZhaUM2Z1Rhb29CSEFDKzhrNk01Sm9NQnNUaXNhUjhDZTBMK3NNN2xtVmpx?=
 =?utf-8?B?dTQ2dEZNenFaajVSYzJCQXVCemFZY0lvYmo0VTNFd3lOSmJ5a0hPaWNDMk9m?=
 =?utf-8?B?eDR3RkpyNWpTWFJUT0pPLzNYKzFlVjNOWXJNMGRRcDdBZng1YlVoODd4QjAz?=
 =?utf-8?B?YkIwVUpJdGVMcnRuNDR3dGNlTnVPaUZFeXNyQjhJVWxaNGVFVzgveVI2RGh2?=
 =?utf-8?B?Z1NNdHVpSExyeXorT2RMWGUwVG1JblRIVXJwckZURTF5SjkwNnBsMlBLOUlj?=
 =?utf-8?B?cUZoRGZZeUcyYURaR2lLQS8rMVo1a1BTdER3c1RBU2JaTlhHRWdlNzNCRDNt?=
 =?utf-8?B?MzJLbnRBeUZCcGhyejZzZ3E3WFdXVTlaVWpCZFdEK2llVWYxNjhEOGtXclJK?=
 =?utf-8?B?U2FVQXBPYXB4RVlSVXU1OEdSTmxUbXhXK1RyYkZsZUhGcTBQcEV4cXh0a3lQ?=
 =?utf-8?B?d1ZyTkdhYU1KYzdsdVZFMFcxZzhpemN4ZEt6eTRwSXJVbjhCejN1M2ZHVUMx?=
 =?utf-8?B?MTBHMFhYT3JuYlhtSkY2UnBqYzRsallMNXNrVnFMVEJKRTU0b0xydHRLS096?=
 =?utf-8?B?NDJFazJOVkttYUVyenpVTHE3bytJcGNzVUswYkQyaEtOcEs4YTVCQ0U5cXB0?=
 =?utf-8?Q?9GcOupLX2kNrXdb+S8=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUdHQUVJUkoxaEN6RmZwY3FIdi9sdnppLzBxYU0ySVFxblJUczNjcHpPbEFU?=
 =?utf-8?B?QWpCU0dMQnNaMlp2NUhSY1E3N21wWlIzNzZGUmZtUXNyekZkOXF0RGdEc2p3?=
 =?utf-8?B?eVVVL1pSY2ZESXZsZ0lqamJ3cnhnK0dJR1dmeVpFL3FVSzlwT05velN1aDBm?=
 =?utf-8?B?VDhVeVRxWkc0K3JvSko1Q1VoUGg3RjdNL25BUHZLSmdOZmsxdzBtZktXbzk1?=
 =?utf-8?B?ZkFnSlBJYWk1ZXJDSVhtN0w5dkFrMjRBc2RYVURaVmw0endVd3R0aW91MW1T?=
 =?utf-8?B?Qlc5MDRvSjV4akZKMkVxSVlrcFBtVDlRN0YybTVZbU5hWXUwR3F1RkxOOVJj?=
 =?utf-8?B?TnJYVGpTa2RmcmJGaUhGb29Fc1F2bzdCYlNXVEpaVVpWL01xelE4c0RzZGJY?=
 =?utf-8?B?UXcrZEw3Qkh4VzlvblhmRXdWMDlqc2I3L3Uzbi9lcjRmeUZaTURra2E5TWRv?=
 =?utf-8?B?Y1FQSDJKM3ZURVI4ZnpBNk5jQktWVDREMHJaNjdaSWNXWG5EMGZlL0lqZGNV?=
 =?utf-8?B?Rk9xOUxSZFR0ZXVoSHVxM1ozU1B0b21ZNW5aT1ZFaHR6dFQ5WWduWlZXMzdz?=
 =?utf-8?B?SytYbVlkbzE4RmZwL0lCSTM5MjZRNFNnbTI3MEFrRVVoaE9ocmQwVzlwU3J5?=
 =?utf-8?B?WXArV24ybFpOay9odXFFbHpUZUNYajRSYUdjUmpVb3poZnlOcnUrUzVybnZo?=
 =?utf-8?B?NEZ3VTMyM25QbGtIZDRWMWE1S05QaEc1cVdKVnRxL21aRmlKU0VUQjZIY012?=
 =?utf-8?B?QXh1WXR2djA3UEV4K3RRV2t2b0grRGk4enNFMTJ1aHc0dXZUSHhXSnlIV2F2?=
 =?utf-8?B?cWlWZGFOaHBOdXlDMGg2TWg0VkZZZm1MdFdYUUQ1QU81UWVIaDExM0xtY2pH?=
 =?utf-8?B?NGQzeFJxQjBBbEhhMkVZQmEzb2NEZ0NHRDlVOFlUY0dlR3FYd2N3WlVTMXNm?=
 =?utf-8?B?d2tBbmFPMDhDeGErNE5mb1pRYkJQbEMvcWdiVk1wcHY2WlhHTnlpU3NrNmNS?=
 =?utf-8?B?dlRmS2JnRnI5SVZsWWNYMnNNZmhkSTl5N0c4aVphSi9QOTBoUXV5YjNPd1Ry?=
 =?utf-8?B?NnpmUnZJR3pvRU1EVzU3bFRqNi96OEFUcGpTUkpaWllHU3VYNk9oaitPRTNm?=
 =?utf-8?B?ZDlqRHY5MlFOUmVlb2FEZkhqaDVCSllQMm5obk9EVHZ5UEdGeHIzWm0wQUIw?=
 =?utf-8?B?c3hiVXFoaFpLVWl1Qm1ORHU2OUJ2azVQQXJIL0RiY2RyMGFuWUNURE9zQmMv?=
 =?utf-8?B?RFdFVForR1BWeXB1OEZKVzVLamU5RVpodHA0dXpmUXpMQUljU2VSZFNwSlEv?=
 =?utf-8?B?MXpZY2F2RlZ2R0NUWUdDWWhqbDhRQXFXZnhTL2ptNUZCL092TzdkNVRRa082?=
 =?utf-8?B?RkRReSt0MUpOeUdEZFV0WkZib2h2SmFVcnIySUJ3dWlpRTFvVnlPNnVGV3Jr?=
 =?utf-8?B?VGpOenB6clMrT0dkRm5weHMwUlFYRC92L252ZXdJN2FPQ0JFWFJwREJvQ1NW?=
 =?utf-8?B?Vy8vYldVdW1acDNOLzZ1OEZrbnBsTmU3SWV5cDNTM2N4ZEgvS1RLbVJya0dJ?=
 =?utf-8?B?S083bjNHVXgzemgyTUh0RjJDNXVycmdOQjMxTTBVVTZDTFJSZDBuallETDZP?=
 =?utf-8?B?M3c5WHd0OHlERFhyT2FvQU1DSitlcUROaDM0Mnlac3VOZVdKU1F5WFVpa2lW?=
 =?utf-8?B?VU9BSFZJVlpzdEtqSW90ZUgxWW1JanI1WWwweUprTFd3TzFFZDlGblVUZUpx?=
 =?utf-8?Q?dQgJAF0nbN8nXuezxLHf36K8s7CT1fQN/Ofxtbe?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-6aa33.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 58db19ab-c526-4569-999d-08de0035cb80
X-MS-Exchange-CrossTenant-AuthSource: MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 15:26:58.3253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB10908



On 30/09/25 8:17 pm, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
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
> Acked-by: Benjamin Tissoires <bentiss@kernel.org>
> Signed-off-by: Kerem Karabay <kekrby@gmail.com>
> Co-developed-by: Aditya Garg <gargaditya08@live.com>
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hid/hid-multitouch.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index a85581cd511fd..35426e702b301 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -72,6 +72,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
>  #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
>  #define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
> +#define MT_QUIRK_APPLE_TOUCHBAR		BIT(23)
>  
>  #define MT_INPUTMODE_TOUCHSCREEN	0x02
>  #define MT_INPUTMODE_TOUCHPAD		0x03
> @@ -612,6 +613,7 @@ static struct mt_application *mt_find_application(struct mt_device *td,
>  static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
>  						      struct hid_report *report)
>  {
> +	struct mt_class *cls = &td->mtclass;
>  	struct mt_report_data *rdata;
>  	struct hid_field *field;
>  	int r, n;
> @@ -636,7 +638,11 @@ static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
>  
>  		if (field->logical == HID_DG_FINGER || td->hdev->group != HID_GROUP_MULTITOUCH_WIN_8) {
>  			for (n = 0; n < field->report_count; n++) {
> -				if (field->usage[n].hid == HID_DG_CONTACTID) {
> +				unsigned int hid = field->usage[n].hid;
> +
> +				if (hid == HID_DG_CONTACTID ||
> +				   (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR &&
> +				   hid == HID_DG_TRANSDUCER_INDEX)) {
>  					rdata->is_mt_collection = true;
>  					break;
>  				}
> @@ -814,6 +820,14 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  						     EV_KEY, BTN_TOUCH);
>  			MT_STORE_FIELD(tip_state);
>  			return 1;
> +		case HID_DG_TRANSDUCER_INDEX:
> +			/*
> +			 * Contact ID in case of Apple Touch Bars is contained
> +			 * in fields with HID_DG_TRANSDUCER_INDEX usage.
> +			 */
> +			if (!(cls->quirks & MT_QUIRK_APPLE_TOUCHBAR))
> +				return 0;
> +			fallthrough;
>  		case HID_DG_CONTACTID:
>  			MT_STORE_FIELD(contactid);
>  			app->touches_by_report++;


Same here: https://lore.kernel.org/stable/MAUPR01MB11546CD5BF3C073E67FEE70BCB81AA@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM/
