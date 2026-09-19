Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F743630B5;
	Sat, 19 Sep 2026 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789830359; cv=fail; b=vFaDJeddy6csJPb8lr/0lNL+JclC7sBbCi6j2PgwhCkeZX9z+WxWTSCOIW6txIpUtbFHhj06g7KKaPSoeFAh63DY8MARr9qInBVF1FINCUE+mahi4ZsVnK/zdeg1MsWgrxO/w7tuMguSJv8n/ntWQz2G7zXRmVfa9BUZxcNH2Wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789830359; c=relaxed/simple;
	bh=OeGyZiJYKAz3dUd1UvbTnFcLYQ/w7w7AkyZmmwJYYxo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aChz+7CoqSEhLwwryDLfMHEa29hLaXbD1iQV8f7dUXtUviZKW6CRvYurw2vTFhWvZgnojERI5xoJt1dR0oI493p//bMSiNLDGE1VcIazN5XD2B5gjYNh0IFrC1lkezkNBslcLWWofBrlmAhzrsiGNG+oUiOmNGYsEJ9RIHDqj1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AQagZ3Vd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NawA20oA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AQagZ3Vd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NawA20oA"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JDjHht1142624;
	Sat, 19 Sep 2026 15:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/o9Gsk91xMSWkWAOMZf3t+xHBfoH2YpObBImj0fP+us=; b=
	AQagZ3VdNwIGUI04z/MNGRSdgvH6TepBEvndhOhuet2KZDlUBaxivf+WdBt7xeXq
	L9ZROFVB5FF9fUTovMBdFm0Jw5PnqDoDIz9bAZOURDlvpyAP1gH3pANR6kCyz5TK
	6pcsMaPL80qU6SINYENHXdi+5OPcGL+mPL+H4fRnjqDwVqUOIQXz2PAISxWwSoaa
	6cFm9DAODYIM5OHbQT0mthHhYR9HMcurbn84Kp7QGreoNMU6mHyrpQJUH+wn1v8v
	DHErZeOjISJulyTefWhsoCP6gr7xqzi1wZ3qP9JsUYyPRsXMyGSrtgs7toPdoz7I
	P70OubhFyL1x7DWHpyyjbw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk0xg857-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 15:05:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68JF5Kf0008805;
	Sat, 19 Sep 2026 15:05:49 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010051.outbound.protection.outlook.com [52.101.193.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgumxu41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 19 Sep 2026 15:05:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mA4AuF3Ggv9Lf32bor9V64eiApSohwSzKfAgzxh4SA8vwRQ38SG7g741P7qUQrKAIo01+MxTbbwoBTPisS4VusRnt3GsCKmLFNAgsZPu+F1DD5wRb6a2u55WugFdIsIiP6Vy+iS4JkVuGc/lLjEfDrxxy0rsT3uyEPbGscx+6VAA04PJg1JscdIqSzTvDDd6HdhKCzgXn7U2RiJtnXQEKd+qRFMKYKqPNPaNX4G/k3WNGU/ELM3h+CE+OsfzKl/qX7FYx1MJS3TpBhkPXJ9HTv5e4BhumWoNzRBm4AO5LYZ+RxCz/YmefrN3FU5aItgRNYaYTSCwjmfaulluL0yeIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/o9Gsk91xMSWkWAOMZf3t+xHBfoH2YpObBImj0fP+us=;
 b=H9JxxFnvcqNP2ZhZ2D0EptdWBunIUUgKBXnLyspbt1z7vtS6JIW2tnCQe5iLRxI14PlCYSPC2ZYbcSvQUxMEjqGLG6F+hPfF5deg2hkx8BbcSrYLQDMACRD4GPsMmlNHxJlAvQYY7tvnAlT5UX62WQAoQjCP6u7FPl8djUkV9ofD0m3hz++jvWmq9RRIcdj72HJTV5GVdBHKFOjwx2GubBHwKYII8H8pB/XrfHzYpyIioIEzPeoh8MFyIzodckLyk96gPeemsc2KSx87f6DHca6ErjAy/YJ1nbel+n0BrGpVuTbEpEvensvhdTn542fwnPq5bHqbEzxe2LenGMVQJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/o9Gsk91xMSWkWAOMZf3t+xHBfoH2YpObBImj0fP+us=;
 b=NawA20oAe1suF65fwUWfx7i5C4oP2OqRAP9DIM7wdf4BY4L7ggHyzvBW2cxVjzT8rzc1o/xD/sBDGuX9p3u73WkGbaK84t4vApah9eTPAEfOpW9D9edmiBcuZf3AirfFwF49ERP6Jv9aUiVOlG53tod8V/6daulewoOEKCea9jg=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DSVPR10MB997914.namprd10.prod.outlook.com (2603:10b6:8:3bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Sat, 19 Sep
 2026 15:05:44 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 15:05:44 +0000
Message-ID: <9b023ec0-80ff-438a-8d1e-15e49182d7d8@oracle.com>
Date: Sat, 19 Sep 2026 20:35:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0649/1102] ASoC: Intel: avs: Clean up streams if
 their initialization fails
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        =?UTF-8?Q?Amadeusz_S=C5=82awi=C5=84ski?=
 <amade@asmblr.net>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151556.451520849@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260917151556.451520849@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0162.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::12) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DSVPR10MB997914:EE_
