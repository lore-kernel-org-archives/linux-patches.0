Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859F3185B6B
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 08:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725264026; cv=fail; b=QgYCITCdby9pgaS311Nt6CiFk5jkNIajjXD2vKWOuW9qPh4PK5V0+tjYoDgd8wQgEptNPMyVFQhiYwCNAfbjyVwaD6gBwe6oOrPKD6aMmpFnLCZJatqV2uZS/xLaxgSSKBDsrvcehyll15yzXG4kSj7d2U1Fxwqb6bl0njCNmfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725264026; c=relaxed/simple;
	bh=gy2yuxjbTtomwoNeEgVfEJ/wpeIc52jTbGz0sVoc22Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VZjlyJw0pB20R79f0Ztdb2F5N9Mc/x/1U9Aplev99b5X7DUA6wzNiWBxTkgOCK6sxSUCXLRAm+vakIFdF8LUCODjmKvpqOAtj9MuPWxIAdkB3dRcIzQP5UQoAdWabx2woSTQsD6uFB/Nj2e7LrzdFfLNatmBkIrtZKA/ErkdzgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HFt625L/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fFzOY7CQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HFt625L/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fFzOY7CQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4825GBj9001346;
	Mon, 2 Sep 2024 08:00:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=cjG1RGgGbHPOsYGsiFxzMDCZ/dbsXqD2TNExyjy+XFA=; b=
	HFt625L/rhbc5YbkoSM/TwRErU6cwa7aTbI+RZ+op468DLqu6RUnB9xw4OLgZMzJ
	T5F8q/AKfW/F9Z/MS+0pq1BDt3jYAQleNfJA9NtMa/PEFPhhWGf15Que86Db3O5q
	ZS31GbkqgNm5gNm82NmvAeRkIKYWafprx2mCtmdkA+wpGHhQ6C7Sfkp8hQdX6lHy
	8wdSuiBaNlYgw/kLuGM+MWOv4IrwiBcPhXM2LHbNBdh5QWhQTwvEiIh1eUdWgfxX
	s/+wocmSXG0+YwRJJuhJWtZm8dXnkonO4dTQRt4GPkAO3jm+ZZBEQDVmsxLXHH8E
	DUzvoWUwS7oMt/U0zrgCsA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41d2858gyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Sep 2024 08:00:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48260Uox027979;
	Mon, 2 Sep 2024 08:00:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm7d68v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Sep 2024 08:00:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYEu+bcuroS5GWAMkt+NMyJSIgXbIZTqVzMmwiIjTQLq9cTEOJYlmlzpDcVwqyt+S+dONYO865rzM6FN26zfFiVnWVc8+hU+rcKyfrXbFPIT5X3bYZdAyad+VlU7/m9SUFp7EtpOHB9L+R4KZsxiN4jVmAPOt69nt4UTcPFl7UUPJTwFBBPSo2cxHG6UXd5ghUJnT/vHkl1+PkHj9+LJHVAHdaPddXMeOPve4NVstzMZK12o01hhPNEltOSoVhUrR5cJNgn04ZgoZZ+0FmWkasXm9Tv0ns7e0kaxACSobvZplQWkDo2tAENvH7+byfc5leH4CYRMG3aZo6VSXp6vpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjG1RGgGbHPOsYGsiFxzMDCZ/dbsXqD2TNExyjy+XFA=;
 b=sqL0HaLB7eG/LYmPvKHKpJRPadllE5u8FSJcSO0amQVmPeJa0mx2Aywx50z72Jl5XoOHnBu1Ysjf2QsBgwZHSLGfJ6WixdPViSjPMbwizTZ0Ry948t1GgA1XuEQvxAzKHE0vK6hAckeRp1ch6lJzWnx8SFF7ypNGnuihi9dl1hvXiwEQOFfY/TLNpN3T7upcH4x0J/SHQZkHc9HnMUdlzYZgAAzfYMFxMBCMc/5+SY3FCeQf6hlqrorNBWIEr6yxpZKF1lqnfiPeREeqxz8Dm0aCCi3E2MTPr7qmkhFtkGCV+/VyP5DlQfrPxF/XMnzkKaPbqpgmOi2GjPNbBtUEhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjG1RGgGbHPOsYGsiFxzMDCZ/dbsXqD2TNExyjy+XFA=;
 b=fFzOY7CQDrO4ewDj7/N4lWkjCD/OBs+VkM1U4LlrZ/BXLdx4qTnR2F+OZZ81r8wV5ZYZg7xU1eoYZYi2Z2YdbOhdaky7jvcjoZ6nKubqQJVINhoSGdA/PaN11hR4aCrRgCHCEQX1QL/cLz14ERcx/mo3Q+xCzjBQtQCXUdL1zF0=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by IA1PR10MB7357.namprd10.prod.outlook.com (2603:10b6:208:3ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Mon, 2 Sep
 2024 08:00:10 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 08:00:10 +0000
Message-ID: <ecd6ce60-f797-47c0-aa92-acafb2c6b02d@oracle.com>
Date: Mon, 2 Sep 2024 13:29:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/134] 5.4.283-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240901160809.752718937@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|IA1PR10MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a0dfb23-d1d6-49e7-e2f4-08dccb25443d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3hjT094NlZxZ2VUak0vYWF5Wkg4YkZXN1NJZVlNNnc4YUdWOGI4eUtIOWor?=
 =?utf-8?B?M3N3dy9JdVBONWRSbDVlSjhPeFhVKytjcUxBdy81QXdYN3ByRVBXR0RGQ2J0?=
 =?utf-8?B?ajZTZE5UT0NZMXN1ZFNXMWZkM2hNa3RrV0VpTEhZYlljQmhtY1ozYysraWdK?=
 =?utf-8?B?VkJwNXBYRVR6SHZiRm1PQmhNSnZmdElHczNKUUFKQUR2UXFoMjFFNHZXRlV3?=
 =?utf-8?B?dlFnNzdwbzhRT3hpOFJMbHkxUy9nOE9RNVpRa0FsSmo4K0Nyc05KVUFLQ0F3?=
 =?utf-8?B?bjRlU09OQ1g3SERGY0FWbzhGbFZpcjJUSVFnZHNob1RhTlZkTWtQRE9JdEJK?=
 =?utf-8?B?T2taY3I4THAyaUh5RksrUzdld25qUCs2T3RxczB5dGs1dUQzNnhidktBZkJI?=
 =?utf-8?B?dHpXRzJjNlhDQ3Z6Rk9qeW9wUDhkRXpoVG5hRnlSeWw1SFBkYXpwSXVXZFlh?=
 =?utf-8?B?OTNtd1hxWHE0L1N2ODdrU3hHYVNvZGhyMXdmdSt5cUJkZjhQMzJab3ExMTd1?=
 =?utf-8?B?UTVtQ3hwc2hHaDZiR282eUNiQjljSUo0d2N4MEFzN05lemlyTGxLNmVCWTNL?=
 =?utf-8?B?QnhjWWpUYTVQeGw3Q2w5THhmdlhVWUwrY3kvdjdERUdja1Nkdm5Td2NMaEg0?=
 =?utf-8?B?SkZMWWVXd0NqT0hORUplTnZmdi9GMCtTNjdvbEpuZFhxRlllYTZ4VzRwaDU3?=
 =?utf-8?B?ZHRva3FjQmdGMTYvejFicFQ2ZzZ0c2VRVzJuTG1TaGFjZFY2WE4wL3Z4Si9u?=
 =?utf-8?B?VFZsNlNWVmVwQWpQTThqOUVPTHg0WVVCdkFvRGlNMzJkVC9jN2hqRkpzeE03?=
 =?utf-8?B?TGtoZFZVMVAvd2laaXdNN000YlVVNkttUERoWWZ6OHBOWWZ4MlFVS05DRzZV?=
 =?utf-8?B?ZkRIUUJkbEZjRFM1TUFZOEx0NHI3UkdrUGVZTmFWd3lCMHRiZXBidkNWOFBO?=
 =?utf-8?B?YjU2Mlo3by9qTnpwdGhsM2RMb0l4Zm5BSzVzZzRkZS9wVk5Uc1RXNzlMcS9Y?=
 =?utf-8?B?Z3hPMDM3bDVQUG53L1I1Ynp6RFZDaUdtZ1A3NGZUSFU3RVlrZ3ZHa0hHb0x0?=
 =?utf-8?B?dFgzWUtHdDdhbnlCQnNxY0x4MHJ3Yms2RGVMNllwbnhicTVDUHVlSjJ4QlZZ?=
 =?utf-8?B?STNlVENTQmMwMk1yL0ZzREQ1Nlc0NTAvL3BXQUc4T213eTUvbFRVM0kvSklW?=
 =?utf-8?B?a0lBSFZnVmtKRFgzT25xMm1YMkVjYzZZcENFaHRucUg1MkpGNE1ZeGxtbzM0?=
 =?utf-8?B?NTR2dEtoTTJoMFY4a0RMVGY4MXFGZ3ZtR09Gc0ZlbFVCWC85U3VFa1pFZzU0?=
 =?utf-8?B?b25uVlZSY2pWeXlQNDhjUlp6ektzQ2pqbEFvZkdxdU9MeHN2SUNSRTJNa1Qw?=
 =?utf-8?B?RTNVOGJUUHZiK25WczFXUWdvQVlEemQ2UU1YRzJRdjdhTzUxOHhDUThJRWla?=
 =?utf-8?B?alR4QVp0Q3JRK1l6Z2V0WkQ1QmNmbDhtd1pneHRQd3hiY2Y4QnhiQlZpN0Ry?=
 =?utf-8?B?VzdLZzV4cDkwcXRWUlE2aTg1MHh5NGpFT3ltdmJmbUhsKzRGR2FjeFZBSndE?=
 =?utf-8?B?aXZjc1V5VVdsdzliMDFIQ3JxQi9RdjZJVS9zSVFtM21VNmtBZ2hjWFd4MnZN?=
 =?utf-8?B?blM4WDRRSzdwS0JIVzd2a0VucVJ1a3puYzZRUjQ2VU5xVVdYRzBZdVZUanRz?=
 =?utf-8?B?N2F2YXlPVjh1VEs3dGMwOElodjlrbjhHcVk1eUhzeHFOUmJxOU5EQU8wamkv?=
 =?utf-8?B?QzE2RGR0TFZCK1gwWWQ3UTZZczVkNXZ2Q21RbktBd1VwQ0dmMk1EOUVhTFgr?=
 =?utf-8?B?ZG85R0IydjJmS01xR29VZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXFrTEduQlBzN3NJNEFoeVRFd1pPZkxoc1JWSFMvNVNsMkM0REJNYTZCNm83?=
 =?utf-8?B?S1VvK09WS29aVlFDanFaZit2ZDlnMlVQVW1SRVozZDNlL3BNc2lTNUg1MU1E?=
 =?utf-8?B?SGZYUUlldUR1WXVIZmM3NFZDYWZYYlMvb1prZ2xXdFFDdWdKT2ZkWDh1bGxl?=
 =?utf-8?B?SGYzaVZLR3ZnenRQOGxOeE82WnlWa1UzYlRhcTdiZHIrMHcvNjZPNU01cDNm?=
 =?utf-8?B?YTQyYTgwckgzbENJTm5TMHJ4YkVmZjY3SEZUbzNXUERQaE1odzhZRitjYk1J?=
 =?utf-8?B?R2pZWWdSUWtQeFM4TEswUnVvU1MrdEJzWEFOcmpCWEI0cUZVZ1JYZThMNkJ6?=
 =?utf-8?B?QUUzYWRDVHV6c2kwUmZjamdQL1duUnNtRHJZZ2x2K1VJRG81NVg2ZWNjWWdS?=
 =?utf-8?B?dnphV0kxVWJPYldHVjZvK2hYdk9BaUp0VjQzV1JHMVE4cG5VSG9Ra29kUXhu?=
 =?utf-8?B?YUNueDVTajFiY1draWFCR3RLaGIyaG1BYytzc3RsSWRJQzlMTHlKUnU2QlFI?=
 =?utf-8?B?MEV5bHdGNWJsUWhCd0VpdjRGekUrMEo1MklmenlIdXpITUYvalpwN3UzMXlF?=
 =?utf-8?B?c0ZGSVRaMFFGenFGcGE2aExodFduZ2N4SnV1WmJ2V0lvWFQyMVVjQk1ESlpy?=
 =?utf-8?B?akpDTkFNTkFwOUp1RjRiZVlQM3JGaS85WE9yQ3FWU0dMT1czcW5UTi9rV3U2?=
 =?utf-8?B?OFdjZjFqaEZBSlgwSXhvSFBIQmhYbWFBcE9TM0prWFlvb2pLRjJkWm5LbCs4?=
 =?utf-8?B?Nmo0aU1IV1o2alBkOUVoUG5UOG1jVG9nMUQvdHRRQnk3aGxLY2VSeDBnNC82?=
 =?utf-8?B?ai9yQitDaEhKU2h1NHE5TVJuWWFjazV0dGVpdS9teER0TTEvbG56d1A2NEIx?=
 =?utf-8?B?WTZZNE5FNTJqVFJpSWR0dU5CZ2Q1Wjh6NGNQQk05dTBqMkpUazY3bTc2Wk5C?=
 =?utf-8?B?K1lYYlZFTERwemtQamJGK0JjNXcxVFNvd0tZdE9SL0FpZHlGanJaRW5mM2pQ?=
 =?utf-8?B?MnRkOXFtM0szeWt0NWxkQU9PQ3lFVGZjanJkdVFKbCtHZVVwN09jSDYxRjNl?=
 =?utf-8?B?WWNYcFhnSkRoaGJobVh1bkNVV0dxbjgvcndlNW1yaXM2Vm1vOWJkM0RoNm5a?=
 =?utf-8?B?WFFyRDBnV0VCT0NYTThzRGtRSnI0OU85UWIyTVdLUS9La3pBdmZMWVYySzJO?=
 =?utf-8?B?d3FtVEU4OHNLMFN4U253MXNrR3paMHhTSzljWWd5VEE5TWlmOElDVzdBWTZ0?=
 =?utf-8?B?bFhnV0hmdVU2cnpnK25NQ3dtL2QrU3QvTW1namdGSTVvcjZFQUMvcVJKYlRS?=
 =?utf-8?B?azBna3E3Y1lwMGlxdW5MWStmRzU4SkxrSHdGbGNOYTlVYXd5SG1TL05xdjB2?=
 =?utf-8?B?a3NWdVpHR1hMMk4vdkd2ODliYitHeEIvNHZpSktGYmpYbU5uOVl3d09hU012?=
 =?utf-8?B?YkNRcFN2a0s4eVc2TndPSVdXRzkwaHYwSnJDR2tLcFVwWFFCR3gwaUo3dzcy?=
 =?utf-8?B?ODd0blZRQ3RQODhxc0JxSEcyZndQQllWTzhURlE3ZmlQN1ZIcXlFR0ZoMWdo?=
 =?utf-8?B?bUw3OXpDOEFNSnhFVzZrMWwxYi8yaCthb3B2RVYrcHlENXd4YjhBMFkzS2dJ?=
 =?utf-8?B?TVVBRFBCcC8xMlBacm9qQThhQ1FuK3B4OFVnSjVsdUxpM2l6WFh3dndMYlFB?=
 =?utf-8?B?YVViQldHTk9Rd01kU1RCb2dpMmxGbTl1aWtONWQvTGl3cEdDeSt3RVZkODFX?=
 =?utf-8?B?ZkpHYmNkbHY4L3RuWlVYWXI4Rkk0Rzd5K2h0SWcvNW9rQnZBZzlVaGd2OFZH?=
 =?utf-8?B?THczWnNqTkYzeWh4S1piV08rKzB3b1JSQUkvL0ZhRno3QjkvNldGanEweWVv?=
 =?utf-8?B?cHFGRHFzQVN4NWFnaEhrQ1hBaXR3ZjRYTTl6amIrSHo0OXhxZ0N0YVJOUStK?=
 =?utf-8?B?SmRJQU1WZHZxc3NJVnNsdFBqY05lbTJrMm9EeUxLM0VCNmF5eEJhb3A3QTYr?=
 =?utf-8?B?WDdhQVdtaElET0g0dE1Hd204UU00enhHVFYxNGRkYTA5TmtFZkxPRWlmK3Fj?=
 =?utf-8?B?OTdvSVlGTG5maFpoRjQ3QnJlWUQrZHFkZWRRbUt4NGVGYnF6RU85T3pXb1Uz?=
 =?utf-8?B?bnQzajI1SHBnUCtoZGF3Q1hqWkN3R1JKNThLdWg0dWhNSi8zMGR5R3dtdUhB?=
 =?utf-8?Q?2sSH+LdhZlZPhe//v45jUog=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RuRl/DGfwfkgF25VrjW1L5w8MWTsySpHM7KCXeU/fRS7A6i0GkfMAqQ4GIuv1ODumBVszrCYbOezhIThMB1Q+NSl4ckt55qhbFmlvUH/A1qpUuJX/oikGy/kly/gRR3m6gjjjFP+HeehFUy3C+/fB58dStMOe19KmB1B5dd94g0LNAF1Vi6M0NEXzWzFTk3dX6O1hCSiR81bUaGIDlsW75XtLV1wX+8wPcREDRcdgD6Kh9W6rPRLZDRuexf7Tz3UGZa4pzqX5MH5KkN197QAudLW4igFy+FtFBPK8cN3CrZbL4loyTlxSHeIE5jjMb+ofl88G2p9alanTAjo+mkptIy8tYBi82ZOFXanHFrKedZ8LwTbixfhGCQdkPT51CXxQeTGI+jQ5Rpmn9ZoCxDK82DD4D2LAvaqjHW1suZCUW3glL88PJbq1uuBMxUW6m6Hd/6C/vbAdnaR3PElKE4f7lDdWCYvb6gqwoVZpoHRu9h5N1rDOCvknhVL5KIqSGCq7er9Q1iGZ4xETbrfewo0yjQ2fqZ1A2M+rn57U0dIQRcdxrj5GAGpXjJINOK4qu3jwNYD/FTQbFpV/UrEds5F9TlLERFKOsfKQNOkCZFuoyY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0dfb23-d1d6-49e7-e2f4-08dccb25443d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 08:00:10.1790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2171NTU/4iT63wEn4qF+fYeuFWaLTgG9fa9Pei0hnC1PxW9DopdjOWkRdf11wnpBs+2FwLObrMLkRnvfxoFnTrG2te1N3y+ZrcCnntQ6k9PVP5/aiLQgr8IdUNporIA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-09-01_06,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409020063
X-Proofpoint-ORIG-GUID: HtB1ZJWt6PQ_n6Ylm2KzuRbSfjXKq6Db
X-Proofpoint-GUID: HtB1ZJWt6PQ_n6Ylm2KzuRbSfjXKq6Db

Hi Greg,

On 01/09/24 21:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.283 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
