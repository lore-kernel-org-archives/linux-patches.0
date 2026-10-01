Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ACB1624D5;
	Thu,  1 Oct 2026 19:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790882438; cv=fail; b=O3O2Par+ALoVflk3P9WRkQ9oLeCUOXljlwv/thZAngviynlvjs6V8uPhKCa6oUChwBnvjgfCJxllLUvyXDgLHCGW2MVaBBDFmxJCkE9Xa6kgOslp2XSVgKzlmiudymK5/O9PGGCmOzXG5tUGIiAYtFRLOs4LoqfsPotN60vzTPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790882438; c=relaxed/simple;
	bh=SvvLpfZkAtSBoWoj6q2Fq/Qr8LqYSefOzJek8arMnIY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gFHCo+bmJZR7yHfJsPHOkk3eKtI4+pDfWjENJ0WZJaU138+MjEIAYLnCWzh9gEDHj2uCatXnIrvJuCmF+7Jxakztfe/MIS8WiNvtszZWmLhRwni3ivbCrOWQcGdVu5OV6I7WpK1+Q24posvMUJgMDbj5gdPUhnXS94/EbJV7kSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UMnSYAi4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0BaO0F1k; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UMnSYAi4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0BaO0F1k"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691Ftlxh909599;
	Thu, 1 Oct 2026 19:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qIYQiKpFyFZipi5T4FXt7aI1JkX+yCj4bLW4mUC17qc=; b=
	UMnSYAi4b8KIjbIvmdepOyw7g81D+cpx2WJ1ydhXZkG3YcjeoRpMLcAj8DLWoWWx
	XcuM1KtN3d4ILxd//OZWJpBvHzDWCbZTSKZosCJT1EslunuKPunvsuziBLYvmjZk
	oCGDeF84gNscPALLPCrEvDePMYQebBX68vhFoQ0YftatTodO0Ime93yhpScCo2Wg
	GLPRH3+qVyAr+Qc8ES+z62E5JK52K2STlkkWxbepEMd+yqmLwoZNmoZpi+5bXYQf
	FyHq29OlLuXGd4n1427bvDelL/N8ByhjZ64Kyg/rMmyop57Gm9MDRRCgP5XXHqNT
	WqX33QbT8sC3sQiAxFBIKQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx5ns1y3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 19:20:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691JKAoY004970;
	Thu, 1 Oct 2026 19:20:22 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gf8vrx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 19:20:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yb6kBGRPsmJAD0FyTd5ohr4XXIIc8PpmdyuH4r4lvijA7Tjh+hRMJktVJTJ8JHCY9S+PQhJx4bZ/MiGj/VhWLt/AXTSKHAAhGT2zpdlHxOL90kv6z4ZBK2habxarQZxP+TvhzZZX9Ayb76yyD/pvoX+fjaPKIdv2a8PKUgOt3qtWIbHxIURgKTLdYv4LDEF7yq0WqAWqID1GmpGeDHqwjvzOPSWRfVKXUHWpJIIQuyRMnUE8l0l+c29+vQupasHMo/O2LAO9DeDpX4BEhI4zCqa3PdcKXTzUcfDNuVLZ/ypbXHQ4mHoDRoQcRZ5DFf475SDAB+W2dPvBrcSZQ8ITxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIYQiKpFyFZipi5T4FXt7aI1JkX+yCj4bLW4mUC17qc=;
 b=ExvnuCZz6JGaxHpub4YVrxp2KMl0lc0YyFCho7xs0/ohVS4LkFycKVzlOZaQernY6y5OcKMJS76uC5RaCRkTGNxHtegAgudSWkuhgfq0AFo7oCwiN4/CjSNUOXXlBFQySCi8l8u9mQzHPeIljwC+gXxXSfFjIwJ0q7badaDRjDqDkad5JFwhC6zhCSHlxnIwpZ0ij+eg8BCHTeJUS8g0mzByqDnWUBXtEZN1O8Po9Xr3sgXvsiQneXlZLOPlhC0a2j13ABE/zbP1DNkMHYLEFtGc+RPoYlGdm/B7obunQvFdXqdfbvtYn5+2Zcx5zN5sTCu55oW+exH1U8JMEPxoEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIYQiKpFyFZipi5T4FXt7aI1JkX+yCj4bLW4mUC17qc=;
 b=0BaO0F1kv9QnmNlwBpA743aZNcQtoqKu0GyoRdc5o4qr+pRohqDRWgUFtfDrof/S//2udQk8QnHN8YEhcI+7XauGZ0nPjZFitmUoN3ToFNm6nSPPGqc5oUfTaQsTdhxBv4XgDmIaStwUAGtBM/PPkt8OW2LK5cpwOxenbbtzoQA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS3PR10MB233121.namprd10.prod.outlook.com (2603:10b6:8:610::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Thu, 1 Oct
 2026 19:19:48 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 19:19:48 +0000
