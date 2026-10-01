Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD90B3C871B
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 20:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790886656; cv=fail; b=InUD6PyeD/f0TiP9nh8x7BNx1/v9DXODzB1D4Ac0h06acny81Ug/SjkFTq4K/FkccY+za0c5HluqiuDxrNTy61vUyHbuUQ+O5xJcJy20ZbXRfWq45A34P0Im03eg75iZl5U5amRN/nVOIYgf07MMiNjPQP2/COQ3uhlwXiu5oGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790886656; c=relaxed/simple;
	bh=WxgIonJIFG1nKYi7p/nPPUUqb5UCeNgjLGcgQrqWh5s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VYkSSFwJmAmXIf2aDSCJ9mToZWpadARSbtE0kxqjiNcaONiJihqYgk5wqS4xcJCj+zhZjvA5QunbVmiGZSyhPCHr6t2mbMwoqfAAoNViwDLsHDIReJRwcA1elBQStXNw7BWIZoBXiFBS9YVWgwgDf+g076PGElrRlm6CTD95wU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iopx3msV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DZ3ZoJZM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iopx3msV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DZ3ZoJZM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691KGboY1693161;
	Thu, 1 Oct 2026 20:30:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yY8l/p1Gha47koUnyRobc9/zsIdHJo66dTdmWNZ4HDg=; b=
	iopx3msVAwBbEHEg9V7vQvs3mN2q2kTDsPVpaX95ZY10CSX4cymMyzyQB9FTLVLe
	ggjYAHk1FHie8GdxM+QOpWvwN040j8R5KcsVtkiUPfOkCkbP2sxtZxbhZzrj8KjJ
	/XOpzGMqeX0pi27PTozyLPmyZ78IOr9ychdnP5p9+pO6caAGlu+QwTuiKiOcaghP
	7iv/Xr3ZxShMdQCE0qd+FIJSqBlY12YS3yqKU+Cq0+/5aezeyCYzZ05Z6ANZ9JcB
	rBvZmbOs1lMklnifuuezTSzoMJnGjUETmH6g7gFZ22sOP0cihdHMGS5i+xRWGdws
	eoJiWf+o/iRTkmrg7TjHYw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4y9jc3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 20:30:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691KKPYb009884;
	Thu, 1 Oct 2026 20:30:50 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012004.outbound.protection.outlook.com [40.107.209.4])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gt8mg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 20:30:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nYiaAALJDXSSkPvWkvHKlYGXVIcuZeiWRrUSAwDEdH9SuDFc+oeorG+u2KjSM6IR6O1+KgoNkD1f4A8xrRcYMQg+vArcTw6HMOLSi/eLbDCJYuOlS2eiY90Y9IpCiwMorZHDG3YFxqjtOL1dIKqgVZVv2dQKuF4qarzkympJX4/+5ehvDXWXkcqWHKuX9X3QE5AEwn87GyWmnSan/xKB6ZjK3daeDgdIL7Yh9V43IBJy2P6dCP1PrwLTwGvQY7oic4I9DjnPTAFt1xEA8C2ma/dBcW2VKb/j/5ax6GOw028C+vNHuKyBMiliZ9mWSqmEpiWEDt+3Sl51JLhLTdfA3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yY8l/p1Gha47koUnyRobc9/zsIdHJo66dTdmWNZ4HDg=;
 b=S2R6efwG5ls5/DbOCAME83wZi34NaNkY+ufZNy+EnvCR6er56gilSJ+hc0MWKEzDd0Y+Lk9OewNulFXnGGqbL9VgRuFZpMYuNjiLrvXGGFICMIp4k5xzLAEOUDl2jlTUviexAptzgR3C/3E7gdNgTY2Dyk46PIV/0219OmhhFe8QPiw5DaEROb21qBT+oRCuh2WQobPkgsGt1jfMuF6qIc/2qZgll94jpOxRsUAqpv9rYIM2Pzmp331ineeSbT21INLdkCj8ZlxUEE7pOHBwuYLECcY3RRglgKHt9Hc5oCxFYcWKntcbqwZLLVKWzJLtmc5BlHTffqI9oNCztz5UKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yY8l/p1Gha47koUnyRobc9/zsIdHJo66dTdmWNZ4HDg=;
 b=DZ3ZoJZMNFHfSwdqwEPvNqMS2wulTBIOZBJEN7Cs2feheK1RFe37Dbyk59axu0Xo4uIiHp/sHlx5g9/g00xb3h5nHDbK+sbv3LjCrRIMycQbpPwe6fD16ZU23TO1IcQITAG5UDdp14z9B52zG8pI/hR9bMk7EW1pwk4nNejstJ0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH3PR10MB7704.namprd10.prod.outlook.com (2603:10b6:610:1a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Thu, 1 Oct
 2026 20:30:47 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 20:30:47 +0000
Message-ID: <d32b4104-efef-4735-b9e5-2b07b57a2f40@oracle.com>
Date: Fri, 2 Oct 2026 02:00:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 773/877] mptcp: prevent race between disconnect() and
 rtx
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152431.395456304@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152431.395456304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0028.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:273::9) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH3PR10MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e92f44-4102-4c30-ca88-08df1ffadfe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|5023799004|4143699003|6133799003|3023799007|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AaQeb3GMKYAQRBAjrdUUuzcH0FpuAdVUqRjC+tcB6IlNXnpOJzmQPw/ZLpc4gmmJY5x8GAZ98FyshRXj1k4a9B3RV2JOnS4PQKsMSDfqjEJJmNnuWD+R8ws1G+zJkcQXDUmC/IgaoroVEgYlYy7NbaX5xqh+k18zFlo04YnWh+Z8HKhg44npr3SjKyruvbW4PgumimZf98T2lZkyqAb+Ui/y4pm9mKdpPlYA2QpeQHLbGtseY7CXNsLiGMlhGlU3ftQ5vsB9qMCMjKcbPHGNNYuq52KhAXu7YdskZD99vUzI1rX3K5xDkJhU9T6vmaQSgQuE+W31Lrk4h/UbPD2HIu5+aSjtfh2kxmcxSid9ZrXdrL9uRvyuWtt5wmmqci5HohLYft3QCyhbxOmES7ZYbPS2lNbl01+p+2m6v6zV6vk7PUeHDw6F4s6TSILZ75M1lvFV8OXzn41dIwSIPY/NqtEGV0LhvmhLMluVNYacX1ty3BFr6JxaP+W7Ig5YD6hkRtHkegOf3lCmY3MEi4kh2/4V8bCt5IVHQX/6K7JPjF4OBkaHF8DLD0+1vYENj4qoCwFNECVwH5//LpvBLmUR/RObf0XdzzoycOPOlIB1oH8XWYJzYJbmPxjc6OjuQF78
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(5023799004)(4143699003)(6133799003)(3023799007)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2lHcklTcHZ5OWFTRHp4ZTJSSUJzQ25hMXc0d2RxcWppakUzS00wRUNKb1B3?=
 =?utf-8?B?bnJ2clBDWU5rRkZIS3R4VWxocVRENDlDUDg1MzRxdDllSytaSUhuNFBtOEww?=
 =?utf-8?B?dE1SV2p3NFFrZHpocE00OEEzWmVWRE01M1dLRnNOaWdsckpTczcxcUp6b2FE?=
 =?utf-8?B?UUp5YVpsM3Myd3p5M2Z5MGExbGM1c1FwWkduQkx3MjBYcHg3ZWt3cjF4c0Vi?=
 =?utf-8?B?MHQvKy9CbzhFRGlsb21iaC9Wcnh5enZ1RW9UMmhLV3hMenpOcTJrSjBwdDFD?=
 =?utf-8?B?R3VLUGhVMDZEWk9OTkxkY2l4RlZyQnd4cnFoRXZlWDVaT0UwcjJZU1dsZk1w?=
 =?utf-8?B?WGFLa21OVWRSWDdYdEJrTEhFK1BzbGNRdXlONTlYN0w1YmJaRmFFTnAxQm9L?=
 =?utf-8?B?MG1TVEF5RUQ3T1hOU0l1cjBDRHhtUHlBdXhtS05PbHd2SHRqa3NReFJLbHpX?=
 =?utf-8?B?NkgxVFhHT1g5YkZtLzhFSFZlbmNZa0E5ckcvRUU4Mmo2V1docEpSekw1VXpz?=
 =?utf-8?B?cklHYlVlYzVFVW0yOGtldW1TT2p2cm9RZjVNazhNTER5Z0l3RUJQd1FEWHpk?=
 =?utf-8?B?b2tZclZ5cjVJdElXdnpCTVNuM3RGaWhXWlZHVlBiWXFUeElheThOUy9jUUF1?=
 =?utf-8?B?VUx2ZDZib1pVOHRqR010UW1jS1NZcDBrWVlOUVRVdGVxMEFmb2xSVHYrUE4x?=
 =?utf-8?B?aDFadUJZYm5QTjVXZmNIT2Y0UUNRMHJkbTdGS0k5Q0t3RFovU0ZMc1cxZmJl?=
 =?utf-8?B?YUxiMGZXb1ZweHZXVXNQeW9Xemk3dEkwdHlsdEpCbUpLR1l0VzhkZ0dleStH?=
 =?utf-8?B?eXpnZFlnU00xREhTOGhrMllrTGNPT3l0Um1WQjB1c1c0V05LanRqS1loRlV2?=
 =?utf-8?B?UEZ4elZsZ3pyYUVyeXJ3bmw4eWVaY3EyOFRjRTlCNVdmeVZYd0luRXhSZ1Fw?=
 =?utf-8?B?ZGt6TkNTN2FIOEkzbGNLVGpkYXE4cmtjanJodGwxWXZkRFdHMDZpdklWM2lr?=
 =?utf-8?B?T0FJcGptZlpQRGluSSsvT09IODBqR2VYbTNTSEZad1RkU1gzdVdTTUc0Y1ND?=
 =?utf-8?B?bzdSQUlacUtyaVc1QkNhZlFQMW0vemlwcGtrUEhacXpUQ1QxUG92dUppYU1x?=
 =?utf-8?B?endHeG5aYitvZGRRbC9QMmdvRmgrZWxKZ3BGcG5CRGxpbG1oQXdKNnZ4bXg2?=
 =?utf-8?B?TUNvVEkvbGVpcXlaNGcxcFhxYjVMVzM1KzliU0lmeEtwRWFVVGxWS2hxWGFt?=
 =?utf-8?B?dEpWTU1ycXI3czlKcVB1MFBjZ3FGTEY4NmtmUEFjYnBHVW95b2tWTlkrNUVV?=
 =?utf-8?B?Zk44bVlucTlGM25pY2syU1BrU2hHTCthelJMbFY3dUV1RkN5ZUJMN1pkck1S?=
 =?utf-8?B?RDBuNnJRR3RNSkFUdkcyTWdOcGhJaDYxay85ZjVBbGlLNU81L1NrTHgxT0JS?=
 =?utf-8?B?U1lxS0ZpQWZXRWxUSFVXSmd4QlhnbVk2UFBMU2V6SU5xSEJZdkxvSFdsNERt?=
 =?utf-8?B?c3I0R3BSbHUreVdqNkdFazJJMi9aZGhhQnM4dEZJNFRyNjRSZjYxaU1Hc3Ez?=
 =?utf-8?B?ZGNsQmxDbE5YU2tSYm95K0VubEIyamFGWlhSSUJnQ3Z3bW40WkZkQUNGZklm?=
 =?utf-8?B?U1cwaGt5T1c2RjF0Mk5TVmN1UVdGY3Z0OUpwS21JKzVpYnZQSy9NZ2tHZlI4?=
 =?utf-8?B?UnE2N0liSXZtV3hhUnU4ZFpKWmdGZXdIUEhZUGhCSXUvSkVHemd2dnVIMEJx?=
 =?utf-8?B?VWpuOGNtcW80S2hzRzlocG9NcGtHZVo2bDZmOGQ1MzNvYzZoV3ppeExnYmhF?=
 =?utf-8?B?QkJLeHVWN2xqMDhFYjlPUFRFeDN6eUFOcTVtZFVrdWhZMEQxTWcwOEN4ZG5V?=
 =?utf-8?B?azR5bm9OVG1pU09xL2lXOC96bEtoT2pnNzJTSnZBV21vTTdLRDB6QlpuSDVB?=
 =?utf-8?B?ZmVpb1ROc1lPMi9qNFo2VGpUdTFIYVJQRFNqRjBRdTErMXlHYnFkOEN6Y2Q4?=
 =?utf-8?B?bXB1azMzOGo4WW4vZ2xaZVJFSTF3TG5IOTVJWXprVzZ1WTA2WWFEb1NGQWVB?=
 =?utf-8?B?eUlob3pmODlsNkVacVVwUEN1T3huaFVFaHpQa3hjdlo2MVNIc1NIZCttcm9w?=
 =?utf-8?B?TUVaeUluNG9PZkdhQkU2ZklkSmt6RTh3TEQzbXkzY1VtUnlLNnEwQWgvM2Nv?=
 =?utf-8?B?R01EWkF6WElUWCt4dGcxSzJvTUxza0dTY0pKay9SU2Mwam9jL2Zab1FsNEVW?=
 =?utf-8?B?eXV6a2d1UDVOZnRTQkRpeWsxZEpzTitWSGNLMEZkUWhyTjFOQkpjMnpYMGNI?=
 =?utf-8?B?ZVRFdWR0MEtxZHdRNnljNTlQUGR0UndhRnVlTVVCSDNTVjNVT3UwSkZpa2N4?=
 =?utf-8?Q?pt9WtaXwb2jfPoKA/toNNZWE9KCs1vZEqBpth?=
