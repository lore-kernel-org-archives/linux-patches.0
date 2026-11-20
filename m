Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162102;
	b=EK7O7Nl7Zr9KY2yMJiDUhWgzZnMYb5+mVngOuUzx43qsrzOEXWiuOM403JkPuP7qOAry
	 DZXiNO5kbt2ICtntj6AqkXTsUY2OLmsJUTGHZpCx2TdOdjboWrR5zgjMOTbg3CBOUEdkW
	 lkol2T8En6MkAomoWWZV6lrWdD/4FhzY4BaZ06d4ZuWUa3ttJnPLtieSO7XSfLOvCpWV8
	 bNzyQ78JR4pOKvRmHeL+UPnURDUQNO0TKTXQrSDY5rFAy8yjwbSXAubjQ/HQ7Ct4XEkdR
	 VswN44DZhOqEPessgWYOsYvn1y20kr2zGsMo1gzrs1Zf2vuqxVGSLKifNRvHamb58SA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162102;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info;
	bh=cltYVtwyOZGnq/99Lmfryv5NlmCTwUv4UZzjgHQiVLI=;
	b=KkPUM7OFEf+uUWQQwyMkImhLkfsnNPnHQp4EP/2EDjGkuZV/XIkUfy7wYwtrx7Enn8bT
	 ILcA8XT8aQiF7T94CsJTs7tyOpRey/rvq6CpExgUT9UCkOSO7taDLhumXXb8KhDUf85EN
	 FkH/nRa4d0fx0gARIe3O+3FGkKzRYUHz4GNZ6CwOhqnNATZSBT0sVJx/sWCFlkaabuRoZ
	 9lEzR5JMr6BYBlq5ew3HaOJt8hVKMmF5fbEkBs86SJ6PN1p/vZH1Xl/KsdRC2nJ4ypcSN
	 rXjC8i1VUjoFL1mhetGVUN9ZELq5CaPn5g0weetI8NgaQDZx0LpOyluHV0FZtBAInrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=GNUAcfzG;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=d4RRvFfp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3F1606A32A
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 08:08:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF3F1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=GNUAcfzG;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=d4RRvFfp
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK4oUgw094384;
	Fri, 20 Nov 2026 08:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cltYVtwyOZGnq/99Lmfryv5NlmCTwUv4UZzjgHQiVLI=; b=
	GNUAcfzGJ2yEq3DxyzIEV1e6qcsEU41S9rVs5Mythp+aiWIPw0SIimTWFkvDl1Eh
	1Pv3k5Oj5gZqwa0kxjaQCjTrgs4jxSocNVc3OaxsVBeAA+AmDGARHkKTABYM7i2t
	6OsRvp2U6pds/rs/fhfb6L7dFf7HltzHyCR3vOyH883yiOGpVs51GTzUQHad7V4c
	S6YWiwLSjyesIdH9SWDRgbWxr2ocWCiRyvRSPJP/1M4mEvaQON+gtA3T/nd1Amc7
	qO3Y4uLAg1xUt69ngq2uHbLgKOGCNE383I4v6M05j9eOmBrupvId30oaj0DJDx8l
	Bd/JmaazVKzrlsdUXpP8dA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0yttv9n4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 08:08:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK7eD6w3685772;
	Fri, 20 Nov 2026 08:07:59 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012038.outbound.protection.outlook.com [40.93.195.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2gd34u5r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 08:07:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yu+MpllyQz43BTN1F23ath9m12h93z1eROESfBilB3+KYdc8QcDqej4si3FooqPmtDOpYjFU3xkRy09z82GS7Cd1HeTgLpo5/onrWbBY/hVYRgeOMFtTFIR57jjScN5sxYSqONHuWfF3w8Qtl/Fh6OPVfvRA10BTZE95xo3ucayKr4gEy1PyhwQWkPzUbOL5EgZHDFT5K0S2D/SWOwgIs+oR+HcJ8BBI9PyVhySLXvnM+LfB+NQ2EsAS8SQDWd5xgttLdYx1HwIIF3WPj7uaiNMm/BnPGLWNj7lu1B/CtPHTCAeWTqdP7WLm5m6JgmRixp5k6ZbBEMnEuA5JDnWbGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cltYVtwyOZGnq/99Lmfryv5NlmCTwUv4UZzjgHQiVLI=;
 b=fcbO8eF1HXAxSqfc58lbfEgKLMj/Ia8pkL038PrEdgQHZvIef+7ICbfDLrVn2EzgOUPZqqtdgs/KLAoAq/f/9oHtPqIg3gqkTYcaX4ZtFrYdRuf7CKNakO+n5pHYYordSbb/dUpWEbj0eStFu72vE0aAzMGhQKSviA4LsoG4fsoVwg78r7iGhHwLk1Kj+F87TY1LyBveBbA/9ZUSBGY9gkQZFEcAe51whLH9++AGXxer8AxkxLFbRr9E3e6Ve7TAC230Uj9xjFFkevw4d4bZS4egqYFVh60YFH+ffliibK6HXvBiieaCw3HGMf63NxzJaxRPzSVhHHL0pzwA14nHog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cltYVtwyOZGnq/99Lmfryv5NlmCTwUv4UZzjgHQiVLI=;
 b=d4RRvFfpa7rtTQ+/gKXgFsPK3+2v+KtXj29OIiT4LyGk5eLV4BYOO/xmxqoF5GR82LLESFO7UDo5sW/sBPlkQaBHs+TLDruLPsBi+db450zkjx0DOxIUCBtaMSkXE1ZsArJv8ZPDRTamEJp5ttkq044+0C05dKACca2/x4+jPUI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA6PR10MB8135.namprd10.prod.outlook.com (2603:10b6:806:440::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 08:07:53 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 08:07:53 +0000
Message-ID: <a4f52715-73e4-49ee-9bc2-5b09b2195f42@oracle.com>
Date: Fri, 20 Nov 2026 13:37:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0091/1756] mm/madvise: preserve VMA_SOFTDIRTY_BIT
 when changing anonymous names
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, "David Hildenbrand (Arm)" <david@kernel.org>,
        "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pedro Falcato <pfalcato@suse.de>,
        "Gregory Price (Meta)" <gourry@gourry.net>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
        SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>,
        Colin Cross <ccross@google.com>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150011.876239624@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150011.876239624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA6PR10MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf0a6b2-2fbd-4299-de1d-08df46dd6088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|18002099003|22082099003|4143699003|5023799004|260925022911599003|260925021911599003|260925021311599003|56012099006|261028144727099003|261022075727099003|261026140227099003|10067099003|261102123227099003|261022105027099003|261009223027099003|261021121427099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	waX7G8SidjIL9xsJw5b/2m1szISL0Ex+LzZK5SfdZNz4PNO3q36nRgD7acVnVcRWkcqeheV0aOm7kEX2DmwLYoy5b3zSUZfO3YRok52TFaGO/Gsck55G5BkNgxJpdiQxT/5Ey6cjQkj55PTmBR3ovf+HgMGLl8VIPgeQ8HR190wwb5gWiMCj0IcWKU5wZdRZuoNWMwk5jA2ysk0uRqA8EBA0biCntcoupwvLZRWoirMsrffOV84OmrZ7D2csWhUK1Mb+jr+r5JukLy/KpS9hmbFOhZsQCN4frjnc0FB5UANK8F5zc3q2B9mhM+7UWGIhs4Si7Rf1OHxFNqatleFE5SfmgizSfyNh6wH+VvkabQ6BVdIZ3sGpcmFm1318XtrZPVjBEn8FbesGUU161O8UAMw2jkMCfEJgIOaNjo7u0K4OoCHjWliolQXESVfjJbHI0rEkRgsA/lWeLY0E7rrCA5bVQhgMGGAU3Rwu+9YzK0YwKKvWk3ivf2YEFCAejEEM25E3CtjJuvfZn8ItjjRwOGhCoOFguFlfE76dPe16cu3Ma/7nEP5XndbeYSiNedg4EIJQaB4qvrPoTv606z2xUM1oWpoXadoPyj6iCoHqaqI6hidg6pv3nTQD54W+yB9j
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(18002099003)(22082099003)(4143699003)(5023799004)(260925022911599003)(260925021911599003)(260925021311599003)(56012099006)(261028144727099003)(261022075727099003)(261026140227099003)(10067099003)(261102123227099003)(261022105027099003)(261009223027099003)(261021121427099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0pOMldaaksyWUgzZGxFaFdFNHBLMlRjVFNCRzN1M0I5ZndhUU5Rby9MQWkw?=
 =?utf-8?B?bEZPNnVNUEphbkdHZjdVR1V3TGZhY253RlNCdFV4SnJicGs3aEJXbGpzU1Ru?=
 =?utf-8?B?UHFVSGg1cVJwc3JuUXQ3c0FmNjBmRjNRSHFKQ0oyVzE1MHg4RFpxeUxKUnli?=
 =?utf-8?B?bDVLRDBxWDhyc0RQaC9sekhsT3Rpckgvbm1BQi82NU80dU9sWHBONWtNM1kr?=
 =?utf-8?B?ZVB5aFVTOG5GcEd2UnRBbGRIc3VGZFhMa0dEbFFoelFZcEFoVXpXbFhpclZu?=
 =?utf-8?B?VlhMSFpHVmI4NDJEa3pCUXp6ZHFHb0hTMTIrRVZvSi94NlVDYktnTXFxWGxL?=
 =?utf-8?B?L1k1U2NESENQbUEwcU4ybG1ZOEJxYmRubzRGcGFmMjlEaFNzRmtxN0puQS9k?=
 =?utf-8?B?bFZJK01SRDdFbWU0c29YTVVnOEJ5WTFpVUVIQkFJeTNzUkdiczczNWRRaVYw?=
 =?utf-8?B?bFhLSUVMSzNyeU1xcXdYazRvckk2QThkQ2lRL3pMVkcrcVZjRHZPR1hIRzhV?=
 =?utf-8?B?U2pTQ1c0d3BOTzZ4anQ3Yk9rTG0zMUhHVTV4YmhnbDBFOUpxMlJKTjBqaTBp?=
 =?utf-8?B?NzZwR3hOUDZ4ZVQ4dWwxUC9oclJTWm1ZOHZUbXhJMU94SklxS09DRklYZ3FG?=
 =?utf-8?B?c05VZFI0bG5wRUVqaXZjN2ZzU2xNZVg3ZWs3UmhYaUJqSHNGYnJ3S3IzckN5?=
 =?utf-8?B?N2pCQjdhOTJKNnBBWmNSNHJGOFNNSXVHN0ZPV3pkU1RIT2ZJWnRlSG5FTnNH?=
 =?utf-8?B?MVZDVTBnMU4vUCt2NkFzVnVHOEU2SVA2NERZdEpKWEc1SmwrSERyaUhwZ3dj?=
 =?utf-8?B?K0VjekhISmpOdkVodDczeVJIVXNjSG1EbkFLaFozM3ZzbXJRdG9OR1VlS2cx?=
 =?utf-8?B?aVNWNHVoS1oxRklzdjY0UEJnSTJCUXJldUs4SmQ0aTVvM1UzVzhzcjkyQ1Fs?=
 =?utf-8?B?STI5N0JxR0F3Uld5YWRpaUMyQ3dBZ3poVURUOUNmU3cwQmZHYkNYN0lJNGhs?=
 =?utf-8?B?SSthWDZ4Tzl3dUZXSUJoOGhXRHN6Wmp5ejFUS0U4LzlIR1FONHZhR1djZ3Zl?=
 =?utf-8?B?ckRuWGQ0Nno0QnY0UDNtYkF4cis2Q1RwTEY2WGZZOUp6T1ppRVhZMlZhbnRh?=
 =?utf-8?B?SVdoWk5hOHIzYnROK1JaVGUrMmthMTN1c2duNmxYeHFLUFdBRmJRdWtnbC9u?=
 =?utf-8?B?ZVJUQTFqVFg5U2JPUWZGM0ZHamxVLytlVkVVZ3NSeUQvdTN0Rk45a2o4MVh6?=
 =?utf-8?B?YnZGajhPa0lrdHRtWjJwUTRVa0gybUVhK21Dazhjc0hxQ2paZDFUVlBCRlNh?=
 =?utf-8?B?YjFNYlE5STJCaXh3VFM2YUdXeFh0eXJ5Z0JZdUNPU29SRVdWeVh2RkdENGow?=
 =?utf-8?B?bXVtNDJTazhsYnk5NWJoUnNMR0FnOW9RWENraUFNc3VGT1lta1lFNktXSHhW?=
 =?utf-8?B?RTQyejhRSlVqNi9MeW1TNkliaytFQ3JLK1Brck41RjBSbDFwNTJiT0U2NUR5?=
 =?utf-8?B?cmdqTnltSDZITTlkbDlqZys1V05ZYW5udlZ2bG9Qa2k1TUVDOHlQQ2FLNzBa?=
 =?utf-8?B?YUh0YUNjcUtjaEFxMW5IYU53VWN0ejFkZjJ2eEMzUklCS1NIOTNYOW9qUmFC?=
 =?utf-8?B?eWxQd25vaVhVT2NOUEFrS3pwREtNcW9HbkFQb1hqWFZkU1l1NWsvY2ovMmFR?=
 =?utf-8?B?ZFVqVzVaaWFJYW9IaGxDZGUxSG1HZGJLN1J4NUFEN1FLQklPcGxtVmFoU2ZZ?=
 =?utf-8?B?aUtjOVdQd2Y4ckl0RGRrSWxNSTZZWkZXREtQQ29jdDB4eWpNTVN1MUVPQW1r?=
 =?utf-8?B?L2dwSDl6S3lqeEQ2SFZFaUtKMk5saG9uVFhrOWl3SDRtMDQ0Vkcybjc3U2t0?=
 =?utf-8?B?eVpUZTNDOUxBbzNBWno5Nzl4WlZGYzZGUmJDK0VNbkhpeGlKSGROOTdEeEVM?=
 =?utf-8?B?YWNRN25qbWJ0NDFRK0NCTy9CNmRDV3FyTlpjNURmU25Td3pDNjg1eWZSTmNO?=
 =?utf-8?B?TDViN2ZhQ1pxelZrUTlZS0JwekhWT3doNnV2UzZvZmwwcEQwRWZHVXBPNVEx?=
 =?utf-8?B?bTBwKzhVZmZ6OVpXUEZ3WGhINW1IT24yYVFkbUlxNUdaSllSR1dHU0h1ZlJy?=
 =?utf-8?B?ejJ4TVJPdS9wWFlmNHA5Rk91dlROd3ZWTWdmN3loYnRlT1B1cEhRZzBkdVkw?=
 =?utf-8?B?VTlSM0g4MSt2ak9Nd2NRT2ROSzlmOGgrb0JFdVVPM3FKR1FQQlQxT2VBcWt3?=
 =?utf-8?B?cDIzeUoxYVhkcWRiSFF2ZlUwYVdVdlNnZ2d4a05GbU5pSlk0TDZITTRCTEFG?=
 =?utf-8?B?SVpUWnEvVExLSTN0c0hydjZOMkNuelMyNHZ4Y08yaGhLVVZOaVg0QWNmNVVK?=
 =?utf-8?Q?AgX5V+TOLKQGe8vbyA9y47xOgndlsRmiMHzEh?=
X-Exchange-RoutingPolicyChecked:
	q7DyWDSFDD/q/M4noGFPHCvOwj+r8nhWzdfCspNer9Kpp+DmemA7EW2iOCkQNqECjgSkGgna3izFyBex426nYbTqpYyd4j0MP5QvkMrINVZkxckjJaw3TheHvND0a+zezw2XO2w6LuE6qs6VhQ3ERv8wnjyhO+Kn5KDO0h5g5j5YRSe2W96SO2x87pRPAbUYGoZgk7xtCBmu/E1FEuVZXO8UkLGYdB9c1PvXWKMhAiMAuc1+OfQ8RbWHs/XvVNtGU3Yp4aVTLj6QxID/S0QDQOYok0f/2hiUdcSglkHgHiTnTDPbmhL/rqaLVqoWC9woARzWNTEim9TZ2GsvOMVTbA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fgbL4bjmUaiTKbDOgL0+gDT+i0oXZIJDb7TfV+ZZmzunkGGQlihUhD83kLB+WKAja0a65ANK/7x1oPmE0/0FMPeHlrFV/C3AxqQqIWHyEKOT9lY/agfEXZ0aO/dj/i6gu10jPKRvof9QPfPj9lV0fXAmUJfDuDGotvJszvwhrBtrbi26/tVE16Oxx4PbEJ9ZerxVGqaXNb6N3450s+1TLSJIliFrwVs0CPxgpiqF1/WfmunepYbEwwuwA77s0RO1HZdwc67WIMGkEPWRC7hxWWBBfPBEo3U/8N1A+WyKU9MFLjM20fl/J13htC7Byw/tqtz2ksAH8tDgZLo/4m2+x07yMs4X/3+adDYLqkgsdPtuYY5eqHF2qtFASGpr8eUPK1XRBiWA/mX40Vtg80cIeySnBzaWp/QIzrGpOUxF4FzHDPXclCu2QDhoHkONAkv5M9pkGssBzJbtQk2ufDLyyL6v11Qfk8ypr9YIFbkVB2qGSWWZfHqHrwtzOAxeRf4EgvCrOD9e6tB8ur55FeZRsDcnlPcF0vNM6/HzlyPFPvmBzsrO9X98EVrw89Xel1UeOIDQbAHV4P4VCNUDpwrIh6hrditQnL1UQ5V95tqFzKE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf0a6b2-2fbd-4299-de1d-08df46dd6088
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:07:53.2387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWpz31oNTvrHJZQo5AIV0v+3BOWtdM1Vr83j/vvSl9ufxj1fWrOvXtRUW8jrvvBq40ieYjaHFXG+Ud0zKrU/2/WRqZwGo9nsS5t912ZQTIJWit+SjnepQhFvifseKKSD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200032
X-Proofpoint-GUID: i6qdktw6HgBifZGCZwl4JZHYOSP3c8I4
X-Proofpoint-ORIG-GUID: i6qdktw6HgBifZGCZwl4JZHYOSP3c8I4
X-Authority-Analysis: v=2.4 cv=dd4VTnXe c=1 sm=1 tr=0 ts=6affffe0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=Z4Rwk6OoAAAA:8 a=tHa68p0SAAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8
 a=iox4zFpeAAAA:8 a=R4ayLD03AAAA:8 a=rFloE2z4N8W5BVDSHcEA:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=ufIsyHvWW7FwcMbVRpPq:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=WzC6qhA0u3u7Ye7llzcV:22 a=qJlm0-shE6CLU_iKUWNr:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAzMSBTYWx0ZWRfX2SntwR8cTMVg
 mN0uQ/F5MZPaCuz6nyj3knUQGByZbDJagvPz5KeH+V8F3rY7d7dhVNVCrjwh5IY+lruwnzK2A2d
 7hEcdpF7a5olDpUbEliLktShwgKxxECD82uPQnBijyPEvhX++rU/ZbMz7MVmrx+RQcb+iWfOkJn
 59KmPYxcPvbf14GYsZ7lc6Vx1h5uSvivGy7+2GPnFD6GxFSzcXF1PqOGYs6oGfBjCBSVwFRgMCW
 VI2A0K5bM6vKkupckSX/2dLI84cXweGHos5GooUvV1VXx02A1nPU603bedYsLn8GFRCRRQ6aJ3U
 GM05Q3MxCcse+Z0TzmVbkqq13/OaMJzHkqXo1MPklFojAfO8qXAz9YwtWriaFDqDQ2ASws45r45
 +clXUD9p51T+MIMlVL1tR5X7SNLzBTlu/6DIRizNbuKLke87K65ZZWiJJQszY5UQpvv4avBi4bW
 5BWCCbZEhTdCLY/bR+T8tqufShH67OKsLp5tTW5c=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAzMSBTYWx0ZWRfX4/QfLO6svIA/
 swMV9s2a+ZAjEgoTHus50WsesUqvLu9GEHmfujifKU6kxEfyR/lg+TqPnirc25CqkIJl7TT1gFc
 IWAL01RPIrGXtdfcrOzUmk040MMfHGKdleRXoSlxeBGB5uC2xGcd

Hi Sasha,

On 18/11/26 8:06 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: David Hildenbrand (Arm) <david@kernel.org>
> 
> [ Upstream commit 652f15be3c11415725694ccea317c51e35c0b582 ]
> 
> When changing the anonymous VMA name, madvise_update_vma() calls
> vma_modify_name() to possibly merge with adjacent VMAs. We don't call
> vma_modify_flags() and consequently don't obtain the new VMA flags.
> 
> Later in the function we update the VMA flags to the stale new_vma_flags
> we obtained before. This can result in us losing the VMA_SOFTDIRTY_BIT
> flag set on a VMA we just merged with.
> 
> There is no need to update the VMA flags at all, so just exit early. This
> skips calling khugepaged_enter_vma(), but since the flags didn't change
> this is fine.
> 
> [ljs@kernel.org: minor edit of commit message, rebased]
> Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-3-8ff4fae1fc85@kernel.org
> Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: SJ Park <sj@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Colin Cross <ccross@google.com>
> Cc: <stable@vger.kernel.org>
> [ sashal: inferred name-only changes from pre-merge flag equality instead of using a separate name-change indicator ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   mm/madvise.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 6ce97106d6d44..2f2f4ba351a0b 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -140,6 +140,7 @@ static int madvise_update_vma(struct vm_area_struct *vma,
>   			      struct anon_vma_name *anon_name)
>   {
>   	struct mm_struct *mm = vma->vm_mm;
> +	bool set_new_anon_name = new_flags == vma->vm_flags;
>   	int error;
>   	VMA_ITERATOR(vmi, mm, start);
>   
> @@ -157,6 +158,9 @@ static int madvise_update_vma(struct vm_area_struct *vma,
>   
>   	/* vm_flags is protected by the mmap_lock held in write mode. */
>   	vma_start_write(vma);
> +	if (set_new_anon_name)
> +		return replace_anon_vma_name(vma, anon_name);
> +


I ran an AI-assisted backport review found an issue and it looks correct 
to me

Renaming a dirty anonymous VMA into a clean neighbor can now lose
VM_SOFTDIRTY.

mm/vma.c:
6.12.y 6a44160fd54e:

     res = merge_left ? prev : next;
     khugepaged_enter_vma(res, vmg->flags);

     vmg->state = VMA_MERGE_SUCCESS;
     return res;

Original upstream 652f15be3c11:

     vma_set_flags_mask(vmg->target, sticky_flags);
     khugepaged_enter_vma(vmg->target, vmg->vm_flags);
     vmg->state = VMA_MERGE_SUCCESS;
     return vmg->target;

mm/madvise.c:
6.12.y 6a44160fd54e:

     vma_start_write(vma);
     if (set_new_anon_name)
         return replace_anon_vma_name(vma, anon_name);

     vm_flags_reset(vma, new_flags);

The destination permits merges that differ only in VM_SOFTDIRTY but
returns the surviving neighbor without combining that bit. The new early
return skips vm_flags_reset(), which previously preserved a dirty
renamed range in this direction. Upstream first accumulates sticky flags
on the surviving VMA. The change fixes the opposite loss direction while
introducing this one; the consequence is incorrect caller-visible change
metadata.

Upstream supplies sticky propagation through 64212ba02e66 ("mm:
implement sticky VMA flags") and 6707915e030a ("mm: propagate
VM_SOFTDIRTY on merge").

Should we drop this patch until we have these backports ?

thanks,
Harshit

>   	vm_flags_reset(vma, new_flags);
>   	/*
>   	 * If the vma become good for khugepaged to scan,