Message-ID: <d26d9da3-5d91-41f5-9270-863f34c772bd@oracle.com>
Date: Fri, 2 Oct 2026 00:49:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 092/877] neighbour: Use rtnl_register_many().
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152416.722458210@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152416.722458210@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS3PR10MB233121:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b409065-a224-4e92-2316-08df1ff0f578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|5023799004|4143699003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BonDEpHYb9Nj2pa8xWGSwd4faa1B5N66U0b1JXb0YkEuOqybNzoaDHaR+GfT8MnbiO0zxi3v+kx/vQAwY4BMHI6XVBpMsFy6fDFPjmSwCksreerMgLQ2nooELJ1fpVwvv6wpsiPayUmLNeUHjjfkCyyNX6UOZ15bCmLQVtR8JZAS6wW+S71JGYiDmxjdWPzgrnu4wbqDR1yZ1n8khkGdeya1xTkBUQQh2otMoEdXCwnZaa/afFxUC5lSQC9EWQkrYjehTPtHBe+7VHbtOmtP10IvBwFVmJsrbBnVMHXvCzt1WveeQYrlL66dpEH23j82WqEwiX7dXqbHQO2AKvjzQcp2Zll1/LanYr0QtrVuIw/RZG0vzw0f8nnePouA1jAAE0vEZSXpSaMTiGCtpJsiCocY7LoFcsojVpjRR4xw/cS978bHBNwbYffie1EJzhvDhtpxMcfb4klteERYtO8bI1cZLEsgUOQxouxIswhqSJdaP3slwnzXeELpCmLdS0PUlu+IjJRobjPw25i7RN2CgkjF/BKJbO8vjuvOIDMfGlH3q3OxW8VCXcixCsnZtJzRrW5LmQsUGfmBB/NWS/kuR4ynMKBTTLB1Nd6nWmB40ZqVNltzu02NTKTYMV0KvJon
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(5023799004)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mm9NWXBZdnlEME96cWRWYVZ6TVk2U2pJVWU4ckQyQ1A5UUFQTGxuOE9TYVU4?=
 =?utf-8?B?TTlpUEhaTWZoSWRQVFd0SGFYRFVRMCttbU1oS1VNYlNaZ2NVNDk0MEhDZlVp?=
 =?utf-8?B?UExsbVByNjBCZllZVkIzUTVxUTZMa2lJZEYwVmxhZitDcXBJSFlEN3g5VjN3?=
 =?utf-8?B?bDl5OXhrUnRQQ25Mb2Z4enZqSjBnTVp1U1V6b0xKeHRnU1VLdUNtR1FaT0h2?=
 =?utf-8?B?TEdmS24ycS9FZUlFQWgwRGQ3dWhuS3ZVSGhMRzRVbEtXZzVHZFdUUE55cHVL?=
 =?utf-8?B?eGJrbEUrK0dvaGVNVURPZDlvTEZWT3MyTUFQTG14OFFWYWx3bGpzT0toTDQv?=
 =?utf-8?B?YnZvcWhwL0U4cDNOcmdBLzBORDFtUzBkbG9zeUVVeWVweUx2dS85V0J3UVlF?=
 =?utf-8?B?ZzdOZ2taYjljME1vVVhQdUgycWRzZml6WXVURVhjU0x0MloySWFmeEVYcFlu?=
 =?utf-8?B?aFBQMEIwcVBTbVoycVRwT3daMjRpRFg1bFhlUGpqZTVEamorYm9YTTZuc25T?=
 =?utf-8?B?K1dDZEFSNGZjQ1JFbFdhWTdNaFo2RlZWVGtHQkhuNDlZL05kNUl5QlZ3ODc5?=
 =?utf-8?B?WW9jZUFYYXJENlAwM1FrM3F4RDlNSDEva1gzWGlFbVBKSjJnM2xDbW5zdDEx?=
 =?utf-8?B?M3JXSnBub2JGSGNuekY0RW9od3ZQWnFOeWR5VG9OZC9pd0pmcUwxWmZycHIr?=
 =?utf-8?B?ZUNqR1lWWStOTUNtL2grUW51VUZvRHZ1bGZ6NjMwV1BkSXg5QnF0VG5ETFA1?=
 =?utf-8?B?MkY1bWl6bFIrUzBtK1ppRm5Qb0MxUHFlc0cwYnZ4a2FrS0tQQXljZ3hWWjNO?=
 =?utf-8?B?MytRanFqWnE1L1RwRVVlLytSNGFzTU5qSTZLV21QY1diWGFlV3hxaXVib21Q?=
 =?utf-8?B?cFBrb1JrUjJHVFU3SWFuZlZ1aHlVS1NJbHcvd0NHcjRYNm1ySHRtd3BiR0xz?=
 =?utf-8?B?a2hlTENyUEVQWnE0c0hlT3VjV0pGVldjaWh4Sk9uVDhBTnBHSG5XQklmeGJM?=
 =?utf-8?B?VmNybmJ3L3F1cGN5c0J6MjJDd0FaUndJL3czMVYwME5CUTNIUkFoUmwyQ1F6?=
 =?utf-8?B?UENMN3ZaZ2hyemJkSXcyR001QURJNFZ6dnF5aVBhZC9YNzl0N1ZmWUdwVUF4?=
 =?utf-8?B?bGtRZktlQUFjb0UyclR2WThSelRUdjB2NXVsa290alBGQlNGd3V0eGZ2VnNj?=
 =?utf-8?B?NTFVRklocEcvc204LzBETk1lOHRCY3VnTWxabGdJTlluV0FwRzZ4MW8vcEpG?=
 =?utf-8?B?a1ArMTNibXdCMlZjUUViU2tqVTJSQTJrUjdRUzFwNzVtYnBXS0VaWE90aXg1?=
 =?utf-8?B?VW5lSm4rWi83dE5iMk5wemxDbndQK3hrOWpsTGpoVDE3dk5Sdzl3YkJIUG9Y?=
 =?utf-8?B?czFlWWZEVW4zcnFuVjNGdURpdjNmaXZmTWJFcjJhWWZzcC9ha3dTakZ0NkUx?=
 =?utf-8?B?L25SbFV4SUk4UHV3czlzcWtpMmgwV3JUZzU4dm1Lc3hIVWdiYjR0UjNSUjZ2?=
 =?utf-8?B?TDBVZ3htajBoK3FaWWYwb3RGRkYxNHhINXVpNm9ObTZ2NzJYR1FjNDNydzIx?=
 =?utf-8?B?bTkyUThEbHNtN0d2S1FrMEE0K3BNMGdkaUY4T2tqLzcxYjVRcVJ1d0x2M1Zp?=
 =?utf-8?B?MlF2b1ZWR2hUbzhud0IxRzVOM29pS043NnlTMzIwcnZlSnEzWkVkN25kSHdl?=
 =?utf-8?B?M1pFYmZZV3VabXBpc0pYY3RxdWNHNUFOVnJTU0JjQ0I5K1JuY01RMjNkMHR2?=
 =?utf-8?B?UUIvMjJKNnlDTUZkeGhsNkNwVUQwQUVCaVdmZEpLb2U5MWgwaXRWOGV4bVpQ?=
 =?utf-8?B?Ti94VXhaT0d1VWptZVF6WnJmVDZNTGNuK085aWlkT0VpZmhmMjg4MWZxSEh2?=
 =?utf-8?B?Z1kzTFpVMFlWT1AwdGxjYXdycEYvbmFXSVpJNW0wcEpBUlVDaldxcTF1V25h?=
 =?utf-8?B?WGd1YXd2UTlKMCs5OGI5alFsV0pvNjB6SzkrdUhUNkhBNXNlZVhyME9xYjNC?=
 =?utf-8?B?VnlYUVgzc3JnaUlJSjVLeHR2RXBpZnloNEpHSXp5a3hidFpiSmVRdEVTaVlT?=
 =?utf-8?B?am5FNTFmMW9tT2JjZ0N1Q1dhNTZlUVdzSzNMYnczTEJvTjJmZVNNbmt3cFp0?=
 =?utf-8?B?NnhKcW1ZQU1PeEJhNTJmMHM4ZEdFSVkzSkM3eWZUaUk3SFlyMGhtbVp6QkRX?=
 =?utf-8?B?eGtDOHhEaDI0bzljTE45M1BkdTRJcFJ2dThRY1FMUXJMVW93Q3p5dmdRanN6?=
 =?utf-8?B?TE9IZjA0d1ZZKzBUZTRuL0hHUUNqTU1wM2oxMklqdmdGMVU3WDJkb2Y5QUll?=
 =?utf-8?B?VzlUOWZPa1F3MDU4TWdlOXgzVnM3MFEzQnJTaHdZRjVXYjFpNjNLQ3pwMjd4?=
 =?utf-8?Q?UkszatIR85b11FphrZFcY9ayQJbHPoa86SbyN?=
