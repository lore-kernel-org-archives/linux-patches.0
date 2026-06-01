Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A553A7F4D;
	Mon,  1 Jun 2026 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780320750; cv=fail; b=rjPWk33M+OOt2jafIAgseCwUckcY2iH3FzKtP9rayKdUBtDFyjSESrnwm/i/+KbHG2r+70BkX/9EDzCFHd6tH0ns9YyT1jbAoZyuda3eTXUEK8j66Fc3XUDmZ/51S2REjR2nhjDh3wexxsu3H6LrTCvU2U3azsoacGv+Miw52VU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780320750; c=relaxed/simple;
	bh=la6tKLA+vsrG0I1jFvZvZ+9hMEJv63uFyzE+R6lI/00=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HzmvGkVIJeLO9SzYY3iuVyEqQjCvQqejgIQBno7IJSB2UAbYc5BayHklcg8PZVQy2Wtkpv5p0fWgoj6iJIOHzhCbS9A7mLVILHT01w3fV/72DqTOQrzTLs/mS1wf1UovE5smas9zwPAhUxfQt7+ghcB3S6IRj7TuRy4ypCWlkeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lUXsaiqe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c5KyH0/2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lUXsaiqe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c5KyH0/2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6511Mk0K1893924;
	Mon, 1 Jun 2026 13:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rHBrAOsf7f+e7rzlBY3Jn8RBQ9veTdEPEF9zA/q+NAw=; b=
	lUXsaiqerRmr6LZdyGol9o1d9O2t2JpbtxTfFrMGokff631ooQBWAGw9LuodaAYi
	7/DDeC3n7LRtq38S656pobihS1wXBIpMRt1pcrSkMZb0qoG56uRJVjRGaYpBLE+O
	TedtD+8O3ZobhZ6FpsII7bemy8o033Gh6m3w7kmIH+gy9lkhXnApJ5jIwSmE4OJ1
	97l8i+ZVVetDIQlIsGjvXDZNJiV8AM25BQsYMg2pUCGgYp7OVapJFClaECK582rT
	6EWEVFh4EhNZceJNRoL8MqDzD8NNZ5/x/Lf8h0d6UcnRQTiCxR42wLdA/YD9Fcp0
	2HWjnZsYOqu4lBLD+VZZOA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxda6r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 13:32:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 651DUjZV032977;
	Mon, 1 Jun 2026 13:32:24 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011020.outbound.protection.outlook.com [40.107.208.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbpnfh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 13:32:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4vUb7FjTnk9PhsWnI214gW3t0EgWNm84tB3TfQDLUFr10SsFMU4d8jo0zB558dPrqH6NVkQoRO1Ox19vhLCIT6qZYMdpDBX45VSc6Zoi2guZg/DzTlzqi3gp43e/WrJl8yYer/2N2uiS9imTrxschgqZp68fRPQ6ra9UgP+KtRYk3j87caMwSLUCjj2YXU4VFXkSe0+yA/NRwvv3hDvjzIXMg890q6iTsJAu/u9TlgTlKHpYcnmIR216cpVG5UXJKcu/x97l4f3o7ZPXtGZrwYC5ZBBOTNYo41C/X3H0omM4V22HkVQPkxbnM6sRI/Jbm5JFrg8Qa/vhJpNR2An2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHBrAOsf7f+e7rzlBY3Jn8RBQ9veTdEPEF9zA/q+NAw=;
 b=n3cV4WRJyXSGm4kxKy8SBT7cWPrcmT/pSktHth2KWZ/n3u3dqaxmvFjaI4xH0ZrxkKBHN28rXAGzOISGoUMVmigRMtf15fY3L6pNJG5L0EHPJnr3xUQyuJz6RMxfu7aKOTX7yhACdzUA10qFGqENlm8knkUUr2FKKJkAWYhQJ0yplxW34DcN+V2tNrn7C/PIAiVSzG+xq7NH4zGMq9gWsK5VFGVXEk3LFfOS257MwrTrzEC+bxeQ4ShhHJCLsHkYk8ODcoPSZkJqpGVGcvxZ+gAwp03ggVPaUoEM3/W9ZKZvZ50VoiOwc+pWTUKL+nipukfXXc6W4eStQrShFv1cVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHBrAOsf7f+e7rzlBY3Jn8RBQ9veTdEPEF9zA/q+NAw=;
 b=c5KyH0/22liumUC/7u/Eu7iiwF1PgMmEgQ8faXclZdvHM5oOhPCo6/wI/H+22zeVRCieA4EXkg3Lwep47LzYLMMnj+9b+eK9mBR/xPCEFObozdfENlSCL1+6x/OAURrzPJfm1XLgIO9t7aJ4qna9sGui8qH2j/vHNFpH8GBizKM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA1PR10MB7213.namprd10.prod.outlook.com (2603:10b6:208:3f2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Mon, 1 Jun 2026
 13:32:21 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0071.011; Mon, 1 Jun 2026
 13:32:21 +0000
Message-ID: <bf9bf060-f361-4333-a56b-d393e7738d28@oracle.com>
Date: Mon, 1 Jun 2026 19:02:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 030/272] Revert "ice: fix double-free of tx_buf skb"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194630.231806613@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260528194630.231806613@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0368.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::15) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA1PR10MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c27df3-d4a8-4329-4e24-08debfe23525
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	N4pu/41mk0qE+/la812+jgAWp5r0T1nkjFfu76KUZfg+6rD1zV7TQqqVgzTtGz0NZaa2vNb5yNXxzIYjcmQkPZoLT6wsLWafLdP3pMXom9/5a4araelcshZcoYp/naBp9p3fGBfJg0s81HpvKtlQJ+Snm+5KMdp8pIfPdRFhih0pgX1YBVr+tIayi8Zz8FWSu6+8Cvb11kQe9oij5fUo/01CLhuxg5bfhnCnLPuJUBN0YLP2WGEQx7VqAu8h8Uzw27Mkpw06nm4+yGupaBvdvfqePwNzaFbTrt10g63jJov9v2kMEYBwJV7I5K04BUfhXMqBl8BNEDN8L+DuDWaLBzjtK+U3pQNNqkBvBcCPeIM2j5KW11bQVB0zS6WeLMk1aHYgopo6LE67Ikxp7BpiDpM6CwyTAvsvKvVvar+1L7/+3R0yIZx9Y/SRWYepDUk5+DMOevd79+wgTu/p1OrrE1RyRhBXRYXAfROBSbD4InNAN20mu0JWvBhIcgZAMqqz9/EFXkp8+JTOzdyX4lBn6WLnQ0wF2gSR/aoDIxtL0XKXaX1aNUUSWozHrhNPOPXsjSSlDe1wSFvfrt8yJTIAY0xT0tooBDE9W47xGvo4sUPPlqhz4zRbovo/J2QicONym28PpPvMa3mCqxYtMT8DoVCyocRmXTfs8Nbp0JM/lHc3AcmjWjpQxu2sb0UQxXMiWx4dzcKofxo+OjFVymxV0g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm5HVytzNFdxZUs1blZNZ0JtL0dNTExkTDZJTjREZmpiMk1tTXBJK2VsUU5N?=
 =?utf-8?B?dTFjSzhTRnRGM3FSZW50by9VY2F6bzJ5YVBWY0Rna2VuMGl4bVFDejl3Y2RI?=
 =?utf-8?B?WVlIMjVXOEwraXlwdWgrRjhNeFh5cEhCQjVYTWFGWHBzZW5nRWo2K24vaUZS?=
 =?utf-8?B?K0VVRC95WFYrbndkUllFcDhnajdmUlpnTXRUZjZ0K3g1U2RxZ1RwS05BeW5u?=
 =?utf-8?B?UlYwSUZJeHNVV1UvNjh6KzhGelRYT3NmVXVEQmRhdmJvR1hGbTJTVlNWdmJS?=
 =?utf-8?B?dVRTZzFrY1p4RS85VU1ISDJtaGkyVk5SWjE4c1E2dTlVY3lVUlh6cUptVXVD?=
 =?utf-8?B?RVVrdnZ4c1l6UzlNSHBIRnhxTzUrZjh0S3dXUFo0WmlvOWlOMmM3T0Q4eU5W?=
 =?utf-8?B?aVhsZDZsVkJkTXh6Z3FRK3FlN0l4QWFOTG5aTXpxZWFadDdGUExnYnVVTCtT?=
 =?utf-8?B?SGppVW5ld21VeG5CSVJXektGa0NFRzdTalF5ZTEyVkJnUmxaT3BnUGlONGlY?=
 =?utf-8?B?V3paWXlrMDI0V21aSUtQMkVrb3NiUjl1Zm4vcmFyTGxaTS9URUEraGZkLzNy?=
 =?utf-8?B?T0VUazU2QnFGWjAzWjhqc25UTFZWWHJFOURQOStzZWV6d2lWdVFyeWtkWnRv?=
 =?utf-8?B?WjA1OWttQnF1UXdPU1VFeGhXMkgwcTVXWmVMaHZKdVBia0lDdFN2SmtmQVVk?=
 =?utf-8?B?Rm9Henc2TVJmNGgrVnFHNlpOdWx2THduM3MwUDhSMlhnd1RYYnVoZ2w3VHpP?=
 =?utf-8?B?Q3BpbGZaNzFhL291K3ZUV1JWMk8welEzdVRtT0l1THJsbXRIUFJkc1kvL2pw?=
 =?utf-8?B?bUt2MTE2Q3NaY1FVcWViS2hETWlhWlhmQ3hMbkNTRys5OHpMTUF6NGtoK0JJ?=
 =?utf-8?B?dmw3czMyV3h6MGRtYkRzMnVTa2RsaloyZ1RpcnFkSlRVbEliT01nRjZCNUJU?=
 =?utf-8?B?WEZNaTlMYTJHY0Fua2oxbjdFaEtwRE5FdGlHYmU3VW5iRGY2ZGdrUzQ0anVU?=
 =?utf-8?B?K0prczVtMTU2cm5iRFFtQ1FlM25UbU1aQWZXOVFTMFI0YkdJeVVicU1YUzZY?=
 =?utf-8?B?eStjakpheHhHc1ZzRTN6S2t3YVRmc0FrMUVxWEIvWHpYSmpOYUxlWXNxT001?=
 =?utf-8?B?YlQ4bWQ2MVNoR29qQzJFR1NSMzZLWnBlQ25HQ05QcUpnbHAvVCtBN0tqR1Jp?=
 =?utf-8?B?Tk5vckJ6cGNXNlNncXFNMmY2K0Y2N3l2SUxSYmFvZUZhdFB6MGYrNWJrMFV4?=
 =?utf-8?B?WDlURFVzK2lzc2pFYTBERXN1d1JBdldzQ3JvcW1CS3orZm1Xbjg1RzBWUmow?=
 =?utf-8?B?WGd5bGdYeFJyTFJrWmwydW9mRUFRKzZKTkI2UlBCMS9NT0xZdHBjOXNWMlhY?=
 =?utf-8?B?MnV3NXIwNHVja3h2RkZmM2lvZXo2RUJ4WjVYc0RTc2N3Ky84NmFwVkI5ODVx?=
 =?utf-8?B?SGJIQ0xjUXBBR3ZhTit5byt6a3lPTjdPMVhaamtpSVlYOUUxb0QwN2VKWmh6?=
 =?utf-8?B?MG1SVTdIWWJJS3IraDdhaGRFZWJtekF4M1pMV3RXN3VLSkFFRDU3bi95S1Vh?=
 =?utf-8?B?UVhBVmxMdHlocnJ5NkRhYnlocURNYWFKdWM3dzVyL21hU1Q1VC8vWE1JeGpM?=
 =?utf-8?B?cDQ1UCtGL240RUMwZCtXR1gyNTIrQjFKdHBzS0VWcWlwZDlBdi9TNWJhcEh5?=
 =?utf-8?B?ZXN2VVhab2pFRGtJcjF0eWRDRWtWWTBzU0FXaXkvTkp0Mis5U2RFdFVYS3Fo?=
 =?utf-8?B?SlhDMVJMemNKUGhJcyttQlFIYXZPUkJGaXBKK3RtbFQrWExTYXdLZmgwQU9r?=
 =?utf-8?B?YXU4OUhPb2Z5TkJiVjhyWnZxVmZsNVRwNk9ENWVidTRLR3ZpNVFpOGJ2MXNv?=
 =?utf-8?B?WGNPUzdyV0QwWkhqb1lvRDhDRXBYeC9RSFd4VWx2RVRhNHI2UDBBRUJuR1dm?=
 =?utf-8?B?amUvTy9uRkVQbUJCclJVQ0lHNU4wTzZlWHRyS0ZkaWluczhscFB3YUd1ZVk4?=
 =?utf-8?B?U3oxUStQR1VtS0x2RHBiWXpUYlVmZDl3RzV3Z0lYOU4rMlRvUHJIU2c1K285?=
 =?utf-8?B?TEtOOGEzNERTc1htckRHdVZ1bG5yUnVURkZ1amNMVko0R0xZZ0hPNVU0Y0d2?=
 =?utf-8?B?U2J5RG8vYUwwWFRsempEMnJpcy94d0pmT2pJSGllT3d2a0ZFMDYxSkY0dEZr?=
 =?utf-8?B?WlFHdUh4dWNhVkVIQWduUmlUODNuTlJVMEV3LzUzWmxacC80bDRQejRvbWdD?=
 =?utf-8?B?TlNFMjBud3o0WVd0QTdKRmI4QVZMcEtxcGR2T09FaEU2ajVYd3lDNlltalRK?=
 =?utf-8?B?TS8vY2loMGprbE91MDJhOTVhQytXQUNQOVhCT1Z5ZnJvNkJpT3k1NVRiVjF1?=
 =?utf-8?Q?9Aq2YQSrPtfP0AclqdEecZq7fnW0S0J7UwUxZ?=
