Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF748F024;
	Thu,  1 Oct 2026 20:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790886266; cv=fail; b=PM8H14dPCGCLYjDxcv09ooflVJDN8LLEzR+haLoKioPSX89yYWd6T9ShDxvPds1nGyIDrikaIdv4XvgzfLwCjQ8Nv31B/TQov//dCVcosoRCrmUwhk1brO5q+1Cy/BhyaPriX+FBHe3tC5HUSAARAMDqO4b8rSbcG/lyCoDozJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790886266; c=relaxed/simple;
	bh=mNMiTDHin0oCyTcXjL5uZ2gT4FYX30KR3uc032EKlHw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KUafKD+RSKsAq8ZU1SzyhztY/y17u59sQcfDgdcUTNupqVuVJb2NyEAI/jlrdXnf20IKPJJh/LD4jg8E1Qoy6fbPnsndbhWwnh8yzdWHpTr3E2fOWSVO+MZhA0IPq1kkeZnZRpKD2/uvEZgGLIHF+9Cbd9oGcjRYh27MOmR2188=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=POQFJ+mC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NeGpGqOW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="POQFJ+mC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NeGpGqOW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691Ftlw5909610;
	Thu, 1 Oct 2026 20:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xwDKQnElv1U5+9oC9AF8KmxiVkx3vAFMziZbjcsJxOc=; b=
	POQFJ+mC8VcdsUCeDGuaracuNbJpNIFuT67F1dgy3SigdB4xaYCswP/nYOHQqXzb
	mQ7+ErZQBev/Okc7o9Cyi1RLiSNUIRt4XgE0KLKPHTJ5qDeQZOP5sJURIepnnaDQ
	Kq461pV6ADKL3+OK8Jh6lKx0xP+P0VJWRgacdPhVtMCE2kESEOl9v2Mr4o6mgd5b
	3F/Kpcg//n2EsbqXnnX2WzfGQ63kEOERNSJX7MMs/Dia6M0fIjt8h51HM10KkDEX
	7zHsv/WI4tSobCVDlE3EZicLwrMDWN2+PlkdkQ4UB1BZzpvdB84j1UzyJ0+djvWF
	wzFj3Jfh8rSi7IHr/vsNBA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx5ns24ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 20:24:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691KJrtJ024063;
	Thu, 1 Oct 2026 20:24:18 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gfaxwt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 20:24:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hCXjOFCx/4+5+xUe3xciZORthcnK8wSx7q236R5WZmvZJAxBQGLtMvsA5QxMwwULTCt4giiW+yi56hqgykaYA4ZrhoF34mkh8y6HuX1XgGQtkaUQzY9QqZXImHY7aC2ZiVuZYJrKuiY+uWLTTq9U6Yb+cEAlWkrdB9wGSZ/LsphaZ0+wA3ryPlpWOkd28nrd0X2fIfCv3SJ/scywgASnlVC9Kdc8QgEPUZgTVanVlcynL02gxIPnXuR2+mzj4u86RFI7NBWbitTHFALQ5CxvIQJzjJ5eN5lheG78/q6OsOZ5qaolPrfKWoJpyYH1dV7WWNeLv4nnumsO14V4DBzP1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwDKQnElv1U5+9oC9AF8KmxiVkx3vAFMziZbjcsJxOc=;
 b=efCaQkbTNUrnCXUK4elpY0laytpjEiV7N5+YbAK2ogRKEX1nVK4iE/VS52vLC6tlnRX9Tc3YPjX5PEupL2w5D6rhSJYEG3mmrsmMqapRXd64GdyMWUDPqS/u3s6p4i3dq2VAyBRSnFyfRR1DYLPcap4nisxiYgHWv02NUPRQpN+Isk/vBRUNv+ADrct3to+/HWUG2p7ZWsYgPKKHoH2rkg00xaqiq19zdpMdvwvA3cOI2vOz8ta1EY27SKJTUkG7LA7FZMSnZYnd6lUQKPeJbFIp+OxaIzVHNaTg1td5OzeMMfmm3Ji22L0aPkupWz7JBLyKos/WJoBUNubFoiZcBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwDKQnElv1U5+9oC9AF8KmxiVkx3vAFMziZbjcsJxOc=;
 b=NeGpGqOWKbd+I/l7CWenqoP3wG163BbUfp5M7qKLaVM7L4x2YR3CQWEK9WpE4y/K1HurtUWZCecspwMOKkBE6MybPpvt2Yr/KmbXWR8oNrq4QlzFF74USsmLsc3fvlup2Tfd36q3XCpIMB9Am17LIe06BYety+lEYCZohJIoeNU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS0PR10MB7051.namprd10.prod.outlook.com (2603:10b6:8:147::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Thu, 1 Oct
 2026 20:24:14 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 20:24:14 +0000
Message-ID: <0d9af3d2-6656-4248-bdc9-0a09d5f7bd40@oracle.com>
Date: Fri, 2 Oct 2026 01:54:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 746/877] ipv4: remove fib_devindex_hashfn()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152430.793210817@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152430.793210817@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0139.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::9) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS0PR10MB7051:EE_
X-MS-Office365-Filtering-Correlation-Id: bea2f2f2-d810-41f9-569f-08df1ff9f5fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|22082099003|3023799007|10067099003|5023799004|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Vg+XA+R/2KkIBqPE0FIL9AlNgdncSXTDf9NeyaHYzDzEHx0l7NU6SXlbzJx5CGEu8i4wlpUoePmADim9GC+pxg01Ty7xMIjBKo+ptbi6sWjkpcVTNiWK173dPiyype8K64GXWd406bx/Sgg+SZ/4arDCfAPx4W+ijfeGiTnLKwXKvOdASxu8oU6A2RtDzWY567YYoUCnTlHsRTeE7ig/QeE+w+WDb/4p2t5Nqs1imyBprImp1NaaFjDGLV4kbHvgmorwPPKZsn/NnZo5QqpLFfXkOa3Q5SxbHFqzu/AGg5ts0F3ObfokaQlyA5vQ4Br9Ne+SKvl/n/XvV/0TYciviCnfl4xAqkhXY6MLEmwwfoNNYrW3mxvbT04KNmmdEp3NUeIrjSo0+P744dapdQ0kKcOX6of16wHBSjbO0XnkMZwgBTtbFUHHmTTFtlSxyPz1X7uF7zJt/LtKpqV3c+D9e9A/VYGJw5jhTSCPupuru6ReLVZGowOseSkOEU2sln1iG9pdQFfHCDFpxzSj0/Kazw7oAaX29dII6gSa7+R+tZBTBZOQV1kDwo/4wM23i/pM6CpLFur8Sl8yAA1i0vtw1H8wzvItQvwkYYUTvzDmfGgZRvS1J2qiamYl85Uni1D5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(3023799007)(10067099003)(5023799004)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OW5ub2VlcWJZbEdHaTcySzZmbzNLS0w2ZzRib1k0aDh0RlV4VUk5ZFI3TDJD?=
 =?utf-8?B?cHc4d1d3TUtRM0RLR1dQd0RweGs5NDQvVWxDd1VaMWJteVFBT003ZWNBbUZz?=
 =?utf-8?B?a00xcTY3RUtMdXI5NUdhc01QZFRpemtnbTJWKzFwZzJ4dXdiSW5WcnZkbGZx?=
 =?utf-8?B?TGl1Vk45OTUyd1hKdXJaMG9CbUttenBiaXAxbXRhd0lESVdwYXhUTHUyQkpK?=
 =?utf-8?B?cjViV2hza1dqT090dncwaVVnemQ5bW84eGVFTFdyL3ZMRm9ENDJiakoyV1hK?=
 =?utf-8?B?TTJyZEp5Wk5BQzl1OWNuZFg1QjB2ckFZTkZQKzY3em80NHhqbWUyUC9mUmVS?=
 =?utf-8?B?c2pZNWk5M0NoUis2ZUljVEx5Vml0STNiYkNHMzlVV2J4SDJVRndqL0c1SjNH?=
 =?utf-8?B?NndpL0NWVksvcmFWc3VDVmJqRUZXOGZYbXRpTEExRy9FZUlXdDNLRnBiK0tz?=
 =?utf-8?B?enlKQ015NUhqM0NmdDZkS096dndqWi9KWUpzZHp3N0VJeFBlUHg5bHhFMm1y?=
 =?utf-8?B?N2ZINmNNNDgvbTNtNjYwUUNTdkZLMVBYU3hYU1lteE1GSlNzaGQyZDFRSVpt?=
 =?utf-8?B?SWdHNUhnK251WWFoaENkLzZOUnIzWFFqZ2dmbnF0OHVHYWp5U2ljandnUXJI?=
 =?utf-8?B?dlJJOEpYNGxySE4rcjlYVVBBdlZHOEJxWEtRaytYb0NPYnZqMDF1NGtobGl4?=
 =?utf-8?B?QkIvOGVBd1JlLzJEbnVpUXJHN3QvRzhucDR3SEtHL3ZHNHpJRHdmbHlnSnEy?=
 =?utf-8?B?VzB3Y3FxVzVZSVJVOU1UWVpRdTVDUEJneTF1L3JuaDYrbElwUVFLSGVqVGhX?=
 =?utf-8?B?UnlEaGpSRFl3dmV5cmJVWWlvQlpSUjFTeDNoaGsrU1drRXhBeTFWMWcyRkFW?=
 =?utf-8?B?cmZhMEhxUUlMU1lTeGRLdy9NcTN0MFlaSW93MXROelZsVzduVXg1QnV0VHNv?=
 =?utf-8?B?QVRnT3ZYN2FHN3NOdC8wcnZMdytiazZiRWltdmZVZ1dGVWUxYlA1T1A3Zzhx?=
 =?utf-8?B?OUdjamlkYThNTUwzZlNiVnYzY1pSd1lLZGcybWR5MTFuWnpoMWVLeXEyWk5r?=
 =?utf-8?B?NVZVRitIMzBFMXhWM3VkR0dUaUJvVWhSQlVkcUxLVUg3SGttRXpKb01ZL3BR?=
 =?utf-8?B?OTRxZ1prTzE4bHlLb01zL2g5c2VMS05WRCtyZXIySXJpd0lsdGRtOUFVUnFu?=
 =?utf-8?B?OWx5cTFlQU1uaHU1REhVSnRvelpxVWNqUG95TmtpVTQwRThzUWFDWm5EdlpC?=
 =?utf-8?B?Umk2SU02TklBZkE1cjVFb2VjeTR6Zm1BaCtjZjcxNFpHV2Z4Qm1CcVdUYUFs?=
 =?utf-8?B?QklJOEFRNTUrNFljUm5RWXc1V04rZ2lOOHk5SUtFS1VCODBOTEI2TUpHNmdX?=
 =?utf-8?B?RlpJdWIyUlJrenp6RUsrZk1PT1MxektBUVNtd012MkhLS0tDTjUyWDd1cWp1?=
 =?utf-8?B?OFNjRmIyVE5ZQUJRdFdyQ2orYm16UEs0RmRUc2lNYmtoQlVVbmJRWi8zaDEz?=
 =?utf-8?B?RnNVUmdiNWZiUkRWYWdoYkNzUEpYRnZPU0JDOHpDQW1MWWxZQnh1aVdyQ1ht?=
 =?utf-8?B?SEZRVGlGNFNFaFFrVmlwOHIwTGhOaFhZeDF4S21oRFovajN4aS9hYlQwQ1Nq?=
 =?utf-8?B?alhBTm53eWU3cUtBOU5yeEhrcnpUSlBveEtqSVBRSG81bXIwZTNoMHlVSEpS?=
 =?utf-8?B?MnhxbU82cEVvd01RVldQQ0JST3NuZklqTXkrU3JoTmdIZjAxaXV6SGpFR3ZR?=
 =?utf-8?B?K2lDNFdPRVpNM1kwOUhuVUg0L3pidWhjcTFsb0hwNmxTT1ZXbThRUUhtbEk5?=
 =?utf-8?B?OW5ZRUVzcURMMWs5YlAvdVJlWll4K3hwZDFsbnJoQUkrenZaYUluZENZT3pw?=
 =?utf-8?B?Z05tQWd4aFRpL3RrVXd1ekxYUUxWRDRTaUtyRVJpaFVFcHNhdFprdWhlbnZ1?=
 =?utf-8?B?T1BxTnB5WDNkZmZxaDdPdTVXdE05WVMrdGp3M1RKN2c4OFN4T2RTM0Q0NXIv?=
 =?utf-8?B?KzBRQUtIdW1OWXNsSUJJUTRXQjFGdWJibEI1aDhpRWw3UGhoc0QvSDhySzdP?=
 =?utf-8?B?dnF3bDZ6THZWRVpaV0Zwd1dwVW1HYmgzS2ptSUFKVVRDRnBkT0d4MFJMK2ly?=
 =?utf-8?B?akJPbmFVVUFsT3VmSnE2NHltaWxvZ2VrRzRJcDhaUTA1UXFHUEpNUE50d3VU?=
 =?utf-8?B?Zi9sTmlzZ0NiMVdmUnZTQ2pCU28xRDNiUURvRFF1aUxyVll2b3ZKMGZ5TUJv?=
 =?utf-8?B?aTBlTE5WbjJPdXlhTzhoLzA3bGRRVzZCQWM0aHlmUWNIWWMrc0hPQUh6bjBR?=
 =?utf-8?B?Vmc2eW5Ody9oVWozMkIzZ0R2RjF1YUVyUUI3ck9SVWUydkgzNTRTTU04YzIr?=
 =?utf-8?Q?AkUXLVxvh5stn7W/NCH31Pv5qFNSJYw/tQBUu?=
