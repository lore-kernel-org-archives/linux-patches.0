Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA1335957
	for <patches@lists.linux.dev>; Sat,  1 Aug 2026 04:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785557525; cv=fail; b=aTzNLlquv9rndTR+dPqR4TN7ftuD0UkOg/PolWyf2XtYHPwd5m/KFMc7CapaspocFw53EWpGcEtvaavk5pEX3CYgQC+4dnSkA87+doMVAtglv/xJ/0DMvkW5V2AeVxAeiaNqwM70r/Nl7SFYUfjUEzO/eb8FRQmRpWRYInzCGRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785557525; c=relaxed/simple;
	bh=iy/1UMvXPaxHsvWoqwxiyGf01RyBAApMAFVVFRDqGlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O2UHUQXbDNm2TNVAjwVpRS2X7ajo7dolFdI+VkAUJiUYCJorRBTiJkqEwZ7LtAJBVlxsLqaOhQmQ0a0zXHAD+xjzlR3JvUm0QGI1hxHctx8bWxY3RD409hFdQN1bm3anDzIIXWjiHHriUB106aWxZg96JxrqeJqYkZHWuXlZsb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VfbkO0rV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U/2XSm+p; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VfbkO0rV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U/2XSm+p"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6713NdkC2248592;
	Sat, 1 Aug 2026 04:11:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/pdwD78Dv1If0xRhbM1sdM0M1h5YlEgrgNglMG8xRNA=; b=
	VfbkO0rVgpAfHP2YtWR7+9RNVYvMF63uTeaeiKk6ecZ4b40pNj6CQ/OdnsboYXU2
	DL25+vSR2shigPt8ajol+D+Cj7PFRXvLcca2caRsk62w3FgVhss/6symNr//n5h2
	TDLWSCewXUw6cNhXufmUIp4nIOg8n+es0I7ZXdrgB+9+RcoOCRDlssfyjQyEy2WQ
	vAdoijfhQbsqH/Xp432btmUn1k/XcTNu/OkpWBw2J+wmC4OZHjjPdQ2mVPiC+eY2
	lmZdwdt5GYOzRazhaZuIpFtf9ajcrsHNwfPF1/YRIymtXoj7CJvBjIeXoPmnT+6S
	gS2BKArQJ7aowr5ApKSiWw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8ug83sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Aug 2026 04:11:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6714ASLJ004588;
	Sat, 1 Aug 2026 04:11:40 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013045.outbound.protection.outlook.com [40.93.201.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78qamb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 01 Aug 2026 04:11:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYEnGEyVXkZ5PLBcp5QoWjxSkbEnuyST7iPcqcWEJL9xH9iOHP2M01ifw6IRs9FIn5B94WUIHP8wjIfHcm1Zxg9cYJUJO7BKvUw2PA1QIbnZJizH/axGJbf7xyhTT3VZVET7rQiDEiP87+zbJ5TBgGqmkMt1dBDfZPweGtm3aqZWOwhWE4NusUa6TUOS2FQgPNXQE4Z8Y33+fMzv7rFZmWEJvdk4SjYy82j160oWhOudHIaTji2GSnmO+GdqxdiuuJkTEJByuKi1txTVRjkGfaAwu/wxNBpPzKaiTRfYuoLwGCzpedxilHb6xE1ny3K4dbUVzcklzQeoIa57s3q54Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pdwD78Dv1If0xRhbM1sdM0M1h5YlEgrgNglMG8xRNA=;
 b=own4s0n+Q3s3JPZzNKG79I6h/wvx1NgA8JVKp0Boi7mh0X3k70M+6Gf6c77OHAoLjeJqvFirpTWhS3zI2ixPZlMOusXMcoJWe1eUPMYEcmVzusv75AgYFS3yVcAPYqlFTJfQNApgvBM0K063nUOA6D4Pgjngfb+rTLR15Z0U52gYw+IvZXFlm+B8VG7nzQECxLDyBPF7L5KqnvAYAZpOPPBmLHLOwM9Vrjpvkb/CM/ki8KGrumknHRMSLVpAA/U7rdtOeG2j95pYIQkPHl0Y75aufFbXp4g68vKnnKz4nXZpUucjVMydPkZsjiWc1CCh07Tn4wyID5EstxljIWU1OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pdwD78Dv1If0xRhbM1sdM0M1h5YlEgrgNglMG8xRNA=;
 b=U/2XSm+p3f1QnewRkn+wYghs0Kowtry24wPvB9KXuzZoFKsdY3uLh1squkj2JOBquEnSfunsIilCFcxEyBUyx/qfdro2Gyb+dEG8yRpMYHBL0pOz2H6uf2/T1k3g0vT1Bpn9f53YLBEr+eh2xsL3RZ74ofmML+9bOrtuAQaG/v0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 04:11:36 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Sat, 1 Aug 2026
 04:11:36 +0000
Message-ID: <934995ee-223e-4ae0-8a90-ad6709d14a85@oracle.com>
Date: Sat, 1 Aug 2026 09:41:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/602] 6.12.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260730141435.976815864@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0548.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: f13edba7-f2b5-4229-2306-08deef82fad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XrF6fXqAoIvi9VTPWT7NTXMPstLZ3L/lUADJWPPDx5iufZfekDff7bQ+si3lp5AFtmr9g76e2GO0Q2GmMTuzpWXAb3yUV6S2AJcn0F4MOb5SrBRSu5dbCXwPU+NHGFelcWz3YdKuZiHJ6RQwfnFkrKaT37FLMxt/7Q7LGqv2DzH5kf5Jwq97YiPwVsK1AABwN6ihkzPQS8JBOjOB9JoOtH1lRS0PYHYzuZojIww7ieUSDX0uc0MNlvo2vYuuYp1XQzOjJCMds5ixqCWwbRh8w7CUudxY1Ul11sJbknKig4MK4EPfzXtU4rN0ryvI5kMgIULmLulfjWiyB9M6HjBOrZLWZxj506b8iA1Xnimgl8Tz1BSxShgQFPvYZnNpixAixJ04qCgi1R3OfZPR+oi+nxIIyJ8eFrjWP66oPARM/M5/TaDIA5TbP3dLMNhlzSFtg28ZfYzfK/d02YEaUBMAyXRnkGWR/x7Dnuq5ez7KAsfwerUUF4/d76qvTTgJTopT5fPz0hudYTK1DcgwawaZxmb+xGwET1tkqbrlz5umz1iABtVvFXNwbbO60x2lVgyPvhZOOCED7zHhpwxxXrFoCModEorgODHZJLZ+18Nw5Zkv9D3VUS7NrmBUx38yANy3BMbKzKlJ5dkPn00NDsY8GHkc3sF3JR6uE+WsgYjzsn0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bU9ZNVBPVzV6TzFZekhPUTBWS2NBK0dQKytINzgyaHp4elBQaHZlbGh3Vmo1?=
 =?utf-8?B?YzgybVBHV3lLcUNXT2tKYlIyMjU0WEEzUWdHNHFhQ3RmakQ4dGZ5S1dmZlhz?=
 =?utf-8?B?VHQ4ZS85aDlKSjdieHBYMU53TG1WL3ZYb0tUSE5vZm05bkxOcHRob1drODZl?=
 =?utf-8?B?L0N1Q3dZNXdBSC9sVnRFdzhCemdkWERPZDY3OVVURUxiRXpLZ3Q1Uk11VU1B?=
 =?utf-8?B?dDhsUFRXS091QmEvSjNldmpXUXlBbytnYmZuV0VmaWZVclFzWVZ2a1dCanlx?=
 =?utf-8?B?UG9VdElRTXdENVdwVllEdXJEQWR4MEhNaXg1L2FVcDdOWGdxaEF1dmZqZll1?=
 =?utf-8?B?SE5raTJvUU9yeG1oWElZdWJrSjR6WERKSjN2VDJ5VkRMelVnTFN6Sk9YY1hU?=
 =?utf-8?B?YjRWUFFkcmlMaC9kYlB2RC9rdmdUbUs3NlVZN1p3NEY0V2pGUXAvU1IvVm9O?=
 =?utf-8?B?RS9sd1M1ZVlyMnViQjVPSURzMzA4a0MrTUF4c3N1UFhYU1dzdW1Pam03MThZ?=
 =?utf-8?B?MzdWTU55T1R1TmMyN1V5NjltNFIwa1FSeER1UldieEc2Q3B5c0NsZXAvZTdZ?=
 =?utf-8?B?KzRpaE51M3A3ZzVCbXlPS0ZVd1VHaWREc0xKT01KR3JTOWpJeEd5NmlSTXV6?=
 =?utf-8?B?N3k0Wm5GN1NnUytUbG4zT2VSckpkTFJQdzVUTkYyYUlZVkhKdm1sTkFpaXdY?=
 =?utf-8?B?TzdDTU80NkV5YnNVejJjREE1Z1RDMXFDVXk2aXdlc0R0bDVaeS9IWmNNMEgx?=
 =?utf-8?B?a3BCUjIrVEJzOGxWVXhTdEdDNEpKYThmQW5uRnNIdWlNRjVJNXBDVXVySmo5?=
 =?utf-8?B?V2tTNmVkSnliajRRT1JxWXRiZUE1WTJ2L1RtcHNzM1lmSm4wZnVIQ1VDN1dr?=
 =?utf-8?B?KzhEZDA5dWYwUmJ1K1JLTzFqNGIvWFVjUnZDK1ZDV09mcm1KVDlVeGoyenpk?=
 =?utf-8?B?dHk3MGlYVXI0UDlTQ0ZvdDZUWHJpc3lJQzI2MXJVSEdGa3p6RVh3ZDE5TFpX?=
 =?utf-8?B?WXJtZ3Y0S0J0WjdhUU1IOFkza0Z2bXVPaGRQVmU5R1ZHVnd2aWNsYjh2TmJE?=
 =?utf-8?B?L3BaUEk2eWRDSzcraXlQbnpkVThqaDhXTHNQY2ZpbUttZ2d1RWRzdDRtV2p1?=
 =?utf-8?B?SFpUMXMzQU5JVlBYdHhpOThQSzhhUm1EMXZLeWlhZjBndW1RcUxCV0lZN211?=
 =?utf-8?B?ODlSSURKM3M0OVVEVmlWb2VQWkRFMCttRVR4Z1F2SGFpQXFzYVczNVZRL2VX?=
 =?utf-8?B?VUd0KzJTWWpiZDNFUGd4djZvOGIvaXBJRFVkR0NGOXV0OElLRHdLTG1mSHhI?=
 =?utf-8?B?YlBZMElDdFpoOGVuSHlreVVScTNRMityMERndGwraDFmcFVJZnFjcld6WWln?=
 =?utf-8?B?MG9Kd1YwZUtvNXVnOWg2ekU0NVZqTkYvWnBMemVHN1pTSThqby9oYVRTL0xk?=
 =?utf-8?B?U2R4UGJZdlFGS2FxbWNpQm4zRVpjZThzZm9HWGMvNVdSbWlxL3N0T1d5Q1hU?=
 =?utf-8?B?ZlhrK2tBSzhaZVB6aElOTU1jTFluV241ODlBdFk1a2lzcmMvTk1ybnVYd2hV?=
 =?utf-8?B?WFY0VW91di9sSFRyV2J5d3ByRndCcUM2a3hDQ3k3MTNIRHNRbUVyQThTL2Zi?=
 =?utf-8?B?Y01SUUdIQjZSbVNxSG81K2JSM2NIQkIxS2ZFaS9ZUHlEZTRidW85R2grUkEv?=
 =?utf-8?B?TWdnREpwUjR0ZkdPSUxKczNtM1pPREFzZlo5ZE9IalduQ3Z4Rk9wcklKOW5w?=
 =?utf-8?B?ckdkNkRnVEc4bktmdHBUN3dPQ1hJMElzei9IR2FXQ2hYbGVOM2FQOXlaZkYy?=
 =?utf-8?B?VkJad2lYbm9WWjMyTFNzaitVKzJya21HOHE1dXVpejBYNEdyTlNFQlNjdDU1?=
 =?utf-8?B?S09JU2NKT3d4WFg0cGlTMjhtQ1I0YkRVaTJDbHVsWUZWaUp3a1JYblpxVjRJ?=
 =?utf-8?B?MUZIbHkrZ2dkcnVjS2N6Z1ZuamJ4eVNJWXhQZ1krTit3d0IyVkxOajhlTTZ1?=
 =?utf-8?B?Uy90SmhHeXlXMElBTTF5aXFUQnFlaTVKMHlRRkZBcWlQSWh5bURnQW0wd3Fm?=
 =?utf-8?B?NndBb0dxTTA1TkxjK3lscTArQnQxSW9kbFFIWkc1aXZrUEFWUUwrR0NkMzhh?=
 =?utf-8?B?QzJqMG5wcS8vMG9iTHlYY0FleGR4QVJLdmx1Z1dRZCsxdkRNaVhoUlA0a2JD?=
 =?utf-8?B?Sm81bUl5YUViYWloa2F1Z1pPNXFnRXJzWmtzc3hCOHNEK1lUeks2UmYvNk94?=
 =?utf-8?B?YnlMNzU0Z2g5ak0wM1BWbFJIazNEY29UNXE2RGFXdENOcHg1T21ENXZ0MEh6?=
 =?utf-8?B?TUkzWWJmWmE2OU1OTDFPbGFuaXYvUWw4VzJBVjNpREs5SUJEN21KV2lFUHA4?=
 =?utf-8?Q?izRfoDnad+AYgqIe7g59a+W//C2ffRlDmraQc?=