X-Exchange-RoutingPolicyChecked:
	cPw8ULqTqGMHNKFxzlIS0psmLhgNRzCHS0W2whg7PCtHa868AQHipCzv2hNtINFiKrC9qAXK869hPP/1isBF+tNUC/7/S7A/ageC5u85ZYrr3q0IBptVvTj4skZ2j3k/fMy7tZCh5nSQo85yOkGB0xbxo4MR3FiFpA5HibQNwxSa7IcTM1sLV+lXOy4zV7Vs+pbdapupw1/v06YTsLDYP1pRA3rW/gl7+NzQZhJxEalIUlUbhdLFkFLpUDQ9+WWGqEMEMYXzQu8Kcie9nJ92H6VIwFbo1Rg+GgSefibOEvT1BMUwHKUQ8qfOPRZ2ejV1rWXIakuDVYL0v9ta1/Decg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fu/lgFLQDQyG9+uhpB4RbC1bKH3nKKEFj8YPFY59swtQ7NOTfwPqsJ3P/nwlNQ2llpl8e9Uy22DgwNp8kRZ6WXN/xTcfG6DteV6eGkUM4JnzgUnY8PDj1/WwAuchseelZ3PE28alYHd/ufO2nRkta8G9dW9Jo+YelnNTV72mvU3XYlCk69p10l+4XLq4dGh7uPqf61CxCRwco1zfq/Ei2GYOe0Q+NBeojNgn6NGLuLlxMZwdjEiIkeCFhkQXbGbG8zj6+i8zNh2O7Dk3MQXwLBNSzIzk50Hp1NOZemxq5/qJtDtNJRCQdoxljThE9vR9b4c5FyoaGriQkPC0o9bUy6+fr8ucrh6hs1wN6yXciQ0d5BGnrVaDnU9R3ngrPo3XGoPhHF8WY5es9x03POM7740VIzREIq2x2/tqOLwkNnyrw+8q+3GZMs6JXWGR5kfs7b9iiDvBpjGn0KSHPOuisM1jaOkXlaFffRAdgdkUu32/NXGy26+/woQWMJOgRq059v37yeAG10jeWculgOVlsacCuixC9b+Rf3eaWDIByMsYunGw5FtghvyEQCQfm0Dt30WnOaHirdXI54O2tlefK23dYjvwG/k9vRgUAG5eWyE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c27df3-d4a8-4329-4e24-08debfe23525
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 13:32:21.0049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8DBPTKo6asSUiFhSGofG5a7T8hvnj1M5JdrYwnrNK7a11Khr28H6TTrbs4ul7BQ0w1wq/oLCNDGcibsQMkUBvq65cLsW6Qz89kteMw6dom8wSc+bUTqfn8KAEXzYlm0i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606010135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEzNSBTYWx0ZWRfXxk51Dr5p5kyb
 wUWnD8NW0FxAMw2kyk46Zp0ZVzQDzZnxfN2MLEq6veIXUQlCiGigENP2Ro6AgoSwGtpaCiXo24I
 aEoxXcOGk8ZaxXPD7SOFwskB6jNd6ZaZziW1wkgl3cjcE4MIXKS7ONJveC026pl/N2ZzxBSF6Ad
 Y6TjUwkoDdzkxP9iw5ulfZ11BqQuUOCGtyrdb7cN11qbGz2vVJQjd9aA9vulHcAZasrhq700H98
 WqeNuRWIV2Tfm8+rfpdh1DeIRk4FiXswwJYxQhyxOj/3oh7o06wBO6bSv4PDW0N0elt5yLP6AzW
 lK4Tp3BQDJGCTa/RjZWmDxaAW9wka/CI9niGjJlw72O/5NVj7PGfkU7UuS4wxelmFitWRTl737z
 +5RQzIm8a/E2eXp9w8+Y/Y/xXHu8p64VBuvPDSC46XMk9YAbbwfateNP6GgOYNFtYn8hpW+1gnK
 OlMWxJdtyi6Bw/CeEMSnfBFOSgUh2CDF41kooFpw=
