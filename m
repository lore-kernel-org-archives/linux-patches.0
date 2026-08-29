Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7029E299959;
	Sat, 29 Aug 2026 21:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788038287; cv=fail; b=k5+YW2HfE+afB/r0yOGa2nakCV9PWlY8o6aPHxRw7xNXKelVoOxRUaAUrQZNUzOcjmhvTcux2Iu5uGXjXnfwklcwkhxCrjhy+N5Nb7bRLpSxSunk7nSFLk9MI3+AsBHEuk1nE+rbWZbadrXHsYY5dw0wVkJPHtCvxOw52z4vHHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788038287; c=relaxed/simple;
	bh=nVh4SNwaT0BAw+Hw8Rcx4t1IvFJxCB+0H/rZfajf2jM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lwRJqTxM+zUw3c3aG8FKKPt74ZkhKw0N0jW2C+HTwzspJ/Ev736EnbV9xclF1vpJRjw/qHVSStqQ8Zksr+vg7CqEWCLVmXYH12EIbhus/rQYNkVKzGy+0B0z05XbAw9VmLWVRFcaQO7MRB5SzEmX4TmrDq4NEiMbVVB2w/77cfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hF/aokl6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iWmOeXok; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hF/aokl6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iWmOeXok"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TLCkW31709500;
	Sat, 29 Aug 2026 21:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sUA/tJeA4ebCf3L6nGzvzFcNNOIKEARmYcy2Hcuhcv0=; b=
	hF/aokl61/e5fw4zaw8hH8fczahTlIGtG22o/uDu6H/yKakPNJN2OhdOLzaNGwqU
	xnricVUMR39bPP9uV47pSPAANeWyAT2/gG9gYM2HgLxCsVyd6UQI29o3yFkWCUdl
	vyZmG0obF8UEYZoSf5wFt4bzhfE3XDwvHmYHz9k7OnNvbgNiYC3B0pJTfeynY8NY
	Rdc/ObxRDORL5MbN38q7UwLxHi2bw/TH3NSKJpjm/0XQsYujxboi9YJ6PTUf4Jkh
	AIYACvhrW/ja3oX3KIEoAGDsziSUCRmmAN9Xx+wZ8lJGspFahfp4LMKDWRFLb+x1
	b2bzEFJPN6Tef/3qqJo+tA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xrnnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 21:17:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TLF6qY037964;
	Sat, 29 Aug 2026 21:17:43 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010021.outbound.protection.outlook.com [52.101.201.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbgdq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 21:17:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wi0u3GyURFkZVek/e7XLLA5whjjCv8aTqGL+xqvc2nmcyB2ra6nrc+qhRAL+TnQRLNCxTEGTT1giFIU0YPabDLUbI+l2yIGCy4oTGNmPuF7eWrNekp0+/bRUyCTVcX5s0ETZiSR20X8E1U+mdQ6W3+Odk5f4EctATMS05pNLZ+RnGxNpkFzFPGOw7JVizN1Doc3ur1wAzfmqklGfSt2KZlsOCyhiivF7dn+qsj63+G0YI8bsE5rG+wrcth2Z6vDP39aEZJxJWRKDr1ppB6R2lgVaDOrVRtPxlXpX56MsgR30Kp81SzcHQVak15apF7rzsxRfR3bWu6/qYSfcAOwC+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUA/tJeA4ebCf3L6nGzvzFcNNOIKEARmYcy2Hcuhcv0=;
 b=MS6gUoFPquTRzFrzZs1AMuNFcgggY+eFPI8myamDDYXRBTu12/bdKeV3FB+YPpAOVVIRL522hoWWVBi5xlMRmSw23roK7ZBsFOujxO0xA+t+xiY7oqsHB2r8ZAyO1TZfDUCZrmPqdswKSN6ffFVxzRylzaC1jHKnHYg1dgk3T3gW50hpp+rUGb5qHRIyon4HhZE/3xUPQbtC/R5PxavGWi0iQbMH8vPaoiiVrAP4DHzv0cvtKd+V9Vp0+oTa+CusHMoRzRCSvh3a3Vx71RmGORjmLY39eQ6kjbdR50dGforOCUSbrlTRP8rIigZHFV9G77FgPsmkPzBYexAgaw0HHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUA/tJeA4ebCf3L6nGzvzFcNNOIKEARmYcy2Hcuhcv0=;
 b=iWmOeXok1h4fffs/oavjcxG8L9z3+Lyvz0VIOvMurUih2Cdh9J+QWpmLsvo9Eo98aJEJf8qFUctAJ/eazNXz2lDkdp7K8GZ7SyuFitjbWHpr7bcRkKBNmeavZgft5VIp+yGpXp3qucryE4CcUaC5Caj5DxvcRmNoaJJ8zpiSceg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH7PR10MB5675.namprd10.prod.outlook.com (2603:10b6:510:127::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 21:17:39 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 21:17:39 +0000
Message-ID: <6e859ea9-468f-47d3-b462-86c1b629b6e0@oracle.com>
Date: Sun, 30 Aug 2026 02:47:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 050/456] sched/vtime: Get rid of generic
 vtime_task_switch() implementation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Alexander Gordeev <agordeev@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260817132539.792407575@linuxfoundation.org>
 <20260817132541.992143810@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132541.992143810@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0091.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::20) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH7PR10MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: 1689508d-ee19-4451-93bf-08df0612f47d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|6133799003|4143699003|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	pgjN+HWr7brkTuj0XmC9u3mXuJIttN7Ag/5i1YktQ5OGFtZv12A+V/fCR890Hey8FAJOTSAOXL4ahXuPm2zeomNzB0akzAPsXvr+8KgIs8s4l8Rok5aAL42ZqUYRWZ6uQYMf/w4DBtwQFANuWsLAP85fZRaeanRR9LR1KOcI/nFEjNkJGxoeAvIgLpPeWyBXUqt9ao75CW1ZtjKEofpLFGLYNDfBBp9DpoaZu5RwuQzQEOlXCR88NdWShDGhshigV/p00MdR9JHe6tPuEZSpG1/uiDal8rJxPsQzNlf5EnlAJ2aGgFGBB2aV/5x4UU99dEcpi3QKHEuSSuh9MbBxWPReYE/INa14cgkAkbWfKVUuUigvIxL5SBFa01SeLXeiyZrZrVd3PqKYB0FrToD/cOAZajEBcgf0rjTCf0hWg9/EowNXkj+tu5M/hqql9AnPOSdanTe4hCV3Dt5bVk9DsqiB+lhTesTv32yFqhjxLuSd5kPGkz2KQEUQqjtBHHrwpDnLtg3tN9znNFv9CBn8I/QLu56DMaLIcJjH8hkLfxbFkxZt+8XbHkynJGShdZCJcwI20QQTEWyvncmDgEQGcjCEo3Y7Di9zql2hb6DAiJEPaar+8ya676k5qGXgXLRCtCNNR7dRpg2qHABz4fEDjw0nzbrQ088ktgzjBIjEii8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(6133799003)(4143699003)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekpJVGxtQUtqSmlNZGtKZlBudGJuMHVRV3NuWUpzc3pQTm5uVVgvbUw0OU11?=
 =?utf-8?B?RkNINENGWFlmcHY1eXpLWlJIelZaZk5wdzd3RlhVYU5DTzRFWFdFU1krbHA3?=
 =?utf-8?B?ZXBGUktTeWRud3Z5UDdzSkxPRkErVkx3T0NxV1N0cEJjdERhODJXdTV0NFpG?=
 =?utf-8?B?QitSMm5TZnBTMTVHeFJzcTNnWmJjb05QYWVTUFplcVVxQ05sM0RtNHJtVmR1?=
 =?utf-8?B?dVkzVE80T3ZXY2xNZUtJckp3TUhqc1RtRkRRMXhxcmtRNlJ4T3pIS050T0U0?=
 =?utf-8?B?cWtSZUtpc1RLYVcxdHRyRHQ0ZzJvRFR3dGVBcjZ3ZjRPbkh5cnpXeDZlVzNi?=
 =?utf-8?B?Q2dDd3VuOTdoYmZtbWFWeWxHY3RGZm9vMVNzbGl3cFFlUnFwcnVrT3poclNj?=
 =?utf-8?B?bkhMVFBxaDR2ZENqY3pEcFpQdkVJZVc1WElxOVZpekRPb1hLcHVKcm5VRklj?=
 =?utf-8?B?dUdYR2FIZ3hRM2U2WkpvYlN6bzVLQzZCMTZNdU5zby9jS0xzR25kVFdyMjJ6?=
 =?utf-8?B?M3FESmQ0SjNXODlqQ3FIaUZZQy9Mb0tubnJUQmcrd3cramF2ZTJRcFpwcXNs?=
 =?utf-8?B?SkJnOU5PSS8walRiT1JJeTlMcU9razFyQmxPQlhCT0VFdVJkZzc1UEdzRTVD?=
 =?utf-8?B?VklTQTBYbHZ2cmFZMkNyN3dFUWJrMCtjZmg2WUtLMGtJSm12alREa3V5NmUw?=
 =?utf-8?B?S0RESU5tSTg2N1ljZFNsUTRDRHFQQzlMM2RWVGRwaXFwSC9WT0RRMzIrZ0VN?=
 =?utf-8?B?Q3NHTFR0U2JmRnQ1YVNmTS9ETUQ5TDlXVG5PK2lnLzQxS2ZtYVhNNDBFSzBz?=
 =?utf-8?B?bWRaZDJjVVBnRHdQeUxLTDlNOEdLV3FUSTNocmg3b0JyQkFjR3h3b2h1aDN5?=
 =?utf-8?B?dTAwaytFczB2allFaVYvNi9sY2x1OG5QUTlwd2FJRmwxZE9semt1bnlSdmlL?=
 =?utf-8?B?QzJsSTY1bnlpczRKOVcwcUZpUVYvTDlldWFrR0ZuNnR2Z0I1RUdISjhDUlRl?=
 =?utf-8?B?dU9EZFp3NmZmSU1MWVh5MHBoVHpaQWNPN3M1cWp5T0JXcjFOelRvNUxGMnlB?=
 =?utf-8?B?c2NYZ2FmMGlvUkNwRFUyWUFzN3ptakRHV0VES1JVS0doSW5zSkpUZThNNElr?=
 =?utf-8?B?TWJYbm9kMnRGUHhrTVFUMG9VWUNuUXEvYW02QjlGS0pWZmZzN1RBNUZNWlIr?=
 =?utf-8?B?ZUJ0U1FDRXltYTJzMzEzWW9QV0l1WkxLUWFHbm5xSFpSd0o1TmhVenZ0Rm9U?=
 =?utf-8?B?c0NVZlJTcUFzdUc4VWpJTzh0dnREcDBRSjVsTEMzTGtaOUMwRG1ZWUR4NU5u?=
 =?utf-8?B?Ri9RUlVDOVRWa2FNbWZ5MUNXN0phRmRJcGFhL1JnaGIrbmtnMHlsZDFIa3Ur?=
 =?utf-8?B?c3pQc2EwRVNWeG5oMHczbWRlWmVUVEYvY3hXdVFaWUc5cjVRZ0tlM2NMRjdN?=
 =?utf-8?B?ZjZxY2NSS1RYeXAxck5QV3dObkFieHBFeUdtT21BclZWa1prYlczUlZqVDl3?=
 =?utf-8?B?K2VYRHQ5MmRicUoyNjI1eDY3bFZFNUt2Y2hZNmk2ZWk5RWxqZnVoa21LdkdL?=
 =?utf-8?B?eStoR2VKK1dlNjdWcWNSUGpiV3p4cU5xdE81amFJcVRWbmRGRXZPQzNJV3kx?=
 =?utf-8?B?cDJLYXVSWGRqdUovaS9wTDdYRzcwamZ1VlJoVnBmMWF5UXB6ZURnQy94REdn?=
 =?utf-8?B?RUhuS3ZGczRXL1lTdHg5b1V5dVZjdHhrdTRlQUkzZDY4WGV6NGVVbFJsRGtN?=
 =?utf-8?B?UGpsRUtUS1paSTZPK3FPNG1rbjFFOWQvTVY0T2JJc3dUaFBZclJsaThEc2lk?=
 =?utf-8?B?Rm1OY012ZGpJR2E1ZlBOSCtWaDA5Q2Yrako1aG5yaGdwUEdiUldVT0V1U1Zm?=
 =?utf-8?B?dFArc1N4Rm9BbXd4a3podlg1Z0I2b0lkYjV4ZHZwaHhCN1FQOEdGcU5BQW1q?=
 =?utf-8?B?Y3Z6N1VWR1FTancwa3hGd3hyMEhsRXFWdTVOMFRMcE40OGlPMEhHTDJramhm?=
 =?utf-8?B?bmJxcWFZUUxzMXZzanY3N0gxc2tRNmoyUTVBVGpFV25nOWM2dFErQ2pOZkUx?=
 =?utf-8?B?ZDlIWGpYcktvTFNRcVRQQStPTXFvelFBalQ0MkZnZURuSUZWcXNURDZ4d214?=
 =?utf-8?B?ekh5aUliQm0wQVZyZzdrejlNdEZXdFFMeWZZS05vWDNxaTRWY2tBcnlaM2Rw?=
 =?utf-8?B?NVBLdHVBbFFkb0RVNUhNbVlDcElhQk1LZ2N5MVl6Um1wN3Z6UzB4akpoeStW?=
 =?utf-8?B?V2s4OGlkNW0wcmVGd3JpOG1oZjZmWlNDSndDSFE5ZlUxMTRUNjZ4MXNiK3g4?=
 =?utf-8?B?VzRaN2xjZ29QZ1RFUlhzVDFDUXdkcC82NkdTQ0NHVnJNYlFtVHlFRElQTVJH?=
 =?utf-8?Q?eqIOvlXBarZNFvwcaWBHFTJREL8F74w3+vaba?=
