Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189523BAD95;
	Fri, 22 May 2026 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779443857; cv=fail; b=OjqtqzvDihcHe6stZPPcdGqYK7qRJtzlrj9DiWblpn1F5SW5jK3eQuaSBYcDyrWjb7hkQheCrj3+m7ojJGNicwafDiLYL6cyPIb31i8E15xctQ6v1Yj98qxjCCd4d9/wdCaX4PzeJ/PrF58dv0ZdMNjtoxPhYaToh8n7ND2LOU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779443857; c=relaxed/simple;
	bh=/fRsqaRu0GsJCAnPrOeaOxxAWxtkh9MBf1chbEZn5gI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S7eLIa5of0cYycYi4E+Lk7Ew+nD8ywTqhIKRbD+w0VD698nnX+tE40URWQ09nwFdCUVIpBOkDYuKtpPJtSJz4GjpKd6tVA6BuHzOSQvcIOfxGM63TGK1B9SUM8vQuGvjVbMGw9NAaz+s9lbmHMux/r0nUmnEkrSFR+SU1twmb04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sBVZZGje; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hH9GpRZC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sBVZZGje";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hH9GpRZC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LJfajc3527414;
	Fri, 22 May 2026 09:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qDsVDpg4JZVXw29OLsRuVksNVQu6QTd/BGArj0ygCOg=; b=
	sBVZZGjeuhEQ2/ZRXFi+3zgip0wmcp4/JV6nIqsYTRjQiavW1zdRbCeXQE2JNvli
	e821ULBAIfC/Hqcqu4xqwiemINHsI/xeeWkNgxIRdrwQlB++xVuocVw18c43lmmk
	9bkbHr9SOkL2fe75oc0vqePPT53AKM5Wu1F07IyuSGj0/mVSEMaZvpNpj7FZZ25f
	2xf/ZuP0ilSpRpKmW7HkN2k2s9S2ttCh83DwQhb8JqfbTWytBlAl8xObapWyIsLD
	hSUVTQtBBeGMk7PiqMY2guZQxF6edbfgzELtWmmd4/+Aak9r1ac/jXOGw0KEoBIm
	yBvyDMxVYInBQFbNX1YOWw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6gxx2r3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 09:57:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64M9nkH2038086;
	Fri, 22 May 2026 09:57:24 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010035.outbound.protection.outlook.com [52.101.193.35])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1ku5cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 09:57:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjXAXo3a4X5mOnqv7fjspZqPPnAc9EdbsQAgScmahBDnyT586x1/B0PeZVcxsTMrkfTwSG8qNpcH6sBV4PtDipEhOX3ue57RFGa0tqn7Eqe4+Cx8UwFziBiyckeAtP8mXXg7MhHWd7ty9qx2VISai1yj/ppuINv5UVyrg4c+xDRCOGaGjS6/WwvKlsXoirgh3sgPCwEmTrrHmXRX6LVXH/vwTZs6vsQH+jWwPk+XQevtVNQCc6ApuGvRZQxyYtlBpYVQ34k7XmCe4p2dXpM9tnnRHNvePOOy3fzrJwSV7AoTwES+y1ySnB3fgJlGz2FgcbfL7QiLfks4Ru+3kxUJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDsVDpg4JZVXw29OLsRuVksNVQu6QTd/BGArj0ygCOg=;
 b=b0MgEDBuc8GWmmxa676hpbsxHnvRewlK+qNEG7r50xASpUO+PNsb/qEzy+AQIZds+2GDc4sok2Vdl766b4OTDgC5cUf/YwzTmKtvOa/H7Tyz0oe+uOrqssIOrGWt6Bq2Qsa5ZLS86nuTKnBC0AN6a4pG5mn+/IbE7Gg0/rKpHBWRe3lSpqAGb8ZGnVZZCKEJXqUXAkbi262kYa5qqQb8sQCNrFHaDhDDfdEgqt8dn+iPv/Q7jjx04f7DZrbBP1gSpVwNiWL2ymlxytJw3V/fnrbQh/BmwK4koY3m+qjIl+PyA4qfiesuwYJ3TxYQQsAxqNWtPWFt6CSnZ1rop2x8JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDsVDpg4JZVXw29OLsRuVksNVQu6QTd/BGArj0ygCOg=;
 b=hH9GpRZCWwFSnLI4cbtzzkU5YzFrh4L+ZyD1bl9mpOD0JII1ofroWWqW+Vc/xeBbIZVA0GUSPCkBhTAqfeI4bTcJajMIb5pnwWvj/8k9WUepQStfNA2meLizjCYu/wKeUgN1DpEksG2zPoPHHDqiLElPbdMG+0aNITlVXwX5Beg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by EAYPR10MB997927.namprd10.prod.outlook.com (2603:10b6:303:2d4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 09:57:22 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 09:57:22 +0000
Message-ID: <b8ef921f-e2ab-4cfb-b75c-89e4277214cf@oracle.com>
Date: Fri, 22 May 2026 15:27:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 346/666] bpf, riscv: Remove redundant
 bpf_flush_icache() after pack allocator finalize
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Song Liu <song@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>, Pu Lehui <pulehui@huawei.com>,
        Paul Chaignon <paul.chaignon@gmail.com>,
        Alexei Starovoitov
 <ast@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162118.730164877@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260520162118.730164877@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0009.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::17) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|EAYPR10MB997927:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a1debc-dcb7-4e41-6d27-08deb7e884a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003|3023799007|5023799004|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Y7lM3sVyUnMBXawxxudTXRd4CvPb00jf+XptI5XisN4i3a09SDa/uGc4cTzv97Npr8jISBKUz/TgqkUfuowYoUh5zrSgHu+ZMxB/uFQwQ+7uC+VTUs6xabkV/Jf1K7yFqxFZepjQt9JLWHfWwxXQIr0PRG+lvHUiLqKe9PchmUaeU6SYBBDsS9jM7EIXXbiZqy44ApEeUKcANKFb8hZWLjH5vL+hEznCcA/79l7lF7O1DEZPn7YgcD0/3yEC6gZuduRu7BjgYfIhHniHUHV11Ylc5KdnpeZyr7m0cPcfTNzpLKNBinSuv7xNQQpKbN+4nBOPEDit08m76Km08V4+hQiCiabqjtEfHooTtkz58Pgy36ghHTee2uZ3NsLkBjpwUv9VBS8i5VfZ0U/iXH1deQ2Kir+5IvD9bLZlRzALlLOE6Fi0d3ul8nI1k57mMyFsVNnOOj8fPr6gEH1qx2JV9ti/P/oj1XbI91UsChS7tdueIKrO2AqhuyfGd/NEg2gupFg2OVQO+CpuZsyb70CUWdzFwjCQi27+/RJENvlCFrEYV5NGbQIHlcmHQS2pYODvl0xO8bRGioU4SId2HkanF6Q6ykeSGxKobocwBbl3nd72RJPYqfxz7BJuyw2RuQ+JZFri5h1YvGPoQ1DzOJL13YKkVzV4Y0OCbXHMTTdZg0Vm996/6KqDVOYOf0FJhCeSKNdhwWOpjywMtEwcEBLsjA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003)(3023799007)(5023799004)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmdqcWtQZm9FSEdPd0JNaXNjOTJkaFZGUkwyWVh4RVF5L3R2UkZaYUV3WjZ3?=
 =?utf-8?B?cy93WEZwZEp6ZndCT3BPSkRFaGkvc0hYMmFsY0VXZ2VCSllZTjZXdFNDNnhQ?=
 =?utf-8?B?TEE5UmZHZG5xYndhM2d4R0RiamdFQlpnMmpSVFZTVDAwQzhKdVZYN1FGVm16?=
 =?utf-8?B?MW80Q2FtS1V0S3ZWVVlYaEtKMmtseWt6eklEOTMwdzlJQzBnaGpwcDJpdDRC?=
 =?utf-8?B?MmxvemtFUXVUclRKbDFka25vcE1oSVRDNjhJUlRYcXpkT1lQUm93cXV0bkwv?=
 =?utf-8?B?c2duT2p2RzNJL2VhVnpGUXFUTDd3c1Q3VGpyWG9FSEtQVGRjQkRzdm9hdGlE?=
 =?utf-8?B?akIyU3kwWThQa1BOZUxNeVUrVm1Mc1JWcFJWdzB6bnY4anVnNU93TGM5YzdR?=
 =?utf-8?B?RVo4QWwrcXZVbkpYcC9XdERlV2wzejZ2YjRvcTkrV2c1d2VpWkdwLzQyelRv?=
 =?utf-8?B?aEFzaWQyZ2JPYWxrZncxL3NRQnNFWU9DVzhTd2svSkV5TFY1dWtYZEZPcGta?=
 =?utf-8?B?VWdETnpFMEZyMWxvdExRN0dDeHVyUmt3SmptMU52WW41QUNoZEQxS01ERjRO?=
 =?utf-8?B?S1F3QkdtS2Z0eE5CTDZ1RVdKRkVYWmc0Qm5xa25rMENFZHNJM1RTWVNHRHdw?=
 =?utf-8?B?Zk94clNUSVYrYnBoQW9ESHlXRU1ZbVRVWXlzbUZtd1ZzdGtuTEpMNmx3dzFT?=
 =?utf-8?B?UzlyTW53WXdTL2tXMDNoWEppL2xHM1dqNFd4Y3VyOWhJRDZWUzZ4V0liUjJI?=
 =?utf-8?B?MkFHZFdnRmVMRy8vWHZuMFYwZnVFT0dNa25qejZ6dVErVWllK1BLODVFVlVY?=
 =?utf-8?B?NzBDZzFLTVlva0laYysrNnB4ejY4Qmlyd1NqT2lkK2tPSWFhMFpydHo0VytQ?=
 =?utf-8?B?ZzJRUCtpUHNQTEp5T0VMQ1p6bFVqV3RzY0xSS0hDU2t6Y3NuOStJZDZZN0to?=
 =?utf-8?B?RTBzbXRpQ25qcHUxTFozeUNqTUlXdEJVUFZ2eHB1eUZKR3dQZHplMGJFWlRW?=
 =?utf-8?B?Z3I2LzhCQ05TT010MWZ1cm9TUEc3ZktORGJKQTY0ekhyTUx3MnJZemJqZ2R2?=
 =?utf-8?B?MVpMN01GOXZ5OVIrL1VQa25QQzRPZmxkQkVBQXUrOHJ5WHp1Sjc3OG9ubFJI?=
 =?utf-8?B?TG1vWElhN0xnQ1l2U1ZRSHFHdHM0cWNwakpBdVdyQmpXN2Npd1hWUGw1Yytj?=
 =?utf-8?B?TXYyQ3F2RzYvU29GZVloNWh3eFBPNStxQkpEZ3lGZnZuUUhnaVllYUM4RUIw?=
 =?utf-8?B?bHZoNlFCbnF5by9nWWJQN2s5cUUvbktsRVBaTXpIR1pHblRkWjBhRXhUVXZk?=
 =?utf-8?B?blpudGhHdEF5OUN6ZC9pY3lVVmVNTkZwQk9EUitRM3NxMFRiSWFvY0xScGZv?=
 =?utf-8?B?ZktVWWtWZWRhdDBSY0hpWngwd2h1RkFsWDcrOVZmTXZPUlZrK1RXRmtrc002?=
 =?utf-8?B?SHdraE9pV0ZUNmpBWmlqL0lqRUh5NG1GTUV0QzJVSzRpbFRCV2xoT2pNOUo1?=
 =?utf-8?B?M0RHM2JNd3ZWT1E2RmZtQ2xaVVJrYzVnRFZQcHJ4TFpZbnZXbGRiYm5DalM1?=
 =?utf-8?B?ZCsyYi9ROUgzb3RCOVpGN0FKWE0xcW1zWjU2SE9leGZBU2ZOa2gwWlJzVWlu?=
 =?utf-8?B?cGdQN1pCczFZa2VUQnhQdWxBSW1vdzFuOXJCbUxWV3ZUeEp1em1uWUdpSEcz?=
 =?utf-8?B?MVZOd3ZlTFhlN09RTHBoaXh5QjFOQ0tKK3ZiRXhrdUZjUXNWK2I4c0ZiQ3BJ?=
 =?utf-8?B?YTVZOXZReFRqckJoelZXcXlTY2VhbTRxanlWUHFqSjhoRWcrdW1HZkZscXA2?=
 =?utf-8?B?ZlJqTHdUZWNjZGsxNTFzaUJLRHVCZWcxemg3RmhBU09OazRQQk0wOWhpTjVS?=
 =?utf-8?B?cGFhVVBrQ3M2MktEa1JtVkRYWU41L0FuOEZYWkR4dDU4Z0JRNS9RYzFlbHVW?=
 =?utf-8?B?RzhET2ZhbkhuZEExcmQ0aG1KamFWS0Jpb0Nya05vaFpjTll3UUdOaTB5NjN1?=
 =?utf-8?B?R2J0cHoxTWZJcVd4UVB5bGt5S2dsbHBHZkh3WHhldU5XMncxeEdNTWVjM3BP?=
 =?utf-8?B?Rjh6L3hwK0ZIcnN2aFdzZlZVV0FkVkpHQzkwTkJHbmhyUXBlajNUbzltbGJJ?=
 =?utf-8?B?UDVCTm01M0d6WlRZR3ZUbUJJVTgyMDZzT3hROHFwd1huME9QSkdHd0Q5UklP?=
 =?utf-8?B?cm5IZlZSTWZkUk5VclZUZi9obWx2VFB0YTluMmlZZm5QdjBhUUNaQjQ5c05v?=
 =?utf-8?B?cHVabHppNXB5YUpEbFdDWlhxNlYyMDh1OHBwek54WExIUTBWT2Z0VWJxRTFn?=
 =?utf-8?B?cjZFeENpeEZYWFcwV21jeDVUYytZejNIOFdlOHd3OFozSENNbC9FenpVb0tZ?=
 =?utf-8?Q?3LPMkn/t3eWo9kE+lYUYS6gh4cABi/o3on3wF?=
