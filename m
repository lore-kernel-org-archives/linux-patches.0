Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315E63C942B;
	Fri,  2 Oct 2026 20:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790974782; cv=fail; b=bS+4VdfKzD2SF+XBhlj+bfcrW/tacNXG+YwN7LL2fi0Wjx+0CLzKDr3zemM9aFvdFmsawTm5pXd2tV31qRbrDw1xFtkZZoBSuE7fE3YsBxLn2MbK4060eV9baXlVSytjQrrbEG7yFuuW421jkXuceqMzZg2YmJMxMWetdEGATfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790974782; c=relaxed/simple;
	bh=X57QygFzBzFwv0o3/KdJtt2qtbx4/f9YKbw2irvHTsQ=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KsyKhY1JydlvH+O5GkuIJbOxsS6JxshJxw5otkEzDHh1RJr+SgsiNLeL8r5L5KX5lR85QJhz4bi+ICgvOhBAMKaVpXuhZD65tdI3ZAzZnScrc64KRJhh1AkwjpuSDGDIOd1rR72usnW5vwlBeSMc1Y6vgs4SQnXvhkgO1fxqQbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OGxXvqjl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dLUZ5ybt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OGxXvqjl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dLUZ5ybt"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692Ec9Qx730693;
	Fri, 2 Oct 2026 20:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=92lfVyWpImWjdwesege+0jeM5jmX8N4gZZxkdtiHuYI=; b=
	OGxXvqjlQZ1r0JYLTxDBaJ/VIXAw/lfyBDdOtBUUjXBRSxdP6fdjzcH3oonk0y3b
	yirul3hnOeu7NJT+WOVEcFbLtMbMkulTZsNGx35++4L4l25oit3jmDAA5Lds0A16
	LIOykAN9WlvCKymV36pMSPfcfBjL9BuIeOc46ro3tmP5HopyCCSTiajoIcNvRqgw
	HxE6CCw7+BP+0zY3r6RjBS+OPVGw6J5VK75mkuJBq83eBKJ/aTvIO0X+LE8E22F1
	CvZZwUhL7f9nPlHl38+raAPGftXcar01MigtWQ7f+h2yCQsxKt/roh9SaMLzOcQS
	dT4dv3zjuMevmVu4+gxzVA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx63c4r21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 20:59:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692KoOVO001872;
	Fri, 2 Oct 2026 20:59:31 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012051.outbound.protection.outlook.com [40.107.209.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gtvsnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 20:59:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W8U6xP0ChGE8tvgof6Tq15sX+NTETrX5zKvL61htuotq1WkwP2wywgOO/dp45hcKqqdBMhEGbX9+ZxhmuX5lu+OOo1ZLjHWU5nYJLbnmS2YsrkbjFFefv7WW3Uqp9GMUefmIo+lHVobF4x1clB9Se49vZyXVRheoLxhkMd07of7dDYS8dCHlRxD2bgwOXZnzHVUVocjGEXo26FuZXTyg6w8aW9dTsJd4XHPWqrXqPeSjIL/asjl57QadM7S9NdB4v8Be86OkjCHgZDWs8BavzMLWB1PLJ3dMOHlZCiHSu1RaZGsiUAj1K+PpxbK6WR6H7ldWWj3W8z3BLlllVb/NrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92lfVyWpImWjdwesege+0jeM5jmX8N4gZZxkdtiHuYI=;
 b=BzDT8GO1BoDpBVz0AcuzMbaDjIbqiMf3JGeunOMc6Nbv24HoIJSbMGzVXPVl0rrN7wGTPvCvARehL0zNMklbcv51RuaOA/Susrb+QgJ5jRC8qeZ39YTqW0iZy7wp3kSLZ+4i43BnMl2RHeguH1Q5ijoRpxSLVJx3uQeFQ9o/2rehgcNAMcTniNq583KqUmbfSV/D0f1aABZgtsPaUFs1NCkR2tlREJeMvRJJoYyM3vj6CR2RsJcMrUC7pHtcOwYqwMKeTAH5oimXyAFh70FIId1qOnoQC+z/lEdRsjQq88bYhkdINQHatkh6pGoa77ozipK9AipsC37kWb5YtW6Nzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92lfVyWpImWjdwesege+0jeM5jmX8N4gZZxkdtiHuYI=;
 b=dLUZ5ybtUGviKH4effcRJJaQ5WDsN9z18RSJ49PJvsipngfZr2xvmW3iHayHndSDwLt44DqdLTIgUpK6KdZE5u3/HzFSmExfuqalCrXYFMfFM8J1zxaeFIYM0vCyU8EymTcVT4GDA0K2gBtRfyKH/aXO16sfE/1YvtRHYEdb+ck=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Fri, 2 Oct 2026
 20:59:28 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 20:59:28 +0000
Message-ID: <a0e22b8a-ddc8-41de-82f0-503edc57a1b9@oracle.com>
Date: Sat, 3 Oct 2026 02:29:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 400/877] bpf: Reject dev-bound-only programs on other
 devices
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, co+ac0a8c41de69121d@bugs.sh,
        Weiming Shi <bestswngs@gmail.com>, Alexei Starovoitov <ast@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152423.316713397@linuxfoundation.org>
 <b3ccd2a3-a51d-41d9-9374-68a392d23ccb@oracle.com>
