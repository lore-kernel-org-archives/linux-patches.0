Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5189D43CEEC;
	Wed, 16 Sep 2026 07:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543058; cv=fail; b=EVI9y/deew/0y1rko10b44PcI6bEKrmO94Dm/hojVuZVnpqafxwDO1oyfhcQDTeSEX1gudlx/WBtmNaeLWfkjrB7C8NGn3LGqGa8foVHu3i/55F580b3XEbPormt9rRa2H/4RZGtKdofbvx/IJvDjRCGNJlPjFAlkf68f58rbq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543058; c=relaxed/simple;
	bh=JITQAEnceP327zlIIvlc62HmMdkKMsDdH1E8f444F/Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o0GN0inK1KZC3RYmFeqBolTVKU4yr8rIFGnU8ri+RehSGb8NvvEKPcviXqtDsq+3BIWIhu5n0pBBq9Mq/2ofwoyr1x4tVZpeXjeBGxCKFKZd8dqN8wwssnc7GkCtd+sHRnBeFUd0RZ8iXCvyUfFoSFoEUrWfhM7/cW7VExbQOJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ko7gqgk6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cA+NHCmk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ko7gqgk6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cA+NHCmk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWOu2641100;
	Wed, 16 Sep 2026 07:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lq5r+5sH61XRG6QJbsu20HHSvXpHeRPUF2bXl81UZEg=; b=
	ko7gqgk6vmM5N3X0VxUjdkaUf3tMbcmvZB4wVuf0m0P1gRifXGL09IXBt1aUnLDf
	THOKhRNDaktoLb86JRrqvgtvfM+UWPAHMgJHk0FpKBGzCNGkygkBTkxk99GQyZdM
	UDrVbS1SeiFszRAM7jKeCxe3F3imxJN0MY2UrHC1FLunfDHycD5HSDeEfXUJc4Ct
	hFMmV3J/gcucJo+VMV/o5FpR3M39NFqVnIaED+9zcp/V73ErKHnSEYxN4hX0PJak
	a6EE2Ml5102I2RRJQH8ffzOyyvNxJy7dgaLyMOzVI33VYhgG/mTA6HRjHZ7gOg1w
	pt2aYFFSUJmBm8EVgoKzTQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs53bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:17:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7A2ko012796;
	Wed, 16 Sep 2026 07:17:24 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d132k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:17:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K25yY7LVC5qTyRiVWtTBBNyGunmdBRl6h7Zp5U6XHo8SQyhAuGghRNyuo7M2AmnQ2yky/tv0vw9WglLDTNmtpyXxxP3jhUJ+RL96voG8IhUQC6TRWcvzY5Vy0uyB1ImEohO2i4RZ9HdSwlff1gZLGILPVAtC2n3fVExiXwjZPCOnLbPXzjAuVd7X3YpmW9N1ayZ1+1PUOZNVx60LDKW+OwUeFhQmEzSOpH06qDEtvwGb27VxeRS+c7KS9ABfNC5qBzf8dVpUl6RidZqRKfYxRMKK7XAJJxW6J1tUsi7wtqpJWApDNJ5ecKdB8MHmzPtEir6VOoFzkoNxxzfLvFJ3zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lq5r+5sH61XRG6QJbsu20HHSvXpHeRPUF2bXl81UZEg=;
 b=TBOlFQDfYMEL43EvXkkiCMc4JfAoLVtPyagDsnSNNKmlmG+HphqXkS0am3LTDkQr8QIl53f9ysp7wCjAI9jgmlVA+NEsW9lyqWIkWmY6wIwzOF6kRcad1doi5rEHWG4FcWgV93NlXpTq8RRi33WLWMkOt2i3nGexPrL/vl0xd+kp+4fPXBVL/l/7NFqegYASrBWajqItgetbMU4OTP1ATx1BEidgNF8lx9f4Vf7PRy9t4PbqM4bI3NLMcKWoiet350PVAn5QuhdyPBhC7wGh287tBEKCfXqSWHJzSmTzNB6h+fx6SJFjkd3UFFnk+gG6EowG0sGrsLM3Mp+TFWd+gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lq5r+5sH61XRG6QJbsu20HHSvXpHeRPUF2bXl81UZEg=;
 b=cA+NHCmkZyd4bjjw4iiH/Oc4hdOWk88VRF0d03S0iTMj/ZE3LS6C2+RxjTcr4wTF1RRQewtHIraJBJ3/Mee8+vBj1Zblc3hP7+X/5Fh/ZThMpNwXyyfyBjwxTBZmI6ZjOCMKHodesfsglxZG2Zoa+VRQXl+FHqpmz5LYSIJ70uc=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH0PR10MB7007.namprd10.prod.outlook.com (2603:10b6:510:282::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Wed, 16 Sep
 2026 07:17:20 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:17:19 +0000
Message-ID: <44690ef9-dc7a-4a0f-8392-a88459edaebb@oracle.com>
Date: Wed, 16 Sep 2026 12:47:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0360/1376] perf tests: Fix flakiness in BPF counters
 test on hybrid systems
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065615.574776230@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065615.574776230@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::9) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH0PR10MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fef9a08-c79b-46d0-a7ac-08df13c28b55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|3023799007|6133799003|18002099003|22082099003|10067099003|4143699003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	19lA96DfXN1VFyQsUNTD1yNa3AZ/QCb2IaybLKSCUCWNQlWCyVvtw8u/JIZLgW5OqZKCCcQuv/onAsIPzQxx2d1MIAfrCagKux+ZOsmra0Y3VH1eQvdtwXeIyz1ZS7HdtEIprbqBdouNRtzi9e6QDG5dIhqiTZBW/tlW3qRWymVinhohcmAMSp01jxx/n/OWcurJIamTZoiIMAhbgnq3mfP+tIMEA7f5XT3jBTcwvfAarDkuqhpjJ9bDYn/5yZLxHEMNYkyzP/uM9E9zusAInGTMyBxYV7scGVChXQCsM6iyf7si5ifJQr43ipbixgqWKx48SRz9gfOMsxNdRfoMnD89iDyvS3S1UWsPFAwvB4fNN1ZbPQHKpkfw1CZixIjiL9REs9sipCWepwU98wIz1hdHcmkQRcl0i7x71AZKgJnCBPP+485/iTNb9MkZT7qpfVEv+vMu9ZNU+miTexPPuXUJH9LMZw3XUA+Lw0kwYkuhLz+WyWXzQG+qkKs6TxB1/SWfhnM0p7/Ip2U0x9unUUeBKcjN/zKtKbtDqE+73c1xpq9FcDak0kPQGcjxD3w/MVyamVXZ4YnvBUGk56JF/g1G9wdyOzht7p4raIgGHovOWhTtMXHxB05ZrdS7QrYDnCc+Y7XNmfmsO4mQYy38XeZCdFGHsT9g9z4op7bJls0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(3023799007)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUpMcmcxd3lWVDBvbmpJV1UyUU9YWWhwYzhzZEpudnN2WkJwUnJWdnQ2M1Vv?=
 =?utf-8?B?dGd1by90R3QzU1VHTWJlYWFBQlNaZDVvSDRycnkxNVZoeEVubVQ4b09JcGdI?=
 =?utf-8?B?T2VQMDc5WTNYQUxldE1TK1p2ZWRvcE9jM1J5MkVLZFB2S3l4NlpNY2VCS2tO?=
 =?utf-8?B?WjIwT3l5TGI0NFFUS2Z5N1dTY0pXVFFaMFArZzNpRkd6aDlDMytYK1VqWG5S?=
 =?utf-8?B?NW41cTVxa3Z0SmhjUjIvQ1dDb1dkaUNNSTBlL2FjUXl3Y0dqd3lRNG8wVU1I?=
 =?utf-8?B?NStlZlV4RGZoUE5DUjBpV3FZaWtXdDB5T25wUTBJM3pMSUcvcjdYVXlmaWlk?=
 =?utf-8?B?QUhoaWozdks2aW9sRzM3QTluUFpKcjJlNDRweUh5RkpQTEpRT2R5QzZLck8y?=
 =?utf-8?B?ck5NOEMrWUowQUF3ZzFLWDNaVXI0VDVKQlZzSGVNWEQ0OU5Ua3FNM3Qxc0VR?=
 =?utf-8?B?QTkzc2pUQjVudFVERmpCdzRCNGpESHBRT0FpRGNMS1pUNHUrY05McCtqS1pj?=
 =?utf-8?B?RTdXdXQrQmdnenN4S1Jvajd6L2NNeDh6MWlmWm1DRHdXekkxdVFWaHBQOG1o?=
 =?utf-8?B?eGFmS3JzYnNHYW9zYjRKUDRDOTdQWjlSKy9zVFdYZlEwYzExQzM4eGt0OTc5?=
 =?utf-8?B?WDJsbkFnMHczQ2lVdk4rVU0rSHBsdXhXMDVEcGx0eEJ6clBNTTNrYkxKeURw?=
 =?utf-8?B?TkxlTGJhcXgxNkp5L09Obk4rZWttYVd2Z016TE5lOEZYc3c1Y3Y0RUozNEpq?=
 =?utf-8?B?SFpKR1FNWXRYUXN3VkpwMlZHL2c0Z3A4eE9KaS9rMk92UEZldlNCZGtxaG0v?=
 =?utf-8?B?QW05cXAzVFdwdjZOZDVwWS9Udk5wWWhJei9ySC9FRkt6cHNZd0FoZ2FzSXV3?=
 =?utf-8?B?QUNDbEpVaGltdVBZaGk2Q0haYnJ2TlEyUk4xT01aSkdrcHFITGkxTTBQNVVn?=
 =?utf-8?B?MjNQSEZZUS9VWE0zdUdRdGJMRGM5bEw0U2I2cTVPcyt1WWhUZ0ZOMzBiRFFt?=
 =?utf-8?B?d3VDQjF0ZG44SGtldjlJV2ZVa1lZQ0VuY2ZYeHV4OHYxbUlaRy8rOUNLN0Np?=
 =?utf-8?B?b0hpS0VHcTcwOTgxZStYR1FNRDJJZk9qTCt3M2ZwMXlPVHRCOE1EK1ZPNklx?=
 =?utf-8?B?dGI3VG8yS21wSDZUcUJxcnlvVnhPQ0xzbU1oblpKbG5iQi9XdFpOTHlwbTRQ?=
 =?utf-8?B?bVBsV2wyL0ZWSFprbHhDOWlCb0o3WlhhTUNCOHdyNUR1T1RQR0FGZWJObSs1?=
 =?utf-8?B?bE80enRRWloxNVhVdlcxVEk5MEZ5T3Y4b2kvZDZhTXZDM0tydG9VZTVEaVk4?=
 =?utf-8?B?UHRpbGNyQ2FjM3pWeE9vd0hYNmhDUTdzT01ZK0RMWU1pRUpxd1l2cnplRGdt?=
 =?utf-8?B?NTBaR1Z6b0pNWEJ0ZVFScEJNOXNXY2hLbFNEazY0cUJObzlJWDFSdjVMWWdE?=
 =?utf-8?B?cW1QM05vclFDYU5zTE55YkhzSC9rSnJ2dkV0ei9QM1ZHTUJsWk9uOWxuUVo5?=
 =?utf-8?B?UXFXSVVjdkd1NDhJR0IzTU1JRTEvUjBIZlBDTVY4UnM0ZHZWaUovQUJRU043?=
 =?utf-8?B?bkFackFUTkR1VnM2a0J0cCtHaGN6bmNMZU56b1VMUW1xcGNibGxuMGFYbnZr?=
 =?utf-8?B?QVlYM084VzRHWXZqaFY5clluWFhsNGFjMWZJL2NCcWdNVDRPeGFBVUljMTgw?=
 =?utf-8?B?K3VQazdKR2JkcEpYYUxmRHg2cU5VR2JlWTVrUk92L2IyQm1tNnpGNVhrakU5?=
 =?utf-8?B?QU01RFRzcWxmWFpjdndoVi9LT0NqK2VMTXIzKytXcGZiNmFMOE81OHJBYUgx?=
 =?utf-8?B?dlRZZENLZ0NZcjA2Qy9oMFFsWTVuV00vbmc0QjZDMkYvQjYveGtSeWl4Tjhy?=
 =?utf-8?B?MFYwZjBEdDBxdHVIcFRqZThTVFM3VGRsdld2d2lmU240Tk9xbzNzVHpJRWpw?=
 =?utf-8?B?d2hBUmNxbGJNenN2ZzlGN1J6Q0wydWhDdzlqWjROTitJNWNVTlVZSlVaeG5t?=
 =?utf-8?B?RnQxSXRNeTk0TnljQ01obVFvWG0rbHZGZWIwWnkreERBeDNIWkh1Tm5lNUR1?=
 =?utf-8?B?Q254dVB4ZTk5VnhmNzBCNmNsT0NDcU80OTB4N3AwYU0yL2JLYUFxWWtTVmtS?=
 =?utf-8?B?dkZUYUFMME9WVXp2Z0NqUW1ubmRCYkkyaGJ0ekkrOE4wK0U5VDBSSFRKaHF2?=
 =?utf-8?B?TzMvVXY3SE5kYm15MEdIZzM5ZzlERDFWZ2JvZ0FEdmRYc3lqbkpOOEtXd2o5?=
 =?utf-8?B?TWRjNTUvYlA4VGRWa2E2TUdQeHExVjU2Q1pSc0xPcUk5WGdKakZ4czR2Nm85?=
 =?utf-8?B?aTZHdCtBWW5CTjQ1U2cvRWl4d1JpMWIyQzRycjRNQ0FnL2lHU2NkR3NmbmpH?=
 =?utf-8?Q?0HwuPjecv2Jz6CJb0SxGQuvTCDWM18uQ63LD4?=
