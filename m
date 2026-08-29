Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A84E4252D9
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 21:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788038662; cv=fail; b=LIji4xPGQbbs6+5xu7pp7q5lzlHERJd5BNEqcwnNIvOLiVv83b3LRASdUgMQMmU4ZzT2ipnpuWOujpDd+s4Sv9K76ym/cEET6d/YYGibyRiUwKKLPPvAZvTtFevZ2xcHdoeEd380BF0C5UD0FGdveLYdosRBKCROMnpPr+lnCc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788038662; c=relaxed/simple;
	bh=wlr9qIFRBDs2paTiD8XhMNrwn6Vutz5Mc7Dn9QsLcmg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Uk++Tecxc79/7PQTE9LuRzIcfY6SZAv6l5GVJD5rYkdfUUJX5CvzoKvRk6Qh6ja7xoezX/0oNjsMUqbwsIkdNIKc++llwo1O1qD6MoXlKryJT5+fcodG6fjtJJWSnrbxNP7rcNUbBLAtK3Zwbp7cvnS4mIvotbkoBpCp9EeOma0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VqUFLsHT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yyBgWAga; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VqUFLsHT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yyBgWAga"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TLFSSn1639603;
	Sat, 29 Aug 2026 21:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0UQl+j1lNqrLBiDUr96uV+wP/0nAIrJco56YEeR+f/s=; b=
	VqUFLsHTy/BWbrG4/SdiZEEmI2N/Nhif0kZ+6cYLpWCRvjjeuKdcvQI9mL9qPEo2
	Q1la7IBeyyrp8b/OdI7lhcjCZRGIMaJgu6yflMi1SYkfixO88K2xbUifJ5M9u6vN
	J6WwMVBqJA4Ox2UHOiPQFTvjCQKluzPBM6TYItRdlmRt8iL5CjzJXGQ+WfQf8J7B
	0h4IbmqHAy6n5cZvS4QYOC4p1aD/UKLJw/ZLq3jHix2cqtY7tiBCeurVHpr0kuw1
	gsdP+oxRi3e87IsXjAVWee9XWUMfnG1rNth3pq7f+1Y9rgy6HVeLoCi71biZO+/o
	zDL92VDbQ0iFAj0B7TgiJQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqyrrm26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 21:24:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TLKAXX007340;
	Sat, 29 Aug 2026 21:24:13 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010035.outbound.protection.outlook.com [52.101.46.35])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbrf8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 21:24:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qV2hTWAJ//NAM02XqZYgZ65eculPSm0T8T02Zc8+p7BWZ1+LMlpaW28Aqjxi68KvmZqbO3T88Ez/E7/4LpOwhsHa3dtWgtXtbxrisEYVKKXs9OF7oA/muSPcSMZ1nH+XCDinA+OUQfnpX5S7sgqlITlBKqZVEopaqwLVVGImHrukbKJqj9fQ25Xf2iPkSqod0LExezgD6xQHD7VOcDBklIqzyditjNGTHHGyXVwe7acp2+ggqduke3/YCkXmkldVeXpyEx37Lb0Y4KQK0wF15D6nQyA5KflusuTv9F1oYLLx2HFGbEYCJkT/xIXsNe7yONQdt3ieOgln0ayRoOJF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UQl+j1lNqrLBiDUr96uV+wP/0nAIrJco56YEeR+f/s=;
 b=OQgE5ged9ZotNBeHIBVHBDieoBDaT5wt48K1TTB0jc1VNFItPOZnHolaPb3mmcsHq83gYRgBudypbnSd8GTzvTDU5CrxyVIsLL3wV7uor69v3SSSqYhSLph8WWXVCFD2ATee3lZi92qF7BKy1KfVzwhyYZfo9z5b0oPGKvtKSnCk7y59AwhAo/AW46QS/sp86fF/Kav73uBxwsfMhRfdYy6ePSzHOPVDLBtxXUuZBVMyPa4E40ah21BV41HWlGlLULT+Ww9TYLc0DWK4MXTTfS8aNhmHDSkKvMA04sGm01F/77xT6aVqQT/wdHbe2NWyybRqm5pdESKz21HBCIjaLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UQl+j1lNqrLBiDUr96uV+wP/0nAIrJco56YEeR+f/s=;
 b=yyBgWAgaEp0BP6AcAlvJqrEqsxDZg6p/RqS7Qti59Kk96DfWFmezoc1V+2YP3WD7k8o1P0TzgY8gVMiKdFuIn958h7Spic9WE64HyldN8mHsvdQLhEv4K1WeB+0cSa/47zbciJoG8rTgjTSg4oLzKaRcFtyOg4VB61NO9bVkJoo=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA1PR10MB6447.namprd10.prod.outlook.com (2603:10b6:806:2b0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 21:24:10 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 21:24:10 +0000
Message-ID: <337d72a0-c301-409a-b2fb-fa4432602af8@oracle.com>
Date: Sun, 30 Aug 2026 02:54:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 303/456] ALSA: pcm: wake linked drain waiters on
 unlink
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Norbert Szetei <norbert@doyensec.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
References: <20260817132539.792407575@linuxfoundation.org>
 <20260817132551.648241095@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132551.648241095@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ae::8) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA1PR10MB6447:EE_