X-Exchange-RoutingPolicyChecked:
	0GB9zxAoKiWDZmLsiiSPj4wiuq88j6D65Axyy9YS0FPTnZkTtXAlI3uTWswL1ZVns9S27gnAI6khvf2BBH+sfDatIankKL0gRO1GtubqR8ruv4Funx57X9204VkLoF+zZaJfiWhhN2IjbYY6bM/4iK/ELVDqwwpNjHYoEdw+4kRwFsA/2Uvtl0iC/iaSQRsCPKUKzolEZjygbvXPeSQ+n8Jz9e8oUcteAusU57UauDwpoOcPT6zI4XagrginrazA28HojZ0P/gqF2CPRM0VjZgJiNor8OAAXuNzt+uQxgrPLO09l9wnu9D560dNtbU0IrOk+oarBs47IfkgcA/ekFQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nJ3xmbLfvS/oCqoTyqjyWyBXCorRq+OzW/hA0VSAF+KdEcEy64LsZogKH2WLbr+nZgz65eOaqv3g+c11crK3GAmiGax00+9MF1/KnR7AtaO8pDixny+U4ceaeyPnDdf3TMR59E0qcqPoA7Ezr9vPqjKcgCZSOv2riLbt//0sDSlEXNCx+XIk5UHrb6uJVIggv72PMlnDSgrJOEFn43EJe2UOdcGiCS2no+9nRL3snnwMDHS3Ggk8hUQ45xxh+WRLCyKPKZjeacn2wqCZlyA0zSMYtivRoyo1GYiHBc3VnacPw6h++vzVYNZPZxEwv6rq5NoxpEo68eQfMIgU1Mp91wlZjDtjvylipoMQIV0yaeV7rBRwYTui7E8GpwesyDR5EePbxXf66XFaMK+2FW+vGdC6dW8ms6D7oZJMuSarHj/fFVQ68wvco2flHxe46kIZqal9lxYmDAPkxkgAGuIzFezCizu8OA7AJLAy8F3kJfJrYVKKKmQJSmN3Jd/1E+d1uHx0Rfr/IGlcBMa4yLnqAh3/8qZ/rPcHtPV+bK2TANRu+7iNc2pEgTHKZ8mdnhwcIM5e7KXndKqFDSwxpDuyoRMpIxD1hc5SGIXzDBupqoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b409065-a224-4e92-2316-08df1ff0f578
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 19:19:48.3572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71T8D5x5/lelpVBw61wmBlxoJJSr1eydHh8+BddMLBc6NFEpXvodGXAvIhqGNbf3N9NGNB7jK4OauC2nfO4btyD/pieLe+gGRVNu3QhlebwQXFNSgkRGEysCKwaGHcCT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB233121
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA3NiBTYWx0ZWRfXwuUXyFzT+uan
 7LrFW0hKMVxYY7+V/dtv+AFMfMFQE/xbnz6laW6SWEISnx2g33vxiVl03rv2PoBpauvUcXgMlkO
 mFxMuVvtgg7olUA0qA0ZEMYQZpESG1pcrnNfWVwTG9O2sYbXDl7TLToIP7DRXn3X7pM3JRh0rZg
 lsFYTvdMQcm1lG1H4Zor3ZyZ2RUZ7YVUdNv7w2CSr/T/M+hFj3qkuSwXJegotaEqaAw3zGn9nj4
 3ksg7XJQmF3lcAHLxUSdahDFvJmwwFsZWSr9WkRphHSz3n7t/1+DTpYyy4h9nNG3pixA+a6C6vk
 IbF2Q1O6NYki36vqWLNTUVWOvJGdkOUONpEMYTLqn2BuGj77GvqSKS6X1dBD1RgZ/SAmMghrkfy
 TAUrrdukUbOAv/Qmm2b28l9BH4uUc7My+0hrHlhNi9RSnNAQXlfdlQK0G5OX//lS1R02loCNy60
 Vm/aaAgBW0rfvbExHuA==
