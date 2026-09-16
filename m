Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A0D39A078
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547915; cv=fail; b=qi4GFq8Pf9wVSas272xQEPBmV+GrfaHDbi0hYlNtK+SvTCe7K4hBjqpi4CqVeK2hqYNNLablWPGzcZ+Jw2vxVm9kEHeiriQAgUmvKp6qBq1X0huAUl+y/HJ5Gaze5ci/RZZODxnyvV1EDo4iUzjVibSmoqnZNtksa1wU9NESEHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547915; c=relaxed/simple;
	bh=1b7hMk3mE9NkIOwe74M8d5ge9CLqD9nW6+Ahbp5Il4g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ocKdWyWL6tFZDxZEmNwZxZoDGSEfM5YfAg7CQtzQAdPgcEjY3d9GKH68reRRp8PRJ0yS9FvP5Z4L08QLbQQqiRP+cn2HalrCg4kWEPb7cwFzk8qTtVZezSc6o1DhUm547Pkmyr0DvWsxXk4ADB/Bg4JUMkKMUQhwdNJVhdrggEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A0MLNtD5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YxUDwKP2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A0MLNtD5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YxUDwKP2"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWcgM622931;
	Wed, 16 Sep 2026 08:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KRPYQcNVocEpp76CpeLirrh57MPY5yuu4pve/QVu16s=; b=
	A0MLNtD5UJW2YJFtbn7bZhVQLz6WnR0I8RRrj3DsDVzrKge0MrqC2IZUsyYfndO8
	IlafVxxTLVJpP639of27BDwBuNpiwkzKt7VWqmaJzqKfysa1fldYU7fISZjVXGWU
	Hj2+OBHhsWdvu140SWG5ykt1n2SEnzjrFdHZtz6FaZBi1VO/y6vviLSOmyGSCzUC
	W3H49tU528D5muBaw8vDaN72elcSSYwzgX7MNqcz7eZevwjtkD3d0NNNyXXezOCv
	Mvu8SPdkl2FRTipxPAqFfObkrgULjAUye3Hyt+XmtdlbQJ5xyefXyM/arosNEYrm
	VrWWw7TgGQi+cBELjA5Y+g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwh1n6vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:38:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8ZQ53036460;
	Wed, 16 Sep 2026 08:38:29 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q3j15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:38:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jyaIAgNRDwwK//via7vXsSwsI2Ol+p55IlKjcN9lGwN/26o1J4bLQiAoV0K03v1TWiNf/5PvcG3gP88uW7KmhwrpMwRftnwyfAIYbEa5NZeNARCKkaAR77zTR8H0kIbFCLPuJ8iL1HRt8lE4SFADQHXQg1b32EJDuv0L1ESD0f+0CGxDbFpbpcXeslRUd11bA8pJw4t76sHtxqpTbYgT4PBdafLSPOFXOMokj339Z9TNBk9Sst6tJb3Z3FiMA8+rJjL4EJuvusgWwKDk8BaZ0mG2Uo+j3M1P6Oh7vgSYOUPmKBFl6rHwfVl/7iirYyfz5gTq4kxmn8fnVWqCn/6I4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRPYQcNVocEpp76CpeLirrh57MPY5yuu4pve/QVu16s=;
 b=Nbv8WignUr8lghF1bZjMS1yD5S8SvW920F7cZLvHHaEL48zcPsoMZAZVji/DO+0s2vyj1a2qdWa2pHpNANehjzP0Dv4BkaY2Z45hXhgh/4UuhYImz0piyaWkqzJgnEVRiV0mpXYgapFQLmNAu+dbjxZM+YqHr0kNabz2ZqRYb0+euW0m3mQPR0Opkag1Q5owqHQ1UO5XFyNF3rXgx4a4+QQw+JnH00qRIbkiE3WhMduPVQbbI+RhPe0m/A5Y/ONQ0JtLAofE1IOw9/4n9VN8aIxNccbzMSVzHkz9c6Zyu6Ny+nqoIW/98QTb6qfyRglFXxubiJ4/H/S8VRarxUO6CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRPYQcNVocEpp76CpeLirrh57MPY5yuu4pve/QVu16s=;
 b=YxUDwKP2Q8Mn2voijd4YkMmzFNysbwGiSnERrietFLFKtOT2fDIxooRBV8Y6UlLL913VxDOW1kA6/Ds3P+Ij/kwjuldk1bwi2Bowt9WhNNw7bz1c1VfSch4Hk0rNqIg+O5Zd1X4ulOhcYgvAdFiFoCADF/x6LvZEM6TLcWCJxjw=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CO1PR10MB4675.namprd10.prod.outlook.com (2603:10b6:303:93::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 08:38:27 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:38:26 +0000
Message-ID: <9e6e50aa-4ddb-408e-b138-c829af813bcb@oracle.com>
Date: Wed, 16 Sep 2026 14:08:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1160/1376] hwmon: (emc1403) Rely on subsystem locking
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065633.406209587@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065633.406209587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0327.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::10) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CO1PR10MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c254a83-cdf4-4577-1b52-08df13cde08a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|4143699003|6133799003|22082099003|56012099006|5023799004|18002099003;
X-Microsoft-Antispam-Message-Info:
	O9tzZzvZiZslK1BOgucdJ0+ShFqsLLTidK9VNNR85ARPWQvshYbkdg1oYUc1SiOMQw5LP5LdfeYGGHFGstF1wMUL62Ft8Bs912p4tpuwE5xz2JLiu6XyNa+tu+nX3GZ7Mr006sI+KZv+WfoN2CZ5mM/HQO7kW1rUlO2oT22NMQ1s/aTcsPQPn1sECk+LC/DoRyKNb77tkEwqX7jieVfGboejiI9bv8v8w6hL8kLGmHl6EUslHmBgpmPEfu/crcc7RP5nAz9CTx6P7DSmqFx5snXAUrnu1IlBHzdS2KuI9joKiYfKXXFCp0P3RYFRjMXic4CQt9OPmg7Xqu5y0fBwBkl8idf/UUk2czIyPo/eTtIolIYxEYAjY9m9IsYlUYn9UIo3nUAfee7CcTBmcY8hH1jVdLFzPfVpPN9pkJ6+rVb2eluXny+/qeyJWeqgUaYpX5fQOj5uAMxdjwbpj6TOO7WH9FErmCYZWY9aSuiyIrUcXf5XSE94cm+XMAOQqYDHGR/ID4zublyy4aesWxU7buSi6kYwnJdbfWF/FJ51L4EgTEGhRC79qY9E19l/BJ5MBtrVSE+FkwwkAQFYE8/d6hDLUEOvdWXen2Pp9i6vwsY/LvCF2nmX9UlLYctOmvc88H0G5yiEsBjkqh4A2DBmbRwHeslS6wrSeF9i3JMKit0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(4143699003)(6133799003)(22082099003)(56012099006)(5023799004)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MW5reDJTUUpWRUVoZnB6eHFHWU0vcEE3eS9XS004Yy94Ny92REgvb0ZiTHBT?=
 =?utf-8?B?NElyUXFPcm1pWWtxQU5lYjR4elZhOG9FOUEzQlcrdlVtYjhMdi81SDJNQjNa?=
 =?utf-8?B?dHpzcjRkMGVueG9SM3A3ck5vbVhjWnBQN291YlUyQWdrK2Rab2MySENpdTFL?=
 =?utf-8?B?bWhjWWd2VlpHa2FOdmkxWXJMeit0bXJibnBrbXhpYTh6TnBWNUJ2WVJxdnVI?=
 =?utf-8?B?UFB4ZkJvWGtpTXJmRVVmVmpZYjJxNWd4aVJxbGRzMHR6ZGM0aEo4MGFkWWNE?=
 =?utf-8?B?YXo2V050US9kLzZDSXdMOWdoVFZ0d3A1ZlJhQTBEMHVYRDVOeW5UQXpLRTQ4?=
 =?utf-8?B?RGJxSzQxQzNiSVZvK0JvamRvL3dHbVpyc0hST2ViNkFQUDQ4TUZLRFlsdm16?=
 =?utf-8?B?SVhDU3FFKzB4UFdMS2o4dHI4ZmdkeXViQ1NWSjdTZ0pHa0N3VGhFMjVzSXR1?=
 =?utf-8?B?Z0g3TVVIK0RsdWpzZGVrTWxKUjlQYmtVQml6T21QZVFmUjBlT0xiZk1sL3hm?=
 =?utf-8?B?U2VVbGVnMjZTa3BKM1N5clYrNVJEcENLaXFoRXd0OFNwSXR2Z2VVWGlWVjJh?=
 =?utf-8?B?QU5Fby9uTFV2N3Joa3JFTGQ0MEQzVzVlQ0FzV2VOUytza2pERGRNaCtCSnUv?=
 =?utf-8?B?N0NDUEg1QmdlMDJobytrY3NWa2pmZ25rTnhSMkFNS2l6NjB4WGFvdC9HRkI4?=
 =?utf-8?B?aUx4WmtJeDU2bFRLZXUwOUQzb0FkbWIxNUtjcVVpUVRZNVhZQ1lUQkxQRmZn?=
 =?utf-8?B?aDNzZjF1dTlFVDRHdHFGYlc2c21GWW9CNUVqbkI5NkhTZnAxeC81bWM1ZUZG?=
 =?utf-8?B?SGt3aUxFaitoZWJEYnVLTndHd1ZsSmEvdVRvUWNYQWM0dlBNTXE1N2JXMkFm?=
 =?utf-8?B?eHI2WlJmUHd4NVlwNDhRVGNwOTJxaTZzemo2VkkyQWFOaGxmUS9YbFA4aXVp?=
 =?utf-8?B?WWxTTEVEaDMxMVBjKzloeDBEVGtYR050ZnR3U2VjRVp5ZTdqdE82VmZ6bGc4?=
 =?utf-8?B?SERnR0wvdExGVkU5a2hWajBLM0lnV0FWTHE1ZHJKNWVDR0dGT1hObnRxTmI2?=
 =?utf-8?B?cTJXSFR2ajVzVVZSVWRMdktPb3VsZXZiUVo5cHlteWFDQ2FEbmthSkZveU5i?=
 =?utf-8?B?VXhac0Z6K0ptMngzK1F3V25CSlJpZVZydWtqZ25xUVc4U1Y1ZEF2UUl2VUFy?=
 =?utf-8?B?MVJaRjVKSWxsZVNqTkN2RFpRNjNsdkZtT1dFTHlqeFFNdzcyNHhpaU8vTTU2?=
 =?utf-8?B?SHdGakNvVzBMVzB0QnNRRFdpZks3dzFJUDMzNHRtbnNYZmF4VmZldFplNkpS?=
 =?utf-8?B?cm1YUC9KSnNNQmdFUGtNaHVDVzV5QXNpUWg5NHc4cG9UUlkvbWhYdWFuTHRm?=
 =?utf-8?B?Q0hETEx1QnlhbDErMGI4dzAvVjg0K3NmV0NjZEhPd0RRNFVGVjJVUGRkdUVY?=
 =?utf-8?B?eHNmdVFUN2g3SERNcjVmUDhKUVpsYk5ydW1ZU1hQd2c4Z2oxZGI2SlNtYVJM?=
 =?utf-8?B?NTZkRFpEd1d6U2pxK2V3UWJDZGJtd1VUd2U2YkNRSWhkZ3daQUVqeU95NnEr?=
 =?utf-8?B?c0RjQldxRHpMbFdNMUh4YnVZTkdRQnVnMy9Pekt3ZlBCZ2RQTVNMWTUyRVpy?=
 =?utf-8?B?anpNZ1l0WmRBQndVbTRIdWZUVkNSdEtZa1g5YzF1N1NkSTVXNnpXKzBac0dl?=
 =?utf-8?B?OG51VmV6aVpyMkhFdVlZWit6MStTZFBPOFJtbFp1MUhaUE1vM2FMako1VENC?=
 =?utf-8?B?Uk03Z1JZMno1RFdLSmVTMzhTK0VvL3RTdU5kOFkzUktmRUlQQkdPYk81K1Q4?=
 =?utf-8?B?V2FqSndBelNtVHp6SHdjOUVOeEt6NTlWN3V5Ti9qUktRU0laT2c0R2UzTVo1?=
 =?utf-8?B?elpBSjJlaEMvVDJGR2xqRE10QXhqM0xxV0NhN2NnM0Y1Q3JUMEtFcE4wb2U4?=
 =?utf-8?B?Zi9uV3FLWW9OWkxRVk4yMUJFQ0JxQ1A2Z0cwU1NwNysxT3ZVZGNGN3pMU243?=
 =?utf-8?B?MlZpOHNyOVVabFZ6NE9CamhBaHB3Zm5mOUZYWk5LVkRvak55SENyNmNYL0ZW?=
 =?utf-8?B?OUd1d0tOZkN1YlVzcFVuSmJaMHZlZHBNbXQxbkRVZkJzdmVCVHF6dmpEenA0?=
 =?utf-8?B?UVBjTmE3WUhHK2llbUR6SkJUSFhBVjJ0SlJlK3pRTE1jZzgvNldldjBXRlRn?=
 =?utf-8?B?TUhaUjZPajFpOW1jS0QvQ2tLekVpaU4xU0pHU3h1cjQyTWdhL2pSU3VWeFll?=
 =?utf-8?B?MnJnZjNxNXhJZ0lFTTJyc1lPNGlYZ3ZqQjlXZTF6U0k2RE8rRTdFWnpzcFMw?=
 =?utf-8?B?R09rbkhxdFRLQTREZHV2ajJSMEhPeC9PS1N3OWtuSG8zTjU3Wmo2UklWVkJE?=
 =?utf-8?Q?DojCuOluFqLhCJk0qXEx/B7r2jvFaE8J+hRNE?=
