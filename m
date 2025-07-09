Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BBE274FD1
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 09:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752053227; cv=fail; b=Gx4HLUALxIPIIeBgcEjVD9C0PnWlBcqjBfws2x9k2qsVjam7Fu3DlQbQ0Dflp2oiUAaAMTtuJ2wymQjk7j+deqmHpNCOgLfE/iGOrWz2GZRVCpO+6yVZeXU20VvYnhYPH19q/1qwE93CN9bxmXVnLQOa4bK6npPs+J6Op55yeYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752053227; c=relaxed/simple;
	bh=p7+AmTLNpKcFtjK4yOrGm9d4VV1/kK4bfwdKPywWMD0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nK3cWgt9T69zwBpyOLxXeY0fE+ImTHkxhZfxz9J0Ya8TfAvwlAW4ATH5bPffifmMRx1RwA+OdrCWprZfUGav/jdz2mEWu/YzYEk3/l3AX/1I0lepxzEqkC8rx8s3i7ucVHlT1yraw1Qu42Yigre5mKdgf//32WUmDpZefXyJyco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pFXyRgbO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Pr4f1EzT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pFXyRgbO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Pr4f1EzT"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5698C4FH017036;
	Wed, 9 Jul 2025 09:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ABgvImK0RYizq7NZK9PlZpDz+nv9jHG/KIj1yu7IcR0=; b=
	pFXyRgbOf2wBobcZSfv1EzV7YDm0UhYUYXLZ32yMMUdMiIKClNMt5UgzTvcb9A6B
	eY3NCm/f9OaIaoqtM0FXgRyi5hf9H+jN0oBdL2//gDPDQOamqLgxV6nXabpWMIs2
	jlOvUI7dMCMbg+zwuSM7xNqS5iDELhicp8mN06fSKVI+lsCgEAEJT7HyPIXpN3fi
	PycxO3eO03q1RGJujc+dTnJvAzFS4B7EThjXQJCwjXEhbNvHNhR3fDKjw9eIwKeF
	RrM0RoJXQFqUOapB3I6/LZXD6ZYa+z/lYgqttt1fyAMehwu1HfA8QIsYLMIfgJzu
	Jl2Ul1eoKmndBHnqiL5mXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47smps85ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 09:26:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5698BQLV023586;
	Wed, 9 Jul 2025 09:26:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb06a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 09:26:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KTqGJKj9JLHurOZ1+IxqV8MTnS7Q+RF6hE8hu2bfoC2f31ZOWtk7T6rcxBgGlEF4Yy/S0WFjug3+62wBKtfwEnUIGMeI0OXMF6JFM0eQVFsYD1zm2fOnHMMx0rd+9XXkaPpEM9BuGSNaWI/Qf4uElm2YCUsd5/+rJWnc3+Cw3NjBJ2Hx5Re8xymM5AJrb/ts/9brRIiS2Gcq1MvQpf2JwT1gJFP2Wx5VNbzCXf2j4CE5qMXeTrp3sjzyG7SLUheOMmzdYs0I3gZW5wKCZ+qdY9kj8xvkbrPU3eKb7a+pA0EzyDPZpT66lVFkO5fihyCXZiJqZuj9trvxzmoR8+bzQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ABgvImK0RYizq7NZK9PlZpDz+nv9jHG/KIj1yu7IcR0=;
 b=Ku3P4aEYHmEgKF0GgclhPXZZ1pkwVQ40RIw/ic7Rdp6qcC8h02crBEWfAJzUVDddTVPJHHkHRoHbsrvnO6JRKE6w6JuHIYgfmufkX83eAj6gvdRaxpDuXsNR/sHmDiR4s8U/vGh7aOml+UT+aDw8OANe2dSbtEBnVYkmg2r1/h8R9qd23NfmAiEemuwUsdCgQMKOeBQ8a0Yvf0//CaKGBFVmXEDWPdPzb2Xtr6ZKD00K2euESRILF4Cefm1zZcXFv565N4eD3Tr2s2Faf4O/z20nTbShYSEjSChjK4rCd6dHLkw/UMsLJbki+f06XLF4SpLZ/jXgTtnraOevE3LnyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABgvImK0RYizq7NZK9PlZpDz+nv9jHG/KIj1yu7IcR0=;
 b=Pr4f1EzTlyx3EsEKSEZSNnAxlxzSdwYO+PP9yk/QcGx7/dEh3cjoNwASEJWU28nsn3tOXJ7XaqUmkkEVwxUgQ7uv4SPEv++dCVldqJvtDhbewG3NXf0YsZFKUP9miaw7rXtG2DLB6ZemdSxo2ZdvENMlfcuBUlGJ5M1XgTp/u/Y=
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17) by SJ0PR10MB5661.namprd10.prod.outlook.com
 (2603:10b6:a03:3da::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 09:26:50 +0000
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428]) by CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428%6]) with mapi id 15.20.8901.021; Wed, 9 Jul 2025
 09:26:50 +0000
