Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD4E24E4AD
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753270518; cv=fail; b=DMqYKt1CtPC9Fu2wPXVCoz9nuewaL1zlbaHiOS2RPBHFzjJr0QSt14g/qd580ajbQ/2E8pyPsPUqx4HZFpXP4bfqLtm8wxK6nRkZoSGRRO9QWqE7ktlmN/P+fAAPRZmYqqGXpBamwx+l9MKWYQagnU4G7ZjwdSK0UetTZUsux6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753270518; c=relaxed/simple;
	bh=DXCL0Bkd8nxaX1TMuljDTYqi6VKa7LlCTPrZIRwinz8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PgFt6TLx5Mhe67MfGObflx3NCTf/UEy1WeeCrXovI/wrU9wm2YZbvBtgyBTAWVXIsZ71H9duDqc7kHblRVXMk+UPkO6iwWSvcqOka7C2JT5OlGICy889XTdVQgXEZFrUZP6iffM2OSCb60e7jfcFaWmSXUAD87F64wJfM0mowQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UO5WqfeG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TAdHzj3+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UO5WqfeG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TAdHzj3+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NPsf000481;
	Wed, 23 Jul 2025 11:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XPsHaBT0ua/UprnrTVru8FvHo3b6Prbygpim/ngo1yc=; b=
	UO5WqfeGgzWdvCMl6VdKWTVN/ZfRuGnvi06QE1iwDchGHAIdK45pl84I8cgcam3H
	vMeTkMzHFpDX5YEqy9fRkzPUmm/d/f+YvE+N9wzV6pTVf91PKISDe5erL0SUAzm9
	ZAJtrydic/oVAkMoV6wezVjjy14dEDpmf3vVLPOnZGGTr2c+uFC29WliWSd89diz
	CXsNlc3Px2co3wLtOWn8BpsrDXlina36REEKUfrj2hHP2WUlFQXtieEjI0zBf75T
	Vv025HgEUE4xWNITvdouwkjLPLOfyOjQPciZVXdQu/SUIBeuuZBh1hWXchynEU9w
	YxzfsqcvHG+eMEgSrya+Cw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056efaeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:35:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NARfDK011662;
	Wed, 23 Jul 2025 11:34:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801taf1em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:34:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wntN7Mj6zC8RxzMV5bRuz6ceQbw1o5F8ciq9qn0Dzuc/BZu9uV5k5YRKatL/FaY9DlbO1LM8Bk/s145bOPE0YVUwFmI7h2bsUnKOAxFPIBH+7QF+v0hVVEkbTZY3eyG+VJRoV2oficUClEErDxlKg4qfGQhLp8/TUHFZmmXQ2E4ahh9nXJ1wnIPi2Dp783YmxPak54rEeIOTnj+W95+LALOUHH6p6tJfHYqo1eRvK37PL+ZswRXERlNDPAWVU4NVqVkHLw8ZrHgwLBPvFWpu8aLZMSp9tviJsKmEBu4v5JOVC2fTRaU4WceYXECBn51yG88xAFKgZB32WyIw9KmztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPsHaBT0ua/UprnrTVru8FvHo3b6Prbygpim/ngo1yc=;
 b=cp0zWkcRX44xOE/DU6PoVvRxoibfIPo6ThMojTC1URSeJUNyh75HeqLKHgCYq5b/m2S+2hXrMzFidvNmuj/taf9iEyajeATw2AJuLXECIgLo3gJu2+3yXQk8yAKz0YWq7DAccpzg66Pt1iP8eKjDvTKdZoYbBsof5xBr+M1PksH62PshNlkhpyk+TUpyp+0Ssqk9lD0FSaVIBsgzuQ3ErCxFRtPLIa/oG3veXsjK4k2ng/4nYCGWx3/hZX8x69xbKBSViro4eG3t6Hb9rMOnZ/L65aNj1KAY34/A6CP/CShEwPXN2eGwsY06dCP3NHndKSwcGJywPur/V9RONR12ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPsHaBT0ua/UprnrTVru8FvHo3b6Prbygpim/ngo1yc=;
 b=TAdHzj3+iuklfveMHq9I+8fLPw/yJ23/pfznd/9TL7vmAMhIjJ/2Jh2XINIXjXuX2Q8FEPdUWooM6QeFZPF3mIWbEMHTVYSvtITBrn0+fsr7a8qmz35cTqgoDEsqGWkGsZNzZXOgpKMUMDTNLMpeAMyc6IDlET2pyX7xX3IQg3c=
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17) by DM3PPF00080FB4B.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c04) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 11:34:56 +0000
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428]) by CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428%5]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 11:34:56 +0000
Message-ID: <76eedd53-d0cb-4769-9ce3-8893fef8abeb@oracle.com>
Date: Wed, 23 Jul 2025 17:04:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250722134333.375479548@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0216.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::14) To CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2310:EE_|DM3PPF00080FB4B:EE_
X-MS-Office365-Filtering-Correlation-Id: adf8eab3-912f-48b4-ada4-08ddc9dcf291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFQwRXlaMHI3eVZaQ3kxaGVRQmZUWUpmTlZYa3lxeDNRZUVVeWh6eHJiSmp0?=
 =?utf-8?B?UkpLaXZKY3h3Q0U1V3pEWXdYcDArNnhscDM1Zm1oeFZJbUtGakoxVkJadHZ6?=
 =?utf-8?B?bThrejJjUkwwN3FvdWNENSs1UmhsMHVZaG13SWNuTVRxNzJhRkt4Y2ppS2R4?=
 =?utf-8?B?aXFTRzhzbXZYZElpdjhyUlVBS2pFcW5VRTlrMzhRV1hKVzlwK3pGcmJwcFVk?=
 =?utf-8?B?d3V0WVIzeW9zVkVLUG43ODc2UjlEVG1JcEdsd3Y5akdxNTY4eTdOVUtJbStU?=
 =?utf-8?B?cmRUWlQwOWNaNTdzLy9HNHBmclBXaVFSSGpEWmE2aUpaVC94eFlSNUhiOHFG?=
 =?utf-8?B?cC9vSi9GbGc3ZG14VW9ORjg4RlBDWGxLb081bXJBTzI5OXJicitrQkR1SnBT?=
 =?utf-8?B?cFRhL3dySTJ4QUg2Q01uUC9UaUs0dlZVVE5JWWxwZ25lSm1LUWxFc2s4Y0dB?=
 =?utf-8?B?OHVXZnJsZ2gwY010UkhDYm1xSktHdlQ0dTVLK2REaVhxOUtGMlFLTWdsNmJ6?=
 =?utf-8?B?WXl0ckhKU1JYUW1xYnRHM1hWbGFBMU05NE1JR2NRdkM0MXI2UzUzOU1ick9S?=
 =?utf-8?B?QnpnVkJEOG93eDM2UzRPLzFoN1pkdW9PZzNUSUozbjFqOE0yNUd4bTNKOWlh?=
 =?utf-8?B?dE8xL0JIKzU5RW9UY2ppTjVwQklld0NlaGlwNzV6elNORTVnY2RjUC9YcjRJ?=
 =?utf-8?B?Y2ozUXlpUFBqZVRRUERBVkVDeWJwcjYxSHZLMDBSRm92c2UrQS84bUQ0VUQx?=
 =?utf-8?B?d01lN1NVbU9SeHRXTjdaTmJFc29EQThNdkQxa2ZHY0wzSTZFYWNmTEo3WXRK?=
 =?utf-8?B?bXhINjk4d3V6cDk3UzBUL2s2UjNlZjVFZE1nQW5pRHpRbHJmSGU1akFBa1BJ?=
 =?utf-8?B?NjBkcGdWZVBKa0RGRCt2SWJxSHcvbTVpNGZEU0MxYUhLajdYanFDTVcxbzIv?=
 =?utf-8?B?cTlxWHU3RlBndTgrRlh0QmFOYW5oQ21JdUEvTTBzb3g2TlNlQ2JkOUlpNUhl?=
 =?utf-8?B?ZnJFN3RRbzBZNC9OQ3hzdjRqV1ZiSGZBdUFyWUltY3NMVlNzRVVxOEh1emhh?=
 =?utf-8?B?NDkzSFZvcWhmS1dnTjZhUzk0dWNvbkI5R3lvMEo2WmVlTGs4dFZqZHZuTUR2?=
 =?utf-8?B?UzZaRVQ0dUwyTnovN0lSTFVBQmJmMW1rTVBRaFIzT0ZJeFlKbk1qcFRRWExF?=
 =?utf-8?B?MG4rZzJoUnpDazJOdUMyVWovZnVHUEZWNU9malZHaVpTamxFWUxkb2hFMlVq?=
 =?utf-8?B?RlNHSGpIUTRlc094SmgzUnlJUWZIbStQMjVudW1ES1p6cGFURlFTNVBuczVz?=
 =?utf-8?B?Q21MN3BOc3NJSUFteStUelFxaEE1djgvd3ZuVFNqbDBaOGVZR0NaSHRrNXVx?=
 =?utf-8?B?NGtxVXo3YkhRQ0tlbUt0TWdEMXUzaVVHTFBITE9vTHh1M0VwZk1kY1NhTjdn?=
 =?utf-8?B?d25RK2VaNGhmVTZLZE9SdGh2VUhMMHFOVDdJbW16dmpBUktEQnJqbGcxdlVQ?=
 =?utf-8?B?U1Y5eTFWb29kRlhxMVZKR2FNbGFiWTNvSnJnNXVaRGh2MHBZQjZhUThCaGEr?=
 =?utf-8?B?R1ZLRjFxaXBBZXl6VEJNRnR2cllaWSt6WTBwTE9BUjdQaWQrR21JWXRlYzhF?=
 =?utf-8?B?clFTaTBhM1RKRFFoMm1FU0V2dTIxWXFvMlV5TENnMHhBdDZiN0oxQTdhWjhU?=
 =?utf-8?B?c2l3NlZIdHdsRkJLWStTYXQ2VnZiTWJYUjRyRTE0STlMZjZaTXQrT0J3Kzgz?=
 =?utf-8?B?QTBjYjJOUk1UdFpBOWhZNlBHeFdFNS9tak8xU0pBOGtmMEZRRlMrM2tmYi9i?=
 =?utf-8?B?TGM0NWVRVDNOZnYrWVRRQy9TVXVKNzZsMklGWXJ2RTJ6dXdodEg5aVVQOE1m?=
 =?utf-8?B?ZlZkSVZLSkpKOGxKakNleDhTVElsc2tQdUdjdDFuY0ZZREMvTVFEbENsaG96?=
 =?utf-8?Q?zytQbnKGpi4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2310.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWpvUWt1aGtDWmFieXNKcHVnSk96RWlHWWlxYldOS1luUUNHcHlzVkxHcjJD?=
 =?utf-8?B?eGt0U3padEx0QUY5SkxOLzRLWXhEdndiNDJOZCtKVEEwenNhMGxNNlRDQW9w?=
 =?utf-8?B?MzN6aG40SUZQTnZkaEIxalp6QSt6WTJHN2V6ZTJDbnNyZVNxY2lDbTZGVzU0?=
 =?utf-8?B?MVhMSzBDeXMvYVJ1UjJOV3E5ZGd6OWY5TlMyREFSR0hJOHB4ZndLS2dQc2hQ?=
 =?utf-8?B?dFU3UCtsbnFtajgxVldBQ00xM2Zvc2xTWTluQ1pGc3BMSVlwYXQvNDZuME5i?=
 =?utf-8?B?L3hZaHpkYld2cUxnRnJsdm1EbGpCY1p3SWZ4aGxlWU55aDZoNzFLckFzTjJj?=
 =?utf-8?B?TnNERlJTaUV2Y2R3QlJFdEJHZVhmS245b2UwOVJKOHVaNndBWjNiN01tTm5E?=
 =?utf-8?B?K2t0WGJzQTZldjlRNnl3Z1VSWk5PNGllRUYvUDQxaVgzeERkaXh6NTE5SWsw?=
 =?utf-8?B?bHpQRitLcDJTLzl0M2tQMTVlUGJVRTlqeWYzS1JBK200aHdMblRFWngxSHFK?=
 =?utf-8?B?MEtFVTlKbTcyK2NwcHhVZi9HWDY3Rm1qZXdqdHluTDU2MkoyQm1XakVxVDAx?=
 =?utf-8?B?alpHVkthUWV0MHpPWVd1c1Rpais1Q1FpRXlLTzk3RGs3WVh2TVpzLzF5UmtH?=
 =?utf-8?B?VlQrZk1wRXJMZVkxZ1ZUZ1pTdUFLdEhYdEhHTWJweGtOVHRSZWgrRjBmaW5F?=
 =?utf-8?B?cjYyVldUK1BpQXYyT1NUQ0FCNzAvSVhnc0EzRENwRUlrelVMSm15blF3bGp0?=
 =?utf-8?B?UTFKOEE3aHpFd2djc1BwSWoyRUJNVzdrYm9xakV6OHlxSkFwd3dPM3QzNHFI?=
 =?utf-8?B?N0duQjlPellJLzd3M3pWKzRNd05VMUt0S1BucHhOeE5xNWw1aFR3ejVFRU14?=
 =?utf-8?B?K3VOd2h1dWpBUjJSV1JaaVJkSlVpMktXZHd5UnVPVTk4OFBwSjUzWXJQM2pl?=
 =?utf-8?B?Uzl6UEsya050VXM2Y2lZUVViRkV2aWl4UDB4WmdWZ2lXcnFkV292MEFXYkhr?=
 =?utf-8?B?S3ZaUEc5M1YyREVWT2RMdTIwc1h0OFJrMUozbnZ3Rko0b0RsU1QzOWNWanN6?=
 =?utf-8?B?RFB6UzlVZ0Y3bnVGdXdiNUd3dlE2Y1ZOWCtraHBOb0Vlck14WXovUlE3aE1y?=
 =?utf-8?B?ZzA1aHJ4czBPcDloeVVoUy9jTzhVQWpmc29aTmF2cVFwbHljS3Y1UDBXbmpq?=
 =?utf-8?B?eXBsMGtrSjZaZlg5MHN4RVBMZnV6TnoxemFVTUFzcGxBNEMveEYrSEg0MUZY?=
 =?utf-8?B?dWFpL09xSUNzUkFiSzErc0FuN1ZqUE1BTmVHcGVEcVlmY0RnbnZ4YW4zdmxq?=
 =?utf-8?B?ZWFuNWJjZ1NnbDczZ1Z5Zm5yOURCcnVDR1NudDMyTGxSUmR0S2hKNVIvbjVN?=
 =?utf-8?B?ZE53VzZqYkUzSTVKMVdWd2JjTi9HMWRCT1Y2eUJBVER0Y2JBNGlXY0xjUXBJ?=
 =?utf-8?B?SkVCMnRVbGt6RlZOQm1KOTRueWwwWkRqR0RoUFZnaCtMS3pXdzZWRGg5cFVl?=
 =?utf-8?B?YkJ0anNtOWlVM3Jid3Z6U01rQldkYmE2RzdZREs3emluM3E4Tm5ZRmRjVEJw?=
 =?utf-8?B?RzJlWEYwS1NvT1FicUJMRUlwUDlSSGtqTWo4N08vcGxvZHgyZkpET2Q5SVc3?=
 =?utf-8?B?RGRwL1A5OEVIc1NtcVRzb0Irb0hDcmNQOWJlY1NWU3RuM2kwUkYzNmlnS1k2?=
 =?utf-8?B?ejFpZFQ0bm1RSFo1R1RRakw5d3pVVWFqSEYrM25uTFlzQUlmbnNjbzJiOXRj?=
 =?utf-8?B?d0EzUmhvWkZIcEIyRUNoUldhaG9pZVlyUFJBa2VLSjI4bUZ0eWI0L0MrUldr?=
 =?utf-8?B?cWRuNy81NHVDV0RtZmZLNnRiSTRuWTk2SGI5U2xiTFNvcGJqajBHeTErSC9S?=
 =?utf-8?B?UkE0bFhNSDQwZUkyTlFEdlZxYXNiVjhveFVSYWdVdTZza0doQjAxWUlRdEtP?=
 =?utf-8?B?YXBvOTJLVXROZk5JZkN0aXp5KzlwMkl1Sm5LODVhYVFsLzJDUEp0NG9mb25i?=
 =?utf-8?B?T0pYbmRMY0FvVHhqT1lLeEI3T0UrdXhkenIyRUFkL3k0TmVQU0ZycXh5WU81?=
 =?utf-8?B?NS9EZHU5SHpic2RxdmdSSUxKdVhtRWNLd29VVGRCZk1aWEoweHRzditzRVNj?=
 =?utf-8?B?SXkvdVZRaGgxcjlva2NobDU2SnFhVkhoelNzMXhrN3Robm0xN2V0MGpZMHFz?=
 =?utf-8?Q?49yeVQYL5CSB8uwpuRYiPbY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wycn3GjvSgltQLnbAvK4F+d0ryNfeebaMRmzQXiEEhGyUQealehfYlxxSdrq4Ey0y2d7IIRGVlGgvkDEmxmeQoC4XBAwsrx/5Xg9dnkkvPdbYbnAvUpDii6m9RLR6GWcuYadcA148Hmu0yBnQrwQjKyGvatPpNACPmFQtV8Lw0vgupBFXy9V8j+wz/8PTTPfG+L+wGlEjdJ1ovHQ30tbr2CZarkcSLs8CAn4cHjuO0dyZgOzM+p/6Y3tlgSaAGiZoliGsaG/RYH3CL9CRe4wBh4XYVCaXGgoaTGdfhJQ01gl4VhqiCr4C/PqAafzOHPnwi8zmAZC6JG88Lk+AR0OIuKnJxh3Ag5bKQrs7HsxYJQbg4234Su6B4ENb8TCam/I1ggjNlomntGn1CLliY8wb18EXW/9t0A4Et6J8XVGGNxsBXnAmq4nLAY6VtfBAI7ENpZjwwpQ8v8EqNqbtLnAKuzwbviR7Set4e7MjMAXd/1oJKxvfRL/Wh0C1EC7hTin7JZwIuU/A1Cv+qy4zRmSOvUzOwPkPVuqx+7rwMnebPxAXoORifsTt98ZBAHsDOTmgEOcGZtR+lMhgruorUdtgUhMzpr1+O6e/+5zXJDE2Do=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf8eab3-912f-48b4-ada4-08ddc9dcf291
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2310.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 11:34:55.9938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7OeVkjo322vuRQF3UYMfYdwOWR1NwflZAG+0zmuL38m0X+YoH954XhLDAYtM8bSen9UN7y2veXbQ2wx0kq+1Z0J1suVXSoUHFD9WdPlLszheG925kTI77qPOQIVIIoDR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF00080FB4B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230098
X-Proofpoint-ORIG-GUID: 65aWYNujZHbXuYnCz6KkFIvIpvvAXiRj
X-Proofpoint-GUID: 65aWYNujZHbXuYnCz6KkFIvIpvvAXiRj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA5OCBTYWx0ZWRfXzFuyagSa+aDX
 S6EfL4pWVEq1qY8enaypBqbCchfydOu796UsdUX4YPAv6Isnl84BwX4Kh1NX08X67WT0mSLPwGx
 0dTBsRTHBnZ8E3OC0W+JEG5Ctd6d5a4LWHIt6J5OgGK3+8NCT8bu4SL+4gzvQMn+L08ZxC2BmTD
 9CwBgjVoAsTnaqo+J/kC8nFBgczfr3mMg0y9ePGPWSBEvpAduv+lDSJigSYcbJSXfozaTCy+eQ+
 5focC3wlTGXJn/++0RWRWnYGHb/JLWKJbwyVBsHgXqqkTdG73M1B8C+m5VPU1BOkhGw1qZDErFz
 mg897HS9MEu9CgK1r/NVGLoPQhsJd/uHTfHx4rTbiCFMRL27Mo2gDphsZRkJgQhMWiHf/wZsaTm
 ABjXitngyoLc/oqsZSeZEMR1tXnoUG4Xq9m5dmi6BxhLnlcK5ArDpLRsw/X1KLY7/eq8YtNT
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=6880c8e4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=Xq6WveWaWgIdxh7GAcgA:9 a=QEXdDO2ut3YA:10

Hi Greg,

On 22/07/25 19:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.100 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
