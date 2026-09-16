Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4126F403B0C;
	Wed, 16 Sep 2026 08:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548369; cv=fail; b=mTGWkv7xuQgsGhglQM1vQZIcCVf1L0toyo58iaomqJoN56HCoq50dXnLbSTFOcDuXICxW19urh+A27ry/3fNYK2upsnk8f4lmbOo21camuXNvQIhJPB1kQUfKkFLUUEQGLOk/rcjry5tRVtbTgM1cfQPgAwjsrW/fwPyxqgx0bY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548369; c=relaxed/simple;
	bh=QlvFyewXk2J1FUygK1E4h6i/biXo1cllXQJJGoSRwbI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZLYs42IvHkeGWKZB9iPKLtKNliJOFzGO3Vb8uorYB3GBqQUa6rB1VhmO4hDU9l/ZYnx5aoGcqDjL8DeMT03sX9xwxpXfhTxfb//XoBGbpfxMRKZz9oSl9bcIk2ZKT2fvxBa6ugmmFRvUXax0Jjr43XFvyDP3dsATcbWXycDt/S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZGFUgr2e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F/D0Wbjf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZGFUgr2e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F/D0Wbjf"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G4x5At2045129;
	Wed, 16 Sep 2026 08:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=l1FTFqDeVweJCeAy4wMDFn5kWTsoASvkG7BerK2KD+M=; b=
	ZGFUgr2eSyhATdRGSp9/ml7LzuIkQMQw/I9OaSBVF1/sWrgNar5UsLz25mwtyOL+
	6zz1VAnYlg+Bsfoz4mZySOoz5sDQpAvirk5nrIaEGthyOXYDmoVv86AvD8qCEU+v
	cMRri2SGOTwq7SCQQTTSPa2XU3wy7VE0oZ37nuIKT29EBlz/E74UoD4w5bMlyx/z
	KEePQugH50s5fV2G+UC1f8wJIQAsDS9mCN16Rs1ilzhb1HMg3ED6enxvUZpEM9a9
	1+O1/PNOg72lfl/HHOM6FbdlyNAMmK/gGd558+MNidI53X1jemBgTYjDLohVkpWZ
	7tT2qCWRVzkNGRR6YOapDA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn958v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:46:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8j172016118;
	Wed, 16 Sep 2026 08:46:03 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010037.outbound.protection.outlook.com [52.101.46.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6aw3n4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:46:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFFGNadZrwrlNo7ihl2PDyX+QaqB0BTTQ92E3sc8Hutmhi+CuU04l6cyLgxCH+pZFKhAXLlfpc0YQQRneV7x2Naiet/rYy3uoRNFEQhT1o/voCA8tsSXGA50U8VEdQtkQpLLYwV3eRgy8fBOJMY/n5XK5Ou1Bdx1b8+DiEmJRz8pJzJ7d9DuWWmeFuH8H+yrfeUI+xPq7CVAjSr1DerblNuvi4RMVHqOVsXXRcO9ZNSvCdwZG0/NnlAlcGSuX8z2yQe/y2nkm/+BUwE6suJgH34WSdDuMMoktP7Y9ETMaEuqlwJd1CW86aen9GEqFlHhvqLZDiN+DftwAqOu7UAiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1FTFqDeVweJCeAy4wMDFn5kWTsoASvkG7BerK2KD+M=;
 b=voe6S/4V05y9dPE9VKGz+NKkxCegnOD9iwiuH135TyRz1pM3ybQTlEVysVhGi2JzCDKKBzOrf9B60Rw+jhb5gTdePKA5sqtv8FjLR2NND+EWXYAvI4J9/0WvAXrADCdrm5a1GPwOXOjiAwjDCNU+7GyxxzF07fYa7jT36lQ05t86UVPdbUEU5wqveu4H1j6c5+UlAROhRzD+jEfXJSkvebzkLiH31xuz197AMWywR4lUO6UI13B8nXr7/ZIISeyNgxXF7T4yGlvZSB87Q509ozKGmCNcK19/IVrl/x1e0idYPH0MuCaemch3P/J+RNwLiu+kWEebrMq7Xm8sCXrw6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1FTFqDeVweJCeAy4wMDFn5kWTsoASvkG7BerK2KD+M=;
 b=F/D0WbjfD27wG4u9E50CJ383bYd/+kuclWC7jSu18stjGISp0+lhcwYn3UDLVsnxGz8v67NCCLqvTt04ykOEP7nHhIOJi4Sr+UI1n4aW9unq2Rj4obiddJE+vYqh14BBX6fx2FBsfOaIN+msLLMu2gjvoFyc5SIcetBwLdxOFQc=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 08:45:53 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:45:52 +0000
Message-ID: <1910ceb0-7b9e-44c8-8ee2-a6a86c7f6095@oracle.com>
Date: Wed, 16 Sep 2026 14:15:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1268/1376] s390: Add ARCH_HAS_PREEMPT_LAZY support
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065635.800686097@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065635.800686097@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::19) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4d12b3-c600-4a34-d3a8-08df13ceea26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|4143699003|56012099006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	cCQ+I71CrvEYq0neva4F988YrqBzZzSASxeayowRfePKM6HqJqgXdd0wqP3c033vTgWNun5HfAWJ0p955ECvZ+SnBFVV0c9IMFZ8RiWxLVzUj7PYoUjzhKF2W2KUHA54/FJ7QglXrME7PAQ6oZ2meXiOk5Q7in0lQaWTAIakuz1IulmCHR7GXPuuvMKvtGSdc50/pe6nDzpGKvpRFS/DAr3Dl4WICphFWXjQSvxZOaHLfD7ACAt45es1zq3A+niRt9bvxykICI8U0vwSSYfr2gTt+f1ZwhbVfBaPllsAeanZQLXW4tp50anpHWP9n7SIBhZdMHfxu9gAJFSSCV9ULA2ThJ/YAC5iFaMrGMyjdeBxeUzuF5ebcncv6c3P6DemrVZxYpmBJl8jW3zsnTcrYgt5CrlMqqXoaZKANsiWDvp607x0O1f5SspFn6Hkg+fLTwDB0/571aNkeQvqkIkss+0nuxZR3+l1ixzzRHEY8wVSueYy7WElrgjXCSbGUckOl1TSPK4rbvSEJVBRUuAzyHohFCelajxMqD1PPHbDCz90JEbsgO1pVyXweUzx9qtTW6QY3qsjKd4mVXLA35zu14SbaPnUg91clQUOGnnb4cfTpIWCDnhBchPZZabvxL8D8riskL6/kYLK3xMiaQ8w37/qFyqA47IrGkQkIrMv/rs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUNPd2N4L1ZlUHhKR1JlOEtrQThzdmNQT1JKbjVRNXdMOHFpaUpDY0ZJSVF3?=
 =?utf-8?B?RkRXM0w1YmVZWjFMTkIvamtMWm9sQy9rcG5lZ0JjczltVGZSNkROYXU5NkpS?=
 =?utf-8?B?NGlUUlVHSkR4akdBOGRBK0xNMG5pU3AxRktLN1VGVzFTeFdDbjVxNUF6dGdm?=
 =?utf-8?B?b3NTKzVtNjcyMHdMMFQ3N1N5UU9WWlR1dlFSdTMxREczZWcyUEp0TTJjWWdK?=
 =?utf-8?B?VHprNE5oRHE5TmJoL2Z0M3p2V2Q2aTlkdXdCeVh2TGExdk90TWl3K0YxVGgx?=
 =?utf-8?B?ME9Rb2t2a25neVp3NFNmaEllUDVxM3hTaUFZTS9aNytCUGxmZWNKemExN2xD?=
 =?utf-8?B?WkFPUU1ObHpHYVIwVEMvUVBMY1kwNDhxZjloOXl1VDNNNXY1Q1RHUlg3YkFJ?=
 =?utf-8?B?ZHFBcjFBRVJKS3FLSWIyNXFpVlJGWU8vQzQxYnNIdHhxOWV5dTZpbGFZLzBD?=
 =?utf-8?B?U2orSXFyTk9TNnR0VUIwUjVRTmxucmhMeTRSdVU4d3FkZzd0b1BXL1ZzTjdE?=
 =?utf-8?B?M2VvSEtWbDVLeHZlcTZPUGlDQ2FLaXNMRm5hZ2paVmhYMDZ5YVFxRWhlZ3du?=
 =?utf-8?B?ZUJLazVtdzI5cWtWQ29HOTNETVJ4SGl3KzhLeUpzWFFQNlYwY1N0TlloclYy?=
 =?utf-8?B?eGZFbHRqZlFxT1RPRldJa3VnalgwbitwY2g5WlAxdlVlcEl2cjVVZXdvdUdY?=
 =?utf-8?B?N2dYQ0p5QzFCWWl3cm9JRUROQWhIekJnTFJiVGRKeHNocnowMmxMSm1UU2xs?=
 =?utf-8?B?OUdhNERwOFdpT2ZSNE1EWjJhUmhQb2w4dkV4blFCUlZCbE5wNCtncnNNdWUz?=
 =?utf-8?B?dmRzN2UrZFlmb1FpWStKYTM5UE9VRmRpbE0xclZrcml3TFZWUVg1MTVTaUE5?=
 =?utf-8?B?alBjdWNIMlNCZmJ5eXo1VHBJV01jcGN4SjU4aFNRejRqMG93U3BVV0JldEtL?=
 =?utf-8?B?NmdaNldIdDBPdGdHUnNxNTNGVVRtZzY3RE5ONmdKNUN5dmhTUjJtMUlibEJl?=
 =?utf-8?B?eTF4VmpMRkNLNGIyMkpaMEJ0Ym5ON01oRXRHd2ZnUkEzZFNkRjNJSHpScmlH?=
 =?utf-8?B?Ry9qU0NMWEVhTTJUQ2I3Z0M3NWh3RnZiS0Vwczh3SGxsY0NUVTV4SmNjMG5C?=
 =?utf-8?B?Rkh3a0ptVUlsWi81R1Qzb0dQb09COExGVW5iZFVTWGpZZFV6elJPYS9yS2k2?=
 =?utf-8?B?QklrajNTQTNmakF2NHB6RmNSTWpNRWxrdm1YWkZ6KzhtcjNzZ1NFRmxxT0ho?=
 =?utf-8?B?cmNaNjFINEJsc3BtVm90cmVXUERnakwzY2FTOVIyVGY1TzZlbEdqd3lWc1Ur?=
 =?utf-8?B?S3N6M0tFVTJqUnp1NmpRYjB0SW1SZ21ycFVsREttUkxhV3BPSVRjcGNTY2g4?=
 =?utf-8?B?RHhZZUdybjI1ZlFaSFY4VjhjVWkxYlJYVTlkVWdMWGM3L1UrR29OM0hicGVq?=
 =?utf-8?B?bzhybklJYXRibzV6Mld0cWJWYjJlVXBtaEYza3V2LzVOUXlnczE2ZjRFeTU5?=
 =?utf-8?B?WkpLaFA4Wnl5U0FFektUWk9OSWNyMUNFNzVFaWVIWHdJdkdzQjBaKzFFbWdJ?=
 =?utf-8?B?SiswelQvQWpMVkVMaXdMQ0xhRHFJYlRaZitXRG1wRnh1bDdGQllMUzhyRTk3?=
 =?utf-8?B?cXdVNjZGWGJ1YkVGNS9PZTg2V25EOTRJZUh6WTdSR1g5UEt2ZlA4Y2VNd0FZ?=
 =?utf-8?B?b0drUDRJb3BpY3JXc2lJVTJwakNJeWxVTVJkeERPYmxMQTU3MEhDSEdZR09s?=
 =?utf-8?B?RFR3SlA2dkpMQmJnLzBVZFdjM2NkaXkxVHV6SWk2b0Vwb2J6MzQzeUlLbDdN?=
 =?utf-8?B?cjM4QTdoeXhOczFod2Z3MXhyeE5hWHNvVkJkckY5a2NLMkRTR2ZwNmt3M0Rk?=
 =?utf-8?B?NUVzYm5aRkxEQm80Wk1nUDZOajdwYzNITlR2YlZ6ZGVWb3V3R1lpV200OFRt?=
 =?utf-8?B?enBuNWdmRDR6M2xPNWJrTnd1R0h0akFoTnpUOFRMOVVaOXVSL0t2cVUwOEFj?=
 =?utf-8?B?dVh4QldwSGNwZTBZeHQ5ZStwS093bXBndXM5VU1abjZrczZhQXgyZ1AzcWNR?=
 =?utf-8?B?dkNlS3RjQXJkZnhhNTVTZG91M2FZMWFsOWVEL0hCendzWkI2Rjh3OTMzTnJy?=
 =?utf-8?B?UUZlK013RDRyQTRlYzVmM0M5eEJoc3BKbGVLYnhsaEVOZ0tyZ1lSOE9NWSsv?=
 =?utf-8?B?OGNSMlAvb2ZlQms1MGtHK3pheHhuOWFiMElOVHdOQUN2bDV0K3BsTitibVlq?=
 =?utf-8?B?WWhCQ0tEQ0VRM0ZMbWZOYkdoWkllU3JrNndBL2J4ZmhQK2xBbTNpRk03SG9j?=
 =?utf-8?B?TlE3aXFIdHRzR1AxK1B5VEdWdEpNeVF4eTNqVDlsRStJMU5rbXFnMVIvUWFz?=
 =?utf-8?Q?xegr8t9w2huaQh/K1eOAiE1PciHhXBgj/+pnp?=
