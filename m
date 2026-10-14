Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36071EB1AA
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014954; cv=fail; b=VHZZc8COkw1xpF0esteMX0D8vbO2tcruyRPRzJWQCuocgQ1FRyqYMtF5+O0vlddcHCfmJQWcgor0VA82rSy6L+mZKwQWWH+F3me1tagJH+uSOH/RXgGrbDHCc/Zwux3hC4rNUKflgD7t2ipV3B8QKav1ownqIf29QDBtvaNKF54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014954; c=relaxed/simple;
	bh=zKEsQZi/bA9S/EgRUVEHUmzmAEL0QD1k7CSRNeN1/p8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Otq/+hHaTNIHSbqKMT13JRe2vWShw4EF8ZuNYL8OEZgUn3NnleZx3BM32eGL9AqC+M/csPgcXRco5lJJJO0xzOXR2X9s1hR2ffMiYafzbqJ7JZ8IQ4lPALkLwwaN4VbhLCeH8oZq+OS5iWcfqg38WTc82rCuWcmFCi6dptpsW/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pnxwWhj6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cRo+ayJw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pnxwWhj6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cRo+ayJw"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ELgSJu3438790;
	Wed, 14 Oct 2026 21:55:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pj/5Kc/+MspZfTrrPokKHkcEES5LqU7Q9JgZj6gXOjk=; b=
	pnxwWhj64/pcpoOIOZytHSw2OO3IG3O+ry9Ne6jCMTmXhwp3TQKyHSyy9mRhHHDk
	G0boyTew3twp99Z4QsmLuLV8WyKTqm92Laky1Y4H416PIifXrabVHZFkDqbeGLut
	qj44CPmPhZqbMynNBazQff5Hqrcs6De3leuw/a+8w6Z8VOD2Hwb0Xwk8/y5lO6qC
	O3tO8IRgYFisnA5NeZteGtJcge3bk1CmO8XY6zOgAq+LfFp05JvJZjaonIQP3V4O
	6Pr741Zn8KxSxGtpOYJrHAc1evn2li/1/oQAwRYJJNSavlaGTMDd9BRgDVWuaxR6
	ee7kW/xiZchFwByaKWOX7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demq2wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:55:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69ELpAkb029421;
	Wed, 14 Oct 2026 21:55:47 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btb6rep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:55:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K1NF1Vk9ey6BEd2jWUtDJeEE4bgBJEUTDrdavv9DdWQIbUVjK78HY8/8dqLNg24o6kFviqN/NdXRQ7qIVbZn4btj6om1tS/HPRKdxSCBCTXg8g6kOod/6Flnbu8Q+J8Q6Uf5qb81mLkttcwXD5lZh1HI1+O689X22g4Mw+xZoyQPBR2O6FzdDzI+SVl25eebzlXfbgbNDdczjZiCbcfg/pIIXtj4vi0e/fBdkV3LGftDpi4xt8fWdXCLizdRfmyF/KV14shDPSfNAikAPAsvS9bZuPHjrvDlbPlI0C4HmIW/6NzTtMo7g/5vbDL7vD5XW+aHfW6+CX6VpP+M9+wviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pj/5Kc/+MspZfTrrPokKHkcEES5LqU7Q9JgZj6gXOjk=;
 b=CSduxbKOvf2gFxgG1XIaNEZFsZ/Uu4OpE2Z4LOkOpKh1K5EEs5zCMlr6i+WWuh37k/YU9TIyZxMjxRYYwhN7RcOzT2qNEqlTatwm+GML1CtzQZixQePP0LgLyUT0wXgcdfPG+DI1f3EWk56sv6+/93HN/tF0sG/r7IUuz8PdJFTx+FP8jV1LIlJdTgNnERALPd3aAYQSmtx9ymuuJClg3rAK/gnoaZLr2pyhgO9uPMewJsegkj6NShXHSnnfb8GcN13k5tmWwiW8CYCQ/nkRS8J5poYQdORNHyZ1C1QdDDhhIY7cZDigqaqrlizgalq74hDCdRJ4te6clnlfStihqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pj/5Kc/+MspZfTrrPokKHkcEES5LqU7Q9JgZj6gXOjk=;
 b=cRo+ayJwi2Dq1IZaf9JyQPTK5TcQi7dueB1F3HcjPFp0FuvedRzVojpLMrEcQzhQpgzqU2/zzOmrxrKAI+Fnxgu5C5ruIF1THAZrCauJlagbVWQGiTt1pw0uugr6KuBdZqpKQhu7r8uWaKL+8JRv8kRfYaAwH/oS5DiV99qT9rM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by FT1PR10MB400295.namprd10.prod.outlook.com (2603:10b6:170:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 14 Oct
 2026 21:55:43 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:55:43 +0000
Message-ID: <abc30e0a-23b4-4955-a788-27ea7dfe8ec7@oracle.com>
Date: Thu, 15 Oct 2026 03:25:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 475/497] cgroup/cpuset: Call is_in_v2_mode() after
 acquiring cpuset_mutex in cpuset_handle_hotplug()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112919.152664273@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112919.152664273@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0199.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::19) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|FT1PR10MB400295:EE_
