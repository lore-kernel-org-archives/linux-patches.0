Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7B126C17;
	Mon,  3 Aug 2026 05:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785733760; cv=fail; b=kMPXvffgpwSqOkgUMk/Ncz+ch0pD4pALKu8gIB1XJ9GR0iezqKs03OaWKk8osjL50vJ/9B2NJe8cKMAlwdT158jL72lfLcqMAodYRnKuu57zMVMdNzBlKiYtBU++V8s5vkL6a+1+riy16o4qrzqtR66fMaWsLQD/mky+9HIKtuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785733760; c=relaxed/simple;
	bh=NvFy+YWQbH+KWSsbAnPb31yd/Qs9OkEQdEbh+kPl0uk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dFCEnGkOI7cbRBlNSMUW2jNlAjuvXOH0wlGJt/ayimytoIupiwzBopWv1DPZhCYu01Ms+KNFp6cmA6rfl77a3Gox8a/OoF4M6TTNROrR0f0wJug0PAaV2CyDT80iGPdcvrtCRbViVHsOiYcoXB2YZEkLTVyBzIox85vewFMrF6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D3kjrvNg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IfCVnE3N; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D3kjrvNg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IfCVnE3N"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67320Lo22035834;
	Mon, 3 Aug 2026 05:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E6BdfNtQLMLQF6bapZf86ixCmHI6Exr/DASb9p4vpVM=; b=
	D3kjrvNg83AC8wW2l8ZiClOHBKjn6N4QqKUCejBg0zUjwdq8hkA6Nd087dzIkDml
	ylM3c3lvcQt2Uezs6KlrfGrXYe0XeATOWR+yu/m73d5ac+CZrGQL5e+Cp5WacJuo
	sWcH3wYmBhly7rU+/IFptY//UeJcAHNGr0kD8XPitAmSPB68vaAUhymSaY5QNMeK
	1OcdOrtk8ZBxS31LrpY01jeayKuzf/Y/4L/FH9fa/AOW9zqEh9ze1Ao/DltVLT73
	vAosr7YOYhUqMRo2fO5pw8n0HgIFFmwDY9qMd39mZ+degjrn4X2vdcS0efGen+3b
	Ci9WJSVZOlTrIwPcLPIKXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7qa3d31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Aug 2026 05:09:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 673555R3007674;
	Mon, 3 Aug 2026 05:09:13 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011053.outbound.protection.outlook.com [52.101.57.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78a7jag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 03 Aug 2026 05:09:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dx67ikTqT+qP4k9aTPrm14O2bZCFnRINTvTyZ0ichB8J4/pj/j9Y9apPIIDbawVC1zUKhBidaxHWMOakq596RjUzpUMljkKM/8xMrXZnyH3Z4ALpcHdPjgi/2R0boAKyNRMeUK6PSYRfoh/c2RHHU7tYVq/3mFjd+SegHrpMfGp2xMf7XLoa9RuVPvFxe7xjWknBzxZS43uZiEJiuBKVWe3ySOR8EndlYcWbF4V/TXiaJyk00/h24MmXSO5Q/Mmz579AULysQUE8gR8cBxY3n3/bGE1d5tVvQaAtwRnXD1s6CE6E4ZBC/aXlE48Ei9oiMpKOFmPE9GGekrgRyfX8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6BdfNtQLMLQF6bapZf86ixCmHI6Exr/DASb9p4vpVM=;
 b=udM/E+LDoNCl/tXlfOiA1nOarmVhA5GYCVeSQehDyzeNXpllYGz0q/FC4jrgZOAaBAaRsnrRqar56zBTjBibn467jAPNoDbJiXmpVPNE2tkyTnYKr5+fSj9ZWfQeTaOPCH6YX3KYDwvHOIXIGry3OWU9jd6mY8VqV/IdACdAZza8rDFXBh9OoT9ydY5vUKBqtOzsFPmhu2Z9Tt4e9uRpIjyz2DNylB4+beumNNnBYHQe6fXueJHMV0QRCgRVVR4NJKgLEBB/3RdOHI0/wME2mSLAHb70fZ9J2T4toXifQwc0FUMNE4kOcRCwkNOooTYOUrud2bNSuOXkv/AcOSLpIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6BdfNtQLMLQF6bapZf86ixCmHI6Exr/DASb9p4vpVM=;
 b=IfCVnE3Nfyoj0fxoQCk+soUJYxcVFQRjis/OlLaagrx01/qIniHnOIKHOLY2gVKh1gqTa7duaCrvnWp7d9bDlMIOkBwgwEwRlwgv1Mv6lyb93JS8fI5JkBIly7ZpBC8XFwABDNYeUNVGtKoonQfppJZdAe+DgGC4WuLQMs4nnPc=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LV3PR10MB7844.namprd10.prod.outlook.com (2603:10b6:408:1ae::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 05:09:07 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 05:09:07 +0000
Message-ID: <f793d6a0-d734-4e4e-8b9e-24a633b18554@oracle.com>
Date: Mon, 3 Aug 2026 10:39:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 541/602] bpf: Refactor
 {acquire,release}_reference_state
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eduard Zingerman <eddyz87@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141447.394161782@linuxfoundation.org>
 <129ad991-e9fa-4f6b-bc1a-a1d78eff6145@oracle.com>
 <20260802030151.769b0f1c8214@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260802030151.769b0f1c8214@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0009.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::14) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LV3PR10MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: 57068bca-1743-4c5a-91b9-08def11d588c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DmbJ7JSd6zFAmhdDpNBfL+/7So/SEMkMBXss+i8sODINzf2LYFVISaVFngQbu3mz4Jy5+HGzBsKC3W4gTeX+UZvV8E4Mwo/U4RN57eMg1y9dyNx5auPGAXTmWdK2nNceHY19M9S0MFGb3+zozRtNNMaAuTRgp7q5+0yvyN7l8geSDPTD2j7tWDs6AgIvtmKYvlv6Zv4dsgQgUIssAq34tiQ3fTAi7c4fUBqIGXIIpOZPI7kk8VdnKkvwsQGscPaudhEc7oKYPFOXbx/UDnXML4eczZVEHEqf6p/dgyEbYAHMKBR23nSXXTZ6yOm5P1OwETpy64I4y/e8drGvU2KCbCI8ie/7dqsIVFiTDgcxfYi+RzN9CSDv+WrahrEs7mRBWLUXoAne0v+TFewIjKpA1y+GtoFnVMA0YlnyVjbONKJoQ6IEr7AS8ELBMgQ3Uv208OfplRQSsr8eDNQtDCxF8/o4lTTLrrjxoODpscwxmaTMYAPAqS/OTenNaZpiY9/erRUOBzn5Mm6GR1z4B6SZKw8gQt9lewS030AONjFHc0AIF6PRQxoGiysPFyIp4BzgEMUt4dnWd1iaUtsLRpY08JY/SsMYXbOGM0ymCTSdd6UyA9wkoHXRsc2+hUFp9dEfPIUYA7CCEyKkKjZfTThLfrzJVOv4fi5zu0vNZYG3bSQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjBnZlpUWlc4WWI4UXJJaWszTDRYM0hucDlPY28xREdjRW5rZHl1bWROdXpG?=
 =?utf-8?B?bjA2VzczTkZVNkNvY3p3clRISW40blVkU2kvKzJDVmNXQlhNcE5QQlpZamMw?=
 =?utf-8?B?NVBrZ09DNDE3ZjNDbTBzSE1hbHhMdjNSYWYzVjE5V1BvR1Izcm9WYUZsSFFk?=
 =?utf-8?B?S3V2Q3MvVnZ2cTVaM3FoYTNpYkdnVDJwMWZYQ3BQSnpHK2RVT2FiQWh2S0pK?=
 =?utf-8?B?L015TzYrYlpXeVBCZzVjZWx2cGdsY2JodGJ2WWRHSjN0YXBHZ1hkbUtUZ1kz?=
 =?utf-8?B?N1luS1oyYVRabmRDN3ppYVVac3lBYzNnRkgxZFlYSkpKQ3RVOTdYZmNub21U?=
 =?utf-8?B?cmlvTXlhZ3VUZjBaWFVLZ1QzUlJVeGhjbG8vdTNWS3g2UzF1eS84b1NVb3ho?=
 =?utf-8?B?UHlUWktkbTNiS2ZRc095Y3NJbEthWTYwSlRTcUR6N1NZaUkzK2Y3QVRTcmtV?=
 =?utf-8?B?STc1TnFyZFM2dGpVT3ZzenFhWEg5cHY5c2d4T0d6NG12TGxDV0VEZ0pTczdJ?=
 =?utf-8?B?TGNYTk1meEYrak0rODluaEd4eUQyMW5VLzdId0xIOHNwbWkvTnBEMlAra25R?=
 =?utf-8?B?UzJFNGJXWndDejQwSElNUnNDQWtuQm1BWXNWSXRHUG5idHBqMTBhWE1HY2xM?=
 =?utf-8?B?OWdNRGhRSUltU0RsZlVOejJGK2JlSGhNYXpZV2V6Sk4wSmhQdnB6Q0NwOW9X?=
 =?utf-8?B?UnREdkxPUXdSU3ZoVDNiNTVsTU03WWhWN1QxUUw2SHFma0x5dHgyZW1wQjBB?=
 =?utf-8?B?R3RvRDgrVUlYYUVjaUl4VDhxWVNmVkVOdVJvdkZRRU44WjJJaU53NVJkWHA2?=
 =?utf-8?B?ZWd3dlErbk5TQUppbmwyU0RzOVZ6ZUxzM1JpcllJbVdLc0VUWDYvcVdYVXZK?=
 =?utf-8?B?dXpSNjZpZHc1MGc3SWw5L1lST2Q5WUVQQUNrb2hoTVVueUprMnVJYjczeEZ1?=
 =?utf-8?B?UTVDaDByVVd5YW5oT1Yxdjk4U0pkMUlKSVRicHY2bTZ3M09xdDBRRlJ3ZWJz?=
 =?utf-8?B?RHhYYWNFRi9ZQVg2RjFKOGZsbjBJU3VVT0F4SjNpRlkyb1J6SUhQUmRMMTEz?=
 =?utf-8?B?M29mMlpwWWt4enliYW4rWE5rRWliR21NRG9VRFh1UGVYdXcvakRqZWMwM3g3?=
 =?utf-8?B?VG1QVGJSWldWZjJDTFlkZXlFbUpoZmR5em5LN0FaQWxLUkJhVjlUbmEvQ29T?=
 =?utf-8?B?d0VhVVUzSitXTHV0VFJCOWZpbm1pUVY5M0t5bGFHSFNlc0w5djJMZmxMZXpm?=
 =?utf-8?B?MDZBMFN3aEx6ckZhUE90QU9HMDdWME45VVh4Z3IzZmcyZlArMGdTQm9sNUFQ?=
 =?utf-8?B?eFZ0dmVVVURtOFhrVDZRUFlrZm9yOWxtcytkZitJdXlSbk1iS09sTTVXRGp3?=
 =?utf-8?B?SG02bkVBSTBXbG1Ua29Rc2o2ODZYcXV1Ri9FWWVrbEtsZTg0T2FoQjljMjlH?=
 =?utf-8?B?bzVnOEhYSGRhTU8zTlZHRWZtSm1hNWt5U0VVTXdIWFVqbzN0N2p3QktHZElE?=
 =?utf-8?B?Q2VhQ1pnSmtjeUZEYmpDeTZGT0N4WTRLNEZuUWwxbEx0R2hVUkJWMGdPbU5G?=
 =?utf-8?B?bGh4WWh5eDJnUEZZMnM0NnpoZWlHZnF1Nm5sWERvTjVKcXY1YnBlSW1hZlNu?=
 =?utf-8?B?VXo3RWxGVmw5WVplQVMyR25pYURuUXc1cGFGVUVRTldVL2NGc2lCcmgzOFRV?=
 =?utf-8?B?YmkvVk8zTUIvTFFLdlBpbEVReHRQN1VUd2RYL09JU3ViYUsvU05PVGMrV0dw?=
 =?utf-8?B?c0NDOUNRdDJPQkxVcU1pbmlFbllRY2V2bFlZdWg5QnBhbVZpMEdibGRjV1Zm?=
 =?utf-8?B?MUVtZXBtdWpQK0FEL2x4eW9sdFVRak91KzJnMi93QkltTGV6Z0FSZ25KOFVF?=
 =?utf-8?B?T0NjNDNuLzRBajMwSUdicXRKSTJraENwVEN0OGVpOWhqSHFxb3lIbTlUcFV6?=
 =?utf-8?B?MGY4cHcyWnZZOVhmS01qUXBqKzgwUUE2M3BVdFhBS0JKYTBVMjJzUHhNbmdq?=
 =?utf-8?B?MmRQWFdjbHNhT3JVcFE2cWN3Ly9kbktEUTdFQUJDdGd2V2FPSWtGRCsxdFZ4?=
 =?utf-8?B?aVFPQ21CMnEyUUxLTHZGYW8rOHQvTWhqcU15d2gyU0pTbjdoN1lhaTlDaUlT?=
 =?utf-8?B?SW9DSkVETWRZb2VSblRud1ZkblBQSm1SaDVWYkwyOUxyajRQeUVGdkxNODFw?=
 =?utf-8?B?THZxbTNTWjdlNzloWVRtTjg1MVdXVTlPNW9nZ3Z4RUp6YlF4VzBhNXhHV0di?=
 =?utf-8?B?M0UyaitvOHhoc1NVVmgxT1c0N0ZkNmFXdkN3bDNFU0MzWGtJNnM0bEJIeDRi?=
 =?utf-8?B?NlNjdGlveTlpT1JzZ1lnRVdrUFpoZHQ5L2JORGpXdU5XOWNpVDJRUmNJQmZV?=
 =?utf-8?Q?/Tf75hdKSR3fQAI/Jm3v454Qjpy2XYtpQqokP?=