X-MS-Office365-Filtering-Correlation-Id: c506677a-37ca-4a5b-2057-08df0613dda7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|4143699003|5023799004|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ly4QQenhkKT9JU3BWKx+NHLEJxsnnb/VGHVKR2wMOanojNkQZFTZQko2aLeWY7FG/FkQaevQVsBeVXp5PecZLL6wKqW0rQDQ3fx/xXKSvK1J2VPl7kl3GgxUwPCf8Jn5wa6ki4Lp0pi6Jo9whMgxAmC10uGPnQfimwOLuuA0ZxQeYCzIACrRM8k5bDQh6XeBC7l8+Mb+lPUSuy2Jg9BV+ox6Ewff1Aqv2BydeNW9ceXRcT+HnFSdz4uxN8NJrGSKeJR+SnRIdB5KyHyrJMtmkjA/7ZLj/Ez6y53QlDQhjq4lhhR5WMerf4uvjs7nO8m5MQXFdePvBPc98hyJXAzlD+9fIsRe+ceRJpY/PpWAVQWiXAYNApG3CUznaqzRtAuZ/B+lceVZhwXtIc3rFXDt9HO0LZwr9v4bk12RCjNeReeI1PXiItewMbItt3EcN5o+vAiGEyBN8/R9erUakZqaozxlljE7NiMvfcQIuz5zCtIdQqqu5tS5bW5r0O2MCmAJujAq2DJfCi7yEX9k/+wbnou+sfqFdlDxZXRzLmygcLIooDZZq3yF+wHBXyc8gLkBULVEVv6f0e8PQZqARvlaSVn0NT9xQ6B2gqS2jB1ux6zdbafnjeukwAsL1Yz1/Iui
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(5023799004)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDZPR1hnN3dsTlNRRi9TQWxvVkcyRTlHN2ttWFZFV3pVd1hteXQrUEttc2p1?=
 =?utf-8?B?OTlMdi8zU3NiMU04eWQ3aGRObk40NFpkZ0JyODZlWW04bk5yVnJqMG55YU1W?=
 =?utf-8?B?M0Z1eDVGcUtpSmZBRmJlTjgrYVNZZDhRS2plU2ZGNTVCVHNINVAxek5OVGdW?=
 =?utf-8?B?bGtsTXlOWkNZeEVDOEJULys2eWlrUndIZGpqRlpTZlQ2dTU1VFhXMDRaRFhB?=
 =?utf-8?B?dy8vc21ybEcwNkZIZlFPZlE5aDhTNW9aeXcxNktQYS9nQmdZOGpUa0Z0eGFJ?=
 =?utf-8?B?TktrdnlueEcvNHc4eVBadFNMcWRNVGh4ODdyT1dqbkJmVVF6eE02VHFHZUw1?=
 =?utf-8?B?Y2MxYUZTU0kwWGIvUkdZd25MVGRTbU92bnlNY1JpUmZsNDRqVHh5TjFuRisy?=
 =?utf-8?B?a3VlSldFWkU4Tm1neER4a2ZGU3JHaC9YcW1XTis4MGhIbnNuK29WSDhOWHpQ?=
 =?utf-8?B?cENuOXpqdyt1bEpJajFCSWlDc2Z5NzdzMW5mY05zdUE1L3I2NEJmdGE5QW9s?=
 =?utf-8?B?T3hGeER5Wm1FWVVQaWdVTkQvdkJ2azF6R1R3NHN4SzA1Uk1pUVliNzI2aWJE?=
 =?utf-8?B?dWtlYXZZempCL3J1TDhMRzRQNlBIbllRUGdBZ3Q3VmJkRmtidks5eWJFcE1v?=
 =?utf-8?B?V21rVFNQKys4Yk5YYXJVUUI1N1NFalJEUjhwWW5zcUUwT01STEZYcjBBRmIz?=
 =?utf-8?B?UEpsN2NnN2FTWkV3QU9pTVFpSlNWMzhkQUt1ZXVyd2V5QVBmcGNQanBIbW1m?=
 =?utf-8?B?aUJnOFUyaGpvazRCR2NnRHdzN0YwSnQ5QnpWeEYyaTJEbE83WW5ReldoajQ0?=
 =?utf-8?B?K3RiZnVJNEhmdlJWMjhreGJTbG90ejQ5OXY2VG1xMnBKYXFldEJ6RFg3V1ZT?=
 =?utf-8?B?TDRaeWV2bERqc3F4Qk81cjd4TlIwdlVRRDZ1cXdhZkRRMjFoNjFFdDFjR205?=
 =?utf-8?B?cXBmMmxIVUJuNG82dWVGYlphZGxtME5SUExaK1hTNWUvMlcwQ1NGM0lwL1Uw?=
 =?utf-8?B?eUtoVzd6eDhUa3lXSTJCYmV6VXgyZjdxWHQyUjFydStMVEpOd2JUL082ZXhp?=
 =?utf-8?B?NFZYVmJmZ1hQV2hGWUh0OStUQmUrRUdmaGl1VFhSVUJsTmpZQitiZmVGRzNG?=
 =?utf-8?B?NTd2dE42UldDU09XNnhMaWRYSXZ1dXpBOWl0dlBGNUxwczl1eXRkU0RyalZP?=
 =?utf-8?B?Y2lSMDJIaWY3ZVpCR3VIL3FSU0tMemp6bU9iNGwzYmYrVlB3bEtaZG9lQVh2?=
 =?utf-8?B?QUtwY1JTVUFDSXFmM3pCblVwc29MNXR5Vm5ib1pPZ0NpeHpDNzl1eDNKb000?=
 =?utf-8?B?b1JISUJLN2ZYZXUwTUE1SXRwSURTYVdnRlJHV3RPTHZpbXVlRnJrek9jcExB?=
 =?utf-8?B?N1ZVeUlJckpUeXBJQlhpL0hZVEdkRXJJMGNRcTdLS3habEZwSkdLZXN1SnI1?=
 =?utf-8?B?aWRPUW5zNk42cDdFNXlYRmFrYlIyWGpuQ3RPa1hsY2RsYlR4NFdPaW9HSTZi?=
 =?utf-8?B?blRqUUNBQ2VabzVDbk8rZTA3R2k1ek1aZlcyQjJDSW1xQy90MlJIVFl2dm5l?=
 =?utf-8?B?OS85aHovUUZyK0JiR0tGTndDVDlYNlhPaS9wbHo2ZE5VSGY0VlAzMENlQzRG?=
 =?utf-8?B?cVdBbWJmQUxpcDFXOCtVcWR2c240U2w4bXBSNktlL1hJakRoTVZQVVdoMXIw?=
 =?utf-8?B?NE9oaDFCTENyeFlIZEwvSlpMU3p1eGlmd3dNRDF3RStLUDBqQVVDcENmTXZu?=
 =?utf-8?B?NTRWcndaWk1GWmtIWjI4S1NSY3JyUGRpZ09pbGtBZXppSnk5OE52OFVxOFp1?=
 =?utf-8?B?V2lJZVE5M25PRGZvLzdqQXlvcVNqVUZoTW50dlBHbVdmSXZBVGx1Q2srSytE?=
 =?utf-8?B?QXM4b2YrTW9mVG9zc0VVNjl1ZGFzMXNvQk1aaVM4azBreGJpTXhKVC94b1RY?=
 =?utf-8?B?Y0VhMFZPc1F6N29WUkpXblhuazJmbThaTnZESWViUXRXaHFqY1RQY0JqckN4?=
 =?utf-8?B?YkRELzlwc3RlTUR3QlVudmtFY3ltQXlxTG9wVnNGWDVXTkxtUTFqaGtyRHdX?=
 =?utf-8?B?SVlmWWkzUHJwUGpFcVJzcEhWOWxwMGhJNEEvakwrYTR5R2ovUkpoR0hKdEh1?=
 =?utf-8?B?VTFSM242dVhEbUhCdG5nbjZKMi9tMjlOSjNSdkozOTRmbGZ3WmJsRkM3YVZo?=
 =?utf-8?B?V3U2dGZOY1ViV1gyenBrOUdPL2hvL2h0cWQrZE1rSlNIY2l4akYvMVlHYjlE?=
 =?utf-8?B?Nmp4ZG8wMmFvMytQQmExZm5QWHh2UXhLTnQzaHBmSnVobm9Sc1lkZW85ZFdG?=
 =?utf-8?B?MGdYajNlcUtQdGxmQUhjZTdHdUlSUW1iZFcrUFdOT0hadldPVEZKMUJOd1Jk?=
 =?utf-8?Q?Xe2XFnJpoTNtR9mMEnBbQxAJnwqtsUCgojtcJ?=
