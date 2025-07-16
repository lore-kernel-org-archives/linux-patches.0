Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732732F4A0E
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668746; cv=fail; b=tN1lkpPT4Fysi1c5AciPGTXsUSsJDZDUun5yIXusE+9BujAhQvGaN9zmwnDzckJR4AsGCggsP+9ZBdxViWSlp7SQrg+iSoqmBH+SVJWNMobkhRbpjk/564DEVEmU+DYv5LM+WwfyYXoTDfhfMnD/DEU4em5xvn3TpoFcqi9JF08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668746; c=relaxed/simple;
	bh=ZTuBCQGZLZjmoEX4GFh6mc1zrXJQgeXnbT1TbuZKGSU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fMv+8Nq9rkViLV7zTv9qVCwLONEW83w20b04dO/VM7l5juJdA57YfSkmcN6Srs6J47fxiD8ggJ59qE8EjAW+D1hAZw4xH/7OWykoqDO1yq3olsLeANRLaQkUsVAMdimoZIEEPKECDrmFgFQWBdirBDekl9wjO5X3CJGf3LoYN7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=plo8RVSv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DgaIpqL+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="plo8RVSv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DgaIpqL+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56G7fmJW014762;
	Wed, 16 Jul 2025 12:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=K49Q9JFlvaJDl4V7U+i7jP1dDK8koWjDOad4feSjyU4=; b=
	plo8RVSvR1LyiAu2PFQDf6dJeItH2yy6iMWD/kVJzvrhAdzTRVjlMcqKeeDyfNh6
	Uu9qVJpIX2QH88nxiamqDXmCx7oorHkEwJXw0aeWCvrHjViG3VeHFrdJvimrJQvN
	Afe4E6Msuh7KRhBCP7lvcDOgWvkTuLe0AcxZJjzRBOd/jgK0eq9mf6reefZhiMfx
	zLKA0r+S19KlGch88oaQnTa7kw1Hsy30bgqDizJTfsj4fk3wHg+VtiV74OuLcFjT
	EIBGwBiJiAn8yBSWBb2Cm0Jev9FG0k+MvLVF5WWUqubneCt/3J9dM/7frDXGebWp
	wk6nWsBTWcGL39/QxhNauA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk1b0sqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 12:25:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56GBZ4Ro030404;
	Wed, 16 Jul 2025 12:25:29 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5b8qne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 12:25:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2nIoVbygdpqhIUphHogDcNJiiG4Y8umZbAJTHbEY9qAp9kYWrHPUHYCISj7tmzeYlhE39j/gB/Ru3WVUgj27JF9RPkNtFGllIDTD4yaCxP1cgcRH7oid1JXjr3Fwf/R5IRGPsLfcCqlyh0c6VlPjstISSiEGzSNBHpyVHnlJxOUc8K1/nso8nPyxc3aH4xdzJvNiRi6jmzLU3uAyIcsZHS9to9G84IQmWRAwGHyfFQyAHK7FsEqR4QCVVR3SzVX7TM+GqfDATdOObJlHSzWNwe7bMnShsSPpqmhjSpRrQ9fR7z0RtFoQxLMzq0M1ol7kAmW3OKUu9In+EPYmihfXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K49Q9JFlvaJDl4V7U+i7jP1dDK8koWjDOad4feSjyU4=;
 b=bY8TqjlWnUT2xRm/r0xuoS/8ItuWT1I5f+1rFkAooKlOgv2AMhLgLjUS/Gvw5nD86S1dmZwVYYWViqbRj9Zil+rE6Y09Hp2NNNdZm+sIeNOzSV0WEpMJE56MIhOT9/CZ48v7+UjrZaIJAaToO6gg2a1kEna+l+OPVzXdR6MB+uezq9wJhXcEqdQTlcGOWMfFmOtaYUOLVlRcLcJrEOd8pf49QhhUdXsMNxBA6FsooPhRkdKUkZ6SKXpyNJhE9T0FcVsBwQsYSxvXu29cE4hh2TcnlosBmgbnh5kg0oK30Tz2AXvF4L1rGSW6cggUXozfWZBPk+NMXNXtz9y8B7IN5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K49Q9JFlvaJDl4V7U+i7jP1dDK8koWjDOad4feSjyU4=;
 b=DgaIpqL+sG2421csUz9nLhTiyEsBGmwQfAKNS4NCPqbDYhyiosYyRYBGVtEjrgpeba4spA3Ary6zwuBlJmEG27JO5OrtP4UgGRfE1RTi3KSezuGuIaAi9qyYi6mFWc8u35MMT+dV6JiCUf+gC4AerFyhyDrv4lCnh6zgscdxGvY=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by LV8PR10MB7725.namprd10.prod.outlook.com (2603:10b6:408:1e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 12:25:24 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 12:25:23 +0000
Message-ID: <b7d8a973-933c-4f28-ab28-11d23847e8c2@oracle.com>
Date: Wed, 16 Jul 2025 17:55:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/148] 5.4.296-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250715130800.293690950@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0127.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b1::7) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|LV8PR10MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 32fc2e42-9a31-4ea9-17dc-08ddc463d637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?STdOYmhWSUtyRVVvLzNnNjM2ejl6bnpKN3B3SFdKUnlnY25sVjNWTU5kZEpw?=
 =?utf-8?B?YnNxNHFKdU5rWGhMR0FYRDBhTExSMlVxSXY1WGNVazJXbTFGUFYzejcxZ0VR?=
 =?utf-8?B?YzQxTkh0L254dDJER2pleXI2WGxzL0pleUxZWkkxSS82M3E4RzdQSUN2UlZG?=
 =?utf-8?B?cENjejMrdUZoS0Z6UlBlT05JQk5VRlFBbkNpcVU3c0NLQnFXeDBVSDI5YmFn?=
 =?utf-8?B?Skc3bVRIMG91Q01DT2x6K3c4SGhZMExRRWJieTBOMGVzVUZZd2pXQk1qZHJS?=
 =?utf-8?B?TTNYcjIwaFh5c2R4cWQ1MXFyVDZaSmJmY1pvWjhJRGJ2WnVZb2pyMS8rNnow?=
 =?utf-8?B?T3BmZXVWK1oyUWZ0a0Qzc1JhZUcxNDVMbWNmY1BJUUtKbWF1Szc3MVpDWGNa?=
 =?utf-8?B?VHo0VWU0NFRCcUxKNk1tYXBwcnNKYk5JVi90aCtBcmhrQ0VJVmdycVdEek5K?=
 =?utf-8?B?NEpvZndXYlVEU0NiMTRoWDROMWtLR3FsOGxmMGg5RDduL3I3RURBbHNSSTZU?=
 =?utf-8?B?NHZDd0MvQzhRbC9YS3dhcExZRVFhaWltSnVkdW9Zb2R0RVZpOVREb2ZFcFV5?=
 =?utf-8?B?UmZTMFkreHJnSktFc21KYzEvbks2b3VqZ0FhNjRjTHdqd0NZRG0rMHN3dzNl?=
 =?utf-8?B?SU5LeGlxNWVmZGRuQXVnYmhyY05BZUpPQW5oLzNiT3ErZ09rRmY2cDc2Uzdk?=
 =?utf-8?B?SUVmUHlNTG5JSDZMekRqTzJDM0R4SEc0WERpYzZjR1YrSmttRVhWNk9YYlpF?=
 =?utf-8?B?Vk95RVlIQUgxVkZkcHA2WlgvT0NFd01mOVlURnZ0QVJmRkpNU0k5YXhxQ01q?=
 =?utf-8?B?TnlaNXVxQ3BXbmg1OFFUTjNBaW14dm8vVDIyM2FVeVY3Z3pFcVpKK3liTWxj?=
 =?utf-8?B?MFRxcXdCYVhnQ0IzMWx5OGtHS08xYXE2aGtZbEd2L28xV25IY1BCSHVkZGdT?=
 =?utf-8?B?T0NNZFJsNVBUMUJjMGlkTU9Zbk1PZ0g2SWs5bWZNY1lUWDE3YWsxK1Z3UlhN?=
 =?utf-8?B?QWNKa1lmeXY5SURPV09JZjdQL1Z3Njg1U0NtRFNPMjF3TVhOd1NlRFEyc1ZV?=
 =?utf-8?B?NVVjUUs1cXlWVFlaS0t0YUdOcDhGODB6UERaSDdUM1dndG1FVzk4UEVUaGhk?=
 =?utf-8?B?RlU3c05nQ0xObEd4RDI2czZ1ZTBFNHFyQ2Y2MVZ5b1Z0aWNIYU1rdUhkNk8v?=
 =?utf-8?B?OUcwLzh3N1Vua2hUTGo1eUlBWEg0NU1hZlFrUTkrcnVncS91Wk4xbWRIK3Vv?=
 =?utf-8?B?ZGdqNWl5RDRNOEtQZVNRRUlpZ0pPcWZDOUlJdlZvcVliSC96bk1XQVJMVWdt?=
 =?utf-8?B?TVVNNTh3STQrNC91V1FPakIzM2JkaFBYdjRmVU0vOUhkMEtKZTFhQmJMYkR5?=
 =?utf-8?B?Q0NRaVVMRVR6SlQ3aFMyVEhGMGt0bFU4RzlTYVNuVStoUlJ2ZDJDYU5BbXRu?=
 =?utf-8?B?TkY4QUdrWUhQRzkxNkFiVUU1SmVKeUV6MXFNdytqVld4enJheDY0YWcyMGpK?=
 =?utf-8?B?VnI2MlFSd0hFdW9xN2lPTlY1UTZKMmI4dTJWTUZibTRBclJyakY4SnhMVUJH?=
 =?utf-8?B?OWM5ZUlQK0FLcXMvZjJsellralkrbzh2MkhOVS9vSjExaWxkUzl3OUN3N3lp?=
 =?utf-8?B?TUZXVlRDUFJwcXpReTRldGRWS1E1YnR3L2E0Zlp1R0dmMGw4ZGUrcGg5Sksy?=
 =?utf-8?B?NHJvNDVVbGJWdTNvQmFhNGRnUnZabGpRUzZ3UFRqcytaL1Z2S2Qvc3lrdmRy?=
 =?utf-8?B?amMycm13dzE1eThHOFdZcDd3MVBXVDFIdnFCVnhURUg3eEQ0YTRHUnBkcHhq?=
 =?utf-8?Q?TsxRCQZunpssxmSEA5uSr3I4BGTxXhcKPUXOM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWl5dzNnZmpmVWJHOVVkbXJpcnFGczVpQ254c3RuL2R1a2pTcHhFOHhaTG9v?=
 =?utf-8?B?dXk2SGltVGNEWHI1cnJxRFJnN29lbkVhY1FvZ2dGNlFveUdIN3d2andUTTRK?=
 =?utf-8?B?S2tCaHRQY0FnWWk4cWI1a3BzL2JqWnI5ZFV1Zml0eFNGOW4vQUJ0MVV0Y1VU?=
 =?utf-8?B?MmRmMzVnU3VUdjFlOG1qOGJRWEZOTXM2YUpEMzFJeWRRTXhkL21rQVRjOEJv?=
 =?utf-8?B?b2RuK3FXcVhXZnpzcmlRZWF4NlZMQzgwcURFUmhqekI2TlVBbWo0d1U0ZEd3?=
 =?utf-8?B?ZXU0eHBqVU9wOXR3MzFNb1pIS3pCVUNBdVJBZWN1cmVXcTFPUHpRQWU1ay9s?=
 =?utf-8?B?ZXJQbi9Ybk1GN2NRUVNId0FPWE9hRUkvdjI4cWVza2FmY0RsY2J4Umh5cndr?=
 =?utf-8?B?cHlvcEZ2dWNFYU9EN0NPOW15TG9GRno4QlFNYi9SaW96OWdOUU1IL0s3TjVP?=
 =?utf-8?B?T1k5OUZ1eis3eXpiTy90dUw3b1BCSW1adSsrMXNzaXdzNGx0blBtL0NUS1Bh?=
 =?utf-8?B?S09zOXJwbHNQWnBSYWxYdUJJQ3YyRlJqN0s2YUZjRm43K1B1V0QrVnV6OHJx?=
 =?utf-8?B?QW9RR2REOVRyVG9tRCtIUGpFVkdhWTRGMUZsczF4bVkwSnlNTWVyZWV5NU1Z?=
 =?utf-8?B?NnliNU9GZEI2QnBvUlFES0Y5Zkp4bXNweUdMY1QzdlNRbDVqUmlibytuVTZS?=
 =?utf-8?B?T3Z4Y3NFRTFyNGFNV3prU01LK3BjQnpHcjhYVVRxMDBxZEYrQmhEeDAzbUhM?=
 =?utf-8?B?Z1QzYXgwWjNSdWttMzRwcGhjT3puclFxZXZVZTlDa3BkQitqQnpaMXlDc1VZ?=
 =?utf-8?B?bzlKTlRISDgrdERMYW45cnFPUTdNK3J3TlVXd1JQd2RFRDkveTlid3lmeHFy?=
 =?utf-8?B?RzY1R3BUaGt2VVNaMUtCTHVMaHFseEVCS3NoL051VFM2WjFQQWtEN1lxUTN1?=
 =?utf-8?B?Mzk5bWNMODcxOHdVWTRFLzUzZFQ2VStaZkhHeU0zN2tVNHJzVTBFVUlWamNQ?=
 =?utf-8?B?OFc0TkJ5bytnQ0t0elNaa3pYS2djSGRtamdEeVRiajBKeWprRk9oL1BBRWhL?=
 =?utf-8?B?OFN5OVdhWHdBcDdBczRlaFc2ZlhBWlg2T3RzWnZEbEtTV2tpNzlML0xGMzBR?=
 =?utf-8?B?S3Mwa0E0QnI4OWlRN0VwR0dtNEUxVXJvNzZ2TFlzOG1NamJLaklUWkdlSEdm?=
 =?utf-8?B?djNmeWloUU1yVFVpeHdmeEJ5RHhYWlY4clN0QUV6Y3JyODNNUnJlTlE4dHZS?=
 =?utf-8?B?YUxrcS9MQmVCMWMyNEFKS0xLZVhwWnE2b2dBeGVvSnpZZlkwdWM5K01Sd3Fs?=
 =?utf-8?B?NUNwbXFHNUhUUW1hK290R1NObFl3dGpOdkd6T3dNem8wbC8rRFFzcWV4bk1x?=
 =?utf-8?B?RlNMTUtNWGVjVWNuVi9rSW9FcVJqZjY3enlmQUxJVndJeDVLZFNWNDJXNkhU?=
 =?utf-8?B?N0Z0M0U2Vm9CUDZGcnJQV1VWN1VyQXB1WDFIVDl5VVV2REFMaitVdnZ4ZTEw?=
 =?utf-8?B?czNNcS93eHpCaGUveGhORlFwWHl1QlNRRzVraW4zYzE1d1hPMTl4MjJWdlZB?=
 =?utf-8?B?WVhOMWZ1OTRSL3JsZUE0Z0t5NTdoS1V0VGVNaDJmckszU2JsRkNiT0orTUgv?=
 =?utf-8?B?UUhlYjNaaFdXU3dFRzRsWmJLREhzRXpieGJIYllkbHl0UEltaCt1Qlo2VlNz?=
 =?utf-8?B?WkZUeDkwNVZqbnpsMFl2c2xnT1BDcHpZRGxyVUNwZndnSStJZDhJNVRsWE5a?=
 =?utf-8?B?K1ppeWdNM3UvV0xRZDVTbW92MkdWVDYvMGg1ZUYxSzNCUTd5MTJFcHJTd3p3?=
 =?utf-8?B?MzAwc1hzT2FlaHc3R3UzaFdaOGRKQ3BUR3VTZGJ0MzBTYy94cml4VzR1eVJG?=
 =?utf-8?B?Y3FwL2x1MFdnKzF4NjR3ajFSSGQxZ1VJTDhIWTBxc0VxbmRrZ3hka1RscEts?=
 =?utf-8?B?YlZ4OFpoZjRpZkJUczhpSWc0SGUydVBpdXZocTFWZlhzdVg3dnRFQUJjQ3Fk?=
 =?utf-8?B?VnFzaGZReGI3U3pFYXFtL2RhL1l2VW56UGZzazlqYzFkMFZNaC9MT0VLTWFQ?=
 =?utf-8?B?SWVuVjRmMHBGN056Rkx5OVpPdDF2a2ZlMG1JV0p2ZStWRUhGaTRRZWcvbmx4?=
 =?utf-8?B?bkZCbElTYm0rTHJ4aUhMbCtXU0Rrbkd3elFYL1EzNE53V2JiN21Cb2NXZmFH?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GaWqaS5+vVbpMKjW2CQzJrmkNL0g+rIVE9muJ7hdUPv+4iA6M5I6PtyZg2fq9usUc31Yiz5GeuFK7Rq+ajKpiJ9tqkoUj06an3aKQ+N3WxgHBCrjuRnFqpty+l5RZ45EpEQpFt9bXtl6EBx+DpoGXVr4pOQxPti007fj8UvTCt2M9GuF2Xj/yLLF3qT562/8Km8zuqBnm4opfLZaSLYV+3evHYduqz4ydUqA1/+sPzzL6OyeftUP6jLrZo3vQ+WxPqtzamVCANJ4pDErHMMmz3SJ3QP+54oozgH9LlNxjIpkiwLbad2BWs4QJHMbwj3BMWLCIe7O/nSzZASatd2Vx5Dz3dZYXqcGV4T8qFwrIUSNO8TsM6wEL0SgFFLMdICRfu9MNRhVpAYjBQVPGB8yXA1gaWTz/T5s28ssFdfHh+pSSexPgCZw3wkPItbFxYcBuPMeW1ATd6NUykKQqMND/3ENCEhj46HFyCq1bOtkxYEBl5Z2uYakX1UF+b7iFyUmgEHa9b5HIQChZbWd9m8VEKWXfgedqzHmgnhtfPZu2QQAr5jlUP+/xu8yCfDw7j8A3pnNzpk4zk5EwlJ5fHFJjG5iQZ0kRxVBuJoaJ38ZSJM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32fc2e42-9a31-4ea9-17dc-08ddc463d637
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 12:25:23.2989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k598Oc47IJdOr40n8lqckhXT5o+GV1WstBX97IlP94nt3cb3oFYdR0b5NJACoDorJ7tQLUJ37Rm1QVYv7TfNpQB+MLCLqxjL5EIPY0cFmfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-16_01,2025-07-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507160111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE2MDExMSBTYWx0ZWRfX0tyJrqnuBt/s 6pR/RjTbuoX92AhWO/cs4z0LM+HMcYq8GjKyBNsthY8EM0yTxkQq5Oj9NwYH84Uh2oe/K8WCqSF esUCKk0URxs6SxBN1ulOjWdzLZPylR/jLITpHG4P5A0mQiu81+57M3xaI3g/ssZmRL2IbLtcAFh
 wPjZdveiqtFrZzmXw+5hQW+/bCyzgVgimVYKzt/4w0OAOzxCjp4GK/eTtGuCW9Oj+WE51pSkPoV mgUl3NHT0Jyf1uG5ZxcPIBaOkxoHD1T8QkJrsc1tGOOgCe965QRelygF4m6vHcC2n5ogsrFC/bk avFoWGmHdsWJlTydAuVQDIEQZrx3AFUrLFSoJrSwtFbXU3Cvt7L8b2g2XtZV6p0JMSZP1u3kWQy
 qTvMBHj6m8iAU5CmI9wex2gaYJ5QN22brtwUSVvcKkrjJJZ10rt19z3+Yl5W6RTF4eKMH1Xo
X-Proofpoint-GUID: HsbroM4GVqis9TqoKaDt7hXAFyyDI30p
X-Proofpoint-ORIG-GUID: HsbroM4GVqis9TqoKaDt7hXAFyyDI30p
X-Authority-Analysis: v=2.4 cv=J8mq7BnS c=1 sm=1 tr=0 ts=68779a3a cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=eHdr1gfFzQ-rI-q0JTYA:9 a=QEXdDO2ut3YA:10



On 7/15/2025 6:42 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.296 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.296-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> KYmQIt1MxSQ54KewmrzO5- 
> tK5d0v5cc3EJXODGzrGg8Ycifrn8i89H6yONTvKIHXONglJrSV-Y_iIItNopP9kk0xsA$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No problems were observed on x86_64 and aarch64 during our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok
