Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DE337F00D;
	Tue,  8 Sep 2026 05:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788846808; cv=fail; b=sSZltrtoMZVC6/BWxa+g4kJVAN560S/p3qa5ZYIoQ9z/0RpCC37f57qlV1qVz7Oou5NmQbxDHzesghAotRR9IbJbFAN2YxxE2o+i12vRUtNYTX8ZI5bsfm5/1PYAS6/s8ACn84tCmFU/WlDYpCg4B8L6Gq9BmAeEK6ngF43ibzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788846808; c=relaxed/simple;
	bh=WmB+K4qpA4fv2n0aC3pvwarfWT/+YAZafv008mol8FY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JSybRqm4CsezWioh7oRAO6oPrurUpjH7FSENUfQyfdYOEwnPiFPBivbepVGYAcG+giK2MlSHmu6NZDIJxpQaI2KhBHwltxUwy3GRwuYgv5tCFPRFqtOdZcTXKLh/BZSDuR5RgMPAn2zp43qrHzmyJrct9T9r/npGn4e9HQGlvhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NAOugkRZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CCSVkqQw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NAOugkRZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CCSVkqQw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880lJAC2676467;
	Tue, 8 Sep 2026 05:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=608iw3vp0DS0MF5xtdXpBt/0FkO5SYy9s8Jeis92xvU=; b=
	NAOugkRZ8uJeI/Rzzc9bKP4NcXrUuTIcSkSspRInnSwlEpi/f6iiD9gva6FCMqNI
	otVuOIdxytUPYsDwCdli+2nzZpgZaptXE9CbPEpYYBFA3nWuc9xq5OUcnx8DtULN
	W/mS91xhHesDXBX4j/qCbXx8PpJsZmV1G+LwtPgp0PGOwQrhjncmra1U8lUW29Z5
	YZTqgAeeUWeQMeO3aWsm5P7Mkwqe9JWmrPCABX1SnfQSaOlBwon+KPQ/tbFhxeWD
	D9kUfUaymv4GduY9MvuVc+QT1VH3LVJojtEpScMUwlbQXGy9z5mKmXvBj5PCrQ5b
	KBJyyS8Y4I3VpMW7ctQrbA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbgvtnmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Sep 2026 05:53:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6885oQ4J001141;
	Tue, 8 Sep 2026 05:53:19 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh753xqr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 08 Sep 2026 05:53:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IqW/HtEZH1bT2jIec5ojstvu7aw5BluD7r2KbGy0pM8Lob3dzlAjVRqy8qQrQnSVXahPaw2631cr1TpvTbUjkZE7BdwcBl0NElL05mBYXGdQHAesVb/oBKJSprEyRMfcgrnhog11KUtOTTPYEJ5WV3TvmefCH5+bpQUjpz3BPW56CyQAG36tvhJvpJ5+C7z2tVEdcbWzpr/CpdxSLGGx+JctjdP7V1vhiXedxHqXCREhcLwU6sKXEiIX5g/lEYU52zBIuvIazNXtWQgfQTBNYYxjLCCVHEVOE2aNT74mDP5PUA7yLlql4U39J2britQEX55y0Zhc9qwjbOEsfZi4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=608iw3vp0DS0MF5xtdXpBt/0FkO5SYy9s8Jeis92xvU=;
 b=Si9sPWM1IcmpRUQ23ClAtctu7xynYO6rFQtXmuvQ8izL9BV/akn5lzB+dM/480MT904zJElbxgejWhsXNrERNtbAzSwHJ+/KQocgElHfLvsCax3kB5OfChcnQ9IeV2CBLeclwJa1gHqXXdKsvDQ/6psMP1Vob/+0LXpM+45k+K+e1PoCr1bE521y/XhNnkebFaz69H6DWwi6rdy6Lxdt4xVeywRjJ/m6yaQ3qZSya49yexDVBGrxv408nobVoKPfa7m3cl8cCe9v5myQD3A09Sv+JrRjG/owPFV0uPsbSkhdP2GVwVbLtKIoNdekr+w4CIaH9RVPBvZDEsoywCNo9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=608iw3vp0DS0MF5xtdXpBt/0FkO5SYy9s8Jeis92xvU=;
 b=CCSVkqQwOsz09ErICUR8aoWATlwQJDHA0+Mryih8kx0AjzHv2Z+An8TaQ3thqGJl4xiBinQnTfPCuGU27ETDA1KpMSHQwlCAIyTwiZO4Uow7JULcx5mJ+UCoajqISymZjiE1evVwHpYiZIN2WO3QWJ19OJVhG5IxUY3KLFQ40pg=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH0PR10MB7463.namprd10.prod.outlook.com (2603:10b6:610:181::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Tue, 8 Sep 2026
 05:53:14 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 05:53:14 +0000
Message-ID: <9a3bb90e-b83e-4ed7-8ed6-a8ab9d85f243@oracle.com>
Date: Tue, 8 Sep 2026 11:23:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 364/456] firmware: stratix10-svc: fix memory leaks
 and list corruption bugs
