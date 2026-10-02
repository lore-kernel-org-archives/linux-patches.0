Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AD33537FF
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 21:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977892; cv=fail; b=s7u5pTbhtzu8quB2m66J6k020kT4/U/uUFGxpNJ1L8Gwn5+1qXQ5spdTMTWvUEBipjwQUi0/80VfEqRjhr9uWB1XgFPTPeKVMwag5m2xsPFMkvzEW6q4uchFS3qKR8BMxuQvEO7WsEe/pB5qKGWQH3bisRbccVbgLDAExrS51W4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977892; c=relaxed/simple;
	bh=vagkGa8SnY65gXBUAAHZQDHhKVmDDwo9VUMAktUvOsc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TP4oL8HYO8En/Y0K+Hz/bCcbL10IlkNflHrJu4Yp2OzvFFZ0xLX10rB/KWpsB6vMbcUV0qZYwCoIKWZS7i6Y0HzckEu2mGxL456woOxUYefJZcMVOTqPPnevkPahHLj+mYTTsZxlKL6xdG2bliwvfY0o5f6AeukJYDii7X2dhhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KWH+qhoL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jmLlce+6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWH+qhoL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jmLlce+6"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692Ebbw53156276;
	Fri, 2 Oct 2026 21:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QcKX4Q5T8PjuiZAYN/FKmaope+0pdoizO8d7796rxkI=; b=
	KWH+qhoLcpjWgwgHz7HMGrw4T5JAr828fNPsgxDnkgbMq5dWAgt/LBTJNU4hZCuN
	mD1/D//7kwGG4v8UKfPrFaVaiFvQ/1b7mHz1GzloxXgNmYmg/PVT0usANL0in3fv
	RW5ekwC/9uQckx/asw5EW0sj7/cwXpuY+/78xHEY5gYknXqHkpbNCQm2ecpwW5TX
	pkyoOACDUe568OEdZsCi0R80E9/uMmUGAtS6Xnpi5f+DmuBCcgbrjjS3sVnt1344
	A+YSrJi+GJz1Oq8j3NIfTESu+Wrz1NKNOzkIYVUudQDR8ZnVQO2MCsMwFojfopZj
	ECVa6XCFTQh6GsSoEIaJUQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx6kscsmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:51:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LZ1Cl040878;
	Fri, 2 Oct 2026 21:51:17 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h2f6fssbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:51:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PiBI+/KMcvU7iZV/cjDO/mQkVqsqVfBi1O8Pfp/N/+ItPMQWwacXGSBTkdxzoxJ0jyYkQcLr+c0S1g/U212969kyWlI0IREj5QslCmyOG5fIYqaFz5bp5zmlqDIyeACEsyq2cw4jzmZDH2I1ch1jnII4bqpzeRPIr4+8iF2QxKMwqjlzum8JQheWT4/vjUDMZItlhelIfX0lHFSefjnythwBtWyiJHtk81RyOFLThRXc+kXUdWwmad1hYFn0J+OvTNhXvDa7Q2hWP+dMMouZWfZX31DGmMQmrAuReAB9kTTt18uG8CjrX0LpcHkqGanN+l3Gdzoy7f7Sm9DOpZ3GGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcKX4Q5T8PjuiZAYN/FKmaope+0pdoizO8d7796rxkI=;
 b=V9jhhtiulJWT6+qRZjjftvTUGGA6SuVJqWJBcElQPwIeXR/K/5tq0huEOssY2LNm4iYU3g6peXwKxaX0zG8TkG6eo4iGB+/Pt88CmCEoxuz+2JHwIV44MrnwRGTh/Z9qoV6rChBbf73ZXSrMfyiIasTG5CB3yudXAKGIU6wsn4iAKRtJ8VuIbJtCmNG7555iu8ZJcDYV6Fe1hx2O+CV94PSBDGy7c7Ajtyw5+uM3o9AgmsFG2rKPodk15aXaZx0pKP6VJUzEg/6Kkmyl6cVr2PO+TEAF0DRKLlyuw4G/UYe5s/QXYKGrEQObNk5+ceQFhKJYNiQ96oNlHfRMd/ifGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcKX4Q5T8PjuiZAYN/FKmaope+0pdoizO8d7796rxkI=;
 b=jmLlce+69CGIEGf8sh58SdajBPGDxGkdu+RzEQL0rYEtrb7pbN2/Rj2FepFZvPQdn9eU6sDuiDlm8c6mVUaFwf9gnTguA50IqmBkT/i6lExLue6SPWl+7VfacifQXOoB66hoiY79jQY0BU3dS3BNXiIndK1gJoC7XnuFA+22SPA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by BN0PR10MB5031.namprd10.prod.outlook.com (2603:10b6:408:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Fri, 2 Oct 2026
 21:51:14 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:51:14 +0000
Message-ID: <bd75a7df-709d-429c-a83a-bf5392db4e63@oracle.com>
Date: Sat, 3 Oct 2026 03:21:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 610/752] fs: avoid repeated scans in evict_inodes()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Julian Sun <sunjunchao@bytedance.com>,
        Jan Kara <jack@suse.cz>,
        "Christian Brauner (Amutable)"
 <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152411.483612066@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152411.483612066@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF00000179.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::44) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|BN0PR10MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: f95691ad-0518-4407-91a8-08df20cf4786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|18002099003|22082099003|3023799007|56012099006|4143699003|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	wpsOLhzM/98OKcEdM+M9Z490rE5tRBqJ7RONCWWwmcdx+yLR8JHXJbkE5yI+Xv0/5WlEeMu1C7tFcPtq+ENWrYu90VfwbfszDOuGtIGWeVIUfobRbOIoWxSPt+Oyb03uNQyHk1aYfmvYirDV6dWa8uzWTB421rdYk/WacqK+ur5hss9gsPiT7Wy9chCDpcvjTeQ6oGaEf+2JXUVeov84x1BztJ1114eugEEeJyu4Nms32bdKehm2xHRdQJ45krDtj3rhZpRo424jDQdY67+XrpzBWiGwHUCrfKaQEy1tDb49istoNP+/45mcyGQNETnHkW8R/T0LK7zzs+w5voV5MHMrP8HBcIQ8sxUj0k+68+QSgu2zIb9oQtH3J2nRrKu8Xw1oVudfF2JrVhgGa0FQ3uvBZR0nwjpWrtwMIaXbtn6+cS8yeTaiaX047WrEEpWbY/1n54LDNllBadYZ5nuC/481W92Zl7UGqSaU3tN63Z1ezZI3s5kMp0YTPHFMjib9qdsx05+t4aEXz+8JrGHhvVgroUhKby9KL+ZtODSetiM4QoHzpkpWsssdwH1PAnXZwtzgURW+0lEeb8Ge+Yn3XTHkDWrzLp43u0HtIF8J1pwyrxH9FtIHXa0452twpKcm4Qt8r7edGpIxNgBB4ZkxBuTRGicG7HyjqzT3LvDlymE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(18002099003)(22082099003)(3023799007)(56012099006)(4143699003)(10067099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVkrakEzVEY4WE1VbUZ4TVU0MHlsNnRaMWJoZDFEb1NKcE5FczFPekF5bTRJ?=
 =?utf-8?B?cXhaTHdINExZaDlDU1ZYN0JzVjAxRWtmZ1N2YVRWNWR3WDMyUHdrU2QzQUJo?=
 =?utf-8?B?clFXZExKZ3hwM09XcEpFZHhPcElBWER5d3hpNVI1K1hiUmNNL3VrVFJDajNv?=
 =?utf-8?B?dWIrWG1seGhhanZOWjlrTmFBNXZqeWYrYnppWjJMUkNwemdrS0kwQ2poSVZr?=
 =?utf-8?B?aTM0NWdDaHY1YzRJbi9pSWJoTEE3MGptTkNvV2JWWndIUVhpY1dwOVdESjhl?=
 =?utf-8?B?ZS9TNmVPR1UyVnBrUnU0cS9NUXFQcGxndm5NMkc5OTh6Nmkwdng2RURwdDBG?=
 =?utf-8?B?aGp5QU5kNTl0TG8ya21DbW1vZWxyR2hQSklWdXBiU1o0clZNaVdZcERodWJp?=
 =?utf-8?B?dW1mdS9oLyt3RHNGWFJoNG5QODZwQkhaM2FlOXgzK0pSRUJscWNrSjBiVGx4?=
 =?utf-8?B?MFIrTGJ3M2RTc0U1R056ajErc2VtQ1UwY1luN0tTdlR6dE9hd0I1MVRIeEJB?=
 =?utf-8?B?STV6NmtPQXRwTHNZRVBUY1hCSGMzODFXVGZpMis5VjIvSXhyM05scmVpd2lF?=
 =?utf-8?B?dkhhZDY5cXJvQSt4ZXI3bUhxcnVvKzhCQmlNZVhuSU1xK2VOZWZOZUljZW9L?=
 =?utf-8?B?ZjQyeFBDUHNkY2xYcVp5TmNLT29uN2RzdFZhRDVGLzZkRnI3aENDZThIZGdJ?=
 =?utf-8?B?OVFSdTEyeVo1M1lqWjBxd1ZLSXdmS2I0S1F6a3p6QWZYTElqeGxqQTA0L0tF?=
 =?utf-8?B?SElYOFQvYXl5QW5nRDJXKzlKQ1F3cy81WElaMjkvc296SVpSaWYrZDE3VzJm?=
 =?utf-8?B?M2dtc2pMMU00aXVlOTVIT25ZSFhMRHBoM3ZNblMrOWxMSVlPK0ZEZzRQS2xq?=
 =?utf-8?B?enlXOVQ4YS90MC94SVpIMGdlMHF6VXcwVUF0N1AxcjhnL3MzbzhMTm01NFU4?=
 =?utf-8?B?eUovZ2lpMGwvU2xOWlAyZ2Nqd1ZBQlhhWWJnVUZCdWZCRjd2VkJaVEVDN0RS?=
 =?utf-8?B?NjdXeEdPblBMUi9YU1lOWE40bC9JVitsalhTL0pTNlRFb2xPSnZ0L1ArZFlx?=
 =?utf-8?B?QnU5amROYldtVHdJMmxXdDVGd08wckxnY2xCV1NONlVPM2k2cTM0R0hKZWpv?=
 =?utf-8?B?UVFXdmcwTXpVdEJGQnpnUmN4MnowcTNNRFlnVFRhOFRJcUZrb045NStjMW5H?=
 =?utf-8?B?cXpMbjlnU2REWjVHTFJzdFpQVDVYZEtrRmdPcVNjK0tHeFdrVXRMNlQrNDU2?=
 =?utf-8?B?SVgvQm5raHhEM1JUeGdVRTdvK29CRW9peDZGWEZZWklRQXJEWjgvRm84Qno0?=
 =?utf-8?B?OUMzWnlwd2hGeHAxYXJWa09CWktXRC9EQkRpdmcrYUxvVUJDK0lMSi9CYVZJ?=
 =?utf-8?B?WFR2Z2tJY0Z2UmgzamhEcHpXMG1sU2ozWlVIZkRvS3NMZDk3dytTM1hMdXQ5?=
 =?utf-8?B?MXhsZjNMV2NIYmVFNXhsTGhiK2VMVGtpM3d3TFlLWjRFV0VZK0UwNkNBUUdG?=
 =?utf-8?B?NW5yMEZZYmVaaXhDUXdpcVhJd1JVQU9uR0ZZaDNDWjFDb1dYK1VXT3VESTFp?=
 =?utf-8?B?cnNDRWxpZXJrK3J6YkJ2Y05TbmpDZ2pqUDBSZ0RxV1k2SklXcVpqSllHeUEz?=
 =?utf-8?B?ekRqT0VpT0lDYlYrYStzZXNOUC8xMG9IQWRiSkcvajB6N0krUUNzekwrNVFW?=
 =?utf-8?B?OVl5QjN1eU83VjBrbkxSRGlJd3FEalRRQ2JuVVRmdnl6WktpTFhpUmEyU1d5?=
 =?utf-8?B?SlBjTG1pTjdyTGR2S0l6SENiaEo3U3hOcTlyd0tXQmZnZ2IwR2VBa3U5Vjg3?=
 =?utf-8?B?QU80SnN2TS9WRlZLUkM3SDUvVlhoOTRQRjM5UHd1S05VQ2xDQXJ2ZlhyWjdn?=
 =?utf-8?B?clNtNXhyVkdKVlc5NEJHRmNFbEFRcTV1T2tqNXRaWENrTTNJclBFZU1DSElX?=
 =?utf-8?B?QVZYSFIrZHdib01DRTMrOWJCNEdmT3VjcFEvdnN5b2VVVEZqMjJMWCtsWmM3?=
 =?utf-8?B?VUVGWjU5ZURoSXF2enFYTHAzM3M4QkZZRmNlZC8vbDc0eDBqd3BQSnQybk9F?=
 =?utf-8?B?Rm5zWjFuWkdSdlFHTTlsM004SkhGanQ4bjZnbnRkRWZHNUs4MEpWVTBnbSt4?=
 =?utf-8?B?R3hxVUVBUkRRYi9GcjNzQUY0ejdoN3BxbENIZlJmYzM3dHhHbyt5aVlWbmVT?=
 =?utf-8?B?L0cyL3M1U09ZSFg1emVtWDh4Q2V3enQrNFVKMGVHTGxqNnp2aCtGUVFLbjRV?=
 =?utf-8?B?QTloekZJVjlkRSs2TjZiZnpWcHZWMnZBVTc4OWpNR0NGamJ5MytiK1Z4alc5?=
 =?utf-8?B?S1AxWWgyVDBnZjZ1MS9vVFFkQyszOS80VVpFallOKzV5TDdlTC9oeWJNREM1?=
 =?utf-8?Q?kg5UYm84aGMaNMes1qixCDoMT+fFaxgUv4n3D?=
X-Exchange-RoutingPolicyChecked:
	EXT0/S1rORGjHdmGhZP4YQx2lr8sefhe3t4RigJuK0Xe+9xKLjfdoUHh2YwLjhGoKkiJrKuHeBadkxRe07vdgiYoraH8wQIvPl1Mnbviy8PbMx1k5q4MxVQmm0GzpbjBgXml9qU05rEqgXlqO0KRRmCYTKNdxfYyiNeRb/oRffuZsoxWMuv38I/FTSqrcEIrG4y/0CHwxIZvs4hdH86IrYd0rLffq5kZuXJC1PACw6bZ/Tm1eoNp3ucAzBXIsSKQLqQun/t6lcMblGxkml9OXB6s3hNCxE6k7slXUinOufKTiHKBJtyBEBOTWkzPX10A6xxrAGzWx3Y/EjR1Dtgu5w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jP4UJyXWAc1FOT5oYXStGd5zIZKXjn4Y+aQW3RgSxzn1DiC+HRA9hTJyyVTQz+gkQLJghToSezw14CFnDBzCjVFNG+eiruDNc67LNFqXfyinhCFEDoljMy73Q6bwXssejspFtRRqL/7/gqrdo1brBPgRkoqIcskTqTLjxhaGcQfUkXzgfSYxaggmsfZHnq9bObgyKgyxPt9LsGcVbFMLVv1vgdp0F0DODRTA6D2K2q2jRr8qA8c7ESPt66W4xGWKx8ChJ0DyirrSR4v3o1IZsSleHmASESN01gREHs8Az8ub/JxGKjmndeekYSO1r0w6AmbSkrOEE1zHXkwETTrVumv3fvO2jl4NMyhJ6R0yvr6T5+Bkbaz4/I/p/90/wvQJ77TiFjDYDR0ZDDsb1R8e3O2vSsLj/kum+tSDgClV6Jfdee4U8eoztgcX0DDMl4Krttd04PVKJUrttPkFOBsYmfeovTUTjQ+ZRkEjKqRngbe8FdOJuduyntdCBtSuaKchamzhmWoehuLWzHBjdcS5oDGDvyGQcqd136lkUbnGUz7cUIMXN+YKgR+fZc8obz0x7yXk+IJas/ueHCNgoxo46PagxXg+UWxoA4GrvkRVj3U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95691ad-0518-4407-91a8-08df20cf4786
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:51:14.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2vAhUiegltO3058BL3zRMFVrb/DWo8ES1EdIWfKT1deEkExkisoEospVffUXvq48919DSEVzMQarn2BuK68nOISBmkqZn+85ZME8x2+5Ujh1IyTa7i0mO3HVK+Br//g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=921
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020086
X-Proofpoint-GUID: SHt9SVLiTDUXnMda7Wf4RRe47SNSl92m
X-Authority-Analysis: v=2.4 cv=U/gHnuru c=1 sm=1 tr=0 ts=6ac02755 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=968KyxNXAAAA:8
 a=yH0Q4Tlzmqz-_qVO7AMA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NyBTYWx0ZWRfX04cM62QAPp/3
 P0IfeFywJpQ+ZP1L2QVMB8g+EO6+ycpvjSwiRBPsBAlODFnNLnFd+uYelMfYYsPGClFD+yYnPB+
 vQSXSe2VJ1Omk+s2OO5wJ9gIkDhak9rKHcyhZ/NVQ3q88cFo3mJ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NyBTYWx0ZWRfX4nNAshIfqSL0
 MTpnbrjpl+OwVxDQcAl/ylbooodsbD5s/QI46zla13GB7+hI4089lBAkkp39DYbLRmTOzMxoNOD
 fZZDWGtoOol2gOAYZ/UOK7X/1DNhJ9r/Wdn4k9txsOxAmZLEVaWdH1R3MtSrEjihfZjPSglDFbw
 z3oBcekXASbmtiBEGz6HL3mO5tB38sDuH9Jzs01vZo/ZFin/GjUyY/l7gIuCBbxZku2qxBLIGx9
 qY4BvdcK04Qh0TGAMPGtscgwRgmN/ZMT4bRqAwlafoShwc/z7OpOmWVbtF8YIRObtP8XxD0g9yK
 PbKdsTZ4xsPf6TGjjE4cojFOQfIsaxzAgyPiw5PV1kgryBbvcPlNCf7bOJ94kjX6Da9ulN9KQIY
 Hnvj8WoROHbqh3gRRTDF/Ghxec1CrDou03mJe+dLdnWAf9JY1Exh4NeVyaxojrLQggfAgOFtLwu
 LLxCQcjLRJYzYg0if/g==
X-Proofpoint-ORIG-GUID: SHt9SVLiTDUXnMda7Wf4RRe47SNSl92m

Hi Greg/Sasha,

On 30/09/26 8:58 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Julian Sun <sunjunchao@bytedance.com>
...
> -again:
>   	spin_lock(&sb->s_inode_list_lock);
>   	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
>   		if (atomic_read(&inode->i_count))
> @@ -715,19 +714,19 @@ void evict_inodes(struct super_block *sb)
>   		inode->i_state |= I_FREEING;
>   		inode_lru_list_del(inode);
>   		spin_unlock(&inode->i_lock);
> -		list_add(&inode->i_lru, &dispose);
>   
>   		/*
> -		 * We can have a ton of inodes to evict at unmount time given
> -		 * enough memory, check to see if we need to go to sleep for a
> -		 * bit so we don't livelock.
> +		 * Keep this inode out of dispose so it stays on s_inodes while
> +		 * the list lock is dropped. I_FREEING prevents new references
> +		 * and leaves eviction to us, so we can resume the walk from it.
>   		 */
>   		if (need_resched()) {
>   			spin_unlock(&sb->s_inode_list_lock);
>   			cond_resched();
>   			dispose_list(&dispose);
> -			goto again;
> +			spin_lock(&sb->s_inode_list_lock);
>   		}
> +		list_add(&inode->i_lru, &dispose);
>   	}


