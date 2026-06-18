Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B20E283C93;
	Thu, 18 Jun 2026 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781803606; cv=fail; b=cwW1mllWFA18FTyfsy+2MUoJyPR/GfhMyK2J0Rhw7Z09+cV4Xnn71oLsdW2bGzO65aYLs4GQVT+LhMIwuzZy2eXq4lm01UIYLAkbZwaMMViId+XEys/7hGSiJpMzJyTmYsyh50r0aXRMEN9ikU4gLRymaDfrH2IJNDwo4eMU9+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781803606; c=relaxed/simple;
	bh=We746UNq438e6R1Wpyr/rkszkDImtnHtPk2uTXG2Uu0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ejoH/RtTj/d0ePZ2yxuuvPpBtsUCkcgUlNKOlAthMDb84Q0toSroCS1KqyYcC49MKvEMa0mrrwKc7CYFO2PT0MPTZNsOONSDzfQGojNZA3BjrgO3cvQuPpgIuuUSQGLwi97le/KtFM5Rs5p8l9qV4naTtSv21bg16cBz0dL6G8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QZCmvLv/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hFJRAjTZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QZCmvLv/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hFJRAjTZ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IGEFXW928844;
	Thu, 18 Jun 2026 17:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dTs24Ps7e2hqgZ3Crtk9LqEq4ew70Xoxq7xSR/42Z14=; b=
	QZCmvLv/MOfoVfRGwt5kL0q1VQ9yS7LQ5XfztRHAZpSD6HwSX3vSitFKyYzNy90F
	9mdLO6q2zoJCHEzVgVfgBWWxRU06w/Lkin1EBXByLGYmKtUaoXK/jvrhcQk3ZlMe
	mgJuN7SwOaZy1i/tYzS00ZwrjOnBHzj9IZ/j6Z2Ck8FYJ2oVRySiMYzGGfJRbnm9
	O2GjZlRT6BXyJWq7NCjiImE6q724TmjAwXPN+l3FVqC5xJAd4vLNPbMTJ6G2Uuev
	jcgCBUJ5B6yFdj6hdASLXx8ikV+I43ohLUZylBzG30knnSYZ/4Wqo14npiuP/HPV
	lZR6grjZelMvTtvVui07xA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euefuu24m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 17:26:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IHHx6B038034;
	Thu, 18 Jun 2026 17:26:26 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013020.outbound.protection.outlook.com [40.107.201.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14f5ykw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 17:26:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nH56/3/nXry+CJMqTuWoQq/qOlLl1ybRJRRA5/F24qqziTg/PSmhxdPveP2RtSXB/2rc5M2mYBskuD7SS83NcncTj5gLj8QLzyG89Arl/OV+udX7YPCFfCoVAToRuN9j+t2vN4Y/5dndUX0YeWI33j9g/yOZq6gCLcB/0s/C25coSO7SAgzHBb+8fVzBxK9UStR6Z6pRFTvT7162U1HUrSdKHcLriXeDnb9/jFzCW4KdUvvRyhAWZXcJcg4M4h9NUm6Q474tae+El8HYA5nR2cATqsGq8tsHuaDc9LRURnACYYVj5zkKJUbfe3Rn2lqtUYJIqhfis7Cn5Dpw6aL63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTs24Ps7e2hqgZ3Crtk9LqEq4ew70Xoxq7xSR/42Z14=;
 b=EKHMDx6du5YVSu6KjENzLK/w0HcIYrByce/PB/QJp3IFq1DaHQK023rlLAosnqfgwfSz49fAWW5qLaUfyZxES48WP1Pat+o9fYv/0OJCJxQ2UcEw1ytp/SlUSaw5pLgCgPIhAqs4OH1uSssrWRpeepd6Vi0iU5bXv4PShcwtDoiGzAx5681kLTkF2VTyMQkCEX1Ix4CPoWX0CQbKsLKGY6ySmGbPwe5U64AfzZlnLRgu5RU0AAp9bo0TcGGjJa6mZP1y+AhESjz5TrAD1EF1zPg//ZVhpTE0WsYYguWQZ3GI61YWHK4r3U6b+ja0kUK6bjjb7UNR9OH7Sfa0v8HyWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTs24Ps7e2hqgZ3Crtk9LqEq4ew70Xoxq7xSR/42Z14=;
 b=hFJRAjTZ5vRrRtc7b3O5+CCOEnULZk4zwHS+3d50DFDN68LtwbJq4DVUNDN/L8U2oERbiJ6dLG2IGUiBHtnpyA85fvrps0KXOVyXyqlW8DV8HaSXIe3T7+3d1yLnmFnlFhnYvCNvVdY6np6WQcuFzEjVI1CGQnDa+8S3txCgA0s=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 17:26:21 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 17:26:21 +0000
Message-ID: <65070920-961c-4567-badd-cd4b2f264e34@oracle.com>
Date: Thu, 18 Jun 2026 22:56:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 009/411] nfc: llcp: Fix use-after-free race in
 nfc_llcp_recv_cc()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Lee Jones <lee@kernel.org>,
        Simon Horman <horms@kernel.org>, David Heidelberg <david@ixit.cz>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145100.851905886@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145100.851905886@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:8:44d::15) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb54e43-ac83-45d3-1992-08decd5eb6e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|5023799004|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oN/MDVrgji6cocw1xqNRKdYLPpMQQ2sm4/FeVZ2MLjeDJ7pLre1EyuqBfozp5f4Cber2AOTZs0AORThFkHbmQW3y/Nyz9ysw3PmwIJUhZASzwYJaYo1dTW1bqpS4XH45rCH096sGveWlMcC1hp5jjUiH3k3muWUg30PYlKRli58gbZhMZGByFtJWbzILN9JYNu7lYIO82fn4ol2pRu8Bx83kfUe0OQoVh2vgo/DPgwLofIWhOYVBxtktpDivLXNnxiW9DZny5kjVTaWfMTtDP7qCzfbgvY3ngDcy5nXuBEdeutLk3HyxsoVdpcTt7xZjulb++qfsPePHEquiSPE4D/Knytg1ATTvyKlAdfK8QyE/qLwtrbywpMjKV1Q1tguyCkDy2wZG99TN/TN9JDF+UemPVmePCfLLiZfYr0N2srP184Mtu1DBwX3AOTvy0wFdwkFLT791v3B80C74BYiLhaZv2xjqHjf/SlJ7M33hZAaA+zZCfeFpk24BdZNUzaudvhc63VGt5BFhKRGhFwf/9IY0c+eO7rHEfNi+03y6sIcDG22rM3J1f7Xx3Z3ISdZp4+tGI7UZOrD51nasfPsNvQC1tV4IO2twHNKd8axrACq9aqzttEiKa7GZ6zq+AVpFmpaKN1vjSn6o2a2qB7EfJQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(5023799004)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlZTUDJOVWZOM0VybjBRbHdkdmlmdC9qOVQzOGo5cFhUVDJBeFRhTUNzck9U?=
 =?utf-8?B?MzlFbHNYa3prSVVUeUJLVzFwdGJMd2g5dHBXMUMwZXJscU1teDdEYzBoanpO?=
 =?utf-8?B?bngxc0crMk9TV3dCeHhHK2ROenlYajNSS2dVdjA4ejlLN2pyMzd5eithVG9z?=
 =?utf-8?B?a2c0ZjFsZ0VyTVlveUpYc3hzeGlBNU1wb2ttSGRwWGcvTm1aREFvSXVGWFdD?=
 =?utf-8?B?ZXFUdm9NUFMvSWtnOEt5clVTSnlPZ3huaGw4aTlqSGUyYVkxd3hrZkZFNEJq?=
 =?utf-8?B?WUt2dkpnRjZqeEZuc1k4cENxMDVvNkd6S09JNTEwSUpPdGNjb1N1bGFlMGdO?=
 =?utf-8?B?ZW1hZzh6dVBLTCtXUlZMQTlOSW55dXZvV0ZtZjhJS1B5b2VOY2JIL3VySGNC?=
 =?utf-8?B?cTJUZ21MQlNBZVh1blRsK3pFSVhvdkhoMXZPWjN3SU0vRkdHMTk0b2dPQXV2?=
 =?utf-8?B?Vys2enVPY1NUalZUbUJ1NTRUT1RIcDhQeTFDR0JQYUQwYmkvN21nNFlROHpl?=
 =?utf-8?B?bis4VVNVcENhVHJxNEJ0MWVOVTdBU3FDNndERklTS1BNZXRGYWFqLzJFZVI1?=
 =?utf-8?B?UmcrNDlLai9PQ0xPTUx3Ty9xNHRKK2pNUWZYSW8vWDN1Vm1ucUZZL3ZjcFZn?=
 =?utf-8?B?NFk4dFRrbTkwalJyK0U3Z0NzdXpxNTZIVmlzQkRvdUNoYWNrYjM1UmxMRitC?=
 =?utf-8?B?Wm5QbG9PazF1SFYyWHo3SDltSStZOUtJeU9LdlM0REdKRnk4a3NlZHhtWC9x?=
 =?utf-8?B?NytJamF5MkdmMjRjdnNPczVCbnNzUVMxOFpKTWsvZ2RneVZFYzJKNmh4YjdT?=
 =?utf-8?B?bEdiTGFEZXRYZmJTdFArSGpyNXNpcnZFT2h4OGZWaUViYVlDV1JFU3gxYys1?=
 =?utf-8?B?eEJENmVUbnNLaFBVOHpSTEJiaE02bHBBQlJ1ME4rQ2crajVyMThrL3UwV0Ux?=
 =?utf-8?B?SThxMHA2UEU3RU9jYnZkNnNBcFNUcGg4MmM1bnlodTJ5RTdoeDBOdkdpb1NC?=
 =?utf-8?B?TGV6ZjNBR0JEV3J3OVlsY1dYazQyZnUra2dCODVCbXZtZGZuV0ZYM2w3UUV1?=
 =?utf-8?B?UEErUFRsQjZDbEppNlMwbkJPeVdPNFBGeUJNaDcxVTZKWFVUaU82ZFpIa2NW?=
 =?utf-8?B?SG1PNnRWT3p3K0JBK0hKNGV4U3c0SjJab2FlbXp6eWFFVzJLSS9ZWkNuNEhQ?=
 =?utf-8?B?R1ltTzdQK211U0dFMFpwTDVsdXh3cWkvTGdFZk13T09Hc21EZU9qT3pWN25E?=
 =?utf-8?B?ZzlDVVEzYzYvaGVnRDRUcmQ0YlViZkV5bFBpWU1UMDBTeGR2VHA2ZkZySmZz?=
 =?utf-8?B?K1FIcTlPUmExTzZDcUtCdGNnaUdMV1BiMUZIM282WFBySFlzMWNBdmdKMWJ5?=
 =?utf-8?B?UDgvdmwxN3hjblJyWUI5WjQ0cEp6c3cvdUtwTk1DMStFTHlQa2FNSURaUDE0?=
 =?utf-8?B?Wm9NVVVkSTV2UmFESXArVXNINWptZ3FNNzBrM2J6U0JLa1MrelJ6djUvQkhl?=
 =?utf-8?B?bXZldHpYWGhnVU1nUDYzVEJaSDExdy9nNG52ZERpcXFEditVais2d2JNbnJv?=
 =?utf-8?B?bitFbUcwc1RVL0VnRk8weFJpYi8vby9ZOE92N2lZeWpiNXZkazh4OTVXZUxz?=
 =?utf-8?B?OTB5NjNwNVE5UU9ETnJiQXpxQmVZbkhwYVU0MXJHeHBKVm5BOHhDTm5KNTJx?=
 =?utf-8?B?aE9zMGlXb2tnMk5pQWFzU1p3S0Z5b2M5dUhhdWVzZTBPNDE5WXJFZ2REMXVn?=
 =?utf-8?B?VG1JOWQyNWFnS1hkaDBodmE3T3VhcVhwNmRSeUJOajhkdWRSb3RaZ3JNMW5M?=
 =?utf-8?B?dDBDVDNjYXk4a1pSbWdRUm80Yk1PQU8xTFBqQnppM1cvN2U2VDF2UTJSd1lS?=
 =?utf-8?B?WGYzZlVpaXQrWVhKR2lpUGJaSXRNdjVLNTkzMkc3UGdiUlpkVWhsbmZGS1FY?=
 =?utf-8?B?WkY3ckhpT2xXcnVUUWZpZnVlenYrYndNUDA5TzczT0Jicld6YTBhSG95MjB1?=
 =?utf-8?B?ejI0VHZtcnAyQk43RmhFSVFJN004UnplbW1xS2xsTlJ4Y3ZiaWtLU1I1V2pv?=
 =?utf-8?B?RVRWWFlaSjVBY0lPa0c0bVNTOUU5Mmt0dm1PenhzQ3JNRHkva3EvL3l1ZTEv?=
 =?utf-8?B?VHV6bUZNdmcrS3Vtb0kzdDFhWUw3alBvYkhwRlFzSFFZQlY5dE1hRkFSK3p4?=
 =?utf-8?B?UmJuTndabmd1anhFNjFZV1JtdUtHaDVWZDdlcUtPdDE4N1JmQ0NjVDV5Sjlj?=
 =?utf-8?B?Q3h1UDZOdGlCcmoveFJhMkdqdFhEQkp0Ylk3WmJKT2YzekpBVDFqS3JFUkUr?=
 =?utf-8?B?Mkk4MXh1NEJIZllIcVM3eFV2L1kwWkxLV0lNNDFvWmQrV1pwTGovU21YWmpQ?=
 =?utf-8?Q?ysfuciTsh8RNEj3BeEarNmJKi6R8XZltlllcO?=
