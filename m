Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43E8321445
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756487715; cv=fail; b=NFCEElKb1FsvCSbFQ/naaG59KrpAVwif6/WSwH6C1CpXQ5PgsVHd9WzJpvUazRfRi4qTXPpZgjAkGlux4WXLMYI0W/L6K+r9DqClCa/J5OILcMolsbi3xCJmwUNF5VpZKzq5TIHoViyCOGs/aulQ6DD/GzMYVq97nUPnZfbDB/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756487715; c=relaxed/simple;
	bh=2HvQJWmzSZO3a0k7ogFCFfyGqGPeNWWFop2bGrXxmd4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j89MnINsU9O69xMG88w7ekEwNiyBjQoptafccABzaq7ln+UdhD0kb8d76869srz/0ACKYqWpFq4iXnK5+C504TTcLxxRJxDFJP3BDctLEn31VtUoekzsZYYzf7elHlXluT+ClBTIKrf+y8Co/f3edYWLCPbe5ucryRKcBTQtWdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FE0/+9jN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RPS8KyMu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FE0/+9jN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RPS8KyMu"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TGfl32016112;
	Fri, 29 Aug 2025 17:15:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2HvQJWmzSZO3a0k7ogFCFfyGqGPeNWWFop2bGrXxmd4=; b=
	FE0/+9jNRUUbTrhGSLm5CJj0rR6u/g/zY2ri8nwT/UDhSpzkF5ktfY4zBwpI+Leb
	8862QVQ2tjwDKZ4a2RyRr45lCKkyiIu2fl3Z2fQf18Ca/fdkYKrhf+/K2p8J3K87
	tGPe/WxQrsJGkVtjnF1WJG8qxVrpV4TxF7m+nG1Hs4/PNgKmrIxnH0wzdNd9kTyK
	9/rR1jgZaMmheGHguHkVYq6XJKJfT/Otsf/tPq4Avu6uP52fpspsJyMjrJvaeRR6
	bpDUVOwidO7L6ukvGD+PZYdIOijxy0RgK9734/fI49QnIoIgiPQuYFTNa1gBHoOA
	h48cmDGq1Uazm4ERvALTGw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q6792w7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 17:15:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TFgrPg026772;
	Fri, 29 Aug 2025 17:15:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d82v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 17:15:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZUi+O2DjaLkPe8sOfp3pOMHodGmITRBptVDYNYI3Q1YcovbXlXtjrNc6qOjN4V8Qi+Q4i5V2t0dKr8aertJFtSDPjvyol6W6yasw775wEbRzxaM0+YNVmKsR8MQN7r511rlP3aJDzVEJB5xI3RBdWK5q0bhQ/rGEBEdXz0ijtEqIL1WCFf+KyrMNOvV9FvM2MTlXmyNCzWsvchANxeyiVyHX2QLtsuWDjAzSEVxyDakofQQ0i3+kf06pT1AAiUFugYh0AnbpDYrktjVwyuaSOHeI8yyav/9y6CtkWMnjPpUQMcmQV9LyfyT1FiRUWxmmj8csnIjDGbFUi+KcVhshw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HvQJWmzSZO3a0k7ogFCFfyGqGPeNWWFop2bGrXxmd4=;
 b=E4s57dt4A4KJH9HieDJpAXxFJBuAG2ZNifs2Cf06v9gaOUOzGPqStY7LQL0TNFWtO2lWz8t6mdzaL11nkwrQ1U2/0gcZy/1sNNVTBgRpIROf1GgmI9+a8SIs47EHvVHmDJmupv0jF6xyMIRdT/n3bPjhpSN9eDeGqJhCEwf8uGPngTI5EsdWtGcoTUUk32q1nVjTK+pjr6prjfy8nd5qKXLiXjiFnYDYhLiOIXYO+NRuwXlyEddgPIYX7EiCDQb6+yCOJRkbUTNHlyH12A9PMZiU9xA0O+vhIJ6Cfxsih2jKg4qBMENgxZ3/FKJfR/n68bL4331iEIMt7GdMp49suw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HvQJWmzSZO3a0k7ogFCFfyGqGPeNWWFop2bGrXxmd4=;
 b=RPS8KyMuXMf+2UzHS/YS9xvfCl3IFkvUVNzOiS92i0UD32WseRts9FyGr6X7sB3BhAgex+bKCK4tg9Y8HDBIDxmuJlr7MUbBDgop/WiS+0Sa039ZYjoausH+ZmTg60ddO2rQ9eWP0rmCF2EtwagM3Mb/nmg+I9rkP/m5troglQE=
