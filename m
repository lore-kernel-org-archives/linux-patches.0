Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E2175A8B
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 01:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776216907; cv=fail; b=j0UAjOm5bKBNhSWzuv6MQoE47uAT6CDM7a6s2p9qYwDB35peYPka52ggwmGY3blgreMfnrtqpURnoQmha0OFNlxwyu14UwiKCM8369YGJH8JgrL4Rv+/so+iqEjZtISnOF1AP1W0ESioplChtzvO5jFzRw3H20K+iWEXNQw/syU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776216907; c=relaxed/simple;
	bh=W70+FJ9zQ+U9lRR4ogNvG4ZWnQe0jgHajmHeVP189pk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CJ/jDldu6tg0XpBSTa86G//5nWbaDn41Q+gxHUCa98o83cRV5cHyurx7/Dt+ZmQl9wirmINgnjs5BBBJ5tpk0IjGRAiwXt3vl9eEAihlZdM5Oe0J7FPn/YR7PaUojn7gr7CqPoZVTeERk1k+R2TzoMQVNxNQp+6EPagxecAXo+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Onj1pXlg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iAaiw0zY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Onj1pXlg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iAaiw0zY"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EI2dPT625768;
	Wed, 15 Apr 2026 01:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0/QMYf6A8kzIg3hHwX7VcyU0xX520fhEtSLzcXtxVko=; b=
	Onj1pXlgJLyMrQ39foFimzDi9hFO1IZmzumunmyvl38klbwIkv7ns2qClkqdcZAL
	tjP27UNbmj8OLBvmtS/Wsw6UX33sGLgmgKhbM9gVulEkEWw9LN32T3WHcZRRMrzN
	UcOWy7Sjqa0VIub4camjF7JfQzbd0YdUmtX3kAnQmy5YznMsegbgdiipZwEzL2wa
	Hlw2dFYa/LbQJOfVRNxhlSbF2AtZOXZimisPsRlHVokvlpjL/WDVBH13jNE3CjSQ
	gEuuIjP+H2V9GcG/WGBJltaTzspdGB4+l4u7JoRpCI7Nm4O7BVv1a9ouMPNQFRtv
	FS7hT1JqSjYIuTWMHuOQpg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87h3v18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 01:34:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63F1TJGZ032436;
	Wed, 15 Apr 2026 01:34:51 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012070.outbound.protection.outlook.com [40.107.200.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dhyjyk6sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 01:34:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QGT1NXZ9vm5ymlkNboWMwNXcC/14E6S0Bp5RzwKBFtpg6MyUyIAgkmto0PbFLB47gLcRUT9oCV8ER6fe9QHtu9eF0nKFRmTHHZktk8GfRSupZAOBxJjv6q4kGLnLKWIQS5GYPraVrK4z79+fuEc8xrLdscS2ck7WQ4yOkL5c5hN7osF4NWSbEgsWG1DqhFAmpK+DtlEnZFYa9wTuNSqGc97HAcHyqDE2aVj+nT3wwIcbur5Z6fsleDBBJBj5GA4Pq90QF7hWLM86heqlK1rM3/CMEf4P+5u74SUa8fdlm9jRmB6Chx/vjIH6wpsO0eDwXeIvwscMcsVJjx1aiSjxHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/QMYf6A8kzIg3hHwX7VcyU0xX520fhEtSLzcXtxVko=;
 b=phxPULy+oa4sqDAuzvR4ZljHh3Ur77q81ZVydOPDos/dL/hmmeW76JztUREmsjAskRzNLYqmFwtBQu9qgIg+mSX8MSRY+Yj7CCELBVNZ4CccuyW0i46HikcQ+iPvzXn3sVPx/ni+aUkAVEnuWGxd/xGMPoLMSGl/z8ZqpLqQgnqKWAERiq0hpSKtmcso4FKKumdSnvSlxfCz+H2Biid2F5xgUXA/bE4VjmaE4sEwIKVsFbF2MAg5IwJKrYdO/deSUTU2NmW46RUSvZU7+X9K3QqWJ4ak3qRltowUeqfsvyrBQk/D1gg0lfYMKZ6IKM5ojLpWqflS1p67/F5YrGOiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/QMYf6A8kzIg3hHwX7VcyU0xX520fhEtSLzcXtxVko=;
 b=iAaiw0zYi63xghHo+2Gz0Xq0+F1vgvPCHFgjme/6MosaS/N/8tgp08wJ+uqC+yxL83uucBbYcx754716V9JsGnzMjiSSQJvuQ+Vr3QTTmoZbVyvxsx6nWWfWvehKdW874tz/QgiaNjjVNVaGTPJmcFZSSM9QO9V8JCso1hr1RRY=
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6) by DS7PR10MB5005.namprd10.prod.outlook.com
 (2603:10b6:5:3ac::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 01:34:43 +0000
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83]) by CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83%4]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 01:34:43 +0000
Message-ID: <78a87643-6175-439c-85fc-76c47d7fc6e4@oracle.com>
Date: Wed, 15 Apr 2026 07:04:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260413155728.181580293@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0029.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::19) To CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH5PR10MB997695:EE_|DS7PR10MB5005:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a0149c-cb9c-49e7-85b4-08de9a8f2b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xGVLP4J09g6InowJcZ0m16VJgwbTIqaSyCpZC9gcQzJh7PNnQU9aKEIiiX+6xuMQPbqB+DgW8wNQLrB3Cz7cgKhgXHyzRgg7DJpVwVz4rH4SaGkz7j1emV4BOG3D+3nz5pGHb6tCTbqlVsj04TODUcE5zaTuBRwJdBJb4LLYXlW2RWq6v0ldjRO3Mbl7vh9K6X3R+UGcUjutQAObMzYEsH+yTik4Eaz29ZqkMt88za5nrKJ3OLchvC07Oxi1ql30kyoPfnGaIfiEHPpFCmfq4kxW5p891wI1a2VEUEGRnKw73zJ8odOwquWxJPrAR7IjDowR+s2DZyYExB+7fBQkAcgd/vOxnjTVgBK5ELXMntrB2kGCHV6bjtu/QvRnPhBfA4zNtqlHJpLhFRK1qT3N57C/LJUt6mVPr8SbrxEtYahFvF+yx3tDhB9MFDl4TOOmTltnM8DmnNYRZ4rg3EN8KG2ECSrgWmoxNn2x2+PFxWy+RCzHmoDM9nali77KjNadQMwF01LeisQ/mMo/HrgcbMh0Q8w3Lh0F/CFzcZl8Jr/1rUVY15P149g2gg+Ae3yKx3f9b6f8zgXqMDwDltRZUREuVECb1CsueVEhkOkBTYbUS0sfnHj3NsfpIVghOICRG2/6ZrB0gXuO2u4HLT9pBDFKV92ZQdGr43U4ICPGdNxO2Qu26gaYF3hJkn9/aglgrxwGExz6oj37GvKB7Sjzigqlz4R6pgB3Y0ExQWpx8io=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH5PR10MB997695.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WitUZXg1L1BkTjFPWnhSb3JMQWZJMzNvVDFtcElLNE9rRkEwQjdEc2pzNTZI?=
 =?utf-8?B?ZzduVjYxV3Rwd0VhQVROTHhmOVJMZnFocWN0TVV2Wlo0MWVqSGpzeEdmb0JH?=
 =?utf-8?B?NUtUek5RbDMzVW1NcmNOOXg5OWpEWUVtcHc1c25EMk5XVHdkYVBOZ3h5Q2pL?=
 =?utf-8?B?SGYySVhrYzNSeTR4MUdab3YyRVprSnVBa1F3M1A5eTFCNVJOUGMxTHJlUlhY?=
 =?utf-8?B?c2RYK0NMWDlxbkYzZEwrZ1RGMFRLTXRRYU1PMFZiV2dIT0dVNnE0c290dHFO?=
 =?utf-8?B?VVVJNEFXUjI3MmhIVW5oZm5QbFRXWGdTMTZDM1lxT0FkU21kblNVQnBOTDJk?=
 =?utf-8?B?aUpVSmMwSktvaFJ6SXd4cmFDUFpXdkplN0ZjNU8wUTVuMTRuT1BXcTJ0QkZE?=
 =?utf-8?B?U0k5OXZ2WHZsY2RxSEtWbjd4eUFnaVMrM1I2L0ZFSlpXZkREVUZHSjY1Qmt3?=
 =?utf-8?B?NmRsdExQQzg1YTRFUTF6Qis3WGgweklzNi9IY21jUDAwNCtlS0tYeDFSNUMv?=
 =?utf-8?B?THpsNzIrek85RGJTTkNXMjUzeGU5QUVRcG5ZeWtxZEZpMExVYTdnc25sQlBw?=
 =?utf-8?B?ZmxLeW1mVGgwc0dNUmVqVGpURzVneTRpc2hublkwaWFwMmpkU3pTTXdqd2tS?=
 =?utf-8?B?OGF2ZUl0Z0hSd2hiSElUTEMzZkQyMXFnWTFJdjkvZTlRVExUZndoQml1cisy?=
 =?utf-8?B?RHBpOUNnd2JzamRYbUZZRzRpWlFteFJZc2FadnNaZlNVWWFDSmlqemorTHBG?=
 =?utf-8?B?SzZKVGxSaFErSE5ta0ZDR2VoK2gzNlBiRDV6T2laMHdjdWhLclhGTWFiTExF?=
 =?utf-8?B?TzRYSnRmWklnbWRnYTlkRkhtZy9pMGpiSm5OQ2NQcWRtUjVyY0lOQjU2Y2Ru?=
 =?utf-8?B?OEpCQUcrencxYkJxTDhONXYxeFg4VTZEYUxpcW1GbHgxdzJtUk53NDlhclNj?=
 =?utf-8?B?L1RXSk9QUEN5b01CUnRnWHJaMDRJTlhONFBUZVF6U2VHbWVVS2xWM0VhL0dP?=
 =?utf-8?B?UTJISWtVMXVEQkZtNktrMC9CTkV0TUJQMzBQOERzOVpYcFpqWkdRMXAwdDQv?=
 =?utf-8?B?a0w0b2hqaUVINEtiK0dnY2VVZTdhTEMxUXRVU1Y4YUtRd2xheVJ5T1luWkla?=
 =?utf-8?B?T2tmRHhTUVFNMVZVVjU0dzNhaXBGZWhlemtFeEdRYUJ3R21tUzY5R1RpZURj?=
 =?utf-8?B?ZGhDRXJtOTVVdkZDb0NvanlWYms2M0dtVXBFTnFZNkVNc2RKNDV3TTBhbmtw?=
 =?utf-8?B?S2ZkMGxwYU5QVCtjb3R4RDA1MUVyZGdKdHJWTTVEU1dJdnZxVFY0QjdCTm5B?=
 =?utf-8?B?RVpkOVZ6aXk0Q25tcjhTWENEWDVzWm03QVFhbTRjcHpFOUpVVUYyMUhsSFM3?=
 =?utf-8?B?QjZ6SXhpMEY3Y2VYVGhnUTd4aVBNa0VqV2Z5ejdwT24zWFUvWnd3d202UVAw?=
 =?utf-8?B?bkFHalpZS0tqQkpVMHY3SjUrSHVadm9LK0FzUzViQ3gzVzdtYXFaTU9FOVk0?=
 =?utf-8?B?eXc3UHJqK2MvM085bFFCU0ZyTUZqNlMxYktnenR6a2F5akE0dGZaYU5uTGZJ?=
 =?utf-8?B?cmJhTlAvWXR2d3N6Skl1RWxRL0dtUmpoRzF6dXljcCsybU55b29FVWpRRHF6?=
 =?utf-8?B?ejhXRmlubXB0MEYyR3FKa2YxWUxZVHNueGhtejlWKzd2Smw2K1U4L0pYc0dm?=
 =?utf-8?B?M0NtNEhuSlJSc2tLcVVIdXZxOUN5aUV2V2ZEMGNqL3QxcUoweExSbXdQNXJr?=
 =?utf-8?B?cFp3ZU5xYnlJQ3crZHgvUVZiK0ZIeXV5V3NWNEF3Z1lOWlkzazJaTmlIVTBS?=
 =?utf-8?B?SC9RV3crYWd3Sy9BeGY3NGJyL0VnNTJvRldJVGZxNmVKakxvbFUvZUhCUWE2?=
 =?utf-8?B?TXVVYmZLTS92WHNSTExvamprNnFPR0ZoWndQdElidUFaRHNyUmI4Z3k4bzVn?=
 =?utf-8?B?YWZOaVdvemVsdnQ4Ylc2SklTVnZJTXRPTHVaQUMvYXhUTkRZNXpDZEVMaWR1?=
 =?utf-8?B?K00zOUNBdk4ySU94Z2Qxc013Y05zR3ltcHJ4ZlZiaERoZ2dXanNpS1pHSGpr?=
 =?utf-8?B?TG56WTRnUTVXaUt4U2pvQ1d4bFJnZ0luZ2VrWjdFTVdqdmNhTDl6SDJwc0VT?=
 =?utf-8?B?VjkzSkNrUDRIa2VNZzdFSW1DMlJuU1lkVng5VWhuU0lSMk4xamRTdnhISVVi?=
 =?utf-8?B?NmUyWmpUUUkrK0JhLzlUa1IvaGh3Q3prSHV0cFV2RCtDVHA0Mng5b08vUDVs?=
 =?utf-8?B?VExHM1dnTnIvak5vRWk1NXBzUVhGZ0hMM2I3L0ZnZlpjdEhTdDZxZWNybGg4?=
 =?utf-8?B?dHRTVm9lTG40WHRvTHFocXNvK0gwcWZRTWxTRTFSdXN4M0MzQWJYNmxIZ0g0?=
 =?utf-8?Q?aM0UuTtUdxX5wXsJU/jwkAC/eHX0LRfh7rK04?=