X-Exchange-RoutingPolicyChecked:
	cugblBcZXh+Q7dIADVcYoXd/eNyEq8AWxPRME/Tfpf5hYFxRR8S/vKX87IMSh+EuG6prACM89wo6O0DiBKkXOSc2YwgVxFrEDh1QLHC66YnzSlCZyZaneLtYammsyeMjOdGpyZBSX1ESEoiQsqw4VRoH05I4DcUtmE5Xxry7wcBROTPbI0q0NGtnTjQ0OgGeqNjXhWkUAYx+iuxPu3zAumfvQIgjqLrm7SAbqB3NVi7YvzAlIfnDfzYbG0MCjve1vXK97ap3seNbaps6V6xoXrdev8GiuKnFjLkJEDZihzCEjMi9wIMh5+nL8UwZ/gEWSPQHR0T++YM0LZyEJANp5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eyVoF1iqXH/O5X4/CvyB32Qx/dy/DiGH79fAiu3n5JY7aUpLwDzSOfDeikqhTES38tllrN7pvdxFFZDT3wKOtwhrp3PVRL5LE4P689jMzW91qecPUmPQN1odXp+7tKTbVBgShSZgeIIEgyNmBfuwAcdSPF5Q1xF0kJWbIRymWDdleUuWGZJTghcgO5LG2TVmduewcgjnEV63y9ujrRScFLqhtBEK8jYzr+CKbqrWDG0X59lJPzW30yi3JGPHHgYBpdaksrj+vMSDOjLxrXRUYyDlDIwjMA7JpUuZJKSowlvIdb7BINc0D/EfDD1JD5LI7JKLf6I34rypmLVviMrcW2IMuL0r3Xcmv6R1g2sPCHR2ZcLOcyyYR6vHXQdXB4lWUUmBO5jfBxVfgDg1VTS7e+IXfWEeVnzKKmnylSKP7qblu/TuOqc5ULRQGiVr4XhM/mZYF8dbyJEodgK1J/rYyUw4MZ2+ZV2CkjpbMiNpD7T8pVhGz+WaG+IJ+tq819gkhQ/KeeZIJImpQA1/ddU+yATJuXfdhNk+VzErGcORXYjhlqWDM+xXHTrfMnOV7cbpmopQBiJjICCpjhNUS3Qrmg4+82JuEbDjuxve4x4NsZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fef9a08-c79b-46d0-a7ac-08df13c28b55
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:17:19.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qS1OzFsL+dN39pHdAQ5sUcVNfMSDbvuMHkDFO/GGYx2v1pg7CdYc7zs/8GZbcG8Bt6Z6XnFZumzhsUA/rO023IR4QlsuXLE4Oy6jNCzRIU5Eo9W+Pz2/3uBIBeObkCfK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7007
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5MyBTYWx0ZWRfX7wi1+2iR7Oe5
 VAHO7Z/sDzG7bXwEGbiRS3BkCu/73jdJJ+VmU7BX3O+X4zICYnNaDDvxOzv0SkGyb90+ao/hN2w
 owGvlvaLp5FUv7OOk6D5ZhXESnf7Tds5bICf4/fguLAbLjhEQ7XXH4HtcoQwIZiVv/19rrPurjm
 zkGziyZw0iuvhV2kl/H7L5Q7AbznrG2DmFSgWnDy71ncTv4F0fkTaffH0rSlkG0O4TcwNTdf2mO
 RrwDikqnAgvjk10CdYtLoGArCQuok5FwGsPIM05IUfoJV0TNoNmgbTplhb6DNCfi2nFnI6cXAWp
 JgExSH+SuZSWwS1gfwuyVS13BdJG/7g5dRUbxmXL3VQxNj7RJPTxIndXEav6ZWcdngfubKagawg
 4uvXDhmIWqA0bzKZPKsGvKXtR/DRPa4EbMNM0bTvGiMW6BloW4gyA8byR3746OR6andO56ZH4Bj
 A/YEfpooHgNQgFqfGKw==
