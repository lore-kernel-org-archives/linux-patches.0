Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D280F341ABB
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 14:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902026; cv=fail; b=rW1v6eRXvraCJUgElXUDoYA6GiX4eCMR5JLSBiAeFAMol0nhFxphUHNeqEglWY0FKJV6fG2h1f6wElopMNa3FKAKBCtr5Kf2VEWEUOttmnL6+5QtNGcEtBcmvgT/+V+YNjzdPn9hHFpFqlrg/hdBzbabotnzDLLEJlMZ+R85nMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902026; c=relaxed/simple;
	bh=icSdT/jAB7cIDxMYyOWqslKoi5Tc2hrr0w5o1lQ1GSQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bP9ccf2xFZkzNRhyxexfdEbwB5Bm3q0QkJ69uuiaBK27DhVG4kGird3thCmKRAb63jFz4yUCaytQN3d6O++GmmLZu8DgJ+bqkzsbWXWf0QusCFnQGGmy7LAj/Z/gy6kPkPdz9yq+ecMMZcxaC+9ieL6wF0gRpHEj3DdrgXnHkB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=mkrtNsZI; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mkrtNsZI"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ODdeUd1820497;
	Fri, 24 Jul 2026 07:06:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=FMLCSNBjWUF9E59AhzzgtdB92G/cr536oi/nJEXMNuQ=; b=
	mkrtNsZI9ipM8OfdDQ8tc3hex8R5Ehd4aOY2JhOHoI0MtaFO6YPJDz64L5nyGfvh
	8K1Q4BbMo/W04fr8loZ00zDr0ZcfQM4VZZYhI5AxsZuIpcsNb7czct8GWufPRt2N
	PjGzrjSHUahdq+gb4g6yb7lEzIcKkAYox1PEdnEmVYK5m9wlTJv8KXS07tPDYKYZ
	5wvEbWROxGZZaWrRkqHldv6Old/Xu2nLXIPsm0ypk2bcF8faFcsKWrwgG92dQ/YG
	IHOETnGK36HBf6Q5YzUKF8DqggIyEURbt8gnVoLG2vj3ALXYtiYuXTzv/Bi3AJah
	klaszxh+3ZeIRPhkH34x4w==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fjt3u4wxf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 07:06:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXQzzNTzTpvHU2O+onZ3fmn5brTemGVLmkKZQpm+yM0Zzlzty2tXn+CW3k8n97+4oT397p47PXNLI1W2U2whf8VbnIM3fvCqnpZayjmuBix6KCjIYw9QY9td+E1szTfWu2LZyQxen4wmmtvVeyp8XoeuCkwZZIKMHZZXJgAu3YngUBCZ+yNtf4lIh5Cxb0r001poQDM2ZR88DOzW6ylkC134IOPhRI+ZnADSigjZPw6IMNhijm6pMmdmAQSB74kr8ikHwhZvYEGyFRiJD2QliSYilr2EVudjogpS1HjmIFOBGnhnUP/LRTbENhYSLdnju0iM4bKug5tP5GFxPWMF4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMLCSNBjWUF9E59AhzzgtdB92G/cr536oi/nJEXMNuQ=;
 b=ysiQdKbS6Cy9XNC2lnwxTm0wsOFP33QDYY6q9Xhad859zgckIPV7iOy2EEuzNKP2/4NkTKED3BAPONPNQGLAS5kkdzB6FwtabO75bQ02OAN7L6XjJjAnxxapVjAVcNeyK86glyARJptGj2pX61sLRdi1tETAFWRyWw+QD+Ggu4+0rsfdmkASSvulSENolCiDvNO+ayj95QLOLcvgrXUjj8kgDqrTCyC9K/MFj29cQ7TH3iIwb6FvRQBlX7XVD03Ldx1SNi7AwySD8tbes/NdgmcZCq8WAqJpWEAtS+oZdvDhZrZoCLCU4U//gJHlh1+ip9bwVbAX8KoCbA+BhvLbEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by MN0PR11MB6036.namprd11.prod.outlook.com (2603:10b6:208:377::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 14:06:49 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 14:06:49 +0000
