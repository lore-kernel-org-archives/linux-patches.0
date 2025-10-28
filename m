Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58958347C7
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761661116; cv=fail; b=AxW/xuRI9/tcV3c62suosrYVgbriT4hL5FahZMQYCsm3wo+14eUUkmWVXGNxLn9OcoELACsfdqIq7YoLrFzjSivOWQJFqyMANZ8ondbuZeFZJg/jsKVVkb7SvuvZvmyh9NzbkyoCyp190EBIcc9Z3wHDcE+3/WBP169B5tt0n6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761661116; c=relaxed/simple;
	bh=+T+6ephyOT8nNls/ykNPhxgKbepdXF2BkvaZqb7nF+U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uKskQ+67jedf7PTWO1aKNU0T4N4mjAub/i289PhjmNXCecJtbBbLYxR6uY3ZU8QY5kvxNOTJdLUrEm+Lv8pAxIta0vEvtdl49oE0rsvyInXE+EcNIBwrn/6UVyiFRFysHQkbhPG4FZ72vZjBO/oTjCx/huwNRA6QepOU0FM1YIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f+B2Hmq1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eP1oqtVU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f+B2Hmq1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eP1oqtVU"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDnZo010051;
	Tue, 28 Oct 2025 14:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ah5KiSslfw0ppYt/zvj0Udo3ANucaZHdxOWriSTUHI8=; b=
	f+B2Hmq1xG73rienBiugK3O0+vZ5rHbj74v8oldH7xSgT8LmwkyRbh8LhPKuEnk4
	tnCx7aDWrroDRMoHUeqCq6hwuPuLTZfErQT1ABm46/fXFmkdmKMlewE4kSpofhYC
	uG9c0CXwTJsAA71BcwveIzbbv3JNdieGbyk3b6xwS6hWDGP8utcxKHFGpj1d7e9l
	CctNPjNq62LrVGViD+x7DBJzcQxm/bqXxzrt2iZGFJc/T2aTxWpdaKYySNGJGRgr
	cvkCJuiABxE9PpBGI4CHB5J0rs39yM7qDfNILsb9wgVHPP/ageaFcVMJiICZgLUi
	frrMViySjUbqrPe7zBA/tQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0q3s683r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 14:18:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SCtFw4034852;
	Tue, 28 Oct 2025 14:18:17 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013002.outbound.protection.outlook.com [40.93.196.2])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pfn6ad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 14:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cm7ARxyaljg1626MwLz176ZhSUXHgFglXFPSHIwrDyWty5pDxIpn02tS6tdpDb6w8vsIQXrxLsI1WEKejDNlAzlXDqhT0aiFiNeC+hfOjR/0exnZL8qONkdpsAU2vXlLcTRpVCwmJmxmkUlJUzq9RpPDhw8y3256w1L3otzv59UyE9reJeYJbqHHyTJd0ZaU0nczbFcS5Zm/RDALfhw+M9uOopso9GaWydpIH/aNk+KA2N9Xv6RZBC5GShYQTJNJERjojsyZaSH+TS9q4/+Ij8s38UhLl6Gb7uR+4pVnZSAdyYH0DaYVeZkagU6a4tehDpqOzXumI5NEq0gSVo9eOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ah5KiSslfw0ppYt/zvj0Udo3ANucaZHdxOWriSTUHI8=;
 b=JHNJWU3/uocx4p7OCak2eHZR8kkJMTFpq5m+m1eysHeqArk3HMHm/OsBAOIJs9F/EwlwO+xbJg8ey1wg3aaO44bGikFxGdkkdRFPWxhu158PiG1FeN2gx0OwdqBHtVQkmeX3xZKQMenF/7k3D0eoaGDwu5AVpMpT8D2AAooOQQprPTWWrnfGAou6BoZ16Uay44wJ+6H46AWXRzuhRrSEDBJyAYAL7ZDn4jpnAyN4YktKkNnFc3uZyHkN2DkGSJ8zBuapstwiKcSk9tA2dT9gVPhLrxtRiCHAsLaTlvsKnZ3T+x4gD/GRqVdJcB5wdd0ibxq5UQiorpmQH3atoBIiPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ah5KiSslfw0ppYt/zvj0Udo3ANucaZHdxOWriSTUHI8=;
 b=eP1oqtVU9DdrAC+g6VeN5YVxqHFg3D/dcCLdUxKKmUbbO4SMETCOn82w25qgWLZSY+5Gd3ulp/TZSHw+aNcc8KS6w7hgIaDeT+HbIbVluSyCpEOX0KJjkLPhqXr65bzNxvAxdjxShNrqugEhm5y1GwKzEIdnZq9CO+vZa7/MUiI=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SN7PR10MB6476.namprd10.prod.outlook.com (2603:10b6:806:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Tue, 28 Oct
 2025 14:17:50 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 14:17:50 +0000
Message-ID: <d4a16e8a-40a4-45aa-8858-0a3559ca35da@oracle.com>
Date: Tue, 28 Oct 2025 19:47:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 5.4 000/224] 5.4.301-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251027183508.963233542@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::18) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SN7PR10MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 658afe5c-e90d-4895-2dea-08de162cc66e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkRGZEtPbUdlOUN5MTBjNDBXdVhDeURJajlPOTc2QUw4VXRVWnpjeFJ2NHpr?=
 =?utf-8?B?cGNTWEpjdVhpYUpMcWoyMUErU3MvUTQ0MTk2TkFqWkJOSlgyd1lhRzY4clJj?=
 =?utf-8?B?T2t6UVpoQXRrekI0YmtPYkVDdzhPenBwbWxJaU9OT3FrZ3dVaXpPcmtKY280?=
 =?utf-8?B?SW1kUnAyY1lNQUhzWVZOdHVuTmNqaW83UVVCdG1idzBaTloyTkE2dC9DN05m?=
 =?utf-8?B?TndLL3RxOGFIZlBmdFd1VThvczNNaWJ0djRlZEVsTmIwbmRMVFVEQ0VnSmVN?=
 =?utf-8?B?UWdzcnR0SGdiU3ZtTFVBazhhSVNJQkl3NHh6TnBmWGlsS3dVWGRMQ1VIRmpD?=
 =?utf-8?B?L2VIMFlheXRZbUQzakR1VGlyOTFiZVMyU0dadHFSNHVEa2Z0Z0YrU1pNNTVo?=
 =?utf-8?B?bDdRV2V5b2M3aEZ6WEdac2FYdG5ITlZhOFBpSG52SDgxY3FrbWNwd0IvTXhT?=
 =?utf-8?B?a1NmWXBnbDBoaVhQbVlCL2V6bHYvOEN4NXp0WlBXK3ZDV2JxM2tQZGZKRFB6?=
 =?utf-8?B?RC8yYXp6WTRrMWd1NlJZTzFBaHZxQ0EvdHQrSlF1YkdpUkhBOFZCQlpjWlNy?=
 =?utf-8?B?Y0lFOWdYWDNETU9ldnAxYjhvUFJoaDk1QjF6UUdwSXUwNHZZYzNIeXh0cW5q?=
 =?utf-8?B?dHJTTHlpeUQxVmQycU5aVW12WUZ1bnArc0p2eTNIcUdlbGZDL0VjN2xWQ1pv?=
 =?utf-8?B?WGY3T3VERTQ4QjRUNEd3a0pqZ0RpUzVSYWxyQjYva2N6ejlWNjVBLzEzNFRo?=
 =?utf-8?B?SjBra2V1elFDZTFFaEJnQ2hMOVRPZEtRRHRxME5zUEJTblZHVUtXL0VuN3dZ?=
 =?utf-8?B?dEU3cVBhVDg4cS9Lc3A4VnVRMzJNaG5UUEVjYy9CTjV5OEVZRmJYMTcvcTVY?=
 =?utf-8?B?c1A0OG42UWhPMUw0MmVZRjc1YkRNbkdZNmh0K25YelZBNEV2OVBsU1Z0NVoz?=
 =?utf-8?B?OXVGazl5eUFzL0VuOTlIaGNIYkphWS9meUM1Q0NyUWhSMnV0VW5jRGlmVnAr?=
 =?utf-8?B?VkU3eWlNc1JZUG1Kb2MwNEVJdmRFek00RnZGdk14eExPSVRQSWlvOWtSbXla?=
 =?utf-8?B?TW9sZHNCd1ZJeGNtVklFakJoZzVVKzhTRjNCYmJVZ0FBaC8rS0hQcmIraVpa?=
 =?utf-8?B?bk1QWlhYS0pNSkkzck5uR3J1aXhOQkluNWFEc2VnK2cyNXZ0MzczRGh4ZXFG?=
 =?utf-8?B?STE4TzVueEtkWXZGaXd6N2RyNE5aakk0QXA3ckZXd3RvSDJ2bTNJVnU0MkYz?=
 =?utf-8?B?MzRBTFA5NWQzbHJyWEtiZ2pRTDFRVXI0YXBBazNjZXZEUElCWW4rQjNmNDRx?=
 =?utf-8?B?SnpNSWc1b0ptekpWNkhNY2NwOEd4Ym5zbDZHdjhkaXhwd3FpS3FEUkQwSFVK?=
 =?utf-8?B?cnE3dGZnRFYxbDJ1Smg5R3JuZ3pUbldxQVF1RDRkZzJwUzk5Y1h3aCt5bExp?=
 =?utf-8?B?aHpZcCtEeGgrOVVkL25PT0grMGtpU0JJRjZaaHJMdUxja1NMSWd6VENyam10?=
 =?utf-8?B?NnZXVVBONTUwRk1CRklNenlsNWxmZU1TN0tqRlFpZzAxU044d09PY0MyMm80?=
 =?utf-8?B?Q252QnZYbjhnZHkrMDlPN09HSXp1RmUvNFduTjlsdE4yS3Z6T3hDWkRnNnBL?=
 =?utf-8?B?dTVabG4wMWZTcEdHWVlkenNwVzNpbmFTZWE3MkJPZGVJM0wzWmlnL2doWlpk?=
 =?utf-8?B?WVpCSlp5WEdYR0FDS0JKallyMWRoVmNNblV0RTBwbHFIZm9sMWpjbnRNd2Fm?=
 =?utf-8?B?dUVhNCs3YW9GbUErSVZubWJTMUs4MjNzVFl6VjMxZkJIMTVjWWh2WnhYVFJX?=
 =?utf-8?B?bmJKQVhRank0ZFVxMTRRK21DdEwzM0pCb1lwcWFPTDhlbTA3L3pqZThWeW9W?=
 =?utf-8?B?YWFFenIrSms1ZDhCNys2WFRyUzZKSGdza3BYbmlQQy9mVGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blo0bzJiTVh2WDBKV1ZrWWh3UmpwK2xubVJFbnBrWm50OFkvL2FmU3FCMlUw?=
 =?utf-8?B?RU5iMTNKREpqRTdBSHUraU0yL0E2Y2JiVmc3UXZFbENGWkMybUY3dm9qdTl6?=
 =?utf-8?B?b0lUQVFKQ1hIV2RDZXJlckRJdWx2NDRsaEhtVk0vSjc3SmhZaFM1OGxFSTlX?=
 =?utf-8?B?UTdDY01CWTlIa3NEQldQNi9aWGtNRnY1bTlHZzZiTVg0VW9MQXZVeDI5UDVJ?=
 =?utf-8?B?NVF5dmtZbU56NVQ3Q2tGL0M2U0NRSWpWVkRUVCtTQzNmNXZWbm90OFVPWEpN?=
 =?utf-8?B?TVRoeGU4ajlBc3liZ0dzYXpuSThpMmFqSERrdnlwb1hyZDc2NjhFMU42dFNu?=
 =?utf-8?B?aHVycDdEaHZaYmU4NlJuK1hYeGlHUEhqYUphWTkrT3hjUW45cDRnd0VQcWVX?=
 =?utf-8?B?R1RkUHNGWHZPVW02RXpLc0c4ZjQweW9RcGdINXVVRHpJVFpmM2NRYVV3YXYr?=
 =?utf-8?B?QzV6ZlRqMXlyQTF1TG43YmpaTEIrR3hYZGdMOXFTUGViTnc5TXlpWXVDSHVs?=
 =?utf-8?B?dmxNalpRR0FtTTAwdGtyb1dQTmh6NTNMbjAwMHQxeUtMMHY0YzU2aTFLUFdL?=
 =?utf-8?B?RTBreFJ2bEk3QmFFckt4U0NrZlJPeVRkRk05YXozVHBqaXJaNlhOSGtlOVB2?=
 =?utf-8?B?ZkxpMmZtWndGeFdRZGRNM3NxSjFQeHlRVUlldm1Gb082MUNrWUw0dVg3Q0g0?=
 =?utf-8?B?QnRVSStQeStRUncyc1RGWE9pdmE0K2JneFpIMUJIR1cwUENQa0cyWjUvL3Iz?=
 =?utf-8?B?ZzRzWERMVHFZRDdEc0VNRktjRVhaUURldFc3WUdyUFQwMTZraVdGM0FkRHdJ?=
 =?utf-8?B?Yklvb1l2NWRPZ1RVZDdBYjUyNW1ZSUMxTzcyUDVtaElxQ0psRmJFMHBUeFVw?=
 =?utf-8?B?bTBQK1BzYVlKY0tTcS9oYXEveG9wS3RZZ0txK2RndGRmRVc5Rjk3cDZFalRC?=
 =?utf-8?B?UEJrYjZMbm1oYVhoRUE1bEZJK0tKZ1l4OXF0dS91NDdkTStMem9YMzdrSXZ2?=
 =?utf-8?B?TStRMWVkVlo4czdnZmdFbG5BV1RVVVVwUklEU0lVNlh3bzlrd0JGcVNxblE4?=
 =?utf-8?B?eVpzYmFmT3VkdS9zaWs3NCs4WW5yTFMyVk9OQjBnbmNPK0RkWUx2ZXoweUND?=
 =?utf-8?B?Z1Jndit3QTJQWG93SitTQkNCWW1DOWRJMVM3dXlXSi94dzc5UTlEZGlQdFJQ?=
 =?utf-8?B?L3VyaWwvYXZ4RFV1U3FVTTZTb1JWMEkzT3p4MGg3UEFWdzlJblBpMi82Q2tk?=
 =?utf-8?B?WGhQalJGMytZc09JRVpzQUlnYzQ5cTdmbjJHcnhVVDJ0K0szR1pzaGlCcWZG?=
 =?utf-8?B?N2xpWGozWTk5NlFwYzF5L080QWowazE2VDUyNGhNd3NKRVYwdlVWMkVrazBq?=
 =?utf-8?B?dHRrSUxkTVV4bTZGbm9qYXF2MUNsRGlVZFQrL1UyckJVbUVxaTdWTHFjdUVO?=
 =?utf-8?B?RlVQUzJnUEszdHJZN3hzMjJwbWNRajkySWNNUTFOZ0tDUkJid0JpSEZUZXpk?=
 =?utf-8?B?eWs4ZGlleE9LZE1kOWFxcGJxR0FkRjR5TGJHb0JBVEhxemhZK1lPalNRODMr?=
 =?utf-8?B?MThreHNrUFlUUWllOGhuaFNHcWNRSW52OXFLRm1TcFc1eDV4VGN3azV2K1dR?=
 =?utf-8?B?MUxSKzY4bkVFenc3V1UvVmNkVEtZdmphSEg3NHhRNURXVG1TYVVwTVVZanpa?=
 =?utf-8?B?Q2FQRWFuR2V5djlsTnNjaXl3WVA1NHNnZGl3andmVlpZSjlWMFc4OVJ3ZVp0?=
 =?utf-8?B?N1BEMzJreE55MGx2RG9aV1pyckpJUnBHcVVWNjIzNU1XVkdhRjdYeFZjTUxK?=
 =?utf-8?B?TG9ZWStDWFgwRVM0NUJCYmt5L1VjMnMvMnBvYlR2S0FZYkRmekhLeWc0Z2lX?=
 =?utf-8?B?SGdEY1VTZXFLc2s2TkdMOXFteVpIakt1VE5VNDROT2lpUUFOakJRSDhOa1RS?=
 =?utf-8?B?bEVEWDg3OWxZYk96YmZXcWVkQzh3cW96a3ZjUkM2bTNKdktMVVZ2QmQvN3h3?=
 =?utf-8?B?TVVua29hZFlvWHpWL2JBcHdYUkdHbHp1MExta04rc3psWnRFTFBoRDR6ZUZn?=
 =?utf-8?B?WC94SDJqa0VFYmtSUFY3WUxjRlVybE5NeE1VQVBPZFg2UGR1YU15NnNPRzFF?=
 =?utf-8?B?MkdETWc2K0YxSFR1Q2FiYkVRaW5Vc2hpMHM2MTBic0lMK1dVa3F6VHhoQ2xE?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J5eWcoNUS9j01jNcDfSfpi83iVfHg7ucBx5AMAqkxoD96mlZO9TditxXn2I5HFBAp/fEIqUFArRRVrGgwPmV2UZprKCKUlF1bLwoTmtgEcH/kYtnZwRxZkO5NK0KGmZRgP6oHPOZFt3wvqqxpt3kVz5a9PMUxjAzYN9gmJ97Ur9hzcZrc5BXziXtDpj5z/5103eKjjTyyY9PLfMc3khmhfdZ3NR2n/tJGH06VbEYW1gvyyldU81Pco5fJTtqcYotubg89P5j0dmktYCOwZ5jhbkA0gKDowLqEZCuHgimuE3wpBLS397lhB6o/PAgO3LxWlyWgf00vSxai/63F4LpLMZE6FI3/EBCKz21o76ZUaNsnsTPiUvw8CzWnmeR9C9XjHRr0kzjmaCo9en0s4H9HUMBa8ZGQj+ctfzpRoxnlBx+K7GbZ7Q5IRnTv7U7pA98scHSxc970OID5xLRYvxVTXTSQjKh8cygofuKVugLzmxTMc+C6wK068iT9nH042btH3tlq98DuEKSNnK31YsDe3j0H08tgTuzRznfTdelWIMR0MLzYut9pTzg5MUDXQ6wihVRhwf072JrP2P6MaA9JCc+lLP+Hn9FVOdrJkaKYjM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658afe5c-e90d-4895-2dea-08de162cc66e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 14:17:49.9261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2V5tcgk9PoE6SgEXMebD+XLdRA+saFWPBFeClmhejzazWwMd1/EKc1M8AO/W6iUh7u5ngj6Uyyc3ishQqO78qCDDesR7XMlLCMmpncgg38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280120
