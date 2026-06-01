Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4297D2DF144;
	Mon,  1 Jun 2026 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780331848; cv=fail; b=uthtmzyOSwC4AW+sfylMvhQR3VocSB+J8//7rrV6g8w+UCvMfjuVBMvIFHwoArbd1Od9U1rHcK40BzapevnzabNkRRMa6pg8JK+Qd3cBv3Piy1W2B5034Zkq3T3lsNjflZFERF/GDOJYk/blH976sBKUC0PcT9+7SWARaOhvFl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780331848; c=relaxed/simple;
	bh=A4rzAaaM/VAlnSKfH7WpYIcQRslW4VQ8SQYkvzppR+Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cluniDoS3ftGG1YzOfVw0Kqvs83ctqq7ZggfCEKsLTKRIDTeUAGJgkxJDCQLx5QjdQrt6eRulVrwFBHq2G5sEf1L7pkBVsmK5k4I4OjGKhNAyHcpMvL3cBkEmqeMENHrNqL3nFDDgeRahjuBdOT49Pud1m8AEE5yhuo+gP2Y3PQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g8JuAVWY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QflRfQqS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g8JuAVWY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QflRfQqS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Ew5ik3890619;
	Mon, 1 Jun 2026 16:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tKyX7JQ2QBgZcbslJSRFOhpELazoNgoCRVTjXO0N398=; b=
	g8JuAVWYp4D0CmY8gsfbiLBHmMeIvoASad5CUwYIBYzm+Fb4IRCj28yOxXrwalHa
	kCwMEnMAmD/XSDmDykE/ktmZB5tq/YNW9Ha6zA1gKAA5tet1QZrpxQvVGXrxo/s4
	9RFNgDPr1ma9qydUyxQB3rRjzFJZc26uuCHa344SKwTIpwQTKo13zqAHGYqwArjH
	msekUEplr7jby2W4f7yhH3NL+m007UrXuFybumpX+YsbRzN+WiFtYtLCSO04jaHu
	CrtRBDGY0N9qQU+A+KsIwMPnymz/DhihGtljNC40xqE+ND5pqhAPVnHjMZzGpsxf
	1D7tjqEGK3uQGVu3vD446Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqs6jh24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 16:37:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 651GZUtO020287;
	Mon, 1 Jun 2026 16:37:21 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011058.outbound.protection.outlook.com [40.107.208.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbpknsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 16:37:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tVy8hsLOh5YaSys7n0rj0vJfb3strUZ2jXEj489oiunr9k7+B/OSuBsKM9cSUynZnM9hx68qQHCC5ZmpU+MiHOHLkpJcING7gdSWYr+j6kW5hKPu3l+2lOtvcIs6xX1JX0a6y/gdif3gqP3ip7xLlMxt/wE5I6TflL+qLxkV9UiYZTBu7LpZd0ralO/L7fRGc0POWCQDyValQQhtbFxt5ak6Lmg1kfZ0QWmxmvIlwgRTEgOYDt9YEugqGApaRPQhXjOL5GwEt2oXTObyDOM9qJfw8xXMiyZ5pzMJQV6dyHZ/U6CN1k5cR9S5erf2xUq+1zJ1gpaqqscJDLXuYqkX9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKyX7JQ2QBgZcbslJSRFOhpELazoNgoCRVTjXO0N398=;
 b=ocSkVD4Tbzo8lQTvuP6UeQfT69616joM74iU2pG/NmBySl92FqE/gmsh316p6p91h2tgaFIDTr+Vj1rVjPthsmpjhGpVF6BkxvFunyvSXXZZUi/TwJH7mMvzMJ2FeWgFgXRHDGYMex5jrbNyjHJ9nhJnKWNWxClNNlI1+b9geb5Hmsiotd/oaLMsecU1oI0oZ7mhjHPGxPhr5yS1w+Y4+86Rx5ysB1cdTZUNNf6tIt3HsLa+/dawJARBLCLpDTwJ9ZPH/liegYMrEPDOevUDKXA8OlG47wX0dM3qpLPm73PSO7+E0WBmmwQ6apH02r1Quq486XnKd068uMS2aE9pwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKyX7JQ2QBgZcbslJSRFOhpELazoNgoCRVTjXO0N398=;
 b=QflRfQqSlqeg/cojY08b7NJ7uU+ZKc+/3tVCZj2iYxb7HyTZfCRS88ut/xt8c9K3v4HcZgN9hYJ3uOepmWt46FYT+awFuTCRGz3o987ZZ/ZbVZ4Rh7K6WwhTpvqY0JqOKzxWA+P3FkhvFDCEpaStz5X+nflmaULE3eK9NHxB3xU=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MW4PR10MB5725.namprd10.prod.outlook.com (2603:10b6:303:18b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Mon, 1 Jun 2026
 16:37:17 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0071.011; Mon, 1 Jun 2026
 16:37:17 +0000
Message-ID: <89da255b-a781-4ccd-bcd2-b2f856a8d7a8@oracle.com>
Date: Mon, 1 Jun 2026 22:07:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 178/272] ice: fix setting RSS VSI hash for E830
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194634.287856530@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260528194634.287856530@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0048.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:271::17) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MW4PR10MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: 01e2c6a5-364f-45e8-008f-08debffc0b34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|4143699003|6133799003|3023799007|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wxzmJ1+TL50dI1dd8Zu4ZBAtPQge385cSC+S3vp9mMEAbROwOMIR4StwU/CcJM4lkkgHQt+Udgp+ZoQfCJh1awqkaRZjNfHsdDJUanP/ZPRAB4e+Q1mL+ZcwiNHEUl9yUxXSr1afvdAf1udMcVgGOPGft6qhgu3aDymULrpRfFTnU8oWWiNFDOigH1b3f7eNsFMZaaNWKMMAbF35rCaD6z1eYurlgimdTDLeNWEblhqb/78PGHvmyGREO3XNeXIYQmEShpA49XiXQzud5KbYwmOg8iPe/qwiK9CZ4a7pbQ7Kmv82ufy/zt0Cpv4iOcd8XEpHMFF8GcBMzBllfNZ2VWmfYwo3ppjHFLloxoCELjuWNevFOQA8vIWy+4JJ3cLd/as4RHZOCMqm8L4l6xL5m4tEdIYlcg1cPvjmlIJfxmMz2cD2mWb1mx5fKX/1+e2abPuVWnUYuVV9aJilPT82/trNmXcSVI3vHyrMkNwowgzKxtybVuyF5mkyREco+XVfk+fTKFBxt2ygsmUlAkq3aXJKT539W3PlsxeLdk1o2bgQeuLVftqxid7mOGkGaN1zs5JQJ3NNtvFAKf7W1TJM7qf5go1JZxBVkyiMysIIHaDiGKEjnlGsyyF0bNAgsG+maa8rnduOah0eyn6VJTAoiw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(4143699003)(6133799003)(3023799007)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGV2cDJlWUxZZTlqWS9LdmR4Yk94NlV6ZmxjTFhFTnFUclJtUUlWVThnZEJD?=
 =?utf-8?B?eEVWQlRWYkU5c2hVK3lIdythVllFbi8wOXJtNkZCK1JobVAyRUFpMUl5OHd2?=
 =?utf-8?B?VTYzNmYrbnJsbytrVTBSc0c0WmNxSUNsVWRaVHRNL1BERjlrUDhITkxpb0Ir?=
 =?utf-8?B?SjZkaXZkY1hPL0ZOS3ZWemt1QmhlbE9jMURnc3MzTEhVb01WaUdyVVA5blkw?=
 =?utf-8?B?RkZ4VmNmUGljaDdGVFJydXJCclVXRWY0ZEFrUzFzSG5TZlVqZWxMbnI2L3pk?=
 =?utf-8?B?WU15T1ExSFlPeE56Nld1R0RCMW1zTEtIbG1adzVIKzVBKzJUUjEwNURoY045?=
 =?utf-8?B?RVBHRy82RXRaVjlTMk1peFN2bUE0QWNrYVVQVFZwSDQ2K1ZSdW5sdmEzdFRU?=
 =?utf-8?B?QWF3S2JDZW9IMzZzTk1EVnoxdEgrWWV3WnlPR205RFNXR0toZEJGQm9XTm9O?=
 =?utf-8?B?dE16dHNOL2VqQzAxQUJlVFBRUll4RXI5NkpTWm0wT00rVUl6SHpvWGozMnNV?=
 =?utf-8?B?QSt6cy9jU2hsWEdzeGtoSUcwODZHVzV6TEI5SlFCc3hnU05nUUM0MXo0aVBL?=
 =?utf-8?B?Z0licTNvQmRYU3h2RGRIQ0NKWHpibiszRGRyZFpoU1haVVdHTWRJM2lucks2?=
 =?utf-8?B?UXlEYlJRbnJldXJSUWt6K0ZVelpoREp6QjBNb0gvMjRLMy8va0d2VzFpN0Q3?=
 =?utf-8?B?RUFHaXFkTFpzTDZTeFkwTzkyZzhtdFRBcGNsU0RCT29SRnlRMFduQStuamdR?=
 =?utf-8?B?RjNoQUdhZElGVGNnbk02U1gzTHRJc05KY1FuN2RISGxWb0JhZ3VJYlAwT25Y?=
 =?utf-8?B?V3RVTExiTlhJamU3eGdWRlR2bFYxa2VEUXkyaG9CR1V4ZVRXZEVDOElXaDRO?=
 =?utf-8?B?VWcwT0RHU3ZiT1hBT3c4YnhKZ0tpTks4ZDdZVjJlYm5ydWVTc1c0L01kQWxI?=
 =?utf-8?B?R1RKMnhSVFVZTTBBZHFQaEl1ZHM5Sk9FMDZ5aDZYbUVJVXl6RWVXbTdITnFp?=
 =?utf-8?B?ZllCbGU5dDVSU21nMS93Ym5NVmpzaC9mcVFPSzR5M3QvWTQ0WnNzVDVhc0s3?=
 =?utf-8?B?VThWK2FsOE03MUUvQnh4aGNDdnl6cENGZFl4VkxEc25ydktUUXZMbGxzb1NW?=
 =?utf-8?B?bEcrcGhEWVpPc0sxdHI5ei90M0dHN050OHFKanJaQkVWeDhzTmNvUTV3bEJF?=
 =?utf-8?B?NXVSUmlBTnpkNmk5dFR4SmFaWGN0Y1YydGUybWx4cy9UMldyeDFhV3BuT0tN?=
 =?utf-8?B?Zm5XZkQ5bjBUWnNjaW5IMHdPcWtpVThrZENKR2FZd0NTaU5LTWdLaTliVjh1?=
 =?utf-8?B?ZnYwcFI5aXc5WDl1VXBpdmw0NHBqUlphUElIclpDZS9oOUpiZzJ4QjJ0end6?=
 =?utf-8?B?UjVzUEkyOXlXMCsrU3J0b2xOTzNnaEpmZjhkNFg5NHFIdzkrTm1ySkxCeW9a?=
 =?utf-8?B?eENFcmdRTzMyMVRqNjNvZTV0VURUeTBiby9hWXREZ2RzM0Zvem1FZExZVVhK?=
 =?utf-8?B?QnBTWFhqekxPU2JHSTdEZWxocEMxV0lpM3ZVWHpOZCtxcmU5R3NmanZrL002?=
 =?utf-8?B?K0xVMFFhcWJmSkRPZGYzMWNEdm9BL1hjSXFiSU1TUHR2Z0x4YzUxMWpqdHNq?=
 =?utf-8?B?Z1FSenRnLzRQNDkrTDV4d1BxK1h6VVpZR0xGMnZYd2ZBSi9mN1Y0L1B2Zk9L?=
 =?utf-8?B?WlRTWCtScmhtT3V4THVvK3BIZTNLYldLRk9jYWNodUIzYXd1R3NQS0l1akJM?=
 =?utf-8?B?WFp5SmQ4aTdRWGtwUzYxdlNhczVTZ3VKUm5uWFRaaVVnTVpaSGtvREpDbTQx?=
 =?utf-8?B?TmJuMElWVy9GbGVNeWRPcXdpWUFVL0gzY2Nkd0JvWEFPM3dmQmVRakQ3Tkpm?=
 =?utf-8?B?MzRJNFRvWUozY3lVbmV6R0VWVStKOWJSNlR6a08zVkwyZndUK3BQQXh5YWI4?=
 =?utf-8?B?Vzk2MFJ6bDdnQnVlUXdEaDJITmZhMEpORGFuYkNnNldhUDMrclV1NC9CT2Uw?=
 =?utf-8?B?SSt2OWJzNjFHTXpwOS9zVnJ1ejhDS0xKZVdGUStRdW51TWdsZ1N0V3QyUEZB?=
 =?utf-8?B?djVqa1NrYVR3UDB6OTFKb05kbnpGUXppZUtTV3o2OWhmMGtzYlp6R0c4SDJs?=
 =?utf-8?B?a2RFc1BnUXlUNVRmMENkME1ZSGhhOUxOZGZRVXhYb3lIa0FnN0FiU1ZQSDRN?=
 =?utf-8?B?ME94OG9kaVhCMFJtNEUzcUszOXZlZTlRa1pJVFJZL0ZsN2NyWmY3Um5mQ09S?=
 =?utf-8?B?dlpwOTFqOEZWakNuWFNySG1JQWdwMUNVT2VBWmVaVGRWa3d5eGJ0bXJzc2tM?=
 =?utf-8?B?Y0RSNXNTSHBsNVNzTFM0bUczL2RkSW5LRjV5K3kyMEdkOFRtMTRTdWJ4MURO?=
 =?utf-8?Q?TPU7LamBLY/sRzHqJRUQRy//RhDHunO0z/03f?=
