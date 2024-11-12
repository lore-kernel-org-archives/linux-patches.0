Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0710202F6B
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731427610; cv=fail; b=uNvkPgDmM4Uz0vTIkxgzwO8prYhxQBjB97iZsz4JqgKEYDVMD00/ZJhjznpMDgUiAnaXWAkahi0KOcQ6/esrMNTDdpfl6ff3/uIw5Nq/wum4XUykWDdsEFjyVmLjJTEIgKQ0NTFQQ+mUiPMzBIyuCyCudIrqZbZIKKkXcINB5fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731427610; c=relaxed/simple;
	bh=OAWfjcK+5dpnhSThpMtxyGkoTVc7yBzcn0wOm8F1/Eo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RwAi/6rpFhHA7vBsaY19nQQcjOSbEhHX+KdqjkuATh5tvj8ovahIitJ1ciFSkh4v5GhTwK8VIMO8CxsMQyBmdbdH8XM6OR2wl96UnlBVfAPSJYGXA63p1qIHu8j9aE11r7sGUoK9U8iKcc91QmbRKcMenlxX5F6G7g+EvN8kvnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g++75T2m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DqrrWpf4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g++75T2m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DqrrWpf4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFNfww008551;
	Tue, 12 Nov 2024 16:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6majkkNgfIrPpP39TciwlrAsjmtQPepzOtdhjEAb97o=; b=
	g++75T2mhiq1CQPobAiTNR+RMKiGYvXT1kZQrAueCssFStfXaeHAULQJI3tNl+Mu
	47G52HUv5ZdG2/XQNYT995GhFTwu9hT4AEkTpJNM4lTRmnvpznUaFtVbJcbPrH0z
	XXlj4rdMVazRbTRc0YzlpgoVehaVw50ClMS3aSE7A+80CH8qcS2V33rP1DZf9F6x
	JrVoHkKlH7UiJksiXGA87YDqfoyCCvGSlnws5MNhuazs6AadldFS/mXQc+o49MEO
	0wSvKFXdVQ4xEaEAb1Q00/nF/APdG/1VWkXgz894Xz/frHh1ohwPwE+KdOPu7JKL
	XJ4+qMn2tNTH3dvib+w1YA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0n4vr4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:06:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFnEMp036079;
	Tue, 12 Nov 2024 16:06:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6835h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fw7o5DrBHPCN3PsSaQ/BgdExaO/CbYJyGMQDQNshAXWSJ64k5qoJIdDQiDerw5Sg2fNSbiEfUSPjqONjfjyPeaPZNej3WO9ishVI3EJtZjRaXC1ahomV/myH8+a9naIyc6uMewH1d/OvzVJfvIo37y343RrYjOzpEA9lWnWRebZZMrYfnoQResOLoDbSj1+2z/18kJ3QHNF7lk9IWa6ztrox55IszDw3dez/kMYOlcg8qCiHkM3aEOP9PgbXXGAFv+oqNqJUux+nWviRkk0WUYi2qucxh8zbU42pzl1x7A2AAyHF9lssSeiLNmbRw7c5OLguitezuOxijfvFfZJ0Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6majkkNgfIrPpP39TciwlrAsjmtQPepzOtdhjEAb97o=;
 b=h+pdQr31qwJvOmQvQD7HUpYxwdz+o43jlksindpYueYIhnC7SJ5qSOd0cMxmnALGJ2ZWDbFWXaZavC+atIpVH7aBOLUbKzLhQkJCbRCYrmfgUDL9xEWw+gQt0012cRWqzf3lfSG5fnd4S9ML0sv6h1+pV4D4SkknrowL0Xk4z87ImDygQffwLXaCHfS9Kvv4oIHXVa93xPC9deJ5Ot8wMdQRs0vsnr1O/6kERGr213TEUXdmJbZ7ZU9ABZ0ejsLqaVu+W/iy67O9B0re/UpW6t6nu2rv/sIqBDmJw6XTBETbG+6GQyn+ROGQc6SZ0pvs/ATHJ07OqtoO80n2ae/tSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6majkkNgfIrPpP39TciwlrAsjmtQPepzOtdhjEAb97o=;
 b=DqrrWpf4ou/663yol4US0R9DuW5CciVI9iEIZKxgOX928vtPZjkKkX5SB7IKviOQVk0/YhN4r3KP6AAFG2/ZVDpsOC44abxm6cL0+ikr7g2eN2T43fNzpXZoPRXKDMN06zVls3PY97hEt9cish0iuz02oS5n5Xc1nsWbmFOL/xs=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 16:06:12 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 16:06:11 +0000