X-Exchange-RoutingPolicyChecked:
	S22fZelZft1ThPrZmVoRL77fng0uTyQsWi/hjBFWUeUol+E4ll9ouvOX4A9pxcZTQ15+gOMtVSBQYtu6nJANW6vb3YdTR0WPoqDs9NfFTpTGaNYEEbD+GQQGy3KDeLLHg199XR3A4uvWGw2ilfCc6MLXrWy1jq/Z8az/5hjGCpeQ3CJDpZsnPY/WS6bmSLktAlO2ehuXDFFtAjcCZE/1DdMud7iyYBFwqa37bXIKgUQY8KaNWlDmT1bJy+NfWEc1onxWPJo0j3Es0bv3crlVtSUJZ3tFzvOf36feyhvNYI1hDmX9JEViZS9Xebdg0/z6NxIb9iYlwODFhBrVxuMG2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XWavHmJActQ343l93KgrCNdsBx2VR7BREdLH6lBMF6wCO5OnNyQWHyqH2UDfqRrgTf+8d+H6CfVvtEtl6NOGd3j+LMr9RXWaAYO/W+YEupBDteKopatnJSFfbp4n+YsVf4ZnFUHIvmFAbYUcHHMvaCS6/o+GxkfOTF7CFIUwN9e6gpNePBGzxHQ7dd5gJt5m7m+IA7iGSihOSJmebVf55WpJ5AJ4lUCc7f+J73I2UsxoDwPY8kKk1jbD6t77ubdKutXhI0uq1UlW5pxIEX35my63iiIjsW6sMc2yMVqx9ojLujvpRQ7Ks5ey/kvv1ocAGADuTwpeea4yR9xNzAU58eipw+8AGz2XLs7CtO9fN8ljjTyCoVBKT3qLgb+aythsWj+RxPl5l7leo+nrKjkR2I8zGBcvngdCXRbgK7u/3NGRBjoeZYVqF5pSv3q+p/7dOqR2X3e0eYZhyGk+FutkWkuUSKVP807oOFyTZQfHKsUoDKQxmawoJZTyXcm3GGhZrALaGV4pQzqEcn38rs4m58/6eCd4D3oBPL0mPXeDCXSNZ8HIzr5ukzFjvOvzt1HSgWLq6xKTN6WE+zstxwGK3ewuomdxiR/uB8P6gMeEfS4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb54e43-ac83-45d3-1992-08decd5eb6e7
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 17:26:21.4123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fvdY2D+pKYR7CL/9TJjmquK+6c8nuWYQs+rw2h7IrxewbJ2WB0Q05joSFEuB3eKw1vDVoyUTusPEkk41ikPr5N7lhkrDaNVkK3sY1Xh0h8HDmzuy/+LQGa2Le1rFz9kX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606180161
X-Authority-Analysis: v=2.4 cv=faedDUQF c=1 sm=1 tr=0 ts=6a342a43 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=IAvANTTsyYtmOMwDY3YA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: NAE45bkuAF9yA1VwWhVisNI93lD-7fJa
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDE2MiBTYWx0ZWRfXzCD0etRbVJdh
 l9REPKqqoIdspjnemKUHAtw4CG20uM9jeIBjZR1TaOcdZY5CwPNkhLFQ6vvhwUg23VnA6CL6sSj
 ruEamGHms4B4P9RgmAHxRqBifrXlUiH/gChjRKS0ckrsnUqThORx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDE2MiBTYWx0ZWRfX5Et9aJlqH5RO
 DfQbi6SKNqbVaNH+Y7nY9Jxs44YAiVF/omTDfIeOzpdCIqRnFxkOqeePd5tMXYb/1/ejJS9RqV+
 8u92JkFE0165tlLIOZYIaNHdqYPxIg0vO2/OlJi38xVlex+vvNSUQrZYy+P/hblzgQdJKq8maHV
 0ev5Zx73rW0mk9WdedHTEymIr69mVfLPrwC/nzRugS3AUZgx1YIEIonBzlr5/KI18s5IL3dl3AU
 mnH/fn4G2gx8KntuA+/Yej4OM2bKkdxVETF2+d35oi4aw1cYV/j0udeaGV13Wigdri0myeqK35x
 9GQhkVLjtDN/pQk79jKSQGSgYmGf1ISAkIcY4Aj9K8qLpP7b3g3R0BdfKFjQ07G6aH/oUU5Rcg4
 G9xfx3aneYHCNpvGcaR2B0V8pSdE27BopB/A1QY8xtVFP7HrNZZtOfmmtKHmRLVRp6IUgIbU8Mk
 AcNaG74BJlOsMfWdT4g==