X-Exchange-RoutingPolicyChecked:
	g6MAPPTfAMPX0jCEX2DAKsREnwuZmu/bHyS7VFfAzO+wk5PtenhIo1ytV6Zfp7yVzfjaUKqYfJpSKdAZTGTP/y/5eCldDAqIgoirve1GHtM1e8kgoSldWvRIH9t38GB/zBVKyfLVb1NQx2TKlYojUoS27oooohfvhMlch9NISGdyHEAzcx398/CZl/tHWrOflxRHS7F7QF6lNHOL/BW+C9HOa7I1NI9i8/hPSFWjKwuESfDCyZTp1HTWq0rwbBfA3xDZ3EOjlT4z2JZqWZk6UOVUvUTc7cfHkrAWY+Y1IgxkNHiuq0joyq7A2NXI9GTViLfSHGaDm/IysjkCEl3I3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8J1l2+M3F90YOWcuZvpJWU6CVjdmIr1Z1k6cdCeo2OQwtIpbwLI3Gxz8dn+N/5DCS0mxFHqtOw7eUGhUzbTnNMFTmWh19KEfwBIavMMFSk8CkZ/jdN22Ta7lp+25gRDTs8PzIEmt3F8m+aCMy+AW3CnM4riD4wLhJZwAaFj80ZvZqHl6MekqZaq0qyV2eOOOXtVcuvQN3DDkBk/aDS68b/Uo/LyHqGz7bKNcAZlUrWQInDKTxynNXPA4mGRJqdGr3Cdy1YPo06Z5N1YQHSrFY9qZPxR3phvi6Zk6f8N16Bycd7oOoGpWvMYFCIM8b8xiCKpsgp8Z3wOrvT5Qb44tXcjAG89lyh3/k08ZYPmkdS9D1hT9O7II9EWFd/EFNEt1j4nDO8Yx5IczkuPQbWJLqvg+Uek+iVtBYSFOsD0VMpNWIYlayuvVvFPf+F1YCsDksLQkqGRkvy8HMQ38v9c3FDYtOPgqKbQYSgrQ5SrjPu2G6Hp3q/x7tcbgVfeOtWk/UHEQvWtKFGqXZW/RFtE9uPURtz1D3zaaqGQYCaLH/mXW9TFlIpjlRR4XXvsiscmuz33hllGhzsVfsootlnOgwZqjnxFPm+sr7d6A9mNHqqw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1689508d-ee19-4451-93bf-08df0612f47d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 21:17:39.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DE5wfvWdiA40Inz0+CsjySb98t8RTNSS6p6b9DdbpGy0zfR9EOLnqJxat/JxF+SGXcnLqVTuc7kzZqNzBcQdpxhq/Qvmee8Fc/4hl3xNKuseVH6dwatxZm2PJlgbJlxH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290184