X-Proofpoint-GUID: FWul9jyrMRiBjZF-_BynIou62FZR2DgJ
X-Authority-Analysis: v=2.4 cv=T8QZ3PKQ c=1 sm=1 tr=0 ts=6abeb277 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=vggBfdFIAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=AKJLblqdeLvfoYedaXcA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA3NiBTYWx0ZWRfX4aAN3hiUCr6y
 gE7/52h3ESg2ItBhto1E/MDYplWKawAAi0/4sv27lh3FnA8LwedEZZZZB/oxbgn2+kUcD6Mcdw3
 KqfX+36qpLPAwPJvIrGqHs6QOlPMd2OaidyOPo9cuhbZgs7cuKqU
X-Proofpoint-ORIG-GUID: FWul9jyrMRiBjZF-_BynIou62FZR2DgJ



On 30/09/26 8:46 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> [ Upstream commit d0d14aef50a6184426c5a05b9815fb2697d6d42c ]
> 
> We will remove rtnl_register() in favour of rtnl_register_many().
> 
> When it succeeds, rtnl_register_many() guarantees all rtnetlink types
> in the passed array are supported, and there is no chance that a part
> of message types is not supported.
> 
> Let's use rtnl_register_many() instead.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://patch.msgid.link/20241014201828.91221-4-kuniyu@amazon.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/core/neighbour.c | 19 ++++++++++---------
>   1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index bf07438d6dfa5..1dd9f85b74997 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -3898,17 +3898,18 @@ EXPORT_SYMBOL(neigh_sysctl_unregister);
>   
>   #endif	/* CONFIG_SYSCTL */
>   
> +static const struct rtnl_msg_handler neigh_rtnl_msg_handlers[] __initconst = {
> +	{.msgtype = RTM_NEWNEIGH, .doit = neigh_add},
> +	{.msgtype = RTM_DELNEIGH, .doit = neigh_delete},
> +	{.msgtype = RTM_GETNEIGH, .doit = neigh_get, .dumpit = neigh_dump_info,
> +	 .flags = RTNL_FLAG_DUMP_UNLOCKED},
> +	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info},
> +	{.msgtype = RTM_SETNEIGHTBL, .doit = neightbl_set},
> +};
> +

