Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FADE211C
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 07:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741676700; cv=fail; b=uxEkSMXwlG/6T27FCKrQHUDx9J/w5W8p7kdVnX+FlLV9wJdpJrNgAsX+Z4f0bw6OALKK36FeuGQtJv3SIziDt+gLn3CPaZs4OkaMzNI9+WpnV89+1ULiqQwHBnoikwmsjptsXIzDrMCWbIk3DUnh62wrI4h1iX4lM4mtEvccP0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741676700; c=relaxed/simple;
	bh=8MiKfjZ0NgaUAOxWUHol+39ZAN02wj0HeWf5zxBRKpM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WSJUjTtXYaHl3f9nrZMBt4JcaWccOLhKorUBmnjyoQax1SZXIoUo9fgPmJS8Knq3fms6YObKwbc6PBUfK3HySJN6h8/h5XPcZ1HhQw9iOnS2lmxpLTeybbQ/0RpSaaKyYdob/R+TikwEle3SyfDLSkXdrjTq+O+OlFBNcfXfS1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LP/ZoZUE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lOTzSDZg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LP/ZoZUE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lOTzSDZg"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B1ftZh026609;
	Tue, 11 Mar 2025 07:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OnAEFp3wCHEqhKBXQ4PT315ba1xhaJ0KcwUK6RCpUgw=; b=
	LP/ZoZUE8VeCHSmxSC3exAhi77TZ4d/Zj01NU1iMQ7vfci7LyBqJcgboeETxmrko
	NItbUldTx594SnDtn9WWlYIR6yE4PkYwMRePFwCvjEWWduhblIN4xxrYuSxwXys5
	JrKagd1pfyhrIdbLeE7L9TXBMvP2LDbDY/i+4xlm1HvbRBe+ftZBOjFwx1uSSwby
	+LwZ+FHKaJLWNyAF2rcf0Mblo4FJtg9OpoCXyTJ+5pPuNDPKhvrqTxoM018dXcQ7
	c7cOiSQNJdcpF5Q998yYOGumMCaXNaI+Km1XIDGOjnSWE7iOc5LL1Hd/KTgiQXFI
	/KBmS9+zkaQ+9Jtwe3snnA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458ds9m5hy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 07:04:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B6oIZu017076;
	Tue, 11 Mar 2025 07:04:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbewr7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 07:04:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rP4iSZO+UT4CxrX05HaD+MkJoZ1GsSP+GYdrheQdRlxnPqG7oDXqG+zyhz6S+o4QoeFZ9zFyxbJrQjLX7off3BRBaRzJkcDG2TJT8LXY8h4DB0NTZOpSpOdZ0Fi5uEJuG/VHOOmQqLUHrOORpco3AcFEtjGHpFuLbA5Sx2YtCU1fqNaNt1o5NCPkjSdSLtnc7y7t7QwqaB8XOVbS20L4+hg6OY0p3JNrnLUw7W2SoOlSV8vM1UakcVw0YO81C79DuXB/VSlQDYz9tFK3Srx4y5TPSq4dgHF27/Y36JZCn1DiWO2F6SW3203WKR5LgqyF477cxqjIyEPCYw90G7u2XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnAEFp3wCHEqhKBXQ4PT315ba1xhaJ0KcwUK6RCpUgw=;
 b=QaX0N6yw0M64SPAqvsH1QcZd9VOVJH6HfI5eIUX7eiprcpJc/3/kqmdG/BD3WegJpqBdcq1yUdIf3f/FQfPCePfBxuuxrAEFDyVCyTw7DLxz3yLuJ2CiaAIoy0AaLifRfY9h8Gjw0Nb9n6aPLAcfR1yTFCku8ZIod5kBh1eS/A19qNHcRPuRiuqJjcg3bUt/7sa2oidBK8yBjEIUWxtUZYC9m//blt4nKbuM8a5mNno3v95k0qs4W9oHZyWENTGF+BANYtIkuujLFk2+3uwDiFRSWYCAt9TgUjChBPvfJ2lFq4nnfod1lEQJHHnu2LwCPCYsTkLtnDIoPGuTKTHBrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnAEFp3wCHEqhKBXQ4PT315ba1xhaJ0KcwUK6RCpUgw=;
 b=lOTzSDZgyfI5pISz0/LzDvj+SuRWLze1QcXWmDTtbLUoyjUJhuPFxk/u1c1hs6bLTvghScx3iriAI3iguX0kqJgscZ+iJFLONwyuA1GijpomIcbYlknsjOVoJNBjJqM/7j7iAiAXn4xIgHQl+f8Z/o6/7xdxogdKiy6MEec8BOc=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Tue, 11 Mar
 2025 07:04:28 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 07:04:28 +0000
