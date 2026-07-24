Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CB542377D
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 12:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895683; cv=fail; b=qef+njYXcv1gkfQFVJKR2MjDwhd8m8F5X4k2CFRxdhtgn/LRq0ZA9n4cgYAuO7X3vwld5hqeXhZpOutBTrNbYBeZGolIyCtUTGSo9wLyvq87u/vRjFBdJmWvYefQITdWL1HNKgnf02qhVD2sn8zDfdhm7GAcR0j53+y6trrAeSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895683; c=relaxed/simple;
	bh=Rlu1LWeji8I+TomnMuk1NYdwYH6BAS/uEX/d0bdYadI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K2pE9BX19NBGF+Yrrpdg95pmNcpDgxUKh+8Q5/15XH8Tsfd+deFsJiAcP5kiqA8KMYAUzI2M7Eupwigq2q7BIiHf3XTA43x6KMboZKjbzblruHIrboQWoSqVaNRNmG+txYntalKSZCRjKjaMJBHSFGUdUosrP2FXZTt5YN+/HwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X26vhIgz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IheGKNwN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X26vhIgz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IheGKNwN"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O8T8481207325;
	Fri, 24 Jul 2026 12:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WRO0VxyH1+4pHOoSICdKz64gT4Kr3tqJrTT2aBtfi0w=; b=
	X26vhIgz1OLWMAzsZjlJTUTnRn6jRlsEuidEQ2pqZcPSQRk8S7icRDPAo/OXCVIo
	AixbXL2VDqdiwIIef9ELxA3VFwXjgoxwEiCN3LXFukvHfWwakZYC03eQ6DvoLK+o
	1V+Yzq+jxRQbJIkfFwE1CIcFnAkl+/greONm69dREes4wT00pX27iCBej/dkwg2a
	/z1d2cBYAkR9wRPWIqjymy3pDl0NDpJXiOJ/bto6Uza836MC0mZAjm9CAflj+gWe
	uBiG599stLR/uG/ZNR3q/1ZIp8RB2e1jsPMkcXA5GSUKVedG4+q6i37B+YmlaP8Y
	0Al9RSzQeiHr5a6ot59CiA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv8d3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 12:21:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OCIbix019877;
	Fri, 24 Jul 2026 12:21:11 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxt601h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 12:21:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OBWFcYccQuMzdFVb85ckWzn5GyKN5WL3tFSq56vIJ8pbZa++kDtFlMAelEjb97aD3S8MhMHJscVSmOHulQI6s1btTw45hZRWTD9yK5TJePP8tAEsT+iM7n//oC5kz4Ist46dsjGnHIKJ0WLGc+7l6JGt0bqe/kaKqz+00bGMTMXoBEIUCc7Lld8suM3nxLTGquGkMRL6vdKx+sYuAPieM74idD/2pfk3q+3DkYyl59WvxkrN+xw1zAxcdy4g0tm9mw1F6ZxaxoeYCCH5HNnup4vSsgEGJbbRecn9/YFc15JPaRSxIkaQBAQazJ2CTsRzz1ukpwQrdlCUtjesd4k26w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRO0VxyH1+4pHOoSICdKz64gT4Kr3tqJrTT2aBtfi0w=;
 b=wRj5Ruunm+uWdjVmdy/mN0F/qtVB5AL/MI0MXuWGhQA47aC28RW1VXIUFK5NQ/Bu4LVs5TtiCQfKYdvzgWswQIHNdUDtFlVi+W39D0H9PIKqlpFz6KrCIGIgfX9x5Svhmj5ZC2C1cRX9WeBjs2p6Mb5Q3Cs7rZSwn6R1y0XG5k0+F5gGfQTA9MY4IOnpa8fhtK414VDOrW+wuZ9BromRvE3mLB/dLh44XZw6O69g3xWMN5zdufbtOl03Fy+H04VR8ANp+0C3iooAawIjgFUTrDU688q5gSNPHabNPeAOYC+UgBGAWOOtLT7erR0MltWhULM1t+/MD0/QnAH8Q+Wv0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRO0VxyH1+4pHOoSICdKz64gT4Kr3tqJrTT2aBtfi0w=;
 b=IheGKNwNAk+5BXoDm0OWIIQMI61AMYmvZaSozNVXJQ1f0bfZzf63HhdYh5hnL/giNWnpTaJT4otPujV8M7A08ptaGCZFlfy7I4Ej6ZwBOrqYubQeg6qxOq49da5yj1eKm0rXESb1rsBZNeIr7DuDF99kHSnifDM3jJrWrlblQuw=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DM3PPFEDD6F73B8.namprd10.prod.outlook.com (2603:10b6:f:fc00::c56) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 12:21:07 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 12:21:07 +0000
