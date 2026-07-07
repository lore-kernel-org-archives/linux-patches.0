Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A793238D27;
	Tue,  7 Jul 2026 19:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783452971; cv=fail; b=efgVW/GLDtREKzIsL/qL/VLnOBxaKx0xAqOWayw/5zIgqN5w1o6t7/uFFAZW+8X09XpCGhc40JJ7W23LV4ayeqk3pwJVnL23gghF7KMw9mVqQuDFyslN4msia4GiP+i8GxEMy6G2lWtQ0GCF17PUBizcI1qmWYAv7u0NMHwzk+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783452971; c=relaxed/simple;
	bh=fQ2Pobm/fhqwLox8T4oyX7K0Ka0I2rI2adYf/qSSjEw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lQyeZkw1W1+oinpTc2QoKxRmkX0kEN3ReYJ2H+bJlEN0G+4o486jvUdAmY59KPzxaYuE/bPhg3w48+mjEkyh/5ZU/98tuyu/B/l08plGkJJCelkBhXvHSh9l14pz9NLfhDYZnMVoP4VYVxUJqWV5YxaSyShjdvrw399/dYjoMmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yl3KA0J7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PxzlOu/9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yl3KA0J7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PxzlOu/9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667JBdrj1486302;
	Tue, 7 Jul 2026 19:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1u3n20u1+bs4s2fp5wiRV/TkbVupTAuG3VINtg6FNPQ=; b=
	Yl3KA0J7sq3mUyL56sDfug1D9IjyjfWqu4cPt3gWiBuQ4n4zWKmOQoSS5nRpM4cI
	DwByWCGy3lIEfP5NG9jzTE7izwgnVjx6cYjwOxTWdmuehZ2NHuUoqDmaqztJ6ujJ
	me+tRYNLXySr6S7nfgNxPinIdO9/YnzwDA0sZTO/IXkHzuXqLHkxXT+9cRsd51me
	aaS1/pqijntd7liYzEcn4PuKvgIBefQQeUp/+tISk96bsz++eUY9G8Ye7KackS9A
	SYDVwBDlgbGIcHeBPV7Q7aQR/1e8pDpZevygcir5u06hIzBQHpTJTqGtzX3ydQy/
	YY03KRkqI9AzzoC6MOCoKg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t2a6746-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 19:36:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 667JS88Z024300;
	Tue, 7 Jul 2026 19:36:02 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f8wuxpr1d-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 19:36:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArdbSpkooa8hHWaqlpCllwgx9xVbnaWJLmo/4bSSMkDMPxSzJqbcwZIH67jfoMHnx480o3rDmR3YPfeSOWX6jfyPn/fEuMuMe+yzo5/dB0yDR8HGz8oUKipEVeGX3Mv13REFBxvg62tMZt+X23ps82tilazP/tYMIieC3vvhqRT3drCI9ruN0FWXZf2H7oqmsJekBGGQmlI/HVGKQYGB/Bpl/b6JNyCjbDOiR76j5g12oS3QkX+YUcUaW6myxRcN8d8u/rfT6CkNEBunWOOBjzf7db3GLYYnjt2OJB/eOILXhH6+iaLFyy+JfE5F+TtnBqSysM10ZRiw+8NCv3MFIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1u3n20u1+bs4s2fp5wiRV/TkbVupTAuG3VINtg6FNPQ=;
 b=IADIgkybRN//O/rCIsqyOEQI9oTs4LAZUJSQEMzCNmQ/r8zbtptbwvfRM26qOJTekIp+TFNmMeQtk/M0/j13qkSPHM9tw7uj1vvWuvv8sGjcxg8LaUUAQuLxko4QElevtHnaCCUnluOL+gZMtlow/6NMNLpLxw+GbMGmMRC8wUMejmCPtLjfZWSvaKWCoYbfhyMiCQbMj4PzbxafbNvla2xATwC1iwNCEGDeBKUMgOPtzYsbMaMgh0PQUAeutgL1uwESwCfRAqOYQW7lM4mfwJy5gPlALepWV8Gecfn4NY3mLTmuC1Dk5sMQOb4EE2M7Sx11lcrrql3HwbF3n5bYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1u3n20u1+bs4s2fp5wiRV/TkbVupTAuG3VINtg6FNPQ=;
 b=PxzlOu/9I8bYzvRnacWOyVkUIJdQmmMDVRO6WpQQLcrJXDXbchxz38e3iwTQjE1g7H9WTXBXUElP27+WytDAvM7tkqbmP3IgwIyk0JS4kAAakOzm/FEpu4vJ9VHo31tuMVv/K+VeEm/V7mKgx8IYJYpA22gwdgITlGRrqdrIRpU=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB7105.namprd10.prod.outlook.com (2603:10b6:510:27f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 19:35:58 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%6]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 19:35:58 +0000
