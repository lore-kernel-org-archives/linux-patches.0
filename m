Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DBD13A41F
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 05:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738819265; cv=fail; b=ZCUF2R66XS9GrBIn29QGDwmyPPH5GnrMuA16B2GPGaddT+DN1AfZfKODUo+nGXzCYnwWXgDxcRc3uMLTtWWq6C6ITQMqz2m6llaf+jWOi/Oq++k5g7OawtX4aZGdjp9QI5JlKN5D5qC6PPBwMC4NoqnP3/PYpJqGHXtxoHhC2jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738819265; c=relaxed/simple;
	bh=JW7DPzlASPWPsfVzh+iq/QswGjLWC4l+P6y9n+8jpyE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gn0ujbVX5gex5koDRE9lEBqHYPKRtaaJo2j5YKtfrhs94I9s4hA/ZP0ofnZoxT6qrtDn12v7/LPnTqiYUana9sTXynMRnZo6p307AIMIvD0X19AVtkOWwWl9jh0eYFmJNvIjKqU+Yzq9/RD139+XsI/+aqVaUe7V78e34OLJMW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AgsdXEnm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KmJ6OeRp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AgsdXEnm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KmJ6OeRp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5161gKXR012172;
	Thu, 6 Feb 2025 05:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=EOh9iXmj6REMLctBt0VpySnawD/stjTkfL3wt8JhuaE=; b=
	AgsdXEnmXexi37Nlw4ObCDiHDMW3SBSuPyV2r/Yh1KHgp8zWYUontfyYBPD8vT74
	bbHyN98FGS0oGp6Pt2Htm1QaaFxU1+9SjFiLlKiO9X6S6RrQA9cJo9AURAL3nSau
	ngBsbzJj252ArecmiMedb7O+LHn6tyCYQqryPct4CRN5KYEU2QVF28r1z1cEy0IF
	cfiKnjqsJz+9BAF7YmKrmECyob6ba+OM+APqLz65k2jG0ml05InnXV+3ZGsOlCXw
	gDuEB6TEH0QSQk/ghOlM8E+xhqSmIVuJuYFfTiqUyojcV5Jr1bRYzvqlWtUzWyY0
	YfDskI8D0sWFakfQG9pkTg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44m58chxm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 05:20:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 516335H2026975;
	Thu, 6 Feb 2025 05:20:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fpgua8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 05:20:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DPha9105UHKLH0BeGdvpqT7HOvXTxKlsIZIvhlpReO6SsXEFiODHC2T1ut7VPE6b+NKHW6zGvbh75ulr3QLEwzX8/xY+EDQSCy2IivQeumWA890DBrQGGmLwvsj+ztDf/0bqrvdTo6Pf72HmS76emq67qO7i9KNxShPzjszdJDcGpHIpbaY3B7xESe6j5GLMR729yhoo2OZPhjPn0VrNhoVtw3zCDW9gQreeq7c/Xy4JFdkgDqoxXGvWTeDTC4FWhEzHDKQBciaOaI8Q1eZXHYhBGA3iG9ftxixHCbY+MB5XLJ57BgpiQCLC5jqgygobmfSOx1L4fDN/jLZ9L7Sg/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOh9iXmj6REMLctBt0VpySnawD/stjTkfL3wt8JhuaE=;
 b=yXIA/m4VNk+egQY9zwNekECXa4RJDoR8lXht/LCWpPbzg01RRZAlD5gZPmisSc+XlHtuVYCdDzN9gEsc/K68jRWYs9d7KjFcwwiRmK1Z0itu2laZ+345CdMqaG0Y4jlDk3hzi6NM6u7x6Lo2zwlHGspE5A6Jr4WeAHfb5L5na5QRRR6jzPWKLia8A1GVQ0WTfcqHzoQzjCRU2+heZSuA4w94V27o78owrfusXInDLAyFJwf/MnSYs/OjtpGJTWG5pb0iGHY+5/liXVMlr59D9LdfBs7DfEmPDQ1RbzhSNj2bcVOPUKwlzUIvNK7D/1cBUcgV06fEbiUnX6aMDYvSZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOh9iXmj6REMLctBt0VpySnawD/stjTkfL3wt8JhuaE=;
 b=KmJ6OeRpcyhzB/MyKi7fkW+0tXL+dQwOHK6EC8klrgHfo0WVRM7MlOQ2uKxkzXp35yWNpSOUHbphArjc8umGQf34AgMRyeBI0qFQpM7u2/PCvQtJkT5nLqlgSiYdDKaAZl4UvhFGCVqhYarClJebdfhbXovBtbVG2WSaPRAmqK8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Thu, 6 Feb
 2025 05:20:42 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8422.009; Thu, 6 Feb 2025
 05:20:40 +0000