I ran an AI-assisted backport review and it flagged this; I 
independently checked the upstream code and 6.12.y at f4ffa8dc360b.

Upstream __rtnl_register_many() at
d0d14aef50a6184426c5a05b9815fb2697d6d42c, net/core/rtnetlink.c:

if (err) {
     if (!handler->owner)
         panic("Unable to register rtnetlink message "
               "handlers, %pS\n", handlers);

     __rtnl_unregister_many(handlers, i);
     break;
}

6.12.y's net/core/rtnetlink.c:

if (err) {
     __rtnl_unregister_many(handlers, i);
     break;
}

neigh_init() ignores the helper's return value. On allocation failure,
the helper rolls back the batch, so boot can continue with none of the
five neighbour handlers. Previously, failures were logged and the
other registrations continued. This boot-time failure path remains at
the review tip; upstream makes failed built-in registration fatal.

I think 6.12 should take 09aec57d8379f14ffde566621b920d97cc0c46e1
("rtnetlink: Panic when __rtnl_register_many() fails for builtin
callers.") before this conversion so the ignored failure cannot silently
continue, thoughts?

Lets drop this until we also take a prereq ?

thanks,
Harshit

>   static int __init neigh_init(void)
>   {
> -	rtnl_register(PF_UNSPEC, RTM_NEWNEIGH, neigh_add, NULL, 0);
> -	rtnl_register(PF_UNSPEC, RTM_DELNEIGH, neigh_delete, NULL, 0);
> -	rtnl_register(PF_UNSPEC, RTM_GETNEIGH, neigh_get, neigh_dump_info,
> -		      RTNL_FLAG_DUMP_UNLOCKED);
> -
> -	rtnl_register(PF_UNSPEC, RTM_GETNEIGHTBL, NULL, neightbl_dump_info,
> -		      0);
> -	rtnl_register(PF_UNSPEC, RTM_SETNEIGHTBL, neightbl_set, NULL, 0);
> -
> +	rtnl_register_many(neigh_rtnl_msg_handlers);
>   	return 0;
>   }
>   

