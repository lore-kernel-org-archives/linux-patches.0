Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C7A3C65FD
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976281; cv=fail; b=DMI7zxOwtDbjnLAclxykJkT2s5Bjht8j9yfepN0m+lyxC0/j5fuERwrdJ6HXjDxxbHz0RLHCM4X6UKIs1yWL5ISrehfEc27qC6WJVlZEE8Hb9StxWbodnbGM6KjJ9DSo1s1UGgA6aJDs1nQZhlKgwQLxIyAYRYzvHBCmawmNQI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976281; c=relaxed/simple;
	bh=o+hJ1Wtqsv6K80sV1iuChTxgXjM7SeUXTN4Sf4of994=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OnYGjnauBkTg1B53/H+iU3NGlpBRXqm+aQMgGlOYBe2hADl/vLJrs8gbF9Fcp9mO01UyaJQxYkpz+4nns3DUr8/Z0jNwr9SUBnrInp+8Iw70njVV0zp6+I4g5f3mmi5tBelO7kFFHCdJFxBspkhhOy7Ht0wbrtTYAId+jSs124Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jK2T/fMn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PFQr45ER; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jK2T/fMn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PFQr45ER"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692Ec1Fi3288013;
	Fri, 2 Oct 2026 21:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bKBuMhykshueAXv3AyQqFvZECYeFnOwvEOPVJ6kEpUA=; b=
	jK2T/fMnTA0tAniqWjk8oOboiRSLKGD8CBbE5k6j/0qmIOo1O3s1ClImhZ2HgsnH
	BNL5X+/qfwfwQO/CfLxqFtbgVsCNSgIDtDPiA/pw1602Epd3GWHBJ84zoBd7zN/W
	KWYARj+MnN0RcOv4LmipjLMhvRm3sVqm13ct6CQD9VDWpSy6Dt09M/xp2/C9Zz9x
	0be6RmX2gNmCqD3ddOQVoBvNMGCn45F9ZfEG+70yHLGJ7psaQmBOXWsK1xtLiqcH
	Bwq3QKhW+IxfWRS+mcXig5MXEktnVfipIM+HDigNkMqXrNNqks1jME2LXWArh76F
	fKeihWLMSnGSgtg3fE0SsQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx5ns4mcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:24:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LKOiW014577;
	Fri, 2 Oct 2026 21:24:34 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gu4hd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:24:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IM8AbqXaCbRku6sUXiGVyAMDj3MCQ3smyVR8ax8uPjXibZav5f5FwST9Js+yGDR8pXaHVXw40nV1n89GBqoONJNtoWa5wDd6azXgWFTSUpIyvBQUUzknrsH+gztNsl9J9V+KYWw52hDoYijVtNjxhQXiT5d/Dz2QA1xBCDVxhNB3k+lf9bzSJpi8xqaRPkcyrAeYwH4Qxcb5N4EhvXkPK/p/b00Eq7xauHqdRjXJXTXamf7tavtpdiqNcMbMsRZyZxmJpXsNqRA/AwOc8TaNcNpfsC1CNI1Gl/kdAOjXUzL9Rc34rK+JlusWU45t+n1qbOm9wtFr1MXeoac1ZTduuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKBuMhykshueAXv3AyQqFvZECYeFnOwvEOPVJ6kEpUA=;
 b=FOkhqCnVXlnnkK7oe07251+5JSEgeO89D7LfGZ/CRkJUvJU0FIY3EbbYoYIsM1AucBSJsT1YwN6dYn9gbfxk/JHJc1NNuzAP6nLDz1cqWC70kF39eENyKdWXFdqakIBVQR1qdqiqE0eqkk2p8DHRM8m6ciSeVgZBVHDqyzs2K94WmgehzLdH8sAY4w1DZceM7H+CeK68SEG8v9Svq5/Xn62feYAwYylt7ZvQBzlYlxfR06NnH3jUdSGly1xNvEGqIHISxVhWcF274wQEvP2zxrRN+UQWa3zA6GiuP/GVH1VOp3MQNFcDvNmGb6M3jbZ8hr+CgHZnulCESzuz18mkaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKBuMhykshueAXv3AyQqFvZECYeFnOwvEOPVJ6kEpUA=;
 b=PFQr45ERlneZNJZWuVBFswUNt8n3hggZspyqx0vdqEgQcANK/0l5VbO7CwEhgah4uBNQ2lW8FwCSGI0wOKk0eelWDstheTbNKINBGgriieyvdNWvZlwQFlweH0SvHBt9FjUQfXbyG6MBYdNUGdPFY19dlclfHNaEaq1FW5AQ2LY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ2PR10MB7788.namprd10.prod.outlook.com (2603:10b6:a03:568::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Fri, 2 Oct 2026
 21:24:30 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:24:28 +0000
Message-ID: <d2ea9d9c-d581-491e-bd33-072ac019d977@oracle.com>
Date: Sat, 3 Oct 2026 02:54:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 118/752] ipmi: si: Use platform_get_irq_optional() to
 retrieve interrupt
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Rosen Penev <rosenp@gmail.com>,
        Corey Minyard <corey@minyard.net>, Sasha Levin <sashal@kernel.org>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152400.732402342@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152400.732402342@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0235.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ2PR10MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: d474edb4-aae5-4c9a-0742-08df20cb8a33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|56012099006|5023799004|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2x4cooh7E0nn8sic8N2W2TKJXDfrT4sXuD/FAm12FMNtTv9y+2BoCzYZqbRwMzRqC8vTNVCs8KS6GugfwAK/wACCho4pIDXblczLlIcI8ohrEQKx8Mh//RlmhHHcnRx1gAJAs7lCvJ90wuiQJiKM9i4mIpyasm7OPwEdUJi6UD0UZaKlFiSDi9NboH7U1jE8Lq7JCb11uC4w0vk21Jihzy6Mmu5yIgleOMq7FAvlMEzal/ZOkY6ljgzDzPHHeKkMvE43/NNgI6gCxIhyfTM2GbYEr503PRmcQ8BkTy9B6KJwcPWxMWv0dAdoFOovR/OqFhEbDH/+YTO2Bi7mUmS8yqG5whcBEOx/2O0OlLirnZ484Sx9bdoqLGTGhNQ5VDJYC/IecoZ0uWAKTiEwJYuL6Edale9yoiQMR+QVuMTQTg80PUQJLDIbluZBgAOYzJRpS0oHQ5CFGCdPGYZ/nAMy65I/7bHq4Zvtk23jxHyML4r0ETMd/TnmarCj7fnd0dvgtZHZgy+5oVu+qDQ8drjWvzDAt+SKi2HUS9jymfWzc+vm2U28oT88EHWvm4dWE9tT6CqOhg0VQjlM4XbVXQpPLgBY55CcUaeyNZe67GA7aHP5gMeReZkKBDZ6ZLLTIfeDysOWl2WvB0/bU5wVBTP6yg4zjm5Oe13qvS7tP1eHmpk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R05uSmdkcWlvLzExSkdHcU52L1FONHk2MGJ5K1ZVQk1NSVNia3lRcUt3akVm?=
 =?utf-8?B?VGVvVEZQY29oeEhPb21xLzB2ZVBjVUVDS2JWMHlpdnlvaExVQ3VPcms2YzRw?=
 =?utf-8?B?dUowZFBTNThmWTFuMkpvUkF3dDBValNXRmJsMjVBY0tOMGpLSFdEaFFueFN5?=
 =?utf-8?B?VG9la2V3eTZ0VzBFOFFQUE0vM2lrcFoxSmpsTWIwREpJemdPZDd5YmZsRm9l?=
 =?utf-8?B?c1V4ZUpQZERRNEc1aDZYb1l5YWJkTnQzTDhLZXVCU1FYL2JFZVRQUTdWRFZm?=
 =?utf-8?B?WDB6K3BwT0gwRnZYM1hEMlk4UlFobEF3RmM1WDZXTlQxVldMUmVuSEVPdG9T?=
 =?utf-8?B?b1JZeU91ZCtwMXBUbXhJYmN0UGhrZm9XWGNuNDVJbGhYRG91WTVBRjMxTiti?=
 =?utf-8?B?eDhhUjRDTFNCVWRUMzM1NHFRcUhqMzZFcmZqVEZzc2thZXdQUlFIdWgrNFBj?=
 =?utf-8?B?eVZqMHU5WW1tS1AyTHF2dDg5dE5BLzYzV244MGw2WkhBQ24rMU8zdHdYa1Ji?=
 =?utf-8?B?eWVqRGtHZkZzNmt6eEdKZEM0MXF5THQ5ZWZ6WGh1b1h6Nk92SUhNZ2VFRFJk?=
 =?utf-8?B?MVNMM2RwWmhOYzVYQkNDQmFlQmhCaTByaWpnK2NxdTVvM04rMmVJR3laenZD?=
 =?utf-8?B?eFFIb3Vlb0R2YzJ5aHFkQTdIei81ZWxHb3B4WnpnMmhnMXR2anBzRXpiQW1J?=
 =?utf-8?B?NmVDVCttY1VDUDNpOXRxeWI0VEx6TTFtQkJoNE9EdGxGRHdJMi9KSnlMSGN4?=
 =?utf-8?B?MU93dmlOSzBod0Qrd2NiVjZmOXE2MkNoQmhidjRrcnJhdGY5dnBOejMrbWdF?=
 =?utf-8?B?TnVESXVOY0pwcmNUTEhETGExL2JKYXJDSFdkdThnQTVBa1pVb052SDVUQjJa?=
 =?utf-8?B?TmdBYWxDeDdXNWRaYk1UTmpRRTNldC9Cb0lFZ2lmdGtuZjRzdVQ4NEoraU9z?=
 =?utf-8?B?NllsN3Urd1kyWTROdFg4NndIWlhqREV4SlYzaFBuWGw5NWtpc3JEOFduU0Uv?=
 =?utf-8?B?QStWb2RkMERHaG5weFlkenhYZlJwRkZFSWFiVHNGdXdMbHl1WHordC92Qyta?=
 =?utf-8?B?b0hnSFRVOGtWb2tZUnloYjZpaWs0MnIxMC91ZXZLamtQb0JYZmpBeUhtTDF1?=
 =?utf-8?B?L0RLMm9xQ05idmMvTWZETlYxWkNYMFJBODV1RmpNQkxSdW5kTFg1cGtwa2JQ?=
 =?utf-8?B?WFl0ZjFXazZqR1J4UzZ1QTM4TTI2aERlOWhnYmRqVXA0anpzTnNBamFDS3Rn?=
 =?utf-8?B?TVU2Q3NBY1MrbzI2M3NzWWZkbENuRmhYRWI2dzM4Y2FnOVlkbUtSK0docStU?=
 =?utf-8?B?aTFDaTZmYXVCMzNTYy9wd3hyZUZ1K0tyMEFtcW1KYjRuS3VwWTFEd0VDRy9M?=
 =?utf-8?B?bGExWUZiZWN2Y3lkazUvQ0FTQktvaFhKMnhaaE5WSzZyT2F6R0JWczQ4S09q?=
 =?utf-8?B?UG9nQkxuSHZ2RllwTkJ2TnFXY29DK1hwaHVpa1FBV3NXWklQRjBScWh2SjR1?=
 =?utf-8?B?M0FUWHZuMDBWUWJudS9zdHE0ZFNmR29Sc1pJbUYvb2tvZUFTZU1RMDlvNURv?=
 =?utf-8?B?ZnBkRFVMUUF4K0lJNGw3VnAxMGI5eWRhbjgwSFg5ekIvazl2YkM0RUxjcE5K?=
 =?utf-8?B?bmZLMElDeWFNVjFKL0NTbGhyWnNMM294YWJtbGZPdkJXSTZiWHdreWQrbm9V?=
 =?utf-8?B?NWFQOEUxNFpLWndXaU10S2JIaEwyKzJkRWI2UUlBN1V3WDh5TXdMemJCNlZz?=
 =?utf-8?B?SXB0MlRnME9nelduNU0zaXY0NDlZSndGZ1d6M1F6eUdsbHcvMVorMTI4Q0RV?=
 =?utf-8?B?RzQ2d21CNTJwOHR6ZnI5Z3VYanRsRnVsZ3EwWVNqS0RxQk5uK2h1ZHp0dXdl?=
 =?utf-8?B?WHZlVDlMdUs5Z0pmRkRXSVY1MXBtbTdGU2NPb1lBdXVvSDd4czhkbXV6NUx6?=
 =?utf-8?B?STVxQXdjR0ZIN3RFb1ExSUZyVjRKT205Y3VVYlVjNlZ5S3JKQkoyTjlOVldt?=
 =?utf-8?B?WGx2ZWp6cFRFbmZSR0hvSUZjQ2FuMlRFT0RLWGpwSm9GTjNYVmIrbE1vM3VD?=
 =?utf-8?B?UW1CN3RsZCtoK1QyZit4bHlmM1BrZGtMelhSaXZkL09qVjE1M1dlN2pFM1cr?=
 =?utf-8?B?TUV6b2tMc0hXWUdrWE1LQ055SEFJYnUvcDZ1VWRjejh1cUw5VVpqaDF2NkF2?=
 =?utf-8?B?TGJPeG43YmJJOWRkQWxVeDNMbHBOSEY4L0V2dTBqdnlrdFZ5WFFQVEtzRkcy?=
 =?utf-8?B?Q1lOVEFlRjhFR2o5SEg0TUpmRWpVSUVTZG4zM1hjb0pZNUMrM01WNm5sT0Y5?=
 =?utf-8?B?ZHhaaHgxNXd3Q05jbEVZTHJFQmY2cUFRV1pPUnpIdEhPTXpHck1ySkdQMWM4?=
 =?utf-8?Q?6u4jqWHOV24MEqB3k7+Tq1vWKpk/BonjCuyVH?=
