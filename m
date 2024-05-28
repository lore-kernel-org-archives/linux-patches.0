Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E294A16D4D0
	for <patches@lists.linux.dev>; Tue, 28 May 2024 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716905898; cv=fail; b=ec02o9meibVhFrkR0HtyrnX91ooq024Zoj4uECz1U8IwPGL1pjz5UlwkSUIfGU1Dq7juo7DmduRLwtSVqampzcqlvBecbhZNFsIITiy8GmetX6F08KLg0WAV2YJiBaEaLTf1Y3t6g964tqsVkej7RG/L2BbSBAaKKsReKLZ1O3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716905898; c=relaxed/simple;
	bh=Hn1iKfUOmyxM/wuvAnx8UV13CLv4z8gdC6D4AP3Fqqw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SK1ilNS+Y26NRYqwz13e6ZfR9onf744irVCdo5HgwzLDhTatQ6O7+ZPbGWsfnc1XddKvQT599W17PW+aOmNiSeAyawYTqY8NEuJ/ga7F3fbXqEqYnRXO8DAkACHdAkiCUyWPYyDoiQ6KDUB4hc028j8DBXmtLzQ8AcA8s86aFHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uci2t2DO; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uci2t2DO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG0O2rxozq2Vdrm2xi+1JSuSV4c/2AGL2OE7cpkgtRn9RU0NqJMVzOULKUGFqRFtA6AT7ncpKt9GrM+v0fg7RApfp0syQgreAqqReizrBHagAVw2psWUTBVljdvYbTro7ouhuA11pKlbjGGsZ30lzGTAkIN6muqClXaso8GBkmgJvy6e1f4dLrvwSKoYMf3etUtGvnPn+8rDyvwG3ICc4zNlXwEkcdv+458YkX2FxChPAuQZcKk9w5Zpf6/9UuacB05uU+zIDfM5AyEpEQu7rs9D0nidwDNKzrs0lCBHYcPRJUHkY/dDpEAnhsualClg9Kz3h/lTGBDEZLGNMnidIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++kYen3kelXXnE2JooxmIIJRFJiU5oeduIYzBWBC/eU=;
 b=T2uameexAukppU0MFGS63WihORl7l8eWDudyAFEErA6/MRlnzNObfkIqnf6FC3lntL5MF+dRK+6jY0oJ9XV8NzY2qDZsAe5/Sg7sQYowxlqX5uvQYiPmfmHxrgLnEI8lHBkza+sOLlS55uE8/8t/FVCMCGbgnS7YH5OZo9Fb9ztmxdTjfGhcpTBcyMJt7+FSWt61pF7n3DMPyfkSAll9mxzefNpWNPqMsHrMDn/wr0ZYfFoofosaNBmOJDIma0eA4XXPt1kEfA3Lc62Tb6vDqM80Z1zSAR7MyxOmxT7kQU7kksYY9nrvHzJqEcBZ4FGt7oPSuXhquYXFj4ajEER9ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++kYen3kelXXnE2JooxmIIJRFJiU5oeduIYzBWBC/eU=;
 b=uci2t2DOftBSglljwilwWwaOFAKTiV4wL7jYqPJTGV0jkNROj+KqMBXh6b9uD9LzvgNrjjIyaL7hGP4zw0behCvg6UEAl9rzINU+CEDuTrxme1iwvbwXmIBnC7d7V93+cvoN0rq4YG2VuP40BakyK+olyDfBYN0MIObMXhWFCh6O2lk+5GdKh2YTnAhILWHqQ1EcNeDZvpW/TStEFFK6zp6aBnF7ZCuGvbwwBUNeflCMq170Ypzp/mbZQM929z7cKh98AwjhAIsCOmk4/EOurSG0TnDTOnRVRgPkFoGxvYdoO06Z+aDVqxxlMf73NEvHnwUBez0k0sKu2mBEi1YKUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.31; Tue, 28 May 2024 14:18:13 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7587.035; Tue, 28 May 2024
 14:18:13 +0000
