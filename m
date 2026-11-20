Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795157887;
	b=T7xSPNV8tI+qctinO+5ti4fMvJ4KjmxPW9kqas8LkDook3us7cMAVP8LRDX34BPXBlvt
	 iBsfcovZjQgl8ihAhT39EpU+OUqBAGTcdYVydt+Jo/qqsmVKJRjWDXU0gFGPzZ8D1ZJsE
	 TaYQzJUGSjjbDZ/Ou3tWt0z8Zr+hb5z8/w6EI+QwRlhICZyepm2n24p/4tuG15YO8KRnB
	 xOVmaZYdDE/QGfqDRdZlz5sqbDIOirhDmf5izreV2LepN0zV4KMYPbqqTnf3zYqlNch75
	 B6T+8oFf1dZ8BD9INYNefzYd4Pv0bD1wLVAEqv+ZobP30Zx2rv9FCx6sNQZ/QPmafWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795157887;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc;
	bh=5dPli+nG568FfgAozvFO9iY3gfcrRMWVTWS69WKFe68=;
	b=Bd0oNYSG2Un7MV15wuK8GYJjmMRkuXOQKqwuVvxgTagoi0zWDc2QZY4sP9r8jkJfRD4J
	 y7BOQQLpeT0Zg2ToIz6qwBUq7NXIIuLibTjH9NTImNhxYjUxV+V1O5XkJnYsYbyw6OwSl
	 Lyfn/5QURkMZEcz6hcZZKzjAUNu9o+JoBIDkufvx57nCU7KarDs7L5hQbI7w+ZEFdT5CL
	 /9MPzCoESFKMbqpzEjAuJUfExsJmk0qu6adJj+D0NHPKa/a5OmVjSDrKQPY3B1kutqiC0
	 5vuVJMs5OL5g1gEOB1rDPqKj7/6xn2WuHD2zIBrubaee3uO70VYzjGIiPQMZ2y+1SBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=oohlll8D;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=J29y1Xmz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A0A606A325
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 06:58:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6A0A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=oohlll8D;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=J29y1Xmz
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3ZOQ2739120;
	Fri, 20 Nov 2026 06:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5dPli+nG568FfgAozvFO9iY3gfcrRMWVTWS69WKFe68=; b=
	oohlll8Ds7T2tsB6brFPzGoKR2ONVwTVmf2d7QQ2BdgLG5tMY3hVZK5SfkaHydq8
	hUiFc6TQBK69SH7rP57J1KTIJ/G/XlZmldRN6SctPGwr3b71vKoAUfUo45TWjPmj
	ltSdGISnizSZ6k2d/JMKKvWkOwXkDy7Zywlo+HJ14nGjM8xl0z0Qk2YwL2kDTtrA
	ddw0N5gmX603tSvpLF1JTFBMupXO9SaISyYgaIFaofocGm33dmz2j0vZRooU+aP9
	3CX2dNtH1r/LPDnJ61wcZRr8F2C3MNW74CRNnEAbNeQMxxraxrsba9xccDRNCFjV
	4ztENo3cKO0oqvkk0hH6gw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytq4a4y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 06:57:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK5e1Eo473574;
	Fri, 20 Nov 2026 06:57:39 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j2g8t2mt1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 06:57:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/LvDHjxITiL9F8TVCvZpepxTVmpdr76iSzmIlM8Rlu7eXmpi4V7ml1GXmEyNsqJHSvdgLDcKGbCmZI+gSvNn3OfRoOGBAuV5tBQAfKiTtKe0OSVMocTwruOjWhUJYsgq3xWO3d5zAuEQTRErJKJgRKsIwO/U++mDU7SJ5v9T6bYO0/r51Rdx483pdJNsXsaa3C1mIV2x+Dmg5ZoO3cs4RQnLJck33tWBRCLnhMRryDb5f+wBUNoOTlF29EnVuOvVWtKVODqrXyOSAlQCZnk9LXH53gAKYnBNDh35c43pIFnVRvgSOKc9lyp9U0cr14gapINgAFzIqXrYQ0pBzrU1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dPli+nG568FfgAozvFO9iY3gfcrRMWVTWS69WKFe68=;
 b=iUBEMAJqStlcrG3B+WnXjqm/sQY9dShbCTCar05XbRwTD7stMEj2t1GkdeLjh1hL3m+vtDZzo/Zi8EIFO3yJGMO0OJw1WqnG1KR1/3zlLyJrRZ/CtYGm7mMbFNmM1Y1H1daiy2TczBHFoLK4yWpGKGGEUF8pIiD7OBsFj3+F6uWUJsISt2wRpPOnsCXdA54ZkO60yZ04COEjhVVjeuOuvGfW3XQWl6GU9uxYii+M3b1oCuBO/g+eK9YvnFmrOnsQmcNYJ5RGfbDqLrT5P2uo1Zdqtg7nQ0FO5X0TpfG3YpetFLsgFjgIMyquwqanQRybNYVvcpZnyf+ba7xauH9UHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dPli+nG568FfgAozvFO9iY3gfcrRMWVTWS69WKFe68=;
 b=J29y1Xmz2DvncAbEE8UhuNsAQ7QK3+slQND3qtS918OJQnLrvnF2Yz8oIzzIR5oCLx2K7gbQyGNCY2UvNmw1vZgbtsn11HFcX+TmDOs/m+mYNvbHKc4BQLYvGFve/dqGyPXUEnxbIBN900ZgOh08axlhSzeMurImoiesYbxNfGY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH4PR10MB086291.namprd10.prod.outlook.com (2603:10b6:610:51a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 06:57:35 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 06:57:35 +0000
Message-ID: <4496ebac-05bf-4350-a12a-8d8808e6553b@oracle.com>
Date: Fri, 20 Nov 2026 12:27:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0074/1756] mm/hugetlb: fix mremap deadlock when PMD
 sharing is possible
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Li Zhe <lizhe.67@bytedance.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
        Sasha Levin <sashal@kernel.org>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150011.252566240@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150011.252566240@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::21) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH4PR10MB086291:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a705e8-740f-48a2-391c-08df46d38e47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|261009223027099003|261022105027099003|261028144727099003|261026140227099003|261026121527099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	zAJcpKpGrOQRaiaxxwdOSQcaaCPuBMyI7Ve6g1aW5FmMge3iDOy9tyn3HEZdTPl0pfZD3rfeAWmTzuhpsAmUz7RSryC+ByyzJ570M/0UyraQHedLc1nz0upDkwIvlYehXhTMpM2yqL3Qy5A79c/ZRntFcFjQ3eZI9q2750pCYzQ4CpfsZrWvqAslhrkSPOFshGdSjCbkOK62BgdJb7HhcvS1KGJqMtytPkPDwrq15jP8nP9Ap6mdd8aaCsakZduAHCl0F8hn7wBGqgK8JNM7zCe/WLeV6oSfubS4pDup7Kwh17O795PoFMn/zMshgCCkat6he1wbTzbmYcRIU/4iZdrJKDrVLbJUxmA8VdWgynhxfRzjfgjjkpMeMZZMrTQT/mESvRdeQSW+zMS2U6CbqjrJSIPSyreM0OyVyl2j4ZRB4oHUkUCoqT0C6z+SzzzRR9EfoeZJbgPT1K6G4SaJ2zb4zAJzlao8btfhwTjd0HW7OQgA5NnQZRlGzz9BbbUMfBoXvQhg5+J5IOD+Gti3mw2WV5k0wS35aJ47QSOsdO8avlLLg+FG0+5F1JvP+jOzJXwP0YCiK9NhOsM/Yrs5+eE529SYZSz0X2W2OVLRtrD/dmN8rR8wDpDZXkXNBcLoRwNmrTuMBNpnmwFG9aAjqetIE/SehDXamiw2pDFVV80=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(261009223027099003)(261022105027099003)(261028144727099003)(261026140227099003)(261026121527099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1JzdzhRcy9kSFRiRTQwYlloSFdiRHV2cTA4MG5tSmdjVEZLN25MckVqUXZJ?=
 =?utf-8?B?N0J2V29HYytNc3U1cEhmbmhEL1hWd01hb0hoTzlMQnVHc24xNG85Nk45d21C?=
 =?utf-8?B?azhYOGtqT2ZqUmFqelN6YlMyVmdBQXNRTDgzY0ZyMzN1QzZuZGcrNjlRSkVo?=
 =?utf-8?B?ZHNMcVorMktVNUdEaG4wc3IvQ1NsbFpNU2RZTFVtazZHZU5zdHdITjVIakV4?=
 =?utf-8?B?UDRacjF6Sy9iWlJ0OHJ6NHYxeW15TVYxN2tCOEJodWZJT0pHZTBYWGdpZGN3?=
 =?utf-8?B?WG84MUdJTzdnOGR1MmNhZ2o2OWR6b3BRNU9DbDF3VjZ1WFpFQ2o0ckhzTmpR?=
 =?utf-8?B?Ymg0azcxWlhsR2NwdVJtc05iRnp1MkJwWmw3eUZSQ1dSU1NWbEJQaEQxWmkx?=
 =?utf-8?B?Q0cvYUMvREZIQlZPVXBENzZ0Y0ZCSFRJVFNjZ3Y2ajR5RkpvTlFBczVrYkZX?=
 =?utf-8?B?Vmw5dnVnWTlWZGRycU5hd2lYOFpXNUQ4a2sxSnhmNmZHSHVYU2tML2Ewd2R5?=
 =?utf-8?B?ZTJPOFFuNE8rdklrYUdPTW5WVC9RZXQyN1BZOGNWcE5qbEllSlVyZkZEdXJC?=
 =?utf-8?B?MjNIVmtSTnlrL1JCUEtjbG5mUVdZMjZMNG5CVFlsQ1FwMjhMemVTakxPVDM5?=
 =?utf-8?B?bXlxVVl1U0VHN0dndmNJRmZ3MklkQUo0RHZiV0RRSExOR2ppMy82Q0s3a3BF?=
 =?utf-8?B?V3Bsd1N3d0NHK1I3UnVTd2xsMDhzZ2ZqR2RaMCswbENQRXZhS3FDQjNaY0lv?=
 =?utf-8?B?NzRnNGd0K0pqNWtoTk0wRzdaSWUyQ2NWMm9NNjhUQ280NURtUUpiM1djL3Q4?=
 =?utf-8?B?ZDQvN2l5RzBxMWMwaFg4bXZoT3BKOFp1aEcwUlBPRjRVRmdBV1A3V2hFOUsy?=
 =?utf-8?B?ZjNLejBuS2pkbU5xeWNMd3daS2w4TkhSMkp1UGNNc0JyYzd1RndReDFPOCs1?=
 =?utf-8?B?a1hIU1FNUWNjVWRGR1N1VlA1cDlhMGx6NFpNTGdIY0dtTm5kR0REalB3NitF?=
 =?utf-8?B?NkRKR3NkSW1lWkpMUFVHbmw1bFZrc3RjVzd1QkNJVU5Zbk5pQXVOQTNKZ0Fo?=
 =?utf-8?B?dGh0ZTd4cnF2S01tVURxTGg2Sy9ENnd3ei96TGxWTkJTWVpyeDFST1d4enhu?=
 =?utf-8?B?cmFpck9rTFQ5RmNTekJ5Z2hqY3dsTSszWVRGYWJma2IvM2xSOHNQNGN1ZEhi?=
 =?utf-8?B?OUt2eWZGQ2h1bVZZS05vNVIvUnp3QldON2hyVyt1UEJyMGpxamx2MlVjcUhr?=
 =?utf-8?B?MGZLMGczcjdSUUxuSjJwTXFMdFI5NnQ3NHA5aENjY1E2TlhJYWsrVU5hSTh0?=
 =?utf-8?B?eksrOC9mK21lRVpmZlhDMDNsVXlOU0FOQTNac2M0VXFwWHY4Z0pJdGg0Mzgz?=
 =?utf-8?B?TTI1b0pHSXN3UTRNWFZyVkJzNyt6NG1GZ3QzYUZLaGpVVGgyNTFEMU1Zbi9z?=
 =?utf-8?B?cEJ0SDlPUDdsdW9sZVNZbFd6VnhQS0o3MTBaVURFUHRLbGNwR0YxRkptZDFI?=
 =?utf-8?B?QmttQWdFbVg2b1BFSHk3QWZuN2JqRWdBbi95YzUwVis1YmJrRXo0SUg0Y0JZ?=
 =?utf-8?B?TjBidkgvTzJUTjcvMmF6dUphSmI1YndPL0R2QTVhbVdxc0cyamZWT2VKUDBQ?=
 =?utf-8?B?WFpFazdhaWJkNC9HbW5QWjhDUkxiL2ZBV2wweFowU1NEK2dlWW5GejFFdXA1?=
 =?utf-8?B?cVhrVDc0YXpwSDJnNkJPOHRiMkNtenNQTXZpV1Fvd1NXclBRQ2VEVU5VMEpm?=
 =?utf-8?B?RmNqR0RjVVV3SGgxRFhHRmpmU0grT0I5bTNNUkwzcWszaFZLRCsycFdXMUxs?=
 =?utf-8?B?VWgrbXlYOTVUNWMrbTdBYzhrZzF2MC9oTGNsZktQNGZWQnlKWmJlVUc2emNm?=
 =?utf-8?B?QngxNnRiTEllRDFoMldueFBKK3prNlNxRWxzZG4xOWlmdmxuaFZleGhmOXF2?=
 =?utf-8?B?enUvQ2YvZGowZHlTZWZENWl2bWxhWXNiajhwUnZuYmRGZUhGYm5kWFNWU2xj?=
 =?utf-8?B?MVZWNFEyQUxXT25IMUtpRlhCcCt2dENQY1lSc3hPNnIvVTIyNlZZTmExWDd3?=
 =?utf-8?B?MFRNYWl5Z2dyeHdZUnBnZ085a001d2xuSXozSXUvOWZxdXlFcnBjYXpkSmha?=
 =?utf-8?B?ZGxrdXMyU1BvbDk2dUJCc21DOE5zOExDNUg5Q2JGc0JMLzZncWJxWU1LUmhD?=
 =?utf-8?B?dmo0MTdQZ1ZxT3VuQk5JSHpnSUZXUTh4Q2p0R2VsSDRabjdzRERjUkpUTkRG?=
 =?utf-8?B?ME8yRHRMVDYrOG5JcmxjYVBLWExTLzgzRGVrYXk1ci9pNFVlYlhya1ZrdlpS?=
 =?utf-8?B?cHJYRy8wK0U1STUrdHhIaTNXc0lhdDE3WUlaYkJoMmVidVZIdFA1emR6UHBa?=
 =?utf-8?Q?ye2qS7Xm/AS99e/GYLFyqTeiXpy6yhDXqbN8m?=
X-Exchange-RoutingPolicyChecked:
	N1AYM6s5DGzTL5Rflb/HoGmzETtkgrpnW+TMqxL+08pgy5TzRWucrY/Wl3lWHseGkSyRxTU4c4Y19r0FRxYW2AjLx+SXNilSBOEyM/fJ847mjV9CdVp18GhDS5cB0vovrkkEU6ktR2xtNwd6z7FIfWu8Ny5EEl+IE5UVgBcP7eJDaUhFBZDFRZHq3BJX/DvbyF3G3/fc5DK3D7fOcmw5hzQpmtCNe49oKE2kmN3sOmww7jpG6ojyv+vKaeYaNcLjJzQ2uZ8BPPDcmjvfOd5BFSTXug7kbv01Dmt1KnM5pum/rpliUyAltR0eh8tl238s9IOVOMx4lVlc36RpavCBhg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xs0Fe/fczsLcv98dVUBbxQzf1q1UoFu4L7VeAU7VItAWDqb71WfzlPFSUX7hgk5V7YBeMXCxtrC9YTn87IXCxNCq8FPQzPoiQhHCjmbneBBdNqHaLLeA25eNd78nIkI0KecXDThPPSB/elAe+BYYUSMk5gscAOOa/FUv2ktuLUQdwGhPn/A08zSZc2iyG6ShOr9QUID5ewjuihE6ZCAxWqQADVOQObggILvA0KwymSRiHM/ZkzW+MJHbwqQkIIYtXTYnwj1Hwd+xpNohLtIHO4/o66dD9NqOlVBvSUZlfdxadic1UKELD3wxOLvVpSs7me18SlAp1XeqN/4yY2ms3WD6ifXLiF6N8IntXeaLkdSUY8j1egno44vii0UTFZz3K7VwXxXcKy6b8EPF4f2OE8qSqW6aCpfgAH9ExIcugx7I4kdr4otf2AhVNl9VIndjapT+NctC1gt1Lc0Fes8LLqn9OIpG2JPMhlzIObSTV2CebzV7vD+IAJ5jlx0xStY4ZUbzN6PSTw6SwQEeqSWDw5kq3uzIQTw5VPVCblh98tiC20wlXv93ZesQlybYZgYyf9wlmEJLnETbErBdciBgu/V/LvFIEM7LV8Xq2CEIMV4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a705e8-740f-48a2-391c-08df46d38e47
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 06:57:34.9991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0WDRgdVMurgr0HVueqnHEWexz4MKfUDUUd2lguG4hpdNPZLlrZatWtfOQWbskHpuzxQn2xHXbX7hzg5Izku8QQT+KtE7y4DOurK04y91jLRB9gWlIY3xqoyLipgtSVU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB086291
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_02,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611200027
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAyNyBTYWx0ZWRfXwzox+MmeuqFV
 +ORI+Pk2jOLkpjgOBiLkaGD3WJZq+RUfY0WMFL48FIB39+gD1NwGWh2ItEH5695hO9FkBjcNYro
 FDgGVv5W0PpIWnwSBKskMZPn3p1gRudGuo3yJ+vrDRTjo5tVLlgY
X-Proofpoint-ORIG-GUID: sxHOUbAGGiGQnVNNFo5AfxpUNdD-qqwB
X-Authority-Analysis: v=2.4 cv=WsK+otfv c=1 sm=1 tr=0 ts=6affef64 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=968KyxNXAAAA:8
 a=Tdy_sO0xf6OEPb2GKP8A:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: sxHOUbAGGiGQnVNNFo5AfxpUNdD-qqwB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAyNyBTYWx0ZWRfX8k40YL6nqOXs
 oUqaUPMBKvW1h9yLUJkH5LfGrAlLlgpjBstrYRO6t4Af6cLEkSD/F3pUGaBP+jtCSHNz+Jrqaxl
 ITVGcsmDt2MpACN2td06KfqE5VmK2FoEXLJDuqdSCLdna39BZB35AmabNyFDCETYgycj4EXaKRb
 dh7L72K7yZ9t1LTSmLK38F9LhXgcuLKiKDH0UVd1HD3VwYrd0DYjowCoN8KdU5Rs7y0tEbaW3vX
 lMdhOQ0nSQtvc2CRBpMjXEqdEsl6gMAt9oEloY+7necjmbiJQ6PfM7AyXuXcH3day06mhN3D0kC
 WyWpKDZBeIJB1CADEQzTM2gYJx6xXrTnSby89fPl46Ll2HDDXL6JZ8X+6t/2+Xir/O5/RWhbGMN
 Sk5z7ORzvllfivBINA/hhC3jcTheuvBIoAI4IUENugtobihjPWeRnwCKOPJX0kd9dh8W9Q+foD/
 8gZWe7RRXqex+FWpN9A==

Hi Greg/Sasha,

On 18/11/26 8:06 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> [ Upstream commit 92daa8652f88c8cfc05f4899a8408a04b02f211e ]
> 
....

> @@ -5556,6 +5562,24 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
>   			continue;
>   		}
>   
> +		/*
> +		 * Avoid entering the destination PMD sharing path while holding
> +		 * i_mmap_rwsem for write. Leave destination page table
> +		 * population to the fault path, which can share the PMD lazily.
> +		 */
> +		if (sz == PMD_SIZE && want_pmd_share(new_vma, new_addr)) {
> +			const unsigned long unmap_size =
> +				min(old_end - old_addr,
> +				    offset_to_last_dst_entry + sz);
> +
> +			hugetlb_unmap_range(&tlb, vma, old_addr,
> +					    old_addr + unmap_size, NULL,
> +					    ZAP_FLAG_DROP_MARKER);


I have run and AI-assisted review of 6.12.y commit and found a missing 
restriction compared with upstream 92daa8652f88.

include/linux/userfaultfd_k.h, 6.12.y -> upstream:

       static inline bool
       uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
       {
   -       return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
   +       return vma->vm_userfaultfd_ctx.ctx;
       }

The 6.12.y helper permits PMD sharing for missing-only UFFD
registrations. Upstream disables sharing for all registrations.

This matters because the new path in mm/hugetlb.c does:

       hugetlb_unmap_range(&tlb, vma, old_addr,
                          old_addr + unmap_size, NULL,
                          ZAP_FLAG_DROP_MARKER);

With an unshared source table and a sharing-eligible destination,
a missing-only UFFD mapping can reach this zap and lose its poison
marker instead of preserving it across mremap.

I think this is a needed prerequisite: 809cbe72ace8 ("mm/hugetlb: 
disable PMD sharing for UFFD missing mode").

We don;t have that in 6.12.y, so should we drop it ?

thanks,
Harshit


> +			old_addr += unmap_size - sz;
> +			new_addr += unmap_size - sz;
> +			continue;
> +		}
> +
>   		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
>   		if (!dst_pte)
>   			break;
> @@ -5575,9 +5599,10 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
>   	return len + old_addr - old_end;
>   }
>   
> -void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> -			    unsigned long start, unsigned long end,
> -			    struct page *ref_page, zap_flags_t zap_flags)
> +static void hugetlb_unmap_range(struct mmu_gather *tlb,
> +				struct vm_area_struct *vma, unsigned long start,
> +				unsigned long end, struct page *ref_page,
> +				zap_flags_t zap_flags)
>   {
>   	struct mm_struct *mm = vma->vm_mm;
>   	unsigned long address;
> @@ -5595,13 +5620,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   	BUG_ON(start & ~huge_page_mask(h));
>   	BUG_ON(end & ~huge_page_mask(h));
>   
> -	/*
> -	 * This is a hugetlb vma, all the pte entries should point
> -	 * to huge page.
> -	 */
> -	tlb_change_page_size(tlb, sz);
> -	tlb_start_vma(tlb, vma);
> -
>   	last_addr_mask = hugetlb_mask_last_page(h);
>   	address = start;
>   	for (; address < end; address += sz) {
> @@ -5728,6 +5746,15 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		if (ref_page)
>   			break;
>   	}
> +}
> +
> +void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> +			    unsigned long start, unsigned long end,
> +			    struct page *ref_page, zap_flags_t zap_flags)
> +{
> +	tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
> +	tlb_start_vma(tlb, vma);
> +	hugetlb_unmap_range(tlb, vma, start, end, ref_page, zap_flags);
>   	tlb_end_vma(tlb, vma);
>   
>   	huge_pmd_unshare_flush(tlb, vma);