X-Exchange-RoutingPolicyChecked:
	ASqe35i4R18Dr7D5/Th9t2RJSj90pcM3p3S93FwgLPuoK5AGP1jwedwFMq3bytxg8dM77wq3Not5wKvJZY797/E6itslzhEYE9ljtR2zbgNukn0JoSuAenzuRSYvG6TEO/Gvy/Xpyr3re75uz+G+xrE+He8uhGun+4uf/aUMScrvnlKj2MBJUtolULeVaRQA40lsYB0Lx6lKNizvztvnTAZVkx24AzIx3kTwAy0GI7p8SXIZ9lT56nBMJCO1XBCpZjGMIztniwyADrlu+iYlH4b64GcSiF+bMPbsfxD6N+bmNYs/A9qACJ56ci1xuR9iVn8CtoBRAwx1nJ737DYfnw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rp4r3skLPqJDtufuNmyxI3uOAyv+iAQtgIKzy91m2f7D54IQJeq1eJSnEUHVOyEppCj/N5v87EWlgbc5FZ0UsiTOGDAAQM9XRNxaFJX4Rqd4vYjf4Op/rmpU8sTAIbc2OeK3GK5f3A1JKk7v4M6ArQPxwD+CtW/xmv6ElNDSmxKWBYcGYlMZ2E66zuMX5lNh6vrsKEdd3eMQckFoZSYMu+nO5pPEypuHMGrjY69tUHJDYwh4nlaTEm/JeCfpgjMppPUEhHD/3MbC9XssfvzCNGN5MhKZkWeCiZs4E0S5s9upS63rUTp7ndSVKnSWcS2XuplHulWxXG5S89YigCTDao0RYkPl+a6Ykbiaph23zIwe4TvkpimMGDZ4yx28DuZSNgLPUbAEPlhLxPK+xMJ8PqA3KiGcZkzEE21Y7UC2vart4HgD6tZE6glhJ9Th7az7yasxQYZc8zHvkItx5saDAAhtLEbZprfdNtzJ3w6tj4+8OkIpQWBYzba4gbi3LDCJ8ouDcTXS1VZMYuKpiVSb2jZtc53oFfya/mWJWRXw/79mTMaaylOW9mpB7cn+JXDqP3Fn1f7geL4a3baQUiZPEewaJdLMY9E4ii3fuUjGiDE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c254a83-cdf4-4577-1b52-08df13cde08a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:38:26.8602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3Rc07FCcpIO4LoMzWhje8FQQ0z/F2AWSmkBLbYMONY6YxnpIEN9qO+HBh/M5oSNpTdcAV3GC78kgh9O6PPPzEegyFqYH3pLE1L69Y5xPtKCBAS/oJXk3AWJ9zgZP9An
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX970lJVXnwc5+
 9PI8mNKb64FBUDWW5wTocYrIuUSxHNHId3nd7+seEEyCbEB7B35BybgB7kIjC9NaktnL6Y+EL94
 +x/z3LW/bx/qsZOwI6n9a20gt4rY9hqwJmvcXtdJIbfWcL1//xJ94UBZ/k3Sku5i/PUsTzBe7Qk
 6zoAiNdeOdQOziVGz+fdI6CAEam2Q8NmF1nlR8X0HdX6bY4N6G4r/XoaX1K1hxo7947nlucbedb
 aqB1bvL45D8uqU4QMQKGmqsj8QZP+R+aHaDJ4H0g1qDds0wtPdxCN3zKvHzg7jWMnRig6sKbrM2
 pQjTJzB2zV6x2FOCdBEysWnds1jwKEhLldzKkvf7IHDt8bDrex5ZUcZMIkfF7FHfkqPaPXNtdpb
 3jKIWRpdbT5CCd2odh+GczSvvz9e4R19hGOOD38mVuikgGGpT2FD+WOTLseRzbAe7DAjLsxIJvI
 3/eSmVsH3sLdKyKIZmUMoCJRFprKExLS2g61BWI4=
