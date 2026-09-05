Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFD1368D45
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788627164; cv=fail; b=Uyxc3XhoUQrmdo88eI1OAbole1yhvB0y8rGPtO/cLnhGQdlCkOp0bI7Fb6CN2wAYj4A0djJ6D+M/Yzg4S5oDqxH2VAW9QQG4JvzewbEztOKumXL/18XQfwBvDWeIOFIJNYBnCuorMPboAkMp9AUhllbXNb/ADuflWOvtT2zICys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788627164; c=relaxed/simple;
	bh=7fEUc8Vh/Vmuu0hv8JXFo2fAvklHCMkSQBSWqj5O/V4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ml5tnGub52Cp+p+HABv/TWHcdR9o3o1X0q/Iz3gF+5tx2EKIZGgggmnGEQBpkPbUG0nUh3VW6y6i3OPXTmmHXJQ2/Ibh0vB3SJ/4pO51KEW8JSSsD46bXEPnrXXnQMhx5ld8Y6mHLG/UrLILKoj32ZEhtm5GkHU1RjJfmrpq7hQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bBg1UQUi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pW/W5Z7s; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bBg1UQUi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pW/W5Z7s"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685GB3VV1289174;
	Sat, 5 Sep 2026 16:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ei4f1rQFHuOTw3E8XmZCKCTjUeCZvps9IsdNnqVz0uQ=; b=
	bBg1UQUiMfmiB/zeVyt+3Qd1+lt6CPqL8ACfZ5YZ5pWNtKGSAsoPd0SAfxWOiAw+
	c+LwqkC/9lB014Dv2hLG1OxPMRQk0quhldFSnIkPrGLuepqdiOTF6ECXg+bH5cON
	KHcCW7xybZV1IhkRGSxavDeJjMk1bwJ1WgzkNY6TvHAxD2Sy+BiakhGadmx/CUux
	ZTgVP9J68HuFEmrEq1umnoEgvnS4iEPHnbtif3qOvYPHY4sUkBTrtNs35anPGB3h
	qvtEkwX9p1yM3rlehJ3aDVIremo50+COfWaGcG5DXHKSS+Aq+GD8l5DRF+mbVJ6G
	8yEr57PPALgJdRQue95VwA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbhugb6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 16:52:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685Go1TJ024677;
	Sat, 5 Sep 2026 16:52:26 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hbbkr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 16:52:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LobyXQQChbQbF/gv1fBmEwcoY71It4ewHDmDpqf4ino9B/Po7PFko+kPoRJP28xmGKtcTmRe6vep5xeJsenv6CA9VOuds0QU1e0CxrZG7HGcuIMAfOGxp+gc+pWPqti22E9phWrR7PJmxWtPu1HIkGJQ3BsbIBxR9ksWpW9Mbi6lCFfqC4IuEanOhyOJUjj72T9okMcIYbfAx821cB1frXKzelPf2MFcXUifxfiRFUTtq5IBqXvUbW4v1V6pyT0OwS8UIVLQK/Xg38jf5v0oe/bjvBjVGSKKGIfuHyZ508qvwMNNxRuG1B8vKRaTYPcIxW4VCNUWJaPC1rjGt57UDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ei4f1rQFHuOTw3E8XmZCKCTjUeCZvps9IsdNnqVz0uQ=;
 b=GIxs6PqfmOWiZ+vlgJ3kIEVp3InhqdcOfPPjrdtZFRfxIItJPzf8iS6MiMM9sfLNH4HNTmmlaNEMpyBnSPEiYZ/hqhKuQsLaXmJXgjEUmzMdCPPlwNoFlZhBKXCj2RShmdnX2TdiHSPdgqENTjqI6cgjIlriJUdFoRt8AZNQQYe+aD0JT4mk7HvTcY0M4koF490gppFVvHMD9BsOppqB1zZpT2oVrMhfW7tQjHLEFRL2y3sPNZwxK6UpAs8BtIF6GzMYmcPRmho/xL0PnxEBsKME6XbgNC5bKXqAmbfmgsv5osZnLdskVhsOm4oE6QwAHz9hHGON/0bD1nyDfb9gFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei4f1rQFHuOTw3E8XmZCKCTjUeCZvps9IsdNnqVz0uQ=;
 b=pW/W5Z7sVATVod7Dej4OEuYUCEsMuRXfjKalKXBOb0YXyY0mXAUEMfu2CoDd9Zqh52iK4vbkKQAnwRWxITvxhDLFGYQth+wJqlQg9SXK5d3Sowo9dO8CPB3BYyLTaYnejWh0Hz3QTx0P4dZ/VbrSjjDizomlZuXCL2JtIktav7A=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.5; Sat, 5 Sep 2026
 16:52:22 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 16:52:22 +0000
