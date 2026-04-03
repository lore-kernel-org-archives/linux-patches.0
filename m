Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41456A001;
	Fri,  3 Apr 2026 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775222244; cv=fail; b=WpmAR4bKAEHj6NebnO5e5hklhNz6RfJOgplG8pPPYQ6nSXNnpUM/2H2iLrCoEiZEzYQAp7ATC5W8gTOVtlv3mPIqZXODSIsAZQFMo4gp6CysqDjH5FE7i0qYuDNsA71U8FmeUFzw4SRAFtKZXICRgJQkTVFkwkXctqK20bKvaBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775222244; c=relaxed/simple;
	bh=d0iOm8KyeRBoTmmgIkpJOSz2CBh1iK25KIioHtGM61c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ksk48xUQg9qEcdMyZOEl1xRQLTi/eMXFn8tgas2aQijZnG7S8IrjXoAluad9uCTue1R16ExppzTgceVTSwwl26omj/Dq0gAMtazL2jXbaTpjqZabAb4jCSsjaIr03TfODLTJQ7kHlKzxNIbECp6Dynnoj9pCY/N1HJB31Gk+WmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bEy/KkFK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eOfr+5k/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bEy/KkFK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eOfr+5k/"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6334hWxE2362988;
	Fri, 3 Apr 2026 13:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2gSGD6G9ITviwZqueihQMqcDXqhjH4kAnMZ0YmxOcoA=; b=
	bEy/KkFKYI01LvfyVTdW4l6u3J/M7XBjkL4BDdEZyWDQWph46W3/O68AEmTrunmX
	MU22COGAiEbpeShgz82iMG2nwusLZzWQzKkl/f7I7zTpyxQMonKhxjKyRPie+h7D
	n7IgpYjZPNXR0k0LsXrITggU8QiqM3nQj5D5BBzhJqokpAOAziG1oKgjkD+0OIa7
	K03jZTG5d/5acT1Ytth5OKOI16YTg6K1pOaBEanVPGE5qpKViKLcrCdugxL3cR9g
	ho/OY98lmqaM3L/e8+4trU0i8Ie9BnMsQaug0W6XGapIvVY0plnzYBLUpWDFH6lO
	LBVDGI2QU/V/QZJ6Rca91w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65dahx03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 13:17:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 633AjN0l020189;
	Fri, 3 Apr 2026 13:17:17 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65emgn28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 13:17:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xm3pZpnwH4CTO6DQrIztZyCUGn/99fR6emeGzpuhY20NZHTVj50pHhCnrfrLq7QSv0PRMdwgL+NrSeIc55k3pS2mrRFROM05hWkog570/Qgpx+AUQ7sjXZ6gzYt3ntBAPMwhrmQupeRA0ymmbDyHu7xq3PsUrAQwzvaA8Fn3F4DW5JTP8Jx6Hn2795ZdiAiF6K6jC2rCIqPUBXXEFXsyKIH9bVkvvInYpyfs2s81Z50v1GzJ0TJnq0WMriN44vM5yd3pa8DcsddgHAoFJv+Si6ltjedlqW1KBFrqcYxPRl6ru7JAsDQhhtvPvHC8Fb9U/bXvpOGOMwbPfhhRl8m4ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gSGD6G9ITviwZqueihQMqcDXqhjH4kAnMZ0YmxOcoA=;
 b=L3ZjB2BgtUe26IveMeW3UuIdJy1yPxkRdOR2zAUZd4iNVuSxv4WLEm14brPnh5cB34IjOQpDpV+JK9ImRDqAhuVwTt63VXNsMvGUXmDZy14qUadHh8uNojAByUWFF8WnWhDUQioE950i4M1W1OmzcHpLctaYZx+w2iPWm/EXmPMrcxZRBEu3hueGSv7iWmpNL2Owfei4uQqBLuI91qbOE1p7LGQUuVq4vNwikwv6qaaHT0RnW5OwImdPGWugV/yShsFvx/btPBJDacKT+9V1pi2DxR1lm1VB7QGXzm+93nwG3cidyQxwUH+k+dYV6dF4gF0HFkxxt9BPYouMIDQevQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gSGD6G9ITviwZqueihQMqcDXqhjH4kAnMZ0YmxOcoA=;
 b=eOfr+5k/ObL4jVvyS6s/bfGXKN7hLR/F4oVuV1HX8tX+vpuVaFhl8GPKYxJZEXlMoKJfIfx0FU66x7Y/460nx2fG97YGRuHlUq+SIJl3u6w075Crj0XV+Yy1iFVH5PxzJmwxbeJs43ijbOQL+xAkuo2m7Oo9DouOr6yij+JMSXg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB6361.namprd10.prod.outlook.com (2603:10b6:806:26f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 13:17:13 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 13:17:13 +0000
Message-ID: <ffb3f43f-ffd0-4e60-9966-a77e8ed611cf@oracle.com>
Date: Fri, 3 Apr 2026 18:47:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 044/265] PCI: dw-rockchip: Dont wait for link since
 we can detect Link Up
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Niklas Cassel <cassel@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201019.793655649@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260312201019.793655649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0426.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::9) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB6361:EE_
X-MS-Office365-Filtering-Correlation-Id: ebd94b3a-8101-4b1b-9336-08de918351dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DpOEsYI+UXQu+XSxkQ0ftgLLF+J7BNa7iO6ziLraArexL1y8Kkj6lTtQuGt7OZYwaHTkKy3sX1OJsEgFkOfTzPaY0tD5lAJKE+lLoxDTvJLFBdqdOi9xHFtBEZifcCBL0Wzd66nRYUuh0lfObX+L7emYNXYyfzVsjV/Di75ubb0HRVkwgaoM/s8x4DNfK1tC5mOtCEor7IKr08alTJVRyefuBfRTdaYve+A6CJROZgJDwoo+i6cjyzalp13o6yUgQkRyDlfvTHfBrXUTcfaVXWkbIbeg4l1dcQ0QDFGn3fFyIwbUZ5b3Q9BwMeKgwi+6Jvm9jnyPcTO99ml4Th354GODAcckQJ95eTaCiFOB3E5fYe5/OYA+Avi73ZJNQ2vCRO59ZcA4nFBwb8OiDPTq/PZNbWL3uSOzYfyqJKgGca2V8vStzjBjBpsL9V7xyu7YhgdDeuGLMvi6F3UZF7nelrOjBieBaKCyXV8j49Li/Za4G03eMpYMwVxaQwhRVae/NB8xJTqZva3et2JEUxpvFOacpdEI+zkqPXklVF88Ha78u9HSMFN19PuqT84JZyaHR1L76qeHEJBUJmUudZU+qcOzAbkgXUSNKq7lbRCVrmdNvVGDYtrRf0M7VyXeSmdzuSLv/b5OU6z92QrtegpZKrQvJQyX3wUxgkwDpxhUUEQj1povoOP1oGMuFgQ7VE+3ce4O41sXpDSxHKwU35OCffU7NGLATgw5ki2+h9byoKA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STdJcUtwNEZ6NllhWEIyZHdpcEpjc1hrVzRBSUpJWU9mOUVyV1NOSWhUb2dP?=
 =?utf-8?B?UEE2QjlpRWg2d0h3dmF4eCt1eUxkNEV2UUVzY0JHeGZGc3g2QU55ejBxNGR2?=
 =?utf-8?B?dXhrNFowd21yMS9HcEZodmttZTY2MDcyZEh1Vjg4QW9qS3Nkc0x4ZXdad0po?=
 =?utf-8?B?bWdDTHhvaVYza0o1Y3ZPOVdFdTFockRjN3RESXBaNUkza3RZdjRULzJ3MFBV?=
 =?utf-8?B?a2hVVEsvQ2NXc3VkbHdVOHovS0VwWjhnU3lFcVJNcHRZUkNTeXAyejRlK3Fu?=
 =?utf-8?B?Y3NrMThhTDdydHJsMW1FMlJjZDVrWVBydUUzNFcrSVc3YkZSRXVmV204NVVH?=
 =?utf-8?B?SDd0NzBHLzZxZDBTeVBNMGUvaDUrTVZxbDUzUUZWcis1VFJCZ2RuSlNrY1l5?=
 =?utf-8?B?Y2JVaFpqOHd0emtNRytUUWZyOGYzTDJnK2VONFM2Q0l5VUpPaDkvdTRPRkpZ?=
 =?utf-8?B?UmtMOVdBL3JsYzQ2UGcwOHBzVTUweHVkVUtpcHZpMlNCTGlFSE9IQ21RQzdV?=
 =?utf-8?B?c2QvSkZienJScEhGV2ZRVVhRTUVtcll6UjBsSzVqdnhxL0pDZkoraWp3c29h?=
 =?utf-8?B?VnpwT3dBV2lNYmRMWUl1aUhmczJDNGhRTStxekpxMmxiYVBHL0g4UWVkcnZY?=
 =?utf-8?B?NU12T2RSVkdnQ1l4Y0J2eXpyamtDbnVBcDBkSVU4RXdrREFva1BZVlNGUmE5?=
 =?utf-8?B?VVNTdW1wblRYZ0lXZG5nNlR0U3prVk9wakNrYnhaVm9lZWUyOERXYnhBbDBL?=
 =?utf-8?B?aWV0bE8reGEwbkRIMTJKbDBPRmkzVFphRm1ycGdIMEtQVGFHc21FcTJoQ0dD?=
 =?utf-8?B?bVRCRUlPMnhkc3E3VXZiTWVoYjl3TnZxU3h4QTNBbVRXRVIzKzFsaWc4a0tj?=
 =?utf-8?B?b0s1RVZmYzFNOXBUMyswVHNTdHRMVktWTTNSUVpLTnh3SDYxU0czL2xNU0tM?=
 =?utf-8?B?M2ZTdG5WcUFUektGcE9XUDhKOUd0SmZOeloxN0tleG9yWTNTSkdaY3Zld2dr?=
 =?utf-8?B?QkdLNjUrekRaeFE5RnozbmRuY2dxcUJBZ2pKTFFqWVdGMnRDMkowdWxhUWI3?=
 =?utf-8?B?RlZvOVhwS2RxTEYwQ3Buc3YzOWsvUjRzNGZ4RWdBam9HRWJCY1NmVU42TDZZ?=
 =?utf-8?B?NlpHb1VJSC84WjdJTm1xeEMzRGpOeTVQaXdVVUFkZW8yUlZhLzFjdUVsSEE0?=
 =?utf-8?B?UVUwc1VRejhObkN1Z2dYTXp0WWt2YWh1UGxndnE0ZkdjSEFjbS9kaVZkL3hZ?=
 =?utf-8?B?YTRleW93ZjIyemVpcEhZNVY1TEZGcVE2Zy9UTlhjUGxmQitIZ0V4dnl5N3d2?=
 =?utf-8?B?Q0ZVZGc2TzZmK0VneW5zd0FJYU9tT29qbi9Hck0ydng3emZIWGdXOVpuNmdo?=
 =?utf-8?B?MDdtTVQrUHhKY004NjY2Tlo0SW02OHNpYVkxc0tiSDZ0QXMrNlN1NWpEaElw?=
 =?utf-8?B?b3RKemc4bmttcFBqS0JTTEhCaFdheEhsZlRlTktwRUZEZlR3bWZuay9iWm9a?=
 =?utf-8?B?MVBYclM0b2t6N1JkVHpvL0NMZE5PdnllcFFBSnRFMFcxZ0pybkdRQmpnNGhy?=
 =?utf-8?B?bFB5RHpnV0NUNWMzRC9rQzlzOU9ic3ordEZPMGE2RWEzeUJjeXFzZ0EwdmJ1?=
 =?utf-8?B?WDJIS2U4SUtickNydVFubHI3M2NlcGVrN2pvVk54bHMzNWp2SWRlWE94VElz?=
 =?utf-8?B?K1lUL3VlWjJVbXdhTW9FdG1BQldkMmFKRTlFWWVSemxwbTR2cWZoZ01wRDNy?=
 =?utf-8?B?N3gralN2ZmlXdzhSV25WYnlmM25qQWl2dXIyejNFV0JoVVZWa2FLZzZDS1dF?=
 =?utf-8?B?MG9FbEZCeWllUStpOG15TmVWTU5aRWJib1ptZ0l0KzVRUFlkTEg2cHRjdkNI?=
 =?utf-8?B?UDZ1bGpUdk10WFpSZUlBN1ZZVXhqWXVPNFV6UXMzUzhoY1RnMHJ5NTZXdnAx?=
 =?utf-8?B?QWJVekZKVTlpQTlmYStVNDQwV1hDbHBoL2lSY1Q1dzl6a080VkVVcHpzcVRM?=
 =?utf-8?B?QWlKZDZjQzFsT0g3OWlSNXhkZXIzMnlxUDZONTZQVXQ5Ky9uQ3RIVk9TQUlU?=
 =?utf-8?B?ZmlTenBVclVpYy8rQngvOVRCZjBBdUk0dWUwMGJDUEQ1MC96aVRyWitnVHNY?=
 =?utf-8?B?VjI2dGlPNnhNQnlyWkprZ1NzZzcrRUlySlhqelpweGUzMjVBY2xVZkRxbUY5?=
 =?utf-8?B?ajgvWGFVSmZ6dHVoK1MxWkNxT25EYklYSzBodkozZEQvZGpjMkovZXFjdmVQ?=
 =?utf-8?B?WmR0Rk1taWZaK3VSd1h5U2tyVXM3eHp4emZLYTBkU0xzTWJ0Q1VHaE5oLzd2?=
 =?utf-8?B?amQ2ZjZyY0w5MFlKR1JYZ1FzNWxUZnY5QWJmZjN5VDVUL1cvZksxRHlnYkhZ?=
 =?utf-8?Q?kww/7GFt4Y2mjkG8CkADc0+ZRakLTewCb7PeT?=
X-Exchange-RoutingPolicyChecked:
	ezHJPS0UOQygYxaNkcrUUQmU+3Z5a0uARx8bR3iF9ywpr7+CUlydnwcQOoMgz7L2oCSx8uc23aiyh0SZTXSElKfY/t0m89GqkRwQ5xV0m37cVcACF5aeIQUP9LUmqgaBnN7tpGyGDH2JIXRHF1hAWsswDspuj/T45wz54tstxH4Uih3P7O6aORVNcPi+JrK//nGdhle3QPkkDFd7RJrifDrWxMz3m7g3sSG0miaJtaoq813Gxq2sonpq0h+gE0e28PXFAdkmEzwJfRGxDWrPUz95zyZ8uRMdo6XfaeSg8qCe3XP8zC9oAFqOtSeg1AFNmqlrzFm35KgCLI6eqUEvLQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AJmqSy+TsV/LQhFtV40Qy1U1dEPh2aF9LLG4thRcUvaf3wHwyO9hoKl0UK4XOJJUofm9pv270AlaGfmWwYxHzMLi+cCy6TB89YA/ZZe9mBI91hFbS7xteIGmll1nnBy3o4aA/rcmI+TRIFO0sBvxPrf2EUJhkLrx8RqERAzL1Sg1GrLRqgA/MWrebfz2LntBEFjJgRmDypfqhJgyfQUFpbQ7iGE8LsymvD6SBbVb32aKDWzWpc3pbd8qV8cVgJ5/SPGGlzE+dzQCpsmGcnBB6GrXCjqIE1tsHg9zplv0HAm5XwXowELG4YggV93hZN8/0xwNy2fcadozI+tEBYNtVdvscfcAArGqzu+yFGkCG/+tgtCT1sTFQbS8XZbHaj1I2fMxdTPeqFjCjp//ilTwKdvrjs3UdQxMf65slylBv+00v1FG7HZoqA0IkyLaowXMjWpNylfLcNZy2+quRPbTRVB0PY8LaiehctOapkMLFCE9JfDWF5c7gTq3fgCSQsM64Vz4qlnWmSXz34NSYaahxkrrPAPBc96CH3aYKCSNS1D7Vo7ATwVQl2gLZrT51RXyX8KgBQvqsKbMtZtc+lz8pVkA53PP6ugrH56mlMwPmHQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd94b3a-8101-4b1b-9336-08de918351dc
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 13:17:13.5636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZ2Ma3wLF8xfXDTYmT8IT3nz2v/GVRkC/FzpQU94+HzaqytUiWVYuNzKs8MbbnCEUGpB26nL7ihsFAl2Z+asU4rPRKb7PDpP6hZ+9ee9G6v+H/t02gpbexDOhGGPhf5+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_04,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604030118
X-Authority-Analysis: v=2.4 cv=IPwPywvG c=1 sm=1 tr=0 ts=69cfbddd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=LlZbDdDpAHlZlzHjhH8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13825
X-Proofpoint-ORIG-GUID: oA40VNlpQjAl510kKfpxke6AP20YanFg
X-Proofpoint-GUID: oA40VNlpQjAl510kKfpxke6AP20YanFg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDExOCBTYWx0ZWRfX3eHfE14S/pT1
 faDBFo/ZgenQDqouv7/cMd10DBQkpcLdatQvajkAZNUtvqaZKQPEmj7rxvFqasDN5Y1RzbdrgKI
 xk/QwvvYKIp5vxTgZloYI7FLss6DJQUWAB+71AbzGKNLAKiUXzt3Uu2tr4AdyvnMEN7ylzFSZ8O
 IA3x1EImoBQpzvWo9sufbWn+MORi6mBXeoVj6oyOciNEECKM7n6ueUG/PCYjexdYb9wkKv9o8mI
 UKECS67i99GhlG3giEJkGRJP/t7QLyRLmNQHCVjsKDhD5j5YYnuvK1kLYKV+QAVU7F68hLKdyIF
 y9hYocIBmx5mYELJ+gOr0z2lWbq/Ct7M/nmvGSKirDTTgMq2prJ3AzIg0FPjeXIq+eebWjA7r3l
 Mohr6ajHi3aBWzKhzZ9BAClDHNXL4hbvx4yoxs/oIdeHCQ4ly5J7gTLCi2goQqhAKLC/RjQwGtC
 nuQvjQtlYa6dcpCdIbbLb0h4db6QvAuwhm6II2t8=

