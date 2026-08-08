Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A196637C92B
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786210437; cv=fail; b=mym0IUG//cQOheACeQD6kCN79OJuIHTJ4pr3nyMHsh1LbztRSxzOrKm6lD7r+OMi4eNBvK1JgviM0gx1cDxHKFi4WJsKmghsqw80rhoQVglL8cwj2FL2CaYCgedKPtOE91/GkxhfixXJfN908URr6xqSskKe3YNrr5L1O+XMBVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786210437; c=relaxed/simple;
	bh=1/qxi5knVlmUwYjXFXv6fEW1YJMVo0DLefn79K1fr0s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AuX1QzWSC0hQneLBKk/Us2SDNk90GYIZgKie6Bpgu/TsEDNBl7XQ8+zvBCooYYmwnxXEdFgvGaI58IA1xnW4zcQNvHxcRna1FTDgCNwAbHwQ2VsevBLiA9KSutZhJjVpM2moWJkA4pm+SYHg3vZ7szSbcGuqO2GV4+nIGy1RzYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QkDexNAt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cr93SZ1F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QkDexNAt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cr93SZ1F"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 678FaskY4109752;
	Sat, 8 Aug 2026 17:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/iY5dUk7dp0l4oZy15JgFkSZWff1ztvLphVpiVhIpPg=; b=
	QkDexNAt873SdNpkhvm70Mg9/Ehy+IB/mjJ5JWah6/NunKAdvoiz3nvJy8z6+XGh
	noRFaczGgyZYAQ9KCFfpyddsrVNWIEQbISII/V7EsLMdsSD6dppZKWANlTA6sVVp
	yQh5NyRWfz9tgvsk47HL6GasYnMooD4s74PwPnvv3jqHUlFv5pmxdb21Fx/3mdRH
	+eU/1dgPJ9WxhrqkoRdQKJi5gDV9MbRlaKsmS+WaNSAB/xc6yQ4Iykm5m92K+VEA
	rG9Uoz4Bw5rTjVlK8B9h4S33q+GoMscWbF3WZyqAyto79i57J1d4xPUVXDJv5HP9
	Blpr3sk6RfRhwo/0sEQyHw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvesrrv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Aug 2026 17:33:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 678HOwav000573;
	Sat, 8 Aug 2026 17:33:51 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwapwmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 08 Aug 2026 17:33:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xRdFKGK3kbyuir5keoXKR/CcEacVTgupleCW9UG5Z6XS1pRMwp1x2RVyF4txIyXQRz1w+0p1PP/eWm9scPe6hWaNYacuzHb4ee/TnfBZ7ch2b12N6pwlhctlVW71cDhlVNO2Fqeueft9XqZCmP6JVPviEtjx72FSzgmJI3TxObWhA0EBEMotd85wl1AeWQtJ0J68VUUnp8d7IlpniVzDA5prgpehP28dBVq4UXgXFyBclAXCZ08uFWwmI6QJmxALcCZM4/ElaBHE/wXZNuVAncnY7q4bZKx7O/NAnT9BtwPzsc8ZK9BVUjviFVHD80puJK4UVCXsWmehn9euIUp/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iY5dUk7dp0l4oZy15JgFkSZWff1ztvLphVpiVhIpPg=;
 b=ZFvZOz/86zCKJRPEbB8vjYwl6KFI+X4pKoRqC8o9WT4Wnbr077VW2kBfTHNZYY7DEepE+jxAIPKG4vjew99j+cOxEgUhwETiKw5FECcB7yyF+NyQBRdwPRv0lIaYe9UywFtGxk9KkE6G0Fo5s4XOMVAV5fSdKbGmL+Z3Ju3g7/RoQcBNZUlJQc+5zR/M2CeZta6MrPLBqyE4UDoRGhbjiiPqG0ow2JMwrDn5nK5P7JLXHhJAZOje37kIDvrfp5f2ITtvRm6EJE/UzAmrAjuK7kAkuupSCAx0bFuFG7SYMuYl3GsUZMLRu89GH2eU29drAjqFL3PFgWfoL+dU4n5fLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iY5dUk7dp0l4oZy15JgFkSZWff1ztvLphVpiVhIpPg=;
 b=cr93SZ1FN2eNWFqugg6MYqb23drH/apEpg8TOwqN3Dzv96oPI8gNi6R8h1eBF+VIoKbfw+Pv8O0SY8FwA0XQRxGZReQb8ihGS6E2LXkUPFSyJ92FzfiTXEeLEB7g88+RapUJ5vVV6MKF1TRvbfSvizUt79UcXQWM40tKHAx5CXo=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB6975.namprd10.prod.outlook.com (2603:10b6:8:146::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sat, 8 Aug
 2026 17:33:47 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0292.022; Sat, 8 Aug 2026
 17:33:47 +0000
Message-ID: <3dfbd05b-7af9-4fdc-850a-91f93eb397aa@oracle.com>
Date: Sat, 8 Aug 2026 23:03:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 129/337] pinctrl: microchip-sgpio: add missing select
 REGMAP_MMIO
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Benjamin Boortz <bennib@mailbox.org>,
        Andy Shevchenko <andy@kernel.org>, Linus Walleij <linusw@kernel.org>,
        vegard.nossum@oracle.com