Message-ID: <8b6fe99f-7fa9-493c-afe7-8e75b7f59852@nvidia.com>
Date: Tue, 28 May 2024 15:18:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Neil Brown <neilb@suse.de>, Chris Packham
 <Chris.Packham@alliedtelesis.co.nz>, linux-stable <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck
 <linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
 "patches@kernelci.org" <patches@kernelci.org>,
 "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
 "pavel@denx.de" <pavel@denx.de>, "f.fainelli@gmail.com"
 <f.fainelli@gmail.com>,
 "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
 "srw@sladewatkins.net" <srw@sladewatkins.net>,
 "rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
 "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240523130327.956341021@linuxfoundation.org>
 <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>
 <2024052541-likeness-banjo-e147@gregkh>
 <8ddb4da3-49e4-4d96-bec3-66a209bff71b@nvidia.com>
 <968E3378-1B38-4519-BB85-5B1C45E3A16A@oracle.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <968E3378-1B38-4519-BB85-5B1C45E3A16A@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::22) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DM6PR12MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: a93f2f22-ef61-4648-22e9-08dc7f21023e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWNzWkEyUkJnYVBySWpEUDI4STRqVWZOYjE4QmJSYWNrMW5od25uSWFBWHYz?=
 =?utf-8?B?TGkxUWVQdENQaW9tZThIQzVMZ1ByZkxMeUgvR3lpbnYzM3RrVndtWXA0ODFv?=
 =?utf-8?B?YWlUR3ZrY1pSZlQ5aGo0RWk0UUxDcFV3bk9QTnUzUGhldlVBZ3B3Slo4N21R?=
 =?utf-8?B?MjZ5QVF1K0NUa3ZjaDRZZ0ZlQjhaSElRcnFxUDBnbDkvelIwVjRqVm1tZW5W?=
 =?utf-8?B?aVhSb3ljKzFvZ1VoUkI0cFJzMk5BdVNhWW96SXZURyszL1lLYlZ0VTA0SEtn?=
 =?utf-8?B?WkNWUlpZYTJDQnVRY0xvZWs1RUJHNzdTb1R0eEV1SUxIenIvekNEWHNnR2hG?=
 =?utf-8?B?aGI0dERFR1J3ZmFkTXl5QzZSczA3UXRDdXhvUDNESnRrRmdQNVBrNVBvRVM3?=
 =?utf-8?B?ckJXQXFXYTIycEZac3NST0NBZHQ0Y1NmMExYOE1nc3pPUjkwNEd2cGluWXlD?=
 =?utf-8?B?alhQWlVpQnhZaUlORHRuSkl6azRQY3VmNlN5UE5BT1BuU0tRZWdpRXlobWNS?=
 =?utf-8?B?N1RZSHdVSk0wa2I3NklYL1pxZzZudHJHVUhENkFLSFRPbjRNUENWbEJVakpS?=
 =?utf-8?B?UFBXbXpaZDI0NlhCT2pDKzZCWGlGcUJ3NWRhaFd2M2x2eEU1cUx3cmt3Y1M1?=
 =?utf-8?B?YXROamlZaGozek9ocURXWGhTbzQ3ekFFc214QmVTbm1xOWltb0VBek9YOHBP?=
 =?utf-8?B?YWNRR2cwelU2Ty93Mlkra1krTVpWWHpRZFFkUlhtbGxMOGxsdHBhSEJudSsz?=
 =?utf-8?B?aFNGQ0VIMlFua0FjWlU1UEhHcStqY1h2OXVqdmpiZnNJNlMzN1BvM0dXY2lS?=
 =?utf-8?B?NGppYkpnTmd0bjhIV3VPd1JYcWtCdnhZUjlROThudzVDUTlZSTZDZFducXRE?=
 =?utf-8?B?SEpuWGtUWUVlWERRUWxpR0Y2cWNBVGtqWmV3UVhzSW1NT0p1YVNkRnRBbXN3?=
 =?utf-8?B?WjJMR002UlppQ1lFMGU5RTdJczhsS0lzTGZ5MUJTdzhhUEM1c2lZenVJcnhH?=
 =?utf-8?B?Mkg4TE1vTUdPU2pSZStvWTNtdVkyR0ZwUTY3N3krajZsa1czNzdQeFRpVkhs?=
 =?utf-8?B?b1puYnhqUDFRK3FhSzQxOU1qcWFsdWdjTVIwUzh5YUxQMTJDZ3lGZk5lWDhx?=
 =?utf-8?B?UWVoNjVaTVpRNElIWEgvcit4UmZxaE05Z25aM2haUkllZzNiZTVvWjV3ZUwv?=
 =?utf-8?B?V3dVVlQ0KzZtNmM1QkZhUTVEK1RaWDlhMVd4SHV3SmkyUCtPcGdqWkFET2Fa?=
 =?utf-8?B?WFhGQmpwOXdhVTZ0blRuNzZ0VXhPZXpwUnF3VzM2ZXA2bE5YVE90UGExTFRF?=
 =?utf-8?B?VXliNXo3cHRLbU9Rb0VKSDE3UlNLeVhFek8wR2EwaFViR0JuZlhxRndiVUdS?=
 =?utf-8?B?U3pUem1vUFN2SXk1MitORjdPZHl0MjErbGg4RG5kWTRicU1oRGpIMiswNkNE?=
 =?utf-8?B?QmtTcUVhZE9Ebm1ocC9Fc1ZtNE0yYVdRckpIWWZEUzZYVk1hNEI4OG9pdHBK?=
 =?utf-8?B?b1dtWkdaTUkyTWlTTE1jMTZ1WWNCaVJHWmhQN0s0UnRCaW5hemh4bkl3WWNZ?=
 =?utf-8?B?T3d0aHoxSUc1TTh6Mnd2U0pRSlpsSDl2alB1NnNGQVphL0dMeUxmenJiWlZ3?=
 =?utf-8?B?clJIMVpiaTg0Qm8xOGZ0T3NTVEMwM1V6ZFFka1JOOXRoNURVSEJFcWdiS1NG?=
 =?utf-8?B?MTdXM2Q3TnhtWFkzYUd3b2taeG1kL3JmZDFuNDNhN2NEYWN4c2xqcWt3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHg1c3pyTFpPN09nRjFib3ZiaVV2TGpTRUF0MmRrR0t4eGV5cTZaNkRRcUds?=
 =?utf-8?B?RGNPTTFKY1hacE5jZFc3NStvS3J6Yk4zWlRsaDA3ZGE4MEt1bndLTlVycC8z?=
 =?utf-8?B?NDlNRThRV1hxM1Y5b2hXRjcwdlJ3WkdubWRaZUZwK0NYUngrbS9lMWJ0RUVZ?=
 =?utf-8?B?bG9oTDhFSWc0SVVYQklRSFE4cEhTekFyUnpBcmtYM3FTUDBleHJqbEVJclJ0?=
 =?utf-8?B?SzRlakxvQkhMaDdCZXZZZTIxTmk1YTFHTXdjcXQ4dVViams0OWNmRG0xVnlm?=
 =?utf-8?B?RmxOb0hWbXpQS2hROTNycVphZXRQdXJaNVEycTlRUXBFbERxOWVyZWdGWHJv?=
 =?utf-8?B?SXMwRWRTaXJscUJiSnVqckZSSWJrMnUxUUhwdjlDdXVLQnQ5SC8yREY5SGd3?=
 =?utf-8?B?MEFTK1p4OWttR1VPNllWRi91cnh0OUd1aGJxNDVrbE4zYzJ0aUpsL2kxQ2RB?=
 =?utf-8?B?RjUrQVNZeEk5aDRrNXZuYXc4WlYvUVBQV294VVN6Y2hmVktuNTdjYUlVMEsw?=
 =?utf-8?B?czhNK2ljS1UxZTV3djMrSzdobGF4NjZTZ2tLRW5NY00zS1BuMXhTVUxBV1E1?=
 =?utf-8?B?VHZhSW5uTVFFMGZIV1lublptYkJ2aHZQSW45T29pMWNxdjgwZytqQnAySWQx?=
 =?utf-8?B?MFJQSVQySUtjNGxnOExuNS9GOXY5NUR4Wm9pc0tjczdFS1V5dlZkbW5DTnEv?=
 =?utf-8?B?MDR0TU9XTndXd21tbDg4THQwQTVtNXlOMzBDS0xUSTEvb2pYbTFDMFFIQnkw?=
 =?utf-8?B?dTlBS05YODRYNFBzdjA4c3Z5LzZwbnhCcVpuUlA3NDdQTWJOczU5OTJHQUVM?=
 =?utf-8?B?NG9SNzZESUhYbHRQOEU1ZEZiS01HSmR1QUJBZmVpMmovS0VQalpsSEk4VkpE?=
 =?utf-8?B?TmxFbU9QWStIVFhuREszSnJZZi9RQk5jaHVNZWVNaE9FQlZhVFZWcm9OTkVB?=
 =?utf-8?B?SmlCNUFKVnRnU0tMRDViMk1YMkRPSmUxQmgweTYweFBqS2ljWlpSWUtPNjJt?=
 =?utf-8?B?eklLQUM0Vkh5ajRJbFRjK0twczlQVWtVRU9Pdk1qYm5HUFpuaEdsRkxUUjZo?=
 =?utf-8?B?ZWQyQUkwaGs3QXJzMnhRQ0RBekUxUGkwZnEvamoyU1dTakJaMTRYM2gzRVlm?=
 =?utf-8?B?WitXQ0xlOXo0ckVVK2xjb3FMcXpSai9TSmdqM2FjdjFnLy9QWmppQW9wRVVV?=
 =?utf-8?B?QjVVcGlsWmRkNjV1aTRLc2VUWHFxb21nT2dxN01hVUxiZmJMZFViK2pIczZT?=
 =?utf-8?B?c1FLMit5dTlJZ212RVBkWW5HVngyNG1zWG1xb2pyQWhPb0xFOFhOTUptMURx?=
 =?utf-8?B?TmtwSVB1TW50STczU1oyUW5USzRBODVFUE5jbVZRRDB6Sms3RlpEVW9RSm50?=
 =?utf-8?B?SHZYWW5PTHBlNTJ4RXJqRml2djRoRmgrUTdIS3FrQW5VRDhYaTdkcnpUS21o?=
 =?utf-8?B?TGxxc1R1UDQ5dXk2YmhZNFRtbDZFVEpIVzhPZlZWNlJ2TFFmc1RueE1zM3JS?=
 =?utf-8?B?ZHF3T0VFNjRLTDUwWjB3MU9uQnI4NE9EOHd3UlZRaHNiY0J1Z29lOHlCUVNL?=
 =?utf-8?B?bnlvYzg5ajhVNlVVdGg0MFh2S3l6RWwzQmJ1WWpsZHFOeFhHMEx5cFF0WjN1?=
 =?utf-8?B?VU04d0xHYTlmVGV6YlBrRGZldDhMbUs4allEK2paUVlFblJ4MmJqWitQaE93?=
 =?utf-8?B?c0VKdWhxWGEyc1JRd3NSaDlIdi9QOW5vWGkxV2cxRU9hZjJ5aDBGQzVxSFk1?=
 =?utf-8?B?QWZVYWprVW5mV28wRWtoK2RqcXNKVmM4dDdvemNPcjBCQ004WkN5UkU0ckxB?=
 =?utf-8?B?aWkzc3YrL3lPUXJ6S2x5ZStNVkNHT0tjcGVuU2JlZzhmZ252ODJGaFFQMHNW?=
 =?utf-8?B?N20yR2FjR3NuZVZZVUFuU0E4TFU2Y01sRDhHUHVXY2FyTVdaTWRGc0NIVVVI?=
 =?utf-8?B?U3psSkNvVWppK2xMSlMxNmdnVEdCZTlSeU9ia0FHR1U1Vjhrd1VLVngvTm9z?=
 =?utf-8?B?TVB1aU1EcGh6ZDVkUWhSZ3Y0MVFydGN2bndBVDIwS2F3dlBhTHN1NXFlTmp4?=
 =?utf-8?B?YlRVZnlFVkNnSDd2TTA2NEdISThWU3dXcWh4dzAxZDMrKzdDaVpGNXBGOVJP?=
 =?utf-8?Q?9vmsQbjKJ0rb8zUad0qP5DRDu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93f2f22-ef61-4648-22e9-08dc7f21023e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 14:18:13.0518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rblcj58tYGpxGaYE1e+uen3g6DJOhRApeckGRx6nwZsBbwvmvkj7XNJmGPXUMhlyN6KhsAlllEjtDVFK+c2SRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138


