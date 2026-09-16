Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2354843CE71
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543971; cv=fail; b=k1k4kcWKgMfHTLlmhkOImfy14zPui8MWiHk7eDBpF+Cq+ih8ksWtRd5nKZUgENuXyVW5zQ1RMxo+CndikYWDTs5ISSdLaoFCZeKfDXanerySVNyuar+kbi12FrMd3g+hNzg4hYkZFC6TqxtojzSdfRfKQONNfs/9jvjyGg+yzyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543971; c=relaxed/simple;
	bh=pSWs46yTmDCdQdMaqe+3NpmxzLtdM5gvzH4HKzX14cA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oJO2FKXYOLXwXsiJLvJyJOClugJcGh+VtXwnsIFXvqv7c35XbnB6AiOA1FHopsZo6Jr9+ZOm6NZf00nv01lO+CaTwHK0VVwn1RVrghQBRg0oiaoK+w8IEfNXUoE0rKeTWa8luO0lW8dN+ZIkmu6bpEqfxXs61rkaRhh/tY2LOsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j4I9OFCp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AbglOYMd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j4I9OFCp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AbglOYMd"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLY73N1308461;
	Wed, 16 Sep 2026 07:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=snZpIm6FbibZCx9C1fKgQK2iyiiyo8zfjx21vhlmxoQ=; b=
	j4I9OFCpISZFVr7E+GprF0NMZ8nPgrYRGzdpQRa9LAly4V/kDjkvy5D7w1kbjLCb
	51gGA5eKxSpdSdx6hlcmx9vT/pi3dEKKwVm/+NFkXfO2hakDb06lmSzqVRYMtX2t
	7RQkMIercQNL9CcN4nBOAsoGz62GCoq4RFbbkhTduUuBObwsJC8c8LC/XeXgF4+E
	DiY6ZvQoPRG6u/xvtZkjg4cjBt6Tuw294KJbTusLumVg/FlHZCudssuztutyLmWf
	p3nLFXcp4idYCuHdU2+950vRBXQtFGCQHnTdJFIbcGRzFiCNDj4f+aqRKgNnYMdz
	rmJpra8v4j5cGg7i7AQMHw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn954nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:32:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7Tpe7009958;
	Wed, 16 Sep 2026 07:32:30 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6b1f6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:32:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPKt1l5Gkmpg0qFtYQahJkCC638pBeNFdnlFgjqfl8BBboXHF//GS6akqo5h5yf3WIi2m5GbraJOqBHLhlSfgNCwQNv3KBqgyZT10bumj0qqGbBZBhCkn8kfIMO1jBGoRd/2y20cAxV8HjgukYSdht3t+R6ZBB+4Krny6Edme+26ZXhkxYODQD3Us34f1ltARuec6JbCNEjLKkjP4xENkQyYntSdsDh97SkiS5Fv9uLqAvOChFHLDvbfdYgMuI8UGTcPIkzUahFZ2vznmBR7dt7oO4QD/fT6liyKurezf1oWx2E7PXkv0/dwPpqfudZIqaUtycpJHBKVmXBlyYrrEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snZpIm6FbibZCx9C1fKgQK2iyiiyo8zfjx21vhlmxoQ=;
 b=VDvrdGNwTUoSc+QZZBWGNlt6GZd4nW9yZQNIRri/eSad5aVcarpkhfRF38gEjrUCD3TnwWUjez2Sedkfio+l64+GeeFHd4kN+0cFYalH1XywKb0epTFp8STgKbIUOGgGPJlYhuEiK1Vd3Q8dV0Xz4A7FNH5EUd8h2d8uA5kJe75fvFqF8cOXqo85c/R3WAh78vq2KK5ADRd6/3IzV1rcjsvVRuffYvzB9gOYtke6RkLztF0oQyXke5UCK6LgAVPgfk3Zemu5R9WuKuYrExbGNM9upHcuobKCBGNOZGQ/tHeklq38frOZ5jjjuSbZ2625YY3GiBtWUicsgCT0vb0beA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snZpIm6FbibZCx9C1fKgQK2iyiiyo8zfjx21vhlmxoQ=;
 b=AbglOYMdDjM4ioRVM5jXzN5FiWgoCwcmHgAEEN09zZaGR+e8sIFrSCe1LxFQNxyMt4o22GKNSFpKYeCevZ/VJpITMV/07r/Cif32FnOztRl3jyBsSEY1LXAhiFBoXO1m+DkYXXjL8k0vLadcK7u+qSUZlT6ltVAyC8VTacPDtow=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV8PR10MB7991.namprd10.prod.outlook.com (2603:10b6:408:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:32:27 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:32:27 +0000
Message-ID: <e2ded0a5-92b3-44f0-863b-704c8ef0e4d2@oracle.com>
Date: Wed, 16 Sep 2026 13:02:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0590/1376] soc: ti: knav_qmss: Remove debugfs file on
 teardown
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Pengpeng Hou <pengpeng@iscas.ac.cn>,
        Nishanth Menon <nm@ti.com>, Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065620.683355423@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065620.683355423@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::17) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV8PR10MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: db981ac7-513c-4b1b-9227-08df13c4a8a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|4143699003|56012099006|5023799004|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	C9MUQ4axCqOqukv7YsNCcOSpp9H3wRYAKJx42lqpTObVD2DwNdf/jWL36VAqcmmy7KC1WXmlcQ+ND+q8bxoA/lPaPCRCwAKNyM1nRRgsGx7Lwmz/F0B4S8HDkxC1C56tC19p2Lh/qpFctXAHT04VBKRuRkBHL015dBWCXV0HTF5CARsWdIutGV2S2dcTYybvgTU3SeV2NtR0qwP+EspmNFWnEKGG06Rg2ingt02dd+DXz1zn1JL9pMGv5evRMXW7KTtvn1FMvLtn2oTTa1wSXJKf+367nheuAdHMdp4720J8+xFEfS+B+rCwF14PNAqB0ZYkJn8s37qmLvVHCGSQOIUhhpAAusqQ7WSQTVY8wL0xOfYDWQ6geJFQ3vqRYVTMqFUHiQT4nURR9fWsHtHZBAisMmgNT5v1495ZzEX8FanUUYuBaa8py91lbyDlWhMtAofEtK0za9qkBy0q6gDMVT7qUuBs1Sl1wvuIDtZX36verc0XjVBvzAbNlKRmHYF07qzr3HFzOtV23+zc8BlFy5SqgM/RBH6XPHcmNmxs6rEatBlorW6ocWhiyk/0bEjEadUZrQbxBj0RwT0/zeb81HW5bYhG2hTHyRQbkGjqTarDhq1iILYypFpACjqcuK3E
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(5023799004)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFB3QVN1V2VIV0tLRmdxeEcyYWg4TytqZXBGelJEOUsrOXVudmJNVksrcmQw?=
 =?utf-8?B?cHoyd25UOVEwUlp1YzQ1V2w3d25BdVN4VG56bEU1a0VUajhMSHdKUHczRmFH?=
 =?utf-8?B?S1cwNHNnL2s0azNKSVZJQnJ4RXowbmdEem9uS0VqT25Caklhdjc1NHE4REVu?=
 =?utf-8?B?VUxzSGFPYm5kNjUrM3pMWitIUnJqL3daZEx3SE02U3Fielh3eE1PdFZ6aGh6?=
 =?utf-8?B?NjdxY2tjd3FPVjdUSHYvVDM1emR5blcrTlhDMGZLbmVsdEhFenZ3RDVZdU9U?=
 =?utf-8?B?dTcxZGRsMGN3SUV1MWJZdUJDUVhIT29YdmFpcXU2emVHTjM5cVJnSWNzamxl?=
 =?utf-8?B?NmFtTGpMWFVzT0p6Rm1jR0Jsa25BSzRieXl2d3BCZ1ZtRDJDUXpXTmZIaVYz?=
 =?utf-8?B?bzdoQWxKMTFZQnBsZWY0c1UyK1k3UHZRZkxCTmh6R1NIbkpMWTI3WE9ENWJa?=
 =?utf-8?B?SVNFS0diYUpxUjZCTWRGRUVCOHJDVTdoREx4TytrUWRZVStXcWsraXJlVG1K?=
 =?utf-8?B?LzFjckhMZWxrMVh5ZlJPMzRvcXpUZHRoSHRLZTNvRE9HdEV2Y3FXbHNSeCtn?=
 =?utf-8?B?Z21VdGVhTmNhazdReDRIL1Ureitpb0RTbHdobmFaTGRUeGhCOTYrTzZNcVE3?=
 =?utf-8?B?SGoyeGNiNGl3cmpUVk8vcUFDejNOQTBPMDNRc2RKWXNIek9SNm5VL0N6alMx?=
 =?utf-8?B?YWRoMEIrdVlWT2tvSFN6bnJQdnlwVFp6R2EyOGZOcUkzVHBQS21xYkZ3WmR2?=
 =?utf-8?B?MkxDOWNWdkk3dUwvQTlzNXQ0K0lZN1F5WmtlT1NHakY0a1lGWmNjdmFDdTZy?=
 =?utf-8?B?RzhMcWE2UlpsY3dNMUVVOHNYTCtpVkdrajNNMlc1WGlnQ2JIcWtMTkowRTdz?=
 =?utf-8?B?bGQ3UnRqY0ZYb0ZiSWxyd0Y2OVFqUEVVVXIvR3VGSnM1azJya3BsYWVPVFdy?=
 =?utf-8?B?YTJ1aThJZmZkZks2MU5HeVp1TExPMnI2L1VQZG9jYUhQeC9rbUlVK25rcUMz?=
 =?utf-8?B?ekYvR3hpN1VmUGl4UHVBdVl0dUU2NTRaQkVZSzV2QWh4cnFZcnk2K3JPYllz?=
 =?utf-8?B?TE1Mc1NzWFVEdm03T3NBSldDK21INTVkZ0Z0RVE3ampZcGtWVXRXWlI3dlJj?=
 =?utf-8?B?d0trSWdHMXh1ampPV1dxeEtZV3NISER4LzhNOThES2FVdUtiU2ZEc2RYazlC?=
 =?utf-8?B?ZXpXV1BUREdSQ1pXNnZycFB6QTBoLzNVRHJjY2M5eUZ5QUQ2bnl6L3Q4bjY4?=
 =?utf-8?B?WW8zZXQvcW1LbWJySTdLYzFlYk4zY2NWL1ROVElFeHIwWTNEck1tVWZFa21L?=
 =?utf-8?B?ZWRZWFNDYzlBWXJmU3RCaDBtK0xTTWVDcWgrdzRPbFRLeWt4RFRUSEdoOEIr?=
 =?utf-8?B?NHpQM0NMNVIwU0k0VkdJZGo1MUxycGc3S2RJZmh0N3MzUFV3bnVMZm8wOVdR?=
 =?utf-8?B?cHhMTnNPa3h0SDVqNHpzQUgrZkVVUXRHU0xqOUMzaTBSZjhYTVlYRVBISHl5?=
 =?utf-8?B?Mk9tcExrRE1hLzBFVEFFd214Szh4M3YzSkJKSTFKY3NBeW9mNWJNV2pONVpI?=
 =?utf-8?B?ekROSXE2U0RJemRSK253S05BQzkzblpGaERPN2RnOU5Ub3d3c1VYc3MzV0hU?=
 =?utf-8?B?QU5qS3ZuUjNOS1pZRVkzWitUd0FUcEpScmhMSGxaRkxGbFVxN1Y4aGtzVzNF?=
 =?utf-8?B?bVYyV2gwV3QwRkNwTVM4N3lUVHIxbEdIYUtLNEhYR1Z2M3dyZEtLR0ZrZ0VU?=
 =?utf-8?B?NWFmU09CUUp0OUNRcHo5MDR4eTdCOHl3N1h2NWpxU1dad3RZUG0zOUJyNEc1?=
 =?utf-8?B?ZVpTTE44L1YwOXRqOHFJSTMvaDJ5YURBVTdTaDdRdy94QjlUTGtZT0RIYmtw?=
 =?utf-8?B?dUU4a0d2REpiKzRsdXVQbkx2VW12SlRFUDVJbGtKSGhQSWVqN1FoakhGYmta?=
 =?utf-8?B?QmtPRGR0QmcwdEhORW1ScFpnSGlsalB6THRSRzNsVm4xaXZlV0x3b004UkVp?=
 =?utf-8?B?eHJYWjZSMFhZY3RzWnJWU1B1dnFFVmRjRHRaTjE0RmxBZ1llb1NkVnBuZHE4?=
 =?utf-8?B?aGhXYi9EellZWmpENHNUNlFib21Fa1IrZHViQjRCMUl4cGpBeWRzNGZud3Zl?=
 =?utf-8?B?TXJnOVAxOXRFMGpkUGgwT0RoaVZKSjFkaFFNVjhZUmtxZi80M0xjR1ZlcnRI?=
 =?utf-8?B?anFZUElyeGhxdU4wNC96T1Z5d0J1UjFpb1dkc1pFeHZIUWpVbG8ray9LVnBC?=
 =?utf-8?B?MFhtQzNUYXJHcTJTdXI2TEVGSGs4RFd0SHA3a2xYU3NFT0dsTlZjRGZISlJq?=
 =?utf-8?B?R3VrUktvclpPYkZ0a0d5NEkweWRhT0hZVnV6NXRWOVRkc2JpY3NhdFByZVAr?=
 =?utf-8?Q?45U34Z/cFbd0ArCJqg7pZAeyFK8wNXnYXTQhB?=
