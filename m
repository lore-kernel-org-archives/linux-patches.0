Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69C519E968
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 08:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485232; cv=fail; b=GmkuX+8auFPrAGu/aPbscd/9V9HGlRHCAdFwqJQVZ8ymQi6UMnbaeX7sTVrKFAjSmwf5xQlB4TrewLMbC2dd1jREq6CfLuW4D/jvtS5TxKEXR5yBqx7sdbJhnkZXJluRHjV9qMLfjVciPjUHVfoV3eJ9cSj//81PzJfATQ9gxw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485232; c=relaxed/simple;
	bh=M6y5wi1Q15tUXMR8WmWS/HtcW+MfvCojigwcY1NUD+U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gYSlHwdA6Yeq83T2QLoGKCv/j1xLiVIL1ZJCPO9ciMNlqgv4m4Dsy5/1fXLAZ/jMSXc4mu2cgW6OJgXUwj93fXKipqKUQ3lvIe4FexLhZYrGPFnHOzynVmL17PDbbnwyZ9b07fVpRizzdcm4f/3Ioy4RZr1BOmzL546m0hfJwtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p3CJRXqe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y9fbsXI+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p3CJRXqe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y9fbsXI+"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V4qO931780414;
	Fri, 31 Jul 2026 08:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pG3ObKLu+dm2ieDLoGvbuS4TRmwXO1961M2DzKj40NM=; b=
	p3CJRXqeJtla6Oz9uWMNjZynUDlehEN87r/zjNLjXfklQXVU7Fkw3Wrv2cmJUDWP
	zuaLme+1pJi+qirPSTdMaEhkk9rVOlFZvUdAyirJ03wvtDtkJ0nwtmCkONtFTF9Y
	aD43NJTCuicFI6R9KjvpspNJs5yNDBV7twkqakwg7fH8SskYLOJKskJYUSs/YnQb
	pQ9VZarqPAmozlVnVIoiPkMHy088gpX2XdwjtJzep0+vbDf9oHUrbzQw596Ghqhz
	btbZPhr6U0KP/hImhNvGtf/Zb9fUV/iXNSBv7kQFfm9FtDdbEv2vaDj+i9sVfEOi
	nFPjOn+jkOguQ+s17PPo/Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr01933m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 08:07:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66V855rv020667;
	Fri, 31 Jul 2026 08:07:06 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011021.outbound.protection.outlook.com [52.101.57.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fqjww3sca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 08:07:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oy1mEb4ov+PV9j509uMkakoMxbHoDLDJ5eRFW1bqVr8NuS4+vBhTmS2rBp7exi+TXDCE6zdom6zaAnFQQYrhP+9Iqhu+iVG1u0ZOuFUvuDlBJbzFPgkyZe2WRdmtQvEEi1w9Op+bWE2XGgYwwg5biTEmpr1pDulamKElSqRGG/UZ5PNNXxeyc3Jy6jTUUWUEae8ZGns3LitCVxWLvkeURcyeql/Rmz9ywPbsttIHn//pGQEJyPjBAfnqb1+q/NW9zZr0KkjQvtMG768X9qbwy/DRh8wGqlA6iD2+NJCKXlGtcUv6ShUo+/dslLowQnuUM8xm9hZplGTr1r8O0VBOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pG3ObKLu+dm2ieDLoGvbuS4TRmwXO1961M2DzKj40NM=;
 b=GhNvU7lbkNzsYKeUbKsyW4yIiV4cD1XPjfR+/uXwoNh7diapsUhJpts7mtqVF7bWrJkxkNSPxrxg+qFph/Q3qET+yMTvANt0vW9XTEuyK5yFq4gyoz/FpZX67nUf528jEzsZXWRU91txNEy+nsu5p45iygvAg92BYqjlvKAZXODGR8pEIqYp9pCuIYV7JuCALOcgYmKIuCBCYbD9meCpuMUIGY0c0NZtRzXeSwSitJJ1Y5HpetpDEb3T1laxVZ5Qi2r2pyS/QFM7eUcVcjaDdeQ5zpR6cqrnMnc0W5gPczm65XoKaAG9ifZ1mBUqR4LTAQ9uskdS/nfTz1Pmxa0A6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG3ObKLu+dm2ieDLoGvbuS4TRmwXO1961M2DzKj40NM=;
 b=y9fbsXI+im0ggOD1Gn4UlNOW2YJMvCl4HU0anpATOqSVN3E2fDVI7MkOfvbJjKsAJxfPaWb5UkPQ69eoB64NHeKZmheHVjmTdkKDYq2mhnx6tnaXIWVm1uvW/afXY3skj5z6cApPfy90oAx8sbMqspH0gH5HVGA8tYhvVUFbHq0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 08:07:02 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 08:07:02 +0000
Message-ID: <475ccfe4-c5be-49b3-a542-8af5ba1046b0@oracle.com>
Date: Fri, 31 Jul 2026 13:36:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0139/1276] arm64: dts: qcom: sc7180: Add power-domain
 and iface clk for ice node
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152449.211750681@linuxfoundation.org>
 <a0273f34-8596-4b6c-a489-66a4533b6dd1@oracle.com>
 <ab3c3006-bfa0-417b-86f7-95470c73e547@oss.qualcomm.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <ab3c3006-bfa0-417b-86f7-95470c73e547@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0171.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::14) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 814e3881-99d0-471c-c890-08deeedab3d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EikAn2C5jHJjh3u14wgdabPm31oVPGTljxFjHP3zXWTiLTo3afLUwolvGWuo5P7ixA2vEXt2owCC7nIH7FoUecIS9WPUsCkadMPEniZBLzXsdK4wLvHFPGGmbE7Zy/ivoLyWsbeZh0+Yr5Q6T72jYH0K1pLn101wKoGs55icHWOIhFjWep3JiAZo4CAiDR+ZJfUIaQjTzklGKqyjg+bXxSyBJ0/Z8CgSxTWDUv96WiTTbRS2vFo/o82O4jU/PJBRL85poYbIO686GN2Hlf++hfx8bsAY1Byql+hK+m0fqBIIM+/kKVyD/vy6acQto2SMPZE5zUwcM4RyJTNOdWvYHX/hB39MN7D/sRHPHGBKFA0M7pHC9ncTmDFIy9X291E8Xky6ODyTZKyCpdAR0OpEaBvz801GLqGUb2F4T6x9HeIFUTSkYn9I4R9DbyXvnVcbYjo09cy0AVLQo+/yiEpQC2txsiAar66f9GByOrkvldQcm+v7whEyKLFg1FzS/SVJH42TZokITgKZExqqz34dtaDr0iDlFJpIYakkP/jPK8/p375oeeIay9Wnnd0hiAM3/48X36AIgUYNsl1X8XOsJtsZyWgicoJ62E2ZwcJr7b9DsOaFpj3YzCB4wPTSWWLB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnUvUDVYa051VmhQQ2MxNEFUamxDSm1EVW1sMXdvTVp1bXJISE50dUlDZEJW?=
 =?utf-8?B?OEFPU2hJQ0dNYVBNQk5xWEtzdmF4OXFCTFU3eXdZM0NFUEdLZlRzZDA1N1BT?=
 =?utf-8?B?VDR1QzErcGI2ODcrQm16V0lRaWQwVy95Y3dTL1lhbzRsWG9QZTBHWWFEa0tj?=
 =?utf-8?B?NGdqaGttdkxXaEhYbk5LSUg3eVlKYmhOdEI3UkVrYk42ZHJWWTlYeERXSmM2?=
 =?utf-8?B?MjEyaUVPaGk3MU5KZHFLWlhkeUR1Y2ZYbE5ZeTZBM2MvbENwam1iUG84L0M4?=
 =?utf-8?B?VTBoTnVmdW8xdnd0UG03ZEJkYkJuaWNSVENaQ0xOSFNscmhucFcxd0VwUzIr?=
 =?utf-8?B?Y0xQUDl1S3U4NjgwNVVCcEpoVkZYeW5BL0N4dzRRd3pTZm0wSUhTeUZVVXRM?=
 =?utf-8?B?aU9YVThkSVpEU1BjK05NSUFvZ1pEeWtmQjNySG5IOG1jengyNkdVc2ZZeWtm?=
 =?utf-8?B?WUF1cTFMWURTejZkOE1kNktpOHI3ZFkwR2ZheDZ3dGdpVUhMQW1Zam5GVHB1?=
 =?utf-8?B?K2tGaEZ3UmNqNW4zeU9OTW1WaU5NbXBMVlJudk9qSGxqV3V2ODNVNG42MVVh?=
 =?utf-8?B?cXB1bmkrc1p3YndPTlIyQjlRelZBMHlMV01ZaDdUcTNxVThUOGRMVDV4bGNE?=
 =?utf-8?B?UlhSd2k4NDE4Nk8xM2RYdDg5bllKMU9SZDFUNTNUZEs5ZGx4UFJlQ0l6SGcw?=
 =?utf-8?B?K1FSK1AycWVYRDkwcm5oMEFQUWdqUDVwVTd2Y2xBTDdDMityeFlHYmJOREo4?=
 =?utf-8?B?YVlVMEMvY0U0anNueU9XU0habXRoZ2dxNkxvK0kySHpNNW1WTmhkVXMvUGln?=
 =?utf-8?B?dmxSZWwzYU1PU051ejVHVDhvZVo1RmtUOEN4WGZZQjlVSWUvcXl1SEhEcnQy?=
 =?utf-8?B?SERhakJ5VlVhandDZ3BkVGhvVWhFR1NmaWRJUTcyang5SVBJUEVrM1pXZTFq?=
 =?utf-8?B?a00vLzFnK2tSOWVKbks4RmZ3SzNPVnBDbEdsbERoOVJmdStUbXE4SU5kbFE1?=
 =?utf-8?B?T0ZFTGc2cVpubnVsZkFJeU9QbGF4dHlQRVNNbjN2RTdPdVR2V3hqc2NsUzBZ?=
 =?utf-8?B?dEhENnpvc2NSQmU2c2lsN3JIM3lqMUNrVzdhK09LeWpUWnphTG1lWGVVbXVC?=
 =?utf-8?B?QVNKeXRoVXhZVG9jU25jNkFrUUs3NlZndUtXQ1drZ0NSUmMwb2lmVkpPZFVR?=
 =?utf-8?B?TmJZMkpjcUVZeWx0LzZPdjZZWmRGSWVmV0dmWlN6R0xoMDhtUkkzdlhPU3kr?=
 =?utf-8?B?NHNXYnFucDVjQ2dFSmhDeFN5d2hMandNZi9YdnBCU3J2MW8wVEcrZkF0eHhR?=
 =?utf-8?B?Ky9JaDdQOXpVbGlwRjFuR0xicFptT1FzQ1MycjBRdkk4dkt1amVPcXpjT1Bz?=
 =?utf-8?B?dUdlWUhtem9mT1NuNU5vZ0NuL3FtT2w5QWsyK3pMMHA1Rlo2SDZNOGszMlRm?=
 =?utf-8?B?T1Y3RVhUWVUrazVNc3pEZzdESUZZd3ducFdrTjdIdlpHNStxMUxHRklaUlJW?=
 =?utf-8?B?c3prYmZxb1hZaVZueXVhNEtzZ1VSNHFUR09MK2RhNFYrcnFmYU8vczhyWEQr?=
 =?utf-8?B?TzBFVFRpNEM3YTVWWTkxZ3Y3cXZTVXF3Zm5JbjgyZmRGalhtYUZ4ZHZnc2lF?=
 =?utf-8?B?REhmR3AxK3hTYW1hTGFkSXJFeVdtdk80bFo0WFBtdnBHV0hBcWpmN0NQeUtu?=
 =?utf-8?B?M1M0bExNRkswREVtRU0xU1NLdWpxdEFQS2tuVDdkeGh3U2FOMWM4Wnh1aDVy?=
 =?utf-8?B?UExkMlk5L283UXZZRm9lTnJBcHlJTG5ldmE2TVBRMHVhdk1OZG50MnE4RElm?=
 =?utf-8?B?bUVwZEMwYk93NjltMkZYYTBVYXhqMGZIRWlSbFVuWmdxQ1RTOUR0aGk2RnlD?=
 =?utf-8?B?cVRqczNkNWxwNHl3SGdHSzNWNmxWTDVKV1FUS215angyaGVvdVFudTA2TXVt?=
 =?utf-8?B?dFFYT3dZZlY1OHA0S2RSd1l6TDF3SU9QaUJaeEp6Nk8wSmNaTnFtdXVoa1Vq?=
 =?utf-8?B?b2ZjVTd0NG0yQmM0V2FpZ1JGQ3hha21ZUklLQlpsRkJ1SW5pVlo2K0FVczlF?=
 =?utf-8?B?MG9KNVdtUDFsa1ZSZ2tRWVhxYUdmaHBMa1pwQ2FoekZaa2tiTTEybWZsNW51?=
 =?utf-8?B?dWtIdFVJdVBOZEN5YzBubWFPL0hmdmRvZi9tWENjbVk1ZC9hT3cyL0NCSGpp?=
 =?utf-8?B?SHRaZkloNUEwbmMzK3YxTHZwRGRHRExEWE1aNHBhSmpKaUxPeGI0RzdXYm1U?=
 =?utf-8?B?L3JCVGx4Y2JBeVZwN01WV3dDSDhIazZWNFloR29vSEx2N1JvMFJIYVdOOTQv?=
 =?utf-8?B?YS85V0VLM291eGxoaTNjRjBCdi9Ia2txdjkrNDlCbFExbnJpbzhzYy9HYWw5?=
 =?utf-8?Q?3g3MS20FuTrmqtjrPOygqOPpAy+XrnW+Y70mA?=