X-MS-Office365-Filtering-Correlation-Id: 77a38b0b-a4b8-4058-ea04-08df165f7ab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|4143699003|6133799003|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1AvGFmK1FtNbfiRv0uL5ip4WYk6UaNPFMidBzYt3muvSyLReS8D4AXKgU0anIj7dVop6zWMHfqbvxf/FEAJg6XeVzr64sdhOnu7jtN5cZyb/KoMFIWMkgXNB+KVXYHzll6iQYohSV935jBJEFMW99J1V9AU14sS9xnqyIgnqe8MTiYRhk4wKq5FZPAGETZCkFvNW5vdJZg54rqfbtex9I1eRS1sbBAQmf7yOYgz5CiNg0bkzanfDXTNfYoNFD4zVbTR+De+Xn8YLzMo2ibS7Eu5pE/Wc7Q5zbt4xaxNMnib1d/LOznPcKU8vvVdR5diL+2+4ZY1rmUusmC+BZOGhBJuob2TFPFE9V9f1aHufvSYEISPSCdYn1qwmPkeyXmUFWkS3tII7RfJHzPen9RrfC//55TEuoirttakH7dn25VaEqJ14BblCf67HQ8aktzX50bvmn0Rm4LHC+tP++xfpNLpNLvd6Ym8iXzH+AELW7w6hszDgCCI6XFxpqmxaid6/huM0zqlo4xOjpLxYQb1+VzSCQZkfKorc4sFcT5We4wWWIAEScHNG8VRRnaLnS1RyPu/wRNpl4zbrLty/a9ZB9oxVCkdPu+0FLmVTBexZ62Zkv34F/krY1I+nwiVtugZm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(4143699003)(6133799003)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1dhRWw4QnI2TmRHT090bVJuOE9aQmNNNWpNQ0ZsL1Q2R0VIb0I0bnBRblhV?=
 =?utf-8?B?Z2k4eThMc25TKzd0K3NVV29uOVcyRnlnSVNsQnV1SFFvd0ozN2tGeUVzQStB?=
 =?utf-8?B?dnl3cm42L091RERQV2UyM2Rzc294WThIQmlrS1pMQVNiSDlabUVaMFVMelFl?=
 =?utf-8?B?OUlKbjRWa0wvTWxldGRnVTBObDcwVFZZK09HYVRDd1NYMHdZUGcyRVZPbWVN?=
 =?utf-8?B?OEQvejBPMXlpVkpoQjlZeUVVN3dzUEp2cjR1VHFCeWI1L0hOVTE5TUhwV3ZP?=
 =?utf-8?B?UmJDVEZjSnM2QjlobE5jQ1ZBb1liTXhPdkl5UHIxUDRWT1JiTU5pVG1NckhN?=
 =?utf-8?B?UDliMUdiRVpvbUErV2kvOUJSbzN2TUZKOUxJakhWMmt4T0hUYVpYQWw0MTVC?=
 =?utf-8?B?T2x6NVpxclpIekFCdFNWRnpDSXFjQm5OVWwzMndyOUsxZE53M0pCTC8yVStN?=
 =?utf-8?B?R2VpSkZxbGlnaUt2S3lRV2tNTHNiZ24xbEE2U3I5ZW54c3ZEMDZoZ1ZaMzY1?=
 =?utf-8?B?c1JTZXkrUHBwYkhWRjlxaG5OV3Z3d08rNmlPb0wydDRUbHdxVGZhVEQ0a2Mr?=
 =?utf-8?B?cE5SQUpsajgycHhIUzFKOTY1QWxXUlNwRUtVYmVZMXFYUEY4TDlsM01XOGNH?=
 =?utf-8?B?b0l0RW1tNmlBWTNDeGdEQmdpWG4rVGkzVWpWTG52QU5jMVcwdXZlMkJBS1Mv?=
 =?utf-8?B?N21CQ2JxckxZM0lXYzFkZzNjQ09JUUw3UEl6ZTB1c3dwZ0MzNi9rY1FlYlZl?=
 =?utf-8?B?YXFPeFcrTEJpa0RWMEhYTERBWlpId0pwWnVDbGJNRi9wcWZrQ0pSYXpYNlAv?=
 =?utf-8?B?dytzTTk2VXhlMVVVdExWTU5nZE8yTVJveEVIZlRoOEd0YUxRU3BsYnoxZUNv?=
 =?utf-8?B?dXRkSWNUSkxyeWdYdEVwc0FEdHhKZk5VN0FUT3BsOHVKNHl6d0FzWUpUV0xY?=
 =?utf-8?B?K2J6WlR6bmh5QnQxWHpmL0c3eDFSNzN5N0ljL2hwK0puemFWT25aNjArb0VH?=
 =?utf-8?B?M3RoVmRxd0xveDVBMi9qelVzS3FSRFVsVlNnMDhabDh1QXdmbXZ0b01NSXoy?=
 =?utf-8?B?eXFMdmRSNytiQXpMTXJpNmlsU2xDOXgxQ2dXK2RrajFzMzVleWFXeWRoWjND?=
 =?utf-8?B?VCsrMHJMQmdUSUUwM0hCSWF5Vi9WRG43Y3ZxeDNHckJEUlkvVDM2Q0hPVHpD?=
 =?utf-8?B?bDlVbGZYbmZxcmpiKzIwQk0wNXVCb1JSamthcjJ2czhFQnNQaWwrQm5NaE8v?=
 =?utf-8?B?bVlVNnVUcXpaU3N3L2llWTFDQVEvWHBYQ1RMYUIySXpMZzdBVC9aYXY3SWEy?=
 =?utf-8?B?clcrNzZZbmtZczZjMjA0OGJFc1phN2RMc0FENG00VUJXeDdMREU2a2ZKZFFm?=
 =?utf-8?B?NXpCd0hrVjBZZ3V6TzcwTk16aldpdWp0YVhCVVRCWjR2UWJyNUhzWm1ZOEdQ?=
 =?utf-8?B?cEwwKzdmSGJPdlo1QjhSamwyd1ZqMjNjSTJwOGg5VEhkNVAzSVYzbUUwVVZk?=
 =?utf-8?B?MjZ4N0hkL3pSZTFsVHRLZHNEQk1SeUlQMVQvWFVLaDFZckJEWjc1M0FMaElw?=
 =?utf-8?B?bVZaQ0dvNkJsVnVQZUNPaFZDUTUyY3MvRk9vcE5QR2FzN2ZuZExEUi9LMXJH?=
 =?utf-8?B?aTZLVDJFMlIzeUk4TjIxd1FOV2NhZU1JdXp0U3R2S1RpS0hwNVM5ZWg5Wkli?=
 =?utf-8?B?RDRJRktyZWJ0d0pWYTBpMGV1SnVJK01oaVJjVVBHdzRlek5EbjVteExWWVRy?=
 =?utf-8?B?d24zZEcwOGljS0JqeTg3SUFwNytjSzJ5K0dreUFMYUEwTkF6cDRQYm15RU92?=
 =?utf-8?B?VFk0MFFYbHZvSUw0L09rZnVpdWdrRDlLSEl5eHBRTnNFc2ZiRFNCV2VmYm1G?=
 =?utf-8?B?RlYxQUdBL2tzOGFhTTBTWUZLWlB2RDVlM0lPN0c4Q2prNE8rZmpad0xqYktI?=
 =?utf-8?B?QVZpY09Oc3pURTh2RGNnZ3VlMjJMeW04M1h5eDl4ZG95cUpYT2w3ajdWQmps?=
 =?utf-8?B?UEMvOTlQK0V5eGFkQzA2dU8raUpmK0dEMFhZNkxpeHpNS05OaHRSYlBmVlJP?=
 =?utf-8?B?L3pyWG0ycUJZVnAzUEw2TWQ5OXBzSnFGaWZJVjhjcGcxZGh5RWhKMjgrY25F?=
 =?utf-8?B?VGpydCtrcHNOQk1ISGVtZGNqRjFlUEVtLzVLMWpicm9ickp3WjFBaktMc1Uw?=
 =?utf-8?B?MTVyN2UyS1NVZHdUenFVdkp6YXhIK2RzWnlveW9DbGlaZzVFcVJnK1BMRi90?=
 =?utf-8?B?ZzJ3aGJuK1NzMENqaWRXRnFWYzBOcGFTVDZHN1lEZ1Bka0IzV2RRaWZuN0Zt?=
 =?utf-8?B?eVhDL1hkV0h2Y2YwM2RRRU91eXFnUkRXd0EzMGw0LzlYQllkL2d1RWt1N1VT?=
 =?utf-8?Q?tekr6y/Ivi1eadPI+5VxHWpkng01Hk3yKcPgN?=
