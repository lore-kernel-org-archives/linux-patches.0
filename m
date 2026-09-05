Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F6C78F2F
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 18:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788633211; cv=fail; b=t2ofQOjC/rbxsyXpaBytY+sDht6fzxFofAJjanF3IvebhONUB/2f38m4Rj75fy1Qp1T6dAnQgtH7ZFRmB/Wl1wwUqi/YX4GAYykMtWkRiCL4wgAuAPBTJDY0Y2aZnfJZg5IpCaq1CPkUVlCRvU+uzwJHrAYwdczQ8ENgn19kCQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788633211; c=relaxed/simple;
	bh=cqlF+cO3tXObO1wLYY8232A5ZQdXaK5YCfcNUT+CZq0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W0OB9ll7pjmSpgb1S6YakjnC4+pHrvPexKy7jQtASy1mWhKCkHuaecirUJUO68hARTC4jok8z0w+VwIip3Olo7wIKnK6C7a3F7MsjNai7EPJ3L4/bwXBVi6pC7sYtJ0lEQZ63vSTDFo0sQk6lP/+OvJ91NHIALa10sX0H81A7dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f9SsGhaa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AsBYabAb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f9SsGhaa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AsBYabAb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685I4xX11411706;
	Sat, 5 Sep 2026 18:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+R7fkpKan1YxUA/r6xaEknEJ0UJoFM8/xR5XxQ8O3XI=; b=
	f9SsGhaatpflPmritfR13kvwVl3T1KNiaVy3G7F2z32SvF4bSTiqp64R+We4Z6g8
	45THA+rDBm/XPyKCqlsnVJJpqy3KcFAdvXChJNCIysvx/uTHz63EVZbeBSMAKMn2
	28v7XKBfcP4gpoliZIi4ia8lEZaWbuBjWjL6hDoOR52QhfW/e/vexDICVFFQ1Ng1
	z9xJGikGk9aRqdKpDJQ2aR3zL7+dqNxqgDZVrSek5K5tYfApmRinZ6aAy1lSJuJt
	vAV4OYHfveVaeTsEOdcf2D3aTm3Gtu7KLWxYuoA3rAJBqince5he7qOIs1P8wb1w
	2um3+UqKpn70lo+kmBbnFg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbmq8cd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 18:33:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685IURgn013289;
	Sat, 5 Sep 2026 18:33:24 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hmvpu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 18:33:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f+7F5YAcFMBKwB95S/2Tf46V3Xj/UrERTF+ZpXWsCmwotAzVXv0VMkvS2v6GMk3hLw/YXi5BI3mdJOHyJwuXGGPb7yAM7gz7OnwblN5KwZuWDghrcy3lp9vsQhDNRjswQnZD76/eNS05a1WQ6nBDrUXWRVpW/J+Q6GZiP8NOERGWxtYRkZYgunSq41apAC5yaZFsO00jfV4n2NCeMlaN3TQ7BcF2gMhL/4ebpO5e6dDpp+m5pTaFW//IIiTpnYsfu4d32DIxFpf4l2PGp3lNi9ZERprIUyaKD7nCD/sO4/iGgWfLlOhc0B4uFHHTeuxJoK/54X0lh/YPR/yZgj0FqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+R7fkpKan1YxUA/r6xaEknEJ0UJoFM8/xR5XxQ8O3XI=;
 b=bsV7DSr7bLkFfJ0xxPa/GKLKTxuqYxGamCKCW2fVGfmaQnRQqdSWpbXYDSQWk9ETCugnLzmSh7g14TiwB6PERamiaLSBGUf7sjjuQ7dZTBGAKLjuyANnPgvg+PtBbS5j7Zqv+I0NWVk06C3nxCcPb/ATCB5gNOmaog8QhlAmgmUlg68YCnwrbRcRkaSIYy/8w2FXeUo/2rDggadoiwnHCQ/9kGGS7IeITEhVBJn58+yFe3Zcmo09ECtfUDZDASPwyORDJxB4iu7hq4af57EGDjA37bRUfH7vOz4Xl26eBJYjIH/O5S4H6SqSCbv9Z4/Ibz/ySyYtl5+T9GieCopk4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+R7fkpKan1YxUA/r6xaEknEJ0UJoFM8/xR5XxQ8O3XI=;
 b=AsBYabAbhPXUJzOBY8yiZu6C3Xj8DXVTmrfj15/gTgEHLLAu+BVzFRFPQrmUDjLcQbnlIJR3MiRaTpmm5M49ycZNnwGa08s939v53kXgFcJV8Z09ANicYh3icA1CYaaM00my9cNWrvlTCROeQMk49A8jYJ6uLZ8pkkrXpFtb4aQ=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB6871.namprd10.prod.outlook.com (2603:10b6:8:134::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sat, 5 Sep
 2026 18:33:21 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 18:33:21 +0000
Message-ID: <f6e0d197-ef12-4606-be7f-4d2a0e14b3c9@oracle.com>
Date: Sun, 6 Sep 2026 00:03:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 349/403] NTB: ntb_transport: Reject oversized TX
 buffers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Koichiro Den <den@valinux.co.jp>,
        Dave Jiang <dave.jiang@intel.com>, Jakub Kicinski <kuba@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045742.751218740@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045742.751218740@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYPR01CA0062.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2b7::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB6871:EE_