X-Exchange-RoutingPolicyChecked:
	dGzIollfdwZTX9SGzwOsAi45UgAbxJUISC+59yd4QaLGEJmfCfgc6ICSiKEf4/6IubYA6w4f/W6q3xp4qbsRe5QA21FKWse+zAbnqGL6tLmiLSVsaqAW7TRSKusPj05DxxG+fmV3rVqUd+ELQW6W1WkWVVmabsEjxGp09h8Bvke82k/2juUGq31Z2e1X+0IUqMuHWcNU5dfVTWvNDxGIoY49sX+/aLjXEwN6Wl0bse2mN7EMmd0EdFA0n4eM3FycEC2c0qh0vzWQeMH7LBgyNgGsYACTKGUtumIrnCg1l4s0TcTboIXDu2xoFO+phrOOlzotKTF91jNvOm2Yz7g3YA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EQ2RF5uvGQkkv5M0y7sah2UMTi++nupIcSiEyVzvizwdi/M69BwEuxFredRVf0mX7Uqtjr/FOFgNLAMQm33uRxmroPwb6v+xNp5Tg10HO9qU8Lk6wiS+aVsDPzmLekz8eio2/QXEx+3TUuic3vgnJlTe7niRBqA0D8vzxrI620ookcsRjiguNzuDNu5tua99zVTtJu0l1FYm/Ry6vMYHU2Eb16keopVU0l0dbLtF25g7ZtnMkKS4skB+BcUqR9r+529ZQh4yTf7JfV/9Tw9LExy93z9S3LJw0ci9P79FHhwETEdnTVUVPypLkMBbP5/9s5OQ70aSu1VKE6PaDR76kOZEYdbftq17+/ZeNrKDHW047b5jPsQ9qvjPse17dpGY4gYGvDVqb1O730fXEH2nXZeL9QVOtRB1V84TtY9enQvoBRSJxIFXvn3amXERklL7yqj4iOlPjjn0+l7ugnpmuMbFDLOSaHQZvVP5mEzOyR+3tP7Xi0PgrNP19779OsX1pE4E3jDz2goRCoHwkBN0tncABCdAl5+lM3OwnoqUYFIkOJHriaREKm2s83y0DYCCkt7/YT3VeJ4aejiTgXMKSl5S69VJzW81aDTcCk85MAU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d474edb4-aae5-4c9a-0742-08df20cb8a33
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:24:28.1117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikJOT+WGqD4fUgfuY1GEX3l5oN7ZWsrKjL+hMnAXah1+w482UnAGdLc0qnhfcsRUAROpjpvPm0rwD3n518BhTKJQMk68AO/QGhMPNY6gvOTWyyuEw4vYJ7iVrgMEQ5+n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7788
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=690
 mlxscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX+GWFUu/rZI5u
 0noiPKHiZajA713omfhML/uxRUoO3Izjy5PU+nQcof4A8at+DJRGVIh7zK4vuLUmJQRfuGjH/Q0
 m6rmcwoFdqBLhuxtq9WFWOOXUOFVKgqaUq2n4DL72IWlevTRp71tJzeDG8eqHkWDmzcMz7gLx2g
 Kzw7jFYOlbacz2kKxakeXA43looHbg9hUFCTphEGTy0vKqhNzEQ9gdBABLlFMMWn4iKHWooW++W
 awKUbSOeglwAO6ks37sFpj/IfUHr4mqywQL+w7KNH2QPVowkizZSl3HZeifKiP0GWE4YXDUMYaB
 IDiGOrzbMm4D4NxXYVl3pjvZ2arcBOl1gHbb2S5MboiosrsInra34JXsTRq/1VBM3CaAXDGm69I
 1PtUwVKs11ZiS/eSxTzxKyq4oknemnp3/80sjM+axTWRe6ArqvqBwnhxlm0jLJf8QfXxzHNKrHc
 YXp753Hep1Z3xPbe1ZIM5/HgMmrvS5n3R9vvQE6Q=