X-Exchange-RoutingPolicyChecked:
	YbUlMiCW8ioD/jowhV3NfZuV8RSJgx7hvikCbD3JqtMelkKzst1SCRvFfLkAi40e38excZQgjyf59sEm73QWcM9a1bIsnN+W9MVE4RJ/ajUPkCWcUwtryma05UClMbljrt5wfY1zEU5IbAM9FOWC1TBMcOWeYZfajtfDFcrIE/HfdXhtYBAelawH29C9CWdLIfioxCwdkx5H9js0k7vnKv5+xJiQWoKz4NOZWv7n6dEHLsdIX8dsqvdlUF13zSpo2bxZs8fNuejUbieo/HJatl74CjU3p1FqSPnAZ7c2uKORDaVc8tt12xPtReoZsGWaFfPH+XX8yxnqXlhYreKEXA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KHBhQrfXAD/pJEYLtGBVEJqTAoc3f73pfMWZ+mm53TP3n0O8yEDwwptkrja11Ld++jqqVPG2auAZdZ44u9H8l/X/NFMGiJlh7u6UFf3d1kQfpXyj21PI+xiEjBgH+03JRsj7PCzOs7N/pEkV1Wu0ru04BqFG0e0O7F4zWK55t0gghEebYL2C2oM3jeRicOJ2O8avsHK+a1c1h8YyCxvfLfkcbwmuxWSYMTxMv5cixu80usNJD1B6FSLpv9RFKNyben4rANMTl7CFR+Kf+1TaTsI00rV3cLTKimH9hyYPY1o8c9XkOs3UbgweWN2S1uSn5+RrzuiYOza8etGLu26UtQfRQVN9J+TwO+QsefG02+NhWaPxnRXQG5tzxk9ZSbkQIyvXXKVm46BYOyof+JKFTm6lVfPdskVSH69Xs742Vlr7ybewMlZf6ChW08qQ0FeTX2NQ7t1NF1p9m6MrT43SeDZGwpT6Jyg1duY0ag/RyBZdxxef5/RdW/ZUD/fMyGB4yuzL3GZqu/fxplw7H1p4sadWBvV13CwuoiTHxtwoqELfiIt6oyXjD+9mlYI0tRhZVbyp4Iibp9Al9MnYegw6k0sv2wcNe16U7dKriK/dOvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a38b0b-a4b8-4058-ea04-08df165f7ab3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 15:05:44.7571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TBZ5Zsq4lkaK4FSl+ujXbJIWvhI9iEsSWVAshYY93ItbYFmnFF/iTGjE1SWJsCnv78d+tC0pxsvW1MzqPgzB452k6uwbSvOA8dovZjbmI9vrfc0Yp+wCpsAVWCQCF8s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB997914
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609190219
X-Authority-Analysis: v=2.4 cv=F/bC5ahN c=1 sm=1 tr=0 ts=6aaea4cd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=KnZRKgjGAAAA:8 a=k2Lk2S3_iUO_-1fW5jAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=TpiK_5arL7lz5Tb8ICna:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIxOSBTYWx0ZWRfX6mXGWbMzmzjX
 XVzUQgX57VC3lav2ZerNt0VL0ZLhq/KKr4P4KJ5Aa197SZwRNEF3wUt54oT64Axjm3BhaRHwhJu
 A4WuSGHx03NLO8ylD8wHNlfsWiN+9jfgLQ3GSoMWRcj4zSXrULYn