X-Proofpoint-ORIG-GUID: n5ZE8iojmZamVWKjV5Xj5-XMJr2aLXFG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5MyBTYWx0ZWRfX516YaCcdAqzW
 0Ym5p4NZUnh3ZRa+s5IVSm+IDmswkfK8xtkYBDNSdKwzKtPZig0u6fEgaih6yQAiD9Ai3E9gn+1
 1kt0x3L0gr+7ln393BrP/sBr+tL3XlZQx8UyGHwjBdlOQmersByI
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa4285 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=1XWaLZrsAAAA:8
 a=VwQbUJbxAAAA:8 a=2jTm8fp-C2Zm-BaF2N0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: n5ZE8iojmZamVWKjV5Xj5-XMJr2aLXFG

Hi Greg/Sasha,

On 12/09/26 12:16 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit b02027776ac5bf737f1b76f3759f405e376097e5 ]
> 
> The `perf stat --bpf-counters test` fails intermittently on hybrid
> architectures or systems with dynamic frequency scaling (DVFS). This
> happens because the test workload (`sqrtloop`) runs for a fixed 1-second
> duration, and the CPU frequency can scale dynamically between idle and
> maximum frequency. As the first run runs on a cold CPU and the second run
> runs on a warmed-up CPU (or vice versa), the number of instructions
> executed in 1 second differs by up to 2.2x, violating the comparison
> tolerance.
> 
> Also, when running as root, BPF tracepoints and scheduling programs
> trigger frequently. Since standard `perf stat -e instructions` measures
> both user and kernel space instructions, it counts BPF helper and program
> execution overheads, whereas the BPF counters themselves do not self-
> measure. This introduces a large kernel-space instruction count
> discrepancy between standard and BPF counters.
> 
> Fix these issues by:
> 1. Switching the workload to a strictly deterministic, iteration-based
>     workload: `awk 'BEGIN { for (i=0; i<10000000; i++) sum+=i }'`. We pin
> the
>     workload to a single random allowed CPU using `taskset -c $CPU` via a
> bash array.
> 2. Restricting the counted event to user-space only (`instructions:u` or
> `/u`).
> 3. Tightening the comparison tolerance from 20% to 15%.
> 
> These modifications isolate the measurements to user-space instructions of
> the deterministic loop, which executes a virtually identical number of
> instructions on both runs (with less than 0.001% variation), eliminating
> Dynamic Frequency Scaling (DVFS), kernel scheduling noise, and BPF helper
> self-measurement overheads.
> 
> Fixes: 2c0cb9f56020 ("perf test: Add a shell test for 'perf stat --bpf-counters' new option")
> Assisted-by: Antigravity:gemini-3.1-pro
> Signed-off-by: Ian Rogers <irogers@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/tests/shell/stat_bpf_counters.sh | 28 +++++++++++++--------
>   1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
> index b776ee2e445a6..76d4a7f15a43d 100755
> --- a/tools/perf/tests/shell/stat_bpf_counters.sh
> +++ b/tools/perf/tests/shell/stat_bpf_counters.sh
> @@ -4,21 +4,26 @@
>   
>   set -e
>   
> -workload="perf test -w sqrtloop"
> +# Get the first allowed CPU
> +CPU=$(taskset -c -p $$ | awk -F': ' '{print $2}' | awk -F'[,-]' '{print $1}')
> +if [ -z "$CPU" ]; then
> +	CPU=0
> +fi
> +workload=(taskset -c "$CPU" awk 'BEGIN { for (i=0; i<10000000; i++) sum+=i }')
>   
> -# check whether $2 is within +/- 20% of $1
> +# check whether $2 is within +/- 15% of $1
>   compare_number()
>   {
>   	first_num=$1
>   	second_num=$2
>   
> -	# upper bound is first_num * 120%
> -	upper=$(expr $first_num + $first_num / 5 )
> -	# lower bound is first_num * 80%
> -	lower=$(expr $first_num - $first_num / 5 )
> +	# upper bound is first_num * 115%
> +	upper=$(expr $first_num + $first_num / 20 \* 3 )
> +	# lower bound is first_num * 85%
> +	lower=$(expr $first_num - $first_num / 20 \* 3 )
>   
>   	if [ $second_num -gt $upper ] || [ $second_num -lt $lower ]; then
> -		echo "The difference between $first_num and $second_num are greater than 20%."
> +		echo "The difference between $first_num and $second_num are greater than 15%."
>   		exit 1
>   	fi
>   }
> @@ -41,11 +46,12 @@ check_counts()
>   test_bpf_counters()
>   {
>   	printf "Testing --bpf-counters "
> -	base_instructions=$(perf stat --no-big-num -e instructions -- $workload 2>&1 | \
> +	base_instructions=$(perf stat --no-big-num -e instructions:u -- "${workload[@]}" 2>&1 | \
>   				awk -v i=0 -v c=0 '/instructions/ { \
>   					if ($1 != "<not") { i++; c += $1 } \
>   				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
> -	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions -- $workload  2>&1 | \
> +	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions:u \
> +				-- "${workload[@]}"  2>&1 | \

^^^


I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The patch uses a Bash array and "${workload[@]}", but 6.12 keeps a
/bin/sh shebang. It also lacks the upstream "(exclusive)" marker even
though the destination perf dispatcher honors that marker when running
tests in parallel. Thus a conforming non-Bash shell cannot run the
script, and the test also loses its required resource isolation.

Upstream code with both prerequisites:

     #!/bin/bash
     # perf stat --bpf-counters test (exclusive)

Downstream 6.12.y code:

     #!/bin/sh
     # perf stat --bpf-counters test
     workload=(taskset -c "$CPU" awk
               'BEGIN { for (i=0; i<10000000; i++) sum+=i }')

The missing commits are 2f5d370dec3f800b44bbf7b68875d521e0af43cd for the
Bash shebang and 2532be3d219d8819e59dc52a5ead4696b8354a82 for the
exclusive marker.

Maybe we should be pulling in these two backports as well, but note this 
is perf/ on stable kernels.

thanks,
Harshit


>   				awk -v i=0 -v c=0 '/instructions/ { \
>   					if ($1 != "<not") { i++; c += $1 } \
>   				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
> @@ -57,7 +63,9 @@ test_bpf_counters()
>   test_bpf_modifier()
>   {
>   	printf "Testing bpf event modifier "
> -	stat_output=$(perf stat --no-big-num -e instructions/name=base_instructions/,instructions/name=bpf_instructions/b -- $workload 2>&1)
> +	stat_output=$(perf stat --no-big-num \
> +		-e instructions/name=base_instructions/u,instructions/name=bpf_instructions/bu \
> +		-- "${workload[@]}" 2>&1)
>   	base_instructions=$(echo "$stat_output"| \
>   				awk -v i=0 -v c=0 '/base_instructions/ { \
>   					if ($1 != "<not") { i++; c += $1 } \

