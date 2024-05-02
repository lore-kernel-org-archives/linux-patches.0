Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9BD4776F
	for <patches@lists.linux.dev>; Thu,  2 May 2024 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714638907; cv=fail; b=Bd+iOBGiPqftUT7ap16uXwbsYPF6TDtmEkob4nNaAg9wthgLzv3+qV9n4VUM1Cboga+tkhxOodeNJ/pEUbyghdTONQ4UVFBAQz9zS3FSaI75NIfxxBuu+iKK7VRveiqIbma4G+cO0scc5SsfPbFAfbpKfwDkN7++Q7Y8AFW1lUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714638907; c=relaxed/simple;
	bh=7NZ9TCTeMvJGmA1QF/1HSqzK4+rrxWwn6Du7RQrLZnY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HfNuLeTnc0mTu/kQPGvUlGkgx8Ld1R7WggwK633F349lsOQkJOovTDDQDH33+arMZjxyiWPRNTQgpvZix2jmgvyjpPryM8PqMlgooTEbXUYxgoF6FAUrNYwIyzDKLjhLuSD+CkIr4hLsRE7zDZ8DmTrV/mnYG49WUGMeymeNFd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IgshWvYw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wowzgdk2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IgshWvYw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wowzgdk2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44283wKo023983;
	Thu, 2 May 2024 08:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=HPPjerNwa0cNrD5p52rB6CihHLiEt5CSdVLa2b1InaI=;
 b=IgshWvYwwk5mxujwBYhy20jNb9yAihwJZ2J5Hbxaof8vpSA797Se8X6rrxcOGOmwKQTl
 BZCIF83JgfMypCqRsLIQ0su/uaQdn7FNUdnxgPROeXCTVqCw2ENI/GFA5WEzQfmj53t1
 XyLeYYqINe1cfYXWXutZSsLguJCILCXqnGFjzXDhP/siqM/CBh+yzQzqmxkdyiG73Wr0
 MzpAEi3i7mpzW6EGB8tinPqQahvY1ltJc3Gil5DMPea9CdrRkXE4ZxifsM03SnC1Ye8I
 Ml5booXyc2oubPxpVYOlHfRtE/5VX90kcT5UY+UDgftwgmlAAKzBR9ODWW6OtwyQN/RS Sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrsdexwyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 08:34:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4426hFnD016672;
	Thu, 2 May 2024 08:34:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtgkh54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 08:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ik8kRkiQ6ivenmQ0/1/BezgAwGky81gGFs/irmHCaMmLLpa1Mfd0oRUzyz4UWsm/7DCbYIrLIqfZGGiOxZMaeLyHieyEHx1ibY70vVRcHRbzdRW69q7lH+yjS2Lk8QXYb31vCHZspElvAUvvvSsz3b9a+4ISnlO4YXe3MwqoeZd7fCqsN3iMVnZK4zLvKcfi07wt9EbtbKlYPjpVnn7+uJCMxjfJJip/E3cbNOczTtEKFxMENLFZnr66U8UOdBGZZYjMsMzwS9T6HCH4JDwaH7+bRdtSt1FkZYdhR/ieCz+VgxXEcedL4TFwmN4d9kVVFtaYVGvyL5JCSsQfDWw29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPPjerNwa0cNrD5p52rB6CihHLiEt5CSdVLa2b1InaI=;
 b=Ofgv06P8Jrnm/t3661uuSHHJtpN+NRMOVuWbrwDTSR6EW8ztte8dO7n+axyY4ENd0bqk2ynPycqcAfV4GVceT4Bq3DuH2iMA/x+x8EyJrNrOGaFzA6ukfaQMTJXz6T17h2CSK3pluf03x0fcUsk1b23853d7EKagasVd+fIzEJwUXymJlAFb62204PP6CQaR9bRO4F7sndGxgburoJb05+wgSiMVtG5UGLyXRtYnl5WxTjucCU0Ejf85OJjBSSBTzPEs7L6pVIw3WJGKR/KmKve8uotiZn31A44iSlA7TeN7Hje0A7ZcUtwrfvLPFBqLie6ajkfucuHyRhjdR55WOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPPjerNwa0cNrD5p52rB6CihHLiEt5CSdVLa2b1InaI=;
 b=wowzgdk2jzcaUYbQ/MdCjhMAj0gWhAqyYmG38oAwVMWz0D3AGSSczKvYx251RNExvVxdC55MLS+xtAJ+hKbGLTSNPsr930M2n8kMr2g3yZZIV/P98+y19pdTSbrCwNylsTyMjFRbwux5fnrSerdOJVa7jmXLM6ZFLxRcYFJ8VOU=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DS0PR10MB7049.namprd10.prod.outlook.com (2603:10b6:8:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28; Thu, 2 May
 2024 08:34:51 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7519.031; Thu, 2 May 2024
 08:34:50 +0000
Message-ID: <23938ba3-2952-4fa5-97c3-05892fea4663@oracle.com>
Date: Thu, 2 May 2024 14:04:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 76/80] fbdev: fix incorrect address computation in
 deferred IO
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nam Cao <namcao@linutronix.de>
Cc: patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240430103043.397234724@linuxfoundation.org>
 <20240430103045.656528789@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240430103045.656528789@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0167.apcprd04.prod.outlook.com (2603:1096:4::29)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DS0PR10MB7049:EE_