X-Proofpoint-ORIG-GUID: H3gtZC8rfBZXrnhklOLemHUVCaL4oRw7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIxOSBTYWx0ZWRfXzDc4kohnht9J
 wSnGTu4ojAivjbnmCgnPu5LpXoAZ3J6hi1GgdgUVVK1zqcY9zAMX+loHVv1u8NwyF0dx18kId4j
 oxg16v47aw6DTK9Rml8duBvGyGb55jiyigHiSlzhB3HIlOzBuS68DxNaQexPeKaF1xYnHu+zuqU
 Wzk3G3g6SCCk2meMW6EA+GBYmviE6zRBdPcBxuk7QwI7ReB84up7eFndSNCadftI9zDhqLvvIBm
 e0Ae1rmg3WnlA1GsGDInDxLCSqFoSFmhTaAxFQshUd6zQw3eOjTIfhD0qqCRmDFAH/vBQCgURR6
 azcnKGc8THSWBE/bZHcYFzRp7yQCrLir5ovAgA4uUZsAadpyP5lKsIG1Jn5VrgGNKuz3jrAP75a
 7IR+TzMkopv+GswWSdLcM+lt1mbDE8gNVFVaXIlMDvGG6rLvOCn22P8HnRu/xita4GGMm1cmVko
 NnSHUJz41r7uMzRa13jd4juD5hkDrP7ATGBEmJPA=
