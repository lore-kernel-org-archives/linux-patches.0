Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81B3395D8B;
	Wed, 14 Oct 2026 21:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012199; cv=fail; b=Zjgj/T9UcSAZEq9S78BEHt1iDM4TIy8D/9brbrWW08j9g6QTfwn3Eb66QB5cRg6dMVPlz9fAZjQUJwAoGppFLOWnXK/hIW3B8UuHp/H0H0suectp3p03N1VtTJJEgYa80m5AvLZUYG2NoZd1p5vt5xE1qxR8rptlDTLQaWzdt9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012199; c=relaxed/simple;
	bh=MB40DIkCjMGxXHxypvXIQU+Yy8xQntwgQRpaLlIwT28=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lwwVLXNmXNyIyrPk8ySGAwFgdsR8OGc6ulZXALJ46wWTjeiayf7HNdomD7aVfHJ2N+naznw6T7FbOWyqY4sbSgZFgawpfs1CTeGycL1xDGQGVXWhWl/+ffNeE2N1KnCxKI4VCGtJFY3o7J1dxrpGFnBZCfpVk6J+aEFjSVMsa2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aQ3LRGQc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eUxhEoq5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aQ3LRGQc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eUxhEoq5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EL0u1s3615130;
	Wed, 14 Oct 2026 21:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zDS4T4iRWQO0ivXpDGmRaooOVFinN+yfZx09jYBRN2Q=; b=
	aQ3LRGQc+NqZqmQddcz1gi6U/l2l9E1hVt9U9GIjaDxj61NHkjG+KYINegEHIFex
	T9f36cWG71NfdVwZX++U2fIMw+VIZtlQeDum/KBOk3G/98iYjyPbflcV2tooqTb5
	ERqNlPzI2hfV/toX9Z2fHaPLhFslxwJO2J5+GRTuxOADirrzklBFxRp5MN0IALpd
	6q0bhRtyOYXNFuHjdsUfNzWYFsWmPON/uPank2vj3l8HA7uBx2Bp9B7n+nxenZMh
	ZvzCCjAJEcgBVKVfRgZtRdDBRngdaiGIT7pcAb0H0FarPnDG62V4esf3coGhSrQ2
	UyOYBQS/b87oVPfd0brsCg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1pys8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:09:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69EL6gsl031071;
	Wed, 14 Oct 2026 21:09:51 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btmvj4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:09:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AZ7kEmEwSqnWxJ2QKDHxQNycx6oDQEhBm12qp41gX+9goLb7JRpQakj0198Ic+ObEMPxzBpj8kUC2m5iSwPFQfowcPtyTbdO7AAdAEEBJRde60YorIyN2c9DbddrfjeGjZItj4EilZkeNJRQEqoeOciyCiG3vJnOuaRQM0ydGkJ6LDvXTwY+pGlEi9RPlT6Vu03VteTQyAiTr6mkq7BVSfYsskLhDZ9zsDcLqL212ZXSbcNoNwW7pvaIm3HiE/MWYzB6mXTcdePcSZQe7xpnw54XXe8oeQTjHKRwNc7qykYwBiB0f256WIKov0lD5q2viuUquiCrfAvnucjJLrvoeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDS4T4iRWQO0ivXpDGmRaooOVFinN+yfZx09jYBRN2Q=;
 b=d5NeSwKnlcfVW6Q/KLk7GYsEwo62Thv3I4VYS8gz8faFHtY8YxzJombGDyJ3QFBGU5Xy08rKUsCx3ULbUbtk5ny9VYlhnk0vVB4qlcQg8U/iAcsy+r5KIZGIP9ozoYMOynO4FlaWAPUY4XuMJaIEyMb3Y8jFs408Ux1dV+K9WABR+CyZxbOCa+iEWdR/3K5K2pSCJ/A5RW8ER2yadve/GktPpODKnjPDO2KAWI9w82i4wRXoG9b0MgVOz9K0Wq7QN+SS7L9irv5oWrVJGX2wiriDJwvOU8CI2gSx1B3S/2Xk/NkYp2bOFfxnn72IcnUUoKCJqA+dDLS9v6O282nUWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDS4T4iRWQO0ivXpDGmRaooOVFinN+yfZx09jYBRN2Q=;
 b=eUxhEoq5DriEekppDjtcsakey5c3hqGX17uwwo8Vcb1l2uywUZn+jzasfqdIzMgnkCSa+YpPUc4E6v0/P6+Qvs86zjn54AT7Zul+GWIZqgFFSNgslO0K7nDYnX2ZbyKF9ObJmmEGfs4spAx21+ixNkJGkDAzl/9DZV1YKIcRXag=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH0PR10MB4890.namprd10.prod.outlook.com (2603:10b6:610:c9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 14 Oct
 2026 21:09:49 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:09:49 +0000
Message-ID: <8868e018-3be3-4de1-a066-5bcdf7aaf124@oracle.com>
Date: Thu, 15 Oct 2026 02:39:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 130/497] Input: synaptics - limit T440p InterTouch
 quirk to LEN0036
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Daniel Salmun <salmundani@gmail.com>,
        =?UTF-8?Q?Rapha=C3=ABl_Larocque?= <rlarocque@disroot.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112910.975677311@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112910.975677311@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DO3P289CA0009.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH0PR10MB4890:EE_