X-Exchange-RoutingPolicyChecked:
	tbuYDKLX2200nS0S/btWE2QjLVPuhOqbSb6Jg96zBczYHOMJY6Y/Ux/ANWXqkLdLChUKWcQiRi2VldEdgvJxSzq8Zru+cIYRh/0FfUZ0btE5ckl/2X5JdZ+fa5Nk5IjUXGy5ePlX4Rv3Rl3Art2U6udmLG7WjcYIWl6WqsigX8VBEm4wBYTwb7cGOZ5sg6YdfLTv2DeTzwGCVY2Il+dckIa5O22hoAv+R+05wGqDldBRdhbU32MBuqPzggVpQd5wmoqJhGvawfuOgAPq4XyslMcd1rSPWcjnCv70nnvau9mQ5q3RdwDq9dJL8rL6im6Pl8dUKZ9rvJDmo8Rtg9JtpA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Udvsd+f35frTIhbEfeFNbla4XwYhOv7lto/p3+1mGFUSw8XljBSjB+0trF3pnE7jZhzL7u5UZgvxR0pLNwh9gKme1WJNNOyTsSACmtVX9VcGQ8z+vWjtlSRtBNDEYLzIXlA2c1u7PbqOesN/X/VxfFvyJN1tOVYOHIMIiOyjRKaBC0KhQIem/m7ve09Li1kSiQmUXGyWPcuzKwLCBNFT/LyKJ/qzAPBrPGWnQKo0nuJjTnLaRYKK5pxY6xjeT7YtTDO8cvNG4M6v9Adp1aadqxf9DvO1NPAWJSSBDYlbShDlkLs5DDSAhH2d2lXmD236hro7zZ++rYAE1b12B9yzMkqtTGjBPzjEa7iJz0QGTiro41eZbW1zS78iuG9MZJGC7qNMoc39RQ9ymzTV8m6WbwwLFg1dYMvnIkTRVyya1VZN2ozQLgS4mWL+NvGtYqKCayIVHpTeJy0i+WoUUrbmjuCuckVxupc1I8OSTLM+jAJSsPzguwieiBT0odjn9TczXMjRW/FXTWSKxhbnQUWX6Ox7oOdOVk5bMztaT2exGRPijwxa8xN5+HcR7WsAvZPVH6xX+xN8wCqZVDHMcJuuw12ocZbmxyRBdV4hRinBHak=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4d12b3-c600-4a34-d3a8-08df13ceea26
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:45:52.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5xDpUDwzNDvH49Af+VZ60RL/HrJuu1sNDQ/F/VbZfPvf82c+X9lGaUgsVZCuIEPCzuye/gw9xE8/74fivJtiSAsiuL/LTGdY2vszsmREqBXIsKeW44NHpcV1+eR++R6N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160113
X-Proofpoint-GUID: jQmPiI9LBND-YWQeYw3D5Bjxd11v2Hh6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMiBTYWx0ZWRfX7LL4tTV1vQ04
 9rsY3nuUJPdUnnqfLzl75ZsAsWq9aW3symo/mj8EEynTX1B7Mf6OCMU0mmL1TVIe3VYXpAg3ZQC
 llayg5waw+ES2x50Z0av9rxFoPg3KVe3yYDMaHG3XFxJujV3kxpI