X-MS-Office365-Filtering-Correlation-Id: dc24522e-e346-4f95-b89b-08df0b7c29c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|56012099006|5023799004|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+9pNV20e1ni4thgCQNFmyBlSjrho4V4GSXCTxq4QYLZPrZsVCBCZi2k5toNswnBkX+sp0ovB6Xe6FCJHUA57iK0HmCzE3+BXyEpbrnFmbULc15iWghO5uY27/dQfhfbwkP5ogydwGNQZ3p4rG8aFqDoQtr+PSAh02DSRatgMia+UYMGlwshE7sb3v0C9S53iezBfgkv1fWDZ6FEpdXT30ZCCzMf6b7FiHBlgx9NSCL9bzTf1GtouHyCxl395wAZPkh+QDnrTdmN4+yRHDMzUpym0zN10h7dgeogjK8ctH8D/Zuqc/yF1/7KECSnCOCQJvaiHoYn0RorPBU/DChVg60XrocDPTWcZZmgujsZbgzc8LtqkDqaZc+5Fqp7gWniHSo7O4KNvR/OAiOoN0Zg4R9yRAWWGV0sNG8Mvr4rOD+5B1ChYl/8x+u1ctsyMMWreGcXaXz6+I+jA2aEBOfdk3tMf7KrulGao0nZ1z5BsDtuw0pk89SBSbwz2E5EE4d+7HfSKIwTb8qytuTKuhZxrJJ5eGggjyFW4jJmek78OmY4Am0gC0Cwt+pWuQlaaTduCBhMue1tQJ983jo3tUIWvlo7VV+OQYtuujlMIscuKFJpe5ztg6b7CY0mPHPYES5pm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(56012099006)(5023799004)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTRFbnc4YnhabGlHUkNhcG1LZVlFQWZuZmNNQVdKbUFkTnlQTTJHbEFkQmNG?=
 =?utf-8?B?TUZhT2t3cTNKZExxdFRWSXFVMm5KeTlxK2JIOWcwVWFRTlFpV1FmeENxckpI?=
 =?utf-8?B?SzkwbkJpQUVGMnYrWnNUOWJ6MURTRHYzb0RNb3NzZ0U1RVlzWmlMREh5Rm5N?=
 =?utf-8?B?SE5FK3Q3WU1EdEZjVWRoc2Uyd2s2TGVOa0RaR2tQaVlOaFo1OXZkMDdSMVVX?=
 =?utf-8?B?eEpQbHA5cEtyYkNucUw4OWRKdFVuTVM5OW5kUzVYZFZta2Y0eUZtR3RHNWIx?=
 =?utf-8?B?cWg3ZlpBVXp1OG01cEVUQy9jSkJ3MEhld3V0eStEQUpXSXhUUHh4N3ZncFJN?=
 =?utf-8?B?WXA3aEhlRTAwSkRzTDV5eDUyYVJORHRMY2RQOHY3RTBPU3BYbjZmQVZxY29K?=
 =?utf-8?B?REVubDUvd1lrL0k5UVhNRGNOY3RaNW96YXhlblA4QloyVDh1Y3V6TG44VURP?=
 =?utf-8?B?ZWtjZ3pZUndHbnZQVk1abExieWFzZVVRMEk0cE8ybml2YlhTdG9qWVlwbWxC?=
 =?utf-8?B?RlJMVVM1SlE2MjZrZEh3YzZXUFd1WUZ6MXpHMldhVnRkdUJzN3NrVE1UNTl0?=
 =?utf-8?B?MUR3N1Vzc0dFd1FqSDBCRk1GSlZtRkhobGJaSnFMNkJVNkpFTFk5VFZoZzlw?=
 =?utf-8?B?ekRkcEU1YVd2MThKeFo4a0RBSzFYcFdnTGo4ZktLZk9meGxaSk40dkxMUGdB?=
 =?utf-8?B?MDNVUWE5Qm9UVDdONkExaXl4b1REb2M4SGE3NTAvN2dVSTdwOG4va1c0Wk5Q?=
 =?utf-8?B?R0NncUdTb25zN1pGMHpsTkM5T1JueXlIUC9TbCt1V2JjRUVxSGlJVTkwNXR4?=
 =?utf-8?B?WHpsTTFLOG1UK1FudDY5b2dkbUVkVjRBODBJbzJNdFNCSmVsUCtNY0lrZ2tj?=
 =?utf-8?B?TE1WcnFhc3J6VUJnbS9CRTVrWUNuNkE3d0ltbGVpbVFUZTJiYUFCdHh6ajJj?=
 =?utf-8?B?ZE0wdktMM0lTWUt2SEE1c0NocitxTjViUmJBRGJaUWtXQ3JKemc3SzBYUmM3?=
 =?utf-8?B?bDM3VDJNbTZzSXRVa3FlSVNreU5ueW9QWGVFTmVwcndTTHlFdXlySlVjZEE5?=
 =?utf-8?B?TUhEd3VTZ01aWjQrTXBTcEIvZytJOUZzY0Q0K1pQZXM1WFBMK3I1NWc5Z1Qy?=
 =?utf-8?B?aXcraXBTdTh5MFBhaDFocXNKR2tXaklaTFdQakNxcUlJZU8vS3h4bzlTWTZW?=
 =?utf-8?B?QWg3T214T3RoOG15KzdjMTk5RDZ6SGEzZHBTSXNiZWNGbWhFKzR0S0VTdmoz?=
 =?utf-8?B?MVZPckhWS1puZUQxSVVBellHYU11QlBHNG1vWVo1MTYvYlluRWgwWkNudEpH?=
 =?utf-8?B?QkowQzY3Z29wKzRKOFovWmhncWFVWCtIdmsyV3MvZmZ6VHJ6V1E1alZQaXZo?=
 =?utf-8?B?dUZ1U2xuRUNpV0czL0NNVEYyclpoZEh3V1NtRHFRZVpBc0hlcjZ6UkJkaWEv?=
 =?utf-8?B?N25oTDRJQ0pZaWF3cDhDZlVldVo2cDFVeGR4eWZiRVgyV09MSFo1MURUT2Ex?=
 =?utf-8?B?a21GYVFPN09lajRBekxOcVQ2WDNBU05WaXVnTy9rTExEdWpWbGpmTk5YeTQv?=
 =?utf-8?B?QWRvNUFINk81SkFOdG4xVTlSTVExZ0NsbHlnQzFHb3Npa2Q2dXZ2QWVzMlBi?=
 =?utf-8?B?c21jZERvemhtYzJMazFVK0FzUzdQeHhFK2JMcnU5Y0szVjR4bkkyOEkvL3BC?=
 =?utf-8?B?MTNRdlA3cTF5WXFlZjhIUjdZOU9xeDc1amZPRE93eS8wZ240U2t5MFd5OHV2?=
 =?utf-8?B?RFJwRUZxRXJFSTdlQnFYemY0K1ZLRFkxNXRqRmswK0Fhc1FXYW5yWFRJaHB3?=
 =?utf-8?B?Tit5L3lEODBiOFcxN3NLSXlzT21SYlpWYlFKeXQ0RXU1RUJlUXM4V3duVUEw?=
 =?utf-8?B?RXlRVHlqMVBxMEpQYlRGUWRrdHZyZVFMZHJWWGw0aUphbGtSTU1tSnZoN2Rr?=
 =?utf-8?B?ZDhKSTBUSGZYMFdtY2JLcmY1WmdkYTJwbVdKdkxycGJZQUFncTRqUWVqRVhW?=
 =?utf-8?B?Um5uQXU0Q0Z5d0VBdWdtNkhrQ3Q1OWR4NWZkNkJBeFBHUVNQdy9VaUJ5MkFX?=
 =?utf-8?B?N1ZqWkk4T0twQWF6TFhKQWltRDN0NDZZSVlYV25wRWdVUHlzbWJLa1JQUGVz?=
 =?utf-8?B?YzgwbWNxOVpPVWJnNjNvSU04Nzl1VWkzdFBxdWlrTjNmWWJudGlPWVo2bzV2?=
 =?utf-8?B?UTdBeFNrTWV4dHp4VHh3dCtzeVdRT0RKQ3Z6NFVyNi9GQnJKL1gyc0QxVnpH?=
 =?utf-8?B?ckRrUDI4OUI1YktvdGN3MnZJdTVxRWNFemhJUEZURFM0T1FaOHNwM1o1N3Fj?=
 =?utf-8?B?WXdYNHhSS05pRnFocHgwUzlpYXdOWGpsOXgxcGVrU1U5azF0M2FERnBCSmpQ?=
 =?utf-8?Q?61kmEf4O7Jq82oWN4tVT+WjmZCdNFbMmDnvs+?=
