Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF7F3D890F;
	Tue, 28 Jul 2026 07:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785222881; cv=fail; b=fvsp5SXMSV5cEJv2QX5mvxVBMROWZn2TB8L7pJM7sE1jvf2XDdveEjus5hqI/KyNdO6UEoZT+rUFhgRJjdyWkALbHyKTM7MOE3d4oRB1ZrEVSdlT+wlQ0aOvR8IXZZRkw70eKFF2mCR7lmuVso3L5ZLma/GtavYHt0SjkuGy/rQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785222881; c=relaxed/simple;
	bh=FcOmK0JM3VFcv30pXwn24Z7IplEQogM7irIxUkLrrBo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aJVGFic05+zBsPJfrYAH/ajj5F1f1DIbn93CzKw9XwJ2u8iQD2nTW04G1Pd177MbYqx5JkPwRwNxYFh4Z1NoaBO2tHlXKAtNsZejJh3Nf0gHkl+mt8DL7tm6fBKKPMGFTBjwTeALUHftB6Mfzuxd+xQqS0m407g6NUH3AcWn1AM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l92SD3lx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B62wFI7P; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l92SD3lx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B62wFI7P"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S0QBUq3511891;
	Tue, 28 Jul 2026 07:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5JKkCzL2yL9AKgl9I4r45NcloBGHC2tcf6RYOQ7Ch1k=; b=
	l92SD3lxhe/GQn8qJA6aV7iYj2E5Lgr5e01bZvT+n+uFCBuCT42v7bmomF0IQ/K+
	nrBWEuF1c56YkROIfvUt3ZznJ1RwsPPq0003ypwW7paR6qVGLAY0qIkXyyqZysWH
	fkO91aLhwcTLtuLo+2LKFUOCjOXDU2rPM9m9HuHg2OvlHl5O5w5Gccku7hSo1XvD
	nmrJnOywT+tR3SR7m9CwmfGFOSfNxSKn550+rGFpWz/n67lNG+JtYn5KnwVuiai9
	Uh+tyjMozOaalbMnlX2tao/DjS63yFhjj9SkLHeziyafLfEbvvqt/YpfNy9uG2/H
	EYI/ehy+FkQZyAWt1ZuXMw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pk9ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 07:14:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66S7AjEu016255;
	Tue, 28 Jul 2026 07:14:29 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012068.outbound.protection.outlook.com [40.93.195.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8h8r3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 28 Jul 2026 07:14:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UaTuI1y1w6HzW6Z0d/Lp5AuAaTaGUhQcc/0Dprz74x/U/prWMzcLzpJhYDhZ9364BoeRmaseNZP9o80uZtJx+Y5ujlixprHZdboesc2pB9fR9X53tQKyxFIMbOhsMr31AUnkViaW7miT2IxA3lX5vyXJseCKN+2FCUSzQ6dP6VToiN86YlLIhmJ4NPeaWFXe+nsLImbWfz/XkdkIMZ9+3BvNaY6vEWd5Ew92jWpX54rSAOGFcSQ5n/5J2BwGZ8OvFaAlLiY+bgFh+39kPu6x5DHTEZlU4HGhOVRDe+RNTOWhwUOdZdS84y9lQnISCfY0GfSTdMx59IzJyTe/TEOcJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JKkCzL2yL9AKgl9I4r45NcloBGHC2tcf6RYOQ7Ch1k=;
 b=OUnTXTYtJt8NdOvQXvAIheaMDobmNmuG9JxmDYvSMzkM+4H0hAvr+1HOGXuyXWpSETcuMzvq9Mv2bj4MKEhk+iNXJKUyZt17tSrakTC7SDjltIIW6hEZnglA2c2rIItu01/9OJ/gYoebWwoC7lCXB9uHjca6ipI8P/se4oRtXPr+6Wt21YQAWMQjucarjI8aeqWL0ruL0MGgz0pGN9PtuVJ+lSRbLlChALB6/42IaAUd+RxG9ZP4LChVXDmxtj655bdjBT/7xh8Gd4I5cM33TG5SFV0z1+xS0Y+N5w93MfLA/qovqTLc7pKIvg+BQs6DvU1gYBz3oXG4C5AGP6yUPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JKkCzL2yL9AKgl9I4r45NcloBGHC2tcf6RYOQ7Ch1k=;
 b=B62wFI7PKp8VsA+YmL4pkJUURhuDIeoohzvsqSI6/7LIcIYVf2V3yGUF9d9S1zTQr9/dpzdDDC40rUTqeARFFfXVH8gdp+2w9QVD+WLETbMv5p+evT6FEm+z1+Gtkwbyo8jEZFQQopCepkIbUSKVpkfWlaTP4cOHxSK7PkbTMqI=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO1PR10MB4580.namprd10.prod.outlook.com (2603:10b6:303:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 07:14:27 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Tue, 28 Jul 2026
 07:14:27 +0000
Message-ID: <8a997b4d-f3a4-42d5-8a89-c37431c6bea7@oracle.com>
Date: Tue, 28 Jul 2026 12:44:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1139/1276] iio: pressure: Remove redundant
 pm_runtime_mark_last_busy() calls
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        vegard.nossum@oracle.com
References: <5e26bed9-8f32-4193-a2fd-49db35b9ddbc@oracle.com>
 <20260727202413.stable-0002@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260727202413.stable-0002@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::16) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO1PR10MB4580:EE_
