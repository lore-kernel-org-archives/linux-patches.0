Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B230569F
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 21:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977632; cv=fail; b=uq6beWC1M/PjA5H4ZefrAVRX+Gv0nZxf50PUkyrJjdVZzP2U749PJzj1LPYcsaLVoamWlDnjj6l3MDI7MYzu4PsoIH7PYG9tpu4070T13syRPsImEQLrZFq7hA1Qoxazn+9Eh8ZfH+4+9jaZTQ8ttOaGahenTVSmsp1YSRPORbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977632; c=relaxed/simple;
	bh=I4kyoUgIFU10ZhyjGwUSlItLTpicm2VBDpDlNVOH0So=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c/TUOVyUx5SzHeg/KVnlGwrg7x3zxc0Ttirb7EM2ulKQijS/Wn5/ghbX49xFN2vtMpAy1WMc1moBQ5VSAGceZxz+5/Yn+mfoDhAnQlMSlD01ctno9GTZ4SylLhhyEQfzs0XPpgGMLTb89VCmIPJGjP/K86lXBpdmp0sYjTLTmOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mIVFlPhL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sU3ymvW6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mIVFlPhL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sU3ymvW6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EcPSh3205294;
	Fri, 2 Oct 2026 21:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yUTBO/4QZUWzRKz8PxEtQvlBqivk5XGECvSZ2MMbxgM=; b=
	mIVFlPhLOpneCWwRNLu6fNRRbQImMwQhb3yzUj9LB8DU+N9xSf19Xqf0YPNTunXq
	UOcWnZ1zFdmwy2iG7tShYctGyKoi6x8xFYSQnSNDMCSPfr7bjjC4pr8RpFKc/xZR
	T2d5TnwtMyx09hkA+Mec5t9lJEYkxlKKJDFCfROerINYtiFpcha2VE4FPWfSm5cy
	PuSw3MfTZqFB9cUkHNxcuuqj1fPq4eaMVnckC1f8uVAJW+LqMKniD1mAui75v1M8
	NmrCFbfNyGpye99Z+LlNe75N8qnsqVIZlKfj7ZvYL2b0Q80Y/AD59BX+3E/vQmTp
	1ZsFTKUrcVj39OV7cfKZpw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4fbmkq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:47:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LZ1D6040959;
	Fri, 2 Oct 2026 21:47:04 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012052.outbound.protection.outlook.com [52.101.53.52])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h2f6fspn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:47:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDqM0ivZoh7HuNHI02luxbIiJACCgcyGNHZiboYHuPNJF0/KCuDl0dG2RhHDxLSrtWJRZMAZz2wIuxEyNh3bhSkwL7HiUthecD+x0x7PXYdp6Hyis0ikrfGAUaZfm2g9APoRgQLTWzUwACsZv6N9BvDi9NiN/rMrQc8tcgSbMl6EBAea2JihwQSQYFYBMZ62n40Hedtpd+V8jmx+uEj4F57pxhLy980Eo+wOzZaVyYiGmIi6uVZQyc7A7UJ4u0U5A9SVtN6wGYGxzn8j4g/wayUonGPtMMnXpiLh2kygzrQu3J4x+j/MxdItvzkvhzfv2+l0/K0kUWL54gGuv1vrQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUTBO/4QZUWzRKz8PxEtQvlBqivk5XGECvSZ2MMbxgM=;
 b=IKTUnqEslY0WKbOSIzEJAq3xYQtPPJMGElnMEnYQzqC/6YNhjSkAEdEXHLv5mk6ocvmLIKepJ+GnhApi2MKXkmG2zD1zThVR+IKqVb2d8VfL9qrldPvUogTcNodVcH9s7SyF7dznkUGEtZX0zQsZbBfKVfmJprcFubhHDnFsKu5mvuvQUTJUF111LhJwSQD+gvjLF/mGnBEwqrKjbjLq8twDWw8jU5HtzcAz6x3aQmp/ufYjLZI12xqDWOaFBBWffArULOJMC/OQLtbB9+x2Zhl1nIjCNzhQif5PaOMilIQolSQkqPIlxZbGdSLliJm0MqXe6RyaTlcvzLD3MHdCxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUTBO/4QZUWzRKz8PxEtQvlBqivk5XGECvSZ2MMbxgM=;
 b=sU3ymvW60PhRsfhrUECjcE0FpkvnJRD9buH3L5adGuweso8L3WIj1ZYqhIJO9JL6N/Taxdf4fdTd/1j9vjrcb0i1gq50pgM6MkvS69ql+Ywnoy0qoCb8oWMI0lpQcujypzts5EbTsGKIw6r6iOmn6RRK6JsxjG63ek9gZmfMlJc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV0PR10MB719201.namprd10.prod.outlook.com (2603:10b6:408:3fc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.13; Fri, 2 Oct
 2026 21:47:00 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:47:00 +0000
Message-ID: <3da7c53c-7b2e-4aa6-80dc-2aa4fc5b60fd@oracle.com>
Date: Sat, 3 Oct 2026 03:16:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 474/752] wifi: cfg80211: dont filter by BSS type when
 removing stale entries
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152408.530774330@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152408.530774330@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV0PR10MB719201:EE_
X-MS-Office365-Filtering-Correlation-Id: e790f2af-40ad-4c1c-5542-08df20ceb03c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|5023799004|56012099006|4143699003|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WOJ1EkPNH+SlCB9Fkkaroejk5+AXT9wOYMaJ5RIHVlcEgRRs2NwpofCk6Krwk6Sjc+nwiCH5GnakimdL9VqxHAJOe22Nk0qlxS94W777pNEUokS0qzPCev5Fri48AwZyXwzo4q+lRh+vkRM9ooWghZ+T7KCMfa6/LQaeAuJPm4r1v0dMZhMBvyo+GpE51jXp2HW7tD9yXvjJSZUOe82wiv+RA+zU3j6CjLWMgCInabK7Y+pVQtVavUBH1JYVZRevUIchsRWslsAAxO+FWNNOHDQEJ2nbqzbAZHdvHQwh5xltDfShoq4LlaCd1w/w2Nt04p64kRLNjKoUaycXf07WXdfzr1NfWkOgZCToyd15wgrINIeVSA5fsorrc4jf5Cb9whlc7srPK1HT42IstVQTEHXMnDwI27+O9/cUPCRCxcgcd0O5G8sCHPmL3Q/xNYDkftDjUCE0tBtJfDCTfLGD7VZsMCt9jkBAzWxKoesPvgyJ4ybARSSMfPl0rkWyb7y6mdnWcvTBxOoAqEoD409PefSDrtsT2YPBnWsHesiDHmj+DCOyZ/ey89eAipmKXYedtreg7H1giWvtswosVHNvoAwu3DrbqYoazNq/RWAg48M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(5023799004)(56012099006)(4143699003)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0VLUlpKL0R6RDBaZTRzTTJpelJzY1BSbHBkUFVqYUdvOGM3d21kR3hMbFFF?=
 =?utf-8?B?MEVyTEdLVzVkS0ZZV1IvMWM3NFFWZnF6dGExOWV1bHJmR2tLcGo4N0RJVWRw?=
 =?utf-8?B?NG5TVDMwcDkwZEF4UUVvYjd4ZXdjck9FNWQ3bWk5SytkVnBoL0lTZ0xvNS9B?=
 =?utf-8?B?cnJOVjRtWFM3VXFEY0ZheFlHUlRoSjJrUFRZaGZ6azhTQ0NxaHY1eXBWZGwx?=
 =?utf-8?B?TGJ1bVhYYW1qVC9MTi91cStUNHJYYzgvWXVlSVdFZzhRTVZOWjk2a0wxNnNR?=
 =?utf-8?B?QS9iQ1pqZTJXQVArWnNSaFNQTjVyRUFjSE5FZ0w0WlViSWNEb0c5R2FoaFEw?=
 =?utf-8?B?NGs1eThVMnUrUUVWOEhCZ2pOQUluSEg3Q3hWZU9RNFdxNlZkaTlBQjh2RjFs?=
 =?utf-8?B?bEtoMHlaQStEcmQxN1hDYjdwdXIvZ2ZwaW1pQXczWTRUZGNsY084RWFnaG1F?=
 =?utf-8?B?MkYrak1UZHZHeGQycHpkNUhMamlmdUNhKzh5RVk0VVJDUU5sS21GOHVkOWJG?=
 =?utf-8?B?SmxYQzRLNVZBTlhJWlV3VmkvQlRmelM2Wm5QS1VBa0JrRkMzNTlJNXRzUkZa?=
 =?utf-8?B?MXdhVHh6YWF1L1Vxd2pvdjJVZkJEbVZJVlFSOUQvbWFVazBIcjc4Q3QvdW4z?=
 =?utf-8?B?MWVFd3l4dVFDcC9GRjFvVVpPcFl3SHNPR3IzUEpIVHk4R1ZpYmU4MzBJQ3Uz?=
 =?utf-8?B?eWpvdzBiMnVjZDVqeHUrblpoVk1OZHBTbWF1NGN3UDUzZmxhb2tLMEVaeWVx?=
 =?utf-8?B?elRiVWRnMHRKbEZLYnJmeEJSSEJUTFo4MGttWWhrVTQ4alZKUjF1SE9SMVRv?=
 =?utf-8?B?OEgyVkhYdWpDQzUvd1gyVXVqcmw4L3JJbWw4WXBZTi9kUVhTUGxtbDBHQ0Zw?=
 =?utf-8?B?OVZaTGZFK1B6MHFNNUpqR2ZRZmJmZk92ZG9IY21teitWTitpblFxYVBoM0FO?=
 =?utf-8?B?UW44cE05by9BUy93NitaY2VUeU15cTdpc0krV2NoeG10cW5nbTcyVmNBbTVP?=
 =?utf-8?B?ajlGZkpXUzVHdUNpSkFxZmIvSGx2MllIbXQ0T2JLZFpUaXdmeCtBWXd4RkxR?=
 =?utf-8?B?c2lIbHlFRW1vbHNxL08vNFpCdks0OW9jbzcwNDBqTmcrSUQxNlpHNGI2SFd5?=
 =?utf-8?B?bU8vb3drVTZIU2M5dnFUbCs4ZGFMbjV4blZ6Zkh2a3B1T2ZtOFdFM1plVVlv?=
 =?utf-8?B?eVVNV3c3S3JwZDNWcXhzZnRJK2R1a1haYnJteEZ2eWJ5K1QydUhrRElRRmpj?=
 =?utf-8?B?RmcxRWtEUTdtcFlXemg2dW8yQVhqTUpvQ2QreHdUb3daejZBSDhFVUY4c3ZW?=
 =?utf-8?B?d28wNVo4T3ZIL2MrVXdPdnB1dy9CVnc1emhBTTJTaWhSNDF4WlFzZUVvQm5Q?=
 =?utf-8?B?aTRnYW9LWEs5dlBIOFErcEhla1BnQkxPaS91UjA4ZlM2TEFVR3ZibzJEVFRN?=
 =?utf-8?B?WVBucWc1TGdOZTc2UVlYTVRNWWhIdDNQanFrYk5odlNMOGwwdlRuQWI4Sm9W?=
 =?utf-8?B?cVc0TGN3RXNxdUhSNmhKSmxYT21DMlBtV0RXM3pWM1V6S2pqMDNGODE2MjNR?=
 =?utf-8?B?SUpoVW1tQjM1ZFNpeW1FSmpCUUpOOWVWZ3kwU2Q4OEVBRnlHS2FVZ0tkMENs?=
 =?utf-8?B?bEVkeFJORy95a1N5Vko2SS9CVlZrN1VINzVBN1FMUjBxbCtNZWxGL0E5Rm5X?=
 =?utf-8?B?NlZYc3BTSlhGMVRxaFhPQXVEN1VWRHZRWlYyZXJodllLdXd5OEN0TXhzRnQv?=
 =?utf-8?B?QVNPZmkydmFUanF5VkRLREtUUmF5MHRrUUNOTURYeFVqNm01UHhMdkhLMEY3?=
 =?utf-8?B?cENzNWdwS2tiRFdvV0V5Y2wzbGRjY1lMbFBxK29ta0wwSFBWQ3ljMVlkK0Nr?=
 =?utf-8?B?Vy94T1VhTnNqSE0zVVVwMGhON21zOUVQcEdPTU5NNGN1NTUzSENJK0FuS1RM?=
 =?utf-8?B?aXladmFoclUvNXMraEtKY2RVMnRubVRESEhkUjJFSktRdUQ2WVNURTU0V1FY?=
 =?utf-8?B?YWsvd05vbk9xZE5GQ05lOEtsalVPMWtFSTJUL3pwZlZHU2RzNVFiak9aM1V4?=
 =?utf-8?B?N2JsWjQ5ZnJpZG1vdWtzZ1VuMWFDelJqRnNhV0g4bERTWnhqbU5LVFJ0bnB4?=
 =?utf-8?B?Rk0xbnZzTElKMlR5REs5V3RlN2tacW9wNjRPbmRtZGRyS0RNR01tcnBEdzdI?=
 =?utf-8?B?ZmFSUmVZMzdESzcrNHpDUndJeE5Sc0s3QUE4a1VYMitrcjlHaUhIY001WXZp?=
 =?utf-8?B?ZVNyR1pwcFVDM2JmOTAwZUZaNHBsWjdiTkhMeFlDcXgyK0tNMHdyaHl4bCtj?=
 =?utf-8?B?dFVYMW5wZWJLdGU4eXJBTFlVcWdYaEQ4NHJDSVNsNHBaTE1sbmlFRmJkMjYr?=
 =?utf-8?Q?wRN1lMGxPdFV+9YIdN8mGO/70AGUNyxliBUb6?=
