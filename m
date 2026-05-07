Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDE23ED113
	for <patches@lists.linux.dev>; Thu,  7 May 2026 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778155720; cv=fail; b=jUTHSzdMT8FQkTAHOyz7DnE1g1IrPSD327Dof60+CFpuMTYX3QhsREyRAY0gPdbUCcHsOFQpKcM+BE4FUUKG5xDUe7Rao+vygURrAwv6SpIeOZ0qed/zs/jzphXUwZbEoJAnCDfXFNr0PDS504NLPGiJ6ELEQ9cgJrnoWu/nGnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778155720; c=relaxed/simple;
	bh=I1BIEtitiCcYKaVjfTzgtYDeHTlSB8ipwpr+xZsY314=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oQFWCp99lAkLJIGybyNP1GOs3b8wTaBkj0H85VdQ8X5722STqE9nrL8HVmEJ89Y8V1Q8ufUaE2s8NN6ZeRcyja7/gTzJbXEbP+Ct5EOg1+A83eZqBZKrdN1dFI8VaPtI/pbLylnsRTblrCwH5+QGi9w3Q5WIImcZEukieFtE0OY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BloGmMIO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pJNxvqTu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BloGmMIO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pJNxvqTu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 646MfQPM3946914;
	Thu, 7 May 2026 12:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DhSjrN1ZjZuIRnGhWkYX+Voy8s3jOhF/fPNc2DhWmiQ=; b=
	BloGmMIO+ldtjtD6GnsebWBR6peIQ6oTeMuat4TK8rWL0BNTQY2ZGBl0mYW2pQah
	Dda5T5h7pma8mvxARIfFmNNx6DM7H8ttNDjJA5TMbwNwEp4Kq/UtDeNm7M3Ue0bB
	8UT0ufF9tjS7gjXgddySCf+WsYoatWhTC8W9A/eBN5rM3ysqlG4cwYqqb/NCv8GN
	0slpFTjnTajsDOqDkqFw+oibgRMNtqo2+Amjh9Y6CdDEA6w8Ucq8h3jU1YDPMUxO
	PwDj1C6ogdwNUOEUXcu41lkhXH94bupBC+lkxvj64ElECVj3DKooQpTiKvP/N4kC
	mWTP463oIutMQLg3csnk/Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dw9eq0qk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 May 2026 12:04:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 647BuC7o026519;
	Thu, 7 May 2026 12:04:18 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dx578encm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 May 2026 12:04:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lWFHlg0/+FVKNSrNlBgN6zCiwL8rhMVEY5se53jPsQKoOWQ82pztYcdQO8uXJyRZYEoVdqRhuL01XMF3NmYfZXS/IYQPJy5Rjb/s+fznB4y/10gPoiFxAVSHUg9ixOUtXYiSLBholvdjiBTngiB+xgF90xXGkN94ElPOld4j9djTw/ftWwXG2gR4trRyH5/AegFwKwiNf18G4tPyFSXBoqx1DBI7WP3h8/L+Yzw8f0PvE6w0wYcg2yeEOiPGBKEMxx5eIu9Cz0Lt1LcqTUJv7JHriUfsZlkzgv1xMDputrmeehOjwoJEy1uXKPwT7Lde1BIOSWMPZfqaFCnf50PiJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhSjrN1ZjZuIRnGhWkYX+Voy8s3jOhF/fPNc2DhWmiQ=;
 b=g1HFp3oHZ2ZUpafjZ6upyCqbtuxx674g73vKwaYPU2mINIVtmE06Gxdij1aNlCvFatKRSWwXviGp/JCK7Dw3Ywv1EWk2vZBfynToZEPcdqanXci65vYz4qfWw7rcyi0LO+mM/OApMjDaTj5ShCqJ2AR2qyOB8OWVtDoESFnlVyQAzWVESPzOsicji++iQ6w6i3Tv3TZLr4KkwuIeRr1APVVBwbvf3CMNvykszQOxIh4eYQkVcsfXyewoxIdolqgVmb91nHxMX52D6z4WXk71/Z9gYX9wGIsdNpaBaXhI9iwDPRqr92McWwLMheZjImk5vdP+JC+45EbsHJ60x7NFRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhSjrN1ZjZuIRnGhWkYX+Voy8s3jOhF/fPNc2DhWmiQ=;
 b=pJNxvqTusyvD9qA2h1fxUJjskdySxVHFsghMzIFbwvMaZCiRtfSxpoalWI5xK5ua6RsfNYS0qTZZXVYjz5Mf+GUL2Qw4t4cn5MLh8+zTcR2Di5o65hqB0cCh79tNv2GmgvqRRY1/tZNyqRzmtyZgNTZ3f61HVn8BasyLtoPgT5o=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB7075.namprd10.prod.outlook.com (2603:10b6:806:34f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 12:04:14 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 12:04:14 +0000
Message-ID: <323213dd-1111-4c45-8e56-3d94c2eb00af@oracle.com>
Date: Thu, 7 May 2026 17:34:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260504135130.169210693@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::18) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB7075:EE_
X-MS-Office365-Filtering-Correlation-Id: c9c2c238-6c9d-4320-395c-08deac30c194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6TziNxLAEpe5kGi2VXmfPZ8sd2s8nPQu7A+ij+FFsuPWeGZD2Bf6vOO4p2tE3g80iNEMT0FWj4SMVAz1h1mHX1UzrMZdkcPOAX+6jzbO17/fmhiTaOtnP+jF26z7btMhfoxa6I1S3acP3c6t62en2s1LAg1okysxv8hfkKBbRZhLkkpgR8vCermiWkkKxLM37uh+fXkCHwJrreUzI+M6LbwxVznSyh/Vzx7CrOROoG0P+ocRzW6UY0NIQxL3rPY9ykWzZTnNO+K24nusaFKYSe/4lc9rZ5t4LlmHwGhUwnT97C3CCBXOFdz7cLQ/tUPxL1BVMOCftyftjUxPWfg/l5GjD9rSMJ675iJSWcpi0jACnu3Czzi0MAnHgmlVB8PJUq5N07PoJSOsbzdv0zUfIKYgKgB8RfJNToJT3CBGclNZ6meV/sjwfmEM/Pb9NVfEqA6Oa1ng/4Q/hgMhgfqX5HIGEmTZQwn4DR1yjZHAjoGEIuOJMA8UmacxBhThQCERwX8scoWjWuGGLjlpPxznB6jeUbU8Kw817XDqUkJQFMPltdxJ66PH6US4hvysJljNeXtiau9swzsjc/j89SSTT0sG7DFfuFLwcC35hM5VGgEg1hBDhOpbqSsfx45Jfe+xxQwEsU9BuM7utHFZq8Zeic/wbh+DhYhA9MpjG6F9PThO6tcUbYLKOqzfikd7SvvZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M00wb3VISy85ck8rcG5IeHNEUnhWL3ZmSmRzNkRJTHEvdnd2dVc2MHdZRnFr?=
 =?utf-8?B?TUcxWEZHdlhqZlNFcUtmQzBwUXNXNUZoMHZwcWZxRmk0ZWV5RHF5RkhnMm9K?=
 =?utf-8?B?eWl4Mm9DdEFEL0NOeHl3OXA2NnFkV1FmZlZ1YTBRY0V2TUxoYTFFSCtLOWFG?=
 =?utf-8?B?cldIOVFraU53ZDJlMjl3Qnp2aUd2WEdyTEZFdlRuU3N3YU5udVJMZ3c2cTB1?=
 =?utf-8?B?T1JINWI4WHIvQyt0Q2Y4aUMvZFAyUm12aTJDeEhLdXBYTGhhb0xKNktoZ3Jr?=
 =?utf-8?B?US9nZ0FvS1VxeE1kUngwclZwWDdxYjNRMjBRU3pTUW5WYUg0ZmNnbWZlM3pt?=
 =?utf-8?B?a1piTnFUV0ExSE51WkY5UmxKZ1FXcEZqNkd4anBqekJTdDVBVE1TRkZIbnF0?=
 =?utf-8?B?dVd0WE5oREZPU1FESmFWTXo2OTJvREIvS3pPcFVXTXhVOGdQVkN1d002WlFm?=
 =?utf-8?B?OHZRUkQ0bnJJOEQyZFVIcXhlTkJEa0thUGtFQjhsWDdFcjV1ZmVpY2NTY1Vi?=
 =?utf-8?B?VHBVK0tOaUFNNWxUUFF3ZE9QNHB5aXl6MkY3UXU3eUlCd2Y2NjVVdDU4UFJC?=
 =?utf-8?B?SktKR2hUcjZGYlNtZmYvL1BvZWNQelJTZ1pQK3RTNEpJMlpDQjNuWS9sSEJz?=
 =?utf-8?B?b0toeWpOQUIwSmJVK1FSTkxDOFZobnBtZnZxRk42S0xyMmpoblorOW9Hbi9K?=
 =?utf-8?B?KzBiQWhOVEdBeXo3eEFVdXozZ0NJSi9vS3ViZHdmaEJ5ODU5akJ3UTkrMWZF?=
 =?utf-8?B?QnlQZDB3Z0FtNmxIdC8vRlJralJYZEYwUjFFbUFLelpyWER1WEN2V1ExSnBI?=
 =?utf-8?B?NXNEYW9QdVhDRWZMeVRPWkgxdnI4ZE5NQk1jSERabG1FU0V4RE1keitDRTBB?=
 =?utf-8?B?ZVJ1OFBCWEQ5cUJ5SXlYNkwra09DNG9aUlpNME9lUFVPQTVES0FiYVVKaWx2?=
 =?utf-8?B?dExxYm0zc2NybUN1eE90T3RnNWJJaHdCaWh2NGI1UlNyd2VpalA4Z0JVdXdK?=
 =?utf-8?B?VTRUQk1ER09FeWNKVTBKejNUdnBpOXVVdEtGTXNpUFVSa3ZZVzZnZUZyZzlM?=
 =?utf-8?B?WmxXWE9jNkU2R1dtMlVHZkUvS3VPOEEzSmhxb2pQMWVBS05iK251cDdaY0RC?=
 =?utf-8?B?dk1PeEhGYUMrdXJEaXRrS1NwMHY0MklYV2xKbjRKWE1wMjlKa1VXMm14RlJ0?=
 =?utf-8?B?enVBNFpEcFRQWncxUVlUNDBNYjNFeCtFK05aTU9yQmp6c0tmdTZRRXZRQ1U0?=
 =?utf-8?B?NHBCZmVDVkRaWjk3c3V2RUpEQmhjbjBNektPY1NTYnF2MFNzeDRpTEJJZVB3?=
 =?utf-8?B?Ky9pckFvYUxnZFQ5WmY0aWJqc3ZMRkVPSmNxQkxzRlh2RGNqQnhpWkZJOHo3?=
 =?utf-8?B?eXk5NHRZamVxMEZPYkltcVBCekVQY0VML2VSL2NkVzlQZWFydllHV2FPRTBz?=
 =?utf-8?B?Ym9yK05hbmxBNUVXa1NhVVBGL3pGNTlXaEc1M1FGTTFHcmxkSFlYVURxT213?=
 =?utf-8?B?N1BtU3JmYnVMUlJ3ait1b1BIUmc3Y1hmVU1SQzZYSGJKekhnM2dvTUczWGRG?=
 =?utf-8?B?WHlDUjhJV3ZTTVUyQ056MzJMM0t5WVdGVGY4TnM5VXkxaFNKMkhmZXZZVEFI?=
 =?utf-8?B?REsybThJRFNwbHRwaEFZUHNJSzFXL3BIYlNDM0tJenUraldTNTBJdGV2eEZz?=
 =?utf-8?B?UGxOVlhVRW5mYlpTTjJtZ1JSS01VaFJEYytjam1oMEhibUc2UDVpUUlmWTdB?=
 =?utf-8?B?aXVVRTBkK3l2bnJPQUwrZWU0WWJIWUdHck1yYmlCQ3FFZVdqc3hzQ2NrakRW?=
 =?utf-8?B?WGEzcERTMy9qR0NqY2ZxWGtvU2xnaXN3My9oK2NKdGhBODRHNFkvSVpiT2V3?=
 =?utf-8?B?OXBGV3I1Wi9nUDZSNG1FK0dXNGVNdldKalBVcTZvZytEMEwxQVR4M0c3SXZo?=
 =?utf-8?B?S0xUQ1NzWEdwbnJyT1cydnlWTUdGVFdSTnZLY3EzMW9HRm4xQ0lORlhGV281?=
 =?utf-8?B?Zk9QQkZTT05UTGVKQnlFL1d5eitFVVVHeGxodjRvQ0JMODdkVnBHODVrQ29V?=
 =?utf-8?B?Ujh5SEpSYWU1ZFh1cWJWTkJNbFFZajhFTkNZSzFpcEQxZnRzSFcwLzcvVStY?=
 =?utf-8?B?eFZpV3J5T1dpTWdvUnhLdnp3VktlV2JyM0hKb1VMY3k2TXJCbjJHU1Q5SzZR?=
 =?utf-8?B?bE02bStYS2U2OEVsM1FFeGc2ZzU1VjYxaU1ZczJZMHNUUVVnbUVHYTJpVEdN?=
 =?utf-8?B?d2ZmNDFZTDFBU2gvR0JQSmprcGM1MEl4VkxtVjE1YTFheUREUHZrdjJvcFJl?=
 =?utf-8?B?NXBTdXVxNDhUQklZM05RSnlXZ1hJMDBKMkF0Z3RBYlplMVcvWHU4ZHJYL2dC?=
 =?utf-8?Q?RRlu4GYFDlGP1bvR6VcqVHvJBsiZaiHrI5FCe?=
