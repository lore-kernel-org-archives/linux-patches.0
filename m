Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A93603DA
	for <patches@lists.linux.dev>; Fri, 22 May 2026 19:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779479301; cv=fail; b=RQqhQM1L4ePA9nAzWOXPmGyLT/Z2+R9wYHGT83XEqAlTg/unj+EXU8h4rNHJ/kGm60Vw73I8RiEWIfkMZwN1sldJMnqthHExOeW2aYvDK1YbGitD7hlvWDnV9lLx8WidYw8D16LU+PMoOUn9NMDFzcDfpONZMdTNVPSgWmsLX5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779479301; c=relaxed/simple;
	bh=iRcGIUjvl2h4R5VtLjlTiygqoOrnZVi33gMP3UgmCBU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hVD4FfwOtEp6Ogs89lu1/p3QqGbZkyhZNwicIaxebHW5uZaZ4o3+IIael1wQUsqOIWtHLq/VAOpCHG8FXziYrzHre3q1BDMnhD+757JEU0yjnsghKZpsHRS3QNnaAXDbg2wqvgWZqcuoXrAtctg5sBi1SMgsCmrGcmbJT7SScbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y3vPT+oY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nFgfNLHY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y3vPT+oY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nFgfNLHY"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MCbm8h3752874;
	Fri, 22 May 2026 19:48:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cl7eIOOhqFTqVhUWZrTlZyc24ntrhYjyZ8DaT7vBo2M=; b=
	Y3vPT+oYvbfjVE3xG91zIRwKNTCHDF3LTmwdJ9MRjSnwfB727lxBAuK3B0XJAW53
	VwIy0X1gHRaVVR4PyqyYfpN7Xm0CyZP7SqV/hKG/zJGcmq9mOIjBD+U3uu/WCn4o
	J15bw0piLzTCNQLvs8EfEiBZ8vyC/Skm5pIkzDDnSNvK7u2LHKseE5NsZbkvybJg
	twSBj0zKRQw/2+gXHMLUku0+CmMyObhGxzxxUVIKHpBAbod+7y0QXh4fXA1XL0/J
	QT0AZv40YtB+BdFuqsZAwkpyQ1lbbGkCcktiD4sm9yGHO9+QrqQVpMcPpHddhyLP
	1EnBdOomHbHLopHWbmHGeQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h1t3gcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 19:48:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64MJjnaF026767;
	Fri, 22 May 2026 19:48:07 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4eau1u5ydx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 19:48:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D58Gvdq84ihTsNK7V20rX3t3EZyGiuE9CGgvyUGv5w1pe2cl4i80YLbXAItzDeYL5npPAVLUXD/lXDCGM89ycCRgZWzvlplnda56HtwvKEjhfsmR4Y7gAxVZschrd4J7B0/U/p6wo/zbGUsPfpk+qucRffHPxgmy1FIwGps05Q2cV2vti/rQJcQAZqjy1ZW3iacNOBgg5VYilKzuQ+7WYT66ZDmMcv1B0p45Om+k49146Y6Bxm07c6r9kTyGZGf4hlAiiZ60TxrKWK9rG8pYZDvQDaywPILBgu0qey/2+81hda+fpDb9tkxjjRH+cNQM4M33sCHddKEaqeDg6KkiqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cl7eIOOhqFTqVhUWZrTlZyc24ntrhYjyZ8DaT7vBo2M=;
 b=XKe8QPi5YXdJIQh15uQbrw8DgrNcT/8kLm8+MMUJlW8eV2ygfutcvi9OrCuHGb0NADPHcOgCC0EWg6I+g70YSZ0kFqNuFiDTMfZOZSgF2AXM4TEahLoy4MC1rga0LZzd0Si10H6dAhZoJpLhmie0OtaH/2cE3vzY9LPG89d47SxrO1tGMgYzj+BoEa3kLiYfulUNmgB12lCBBW2q7sBPGUOQGSwm37Fhmqvr8J/qv6sgnGBJbmUVE8bOL5ZCwVE03XUHJZ/kc2tDzOJN6b/0eSi/ywIZRhHgqF7pc5gzBiaNSoQf8hR9nrB0DGNNIjd3cUNMr9ysP4TNwm3qGrRH/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl7eIOOhqFTqVhUWZrTlZyc24ntrhYjyZ8DaT7vBo2M=;
 b=nFgfNLHYcR31okZLcIJJkY6YUYQF96QX80GwsYdJe22IC6CAwFqjjLXhTYbVaPquwXSwuq8Zk/R1XMAQPQpW+H/p+7k20bMhRwzAGWFnH4+IGJ3xNogtE6HRV5uowkT1PeFxGWGirx5qwK+0c9k55bBFOyh1OWPwZ8dQZGqR6m8=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LV8PR10MB7726.namprd10.prod.outlook.com (2603:10b6:408:1e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 19:48:04 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 19:48:04 +0000
Message-ID: <8a06c5c3-8f7a-4252-a3b1-0c0d812e2654@oracle.com>
Date: Sat, 23 May 2026 01:17:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 505/666] sched/psi: fix race between file release and
 pressure write
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com,
        Edward Adam Davis <eadavis@qq.com>,
        Chen Ridong
 <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162122.206605865@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260520162122.206605865@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0216.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::20) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LV8PR10MB7726:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bacc1b6-6f4d-4a24-08e9-08deb83b0a0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003|6133799003|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	iyEhVBprSdZhv+5CVeCAfXkGJ2/OYTjI5M/JvvEx8I3rgpTO50zGfoe+nbwZ/9Cix262FQWb1CKfDilE/YOOjaDuJuoDezuPSamIhtv5KwdQG7pZOJBe085Fmy7P6pPZSKNwVEatMGI3Gp0p5Knj8YvX0UCQPEyFl9MKs4eAGJb/knHNgFPyIaLKk7z9hrr6YlHAqypgpKrlsVuKtXjk9rE1Qo7an+fzc7vOl7u7HX93U75D/hIsW9zg91fu8CiFYDY9GZFkpJ4tMCA/blcagO+A9rzqjAMpkmWQeEGlYwb4mAIsyvHOlY1PCU3iTLffD/WcoSG1xaNPhSkVDU3O5bmDf1Qk+M6TwmKBJ+BixYgQt8AmFxi1btmIt5RnjbrVe3TmHElcsrx1KwwYNf4J3pMowrmTWt9v6RhI0rrIccKiuzIEEt96ihATmmVjbRwxEXzOys2YAkRNY8mqO3c1aBnguiz2yeDN43LnJAcXXxI8YpecZBoaPS2dPTa5soaRl2jgctfT0OeRSe0HUhEelMSKwRK1U0yndZD+zKGyeAncYys/r/fUUqcZBgVncrg9yLcLxCQM4AJmnjQzqvW+uQsu1r5XSAA3c4OIkeRy7FDzDyHWqgrj5415YuW7kIQ0k5qJANVVww/3eLrS6ykLjg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003)(6133799003)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1UxYlhKRGtUMG9UNTRaaHdleWx0cEVLejVIOU5ib1hhbDIvMDNoNytsNkMz?=
 =?utf-8?B?L0NGY2NTMmVBZktCWHJ3MWUrUE9GNytVMlQybU83UmpWODdIeUF4MmRwdHRp?=
 =?utf-8?B?SWhpbEJwTnlvaWhUTzdZLzA2SS9vTEptSEhKS04ydjc3aUtxOHlxSzNUaEFQ?=
 =?utf-8?B?dHlOSzloQjIyeHZNak1qcW5Za0drZ1k4WGptZHpxVnAwUzNWU1ZuVURya2g3?=
 =?utf-8?B?QVpORittZEFBZXFaT3ZBellRangxbXdIeFV2ZU1IcnBqKzVJdDBnTWVrWnRY?=
 =?utf-8?B?SzR0dTg5VU9nYjhaWHJINitTSm1USTB1eTU1dk5HUnMzV3Q0emcxVmlMYkdQ?=
 =?utf-8?B?aVloSkh4UlArM2FWZGMvY2JuS1JJMnFzWDYvR0d1ZFFldnRTZHluZFdhT2JD?=
 =?utf-8?B?bDNKT0pIeGl2QzNQOCs4Nkd5bWM4SDQycXNDY0hXQVZxUzZOczdqeVgxWXlr?=
 =?utf-8?B?eG5nMW9sM1EvWG1CbHZkbjl4NGd1SXpvdmY2OGVJRzJlbk1OTXh3NWhseVRk?=
 =?utf-8?B?VXkwcXViNjB4aEZMRVIzRVN0a2cxekR2YjArckxWUUxoQ2c1Znl6cHpyeUN1?=
 =?utf-8?B?OU9POFZkcE1rb2ZHUXk4dFhxNXhNZitIQUp6Tk5XRnNnKzVpNXFhZ1lSUnhV?=
 =?utf-8?B?RTNBQktSM25tTCtIRlNWQWYrT1hiaVJSOXZXc1EwR1g3Y1NqbWRYOS9IM2Jr?=
 =?utf-8?B?ekE0MUQwTENhcG56U1dreVpLa0tWWHdNWUxrdit6UnlYNlh1VjZ2U3A4N1Jo?=
 =?utf-8?B?RkFJZTFHcFhlazVtbkM5MlRtY011ZlowQkNtZkhad0x2WGtSdW9uNmZmSnJZ?=
 =?utf-8?B?VVFORkdQVGo3TlRaYTVLSjY1Q3VQbmlJZnJlZytJaTVvV05MSUw0aytrOXZQ?=
 =?utf-8?B?NE56anFTQm8wY1FicDRueHpYMzA4WjVveDdKUk5VdUYxUUdrb29qbi9zajlk?=
 =?utf-8?B?QWQzVzA1NlRaTlg1aDZQUmo2RTRCKzRGS1JVRHZ6amRvSlpYblRWcDBoOXoz?=
 =?utf-8?B?QU9iZFBQL3JMN08wdmxQRk9LRi93MTZKTE9CcmNERjFHN2tCMXVKdXdPZzZL?=
 =?utf-8?B?eEMxeG1HbkwrZWExVTJOSkVBQVZlU2Z2bWRUc096eWhJSEtMV09rZnpEVWdI?=
 =?utf-8?B?RmY1c3lWM2Z2NjZpUHgxdXFoRGRMYlljV0pNSVd2NVFNb0JwOWIyeHRDSnl1?=
 =?utf-8?B?a3ZReDZpL0FnZGNra05KM3ZGV1BKUHk2aHB6OTNIZWQ0WkVXTXRvYzdnWmZu?=
 =?utf-8?B?YVpPcTY4ZDIyc0JObStzS2plTnJlSGhYRnRiazJlbXdzTENLNmdQdklFK2ZX?=
 =?utf-8?B?bjJFQThjOUczN3pxZFRraURDWG9Ob1RrQS8ydVplNHZpV1duNVBKYStpQU5B?=
 =?utf-8?B?QUlZQ1lkMVZmaGV0Y3Eyd0ZZTFhSOGpYdlJvNTAxSWZPRjNuallYa0ZGbXVq?=
 =?utf-8?B?ekhGaVdvRmc3V1M1eFRKMVdOamo2VkFZZExQM0pqMS91dDJYMjlwY1ZFZ0JZ?=
 =?utf-8?B?cE1aSU0wNFhsRkxhdUdqRVVEazhqZ1VySW0yTjlRdW4weVVpOGJjVFU0UVlO?=
 =?utf-8?B?SzhLOEU5Q0hpTXZFeEdndzRJWHlXR1dIWndkUTJmUWhUWFVWVlYzQnBwMVRV?=
 =?utf-8?B?Y2dBUVB2MEVuYlJjbEJnQlZyYU80K3JQeDNNMWp4K0d4Ukk5VHYrMC9jVTZ4?=
 =?utf-8?B?cGZSK0ZoN093TUp5MmxySlNpRGpEdXYrOEl5VXFreUdkcE81R0NYTEk1V1lk?=
 =?utf-8?B?Zm1IWFZKbURqVmwvZmZwSDFQRkk2MWJFbVpQelpQMUFsRmVtU1NkQzByc1pr?=
 =?utf-8?B?Wjh3amkzUGt4eDIrV0NmOVl0bzFaMDl0bmVQZE5LTUg0NjVsNG95TFk4c0g0?=
 =?utf-8?B?cmNsbnlDODdUcUQ1S1U3eXQxY3dXOG00dnJHT2UrdVJqaEd6cVQ0WjlocDRO?=
 =?utf-8?B?eG1TMFVCM2xJVDVvUS9xaEt2anlreGNMbG9lazdCYjErR0ZKK05HOUN3NU93?=
 =?utf-8?B?MStXNndZWVhOREpFWmlWbkEzZ3ppOXFZRzRSdDBtNjBVNFgvZ0lDRlhEYjlt?=
 =?utf-8?B?b3ZMZ0E5Q2FZQTdnUzZoZ25DYU1OSVY4Z3hPTFkzck1DWFppVytGZjczcUQr?=
 =?utf-8?B?RFQ1NEZkTm40N0YzRitHelUzNHRVcDBxVStGZUtNUDFPSUE1aThpbEEzbWhC?=
 =?utf-8?B?aTNtNDNLcFl5eit0TE9rVXNIZ3JuWEt3Q3JpWitKMWhHSm0xWEJ6N0djSCtP?=
 =?utf-8?B?YzRTUk1RRmVBeFd0L29qVjZud1MvYUVWbVlUc0c3M2kzb3JLSWVvTHU2b1Qz?=
 =?utf-8?B?SDdlZkZ5cVRqZmYvNnBqcmZTa0tkZHlmMWVVWXE2N3lwOFVOalo2VnNnblF6?=
 =?utf-8?Q?I1Hp061DHq4xRBMQATxA4y0HptQPhpo9dy6lV?=
