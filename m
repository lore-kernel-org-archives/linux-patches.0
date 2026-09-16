Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56025473C73
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547321; cv=fail; b=mHFlNNm8aMV38iSHqUG9JgWj8zZmKgQJrevq9XB182VcdWRkq1d3CHhDxjLZiSA8OjIdSzeXn2eILOVlf9EcH7N3WrAYkAtScFvfdqiJwvPVUDgC2IDpk9wlx+Mb06LjVRONm6hoNj+TOa8LmkcqcmgTBQXwBMY49iiHvifS6qY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547321; c=relaxed/simple;
	bh=3v5d6y4/watVu320Il3WHNrCB7Q7cUvNPRu/XnnE5oo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jnp+5EkCZ9C9m0Q7WZS5AqAmebhyLQlo/jI2l+FywFzypi+Ue/QRGSozXuJ/tBeinWdpoNsulFneVPH/AwEkWrpFyaZX3ifLYZzN86RMZgz6EOSRqgbKsJ0UzOzjEpFGFYI4AyrY93iUYeuMyXUutIAyQRnGEzGlV0n/pdD+tq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EFC6g+CM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jmSYVV6N; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EFC6g+CM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jmSYVV6N"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWXPV641222;
	Wed, 16 Sep 2026 08:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dl+7NKgRW+n5HhxdFe7BP34/QYvs8IKmftH9JG4ZW84=; b=
	EFC6g+CMxAM/lE7uAeA6Q/FyqinMZoVz1x2LYsRYT59yCt2z5isBH2DG6s1osBf7
	/jOePhA0LJRo7rBmWcjM2cuOR3EFGXCTzLnhnzTCiPYornT8Xa721aAIm9JJ6X8q
	cT0FnNhtxlvKIuewRQgb9HW6MiE92bgdlYp20XLG+noZjmaH+BOgdADL4Qy8jcyn
	sROUgHtaDJebYwN/lNCtOybiKPbmlxQ+cGMu5y0p5naBGuu7huDWtLLhwWqEDb63
	Bu0rwDNK9SGqhJp4sf/PUo/iJkXcjBf65II+F7bttPUak1wxcIditV0h4pJUsVhK
	PNqdJgGdYrNPlFwGKZEMGw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs562u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:28:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8P4sW026708;
	Wed, 16 Sep 2026 08:28:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6b383f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:28:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=At1QQdV7dRGZ6QxRVX59s5H2hCSLAPZxZw/YC/BS6MAqGnhJyN3sZiP/QOb+w4622huqgzVoUz0lbmrU8uBbbfboa+ZCf2rIlpCXvXYCG3k7KOxjrS5k3OP2gq/jvfCS4PbcyzEqX+++Cf26rxnopPzzibYYGvBlQEsFw8HF9/0mNOs3JJUHm7KDn3ilVJAp0+dJl2r8FigafbdQPTp74MbYppeZcpYN1a1g8pqX/HcrAb3T3gvk0jk84lobLH3bEzohpqBdgmF43X0ddSy4Zo1kzKk/iXuP3A+7APUxM8WZGgJtE2vdgieucF6Blk1sQCKGZnARASujjJMtD3bAuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dl+7NKgRW+n5HhxdFe7BP34/QYvs8IKmftH9JG4ZW84=;
 b=nRAiMTYj3zVMLV39fVlCnd7W8qPqa8Q+tAdelfc6D25tCtgoSfAgtxkd8ZhFVCVi/ZH7CoqYOMDYqBy1hF3XuLBIAqGPCSi/04sxTa3L31I6Dp4bbGZSY5OMSUBlQ1znA+OEeCs3T3x2QeWdNJoFNfrOufnkucq3INojyZXCKpWmc+6R++lLr+IgHnaw27q2F272JZDcNCE223jkGHl2aO/t+OqCvgcKgd9d3pdpuq9r8rNu5RZ/Zj4MxFqDccHFWRQvAe+tSRE6ATOdAxoNXZFIX+oo/elE33yAL1nZAJMKkz/pELrzmFq5/z8XN2DL6X+j5I63tPw7xB9FNy2IHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dl+7NKgRW+n5HhxdFe7BP34/QYvs8IKmftH9JG4ZW84=;
 b=jmSYVV6NxtJWPxzHr6kmstDvQ8RY0AXpvfVrB16j8NNXKYrq902j7AU1HaO6XPTPItYy2Q5P6HfvCK3+57Qcebl8rUeVcklwGDPfZvMTdToNiwovyVvPW/MRgchDQQbB0OzE9s8G7zYbeYY78n1IqleuZexeeWYuMHDgcHHNXSY=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV0PR10MB998113.namprd10.prod.outlook.com (2603:10b6:408:398::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 08:28:19 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:28:18 +0000
Message-ID: <e7df7b15-c374-4f4c-9928-e8c4390cd1b2@oracle.com>
Date: Wed, 16 Sep 2026 13:58:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0975/1376] block/bdev: lift block size restrictions
 to 64k
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Hannes Reinecke <hare@suse.de>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Christian Brauner
 <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065629.297388116@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065629.297388116@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0017.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1e::20) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV0PR10MB998113:EE_
