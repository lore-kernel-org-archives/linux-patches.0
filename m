Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96063468C08;
	Wed, 16 Sep 2026 20:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591084; cv=fail; b=AOrYyDO3KXGib2K6KhR68LxYPxCj4fnQL1Q68QboGRp6lxnJJJewiFkuySKDGlMONW2SPat7c+CM89kIEozqap7KnoDb6Nwf1zhoe5ekQw/EsMElq9eoxvR69sWOzvorOEk7j7jCHNvOEtEm+Me1XEikEv/ihJy0QgEbwgUViaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591084; c=relaxed/simple;
	bh=GPh+6WKxz6qKM6hqBCIkHQER72/+1zHJF9cG/AmPNFA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KW7gf+aIIEpcenm2yawF0KJKJmUL60nt3FzaOzzytCVU9gE4/SmNjFhEpWlVq5HQm3ACz/Fu6Vx4bbe2JtUjNRKlfkEWbyeR0aWEsLUCiH1xJNRVtyjhNCv/7O2f1Vw8NEFuOMr9ao0IC3BgCm2a6lPZriC81xUA7KRJ1fzdR4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J42YoLAE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t38rIZsn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J42YoLAE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t38rIZsn"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEBejj2379962;
	Wed, 16 Sep 2026 20:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GPh+6WKxz6qKM6hqBCIkHQER72/+1zHJF9cG/AmPNFA=; b=
	J42YoLAEYUG2cNWbZAUfBOjGV8QO4YwHIcc5u0W8D2vzp709G/aE10M25kUtVkHc
	3CGAyuLg179PBH9wD89adLxqd5e2NAQdQjgmimb3ETKuJsNTPJmbFdfwmSsmk/ml
	JvQVMCSGdhPiVt67mdMVBYQxym7prz/syCoDzZGBwvZnhPgx2Ir3+i092E+++feU
	cxN1Iy1jiMWIzAXHKa6SQJnaMhydKsunggujq84pmpqwrQ6uEcdw/PQDeppzAqig
	JuiuzS+OE+Ek89eBPADf9TF4KMQLBT0zvpo3ToVoQI76tR7zhTd5iMUJf3Mz/3lO
	kRNxRMigOCUIC4Bnky+I+Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7edek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 20:37:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GKYpoK039620;
	Wed, 16 Sep 2026 20:37:41 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6e22u1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 20:37:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qb1JC643hk1xACbi1zePEs8m+aIIjB8np4zvRccdlEO1xoWQzFNt4f6LuY2RtWLH8/KMMuvUiNiZ8OVKaEzctAmc5qjRdiTVGD3YK9U5fFmi9awDxchCIjqSq4W9NvVI7IdJ4k2cSlvksjHEfoIS3uCk1YvV8ZZNehPd/rC0dPlaCnRQQgnumIDxKDCebqLgqRvnyMwv4Rv67JorqJxb6zaqGDOs3aAPvMIBqhE+jLdIvICUfJTJ8EnZifo76+nhKw317GdthuaA+t9aSipaB5/2MJnc5/5C7F522iKcpVE1TPKQnuWnejKApDn318UM/oMKBzNiw+qIiUbkKawRSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPh+6WKxz6qKM6hqBCIkHQER72/+1zHJF9cG/AmPNFA=;
 b=Me5eKMsHEbq0R5dQiIYkjreMRMtpgpApnZRUS8Ynl1SRMWOMnLBXv0Qg52/DJwkYPM6XWZVRGwonWjdJ/gcmjVf5JLBsNo3WnVi+ag71K5TsYtjuX8hpkLaBus8I8l+iFcCVV5SeSZzUa+uflg6OrAmG4sgXza1H4jjK2tAZP5FGnRKtOZkQXLMsVvlIr6pCbJmC2hHUusOxL5iEvfIrO+pgafKz/lGqoNWnA9ehfOMX/xHt91N+l2/gC0SSExmmsbMKNnhgugcr2vRx9mvb0A41GI1Ls8BCbRBW0apXLEh+LHS5aKfNVMk5MQ7QK7mUDzQPYcEB23fYZSIv1zmrQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPh+6WKxz6qKM6hqBCIkHQER72/+1zHJF9cG/AmPNFA=;
 b=t38rIZsncDx7Q8Xtg9QXAS0zsmW/loMWdqs42H5jsbq6uVAhFt/KfhKi4swGUsu+Vvm8O2YE1+43ff4vCxs8qIWZdQFLHoxVTkda4iDDMsVA6rI1im3WQNVRHhri8XWIGXeXO6kZtqP3rQhH59nZeDr/8e+PFyS1DuTZvNjY4Nc=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA3PR10MB8707.namprd10.prod.outlook.com (2603:10b6:208:571::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 20:37:29 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 20:37:29 +0000
Message-ID: <2eef66e0-230a-4633-b76b-71326a481d11@oracle.com>
Date: Thu, 17 Sep 2026 02:07:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1031/1376] xdrgen: Do not declare union XDR functions
 in the definitions header
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chuck Lever <cel@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <28b2ad9d-520b-48b0-a4df-d940bb21bbb5@oracle.com>
 <daily-reply-20260916-0017-re-xdrgen-union-decls@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <daily-reply-20260916-0017-re-xdrgen-union-decls@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA3PR10MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a344c4-bc82-4634-5786-08df14325358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|4143699003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1wm3VWra0oHNpqIKb3g1IjfDZhzoA+mMJaeIqNLQPas5rjdikZjsMHz9mjG/IkEVXfAWUsvaSJEzNbmiW03fJSB6ZeDadQ4zp9OBx0RoQSlOZfCFvX3AioDgE1kYl2r5m66txEr+fP98A3+lq41Os1GFk9TlOpuP2Zdq9kHy5qRePmcr5LpJ7dRkbIbCFGHqMh0Ja1kgRLSl/wPO4bq0VYDEEydFEYVsrxKcSUKYiEjiugxPwIf10DbeFhE+k4gpreTeByBr2Af9oPLhzhBAYrtM21jhMbFfZSaqRapk06SRM5Q2DgRvtBJ3PiANoCk1Ns5y0iDMIKQXIUjShn0LAoSwO8Qc3xQokM9FX3A2UzmsdBJR1xhsCId6o3uDkK9hSrjfGFYsVOmp+cZH+pVWXWWrLmtNrLBmFkXITi4Lv/hrUT1BriMYrsIFkOqkkDnj3JL0GLjtGdofusjHNnJjJGrxmAnoMTr8vrBsHF5bc5l1OCue8ORAoVmYIU0SmKNdiRsrTnmcb/kHFz0VfDTcgmTsS5xW58p6oGzQLvKzukEwgx8jFYVZYeJ2KVwUarCRpYN6i+UGro4+sPJajPw09o5vpbOmvhFVFYBzb/TKk7eIvmMRjAqIi9OZrCnHteXPatrPtgDwdelnXk5xFzuF2iKqxQC0qJLf8WeNoL/i/jk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(4143699003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MzQzbFVPNDhEZmtCWVNDQW1TanRsYWNFMUNEcHdvTlBLemRmOFk5MFJwQWZm?=
 =?utf-8?B?UXVnVnhrYmtnY09WK1Rmc05NbE9QL1I3L3RKL0RpMGtxMTBQUG1BVURJRGth?=
 =?utf-8?B?dms1UXhkMythY2RlZFRMMDFqTUxhSUw3NkYra3oxa1JxUW1GZUYrMDdTY1g5?=
 =?utf-8?B?VEYxaForaEVubld6eU1ITksyc0M1SlV4UVBPeE4wc2VzbUwzKzlpckFhODRk?=
 =?utf-8?B?MmpaaFJrbUh0L09CMDEybm9wc3d1cktMbWY3bzBBUjAzaGhhWTE1dThlZ3FV?=
 =?utf-8?B?OUNiUTdOWERmNjYwYy96amxjUHVxMThzNitZK0l6UXUvMnUyWGtWOXZ6ZnRD?=
 =?utf-8?B?ZGJab2d2aXVJbHFnbHR0bkhrSE5ZdGJFRytyZE4ySGVuSFJkYlZzbHNxZ3Zu?=
 =?utf-8?B?REh0aEU4b00zQ09GK3pmMUJ2eEh1cnBOOVJBei9BNjc4OFBtenVaLysxNUJj?=
 =?utf-8?B?VXM4QVRQL2lBdzlyZlJZSndoRTF4ZlNuRFhJNkdzYnFmSDNpa0xDSDg3cFJK?=
 =?utf-8?B?TzFDQ2tkNDJyYThPZnYwTTZCMTlyeFNrczBHcUxKTGgvdlhPc3h5TS95RTNK?=
 =?utf-8?B?bWF3OHQrV3grQ21SNkJQK2pWZkFuR2ZnWjZBUkJvaWZURDhKSnJSak9IOS9a?=
 =?utf-8?B?ZHhFU0JkTWI1RFh4UEFDc2dnS2RPMzZQOFFuVmJpeEU0VW5RcDNOdHZVM2xN?=
 =?utf-8?B?blVxZ0pQNllwOVFGejJ3ZWw0aHJ0SUNjVVVsanpSS0dtMmxVblMrb3dySnVC?=
 =?utf-8?B?SGExaEY2MklOdHRKbVgwamRpZ3ZlSEhoMzZPS09PNWthazZ6VUtIREJmWWsy?=
 =?utf-8?B?aFE5aDBnTUcybTlqQWRXTzhTaHE3czNyUm9vNmRmK3dLRUhDQjRpeXlwbGty?=
 =?utf-8?B?YUpoTmRoSGlKNENkdzIxZGVRcmErNWNqZHlRL0M3WERZNlVGd2ZGc2NTaGlC?=
 =?utf-8?B?bFViR3M1V0tvbWhkZXl4YS9KQ3hiQlNvY280Q0ZRVytoeU5id1NBYVlNNVdm?=
 =?utf-8?B?aGdLaXpxU0RYRmNFdXFKOVRQbVd6SmlDVzhYVyswZDhSdis2WERNemRMOFV4?=
 =?utf-8?B?Q1c0ZzJYbS9kQ2UvN3kvWm1uaWZub2ZVU1BJNm45RTJlMTBPSUZycHc3Nk45?=
 =?utf-8?B?OW9VMi9yaE9pSWhyb25MSXVXb2JnUzd5Y1hUdFRtcEYzd1dZWFZGTkc1NWZL?=
 =?utf-8?B?WHk5QzlUZ2o1VS90SHFiSU9zVXR4elVQMVVNc2wxNSt2T2Y0Q0FXNEJMd1g4?=
 =?utf-8?B?eERyUzZVbmdTOEhzdjd1TDFqYXh2ZWRtQzRXeno2OHNybnptWTg2ZDZhNENs?=
 =?utf-8?B?d1JZRS83WkVvdGdwWUVzbDIrMGpkY1FKVkdlTUVmcXlRMzBwaHk0UExqUTBP?=
 =?utf-8?B?c3ZaYWpMZlVIcVNkRmJYdnBFZ2tsL3pzM21tVENXcDdNaDFpbUNEUDZ2cy9E?=
 =?utf-8?B?YmlrQ21DeU9nZENQQnpqaDBiUW8vQnNnRkg3bTNyU2dPbVVKMTcvdGpmTDQ4?=
 =?utf-8?B?cEFObU5KbUZrY1ViN3lIMGdEL3I0S2pSV21HTWJpb1VNbFVsYVRyK2YyQ05R?=
 =?utf-8?B?NmdqUUk2YWRQL0dFVllFdy9YTUlwNUdkRXpUV2U3WWdLUVJ0OVlOV1JTYUZh?=
 =?utf-8?B?dDRQbEwrWW5aSzJXTkpkQU1rcTRKeDkzK2VBOGxsVUFmT2JFVEZLYU41WTZK?=
 =?utf-8?B?bFlDbWRTVUhEV3RLR2txQm5ndlBnUVcwdG9ZM0JGUjZZZUIwWGVzQmpUbmRC?=
 =?utf-8?B?OHcyU1VWZTdJaUh1S3RSWXdMdHBDTlN3OFVEdEdUeXByQ3dseUNEZFdpR2NX?=
 =?utf-8?B?WHBNSUtJWGIwcW1XcGc0UEJFak9zZ3gvdi9menVKc2xoTzFuQ1c3WjdzQ3Qy?=
 =?utf-8?B?VFpVM2lkeXZFRDZIbU0rcUcwSDFVRXBkRGIwZ09tcmRNR2pQZ09wQmMyWm9Q?=
 =?utf-8?B?dW5QQVE3M0E4NEgwK3pVbU10ZFRWdUZjSkJyOXlrK2VBNmFlanUvN1RMR3Ri?=
 =?utf-8?B?OTVtUUdjY0JLa3MyM0R3OUtWaEZFRUlsTGZlaC9NMWMrbUNZb3Vpeis2bGhn?=
 =?utf-8?B?VTl4M0ZVL0FveDdPUHJuYldSZ0NXUkp2K2N0WElibGNOeVlZNEJlaituU1Jw?=
 =?utf-8?B?ZmMreHZtYmZjQ2Mzc3RLdkxrUERlY0ZMa3JORjRrdlNkL0dMVlRWTnllSk5h?=
 =?utf-8?B?WVhIMmZIMDNrNlVqOW1qUitaeUtVRzNKcmZBKy9BSjI0T2lpenZ3Tm5sRk8z?=
 =?utf-8?B?dG4wVTg2Wmp5c0IyTmVNbXEreDUyT05EZFZOZ2RVWEExTXRuWmo0SG5YajlN?=
 =?utf-8?B?T21UQ1cwUk8zMmhvbm9zZTJsN3lHVExCUjNTTUxRdkhUSnQwazBsMXZVOW8r?=
 =?utf-8?Q?zkG+JqFaD0KLO2xrd+Hcex8oI6GfGZ7rnfnF1?=
X-Exchange-RoutingPolicyChecked:
	I2wvDV1SK6NOlVsb3oZnc211gLM1AMHsVdp4VQiAmrmrjCz89nRpiVC1UQGlVapRj4ytzWVNuk4oDRfrz0ewRPEAnoZXzP1LdA8TXe9t+H+uYCRo6HhVFD21CQCNnRwGWxSzcxr+PTnVyB55yuL2ArJ2vHr1UVHDxc8Tc4gOQcF9PY31RDtEkDV6R9M40yuwP7aT1w3JHD6g5B/CXu9lKs8jmNZqGr7epFEl551Gb26qaEBm9RGF0b9DHimikhltZ9xxzHVruPX2JcsIOEjFJ6a0uW2hizCJoKarQ8tKtqXiWdFpMtx57kb2lbsx0QPgWUnmE2VFFHanxF3VoEDISQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2gA8KXgwsj8fyLDyvK/scKbqEv7mrEHUxkN5Dvj8JQmVSRNf/aNnM3hDVkudZprYPj5E9nodwjdeAMLOhKe4Fi4eYep33HkQyaZhZ44m60YsUHYaEABYSmd7uQd75NL+YTmEUhspKc68INTbuSPmILy3cc8ufcz+wK/JUdTVju5X51sE4oV0OQZQzQDETA3wOJYSiMnISy855y59tJMfZWLoXfuLU5RnECwi4jgLGZ6DcwfAkWQvyU3yKtIE/HXr4x6S5OItCAU6VAMmvFoSVXEW1zOYALuqTliDRS+QkAWHcGleVv3lJ2A0qRsZIbX/VBYUO8wUlG7Wfa3/YCtz7YfqjjZqq1elo2bNQd+mYJZfu6Pl3lLxZnVHX4zZUaEramZfX5OwdkE5iHXtHxM2KJKQOyt9Mp35sPakjHwKEl7Kwkul/MdBzrEGPpGUFQUw0notQ493mITavjCgjJoFXluQdQG6jbfP4LJxal0Jkx1fp9fcDrnGdmVFV6zzdl4FTOz0AnYigBvmg0YS302eRRNykcGlk4fpOH1NwiuTbyKQqd7TUP3tPFdjsxaWGeb/RMV9tJleRhesluFi0/hdAmPZ389zRo3OA8Tyas0hngY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a344c4-bc82-4634-5786-08df14325358
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 20:37:29.0246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyxL4ys5/3bPUiwE9CVuKHN+QGMFNykXbu7VWkGdQ4A2xV9su6zOJffIMOPMfsqtYW6vaXW+kXCTt0ZgGNOYBs9eYXzSwAsbIoREVQw0mo6pBVX4SgdxT60jr0CLZPeu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160286
X-Proofpoint-GUID: osJFKDt9sl3jBNjtwJMn4nXNnd0F8fH-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX0KjDR4mWsWNe
 x1whCYroDXoiE5B8BAaQNuT8l4fLP7D5i1qykx5Hr92Uano/1Dch5R+tN0gHTxu+eGtpLurStyA
 KcqGYMauyQbRkgc7K2f3m0qgqXnnbpTPKxA/B4D3wUgTkuoWLWRIVM1TBrD5gI7vEPyVT74tzCs
 TVKWfJpZ5ErxwiCfwuHp/FJNmTgtfL82kVzHLc8aIM3q79j3kSr2DmLFNsPjkECCCRHdlWEXx0P
 rVu2tJ7oa6kEQr9ood/bkrEItMDzP6G6b0nPd3s2qv3At80Su7Vea8bnpBMXNK30hdCrOWZckj5
 nRZcCZYQWVLAwj80GlVInhaqR/2vLk2eUWGQyxp25PaJ0NUwZP8nlHvumqUpMD6c38RNJ4LZ3lp
 bYlO3HxoEu84GuQcAa8lNmlm4nBk9FWkFDY/1/Q25PMoqNDX/mC18er4zWs8bv8mwzNHqrjVm/l
 AxOqATyCys5ztvuu8XQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX2xl1dZ1UZti/
 i2YjBLe8rnzVjf5i9NVxhgswzIw3AQldmgKX/29BnVg1+Kqd6uLmW/fJUtVYzqfxBZ4Wt4MbTqh
 yyO+jaVp6/5EfQ7EI+3ceLaAxE+TX5tOks/oYxlsK69MO1OGH+Vx
X-Proofpoint-ORIG-GUID: osJFKDt9sl3jBNjtwJMn4nXNnd0F8fH-
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaafe15 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=pe3p3pft4Z6mDz5g1IUA:9
 a=QEXdDO2ut3YA:10



On 17/09/26 12:58 am, Sasha Levin wrote:
>> I think 6.12.y misses f7cb94fad4e6cec354a3ea779f91fe5560fb72b6, "xdrgen:
>> Fix union declarations". Thoughts?
> Queued for 6.18 and 6.12, thanks. 6.18 had the same gap.

thanks a lot!

Regards,
Harshit
