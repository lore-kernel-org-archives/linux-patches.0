Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F35470EB2
	for <patches@lists.linux.dev>; Sun, 20 Sep 2026 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933830; cv=fail; b=NiOs7NomZ1EngQ8CTHR72xxS0YgA/D92D0zlmCyp/Rk/oa+N05RC4pM00ahyaY6/UMbKO/cGSvcp/FYHZhyDhvB+hY1xjwd54RxjCdqofcgwkdWq7BGNtIK9NFS4MNCLUwc+dT/CbRJ9UJQdlFqo31ItARGjL6/TnWrOOJSct7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933830; c=relaxed/simple;
	bh=gkP7mKVJgdwur2eu6uH7SK6npZm1MV43tXJv0PzP7CM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=czPwAJ5EZU3LLyoryn+t8eaCh3pBOWEsIo/jqoou1CLTFw5Za84VikoICMEkIkZjp9zu4BQctGQZeNoNLjys0otNIXyeY7NI3eTFIxQrWHwgSHRTINfRoYLDoWJxMze0MoxBP0wIGHb1w+MQDVPtJNyTiMLLEkP6MRvQ36w0Sg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DcbsB/2T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bugl9Abu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DcbsB/2T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bugl9Abu"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68KIe1Ki1311741;
	Sun, 20 Sep 2026 19:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GDY0qSOQaUfG0ZjvBe8pUlehOxNKDyGogy0PuWxe21I=; b=
	DcbsB/2TY8TPtXDEz3qXvwv8zMNsMAiKQ4N3/cwxWCuWZYDThM+aAPQvAjzGxyzj
	61nRF7XA/KolqsoeWP9BAJEMZhVYONiEncRzamNUd87uS1v9NSVzN4+SkLk69I22
	apv6Cb1VEKjolEFGMpmQjpifNJNrijhOVibKKGtZXt/kjp7JWN+/DVXH6FvCJSlg
	edjl+n4GmBEXKMlvqYjCiCOM3ajeqx6nOv7UVlASg/v7ultiJKWOXmpSYt4OOXqr
	ownlAxJ4z+Aut2bUrFvZHCg9ZOPej6LEDMnm/BQjc6Ta1x9SOzPIw/rPrOBIbcNo
	7gY45BzCyNrnxXo/YiDiiA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk0h1d63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Sep 2026 19:50:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68KJo0EI001819;
	Sun, 20 Sep 2026 19:50:01 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012017.outbound.protection.outlook.com [40.93.195.17])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gtehxx3sq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 20 Sep 2026 19:50:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8lQ34ua6V+0MHeQ3w2VSdKtEp4SXawrjMQRbM9UsoUTVUD5LLSh3hUUzmhjSH/hvhqwrKROAU6rtGvx/3jejiqWniHuUk9cT8uSYx5+EwmQGq4DZ7uo4pmK0m7VwB9dzNSsfjK+9zGa/2lOVxARknSo3q3s5gUz97Um/tMfj3/kKUGVIrCP5wQYfy5sgek91iXY/kzWQsJH8r4HmUIMfn47XVbmHTlBLZ4DVpUOIP1is/hM3RTEOBpLcUGUbtsbJ3DTjyzHOhTENU8TdREcEZRy/xQeFa62cfkjSZswUdAHM9p49VniB0mRJI1bz+p85hLG/xK1SMH8GlPTgVcugg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDY0qSOQaUfG0ZjvBe8pUlehOxNKDyGogy0PuWxe21I=;
 b=A2bWc5dlwBQ5el1AX+rSxfeXDuZDWIs4vW+3+M6opV4AWmK/CdMGH6N5lxMq4C7lozq4C7qVAg2G+mgHS8A2hIHvu7MXjFmBiCaAgTnAGosveIOOW52mtnHSc5GzTdu7gK7QxXMAVaYArCYBfVBwNqq3PtRwNpcMXvtMn/CryidcIMAml5snHN7csskg+iiYOwz/8cwIQpTv5gNUxXhU0DSCUWLPsuT67MZo7t3+sTbidUF2R2JQiJuWsM0ECcHkrqieDGTb1QbHo8uiVnDfPX8b/0YldskbpSaOqvrKFNc+vlC06ejG+ZEnUzXEsjRFbUGB5JCrspM6aKNK4AYnWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDY0qSOQaUfG0ZjvBe8pUlehOxNKDyGogy0PuWxe21I=;
 b=bugl9AbuKqCECTPoekZEFNZpvLYVIY9QyO4ZflKCgOfKnVqK6s0UpQ6FeSKa6Ocps1QCJl//Rq82ePGvXxwX1uD8yeNYfePKwAcqMHbR5zmrjZmUsOh8CCgF7Vdr5YJYarHcJZpS23T9NaYQlQLu43upO6rHHPRLR0jKVpENesM=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA1PR10MB5946.namprd10.prod.outlook.com (2603:10b6:208:3d6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Sun, 20 Sep
 2026 19:49:41 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sun, 20 Sep 2026
 19:49:41 +0000
