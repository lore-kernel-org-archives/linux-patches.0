Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.95.88
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795034368;
	b=PBPYBBpsE+ZvNoDePNlCpadR8Fa5ehlYiTcjv2RIjkP3P0CtX0m+QPOCTl/+/Xv4OE7c
	 o39Otf5w3t72t+Dwbz7RTRWfOVO+mwxhJUdz1DjvfhKBaHw3yWMDNIrNHHziblX5khGMF
	 D1oyvelSHgqDIR93BFAouFwEyyynERR8oaSntxW4/Msg+uatQojHy55V6p+QMF9XrBxMH
	 DaseXpnKxvJlDD6D2J+XpX9pZah/09VvFVMz2KgXJUm2c9KVehRt5UooENONJaYfKszWb
	 obJfrRlJBLbOU/AknI+5nQa1n+Spehb553ZxBlVBshaRMK16p6Y6oy/3qrGHe/lxJ9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034368;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:To:Cc:Subject:
	 From:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=4ms9d1vNvz4RNaR3rYQyx1SLjToZqaXQYeK2yUGgV7s=;
	b=tzamjUIom67u+eXdcUeZldyaLq3X3Kg9KdIAKy08xUPUab5ktn/G6vC3Ux3rZydvJ3W7
	 d93gegtXlptuQ6aJOVbm/vZW413clWcszCX5f7mrfX8vp7EWjofhkIv0idXDSQXszE9pV
	 4TcB+r2ZwJ3CLAdpZCTqkW8JdY/tsUTDhh79mikr801PLgi3QvkQy3rzFfAPvRu7TOyH1
	 Cs5X6B2pv0ANcq5p5YL6eItEa79Ry4fNsgcgM6n0/3DeddYaV44v2eNE9E8VxQ5xE5237
	 AJXQnBUkOZoSLN4mEPAB4e19PozxiyRVBYgL1utWaI/962BvKDpYygcP71++m4agipQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=garyguo.net;
	spf=pass smtp.mailfrom=garyguo.net;
	dkim=pass header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=Hmid2ETf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.95.88
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021088.outbound.protection.outlook.com [52.101.95.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5A8606A32F
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 20:39:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE5A8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=Hmid2ETf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fm063IoOgx6rzPMu6yJzXTBaX1QiklEvoLhE+6iwRMDhpqSQSndHnm0lEX4wDMoML+Q5L4PPLTaTTOQ0iB6Ar6M0dqwhdUr2MJKP3MQ8+hXJOfaw0jbQan+e5yxSm8jXur9+B+YJbPNsROsCb4vOpqC/VNFHw4I1MZHpS4km0hk+lt1LFnahJoH0tY5+RGIpYZxs0HJw4qb1LwBMVBJmCijez48OkxZFRTnosbp55wJMXkHglEVNHkOQ3vhPM+LiAqnu8mNONzphg9o0ye9ABfID3Z63tA2j25bXjeLFaq1aZpCzgwsVn5oiLOar+CMJ/QxXsYIMvfFdnDLU0CBCDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ms9d1vNvz4RNaR3rYQyx1SLjToZqaXQYeK2yUGgV7s=;
 b=Tuny73N+ff4ozdfQz0vlGZGS8c+etgvEMLZYQUFwWnN/MXOrGn7GwSRk9yI1fV1RDeK8lV5SP0DRc3if4V++iUlmyfM9tslwNFKTVtw+SfQN9j5+7RDglnbUtXAboW7xUsnhttJ85tG0MyC5IuBk1x82X5vRkH3n547ackZst9j5Qg/TRmp02u9/ZnELV0sg3kTY5vRHcxPbQQGqeOa5SrZAmlIuhA3gCt7e/248TrPT9q76Bswx8iz/bt2PElL00K1DZI9TtcRF06uhdSn77hycu/ZsSHxwZ2uzPkt7aCS73pwc2VRya5/RwE1PMDFkkSTUjo+crGsles9y5ncPfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ms9d1vNvz4RNaR3rYQyx1SLjToZqaXQYeK2yUGgV7s=;
 b=Hmid2ETf4XCYfuSu8M/+dYvjodNyUcqBWMsymPMyf1xqdgVGoD63LVjxZevOjyjXHzM2PS/fUNIaTe/E+2fu4Oa5zC2yFE87yKSwQigCu/Jtz6b7FAJLc+PDEo8G4dyfQ7sUOzHIaEVxsNuPF9jf389GDxkVWp5gqZTyu7i+ctA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1cb::9)
 by LO0P265MB9179.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:49b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 20:39:23 +0000
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3]) by CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3%2]) with mapi id 15.21.0615.015; Wed, 18 Nov 2026
 20:39:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Nov 2026 20:39:22 +0000