X-Proofpoint-ORIG-GUID: sFuhxlti9DAta8NiAqJUm6nr0r6qOtEw
X-Proofpoint-GUID: sFuhxlti9DAta8NiAqJUm6nr0r6qOtEw
X-Authority-Analysis: v=2.4 cv=HPhWhYtv c=1 sm=1 tr=0 ts=6aaa5586 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=_jlGtV7tAAAA:8
 a=VwQbUJbxAAAA:8 a=bQl80SbKOGWWCTY15m0A:9 a=QEXdDO2ut3YA:10
 a=nlm17XC03S6CtCLSeiRr:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX+Sjs6TxA0Ymi
 LSsoTE9YE1wHpeUytIezVvdCsa87XrfNx9DbZOt8tlffWMbvupJvAUHCCTeHrny+caBUbfNy04u
 Hf8+4riIEWJDVn6CuIR3+hl6vBuiAOy9dFncmkxhFoQ/6AbhrY+t



On 12/09/26 12:29 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Guenter Roeck <linux@roeck-us.net>
> 
> [ Upstream commit 61e9b50ffa2390a2927051d335b2ba04b8f791ce ]
> 
> Attribute access is now serialized in the hardware monitoring core,
> so locking in the driver code is no longer necessary. Drop it.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Stable-dep-of: 75f2c0b36907 ("hwmon: (emc1403) Drop hysteresis for low limit temperature")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