References: <20260807143418.516897842@linuxfoundation.org>
 <20260807143421.330302978@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260807143421.330302978@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0093.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b8::9) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB6975:EE_
X-MS-Office365-Filtering-Correlation-Id: fee87148-487f-4aa4-e542-08def5733405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|22082099003|10067099003|56012099006|5023799004|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	SDogzgYlrp4ambJR3vKxyYr7TwQcxOEwiXKcZ8iaW4pZeo/CsIjS8Sly1ttzvlb+787j1CMlEfBYiJOhV+sTWH0MBLGkV3V5tJcBxCaK4pheqvtxnooF3JzJ4EoOZRLERBxK/TFWjGsefY9VYOe1Oxt/Bi67H7tMu8X5ohRKEYovhkn/WKh9qetekWKeu0Ahrf84C7l1lXpO3lSpfGbD1wV3fC3oC7D5lV14ENC2ble8N3bj/dlr3BdjFI6PQwqZEGmbDsXh1bT7P0tKFktDDa2UswwSQxxZg6ZuKsh7hKqKh/XU/iQxgD6DNAFwFnv193xzX+396oMvxJS9eMjbiSjnQzz3XyiHLemhxn6x4iQf2A/KPds91fyPZFEzMrV11KdY9EyXwgM2pY80mxFMQvg7o0nMWZIQDUFB8nqkSzN2k9lbXkCVQpD+UWoi+A/bH/l8Tz28o/BnhAdEMbdZ1xW2TkORkIPn5F9qSn34JYbg92oA5KLkxBWpJccRKArmQSgU5LUFE8oEAooF35cXSQEZL6yHrJDMCobEiBMDB9AdBuiLroJpmVTZVA4Me2ZNab3tGsepl5T9b0XepuBs8kyMSdpic26vCGkqgGa3Qn6yiUx4DVaMTmcApvHsvQ/oF809l8iIO/0cjkEgMqlqFz1pRHD1MDXcx/9cCZG/HBs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(5023799004)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ty81cmRkK3I1ZllFU0JjVDNLT0dYZEZ1SVp6SmUzYUVlZWMybDNZZ2xXdm85?=
 =?utf-8?B?bm10MUl5bHhKNnJtV0dGZWcxdENxcGlqOWtVakdsVGE5VTBWTEZVV2JMdnNM?=
 =?utf-8?B?VlVRd2JiR1N4ajVJWFM2cnd2TjhLOUQ5TmZQcTZkKzdNejlIMFlSK1dCcWw1?=
 =?utf-8?B?bGpkNHIvZklrSTRZTFFPbXNaWlZ4YVJuL3JVUG8rY3VzNm1jWVQ1UFBWRDRx?=
 =?utf-8?B?NGx4NXZJM0pBY0tiemw2UUx5OEdzZTk3MGFqbk42UDFvQlRZYUdzcXVJU1pV?=
 =?utf-8?B?WERWK05lVzd0Y0pkNG1OMzdqZnFYc3lXc1g3Mm9hWjE0SklXR0ZKa2N2Y3Bi?=
 =?utf-8?B?d1RKamJEZkFINTQ0VTJ4c0IrVFo4VnJKZERYSFRqallndnpuWHEyK3JCRGEv?=
 =?utf-8?B?ZlVjaE5uMnFPZmJLb2hHSHY2RUxmb0NyU3JyUzVJeVVEQjFQUFVvU0Exd01I?=
 =?utf-8?B?dXlPeHJvYXhUR1M1S2hmYUdsMmlRZ3VKTy8yZ0tXUEUwSzRoMXg3WlBjUjhB?=
 =?utf-8?B?MHJ6SW5uODBNYTFtMjJ0dm8zbS9CVEZ3K1pJT0ZJd1dsK3BENTk3eWswQWtl?=
 =?utf-8?B?UzFqQm5ka0dkYWpOL3diZmF1WUNrd08vOEVXMFR4c2cvaVJ0cklDVm5yaHh6?=
 =?utf-8?B?Q1o3TG15czdyTjkyMDMwVWhUOEljL05vbkVCdndiRWNPMWNDZEEvRVpjcWM2?=
 =?utf-8?B?Y1N0YXhjSEJYVTRMRVJON1kzK1dBanppSW5OMUpnWlNMUnMrbk5qY09naGkw?=
 =?utf-8?B?U0cwUmpHWFV2UFc5MExrUFpHSDZaRk9jRmdzQ1ZiTnEvUm1tNVBkbytxMmRP?=
 =?utf-8?B?bTlJUk1QWTI3eUE2WlROSTJVNDJiQTBuY3hZZ2o3ZU9sa2ZaYXA4c1F0ZG5o?=
 =?utf-8?B?OFY4c1JaNXkzWkcrYWlGWU4xWXJnYXdoVEhqZFhMakQvNjZWOGJqVXNQVGRr?=
 =?utf-8?B?elp3dXBhQ3pLelIzc3JxdHhQaFZmMkZvNFQ5SGhBWS9TRmRnYkNZdWdkTEg4?=
 =?utf-8?B?N2hrUVdWelE2UzNFWndnWFVXN1RvOFdlVFN0QThhQm43VmFWSFpKM0hyaFRj?=
 =?utf-8?B?QzQ3cGFHMklSaklwVTgySWg0WGJFemc4dmhBT2VQVmdlWDZ5THZjblYyUktW?=
 =?utf-8?B?SnNrQllJTkM4TGdiTm9adnNvK1IwYkRoWjZQd0tuSXhZVExJM2Q0UjZjY3JG?=
 =?utf-8?B?VnNwdmFWZEx1TVBiMU4rRDd1MDc1bmh0TUJVcU9OR1Yzc3pURVdUSUVwVURy?=
 =?utf-8?B?c2JEN29uaEVNa1AxV1l5QU1tM0lRcDF0bjJxc0l1OVdxQWdaaHlDN2hIbkM5?=
 =?utf-8?B?M3pyZnZuWXRGR0RhNGRtTzFWdUdWWXEzMjV0RWI0SjhHVVZDeUVNNzdLbXgw?=
 =?utf-8?B?Y2t4Wm5xemdlZWdoNTRKMy9MTThIcEZXNEJnZGxHMFVzWDVwMnJET0VSMTIr?=
 =?utf-8?B?dzRqd1BCUHJRck5UM29wQmEwWmNkMGhtZVNMZUlWa2htbFRsZjloTjdKME9F?=
 =?utf-8?B?RW5xaHQyNTZOY0U3cHR1WXdGOFJkWFFxci92cUEwTG85ZGo3dXRJM0lUVzh1?=
 =?utf-8?B?eEt6eVg3QlNjem14dHg0TTZXNWVTYVhBaytpVWVlQXluU2hFUnhqb3JCbWND?=
 =?utf-8?B?SUM4TGZQeGJ2VmxDUjFJUGE5OEcva0tWcEZNdjJnQVlqUDExdjVETkcxN0Rz?=
 =?utf-8?B?S3RIYUN5eU5DT0R4OW5pSlJvRFUxMkN5MHJZWlJRcGxsWWt4NjAycVBXamN3?=
 =?utf-8?B?cVR4THY3NWRYVkYvbVVEK09XeEZIbE9QYjJOUW9XTmluQjVqRVpXZjNUK002?=
 =?utf-8?B?bHdsZlVzSXk1cVFhN25mZ2NWdE5xWmNHQTFQMU9FOVkvM3A2dGlxalJkMDhL?=
 =?utf-8?B?eTE3czl0UjJBUW5RbnZwTGU2MzhkSWFZRWtURDQ2S1BDRTRJZnJQeloybEor?=
 =?utf-8?B?MGswR2Q0blRCa3p5QjFFeFB5N0YxWnJoRmRBQ1U5QXViRFRKZEhrZkZITGN1?=
 =?utf-8?B?TEVTMVZlSjJiT1BqU2tsY0JSL3dpOWRlRG5rSFZFMWZOT1pFcGJRSGV3eWRC?=
 =?utf-8?B?QUlJZndnd09BdjlaZit5L3M1REtrMmQ2V05ldGo2VHd5ektuOHpYUlF5eVIr?=
 =?utf-8?B?NHJrdEg5b25Sck1mZmtwSWhGSWFLdVhwR1RVU0JCcnZzL2p2V3R5TnN1dzkv?=
 =?utf-8?B?RG01SHk4VGoxMFEySHRzS3piem5xS3BJK0FLME9MdG12MzNVL0I5Mmt6K0Yz?=
 =?utf-8?B?YzZMbkYwQTdvbFE5bGQ0SjZ5QXpQMXVVbDFac21FNjJKZ3JadWJDKzYvR0Ji?=
 =?utf-8?B?T0d4UTVqd09IZzNuRk12L0k0aWc4eUV4Y2lCWm1BZnBDVW8rOWVFejQvT1lO?=
 =?utf-8?Q?/StDj3VfQnvfla7t34iKASJdR4thEQxXuACJt?=