X-Proofpoint-ORIG-GUID: CL3BfMy9meU8mpujIRUlRdWrH9RrIvsJ
X-Proofpoint-GUID: CL3BfMy9meU8mpujIRUlRdWrH9RrIvsJ
X-Authority-Analysis: v=2.4 cv=Q57fIo2a c=1 sm=1 tr=0 ts=6900d0aa b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=JCbkYDn2s9hrs8J9IaYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12124
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAzMSBTYWx0ZWRfX/P6D1MeZY1ID
 SSp8g/Oto9jpRFNuKxFZngOupWgeFbzL+gCKShG3oxi/VCFH7EBHmCS0jOfLiFp8a1pb1RhBwhj
 8MKKShyJk4OXUSMt+7RiRzwXGXg3XRb5r+lieSaLGkGU+7thsMZG45TUBI3kCkp5WKZchwUPDmD
 zaFy4x8xFJhupoReptKiqrKfGmOArDDmoy4e9asIDJ7L/fMcJosNowwrnKBG3tkSNEE26mNwfwu
 XkmRrW4CIoTsn3K9lgaR3XmUuWE1ky063H1GSIM369Y0HilxbXiCKtTUQ0vX7jRqyNJLepQssqB
 k3WDy5BDOTCkKynYJKBmVQHMi1k0J/wm5DQzO1SDivuNYQOBJ+M4f8v6HrtBccBeqgb5GPSOOhF
 3B/XY2oWWXeHUcqN6F1Euc2qe/W7Qqy6cra0FxNiqjBw4BcL8jA=

Hi Greg,

On 10/28/2025 12:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.301 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.301-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> NE7mCUe86dFjW5qDD5v2HZqN4VGLlPFhjP5yjZzxIl1E1aWheWUGJSZYLDzHSwCOOocva- 
> zhvQlIsjzrcl4HtHPREg$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok

