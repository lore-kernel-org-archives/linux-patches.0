Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA8C38552C;
	Sat,  8 Aug 2026 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786209835; cv=fail; b=PEtK1gHg86QR++2BWJfVECod7rAExqLSxDYSnYmuKdfv6mkdYCUaBcHXV+kg8iCeIigD82S4zBoT8FVE7U7Nn0yc5xcC5WyE9/HtrScDXOQDsmgpQUmLwL0OVxyE+0iWQM0xlgOtr5aEOJgcHHOVLD1+dexLT2s/elHPUP4ICMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786209835; c=relaxed/simple;
	bh=qVuQ2vN0D+gHUD6kDSVho8Kfh0DkddKKDqlpWJgSe3s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EAgyaPCF8uJH0vgVYQn+VFZ7Y4dPCqWFwu1HW5jiDnAQsP46cei6IWZ7O7NIcHbBdSrw4ZUoHM+DqNyb/2ICLosOrm3KSj8XnAgUi2UPmDkbiJ+HaEy3KQPjf/k0qWo9bXiC7JbOlq9PoGMYV1JVVopwzFZJ9H4gG5uuECGPrt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fz6F4o4q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h5oQFsEF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fz6F4o4q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h5oQFsEF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 678GZXQk3842779;
	Sat, 8 Aug 2026 17:23:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oMXboGztwT5UocqWhChr8MVXeLt8v4futdB7rn0nlOw=; b=
	fz6F4o4qp2p7YjoaLOSq9QB1n/0KN6zUnWYmiVCERb4nby1Zoprl0AHXRFRFYF3o
	ADboVgwoMhnyF7DGs16hZdkotnAgYEHj9+wSZiyv3N2pPsVRe41luQjUxQfQIGsW
	FkPQG53eFPoX78Tt7UHV1Il2N7lgbNWUzOyePGM5RvBDMz+DYXCzRlrJNbrBQJFb
	KDgpBe2ar81GVEed7NPUxrWVWMpMSlX3OMEbStb73LX2RL9ThOLxXMPQEi+6EaRg
	OvNFwPrQnlOMrO9bVi8AmT1/q1JY+ILbeGEVD190/OwM5vbj++uFuUa4eR0DvSMx
	d6KDlBBtVx6Kpljxfljaxw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvk68rjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Aug 2026 17:23:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 678HKHJQ034710;
	Sat, 8 Aug 2026 17:23:41 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwapskq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 08 Aug 2026 17:23:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzrRfUqauVXHyXZ/LB6P4k/6WJS5KZwO/mjnM2xFdKuyhkaiYZ+L1X+R94QhWuf2KipbMW4baaTN2i1wSe3w+tPJ+fDeh8yVRtykdR/eTYHbJmtaiengDaqNeD8r1qUPdbak9WNemTiVotBngK9ulfOY+HUNwzXawiHOM8Y+5U/FB7N/XsKyJ79RD2qgmv8uHwS07IU8RElXOVGLG2k2+FI9rO35iIW6YxaeZI4pj+OrO7K4NoGR3FC0cxceNOAStRWiTrG34z8Q1pD25+zbvqf5OyYkg5zIw95gUnhyW8E9PogcOCuObmUgc1BWWFJICbjNpAXFC8C+0HtyMUei+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMXboGztwT5UocqWhChr8MVXeLt8v4futdB7rn0nlOw=;
 b=RUZ0oXzNXLjHGbcGWk3Y3iFstw6I20AdMs2+DfjBITJ9UBAAW3xF3Sfz8WNdfyN5ngWdM2XgVu9Nq7Z9IM/PZKEEOWrws8kp61hnlq5kHMBPc9sDl7FmJyissI1eu8wNcDq8AOnm5fCOYtlrCqUiYEyyLRjdyCzXDdXU1aHr0TLlNGtoTMsJHkru6lc9JqmKnMOMhkU/49gHOFfGW+6fBJp16NnD2/mr7TM8LrXgKJBDGy2gPCbvpQHJ9dzv8WCXNKxlWOzWfzxEbQzMck5uaT0KjZEpI9baxTSukuojh+HIBaY0rx+mrtHs9pP34WiyFnn9/l9cPSpmS33niOe2vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMXboGztwT5UocqWhChr8MVXeLt8v4futdB7rn0nlOw=;
 b=h5oQFsEFuVtnOAF3rzn7eEc5aTE1+MhKIssre6oz1PxGQ1LLYxm9TtRfz+S8OOzNrroYB34cfY+4rIDtMCfJ44iXHa6NmEDKy5Ez6Tj/bHeaSnttN8Sl6vGec9B2c3geQAOwR4r0/HnyDZI/xdjQ6UKc1CBEvpdBZDifNFy0eA8=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CH0PR10MB4969.namprd10.prod.outlook.com (2603:10b6:610:c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sat, 8 Aug
 2026 17:23:38 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0292.022; Sat, 8 Aug 2026
 17:23:38 +0000
Message-ID: <e4f43ad5-7f15-49bb-97b4-3035220261b8@oracle.com>
Date: Sat, 8 Aug 2026 22:53:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 117/337] tracing/mmiotrace: Add NULL check for
 mmio_trace_array in logging functions
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Sasha Levin <sashal@kernel.org>,
        vegard.nossum@oracle.com
References: <20260807143418.516897842@linuxfoundation.org>
 <20260807143421.067366429@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260807143421.067366429@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0020.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CH0PR10MB4969:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ed75593-c8a6-4f97-00e8-08def571c8db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|5023799004|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5jh33o4zI9aaIsQvbvNIowuO7Eo2h0xBcChrRBe7iDt4F+4wm6c+mQ0pGhVRtichk3EUkWW5de0+6GAgh+0RYOL33gbbQQCjxohqptNNSVtf39+ZENNrJOh88zL3pB0oFkjXlal5WaztpZxpR9T9Y4zOgIpXeLzGdWnaSFLSZ1naeStKfLOhYIP31mDi9aeh2VlK6kg0RLw4GIdM0S5Fi1cxPx+f3RWNKTXq1cOP9IWq1GQCfqxcsH/NpK0Kudbgm50fKoi1V3Dk1qSJUtnLpP7uz0XLbamYcbheRGpe0W2VkLfhljNtmX+iHP/6U9AvueOPR60tQfj9QjFrLdqrhY6u7790Z17PKD//prDaZ67ANuWnXyTT+B2Imnv+RvkcfUh9KB8jPz5jiiI0YTGYP2gLorEKJqxq+XdCkoXCqrxF6QdUrsK8rQkNBNYpnHAGDoGLkYqJwgYHpWM2DhhK1tkemrnwYc3jWH/XV34V+33E8Y92wnd9y+a/KBfNKSd8lrccpOVfZIEIQS3i0PxTCVTyH7Zx4oDR7cDwsRsVNlksZZtE+ktekqt05EoH6tDw5PJLTlwqmPtb0HdsK5JMTRagSHIc4QvgS49rxEs7s0r9UYdM3qv1IaXUEgj21X+t
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(5023799004)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkxwNTRBRFU3NmRHOFRMRFQ2WmZjSVdlRVFoK2RFRlhjYjZHSkc1U0o2UXRO?=
 =?utf-8?B?bjlVaVRMUGNHRDdCYjlWVXgrNnFoTTR1MEJROUo0VmdqTjBKcjhnWHZWcytB?=
 =?utf-8?B?UmdQTm9RMHMwVCtxaU9BZ0pEOU96cDZnKzZBL01FVU5rZTNHSitobXBaVzdY?=
 =?utf-8?B?RDV5TFo3ZjNCMTRvZjBqN3lkNnpncWdmL25ZSFNSckxmZUZDdUdidDNDcGsv?=
 =?utf-8?B?cTdZMWFsSGkrdFBFall5WkdvOGZIWTVQMi81REx6MFRtNjl5MVZadnRncHov?=
 =?utf-8?B?WjVSdGtzTHhibGNhV1FiUnNBaDVIb3NuU1JsRmpqbDNkbnBueEs0TWc1V2xH?=
 =?utf-8?B?NzBaa0JCTUM2WHpGNVBydTUzbHpRZW45TC9LckV6dkxHR2RlekoxeXlZUGRu?=
 =?utf-8?B?Mzd6NTAzRWszTUJWaVhaa3NLQk5KOFQ1Sm82aWM0aTJ4blJpYWZkaDJrY2RU?=
 =?utf-8?B?dEMyTTdUMERSakRyUWd1bHdrV2xUN29CbEQ0WFRuek5zYlE3dG9vNVoweEM3?=
 =?utf-8?B?cGxmUGJnU0ZqYmkzZkJ0NkpCTXhjVXFPcjAwTm4rbjB0YjRPeHd3SUVLUmMx?=
 =?utf-8?B?QzhqRzFSZy93b3NjMUlTenVNNlJXVUNFRy9Jb01lbG5oZVpLaGhNQjVId3FH?=
 =?utf-8?B?a3JwdGRMeFltTzVrcHdCZVRLY2J2cEpaeFV1bDJPZFVoQ0lvaS81YkgvRG8x?=
 =?utf-8?B?ODZuZnZDUmQxMnR5aXVtaDVEbDlGNDdOQW5hS0h5eG80eTNmKzVZS01JK2ZX?=
 =?utf-8?B?aVh0OEFYTGJ6bjRlbUZldXEyWDNyRjdOTWhsZktTOVNYQ21vSExNdkE4c0V2?=
 =?utf-8?B?amJEcllicnZYaDVBUkthblhLRm42MWgrdHl4R29SRkVMdERCUDVqWUFPMlBl?=
 =?utf-8?B?d28xcklOMlltWGxTSXhPT3l0eGhEWmpXMFBsY1pZMXJmZDFid0dGQmJCdVU3?=
 =?utf-8?B?Nm1LMUV0M2FXVTJ1dE1FT2E2Y1JkWjU5ZjBuSDRjai9MaFlQeEx3RjJ3N2d5?=
 =?utf-8?B?TFF5NU1LcE9mQ2dBb3lSZTJ6TDQ1d3ZHSlVWaEY4bWJXMWhRK09JYklab0VS?=
 =?utf-8?B?UXFqODIyYytyWlVNMmdRREl5clJQbHlRSi96dHFzT3FpNUdCZGgxODlrcEdp?=
 =?utf-8?B?UHNTSWI4d2hSQ0NZTXBsMjN2T1JzeGkwZTVQaXVueFAwUWJyMFBYYVN3bThj?=
 =?utf-8?B?dDNaWXMyclJCNGJRRmJ3ejZYZFZ2V1YrTGRtU3ErdnJHTWdGdjF4aWk2ckZm?=
 =?utf-8?B?Q0dva2hFL2pyWmZGMkFCWXNQSmd1cFF0VDRUcWJZanlMVlFaRDFzVXA4dS8v?=
 =?utf-8?B?UGFBQlk3VHdrekdRSGIvMm5tUnR1WVc0VkVQZUFhSndsSmlyNGdWc1BNbjQ4?=
 =?utf-8?B?djZoVmJyaitqQ2dXSWcrOUZHbVZkU0ZOOVZGbmxUUG1IQzl5N2lUNHJoajlC?=
 =?utf-8?B?V0hGcGpVNTlkRVA0YlZVQVdGTlJTZExQemJrRzR2T3I3NU1oYnBJMGtjeEgw?=
 =?utf-8?B?UEZvRklmejFYL2tBbTZTK1VSK3hvZ1hHUWxSMndGd2tkOWZSV0RQT3JYZEJ4?=
 =?utf-8?B?bzZaakJuYk5QcmJNeEQvV3MxdjdkSTNRTWU0TnVzQjBGdUlwcTl5YkZwMGVW?=
 =?utf-8?B?WSs1VmNCSkpUcys5ZDh3ZDRPUUVWMlQxYTJUcytOM0tHRTJYaEE2WFhmOGgw?=
 =?utf-8?B?d0xOTFdoS2psVklJWGlURFd3bnhSaDFTUVFnOHEzcFZsTDR0d3grV3dVdmZT?=
 =?utf-8?B?U2JaQWpWU3ZYUkVjY2lBVnU3UDEwMGNCcy9kUVhYSUhKNWVhRXVBdUdNeVUv?=
 =?utf-8?B?eDhJbkxvMllhSC9hMisySmowc094MHFUY2FFMFUzUFZJS1UwdnZyWERDR1VH?=
 =?utf-8?B?enI4WkQ3eDM0Ty9WQU0zb3dvVVNkQ3FmOHNtY2RWWm9IYkRYeDlMam43RXRF?=
 =?utf-8?B?R09wbVduZlBOcStpZUN2UGZIWUF6Y1FHb2JOWVo5RVZmcDBoZnZZaGc0TkQ3?=
 =?utf-8?B?QzNUa2V0MjlOUGxrbW04cmVpaDFiS1crY0FZN3QvNVV0aURrWG1OeVpNbUJw?=
 =?utf-8?B?QThhakF0TjVsdDZvaHpVbnl1UUxuenlRMVVzMlVOdGU0aWYvSno1Z0FjOXlE?=
 =?utf-8?B?R09sWVgwaUVndE9UMngvb2k2eTZKU1U1ZEc4bkN1ckNGTTRKVzNHM3UrRTJU?=
 =?utf-8?B?Q1RQQUVNNS9hVkU4QlM5S25ZZ1JtaWRhcGxhY3QxZzloYmFtenc2cVVDTnQ0?=
 =?utf-8?B?UGRSbkRLOFY3UWxXeERIMjd4QXVib1JsWVpDVkExZjN3b21naTdNTGlEcXVI?=
 =?utf-8?B?Yk0ybEhFWHhHVVpJVk52M0NwZmlzNG9xUWNFQlFOelBXTWdMOVVMTmxIaDdE?=
 =?utf-8?Q?Yq7w6TDffP+UwxUy2n/qGkkbC7MGa4iafu4po?=
X-Exchange-RoutingPolicyChecked:
	FzG+V+itUUm+YZQmJf5/RtE2U70QGUrQuIqnZ/hnjHs4vTVbfftC0rTFzaskvREQpLHEW+rM8ey9iu49Ieu+zR3KdSR1FvQlItLpcXtpXI9qjzX/bbQho2DjKHCeEqlnfRemqtE5Ojm/fzWDzgHpsazMfMYJhzmM/3+6GBE6gsQKCkp3K/pwedrK282vju2bkhIz/JC0nfGErgLPtavR4NPWL4TmnPgWIPivXwS0nRdQrAWbxfVhWlJ1hpY1TUgGqspbgoi2P7BnrBK1CEidlxCpUNkDHwTvJ9vk2lckxbGms0EHWAGSNVKirc7OaYgMK/thq+t/Qqw5H3UJSm3r7w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1k0PUD0Dm0ZR4ysjPaeCdGAFfcnlMHLr260C+vdkgKiVrjTFHpAK4wInuGF6jatcPodgj3mfU4a4gn+wDy2o9FGMYCUiw8co6fQ7YK3K+zPwZ1jihubP5V0rXPDjqOE9PTX4VeKqw3BVbJO2M0lvszSr00saUNU76X3TsBoLMo/vopBEZAv3MYn0p3dGF8izd9pTgQK/HZMts3Rj4B3emXDGSLYx8ApHsEAY9Zvi3YtNtp/CphrkTp6KggA+gGr95EBOvYlx0uEQH3096GLaoYOm0jtHaFRug42Cb1l2AgsdzPlL4r3drWLNZ68Kv9K1Y/A9cjWOrQ/pBU4npkPQZKbO/3oMsiISa4H06R9x62KiLVTchVzGBW/XKwKiwXidv8GwwKq+9POsSpPM5UHKt1xhByeMbVjmXI+k7SSdGTg2v1VdZ/7GCG6rKm7go8P4jG1bZ/MMiQqym0xBE7oXKL72brCUY619UGX5sTxMGxMFKxOLmptbBySJu5YTVpiguqGr7kRns85iWwHSVv5v3qqlYHRx5qn8dDbIN0iLyXdDzh6Uo6TZvlOmhRIdl7FQBVFjaua5HHlBKkooYsGasMWr+SFLUDJbqT6MT8jqlmU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed75593-c8a6-4f97-00e8-08def571c8db
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 17:23:38.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJCKzcZjLJuVaYOK5hX2r9dZuRAoQm+o0QUae7e5dvLR1u3/wtQxmfRSPyzuIzfGR1co2rNBSecxMcMAI8ycpTdt6dHF78c2F8e0yFFY7tDUrMGW91VghocXDA1GE2lJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-08_06,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608080149
X-Authority-Analysis: v=2.4 cv=GaknWwXL c=1 sm=1 tr=0 ts=6a77661d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=_8cVnxNqzcTN8v-yuRcA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: plxHbZcSl_HRrvV-fjDISmOgp_JpCKQA
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA4MDE0OSBTYWx0ZWRfX2yDMAyGkar4e
 nLo0m2wqAxMgO1PZ+3nY4BS3Py/S7ULF3lNzquT0lgPVRJVq+iXOChy+vItjJy41XHSkKY2pfeV
 26cRZ5G22zDokT1dQspojbmMOeDEpJSzg/C+pbI624RsPlaOkFGo
