Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3314472F7A
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547742; cv=fail; b=H4Shu/WWz1xlpaXgaZIdRUVpIenjO/rvuFqgc5pSL33L6XqxKB+wxt1q268V077MQiHxE4FWNU5KJ6Cqum1bceK4mkT88tjy/0DTFrnHwEleNa5a4tpUzH26nZHTOPiOVoThWAixljy0/Qh34NlY/8DdE3Wgd/pI57ny5ko/klE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547742; c=relaxed/simple;
	bh=k5cbzXQfnnAydMuzNAXZv6GlT6cKZrYAWU5PbWEAk7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A62lJ4a0qghjI6Q4CBtx4olXtT5GgdgYai6NP66zSYcz45Zn6+rev3bwuk+zE/Ik+ut4EFQql9Q0Vwt6OVE+rgJqQUIh3xsUUOwtqDMu5M2D6U3uZCArLpw/2k90vppQr/xGiMVAqF7Y91iTQ9DRylvB2d0ddbSU5UN+Che2eXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aE5Gs2Kq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OEmoxBI7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aE5Gs2Kq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OEmoxBI7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWOgC2102097;
	Wed, 16 Sep 2026 08:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hLX1LDZzPoPWVZooP9wNyy6kNqbYyg0iq4PVtUokezE=; b=
	aE5Gs2KqUZHYKTd9ficmxMBfMYoPcRl4xGLa5R1daraYNcCSQclBVXk9rMtNswx3
	9Fn1h/Mm+xpbTBPZWw01W56n8mERcBh+vbyeB//JNk8R9DCmVrbfINt8vznVC5n3
	MEODP6rR1gc89ZDAGyj1rdqI0IvDxZkq2tuGPkn3N5W9HGoofUQRaGrqRAHbLKLq
	CBhMHnwShlTJx0z6ZN+1FahO05dyATa6HhQZqfqTZv/MjIP/IsnNjusZvdwjxos0
	w57XCajnSr76kSx+JeCCYpUqi//OYNwLjS1p3qKLComqiZiF0Ncy9mKg7pA4Uyxy
	GPe1OEaAI4D+9FX2DHGDvA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxsbn857-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:35:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8TpZK033844;
	Wed, 16 Sep 2026 08:35:34 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d3g87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:35:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TtKFTCWfrG+1jk/1NxREcgKKVRMRuCt4vmy38r3lrBeV9mjw2zq/8IH8zN6wzpR7bPqsiXyq0CzlfWTcKPOYudUXj/3IouG7j4GH64iCmIDX4OH7eIzRnF2O5SYPj9n3KGL4LaxYeGBYABliyBWfX067/hKWP9ehzTlRGhHDWgTfTumeiP/kcYfciN/kwU47nJb/ioSI9S4Nx/XHJsmfFE2fdx/s903bDLh+TK7Od2KGRv3jtE/0ah7eUvisGOI0ye1p8vf/AjkQ0BGPwnROWctQzbU2HbxR4NoX8uEteEaESpnLDM+G/4Q4A0MgV7GcAD/laxwMdkYj+wSODvpZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLX1LDZzPoPWVZooP9wNyy6kNqbYyg0iq4PVtUokezE=;
 b=EAph98q26UzTkEYPNKihRAZNamgYnSTWavYMuCZBBjkXjX3wfx388kyKPfNLt/qPsHhLsD8sFVSDTkKCx22fiIjzCl2NHhpmuLQA2k8ZsrYk3bqud77F4uPv9J410DkwU/MA5ZboTbgUNc1qp980IxrgVzOGhFiQu5jXam8yraQNMSDAdg68dL5yVNtqIKmTvlj/7wCAPiHoFDbWemG1rotDArj0aju/1QMX9/opZHCAONu7y24yBthiviU4960C4fKq4JBcpxfZYYDfDRd6CX09IitkWiuRXiBulqJ9nu4m3VNx3w6ZVdFoOfY/IqLO/LuyjUQXDX15EceLk1oYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLX1LDZzPoPWVZooP9wNyy6kNqbYyg0iq4PVtUokezE=;
 b=OEmoxBI7jlvAr4Pa2WE8Cx/I4TiD8oVUCY8rJUXY16q3Tr9xgxhs+FLcsKioktK/SMvLsUjzWb4h8TyDAmHwlMcRwitkDg7lCjrn4SqXN7RivwViLaKeK53dbs5OR26DhOMHUyMS1PL7E+VLL3/AkXzTg9OcXUjw0791wWIumg0=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS7PR10MB5055.namprd10.prod.outlook.com (2603:10b6:5:3a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 16 Sep
 2026 08:35:31 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:35:31 +0000
Message-ID: <9a88dda4-16e8-4205-8f28-428f2da245d1@oracle.com>
Date: Wed, 16 Sep 2026 14:05:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1096/1376] selftests: harness: Mark test fixture
 objects __maybe_unused
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Alex Williamson <alex@shazbot.org>,
        David Matlack <dmatlack@google.com>,
        Nathan Chancellor <nathan@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065631.987140971@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065631.987140971@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::13) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS7PR10MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: d57c6889-ee8d-4aa3-8245-08df13cd7824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|6133799003|10067099003|18002099003|22082099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	Yi12d0kPmitHQVi8BvnnS2fvqhCTgaQSeZU8UzkbC6jVjp5i+CIWWqvvwEV4O+E7/E4pbWuDjbSkfFeekyeE6kpyqnokn+y/DduReDDMw4rgx/Z40zj9/Zj/etdKXxz7cdIuso5tqbxMGL1KN1vH9cqu4kCLXc99oPR+ajOIMGqaeJo8IKsSg49QlDiKIf7LHNY/hdw1+XmQV/DtrqF6cyMagUmA62z4zPviJTKWiJA1dGaUxmEoF7ncFE47Jn5V3B/oCQxGkH1hLHF6/zjEzXlMQLsGpXEDGwQb1YOkUL/JfN/ymsKRkvH8urc8UNzCRenrXTIO2Qzh+FvKUQWhdv4uK1hqe7EKvYaEfVss2qv/Ai+t9yzZtDStEgkmCfjVmLGztaiw76qXTBggYQRo6joatMsNbhyyiKptuE8ZX1Gz3SSBrghVyzmOLX84JcV3Q5H/XyKoG3SdrIb1YoBYlgGX+nMVz3yfJEIXEtB2sxJ+iiNFghCN112s2wwiOK8/jYaeZ0TU7zVryljfPspU+tsfP70Z8gv8tMHZmBcEcYu03cyfgFrJLi9zihNt6WN9CXx8bAtDNNWEQ2wQW+aJgL0zEjS+xSYPlA7xrto69TCaPCaWmY81xMNKNVBjz0/kP2PzD4Fn+v5EIznKdRmqX8pjDPPOV3YGPWHiiLyybUY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlNwUWJJL01tcjd6NERwRUE2MmdJZ3BORHVFNitJbGM4Qjk3OUxjNGhhY1JQ?=
 =?utf-8?B?T0VhRFBwOWpOUVJTTXViQjRYbmZxeWZ4V3F5dHc1Z0pESUl4ZVRqQTl1b2ZQ?=
 =?utf-8?B?cXA2RUp4S0psMHk5bzhRaDB1d0E2ZnpLZXpKYlBML0tCckJoSW4yZ2gvYjVa?=
 =?utf-8?B?VkNtVHg0azZ2ZmRuekVFMFR4WHhncmhZSk0xS1htYVhpQ0pLcmozRkh2TnlF?=
 =?utf-8?B?RUl1R0F2cmxtZlFYQzYxSUp2QjZNcXhUcjdZUFJNYi85V20zMVlUZGZLM1py?=
 =?utf-8?B?ZG9CQXk5cE5QbEpaVzNiWTMvaEdWdkR3UGdYcHdScElmekcwR1hmYWkwUmV0?=
 =?utf-8?B?eEdUNTZXam16aDRFbFk3U2lpY0V4VXpoVzRFQllrRDdPZlVXbmQ5QkVPdjY4?=
 =?utf-8?B?OXNIaHVSSVQwNkJSZXUvdVoyZXdYTENqVElMd2dtM2k0YVN1Yk15ZFJoRDl6?=
 =?utf-8?B?Wmc4MVhpMnM5dnVxaS9COEhsMUFJMm5nOW1lQ0gwdkh0Zk5GQmRkNUU0R2t4?=
 =?utf-8?B?bHNMNHJFRUtIYjF3VkZLaVpPTkxSQ2hETit0NFRxOUJhOEJrazV2OVVhLzQv?=
 =?utf-8?B?alk4TWppZ0ZGNUdsZEFSbHJRcXRtZ3krMzVrMTJHbjloV0ZtbVkyTDIzNEoy?=
 =?utf-8?B?dGRWSGFqd0FsOUVYa2wwckFTUmU5M1lTQVJSamF1TmNDZ2NyZ3lpS0JGR21s?=
 =?utf-8?B?bGE3ZFloMXY4RWZGdytuU1FZOUJhTFozU3dGMUV5UURPTWYwSEhad1JLUyta?=
 =?utf-8?B?N0RZcHRkbkl2Z2M3RldudGtFRVZPMWlLcTZsbjFSY0xGTDNpSU0zS2dtVmw1?=
 =?utf-8?B?Y3hjYzRmd1JyOEJtK3lMR0tnR2s4bC9OOS9RRSszZEEyQ2ZWNGtLQW51YTBJ?=
 =?utf-8?B?MXorVS82R1B1d0VOeFZPbHBCa2cvSmNRc0t0d1dkUUFCL0podEs0NzNUaURw?=
 =?utf-8?B?aGRUL0c1Q1liSU9NVG5zV3pWb1dEWDlHNFVwN2pMSERQMGJrSWRIaHFWeVEv?=
 =?utf-8?B?T1BhcEdYOHpwZUJ0Q0RQRHppbThWalM3YWZFWiszRWgwQ3orb1dYclk5dkZo?=
 =?utf-8?B?WGpMVFRGRys0a1paTVlkQmZKUk5ESFdJcDZ4djUyWFJJN3NzZnMrTkN0QU93?=
 =?utf-8?B?VXg4VE83aXhmOGhpN0FRUXlHMEZ0OG9vOEVLN0VsVDIvazZSQU0xa0lza09n?=
 =?utf-8?B?aVozRGM1YzZqR200NkE1NFVMS1NjWUdLN3YrN0xQODNCOFBTVzRDYlJsZ3F0?=
 =?utf-8?B?R0FmZFcrUEJWcXBtUWo4TXFIczVsaWo0N0pVUUFJRlBZQVpSY2xEM1NELzVw?=
 =?utf-8?B?cmhWalFJL1l4anozaTJmRDYxc1U1V1lGeG5lTGZkTFNUSzYva3RsVlZnNXVN?=
 =?utf-8?B?RW1mZjdrVUswT3VJRTd2ckZZSDVMNmVPWDQ3KzNFb1I3TnJqamdwK0haQm5E?=
 =?utf-8?B?WDgweTNUQU1LcW10Y3NSYmV4RmxVdmY0dDhTU1ZUcjV1REF6RkRaKzdxbmFT?=
 =?utf-8?B?clhvSDJ3M2pIdndiZGJXZkFyRXRuNmVwbEZCZjNRd0hMb1FiRDhTczJLRTQ3?=
 =?utf-8?B?aDBWS0wxdGp6QkdwTnM2UkFpY2g4QTI2MmVxR2lqMWM1WHlVV3JSdVFkOHFm?=
 =?utf-8?B?VVZOOGpORFRLaTlsSjUycUFDeFVJZHBtNDhNeittalA3eGhySE5BaXJFWGkw?=
 =?utf-8?B?bUp3MnQ4K0VzSGFLM0JxcnZhbm1TaDNwRmFvZ0JHOC9kd0dMbkIrNUI5OTRH?=
 =?utf-8?B?RjZNUkJQcTdkS3ZKYllXRWJpczVwOW45aVp2UGcrSk9NZFQxMjZPTGJGdHI0?=
 =?utf-8?B?T3o0THhsakhEZ0RSdUZDSVd2am52SUZ4cFY2dHhRaGd1SXQwWmNyWXkrWXRV?=
 =?utf-8?B?dDlCeTQzcEd3TkxqRUM0eTBkeVIxM2NHcXRJK2RoV1VGTlFZdUduaVV6SGpS?=
 =?utf-8?B?bW01VERmWmovN2VZNmlvajhQajhaeUtyME8wZ3pZMkV6WHp2TlRuMXNmK2pp?=
 =?utf-8?B?SE5uZ2FYUGZtUTU3R0JWZHNMblRYZ1Nsemt4cS8xRlJhODBhak5uQW1yWk1v?=
 =?utf-8?B?WTh5Ly9aQ28vSk9Fd3hzR0MxOVFnL0JTT1luZjFSbW5vYUoyWnZ5eFpOVkhn?=
 =?utf-8?B?UG0reUhRajlmU0J4eWNvM1Rhd21mNkR6TWhOc3JwQ1NicEtVcitaQnh2bG4v?=
 =?utf-8?B?TWN5NWxxbzluZnJSeW1nVjVHMFlKOFR5R1oydlc4cUF4Ny9HRnUrajJtTVow?=
 =?utf-8?B?VFpxb2NDOURBQ2Z4WXJOQytKdkFPb1dYKytkU0ZkN3NGZ3ZmZTBiWlRDbzBS?=
 =?utf-8?B?d3NvU0FHYmZpcDZrclduaGZ4N2VOZmZ0UUlOcVVSc0JXU2lCckQ0N3h6U20v?=
 =?utf-8?Q?2Amm2XSGkoXeMmYDOKwCOk8aW66FFthN5SadT?=