X-Exchange-RoutingPolicyChecked:
	rmuie/ZiJEKEcIy/i15OlmnFUZ8GvR+Of+PaeUFJlZ0RClZwG923EVMeGvf5Kn3utqE5Mzf8Gd8u9xP5BV6dZ90tr/Qd0C55tLg49DDGW/vmP5DbG6ZWB+HKn6bq8tnD2DtScrvqP5ZVrOjzrXr2rF/d4b+IjvRQgKvoUcoxLQibfZ/lxQ1aOiaJrXJR5P/TK5gI4tCx1EL9TvT4R3u+FgfDT//bzlPbI7dttRfetdCj2LUjyDcFSeapYrWddF+VjkrFuYEiUZgUQJAOCog5IWT753ZwlE46MWzKB2pL2a+6p/eFfMzZgwvlJZw5nHREp/PMV2QpH5qiCQF4w/tQzw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rweE8qKv/pfbFE2BOu2fDboiIKZ/2NhJcOy4hqnJatWMRrXSlCsmm7tegMZOj+X+EBYFZaIxfxt7vHX0B7ioqB4wP0X5+1UOcyldxhhqYmXWvdikJ53Q4MpJt0yiM3N6Cs6Ml0Kedr/Ed6PQpYRVNqFjN81aKLZP2iccXFxCK1EUQV8dM4fcAs8o3LyF0NUuc3nhJzRJolwotlNVM59QnTn07qBD8M9C9GXuPvAM8LsQblWfiHHVer652To+TX4BrGysF1vj9VfokZiokhAqQEox+XmW+u2Ouf9jj6/eMiX+PhKLC7mhucXYvyAZILql5bD5cmfPNjQfwtCuuAe0McN+5eK3/SXFgkFz/9PbQWyVj6cBPIv7PYgkp/hslPey2AhxJ7lyDllWKrWPUktHbB4unXj11FxN45I+AbvaFhcnMH17ps+dc6EwneH03cjLiuizB7mMZm2mWTxWjSyBbDiteAqXtCGYoXL1vYHZXtfHTyGcnRogThHzxZlx+J+z0GBHjEmfSBDXwW8A96fzzRKY7ZKTRRzyFKBD+dISBUeds0mxCnY6UGX4Jw8cuRkAVEYjNFu1LbOH91zgFre/U+Kx0xONZPU40nu7F2PTE/8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814e3881-99d0-471c-c890-08deeedab3d9
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 08:07:02.1910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMkdmWgEAznRze2GNn1AyAoJZRAZRkjXx1HJGH5kX0vGe4JkJT+nMvgVxozWvIMn7lygs8YnQfQcIDCGQG8uKOyNpn0brfZYWMymdKX+3qrnRHtlKYXgpM7b+f9ED7eq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607310057
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA1NyBTYWx0ZWRfX8FFKnsuNc3pD
 +ANYFjX9ykkuivYw4RM1wroIDk9bxioV9MLuhGhdBTAepGasbLWY6Raw0uNWRLabseabzFYxrij
 kHD2NvyAy2x0bPEkq49UF80m6oAXaKqOlaE7m496+CzqvnLXYEkr