X-Exchange-RoutingPolicyChecked:
	AoT86DB3Q8oZmGkzSplS7b3a8wbuLzEnmH4T9SOPcPleFtWQW27EZ/U3xD2vTmuaBnCI5tpsvQoYH5ILdZ51L56+wkLUdEyzlsG2hf6telqHoj3Tka4aXTAxpAe4iRTjUPA7fVGCoziSyms6o/d+x03TqG+qKZ8oCwAixKC6c1I8F3OOZ/t3k8ra8jph18ugljeXtGSi1dukewNZb7wvVYwHo+G6w3VEZ2THepACweEfpB5zamkShY7XxGCp1mSd+N/DyNCvmj5x5F2NsQB6kvhOGIHUdatStVwq5nqSbSBPf0HgeLsgJ+ZYfxi4kNr+c6pKeX6gBF12OK6ckHBvWg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gz/HZbYLe7csGMrzKKtsMo2nFedT7F9cfZ+yJwa5ZRRmMzNuVs0vc3uscJqG1rvFcijtXphU2iJC2w0bIK5yuipEnyziEFdkKBB2tlPhH77l60Uijg15xoFgQOnGcj1ElUbfd7Ei+9OfPKoj8J0CKhUAhhPAXQjH4rOPqWrmuLXM0GuS3xweDOOFuplMpeHqjCTSZgfBheeE2r32LoiaxitEslFfcphZP3gDLup6zALL6OzH+BVFkhdinKKpyAZX0Kfw0zbD1TwsR8xrgN/m8FUEj0UIAz9vs86gM/7WXrAll4TnJFPzQlgbzwPpw+rw+gXadpbAWCJOL6SOoybGCmaqkEZLjiBplmMkpMdhF/XDDTOdkna3kV8kFhzVnT+5fZ3UhKv4Ts1BusvfR1ihTZzPFDZLDzakv3/AdSxt06pfXleld56zyNrMJ1atONUDRAk7Nj85hRDtay5Qu6C4B9JozQWBc1i/AsgSHftNZg+xbpFErPHLzjNxsCLGUNg0nphKEzbVgJg+9ik9Miy6hDlTVx7ykneneHp1ft6VifK2lA8mp+kUCqtCfgL/doZeMipUBGWAgj5UEb7dgmXHfOcO/DoLGg6NBccoyX8Q1Ac=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e92f44-4102-4c30-ca88-08df1ffadfe4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 20:30:46.9763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0l/Wh+GAXHCZ1IOvkth3a3xt+WMovYYiS4pkpou+t7tT8vXo1Jp+ZLrU4fJti7qe8mBTIZ7+sA2xlInHlJFYHufVW68+7kIuzQqrmCPPRtw8JGEUYytvWIy4MpJZL5TG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7704
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA4MSBTYWx0ZWRfX0o6mRzk9jIyM
 A7/T66BvYTbopvwXqkJMS3fdrTb9u+5Xj2gl0Ck+Khe6YksqQzDglXwOVwAoAj9s9XNYKE61eLM
 N76LSaN4xmxGV8qlDLlMAhG3ISsU0lEMBaSHzMEGfxwGXF9joFZlvIm+/9vlyf6L144TQh7kjfi
 WVTzsXOwuzxQT/Zc88BcOIzCzns81pX6VT+qDy1M3cQ8JBxIzioeCl4ZkbWxhs6rOhtfUdT3ZZq
 cj3ZhhSm8RIsT6P4vO372hdrggbcl4NqJihjLszd1TJRa2Wqq/EOmuDfW0LT/aYv8/flWn79X5f
 FcZsLtE+ReFq+vp4JARSdrWRlmYdU9BjKjwLX6SQGHO2JiyS8laaFZ0RvNbxWH5AWngcaDekWWK
 oooaGIt+16iL8xA8bVJHdvFD0T6P46iXNbF+lHIi999Gyo/3YOxj+D2cjtg+r+DJe454fOe8dXj
 K69Yb2pxOHmJqEFxU7pS0efvDYAv8G16fsmQnb6I=
