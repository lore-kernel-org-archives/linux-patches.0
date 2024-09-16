Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E5B15A84E
	for <patches@lists.linux.dev>; Mon, 16 Sep 2024 16:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726504205; cv=fail; b=j8HHfJ4/VfWMZqpJVh2S7nU0okDoQp5DqRMJMssEOpMFcVUBDMeEBoVS142mmj7EeCLVqF+NQZjc8FxslI8oqS6Zqn65WL3jivR7UNrM6aydWNW4LBPz2UWCC+cLUEW2N0QUVgbqfkopCGfsRiiT7SzhnuwHWGg3jU3dUI4Cylo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726504205; c=relaxed/simple;
	bh=mI9cr2u9gn08k+D9krSQx35da8r/0qXm42Iw9EFa11c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=otvSKxPqgpHl0wBPipa4QxVC1/hH8iRa0calMUbxvY4yVuKohqDLEfXC0iCiClHjYtiSabu7ibqZIZKu5adXTcwJGxHvTgDlSwfxJtWvO3jtJpGQ/cBnOhtI7i+/EdmrqtGGuBwh5qvsZ4U5V93kPUdbTPLzteO/VHLaKO6Tt2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=opggguOa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Peu/U5pX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="opggguOa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Peu/U5pX"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEMZ5W001107;
	Mon, 16 Sep 2024 16:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=7d+zt5RdO+FZ80AB+IU2PTgJrdzr41JgCuofElOptkM=; b=
	opggguOahKFh3u8oTPldMjfrvKI5mYNCmRIHRtdN7skOFDK3E3K54+WhlT5iHXER
	tLdiPP7CyX42xvgoXfJ2flyc1hhK8mUPYjMfvtYPd+J8Q/7o4nlpkA+vEWkKgSeZ
	fZXoHYACL4PFffRDkWWn5OJXUGFEXTXHcsKbYgY0La0pSsd4reN98ISIPSMuoKum
	rNSbEGKyw2Ozktw5KwpXUVc4tqevSHX6ZQ3tLlxDXAXmQpwtcpbyokihNxdAHZqJ
	02vGVkP0dnF4/lVzL2LZfOupNhWpS/sIEhVfG+XYQIFSwU9DBFLZBxnPNvw6i4qJ
	F+POCQehS+XhWjoT7aqohA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sfkv9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:29:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GEvL5g000341;
	Mon, 16 Sep 2024 16:29:46 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nydu3ab9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 16:29:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J+8GUuivgBa4HN0WPN/lI9tRtlSHULgEY/djqtga/NUmcgEML0BFfGCWIHXyR7HGbguV0HHdgxC1IXjJWyU8EVuJiqNBwwbi20xB60AOEt6vLmwWoRwPE/+auSX5EmHLeUX6VSx1TYi8T65KWNdVPcJNvon9b18OCQRlgElWhFXaMUMXXTjTPIF8StpatkUa4P2NNQY2KmDHD2oYNvavh3c5vP5hRelyajb/DypAFSu2P8I4xxOwl1p1/wK+ypOy0bXDa9bn+dauGVWRApjNrOdCScrWD7FocjCzCRJR43oHxLAQs20E8vgh70BZfR9kPXDrTOlGM74+PJnwyVJmuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7d+zt5RdO+FZ80AB+IU2PTgJrdzr41JgCuofElOptkM=;
 b=KDM+2jVuNL6DOXFfv7d8w5UP64Hm+aIJbc1+0pW9ULkxSL3wifn17kxD889k2kRT/7pZMwufNvdYmMYP6bSltHr56QJVi4Xsl6wRPpdXs74e20IcFpR8v7mXECFCidR7DoSOw04n/V0nPlOUA++OX4R1EUWi54VMBw2DJOh3G1eNGBXOqQWpSdBjSuAARUM0/6V5J92HQ4r6m8hztblcKBxctp9tVcQVRntbIcxx+152+Myuio2z+uayr41aq0WxkxJ47WfJD/b4X0la6S0KaqmAg+WaLoGwF8lb/F1Ge1UKVFNd5v4zR+NqnhXjvMDSqeTK0psl1DPNrKGrXonmRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7d+zt5RdO+FZ80AB+IU2PTgJrdzr41JgCuofElOptkM=;
 b=Peu/U5pXbRsDn/NF9Maai0KoEdyCd1IPmEBGCQxI1K0W3eIQaBcJOLvJ9y4qX0ODjTfUlNcyQ7B9VFBtbYVd04bbNgUvMHfjFbEYhONWiHN0tM5bquQauj0c0z0jfwo9j5W/sF+rGXAuDeQFQez2atVNyRwMgVFJLDoYfNzyByM=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SJ0PR10MB5859.namprd10.prod.outlook.com (2603:10b6:a03:3ef::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.14; Mon, 16 Sep
 2024 16:29:43 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.7982.012; Mon, 16 Sep 2024
 16:29:43 +0000
Message-ID: <fe047543-b6cc-4f9f-b478-29c8019395d0@oracle.com>
Date: Mon, 16 Sep 2024 21:59:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240916114224.509743970@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SJ0PR10MB5859:EE_
X-MS-Office365-Filtering-Correlation-Id: 14512692-34ff-463f-19b2-08dcd66cc4e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmpiWkxIQm96Z0h1bVRwZlhvM0pKd3hvRXVyMGE0dXk1RHU2RWNEbzFScW92?=
 =?utf-8?B?RTJhYmMrUXN4RytoS3Iwc1owSzRZRWVvM2hJYnYyWUVOS0lvM1FVc1FUbHR0?=
 =?utf-8?B?ODdDc0JwZzZXWkl5amtBRDBKcjQ2a1FMNVExRWJBVVNUZktoUDFZSzh2cGUr?=
 =?utf-8?B?emFHbVcvRkpTeTdWNDlTRTM1ODBSOGNUT05LamRHUFRIb29KN0MySjVkMzIw?=
 =?utf-8?B?RXQyK2xXNUpzZ0I4V2p4bE0vcWJaWG1QM01yUVUvbFlZTHhSeWJHYURSYjZh?=
 =?utf-8?B?R3lMRjNBZzBLQlkwbThISFlwUFZHeFZCUmJZd2NseXBXTWp5ZU5LaGZWY3Nm?=
 =?utf-8?B?blpvMXRvaUpDcXA5KzNZcFlFWk1TUVROOFh1cWJOa0IxK0Q0KzhEZXVRVm9n?=
 =?utf-8?B?TER2RnNxd0JSa2czdm1IQ0NEYWJEMjU4VUxJckJrM2Ryc3J5NEk0TXlqK3lq?=
 =?utf-8?B?TXFHN1dkQmdHL3ZEdXZsSlpRNldIenJ4clg3aGhrc3NGNXJYckdQWWNTbEVM?=
 =?utf-8?B?bEsvckNyU1hIVHVLL1RiNXpVdE4xVFBnU01NWVFsK296OGoyeXNGTFBKYm9q?=
 =?utf-8?B?Y25WTHdKdTFsNlVzVjJnY2ZjTVpESEFtS2pWbTh0S3J3YUZFMmp6Y2xsRGVn?=
 =?utf-8?B?Z0dESTIyck1IOVY0VlJ2a2IvbmxuYmJaZjFOZGExRlFMdTZuU2ZyeUxlVE5s?=
 =?utf-8?B?MnU4emFSWElIWndvbksrODlINm5kYnBYaFV4Z3lSeUZwMjZKVVc1b0xiajRq?=
 =?utf-8?B?QjMrbHhrUzM1bU1GZi96b0FWSmpjR0FEZWpPNm5oZmFoV1ZjREZXUXBrYXht?=
 =?utf-8?B?aFMybGw5QU5NY0JNai9ZSGdGdSt4bCs3YXU4YWdhVllUa1JPTHhIb0RQOUlW?=
 =?utf-8?B?Z1pwZXNmQWtpdUMwaE0zNkoyeVl0SDZDUStuVDJqY25YUWM2eTFBeVdSWmw5?=
 =?utf-8?B?c1VUMlgrOS9GalNTOVRxYjdvQmdOcGhiQ1U4Q1NhRXNYM0dGOHVxTkZTM1I1?=
 =?utf-8?B?MTRMakhKS2pYc3p4ZlhZR0U4MkVtcXYxRWcvbDhUeVFJeUxSMUNlY3A5U0Nu?=
 =?utf-8?B?NFVIeDJiMEwrOUllUnhDNnh5c3dxUEdvZlg1MWFqSmNmTDRob0xrWnhHL2Zr?=
 =?utf-8?B?VGo5NXlGUTNiMng2R3hvbHBSTHBGMlNMZ0lrN0dXbnc2c2NVZ2NUUFBSaGZC?=
 =?utf-8?B?QmtmaFkxYWQ5ZTRhb1d3emRTakttVHZtOHZsQnBZRERIWGhVeDNBZUNwenQ4?=
 =?utf-8?B?SlNmMGFOUGtUbndMVlRoaE8vQXlIUzNqSThRVDZRd2JlQmdZMzh0QUtXbVlI?=
 =?utf-8?B?K0hEdExMN3FTb1pPR2k3N21lY1c5d1h0VWRianFYTTUxVW5kcFFicjNtQXVa?=
 =?utf-8?B?TFh1K3ZHMTI1cUNUNWRrRi9JSWEydlBseDNUOXJ4V2pPQXg2NUVLYmNpOHRk?=
 =?utf-8?B?RmgyTXptSmdvY3ZKWlJZOGZTVEs1SlVLQ2dzY20ySVRlVkJCVGtJZzNFaXpq?=
 =?utf-8?B?VG5QTjU1TlNMNjJZQzJuNnRuejVFUnJrN0RLWDRkN0FyOVUycHhKbFFyekVC?=
 =?utf-8?B?czQ1dEhDWDdMMXR5OFZQRTR3djhqVTliNHlyMk43eUVIUThQUkJjYWxyNHRC?=
 =?utf-8?B?SlZqQTZXOWU3SzJ2TysyUWxHdHBwMlFicHNCNHdVMHRFbElyQXpSNE5GdmNJ?=
 =?utf-8?B?aFRza09lcmZ5aCtKekp4VGplTHpjbUZENWF0blpLVjh1Z0xiUXU4VzVYc3Nq?=
 =?utf-8?B?YVJ4SVdTdHJLdVFLWU94c3dvM3BSU3RDVTN6RG83NldWRVdpMWcxZXdibk82?=
 =?utf-8?B?ZEU3Rm9lUWVibWx2elAwQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1h0a0RneVBxTVBBS0FKQ3FVU2Y3dnVtNUVkYTR0b3J1Qm5Udkp3NzdTb1B4?=
 =?utf-8?B?L1g3MG5YNloyWUc1eFBJVHJZV01qaURsVm1OeS9HSXZXV2twZVRLMjdWVXE0?=
 =?utf-8?B?disrZDZpdExNU2ZvUUVsU1NDVlhJb050YUNVSWhGVEV1TVplazYrdFV3NlR3?=
 =?utf-8?B?UmE3T2lIaHovTXVRZG1XSGVhUmRsZy9kSStvek1jREgyTlZXV1cveTdtQ052?=
 =?utf-8?B?TEJ4UjNSeVNrUzVHUFlKMTFsVlArQ09WN2I5MlEyY3hQc0Q2akM1Z1dWVUFT?=
 =?utf-8?B?U05GVDZaeHBBMzFad0pZbDBsZjRkR2svTTdWZURQS0NNN3l5VXlmYjBXZVhz?=
 =?utf-8?B?bjM0L3NBYTlONG0wTHc3TXpDdkNWTEJBd3hyREVxZURiWHdUWUV4ZE5YVkdn?=
 =?utf-8?B?aFNCN3BtakExSVFBTTRmMGcrSzlvV2ZsZDlOUjNTd3hMbG5sWE9kWVlCOXpD?=
 =?utf-8?B?dldGWlJMaDVVL0NIQjJxQSs0a251dmlZWTVpZnJTZjAvNC8vZjhvMEJrMzlL?=
 =?utf-8?B?THRoeFZKdEsxYVlhSmVENW9YRHhQTE1tRVRUTWxUNGxMQW1CTXNmRXRnVGVy?=
 =?utf-8?B?RlBZQk00QXFWSFpCb2o3emFhY2dvUHdHakU2TVN5Q2llWmpReTg4Rk0wWGQz?=
 =?utf-8?B?VXlSc2Zzekd0Q0owSUgrdjNGb1J0ZlFqWDF2dlBEMm9Nd1I1eUFhLzZibFBj?=
 =?utf-8?B?Z283Y2tjclZkUytLS0pKNStWV0xtZWpKaDNqNXAxTUpVaE90Y3ROS3NJL1lZ?=
 =?utf-8?B?a25MdjF5Zy9pVTR2cWJDQkZ3YTVIQ3dkSXZER2xVRHJBckIwMWU4SndadEpC?=
 =?utf-8?B?Tlh3eXJmeCsyV1lSZlJNbjR1SExwRG9rUDduL2hIVFVZK3lGeHh5UXlWeTB0?=
 =?utf-8?B?OVlRTUEreUtxRGRqazBSSkNPa3hUaHNoQ1ZWc1ZRcEJVU2pHWitCaVJjcU5O?=
 =?utf-8?B?TFFoSGszbGtNaXdMdXYwNDV0Sm1TNzBnTXpDY2dZdExZUE8rRUYxa29VVmVU?=
 =?utf-8?B?WXRKSC9jTlp0L2lVY3BLcVk1QURkV1B4MnJHanBCd0RUTjRjRE5NR1ZtMXVH?=
 =?utf-8?B?bkZEMFNxVnV6L2J6OWF3U0dySHJYL2c1TWxyU2xJTU5qSDlhaEpvckt1WXhq?=
 =?utf-8?B?aWdZVUEyU1YyOGJrb0FqL0VJMHpiYXR5ZmlycFpGY2FNYTlkMSszbXpxd0lI?=
 =?utf-8?B?SkZHQ1hiUytaOXVMamRmQWFKUUxIMkVsZzZxOXJZc3hyY09NUnhFdXFIT0g3?=
 =?utf-8?B?SXNlTmc3SEgwcTlUOTQ1WG9QZ2x0TVBmTlNWM21wbGxZVkFUbFBGMW1VbGNF?=
 =?utf-8?B?c2F1VXBadXBxMVRCem5zdmx3RW1VN2tUVm5Fc2N0NXp3OTdlZnduOVpHbWpP?=
 =?utf-8?B?L1pVUmJjbmpWMEVXNk9TRzYvekt2LzdycDFRT3JXVUl0QWEwbkl5dXpGMzhP?=
 =?utf-8?B?U3dwdWJ6cyttTzRMMjVuOVo4aVRsZGhhRklzd0NvNjh2cmhHZlNLRlRMS1la?=
 =?utf-8?B?OTFzOVpyR0Zld25iL2lNMjVxZ2VUZEhNUW9SemMyRlRlSUR5OWFYcGROUXBz?=
 =?utf-8?B?bXE2MS8wMmxKTWNMckFnem1tUHM1Nmx0QnUvWUNCT3FjMHFmelB5eVQvcVAw?=
 =?utf-8?B?YlNLRXQvV3JRVndDZjc1NzdId09EUE5SMGplTmFrTEF3SGNIUW9xVGZ0U2ZL?=
 =?utf-8?B?YlJoWkJmTnpjMDhXWEdLVXIyaEY5djhmdFJSaDlYQkl0ZS9tVU11NGNPdkp0?=
 =?utf-8?B?Z1FpU2k5ZkZCck9pK3VkWHppTzI0SzZvZXNYVFJLQU85MHluMWErZE9sWXZo?=
 =?utf-8?B?dnVpYUNybHdQVDEvQnpWTmU5N2VVYnBTU0FjSE1KenVsbXZVRkR1NlZyVVQz?=
 =?utf-8?B?d0V0cUJ0aVJnZWdOand3cGw0QjlwSjhrMG0yTndFdXFNZE5WUkV2cVUvUE9t?=
 =?utf-8?B?UFYzTVRVNFdyRTBaWDMyL3BWM1lhWDlSK3RiYkVnOHd2NGNUZ0k1VkxjNmEy?=
 =?utf-8?B?aEJsTFNGVUcwdGFTSDR5NkdGUHE2NXRmcEovUzZlcGxmakp4ZXFoMGUrZzkx?=
 =?utf-8?B?MWhMN3Y2VE0zQlB6MG9IWUJBSmp0bXZzY0kvanRxNTV4T0pkRkJYMFZncFNo?=
 =?utf-8?B?cGw5bjBMUFdTOCt2OHJ4bmVuWm9hd0ppRld4R0t6STVEUmlIQWFCUEt3czBy?=
 =?utf-8?Q?YYODQR1wwMYN0l58RAiE238=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	reEfy4xqiuTRT+yLjgyfmyJ0SWUiFIyjenBbYS66VHnfZDiDjM/ZCz/EpXy+5T34UD/0fphWU5a5Y25Cd03zJxJAT3UxUASfeh0SK2oG93/Tb1b6joCkgZKvSnwd5C8NC9kefsc4kEthjX+efFD5oX+21i/RaOLodGIh2sKxugfL6v1DEt5bR58xAdK8L+isxcgceuD55XA7TYMqbRI4EIP2bBKk+U+YijD6MUibdygepVXDbPsbOWS5dMws02xrd25vnqlPTcBabFgsUDBTCUmQBcuaJpOaTymb3XpVsXCXUvmo3YNWqgBFZ/zJ5u+Vs6r9T4gbgtwVHgxvROoK2P5JrX8Kof10VunI/o+lhOIfas6PmLnwyUA95Eh+AdTwRoQm1cGB3dIiKvZxeN6H+MVmWbq2e9IxiKjjUzusus0RJ22K8s5++amUtbe6vyDLn8a8HZHKrmK5JNgsqRpijBmjwK6bQXJR1MaCE8bORQ8R/JMnoC9Qmm5zKrQKTNRbu6XcVw/xsk/wQ8x3ufnlOvalP99iMjuDGrNEacW1dHntIkUob9X9QpQPx73RnKutUhJrzDhV+9JMkM61hGgmWC+PX/OEDnA2DaONQnhJupU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14512692-34ff-463f-19b2-08dcd66cc4e5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 16:29:43.2529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPlPBOI2B2WIJ/lsxMotONSBYdUf1fzhUqdNKhtBnNo+ueCWBymsqtmE8LO59LMOVbPVe5xlLXUF3LeQ/JpZWTqm95ZurkD7crE2toQK2JXaLTHVSMwZDYki5HtrTtMI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5859
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_12,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409160109
X-Proofpoint-GUID: Jn4C43TYmZD3O5HbeFZxgrgpr90jco1g
X-Proofpoint-ORIG-GUID: Jn4C43TYmZD3O5HbeFZxgrgpr90jco1g

On 16/09/24 17:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.52 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too l

Hi Greg,

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