X-MS-Office365-Filtering-Correlation-Id: d93f7805-4940-498a-1531-08df13cc760f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|4143699003|10067099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	koYpe2+rjhiUsrGikiLDvqDXsV0HUfep9uPv3R+GqbFrCxkTRxQesbFNJe1Zejn/zhTWmutmuCgBGwLGIREw/oh6dwFKzzGFNnmGA6zHcCN9LrbqXrJgHjHO2fIc/Zb5zte8afo1k0MoYhtbeEOqA5wgS012NBMhLJ3jS/WIpss8lXZBqn8FgzUCE6T8lyH58kiS0AiAu65fzJssEnkdPRi8ajMPyVJ55wIyIfY9072yzIuhs9uDZX4DhAL51G5BHrR956CfdqOAgiSm/sPh0WFrKPObhXTGCltkNLOp9wIniz2vpnoRDmgICdKYEsCkR4XbLTi86gbWfhzLmU2of1y6Kwh6lt90vBuzeFhyF3pbtKV2/RvytqwZHgfUIEihPR5EjVAitjvUMidCOUHDH27bRCq+XGKjRHufp5U/tLKpPMKibUIyau12xj+zL22cDq77x+EzYRkH3kTLRaODI4eJW/1Z92R/r/0qhOg625g30NiraWAuEvswWtIs0gBKdd8MJsIaCzkD0EE0lfVm5jDncqHhG/JWhk8GT0JqfIh+uqq/Ag975B1rsliwgV1fJn1q7ttmdp8Lc2eg8KqJcMwPKiNdj0i5ZkzmOFQtS6WFqC9lUS0npZiw9B41PYkmaPgaUvKUteSHgxMZLOB+RCPFF2yhuYpYeRFaNRa+qY8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmRoWjVsNmR3R3R3UUZQZzZIeENEb1FFeXVsUllYUW1obi9qS2RtWFFMaU1a?=
 =?utf-8?B?bmpwMjdTL2t1K2hOV3ArTjY0RkVIa2RGbnp3N0FEbnk3U3NTNiswM09nYkZX?=
 =?utf-8?B?NXI5cTlYemx4UXVJbzVtZzNSWEJiZ3huSVEyUWNqOUpRZFp2ZDQ1UzBOcklZ?=
 =?utf-8?B?RTRPQkRET215aG8xNTBVWDc2VTVFNlNMaVV5L2JqNlZDSzhRUmdaM1pGK1JP?=
 =?utf-8?B?MWgvN2JkMm8xb0Y0Y3FvWGhaK3ZIcElsQmwwOGFJZVBHMTJNbHZXZkFwNmVP?=
 =?utf-8?B?L1V4d2p2d21teDhGYjI4ME9wcThWNkF3RE1ybFRzYU9LWnkrcTF1OUpLMFpw?=
 =?utf-8?B?aEVLUmdqempCQjN2YTNTdFZ4U1hpRzgwTXpsK3B0UWJPVGNrNWxiWWZ0TE5i?=
 =?utf-8?B?QWZ4QXgrcWNLdFJEM3U3M1k0cWdRQkRLRVVBQ2tTVytKaklqbkhRenl5K3Z2?=
 =?utf-8?B?NHFXY1UxTWNENUpMTUJ6Smh6MDIvcW5pajZPWDF2aCt0cGhWVnJTd0YzVjZU?=
 =?utf-8?B?L1ZCZ3l4OHAyR2U0MS9rUGxKVW1oaTVSOWZGWkJ1Q1k5RFdMTEZ5VWRldWRO?=
 =?utf-8?B?RHVwS3czb21QaGhjZnBaL3ZqQkhwRWlWMThGbnVVQkFNMDNUclpGMUI2UTdw?=
 =?utf-8?B?eGJVajFWMmhTNWE2b0VrVjM1TWk1ZEtabkRhU00rUWdlVnFxVmg5Rm9ISG5N?=
 =?utf-8?B?Y0Nmbjg4T1hTVmRISUhCQXJVdExEUGh5ektYS0cwejR5bTAxcHNUQXJGY3M2?=
 =?utf-8?B?amJwUkdXQlZiZnVSZmxTOFovdUgwTjhJMzJWTkxaT2ZwUmJIZGxGVm44NEdO?=
 =?utf-8?B?Z012ek55VWVGbThrc1ZoV3ZJejNuVEQvZUtuaVNnWEs2VUlvVC82bHRUQlZK?=
 =?utf-8?B?TzVMYXMxRE1vSW1kZUpFRlY0VlpJbFFHVFJNcUVZZlBoNk1UaTJaQ0tjeW5w?=
 =?utf-8?B?bGRWa0kzRG93MlJ1RGJsU3dBRjBaSTJ3Z2FnOFFoMmpqZXFlVlFmY2VMb2Vk?=
 =?utf-8?B?aldrYU16Vm9qNzdaWVlpbHNGUUc2cXBQa2Q0cG0wbkJ0WW1sRGhLVGxuMHpE?=
 =?utf-8?B?ZVZlUjFJNGQyRTVzeEhmcTZRUVVrTGtucnBrUkR6bDBlS1l3enhtZ212ejNh?=
 =?utf-8?B?WUI2SDBldU1LOC9PRkUzM1d4ZFpML0pVb0VNdlZrVmJ4a1VJMkNCSU1yNU9I?=
 =?utf-8?B?RUhBWE93cUtVbEVRYkVQblQzZGk0YzlhWnVlQXV2U2o4b2s1RTVrSzF2bzVK?=
 =?utf-8?B?Q2pwY1krY0g1U0FxR3BSUE9EU1JXTndmZGV1WXQ0by9mZGcveDJmUjFyS0xq?=
 =?utf-8?B?cjQ5U1YxSjhZem80aFhneWR2eDZwSEdyZlhTc1UrNVcvdTkrZ3NBYUY3Qjlx?=
 =?utf-8?B?cmhYOVY0TlM2Y2F3M2Rsa1YwcFlSeWtjMTZEeTlnbitIWFhZQ0dZUVRRZjl4?=
 =?utf-8?B?elRkUUYxNHZLdDVXcFJoeHRuMEhvaTNoejI2KzJlWStzMjh5bmg4bGVhNTF4?=
 =?utf-8?B?S21oZEQ1MHdJbGd2WHQ2U1ROOUJ4MTdYQ1kxR1ZuVyszK2lPRzRkM28xS2RH?=
 =?utf-8?B?NnRpSHI4ajF5ZDNNeUQrVDgrdVgzRFk0eFRQM0JxM1phQ3U5SHJNdXFVM1cr?=
 =?utf-8?B?dFhLWlJEbXpJMVFrbTFUd2dUVnRCbldWV0p1Y24zUThscHE3c2FxV0ZpYm9P?=
 =?utf-8?B?T2Zka0tJeXEyLzN5MFJQd0w5aFZsejNhNTliY2lsT0VYZkEvdDlLRFFDSzBK?=
 =?utf-8?B?MUg5M0V4SlIvdmh0d2p4andsaTF2NGpSeS9OWGk3Z2VucThQUTRzSDZCZGFH?=
 =?utf-8?B?ZVZSWk9kdVFUYzFCUXRBcnN3Ry9LOFNLNVlrdXpLMGpTRmRabjF6NVRHRUEw?=
 =?utf-8?B?NjE1b2wyMjVmb24wQldwUnFHb2hmb1ZpNnZ5WU1TRnlLN0FFcnRpdmd1SEtO?=
 =?utf-8?B?NDBTczB3VlJnR0grdzBtTGxVMlplRU9FbnJNOWIvNzZocVVscFc1RjlNSS9N?=
 =?utf-8?B?enJ6Y3B3elQvaXM5RXIzTWZqa0lOTVExUjl1QTQrQm56a29wQU90ZWJIcHVD?=
 =?utf-8?B?V3libndTQWxKdEgzTUdIVnRNSWdtK2xnMVJFYnNOelNyTUZuZzU1TnhFa2ZV?=
 =?utf-8?B?QU8vejQ3SG10WFM4dDdaYVVSVTRNSzFhMEVIQy9LK3VZUFByZDdEODBNeUxD?=
 =?utf-8?B?a0p6cTBzeW8ycE1pV0hKVUpZdVYwN0x3MEhZSlBxRHkyK3BVWWNkaUczNDQy?=
 =?utf-8?B?dzFOQ1pDTFQ4ZkJRNHNHNmtJL2xqR1ZSeWJURm81a2FRb1NRMHpnUVNPSVk2?=
 =?utf-8?B?OXlEUzlxZEdnQlJOUGhFem56UStCdFQxWC9QenpVeE9nTmNuN0ZiUkhzbWFk?=
 =?utf-8?Q?+gQsGlbkaQiqZdH0ta5rdxvAsr7SO6pNmNJXn?=
