Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF323FC41;
	Mon,  3 Aug 2026 05:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785733749; cv=fail; b=KkYLPtrzTuAcO3QwfQma8+BER30in1ebee4DZYwPo0PofV5AbVz3oCs2PGta+UTsRYKKH/AdIYFDCatYD2YEOdibel/N51MES8EbHvJq3jWjU4lEqodMFLeIXWXOMJA5gpaOcAK80iCAGBjuc6Lvdr+iQXkakNzdHqC+iB7cohg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785733749; c=relaxed/simple;
	bh=JePpKsZez6XJ5/yBlD9pm/cP5tpOjFLJ4jVAzwrYpq0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YO7dJ2mmRGor6/7Y0c5kJkVYh9SsLK8sms5RC+o4i0FUItpC4RqnXmDC3g2CaCBNU5CUlfEUvrDyWEJzWl4lHZEM4b87PRh27fZM554c45zWhymMgWz9fOqbVOENng6ZeoR5DahYVJzILMh7i8Y+waJI7wJpyb4/s+3mW2ix69w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n00y5W2s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k39hqwui; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n00y5W2s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k39hqwui"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6731Ed0D1817572;
	Mon, 3 Aug 2026 05:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3d2M3+jfZ4qLrElyes/ucHQdpzEquU+P9Utgj5GJKuc=; b=
	n00y5W2sAb4a753fxH8PfR/E/d7plPZpf8O7p0RuqatFKwBJMxf8+6nKdsffot0/
	MmVcHb21uTzcjW6lYM3gpv+ReNuon5VdAQfxfNt8866ZOHaleiQioXKYGlagfI2O
	ri90ApR4JnUk3jyXVi6oLjctHczvv0+zgw2NGWndcOYVYW8aC6X/iKqpAwL+x7l7
	20WD8H/B8dCcd10y2A2Ck1YNzF2Qv6p81WyrH3atf309wVCYbIWEeHE6H7PHkH8y
	1NVpEIKMKapfeRNDMyKAlEzJkAWSqMFPgRVfaWwnKv99px1vdNg7Mqncwb/4mQ+R
	yOc9swEFZTZxikM1v/Xrpg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p932u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Aug 2026 05:08:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67354t61017821;
	Mon, 3 Aug 2026 05:08:30 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012001.outbound.protection.outlook.com [40.107.209.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fs788tnuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 03 Aug 2026 05:08:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MVuQS+pva78SPRs55XDGPlFCVS3RQMynr9BzHHSpiqUn+qhvP61orbUqiH8v8OBOA3QCzufiJCr4ZDxA+t/vmnTPS6aZxq9LLyOqBGzKjqJvMNSpZwGmSqubpzf+1R3HUx/KDFJ0Xnbf/0mjEp7HFcyO3Jbc9BfeA5klv2Kzj83HLnghTWcVrr0RnrJ7TjzYnzLy2TQjzpNRMIjZL9hl7IVwGo7ZrACIfZgv0iGtkSjywlYZ0wghHvIpO9aIxlmzsN42EtCZOt5dS3MscOiur0kAH5lObY2zPDopMffBP+MVuPBZn4P1XbCwtPD9GWIKHDF4HwSWS+u/vx+BwqhRxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3d2M3+jfZ4qLrElyes/ucHQdpzEquU+P9Utgj5GJKuc=;
 b=AEve9zoYZmKCo+FHnr7YIx5o0P4paNzFam5QA0hocJMCBDtOKMuK5YuGA+/G+h457Z79kWp7cy7X0iMFsOp8byyqHb3TLdI4Aj2WIYQjm5UyiQs5QU03sUJRZCmdH799V5SfNIH0PPY7cO+iQqdLlFLp5A38xBUmpd3LK+NqR27BfSy3K4iruLsojXKZQPuPJ2YT32OUl0txUxhWzpI9sefV+sZguC5PMb36JaSk592a3nFF6htVtu4lYsVWF2nR05TqA6GPZ6uv6YyWnrmhRpfahPLjD3C56UUvKCQvYUam1MxqmIDulcYuiYB4qggR42LuzMWx1Sj6FAwUVZgQYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3d2M3+jfZ4qLrElyes/ucHQdpzEquU+P9Utgj5GJKuc=;
 b=k39hqwuicWnlHl03Zc+Pt54kAN62NqXEp/vAYZdGalzlRKYb/oEUixuW3xaIIY60QrhVyCYJDLLQdTCgRj+xgrePtCQQ0p4lIazAEPJh8kmMzqdxV2X2emCJKi1QM5qmGih74Pf78IHFptFT9nXZIbNC84GM9LG8MmHzHVc0t1o=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LV3PR10MB7844.namprd10.prod.outlook.com (2603:10b6:408:1ae::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 05:08:26 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 05:08:26 +0000
Message-ID: <11d7b24c-6bc1-4ad8-9ef8-0c9fb96e36ac@oracle.com>
Date: Mon, 3 Aug 2026 10:38:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 528/602] thunderbolt: Prevent XDomain delayed work
 use-after-free on disconnect
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Michael Bommarito <michael.bommarito@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141447.107046386@linuxfoundation.org>
 <2eae07c3-848e-4bc8-a444-f8274692f653@oracle.com>
 <20260802030150.2c5d2d3c3f70@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260802030150.2c5d2d3c3f70@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::9) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LV3PR10MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a095d8-622f-4888-8de2-08def11d4008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|10067099003|5023799004|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WqqtkheJFp1mG5es7H/i8394Ep3SnW/DhxoxSaw28rU2KmkC1hvaID2Gyzd2YHVsaEW7/PU8zRrZ2RQJBlK7RSVNJ6Js5nAvc7R9G2eLR99fDI6gnUehNUCbR9lH4FwsU9d8YyABpkEFgnEHETd/dtC1mwj+MbssH+kBxxjRZVVC2kjQzHAqRKq8PDo5j2JQwYi7frTt5rYOZEz7auhKC7mSVjwFHtS5/4w8Tx8ZoK20k0zmWsZYPzkrlOAduRcQ7X0jwvUPdYxPKO3fJSSHV/byNF91Hv1b6dqY5lswaFAFTaSQRA9hhcpD5BeTNP6/q/TDnsGJjQHWj2rLdp24/Z84TdMmU6FOL1IpX5EqhaY3KL9vY1OZln+gbYmcuBH8dz8MpToBxDylO1J2ZQX3TmKU3YUms4HXvLUuL8jnwr7pn8VL1/kc87HkLQ5ZNP43wRyYZhSqddh1AGPmtWVrqAVnL8iMFB7AjBi7u+WQgGY5O4YyW8CQY2sWtRUCmahtxj7OcbGX6Tnw6Xirf4aQbcuSzYfN3r3XT2gUt6BECGReNzIn+GX/b58u6EiCf79ZmOPFOKvNPo512S7j0BpYB7doxc8Kq79v5SDdT2KBbdqM5V7kSoxyX4czJ1I+El2C/o8f/B+3h0YwvPauFF/6vSKTKBW7/+RuQPqYeCFv+YM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(10067099003)(5023799004)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejRIdDluc05iVHo2Ny8vRVpWME1obDFyOUFWa2hRUWRQdk0rQ2RibmhsREVI?=
 =?utf-8?B?cXRZUGdFMUh5TW1NcVJPUGZBQ294a1BtSzd6MFArbkRYSko4VUFFblM4Vk1V?=
 =?utf-8?B?Y0pQMVROL1o2c2p4WVdOZ3BwcG1jOE0xT0ZoZ0dzVTJWQ2M4UVhNeDVPOUwv?=
 =?utf-8?B?ZzRlbnU5bU12SHBVVkJaMFhvbU5MY1p5bkc0QVNjUWpzTGZocVZjN3RpRnpJ?=
 =?utf-8?B?c3VpZHJTVHpGRkRQWm1GUnRua04xUktFWS9Eenk2b1JNUkRZYXl1NitOVmVE?=
 =?utf-8?B?b3RNb25FemhkSGhpVHd4ZWsySE9ha1lCTVl1SU1LVXFBQ3FDT1FlT2JhYmEv?=
 =?utf-8?B?SnhZdE56SUZ3YU1VWjlPekpVbFgrWnNUbDZMWVNPd0IrMExiVU84c3R1SHA0?=
 =?utf-8?B?YWdiSm5wV2syUGpWMGlsWHRUVThQT25nRHgxWjdLMHpDSGpqYmlINjdNR083?=
 =?utf-8?B?bDZRM01Bbk5iTFN5emNwQ25DUXNKUGV4TWhlTU1RQjZVM1U2TWRKUmErbGx4?=
 =?utf-8?B?TlVvQ01IS1huSUU3MnR6d216MytPaVkwUSs2b2FYM3hycG15ZisrZUhiYTIr?=
 =?utf-8?B?bVI5VFJ2MnhnQ3FpRE9FNFdzeEpudlBRQThMOEQ1MTJDZnJhZDlQMkVzSWQx?=
 =?utf-8?B?YmJHMlBDdXhaVTg4cWo4ZFNpTitpL24rWkVqTm8zVkx2bUwvLzlnQm1LcDVa?=
 =?utf-8?B?Q3hyTjByZ0tZdVBEZmpDUUUyb2VaL1lLSStvRHdOQ3NTaFpxQ081d2NmYVBx?=
 =?utf-8?B?cDdJU3Z2NVF2WkRsak53RGp1aGZiUjNGa3JKcWNPdDhUcDBraVlaZ1JWUGxa?=
 =?utf-8?B?STlTQmhGZ0ZEOGpMMk5WY1UvWENpejNiQ0FXTVVDWU5wMWFFcjhzOUQzNVAy?=
 =?utf-8?B?b09LT1YvejkxT0xEb25KSWdWeHYwdW9GMDQ3eEVRemQyZUpJTzljbURmdFpG?=
 =?utf-8?B?S01jeDhybDMvVSs2Q2dGVS9QM0tEckJCdEdhWXBubStLOXQyUUFMZThudk9a?=
 =?utf-8?B?WG01b1k0eEJmaFJiTFYxeGhmUmp6MlhnSngxc09CdnFvb1FjY252VWF3QnNx?=
 =?utf-8?B?bEZWMUt2ZmZtV2MrZVlrMmt4aGNtZnZBaDZTbGdUM2RlVUNISDJ6RnJMc1Ix?=
 =?utf-8?B?Vnd5M1M5RlY1RmIrcDVUMjdNQnVuU0hVSVhxaUVBUGJsaU9ES1pnVG1rNE5a?=
 =?utf-8?B?Ry9rOGRUQ29mMUM2bUJFa2xXazFhbXZxV0FJckpDT0ExY3lLUlJmcW1uSkZW?=
 =?utf-8?B?SzNPMzNVd3ZZdVMvaXl1bWkxRS9DQ2hLaWFNak9HQW9EdE54RHFPOU5KQ2pX?=
 =?utf-8?B?SWpacUd0aXdxbi9idnliOFRDME5PeURCdlIydldQdVF2ek9UWlpXZjJvOEV5?=
 =?utf-8?B?VUNvQlgybGE2RFExczZXU3VFRU00SW9YbjZKQWNVbjN0a3d2YlFIUTdJZ2Rh?=
 =?utf-8?B?UGFJNVU2ZjhIalV1V1hTMFY5MHJQakd3VmRBTjRXbnZFWXhjcnRYdy80YlhD?=
 =?utf-8?B?Um0vOWE3SU02ck9McTR2Vy8zazR3bWJzNlM2eXNBY0ZENmZWUzlKZ0Z3ZVVm?=
 =?utf-8?B?MzJyWTlTWVJJUS9rbFB4QXZuQjU5UithZkdLUE5ONHFNWVE0ZGI2SU5BQXoy?=
 =?utf-8?B?b2ZLMFZ5Y09nYnU4ZUV3NFp4cHR6eVRManhCOEEwWG5zUnc1Y2VjNGp6WmF3?=
 =?utf-8?B?YlpqVTl4eFh3d3o2TndWRFM5SVNXS3BCRnFWVzh1clBKUUV0YVJ3WG5OV3RR?=
 =?utf-8?B?dDZwSUpqV1RiM2dPTTNPcXNUMjMwQzBLdGcxTVdoOXlqdjZoeXlGRG9ld2Y0?=
 =?utf-8?B?ajVnaEpuckNUMDZsaFFkNTJ0SkdRRlh1bXJOVXhiK2gvckJFaHI4ZTNTZmo4?=
 =?utf-8?B?bkJNTXRkamx3ZjYzdDc2QnRnRzRyL0ROOCtOT0VRcUpMY0YramVNNmN1b29F?=
 =?utf-8?B?NUtVb2h0T1c4S293WmlnKzI0ZmdWM2ZEMlM3MDkwTjFOS2tNZlIyUFA1aTA3?=
 =?utf-8?B?SlQwRUlwZDV5VlBMUjdSRzUrdU44TVJJTGNEenZvcklsTjlIcmJBYjFlRjRN?=
 =?utf-8?B?UTN6TldRUHI0Unk1LzZKOEplUzhPZ2ZjclE3eTdBVk5INUM3dG9HS3ZKbnhX?=
 =?utf-8?B?VFZ0Zml1QWlYOGhZRlQyVUEydUNQK3RDZ3FBVlFxUUZHNFhvai9pQVBhLy9I?=
 =?utf-8?B?KzdLQWJEODJKQmhPbXQyY1ViTTBBcXpjM3BHRm8wSkM3cXd2QjhtZ2pmTSt1?=
 =?utf-8?B?bnJ3Sm1XeEM0UVEyYkFHSkZJb0pGd2NydmlhaUdIK0RBVzZoMDE5M0pTQjZX?=
 =?utf-8?B?ZlduVURldkFHUXVXWi9henFNOFYwRHhVY1hENmtWc1JEekYzMjlWaXJnOXJu?=
 =?utf-8?Q?QYVS3VTe4owzji+YEPtZrw38uASCbvQDPHbs4?=
