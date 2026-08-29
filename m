Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E4B3BB123
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 21:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788039221; cv=fail; b=aIQsxd5oySzfI6UIo64VZadCzxveaZBnKAMJJX6P6cva56mWBG6oqikbFEp1tF/QlGwbqJHtuB+pS814Pipc1FseVo1YAXD/ksgVG8T52gVqL7zfhmmCnMxIpbqHGtjCg3Fqln4AQBS1QRerHH9RYuHrlGJ/n7XkqoqRY3j6znM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788039221; c=relaxed/simple;
	bh=TckY5NpF5XEUBbMFMczKegAUbu1di/V3zh7hQLDNwsw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OEQPvTzZF7W8yNufbVOewIXyvpqKPIwEgM1wksudQ32WPcoxoIe1b3TW53aTFuozFJV1R87Wg8MR8GJWn3HdT/YQp/06WDlCGsPv8N7LhECMw3JtLZXNLe/6W0MGnMqqjPJ4fhPKBCTq2Q1kiLnMEYs9Ilm2aB7zxJqyTsQmWkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hw1GTK5T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hmwcHpbf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hw1GTK5T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hmwcHpbf"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TLB1Tp1707328;
	Sat, 29 Aug 2026 21:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GekL70h/o85ceRvozHTYHGp5N+GxNi8E+SpVdpp5Vbg=; b=
	hw1GTK5T2jLDvRITTCYYE34Ns5GSeHKl25XC1cMsGM3BcAmjJEPc7C7a6W0Wp3HY
	qXbOOEA7ABAkReNTon5v9pVkuNOwA/a3Y7yRCqnbh9tQL21VZmSQLWCgL41qHWqe
	jbnLh1laCpgGojB3D0+dWcXrmcq3EbFk3pV2GCvPt/Os3rxDVr7l2ezL38pt1V/4
	/I1WbQRfH6UK2wKbiEAObOcoENp2BJNiq+4qvutDumRZw7WYKYhiDTD6PveNGlVD
	6NWfJLR4FmwrvjbK2HCoXCT15h/s6WPWRF7rhd/IaTQQKtD/UCs3V6i61694/mUE
	mTjcU1SNSipzxjZKjiHISQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xrp1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 21:33:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TLPWng015036;
	Sat, 29 Aug 2026 21:33:34 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvn8hpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 21:33:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMhBaCnVXIGKK3hZZqisCh+w90C3SEIyQVJwjbzazksHHg44ah4zced47cMimuTune+g6HFj28eR9+YmNvJNhSyLuxebdGPmINK91yZmatzw/XCHX/KmWXQ1RKEyuhFuIRUsylXtI+kwvIKSYBc+zyUeGwkLp+Wkkfdgn3jNVOelCXWrCaInZqSVkiA8K9u29PzqODztbSWJrpbdCRYtK3DH6PbyN9X1Eo74ssObl0/6WCjtZuYlIf7TI16HxmRk3dOyw73MDRRW/oHDIiYDZB5nX+WeCopJQZVUNqYqaViFBL4CMwsWHqzCUX8MwH9wBN0ZSfoG0il/rlKeLcIXew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GekL70h/o85ceRvozHTYHGp5N+GxNi8E+SpVdpp5Vbg=;
 b=Xl26C9nylF42h/U1C1jALnTAwpYEMH4DjwZUgO5Xsvf1KNMIgzL1cp3ImMfqbKSgJBjsrYnmNB3ZYFF4LmiyzRNKcie20w70uIvW3vOEkcNZTfTAP5DGgBmG3awwZYFQshlbjhHJYaeG9aLk7J9LzE/8DLZ+VrHg0vZ9hER1fLK7VtWro67czn7WxClXiciKZS1TXUm3YTUwX9j57VkQ//g13fDWGyl5TVm3VXhawfwp49fFll59yMYIJQkeUllGtWuGsVjrzqawYVt8Wi0AiGqRTQbRfiJMHmT1rKkT3zoZHLro1XzIgDlcLwzKJRTz4oBdPB3WU9gN+3oXmHLPUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GekL70h/o85ceRvozHTYHGp5N+GxNi8E+SpVdpp5Vbg=;
 b=hmwcHpbf4ZfxHYATIGvYFPYbU+SYtaEpLKz8CR3/qS7uhfepM2ZLPnQ+NbjfB5q55QzznrWjiuBJUYM9gqqM+6BX5HIw+rda1TPt6FHhoMLI2ebsAPbUjrWv9q4vdTeE/ZPLHEgw60nZyYZk5VBI4ElHtv1k4QJMfro7bBvLdq0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB7002.namprd10.prod.outlook.com (2603:10b6:806:344::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 21:33:29 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 21:33:29 +0000
Message-ID: <24f50ccf-4a9a-40b5-a1db-cc48a7acf556@oracle.com>
Date: Sun, 30 Aug 2026 03:03:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 372/456] bpf: Preserve pointer state for commuted
 arithmetic
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
        Daniel Wade <danjwade95@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Eduard Zingerman <eddyz87@gmail.com>, Sasha Levin <sashal@kernel.org>