X-Proofpoint-GUID: xJ-RhdoTMCUYOrY4PNHtUw8DSpDENx9G
X-Proofpoint-ORIG-GUID: xJ-RhdoTMCUYOrY4PNHtUw8DSpDENx9G
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1d89e9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=1DHk3_p-HtSCqALZKLkA:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12303

Hi Sasha/Greg,

On 29/05/26 01:16, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> This reverts commit fd95ef8d0f6dbe2daa95d6488c9e0f8a95a7e048.
> 
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/ethernet/intel/ice/ice_txrx.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 48434a79869cb..08d1757f40888 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -2346,9 +2346,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
>   
>   	ice_trace(xmit_frame_ring, tx_ring, skb);
>   
> -	/* record the location of the first descriptor for this packet */
> -	first = &tx_ring->tx_buf[tx_ring->next_to_use];
> -
>   	count = ice_xmit_desc_count(skb);
>   	if (ice_chk_linearize(skb, count)) {
>   		if (__skb_linearize(skb))
> @@ -2374,6 +2371,8 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
>   
>   	offload.tx_ring = tx_ring;
>   
> +	/* record the location of the first descriptor for this packet */
> +	first = &tx_ring->tx_buf[tx_ring->next_to_use];
>   	first->skb = skb;
>   	first->type = ICE_TX_BUF_SKB;
>   	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
> @@ -2437,7 +2436,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
>   out_drop:
>   	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
>   	dev_kfree_skb_any(skb);
> -	first->type = ICE_TX_BUF_EMPTY;
>   	return NETDEV_TX_OK;
>   }


I ran an AI-assisted backport review and then checked this one against 
the 6.12.y tree.

I think this purely opens the issue again back, we need some sort of 
TODO list for tracking these backports that are reverted for now.

Issue goes back like this

That fix(what we are reverting) made ice_xmit_frame_ring() clear the TX 
buffer state on the drop path:

dev_kfree_skb_any(skb);
first->type = ICE_TX_BUF_EMPTY;

After the revert, first->skb is still recorded and first->type is still 
set to ICE_TX_BUF_SKB before ice_tso() / ice_tx_csum(), but the error 
path now only frees the skb and returns.

Later ice_clean_tx_ring() -> ice_unmap_and_free_tx_buf() still treats
ICE_TX_BUF_SKB as owning a live skb and frees tx_buf->skb.

So its again the same issue coming back to stable.

I looked up the reason for the revert and the reason for the revert is 
we took a prerequisite for this which doesn't fit will so to revert the 
prerequisite we reverted this fix as well, I think we need adapted patch 
to older stable trees.

https://lore.kernel.org/all/20260527-agent5-item003-ice@kernel.org/

Nothing to do now but I think we need to add some sort TODO-backports 
list in stable-queue , thoughts ?

thanks,
Harshit


>   

