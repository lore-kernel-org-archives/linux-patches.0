Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795282761;
	b=j3iMpSfAluhp1f4x0VmZhfN5MZEEisZf7st3P3T35WMQFZ0AM/thTlNAX/nsM+Qs5yqb
	 XBxE4tvHWkMauwbTyg78U8qVfG3ok2xXXpNNiSLTe14bml6SuVCWWNqEh+DlXtwHSbwC2
	 Xn/80xP4azvte1rzDfaqp0GXjBaO/BZ7d2EAE9ntkTsxMiYOjxb1Ya5NgW1hlsv3BCzow
	 NMfyHvm8eqndB8LWNLs7Rp7Pgi3OWpReXInlJHgo8qHq2eg4ahjqEzYBIlQWMbpRw4jBm
	 lhCDv/vrCCNMEDM5NksMlLbT/7QcQ1MTOXaQidK63W+kp/aPgYLROfPs4kBGaZeajdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795282761;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID;
	bh=7jgRmxQZl9xKqiOt62M2n2nPHithyvFktg+v81bmsik=;
	b=WDq3ZAG0ih31sBnpMISNmlNviWVDmZwld0CRzwF6C6ktPkxEzJTHFxrjVyjU60ANWRqm
	 jSjMXIsX/7879Tqt/+rK6EGt84p1/GhyZk4uA3ks5eA1vbuDCk354awB1F/VhDJtdT9KA
	 qF8LDRGl4hymntBlGTSw8mAu1Tfd/lZq2GbLJOBZbNSodwr1PX8Yj/ULz6/USVTfQJK5q
	 3DizmXB3BjYAklpUh27irOW8d0MzZ4fN7JZzdSTz0+lEkV+JGdeLGZq+KY3niMAVX+5G5
	 Fm69tpEJwIJhrburgezfG831s8gxUwxoA+YtNm4P2l7GQjxqzahy92GoUiju4QIHT9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Ch9BSqP9;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=PDw5o2+z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4CB606A320
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 17:39:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E4CB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Ch9BSqP9;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=PDw5o2+z
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALGfoAN875209;
	Sat, 21 Nov 2026 17:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7jgRmxQZl9xKqiOt62M2n2nPHithyvFktg+v81bmsik=; b=
	Ch9BSqP9T1g/RJeRP3y0cXk4JFIq68aAbrJyxHNG8Q1G8yfeZgIuAl88tNMTB4op
	vdRAmw9xoW4s40d/RnSd0EtpO1ltlFU3uwWGoi2NnzVhbq3nI4Y8PCXjuo82B9R2
	rPOaF2rthITJo0BYeIhAZFYyaPQXICUnhTDGruwf8+unqH43G9Haxus8muJGjzOj
	iJ0GdzQxycJ8J9SY8ncX0T4O4w5pBkCh0pYY1nY9lkYIF1Fkix2d/Ppd4My9nk03
	XjIBErHF8IK4piBetkdIRF+djnu8M+/7z2Icrif8H6cbNShAuaIJaSqyl20WOxGv
	RjeQSSEtpa4qzPxbFDXGEw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34r6r9rd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 17:38:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFX5qo571140;
	Sat, 21 Nov 2026 17:38:37 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011062.outbound.protection.outlook.com [40.107.208.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j38rfpkc5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 17:38:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMFWKnp2ALHkMljI9pN5Wzb5xmjwy1RNnvEZjIS7wQfFWclOq6daHdc/P49LNSX9Qulq8aVGYK5ADc11dLiLNK/4lpTBnRKs/UsONzpki6j+19gbZdzM+R5qc9J+5IFumuSlKbddFbDlZUjpYhM3Wt1BOHU++ig/TCX4+QE+RA4HtjezixJQ0UO2t6sSqPmv7y28LQZkrdfe6e0ecdOkidVWk/OKbU8Bp9m3OJPmMbuYWzoc4I2qrhCL1Ovl8vy1/Cnv/u8yMryZSTZPu3AtqJMAz3zhEAgUbmFXANpVxkrKmLZuXHvfE/rM8luJFyfI2JvYXa677poQM5BGzKC9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jgRmxQZl9xKqiOt62M2n2nPHithyvFktg+v81bmsik=;
 b=ham7YFiXq4rKFV0ZZYl6E6Ct+q2oT0ae2iqKyFNgzT1t1CfjJWc8A2uVHKjshkYxOxBwpbE6V2pTSPkLH7NK3aBAIhCumJKhOgBEO3Z66XDsAtZ1d6BPemsGvTdm7o5StUJheX7zccHF2438/yHSuEMgwuEzs3yAZoXMYsZRFzGM3x2Olyj02yPsDKj+jadlbWDPFiwFwqxA15GHwDDlon1j08eJNTcSjTwp4a+mhLK+mEZG2zX6wY6QG3WrlVJPTbBQECyZxjGyJkJo0gRqTvOO9c5MvQTRS7ubTOhz3itvf9mIn+TJkzmylRHdlFMku1aaTw0REc6CBkTgIwZVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jgRmxQZl9xKqiOt62M2n2nPHithyvFktg+v81bmsik=;
 b=PDw5o2+z0lKY0iVbkLyg30giETKPmWrprWEMaTZb+SMwPD2YnnTA2nXOtWPiO6i/iMHu2YZamXU+g25oQ9pNlAutxWjVk8Om1u4DVDfddgJgeaj0KkER8zILi97CL4zFZvYeq2tHsGYdnQ3LT0YxNtm1RA08kIvQjU47UeWj0QI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MW4PR10MB6607.namprd10.prod.outlook.com (2603:10b6:303:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sat, 21 Nov
 2026 17:38:35 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 17:38:35 +0000
Message-ID: <789028fc-ea60-4ca6-ab07-065d0244daa2@oracle.com>
Date: Sat, 21 Nov 2026 23:08:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1835/2214] seq_buf: Introduce DECLARE_SEQ_BUF and
 seq_buf_str()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Yosry Ahmed <yosryahmed@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Justin Stitt <justinstitt@google.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Yun Zhou <yun.zhou@windriver.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150124.840704105@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150124.840704105@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0201.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b2::9) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MW4PR10MB6607:EE_