X-Exchange-RoutingPolicyChecked:
	shDYkfATuPGxGTzqMpGNnyf5RpjuUtZ+JtBLN6hDZGdQ+3eNsUpE2f+8V/uCyE2OH5ChwslhH6nszfm/VLyVw2ujTlFKiqJt6rp+Q2ALzkDt2DLo9+8Yv9yskb+VwNlg6abtFWrrCouFwxpNZFL7jc1bCBKk9pXoC4YhMrPpm7BZq3PIj56REasEalrG9PXg6HOKD7LcsuqeAFDTu6+/H+9aaWkK4MIxX7njYXHE8yri2lQJ57TBGuMzQxHZWsQdMWvWb58oh8H4U0/lu7ezngJcS3giGHtdGaZTItAsdC1Kn0ymqAFpI0K94QaGXMnevCVfA8drVuxFK/A/c90rBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hp2FK/ErLj7gCSZC2kZNwoG2Ob99KkEkPFEct8qIxyOGJ4VUjJiaw12B5WSS8v5BqvMar+SJ51py18o/xypQtl6444bceyZzqbGtSX2ZyVF3j63u4sFyk3HPBhiwnvX7J4AhcvB3w2x+txiBh1nzRRmY2BQQxMntRo5MmLWz/RDKHiaMNSINvcdARzu5qQM2uNF4eq8wuEdDETrVODlo0sEWp2VI+6x0DwRU1Pcl3CPrceYU8niRoQIgV4WWA2Re5VniX0U+ZAPNOdl+IzxpKEtRwgwr5vflYCr6r0hLwId65mwnZr3Ff+sjQ3VifMN0tDcQlNH6MnWYxhQ+OWMek+Yu1iKzOWMcTo6FLnZ5WRNQ+5XgtdovCaQ7H7ulxnUrj4uhek1vulmxB8ClP7tvxERhGwm4FHLrm9PbsQhRSQdjCBwlKl68OtzkUgl2nQkU0xue1yQ91+cOxTisQSi/yWtBvHlaHk2C0b0/m+Kyup0QBod4TnAhRH+gQurA6qeY4uvzZ4HZtat5/Og8z9ghrAL9wSwuVdPQf9hW9baAgvf+TAkdxHqmt2Y3YSd+ue+s0dL6WdyvusCicklzdQxJUGiVHiotTtspS758GHIKfio=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57c6889-ee8d-4aa3-8245-08df13cd7824
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:35:31.7558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfpjp2P9f70oJLMcT+iCi5SdIsuwMpxuibc3xlIR/K+FVxNMNaayA5DKNSGR8H+qD+n2eMUn82WgvX9WXY74PXcCaeqxvDzBkYK3CQZK4ML60uqFqPtZi/8ngU1NXZts
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX7uF5kgdjW97v
 E9Wfi2knzrUof12pP44NpPB9+e2bpBdBQg6X+FxSbg7AwDMU/0merrEvo3+ITAWF3xP+c4wJsrR
 vsDw4MuCBM1oqc4veHrvcrSPTIj3Wj5Vuti7SEFrA9MMTcpGsU2jYB+OY37JBxJWgXcNi6LqqFr
 V84mzF5Hu5hPob/PhBzldqfJ79Rb/HImt3T3suc89kJqdIfNMvZeFRhK4Z1yZSuOZFW+j24C8Mf
 c7+phEYRfYtWedJJowvrR1z2wPgQCoZwyzDf+g5Wm7FIi7d+KiGsH+Z02FDIKYQP5R9GZjyCY34
 UPiLEdzCXbWWZttSisiB5kc7MrvBdyrRhM2GLzeOfpmSudk6n3ktcQzH2ZZeOtYw2bsrAq7fGsP
 PzfhUnPyRE+Y47HhvkxOkllz9S20V64y2t0jxvWaHr5d7wjs+XtRstW1LBWnlf9z4axcl6Vu3W/
 8n6kA8rJgPdSITHETlQ==