To: "NG, TZE YEE" <tze.yee.ng@altera.com>, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>
References: <f3b734d9-d286-42d6-b332-e4889e7bcde3@oracle.com>
 <20260830195300.0009-1-sashal@kernel.org>
 <34cef7ad-8730-4a49-b6f4-8307adc1e36f@altera.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <34cef7ad-8730-4a49-b6f4-8307adc1e36f@altera.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PNYPR01CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2b7::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH0PR10MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: b73de926-d75d-45d9-084b-08df0d6d792f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|4143699003|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	swp781qzizEYZeGNVgBqoUGWeb80F8QcuaGsTS73dKHh1owGBAyfq1VU0PRhugc3Gsrrq9ZqyepolhyXUL7BTE6CaiK0DrRw79BChj9yeK9ecxOkZOkHS/vS3IL1VXuhtTX5eesUHnc2CDTMoGqKe6VjWII4cSrwlUz9qDhNnm3zXrWEJI83oJMpd+N7AuAgvCwc8x5ktk7P8BBTVqyIDOnMynFk7p88m7WDw/zt/9OQyqiq3EA8i3grqeOTWCgafOMVNOkY1xilw8VEAVZKcHei/96zbcQdt3D4ZzelNmDhsFHonKI+1MtySYaAFk/iPzcr/bSgiG0yIP3HQzpQEKXVvL5ivTUBltigNSa3CVxY9HcvLlPdjC0TVUOZyhJTc8NS+SYkX4tRIMA0iMkUFd/aPqKvwHrrdaASGmIDeViNvmNsS6VtZvtb45J78LTGBBMu/2HUyWniq1TpH2QrxxzrSpOMif58hxi7+ii/kw3xk25gYGQwP4PeXHX8uFu0a5EHsbtUdwXIXx0OhYArU9DMC3kMBknYiE1lWYCdtYBqv9eM56FxQAFT1mtP5XAtWjlRZoaV9UuZs33W5nvzgv2Dio56NYUgs5whD9PT5XEa1eaE1B140N8XpiE5x7wZeML50YtGh5CSPw+oNAPUWyd2DOE3QSVlMHlh9aG4reE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWlZb0FWM1c5L3VpKzZPVmxzb0NSN0ZoNm1abURBYytXWW9ta3hLUFAveEQr?=
 =?utf-8?B?MDM1RTV2UmdnaE5yYVZNQnI0MGRsN3FvcmFWaTVIOEpxVmc4Z2RIMDRJRkpW?=
 =?utf-8?B?VFhYVXV0clF1clZ6N1NNM09ISlhMZ0t3alNJaklVN3lGTDNKbXVPYmRFT3hz?=
 =?utf-8?B?aWRrOXNhdVlIT1lxUjIwVXB5c1FZc0NNZ1VWM1B2eU83MkRtaThPSGFDNDht?=
 =?utf-8?B?d3pXQmNIQzVzbWdRWkRmNW1wSXN6TXFiekNIRlMrTDM1WkpOdFJiTkFPTFAv?=
 =?utf-8?B?alhHb2QvU3ppUFgyQSsyTlp3eDRjWFRnQit3RVVtR2JnRWtMNXRqaS83TnIr?=
 =?utf-8?B?dUNwTWVSYkg4dGxSNFhKQ2JhZzJveElaeVhibUMwdlNCMjcySWFHVnJ4Umph?=
 =?utf-8?B?RmFUZEsvbk9XNjFpd3FkU2JkRzFaRldRUTB3NjhlVmFQZWJOSXZTclpYR2oz?=
 =?utf-8?B?bStkU3lweGNXQkh4SFYvaUFONWo3WVk3Lzhpb2VlNDZzUXhHQWdyQWFKRTh5?=
 =?utf-8?B?cnhjQ2syajlQUFF3UkRhTE1lZWhHNmVtK3J0eTdHNTJOVkhBSkwra3YzdlVW?=
 =?utf-8?B?Z1l5dVQwdno3Ry83U2xMRFBjaUpqdytTQmYvbmZBWU9rY3VMcFZmTXRvQ3dD?=
 =?utf-8?B?U2FEN1ZGM0YxTkFRVnZiVHFBTUtvSlBaUlY0SWREallGMHRnRVVQdVVnWnZY?=
 =?utf-8?B?QnpPTmxEZ3ZlRTROYy9QcmtMZ0FhT3ZjQ2ttZUJydFFpa0NTQldMNmhIUlBB?=
 =?utf-8?B?OXNNWmRkREFaTnhlOEhzby9XNHhRSUZ5Yk5TdHNwVFh2a1pRQXduN2NTVzBT?=
 =?utf-8?B?RWhpbTVwTFlGNitrZE1rck9vMHFiNzB6QXJpdlZCRWFLZXI4ZWszMWZXU0Vk?=
 =?utf-8?B?R3RyenQrSnhLSVhtUkZabGMwNEZmUElBWmI4VGFVRUNUYzBodEl6MTBVb05X?=
 =?utf-8?B?MDdPcWRCSmdHREg4a1NNSVpkVDZFYXBtTlZFSDMzdmJ6VkRvTVRZcXVDSWFM?=
 =?utf-8?B?TmhWRFNodGJmbnI3aDNiaGlGN05qZ2RsQWhIbTN4RXpLcktjK0hSN01Kc1Zo?=
 =?utf-8?B?NklockJmTFpKNWNON1gwMEJMSzNwakJVaVNYV1ZRSXA3NTIvQjM4M2RlZ3JJ?=
 =?utf-8?B?M0x3VXhWL2txQlVEN2ZNRVhwUGsrU2MxQUxFZUZqZWEvM3FPUjVic01YS0tP?=
 =?utf-8?B?bjFBL05zaC9jazVOaFYwdXFnTnNXQiszakxFZy9CU2NKaUlZaFZFWFJ0SGQ4?=
 =?utf-8?B?UkljaGFPRFdJNDdSZEJCNFdoRlFUa3ZCNnJ4S1NSaHVkK0dXeU93NDNvNEtt?=
 =?utf-8?B?OEE5cmFtU2FWM1BMMnVEMWJWVmZ4ckJZaUtSOTVUZi9hcTJXaUwrVjFZZ2U0?=
 =?utf-8?B?MngwUjFNckk5MkpHdHVTUzVKbHk4VUZNd28ycDRjdkNQcWRCRE42VzlZVGFU?=
 =?utf-8?B?R3M0ZVNSc1JmZ3lMdEVqcGdKNmk1M0VJYzFvelZZZFRSd0tObDBoQ3loczJ1?=
 =?utf-8?B?UDdWelJUUmkzR2RieXk5bjMydmNyUGgwdHEvV0VCM00xdStNS1k0TC9FVm01?=
 =?utf-8?B?ZVFOUCtIUi93MHRxSDU4Ynl4WmpPaWZsYWRUdkc2Ukh2eFFjcWVDTUYrUkw5?=
 =?utf-8?B?K0dBVFdOcnJzcmlpeUlDZ0dvS2F3TTRNQTg1bHhuNWg3OHpZa0lvcDNjZFZI?=
 =?utf-8?B?cUtzOTEwWDFXQ2d5SE10T2h0ZXRBa1dieDhDNFBzUis4OE4ydzF2eGVoL1RN?=
 =?utf-8?B?enhuVXlzbVdabzcvYkhjdENrNjJ5ejZ0ZFVGVTNOckF6ZkovbkUyYm5TNElS?=
 =?utf-8?B?QU9yV091Z0pNUkR3aTJia1pKWG53ZzVqcHZkQ1JpN3plRFVwQ1JudGxPM284?=
 =?utf-8?B?T3RUQXNHYTUxZ0YzN1FOd00yamJMNmJ3ZStCMzYzZE1JOGwyK2dCc3ZNYmNm?=
 =?utf-8?B?WktYK3h1N2JnRytIYkxLTno5MTN3UlMySS9qaUJhMVlJd0lvWk5DM1VjcC9n?=
 =?utf-8?B?NU80OHZuL2J1Qys1R1JqeGdpQkdnTGJLSmtRM0NteUQ1ZlBtN1VjbWJVbFVE?=
 =?utf-8?B?eG1mdVlQZGNLQUZpbE9TVWJ4UWFlZDN2QjdHSjhSYm9paXV4eHRadXRXMnlp?=
 =?utf-8?B?VkNLbXVMZjBNMjVaSVFLOURSRERDYkRUaEdrMzU5bG5zQ3p2eUladUg2L0VB?=
 =?utf-8?B?aXMwRXlITXU3WFJCVUpGdUJkbmdHMDh6a1JaazNsdFZVU0dTUnhWcjR5OUZm?=
 =?utf-8?B?WWg2WU1IMWI0dWQzVVVTV1hTNDZDS1pJMkJLZUhIQUxiZ0xmcFdQdlRPaml0?=
 =?utf-8?B?dm5UOStPK0ZNWWhPTjVYekxsTUp2SmtRam4wRTdZN3RkNGFvaGdLTlZRV05I?=
 =?utf-8?Q?B0QgAQk8xpOG705YoQ5pRpCV/+lYrpqXb76xc?=