X-Proofpoint-GUID: xBOOHbxYdnTX8mYpBfTitxUXpDZVht5J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA1NyBTYWx0ZWRfX62lklNsNKGKd
 2sdGb3RsFLDh7yPxzW0kPnSPVScB/7aQ9u0gSQQCdb8gX82UWQXtUOm0KCoDLJ5EfyjTZbsyhPo
 QKZ0XaliAWhdgfdUvm7ZtrwzhyDFL+tia8k7zFnXdhO41RLvMa/sCv2h/vTv9MaMR6fnkEh5irC
 zprVvsT38mwE5y1IbRf9zLBk9Y/LI+yXg7w0uZdinoRqv/vyXHxsJ+mtLZpNEEejok8vn/E8Lby
 WLiQ0ZOBkgoVV+WOOv1g9mNS1aFGr75cHnQyWFQEdmyYz50q2PnVRDjACk1GJxUB7Jlh/1msvT1
 Okcw6eB92ol08HQga253NoQe6iO5u5vDx/UMBzVHlIgip/eDMPCv6AcqoKeU1dlszm9thIpIFjT
 OecFKls1OxtySXb6YJMjeC1SyZhAfvMMChqMfhmd7m9GaESmZWWjeiz5ZgbY0SqqRAZsVTHvTTn
 QjM1KVTOsQ5XfZRYZzg==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a6c57ab b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=ag1SF4gXAAAA:8 a=53Yb0-6E895rjr6lNHgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: xBOOHbxYdnTX8mYpBfTitxUXpDZVht5J