X-Exchange-RoutingPolicyChecked:
	NrNrJoqchGHL6sPY1AILe/3IqvtxoDUS0w67yeg11XsTSD+OTGF+GFQmQbvCe9GX0C0RsIL0Z9T2d9FNnaD/BFQrvRQQ+QUoAOQLT85Id3ryjZK8TZyDL6nbeYrv5Bi/PoLipHI5Y4wrykBSfKlVifEuKqmqeVgnSYDdIvFP/Y542KguFi4Lwne2MqW0MzDrYeEuUmhhmEhheLlIxSLv114RkSwoBt+Z8heJrivYCiC0Jutg63epHAfEANYRlC8e1b3fgdMoTXSF7sI3f8SRZYSYcYnivtTpGYeAPSQuvMzYb/YEeggeGRDzlV5wN9BiGD1BgOf5X7vweSepJHy0yw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u6rMYklKdTKceuHPFO58S/w1HdRbKU9hHlpfAYdLgFUWUCWOT8dnw+rqEATOi2/Dx3AUMBDizw+xe+WxRK/eH/thHx7HRZycqW0L2VarMwWh0cOl4lHzREzjJgszp5A8fXDv8zHGtooFFZXiMrTaa8syQUxtNNf8Fzr0sSQICdmI62eCONy9eMcbPGcS/HpG+wct1ahwx/IpP6UCbp8YIWjdcn7AiwIPs0G2DcUmdBSY6ZxJyqJVePVyqWACF2YVSEvp4FXZKtKOwUeKSXouocyQcrOYF0KmCBP3Si6ayfG40FXNjJr1yNkyziPBaPxzlQDvtgJHF6zT08J8tnCdPqPg6smPSjoI2Am+8b8K7K829T9oPI3wiRZz3K+CbULbKyXjwUrkT4eddTUQe1+m2BPvTI90cqXbYk59ihdT9ZKcU1qLFeTm/JG4e3PaciBvgo4ThFjswmdIZEpxf7ma/jVuG+Jgl5xXCEOcYLD/RoKNF7uVxZSlLU2sHe3cVHFJKFv9ZUIqzFQDeYAHTgsc/CjNYMOCXM7iXgiKI1hHrbqaLMuPnU2DIn0QeSZYuodYkcVqDEgX1l5b0dX+3qkvH6GNm8KEHSa+UgckSANtXx8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a095d8-622f-4888-8de2-08def11d4008
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 05:08:26.5561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 87MdyIjpeBvAt0Lo/OsTRSj1hc2nJXznOUByf24i2pNInPiX17/wL+MAtRKSQ6OmJJeILQarQlOD3maNmHDjDdyyxDr2DlnLWvaajLi1JQNgKVgQ4P1xjtjEw465xplD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7844
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608030042
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA0MiBTYWx0ZWRfX7kAZzYt3oN6a
 45FoxPcI0dYIdXP5pMXNZSlUdi+GF+dRTJ7xFkXMyXVc6GjZbH0ly5gMkqud9SZ8z1f2h/DA7VN
 YithKcWbwyUYNSzwVpvBq7Fnfvjve+1VQQpnEnmr8P4lNT4pyvgc
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a702254 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=T22ZgWjnt2c2Hw30pvMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: -I5DLR-uqNLf0erx-FGlXPCue8zDHIlE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA0MiBTYWx0ZWRfX0xmX2a9QadOF
 flS+HL6EVoUXM/H07RavfhYMtcMhV/PmupH4Iu+FWdhEsUP/DVG+8jw26Mm6FOIsHspduC7ftiG
 1YtKXf9uA17f+pZBueEl3QBiogZnQPSBN8CXAet+opU/Awaw3idFBpA+S9hfTCmkfN5k7dmOTlD
 al1rj/C49fzICXdLdN5CEQw2IW0GH9aaEKx9F3Zik6QguW+vN1dIsC03W6cWNJT5po3hq8d32cB
 HsTtzncc6SeQ9X7VmwQOiB8nTDd9inYXtJurv1mDlWUoXpqTuRf/o1kppoNImPX8Gqi29fi5BiD
 MX7QK+NAoPypXmcQRfKl+vfxFQLfqQFw6Z1j33LFvZvXPhlhYvpm77am8r1fXu4Mnc6K+OXqXyQ
 NAvCDlm4lpS3mRg9ugyqmYgQr5ZJhDImr6GWIax/J8qrURkjKc5Z2NlGXGne//nB/7B6FkiKonU
 +Z5lezef0A9PPZBnVvQ==
