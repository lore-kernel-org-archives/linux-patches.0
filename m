Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02olkn2085.outbound.protection.outlook.com [40.92.50.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A5B84E18
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 07:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.50.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728459336; cv=fail; b=Ylxq435hXsGKhjvbsxw0iNORQ7CgZ4Ly3FJsA6jM3miUk5nZTbzn3bueh+LkNNKNYGLsdAgU8vTF02oADL2PKTt+mDFre5MSXmHB8MNRUhg40hpWzWW+V3SfMNZsNSCpp0efI6BUhFGgMc42jIFLcKXki7qKEWqf2/aFuZndhqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728459336; c=relaxed/simple;
	bh=K6940fB5DapIMG5Gkab9RTenLAefGrw17Z+pfTV68lc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LkD7f0rZt19JvqWlY5qPJnqL48YF6uDxUO8dYZn9RiaaX6OTXyN3FH/roQSK1Imy2Cbl2lIkp1YZ+IDAO0MyWnaoxoYykktsyfkf29a1lNng2zYemNDfoZMG3f3/VuYRS9cmtcsv8TOd3dZ4ayHqofqrzWs6n+nFXK02kZ4TKkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=t9g9sYi9; arc=fail smtp.client-ip=40.92.50.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="t9g9sYi9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQP+aZpzy6SjFzzD8X3nFkcjS6qjNXV0ZIPBDXEktdHjH7o2OtPlF6hliHAt0+w7WHM59APLYSQY0R0JjDqP5N7RgUy+/cVf84t6nEwuXPIVOP1rAwhzaN9FUICrLpzEKbemfp/KYzaz8jn0v0ksgwFuiuusFnzjN1oePZbBqA8+SF2Fzoh+O/Z24yVBB8M1l2rMYUPkH9gAkMxtv9Q02acgZrn6pi4L+bdcCMRhBtkCdszOOsN+xXu2H8B9WSA7ayvwZUWB1cJ+fAJ00N3YBidDG0azoLpJhIKCcylSSlXhJkgnTpl73OJCuwPkhx327t2xBT3xQeMLNC1dcv/Mvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/91dLmPDgpAeHWiQ6JyEXJo39tHDEgd4YwTDYO02HA=;
 b=cUZcK9J/ornCIx2KwItBfEp7raXslQn33eINEKVoPcu6ipsfQPDDMX6Wz4JoPEz12Se/qOW1EunXAe9aMeMQHIEWuotTidRAfVwh95wFt8UQRFliDdhimIkWhGWqZcD3D1BDk/zsMYl0WMpUa1BWsTI4F7UfAEm0OiJowDt9mykIZvKwK9LlXQ8fO97QUtTGURucyE4RMOEd0loe6kiMWtQoM7oiVA8ugqgdc7Q00FpH8F3TCS9ycOyjjFbhrn9iJJCsOnz2NWp5kagmXU0v1LrCnDk0DqICMzVD4YdI+a7caWpVvNZXW+SIaOhJj66zndAxNCjAn5wK/VjOR1XUIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/91dLmPDgpAeHWiQ6JyEXJo39tHDEgd4YwTDYO02HA=;
 b=t9g9sYi9N2dXnKZ2eV3hP+MPQfdUaXEglkJ6Y4sRR7hV8ZzESZvIriZW2CR8GR3gbmR+HjSH8h5jYuSCZpk2OAUZ2Z5jG6fuUiHEN3/9awCgEdT/+VsU+zIhONfY0cldxmRdGfcGDB1z53H0fclHnaDqKGWo6r/GJnihftzGY1vjXJ+Gmrr5x0eqTMFZLN06s2FevGwwTRkz3R+c0+Wfxz3tPK7DLf+hrLTEOSuRtRgeJRqrmQ521sE7NaHk48yUqQnTDAvjDtTAd0OY4y9kKmLCLzI+Gr7OhzCcy3bRy3skqmkK+Ef7o1uPw1jYlHDjOGL4m3Mqs55NGRMh7RGU5w==
Received: from AS8P190MB1285.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e0::21)
 by AM7P190MB0776.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:119::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 07:35:32 +0000
Received: from AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 ([fe80::5307:a61:337b:f3fb]) by AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 ([fe80::5307:a61:337b:f3fb%4]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 07:35:32 +0000
Message-ID:
 <AS8P190MB1285D7871E746D824330F1C4EC7F2@AS8P190MB1285.EURP190.PROD.OUTLOOK.COM>
Date: Wed, 9 Oct 2024 00:35:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 168/558] ALSA: usb-audio: Support multiple control
 interfaces
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
 Sasha Levin <sashal@kernel.org>