X-Proofpoint-GUID: 5CijBe_-6UDQbT9jJgPKHYyR66rUSm0v
X-Authority-Analysis: v=2.4 cv=dY0VTnXe c=1 sm=1 tr=0 ts=6aaa54d7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=r1p2_3pzAAAA:8 a=tYnSOOS0ReHTOVxoXH0A:9 a=QEXdDO2ut3YA:10
 a=r_pkcD-q9-ctt7trBg_g:22
X-Proofpoint-ORIG-GUID: 5CijBe_-6UDQbT9jJgPKHYyR66rUSm0v
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX1kFxW/bdrQSL
 xqf4TCjZ9MU6fdwCVpOfE1sC9LUVxhAdX95bUOVkqhWn3BweSNaPkdrZu9+ZdALW0tmrjQQ+IBc
 se0UqyoQ4Ye0ZjFTIg58LqMIxZKQAuL5zGLUVtCZvNsVRWX7bPxJ



On 12/09/26 12:28 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: David Matlack <dmatlack@google.com>
> 
> [ Upstream commit 37ffa24c9d07edcd414d34283e02af3f3866cf12 ]
> 
> Mark _##fixture_name##_##test_name##_object __maybe_unused since it may
> not ever be read. This pointer is only read in XFAIL_ADD(), which tests
> are not required to use.
> 
> clang made a change to -Wunused-but-set-variable (split out into its own
> subwarning, -Wunused-but-set-global) that causes this warning to be
> emitted for various selftests and can be upgraded to an error in
> selftest that set -Werror.
> 
> VFIO selftests have been broken since commit ff556bd98348 ("vfio:
> selftests: Add -Wall and -Werror to the Makefile"), and the net
> selftests builds have been noisy due to -Wall.
> 
> Fixes: 24cf65a62266 ("selftests/harness: Share _metadata between forked processes")
> Reported-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reported-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Alex Williamson <alex@shazbot.org>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://lore.kernel.org/r/20260706183154.2660394-1-dmatlack@google.com
> Signed-off-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/testing/selftests/kselftest_harness.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> index cdf1e75ef0f73..4c652d2a80766 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -467,7 +467,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
>   		} \
>   		__test_check_assert(_metadata); \
>   	} \
> -	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
> +	static struct __test_metadata *_##fixture_name##_##test_name##_object __maybe_unused; \


Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The harness now annotates fixture declarations with __maybe_unused, but
the 6.12 kselftest.h does not define that macro. A real TEST_F()
consumer, tools/testing/selftests/exec/non-regular.c, consequently fails
to compile at the declaration. Supplying the guarded unused-attribute
definition makes the same source compile.

Upstream prerequisite code:

     #ifndef __maybe_unused
     #define __maybe_unused __attribute__((__unused__))
     #endif

Downstream 6.12.y harness code:

     static struct __test_metadata *
     _##fixture_name##_##test_name##_object __maybe_unused;

The downstream header uses a macro its included kselftest.h lacks.

I suggest taking the kselftest.h definition from
a7498388b099f08219bad5f19d00e436da27fbf9 before this backport. Thoughts?

>   	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) \
>   			_register_##fixture_name##_##test_name(void) \
>   	{ \

