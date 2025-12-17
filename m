Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96A43590D9
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765979383; cv=fail; b=AEYAA9MEJHYlIemVAl8P/zbQSNmSIzg2JiNn+mqQeSNI5Szcb4ZnBeVE4fZyod7L6ATTKP/9A4qZPnnT5t+KbnrkdE3n9DTrBlrP/hNO4R66mN0NwgZfhmov8KVtVr6bflLML3DB8FuyE3Ma3Xcr8HIFg1k9JlICCYUon4iiU2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765979383; c=relaxed/simple;
	bh=j9un7z1JDg+aJfq0BUgUcwjSRzz9IOQTXAB7gHTnZTk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d7q1kwvtGeEi7dpdrKbzuzdyPGEbQVTwVx2+MRLTW2tnpoAHNCeuGf+Ollb+vZJnM49Jd2gIQJGSGmzIGPu399tfMOlvN4DLXXRqMXlRG+uf7dLLlfsJeaT4ztnO0vU7BWLPhgx69gF3opW/+Z47lqeLLS1bJ6tj4WiotpRoAMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pUR1V4K1; arc=fail smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pUR1V4K1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDCCC113D0
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 13:49:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pUR1V4K1"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 17 Dec 2025 13:49:40 +0000
Resent-Message-ID: <aUK09Gb_T_AdsB2J@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id B05412327D
	for <broonie@sirena.co.uk>; Wed, 17 Dec 2025 13:40:25 +0000 (UTC)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDA3F601A5
	for <broonie@sirena.co.uk>; Wed, 17 Dec 2025 13:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 99BF5C113D0; Wed, 17 Dec 2025 13:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C407BC4CEF5
	for <broonie@kernel.org>; Wed, 17 Dec 2025 13:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C407BC4CEF5
Authentication-Results: smtp.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dxz3gKVB2rm42rITiR4xTEa+XjNGttfKIsaBYgx1nJwz7UPjhKooKYan3zocEPJlke9766WhpLZE3X/yxvXCBBU2B5m4vu23kgsRJgLZDLAQTp23DiigYQ1cFkHZ1c7YyMsbaJtreE9/p4EE12f2un2B2qWdnZSULIVKdHvejEJxbF+kLDhMjr/b3q//2DhqO1L8SGRhcwR+T5WZNEtVRe4jntrP5ohrijBgPdBRD6A447yBO+DNAVxUMzp6vh1v1DTQXZuvmSEVfKqEKm4ob7RYJR1mv7f4+CXXD6L5fsR+Y1aLvhev7BnDLs58FgJZd/6Ep5HUEM1Zx6+9lOV0jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3917HojGhxqdKMIlAQgYOxBNOon1L7QSuBMl2SURzU4=;
 b=BMqy2w2MeUaNKeIjrV+T18D9zPkO+s9U022SlUzQjPVvFYFXM3NXBQQlLMrGr6O0Xx51sX/16EBFO17YK6I67gQJLkjOSp4tF8NaV8MxJX8RxwWHyrWKwNsWArFDhI+zfTnzTgH0NTeM4xC4AGsapQaZWhZaLe/FqEfc7/oHnguatzxVi9Opdids7q8Wlts0H+kg+viCyzsRQ3e4jBFTf+cK0/evpuqBA1TBqrXzNF4k7R5z8zmVircmv2SH/DT4t/yA0UCkH7sY6o18OUOq1e5npcs9GnY7mSoMcWdwYOuFazlcc3QlTyTMQ5hRnsHqxBeE9ITZxjm6nnlj+bDWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3917HojGhxqdKMIlAQgYOxBNOon1L7QSuBMl2SURzU4=;
 b=pUR1V4K1ZW1cTAm1YMwI2/CheaVIG0iMv5Q0QsZpNOsU02it8xjZgtiH7iBDHiGbkszUDGMxp/XN6pJ5+pyAKdN8sVd1Nb/p7r4A4ASS5kDONbbUG1ciml2mmKtsisE/UToyMLkfQRprWhF64+mIhsJMj5Zb/iXyPjdAnQup1Nc3/dtOqB5R+ra8mC1tY73f0YgVB5gGpyBGf2jtJPDhCLqVG+Y7zkhwbsWz9PTUSzG5bWxQjf6JbouFz2dsJZ7y3JbZFEGwloMf/T56nCoVzlOAGUNZZxvxmr7hDopeJiEtaTxDuTmm2UyJ3RorAThSnyUspnmhyldkqCduB8X7og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH1PR12MB9622.namprd12.prod.outlook.com (2603:10b6:610:2b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 13:40:20 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%7]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 13:40:20 +0000