X-Exchange-RoutingPolicyChecked:
	xTcZWUYyBbt/Bs2CD6t7n8qiT0WV8Z01tgH42cdO8sDAbtdcnJFjpJIzOjFWHE9ooT61qjC9qAABXKgQGTGopK97lbTZp9FuUnvSVkDjcHf6fibOKWGfiYrzodgTWqd+n17VTrNZgh34AcDvfji/tTRBypXcPnOKzeFAxnmT/Q2io/5um7xlAihFdqcGDbgiQas15eCxVTmdeWkXZkd1VIGYI71T58MRAnpcx5yFS/TXOApL0ql5O/PnALeMj5lzKmOb9L0Jdn6EZnqKH07eYKwB9T8/s8UtCD8YRRcCeDoVmq0pDn71kZbR0tjc4s1IAE2L79M8w3tMIHMSHGXDqA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3lLaTLIZ+YZeXv66/t8OMuFbTwGYKwSFyu1JYKmd7ayaG+QpseDePeSz3fA4QEYa/meROBwF96KSQslLQQ1y9pgHbLvU/415XfOU06EFRmp7Lv0XSO1wbVE4bSzGNHWxZDTzMLlKCRA+a9f3votWwkQkOksfdPBwMVOM1PaXKhAWkiOR61PYAP6Yatp7O+SCVPtqXo1Fc8vjMY29dvqc8zZP7oyc40RgZy1qRlzmtlWVX5pSyshrZ854V6HSXXnILP22ejAdMX6Gs3jBJbzoJinszehodyPJ1SGGfSPOvRwkL5ZCEG5m/4SY0Vhk3ekcieWC5hLFcxFPaWG45fLxMCxyQKN1r1v0/O6t3TEM4OOAxwPtwp6xIh0dLGl8As81eILuu+apXdgYDsgYcEx7VNX0RPFlX1Gu2UIRAkUbAatPH0qVtR2o1WrONvBgq4+lXLi/rDRVYtbMfCaTIGbL5bUsyBtPJeBo2SapgIazkm+aKYDOr5AIkPBl9exPlwevNUuPtbYZW4Jg33yeV8kWlVnGEBVEiF38DymtjgsBt1GNBaFhyw82NR5KjWY3b8cF+qLqovhEFAw7aBOzjpGfVzYQUHfzG/JXFYK0gCAABEc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea2f2f2-d810-41f9-569f-08df1ff9f5fb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 20:24:14.5449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLsPrGkOjg9SE8pMGqoQD/BG0Gcf4ES5sQkW7I9IapQ5W+ag1qLH8LlHQHBSS8akFXtfBaSnQVwTdpGUbrySb6rG4xXO5u/M1lIvGrpDU0Uz5Pjr+716MXobA8ObMS/0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7051
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA4MSBTYWx0ZWRfXxu9Np02l3rwj
 SMgBe9HybVJY1M7E2TY/WtXo+66wJA2O0kkDza6S7Sfr/GN19XWQ08gptqarYs9NqcjvSfFa5ba
 rbA01NG0WLMMEuzin7jKOaklnxTbsnWsCb79wGU0+gEO63/iaxH8xwYhwDNgfnxDuptXvzhwVqn
 mC9Su7ZdYBhGV+SX47cBwMED1+Ch55LpsbOPZEtgizFRt9Yjj6eln5YhK6QnNWkCeX+qaljEH4i
 tkouabOIV+hTTaXjGBbkV+1B1OQ8Kzp/pU+WD7Jm0aJ/zwv3mCqO7CLQwyIMR6aIhha8m7mpBJ9
 wO4G+/KV95hVzEUHwliEO8ycg40qTBguW0AdGhynVf4MgE7BiHzW1FdqFTiSp0gMrQBp8WyBGCP
 LM+YQ3whIp0lLVQOecCLi2J2h//K+KEA5SDs1qAnmqy2llic+SVgomYBA5pcurgbdhuAWBnlH8F
 YCZx+4x2cV+j1E3toOA==
