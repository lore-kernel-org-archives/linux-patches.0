Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1922F3C4542;
	Tue, 28 Jul 2026 07:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785223133; cv=fail; b=D41IV2k5K031Hif2kOD4Fx20Rc5LZhgb0CX10ZN/B4ROtxaYaG4VcINfXNLEHOJGmLw78/BCXQbsvMb9d38f9wUyail0CgoR6aXreYpkP+HD93P9KmAfQp4SsJCWo5o4V7aR2H3/ZKw0ZJwuCvTOId6hUCGmUmNwJpvu5/fNiFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785223133; c=relaxed/simple;
	bh=YFW0IbKv0+Ephm6lo6JBh47ie2o8hvthMQ2TgMagfCc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ko+1ya+E2Z3JVjF8JwqJj5sywpOLi20mzBbrUA6O5D7Sr0pUUi98H1uTDLLkYM/0okysoIZy2Rqb4BX5ynP/pAyVvDabRkSYW4r1st5Y7tkULuJYq4LkxZD96w+OIDJhOebdSFOBKQAWXYTSHvomAwi5tF3yqeYY6z32Is7QPs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cwO238kK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a5FykJae; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cwO238kK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a5FykJae"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RKeINq2970212;
	Tue, 28 Jul 2026 07:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qP+YmX2aD3NuL2yb65aP+Igogf46ZXoM2B/uYwaMKcM=; b=
	cwO238kKzAzOTla+8GOScqsQUk0qHji93R7vNvesidFvBcF7FF5S49zngRS8jagf
	fuV1VAo/egvgz0M5yVNRTwjfIJPM9n6+U7BUJr9B9B/2z5V1I7k8wV4KTIcLB+5h
	CHI+98JPla6HJiOga9bFogdGeRv86TZs3eSEK9TjUIhQiQ400+hktWzUF74L87uI
	2te8Dl6NHYUeKZFDQO90ITM5wnRdpnVG8xZvqZZN1SarOAvyBsCNA8rN3cJcqMxJ
	NyEviJdtyQ/L7/RoWadByll3YfpFFh2N6QCpsuwwKmoP16PooIzFa7WfajHvNNb6
	M1wDxdv3Vmu3HNr4OlGMpw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xuam0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 07:18:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66S7AA5K012466;
	Tue, 28 Jul 2026 07:18:46 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011016.outbound.protection.outlook.com [52.101.62.16])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8916vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 28 Jul 2026 07:18:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNCt+LLI1K2D2aEjWbz7bw7UIkp/12j7jnClhgegrezx0Lw/kpolYSTe/G7Bfu5os3DledjozK1tbsLW3NO7XgVtWwb5b4v1K+OINZO6QctkMfEzq9v+kUvyKJyt3pbXFqHl+51Hw99GC40z3cZ47PKZC/vk/8iyI0r1yA5AnG6IeoZWgKMApRyikWV1Mn5tcCTDzAT0bn4Ucf+1LrE4//my5uhcA8OkFvvpnJNIbuKkCK6Dz9E5FIZse9mOK/mMRBa1sB4BF8lUUNjzojFBO7B8IZVDu2kGzTfcfnUPENSVKSsuR3oiaWnikyHIa9Wf06qgiEdgFdEZ8TAqD+WiBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qP+YmX2aD3NuL2yb65aP+Igogf46ZXoM2B/uYwaMKcM=;
 b=d6gdVLvWZwDperGJn9Vz16VHLohBpwHQUxbBr5MYe5PDcoipvkPMynTREdQIkvrlFWR2qly+bS/Ag0EKvVbIyQL5YXuf67bTRb/N+wbp6S2AftbroE3XkakQSaJXdFR66mFwyQgxnZPw6teaDpqBlEN+98vjTLFx9vivJgWXcAOD5GapAsDI3Lvio8y75PasYFql6stBeV08WhOIYroha706Jv2t7rGScHGV95++Xf6www7aIumLQAsW5IRzbRlcIGk9Jd4a0l4B0Gr6Aaw0TNkTW3UpEQG8JmC/N6UGZt75VvAlPA6dnuo54+f8RFS+vWjvTVBaetgsq0PseqMXuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qP+YmX2aD3NuL2yb65aP+Igogf46ZXoM2B/uYwaMKcM=;
 b=a5FykJaenTgUUMpst3pFU4MLZaDQEZazi9i1I7+XjTepp85oj5/jzufJD7pwSyySgLHKvErekQoj3sgOG83RpfSFYJMlDXQLlCGnlndEGqOIXhvSLfoM74qJZa+9VlrKz8rs/QbnKI1/x1KUiQ4wLneXDz4ccxnhfOmsvpmX8ms=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LV0PR10MB997969.namprd10.prod.outlook.com (2603:10b6:408:396::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 07:18:42 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Tue, 28 Jul 2026
 07:18:41 +0000
Message-ID: <3c0bc339-5fc8-45b7-8762-d0126abca864@oracle.com>
Date: Tue, 28 Jul 2026 12:48:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0454/1276] drm/amd/display: Add missing kdoc for ALLM
 parameters
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Roman Li <roman.li@amd.com>,
        Alex Hung <alex.hung@amd.com>, Tom Chung <chiahsuan.chung@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>, vegard.nossum@oracle.com