X-Proofpoint-GUID: 7sezjWHgvMnFT6dS6PaF9bt5ymDaH4j2
X-Authority-Analysis: v=2.4 cv=T8QZ3PKQ c=1 sm=1 tr=0 ts=6ac02113 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=pGLkceISAAAA:8
 a=HL3alpDKAAAA:8 a=VwQbUJbxAAAA:8 a=WeoOuW8cy4rZ-PbHSAUA:9 a=QEXdDO2ut3YA:10
 a=KRX0AkppOCwXZa-dNZoJ:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX1dKfqoXG2ATK
 kFVhbuZTt2/KdMgAacGMeAD+9OGkBEmchZh76A5T9xQWaEKJUMUN0UOfGUrQ9oS2di8mEtgZ2fx
 OQ8OMfSTV36THado2dEYSlkV/RRxx5f8c1lEALKepqpkA6bYz1In
X-Proofpoint-ORIG-GUID: 7sezjWHgvMnFT6dS6PaF9bt5ymDaH4j2

Hi Sasha,

On 30/09/26 8:49 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rosen Penev <rosenp@gmail.com>
> 
> [ Upstream commit 39851b7e580a65bee732e5364f0efb974b242370 ]
> 
> Use platform_get_irq_optional() to retrieve the interrupt resource
> instead of directly parsing and mapping the OF node via
> irq_of_parse_and_map().  This is the standard pattern for platform
> devices.  irq_of_parse_and_map() requires ire_dispose_mapping(), which
> is missing.
> 
> Assisted-by: Antigravity:Gemini-3.5-Flash
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> Message-ID: <20260603192511.6869-1-rosenp@gmail.com>
> [Handle a negative return from platform_get_irq_optional() to mean
>   no interrupt is assigned.]
> Signed-off-by: Corey Minyard <corey@minyard.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/char/ipmi/ipmi_si_platform.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_platform.c b/drivers/char/ipmi/ipmi_si_platform.c
> index 505cc978c97a0..f7f602067a574 100644
> --- a/drivers/char/ipmi/ipmi_si_platform.c
> +++ b/drivers/char/ipmi/ipmi_si_platform.c
> @@ -279,7 +279,10 @@ static int of_ipmi_probe(struct platform_device *pdev)
>   	io.regspacing	= regspacing ? be32_to_cpup(regspacing) : DEFAULT_REGSPACING;
>   	io.regshift	= regshift ? be32_to_cpup(regshift) : 0;
>   
> -	io.irq		= irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	io.irq = platform_get_irq_optional(pdev, 0);
> +	if (io.irq < 0)
> +		io.irq = 0;
> +