Hi Harshal,

> Hi Harshit,
> 
> Apologies for the late response, I am currently on vacation.
> 

You really don't need to apologize, and thanks for checking!

> On 24-07-2026 05:50 pm, Harshit Mogalapalli wrote:
....

>> I reviewed these four 6.12.y commits and checked the current 6.12 ICE driver and binding: Patches 139-142:
>> 
>> - e49e61994f4d ("arm64: dts: qcom: sc7180: Add power-domain and iface clk for ice node")
>> - 4960fae719ad ("arm64: dts: qcom: kodiak: Add power-domain and iface clk for ice node")
>> - bac1108e0040 ("arm64: dts: qcom: sm8450: Add power-domain and iface clk for ice node")
>> - c4a4e6c6255d ("arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node")
>> 
>> I may be missing something, so I wanted to sanity-check my reading.
>> 
>> These DTS patches add a second clock named "iface" and also add
>> power-domains to the ICE node.
>> 
>> Upstream commit 0d5dc5818191 updates the driver to request both clocks:
>> 
>> if (!engine->core_clk)
>>         engine->core_clk = devm_clk_get_optional_enabled(dev, "core");
>> 
>> engine->iface_clk = devm_clk_get_optional_enabled(dev, "iface");
>> 
>> But 6.12.y still only requests one clock:
>> 
>> engine->core_clk = devm_clk_get_optional_enabled(dev, "ice_core_clk");
>> if (!engine->core_clk)
>>         engine->core_clk = devm_clk_get_optional_enabled(dev, "ice");
>> if (!engine->core_clk)
>>         engine->core_clk = devm_clk_get_enabled(dev, NULL);
>> 
>> if (!qcom_ice_check_supported(engine))
>>         return ERR_PTR(-EOPNOTSUPP);
>> 
>> My understanding is that these DTS patches add a second clock to the ICE node, but the 6.12.y ICE driver still enables only one clock from that node.
>> 
>> If so, the new "iface" clock on the ICE node would never be requested on
>> 6.12.y, and ICE could still touch registers during probe and resume with only the "core" clock enabled. Is that the right reading?
>>
> 
> Yes this analysis is correct. I can see Greg already picked this patch:
> https://lore.kernel.org/all/20260730141436.745713281@linuxfoundation.org/
> 

Thanks for checking and sharing that.

>> Separately, the 6.12 binding still seems to have clocks: maxItems: 1 and
>> does not describe clock-names or power-domains.
>>
> 
> It doesn't right now, yes.
> 
>> If that reading is right, should 6.12.y take adapted versions of these two commits before the four DTS patches?
>> 
>> - 0d5dc5818191 ("soc: qcom: ice: Allow explicit votes on 'iface' clock for ICE")
>> - e27264daac7d ("dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk")
>>
> 
> The 1st can be taken on-top of the four DTS, since describing the clocks first but enabling them
> later via the commit is totally fine.
> 

Sure.
> The 2nd one should be taken to make the DTS patches comply with an updated binding. The binding is
> written in a backward compatible way so it will not break any out of tree DTS still relying on
> the old binding. However, the patch must be adapted to 6.12 to not make the power-domain and
> clock-names mandatory for Eliza and Milos since those targets arrived in 7.1 kernel. Only the first
> portion of the patch is applicable for 6.12.
> 

Can you please help with that whenever you can ?

thanks,
Harshit

