Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88D225CC57;
	Fri, 24 Jul 2026 13:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898411; cv=fail; b=PoU0laB2VqMIiBlEQKz8qsC1M7QnxFsRhMarONYJO0BrIzZm7RKL+ohE+et2VtVrvfzR4aJe+EaOfZQOue34dCqqNWqQv4sRQPfuYs14o80plMk8nb6dCz+uAz3HeB199D65AIS67vhJCdUTCXNQEcZLhlaUjr+ACdq+lSNkTy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898411; c=relaxed/simple;
	bh=Mb1d7iQTnHdwQlWsUDk+Uu5Ml+s0ifrk/13DplYFbUo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P2JvDCbTZtte7oSvMrFS2cWTGKDrHOOqNlUII49uwoosZjrk5vLcfOO/T8dIeU5z8cA5ZvTk8c7BEAGGpm/KBvD/tNzyX7YEvJHUL7596bulyVzmzvhABujpHjLgAl2cm4sbxe8Cl6EIurIDPKtrTmFraJM3i9xRW9QFSkPkJYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fuVJA0WT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w3UR2sdj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fuVJA0WT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w3UR2sdj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCtgJ13346913;
	Fri, 24 Jul 2026 13:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2Ptm3iMnxS27ia+bVDifdNPPCIo6jA1Rb594we9e4FM=; b=
	fuVJA0WT1n8nWufv9tnKRp/lVqnxJBIzqmmFgc7gUBaiNv0vgWJFbnFwRSB8qk/G
	5nsgtJC3hNHdjEmOXiPyyyIJwx/AZUFtECJkRruJum7dBkWilxgZmoyIpY16/NRC
	qQeAVmoNFXwPNaL+Rv03jgYMw+Y3jswHl2fUI5dNGF9XtGyLn3yWaSPeby/79Uyk
	AznlrqrwjOi5TrLVmQDRDpmgWGMsbdarKSo3yJAOhsfsB8IRvuH+YR6KA+32LrVV
	V0VSUuXV3968326V0JBokFUKf4SgRjDlcn74+aF+Pj5td7PkwUrIPYxNLpIA2fg8
	FmBrKSIDIiyFFfhpN6a0uw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv8exs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 13:06:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OCxEXJ006176;
	Fri, 24 Jul 2026 13:06:43 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012064.outbound.protection.outlook.com [40.107.200.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxtfrar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 13:06:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5Ye4XS/+CTtRCsxQ/MI97rMg+/OgnrDkVvU+DBsNMBHugdCI4JKS0ebLLQ2+RFUHMADZ9HvKcjCh1Rks4CCLU4lBluav4VJagFq1uaAYwNb8wu/CiPcBlgGD0MEqXuCYZ2I2UOzlpyu4IwLrdGHbCTozg9yr99ymbt6gamaA2QGI7MsXgTAUVRSuFWrXlaEBqrB79beNK9YLN8G5vUQUpj+qMtrzvHcnY35kWavVgyphRDNDd8udOgGxRFHEVzge1wCa6R7wh5uRQifS4SFWYN01mqkROK9iKUib5q6Aev8+jxO2aEx2lmFVoRN9a64Z+fHkJRX7mG1yt7G7obulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ptm3iMnxS27ia+bVDifdNPPCIo6jA1Rb594we9e4FM=;
 b=DOgrp5BkH4dR26wCRoSUXs1W0vzQZf6yuepGQxRKJm8AHhYygnt5YWqleHYS6xcPd8NRzR70V3rLgiz1NM5cG0ub3nHjuHU4VIY9SnFTgGKIpkcRo7ZqELbm1bQAwddGY9yx3zKGwY0I7fn6fRMqGGpdOejZrulxT/1cJkotgCz4T430Qx4CDpzDKmhJRL/A99udSBa9vBPfeCsmIFxehcDwQ9gjTaFndoLIbI4XRkNyFDuzoMxzJj+ReDVrzdF34DLo4J9lk2yrMSy5/+Qun4tu7piBJDgV1cwLK+JkDZLzDrA6fb/3ekEmfCPk6E5+Nruyr3tHR2I8rtmd2jHATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ptm3iMnxS27ia+bVDifdNPPCIo6jA1Rb594we9e4FM=;
 b=w3UR2sdjGYcluXBrbv+PhF/0/oxMgsO+YdYWVTcuOihZFMo0DQU5Jytl2cxasq3JaK/0w3TfOVmMoQV9IkYOcZqaDNZvA/7mIH8RH65ZdMd8rpDkF/fg71CWtnXSq8frAW4te439+eoja0iOH7wyTmFK93PXI8aMrTcvLprR4A4=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 13:06:39 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 13:06:39 +0000
Message-ID: <f3983301-c8db-4071-839c-d153b7e0efbc@oracle.com>
Date: Fri, 24 Jul 2026 18:36:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0454/1276] drm/amd/display: Add missing kdoc for ALLM
 parameters
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Roman Li <roman.li@amd.com>,
        Alex Hung <alex.hung@amd.com>, Tom Chung <chiahsuan.chung@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152456.263240536@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152456.263240536@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0154.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::15) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: fb7f0222-9133-4c5b-141e-08dee9846666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|22082099003|18002099003|56012099006|4143699003|5023799004|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	y1aVqGLHUdfU1Sk4Zi1BOUtHHogh8hE3OKfEiIx7LGr3mVc8ElFNgFlHhjBCLmtFrqKELXZdTVKCFuENHkywJpKf1z8lWXIzyCqTKMMBqbI5af4m2ex77XWe26VbH2cilBTX1tM8AfVgvPctS9pByoDaOhhxE/IovbN/yRKF/pSwhA0yWAi/U7Ujli7ANRpJorhAoCClIeN5LSoh5TNop2bdE0Y/gGQT8kXmYgCU/Ka6aWJxE4QAa+sxKKr1mi1TqvO2mUlEAu+Sq6fWAE29/gjUNpLmJmSw/sFjeWMWpzW8qg4FI4l9Bo+oGOQhUqu0IMEW710QbgXYzsxdiA0xoqrLpoFeBbYMosbkUPltdhnG9eVAN4HbqodZWR7D8WZdEVQtp8jP180OwDwD6mwQ/4jXLZ5IipWIfAhntvLwkMJ3kj99qn7TyADU8UquKTwOChZkwR2PyD+aX9tJEAqp3ihWbXxrFPzKoOv6yRMtTC+CuVYNMSwaDnq1ouMljVQC6O4F7JPZNd1Hp3lwpBN/hjPZf3Vxl62zO5mEkswUZ1TK5fzQ6JKK8zi0yziy8XTksAgDIDpNH5fS0RDflw8/MZ9wBGSBHZUTrY/WotyByoW3acDReEF+LIe0P8FUCFBUf3p6I+rixpEudp+dJns7quGoG5NUEknWV/PvMIH6eLQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(4143699003)(5023799004)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1ZsZnY2MENFK0I1Z01VQm5KdnFaV2pPTUxqYzV3UWNnb2xFYTVRTzI5NVJH?=
 =?utf-8?B?NTlkV2d5ejdYM3F6dkNlY3d3dkZCQkY5eW1ja3FlU0R4c1dHOVoxaXU4MFdQ?=
 =?utf-8?B?QWFxUzNpekRUZERNVVdjdEFVODdoZ08yQVFrajYvb1YwdkF0d09qZTc5QnYy?=
 =?utf-8?B?UXg0cGtTTzN1NXNuOHRxeE8vL3JVdHhWQUR4VjN3c1BhbCtzUFRncWFWTkdo?=
 =?utf-8?B?MXlNOEh2MzNiSEhyaWVXaHlUVUpuNTRFbjdtbngwU0szaDhoWGtlVDVxVkdi?=
 =?utf-8?B?cWVsSzdJbXY2NmVwbHh5b2Z3MEVSdnpCSzlwNnNuT1l2MHJVb0s3bXlMQWl5?=
 =?utf-8?B?UEM5a3h0cVBlVnBBLzllM0xTU3RJSzVNeVdJditBVERPckZQV00zVjhlSWkw?=
 =?utf-8?B?UUtMN1NLTzV0ZGRJZVN0Ky9sTjlQZkM1MzY3V0drdXdnL0J4WkJSNmhXYldM?=
 =?utf-8?B?Q0x6ckk0bC9oQmt1ZFk0UUJwcFgvdjlMaSs1YjhXNTBzVEd1ZmlmUkJhMFVi?=
 =?utf-8?B?NDJ2bDU2Q1hheGJZQjZSMEdrWGliZTczZDhaOHp0QUlDZGszME53ZzZZSkFJ?=
 =?utf-8?B?YVh5RzJQeE5HMnRoaTNFRU9Udm9HcFh5dG5IMklRdG0rbGp4M2ZaLzVGZVh5?=
 =?utf-8?B?QTJiMEU1MCtXR1BWYXJML0tPZHF0Tk1XTDN5Mm83MWVBeW5VSHRkcjRyS3c5?=
 =?utf-8?B?TU5uQzhrZDI3WlVxTXNIVzVHZG95ZnJtdW5NRlNJRHJ0MDdYcllWd3QvOXF2?=
 =?utf-8?B?bWVaU2dNbHdybS90NDJ5TWVtVUVnQXBBakduQjVZQVFQdE5aMzZpa0crak9j?=
 =?utf-8?B?UHlVM0RSV0RHcTJUZG9kMlJOTmxkRjNsSDdlMWp6M3FBL2F6SzJHMGhEd1ZP?=
 =?utf-8?B?VzE1RGVkd1FzbnVaTUNtSDhqTnkvWE42OHAyY09vSHNDMTBPNmY2ek00YmRJ?=
 =?utf-8?B?VjVhWmhNcjNnOEpKdWYzcGI2MTMwbHh1aEZpV1Z3UnY1TWliV0dMNkgrcFFG?=
 =?utf-8?B?c1JLMTFzdG5HVVcvWk5oemtSZDNNdldnVnpONW9mOEdCNlhhTlFTUTFEcFBH?=
 =?utf-8?B?dUY3Ui9Nb1Q0TWsydUhyRlJHbG9MZXJxTTVXNHZ4T1VYd2lOSGJtM3Y0bjly?=
 =?utf-8?B?eG8zeUpTZkhiWWZ0cWVFOU1GTDZwTTBhV2xrMFlZbDgrZlJtUWgyTStxMyt3?=
 =?utf-8?B?dzhnQWUzQlFZM00vVEhZbFkzMStFSis0THMzaHFTbVIzbzA2anNHYTJjQWxx?=
 =?utf-8?B?RzB1YUlPQmtkZnh4cU12ZDFkZlI0TjcvTU5lMyt2Y3p3TkVnNCtwcmUyQmVJ?=
 =?utf-8?B?Q1U0dk1Od25JYlVxcEVzODVvbWZXNWpvMjdEWHFaSVpTelhjU1kzUGlrM2dv?=
 =?utf-8?B?Ry9JU0E4ZWhvZnRGNXlwMHkzYkh6Y2hENVNwL01YeE1XTDdxWldRcHNJTy9w?=
 =?utf-8?B?aitsUmRQMXk3ZUpYeVB0aFRXQXJjYUZqcUJ1Kzc0K0NxVlBEYWUzU0c2S0tV?=
 =?utf-8?B?V2hyWkU5bnhSdW5SeWl5MGVQNjlwTnF2WUdkL3FUM3A0WlVTaytMZFppMVln?=
 =?utf-8?B?Ujg3UXdVZEpUTkxDV2Q4Qms5dmJFbFBLK1hmdkJ0WThFTGIvZEJpdUltbkky?=
 =?utf-8?B?OGQvWXdHKzY5U1QxZTU1WExRT1ByS0hEU3laaWFDKzRtZW9YQ05obTd2Nmwx?=
 =?utf-8?B?bHM1eUhXZFFNTng5TThBYjM5L05GT1kvWVVHcXhUdGE0TVY5bjRKdHlLSzFm?=
 =?utf-8?B?aytDWVRobUlPc1RlSFhwZEZ3anFQakpJcDdORFYvVklheUE5QnFmMWdqaTFp?=
 =?utf-8?B?YzlUTnpodlVUVjJ0Z2llcFVDcFZTTm5IUWZDVXliSFVkaWJBSHU2dTJSYWt2?=
 =?utf-8?B?eGVmOWRMVjFhMmNraGxhbm5ROER0a1lTVytKQS9SM3pZKzZIYlF5ZnNyQ2RF?=
 =?utf-8?B?bDJlMjNJUkxBOFJaQTQ2akdHYnBHZTR1Z2dYNG9wQlJJTjN2bjZjUHNrWnJO?=
 =?utf-8?B?STZsZG9ka04rcUVGTXdLWm4wRFRZVE82c0pWRzh6ZWFFbTkwelJkTjQrSnpJ?=
 =?utf-8?B?TmtiZVZIZlFmMUg3eWdkcXdqQlc3cUxkK3k0dVJweGVSRHpuY3JUZ3hrTHJt?=
 =?utf-8?B?T2k0ODVsaWNsLzdybFhNS2drWEY1Y3hNUU9jWnQxRnFjMUx5Y092L1RqUVRh?=
 =?utf-8?B?UTEyN1BUTkRad0gzRDMyMXczVjhlVHhnemJKdkpkVk1QVWhvU2pDbE5qRmlq?=
 =?utf-8?B?NWhPbTJuWXE5SVJvQ3pTY0VydmIrWiswL3BKb01MdEs5TGJzbnYzaklGZG5J?=
 =?utf-8?B?ZUVZMmkrYS9xZm5LTm8zS25Xem9UZThaNlF6anVXMWh2ZElNbExwbUIwc2NM?=
 =?utf-8?Q?SW2nsb6XiFcMZEL4liwO0AXs4gygh2NhMj7TG?=