X-Exchange-RoutingPolicyChecked:
	LN2OWtEyN07Cw+kDah1K8RwwBAcBtCVuEulTQwuBPlpv+DORlorhGF7SR77td2lOt8XnkHTz6dPCf3sVb8BFtRYlheFfYB2aRD7W+KHeFBF5pufHD+Rz1ZHL3cbbEtNkgSJ7DynMAyLnspn7vLv3kOAk904rVhtgLPsR3BeJzM+/Gc2Z3zyoeukTYjqBOq/SDXu4xweR5Tcj7R62VAPGFVnI89ob1sjt6sIqnJkEReeDMergW8KO1Ly+f4u6ky9VFHIjM5/fSJ86ft8fMWOs41FnNSsSE8Y3kIFfGSueohTfIqoXAi59u8S4z+Hx8WRwY1PzRRcsvGJiLJ9AL8LIWw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XQH28E4cj8AFmUplvrKMt3c6FNq6R9YZ6OO2HbJN64zLzHI1vuGNmr8lFqxkdFyd9udfhJW5e3x19siXXWuPYYBR7oP2Qle13CAEQ4vXB4MExEOgq58LWcrkpmwAcPT5CpwpcfK3qCl2FarZDoHEvoGi2C0YBvoD6Bw2gydgVYyXTDYMmFhG97GeLk8eQwwB2Ec+zHABgHyv5vAlJK0mgl7tsoSJ6qHvlMyuugDa/3xX7eIgPP++ZC0dNB7jMa3bfHhgM/RfqycdfnKTyDqcsViM3UPrNxdAICAHj1PwWnasVjVTy7RcwZaRIF/Fd8mvegcMeCC2WPjhk2M76q5C/SMMrFisyNFwb7umbbC1kiAmGebpJufVTatpZ1qKweuNntEf+d9dqRyntN5vDMPI2x+yRI52aezms+WMmSq3IvRM0FdAKnqIHr8hdicwNEVOafSc8FwTbuDSp+ztJjdv0MrSjwG1R2F2x09+Mqkcervanaep8PWKd4tsUaPFgAYlYZjUK0Fp28F0gLbax2lfl2n5oDf1jbIgwf5+YROQaJvM1zgQ5gdWVaR4mOXcCkz+IDY2y3lvv23KO+d4LTiPU0hYS4IpruebK3P5VlOUVk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c506677a-37ca-4a5b-2057-08df0613dda7
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 21:24:10.3522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n21V9zZ2Jsv9rnIh6+i/hU3rsO2xLAY34fJr4qg6kJVh/Ohkd9LDP/djdm1XQWGgx2iALlu7rlS9YyxxPPjbgsYm69ATqO7vuPSPtr13KXaU/Df8sLu4RSNG56oqGMic
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6447
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290185
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE4NSBTYWx0ZWRfX2VljvrejAsSC
 ZubDOCU+5IKr6vWxwrdR2wqrjlPhTSYBkAEvygbZqEK1r358O51hy1S0dmzNZEf2gMj60yChiY3
 l6QxyJ7KPrfAuNZzU4VrTU7Mf5f7upJCqYqRCgr6+K2f0Fg4WiP57kVfATxcOIvt7kyP85Cusgf
 z1+NYNV8ea/dA7dUMTzcF+D8SsEc4JIMsA12AkaXrrHVd0OUQ6tbGxo6z534ma+JyUE6EnlTd+D
 Si59vUsjuz8RvBQwjLlsgwgHJ0JviLDqiwJimbkDeQd6OeBm6d0BcWG91DDIW9BzCahTKR6nAhr
 wCycgrVtVXpv/W7vJYKW/qCYobfObKatrNwjFc0aG6sN6ghV5yB+XJwF+0U79BxJk3F64vi73dq
 duQ3M2jTllI8kpNaMZMcIeLvfykNx7zF/DD+70MrivyAYSf1OTpecYbKpYLV4aCdAQfXU2e66Ay
 KgmMha9ImW8mTQ1YAKg==