X-Proofpoint-ORIG-GUID: NAE45bkuAF9yA1VwWhVisNI93lD-7fJa

Hi Greg/Sasha,


On 16/06/26 20:24, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Lee Jones <lee@kernel.org>
> 
> [ Upstream commit b493ea2765cc17cb8aa7e7544a4b6dcb05b6ed77 ]
> 
> A race condition exists in the NFC LLCP connection state machine where
> the connection acceptance packet (CC) can be processed concurrently with
> socket release.  This can lead to a use-after-free of the socket object.
> 

^^ let's remember this: race between acceptance packet(receive) and 
socket release.

> When nfc_llcp_recv_cc() moves the socket from the connecting_sockets
> list to the sockets list, it does so without holding the socket lock.
> If llcp_sock_release() is executing concurrently, it might have already
> unlinked the socket and dropped its references, which can result in
> nfc_llcp_recv_cc() linking a freed socket into the live list.
> 
> Fix this by holding lock_sock() during the state transition and list
> movement in nfc_llcp_recv_cc().  After acquiring the lock, check if
> the socket is still hashed to ensure it hasn't already been unlinked
> and marked for destruction by the release path.  This aligns the locking
> pattern with recv_hdlc() and recv_disc().
> 
> Fixes: a69f32af86e3 ("NFC: Socket linked list")
> Signed-off-by: Lee Jones <lee@kernel.org>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://patch.msgid.link/20260429134115.3558604-2-lee@kernel.org
> Signed-off-by: David Heidelberg <david@ixit.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/nfc/llcp_core.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
> index e04634f22b49f4..c7de44637e0187 100644
> --- a/net/nfc/llcp_core.c
> +++ b/net/nfc/llcp_core.c
> @@ -1225,6 +1225,15 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
>   
>   	sk = &llcp_sock->sk;
>   
> +	lock_sock(sk);
> +
> +	/* Check if socket was destroyed whilst waiting for the lock */
> +	if (!sk_hashed(sk)) {
> +		release_sock(sk);
> +		nfc_llcp_sock_put(llcp_sock);
> +		return;
> +	}
> +
>   	/* Unlink from connecting and link to the client array */
>   	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
>   	nfc_llcp_sock_link(&local->sockets, sk);
> @@ -1236,6 +1245,8 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
>   	sk->sk_state = LLCP_CONNECTED;
>   	sk->sk_state_change(sk);
>   
> +	release_sock(sk);
> +