X-Exchange-RoutingPolicyChecked:
	AuuDvnonvBW70vsc0oNG4LwRCKVbzcTTU7a+V28+TJjrHL9WdW28vy09TgaEFd4UznI4Mm8AZ7KuU26haV0vrIMtXb2ijDiEJvalv7BlcQBs2TR+Zai1KTBpTCtLPQTr4n6m/1HhTG55Mw3nTnwDSOUzr1sH4DMGIdiod3EtLy0SFRy62h/1myZ83HIftmZ8luKDq4VdjQgraf3h3wegQn6xhh4sH4RfE3v7JBA9B/y2IpAXLmC8QjObaj8GmBPGm9mibNYQ8hKYQ6LdPMVR2RXDzE09CqOhJ5rClIDu4qsEUVuR/Nk59g1mRYeWP134EmF8q1RYcXu9M8SJDhbiyw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+1eNccxLe6lPK9omGSZLSx2kFWP69NcpfLkGuI2wzCe/0Snj0Om7JYbMdAHrLxu9THfQaeEiVd3fC6UMK1PCBzZf80dzg3oXGocwT1/ym6/dKrCxQtQgQabN0pt4Z1P9N1RxjlLTvkq+fmjqdfz5ZqB6TjUTNZ74MOdA8F5piFcOpQ2mMlTbhjtn3v3VeAzXTVOiKLYLvbJkl/lETANGWFcAJfHg02tij4l/95/4cYqs7ZohWVoJZeIXXDhD1bewvUR6b77pKpdE7l2+RsihT9fZYl1wtIoqcqBHzAblDU2xQxCEkxsbEzTuZVRZeSPSl46nT6zJJ2zXnPU3QEJ6TCPlDBofH7tPitw2kvY71d5qRCPUZqhXtdhgXo4tsqK4Mz+8QIIRLfzY2ZY5UNiLpFSXl59RuT4PL6ZtpRhqeVtaKn0aMyqq5EBwfY30krc7tdFM48bvHOQ3aMX+0Y6w/VETBfaud2EG5i4FIEUR+F7BhRb3RkFP1ru9T9TUxu5U0aQ0pzFirY0gK/HFNjDGEUzFSVCV1bR9PTjmJueumkCSHP5LKZdyH7Ae3FCT0YSkGeoscEEeVA8MSMO2GXgTi1vNfnNTRz1qBGJWNkQrS2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a1debc-dcb7-4e41-6d27-08deb7e884a1
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 09:57:22.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r57q5OsXrJWKYsY/d1TypPMugvhlQ7zZy1Wi2Sogkk8o1mDfzALkucmhr+A9nCHN7v6F5JBU4KQN6z/W844xnDqOPQSA1+RKGVsOSK/XQyq61XvX3scDOxDd1SGg528m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR10MB997927
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605220097
X-Authority-Analysis: v=2.4 cv=UOjt2ify c=1 sm=1 tr=0 ts=6a102885 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=pGLkceISAAAA:8 a=HvvHtwdB2HOY62bBbaYA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12299
X-Proofpoint-ORIG-GUID: a3TzTdzpI6IJ3AKqXL1JTspNrrsUWwiH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDA5OCBTYWx0ZWRfXz3Bl1rfQRth9
 MgntV4gLBHOqchVUkfzB6v7O3/hCceS1B/dzXGUS860w50Lx4DG5VTF6vPpzNnQInyZ1AB2KXSn
 tAhQHu/PEbAdqJqqfGTM6sgjErX6ErCoQVOkSOHBZvBFjQ5k2LyfNkJRZ+yuF/nazfX4NN9oiUm
 H6b/uI+iksxmr/KJW4ywlIjVHfgyOZnGoUb3YdLsQChag45T8zoMbQU7E4hRCSmHH+EId10e59h
 +8cvDD6gH8Frnwi2wqx+bhnJmG8p8GGd58E7kASf1zKObhg3xqbFdOOwvNTpf0A8nT8qW5edhL1
 rG8jCkLhUZHUuBOJhejpUnl01FQ0658098G2S49jAn5pJrWH/Xd5rMnG9acGBTMA/QuNo5VJrkH
 UCgFs8v6urX6hcmFT0q3xJye2YTxDe8gG98vMS9lkLzQRVgT5XAZQT+8JLUJs92Ni0dSwrH82E4
 86dD7dPyrSLYQA4DpUjfOJSZoxMFnO/73rUG7lL4=
