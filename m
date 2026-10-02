Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703CE3B7742
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 20:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790974080; cv=fail; b=Ok2KVfk2bjo/s5z+4VqaMTt84LUHW4BsYiDS+AtR8Y97wd3KyqO/nXcR1vmMu9UvGC9w+fudXUjfINvLGeSNSpLlWQLXrcJeeNh2KF2KLh+yMhxQG0yk+NHIy2A0OjL1hwrpCGmCrxJCVYxK+j/DCdqDNT6ZfBkXIx4NfTuClhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790974080; c=relaxed/simple;
	bh=h78ifundIeRdkV14anGeuWX1qDS3ZXkYDyv4WmnWAaU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M4fc6TIS9g9PADAOYdqcQIts9vOzvIC3Oo3svBQaMBYZJAMY3ESy6r2Vx4F4zZ6oQR6IjktsMRz4yHNjJ7Ov73T8gxNjh8Cdf5gHdmxy3WrMjE4NhQL8A9ZTjCBcDY7CmPCBWPj9DO2LcQCRowPjPVhDJFtzDYu/pFj9+z9iC1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D5/h34uz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c4i+pLpN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D5/h34uz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c4i+pLpN"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692Ebe1B4070641;
	Fri, 2 Oct 2026 20:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UQyEM+OVFCPpnbUlJZOeSNQlN/rVrlvrdGTY0gwGxvs=; b=
	D5/h34uzt3gc2+9vEV0HahLovoX7TaNqzb/1TybDwHZRtF4fo7duFQt9FvVsHzBW
	UKF2Lb5kUPbfvHDiYrzMI47BRtaRAfsGNOfNHVnvjxbdXFroYlmyhULAkUQ0tQzM
	KzFExOVKXxwaDZz3RejjIEVDcrQF5M9b9iODMfFvBa97aE4h9R2dPCm/Fu9AP1vV
	WevBP6LAMlTqHtvGP6ieGNcd3F0rlPT1uSbENqTMWhdP7u6sct3aA9exZH+Myqpd
	6vio1w6d2WDhajlf/yO064Fr+wWJhVxPXF998xCV8j+OTz2Lqa0hgbQOmhHCZIeJ
	F+hSdTfZKWAlVm6QuashqQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4y9mscw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 20:47:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692KZOb7021923;
	Fri, 2 Oct 2026 20:47:37 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013030.outbound.protection.outlook.com [40.107.201.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gubyhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 20:47:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zK7cjHARn0mu7NVPV4CytmBnvs029x/ns1/laBjmYoCR2HAm7CPu1J8nAZsHT7K35RyCHdbXHSTu0hezyA1mih/6hTuMrH99y3VPQyn8GeX6Hvgt0hRSwhbBGx1djuy0GwECW6oN7TwvRZn692GAj/epXf52pPP4ZMbUo0pvG96fGHqeUETA44Jk5ZjQCHfmcGdnQJkR01x1CHs6S3VqOyDVlGcZsqeRMUftT34HPpi6ryz0KgEGU4O37JX9ktRpPExDBdjbzg/sbIXQFnKYjHraXfA3pGWp4zu0Wxe78Bk4hZ5T+YL74xM2Wm37laWyxo7CpAGvlCChJkjY0/ZiMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQyEM+OVFCPpnbUlJZOeSNQlN/rVrlvrdGTY0gwGxvs=;
 b=F2acFhnA3DhNOO/+zfrn2HRvFKaUXuPvtU6/s7k3ip2WpVf1+e3+pT0KPdKV/akhVelT5XJiBAbOcMku+eRw8WIPgRsWjKISCkzOaFC9vzM0JYqLq+s0tPimlHK3WFlE8IpD+2y7Nt0kLsyLfal2LOaYcp0zv3GKF5ti8s8CIZI/X6b0t7FDSN03svJW7vDQjgG7tQZocBZqMV7/993vzOTKFtBF8IAhILnQJKJjzNeNNAuqdDux1ncnYawMs4W1NQJODdunQ84OzJyJEYSVOBAqykAW3QN1IxruePJi4B9OaQMAgT/axIgip15p3xygKYbZzooknhy5dKVhROc4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQyEM+OVFCPpnbUlJZOeSNQlN/rVrlvrdGTY0gwGxvs=;
 b=c4i+pLpNpa3UZc3WTXNYeRCqK90s1NaDjcfF3T3LcKPqgZibkOHbI7iQjgprj3bmPTxtj0O2PIAOFBqaTsMdUeML37UISGKkEESKqYlwLzZUHVwpbGHn3vIheHRhWlNOhc4MndxMN6cxoRAEkbuO0FuFb8mNIHZxut1+yjQPyuw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ0PR10MB4509.namprd10.prod.outlook.com (2603:10b6:a03:2d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.13; Fri, 2 Oct
 2026 20:47:34 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 20:47:34 +0000
Message-ID: <a10d4dae-c416-4ae1-8b63-4b7104c5dfe8@oracle.com>
Date: Sat, 3 Oct 2026 02:17:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 341/877] fs: avoid repeated scans in evict_inodes()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Julian Sun <sunjunchao@bytedance.com>, Jan Kara <jack@suse.cz>,
        "Christian Brauner (Amutable)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152422.027976780@linuxfoundation.org>
 <0fee0444-1e42-4b1f-b7ac-234b5e19bb43@oracle.com>
 <2026100223-idealist-eatery-53bc@gregkh>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <2026100223-idealist-eatery-53bc@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0010.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ0PR10MB4509:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a22e514-ae6c-4832-7fa8-08df20c662a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|5023799004|56012099006|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9btvG6LjT1DTvqYb1UeJSMIoEmIXjnTWov7pYpGykd49ZbFT/gQyL5Za/UobO8KYWteUZLmnCQXGqzQgkIj5DFiTf1o3HxOchO6GqsI3SAPwHzZ5Vq6kuF/9afEmtWDxXO+bnN2lhw5YQ0uhUvbvv8VOgw9/ZzT7aWjXw0X3wLAguothWccQHo9a66V0adgks5HTEWdRdMwHrKZtxAx2+9C8xPwD2KIKr6OAmDa9xyuR86EuTOkXj7IksBVy7MFApcojWZS2jGFInu6FHY3ONWz8Dk6/0xT6nuJTgU+uBOimVYNjGBvy5BpnxZo3jthK679DAVVU7mAuSSw79Agvb0p1uSJ2mQIKd6jYWSwj2iGqCAG+mPAEy6zUxstNcYX/yRfZnRsvA8ua3+ix/ZcT/3CHLi7oFSKXUcOcQC/DImFcz+o2ELDuELeHURW9e77OHc2FdsuV67HCHklS3jdUjZ8wsreN0ol84belm8UE1IEmwrWvSQ/eVCWcrD8tNGlIeYfvxaIzquQ9bGlCA//b0aqHZhhxrZwRdR0oFj92Lz/a6FUefFKs4WZUQ/eOZUUXXkJk+yQwa3qe4q+4bT7vO8Ls71Znoxm1Aa33z+eqc4rk+c9CwsnHdB8zzyhdF+RBlJn2wT024WGCLoYjsA8+IvZs1qRNa9nbYEo/3aetUjs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(5023799004)(56012099006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXlUN3hBazFzbDE3ZFAzNnJ6Z1BZUVRDWDl0U2gzYUNtVUVRSkwxeXArcTNu?=
 =?utf-8?B?RUFDTmxNUkZoRERKS0pSeEtjYkM3MUF3ZUVtNkcyTWhUZ29zMEEvbTdYZVBt?=
 =?utf-8?B?Smt1TmJWVHp3NUxwcTlxNlNja2NKY2poTDlaSXlTQnIveDRXZ0l4aVhHaE9x?=
 =?utf-8?B?dkxvbThtT2xOWkd3ZGFWMm41bzBVem9Fc0hXWXdHR00wSEdBc1MxZjFBLzd5?=
 =?utf-8?B?a1Q5bXNWTVZCdzN4K1BIdHB4NmljOUl0N0tEZnJBQkxsczlFbG4yU2lOK09u?=
 =?utf-8?B?K3R1TlRuM1ZrTHBGeTQ5MUJaaENDcU41N2xtMmE1V2I0NEdUQ0tpbXFJR0xB?=
 =?utf-8?B?VjFYNmk1Nnpja3gvbFA0d1cyODZRWVE0K0JWMWswdEw1UmswZFM5cXV4bExG?=
 =?utf-8?B?MEU4YitpNXlwOWcxVHprNW1LL3M1cFB1R0FvcTZPOWx5NGxCd3RJWFl1S2Za?=
 =?utf-8?B?SlUyVzJJa1Z5VmZTdjU0Y25COXZrd05iUE03MUV0L0ZwTFpVZ041bXk2ZHk5?=
 =?utf-8?B?VzBpcFJndklINnBobnZXOG9DeDRRbER1Z2JweEFYQ2lzZWwyT2s0QWJZV1pr?=
 =?utf-8?B?U1pTbmVDRUZXSk9lOVhrelIvR09hY2FUMThjTE1ZMWxXdFJtMGJPbzNVS3RS?=
 =?utf-8?B?MWZPSkhISWlpejdLMDNkWGFacnViWEhzMXBWbXIxT2M2TkoxVGNLUm1ZM1Jq?=
 =?utf-8?B?RlAwL3hFNHRCNjdEbVZSeDJ1NEFuL3REdTVtdVYzRmhkc3h4aTh1ajd4Z1NW?=
 =?utf-8?B?cnNsV2E2cTQrcWhtNnV5UG93cTI2ZEV1LzZtczhjWWtnejRVTWs1QWN5Nk5N?=
 =?utf-8?B?R0ttR0RwemNtUEJxalllZTdBcG4walplbU1MWXJ2QU5MQlJGRzl1SC9iS3BY?=
 =?utf-8?B?T2RxM2tyWEpneHpGWkN4THpJN3dwa0hhdTRWVFJnam9mV29UcFFRNDMxUzBN?=
 =?utf-8?B?M3hxbDJFTmdDTUZ0WVp3dFN2R3cvTnhmZklxQlV5Qk5pbUphOE9lVk5jbWxo?=
 =?utf-8?B?aEpKV3hQWUQ4VXZEUHNId0NXbEdYN0dWT2EzSVZkYnMxL1NKZEhNMjFUYXpo?=
 =?utf-8?B?c2kvdG9nOWpiR29RbndJbFU4QjBHY0w3T1BFOE5sZVY4bituMUtlZ2lGTzVw?=
 =?utf-8?B?THBRWGRYTElFM1VZVndjTmUzWUxMaXZrUVVZRVdCbENCd1ViazZZZHNRTkp1?=
 =?utf-8?B?NE5qNUxpL3lNUjIyTENWOXNST0pZc1c3VE5CalJTek1zZHdWMSs0TzZRL0JJ?=
 =?utf-8?B?NWYzTzA5T3RKL056WEc5M1NLRzNRM0NnTk5LZkNSc2xmUnlZbDZuODhWbjEr?=
 =?utf-8?B?TUhiYUxGMDFxRlkyS29WOHpIdzRKZzRjRmlCd0pldzhJWEVuc3p6WjJaQm0v?=
 =?utf-8?B?czJuRG9JQWJqNTNyRUJwdTAwWnNlVDZpaUJsNDZ6MTkxVk5nd2t0ZFB3cE5t?=
 =?utf-8?B?YTVycHlHZDVWKzdXTzNZNlhuK0FJcWJpaEpxVmVNdkhHL2Zlb2xFWHZYdFYw?=
 =?utf-8?B?N285YnJRanAzZlJDTlRVNmxOOTRtR0dRYjAwSG5lT1E0TWdJSThEWkVrKytJ?=
 =?utf-8?B?a0ptZm5PdmxWSG5vTFVNa0VMYTFEeEVrZXQrZnM2R25BV2FmczhhRzQxNVRp?=
 =?utf-8?B?L09tdjQ5RmpQOGtvQjdhNzlOVXFXL3MxL2Npa2xJYlNLNmFWd2N4UzJwdFJJ?=
 =?utf-8?B?NldDZWxDU2tqdEhFdHA2b21Cb2lpMktPVFFLVk05SmQwa0I5WDlCckVEaU9r?=
 =?utf-8?B?dW1GSWdmY0xPVFdlUzdNVEJmTmJUZVV0cGM0MzBZaTRudWhkR0lQRkVaYnhi?=
 =?utf-8?B?OUQyODhkcVhnVWhNMUZzeTVvWDhaRmdaSTYrVEd3bGtzYkNWQ1NybnJlaDdE?=
 =?utf-8?B?cm5xNHJuS1czM3ExRWlyazhzNStsN0g3bEd3V0duNUI4R2txMVFJTHBLSGJy?=
 =?utf-8?B?OVNqbndjd1d2WjU3aUxnUUZQYjU2cW1vcXF2RmxMUlVmY0RHR1Z6VFlzRGUw?=
 =?utf-8?B?eitVSy9SSGkxL24xUHEzR25xbGxaRFFCT2tmRERBODAvUHFBUFovdFJ3K0Zh?=
 =?utf-8?B?Y1ZLWDZoTmx6WHJxdmtWWmpHSVBsL3l0WWp1VGpxb0dhM0tMK2ZBT2ZVZjcz?=
 =?utf-8?B?b0lydCtoZmdwTndkZHFlQjh1NXB3dGNrN3dFWm9UMjBnZ1hqcWlXTUhhc1pw?=
 =?utf-8?B?RXhXTE9IVS9xaFV0YlowZS9jb2Y2Z1JyTCtsTkc0a3RkRlRycE93QWd0QmRS?=
 =?utf-8?B?VU0xbm5LcGlvUnZobXMyRkgxMmFCTUV0VlBpa2RSdUxkOXorVytHS1kxc2VO?=
 =?utf-8?B?Y0xKdDg3MDlVd1haYWRVTzdoQ0paWFd2SG5GalRncGFxbnBRdGJZaFJYek9P?=
 =?utf-8?Q?x2breeQM9LLombJUWzBbC3L0QIP2YfhiPZm+p?=
X-Exchange-RoutingPolicyChecked:
	rCkU3LKFUKvex/ALTb+kM9YllW7fAUV0CySd6jLcTbh64WdN0HPUVxDo/emDjU8Qg+EfoYc3p3N7tSATeqX9WwdpQWjdqIoBbFNeg2l8aduKNUAuwzGvcugYl0xda5Q0O2e+sTgkwYagkANnU179srNliD03Of2BNbO7bTB39hv8u3HeOxBzLg+x8hD66ISbCQbJbazFNanowpQga7mT0FUb3egp99Y35nzpHPOHVAeH+GzpJoVSM5xfj/W957C1DxMxmKb/hV7p3hAN8JEETG37eNsQnlbVvzfkb9qAInDIIQUKUzUnZgDOXl8kFZ2jl7IZ9SAVgtBFLVqqNc/jxQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ar4M5CCPMM9MymGLKd2/MQkBNt7BiLqRoPOJmIZ/kygqXe7LeWFfVZ5m6qBphpJGPbvm5coQ6Ga8yAT6n+HxGB7geOyqT1iqFkbr5eB9pxrQLkV6jjjL8EuMVa1YmA4O1/brOQN/sp4jS752b+GiTm9+XkvuUCfhaQtmLaEmsWX5Rfy7V1ntkOSAisATsKEDGrOKQM5T7OVP5ayF6pf6Bo83MqND42EyxhZhr0MI9EyWmv9txwGaXYrj0Pi27OVG5k2mqlGJsPSg2ZUoSW+dO0jSntWT5nZ4YBjrRxX3nVLNUzqPjVdVczYozdpaW2qd59yoV/pbRGMLi5hxRt949cdiK+TJqINPdTC98/riyDLHosGh+RN/04BQbNwzAT1Ij9zuDWX+rPvVmVbUOs+F+oga3Ivicw8TFgOsDNwF4OReuf+SBfK17bC9yO0KMvyKOxC/UyvcUGBRPhBDUkdXwr1csZ1NLXNx+D6l5kLMGDOH1FR5nWXyS3qUmSw/hYbHSsMoeGK3kfu6IJAM3JM6y/+Jg9w+VA+AUIVG0KfffMJVDYFlBkkTQO1RGguHOzhBxGb2/dgGqkCz45pOZUitTir1TTOuyYvaXbboHHyQBJs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a22e514-ae6c-4832-7fa8-08df20c662a0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 20:47:34.2327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SapbeucN+dhtNwvUTz0yHgX3F8SWqljv/yrTwd2bjGYWmzfQYTMpWux9DtTUSF/t3N6q0sLxriAm0XwYIiIlYdmIUuIetOabqAWXHQP22CmsBNOes+DPtTewrgR/NO/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4509
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxlogscore=969 lowpriorityscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020082
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4MiBTYWx0ZWRfX6TxLItWH/V7e
 g6NSDu/VNpjqoDixuNd9JYG20aPgjuvT/gQ6+VU8xeBjiqEW9o5g33VGZHfsQutNW1rwgzuJM0Q
 UYM42e9xf8MhZWIZkklDuBGUZUXfT8ifsxij2Gam56ZwOh3QLQAi7gyLrnT0JdFPqWu3sQl3jEq
 FpweD9ssXE7UzIRjpFguWcCtsIg391trzSwzyIWNCZd54CKIuZy4/o0/BrVc/K9YfpTzB7xzWLa
 N8C+6ecves3iBY/sQ4cHCC7n9FkDAPREUKwPgUJLZa5hZ7qIA4F+lFbMdtU4NNKBwx9LXS1mmYj
 ywEEIEO35LverZ8BknFD/cStMWd/Lg9PsKsp/e8TFhqdtUyWbXth66hb32Yvd983gRejrKw4VC7
 BZkBAJAvqT3S0kAMTbNZnirBuE4ewC4zLx8oF/1Ql9KaUI1bbPiocDPEfly76HVOwsd53ZaD9ta
 81mcKvPICkDy0lRTwISE00/bKaeNNz7q/qzonABY=
X-Proofpoint-GUID: aSI5ZtNMh8dcUVE4Cw7PMClLmrpIngRi
X-Proofpoint-ORIG-GUID: aSI5ZtNMh8dcUVE4Cw7PMClLmrpIngRi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4MiBTYWx0ZWRfX5yAxnbOg3z1R
 yNd0ztZ0FcVg0yUJq+yERNm/LAayvFINqj7tU6QLBkrSbL3MaJ7QH71QIa6X2FO5kiFOaKiPSG5
 9lbPR9gLlVlxzkgg+lBCH9zfAGietQbL042olY5PrN3vEh3RF5sp
X-Authority-Analysis: v=2.4 cv=IuyL47/g c=1 sm=1 tr=0 ts=6ac0186b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=ZE9D-lmXlzKIYpEy-2MA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107

Hi Greg,

>> 
>> Hi Greg/Sasha,
>> 
>> An AI assisted backport review flagged this, and I checked the upstream
>> code against the 6.12.y tip f4ffa8dc360b.
>> 
>> Upstream 7459c0218742 uses the current inode's successor after
>> relocking:
>> 
>>     struct inode *inode;
>>     LIST_HEAD(dispose);
>> 
>>     spin_lock(&sb->s_inode_list_lock);
>>     list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>>         /* ... intervening source omitted ... */
>>         if (need_resched()) {
>>             spin_unlock(&sb->s_inode_list_lock);
>>             cond_resched();
>>             dispose_list(&dispose);
>>             spin_lock(&sb->s_inode_list_lock);
>>         }
>>         list_add(&inode->i_lru, &dispose);
>> 
>> 6.12.y retains the cached-successor iterator:
>> 
>>     struct inode *inode, *next;
>>     LIST_HEAD(dispose);
>> 
>>     spin_lock(&sb->s_inode_list_lock);
>>     list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
>>         /* ... intervening source omitted ... */
>>         if (need_resched()) {
>>             spin_unlock(&sb->s_inode_list_lock);
>>             cond_resched();
>>             dispose_list(&dispose);
>>             spin_lock(&sb->s_inode_list_lock);
>>         }
>>         list_add(&inode->i_lru, &dispose);
>> 
>> I_FREEING protects inode, but the safe iterator's cached next can be
>> detached or freed while the lock is dropped.  The 6.12's invalidate_inodes()
>> differs from upstream's disk-removal trigger.
>> 
>> I think 6.12.y needs the two-line iterator change from
>> 3bc4e4410830d556b0f40dfa6671bfcaeacc1599 ("vfs: Remove unnecessary
>> list_for_each_entry_safe() from evict_inodes()") before this backport,
>> thoughts?
> 
> If it's needed, it needs to be backported here and to older stable
> kernels, and it needs a manual backport as it doesn't apply cleanly.
> 

Please drop this stable backport.

They retain:

	list_for_each_entry_safe(inode, next, &sb->s_inodes,
                                    i_sb_list) {
              ...
              spin_unlock(&sb->s_inode_list_lock);
              dispose_list(&dispose);
              spin_lock(&sb->s_inode_list_lock);
         }

The safe iterator cached next before the unlock. A concurrent final
iput() can remove and free next while the lock is dropped. The loop
then dereferences that freed inode:

        inode = next;
        next = list_next_entry(next, i_sb_list);

I_FREEING protects only inode, not next. This creates a use-after-free 
risk that can cause a crash or memory corruption.

3bc4e4410830 changes the walk to:

           list_for_each_entry(inode, &sb->s_inodes, i_sb_list)

This reads inode's updated successor after relocking. So until we take 
both the backport and its prereq together I think we better drop this.

thanks,
Harshit

> thanks,
> 
> greg k-h
> 