Content-Language: en-US
In-Reply-To: <b3ccd2a3-a51d-41d9-9374-68a392d23ccb@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0671.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: a8687a9b-aeaa-48c7-1d57-08df20c80c1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|56012099006|5023799004|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	T53oBnVdgIh3DPBhhWObR++DpvYTfo+/clSsQ8oJ2TPdVM+OY8mixgXRjyAIP869LQT5irBdgKRI8AMz4JKJXtyuX6U/9/+87iOdwQPkAu2KKlovATDanmO20MWApHO8LaFvZtn5Vs7AwjDkhnXoVBHKCa29DaU0b5QboKMv4j3T7KEBnm/BJp3ElEN5lnlPgz+gmYdtXPnNbtnhmzDiFxmiPbceOQ9uzYOzveWrlxcXVLaYsNX/Z4+p6ovw+LER85PcZ7BuMfDGdGQsDX2Tw+kbLIuF5jsdr9W4NPTgpbOR2PCWRp8pmn3aZwUqfoXIIULjCom5IDM/YEVy8Cg7bjlXufckVwrhlJ//qTxYQrpj3wgnJJAupoX901oDjszlLMVtpsTijHvOf+XR23ceaS992a5A1l0R8vSUhM7l2giKwEelYtgP+VEfrPNgTM08Doh9qyxaQLcEugdn/JFtyFhXZ6FDsIm/Zk9Xci1IP3NbhwwyapHHnApaUh5RzImZVU+J1YMsWBgAPcNyJombvc1C+Cqa7b8T5CFrYbKD8UuqULaECA3ChKfPZZA6YFhTnJHVcK2bT+Xq5J3f4HETjT5+KV8LiTua4o5GfU4VPAHABqqNZSl/cFRS0EmjR0xYvWq/c6WAMsMDk6oJGMGAuhvNsFDGMJ2skkV4Nk8AsLI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(56012099006)(5023799004)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1hoVWpTZk9IaG9zNGVaTlkrUVUxV3hvUHN6MFdmZWVWMlRxWUl3eUh3R0FT?=
 =?utf-8?B?YXZqMGdlTFdjQmFteUNUZElCRnkwQkhLVnlVdERPaWZOK0ZOVTNnUnFYYm0y?=
 =?utf-8?B?bm4xUUk4YjRjNU1YRkxXTkREbEtvWnV5b0F1YmREdEJIVU42RWVaRDlUM0dl?=
 =?utf-8?B?ZzJSN0h0WWNrOUxPaDZJUWFZMzhOcklZVHprMm9IVUxoTXZxWjc1Ky8zTGV5?=
 =?utf-8?B?cVBibDU5K1Uwdk5HRTJtWkw5dkR6cFJsaWNBQWd0Q0lEcmFLVUJDd1BqcVF5?=
 =?utf-8?B?TG5XNVNOaFJPWHdicXQxQW9wbklpTFdRVDdCZ2o3Tzh1c3d0SWpwbGtOdlhz?=
 =?utf-8?B?SVlvRERONzVaMCtxNHRpWXRjT3g1WXdDMGNoVktzUWg4cE5tOTFVaUJadkxE?=
 =?utf-8?B?b2NuVmd5WEdnOU5nU3ZqY1B2dEhiNjEzNXJCanZqUEpaK05oUVhPZ095Y0hH?=
 =?utf-8?B?VkJsR3FTb3AwQ0xSbWg0VTFzNkNNcnpFbThVOG85WGJiZ3Vob1RIaExYSDA2?=
 =?utf-8?B?N0JBSUY3UG5vb29zM2hGSTE2c0JXdlJPTmpPWDAyanprWFkzKzhQN1diMVRC?=
 =?utf-8?B?MWZtdnRjZHhBNGs5cHpUb3hGNkFPWVBEM0VPck5vNG9ocEdPU20va3AydW9I?=
 =?utf-8?B?WDRUOWVFZjhNU0Z3dEpSd1ZPZFdTL0tFVFE3Yk8yQ205Qm9UWG1rR3V6dWFJ?=
 =?utf-8?B?ZGNZMExCV0pVTjgwL05xeFp0b2I1ZFZEaVV3WHM0aE5Ha3RpMmF6ZjRlTHM4?=
 =?utf-8?B?Z3FuZjJ1NGxob2MrM1hpb09ORlI0YUpoam10VjNBd05BdHdGSzZqN1JyZzlr?=
 =?utf-8?B?bzFRSHp2WHUySFNlMCszcG9ZcFpQMzltTnozTEdnRG41cFdPL1k3cm5uSFAr?=
 =?utf-8?B?Y3JuYnRodVQ2SU15YTNLNkhveVFHRG1LZDk5Q2hGTkl5K0FKb1ZPL0JOUjFS?=
 =?utf-8?B?V3hmZHdSeEVYdWJHVjdQY0wvdGxlWXBBcUFJMDliZG5nTXFjR0tpU3FFNUF1?=
 =?utf-8?B?NFpvMXRQUTN2VWNtSDJpc3MrbkJCY1Z6cncyVy84Z1QzYlZxZnZ4U3g2YU4r?=
 =?utf-8?B?R1NjOTYyMmZGcEFacU5EV0JGMHVFLzBtdkMxQjBvNFVseGdlRHlCU0U3eWxT?=
 =?utf-8?B?VjZjdklnRzhWdDhyejBwSFpBWkhOTXZzMFZnMCtNTUxCeFRlYU5Xb0ZRT3N1?=
 =?utf-8?B?NWhyak93bUZoY3NiQnNKWlRLS1ZDT2Q3UVFTd2RQSlhPR2w1WHRaMzdLL2Qx?=
 =?utf-8?B?eU5ocnZoWk5PeWJKdDFuNlhhNEpxdEJMS0F3cVdkU1hybExLYnpBbXliVWJN?=
 =?utf-8?B?UzVpNzB5czF0RHI4ZW1LcndBaDdHTDRCSkh1OWVVNDhzMGtiRzFpRXNaY3NN?=
 =?utf-8?B?R1Z2c2luRkY2VDJoSE43bHQxSm5MOGRZeGJIYkg0aGpyVnhOQTZnejdmTzc1?=
 =?utf-8?B?dnJMVXRmS3RESlgzMUNNNlBUa09lalpFemMxbWVDeGFHeTNOd3NBaHJ0ZlBB?=
 =?utf-8?B?dlFYTUdlQXlQWUMzOEd2NjI3TTA3V2pIdGh2Rm1VYmx2OXNwbXRJODNNdkVu?=
 =?utf-8?B?c0xCMGozcUE4TnRTQldCeHAvRUZldFBjM0ZGMEo4dXZuRE1yU0RHZHB1MWlS?=
 =?utf-8?B?V3FvWjZrRFBCY0lvSHVGMGZmMDM3RzNzUUp5ekREM1hXL3dxblF1SW9GZ3Bn?=
 =?utf-8?B?SG92UGpvdjBoSzdZVFFxbXZaUGwyL25wVHY4cDFLV0YvaDI5ZHBpRFVwM2hu?=
 =?utf-8?B?aHdRbzdPOUthejBvN2tWbGNhdmV0aDdkSkt2cWdzZ04vSldCRXJBUXVlVmFj?=
 =?utf-8?B?czFaM3FoNjJyYWY2RHkzTEthYlBHemxXNDU2L0tKeUlWUDBpdndVNXY4Sk1U?=
 =?utf-8?B?K3lOQXVoSk11bFAyWXVtTGNjWkZiMHN2VmhjNHRBY1REcTRqUWcwUWtQQndr?=
 =?utf-8?B?R1VYbDd3Mjd2aXVyYVlTTHJ5VGNzWEdEeW9odEJzdDF4NDZ2U0RTeDM1TUhI?=
 =?utf-8?B?WTMyeXdFUFN3QkltQ2pVemdySUp0RGMzSFlNL2g2MWgzVmlJSzBnN2txcnhT?=
 =?utf-8?B?SldCOWtEMHQ5QWh6aEVmeW9JRkxlRUtjMGNJUGRhYm5BNEFNd0lTU2FHUFg2?=
 =?utf-8?B?M2EyQ0FBM0lqL2hDSUlkdWg0WDFkb0xWWW9QdGlBWnE4UDhSM0d0Rkh1M2t5?=
 =?utf-8?B?TjZLZlFrOEFtS2dqQzI0aDRLeFdpZEtlUk1HcGUrV3hHVWNGZFpDZTJrVkI4?=
 =?utf-8?B?RjYrRHA3SmJ4V2FpbzNqUjBmSmJCVHJnYXN6WXM0VEx6ZElxQ3NURU1VM1ZU?=
 =?utf-8?B?MFJuMnZWSEtudVgyZmg4ZHEzSGtvK0g5Z2hHdEdsWkVsTlIvUHJzK3JMV3RS?=
 =?utf-8?Q?qmvbtBQ0/pBqdwwKhG9xbIuGQSQr3kAyLCDe7?=
