Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D222C027C
	for <patches@lists.linux.dev>; Sat, 19 Sep 2026 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789834381; cv=fail; b=AO2PFFInJI3PJHGXa3d8FhH7sk2+h84tw+i/tmlfd+kg2EWQ8pEPVTSoau9boAIRt9bRk1K3JuAEns6shF8i6nnbLhR/tAUbK9EobtY4zBZNCqLwNz+hb3wZgO9Z7SnLJu+lFkWrub90+LWx9yP+Qe6ZOOFXWtNWYPOX8wF8cic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789834381; c=relaxed/simple;
	bh=8aP2lBERmjvlU/dTmIpaPZizXMJbRIrk4k+QKq6dzas=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NWTpdZRQs9kZRCkw5PYEQma7Gcy5VA1mpkVQa8JyRHhWggPxYjzsiK8N4UUYmxmizncircPRaJAFqJR5DHvROdriO8zb1IV4mO+vJS3QTCnCauGFnsZ0DOkRRa0ltkCPRJLvyZKLMI5/RbYKLpGp5zSdIdgtaVKjy7zrQxpcr54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lfbwwitp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XUIn0EcP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lfbwwitp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XUIn0EcP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JFJDaS1293030;
	Sat, 19 Sep 2026 16:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8zFE07ByNayYvNpIeCZrMPdL5yDORQQTCRl4jebfJtc=; b=
	LfbwwitpLwDfwJQf657HjVH21ARk21adiQsX8Qfh2iTyOXL1AmByd13BWZidaMge
	c7bsIrjOXThp2/UuP0s1It8ijdVts0nnspHbtlmUICoG7CL4BjEtO6fXsRWL1BKe
	klDsx2YiTryVQg2dZElFnoTwH3EX+WAaZRwdTnNzDcDrdNUYfxx3Q5u2Gmb8hY7t
	jVpeELj5Mh50Ulbf8vmMZeaPHzpFKNa8wlSxRJR1c7JzHAZWocyJx//rRhQf+K0x
	RzFFggrXwrDAE77HQvKt/rzSzPoWgcHCpbUZeTCoAtoiXzULaKSsT+voyIXHBn7m
	u9Nnabuk/k6g7ZY2gS5ElA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk1dr8x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 16:12:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68JGAedv030528;
	Sat, 19 Sep 2026 16:12:29 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgumrf7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 19 Sep 2026 16:12:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hv2BhRyu9RWtj2ClDJcaOQSQOQ8KIpfOCC1nGTZqqYjlgrmIBk1qcY95S3DeX6FDmkqxW+uUQ3DQzMGhTMmHD+JF+fucQBv6MuFsS4Jwg6Rt6dozww/WiQBJdxUJX7MZJ9SbZ2ZXqr/lRQb2rZcXXrOVrV5cBIXjtB3u65uuYUoDwFHoPDZb1y7YnyItFpP2IY0JX1QiRvQURC9baqglBAI+Dy5NhalYPamJrsSX09A9Mv+O/OPe5suFa0VDD+qNJk5+qRmCojCGbPdfhnFqYFYaSRYEep7mglcrdDvECpATweTWaFRtPtQ2OmsEdDLZLHLGZI15YUMABcR4OzcfKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zFE07ByNayYvNpIeCZrMPdL5yDORQQTCRl4jebfJtc=;
 b=GsZGuTOZFPc+v+dnaj2gprphKoh56gcnqX4y8Yxpw3c7+MGMNc3xjvNmiC7ULx6hTONQnyICuGdvJqbFYYrsboQIwtjtpb2yH2OOBOsnjtGSoMwdiWNaUva3Q2W0LiEwaUCi5O1uGi0/hK951dkPuNTmB//lyf4r8hBgH0HDcKFWcl3+HojEsjtkUyux3Ok5Qae62HVuDxgbJGWlfvjEITsFmn4en8tVoanMxQ+n3WRYtJOCa0pQw0vhebNn2u6tSbZj+3FvTjwmEAQvQ8oCiRu3MKMvRcsN/t3RhimvGdyXBJ8KOgkQPOpLh7vnPs1uXOSZB2hWwAnQugZTQRKTjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zFE07ByNayYvNpIeCZrMPdL5yDORQQTCRl4jebfJtc=;
 b=XUIn0EcP4DATZQqMWdR2o2url/T1eQgA1iU3F4DX/Fo+86DdUdZIvcwVgv0BpZIEjOmqdkb80hZLmqmATn1iFl5SZKm19/odRNj15MhX9sMWCd3i0zYe+A7i/OZoPWJEsim0Oli0vUY5mvj3K/cOtwrRw+sw46mkT02KWUEt50w=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ0PR10MB4717.namprd10.prod.outlook.com (2603:10b6:a03:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Sat, 19 Sep
 2026 16:12:26 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 16:12:26 +0000
Message-ID: <c1b0c844-fb36-400c-a66a-6fc31a60d06d@oracle.com>
Date: Sat, 19 Sep 2026 21:42:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0996/1102] mm/mglru: use the common routine for
 dirty/writeback reactivation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Kairui Song <kasong@tencent.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Barry Song <baohua@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chen Ridong <chenridong@huaweicloud.com>, Chris Li <chrisl@kernel.org>,
        David Hildenbrand <david@kernel.org>,
        David Stevens <stevensd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kalesh Singh <kaleshsingh@google.com>, Leno Hou <lenohou@gmail.com>,
        Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Vernon Yang <vernon2gm@gmail.com>, Wei Xu <weixugc@google.com>,
        Yafang <laoar.shao@gmail.com>, Yuanchu Xie <yuanchu@google.com>,
        Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151605.728374490@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260917151605.728374490@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0291.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::17) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ0PR10MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 76d9333d-96e0-45a0-85e0-08df1668cbb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|10067099003|3023799007|22082099003|56012099006|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5owDXuidNmV41Znmj6Tdb4DdkSn0KmqpeLTYdHiJ2t00CCXjyRHRQVMsFYw7npY59N+oZMWf/Q2ixX1hcyOBT7/vT4lu1rb13U78bwszMfAeyPWn+d8FHjPi/2zpTpSxD6ICFPUq7jWjVRr/UybCXgo3aWkntRakl4fi9eZsgErwT2yzYtxCS8QEHsd71SnNag6LWKhk66jAAdVm2sCpRhkjT8fjpqnsfVBk+GHlDj4VFuVIJO0Jzc37XjwuTESs9md5C7n7bX5yDXRTjKN93gD9AxsaRAeD0dWA8dZoI9p1UVleY0LYTMb3Gl+u2wuow50gQrFRuxiZkXwj1HKZJQFmAIZTaE4qsNg+cGXfiJkeAfcObXe0LgQyyHyOhAnrm5U7gLT/5hn7lwhFcMe2VGnPnJBWpYItxAY4pbdXSqoTp/KRBZFr7+FZ21D+Yw6Ypa70aqp0uw3VCsFWV/XDVvsphhjZRupzzk3DHM2khs9RdzTK/jjCyiSvNxtoomcq67qch+fSEY1v1F7ESU+vjnHj348FzuNCqebApy9d1W4P10BiOD0P/qjnpEKpcCiXk90ULjYRsxG40hUGRTu38FmDuSxRs3I5OVe7Edb9kJYh+tILww8yRwTE+QLfADTB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(10067099003)(3023799007)(22082099003)(56012099006)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDF6bW54Ti9sbEtNUVllQk9ZY3J2Qms3QUtjOUk1cU5UY3d6UXlBcnhvT2c3?=
 =?utf-8?B?eCtteVFWRE9pNk9IZ0YzTWswR0h0QTFQbDJjUHEvbFlhZ3FLUEVySjFIVzNQ?=
 =?utf-8?B?cmlTRmVaV1NyWXRiRDNwNUtnMVFobWluY0p3L1BacGpqSFl6SVNqTHRZSGxZ?=
 =?utf-8?B?WWoxRTJIWnBYdjBybGVQbTh5cHFtODkwRTlqT3J1RExXanJmdERwMWx4RDls?=
 =?utf-8?B?QVJPY3dncno1UHZKQy9neGh3RkVMUDlTUDNjb25ZZDRSQlVMaW1QdUllOTJm?=
 =?utf-8?B?MEJZOGJUK05UckpRRGJob2hGQTZuaFlRN2hVSzZtZ2xxVXI4SXZpWEF2NVlu?=
 =?utf-8?B?RnJ4L3EwWnpGbjhqTmJMM0h4ZE9VZEIwalBFWkRCaklmYksrTHpxczJiNUg1?=
 =?utf-8?B?ZStzcGNQUEFseE9tMmFtcFZtbmhMUzd3YkpPZEdxNjFZUEJRNGtZYm9LSW9E?=
 =?utf-8?B?RHZNOVdwTXZJaURrWFVQTDJHckFxcDY5TUZ4UG9wWlhwTElQZzJUU284NVk5?=
 =?utf-8?B?OXlRY2dxKzBMVjZTQjNiYTE1TlR1ck1OMTF4SGxkWElzdGwySlRudHN6cWVl?=
 =?utf-8?B?WXZvaTB3MVhWUm9lSldyZ3BSMnZ0VzZsVkFDQStITjVDeER6S1VBbm9pUnhI?=
 =?utf-8?B?ckFrbFQzOEJHTGZVak5aa3JWb0VvT0FLa3JxcXhucDdmcWZXU0Z3U05nK0g0?=
 =?utf-8?B?Nzhkd3dKbU90d1NnNS90UGx5VlU2OG5pY0lJeUNFMHFJd1M3RHRKMllQY1lE?=
 =?utf-8?B?WUR4YnVTb1RkTmRmNllYdHp2NWorbERiSXFvWWFiYnN3Y1ZWQ1BSRTJ1bGhN?=
 =?utf-8?B?UVJaUmdrUGV6cll2NHRrSFQ1cktGL1MzWlJBWHN0cFh0WFJQUEF5UTA0QjQ4?=
 =?utf-8?B?cVlKWFU5SjdNQVRZQlZWb0xIQTF3TE9mMnRRckljZENid01pOG5EUEE3VVlT?=
 =?utf-8?B?K2hpWGZOUTIyd1lhSFJzRytnM053Q2EydVJvaTBjTkhwYjRYQTBqcUc4WjZO?=
 =?utf-8?B?ekFyQnc2OU9rRzl6Mk52LzFpRmRqTEpSLy95OThlSDUwcytSYmp5eDZWNWxL?=
 =?utf-8?B?R1Y3dXJsQklVcFFKQS9ZbTVJcU44eVRFVGtjQlVCclZESHI1ZzFTTldNWkdX?=
 =?utf-8?B?RGNYMVlzemJTbXl1M1hVQ0ZPaGdFdnFmSDQ1TFE1NjVVby9XRlBTQVN1WkV0?=
 =?utf-8?B?bVFRakJjc2JVTU5BLzVZRDF3ek1TSnBIVlY1b1pwbTdvUGhTUitoRXZacGkv?=
 =?utf-8?B?aHE0RmVPUDdxRm9LUTB2OXFOcTJOU084bzg5VldlTTFRR0hSRC9vZlZnNTlH?=
 =?utf-8?B?T2c1azc5ZERCQkIxcnVkY3dYNzF3Sk53czRNTjdsYW5oM0xiZU5iSUVFamJO?=
 =?utf-8?B?UGJOUzhhdUgvb2lPWWZWTmxtQmE1ejJDNUdIaUJsaGlScE81ZnZHbFRqSDdw?=
 =?utf-8?B?WldsSzRuZThnbSt3V3p0NkNMV2Q2dERrZnRvcHZwdlc0Wk5NNTh4UW8yVGZi?=
 =?utf-8?B?dGRSK0t2NXU1TXBmRFlsbmkzZ0lBNDFIK1I2MFBaTk1VY1ZXcHlMNUloNWdV?=
 =?utf-8?B?TXJTdlhudG9QQm4yeFJyTFloRjY2L2VHTXFmL0xDd1RzYmFNTlE1NDl3RFNS?=
 =?utf-8?B?bVdKUnR6Q3BIWnpSNURTZHVXTUlUT3ZVdWRRUVF0RVpSK1dodkFXcS9Ba05u?=
 =?utf-8?B?WlJndXA3aG5HYVFBVUhRUkRmRnFPclZBZnI1NHh5RDZQWkVyUXMvaUkvZ2tF?=
 =?utf-8?B?dEtpRkVJZWZuRTlJQlQzdEkyTzFOSklxRGhjK1FPd3dpR1lhSDhWdWtnQk1y?=
 =?utf-8?B?MWJaWXNTdm94NzZ5dVZ0Slg1K0wyaTFZdGlqTlRPdTFGZFA3U0tOVGh3V215?=
 =?utf-8?B?d2FOQUhacHBvWTlGYU42Y1BobzdRS2pZWGt0ek1zOER3RFA3NUtDcDlPWTRQ?=
 =?utf-8?B?L3cxclFidVNJUDB3QUNTWjdnVjVhVlJUMkFoNjE1eE1rSmhWbjJLdFhtL2Nm?=
 =?utf-8?B?VFJETTE2c1ZDUk1QOWtUTjNlOU9Ic0pkWWJrT05Uc1RUK0xOSFFtRW5BeHBz?=
 =?utf-8?B?ZGlpNUs2b3lWYkFkT2NnOER5N2F5VXdaK3lONGRvVmlSU0NWWjBWY2dSS3Rx?=
 =?utf-8?B?a2x0N1FiYW0wR05pVk9sblg5K3RKMkpHUTMwVmhmY2M2SEt3SWQ5Qm9KVklK?=
 =?utf-8?B?QWhkQ3Z1alRWbGE4alJzVmxqR1ZiRUhzc00yNDVYMlJZQjVPWGI3YWZHM1ho?=
 =?utf-8?B?bVZIUCttem5NU20vOTQwOGhVeFVYa0ovR2F4VXV3WUYyLzdud2tudnVNbXBD?=
 =?utf-8?B?dUNBQTF4TVk0Y0hiSTZzNTlUSVMwbmxoM1ZNdHBCQjFDNXBzS3BwZWxRQU9Z?=
 =?utf-8?Q?Lc0RbMadzWWaAZxPpiQl9e8MHYvBdCjeniVLe?=