Message-ID: <59dae82b-5307-4018-8e17-8bd447b7271e@windriver.com>
Date: Fri, 24 Jul 2026 22:06:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0309/1276] ext4: validate donor file superblock early
 in EXT4_IOC_MOVE_EXT
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152453.007613078@linuxfoundation.org>
 <79f8b3b5-bbdb-415c-9211-ae1858cb5dd5@oracle.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <79f8b3b5-bbdb-415c-9211-ae1858cb5dd5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SE2P216CA0197.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::10) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|MN0PR11MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: cef3c67f-2eb8-49f9-afc3-08dee98ccdee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|18002099003|22082099003|5023799004|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	PFi/MaQirG4aDepx1ZO4TwQU9Tc6WBOTDOscPWiQPvDIDu6ioXAz+u2RaR23C7dZ5HF024IwLKAg7OslZjiBogRlLzpKA/Wb+XMV0pc/2eOcDE6jo/Pc8gRGAKFpw6JLnzfGCSxHKzYPY/OPFyQBko0gtb+tPkf4rNmJsLJLXI4unlSTb/93xO7j3PCxdHEEg+O2ubq0fTOOA1U9wofA2iqPsCeBQzLJvssgGmYZv7W3cJnKUd+YEEe6CPR4UXFMkLgMHjrgYmzNQKrcx4JVybi822moobJ/R6KFYAozdugPHLDaHjrewsuZfV/fZZ8CwXWmf31xHDxlK+qlWvANTg9Swk0CU3tEyOwTvniW0GBPMmRer1Gy5zZpvknmk+90JhEexQiNArxqf32l/n3UAGd0q0wIiNAzfVSS399MFfUo4tIIHFs/idk00SwScBypxpMEflls+pfF5/QoCBfbEXLIdHCFxWs2BaTteoVQ95GM+XO6JRr3ecFbNxs2GBA9jRiq0O+G3C5qKNmj917CHr5f75Hq/7R1dsgf/n0iH8EC9Ksyxolk+KmpN+VpGx9/Vr5mtyqa3ZryzdSMh41CHJPHzkq9+nNdvPC9XpPWHg02bW69swn9PjWWkW7bNotSlMhS4WzAjNfFK08Dw7hqaT8VRJByG339yUUOBIRKYOw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(5023799004)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rjk2cXJlVzR0aGZqREQxUkhoUmtKa0ZTUkd4TS93R3gzYXZ2RFJZdGo1eUJp?=
 =?utf-8?B?N0E4RVJVQVcxMWtaakdPTnJLbXRXbUpHR2xzTUJBRFdUVkRSQ3NsanhmaWV4?=
 =?utf-8?B?MVZMdThudml3REtVcWxydnpObEZENm9wRWZKeHdzQ1ZUTFluNXorQjZsOEJG?=
 =?utf-8?B?RzVwS0Nqc3d3UVVGRFRVSmRBSzQ0ODNzOU5pRk1EakQwSDZrY3RodmRVaktY?=
 =?utf-8?B?R1ZiT3p0K0JycUZvU3dTVi9ydFErV3lZSDJwTXNNaG91U29xeUdjclpidTlq?=
 =?utf-8?B?L29KS25iTTJxK3VmbmoyZFh4eEM1bTExbUpycFZYM1RtOC9uM05nSk1PdEw1?=
 =?utf-8?B?YUVMMzdRemVvNlJPeCtWNG1OWisyNlFvcHJVZ204emJMdUJ1N1MxQVpVdjQ3?=
 =?utf-8?B?eUhGQ0s1T0RWTkg1bXo0Rkcxby9HVFZTTEt0aS9MdWc5VUNwQThyZHArQW5j?=
 =?utf-8?B?WVNyOFFHODM4S0FKb1cwTG1JSTJhb2pGSDFRdTl2NjE0bllIZGNaOUlBL3c4?=
 =?utf-8?B?SFE4d2hpbWJBYUJtVHhBY242eHVSeG1sY2l1dXM5Z2hBY282MkxGbXB1R2lz?=
 =?utf-8?B?YUEwQmllckM0SVVCdWxKSTVPYXdrZW8yMy9NT1l2WkFJOGJVWHc2WjJhNEFq?=
 =?utf-8?B?VVp6bWNrMGZCakpBMWJhanlpMDA4YkNqLzArR2hjd1lrMmhOZ2ZZdzJlS3pz?=
 =?utf-8?B?MjdOL2lOSkFUSDdBSUFyYUNGdCtHdVZyc0EvLzdwOU0xeDF2TlJvSjErTzBK?=
 =?utf-8?B?YUcwckViZUl5OXpXMURvWlVaZlJ4b3lIZDRuRVFHMy81K2FPSitBSkV2Rloy?=
 =?utf-8?B?dG9OUUVDSDdCaGxZNTcwT1M1Y1lwK0ZVNXY2SXo1WlBIamhFeTIvUkxRK1p0?=
 =?utf-8?B?N3Ztby9tS2Y1SzVzR0RLYVZ3aHBIYlVsNnB4WUNrMmpJSzB4QVdMVUVWamVZ?=
 =?utf-8?B?UlhQemNxczVvMVhDS1RKZ1IvMmN1UEFIOWZzcWdVUTlKNk9NZ01PdUNiTWVq?=
 =?utf-8?B?OGdWM1VSZUNFS3V3ZytDZTE5ck9yK2N3ZmVHWDN0ejhPMnhWVDBWeW9DU1FW?=
 =?utf-8?B?U2dWTWRmMXNlN1A0ZEI1ZEJzc3lMRms2ZXp4T05jTko2RHN0Um9XMUxVaVhx?=
 =?utf-8?B?S2JjN05MSjlGeFZFV21TUFlnaUNhVHBJWWtac3JSN2RvZjhtc3FZYXduWjVq?=
 =?utf-8?B?djM4SGF2Y0NZR3YzRnR6L0d0cXprNDdQQW5xeEpMbU54amNGdFJPdmVxMFJM?=
 =?utf-8?B?clJiL1JRc3Q4cy9wWmxDRDZXaE9idEZGRjlrV2FvbXJtd3U1ZGxzaDdHMFZM?=
 =?utf-8?B?akdvVE1vbWdrTjZPUjBwTXhFK1lscXF6OFdvS1kxMFZKVm1IYU9ESUhUa2Vw?=
 =?utf-8?B?Wm9WVm9NbXlmTWZ0ajUrd28vV29rUDZhZFMvWFdQSlNPU25Pb1Yra2o1V3lt?=
 =?utf-8?B?dnRjd2VWdllEYk5VRkN3bElWbGx6WGllRzdPelhpUmNHR0pkVXd6YWtQbUlL?=
 =?utf-8?B?ZFUweGJtSFdzZW1aVEo2RFp1N0R0UlNuS1JHZnc5SzY2TEFYMllSL1NlTmZK?=
 =?utf-8?B?S0x6TW9ITUdoWFR5UnNVY2pLUHNJSE1tZWM4UWhvTGt6ZVA4cldtWFVhb2NR?=
 =?utf-8?B?am9CT1FxcDZuK1pFNStFbTdPWmQ5UFVmZTlTUVdmb3orRDVFamxRYmdJRUlE?=
 =?utf-8?B?YzM3YStyZXV6bXNLN1A3ZXh2Qi9NK0RXdEJNb0IzcDFma2xSYXJ2SnVkaFQ3?=
 =?utf-8?B?N2xWcEFzdnJGeUwzVGY1a1VtU1doRms3V3pQdjduUCs5dmM3UXJ0WFBZOWJm?=
 =?utf-8?B?SU5qNHVkOFZXMlR4NWtWeng1ekt3VTRkbThDNkFEUFZKYXQ4TXY0K2ZBYm1v?=
 =?utf-8?B?SkhCU1ppZlRrVDVSQ05RdWQ1QmlpY1k5eGtNS2ZhbmN4cExGQ3FlbXpNOHF1?=
 =?utf-8?B?WlBoTFhlWFZZSW5EZVV4ZUMxM29lL0M3eWcyYVhZcVFQdlpzSDQ4cnlRWVI0?=
 =?utf-8?B?NWhFVEs5dlVRR0IvcDM4c1pWRGlUblJEL3JSYnRleU4vL1psbVl1ZTRYNnNk?=
 =?utf-8?B?SDUwVXExUUFMYmdTVDF2aGlwcW1LbnZpb3hhMjlwWm02QzBCZlh6bXRobWZJ?=
 =?utf-8?B?TmdZeldHN2QrcXpnL1BkM2RuMnBXbzFCWTFaRjNXSEJDb0s5YXdEaXMxMU5w?=
 =?utf-8?B?bG40bmdnRWpQQTFEZ2YrelQzTmF2Mkp3ZEUzMVpMV3lRZE5CM0pYVk9TU1o1?=
 =?utf-8?B?dlBTaE1OWjVERlBUSUliRlBlQWQ2S2Y1czBQZ28zelRVOW9JY1lBalpMREUz?=
 =?utf-8?B?cGw2TXpOV2FxTU5iaUZPNmV2cm94MXljSTMyVllZSmhMSVB3SE5ZQT09?=