X-Exchange-RoutingPolicyChecked:
	JPzkdzBR895dMEdKUka3l+sTAdaM1rWLM3le15ROswrfJJCu+N6gNpKSORDSBT8CwbCDKr/xfnqsaboDgqZWdyjX1UnkoZAMJ+VyqwiQByS+Hqk1E67MW/FHeVCpWCWIHN6MjQc4Ze5/fzDVP902mPUeCDp7GIXaOX4T7z4ocUColR6YxW44osrEk7YUi9bMY3aFBfuJo/024mJEy2dXLYMg4iXVJczL+ekOZJGZFNfX3YOCaN8A4RN/T6z1FxTjgPzyKzs5X7XpyhdQspdR86yajVsYLM5VBwPpM8D8ahFomCr/GM6+REZUcPXSUILq58y4Zfm9dVC6L71ZgIQFSg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vyeKNP/45kiyTp3vXoBkRCg5vyVdGgCyWKW1/zbIWz06ZIfYRkiWYXhRMhx3+Tjkh55457/Z33KpW3fkl+azAy4nP6qkmwptj9TnRyz9UjPGl1jue+Rp4KWdsiKSSlw1fAFE3bYz0InWUflusu8OBPMpv8yYSBktOniJspItdoNcFwy/MXZ1lrZpNTOiIt0Z4HEUVjaM5Yb2h8Ve0wp/GcE49EQ98BPZv9QYdO+PQKYoXf5DdZma3nxEBdffkEMZ8Czm4pqAago47yC+wfu+83K788F0VqTMMLeewEIu1DvV+DpFxwVgibEvo5Vgw+6+d58tIU1OKMEKnD6pruNkbQBFQ5jNbJLVMv2WHcprVQ0Ah5ozBFvTsc2hsZdq03KkCI7MlN3UfkghPTVG7HUoYS/d5yj64IJI0NlyFiBGcNq1CGxWTns5mp6O0p85sraxz6z932mVYGg88hQCY9KMHMs+tHAmlhkMbntPfWapZQKiQPjTWnTEkk16pnvvnV7rMhAE280LGMzISbVGzkOTAnurdr8R66nUwqjD3q5lRDTFK4zHAOK5lxpkXB5kQMqPH/70C7E+mvwzikjP8AnOsee28FEDJ1yLl8ATRHJLSP0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e790f2af-40ad-4c1c-5542-08df20ceb03c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:47:00.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gpkkdk7ARXSwWpfAJT4zl5onBYDQPNjx2Y3Cox5ISlWHaITyW05/wlkNpWbt97GTxfG9Vmq+oHpu2ptXYnE9zHDPwsxSCnveCcF/VjtoAyzrU6me7h7lO4JWzVWqYu6X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB719201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020086