X-Exchange-RoutingPolicyChecked:
	Lwdg16Z0kCQA3veUryaMFEHlAQrMnmSVmpTTiTF6lbNCapWW93a+uQoZRdFpYAi7eVSNeh+UYVmsLiJ9wXN8e+qD4k8EX0ef0Dnnx+Aq0brxdSDJh/DHioZYsRsiJFHU1Q1NCthRw1F6IWGKnasKad3jitAcgHXjEOmnbqL45cogFDRicpISHe2vnhMVLYabp4riOMqYOXYISEpuh3pGFs8a4uEVsqqQrEUBpN/l+UpBNBulgF3L1h/nfZjXE0rjfzBQhxNirJER7V3fAK16Pj1ENRGDVtng52zzH70nM48MOlVLqKg7HZ+iy+jgy2LoW+f0FDcbJwv1aVictFYXKg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6G1Gezf/qNmF7MQfJ3FIX60z7B/t9Hyg54AguX93Kfc7S5AYBa/4edbLPSM6gyOSPL66hp8/5divz74WDBYHXOt7Gnkwsf2zUoqBlLjOGTBG+rI5AsOc5oUVdphGHQL0H13FwDvhXvfTNj2BpFSxVnewwOdMqt/c8CYNU5s73vUKCITfwTNRvpeHXhxuiVhMDzMm/5ar4PTB1HeFTTyJ+JkFhU+cYH+MqcE9asEY3Z4Gy8P5O5xloD+spfhhzqBsmLkm+X+FLKJP0dtaHTojLa2B43pjAI+rmoeAJbKRTHFJvFp2HXTgedfool1fO31SMVghpFrsKmglAqbsemfq/pR0OsN4YsvXpCC4TtGqqb2DAL4nnRAncutF8At4suB96V4GiGZu22fgJUOh4Aqm8/qPn7Qs7vfRC0XyWXs6+KY++P28BlmnLxXcF2+efsz/0dldGalRM0mndKU8mwGSkTUWHMD4yxowNmDzKt3pzqSF38pbDZbi5+5L9RpT+OkeeMR13HFnVhwOSGSJa2ldspXRv8o6XfStlNXAbmeFpQf9L6eHsxtSxr6RVtvz5DIswO6z41h/mCTh0xI0MsKEyMEp3a9NP/4MC/Ioxm75aGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b73de926-d75d-45d9-084b-08df0d6d792f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 05:53:14.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K93KYzBiCX2tFF2H3h5lgMUhaVrN+tyDBX9utRwRHjlDBLF6SvH71X9GCLgX2Ba9Mc8Z/mUSHPy4EiWcBbUf4hrGaI9Mz9zBRVaM6sQQn+11kyk51yKtplENm+4IJKHc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7463
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_07,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609080061
X-Proofpoint-ORIG-GUID: dtt-1otwEBKaWfOdP5Q5aIDNNvD6qJl-
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDA2MiBTYWx0ZWRfXx+whm0E2PWG+
 wfkHCYEzxKnWbascMmpL4kTnvDvHo8K1b54wdKEglwyFWxC0TcpP3N+RwbqEe2+DHSj85y+dfHb
 azUKTnXVM5DjrkeeEgd6dIXYi9MfsFGgsOJuyL49iNpQsYIUNZ8E