X-Exchange-RoutingPolicyChecked:
	IADdZIQxAJ4STyKDWSHTQ9+YM4aqkNRx6s34h79H5rxdabckfaaTVoTRdOoWoyO7dR8B+nZPGheJMbpwdv7dGYoysuRy1J4iXEMrFKxlGgqRfzkRg+7CXq2UeyF2uo9Qto8i433wrGY/JN9HgH16snI1Nb2qcJhkLnoKlLG27duFpzDuL2W6aJXtdLeuEnoCAvtG3nQyFZJAtGAFm2Be+bnh/BSQSdHB8t+NmBOP6xnA8lzlZ7kMokPlv7+QffxcO/8ArnsfDj9tPjM5rUyXD81c6cVq9D2bZsyxBkG/RLemJCeJSYJDdE+/eL5D6l3C1quW9mDpaOvbO6WDTrepkA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A5gIz9MoIYguxBrz8N2KlwhlQX6u7wWjTU/eThSJX8kA+dx7ubN8pQUYlL9m08AiN1jhJLUZKIyV7LxOKEkqvSSDeoGotDzNW6PkC7+SEKgVgIvQXQRRFhVte3u+9Kj22HhteDZSpGHoLQLwizlQgQ4Yw4AfVEzZ9T57eLnFS5ULyfYxPb2DihDpe69WNVPS65obPR0qkpeGLn7dw1iW62YwMN8ZUdD4PnOSORm+JXOj2qIhkW47V7rJGEUw93i0IMCbe8xOw6WXpmskN9LMU1cWZd5/hp7vCCWisXur3FlC6h4eeplNy4fVSi4SahIby4qsSpqamTsaVWDM8M2IxyZ0fcIS4gSgcGramvZThLNsnh5Hc3N4tsCv+Mfl7vakJ/RghGgCy+YETJ43IXU4kIjARHxyImQdedLt5ek6Ba/OmlAStJ/BKZDtgf37CcMyselDU441G3rbLA9GJ8RXlNwMkmn7wOJEP97hlVNdUzq6NNS7ARFR9JUhQTqPYQqwhJnDgbdkekFXzdOPZsa+iRrCF64whCagYrY1lz7CvyJ5fxM/I94avh5jEDNYw7J3WspOvopDzw4vMsWypyIS7SNcC3+G9Fs6BIr+zzhf6Lo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bacc1b6-6f4d-4a24-08e9-08deb83b0a0b
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 19:48:04.5397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGXKFcYSRurx86sY327Zp7v/IGa/qAHNyw+QHG4FPoDlghRfZFNcsGcj+/Ha6l4jOuQTfp9RWYBjAX0qtjgG8QL8ltmzi59k38KnpgCrCKLOo921FAdqZZO9QzByxe2H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_05,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605220197
X-Proofpoint-ORIG-GUID: lgSHWNuOPodHUMuCoRwZ8sGVHNh7NAI3
X-Authority-Analysis: v=2.4 cv=aoKCzyZV c=1 sm=1 tr=0 ts=6a10b2f8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=edf1wS77AAAA:8
 a=dZbOZ2KzAAAA:8 a=hSkVLCK3AAAA:8 a=AiHppB-aAAAA:8 a=VwQbUJbxAAAA:8
 a=pQkuGY2LVspxzYj3u7cA:9 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13835
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDE5NiBTYWx0ZWRfX6Oj2fO1DS5fx
 sTh+S0O1+kYRnBeFizk1CAWvcjqMOeNvkOuDpUzRpDf5WoFrAP+0WPd4J75VrYn4nuGmbL3UziR
 N3hzdxrYy+HDSXaBEj1RihBlGN+If+YwhP8Ho7V9CH7y3SkhV1RTVhxi9T3ToNcIH9UeEfVtxeu
 7Z8zXExk3FkLzGDDD7vDVzjKeGym4Q5kDwBIe02BwiZh8ckHVGR0UA/nxhGnlctAXe5CGgAdtsa
 u3UWryiy/s3bM3RC9samAldIPswbR25t4lGsa73OIQH9rPwxjOcD1+Im3rDglTevseergnotTtO
 GRCBkRPTF3Df0c6yDzox/7on9P18ITCFSBLOf7y3oBE/SaC+1rp0rIFF1JO2Nvj+0vTR5ZdZv5R
 622DpOaDyZrU4Butr+5wTqAbAajy4vxBj+yWeEjiSY6DYyBmeFz/W2vaGwkqcB/VFbKjgOXMbpZ
 eaIikOL138M5fts+TxdaGtudqGZdSwlTX+IpWP9I=