X-MS-Office365-Filtering-Correlation-Id: a5c5814d-bdf3-4810-5e70-08df2a377b48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|261009223027099003|10067099003|5023799004|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iiptCLs9lP/ARSB7hhkzdx+eHHUcupRTjufAgI91vaWL3m8ZRBcESHVss0l3jj6zJgGiuAmS++HFjOtZTqaMx0XA7MnVgGa9Cw3ePvonGJYppA9DTkGT0o9kh0bDM0oyAkwTEJcks2Oimy+AH6EID6tAkfmki5Ygwc4J8bq1ojXnHEAMO4KYr7RttnWAbD/sVrYPFEDJYjR04bXAReOyw2pUwrBUGCDPpx68kvu10Z/ndZLwc9n6vYRbLBKCjT6AepX9VsmZkQglvXwVIXWbcIa/7aB6AOjBj9s7EAAg9+KzmJ+BCcR3dn1zkllEL3VQEiTvCrCoNKIAUGpSOZcn8Hl1aDo5ZorYGECXxFF7i5QQzz0rR/rnlI3N3IwUfuKgNztHpxUquQQKePfnT5YdoKNutkdRjzFkPtNNQ9eyiivb2T+7ZjEhy9gFr0+/4KcbqrfcmY1cg2+2ar0bNTT86y48Eu+tlBvQt5jEGdvy6RYB+iQbl1AQU4MnXLRBL0cPayLLqNa2h7YuDp3NKugGOqG5Uft1zsVEzXlJwnyA6ZugcViNDSu9wRtRuSFd993KhjdXvtu+grQOqW1cvmtWO7gGOlX/Wk7GjKLwsnm/mggdOiLt0SrzhDFhv672wkvj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(10067099003)(5023799004)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkN6OHlCcWEwQjJPS01adW9vTHk5UjBtUjQ3Y1pVcDB5eTc0cHRQMnJQTEVL?=
 =?utf-8?B?K3hWTzlPemMxWE1sbE10OWNDZEJMQmZMa2Y1NjZNeko0RHpJd2s2YnZEcDNM?=
 =?utf-8?B?dC9qcFc0TExMUHVsYmwxM1QyaDVIOU9weXBGUTZFQ1ZXU3F1NFlkTnk5WHVu?=
 =?utf-8?B?YUUwU3kwU1Bmdm5LSllTbmQ0ZXcyMGNlMGNJeDZ6SGZJQXQyenJsaUt1RkRV?=
 =?utf-8?B?S1JodzJGT0h4dWtpRzROTWNva25zVkREU3p3cEwzemdJMUZkeWxZUXVrcWJU?=
 =?utf-8?B?dHNkQjJSc0pCSGw1dzByc0dDalVkZFE2eGg5cjV2WHhvcXBNd1dnRkhuVnNl?=
 =?utf-8?B?STRvODdYR0owcEtWM25lZTRDQVdhUkhtMDQzSTNaeGl1NXV2Q2dheFVmdWMy?=
 =?utf-8?B?MjkrQnFyQ2ROZVVBVStuZjBpSDkxdFZPOW9kUERtdlF0SGtPMXEwYzBQUXg0?=
 =?utf-8?B?WVRxdXVXSEdCYnBib0NUemtPTHJCSURDaHE5RDlJUTRHMFdiZVpNOGtlQWxP?=
 =?utf-8?B?b2MxYnZmVllUb3hYakFYUW41cnRzUGczNHNxYlFKN0dibi9FVllRSCszZ2sw?=
 =?utf-8?B?UURkN3FTRzVhQzA4dW1vd3YzWVJEWk5WeUVDZ1RENTJlQnlCc2ZCUnZ4Vysv?=
 =?utf-8?B?ai9UNStPRnVsOXFUdWpNZTdJcUJVKzB6WWh1SFphQ0lJdjkvVDErRlppMjFV?=
 =?utf-8?B?MDFGRHVQWjNUL1diZCtvUUdCQXMzVEVJMXU4SXd2UzYzK2l1SGdBckZCNVNq?=
 =?utf-8?B?NHd0ZjdWYm1tRTZzbTZVdTk5QjZlektLKzFESU9ZVVYzZ1FJRkRRNkxUQlVL?=
 =?utf-8?B?TzBWTktMYmF0S0IrNXMvYzR5Y2p6NVdpa3FOUWdZQ0R4Vk5ybXRRK0pBYjlL?=
 =?utf-8?B?NEtldnNqVGFTOExSYWU1aDZZeTdUYTg5TVh1WkdMajRBWjMvenpWNWhDeXg2?=
 =?utf-8?B?T1FSZzJFcmxLTTFhSldVV2pDelRJMnhFZXpwZFlGZHI1V3ozK2RBQzlIcVVN?=
 =?utf-8?B?eGF4enNiSjNTYS9jWS9LVDlDK2E5Rm1zTWFoNUswWHJaZFRzQ3FwVyt2N0VQ?=
 =?utf-8?B?WEZHRGRIazhNOXQ5WElmV2o0WEUxZ0RuL3RzdXNqNk5oREtuOE1VOE92YjNz?=
 =?utf-8?B?SkdtQmlsZFVtdHpCcGw3SzAzNlk0d2JuOHBoSEYyM2N5MzhKL1NBUTlLMDZv?=
 =?utf-8?B?UTYrV0JCU3pUUm04ZkQ2TVEwRFN0Z2RBdDUrM3Z3NktRT3lpM3JLQW1lOEx4?=
 =?utf-8?B?R29xaGRXSlhMOERtb2x0QXVGYnc0Mm1jeDNUTWNXVXVzVzRWdFFpREZLdnU0?=
 =?utf-8?B?aUI0LzdIZzNCZjJKLzEvcm5nazF5S0F0cVRZZ1ZNQnNjMThKL0ZlSmlqRG0x?=
 =?utf-8?B?bVI4S2h0NWx4MEZubmxEaWFDWHI4WlhnVE0xcGxFUVVaZURCUmt4YUpLZXl4?=
 =?utf-8?B?dWZKbmplMjNJS1laTXVYc29RMXNqL2xPVlFZWVVUQjJvT3FMdW53bUs2SzA2?=
 =?utf-8?B?TW5OMDJick00cjNESU1jM0N6YWU4VGhDMnN3ZU1PaUdKYUNrSTluSXdHVk9E?=
 =?utf-8?B?QTlLU2NDMjk0RzBWNTJYbHhVWUhyREduckFpY2VRc1dva0Ywb3MyM3FJanFQ?=
 =?utf-8?B?aHNZK0JWMS96VWJvSGJWUVhRSXNkeTVmV0NGVkNmRm4vYTRwbjhYa0hocTBO?=
 =?utf-8?B?c3VWRXJiSS9JL1k2NDMraEJDYjR0QkErUEs3T2U0RnM3TWc2V1ZxRTdGZDQ4?=
 =?utf-8?B?WUZPRHVCbldSOEZHbG90SGZjTU01TEVvVGN2Mnd4dERoVll5UHpqM2xSOHZS?=
 =?utf-8?B?ZlhHU0paS0lOT0NWdnBXMVlRdlNiS2dEbEYwYU5YbUVOYXIwOUo4VHc2S1ZP?=
 =?utf-8?B?eDRFcTZJbVRiSGFtQ05PYlMrNUVQN1JDczBmaUJqNGwwUXFDazJRQzlrMW1Q?=
 =?utf-8?B?VE90dkhmblpycXBPM3k3ZC92ODBqUVhqUG42NVZrUHJTOVcvS3VpeWxHQnp1?=
 =?utf-8?B?ZDkvQ05meVpFSWoyYjlsMjZSOFEremYwUG5PTXhJaGdyZHpnQ0YxN3llaGdp?=
 =?utf-8?B?TWpvbWJQRnIreWM4YnJ3enFrNFRYTk10Vk9yOWVncXg0T2ZEeGp4MDJ4T2dy?=
 =?utf-8?B?VWtvbnJDQTJOOFRpYXM4Rm0vVzBFMm5SWTAvL1orakZFT1VLUE1GZksyK2pV?=
 =?utf-8?B?MkNzR0tEcldlY3BMWkZqWTZobVM3SHVWNzdkbjc0Q3JYMGdTK3FSeWh5TUJX?=
 =?utf-8?B?WDM0RnFCNTlEbEYzOUhiV0NVc2NLNnVsSkNqMTBVeW5DQUNaQkRocTQ3bDhB?=
 =?utf-8?B?dnVRZlBpbGZqcmZGbnEvakJxSlRRdERHbUgzbW5sRjR0QVUwVWlYYzVzNU5p?=
 =?utf-8?Q?nhL4B1D8cFGA9d330X9aCiWzEswtFrQnmlQBT?=
X-Exchange-RoutingPolicyChecked:
	IkbyQU+N2bEYh4K5/QyNTLBUoHSi6g70w/Ttw5BibH3Qv1TNagOyx9TJALGkAwXH1phj5YgyOhBZwJYiYz+bfRe+ljliriF5Tg06m3Y8B7Y9JBN5RvA4lptdxvargMI+AJu3V8UnQ2EtX/NyYRbOO7drdpxF5w2ZgGIeIhWFh2tRqOzmhvbjQAMeg1bwCh0298KB06NnpR34lRYeBPtWfX0vhcAl9sNU5sQslhbr21B9X/bhZ4vNK7Txrt1tuQwyLV0I4XWkIOOUk2zBnlDzSMLeGePZhZSBx0gGIU+3tz3PKAq/H1vmHmTiTbZQvn0cwZVuzSyJnl9ugW2yydp+zw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i2miaYKk2p05m5c0h3HHqP1MDy9disSA2UbhSJs6NogNl7SbdMstyRt6ThLkAm+M2YOiFhQ5HYIi1gjWlNN1V7qPyLNYNj3PebkZ9t2Kh+1e6olo2r+Wx4TKccLDJkGyP93GqI82jv1za1n2mKyRzblonQTobgvi6cnBpqUZ+kh2sHwb8BQoFglcdoqxtW18cLgbd2LUZQSLVnYaIBdqZRvJBzBdJSEUZdXT49cfwz0z7DvcE5tnnIy8EV1DduenA/lUqNXIGyMlO6aH+ycYDJ/PWch3VUuEJaYOBLYZi4ZKSohprTZr+P38y8kY9O/u84lAFqynbKq514cTQ3REKRyWli/33+kNC8W3Rv4F+VpVkLVsIDIh4wStJ/Cqgjpupr0gZjjv72kWVsvDOl/B/34Ep+ew7m42hk4u3j9qkvqL3Ff6FXNdqTtS+1CP17DgnIkXMh5mnhQWlrN9Xf/JBQIitYExTPSIir7TuAhwgWJDiSodb+IcSyw4EkLi0ebiFNPn6RRRdNx9g4kdlAnFPfB2eCqQ+Csxjj5TS80JNj9loJOW3/kqaL8Rp4REzgdLc9UTU2FjTdV5VNOq6NOkLPos0X6UzXkEGJhgTdQ6Pnc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c5814d-bdf3-4810-5e70-08df2a377b48
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:09:49.0782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMT3XR93QA6WCkuc4MsEupgR8LvLbhMfw9pAP+4UAT9CYWMtvy7/jt6ObekvovG2K87cDsQ4kpRDT2DNRadO89LVJacwAz5D/tRwGUe6Xm5jZ3zytClHcrOEIc4igEgG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4890
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140084
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acfefa1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=bC-a23v3AAAA:8 a=LpNgXrTXAAAA:8 a=ag1SF4gXAAAA:8
 a=awbfKOgv8huqgPx8rogA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=LqOpv0_-CX5VL_7kjZO3:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NCBTYWx0ZWRfX3IY+Jbp+ykcJ
 ofkCic4DkW7ZUkaeODsEg+iX23Vv7ETOhxfvQTywPvF7Rai9OxTgPFPByK60fJ11xqbKweESp+g
 W0chtzA3Wmk1/13yaDdYW6ZYUBC37Q3VnRlJYcza+GTZXUYmcKE4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NCBTYWx0ZWRfX9O7qC8el4Q7q
 I7Xds3ltVVrPDJIuxP3PQDe4/MnoifNlE7gsYbFss0/15tMBQCIvyBhwiTlcMWRuXEkvkCWY2z6
 EyyBWHOKO+sfPXxOvxylskZkK8vg1ikDhIFFKpbIY+4nEP0EX2x10rJtE5XextvxQ3Jp+BpKdMR
 WwYIBp0c4zxxzaJRbrTxcgPpUXK7dQWs91313N2scSgYxC3b/wmQaQhgSd+GKfoOQXMI5JEgcij
 SZ6Vunk4QpeiA5ZLpx8iWj/wpz2IUmh41mhVHSezzY+HWn/dK40u0t6KDSPTuTwAA3v3A0fno2n
 dg4KNS6KuxhNtQs473MmEGXIOlwiDoNIdMMmUKGGn+bujbK4GY7jajkknq/W0eQIwimHHl9ATWo
 UMnzH1yHaVVy0iVYUG7pIFMwc+kLhJ8ypWXUHBGQlLBcMIMuFWmNcC64yrSRfoAkxV/4N5xR1+b
 MaI6kVc/y0Jr/QXLe4NQyt3/IM2DlcTo86xVUgmA=