Upstream hwmon core after 3ad2a7b9b15d:

     struct mutex lock;
     guard(mutex)(&hwdev->lock);
     ret = hattr->ops->read(dev, hattr->type, hattr->attr,
                            hattr->index, &val);

Downstream 6.12.y hwmon core:

     ret = hattr->ops->read(dev, hattr->type, hattr->attr,
                            hattr->index, &val);

The downstream core invokes the complete callback without its own lock.

The patch removes the EMC1403 mutex on the premise that hwmon core
serializes callbacks. This 6.12 hwmon core has no such mutex and invokes
read and write operations unlocked. Regmap locking covers only each
individual transfer, not the driver's multi-read or multi-write
transactions, so concurrent callbacks can interleave threshold and
temperature operations.

I think 6.12.y misses 3ad2a7b9b15d5072139a20be84adb36776eb6c9b, "hwmon:
Serialize accesses in hwmon core".


> ---
>   drivers/hwmon/emc1403.c | 46 +++++++++--------------------------------
>   1 file changed, 10 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
> index eca33220d34a0..ccce948a4306e 100644
> --- a/drivers/hwmon/emc1403.c
> +++ b/drivers/hwmon/emc1403.c
> @@ -17,7 +17,6 @@
>   #include <linux/hwmon-sysfs.h>
>   #include <linux/err.h>
>   #include <linux/sysfs.h>
> -#include <linux/mutex.h>
>   #include <linux/regmap.h>
>   #include <linux/util_macros.h>
>   
> @@ -30,7 +29,6 @@ enum emc1403_chip { emc1402, emc1403, emc1404, emc1428 };
>   struct thermal_data {
>   	enum emc1403_chip chip;
>   	struct regmap *regmap;
> -	struct mutex mutex;
>   };
>   
>   static ssize_t power_state_show(struct device *dev, struct device_attribute *attr, char *buf)
> @@ -268,8 +266,8 @@ static s8 emc1403_temp_regs_low[][4] = {
>   	},
>   };
>   
> -static int __emc1403_get_temp(struct thermal_data *data, int channel,
> -			      enum emc1403_reg_map map, long *val)
> +static int emc1403_get_temp(struct thermal_data *data, int channel,
> +			    enum emc1403_reg_map map, long *val)
>   {
>   	unsigned int regvalh;
>   	unsigned int regvall = 0;
> @@ -295,38 +293,23 @@ static int __emc1403_get_temp(struct thermal_data *data, int channel,
>   	return 0;
>   }
>   
> -static int emc1403_get_temp(struct thermal_data *data, int channel,
> -			    enum emc1403_reg_map map, long *val)
> -{
> -	int ret;
> -
> -	mutex_lock(&data->mutex);
> -	ret = __emc1403_get_temp(data, channel, map, val);
> -	mutex_unlock(&data->mutex);
> -
> -	return ret;
> -}
> -
>   static int emc1403_get_hyst(struct thermal_data *data, int channel,
>   			    enum emc1403_reg_map map, long *val)
>   {
>   	int hyst, ret;
>   	long limit;
>   
> -	mutex_lock(&data->mutex);
> -	ret = __emc1403_get_temp(data, channel, map, &limit);
> +	ret = emc1403_get_temp(data, channel, map, &limit);
>   	if (ret < 0)
> -		goto unlock;
> +		return ret;
>   	ret = regmap_read(data->regmap, 0x21, &hyst);
>   	if (ret < 0)
> -		goto unlock;
> +		return ret;
>   	if (map == temp_min)
>   		*val = limit + hyst * 1000;
>   	else
>   		*val = limit - hyst * 1000;
> -unlock:
> -	mutex_unlock(&data->mutex);
> -	return ret;
> +	return 0;
>   }
>   
>   static int emc1403_temp_read(struct thermal_data *data, u32 attr, int channel, long *val)
> @@ -451,20 +434,16 @@ static int emc1403_set_hyst(struct thermal_data *data, long val)
>   	else
>   		val = clamp_val(val, 0, 255000);
>   
> -	mutex_lock(&data->mutex);
> -	ret = __emc1403_get_temp(data, 0, temp_crit, &limit);
> +	ret = emc1403_get_temp(data, 0, temp_crit, &limit);
>   	if (ret < 0)
> -		goto unlock;
> +		return ret;
>   
>   	hyst = limit - val;
>   	if (data->chip == emc1428)
>   		hyst = clamp_val(DIV_ROUND_CLOSEST(hyst, 1000), 0, 127);
>   	else
>   		hyst = clamp_val(DIV_ROUND_CLOSEST(hyst, 1000), 0, 255);
> -	ret = regmap_write(data->regmap, 0x21, hyst);
> -unlock:
> -	mutex_unlock(&data->mutex);
> -	return ret;
> +	return regmap_write(data->regmap, 0x21, hyst);
>   }
>   
>   static int emc1403_set_temp(struct thermal_data *data, int channel,
> @@ -478,7 +457,6 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
>   	regh = emc1403_temp_regs[channel][map];
>   	regl = emc1403_temp_regs_low[channel][map];
>   
> -	mutex_lock(&data->mutex);
>   	if (regl >= 0) {
>   		if (data->chip == emc1428)
>   			val = clamp_val(val, -128000, 127875);
> @@ -487,7 +465,7 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
>   		regval = DIV_ROUND_CLOSEST(val, 125);
>   		ret = regmap_write(data->regmap, regh, (regval >> 3) & 0xff);
>   		if (ret < 0)
> -			goto unlock;
> +			return ret;
>   		ret = regmap_write(data->regmap, regl, (regval & 0x07) << 5);
>   	} else {
>   		if (data->chip == emc1428)
> @@ -497,8 +475,6 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
>   		regval = DIV_ROUND_CLOSEST(val, 1000);
>   		ret = regmap_write(data->regmap, regh, regval);
>   	}
> -unlock:
> -	mutex_unlock(&data->mutex);
>   	return ret;
>   }
>   
> @@ -695,8 +671,6 @@ static int emc1403_probe(struct i2c_client *client)
>   	if (IS_ERR(data->regmap))
>   		return PTR_ERR(data->regmap);
>   
> -	mutex_init(&data->mutex);
> -
>   	hwmon_dev = devm_hwmon_device_register_with_info(&client->dev,
>   							 client->name, data,
>   							 &emc1403_chip_info,

