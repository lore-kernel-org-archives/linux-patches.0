Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BF734845C
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 13:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775827773; cv=fail; b=aluDNB0TFjtg1DK7yVw9iY6LwwuZssg/LHf9V9LhafKgn4ec5V4apJCsM5aCmMpjYVHqLClh/HgFvoEWcoSbGm3L8i435waXD3u1fCbaWbpamhSIxY9xrHjP2cD1jprQ8SQEaE5zqTgjjR/9Ca2OG3zUkp/eZFEy7irlwLREgnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775827773; c=relaxed/simple;
	bh=HcvKZq95mq+J7wVc+5z1cETXF3PH8kfd/iUmlB5BjSQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MthzfP3siDTpzjDc3scnFAkIGNHaZEaiwTtpR0XH6+MUNRRSQ7tltcEXBDAibogU4rqRT8oSbK+F1fVa9x1HkW7AOXnQUaibJC6dbVUB2Ih0XjRNvGTeyML0PTjKKbfy8Df09X0Nh+1LxAgQJLKVi4Bn5uz+qAW10CuONEMQW9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X46KuWI4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vDA9b3ss; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X46KuWI4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vDA9b3ss"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A8tSL31322850;
	Fri, 10 Apr 2026 13:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YZsYCC8nw/1nICZ7KW9FseUV7SeHGxUrCtX6vbqFaGk=; b=
	X46KuWI4q+V8TJf3btmQhGqvopoxfUhMBpVCG3JIdjNWmmmjTu91YOkLqSgqXKib
	OQLpGO2AolUaSpl7FMDgbzMCevP5nGxeOsqSV7dQIQS6158IFuyVWkf9CePyEM82
	hRvVGO01VnRR0t05Ufqq+AfDoVVHra+nmdazxelaphZNv90LTtuGu2lF2NHfSo5R
	uOdqANHNg/jEwnkGsae67F7h55Ab2CsjpVZphh6fNre7qMEeQiIo4T1UCqOJmyP0
	QxnZvcW7xpjMKjA6RHLWTd2hrFzN6Vv1npgZQioqaIhrivgA4uJRKI0DOK/BMcrw
	NIckZNgA5cXQes0oHgAwVA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb9ebu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 13:29:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63AD0LCx004808;
	Fri, 10 Apr 2026 13:29:20 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010011.outbound.protection.outlook.com [52.101.201.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4deydnwjyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 13:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgnULm+eidibjgWeBXRlLcOQm9xB7qHLbe/WNIjjnakqqdOK0ZlAo+zpvUVteCCZ9TckLSFM3nhJNquXAoLL65jeKLz2z7A5zhP2PrmPv3Wv943fnWCnuLSTokmJFenbIEuGVcVYbJlc0IcJ2DOKudtFAJMPb0TEdJ2+LmIEb2OPmvrIGFQUTE+x4iOGOU0/o8TchkNDqS2wgamPy5W1DoxxD2kTdwASVfj5WYxc6uWXB0j2UdhDE8CdFyjPROil9lLRm3HBhMTu+p6HQfA+SFrRtudPQfRLR0JFPogDDoZUedxqBIxAf4e/makw4k5NVyGo9d0+vzDvk8omznN7Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZsYCC8nw/1nICZ7KW9FseUV7SeHGxUrCtX6vbqFaGk=;
 b=qYE4Ooid+waiiA62IgdnaeGmSTcjG+VOAgLpKQq/yH9bydF8voZ/OvyZUiFwCCzpko2Kmv63wyODr1XCDXxv/VV+doqYkObkFpQ3eO0FFHb/yelLKbbzhiEFj+D/7//OciZjrvIareqP4w4eVbnOA3sXtzqsLvjKC99dHIYrvhbn/4MyeQSTeQVNUDoLg8dFhcQo3KFfSUgxdJcjnTwlpqxqMGTsC+vltJGtPG+KuSZ1Tus1kj3jbsflV0zcLDUEXIzKaW0HuS4JKnOdx3i2GujegbhnTGGVAhB69CuGFe8sueCoqmrdZ2jPZHq+RdI0ss46P4bz+4AThRCPVpSzQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZsYCC8nw/1nICZ7KW9FseUV7SeHGxUrCtX6vbqFaGk=;
 b=vDA9b3ssPnnWFO50ZHAiFJ6yZi6M/eSkp9SlqTEyw5Tc5Jxw+FQDc5CZMA0MTzvlJymAlvLkd4i5AQA9LhkAnjAlssPFIUED5wIar7SA/JA/A6GUaiizKGSXOiiD5NwB7/llYNqPt+7ZXkx3SlINkqRaD9Vas0JLuJKPjFwOA9s=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Fri, 10 Apr
 2026 13:29:17 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 13:29:17 +0000
Message-ID: <3da89a45-04d6-44c7-a2d7-b832a8ffd3e1@oracle.com>
Date: Fri, 10 Apr 2026 18:59:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/241] 6.12.81-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260409091733.126574279@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260409091733.126574279@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX1P273CA0013.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:21::18) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d3d55b-3831-46b8-05e8-08de97052a25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zWKjHGOd8fgacgk7lAdlUsnGivgwKsoRJl2sch6U0WpXpTS8ZLRDpNd2A3cIRYyHmNbpaxSkck1ljUrE9QJBFvwPwHVLV1oxALOa34iIvkMOGuQvwtN7jMtk/nOyF8vqemfdpJ13rGnIMC8CVhXLMrfTb0ePkn/O6AyBpsT88MtIwPXRvdXzyk/t4U5QJUielSKDFrY/ZiaGXi6y4ycBuKPF8ET4OtfZ1O7kIXD7y+6PWbbCI/+Ky59gne1qr3QXpipIqv+k99X3b4ROUs5lUut73w7l0bRkBbmT2dHar3WcXIFdVY3Kor8rF8iTjJ/IP8ZJ2LzbMTcVWhZrJFKBRA694h+qDC1zV4xZyFhbSOXwJ60hGjz3tmLXkNhR9/HkF7ErptRmqREl1LbyBF1LEzgpz3tG1+X8FpkcJGtgk624RvXnH+6sQBVbEpHZjNedXgDDzsB0cyoTqt8aQLyeMdMB9iy9MX5pC7rZvYfTF/+fki3zJTgbrcefBp3bWq0MeakoDOlrx+lwlD4HW+38xon+SdYpMpbz0NDLSzge0rZlnnJR2jL2gbZThthbbRgYkHnsKtg3u3+z7oT1pj0wxZiHJ/wRZDJHy4lKR517Lfy67xjoRfwTZaBEZnr0zgmtgBdTr4+hth3+92h1byWvmlu9WEB8Fqzzt7pvk2jkE5yO48c16qWiOawQHy9X4x880FWcfpIc3heA584n5FvYYGmggyhGI4kS3sieCha4oYU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWl3MnpQSGNyYVExNml3TGprSW9ZdmE4U2NDTTBNbnhXRFFldzd1M1JieThi?=
 =?utf-8?B?dWtwVFNxTEVmcTJrYmgzVVM0VmQ4YWZWaFZDUUNJN0c3Y0M5NnBuYjNhWVBG?=
 =?utf-8?B?cUpISlVGc3RqVG9zRXN0ZUc5RkZkOWsxNVVhVU5zYXhIMTdPbTA4N2Yycktv?=
 =?utf-8?B?MFdRdWdYSldEdXl4aTEwZjJvM0c3YU5WZEdLeVIzajc4WVRkOGIxL3FnZGVC?=
 =?utf-8?B?UUV5K0RqSCs0cFlPU296QVhmSHh0eVF6eUpCVW01OEZKRTg4Z2VtVVVkMDN4?=
 =?utf-8?B?VUVSWWhZQUIwczVQQjdiSWZYemcvL1ZTeThxM20vZUNmQmMweFdXUjI3NkhG?=
 =?utf-8?B?Z3ZvZW9FZWkxdGxMbFVDdnZXbThJY1NqK2dCeEl3eUo3ZXozekpkT3NZSkNu?=
 =?utf-8?B?VkJveUJ1OWl6NmNqeXNvT0IxL2lZWVVjSGJFV1luQkpuSkozYzVxVmVFL3hE?=
 =?utf-8?B?eWxBMmdURXFZSDNYZzZoTXV1VkFuVXYvRzBpejVLOElFUWtPdk52Q1pLeW9m?=
 =?utf-8?B?ZjRkOG9VWFJJTFd3ZDRDaGZUczY0bS9meXFhNVJ1c3V3YW1wd2pmdkp5TWQv?=
 =?utf-8?B?Q0FSdmRCNUR0Z01kLzI2NFFnaUZIQTd0NGJnWFVGaXhsQTYwVGVHS0U3YUx1?=
 =?utf-8?B?Ry80Q2w5NndJL2NMZGpIV3lWTW14OTlDS3pJc29maXV5Q2NGR2FodHY0MlBP?=
 =?utf-8?B?eXVXVWl5MnFLaVRhUXM1aWlXSUN0K2lldkJTcW9jWHhxNHYrZGQyMVM1RXpj?=
 =?utf-8?B?RmR3T2xGYU8yaVF4aUVPN21ONGJIWWFQRzJObWs4OUJrWWhHMW00WXV1UUFx?=
 =?utf-8?B?SzNjckpKTit6T2xZbE1sQ3RUWEo5aURvYkJkWEw2SG5vV29NYkE1TDJOdDF4?=
 =?utf-8?B?ZGUyMFpreUplTGprS2JUUFB0Mk1LZEc0WVZMZ1hpT1VqYXF4OEZQYjNlZHk5?=
 =?utf-8?B?VjIvM1lOelhBSmZqVnBCT0ZqclV6M2h3U1llT3FobDcvUkhwRkJrSjlpaU41?=
 =?utf-8?B?TXVxMTIva1YzYWVtM2pRcVh2Q21ua0pQbVB2c3FsQWwrTjNYTDBvSnkyRDJV?=
 =?utf-8?B?VUxzeXpsMTlEU1N0ZFJONVIrdzcySzFCNWRnRkRSOW1kZEdQVjkrQnhUN053?=
 =?utf-8?B?emRzZHRZN1h6c2tBSGdCd21MeDhNUTVoR0ttQnJHZVJ3R1YwVDZQWEJ2OVRh?=
 =?utf-8?B?VVpsVUlYZGN2amQ4Kys0MmFkdjZMMVZsYWdyK2hobUhaMFpWdjlqUXQ5YTdm?=
 =?utf-8?B?SmhkMlZNYkp0YW84T1cxTXJrVE9OM0lvSU14WWRtWTFzdlJteWxiUUZsdXFm?=
 =?utf-8?B?RjkxbjZ0VHRLRmJpdkhjaEp4aytOWnRKZS9hSTFzMmh3dHY5UHRxanNlaTVW?=
 =?utf-8?B?VWNwSXVudzJJKzF1Qk9YUmdURXlVdjVQcm51WDBaVDRHMGliTWRqUCtnTUNJ?=
 =?utf-8?B?MDErMWF5K09JMzZQbnpUVEQxSFVXdjRQMFZaSlJmbEMzQzdyWVMzMDlwYzNl?=
 =?utf-8?B?eWlOYndSbWNQRjlTQktzMThnOG5kdmRlbC9aaUtMK3R0SU4rUmFIZWErUmlK?=
 =?utf-8?B?RUFCaHpFSTZZMXp1Ymh2djdVRFZhSkRrdTNTTktZZGFBVFN5aGczTlhqS3VS?=
 =?utf-8?B?eUY2S1l3RGQ1TTVUcEFobzZldENYalhFMnFIRmRHTUFzcXRUSUV2K0RyNnBL?=
 =?utf-8?B?ck4vQkpNRVR0MEU0ZmQzand4eTBBSGpBQ0ovN1I2QVhaekFncDFwR21YcWt1?=
 =?utf-8?B?UHVscTRMbjZ5cHFMZC8vcjlEWE5mcHU3QTRpQlh5SFN2WkpwOWFmWVU3RDVi?=
 =?utf-8?B?RnR4eWVlZVNSWklXNWl4OGY5bWh5UzhWZHppcStlVEZUUVhRM0RVcVNWTHQ1?=
 =?utf-8?B?Z2M5WUx6NXNsa3NzdXlCZ0ZnVEp1SG1SUktiN3ZNY3BjaGJSa1NTMU9IRW1X?=
 =?utf-8?B?RzdtV1ZBc0dRdkZaUkk2RmxUZWw3aGZzT1BkT2VzZnVwN3B6N09vb1NCSlF1?=
 =?utf-8?B?NWJRam02dWl6dFQ4N1k2ZDJkcmFEU20ycmtFOWxET2FCaXRkam9VbkpuOUVQ?=
 =?utf-8?B?SXMxakQ4cm1PbFdoS3RBVUpMOTJkcnUraFNkdDRCSmJEaHoxekZLRUZmU0NX?=
 =?utf-8?B?eUkyT1ZYSmM4T1FRUEtkcldwek9TVmtRS3pUeGN2ajRlZ2c5VzJrWEZkMW5t?=
 =?utf-8?B?eVpNUzdXR2pYQkNNdy9XbER0bk1saEpsbkljaDJDSG1xcDRrS0ovZ29VRnR3?=
 =?utf-8?B?QlBHclREaFc0V05ENmJBWktGOHpxSmRka3gxb2gyNWwzaFJiRVlWRWpTWTBx?=
 =?utf-8?B?SDNSVHhTR3lzUzBBTEFkdk5aUUtYblRlWmFjcmVvenZDTHNHNjRHb1ZuaGF5?=
 =?utf-8?Q?yFRd/7BMGU738W26LYU72k5lZgluw6E/Wmi3b?=