X-Exchange-RoutingPolicyChecked:
	R5mvDydK3Q9fpPE9DFZ2Bx1pXUl3qUTCqXIby8eSzI7SKq3OFZVnQEpDDVfchd1wmDnyBIXOA0/o/Q1k7hmqDLllEYvTpNEqtmS6r4mFP09HHbUhm1F5HFEdR+ITktorEiFTnyj8hgxo311nKlARs//i9tfG1jV71qXJUakUugPO7j1sd4hWIH0jXf5SVUubKuCJOa86ZDi2tEjZ3Le3hGJkJ1isH6uiNj3NJEfrNG2UW0ZWGqxsBF9Fgxm9PVKWSi2hQYuDUIglxuwMoKBTV42xEkQ2cBjrAr+pZt4kywT/+Gl8DNejXB5789a18QV+gVAOp4rsW9YXImBmuLA5nw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	18FMSOMZ+9fWu/fZeIebZk/5yqG9nL8dYT9wqN5mooLy56V7ezj8Vh3UUXA99AjmcyHLnZuzFTnaGqsgeaCkQBC+DLpb4qHxFL1MprVnODmZcQvuRHWMtdm9XOAMcwcvw9hhu6aIqRJn8V+ujZAF8pCj2HlpxTD58Od94PYpXngMtsXBOmQ+W+xrP6qSea3c1Zkamm0obp2w7R7g1Lwbb0Ch7jXnd0xP7SgXeZAUnzRw/cttYpLJbiytnkYtwssiMGgSAx0QzwuuU8cow9lZxWYYeSl56NAahaiR4faYxSwDPzE4Y8P82l+s6zRWMKVjMVokmh7wuJlSR5CGhpaGRsnqReeOMWeNuqvr8iOj2eEI2u0ZkTjQydYinZjeMpd9KfydRjUX4EBO9hINKaPQRHmghQRNEMW1DEIMR1gJg87qRPLDgQzp1Ead6NjQHTSoYt7IfmBgwE+PmtHNf318JlU5mEsZFufAVXwHkF2j0UQnLNWCgBFQmcIqe1xnncUvUM0raeSdXArqCT+LiwbJAoxEuA4c2nJWU+ArS0URPdQvzTVbM+aOKy9CVbM359YGPO4I/0QiZP5LheFKr5Q9DHxRr2soR4ns1L8muGQK2ec=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a0149c-cb9c-49e7-85b4-08de9a8f2b69