X-Proofpoint-ORIG-GUID: jQmPiI9LBND-YWQeYw3D5Bjxd11v2Hh6
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaa574b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=E9HPYs5OSs5HympzCg4A:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMiBTYWx0ZWRfX/fUykD2FLOh9
 8s7Dgyf+P9i7XeLQlgvSFbeNx3X63tqwTlwRpztDJp0dNfMEBJSwoMAu48LkXuxq5EdUPPBa7RE
 BH7G5xIA5MxFEYCgylE32uxOGh1oGqhAXFJnDKMCoIUsmihMin29ymqHbIhT4WGTjeWWgW3PVAC
 tRv8LU7Tryr4FiHbLlH3H9sCrHf0QG3Ug21LKa7MOr6iboydfWxE5TrtGth5WAzjWMylQqB5+ds
 RE4SLdp+6caNKEw3jq2jaapIMvQw27Y1xMZlclPkeE9D5Xei1AZj8C31FdmdXAgtnMRHe/qkaiZ
 GF6wq36xOwgCsNgUuqPwk+ZX4b2J3ve7Z9QiczBi/Dr/KDSSmFc6XhudvMoMEp3AVS5EPxJerJK
 oM+ofWYbGxJte36h9AmqH1AtZuun+TGGcHT0nUN8WrXpG2tl7HmCQBntmUNxCZyq7hwEca267Zk
 MOCoynCRKDgyBg1bmpg==



