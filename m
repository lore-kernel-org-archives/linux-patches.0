Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A929A31C
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 13:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759325938; cv=fail; b=tXBi6dIbuFLyd5S8EKaDndrpUnyR/QophOh4vVeyWjAcDC7rYMArZOrr9WGVADZVkcEiLyzLCUYMNW1Vtg/hntt0pYkeeMGEdrqa2N5+4ARRCxIt6WqGk9gNbiW0QvAgfut/4S+RmBtl1Yjf7wXpN7JLfKFBCVgxkjwo+S45XWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759325938; c=relaxed/simple;
	bh=/953DPafzG7inD9uJcqkOpfndLmD/932e0V4nTuCp7c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M2iUKhHwbjsJgt2eI1ODYRZoMWbJokoNqToqJ11cDvQvZ42azloXi7+Juz78inGxiDcYqzcN5NgEm+v69qyXweR2gu2MeDlHGdtPy1NvMNAVKbEk+s/H/HoQgiEHDyNEyxVEONgeBxwpKE6sg1v6Khd2X360JGu25gF+XRrM2dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NLc6sMD7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wdgSfW0j; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NLc6sMD7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wdgSfW0j"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591CrEIl019478;
	Wed, 1 Oct 2025 13:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1zLCviTNzPynK/Qr5Gc0Hrgcn4iVkQuB2EASkRX0A3w=; b=
	NLc6sMD7ut01FhGGFwK+n0PAtCLecHjAHYutOS6kTl6RWyW+/U9vQ/cuyeUvYKpB
	JP404mFM3uSEkUrDivzTxFM4Nj5ro4q5ny2otmvOf1Sb59OLFPXwIFWgSp/pilis
	vseh3v/n+BnX5eKCXX/I8T22d/QS3oVQi5PX3SPLrob61hIjPcWoOeDz/XpW5ElD
	7D/9V7LPOj7+eQ/VI+q89luv4a8oAl6bR1FclGwe7UWFiezE6tQgTKlaNAsBuPV7
	s5zArAIVZgspuOFAVM+w1ilkDatCD9p5fSKHCRJ1auqBrO2G5u6+c5sofpY/LMT6
	Jt7Wz9Lc73Sply1WwK1QIQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gm3bhg54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 13:38:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 591D0SGr004064;
	Wed, 1 Oct 2025 13:38:28 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013025.outbound.protection.outlook.com [40.93.201.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c96ja2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 13:38:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dPpEwFYdPHZYncy7lNFOccg+x80olMyRYv8gzhqjqCJ6gnOI+ttIF1GhWpVTj0qwe2y/3e5TaUkF4LFvdMzhyn2pkHh72HjOkhOJb/cX8fzabl80NPXrtZMWUPqQtrRqKbhDMlVmPjP3HqLHWj2DD++XYLzFELIcE/+gNv8EeKUgoAuANoiWCqzKK6K4UmgOpfAOjKIqH1H+Pte17wkefqqGmV4mjW+VyUDZjPrmf0D2Tx5jwfEaOdtylQRDtI3n0/3yQ/ndpptBEuGS/7CUf5yhb74sPGPZ2JUJKBbMwq2I6L5UE1+estg951BVg/DlQBBbBRljVgv43SRM4S4EQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zLCviTNzPynK/Qr5Gc0Hrgcn4iVkQuB2EASkRX0A3w=;
 b=yuZO4/GbXdCsnPWcPms1EC60eg66w2XQtpx0ubD6dN3xsjfvD+AwYewsdXtMNQW5s7JfZQvMd25tWHxCbHVRKvdiOi4bg5diWFGIOD01AtJf2L63h+fZcDudzLLJhMHuo/Qvm7Vk5Uw1TlMcNGQTFu9RHNB+18LexiXRYVydm0b+VcunUXei0TkApmkKeaeF2OjPu1oABY4KND9dceeB4l76pLFsa7yP/kkc9IVjXPsTWedhl7HEGOd9OuHzZOAsInTwMJrUlt3AHrD9/SFFPhDINsocaA2qEJQnmZF8i/eYmi+8TagEjOCesN/jWbAew7vwkxA8Dvsi72PDj58bPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zLCviTNzPynK/Qr5Gc0Hrgcn4iVkQuB2EASkRX0A3w=;
 b=wdgSfW0j9xe34wAdLTwxUZULLZFop/F0w2+4FgYuPHJjCq6hVPDveMxXwOnpzBI79arFq22viqSYsa7mKXVJN/yIQaGzn1Y6Z3Es0cSQ8OHIVZY9OI4+txY8CNX4fnIRJXXP6MWk+OCcb0SvAB6HldOWOoEG33qhI1SQx4I2h6A=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by DS7PR10MB5087.namprd10.prod.outlook.com (2603:10b6:5:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Wed, 1 Oct
 2025 13:38:00 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9160.014; Wed, 1 Oct 2025
 13:38:00 +0000
Message-ID: <83409174-6938-4b9d-9474-fae24f1c07c2@oracle.com>
Date: Wed, 1 Oct 2025 19:07:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 5.4 00/81] 5.4.300-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org
References: <20250930143819.654157320@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0049.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::12) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|DS7PR10MB5087:EE_
X-MS-Office365-Filtering-Correlation-Id: 2958f0a3-4267-4070-45b6-08de00efbd05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZU1lNHVrMHBXY1cvV3FIb1kycURNMFpBVFBKUjA0OEE4UGttQkZpL1pLdmlG?=
 =?utf-8?B?S0w0QlFFVXhtSGJnQVBzVVVMSmpad3lZa0lzY3VQVWJrZmp1RklUclphN3gw?=
 =?utf-8?B?L0J2ZjZvUU8zcHk1Rm1hUThJRlpGcHlIckpaQjVFODlzMnFibFdMNldTejdq?=
 =?utf-8?B?Wm12NG50Skk4ellVakJ1SWlxR3Q0UnpnVWNzb1ZjN2lhUWlTTTlxYldYUXI2?=
 =?utf-8?B?SmhLeHBIWUtaSFJGRDhndmdvUStkSDE1aEF3Zys4YWp3Y0RydUFWVURkcnJu?=
 =?utf-8?B?NGxXVXVhV3VZZ0lqUk5TZ3hQWmg3UjNnWkVVbnhQNkZ6c2lZVTJ6amlwSGJ1?=
 =?utf-8?B?dElZQ1Z6aXFINXhKci9XWnMydVhVTmIzOVJKV0lmeDlhNTl0Tnh6TTdCUVFE?=
 =?utf-8?B?aEovblA0N1FzeDhTQmVkUzFUR0pXRlBtV3ZtM2ZaWm1oeEFDZkxwWlJTVitr?=
 =?utf-8?B?OC9pbWFRL0pYL3U2RGd5cE5JNzd4ZVNGeDFocklmOGhOSTJDRlU0OUZjSDlF?=
 =?utf-8?B?TEg2Y0c2ZG4xME1vTWRIeDc0NlFnTTBqdURBRmcwZUVvQXM2cmkya0RnVzk5?=
 =?utf-8?B?a3lqUi9VSFA1SW82SU9vWGNIY2xXTG1vbXN6U3Rta0J6VW0xeUlEL3NFM3JK?=
 =?utf-8?B?am1Pa0ZpQXpkblVpeEMvWTVhYlliNXdUdGk5U0pYNHRscXFOVjhibUY3M3hu?=
 =?utf-8?B?U3pOMk8xNzFMUWIxMC9DOVRuMENCVURFUkdnK3dTWGJ3REZPOTQxeUpycTZM?=
 =?utf-8?B?VXF3bW4rS0FzaHBFcDVZZk5NOVh2aHFDR2VyZ1Z2ampPNUlGRkN6ZUtDNVFB?=
 =?utf-8?B?VW5YZXhtZFRjcll6OW1EMHhNQWZDSmU1aGRjWmd5dkZNdnhabHMyOXNuODcw?=
 =?utf-8?B?bDdISUc4VXE1a0lCd3hINlR1a3YwYTZ5cnA2WTFxVUw2anZpSGZLM0s1V3N1?=
 =?utf-8?B?dTE5b3Y3YWxCTzludTFiWHUxNUZFMTlnQVNEdDdHMG9tVmJXMWJZTnZIaDds?=
 =?utf-8?B?VGU3amRQUnBiRkNkOS9hYURxcDBrbnVRU3loWHI3eWVYNHBSNnRWaVlodEhP?=
 =?utf-8?B?VHRTZWo1bmdlelNCTjZkYlVSdElWQW9iN0RHb1JYQzhrdUJMOFZjM1hZN1JM?=
 =?utf-8?B?ZG5xSUNqSnh2WGQvL1J2bUpGaytRUHhpUnprK09RYUtENEdoVmVVdjlZclVD?=
 =?utf-8?B?STI5OXBxMGRXamhXWFd6UmE0TzJBN0JGQjE4QW5aQjVNbWMzZElOTGJCTHlr?=
 =?utf-8?B?V29lYzJwNUJYc0VWVFlFZlkyTHFVM0JaOHByTHgrQkRSLzMrK0x2SjJVaHJp?=
 =?utf-8?B?RXhZTHU4MERzYWxYbkpQMyt1b1NaUmMzMWNWaTY2M28zWnZvK1A0TU1YWVhV?=
 =?utf-8?B?dTV1d2YzS0JhbUZucmlFNnM0L3BTTzBFamRyRW5JaDcxeFI2ejljOC84Nk9C?=
 =?utf-8?B?eXdPQmNoZFF2ZndFRmI4UVo4YTJGUHcyaSt6bVJyRW9QYVR6UzFxcFhGbXdJ?=
 =?utf-8?B?YzkwV3Npd2l2bktEKzdVajYvK1dmWXNWc09RczBmN0RMdGJFZ29VK0VhUmI4?=
 =?utf-8?B?R0hYczFWL0NCU1VkMCtMRjhHK3U3U2JndGF0bHowUWVoUEVGRkZUcUlSMUI0?=
 =?utf-8?B?YUoveTZsdE0rZXRSUVlOUjl2V1hrcjZvZmtLLzVDUGI3bkZzaklmMzRxUjN4?=
 =?utf-8?B?dUx0L0E0ZHdtcE14ZHg5NFU5djJKbnVhbkRoZ2tWSmF2aGhlSzNuMnV5WE8r?=
 =?utf-8?B?ZFAzamtha09kYlMvS2o5YnNnWktYVGxUOHRrc2xNbktuQS9sNXVwdHltOC9h?=
 =?utf-8?B?TmFQYUtXUGMzMjNuUjZueS9tMGQ4UnRKRmkrNGpia3AxVEExSjhoejdZNTBy?=
 =?utf-8?B?R3FTUlFZSTJQM0lVKzJCV2lHckR0Q0FIT3hQaDFBcGdiTXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVAxMDRRWXJpTVhkUTc4ZWJiVGNwQ0ZwbWJCVXYwd1NEbXBBTC8raFdQaVE3?=
 =?utf-8?B?M0YrTUFZSFZGOW1FRWF5WTZJTlR3bzhtL0dVTzl6L1VVb0NSMm9RaWwzcGFP?=
 =?utf-8?B?bGdxa3hQMjhiNG9PenZ3a3EzejRaS0lNdDB2VEJXdHJzWnNYYjBVRDVEdWxH?=
 =?utf-8?B?bytzRllBQ0M5dnV1MnYvZ2lhYXI4NmVqV3R6VzdpNEtod2VnVGVwWnd5cTlo?=
 =?utf-8?B?bHppcUFqSXFXNTNnRm1ESWJFTkRuVnBsSUZ6SElEZjRJQU5xeThHdkxwUmJy?=
 =?utf-8?B?R0IrbEJ1UkZaeHBJMmdmY3VJY1ZSd05BVHV0ZVl3c2pFdTltR0tqY2dta0p6?=
 =?utf-8?B?dTF0T3lIU1Z0dDBsR0phZW4zaU1OVU53dHhOZjZSMXlzL3lpbG9uY0VnNFN4?=
 =?utf-8?B?Y1ovVTd0YU8wWTNxS1ZNcUFCTkhOazdEOGNoUlFFcXdlMXZzMWVWVU1RQWVU?=
 =?utf-8?B?YUdtK1UzSDlWRlhQbHkzQ3hjZ0UweDQ0eU5WWFM2NTYyUDJkUUNNamcwVFRP?=
 =?utf-8?B?dmFLUTdRTW9YM0Z4NTM0eTl0aU9oSTNTN0VXcWVmMjB4SG5HcHpHTnlPbTFm?=
 =?utf-8?B?UVdOWFE3aFVCSlM4Z25ZMnZHRDlBUTIzL1lkeGx0WG1Qeno1by9HeTJRa0F5?=
 =?utf-8?B?Y1ZRZVJMbUpLdVA3Ykc2T2tsT3RtUzZsKzNQMzJJMThIVGM4eERnM1kxTmM1?=
 =?utf-8?B?WEU4aW16Qytlc1k3MDc0MFpuMVVUa05Yb2NjMU9Rd05wc1NIa3ZROE5HZjBM?=
 =?utf-8?B?RTIwbEs0SE1iWnR2TkRBd0pYSk80Q1FuaEkyVDR4TS80UTZ0VXNZTjFJZTBv?=
 =?utf-8?B?ZGloQUloQ2s1ZnpVOFNDTXI0ODhiUUNCbnFaYUE4R3hvY2M3YnYzd2J2SVkz?=
 =?utf-8?B?ME01V3p2eFBCakFlbTR6MTMya2h4V2VqM2txbk56Wmt3S0VPR2VjTHc2b1Zy?=
 =?utf-8?B?ME11NjJmVXZIWmxBbGdRVjN1K3FBTUZLb24rVEM3TUwwcWdybTgwVi9QbGlE?=
 =?utf-8?B?TFA4SmpXV0pseTRsbzd5S0laSnR2eER4a0dQU0dqakVZOHpBMWhibTF6VW1S?=
 =?utf-8?B?bnlPa2doSkNSNE5KUVFxTlRlSXVaUDZQUmY2eXU2NFVvZm1DWVBzSGlMbzJQ?=
 =?utf-8?B?dTRlRTFBUjZla0pMWFZQMzdCajdSR2h4V3lFcGN1Vy9OaUlXakZPVlhsVUpR?=
 =?utf-8?B?TWZOcXNlcTNpbThUU25wOVhTalZRZURFYy9kMDBKT0h1d2FmMnZpTzBYV285?=
 =?utf-8?B?KzJ6Z3pYT2ZOdmFyQ1ZuQmtPRWFKQXp3LzRQb2NUd1ZsV3VBRXBOR08rUG81?=
 =?utf-8?B?bGdwaTNmYzVQcUVmaVNCcjd0OWVBNjR1NUZpY2gvdkwzVnZoTHdQZDNLeGkv?=
 =?utf-8?B?RTJpeUJOQ2tZcjlQMG1jZXlsTWowYmo3Z1ZOWkFOWXNoRUx5bzlKY25UMWV3?=
 =?utf-8?B?dVk4TGhKa0V5MEdJU1lYbHFZUkFTdFlnYnV2RzNPbTB5MC8yZkpXSWJESldl?=
 =?utf-8?B?RmxJMWZHUVU5SmFoZDB1QTgrRHVZTktDL2hPODNBVnFybVY4K2wvV0JrOHFp?=
 =?utf-8?B?UGxXdUpUd1dHKzEweHRyRXdqMWxValpZV3REN2JzMlEzQzdURFh2MS9IRTF0?=
 =?utf-8?B?bDZwcFk5MjlTN3gyMDFqWjhoVzdPanp3Z0piT05GL245SGJaZ3lHOU14N0dm?=
 =?utf-8?B?ajh2SFBrVDFCeTZ1RG9rb0VtMEpCR24wT2hLNVFqVlhRazFiTnNwU3Z4OWNQ?=
 =?utf-8?B?L2pEcVBIVTNsYUlzYTFxVVhsenFqcEV1cE5ndHNXNm9vd2RuZE1rVnQwKzZi?=
 =?utf-8?B?eDJnSk5mR2JXV2F3a1NQcTZkbFlWc3ZoWnZFbWpVTkppV1B2ZVRyM1NGWjMy?=
 =?utf-8?B?Vi9sMEF6bWNZNERTZkRlYk1jRFFOTzhKNEgvM0owSHN1MnU4MmpKeVVWdkdM?=
 =?utf-8?B?NnEydThiTzRSUVZwTjhpU25wMTVNWXRzM0c5a1hld3ZHbHVWMzhtUjdCVkZV?=
 =?utf-8?B?QVpvWjBaMlBVQy9ETnBqZmljd2FZbVRYaTdqeFVxa1hBTGZyT1duRThSS1ZP?=
 =?utf-8?B?ZWtVclRmNGdxT2tUQzMvTmtHaDJLSk5hQnJLMkhwcVB1WDdoUTlPUVF6b2Jw?=
 =?utf-8?B?OUlxaEhTNE5oK0E5VHlSakplc1c4Z0MyeE9MbnJzWlF5N0VDSEtNb01zMmcw?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ITa07qFeEjLDs6MkQZpOvkrwv84KxJnaJXJ6xpeBH4dxw1quRxDCRGNqqGGcp0vE+jGwOugju3SpBHgP9CbeWipCl/Vvl6kGptRd9otIF+BznmpTYWMkvyAap/zfnHHrx8dGwcN9a+BxqUK7TBuASTZA2qJBJoaHSATayiU3LNS7sRnpz8QxhcV4w1UtN3UG6P+Xx0pfUwYuWpR1T1lIOEkwQMxGelNtZ+QT3+sCz5vitkUfUZvC/52qzQLc8Ki1ZuYKXUggATs7DTyyfV8LPEmACiAjD8SS7PJu/8R9RCE4nEw4czI27r93HeP1XFz7jgj2XPC/Q3y1jwPwf/MPHXlsCxdcewxD4Ey5dcI0K5XzXtCUp9eIqsmFqL3PEjrmZkIZ99dFj1s9qFGLa7NOlPQ2l4/NMmGchmvf/NtWOK+UZOy9cIQc25lmuHcagg3CnOvHQRWCN+CLIMG4lI4Nhs8XXL+L9QH5FcH/lwM+8wJL8llOqNfmtXFtMMYofKgAz1+w0KFupM4MILfNpiywArMgRySigiA6XPjXQr9kYUOMIcWE6KpjM47BipKv8kdX+zvmLCqUBZEWlDejlbF6hfWp9cOl18sAkc/8Az6D63c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2958f0a3-4267-4070-45b6-08de00efbd05
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 13:38:00.4123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vwls3PnQfM+hU+z370cicknLoaWm/CifeWg/lpw3Qlxdu9oxeCtRA2mtmeaHowVKi5Q48aDoiyiIRyXdK95uiSSKFqsD0BD0TBjjs1CEfFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510010118
X-Proofpoint-GUID: znsuUd4h-SLQtKKA1odmukNY_InB8lDS
X-Authority-Analysis: v=2.4 cv=GsJPO01C c=1 sm=1 tr=0 ts=68dd2ed5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=nJSeLvf3dD-fGHVMcaYA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MiBTYWx0ZWRfX5K54eTQa49nR
 FOSGSbBgIQUJI6ebsRrGJE4V0pRp2Z+/MvODSlTDPtCa5oovDWNdspgHnhnKg2hmEw8wW13Q1cX
 Jk6C40N5YR2r1GZJRgwaIikptOyJSGh4U/M/PZzWBPAy2PnY53OR2LgjQLt4xrdopoDd9+ujUa2
 oMdfYBw9ypkeJdoWGBmWt9juC5cQFQnB6npG0H94q980w5Q33dmPszlOiJdh3PS/3r+aVmOyLlr
 zBuyta/1kZ1O6a8W1E/292VjD3mx7BBz927qXQ1usCpZvZBxLAcMX5Jelpidy76mhyit6T3Ia2r
 rj5zLrVaSSObL4MaqSob4Ox2qJkDIaBCKZSYjGJaQzUc3UvidvErYQOaqq5RLJ5mSGfij6dm1S1
 o3Rd/BDMIiArYdnDKNEiGma6kxOo0Q==
X-Proofpoint-ORIG-GUID: znsuUd4h-SLQtKKA1odmukNY_InB8lDS

Hi Greg,

On 9/30/2025 8:16 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.300 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.300-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> Kym8XMoYTNEV2epsa9VYcCZjGb1C8XhipnQKz9ZdKeVEV1OcYCEdMIZhKBqZFTXO5pwrmQdbGfoOBWtW8qD_KQ4LIg$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No problems were observed on x86_64 and aarch64 during our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok
