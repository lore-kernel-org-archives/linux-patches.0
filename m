Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71714263F26
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 17:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741715489; cv=fail; b=mNHAb39MoPtDbPdJxORqWUTCkCDQrkwBUxpS4tfL9cCOMY/E/MvFZI6895zalTaQTu2FrVUkWqQvMfxccyvymTF4jdkwg23YPgCFXN9+wWTHetY5DOfVO1yFRb4OivS6r0HeFOs1vA65Hq8yv4AVzzvrq1tw1g1vflNpUnDix64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741715489; c=relaxed/simple;
	bh=9tD5nEdYSD2hZFG7VudOGJkh7Rs3iwPCMMdFxVS347w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qacq5LrUrVI2ggR/3sutoYWBIwIfdZn3IlG5+1gx5Ia8BZrtHJdD/QYznMq1ID04J9beNhRCi0sRiOvoavPlqZpOORV7nJSM1AVkbHEyAL5et82ZAtW2Y0UBAbI8OELZoUrkmrGzqHK0lncNReQd5RZHanH5gFdh6TWakKkpmmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I6tr8Hob; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fBCswmD4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I6tr8Hob";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fBCswmD4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52BGQmLp004069;
	Tue, 11 Mar 2025 17:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hOWw6s4HqBe+AaFz3gMk6EU8TUpHQcOpTIGAvlF0Tj8=; b=
	I6tr8HobVMV3N+i98w2NAyftL+GfWM/oebw7H2ZcIQSqG4RBWVDtz+Hm1iFLNvGb
	6OjjR0sF4P2zG7CIszTP6+mCCV4gc1wx3grbEIaItNSgNaVF79eJA9Oio0NPBD9L
	A5U0KoJAj6EdSH/9pwffKR1PPhVVuWpYseEhDn+WUOLi8A7SYzlzv+sAPbl9fIVa
	e2wtEEE8otKnZ9XvODjPelFjfeEeuY9K4WdOgK7X4uzyhTmbCm4yKsX8uFAtHFQH
	3OpOFFdr3HFYcw4rRHPlUjfHLXYC74vv9UAfdSPzLQI4WXAqhro4kipFRWlOrFGy
	YiyAxwItEd95BuHhef7ihQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458dgt5drj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 17:51:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52BGhIRD017521;
	Tue, 11 Mar 2025 17:51:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458cb9cf62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 17:50:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QKw6S/VD8yipa7/FoVh2AsDXS1W97dd9fjWaeIR3Q+EUT7JxO9RX81c/PMHw7HyKiTOPde3y1qB6Ql8TMOsOuSXdWtGm0KnnNzQWrUVlzg9WnwKs6Rjmr9HtVIjjxMgXIeb1BPSlOKMBKurrBbDryTKPpZ+TKOfJEEEHa6gStLAQFN8K2Zyq+Epxr7YXbC+sB0j3oF/c6Vks6/l5cvJzYrhG2XnpCjYjprahtEXqsj1U9xj14dfhMm4pLTU9VW24y6sEoj1cj6lQJFtBy6QuqeZB22yH47ztg+Z8rr0qUggHfQy+C5XcUaezUQrqfBE1thkji15WK88WePCHKQB13A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOWw6s4HqBe+AaFz3gMk6EU8TUpHQcOpTIGAvlF0Tj8=;
 b=EqCBT2pXNsJMlbmS1ajHGEwhYsrmQkq8TRATeIlJChdGFHglLthGYSD1GIid6Kuh9YXRab6FN7US9BhOjoEC7MFODuIxMTuAdmAR0a/scKIkPA+VtbkvqcenGTa4Wd4H+ZYHHnsEnbTKgsr/ACvRYGf1BDq1CZ4IhUb6PNGfG3iHjCw5OFSRibyA97wzah26nHkxOuXvZKX9ZSbD75f38cWza5IR2SJlgZYytff7ziYgwQxxyo041UaNOG54kNIHkrsF4jWmSiz0os21moTNcD31YJI6Gn5jx870Q3lcOXj72HHclt1Dlatk88qAkgJx+GGmdsiscWovDTPAxtPfWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOWw6s4HqBe+AaFz3gMk6EU8TUpHQcOpTIGAvlF0Tj8=;
 b=fBCswmD42Xk6Mi/lRFAkjfQQEB979o4+uu+YZW0NyexrayoYYTQXKQI3tprRP5SFGau+hEBbtCTEbnEini8ebH9OqKl3eEmT8WJi66U1alJNxqpAhDNPMJZxzjzh9sbdHPMGvIPrt13/pyTGtuoPyvaDT6WQckCJTlc1tJvz22Y=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by CH3PR10MB7188.namprd10.prod.outlook.com (2603:10b6:610:121::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 17:50:53 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%3]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 17:50:53 +0000
Message-ID: <da314ecc-c7eb-4351-a9ae-ff1c8ef72e44@oracle.com>
Date: Tue, 11 Mar 2025 23:20:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/616] 5.15.179-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250311135758.248271750@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250311135758.248271750@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|CH3PR10MB7188:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae9a65c-8660-43f1-46cd-08dd60c54476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFhvdVd1QjZ5bm05SmZaN1hGR0pMVTVBY3NmYWVOUzMrOGsxN2x5OFgrVGpa?=
 =?utf-8?B?aGI5N2ZZY0t5cmVVbldxTTluVnlMWDliWW91QzdoWEhNRG11dG53NDlqRnh6?=
 =?utf-8?B?TEtYM3NPZDRpSGhaZGhIT2VabnJGRmpwKzdoOHVIL2E4QWRCZ2RxaENBRXVo?=
 =?utf-8?B?QklXd091WWZQdUVFU1NrYlNnVm5WcXlINDdiOGxGME1sbnJ0Vzk3Z2VwUm9p?=
 =?utf-8?B?ZW15NEJpM3hHb2hYd1JzS3RncHVJYUpBRm1FR3J0TmRUNStXOHNVZ1pvTUZX?=
 =?utf-8?B?KzM3cTl4Tm53R0VLblRkanZFMVNjMlgyNjhQWTZteFRpL0hIK2w4cFJRdXcz?=
 =?utf-8?B?SlBrTkk3UlRQb01qenZPbWVNSmRsOWtmT1pzNEg1TWhyWVpnaXBCRDdyQnVU?=
 =?utf-8?B?ODNUK01zZVlXU0cvaVhXZjh3bG9QZEVxblRXWWQ5ZFMwNGRoMW9FdVl6MlI5?=
 =?utf-8?B?TmY2QUczOW9RVE1teWRGLytpU1VuUTErL1BnanpqSUdETVdEbGVUQ29mZjBM?=
 =?utf-8?B?MDZIVTc0WHhvZHVpcU1QREZoelh3K3NCN3U5SU5MUFBWU0FySGlZdlcrVjNm?=
 =?utf-8?B?UWFETkVzaWQxcEtPVUtmbTFiSzJuM0c5SUp0TFJTelNqMkF1NHZUcGlaaitz?=
 =?utf-8?B?TGl2Y25ZT3FCK2FmandjZTdGVzc5ZkZPanl4cFJlSWpwYm95dTFvTC9hTVhK?=
 =?utf-8?B?MlRxYnhZQWlsKzBDQUpCR2MxUGh2MlFmTHN4cmF2Mi9JS3Y1eHM3aVo4alVU?=
 =?utf-8?B?N3pWaWpEUUlHQkRQa3pXQjB5U0treUN1MmJyRndFZGw0OFpRNjR6R0M4cTds?=
 =?utf-8?B?MVY0YXFwU3ZiQUJYVVN1OGFGZGI2dTNhbXg3bEtPbVY3OTdabUxJdEttdE9a?=
 =?utf-8?B?cVdGYytvQ2ZNVVpsZ0hoZnpXZzFVVk1VRjNMQk4vcU5yVTZLMytneHZDbkRk?=
 =?utf-8?B?WWpGR21xRXJkRGtkMi9XcnhwSm5LQzVNTDE0ZS9WQWpxMlVIRlV0QVBtdklu?=
 =?utf-8?B?K1J5eEZ5QTdzUUx5U29YUlMxWXJnTTRwSkRmRElITWVoYXI1aHV1a3dxeFpG?=
 =?utf-8?B?b0Q5MWo0VVdrMGRPQ3hST2I4K21zdm5jK2RkTmlNb0lMbkZNK0FtT2N1S3ZK?=
 =?utf-8?B?NnB3clYxdDVja3B2WWM3UzJES0tySE5qa2NxUldoSGwrMHVwUTdPOEoxVUhV?=
 =?utf-8?B?MUFRcVdOdnNYUEt1cWNrakVBeUJYZXVBS3RhR3preFNOL3RLdGRIcngxeENa?=
 =?utf-8?B?dW5pc3dBV1E2aFZ0c01PbnczcEZvNVFFdSt4ZDBIUG42MEdSMk5qazM0MUVJ?=
 =?utf-8?B?T3hvMEVzajlTZllDMXA5SVNhdXA1T2FwNGN0dXFrS3N5ZjRHNFYrcEVmc2Jq?=
 =?utf-8?B?YWRZSGtOZUgrRUNvNUxpeDBnYzExbTZPOFU1K1FyaVd3V2YzODJyVnZqbW0r?=
 =?utf-8?B?US93amVkTjhvTnVES0FHcVczY1V4aDRHY3MyMGNjeHhuTUN4bWtpSkNibGp2?=
 =?utf-8?B?V1JJd0lWSVlaaDA4ZVNaRnJ0bW45bjZscGUzemFPTkJ0eVFzcVN5U0xXUTFo?=
 =?utf-8?B?OXBJaEVRQmVDek11M2JISUVBQXBWSHZkZXhHV0NQeGFLOTM1VTliNytwN2J4?=
 =?utf-8?B?dzJzZzlGdjNSYlI5a0lKc3gwZ3VTY0t1UlhWTkZhRVpIWVNaVXJHK1ZDQTBN?=
 =?utf-8?B?cjZZb082T0FPYTJVQnBIRnByQVpjZ0VrUW8vNGVQY3lrWm9VYzEwMTc2L1VS?=
 =?utf-8?B?d1hHS01TZjM3Mm1EYUt6dmVJalE0OTRUYUROTVVTbmZuM1BPNDhPcE10Wi9x?=
 =?utf-8?B?YmR6VzJmNHNZQ2hLU21MeHo3TnRQRkZHRUV1bUVoNTBCZ3dmQ3pFLzJGNTg4?=
 =?utf-8?Q?AlwTCr6FyIQ2a?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2R4dC95ZDIwbU1vWXp2SC83NHF4TTFOUkdZSEpqVkVFQmZPcWgvaE96dVBI?=
 =?utf-8?B?NlJNWmlHZ2pGby9oMFRGMmJDYmc0YnI5WEUvR1N6K3pBUXRQT244aFJzVFBI?=
 =?utf-8?B?cjgzWnA5em8zN1BTYlFSNmJQS0FsdUpwMC9BZ2pKWEpmeEZmY0QvdkxlakVx?=
 =?utf-8?B?OXppdFFrbHNPeDU4K2tDV1JoazVLQUNIRmVlR2p2U0hHSVowUE9aUjlHZjBP?=
 =?utf-8?B?ZkhvMDZrRHF1TElxbE1tQm1MVGFNd0R3Q2Q5TlJ3N0VmY1lTa3gxZ3lOQVFK?=
 =?utf-8?B?ZEhiSXJaWkpnWnRUT1d6SFRaVC9xeklYTW13VzVTeGJPS3FHby9UL3k0S2RS?=
 =?utf-8?B?U29UWXQzMk1uL1NjdjNDWjVhNDRPNlBFcXZROHZrK1hoQmdoMHRFeDBFamg4?=
 =?utf-8?B?VE5DRHMwaHlMYW5iL3hveG5YYmtRbXlhVmNxczBEa0wrZ1dxSjFqTzYrRFZE?=
 =?utf-8?B?WW0xN1pLem00R2JhSFlUc3hmbUhxQTE5QUdranRjK2IwRjVWYnRva1hVQVVq?=
 =?utf-8?B?dXZVanVMN3BxY0dTL3cwYjRGUktEN3h2bVFRem5ySWJwaVA2NFFyV3Zlblha?=
 =?utf-8?B?UFF3cnN1ZDdLWmtkK1BuOS9KNHVJcUtLc0MzQzIraHZPelNIazU2RUZ6TGRN?=
 =?utf-8?B?L2tWSHZPZ0Ird3UwRjh2WkZtMkdSWFUzSDRBWTJXRElHaS92cnJNZ2ZWcE9K?=
 =?utf-8?B?SmlyTlo2VUd4Q0NPcHR5MnlMN1UycFF6N1lLNlVVQXNGLzFYeE9yZWpMVzlr?=
 =?utf-8?B?MFhqWkh1Q1d4SllLNTVMZVdna1hEcnBBQ3lWV2pSTHpzVjQ3cWNPSWxQMkhY?=
 =?utf-8?B?VUpaZDI5ckVBeUxwUFh2eXd2YWo3ZkR4TGk3dFdHZVpVcVZ4YTJlRzZqVG9x?=
 =?utf-8?B?QnNVNFFCVy96ajkzZU41VEN2ZHFtN2E2UTZPNzJJT05aazJVL0ZxdnMxS2Vt?=
 =?utf-8?B?V3FPdmVMU3BGTkNFZWp1Z3NGWk5NMWh1T3doSnZGTVhPc2xuNVRlVW5oQ1gy?=
 =?utf-8?B?L1BQeit2VWsrSmRZOTFNaEhnNWZDdEhoY1FxSHZXWGR6VWM1UnpBNzM1L2V1?=
 =?utf-8?B?WTQwdnpmKzJGWkxJUkx4TktKeFMxeUcrR0pqQjlsdUdIOFp1VS9CM3VESUVU?=
 =?utf-8?B?ZGtWSVMxd3kxdDMvOWtMNE1iSVFwQkpVZ1lZSURKK2hhTCtHUCtGMEFqalFv?=
 =?utf-8?B?VERCM1Z6eFNCa240NWlDNXY3RnFaMDd2eS9HQTJPcFRsdG9pVFY0cFNEekJJ?=
 =?utf-8?B?QXNFdEZqUyt0SzJvMWRRUEV5RXZhVEw4aXRjRFlkSFk1VGIvQjVuRkFucXVC?=
 =?utf-8?B?Q2xCeEQ3ZGhIV21PZHdkRXBwT0VwNG1lYm9LS1ZpSkNJTzZaRENsSmlRZFRZ?=
 =?utf-8?B?TE9YU0tTNncrS21SVVN2dU1XVENJMmQ1T3hmcmRUSE1wOVdWUE4zcGVPaUxI?=
 =?utf-8?B?MXB5U2RaZ2Fnb0N0NmFRMEhqMEplY1lEckJvNzNRRGkzZXA5a28vbU1SUkZD?=
 =?utf-8?B?ZksrbERSVThGTWlySFk0dWNJTnBYRGhsRzhYZXJqbFFmbEp0SjNCaE9TeW1G?=
 =?utf-8?B?bytOdkF0YUw4ZFo4d2lRbjRDQUVsN21HZWsxOVA1MDFnODZVZnQ5Q1lUMnAv?=
 =?utf-8?B?d3RCOE5Pakx3a21Zc1gyZzlISU1WSHEyTkNtTTVERnluN0FvMmtqQU84S2tr?=
 =?utf-8?B?eFRTM1c4aUowNE1Sdy9Ma2l0S0VNY09GekZVQUdUQzlqZ0hoaXhSN3FSVGds?=
 =?utf-8?B?VDBwUDVxSVkyQVYrYUd5ci9ycmVmb1NGSHdNbVprVytTWE5YL1FCR04zdVNl?=
 =?utf-8?B?aGRYRVlLbUd5WExsSzhVQ0tENVhhYXgraWVVSXVNKzN0YWxaaGEybE1CTXFl?=
 =?utf-8?B?ZmxoZG5DRXFGRGVTRG1GWllLMUEvY0hBV0xoSStLSVpzQ0ZDVlA4TkJzZWNV?=
 =?utf-8?B?VjZwR2k5Z3RSeUxyWExkRUg1YzZUWXo1S0hiTDh2WGFNa0RSZnZZcHI2UXlr?=
 =?utf-8?B?a2tsYS9uMGk3N1VkZHFlU3hoUnphb3FzSFZGTkZ4bkxReGNwYTdRR01jNURy?=
 =?utf-8?B?cnlsUyswaEdXcjYrTzZXTmRyQjZySldlenpkZnJDVWIzYjE2MG15NGpFNDMw?=
 =?utf-8?B?ZmVmb05BdVVqZFVpQlVGeWFpamFVYVZicUovZWd5NENwMUFZVUFLZ2hMc2VX?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lA7PVvAnWO7movoHMTsOFUwFcGHLF5DjTIB6DEKO41gSN7c83/s43fBnnjbcLaeXej4WjvTPSTUjy9SLuDQYVrZL60ZwoCcFvpHWIOhzwwTQxom2Bi5NqCkkGV2/XS/s+o5ICEajbuOHl3wMot6tXa4jSloZC4i97/Pyqrstn+Tbl0ArnL6cxX0WFqTvTALSMiIdl8EzA9DErCEXbX8K2rPDkJ6a+/plNJ9ZpKBXxvfGqvamOD/jZQALbhQewm/ZqUij195VJkqXfGng5iIrN9kfjgp2TxZKPGkM17V5vGaLPE6DxTKGCPK2QBPLwfh/rtb4264Ysk/A/xsUWLfQgRmz/JMYzxt771zwrEH14RowTDL8xtblYk8Qe8M/EwXOGycaQwYichsObf+1/IGyL8OHHGmBbxq4MsOVKfTr5Z0gpr5R3BvgN54Q30Dql11sV3BIqXsNeYD0nfyi5m+c7uz/cVQ5/N69oTzAfa0YPEgHg+dqztS/h0bA0l1atTHcbIm/cvqzLrM3WsNr6Q6VXI+IhTBKbqE5YYQbO/Udb7/KqqhB9pL1K65SVc1pmDMUEOMZEBypilOB8h/A7YrGA4Pm/5u57Hxv7ZnLMaTvAjA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae9a65c-8660-43f1-46cd-08dd60c54476
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 17:50:53.6865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTG8T7GauUYuWCxalIenkKV9C4r9yahzO38cDgFsB+WYnaYNzHEazDGiIKsFJHPUQqbwJj6TlMKQhXPJQuC2Lo5Go8asCUeG+FRuxsYR5j8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_05,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2503110114
X-Proofpoint-GUID: JxUj6Gs0eDhwyKhn-roC88K8ipgJpD9P
X-Proofpoint-ORIG-GUID: JxUj6Gs0eDhwyKhn-roC88K8ipgJpD9P