X-Exchange-RoutingPolicyChecked:
	gyYqnekO656MI+IB+6Z53nLGUUwgZYo0hRJC4U/RvUwwN+Ov4cTr/rV1O8RFcj7TAM1WhqQ+sA5q9FiZgsM010xH0+o3lt1Onedb8gGW9E69psrPphOVKGl9/Xcl67QiJsf7nw2V3QQnYOYGuM8fMGG8/DNfIbCbOXG5x2sRTsSzHBfa7r/wH+993V0DqktsVMmyq11AlWk8ubnGXlbP2/M5/qGh1022CDAn9DMyrXctf+eBOuFeEqm9uMqaJ8475JQE09plyw2X0AlFnLNObEMJ42zPgTa3HjT+T8QiHKeRjVpDqcrgiJY7eW4tAImq5aOxoBtD+uJXt0K5OhUgIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ycVkkGxlK7T3+hRLdUeg7KAyMhNP5AqrVeyazPCYb+XPTdEX26K8owX8y7KxRONjj8umv+A+U76VEosRet19arOcsN0y40JkCCM+JJdvL/QxbZIPY9YLckmvg6dXZ8htu0zZxSB5rZchX3O+J5SQEN8p+CQMBl8ug/xdXCA2mNgTPnovOxnjTEMAZOA6p05a1UBLQTfjDNhBrx3uGyjP5MUa+f64qy9Qx4sY5SC4yqbtLYM6g/OB+LPwdpFvEp2TqSSC83myEBdk6bPdNm0QZgoJsWxMNumeP2GMfscTaoedZBem56uo0xD0K9xgkNgC8qErJs9BmrA/ypzgtaJtjPbiofgGr+CUpgmD4mOk7dYVxl1B15EoVfxsiRVQJZozB3J/shklmaZoYnc1dHzJtxDmUScCNTLh0HCFHDSx5Pv8zzaFQLOy1lOn4x/Iu5NVBEUJLDnrhI824KT1yMxArKysARToNYx79bfzKOjcr1Vq4LzNApMcshL6Qv1ObJhQvvU+iyXMQVsbf6CY9+o9zQhPzzv9Oz5hOd4F3SN15UCGx6U9LWa583ljafFm12VawuZAt8q2W9o2Ik9P/pLfIckW7RJyuwGu0zyjZjvaFXE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d9333d-96e0-45a0-85e0-08df1668cbb4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 16:12:26.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dht64O/dcmToRtMQUWVWiBIYUq+A5B4x8PNQ+W68yGSV+7YjCKo0pAQ4XYEM/38OhYJReAbHhOupIQJcSqlCg2mns3qySEUrjw+77UjqwJ8QUHJ6RaragfjhaXQN9uIm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609190236
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIzNiBTYWx0ZWRfX/NyFRCidLFWS
 RlLXhgiR4eDPmWXhvRUlTf+EJNwIktN3GK37i0d0Q+Zq6oVNWEUmdbwugz4rk3Di3uT5EbbAZVY
 w2ayIcOoJI6rSsLHgiHxArf+E3Jvkz4Zc9xyOGkNeI/Wx8ECLaMj4zHBXgsXW3z7CbTCxvEL8c4
 7lWgtMesAfT2jHu8+kF34SSWlVq9bsdkzaIEOd2JFn3d+qlkNY7+NEdEJ3are71+TBxk+FLlW1Q
 iBJ/g7XTfc3TWh+TYbBBbnWigVGmFnQ+gi4uxfYN3A5X81U39G25G+mW9k5xJRBdnO+fgiQ2SV6
 SUl9ZEYcmhIiXznaP/7O5jY/elwpXmktcIf0/g5QqOMKY+A5aKFP7WQLEmM4oN0QSY9q8/8FxbO
 JlGszj5/zg2vATSg7X/j6B9YaxzippIj+JuPPkTNpO71bzxoyXPl8iSrdzTsZY+SZ6JcSBQij60
 KqmJkpTudmmEFl9JVrgJqAUvCWUD9/gFVyJ2UZBE=