Hi Greg and Sasha,


On 13/03/26 01:37, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Niklas Cassel <cassel@kernel.org>
> 
> [ Upstream commit ec9fd499b9c60a187ac8d6414c3c343c77d32e42 ]
> 
> The Root Complex specific device tree binding for pcie-dw-rockchip has the
> 'sys' interrupt marked as required.
> 
> The driver requests the 'sys' IRQ unconditionally, and errors out if not
> provided.
> 
> Thus, we can unconditionally set 'use_linkup_irq', so dw_pcie_host_init()
> doesn't wait for the link to come up.
> 
> This will skip the wait for link up (since the bus will be enumerated once
> the link up IRQ is triggered), which reduces the bootup time.
> 
> Link: https://lore.kernel.org/r/20250113-rockchip-no-wait-v1-1-25417f37b92f@kernel.org
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> [bhelgaas: commit log]
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
> Stable-dep-of: fc6298086bfa ("Revert "PCI: dw-rockchip: Don't wait for link since we can detect Link Up"")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

We need a process improvement here.

We are pulling in a broken commit as a stable-dep, so we can revert it.

Patch 45 is the revert, same logic for pair (46 and 47)

[PATCH 6.12 046/265] PCI: qcom: Dont wait for link if we can detect Link Up
[PATCH 6.12 047/265] Revert "PCI: qcom: Dont wait for link if we can 
detect Link Up"


Thanks,
Harshit
> ---
>   drivers/pci/controller/dwc/pcie-dw-rockchip.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
> index 6b113a1212a92..8bcde64a7fe52 100644
> --- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
> +++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
> @@ -433,6 +433,7 @@ static int rockchip_pcie_configure_rc(struct rockchip_pcie *rockchip)
>   
>   	pp = &rockchip->pci.pp;
>   	pp->ops = &rockchip_pcie_host_ops;
> +	pp->use_linkup_irq = true;
>   
>   	return dw_pcie_host_init(pp);
>   }