X-Exchange-RoutingPolicyChecked:
	SHULeZkU7OKne0xUBLIJI96dHSxyL4uWeXXxOMOGU7vsQNreXsyugRqD+niaFewyaQH/yM0VOkYL/oe5+a74ntZy96e9Tuk5cNBwg3t2pLKmXnYDTFgkQ6phSOYCQBLlKQYPYZVHLDWilgCS88SJmORlFatYjylcRBg4h2KTS9wJ4zasxLJWbp03vzx9SVCD2qK7DOa9sj+6AQSXlAQuwJtuAQSCa4Z1Xuye7os51dtlYDwVKpKJbMGq2/whWJAGgWQGIPg6RPow0KABofvmj0StZ6oODJiZjYhpN3LzoQ0WPuqJNXmiaVLXZzViKFM/SlC5jJO04jUyHHa3gHK5xQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	66Dqc5QrGdAzu7GIPpjQkCUS40PINl+ZyXIU1S6j5YytL5cLzVGSbc9z5ZIVClXhBL98uCuxbvk40VuCjzIopvmo9lglT9udqNiyH1/rdhKKsrdGqFradC6WoU9KVCHWB6dQc2GzzXI8wo9HLQuOpbKD4P53ZGO4+apjE4Hrroir+aaARtlpyZvTrCF4NwAfNVViMR7XrBzH3BXCzCUS95Xu5E/RNocU0znEWEoVJ5xgEp1B2xd+Hxtj2KO1Ig7g3QtYqDo2x6GEhfYUq7SZIbpIlmtLsZQ12HtVj8huAJt0GUar33xPQuVKS3/vOUbo2YLnpo49zJhalJ0fl6Q/GKG2aFIAovYJP87QhanJgAc8HETce/ql0NY+jsQLpaYIMzmp5Tc3SzhU0s4u3zvxEz0z3L17vKKGkm+8Xu31HtCtKKcuSBrn8V4sV16wfzdzxBiV4PCJ8P9UJ6gAFBxMEW64rEvWOOnFMJDnkOBVxcMStLZwRPBHXw9HkHqN8g8cd47/oQsj4NfGwo+Cxx/OP3/gpHRiEURznw+7+GD5pMdflzXoH6PSCTErfJIVTzh8V2OJOOh1V1xLZ8jf0agwH/ILB+fwhVHKHGdjQEDHlRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7f0222-9133-4c5b-141e-08dee9846666
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 13:06:39.7247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKDSlrJTMo9d8U0QpU/ctX9g38d/hXGwDELZftEN4Uow2Yi4En87pkxFM9aylLmFLjMSQmUg5V6O+5x6SaAvJlPJgUuQQOuLhIUY2lE/mSWEcAM/eIEZnUjI16pg870S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607240118
X-Proofpoint-GUID: 7iSbeR6SPcUdR1S4vL7xDtn3x2snYwqx
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDExOCBTYWx0ZWRfXwaUt7AcF3H/G
 +FPVY74+dbuEeUZTKvDvlUlW9UFhHAJikN72VM4TSxEMR20qM8c0GQlkXgUXAbeunE438jOlpUR
 Jhg47L6on5l6kpzsd1fBYAyDOXQJMph0Ix5Jhrpncup5HzDFFz1c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDExOCBTYWx0ZWRfX5b1s1wsFkv9t
 AR1VaHb4qMZsrVBY7js6z23L8DCcFzPv8P3DJ2Ayzo0W2RP/LwEIqIfL1KyeJzZ9xvJl3uc2HDn
 JwVSa1ZKJqiw7iJTSwx/tMbuIMp3G8l8+z9xGEkq5AhS1xRPBiqsN8n9h1Y43qU5LmaTD0+++I9
 SdPEEklGj7gSGulOzqWREkBeK7sjvtA7auEwbtTfqQLz/8BaHzJEi84by+vSYrE3Lj6iu4NJj1K
 qRmi61MC1CWHilTv+rsvaQr8HZdcC4Dc+KVwjIw3CG+Zdsz/9HFP1HxMnw+iML8JX8Ft4y/YDqf
 BWpBcPXEx6UMGZa+7klCgjQsS+//sYO1yWJ9UbNrwKIG3zDkc7TByBD1dGCKmUL31+Ac3JKPg6u
 ZHa1mnDAqSE/8G7Y7TOEpti0GZ5FyVG910gn+5hFkwyfXyqrOQbfJYn5ubEfaG5ff78BhGXPUkU
 Q1Wy3ijzburKmdaqRrbf1CKcxiU/DxB19sRAsnds=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a636363 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=zd2uoN0lAAAA:8
 a=VwQbUJbxAAAA:8 a=qp42saXfZA000H6VjxEA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: 7iSbeR6SPcUdR1S4vL7xDtn3x2snYwqx