X-Exchange-RoutingPolicyChecked:
	CIJwDops8HR7li9SpNI6zXAI93CbpWRDGa11b9hwVEmG4NMkxtEA2tckJKSC7Ak6j54/sTxS+E/iunyv8XqzA0Y6m/JO2bWowI53sdjBujDf9OzWGueUxxLfWAe+4st0F3cMbb114GADK1E5fjTL9jp/ElhshtjuRIEKQKMKoYSmn5xVoR/7VZdDjPwQSaoJ2wFIzv7Khh7/pSeFHKVsqwBO/uE4AbSNwS5sMUgSufnmvxpiKDjp7XnBypVkQSl0/+eACuDxKKwZ+sshKgmLAYeUCTO4pQwmbUU6GPLSzwZTaCnxnJww9dJ8NyzoZsUEZXpFqt9271N1mBT13jHXig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m7FwICqV01qmUyTWJF1/7CAPd7hxo3iOHZEwpYRM7K6vR+X7Mou+BCSZc/Zs1woFnJ/ZC1fkWGIPiUJVVaGPWqIDKaFASutDGedcsaDIPRrcx3mF7sm9H8pYxkDXHyu8Y4Xou3VOOOnRXZHhJGk7Y6Zjb4rdSyMYQI1Sd/qAzcFwJ0vUtmrTCn9YLGRI1NDhCleesWSzVq/prFghByIbh/tQDsPE3h6k/xBxCG9pkVkuB5jW2HjEyWMVcvkAzDlaBLknSKvUix0ihHIFW8KGWncgfZCQYMdVAZb9JW3e+fdZIdpxOhc8dXpqivQ/7YwyJczfZMKC85DwyYjlBepU7NdWKw8aiEU/th5YKzIc7NlUHWZfjE3LAwAWX4xTJRMUuANLhI2SAkDUQRy1w/23iM6RGikwNsp3FBsI1f6uDaI/Qy12KW8IMWsuCGJR6r+A7PFgk2FYLPKGOxzQq/S17AQMNwZ9dx2YB7aXB/5aKVOjf1Py6VCLLVJofPDHfbiQfNZmRV3YWAyhyJPmWT2y3hKHOH4Uwg0WrHY8rENXdt/lIV5KXMKd89hftRz02zbI21w0IRG3/lDUQl14LRyXJAbH7mHK9lfBR0oALYu7r0Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8687a9b-aeaa-48c7-1d57-08df20c80c1f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 20:59:28.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5T4G6s7hM8ydGGno3HhO1PNjZKE4KrMoCGDlVfY2hBfqXIWRAqEID0Uzo00arhyWCjT2LL+SoyGjuwTzaHwGgUotnvbGnjaAihdhlvAsnOnBhs1F0d2bomuPnnn8+BH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610020083
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4MyBTYWx0ZWRfX7C88Fb50aCCm
 SUaEn1SNnZkvSt77bHFthYefb2RrUGKIxlHl5i8pL3lmth9CRQGxhIkX9B5uWB2pJVsh5smSIoO
 6ZMyGd1UwePhM1Flu0HYs7yP2M74NcAeLxJHQuHWeXAZUIRphFAD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4MyBTYWx0ZWRfX/gffNFH0LE9M
 4lp0k+9QEmB2mci2S/cLu/WAtE0Qa9JtkAEQHPiHSF275BIi0lK/DvXHrObK8hqa9NaTZDGMIat
 NUB2bJntkc0+vHOd7uKtfuAPg5KIUHqETga2Dssqzrf8BuRjHSCI5vN64eUpS5TkeFh5iCMYH68
 mVG4c4L1d7uSkhDs9p10wNJyum6APN4kQ8lG3DFpu+jCuZfF1mreUl9WgWVWD//zhkoTNrJIJNB
 85+D6T039A9vXE7Ax33taJva4OQcWk4rgxlnR8V7k4iCIBCQNaTD93Q7T/LNiPwQbUctAH50OCU
 XXbS5l01AFjBhDlhXEDfOcrrtYwKwJAmnAFin5NeRk9i5ZfADlM9LobEsvryoh0m7B3VvFH3hBU
 OycpK106mwdLtai7ZzcJGm8Ls+QXNtdig9SZC1BDhSWXdQEEb1mzqb7bfog7LFZ8AHFFuCgTHqK
 Bxu2YOKZ/NmSpoMVOEggKF1uzWT/Gic1VnEAfaoU=