X-Proofpoint-GUID: qMXBU8UcX0HfmUM048rTEVIbbRxOKRuv
X-Proofpoint-ORIG-GUID: qMXBU8UcX0HfmUM048rTEVIbbRxOKRuv
X-Authority-Analysis: v=2.4 cv=eNqGH3p1 c=1 sm=1 tr=0 ts=6aaeb46e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=GvQkQWPkAAAA:8 a=1XWaLZrsAAAA:8 a=SRrdq9N9AAAA:8 a=AiHppB-aAAAA:8
 a=ufHFDILaAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=ag1SF4gXAAAA:8
 a=XOHU4orl1BBBW_SgLAkA:9 a=QEXdDO2ut3YA:10 a=ZmIg1sZ3JBWsdXgziEIF:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIzNiBTYWx0ZWRfX43VjPc9zrNvh
 /beY45IzGJdC9YkKjEjxaF4JAn68YN2HMiSHOBdA/0KcINWwzSsgjaplWNefX5/mj0O0qFDF62L
 DS8a1CaX+OmEh8My4tyu/80hmbzXWBk9azgXxJfGmJ/rCZ9i/1n2



On 17/09/26 8:45 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kairui Song <kasong@tencent.com>
> 
> [ Upstream commit 75d4c3f5fb980de1b620adede47e43dff4d6a5f3 ]
> 
> Currently MGLRU will move the dirty writeback folios to the second oldest
> gen instead of reactivate them like the classical LRU.  This might help to
> reduce the LRU contention as it skipped the isolation.  But as a result we
> will see these folios at the LRU tail more frequently leading to
> inefficient reclaim.
> 
> Besides, the dirty / writeback check after isolation in shrink_folio_list
> is more accurate and covers more cases.  So instead, just drop the special
> handling for dirty writeback, use the common routine and re-activate it
> like the classical LRU.
> 
> This should in theory improve the scan efficiency.  These folios will be
> rotated back to LRU tail once writeback is done so there is no risk of
> hotness inversion.  And now each reclaim loop will have a higher success
> rate.  This also prepares for unifying the writeback and throttling
> mechanism with classical LRU, we keep these folios far from tail so
> detecting the tail batch will have a similar pattern with classical LRU.
> 
> The micro optimization that avoids LRU contention by skipping the
> isolation is gone, which should be fine.  Compared to IO and writeback
> cost, the isolation overhead is trivial.
> 
> And using the common routine also keeps the folio's referenced bits (tier
> bits), which could improve metrics in the long term.  Also no more need to
> clean reclaim bit as the common routine will make use of it.
> 
> Note the common routine updates a few throttling and writeback counters,
> which are not used, and never have been for the MGLRU case.  We will start
> making use of these in later commits.
> 
> Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-10-02fabb92dc43@tencent.com
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Chen Ridong <chenridong@huaweicloud.com>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: David Stevens <stevensd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Leno Hou <lenohou@gmail.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vernon Yang <vernon2gm@gmail.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: Yafang <laoar.shao@gmail.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Stable-dep-of: f7e698e326b2 ("mm/mglru: fix and remove redundant unevictable folio handling")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   mm/vmscan.c |   21 ---------------------
>   1 file changed, 21 deletions(-)
> 
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4358,23 +4358,6 @@ static bool sort_folio(struct lruvec *lr
>   		return true;
>   	}
>   
> -	bool dirty = folio_test_dirty(folio);
> -	bool writeback = folio_test_writeback(folio);
> -
> -	if (type == LRU_GEN_FILE && dirty) {
> -		sc->nr.file_taken += delta;
> -		if (!writeback)
> -			sc->nr.unqueued_dirty += delta;
> -	}
> -
> -	/* waiting for writeback */
> -	if (folio_test_locked(folio) || writeback ||
> -	    (type == LRU_GEN_FILE && dirty)) {
> -		gen = folio_inc_gen(lruvec, folio, true);
> -		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> -		return true;
> -	}
> -
>   	return false;
>   }
>   
> @@ -4402,10 +4385,6 @@ static bool isolate_folio(struct lruvec
>   	if (!folio_test_referenced(folio))
>   		folio_clear_lru_refs(folio);
>   
> -	/* for shrink_folio_list() */
> -	folio_clear_reclaim(folio);
> -	folio_clear_referenced(folio);

^^^^

Hi Greg/Sasha,

I checked the AI-assisted report for 0ad8312612a0 against the older
6.12.y MGLRU reference-state protocol.

Upstream has, after 4d5d14a01e2c:

if (!sc->may_unmap && folio_mapped(folio))
         goto keep_locked;

/* Continue into common dirty and writeback handling. */

6.12.y has:

if (!sc->may_unmap && folio_mapped(folio))
         goto keep_locked;
if (lru_gen_enabled() && !ignore_references &&
     folio_mapped(folio) && folio_test_referenced(folio))
         goto keep_locked;

The backport removes folio_clear_referenced() as upstream 75d4c3f5fb98
does, but upstream first applied:

4d5d14a01e2c9091b128fb46e1d07475e9a7bb72
("mm/mglru: rework workingset protection")

That redesign removed shrink_folio_list()'s old PG_referenced shortcut.
The destination retains the shortcut, so a referenced mapped folio can
be kept before it reaches the common dirty/writeback handling which the
posted patch was intended to use.

The missing prerequisite is a broad workingset change rather than a
small stable dependency.

Maybe we should drop this series of commits ?

thanks,
Harshit

> -
>   	success = lru_gen_del_folio(lruvec, folio, true);
>   	VM_WARN_ON_ONCE_FOLIO(!success, folio);
>   
> 
> 
> 