X-MS-Office365-Filtering-Correlation-Id: 11908f25-45fa-4b63-68ea-08df47f644c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|4143699003|5023799004|56012099006|261022105027099003|261022075727099003|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261028144727099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	q+k7c8vUsdUVIeNNlaTPJsCM+7Gir/SKdXmTJ2keI8Wv72Vt8+6sUe6STrd/LxwNeRkQTNMYqXFiW860rfmIJKaq8ExyuHbKcrUvDP1NfrSmWI6Z92m1LPIjgXF9WdxuVgO2oRWoM8L+7Yxv1MRz8JPS5tXhpRz2zRnlYx6y7QqBitVdbedesyNuszdCjXDhxEE5iV7UweWjJssJ76yIF8dDYrUAqLEa27J9xh5ZU74KeCgyo4gWECxMG+N0OrPQbNO8ZU/O12RydHj3WRscv1SJ5hdmLoDnNPxFcbKj3+CmbHMcKB/7xq/3dF2fiGO29y1nxZ5SkhH9Qgp/DTmJVxSZXJXRs0XpIniJe8RMPuXwWGyDQnfy5TGFQlKL7ESPo/Q8xlrkS3S42K/9JE6tQ1E2nsRHlFVchIJVX67eZBH5LwtTlruNoG8w01hb1dE0X2PoqHl+IdOuSBU0W0BOufBJX+a8ULOO1fWOQ95TmGl6uk3E4eSW3kiUNZhlaAbWdub2YsNMv2S1S5i5SWo/xZAhNEICZbksQUnkbVWoUHQugsoHlR6x0ZQbeLamOydxSTSGYsLCgSoETNFzl73Nu6e81JRmRNXMMlq+Jbe70UMGBI+Uom+z5PSDVfUwHCJT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(5023799004)(56012099006)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkJGMmpEMWJnYWpZU2sxSDhMT2ZwTTZwQUJyOUJpaWlBWEduRUxOcDdhL0FL?=
 =?utf-8?B?R2p6d3FNdGI2Mitxb05YaHY5VHVsYkMwdW1ESVFYMVRUZVU2Y3dIWVgzRmZk?=
 =?utf-8?B?NFBlZzliS0EzcW5UUEMvQ0RVYis1T0VQSUJTRHBsN3J1Sm5hUWdZS1JoaDBZ?=
 =?utf-8?B?cVJUcnRQbG94VjdXMXNkaW82VEo5TU1OLzU2bk9pd0M1Wlk2NzZIM2RaQ0h5?=
 =?utf-8?B?Z0pleXQ5alZwVjY1WEhoYUg3RWc0ZE8zRmdiTXFLUWxHTVpVclBxcTVxTS9y?=
 =?utf-8?B?aTVMbFk5czh4N0xxbmFhdnViQnQwamRkcmh2cXRVQkJsMDdnQkI4M3hnUndB?=
 =?utf-8?B?ZE9rRUpDdzhmUVB1SCsxWHJYN3FyNWRyTThLUFNQZFkzM2ZiRnVwOEhPZU9Q?=
 =?utf-8?B?Wi8rT1QyYnRYV0RUMmJpRlA4Z00ybU9MRFpMNjRHeTNxdlZydndLTHBrZHZP?=
 =?utf-8?B?YVZrSmk1ZXlIMUYzbmJTMlNsbVVmTEpLMWJLbjlMcEVVTXloQzh0Nk1iYXNC?=
 =?utf-8?B?R1RacUhERVRkUHhESy94ZUF2R3NxK2Q3bjdSZkxnWDc0Z0NoOHNpZWZjVFRG?=
 =?utf-8?B?YmlPanZXSkxyU0N6TjMrdHFUQlJUNndOL2ZCSll1QzR1UGlkQXpVaStaNWN2?=
 =?utf-8?B?dWtBdUVVMnd0NFZ2dlROS2gvVmR1MDdUNUlXU3plUTBOMWo3RmxRWnlHMG5O?=
 =?utf-8?B?UEtsYlZkdkRCOWJQdFgweFcycm9Ub2o2QTVlclZLa2ZFMW45M3ZHMkZ1NUdM?=
 =?utf-8?B?TXR4UXJlN1pVOTBtRmJwNWpkd2lKVVgzdkZvYlhyc0xKdjh3V2trcHVwdW5t?=
 =?utf-8?B?aTFRT0JjZUI2VGJ5dEE4L0RQb0Z6c3pqSkJZQkNCZ2ZNMTZlUnZ1OTh1eHl0?=
 =?utf-8?B?QTljSVhIZndRWlJFNUhzeXpvYXBuVUFsRTYySDNsV21oSVNEbkd0NWJPUkxo?=
 =?utf-8?B?QjRBZUFOR3VuWXkrN3pnTnJKMk9hdTJJZGVka0xJcVNJNjdxOXhsQThoTENK?=
 =?utf-8?B?eDRuOFlLNWpNSUdRU2Zra3pVckpKTTZqczN1QXExUDIyTFZuZ3YrMjVla2Jv?=
 =?utf-8?B?eDgxZTgwc3FIb1RsRWl5bzF0dytVUTd0RFNVdXEvQ1FhWlNiSDllZEJ6bXlC?=
 =?utf-8?B?VDR2YnNrYkI0Z3JuNHB2MTVHRlkrSE5QVjJnbURwNGFjOGxCYUNIbituZFBm?=
 =?utf-8?B?ZUVidTVSbGhUV3dhdExCSHZ5a2FWVTFXZzVPYlRzWEpDMkVBWTVXSGV3d1kv?=
 =?utf-8?B?QVJBRnBtZURPUldEWWQxaG9LZmdtSVFzQjBRM2ROZjdpWXB2NGdkb2pxL2I5?=
 =?utf-8?B?OW04NXZTekRDdm5zVk8wYmJYT1JOUUozZ2FQcWpqRUhxc0ttUjJqUHlRSVVs?=
 =?utf-8?B?T3lweG1aUXVhS1hRR1lrNWtTU2xpbkJlWEloMzlhS1VBNDdlTnI2VnlkR3Mw?=
 =?utf-8?B?SnpZUUdJWlYvZGlWOXUzVWVJNGZuQ2M4SVl0SGk0dE1pQjcvWWJkbUhhU05V?=
 =?utf-8?B?MEpIc0xoeGdYckxiU0hvQ0t1MGZwTVJDWmQzRTkzdHdjUVY1cGsvNENhLzRa?=
 =?utf-8?B?SG5mSFFDK0ZOZzM2K3RaRHhiZEY5MmQ2NXBmM0RGTVBjU1NBR3BSRms0YWkx?=
 =?utf-8?B?cWgyUWJKWFowL2xKWXFvaHRIeC81SXo0N3h3N3FlUGI1U1pFR1YxNUc0clVu?=
 =?utf-8?B?V1pLVElnV2F6dzFGbEZvWnorTjlIejdXc0o4cnVKbVlWZ2dZNkk5RHdZRlNz?=
 =?utf-8?B?aTYrR0M5UExPRlJkYW9LVlRZd2hVQ2k2VitlME45RG5pNGtZMk5qMks4WXF1?=
 =?utf-8?B?WTFEQWRJNzZIT1owUUNmSitDcTEydGhEK2xBRS9lOTVqU1p0YkltRlpRN1FZ?=
 =?utf-8?B?NmFQYjV1czg1bGxJK1RFcndNNStsNUdlT1oyampReVR1ZUE4S2VvQURPZGFi?=
 =?utf-8?B?dVJzbzBKdmZHUkVQRmlvWVNXeTBpS3g2ZTdvT0JEUlMwbzMvZzU0TWZMM0Ez?=
 =?utf-8?B?RnBBdjJuUUtrWFlwQmJHb2w4S2w3TjZlcWdIbm5NVkpTZ0pweUs0ejJMcHRT?=
 =?utf-8?B?V0xDNklScEdCdXFXWjB2U0c4WlE4aUx0a2VwcFlMNkRWbWdyUDZXWTg5V1pY?=
 =?utf-8?B?STgzVXRjOUVGZXk5QzNmL0s5WC9STnFtU2hqcHJvUGJ6ei8xa3VjTlRxZlhV?=
 =?utf-8?B?VHRwb0Jyc0wrTmlUdnI4RzJYeitZOHR5WHBhY016UmJYejF2UGkzZkR3ODhF?=
 =?utf-8?B?LzNWQmxIMEhhYmFrUWRad0ttRXl1ckpockhkOE5DeTIrUS9YQWhTVG00Ym9Y?=
 =?utf-8?B?ekZLaHQrUVN6WndoS091OURFamVjZ0QyUzNjYmszVzg1UVFMaHNPWU1nQXFx?=
 =?utf-8?Q?lxs/qW17CGsPfQzAZd6Pm7u1+ioiNkqI2BF9p?=