Message-ID: <2fdbae4d-081b-4963-b009-b803d7f3bd53@oracle.com>
Date: Sat, 5 Sep 2026 22:22:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 023/403] mm/page_owner: use memcg_data snapshot to
 avoid TOCTOU in print_page_owner_memcg()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Ye Liu <ye.liu@linux.dev>,
        Sashiko <sashiko-bot@kernel.org>, Zi Yan <ziy@nvidia.com>,
        "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045735.340715126@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045735.340715126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0067.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:25a::6) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA1PR10MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: ef2f3675-ab98-47ce-f900-08df0b6e0e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|10067099003|56012099006|4143699003|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oMuOaKYhz700BLxEKNj9EAdt8SQrnzD7Y9grzwhwVYJr/zMTr5KXGMJZvFI2XKeGTxr+uQythVtIXbFBKnpPfRSGVxQEDcGWtBbXG7sqSqTw8OTY96Nny4J8nFBNBeBnxgHmQ86lJ0t4+zhuvfP4ynmyaQ86SmTVbe8HObpnaEOf/jNiJP1EHg5GaLoTgPu+x6IXllRi3DTMNoQztFlvdMAlU9JRVtoKQtGjUmqZsHQXypG7SRR1AcklCZ1+cnpQpjfcZ5ySrzJDBjv7DfXZmqJTZL0m56qIZSpwocaVBbp3t2g997nJXJ1VWhZPcDfHEZr8wMLxF5Fs3OKqZXBeoPRbFZVDsw/0KZh/79dcZ9fOaAQsVtLTDFCYzbX4JsIvK8Pr5NHGA6LTUQUpMATmRUGfTm3LDlqH+py7KhnCIiQQA74vWjLtDHKFBzpmW5ze9tpFsvQHIU63bybW+pEhUwQw8EXjhCHa9zhQsGtl8UCHI29hlyBsGnNecFEZ7aDLj9T5PA0iLVcpsuJ2mHoyeey3yJBl23P+wd+9Qa6NWchy4+rRhq7FwtGCz2/ZavSKq5xidtfZVO+YfIDzbSJvAMuNOCOXe9D0VpvWeHAlWm6njZ3Q+C9yvI2bZfv4C07rcxJLjnGNj4dnU5S2TYzhGHaGTajEzPM+BFEsiWWNfLE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(10067099003)(56012099006)(4143699003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGdOc3l3Z1oxREFSR3c1SmM1RGFKeXM3VnlYY2tCSnd1ZkpyTlhKTnhzS3dr?=
 =?utf-8?B?RjN4amVKbnI3d0Q2R2g1a05WUFZOTUJuVWx3cEJxeUxpMC9kRzRKZWxWbHlF?=
 =?utf-8?B?Q2JjV2lIYmphT1NCSTlDWTRXMGswQjU4anZvaDZWbzF4OWdqYVFCaW5iV1dY?=
 =?utf-8?B?RHJJeUNSV2RaZS96dml3eDZLU0Ric1VRUUl6VEx1NTRyTFR6U1EwMFZuYjE1?=
 =?utf-8?B?cXJPMGxRUFNPdStqU1hmYUJKLy8xZUQrMFpDMTVwNjNYc09DdGFtWnVqbjhr?=
 =?utf-8?B?Vy9mcFI3V2FoMHpCaVRjRG9QUk12NUsxaExnd0plbnlRbFFmRi9IYXh2NGNO?=
 =?utf-8?B?RlpGRFkvbWxnT3N6M0V2bUZKYWtvbDdDcmVTQ09menBIZWloOTM1dndWTUJN?=
 =?utf-8?B?UmM0NW9XWGxhcjAxRjEweGMrOXd6d25xY0U3NVRQZmQ4L2hxemJ0ZVdYU0tB?=
 =?utf-8?B?bmVXckk3MUdWY0VvUk9ELzhjREQrNFp2WG41dWgwVXJZSG1KbWVQRjNhMEQ1?=
 =?utf-8?B?NnlLalBIVTUyNkRrWWVhemdrbXNHQTVUN3k4Q0U2bGVyRHhvK1hOQllvRmJk?=
 =?utf-8?B?emUrZWYybG5vaW5rRWpqQlRjSEdzdzNUR2VCNzR3b2NkbHdFM1NtdkxTL09N?=
 =?utf-8?B?QWg5RHRqTG1YdjROUkE0ckR3TDRDRnJBcTI0R2JaejRvdXU3RnAwMCtSTS9X?=
 =?utf-8?B?b1RtcEJlUlRobTVFN0dpSDRMNFVhRTlYaWJ2ZGVpcFMxdDFiYWszNzRIWE0x?=
 =?utf-8?B?V0xvZlIvOHVDSSt0R0RMV3BhNUFUM2tDSWNXVTA5QWw3akJlQXU3Q2M2WUly?=
 =?utf-8?B?eWRoRWZ0SWw5ZCtSWXQwWDQ0T0NyYkJGa21CeUdHVlYwZW1kTlRCRTM2SFNH?=
 =?utf-8?B?eWZKaGQ4b0htaXYvZlF6cW1kOFRBczNLV1RlUEtOYWlRUHBtSUErTktuTEFU?=
 =?utf-8?B?RUR6VlRGWURNSW52VGNWaHl6blFrU0xoRHhOcGFmd2RvYnlVTXkwTVg3QmZS?=
 =?utf-8?B?aTdTRisvNE16QmJycy91MFNMSE5FcWNNa3dyUklzOS9ib05xQnduT2tHNkVP?=
 =?utf-8?B?aTV0cnJYM0tNSmZnK2l5bjRtR2dRV1FDSUZqcVR1OHg1NFBTckxxeDhybVYv?=
 =?utf-8?B?TnR6UmNBbC9ObVZIaGlDMFZmQThnT05jSDYrZVpMN3ZydlhLclBkUGlGVmNs?=
 =?utf-8?B?T2VjWWI1ZGRubzFEYWFjSFRYOVZKME5nTE9kOHpyUWNOeXI4WldOTmhIUG5X?=
 =?utf-8?B?WWkwb3BHWnBHOFk2YkJMVzUyYzhadmZUeWlRSE81LyswNzg0RW40bUhJM1V1?=
 =?utf-8?B?eHVmQ3pqSTFKWGxmUkhEVWlROXhocEY1cUdkLzhDdnpjaGd4ZlQ2Q1pkNHV3?=
 =?utf-8?B?cVl5aHNreWR0UE9VMUg4LzhGWFpFdEZ2WG5wNVZMeGpoRUF0aVBNRExFK3Nu?=
 =?utf-8?B?TzN2WG5FazREeTFSaUdBemxJZHBMaWRVTnE4bjdRVXJqa2VsZ0hlZGZUTWFu?=
 =?utf-8?B?cHlsTkNwK3llcTdkbjlsOEN1aFE5UXFLZldLeHVDanBabHcrQmkrNzJuZ3dT?=
 =?utf-8?B?akRGd0lXa1pNcDVyT1hDTVFtOGhodmxrcGhnUFYwODNJTUVGZ3R5R2NLcHl0?=
 =?utf-8?B?KzU5dW5nMzFKQ0hDU2JkSjlsblpqd24zazJ2Z0Z5VDAzQVBMM0d4T01idUhu?=
 =?utf-8?B?b2orbkIxMC9ZODZRckJJWE1kMWE1Mk5RdFQyaTJnYUpxR3FEWDRBOVhURkNL?=
 =?utf-8?B?WFNDamtoNURjWkZQN2hsTEtDVkpFVERTWkY5VTZqMVBSejByMFRRTkp3bmxN?=
 =?utf-8?B?Z3JZRFU4SjZ2RXBWa0s4bmR3K3F1aXh0MnZTVE1teXZmSndmQ2p6dVB4K0Jx?=
 =?utf-8?B?Z3dzU0o1OTk0K3VpbkR3a3JteHMybVEySk9tUkJaUWI3M2djdWlRNXljMGhP?=
 =?utf-8?B?aFRPc043QjlnT2x1c0hOZXdYNDZDWndQL1M4cTJyY25raldTR0FXanI0OWpO?=
 =?utf-8?B?bWZQN2x6TXZKS3RWZnQ1U3BmcmFrQWVKOTVTN0p5WEpTUS9pNnltQ2lteGhY?=
 =?utf-8?B?aEk2UHBnakZKR0VEVzVjeXkwVFB3YWlRaUlFU0lGaW4xczhxaSt2dUsxQ09T?=
 =?utf-8?B?ZkNWcldkMDFKMkV1WFF2ZjViZ295bW5DNk9uSFl1WlViSXJQVkNqdWtZaDlv?=
 =?utf-8?B?cXFjeGJva21SUmt5UGdiRk5ubU03dlBDRUNmU1orSHB5cDFmNzErTEdldE1p?=
 =?utf-8?B?OG9MVzg4bWIvVFczRDRFWUF3U0oyM0RsZXphYUJJT3BkendLanpjWGNjeXpo?=
 =?utf-8?B?OXBYZXlNaGVtV3hjV3JZb1dudVJRaHhPcDdwVFRIaTZPbUJEamRWcTZzbERW?=
 =?utf-8?Q?DVKofT0cYoFVoGOhP7gEY1bCjdtKNJ+w1jOUs?=