X-Proofpoint-ORIG-GUID: _q4qDQWLyl8639ZOols40dUZXlX9MtGg
X-Proofpoint-GUID: _q4qDQWLyl8639ZOols40dUZXlX9MtGg
X-Authority-Analysis: v=2.4 cv=eJCGH3p1 c=1 sm=1 tr=0 ts=6ac02659 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=edf1wS77AAAA:8
 a=bC-a23v3AAAA:8 a=QyXUC8HyAAAA:8 a=hSkVLCK3AAAA:8 a=VwQbUJbxAAAA:8
 a=Ksqme-b9bE_6W1MfNz8A:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=FO4_E8m0qiDe52t0p3_H:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NiBTYWx0ZWRfX+gUd/NqGzvdi
 G/jbQO9Y7VwA7TOeU71qLCEJJwukziQL4bd+yRX6UPz0vZN7M+MLPfDzGAA4ctEKMP+TV42CwdN
 8PILDfCsI29v1bf0TlP6W765LYKHo2ji4ehNgqw7vntNS7l1zpvW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NiBTYWx0ZWRfX1F5+9j/zQBm5
 sIdoTMagXYotxe4S63AmjS1ON5VXvP1Y6yXEFvJk5+uDitdG4pBnbZlK2gqe86B5u63sl4/Rl4W
 TUQ2gow+VCLWPcdT5TX3lKOaMta3sIqxmcY99OJY4O6HLS77ghzny9Ox3JALX3gL49DvnBSHbSp
 rEv/QjdgOY95Ato486ezURt8BeGYWb3+lBaYolTRJ4DcrD/BWKOrUqivpqhzGSsT6JvRBQ1HRSX
 j24olS57qouAPT2CMl0snGlab5ANmS8V1QtZvrcCGvoldooPmIjoq8QFs8ypCVedXaDLHAvXtgK
 a/SzODuc8xbLAppdZTpk0VhD9Ub+/rS1+7PFY8d0swroZrfe9pcTICCOTwTq93eGDeCkNtnxw/g
 ubxgTpa/hsHKssXgv/I/DDvmTw2F3CQyRG07amkhN5kUe7x/SAK4/ha/EPLq82BkLoOLQ/eeHKT
 B3xZx407AGTX3uYA2sA==