X-Exchange-RoutingPolicyChecked:
	km2ye/jmJA0zMj4oR8J4R1GE/hAu8lmOC3whRqhE14p40v0CzLHrYSLG7x61Rm05Lrm7KN7Yfx6cTpeuZEZYoJF9uzZXCTzz+O5X5mHNoiFuBVugr/02k0GsFJx85kTjxARyEPnHk357mb+zCGWPW18zPt9SFwW4Ksggh2q8DhnhWVqk2wks+ox+ITpTU+GclscydV281vN+d+tIgoqIJdimnefFM+nfkd8Imdsvf3E781yYxC5dAS6T5OdpLsLJKtf3KOiJAJbF+sx4bHNJkL/7lC4CNIYx34uFZysGqDYHVZUGhP3/5ocyUgfbWJu+DphXKZJLtaz1YrDdJD3vkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i+gkEJtwhwP/ZdpboJo9+HeSE5c39wST3SOybXPyFimcgysCd5mZ56if58vu4PVAMjnt6chV/RGksyiqzlypadLCyvRwp0xpbt65HQoMOC67zVFl2QRXvd8X/OYKWq9yuZDA4sUbsXHinMcXFgTVYL+4ykx5KqgkBkgZxxdL5fhRLWtCVL9Q41v6GOgy1zpu7KysUiItur++ZQJtzTILzoEiL2m/DAXfOSM3UQD3KkinWuQUhao6+DixGI9oPfzM7VFy/cpJ0vGnRIpybhkCGLP26DVVisKLv3jPRdRyJG2X33M7olcyzkl6ZYNjmh99JZTKG1j+mtJINAsZCjmmJey2YkjQ9nhSvkPndqqPTyd/JOFFHf1so2CDlw0+arrA4+exBMMb7YjjZ1FboOqCaEVlxQe2iW+KeW8aS08hfov5f+5UVABZalghULBe5IOx9ZYHu+J8+Ll7aMFjnwR1Gk/jM3Vi7v3quA6ZWStZHKGh3/ElsxtNRYBPDCDT6W4f/HoUFSQsSJaIfg8CQ2gBer8op0wZ4bVaJBFOqkyfytIk+2QpVPkVeq+n7rmwys4XyNC3mxO/TxFESLW8KHoy8buqIgNF546W7cG3BNxVDhM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db981ac7-513c-4b1b-9227-08df13c4a8a9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:32:27.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1JHf4qAXqyKO+s7X7qjf3GkC4QnoHd8bij7dYqLcad+iIe11IQYadouGJW8smtF5ZS1KhBmYjFhBzLqRbFZWXQombmdp+EATa2x4Y38Wtmgc/C6vhJqgnBh5AeckZBw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609160096