References: <20241008115702.214071228@linuxfoundation.org>
 <20241008115708.966425966@linuxfoundation.org>
From: Karol Kosik <k.kosik@outlook.com>
In-Reply-To: <20241008115708.966425966@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0010.namprd21.prod.outlook.com
 (2603:10b6:302:1::23) To AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e0::21)
X-Microsoft-Original-Message-ID:
 <f0457aa1-acc0-48c6-b546-47a87e92540b@outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P190MB1285:EE_|AM7P190MB0776:EE_
X-MS-Office365-Filtering-Correlation-Id: 28541446-1dea-4a1c-53c1-08dce834f4b8
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|8060799006|5072599009|19110799003|15080799006|7092599003|461199028|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	T/oBjf1koOIe03ILd1NhTvG2HekkdRZmos9Y0WnOa9Q59HxkcrUYOduTKvbV+z3novp5PGGyDJu2xlIY6oiCP7reb6D8Ot+qm8Xd8nyJ0WXck8NRxEezpUr5Wml6owMBIaC3NDUNENaH0awvrB8e2N/gXS0N3w0cP4pHeP9gHXgaXozmS9zTWTpufj7cNl69txI/TBguazXnwqExyfRHjY4FB8EV6PwT8VwikSt03QiF7v4XNufLn9MIYyapOBUKhxBR8ZV41SvFc1ChdSM0UPZftgltZ89wGQxO3u0/xv517mWcBWfQMoYYFEE+8+VMA5/P5EvehiDAdg5Gtm6zi+RntrmFVzTE1DgIfeajwQ2E73ZGYFCDPKxcSAT899IjjTowtbIIo7iW37T7cPy1SUJy3orsKBPazcF2BkYShNBd9FRjphEM87k8jJLOL1wTQ2cSq8+v+vlDfMNa3DjM/lJE8ndy8DrBSpBrMtDzqN/fu9YeVo2eYCAWZ3X3AU6sQRtEdMVJ0tHaBzkybw7W9Fe0OcWouC7WzlXHZ3QVuAErCEY8IpQ6qGJw6LBvg2yISl/J6ND8KtK4g5zqaw7FOK9wxq5QdhDem9QWo/Y56Q76BNUEVuqAYB9/2ZZFcqRpeDMpqUxmGEDXx6vm/aGTTQhaeb0r2sOKT3YjQqFDmUTrMq+ssKPbpCdnuRBdtGVH/8nF1+EuMMdAzsgT3iPSCdyyMs6Azlqg96Iy7Sh9BXWC0JExjFISgY6xUtd3a6OXAEesxYgy5l3qczc1tW/O8w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajdYSytpQ3lMTlhFK2JqZktlYkYwdDBGbXZDOVFpTDVDbnZTWGpETzZqMUFZ?=
 =?utf-8?B?ZW5WQUxtRVZBTTdZY0RybVNvSGR3Tng0VVdpM0FxTmh1UTBGZkRsdmpabThG?=
 =?utf-8?B?MEFYeVIyWnQ5emF6dzBJUUREYlRpT08rcFhVZjBqY3FZdVhYQUpodHp5cHZa?=
 =?utf-8?B?aW40RCtTT0QxS3g4UzRidlBIRWFCN1ZMbWUvVjd5RHlZVzQvMlNmYnVnZlZw?=
 =?utf-8?B?bEZhS3N2bTZXWkQ5cXl5blhEanJ4TDBzNHpGTDk0TlBUMVFnSkp4S1Jmc3lz?=
 =?utf-8?B?TWlKQ1ZONFBFYmIxa1MyazBWRGJ1cUZERXkrZFUrU1BTMVFheU4ycFlRYnJK?=
 =?utf-8?B?Sjd4TzRiMElTOFB2SVg2SnFyZ2c4TnZrMlNNT21zYUd0dWNSRkJCZ1VZNlBB?=
 =?utf-8?B?ZWI2MFdiMU81NXcrbG55UjRKMWwxRGFCeXNTYTJpTUtOcHMwOW9YK3NOd0Zu?=
 =?utf-8?B?Q1A3ak82aWEwVkpJTVJHWHhOWXhLWmtRQ2gzMGpmWXJBTXBUUHlLZGRVVjFN?=
 =?utf-8?B?aXcya1IwU2FrdTUzU0hOVjZyNk1RQ1ljWUpYTGF6MHlBVWhnNCtpTE5jNFY2?=
 =?utf-8?B?bUJYek4rajQ4QWJNWWpQZDhYSzFLVCtYZk4xU3o0NmFkKzM2WlIwakhzK2lE?=
 =?utf-8?B?RHR3bmNsdkc2VGVWVDRJVmhoaHgxZklQbzJCSHFDekRIY2ZVbnUvWXBsVVhT?=
 =?utf-8?B?d2pEVzZETHkyd3E1ZTc5YlhRN1VYUVpXYXhCc3gvRVA3N0JUUU5FSVNPN25k?=
 =?utf-8?B?dTh3T2dsaGRyai9JbktYcUpTU1d6L01VVUVLRmhtMTNzUEVSZm5hYWRuNWpK?=
 =?utf-8?B?TW9vZmtOY3NLU2JDODJZbGovcFZ6UFV3Yi9hUllPY3NtVmJ6eXFjK0x3aWEz?=
 =?utf-8?B?RjliOUx0bUkybGRYdE8wdTllckt4a3V4bmU2QVltTnZCU3FNSzlJOE9oMWdO?=
 =?utf-8?B?dXZPSVZtOEJoRnhVSTl6ZCtmZ1VSemF2R3pHY0l2Z2dId2RvV2FrdXVwdFNB?=
 =?utf-8?B?OGtYbzBpQnJHVTdmYkp6cmI4aUZOV1oraGFINnAreEwvS0w2M3FQZjdMM3lM?=
 =?utf-8?B?eHQrYytLTVFrWk5PUHZUalJ3ZkhTNHhJUnhWS1U4Y0dJekYvUk5yYy90RjNQ?=
 =?utf-8?B?cldpU09ROTNUOVltaUt5T1B3aTJBRkJENk5LUlM0WXlRWmxwdTc0aUJpTDE2?=
 =?utf-8?B?N3VtSjBEOHZnUEJKSUYxb0FEMGRHVGpEeGt0WGl4LzY5UVhNTU5IZ0htM1M5?=
 =?utf-8?B?S01LRTNSRHB0YUwwbVFQMGIvYnlPM1RrK29OTnpmdFFKblJUMGJqS0djaHJu?=
 =?utf-8?B?akpHWHZ6eEZqMEtBbXlRVnNjQ2cvSU15ZHk4aEJYMUM1QzIxQktuN2dyNHpY?=
 =?utf-8?B?VW81TnBqRUpJT1pBMFBLTzRhSUl2ZTRRZDVSVWFPR0lQVXRKa2JuVm1iRkZZ?=
 =?utf-8?B?dTEzK1lGZG1iM0ZrZFJXVitkRVIvRXN1b1pOdzNMZzZpaTZWb0x3UnBSWkhW?=
 =?utf-8?B?UUUvUmUvOUpBWXZmbFNTdTZiK3VvUUtiQVRKclBvNm52QTlvV2tNa2dpeXNp?=
 =?utf-8?B?bzRKTE1jbjZIMUJjUS8vNndMMllXa3l2L1lXTGF3U1YzWW8rYUlrN1dmVlkv?=
 =?utf-8?B?cUk4bWdySmdhclRrMHA3aytrbXY3VU5aNEU0ZWcwbVV3ejNkb2hsSFRma0Nl?=
 =?utf-8?B?WHE3L0RYTnZVR1JUOE9aRTZ2ZVNWZmpOVitLWlJpNWc2d3hFZTExT0YyV3lG?=
 =?utf-8?Q?K/L7xqhoTPOUD/Kjo8=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28541446-1dea-4a1c-53c1-08dce834f4b8
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 07:35:32.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P190MB0776



On 10/8/24 05:03, Greg Kroah-Hartman wrote:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
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

Please postpone (or skip) merging my patch to 6.11 due to regression.

I've just learned that my change causes kernel crash when Apple USB-C
headphones are connected and confirmed it's related to my change.

TL;DR: The general idea is correct, but I missed one variable initialization
when specific USB 3.0 audio device connects, as none of the devices I tested
were relying on it.

I'm sorry for the disruption caused by this commit. One line fix will be sent
for review tomorrow after I re-run all tests, and I aim to get it into 6.12-rc3.

Regards,
Karol Kosik