X-MS-Exchange-CrossTenant-AuthSource: CH5PR10MB997695.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 01:34:43.3581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKlyxJPxApWI6hcPIdfV7sdEEO2mV5Glnl9w4Xj1Lctq++cHG+yRehgg22i3Cj0vXqJXBtoKoQLHRHwoXwITU7XD9pj6iqH0vlxl2IHT5hYCk4wUyhgs+BzbWkbTYmwU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604150012
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69deeb3c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDAxMiBTYWx0ZWRfX62eEaX0vD7ew
 g09bZO4fqbFHFIVc6TLkdKLQcFJjPz8jsVJZfkrm8Y5SSSNPjciVkfMCY5tZtSoRxbLh8ra0ITf
 u/ofB6NerBN8fpIYV9AlXqxkvHuC0peB/lkFNcqRSO8PGjaw7FyPmq7Jxn52AwDJ7UQXrT/cgvM
 o8Pn4a5YtwKVSHorx4rCrIC9tO5XDd4FL89GdgqWiO0pnVdMfwO1gntHBY+f095w+P/rLlqFw7U
 9+lAJ0DM5tcuYVl6STE3SHY7Jbg6wYFVfHpWoZ/+/pzIoOP87x59RkqVNGPL9fc5bx0sxKKokNB
 wzcKW7o7ZZiDoUOQMMoc6kD5ijtnniUIFCFDT9ogskqj/V7KKrrXuvSKjUPGkPebqPAOswgLKaj
 3GJ1DC8GVCezxuTbcnIa9VwArqtS1PervMWRQsUNypWKsWmIGWjQ6U5DKnzgnS8ZMYCwl2rzd90
 TeolVy3hrGqj9xRuDjA==
X-Proofpoint-ORIG-GUID: GttrvY4aTOdC8w-KVqRMj68zl4nJHo4U
X-Proofpoint-GUID: GttrvY4aTOdC8w-KVqRMj68zl4nJHo4U

Hi Greg,

On 13/04/26 21:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