X-MS-Office365-Filtering-Correlation-Id: eebad76f-b49a-4e30-06e9-08deec77dc02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RQ1O2m/nAyDuyKkZYOCZSl82+myeTfOcbuqQonHBlAQceiYih9qtmZNXiXkgIWnKw1xpokkr93tPqNExKIgzpoIOalSOYIBdDQ34XqfNqrz+a4kXVNZw0giYX+ECLIT/sx8vLPF60R4if8k69l9rwoy+703/Fmlhu6VE2NTVvYsp5/fP+Fq9n5oKHgS5m7f8n4pMGJTrJRDBa9oWpuXSVVN/be7lQ1Q1jEbFqZbFlL/63XBJ5kVjsauAGUsuS6am9hkoz3Ov/MkIl50BZDRjeB5enNoOYrZLs4MizcU0sNSmmaUycY7P7DA2rv5hxMdMazcTtlPsa880OXPo+bWs5dlpCyDAcAgl017jZ0RBjpag902HgBRpFIdyByh42JTOeaeMInxtPwxeLvg7d+jrCw1JlJB+xEmfGkDmC5TEagxcRZSfS7q7V7SXNSQEsy0TFcExw8ln2r1kJhEddF6/x3s/Ju+ivJod1XrRtVuOsNsJHD5prv/YUIseZjWYFv0afrQNDLvQo+TxM8DGUj/M5A78X+9Vq2KSn/IaKIeAbkbGEx85Cj9T5iW+X2DYvo/1GyInbWecNoitQvwAWDT+EKCKkRVT/aX71uueO1Ve54DceEzGOEOfvDK4NH2MRGNFOJJbrYmyNgwqiUuuY6+fkGky+r3egYfejyo3IBNKA/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NG1hTmlOZ0JvME1uN24zZlJjaEdTU2FnVXhrV015SmlWT1hhV0dqMWppcXM1?=
 =?utf-8?B?ck5qMW03cXF1NnhacVV1d0h4L25GamM1NGc0dnczaWlya1NKQnhOUEhLdDhx?=
 =?utf-8?B?OUhXZnd0MWs0a3NyRUNudFNCSXlkdzVxcU1FdnNqVm1nRUpJYUdseHlCTnlI?=
 =?utf-8?B?QzdRU2pURmIzeXBqWnVxUC9mbzE4bTFaNHloQ2MyeVNGVFRVYzRyVVdtcUk5?=
 =?utf-8?B?UVFyT2wvcEdJS2NVTXBTbFNYcEd5aHhORWI3blczRFY4UHU5TCtsSFNnSU5t?=
 =?utf-8?B?dFk3Z2ZPM2pqMTR3SDlwUWc3SEo0K2NDcVgrUTBnay92MG5zeEJ2YjYveExh?=
 =?utf-8?B?QVBWZU50enFDYWprOE0yY29ab3ZWWko3MHVyZ0xxS0UrZC80MXZEYm1TY0o0?=
 =?utf-8?B?MVZWaFJqckxjUnB5RUtqWnZPSDRBTHVzOThBVEowZFI0eXpPU3d0Tm9DQ3Mz?=
 =?utf-8?B?K0JJa1BtdVVycGtsRUVkdEtIeDNtUzY1MzQ1amJXeE9yaUNqbGZKNHMrYWR1?=
 =?utf-8?B?UTBmeWllUlJ6bFAxUEFmTnFVaVZSZnJINEFSNG5pMUFIT1ltRHRLNXNjL1hQ?=
 =?utf-8?B?SDlGbFlJMzc1NDZkZW5jeUxPVS90ekJrRFN2ZW5KaHd6dHo2Y2dRSE5wN0tr?=
 =?utf-8?B?R0JYYTBKMVY2UDNEV1JSczZNT2h4UFE2SU9pYjhReE9NcW03cFRzVGpOTmI1?=
 =?utf-8?B?WUdPSkNOQlhabk1kZDhrMFhNaWNxNG96UDdVK3gwcEZDcEh5TXNoTnpCVGY0?=
 =?utf-8?B?NG1INU9BbktQZTBwUzdDTitpS1NHb0UwTnltdXovOFV6N0RMZkZmTXJhbFJ5?=
 =?utf-8?B?L1MvNGxHN3dlbWZVWWR3b2xxVGU0bVVFWVpNOXBLcU5FRmNYTndaVHBRYksz?=
 =?utf-8?B?RUY5VmdacjdBbWw1czFDOUpyNzFjSnI1VjlvVU0xOFhRMmdwbzN6cGhUUnIx?=
 =?utf-8?B?KzIyT1I0TlZwcWVHTWNnb3lWMlBsblBMamg1YTZPQ3ZXYnF1My9iVHlYaGJy?=
 =?utf-8?B?ZmRjQWY4bkd1Nk9aRW1JMkJqVVVuZFBYbFRrRU14U1dQWno2OS9UeVFwL3h5?=
 =?utf-8?B?Rk04V2JXQ3BiTFpRUHJKUXc4c1R1TmZRQ0R3YWMvcU9obHY1aWZQS3FLbFlu?=
 =?utf-8?B?WHNMbUxIZzM4ZkVPNURGam1VUHkxaFlVU2JXMGdxOG5zSnB4QVErU1VIMDJL?=
 =?utf-8?B?MzRnZXZUU2RBKzBFc200dC9aYkYxK2FVdFNBaXVnS0dDcEF0OCtKemM1YzB6?=
 =?utf-8?B?UGhIOW03c0xMcW1KV2JVVDJtYnV5ejFJUnlJdC9jRnVCK2RjVVVUNjhpY1Q2?=
 =?utf-8?B?Y3hBZVZnSktKODZZTXNmM3kyMnZUYVYwcW04UkRwSGNDdVBuMFhhaDJjeFB6?=
 =?utf-8?B?V2RvL3poOWpwNVVwYVZsTHNZam1tTmlqdkhaSUx3RU1PRyt0c3MrSzJ0TUJW?=
 =?utf-8?B?QUlTcDhZRnV0YmIzRWI0SGo0NHhVcjNjRVlBUC9EVlM2R1JINDFONzRLbCt1?=
 =?utf-8?B?c2pubjhOSWp2VnV4eWdWS1d3Nmo3S2lyellDQkJvQjVvUGk5OFE0MldvRkl0?=
 =?utf-8?B?K3RNb1VyMlY1d1BSV0trUXlSdGdINU92MnROYlRHOEgzNC9BOFBlRy9nNndX?=
 =?utf-8?B?NTg4R2xWbUxDK2dmTmVjRXBwR3g1RnR4TE1vVlY3My9RR3B4M2xlakNMcXU5?=
 =?utf-8?B?aDhGNmwxY0l1Nk5tc1RubzFnVCtyMmw4RFEvNGxlQTV4cEVIMFRsNUtBekNy?=
 =?utf-8?B?UnBEWi9teU9IeU12SFg0c2dQRDRweGlXQ085QSs2aHI5cStYYXhadTZvYW4z?=
 =?utf-8?B?NGFnejU3dWRONWVLYWFMWGRSbjU5dWFzQXlXVDNnRWpFRVphUUtlOG9IZUFJ?=
 =?utf-8?B?eVZsQjhnV0JRQmpFRVR5eG1oSzZPdWxjUFozMU8vS0h0d3Y2eWhTVG54M1Rs?=
 =?utf-8?B?WFVZNkxvUklhbUtYcVJ3MU5FWS9KYlQ3YUlURHZjTGdNY3lSY2FkVVljT3d4?=
 =?utf-8?B?NHdaK3cxN01DdGJBc3FCWVRJMVVOTHNYNExqbWEzY2xRU3RKNzZUYXVtMDVE?=
 =?utf-8?B?K1ZpczZQbXZBcHhxaHZnclR6dm1MaitoNmlmWDVpaVQ5c0dMbktFcTllK1JW?=
 =?utf-8?B?V2p4RkJiU3BZNWdLUmtBOStQc3RVRmZxdkVwR1BJZUlnT2dvV0NjOVBFbVlJ?=
 =?utf-8?B?dFJqNDJlUm1IN2JXMjY4czFuMTNKbVo3Si84TkViWkVSRTFlRVJLMGEreVNs?=
 =?utf-8?B?azFnUHlzeHd3SjYwNzgvY1VPWHEwTXN5ZkJzL3hlUW1RMU5tbWFzQnZRTmxx?=
 =?utf-8?B?aVhDWjlub095NjJVdldLQTJxOXlNSllXWGc5UndYY0RzM0h1djl3dmVnemcw?=
 =?utf-8?Q?0neByv/CnLpZiqlFduDxD5THld1Wo0j4NIIbl?=