References: <20260817132539.792407575@linuxfoundation.org>
 <20260817132554.044665534@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132554.044665534@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0141.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::21) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: 055add1e-37a2-4fb7-4f60-08df06152b01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|4143699003|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ml7zxS56LKnw79MC5RXANFIkKpvuc7//pFJkByV5F7PLpb06yK/jJ9U2+yj8zmrUs0oCR8iMuaj0m6XMJSmcjAhoynP1d1mD3k1rtane8xUR7aCzbZw9pbt7M1v/dmSCvw85hd2e589pmSQ9HAz2YjdhBZ5r4PuTriMNBw6yxRmd6EslPWwz71TYCcBOxJ62c2Pbs+9ef1MSgudTa2x6njkY4KGrXV+qB0T2dAEgndVIW+Q1UHnPycJFv3CNaYaJtWY8EExXyVf6TkmNca4nQee70q2vVoX3Zo9styR3ln45c0ejVqaJr/mxo11X2SJsohgh4hDWPchXbRgeEw9vd9JtYWvtIrdbjXzrz0qf80brdSXMz8K1bbHbS/z0yrS6BNryLY0ammRXTyMe0bamtFb9ndrSb3FnpnG49WvWRzzBiW9ujtovivmM56duT8UmXV8yASrSRpcz62Ka3FGpCul6K8XLMYkO/nCdX9wXRGeucMh7PwBZNARxUcqewHSH3+cIhj3GfbFkEisWTzWRCQRlQRPmLOx5hdoUmEip+uy5eYCGTT7aJB1GvHkQKvjqKVl446MQ1Vtj8cMqYFMDilWl77lNU7J48dWj7wmdO1k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(4143699003)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWk4eXkxRU53S0lvNWF3dFVFNzFsRnNRSWJrUlNKaW5SZTZ3aGpCb1AxRFQ0?=
 =?utf-8?B?Skw2akswdjRGQXVhZ1Z1UGRFV0h0ZkxkVTNLNmhJd2M4WElibGpjbUZjRy9D?=
 =?utf-8?B?SDZPTFdERUszdlF2cVZ3YmZwTDFyQXNFa3JQa3NNc1ZyM3hvaHE4dGVwQ0RU?=
 =?utf-8?B?YTFiZHBybUtXN3NOdGhYQ3hxbHhqbVVSZUJ2dnRsZW1EWk12UGVmMDZaZU1y?=
 =?utf-8?B?cDRJRzlodTZXQzgrOTlyNUMxZmNNSmdTSmhra3E4UG8yMkthYUVFVGtXTlZt?=
 =?utf-8?B?OE5QN3lTZXdhdndteWRaampLQjB5TXhqRVpuZWVHdkNyN2UzNHpMTGhxaDFx?=
 =?utf-8?B?dHRuZ2dkM3FSYzEvbGtpUnpkT0gxMnF1L1cvcEowcmROSmdDMUcyMXk1MDh6?=
 =?utf-8?B?YWYvNURqd3lST2FWejJmc1FDa05XUzR6Y0ttTFRmeWN1STlBdUxCK2JPMHdy?=
 =?utf-8?B?aEw2MDB5M2FFSnNmQVV1Ri9wK2dMWFcvOTVjUVRFd3NqR2hpV3FaQWh6cU5F?=
 =?utf-8?B?Tk1hWFkyNEFVY3habEE1QUhCY3JjTlByNzRxUWhLc0d6Z0lOZEJ5Y0FKTnIv?=
 =?utf-8?B?UW9DT1JudHNDNENKMG5lcDZtbXY0b2RSWkhMTHdDRXRJWjR2YzhyTGgyT25B?=
 =?utf-8?B?QWc2ZTlVV08vVG9mOHBEbmxHZzI1Vmo3RmorNFkyZHFFeGQvMlUzSHpPUVdh?=
 =?utf-8?B?RFhSZUhaRVZ1ZnV2aXFSeGtsN0pVQjR2ZmxFYkh6dFVaNW5UL2k1SjBWMndX?=
 =?utf-8?B?MWVJMGl4bCttd20rS21pQzhlend6c3AwNjVuTUxETlpONEQ5d05LVGQzR0lw?=
 =?utf-8?B?MTA5L3dqamdaVm0yWTRKRllMVWhFc2NIYStsUnF3U2xJcGN1ZnRPQ1pIOUo3?=
 =?utf-8?B?eGt2OFAyTFZuT29LWlErSFdmMXBLM1VoU3p0dHB0cWNHeHZSS3prbWtnRERr?=
 =?utf-8?B?VHE2eFowU1pmMmx1MThyeFZNMER4ZjdZbmJXSVZjblZFZVkwRHdlTFpKTEpp?=
 =?utf-8?B?ak0zb2NESWhyNEVoa3d2UFQ2eEU4SUpIUlcreUxaNFFZVjMrVksxdGRteHlX?=
 =?utf-8?B?dms3ajNKOHdaQmdqVitFRUxCZElHb2NQdFdxakJTcHRxNk1ZUmVPdnExOEtr?=
 =?utf-8?B?RlBiK2h2YjBoY3duRUNlZGJnOXdOWjdKcnJuKzNUTnh6ejNDaitKaTRTRFFX?=
 =?utf-8?B?TlB0M0lJd01pRXJzSllrcDV1dytxVndPYmFEL3hUbWlHd0NLdlVrZzhSVnU2?=
 =?utf-8?B?WGE4d1pHRmJEMEJ2UHpCR2Z2WnVwQkJnRGNGRnJYdURrS0dCZ203cTlsU1JR?=
 =?utf-8?B?VEpaaU55QXZFYVlHTHJBUDcrTllYWUdhejBMeGQ4NmZieGpDUDNhbmxNc0Y2?=
 =?utf-8?B?SjRXWDMwNnlQNUh5T2F3cGw3aUoybWNuU0JObzJROGVyNXJITnV0TTVJQkUz?=
 =?utf-8?B?dThYMnJ0eFlSUWRmNWZzamxVWlhadnJBNlVacmFKMkEwbHNPRk1qMmRFNVJ0?=
 =?utf-8?B?M3RRUVpoeXZJbWFsOXBseUdFeW13ZVBTamVTbzlwM2FHM1c0NVJVUGtoZTRz?=
 =?utf-8?B?U1U3NEpvdkc3L2szR1ZOUEV6VVVKNEIyYWZVTllwTWpXTDBNZUhpMWN3ZXpp?=
 =?utf-8?B?bUJBMUpxc3ZsMG9nbDhvYXFGR1hPRlpIcmNGS1o3MSszRHhONWpuMi9Celp6?=
 =?utf-8?B?WFRjdVVKSnRPQkxJL3hRZHlHcG1INDVSVEN0R3I0Y3JWSkFNeEc0dnk2SkN5?=
 =?utf-8?B?TERHMzVhQVJMc0xQNm1uTW9QQ2pKZ0IzL0poYVNOK2ZsOTJXWDMwR3lldHlP?=
 =?utf-8?B?WXhIY3c4dG9VNjBKc1Rya3JCdU85TVpSc2hIbGNza1dtcHc1aGorWUV4clZM?=
 =?utf-8?B?Y014eWpZUnd6K3JlcDdqTDF0b1AxT3g5UGY2YjFBQ1VUejhaVWhycCsyOUpm?=
 =?utf-8?B?WjNub2JNNHErcE1WSlF1djRNK3JBSVRkR2pyZ0RzM2NVV0lqZW1VZW1pdFc0?=
 =?utf-8?B?alRlQU1EdUR1Tkw1V0p1K0U2ckxmS3RxVUN3YTBYaVF4MkZRYlRaa1pyVkRa?=
 =?utf-8?B?bWNWbHNZazdPTmU1bUIrRFhQYW0xZXJjZm5vVGM5c2Y3a1g2WFRFNUpvVmRG?=
 =?utf-8?B?a1ozZk95eUE0MWRkVFo0cUJaeDB3clJyY3k1Y1ZOY1BqT09JV0ZGTUs4cjcx?=
 =?utf-8?B?UWZhb0hiZnpoZ2Q3QVh6THpqZ05HeFpsdHExazhPQ0FSR2VWNzlSRzNsTTBl?=
 =?utf-8?B?OFpvZzhaYnRWMGYxbnU5ZkdBQnFpb055OGNHdDVQWGdta21EdmlGenVxc1dX?=
 =?utf-8?B?VVcrbUZ1VW9LZUNiZUs3eCtYcXZ0Vmw5dDBiVTBWelRueE1jUEk3aEx0SWlU?=
 =?utf-8?Q?ACctHLsCcAk6vFuyUVj6BMFsfaymiMCzBe/3w?=