X-Exchange-RoutingPolicyChecked:
	pFKDVROpQACkbPcRafePUnB8E2VEqYyQitcoRQnWAroMChebxpfS1TjkLzgCfjRicvpA38WDEXaKsGatSoI0AH6jNE0+TOKkx/E/1W8Rt9ItVlc4UesuY+qGQtIJlUeBUnjOIfgo11JIvAnSmf1FGZnb6WPdPOI7P2iXB+Ci1jQt2U/IQpOQe7bcoyCzfOfnfl98wztqvTlEChtsB43VrgDZvtV0S2K+CBOynyHwhCWd85YBfTUWn+oDB5BoYVefkVKwjEik1pvcW3SU02IVhgEue5FG9g0FYv3vsOzLyw2Iick7e1FzfvJ5PKd3Yatt4x3M3ckVxZepvpae80f8gQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef3c67f-2eb8-49f9-afc3-08dee98ccdee
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 14:06:49.4062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RRk8bOIeqcCvI21M04CPnU634ayIWtROSmlPeO1T3VbzrGDjMjHhmY0WHErpIppbFT0tFAMXuSZRfTb4Id5h+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6036
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEyNyBTYWx0ZWRfX/0GX7DmbKHZw
 6akUzNqSYYTwG+5kBfH04J1oWMdnatihXpcyfIcluh4WTWEKhPDxLqdz5F6ORoDV/djF+Ldex4Z
 ATTYfFnIeyCQgAMDA/YyIr+rIPyiGFuyrPAhhs1NE9eE8PrzTd1EPvSgu/hN54FlDvMxvxPK0Z8
 k+8jxm9CKHGEeM/aHhouyvhswC0NHBRgdfurEkN7YeowNfxzJhuwy4yIkbZACdSL49xF7BO8Vb7
 y/WOF0HiiovO0qIt5BUWUOQeaGl2nnQUDqIoSomFYwlq0ijqS9EvehiLmEPyowHWJhxaJePf53X
 YgGeDEqGc9Ix+1Jo5VvCTnGqGqQODoa7IUa/IRl2orcTy8RA+ME5GNGukS7sqtr9JYScpYYtUok
 Mvsg1doZ/ejie/rM6hRO4NiQcdARmn9ZiW8OrmETUqYKAQgozLMQjz1aAWpJK/zCA3cvZGa/3g4
 pIrrvgOxuDBvqYmrLpQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEyNyBTYWx0ZWRfXxW/Qkr2ZXseQ
 +0nMQ61/jVrUweurXJKmhpUvv0ieQhe5p4Am+6BpxIc4ddvT4PMhKp1pSQCTLBK6CohsuO89vod
 41J0Ish1v3vpelGnu9mSu4us4BXScR53eb0ryJ1U3fUf8ws1GTOy