X-Proofpoint-ORIG-GUID: 9_Bz5-VwJM0iRoJ9vb7GDhz985xYUIfV
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a934dfe cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=OVD7ab4yAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=XVYPQhr4CARhVs5R7vgA:9
 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=uj-rpvF5wCmgIeEMWm7q:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: 9_Bz5-VwJM0iRoJ9vb7GDhz985xYUIfV
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE4NSBTYWx0ZWRfX2ijTIrAX76ok
 ZFhBxwOheCfKq1t3pa9xfsJgC9cSLJ66qerfe6i356mGQZXTI9NT1k4MHTdKkpfVWqiL6rF1sgX
 ghsKASKl+ozskSWJWufMf/rfyg9L/kg7Rft1IbN7HZCqf0yinmHc

Hi Greg/Sasha,

On 17/08/26 7:01 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Norbert Szetei <norbert@doyensec.com>
> 
> commit f495b6c4c8594122918552c9be2b51eb71647cd9 upstream.
> 
> snd_pcm_drain() on a linked stream parks an on-stack wait entry on the
> drained peer's runtime->sleep, and after schedule_timeout() removes it
> only if that peer is still found in the caller's group.  If group
> membership changes during the wait and the sleep ends by signal or
> timeout (so autoremove_wake_function() does not run), finish_wait() is
> skipped and snd_pcm_drain() returns with the entry still queued on that
> stream's sleep list; a later wake_up() then walks a freed stack frame.
> This is reachable by unlinking either the drained or the draining stream.
> 
> Unlike the close path (snd_pcm_drop() -> snd_pcm_post_stop()),
> snd_pcm_unlink() never wakes the sleep queues.  Wake every group member
> under the group lock before the membership change, so a linked drainer is
> released and drops its entry while the streams are still grouped.
> 
> The window was opened when snd_pcm_link_rwsem stopped being held across
> the wait and the removal became conditional on group membership (see
> Fixes). The later switch to finish_wait() kept that conditional removal,
> so the signal/timeout case remained.
> 
> Fixes: f57f3df03a8e ("ALSA: pcm: More fine-grained PCM link locking")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> Link: https://patch.msgid.link/A0705100-D10B-4286-9980-0142ABEEAD51@doyensec.com
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   sound/core/pcm_native.c |    7 +++++++
>   1 file changed, 7 insertions(+)
> 
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -2338,6 +2338,7 @@ static void relink_to_local(struct snd_p
>   
>   static int snd_pcm_unlink(struct snd_pcm_substream *substream)
>   {
> +	struct snd_pcm_substream *s;
>   	struct snd_pcm_group *group;
>   	bool nonatomic = substream->pcm->nonatomic;
>   	bool do_free = false;
> @@ -2353,6 +2354,12 @@ static int snd_pcm_unlink(struct snd_pcm
>   	group = substream->group;
>   	snd_pcm_group_lock_irq(group, nonatomic);
>   
> +	/* release drain waiters before changing membership, else snd_pcm_drain()
> +	 * leaves its on-stack wait entry queued on a member's sleep list
> +	 */
> +	snd_pcm_group_for_each_entry(s, substream)
> +		wake_up(&s->runtime->sleep);
> +


I ran an AI-assisted backport review of 3035bb784cea and checked the
finding against 5.15.y. The new unlink wakeup depends on a wait-entry
lifecycle fix that is missing from this branch.

Before upstream f495b6c4c859, commit 88fe2e3658726 ("ALSA: PCM: Fix wait 
queue list corruption in snd_pcm_drain() on linked streams") changed the
drain wait to:

         init_wait_entry(&wait, 0);
         prepare_to_wait(&to_check->sleep, &wait, TASK_INTERRUPTIBLE);
         ...
         finish_wait(&to_check->sleep, &wait);

The 5.15 endpoint still has:

         init_waitqueue_entry(&wait, current);
         add_wait_queue(&to_check->sleep, &wait);
         ...
         if (s->runtime == to_check)
                 remove_wait_queue(&to_check->sleep, &wait);

3035bb784cea wakes the waiter and then changes link-group membership.
The 5.15 default wake function does not remove the on-stack wait entry,
and the post-wakeup group scan can now skip remove_wait_queue(). The
entry can remain linked after snd_pcm_drain() returns, so a later wake
can walk stale stack memory and corrupt the wait list or OOPS.

I think 5.15.y should take an adapted backport of
88fe2e365872 now that we have the above merged already.

thanks,
Harshit


>   	relink_to_local(substream);
>   	refcount_dec(&group->refs);
>   
> 
> 
> 