Message-ID: <9200dfdc-009a-4998-8d2f-b106d362e6ad@oracle.com>
Date: Mon, 21 Sep 2026 01:19:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0472/1102] mm/huge_memory: use folios memcg inside
 __folio_split()
To: Zi Yan <ziy@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151551.542102472@linuxfoundation.org>
 <70fbd5c6-2903-47e5-9627-4e028be7a858@oracle.com>
 <DLK9ZIXNO1HT.3B6K7O0U849Y0@nvidia.com>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <DLK9ZIXNO1HT.3B6K7O0U849Y0@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0010.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::9) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA1PR10MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: a72f68c7-0c7c-4f34-0060-08df17504f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|10067099003|22082099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Yy3n+gnX5IKErvb7SvTJ9SY+ilbCTzFzWQZyxjdT2ylpHvawap17SJfyEbJLJhRwFKP/kSyWuVJo0X45WiMXu+e21SA7hZBaM1a5fje9SlyrHy1gVBvHJmkPwka9t50/SJirxVVNLIsQN8QQppKef96aLBhJSFsJOZcr10sUmuH8OBTgXbNOtAlSi8Iuek+pPvd/XY7qwzNpF5t2qDRycUh9CnieOz0DFdjttKcNJR98+SHr55Rip6MRCRlYmcQ0ZE07iNa1cmbwn4nRHNIuuR5RJ89ctwtRyBftMzydhIWEY64a58Gd8KLxCLcBy1j1CxVc19j8G+UvXB58P0NrO/zHpp5w0un9jP7128Ldkvq0mLUoGd5n87r+DQV+ineoRV31NzwUwMU2uXCxs4TsZP9OC8E50ZqVbzrHCXq3+Yxv7WV08mNCXQWTW4G+ck4A/vT+G3Uo0/9IW17CHEnmUyXCGVKtq7OwHM7ov8footbniyh4gIbUVcrgJBJLekWi9O7OTGOdHk1eTWCf/SudfYCn/HH1DTE0UkJlHP/S4/eZqt+sl7bfZR+AkkU9+9g2bWJSpZx/0GuSMuIYE2c1T+1NLiEpw1xJ+Zp8M+tVdljMPTaxtW4ac4AbTOhnb3ay
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTIrK0E3d2JCZ1JxL2Jsb2hYYTVmRXgzbnE1ZEVGTjMzdzcxRzJwaE5reTBU?=
 =?utf-8?B?T3BiVVk3SXY3STVEMkZHbDRZTkhOVDdkazhQd1pIbkY4ODg4MER2TmNZU2Mx?=
 =?utf-8?B?WG51NXI2UEF3SUc3aytoaTUrTGh2bTI1WWNJM3lHWEtLUmk1c0hkVDQ2c1g3?=
 =?utf-8?B?UmRyeFdpWitGK25XMmtZVG1NcjJBQmluZnppTjc1R09LK0RCVlVmMkxWOEpl?=
 =?utf-8?B?QzdtcWhMeURWVkNNNXg0TEZNUXZOd3Zva3pqdHZDejlpRXZRSGtpeDBYbVRO?=
 =?utf-8?B?bFMzb3NqdW05WkFxUVRHRlZiK1g5T2oyTVNhZW9IT1VQR3gveEdSRG0rWTVu?=
 =?utf-8?B?eXk4Q3ZJcjlrZ2VJbnZxNE1jRHBkcUJpbERRZnRLZFp4cmdLNnNiNEhQc0NI?=
 =?utf-8?B?T2VRUFc4RWhxQlAwLzNGSS9zSzZCelFGNFlwY0Y1Ym5aaUkzd2ZJY3RPemtv?=
 =?utf-8?B?b05QekVaamhZQVdUUFlVbTVQenpXRzg2REIyellHZ000OEQrRVBySnJqYkt2?=
 =?utf-8?B?UTVCMlZzdE5CWll4Ym1VZ3NjbG1FbnAzdTA2L0NVNU0vcVFlSTBTT1o4clp4?=
 =?utf-8?B?dWtPZWlvWVJUL0hvVzVtdkZqU2dlMWhFRzVtcmpEa3dTenhhQ3BoMnpzU0dv?=
 =?utf-8?B?Wk1aUVhhK1RJNXd0MHV4MU5aQ2pyd0Eza0U4N0hpL1BNVEUrcFRPVHl1bWkr?=
 =?utf-8?B?RTZSYjA1M3dMVXFCSXdPU3NINGMwRzRUWHFpZExPQU4rcXlwK1R3U1hYRnpS?=
 =?utf-8?B?djRzdzdIZGh4RkF4VDBUQTZtdzhRcTZQWG1vVTFGd24xTHFpVWQrWHBOeWRX?=
 =?utf-8?B?TXN4cEJoWXFOejJuQlBlVG1QNlFOL0JtNkFTWnRra2dlUWJLV0NGVmMzWHo1?=
 =?utf-8?B?QlRETTVYc28xWGRIRGlqM3ZLYmRKS1JicUlQM0Q2RmphKzhhUFdKRlZ5Z3Zx?=
 =?utf-8?B?c1l2U1lodjkrOUcrYWQvaml5a1htTG93N2JNZnJBZFVLNmdpZ1plTlQxekh0?=
 =?utf-8?B?djZoZENONE4wRVpLdDFNUXRrMTBnejBZa3E5NDU0d3ZmeFpqSFlxRnBZa0F5?=
 =?utf-8?B?UVRxUHI5MVUyWDJYa0pPaUFYdzdKWWdPdTlYZUR0NGlGV0F3YVRLMThsRGs4?=
 =?utf-8?B?bmdXM1ArU251VlAxeWUwbFJPL1hZbE43K0lTRUtDdkh5ZVpNRktqRHVnNXhK?=
 =?utf-8?B?SnhPLysyOWxrZnJSVzEyRTJrV2NKWXNLYU5wZjM4SlFaRVFydHI5a2tmWXVa?=
 =?utf-8?B?M28xU0lmbmowbGxjU3g5cGh6UTFJdVQ0eDVXZW0ybC9PVzBRRlBFWlh5aTFo?=
 =?utf-8?B?UWVQc1doblRJMHZUMjVRZkV0a1E4VTRDQ0ptN1R2WHQ1L1lvV09OSHhvTmhZ?=
 =?utf-8?B?WVJSU3cwUDJZMjhiZS9wdlg3Vnd5WlcyTkh0ZUd0bWJuRXRBZFZKWTJiaTVU?=
 =?utf-8?B?UzlhK25Ga3JxR0NSRmdmZzFNbFF6c1J2ZlErZk84aFBtaGdQNmQvZXNGRVRq?=
 =?utf-8?B?ajVWRDdOVldHbGtEWW1mbTNrM0hxOUszKy9qU3lndmxHZWJCaTUyVzFhS1Rt?=
 =?utf-8?B?SjRzTm1ONlNSNlVKZG9GRGErMlMxd1ZrMUExSytpejhGak5Oek14Ry9MOERW?=
 =?utf-8?B?S0FJRU5Rc1VHZGZzMzJMUDZObEJSOE9pVFdGL0FQUmREUGMvZG90U21aYmZN?=
 =?utf-8?B?UnhYZWh2SUtBNFpnQ1VoSXhYTTB4MzRwaHlCYlQ1NTZ2S0JpRVJFeE02ZU1u?=
 =?utf-8?B?dGZCYzgxaTgvK0ZoVDJkRnBBUHg4eDlaeWhXeGg3VGwvVkFSL0xQQmxqUkNt?=
 =?utf-8?B?Sk1teU9Xa2F0MGM2dHNyN3FLNFpsUjhncWRlVnU4S1dXUzAwSGNMWWNONWNF?=
 =?utf-8?B?d05sWHNTbFR5WDl3TlYxRFo3NjlBcnZML3RaclRBWXJJdzE1SGtxVEFKS3Zk?=
 =?utf-8?B?V01lNDUrK2VmT3JBRmR2ZlNqN21SdlhBZTdNRXhScUZTYnBSaUNKanNOZXFF?=
 =?utf-8?B?ZHE4d2EwT2xNc09rdmJIb3pSYlNaU2h1cGpRN2ZBT1BuRk10Qk5TUHJTb0w5?=
 =?utf-8?B?QWM1VFcrZDJQaTBRZzh3cHFHRVZ4dnFIejZSZGF3VWZ3c1diZHhQTHBOaHpw?=
 =?utf-8?B?dlFLRXZKUUJ5RU82a1JYQk9oOFdnckZWcWlZMnJoRjdURVh2bzNEL3lGUWVO?=
 =?utf-8?B?dnU4bldlOXg1b0R0YTVYbTR5Mnc3L21NSFNra2FUTEpGdjdhd1BwNzhzcHR6?=
 =?utf-8?B?bzloWGEyUUhuNUZybSsycXZoWndqQlg2Q2FLczJZOTFwQlZpeUl4K3NZcnF3?=
 =?utf-8?B?UTJXQmh2MGRRV2NEUmx0eHhjTmpmVTliZit0RmxqaEhsSktxMGJ3UFJET0FE?=
 =?utf-8?Q?z5gYUOyMhg/jIWnd2/nG69/SthVj1AAelg7kc?=