X-Proofpoint-ORIG-GUID: _OQgEiJJuUwGFGNrOPit3uPpCyr94XYL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE4NSBTYWx0ZWRfX7BLg3xr9X7PI
 WyyiwulJDSsKkZ5dSRA73GgNCtYHfrVCxjpvqa/r1etoddpw2djKqhJm7pdY6rJvorM1hDPvunN
 QE1dn/G6/9shhFJ6/fmMaXr2s4nipWpATwxMUw6FnF2DlkCdY/ZEVgoY4mVkzHlV54UBFhc/dwN
 eBCxZRKufj767PwhyXX4O7kIa6ZzEdrMrtfsa4ur7DQU8VWqN/YjhxyeAJnKYUamHsfoXUqfLBb
 z3DppTo93VJWqbX3pnaDbHgF09Lear9ekjsmOdDroHS0tv+29U8aDXPshzgVy4dVoAtKn9MHZ0G
 tDNj445D6BgyUSlYPqOuErgrFC/w8qw0lcNC7cJRptZ21KEqLiW8qikd8ay3nMBvAupTzfXA2Wn
 nbDC9zDcilDR2cQJIKEDlJwZ0Z6Ljs0semXGjPFxWSj0Dyhl1bik/ZtwKvmeSZyk6oRZsY2Oo7t
 nXL0an7i0yr8R/T/FRQ==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a934c78 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=rCeK5E6h5QI9kuc6UegA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: _OQgEiJJuUwGFGNrOPit3uPpCyr94XYL
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE4NSBTYWx0ZWRfX7Rz0cww9Qo30
 P6zwP4uS5Yq8T5AgMgsRe4iMlSnpbzqAJT7z6X2hF8xRqJdoH3nvkLJG4ZP0GupBMuoQzhLChZp
 kLJycMbGA60Wdmm7dm/qjdY3KSM6P+tlfKHzKlQ3PEgUx+izV0zz

