Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2612C15855C
	for <patches@lists.linux.dev>; Wed, 21 May 2025 03:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747797867; cv=fail; b=rHYW/nrxVQG1/FAiMfsg4aeV19pJOzPHY1gJfkQwsj8DsGl8ayZNfaKCwUObtWBoA1K7wsev97/IUJzLrR4Y2T41M9c27+R0rHk1jzZynBAhi2m2HutLJP8Zg3ihlspgMFC0oFs+DB0WA4Z16vClHo5pkh+leOfxDG8SIKO3lJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747797867; c=relaxed/simple;
	bh=Kua0OKrtzISCcv+ECrr7rIaleB3Rkhpn10R/MSSnuCk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ffxgz3sw9NSjlFHnHNYb8iNYKN9x64QaAFUx123czusILSHpRCzBPjoO/t3BpYlQHyoyTKI0m7SsEuAodmydA/pIvrDLHVubpgRmZyOonBi+33ISpZRHJH1doM6APXYBGg8b7ln49Kfq/ZcjWFoE6pWsma3FJxcyBRWOd0DQGf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A7iAVGVG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lVRwQ0PK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A7iAVGVG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lVRwQ0PK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L3HdA2015063;
	Wed, 21 May 2025 03:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ClR4LAVo2FjLC6BOQ/Y0tdtF47iZsbqJ7PfM5/6SGiQ=; b=
	A7iAVGVG9F+zuboYao9oW7xJa2IX0CnNPWna3g5+tgj9Fxlieqlpziy44AG83ENK
	8lCdvJpoTWaJ6cDFB2GR8l60Pz4byKG1IKoy+ENa/MME9zK4KN+g9KudWYaXTljZ
	sJ15gltqycLEvqLMmSUkBAZtPDVCXqmLLGZKYgwB1zN4GARKMLxg4b0tLVhiwYHI
	/TZXGtw7rhmSXzpzklPUP6sLqhUQQKW9rXHZd/lmBE8Z4VG7uGdla3zDbLgMVQjg
	LOxCgb2t5mnzETNEwrQ3zc9xUpQyxQ+Kf+ydkB76xKQ0IdXUpk9r0yvSVvLjLF6a
	qJ1e8KNpx8yheYSYLOHkwg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s6js80gd-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 03:24:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L2DZXi034544;
	Wed, 21 May 2025 03:17:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwepa1hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 03:17:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uqALq/uTlFOv8MOGYLpe/ggN//T+O48wpgYfuX6s/eCCkkOyiqMI8cb94QkXeuFUhUiyGBZLrt08veD5CJs+Pqm4Z7SphNhCjjAGcrYGzLUW1tSUWRY51576IsojyJYjQU2kvqxGsWZviOWs2nWP86BiQFniKRa79tPbMpx5HeAM1kXB+G1wS8rtNiEmGjKNl55eryc+1Y8f2eOgXlFUis4JtHBtgoJOtccPhr8Mq7QUpUlno06rPHvoRTOkgqKQ0Fiz8+NsdwTqdjfQL1E7zwFNqCZdM9x6oY4+Y7x7WqvSaw1Q7SU6Akb0stbeRJAd0r9jW5WUAfXPCUQOtNXVtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClR4LAVo2FjLC6BOQ/Y0tdtF47iZsbqJ7PfM5/6SGiQ=;
 b=mrgqVF4OZhHMbb6lGlmfMC5N+OUHCoukt16Yw5LU9d1TD/dDqOmLharPddxAUEVEo/HY8EvCoVl3kVy+rd/82AvMW2QzHx+24p9DIfqxscjyeeB5vfxQtSOfHJSlRcLt4iqn0jvssNcHiG/XirpIm2DddxUY57aI1ULkyIIfW1Zksag3SuHpDFCYafdHw8CJgFvW9q3+qu4D7KLgiO40yidfjNj6PV+EEB+bx3ji8IXdYblp4R8FWyZpw3KsDHJ/pWr83fpTVmuk08+T1lapBwPYZQSwJDGDeWimdu0p7QFI7AgFK+vHGieTwzyQ27+DZbB3vON/E40z0c5ESeyF7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClR4LAVo2FjLC6BOQ/Y0tdtF47iZsbqJ7PfM5/6SGiQ=;
 b=lVRwQ0PKMJzYkA7+oKFB15lrbqLwBH9cnNozpt58j4zr9smQBZiZ1s2DVcJc9m754oLSJLc6sbeHvjq0BhTshP26G6nwBhgGqRNl26LrYMVcgqNYF0oTguuNmGzK4UyB06y6GV35772Eebu9QNzkSVmAb0xNsv+V+vu9v9aAypY=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 21 May
 2025 03:17:03 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 03:17:03 +0000
