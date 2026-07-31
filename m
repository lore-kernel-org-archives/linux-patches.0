Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0DF4398EB;
	Fri, 31 Jul 2026 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512187; cv=fail; b=ELhi1Yep7q2kilk7bICEFengRKE3Z2cOyd4fHAdIOy34HPz5QngS5AD0bOMrLLObi49kEUJiGfysvnlLZGtS6zYf3Mqjv8rmAWPSbCCgU22VootzIYEQckNhAyveyAlNa9hOPpkuWrSRnEmmypMbcN+YCK4IXMDtU3Rwbu7JAfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512187; c=relaxed/simple;
	bh=hh5MZmBIG4RODIuKgg5I8XSzGD66rFmMuoNA7Y/J6rk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ou9eJItBnwiDBGl8cg/ORLFe44NiMiZlRS7k8hq349IedsA8lU1H17cbpW9OhG9Ez4MZiqJhpP6tHrSnbmgUcO0ZUpsVoSa6Kks975Psc0TvhNGp7Hg5JiqoK6iRICrCetk5mnS/Z6WTjJaquJQqLtNGl/AaY9HvaawSwpAVUnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KiN1m4sy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K5OsgmXA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KiN1m4sy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K5OsgmXA"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VDDaA03814492;
	Fri, 31 Jul 2026 15:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p36H43aS165oJ69AUFdBUhBYJqeDKW9kIdhQprs3HU8=; b=
	KiN1m4syGVJAMtktggIqA7QxOF5Fz8X2QLFlqCJPdAKQEYpsCADfS0rI0Nq7g3mZ
	8B7kmchYU7G/wv0jCiJou3OPyjzYJEgcgM1le5Jnyf7jflcCOjByl8T3d2QosyvJ
	DXzs0Eb8mEixJhwLzCSEz0nDj5PuYCe6LuSlK7i8w1u9CjAVuUTfVTyO1IGm5ipU
	J3GfpK0E5dkEjXdCplQilPROdaWyZKhfbrd/yIrQ2q24/wPu8ew829+u2ee6cZC3
	K0FQ7g2+GcWxUFArWI5bXcWaVVIugRj9sGgiNgSyqoQIwJQrIBBV4m1GhMn0MaY4
	A+s6KBMv4ioNCyqi9yVjyA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5y2sdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 15:36:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66VFZbHA038319;
	Fri, 31 Jul 2026 15:36:20 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6tp5wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 15:36:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SHm7IsuK2d7AppevGdPJaZaCDO5CNpadL+2cAEQSjDzVEjPjlDmjkX40SlP6DDySM3d/MZjpjK3LRn5jB0JfMT0Mro0syct/p/wQL2um7gUXPuuMMyZrCxPAxhlNE74Ag+z8e8RrXUpqyCa+CVe88GgmXGRXa0icZXDKVvGlGZuvzZeZ62+4PjryGUdB8ayRtl5AJpU42bcmxiQeWihGCTzBUXFiwaxuov79BBFCOPAOuOsbuX1BT25+b6FnGx7jDmZSNSI//aB+FKK2yV5GbGxtZMGX7s9PHCOI7bhKZSAKlkJFaWBKy+4+WPw3nSQVo0tomjdrvtYf8FpRZtuEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p36H43aS165oJ69AUFdBUhBYJqeDKW9kIdhQprs3HU8=;
 b=AFYnEr/tCJmlIgEiYPwa4jNxL6VaFKHAa7jdZMQlvSV3VljYOqeeV0CQA32QxWzy85tigjoGpdUHFEPQwNm2Vu48s3oUeSsRu8siYF0WL3+Ht0dKNwEvmgqSUmGqYmWoamw+1XkCVJzg3QH8n3BTZyezMkaJFBK5oyxqPMI3yQ1pGeUc4Se/lD3iBtWfvflLj4VYvP7lhlzSIhhjYwIDfdxXJOzrjoGNm6X/AXjgVHJoA6wLLh/BLVEQ2lw/j8CScBZFdAN8cvhvMQqeJnxauF+DoQQstZU5ssAWtkBiCT+mtblkVxakZQk9Oq/Ng5NqFArquddzTKSPpZIyFl2S8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p36H43aS165oJ69AUFdBUhBYJqeDKW9kIdhQprs3HU8=;
 b=K5OsgmXAq1mXub14ODNe53FDrY809xXIg763vPIEcO2kbfJPSnhfv5/RP25A1tC/vvA3ggMH4hrAntEJTN26MsO/zPMchhWu0nOltj3KE4KTOdfNM94hi8V/kbpFku8BOun8cxJnGgOPdQpJvindw3YPDRcFfbojpe96dF5RMkA=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS6PR10MB997849.namprd10.prod.outlook.com (2603:10b6:8:464::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 15:36:17 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 15:36:17 +0000
Message-ID: <82f9ac55-cbe8-48b3-8014-c590ce84e45b@oracle.com>
Date: Fri, 31 Jul 2026 21:06:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 419/602] selftests/ftrace: Reset triggers at top
 level before instance loop
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141444.770360697@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260730141444.770360697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0018.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::32) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS6PR10MB997849:EE_
X-MS-Office365-Filtering-Correlation-Id: 8443a7ea-e2de-4030-cc0e-08deef197637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|4143699003|5023799004|56012099006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	fqpv3rQqlXPVpcc7oncaDMmHLM7qcfNTJKxKqpvHprxf2+Ejb3IxYxFkvOG1/aG3FkIuSZaH3xZJIXOheb5f9d9nW+cMhER+3noJBO5Xie0K9HTekTMCWrCDds4gWgNW742acXCRew2lG7tdd6JDs7t0fnp/Uw7EDXxZjUQ9zzy3M7joucfNEvv7uUsDWdHtP6uZbJFplx2qoyP6n5iRS5aAdr9qxkr0Dwdtt4Xnqvfq3lF6lJpzw/TMFz8zYrJBLHr+0ipZUinlSuBybrz11OIoW7vw/ZXqDGZKxFpo48VuSEcOmU0RjCxAe87P8sNzDiriMnhD2bdtSgYj40rMS40LRPlpPki4dV45diB2sfP7NI6GBlga2PHrSk1cJGGjcvqpVmGGasGuB5dMKeL7fshNb1mY7+VsaVmrU24413C7cveQ0fqSc7XUcDGmLX/Hvu+1Rz23b2NYnYja0Ct+envPqIA0X35B/GchkagwXzmUdVmX8JDDtb4jAsCcArAOFbZEdvoxkpG5LOZoHUEfl+aUlJZlf7hO4wq2LnkwFAuzATOcGmZWGBY0xQW6yCKdghgdiXR+PvaM9dsCYdZKjmXLOQSAwu/02+T8dCu4JphnPGFmdOIZ+24Uu3UCHX1k
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(4143699003)(5023799004)(56012099006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFUycnBZTTN4blRlOFpwM1htdjV6MHUwZGxFa0R4U1pCMzBEeDV5N1hPQXFa?=
 =?utf-8?B?YTdDQTl4OEdvLzJCb3Vaampnelc3TUt6MDlQYmMvVFhoOXp6dE41ZXF4K1p3?=
 =?utf-8?B?c0xwV1FDR3VNMk9lUVJ0dGl1OWl5L3ZoU1pCR3laMWVuc09yV3BhZTlTd1hk?=
 =?utf-8?B?K3FkZ1JrbkxaelRRVEZHdGxndmpvZGxFVnpHT2psS1hqbXphMS9JdmIyRWxx?=
 =?utf-8?B?cVp4UUJSYU50cWFub0NWeWZKY29mSkFoVENzbTdCVmhGNHZrNUNLSGVNajJZ?=
 =?utf-8?B?T2N3MFlRME5uQUhBK01taTBpVElGZDJZemx3MG9lc3ZMNzdHM0tSVndTcWFy?=
 =?utf-8?B?Mm1PTzArY1EySUd5UGliVkJNOThGZk1wV1p4SjltaEFvSWFJTC8vV2dPNVVX?=
 =?utf-8?B?NFpheVd3VjlubjBYc2xXUHpIT0s2dnFpT0pVcjQ5dW9Pa0t1eHQvdWF3RzBS?=
 =?utf-8?B?d3pDbGFRV0Z3RWRXNDVmblJBbHJjY04yUEplay96LzU2akx6L240V2prWHpI?=
 =?utf-8?B?ZnVWTWw5LzAxaXB1bkg4Y21YcStFemxLL29SSVVwMnFJeDBXTVU1eHJORE1F?=
 =?utf-8?B?amlmNlpHZDRkektNUmhRU0Q3U2xhOTFxaWVzc3R5ejBYV2llaitva05uaG1m?=
 =?utf-8?B?OGsvNlRvc01zanNsZitMbzRia3VDY05BVUN2QWlrbzFOZkpZVEQ1d1ZLRklF?=
 =?utf-8?B?SVZNaDBEelpFQUtiUXhLUHNVTFRmaHFUdGw2b1M5QVRFWXVBYTBnN2xRMits?=
 =?utf-8?B?T1p6NlFQZ2pYRWFDblJPMmtVc0RSUkZoRGlmRlVxc1owOGpCQUlzcXN1dGJn?=
 =?utf-8?B?enZsOWFPRFZiSW9VUnpzY3ZTM0dreTVxQ1FwdDFhczRrUHFTM01iQTF4S1B2?=
 =?utf-8?B?Z0Q2OXE0Nk1CeUNwb1hNS3RhUmJsdzdCV3BzSnNiSHdzT1RwSnpMYW9kdStV?=
 =?utf-8?B?eUt1VWNlNElEdG1RTFBqOEZURFlYS25SV0lVK2VvamtTTGgvMGp4SDZMTjNK?=
 =?utf-8?B?eVJHQndyelhTcHRSQUZpTEJwT09YQUNaZEZhRXJXMWExbytTNWZKSEhmY1Uw?=
 =?utf-8?B?cGVQSVZLNi9hcnViSWlqZGRjTEF2U2F1ZHdRcEN6UW9hRE9hTCsrNmUzc2Vp?=
 =?utf-8?B?UFRRUlJIQ1U5RmRmaEhIaHNhQ0dQeUtPMW9hYVlIbWJKcThyVmcxTHhFa2Zz?=
 =?utf-8?B?QnNnSy9LblJZNExCbUQ3dGpyaVV3T29UUTZXQlpBS3UwRW5US3E0WWkrZW9m?=
 =?utf-8?B?R2JOQVZjc1NvMlFHNzFRUUpHd2lQajFaVDBpSkp6VGs5NzRtOThLUXBVV1Rp?=
 =?utf-8?B?R0k3M25UUGc2MkpWbElQdDNBVTN6Nnk1MVZPclk2K04rbzFBSGN2VlZuMmV3?=
 =?utf-8?B?d251aU5MN3ZkTFljODljazM0Vlp1elhybC9sVHdUQ0JyRVFkM0RQSGt6OEUz?=
 =?utf-8?B?aENDVlVIVkwrczBFZjVxVTRTYnFueGpYN3I4QVpkOUpSMlJVZXVLTTBMblY5?=
 =?utf-8?B?aGdFeHdOYTlYeHI0aG9GSVFlNFBvZ243ZmxRbkVJUzIvVU8yRkwzdUNqOWtq?=
 =?utf-8?B?Tjl4UGpoUkNQaTgwVm5JWXcwajQ2d096c2tkYUw0b1EyQ1BMdlBkbkFsUGto?=
 =?utf-8?B?MkxzbnMvR2k3VzV1N1RidTlLcjl1bWZRNE5DNE40K0s4RlBuRExRajY0Tm0r?=
 =?utf-8?B?WEtlZWg4eklFYWhpUFNTUkhtQ3BuZFlPb0JnS1VwRWwyUVVramJPYURHSG5K?=
 =?utf-8?B?bTVDcERoak5SSTQ5d0RXY2FyaXZMaFpPOUFRUUhEYzJnK29ESlVNU3F3Vjll?=
 =?utf-8?B?T0xVN0szT0tGYlU0WEFiSWx0SDFsZ3YyZXFDNUg2YzFJc2NqQklYUHdzVnJT?=
 =?utf-8?B?L0t2dWs2ZUZmbGxCeHQvbFR5aERjTGxXUWhYcmF2dWdkNWdTOHRHYTV0Nkd1?=
 =?utf-8?B?Z2pzMEt5c0cxWG9IQ2VjVXZPcmw5OENBV1M0bDZTeDJROFBFZW94Rjg0bnZt?=
 =?utf-8?B?WHJVeDZSS2UrWk1KdnBiV0xwUXdpb2czRktyNXp6eit6WlF5Y0tqeU9mWWNs?=
 =?utf-8?B?Z2hQVWgxUm1RVXNJUERlekpucTI4cjM1RlVqTGhFbHhvTnRwOTVGeWlmU2FB?=
 =?utf-8?B?NjFya0Zrc0pyQUVISFZEMWJBVklNTlJ1Z05lV2xIeVZwT1Vjd3MvYVR3UFFQ?=
 =?utf-8?B?dlVWeEdPTHFXdFRKZHFTTk9tbjBVRHk2SHhlb01qTFJjVW42Yk5lOFdCUERU?=
 =?utf-8?B?cUdGS1pQaHlhOW9NeitaR3QvQjhSNlUzOGJHdHRFUHY0bjZMdXVBbXh0L01R?=
 =?utf-8?B?c05YQ2RCd042M1NxTmltaWJ2UXhMMXFCdTcwMHhrSEdKSVlaWEE4UXZzd1dI?=
 =?utf-8?Q?JD7hGo9hijRxHR9SGS7h6dYQEaxocf01ClfOJ?=
X-Exchange-RoutingPolicyChecked:
	j/4vubbJv7Qiz1WJXYR2DTEXIBBpISlE/idBgL4moQ0BVaxqg9f2C/B0zIkBvGiWdFNIh0frjbpHOHR6xuZrTa2zwqTU0z5Et7M2CNX40ytNqi1ntenf6MPL6+WocP21Qbd6zRV1wg/KPqdb7FAZxxTusxJJTNNzsiK70Xt2IQdOkkiGKoxvxwX6aIFls9kI8Ym1VYMf6QLQtUCZs6tSJlZ4SPUES6G4etLn4jNqmhSQfx9hzGYTloRTwqVEfqP6G7ou7ENZwGL3YNBgv5a3qcbz8CEQ2hAkRp/AUpjCzFhbyiFTNHPKmvN8dUE88/1meRr73IFQYWeUxMDJW7GR/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Aol9ZlhIBgKbZQyyLAZg8PZE6SCO42HpRohwrgfccR8YnQZvMbkljW6nr3IuS0USMAeifmFIr2jIVVEHP0Oame0D8MRwW3zgoTJw/ANrCzyoysFTefgQ+L1Q47tPaY/oMsSJBFXsRC1c/Wfm7iMH26b5oBVqYAPRTM3ltDlzii49uFozi2GhU/qfT+NnvjARI0oNIKa5WILAXz9UgXjLZrrMBicm0xOsqI4GixL+hM08KFQwzxuQJa6JI7ypZyQAX2SnDr6fN4HXVbm2yumwzG+v0aJSa+NwYXBPOHsBSBVy2oCz57O/BratuMG8oQ8Vb4NuKif80fCh//jea68zLDUvJV904YfyFnrvuOpawEWUKG3/epX0kID6Ciru7gleRBZKTZ0tG/W7UHW1/7bwpcKeLcezPi+6VZ6DDAf57WCMHTwOJIAk32AknF8mOdYEd+PHOHxickNvzLj7kFyWGWbSUZ0ok+uNX1FIlLGAZ0kaD2g3kB5WjkZUSBGzqSDCUOOvpjRadxXMQ4MQR5BL6/iwZ7PZcEttSHTpzQ0LpgxUHQD1/W8w5mdzkzN9cmp94RpMtiyMECzCv2qWZxHoeAflq4BCGODoIXvxPsoqp6g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8443a7ea-e2de-4030-cc0e-08deef197637
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 15:36:17.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpZFOyjUTsoPFlo7Q190zkiaTsunKLKem9NMwZB7vXbmRtrlJizgdo8I5FVHKrMBvvPrinEUZKX6YlQrP86qJkDX+3nJ6egkrChFT4ea4F0BLpz1HuwFziazutfxUdot
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR10MB997849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607310119
X-Proofpoint-ORIG-GUID: DpHxa5FZevlLcULygyGEjR8TkCiIYArs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDExOCBTYWx0ZWRfX+A94eqWYMGl9
 TQ3q2EfkFtVNaufOWptoLpMbM3nVjEFSgVlJhqPGbk0H+9Jcs6hzZEaS4p01IKu6vnl1p4VJcan
 HSLaL1C5EXrR4cjomjlyu43t3b0nK475fGS4imHmGHDRFPraIS8NVKJYfaqrA5pTsucUmKxSAuV
 9BNSH6CcrFQh5F7knDweUE+s9kLuHDUMBfNoXZYvEPKjzzU3pOu0XZuwwTUhJ3fN52m4WYvsWw2
 Tz/nVYscnNM8hdxcb3441W6qgouJyuDGQ7e4mSp/WJD1wyfee6GlMmI/YZ9CbvRkxfElz7ZZTJF
 Rszc/7vB2kqLnGAIhJMXTZEwXymTJkrcjZOzaNHVRpKg248HqKr1UbD6hzmfLR+otFmCnJkc/rg
 HvDS4D1FuFPfdFc6cf+Nw7Iwin+k+hbC0mLT1ujtKI8rs+pUJhIvnNsAhcOv9LxVWiUmRx7AkLd
 nZgexMFJzYI+CjdqHnTiKf2vTZkevQCLsoBSKI0I=
X-Proofpoint-GUID: DpHxa5FZevlLcULygyGEjR8TkCiIYArs
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a6cc0f5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ag1SF4gXAAAA:8 a=K3buwBLi9FAIJHGaz28A:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=2JgSa4NbpEOStq-L5dxp:22
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12106
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDExOCBTYWx0ZWRfX5Yn0cNkV2/u0
 OM0omPKR1F1O9QU+aA3kP3XcXv/RWUsemZNKBIMeked0XBoveCYOsf8eUgs1ZSMJI7PqAZuqRlp
 twvfPVCvhjypkCrEf3RNUUciYolFiKhdsaGvESxjHXle3MxI3Xnt

On 30/07/26 7:43 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> commit 1a087033a6bad73b4140020b40e819b0933aafc3 upstream.
> 
> When running instance tests, 'ftracetest' creates a new ftrace instance
> and runs the tests inside it. Before starting each test, it executes
> 'initialize_system()' to reset the ftrace state to initial-state.
> 
> However, since 'initialize_system()' is executed in the context of the
> instance directory, it only cleans up triggers and filters of that
> instance.
> Any triggers or dynamic events left behind in the top-level instance by
> previous failed top-level tests, are left completely untouched. These
> top-level leftovers can cause subsequent instance-based tests to fail
> or even crash the kernel.
> 
> Fix this by executing 'initialize_system()' in the top-level tracing
> directory once before entering the instance loop.
> 
> Cc: stable@vger.kernel.org
> Link: https://patch.msgid.link/178425671889.84440.9477850701738666404.stgit@devnote2
> Fixes: b5b77be812de ("selftests: ftrace: Allow some tests to be run in a tracing instance")
> Assisted-by: Antigravity:gemini-3.5-flash
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   tools/testing/selftests/ftrace/ftracetest |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/tools/testing/selftests/ftrace/ftracetest
> +++ b/tools/testing/selftests/ftrace/ftracetest
> @@ -483,6 +483,7 @@ for t in $TEST_CASES; do
>   done
>   
>   # Test on instance loop
> +(cd $TRACING_DIR; initialize_system)
>   INSTANCE=" (instance) "

Hi Greg/Sasha,

I ran an AI-assisted backport review and checked this manually. The
backport calls a helper that does not exist on 6.12.y.

The backport adds:

	(cd $TRACING_DIR; initialize_system)

But 6.12.y defines:

   	initialize_ftrace()

The helper rename came from upstream commit a0aa283c53a7, which is not
present on this branch. I think this is a wrong adaptation;


Lets drop it, as we anyway don't backport selftests apart from bpf to 
stable ?


thanks,
harshit

>   for t in $TEST_CASES; do
>     test_on_instance $t || continue
> 
> 
> 