Message-ID: <9516338c-50c0-4e0b-a8e8-5af82e6d0412@oracle.com>
Date: Tue, 7 Jul 2026 15:35:56 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 81/96] nfsd: check get_user() return when reading
 princhashlen
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev,
        =?UTF-8?Q?Dominik_Wo=C5=BAniak?=
 <stalion@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
References: <8601edcd7c9bcc70e75f85a758f8818c57945d07.camel@decadent.org.uk>
 <20260706135124.draft-0004@kernel.org>
 <ba08a15b-e61b-453f-9331-adf17690d612@oracle.com> <ak1UcPv7GwgdmDIn@laps>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <ak1UcPv7GwgdmDIn@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0047.namprd18.prod.outlook.com
 (2603:10b6:610:55::27) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|PH7PR10MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: ec2c38f5-fd58-4306-e70c-08dedc5ef7e8
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 jueZ6qTHSOeFL5tpPDbMkAnl6cDh8cA0flDc4N6e7u4CjTnAwoMLIUAH94CQC9rpwZnZf7ZIzERRpA/FJ5DcF365XcE9DTbf0nDq+VY0h3tUGcboBQK8LE5wpHfVApkf0Ijg1zvlVExA2c26p4hKIC9zO3S4Oc1k7dum+BUkvCUhrKvHWZLdbexZf2+HguEPZAxs1I4WFlQaQ2UejSzrktYoJR1U1wucZdCfgOTieCAgJpr28WADvD8GElej955ju79yOO3oW94jX+sSopHYmIGd/YjfKY0RsBBdB4Ios3GYOogfRXaeOgZ4vQ4kHTcSa2HfXegQzWbP8L4gWJ2m8s6bqXmgtkmlqe3hT/6+jfdJcTv6uXV12ve2dQyKuipOYebJo2iF2/KsZch6aDRHyAVp1fyuDN5sSZTjvTPOcq3E8nwfVnON1QOGxntt080FVE3iZzg9d8zMcdKbloMYF0ql5Yhd/dz/9y43zifzJrjHXll9a7mtGoUSCfVyMVa0dZCuzQrivi4F99DvLZVjnzAoQyL8OWWAgS9nNae+7Ghkw/dW/+TJR1cewPn25rrs1a1J2ceM4N7svcw18gd/+z8gAQZzNnpWy55RiohgjYuhuuJVSGYjcqY7p4qhnAdyTJzPLx2/J4hRjNgYLencgq5Tdg/Wz4WCMI9XrS+vzss=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TXVXU2s0clZucTIxbXk1STBVa3dEaVF2UGRyZVM3aXZDditWMm56L2V4SjJv?=
 =?utf-8?B?dVN1ZG9YK2ZDbU1jQi9mZVVOKzdNdllsUzdBMkZQVjFwSkJpWVdJcTlqQXNC?=
 =?utf-8?B?bTFSSlJWbkJxWVRZdkVyRXJYQ2ZRSUlodzFVU2dMMGlxc0hzbEYzTEozRFQr?=
 =?utf-8?B?RFZUZVlENi8vazBqZzlRUzQvcmtEVEpLaVdhRldSdURYSTNOWnBGVCtZQWNo?=
 =?utf-8?B?eHdTZHluOWVRQkIxSTA1OTI3TTUreUgwdFkzRGs0dWF0Q3B2eDNmZFB1SDha?=
 =?utf-8?B?ejJ5YU13c0IxTWl2MFV3MHQvRms3VDhzbVpCeXlkZ3pXY3VpTFg0RkpKdEFG?=
 =?utf-8?B?WVZ1T0JqbHNYT1ZVMmhvY1pnNTVvbU94M05Gc09neThaVjZaL3JnSC9BNUVD?=
 =?utf-8?B?TjFuU0pPMU01Umt6d3o5Lzk4RU5uYW51a3NaNVZiNGlCa0pJV05DQTJvZ0E4?=
 =?utf-8?B?UmJsRDJlblpFeDNmS3NITklrSFg2TnBDK2MyMnNtR2lrVlk4MlNzUTA1QjVW?=
 =?utf-8?B?QU5lZ2o1a3RaSzRjQUE3OFlZNURrSFJHM0VYbkNHM1BKZW51QzNLa1ZLVzZy?=
 =?utf-8?B?RHFWUEhuTTJQOVNaRk9wRG54M3BVZFFPYmxtdjdxaWJJOHlNQWppRW5BVnFQ?=
 =?utf-8?B?eWZUZmRBMHh4TUYzWkl2a1FvY0ZDRi80WlRlRWVZQTI0aDlYMnAzK200TEZx?=
 =?utf-8?B?VXhPYnRHSFFmMWJUNXBpSXFkZ0Z1OWlUczFUcExnUi9tQ09rMUpaa09VTE0y?=
 =?utf-8?B?THBEemFyQm5SK2t4T2ZWN29hV3R6TGF2R1VOQlZuanNPcjMzOFZpeVhLK2p1?=
 =?utf-8?B?ZWNiemR4NStBeElOM2kvaVM1bWNSaXNrM0JqbytGK0hrNGRhV005SHlxWGp4?=
 =?utf-8?B?Unh4ajdZMFNIQ082WFFjam4xNjBhYWJvdDR0dFBPWUtoN2NZNGs5d2s5ZVY2?=
 =?utf-8?B?Q0QySE1yTXZ2c3R2U0xkOXVhWDhyNlF3ZGN2ZmdxMW1JU2N6RzZIQ3kyUkRw?=
 =?utf-8?B?b3d2UCtMV1o5ZlVWUERxc3JCcHpkOG81Z0Q5UFhmdEFlTG9sbDU1N2RHMmR2?=
 =?utf-8?B?Z0lXVjZzOXJtamRNRWRmditZaFMyeHdLR3cyYlVtSzJ3MGZmS1NxUy9rc2Ur?=
 =?utf-8?B?cTdSajlOc2gybkxOZEJhNGN6V0pacE9IQlJ5NFRUZFV4WDQ0YWxac0NLOTZR?=
 =?utf-8?B?UlJJempzTWdKK3dZS2Fmd3NpRzVDbndrVWp6RWVLbzU0WHlseFo4SEZxbENq?=
 =?utf-8?B?aEVvdGk0blhxZTJaOVZKb0hmUjUxWmZSbXJkaWtiaHQ4dGwwZkFFaXAwN1pB?=
 =?utf-8?B?S3ZYdHh0Q1Y5T3Q2TTdhSWlGZkVDZ1QvSkF1MUFERE02SWpnYmpUSUxIY2xW?=
 =?utf-8?B?a2Y2VXNmVy9pQzBrOCs1d2V4ZWV3eFJTT2l2ZVBLNGpRUzhCbEZwNzJmVUNo?=
 =?utf-8?B?SmNRWGt4a2I5bWRQelk1cWZpbUJpRXQyZVhIeVpOSmlXSGZ0RUxENmN5eTQ5?=
 =?utf-8?B?TnN6N3V5Zi9sa3M1U0NTUDFBTmxSSE12RkJqcUQrM3hLbUlBeWhYdUs1cDJC?=
 =?utf-8?B?SW1XdVhFRzJPRmt3RGQrSTY1cWtHc1p1b2YzQUc4Y2dtZVhQSkF5S1lmYzA1?=
 =?utf-8?B?Q2F4V1FTNzl1TUdkY1VRMlNtVHZGeFhYN3JVYndoSCt3c2VScjErRGZINHZw?=
 =?utf-8?B?MGdjaTZxOGxRRkYyZXIvNENuOFBVTkU5a1cyYWVybUJ0QjQ3dkxtcm9zTUdv?=
 =?utf-8?B?S3ZUZFBuMFd5bVNiWlNsWXhJZzQzalA2TzU5M1VPcVNkOURuNUtLaXk4cUV4?=
 =?utf-8?B?VzViS1d6a2QwVXR5bTZueUhhQlo5b3VrYXNHbXZCSEo0b2phQll0VE5EQlZB?=
 =?utf-8?B?a3I1ZjVSdTZvb0UrOS96THQ4b3F4SGpDMThJY0lnbUc5VVp5YU9CV05JWThx?=
 =?utf-8?B?VWVETmozYnV5Z2lBMlI4OFpFZE45VjVnNWJTVkFVVysxV0tjSHg4R3ZRS2pT?=
 =?utf-8?B?WVAyNitaZCsrcVl2R1JCdDJyS2dDaEcrOER5SmdiUjNPempPUjllZEhSdXlk?=
 =?utf-8?B?UGtxQ3pkOTRVVTlvM3A1OEFLeGFuOHFPZDJHWnZqc2JlWmg2cm5IeUxaNWxW?=
 =?utf-8?B?NXFtb3I2eHU1d01IcUlSSHlGdFRKaEVHRWZwM09tMWJObVZyNFdSSkgxckd2?=
 =?utf-8?B?c1JJNTJueldtdFZrZytUTmtWZWN4U0xvUkFIOUxFN2tuTDhiWEZRQ2pGUFFr?=
 =?utf-8?B?NFQyWFdaWFc2RHlSVzJnZEczdHZrZEdkbTFuZlV0TzhCUnhzeE1aTWkrYUJK?=
 =?utf-8?B?RzlyWUJNSDk2YXkvSEoxRW5tK01HS3VhSCszMjhxRVRuVkk4UUVhUT09?=