Message-ID: <f1bb99b4-55ae-415b-82fe-0f5f1165a949@oracle.com>
Date: Thu, 6 Feb 2025 10:50:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250205134455.220373560@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::18) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fd5c0b2-8a8a-4ea6-e187-08dd466dff11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVpKMXJ3eDJHS0FaSDVVSTVGdjFlZVM3VEpIRVYzYVArOG1EYW1rb3haelUz?=
 =?utf-8?B?REdsZ0xsNEIxaWlEUHJZdXpDWTE2MVhaZWp0ZmZtc0d0SzRhaDdMaFZaVExx?=
 =?utf-8?B?MTd2RWc4YjIvZlAySWlwRDFwYnR0V0drNFFBYTh5STJkR2RHYTE4akdmMWFx?=
 =?utf-8?B?bXE1Z0hCb3BmdkFvcWF3WWFzUXpJQ3YrT29VZXYxeWNTSUs3em1hcmlHOHRh?=
 =?utf-8?B?c09laWowY3RsamhqRnFtYWRlL2x5N3pIZHdBcWJOejN6K1NHU1o2U0k0TlNF?=
 =?utf-8?B?aGIyOVZ3TldaS3JCOUJhT3NxeWZxNUN3cDhUbWs4SHVHNmNld1FjQlNTZFFY?=
 =?utf-8?B?c2s0MFhaWE5RTWdobjlkVzRWS1cyelJrRlFaMm9pN2hET3poTnY4clIwUWF0?=
 =?utf-8?B?cFkrOGJWRjl0bzZKRFN4OTNJY0hKc0JlY2dRZ3JYNFQ2SWx0eDh5NStoZnZk?=
 =?utf-8?B?OWZMVzhubDcyM2cvd1dGSVNmeDRlbWpvUnRPa091eUdqMmRBNkljRm5PeFZl?=
 =?utf-8?B?cTFWTDJleDVqb1pSMWliWGdCeFBuZmpGcnAzdDZIRytaNXZlYmFwcUZhSjhJ?=
 =?utf-8?B?TjA1TWVsdkYxMmlMN25Cdyt4ci9DMldoM3VjSWc0aXFvaVpwR1J1NUVuY1F4?=
 =?utf-8?B?R0F5SHdORU9kdnFIVVBQV29vdkF2UmNSK1hML3ZVc2ZhdFFScDU0djZSdU9l?=
 =?utf-8?B?RW85NUhlc1lLd2lTKzBRSHo2WENraHd6S1ZETElVMlFvRnBNOG85QXpvM1hD?=
 =?utf-8?B?NEZYS0NEV1l2QWFaQkJEWUlxSGIvQk1rSm1QSHhYUG9ETVpnaDRYRkt4SEY4?=
 =?utf-8?B?TmNRV0ZPYkdvbzlVTVZzWGhqY1hVOFE4aThEa2RuNEZKUC90QVA4d0lSM1Fm?=
 =?utf-8?B?RWxoU3d2WEc5ai92bWU1am0xc1lyeHhQR0RPYlhrdVcyV2ViMkxaOXpKNmFw?=
 =?utf-8?B?SHhOdnlYVWpxVGtaQnRuMGIybzR6dG8zR2hwOFFoTDNJSmFYMndtSlNkbGh0?=
 =?utf-8?B?bERJdGt0VnhETUwzZ3RvQmFGYnoweHRuZy9ON3NYdng5TUJNcEJRWldpeVRy?=
 =?utf-8?B?MG5seTVNSk13MVpUa1ZjeEpkVk4ya0xvWkZKejVodDFRV1RDUVdVMnlHeTQ2?=
 =?utf-8?B?V2FLM0JrQTc2emtXNHJoSDVlLzI0d2FWZDRiME10QlhDckNjRW9xTlhkUjJG?=
 =?utf-8?B?bW8vRHNhcUY0TWFvSGVNV1YvVFVsRGVuNjVZdG0rcXljQSt3SDdrd2ZubFJx?=
 =?utf-8?B?ZHp1VW13QW52L3dodDlEdXBDc1pDWXdEN29JOUlzdnJrVitHck9maGFoRjFp?=
 =?utf-8?B?bE1uQUxnSE9DMklzN2pYNXVwSndjc2VvS2ZmVUtBc0VJanJJT0d1Q0E4L3hJ?=
 =?utf-8?B?a25iOWFNZ1k4WGZ0RGRDdllOd3BmTXM4cVZTL253KzYxZHZhbDk0UVNhenhW?=
 =?utf-8?B?d1BidmEwNU15L3NZdzFMLzRBeTZwcWp1eTNDNFFBdGs1eDRjZWl3Y3p2U0w4?=
 =?utf-8?B?VmpuZFpyZGtKQ3lIWUtaT2J1dlB1MG4xa0MrNmpnclBFYW13OGhRaG84Ynla?=
 =?utf-8?B?bGMzc1pEN21CRGdrZDZScHRuMHN2bmpLVkR6OVdpNGJZRTRLQUFpVzlDRmh3?=
 =?utf-8?B?M3BQL3FFSXZWM3VqME5kc0xmNk9jbEk4eGdVOTFIVG5rVWpnQjF2THJDQUdR?=
 =?utf-8?B?RHFIZzA5bk54a1NXVmYrSGZnMVNhR2FtOUpRWHhEaXhvemEyLytlb0lHa3p6?=
 =?utf-8?B?aG9Kckwyd2hhYmROeU1KQWNIekhVVmQ2ejduZlpFajJ3ell0azBJdC9XUXV6?=
 =?utf-8?B?Tm5RN3V4QkQ2dnM0V2RyS0t3amtqVU03YkI0Q0hydjNiZ1JVSHlQdHFLb0tn?=
 =?utf-8?Q?REellTl8pq9We?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1dRSUxNL1ZIdFdsTkdWemxsMWd5eWYwbWZLRlMwNGwrOVluK1EzUytlaFV2?=
 =?utf-8?B?N1ZWRFE1OWhja1RRcEZaaUo5L1J1elFvSHFHUVNoVXNsbzNpYXo0NzhMSkZw?=
 =?utf-8?B?V1dXQkFrVVpCeURyNDVnQklUYTczLy9QVGxOTTlsOEdhaVIwOGxmS0dlNFBl?=
 =?utf-8?B?OTdQdFpVUktkb0VUL3ExYUlYNkZ5bWFDT0E1aDNKSVBPZWVZc3RDUUk3R1U5?=
 =?utf-8?B?bGFNNG9rTW43byttL0I0NVBpL2JQOUNZcVBqZkNaVFlxQVhIcTFSL3ZhenlE?=
 =?utf-8?B?TUNnMWFySjFMSkRmeUlUbE1YM3cyYkJZTElpZHpCb2x4aWNSeWxwbThrOVlZ?=
 =?utf-8?B?TU00REVpQ2tNYVZSZjJ5RXdqQkdqNnd5M0w4SVFCb3NpNVI2UnlEK01ZZVhh?=
 =?utf-8?B?SlY5b28zaHg2Vklra1pxeHlCaG1Zd05zWDVPTGVCdXBSV3B4ZXl0OWxBa0h5?=
 =?utf-8?B?VE15aWM5Z056dkc4cWhGc0FXQzR1bXkvdktzT2xWVzdHTmM3QUViTGQ2VWVo?=
 =?utf-8?B?MW5ieU12MUFHcC9aZzc1Ti9Wc2hqSktBamRVTlFZTC9CZzBrS1p3ZmFhM1RR?=
 =?utf-8?B?NGxyMlNTOFVRcGdQYmpTazF1ZnU0SDFRTlIyWFltYnMrYWYxUTVOTFkvRlY5?=
 =?utf-8?B?ZEIzMkY2cmpHQ2wva1lGdkM4ekxWWEl2ditqb3FSR1NBNE12RlBZYS85OXRN?=
 =?utf-8?B?eXJUTXhVNUpIcjI0TUpFNUlFbU1zd2M0NHFOWVVwM09jTytuOXN1WStsdGx5?=
 =?utf-8?B?UXhSM1g3L1JBeVU0b2gyZjFnVlI3d2xVVWJuRXpaejJlVnNyaGpPNUtvU2M2?=
 =?utf-8?B?Q2ZlUlMySGRNNWp2bWwxMDlIMlQ5YVgxSklCN2x2dnpSVTgveUU4U0lFU3l5?=
 =?utf-8?B?am5QanJtaUF5QUlUUDhleHN2Z1pDd1E3dnRzVTc5dmFDOEtNSlZrU3doUTFy?=
 =?utf-8?B?WUJsOGJnTGdhL3l5aDNjU3drdmhYQktiQVdVREhJTjdjYnRnbHB2Nzl5RDRj?=
 =?utf-8?B?dUJaVEhjVGt0N2hGVU9mS1lHbHpwSWxYMmVpOFFZTUVNMXFqdHdIK2NlUVJa?=
 =?utf-8?B?S2ZjSkRrOURzT2lDV201MEdtT010aWF5a0FmbFZUaEtQV1JabEZ5THZMcnR6?=
 =?utf-8?B?U25sbWlqK0dGMEV4RzNpTU8zUzVpTUtMNllLQ2lPN21nN0toaFgvQ0NJTWJE?=
 =?utf-8?B?eTRwUm56bUsrT1pMUHJ6VUU0V1o3emlxSW9NWmpNM21DY2dkTmhhSXlXbkxX?=
 =?utf-8?B?RksxUU1pUy9vajlRVHVEeEROUERiS2l0RUo0c1dsK3JYcGhpYVlBeWFFMUhY?=
 =?utf-8?B?STJWTFU4akwwdDVVakZtUVB2OStPMlcyQkQwSEZJNnloWjR1SlQvZ09mT1lP?=
 =?utf-8?B?eW1YbzVIL2ExTWxRYWdGNERzUFRrem11dWQzYnpKbnMvcWxRbDdKVW1SUWpP?=
 =?utf-8?B?Vi9ob2EzNDViNmJURGxkN2FjUlJjcUpNL3FqeTM1dXgyZTJjdnVva2t0dVV2?=
 =?utf-8?B?S0pialFtbmV3MFU3dmRMRDhLdmdTVEF5Wmh0YUxLdnJ1V2JzMHk3c2NwS3dQ?=
 =?utf-8?B?VnFvVFE0d0kycFVCR2lpVUZEdnNhQnU4akE4M0pBb1diQTZOQWhiM21Yeksx?=
 =?utf-8?B?RW9QWkd6emxZZnRRWG1lT1NEdEJPd0JjWERVanR3ZTUyenJDOGlFckN5TFpD?=
 =?utf-8?B?UEY2UkQ0MkVIdGRWVVJ4NFRKdmNtRFNoSnlZemtNUXRXTTJBQUh0aUYzd0Ir?=
 =?utf-8?B?N1JXb2FmWkhLN1A1Y1ZhUDYyVWgwekxlRmJaeTJtMExQcGZKNHZ5RHhrQlVz?=
 =?utf-8?B?dGpmWWI2cGhkNzZNbXlsTnhIaUM4cUk0cVZIZW1uZFBaSDBIVDMya3E5ZFVR?=
 =?utf-8?B?MjVtZVhhL3BsanhucmlabXRoSmpTRUswTnlRVTBmUHl1bWI0enVJRitZQzRr?=
 =?utf-8?B?Q0s0TGtIbzF0V2ZWVzhDRDZEWEVIaVhRNGhNRkxpMUlwTHZqQnFwTSt0YXNa?=
 =?utf-8?B?c3B5WVpiWjNWZzVjbnVpcjZLNThBSGsybzhFa1R5VHZvWHUyUllBMkNZN0ht?=
 =?utf-8?B?amd3OERUVzk3N29Xb0xTdXZmSTZOdjRpR0ozaURxT1BqUSt4UjVudjlnOFh3?=
 =?utf-8?B?dmNJdUpYcnFEcG5RQ0dBc2ROZ3ZTaGtNdjhqejF5bDhTZW9mSmV5Vm5DaXBS?=
 =?utf-8?Q?KtLfZrwqiB2Gq0aLiPjGXxI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	23S9quwHN1a1qYSKGFXq0cWOPJDDbe09z2Rq8iqb7VHCl/oFYZwy8NhyO+JMLACiQo9W7MPzkk5z0FXKsVWPJZyusdvbVeGEh4kXmJIRwFwsVxiDCavf4dqqIgntL/5h9rgyntXzOYb82UdtKWrBfoEByMMXTE3GgfE7YzbI2WHsaYISZXjI0eTE8rK/rhkPAoW0lv2VlI9pe2tNb/hJKmQGfuX5xjKegfKb/6871ePtximpXGQ1QlIP67vBAGuNNBThYQk9OD2j1WfUx45a3r4KKKd7Ub6i15EIQejwWUMPHffrSHZuL/rqz1nyIBEvIx4Gx3Ic63s7ySUWJaLnqCpo9URUArqcLtM1XHx4joBVVAS16Er+QfVfzaqXUgrMimK+wJrhkhu4C1rBl9d6fmQ5S1x3oj5PO/lomiZcf2lNFJU1VZpya7qIExLGc4BYusj33U3xsiKYVCn961fTZdeqJSyzS9RdQpd4AlA+TGvpBOXUcUU1ZDFQrFlmYAEYnN7Y+faSa4aa+0VRVcgZDHsJCn1BV0vua/HM8ac7Eqj52FSTLOUXmdUl5bvwxv854pasEEts5kjdluEdDvM4+snEFi93+qB3SpltxJLemDk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd5c0b2-8a8a-4ea6-e187-08dd466dff11
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 05:20:40.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e73igg2gs/aZmG8wBIZe1iaa4i/IEZJGaRcrGkEeRFSZBN18xcl+ec2wBYGFy7C26kSnfMxKERlAnBrnh0TAReU27CsLHv/ieYjECM2B9upl7yhEIi0NFAmtmNyaljDT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_01,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502060042
X-Proofpoint-ORIG-GUID: 0uGIt7m1Nf-00b4AWCmMuqooKS9ds7Dy
X-Proofpoint-GUID: 0uGIt7m1Nf-00b4AWCmMuqooKS9ds7Dy

Hi Greg,

On 05/02/25 19:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