X-Exchange-RoutingPolicyChecked:
	TFlSoSJWmt0B8JDJ6AK4tUAlELhBtO5XekNEo6dzEMTTY4lTysGXh6zbI4Gjf415QcuXfEu+puB6apXp+eMTLtoQHQxU1v7iDhPzpn7D1X5kvb4VCJX3l1xHVBqm3wq6m2KfG/VzBba+ahdrn7P8+rbwesZucB1GbAnD9cOsUNQEmVyBT1y30NhP4g4j0Vf6DWEzzvRkS+5mq7MqaZuVpY3AcgnqtNVcqx1FRbuCjBHKHXSaHsEyat03rikKoOtFRvtVkiviAhF6GjYgb961kDM8kmL1YKMeI15j/FUOxxS1yHnauUSm6seEJMM5wqtlftnBrqs+owoNoy8dzwnLgw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HSJy2k4+b02aum/durpkLmazM66cy0go5SA5b5IY5/pgSBMqANSKv0T41v8Iv+/kC+4Oo5FNYHgoPcOevFc5d6dZN6OdJ9i36KnTn/o2x39BctcFhsKXBBIqSYS8vrAMo6sW6eTO0rNB5XsbsU0gVVwcCER9lRapVN/soNti6xAXJ1Eqe/kjynkTqA6IvTuD0VTNlvtwMIsu7dGY/HdtaSIP3EpbnEya1A3jcimQgP6B+HxLIkU8y8ZBFUXpOEOzNyVqcJB+kR3IKJeuNThskAfpp3FizfDkd09TWoQ67rBd1nYC3dm2l1AdbqAEkX+5j37cl70esI4y/ZkObmqjqSubdPYc5618hog+C205pZds1AurjvuKVXbMzMIq5s0fl4eFBnP+1hUPwWft6au51gBBpjJ6qiqS3KKcSaNXZpPGqx9wblnUquu2TYJck1S1npfbmq3NyYdMOBTQXNie6zAD9zVzumb8zOQn/4xaP+L0Wq5so1ZpPwoiGoG/LsCo7VkdAHXe5GmvXzwpDQgpLkJ/9hyM5qCnde99vzTfP9Cq3HCQbY+CYq56+iXaR4vnXsEzLwnKdPOn1iX8c0Ld9DAtFYzc9z+Jbzlak3eLpSk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93f7805-4940-498a-1531-08df13cc760f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:28:18.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIHOJa0qP9jaR2s9nh/+nS8Z5D4HZFGWTebAjtH6erh3kP4nyK4zSXPDTrDxpmAtL+LGGjra1BI3WUO9jkDLgu3aH1nShvz6PZnGt61k1O2JhE7N+GwtaYR/rHWzOhhk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB998113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609160108
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwOSBTYWx0ZWRfXzESJJZBJiAyn
 3WqGnTshzlnCbgGsYqmnaL3l56L/tOLiW4f/+iKs+y0SI+srdEP9yx9d6hsbTN3yAFj366j4e7r
 VJCl4jZOnCN8oOBuUAQccSHa+EzBjDwDZJFO2B9p/rWHQTVccMloRmjNLS/WcIPKwZImyj+zY/B
 jpxBP2jUiwxO7Fj12f7XDk3H0rncMFaI6k4yX3gsqbZd9zyYutCafA2E2iChg/rjUUokuR9I9+9
 xi6p+ium1q4aCaZI90qBcf7E4SpbC+cqToF5z4kO4G8QbbSZWvc3n9Og6Lal+SmH476QIdsLbUW
 J7I4H6zyU6I+Yovj8hGBInNFa1EvyTwVmbCx3eJDmxy5z5Cht6aKns1pp6YHsvxHrBPRiMN3ars
 BfkFgD5iVJXTwtO26JXT40CzJ3drYQfion0KRoGguYApCHTiONjxVTgth3WFluJM0AXgJGJxitG
 YVzME7FUQJBy/+bKokw==