X-Exchange-RoutingPolicyChecked:
	oZzbmXVhNqbU8AZsxNTQ9BHloPA5D1F83fmtX8a1vDwvfsWrD+U0WNEZ528XHZu/U63AA8e1NJCvm9gXxLvJMSEGj6O2WWrnwxQMluRjsELAS3r5ZQebHF9NChM4lJfO4wr8yVkmIr2/aNjo4ZsmeLkn6xIaBhCxU5pEkStfC69X4jRfzKdrqHlwKGm+j3fJcHG5lNpu35X6J/rg1HOAPytsVZ06kgHFG/3xFhLtAbv9S4/lLmUFGXd1XrWpMq2Bc23+QdLIzzID5wfGmEf/QUBV6Y0GNnjrEOfEMQZLMbs55kHiM/7F/4mUmEWD/lZjACgEX+snxpq5afx6tyXHOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w4y53IHnTIKkd0lQ63DLZFz4JXusZeOyTJvJU6jEvZQkfbjIxnGFT33MnRihBnvIsK3FtixEGUd1sxDwIkLaup1LYmMsaYINKrIzUpE5HYUNZv101WYAGP5PFdOoC4kBUSKPd3kEcfXRPUklOuAlyfS3GgZZA1NEghpaMpuk5TmzRJrBnmVBlOZTjGm1y/a5LD32H7nEnFONI7pvs1/QQUyikujhx1ESMTLBL1sJAed0KKr4ls3/aAmQYlxfLfFgNCqNaenBs2yx2BLYe215g8IIUfx7YGstOasocKR9Eq8WDdRc7SH5CB1B2ZjnbAhX88UItB1JWkrn887vW7f2bX1g/M6xdwJE4d2I6pX2iFq2NkulVqJ3NFEgwp0BbFfPYR0fSXHkQsRE836O3wOpvhwTuUq4aQgAkkNvfCoamyC37KFEG7LXr/0r40K5h0f1MabbUv+tV0f2bDILJtbxgqXI5MkAePiCH8oTQOlu/39ajnPt/qR/0ZjoxIFPa6j8cW+HVr9JLu8nAzaFEUTKb0u4c+eKSyoBo6eKe7aiG5m1LQf4+gwsf4zmuwJlnaYa1DNQ2rGlbcuKZDsSi9srdpgGVbiJkjqwInZT69HLLVI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2f3675-ab98-47ce-f900-08df0b6e0e35
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 16:52:22.5481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lz8fnUDvyD9lE2o8LISskRfC0BiUuuZI+NaEAKm4YQ9BxLLwU+OoKyhQxIfZCcNxyPZeOS51iV6/4zvBSd08f2WG3PHvsdEsBkn6Hqvze7S871QTDJ3hvlJ33Te1phSn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609050187
X-Proofpoint-GUID: 3cotGYjuO4hOUichYZlhZ23i9piTg3BL
X-Proofpoint-ORIG-GUID: 3cotGYjuO4hOUichYZlhZ23i9piTg3BL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDE4NyBTYWx0ZWRfX5EnezP6hMa6W
 di/SLJhdLeXzVHUmPTNnYFCCCyvLBe7hdAkYugM03A0EEJ5nX+BigZWCGdy8Knew3OwFDlhU5J3
 W6nzmcmlLTO19lwlC9qqvT+9RslyZ1MxsaAwYv8fljsor214uombHi+PN/ga9k8915AiEQ/Vtex
 3D/wjZQFHkLjA0VrzoIToNawAs+JT8v1JITxgVK0wA5wzWsHU78J3RjBZKB5bTYiU9gJognyWLU
 6QVhcTJS5utm3oTv3iHoQ8IeW9rhEf9uJRmzsl5wRfOb+ceg+efqbSoSxIdQcqqdUUYH983VbUI
 S3IfUHTWd16PD74htoh3VzUqND4NgQdfMegI1HAdvIfL6OQex1c2DE6XjYPS8wbyZzUbkiynePr
 SwqYCh6Mf2wDUuRt7xSC/ezK1GecpPJYiLb6jryHtkfhU8CpgjVwDiQN1LSe1clzIGKkLwcjMY+
 GSykD9DOoT7sC2RIhTQ==