Received: from SJ5PPFCC6481C4C.namprd10.prod.outlook.com
 (2603:10b6:a0f:fc02::7cf) by CY8PR10MB6444.namprd10.prod.outlook.com
 (2603:10b6:930:60::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Fri, 29 Aug
 2025 17:15:01 +0000
Received: from SJ5PPFCC6481C4C.namprd10.prod.outlook.com
 ([fe80::5bca:baf2:503b:303]) by SJ5PPFCC6481C4C.namprd10.prod.outlook.com
 ([fe80::5bca:baf2:503b:303%5]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 17:15:00 +0000
From: Sherry Yang <sherry.yang@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "repk@triplefau.lt"
	<repk@triplefau.lt>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 098/403] Reapply "wifi: mac80211: Update skbs control
 block key in ieee80211_tx_dequeue()"
Thread-Topic: [PATCH 5.4 098/403] Reapply "wifi: mac80211: Update skbs control
 block key in ieee80211_tx_dequeue()"
Thread-Index: AQHcGG6ScJ4BAPTSbUWAAg0+3cGOnbR5CNEAgADXLAA=
Date: Fri, 29 Aug 2025 17:15:00 +0000
Message-ID: <6E63CCB8-0298-45F1-B835-B5E040CE6815@oracle.com>
References: <20250826110909.381604948@linuxfoundation.org>
 <20250828225323.725505-1-sherry.yang@oracle.com>
 <2025082931-repurpose-unfeeling-04fb@gregkh>
In-Reply-To: <2025082931-repurpose-unfeeling-04fb@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ5PPFCC6481C4C:EE_|CY8PR10MB6444:EE_
x-ms-office365-filtering-correlation-id: e62032d3-7179-4865-a00a-08dde71f9662
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZUdCaDF3dmxoMVZvNGdhRWEycVl4L0x4b0s4TUEwYldBdlpXcHpsVk54dG9Z?=
 =?utf-8?B?ZUtXNG1GUlBLN0pYTHBlQzV1UVR4aTdXbFJIUXJhSjl6OVN4TlN4MkExSUdT?=
 =?utf-8?B?SXNKL2NDL0ptMDY0cDRrczRNd0JIOWl3aXRoeTZyQ3hmWCtIZ1Z1dytmb3lQ?=
 =?utf-8?B?bGxkc084ai9nSEU5Ung1UFkvejBpbHZER0FYZ3lhRmJjeGk0OWFSOFU3ZUg4?=
 =?utf-8?B?aUZlVUhvaC90Wm1yYzZNOWVEM0E1Yk4xZUVnYzZHblI4SFhUdHJvZjdMMW1N?=
 =?utf-8?B?TWNtVkVHd20rc3NVeVRFSENpKzRnOTVINFE1b2habE5CNnJ1enBRb3ozRUJY?=
 =?utf-8?B?eTc4OEpJT1BPN0E3aWxuMm9mNkNMNFkxYVZwQjN1b2ZuNHNEcVFDN1ZQL0JT?=
 =?utf-8?B?QldYekkrZlhpaTVDS1BFRWJ5RWNIWW5oSWROR3FEcFpkZ2x2Y0g2NXdFd0tE?=
 =?utf-8?B?VkhMN20xVGpnUlVpWFlRN3pBZUppZHVpbTU4eExWRXZpNFNBZXBaazlXL3FQ?=
 =?utf-8?B?WEZ0UXYvekZUTkY5WkdxbWFmRnBFMGRXQzJxVTdhSVhKeWRHY2ZPK2NuSXNo?=
 =?utf-8?B?ZyszTWhBb3ZpWkNzbjhIZDZqVkJaUjZZU1Eyby9aVzhoWUlmRXBIby9RRkpS?=
 =?utf-8?B?ZGZGRTd3YnA1a0MyV2o0WElWbjVpc2pTMk4ySUlZRkx0cnBpa3htZVRKV1JI?=
 =?utf-8?B?TmZaK3pUcThzQjFPVmdJSmdnR2N2UktCRnhMSW91bDEvSURxTlBqNlpkVHZi?=
 =?utf-8?B?TlJjaUtZRVlCZFhWMkVsWWw5WWtLcEQzVGJjakpOREdHM2EyVUNzOUN3YU41?=
 =?utf-8?B?bzQ5Q0srYnNYVzhsSFlOa293dXlJZ1QxSTZDTDcxVkRMMmR1R3EwMDJUSmov?=
 =?utf-8?B?STY4ZDlPWG5mL29QVm4yMnhybzRORW96U3ZmOS9iR3pZYnVMTDZ5dHUrZEcy?=
 =?utf-8?B?QXE1RzRRSTZ1QW93cEtTS1dRU1NKOGI0cllUVTJhbTdtMUJ0VkZyM21hK1Fr?=
 =?utf-8?B?R0J0VnVsVkNTYlhpcHdZZm1TbTBFV1dkYm1xUGpWaWtTeDU2enFiSWhwR2wz?=
 =?utf-8?B?Q0NhRUhndiszcmY5bEZrOU1xOHJyMkFOYU9hVUVNczBIS2wwZ1M4cWhOTzlh?=
 =?utf-8?B?U0NLR0RBTjBEWXJoRnNzcEVZL09HdURvOWpTbFlIcC9HMjBMTk90RUgzQitx?=
 =?utf-8?B?eXB0VmVEcEYyVzFxNkFQdTgzMkNVT2N1QkVkZTY3RTQvYk5zeXhpcXYybElm?=
 =?utf-8?B?YXBRSlptYUUvazk1ZzA0WGRXaGY5dnpjMDR0N0lzQXJNVks1cGJEWk1YK2tw?=
 =?utf-8?B?SHk1SzgxM0t6U2pSbnJoSnFzZTJza3U2NEhudGo3RGF6bjlUOFpvVnljb21w?=
 =?utf-8?B?bmhMWW1DUEMxMDZrZHBNV2VmOEY5ZjNoWlZmdldKRjNqM3JhQ3EzUVZlTTEx?=
 =?utf-8?B?R3BHUnBKWjh1c1RwVFJQd2V3WHhkZ2MwMTNlZjFkUUxKRnJsczh0ZTdKQXF0?=
 =?utf-8?B?SEV5SXVYdkswalV3NWo5Vmw3VjV6QndDYlVnNFJwMGdEYlAvQjZoV21SeStN?=
 =?utf-8?B?ZlhaNmpHYUVvNXRnTjFUNlNMSnRKR29nOHFVQjJBNjl5ZUdtaElvR3Y5bm1U?=
 =?utf-8?B?Y3VUWlBtYUIwN3RCYktWWmo2cFI3UnBqd3FKb1ZhN1F6Q1lTb0Vvb21qQnNh?=
 =?utf-8?B?NklzYjQwRXlMSm1FQnFTUmpFeC9ZZUJpdXk4dlpiK0Q2VTNWUVBZZVhjZTBx?=
 =?utf-8?B?ZXJGUmRrZEQxSVZSaHR6VWtrZ0NQZFU2MjlzbGlwSFYzRFJ1UmNjR3dlVUUr?=
 =?utf-8?B?WkNxUVhEZzNnRk5hTHE2UEZJaE82ZUE4TzNVL3BjbWV5SXZRNEdSMS94UGlE?=
 =?utf-8?B?VDczTUFISEVibHpjclorSVU4MFEwUDRaa0ZTZGNyUHV1eXZpQkhHRytKZW1G?=
 =?utf-8?B?VUtrNGpxeVpBZzJFL2M2UHc5OTd3cW5tTXpud1FZa2lWNjZ0K3FwWXZEbUUz?=
 =?utf-8?Q?4ngn1r2e13YAXSLEShISJRtmJZlcPY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPFCC6481C4C.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TEdRUXpvMCtISjByeEd3MTY4TXlPS0MxY3FQbElmUVIwbEgrZlFIcEtZN0ZY?=
 =?utf-8?B?dEpWZzUwMUluOEJ1MTJTSUNtMTd3VlJXTmJnNks2YWQwYmZRUDhBdUYwT2tN?=
 =?utf-8?B?S01qSjRBUFhYTGk2NnF4OEF3bGlGU2txRmEyMUNiZlNRQkFERTdMMGxzbVVM?=
 =?utf-8?B?WEtoemtPK2lPOEg2eURJV3hXeWlWMXc0TU1WUjJ4aG05eEtVSUNiY1VhTWVH?=
 =?utf-8?B?alNGWElZOWpjcXd1WnBJNTMrVUU5WktNK0R1bC9YVENDMjlnWXhzTnRTTnlD?=
 =?utf-8?B?NFJFSnFFR0dnU3c0YVJKclVsVUw2Y2EzSGhNWnFiZWlJTTJUWjBVQzBOWXVO?=
 =?utf-8?B?Rmpkb3hzREx4Si84MEJsUkdEdVcvNDIxTGNTV2ZqQ1B4aytqaERQazcyOTho?=
 =?utf-8?B?ZVJONzV2Q2VmUE9NQ3JGMHZxS01Cbi9DQnFIZUR2bW9JQ3Job0dSaUJMV1NF?=
 =?utf-8?B?Nm4yVmZxMkZvN3N0NGlibTN6T2VhMENjNUlEYlo2bzhFeDdMTFBEZ2ZFeVBt?=
 =?utf-8?B?UEVlbE5id2NPZS95MWtKcTZJOVQyMXA0V01nekZhcCtlTDRRcHFTRWwyT3RG?=
 =?utf-8?B?U2Q4UUt1YVgxeWRuQ213ODhETVhwa0orcUI1TWxpR3JNN01Oc2ExNGQwWFZx?=
 =?utf-8?B?SUk5TDg1V0R1OStmSmdjN3FoS3AzeWliQUNDZ0N1emV5dkNUaGIxLzlkSDdG?=
 =?utf-8?B?bXMvSnF4cmRYOGFORWdqM3lxaXA1cms0eG9ObkhFbDJvNUFCcUpGUGtReUZy?=
 =?utf-8?B?RWkwZzFtZ0trTmJncVdOU2lzU1VVaS9GZkdXNE1OSDd0cjVSSXFNNy9PYUdM?=
 =?utf-8?B?dUlwcTBabGFTckFlTVhONFVoM2tOK1A2Y2dMZWJITFh6SjFEN2RhZjRFcTVq?=
 =?utf-8?B?Y3hJTEtWRHNGQkc0S0dsbDMreVlsa3FtVitSdXcrc1FKMnhlaFFaNmFoTzZE?=
 =?utf-8?B?TTBVNXFtRGVsa1RobnVXUDVMQVMwSjkzQndBQXJxK0RXSTJnaHRRVWpXRGE5?=
 =?utf-8?B?blExS2JwQkVZTCt0STdJbEVmMXpSanlVS1VXTmYvMzRqM25JZWZ0ZlhXS0kz?=
 =?utf-8?B?ZnVGYU81Y3BVY1hCNVc0YVc1UTJ3ellQY01vU0VDWnhNempMbzZBdlJlemlU?=
 =?utf-8?B?RFBUQlhmb2d3Ukt6ZVB4emZlSFF4Y3cwUFp3VEVpM3VQbWk0OXFzV2E1bXUy?=
 =?utf-8?B?V0lXb29RYXJpY2lCOFFtQXBNQS9aZDlNMVN1a0YyZG92a3kxQkdyY1kxR2tK?=
 =?utf-8?B?NDdtM2RXY2RxWC9tMnNMS1gyeFdrSis3THY5ekM2ZUY1aGU5WU1ZbFd1aTYx?=
 =?utf-8?B?R1pDUHRFTit2QXhoL1FZZTVHS1drbGZKdm9sV1lyc0hQVTJJaTRzcjR0dGNq?=
 =?utf-8?B?YnBhT2ZtdGJRaVhyNmUySVdKZk85TjNLcE9ySXNwQlQzVnZibS9uSnZXdVJX?=
 =?utf-8?B?T3NEV0F2Vks1UnJDOUUxczdnZkpyb0JscFM1aFRNb1VtNWZFNncyYjRYR0pR?=
 =?utf-8?B?Y2hYdzh4d29KSTdJMCt6Ky9hWk44TGlHMUYxMmx0RzJFZG9rMzQxSjVMZEVE?=
 =?utf-8?B?U0k2QlJWNlM1ZWFTNWdhcHNpekN4NzBVOU9tVGpsZjhnQVRHVjJXZktFc0w5?=
 =?utf-8?B?VDQ5RElycWxJMEdpdHp4R3dhNDlUeWhtVzNoS09UOHNkRUtvKzY0cUV3WWor?=
 =?utf-8?B?ZE9IN0RrL2ZycTJEeWJXaHlYeWtzWnhiR1F2ZVZheWU5VmxzSWFhOUozQVVy?=
 =?utf-8?B?d2NmTzMvaFpWYlhDNGNIaERJMnN0aEFweWVZN05zOEIwc3BjZ3RBUVdqZTFH?=
 =?utf-8?B?MHM1ZWxJWU5Cd1hyWWUrckJUQjl6emZUWmtXMkVTYUhvQ3U0aE1FZlNuaTBa?=
 =?utf-8?B?eERxTkszOVBqZ0piRGdJek16dG1qYVQzdWROckNnSjByQlpUdm1uSlQyemVS?=
 =?utf-8?B?U0l0UnRES3dabEtjTXNIeE1mQXVkN1FsWmZ0Y2JWSGd4cS8wcXR6RmRSZTUv?=
 =?utf-8?B?bzA2WGJjNDgwdlJqYmY2UVdmMlQyemJtbE9OeTdLQWNaT1ZrbzdMTlcrWU1x?=
 =?utf-8?B?QWo1d0NLQ1dHUHdyVmJtUDJnT3lBd3dkd01CRytOcWFoaFhybTVaYkt0a3N1?=
 =?utf-8?B?cHhwZFQwMFprT09DZUJ0SkVkK2VqbGhlanJnUlVueExIZ3RuUWk0ejNFYU05?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EC74CF49EC7C1488A3AC74304F5A0F3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D4qxdN3myApw2QJFBs07ybZoO3lbMZhdHo7cIYPi4Yh/fh+Vvo6GT5LeRSIZjk/Sbg+3JkHy/9hX7RACLjhwu+W9peLPOoq4vbE5ADUeYYBRDhwVCboutiy3Yh6tcaWGtjC6DaZiiUlZw7SrH6yw1QY5keQAo4O0t7SuX5W6/Fg3v3oYr7ieCOPsdBg2So1nfZdRH25oLrruQ5ngeuvkSlHe/ReigV0YrDSjQtXYH1qFLR1PtSidI7fOcwG3a8DWoCvRppkodVJ6JM4N2/EM7x21EKgKp9M/xQmJX1e2L9EAeBjt3GEWqp5aDNXAAfaRzYeAAlRZe/BhHjhI2FXxxPmhyp16YY7ooYWDMAUb+1ST5edfT076/VM3ktyGL8FoYqJTV5V45511M4ra76UVAld3IvC4NUMCqFf9SW/qR7d5A5QhPdUoY7z5Wpq2fB87IB0KF3Wgbjqp9b1jyuiVmdZKQAob7rvkc9l6HC6IyZzA3aljvh4vOEPoJpoLuG/5CbaQ3KIVbtJh0FKvYydTsFAKK/FGyOtDT3LhPbavy1/6YEMcrU8CICCe8AFdbw774m1jQpdI9xt5InBmcQI/WaGfiiWg67nkKrph88yvnLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPFCC6481C4C.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e62032d3-7179-4865-a00a-08dde71f9662
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 17:15:00.8928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPGcmRndfgGsa7UqaTSABOYLEbGGgDRGPN3IlQMdLka/LUbcTrlNgwDqi4brDCH2B9oakNv1eBZeNWrAkOtZog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6444
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=872 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290150
X-Proofpoint-GUID: l9GG92sv8UEz6T4bOUPowMK_aKF-0wmT
X-Proofpoint-ORIG-GUID: l9GG92sv8UEz6T4bOUPowMK_aKF-0wmT
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b1e01d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=E00tsmfOWOA53g41cNkA:9 a=QEXdDO2ut3YA:10
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX8FY/EYkPJJr7
 p5RoYYA8pcQJPahglhzC81ProsAsYj5Is3sOIt68erCJquWVLDkPX8yM3UJiNyQHODvjvivsewR
 wMFIRZkkr38fa7aCpDrvEDC3ivNzH8599pEFUpfDzqUcuHH2onlOkwoQrMcxHNttBzaCxxLt1Pc
 LPHu6R7glJ4juU2zBnLdgJrB9WarIOQlCqB85iNHE/7kjeubzH+MLbWo+6ZihNbt0yHHHVkC1do
 bKjYg+MdqFAmaVZJthdmS2H6qvoxPPHCyOo9MwVxKuy1liMytHCgfOebLcWDSzzISunmYUTLrH+
 +8sa42BMupPI8r2+m1qZ0V1fPw1ZIaRvA+La/5s/EEBWCmh1XV42a/9zGIAquB6URNWIO8oxzG1
 WIkVowZU

DQoNCj4gT24gQXVnIDI4LCAyMDI1LCBhdCA5OjI04oCvUE0sIEdyZWcgS0ggPGdyZWdraEBsaW51
eGZvdW5kYXRpb24ub3JnPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgQXVnIDI4LCAyMDI1IGF0IDAz
OjUzOjIzUE0gLTA3MDAsIFNoZXJyeSBZYW5nIHdyb3RlOg0KPj4gSGkgR3JlZywNCj4+IA0KPj4g
SSBub3RpY2VkIHRoYXQgb25seSBbUEFUQ0ggMi8yXSBmcm9tIHRoZSBzZXJpZXMNCj4+IA0KPj4g
W1BBVENIIHdpcmVsZXNzIDAvMl0gRml4IGllZWU4MDIxMV90eF9oX3NlbGVjdF9rZXkoKSBmb3Ig
ODAyLjExIGVuY2FwcyBvZmZsb2FkaW5nIFsxXQ0KPj4gDQo+PiB3YXMgYmFja3BvcnRlZCB0byA1
LjQtc3RhYmxlLCB3aGlsZSBbUEFUQ0ggMS8yXSBpcyBtaXNzaW5nLg0KPj4gDQo+PiBJdCBsb29r
cyBsaWtlIHRoZSAxc3QgcGF0Y2ggaXMgdGhlIHByZXJlcXVpc2l0ZSBwYXRjaCB0byBhcHBseSB0
aGUgMm5kIHBhdGNoLg0KPj4gDQo+PiBbMV0gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9jb3Zlci4xNzUyNzY1OTcxLmdpdC5yZXBrQHRyaXBs
ZWZhdS5sdGFfXzshIUFDV1Y1TjlNMlJWOTloUSFJVE1xVnU0UGNiekdUU2hTQ2thN1RIUFhrYXZH
dEpTRFYxNE5FTmhYclNsbnE1TlZZbTVjNDR1UXVqaFllSUoteTZvSE16Qll1VFY3cVVoLTdfRU5y
TUJzJA0KPiANCj4gV2hhdCBpcyB0aGUgZ2l0IGlkIG9mIHRoZSBwYXRjaCB5b3UgZmVlbCBpcyBt
aXNzaW5nPw0KDQo5YjA5NmFiZDU0NTQgKOKAnHdpZmk6IG1hYzgwMjExOiBDaGVjayA4MDIuMTEg
ZW5jYXBzIG9mZmxvYWRpbmcgaW4gaWVlZTgwMjExX3R4X2hfc2VsZWN0X2tleSgp4oCdKSBpbiBs
aW51eC1zdGFibGUtNS4xNS55DQoNClRoYW5rcywNClNoZXJyeQ0KDQo=