X-Exchange-RoutingPolicyChecked:
	L2AQUbKksgiBfipUto3qTgnlOpbNu/JbBtnhmBSCIXx7VWJvjLL0V15OUTkp/L5gkhfueJOpoZuCTImnDYXuObLSWs3NdTg9SRFaBCncgXtUohZiHOpCJrUo5bn8x8Q9CgPNiGIEEavELBybJum6ClpOdcZeuKFaQmCrQPC7bTxa4+GZBuIPHwrdWTyvyY958JLllfKZSUAJuMfO+cst7P1xmd66eqdZjss42Ghmy5WUtrV/DWGGsLAA2rAqzMSy4ZNLCRtcmCQxcDYPgT3u60ALFDQTBSqr+V9Fkb/Es0Tddcr1gKmpbjlwLaZQT0setobbQU+u/hCeB8oLaCP2Ng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NF5daI+O2DM9EH1+J8iXEzenoabwJpYaJ/BoyKI71KXF3B0Xh1nDr00VHjk1DLdMvt66JBQs4ZOuAq6EkGgsDncVwoVt4YZYdBGokRLf3PjBvr/avUk8+ICTv9eC61ZsGJiE5erpWqWSbFadrqWPU6HSV2vDEe+q+TUVsPdF73gSJnNPYG7m6CQ8Sq+Z7sArzv43Dpll19u9jzAGvC32Oa+WMCP3pnqdbwVMFitmMAZGY893zzYLwlLUZ2Z69esoTVFSntUTMwKt3FuoFFIm4Yd3q4t4ewPUgQGnsc6dfLadA0Ss4gP3qMU0qYrtRyjraUW7ALOycV9/GEBfk3L9L4l9PQkTqsJ+EH4YK5HMQyC6yLJYzdw2VR66FfVeSs+ejGu/i0UwtsAdescfLwX1Y7ArVaDgAaXAIBmdCWmkqYSOLrJcWiNM5FKkzamSTH/giqjoaxuhTUZTrCKhM/EgrFaFQ+s31bmCeFm+KmFgEebbhfYHmO7rNsnwounnc/mR87xX8QmPyjjlbBmb2LUDz1/BByPZHHDxF7K8eu4j2z8U56zma5Ynnw/qhSUhZ4mRZdqqEEllTyh54UZCOHMktWWCKfVKY/I5sg7TyQm52lg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e2c6a5-364f-45e8-008f-08debffc0b34
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 16:37:17.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wj8xwCJDPk2CyyA5EA3T2JM9LaeXmcoju/KtWF4tZNzGuBHHbAvF6Yp5hW7pPjA+2AFwkFHtjO+SgK8OGpPUK+gChv3Q7Y13I0lOdTs5YhAxhyE89TTt7VqZ4GlpEcGn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606010165
X-Proofpoint-ORIG-GUID: To6lFsE1xKGtyUndLSw_X4dJJMct3FeN
X-Authority-Analysis: v=2.4 cv=POQ/P/qC c=1 sm=1 tr=0 ts=6a1db542 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=LhkT__Z0w94Iq4tgARQA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12302
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE2NSBTYWx0ZWRfX4fPWibb8ipj2
 m5JyoUxh2bW5WHQBCECO0f9VNQnvuvlcC76fDeN2+U7v5PpfAtxxp0G6x/bZ30D4LwI0e+VW1SC
 SXMdKy3qTYFgkttoxa8qyvOeMufcmWWlIHO4UN75UMldvk53baUQACmmp8FnMmIVTgYZSTCLWIk
 /Yw6lk1cYPmGK0B+uicSW1awEPq0ZVVjq4rlHnRkJx3mWFgNtrgaJL4aGD8fJryepZlY9Cn1bUX
 J4Q71ucvafvLZoyX4Kk24oZTgb4oKbrgzv4+LCgnb5CtrmyyVQTFeoZDx49pMEO4MXLeYssYAuq
 IJ/npf3W6Nvg+7NOu8im7YHeR46lHqLFozHoXjIvBirixjGJ49ueK/df84JLYiQrCfGwl3giMt2
 x9h/+zcL+yGaAkDxP5YkxqcLleTuoM4tuMf8tuBIrwPV7kF+8xhgiIAD88mfEXm6RXCSoR5Zir4
 vkfvntHQuKemj+4chwSiP6goSGMwwpaqOwE2MfX0=