X-Exchange-RoutingPolicyChecked:
	khUQ88P12gvI2/x2zIDz47WZVlMmSY1u/1LCMqY05uoKONirZ2SrVTYvoUvNj0mIsDkauE2+bO4W5YNNG9s7ihnqbhGn63oeI7Z9jnN7LwOdrDXVdKqH8g52qeyplviGBzKg0GoQ1TExUtCsz7oS4Mj68NQMa/7PJ6JI3U+7CHGB+3dj6Igx0Eo92FqMEfcey6zDYAmiphR9Z+/McLMQW6oWAJlb6zMVvRy0ejbrdO/mly9pXx8BOyB9WSyQhSMA8yGemqK+RSHaOXALxj1et0xemvVtuUhuV1Efli+dce1fEKaNi7xap2+hGZSc3B9/J6KZucCKis1oxD123+1BJQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ewhbUwn6os491Oc7k9bCRbDZ0fBDojDPIJafS9PhKyBfFF4pqVU0+qWfjPhruI3YKfQL2pbGQZDUtp0InPB9zqPh3rFIcJ+HgSN0NCCo5xgbcPv6LG/+hhWOxorS0JBy7XatJ+bEMVDyUWvM7ydLwbajlfenAChfz6brM0I45Ukzujpmxxq0pyMjoFKtQnZJnLqORB17kd/LD27MyGMJk5QDB6nl9hj0T9xaeDMQw1a04Y3SYOFcqslbFZAFhLYOeR10xz4Uq8Ttq4CjWIpDPyhiHW7cBET4Vwsil+VSjh4UrEY2IFAhV/YJLNCEuXPDNg3D9cWEMpg1WTtLaBNQMGS9fDlz4AJsInYPKWAibyoHzZAjS3FLcrEhVv4SQWklKtjXxBoo7JgYcQF9KMeBkXiBuG+Uxwlolf70RXhARFgxwagzSW/VJ4vsbb7nq9nZMQ9ZoMN6jaJoda/MJ6bt6XZ74/fsKJJRFIl8+dgxmheWtwpRAUHrc2CZfm7q7NnK9qYs6wQgeU0b1Y2Z0zvIcdwchLPLG/ZY2BLIIjXCoLKWhEx+e3M20al+MdaQqtPH3+ESOUVN3On1rzA9Y7vLRH9TYkmbENL/B+/3+1UZzhU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72f68c7-0c7c-4f34-0060-08df17504f92
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 19:49:41.3016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oskANy+Ty+m9NCd8ZxtBW1ghuALvrKUVvS0skJ/htly743a0LjkENSlxF1zw2OQIiHP+CrcvHFrP/Ezldmm3II3IaiLx0DCHLcSdyFk+T+0UuG1v3rLqPfiuHOhzSI4p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5946
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_06,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609200291
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDI5MCBTYWx0ZWRfX206jUVGpHgjP
 1HJoLyB8LfHPTsbfGSyR8G4g5lBp3B/ELKkGR3XJoRrnb3OEosoGubfWEb1f0b8vthBlKTk+Z06
 sDtybUeskYYTDoTw2RiirEKnRpeMMs81lnITOGvMZZSGMrnXlkWL