References: <b7e82885-cb8c-4caf-ae0e-1494ad94ac9e@oracle.com>
 <20260727202413.stable-0011@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260727202413.stable-0011@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0694.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::16) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LV0PR10MB997969:EE_
X-MS-Office365-Filtering-Correlation-Id: a1bc0d04-64c0-4ffb-99af-08deec7873df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|10067099003|4143699003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	lzItgjcVuoe6i/+aCq8JuXDhxmrApt7FN3UFFE/cxcuCdVWEvD5NM8Zxw9tuqgPVpXivSinXwKTylEKKwj+V3qQz/+NS4/NTKQpoJSWJRk/IEe6paN8jDiu91ersGXghnRWKQrskht5D4BMi+c8H9FCNOnihlY+3tS0cu8LBGavJCXQ/ecKKgIy1QLP4BvoGuU0lKe1aAnLUrZrybj0UYkl1tmmHCak3dvOVFjR62aFYe+/AwVeAGX85JB8mrCNliNJS0wGcMYfONljxE2WP6+hKATw7GzdRb/8+hktnU9FmEtQBlYUWUIg3mi5qs/0M8A671YVvwvTONQVnYqCMJmalK2jnSnuZw4qsX72zeS5A6Byz80+JDDXcb6mUKJH+TcIVlcFIUNpcITO+vAB2RVJ/lSNbZZmZqHqG7CNBZkNZT5Dgz8062hiTsjmrRL9PT4OrdRU+Fb1+uqrDXGuMfz21NwTiVgfDZ1Gm4HuoaL0ZFC7BPA8os4MVtTQV7RkfXx9cnUvNIIKSWTT7cDEVcITsLRCFR6FqPabRmSdwvDqc6VUXoZu4c9epmfPxCk7Si4l0gMoVmhORzBgb7bJELnBRVf8KSq8ziDFqD5TzXwhRvJXQyjx9+J65/Cy4+6z6UGDEOY6NfDU3jGW66aUQWOOYpmcuHqi5e+fkOJfX+4A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(4143699003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGUvNXlDM1MybHQwdCtJbGE4SmJoQkhhMDFxRkYwWUZMWDRmbnVvSkp2SDZI?=
 =?utf-8?B?dmtqOXIyTGtnTVJMWlZWakovb3k2VXl2UVhxUit4UjhUc3VnWGlvZlFKVlV3?=
 =?utf-8?B?R0NSNS9DZVFJd2RzQlIvOTVTc3ZrSExnNVdHZk1aK052VVg4bEN5Q0xiNksw?=
 =?utf-8?B?MEIvUkUyZCtUNmxSejVMVUcxWTFNQlBTNE1PVCtrM0JHWXFaeWhxOTRYRnpn?=
 =?utf-8?B?RStBakJ2MFErQ0tqK1VwWHF6STNFc2hwZDFqU29oL3hTeG9UaFY4bCt1ZjZl?=
 =?utf-8?B?c2JFTUNDS0g1c0g3UVozWjJSdUNuMVhoQzl3bVRMZGwvbThodHplZng5dXQ1?=
 =?utf-8?B?cU4ydTI2V25vM2hPcTA0TXpRZFJHTENOcjFPT1hyS3dVSEM2VEg0SkFIOWpu?=
 =?utf-8?B?cENOUEFZKy9LNUFGMFQ1UVdnQnZBWHVuenlWUC9JUFdjQ1hWblRXTmc1YjFn?=
 =?utf-8?B?d2ExQWlacDVwUFlmbVBVMmhrOWtVaTRnTnVrZDBaTHJOQVExNkNER2tobDg2?=
 =?utf-8?B?UWJydzZkQU8ybXBCUngreFBYMDc0ZXhrYURvc0RCbVVZOWp0UDBKcmh1aUQ5?=
 =?utf-8?B?TlE4ZXFDaDJ3NDYzdkMxUFJFL1JmR0treDFmNlF0NnNNYlZESFhlNFFibXVR?=
 =?utf-8?B?VWROcm5YR0ZGbE8vZStXZDdaci9pYm43dDhab0xDc2VKUW5KUmJUVWZOblB4?=
 =?utf-8?B?T2VtUFkwbXhwNDlvNy9kblIxWXlnMU1DRlQ2Zy9hL2RMOXlpdkVoeDlSZndR?=
 =?utf-8?B?MS9ISktQNHpRMFdhekZ6OVdQZkZTOVdiK2UyTUZOM0hTaXNTL08vS2lVSmw3?=
 =?utf-8?B?cmZaVW9yaUJ4Y09NTDQxdDlGa1NzVGE3TUZyM3FMSittblhaQ054dGZEb09D?=
 =?utf-8?B?VXRlYVRuODkvYUVQVmR3RXFyWDFxZjdPRjlvUk1NUXVLc3k4T01CV25Wbzhm?=
 =?utf-8?B?NnN2dDFTdkU0aE9Ba0l4QzNOM2JtNXozZDRIdlc2Z1ZrbktBdEx3c3BHQ3Ft?=
 =?utf-8?B?dlNlT2JQa2FKa0FVVUZrNlBOK3RxcUdLRmE0S1JJR09ETEZFYTcvb05VMFkz?=
 =?utf-8?B?U05veXN2QkNIRmo0WUV3RlJDWHhER3JyU3pvRXB1MUp0SS9CeDA1Z085eFJ3?=
 =?utf-8?B?ckx2dWt4ZVlBTjNuQXlhSXRyWVJpSjU5czh1bjRXSFN4MFZONEFNeGhUbkNM?=
 =?utf-8?B?Qnc2STJDSEpzcVd1ajlyakNSVG5UQ3RnbC9kcWw3YTJXY2tmbExwUmUyWEVZ?=
 =?utf-8?B?ODBBblRxNXZpL0VMTFdhaml2TS9FU1VmblFVcEZkbENrYUliT3hRZkV6VzFD?=
 =?utf-8?B?M2NjM0lORUpvTXJiWEoxK20vbmtwWDJZUkxvYXkyai9mOXlweWFvNnUyY2cx?=
 =?utf-8?B?ZEFlY1JOZWcwV0VXWUV2b2FLM1lSQkwvRy9vb0M3dVFML0lEZDZzQUFKN3do?=
 =?utf-8?B?TWNJeWIzMFlRWXpneTMyLzZqSFJ2bysybnFCRGE1d0d6d2J3S09uZ0JON1Yy?=
 =?utf-8?B?Y1IxTXo3UXFvcDQvOEFteVdHRGlUNlh1QlpmZk9SUmFJbUphc1N4bDdEcWU5?=
 =?utf-8?B?eUxid2ptaVpVai9Cc2g5RUJTSVNiWWVGZkJnY3ozYVNOUHNkL0hWRDNNOGlM?=
 =?utf-8?B?bFFYU3VhUFZFOWRGWElnUjFUbFJHWW85eUJjR3dFbnNvb3pxdDg5ak5aOUta?=
 =?utf-8?B?QkxnbS9HQ1pjamJadG1PTzBCSWY0M2dKOE14U1c1cmdIQVlLeFdJb1ljamRx?=
 =?utf-8?B?SmtZci84MlRqN1k0T2N4YTBNZmNlYmRJc2hyQ2tkcGd6eUE4UGFiYW5GVVZl?=
 =?utf-8?B?QkZpWkRiMXdwSGFzQjdUaktTckRuT3JZZno4OWZWYS9PMy9SOWYzSXZ3RFp4?=
 =?utf-8?B?cGk3L0pjdVZXbmJEWVJ5TUYyTkJvOEJGOVZKRTFiVThuRnZJa0ZkZzdrbkE0?=
 =?utf-8?B?RFdGVHdLUTBUVjVqNmZWWFI1RDJrUFFZa2hjRW5aNTZrSVpqRWEyMU94c25V?=
 =?utf-8?B?ejA3YVZEU0RLQ1BXUjdGQXpENVZYMEUvN2gyUmk5QlFHTENzZWJUMm5KQ3Ar?=
 =?utf-8?B?UURZeWVjaGNZNkRaR0RFenl6dnhXbzN3UXg5VlRHY0VxTFA5cDl3MlQ0MDdp?=
 =?utf-8?B?ZTgwQXNkWXlCZTNnZkFFZTI2cmt0ck9qaDRwVWg4M29CZXdrMlpmMEhQNVpl?=
 =?utf-8?B?aVhZaWJnSzF1NmVwdnVTK2pTVWRFajd4RHJsQldGWTFTdEVZdWxEM2hsVitN?=
 =?utf-8?B?L29sSXNLTHA4SlhQaDNyNE10bWNodzZNVll4RWVBRk96a2Y3dVpkS2ZoL2d4?=
 =?utf-8?B?ZFpDcUZlNHdnKy9BbVNFQzcybTgzTGpoSHoxQ0pkVEltUysxWjk5eHdxVVBp?=
 =?utf-8?Q?0TGZGUsVHMZPMKDfnm7EVxtnQoI0JD2LEyfEa?=
X-Exchange-RoutingPolicyChecked:
	JO1PqBUvdZEv5K8r0DwLLIZNo4QzZARmY4RD7Vlmc/vbQp3bK6ROBpCGBmpAJIVda1UuTjnnZCfYPfj84646iHfLOiYXX1braiW2HPCVLIAFBEUfquC1+5jWXvE9FoUg/cT881tnFoZJfKcLbUoSIC6YuTE/riUnq1JoRCjMLSyv17VflK48uH1HmX+SS2gOkRBTkipncDwdcdeJMXzhqlBO/7IVVOxuye5rR8aLjCs29G4jzjj+auCa5eDaLzB+9GQgyYFl4rY9S2dh2A03lsWHJ0LftK4WUyHJfiOf31Qc2XXzkOMHl84PaaEh06w1va5feUNfaj61GpeY1gmSOA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l4Ln5TG7APWQ21xq3dPYn3fdGv6GYXeGW0aHMmyo7rlk0kI6I6v76Bqg7TF/jAm5BD7anB6TMRM0+Z/4IOfu8Un2GRcKUoV9EWgnlPCzfb4w/If1nUlwn+/KC32rP+MetkyGCk2IoIX1hehKWcisLR+I9h1LliGJStu9AXka6Hgj1ZB8bxfddXAsXNZGEIzERefYsyiszqOygfogykf0p3tWCjYuN0Jf9PVNU9kKdjX9ViEf2EuoCroMRajV9CFBZCCU7igEBLDPJNBhjV6pDOMWMQWN6M6ggZcu5mK/u6/U18PCVLHDYadUsdA1cIkwsIvNvzU3Wb5uoPwFOKRzGZt7xJvEhguGYHAlxgsswx3ZjkXjIiFMh/e2pCylg6ssUBoAZP6NFA85Yi79tXo63c/9mXJKiUbIO3z3OjHX9hHi6WSBPkpfWQzZSfyjvBa2wq/XthkfIprjBVJ77bmuIWnCvysTwTpbM5mO1CBiKITtDxIPqI3jHrDjhNVVP47JJh8QPXw7CqpV6NjnyafmVAi2R1+GtYyb4IKf6UozsDw8No+kJYBEdLTEHzxG6OKaVwioj18JWmu3JB1OGVpezdQMwnt6aKWE+aYA1Tp3qic=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bc0d04-64c0-4ffb-99af-08deec7873df
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 07:18:41.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cBVN5cHilE5/jAWnwRIkZ917U58943/gVnzvHS+BjUNuR89pgrYQi7XpuWHLsMKkarNT706CofdVuuqYZjgCCbXLxfPoDxVcihxdTsYUmP8yl42ZvAOHnfH8d5mP0lZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=926 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607280062
X-Proofpoint-ORIG-GUID: _-DJcmc61TxiQy5uAlbJHQnGKQcMe3lT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA2MyBTYWx0ZWRfX1U0Eu2Qa9MVn
 JSuW0pxfE+ZjgQURhkKXnFjlnskboSlWzCpmrpSR7HKp5RNK5CK51nzo4gJMX1uBvqYddn4MdiU
 w08iN0hMX7zXI3rSBk1Zh8d41wvr4QMn8tKrI+B32r0d+P/lwMi0uCCGEIT0FqycCdw2PsJYhEp
 4SBW1Pjg+GZusLPKj5Luavg0VsrF0ve3zL1SRYYfukAvJ5U//TXBlotqHmGXIotWCoZ9eYvvqHn
 4l3kNAkQWsccDuhw4wgyr85UsGwe5WC4iTBsId24t3HeAFVNP1dBfrj8xHzhGWDpt3xatm+PLnx
 DN55ZuG0hPH5iUGSJw74dUqbI/kLOSck75yI37q8PSPTktvwAbAYBG5TalmpC+6XpttHno8PT2v
 Kjxv0b3mveHkYLwev8kCafXuB+6izAur40EjhYS3c7HyMs1Qf1X+w6EHK8XyhL1xuIq+U1W56km
 S5zstWKcv5TnJesRWCQ==
X-Proofpoint-GUID: _-DJcmc61TxiQy5uAlbJHQnGKQcMe3lT
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a6857d7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=IT1OQ3stXUWYhYfgZEwA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA2MyBTYWx0ZWRfX4Wsgs1UE6mpE
 Q31sLotNaQ3cfN7EtUFHVJ5PON1L0CtrVc08ObZJa0svGkbdG/40+gukp4VavLTvt86aC0BKln4
 4WLtHcBEXTfbgs0zqx/+D0t0QINlth6qJyMwCJM2SjzxBHewqt+0

Hi Sasha,

On 28/07/26 3:49 am, Sasha Levin wrote:
> On Sun, Jul 26, 2026 at 08:57:22PM +0530, Harshit Mogalapalli wrote:
>> But this is also a documentation patch which is not really adding a
>> functional value and with this being incorrectly backported, should we
>> just revert this ? Particularly asking this because it is a doc-only
>> patch and not really a prerequisite that would help other patches.
> 
> Okay, makes sense.
> 
> I've queued a revert of it on every branch that took it: 5.15, 6.1, 6.6,
> 6.12, 6.18 and 7.1. 5.10 never picked it up, so nothing to do there.
> 

Yep thats better, thanks for doing it!.

regards,
Harshit