Message-ID: <41cb1bac-5503-4765-b45a-200963448e5a@nvidia.com>
Date: Wed, 17 Dec 2025 13:40:15 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ASoC: tegra: Revert fix for uninitialized flat cache
 warning in tegra210_ahub
To: "Sheetal ." <sheetal@nvidia.com>, linux-sound@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, Thierry Reding <thierry.reding@gmail.com>,
 Charles Keepax <ckeepax@opensource.cirrus.com>, linux-tegra@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251217132524.2844499-1-sheetal@nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20251217132524.2844499-1-sheetal@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::33) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH1PR12MB9622:EE_
X-MS-Office365-Filtering-Correlation-Id: a848dd4e-29fe-402c-ffd5-08de3d71d23d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzVCUDJGbE9zQ1B6bndjMXdMVDU3M1hyTlRGaVJQOEc0UDFjVmpoUUpKdDlG?=
 =?utf-8?B?djUzU3I4Ri9PM29TU3dQR2dtVGtqUmxYRE9hbkh3dG9tT1FVTld2dlFXT2o1?=
 =?utf-8?B?QjliS2VoaTVuTzNGY3pCMXRJWnA1ZFZjRURYVFNHSjZRcndqeHh3YnFoTmkw?=
 =?utf-8?B?ZEFxd1hRbEt4ZXRpRjRYeGp2MU1tSlpzenBiVkJyUTRZMlFmTityR2pvdi9j?=
 =?utf-8?B?aVZHQUhCUVhyTkN5TU50aVJVRWtJV29ERGJMYk5uZGpsUk8rdTllLzVnWmFX?=
 =?utf-8?B?ZjJTNTdVMzgybm5MSkJuWmQ1RlhmcHIzU1dBRjRhdytNSEp6alRIdnE3NjMy?=
 =?utf-8?B?WGRubUFqNGdpQmROUEFuU2dSQVdIdGtFMmRDeDdPS3U1WHBSQy93RUZuQ3hh?=
 =?utf-8?B?c2MxdXZGTmozaW1vcmwrcU1MaTJaa0F0Rm1DTXhHN1RHMW04RE4rNWhiQThM?=
 =?utf-8?B?THZNK001blJLQ0xKV0ZEQS9uQkNiMlNIRyt3WUZMdTlqbUsrSGdkUlJOYnFS?=
 =?utf-8?B?azNlQlpraDE0NDd2UjBUSkVMQWsxak93UEZXVEZLd2Z6Vk9nZlY4ODBPKzFR?=
 =?utf-8?B?QisvZTluTWR5NTYxU2NXOVR1SVQ5amJZVkxCMXNpRFZaU3NCdmZORkhqd1A1?=
 =?utf-8?B?blpIZDJaOEtTY3VUMlNLeDllWGpCQ0tiS0FrUWxrWVBRUDlxOEQ1OTNmeHcr?=
 =?utf-8?B?WHNSVXVSVUZXajJGZGx4MHFuV0NZRmk4bzlQTEhaRFA1cWc1SXdmSWJWQklQ?=
 =?utf-8?B?a0lnMUFlenI2czJsYVpQTGRaU09NM3REUG45dk9qMUtROUZDTFNoR1RHSnlF?=
 =?utf-8?B?ZTJsd04rS3VSbGk4cXg0bnZmNzkzZ25wZkxpSW9rQmNMaWNVdVNxNnBZWHhm?=
 =?utf-8?B?ZzdUVGlEckwwMzdNNzRqbVNabEpQYkt1UVFIaWg1anY1RW54YjNmZm8wVDdN?=
 =?utf-8?B?K0pacGdjNHFJQnMrZkZVenVpdjNsSm5DTUx5dEZQT0xCMThJY0c1R1pndGU1?=
 =?utf-8?B?NXlOOVM1dFl2dWhPazByNEhjNVJPbVZaV2gxM0FuaVhCaW5uRkF0MktobGF6?=
 =?utf-8?B?b1BIaDZYeGVrMnFJd21qeVd4UlNTSzNrbE1FM05HaVgwTEhjdTUzU1crbWZo?=
 =?utf-8?B?WHRSVUl5ZEhWalJMeTFFL3h3M2NmR2xVVzZlWXJjdm43TmxCbkdZa0xsOHF5?=
 =?utf-8?B?dCtVTkVub25kUUpFWVdudURGRmc4STN3RnlTSEFDeGVUZGRMTmp3N213R3h4?=
 =?utf-8?B?ZW0zYmRJa0xQbTI2OHZEcDYrMEpUT0c1QjZzbmlHb3VFcXdxZWRMV3hrSEZL?=
 =?utf-8?B?OS9GREpCTG40c1hvTU55RHZYUXhCK1dRZlNHZjc0ZXpIK3BsWXg2UnFhOXli?=
 =?utf-8?B?Wk1KUGQ2RS9UaXFEbU05M1hDOVZOVU9JUmQwZTI0U3A1Wk95YUFhOTdISVBK?=
 =?utf-8?B?Znc5bjZyTm9IZWFYV0JCQzIrdmk3cGNmbnhmZExaTFVGQTBxSDJNQVg1TzRQ?=
 =?utf-8?B?b3lnZzVCYVpvTFJCaVMvSlUxUWxQdlp5NmdhblJRZ3VieTBicTQ5T1FzR0Z6?=
 =?utf-8?B?dW84bFNETmdiVzRQMmJYTDBvU3RiVGFMQlZqWVdDQmFXZm9RUlFUYklmL3Ny?=
 =?utf-8?B?RXBnTlIzUm1qeDhUdmp3ZlZjYk92VU8zQnBJUDFBUFhPWjZEdUJyQktBaFMx?=
 =?utf-8?B?eWx2T0NlcytKY0wrbUI3MXZJS1FwV2NPSzJaQUJxZ1BVMkoydFFVSVNzalJC?=
 =?utf-8?B?NG1rZFlYc1JFSlc1djdMVU90a3FrL2s0ajJKeldDSWhyRmF4cWExaXViUS8x?=
 =?utf-8?B?K2Z0Qk9Rd2tOQ1prTEt2UUt0VCtQcm5oWXhoTUhkTWZ4bjF4ZnpVeG9iK3hH?=
 =?utf-8?B?c0MwUjRndGtRbHJLV0k3bUVENXhnZmVzTjFPelhWMWQrM1ZtWm1HQ2c3TW1w?=
 =?utf-8?Q?jMVJhsOZPz9yCNNLxx0MAd9ByemSQxkd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1hFdmlodEZqb3JTenBmOWpyNGJoVEVHR3NXVjBxK0gzZmgwUDlBZ09hdVA2?=
 =?utf-8?B?bEpFN3V6UWNrNXNDRTA3dVdqTGloRjJxWEdHSHlJNHpyRTdGVGZma1RIWm5u?=
 =?utf-8?B?K1c2V2pOcENWUndXYkpNVkQ2UEtLQXhFWmErQkNIajF1UTFxbFpTM2xVd1FD?=
 =?utf-8?B?QkxhdGR6RFEyV0E4d0ViRjFib0ZGZVhDeU9heW9yK2lXL1M4TlJpMmMrblN3?=
 =?utf-8?B?Z0I4b1NBN2Q5bFFzR0JaTVh3VUhyWWlWaWVhZ2g3SW1XeHVYZm1MSEJWVUlD?=
 =?utf-8?B?Zllza0lQSm1ZcWx4RU53dVBpVDgxMDcyN2MyUVU0VU9ac2hlTHdtbXhveHdZ?=
 =?utf-8?B?Z3Z6dVhzeGxRNEVCZnhjT1lhemwrMVVXT1I1dCt0MkNxczhYaGt6TnlqMUx4?=
 =?utf-8?B?MDZ2RGlNRityTjVBbm9QblRCV0J4OUQxYk5kUGpzaHVteHQxMzUxUG0vMlJr?=
 =?utf-8?B?aytIY0ZCcGpWNmxYdzlwNzdKYXVJVWYyY09USTgyNURMbUhvWU5XRTNscUlm?=
 =?utf-8?B?S3Y5QWk5NHdzZ3JQd2IzVUtmRjE1dVRjSGg3K3hhUDdtckNsSDlFTGU4cUt3?=
 =?utf-8?B?VVJVbU51L0dMOWZrMHd6SmRPMUZoOGVqTnhnSlZDQi9GdHN2Ulg1bmJPUE5P?=
 =?utf-8?B?N2UxQnVLb1kxb0FTZ01xZEd5amxsK0dGN3VJNW9wZFhEeVZzUEdrelF5TXBk?=
 =?utf-8?B?UFNIalpHdWFMUkFnRC91b3IyRk9DVTRXK20zRlZYQk1ZWEZFMVVWRUFVemZB?=
 =?utf-8?B?eWx0R3E0QVhRMk5IQ083N21PbVRqT2JHblhRYnZ2cGcrYm1HM09SM0tSM0Zu?=
 =?utf-8?B?c1plRVd2OGpTRm1lSzgyWlhhbmFFWmpIekcxQ1lkMmdYMFB3eTMrcm5CRnlT?=
 =?utf-8?B?dTRlSllXQ0lIZjRaMXV0enZ5Zmdudk00L3V3M3M4dFRDcGJBUDNOTFNpOGxi?=
 =?utf-8?B?MzdVOVRaYThNeVVTVUI2azJySDNFK3c2VmV4UHRCS1ZVTmRqQ3MrWm8wM2tZ?=
 =?utf-8?B?TWJaK3UzcTFTemJvMUZzUk1SaTdrUVp6eHFSMmx0ODJEaEo5ME9PSlcxRW5C?=
 =?utf-8?B?em1yVWszWGUvbWQvYUFnOGN2R04rQzNiOE5PTWpqZVBRS3JHcGllMTB0NzNN?=
 =?utf-8?B?Qmx2Z3M1QjJYR2FLWi9CR2RBRVdXTTVwNzArVnZiY3IrWnBxWUYzS1FTS3FG?=
 =?utf-8?B?Nm9KVlBxbElwUW13NUpXbDNNNWkvQkxlNWk3LzQzZ1NEc2FiMXBWSE9Ed0hI?=
 =?utf-8?B?L1lOeTdRTXQ5NzNneWcvcnNmTkxuQms5Y01KNFNvVTcrMis1MXBoanVYeFdq?=
 =?utf-8?B?SXdYYWFIZlM1UFVPckgrVk9mTkJ5Vy8xZWJrSFlHZ2p3MGdBVE9RcFQ1RkFh?=
 =?utf-8?B?U0FiVlRkc1MyUWdvcjlwR05wNThKUmI5TzAvOU5pQ0FqbUVYLzNJWkVyOW5T?=
 =?utf-8?B?RU9tczB0L3pUeWdhZFNUdmtkQTQyclpkVGY1SGV5UUlydjI5Y21mNGh1UDg5?=
 =?utf-8?B?ZW5ZcXNMb2NEeWtDM0VYQUtuWk5ydFZuMEFva3V6aHpSdzlOTGVOZGVsZzdv?=
 =?utf-8?B?dXJmeGkyY1Q2alVnNTU2a1FOYUdza1hPRmN3VktOaHlJZURMbmZCb1NXaW1y?=
 =?utf-8?B?eWp1NGNTcnpSajNZSDcrSnZIY3czalRjdjF0SUtjNTRla0JSbDVSZC9NUUox?=
 =?utf-8?B?Q0xkdy9zVDB5SU54TStETVVzbWFkSi9icGlBeWJGQkEvOVlGM1REbDNHUFZ2?=
 =?utf-8?B?aFZjQWdDS2VnSE9UbDJXaGVEbzBhNEovOHRZb0NjWm1FbFJqK21JdVR2cUlH?=
 =?utf-8?B?MmU1N21IQXhDM0IxZyt2UDViQXpvQ1lUU1BtM0lBQW5ZaTZyeTgzTVFrNWFn?=
 =?utf-8?B?ZU9XMGxBMVJEK3pON1k0V2tJcld5dTliVWYvYUZCVFVHQUlRSUNYMXNyTS9i?=
 =?utf-8?B?TmlMdHFMaHhtZTc1Y2VyKzdVWWRHZVpiZ1p6d3dHblZmVm81RThmcVREeE9j?=
 =?utf-8?B?bkJoYVFPSzY2UjhVcmh6cEZmWEZTeDN6Zk1UMklqSlorTUlLOHYzbkpHelZi?=
 =?utf-8?B?VDhxVEV3TUY1OXByR1BQSEU2VGhTUGFjQW5CNmUvQ1VHWXZPTkdiSm82dDRi?=
 =?utf-8?B?blhVR0JsSG5EWW5vN0ZWOThMQTRlM0NuaCt4VDNhaThNNklWaGJxQnFQTmFQ?=
 =?utf-8?Q?LnQLm8FL01vQNY/h+sVGCcjV+JXCf/pl+v964otnFB4i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a848dd4e-29fe-402c-ffd5-08de3d71d23d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 13:40:20.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrR7eYytLlMdEhXoHhFEXV9UiperYLVP48XRnlf0m6x2iYso5Ki9aM65VCMZhBFOPnkxWnF1epZwmZ76pgvSYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9622