An AI assisted review flagged a node-reference leak in the IPMI IRQ API
conversion. The call-site edit matches, but the newly selected helper
has different ownership behavior on this branch.

Upstream 39851b7e580a releases the parsed interrupt-parent reference on
both post-parse exits (drivers/of/irq.c:544):

         rc = irq_create_of_mapping(&oirq);
     out:
         of_node_put(oirq.np);

         return rc;

5.15.y returns after successful parsing without releasing that reference
(drivers/of/irq.c:409):

         domain = irq_find_host(oirq.np);
         if (!domain)
             return -EPROBE_DEFER;

         return irq_create_of_mapping(&oirq);
     }

platform_get_irq_optional() uses of_irq_get(), which leaks the parsed
parent-node reference on both mapping and no-domain exits. The previous
irq_of_parse_and_map() call balanced that reference. With OF_DYNAMIC
refcounting, this new unbalanced lookup can retain a detached parent.

I think 5.15.y should take eb2b4ecf7299ee39ee9cecc4d3f2633aeb10cefb
("of/irq: add missing of_node_put() for interrupt parent node") before
accepting this API conversion; thoughts?

thanks,
Harshit


>   	io.dev		= &pdev->dev;
>   
>   	dev_dbg(&pdev->dev, "addr 0x%lx regsize %d spacing %d irq %d\n",

