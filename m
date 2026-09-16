Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9104570C7
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545223; cv=fail; b=sISqvFQLuSGlmbMsOQQ8Kxsw2JJTRC7+7gA6RG14dZPDNGhAEeK+89Yugos+4r+I21xdOg3EjHA95LBrsgEbPrvKnJ0OXl/rHDA/FpJDJKP/Juc1IGSjoWWHVgShVhC//n0zb7sHlXQU2tDuARTI22Q+XmcXnBGBOtNQlBOYiqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545223; c=relaxed/simple;
	bh=X23BLPMmvO4GMYgivYP7om/PeHMJbWEur5QvbojQuZ4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p3f3vW3G1C/btro3t2myoGPtDk5U6o0dF1RdBPPIzDl3vd1iCbgzBIBEwt3Odc/I+eCI7OaHiXfmoUFpCCBUpjapL0YQ9yrLpIZN4/cnmiDjhImNDtwUghQQc0f002Q3HUjSV/lkMtBbXmEyG1ZwX5OMhT5N7jByhyGyYo/UnsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c6kqiz0F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d456BZeV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c6kqiz0F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d456BZeV"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLYsdR1309254;
	Wed, 16 Sep 2026 07:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p9eYzTU4nNQIkQOk3QTj/qLOBVvNLRQE3M5HSnjstUE=; b=
	c6kqiz0Fsqc0tL8L3wEmRFwMv83/1oXjDSIGUxK0vqtFwVtOvR/EdVaDfr4UT+Kn
	zNcFP8NLC2PxR5HP2vGIWg5FbiB1y2O+yFrp0BE66380z5BcVkBiMlF0520M4UjD
	XFmluHSv9JVayg6/aEdVC/ROo7fIKfiynzI0LH7EDfrleBYfs0zRGjYA7jZ3PiIW
	uJ/Y4Ls/oez8w5ArQnulyuVs1v3cq5e4m9+1ZoxO8tksY11rElHQZ+A+8+G/DgKF
	epOnQLG6e+0TS4CsDp3fVeRCW2bhYw1iUyCDzrYxuNT0Obp5fllCcMB1KkBpPTbr
	HUWLUcW1gLTf2cUW7WmWzA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn955h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:53:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7oVnY026476;
	Wed, 16 Sep 2026 07:53:31 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d239w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:53:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FSa1gl0PmQNqfv7/iDCYWfiXWRQuYvNFRHBpATQOZ5Yjm2yZX5hvoAXDR4w8yb1l9CL6+Db41zU+mYgokbeWSXHZf1ZuLXGJD/yrTYhEdHm4UqMQ/Uh4E50rcTOux6hZdqCpbzysCKVNuBI/WkTovvmb3TGUnH2uz44Qv/jYfTcXgk+oVRwnFyTQ4yVdDA0TZExJp41Ku9mXuu4mThAewVnvBkjJY3gQJ/E0S4MVdSDpU4k5YOwyIOvv81gYPY4lJw1EEznEWmNGWraK/j11VBRrMiZbanPKqaQ+Nk/7IW3aLe3t9gRUGmUPkGpix1zq1ANrQyjyvUou6iXlHMbVgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9eYzTU4nNQIkQOk3QTj/qLOBVvNLRQE3M5HSnjstUE=;
 b=mIcrHAsMV5sVuT+h9n72xmn8bYQ0HAXK35/Ck0PajrFABiCZ62VMOKughU79SWpFKyef3lwt9CSkMSPge1C9uWHAjCCm3bh/F3aLbsxNs3Bz+cT3cgfFXvbKsokvRq/x+wnDoaLjFGvs6kmDTBSE30DigSfduwkKDdx58RGbct/qYQ05zlikDBjJd/COxozm3xSOmks6WAAlV/m3QmsVx73Qc8HzsjrmOW8xW7y7ImlZdEhmq4Ohqgb5U19UQxTMwLv9+LXBnZ+fHpDXnFiG0VkCYd+vLEwJj3n1gSPzdGAjJNGe7A5a8v7msie9/SLKoLh5bv8E6wZwnq9ZbRlyBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9eYzTU4nNQIkQOk3QTj/qLOBVvNLRQE3M5HSnjstUE=;
 b=d456BZeVeRcZkjwJMBVVJ+m4W4v6ufiudDqZjDinfBxePwJZeFp9OY0qwJQbCtJ6CXYed57lyA2VQPYz4w8YNyXVUnIBh6wfw8aQh+sFtnCDycv9fPzms/QUj2gLdoh06zczuqr3A7OnevLbseOv5ec3mNXqH8q3r9nI9CR+oKc=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH0PR10MB7533.namprd10.prod.outlook.com (2603:10b6:610:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:53:27 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:53:27 +0000
Message-ID: <746d3cf6-6a7e-4306-a291-4fe158c9968f@oracle.com>
Date: Wed, 16 Sep 2026 13:23:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0774/1376] arm64: dts: qcom: sm8650: Fix the PCIe
 iommu-map entries
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065624.789329301@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065624.789329301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0015.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::19) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH0PR10MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ecf2385-8891-4918-3a03-08df13c79757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|3023799007|4143699003|10067099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	Qipkjas3d3mtjjbFwGsBK1OyU5Ngm0hlqqbTD14HrwrBnRQO77PZGqtwXgMsbxj3Zl1JM+DCyBLgW7bXS+KFAXGYTYEn4Q3QVdCAODsd1s0UOixHu2r/LU4fcv1XVIgcx3D2OIujpbLyh96Hhlhw/V+xIYBO6ZB46ecYJNkZWJuUho8Ppw/fprbL/scSlb/qq2vdvfJcO8yFJ2JVTBkkxlgIL+xwFR9CUuvWXvExb+/xorutFxs0TWP/B8HEDnXCrkN8YaPKlf5HBIfQcA9Y+uXcO6a2lp0Ajevbftru+B9jJrbd/UAf0sPA5iRGl1/EYx/1f9SwZG4sVuN9xoGzbj03TGWKlBl/DTPtGd4eTra7ZCdwRuDX9T/S7XZmlqIsulZjvsdV9cBFKoiNx0ywQY+2bq/bCgNKr+tMqVMLTkOLqE8FQECJ4yDFuCi9c2AyNLuoYyMvpVOyUsdZr9Ko71KMhqhOXtdAPVRKvJmPKJ/48/wQMUd4LyEnkHNhI4rmt1CDi8ZDQAoO4fXyR13qOY9d8DyXg1CxbhIL4bGzWi5LIoWCuEIDEcsfy72/HQwm3mmT2FIFi85uuj/CMKGfCigtfO2nEZ/7G0dEmte0p20yTdWPvf44OXUqcEj7UlV69jGBVD51PFnWvCiKkX5Mzaf0ZYMWU69xfT/8eEjqm7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(3023799007)(4143699003)(10067099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXZNR25tRXJacXYwcGFNUVNMSTh2Uk00UmN5OXhmeklHUmNRY0FhSVY1V1Vh?=
 =?utf-8?B?K1h0QklCTFVjRUc3YXZDOUJVMWp4WHJHUTlScWlXUCtsS3pkVnZqcXcyQVcx?=
 =?utf-8?B?MXZHZ2RWa3o5eHlERXJFUEgwOFBRZkppUHhFRlVza0FvK0FHSGIyUnhYK1hC?=
 =?utf-8?B?QlhqZWt3VGNiR0Z0MmNZcEtqRUxIem1ybWxySzBmVjJta1duM3k1Q0dMZktS?=
 =?utf-8?B?Sk1YN1pyL0hDdnhSQWVRaHp4VWE3c05BWDExOGdEUmNDQ1F0SiszVzg3MU82?=
 =?utf-8?B?ZmhLZW42SElKVk9Cenk3eFBIL3VaUUpISE1aMXMzcUFGT0RCVDZGcFpHeG04?=
 =?utf-8?B?bHF1am9DT3Jvdm5rL2tuQitPcVpSd3FYa3JQNmsyQVVYaXhTVHByREhDTk11?=
 =?utf-8?B?RzduTjhUV3VsMU04alF3WHZyUllkR1JpZmpGQlY0eC9GNHJkS0hiNHJNMEtV?=
 =?utf-8?B?U0lvUGpLWXpIYjNrT1Q4dnQ4NTZGazhicWdDMHlSWHRleVVldEJmTlpBYTV5?=
 =?utf-8?B?TE40QXd3aUJ0dE02c05MeUF5ZjNXOWt6VVVBWmUzZnFCNnFaV0pseTNKTFBz?=
 =?utf-8?B?RUIwbHNIamFqNGNpeXpMVEJTSzBFR05pRHNIUDBWd1dWbTU5dVdTUm1uN3F5?=
 =?utf-8?B?MmNjSEcyYkdBZHZXYkZ1TGVBVExNcnBaZFpBWmhCY1JjTUEwcXZJT2RYc2Vz?=
 =?utf-8?B?VWpHQ2Rha0lncTNvY1lXWGN6M2xHdW9taWluLzNwVFIvdVJZUTRUU2xZL3pm?=
 =?utf-8?B?akttcUVqNE9MSjNLbzdhOVI2MUlxbjMzMVV1UzRUK1A4M1JIV1MyU3p4bTNy?=
 =?utf-8?B?cjJXNmk3alJEemRoazBMWVdZSGIrUGpaT1VxRG16VDZYcVNBY2s2SFR2RDQw?=
 =?utf-8?B?MjViMGZld1B6Vmo5c2hDdFd1ZmNhSFd5ZWZGdE05ZWJHcGlEa004YW9tYlRy?=
 =?utf-8?B?T2R1RWFuSnBaRWo4aENlNWk4MkpkRjdiRnJ0aUk5UkhqWGw4U1FXMktRdzc3?=
 =?utf-8?B?SHB2YkZRUjFha3FINVBvalUra2l5a2ZtcmtlcVhNVmtoMDBEVjdhWW9PM3hF?=
 =?utf-8?B?bWs4T3R2bGhYcTU3MURnenQ1TWVjSytVS1hCUXFYRGZvbVIxMEtrVmZDQW81?=
 =?utf-8?B?NmpLYzVoaVkvTDJMUWR5d0hpR21oN2ErR0JZWU1LdnFLU3hPbUpuc04xejhF?=
 =?utf-8?B?TWtrRi9VT2ZxTmJPWXJpQ3BtR0dPb3ZJZzlJek1vUy9YaHI5UDhYMk0zREk2?=
 =?utf-8?B?UlpOQUt5S2wvT1crVmd5eVkwazZBeWZ6eDkxYkF2RFBOY2NsTzQzeXlXc1NN?=
 =?utf-8?B?UFZiZFordUl2c3RMOUhyOC85Y0VSU0krcUFpSXYyc1drTUROM3NSbWxoNUdC?=
 =?utf-8?B?K1lXQ0JaQXJZbHVhM0pLMmJjemh0VytGWVczUVArVUN5UmtQWlVsSFpzNk9r?=
 =?utf-8?B?M1ZnRkpmdUpNVWc1ZHBDMlpic0pPcXBqSGVQTktVbC9zRUx3dlVLWDVKelZJ?=
 =?utf-8?B?ZWZQSUFtMG9pUFZGcElUMlpRSnp0NlRtTC9NWlp4OU9MNjFSUWpSYi95cXJJ?=
 =?utf-8?B?TWcybzlVZ25EYW5QVUFzZEhLQlBZZDdnV2hrMWFvbHY2OTVhOXFpbWovUGlY?=
 =?utf-8?B?TDdwVnArOHZZRm55cXgzem5CeStxRm8wbDlUMUo3RmFObFdnZEduUEpjbWZa?=
 =?utf-8?B?eUdkZWhkUzRNNlhsSTl5OTZscHFsaXVIUVpjQjhVZy8rRDZ4aFFHU3dWSjVi?=
 =?utf-8?B?WDJCTGVvSXRmNklJRGRlTWd3MWlaL1lPMjdCQmtIdklsbVI4R01JazF0MHc1?=
 =?utf-8?B?ckRFNlVSVkY0UFFGVzdXc0hVMHJBSVBNS1FPUG13T0hGbFlXSHY0Y0lNcGJi?=
 =?utf-8?B?dmcxNlR1Qkc3WTU0R3hqZTk4b2JpTTd3MSsxWmZjY2gzekVoTWJ2dnZubFB2?=
 =?utf-8?B?U3BvNVorY1VvMEVJZk1xTjQrRWtoeHV5WmY1Q2RkN1lYeTByQjAxSlFWRndS?=
 =?utf-8?B?aVFCYVdXWjBvbUpVYmluYWovUzRYV0Z5dXQ4enc3bUx3Y2pQRDhFQjMyeGRx?=
 =?utf-8?B?YTE2UlUweElYVnVJK3MwSGxDMjl6WUNjREk4M2lOMHdtZk1ZZHc0SUJsL1A0?=
 =?utf-8?B?TXMvNXNiRUszaFdaZTNQai81UGxVS1R4RmJiN21DUXdyaCtGYUdrcDJSMkJk?=
 =?utf-8?B?V1VtbEhNRlZDYjNoR0pmMDFNUEhJSXhodVJIcG1HZUVlamp4SXVTUzJiVGpV?=
 =?utf-8?B?Y255VW5OaGNZNTRXRTg2YUVIMGlIK0gvQU1OOTRDVHhabVR3LzN3UjYzbTdu?=
 =?utf-8?B?QitHOStPZ09RR255WmtxdXdCbVJtT3ZWTnhLdTZOYzBCbzVTQUxjMEpaVC84?=
 =?utf-8?Q?TdVGsy67YBPNRgoyRbL0u2iUUIDfhi+Yekw+m?=
X-Exchange-RoutingPolicyChecked:
	0f/XXY3D3bByPVh6JFM6/XyoWpf2CeNXkxpYepE6YRaC9pWmQK03Mlo1nol5Q2xa630dnbC6nrEbm5yPYBffGeVRoR/7skYAQ7CpDaR1UrpymTla7HUqBaDxBdz0aVyiLmnQecxVcAQWbNhFoXbBCIoVl5S3SoGCPIspVpoW9KIrbpB80jab4E5te6mAoEF4bT/gJ883LSwWfhTy3XKuCjw8CNREV4OWzBv0abMJXuVLMtO6snZ6hRQ321xjE2BQV0fmYIx70VQhW6wMVcT/eJs8hDzWCTgStkquwjRBfmQf7/Lhk9qwwNRL5hlTHHRFeO0nOpCkktaFEm0O8o7M6Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5hLUVDNPCaFCRLyUvVm7ICSvOABvjFTAmc14ht5jbq5Mblfvay66mMlWBpDUKNAHwv66ok1/Rs8ShWRfEVUBFLCz9YAGBB/R0mMC7Mb/5aFzm0V2EeJAWOfogtm+6qhISBimDGBPLo3Fpq2Gi6VWtVyA/HJbNCqJEpqeswkQt66ZyjFljswTsMCU690zHkauJGOVZBfDnGrl1Y7OtWITKo+unKx8gFS+uZ+AR5D53NE9HpXB6cw5Ni3CLdgcYAxt992KuhezvhJfDAjzfADUzF5YWtpF2ZrhIK0A0spte2b+BPVTQCJcKvYy4AziKJNCpuF3mrJhD/TUC7cHDNMoahSKfF9XVcVh1hDn5cKNjn11m+73GjtXEtTsBZ28KLjR2rErIQ2rqjBz7lB+7HQc4fO2P6rs7p7QOBuYwz3ZlWydtf1jr+wZ1nHI54SmWB+p/elbq3YhqWwKBo1SgwY/zZ53NiMQPrtt5ZPpbKc/sEzbgG4bEoSeJlZ/zoW8aOC/zDkv82vNJrL318fNxXTHrFYiJkz30DnSqqt0kv0/j8vgCxcEKFpWMRtJPHR23aJIEp5lmP1+6SaeI30wSP8waMkbl4TXWJ6OsVz7P9mXPOU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecf2385-8891-4918-3a03-08df13c79757
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:53:26.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+9ExpfrZ795c0w2sYgjFHAchkNufLoz1VBdMJLTMcq0fxImS9JIBTt2Gw6qhBSn6SgICPvgJ8/az4KCMwlvH4vwq1IQcNiynw4ckxM/bA0JzNNi7JdJGerniCeyQETb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160101
X-Proofpoint-GUID: c6Tz4rH9hkJEavT2VNG8j5iRdW4hzyHr
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwMiBTYWx0ZWRfX7k07jedrqRVv
 SYIB8Y6ymO3R6cS5zhjNCx6/SOZg6EUeLbyYlhh5P8MkH0DA34qyfcmcFyS7JFelAZQDIcgc65+
 gE9GZjzGlFw6uEXcLocXiFVXcZpHYM1alXE2ERroLIqpr5u66yk/
X-Proofpoint-ORIG-GUID: c6Tz4rH9hkJEavT2VNG8j5iRdW4hzyHr
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaa4afc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=qAMQX31tJun4B5yFMF0A:9 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwMiBTYWx0ZWRfXyslsbOpg0aps
 PU7zAi+EwPWefFxJB8QsKrVlcOAc9iBuPH9l7wL/9vhbNFjp5t7xq+rjQMfSTOsGybPW9mYoQQr
 uoXExVW2DnJCPUq3aEGVP/g3bOe7WJq1Z5DhI4JgwhAPmS2EzpPl3j44G68KHMYPac2K3Ga+tji
 RI4XDmmOGnshbOAoVkU+jeUTZsnMst1vDV2uOIbppKU4H+hfJQBEAfRw0WyOl3t45TjL6Cy5aTR
 jGW+M/BlDg5WFosn3tVMUqw9zvBTs1K421aUDFVQ64i+sYmMCEHMQwyhSSAHPY8H4oRp+MiIYhD
 MZ3AZ+qeS5ubHEkhJ/0bojKhBkhbl4SxZcI2h+r3xrMz7gBrWJ1TxDJ6EEsrQGR//vevoteMx6a
 RmYJf9ajJxpSNzjf5oup3P8sq2WIyzFCerLWb1hvO42CYmYLLD8eBqVh97C8mqk3VRks7PLvMxD
 4sSwcAmsvDMCItBc/2w==



On 12/09/26 12:23 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> [ Upstream commit 8ccba7b44609d58db088447a771f6f30cfa8739e ]
> 
> The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
> iommu-map entries specify only one cell for the SID, omitting the SID
> mask. This went unnoticed until the OF core started warning with commit
> ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):
> 
>    iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output
> 
> So fix the entries to match the provider's '#iommu-cells' property.
> 
> Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-11-83405d37ba41@oss.qualcomm.com
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm64/boot/dts/qcom/sm8650.dtsi | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
> index 51bfb220b6c2e..d28dfbf57e634 100644
> --- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
> @@ -2281,8 +2281,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>   
>   			operating-points-v2 = <&pcie0_opp_table>;
>   
> -			iommu-map = <0     &apps_smmu 0x1400 0x1>,
> -				    <0x100 &apps_smmu 0x1401 0x1>;
> +			iommu-map = <0     &apps_smmu 0x1400 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1401 0x0 0x1>;

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The SM8650 DTS now has two five-cell iommu-map records per controller,
but 6.12's of_map_id() only accepts fixed four-cell records. Each
40-byte map fails its 16-byte record-length check before requester-ID
translation, and PCI setup can continue without the intended IOMMU
association.