X-Proofpoint-GUID: rcR7HxiLrydpM_OU0iRS6JvjRf56Uwnt
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5NyBTYWx0ZWRfX1Y2Z+//YRoEJ
 aNjIePWRHaHl18xkQ7uZk5riA8tuYSLmw5NHcWtzZQ2M/JXNOrOqY9z0KvoouAzEXgk7hfEHkbL
 NSXMxdjvkQaX3rEYsVBcwlEMDn3qH7YLMbAuXND/BzaiikqPTuf4
X-Proofpoint-ORIG-GUID: rcR7HxiLrydpM_OU0iRS6JvjRf56Uwnt
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaa460f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=bC-a23v3AAAA:8
 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=siAW5P4oHWUc_vPdS94A:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5NyBTYWx0ZWRfX7x+rQafwia9K
 qm1avhh/XJ4/GSHJPRe2ubwHOBqKxfUP6Tb2b93Dh7aaeyQTBgHByDcV8YiWwrKdnuiM7quaQsT
 Lxe6d9APORsx058vdlPFvLgGDIE/a4VNIW9IFhALk8pdyDIvj1CDM+HUA6Sy0xPzaARwhVqn0Bf
 HumBr20CiwDp1VOV8jwiTyrRrh8lgG6V/3xrEDbgTH38nrpJwOWcG3MHdpsjNE35uCC5GUZ1SFO
 0FpfNglTO3Mh5WOPi0LnCGgudFSeKfeld51+2nJtjLqkY2qmcbdDydJy7IDnitwAtK0f5y9Jxjm
 Y4TTeAHK3UriKAvlMOpi6de1DLVPs6/wQ7Dxf8Hb42yZLpS/AvQMsmsjbOX6VdjQCBNLXKoHRa9
 NgA1HMYh0aygsU/AnlLN0mpsZCzth7zL97e8he3ZIXqfC6jwYNnnhkIQ3frxFLLvXxhj1iLbfDZ
 TXdd/TieViQnxQveohw==