X-Proofpoint-GUID: plxHbZcSl_HRrvV-fjDISmOgp_JpCKQA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA4MDE0OSBTYWx0ZWRfXz6XJjm5VyQSf
 4e1fxZpwVz6kPCf0X1vMQQ1Um/KFD8/g58+wBmV97fu0KRNT23cxEv5uEm/lr6api6G+4kdogGw
 KhM+LLAjLaQDFVnRE7xFlAoEaurb/QH6mbl9728eLNdFvBx3ItIM6VL1m8mJ74RthazA33KyGw4
 H/2HYH4boBUr7QxKk04yNkiqiBfjH6sglVYLcjLOM47HbigXdYELnrLg0/zKnF8tqmp/GKZT/Iy
 A0Rd8P5+mB9WXzl3Q+cpWmyyFtU0fHobhZTKUDR0f/kMC0hqgPPv4822jBOe5sN+hJ6P1tsWz+u
 3Gck5VKOCvwOJRoA4a26J2eBBBOUMoEZ9cd1rx39DSPfQYAI9l7x4KbUe5ErMXyuTivhSArj+vo
 2J9Oe7tNz3x42QwMA+8qHWRga+UvwdTTdY6Ar8JbrJ2b4JyB3r2hrVzG2Fu3ZMSvoQzdxVWtXZs
 LEua12SyaDjTSfUwRHQ==