X-Proofpoint-GUID: qfQw7mjx4WyyypnAzSbHsHLcLqhruWgb
X-Authority-Analysis: v=2.4 cv=T8QZ3PKQ c=1 sm=1 tr=0 ts=6abec173 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=1XWaLZrsAAAA:8 a=vggBfdFIAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=o47SOo92ysQdPfLXOhMA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA4MSBTYWx0ZWRfX/2ykrHk71aq8
 GSlYajlCC7/872sIXvon4osZ0wczNL1Q5yxW4KDEqdZ74U7FLz7yUhIP7057ZsLNE2wyRd2lk35
 q3WnoVivth4iQYdfPrHgXRR8wdkrlalhZgXORuUcvekUX5p4z6th
X-Proofpoint-ORIG-GUID: qfQw7mjx4WyyypnAzSbHsHLcLqhruWgb



On 30/09/26 8:57 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 8a0f62fdeb9ea66ad3d0e959c7c4addbabeac1be ]
> 
> fib_devindex_hashfn() converts a 32bit ifindex value to a 8bit hash.
> 
> It makes no sense doing this from fib_info_hashfn() and
> fib_find_info_nh().
> 
> It is better to keep as many bits as possible to let
> fib_info_hashfn_result() have better spread.
> 
> Only fib_info_devhash_bucket() needs to make this operation,
> we can 'inline' trivial fib_devindex_hashfn() in it.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Link: https://patch.msgid.link/20241004134720.579244-2-edumazet@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 8d6cd1885085 ("ipv6: flowlabel: cap duplicate leases per socket")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/ipv4/fib_semantics.c |   13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
> 
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -322,17 +322,12 @@ static inline int nh_comp(struct fib_inf
>   	return 0;
>   }
>   
> -static inline unsigned int fib_devindex_hashfn(unsigned int val)
> -{
> -	return hash_32(val, DEVINDEX_HASHBITS);
> -}
> -

