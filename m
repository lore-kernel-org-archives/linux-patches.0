Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC3718990C;
	Fri, 15 Nov 2024 08:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659631; cv=fail; b=FwWY9v8eB1y44ZtDjVOPjgxuNrwhG4zkxTG5l/QkWhV5Hcxgc2Yvvk+uapgye4bQhp5bvKXpEYc86chYa64kFeqJkoK6B8SlaHJGsnVAnw3gir0/37e4tn4r3iBiyX28uhBw53kZnB4oCo5KJaaUvP4JlghtzMY4EyKaA5lNUsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659631; c=relaxed/simple;
	bh=67ZtE+7Rj97vRf55NMtE5J3yodBice7iUz/QXwJ44Hs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CXJd+IlMwaPTyDSs7LUYNBPffwiLPalyZYBH/ksxyAtuxt5lhK31ZS024xZzltWkl1fJFC26iAUS79lSILE5Cg6I77ZD9O81OBxwSA7lDVU2Vlall6uRWSzBk72Qjitr1zn5yQEpxRJ10b0cU7uBhNFwJRIHijstdhkfUymWlKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=caHkmbmR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KzRSH3m+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="caHkmbmR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KzRSH3m+"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF7deui014376;
	Fri, 15 Nov 2024 08:33:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5LvoIcfHzIqkK290kPZzKwK3ShZLcWiQLdhEEtUerkE=; b=
	caHkmbmRJBDruU2rQBpfNBaNzIWp7YHYa2UYKdoOXpzPCajYJYef0TVtMjyrvx42
	HlahnDzk6H9byvMn8STFxEPi+Cuw2wPMGEvMSOzvqSLqrzJs2zJbKmoXNr3LTAbO
	8fg6vgSosiMwY/CQ1VVgG2OpJSQpPkw2wSZXNUBoc2Mnh2COf+VR0db7Q0QZpMfo
	miy3kzpZIl78L5jNFGBR+PKky7IGqCJAD5sAu4aw5O6Qli4nD9R4+c4+SwfUuPgY
	PHW05+H+V5S1j5BL8vhY9JiFwBK9QzVzSd5u0b878rSBnkwHouYl2wSGZg81zrdM
	EZFnY3uUk0zT+d3V06rHVA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbk1kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 08:33:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF8FqGT022819;
	Fri, 15 Nov 2024 08:33:45 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw2duu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 08:33:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ILORHKVtu3CRwbIkgIx9HZm+kNlEqc0StE2WqwOrGTffHPmGu2j3MUh4aYtxJhqqRQAMLnVjuPsKeqFZj6cG91d5LU4x3CDXdjvkkwym5HAtCDbPfzFRPuu48vjNXKv2J5wnI6NOryGqYLa06kcIrBXIMpaEvXuKkVVhc3H9x2d/cDa06Y58khl/hixWzft3gOgyScHjy3qwVrpX2B4Br8kql7cVq5P9HkyoMjs9TRveHUJC49HSZ1KpwXznLN/4Z/usJ0mhdc36SxGse0fCyoigYA3MnMac5cF4XrRZ/kWQXzcGNyH1XwVG7obqV4xOHTrCeMKCROO1QYf1F3Dl1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LvoIcfHzIqkK290kPZzKwK3ShZLcWiQLdhEEtUerkE=;
 b=dV8T9twLLrxPHjfPbYrVYdcr3b3KH4vLitAN+8bD8yAZQ99udSjqpUpdm8bFFEtiVewWOj1j9QRpQB/7OKxN96sl8on7+cvPU3zG6syf+CEL8IQ2vALdfo2R3uF8EM9VQPseYAfZRHCz+wBha96DH6Ueq7sFXGO7DdMdaOgIrf1Zl5isijFzm7NFfSAgnH9JP7wFnzWFd4ZDH8nlJXtZ8HflVViwxONsPtXDwA5FeoulixUWe291ddZszQwJ6GCgmQIMqiF/XyG+cN1FXS4dgMqQM7IaYLNHJcXyz7KtORSw2XpIyUJjCa1/9f7e4sKVvJWrue45hNTIr2E5Wxf1Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LvoIcfHzIqkK290kPZzKwK3ShZLcWiQLdhEEtUerkE=;
 b=KzRSH3m+USbscBdSDnanXJUux8cwyDmxJSu+owyiJH9MWAiqxWBBvDoGKLDGWk0/rGQYLcHANmlEpicmKZmffLOmFi6TymSLG3u9Ap6yr4WVcll0QYs3R/H+7HxaiZ+2KOzCHRVsVHW1JahGZhz9y/rWPotXqEzSM+HlGgGIvKw=