X-Proofpoint-ORIG-GUID: -I5DLR-uqNLf0erx-FGlXPCue8zDHIlE

Hi Sasha,

On 02/08/26 8:45 am, Sasha Levin wrote:
> On Sat, Aug 01, 2026 at 08:56:42PM +0530, Harshit Mogalapalli wrote:
>> I have run an AI assisted backport review and it spotted an issue. I
>> have taken a look, and this backport does not contain the fix described
>> by upstream 2c5d2d3c3f70.
> 
> You're right, and thanks for the careful review.
> 
>> The 6.12.y commit still has:
>>
>>      if (xd)
>>              queue_delayed_work(xd->tb->wq,
>>                                 &xd->properties_changed_work, ...);
>>
>> and no removing field or guarded request-handler queue sites. Its diff
>> only relocates the unchanged update_xdomain() function, so work can
>> still be queued after cancellation and run after the xdomain is freed.
> 
> Yup :(
> 
> Dropped from the 7.1, 6.18, 6.12 and 6.6 queues, along with the full
> prerequisite chain that came with it:
> 
>    - thunderbolt: Keep XDomain reference during the lifetime of a service
>    - thunderbolt: Remove service debugfs entries during unregister
>    - thunderbolt: Remove XDomain from the bus without holding tb->lock
>    - thunderbolt: Handle lane bonding of Gen 4 XDomain links properly (6.6)
>    - thunderbolt: Remove usage of the deprecated ida_simple_xx() API (6.6)
>    - thunderbolt: Update property.c function documentation (6.6)
> 
> The actual upstream commit applies cleanly to all four branches, so I'll
> requeue it properly next cycle.

thanks a lot Sasha, as you know, it's very useful to get this fixed 
before they get merged :)

regards,
Harshit