Message-ID: <a0273f34-8596-4b6c-a489-66a4533b6dd1@oracle.com>
Date: Fri, 24 Jul 2026 17:50:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0139/1276] arm64: dts: qcom: sc7180: Add power-domain
 and iface clk for ice node
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152449.211750681@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152449.211750681@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::19) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DM3PPFEDD6F73B8:EE_
X-MS-Office365-Filtering-Correlation-Id: f6731f0d-3a20-4eac-9caa-08dee97e09a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|5023799004|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+nA6st6hcaH3PG//sK+XrOz+uU1ygWZYlB7L6+IdgAA/d92bJBQDvKGAQY5r/AYILR30rjsMKqZgh3x96RBpD89a84ZF5Q6JaaXumEF+WwVI8glcfd9D8xV+kZy86+ionJDl/t9GQYzFSonUOzS7pbHUu9SoCe3Ae3Go/PO19UZL1n3g6wc44UM67Th8PmdphD7RrUqy5lR+stOQDqkVlxUq2HXLnNmCpN7qMun9L4h1i0f+/VB66Hnzb6DKR8UorIFUkKcYe6yAqejRnOj3OGYC+XAT67ZWuO1WRWU2Xl3XBnbzF5vvFa51aJ1nqdHSkX81/kNuDOxx1cpUIC2KPzBIS92WVt8UAO7WvuQMq5GflV1xOwJpM4wipVwQptxz1Gk+KtqnEQGH1znW7dHPqxxgf9jqqFDHZX+xq8x+oD+ZzwG751acC/k8Qcqsp+ZJ2hdPqSNUzqk7ALRlIUiARrkX0+v6aqK9hTFLSxODzMYZudDO8nn0UJdL336z8oj7i75/95YQMDySpK/8G9GNq3I/hB5ZkrWki48yW2P5agw0VmrUBhDm5Ibnnnvwdul+MPuMy3XJczpzgYMuUTZK/DyEsVYAH72Kg0kA5A8Gm0R504NCoPS2HtKLH07ROW6Ohx/zYk/EMzib8NJy6CTvdJxNyZKTWogxJ/qvwaI2nlo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(5023799004)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUdFSk4wck4wNnMvaUw1L25RQlRkU1AxMm5jdmJ6TUR1a1BGSzV6SmFDd1Zk?=
 =?utf-8?B?a0hXMmhtWEpyV1BjajY4WEQweUJyYjUrektCYUVnMlJzeHBpUFd1K3hoanpy?=
 =?utf-8?B?bnMzSDVCSlJYMnlCZmdpY3lSZ2orYUZLVW1NRTl3SG1ZMnRtdnY4RnhNOVJp?=
 =?utf-8?B?bTExNVJFckExU0RjekV0LzNJUEVtOFFZdWgyYnFCV3ZUY1B3SGxabzMzV3hw?=
 =?utf-8?B?Y1RncG1HaGgxTGV1OEx2ZXdVeHVYYkJ1U09Ybyt5YXV5STFXcGE0eVRFN2xn?=
 =?utf-8?B?eVZsb2FSQ1RMMEYvWERPM1NzRlJHRnUyTDgrVkFrM01UV3pvSXAzQkk1TmZI?=
 =?utf-8?B?UUZ4QS9aY2dnOXNjUEtDa0srZ08yWFk3TzhMb1dhRmhWNzU0bGNMQ1RmYVFt?=
 =?utf-8?B?cU8ydmtIb09LVERkNnhibSt0ZUtYMGhCYkFZQiszS3JrdUVOTU8yVjIzOW5o?=
 =?utf-8?B?T2hBTlpJdFBXZkNEYTdaRm94ZEkwc3JYNkMzc1p3a2hxdkVpUnJLT3pqeU9R?=
 =?utf-8?B?QVp4V0hMd1R4cGFGTkxlYkRZWjJyRVZQQ3JPNFFENHZqS0w5cXg2UFRPNDFL?=
 =?utf-8?B?ZGdnY0NVN2RocVpUdVdSNTVVbGFQeGxwS1JNVS81OGw0c2h1UUJscUtMMjN5?=
 =?utf-8?B?V1VOTWxGOFdRY3pTMU9SRU50aGd2a0NwajdQdkFoOUZKbXZxMG1LdUZRTVhG?=
 =?utf-8?B?RDh3U05DQkhwcHc4RmluVDBSNFNCb205bHp4cnNEQXNxaG9SUUNOM1EwMWxD?=
 =?utf-8?B?eXJRVHAxbzdydVk3YU9yU29oWitNMU9yVEc2TjdOSzhPdXVyR0IrM0VxcG9k?=
 =?utf-8?B?Vis3T1N2NGN6V1l3cEVhSTlyRW0wN1oySW5WTkgwdFcyTVgyRjNMTFZtZy9u?=
 =?utf-8?B?THZXWGsxT1RLSnJaV296WTZFTzk2UUpVYklzVUNPWWRyd1o5eDdydENBS0Fz?=
 =?utf-8?B?SmRzelUxb0krK2hEWnVFY1NIK3o4bzdsRjByREZOYXRvWSt4eDMxNi9aSGJH?=
 =?utf-8?B?eEpIMDRTRCt4Z09CN2VLQUxPNU9ueTl1aEczUkJTUDBrajdXMHhLQmZ1aEVi?=
 =?utf-8?B?cUlJNnVtZjBaaE5EdUNUQ3NZV2xUaEhnbFdxSkxONWZ6VHlVOGxzMmhvSC9D?=
 =?utf-8?B?R2hCWTBnWTFGVDZQelQyZmt2NTNubmp4Z2U0RFpvLzZ4aGRSeTlsM1Z2VUlX?=
 =?utf-8?B?b0RPSVVneDErTmNzc2k2bld0SXdTNGZ0TzNiYk8zKzJyUjdRODNhTytyeTU3?=
 =?utf-8?B?OW5kSVMvRzhOVmpGK1VIWXpzZng4MUZaSjBiNU1yc0htMWN3dmxsZVFGSXZ3?=
 =?utf-8?B?RSt2QnQ5eU10K1FNZGp0UHFsOTBIQzNKQnVKZDZmVmQ2bTNnaklqbkdtR0wr?=
 =?utf-8?B?a05UNHdwcTRoanFnZnVZM3pQRElreEs3djJrNFhDTmxQTjdZcnVsd2o3NUw4?=
 =?utf-8?B?dHBNYTBQMXNIS0xWTU92YzlKSzhxNmRGYUNieVlTVERsdzRYV1Z3UHJwMFZT?=
 =?utf-8?B?MVF4NStlSzlwTE81a0RPYlYwY09BeVNhbmQ4ZWZBYzlBdytHbmRNL2lVY25K?=
 =?utf-8?B?V1VyMVRCYUw1aGVRQTBoa1BvclZqMHNXNDNSSlZIYWx6VTJZTU45NnA5ZXRo?=
 =?utf-8?B?dXk5QnVuTVFxLzhyOHNtTnFmNHJUVDFLMlVBSCt0RHV2Y25mU1MxNlNyQktQ?=
 =?utf-8?B?ZFBDQXlPWisxZkRNZUg3T0lKeHQzN3k3Zm1OTk5YRVp0TGVSLzhzK0ZzZlYy?=
 =?utf-8?B?ZEhpOUZtOWQxcStpRHpLQlZPcW9PRDJ1N21DVVl0UTVRL2xHSDU3YlJGSnBR?=
 =?utf-8?B?RnZ3c0pFbG04NzkrUlhsVXN3ZWYrdWZMcWpFaHV0cDU1K1BYTFc0L1Z3Ry84?=
 =?utf-8?B?VXpnRmNab1NuS2RNNHpJa1ovbGMyUVcyTHF2a1d2YzJ0SkJqb21FdXNUd2No?=
 =?utf-8?B?V1pjMXplQ2R3cmtxclB4clFHZnUxR1BodFI1c0lYc1JuVTVhbDVpL1F5dnk0?=
 =?utf-8?B?d0ljUkwrQzFNQTNVMldRc29DaTVxQ0hGc1VjMmNyQWVZRkY1Z1lyOWRkTFJw?=
 =?utf-8?B?V3lJMWQ5R0d5S0JDWk9VQXNkODNFeW5JaWlTS0x1T1JyYmREaVRzRU1wUmlD?=
 =?utf-8?B?d2Z4azhocytXK3E5YnVpdmVZYzhnUkV1M0tUcEJCYUR6QitHeS94dTBheFZG?=
 =?utf-8?B?eEg1enpwRCtxUkZkUm5RT2ovK0MxMncxUng3NXNUdkxSOEZROVZTalhLNWI3?=
 =?utf-8?B?K0N4V3lkUW4wanNpT2VTMEc2a0RLdUl0ZHVTdHNlZDZUVDBhWTNhbjVMTGlo?=
 =?utf-8?B?ckh4ZnJHRG1ueUhTK01rT2ppVndPcm53TUxRUktFbDJuMWt4UHhrWGdhUWhy?=
 =?utf-8?Q?9cW5x0l9iwErFFGL1QsdvNYlKZ6OfYZpwmSTt?=