X-Exchange-RoutingPolicyChecked:
	cGie5aVS3s/6GbeC6RBW5XQKcLr3+CQieCcJc84HHWWwUaxmMjJafwJeFINcfSUGbhXlzC/+x/VTDTipS3KdeHwSgFfkJLqfkO2twJTR5fDdJjMT2xn89ufgybP3JL/XpLhTgteBgo3Spge1aaFnlTVq4+4Sbg8J1ksKzUSDYsI+nWWjBN46cAq9elvo1TIFSVrAy8oX9j9qtfpL/OmJ3Q+lPpHi0zI2IZY08aY1rNelcdKsBNSaQOBpJf/FUsIGNUdrfFSZGHAprcF3NDEQ1F1gy9rVs5dV5SKYJQm7mCiWVXEUOCZUeqLtWRd4EnXWjeVt7D9zy9hMnJ25uQHQpg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QdJb5pwW8a5/SWc4kcZe77V6N/1+3aERLmXLgn7VEvixliKWY3vu7W2SjaoUaroLr1LVxDPyv9qwtov/cBJVeRp3XDM+blyrjMyttPQPxxzPb0Gc1h6WVBohJT0dL3+iq5h+8UNpe+SqgJXQg67he2wD3P0+HWBs44JBCG+UWZgPCyKM43gmhttFu2cisS3FFNBuiuPqyma82rI9px5GmusZDteiwVsu1lStf+5QMYB9bmFVw/kjr9iJrhqhp2xe1W1/8aDYyaWYXH8Xu/7fkwtERkS57J3VEsFGf6KY+U8W1AGFcibcF5hOXynFJ/1jMxpEiCHtMyVSrFZROr0c1Rg5CyMV9QrJ/LX+pkbFKSXY+q5yNrb6BGZChiDibanxZTuiWX4rZKSoWfizVDvIwWKmOOOzR9eUoq+9Ga7Hx5iZNrwI6zdAad+n64rhS+jKOshSrQ79WGuJINQVAw5q9xtrPdCYPPnLTZ1lFqNoPfGx06ifohSr+ID5wqSN9QJQHK3+5otiTZVqt60Dj7eP6eXAgzXw7MRW1gc1j3WtgDMpZ9VNhUi4PsCTXNj/kockWjmy3msG9J7FmlTvhxtrew2eZLFtVXUcOj05wnjIVls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee87148-487f-4aa4-e542-08def5733405
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 17:33:47.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOB2zZ5d0C6Ds5xRxiuzQdnRow6Bn0IVhfyC5q2orTnGfbvf9fqdVTCJjYaNmBlFnx30jANJ5UX424Zl1djPh4yshygCwpceNZYYNb35r5fiWy5SyQYP1ZShR3fHSVZm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6975
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-08_06,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608080150
X-Authority-Analysis: v=2.4 cv=R8wz39RX c=1 sm=1 tr=0 ts=6a776880 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=b3CbU_ItAAAA:8
 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=ByIkLN7CMEE-Dtb9SG0A:9 a=QEXdDO2ut3YA:10
 a=Rv2g8BkzVjQTVhhssdqe:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: CBsmhi9vrdH6OWtUD6V5-r9-My97OoHZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA4MDE1MSBTYWx0ZWRfX93WwjuIxANPt
 fQliliyFFGRFXi1Kdmh7lN+ozagaVInMqi9nQ5NBQV54AnlINK+hHKgrbGRA/tmXfwTF9rZJUzI
 7qTNwp0fLCjFrnqPAJ2Bm8zGv60TEv8OoK1IRkr1XuhJ15BCukRUI3NMmDczg6cT8rqWZymTvfF
 FOS1OCFI8OJrNBOkKJCLiUTtkjdal2JhQxFgr+WfsAMTLnYaChGvphLVYgXqhIB/UZjVE0px0+4
 SaZ8Nnce06w5RIbJivF9syMCd8Y7Sexe8bxT/CnIqOKj4H7DyDxBBYFDY8FiEsohFKlFeIiCU2o
 nEgK5f6BVh6R3DLoY3TND3QhAI8te6neLhPsNMJ+XnERQqQdA6pDEEzesv/Hxx5AY25WirOjHWr
 WqxXDXLOvEW8/GpkQxGDiPAmpFAOBAIyfA6tvdzXkLwigZj/lN6Beo/I9kNxv9f2xpOOr1IsEVN
 7bFDoF2aCqL40XIbolA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA4MDE1MSBTYWx0ZWRfX3Pk4v1AQMeMZ
 Bd6EJeD4xPJKSqvaO6GfQeKAQiWNGaGTUx8Zct4d569812BTd1OOMaI68RdwG21E17NHpJ20F3C
 N8hg1NuOYwhaSQEuAt3EabNUI6HoyOephk/auvwYzI7jNMrcj/MN