On 11/03/25 7:32 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 616 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 13:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
No Problem, seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> thanks,
> 
> greg k-h
> 
Thanks
Vijay
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 5.15.179-rc2
> 
> Jakub Kicinski <kuba@kernel.org>
>      net: ipv6: fix dst refleaks in rpl, seg6 and ioam6 lwtunnels
> 
> Thomas Weißschuh <thomas.weissschuh@linutronix.de>
>      kbuild: userprogs: use correct lld when linking through clang
> 
> Toke Høiland-Jørgensen <toke@redhat.com>
>      sched: sch_cake: add bounds checks to host bulk flow fairness counts
> 
> Michal Luczaj <mhal@rbox.co>
>      vsock: Orphan socket after transport release
> 
> Michal Luczaj <mhal@rbox.co>
>      vsock: Keep the binding until socket destruction
> 
> Michal Luczaj <mhal@rbox.co>
>      bpf, vsock: Invoke proto::close on close()
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Remove dangling pointers
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Fix crash during unbind if gpio unit is in use
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: handle errors that nilfs_prepare_chunk() may return
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: eliminate staggered calls to kunmap in nilfs_rename
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: move page release outside of nilfs_delete_entry and nilfs_set_link
> 
> Ralf Schlatterbeck <rsc@runtux.com>
>      spi-mxs: Fix chipselect glitch
> 
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>      mtd: rawnand: cadence: fix unchecked dereference
> 
> NeilBrown <neilb@suse.de>
>      md: select BLOCK_LEGACY_AUTOLOAD
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Avoid returning invalid controls
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Avoid invalid memory access
> 
> Haoyu Li <lihaoyu499@gmail.com>
>      drivers: virt: acrn: hsm: Use kzalloc to avoid info leak in pmcmd_ioctl
> 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>      eeprom: digsy_mtc: Make GPIO lookup table match the device
> 
> Manivannan Sadhasivam <mani@kernel.org>
>      bus: mhi: host: pci_generic: Use pci_try_reset_function() to avoid deadlock
> 
> Visweswara Tanuku <quic_vtanuku@quicinc.com>
>      slimbus: messaging: Free transaction ID in delayed interrupt scenario
> 
> Alexander Shishkin <alexander.shishkin@linux.intel.com>
>      intel_th: pci: Add Panther Lake-P/U support
> 
> Alexander Shishkin <alexander.shishkin@linux.intel.com>
>      intel_th: pci: Add Panther Lake-H support
> 
> Pawel Chmielewski <pawel.chmielewski@intel.com>
>      intel_th: pci: Add Arrow Lake support
> 
> Alexander Usyskin <alexander.usyskin@intel.com>
>      mei: me: add panther lake P DID
> 
> Phillip Lougher <phillip@squashfs.org.uk>
>      Squashfs: check the inode number is not the invalid value of zero
> 
> Michal Pecio <michal.pecio@gmail.com>
>      usb: xhci: Enable the TRB overfetch quirk on VIA VL805
> 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>      xhci: pci: Fix indentation in the PCI device ID definitions
> 
> Prashanth K <prashanth.k@oss.qualcomm.com>
>      usb: gadget: Check bmAttributes only if configuration is valid
> 
> Marek Szyprowski <m.szyprowski@samsung.com>
>      usb: gadget: Fix setting self-powered state on suspend
> 
> Prashanth K <prashanth.k@oss.qualcomm.com>
>      usb: gadget: Set self-powered based on MaxPower and bmAttributes
> 
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>      usb: typec: tcpci_rt1711h: Unmask alert interrupts to fix functionality
> 
> Fedor Pchelkin <boddah8794@gmail.com>
>      usb: typec: ucsi: increase timeout for PPM reset operations
> 
> Badhri Jagan Sridharan <badhri@google.com>
>      usb: dwc3: gadget: Prevent irq storm when TH re-executes
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>      usb: dwc3: Set SUSPENDENABLE soon after phy init
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      usb: atm: cxacru: fix a flaw in existing endpoint checks
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      usb: renesas_usbhs: Flush the notify_hotplug_work
> 
> Miao Li <limiao@kylinos.cn>
>      usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader
> 
> Pawel Laszczak <pawell@cadence.com>
>      usb: hub: lack of clearing xHC resources
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      usb: renesas_usbhs: Use devm_usb_get_phy()
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      usb: renesas_usbhs: Call clk_put()
> 
> Christian Heusel <christian@heusel.eu>
>      Revert "drivers/card_reader/rtsx_usb: Restore interrupt based detection"
> 
> Fabrizio Castro <fabrizio.castro.jz@renesas.com>
>      gpio: rcar: Fix missing of_node_put() call
> 
> Justin Iurman <justin.iurman@uliege.be>
>      net: ipv6: fix missing dst ref drop in ila lwtunnel
> 
> Justin Iurman <justin.iurman@uliege.be>
>      net: ipv6: fix dst ref loop in ila lwtunnel
> 
> Zecheng Li <zecheng@google.com>
>      sched/fair: Fix potential memory corruption in child_cfs_rq_on_list
> 
> Jason Xing <kerneljasonxing@gmail.com>
>      net-timestamp: support TCP GSO case for a few missing flags
> 
> Namjae Jeon <linkinjeon@kernel.org>
>      exfat: fix soft lockup in exfat_clear_bitmap
> 
> Jarkko Sakkinen <jarkko@kernel.org>
>      x86/sgx: Fix size overflows in sgx_encl_create()
> 
> Reinette Chatre <reinette.chatre@intel.com>
>      x86/sgx: Support VA page allocation without reclaiming
> 
> Reinette Chatre <reinette.chatre@intel.com>
>      x86/sgx: Export sgx_encl_{grow,shrink}()
> 
> Reinette Chatre <reinette.chatre@intel.com>
>      x86/sgx: Move PTE zap code to new sgx_zap_enclave_ptes()
> 
> Reinette Chatre <reinette.chatre@intel.com>
>      x86/sgx: Support loading enclave page without VMA permissions check
> 
> Oscar Maes <oscmaes92@gmail.com>
>      vlan: enforce underlying device type
> 
> Jiayuan Chen <jiayuan.chen@linux.dev>
>      ppp: Fix KMSAN uninit-value warning with bpf
> 
> Peiyang Wang <wangpeiyang1@huawei.com>
>      net: hns3: make sure ptp clock is unregister and freed if hclge_ptp_get_cycle returns an error
> 
> Nikolay Aleksandrov <razor@blackwall.org>
>      be2net: fix sleeping while atomic bugs in be_ndo_bridge_getlink
> 
> Philipp Stanner <phasta@kernel.org>
>      drm/sched: Fix preprocessor guard
> 
> Xinghuo Chen <xinghuo.chen@foxmail.com>
>      hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()
> 
> Eric Dumazet <edumazet@google.com>
>      llc: do not use skb_get() before dev_queue_xmit()
> 
> Murad Masimov <m.masimov@mt-integration.ru>
>      ALSA: usx2y: validate nrpacks module parameter on probe
> 
> Erik Schumacher <erik.schumacher@iris-sensing.com>
>      hwmon: (ad7314) Validate leading zero bits and return error
> 
> Maud Spierings <maudspierings@gocontroll.com>
>      hwmon: (ntc_thermistor) Fix the ncpXXxh103 sensor table
> 
> Titus Rwantare <titusr@google.com>
>      hwmon: (pmbus) Initialise page count in pmbus_identify()
> 
> Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
>      caif_virtio: fix wrong pointer check in cfv_probe()
> 
> Antoine Tenart <atenart@kernel.org>
>      net: gso: fix ownership in __udp_gso_segment
> 
> Meir Elisha <meir.elisha@volumez.com>
>      nvmet-tcp: Fix a possible sporadic response drops in weakly ordered arch
> 
> Zhang Lixu <lixu.zhang@intel.com>
>      HID: intel-ish-hid: Fix use-after-free issue in ishtp_hid_remove()
> 
> Yu-Chun Lin <eleanor15x@gmail.com>
>      HID: google: fix unused variable warning under !CONFIG_ACPI
> 
> Johannes Berg <johannes.berg@intel.com>
>      wifi: iwlwifi: limit printed string from FW file
> 
> Ryan Roberts <ryan.roberts@arm.com>
>      mm: don't skip arch_sync_kernel_mappings() in error paths
> 
> Hao Zhang <zhanghao1@kylinos.cn>
>      mm/page_alloc: fix uninitialized variable
> 
> Olivier Gayot <olivier.gayot@canonical.com>
>      block: fix conversion of GPT partition name to 7-bit
> 
> Heiko Carstens <hca@linux.ibm.com>
>      s390/traps: Fix test_monitor_call() inline assembly
> 
> Haoxiang Li <haoxiang_li2024@163.com>
>      rapidio: fix an API misues when rio_add_net() fails
> 
> Haoxiang Li <haoxiang_li2024@163.com>
>      rapidio: add check for rio_add_net() in rio_scan_alloc_net()
> 
> Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
>      wifi: nl80211: reject cooked mode if it is set along with other flags
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      wifi: cfg80211: regulatory: improve invalid hints checking
> 
> Ahmed S. Darwish <darwi@linutronix.de>
>      x86/cpu: Properly parse CPUID leaf 0x2 TLB descriptor 0x63
> 
> Ahmed S. Darwish <darwi@linutronix.de>
>      x86/cpu: Validate CPUID leaf 0x2 EDX output
> 
> Ahmed S. Darwish <darwi@linutronix.de>
>      x86/cacheinfo: Validate CPUID leaf 0x2 EDX output
> 
> Mingcong Bai <jeffbai@aosc.io>
>      platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e
> 
> Richard Thier <u9vata@gmail.com>
>      drm/radeon: Fix rs400_gpu_init for ATI mobility radeon Xpress 200M
> 
> Kailang Yang <kailang@realtek.com>
>      ALSA: hda/realtek: update ALC222 depop optimize
> 
> Hoku Ishibe <me@hokuishi.be>
>      ALSA: hda: intel: Add Dell ALC3271 to power_save denylist
> 
> Koichiro Den <koichiro.den@canonical.com>
>      gpio: aggregator: protect driver attr handlers against module unload
> 
> Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>      gpio: rcar: Use raw_spinlock to protect register access
> 
> Daniil Dulov <d.dulov@aladdin.ru>
>      HID: appleir: Fix potential NULL dereference at raw event handle
> 
> Rob Herring (Arm) <robh@kernel.org>
>      Revert "of: reserved-memory: Fix using wrong number of cells to get property 'alignment'"
> 
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu: disable BAR resize on Dell G5 SE
> 
> Ma Jun <Jun.Ma2@amd.com>
>      drm/amdgpu: Check extended configuration space register when system uses large bar
> 
> Haoxiang Li <haoxiang_li2024@163.com>
>      smb: client: Add check for next_buffer in receive_encrypted_standard()
> 
> Quang Le <quanglex97@gmail.com>
>      pfifo_tail_enqueue: Drop new packet when sch->limit == 0
> 
> Thomas Gleixner <tglx@linutronix.de>
>      intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly
> 
> Thomas Gleixner <tglx@linutronix.de>
>      sched/core: Prevent rescheduling when interrupts are disabled
> 
> Ard Biesheuvel <ardb@kernel.org>
>      vmlinux.lds: Ensure that const vars with relocations are mapped R/O
> 
> Paolo Abeni <pabeni@redhat.com>
>      mptcp: always handle address removal under msk socket lock
> 
> Kaustabh Chakraborty <kauschluss@disroot.org>
>      phy: exynos5-usbdrd: fix MPLL_MULTIPLIER and SSC_REFCLKSEL masks in refclk
> 
> BH Hsieh <bhsieh@nvidia.com>
>      phy: tegra: xusb: reset VBUS & ID OVERRIDE
> 
> Wei Fang <wei.fang@nxp.com>
>      net: enetc: correct the xdp_tx statistics
> 
> Wei Fang <wei.fang@nxp.com>
>      net: enetc: update UDP checksum when updating originTimestamp field
> 
> Wei Fang <wei.fang@nxp.com>
>      net: enetc: fix the off-by-one issue in enetc_map_tx_buffs()
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      usbnet: gl620a: fix endpoint checking in genelink_bind()
> 
> Tyrone Ting <kfting@nuvoton.com>
>      i2c: npcm: disable interrupt enable bit before devm_request_irq
> 
> Roman Li <Roman.Li@amd.com>
>      drm/amd/display: Fix HPD after gpu reset
> 
> Kan Liang <kan.liang@linux.intel.com>
>      perf/core: Fix low freq setting via IOC_PERIOD
> 
> Dmitry Panchenko <dmitry@d-systems.ee>
>      ALSA: usb-audio: Re-add sample rate quirk for Pioneer DJM-900NXS2
> 
> Nikolay Kuratov <kniv@yandex-team.ru>
>      ftrace: Avoid potential division by zero in function_stat_show()
> 
> Russell Senior <russell@personaltelco.net>
>      x86/CPU: Fix warm boot hang regression on AMD SC1100 SoC systems
> 
> Justin Iurman <justin.iurman@uliege.be>
>      net: ipv6: fix dst ref loop on input in rpl lwt
> 
> Justin Iurman <justin.iurman@uliege.be>
>      net: ipv6: rpl_iptunnel: mitigate 2-realloc issue
> 
> Justin Iurman <justin.iurman@uliege.be>
>      net: ipv6: fix dst ref loop on input in seg6 lwt
> 
> Justin Iurman <justin.iurman@uliege.be>
>      net: ipv6: seg6_iptunnel: mitigate 2-realloc issue
> 
> Justin Iurman <justin.iurman@uliege.be>
>      include: net: add static inline dst_dev_overhead() to dst.h
> 
> Andrea Mayer <andrea.mayer@uniroma2.it>
>      seg6: add support for SRv6 H.L2Encaps.Red behavior
> 
> Andrea Mayer <andrea.mayer@uniroma2.it>
>      seg6: add support for SRv6 H.Encaps.Red behavior
> 
> Shay Drory <shayd@nvidia.com>
>      net/mlx5: IRQ, Fix null string in debug print
> 
> Harshal Chaudhari <hchaudhari@marvell.com>
>      net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.
> 
> Wang Hai <wanghai38@huawei.com>
>      tcp: Defer ts_recent changes until req is owned
> 
> Philo Lu <lulie@linux.alibaba.com>
>      ipvs: Always clear ipvs_property flag in skb_scrub_packet()
> 
> Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
>      ASoC: es8328: fix route from DAC to output
> 
> Sean Anderson <sean.anderson@linux.dev>
>      net: cadence: macb: Synchronize stats calculations
> 
> Ido Schimmel <idosch@nvidia.com>
>      net: loopback: Avoid sending IP packets without an Ethernet header
> 
> David Howells <dhowells@redhat.com>
>      afs: Fix the server_list to unuse a displaced server rather than putting it
> 
> David Howells <dhowells@redhat.com>
>      afs: Make it possible to find the volumes that are using a server
> 
> Colin Ian King <colin.i.king@gmail.com>
>      afs: remove variable nr_servers
> 
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>      Bluetooth: L2CAP: Fix L2CAP_ECRED_CONN_RSP response
> 
> Takashi Iwai <tiwai@suse.de>
>      ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports
> 
> Arnd Bergmann <arnd@arndb.de>
>      sunrpc: suppress warnings for unused procfs functions
> 
> Patrisious Haddad <phaddad@nvidia.com>
>      RDMA/mlx5: Fix bind QP error cleanup flow
> 
> Ye Bin <yebin10@huawei.com>
>      scsi: core: Clear driver private data when retrying request
> 
> Christoph Hellwig <hch@lst.de>
>      scsi: core: Don't memset() the entire scsi_cmnd in scsi_init_command()
> 
> Vasiliy Kovalev <kovalev@altlinux.org>
>      ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up
> 
> Christian Brauner <brauner@kernel.org>
>      ovl: pass ofs to creation operations
> 
> Amir Goldstein <amir73il@gmail.com>
>      ovl: use wrappers to all vfs_*xattr() calls
> 
> Mark Zhang <markzhang@nvidia.com>
>      IB/mlx5: Set and get correct qp_num for a DCT QP
> 
> Patrick Bellasi <derkling@google.com>
>      x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit
> 
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>      mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
> 
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>      mtd: rawnand: cadence: use dma_map_resource for sdma address
> 
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>      mtd: rawnand: cadence: fix error code in cadence_nand_init()
> 
> Christian Brauner <brauner@kernel.org>
>      acct: block access to kernel internal filesystems
> 
> Christian Brauner <brauner@kernel.org>
>      acct: perform last write from workqueue
> 
> John Veness <john-linux@pelago.org.uk>
>      ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED
> 
> Haoxiang Li <haoxiang_li2024@163.com>
>      nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
> 
> Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
>      drop_monitor: fix incorrect initialization order
> 
> Sumit Garg <sumit.garg@linaro.org>
>      tee: optee: Fix supplicant wait loop
> 
> Yan Zhai <yan@cloudflare.com>
>      bpf: skip non exist keys in generic_map_lookup_batch
> 
> Caleb Sander Mateos <csander@purestorage.com>
>      nvme/ioctl: add missing space in err message
> 
> Andrey Vatoropin <a.vatoropin@crpt.ru>
>      power: supply: da9150-fg: fix potential overflow
> 
> Breno Leitao <leitao@debian.org>
>      arp: switch to dev_getbyhwaddr() in arp_req_set_public()
> 
> Breno Leitao <leitao@debian.org>
>      net: Add non-RCU dev_getbyhwaddr() helper
> 
> Cong Wang <xiyou.wangcong@gmail.com>
>      flow_dissector: Fix port range key handling in BPF conversion
> 
> Cong Wang <xiyou.wangcong@gmail.com>
>      flow_dissector: Fix handling of mixed port and port-range keys
> 
> Maksym Glubokiy <maksym.glubokiy@plvision.eu>
>      net: extract port range fields from fl_flow_key
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>      geneve: Suppress list corruption splat in geneve_destroy_tunnels().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>      gtp: Suppress list corruption splat in gtp_net_exit_batch_rtnl().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>      geneve: Fix use-after-free in geneve_find_dev().
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>      powerpc/code-patching: Fix KASAN hit by not flagging text patching area as VM_ALLOC
> 
> Kailang Yang <kailang@realtek.com>
>      ALSA: hda/realtek: Fixup ALC225 depop procedure
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>      powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline
> 
> Michael Ellerman <mpe@ellerman.id.au>
>      powerpc/64s/mm: Move __real_pte stubs into hash-4k.h
> 
> Jill Donahue <jilliandonahue58@gmail.com>
>      USB: gadget: f_midi: f_midi_complete to call queue_work
> 
> Selvarasu Ganesan <selvarasu.g@samsung.com>
>      usb: dwc3: Fix timeout issue during controller enter/exit from halt state
> 
> Wesley Cheng <quic_wcheng@quicinc.com>
>      usb: dwc3: Increase DWC3 controller halt timeout
> 
> Sven Eckelmann <sven@narfation.org>
>      batman-adv: Drop unmanaged ELP metric worker
> 
> Sven Eckelmann <sven@narfation.org>
>      batman-adv: Drop initialization of flexible ethtool_link_ksettings
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Only save async fh if success
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Refactor iterators
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Set error_idx during ctrl_commit errors
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      soc/mediatek: mtk-devapc: Convert to platform remove callback returning void
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      soc: mediatek: mtk-devapc: Fix leaking IO map on error paths
> 
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>      soc: mediatek: mtk-devapc: Switch to devm_clk_get_enabled()
> 
> Marco Elver <elver@google.com>
>      kfence: skip __GFP_THISNODE allocations on NUMA systems
> 
> huangshaobo <huangshaobo6@huawei.com>
>      kfence: enable check kfence canary on panic via boot param
> 
> Marco Elver <elver@google.com>
>      kfence: allow use of a deferrable timer
> 
> Jarkko Sakkinen <jarkko@kernel.org>
>      tpm: Change to kvalloc() in eventlog/acpi.c
> 
> Eddie James <eajames@linux.ibm.com>
>      tpm: Use managed allocation for bios event log
> 
> Chen-Yu Tsai <wenst@chromium.org>
>      arm64: dts: mediatek: mt8183: Disable DSI display output by default
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      ASoC: renesas: rz-ssi: Add a check for negative sample_space
> 
> Thomas Zimmermann <tzimmermann@suse.de>
>      drm/rockchip: cdn-dp: Use drm_connector_helper_hpd_irq_event()
> 
> Maxime Ripard <maxime@cerno.tech>
>      drm/probe-helper: Create a HPD IRQ event helper for a single connector
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      ksmbd: fix integer overflows on 32 bit systems
> 
> Chen Ridong <chenridong@huawei.com>
>      memcg: fix soft lockup in the OOM process
> 
> Carlos Galo <carlosgalo@google.com>
>      mm: update mark_victim tracepoints fields
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      media: imx-jpeg: Fix potential error pointer dereference in detach_pm()
> 
> Ignat Korchagin <ignat@cloudflare.com>
>      crypto: testmgr - some more fixes to RSA test vectors
> 
> Ignat Korchagin <ignat@cloudflare.com>
>      crypto: testmgr - populate RSA CRT parameters in RSA test vectors
> 
> lei he <helei.sig11@bytedance.com>
>      crypto: testmgr - fix version number of RSA tests
> 
> Lei He <helei.sig11@bytedance.com>
>      crypto: testmgr - Fix wrong test case of RSA
> 
> Lei He <helei.sig11@bytedance.com>
>      crypto: testmgr - fix wrong key length for pkcs1pad
> 
> Catalin Marinas <catalin.marinas@arm.com>
>      arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings
> 
> Calvin Owens <calvin@wbinvd.org>
>      pps: Fix a use-after-free
> 
> Filipe Manana <fdmanana@suse.com>
>      btrfs: avoid monopolizing a core when activating a swap file
> 
> Koichiro Den <koichiro.den@canonical.com>
>      Revert "btrfs: avoid monopolizing a core when activating a swap file"
> 
> David Woodhouse <dwmw@amazon.co.uk>
>      x86/i8253: Disable PIT timer 0 when not in use
> 
> Chao Yu <chao@kernel.org>
>      f2fs: fix to wait dio completion
> 
> Romain Naour <romain.naour@skf.com>
>      ARM: dts: dra7: Add bus_dma_limit for l4 cfg bus
> 
> Hangbin Liu <liuhangbin@gmail.com>
>      selftests: rtnetlink: update netdevsim ipsec output format
> 
> Hangbin Liu <liuhangbin@gmail.com>
>      netdevsim: print human readable IP address
> 
> Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
>      parport_pc: add support for ASIX AX99100
> 
> Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
>      serial: 8250_pci: add support for ASIX AX99100
> 
> Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
>      can: ems_pci: move ASIX AX99100 ids to pci_ids.h
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: protect access to buffers with no active references
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: do not force clear folio if buffer is referenced
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: do not output warnings when clearing dirty buffers
> 
> Ivan Kokshaysky <ink@unseen.parts>
>      alpha: replace hardcoded stack offsets with autogenerated ones
> 
> Andrew Cooper <andrew.cooper3@citrix.com>
>      x86/static-call: Remove early_boot_irqs_disabled check to fix Xen PVH dom0
> 
> John Ogness <john.ogness@linutronix.de>
>      kdb: Do not assume write() callback available
> 
> Christian Gmeiner <cgmeiner@igalia.com>
>      drm/v3d: Stop active perfmon if it is being destroyed
> 
> Devarsh Thakkar <devarsht@ti.com>
>      drm/tidss: Clear the interrupt status for interrupts being disabled
> 
> Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
>      drm/tidss: Fix issue in irq handling causing irq-flood issue
> 
> Eric Dumazet <edumazet@google.com>
>      ipv6: mcast: add RCU protection to mld_newpack()
> 
> Eric Dumazet <edumazet@google.com>
>      ndisc: extend RCU protection in ndisc_send_skb()
> 
> Eric Dumazet <edumazet@google.com>
>      openvswitch: use RCU protection in ovs_vport_cmd_fill_info()
> 
> Eric Dumazet <edumazet@google.com>
>      arp: use RCU protection in arp_xmit()
> 
> Eric Dumazet <edumazet@google.com>
>      neighbour: use RCU protection in __neigh_notify()
> 
> Li Zetao <lizetao1@huawei.com>
>      neighbour: delete redundant judgment statements
> 
> Eric Dumazet <edumazet@google.com>
>      ndisc: use RCU protection in ndisc_alloc_skb()
> 
> Eric Dumazet <edumazet@google.com>
>      ipv6: use RCU protection in ip6_default_advmss()
> 
> Eric Dumazet <edumazet@google.com>
>      ipv4: use RCU protection in __ip_rt_update_pmtu()
> 
> Vladimir Vdovin <deliran@verdict.gg>
>      net: ipv4: Cache pmtu for all packet paths if multipath enabled
> 
> Guillaume Nault <gnault@redhat.com>
>      selftest: net: Test IPv4 PMTU exceptions with DSCP and ECN
> 
> xu xin <xu.xin16@zte.com.cn>
>      Namespaceify mtu_expires sysctl
> 
> xu xin <xu.xin16@zte.com.cn>
>      Namespaceify min_pmtu sysctl
> 
> Eric Dumazet <edumazet@google.com>
>      ipv4: use RCU protection in inet_select_addr()
> 
> Eric Dumazet <edumazet@google.com>
>      ipv4: use RCU protection in rt_is_expired()
> 
> Eric Dumazet <edumazet@google.com>
>      net: add dev_net_rcu() helper
> 
> Jiri Pirko <jiri@nvidia.com>
>      net: treat possible_net_t net pointer as an RCU one and add read_pnet_rcu()
> 
> Eric Dumazet <edumazet@google.com>
>      ipv4: add RCU protection to ip4_dst_hoplimit()
> 
> Waiman Long <longman@redhat.com>
>      clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context
> 
> Waiman Long <longman@redhat.com>
>      clocksource: Use pr_info() for "Checking clocksource synchronization" message
> 
> Yury Norov <yury.norov@gmail.com>
>      clocksource: Replace cpumask_weight() with cpumask_empty()
> 
> Filipe Manana <fdmanana@suse.com>
>      btrfs: fix hole expansion when writing at an offset beyond EOF
> 
> Wentao Liang <vulab@iscas.ac.cn>
>      mlxsw: Add return value check for mlxsw_sp_port_get_stats_raw()
> 
> Nathan Chancellor <nathan@kernel.org>
>      arm64: Handle .ARM.attributes section in linker scripts
> 
> Jiasheng Jiang <jiashengjiangcool@gmail.com>
>      regmap-irq: Add missing kfree()
> 
> Jann Horn <jannh@google.com>
>      partitions: mac: fix handling of bogus partition table
> 
> Wentao Liang <vulab@iscas.ac.cn>
>      gpio: stmpe: Check return value of stmpe_reg_read in stmpe_gpio_irq_sync_unlock
> 
> Ivan Kokshaysky <ink@unseen.parts>
>      alpha: align stack for page fault and user unaligned trap handlers
> 
> John Keeping <jkeeping@inmusicbrands.com>
>      serial: 8250: Fix fifo underflow on flush
> 
> Shakeel Butt <shakeel.butt@linux.dev>
>      cgroup: fix race between fork and cgroup.kill
> 
> Ard Biesheuvel <ardb@kernel.org>
>      efi: Avoid cold plugged memory for placing the kernel
> 
> Ivan Kokshaysky <ink@unseen.parts>
>      alpha: make stack 16-byte aligned (most cases)
> 
> Alexander Hölzl <alexander.hoelzl@gmx.net>
>      can: j1939: j1939_sk_send_loop(): fix unable to send messages with data length zero
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      can: c_can: fix unbalanced runtime PM disable in error path
> 
> Johan Hovold <johan@kernel.org>
>      USB: serial: option: drop MeiG Smart defines
> 
> Fabio Porcedda <fabio.porcedda@gmail.com>
>      USB: serial: option: fix Telit Cinterion FN990A name
> 
> Fabio Porcedda <fabio.porcedda@gmail.com>
>      USB: serial: option: add Telit Cinterion FN990B compositions
> 
> Chester A. Unal <chester.a.unal@arinc9.com>
>      USB: serial: option: add MeiG Smart SLM828
> 
> Jann Horn <jannh@google.com>
>      usb: cdc-acm: Fix handling of oversized fragments
> 
> Jann Horn <jannh@google.com>
>      usb: cdc-acm: Check control transfer buffer size before access
> 
> Marek Vasut <marek.vasut+renesas@mailbox.org>
>      USB: cdc-acm: Fill in Renesas R-Car D3 USB Download mode quirk
> 
> Alan Stern <stern@rowland.harvard.edu>
>      USB: hub: Ignore non-compliant devices with too many configs or interfaces
> 
> John Keeping <jkeeping@inmusicbrands.com>
>      usb: gadget: f_midi: fix MIDI Streaming descriptor lengths
> 
> Mathias Nyman <mathias.nyman@linux.intel.com>
>      USB: Add USB_QUIRK_NO_LPM quirk for sony xperia xz1 smartphone
> 
> Lei Huang <huanglei@kylinos.cn>
>      USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist
> 
> Stefan Eichenberger <stefan.eichenberger@toradex.com>
>      usb: core: fix pipe creation for get_bMaxPacketSize0
> 
> Huacai Chen <chenhuacai@kernel.org>
>      USB: pci-quirks: Fix HCCPARAMS register error for LS7A EHCI
> 
> Fabrice Gasnier <fabrice.gasnier@foss.st.com>
>      usb: dwc2: gadget: remove of_node reference upon udc_stop
> 
> Guo Ren <guoren@linux.alibaba.com>
>      usb: gadget: udc: renesas_usb3: Fix compiler warning
> 
> Elson Roy Serrao <quic_eserrao@quicinc.com>
>      usb: roles: set switch registered flag early on
> 
> Sean Christopherson <seanjc@google.com>
>      perf/x86/intel: Ensure LBRs are disabled when a CPU is starting
> 
> Sean Christopherson <seanjc@google.com>
>      KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local APIC isn't in-kernel
> 
> Sven Eckelmann <sven@narfation.org>
>      batman-adv: Ignore neighbor throughput metrics in error case
> 
> Andy Strohman <andrew@andrewstrohman.com>
>      batman-adv: fix panic during interface removal
> 
> Hans de Goede <hdegoede@redhat.com>
>      ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet 5V
> 
> Mike Marshall <hubcap@omnibond.com>
>      orangefs: fix a oob in orangefs_debug_write
> 
> Rik van Riel <riel@fb.com>
>      x86/mm/tlb: Only trim the mm_cpumask once a second
> 
> Maksym Planeta <maksym@exostellar.io>
>      Grab mm lock before grabbing pt lock
> 
> Ramesh Thomas <ramesh.thomas@intel.com>
>      vfio/pci: Enable iowrite64 and ioread64 for vfio pci
> 
> Takashi Iwai <tiwai@suse.de>
>      PCI/DPC: Quirk PIO log size for Intel Raptor Lake-P
> 
> Edward Adam Davis <eadavis@qq.com>
>      media: vidtv: Fix a null-ptr-deref in vidtv_mux_stop_thread
> 
> Arnd Bergmann <arnd@arndb.de>
>      media: cxd2841er: fix 64-bit division on gcc-9
> 
> Juergen Gross <jgross@suse.com>
>      x86/xen: allow larger contiguous memory regions in PV guests
> 
> Petr Tesarik <petr.tesarik.ext@huawei.com>
>      xen: remove a confusing comment on auto-translated guest I/O
> 
> Artur Weber <aweber.kernel@gmail.com>
>      gpio: bcm-kona: Add missing newline to dev_err format string
> 
> Artur Weber <aweber.kernel@gmail.com>
>      gpio: bcm-kona: Make sure GPIO bits are unlocked when requesting IRQ
> 
> Artur Weber <aweber.kernel@gmail.com>
>      gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0
> 
> Krzysztof Karas <krzysztof.karas@intel.com>
>      drm/i915/selftests: avoid using uninitialized context
> 
> Radu Rendec <rrendec@redhat.com>
>      arm64: cacheinfo: Avoid out-of-bounds write to cacheinfo array
> 
> Eric Dumazet <edumazet@google.com>
>      team: better TEAM_OPTION_TYPE_STRING validation
> 
> Eric Dumazet <edumazet@google.com>
>      vrf: use RCU protection in l3mdev_l3_out()
> 
> Eric Dumazet <edumazet@google.com>
>      ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
> 
> Charles Han <hanchunchao@inspur.com>
>      HID: multitouch: Add NULL check in mt_input_configured
> 
> Dai Ngo <dai.ngo@oracle.com>
>      NFSD: fix hang in nfsd4_shutdown_callback
> 
> Li Lingfeng <lilingfeng3@huawei.com>
>      nfsd: clear acl_access/acl_default after releasing them
> 
> Sean Anderson <sean.anderson@linux.dev>
>      tty: xilinx_uartps: split sysrq handling
> 
> Paolo Abeni <pabeni@redhat.com>
>      mptcp: prevent excessive coalescing on receive
> 
> Su Yue <glass.su@suse.com>
>      ocfs2: check dir i_size in ocfs2_find_entry
> 
> Dmitry Osipenko <digetx@gmail.com>
>      memory: tegra20-emc: Correct memory device mask
> 
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>      gpio: xilinx: remove excess kernel doc
> 
> Paul Fertser <fercerpav@gmail.com>
>      net/ncsi: use dev_set_mac_address() for Get MC MAC Address handling
> 
> WangYuli <wangyuli@uniontech.com>
>      MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static
> 
> Thomas Weißschuh <linux@weissschuh.net>
>      ptp: Ensure info->enable callback is always set
> 
> Milos Reljin <milos_reljin@outlook.com>
>      net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset
> 
> Paul Fertser <fercerpav@gmail.com>
>      net/ncsi: wait for the last response to Deselect Package before configuring channel
> 
> Ekansh Gupta <quic_ekangupt@quicinc.com>
>      misc: fastrpc: Fix registered buffer page address
> 
> Ivan Stepchenko <sid@itb.spb.ru>
>      mtd: onenand: Fix uninitialized retlen in do_otp_read()
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      NFC: nci: Add bounds checking in nci_hci_create_pipe()
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      nilfs2: fix possible int overflows in nilfs_fiemap()
> 
> Matthew Wilcox (Oracle) <willy@infradead.org>
>      ocfs2: handle a symlink read error correctly
> 
> Heming Zhao <heming.zhao@suse.com>
>      ocfs2: fix incorrect CPU endianness conversion causing mount failure
> 
> Mike Snitzer <snitzer@kernel.org>
>      pnfs/flexfiles: retry getting layout segment for reads
> 
> Alex Williamson <alex.williamson@redhat.com>
>      vfio/platform: check the bounds of read/write syscalls
> 
> Jennifer Berringer <jberring@redhat.com>
>      nvmem: core: improve range check for nvmem_cell_write()
> 
> Luca Weiss <luca.weiss@fairphone.com>
>      nvmem: qcom-spmi-sdam: Set size in struct nvmem_config
> 
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>      crypto: qce - unregister previously registered algos in error path
> 
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>      crypto: qce - fix goto jump in error path
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Remove redundant NULL assignment
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Fix event flags in uvc_ctrl_send_events
> 
> Mehdi Djait <mehdi.djait@linux.intel.com>
>      media: ccs: Fix cleanup order in ccs_probe()
> 
> Sakari Ailus <sakari.ailus@linux.intel.com>
>      media: ccs: Fix CCS static data parsing for large block sizes
> 
> Sam Bobrowicz <sam@elite-embedded.com>
>      media: ov5640: fix get_light_freq on auto
> 
> Cosmin Tanislav <demonsingur@gmail.com>
>      media: mc: fix endpoint iteration
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      soc: qcom: smem_state: fix missing of_node_put in error path
> 
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>      iio: light: as73211: fix channel handling in only-color triggered buffer
> 
> Sakari Ailus <sakari.ailus@linux.intel.com>
>      media: ccs: Clean up parsed CCS static data on parse failure
> 
> Wentao Liang <vulab@iscas.ac.cn>
>      xfs: Add error handling for xfs_reflink_cancel_cow_range
> 
> Eric Biggers <ebiggers@google.com>
>      crypto: qce - fix priority to be less than ARMv8 CE
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      arm64: dts: qcom: sm8350: Fix MPSS memory length
> 
> Nathan Chancellor <nathan@kernel.org>
>      x86/boot: Use '-std=gnu11' to fix build with GCC 15
> 
> Nathan Chancellor <nathan@kernel.org>
>      kbuild: Move -Wenum-enum-conversion to W=2
> 
> Long Li <longli@microsoft.com>
>      scsi: storvsc: Set correct data length for sending SCSI command without payload
> 
> Quinn Tran <qutran@marvell.com>
>      scsi: qla2xxx: Move FCE Trace buffer allocation to user control
> 
> Georg Gottleuber <ggo@tuxedocomputers.com>
>      nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk
> 
> Georg Gottleuber <ggo@tuxedocomputers.com>
>      nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()
> 
> Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
>      ALSA: hda/realtek: Enable headset mic on Positivo C6400
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      Revert "media: uvcvideo: Require entities to have a non-zero unique ID"
> 
> Mateusz Jończyk <mat.jonczyk@o2.pl>
>      mips/math-emu: fix emulation of the prefx instruction
> 
> Hou Tao <houtao1@huawei.com>
>      dm-crypt: track tag_offset in convert_context
> 
> Hou Tao <houtao1@huawei.com>
>      dm-crypt: don't update io->sector after kcryptd_crypt_write_io_submit()
> 
> Narayana Murty N <nnmlinux@linux.ibm.com>
>      powerpc/pseries/eeh: Fix get PE state translation
> 
> Kexy Biscuit <kexybiscuit@aosc.io>
>      MIPS: Loongson64: remove ROM Size unit in boardinfo
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      serial: sh-sci: Do not probe the serial port if its slot in sci_ports[] is in use
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      serial: sh-sci: Drop __initdata macro for port_cfg
> 
> Stephan Gerhold <stephan.gerhold@linaro.org>
>      soc: qcom: socinfo: Avoid out of bounds read of serial number
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>      usb: gadget: f_tcm: Don't prepare BOT write request twice
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>      usb: gadget: f_tcm: ep_autoconfig with fullspeed endpoint
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>      usb: gadget: f_tcm: Decrement command ref count on cleanup
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>      usb: gadget: f_tcm: Translate error to sense
> 
> Marcel Hamer <marcel.hamer@windriver.com>
>      wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()
> 
> Bitterblue Smith <rtl8821cerfe2@gmail.com>
>      wifi: rtlwifi: rtl8821ae: Fix media status report
> 
> Heiko Stuebner <heiko@sntech.de>
>      HID: hid-sensor-hub: don't use stale platform-data on remove
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      of: reserved-memory: Fix using wrong number of cells to get property 'alignment'
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      of: Fix of_find_node_opts_by_path() handling of alias+path+options
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      of: Correct child specifier used as input of the 2nd nexus node
> 
> Kuan-Wei Chiu <visitorckw@gmail.com>
>      perf bench: Fix undefined behavior in cmpworker()
> 
> Nathan Chancellor <nathan@kernel.org>
>      efi: libstub: Use '-std=gnu11' to fix build with GCC 15
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      blk-cgroup: Fix class @block_class's subsystem refcount leakage
> 
> Anastasia Belova <abelova@astralinux.ru>
>      clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
> 
> Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
>      clk: qcom: gcc-mdm9607: Fix cmd_rcgr offset for blsp1_uart6 rcg
> 
> Luca Weiss <luca.weiss@fairphone.com>
>      clk: qcom: gcc-sm6350: Add missing parent_map for two clocks
> 
> Gabor Juhos <j4g8y7@gmail.com>
>      clk: qcom: clk-alpha-pll: fix alpha mode configuration
> 
> Cody Eksal <masterr3c0rd@epochal.quest>
>      clk: sunxi-ng: a100: enable MMC clock reparenting
> 
> Fedor Pchelkin <pchelkin@ispras.ru>
>      Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection
> 
> Fedor Pchelkin <pchelkin@ispras.ru>
>      Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc
> 
> Ville Syrjälä <ville.syrjala@linux.intel.com>
>      drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes
> 
> Haoxiang Li <haoxiang_li2024@163.com>
>      drm/komeda: Add check for komeda_get_layer_fourcc_list()
> 
> Lijo Lazar <lijo.lazar@amd.com>
>      drm/amd/pm: Mark MM activity as unsupported
> 
> David Hildenbrand <david@redhat.com>
>      KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
> 
> Sean Christopherson <seanjc@google.com>
>      KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
> 
> Jakob Unterwurzacher <jakobunt@gmail.com>
>      arm64: dts: rockchip: increase gmac rx_delay on rk3399-puma
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      binfmt_flat: Fix integer overflow bug on 32 bit systems
> 
> Thomas Zimmermann <tzimmermann@suse.de>
>      m68k: vga: Fix I/O defines
> 
> Heiko Carstens <hca@linux.ibm.com>
>      s390/futex: Fix FUTEX_OP_ANDN implementation
> 
> Maarten Lankhorst <dev@lankhorst.se>
>      drm/modeset: Handle tiled displays in pan_display_atomic.
> 
> Alexander Sverdlin <alexander.sverdlin@siemens.com>
>      leds: lp8860: Write full EEPROM, not only half of it
> 
> Viresh Kumar <viresh.kumar@linaro.org>
>      cpufreq: s3c64xx: Fix compilation warning
> 
> Willem de Bruijn <willemb@google.com>
>      tun: revert fix group permission check
> 
> Cong Wang <cong.wang@bytedance.com>
>      netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()
> 
> Juergen Gross <jgross@suse.com>
>      x86/xen: add FRAME_END to xen_hypercall_hvm()
> 
> Juergen Gross <jgross@suse.com>
>      x86/xen: fix xen_hypercall_hvm() to not clobber %rbx
> 
> Eric Dumazet <edumazet@google.com>
>      net: rose: lock the socket in rose_bind()
> 
> Jacob Moroni <mail@jakemoroni.com>
>      net: atlantic: fix warning during hot unplug
> 
> Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
>      gpio: pca953x: Improve interrupt support
> 
> Yan Zhai <yan@cloudflare.com>
>      udp: gso: do not drop small packets when PMTU reduces
> 
> Lenny Szubowicz <lszubowi@redhat.com>
>      tg3: Disable tg3 PCIe AER on system reboot
> 
> Hans Verkuil <hverkuil@xs4all.nl>
>      gpu: drm_dp_cec: fix broken CEC adapter properties check
> 
> Prasad Pandit <pjp@fedoraproject.org>
>      firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry
> 
> Daniel Wagner <wagi@kernel.org>
>      nvme: handle connectivity loss in nvme_set_queue_count
> 
> Michal Pecio <michal.pecio@gmail.com>
>      usb: xhci: Fix NULL pointer dereference on certain command aborts
> 
> Hardik Gajjar <hgajjar@de.adit-jv.com>
>      usb: xhci: Add timeout argument in address_device USB HCD callback
> 
> Darrick J. Wong <djwong@kernel.org>
>      xfs: don't over-report free space or inodes in statvfs
> 
> Darrick J. Wong <djwong@kernel.org>
>      xfs: report realtime block quota limits on realtime directories
> 
> Sean Anderson <sean.anderson@linux.dev>
>      gpio: xilinx: Convert gpio_lock to raw spinlock
> 
> Paul Fertser <fercerpav@gmail.com>
>      net/ncsi: fix locking in Get MAC Address handling
> 
> Peter Delevoryas <peter@pjd.dev>
>      net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      usb: chipidea/ci_hdrc_imx: Convert to platform remove callback returning void
> 
> Alexander Stein <alexander.stein@ew.tq-group.com>
>      usb: chipidea: ci_hdrc_imx: use dev_err_probe()
> 
> Xi Ruoyao <xry111@xry111.site>
>      x86/mm: Don't disable PCID when INVLPG has been fixed by microcode
> 
> Armin Wolf <W_Armin@gmx.de>
>      platform/x86: acer-wmi: Ignore AC events
> 
> Illia Ostapyshyn <illia@yshyn.com>
>      Input: allocate keycode for phone linking
> 
> Liu Ye <liuye@kylinos.cn>
>      selftests/net/ipsec: Fix Null pointer dereference in rtattr_pack()
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      tipc: re-order conditions in tipc_crypto_key_rcv()
> 
> Yuanjie Yang <quic_yuanjiey@quicinc.com>
>      mmc: sdhci-msm: Correctly set the load for the regulator
> 
> Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>      net: wwan: iosm: Fix hibernation by re-binding the driver around it
> 
> Borislav Petkov <bp@alien8.de>
>      APEI: GHES: Have GHES honor the panic= setting
> 
> Randolph Ha <rha051117@gmail.com>
>      i2c: Force ELAN06FA touchpad I2C bus freq to 100KHz
> 
> Miri Korenblit <miriam.rachel.korenblit@intel.com>
>      wifi: iwlwifi: avoid memory leak
> 
> Vadim Fedorenko <vadfed@meta.com>
>      net/mlx5: use do_aux_work for PHC overflow checks
> 
> Even Xu <even.xu@intel.com>
>      HID: Wacom: Add PCI Wacom device support
> 
> Hans de Goede <hdegoede@redhat.com>
>      mfd: lpc_ich: Add another Gemini Lake ISA bridge PCI device-id
> 
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>      tomoyo: don't emit warning in tomoyo_write_control()
> 
> Dmitry Antipov <dmantipov@yandex.ru>
>      wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()
> 
> Shawn Lin <shawn.lin@rock-chips.com>
>      mmc: core: Respect quirk_max_rate for non-UHS SDIO card
> 
> Stas Sergeev <stsp2@yandex.ru>
>      tun: fix group permission check
> 
> Leo Stone <leocstone@gmail.com>
>      safesetid: check size of policy writes
> 
> Kuan-Wei Chiu <visitorckw@gmail.com>
>      printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
> 
> Yazen Ghannam <yazen.ghannam@amd.com>
>      x86/amd_nb: Restrict init function to AMD-based systems
> 
> Carlos Llamas <cmllamas@google.com>
>      lockdep: Fix upper limit for LOCKDEP_*_BITS configs
> 
> Suleiman Souhlal <suleiman@google.com>
>      sched: Don't try to catch up excess steal time.
> 
> Josef Bacik <josef@toxicpanda.com>
>      btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling
> 
> Hao-ran Zheng <zhenghaoran154@gmail.com>
>      btrfs: fix data race when accessing the inode's disk_i_size at btrfs_drop_extents()
> 
> Filipe Manana <fdmanana@suse.com>
>      btrfs: fix use-after-free when attempting to join an aborted transaction
> 
> Qu Wenruo <wqu@suse.com>
>      btrfs: output the reason for open_ctree() failure
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>      usb: gadget: f_tcm: Don't free command immediately
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>      media: uvcvideo: Fix double free in error path
> 
> Paolo Abeni <pabeni@redhat.com>
>      mptcp: consolidate suboption status
> 
> Kyle Tso <kyletso@google.com>
>      usb: typec: tcpci: Prevent Sink disconnection before vPpsShutdown in SPR PPS
> 
> Jos Wang <joswang@lenovo.com>
>      usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE
> 
> Kyle Tso <kyletso@google.com>
>      usb: dwc3: core: Defer the probe until USB power supply ready
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>      usb: gadget: f_tcm: Fix Get/SetInterface return value
> 
> Sean Rhodes <sean@starlabs.systems>
>      drivers/card_reader/rtsx_usb: Restore interrupt based detection
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      net: usb: rtl8150: enable basic endpoint checking
> 
> Lianqin Hu <hulianqin@vivo.com>
>      ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro
> 
> Ricardo B. Marliere <rbm@suse.com>
>      ktest.pl: Check kernelrelease return in get_version
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>      netfilter: nf_tables: reject mismatching sum of field_len with set key length
> 
> Chuck Lever <chuck.lever@oracle.com>
>      NFSD: Reset cb_seq_status after NFS4ERR_DELAY
> 
> Daniel Lee <chullee@google.com>
>      f2fs: Introduce linear search for dentries
> 
> Lin Yujun <linyujun809@huawei.com>
>      hexagon: Fix unbalanced spinlock in die()
> 
> Willem de Bruijn <willemb@google.com>
>      hexagon: fix using plain integer as NULL pointer warning in cmpxchg
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      kconfig: fix memory leak in sym_warn_unmet_dep()
> 
> Sergey Senozhatsky <senozhatsky@chromium.org>
>      kconfig: WERROR unmet symbol dependency
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      kconfig: deduplicate code in conf_read_simple()
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      kconfig: remove unused code for S_DEF_AUTO in conf_read_simple()
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      kconfig: require a space after '#' for valid input
> 
> Sergey Senozhatsky <senozhatsky@chromium.org>
>      kconfig: add warn-unknown-symbols sanity check
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      genksyms: fix memory leak when the same symbol is read from *.symref file
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      genksyms: fix memory leak when the same symbol is added from source
> 
> Eric Dumazet <edumazet@google.com>
>      net: hsr: fix fill_frame_info() regression vs VLAN packets
> 
> Kory Maincent <kory.maincent@bootlin.com>
>      net: sh_eth: Fix missing rtnl lock in suspend/resume path
> 
> Rafał Miłecki <rafal@milecki.pl>
>      bgmac: reduce max frame size to support just MTU 1500
> 
> Michal Luczaj <mhal@rbox.co>
>      vsock: Allow retrying on connect() failure
> 
> Howard Chu <howardchu95@gmail.com>
>      perf trace: Fix runtime error of index out of bounds
> 
> Thomas Weißschuh <linux@weissschuh.net>
>      ptp: Properly handle compat ioctls
> 
> Chenyuan Yang <chenyuan0y@gmail.com>
>      net: davicom: fix UAF in dm9000_drv_remove
> 
> Jakub Kicinski <kuba@kernel.org>
>      net: netdevsim: try to close UDP port harness races
> 
> Eric Dumazet <edumazet@google.com>
>      net: rose: fix timer races against user threads
> 
> Wentao Liang <vulab@iscas.ac.cn>
>      PM: hibernate: Add error handling for syscore_suspend()
> 
> Eric Dumazet <edumazet@google.com>
>      ipmr: do not call mr_mfc_uses_dev() for unres entries
> 
> Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
>      net: fec: implement TSO descriptor cleanup
> 
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>      gpio: mxc: remove dead code after switch to DT-only
> 
> Jian Shen <shenjian15@huawei.com>
>      net: hns3: fix oops when unload drivers paralleling
> 
> pangliyuan <pangliyuan1@huawei.com>
>      ubifs: skip dumping tnc tree when zroot is null
> 
> Oleksij Rempel <linux@rempel-privat.de>
>      rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      dmaengine: ti: edma: fix OF node reference leaks in edma_driver
> 
> Jianbo Liu <jianbol@nvidia.com>
>      xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO
> 
> Luo Yifan <luoyifan@cmss.chinamobile.com>
>      tools/bootconfig: Fix the wrong format specifier
> 
> Olga Kornievskaia <okorniev@redhat.com>
>      NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE
> 
> Olga Kornievskaia <okorniev@redhat.com>
>      NFSv4.2: fix COPY_NOTIFY xdr buf size calculation
> 
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>      module: Extend the preempt disabled section in dereference_symbol_descriptor().
> 
> Su Yue <glass.su@suse.com>
>      ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
> 
> Guixin Liu <kanie@linux.alibaba.com>
>      scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
> 
> Paul Menzel <pmenzel@molgen.mpg.de>
>      scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
> 
> King Dix <kingdix10@qq.com>
>      PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      mtd: hyperbus: hbmc-am654: fix an OF node reference leak
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      mtd: hyperbus: hbmc-am654: Convert to platform remove callback returning void
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      mtd: hyperbus: Make hyperbus_unregister_device() return void
> 
> Ricardo Ribalda <ribalda@chromium.org>
>      media: uvcvideo: Propagate buf->error to userspace
> 
> Jiasheng Jiang <jiashengjiangcool@gmail.com>
>      media: camif-core: Add check for clk_enable()
> 
> Jiasheng Jiang <jiashengjiangcool@gmail.com>
>      media: mipi-csis: Add check for clk_enable()
> 
> Dave Stevenson <dave.stevenson@raspberrypi.com>
>      media: i2c: ov9282: Correct the exposure offset
> 
> Luca Weiss <luca.weiss@fairphone.com>
>      media: i2c: imx412: Add missing newline to prints
> 
> Jiasheng Jiang <jiashengjiangcool@gmail.com>
>      media: marvell: Add check for clk_enable()
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()
> 
> Chen Ni <nichen@iscas.ac.cn>
>      media: lmedm04: Handle errors for lme2510_int_read
> 
> Oliver Neukum <oneukum@suse.com>
>      media: rc: iguanair: handle timeouts
> 
> Randy Dunlap <rdunlap@infradead.org>
>      efi: sysfb_efi: fix W=1 warnings when EFI is not set
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      of: reserved-memory: Do not make kmemleak ignore freed address
> 
> Mike Rapoport <rppt@kernel.org>
>      memblock: drop memblock_free_early_nid() and memblock_free_early()
> 
> Mike Rapoport <rppt@kernel.org>
>      xen/x86: free_p2m_page: use memblock_free_ptr() to free a virtual pointer
> 
> Michael Guralnik <michaelgur@nvidia.com>
>      RDMA/mlx5: Fix indirect mkey ODP page count
> 
> Michael Guralnik <michaelgur@nvidia.com>
>      RDMA/mlx5: Enforce umem boundaries for explicit ODP page faults
> 
> Aharon Landau <aharonl@nvidia.com>
>      RDMA/mlx5: Remove iova from struct mlx5_core_mkey
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
> 
> Rafał Miłecki <rafal@milecki.pl>
>      ARM: dts: mediatek: mt7623: fix IR nodename
> 
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>      arm64: dts: qcom: sdm845: Fix interrupt types of camss interrupts
> 
> Neil Armstrong <neil.armstrong@linaro.org>
>      arm64: dts: qcom: sm8150-microsoft-surface-duo: fix typos in da7280 properties
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      arm64: dts: qcom: sm8350: correct sleep clock frequency
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      arm64: dts: qcom: sm8250: correct sleep clock frequency
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      arm64: dts: qcom: sm6125: correct sleep clock frequency
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      arm64: dts: qcom: sc7280: correct sleep clock frequency
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      arm64: dts: qcom: msm8994: correct sleep clock frequency
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      arm64: dts: qcom: msm8916: correct sleep clock frequency
> 
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>      arm64: dts: qcom: msm8994: Describe USB interrupts
> 
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>      arm64: dts: qcom: msm8996: Fix up USB3 interrupts
> 
> Chen-Yu Tsai <wenst@chromium.org>
>      arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage settings
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      memory: tegra20-emc: fix an OF node reference bug in tegra_emc_find_node_by_ram_code()
> 
> Dmitry Osipenko <digetx@gmail.com>
>      memory: tegra20-emc: Support matching timings by LPDDR2 configuration
> 
> Dmitry Osipenko <digetx@gmail.com>
>      memory: Add LPDDR2-info helpers
> 
> Hsin-Te Yuan <yuanhsinte@chromium.org>
>      arm64: dts: mediatek: mt8183: willow: Support second source touchscreen
> 
> Hsin-Te Yuan <yuanhsinte@chromium.org>
>      arm64: dts: mediatek: mt8183: kenzo: Support second source touchscreen
> 
> Chen-Yu Tsai <wenst@chromium.org>
>      arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
> 
> Chen-Yu Tsai <wenst@chromium.org>
>      arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names
> 
> Chen-Yu Tsai <wenst@chromium.org>
>      arm64: dts: mediatek: mt8173-elm: Drop regulator-compatible property
> 
> Chen-Yu Tsai <wenst@chromium.org>
>      arm64: dts: mediatek: mt8173-evb: Drop regulator-compatible property
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      rdma/cxgb4: Prevent potential integer overflow on 32bit
> 
> Leon Romanovsky <leon@kernel.org>
>      RDMA/mlx4: Avoid false error about access to uninitialized gids array
> 
> Val Packett <val@packett.cool>
>      arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A
> 
> Val Packett <val@packett.cool>
>      arm64: dts: mediatek: mt8516: add i2c clock-div property
> 
> Fabien Parent <fparent@baylibre.com>
>      arm64: dts: mediatek: mt8516: remove 2 invalid i2c clocks
> 
> Val Packett <val@packett.cool>
>      arm64: dts: mediatek: mt8516: fix wdt irq type
> 
> Val Packett <val@packett.cool>
>      arm64: dts: mediatek: mt8516: fix GICv2 range
> 
> Hsin-Yi Wang <hsinyi@chromium.org>
>      arm64: dts: mt8183: set DMIC one-wire mode on Damu
> 
> Nicolas Ferre <nicolas.ferre@microchip.com>
>      ARM: at91: pm: change BU Power Switch to automatic mode
> 
> Chen Ridong <chenridong@huawei.com>
>      padata: avoid UAF for reorder_work
> 
> Chen Ridong <chenridong@huawei.com>
>      padata: add pd get/put refcnt helper
> 
> Chen Ridong <chenridong@huawei.com>
>      padata: fix UAF in padata_reorder
> 
> Puranjay Mohan <puranjay@kernel.org>
>      bpf: Send signals asynchronously if !preemptible
> 
> Jiachen Zhang <me@jcix.top>
>      perf report: Fix misleading help message about --demangle
> 
> Arnaldo Carvalho de Melo <acme@redhat.com>
>      perf top: Don't complain about lack of vmlinux when not resolving some kernel samples
> 
> Thomas Weißschuh <linux@weissschuh.net>
>      padata: fix sysfs store callback check
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()
> 
> Wenkai Lin <linwenkai6@hisilicon.com>
>      crypto: hisilicon/sec2 - fix for aead invalid authsize
> 
> Wenkai Lin <linwenkai6@hisilicon.com>
>      crypto: hisilicon/sec2 - fix for aead icv error
> 
> Chenghai Huang <huangchenghai2@huawei.com>
>      crypto: hisilicon/sec2 - optimize the error return process
> 
> Kai Ye <yekai13@huawei.com>
>      crypto: hisilicon/sec - delete redundant blank lines
> 
> Kai Ye <yekai13@huawei.com>
>      crypto: hisilicon/sec - add some comments for soft fallback
> 
> Ba Jing <bajing@cmss.chinamobile.com>
>      ktest.pl: Remove unused declarations in run_bisect_test function
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      ASoC: renesas: rz-ssi: Use only the proper amount of dividers
> 
> Zhongqiu Han <quic_zhonhan@quicinc.com>
>      perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_prog_info()
> 
> Zhongqiu Han <quic_zhonhan@quicinc.com>
>      perf header: Fix one memory leakage in process_bpf_prog_info()
> 
> Zhongqiu Han <quic_zhonhan@quicinc.com>
>      perf header: Fix one memory leakage in process_bpf_btf()
> 
> George Lander <lander@jagmn.com>
>      ASoC: sun4i-spdif: Add clock multiplier settings
> 
> Quentin Monnet <qmo@kernel.org>
>      libbpf: Fix segfault due to libelf functions not setting errno
> 
> Marco Leogrande <leogrande@google.com>
>      tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      net/rose: prevent integer overflows in rose_setsockopt()
> 
> Mahdi Arghavani <ma.arghavani@yahoo.com>
>      tcp_cubic: fix incorrect HyStart round start detection
> 
> Roger Quadros <rogerq@kernel.org>
>      net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()
> 
> Florian Westphal <fw@strlen.de>
>      netfilter: nft_flow_offload: update tcp state flags under lock
> 
> Jamal Hadi Salim <jhs@mojatatu.com>
>      net: sched: Disallow replacing of child qdisc from one parent to another
> 
> Antoine Tenart <atenart@kernel.org>
>      net: avoid race between device unregistration and ethnl ops
> 
> Maher Sanalla <msanalla@nvidia.com>
>      net/mlxfw: Drop hard coded max FW flash image size
> 
> Liu Jian <liujian56@huawei.com>
>      net: let net.core.dev_weight always be non-zero
> 
> Mickaël Salaün <mic@digikod.net>
>      selftests/landlock: Fix error message
> 
> Bo Gan <ganboing@gmail.com>
>      clk: analogbits: Fix incorrect calculation of vco rate delta
> 
> Dmitry Antipov <dmantipov@yandex.ru>
>      wifi: cfg80211: adjust allocation of colocated AP data
> 
> Ilan Peer <ilan.peer@intel.com>
>      wifi: cfg80211: Handle specific BSSID in 6GHz scanning
> 
> Dmitry V. Levin <ldv@strace.io>
>      selftests: harness: fix printing of mismatch values in __EXPECT()
> 
> Gautham R. Shenoy <gautham.shenoy@amd.com>
>      cpufreq: ACPI: Fix max-frequency computation
> 
> WangYuli <wangyuli@uniontech.com>
>      wifi: mt76: mt76u_vendor_request: Do not print error messages when -EPROTO
> 
> Mickaël Salaün <mic@digikod.net>
>      landlock: Handle weird files
> 
> Mickaël Salaün <mic@digikod.net>
>      landlock: Move filesystem helpers and add a new one
> 
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>      net/smc: fix data error when recvmsg with MSG_PEEK flag
> 
> Andreas Kemnade <andreas@kemnade.info>
>      wifi: wlcore: fix unbalanced pm_runtime calls
> 
> Zichen Xie <zichenxie0106@gmail.com>
>      samples/landlock: Fix possible NULL dereference in parse_path()
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      regulator: of: Implement the unwind path of of_regulator_match()
> 
> Octavian Purdila <tavip@google.com>
>      team: prevent adding a device which is already a team device lower
> 
> Marek Vasut <marex@denx.de>
>      clk: imx8mp: Fix clkout1/2 support
> 
> Sultan Alsawaf (unemployed) <sultan@kerneltoast.com>
>      cpufreq: schedutil: Fix superfluous updates caused by need_freq_update
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()
> 
> Matti Vaittinen <mazziesaccount@gmail.com>
>      dt-bindings: mfd: bd71815: Fix rsense and typos
> 
> He Rongguang <herongguang@linux.alibaba.com>
>      cpupower: fix TSC MHz calculation
> 
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>      ACPI: fan: cleanup resources in the error path of .probe()
> 
> Chen-Yu Tsai <wenst@chromium.org>
>      regulator: dt-bindings: mt6315: Drop regulator-compatible property
> 
> Jiri Kosina <jkosina@suse.com>
>      HID: multitouch: fix support for Goodix PID 0x01e9
> 
> Jiri Kosina <jkosina@suse.com>
>      Revert "HID: multitouch: Add support for lenovo Y9000P Touchpad"
> 
> He Lugang <helugang@uniontech.com>
>      HID: multitouch: Add support for lenovo Y9000P Touchpad
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: pci: wait for firmware loading before releasing memory
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: fix memory leaks and invalid access at probe error path
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: destroy workqueue at rtl_deinit_core
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: remove unused check_buddy_priv
> 
> Dmitry Antipov <dmantipov@yandex.ru>
>      wifi: rtlwifi: remove unused dualmac control leftovers
> 
> Dmitry Antipov <dmantipov@yandex.ru>
>      wifi: rtlwifi: remove unused timer and related code
> 
> Jakob Koschel <jakobkoschel@gmail.com>
>      rtlwifi: replace usage of found with dedicated list iterator variable
> 
> Geert Uytterhoeven <geert+renesas@glider.be>
>      dt-bindings: leds: class-multicolor: Fix path to color definitions
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      dt-bindings: leds: class-multicolor: reference class directly in multi-led node
> 
> Sven Schwermer <sven.schwermer@disruptive-technologies.com>
>      dt-bindings: leds: Add multicolor PWM LED bindings
> 
> Sven Schwermer <sven.schwermer@disruptive-technologies.com>
>      dt-bindings: leds: Optional multi-led unit address
> 
> Bjorn Andersson <bjorn.andersson@linaro.org>
>      dt-bindings: leds: Add Qualcomm Light Pulse Generator binding
> 
> Rob Herring <robh@kernel.org>
>      dt-bindings: Another pass removing cases of 'allOf' containing a '$ref'
> 
> Pratyush Yadav <p.yadav@ti.com>
>      spi: dt-bindings: add schema listing peripheral-specific properties
> 
> Neil Armstrong <neil.armstrong@linaro.org>
>      dt-bindings: mmc: controller: clarify the address-cells description
> 
> Mingwei Zheng <zmw12306@gmail.com>
>      spi: zynq-qspi: Add check for clk_enable()
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: usb: fix workqueue leak when probe fails
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: fix init_sw_vars leak when probe fails
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: wait for firmware loading before releasing memory
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      wifi: rtlwifi: do not complete firmware loading needlessly
> 
> Charles Han <hanchunchao@inspur.com>
>      ipmi: ipmb: Add check devm_kasprintf() returned value
> 
> Thomas Gleixner <tglx@linutronix.de>
>      genirq: Make handle_enforce_irqctx() unconditionally available
> 
> Ivan Stepchenko <sid@itb.spb.ru>
>      drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table
> 
> Alan Stern <stern@rowland.harvard.edu>
>      HID: core: Fix assumption that Resolution Multipliers must be in Logical Collections
> 
> Sui Jingfeng <sui.jingfeng@linux.dev>
>      drm/etnaviv: Fix page property being used for non writecombine buffers
> 
> Peter Zijlstra <peterz@infradead.org>
>      sched/fair: Fix value reported by hot tasks pulled in /proc/schedstat
> 
> Chengming Zhou <zhouchengming@bytedance.com>
>      sched/psi: Use task->psi_flags to clear in CPU migration
> 
> David Howells <dhowells@redhat.com>
>      afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>      select: Fix unbalanced user_access_end()
> 
> Randy Dunlap <rdunlap@infradead.org>
>      partitions: ldm: remove the initial kernel-doc notation
> 
> Keisuke Nishimura <keisuke.nishimura@inria.fr>
>      nvme: Add error check for xa_store in nvme_get_effects_log
> 
> Eugen Hristev <eugen.hristev@linaro.org>
>      pstore/blk: trivial typo fixes
> 
> Yu Kuai <yukuai3@huawei.com>
>      nbd: don't allow reconnect after disconnect
> 
> Yang Erkun <yangerkun@huawei.com>
>      block: retry call probe after request_module in blk_request_module
> 
> Christoph Hellwig <hch@lst.de>
>      block: deprecate autoloading based on dev_t
> 
> Jinliang Zheng <alexjlzheng@gmail.com>
>      fs: fix proc_handler for sysctl_nr_open
> 
> Luis Chamberlain <mcgrof@kernel.org>
>      fs: move fs stat sysctls to file_table.c
> 
> Luis Chamberlain <mcgrof@kernel.org>
>      fs: move inode sysctls to its own file
> 
> Luis Chamberlain <mcgrof@kernel.org>
>      sysctl: share unsigned long const values
> 
> Xiaoming Ni <nixiaoming@huawei.com>
>      sysctl: use const for typically used max/min proc sysctls
> 
> Xiaoming Ni <nixiaoming@huawei.com>
>      hung_task: move hung_task sysctl interface to hung_task.c
> 
> David Howells <dhowells@redhat.com>
>      afs: Fix directory format encoding struct
> 
> David Howells <dhowells@redhat.com>
>      afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
> 
> 
> -------------
> 
> Diffstat:
> 
>   Documentation/dev-tools/kfence.rst                 |  12 ++
>   .../bindings/connector/usb-connector.yaml          |   3 +-
>   .../bindings/display/brcm,bcm2711-hdmi.yaml        |   3 +-
>   .../bindings/display/bridge/adi,adv7511.yaml       |   5 +-
>   .../bindings/display/bridge/synopsys,dw-hdmi.yaml  |   5 +-
>   .../bindings/display/panel/display-timings.yaml    |   3 +-
>   .../devicetree/bindings/display/ste,mcde.yaml      |   4 +-
>   .../devicetree/bindings/input/adc-joystick.yaml    |   9 +-
>   .../bindings/leds/cznic,turris-omnia-leds.yaml     |   5 +-
>   .../bindings/leds/leds-class-multicolor.yaml       |  28 +--
>   .../devicetree/bindings/leds/leds-lp50xx.yaml      |   5 +-
>   .../bindings/leds/leds-pwm-multicolor.yaml         |  78 +++++++
>   .../devicetree/bindings/leds/leds-qcom-lpg.yaml    | 175 ++++++++++++++++
>   .../devicetree/bindings/mfd/google,cros-ec.yaml    |  12 +-
>   .../devicetree/bindings/mfd/rohm,bd71815-pmic.yaml |  20 +-
>   .../devicetree/bindings/mmc/mmc-controller.yaml    |   2 +-
>   .../bindings/mtd/rockchip,nand-controller.yaml     |   3 +-
>   .../devicetree/bindings/net/ti,cpsw-switch.yaml    |   3 +-
>   .../devicetree/bindings/phy/phy-stm32-usbphyc.yaml |   3 +-
>   .../bindings/power/supply/sbs,sbs-manager.yaml     |   4 +-
>   .../bindings/regulator/mt6315-regulator.yaml       |   6 -
>   .../bindings/remoteproc/ti,k3-r5f-rproc.yaml       |   3 +-
>   .../devicetree/bindings/soc/ti/ti,pruss.yaml       |  15 +-
>   .../devicetree/bindings/sound/st,stm32-sai.yaml    |   3 +-
>   .../devicetree/bindings/sound/tlv320adcx140.yaml   |  13 +-
>   .../devicetree/bindings/spi/spi-controller.yaml    |  69 +------
>   .../bindings/spi/spi-peripheral-props.yaml         |  87 ++++++++
>   .../devicetree/bindings/usb/st,stusb160x.yaml      |   4 +-
>   Documentation/kbuild/kconfig.rst                   |   9 +
>   Makefile                                           |   9 +-
>   arch/alpha/include/uapi/asm/ptrace.h               |   2 +
>   arch/alpha/kernel/asm-offsets.c                    |   2 +
>   arch/alpha/kernel/entry.S                          |  24 +--
>   arch/alpha/kernel/traps.c                          |   2 +-
>   arch/alpha/mm/fault.c                              |   4 +-
>   arch/arm/boot/dts/dra7-l4.dtsi                     |   2 +
>   arch/arm/boot/dts/mt7623.dtsi                      |   2 +-
>   arch/arm/mach-at91/pm.c                            |  31 ++-
>   arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi       |  29 +--
>   arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |  25 +--
>   .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |   4 +
>   .../dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts    |  15 ++
>   .../dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi  |  15 ++
>   .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |   2 -
>   arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   1 +
>   arch/arm64/boot/dts/mediatek/mt8516.dtsi           |  38 ++--
>   arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   2 -
>   arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
>   arch/arm64/boot/dts/qcom/msm8994.dtsi              |  11 +-
>   arch/arm64/boot/dts/qcom/msm8996.dtsi              |   9 +-
>   arch/arm64/boot/dts/qcom/sc7280.dtsi               |   2 +-
>   arch/arm64/boot/dts/qcom/sdm845.dtsi               |  20 +-
>   arch/arm64/boot/dts/qcom/sm6125.dtsi               |   2 +-
>   .../boot/dts/qcom/sm8150-microsoft-surface-duo.dts |   4 +-
>   arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
>   arch/arm64/boot/dts/qcom/sm8350.dtsi               |   4 +-
>   arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   2 +-
>   arch/arm64/include/asm/mman.h                      |   9 +-
>   arch/arm64/kernel/cacheinfo.c                      |  12 +-
>   arch/arm64/kernel/vdso/vdso.lds.S                  |   1 +
>   arch/arm64/kernel/vmlinux.lds.S                    |   1 +
>   arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
>   arch/hexagon/kernel/traps.c                        |   4 +-
>   arch/m68k/include/asm/vga.h                        |   8 +-
>   arch/mips/kernel/ftrace.c                          |   2 +-
>   arch/mips/loongson64/boardinfo.c                   |   2 -
>   arch/mips/math-emu/cp1emu.c                        |   2 +-
>   arch/mips/mm/init.c                                |   2 +-
>   arch/powerpc/include/asm/book3s/64/hash-4k.h       |  28 +++
>   arch/powerpc/include/asm/book3s/64/pgtable.h       |  26 ---
>   arch/powerpc/lib/code-patching.c                   |   2 +-
>   arch/powerpc/platforms/pseries/eeh_pseries.c       |   6 +-
>   arch/powerpc/platforms/pseries/svm.c               |   3 +-
>   arch/s390/include/asm/futex.h                      |   2 +-
>   arch/s390/kernel/smp.c                             |   2 +-
>   arch/s390/kernel/traps.c                           |   6 +-
>   arch/s390/kvm/vsie.c                               |  25 ++-
>   arch/x86/Kconfig                                   |   3 +-
>   arch/x86/boot/compressed/Makefile                  |   1 +
>   arch/x86/events/intel/core.c                       |   5 +-
>   arch/x86/include/asm/mmu.h                         |   2 +
>   arch/x86/include/asm/mmu_context.h                 |   1 +
>   arch/x86/include/asm/msr-index.h                   |   3 +-
>   arch/x86/include/asm/tlbflush.h                    |   1 +
>   arch/x86/kernel/amd_nb.c                           |   4 +
>   arch/x86/kernel/cpu/bugs.c                         |  20 +-
>   arch/x86/kernel/cpu/cacheinfo.c                    |   2 +-
>   arch/x86/kernel/cpu/cyrix.c                        |   4 +-
>   arch/x86/kernel/cpu/intel.c                        |  52 +++--
>   arch/x86/kernel/cpu/sgx/encl.c                     | 108 ++++++++--
>   arch/x86/kernel/cpu/sgx/encl.h                     |   8 +-
>   arch/x86/kernel/cpu/sgx/ioctl.c                    |  17 +-
>   arch/x86/kernel/cpu/sgx/main.c                     |  31 +--
>   arch/x86/kernel/i8253.c                            |  11 +-
>   arch/x86/kernel/static_call.c                      |   1 -
>   arch/x86/kvm/hyperv.c                              |   6 +-
>   arch/x86/mm/init.c                                 |  23 ++-
>   arch/x86/mm/tlb.c                                  |  35 +++-
>   arch/x86/xen/mmu_pv.c                              |  79 +++++--
>   arch/x86/xen/p2m.c                                 |   2 +-
>   arch/x86/xen/xen-head.S                            |   5 +-
>   block/Kconfig                                      |  12 ++
>   block/bdev.c                                       |   9 +-
>   block/blk-cgroup.c                                 |   1 +
>   block/genhd.c                                      |  30 ++-
>   block/partitions/efi.c                             |   2 +-
>   block/partitions/ldm.h                             |   2 +-
>   block/partitions/mac.c                             |  18 +-
>   crypto/testmgr.h                                   | 227 ++++++++++++++------
>   drivers/acpi/apei/ghes.c                           |  10 +-
>   drivers/acpi/fan.c                                 |  10 +-
>   drivers/base/arch_numa.c                           |   2 +-
>   drivers/base/regmap/regmap-irq.c                   |   2 +
>   drivers/block/nbd.c                                |   1 +
>   drivers/bus/mhi/host/pci_generic.c                 |   5 +-
>   drivers/char/ipmi/ipmb_dev_int.c                   |   3 +
>   drivers/char/tpm/eventlog/acpi.c                   |  16 +-
>   drivers/char/tpm/eventlog/efi.c                    |  13 +-
>   drivers/char/tpm/eventlog/of.c                     |   3 +-
>   drivers/char/tpm/tpm-chip.c                        |   1 -
>   drivers/clk/analogbits/wrpll-cln28hpc.c            |   2 +-
>   drivers/clk/imx/clk-imx8mp.c                       |   5 +-
>   drivers/clk/qcom/clk-alpha-pll.c                   |   2 +
>   drivers/clk/qcom/clk-rpmh.c                        |   2 +-
>   drivers/clk/qcom/gcc-mdm9607.c                     |   2 +-
>   drivers/clk/qcom/gcc-sm6350.c                      |  22 +-
>   drivers/clk/sunxi-ng/ccu-sun50i-a100.c             |   6 +-
>   drivers/clocksource/i8253.c                        |  13 +-
>   drivers/cpufreq/acpi-cpufreq.c                     |  36 +++-
>   drivers/cpufreq/s3c64xx-cpufreq.c                  |  11 +-
>   drivers/crypto/hisilicon/sec2/sec.h                |   3 +-
>   drivers/crypto/hisilicon/sec2/sec_crypto.c         | 178 ++++++++--------
>   drivers/crypto/hisilicon/sec2/sec_crypto.h         |  11 -
>   drivers/crypto/ixp4xx_crypto.c                     |   3 +
>   drivers/crypto/qce/aead.c                          |   2 +-
>   drivers/crypto/qce/core.c                          |  13 +-
>   drivers/crypto/qce/sha.c                           |   2 +-
>   drivers/crypto/qce/skcipher.c                      |   2 +-
>   drivers/dma/ti/edma.c                              |   3 +-
>   drivers/firmware/Kconfig                           |   2 +-
>   drivers/firmware/efi/efi.c                         |   6 +-
>   drivers/firmware/efi/libstub/Makefile              |   2 +-
>   drivers/firmware/efi/libstub/randomalloc.c         |   3 +
>   drivers/firmware/efi/libstub/relocate.c            |   3 +
>   drivers/firmware/efi/sysfb_efi.c                   |   2 +-
>   drivers/gpio/gpio-aggregator.c                     |  20 +-
>   drivers/gpio/gpio-bcm-kona.c                       |  71 +++++--
>   drivers/gpio/gpio-mxc.c                            |   3 +-
>   drivers/gpio/gpio-pca953x.c                        |  19 --
>   drivers/gpio/gpio-rcar.c                           |  31 +--
>   drivers/gpio/gpio-stmpe.c                          |  15 +-
>   drivers/gpio/gpio-xilinx.c                         |  33 ++-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  11 +
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |  14 ++
>   .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   2 +
>   drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   1 -
>   .../drm/arm/display/komeda/komeda_wb_connector.c   |   4 +
>   drivers/gpu/drm/drm_dp_cec.c                       |  14 +-
>   drivers/gpu/drm/drm_fb_helper.c                    |  14 +-
>   drivers/gpu/drm/drm_probe_helper.c                 | 116 ++++++++---
>   drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  16 +-
>   drivers/gpu/drm/i915/display/skl_universal_plane.c |   4 -
>   drivers/gpu/drm/i915/selftests/i915_gem_gtt.c      |   4 +-
>   drivers/gpu/drm/radeon/r300.c                      |   3 +-
>   drivers/gpu/drm/radeon/radeon_asic.h               |   1 +
>   drivers/gpu/drm/radeon/rs400.c                     |  18 +-
>   drivers/gpu/drm/rockchip/cdn-dp-core.c             |   9 +-
>   drivers/gpu/drm/scheduler/gpu_scheduler_trace.h    |   4 +-
>   drivers/gpu/drm/tidss/tidss_dispc.c                |  22 +-
>   drivers/gpu/drm/v3d/v3d_perfmon.c                  |   5 +
>   drivers/hid/hid-appleir.c                          |   2 +-
>   drivers/hid/hid-core.c                             |   2 +
>   drivers/hid/hid-google-hammer.c                    |   2 +
>   drivers/hid/hid-multitouch.c                       |   7 +-
>   drivers/hid/hid-sensor-hub.c                       |  21 +-
>   drivers/hid/intel-ish-hid/ishtp-hid.c              |   4 +-
>   drivers/hid/wacom_wac.c                            |   5 +
>   drivers/hwmon/ad7314.c                             |  10 +
>   drivers/hwmon/ntc_thermistor.c                     |  66 +++---
>   drivers/hwmon/pmbus/pmbus.c                        |   2 +
>   drivers/hwmon/xgene-hwmon.c                        |   2 +-
>   drivers/hwtracing/intel_th/pci.c                   |  15 ++
>   drivers/i2c/busses/i2c-npcm7xx.c                   |   7 +
>   drivers/i2c/i2c-core-acpi.c                        |  22 ++
>   drivers/idle/intel_idle.c                          |   4 +
>   drivers/iio/light/as73211.c                        |  24 ++-
>   drivers/infiniband/hw/cxgb4/device.c               |   6 +-
>   drivers/infiniband/hw/mlx4/main.c                  |   6 +-
>   drivers/infiniband/hw/mlx5/counters.c              |   8 +-
>   drivers/infiniband/hw/mlx5/devx.c                  |   1 -
>   drivers/infiniband/hw/mlx5/mr.c                    |  16 +-
>   drivers/infiniband/hw/mlx5/odp.c                   |  61 +++---
>   drivers/infiniband/hw/mlx5/qp.c                    |   4 +-
>   drivers/leds/leds-lp8860.c                         |   2 +-
>   drivers/leds/leds-netxbig.c                        |   1 +
>   drivers/md/Kconfig                                 |   4 +
>   drivers/md/dm-crypt.c                              |  27 +--
>   drivers/media/dvb-frontends/cxd2841er.c            |   8 +-
>   drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
>   drivers/media/i2c/ccs/ccs-data.c                   |  14 +-
>   drivers/media/i2c/imx412.c                         |  42 ++--
>   drivers/media/i2c/ov5640.c                         |   1 +
>   drivers/media/i2c/ov9282.c                         |   2 +-
>   drivers/media/platform/exynos4-is/mipi-csis.c      |  10 +-
>   drivers/media/platform/imx-jpeg/mxc-jpeg.c         |   7 +-
>   drivers/media/platform/marvell-ccic/mcam-core.c    |   7 +-
>   drivers/media/platform/s3c-camif/camif-core.c      |  13 +-
>   drivers/media/rc/iguanair.c                        |   4 +-
>   drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   8 +-
>   drivers/media/usb/dvb-usb-v2/lmedm04.c             |  12 +-
>   drivers/media/usb/uvc/uvc_ctrl.c                   | 139 ++++++++++---
>   drivers/media/usb/uvc/uvc_driver.c                 | 105 +++++-----
>   drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
>   drivers/media/usb/uvc/uvc_status.c                 |   1 +
>   drivers/media/usb/uvc/uvc_v4l2.c                   |   4 +-
>   drivers/media/usb/uvc/uvcvideo.h                   |  20 +-
>   drivers/media/v4l2-core/v4l2-mc.c                  |   2 +-
>   drivers/memory/jedec_ddr.h                         |  47 +++++
>   drivers/memory/jedec_ddr_data.c                    |  41 ++++
>   drivers/memory/of_memory.c                         |  87 ++++++++
>   drivers/memory/of_memory.h                         |   9 +
>   drivers/memory/tegra/Kconfig                       |   1 +
>   drivers/memory/tegra/tegra20-emc.c                 | 203 ++++++++++++++++--
>   drivers/mfd/lpc_ich.c                              |   3 +-
>   drivers/misc/eeprom/digsy_mtc_eeprom.c             |   2 +-
>   drivers/misc/fastrpc.c                             |   2 +-
>   drivers/misc/mei/hw-me-regs.h                      |   2 +
>   drivers/misc/mei/pci-me.c                          |   2 +
>   drivers/mmc/core/sdio.c                            |   2 +
>   drivers/mmc/host/sdhci-msm.c                       |  53 ++++-
>   drivers/mtd/hyperbus/hbmc-am654.c                  |  29 +--
>   drivers/mtd/hyperbus/hyperbus-core.c               |   8 +-
>   drivers/mtd/hyperbus/rpc-if.c                      |   5 +-
>   drivers/mtd/nand/onenand/onenand_base.c            |   1 +
>   drivers/mtd/nand/raw/cadence-nand-controller.c     |  44 +++-
>   drivers/net/caif/caif_virtio.c                     |   2 +-
>   drivers/net/can/c_can/c_can_platform.c             |   5 +-
>   drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   4 +-
>   drivers/net/ethernet/broadcom/bgmac.h              |   3 +-
>   drivers/net/ethernet/broadcom/tg3.c                |  58 ++++++
>   drivers/net/ethernet/cadence/macb.h                |   2 +
>   drivers/net/ethernet/cadence/macb_main.c           |  12 +-
>   drivers/net/ethernet/davicom/dm9000.c              |   3 +-
>   drivers/net/ethernet/emulex/benet/be.h             |   2 +-
>   drivers/net/ethernet/emulex/benet/be_cmds.c        | 197 +++++++++---------
>   drivers/net/ethernet/emulex/benet/be_main.c        |   2 +-
>   drivers/net/ethernet/freescale/enetc/enetc.c       |  69 +++++--
>   drivers/net/ethernet/freescale/fec_main.c          |  31 ++-
>   drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  15 ++
>   drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +
>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   2 +-
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +
>   drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
>   .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  24 ++-
>   drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   1 -
>   drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   2 +-
>   drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |   2 -
>   .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |   4 +-
>   drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   2 +
>   drivers/net/ethernet/renesas/sh_eth.c              |   4 +
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
>   drivers/net/geneve.c                               |  16 +-
>   drivers/net/gtp.c                                  |   5 -
>   drivers/net/loopback.c                             |  14 ++
>   drivers/net/netdevsim/ipsec.c                      |  12 +-
>   drivers/net/netdevsim/netdevsim.h                  |   1 +
>   drivers/net/netdevsim/udp_tunnels.c                |  23 ++-
>   drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +
>   drivers/net/ppp/ppp_generic.c                      |  28 ++-
>   drivers/net/team/team.c                            |  11 +-
>   drivers/net/tun.c                                  |   2 +-
>   drivers/net/usb/gl620a.c                           |   4 +-
>   drivers/net/usb/rtl8150.c                          |  22 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
>   .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   3 +
>   drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  13 +-
>   drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
>   drivers/net/wireless/mediatek/mt76/usb.c           |   4 +-
>   drivers/net/wireless/realtek/rtlwifi/base.c        |  42 ++--
>   drivers/net/wireless/realtek/rtlwifi/base.h        |   2 -
>   drivers/net/wireless/realtek/rtlwifi/pci.c         |  67 +-----
>   .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   7 +-
>   .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   4 +-
>   drivers/net/wireless/realtek/rtlwifi/usb.c         |  12 +-
>   drivers/net/wireless/realtek/rtlwifi/wifi.h        |  23 ---
>   drivers/net/wireless/ti/wlcore/main.c              |  10 +-
>   drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  56 ++++-
>   drivers/nvme/host/core.c                           |  16 +-
>   drivers/nvme/host/ioctl.c                          |   3 +-
>   drivers/nvme/host/pci.c                            |   4 +-
>   drivers/nvme/target/tcp.c                          |  15 +-
>   drivers/nvmem/core.c                               |   2 +
>   drivers/nvmem/qcom-spmi-sdam.c                     |   1 +
>   drivers/of/base.c                                  |   8 +-
>   drivers/of/of_reserved_mem.c                       |   3 +-
>   drivers/parport/parport_pc.c                       |   5 +
>   drivers/pci/controller/pcie-rcar-ep.c              |   2 +-
>   drivers/pci/endpoint/pci-epc-core.c                |   2 +-
>   drivers/pci/endpoint/pci-epf-core.c                |   1 +
>   drivers/pci/quirks.c                               |   1 +
>   drivers/phy/samsung/phy-exynos5-usbdrd.c           |  12 +-
>   drivers/phy/tegra/xusb-tegra186.c                  |  11 +
>   drivers/platform/x86/acer-wmi.c                    |   4 +
>   drivers/platform/x86/thinkpad_acpi.c               |   1 +
>   drivers/power/supply/da9150-fg.c                   |   4 +-
>   drivers/pps/clients/pps-gpio.c                     |   4 +-
>   drivers/pps/clients/pps-ktimer.c                   |   4 +-
>   drivers/pps/clients/pps-ldisc.c                    |   6 +-
>   drivers/pps/clients/pps_parport.c                  |   4 +-
>   drivers/pps/kapi.c                                 |  10 +-
>   drivers/pps/kc.c                                   |  10 +-
>   drivers/pps/pps.c                                  | 127 ++++++------
>   drivers/ptp/ptp_chardev.c                          |   4 +
>   drivers/ptp/ptp_clock.c                            |   8 +
>   drivers/ptp/ptp_ocp.c                              |   2 +-
>   drivers/rapidio/devices/rio_mport_cdev.c           |   3 +-
>   drivers/rapidio/rio-scan.c                         |   5 +-
>   drivers/regulator/of_regulator.c                   |  14 +-
>   drivers/rtc/rtc-pcf85063.c                         |  11 +-
>   drivers/s390/char/sclp_early.c                     |   2 +-
>   drivers/scsi/mpt3sas/mpt3sas_base.c                |   3 +-
>   drivers/scsi/qla2xxx/qla_def.h                     |   2 +
>   drivers/scsi/qla2xxx/qla_dfs.c                     | 122 +++++++++--
>   drivers/scsi/qla2xxx/qla_gbl.h                     |   3 +
>   drivers/scsi/qla2xxx/qla_init.c                    |  28 ++-
>   drivers/scsi/scsi_lib.c                            |  58 +++---
>   drivers/scsi/storvsc_drv.c                         |   1 +
>   drivers/scsi/ufs/ufs_bsg.c                         |   1 +
>   drivers/slimbus/messaging.c                        |   5 +-
>   drivers/soc/mediatek/mtk-devapc.c                  |  36 ++--
>   drivers/soc/qcom/smem_state.c                      |   3 +-
>   drivers/soc/qcom/socinfo.c                         |   2 +-
>   drivers/spi/spi-mxs.c                              |   3 +-
>   drivers/spi/spi-zynq-qspi.c                        |  13 +-
>   drivers/staging/media/imx/imx-media-of.c           |   8 +-
>   drivers/tee/optee/supp.c                           |  35 +---
>   drivers/tty/serial/8250/8250.h                     |   2 +
>   drivers/tty/serial/8250/8250_dma.c                 |  16 ++
>   drivers/tty/serial/8250/8250_pci.c                 |  10 +
>   drivers/tty/serial/8250/8250_port.c                |   9 +
>   drivers/tty/serial/sh-sci.c                        |  25 ++-
>   drivers/tty/serial/xilinx_uartps.c                 |  10 +-
>   drivers/usb/atm/cxacru.c                           |  13 +-
>   drivers/usb/chipidea/ci_hdrc_imx.c                 |  38 ++--
>   drivers/usb/class/cdc-acm.c                        |  28 ++-
>   drivers/usb/core/hub.c                             |  49 ++++-
>   drivers/usb/core/quirks.c                          |  10 +
>   drivers/usb/dwc2/gadget.c                          |   1 +
>   drivers/usb/dwc3/core.c                            | 115 ++++++-----
>   drivers/usb/dwc3/core.h                            |   2 +-
>   drivers/usb/dwc3/drd.c                             |   4 +-
>   drivers/usb/dwc3/gadget.c                          |  47 ++++-
>   drivers/usb/gadget/composite.c                     |  17 +-
>   drivers/usb/gadget/function/f_midi.c               |  10 +-
>   drivers/usb/gadget/function/f_tcm.c                |  66 +++---
>   drivers/usb/gadget/udc/renesas_usb3.c              |   2 +-
>   drivers/usb/host/pci-quirks.c                      |   9 +
>   drivers/usb/host/xhci-mem.c                        |   5 +-
>   drivers/usb/host/xhci-pci.c                        |  18 +-
>   drivers/usb/host/xhci-ring.c                       |  12 +-
>   drivers/usb/host/xhci.c                            |  23 ++-
>   drivers/usb/host/xhci.h                            |  11 +-
>   drivers/usb/renesas_usbhs/common.c                 |   6 +-
>   drivers/usb/renesas_usbhs/mod_gadget.c             |   2 +-
>   drivers/usb/roles/class.c                          |   5 +-
>   drivers/usb/serial/option.c                        |  49 +++--
>   drivers/usb/typec/tcpm/tcpci.c                     |  13 +-
>   drivers/usb/typec/tcpm/tcpci_rt1711h.c             |  11 +
>   drivers/usb/typec/tcpm/tcpm.c                      |  10 +-
>   drivers/usb/typec/ucsi/ucsi.c                      |   2 +-
>   drivers/vdpa/mlx5/core/resources.c                 |   1 -
>   drivers/vfio/pci/vfio_pci_rdwr.c                   |   1 +
>   drivers/vfio/platform/vfio_platform_common.c       |  10 +
>   drivers/video/fbdev/omap2/omapfb/dss/dss-of.c      |   1 +
>   drivers/virt/acrn/hsm.c                            |   6 +-
>   fs/afs/cell.c                                      |   1 +
>   fs/afs/dir.c                                       |   7 +-
>   fs/afs/internal.h                                  |  23 ++-
>   fs/afs/server.c                                    |   1 +
>   fs/afs/server_list.c                               | 114 +++++++++-
>   fs/afs/vl_alias.c                                  |   2 +-
>   fs/afs/volume.c                                    |  40 ++--
>   fs/afs/xdr_fs.h                                    |   2 +-
>   fs/afs/yfsclient.c                                 |   5 +-
>   fs/binfmt_flat.c                                   |   2 +-
>   fs/btrfs/file.c                                    |   6 +-
>   fs/btrfs/inode.c                                   |   4 +-
>   fs/btrfs/relocation.c                              |  14 +-
>   fs/btrfs/super.c                                   |   2 +-
>   fs/btrfs/transaction.c                             |   4 +-
>   fs/cifs/smb2ops.c                                  |   4 +
>   fs/exfat/balloc.c                                  |  10 +-
>   fs/exfat/exfat_fs.h                                |   2 +-
>   fs/exfat/fatent.c                                  |  11 +-
>   fs/f2fs/dir.c                                      |  53 +++--
>   fs/f2fs/f2fs.h                                     |   6 +-
>   fs/f2fs/file.c                                     |  13 ++
>   fs/f2fs/inline.c                                   |   5 +-
>   fs/file_table.c                                    |  47 ++++-
>   fs/inode.c                                         |  39 +++-
>   fs/ksmbd/transport_ipc.c                           |   9 +
>   fs/nfs/flexfilelayout/flexfilelayout.c             |  27 ++-
>   fs/nfs/nfs42proc.c                                 |   2 +-
>   fs/nfs/nfs42xdr.c                                  |   2 +
>   fs/nfsd/nfs2acl.c                                  |   2 +
>   fs/nfsd/nfs3acl.c                                  |   2 +
>   fs/nfsd/nfs4callback.c                             |   8 +-
>   fs/nilfs2/dir.c                                    |  24 +--
>   fs/nilfs2/inode.c                                  |  10 +-
>   fs/nilfs2/mdt.c                                    |   6 +-
>   fs/nilfs2/namei.c                                  |  37 ++--
>   fs/nilfs2/nilfs.h                                  |  10 +-
>   fs/nilfs2/page.c                                   |  55 ++---
>   fs/nilfs2/page.h                                   |   4 +-
>   fs/nilfs2/segment.c                                |   4 +-
>   fs/ocfs2/dir.c                                     |  25 ++-
>   fs/ocfs2/quota_global.c                            |   5 +
>   fs/ocfs2/super.c                                   |   2 +-
>   fs/ocfs2/symlink.c                                 |   5 +-
>   fs/orangefs/orangefs-debugfs.c                     |   4 +-
>   fs/overlayfs/copy_up.c                             |  44 ++--
>   fs/overlayfs/dir.c                                 | 100 ++++-----
>   fs/overlayfs/inode.c                               |  17 +-
>   fs/overlayfs/namei.c                               |   6 +-
>   fs/overlayfs/overlayfs.h                           |  96 ++++++---
>   fs/overlayfs/readdir.c                             |  32 +--
>   fs/overlayfs/super.c                               |  40 ++--
>   fs/overlayfs/util.c                                |  18 +-
>   fs/proc/proc_sysctl.c                              |   3 +
>   fs/pstore/blk.c                                    |   4 +-
>   fs/select.c                                        |   4 +-
>   fs/squashfs/inode.c                                |   5 +-
>   fs/ubifs/debug.c                                   |  22 +-
>   fs/xfs/xfs_inode.c                                 |   7 +-
>   fs/xfs/xfs_qm_bhv.c                                |  41 ++--
>   fs/xfs/xfs_super.c                                 |  11 +-
>   include/asm-generic/vmlinux.lds.h                  |   2 +-
>   include/drm/drm_probe_helper.h                     |   1 +
>   include/linux/cgroup-defs.h                        |   6 +-
>   include/linux/efi.h                                |   1 +
>   include/linux/fs.h                                 |   6 -
>   include/linux/i8253.h                              |   1 +
>   include/linux/kallsyms.h                           |   2 +-
>   include/linux/kvm_host.h                           |   9 +
>   include/linux/memblock.h                           |  12 --
>   include/linux/mlx5/driver.h                        |   2 -
>   include/linux/mtd/hyperbus.h                       |   4 +-
>   include/linux/netdevice.h                          |   8 +
>   include/linux/pci_ids.h                            |   4 +
>   include/linux/pps_kernel.h                         |   3 +-
>   include/linux/sched.h                              |   4 +-
>   include/linux/sched/sysctl.h                       |  14 +-
>   include/linux/sched/task.h                         |   1 +
>   include/linux/sysctl.h                             |   6 +
>   include/linux/usb/hcd.h                            |   5 +-
>   include/linux/usb/tcpm.h                           |   3 +-
>   include/net/dst.h                                  |   9 +
>   include/net/flow_dissector.h                       |  16 ++
>   include/net/flow_offload.h                         |   6 +
>   include/net/l3mdev.h                               |   2 +
>   include/net/net_namespace.h                        |  15 +-
>   include/net/netns/ipv4.h                           |   3 +
>   include/net/route.h                                |   9 +-
>   include/trace/events/oom.h                         |  36 +++-
>   include/uapi/linux/input-event-codes.h             |   1 +
>   include/uapi/linux/seg6_iptunnel.h                 |   2 +
>   kernel/acct.c                                      | 134 +++++++-----
>   kernel/bpf/syscall.c                               |  18 +-
>   kernel/cgroup/cgroup.c                             |  20 +-
>   kernel/debug/kdb/kdb_io.c                          |   2 +
>   kernel/dma/swiotlb.c                               |   2 +-
>   kernel/events/core.c                               |  17 +-
>   kernel/hung_task.c                                 |  81 +++++++-
>   kernel/irq/internals.h                             |   9 +-
>   kernel/padata.c                                    |  45 +++-
>   kernel/power/hibernate.c                           |   7 +-
>   kernel/printk/printk.c                             |   2 +-
>   kernel/sched/core.c                                |  10 +-
>   kernel/sched/cpufreq_schedutil.c                   |   4 +-
>   kernel/sched/fair.c                                |  23 ++-
>   kernel/sched/stats.h                               |  22 +-
>   kernel/sysctl.c                                    | 146 ++-----------
>   kernel/time/clocksource.c                          |  11 +-
>   kernel/trace/bpf_trace.c                           |   2 +-
>   kernel/trace/ftrace.c                              |  27 ++-
>   lib/Kconfig.debug                                  |   8 +-
>   lib/Kconfig.kfence                                 |  12 ++
>   lib/cpumask.c                                      |   2 +-
>   mm/kfence/core.c                                   |  51 ++++-
>   mm/memcontrol.c                                    |   7 +-
>   mm/memory.c                                        |   6 +-
>   mm/oom_kill.c                                      |  14 +-
>   mm/page_alloc.c                                    |   1 +
>   mm/percpu.c                                        |   8 +-
>   mm/sparse.c                                        |   2 +-
>   mm/vmalloc.c                                       |   4 +-
>   net/8021q/vlan.c                                   |   3 +-
>   net/batman-adv/bat_v.c                             |   2 -
>   net/batman-adv/bat_v_elp.c                         | 123 +++++++----
>   net/batman-adv/bat_v_elp.h                         |   2 -
>   net/batman-adv/types.h                             |   3 -
>   net/bluetooth/l2cap_core.c                         |   9 +-
>   net/bluetooth/l2cap_sock.c                         |   7 +-
>   net/can/j1939/socket.c                             |   4 +-
>   net/can/j1939/transport.c                          |   5 +-
>   net/core/dev.c                                     |  37 +++-
>   net/core/drop_monitor.c                            |  39 ++--
>   net/core/flow_dissector.c                          |  49 +++--
>   net/core/flow_offload.c                            |   7 +
>   net/core/neighbour.c                               |  11 +-
>   net/core/skbuff.c                                  |   2 +-
>   net/core/sysctl_net_core.c                         |   5 +-
>   net/ethtool/netlink.c                              |   2 +-
>   net/hsr/hsr_forward.c                              |   7 +-
>   net/ipv4/arp.c                                     |   6 +-
>   net/ipv4/devinet.c                                 |   3 +-
>   net/ipv4/ipmr_base.c                               |   3 -
>   net/ipv4/route.c                                   | 102 ++++++---
>   net/ipv4/tcp_cubic.c                               |   8 +-
>   net/ipv4/tcp_minisocks.c                           |  10 +-
>   net/ipv4/tcp_offload.c                             |  11 +-
>   net/ipv4/udp.c                                     |   4 +-
>   net/ipv4/udp_offload.c                             |   8 +-
>   net/ipv6/ila/ila_lwt.c                             |   4 +-
>   net/ipv6/mcast.c                                   |  14 +-
>   net/ipv6/ndisc.c                                   |  28 +--
>   net/ipv6/route.c                                   |   7 +-
>   net/ipv6/rpl_iptunnel.c                            |  62 +++---
>   net/ipv6/seg6_iptunnel.c                           | 227 +++++++++++++++++---
>   net/ipv6/udp.c                                     |   4 +-
>   net/llc/llc_s_ac.c                                 |  49 +++--
>   net/mptcp/options.c                                |  13 +-
>   net/mptcp/pm_netlink.c                             |   6 -
>   net/mptcp/protocol.c                               |   1 +
>   net/mptcp/protocol.h                               |  30 +--
>   net/ncsi/internal.h                                |   2 +
>   net/ncsi/ncsi-cmd.c                                |   3 +-
>   net/ncsi/ncsi-manage.c                             |  38 +++-
>   net/ncsi/ncsi-pkt.h                                |  10 +
>   net/ncsi/ncsi-rsp.c                                |  58 ++++--
>   net/netfilter/nf_tables_api.c                      |   8 +-
>   net/netfilter/nft_flow_offload.c                   |  16 +-
>   net/nfc/nci/hci.c                                  |   2 +
>   net/openvswitch/datapath.c                         |  12 +-
>   net/rose/af_rose.c                                 |  40 ++--
>   net/rose/rose_timer.c                              |  15 ++
>   net/sched/cls_flower.c                             |   8 +-
>   net/sched/sch_api.c                                |   4 +
>   net/sched/sch_cake.c                               | 140 +++++++------
>   net/sched/sch_fifo.c                               |   3 +
>   net/sched/sch_netem.c                              |   2 +-
>   net/smc/af_smc.c                                   |   2 +-
>   net/smc/smc_rx.c                                   |  37 ++--
>   net/smc/smc_rx.h                                   |   8 +-
>   net/sunrpc/cache.c                                 |  10 +-
>   net/tipc/crypto.c                                  |   4 +-
>   net/vmw_vsock/af_vsock.c                           |  82 +++++---
>   net/wireless/nl80211.c                             |   5 +
>   net/wireless/reg.c                                 |   3 +-
>   net/wireless/scan.c                                |  35 ++++
>   net/xfrm/xfrm_replay.c                             |  10 +-
>   samples/landlock/sandboxer.c                       |   7 +
>   scripts/Makefile.extrawarn                         |   5 +-
>   scripts/genksyms/genksyms.c                        |  11 +-
>   scripts/genksyms/genksyms.h                        |   2 +-
>   scripts/genksyms/parse.y                           |  18 +-
>   scripts/kconfig/conf.c                             |   6 +
>   scripts/kconfig/confdata.c                         | 102 ++++-----
>   scripts/kconfig/lkc_proto.h                        |   2 +
>   scripts/kconfig/symbol.c                           |  10 +
>   security/landlock/fs.c                             |  86 ++++----
>   security/safesetid/securityfs.c                    |   3 +
>   security/tomoyo/common.c                           |   2 +-
>   sound/pci/hda/hda_intel.c                          |   2 +
>   sound/pci/hda/patch_conexant.c                     |   1 +
>   sound/pci/hda/patch_realtek.c                      |  78 +++++++
>   sound/soc/codecs/es8328.c                          |  15 +-
>   sound/soc/intel/boards/bytcr_rt5640.c              |  17 +-
>   sound/soc/sh/rz-ssi.c                              |   5 +-
>   sound/soc/sunxi/sun4i-spdif.c                      |   7 +
>   sound/usb/midi.c                                   |   2 +-
>   sound/usb/quirks.c                                 |   3 +
>   sound/usb/usx2y/usbusx2y.c                         |  11 +
>   sound/usb/usx2y/usbusx2y.h                         |  26 +++
>   sound/usb/usx2y/usbusx2yaudio.c                    |  27 ---
>   tools/bootconfig/main.c                            |   4 +-
>   tools/lib/bpf/linker.c                             |  22 +-
>   tools/perf/bench/epoll-wait.c                      |   7 +-
>   tools/perf/builtin-report.c                        |   2 +-
>   tools/perf/builtin-top.c                           |   2 +-
>   tools/perf/builtin-trace.c                         |   6 +-
>   tools/perf/util/bpf-event.c                        |  10 +-
>   tools/perf/util/env.c                              |  13 +-
>   tools/perf/util/env.h                              |   4 +-
>   tools/perf/util/header.c                           |   8 +-
>   .../cpupower/utils/idle_monitor/mperf_monitor.c    |  15 +-
>   tools/testing/ktest/ktest.pl                       |   7 +-
>   tools/testing/selftests/bpf/test_tc_tunnel.sh      |   1 +
>   .../drivers/net/netdevsim/udp_tunnel_nic.sh        |  16 +-
>   tools/testing/selftests/kselftest_harness.h        |  24 +--
>   tools/testing/selftests/landlock/fs_test.c         |   3 +-
>   tools/testing/selftests/net/ipsec.c                |   3 +-
>   tools/testing/selftests/net/pmtu.sh                | 229 ++++++++++++++++++++-
>   tools/testing/selftests/net/rtnetlink.sh           |   4 +-
>   tools/testing/selftests/net/udpgso.c               |  26 +++
>   607 files changed, 6988 insertions(+), 3353 deletions(-)
> 
> 
> 