X-MS-Office365-Filtering-Correlation-Id: 7485ee4d-a993-4bdd-db44-08dc6a82bba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WDNXclRyVWRTZWsrRlI5d25PS25LSUFTVzBSL3lpOWVxZEVpVExRYUZVSWdL?=
 =?utf-8?B?Z09VK2huei9BTnk0emhCN0VZSVZ1TXhxSWc0dVlXYVdrZVhaeklvS0orQ29v?=
 =?utf-8?B?NUgvaFdjNHAzK2l0ZWFiSDBaa01qN2loelkvTzJMeVhNTGdZTXloMVdlNDY3?=
 =?utf-8?B?L2xQNzFDVThxbzNaSnBZMWdCMUwzSHdMQnRYck92cFI2K1J6MnpCZCtOL0ZP?=
 =?utf-8?B?R2tjOTFENDFjUFpiekR3U01JeDdXaXlBUU5vNVJCNG1nS3BrTkxSSm1uRmJy?=
 =?utf-8?B?ZGxJbmNQRHFJLzQ3ZFBiUFNFN0FBUktQWDNreXpWOXZ3bVlzcUxmVzBkSUp4?=
 =?utf-8?B?VjMrclVmRjlGeEhLSEF2QVh1ZGw3cEp0WEE0c0l6LzJqd0ZXQmR6WG9peTFp?=
 =?utf-8?B?VU10MHdVQzdkK0tuMHhLaTVKNmJRVWtBZ2xIdFVac2Erc1dTczllK0FiYUZB?=
 =?utf-8?B?aUNid1dwR2tUMDhqRGNoUWQ4N1F3NWZHTHRGQjVxQmY5Yk9jRDA1dGI5eEJG?=
 =?utf-8?B?UGNiZnc5Ym85cE1kalk1U2UxK2FvamtpdGVFdFlORnpsVmVMRy9sNlY1eWtZ?=
 =?utf-8?B?MjZwY2dyaW5HNnF2ejJOVmsrUEQ4RVl0VXBuT005Snk5bG9mWDIwdDV4WGRa?=
 =?utf-8?B?R2VMVjRuNGRzbWU1SG0zOU9yZnZmcnBCVklsazdRM243TGNGSXZvTmdRZEtY?=
 =?utf-8?B?ejhkQXlMSm13c1Ftekd0eUgxdnFyVTNCOFZrK3IySEpJcjBrRjl2dWVlNmMx?=
 =?utf-8?B?cG1nRU1oUVpNUW9OeHVvcUFySVVmdnN3aEIzSzQraWI5K0VLQmt5MzZWUXcr?=
 =?utf-8?B?OUJzakU0VDdHbWRTVVQ0SWJDS2pTd3pwYnd0TWQyQUdqK24xMzZxTEFpRnU5?=
 =?utf-8?B?U3kwZGY2MkxCSEZZQkE5ZlJBMkkySXpvRTlRRkF0RXJMQ1FxT295b0prWkg2?=
 =?utf-8?B?MkdJdGJPMnZVU1Jnd3hQS2FLS0RERGY3WXZ0ZlM4QzdkVWQ2Wnd6eHI1VEl6?=
 =?utf-8?B?VDZiYzhKYWh2Qm5lM2tKMzlnWVNxTjg4b2QrWWZrNVlqV1VqR1FMSEtsTmtu?=
 =?utf-8?B?UGttWS8zMnRrUnBGWUlUdEFWTFB5RWpqaExvaldoQlBJR3Y2dFp0eTNiaHdW?=
 =?utf-8?B?UTF5eVNwbjdBa2xiTFh4UElzWFNZUmRvUHZjZHd0SUtSK3FlbEJObXlvR0Fy?=
 =?utf-8?B?UlR0Z3pxN2VZbGRJNmlPSnJPK2oxY3lsWGV3R21QTk9FbzVGdXJnT0tEU3FM?=
 =?utf-8?B?V2NIbndVMDZ1SjMzUVBrUjhPdHdzTGxtSEF2ZlMzU3NVK0pUTTVnZ2Nid0hB?=
 =?utf-8?B?RWYxS1JLVFd0d0lwalM2S01KR0J3a3RNTWxHWTBpZkxadFRwNTVSaUFMUzY5?=
 =?utf-8?B?WUV4OUpWNGpybC9DNUMrMC9yZE0zV2xTaGllZWR5UWRxV3Zva2h5T0RUUFlv?=
 =?utf-8?B?L244NGM1eUxRVDVqcW5rNVhGbExsRDZ3VENQd3hKM3BxQi83NW1ta1R5TlJK?=
 =?utf-8?B?MGVRK0VCeWN3eVB1b21sdWttdUR6cHFyblVGNFQ4L1RJNnRvaWJIZzZhdnVK?=
 =?utf-8?B?ZmtQeFQ2SWhLVlZ6dzNwOExKbWNmNXRxaUxzZE1EZlNrMGMzZEEraTlDRGp0?=
 =?utf-8?Q?s9PWpuFDk2mSuP7KJpPbjFy5kCb3eFZUu5ySsy/ElbZA=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TzlSMFAvZ3gzTjZaeEs2bzJIN1ZPMHcvNnBHREJEaVQxRW9VOHF3Szkyd01z?=
 =?utf-8?B?TDdvd0lUQjQ4OXpJU0l3cDk2WlRSUWVnM0ZRNk56d1RnOG5wSmVpNjdHekho?=
 =?utf-8?B?TTZkSUJ4M1czY1VmNk1xQlRXYlQ2ZGQvcTZJcmg1VEIvUUFKalBYcmZxbm1Q?=
 =?utf-8?B?bEhVTEt3ZmFDTFlEdDdxeHhvNWt1OVFVVDh2UFNmemFSSzJlYlhGWGRXbFBp?=
 =?utf-8?B?ZmxNYlJDWHk2N2lVYXd5dngyOWJaVGtnMjZaNDduckp5WkRwdGdPaXB1SkNS?=
 =?utf-8?B?SDJSMTF6RmFBY2NFRE1GdDZCc2FVai91Z25SK0lORXAxWU5RV1hJNlVIajFw?=
 =?utf-8?B?cFdWNVhtdmZqVC8zcFFGNmxyekhEaDFuWDQ3dmY4TWx6dUpOb0tJaUk1Z1ps?=
 =?utf-8?B?S2loZmd5THVLdVJJRWJNUXo2VGFuWEJiY0lzcDhXcVlHQm51ZDRDRWFGMUJp?=
 =?utf-8?B?VXR4UytLQjVMeFZQMTFRM1NHYkRnVm1mQXpVMUtDb1NicmFzYUxVN3RIblNr?=
 =?utf-8?B?V0szQXFZamgzdFVsdWN3R0ZQKzNtR0VwWFA1Tzh3eHFHVndiRTRVblMycUZJ?=
 =?utf-8?B?UFk1V01kbGIxM2oyNzlYdEExTmt1bzhiR3ZBdWs1TmFXMmFOS1RPSVFyRDV5?=
 =?utf-8?B?ZHZJWDROeUZDZGRIV1dvZ2paelJFb2RocWxhKzBMSUU4YzNrc1g4NkEwdVFP?=
 =?utf-8?B?QjllUlVSM3VGOHloNmlCU2s4SmRJNHFYY2ZZRjByR3FDNTV3WWhrSmJjZkVq?=
 =?utf-8?B?RmYwbkNsS01vQmRoZVRtV1VYeCtNSlIyMzl4dUQrc240VDdwOENoUS9OV25Q?=
 =?utf-8?B?R29OanpYTEp4SXN6L0V4VjI3S2RKVGVIcVVuRUdXeVAzOUFkbVBCM2VGU3Ro?=
 =?utf-8?B?SWZFdm9lS2laU3c2SEozbnN1RnlKMTdzak1wK2VNYXdUdmRObXZweUdkOVQ2?=
 =?utf-8?B?aUh4NStVdlB2OTVzU0FQV1RpMmNhSG14ZGg4YmlGbDMzM1B6Z09PUEFJclJs?=
 =?utf-8?B?WkI4SmJ0dU01RDZ2V2tEL0ppblo3d0JzejVXT1dVdUhlZVN6TmtMSS80emZP?=
 =?utf-8?B?V2hZUVM1VlhmWmE0aFhVZFJrV084TEFQSjU2dGEvaHJHdGVNMC9IRTJBaHd0?=
 =?utf-8?B?NTR0UzhPY29EWENCNDJnR1BKTjlQeUZTNW5rSkpDNUhGS1R6VGxDUFNrb2Rw?=
 =?utf-8?B?bHlram1EY3VSWUoyVnU2aWQvempERHVuczRZckdGQmhMdDlpd1lrRVRNODAv?=
 =?utf-8?B?ZWFUd2tRQjhsYmI4K2QyVzRlMHZXdjRXS3N6bzh6T2h4TU1tZFd1NU9xU2l5?=
 =?utf-8?B?MXB0ZUgwQUd0TmtMbWIxZ2c4R2UyNThzL2tnTTVNbnNHUWx2YjZtTG41c0dQ?=
 =?utf-8?B?cE1Na00wWHhCM3lYVUdsVFJub1FQY2RJQ21YblFOd1BlZmd3U3lwM2lzMmFI?=
 =?utf-8?B?N21SdjFjMEpLWThhc0k2dUJwRE5IWXV3TnFLMUlQeUdkYXVFY25FL3FMMWsy?=
 =?utf-8?B?aG9uMFdRSDdBdnRsR0lSRllqWTk3WWkxWURYcE9TSWFobTdERWdrMjc1dnMz?=
 =?utf-8?B?dDg3RjB1VkM2NWpVTHh6MGpyMFIwc2VDVDRKRUJXeExxTGU1L1E2bFhMd1Bi?=
 =?utf-8?B?eUREZEZocitpUUM5S25kSFRGQ1hhcXFCK2R6cXYxY0pGNFVPMlpNa3k2elpI?=
 =?utf-8?B?a1EvQnkxV2VSVDZrR1pRaGo3aGVEU0N6YURuK0ZWd1NuTldyVHZpYk1WNXZT?=
 =?utf-8?B?RXpLdUU1OHlMd212eXRHQnZSNU8yR1BWbGQ3emp4QTl3TTFQOU9KYWgwbXZQ?=
 =?utf-8?B?Sk9KOWlQTlZuaG9nNnFCRTRIUUdvMy83eDB0blU5NWFRUkZuT05yRFVhY1pK?=
 =?utf-8?B?SEpCdmJoQkU4T2o1a3B3VGtUWmFyUnRZNXA5eEFxUlY3dURPb01mRlg0bVdK?=
 =?utf-8?B?d3dIbXBIWWxQVmZKMWJoc3Jyc1lnNDFZZmd1cW1yUzFQTXQyOGtGNS90dVpG?=
 =?utf-8?B?UmVuRURuMXNxWWFDZ2JUd280dTBjVWJtdUJvRjRGR0E2aUloenNNcFp5WFV1?=
 =?utf-8?B?aGZFQ2xKSGxrTjJNZEd1UGM2cHdPM01KamxobksxcjVJWWJYR0pNcG95aGZy?=
 =?utf-8?B?M2ZxeEc4WmFHaTZIWFF0SlRDL0RwSlFWVlhibWtKeXcwMUd1TTFsTUFpMGJX?=
 =?utf-8?Q?ivBy4Jadbdekcvu3D547HI4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QlVTe6i3azeEAXHeScJ53VziZwk4gfQVISs7a2XOkeiKPH0psZnxg8cl32ww801zmY5wMBPLRLPMOIBNZkNsFvlYl4jl+pPhBcnRrpxAeeOymVawVOTytwM2BVxi0wfp9KK8cWEKfkWN8EATodbiR8zgHgYZWQeR/vQh8x7On+TqXfUMQjA7qFRKrxfvwglVO7cIS0CNGRyN7Loim/69lDoThYW6l0BozDGoR2gZ95DsdmhBtQPP8r3QyNwC/tYC2N4UUDe8ABncFyz22YjheO8qYqepQayFemNn4NOhScisNEmOLJs51tA/vk09nd7I5Z0GJCf9WoSH4QvvyCoguQ2gW8sxDiVoLVvfekZARiPfh3HiQhyvXy33Wb9yyvU4fG6OkwdG/nOmpAnRdiK+7C1UJfL5cQlGDbNDqwBrDg+Jp/09QvEuXvT+QgXB57YR82tUFKRRFZNAIhPmFFP/Buinu28qw0/i0x/kaRAxj976cK/yqFuiZ7kLfHo6ZvGCCiXP+fCDLbHpCW6iyxnweNZYB85VKIoh1T4KkDtCcR8ay1my8XwUYKWpJJQg1Pa065IYiGLa2dSJAjOkm0fK0vJEdRm4iiIG7T4h/mVpc1U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7485ee4d-a993-4bdd-db44-08dc6a82bba6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2024 08:34:50.9212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r50+d03PnrUdEa0wbgg639aH/qQDltWADJeDn/P0QhU6GhF+7nPaxV2YcbZ3FXQyjlOpBBXgaPbRq3X33p/nMVjoUQ46BwzudYHVfGWtWd4y+bBW80QbBLEOLEGD4XcJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-01_16,2024-05-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405020051