Hi Greg/Sasha,

On 07/08/26 8:05 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> [ Upstream commit 12b80cdbc54cf615b4717a4e8180063408091ea2 ]
> 
> mmio_trace_rw() and mmio_trace_mapping() retrieve mmio_trace_array into
> tr and pass it to __trace_mmiotrace_rw() and __trace_mmiotrace_map().
> If these functions are invoked while mmio_trace_array is NULL (e.g. before
> initialization or after disabled), accessing tr->array_buffer.buffer will
> result in a NULL pointer dereference crash.
> 
> Fix this by adding an explicit NULL check for tr at the beginning of
> __trace_mmiotrace_rw() and __trace_mmiotrace_map().
> 
> Link: https://patch.msgid.link/178524300062.56416.8362487250709962380.stgit@devnote2
> Fixes: f984b51e0779 ("ftrace: add mmiotrace plugin")
> Assisted-by: Antigravity:gemini-3.6-flash
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/trace/trace_mmiotrace.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index 6b964471265e1..251ed7051e409 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -295,11 +295,15 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
>   				struct trace_array_cpu *data,

^^^ lets keep this in mind

>   				struct mmiotrace_rw *rw)
>   {
> -	struct trace_buffer *buffer = tr->array_buffer.buffer;
> +	struct trace_buffer *buffer;
>   	struct ring_buffer_event *event;
>   	struct trace_mmiotrace_rw *entry;
>   	unsigned int trace_ctx;
>   
> +	if (!tr)
> +		return;
> +
> +	buffer = tr->array_buffer.buffer;

I ran an AI-assisted backport review and then checked the 6.12.y code. I
think this backport is missing a small prerequisite.

Upstream's wrappers pass tr directly to __trace_mmiotrace_rw() and
__trace_mmiotrace_map().Each function checks tr before dereferencing it:

if (!tr)
	return;
buffer = tr->array_buffer.buffer;


The upstream fix follows commit: 6936298393d8 ("tracing/mmiotrace: 
Remove reference to unused per CPU data pointer"), which removes the 
unused data argument.

6.12.y does not have that commit, so both functions still have that 
argument and their wrappers compute it first:

struct trace_array *tr = mmio_trace_array;
struct trace_array_cpu *data =
	per_cpu_ptr(tr->array_buffer.data, smp_processor_id());
__trace_mmiotrace_rw(tr, data, rw);


Consequently, if mmio_trace_array is NULL, the dereference in
per_cpu_ptr(tr->array_buffer.data, ...) occurs before either function's 
new NULL check.

I think 6.12.y needs commit: 6936298393d8 ("tracing/mmiotrace: Remove
reference to unused per CPU data pointer") before this fix.

Thoughts?


thanks,
Harshit
>   	trace_ctx = tracing_gen_ctx_flags(0);
>   	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_RW,
>   					  sizeof(*entry), trace_ctx);
> @@ -324,11 +328,15 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
>   				struct trace_array_cpu *data,
>   				struct mmiotrace_map *map)
>   {
> -	struct trace_buffer *buffer = tr->array_buffer.buffer;
> +	struct trace_buffer *buffer;
>   	struct ring_buffer_event *event;
>   	struct trace_mmiotrace_map *entry;
>   	unsigned int trace_ctx;
>   
> +	if (!tr)
> +		return;
> +
> +	buffer = tr->array_buffer.buffer;
>   	trace_ctx = tracing_gen_ctx_flags(0);
>   	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_MAP,
>   					  sizeof(*entry), trace_ctx);