X-Exchange-RoutingPolicyChecked:
	pKlV4VKsZN1Uxn8QkOqkENv82nCEFbZunrPD5k7UyJ5VwvWZkloo1aJHKFJzYKrAwlQxazgDgV9oG/3LeoroGX7Lk2JBaECN+jTF7cjJYDYFMC0JppbiQV/oeN/a1PGXxhsVxdqSwszykkcjpRXmIK3NqDL5Tlxh5d7Ys34bkYTAjTghbRSpTEuKr8vONAKQVLqkNXmGABmCfoYLXmgWnixaj49utGQFTxU30dEqJe/8R2yQVEqBT/lQSj3c9a0p3foxXnvRN22XVlvAS7luqdYRqrekeeFMK80R+Gbte0LisElbG75k9sSjtLYiswZT9dro+oe3vyh8WkeIobnkCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vttpY7z3KJMslLzUh51GVaQKB6WKPwip3ekzgdEby6itlGtcjaiqtARF4Cx3teSYsiejlVzli2FMisB9ulnApWJGxDjSpcYx4O13meSyAL2XHN32eqXNfNzZ3OB+yGku2P/+EmAZl2VgpXu9qEIgfZT5VSFKA+g35NcuT1y+6LyBjov7NCAnFKz4M9wNzh87rP7IwQeFWtlccZ5Wfb8OoqEDS6XUF063zXIU9BGoOuCT2nV6daQPiSxS1et9ZNHu+NKNOnnZ+vU+kMAvi5+7qygUKr1Wpm68XbbaAkcfWl1eHMGC8UMSb8idynZ0tjeAtqJeBivJkkm+ntl5QdMW0N2xmD68dysrzEmxhANJyyWSjS4WB0OdXN1nOkG+4TcNjg8G16VGe2gjS8RtW33IqbEeiJUvCVdYp3U6l8m1JVM7yVLFMduwLJMtYeXAEPeSkuRugBJlhoLF1aQUKWJF0ow3/03grbbT8eq7SG1sjBkTriEgKjcKLlOnZkq2VJt1zz5vcfRSt4AIhWN3jbhRZGzN1k+SCEwH8BZnOcKgwp6wV5FdPvVw+8dIryyZdriWwK+xEOOfO8fznGnYCgOkntZ/5Rc38BdPlpuAeSyjKvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2c38f5-fd58-4306-e70c-08dedc5ef7e8
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 19:35:57.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nT3Bq8AVoVtocaHAq0yrCaNaqcjujTaMDxFA3AaP//4eOb7L0v65nRbF6nGHaSdFneOWZXgo/ECYjpTsGvnudA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_05,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 mlxlogscore=813 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607070191
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDE5MiBTYWx0ZWRfX2zBELd9LoOUQ
 uvqC8fdwuCqLN+zlmN/vkRjXkmtEsksqQrv/FNZW8dydjGYCvilfMGxT6K8TqKRESBiLuhJR3Ls
 tBxm5byB3YIGoprB5U5gIADyQFomTWekkvDBrp5A515hKNpnhCbSyqxiu4Q0HQDFvwWrnRRs4Wp
 NHa6MIKW8PTSWn+/D0y81oxD7TP5MdHNRssKRB5kAdk5jcLZA41rBZ/OVoXYwZj2/jf3DnzBD8y
 UhJvH7uAMTQQMHAAVcL+d7v+VCU4KmdmPDwCAS6IqRZiiA8aiwOuSjBDYFfod3Tn6bE1ScJqqsV
 PmNeo6tyBHnpJTpAQiFS61zgT8EF5Akrz7C5k9Da2gQnbV4Y5fhJOqks/00EQYAEhw8+ErenDwa
 IkbKtLUGN6YetS1S2InY+mZhNno5Svudu0c10sANVrOh8VNkYWFD7e2+xRHsLH1NVrfDZnRmDy2
 TfK3pJ6y9NMti6gvy/w==