On 28/05/2024 14:14, Chuck Lever III wrote:
> 
> 
>> On May 28, 2024, at 5:04 AM, Jon Hunter <jonathanh@nvidia.com> wrote:
>>
>>
>> On 25/05/2024 15:20, Greg Kroah-Hartman wrote:
>>> On Sat, May 25, 2024 at 12:13:28AM +0100, Jon Hunter wrote:
>>>> Hi Greg,
>>>>
>>>> On 23/05/2024 14:12, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.15.160 release.
>>>>> There are 23 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
>>>>> or in the git tree and branch at:
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>> -------------
>>>>> Pseudo-Shortlog of commits:
>>>>
>>>> ...
>>>>
>>>>> NeilBrown <neilb@suse.de>
>>>>>       nfsd: don't allow nfsd threads to be signalled.
>>>>
>>>>
>>>> I am seeing a suspend regression on a couple boards and bisect is pointing
>>>> to the above commit. Reverting this commit does fix the issue.
>>> Ugh, that fixes the report from others.  Can you cc: everyone on that
>>> and figure out what is going on, as this keeps going back and forth...
>>
>>
>> Adding Chuck, Neil and Chris from the bug report here [0].
>>
>> With the above applied to v5.15.y, I am seeing suspend on 2 of our boards fail. These boards are using NFS and on entry to suspend I am now seeing ...
>>
>> Freezing of tasks failed after 20.002 seconds (1 tasks refusing to
>> freeze, wq_busy=0):
>>
>> The boards appear to hang at that point. So may be something else missing?
> 
> Note that we don't have access to hardware like this, so
> we haven't tested that patch (even the upstream version)
> with suspend on that hardware.


No problem, I would not expect you to have this particular hardware :-)

> So, it could be something missing, or it could be that
> patch has a problem.
> 
> It would help us to know if you observe the same issue
> with an upstream kernel, if that is possible.


I don't observe this with either mainline, -next or any other stable 
branch. So that would suggest that something else is missing from 
linux-5.15.y.

Jon

-- 
nvpublic