X-Exchange-RoutingPolicyChecked:
	QYOFwftZZ/8KaQijenkuzEcfaR3kOOQrmTAanH1CkRpSqf+0noEr+sZQC1NUXgqgXStsd72GsTbMzkmJtB1GvktFEITNhXh4f7HTP5GumBjMvI6PgXdXwjWsk750Kh8DWH4BzGb2ExTBvsIllAmJZ5IsbklSkjbYH1ErfjCmM936aEFrdwHLTNFBe7LRoVw3EXTVdeco6/vSRgpMd/0UydCxG4HEST3I6Z55C1YXLk68iBEcsOzsB0TBc93TJN+uEilmn9YEIcq8Uy/xjt2s/7mcGEvNkKmFlpQfTBlfCdPrLm3QmcqoPEgSnUbeoyP7ezrFzugmzaRM4NHJHDyQkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6qU8eG38sogsvsmJXhWrSbL+LIiidNN/LYBUj/9TuSVaeUD9ji7UjuTWuMfr4U0RK/b48rhPIQ2/H/P2Mi4GwX4jv6mIV/jKjT4zI0Gbn099LSIn5CuPf+jOIT52vd02Eiu6fpWcrxQeWFdS2YgDkbyt8+h0ciMlJnEra4lRw4XcIZrPNKTAP6COs+RIBXA2/Dzt47DLwDZ6QvoVxgy07nhnJ62/Y/bZRfHGAFeiF37C/sSmbCx4RC7R7hcjdCmhJHdi862q66/NhkIbk9OKN9e7tlY0Odkmy6B7I9CBBQV7P+qcTK+b9swehPitdqTlVz0K7sg3YJPuoVHZCDY7j8BZdUheY5cQ2NM05ftjgEZL1nK5ddjwxNpcfk9GAVLwpOm4pvatVnbvkIo7n87fn8Fc2Veqi8fafdhAn+0t8+X7j8TVbTebvhnbNI9ICIloMZD+4eaL7Echk0CZDgteTj7u8y+9UoR8WLd6r2p46eavYYkzCp+uFj3pLkW0YL62ucFZI7anQMEFJqH/4pLCfp8tusahbhGCpB0BFX8knc0Tap+9fDM72IVtHCBGA6B295hk/lk6LvauJj1ZK8voKNQH02UmEnvijx3/lF4+bfA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11908f25-45fa-4b63-68ea-08df47f644c9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 17:38:35.3273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MA/lGIDi+/bIDLjIHtF422b7vC5RCB2bc1wsUcR89DwgNproXPbZ1IvLFzUY6sB/IQTfgogxEsNmfHTx7P/C1wavoU6vKPf/yV8oXt+0F+TNCgIu/+dZ7SRIU7h/vsFj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6607
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210070
X-Authority-Analysis: v=2.4 cv=M5bYuCws c=1 sm=1 tr=0 ts=6b01d71d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=cm27Pg_UAAAA:8 a=1XWaLZrsAAAA:8 a=JfrnYn6hAAAA:8 a=iox4zFpeAAAA:8
 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=07d9gI8wAAAA:8 a=t7CeM3EgAAAA:8
 a=i0EeH86SAAAA:8 a=meVymXHHAAAA:8 a=M-_6R3xnv-BvMn5xt_0A:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=e2CUPOnPG4QKp8I52DXD:22 a=FdTzh2GWekK77mhwV6Dw:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA3MCBTYWx0ZWRfX3RkpjHUE7CR5
 X2uvs9fen/0+H5qD9X5nU2n3zHX7XnhgPEj2pw3p9xYafk04CFpeirGUIV4Nbvcw0oS2rJYdlXJ
 kVZ4ncNzQ/KvLYzeXaKRdDhgtfjcdc2KUokIbzA1BNT9V8kMwck+TXy1eCpGGhu6zVN2SCGosLa
 TV7biO81v31t5AaMGW1SZieNIOhn590J4gTwaJ/6x5Qb4mIE6LyR8dga4vT2KP0z2ts45bVOPpD
 8+BWRWeTO1O6N5Wa32murqrO10Iykl5KpDbLB2JvV1LhL+vZV9160ATd3QfIruDdjFbp+u4Nz22
 AELQzObUuP+fs7wsSXCmBQzEqzXH8asOezbF0nz2kgDOWvtmVJVhwkKIhTwMiR+1MZIrCvxXR2T
 7+HdiJqDyRMEYsdZwToB1HqCBA4PXAx/9KV/Bmq1I06gj2g/Mx+XM/lZNsrWtXoEr4qex14q5oC
 py+KPYsrsS9hGsE4tww==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA3MCBTYWx0ZWRfXyNVwiZhHMVT6
 QalibOkJuAKsDkkUzhP8fq8col1N4EqLree1hrSrmFprKLQ76uKEByazqd3ixVriZBx/waLUZN1
 lGV5ZSGsZQJRJ1hMoiUjhxCElW1ej1aSQNmsTU9oliaVaZ+9m+RU
