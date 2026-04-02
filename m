Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021107.outbound.protection.outlook.com [52.101.100.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AECA3D3D09
	for <patches@lists.linux.dev>; Thu,  2 Apr 2026 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775131321; cv=fail; b=l87aPnHtIVZ2LPqu6rnKMetAABIyUB1cVggplz73W8QbUXiLSCrNGdTyfGZ1Dfb2fzccOG0ouq211s5PsNYaOOFPavbn3/Y1l4m77PfwwSfrV8gzVXnc913uiaL5tFqsWVh9PhwiQ+Q3IucQk3hlxMWC/WSm9+SXKYNWM5j1O9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775131321; c=relaxed/simple;
	bh=wDKhq1cBYQzMjKbVEOA14Af2uPktc+rIqUDeCh6h4Sk=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=ZEwpNhf0tl9BUxETY2Th0iS/I8FOEJhW+xttDvOS/CeoqPu2MY/WoMRW1xzjFIgfL/mm6wlipGnqYh6xxD5N354Z/K9jsmVfhTtoO3Lt3PdiZBKfcwPOZobY7hwhtLzgo7QpnO8OTlyaovYN2I4AwlUZBw77fQMROysU9sCEDKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=m61JVegJ; arc=fail smtp.client-ip=52.101.100.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="m61JVegJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uv5tcmQKR8uQqTyN/k3H5PcAYxIFsjdo3Lt/4eJ/3MpQ3RO9Q0UKjRgp0M/qAdQPZzBSTqUVVDDXbnxYjX/WXyjFkth2/ew1w8XCx15EZPWSVQRfjf+9IteJfgFGqCcDIlyv3csrssJ0i0ScDLyTnfu679kEVFFTJIvraiDzZbnUtg7MEIHqN45J5BlU91onwM1wgtqDdShPr2hscMjpoZBS06nPt+m5Ep2ABJvagClYSq0EwoYqjslYqYZDkRedsheD/xjhEx7IMzZ5tsKqJ3wpW2f92cQYIDBbCd7HP+ELj0lEzw74J7ACJ5VcC80kpMz3yPKKcM/8C67XJKdhnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSVP9kbJJLIfpKcvP4um985OxyaaU+v7mRh3Sk7UejE=;
 b=t+jLCB4sSaF63lnjt3Sf/JRXZNQMf7Z4GhG8I/7vjSdI+SssuOXnHkQolKxyHS01CvFFEX5mitWe9kOoBJBIfb6LYH8yVw2PGBogmfETwtaL8wt4S3t/yVsyFHhn9bj0bcqG0lh5Sz6ed7sguv2aWfjXHmiN6Q6iCFWGpOUK/r5TX5jhrRZBOW8+yGCnPxvCe+Rb7rm4I5RZFC66nfdEroacXeST2OWLRVyqMdD6brpSVwXTQiK6K01ZJrtAXf+uTcZ1naY8mLN08jZLN47bmZ1LUcC1CqGMPIC4v11UnFvqoWBzetL8b2jF6zCU1cKqSzJU+ra84CXXe030YmtYhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSVP9kbJJLIfpKcvP4um985OxyaaU+v7mRh3Sk7UejE=;
 b=m61JVegJdua5qeZGrjhNIxAN+Ii1f2+ZiBWwJhDP+cZ3VU3t/hm6ZVlqdkjBSulWhn7tZ7VsuwNoKeua0jWZ3XyalNcxUeg4quWpG+ewXO2SthNRhT6T2y6gW65kYb4XXBW/WeKT6Op084uv6yeXbZDYVJRfNmVPUH0sYBsw7mM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CW1P265MB9086.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:270::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 2 Apr
 2026 12:01:51 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.20.9769.016; Thu, 2 Apr 2026
 12:01:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Apr 2026 13:01:50 +0100
Message-Id: <DHINJ6CUHNLM.3RD5BA5313NKK@garyguo.net>
Cc: <achill@achill.org>, <akpm@linux-foundation.org>, <broonie@kernel.org>,
 <conor@kernel.org>, <f.fainelli@gmail.com>, <hargar@microsoft.com>,
 <jonathanh@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux@roeck-us.net>, <lkft-triage@lists.linaro.org>,
 <patches@kernelci.org>, <patches@lists.linux.dev>, <pavel@nabladev.com>,
 <rwarsow@gmx.de>, <shuah@kernel.org>, <sr@sladewatkins.com>,
 <stable@vger.kernel.org>, <sudipm.mukherjee@gmail.com>,
 <torvalds@linux-foundation.org>, "Benno Lossin" <lossin@kernel.org>, "Gary
 Guo" <gary@garyguo.net>
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
From: "Gary Guo" <gary@garyguo.net>
To: "Greg KH" <gregkh@linuxfoundation.org>, "Miguel Ojeda"
 <ojeda@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260331161729.779738837@linuxfoundation.org>
 <20260402112712.110869-1-ojeda@kernel.org>
 <2026040247-stimuli-surreal-edf1@gregkh>
In-Reply-To: <2026040247-stimuli-surreal-edf1@gregkh>
X-ClientProxiedBy: LO4P123CA0467.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::22) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CW1P265MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: d47207c7-0430-4dcb-85dc-08de90afa047
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cJuzrWf6jsDblQkAL699xP46gQdNLOvsnIxEtTJ1eO/9cx+zTa1dGhjkMF7dZEl9VIHEe4BTL+3ZR8HqcIYTCJtKmwiNurE4m7qrP3CpB7RUuDp+D/GBvead7czv7P0klzKRiEFfn0ggcdM8SzDUbS2dqa2/mA3fwDLhgj/8roWLumnhQx0jP1z271sPttby7Glu3FBgiuC2r4n+r2SB8zRaMz0xDw6R44ieVnMNTACGFiH0iI9qsZP+jCbE1b9aUQZnDxUc4jKcGynxMA+A1GF9sJLk5rNJhdmczce4jyOOEj7E8qpl07s8hNJgChj9PocLFZnMluyydw7nDCvHqJVWubhZuVZRogN2mGZGELv2V7ylXsq863l7+VcWGAEUMY//JfX/Kbah1DQgHvdbYmV8xSEm8GSGhOWOV5cMcUxu4DiQygZqwVckGwVlRZq33o1AQU+iOnRoVWJNmMajkvmHN9yxLlRgAO7YNywNKdwuYqDq8aAfgx5CYOXsiphNEHRk/RIDoWy0NDjJ/OBrHqf7payRs2uTnsJLMXS14RuMcMB1AZep4izrVo0/fLvpY6jBr0otaGkqGo0HT6BaIWKT5T3Uz2v25kQUP6N01STZDq7JwnVNvnmBeBGhgQUUHp9kV4rkQZG5J7Mkd0hFSGVfm/UAacD5OPtGBwGIPvOFWHUH0vqGk/bxR4fGuN7OU3+TvfO0a9JYl+8FeSb/VZNPZA0aCkd5mmC2szXetZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDdpTnBueHh2KzdYZm5lOTRFTGNPU2VCMjNyUm1kcUNhenRoTG5kUmljWUdi?=
 =?utf-8?B?aWpTdnk3M20rQ2pCM0NFZ1NkeDN1c1gyeDhmZDArUC9IWmNmWGtNQVlMVjc1?=
 =?utf-8?B?Vi9oTmViZWlYRTVKVVY3cU9yYWJTbk1zNUZXYmNjRnc1M1dwZ3c4ZHFLck5x?=
 =?utf-8?B?Q1ZnOTBiMnA1K2k4ZGhCQlFETVFKcWlTc2JMdU9RY1Q1WHE3ekxsTVRuL3dl?=
 =?utf-8?B?ZWd2dmNyZkpndTVxUUJ4OHA4S3UrbG9BL0V3QmUwT1czck1tZmFLK1pMUDE0?=
 =?utf-8?B?VEhEQlZYUkpEcjhwZnlmZVluMzFFWTQ1Ni82NnNwNnA3VGdxZFk4MWU4aERk?=
 =?utf-8?B?K21oRnd2UXNyVVZXZ2tVanJEL0t1TktSWHVCYXp4bDZuL01MVlpWUG9MamtS?=
 =?utf-8?B?N3pVam0zTHJFU0JOUGJma3ppcXFmalNMdnFwNFJJRkhMTU9ZMzh6RmZ1MDZS?=
 =?utf-8?B?ci9SUlZHeUdoYUJ2UXBvU3Z2UUVETTZWQ25DSDhLemZiV2lWQnh3LzNWRHFS?=
 =?utf-8?B?QUVsYjhyOUFQTFJYSVZ6eW5ya2FYUmJDbWZnZml4WCtLalRkcWQ3Um1UY2NU?=
 =?utf-8?B?WXFvY0RETzF3ZG1jOEplMGpvSnBOd04vZ2M5MzdCYXhTUEZoN1F6Z1UxYmNJ?=
 =?utf-8?B?ZkF0VlVTTkxlUW1GZzg4a2l4eWlUU01SckFOLzVoWDFVRWNJclhPcm53VEI0?=
 =?utf-8?B?NWU1OHBwZWsweEl0MzM1a3JKNXpzY1pwUWZCcXFFcE1heHMrVlFPVm92YnM0?=
 =?utf-8?B?VmxtU3Ywcm9tQnN5OVpWSDdJbHF5eERFUmw0YzAxRkhnekxIbzUyWW9kMisw?=
 =?utf-8?B?ZEtjNSs4cnFRbGxsZjFyekhpNTI1L3V1M1krUGhtY3FrTUdzT1VFWUthQmJy?=
 =?utf-8?B?WkxJQnoxTXBlaXMyZ25BV2tTejZMcVVsdzQzbDJURXNaT1VVeWJDWXVxbFR0?=
 =?utf-8?B?MHk0c1gycGdTd1YzcWcvc0d6WUM5T0owZ20vR2RmLzlhaTJsRmRCcW80VEt1?=
 =?utf-8?B?NzFSTHg2MnZvSDdIcWxObzJSMU1OK3RhMTRFZjd1Wk5jbWxwbXlJVGlGaXdp?=
 =?utf-8?B?SUFtS3VsSGxNMS85TUswL3V2VDB0ODFRSXVrZmNaVFJHVXZ4V3dnZ2pTaDl5?=
 =?utf-8?B?OGZOb0dqV2RjZFdhcmhGZllQMEJrWVV3VHhrSEFMK2NpM1N0eXI2R3NLaXJa?=
 =?utf-8?B?NXVVOG9vUEo1TS9ub1hpSzBXSTdVaXZnek9IV1BoeWdZRzNJWjM4d0tsS3pt?=
 =?utf-8?B?R3JyeEYzZksxQVFFV2orcVN5WnFMMEZtNlpIUG9PeTF4bCtLMklTWmhzVDFM?=
 =?utf-8?B?ZVRGWjhFWXB0MkVFL3h2K2VPRUo0YkhxdTdDenduOVJ3ZUx3bksxS3hZUG9M?=
 =?utf-8?B?dUlxTDk3U293OU9uejVMRGRLVUl6YSt2a2xISzl3d2llanFlSFhUTjYycFFj?=
 =?utf-8?B?RGNWa1Q4YndzaU9VNGNRYlp1dm9FajRBRWFob05ZUWZKYmk0UkdzYjg2bTZt?=
 =?utf-8?B?WFptazZtaHZ1QTZVdWRCMTQrUXlYRjFwSno4Yk5jU3dWV3lmT1JOS1pEcXpB?=
 =?utf-8?B?WmNkdWJTUGQ1NGt3VFdTOW5SYWh4OC9Ld1oxaXRXVVI4WmRJaXdQQmFja1Ju?=
 =?utf-8?B?blQ4Ui9ocGJQUzYrdUxUNHRpMFV0dEszYlpWOUg4UzlGcC83UmRPZjJvQWFW?=
 =?utf-8?B?bHlJVGhydlRCWUVIQ1RrOVpsNUk0eEhMK3hKeTB1QUF5VjRBUmIwcnNrakRW?=
 =?utf-8?B?djFIcS9PQTdydmwxc1g0QUhUUWxxTkxUd2FzNkljWFJ2K3c5K1lTWmVtRjly?=
 =?utf-8?B?bnk2RmNMNU8yZUFJUU5ESVJBMG5PbXFOUjBOOFBWUUtoaFp1SllMVEVONEQv?=
 =?utf-8?B?bTdlai9OQyt6dlRNTTN1SFlYMHdiL0dmTC9ld2JTbGthVll5SWV4bnAwbU1O?=
 =?utf-8?B?b0xCdWk4OTFPemJLM1IwQm1oc0VBeEE4VEVKcnFtYk02aFNJbW5LOEpBdVNr?=
 =?utf-8?B?cDJVTEY4b0lNT3d6eDZBWTdqNUlDZDBFZUpIWHVtdUdiL0xrcmtIWGlaazJV?=
 =?utf-8?B?RTF1Uzc5RHc4Y1BGTzZYMllPNytKZFhINFZ1MUIwY2NUWjJFWHZwUk00TktG?=
 =?utf-8?B?UEFoWEUyVSs4NkdUZ2NabFFBYnIrYmI1UllyMFRrdFNaVy9YbEtrRUVaazRQ?=
 =?utf-8?B?dllqWFpGUUtwZGt0M3U3d3dseGxPZzc1NUJHcGlFZDZqZFVXMm0rL001WWlD?=
 =?utf-8?B?YnhJT0hoSnROVFFQdTBjNXlEVWpuSk50MERCSkY5Z1ZXUDZzdm9ONDVlUzBo?=
 =?utf-8?B?M2tlUlBBUW44SnJwMk9TUnl6Y25MUWZvRXN0R29IbmpTMVhIeW9VZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: d47207c7-0430-4dcb-85dc-08de90afa047
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 12:01:51.6934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oKxm190M9ymph5uw72qdcU7vq+eGjMoLfdCCAE2x2K06FBoCGpi0PiDl7lBxQylYZER3TVyLd5uLv0JfTwUkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB9086