X-Exchange-RoutingPolicyChecked:
	ZcKnuB8WPHAw4BRYPuuacgx7wOsfNp1Rg/OA2ajFWpqvxKX/L0VE9WwPYGriAcJkL126opKa1C9+Q+PW0gWga5HRV9iTHA//BhCC7vqWoNotCVIuPORL3etJ75Bu6+ALIWud3lQGD0Y6FK2ex4JnVKNujZp5GSO1hLoQQvIePw6MUdJAemq08/RRy07G5tsbqeMLPPAzwK/2zS+wCJsNYKsVVqIcFe9HyPur5Zf5laFSU9c1O2YDRDZ20kHTpPn/hWfLYUT0mURVBR2Tzrso0rQbko3d8oC06bZIvmKPk3MHfzOInBMBBzsd3iSvDmJWwkqeILfwjLK/SrXzF6Zy7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZLMHF73VOxRT5h6sSrEkxiIK3NsOdWIOdHuaFyUVVXD/rePAAX5mLQUdHwfJHibMR/YGxo9fPOaEXkO69yyWvXDhpe47BRBG7dHjcURGkuQns3HCEqmMS0162K0Pg2Q6+doc1xu++Ph7QjV6XhZzG3+eGdMVd7qEbPPRnK4IQ2HPcpirSryTC9fMYZ29Siqwf/NBz0si5SiZLp4Z5JIzoqM3IM5/D9ERhij8oEV1faRRqBAlUj9aLNEgsFStNFnaz6To8avIh/i9YhITxk+OhbGjCu9ffDm3caCQ91cb+lF0YZ0DDuSeYONDenjL/rZq3XUOJqpMyrURJPiIy6EwOJ0WgL+57Iln8TFct+A402GEf/DkbOWHT5F8uRenLlj5rAdht98Jg51obOK85dg/UrgTYOxaxjikp69mieVgACpUikucgm7cjpiAcycCxCqk8M/OCVEqSi1xKh35mp4I+mnAmrBFjB6UCIsHvC8kYFZF8bPZwyhr9TW5TU3rHbN6tvQA8JwwQYKId9Z8wlHspKx3EJygFfoRNLwumEdWkNcpwhtpS/IQOBkgmHO9kKovuDegLrTdUWtnNwvJBNEoWmmVmJUpnGzDb0D155CFkY0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13edba7-f2b5-4229-2306-08deef82fad3
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 04:11:36.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXcGTCfZt04/mNm9/zBmaL2s1IU6dvO8o1dUcciu4KmtRiyzgOVrc0nyFYYRd6aSIetYEN4ZIG1Oq0KWADhh9qQ56pHnYZP/uIfCWVk6zWcMmNBnI2PfCF/IUtkrapvr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608010024
X-Proofpoint-ORIG-GUID: 3Kg0TSlkLlSbvALL2dh8ZMlXhpnpAFgp
X-Authority-Analysis: v=2.4 cv=XqnK/1F9 c=1 sm=1 tr=0 ts=6a6d71fd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=B2U_4hgnSM_ksmQ74nkA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDAyNCBTYWx0ZWRfX6tBDxP6heOCm
 TCjPSHLziMhvbTll/YSqMU2uMEPzrcvwWttn2JXLIbiy/Q9FaEyDxHVmP0UJds+OdVnxH9H348q
 MbyK9vF3HtGkZfmp2KMYh0vYEY4gOM66uu3czv7jkfqvDxV4d7iF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDAyNCBTYWx0ZWRfX/A3gBzO0050j
 C4uS6dWBgKoU0R+hoNcFoQ5dg4yNmQZ82OIQQlCr/tZqlbwfpw0dLjihsJS0E/T9UZbzPPawNBZ
 QfE5SmCIMvPAhdpvaODUmFgsXSZ2jVApeQsTqW753221Slak960LqLOCMreCW08hMATvX2QBd4F
 /qOjONhAJ0ehDecRkMlx//GmKO57ttfkBHp2j6pzPLCukvT4mHT6bX6xVOkKZw0a0VmjepVzg+8
 HExUWkAiIbsqpUFoJPrQL8U3kVZvHE+R2syEvTH4rHghQcz0eQhVAesi+etRmtLbbvc0M8ZiEQN
 U5SD7VMlG1RgGm48HOJ1hturTu2QACIhIoMHp2exhCtinb9LKgzbnCA+abcO3CizmKQVSv9B5sM
 I/bCfshPI2FCKdVGEh97Wm1Oeb1XO+5XKT4rowA+V048a4TFHW7Qlkx3+5eZ2vO3/vW2/Vh2PW3
 86EoB9kSmxtNwP6WqHWVZ06VOkFSIqhJDSXVW3zE=
X-Proofpoint-GUID: 3Kg0TSlkLlSbvALL2dh8ZMlXhpnpAFgp

Hi Greg,

On 30/07/26 7:36 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.101 release.
> There are 602 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:43 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Have responded to few patches where AI reported problems with backports. 
I have 4 more reports, will review and report them soon.


Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.101-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