Hi Greg/Sasha,

On 17/08/26 6:57 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> [ Upstream commit 89d6910cc562ab34d1f1c08f3cf0a9700b8bf2c4 ]
> 
> The generic vtime_task_switch() implementation gets built only
> if __ARCH_HAS_VTIME_TASK_SWITCH is not defined, but requires an
> architecture to implement arch_vtime_task_switch() callback at
> the same time, which is confusing.
> 
> Further, arch_vtime_task_switch() is implemented for 32-bit PowerPC
> architecture only and vtime_task_switch() generic variant is rather
> superfluous.
> 
> Simplify the whole vtime_task_switch() wiring by moving the existing
> generic implementation to PowerPC.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/2cb6e3caada93623f6d4f78ad938ac6cd0e2fda8.1712760275.git.agordeev@linux.ibm.com
> Stable-dep-of: c1c1ffa490fc ("powerpc/vtime: Initialize starttime at boot for native accounting")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/powerpc/include/asm/cputime.h | 13 -------------
>   arch/powerpc/kernel/time.c         | 22 ++++++++++++++++++++++
>   kernel/sched/cputime.c             | 13 -------------
>   3 files changed, 22 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
> index a23356c05af193..2e5cc3abd92df5 100644
> --- a/arch/powerpc/include/asm/cputime.h
> +++ b/arch/powerpc/include/asm/cputime.h
> @@ -31,23 +31,10 @@
>   #ifdef CONFIG_PPC64
>   #define get_accounting(tsk)	(&get_paca()->accounting)
>   #define raw_get_accounting(tsk)	(&local_paca->accounting)
> -static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
>   
>   #else
>   #define get_accounting(tsk)	(&task_thread_info(tsk)->accounting)
>   #define raw_get_accounting(tsk)	get_accounting(tsk)
> -/*
> - * Called from the context switch with interrupts disabled, to charge all
> - * accumulated times to the current process, and to prepare accounting on
> - * the next process.
> - */
> -static inline void arch_vtime_task_switch(struct task_struct *prev)
> -{
> -	struct cpu_accounting_data *acct = get_accounting(current);
> -	struct cpu_accounting_data *acct0 = get_accounting(prev);
> -
> -	acct->starttime = acct0->starttime;
> -}
>   #endif
>   
>   /*
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index d0e59f427fd6f1..65235323bee49c 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -429,6 +429,28 @@ void vtime_flush(struct task_struct *tsk)
>   	acct->hardirq_time = 0;
>   	acct->softirq_time = 0;
>   }
> +
> +/*
> + * Called from the context switch with interrupts disabled, to charge all
> + * accumulated times to the current process, and to prepare accounting on
> + * the next process.
> + */
> +void vtime_task_switch(struct task_struct *prev)
> +{
> +	if (is_idle_task(prev))
> +		vtime_account_idle(prev);
> +	else
> +		vtime_account_kernel(prev);
> +
> +	vtime_flush(prev);
> +
> +	if (!IS_ENABLED(CONFIG_PPC64)) {
> +		struct cpu_accounting_data *acct = get_accounting(current);
> +		struct cpu_accounting_data *acct0 = get_accounting(prev);
> +
> +		acct->starttime = acct0->starttime;
> +	}
> +}
>   #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
>   
>   void __no_kcsan __delay(unsigned long loops)
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index e3022598f7b02b..d71c4817996b32 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -406,19 +406,6 @@ static inline void irqtime_account_process_tick(struct task_struct *p, int user_
>    */
>   #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>   
> -# ifndef __ARCH_HAS_VTIME_TASK_SWITCH
> -void vtime_task_switch(struct task_struct *prev)
> -{
> -	if (is_idle_task(prev))
> -		vtime_account_idle(prev);
> -	else
> -		vtime_account_kernel(prev);
> -
> -	vtime_flush(prev);
> -	arch_vtime_task_switch(prev);
> -}

^^^

I ran an AI-assisted backport review of f4b5a7d855d2 and checked the
finding against 5.15.y. The backport relies on an upstream architecture
invariant that does not hold in 5.15.

Upstream commit 89d6910cc562 was applied after
cf8e8658100d4eae80ce9b21f7a81cb024dd5057 ("arch: Remove Itanium (IA-64)
architecture"). It can therefore remove the generic implementation:

         void vtime_task_switch(struct task_struct *prev)
         {
                 ...
                 arch_vtime_task_switch(prev);
         }

and provide the remaining implementation only under PowerPC.

5.15 still supports IA-64. With CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y it
has:

         extern void vtime_task_switch(struct task_struct *prev);

and finish_task_switch() calls that symbol, but IA-64 provides only:

         void arch_vtime_task_switch(struct task_struct *prev)

After f4b5a7d855d2, no vtime_task_switch() definition remains for that
IA-64 configuration, so the kernel fails at final link.

Maybe we don't worry about IA-64 anymore ? So nothing todo ?

thanks,
Harshit


> -# endif
> -
>   void vtime_account_irq(struct task_struct *tsk, unsigned int offset)
>   {
>   	unsigned int pc = irq_count() - offset;