X-Authority-Analysis: v=2.4 cv=S4HpBosP c=1 sm=1 tr=0 ts=6a9c48cb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=Z4Rwk6OoAAAA:8 a=ag1SF4gXAAAA:8 a=FeyXMw8JXyYWBv3KxnEA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=HkZW87K1Qel5hWWM3VKY:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDE4NyBTYWx0ZWRfX3eJVW0dO8VVz
 dCD2hVGZupohdKN9ckpeBT6O0zn9b0m6wUUyLgUsvB8k0v3IAMDJg/C7FqtoUnXN1n5jdkrcBQH
 oAbiZp8Hu7ye25jki0nSLMyGoyH8LGzmkwFMyWsWdVvASmimDrXt

Hi Greg/Sasha,

On 04/09/26 10:27 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
...
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   mm/page_owner.c |   10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -501,6 +501,7 @@ static inline int print_page_owner_memcg
>   {
>   #ifdef CONFIG_MEMCG
>   	unsigned long memcg_data;
> +	struct obj_cgroup *objcg;
>   	struct mem_cgroup *memcg;
>   	bool online;
>   	char name[80];
> @@ -510,11 +511,14 @@ static inline int print_page_owner_memcg
>   	if (!memcg_data)
>   		goto out_unlock;
>   
> -	if (memcg_data & MEMCG_DATA_OBJEXTS)
> +	if (memcg_data & MEMCG_DATA_OBJEXTS) {
>   		ret += scnprintf(kbuf + ret, count - ret,
>   				"Slab cache page\n");
> +		goto out_unlock;
> +	}
>   
> -	memcg = page_memcg_check(page);
> +	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
> +	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;



I have run an AI-assisted backport review and it spotted an issue.
I checked the finding against stablerc/linux-6.12.y and the report looks 
reasonable to me.

Upstream commit: 90f095b816e2 ("mm/page_owner: use memcg_data snapshot
to avoid TOCTOU in print_page_owner_memcg()") can decode every non-slab
memcg_data value as an obj_cgroup pointer because earlier commit:
f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory
cgroup for LRU folios") changed the representation for LRU folios.

The 6.12.y representation is different.  commit_charge() stores
a struct mem_cgroup pointer for an non-kmem folio, while only
MEMCG_DATA_KMEM denotes a struct obj_cgroup pointer.  The backport
does:

     objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
     memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;

It therefore interprets a normal struct mem_cgroup as struct obj_cgroup
and dereferences the wrong layout.  A page_owner read can report
bogus data or fault.

The missing commit: f1cf8d2f36dc ("mm: memcontrol: eliminate
the problem of dying memory cgroup for LRU folios") is a large
memcg representation change and is not suitable as an implicit
dependency for this small fix.  I would suggest dropping commit:
5672bba8d5d6 ("mm/page_owner: use memcg_data snapshot to avoid TOCTOU
in print_page_owner_memcg()") and replacing it with a 6.12-specific
decoder that tests MEMCG_DATA_KMEM.  Thoughts?


thanks,
Harshit

>   	if (!memcg)
>   		goto out_unlock;
>   
> @@ -522,7 +526,7 @@ static inline int print_page_owner_memcg
>   	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>   	ret += scnprintf(kbuf + ret, count - ret,
>   			"Charged %sto %smemcg %s\n",
> -			PageMemcgKmem(page) ? "(via objcg) " : "",
> +			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
>   			online ? "" : "offline ",
>   			name);
>   out_unlock:
> 
> 
> 