X-Proofpoint-GUID: dtt-1otwEBKaWfOdP5Q5aIDNNvD6qJl-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDA2MiBTYWx0ZWRfX3Me4UiC71hZy
 5xcgAao7r+SWLvPAFSzW4yKLNkXEkMS3guj/BvBv4nRRNrBXQi8yGBzVHR1qhKOcwJip1vCiriB
 +eMH42O48yWZ08IuO4UfGxZf4F7aByCSRWLjKsdb+B0hMDSLf+PFJtuQZValMlS33tftQp5Y1l+
 ANLQ9myOCBn//Hiq56EiH7QSoceLFHxBXMlhYjpIiaPuhjkOUkLTHYGq7FUgjTk2m/gPsVBf9dm
 xiYEedzqf8wI6dQj9YqMTYvNhJuj+k/7CdGC3Ffcv87kuY7hnFhxwAiiTMdFx83CV6Oqa7H9Ydg
 4l5M1br8A8n6vH6V1CIFCkvWZ3Ajg20WWyWrJtrhqlw1pyA5u457Bx80Y9yO7v4ZpBOKM+Kgg0c
 5KugEq7Tady5LlcVXqcJkI4ZLztz4PUCORwyDW9JDdMPiTN18pIvhYMoV3/UQcpHa1USjeeG83s
 D5aKRSmhEU71lpta1xWqgza7jlSKtsJFmKQS1Kn4=