X-Proofpoint-ORIG-GUID: JcPriPWxTi91g14KO5tomEc_mt38g-BK
X-Proofpoint-GUID: JcPriPWxTi91g14KO5tomEc_mt38g-BK
X-Authority-Analysis: v=2.4 cv=PPGaavqC c=1 sm=1 tr=0 ts=6ac01b33 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=GnSy7jjC-6XDeWeEgQUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537

Hi Greg/Sasha,

On 02/10/26 1:39 am, Harshit Mogalapalli wrote:
> 
> 
...
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   kernel/bpf/offload.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
>> index 56115739fcfdd..1b6f9e7175666 100644
>> --- a/kernel/bpf/offload.c
>> +++ b/kernel/bpf/offload.c
>> @@ -703,6 +703,8 @@ static bool __bpf_offload_dev_match(struct 
>> bpf_prog *prog,
>>           return false;
>>       if (offload->netdev == netdev)
>>           return true;
>> +    if (!bpf_prog_is_offloaded(prog->aux))
>> +        return false;
> 
> 
> Hi Greg/Sasha,
> 
> An AI assisted backport review flagged this, and I checked the upstream
> code against the 6.12.y tip f4ffa8dc360b.
> 
> Upstream 6db1ce73e985 checks device binding in dev_xdp_install():
> 
>          if (bpf_prog_is_dev_bound(prog->aux) &&
>              !bpf_offload_dev_match(prog, dev)) {
>              NL_SET_ERR_MSG(extack, "Program bound to different device");
>              return -EINVAL;
>          }
> 
> 6.12.y bpf_xdp_link_update() goes directly to that installer:
> 
>      mode = dev_xdp_mode(xdp_link->dev, xdp_link->flags);
>      bpf_op = dev_xdp_bpf_op(xdp_link->dev, mode);
>      err = dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
>                            xdp_link->flags, new_prog);
>      if (err)
>          goto out_unlock;
> 
> Link update calls dev_xdp_install() directly, bypassing 6.12's binding
> check in dev_xdp_attach(). Type checks and tun's callback cannot prevent
> wrong-device installation, leaving metadata kfuncs with an incompatible
> context. The matcher fix is correct; this bypass predates it. No
> destination kernel crash was reproduced.
> 
> I think 6.12.y needs ad27ed7d2309419a129078d781504f486b1b469a ("bpf,
> xdp: move offload check into dev_xdp_install()"), adapted to the 6.12
> installer, alongside this fix, thoughts?
> 

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.12 
I still see this.

I think we need to drop this until we take the prereq as well Greg.

Sorry for the ping.

thanks,
Harshit



> thanks,
> Harshit>
>>       ondev1 = bpf_offload_find_netdev(offload->netdev);
>>       ondev2 = bpf_offload_find_netdev(netdev);
> 

