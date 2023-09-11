Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2112.outbound.protection.outlook.com [40.107.114.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F7A28F9
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 23:16:04 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4Zms6nvXKLFqaK/Yzz54ysiURpfV7IAhW8xnaDqbr79qjPTob2EO8Jbyi7WcnQox4PYSsO5cCQYmXRbW27uxvhFf9zHn+sIYwKDTadtjfHvPhxXynt9FIYQw3oyQdPeBW41erjd5g+vkSbcy2cma96tX29xpq+a3YoavaQ9kCEY0SGNghf4Zezg0tm8hXXeGb8gUPBksWpaKTnRHxH5CmuEm6rXq1+BNp0/vWg04RBp325TJa6ESknaVTbVt59UbHrtTq4fGGIx634+/6pSEr6qHnc9GPfcnuvorp9qcJUHJwsoFUgqEbbPCu0nPKNDEGjm7vkjYbC8lPXhAS0kJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipqm6CioroLcsF2pUYQ+1ZUma2FXJSKDLcndMDFhxYw=;
 b=XavsjgLF4TrsMSznJ6VmyONSsCT659Hxzz3QiYnTM/pkcZnNDP4rCnv+y5bs6pxDfYLqryh5HbP3K8Ar87+8iFCL7XW46K/+gpj1ZYKMP1B4eaVo2lIKbFJIR03AARFmTNFcAzNs9u70zgl8Al4uVAwc+9SYoTfnx19NoarqJfyrMrLn3z2OGk1mFj0N7HdZSSXa9+OitgYnHw4UDMBhHSM1tHhzSWl5CymzWarcblOaMQXwhthfUujvMeVK76WfbZMknh1E6RWLN2kQobt0fzUmZF2oafb51K5iz+vwlrrtkujW8su4Bcp1DzlJwK80fi9YbtPrZJ2fdehbyC0klg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipqm6CioroLcsF2pUYQ+1ZUma2FXJSKDLcndMDFhxYw=;
 b=NYE8tRvtyM19LDcxNWp4NfZnjtXeZvLcgX2ns699xu8XlZynU628iFVBuyvvf5t9giEwcMDcnWmT5rVg+IhOgGxh8pC+P4E17jAo91N1t26QcLEhphbA9LcuKLrgMFUB+RHZ8XTzSf/VLC+PruYCbQnslHvDDRT8kQoILy04uZQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by TYCPR01MB10429.jpnprd01.prod.outlook.com (2603:1096:400:245::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Mon, 11 Sep
 2023 23:16:00 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::8c08:d94c:8e54:9b5d]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::8c08:d94c:8e54:9b5d%6]) with mapi id 15.20.6768.036; Mon, 11 Sep 2023
 23:16:00 +0000
Message-ID: <87il8gs3m8.wl-kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 364/739] ASoC: soc-dai.h: merge DAI call back functions into ops
In-Reply-To: <ZP8oM04ucZJkxXCS@finisterre.sirena.org.uk>
References: <20230911134650.921299741@linuxfoundation.org>
	<20230911134701.316565214@linuxfoundation.org>
	<ZP8oM04ucZJkxXCS@finisterre.sirena.org.uk>