X-Proofpoint-GUID: a3TzTdzpI6IJ3AKqXL1JTspNrrsUWwiH

Hi Greg,

On 20/05/26 21:49, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Puranjay Mohan <puranjay@kernel.org>
> 
> [ Upstream commit 46ee1342b887c9387a933397d846ff6c9584322c ]
> 
> bpf_flush_icache() calls flush_icache_range() to clean the data cache
> and invalidate the instruction cache for the JITed code region. However,
> since commit 48a8f78c50bd ("bpf, riscv: use prog pack allocator in the
> BPF JIT"), this flush is redundant.
> 
> bpf_jit_binary_pack_finalize() copies the JITed instructions to the ROX
> region via bpf_arch_text_copy() -> patch_text_nosync(), and
> patch_text_nosync() already calls flush_icache_range() on the written
> range. The subsequent bpf_flush_icache() repeats the same cache
> maintenance on an overlapping range.
> 
> Remove the redundant bpf_flush_icache() call and its now-unused
> definition.
> 
> Fixes: 48a8f78c50bd ("bpf, riscv: use prog pack allocator in the BPF JIT")
> Acked-by: Song Liu <song@kernel.org>
> Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
> Reviewed-by: Pu Lehui <pulehui@huawei.com>
> Tested-by: Paul Chaignon <paul.chaignon@gmail.com>
> Link: https://lore.kernel.org/r/20260413191111.3426023-3-puranjay@kernel.org
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/riscv/net/bpf_jit.h      | 6 ------
>   arch/riscv/net/bpf_jit_core.c | 7 -------
>   2 files changed, 13 deletions(-)
> 
> diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
> index 1d1c78d4cff1e..f87bad9a0578c 100644
> --- a/arch/riscv/net/bpf_jit.h
> +++ b/arch/riscv/net/bpf_jit.h
> @@ -11,7 +11,6 @@
>   
>   #include <linux/bpf.h>
>   #include <linux/filter.h>
> -#include <asm/cacheflush.h>
>   
>   static inline bool rvc_enabled(void)
>   {
> @@ -109,11 +108,6 @@ static inline void bpf_fill_ill_insns(void *area, unsigned int size)
>   	memset(area, 0, size);
>   }
>   
> -static inline void bpf_flush_icache(void *start, void *end)
> -{
> -	flush_icache_range((unsigned long)start, (unsigned long)end);
> -}
> -

I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:



on 6.12.
$ git grep bpf_flush_icache arch/riscv/
arch/riscv/net/bpf_jit_comp64.c:        bpf_flush_icache(ro_image, 
ro_image_end);

Upstream doesn't have this problem because this call is removed in 
commit: 6798668ab195 ("riscv, bpf: Remove duplicated 
bpf_flush_icache()") but this is not present in 6.12.91 so I think it is 
incorrect to backport this, should we drop this ?

I didn't try compiling this on risv.

thanks,
Harshit


>   /* Emit a 4-byte riscv instruction. */
>   static inline void emit(const u32 insn, struct rv_jit_context *ctx)
>   {
> diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
> index 6de753c667f42..fe362030ed2a9 100644
> --- a/arch/riscv/net/bpf_jit_core.c
> +++ b/arch/riscv/net/bpf_jit_core.c
> @@ -184,13 +184,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   			prog = orig_prog;
>   			goto out_offset;
>   		}
> -		/*
> -		 * The instructions have now been copied to the ROX region from
> -		 * where they will execute.
> -		 * Write any modified data cache blocks out to memory and
> -		 * invalidate the corresponding blocks in the instruction cache.
> -		 */
> -		bpf_flush_icache(jit_data->ro_header, ctx->ro_insns + ctx->ninsns);
>   		for (i = 0; i < prog->len; i++)
>   			ctx->offset[i] = ninsns_rvoff(ctx->offset[i]);
>   		bpf_prog_fill_jited_linfo(prog, ctx->offset);