X-Proofpoint-GUID: lgSHWNuOPodHUMuCoRwZ8sGVHNh7NAI3

Hi Greg/Sasha,

On 20/05/26 21:51, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Edward Adam Davis <eadavis@qq.com>
> 
> [ Upstream commit a5b98009f16d8a5fb4a8ff9a193f5735515c38fa ]
> 
> A potential race condition exists between pressure write and cgroup file
> release regarding the priv member of struct kernfs_open_file, which
> triggers the uaf reported in [1].
> 
> Consider the following scenario involving execution on two separate CPUs:
> 
>     CPU0					CPU1
>     ====					====
> 					vfs_rmdir()
> 					kernfs_iop_rmdir()
> 					cgroup_rmdir()
> 					cgroup_kn_lock_live()
> 					cgroup_destroy_locked()
> 					cgroup_addrm_files()
> 					cgroup_rm_file()
> 					kernfs_remove_by_name()
> 					kernfs_remove_by_name_ns()
>   vfs_write()				__kernfs_remove()
>   new_sync_write()			kernfs_drain()
>   kernfs_fop_write_iter()		kernfs_drain_open_files()
>   cgroup_file_write()			kernfs_release_file()
>   pressure_write()			cgroup_file_release()
>   ctx = of->priv;
> 					kfree(ctx);
>   					of->priv = NULL;
> 					cgroup_kn_unlock()
>   cgroup_kn_lock_live()
>   cgroup_get(cgrp)
>   cgroup_kn_unlock()
>   if (ctx->psi.trigger)  // here, trigger uaf for ctx, that is of->priv
> 
> The cgroup_rmdir() is protected by the cgroup_mutex, it also safeguards
> the memory deallocation of of->priv performed within cgroup_file_release().
> However, the operations involving of->priv executed within pressure_write()
> are not entirely covered by the protection of cgroup_mutex. Consequently,
> if the code in pressure_write(), specifically the section handling the
> ctx variable executes after cgroup_file_release() has completed, a uaf
> vulnerability involving of->priv is triggered.
> 
> Therefore, the issue can be resolved by extending the scope of the
> cgroup_mutex lock within pressure_write() to encompass all code paths
> involving of->priv, thereby properly synchronizing the race condition
> occurring between cgroup_file_release() and pressure_write().
> 
> And, if an live kn lock can be successfully acquired while executing
> the pressure write operation, it indicates that the cgroup deletion
> process has not yet reached its final stage; consequently, the priv
> pointer within open_file cannot be NULL. Therefore, the operation to
> retrieve the ctx value must be moved to a point *after* the live kn
> lock has been successfully acquired.
> 
> In another situation, specifically after entering cgroup_kn_lock_live()
> but before acquiring cgroup_mutex, there exists a different class of
> race condition:
> 
> CPU0: write memory.pressure               CPU1: write cgroup.pressure=0
> ===========================		  =============================
> 
> kernfs_fop_write_iter()
>   kernfs_get_active_of(of)
>   pressure_write()
>     cgroup_kn_lock_live(memory.pressure)
>       cgroup_tryget(cgrp)
>       kernfs_break_active_protection(kn)
>       ... blocks on cgroup_mutex
> 
>                                       	  cgroup_pressure_write()
>                                       	  cgroup_kn_lock_live(cgroup.pressure)
>                                       	  cgroup_file_show(memory.pressure, false)
>                                       	    kernfs_show(false)
>                                       	      kernfs_drain_open_files()
>                                       	        cgroup_file_release(of)
>                                       	          kfree(ctx)
>                                       	            of->priv = NULL
>                                       	  cgroup_kn_unlock()
> 
>     ... acquires cgroup_mutex
>     ctx = of->priv;        // may now be NULL
>     if (ctx->psi.trigger)  // NULL dereference
> 
> Consequently, there is a possibility that of->priv is NULL, the pressure
> write needs to check for this.
> 
> Now that the scope of the cgroup_mutex has been expanded, the original
> explicit cgroup_get/put operations are no longer necessary, this is
> because acquiring/releasing the live kn lock inherently executes a
> cgroup get/put operation.
> 
> [1]
> BUG: KASAN: slab-use-after-free in pressure_write+0xa4/0x210 kernel/cgroup/cgroup.c:4011
> Call Trace:
>   pressure_write+0xa4/0x210 kernel/cgroup/cgroup.c:4011
>   cgroup_file_write+0x36f/0x790 kernel/cgroup/cgroup.c:4311
>   kernfs_fop_write_iter+0x3b0/0x540 fs/kernfs/file.c:352
> 
> Allocated by task 9352:
>   cgroup_file_open+0x90/0x3a0 kernel/cgroup/cgroup.c:4256
>   kernfs_fop_open+0x9eb/0xcb0 fs/kernfs/file.c:724
>   do_dentry_open+0x83d/0x13e0 fs/open.c:949
> 
> Freed by task 9353:
>   cgroup_file_release+0xd6/0x100 kernel/cgroup/cgroup.c:4283
>   kernfs_release_file fs/kernfs/file.c:764 [inline]
>   kernfs_drain_open_files+0x392/0x720 fs/kernfs/file.c:834
>   kernfs_drain+0x470/0x600 fs/kernfs/dir.c:525
> 
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Reported-by: syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=33e571025d88efd1312c
> Tested-by: syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/cgroup/cgroup.c | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 046f671532b04..0914a1a189ee1 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3876,33 +3876,41 @@ static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
>   static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
>   			      size_t nbytes, enum psi_res res)
>   {
> -	struct cgroup_file_ctx *ctx = of->priv;
> +	struct cgroup_file_ctx *ctx;
>   	struct psi_trigger *new;
>   	struct cgroup *cgrp;
>   	struct psi_group *psi;
> +	ssize_t ret = 0;
>   
>   	cgrp = cgroup_kn_lock_live(of->kn, false);
>   	if (!cgrp)
>   		return -ENODEV;
>   
> -	cgroup_get(cgrp);
> -	cgroup_kn_unlock(of->kn);
> +	ctx = of->priv;
> +	if (!ctx) {
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
>   

I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:

Upstream has:

static void cgroup_file_release(struct kernfs_open_file *of)
{
         struct cftype *cft = of_cft(of);
         struct cgroup_file_ctx *ctx = of->priv;

         if (cft->release)
                 cft->release(of);
         put_cgroup_ns(ctx->ns);
         kfree(ctx);
         of->priv = NULL;
}



On 6.12.y:

static void cgroup_file_release(struct kernfs_open_file *of)
{
         struct cftype *cft = of_cft(of);
         struct cgroup_file_ctx *ctx = of->priv;

         if (cft->release)
                 cft->release(of);
         put_cgroup_ns(ctx->ns);
         kfree(ctx);
}

On 6.12.y, cgroup_file_release() frees ctx but does not clear of->priv. 
The posted backport adds
	ctx = of->priv;
	if (!ctx)

in pressure_write(), but that only works if release turns of->priv into 
NULL. In the pressure_write() vs cgroup_pressure_write() race from the 
commit message, 6.12.y still leaves a dangling pointer there, so this 
backport alone is incomplete and can still hit UAF.

So upstream has commit: 94a4acfec146 ("cgroup/psi: Set of->priv to NULL 
upon file release") which might be needed here as well, without that I 
would suggest a drop.


Thanks,
Harshit