X-Exchange-RoutingPolicyChecked:
	pgMo8uld+ktZ+7pO8uVkhR9mcaIHxoJgKys2IepGb0pq1uCNb9DoL+hcR4A6J3MDYXxLlbMDYvn8sjqeevYxqXAbwel2cGY0lrhk6r6Q7sfNogm7nEtLLXhpZP10PbNsRpI8KN/iBBhFX/DnfAgyNqOL8qaRVGGkZMQ0pOtgk7TYdHiycsx7BBTCz6Aev5jrvKbBB65pxRzBEOdh2u7IlLWCN37IEPZqjtB8ucXXHohVH2GAMuIAy1+XA8XAGer+/Qa+1QAJ4yl+SleE/wvF5O9hfhfS0Wdu0J6zKTdFZKTU7GY4z4jQBuET5GFT2Bk80zTiYhOVWfgDWDcKHM+IYw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fGYH0bz43syN8ATyXnrIQvWOat3llQbV/LgdRE0E+N8NCOziQdTGDsxjg9zyuyFOVV99vW2WQL0pCpgO6ntWBuSR26iSNcV7VCg+UZVQpUNsvGWkv2RpwMZ0PV+kbWElfHj1vfHiyKR8jVspadSXg2to8pibSo5fH4+CcGqXVZP0xYz8CpFj6JBKdCgIGZIPuqOstg5tCCfh8wR/+lYUnypTZHXMyUGcxtQrmoMzPyJtAlJtrI/XSYmKRt88awGt+aF7SrF0MQgzNhWLr2+uOCNQUkWgFebCsrfEpCITzuBRS9K5TUeyxlg1A/IXNkR4OhpHMHPZbSTbrWxKf5updZIFoMqTfUnosDmICWkGZcYEnQjOieWo/iMgltTp1pgC1PfkVb6HeznBPYEA4aOOzXZTicqab82E8o2HOAedpmtMXWcmwjpAX49/uxGr9uFkxHNmQiGFMipFhrQwjcK3kT14zTggKoez0WA1Yq0EtQa8/mR1ayGZJBr6YLZ+EMrb6SkGlkQuGpAGpQE15VGfEywkm2TuHw79Q+VAYkt1TynQxHdMSc4nSM8WPtGxas4rfQyUcdUYZT1sSdc7FM1034tuiuA9+PukkYeg0rK9fSA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6731f0d-3a20-4eac-9caa-08dee97e09a0
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 12:21:07.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3OYZnhwKhucIK7zmHnID8FM+sizAl7eCEskCz9TUiDJ068XlNS9KgTN/NRBbAgjLeB87CzEyAF5/bgmgWz0Y01wwFhjL5/vWYYtEuO3tKG3JBk0Nsr8PqcCWcxKesp+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFEDD6F73B8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607240112
X-Proofpoint-GUID: e7RDOo-FZ_jdt_lWnrnonf-68UQsp_yL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDExMSBTYWx0ZWRfX9NHeiti4TJ3c
 4thOYdfTw4VkER70yE5e9wgssU5HC8zA7r3F0F/eCMOwcs/ed/G3ylYdFJOWpHCibDgHx3cmC5s
 hIwl2ywx8TTh2cIr+v/P52WTw64F7Rv98k8R9iMnYYIsHOCOevwI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDExMSBTYWx0ZWRfXw9Pq94Au6LZy
 0X6MWTQKhUl5QGjY0/w/V1A0ZmD+drmVmHGXHRZyV37Dme36dEY0RzZa/fQO3/zxki8zfsxBq/J
 yLYwLSUD+G3uMJ/V6NUx6/FHxW8AwkHP6mniZkRDvOoYwxZFYqu0dSvfiPBn3gpiV81z24zjPea
 f76KA/CorcgFGJ0ANH1TQDAO+5oWDJRgDGDmNBwPXbL8hbORuxwjccXVNkfdIMyoIZYmeZheiFW
 ua/XKUv7syirdqSvhCI2bENED3VdeTBAkgW6R0jT4/+N8dCGlkokXeuTWOecFZqiqofSn+AchBl
 Ujrm1G36voDdbpE9yB1mB/mPmTUmPFeML+zB/pJUHIIcljHSEcw9DoDmxS6a8Lw9IOBTM6lgrYE
 kZ/MT5uJ1Y2amVViIxgYj/YN+qNrujQIo4lq4yCrX4taSJ1VzXJJiFocDYU9ghn6KoZ6Bm0aIgM
 F6XmSA3xIpPqBkUUhMx83pPeAvu0YzNdUPVeWAkI=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a6358b8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=z36etfODR-1Um4jy_oMA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: e7RDOo-FZ_jdt_lWnrnonf-68UQsp_yL