X-Proofpoint-ORIG-GUID: CBsmhi9vrdH6OWtUD6V5-r9-My97OoHZ

Hi Greg,

On 07/08/26 8:05 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Benjamin Boortz <bennib@mailbox.org>
> 
> commit 25cb6e9a13123d1039cdc75b446ac52e1ebdc26d upstream.
> 
> The driver calls ocelot_regmap_from_resource() via <linux/mfd/ocelot.h>,
> which internally uses devm_regmap_init_mmio() and requires REGMAP_MMIO.
> The Kconfig entry does not select REGMAP_MMIO, causing a build failure
> when no other driver in the config happens to pull in REGMAP_MMIO:
> 
>    include/linux/mfd/ocelot.h:34:24: error: implicit declaration of function 'devm_regmap_init_mmio'
> 
> Found by randconfig testing on arm64; tinyconfig reproducer below.
> 
> Fixes: 2afbbab45c26 ("pinctrl: microchip-sgpio: update to support regmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Benjamin Boortz <bennib@mailbox.org>
> Reviewed-by: Andy Shevchenko <andy@kernel.org>
> Signed-off-by: Linus Walleij <linusw@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/pinctrl/Kconfig |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -213,6 +213,7 @@ config PINCTRL_EQUILIBRIUM
>   	select GENERIC_PINCONF
>   	select GENERIC_PINCTRL_GROUPS
>   	select GENERIC_PINMUX_FUNCTIONS
> +	select REGMAP_MMIO

I have run an AI assisted backport review and it spotted an issue; I 
checked the Kconfig delta and the selector was added to the wrong symbol.

Upstream has:
config PINCTRL_MICROCHIP_SGPIO
	...
	select REGMAP_MMIO


The posted 6.12.y change instead leaves PINCTRL_MICROCHIP_SGPIO without 
that line and adds it under PINCTRL_EQUILIBRIUM.

I suggest moving select REGMAP_MMIO to the PINCTRL_MICROCHIP_SGPIO.


Thanks,
Harshit
>   	help
>   	  Equilibrium driver is a pinctrl and GPIO driver for Intel Lightning
>   	  Mountain network processor SoC that supports both the GPIO and pin
> 
> 
> 

