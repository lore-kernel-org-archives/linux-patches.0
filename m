Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37A9371CEA
	for <patches@lists.linux.dev>; Thu, 14 May 2026 12:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778763574; cv=fail; b=tQr5pd5QzkdxaZd/7YC5a4IDenNhnZ/4piQJz+nDhsLbLaoQqldAF0NR50bRK0ZUNA8fJyAlv7bPu/Zw0yuEQ1H1BJ4NIV/DHekzNoxg8/v7DeddND2+h5dp31VwZwRQLZHK8KOSr6t4BQ/gV9A0MZ+d80H+/hN0jgxMc+iaj8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778763574; c=relaxed/simple;
	bh=UVsZed6oqkwK4dwo916uO0RnEkNfnuuvqAciL9fQpYk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Bn8jsDG7rMSjkEP5c9VH5fxwag0nw+e2pYXM0gLVrTev8WNJhkjFk9I6bjgM6QfzPj4VsY415DN8tEbtLxzbl2TVM5+J5hkwkTMYJplM0l1BQ1o21Tl95NCQeG7TEu08LpqfTqgEHW8cAjcg7l+bOaUoEntxAC1O68snGj7jjFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yx3C9/89; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SONW9nSx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yx3C9/89";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SONW9nSx"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EAMbdp2208923;
	Thu, 14 May 2026 12:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uxaiT8SCFrt5y4vU89fPLYgBeeYVeXgmr/KoALmKFAg=; b=
	Yx3C9/89+JZK/tBdYZQYT5DhS8kuMTbqzb54F3bKRCMTqspI1dTP3G1WtsS1SnHH
	75DTbbGEk1DRot56nrJpdqWyPFyLM7cvi/LbjGI6HjKibYSeXT4V+TSxcbKI6vP/
	Iqk17mZ3WyfEtiSpOO+uc+QPJZRSV2/8xy2jRNWPn3nrW06umw/FxZTyecJykAcA
	H6ITQF6ke8vsA3WLLp/i+7N7YOYcFTI+J1Oa/bSlZ8nDKXuLLxTVJkNRn6CAgY2i
	FHEHA68EjLx6jOd5olT8sM+i21VU9dn/kyINDiQqNcoDkMqMjjCbjZhz/iZPcofY
	FoDAsR4MQ/chKwo++YgNCw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c96k6cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 May 2026 12:59:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64ECsvQ6031567;
	Thu, 14 May 2026 12:59:10 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010054.outbound.protection.outlook.com [52.101.61.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e3necbdw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 May 2026 12:59:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zEAVMXiM/WNW3vDp/pIGWCxFIg/LUqDcikHqFseK4m/3pcDsLXFAQa8uDTHPqogNITIFCwHTGqFRT9jWmacd0yqOto1xH6ubz3vyvGHSNjjyyYKiynXuuFYARY/+if5meKNEXEdW5X9DNmk4kwMUjZPaQhaI8lVontPZEt7m95fGt6Zwt7Wh0Igpne307FH+Mw5ySS5k/vXCg8MAF+HcQxNl9buh70AuZQVdx4uX6wJr+asga7ipcBjxrWnpvqjd8x0TlRutEaFMHLl9aiiqugljAt2tQY//58pgl5cxXFZBKAmcpTdo52fpB22lBgKM4VWYkA3lUxiEd9V5jrn0jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxaiT8SCFrt5y4vU89fPLYgBeeYVeXgmr/KoALmKFAg=;
 b=l/qUhivyc/QiR6/jN/ctgClpAXrklInzokV6VDET7I3uE8WPBXYuKw64ZVVoZmBOZ5pwDfKHsWeuUvIBUkToiWPu1YsuRsYBtyyAflZV3QZx9JlqJqAaCeoI8ef/FKKMYuwSkq85/TCeBUGeENeyEVg7f3WYCsztPDXO2nXcpYRNGkLcpUOaKC77aVTrvuTTuvrN8O23dQ28GFB2Z0PsicA1zV1+n4eqXNsNy0GjT6atrnaL6bzZPVze+6Spmb6K1jiZ947AKSMVr2V9/0j2gh0AL7IA+kznIVUQgiqsTH0vbs1hScivIiTg2lINXN5OId4irJbxWAs4ASVlyaTIhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxaiT8SCFrt5y4vU89fPLYgBeeYVeXgmr/KoALmKFAg=;
 b=SONW9nSxTz3WgPHk9vhmwzMCuMIJdweJX4TgshTy46vz6SsT+8pbzNTCjakbKpYyr/p44/X8tO78p1m9eRrdvq1TLHax6MWVeSgbNyx5uw+Owzn4OGRE7dA3gSVVOC2+GrQvy5fLnr51WjqtBUjIzkJE7vPEhmRV+RVMiB8HzVs=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB5657.namprd10.prod.outlook.com (2603:10b6:510:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 14 May
 2026 12:59:03 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 12:59:03 +0000
Message-ID: <262e7717-e2e0-4797-867f-38473da867c2@oracle.com>
Date: Thu, 14 May 2026 18:28:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260512173932.810559588@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5PR01CA0039.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:264::15) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB5657:EE_
X-MS-Office365-Filtering-Correlation-Id: 25d1bd2f-26dc-44aa-c8dd-08deb1b892bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vNs5qbBB/VDtTJjLnCkX6ILYv8fSWkNBRpQ5PuAA/EThQkXy6vUHbWvd4qYCxQ1svbwlUIatBZHQrNooVmhy5+BkqZ6pjh457w3HziDEqQYDer5CxnYlRLFSvoIuNKuAfPuZ5tWVS7jQ53Zd7Xy2ceNYriIbxSGKtpZlIqV+Qoew/YhWEqDDYmz1mcoJXUIr94fcXn7lUKPbMz45Hft0v9v6eK1jQe3OFiw74UC5FEczjtCYeiIsZ2W0pkitD5aydfuax7nrevN886LGMj0e+7H9f9ALA4PtNcSHF1jXjym+TrqLHEaccr3wuOyyl+M2CWPG/+PRNpzhQ0mdLCl/p3V6P8Sp3xFa8xBUxKuVHOGlpHGg3jc1hxWjtHF/2KqhRrdSgMRKZS8xmi8XEe+hWCs8wKSjobtDTx8gLOS5oNo+FRnHtewLN3K5LxibIAVeRp4rC4ZLnpg6eIIbIrjATwCYNL9y/Ra2hpmFoasp9AQWctrlSb9yurFW3DeQrmDoV86VH7hGxGUjbXfBqxnFHPoPmAtKxSMDry934cHzWodNs1hhIGCREvddXdBcOQMM7FtvCCkI34iGQtDRalzowqo5YFixJvgks07mZAT39uSltJIYhl7tDEVYYQsbcg6eoD6HJOVRs7k869aLCiTbifCgqXKVJOHyaE9DW5JiQsq1rjGxPOiups/UuBcsqXLSV6Iz4dpWKdpwfizDccsCYA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHJ4MStQVzNBZ0E0aGFqdDI5TWlGME1Ca3IrRFdUR2hSY2ZhdE9lcUpoZ0ZE?=
 =?utf-8?B?NlNtenBmbXRtejltakdmZ0VwTXVTSUpROUVGQU1sY0JVMS8yZkZ4M2R1QlB0?=
 =?utf-8?B?WkVCTThFSlhGVGRpQ3dPcHBhMzhUcUM0dHV3a3A1emtpVU9KQlY0cXF5Ukty?=
 =?utf-8?B?Y0RwQ3BMcmZOdGl2UjhBT0tYUWQ4eUFjcFNtMi9RWEJhSmhkVWlWOHdOWERR?=
 =?utf-8?B?M3MyZVFNVVBiWEp5aGJPWjN0YXl0cGp1ZjFSNFNGb2k1SVZDVXVQemdtODQv?=
 =?utf-8?B?UVJhQ3NKL05CUXpPVThrQkJJN2xjQVNtcWFRdDhLb3dGdXd3YmlLU1FVbFZl?=
 =?utf-8?B?bFVTN1drYlI2cHFVUTZsWW1MTnRQMGlJaDl0ZmhhcVhlWm14dUpWK2N6Umpj?=
 =?utf-8?B?aTdYZkFvckRBRFZEa2pXUHYydG5kQ1dxc0ZQektGOWlUZWl6QXpPRnE3c1lK?=
 =?utf-8?B?STRqN2FNZklJWEE2dVIvVENwZUlEMUZJcXg3ZWlzZFBKK0tqN1BNb2R5QVBj?=
 =?utf-8?B?RGovR2k2M0tRUXlXVTRqbjl0bjBYQnlGeHc1OFhrL3RDUTJVUHRsOVZOKzhi?=
 =?utf-8?B?S3BUVU41MS9EdFB2aHVXWWVmTDhlMldhYXJvUjgvV2pydW11OE5saFdkdTJ2?=
 =?utf-8?B?ZGloOXdrak5wLzhNL09GTnRWdWs2UnhscTQrZzR5cVpRN0liejBrTXV1TkFq?=
 =?utf-8?B?STlxYW1vbXlqZ0lxdXdYY1E4MDRlZm4xTUUydTI5MjducnVJUWV4ZFduYUM4?=
 =?utf-8?B?RjFiTWgwRCt5QUJVVmRJTEM5YVhhWTFXTWFUUXFTNGt0NVFIUFUyZ09NUmJY?=
 =?utf-8?B?Tk56REdnS0pQcVVYenV2U3FNT2MvQm5yTFdDWHQ1Rk41OThseTFSZ1d4TUJn?=
 =?utf-8?B?SmJSYkJNQ1RDUnFsUzN6MzdCUWhiOHFKMEdqWDlyekNIUXB2T2NwdVJtNDNi?=
 =?utf-8?B?aHdrTUt4UEcyY2dhZDVLOHFMWmMxSmJNaDJzL2Y2cUxDL0IvdjlCWmljdEx2?=
 =?utf-8?B?aE55YVcrc0pPakxuZFA3ZjhUemUvWFVrVXl1MGxSaVBEdStkN3lPcnVEWUxv?=
 =?utf-8?B?alJqa1BOQnlaNTVkVmRieDZPRGNMWFlTS2FBTitrT3JRbStYMldXbUlKYTZq?=
 =?utf-8?B?bi9CWS9tMS9nZnZUR3pFSTVZeGYwOHNSYk9ENjdyZXpkalkzZFJFUG1Gb1NF?=
 =?utf-8?B?eU55Z3cvekxUS1VQVllUY01ITnFLa0N6cUlsQUpPcTdJL3BRN0ZUa1pPOWVB?=
 =?utf-8?B?RDEyUGxibURhUjRJZFMwTXVlZmFJNkZEMEJLUVRQdE5ZTjRjRC9NUzZiazBP?=
 =?utf-8?B?QzBjMS9LMGRLLzRxdDNoM2dlTmRIeTJ3WVdKT3h0UGtWd1RXTXJHbkRiTHV1?=
 =?utf-8?B?d3hhZFFaOSt3MjZQQjljQk40L1JGeFFtNURVMmI5b3JDNEtJWWo4QXFpdzl3?=
 =?utf-8?B?Z21mQ1FqeUVkSGtQaXpRTDBSWVNVeDE2bTV5WHVDRFZ1RDg2RHVxNjBWcDRi?=
 =?utf-8?B?NVVYVG1pWDBxQ3ZlSnh4T0d6VHJGRXlSWTl2ODMrY3MwcUNLQVRhMHR2WVZw?=
 =?utf-8?B?Yi83TzZ5VjJMd05QQWZIYUkvcFUrbnptWkhiOVdOeXhkOU50a0taSm9PVWhk?=
 =?utf-8?B?ZHhkN3A5ZVYxYndlTlVpL2xnZFZxRTZMbXMxZGV6a1R2NEx3a1Nra05Rc3Bs?=
 =?utf-8?B?N2NOSGRHRjNFd3NCbjRPcnZubFFFRFUwL1JlOGJUdHd6UGlnU0licC9Bdkt6?=
 =?utf-8?B?dDVXVmg1SjZhdCt5NVZDbzJCUTBtL01oMERUdEFrUjdmODlleWZnN1ZZaXAv?=
 =?utf-8?B?UElvQ2p5SHN4RHovNU04NitOM09aMXluWE5LQnpiUzRDSXc5VzJOYTNrTTZE?=
 =?utf-8?B?UU83TC9TM2lTTEJPUFFQbHdTc3FreHBiUWF0UDVueFdKMHdiNlhEaFJLRDMx?=
 =?utf-8?B?ZU5ZN0J0eUNENDlNNUhVaWdKYk56QU5BNHpFS1lTUExjWTJEUlBEMWxqSkZI?=
 =?utf-8?B?N0MyTjk5WHJNVGNQR2ttaHZOcGY5N0tHdUg0NE1zSWpvN2N2ZDBmQXpsOTZl?=
 =?utf-8?B?Q2hHbDhROHludzBNUnF2a01PMkpzWkwzdFQ1dWZtTklJRDR0dy9DUnV0TlB1?=
 =?utf-8?B?MlcwUUtrYXIwUzB5SDR5d2tTdXRUOFpiMWpqR09KWkxzejJqYWJjcGJHTmZY?=
 =?utf-8?B?OWRFcmpWMTdzbmJmaTJNZEplWXR2eEhTZFhBME1WSGM1dGV0YjRqeTFJazZs?=
 =?utf-8?B?b2FxSHRKNG5FM1lRTXFGZGFkNU9Za3hmUFh0MnQ5RzRGTEUzMk5PYW5CMXAv?=
 =?utf-8?B?UWhYSU9iWTdOcWZBZjNGNGIzMDQzM0RJTjA1N01hQ1lsUXBkZTlpQVY0d0oy?=
 =?utf-8?Q?KUG2aSi9646nwQX8WLgN2gM1BIwhn4KeJxy4D?=
X-Exchange-RoutingPolicyChecked:
	KHD1yaz/xUftQrQI5zj9VHwnysCxSPc1d9vjLyZzOg97L2iTG1CpBxTP/mVf3S75XxHWONMIUEoa61oevGx3fJ+BNicgUWLGiDc4Z1xAGlAxViFQ8bGaSvTan8DnM/FFrnFpj0DFsRqMTuIWqV3R65iB3AT6lMiCRyU5E1QKs5etyuwVlu3T8BY9n7iHf2ayzPUKq/6uLy2RN3OXOJGtMHM86ntv6iAPpyULblWkTvLqaR8oczN0JIYVvcOWsC/Qgi+J4AKoUM3TFnqUgX7n89G3Vi2+E/b54Eyv7aNmvy08EYhK9EnBCPyZ1vjjSIpnmPMaiY0b/lVWm2NweTX8bQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SmD1XlXlhAByNPC/X/9ynvSX40UrXNI/hT8SMvjjr+RbM2FGwgusaVBsWr0egDVia3BnvbnSbthUS251E8itGHAxGtprpklD/ASzdPn4JsJ2wHLbFc1YZ8Eb3dln94W4H/lbJQPboatSCDZdWCidm9LL959EJuTmwYH1rlXUNSYrEqciC5mvcu1KPsksLf1GFzn8ZYoO4d0wbkuHwIcJb7rsA3++0tsCWpdoeTZ5YKqjUBvp/zvHOFve4M8yRREHXN3XNwVCjunS46MXl3OrfJqG7LS+dNjfFVyzyjofbVAw11giK1zRivksi8sB90zVZ9klG7sHs2pD9fMREfE2fp8fILvDC3yLH2q1Q3dNtg8QBlWWCP0+EVdi2z2JukF/ByPboaeeQpQE/M0ZhmklUuIulI8ZE4vCYdl4V+YIWvar5ltDiuXonnelybgW9i3Yhk4V1weYVX1FdNwQVToJebZjBDkptsc6sj7auY1wnXROqRHelY5VJZSeX8Pyn+XFyjYUrazusObYKoX3HoHCk2bntJvdOaF0liKCtaPxwQftGJCRl/ohZE6exasUmrQaokhPIRc55kf+Wu9vy0k2gcJummenSQEXrXe73QSRFjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d1bd2f-26dc-44aa-c8dd-08deb1b892bc
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 12:59:03.0118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qx/xFU+L9nVQeViyKj6YgplpeZyS7dqnvP8za8uo6mJrn6V6BSynd5YtV2LuLJTeTpmEs/bStPn/fLsO442SB0kRpsVqHB70IuFredMCqWy6kb6f8g7Nt5a9ZjgEn+tp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605050000 definitions=main-2605140129
X-Proofpoint-GUID: Xl_L-L0CPznK6kaQSlpSerY07GPyoxWj
X-Proofpoint-ORIG-GUID: Xl_L-L0CPznK6kaQSlpSerY07GPyoxWj
X-Authority-Analysis: v=2.4 cv=fvnsol4f c=1 sm=1 tr=0 ts=6a05c71f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=C7urQHLkpUFOlMtZ_bkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDEzMCBTYWx0ZWRfX+9F8Nf/ax56N
 3bLBsiIx+qEowhUNCCDh39TyLWDaPHOyYbpxUq0vXx0P3dQL+7OjqXx5wYRZMyIXnskneuDeXtg
 HDfkrG0cdgstE6JbT4MJBBX3X/5FB/tjXI+z40TKE/vQ260KhDMnn3neLpbBr6GfwxG+TiMw5bd
 6mG0VbOxoJ8Sbo6IvcLDD86ROfWwGRn5LIqRcocxpk0XX2/kCUDGuEOXLLNiwNgDTm8zY8mQHEJ
 /05wc9cJl0PhQZNwsyWe9PqmcAHqVWCDzQGJcI0MpTOIPoGSWbv0t23xbWnmWY0pXNbh8yiaUnp
 zLuAX1qAhiTFQM36rt+P1r9RdVdGb10HiG3Sjfj7SjsLaMaBhxxWEI/CWlJBrAoFxial2tkDe0q
 STxiBi674/LbY7OT9cwQU/4GeEeZ2wrHXLr3VAln68Lld9zVkClJjMSJEq34qf3JZ92c2AOfq7Z
 grU4KuS6SwCABW/nzeA==

Hi Greg,

On 12/05/26 23:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
> Anything received after that time might be too late.
> 


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