Message-ID: <a406eb88-2290-476f-a721-94fde419ed8a@oracle.com>
Date: Tue, 11 Mar 2025 12:34:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/145] 6.6.83-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250310170434.733307314@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MN2PR10MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: 194003cc-60f3-4a23-08e4-08dd606af69b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjVSK21uYTZaUFk2WVJkWkloZStTUVBnWlJ4YytnM0x4d0hTM2VFa2xZdmda?=
 =?utf-8?B?blpiNVBWUTdmMGdZdnZSNDdiNnZINi84bnlYbmIrTEp3NHBFU2IyMjNsK2F5?=
 =?utf-8?B?cmJ0ZWtjd1FzSHh2dWY5bWl5K3pNdDJlSzFNZVZWYW9nVTB2NEY3KzBuKzVL?=
 =?utf-8?B?NU1oMVlVN2R5VmFOK0hHNU10aGtTSEZvaVJVRnl1cC9lcThtL0t1Z1g5cDVy?=
 =?utf-8?B?Zm9oV0xTcGU1YU5KenFzTk42T0dBVUlDS1VMV1VLekFuNkFGRlpNVG1VK2tx?=
 =?utf-8?B?azlpcnUyWDMwbkM1bU5Fb2ptK05zQ3dLaVA0YjJ1dGhGTkM3ZzYwQnkzTWdn?=
 =?utf-8?B?UmRjTlNTRXhRV2FEY3AyUXQvNXZadzZpNkl3S2xDY2g2SFcyRXF3Si9rQjdZ?=
 =?utf-8?B?SEtTQW9LOUI3RGpCelhSRG94NWtZck1XRFRoWDRSaHJEUkhuTDE3alFteThS?=
 =?utf-8?B?VHZGVUhlMEtYOC9oNU5tckJBSytSRlJ2QTlJZVdvNUl4RG5icWVkNlQ0K3RR?=
 =?utf-8?B?NHNNdXdzdXNjQ005SkNLaWZQdit0VDRreEx6K3lOY0hTQWZPTWUxZWFmRUdT?=
 =?utf-8?B?Wk5mNWdSclM1cTNKMWJUSTZUU0t3WlQvN3I3Wng2bkZpbmFxVHFHYVlUZk52?=
 =?utf-8?B?Ym1FNE4zemVSaTZNcHZ6cTFBb0x6OFFjc2IvandLUFVhSnNnREtsNUxVWnB1?=
 =?utf-8?B?NzVVUmxrUFVWUk94K0FmRUR1MTFGcDJhNVJCKzBQYXhpL2QrdUFRNTBNV1dh?=
 =?utf-8?B?emV5T2lSSm5MS1lQUU5iYVp3SW9ncTJDbjY1WU5Ja2JxWm96MzRTZHk4R1gw?=
 =?utf-8?B?K3RVRUVyK09zK3lDWitNb29hSnhXNTZlc2FnV25JaVNWSVk5R3QyZG5DRGxj?=
 =?utf-8?B?d095RjZwcXRVVzJ5QlpKZGNRUXhKUkY0bjE5MEh3UktLT1h4aGZaMCtjMHcr?=
 =?utf-8?B?elMwM2RyL0xYZ1pNNU1JNlB0SnpaR2J1U1ROekM5U2h3alNpN1ozSXRhVGlM?=
 =?utf-8?B?UTlDWjBJUjBJNnZQeU03SmtRU09JeGVISTlzS3BDRnNETmhjc2NxaHgxL1dJ?=
 =?utf-8?B?RU1OdWptV0FtZndmSDgzdUNNS3M0M0VhWE1YWWdpWGJyeXBSOHJ4UjBsa3hp?=
 =?utf-8?B?RFYwTDg5bDYxbFFDVlpUKzFWRXIxV2I4RUQvdDZvVXJkM3F1NGNUcHFZQkEv?=
 =?utf-8?B?aElNckZVdzBUa0xwZ3pzbjIvOGNmMHFRQ1doZmsvSFBybkJBVzBsaGxsaDlR?=
 =?utf-8?B?dytDS1c0MCtMQXpQNlZtV3RwaFVvdDRDMWw0SXV3TGUwNHVHRk5Cc0E0Ny9K?=
 =?utf-8?B?QUlNUkJQbzhxL1lIeFQ2dC8rejZhbU1HR3kwUnBQcFMxejRuVVZVZ2E4cTJn?=
 =?utf-8?B?cG92WXI1SkNUdVV2Wjl5Y0I5d21ubFBlcDRwcTlXaHZHQVZxMmZpcktva1hz?=
 =?utf-8?B?cnU3eE0yOFFtOGJVdHhNS3VWcHNJUng1SW8vZTBGWFNNcVNuZVIzNlRPMWhO?=
 =?utf-8?B?SXU5THBFY0hOU1VnbmxvaE9HZE53REZXRzR0U242S2ZzMDFYeHBNZU9RR0Fn?=
 =?utf-8?B?bHA1SWFJN2FJS1FDaUVCS3JZbXNDTzE3SFZ4YmppbEIyZXlhTWM0VnUxOHlW?=
 =?utf-8?B?T1psNERRL3Q5bEUyNkdyRzFxV2ZOaHRDS2V4NkxyV3ZFaDM5ZUkvSzVjc215?=
 =?utf-8?B?ajdWaTFJL3hRYVJITk9wVWN4UGxRMXpiLzErT1NjcW9CY0ZIWXJRT2Q5ZDBL?=
 =?utf-8?B?Yzk3eDBsTkJFNE5vcEJNL05mVWtoWDJMRE5HY3VQZTJLRXFHTUlCbi9DOEN4?=
 =?utf-8?B?cWxjQ1RIQklnNjF5cVc1UEc3T2tqcm9tbFE3dUhLNmNHRUE1cE5zY0svbzBF?=
 =?utf-8?Q?pDKnDae5tp9XP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zjd4eTE4WklOMWNXdzJCSW1neDgyUG9jZnRSNlB6QmpyaVZxZ211cGJpbzNj?=
 =?utf-8?B?cjhVYXJnOTdibXo2Szl1aFBDTTJ3eTBaMGpja08yaVlrQ3Y0QmwyU3lCVDVz?=
 =?utf-8?B?Y3pxSHBmWG90ZXFHMjNWa28zTEIyRE5CWDdudjJXdjg0VWYwN2pTNU5UZmh3?=
 =?utf-8?B?NCtJZlNJTFFpUWlXWW81S2syUGVLYnZ5Zlk0eFJzQmRIa3VySEFwdDBNeG1z?=
 =?utf-8?B?b202eUg5TStoNEJSRkdPQzF4aU85Ynp6blh1UDltTmdtbGVxRXFjR0NRSWg0?=
 =?utf-8?B?SUplNzhYNS9FdlgxQXpucDRhV09HbnArVVNkcGMvZzd3bzBLQzJXYzlZVVYr?=
 =?utf-8?B?KzNuTUtIc2tVOG5SYjdJbXZaZjJPQUlFd1RjeGdqSUlGSS90NVVXYkp5dlY5?=
 =?utf-8?B?VXhTbnNXSU8xY1oxdnNyWnVTOEVVMUpwY0JlK2RSc3FsZSs2eEJoNnJNZ2FU?=
 =?utf-8?B?dUQxMk9ROCtwTE5VdlZGdVpCRm1TWjBLVTlYK0tvalhqSUd4MUIrOTBxRm1C?=
 =?utf-8?B?clRTeTRzSDRzQTVKYzBLUHE3QXlrR2RYZHhFQ25ML2srTXQxNitDaFhxd0JR?=
 =?utf-8?B?c1hNVFVvSmtoeFVXQ2lvWkhsK2k3WGJsVGlUUEJBdG5oVWUwaktvUTJxU2VV?=
 =?utf-8?B?aGppRGdJNElrd2NTY29Pbis4MjNUOWVxRG1MNnAycTN1Vkh4aDJBRjhlSm5z?=
 =?utf-8?B?bEpoeHlKSjRDak1BYjFXVVdleU1INnlkOWRObXhnMjZJMnBjbDRqU1BLeE1W?=
 =?utf-8?B?d2VkK3RhemcyY25nVEcwSCs1MHg2OFpwSUl1bHc0Tkdray9UeEtkZ2t3MkFK?=
 =?utf-8?B?QlRGWGJqcHgydExSemw0cFVPY0o5UnpuaVBvbVJkTkt4QW1HcXROSGh6S0xT?=
 =?utf-8?B?ajZKSnBLakJiMUx1MzE2ckJXcFNqcjAxUnVsU0NRWWRkSEZyVWpiTHRUZ2tz?=
 =?utf-8?B?OCt2L3Nldzlmb0FZOGRtR1hHNEFKVmJ4Z25Dd0l1OWdYSGdtLzQwRVBtKzkw?=
 =?utf-8?B?alZLZHNFS1h5ZlFXSElCNFE4SDZFMHRHc3pDRUhzV3hGQUNYazd2cldjUXIy?=
 =?utf-8?B?bGNBRGFyN1BCTzFjNUhrQ28wM3VkcEZjMmZ0MDlnQmVQekFWdXo1V0dvaDVj?=
 =?utf-8?B?QzBuOUlmRW9PZThSMTRVcUM0UkhEU0lKN0pVdzgzT215Sjc1UGtqam82K3d2?=
 =?utf-8?B?Q2g0U05LT1htRUF0WFFqT01KaTRSOVNMQXk1WEUxNCtNSXJyb05kVngwbGJ6?=
 =?utf-8?B?YlJqR2dZUWpVWFd4a2ZvOXljdlo3NHlBWDE1NnhaQmNaTHZNbldndSt1SnBJ?=
 =?utf-8?B?c09lUWhTVThWWWtaTFVPVGxsYlZjVERoZVYwQ1ZwOVMzQnM2NDdoOHNFVk9V?=
 =?utf-8?B?ZHMwVWw3QzVOZzZwWTJMZHdlZ3VKcEN1RVNxVVd0TE5IMlZXNnpyWXRjM213?=
 =?utf-8?B?QmZCVGFUYUkrTDNJRVliYm5sT1V5cXk2bEF4WkdtMEg2ellBaVVTcFJyU2Fm?=
 =?utf-8?B?K1ZJdDRCaGlNVnpLOVFoRnFaZWlsOE82OTVGcG1rUkpuRFY3aWtTeUtMcWFB?=
 =?utf-8?B?SUx4L2JRclU0cnRtTG1FcEJCK2xKMVNzR3RxWXE5Y1FIUUplTmJTdWw0T0ZW?=
 =?utf-8?B?N3JXaFZxZ244dVNsb1VGZ2FZTThJcVhhSTNuMnFpNEZodUdwKzFFNE9pK2o3?=
 =?utf-8?B?b043bVdWemFYNnNESHdPbm1zUHhXTm0rczIyZXF0YmQ0ZnlWYm1SOFBSOFpy?=
 =?utf-8?B?RWw0UTNqZ21VcGJLSTVvb2tvVVR3MnJkYVFGNVJueFlLZU9UNnNWV2kwVkNh?=
 =?utf-8?B?QktsdUZCU29CUGRtSEErTWJPcmNUZXBDSS8xYjJQajhPLzM2K1JCREIyaG1F?=
 =?utf-8?B?N05Ca0VSallhM3JsbHYzaHZScEdyUGEyWEIwbzNQRzRWSHJIVkdibkI2V2RQ?=
 =?utf-8?B?WFRpUjltZGl1L3JwNlJUZGY2OWNKa25TRnlOd1hEUTBMcGhCK3kvUzVvN2lv?=
 =?utf-8?B?WU12anZ0L20rZmk1TlZCd1hjOU1QSFUwSU10NFBDM25NM3ZJY2Z6R0hUNU11?=
 =?utf-8?B?VWcrUU5OSFUrSG9WaXp2eGN0VTJMUzRyUTJPUlJzZGh1NkxKL2kwMDhOQ2Zt?=
 =?utf-8?B?VDk3N1BKMXpONDRDWEoyUkt3dDNZSzF4QTFzbGRNRUh1RlozZGNLQUQ4eEZy?=
 =?utf-8?Q?hGBrMEX+AjwcA6oYr34+WaQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZhNHcHK61KjRMOJpJZSRnT8mA3KG/8HTKOanLscMmxT3C/rAby8NhQ9HykZfQd9gm0qDWd/O0kaIpqfrnrY6/QYnOYM0c9qUQBESKm42SLIhdP3g3zsUac7+ziYF16n36F3CsKpyLhVmEz7FlVDUn4a9yDHzi0g54HlbNQVAqMKXWrjXp/esQ0V0Dl4Scf0A8MrPf6poE+4JpoO8jo5xxtP10LOfQEWkpF1xnvrDuVlfMCMvF/ssmk4ledL8X8drAR4FfFWw6AELqCmtP5HjFLo6KgCGiktuTiNfm7Q2JK2dTptxecYkn+L8xOuk8PwxemVQIWrAeBwaDmsR2vp4hspI/C4q5gMYP0TphC46RsFV+HElxTzuwDz7sAXGV+5o7l6diWP/s/FgX4v79Fdy+dbpy/1uvDs75PCCTjqVfbBWVI4f55N328Ud3yqa0kKFhHcbmt6l9doxGfEWfrzDyQd9RgFyybp9tqePtXLAjksYlIgu0DioxP3/BVokTGMKNypKmw2jC0B42iBNxQvuExtW26+pyTP5hY6UBDp/Lh2Epi429ktjCflAUZ2CbswNW/QqS95RXaDBGVGpsWiWMKDzHQVTV8sQm1a62WGv+CY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 194003cc-60f3-4a23-08e4-08dd606af69b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 07:04:28.0231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjBweCke67bCJkPGPtgrwSi0YO5+5qRBzCvvZ0UFn2LhSfxxplvXSqXu5pG5cvSJnzORsHwjugibLk73ZGmGKoIEQPX8ohj69kW9mZ04tSgL/3YMj4SqCXPBnkpaakSE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110046
X-Proofpoint-GUID: yQSX1tBrI_IagozmLokoRU8rDZtesAkL
X-Proofpoint-ORIG-GUID: yQSX1tBrI_IagozmLokoRU8rDZtesAkL

Hi Greg,

On 10/03/25 22:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