Message-ID: <6a0abe9f-c3a8-452d-ab76-ee1e19da8bb5@oracle.com>
Date: Tue, 12 Nov 2024 21:35:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/76] 5.15.172-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241112101839.777512218@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::12) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: faf5dd50-02f4-4f75-f46f-08dd0333ed41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K01YTHRQMmpQSE1nMm5sdzlSMW91cDhRcGc2MG1ROGdZaFdyd0k5Y3ZZYVFL?=
 =?utf-8?B?eTFqY0RYZW1MUU9OMW1LZzkzcDZwWHRGSGtoczB6emM5UjdqMTJDODRKZ0p2?=
 =?utf-8?B?enRud1Z2QVBzVGR2QWp6WlVDbGlGMllKTEJIMGF6SWlVNE50cWF0VXhaUVBD?=
 =?utf-8?B?ZEt5amxubVhEOExmVmNkUFpIODBlRjlRRE0yNFdiSGhDbkVyN2lJQXJZallU?=
 =?utf-8?B?SFZzb1kxWUFSdVJ3QlZiZU0zRDBuWVFaTzhybzRJMEJCRWx4TUZReC81enVM?=
 =?utf-8?B?R1JYRG4ycEhXTDVEaUxDWUQvTUJvRFN6K2l1S0hvRTBuS0F1NU5XV2FCVkFu?=
 =?utf-8?B?N21YQTdwMVJUZ2szbENRTDUrdHl2ZzBobWYwU0loMGcyZHdIZXgvMDg1RU9z?=
 =?utf-8?B?Z0wrZzBaOFZjQXhLRmpHcXd6UHY5UkhrREJwMHBHYnRkU2dFQTcyYXg0eGNi?=
 =?utf-8?B?WTNLV0FrK2R4a1l4dzRtaXp3ejZYSzlBaExJSmdOR1VZK3ZaU0pSS0JzS3Ji?=
 =?utf-8?B?bmtPRTdHQVgyNkkwVzcvS01VcU9rTWt5NXhFQ0JFeDlCb0toTDdNdUJ1WmhR?=
 =?utf-8?B?cHlHdXpqL1dGaFduU1BqQUIvZ0kxUkVBRlJWcFc3bDhUNEpXalZaUzRiQWlz?=
 =?utf-8?B?RE1TamdFbm53dzcwenBKVHJPYWdXdXcxUm1XOTNrS3NIVmlMUGRyUzdEV3dG?=
 =?utf-8?B?YXljVDNDZ0EzanVuMEJmekY4eDRjRElDdnNVYjIraEkvOWgvK0F4cy9KSHRp?=
 =?utf-8?B?TTRpTzZ1LzJRczRhNDY1Q3Q3YVg1VWx4UHRJWi9zYTMyREZ6Y0Evci9JR05J?=
 =?utf-8?B?WUVITGRJYzY1aEZ0eEtXNHJhSElRc1ZXWW84L3dPaXNPOE9qdnJZS3hhYlls?=
 =?utf-8?B?U0JUQ2xLeW4wSDM4Y0RwSWJlTk5OSHVpcGhyajNXQlNiYUhuYURhcml1dDlV?=
 =?utf-8?B?U1VLazRPWTE2anBTcUN3NWVPKzN5U3dLNXplcWNUZXBFYWpHeHdzTTVDUitX?=
 =?utf-8?B?Z0pmWS95STc2TFdFbTB3NmlEMWpleDdlT0pzTDQ5cWpXbmFWK0tCV0EzYW1j?=
 =?utf-8?B?MXNQV0JhTGVkK0FOV281QlBTdXJJL0k0ek0vVHRTNlY4SHRoSlBaMXR4emdr?=
 =?utf-8?B?UThBaExQellHYXp6TFczZkRwMUloekNjRFBMSElOSWJsZ0M4d0FkTm5XS0Qr?=
 =?utf-8?B?c3NxeTNqVjYvUUpGYjQ3NnJRbG8zRlhMNXlheFRRdEE4UEpwa21aVk5ML2ZB?=
 =?utf-8?B?RWpXYTBob1ZMd0pPVUVaUlJJdzk5M01BRkJVT0xDSlROT2xxWjhvZ3VFVzFR?=
 =?utf-8?B?cTJtZ3MxcmNIdGFvQTZBc2tjMHdhU1NsTnFUSytzU3FId0E0a0JoVlVTelFP?=
 =?utf-8?B?bU8vMS9UR0h6TEoreTIxWGlyc1p1bmxXTnZ3RXNRejgweUREakxzSVpwRVJD?=
 =?utf-8?B?OTF6V2pudkREUVJVUnNvZTB6T2QxYXZpaGMyZzdDNE1sZEszN3JTU0hpc1dW?=
 =?utf-8?B?eWFNQWRTM2U4NElZd2I5ZUdMd2VrcTUwVlNIdmRVck5zMmt1d1ZzMGZkYUxO?=
 =?utf-8?B?Z2hRanpPOTZIQ09FL1g1QVJJVVRLMmM5ZDIwK1AxUGU3SHo4Y0szN3BKT1M0?=
 =?utf-8?B?YTNyTHpROHdONUxGMm1jNytXdkF1OUZHNDZoL1I2d3NCbzhPb0VjWU8rOEY3?=
 =?utf-8?B?SUJ4MGJpZERwNzlRRTByRVpUaFplclFVdU1SNFEvQ2VZVDNDcmFrdnJLVW96?=
 =?utf-8?Q?V8mdBDLFcztA0DNeT5WuZ0scTaWkSYZs+6IXUcW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTMyLzVqdkNPZEZ2WU5uSEp4c3NoZXErdW9RUjcyUjRTUnlkc1BWTGlsbFI5?=
 =?utf-8?B?Z3Zvbk9LdkxGSTZmUGY5UG5jSEJtaHorcExLTGJkdWNRTjVEQzFPQkU5OHRa?=
 =?utf-8?B?SGZXSmRlTTFXMWpkeFk2V2JZWm1KUzJWM3FsODNuQzZ0UitZRzRxa0lySzZ0?=
 =?utf-8?B?eGErRlY3bXk0VEFWZjVhSmFVWVNsaStJelpiK0dtSTJVMGN0aW1ON3dmbXAx?=
 =?utf-8?B?VWx5MXdoL283S2R1VDRBT1VDamtIQkFGTmdHazZjbEkyM3oza2pUL3c2dFFE?=
 =?utf-8?B?R0d3R3B1TFhjaHVjNVk2SkRLV1JHUHpNaVBEWVptQnpNK25oUU01YkU0YWtY?=
 =?utf-8?B?UDladkdZSmNmWkdJL1ZjRFRhRGg1azJBSEZUQlYySUR2bGhRSkxsVnFEV2tQ?=
 =?utf-8?B?UHZ6MUIrK2YzQmVRaERWYU1SSW5PdFdLeGtoaVhoQTVzMzNUM0NtMFBrSnVx?=
 =?utf-8?B?MWZUa3FtS1lmQ3hwWUpDMjN3blpsVXdRaHJVbmY1RkUzRWlLbmxyQWdURmZr?=
 =?utf-8?B?UFVFTXVaOVMvc1NCckVCOXlQNWhwV3Zjb2JVcjdzL21VTjhjR1hYaTNjRVEv?=
 =?utf-8?B?WnhpK0thdG9JRWFna3ZWaEdkYndLWU5ESUVEYnJ5NGZGcCthaEk1L3AwUUk2?=
 =?utf-8?B?b2hHUGF2YmRDcHdKQ2UzOWVWeVVNdlFqS0Qvb0s5WEtxTUpjYm1TNm5iSkgv?=
 =?utf-8?B?T0ZCUXBTbU9SYzU5Ym55YzlJVWcrK0lWWnBwV3doS1FFb1E4eGc1RDlCWVl3?=
 =?utf-8?B?RXY1Vld2clg4VkZ4ZlZqZ1BmNEtGVklTa2RJNGQ4NmV1VWVGLytZTTlTaXVi?=
 =?utf-8?B?UG5CVExDbEFkdnl0U3lacVdBNDRJRG02SjNub0QxSWErR1FTSE9NaGhTTVow?=
 =?utf-8?B?SE9QTEFvandqUmZPNjB4QnpRTmRXMzdBQlQ2TWhncm9DVmJjOU1sVSszL3NB?=
 =?utf-8?B?UXBpMS96cjh1U0dJWWUrQ2xWMkUvV2xHMzNuNE1nSE1jQUdLNDFPaHQwT1B3?=
 =?utf-8?B?SHFqZ3FGN25qTXpIWGhVbkdWZEhMYU12clZPSmtvMXVLKy9qR2IrTFd5NFAv?=
 =?utf-8?B?emNJSW5HSmJJNzBDWlltZURvaDVCek0zcE5UVDFWRm8wNkNrbS9EVC9vZmUx?=
 =?utf-8?B?aC9aSnlFNTltQVNEbGZic3ljektsQWZNTGs4ak9LbWd1eTdLRTh3ekYxVW5Q?=
 =?utf-8?B?SGMrNW8ydWx5c2pxbHB4YWVTQmhvYXQzaDBOT1VxdEl4U2kwcVpuT2g0djlY?=
 =?utf-8?B?S2JDNnNJRFBSSCsrazJzY2RpZWlEVjNpOHo4dVNFbUtxTlNXUTQzbkhMQ2JM?=
 =?utf-8?B?TlZoMGFUQldZMS9xNzFiZUFxWktRcm9ISzA0bnJVamd3SUlLTnNQTVdha0Jk?=
 =?utf-8?B?U1F3Z2RBdzNKNlBRR2IzZ0JzQlhzcFZ3SCtRendXWThYMFlzdERkQVJKRGZr?=
 =?utf-8?B?MC9lYTh6TG5vSkFTVXhHM25MTmo0dFRvSTBoMFRYOWpGTVBSSW52Rm5jM0lt?=
 =?utf-8?B?Z1VhNVByWXNNMXJsWmJ2aXhObEZ6VGVMYkwyMEh5VGpDRXJrYVl2Q0ZNbng0?=
 =?utf-8?B?eC9ET3JvSFVaUkZ3SkNKNHd1TGsvWFRiYUJyQWlLRXJNcHprZHRianhzeXNn?=
 =?utf-8?B?aDRTNDJ5Y1B5cHBqRlpwcE1hQTFkZzEwQk9mamlrc0lPS0prN1lyRzE1UWlI?=
 =?utf-8?B?SEF6STh6ZVkzcDhITHVaMXdlUUtHbkJ5QXNKNnZpQ2dXelh0ZFY1SDU0Z204?=
 =?utf-8?B?cWRoY1lRbWdkc3JDL0VYMXZCd3pmVkVwRGtrTENleHd0N2pvdWllSlpOa1cr?=
 =?utf-8?B?djNiZkN1b3ZUTndsM0wyMDJTYWRoRnQzUkRicTJFQlVteG5kTStJRytwMVcw?=
 =?utf-8?B?MS9yMG9wSy8xUnZWZ0J3RStJZmQva3g2Nm92d2JSUENoNEtGaWFBQWQ0Qjhh?=
 =?utf-8?B?eWdyVENKOUxNdEJYY2MyT3p3d3VUVmV0OWpBSW4vMCswelhGeWFvYmpXeUlB?=
 =?utf-8?B?bGRnaGlCOFNhNXJkaFA5U0l0emRBc2N1dVg3K2NsRzhUSmRFMURvMy9peGQ5?=
 =?utf-8?B?UWoxUmRCaDJScDRjWDFleDdGVUNEViszNmdHYWVQRUtTYktCWG1lWUFoejAr?=
 =?utf-8?B?SWVSK1JIUzhVTFd1OXMrbWlXbW1pQmh5cjVkTzQ4bXJoL2IrTDY4V1lzbWky?=
 =?utf-8?Q?wbWIJtn1iGBPOJxIhrFBbw8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xcl8mMtxT0iRsNQiz4x2xgnZit0hjtU5w3+rg4/UX1bbBhFc4ZaNIdDOOWnWbvXYcbt/Z0vhaWypuBGI/JTUml45PKQx3HqkOHfXxUQwWhWALY4/0L3+cC5nUTRAcB+IKdiv7L94Sovzo+t76YWrKc+JDYQO67w7YWYkH7nqV28qYVScBWqDei286QdV3KX9/Ww6q3zLrf1ekB3/pwq6fb5nrkHOtteY8+btu3mrhUhzaBKZ0+LtpapdHHtzM0Ev6JPs6/GRILgZ12+MNF6whPfpIM8+yNhipUeBUNyRFQumfC0lbTvNMcKbkfORPgSQreDqZnpK8Y1zLIbKWoBJYReHv3nAcT0ROKD9owXRSHQlnKBPAmOfRkKmuCkpmdrP3ECqItuHDVpc1P4+VWSPX1n97UQnAiYB2RGBlqe4o+YqRzYJDuJfPjTRrtd+QyERZNcVakthMeQf+VQwGQ41GSs4BLyjkE+55mwNzS/dkm0qV2NPtKL1X8+DMY0F770BNwKqTWttQccwo4EJxo3pr37qXLDfSfmTfwIKGKEWFt3mMbAAZ0vcJYI8wUivMVkALfhzbOFyVSZYlYiHTpmMM59/lv1vOnAD7Pl4SBmuGV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf5dd50-02f4-4f75-f46f-08dd0333ed41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 16:06:11.7222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Rb6QPnJNCDOyihlRm1YbH86CLtkoYEvGX3gBBF8GirZZ35/gD4aRxfngZmRWxnQvuG1Z1lsRs43QeF34EqM29lyVIr+J1Lwl0RHAUFWFTKXkF6BhLKHYUVbbduFcewo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_06,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411120128
X-Proofpoint-ORIG-GUID: erRTYzIqIXEw_G7-MZuYbisSH_yijUSi
X-Proofpoint-GUID: erRTYzIqIXEw_G7-MZuYbisSH_yijUSi

Hi Greg,

On 12/11/24 15:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.172 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