X-Proofpoint-GUID: 2ASThuOeLPdUaSllATRh9SPTvfTqJ4R4
X-Proofpoint-ORIG-GUID: 2ASThuOeLPdUaSllATRh9SPTvfTqJ4R4

Hi Greg/Sasha,

On 13/10/26 5:04 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Raphaël Larocque <rlarocque@disroot.org>
> 
> commit f0fd8993082ca229faa3f9844f1c9fe182eca20b upstream.
> 
> The ThinkPad L440 also uses board id 2722, but does not have the SMBus
> initialization problem seen on the T440p. On the L440, the SMBus
> companion becomes available shortly after psmouse probes, allowing the
> touchpad to use SMBus/RMI4 normally.
> 
> The T440p's quirk is currently applied to all Synaptics touchpads with
> board id 2722, unnecessarily disabling SMBus InterTouch on the L440,
> as reported by Daniel Salmun.
> 
> Restrict the quirk to PNP ID LEN0036, which identifies the T440p, so
> that other devices sharing board id 2722 retain their normal
> SMBus/RMI4 operation.
> 
> Reported-by: Daniel Salmun <salmundani@gmail.com>
> Link: https://lore.kernel.org/all/20260925230039.236786-1-salmundani@gmail.com/
> Fixes: 26eb3d92c7a4 ("Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Raphaël Larocque <rlarocque@disroot.org>
> Link: https://patch.msgid.link/20260927005810.85971-1-rlarocque@disroot.org
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/input/mouse/synaptics.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -1839,8 +1839,10 @@ static int synaptics_setup_intertouch(st
>   			return -ENXIO;
>   		}
>   
> -		/* Disable intertouch on known-broken board revisions */
> -		if (info->board_id == 2722) {
> +		/* Disable intertouch on known-broken T440p board revisions */
> +		if (info->board_id == 2722 &&
> +		    psmouse_matches_pnp_id(psmouse,
> +					   (const char * const []){"LEN0036", NULL})) {


An AI-assisted review of 6.12.113-rc1 patch 130, 13350b0f2408, flagged
that its new LEN0036 check can bypass the T440p exclusion when
allocation fails. I checked the upstream implementation against the
6.12.y tip f4ffa8dc360b; the same code remains in 6.12.113-rc2.

psmouse_matches_pnp_id(), whitespace normalized:
Downstream 13350b0f2408, drivers/input/mouse/psmouse-base.c:

     fw_id_copy = kstrndup(&serio->firmware_id[5],
                          sizeof(serio->firmware_id) - 5,
                          GFP_KERNEL);
     if (!fw_id_copy)
         return false;

Upstream f0fd8993082c parses the string without allocating:

     while (*p) {
         p = skip_spaces(p);
         if (!*p)
             break;

         if (psmouse_check_pnp_id(p, ids))
             return true;

An earlier allowlist match can succeed while this second match fails,
allowing board 2722/LEN0036 to reach SMBus setup. The parent rejected
that board without a second allocation. c1df7e4e4951 ("Input: psmouse -
modernize PNP ID parsing") supplies the missing allocation-free
behavior.

Should we backport that first ?

thanks,
harshit

>   			psmouse_info(psmouse,
>   				     "Disabling intertouch for board id %u\n",
>   				     info->board_id);
> 
> 
> 

