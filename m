Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793457715;
	b=Bp1BSsney1f0+0bFDFk/ywZFuz+kDgPX5YOyXXJu7Va2GhXvNpb0I9IHCGZHkIN8Dxk0
	 KgPcZSVY1rJWy8hHtmaqmPk1cR93l/NEgUEjhvzbeLhWPB9UQUnv7pu4q4geyZd0kpU+q
	 uzxkaIhiKfilyA+JOiQyy45VQ2vEZEHqKJE+hRsdp2a2XgEaqOPLsXSxNxfDLUFy8elpl
	 mXPMR2Kbb3LHkLuHHrDNpYLpObC5qE7iB/T37CJk3UXfzYIL64w2cyzqIX/sXgBQyFcju
	 ciih7LXyKYIJubU3ND68XdPjyfP5XBsN4ucBXGpcIYAHRQ0hWHRRBVHnldErOqBwznw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793457715;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:From:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=L/O79hPA2Yqud37jW9/SvFoY0OMTqyhVxweA9lUGqFk=;
	b=RnoyxLzSmvr2z4p+VBtG/bNPnYEdu7o1Hv7FWyJdqp2jiuz5dvCTu++FbfMcJ09mEVFI
	 Fi/FBLZY8Y/T+mDS58uR82L8IrUcYx/RJDk/5D+2Paubxn1tUZgSXNTwxIoEK3LJ/YsY/
	 Yjb9t5aZf6XBfO9T1eAXauuXXCna4AWVU1vpZMjkcyqJKkxBcbyT4Qvy+syT5SMYdadSO
	 7ULL42cQ5bCA0p/veMp35mu7CzlMy3de9zzq8MexWivvckFs5iJb3edLGAnXs+rgha+t8
	 6wuysXXljdSEdJediKT8+fHnFv/x3PYjKPD8cTbrAEXB755nd+ETeRcwgg0hg2STf8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="V67GgXN/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.26
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C1606A31C
	for <patches@lists.linux.dev>; Sat, 31 Oct 2026 14:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD6C1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=V67GgXN/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwwzkpwcd4TjkzEKem/4Y/45tSrBJ6mdq8w2wnK3loR4XesYQgDbLbCI/YUHAL2vDf9suDglvn+sgVQtH+a9c3hK5wg9SVI9ZmMFxBHhVoWWHobeTFgGgMLg/PJp3SLbkHjT+glvmScvtAlyuUG1Of1zKYDRmJXvg9Yb7f3v1IDf3FOriRiq6J9XizDPhBaspi0IwzBzvKWVZyviKSv2fYrELUJ1ZkkUAtZDjC+S6waPSaCW9sobs6vtwvSr5XvkGz7N0q/I4QfHYit0aGc14JH2i2MiZjYlmhbrRJKAvBmpgHspx5NfyXab0Ef31DuxJ0GPPiwbkDUMemd9Sntq6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/O79hPA2Yqud37jW9/SvFoY0OMTqyhVxweA9lUGqFk=;
 b=y8zlpJq3DUbZ/xV3B7E/P7x0ICrA26vLYCqN/7FqgoU4aKz07ydcU2aBblnDDlZD8CLycjYXw+q3Jmo3UbLLMlpeiV+vRvfEEweDeFWsTOkWD87JpuBEEl4DCD2nXs26DMSntnSghoFBFbcFu3drZIbEQ/0ZcMn5HnIlJ2NeH6AEd22VlhzgK1CAiw6kAvEUgBz1pQjaHzK7zjCk2xbcFwBxVQQOebaGJMSpggDxiD9M1Kbx6COdldb8vkQqnaxfr48Vs1qYkigHBAMBBTpg79jOsSJmmqGeN7jQO+RwyArkQC5T07tTuBk99KVJPp+8be8oaIwRIvlsTXgr1ViIfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/O79hPA2Yqud37jW9/SvFoY0OMTqyhVxweA9lUGqFk=;
 b=V67GgXN/JAJhMKQPLrHuGktoTXol8FdWyXOkXfs9pn36eF4caaYyWzx5DfqirMHk/T9Q3F8dT8bptT4lo0PCbMPQ78UvkzPe5naJRPilZ7/VRbNqmp+V+ZwmmIxdYxQa9BP4rxqbCTiXVQOXTSiEfuJQO7yF4DlpJ3T8jypyZNiiP4aak6Nc+8595rDBtr108y/61uh2js0JFil5Y657IvICdDkLvcL557xMBHS3oLaDYPpckMe4akAsKwurHbTkWctVEWFWzWnIItUOC/5W1Bc113jatjeO32E/nn5wutZC13r3jhpVXsCcKIvXUde0KSP2tRfLF4gmxs6O1yMUMw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by BL4PR12MB9477.namprd12.prod.outlook.com (2603:10b6:208:58d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 14:41:50 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 14:41:50 +0000
Message-ID: <7e927599-10b7-44f4-828f-e50c0caf5f27@nvidia.com>
Date: Sat, 31 Oct 2026 14:41:43 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20261029073135.159947193@linuxfoundation.org>
 <b85e0697-d669-4b14-859f-52ee295264e4@rnnvmail201.nvidia.com>
 <80816b31-948c-45a8-9f98-4cc55f5bd530@nvidia.com>
Content-Language: en-US
In-Reply-To: <80816b31-948c-45a8-9f98-4cc55f5bd530@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P189CA0029.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::34) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|BL4PR12MB9477:EE_
X-MS-Office365-Filtering-Correlation-Id: 6049095f-495b-45bf-1162-08df375d18dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10070799003|4143699003|11063799006|56012099006|261009223027099003|261028144727099003|261026140227099003|261022105027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YqbJk+RNhCYSFHqI+si9gYXrBWvPtUFcQ5umS7gKFyrDPZ6pk9QlUT2y+j8PYuDGtj4iKBLqLMcSt6tZBj/OAIvau21aKT4X3Ii89xNZt7ngAJYIuoHhkkchT1C7H2DvDaj5hSNPYFKhYc9KiPxtrkUXMKEz+qsXdOGr60V0hJi3+d6ti5DULOQFr1XMCCpd9nDyGWF/o6fSBO0GnFl2/aXmjr98x9KMxw23r4sjSpbADXSLkCC+Y/julLYmnZT/qB3OsWsvi9V96rIR0qKQHfp0pbDVFTU91x9rtASupeaLCvHlRpsRWgONMkf/PcppXKBKBVoE6xX6jMD4Js+wRUrYtwUeojN/NAZXkqJ6uAiZVjvQOLpxW5pxZnRCc6LsIU+BTF8mY5AhJOvGDzswPuJladprY/WuIV0KmwU+dN2V5Vlsv4ScJHn/VtN00ykRSBjTFysbY/pwy5hDR0h62ufw0/se6N3yQ3NhwI89iy4CRC5pd08coatcIey8pt2g+GetqRr5ZFq+Q52W45d+VoUDN087rXhJcOqmqRvHkSpOM1IAx7IU0ZBUbigPMMRncKPlhmvTPS7Wl3PZaw9DWKpHgSduqfXzbkrOH2rEfZ5/5pCw0EJiVFptboDVF0lsabxsqh0xYQbKoJ10JPUiER6xxUdnhZbpGZTys26gxww=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10070799003)(4143699003)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261026140227099003)(261022105027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDF6Mml5YmxuWHd4RFM2Zk9ZZ2pPUnExdFY3djZ1Z0Nhd1hOeHNZOXVlS0Nq?=
 =?utf-8?B?anU4a0FaK05YcGRtU05qSkVpblFHdnMyVG0vTkVtbGdiMlJZRVpFZjRxYTdC?=
 =?utf-8?B?Z2FBZ2VOTk9SbllTSWd0SHozWWcza0drY0p1YldWOFpWV0lLVWM1VXRPV2Ur?=
 =?utf-8?B?MjVsbWsrMllCZ21oNVp4QTZtU1llUkNsa3g3dkEzYnNYbk5KcFhvUE5vVWdh?=
 =?utf-8?B?RmFGSEdtUGVXb0pIZUxSZVoyV21vTDVNWjBHLzhYOHZYVWFTQkV2SWdKaG1z?=
 =?utf-8?B?NVpaYXdWUzFXTGdDRUdSUnV2SVZJZ1Z1R0JNNzVYSVNtUWQwUTVHOG5oZ2hV?=
 =?utf-8?B?TTBUaUdSeUV3QjJyQjk5VE4xRzRqMm1FQUhSYWdKejZDUVlJM1dqbHVHR2Nw?=
 =?utf-8?B?aEhQbHN3bHMrcEphdTRiUm1UcWhvZ3oxcS9TQkpsZXV1ZmpiaW5wL3IvTDJ6?=
 =?utf-8?B?aERweERPNjMwZm16Lzk4SldFL0VpTnpFcm45clJrcUJ1U1JsLzdCWElvYlBJ?=
 =?utf-8?B?RjN0aTlxbTA4eHZYMVNIenZBVGYvbWw2d29qUUxEakFrRXMvYWw1V09vaXJl?=
 =?utf-8?B?Y2NMUTNaekZqK2RvYkVxNEU0L3d4bG1ieWpwbE9tOCswUk1xYXQzMjM2L2h4?=
 =?utf-8?B?Qkg4dFlDV29vbmJvM1JyVDBnV2R2V0tLRGpBWmlDUm5FTVdyK0gzZjdZWkJ0?=
 =?utf-8?B?SVBMRFhKaWZSelM4ZWZMUHBSMTZ2MnluSFo2ZUY4YXZNQTV6OXRQWTQwa1ZH?=
 =?utf-8?B?YWxaMlozNy9KOVV4MjJnWTRIREdvR1NVTmsvRWRDTG55V2UvWSs5VkZpV2FF?=
 =?utf-8?B?b2VCOThUTVNWdUdnamRkVVFBUTFPcVplempVR2IyVnA0S3RLakdLL0ZKUFA5?=
 =?utf-8?B?OWwzaE45UmhNNDRyZ3FBOUZ0dEVLZ1NxalZYYlNBY0xudFNOOEQ1NmlNMlNB?=
 =?utf-8?B?TUh2dEZ6Nkp2STBYa2NLbVJnMndMeDdWYUdvUnhBMVd3V2taaWhSczlGYUIw?=
 =?utf-8?B?dllzcjhJUGNiQjUrcEp2TTJ4ZGROVC9QdFVmNWg1MjJaVWpRVWRzTnpmdUpC?=
 =?utf-8?B?QzJyUTcwTUJXL3JFSzN2dUZpWnlDSENmVkRjODU3UW1rQ2t1RnRqRyt4QzFj?=
 =?utf-8?B?ZDJEWTUrT1VPYWdXUTZXTlBCQVhRcGlJZS9JTkt3dkVUZ3YxZzY1dGNzOEJt?=
 =?utf-8?B?RENQaktzNnliOGRQNmtpdExWN29CWkV0UDd3SmVHdHRhTHVmNW5tbThkL251?=
 =?utf-8?B?NnNRWTJUN09XQUs5bUU3bU5SWmpJcmxDM0VYM1Fnb3V4S3BkaDJETE9ZVjJE?=
 =?utf-8?B?aU9qeFhxLzJvditSK0ZhVUxMVVovWHNSTWVveTEwUHUweExGaTJUMDRybUY3?=
 =?utf-8?B?VUpZR2JXMWYrTDhDRkhPaXZBUXVXVVZiSnlOTDdwSm5Ma0VJNkVEMEh4ZWEw?=
 =?utf-8?B?MzREeHZqVnV0Ri9PVm9yZ0kzQ05sNklIR2QxdndDK0ZBRXFRR09hakl3bWRT?=
 =?utf-8?B?YklXZFRVM3lBa0hIdFlmTVdTaElkMFVzeFZyUWF1azB0TDM2TG1wSWVORUZs?=
 =?utf-8?B?ZzFSSDA2bE1BdE1TcEtQa05sbEgya3ZxQWpNRXY3ZVFjM0xWaXNkR2JKUXJP?=
 =?utf-8?B?aWFOSHpVUWlNbDlWSEszcmppVjBEdVhsbDJyZGhjaFgvVllNR0FycFpscjh0?=
 =?utf-8?B?Zmo4TmdRWTBFalhYSWt0MCtRQ1ZrRVVPdnJBR0RSTFl0TFFFaldXS2lsMUx1?=
 =?utf-8?B?VUt2dXNZSkovR08zNGJJQ2hONk1BL2ZRNkpWTXVhY1Q5YjdoU3JTQk05S2x3?=
 =?utf-8?B?L0hFeDkwUVlqa0FsbFVWS2JIM2RwN0NKSm44Nm14ZDBNRGJBNFk3Wm9rcnpM?=
 =?utf-8?B?b1M3bFRHUVBKRVVWa08vQUNDa1BWTVF2NWxJajkxeXNCR3NlL2E3ZHpiSm9T?=
 =?utf-8?B?SG9XTmdRRjlkNjQ0V3lSTlB0UUYvbkwvUmdDTFJRSmRvZzV2UGNtOTB1WU42?=
 =?utf-8?B?RDBYbVVzNGl5UGxCVVhpQUlDMERHa0NYOVhoaU1nRTMvbDJSTldJMjlDSzBO?=
 =?utf-8?B?TEZTV0JaQ0N6SnZqbU5iMmFnTmRkK0ZlZ3M2MWxoaFU5QW44eDFreGk1cEx6?=
 =?utf-8?B?dFhLaml1M3BwWnlPR3Zqa1Y2aWRqYnZQTUt0K2lMRGJMcGFTSlFseGtSTG5p?=
 =?utf-8?B?TEJMS0U1czRreXZOZzRiN2tuV3FYMW1VWHZpd2FuTGtLUlpFUC9yUzJmTkY3?=
 =?utf-8?B?MlpkTjRNUkhIZEQyblJyZHNaU21CUjhtN0RJRUtQaVR1c1NGeUl5Zjg4YWE2?=
 =?utf-8?B?U2tkVmhCY0ZEbFF6ei83SlRRWEpkMTI2bVVBK3UwT0YrbnJmcjQ2bXVJNVNE?=
 =?utf-8?Q?cM+Y7gU5msng+pxldAu5KNXJWwZQVu8r7pqjex/Vp2U5G?=
X-MS-Exchange-AntiSpam-MessageData-1: h05pYdq4Ne+mrg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6049095f-495b-45bf-1162-08df375d18dc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 14:41:50.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8IJ7nNU/NtPZxwKQ+vwgeAqZgtJURfPtAeLQZoC9Jrtm9iX8JvZCCcBCN95U2Vv9Vj3+OW5zoX5ru/h3zkd0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9477

Hi Greg,

On 31/10/2026 09:26, Jon Hunter wrote:

...

> On 31/10/2026 09:24, Jon Hunter wrote:
>> On Thu, 29 Oct 2026 08:33:04 +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.191 release.
>>> There are 1879 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc2.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Failures detected for Tegra ...
>>
>> Test results for stable-v6.1:
>>     builds:	9 pass, 0 fail
>>     boots:	28 pass, 4 fail
>>     tests:	83 pass, 7 fail
>>
>> Linux version:	6.1.191-rc2-g3b00df762ebc
>> Boards tested:	tegra20-ventana
>>                 tegra30-cardhu-a04
>>                 tegra124-jetson-tk1
>>                 tegra210-p2371-2180
>>                 tegra210-p3450-0000
>>                 tegra186-p2771-0000
>>                 tegra186-p3509-0000+p3636-0001
>>                 tegra194-p2972-0000
>>                 tegra194-p3509-0000+p3668-0000
>>
>> Boot failures:	tegra186-p2771-0000, tegra186-p3509-0000+p3636-0001,
>>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000
>>
>> Test failures:	tegra124-jetson-tk1: pm-system-suspend.sh
>>                 tegra20-ventana: pm-system-suspend.sh
>>                 tegra30-cardhu-a04: pm-system-suspend.sh
> I am looking into the above boot and suspend issues and will let you
> know what I find.

Bisecting is pointing to the below commit and reverting it fixes
the above issues ...

# first bad commit: [26c5e136ba4e94ad708333c9bd34039a1de397b0] net: stmmac: protect updates of 64-bit statistics counters

Jon

-- 
nvpublic

