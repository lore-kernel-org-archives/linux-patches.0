Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F23717FAB1
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027184; cv=fail; b=NLmBdvoJsKXWlyilAqVfrDHg6aS2Or83Ni8jmM7yi3sLbT1DuRqCFcLzATtnGlsaxTYI98X3Uy/sjye990aeGe3qyyM5XxLXCm1ReYTIby4QVFVgNLCqTq8M9CjdUqm+8wMj4sGAB0h8qHyvIUEdoqjXb9o3FJsfLgo68Xw7kCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027184; c=relaxed/simple;
	bh=S1sNKNS7hL0NbrctEwazVKlJCTuMOFh7YTEQYo2/6Ow=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eTSwYt45+bQI20pvZsAHjrPK1FZKSNZb/n+MGpl1e4Ky5h4z2g25GmVIR5MWyXLdoDASd8CDiSB8QM5KIqiu//e7BC+0/V11M+zaYdw/aXyxmFz3G9JHT0XisfhCE0kQQWcTobzu8XhUytPwrEcVSxo83qKLA8bHm1dvTNjrHS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aztbAntS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lVS6f4pN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aztbAntS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lVS6f4pN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463FMVl2025164;
	Wed, 3 Jul 2024 17:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=AZvjq+0jg4xBXYDGSMQVpv08gO9M0oCbWU9kgSrGGE8=; b=
	aztbAntS/3Vm/4hdLxyH9MI4UqB9zq3dLWlhg4gNiE0Q4rmMcr+xXuHXan2X0kDr
	aNrDQHPOtLWY9Du1nBtg2cETaeQB7OVehGTLhDMVwP76CMZPGSduoudjB2/xVpbw
	hAg1N7TCG35HGFsu8y+NrUY1PLfpc81CrsqCNcrU1LFyCJwOhFBWUzBJLt+wtnIX
	1t9ez1jm9ZFU0BOnrpcmF/XREE/u7m8NgnfI86JEb6f4cSx/mrxPG4EkkhfZ83x7
	Bvi6wPjIFpQM/pKVlTWK3D9Avq9OkxJ040v3J+XHDm1pesUvz/fXMH/8uHtjoiMv
	n8UKlybnG2mV/PJMEvRWZQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4028v0rr84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:19:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 463H4mXe024789;
	Wed, 3 Jul 2024 17:19:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028q9tkjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:19:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQR0V6PAwOAWj4bRIOotECtYi8CZYIDkaJGwgZvqE3geDAwdWZoxlSlaXD62BXKcaLI+OvvDWQbcu6kJ0nFfAFDhSXpRvj39GQh2+SAdyU5EyoLGfacNb+uw1ZPmJgyeDZbK6VfTrSvsiStjuP3pQMDiXg128js/k13rstt+9+OJNnMBqZRT+lyEwX8qFKueazJ4fZQvj77Ay20hGrk3rcgz/4BQ8xfvgrqN0/D0XeGWAH5aEXC1yD0d7eo5XtnURaVS9hBajWmDzewxku/OlpDvQJJ11PMWDI5YigqT25LA1JONW7t/fu75xcEMML9YbLxKQOf/fhXEt7ecZzoE1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZvjq+0jg4xBXYDGSMQVpv08gO9M0oCbWU9kgSrGGE8=;
 b=TZPhJMI/Il3ow553oy/Dksf3J/fMt/UyCKMFZ4NhtYOeSjoIWoz/ZbykAfQ+igL5cTQSXKCpU617RRNCoavIpxOj2kiecyxVBMSLwgKbPs7rM3rmStuFTVE5at7L7fIQQqFTNggoWJZSRYStA5KvuHyLf9h02b6u8EKk664JGV3gEo2xK+07xveMDxPzjwH7CnAF2wRCQBtd9pnpN3epdBosMa6OvpzGpMBpjO2+xz03xhq7Ar9Uh5bLPQlyPkIIF81MtAuigfiGj/7JMZgNwk4JUpaziEV7MHGjKqbWfbn5xjsYHgieSK8jHH1XVVwZ08gpTD+aRaAlzuh8c72hHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZvjq+0jg4xBXYDGSMQVpv08gO9M0oCbWU9kgSrGGE8=;
 b=lVS6f4pNociy/szRAbl+wN7IBMd1QgkW70lk994ghO7TGNR6wQ5JUkJujf/3Y0CKCgST1QaG/NimHQDA8UtyxMIGg+B0jO9PA93DoxtwT1l+EA+AN6J/hfYDom0GQqwpKPM/Fcql2zWQaJOnEKN9sIP5OIIx67lgvTAm6ZW8IO0=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CY5PR10MB5913.namprd10.prod.outlook.com (2603:10b6:930:2f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Wed, 3 Jul
 2024 17:19:25 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7698.025; Wed, 3 Jul 2024
 17:19:25 +0000
Message-ID: <a7933650-edfa-4d73-be04-65d7c46993ab@oracle.com>
Date: Wed, 3 Jul 2024 22:49:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240703102841.492044697@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::14) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CY5PR10MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: ba971631-4bdc-44e5-0c3d-08dc9b8449aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?STlCNmRSR25HY0ZYcEF1am5FeVFRaHh2OFNQbUIyNmlMZ3hyYTJnVlZIQUdv?=
 =?utf-8?B?MGsxRyt1Snl4L1hJVm8wSnFhUzBhUDZoVCtnSlJKeEl0a3E0aVdjblgrZnhY?=
 =?utf-8?B?cWZmU2s1V01PU21ab3kwYmhYZk9QWnNhNUFFeEtNSm9sU25ZMU1iZXpDaEhy?=
 =?utf-8?B?SHNqaVRCZm5TOGd1dm5wSHhWSmM4QjRvaDd1TWw2TzNDOXY2S3hlR3hmTENH?=
 =?utf-8?B?TW45R3ZtNGRHSzE0clFrUFlidXNQSTJuMldndGNHcVgwZ2J1WnNjb2JhUm0y?=
 =?utf-8?B?MElNVHZETnRFS0Q2Vkpud2h0N1VjVVhPVkV1UjJOTVZRUWQzOGhvOS83K0cz?=
 =?utf-8?B?VmlqbVVUbnVXM1lINnVkOE5QS1U3dHliQzlTWnhOZ2ROd04vNkE3QWNDMVBQ?=
 =?utf-8?B?UENFN01ncFVDSW9SQW9xcEVpQXVRTEd0YktZV3pxZDdqeWZ3dVc5TDkxNm55?=
 =?utf-8?B?VU9rNG5nRkZmQ0YrTTF2RW45RHdVNm4vbm9Ec2EzUzEvOHdsVU9TblYyOUVz?=
 =?utf-8?B?MWtFN01CYlZwdDJPT01LUEVXQmkzdnptSURXUDkybWFLclN2MkcwM3k0bmEv?=
 =?utf-8?B?TXgwRkkvaitpci8zSHZLQ3RSNk13S1VvWDZ5WVZMWmdSWkpyc296LzRlZmVn?=
 =?utf-8?B?RmhkL09TTjREcGFvOWh5aWdYbXY0N2FVUTJvWjlPT2V5ZHBWbjNacjBJSlYz?=
 =?utf-8?B?cjJKS3g1TWVpblFVbmN2UG5qQlRnSHAxZ3Vta2VLTzdONzNPdXAzRU11QzRZ?=
 =?utf-8?B?eGZ4Zm1SS0RoZGRUQjA3dFlYdDY1a2tkRG1JY1Nvdk5Oc0daL3JySXdhV0JT?=
 =?utf-8?B?WDlQbGJNUERteHJQdHI5T0pEUUthYkIyQmIxZHV4WVBQeUVkcTVacjAyZEFJ?=
 =?utf-8?B?WTI4bDlvbmFYZytSSi8zYTNlamN5OTJjd1BiVFp4Y0hEZDJqM1BBSFIwNWdl?=
 =?utf-8?B?UVBNbmhEY0NobFhLSGZ4OFdYR3pWSC9CeUxTa2xWbElOSDJCS0czUTZDdjg0?=
 =?utf-8?B?WUplYUwzQm5hNVRzZ0VmMHlRZjNTSWFPcUkzOUtwTmJVeDVGUlNEUjVZOWlC?=
 =?utf-8?B?djM5WTVod2dyblJ2dVEweEpOWnNnNjNITk9DWGNNaWl5blp0cjMwYjZJUWtP?=
 =?utf-8?B?NFlmM0dBQ2R0VWYwVFAwSjJFOFVVcVpMV2lJOFJSN0x6K0kwTkVhdnhJTlNx?=
 =?utf-8?B?Wk5ZQTllR2dPZlR2NGhGQWpmbnZlV2VtbUZQYjZlREFOSjFYYzJ2eno5eTd2?=
 =?utf-8?B?VjF6U1h3dFEvdUM3dWdlcXlIWnFJdnZkb2F0ditkY1ZFU0szeEF3YnNscERG?=
 =?utf-8?B?TkJVdmhjalUwTDh0V014TzhuaCtYUExacW9WZFNUUWdUd0wrcHI1Q2NKcFkw?=
 =?utf-8?B?ampPeXhPdnNHLzQyTkRLS0I2MTQ4NjlvbmwrbXJ2bmYxVzBoWXR2NHdvTDFz?=
 =?utf-8?B?WXF6OWFHQ2syQmhvejBQeXVKekZqOXd3aDQ3TndjYUN0Q1FNSmQrcHdTOFo1?=
 =?utf-8?B?akR0ZHJBWDkxOXAzcWpkUWNMMG1ITlFMU0JFcDFmeVM5VVNJUTdNZ0t3WERG?=
 =?utf-8?B?ZFpOVTRQcEErK3ZFVXFqelRlR0E4dHgrZWxEZTRKWmVLemRDL1YvQzJDcW5V?=
 =?utf-8?B?b2pENUU2MCtHR1lvcC9NZXdXeEhBN1VmZ2RybUhMa3pyTVI2c1hLNXVxbEpi?=
 =?utf-8?B?Tng2R01zK2VPR3RRL0Z4M2pxQXFkcVNYcDhSOGR0RGFPblUxeUhwWjY1N0x5?=
 =?utf-8?Q?xBrNS5aq/uJBtDeve8=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZzAreXFXNU54dXhkZ3YzRnVIV0Jhdy9JWHE3MWtZMEJhUksyTHYzNEhBZnpk?=
 =?utf-8?B?UlpkbHI4MzZvM1NPVVBsRzB3SlBvZDN4Snd2cWxUQXBFbWJJbVMwVWwyNWVY?=
 =?utf-8?B?YVBpUHc5Y1JqeDREaUN5MG5BN2MwK2JXbWxLQ0tyT01zOFpjMFRHSlB2amxL?=
 =?utf-8?B?NzZjbHdtQmFpSjJwTVdPZ1JjTDRIRXR0YmorSXhJSm1IU0haSUpNb2kwZnNp?=
 =?utf-8?B?MUZscldlVEVNY2hMQk80RGE4cEVEa0htTFlNSFZBVzdnVDZJUDRNOEdIbWF5?=
 =?utf-8?B?Slk5TkJIZGc0N3gvN0JzRUcvSDlHclUwd3VLczV6a2FqNFFlZkxZSWdITld2?=
 =?utf-8?B?Y1JBN3poVkwzMCtoMWIyNG9lMmxlZlJqdkFmY0EzenprT1h2YjhVb2E0N0F2?=
 =?utf-8?B?aC9KWEpzRmNDcmZqL3FqalM2U0pxYTliQlBKQWlPQk5mQldteUtEOGl5dVNh?=
 =?utf-8?B?TTJOdTFIQVNVU0R1U2RteXpDY2N3clVmR3dyNUI5Q094NHBCOFAwOXlIbXNU?=
 =?utf-8?B?MFNPQk1NOEl1NDNTR2gyakZ5SmNWcEM0dnVQYWlqUVB1b3ZlWG1PdVlBWHNK?=
 =?utf-8?B?cVJQUTExbEhHUklhUnp5MHRhZjJiWWNQOGxRRUlBSVJuVEI3K3cxdVBtYW5S?=
 =?utf-8?B?ZWpLM2pld0orcWFJczZ1MWJnRFR1d1hHK0hUNE1WSzNBU2dGRWdJQzdKTXdn?=
 =?utf-8?B?a0FxL0tnVFNKZFQ3QVRWMG5Ed3YrTnp2UjR0akplWUs3MXhwOWQ1dGVLNHhu?=
 =?utf-8?B?ZXB0ZjdnVzhpYW1ZeFFHcEExMUVVdllRdGRZVWFmemxNS0s1TUlmaDRsUGZF?=
 =?utf-8?B?VHdMMUpRRGN6eGlFNUQzTTB3cnIvdzYrclYvRnVNTExZOWE1aStZMjVkVnQz?=
 =?utf-8?B?eGNWcE83S0swZGpFRUZnS0NQaytaU2Exd2Q3cWM4ODdxdXlBVkZ2dFcyUGI0?=
 =?utf-8?B?b1RwenhkN283d1dzSEJqOGg4aHpDM1dyYXNvZEtCQklrZ2hHYjZYc3BjUzBi?=
 =?utf-8?B?SEpaNzM2ZVQyZEYwaytUT2EyRUxjcDQ3V0EyRkZlVzRqVk53ZUJHa1hiaExy?=
 =?utf-8?B?OU5KMUlBeVppRHVWVFJOc0lXN1JScWlKdFJId1V5Z3NQYTZGR0RXcExFM0x0?=
 =?utf-8?B?S3Z5MDBlMFlzZGlsbHA2R3RTY2lSQTU1aklhd2F1MDFDT21VbmpVSWsvSmFa?=
 =?utf-8?B?OHJGSUptckkzQ2ZJeVp5RG9CQ0xjTFFyWTNHYXRtZDNpeGJKSlJTMVc3L0dQ?=
 =?utf-8?B?SlpBc05neThmcGZ3WlpuZFBQMFV0S1FEaVdleXVHU21yYm84YmtEVEhpSkV4?=
 =?utf-8?B?QWdjV0MrN2RuRWtoWUVPL1FLWHhEaUdJY2pmV29WOXJ5MDhTUUpHZFQ1ZXhl?=
 =?utf-8?B?T2ZDNTNuMUNuc0FENW9OS0tFaU0yeDlnaU1JMmZYRWorNGdHZlBycldVcWUz?=
 =?utf-8?B?RWw1aHRGWkJjRFhSejZnZDR6cUxhZmQ5QjB1YUpGRGNJeGZ2VGorQUI2UnFY?=
 =?utf-8?B?VGxzbVd4UUovNmE2eTdYZGczdTBkeWVPK3dQZnJ4QWcrb2JBWU1Sa1IzelJZ?=
 =?utf-8?B?eFF1YkNsYVpNNVl5R3BBV0lZZm9hWnZjSWFQaGVNMEdVdnRHWlNQaU5uYkZF?=
 =?utf-8?B?TW1CbndZUEF2bktCUllNdFMrTDlROUxScThYbk1sWjE4TENtMXMxK2tLa3Zi?=
 =?utf-8?B?ZFVlcWE1eHoxa2hKdUozUlRzZzVRejVIRWdpbVB1RkZDQ0FHK1FaaUhQSktz?=
 =?utf-8?B?QkxuTjE2R09qd0dDd2dhWUNSTHlFWVFoMUU1cWxMRjB3dHVzMEtEQ2FYY25t?=
 =?utf-8?B?bkkrYmRSOGx2Rnc0Vis0azB6cEh2ZTczOGt0dnhaNnNlL3ZmMWhZTkV6Nm5H?=
 =?utf-8?B?d3UzTnZXSmJwSUZDNE5FWTVXenhDcklUYXRES0VhRzV3UVZQTmxaZ2gwYzda?=
 =?utf-8?B?RTR2VEptUkZxR3Q1bXoyUUtSZW9uaENTTG5scFkxa3U1ekE4Y3BWQnVXWlBY?=
 =?utf-8?B?QmxPMFhySmFjL1F0OCtEWFZCRVI3ejZiZllkd0daYThadUl1REIzajBLeHhY?=
 =?utf-8?B?aGdxR3ZOSSs2UXM4YTlzR1NCT25hQUJkcnltSmk5dVNKYmd6SWI0L0FDNWl3?=
 =?utf-8?B?cXZxUmQzVitBc3NQa3ZBWURIWVIzcmtNdkFwZU1UcFNtaUh6SzYwMGdNTEpR?=
 =?utf-8?Q?KRu/UstcjBULDQIPrJZKC/c=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tToOfyLHkEqESOd/4NEg/quyJQMruYEVXlYc6YkjR4j64NRUjkofmXiv2EDHbvY2hDPtQyFZHYdg1vCilL+iFDl4qpYaeXtsu3FYiyoTqjrrNQgtxbMO550OJRHdwU4Zn1+wcGaX6Sh0IeiuFG3KrweyGrN5DVdz3tXJz2K1WJXbahydx1HWjRNe38TNq6mQmtr6ffettf7XkFHd4lMTfRlaa3ABLbZ4MnAy1XwllJz5LLVEeadXgEDWnI3lbAiiFQpw/so/Z5eQyPhvq/ahTNq3/ecDi+09VRgtkzKd/QJdBNBtWWxQX8hdw6A2bwjg4BmS8fP/GLQlS0S0q+dbiY/AXRwRakVy0iLUcLaXynAhaWW3v/vEgj4xegMFjkMIzOipJ0BVeho5LEGJjreHOrT7Th8P1VfjMkpSukP4mc9az/cdF+2Zt6jp1tnLXSlNF8eKXSMxYg7a8MbsnN0/yKZea579fLG3Js/9lLwbwdF2wiMDKdD+HrYOL/GPdCA6uncWdjiNZ5Iw5VSfktr40xOO2Xr2EKO1UBHwcYbNimbE2Bd6RG1hI5IhrXmUMOCZP87zGN7nvfMGTmBA31LE9I9uHH9AO4sGy3alvMGQINI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba971631-4bdc-44e5-0c3d-08dc9b8449aa
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 17:19:25.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5BLq6iEWoTaRgnOX49YRr1Bz8jfxzJ4R7Q2658MCmtTrd8kzRqC8rPyygyVYDo/QU1emN3H/seV0E1bVNPb9Q8OzQeMofCt59qtRc89XkFpT729Y4QmYwYZut7Lmdh6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_12,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407030129
X-Proofpoint-ORIG-GUID: oB2FmYZyK1IeA39cEkbHYPHly0IYZLxg
X-Proofpoint-GUID: oB2FmYZyK1IeA39cEkbHYPHly0IYZLxg

On 03/07/24 16:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.279 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:06 +0000.
> Anything received after that time might be too late.
> 

Hi Greg,


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.279-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