Received: from PH7PR10MB6505.namprd10.prod.outlook.com (2603:10b6:510:200::11)
 by SN4PR10MB5608.namprd10.prod.outlook.com (2603:10b6:806:20b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 08:33:43 +0000
Received: from PH7PR10MB6505.namprd10.prod.outlook.com
 ([fe80::83d9:1bf1:52cf:df54]) by PH7PR10MB6505.namprd10.prod.outlook.com
 ([fe80::83d9:1bf1:52cf:df54%3]) with mapi id 15.20.8137.027; Fri, 15 Nov 2024
 08:33:42 +0000
Message-ID: <003c7218-ba88-4457-9175-b6901318bc1c@oracle.com>
Date: Fri, 15 Nov 2024 14:03:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 62/66] mm: clarify a confusing comment for
 remap_pfn_range()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        WANG Wenhu <wenhu.wang@vivo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
 <20241115063725.079065062@linuxfoundation.org>
 <4537b145-3026-4203-8cc4-6a4a063f4d96@oracle.com>
 <2024111556-exterior-catapult-9306@gregkh>
Content-Language: en-US
From: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
In-Reply-To: <2024111556-exterior-catapult-9306@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0231.apcprd06.prod.outlook.com
 (2603:1096:4:ac::15) To PH7PR10MB6505.namprd10.prod.outlook.com
 (2603:10b6:510:200::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6505:EE_|SN4PR10MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: 5470a08b-be0e-4a18-93f4-08dd05503641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGEyeWlzeHVFd1pHOHNLbTdESXhUN3k4ZkwyQTd5Z0s5b2E0d2k1MzhVWlUy?=
 =?utf-8?B?eGM3V2pMRzZmaWxIaGVWSXRSeUtKUy9PRGI2ZDNiblVyckdrMm04aEZ1cjcx?=
 =?utf-8?B?Q0dqK2U0VWRFZE5xbHROMDM5YnlSaXdVS1hqRUtmNGhQZjBueGFmRks3QVJK?=
 =?utf-8?B?eFVMeWJWTm5XWlBnaklCajV0SzMzakNpUHNVbU0xZzNGSmhDcWJJRDlUdWFr?=
 =?utf-8?B?RkV2NkVlRzVNUWJzODZuWUp2aFovREh2Nkt0NXV6R3BRdDVKNDg2eTdPeCtE?=
 =?utf-8?B?ejVBYUxVaDJiWStQZjZpaE9RT3BPQnFndkhpeFFjd21xS2Nwcmc4TkVjVXJ6?=
 =?utf-8?B?SVdBMnJVTy82TE5HUXowdjIxRnpnTmdlcVNVYmRyL0tFNUlHWHlWWFA1aVJ0?=
 =?utf-8?B?TnNuRGZpd0haaUtSdzBJY2UvRVN5S3R2cDBOd1NvRE8rTmxmRnRiYko4V01W?=
 =?utf-8?B?T0NuaHd4T2U1L2NWNmo4NTUwTWJSUHFUWm5wRUVwN3B1a3RtbzZFWUdkS3p0?=
 =?utf-8?B?OFo2MWJQQzVEVGtqazFZdXdZcllDQnFyRWRZNS9OdWtPYkUzM2dDUGNRd3lJ?=
 =?utf-8?B?cXpUNTVEZVcxOUxVZDJLZ1dGMklxYzZnWXlWMUpIMzUzL0xjbU1oelQ4ZFhF?=
 =?utf-8?B?M0ZUbTV0a0M5c3h2dU1RSDQ4ck5jYVE3WVpEUmRBcGlVcjRkUWRibXN5cFph?=
 =?utf-8?B?MnRrUXYwMkpsUCsvZzRLT3JnUEliOGdjRWV0UnNJZ2lVclZGNUZyTUZVQmxP?=
 =?utf-8?B?STVBTHhMSDJicm40anA4T24rd3p1SlNyZUJnOGhsVDNQOTFEWU5PbjRTOUJK?=
 =?utf-8?B?bkgrV3J2Q2Y5UFAwZXc0K2IzTlUrL1k1NHJWVUxmZWhqaXI5MGtERWhwUENa?=
 =?utf-8?B?bWY4MXU3WW9rVm4vM3FjR2c0YVdyVWpzMjFQdzVJMzVVaW1Va05SY281aFJn?=
 =?utf-8?B?aU95aTR3M1RrRWI3YyszQVpNQ0VnZ0ZIVHJ5RHRFdlQvTm5xWXB2a3laUkcw?=
 =?utf-8?B?c3hFcjdJR2hTblFHcUg2S0xXRHZJSHFvRm9ZU0xsMnc5Y1BIVnNLNnc0c0hv?=
 =?utf-8?B?NGFLR2loUGs0QVRqdnRzY0lCVi9JaERLQkdUOEVmbHIyYlN3QUkxMytVMkFh?=
 =?utf-8?B?SytqM3gzQVVySU1RdzUvSTlRT1pialE4SmVvZHl4QTVLVG9SM0JxUlowbXJk?=
 =?utf-8?B?UHNrQXlNV2hNSThjc29kVGRnYlNrcFJLOU1YRG1mT0RVUStab2QwdWpLdi9h?=
 =?utf-8?B?UlYwbTBPWW56eGtuTmFsWXlFWTFldU5pNS9qNUdRcXlZdFVZclBPaG0vWTFu?=
 =?utf-8?B?RVRmNTJMVHY4cVphMGFsVlBvdDAxaTN3SmZuTXVIelhkano4bjdDWnB6anFk?=
 =?utf-8?B?aVQ4UnRoTWlFeC9ydTd5aDV5U3ZpanVXcytBRWdML3Uyb0ZJbGtoMHRQbjFV?=
 =?utf-8?B?MlZlVFFFVXV0ZVFhMlI2QUF2RjBTeHFqSWw1VmhmRW1RdzJkekNMWXN2SmIw?=
 =?utf-8?B?WGkwV3BvTkZKcW1neENHU253eTB0aWxRV2RMVGZoSkJvd3FyVzV6TklOMGJ3?=
 =?utf-8?B?UkJyVGZVc3FGKzNoYmFpVERIS0tUakhsNlY5RUpUaHNQekhOWnYwYjMwNzNI?=
 =?utf-8?B?OS9qUWdTSmp2ZDVOWDlqcytQS3pMa2EwNXRjL2tOclp6eDFDMmxxYklmRVdQ?=
 =?utf-8?B?dU8yL0lOZ1RTRUROV2R6aVJZSmNHNkZBK1Q2RTRlV200K1VsenRFaENuL0tB?=
 =?utf-8?Q?PBaKtMM83L46Hm1JMmJt1khmEUlKBsF14yVxUzV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1FVSlNTaVBVemtIZzVIbDJBSVBSTnpsT3lZcjhMc3ZJUU5zR3crWUdoWS9Y?=
 =?utf-8?B?U0dXSnNoaHR4WDJYZ2l3RVNrRWsxTUw5M0tBeDJhckpOVEd5cHZSUG9MbGlq?=
 =?utf-8?B?QWRqejI2S1h4aXlwazVrY0hVZkQzcm1DSzhYeWd5dnU0WjZ4eGJKMEdmRlJC?=
 =?utf-8?B?UDBiUjA1ZEx1bWIyZ09sWStRUnFMeEg4SllaL2xPWFFVV1NRTXBEbUNmR01I?=
 =?utf-8?B?bmZUbytuVDcwRk03TDVpaUpTN1g5WC85ZE9xcUkxZWU3QkZ6WURFZks0UlFW?=
 =?utf-8?B?R3BTTUtMa1pQNkE5d0E1RHVOM2orbGJ1cjZNNmIvODl2TFR1Z0dpbGNWUy8z?=
 =?utf-8?B?VjUyaUJpWjZWazdkQzEveDE5U01RaGE1ZGpyNDRHc0FzaGdjOU5scHNqdlZV?=
 =?utf-8?B?dS9scEhacXhiYzB1bVRrU3dVeS9rck9VbzB0T002WGR4KzN6QjJCS09lZnhz?=
 =?utf-8?B?ZGVLNmpXM3VuSU9QejBPMHp5a2oyVEZMT2p1RVVKbENETmhTVzZPRTltZWds?=
 =?utf-8?B?ZnJ5MUdEeWNOQUZrTSswcUhxNEllZ0greDVHQVQxaFY2SzhkL0t5c3MvNHRS?=
 =?utf-8?B?MGVpbjdDcGt0dEdJZ1dhTTdoVzNsSUhjVThHSDdvblQxNzliUXQ3UnFGZlZl?=
 =?utf-8?B?dENlQzlFcTlSbEFGUDllOSs3bjdJRWxTM21sMjgrUXNtU1NLMVBBam9YZ3BE?=
 =?utf-8?B?NjBpL1R6dkRkVHJKTC9WVUZHREV2cStKUmxndE1tV0hQRDVndnZOWnpyNFY3?=
 =?utf-8?B?UXJpUzNCUnUycUhMY2VjdUZab2pGNVFreXZvZXBpMzdLRldNQytSNm9qSWxT?=
 =?utf-8?B?bDNCY0kwVVBIMHFkWFdlZndxSVlrcmhMOTZLMEVnWUxSblNnZXhnL01MUE5P?=
 =?utf-8?B?bHQzUGNqV0szZGE5YWlyUm92WGRrNGIzRDNpRE82Z3NMYzluVWhadmZwRFVv?=
 =?utf-8?B?d0ZNMWlDd0d2YXdLb3dnT3FKUDdIOHdBaVhQOEw5SWl0N050akh0dEVPSmV6?=
 =?utf-8?B?Yk1rOVY5Zjg5UWI2YjgxQ2pJVWsrR2cvcWRSR05WVXNoS1VzN3o2SENOOUt1?=
 =?utf-8?B?eFpFajNrWlp2NlpaMFZGaWJaRlBYcXQ5dW5YWG5KSERhbmxNcU5ySUlrZTB1?=
 =?utf-8?B?aVVSOGRLaDRhUzBkZkUrQ2ZWWVIvYkIwb011WnBzSmwyMWRrK3BKWWJMSTgx?=
 =?utf-8?B?Uk1aRFVLcndGbHVjYUhyZCtOL1NLQ2NZU21tV1lGWUNqTWtOeEk0RWpJb2tY?=
 =?utf-8?B?ditqa3FKc2NyczNvWTYyeHQ4Y0lKSms4YWdwTFhFejhQZU9qVklLeDVJMUpH?=
 =?utf-8?B?R1YwK1lQcXJva2Z1TUVyZUF0VnZxSWcrMExJenFnaTQxNHZiYTVDTlM4Q3U2?=
 =?utf-8?B?R2xsdG9xUElqVEdJUVZ4ZU9OUXpQZGMzNUw0d0Vsci9oamFyYk03UG9yNUls?=
 =?utf-8?B?Tk54Z1BoTGlIQjdUaThhZjU2dmgxS0w4WG5YOU95YUhwZGlnTWI5WFdXeFVm?=
 =?utf-8?B?WnFlYjl0N1RJMDdhVXBORXVBV0VBeUcvbnB5d3hZd01mY1VhMGNYQVJmdWNP?=
 =?utf-8?B?RnhtWVkreTVKZ1lzWk1GcU5VKzVrU1dXUm5yWUlYNytoa05OK1pVYUxOZURP?=
 =?utf-8?B?dGdkY2UvY0RNN3BUSzZ5SHF5V3d6b214ajNHQm10QTk4ODdCbGp5ZFRueG96?=
 =?utf-8?B?VCtISkx2M2E4M3V1cHVLdkZJeU9YeUc1bGtGTXdxb1p1Zk9SRnNHSUtqN2tH?=
 =?utf-8?B?bFZETGpWd0llY21vRDRLS3h6WGxoK3RpbUx2NFlZaXliUzB5cncwM1M0SmZQ?=
 =?utf-8?B?dzVVSktPc2hZaFhKd1NsaGdBekptb1FIdVFIODI4dys1MEt3QU02UVAxeU1F?=
 =?utf-8?B?L3BWbVExRmZLM04yL2hSOUZCS3ArbnRMdkluakl4dXpST3RjNzNwcGRuVEZF?=
 =?utf-8?B?ZnRNOFZzYW4yV1BrbzRwNTkwOFI5R0RJYnRYMDBpKzA0QzhQbmx2UlEyR2sv?=
 =?utf-8?B?Y2hvVmEwV3NwOVJ5d1pybVZsMnBDaHlldXdPcHpOd3BMTjZPWUpheTNBT0dZ?=
 =?utf-8?B?UExBR2RtcHJ6UGJTdDJtYW82ZEwyRVhVamNGM0VCa3JodmpIK3kyNDBFSHhl?=
 =?utf-8?B?MVJWekF6NEpSZ3FYS2l2ejNHcXpFb0tXZjdTUm5xQjRLZnJLU1FyM01jYjlM?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kX1XBTbjeKwtqB73UV/3tjhN1NHoJCo1njCFrrJ1Ci3wbyi00usWvl4XUuIk3CcHxKQP1IjtLE2AJngURENp4PyM9Zu7Cx2AboGw1T/t101g6LXtWzzEw6Z3EWueLmcs6k/n5GMG4luKE2Y0PRIiQpC11lJjIvGq0zMyCukcU6sQadIXJYtfxU1Y/Uf3MfTSQL+h6JU+E/WLPLToQWEfh/d6ia5RN/5HMIwu3JTb4V07peRdO63qHUhb9o5m6PeG30uLyLhNz7mOKZ1OgWX8e5vcVMTAVnoKq+FfrJM5eW82JzEWRUdmIEnXlpSq9fFfyLshzGKZ2MvdhYcP2U98Wb6aCR6Xmoj0wmx8y63Tbzv+QJIktPOtMzo7yg9Kivp14ByNULcw8RaLscB06v13bpiFb6WRASWbl34QsWt3IlQvfsjKec3hUAPF1CkCYSI4zq4qDf88ojkHHZFjCJmhQfO3DgfwRKbgG16LRKDDzJ7pGa7ab/AEBuzIPcWhTEZrSOtftVT4Oeqk69582060WthiUJ16uqUp9ZjD40RlDOr+Cvf/cDTShPGyoHIHvmdCDpJIN/i5bR2IqDbJD2EnihanHqusjX2uPbtBpWUIgEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5470a08b-be0e-4a18-93f4-08dd05503641
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 08:33:42.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lK6Swjya425jt2MCC+Z6WRQZqk/W9XhP2zrRE4snG1mAup9MdCbH04ERGL614y1zjQGXw1fV0F5JmHD17+4wjn38d7rh71x8iHL5XGq5ZKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5608
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_05,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=751 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411150072
X-Proofpoint-GUID: 9gbibjPoV6Op14ZcHHnwGDu5NLyQB6gY
X-Proofpoint-ORIG-GUID: 9gbibjPoV6Op14ZcHHnwGDu5NLyQB6gY


On 15/11/24 1:58 PM, Greg Kroah-Hartman wrote:
> On Fri, Nov 15, 2024 at 12:30:47PM +0530, Harshvardhan Jha wrote:
>> Hi Greg,
>>
>> The patch series is fine but I missed one final patch of the patch
>> series. I'd like to send a v2 if it's possible. The series is missing
>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=35770ca6180caa24a2b258c99a87bd437a1ee10f__;!!ACWV5N9M2RV99hQ!Jjv9Q-SraAFRWb-CchHiy6wbnrShMziEurtSW12w68rZFsd5FNRhQcNyXIoCxB3oCw2J7dFCD3VnmB-poyn9n9xKb-xjvg$ 
>> unfortunately which is the fix itself. These patches were required to
>> get a clean pick when backporting this patch but I forgot to send the
>> final patch itself. Sorry for the inconvenience caused.
> So can I just cherry-pick that one commit now?  Or just send it on and I
> can add it to the end of this series and do a -rc2 with it, which ever
> works.

Whatever you feel should be the easiest way forward. I have a v2 for the
entire series ready. I could send the entire series or simply just the
patch to you and you can add to the end of the series. Please let me
know whatever is fine by you.

Thanks,
Harshvardhan

>
> thanks,
>
> greg k-h