X-Exchange-RoutingPolicyChecked:
	BT4/+g9KFD1egDWwlaV4x/lPC5CtFvBu5g3N0hJBmArJP+TCJcQPYtzQZVMOgvkGj6Y6L50Se6jWBZDVHFP5seHtcxVWLLkgN7l/1FxiBY94H04TubOrQBi2dNrk0x584Iu83NdTeevIpqUp6Tq5/RwonFCrGvJnJmu3qotsEU/+afw3XzpuOZfAWiJNUkQ9e1Qk1QJI9bOt2k9RwJs0fEiuI9mY3IsFGeiz/JnGRCxEanL5/RyYv2Vd7uZJu3EgeGG+gjXDUh+uQQLH+n2Rd4UWOsS5Xgfll6CPESBXvbxeXGVZjH0q1JkXc2JYV934oYABL7el+FnA4B6srma7/A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+1hJOQGFXh+Zi3PWPgh5GqLIWa9YUBTVv14eml6JMf9qLm5+yY3QqouMI1F1V25L3ig3D7GI2g9Ptx08I15bBfjyWS8OCSGxCKDuJm3tgWBuesUEfpE39/kpDDqHNpiw9BmCGCe0EsEnSP5BLRJmVuFpAKCA4XKD8cSHLXIoxjnK4tJlBO+OUtH1OyvrMNlUE8WdQ7KQonqA/QVMFTddBQLFsBi44oQQJOwOxihzoae9zyk/vZ7VZ5Wp7Q8/OL9PC1s55/CucgXw9ki4JNTbeyNWHYvoDxtCGwvxy7kxNRfo2YPCmKjY7O8nSFRI8SZU2qvAblTWFLmoCCPTbmSJyC5TxfsjjMMr58P5VsJUfupQ8UOvhVd59+7Yqo4s9VF9nAKd69yJ3lvHf28uFVVomOc1pAoq9i9bhYUZSG7JicDfEB2QceciuEA/Dt9RAeYbJHM7GdfPSq89gIYAAlJoJ4nnilEEjfL7OW6E5MRUy3iy2eZf7u6MhYppTkDcTOnkQlXGekldBbfOHlfmY3wIozOnsQCSMFNOgdmncKVNIGstIA7UaZmlLnhVzdyiPBbuOTnpXJ13E4LkQTYCQcDl2Ra9Je29d/jxe8ncbqCgawE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d3d55b-3831-46b8-05e8-08de97052a25
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 13:29:17.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIrBjKFuqv4a8d5GsZwbzeN9uzSFqzGHWffcRYGQB8r3ArWiS7vHsc8PP37Cn6Aa969zHucbUAFeHbn4mixutmW7sKFJJ66Mj2GqOlyRf9BB8PHSLUuDOrBdY9muwmsO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604100126
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEyNSBTYWx0ZWRfXzPao1MJKC4k7
 +g+SLoiQfNdhMAI/wr7hZ7bkg1cHt1eLf8w6BIuEMaEtUUftDqO6GrLUBmZ/SDxPMuNm8znhHVy
 sOpRDRaYII/ltldAuZVlda8zvtxxtUUXqjvWaYUVTQ8Cv/AzSwbTh+GTwlTKJdHu8yvOWFMARkb
 LuXNiXw2raw0MbXKrJDl//OIfEC1BqGpIExFw0qPzgPRrLQl8d/2PFosV2ne2Ltp5LVowqqIQ2q
 iLz4HN8aIGpLeLupLfJuQBpqvM5IBoYsK6YSHT4DG//6lRl3WsYY78NvsZymw8RcEre2A5lgdkD
 LEO6XgQ8Ut64UvD8MqT5tzmEY82PTctBC5sqDe0PQctTB8EYc5hvqjAgAWm1EZrNd8bSR38IZnX
 z3Ipo8jA4G56nLZ1W8h+vNQVSwJ9VnD2GkuqUkou+uq35KENAewRuCgoDHBsHf3fRDL869hNzVY
 p+/+t057YhJhHJsjLWA==
X-Proofpoint-ORIG-GUID: r-CiekuMo8aKKD5kAdgjGg1Y6T4N2dsS
X-Proofpoint-GUID: r-CiekuMo8aKKD5kAdgjGg1Y6T4N2dsS
X-Authority-Analysis: v=2.4 cv=cK7QdFeN c=1 sm=1 tr=0 ts=69d8fb31 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=cKehCjhk2IfrQodDBDEA:9 a=QEXdDO2ut3YA:10

Hi Greg,

On 09/04/26 14:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 11 Apr 2026 09:16:49 +0000.
> Anything received after that time might be too late.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