Upstream relies on ccb2fd725d411265df8f7ce12a66c226b16014e6 plus its OF
API prerequisites. Since that broader series is absent, Thoughts?

In v6.12.110, the same missing OF-parser dependency affects all eight 
neighboring QCOM fixes: sc8180x, sdm845, sm8150, sm8250, sm8350, sm8450, 
sm8550, and sm8650.

maybe we should revert all of these ?

thanks,
Harshit>
>   			interrupt-map = <0 0 0 1 &intc 0 0 0 149 IRQ_TYPE_LEVEL_HIGH>,
>   					<0 0 0 2 &intc 0 0 0 150 IRQ_TYPE_LEVEL_HIGH>,
> @@ -2459,8 +2459,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>   
>   			operating-points-v2 = <&pcie1_opp_table>;
>   
> -			iommu-map = <0     &apps_smmu 0x1480 0x1>,
> -				    <0x100 &apps_smmu 0x1481 0x1>;
> +			iommu-map = <0     &apps_smmu 0x1480 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1481 0x0 0x1>;
>   
>   			interrupt-map = <0 0 0 1 &intc 0 0 0 434 IRQ_TYPE_LEVEL_HIGH>,
>   					<0 0 0 2 &intc 0 0 0 435 IRQ_TYPE_LEVEL_HIGH>,