An AI-assisted review flagged the evict_inodes() change, and I checked
the iterator expansion and concurrent inode-removal paths at the final
5.15.y tip. The backport removes the restart but keeps a
cached-successor iterator that upstream no longer uses.

Upstream eviction iterator (7459c0218742, fs/inode.c:878):

     void evict_inodes(struct super_block *sb)
     {
         struct inode *inode;
         LIST_HEAD(dispose);

         spin_lock(&sb->s_inode_list_lock);
         list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
             if (icount_read_once(inode))

5.15.y eviction iterator (d7aa8488b4a2, fs/inode.c:694):

     void evict_inodes(struct super_block *sb)
     {
         struct inode *inode, *next;
         LIST_HEAD(dispose);

         spin_lock(&sb->s_inode_list_lock);
         list_for_each_entry_safe(inode, next, &sb->s_inodes,
             i_sb_list) {
             if (atomic_read(&inode->i_count))

The iterator caches next before dropping s_inode_list_lock to reschedule
and dispose a batch. A concurrent eviction can detach or free that
successor, causing a loop or stale access on resumption. Delayed
disposal protects only the current inode; upstream advances from its
updated link.

This is a similar report to that of 6.12.y report.

I think 5.15.y needs the declaration/iterator change from
3bc4e4410830d ("vfs: Remove unnecessary list_for_each_entry_safe() from 
evict_inodes()"), retaining delayed disposal to protect the current 
inode, thoughts?

thanks,
Harshit>   	spin_unlock(&sb->s_inode_list_lock);
>   