X-Exchange-RoutingPolicyChecked:
	JAeaGNamiXmV4RkFybqQqzB8nJOQCCkeMnMJ0RNFLBZYdKfch1gG7ED2ZZTP9xlMzeXyWXJHnyrRwH1CqBp2M6d0ZRfacSdPzHIpmNZwWdmDBcXSQUGokaJ7me3U67adEWdXz6LmI1QDvs0WGuRbhENQWDrbcxbrVV1aekuTMpRbvCFavy7MvFejk4Wr4Ko7pUEXj7ZOfDvGu1VeaTVmXaBp3To9MH15Dep9d/YDsygxmClUkbrWBPefBea9KZcKWtFcmScCQYSwgl+UBheo1hFvDXE8B3fYSRoCZ+VPqdfgNjwOt8QazYKKxc/GebOk3svuBYG9g4DFmGn/IFPn7w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SYrTRnckgXXhArAU+RqLMV28lYVtKS2xfOrwfFpQWajV5PM45hQgdxiLpTuF/X2/OSz0GjGEMZBLf//Yuk07dUnrHMyFkGTamyfL/viACmAhBsPu2MOnUM+/kmbUsVHSU/BkdfmQgH0t77lx2L1Nrb5ZuX0Fv2Aii94QWKfEGyxAgcS0nGZC2uGdFyAMJ9UGwNXEpikMxSgMfZkYzOSRDI7+SZWT/wfTXf0PCMNI+MUuvmCguV4a+auixlz0aOcaomVOTFMzqG2WBDz2ouBlvKhLp1G/DIIVDh7iJvFG52M4ydSwTop/KE1HCSq2FND3hSq0kprZ+Z50IyAPgWoMWxeG9WE483B1H0/X8TLW46H8dkr5mwUIENVs9l3XvJJu7chZlttzx+SH1rjSYWelyMrX6OCEcnkrGYd5TN9yeUX6L6Uqzjrsumg0D9lJj0dd4iu6QIZJp0fLIULIITSBrfD9y6FFzVtyPLQQX9r7rhFx5mGteJQoikupwRxb9KKIxB6uZ+lxGp0K271Ccia+d9BgCoQYm3vRsJQVv+5FUXLrHMcLv+i+ViBfwirIkmvv0igNwcerHUW+e1hHZUasWX+xsdef5fp3VzPTkBt6gnQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebad76f-b49a-4e30-06e9-08deec77dc02
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 07:14:27.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BztXJL0NIIp+XZ5CUEL2+zvGDDD5PvtYZ+grRdNisjRVWQYxrAGOgfEIn+0OAoDZw+VTtHy+a/8hQWR5yrT7A0IvcCxh+dO5XtHarioEl4w1LUo2q+PMRepSG/Hv/WTM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607280062
X-Proofpoint-GUID: gZicQUoB-B2gJx1dCxxNEmSdyRMY5Uvw
X-Proofpoint-ORIG-GUID: gZicQUoB-B2gJx1dCxxNEmSdyRMY5Uvw
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a6856d7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=eI7B1pA_Mrple_t_2uEA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12115
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA2MiBTYWx0ZWRfX3/wQZ0kVsOVx
 bR4pCfwYq64yO7Q65k8CUWAC+C+j2fLG+VcucO6g8eQAnYEzGzklm29MbegTRbNWtP2knfCR/yQ
 UkcsObV3o3MGMyjZ99+7fsYzU9+MDFVXcDcCKtpPg8bjII7c37J7FjNZiyDFnbj00lQYf5X0df2
 riznUZPQuSNSMmBrnQh8sqVCe4IejjrIudx9UVm/qynvgILEwM1JaagjH5PYnKnihkh6/RbsOhJ
 4HE//AYjQSmVHHX04eMCz6Z4mBWuoDEy1AwljXdUBVaE2GThEM+CYY7USL2e3f7qWD1xENUJVQN
 YZW4sTjeKQ7TpwJHZjVam5bX0tEyFjDPAltOjieMHMx+E1pIAJSgZlVlLMlD5D1i4wRJIWKuXQF
 Ecj7Dznqb9ctJjcdOhvRri42kTvxPTb4dOMAuKEaDtObDiTed89ABL/nZ0gKaXvTefclU5Sj1+w
 fH2du8upy4EGWFikzsP/iltR3OD9ccUnp2s5aW1c=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA2MiBTYWx0ZWRfX/RAHKk2pbYnC
 sMnY/oSt4bH9oPGxJv4qx59gM1noQR+wTuOMZD/soVTFawEyXO+lyplEoxjksAz7WTYyE6wgc2c
 4RnLZn9DMxTpRymDrHALRmGd5C7PnQYYZJLcNUISW9BrTBwfs0ix

Hi Sasha.

On 28/07/26 3:49 am, Sasha Levin wrote:
> On Sun, Jul 26, 2026 at 08:55:37PM +0530, Harshit Mogalapalli wrote:
>> Looks like we already merged it so a revert and redo ?
> 
> Yes - v6.12.97 went out before I got to it, so dropping is no longer an
> option and a revert on top is the only way back.
> 
> Could you (or Sakari/Jonathan) send a [PATCH 6.12.y] doing that? The pair
> can then be redone properly later on top of b3db492e8335 ("PM: runtime:
> Mark last busy stamp in pm_runtime_put_autosuspend()") if anyone wants
> the cleanup back on 6.12.
> 

I will do that.

thanks,
Harshit