Message-Id: <DMYMKQ2PRN7X.WKDSQ4X8JIFB@garyguo.net>
To: "Thorsten Leemhuis" <linux@leemhuis.info>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
 <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>,
 <sr@sladewatkins.com>, "Miguel Ojeda" <ojeda@kernel.org>, "RUST"
 <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.22.0
References: <20261118150247.972732815@linuxfoundation.org>
 <cb9ff126-7767-4c60-b735-1b7890a247fc@leemhuis.info>
In-Reply-To: <cb9ff126-7767-4c60-b735-1b7890a247fc@leemhuis.info>
X-ClientProxiedBy: LO4P265CA0032.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::18) To CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:1cb::9)
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
X-MS-TrafficTypeDiagnostic: CWLP265MB6051:EE_|LO0P265MB9179:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be2245b-703a-46b8-1eae-08df45b407a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|7416014|23010399003|366016|6133799003|22082099003|18002099003|261009223027099003|4143699003|56012099006|261026121527099003|261102123227099003|261028144727099003|261022115727099003|261026140227099003|261021121427099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	kd80Z4MVaBwGALczHuBIXhCTaw7u+YMCXUgeF9sWPI8B/snIgdlNbGx/shN+qH7oPfOyDZQI26pJvmnpmax65y2XYOnDAWds7bQMVudXHQmyKUTdyorbp7QqOtcjyCqFDisAd2ep0W1+aFuVFbFT0LJxKdPIMs9IggrnEl+kdBorJv0ju8Ad6+vs7fbjtCWSl1Dy84XxxOptTjLXx5NTLoEMH+aFFqwADvUEwJfQMDak2d+1M4byhdbr8oRw6Lpj6eOegsWbHOlu5DiOKyvx3xbW/cQfNg+0qTWyeJgdBVypwk7UQqngsvqo9zbkLcWvROJe6tU9A2Ue5anA5jPGJ7oJ3puvijFpeWhMxnWB2KRBAdnvKP4tOgeItcYu/ETTTACl2EonO0b8tx6VgZqPcRichJgIR6zYgtfpdcJHhxQESPz3vJi+pSyO/b+hDOt3IzuIXeMGCKz8/7CRs9gBgLHw+7CBBkQ0GMAmCR+nu0ocAnJoK2OJ0WnD6xDSssYLevtOCLUHqTWJHXa9xiiHSp6HrUjatfbq6kXqubV5mGgp3D629jDZUezi0QjjgsrX7cyJ3a70IJBST+5HZfAxLiHkHBDoUXTmeIUh6gVR+OnmNn4DkSBPY0XjiM3DsHMv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(261009223027099003)(4143699003)(56012099006)(261026121527099003)(261102123227099003)(261028144727099003)(261022115727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGpZQnRaeU9qbnNYVTJGaFRFWXBIS25ham95UlBWWDNIREcyRlNWeGRUY1ll?=
 =?utf-8?B?OVcrWVVLTjllMXpBVXk2a3JoVkNBaEdxS1gzT3VYOW5YdDd6R3F1bnBtalht?=
 =?utf-8?B?R2pMN1ZCZUZmSklXbkc0aFcrQUtFV2dQWHVqZFFsa3REUnFqWHYzR0gxckQ1?=
 =?utf-8?B?MTVTZFJsM211OTNYT09aeXN3NHcydjVUbHkxSzlDc1ViYkV5b3VEQ2xNRlh6?=
 =?utf-8?B?NHVpeXFXTVZmY1d0WGxNUUs5Nm11NUQ4bGtVWVNKNFNIQUkrMUtmblFjbEt5?=
 =?utf-8?B?L0kzUWlSZjZsUGdCVmlvSlgyK21zOS80MDdmV2JTQ0RyYmt1aUplQWQ2a0p6?=
 =?utf-8?B?amllVEJ0T09NUHZVaXZ0bW1xUEw0V2h1RmgzWmNKZC9oMmI4OWJ2RjBtUVR6?=
 =?utf-8?B?RXdhOUU1YzN6SGhtNjBUb2ROZDlGSm9Md05KbUJEQVB6U0NkL3RjWldjTytC?=
 =?utf-8?B?TTAyVklaU0NxWFplN2dJczVJT2JmbVlkR3BQVTBkOWdqZWkvOGlKQUFBcFA3?=
 =?utf-8?B?Wnl0dkFEME1mcklJT2xLaUk2RmJEQnkrb1FpbUlGLzZkUEdTZGFxQ2h1azdy?=
 =?utf-8?B?N2tUanloNHE1WlY4Q204dGMvdDdwdHhtTElPbjhkL0F1dU9LWWdNci9jeVYr?=
 =?utf-8?B?dTdBZVBWWWkzNWtLM3NlZ0FUWjVpYXpGbEIrc05UWXlsYlpjelFPMGF0RWpZ?=
 =?utf-8?B?b2pTUnlScnpZOG9NWHBVdUk0MDJ4bDQ5bzVqS083U1VTWGJKTTlLNUF0SXFp?=
 =?utf-8?B?cVJJM2hINXF0SkZkTGRlZGZNN2NZK1FnL3czeWo2K2czYnltTytxRmI4NFd4?=
 =?utf-8?B?ck5JemZZK2wrblRsUC9tMXpXYTNLbEVIeG9SQ200VStScGlLV2hsUjhEQmxy?=
 =?utf-8?B?YXNNcDcxVUZEQWplUUlrQmw0MGdEMUQ4TGcwcTRBOXJFR1czdDZxeGlwYTVo?=
 =?utf-8?B?SG1uWjdrR0U5dXRCYkRzNVpZWExRcGU2YUpMZ2FUNTZ1ODlrb1Z6Z1VQUGRE?=
 =?utf-8?B?MkVCOHZFWDNESHphSnc5TGZNTWs0bHpHWFRxNzhLdVQxUnRoVE0zK3hlRGhn?=
 =?utf-8?B?Wkhmak44ZEZ2RkdpMHplcXFONDVBcW4xK2M2RUppYkZ6ZlRncjZ6TnB0N1BV?=
 =?utf-8?B?VGdpZFFVMG1Ddm11Q29JbWJPMWdtUXB4bmZJT1pRT2RKUFYxNGJjaFdneC9V?=
 =?utf-8?B?MWx2YUVmY1pUV3lYd1Vic1l1MjYwazVBSGVjcTN3YUoyS0JzczNmT3dsMXFa?=
 =?utf-8?B?QmNvK09Va3BZMEc2bittV0UvamlGODhuMEFDV2NnS0ZMSml0eExSVHIxSlF0?=
 =?utf-8?B?TDFKVTJPMDBrWmRNYmFYNUYydHlubkVVbFBJTWhBd25lQjh6TnM4ckVhY2cw?=
 =?utf-8?B?YkZUSVF0VGNlRzhPbENYRElSYXZxWG4rUmIwdHZGRytpYkc5Q1VjTnJoV0V3?=
 =?utf-8?B?UHlaOGQwZVJZcVk1blMvWFJ4TUMvczNZSW55clYyQ1RZc0pwQ1dOQlBqSDZ1?=
 =?utf-8?B?YzYySm50NDJUeDlmanVMR25RQlh6V2xhWmRPMGlONWVsS3E5SndDZC9RaGRN?=
 =?utf-8?B?U2RqOUJyQjhIYXpYOHZjTmFlTDk5M2xhVmVzQ04yT0t3Q1FWamMyNTJkVFpD?=
 =?utf-8?B?MmFBaE5uUmhGUGxsUjRIQkRNNHJQN05hRHZJYTFjVXc0U2ZvMmFVTURDMWM4?=
 =?utf-8?B?WnVFZzUxU1lZejB0alVsSlM5U3NUVGFnZjR4SENzblpwN2ZWVWdTa0ZGcER2?=
 =?utf-8?B?WnE2TzJXTVV0cjJXcm1jQVBXNjBZckZnSWxIQmtRL0tieTh5YXBmU1dSVDgv?=
 =?utf-8?B?Y1hZaHJSZzcrQ2FTckdud1BqMGJVQ0JuNWdoeG1XZkZnT2JDdWowZkxRL2N5?=
 =?utf-8?B?a0VqQVYwbHA0a1FHLzM2SmFlUCtQWFlnTDA0Z2p3dXZZdUtPUFhhSk9BNld3?=
 =?utf-8?B?VjhlUHhWOVVEZ1laMmR1TnpPbXUxcGRiNGwrWi9uODFMdGhFMGJMVnEzZEJD?=
 =?utf-8?B?N2JoczFWeGNPeWxpVkZ3Tklsc3hFa0Z2SUlFV1dpRHFwWFJ2S3QyTlJ2ZVc5?=
 =?utf-8?B?MGVkbnR5b3BVSUVWc1lrVWZGNGtmYkgxcWlqbnIrdlFESk9DRGc1S1VoMFo3?=
 =?utf-8?B?OHh6WHVBcUt0MXlvT0hQbC90b3ZQZXl6VlVrUkNOT1VZRTVscVNUYTVnT2x2?=
 =?utf-8?B?YURja0tSekZIWkhDbisvNFlJNFFIWUFWV0RpVWcreU1yNnRveTVuMGp6NVpi?=
 =?utf-8?B?VjNMalAzcmF6a3NFM0RLZkpMWk9OTklHNXhGbkxBbi9kRW52ejU4aWVrUS9u?=
 =?utf-8?B?d1FxdUVKQ2dyZng2OTFqRkhLZXZWL2pPbjk1b2x5aG1PbXVNbVFBUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be2245b-703a-46b8-1eae-08df45b407a1
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 20:39:23.5747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFZZ5Q0ZJjwDpVR/6ud5YYTkz96/Z7BL8lWrQC6lROMHQmbr+2Ei0KNa9hARwsJ3vfTCLMCvdxL3kPyWatTt7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB9179

On Wed Nov 18, 2026 at 7:02 PM GMT, Thorsten Leemhuis wrote:
> On 11/18/26 15:20, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 7.3.6 release.
>> There are 2651 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>=20
>> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
>> Anything received after that time might be too late.
>>=20
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-=
rc1.gz
>> [...]
>
> This failed to build for me due to a problem with rust during the "make
> bzimage" stage:
>
> """> error[E0432]: unresolved import `crate::util`
>>   --> rust/pin-init/internal/src/init.rs:17:5
>>    |
>> 17 |     util::*,
>>    |     ^^^^ could not find `util` in the crate root
>>=20
>> error[E0599]: no method named `extract_cfg_attrs` found for struct `Vec<=
Attribute>` in the current scope
>>    --> rust/pin-init/internal/src/init.rs:171:39
>>     |
>> 171 |                 let cfg =3D field.attrs.extract_cfg_attrs();
>>     |                                       ^^^^^^^^^^^^^^^^^
>>     |
>> help: there is a method `extract_if` with a similar name, but with diffe=
rent arguments
>>    --> library/alloc/src/vec/mod.rs:4245:4
>>=20
>> error[E0599]: no method named `as_ident` found for reference `&Member` i=
n the current scope
>>    --> rust/pin-init/internal/src/init.rs:413:28
>>     |
>> 413 |         let ident =3D member.as_ident();
>>     |                            ^^^^^^^^ method not found in `&Member`
>>=20
>> error: aborting due to 3 previous errors
>>=20
>> Some errors have detailed explanations: E0432, E0599.
>> For more information about an error, try `rustc --explain E0432`.
>> make[2]: *** [rust/Makefile:649: rust/libpin_init_internal.so] Error 1
>> make[2]: *** Waiting for unfinished jobs....
>> make[1]: *** [/builddir/build/BUILD/kernel-7.3.6-build/kernel-7.3.6-rc1/=
linux-7.3.6-0.rc1.400.vanilla.fc45.x86_64/Makefile:1440: prepare] Error 2

It looks like there's missing dependency not picked for pin-init changes.

Greg, can you drop

    [PATCH 7.3 0580/2651] rust: pin-init: internal: init: emit `slot` using=
 mixed site hygiene
    [PATCH 7.3 0579/2651] rust: pin-init: internal: init: support tuple str=
uct constructor syntax
    [PATCH 7.3 0578/2651] rust: pin-init: internal: init: support tuple str=
ucts in `[pin_]init!`

? While patch 0580 is a fix, pin-init is not used in a way that manifested =
the
issue in 7.3, so it's simpler to just drop it and the other two picked as d=
ep of
it.

Best,
Gary

>> make: *** [Makefile:256: __sub-make] Error 2
> """
> Full log:
> https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora=
-rc/fedora-45-x86_64/11350094-stablerc-fedorarc-releases/builder-live.log.g=
z
>
> Have to run, so not time to look at where this is coming from right now,
> sorry.
>
> Ciao, Thorsten