X-Proofpoint-ORIG-GUID: b7KeNryANqSqfjw2kAKcziHdmDOBwgkH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDE5MiBTYWx0ZWRfX381ft4Jr8lYn
 5GCidSu3WKAzPK5QShaTvcIF7B61F8OlQruBLV1m0og2WsbiD2Wxbv3fcAy2DSSKHGIh8GeErN5
 NC3+VMrcDIfk2bScFXz891qXm6DG12uQdpG2LQU6FghO6+lIO8FG
X-Authority-Analysis: v=2.4 cv=fdmdDUQF c=1 sm=1 tr=0 ts=6a4d5523 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=W715OWFM-2t76HoA0bgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: b7KeNryANqSqfjw2kAKcziHdmDOBwgkH

On 7/7/26 3:33 PM, Sasha Levin wrote:
> On Tue, Jul 07, 2026 at 09:18:14AM -0400, Chuck Lever wrote:
>> On 7/6/26 10:08 AM, Sasha Levin wrote:
>>>> I think this depends on commit 4552f4e3f2c9 "nfsd: change
>>>> nfs4_client_to_reclaim() to allocate data" which went into 6.19.  In
>>>> older stable branches this failure path appears to leak name.data.
>>>
>>> You're right - the new early return leaks name.data on every branch
>>> lacking 4552f4e3f2c9, and the patch shipped in this round of releases
>>> on all six branches.
>>>
>>> Could someone please send a tested backport of 4552f4e3f2c9 to all
>>> relevant
>>> trees?
>>
>> Not wanting to duplicate effort, is that "someone" me ?
> 
> Looks like most of the conflict is due to a missing 89bd77cf436b ("nfsd:
> move
> name lookup out of nfsd4_list_rec_dir()"). Ok to queue up both
> 89bd77cf436b and
> 4552f4e3f2c9?
> 

Those don't look like Rocket Science (tm), so go ahead.

-- 
Chuck Lever