Hi Greg/Sasha,

On 21/07/26 8:44 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
> 
> [ Upstream commit d4c6ec729fb7a8bf8a27b19bd70a1b945ad93dac ]
> 
> Add descriptions for the missing parameters for ALLMEnabled and
> ALLMValue  to keep the function documentation synchronized with the
> function prototype mod_build_hf_vsif_infopacket().
> 
> Fixes the below with gcc W=1:
> ../display/modules/info_packet/info_packet.c:507 function parameter 'ALLMEnabled' not described in 'mod_build_hf_vsif_infopacket'
> ../display/modules/info_packet/info_packet.c:507 function parameter 'ALLMValue' not described in 'mod_build_hf_vsif_infopacket'
> 
> Fixes: 3c2381b92cba ("drm/amd/display: add support for VSIP info packet")
> Cc: Roman Li <roman.li@amd.com>
> Cc: Alex Hung <alex.hung@amd.com>
> Cc: Tom Chung <chiahsuan.chung@amd.com>
> Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
> Cc: Wayne Lin <Wayne.Lin@amd.com>
> Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
> Cc: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
> Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
> Reviewed-by: Alex Hung <alex.hung@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
> index b3d55cac35694b..ae858a43c35f4a 100644
> --- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
> +++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
> @@ -447,6 +447,8 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
>    *
>    *  @stream:      contains data we may need to construct VSIF (i.e. timing_3d_format, etc.)
>    *  @info_packet: output structure where to store VSIF
> + *  @ALLMEnabled: indicates whether ALLM HF-VSIF should be generated
> + *  @ALLMValue:   ALLM bit value to advertise in HF-VSIF
>    */
>   void mod_build_hf_vsif_infopacket(const struct dc_stream_state *stream,
>   		struct dc_info_packet *info_packet)

I have run an AI-assisted backport review and took a look at
afefa5685cec ("drm/amd/display: Add missing kdoc for ALLM parameters").

The upstream commit d4c6ec729fb7 documents ALLMEnabled and ALLMValue
because its mod_build_hf_vsif_infopacket() prototype has those two
parameters. In 6.12, the function still has only:

         mod_build_hf_vsif_infopacket(stream, info_packet)

The backport therefore adds two excess kernel-doc parameter
descriptions. scripts/kernel-doc reports warnings for ALLMEnabled and
ALLMValue on the reviewed tree.

The parameters are reintroduced upstream by 952df08d5b2d
("drm/amd/display: Update HDCP and info_packet modules for FRL"), which
is not appropriate to take merely for this documentation patch.

I would suggest dropping afefa5685cec from 6.12.y.

Also this is a documentation patch and not a stable-dep of as well, so 
lets drop this.

thanks,
Harshit