User-Agent: Wanderlust/2.15.9 Emacs/27.1 Mule/6.0
Content-Type: text/plain; charset=US-ASCII
Date: Mon, 11 Sep 2023 23:16:00 +0000
X-ClientProxiedBy: TYCP286CA0130.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::12) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB8426:EE_|TYCPR01MB10429:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ac3fdac-b104-47cc-da7d-08dbb31d0fde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zeOUNHwbupC+TQuvDi9hcA/pTvs3PrDfaaZvkIBGWMhp4xdMitklKIDswvfOuIeAdrcaoTX47vjF1hL4r7L6wBrcEUV6ik5f0p1F6W3zWAcarZanQghHqVFLPRQY7AZIMxv36FgRYTki/5DZAcEQ7sN5fYtA1hRW6CwNWf16v/TYJ1FVWjMJnFMk+VT/btllWelYXL5yeOTrYivrjB1zR8lz6yN/58ZThsEMRmaj9prl7mpjnm8VZvdmn4ttTh3mLjICpjbIx0k1kNlw2JmdZCuDNbXs7xkZ2/sKQbGkh6rWU6DwdIscy08nU9q65U1qbgvB35jb7RTpkjoFFKDoo//ANR7BBWG4pMF/xm00PHAzvB+bVb5vCZxLjRqI3A0fxb+38gWRkUB2xFZLcSAGZZECaAcJVdfq8PtBX2xc82rwo1jTJYHEKSXoK7BwoQsGbtrsNldjUCREhxeFW3M4eo7+dOwRgpSjUUcAoyKI2ygIKSAqYibt5JgWNBnoepvLc2dBFGWK8CEOnEnMWdrv+nQNBipTCfPM80oKR+F3j8ME7YhxU1eJtpkZeGLOomL5TQj6soKcL29iq83oRr2kZ8URUcKmX2ol5RDYz38PdcxH9pdaBJ0L00cSRam7aJbH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(136003)(39860400002)(396003)(186009)(451199024)(1800799009)(66946007)(316002)(6916009)(66476007)(66556008)(54906003)(41300700001)(478600001)(38350700002)(38100700002)(2906002)(86362001)(36756003)(5660300002)(4326008)(8676002)(8936002)(26005)(2616005)(83380400001)(6506007)(6486002)(52116002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wf3CWgutJVwoyN/SL+R+H/9wZle0My1CjssQydDIIE4scRQ8dAuyVSJj2b0Y?=
 =?us-ascii?Q?QMtKZpK9AiUM8wXD35y6nf3etCzDH0uL4uOxqBIvjxbT81xzSMZ8ehVqsro/?=
 =?us-ascii?Q?EVEM2xjGCFyzxDcNlGICz/yuZlVVFIA9y4BE1hD19WKg1/oJ/0K/AafibyBg?=
 =?us-ascii?Q?xHnz7Y3xCa3P2U6+FeL6D2UNcTbY9lWXvsr2+q8LygQctkW0RuI31rtBVuTm?=
 =?us-ascii?Q?8NncoizE0ZFYHSltIzidarupEPU30insxETfrVjOZR+ad4/2pbmCsIuWrAW6?=
 =?us-ascii?Q?zxg/c7e8EQpPRgp/Gs3DpbMzHFMHayBnSZFi6BCvnyxwHkIQbHkv9WWDAnNz?=
 =?us-ascii?Q?QYcg0JLS9qi/YBpZ8eJxN1CWbihkBf/d7ZKfOKsQ0kn4mvDIGPHVgJLdZfex?=
 =?us-ascii?Q?dpwneL7shq3AfCbJ6rwOcj9S2aIJw++yaMOeGKwangqejc7d1NEL2vNbXvxf?=
 =?us-ascii?Q?yD8Vz871U10T6f57cITUxMDzK2KahojdZ4FoEI4Mmc9Ej5JuWdopber/C2le?=
 =?us-ascii?Q?VENiQD0zt1CXJnAp4UXSXr5iTBecDwSE6ZPWqXlcZDnvpAl+v8x05ZI4sJ3l?=
 =?us-ascii?Q?ZzTM83WuPaC5gqX9REio/OCGUQDWAUxzzeHmsK6hvaH3OXXr/zTMvva23ogP?=
 =?us-ascii?Q?6Qj1TGOrLt6r7Aq+iyNjFT9Cmsa0bBslk5SA4tRTu1ZHh5rKVLuz1EgGELUj?=
 =?us-ascii?Q?3Ozfz0seoez4CLRNF+wuez7LAJRsX2KUvpR+Bd7qNr2dYtjJoigHDEQjCExq?=
 =?us-ascii?Q?w3rG5/IqvqFanxT0DVnR0YFsMKvzg9eh3AMpwa9hQoqy0kq2VdobpxnBJl63?=
 =?us-ascii?Q?KsAtp772425RcUpIBfdSC1MlP6pRZ9/qQZA26Sk53M1IqYy/rBAni5G5Czdd?=
 =?us-ascii?Q?uFvVBo5jSXwPuyNbWe8WVEaGMsdEfHTYlpmWPYpLeEpZXtsyj0R66h+SzIZC?=
 =?us-ascii?Q?hOkrvL/eSbRVUKN2zWYtef7vrjZCSPpY1cW1wUzcNRhYr70FSZtFpYkkb/8C?=
 =?us-ascii?Q?XBotCeXIH9rjhJWMVLWpjcYkSiJvXXZrHVpFv+Zt+s39KTrt/jrmq5agT6XD?=
 =?us-ascii?Q?nBYYTJnCBU9sPDZIb0eGfNGijR1UGzl8dw+kent4XKkmsQCWjeOJQEOq+6H9?=
 =?us-ascii?Q?tycOPwYXs/dwxFBSY6H4UbF4s1KfQkudLZqZjgBP2fE3AHxQcPw3ykKqcNgn?=
 =?us-ascii?Q?nP5ktR2N3KYxqMZc5U3sUvRIP9i+NBz4s6DkYASU1Wpw11lb8JqMVjjcqoHK?=
 =?us-ascii?Q?BcMwXA3DPe2sFY5SYVuDzSAteQe4QkF1SV1DpgIY14kEarzAUfTRu3cc17+q?=
 =?us-ascii?Q?c6Wwv6IEThg5utQs/p94brPMQV7+2CTSnr/jrHCZN63/V8hbSZ/ui+zOVpw3?=
 =?us-ascii?Q?FbmV/TG9NgE04p4Nb8EQYL715pp1JET5BFDWas4kHTpENA3LsRAjmA+PZ3IR?=
 =?us-ascii?Q?s2TNzT9FrPkPxtqtcGo+2tTL7r0EdQZ6V01mfUnTM4KnEXQwe/o2Gha6+z1i?=
 =?us-ascii?Q?to0oeADUU3p191vwsLdMFXMd9ea4vKYNATQWFNuUhovUje77hotIeBNbAH3T?=
 =?us-ascii?Q?3MvB35mH3wNkCigrrVngP0ghamMGqtmuFEDhDXpfeZsAf7QTkjNMJfhtIbVl?=
 =?us-ascii?Q?e8+vrWkAO/9y4yGS4Sn+3VM=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac3fdac-b104-47cc-da7d-08dbb31d0fde
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 23:16:00.6176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nj8UntDBoE/MwNnkL7g7PV4CM0IO6Cdjfhvngrf+AhZ10lReIVl793iPcWBkK5v9/eKqw70xecQL1B/EfCBnyH80llhiRA5bEvcSTBWYD6XbR26ZY8Q9pbkDKWzhVWry
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10429


Hi

> > [ Upstream commit 3e8bcec0787d1a73703c915c31cb00a2fd18ccbf ]
(snip)
> This is a code refactoring.  It is obviously not suitable for stable,
> it's not even a warning fix or anything - just a refactoring.  You've
> marked it as a dependency of another patch which is doing the
> refactoring in a specific driver which obviously shouldn't be being
> backported either.
> 
> To repeat what I said the other day in response to the other wildly
> inappropriate backports (one was an entirely new driver...) I thought
> that there was supposed to be some manual review of the patches being
> included in stable prior to them being sent out.  How on earth are
> things like this getting as far as being even proposed for stable?

I have noticed about this, but my guess was that because this each patch
modifies driver file with wide range. Thus, other main/important patch
can't be backported without this patch (to fsl/pxa) ?
(I'm not 100% understanding stable rules...)

Fortunatry, this patch-set adds (1) add new style, (2) switch to new style
(3) remove old style. We can keep compatibility if (3) was not added.

Best regards
---
Kuninori Morimoto