X-Exchange-RoutingPolicyChecked:
	J3iolTSix8ZU6s0t9TDe0UMg7LWfyyS2aeoDTdBeJs36UbkWqsZB/MFWFX2wB7Ak2gEE4i+pn+5Makm3FtznvCzvfs0YTapX222k0JU+NIzJd1cCxI5pAwYWk2FhQZPz7ozQTczgRG/0ipLVz5r1njGPSMcA8oG54+9YSdrKrEz1gNpLUZQLSMjiANV6mqk9tLCc/9Nsppe5AO5NrmE2nqEETJxImeN3zI8xOszDL3ahDa+XMZntBAuiZqIIePU9AW2iEBtahyyTVMbX1/3Ppf229674rJZtDkdH9vBjfffIbaPxq8ycE+hltwX/+YZbBnCnZ8Wt2LKZfxFwQuz0gw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w+PC1JQAZM09slyw4WbiJTkZsR8iGuvBofkwiYpdA6cJOnDiXprbixS+UX9EVLKRRBsiEHocyCFpOT5whqszhRYenebHgwDHOF9WhsrGKpcjhvLQv8KwegZlKPfEa24pq95XisJ7jygS8Njig6JHNtD+mtEmMOwx11/LvxPoyADlTDWEJp6fbLeGpJYY+4CD/yjeBkqWULqKSAthk1Iwm+vIlARC5mtoIDgvEV/T7GrnxPlDs6iDILw6Uzp6OBWfJZbMRJKOkwbXESWzuFq/lDnmm/3hBySTG4wN6Rm2OgAXYqONFGmLjOG60hs2OoBJG4hHkYJStL4SfgQCLiQEpuHetf8aS1DHAVBspk1K5UAsHfQSIAlwAkzXyZkywu7O6Ofkp1wYt/ov9qqyUNCfKTIOoIxHCkxpIUojQM6n/SOarOsAkb+Fj+xg5dmL0oMv/mXos+aM6LRXrWWROjJ8MjruwKJgtPL3fA5h+GihUzatu7I5IXDdjoLEZDxlUZfjN5UP8v5JOnd99cxRVKJk85qH1fjuSMYHk9D+6y/qbNG9qV8+evZrdJXat8Q77rgz6qBdiznOrNiddZPbd6n0NMbFEeHjl6Feb6woD8t9IIo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc24522e-e346-4f95-b89b-08df0b7c29c6
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 18:33:21.5427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0qibh9hEAVi1tafRCi4xWnycXaBGLeQhZKdvl8IVuyh2oinbdy4zWQCfIP6j41bhgx+QBpTjTTqa9aWrYLmKXg6A+M17bRkIpt0IBX5oR7v2GiLLWkG3SBI/dkp0hwJg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_06,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609050206
X-Authority-Analysis: v=2.4 cv=JYiMa0KV c=1 sm=1 tr=0 ts=6a9c6076 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=EiwrEXLOZUgQKi9E7pIA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIwNyBTYWx0ZWRfX1oDQA9bUpcjP
 O0SCiGdKIT8Ah0SHCbtoqbwo1lCnq96AbLgRXWe3dLqLm52x4Ia18by0xdWpAyoYaetOmXxgbSb
 6JHsn1dAPj8IsYC10yp6giDNJm43ZfT0U0HwyAqZxLGI88Os3b6rKPQgpF4XKT603GF9nA2Wdz+
 0MBn1eBnxyfTrZYmgrVRKD9Ww4we/22JMHfS024RkicirsakkG6+NG+MUEjd5pnBLQEel1XYL31
 gOl1k8lDajsNol8FS+Be8HIWsDfXdoNfYe2eYWOlsprPeA8MOXMehcDIfi5q5hoW2zAwXpdMI8Q
 2h/ikLNcMC11+kgtTNFpeLMJ3qXPLov3GUOY9zukxw1+QDlF+ysq/0G330nvnv5wc1JdoWQWuL7
 z6HvTG2OKh2cKsjsDrJpiUrmb0JLYho55TqCXZCvH35AGq+rEv/w0TDhc8I7zKIxnQcXbmBSXoM
 Kr/4yYFh5qy2cfNGDYcfy0Yhi/zh/DhVrXyFBA8A=