X-Exchange-RoutingPolicyChecked:
	UUpQg5ko8k76uC9KlNjzZu3uFBjw9iT/SRBI7KGhZc3Qo/L6f8n2Al6aypYvzJsq9Yq6wp91owGZJJkq9zKQWfGsrje+4GOe5oEuxzNr5z2Duzz0VEXMekil/WsRI/MDI9ZEhEew9Qf+Il8rN01FxtvpsdvClEVOUTJTpMSVkn9V51nAh3G6e6ywMRwbdTsnwa+dnFnN20ISFF5WX5WhHAmdA5p4VafcR7i7lxlYmPF9G0tTzGbzhaHrJV8JYQyM3bF9pqqAqG8T4koQ6SwnATDLGnFqDSQPnH3rQHxjGIt+VhhmoShowIOApjgNK/M4+aMXb2kz/0d52k8o3Hrt+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T/liX3+8IXbAZtVpjFMDctjsuADXuzW2Uz4Qf9dUnFggwwIo0a+CIPN2hNcdXV/d8epzXpiyhvYLCqE/CKr7+uHXhxS2NZDjaf65zPv1UyXFs03xVlzP9BI1TEcKuYZIB4q+AefHgepMlMnGx0hJP2Qa5CU9MkzRknjEkYALqDrUIZ0zilm54gXbbXhVjxGiCcYSGCejPCsHpGZsNlubyn8DaNUJzfABBhWL72u9yHGnGxcSgFuDkxiLMDxgojGt9bP6K9NVW27YQc135/dpz25C3q92RzEZbwUO8i08XR0KbNHD1znREby9i4uKCXxiBOpdH7ZE7aF4FXuaXLt7EnVRaTIi1y8v1BLBzMQOZQRmRubpnWp5tP5oesoz37LCQp4t2buFxOxrSbhM8s4UTq2MJ6C48G6Zj3Mw0l79ZBtUITIjriBQXXGXkDLwfcLtRzB2RuUjOYKtCQ6FFZurT3UVwhZ0ovCo4+ZrtdQBBNqLI3zx2cTzzPjmo/3CRi6PZ7Q7lEb+k8ixyeAxaHFW9TuNaLFbA12fGDW6K6dDNtpmuSvJl8GdHDNuviopPEmFB9cK7t9MeZvZz+VWvRekhwpI5Kxvoz9mR2VU2JHg/LA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055add1e-37a2-4fb7-4f60-08df06152b01
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 21:33:29.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4UBcvaEYLIe3NQGIXvN6IkGZAM0dLm5UR8ZthWFSgDf5yWPLkHuhQCEaaBpuFD7Xw9gT6YBZLv/3rTuGqi0cR8NQaDINeUTojKUgbEJijVpx1chiTVqxS8rUjOiaOO5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7002
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608290186
X-Proofpoint-ORIG-GUID: qqgqp7ScjF08w6lj9oLABZ5xU9OLLFiD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE4NyBTYWx0ZWRfX03fr9++wo4jj
 JiRFj7zgZYWdr8t0yUJJjwC1GOk4iCJ1hXeTcZtlM35B+f8V3J+4RbTPBRjdO4UDBNv5T7Jak4D
 dqwvRduhpiB0rj88d7ziRaLb4Vh/VDmoZgd1+iI34z1v7VAeuFN6blgotZUgnOtTvRVMIsXAjuV
 L2htjh1Q3Ab1D8wtT158fatRr3exPad98kJTyT4wFBQuWNnyXTIwuGPCLGGDwV1LTR9CKpM2zWJ
 D/v2j198uXG48Ymd4AWdzsITZE2nXE4eMuDasye8Hx2ijQtQ7cpZcF3eoV+ZKjd4IrfKBFqtQeU
 036W1D96bmHbMBqRENlBoo6Kadrj3ZdBLQCDLOA7XxFOiVMRwIrujTv0/W7rshmFdlsiq++T+Yc
 G17+Kpe1HXCg0pQseriE8WG+4ERMq+EXFBuMk3H4V2q2mp+S0pKN/fWO5JOluSsuntnUgpSQ3rA
 OwbMVHOmW14FR39zqrgo0j9SCFR6WoXb8WTi1pys=
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a93502f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=pGLkceISAAAA:8 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=xV0_5odhADDP_reDE2EA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: qqgqp7ScjF08w6lj9oLABZ5xU9OLLFiD
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE4NyBTYWx0ZWRfX6HQkR9C5r/+z
 TPoFRTX6fOnYhUtbWujULYPPQqwmTglxvKuE6KrEEcCXQwI7+//Lr0p0gtsWYYSsj5NL1RFOgIU
 PZvo2dcHrLOPzmzWYNG6HlG4JWGtwQTat5zyk/dvQtOWLgzg9bdM