X-Proofpoint-GUID: XQ2Q4Bv76Uf7ZFnwVfPWZlOIn6bU5EJy
X-Authority-Analysis: v=2.4 cv=CNa/zhrD c=1 sm=1 tr=0 ts=6ab038ea b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=ufHFDILaAAAA:8 a=3cHpARXcN2cUhSZgTY4A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=ZXulRonScM0A:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDI5MCBTYWx0ZWRfXyFGRWatrkRUC
 wfQP0egDYUZA7UKy8Dt9A8+pqCcZgzi8+VMIWK8GgdM3f+DCUx32SN8QA214FCK2RXebwlSAITx
 nPwImFOZxYF3TvoGOM77h1gXVwgFVc2V7u+sYHYMl8uC60e9FkKTWeS6w4qCbyoqmiPpHcK8ol5
 2b+hCtBw7WTznuRgep4NFhNWj5+ri0KKOspYA0g1WcJHvjryOEtQ6IaTPoDmTia7xsnKy2fz7u8
 cp92IsYS14Sry9l5N6l/FBGQUthEus9DU8JP2/gZkN1O0IUxkZeiatnPsI3bRhBQ9WAWzKv+/Rc
 xAb3mvTfvj7Ksbf00ZjOZJNb56N6hnC4jrqzTlcAr+7yaI2Blzj0VbQuPLYd5DqSD8qA9Hpcwjc
 XHg403JrC71y4xegHmySNHRk0pllAazYCSOxfnwN6cC3sXsD5Cw+gD4ueRcCs1eLtn47jKN/L7Y
 uUfD4dQBLEQBNIZTuhA==
X-Proofpoint-ORIG-GUID: XQ2Q4Bv76Uf7ZFnwVfPWZlOIn6bU5EJy

Hi Zi Yan, Sasha,


On 20/09/26 9:44 pm, Zi Yan wrote:
>> Maybe we should replace the folio_memcg() use with the upstream 
>> referenced get/put pair ? Maybe lets drop this and get it backported 
>> correctly next cycle ?
> 
> No. 6.12.y backport is correct. The same reason for 6.6.y backport[1]
> applies here:
> 
> |> Before commit f1cf8d2f36dc3 ("mm: memcontrol:
> |> eliminate the problem of dying memory cgroup for LRU folios"), like
> |> v6.6, a charged folio take a ref on its memcg. During split, the folio
> |> is locked, so will not be uncharged. As a result, its memcg will not go
> |> away.
> 
> Commit f1cf8d2f36dc3 is introduced in 7.1.
> 

thanks a lot for checking and responding.


Looks like a very similar report was clarified by Johannes and Zi. Sorry 
for the noise.

Sasha: Will it be possible for you to re-queue this ?

thanks,
Harshit

> 
> [1] https://lore.kernel.org/all/aqMDyxhGXZyhcm5H@cmpxchg.org/