Message-ID: <00f01afb-ecb6-40eb-8fae-523bad267bbc@oracle.com>
Date: Wed, 21 May 2025 08:46:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250520125753.836407405@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0025.jpnprd01.prod.outlook.com
 (2603:1096:405:1::13) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|PH0PR10MB4501:EE_
X-MS-Office365-Filtering-Correlation-Id: 63001999-44a0-42d7-bc0b-08dd9815f522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVlqdUwvN0ZxUko1RmxRZWltNjlxK0Voa2lTWExBTXJFVmlJeVNuREZ4dVMw?=
 =?utf-8?B?NnAvbGk5MjYxdWZtdEl3bytzTmY3a3pTMjFqSlpBUUhrVEcxWi9Sd05sQjBL?=
 =?utf-8?B?eGQxclY5NXRxWXZFZ2VLaCt0NHhjNlVMN0ZDM01pOGdxTCtRT3NHK2lDU1U2?=
 =?utf-8?B?ZE9OUUZJNStZV0dJcDF1TGhMWGoyYm45MzFGajdnVHF4QjdkV1VNRjkrZHRi?=
 =?utf-8?B?VUx0T3lDNHJ5aXdjSmRBRnF3amp6UEhyYzRibGczWWR6S1ROK0ZmUjBvMDlG?=
 =?utf-8?B?cXZlY2tKTG9kWHpUSys1TUFkbVV1Tk1KZ05WWUNhazFzZi9MYldJbUt6TzFp?=
 =?utf-8?B?d094dmVYWkdmUlM4NnN3TXIwZGFzRmF4OUUvNmxmdFVFR1U0SWVZYjEvMVRF?=
 =?utf-8?B?ZlhRaTdiTmw2cUtWeWpEUjk3R0xwYWpObmdOY2s0a09CVmxZZnp1VXNncFEw?=
 =?utf-8?B?UWtTQjk2dFR0Mi83WkI4N3NHVEVsYU1EV1NjN0wxRXJtRnhkNTJId1ZzM3VY?=
 =?utf-8?B?UHNmeU9HdXZEcE11WlNlaUpLaHRyQzZ4dzdmcGdrNmFMRDFqenRwUVJsMGpi?=
 =?utf-8?B?ZnBrRkNzMVArbGdsVGU4ZU02Rjc3SFdqOU9KZVlWcW1TS043eU5GOXBJYUl0?=
 =?utf-8?B?dkcySE0wQXA1ZzFPYVN5QlMxcCthNEdrUHZEUGpObGpDbkkyZjZpUURDL1FL?=
 =?utf-8?B?R3Q4L2F5d21EbFk1djcvdmwwUTVaS21uZFZUblFyY3VaR2pSOE5hc3BVQXIw?=
 =?utf-8?B?dTVFTmNjeitHZWlBSEkvTFlFT0hpQjRJVlZCR0Nta09JRmR4ejF0QndSN0ty?=
 =?utf-8?B?UVpXWW1MWFRjcGduVktpb2dtUnVtMWYrellEdHNTZmNhc1ljcHVHaFpUSDhJ?=
 =?utf-8?B?MEg1U1FSbjVQelNwRUh4alZ4UlJTbjlya0lNbTRTSVh2TEtnVXZVNThXWnor?=
 =?utf-8?B?YndMODMzbGVFVjVHelpOR05yS3lSZTl6TG1XU0hteGFMUHM0OVAxdGZNOEI2?=
 =?utf-8?B?OFdUVEZCRzU4TmYrYUtZeG15dy82aVY1MFNOK1BQS2FIV0VHci9rWTNVcE9o?=
 =?utf-8?B?YmpaZ21Qdk5FRFZBSmtmb2pkNWRvVzA3ZnFkaDVTN3U1Ti9Uc29lRE04eEFR?=
 =?utf-8?B?Vk9nL2hGUG51S1k5Umh2dnNyREx2a0c3MjhoanFHTGxNbXhGK2FOYy9UcUha?=
 =?utf-8?B?QmJTRHh3RCtpeWR6THpDU2ZIeWpnT3RNOEFxY0NvQWpvNVFxOS9WV2djRS9m?=
 =?utf-8?B?VHFieCt2U2pHRlNSVFk0T0pia3RaekwrelZSRUJCaHpBOFF2c0dDdnJONEk2?=
 =?utf-8?B?N3NDcVl3cHg5WkVkaWFMT3pjYUlrU2t6M3YzM2FOK09oSWhJemJGY1lGZmxa?=
 =?utf-8?B?RnY3RzNxQjQ2ZFNjNFVXaDZySG9DNWcrWTdhVnZRUG9NZGN4akFIdXRMc2FQ?=
 =?utf-8?B?c252dGQxdk9xMVNobGs5ZmVJYzRSdFlnVUZWcVVFMGk5WllEVmlTeWNtdnMr?=
 =?utf-8?B?YmRVVGNZRDYwamNOa0hhK1RuVDdoSmtnaWtIRmwrMTJGVkJUOGtBOGJ6d2VF?=
 =?utf-8?B?cFMvVVRxcGtpTmNtN2F3R3c3UlpqOTNzaklPKzM0NkhRRUJqK3g0bXpmc2da?=
 =?utf-8?B?QzMxbTdTOUlpOGFENXZXTVQxQnlmblNPdXpKNDJWNFhkUHd5QkFva3kyUjQr?=
 =?utf-8?B?cDRpWFBra3owbG5IM2MxL2Y4a0d0RVdVRnV6bUs3d0hWN2QyUXlHdHVEcE9V?=
 =?utf-8?B?cXl0Y0Y2VEVxclUva3lkTVprYm8rVDNXL1Ywb3dTNUZuME50K2R1TXltdXRV?=
 =?utf-8?B?NUp5WmpzNVcxRXVmQmhzcVJITnV1WlV3UU05NVpURjl0R1B1L1hYVWRRSFYw?=
 =?utf-8?B?cUJSR0pkTERGKzZjS3g3QWtKMlpBcWZyQ0dqMWRXTHR3cERnck1NREx6OW82?=
 =?utf-8?Q?FRNLdKtyURs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWg4SERjMUE3QjhLNnVISW10b1FZWlVNSnlrRzAxR3hreUdNTXE2am1MbVpO?=
 =?utf-8?B?SngzRG11SVdhYXZvbkR4Q1FGK1ZZVFpIQjFyLzN5dy9KRThQUTBqZzM5RURt?=
 =?utf-8?B?NVJIR042cVlOb2twSHBjcmxjRER2NHVoemRZRlV0OWdNMmdpQ1RqMVVJSkJZ?=
 =?utf-8?B?VGZRSGJ3YjkyaTVGaUd0M1VkS1lqN1FaZnJleERFZ2tHbFpwVXgxamtXSWhI?=
 =?utf-8?B?WXFrVVI5d2RwRlR0WGJnWVMvRzBRNTJNTEV2Q0pjdWZOZlE3RExCVHRLTG1B?=
 =?utf-8?B?VFllY0VnbjVENnE2VzdTK0lHYVFLMEtXNzNCa1FFN3FrUnpCKzRoREwwMGd3?=
 =?utf-8?B?UUMwaDZ1OW9nTDM5eDNPendkd3RWR1BqOExacW1HS2toSDdVUndoUE90UFpL?=
 =?utf-8?B?YlBqbDh1SGRQY1crU2ZxLzl0QlVJb09hRUZtM29ZdEswRHpsclJ3WmFOS255?=
 =?utf-8?B?MzhmbWFNZWZrdGRsMGFMUWtibFZpbW9aR1I2WU8ya1d6OUFQd2hXTnN1NlZq?=
 =?utf-8?B?ck5lL083ZXRUY29RMGt4K3Zmd3pFOGdPT1k1VXJLZ29pVUhYdjQyTEc3RnY4?=
 =?utf-8?B?clRySVg3NjRDVm4rVGpXTjl5L3JBTGlBS1hNSTdJY2RYeThKWWtyTDVmN2ZP?=
 =?utf-8?B?ZlpzcWZCMEJpTEVpUVc0OTZMcEowdUNKM1RWOXU2dllaaFIvZ3lEbXBWUXZJ?=
 =?utf-8?B?S1VmeVE2eGk4Sjk4QXdVdGtOV001ci8wNm1pZk5pQUIwR0UzS0NIVVA2QXp0?=
 =?utf-8?B?L2hnaUNNQ1o0b0FrVEx3WHBPQjFzQnUwNUZpSXBDZFRhVG83bUNsdDNxL0JS?=
 =?utf-8?B?aGVGT3ZUbTZyalNJM2dNYXdJSFpYRFNXWmRqTUJVdGpMYy8vREJuaEMwd3Uz?=
 =?utf-8?B?OTZ5RTR1NkNuMkduaE80SktSRG5DeVhadUw5eTVZOEJHa2lQUDUvZEg3RFB6?=
 =?utf-8?B?VGN6N3JYKzVJbVdscFg1UkI1U01FQlp2aTd5RjE0SkZOZFpiQldUQ0hVbk1Y?=
 =?utf-8?B?M3FRK24rWU9XZzNMV2dnMFhhd3BBYk9KZkRueEVsVFI3Q0F2UXBwbWhkVE5Q?=
 =?utf-8?B?bCtIYm5tZXhweDdVUXg5djVZQnlUMTdETEpjMDdNV2srWVZ1VTJUVSsrSFpt?=
 =?utf-8?B?cDY5V2VReW5DVXg4cGFXUUNRSHAreVFmYXo4dGI2Ris2RXRFMGJadE5CRHZs?=
 =?utf-8?B?WldXaUp4YzNNVUpaa0pMOStFNUJKOWVEcy9tdGV3RnJ1TG51dDFQcU9HTndP?=
 =?utf-8?B?Q2J5K1VvbzA2a1hDejY1dmFVWEtZMUsyVnl2cFgwdGY1WWxNSnhNdTZ3TXVw?=
 =?utf-8?B?L3pXT1hOMXQwbE1yRTJLZG9VRGZWRHY1SllMcXcxUnR2c1ZwVnBQKzdnYktF?=
 =?utf-8?B?TXprTnR4TlBRSGZOUmZMaTMxZGhUR3RrRStCMWM2MTRQclJVdVc4QmxnYVR5?=
 =?utf-8?B?RGppTEZBdm56dnZsOEJLTGdPQ2pJcllxZDVETURQMEoyQWxPcWd3VFV6V3ph?=
 =?utf-8?B?TXl5b2l5dTNCMFJLY3UzQmpCTXNlcDlTb1VPdjRtUm9LczNRTTZCT2QvMlBH?=
 =?utf-8?B?NEx0YlJuMnNhU1lNS01UQUtHZ1Z4eGpOYnplRWRDQkRkaEY3L2w0WVN1SEkv?=
 =?utf-8?B?c0NXaFFvRGNJMWlXanp4SEtjaXBvZ1Z0NHJXSDNGMnMxZGhVUEFOdTZNM0xP?=
 =?utf-8?B?UTBVN2h0ZVJ2NmdMa1lGWkNzUXJsOWtRQ3UzR3BzbHJFUUlLK1k2aVlybU5Y?=
 =?utf-8?B?V0FsWVhyaktDVTlwRkJOU1pMWEgxeEpKeUFMZm9qbWsvQ3hBdTVyVUwvN2RV?=
 =?utf-8?B?TUFRZGZscGg3ZmNqVjRkUjlHN1VIbmM0dHhPREtQQjNybTFJOERtaENBVnZM?=
 =?utf-8?B?NkM5anlOMnYzemJMZ29PbzhQOUxMWjZUSEVYZUt2cnA0NDF1OWd1QzVuU3Mz?=
 =?utf-8?B?YWFmZ3QvNEwzSVcvWTFLN2NxZk1jS2JRc29Tc3VHWXZFVmxjajdEQUluZFRL?=
 =?utf-8?B?Y096OGRLeXc2UjFiMDBKbmYxZFEyYjR5dDRuejcreDZmdi94dWNCTm5Ram5a?=
 =?utf-8?B?dU5BNWlyQUlNbHdRWms0dXRGQytkbG9pSVRQbnZDVUlNT1VCeHFlQ095UnUz?=
 =?utf-8?B?SHEydTgvM0dFTXNPS0x0R2FPWmVacnJLclJSNjNTcVdFRkdqZk11SUZMdCs3?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aw7T/wq8kzLrOzdBXk5nEU8OxXdQTPXlVzfJk6YBndAgxwvBXyvFVekBa7w+SNzvjUdlDfJshNXhknkrOmrrrovklH8RPMiZtOQQavS//Xqn8UAhha7vFZx17fEGDQN2wuXctydRLXI5bRKWL/uwIzpbo0l+xxnCWcZkfrJ/3OFKc5sGs+C3qaueDYuc412nIqKVQEDUtOiPr92gW+nEZnt6tiJlthWEqfO9XIND9G0C9F2c4danI1su7USouAtC3inMmCz6tCpZuRwGrGp0MEW2sMKH2Bf+En+J9+aYfHQ4YRrqk2oqE6hYi9V74cYRxWfL+dAbxXn4HuRHe1FinC22NSYl/xC1ozgTy3gWvqaRLQkTcqkIAF7AmjWBCURAw6UwS02HoQocBoy3V6R9Y3/f8sysTaJOA0wPQP/9no3IwR/D1MFFqgi5e31zh7YYoYxLd3OE/bOYiyvsOxjqeDUJ6SAymkn/Xox3mkV7OPoO+x2GG5EG6wXsxgDKEb/wltdDoQVH6MBB04BGWrWDJstGF1z2ZCVsKQV+ENZOjWUd9MFK22c8vucgKkwDb9yAeavc4Fxzrlbk6ChFP6YChy7PH7ou/c944U4FQ/lKQLs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63001999-44a0-42d7-bc0b-08dd9815f522
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 03:17:03.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iq/zavtZ0xIWaJyJ6CMXtJd2QU8/Y97ovaOUZA+gx1iWgZoL+oDUjQnbkvuIYu3rP2HpP/BP8EyEF/UzCmjEoOMixiPohMlmvM5vcYxd8Jg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505210029
X-Proofpoint-GUID: WUyQING4v0lz-phkU4GUVdrrFaYGmq9O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAzMSBTYWx0ZWRfX4PBpDumQrOne ntRNWo6eiHusPqYXCVUgv+huMo/zRMYgtpCPt8Dt7UYH4XFqAJ5iZ4FrpV6jAaBDIwakwjCt2lg OlXunhF++HTRms3JXf14cfmHqr5O4n8sdtYVu9bSyldjfJETo6NRSNwv7PdscIDu4Id8J9Uc+B7
 pH7TOCMG+CXeD5dUbop1a0AlIP0xj8mCQrJhSMfy+/rHz1DQc+j5f6CRQQl4CTcaPOp39s7ke4V nmJEtezO7I6ks9tZjhTUQmghb7WJfeFs12fds9zV+kbAT2snTVoSxt17rhNuplRee7r0dNghqyF mOfVJQBOh6uDJK2hSD5wUF3nfk26CfJPXYFPEemIdD/TtbotOURnmn1t5PwfhXhBpdq4qPGo18j
 a3LhRKePhs9FeXnk0MVaQu7hxTvddXCt752xPX+DOWNe8kvQID3GkqpzHNqFkcBDWWSC6HAO
X-Proofpoint-ORIG-GUID: WUyQING4v0lz-phkU4GUVdrrFaYGmq9O
X-Authority-Analysis: v=2.4 cv=TM9FS0la c=1 sm=1 tr=0 ts=682d4757 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=T2hqEObZi1s3ibl9-cMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13188



On 20/05/25 7:19 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
Thanks,
Vijay