On 12/09/26 12:20 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pengpeng Hou <pengpeng@iscas.ac.cn>
> 
> [ Upstream commit 3c817862759913097f11467ed4ed2bbf974dabaf ]
> 
> knav_queue_probe() creates the global qmss debugfs file whose show
> callback reads the global knav_qdev state. knav_queue_remove() tears
> down the queue manager resources but leaves the debugfs file published.
> 
> Save the debugfs dentry in struct knav_device and remove it during
> teardown before the resources used by the show callback are released.
> While touching the debugfs_create_file() call, spell the unchanged read-
> only file mode as 0444.
> 
> Fixes: 41f93af900a2 ("soc: ti: add Keystone Navigator QMSS driver")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> Link: https://patch.msgid.link/20260706144706.96313-1-pengpeng@iscas.ac.cn
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/soc/ti/knav_qmss.h       | 1 +
>   drivers/soc/ti/knav_qmss_queue.c | 7 +++++--
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/soc/ti/knav_qmss.h b/drivers/soc/ti/knav_qmss.h
> index 9325e8ce2e25c..bd3426a30d958 100644
> --- a/drivers/soc/ti/knav_qmss.h
> +++ b/drivers/soc/ti/knav_qmss.h
> @@ -304,6 +304,7 @@ struct knav_device {
>   	struct list_head			pools;
>   	struct list_head			pdsps;
>   	struct list_head			qmgrs;
> +	struct dentry				*debugfs_file;
>   	enum qmss_version			version;
>   };
>   
> diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
> index df66fb15e4f95..7b2ab95593ff6 100644
> --- a/drivers/soc/ti/knav_qmss_queue.c
> +++ b/drivers/soc/ti/knav_qmss_queue.c
> @@ -1871,8 +1871,9 @@ static int knav_queue_probe(struct platform_device *pdev)
>   		goto err;
>   	}
>   
> -	debugfs_create_file("qmss", S_IFREG | S_IRUGO, NULL, NULL,
> -			    &knav_queue_debug_fops);
> +	knav_qdev->debugfs_file =
> +		debugfs_create_file("qmss", 0444, NULL, NULL,
> +				    &knav_queue_debug_fops);

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