X-Proofpoint-ORIG-GUID: YWgfnFRXMty-FbmIguVkFeQ_NhBqlmpy
X-Proofpoint-GUID: YWgfnFRXMty-FbmIguVkFeQ_NhBqlmpy

Hi Greg/Sasha,


On 18/11/26 8:28 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kees Cook <keescook@chromium.org>
> 
> [ Upstream commit dcc4e5728eeaeda84878ca0018758cff1abfca21 ]
> 
> Solve two ergonomic issues with struct seq_buf;
> 
> 1) Too much boilerplate is required to initialize:
> 
> 	struct seq_buf s;
> 	char buf[32];
> 
> 	seq_buf_init(s, buf, sizeof(buf));
> 
> Instead, we can build this directly on the stack. Provide
> DECLARE_SEQ_BUF() macro to do this:
> 
> 	DECLARE_SEQ_BUF(s, 32);
> 
> 2) %NUL termination is fragile and requires 2 steps to get a valid
>     C String (and is a layering violation exposing the "internals" of
>     seq_buf):
> 
> 	seq_buf_terminate(s);
> 	do_something(s->buffer);
> 
> Instead, we can just return s->buffer directly after terminating it in
> the refactored seq_buf_terminate(), now known as seq_buf_str():
> 
> 	do_something(seq_buf_str(s));
> 
> Link: https://lore.kernel.org/linux-trace-kernel/20231027155634.make.260-kees@kernel.org
> Link: https://lore.kernel.org/linux-trace-kernel/20231026194033.it.702-kees@kernel.org/
> 
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Justin Stitt <justinstitt@google.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Yun Zhou <yun.zhou@windriver.com>
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Stable-dep-of: fa291d6429eb ("PCI/P2PDMA: Safely terminate ACS redirect lists")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/linux/seq_buf.h | 21 +++++++++++++++++----
>   kernel/trace/trace.c    | 11 +----------
>   lib/seq_buf.c           |  4 +---
>   3 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index a0fb013cebdf2..d9db59f420a49 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -21,9 +21,18 @@ struct seq_buf {
>   	size_t			len;
>   };
>   
> +#define DECLARE_SEQ_BUF(NAME, SIZE)			\
> +	char __ ## NAME ## _buffer[SIZE] = "";		\
> +	struct seq_buf NAME = {				\
> +		.buffer = &__ ## NAME ## _buffer,	\
> +		.size = SIZE,				\
> +	}
> +
>   static inline void seq_buf_clear(struct seq_buf *s)
>   {
>   	s->len = 0;
> +	if (s->size)
> +		s->buffer[0] = '\0';


I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this backport adds a write through the seq_buf buffer
during initialization. memory_stat_format() checks allocation failure
only afterward, so reading memory.stat can now write through NULL.

In mm/memcontrol.c, memory_stat_format() passes the allocation to
seq_buf_init() before checking it: (Code spacing adjusted.)

     seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
     if (!s.buffer)
         return NULL;

The backport adds this write to seq_buf_clear(), which is called by
seq_buf_init():

     s->len = 0;
     if (s->size)
         s->buffer[0] = '\0';

If kmalloc() returns NULL, that write happens before the caller's NULL
check and can cause an OOPS. Previously, clear only reset len.

Upstream (dcc4e5728eea) checks the allocation first, in
memory_stat_show():

     char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
     struct seq_buf s;

     if (!buf)
         return -ENOMEM;
     seq_buf_init(&s, buf, PAGE_SIZE);

Maybe we should check allocation before seq_buf_init(), preserving the
existing failure return. Upstream already does so following 68aaee147e59
("mm: memcontrol: fix potential oom_lock recursion deadlock").

Thanks,
Harshit

>   }
>   
>   static inline void
> @@ -69,8 +78,8 @@ static inline unsigned int seq_buf_used(struct seq_buf *s)
>   }
>   
>   /**
> - * seq_buf_terminate - Make sure buffer is nul terminated
> - * @s: the seq_buf descriptor to terminate.
> + * seq_buf_str - get %NUL-terminated C string from seq_buf
> + * @s: the seq_buf handle
>    *
>    * This makes sure that the buffer in @s is nul terminated and
>    * safe to read as a string.
> @@ -81,16 +90,20 @@ static inline unsigned int seq_buf_used(struct seq_buf *s)
>    *
>    * After this function is called, s->buffer is safe to use
>    * in string operations.
> + *
> + * Returns @s->buf after making sure it is terminated.
>    */
> -static inline void seq_buf_terminate(struct seq_buf *s)
> +static inline const char *seq_buf_str(struct seq_buf *s)
>   {
>   	if (WARN_ON(s->size == 0))
> -		return;
> +		return "";
>   
>   	if (seq_buf_buffer_left(s))
>   		s->buffer[s->len] = 0;
>   	else
>   		s->buffer[s->size - 1] = 0;
> +
> +	return s->buffer;
>   }
>   
>   /**
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 73c0a0c9ff977..6d296ed08d6d3 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3716,15 +3716,6 @@ static bool trace_safe_str(struct trace_iterator *iter, const char *str,
>   	return false;
>   }
>   
> -static const char *show_buffer(struct trace_seq *s)
> -{
> -	struct seq_buf *seq = &s->seq;
> -
> -	seq_buf_terminate(seq);
> -
> -	return seq->buffer;
> -}
> -
>   static DEFINE_STATIC_KEY_FALSE(trace_no_verify);
>   
>   static int test_can_verify_check(const char *fmt, ...)
> @@ -3864,7 +3855,7 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
>   		 */
>   		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
>   			      "fmt: '%s' current_buffer: '%s'",
> -			      fmt, show_buffer(&iter->seq))) {
> +			      fmt, seq_buf_str(&iter->seq.seq))) {
>   			int ret;
>   
>   			/* Try to safely read the string */
> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
> index b7477aefff537..23518f77ea9c5 100644
> --- a/lib/seq_buf.c
> +++ b/lib/seq_buf.c
> @@ -109,9 +109,7 @@ void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
>   	if (s->size == 0 || s->len == 0)
>   		return;
>   
> -	seq_buf_terminate(s);
> -
> -	start = s->buffer;
> +	start = seq_buf_str(s);
>   	while ((lf = strchr(start, '\n'))) {
>   		int len = lf - start + 1;
>   