X-Authority-Analysis: v=2.4 cv=Td6mcxQh c=1 sm=1 tr=0 ts=6a9fa2cf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yBYpec10AAAA:8 a=7YiEF4elyewTtQ0QywcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zbxmTX4fiVD2UiCe4Dha:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108



On 08/09/26 11:16 am, NG, TZE YEE wrote:
> 
> 
> On 31/8/2026 9:39 am, Sasha Levin wrote:
>>> Before upstream 9119ceb76e98, commit
>>> 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ("firmware: stratix10-svc: Add
>>> mutex in stratix10 memory management") added a shared mutex around all
>>> four svc_data_mem access paths
>>
>> I agree. A tested backport is more than welcome :)
>>
> Hi Sasha, Harshit,
> 
> Agreed to apply this to 5.1.5y:
> 
>    firmware: stratix10-svc: Add mutex in stratix10 memory management
>    [ upstream commit 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ]
> 
> Tested on an Intel Stratix 10 SoC Dev Kit (arm64, 4x Cortex-A53),
> v5.15.220, with KASAN, DEBUG_LIST, DEBUG_MUTEXES and DEBUG_ATOMIC_SLEEP
> enabled.
> 
> 1) FPGA reconfiguration in a loop, concurrently with 4 RSU sysfs reader
> loops (concurrent list_add/list_del vs. list traversal on
> svc_data_mem). Ran clean. No KASAN reports, no DEBUG_LIST corruption, no 
> mutex/atomic-sleep warnings.
> 
> 2) A stress module with 8 kthreads concurrently calling 
> stratix10_svc_allocate_memory()/free_memory(), freeing buffers from a
> different thread than allocated them (the multi-client case this patch
> targets). Over ~1.6M alloc + ~1.6M free cycles, no KASAN / DEBUG_LIST / 
> mutex splats, balanced (leaked=0), pool never exhausted.
> 
> No regressions or locking issues seen.
> 
> I will send this as a backport to stable@vger.kernel.org as a separate
> patch with the Tested-by below; let me know if you prefer to take it
> directly.


Thanks for the great work!!

regards,
Harshit

> 
> Tested-by: Tze Yee Ng <tze.yee.ng@altera.com>
> 
> Thanks,
> Tze Yee
> 