X-Proofpoint-GUID: To6lFsE1xKGtyUndLSw_X4dJJMct3FeN

Hi Greg/Sasha,

On 29/05/26 01:19, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Marcin Szycik <marcin.szycik@linux.intel.com>
> 
> [ Upstream commit b3cda96feb60d91fe88d52b974ff110dcfa91239 ]
> 
> ice_set_rss_hfunc() performs a VSI update, in which it sets hashing
> function, leaving other VSI options unchanged. However, ::q_opt_flags is
> mistakenly set to the value of another field, instead of its original
> value, probably due to a typo. What happens next is hardware-dependent:
> 
> On E810, only the first bit is meaningful (see
> ICE_AQ_VSI_Q_OPT_PE_FLTR_EN) and can potentially end up in a different
> state than before VSI update.
> 
> On E830, some of the remaining bits are not reserved. Setting them
> to some unrelated values can cause the firmware to reject the update
> because of invalid settings, or worse - succeed.
> 
> Reproducer:
>    sudo ethtool -X $PF1 equal 8
> 
> Output in dmesg:
>    Failed to configure RSS hash for VSI 6, error -5
> 
> Fixes: 352e9bf23813 ("ice: enable symmetric-xor RSS for Toeplitz hash function")
> Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-5-a5ea4dc837a9@intel.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 2a629b9a9e03a..664bedfbd8054 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -8108,7 +8108,7 @@ int ice_set_rss_hfunc(struct ice_vsi *vsi, u8 hfunc)
>   	ctx->info.q_opt_rss |=
>   		FIELD_PREP(ICE_AQ_VSI_Q_OPT_RSS_HASH_M, hfunc);
>   	ctx->info.q_opt_tc = vsi->info.q_opt_tc;
> -	ctx->info.q_opt_flags = vsi->info.q_opt_rss;
> +	ctx->info.q_opt_flags = vsi->info.q_opt_flags;
>   


I ran an AI-assisted backport review and checked this against the 6.12.y 
ice driver. I think the E830 RSS fix is incomplete on this branch.

The backport fixed the PF path in ice_main.c, so 6.12.y now has:

ctx->info.q_opt_flags = vsi->info.q_opt_flags;

But 6.12.y still has the older VF virtchnl RSS path in ice_virtchnl.c, 
and that path still does:

ctx->info.q_opt_flags = vsi->info.q_opt_rss;

Upstream has newer VF helper in virt/rss.c preserves q_opt_flags as 
well, but that helper/refactor is not present in this 6.12.y tree.

See commit: 3a6d87e2eaac ("ice: implement GTP RSS context tracking and 
configuration") which is not yet in 6.12.y

I think 6.12.y needs the equivalent one-line fix in 
drivers/net/ethernet/intel/ice/ice_virtchnl.c, changing q_opt_flags to 
preserve vsi->info.q_opt_flags there too. Thoughts?

Maybe lets drop this and backport it again ?

thanks,
Harshit

>   	err = ice_update_vsi(hw, vsi->idx, ctx, NULL);
>   	if (err) {