X-Proofpoint-GUID: H3gtZC8rfBZXrnhklOLemHUVCaL4oRw7



On 17/09/26 8:39 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Cezary Rojewski <cezary.rojewski@intel.com>
> 
> [ Upstream commit f4ba00bb56a8511bafbd19826501d27157141c6d ]
> 
> When streams are being initialized the memory allocation may fail.
> Have an error path and return early if that is the case.
> 
> Fixes: 1affc44ea5dd ("ASoC: Intel: avs: PCI driver implementation")
> Co-developed-by: Amadeusz Sławiński <amade@asmblr.net>
> Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
> Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
> Link: https://patch.msgid.link/20260902081814.1590883-6-cezary.rojewski@intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   sound/soc/intel/avs/core.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
> index cf7adf67e34a1..600e1a0a365da 100644
> --- a/sound/soc/intel/avs/core.c
> +++ b/sound/soc/intel/avs/core.c
> @@ -85,16 +85,28 @@ static int avs_hdac_bus_init_streams(struct hdac_bus *bus)
>   {
>   	unsigned int cp_streams, pb_streams;
>   	unsigned int gcap;
> +	int ret;
>   
>   	gcap = snd_hdac_chip_readw(bus, GCAP);
>   	cp_streams = (gcap >> 8) & 0x0F;
>   	pb_streams = (gcap >> 12) & 0x0F;
>   	bus->num_streams = cp_streams + pb_streams;
>   
> -	snd_hdac_ext_stream_init_all(bus, 0, cp_streams, SNDRV_PCM_STREAM_CAPTURE);
> -	snd_hdac_ext_stream_init_all(bus, cp_streams, pb_streams, SNDRV_PCM_STREAM_PLAYBACK);
> +	ret = snd_hdac_ext_stream_init_all(bus, 0, cp_streams, SNDRV_PCM_STREAM_CAPTURE);
> +	if (ret)
> +		return ret;
> +	ret = snd_hdac_ext_stream_init_all(bus, cp_streams, pb_streams, SNDRV_PCM_STREAM_PLAYBACK);
> +	if (ret)
> +		goto err;
> +
> +	ret = snd_hdac_bus_alloc_stream_pages(bus);
> +	if (ret)
> +		goto err;
>   
> -	return snd_hdac_bus_alloc_stream_pages(bus);
> +	return 0;

^^^

Hi Greg/Sasha,

I ran an AI-assisted review of 8dac807fb313 and verified two missing
HDA cleanup dependencies in 6.12.y.

Upstream has:

if (!hext_stream) {
         snd_hdac_ext_stream_free_all(bus);
         return -ENOMEM;
}
...
if (err < 0)
         goto error_bdl;

6.12.y has:

if (!hext_stream)
         return -ENOMEM;
...
if (err < 0)
         return -ENOMEM;

The AVS patch matches upstream f4ba00bb56a8, whose source tree already
contains:

48afc07c4f1b9c3cdbe66ddc3e7677ed395ce75f
("ALSA: hda: ext: Clean up streams if their initialization fails")

f16eaa38ea640884f66d24865c770c3f6c43bd42
("ALSA: hda/core: add cleanup in
snd_hdac_bus_alloc_stream_pages()")

Without the first commit, a capture allocation failure can return while
partial stream objects remain.  Without the second, a stream-page
failure can leave DMA allocations behind even though AVS frees the
stream objects.


They are in a series: 
https://lore.kernel.org/all/20260902081814.1590883-3-cezary.rojewski@intel.com/


I think both prerequisite cleanups should be applied before retrying
8dac807fb313, thoughts?


thanks,
Harshit> +err:
> +	snd_hdac_ext_stream_free_all(bus);
> +	return ret;
>   }
>   
>   static bool avs_hdac_bus_init_chip(struct hdac_bus *bus, bool full_reset)