X-Exchange-RoutingPolicyChecked:
	Xd/hDGdkgp4IMVmrNKeU9M3fv4SWom0zxTQiHJM+pUo2PrZ2fqdVxe86+QfduxN4HkxkmtHYHT+HeaUbFMEbWiDjJjJRoSmVwnHGpuMETyd9oRaxUSMFNgzA89lnWTZmVEd1Uywxav/P/gyxZ+DEio4HzwqhFJVQXb7TQ2ArKkLFwQZ6ykdQRM199N+54NVg3z8gzr3qOus6/GtbGHizKcIQWFcYIhTtxc2k1GoGOHELIdODbv6kzEN4dryGpgVz6LpB+9OTvmlbMHSqip+ROQgikgTQUDOub03rlRwKMCO4McMZgTo3ns4Ol0E2iT/lWbSszsRJG+LIkHGio1z2/g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xCRpet7FFfJkO9ZciAOyFY0yHspQc1NW32GPQ8o9rpYq2xHI63XQBvhfZDT6M0fq76qb+RtIYp5BDg2cPFlvyMjnmEsUfDaWBISdn5Dlvj+U9N6L3TCYX7+29Ek6xB15iQDeIesjc2K8SOLWYbEpHWId/A19CipbMNdgecSeq7DYY7ceC5yGjknZvpyBC0SfHwXfHClxTBw0LAHDoUVY+SNO0k4zwhlp9666nyY9KFWp4gbsyWRv9BMu+WkNcTNaZX7DtGYNnBzyr3TVmFacOrHhrp8vs336dBAB0+f5BqLGCQMpuwToECOssTUNKLoMT7SIkyVOCwMoQfhivKv957GecFdz2mqDkLaHNEL7i0SXIWHsPtGXAPp/uUdP8S5PvNG7NCNS79/CbmX11ShDG+XgK5PZP3AYQFnz4gEssU7/a/yetxeMKNsps5AQnGZqjcUKvNrtgla1enAf4R8DujnC6FlBCHoX6WGhlQljEA29lzqxxd9SLdzEYzqgWea+RSa3aeLtlAq9fTOctCDxgcTAbrObHCiDNzgEBEi37hDutQNggs4B0U9mmCobhkhFdr5vkeBX+bkWzdXesVSapgLZY4UhFORRo044Bba5+lI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57068bca-1743-4c5a-91b9-08def11d588c
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 05:09:07.7147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pubfhtEmFe77FT9tcsK1t3T6tz57CoSnGaia7TMpRlROOR+t0AKlctswtOerXH3XDG85vkDj1FFanRCEi9FDvVYG7I1nfFruEM5AVagUz712i8LdM0+YNJFJMLfxzQCB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7844
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608030042
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA0MiBTYWx0ZWRfX33SJEAkS7iTd
 +1fljmguE6+A3dxFoiORxl29Sx8ZXrTgOO0m28eGUHzOVow+KNnfxdb7ehJW0xXs7CsIP/1WuuT
 7NvvWM88ZOMUXnZOuExqEK4LLarFPUzt48qPY7utXEMpucCcZZfUeMB/mHlll+oeZGmR5yU5tNT
 RtEDUMbc27yeVfL/H/oRRzDGCCcrGwrlQWNLzFUO2/yuwdhnC57Q/LFC6B8LLlfe3lTIw1I6T3b
 oMPTnGHdvpKBlZbJKoaFYXHDnmi0lVKU0bP/g0tbRpDWUM3KxLwzNLB/xuXky6IYvCMzq0HSbBm
 D1TizRX0uiCqWmJFTPYeDu4FCpKjH1/FkBuCp6piOa/S8DXQuByEFD1zJiBi2ohbPYYvFCOXzXT
 ulYrc+5cLmHynDq7/4K5VnyGk3jsW1rvhCUfgncd6xTG2xM9TRtrhqCjc9xlCGvbmg3vU/LQQVl
 ZVG+LwDPa6YtQfym20g==