Hi Greg/Sasha,

On 17/08/26 7:02 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
> 
> [ Upstream commit a4c6f804b44c5c790269b25e0e61cf4e9f117c86 ]
> 
> When scalar += pointer is handled in adjust_ptr_min_max_vals(), the
> destination register inherits the pointer state from the source pointer.
> Copying only selected fields is fragile because pointer provenance is
> tracked by several bpf_reg_state fields.
> 
> Use the caller's temporary offset register to preserve the scalar operand
> while replacing the destination with the full pointer state. This preserves
> the frame number for PTR_TO_STACK registers and keeps parent identity
> fields consistent.
> 
> Fixes: f4d7e40a5b71 ("bpf: introduce function calls (verification)")
> Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
> Tested-by: Daniel Wade <danjwade95@gmail.com>
> Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> Link: https://patch.msgid.link/20260729-c3-035-public-bpf-v4-v4-2-8ee297e2346b@mails.tsinghua.edu.cn
> Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/bpf/verifier.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5e71d58e4a300..a0163090309a4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7388,11 +7388,12 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
>   		break;
>   	}
>   
> -	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
> -	 * The id may be overwritten later if we create a new variable offset.
> +	/* For 'scalar += pointer', dst_reg inherits the complete pointer
> +	 * register state. Individual fields may be adjusted later by pointer
> +	 * arithmetic. Callers guarantee that below does not overwrite off_reg.
>   	 */
> -	dst_reg->type = ptr_reg->type;
> -	dst_reg->id = ptr_reg->id;
> +	if (dst_reg != ptr_reg)
> +		*dst_reg = *ptr_reg;