I ran an AI assisted backport review over the 5.15.210 queue and then
checked this one manually. I think the 5.15.y backport of:

This backport is still incomplete.

Upstream b493ea2765cc has the release-side list unlink covered by
lock_sock(sk):

net/nfc/llcp_sock.c:    .release        = llcp_sock_release,
^ release socket function

lets see: llcp_sock_release()

         lock_sock(sk);

         if (sock->type == SOCK_RAW)
                 nfc_llcp_sock_unlink(&local->raw_sockets, sk);
         else if (sk->sk_state == LLCP_CONNECTING)
                 nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
         else
                 nfc_llcp_sock_unlink(&local->sockets, sk);

         release_sock(sk);

So unlinking happened within lock_sock()

But final 5.15.y still drops the socket lock before the unlink:

         release_sock(sk);

         if (sk->sk_state == LLCP_DISCONNECTING)
                 return err;

         if (sock->type == SOCK_RAW)
                 nfc_llcp_sock_unlink(&local->raw_sockets, sk);
         else if (sk->sk_state == LLCP_CONNECTING)
                 nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
         else
                 nfc_llcp_sock_unlink(&local->sockets, sk);

                 nfc_llcp_sock_unlink(&local->sockets, sk);

         release_sock(sk);

The receive-side part of the patch now takes lock_sock(sk) and checks
sk_hashed(), but that only closes the race if release-side unlinking is
serialized by the same socket lock.

In 5.15.y there is still a window after release_sock(sk) and before the 
unlink where nfc_llcp_recv_cc() can acquire the lock, see the socket as 
hashed ? I think we don;'t have this backport: commit: a06b8044169f 
("nfc: llcp: protect nfc_llcp_sock_unlink() calls") in 5.15.y which 
might be needed I think. This is only 5.18 +. Maybe we could queue up 
this for future stable release ?

Thoughts ?

thanks,
Harshit




>   	nfc_llcp_sock_put(llcp_sock);
>   }
>   