Message-ID: <e7ebce87-2c1d-4bd9-8695-5431dcfeaa71@oracle.com>
Date: Wed, 9 Jul 2025 14:56:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/232] 6.12.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250708162241.426806072@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2af::11) To CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2310:EE_|SJ0PR10MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: e54ea76e-8e91-4186-f9e3-08ddbecabbf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUR2dktZQUtaRWhEVXBVcUp0ZHIwK3lGenlGTlBhQ3pZM2wyOXgrYzNXWjZC?=
 =?utf-8?B?YjN0WGJFcHhBY2QzYkVaWVR5N2ZzczU1cS8yUzA4VjVXWTVoVmFSejdYK01j?=
 =?utf-8?B?cE9saUJlM3dPSFBHYzY0M1g3bzJLb1ZIMW1LZFVhYjNxd2N6V0s1VTIvd1Q5?=
 =?utf-8?B?UnhwbzFWU0FUc0RYNENpQms5SnFZY3VycG4rTE9iWmhSdTNmWTdmM0tHRVlS?=
 =?utf-8?B?cmtYZU5XZzlyYWdVc0F6REZLTDJ5V0dnbEdSd3BpSGJrNzh1M2l4Y2ZPbHJK?=
 =?utf-8?B?SzdseE04b3pDV0d6MnorL3RnL0Q5VTd0NWdWbVNPdnVHUUJZcW1hdkd6MTd6?=
 =?utf-8?B?Tndha3RpZ0pnUjVzT2ZtNkhwbnRZUS84QkNIM0tSaHRCcWRSeXduQy9UTTB6?=
 =?utf-8?B?MkVrMElLdXVaY3FodjRKMDhtdXNWSWpUVldBMGhNRDlEdDFQd3ZJbFFZRDl1?=
 =?utf-8?B?T3RFckoyU1Rnb0NzZ2VIdGtNWmdDWUg5aTZpM0FXejNnQmZ6dnhjandtV3Zo?=
 =?utf-8?B?N2lEak9CZEhGN3dZK0tXcWdnWWNyRG4xRXpTNU9BVlJ6VG1uUWo0NlBEc1ZL?=
 =?utf-8?B?VW9GMjgzWlhqdzYyNHc0T3pTYnB0QVhFZnErNFowZi9iOTQxYkFHd2JITTFI?=
 =?utf-8?B?aGRnMFd3ekJtbkRnam1nNHNoWjd4WWttemQ1ZjR5R2M0b29BWGJJdkx2TjRp?=
 =?utf-8?B?SW8wbFFaR2cvSStIK0hvWUl6d1BMQUh6cmI1em8zMEo0MlExbGx0ZEd1QjB2?=
 =?utf-8?B?dlArbW5xUTdSbjIxL0JJcGJsMWtJREQxSGNmUmJYbmwyMWsycW9IMDNlRkdJ?=
 =?utf-8?B?dG9qeGNsWFR6aWp2Zm1hcEJuSjJvUjMwR2RuUjVveURPQzhod0QydUNBcDdn?=
 =?utf-8?B?Tkp2dlhtY2tYbHdNZi9mcnl6UWkxOXVZdHNPeGFrUE5pQlhLOUpwa1BYNERx?=
 =?utf-8?B?ejE2MmxEcEw2OVM0U1J5OWhDcC9JYlNLYnB1WDZxekllQUtYWEF6bDVyQU9a?=
 =?utf-8?B?dE9qU1FTR05SU09McEt6SGNla01uU3BCWDQvUU1rY3ZwaDB2MjJTTWZYWm9k?=
 =?utf-8?B?T1lCNW1sd0tsb1ZrRGRoNDVXWjdsL0hyTjNzSHlMVSs5N3BzSVFWNEZNOVNy?=
 =?utf-8?B?MVBNcUxzYllGMHNJNzFFd2NDN1NNK1dua3VBK2tsclhBdEJmVkNtaFFPNmRh?=
 =?utf-8?B?Z2NJVkRNL0JXVyt5ci94V1QvZGMrR0gyK09vTXI2T09HYUh0ZGVYRFpPZlRP?=
 =?utf-8?B?VTRDem5Ha1pKbVB3Zm1KNmt1S1U1MVQvWGlxak1jRkpZVzlTY1lmRWhjWDU3?=
 =?utf-8?B?VVBTZ3lubGdVN3NIUVUrWmVoV0RJSkd3ZEFiYUdlcHhDMWRXNDNZV3NRT2JC?=
 =?utf-8?B?N0w0WmRneE9wVEVEUVNKamJ5ZVlMTVQvQ0tpelJWN2hPRGU4UkdJQlo2bjVC?=
 =?utf-8?B?Nk5hUEp2ck1xMVlML2ZvSFRzdVU4SGlPbWNSNFZCTFdUaEdqemxRQ2JBVVRT?=
 =?utf-8?B?NnJ6NVd4QnZNOTlhQ3R3ck81SXdyNkRyTDBjUnhPZXVwNHBYL0NJd2VVcXFJ?=
 =?utf-8?B?d0RmbkptNEhlTzFPYU1JV3V4cEVvSUhOa0hhb2lQVmlURzlFQU83Y1FzdlNV?=
 =?utf-8?B?K2pUcUoxajBFT1hua08xMTdLSDVIUVNMREpOTEptMWE3UTlJZkQ4WWRkbzNE?=
 =?utf-8?B?T0p3OEMzRm9YSDBRVnY2Z2lKSDlzc3hUaG5DYVhQQXpRdHR4RTFRalgrVlpF?=
 =?utf-8?B?UE1VMzFnMER6aXNQb2g0RDdZMHRKMzFrWFBNOFRMT1lKMU9xUGNTWFNQam81?=
 =?utf-8?B?NjZLVjF3eFRsZFJ3NmhtcE1BMWRaVWRMWkJVTExRNm8xb3I4RSt2QnVvYUpk?=
 =?utf-8?B?enI0ZjFBN0FOZHo0UHVyN2xnRlU0MGRZQXZkbldjVDVGaExPamE4ODc3YmJ3?=
 =?utf-8?Q?l2kTowDJnE0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2310.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVFqZXZaRytMdG9yZUNpWTErTlBETkNRS2tBSWcvU0taL3VRdVUwejY5VXd3?=
 =?utf-8?B?ZGY3QmhRalNyWnFJYnhUU3RpS0ZDY3NNZWZKbnM0K25QRjJRUmRUOFhPMzhU?=
 =?utf-8?B?RmZMMHdoV2o0U2Y5c0Z0L3dxdjZ0WVM3TDYzMGtyOVhXQ1Njd1FrTzVnYVJE?=
 =?utf-8?B?cG5uODZoZjdhbHhqL2FOcHlVUmgzQXdkVGFwdTduOFZNMUhmaVg1ZURJcTlj?=
 =?utf-8?B?VGZvbnlEdlhLUUQzUG01dmZIaVZaUmZYRCtDV1R1UTUvN05FUWk5eVRDRS81?=
 =?utf-8?B?NTdaSlNBWGpOUDZHTm1pWmJleGFHTFhSVFJIYzJacU5HZzJGSXNTUHA5RzZw?=
 =?utf-8?B?dGx1WndoRVlWaUY2cFBDN1E3S0FGTy8yOXZQUWdCNy9Zd1JMZ2I1Q3krVGFo?=
 =?utf-8?B?RGNsOXVIWm5EMnI5eGdBTTd5Sm8raUxicUZXQklqSDRHZFAzUkwvRURkOXAw?=
 =?utf-8?B?dW8zeFVEd1FzMWlFNzNXOWlFUmV4YnFJcEwzM0w4SGxhbm8rR2g1UEVpdnRN?=
 =?utf-8?B?MHhpS0hOTjNSdnc4NkVhcGVlZnB0U21qVUNUd0tnVDBHOFJnZXR1UDJyYVpp?=
 =?utf-8?B?Vk1PNUdNN1R6b0ptQ2pLbHl4aG94OWZuaDVPa2ZzNVVsaUJUN3Q5bkdLQWVY?=
 =?utf-8?B?RFdDaXNlVGwrelhZaDczc2RFWmxLdU83VlpBWmlwQU1iU0xBdXVmUVlIeGp5?=
 =?utf-8?B?N1NTaTNFaHBjdFNGYjkwQzVLSktyUy8vMHp6TGc1TWd4aUc5WHpBSnB1S09l?=
 =?utf-8?B?bkgxRWtudVI5U0kxNEQ4eStyODBZMUdEVUp5ODBYbUJONk56bThOblo2N3Q4?=
 =?utf-8?B?d3NYVGhCaFdaSEVJZW40OWNSdEtoWC9jUXo1N2NicmhWWFgrbkl1MzYrci9V?=
 =?utf-8?B?SG9PNVV1dXY5c3dKaGRQTXpYZXZLbnZWbG5jNmtlbW0rS1BCOG8yV0pwSks0?=
 =?utf-8?B?TWoyZ3p5anpwdFQ5Y1ZPZG56bWhKQklwWHJ4OUhhVFYxZE9zdC93bkt1NUNX?=
 =?utf-8?B?RG1BS29ZN1hncFp2K3BFTkFmQ0pyRzlVVzczN25aaUU3Z1NQT01sRXgxZTFK?=
 =?utf-8?B?V21lQVJ4bTZHNkdJenNFempJSXRmN0Nydjg4V29YaGZqMVczWllranpUclJP?=
 =?utf-8?B?eFFYek4va0htemU2UW1XaUJCQ1c4RmY5TWQrcGF5WXRrOGwyMmM3SDkvUUsx?=
 =?utf-8?B?OHFjNmN1Y3lhZmRXTU5Yclh0RVh5ci9WRm5Va1FyQUhmcDV5STdKOUZrZUc2?=
 =?utf-8?B?VlBPMy81ZFNWQWlabktGUjRZZzR4aFZ5a2lvYVFteGxXWTRhNkFrOXFlNWZu?=
 =?utf-8?B?MysrTklXQ0NjMWtUU2w3T1QwcS9oVjZoT0tjQ2tiRUtjaFNyMU1LYTR0UkNw?=
 =?utf-8?B?d3Badk1FWnAyYW15a012REpCN0VhZ3dFVjFpYlVNcTc5NENkNUpIL0xZbkty?=
 =?utf-8?B?SURaYm9way9UTXdLaUFOVERyMi92SWZnL1Jvalg1eFM3Zk1Lam9Wc1VxWjVM?=
 =?utf-8?B?SGlOT3V5dXdScTdYdk5heVk4aG9FY3dMaVc4SmJlZnQ2NjN2WmhMUDg2WnF3?=
 =?utf-8?B?c2lqRmJEemEwbXNaWHBObk5xZURWaStZblhzaGtmY0JuaEZ4blZvSTNURll0?=
 =?utf-8?B?U0czNXVWMnRQcEhQNkZ0Y3k0cklSZFB2Ykt1Q3FIQlA0SndGdGszUjZsbXlp?=
 =?utf-8?B?RXMvMlRUaG11amExalo3SWNtSjRjWFV1MHgzTHNFTW9rdkN2bHU3TlpUSWxa?=
 =?utf-8?B?d1QrYjRxRm9OeVdaNEVDWjBaUjk4c1ZNWnN0TDJnNTFhU0h6MFFnZHdsVkZZ?=
 =?utf-8?B?aGpDM2dkNHcwTU12NlQweDRsN3VjZkZ5RFV6ZHgzS3FYVUdpNVBudTlXTFBW?=
 =?utf-8?B?MWEzRm1WOU9rMGRPN2c3bTdra3lpcGpuMDRpZ0c2WTdqaTkvcEVqTjNOUFJk?=
 =?utf-8?B?QzdNZ3ZxVDYySmVsbVV5NTZyMjFsSW9lZU9LRzNFMDNjWXJJY28yQmk0Vk1R?=
 =?utf-8?B?aGV6WHNzM0pmcVhOMHVmRXRDcG04MjllZE1hOUxpV1RzU1o1Vkg2MVVSdTM0?=
 =?utf-8?B?ckVIRGNzei9FdXQxVUU1d1hSYXhON3RLelZ1WXNTRmJOVTV4dkU2YzlzYXhq?=
 =?utf-8?B?U2M2allkMG9KdVNGdTBCV01ydVpLOXl4Z1RhK1RqWkR4bTRISW1RZWJLK1kw?=
 =?utf-8?Q?u0iNudhWfwf2ZJK5c7awaqQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wnc1+GbGEEtK89/NIgORAovQZFw/75czRJw/eHTjXF5qD+muVL/iWbyfX8GE+fCGKpuzljZWFAQK4M6o4PY7fughqJmW6uucAqvYISbfo/UDuF2N/w/EgLUE5m4F4R33JO4X1cq+Jq8GXDBzW5DcqZUtfLf6WCnKtzxmDDDP7hYLlpxpnyBEZSMrrOxUDfitjApQeq/C/Z0/FNd71sjJvPgH/lzMx5uMktRuujwbUe/aeQlV8g4XJBKTB1w076ZYuUt29LTqiaDYik5fy6OIRXkwNaBys7S9AvQ4aatZSaPOk/IXVEiYqzMfo10x7279qGNjRTO/OLPjJJSg0Acg1x8FCkoSEEmhRZncm8jEtf3z1th7EcckWT7N2I9E28A5YAfhNWqskgq77E1cZ3XirjRfU5khhOpWyFtSNUFhq76hqXlu2YL7TuX/0T4FJPNTX9oT0sNtWsaqLdwPlZEc9CRAY+xtBHvOZ67xUw64725SoBWotVm668MNnw2b7ypUXINK4Lisw/O2YECH+Gc44wZlmPGb7XovElHrSTwd9/SfGXjjOyz9lP58taXwGDMDT2/bsQrikAX2y14pJRnv2Wt71sEHGpQIhMvCpTUcisw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54ea76e-8e91-4186-f9e3-08ddbecabbf8
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2310.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 09:26:50.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJtejC/r78i9ofKwodRjt+jcqKK39JDk5aC+KyneeemEWfTYmi2xT//3x74Bk+uQKGR7NR9tvYxmnvwSjoU2TMPhznPbkkYLUYPABNPoBSJig+4bjW8YgOxakWtHHgnD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090084
X-Proofpoint-ORIG-GUID: sqF5YjZLyJKcWa-nUNYc1rmM2R1jUP65
X-Proofpoint-GUID: sqF5YjZLyJKcWa-nUNYc1rmM2R1jUP65
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA4NCBTYWx0ZWRfX5iTpuwmo376E sy/WOqnY7OqRejKhCZJxEsdVa7BWowvbI0kKwVZ+jZfWthXBAw3N6xZcALoBekNc7qb0USGxmau GyMwD0N07q23qSlB2HTwERfOeN8sy2G/36MP6l3vF3r1Drav5zZRocU+DftfAb3UVSbrtj82xUB
 a+oZ3FczojUXM/kRra668Nj77WX8ubsQV3+zT3Vgeho9K6R//r0vLzeCk8A/oEIQbQt+3BQ7/hy z/OStLweBcLYWfWyCYQ4MeIbolddqb6Wk9WQkPwLt79LMp6d8u/wj5Ic9BvwtXLT9GKy17zsPIl Cp+ZRE9USZOKiDyhs4ChQDaUNPr6hZrJMkC5ssZhWmAIF3+4ZEgfa9TNEPJS4PxCREe2zjaemkh
 9OKkUTS1VG5FEUgh8nkqehOTgBAShDR7GCDwjleqWCiSsANJxhvOC/9UW/QCzV6PU4ODJrXC
X-Authority-Analysis: v=2.4 cv=Scr3duRu c=1 sm=1 tr=0 ts=686e35de b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=ZFId0DEggJzLHO5cZtIA:9 a=QEXdDO2ut3YA:10

Hi Greg,

On 08/07/25 21:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.37 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