X-Proofpoint-GUID: HJhBjNuR82JrFD5I1h55jgaaOTzoGmGX
X-Authority-Analysis: v=2.4 cv=U9yiy+ru c=1 sm=1 tr=0 ts=6a63717c cx=c_pps
 a=+5nsKerQHvRPAoQt0ERV+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=ikGTjp6yX_QUaokfwyEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: HJhBjNuR82JrFD5I1h55jgaaOTzoGmGX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240127

On 7/24/2026 9:02 PM, Harshit Mogalapalli wrote:
> On 21/07/26 8:42 pm, Greg Kroah-Hartman wrote:
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index c3758c64fc4e03..a8a024bb62b4f7 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -1372,6 +1372,9 @@ static long __ext4_ioctl(struct file *filp, 
>> unsigned int cmd, unsigned long arg)
>>                       goto mext_out;
>>               }
>>
>> +             if (file_inode(filp)->i_sb != 
>> file_inode(fd_file(donor))->i_sb)
>> +                     return -EXDEV;
>> +
>>               err = mnt_want_write_file(filp);
>>               if (err)
>>                       goto mext_out;
> 
> I have run an AI-assisted backport review and took a look at
> d9db3e516000 ("ext4: validate donor file superblock early in
> EXT4_IOC_MOVE_EXT").
> 
> Upstream c143957520c6 uses CLASS(fd, donor), so its new direct
> return -EXDEV is safe: leaving the scope performs fdput(). The 6.12
> backport instead uses an explicit fdget() and releases the donor only
> via mext_out:
> 
>         + if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
>         +        return -EXDEV; <---
> 
>           err = mnt_want_write_file(filp);
>           if (err)
>                  goto mext_out;
> 
> ...
> mext_out:
>          fdput(donor);
> 
> Thus the new cross-superblock return bypasses fdput(). In particular,
> when the caller has a shared files_struct, fdget() obtains a counted
> file reference, which is then leaked on this path.
> 
> I think the stable patch needs a small branch-specific adjustment:
> set err = -EXDEV and goto mext_out instead of returning directly.
> Thoughts? or we need to drop this and redo this again. I think impact is
> mostly a leak/DoS risk but I still think we need to get this fixed.
> 

You're right. The fix is simply:

    if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb) {
       err = -EXDEV;
       goto mext_out;
    }

BR,
Yun