X-Exchange-RoutingPolicyChecked:
	ZiyrtWlhLsRPlwZq9EGmEKxUV0VSW4bLIj0yatQAR55U11M8m0ORm8Lk8GzdIrNn0Ei6V9G72eAXEHMkhfogZfwexvMi1w45Fg9H4AX7X0J6FniFXz1PtyQ7+pIMvA/HNWEw3FqJQn7gkRg3BCtVpTO8f3On+6lcsjaoEVtDDjCCazPGfGQ0AzFv9/wcZ9ujPEKJ2zZzD+cAyBmIJU372eqmN611Gp8r3MZzRIAImulnaOjFi4BvPlXV3J+sI36WdMl/d5bpPOMCmo017JQvb6RSQR+dlasPZXAgzF6sW9PofQjCPNx7DLAIcKnYB9B0oQYiJZ1844WK84TKGlJiQw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mu+eVNZjtpR+VZZrzFH2E1IUaGGDwojwEsF4SCrrhjsgobkekHKnbVLi02iftTx/ydKQkEOeKsrD/hapGHHfMt81fAQDV1nd2xnxcbq04kYsbJHwNjQulK4mqvGDZxwxLs5ujDrCyT2Tr1aDy3+0Oli7K8oQx61a/Y5RdQ2beK3nRdK7gv0gHHchLhVCPuT60P1KjuEMXPNQkbaLq+sUY0XzO14dUa6rn3lsunxwU/9PgMpJezKi36pKy2WsrtOv0SW3xQUYmyzC3RKn9+jCqCbRmM0U8Nay0n2NVRnNJ7xMu7yUwwafuCQQsefO3n0PszaXV2d8jqky98X7jyWj5wSfDuuplJxLbYv6vqCQl4Tv7JnTw5OZ/Z21Najil20iaErDJw3YCn9nPdFsJkpGzlMNTUMfjl3PPruGsWomzFyFNJjjsP6IpFuRd+x7o4D2reY9jGv1hUrpxKGBDDmx32jaCwfUBCmGQt/nTWC7n+D0CmmOHySh35XXsQA5SbeO160WXWTdHVckWX3QGbeWd96HQjYchi7cEvfzLM6P4Ps0eL4Nrs8iTor8VNSC0nG+/pxqZr1n5XU9uh72AE5BLSaAuEIw8RJ8c1/xMlMjFV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c2c238-6c9d-4320-395c-08deac30c194
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 12:04:14.1567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6nySe5Wyz3Yx89AsA6Y5Fv41A2ccw+wv/AcrNUdLHJTQjpBTow/neOCWPejnOMB4h7fdEUox2Ve1cTPxAMTdjdxjCD9HpWDBiAwo+BZPMIuV/BU+7lyAKqm9lu+Q5dqt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7075
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2605070119
X-Proofpoint-ORIG-GUID: 6I_A41poJ3LW8KF6imrAIk8tQblwDWJw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDEyMCBTYWx0ZWRfX8rzb7/OuEO2G
 tFP1oFg40vW2t7E2jBKIgXnwLKKzNTUuogwTNNUfZuR+GCXfczNE0Rxil9Zmp6Pj5b3uNsp11Fn
 e/5YUDkSb8JdmJM5lSBsBXHl4vn966KmmAGVagt4AdTNKLzVUDPL6N0ERA///zRxxzb2t6U/1zq
 CdnTFmq5iOBI+QNuYdHeX+mny4dJ5I3lyYrtTxSddYC+JSoiL1uOfIiDEiW+awrToECnyjfFafB
 uRcOoHWUPv0XBk/HWiZIDyHN9dmA2xjfh6cqKuzZ2EXMN+bb6w6WERukwwCr+cLcRG6jf7ofDfT
 SpqZyQkadkmCcYtJNy8qRr7dM7RolhypahZrL0n3mcWGUOrPqQA1as0D/nJcBMRcm5tYSWJ+nt8
 9H24w6FPqfhnnW/meQma3dLSrlni/ycgfXTSQevI2BWj0Psq2YSsaOKQ4Yhj7q7U4j5d3jn90/A
 BTmvo8zQa+VZm9+R+iw==
X-Authority-Analysis: v=2.4 cv=YKKvDxGx c=1 sm=1 tr=0 ts=69fc7fc2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=NAwWG0e-j77qbkYhR88A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 6I_A41poJ3LW8KF6imrAIk8tQblwDWJw

Hi Greg,

On 04/05/26 19:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