On Thu Apr 2, 2026 at 12:52 PM BST, Greg KH wrote:
> On Thu, Apr 02, 2026 at 01:27:12PM +0200, Miguel Ojeda wrote:
>> On Tue, 31 Mar 2026 18:19:44 +0200 Greg Kroah-Hartman <gregkh@linuxfound=
ation.org> wrote:
>> >
>> > This is the start of the stable review cycle for the 6.6.131 release.
>> > There are 175 patches in this series, all will be posted as a response
>> > to this one.  If anyone has any issues with these being applied, pleas=
e
>> > let me know.
>> >
>> > Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
>> > Anything received after that time might be too late.
>>=20
>> The pin-init change does not build:
>>=20
>>     error[E0425]: cannot find value `__refcount_guard` in this scope
>>         --> rust/kernel/init/macros.rs:1320:25
>>          |
>>     1320 |                   @guards([< __ $field _guard >], $($guards,)=
*),
>>          |                           ^^^^^^^^^^^^^^^^^^^^^^ not found in=
 this scope
>>          |
>>         ::: rust/kernel/sync/arc.rs:529:49
>>          |
>>     529  |           let inner =3D Box::try_init::<AllocError>(try_init!=
(ArcInner {
>>          |  _________________________________________________-
>>     530  | |             // SAFETY: There are no safety requirements for=
 this FFI call.
>>     531  | |             refcount: Opaque::new(unsafe { bindings::REFCOU=
NT_INIT(1) }),
>>     532  | |             data <- init::uninit::<T, AllocError>(),
>>     533  | |         }? AllocError))?;
>>          | |______________________- in this macro invocation
>>          |
>>          =3D note: this error originates in the macro `$crate::__init_in=
ternal` which comes from the expansion of the macro `try_init` (in Nightly =
builds, run with -Z macro-backtrace for more info)
>>=20
>> (among other errors)
>>=20
>> I would suggest dropping these for now:
>>=20
>>     0565326613fa ("rust: pin-init: internal: init: document load-bearing=
 fact of field accessors")
>>     66655aacfa42 ("rust: pin-init: add references to previously initiali=
zed fields")
>>=20
>> Cc: Benno Lossin <lossin@kernel.org>
>> Cc: Gary Guo <gary@garyguo.net>
>
> Crap, I just did a realease.  Let me go revert these and do a new
> release with that fixed, sorry about that, I guess my builds weren't
> testing rust on older kernels, my fault :(
>
> greg k-h

It is probably missing a dependency patch. I could take a look next week, b=
ut
perhaps not backporting to 6.6 is an easier solution :)

Best,
Gary