Hi Greg/Sasha,

An AI-assisted review flagged this, and I checked the upstream and 6.12
code. Removing fib_devindex_hashfn() also needs the upstream finalizer.

Upstream, net/ipv4/fib_semantics.c:

     return hash_32(val ^ net_hash_mix(net), fib_info_hash_bits);

6.12.y still has:

     unsigned int mask = (fib_info_hash_size - 1);
     return (val ^ (val >> 7) ^ (val >> 12)) & mask;

The old finalizer ignores upper bits of raw nexthop IDs/ifindices at
ordinary table sizes. In a 256-bucket check with equal route metadata,
128 IDs differing only in their upper byte use 128 buckets before, one
after, and 128 upstream.

I think 6.12 needs 9b8ca04854fd1253a58aeb1bd089c191cb5a074c ("ipv4:
avoid quadratic behavior in FIB insertion of common address") before
this change, including both finalizer callers, thoughts?

thanks,
Harshit>   static struct hlist_head *
>   fib_info_devhash_bucket(const struct net_device *dev)
>   {
>   	u32 val = net_hash_mix(dev_net(dev)) ^ dev->ifindex;
>   
> -	return &fib_info_devhash[fib_devindex_hashfn(val)];
> +	return &fib_info_devhash[hash_32(val, DEVINDEX_HASHBITS)];
>   }
>   
>   static unsigned int fib_info_hashfn_1(int init_val, u8 protocol, u8 scope,
> @@ -363,10 +358,10 @@ static inline unsigned int fib_info_hash
>   				fi->fib_priority);
>   
>   	if (fi->nh) {
> -		val ^= fib_devindex_hashfn(fi->nh->id);
> +		val ^= fi->nh->id;
>   	} else {
>   		for_nexthops(fi) {
> -			val ^= fib_devindex_hashfn(nh->fib_nh_oif);
> +			val ^= nh->fib_nh_oif;
>   		} endfor_nexthops(fi)
>   	}
>   
> @@ -381,7 +376,7 @@ static struct fib_info *fib_find_info_nh
>   	struct fib_info *fi;
>   	unsigned int hash;
>   
> -	hash = fib_info_hashfn_1(fib_devindex_hashfn(cfg->fc_nh_id),
> +	hash = fib_info_hashfn_1(cfg->fc_nh_id,
>   				 cfg->fc_protocol, cfg->fc_scope,
>   				 (__force u32)cfg->fc_prefsrc,
>   				 cfg->fc_priority);
> 
> 
> 