X-Proofpoint-ORIG-GUID: dcTF-0PgHCMhaTn5otJr1J4v--8jFTCd
X-Proofpoint-GUID: dcTF-0PgHCMhaTn5otJr1J4v--8jFTCd
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDIwNyBTYWx0ZWRfXzMX9wYpxPvys
 kWo3SsZaBlNPaqevusFzV5J2fvXjmAuG3x5tL0OoMV/5AWiN8Seu1njH/z4ekhPKxvGdBLgrLiz
 HvXmUEXj2ForIzRICuE5vgnQ3fLl4pa+K8o0l1O08slOQAXOSKGY

Hi Greg/Sasha,


On 04/09/26 10:32 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Koichiro Den <den@valinux.co.jp>
> 
> commit a4f2387db6f1cc2f03abba7f3a6807ad61e26ff7 upstream.
> 
> ntb_process_tx() handles an oversized buffer by calling tx_handler()
> with a NULL data pointer and returning success. ntb_netdev therefore
> neither frees the skb in its completion callback nor takes its enqueue
> error path, leaking it.
> 
> Reject oversized buffers in ntb_transport_tx_enqueue() before acquiring
> a queue entry and return -EMSGSIZE. The caller retains ownership of the
> buffer, and the preceding netdev patch frees the skb when enqueue
> returns this permanent error.
> 
> Fixes: fce8a7bb5b4b ("PCI-Express Non-Transparent Bridge Support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Koichiro Den <den@valinux.co.jp>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Link: https://patch.msgid.link/20260817053519.4135287-5-den@valinux.co.jp
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/ntb/ntb_transport.c |   12 +++---------
>   1 file changed, 3 insertions(+), 9 deletions(-)
> 
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -1927,15 +1927,6 @@ static int ntb_process_tx(struct ntb_tra
>   		return -EAGAIN;
>   	}
>   
> -	if (entry->len > qp->tx_max_frame - sizeof(struct ntb_payload_header)) {
> -		if (qp->tx_handler)
> -			qp->tx_handler(qp, qp->cb_data, NULL, -EIO);
> -
> -		ntb_list_add(&qp->ntb_tx_free_q_lock, &entry->entry,
> -			     &qp->tx_free_q);
> -		return 0;
> -	}
> -
 >   	ntb_async_tx(qp, entry);>
>   	qp->tx_index++;
> @@ -2310,6 +2301,9 @@ int ntb_transport_tx_enqueue(struct ntb_
>   	if (!qp->link_is_up)
>   		return -ENOLINK;
>   
> +	if (len > qp->tx_max_frame - sizeof(struct ntb_payload_header))
> +		return -EMSGSIZE;
> +

I have run an AI-assisted backport review and it spotted an issue.

Upstream commit: a4f2387db6f1 ("NTB: ntb_transport: Reject oversized
TX buffers") returns -EMSGSIZE before dequeuing a transport entry.
It relies on preceding commit: 8aaa47351db0 ("net: ntb_netdev: Fix
TX busy and drop handling") to free an skb on a permanent enqueue
error and return NETDEV_TX_OK.

The 6.12.y ntb_netdev caller still does this for every error:

     ndev->stats.tx_dropped++;
     ndev->stats.tx_errors++;
     return NETDEV_TX_BUSY;

It does not free the skb.  Thus an oversized packet can never succeed,
but commit: 9d457690ff8c ("NTB: ntb_transport: Reject oversized TX
buffers") tells the stack to retry it as though the condition were
temporary.  That can leave the packet stuck and stall NTB transmit.

I think 6.12.y misses commit: 8aaa47351db0 ("net: ntb_netdev: Fix TX
busy and drop handling"). Thoughts?

These are all part of patch series:
https://lore.kernel.org/all/20260817053519.4135287-1-den@valinux.co.jp/

thanks,
Harshit

>   	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
>   	if (!entry) {
>   		qp->tx_err_no_buf++;
> 
> 
> 

