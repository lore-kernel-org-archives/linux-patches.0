Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ABE17EBA5
	for <patches@lists.linux.dev>; Tue, 14 May 2024 19:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715713834; cv=fail; b=hvBxmWSKm3BLCkaoxokage4wpuEMFxtABltVa8p0FDGZKY4jSZ5MYEkm4nZ/pNs6100l/9uqMXpZQ4m3QphaoRezpGAOAuMHAPmRAw8VUUpGxEofGhvF4Z9/IQSmyRFZuoMNjpWdUIaTsWK51F7/5r/ojBJvw924kh96LmuZJCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715713834; c=relaxed/simple;
	bh=waq50eFlpYQk4j2SyiF3nRIFBQHDpTCE1mlvVwFZ4Os=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WlNlm0LjRTBNNXGdQbTSNv+3qIR18Ylr+ue/VfXPiCy4i3xdCR7mnkb8dDzevQZlTJU1oYGMdbVfUX1rhlashLI5vY0t5EDtBhcM5S6xkmvaLzoHAUdyw4gWCRVLfBRTHolPTnqV2m8VdhXCh6Lh9ZIwr9/Idk2A0CHNzT5tPOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AlLK3+cg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=npIb1LCq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AlLK3+cg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="npIb1LCq"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44EHJsQX004805;
	Tue, 14 May 2024 19:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Cd2RpZiN0v1Q1dYkqkQXBz0t3jj8Ni58evj9SrLvITo=;
 b=AlLK3+cgTBYln9rEaT5KGoQwazlv1evFO4IAQTxrSicE0kEANJOBeW1BUkiTKhtZoXwT
 3Zs2Ibca4Yqt9GmUH1j0qVSeOBV+xWPQ7TQey9w02OTuoI5j8N3rQ5TtCLOwZyxqIwDz
 S0pe/UZD1fbpKCC6SxUw8ENms/YCcM96UfPcFACc3TVJNxpr7Ay2Z9L+7x7roILFzaMd
 hnPlxyHbGvmgMetcKCPSvVJnab/CB8CKH40PCoTJhqgFiIvOwUSIbD5PmynetB93senh
 vlNN8pKG7tvELU4AEr052HFRJjYfLWTVxLZa2m8sysfkHOJ2k+Rhq9mAbJj5Je2hNjL6 hw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y4c8r0a1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 19:10:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44EIjUqc018081;
	Tue, 14 May 2024 19:10:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y4dy6j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 19:10:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjTZRQRaBRXlHTcGXFAo5NT4ODetVzIyhODGN5qZIr4b610/TBmXN16sLhp7p9b8E56lf+vi/wdPZNAPp3PY0qxZWJN13lCx4sDPM1n01aXtpuNbU3g0o0BsyaVtGSbjgRcpRK5j+r0vFummQrofEIYikmNSn+vv3VA7y2LnzqLlwwvxZpE845VPTR4rejaT7I7bbp4dXlfpfAk8AzaRP3ZieD8RSypOnX6F/ze7930hl4gSHkWZap8HO7D30/4PEToiDk6/RDkkvPRF/Lwl2xPLKKLe7GlpN1jbLsA2UvtAv0szAqdqMZQRBiFUcNFerXObhK3kYX9vipTQjibhnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cd2RpZiN0v1Q1dYkqkQXBz0t3jj8Ni58evj9SrLvITo=;
 b=Q90O16u6ybfrPvj1f+oNiqEhx/EP6eRpu3l5obkF/HAm9H3JcdWFNJuBjxYVX0YsUd4vVgu9/MRpzA0voBjvdS3tYMSVyLvfQiSfnPBwysktXKNqi8mAmTY6OVKcnuBAP7zNfC8AwB7+j5tZIyQU9FjTOzlM2CEt2/XS4Ccha/Ag9F0KQrCJTJvlBaiBI9SJSdV6Wb7pO+r2VA6wmp9y3w2TdKmx2CL9fWfgGPzq2jpg+TGrUjntMfMPU6Udut8kl4VDvluo6YdcoPpnlTwjrSkgwXiESqY7Tq9o+FARq8iQbHbCRHAnxQtndRMo73jbN2WYDzpwxjZNV+B/WysyPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cd2RpZiN0v1Q1dYkqkQXBz0t3jj8Ni58evj9SrLvITo=;
 b=npIb1LCqBUP1g7KLfuOJPFyUI5+Jnx94QmZvzDwNHBECa4MOFoBesVAZVeU7C4F/RbyHSzny2XJxY7FSVqy3MMW9RbyC3QYmkm4zvC0WoSKsG5C8enA+gsM1SmYmWcPcHLoI6dd1Venxz0qCxa7UnsfWt5CxVZf/vfRGT5HC7iU=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MW4PR10MB6437.namprd10.prod.outlook.com (2603:10b6:303:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.25; Tue, 14 May
 2024 19:10:15 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 19:10:15 +0000
Message-ID: <59aab4a0-df2c-4216-9378-3bf5d26ca537@oracle.com>
Date: Wed, 15 May 2024 00:39:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/301] 6.6.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20240514101032.219857983@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:196::7) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MW4PR10MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: a652218f-d5c4-4b65-6fab-08dc74497ca9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VVJLRjd2ajQzQVg3VlUycE9kVUVWcDhpZjlzWGNoUVhDUUxNUUF0Z0hWaVdq?=
 =?utf-8?B?TW5ETTdwbTczWXpWUytVMkpWVyt6NlY1RlhmbjB4VU5YcGZMOTJDRXlNQlJE?=
 =?utf-8?B?Mjd6VDFHeHQrNGZkbDhIRXBFbzY0Sml0Zk1WWVZUT1RSSnIzaWM4cUxIeHRs?=
 =?utf-8?B?cmhSNDBIQVk5Q3JGbTkwL3FCMUpvS004emtEV1dUU2dVRnY4STN1RGJ2Vmtj?=
 =?utf-8?B?cjV3NTVJbTZZR3NXNXpDMlhzRDRqaTY4Zkx6N2RON3U1bWIvWkZpbDZLS0Nq?=
 =?utf-8?B?cXkwdnlGNmpPbTFQc1dOK0JUNkZUR3pPVU96RFVrS2dkQTFlOE5YbWVNMXNW?=
 =?utf-8?B?K21BWVJDcktnakpxbEZPZlRGUXNQUmU5L2wvdWlUT2Q4dmU3b05DWUVoRytS?=
 =?utf-8?B?aWFONXFZZWlLU3E3cEdZalR0YmVmWlJScXBxaXE0ZWlZSXR4eERwaGpvMHVY?=
 =?utf-8?B?Q0RWWG4waEN0L251SlpDbzN6TGlINFNUU3RKY1dNbHZGQzBCdnpnN2J2RWZ5?=
 =?utf-8?B?eVkwaFdKYXZibjk2UEFRM2M3YWRPUWxwd1RtN05UWmlJZFpGZkMrRDlnZ2Q3?=
 =?utf-8?B?YThKalRVOGYrRStRcXBFZ09CTjZlR1FqQUZBeU9mUVhINWVHUU5MOC80dGhO?=
 =?utf-8?B?VkJSdmU3U1loSTZTWm50WHdNWUNsQU1idUlTZkNLNXFxWjFibGE3cFlrTis1?=
 =?utf-8?B?OFRpcWNOWmRRMmk4RWo2U3pwSGZSNXpvaTdRUzZBbXp1OE9GZTVEQlNtWDE2?=
 =?utf-8?B?aEM2MXF5b0VYbDZYRkg0aFM0cXhtTEtzTGNSQlRNc2tFaCtQRitoVWtrSGJl?=
 =?utf-8?B?c0JIRW9ha1gyNHlGMU9ydE44blNycmhwUWEzK3R1SEtKMWdRa3RDWVNEZzVp?=
 =?utf-8?B?YW5hZzZsQnphZloybm1lVlNpRUhDV3pnNWJ6V3kvcGJGWHF1Q3F6eVFZZTZD?=
 =?utf-8?B?clpnYXorYU5GUWJrelZSeVpyMURka3dOYzF1WW1kVWs3MjdSYjJXTkg3TXVW?=
 =?utf-8?B?eUovem5zUmxEZGdxRTY3cU5lVTBuaTBvcGpFeWdDTXpWQ0c1M3FxYUtjR3hZ?=
 =?utf-8?B?VGVVU2VPQTlOMFQ0OUcxZy9McE1CTUhURzcyQ0kyQVNnK3ZNS2tUcU5UZjZo?=
 =?utf-8?B?azJwOStGOHlHVTJRdGw4bVpzbnR3QTAvang2YXJ6NU1aaXpqMElNbEd0SXNU?=
 =?utf-8?B?N2YrbUJrckk0R0VsUjZGOEY1WnZhdkszVE1CQ015eFd5NHRpd1dhQ0dNSG8y?=
 =?utf-8?B?SDNwTmFLdWl0RncrM0pvRFN2cW1NTU83bXMzRWhkelpNK2JCWVdnWndJMms0?=
 =?utf-8?B?SCtUbmNWdWxTQm1sQ0dKb0tYK0xXc3NVa2pyM1pJUTFxVXBZdTVjUzh4eHpT?=
 =?utf-8?B?QnA1SmkwRC94ZUd1N3ZjbklSajZaQS8yWndwM1pHSjZJb3Q0Rnh1cE9jSTcr?=
 =?utf-8?B?WjFrMnRqVDloZGIrcERJamlNNG1QaE5VTHU2cWxJR1F3dElsQmV2ZHA4QlVk?=
 =?utf-8?B?elVzYXpBTitxRW1KOCtoUHRmKytDdW9LSWphQnN0K2VMbXk4U2RiT2x1NFZ6?=
 =?utf-8?B?dVlXKzhDU2h4RXUrMVExWDgzdzJaRGh5bVlLSEp1R2NYNFY3emEvRkxEZzNU?=
 =?utf-8?Q?ZRibI7ODgiqg4Jd7IYDaVUVeih7O8vwo0wWG0801a11I=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZjVpeTdzVWZxbXAzZlFQamU0TEl3L3NUdDczeU80MnF3THQ2VGI0SE8rd0J4?=
 =?utf-8?B?VU5qcmJmKzdTd09mT0JLdWtVNUpLNEVRVEpQbDNCU3pPU1lPYVdwbUlhMFdi?=
 =?utf-8?B?ZmthaGVPNVk0ZHBIS2dLVVRyeVVJRXNwc290a1pmYVpPVlRpdEhjOXBDeEdF?=
 =?utf-8?B?YnhQRnJnNEdkVitZdWRTSEd0MkhNU3pvYmRzTThoUDZNR0RVOVBJd1c5LzlE?=
 =?utf-8?B?c0puS2RnMWhlR3c0UTM4dEgzRmFDYXlQNTJ2cjNhVFUwL1JENDJLcUlZTFp6?=
 =?utf-8?B?MWo2cDBxbTBvc0RURmg0Vm1ITm9mVGFKMnErUEFyeis0TFFvZE9TTDdXTGxH?=
 =?utf-8?B?OTJlQ1k0QVF4amJ4UWluZVdNRXZVbzBFdm83ZXFjZVNpbmZ1MGFKOGp1aHNY?=
 =?utf-8?B?bUJuY1kzUUszSWdpN0ZDeHp6TjFFZ1ZWaENPeWI5ckM1aVVocTcxc3l0bmNq?=
 =?utf-8?B?eFA1d0pDQWJYNVZOdE9rZUNYNkFyRG5OVjNkeDJoSUwwQnNvUlN2a2lRSzVt?=
 =?utf-8?B?RmNkc1cxL2FHMzFzWVg4dTQ1dDgyb3RGY204VlNuL3FibHZTQ0o1bWVEaUdU?=
 =?utf-8?B?eXJDdkN6MWMvYUt3OHlsQVUyRHBURGI1RXNVb3BvOE91UjIrV0t1RjZobDRB?=
 =?utf-8?B?dEkzbnNqZm56Z3dKazRXYm1Rc3FOS0I5cllId0lKa3ZGeUpyNGtudjE3S01B?=
 =?utf-8?B?TWk2Mk1mVFpLRlZGb1JIOHpVbjB2L1ZvRlVKMEtPaWVpRmhBVTVCNHdQWHNB?=
 =?utf-8?B?dUtTR0ZlRjZkTmZoUHhPeWFYeFdSZzcxMURzcWhDYlYzai9WYi91bjhGTXNH?=
 =?utf-8?B?bWU2M1dLSE0rQU5mWE16UngrQUxqV25mdnZnM29vWU9UU3pnQ1lvemVTOE1Y?=
 =?utf-8?B?ZjRSMWVaRnpvcmh1NkwwaGdub2JqZzl1UWc4RkZsNjlPam1JRTV1aFZIN1ly?=
 =?utf-8?B?T3BFcnR4cmJ6dXlSWVZmWkhacHBCVE9teUd2dTlFVkdIbGpUNWZEV1ZhYXRX?=
 =?utf-8?B?VkJkMS9YRXBHak84Ky9wbGZOczl0K1N5cDZjbUkyRDJ3UmZ5VEdZTnAzWjZF?=
 =?utf-8?B?YWdjYXRmdEFBUURuMXp6R0NGNjlRWVJrTDVBbUh0Unh5NGRuR2tXZkFhM0hO?=
 =?utf-8?B?T0cvN3AyRk9OSzZUY0w0VDFJOGZDc25ZdHZwdzBLd3F5dkVERTBlR1pTc2hK?=
 =?utf-8?B?ZjBoMU5PTzBFbU9OR1pGZ25wdTBoNExkVkk2NFRaTFVMWXk3NnFqYVEwQVJV?=
 =?utf-8?B?dzBJcFd6VmdsYWhSMUdUbytsNnUyUFA0WmJlUjhQaktlbDdVak1xSUxCelhn?=
 =?utf-8?B?U2plQlErTlJacDdXTk1ZKzUwblNaU0pZYjhxS1hudEM2OWVUbmRjRHJUVi9z?=
 =?utf-8?B?UUw0c2JXQmp1ZU9OV2VkRmd4RDVGaHVjSnBQQSs4Vk5HRlU5dkFGRXVYcldK?=
 =?utf-8?B?YnJUa3I2S2h3Yno2SXB0WUlucWJjVDN0UWxjRzRhcXJJanBVelVRNGpVMGNo?=
 =?utf-8?B?U1F4bEx5cytxZUJiVnBEQkpMQUpoVmtnRlhuN0puK0ZtQWVjRDlJTDNyd1ZS?=
 =?utf-8?B?ZzVpMDFqTHVQbFM0blBFcGIzekdsZjUwR1Nrb3J1WHJDQkNXKzVmMUVtL0R0?=
 =?utf-8?B?V1dLVzQ2MGxMVGZOR0llQnBhYndOWHpUWWpUZ0lrQTRnTzZpRndkcW8vd21i?=
 =?utf-8?B?em95VmQzNzc3a2F5VGorQ2tXSHduekwyL2QxTlRxUmU0UHVZcnh4d0tUZXFw?=
 =?utf-8?B?bGhxOE5zT1I1ejF6dHM3QzB6TnZDWDM3YTZrdmRkM2ZIYk1NWks3T2hjNExQ?=
 =?utf-8?B?UWxvNEhSTW5PN2RpMVhubEN0NFJQRnNxbEhFQ0JvaGpyTE1nZHY2dlY0bnFO?=
 =?utf-8?B?WEVDMG56b1hKU3BaSGQ3QlNIV1FxV25qNEpzWmFzZWlIaWVCVkJISnFGMmNm?=
 =?utf-8?B?eUlxaFQxNlZiMzJwR1hXUHdzNTlYRm9ka2ZoU2YzTU82dlJETU42TE55WlF2?=
 =?utf-8?B?ZUVCc05EUUpnYnpBeVgvcUZJK05WOFV0RGNRamhjY3pUQ3N2TWdXKzNRL1JC?=
 =?utf-8?B?QU9yalB6d2ZjcG8zN2dFZHNMWmZhRm9XT2NUVzk5d0YwaDJ1SlBIdGdwOWw2?=
 =?utf-8?B?dVJBanpsWnlqaEJjaDVWNUhGdjU1dldjN2JheERsT2VhcUsxV2U1UFVZRXpv?=
 =?utf-8?Q?Vk4znc6NrVuW18j/wYwQ8BY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bxgxk+9C01VoFAnbLjoqeXWWpl8VrV5JfBrdFmDXe/wokpZK0Q4XvSOrHSJja/AtQy0Au1xgpSOtqlv79+ccaX8wjMxvTpKOtCIoGnNpBY3kL1bRzsmr4q3srlSiAXEuabpLQSpiJfhE+4J2ucgJ/Qpd37x2xocdb64YnZwhVS9EeWuCeGgKxrTb/FRE1PlrecJn0eKLFGYeyxyWTjQpyRbtBvcBLWeBI19jGhEEVrGx6/d+GnTOkeoN/UsRLW+S0BqWzS3dTL+ynychYQt2X/DGGZMXO6uo5aG2N3iVjDH7D4DB5Pmi+yrh3gAWSxtaLU1nnceLn72X/qVHzVm5xipVnhZNamryx7Ss2E/6Gex9R3hQ/Y1Jpxc1Qizz2JN690w065jK6pDgrKrWxIcfvRFo2/FltyjKXdHvwQxeUrgFtI8uYL845lRfnmGef7NEsq7wcVTbXv++qDVgb/GUoxpJ45TsKet165+DS4+8Dl91XgTcgEGeObPzqtM3AvYHALwOlXcLzLQenR+5Ys7VHzVjUuKFlcyA6a04xXcvBr0tK7T1j5Aj5cE8WiXUXzYCixvKXDUGqqcYekOwzsEwOUTqwgIJD8OMYdZ0DOMLtb8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a652218f-d5c4-4b65-6fab-08dc74497ca9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 19:10:15.5622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APyR9knWxu6gm/EgaONy3qPCBmVlPWYQsgvZq70MYZvkvasdAx4i18/osMHGRII1omhET/08JvLQnV319zsR4m7RnvIAlfT03o04OwiDfNlXBuO8e8kRooD6prnTvn7+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6437
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_11,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140136
X-Proofpoint-ORIG-GUID: Ose_GsOhRUdpuRhy6MHHJtAyHqKUBetx
X-Proofpoint-GUID: Ose_GsOhRUdpuRhy6MHHJtAyHqKUBetx

Hi Greg,

On 14/05/24 15:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 301 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>


Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