X-Proofpoint-GUID: 7HVZSDTYs4B1P-jmStZR2YX173b2-Wnp
X-Proofpoint-ORIG-GUID: 7HVZSDTYs4B1P-jmStZR2YX173b2-Wnp

Hi Greg,

On 30/04/24 16:10, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Nam Cao <namcao@linutronix.de>
> 
> commit 78d9161d2bcd442d93d917339297ffa057dbee8c upstream.
> 
> With deferred IO enabled, a page fault happens when data is written to the
> framebuffer device. Then driver determines which page is being updated by
> calculating the offset of the written virtual address within the virtual
> memory area, and uses this offset to get the updated page within the
> internal buffer. This page is later copied to hardware (thus the name
> "deferred IO").
> 
> This offset calculation is only correct if the virtual memory area is
> mapped to the beginning of the internal buffer. Otherwise this is wrong.
> For example, if users do:
>      mmap(ptr, 4096, PROT_WRITE, MAP_FIXED | MAP_SHARED, fd, 0xff000);
> 
> Then the virtual memory area will mapped at offset 0xff000 within the
> internal buffer. This offset 0xff000 is not accounted for, and wrong page
> is updated.
> 
> Correct the calculation by using vmf->pgoff instead. With this change, the
> variable "offset" will no longer hold the exact offset value, but it is
> rounded down to multiples of PAGE_SIZE. But this is still correct, because
> this variable is only used to calculate the page offset.
> 
> Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Closes: https://lore.kernel.org/linux-fbdev/271372d6-e665-4e7f-b088-dee5f4ab341a@oracle.com
> Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nam Cao <namcao@linutronix.de>
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Link: https://patchwork.freedesktop.org/patch/msgid/20240423115053.4490-1-namcao@linutronix.de
> [rebase to v5.15]


FYI,

The reproducer doesnot create task hung messages anymore. This was 
initially reported when we first saw regression after fbdev commits in 
5.15.149 update: 
https://lore.kernel.org/all/271372d6-e665-4e7f-b088-dee5f4ab341a@oracle.com/

Regression is fixed after this patch in 5.15.158

Thanks to Nam for quick 5.15.y backport and for helping with the fix.

Thanks,
Harshit


> Signed-off-by: Nam Cao <namcao@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/video/fbdev/core/fb_defio.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/video/fbdev/core/fb_defio.c
> +++ b/drivers/video/fbdev/core/fb_defio.c
> @@ -149,7 +149,7 @@ static vm_fault_t fb_deferred_io_mkwrite
>   	unsigned long offset;
>   	vm_fault_t ret;
>   
> -	offset = (vmf->address - vmf->vma->vm_start);
> +	offset = vmf->pgoff << PAGE_SHIFT;
>   
>   	/* this is a callback we get when userspace first tries to
>   	write to the page. we schedule a workqueue. that workqueue
> 
> 
> 