X-Proofpoint-GUID: AFlfdzee6_mcmU2tyvfEtLp2tJAb0CAI
X-Proofpoint-ORIG-GUID: AFlfdzee6_mcmU2tyvfEtLp2tJAb0CAI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA4MSBTYWx0ZWRfX6WLUpma25rsv
 lVu0S6zpIYTd60X0tPCRz1T6A3YZPap3HT3x3Z8D65s24D4B2SdfVcwBm64zfHrbE+Da+M19dDL
 l1EzbYZ+QXATfLpTIgrVjOOBxlWiUh+PzeY5wi/ZN5QesFtstETi
X-Authority-Analysis: v=2.4 cv=IuyL47/g c=1 sm=1 tr=0 ts=6abec2fb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=Hs2L3LXl4pqqBji6e3wA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107



On 30/09/26 8:58 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Paolo Abeni <pabeni@redhat.com>
> 
> [ Upstream commit 85c580b0d8590520ae00a15c29e9fb9c99427a3e ]
> 
> Sashiko noted that the two event can race, leading to inconsistent
> status. Prevent the race using the synchronous timer stop operation.
> 
> Cc: stable@vger.kernel.org
> Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-6-df1de70348b6@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/mptcp/protocol.c |   10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -3367,6 +3367,7 @@ static void mptcp_copy_inaddrs(struct so
>   
>   static int mptcp_disconnect(struct sock *sk, int flags)
>   {
> +	struct inet_connection_sock *icsk = inet_csk(sk);
>   	struct mptcp_sock *msk = mptcp_sk(sk);
>   
>   	/* We are on the fastopen error path. We can't call straight into the
> @@ -3379,8 +3380,13 @@ static int mptcp_disconnect(struct sock
>   	mptcp_check_listen_stop(sk);
>   	mptcp_set_state(sk, TCP_CLOSE);
>   
> -	mptcp_stop_rtx_timer(sk);
> -	mptcp_stop_tout_timer(sk);
> +	/* The later subflow close can not kick again the tout timer,
> +	 * as the msk is already in closed status.
> +	 */
> +	msk->timer_ival = icsk->icsk_rto_min;
^^^

Hi Greg/Sasha,

An AI-assisted review flagged the reset expression, and I checked the
MPTCP parent-socket initialization on 6.12.

Upstream, net/mptcp/protocol.c, __mptcp_init_sock():

     icsk->icsk_rto_min =
         usecs_to_jiffies(READ_ONCE(net->ipv4.sysctl_tcp_rto_min_us));

Then mptcp_disconnect() uses:

     msk->timer_ival = icsk->icsk_rto_min;

6.12's initializer instead has:

     msk->timer_ival = TCP_RTO_MIN;

6.12 never initializes the parent's icsk_rto_min or calls
tcp_init_sock(), so disconnect reads zero; the subflow's initialized
field does not help. Upstream's broader RTO feature,
ea4eb2adb0d3414abeddaba72dbf8876fa66528f ("mptcp: honour configured
min/max RTO in retransmit paths"), supplies the missing initialization.

Could we use msk->timer_ival = TCP_RTO_MIN on 6.12, matching its
initializer while retaining the synchronous stops?


should we drop this for now ?

thanks,
Harshit


> +	sk_stop_timer_sync(sk, &sk->mptcp_retransmit_timer);
> +	icsk->icsk_mtup.probe_timestamp = 0;
> +	sk_stop_timer_sync(sk, &icsk->mptcp_tout_timer);
>   
>   	if (msk->token)
>   		mptcp_event(MPTCP_EVENT_CLOSED, msk, NULL, GFP_KERNEL);
> 
> 
> 