X-MS-Office365-Filtering-Correlation-Id: 6089fbcf-bf3c-45d8-17ed-08df2a3de4f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|4143699003|56012099006|5023799004|10067099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Y7yjRPB0jO0/u8NFKDLzoKJ1kE6vAXrO6EWOJEDMMuFQNzwBV+t6l3DRgnsmKycKK7QcBdqbZ7xlmOH7rmqY6qxCddf7AqtZ2RVjrRZY/Naa7I+OoBfxty1mqFQooYMX2qsjYM3PGwEuKEqeu/KTFgcHj47TKmD24hyPs8u6Rm/mq9TuWNXRoW3ftx4FsqZI+66DvpzqIzlfqBTVLjVL4Z3bfhnB0UlNccY3Q5WvYjmPApHHcrfNZrZvgyRukMjxUdyfeIZG1sb16hazy+MrD7Asqfa6bUAI6jzLiBlQYLC2owJpX7YJhXJdvVOmdcLfV/zZcRfAa50vYrG4Vwg14W4kydRmbGS5l1JaI5Bs14msKiZY6AZ71ekLCi2dTDjfXtQlc1gGlSHmdjczauGS2Vj+RC7wpQL9sg4qgIYXhpf5j6q1bXashePTbsMn19EhU9pGco3bcxjLhqXcEEErg77mekdJzpJNIzbdippv9NcDbxXyX1NVBvnofX8BOBtZbP6FxFLGjNyjEn305X5C9J+QoMvTaHjN1CHYo3ll4fqc6AylY8QYsx3knZOUV/cwzzF7SpoxJFiIP1onoim0CRGYIU3HqWi/TYoYKuvWhKa78tn7CNfCKtHA6GBLZL+SOgPMcC68lGU/ZVOKqssK0bRhJeXyWrmHNPL2IC4DMIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(4143699003)(56012099006)(5023799004)(10067099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVB4bTIxS0UrL1U3eEk2amhRTnJCeXJNSXJ5bVhYbytrcXJ4WFY2cWg5K2tF?=
 =?utf-8?B?cXA1OFRTWHI5Y1NHR2k5MEZwbUhHYmhVSFN2Z2Z1b3hwNWxWald6Z1ZNQ1Jp?=
 =?utf-8?B?WS9uUjExZGlwKzF4Z2xSdUZHdmJsVnA4WXhSZVlGSkNVR1ZKalVMNi9XQ1pp?=
 =?utf-8?B?TitMNEdWL0JGc1RyNzE2ZWZWTHllUzhnVHZodXdSazg0Z3E2ZGx5S3NyV0F3?=
 =?utf-8?B?NGl0Rk1IdlpXWEVON2NGZ243WFBUUS96UHdoMG5pQXlKTmZGYXI1OGFGR0JN?=
 =?utf-8?B?bFFlRTVCQThic3M0UmxTWWhkYXRZQURoa1AvbDRSUU5BSmpYcmppcWYySCtx?=
 =?utf-8?B?S3FFZkxodkJrcDNGQTNwQVZTelE3SHNqeko2RUxjMVdKNmFoVFZUN3lNd0pz?=
 =?utf-8?B?MzRmL1c0OEx3NUhDUlA4RWhvVWNtbHhpS3craTNNZU1ZQzNmSmZ0b1lqUXBD?=
 =?utf-8?B?UGIreUlMYUZvQUl1ZmVhNEhPZWwwNy9sZENZL0NqMUxrcXpjcHV1OExkbCsr?=
 =?utf-8?B?M0M4YkpmMDBraWsyc3lzcjVhem0zbi8wYUtnZ1E5OGZlMVY3VlE5empIbzM1?=
 =?utf-8?B?clMwc1hxZ3JjczMyMHhwVzhzU3I4NjczdUtibk9GZEFxMllvdmZXcjlJVU9n?=
 =?utf-8?B?Y3A5U0xvNHRzZmU2R2ZEbTdreFdZZTZwc1BHbnB4ckNtcTZSdm5PZU0waU03?=
 =?utf-8?B?OXlwZWYyTUY0OUVuSS91MzBVY1lHQmtPdzlmR1dRNC9zWkR2N0lDUFpEd0J5?=
 =?utf-8?B?a2FobWRCT0FwNG9qMmxLQzFnZGlGc1B4WENsdFNHYnMxdVMrSFVXQk1WZVhj?=
 =?utf-8?B?bUZzbm11eVZhWU5sLzJKQWg5eGtXejdZRytuYUd3bklrZGxVaU4zL2ppZmlx?=
 =?utf-8?B?RHVMd0RrNllqcmFFYy9NK0g4TjU0RFI0T0dVV01zRFplZ3VXQzA1elF0T1gx?=
 =?utf-8?B?Y3JjallKRThDaWVPbm50UzdiU01vQm9PZVF5OFBBbkd1VEExWTBlejFMWHkv?=
 =?utf-8?B?QlpTdE5KU21UWVA1QjdVZko0YXZ2UkkxNXovNjVNWFFWcElYSkpBUE1QRWFM?=
 =?utf-8?B?N1I5SkJjNEI4ZmxoUmliS3E1NWg4bEdBQjFNUC9PQ1BFaGNYZmFiVVNVc2o5?=
 =?utf-8?B?d0Z6dDRUZFhkM3hUV21zOUswd2U2dytWRmNxSzdjbWlSUGlKSGxmRnZUenFU?=
 =?utf-8?B?UXBVSXhpQTlsV3dNb2REYkRiSWJJS1FBV2VtcDZ3R2lBTFRuSWJlNU53d0ha?=
 =?utf-8?B?anB2L0xDc0g5ZmFoZDloZFloWjJVdE5xQ1NLcmcvSVV3R2d4YUY3MjNISkRO?=
 =?utf-8?B?ZFloQ3dsNk9ZRGkrT2dLNHBhSTg0TTJxaDF2ZG0vOWM2eGlGWnFMMFp1TWQx?=
 =?utf-8?B?YndJbFhYOWswSmRURjdSR1dEc2Z1bjNrcmN4NUQ1c2prK3lqQ09sOVVXeVZw?=
 =?utf-8?B?WGhNNngyamNkb3RaODcxbk5qVkRtTk5QZzJWQkMxc2xUWUE5UmVtNHN0WGlo?=
 =?utf-8?B?V1dTWlcyZm5qVUF4YWFkRmRqMGRWTVJ3SXFyRko0MmpyMDcwSVhyRE4vdW5L?=
 =?utf-8?B?QjN3L1JwcVVzbmdiT01nUUx3WWlyRTlKRmRZYU9EUTJIc2xtRmJmVzhjT2s2?=
 =?utf-8?B?QTBzcmgxRWNFdUNGWlFIZkl4SzRrckJIME8wRDkrK0p5MG5NdVplK2pPYndQ?=
 =?utf-8?B?d3cxMXRDWUMvYXdZMVR1WFpBaGM3b3ZaS3doM1pXaWF6VUd2VGdTSS9sNEU1?=
 =?utf-8?B?U3dUQzQ5WXBFYm9EQjd5VW5QNmRVcmw4eE00cnhhWGdhVHJYUWNaVEk3M3V2?=
 =?utf-8?B?ZURyVU0xdXNIc0llRHpVL0lvU3RFUXYrM0tWUFNnTjdVazExUU5mUkkxaGRr?=
 =?utf-8?B?UkdYOTZxSU15UExLSytLd1A3UXdKVnRZc3ZMR1hCd1VlOEhrd3Y5WHp0T2lQ?=
 =?utf-8?B?RFEvS1ZmWnpET1Q0NkhTUUZwV29zdHd2RXYzWGQzeElybkc4VWpkbWlzY1hK?=
 =?utf-8?B?TW5qbnZrc2tIWUdmVHhOVlMzWWczZlUwRjdZUmNhcDFuOU0vYVBoZkNRTWJT?=
 =?utf-8?B?M3B2MFVuWVJra2E3V0tLc1ZEZDc1a3hlU1FFV0g1Wld4VjdhdkJBb1JteGtI?=
 =?utf-8?B?dEplOGFDaHk0Qno5QS84T1VxaFF5WUFINzMwSXVhZENldVdtMlAzQk1oYUdL?=
 =?utf-8?B?Mk1raEdmY0hweW1DWmlkclFwSXlWZkNlMjdzZjYzL0JNSDJvWWFOYjlvVzhK?=
 =?utf-8?B?cEZlc3BPaGFGMnpTcWJ2YlJJWm0xcUlOUnBzYUlXQnlET0JkYkFpRDdvQnhZ?=
 =?utf-8?B?VFg3M29tNVNmaXcvSlQ3czNueTNSc0RwRXB0RUdRZHZwNmxDeDRkZE9MbGsx?=
 =?utf-8?Q?LP9IvtLNLnG45yfA4fB4orpn+IO8yf9miLlWU?=
X-Exchange-RoutingPolicyChecked:
	iVmTdRuUauSvK4ovUDgpHa+R4mnxo9KtelmcdDA2BXwrQZ+rRVMw4KrxTXusicL0en4hl1KvyFRLbrsP1X8rd4pB5iY282fzy3R0qC50lcw/xXvpJvZFV6s6Kbl6VNHbQaYstGIXgGhOf0L3vSv23+iklxWfmyhZNbvLtBQ0EVW1qOc1ky7iDSWjHWbcd1BawiMGu6regE/7pnb0Ia9QiAr3hMQZhYKw+Br96wf4J0nKgNk3/mHODDfa/u+AvX3LK6RY/hr7kFLXkw0QkyuTD+lCFd/lGREV3AYiSeUftwts2jdZ1tHcn+OQWO/+a79NZ+O56Ackefd6olzzO45Bow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	omYo4loqic38otnZSJQYZdkWafJjrz7FTO2/JE6DiqC+PNdo2pqvLLy9fqbJF0ONTLZ1aQ3wBgxNyQcuPSrrfn5qC3CVAj4FTKjPy7y3yDPFxObWoGjbyCqLVbCJKU3PNf16p47y22zZoxlVGtw1Chr/HA1+H73bG9cZ91RymzW9H+4c9FLboZMDXNKI3kt2OW0jBjkxer9aN/FixJR77Njk/ol4r6GX2Dggh2TxJUB4Sy73PXDVNtFAE3N+gmBCX4ng3FssEEtSDIp9zja1RykLV2jeBo6UaJHGszW859tZ0LEzcAd9c/08AS3z8tS4x1gb6oTtRgJnmRPjh80nSDKUeu9FkMFpnaTMdpeNP9kCtRhw3219wW9LuMOnQ4toEinE4F+9N/ON08naQV6SB+LqLivvRixc0HnYErVLlyWS5qI03rgg6gu1FChY/qaITx1fG0t9zJpDktHub+e2DShgGY6BGuHjlYvDnFkahSD9fLF+FtbaRUUV/tyFduOYVme4dkzy2XZuLhNau7FMGcr65eVAADQnhJb1b7aK/TcQwhmvsdOFN58WFN9jRHFodwZMEQRgFTKnVQTZqEpwtJuUnELCPDQDj9UDflQwtDw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6089fbcf-bf3c-45d8-17ed-08df2a3de4f1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:55:43.3491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnEwsIaZSw0bqrmSxqOYChn2q473pn//0S+2bsuAHmP/qf1W40uIQ5SNug3cAQ+4vBxXg0zM1WadGa7kNoAa5FeorVZbl7I0asWF3OSOBKPIV6oOm6dNM0oiGc1kDNg+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR10MB400295
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140087
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acffa64 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=20KFwNOVAAAA:8
 a=VwQbUJbxAAAA:8 a=fo35gztUsXGCeQsHbM8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 33_mC6cAX4KAtVBECE742KCp1ktZ7ns2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NyBTYWx0ZWRfXzlM/HxPcBaYh
 dZYsOgkQM8jokVaY1axTOc3qRBeZ0gE2Pakft94PP/IfuHVnCuhymXXkO0MGytcyinokFXok2eI
 i+SSfI6Hu8X7jwaoAtpeR/K+5yu4YDo1sGWE+OwWcZqD7z5TZBYG
X-Proofpoint-ORIG-GUID: 33_mC6cAX4KAtVBECE742KCp1ktZ7ns2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NyBTYWx0ZWRfX90rUXyoV2Jwn
 UTJzu229i1ztSUMLlXz1y8W+IQgzg4VVCKz0w99rdOSs51AkUG1jpp9BXFQ8/Ay+4n/J/q5G+Gq
 bEvL6yPyKZT/bbrUvDTwpe8yXkt1pXNrxg/h+IYclsyQsBpNwXwV6xJpvtb+cT8eSbIfQKV7Uln
 E7c1BGLxeG9QSYjYEUrdBbIyNea+4QFMxQj1vlWCPKIN+PQ1qz3QKQ2Hmk6qyYt6fee4sB6Eq5p
 Wlj93B4Yo7T3HbmdyZpzOzQL6DXS2MVn34rRrV0MSfIjuNwOBnfu3qPdW8P+M2dsX42Kb9fLOoI
 L8sIh8r4KYqXqS97kFh4Gjs89tLch11TemgKKgg3c9kqvKpI+GL6ASELN3ghGwL//cf46HbUWcY
 xCfk7/lOLjXL+tT2u1aBFPN2s4+CYhFNyXgf19SbDnuAdeGcoObj4Jtq9VBHHMDrQ66WTyJTuDn
 SQhsNvL+eHvlnEVUMKQ==

Hi Greg/Sasha,

On 13/10/26 5:10 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Waiman Long <longman@redhat.com>
> 
> [ Upstream commit b8eb5fd5bdb4c03758b056c70e5e1d962ca89757 ]
> 
> It is reported by sashiko that calling is_in_v2_mode() outside of
> cpuset_mutex critical section in cpuset_handle_hotplug() can introduce
> a TOCTOU race where cgroup hierarchy may have changed from v1 to v2 or
> vice versa after is_in_v2_mode() is called leading to erroneously skip
> the allocation of tmpmasks or incorrectly modify cpus_allowed masks,
> resulting in cpuset state corruption. Fix that by calling is_in_v2_mode()
> after acquiring the cpuset_mutex.
> 
> Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/cgroup/cpuset.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index eb725c516ce39..5991a9a354aad 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3915,15 +3915,16 @@ static void cpuset_handle_hotplug(void)
>   	static cpumask_t new_cpus;
>   	static nodemask_t new_mems;
>   	bool cpus_updated, mems_updated;
> -	bool on_dfl = is_in_v2_mode();
> +	bool on_dfl;
>   	struct tmpmasks tmp, *ptmp = NULL;
>   
> -	if (on_dfl && !alloc_tmpmasks(&tmp))
> -		ptmp = &tmp;
> -
>   	lockdep_assert_cpus_held();
>   	mutex_lock(&cpuset_mutex);
>   
> +	on_dfl = is_in_v2_mode();
> +	if (on_dfl && !alloc_tmpmasks(&tmp))
> +		ptmp = &tmp;

An AI-assisted review identified a remaining hotplug mode race in rc1
patch 475, aa947c54a694. I verified the missing bound-mode cache by
comparing upstream with the 6.12.y tip.

kernel/cgroup/cpuset.c, is_in_v2_mode():

Downstream 4a8beb0f1e36 reads the current root:

     return cpuset_v2() ||
           (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);

Upstream b8eb5fd5bdb4 reads the bind-time cache:

     return cpuset_v2() || READ_ONCE(cpuset_v2_mode);

Rebinding publishes ss->root before updating the default-hierarchy
key and calling bind. Hotplug can therefore see legacy mode while
moving a v1 cpuset_v2_mode hierarchy to v2, skip temporary-mask
allocation, and overwrite the requested top-level CPU mask.
Moving this check under cpuset_mutex leaves that existing race
unfixed because root publication does not take the mutex.
e06b678e3b4e ("cgroup/cpuset: Don't access cpuset_cgrp_subsys.root
in is_in_v2_mode()") supplies the cache.

So I think we need to take this prerequisite to make it complete, thoughts ?

thanks,
Harshit


> +
>   	/* fetch the available cpus/mems and find out which changed how */
>   	cpumask_copy(&new_cpus, cpu_active_mask);
>   	new_mems = node_states[N_MEMORY];

