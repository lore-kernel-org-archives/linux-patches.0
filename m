Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8092586C2
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 10:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739528105; cv=fail; b=YmsDO3MyG9OyKnJvKkt5y7kwXjEND5qiGacCnDHfIbRCXM3LdzwiykAJp0A5NVsZLW1t7t2pGrsfMBgrMWki+MJzj4KauFhzdI53bhLvEgSgFaFZiRl1JjCDRV5NAGaBQ3EHjbjgwRrQuq9+37U7QzqMYpe2BRqieZIw5XrDsag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739528105; c=relaxed/simple;
	bh=Txtu/xH7UNthyIb4LCrxsBCEvh/dOpo63auhgCxR1Mk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PcMPj7zIziuDh0svY9NYBIjF5oaoPoycu0fn0SWmoN0WmpSrp0Rpt55B1gu2kpkKzuQmJrSbVNowabUUQxgfWtNsHHRZB/EOpTvUUlgbeWJC6O9Fpc0k7PSVsNcIawOveenW4HII/NHqPV+cHTxEuaLG1/m12PhYM0p8/no5bYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OdXwMqP2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F/nJ6a+T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OdXwMqP2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F/nJ6a+T"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E7gXfF011495;
	Fri, 14 Feb 2025 10:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=n+d8Q5dosP7plVtvXtXpHFKRoLlWbU4Paqzakrz49Ag=; b=
	OdXwMqP2C6lJR7CxxB0frWc3j9z8bs3ZvwRqos/EycBEHRbNVuJEXFS3CBSr6Il1
	STb9XMkVem/a75m3K1gDxeXJLljaYPqaeiywP9rUP9D0qOj/xWEM7EeiUY6ojn81
	K1QKWUC6I/N8nXPCPgAa3L1Bm4hCnSNr9ohH7mP2amiwSqBex3Clwg+DffVSCk2S
	5b225qEWY4caBnixGAiYiyiSLEciukqyQdoa6pYqaxRvCAQUiw0rjcFexZGFwjRu
	geOKbajHvcefr4tYBJfjxD9G4bL6QExOIAR6kDIBOK51yAxVtkzUBkBKmFRDEEYo
	DC3LC5jBz77uXwFfwIqvIA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0tnbbhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 10:14:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51E8AuPQ005296;
	Fri, 14 Feb 2025 10:14:46 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqcy0nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 10:14:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UtcDgwmzZW5w4E0mhi+aym816C7sI4OLOVRo6BQRJWNSKqimYj48yABDfGIjlv1v8zh48aq371B2AVplwa/Cs3jIKJGfEpd/VkFW8Wkh+cu/aGSXDvp0IeLt+pS00fnCDrb7HvhcP+tKW7tWn2YkkUBjPNxNGP3PyNekJPHq59aWGrYJa7yGu+Rt8O6KZVfdlEXVPehPJ4OX4mXgNkSrhsc2WU/8Hk7cQxxDsyBh0ry44MWGeywmzo+IbUQyewVlzXp2qZdN259ysSiTfF/SWL297JOL3NCGInWmb3rhUyQbrWZXejzL54xikhSvwGcl3JXhrXqiFgASPezyEhOrdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+d8Q5dosP7plVtvXtXpHFKRoLlWbU4Paqzakrz49Ag=;
 b=jp0PzODkfNFoEc61y+iob09uXV04NAa3GbKX7th1G/izt+Q6vWmghiS0ru7/illkKmvGID4gxtHk2fb7hVIKY/BBIK3rfAc9xWtejTskwyVGNCmYX46wJgbaJ0rEJ38ZqSIdShW/Z8VM1MAmUouIaMNHPIxtN1Y0bSLyaYbh+WY9L/FCVNQphcglTvEHP6wAs0fgNSr1sx+OMwsm8nIMGgUs7ztUWqars/qoNX5UHMv6vUg+zyxPOG8kp5AtgLk2SMF1HSjvO5VVq/D4BcYqyKWuJe33O/HMpItk9kt4sjxC7jjiuk0VBQCQ1OeRVW82Me8ZVLkrrvqax2JfsolDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+d8Q5dosP7plVtvXtXpHFKRoLlWbU4Paqzakrz49Ag=;
 b=F/nJ6a+TU65bqWt1JjOTVSZlup0jPIK+pF6p/kbBdwg05JX27VnnDCDsdNY+R6YBMnvVaBhLaRL6Hz+X+1QzwCDTl6IBC0OM6m1dsvryNkN31vrm+OsM3j3GP19zmw3VJG4J4euc5d6LO047tIoWr5kPydBbpIF5iFx77DoL3Mc=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ1PR10MB5929.namprd10.prod.outlook.com (2603:10b6:a03:48c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.14; Fri, 14 Feb
 2025 10:14:44 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8445.015; Fri, 14 Feb 2025
 10:14:44 +0000
Message-ID: <2a673a49-29b9-4101-a125-4c7d886dfbc2@oracle.com>
Date: Fri, 14 Feb 2025 15:44:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250213142407.354217048@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0186.apcprd04.prod.outlook.com
 (2603:1096:4:14::24) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ1PR10MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 520c04ee-cf30-499e-ad4d-08dd4ce066c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUd2VXdKWVRoS0VrMHBpZHRZdVdVTndlQStUTXR4MWhhL3FHbVoyYUJVQ0hC?=
 =?utf-8?B?ODlmNUtkS2NlZTBnUjE0TWhqaFB3OXg5dkJUaTJoRUVVWityRy9kSm5qUXJV?=
 =?utf-8?B?SEdFOHQ5amx4YjZ4bkR1NHVpSzNic2tlSk5tUEZZME5BYzZkYTlTc2g2VC8z?=
 =?utf-8?B?UzRKRXowNlhGeC9Ubk94R2tkZlUvS2lYOHpzbUk5ZVI1SVZNUkZYYloxRnhq?=
 =?utf-8?B?UlJHYk5jKzRsWko1cFN2bGtDQUVNYnJHZnd5Smk2K3F6T29aQnFWcUl0d1pQ?=
 =?utf-8?B?ZnRuQTlFR2M0MnRTSkFRdU5IVnlXS2M0MldXWnBZYmtFRVVIdHd1Zjl5bU1X?=
 =?utf-8?B?bFpYK28vMTl6aWJRdFViaEpoejZEVVdRN0lNN1ZZaDE3dUo0cUpNMVBtR3FJ?=
 =?utf-8?B?a2tLRHNpT0NVZlAvOVk0dng2UEJ6ZXkrREJyeGlvb3pWclE5L2FYY0RIazg4?=
 =?utf-8?B?d240ZmV1VTJJVmdncklnbjBZNTc4elozK1QxeEhsTk15cXp1K05FQlpOMUxF?=
 =?utf-8?B?dmNJZy84SW0xclNMcFlOcURCZG4xbWVtRUhkNWdhM1RWWW1obUdGbU4yOHpm?=
 =?utf-8?B?SUcySTJkamRmNXJCdERSdlJTUXF1MTlqOXNodUwvRE56ajRvUkhPaVowcUhw?=
 =?utf-8?B?c0RNSG1rRFJHOWZKS2xzbCtkR09DdjJweFFXenFOREdPZ0Y4TjZwbS92WVBm?=
 =?utf-8?B?N0JhQU9laThMUlh3TWkvWVdySjJJaDc1RTlPMXloKzNXQXV2UUhnaE50NFBa?=
 =?utf-8?B?Z1lDZjBlUDZOeXdCbW1GQnZKN3Njamc4MU1TUHYxL3pDRWtobXJhZTdOOEgv?=
 =?utf-8?B?Z2I1a3l5cVc3d3RGZGdkUUNtVUljY3hYTUxOQ2Z1UW1tNFVINTJDeCtLNjJo?=
 =?utf-8?B?eEJDZndtZkdBeG1xb1g0VGtRcGEvZmRPV2p3UlYrOEE2VHNkS05GeUcwVFVU?=
 =?utf-8?B?MHFsVzIzd3pML2gvZDhFS1RSeU4wbXNNMGpBUEhUMmtaQ0Vnc2Z3Njk4ZFdp?=
 =?utf-8?B?ZkVKdVN0Mlkrb0RDR09LbXJmK2ZmVjc5ZnZyRkxrL1o2U0pFUlFPMmlJQ09h?=
 =?utf-8?B?cXlnWmZlTzJZb2hnNDJOSGgyaUwwQnd6VURQOHJtSXF1ajRHTlR3b0c4bTFW?=
 =?utf-8?B?OFhGMHhaekR2Q2VReWJBWmFPN3dhSzBUL0NuKzdFK1YzaThQNkQ4OGUzdno3?=
 =?utf-8?B?TTdUTjd5dTAxclpEMUhhNlJhWjBkS1lWdHdoMW1heVFKTEFLZFU4bC9YWDZS?=
 =?utf-8?B?MXU5aHlqeEdUV1gwUU9OQlZ2UVAyWkdrZUNZS3g1b0djUndNR3VOVEdTNDZa?=
 =?utf-8?B?SFFDS1NFZ0cyRHNaY1oyYUh5ZFdXdW9FcjNOKzlwbGhicDJBb0RKMDhNU2Vp?=
 =?utf-8?B?QnZGVkQzelpUbytTWUlKOU5lSzE0cHFYRlVuRlVrQThRckRnY2FKWXpSWmla?=
 =?utf-8?B?elZuRGNSTEJyeDhnZnBjMEcxaWloYWxMZkFLQkJsQ1BJK0JNcDUyR3FjT1JO?=
 =?utf-8?B?UFRFa0tCbjhVRHUvUCtIK3liaFBFSnBkUENWN2c0TDI5T1daWEt6b0NkU3Na?=
 =?utf-8?B?VHRnREp5c0xMQ2ZwODlKU0dNNG9EWEpUUDlNNGgrMDZ4dENXTEJ4a2lmcGJP?=
 =?utf-8?B?UStacjJwWWc5S0pNVlpseDVBVHVoeDNNWHZuYTJQUmJQWHVXdXRyRS9TcTBQ?=
 =?utf-8?B?QjZsYTVVRUlXR0c4WjAyZjVuWm9TeHJVYk8zQlczTURmMnpQRTlhZnYvRjRh?=
 =?utf-8?B?NmVCMERTQlpaRVhoUm11ZXk1UVJXUE1vZ0xvTGh2eDl3WFhVTnZ6OE9OODJD?=
 =?utf-8?B?aDM4NU02eGxPcEd3dmswUlo3NU50Q0kwSkVCSk5GM081c3U5S2FnUzJVSGpm?=
 =?utf-8?Q?41jSlW4xfrcoo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0pNVXF3WFBNSm1MUzBqOUd5a21zdmNBeGRpZ3ppTFJpckdCOVJ0eHI1cndv?=
 =?utf-8?B?U2ZBbUs5WVgrOTQrc1RiSUpMdjZLOHJRdWVyTlErK0Nmem42eWhweEU1RVp2?=
 =?utf-8?B?cFZSTWk2bjNCdUovem5qYm1tSTZBL1ZDM1JkRUNjQWthWmxsY2xKZXlUTTNh?=
 =?utf-8?B?ZVNETTh4dXlLcFV5Zjlmc1UrMS9yVUVxd0V1amt5Q3BiczZVZDljZG1vaktR?=
 =?utf-8?B?ZFFPa1EwcXVnVkVkTEdnTEQ2VjVJZ1JIdWJJWEFRd1RBZHZpWER6em45MUZD?=
 =?utf-8?B?REx3R0pMTURuN0RjWkpnc2RkTEdmTEVESDNXUHNCRjNTdmtmVkRGajc2cGpM?=
 =?utf-8?B?RkV3a0F5dU1SZ3djQ0xhNGNySUdMZTQ5c081dEkwSnpxQ1d5L29oazk4SjRU?=
 =?utf-8?B?dnkvaEQyWFNXekdQd2ZNUk16MlZTUW5NTXFKVzNDeHMrUVJYNHUvd1RybXZi?=
 =?utf-8?B?NWNzMDNOZjg2V0dNT3JnRURnU0N0VytVOCtYSkc3UDNVSnR1Q0lXSUJFaFg1?=
 =?utf-8?B?dzliei8zMUk5V0p0Qi9JR1JqSCtVeTR4Nlp2NC9SV1c3bWxqdkhqRTB2LzVN?=
 =?utf-8?B?S1BjVG1EdS9HVDNHdnhHbXphRG9CSHBIYk5EWkk4c0VIUHVrR0t5c242dDVX?=
 =?utf-8?B?NWJUSnhkb0hhUVViTjgwLzV1UWdEZ0hkVWlad3cyS3VxR2NjaEJOMEZ3M2ZP?=
 =?utf-8?B?SjZDQkdmYlpPSFMzeU9kbDNaM05ZdHdjMExXN1NZWVlETExDZ1lUdURFdWN2?=
 =?utf-8?B?K3h2Nlk4bHFhZzdvWmtncCtOZEhTY1BJN0VvY09DTWNpay83R0pLdXdCZkdL?=
 =?utf-8?B?RVBlQzFLbXEwd3VFRHNOL2F0cFgzU0FydlN1NXkydU5NZ1IrU25WVm84NVVl?=
 =?utf-8?B?Q1lxeEt2eWlxV2xxbXAxZ2NBUy9RY2JGbG85a3JGQzFTUVhCUW10REVLdDVj?=
 =?utf-8?B?eWRROVBTRi9nMUJJbWRuZThBelg0a2NaQjRMeHluekNHYXl1cUxTM3c2bXU5?=
 =?utf-8?B?Mm1QZWQvS1EyOTYwa211QTNUNThZSTY1MFRWK2hHYWQ4ME5aa3RsL0R6cUZj?=
 =?utf-8?B?MmNpT3hSQ0F5b0FONCtDWkhHbkRVMkFUeDNCUzJscGhaTUwzUUlxN2wzVjVj?=
 =?utf-8?B?Mk5Relk1aDcwL3F6Qi9lQVhzMnc1SHR0WnlvcVc2UzFkNU9LQUZmb1F6TVVL?=
 =?utf-8?B?YU5jczYzTDdGNW9weHppbGNZb2psUXRzRkxvS04zRm1TaFlGY015WFE0M1Vt?=
 =?utf-8?B?Q2xXRU9KL3h6ZWd3SG82RVZRQ3hwdW9PRWZHMzJmMW1OLzNIWXJqVXpWRHFu?=
 =?utf-8?B?dUl1emVBOWo5bWlSNVpoKzR6WkJrY3VGMEVOZEthSnhOZzhPUVl1eWFMeG9L?=
 =?utf-8?B?VkVaWDlyOUd6OGphUVZocXJ1Z3NHczNJOXh3WWxCa2RuY2pWZzhXMm5PRUdL?=
 =?utf-8?B?bnNFVGV2V3krSkdjczFjaWZ4ZVlxTEhTN0JLSlBjUzVray9tVXI4T0xxakkr?=
 =?utf-8?B?NkhEUGZYNHAwTTcwK3BFcS9OeENCMGtPNUtQTlhIY1RMU3gwbTk2bkkrcklr?=
 =?utf-8?B?QTdGT3BlbU5FeG9TM3J1QmZUQkp1VUY0a0t1M1VKeENQRHkrQy9jZGJoOTNv?=
 =?utf-8?B?VlVaN0tFVFEzcEsrS3IzV3J4NDBSUFNNT3cvQlprOWhOdHdENnlHNlV0V1Vi?=
 =?utf-8?B?alFtZmlsRVZVUEFEWTJhcGxnTUxIWU0vQkUwcU9qc0xPaDdSbWd1OWhuQjZ4?=
 =?utf-8?B?T1RQUHRIaUhsb3luSGs4ZHpzSGZoeXloMlNHcytVbDdhS3ZYSEJuNnI5VVRw?=
 =?utf-8?B?cVJubVQvUHpNSjZCNzhDV2xQVVp1SHF3UVU2NnE3aS9WM1p0dG0zZ3NDN1l4?=
 =?utf-8?B?Q25uSU9ZOEZSbXR0R2gyWlNCN3J3YkZVYmFhZHVobExSbkFObk16RXA5ckJF?=
 =?utf-8?B?RTNNSDcrUlcxN0xCV3I1L3lXMjhhdU1Wb2pyTHRRekF2NzhHNHhhVHFhZm9E?=
 =?utf-8?B?TktkSUNFU1lDbmlCT1Q5U0NuSHUyMndQMkZrWUExMFk2VUhLYVpWU3JRSG5h?=
 =?utf-8?B?ZjE3aVNjbnNJOGlTbWJwOVZqY1FjRlRmZmpSYjI4RlRSVXNleGVMM3pNV2FL?=
 =?utf-8?B?ZDJCelJTcEorTlRHVXN2bm9ScWFqRkYvcDFmZzB5NE02K1NRaVZiUDMwaDdq?=
 =?utf-8?Q?PFo2FPZy1gZvEYPCo4U+daE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OeszS2MYiq3aMzay57EBSt5bnmjelgfhdgiLDevev8ZcWuvfI+5DooDaorNdp51Rstb2idrwB3D537a4vUiCxF8DcJH+EsOob0oRV9yac6gONao9zLR3q81+SKK0TzQJbnXDlAgHyXDrfu4EGFG/PsfhU01XVoug7TtVsrUO+yGEUPNybagBMBzx3aiNnYxYdrzO6oJmza/YPoYj8VHO+xHjgfSz9gQcmJE952HxM+iUrV/flzor3bhRO8amEW8emFzpu+Ls8Wrs8FBT2iq9RCBl6zIfjhXPQGR6tLmkLRDJQsZkF3BgcHADJJnNB7dR0hYO+rr01f1+SRi0a8yb8wLFS7ZqYliY5YDZzGosH75ilnT2fT/Krz7EGpL7ACy4VVCq8wf8XAEE/kHIp/3NlV7LhFo9VwLx2RvD2ok8S5NLeqqWNJ5CwPMWOS7d37BZPileC4DkmZATvHnai7fcYEWM2FXJHSwRHZsSQ1ijEwLJewMiubGISVkIBsrm3/3y8VYOSGYWupFrbXGAWUie0G5QSr+Ay1qr6+6zYGnU/BwqOugJytFhETm/PRpns5khJnweXFRuwQ7KnoIF/m3jaGq2Bc3yt97bahP++Afv5DI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520c04ee-cf30-499e-ad4d-08dd4ce066c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 10:14:44.0398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+YvGFmEPYBjP2Fy7FvFyUDqid5B5tIy+YJitUppFa6Gy5d5LTQz4pA+eQbxHxe29O7RPAiQKoZBTA5raTUg8quROwAmv/3kM+RROmSli2XaNjHs6nCahccmnghajcbx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502140074
X-Proofpoint-GUID: y146G07K6INkamixlRx3wAUa1Jv_D54m
X-Proofpoint-ORIG-GUID: y146G07K6INkamixlRx3wAUa1Jv_D54m

Hi Greg,

On 13/02/25 19:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