X-Proofpoint-ORIG-GUID: RKEWVR-SL24CNhKVJ1PHT3sz13Rwq0vv
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwOSBTYWx0ZWRfX9G5Ur8HreZgC
 jdd5j/q/iPMJWpCVlWtRYnKSPooe4abBXFDEmXK45aSO9CeUI34TuF+Id0kRdTgTZPYlr8mtOLC
 18TSCnCRD2Cnb2kID0uEHXVCljXNJ6Gp4aYpneZXzzveIiUzVNcB
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa5326 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=JfrnYn6hAAAA:8 a=00se4nbjxJVuxNdA9EMA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: RKEWVR-SL24CNhKVJ1PHT3sz13Rwq0vv



On 12/09/26 12:26 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> [ Upstream commit 47dd67532303803a87f43195e088b3b4bcf0454d ]
> 
> We now can support blocksizes larger than PAGE_SIZE, so in theory
> we should be able to lift the restriction up to the max supported page
> cache order. However bound ourselves to what we can currently validate
> and test. Through blktests and fstest we can validate up to 64k today.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Link: https://lore.kernel.org/r/20250221223823.1680616-8-mcgrof@kernel.org
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   block/bdev.c           | 3 +--
>   include/linux/blkdev.h | 8 +++++++-
>   2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index e96ff382a1ce9..1092998d28d42 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -198,8 +198,7 @@ int sb_set_blocksize(struct super_block *sb, int size)
>   {
>   	if (set_blocksize(sb->s_bdev_file, size))
>   		return 0;
> -	/* If we get here, we know size is power of two
> -	 * and it's value is between 512 and PAGE_SIZE */
> +	/* If we get here, we know size is validated */
>   	sb->s_blocksize = size;
>   	sb->s_blocksize_bits = blksize_bits(size);
>   	return sb->s_blocksize;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 33f5b16c0fd9a..5a90245fbd8ec 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -268,10 +268,16 @@ static inline dev_t disk_devt(struct gendisk *disk)
>   	return MKDEV(disk->major, disk->first_minor);
>   }
>   
> +/*
> + * We should strive for 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER)
> + * however we constrain this to what we can validate and test.
> + */
> +#define BLK_MAX_BLOCK_SIZE      SZ_64K
> +
>   /* blk_validate_limits() validates bsize, so drivers don't usually need to */
>   static inline int blk_validate_block_size(unsigned long bsize)
>   {
> -	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
> +	if (bsize < 512 || bsize > BLK_MAX_BLOCK_SIZE || !is_power_of_2(bsize))

Hi Greg/Sasha,

I ran an AI-assisted backport review and manually verified the finding.

The backport allows SCSI to accept logical sectors up to 64 KiB:

#define BLK_MAX_BLOCK_SIZE SZ_64K

if (blk_validate_block_size(sector_size)) {
         sector_size = 512;
}

However, set_init_blocksize() only changes i_blkbits; it does not 
establish the matching minimum folio order:

BD_INODE(bdev)->i_blkbits = blksize_bits(bsize);

A buffered read can therefore use a 4-KiB folio with a 64-KiB block 
size. folio_create_buffers() returns NULL because the buffer does not 
fit, and the caller immediately dereferences it:

   head = folio_create_buffers(folio, inode, 0);
   blocksize = head->b_size;

The mpage path also retains:

   block_in_file = (sector_t)folio->index << (PAGE_SHIFT - blkbits);

which uses an invalid negative shift when the block size exceeds PAGE_SIZE.

The missing support includes 26fff8a4432f, 86c60efd7c0e, 8b45a4f4133d, 
e59e97d42b05, 3c20917120ce, and 4cdf1bdd45ac.

Maybe we should drop this/revert this.

Thanks,
Harshit

>   		return -EINVAL;
>   
>   	return 0;