^^^
>   
>   	if (!check_reg_sane_offset(env, off_reg, ptr_reg->type) ||
>   	    !check_reg_sane_offset(env, ptr_reg, ptr_reg->type))
> @@ -7460,7 +7461,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
>   		}
>   		break;
>   	case BPF_SUB:
> -		if (dst_reg == off_reg) {
> +		if (dst_reg != ptr_reg) {
>   			/* scalar -= pointer.  Creates an unknown scalar */
>   			verbose(env, "R%d tried to subtract pointer from scalar\n",
>   				dst);
> @@ -8319,8 +8320,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
>   				err = mark_chain_precision(env, insn->dst_reg);
>   				if (err)
>   					return err;
> -				return adjust_ptr_min_max_vals(env, insn,
> -							       src_reg, dst_reg);
> +				off_reg = *dst_reg;
> +				return adjust_ptr_min_max_vals(env, insn, src_reg, &off_reg);

^^^

I ran an AI-assisted backport review of 8109c25e0c41 and checked the
finding against the 5.15 BPF verifier state model. The full
pointer-state copy needs a branch-specific adaptation.

Current upstream no longer stores verifier liveness in bpf_reg_state;
it has pointer-provenance fields such as parent_id and frameno.
Upstream a4c6f804b44c can therefore use:

         if (dst_reg != ptr_reg)
                 *dst_reg = *ptr_reg;

The 5.15 bpf_reg_state still contains:

         struct bpf_reg_state *parent;
         enum bpf_reg_liveness live;

and this branch already provides the intended copy helper from
34ad5d8885f5 ("bpf: Fix to preserve reg parent/live fields when copying
range info"):

         copy_register_state(dst_reg, ptr_reg);

8109c25e0c41 uses the raw assignment instead. It overwrites the
destination register's parent/live lineage with the source pointer's
liveness state, even though those fields track register history rather
than pointer provenance on 5.15. That can make verifier liveness
propagation and state pruning incorrect.

Maybe we should replacing the raw assignment in 
adjust_ptr_min_max_vals() with copy_register_state(dst_reg, ptr_reg) and 
rerunning the verifier selftests.


thanks,
Harshit
>   			}
>   		} else if (ptr_reg) {
>   			/* pointer += scalar */