X-Proofpoint-GUID: 2Kctx9fg6XakhVb1cLgLqcYN_b09OZZd
X-Authority-Analysis: v=2.4 cv=frDsol4f c=1 sm=1 tr=0 ts=6a70227b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=zaxhBlLj2UWU9TMZRmgA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: 2Kctx9fg6XakhVb1cLgLqcYN_b09OZZd
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA0MiBTYWx0ZWRfX95j1TE/ZoHZF
 BDlQU2HX0CIy9BpHSJwU5wrhGnQJcKFgDGOMGVi9PC9SQnmKgbaO3RrBb0lbF+fTnnvfoxU1dZO
 Az13wpoYB6JUL5hx3RgFL4jNGCm0Pdr3sPyxA3fEQ4+d06AXmEk6

Hi Sasha,

On 02/08/26 8:45 am, Sasha Levin wrote:
> On Sat, Aug 01, 2026 at 11:34:53PM +0530, Harshit Mogalapalli wrote:
>> So 769b0f1c8214 is recorded as present although its semantics are
>> absent, while 201b62ccc831 is split across two differently attributed
>> commits.
> 
> Confirmed, and thanks for chasing this down - your reading of it is
> correct.
> 
>> Maybe we could be replacing 76344b7301ce plus 4ee2d0ce3e82 with one
>> correctly attributed adapted backport of 201b62ccc831 before
>> 6261a33d665b.
> 
> For now I've dropped all three from the 6.12 queue:
> 
>    - bpf: Refactor {acquire,release}_reference_state (769b0f1c8214)
>    - bpf: Refactor check_ctx_access() (201b62ccc831)
>    - bpf: Reset register bounds before narrowing retval range in
>      check_mem_access() (5e0b273e0a62)
> 
> I'll requeue the fix next cycle with a corrected dependency set.
> 

Thanks again, that plan looks good to me.

regards,
Harshit