On 12/09/26 12:31 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Heiko Carstens <hca@linux.ibm.com>
> 
> [ Upstream commit 9de3e4bf6cfbcb62e9ec658e3b291cd479018b43 ]
> 
> Just add the required TIF bit for ARCH_HAS_PREEMPT_LAZY support.
> 
> Shuffle TIF bits to get TIF_NEED_RESCHED_LAZY next to TIF_NEED_RESCHED.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/s390/Kconfig                   | 1 +
>   arch/s390/include/asm/thread_info.h | 8 +++++---
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 53dd642281776..69aac02d5fc4c 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -80,6 +80,7 @@ config S390
>   	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>   	select ARCH_HAS_MEM_ENCRYPT
>   	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
> +	select ARCH_HAS_PREEMPT_LAZY
Hi Greg/Sasha,


I don't see this defined in 6.12.y.

thanks,
Harshit>   	select ARCH_HAS_PTE_SPECIAL
>   	select ARCH_HAS_SCALED_CPUTIME
>   	select ARCH_HAS_SET_DIRECT_MAP
> diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
> index 3802f281eeedc..c33f7144d1b97 100644
> --- a/arch/s390/include/asm/thread_info.h
> +++ b/arch/s390/include/asm/thread_info.h
> @@ -64,11 +64,12 @@ void arch_setup_new_exec(void);
>   #define TIF_NOTIFY_RESUME	0	/* callback before returning to user */
>   #define TIF_SIGPENDING		1	/* signal pending */
>   #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
> -#define TIF_UPROBE		3	/* breakpointed or single-stepping */
> -#define TIF_GUARDED_STORAGE	4	/* load guarded storage control block */
> +#define TIF_NEED_RESCHED_LAZY	3	/* lazy rescheduling needed */
> +#define TIF_UPROBE		4	/* breakpointed or single-stepping */
>   #define TIF_PATCH_PENDING	5	/* pending live patching update */
>   #define TIF_PGSTE		6	/* New mm's will use 4K page tables */
>   #define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
> +#define TIF_GUARDED_STORAGE	8	/* load guarded storage control block */
>   #define TIF_ISOLATE_BP_GUEST	9	/* Run KVM guests with isolated BP */
>   #define TIF_PER_TRAP		10	/* Need to handle PER trap on exit to usermode */
>   #define TIF_31BIT		16	/* 32bit process */
> @@ -85,11 +86,12 @@ void arch_setup_new_exec(void);
>   #define _TIF_NOTIFY_RESUME	BIT(TIF_NOTIFY_RESUME)
>   #define _TIF_SIGPENDING		BIT(TIF_SIGPENDING)
>   #define _TIF_NEED_RESCHED	BIT(TIF_NEED_RESCHED)
> +#define _TIF_NEED_RESCHED_LAZY	BIT(TIF_NEED_RESCHED_LAZY)
>   #define _TIF_UPROBE		BIT(TIF_UPROBE)
> -#define _TIF_GUARDED_STORAGE	BIT(TIF_GUARDED_STORAGE)
>   #define _TIF_PATCH_PENDING	BIT(TIF_PATCH_PENDING)
>   #define _TIF_PGSTE		BIT(TIF_PGSTE)
>   #define _TIF_NOTIFY_SIGNAL	BIT(TIF_NOTIFY_SIGNAL)
> +#define _TIF_GUARDED_STORAGE	BIT(TIF_GUARDED_STORAGE)
>   #define _TIF_ISOLATE_BP_GUEST	BIT(TIF_ISOLATE_BP_GUEST)
>   #define _TIF_PER_TRAP		BIT(TIF_PER_TRAP)
>   #define _TIF_31BIT		BIT(TIF_31BIT)