On 17/12/2025 13:25, Sheetal . wrote:
> From: sheetal <sheetal@nvidia.com>
> 
> Commit 4d4021b0bbd1 ("ASoC: tegra: Fix uninitialized flat cache warning
> in tegra210_ahub") attempted to fix the uninitialized flat cache warning
> that is observed for the Tegra210 AHUB driver. However, the change broke
> various audio tests because an -EBUSY error is returned when accessing
> registers from cache before they are read from hardware. Revert this
> change for now, until a proper fix is available.
> 
> Fixes: 4d4021b0bbd1 ("ASoC: tegra: Fix uninitialized flat cache warning in tegra210_ahub")
> Signed-off-by: sheetal <sheetal@nvidia.com>
> ---
>   sound/soc/tegra/tegra210_ahub.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
> index 261d9067d27b..e795907a3963 100644
> --- a/sound/soc/tegra/tegra210_ahub.c
> +++ b/sound/soc/tegra/tegra210_ahub.c
> @@ -2077,7 +2077,7 @@ static const struct regmap_config tegra210_ahub_regmap_config = {
>   	.val_bits		= 32,
>   	.reg_stride		= 4,
>   	.max_register		= TEGRA210_MAX_REGISTER_ADDR,
> -	.cache_type		= REGCACHE_FLAT_S,
> +	.cache_type		= REGCACHE_FLAT,
>   };
>   
>   static const struct regmap_config tegra186_ahub_regmap_config = {
> @@ -2085,7 +2085,7 @@ static const struct regmap_config tegra186_ahub_regmap_config = {
>   	.val_bits		= 32,
>   	.reg_stride		= 4,
>   	.max_register		= TEGRA186_MAX_REGISTER_ADDR,
> -	.cache_type		= REGCACHE_FLAT_S,
> +	.cache_type		= REGCACHE_FLAT,
>   };
>   
>   static const struct regmap_config tegra264_ahub_regmap_config = {
> @@ -2094,7 +2094,7 @@ static const struct regmap_config tegra264_ahub_regmap_config = {
>   	.reg_stride		= 4,
>   	.writeable_reg		= tegra264_ahub_wr_reg,
>   	.max_register		= TEGRA264_MAX_REGISTER_ADDR,
> -	.cache_type		= REGCACHE_FLAT_S,
> +	.cache_type		= REGCACHE_FLAT,
>   };
>   
>   static const struct tegra_ahub_soc_data soc_data_tegra210 = {


Acked-by: Jon Hunter <jonathanh@nvidia.com>

Thanks!
Jon
-- 
nvpublic

