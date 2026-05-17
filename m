Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821D93CEBA6
	for <patches@lists.linux.dev>; Sun, 17 May 2026 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779043177; cv=fail; b=ELhKpKlBQGhSNnhoYv2fy+Z5awDR9wSfK37WGOCWpJPANUnmu+MWiIATdvhJa+MNB8I/u9mHXbXO/ERpYs+3vstRdK9JhIWF0D269lTmsFqLI6TVfK5aiyaWdBwKOZhmSTuqM6+EppFHkvtltxQHW1JIO6kg1bYY/FcyqPv0iTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779043177; c=relaxed/simple;
	bh=Xs536vyYr5XwcSAj6BbOtaf5MUb+IlJadnPic4xSrlw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zx40Y1Wc1syl3f6gva8y/ieWdV5JLRiONiSANWux/+U4Bhe7B4keAN4MHXWYIzCP20IF3v7X3FwRzIOVJmjAwo9gQV9bFbDXu0wNibvmyMuthntMMFbnJcMGmwfDuC53busEU8bbX9CoORdahUt3acwzINQxLhTP6XSLrBRqxug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bSZREuQn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CP2rq0XF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bSZREuQn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CP2rq0XF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64HFVWjr3827305;
	Sun, 17 May 2026 18:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O5U+02slA3MmU03EdY2M7ZefqQKXR5qny4n+jBms5ZM=; b=
	bSZREuQnKGPLpsOjAcvMhAX6a7I382n0SefB0476Old1L0RQtSu6dKEBRwWcYkWS
	78stbWs2E50XL5NnxmQ4MhYeSDePIuTSn9bv29aRt/Q/1Kmzmb7aAB9KfO+YpBbb
	cimNSmyhP4PIKWQyjdhnGOymc/A4Eg94WXrkhLPgzZLXYY0KOA+G4BX4OOpgChZz
	UitSNJWBCXlSanezVyqHscfE+kitRxWc6iCHO949zmcO9jJOSHBdS2Lsr8XFM2Ac
	3VQmwR9bKtPexYFIxoCdpXWR8ubeotDQcTb9/4CAxfn4/ZLFWh5e1275LQ2GW+De
	Offp+Gal9uzrGk4OuG7YnQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6gyx199y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 May 2026 18:39:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64HIYfEp002453;
	Sun, 17 May 2026 18:39:26 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010052.outbound.protection.outlook.com [52.101.46.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f18n4gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 May 2026 18:39:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJhUHbS81/uFSQfbGZVzENbCTxwk1R9t2Z4a8r+dH/eRWJ5q1h48EPYhvyWjeEF/01v/VaRz1yjrhKJ9LQsW6fNYMwkwreJTqtECXh8P+FxZbOrcfHFdIaONfvkCWUxBjdIhz9e2LSMx9oKY5XuYaogPk1YHZoe2sl/5TyV1MeB5c9GnVNQRbC7yfcA8g+RIl2j7Ue9LoxDJp0Z4J7jG5MbAcx2DFK+cLVLE+vlGE2cp1Nh2i8c49u0eDEKDAWT14HbF/2BpbKIuIH6+FWN5LWh12XOvCXVuTd4yd7Rs7Efp4SkjwvZCWsJTNjqaJoZhKmLEPjT/4mz53vL2nsYNrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5U+02slA3MmU03EdY2M7ZefqQKXR5qny4n+jBms5ZM=;
 b=JTD+wDs+tA/fftZiCwBoX36PA4FK5gm3zynbjrI3T0gqskE6sP0EbvcgnjGxy/b6ghRjoQ/JIhg/TV70/eIIc8bjH1Bqckf96VS06RuQU9OPT7ZQObqBmvu93AHQJVmHOPIDDqSup8IOPql5ZYEKC4Sh+ADyFuYTEMr3t1wUUR3ifkWXX39j0yjuR1NLujrP2yhfdvEU7s/K4hqRQoPyJ9+g9GBREmFUxawI0ZL5sQvHYhyv79e8oR4ENGXyGnV18Mf0wr0RJaDSuXJc3KjSMx6kICNEJj9vESl3wLTsObPkotpDE5nPm6KNUhOQ32t2aMwbhSuiv+j3/fuZGA/qLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5U+02slA3MmU03EdY2M7ZefqQKXR5qny4n+jBms5ZM=;
 b=CP2rq0XF/D+GmSbq48E/IqAhrh3auYg3mFuirR2c83Zy45qgHecRO4nnoy/b1MXcr4+FWMeDX1RkRzYZ4bjKJ/X4PvczLkdmSmRL1xW1OdYHOmHSFABWn3gYo4AVUHflmtaaZrITzL2VymnzbCLuUp8VAYC7R/MPXet7quYjpic=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BY5PR10MB4130.namprd10.prod.outlook.com (2603:10b6:a03:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Sun, 17 May
 2026 18:39:23 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0025.020; Sun, 17 May 2026
 18:39:23 +0000
Message-ID: <876ac528-b2db-4d52-afff-2a44f13a6767@oracle.com>
Date: Mon, 18 May 2026 00:09:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 130/144] io_uring/kbuf: support min length left for
 incremental buffers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Martin Michaelis <code@mgjm.de>,
        Gabriel Krisman Bertazi <krisman@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Vegard Nossum <vegard.nossum@oracle.com>
References: <20260515154653.469907118@linuxfoundation.org>
 <20260515154656.529062291@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260515154656.529062291@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BY5PR10MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: 663df5ed-913f-42b3-d133-08deb4439d63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|4143699003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wsn0+IFzqjGlfKBBCVUeEnZX5VF73IQ329ycOOuVR/XpJOuZwYENRhETDG76QqxC9FFaKG9qp2PSsqR7hK32V1lHPyz/zPztdUxEueI9bAthxEV6jMxpiS3jMCJuQ6DbPxdd5gDqK1qvIMDHEfqok86KcSnCbU2pjnkbCDbkbLAodOnlLDP2wXR1I4rgO+pPMB4uSAxlRm2AzgzcZb3j1OGNb+h9stwsMvjqk44Ihhtyjbz28EeiQ8iI6i7DQYvjAuFU7oEdbzUyprnlJhnRUL9voT2NMkQ9tyInJ0IbUxMlWy0mLKticGokCleBlOYPhAdfshUNkWzyyBkQWofckQAUeDUDPI8PHNGzSZDGm1uEYecuH6cOSAgzZ8PnMN4ccHC/Hx417O1lLPng4YQxG8GYx5VphRIPdI8sL2VwaNx8Trf8ZUrke4y7tF+/6pFL+0C7kQBeAIayZuCrF98rdekWez4PUhtOOegvoe8ORxDNg14efbzUpRW5IyaJBUdxBnvzG5JDKsC04C2qQNTn0QKTXEi5ICFpTXg9Mb3Lf2AzmeztxW0HUmCYk0zCw7hv6qeXvKu9wwPqMCxT0UkjquHSSEHu14r66ZqQKfDXnrsSH8GOBSlCU5ca6nCZos+RSoJ41IbHp+Qf9G0d6LYSv+TkWtsNFD2Tuvz82McLHDmTRCNK7aHyZalxBMk5kyUUFZwSW/GdGG3w/ge6BbGvaw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(4143699003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDR5aEROZ01JblNydDdhT3FxRExRTzVGRjExTUtackdxdE9iOGdnVEdkUUNN?=
 =?utf-8?B?MlNOL1EwTWRscVBWc1gvVzlQa3FyOXRCend6bEpTTHR6aUFIUi9JOW96Qlhz?=
 =?utf-8?B?bDB6NElEdnYzZkhaLzRUQ2JEaTdxTVBoN3Rxck5YdkJ0b0NqNGVVcWhIbGtq?=
 =?utf-8?B?Yi9yeGtQWTNhQVY4N0puMytjL0cvMGxKYWhWK21ITjRXaThCdm5uVjlTaUxx?=
 =?utf-8?B?dW1xSVVDMVZnQkEvdDBtYng4aEtnWUQyYlp5OWZ0WXpCNTlPdFljOVc3Vm5G?=
 =?utf-8?B?UlZQT0txK1A3N1grb3RzMFZzY0VRV1UvRGRBSEVqMW0xdTlOREIvM0Jaanl3?=
 =?utf-8?B?UzI2R1B6SlhXZ29IWjJwQ1B1UE5qbFpoRVpXWStNakRzTjVzTU5BeFI3cUhv?=
 =?utf-8?B?eGpFRE5TSEJ2L2NJbS80MmRHcm11QVhheVRnQ0hPRUVhRG5kS1h3RUdBMDE4?=
 =?utf-8?B?eVU4cTZQTjVWRXY0Sk5KcDRVaHJmc0tkdmxsa2pkY3lxa3owN09PanB0SEJi?=
 =?utf-8?B?aFY1cXU5VW5RdnpKZU8yNHdmTmFPRmdraHB2QTk1S0toVWdjakViWXhkZjQ3?=
 =?utf-8?B?OXJUOXhySHRJWGF1Ny9BU3l1eHN3Wno2dmtETDJhbGR3SUFUT1lWOWN2SktB?=
 =?utf-8?B?cEdIRDR3Z1B0aVBmVm9CM0RvTlFhZWpaZS9XeVBzb1BCMkR4WFZmNDlLUE9X?=
 =?utf-8?B?ZEdZNXhVM2gvVU9ablVJRm84RjJGNlFuRzl3M2dQRmxWM1l3ZGNXaEEyV21z?=
 =?utf-8?B?eVAxRmk3OUxjQllBYXpYb3BQdS85TFhVMzNJb2Z3bVRFU0RwYnNDZGJqQVZC?=
 =?utf-8?B?eGFrckhqVUhEVVRNZWIxTGpmd2NPRlZhcjhweXJkbGl4UWR4aitaUitkRGJv?=
 =?utf-8?B?MXUxdEgyUmNTRU8rQStQMkRweHdRUFIwakppSkxyY0NwUHJJOEJNUnFIN0ZJ?=
 =?utf-8?B?dGdZNElKVXVTU2NhNXhFbnd5NmxJYWVnMHJDbktnTHdSNnlpVkhaUzRReFFO?=
 =?utf-8?B?QldxcW5Jd1FYMXJONUQyWk9PNFFWRUtvY1ZMV3NnVXpXL0FpN1pvYjdhWDJI?=
 =?utf-8?B?ZG9Zb2JaU0Fvdit0K0tFNVVQbGhhUTd3WFFNcWJWU2hJSDlmUnZ5Tk4yWS91?=
 =?utf-8?B?NC9ldE45Y0RVVTZYdXhseXI0OENiMlZjWXBuc21hUHV6TCtEODB4MGxKVDZk?=
 =?utf-8?B?eEtmTDRHOTJCVk5aTU0zY2htdVJwSDhBUVdzWFFrZ2lUbHJhTDZSK1pDTUNO?=
 =?utf-8?B?QUhhKzJ4WXZ3N3FHNVhWaDQ3Uk5kRFRqMlNsNEZGVGJFSG1Cb0s4KyszR3Z4?=
 =?utf-8?B?bmZxWFpzRnF6WjFMWG1sZWlBVmVYK2ZlWXYreTFwL05Md2pFanM5d3Byb3ZR?=
 =?utf-8?B?cFBHRHp6ZDRLMkRWT05hdlBJYmFXMkp1L0Nrc2VNUzY5akprMmJQalFDcTJX?=
 =?utf-8?B?bm9wRHhjVTVXS2dOZnJXdXBUTTJYVDkvbHcxQUE5Ull4SUk1eHJoVnZFZmVI?=
 =?utf-8?B?di8xdGtWamVEMW5ad1ZITytTMktLTTdKczVHK0RDNUF0bzZGMkFXYm4yTWJB?=
 =?utf-8?B?bE5GL0pwck5MNlU3MCtPL3NpbXREV29sMitlVzJHUHFtaGRrSHdwVk9xeGs2?=
 =?utf-8?B?UzhobmJKWlBnQWtXa29kL1ozSGlTTExQSGtzd1FMcTJoR2tKd3pwZXFzU2Y4?=
 =?utf-8?B?L0hybWhaM1ZJaDQ1cXBCc1h4YmhEUTlSWGZCOVNSUVZMbUVndTliVHJyN2U3?=
 =?utf-8?B?YlFGdkJWMm1QTnUvK0V2RndCK1dmN1Rra21JTXo4OUhTb05WZFZJTW9ZL0pS?=
 =?utf-8?B?WXk5cmEzbHppK0x5OU1sRER1UUtoRERrd0VFdEtENEs2RG1zMUdBZHBtK24x?=
 =?utf-8?B?c3hKM1p4VjFoU3VxUERtLzZUenJPYWRleE8vNTZ2L0xUWlk3L2VnaFYvanVt?=
 =?utf-8?B?bFNiT21NVmV1QW5QdUpCTytzV25YemNCUmJncGxReVhUdXNEY2R4ZkhaRFNh?=
 =?utf-8?B?TjdtQ1J4Mk83eTR4aDVMNittSTI1NG1hNlRYeUlxVFBDKzNwai9lUklOM0pj?=
 =?utf-8?B?T1BtSDY0YUdWS2I1aGhNSXJaWnFZcjN0M2VFN3N6UVZCRllGK3d4UUxaY3JV?=
 =?utf-8?B?NXMrNUxaV1Y3dUxvb25iZEpxY3BaVkJrNjFTUmJGZFk5WkhuMHk4a203TFF5?=
 =?utf-8?B?aUxjQWxmeE9PM0xwYkVZU1cvdDNjK09kNXFUMFBKcUVIWkNFbXJoOHVtOVY3?=
 =?utf-8?B?alo1akYzM3UwR0U1T0JDWkc5bU1tcmdUY2ZMeThrV2YzNENIZlowWURCMGR3?=
 =?utf-8?B?czVYSDNiVmYwN1FXMytsS0J2MWNON2d4TUpmamE3NVRqVDhjSGQ5UWNKaHJS?=
 =?utf-8?Q?YkNTNQeZIlfuBngmCOMMV8TOm5+sNUbqx5I45?=
X-Exchange-RoutingPolicyChecked:
	IJ9lkKITA7mcWiSJzZQCtk0xSFDGRa5ZVgFIS3mgEP8ah53yiF4w3y3lEXUDa1snLLclx2fjsbzYY77MakH3ThLgvsfs1teTul2nvErFhJ85kFnOvC63SJNBwJ9z7hChaIMLa+O+f9QxMdROQfhc5bkRJ0fKXntBnJGboYL0WLwBgZDMpZ51IVa00lqqx9AG0LkhYQX+3/SW0wyUM4oCwcSAAiI/o5J5ZP5FLztYn98PofVqGGLudbE7MGU/27f2GSRYq8UY+GUzhvRb+jsiWjXiTUE31p9FXY72tk3CvAuju0ETB1eRbOEEFgIIAggAlA8qBukcgH1qV5mq7hRSjw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PYLZN8kLGyrIqHMiWmQBZFBOnK5xy6MUMi8wZ0kaFon2BrnkU0ZaYYjAkBvyUuXwuTOChmPW8oaVT6gucqKcNk6miV+pzk2mFr8suUJqVD4oj5/AYiOMkfxtbqrU2PX19+fzXjZ/ZBUy+fP2L4LnCS96Iu2xWQkbLQuz27Hnpe3jeCm1uTWrcFd8TXpgvUcRfqAHFmIy6INkJu9di+tXynX5Pyf/uXxEeGe8JrYze42T8WTe32LI4PKsXyQgT6z82wDwBNlNugAEgRCKe74tnVnlI60rbs/X2CwQ9QWUk0EYQDwwGFsuaa0jVSYBDLDd5FS5gujxDvGl7lJfGl0kmI6xeIeTo7Vbeu/C470kRarmunKkhzV5S6S9kHumMPwKTE1ALZhoQLRGzRRdo4QZV02wHOWQyp0AaZljmElPd8kkfJcPWVwDBDHVfNapjnnmyTKGtSa4tOVRLhpf9pN8Q85KHdnvYSRV9lYWwQdnXHC5MiUGnBx18ayyPmgx1EMD9CeeKCg6Q60Ixpxg2rBtLaEt0Coxiimv+5oTRUfoHWlP2r4Ukms4t9ls7fc82GZaOOpWztox22EVdSKEoLH8mMfsZeleUENVOgF7fsHdmpI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663df5ed-913f-42b3-d133-08deb4439d63
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 18:39:23.0924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YodS2qKC64uhoJCV/tu+tQ+UggP75hFL44KO2v0DHoFAquVOkKPPYnk3roOKBnhYH3CZQjhxW2LZPNs+CS4j8+wWWU0fpMy+MMIa3gdSA91JqWEzoHCIXipywhXjNjcE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-17_04,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605170201
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE3MDIwMSBTYWx0ZWRfX3lPAPCTId8uY
 V+RsjT+RCq9gnzPDLxLPxk6uy9YRIY16H4slnnNruepDyLAIeCm8aKuwo9fcIjMyToI/E+b9+qc
 mfpS9GL7QGeBBsDXp+tZmZ/dBz+gXFcmwqn1iPEBzgOq2U+GxRz8mv0BBmire8IGmobdheixU2G
 3J6RVKba4gyE0hiQubstZ2w1IGAFJ1XfbS6BzRVj6SeeAUI/v/CAxzD4wSWsCOdPpDjIzjyMZzE
 DNfNTeHRB+3+u8PZlHisgneHyHiHy318zjBlSW3gqTBQcSPYBZoZvJCeWb7u8EEx+roVoBrbsIP
 e2uE3cQ6EsKlHys7lYG8//l5eQe1ZYa2co/MBKB9he5/K0m0nLT2pSlax9aPDmiAuuATryaA7IK
 I+gE7vyYEM55M+pZVtQrNTmTy/Aameion2bBMoJdCM6qFN2XLgcMTReQlpP0nLANNbh7StNuTTv
 GKM4PXZggc6wDew1Lhw==
X-Authority-Analysis: v=2.4 cv=Ls2iDHdc c=1 sm=1 tr=0 ts=6a0a0b5f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=AwsdFj-TYtKKazKUFgEA:9 a=QEXdDO2ut3YA:10
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: USQxslcRRw2QTM0vGorbNwIsX9Dr-Wk8
X-Proofpoint-GUID: USQxslcRRw2QTM0vGorbNwIsX9Dr-Wk8

Hi Greg and Jens,

On 15/05/26 21:19, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Martin Michaelis <code@mgjm.de>
> 
> commit 7deba791ad495ce1d7921683f4f7d1190fa210d1 upstream.
> 
> Incrementally consumed buffer rings are generally fully consumed, but
> it's quite possible that the application has a minimum size it needs to
> meet to avoid truncation. Currently that minimum limit is 1 byte, but
> this should be a setting that is the hands of the application. For
> recvmsg multishot, a prime use case for incrementally consumed buffers,
> the application may get spurious -EFAULT returned at the end of an
> incrementally consumed buffer, as less space is available than the
> headers need.
> 
> Grab a u32 field in struct io_uring_buf_reg, which the application can
> use to inform the kernel of the minimum size that should be available
> in an incrementally consumed buffer. If less than that is available,
> the current buffer is fully processed and the next one will be picked.
> 
> Cc: stable@vger.kernel.org
> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
> Link: https://github.com/axboe/liburing/issues/1433
> Signed-off-by: Martin Michaelis <code@mgjm.de>
> [axboe: write commit message, change io_buffer_list member name]
> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   include/uapi/linux/io_uring.h |    3 ++-
>   io_uring/kbuf.c               |    8 +++++++-
>   io_uring/kbuf.h               |    7 +++++++
>   3 files changed, 16 insertions(+), 2 deletions(-)
> 
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -758,7 +758,8 @@ struct io_uring_buf_reg {
>   	__u32	ring_entries;
>   	__u16	bgid;
>   	__u16	flags;
> -	__u64	resv[3];
> +	__u32	min_left;
> +	__u32	resv[5];
>   };

^^^ let us remember this. More comments below
>   
>   /* argument for IORING_REGISTER_PBUF_STATUS */
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io
>   		this_len = min_t(u32, len, buf_len);
>   		buf_len -= this_len;
>   		/* Stop looping for invalid buffer length of 0 */
> -		if (buf_len || !this_len) {
> +		if (buf_len > bl->min_left_sub_one || !this_len) {
>   			WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
>   			WRITE_ONCE(buf->len, buf_len);
>   			return false;
> @@ -727,6 +727,10 @@ int io_register_pbuf_ring(struct io_ring
>   	if (reg.ring_entries >= 65536)
>   		return -EINVAL;
>   
> +	/* minimum left byte count is a property of incremental buffers */
> +	if (!(reg.flags & IOU_PBUF_RING_INC) && reg.min_left)
> +		return -EINVAL;
> +
>   	bl = io_buffer_get_list(ctx, reg.bgid);
>   	if (bl) {
>   		/* if mapped buffer ring OR classic exists, don't allow */
> @@ -747,6 +751,8 @@ int io_register_pbuf_ring(struct io_ring
>   	if (!ret) {
>   		bl->nr_entries = reg.ring_entries;
>   		bl->mask = reg.ring_entries - 1;
> +		if (reg.min_left)
> +			bl->min_left_sub_one = reg.min_left - 1;
>   		if (reg.flags & IOU_PBUF_RING_INC)
>   			bl->flags |= IOBL_INC;


I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:

Backport updates struct io_uring_buf_reg to min_left + resv[5] but keeps 
legacy validation that only checks reg.resv[0..2], so resv[3] and 
resv[4] are silently accepted.

Upstream has something like this:

if (copy_from_user(&reg, arg, sizeof(reg)))
	return -EFAULT;
if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
	return -EINVAL;
if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
	return -EINVAL;

6.12.y still has:

if (copy_from_user(&reg, arg, sizeof(reg)))
	return -EFAULT;

if (reg.resv[0] || reg.resv[1] || reg.resv[2])
	return -EINVAL;
if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
	return -EINVAL;

So we are not checking resv[3], resv[4],

This commit is needed commit: 172484907285 ("io_uring/kbuf: use 
mem_is_zero()") to fix this. It is a clean cherry-pick, so I think the 
best thing is to take it for next cycle. this commit is present in 
6.16-rc1+ so newer long-term stable kernel releases than 6.12.y don't 
have this problem.


Jens, please correct me if the above understanding looks wrong.

Thanks,
Harshit


>   
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -38,6 +38,13 @@ struct io_buffer_list {
>   	__u16 flags;
>   
>   	atomic_t refs;
> +
> +	/*
> +	 * minimum required amount to be left to reuse an incrementally
> +	 * consumed buffer. If less than this is left at consumption time,
> +	 * buffer is done and head is incremented to the next buffer.
> +	 */
> +	__u32 min_left_sub_one;
>   };
>   
>   struct io_buffer {
> 
> 
> 

