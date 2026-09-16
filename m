Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF194D9577;
	Wed, 16 Sep 2026 20:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591121; cv=fail; b=HYOOkKV+soClSf4T+oX9mTkhE5xHsUkY6oku/h8P/foPdOfIrWxo1XQ0wQO2bAEZsgaW6bP1lqqMrR2Nsl5mfLsErlQwRTIvqh74+27w2LrmI00G8kHV8SVAKynYfXlVNS9vhd3AbktIw77A5JP1ajuzovNDzaU8X83yn2aqeNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591121; c=relaxed/simple;
	bh=kKyDMKenNZ4WDG9q33B6pxlHwsVy12uVhuEqMHur2IY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jg8TlQBiChWZdiiOKqqmxNwwxqaRWrCdENCOA13f+er4AyvBmXpV5NfdH3HDeotlaIkItnr6fe8QIFbzANmzkwz5g8D4+m30q9AxmK0LdW+woQ7RwKfzyqMIzI8fLLdZ9leyu5NPlty41vmdXimDT++1kkjZxOWY7HUgQtlxQjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KAwgZCsN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jejZT9WM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KAwgZCsN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jejZT9WM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEBtrF3775481;
	Wed, 16 Sep 2026 20:38:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kKyDMKenNZ4WDG9q33B6pxlHwsVy12uVhuEqMHur2IY=; b=
	KAwgZCsNH0wHxzR3BcfioErXNTDWpJGfIlfHgrxVgrcK78kgwV50FWXM3Y6zUFqw
	ZxKWfdW2I9Ie685wEwFnD+oVhMcMI6JHDtRC6mLTMqw/BRyI2f0YiPFG/isjuNEK
	ylS4adrBcK8v5042a33LviIqACkoDdMj71qXMVz7AcXVCP5ce6jHfRMnccgNT3uv
	wJnyG2Jwn+SBMHLUtRYJ03WYz3yT4uWqojbGkQ6zD4EBjwT/oeoSBZDVKSXHfhpC
	xSLaAnuFubyS/eNoGKeWB30cuDa97ICNWgC328CC+BsR1YePd2t7jAY6/KJG+Isr
	1n9CEkL5Tl0I5F5bESgLzw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxsbpe2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 20:38:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GKZQgL004681;
	Wed, 16 Sep 2026 20:38:04 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6r0vrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 20:38:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txRFbp1GWIzxvO5Ng27f0/PrjxZug3egmK+v77hgB8qhLoYjdUCQ8QHoGjAMctbZrCNV7GSbFIJOVgA0chWKYvenf7hF5ZLseEQvR9DSS+p5NnxJusS7FFoMLzCH7MizTlBHQ3fKs7vuyPqdGdAiY0Kws6EWLdFsgHmAUE0qn6TR4pZQQD9mvF4uZmB4ohrMYZGz68Yr9AYuBF4iwoimyij5Ul+ac3QCYoMFqVrdh2Ke5Zla0qRfh0UPlhWZV/fbIkoSA/+2R/SNoic3zHBGpYhpYqifJmkM+JAguyfPZcSzC066ZO3Yi6OSUmdKhssWM/HwiLql8RNgRukWV/aHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKyDMKenNZ4WDG9q33B6pxlHwsVy12uVhuEqMHur2IY=;
 b=FAutPmRU85k9tEfRudepSvvj1l1qOkamoveY3ItcN13+RqrRs3N4VKXOLeNgtPFUtS+iYa38+80K4fLUMXD7a45r2opQyBqmckl7jARWKoVr2opwmPIW2GeZAH/0zyZzRXlIOMNi8Rt4BreFzZuoD4xcSiD6bfXnQsfksyEjxKzg7TgdeWM5t/kug9pd/Emi85qb7rIPP5bsGp/gGnvM+Nl+ar09Nnp/u1bNL6KPLWz7dwWn8bcWc4wyVM9uw9gyTbj25A8338csY3LWIopyfPlHGruQ+ZsRmiXGr6Q/jGIJW1whBJH8F/Ug50JMoZR9gevnHbGkHS/PmaRNYxaBPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKyDMKenNZ4WDG9q33B6pxlHwsVy12uVhuEqMHur2IY=;
 b=jejZT9WMIuGtive4SyuPiUMrXJL7SbwtPsKNctkRDrySKsMr7dusig2gmFqE5nCBoMDd4qp2RH+eU0G6p6N7d6f0cLL8FDKHdVysqDZyvKyW4TN1ZnKwqP12IRacACGsGDR2z6jeCgCrF33h/xN/B6hHlW5kXHX3kcQ8DrLMbJg=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA3PR10MB8707.namprd10.prod.outlook.com (2603:10b6:208:571::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 20:37:59 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 20:37:56 +0000
Message-ID: <d8c3ff69-8b16-4071-892d-c0f21dea7d82@oracle.com>
Date: Thu, 17 Sep 2026 02:07:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1269/1376] powerpc: Add preempt lazy support
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <0de39bd3-3575-4955-963c-b528f81b7fa6@oracle.com>
 <daily-reply-20260916-0019-re-powerpc-preempt-lazy@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <daily-reply-20260916-0019-re-powerpc-preempt-lazy@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0382.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::20) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA3PR10MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: 249a6173-9bb5-42b4-14f1-08df1432635d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|4143699003|22082099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	gGehOGWKkSEN/7p+2YG4A+wKyRU+5WAcp0o4zRfzWe+p56vms+KLJvyRu5HnbX6o9IJUBEnGsRXwWc0EkgEidrePgH2TBnaoBeIt9jP1P43sz21dkfz+HswslzLYFKekcLJeUSVNPdwg2upRcDz2MZvQ2Fk5r+F2VavnvLoKbLiKLHpeySPSZ0gWodWj8TJKOshUOrWnIVemcqTjD1BZRuYPpwKsrFNi7KdDdoGsAerbNukNKVrRM4U4vS8y2klikbPbNDk9x2SxW7PXovkUG7Yn3a7EJuHBUe5gadYUzwOM00OZLBgCVPTf4GbGf2bEDzGznt7P+PqbI33WspKyXf5kw6NnyCJXAvzdeK0ewlodLWXlw32FIxdq5PTuMjMQQRtcnjHrsu4OqSyydxrtAERM4rXMQNp9prH1cb2J8qWP7B08Z5tY/7iygnfyIT09jr9+V20HM7KsUp0ggrV/VaZwmrV+oQqhuAzw4TRBxkyQ/EqMnQ2d34ljl9zQVTJxrg879unQrIuvZ8lP1K8Oc/urjYJkSYjBG5ALo2TqPLzXmYmyIUttqBy9QcaS9pu+UFBfHdEGrSzeLiHUrjDkFLcUiSJVkA+3p2mEBD550ebqmsUDDx3UWDMAXlyuPnZQDx4RUeNuxxz4PgrK9aKGaZlvE94+LwhEcGnSlUmaSJo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(4143699003)(22082099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q21CL081bVk0NzliYzdtemZCSk5qa3lHSVpDTVN5RTh5ZWIyVnREdXNXVnVj?=
 =?utf-8?B?emV6MVZFajhZNFZBdHFtM3AxVm9CYUhZYXBMcXdvM1YvY2VKVVoybWJ3bUZU?=
 =?utf-8?B?NjVyNUhjZGd4aHBMWDNudFpVZkhGSUErNnc2RUlMbDdjNVA1eHMzajUwMFQ5?=
 =?utf-8?B?VDVVWUtpK2VReW1qOFgydEFoTG5odTVIaEkzbWJLQ3k0ZEVXTFdRVUFXcG1D?=
 =?utf-8?B?VHFxR3p0cjNnQ2IyeG13c2VvZ3NQbC9vV2hBcnFDTGNsTWYwS1ZPUWc0NlJ2?=
 =?utf-8?B?YWxYTXMwbDBxNnZ2UHBxNklqZUtndW9ORUJuV1VsdFpaSjVoV2RhT2dzTnNP?=
 =?utf-8?B?clFhYXBiaVluTkRlTHNjb09UTmZyUFZycllML0ZuR3pWMGRHenpDL1c5ekdy?=
 =?utf-8?B?V1BwdHozaVZHTjMzVFBQWXpVQUdFcENLODZDUUU5d3lJN3BsdjE0aGNGVVBK?=
 =?utf-8?B?OHJoZFgrSGtOTGRXYUlSVmJEZ2JYenF3TDRiemJpR3ZmMWJQL3dtTGcrK0F0?=
 =?utf-8?B?eFhvVy9JaHY2SStxSXRESDVwNE41Rm9nTWpyWGVva0lkT1Nud0x5c3dYeFFx?=
 =?utf-8?B?c296ZSthOFdzdUJpdTBqT0RURTlWd3YxU3NHQU1BVFBmM0lHVTh0OURzUkpB?=
 =?utf-8?B?NVRUeml4MGtVaGlMNWEzSVBGb1RaMnhkMUMyQmtVWHo1KzBVUkczTXFNNXZ4?=
 =?utf-8?B?NXRRSEQzUGZacVVNbHU1M2RjMHdkWm1Gd2prVzFibUluNTlEMXdsNThRNHZj?=
 =?utf-8?B?OFJoMEJrbWM3aGh5aVJqQmc2T3ZoenBEdEVYcVQzcmJWKzNHbThFNWFhdDdy?=
 =?utf-8?B?SkpMRzdBOGtHZk9pZ0tTU29vQWZlT2F1RGVJWUNiVVpicWVpRytNd0tuUTND?=
 =?utf-8?B?UGErMGxLQzF1MEg3N0JDMlJ4NlpMVHR5cHkvc2lrMmhEZ3BDS1draVd4QkpB?=
 =?utf-8?B?S2w4NlNhQ3UrbFBxdlBlRnNiM1RPMnhFd2JudGxzeUo0Zy80YVV6aFE2Lzlx?=
 =?utf-8?B?YTZ4OTdBbWlUbjQxdU9qWHAxeDU4WDdNbGR2a0RGNkhtelI3ekNNbndDOENv?=
 =?utf-8?B?TkJxbTg0eENqYWtFME10NEo4dFBYa2dhZ2FsdzhlVTRzSEtNR1VoNEtWbVNR?=
 =?utf-8?B?WWdDMmFMbUVRWFZwbE1ua1dnU3lLRjBCOU9YMVRlZWVlVGRpSnYxaXZNdkFP?=
 =?utf-8?B?ZWtHNlFhUUYzL3JzVmQwb1phWXlndlVpbkg3TGJBZVM4VkJhTDBaVG1pZzRI?=
 =?utf-8?B?QkFldFhsWHVtcUdwVTVpbzVQQWF6YzFlU0hLcG5ucERWNGJ4Rkx6QVR0R3B0?=
 =?utf-8?B?MTFnUjJnRldZOWN6NFh0eXRxYmdwbExpTzRGY253cmppT1J3bEZ0bkJYT1dZ?=
 =?utf-8?B?SHlCQW9jTTBnQXZxU0tGcWF2aTIveWVucEg5Qnl0MnIreDlGK0hEVThBMDZF?=
 =?utf-8?B?TzJxaWt5TXZ3bTRLcXByTktLZUo5Tkphd1FQdGNycFZUVFVzc3BVSENXcXZL?=
 =?utf-8?B?SXRuREN3TmVxU1UzQjVNYmhWQitqcjZMZjAzQ09TU0hyWEdWMWR2TnFSRmcr?=
 =?utf-8?B?WWErSG5BWUNrMzd1OFl3TjNhRmg2Nm5XNDB5R1JGOW81d0NYS1hMVWZKYitt?=
 =?utf-8?B?MURkUkxFR1QvWHloWFhyS3lPZ2Mwa1ZRNWxLU3pYNlB2T0ZVTk5McnI1YkFj?=
 =?utf-8?B?bjlYUnIyaHgzRTB2RXg1QmlaVno5MFZ3QURLRUdsUGlJVVZFVG9LekxQMnlh?=
 =?utf-8?B?emFUd2RiWlIyaEZuZkNYbEJ4TGdRNWpQYTdTMnBXYnMrcmtKZUh3b090QmNu?=
 =?utf-8?B?OWlQVzU3WUJXdmZmOWhYajRINElmcXBMVVpQc010eThjMzl1UCtRemZNNmlj?=
 =?utf-8?B?TWtmY2lOanpadHRBUnVmTzBURnR2RkxINzhBcEIwRHorWWExV1dwaW83Wld3?=
 =?utf-8?B?NjJFOUgxYjFCb1pRK3BrSmgrVHhpcFFDZGgzSGZHekVMcG9odHR1QUdWRDJY?=
 =?utf-8?B?WEl2cTZkTysrVXJYblVWSU44OXVEQXdiZzZxb0N1UDRtU2c5eHFoOGxxRVBy?=
 =?utf-8?B?RndqV0Z4VEU3U1QyTkphNldkdGZzSUtCcE5WSUU0VkFZV1ROallGL3p5T1hD?=
 =?utf-8?B?Q2dRYjhyVnc4bXk4S2p3b1B2aSswUFZlNVhXZS9uRklEK0tQY0hkN1U0WHRD?=
 =?utf-8?B?cll2RW1vbXMwSzVpVGRIaTJ6azdJdG0xcUV0VkVQeDAvNS8rTFMweWsvRW9P?=
 =?utf-8?B?M2NHeUZaNmhNQ0l2cmp0QWY2aUsydm9qeHIxbndjYUtKWTZnNjBxcXNObjdr?=
 =?utf-8?B?MmYyZTJhbkxMTU1PWG14cHVMZVR5ZEZmM1p2VWJ4VTl5RXEzSmhHdDFuRE93?=
 =?utf-8?Q?Wd3OmUxLaI4omHA2jVlfN7QE7ufwosxdBoPcJ?=
X-Exchange-RoutingPolicyChecked:
	CqN7pPgYEWcOgJU+Tw4giCVR4gew41/zF7qvpkAg5tPklF/Ns9+No6HKKZFsPQjCnKDICCNVAAfs+0xS48SyK89YvJExfLnVN0a0UI+f8tjzwRhxRdvjzKdycTJ7jEZH1NJmF0cEQgGydsd7uOqxU2gUPmohxtk+ezJwsyp8dVIT+rk1NXh9eiSnmaMVuwlNJypICq892Th2o8VBIio7jWLCbqkoIdF8bIyPUxRlqk+FP+VA9bitIHDWUKcfF9/AFj8XmeGjUnHLjv0ZW5HayPXTJ6LZ4xi7+cCKmftL6LzPq8mMk/f5BFnuI0O3ryID3Fiq1e+3WWVC9g6iH7kgSw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	17SZzOaOyggO+i9+ptyLZZshdBygYLjeAtv4urSDXsN4sj05yyCMdOyIvYw9jqWXCXPPLQZdC5zx9Ltri0oPRIaCJsbo7exIXf/lJJzoy5FrdJUyYb7ffNvCuRCmLY18TkTzFUqXHQvPI2n7XjImz+am4yDCvMX5UeDpnuDbsBsdUnCrC5A61snwMpYGMDXzLW+AQMXDbQRonQoYHNmzyLvjmaQBUxCHz7P+1GsDZy52EEiSPHZvJJUCBFws508TLGMvYXtoveqgCM/D4Ddr7qN5IRwXNp6+7h1K7VBRKUMwXkx8DTxtprYa1CM9EjrFDAQHDR9cAREAbk3Azwx0lU4BDiaXWvGELFf3npVVYHAplthX+jzA/HWVZ4R8xLospYbkKG9KDnkH+1Ug6kzhIbE1VFmm53UycDsyWokJAHlwKI1eHpC/upykemml0uv4mX7BAi4o5s6atm+d1wmuHXQA8TF+Zg2mwCzm2PcdQhmgWm4JQGb7g+PZ8RC2v/6MODPmn0sNac6WcX+tWHOQCGABWouu/VBVchZ7+LrrCFav2P2zAPFlEuQNIq8/MeDZTFuZHAGtL+t78DA4rBMoPrWcimTJgSpdEhKoJsz5cqk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249a6173-9bb5-42b4-14f1-08df1432635d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 20:37:56.1044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSptvAr5G0EO+mE4P4ZQSnN4jBkW2jfxXLHWAp8UOwKpgjv2Vb+cevLv56WLAvHc3v+x6LrDN+GlM6OGVV22WeVCAVA5+BVWD6+8TLtvyvrZkEUeaOcEr6wx7LK8WE2H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=941 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160286
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfXy4Ej6mzr21Uq
 0GyMEQ4b6D0axW4oHlGWMiIMuKs98WQrbRJ4ydOTOCm5hGVRRu1WuGblfNef7p/Y3g+UvSLujoc
 ePblZTemGNkuQ5h6fWrBLL81Y0+iC9KHgzeZqQPeyQsiP/1pdDduJylVlj7Un8KcW5ZDxNQGqyh
 u+t0GUPW//K1hojXCXbSaNsH37SNDblv24Roe145g0S/bhJobpefJ7KtTLuCutnjPx88ipNlAiI
 CZKKCVqxzsYJ26KciaW0nzYij9Zej1R0cgEsz93wqlMElkF3MPmDTNDlt5MbkgSRDvDzwtFTYt/
 Mx/XjeSa/bExbQZtB2lyh7sjsxURKjVcYTmv7NAyeIsnIAI6xMxhBR8nwGwG/7cey09RkqC6Pc4
 q/ZMpaflMa9B0gpf9lAoT4O6CIRZlSpHp7oNKK0aNLupP5Y2dkZFSHT9Xab0BUvUVhX1bgdVji9
 w+x7+gOqtnssz3OEI1ul3+nqYRQFI82lIQfTNEJ4=
X-Proofpoint-GUID: jNW3QgvIS2rMacMVy2kLgG0Sdz9573pb
X-Authority-Analysis: v=2.4 cv=dY0VTnXe c=1 sm=1 tr=0 ts=6aaafe2d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=PIlaqZLDv8Ke_CmpaCwA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107
X-Proofpoint-ORIG-GUID: jNW3QgvIS2rMacMVy2kLgG0Sdz9573pb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX2oDgPblqgmRU
 uO52gUtetSKc6z6rkM0aZx+cYqatQJLVL1GIA4XDT+zP+U7aFxbCCwqhHSf6EUZjts6XlVv2mLG
 R0HhL1OsKHxOH5+IF/QnEfSilFd0rDwa6bGR4YlKmwKlgxmVLqxf



On 17/09/26 12:58 am, Sasha Levin wrote:
> Since it is released and does nothing observable, I am keeping it rather than
> adding a revert.

Sure, thanks.

Regards,
Harshit