Upstream code after the later singleton rename:

     knav_qdev->debugfs_file =
             debugfs_create_file("qmss", 0444, NULL, NULL,
                                 &knav_queue_debug_fops);

Downstream 6.12.y declaration and new code:

     static struct knav_device *kdev;
     knav_qdev->debugfs_file =
             debugfs_create_file("qmss", 0444, NULL, NULL,
                                 &knav_queue_debug_fops);

The new probe assignment uses knav_qdev->debugfs_file, but the 6.12
driver declares its singleton as static struct knav_device *kdev. The
knav_qdev rename exists only in later upstream history, and no such
identifier is declared on this branch. Supported Keystone configurations
therefore fail to compile the affected object.

Maybe we should be changing knav_qdev to kdev at the new assignment and
rebuilding a Keystone ARM configuration before retaining the backport.
Thoughts?


thanks,
Harshit

>   	device_ready = true;
>   	return 0;
>   
> @@ -1890,6 +1891,8 @@ static void knav_queue_remove(struct platform_device *pdev)
>   	struct knav_device *kdev = platform_get_drvdata(pdev);
>   
>   	device_ready = false;
> +	debugfs_remove(kdev->debugfs_file);
> +	kdev->debugfs_file = NULL;
>   	knav_queue_stop_pdsps(kdev);
>   	knav_queue_free_regions(kdev);
>   	knav_free_queue_ranges(kdev);

