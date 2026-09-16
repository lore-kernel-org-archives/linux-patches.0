Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0321368D5A;
	Wed, 16 Sep 2026 08:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548178; cv=fail; b=E16fsxqCdnQwHYt1nV4lXrccqHOgWwPhkoCkoshW2HFeweEnaWuzMFeQ/D63Lx3MAguw7AO7yjsVPB0EMrvaxzUBrnpt6UVH2eCzu5t/eWpyQ13uG5a+C4RwMHo8Rmnbw5dBBqtpHqao1wKcQ6FYuTIP7/QzH/Zu+1pr6mKO8vI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548178; c=relaxed/simple;
	bh=PfwXajn8qYOOy7Scwxq1Xo6lOCp7EptijVgph5t5Rr8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ex5HQ1J5QDDFkuCr+aSip5TBLjsbX2QZU8SE6Sg3yHlLsnW0r4sj8/H2xTgWYC2s1EIxqukrom11uttbj/2pPTdUWLdQWB3uA1lQM6/MYGueJxz5B44ldrXjvjJJH7gdD99l/w8dESbfahbCd9Dhv37sms30wfwnrNTsHwNcLqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b84EvQTE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XRExcV5r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b84EvQTE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XRExcV5r"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXAej525158;
	Wed, 16 Sep 2026 08:42:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bBKZD7FUR1scB/20ZiqkQ2PdA5gO0Xm0UOW/Pj5lZ6U=; b=
	b84EvQTEvKcqHYoT62n4tuWjh1FyZa3UDKrBbpLMkXqF70HL6dWF04WE3MrQ7Ap0
	W7N4bCG+atOJurpqEZfNxAcr4oLkA7ytKPGTAxWDjbqrkBADPZ680/anDsRqDcWc
	9TvOVhTHtJfL5mJK+iuZ0DkVqHSbZzAdodfQYz/lFFgSAkGC0GILGHHiY4Hymp9A
	+ORFUenRFY0ddJItvzT5jn4SAqqStxOwOGnCYhwA0VCm79jZSYOJ/DoYyIuOsV2N
	/p787kpXx31UNUpyRJLz9NHAxdY/0TwyDSegsGZl/V5TUc75Uu1/TZ+QLQigqW+1
	uqfq+zE/S8NX0DW9D4yLCA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmy9rw660-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:42:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8doeS025455;
	Wed, 16 Sep 2026 08:42:45 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013069.outbound.protection.outlook.com [40.93.201.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d3r9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:42:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ytqQh1HHoyeHaBuaqvv+Q7sgwZCOahHMPcL+QVlTbwVsZGzthhb3L9o5QIYto9a3dWM8nkNrEmm9QoMmpY7aKdSspvMDKrSrSaCLwxkiefll1/rTR/PgW8mWErqDht5dJM3xQY/tHSwMgcRVDOrFBmSeybJdaui97/xXCWQ01dGv/xW8M/V1UPDXS4iTzaV5iooqRhREhXdqBcisMr9CiV9+VZySYy0q84TvdApDE5fPKbQL2loqVWaP+TQqZSl6gG6kO8YEN8ENCnrHcFd8L17H5YIW/sFA8YKMx4gKXGpHzBxmKpRBiVCrHJJGoQvcE2R+A0CXRb7qzSGG7drugA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBKZD7FUR1scB/20ZiqkQ2PdA5gO0Xm0UOW/Pj5lZ6U=;
 b=A/fxTxN5RfpO4WPcVlAEF+jYoiFXx2lWLsgZmXIOSO+JZfmeBr6JbYqFhMP2ETZOYRjuq6SUg+VY28PkMCWfD5HrR9d0qH6XhU9GNya+4WQ1HX1f6nsDrQEePVcxkHiwhzQ//M/5Y/LlQS/vwdkR5T2og/OgQrev6fSyGlTIKoKdzZ2sgKmr3lomSyXEoIBtvq1/4pgL1CVeHbxwyjPUbrjW0PM9HuWkvypM/OjdPe8yQZ3eO+YwsNgzAPci8MfRpxHweEb8mZWydW6Dn4yuxSWUHI40t93H0kCiytG0ddt26qAvsqwluNY0739chgv3H8oluMvjwOcar6YS982UIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBKZD7FUR1scB/20ZiqkQ2PdA5gO0Xm0UOW/Pj5lZ6U=;
 b=XRExcV5rmA3CvzV2vbqSGlaqKqTtHSfmbEWr5g+PRAKHIHiByosdLNOXYkXvgzzqDB5vWBbZibq0q2T0HlEuZpgGBvLXIeFv4rgwU5VOH17YxtS+npPw+RJDkYT0SzlJRUV45RCZ932RQUhyz7HfW2bxaOI8KxpGB9TUw25ImrY=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CO1PR10MB4675.namprd10.prod.outlook.com (2603:10b6:303:93::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 08:42:40 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:42:40 +0000
Message-ID: <2820554a-987a-4583-a2c8-b97434eeb697@oracle.com>
Date: Wed, 16 Sep 2026 14:12:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1266/1376] arm64: Enable ARCH_HAS_NONLEAF_PMD_YOUNG
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yicong Yang <yangyicong@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065635.757933915@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065635.757933915@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0433.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CO1PR10MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8cf042-5c69-40e4-2997-08df13ce77fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|4143699003|6133799003|22082099003|56012099006|5023799004|18002099003;
X-Microsoft-Antispam-Message-Info:
	vlExA+KK62P7g1WiZWJpXr2eQz62pkER7Y0C0K8uVxHi/5KY8YNOY61q3KtpkXMFG/VgczV59kqOcM26EOlRaVi3UC9L/AMJVwyG27epeL5GGIX//JVLqHqVJbRxDBV92q5LNEO5V9tO2MgzD4RuuMGA6U8elXM60go5IYBorSj+rKm/hYvHKQ7cCPMPuobYjNQG7lxw2kHf8lkrKj3ue7i8AkTqYL3IfCKMAcgc3KKFDOF2nYJP+ZIX6JShwZnIWWXtanR/KjdcqGo+06Sgo2NIsm1uEOFrTFvlV4JV6TIAqrxh20kI0yWlhqFuyRbCVYuWAyeZOy/ry/btdZYDh4d23oU6qNwZCP77uMJXdrTkKVg2hP6OvYtsaRMLTgX3nsQDYl1Vsi8LQg0H+NnRq8vtT9bSFA01gFgQLxCNjULn1laN+gZjcFHBDr/XKWoyGe6XFY5zWOuJOzlLL0vl99uNQkaswjM1+/GC7z7T17U7dNHUOiVDgd6zWo3Yfdh2NJIn26EWjsXumhJdu5m0rsf+Ozf5enqYtD2iXGH9wHJoxttocsiSv5Qwt+RJOu14ZtOQHzorb3kdt7HpwwR2yQwEDNJah/VZBE9HQMHLv/e/ClalIygijv4Amf2m1MXXkXaFOJ3yd1NLDuvlqXKdgD3kUSoqO1f1MhLASo4O6VE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(4143699003)(6133799003)(22082099003)(56012099006)(5023799004)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azFIeFYycmJydG9aeWdTQllZMGY0NE1zcG4rVXkwQk8vaERaUmJuN0ZVc1lJ?=
 =?utf-8?B?MncvbldhSlJDZjB5VUl3amRHY0dzbnQ5dUoyRGZ4dEtpV0VOV1RsMWs4dXQz?=
 =?utf-8?B?bE5lU0g3dUhOeUNDRVdKMFgzbTB2OERLa3pQT3krdkc2WFphbzcvZmVhTjdu?=
 =?utf-8?B?OEZ1cDhnWlE2a3NNTklDOXJGTFRYNEJ4R0U3Z2dLT0R1WVVzcVFFYXp4OEZr?=
 =?utf-8?B?cUI5d2lzVm16V3N0Z2Q5bVdFa3ZMRThiSTQwdEVzTWczZDJscmU1b28yUTlO?=
 =?utf-8?B?YjZVUzd0NjVsUTFFMng1eDArS3YxdC91UER0NXVNL1BOMXZEK2JlSVF5NFkz?=
 =?utf-8?B?QzUxdDZoZ2ltMUdHNDlkaGdKc0ZiRWxReEJvbzR2ZmJJUmN2RjZjY01EaXp6?=
 =?utf-8?B?TWxEZnljMG9RUmk5UW5IWHA4SEVqVW5mTEhtQkhRUU4wMjdoV01kTGdyblVE?=
 =?utf-8?B?T1lKR0EwZHZsOGVVQktNeXZpbWFjb1JOYnF3cFRUeGJNNkYzSVN4Z1NvQTJI?=
 =?utf-8?B?VzRtd0NqN3kvUW1yTy9xVGRMazZUUXNrWkFXSzdZb2o1b1JuVE05aTZNZ1pT?=
 =?utf-8?B?MVNEWmxOM25kNFI1RHJhaTBsb3VSUEpEVSt3T2JjTkI1SzRNNmlzS3VwaEM2?=
 =?utf-8?B?cU9WZk9SU0RJRDlXdzUxS0tXc1NuelNtaTBwZkZzbTgwY0RhQ2xRRVR4SFpU?=
 =?utf-8?B?bURsbzBrTEdmM3VLbTlIcDVPeDBRYnkxMW9mbUg3VG5ESWREbUlWOEpld1ZL?=
 =?utf-8?B?elpJZTFxMUZqbHFMWTZXa3FoZE1HU3Q0elpaajVPVHlxZnJPd1d2S2JTc1Nr?=
 =?utf-8?B?TlBvY1hzdmx1V1lubERSaXJFREZMWWxvQlhpa0Q2RXM4aG0rNnhCZFBLWHA2?=
 =?utf-8?B?TEVTUzIxVGd5VkFzWWZ5QU14OFRqMFN0RjNNVVY5Q1JPemhwZUJSTDVlZ1hQ?=
 =?utf-8?B?QjF3UDh2TndUTGpkMUpDYXJkK1dCZXFNTWFibFhyQm9yNzZhRFhqQ0FLeFdw?=
 =?utf-8?B?NTZpOTY5K1dsL1kxaUNDL3FkQ0JRdHo1ZVpqUVNLbDFjRGdsK1p4Rkc1eGVt?=
 =?utf-8?B?amJ3dENTL0hPOHo3UWZlQVdJZXNIcFpLMHdUSnBtSWpmblZjVzIycEZ4RmVG?=
 =?utf-8?B?MFRDSmF5TWR1NjVxNXIvbW5UMU5rSWFnMGVGdlowK3Bzd0QxZFk1eXdqcG9L?=
 =?utf-8?B?NEtWVmgwVGp6TjdVNGREZW5aV1NLZFJqSmN0QWFmL1lpZTVkYVZSekthK2J4?=
 =?utf-8?B?MXV0MUxNUWZSaTQvTnpBUnVEZ1ZFeCtFRVpIayt5b09QZU5NSUM0NlM2dmRL?=
 =?utf-8?B?VEdISVIwbXpFN2ZVTmUyT3VhWWlqNldaMU5pd2F3bC80UDFTajl3SEJGcWtP?=
 =?utf-8?B?bGF0Q0hmV3B1YTNyTmY2bnpPenBUQTRTYXdKaUpJR1Nob1JlZzlRUDRDTzJJ?=
 =?utf-8?B?blQ1VEJtclhxa1VXaEltY1lhNVRPUTZlUi9SRjhvTC9XaUd0WWh5WmUvMDhM?=
 =?utf-8?B?TGhZdFJVZG5UeFhjRzJpMElSbUNSelJzNlNlSTliaDl6NnpxTExLQUxOd01Y?=
 =?utf-8?B?UmpRNmNrMk9vU2tseFZ4NHZFNUVWT0hBc3pUK3hwQmdlMDEzVUxnQ2FaUDY5?=
 =?utf-8?B?djFJYXBtRWVaTFBBUHR2dEU2d1psZ1Q0emFKS2VuOUVHbWNTdWdYczA0ZjY4?=
 =?utf-8?B?SDI2Q3NSdGF4dXptVllqcE9JMS9KaExnNURhaDVSdmd4OVQ4L3NWdm9laEhq?=
 =?utf-8?B?cHZzMjYxVVhFcGVkdUhpc2lYTGwrV3lzdVlwUUFWdUNiQnpvQmVCcFRUbi9I?=
 =?utf-8?B?QUg1TnBFa3FVcXUybzZqR24zNWNJdHZTZFl1TlVNMys4K0dvS0t5VitMSmpF?=
 =?utf-8?B?SGJrdTdJZ2hPbS80UnJyeGJmMkhlZWdFVlF2akhKZm4vVUx2bUVKeStBdXJK?=
 =?utf-8?B?SG8zdnpVWFQrbCtFUXB4d0pJMm4yL1k0MGVuZ1VGUWphM2JIVDI0Tjd4K3BH?=
 =?utf-8?B?bTZpUVFPbjVRcmN3KzNqSzlFeUJuZ3pRY1BRQUt2YXFhU0o2QnNqTGk0WHRz?=
 =?utf-8?B?blJwYXYyeGF6Z0kzSmNwSE1tT3ltTGNyK1IxL3I1VzJ6a2s5ZnMrdWNSY2Qx?=
 =?utf-8?B?TzVVaFIyc0tYTG5DR0JWL0NGa2d5SkpvaERxRU81bVR6bG93T1I5VFk5U2ps?=
 =?utf-8?B?bnhWaWpBK2IvQTJuL1BXY01MQUlhOWxBaElRZ01yZk5tSVAyazhnMmV0bE1y?=
 =?utf-8?B?UENwSzhJVHZudUR3U3krbzJlZEU1UCtKNlVScUQ1bmdkVTBoMmRPS3dFeHB3?=
 =?utf-8?B?c1Y1di9MellNVExvTWxncFQxMEV3cm9Rb1M5VDdydCt4aUNUMGVFU0paRDdE?=
 =?utf-8?Q?n2ilLnNIR45Y00kbQa7894B3cwN1Jz63E/FTr?=
X-Exchange-RoutingPolicyChecked:
	Q2szj8nPxTJ1VOK89fnqVCK6yB+XEsyEDBcaMXGjx38jMCRqBEIBq9DolOHywF2ZaiUZGInQCJS9fMql9s8h8MLgfLRnsbWtQG34Gnf8EIzThLuDv0l69EhYU94uSa8mPN/P5lz9YZFxXEGP6R8AD3pcoWa/RLldfVcpG65yNIEAF3byt56Lwt5wVXeD+BUkjdlgkRAooanpwN/o81tPV2HxjHhymIeA0HLLtd48tHZC3EutUPVQJ/yiUh8jwyf65LDo9zbnyQZSXvE7RGInBsj1f0mr7FJLbvFWOvCX3R7Rg/AxnTSjYvw5hbOZWo9/G7Obf5mIu2DIvhAGPM62PA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J/HvoO/v4PIudhTViJnUzglfWfNCmKIUF9d29FJjhH5mg3+cRmtDf2K2ndrD0rLnuhPlXZ3ASWxkIrFVJUZw2A7oy8cwo30aVdMvI5PxcGyWmFVMW1oN7Zzrx6P585IIEM2oCiF1Pvs3qpcnUZWenrnYhlsPlmWRyxvguphxJQupIlZkPdFUrnwXxGWkI4QppGsXEa5bulcuNDKJfpwwzftzVKryblEpGH6612OjbpgungI13eA4aWQ7DNdj4XMNe9FSgj+RTOBFtyB2m6aITAZsHloIXCMR1Qb1TuenVQDmvlvw+FrsN+w7CbZGh42hKkhPyC+j7f8r0Ls2Ee6WKo351z/FGHh6QEMHJvh0Lb1NaGyZ2GSbLcnyUu4gbosGynRz1+I3cBoZpkxQqYh1gZqalWz682/aeocRzymcwJ5XGSjFTCWx13fX7m4oNeWqfYs84WsE8X3Owwtrt2TYhkhvK+AmhAEzKNmcHvcirM6ZmSxXM/t2Qt6G6M88/JR2I+T/V3tyDBFOoi9X1cwlQ0WJqmMiolsrC3ATKy+iPgBCX2gTSFVsCbYTzNsdaJTbfoRq5W7WbTkCFTcGLAfg2epKPjE8ls4xVwwVClys8eI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8cf042-5c69-40e4-2997-08df13ce77fa
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:42:40.7981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eojW7BvCTIL4VPGodkzNsTnuRUTJOamyxh9RB7PjBLWuFTl5QOcW1q26EplkdHtQedQOZwsdihzSEjyoGBzwBK+Gfz8M5zFKvloV727c2VDRWrQ2v2H+dJzXuP23AXiF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160112
X-Proofpoint-ORIG-GUID: voa9fiqcYKQ9MU18zaM4TSFjS1vx1uhj
X-Authority-Analysis: v=2.4 cv=MuvHeGae c=1 sm=1 tr=0 ts=6aaa5686 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=BTeA3XvPAAAA:8 a=7CQSdrXTAAAA:8 a=Mg4PJbWOFPgdXo8OkgQA:9
 a=QEXdDO2ut3YA:10 a=tafbbOV3vt1XuEhzTjGK:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMiBTYWx0ZWRfX3wquro1wqixt
 DMppexKwFbstQdvT+0aOpfhUq+I14vf3DpoOYN/ctcLfK691uofEGWBVnSvoo0mWS+17/DrXMQY
 bdtov+ACkVNvhyPGs30D6S1MXvyYGBUOcKFCrMfLOdpdGVMOuC+o
X-Proofpoint-GUID: voa9fiqcYKQ9MU18zaM4TSFjS1vx1uhj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMiBTYWx0ZWRfX1rzJitgz/MPG
 GYrbJMTD9zdfuegIbqIZgmt4DqHsdHFSQtcKxh2lazo7VXQYBxHvIqqgFwy4rSenWGXu9EiddJn
 aejq2UlkBo9QMP3zMoAC8KraAl8gtLbYlPutY0S/tsQ/qzOSEKOjg2gd+iK3Swei7BPFAolSyVe
 ob0LSh6MuAwheYXtQ2iaOf7xJ0ZkWE0//4qohu/RaIzu9Kd9iQV4ZMgBgXTENL7+ONaFn6RbGj4
 pZWf5nh7hOicVI2HcDy34lb197RyXUPuRFjzXW+IGJA+5C2blv7Ziv4DnpV25oQVZUiBIT26Rz+
 X9mYd/PG8R/qoq26arqmlHRDT7xGE9qV/cDqqF948c3QZlVkgjR9OfO2I4blnlGnhg+Z1CR2Nxe
 S6R3f+o8NvFmzeXDFnll00H448FkyXsb4eN48sk32Q7fIdGKgpvIf20BVy7dM9LsQFQv3BsuLnD
 tPgMQQ+5ruU+lhW/UYw==



On 12/09/26 12:31 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yicong Yang <yangyicong@hisilicon.com>
> 
> [ Upstream commit 62df5870ebf7cec96a51c9b9008daf167e22db14 ]
> 
> With the support of FEAT_HAFT, the NONLEAF_PMD_YOUNG can be enabled
> on arm64 since the hardware is capable of updating the AF flag for
> PMD table descriptor. Since the AF bit of the table descriptor
> shares the same bit position in block descriptors, we only need
> to implement arch_has_hw_nonleaf_pmd_young() and select related
> configs. The related pmd_young test/update operations keeps the
> same with and already implemented for transparent page support.
> 
> Currently ARCH_HAS_NONLEAF_PMD_YOUNG is used to improve the
> efficiency of lru-gen aging.
> 
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://lore.kernel.org/r/20241102104235.62560-5-yangyicong@huawei.com
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm64/Kconfig               | 1 +
>   arch/arm64/include/asm/pgtable.h | 8 ++++++--
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index dd98fa97aad00..10aa534852fb9 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -38,6 +38,7 @@ config ARM64
>   	select ARCH_HAS_MEM_ENCRYPT
>   	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>   	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

Upstream prerequisite code:

     config ARM64_HAFT
             depends on ARM64_HW_AFDBM

     static inline bool system_supports_haft(void)

Downstream 6.12.y code:

     select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT

Downstream refers to ARM64_HAFT but supplies no definition for it.

The patch selects ARCH_HAS_NONLEAF_PMD_YOUNG only under ARM64_HAFT and
maps the hardware predicate to system_supports_haft(), but neither
symbol is defined on this branch. The capability is therefore
permanently disabled. Upstream obtains all FEAT_HAFT detection and MMU
setup from the nine-file prerequisite efe72541355d.

That is a broader hardware feature, not an incidental stable dependency.

Maybe we should revert this, thoughts ?

thanks,
Harshit



>   	select ARCH_HAS_PTE_DEVMAP
>   	select ARCH_HAS_PTE_SPECIAL
>   	select ARCH_HAS_HW_PTE_YOUNG
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 2de5a70a47ce3..a66a474949c86 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1266,7 +1266,7 @@ static inline int __ptep_clear_flush_young(struct vm_area_struct *vma,
>   	return young;
>   }
>   
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
>   #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
>   static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
>   					    unsigned long address,
> @@ -1274,7 +1274,7 @@ static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
>   {
>   	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
>   }
> -#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> +#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
>   
>   static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
>   				       unsigned long address, pte_t *ptep)
> @@ -1509,6 +1509,10 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
>    */
>   #define arch_has_hw_pte_young		cpu_has_hw_af
>   
> +#ifdef CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
> +#define arch_has_hw_nonleaf_pmd_young	system_supports_haft
> +#endif
> +
>   /*
>    * Experimentally, it's cheap to set the access flag in hardware and we
>    * benefit from prefaulting mappings as 'old' to start with.

