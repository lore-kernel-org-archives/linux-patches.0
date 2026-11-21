Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795267950;
	b=uGXr2WH7IYTUSLe0FGm9Xx+YIVd/sK59PTVi/YEV7o0PmdF5p9UUhJbLqaDCpDsK3AW+
	 meP+Um+C1Zqtjlg4KilXGKcC4pvlm3sMwtvS+7J7/xxBVQlae0E7Fff1YYfsNWiHhDcFB
	 tH3DOpWUN5DmPEbarLlLIznX9ZRkV+1D9XaeV/b8BQ5PUlXdnB1tM4SnnhDLG87e0stT5
	 grSX42mJBIB57WdfZStG1EgTmEH3X/Yd0yF2jZmLQQYfZFdvslfC7b84KN+alhdyHjWkF
	 2DnPQekvRPuDfgWPQ1CAN+6BxvmDcSr2sDE3CfnhfeC3KvCecXpdiPImCCjwkN/CghA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795267950;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info;
	bh=5+QGra6P9c2WlFNVYHnUZwrwKfroJGFJcm1daeEVIhQ=;
	b=4LfEOqmINvp0ICmnFIn5K7YUuqGir1piD7YCCcHXgUH4lYQCWYHeP4hVRVo9Hms8go9o
	 Szewmjf7grzOje53hjWQpZ5G816vDylPsy0YA4R4X2Qvoe5HgIdSFYRgSeWAgmpc8oGeU
	 6bm2nyVYYlHMsJq06GcNa9FWYcNGp1Y6u7+CnVdpxIQyHrYNwWOaCPH0/Rmbzg+lMqnAk
	 QLmRq2s7pLc9w0FCQqoZvhMr6FZCzWmMGa2BHFGzVGYs8CG6Ac+uB0RZXw55OB01WPrgN
	 HeyasaBH9Q9c8XUWA/4HfI6Ps9gsWcA1UHgyRQdtbb3ipTfJ1BGZ3z4ARtweVUUBBeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=oZE3n9py;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=U7YwSXRg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D5C606A320
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 13:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46D5C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=oZE3n9py;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=U7YwSXRg
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALDBqBl2103457;
	Sat, 21 Nov 2026 13:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5+QGra6P9c2WlFNVYHnUZwrwKfroJGFJcm1daeEVIhQ=; b=
	oZE3n9pyrFuPMrMAqCUWHSal1g6Rt4AqbjiB84PPMSzjGjpwxEeUgqJcRbikwIMU
	b3ph55WVC0h2hvIyV26Tdz2mfQAZvVp8BU5loPIuzj+iqhh0hOsstEZrXSQrP5wt
	KyzVeaheiuUs+7QJJX70V53B6452ez+0EVjSuSCrazwimtLjy7BMqFr08qb1hTi+
	0lny8dqGLdskuHu1WpWDAEuOK5DK2n0wICG0jvLzX5TyiRxidPSGgQ+xthZquMVj
	/pJfW/exNwhRnN9JA8fCowogzoVJkT6ucn565MWPWxorqnEFb0tWdkc9lkFt9Q26
	sJf7sEdjQ+S+rNuNfQIWQQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t50711-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 13:32:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCHtDb252387;
	Sat, 21 Nov 2026 13:32:22 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010016.outbound.protection.outlook.com [52.101.56.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j38rfkg5r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 13:32:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YewzYbzc+0aLjrZISmP/7xZ07SHiQ7HqH6q4qxy2odmjYzWr1EQs3lE9oTxtOGA0q0rpU2B2LbWDwcSekvCzQ6JhItx05LMicLxdIL5xD+I+kQKZtK/vTGdxHljlwVbV8ZeiEEg+TKlbDpqvDtYn3Kqi86ksjrb11jPEYAcOUwCbvm+xDiilm+COeMDx12MlOBOUQ/o7bxA1HZab51Dy54joEAQcgUYKzDHv/zKQmVTOYbshNwSf6DJGEhDF6pryQhtFpR/G3B+3QIRKgJsWywojEDYcL+B4ykUkaqh3pQN00kj9uaW0/Sbb/p6n2zcJZDf4kUnoNc7JDUymf0ZrEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+QGra6P9c2WlFNVYHnUZwrwKfroJGFJcm1daeEVIhQ=;
 b=ldhLHDfVuagr7QpNhHZL3G462kQz8Pna1sM5hhLUmxBuQAZvMUng67TIkmrlSdMeDEb1KdUh6/UubXfdpNTZoeQVPoMNlPFKEvHJz26abfSjsN4dNYUw7MVpYG4cg3/muhWmnv23AWX5k0kaD94V58QvGmjDnBPuTpipahptVbG9s25FUlyKqNeSooVTjip5dSGBHR+jSgSMVJXgyCoAOIt0UKCPdSH2c1TU0oOr6OMckXqRc5BBD8kAKGkUZGCZuHM+gaBfA0KShr1fgTpBFyG3HGDRrmQG26MyONQbzTXnX6CQzym2ZjTEa93ayaA+Eii0880hQFgBLeTBmNgfUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+QGra6P9c2WlFNVYHnUZwrwKfroJGFJcm1daeEVIhQ=;
 b=U7YwSXRgCZRw1mzs/OAnT/bv478ak2OIS6iYQD2snl1AImn/2vw2l8l4ZnWcry7hniGsHJDNf1fe1MAjUVQqryCF18fJCMal7bIVg9rkQxjWeebYGS3VUrh35/rtA7Po+rYq02NVNz60Gmw+h/hxPyDRd71Bpifh+rInPa6w0h4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CO1PR10MB4467.namprd10.prod.outlook.com (2603:10b6:303:90::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 13:32:20 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 13:32:19 +0000
Message-ID: <f23e1065-bffa-465a-a421-415b09665e0e@oracle.com>
Date: Sat, 21 Nov 2026 19:02:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0726/2214] ALSA: hda: Reject codec reset on ASoC
 (ext_ops) buses
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Takashi Iwai <tiwai@suse.de>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150040.812478392@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150040.812478392@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0104.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b5::12) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CO1PR10MB4467:EE_
X-MS-Office365-Filtering-Correlation-Id: e787b327-7d45-48a7-458f-08df47d3ddf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|261009223027099003|261021121427099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|4143699003|56012099006|10067099003|261102123227099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	Pf5Wffl2GyY9OZamqtyDXF8bV/DHhasYs+HQpB29CeSAoBR6YDUOXJzjCnqCxVVGzjL6zZzqYPuzVvz/RuuCBWXY/HpdQOSW5RjYN2YQxQRvpL+sa7IRGy6ugtDU29so6OvcZP7MqhCCgKXHR4s+AmID10sXR5EDV1k6MDQS2ykdpg9jwO6L+i1YYpwsold9/0fbiA90A+KeVqxPcQACG73bvtIth+IUflCYv3YdoJdHc/vG9aWwF3eL46w3uMCg6yrLvOgGQA34ELpyrWXAIbSvhekhqWeZBcL2k9etkxd0DBu9qWrybizwnsU+EMvULkOQ8gIJkPA7zHOWMhBbchIMYm5hq0fBf2KmT4Ig37lOsG5vhsr+betS9cE5nK+NsbLX9X3Dha1343zqbTx+vaFFIRwP/yGclIlvGgiKETYrJx+jX4uvZeZAECGvmQG/XoxyV4nJO8G+Zj81W8UnMbmDsdZc3Csyh9TKeG/ATANcooJHYK7gL5oVgP/HkbSIbRhL3QwCuosVh1ZDz+CynIToYZ4KsuMK6mMz8vBTQeEeUSWcF1Mxkx8kBz09LJ96ikE+S/drz9E20yt/A5jAtmns2aTdPeYikN4MlpGZwK4qe6FyIcu1JhZqMn0vv3xI7GyhwDzr6vnyYOfU+RkR3n3z92TSEn18XkBXSvJWjMs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(261009223027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102123227099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3ZSRW4rZlpiWk83WTdoQzIxSnJYamNUZUljNktPMVAyTEsrRlFUTEFhMzg4?=
 =?utf-8?B?b1hHTDFXZkxCZHlIclhJckFwK2RtRE1yOVF6dWdhY1pVdStlWE9KQThzN3Na?=
 =?utf-8?B?UkNUSlgyN283UFovaU43U1draHlpbTdLV2JGRVc3YjRoWW9OYVorZ3hSck9B?=
 =?utf-8?B?Ujk0UlhnRmVpbGxoTVk3Zm9HSjVYWlg0YVRNUWliS1N2Q0Z4VzgvZ1liZ2l4?=
 =?utf-8?B?S2ZGa0hIM0M4OTAvdlIyUUJhU0JTYzN2TXJGaTYvaVBIaUxia3pXT2RsWDdZ?=
 =?utf-8?B?c1JoUkFmb2MrR2JhYldyN1g1TDE5RzVXUUlSTi9HQmJyRER1ZnJNZXcxMkcr?=
 =?utf-8?B?N2x5WjdmOHo2TGRqSFVLYlgxTU83S2sya2I4QkJ0akIwbUFmbFNNSHRrUm1j?=
 =?utf-8?B?ZkVTbFM3cnBsVzdHRmhoTDFiU09YL0g5aDBuUDFaZUZkMUFMWmlqREJXalBV?=
 =?utf-8?B?a1JLN0Z3bzhRd0xkTTlReit0VytoKzhBcSs0ME53K3U2Rjh1bFl0ZUd6dDFh?=
 =?utf-8?B?Tm4xZjkxWEg0NjE3R1RVcHIxWHRCWmJDdjhxWWlmbHh6dGRHOXZtMk5DNTZZ?=
 =?utf-8?B?Q25KU2RpNGR5M1VtV3FDNnBqNVkzejkxTnpJMlh4dUhvU1VKSmxyMEdRSkhs?=
 =?utf-8?B?bThLQjdTbzdMTzVFRlRrTWxDZ3BCMXhiNUpWSmJCdVFKY3hwVmc4bzlnYnNH?=
 =?utf-8?B?ekoxOGc1bjRnNlBBZ3FSc1RJSHI2b0FnUUlUOFhzN1ZqUWg2UEhnMS9DeTNY?=
 =?utf-8?B?ZEk2clIzTUR3cWxBeE5XVHdtSFZNcjhwdjJxZVU5Z1pHV3lzaEl6SDNuSGsv?=
 =?utf-8?B?dGpDcEUyUWw0RldUZDNJejB0OGFBVlF6Mzh0c1J2c2lNK1Q2NG1yYXZvOUR1?=
 =?utf-8?B?SThnTlMvQ1phdER2Z0F3T0J1SmtRMEJHTVFnT1dZY05pTk1qcnBqR0tVY2J6?=
 =?utf-8?B?K3IxcXcrMFV5MmVTVCtEb2NrZDhPOEhteFcrOFZxS3hXUS9CcnFhcHZJTGhP?=
 =?utf-8?B?UTVrZitmL2dnNExhTEV5bVhGenNxdjhubGt1aU9QbzZKOTBQMzZGa2dFNm5k?=
 =?utf-8?B?YmhmTVk0QmJPVU0zcHBaSjlqa0FpRktaUFJRMzZTOHFta0pNZWIzcnA1Umlx?=
 =?utf-8?B?eGk1b05ETUhsVnZnSHJzZUdadjBJbk14bkVlcFRQVnRSdk5HYlBUdWV1S3BB?=
 =?utf-8?B?K3lwVndFQVRUMTZCdHJmM3VUZlg0UnYxRDBHOE45bEx0anphYlROL1IvUFVR?=
 =?utf-8?B?WTdMbjdhQWZUUGtOWENUZ0JPYTlWMVBrMUNqVitwbWtPSXFzS0FnZm45RXNs?=
 =?utf-8?B?NE1aU1Z6ZnZmVk1UWnJiNkNOSCtzbU1PRHBIeVp4OU1xNERaWXBOcGEwSmpy?=
 =?utf-8?B?dnYyS2Nka1A4SXJ0Z1JOOE1pTHdMMUt5SWJKQUdmejIwY0ZQamtrcERPMG9z?=
 =?utf-8?B?WHROQWV4RUpneUUxNWdKaEsyc29uSUJSdS84TVErL0ZBbFlwTVRuUHNINTJq?=
 =?utf-8?B?QVB2NEFtRzhNTmF0QTFDMlBBWFpLai9sUnlwRDZqK0xueGdvaUM5TEJmYlhp?=
 =?utf-8?B?VGdXSVo1dWFsdVVZZThjMG9vMGlkRmdLWUpsWmIreThFdjhsZncrL3JraHVK?=
 =?utf-8?B?cmd1Z1A5d0lpWGQvYkhDT2ZXcXJiS1dsejluQm4xdi9NWE9jVmcvRjlHY2Rw?=
 =?utf-8?B?U05LSm8xS3IzbldQdjhxcmIwZ0pQZm9tb3FLNStKMUpCUzhvMHNEWGFPSUta?=
 =?utf-8?B?cmgvUjVXcmZlWDVEdkZsSEhYdFQ1b1krQ1M2bDNySkRBWGFUbTBsVmQwU1ds?=
 =?utf-8?B?aTI0cVR4OUo2OW83U2ZLWnB1SUNnVURvV3FFOUVCd1hicHZsU1N2dVRJTEpn?=
 =?utf-8?B?UWFGRlFmRWFURXhTWEtncERadjRvaWVzcVV3VFpJLzdsK0h1MHVKUVAwaDEr?=
 =?utf-8?B?VXBMNHgvem9Bb093Nk1aTGJ0d0lENzREaE9TcE9MWWZWdlJsbUowZEdWYTZQ?=
 =?utf-8?B?TmxiVlZzNWx6cHNmRm1Ma2ZYMUV3bGgwdEdZV1A4TEFLbXRCV1JVT3NLd2do?=
 =?utf-8?B?Z3BsdGkyTVozZ0MvV0N3Tjgzc092VXVtaXBUSU1BZ2czMW5zWVlCY2Vab1Qv?=
 =?utf-8?B?WXNBMEhNeVQ5QmhUL1BDMExMb0crRXI1Sk5ndmhEYWYvUGFXZkxiOWx5MVBk?=
 =?utf-8?B?MXduWW9lN25ONTJpWmxaSmRRS0gyVmpxWE45OWd2SElxQnZKWk44VXBZWVV5?=
 =?utf-8?B?eE41L2hPUllNR1VTTGU0c1ArYllFVjFkVGEwVjNKR0FFai9SYmx1Nmdtdkc5?=
 =?utf-8?B?VU9NZHF3UU1SZGhZMUgveCtmenVCSlF1Nkc1SlBheGdDVWt3SVo1TmlPUXF1?=
 =?utf-8?Q?FkZyLu9mXeZp0LqmMITDaNS3ec0Ewys2MdPs/?=
X-Exchange-RoutingPolicyChecked:
	LXHBiHSWnuTfCovqkzkQj9xsFXrDWnw1YwH2TyDWi2JMksHuNiQuuYmc3oLUi4cN+eqAIi98fTy8XhpFR91e40xgzkXVZ6+B76JnvQABrlMPWuQ3vCgFY1NvW+sQuf7Z2AeTCEP/b0kdYlhNK3YcjidLp9KgnwxXNw15eV6T1Q+VRw/c81L0In+NlIwKrFI8Aer0RDsbM+5nY9rz21MaJ306DRLjLb/sMFDu1VQYv5uHTdfeAgeaWQUlCChD3Jmyi22ClhsW+tZwu7nac1VjY15+7gsmMJ1QHgZlfvKUWZoFI0gFLFrMYxcziIzaGA1L+KXGBz2ebjov/v7PS+a5AA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	paIi6ZmYWolgjHzrMmZllEhB2+Qhu0iOpw6WjkuYRpkSBpNKwaxNm21kykZIh5jBWf8ltmZa1JrWk9TLfXi0B0e6SHU8CtL/hx0OJP1S38cHiLBu2V5l3AqjYccLZIhhSHrZw3cdBDbIN3+34eUOxbIe5hzKBrxzbUfEGeU6WQDF7waN0esDoWkJhE/sFW4CWP1CrlNueiP7aoVfQ/JRcSaysMqsgVvqGxnRaIbCkNFCi1y8FRKZzy3p/D5URepBk+UbWoBo6jg9ZXzOhLAKRtWdOX8KHnwXeMI285SL/uyNOpXXTGks5e52PFQgO/i/k7VPQW7sRJ8XoRzMNvYegVM3uH3S6o5I+kMSTzMLBlJGIRvRUkQhUPacNb4tuCc45IiZX/KxTa2p4+rjIHauWP5VTo/UBMJ29M6Q9u7sf/Rdrwc+SG82j0/wyM+q35gNRQsJhhnR3xS/JDY0MJ99BHiBztUDzap5h3ABd0glrvA2DqfF8ui++0UvZGFDSMmQvortRbIi5pc9eoThVyRofXKEAFstC2zJrSg5FI2+bvfmC/NA3UuztqzXAFU5+XcDjIbBjkl7bpiCI9rUVBAByv2TqfblK+3sFyCSWRoAAUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e787b327-7d45-48a7-458f-08df47d3ddf0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 13:32:19.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t42VCO19bZH4BFZ1/FRkfaF7eRT2G9adOayerEnIHMoJPJMDf89QpqUAZJwdpoLGYSiOZJUTJJ0N5dGYK3KiKbgKBxTSJzs1T8GQqPO7Ofj9rdif4GvZsYHfe7ifd3H7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210053
X-Authority-Analysis: v=2.4 cv=dJIzC+Zb c=1 sm=1 tr=0 ts=6b019d67 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=QyXUC8HyAAAA:8
 a=UHfj1_f3VPuKF_RLxL0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RiszuSuU-TkaOunuoz9MUlI8rpddU-ON
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfX528t2x7AQK5v
 XWvvbnZS2THY8Hu9jxAvPfWr497aNjP4dN9eEHGzniz7G3Wc+PY2KU4CI8zqJSAVTNLAKRzDOXw
 zS9mGIUOZ783f+uHb7cW1Gb84JxliaCKEQlEygJ+2KUccTYJJ73h+3jdgKzvkW/IBTNuZa9oFz7
 qO+xFDYPl38l1U6kFXw31AvUAVYAXCtKqZPp+Im4AJiMsjSs6+jIK/psO1smVRTMzQNqPQLosCu
 zxvd1oYrH29vDIEPIry10iRtpvP9OukFvJ4RgWD49YOkzNELZqxOv7T8+oDWfYSNhDkKnkA2BUV
 VZ1EQbc9g7IKJhJS/hEC92lR2lNQ2T1IKh4JMRkhiz/t1ipRcNIT7JkAoEX+3N1vBMgJUXSUiaE
 UoLILgCpwqOhX3dd4DufcfboDuBalIpQh2Zwt2rMQ0SMQzgVZ9YvyDtKRr96GhzgZ3FzfpCnd8S
 h/kRv9x2ectUNnwfQhg==
X-Proofpoint-ORIG-GUID: RiszuSuU-TkaOunuoz9MUlI8rpddU-ON
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfX9mL8ByNq22rD
 4sqAuN6KHQUGlau/JloSW+PSeW6AU168+3R5RZ2XKYlBWSR96Ra3UEZCRESKUp1pgp0M2qES0GR
 m7NlXjDUzNZW5qbJK6xaXA3aeX+7dmMx6mEkD6CRlLO0rNLgw5lF

Hi Greg/Sasha,

On 18/11/26 8:10 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> 
> [ Upstream commit a4311e9447bbb219044db38897f95be112f46a8a ]
> 
> Writing to the reconfig or clear sysfs nodes of a codec handled by ASoC
> (SOF via hdac_hda, AVS via codecs/hda) hangs the writer.
...


> @@ -134,6 +136,8 @@ static int reconfig_codec(struct hda_codec *codec)
>   	snd_hda_power_up(codec);
>   	codec_info(codec, "hda-codec: reconfiguring\n");
>   	err = snd_hda_codec_reset(codec);
> +	if (err == -EOPNOTSUPP)
> +		return err;


I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, 224708432197 returns from reconfig_codec() on
-EOPNOTSUPP after snd_hda_power_up(), bypassing snd_hda_power_down() and
leaking the power reference.

In hda_sysfs.c, reconfig_codec() now does: (Code spacing adjusted.)

     snd_hda_power_up(codec);
     codec_info(codec, "hda-codec: reconfiguring\n");
     err = snd_hda_codec_reset(codec);
     if (err == -EOPNOTSUPP)
         return err;

That return bypasses the existing cleanup:

     error:
        snd_hda_power_down(codec);
        return err;

Upstream (a4311e9447bb) uses automatic cleanup in sysfs.c:

     CLASS(snd_hda_power, pm)(codec);
     codec_info(codec, "hda-codec: reconfiguring\n");
     err = snd_hda_codec_reset(codec);
     if (err == -EOPNOTSUPP)
         return err;

The snd_hda_power object calls snd_hda_power_down() when the function
returns. The 5.15 code uses explicit cleanup, so it needs to reach the
error label instead. Repeated -EOPNOTSUPP returns can keep the codec
powered and prevent autosuspend. The parent sent all reset errors
through that label.

Maybe we shoul route -EOPNOTSUPP through the existing error label to 
balance the power reference. Or drop this backport and we redo it later 
again ?

Thanks,
Harshit

>   	if (err < 0) {
>   		codec_err(codec,
>   			   "The codec is being used, can't reconfigure.\n");