Hi Greg/Sasha,


On 30/09/26 8:55 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> [ Upstream commit b377e1000d963e7182a987082b4b06580bd7ac84 ]
> 
> When an assoc AP switches to a channel that already has a BSS entry,
> cfg80211_update_assoc_bss_entry() removes that entry before rehashing
> the real one, since the two would otherwise collide in the BSS rbtree.
> 
> The lookup for that entry also required it to match the connection's BSS
> type, so an entry advertising e.g. the IBSS capability bit was left in
> place, and the following cfg80211_rehash_bss() then ran into it:
> 
>    WARN_ON(!cmp)
> 
> Changing the type shouldn't really happen, but can be triggered by a
> rogue AP/device, so drop the check and remove any entries matching
> the comparison.
> 
> Assisted-by: LLM
> Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
> Reported-by: syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=dc6f4dce0d707900cdea
> Link: https://patch.msgid.link/20260904165614.1f05dae1c546.Ib52d57b57caa912efee020f9d4a033a5160617ce@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/wireless/scan.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index de1e89f471a17..5063f43cceda7 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -2745,11 +2745,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
>   	cbss->pub.channel = chan;
>   
>   	list_for_each_entry(bss, &rdev->bss_list, list) {
> -		if (!cfg80211_bss_type_match(bss->pub.capability,
> -					     bss->pub.channel->band,
> -					     wdev->conn_bss_type))
> -			continue;


An AI-assisted review flagged the stale-BSS selection change, and I
checked the caller, merge helper and final-reference cleanup at the
final 5.15.y tip. The filter deletion is exact, but the caller still
uses the older IE ownership rule.

Upstream ownership handling (b377e1000d96, net/wireless/scan.c:3514):

     if (new) {
         /* to save time, update IEs for transmitting bss only */
         cfg80211_update_known_bss(rdev, cbss, new, false);
         new->pub.proberesp_ies = NULL;
         new->pub.beacon_ies = NULL;

5.15.y ownership handling (d7aa8488b4a2, net/wireless/scan.c:2757):

     if (new) {
         /* to save time, update IEs for transmitting bss only */
         if (cfg80211_update_known_bss(rdev, cbss, new, false)) {
             new->pub.proberesp_ies = NULL;
             new->pub.beacon_ies = NULL;
         }

The merge helper can consume beacon_ies and return false, leaving new's
pointer uncleared. Unlinking and freeing that cached entry can then
queue the same IE for disposal again. Before this patch, the caller
skipped capability-mismatched entries; deleting that filter now admits
those entries to the failing merge/unlink path. The older ownership bug
therefore gains an additional double-disposal case.

I think 5.15.y needs acc44cbd7727115f9381c35c2898b1b5af665ec8 ("wifi:
cfg80211: avoid double free if updating BSS fails") before this
selection change, clearing both IE pointers regardless of the helper's
return value, thoughts?

thanks,
Harshit

> -
>   		if (bss == cbss)
>   			continue;
>   