Hi Greg/Sasha,

On 21/07/26 8:39 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Harshal Dev <harshal.dev@oss.qualcomm.com>
> 
> [ Upstream commit 7cd7271ac525e4eadd22734f418219f247638f43 ]
> 
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sc7180.
> 
> Fixes: 858536d9dc946 ("arm64: dts: qcom: sc7180: Add UFS nodes")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20260416-qcom_ice_power_and_clk_vote-v5-6-5ccf5d7e2846@oss.qualcomm.com
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm64/boot/dts/qcom/sc7180.dtsi | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> index 6ae5ca00c7187a..e52d938df1bece 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> @@ -1601,7 +1601,11 @@ ice: crypto@1d90000 {
>   			compatible = "qcom,sc7180-inline-crypto-engine",
>   				     "qcom,inline-crypto-engine";
>   			reg = <0 0x01d90000 0 0x8000>;
> -			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>;
> +			clock-names = "core",
> +				      "iface";
> +			power-domains = <&gcc UFS_PHY_GDSC>;
>   		};
I ran an AI-assisted backport review and what it found is likely worth 
noting:

I reviewed these four 6.12.y commits and checked the current 6.12 ICE 
driver and binding: Patches 139-142:

- e49e61994f4d ("arm64: dts: qcom: sc7180: Add power-domain and iface 
clk for ice node")
- 4960fae719ad ("arm64: dts: qcom: kodiak: Add power-domain and iface 
clk for ice node")
- bac1108e0040 ("arm64: dts: qcom: sm8450: Add power-domain and iface 
clk for ice node")
- c4a4e6c6255d ("arm64: dts: qcom: sm8650: Add power-domain and iface 
clk for ice node")

I may be missing something, so I wanted to sanity-check my reading.

These DTS patches add a second clock named "iface" and also add
power-domains to the ICE node.

Upstream commit 0d5dc5818191 updates the driver to request both clocks:

if (!engine->core_clk)
         engine->core_clk = devm_clk_get_optional_enabled(dev, "core");

engine->iface_clk = devm_clk_get_optional_enabled(dev, "iface");

But 6.12.y still only requests one clock:

engine->core_clk = devm_clk_get_optional_enabled(dev, "ice_core_clk");
if (!engine->core_clk)
         engine->core_clk = devm_clk_get_optional_enabled(dev, "ice");
if (!engine->core_clk)
         engine->core_clk = devm_clk_get_enabled(dev, NULL);

if (!qcom_ice_check_supported(engine))
         return ERR_PTR(-EOPNOTSUPP);

My understanding is that these DTS patches add a second clock to the ICE 
node, but the 6.12.y ICE driver still enables only one clock from that node.

If so, the new "iface" clock on the ICE node would never be requested on
6.12.y, and ICE could still touch registers during probe and resume with 
only the "core" clock enabled. Is that the right reading?

Separately, the 6.12 binding still seems to have clocks: maxItems: 1 and
does not describe clock-names or power-domains.

If that reading is right, should 6.12.y take adapted versions of these 
two commits before the four DTS patches?

- 0d5dc5818191 ("soc: qcom: ice: Allow explicit votes on 'iface' clock 
for ICE")
- e27264daac7d ("dt-bindings: crypto: qcom,ice: Fix missing power-domain 
and iface clk")

Aslo the patches are from a series which includes the above two, so 
should we either queue the above two or drop the 4 patches for now ?

Thanks,
Harshit


>   
>   		ipa: ipa@1e40000 {

