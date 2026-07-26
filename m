Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D4D3BBFAD;
	Sun, 26 Jul 2026 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079367; cv=fail; b=HdPPOXeUDlcOPidR5txt+Y2Mhef5IyjPabroLO8E+gsJASIRqcyK9fzIP267y9nRdO/0+DvAamGJhT6/YRlKMR1n5aHSqJWF1LKzrzhLgLV/DqrGwQne/nrPB8mJ9YUsGmDmkaJ6fsEBVyxu+NVd+m3bv+piaHXWKxPWbFOtbd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079367; c=relaxed/simple;
	bh=5Qjp7dBSaRacTLmujLy2wb7TAok0H/9+Qs+fyhycA3Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uPSvkaesi3/fOCCaKumFu3Ht3oCk9iJcovIIjecRrW6tIZOnqk2GfosQPIsKw1sUp+fD3vB+6R5J9Ty2Ui5/ioEgwbg39J1gk0iC0NFx+fLWu9kcVBgWBl2AGrXwJ4R70FRGmDgnfn4aCq+f6DC2NUPSF7c/zMMC6TZighSX6HM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fF+s7m/E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ID65d6EG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fF+s7m/E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ID65d6EG"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QEU2gU4079155;
	Sun, 26 Jul 2026 15:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7G0TN2ADfy1rmYeIe4GmdgcNV1UwFvsUjY2wYjH0cE8=; b=
	fF+s7m/EQXS6lBm6aaGZ7OS51OCwx9TDDLKLffX15E5yMBixMhpxEcKf4/OJScVv
	v92+ZOMO3Vw6pdBTAQSCV7zmdUQHnTyBO7iQxf+tERjra0KN1FYzRv4p9HusmT+a
	TtjOPNL9yeTzSfEfF2jCOFyC7nPYcAo95V70aDPHxIiSi32GWPslQNWuRhfhPRZ4
	ckQfUvyFqEa36/KRYZ8iQPBFPYcPU9owLpdKX6DPNxMkbLDoklLvdvT+46bM5e+8
	+a8USokq09ui3XZtrdrEESy9VGXWr19/ZIgI7+bom+kxYk/NT4j+0YuNv21OWExi
	p0n2X1HeWGfxbwynV0I1VQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym0tkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 15:22:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QFKOVG039057;
	Sun, 26 Jul 2026 15:22:40 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012021.outbound.protection.outlook.com [40.107.209.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6mk2de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 15:22:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTu360ImEXV/SfX3e81YdPdAS/wOqXEND1eHMhWML6VbuXmGqvSg9XBssp7KO35GN3U8kMWtMAFEMA35GP+ozyAVet3zCkitCFq9e+SefIfYxmt5ncjkz2KgJ5BW2OKytlyp9eD8/Epmkm63wLEKHF84m6U1n8LYCtvtU76rEqzEQVl07d0J5VH/LmXLAhJeUbYFvTw1SSvQIc+qI1Hn/AJDI0f7kyCCe3WVJNzpNmhM882bkCiOBC+X0+kZGQwgxk092FSt33uWrIG8/hh9WlRUxJj9di5LdkvUwdRWbXoVWRi6bflkKuhSsRtNxBSQX0mj5IsRGtDeBVa4HeLztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7G0TN2ADfy1rmYeIe4GmdgcNV1UwFvsUjY2wYjH0cE8=;
 b=G3ea5wPeTFdnV2bLzI+hGBTFCzvZJhtbKeygfbnmmrCnKr3kHhilol8RmKCD+0IV0Tm/b+g3hiw27tYJxjEfCyAJp/N4DakAo5K9T8nCDrphTEfo0OYyZb/udYfnRpp401xdjbJQKbwXL9x+kx7TxGGV9x5OlXD04e5YNMFruChLprr+G16FVqeBFJl0TF3NAvgTgrieXBn7IkAyq4+eIBxTG5/FPWOitkLIa0H0aoIsKOLUmuvl3RwFk9SIdVYSFA4NFJqYjIxMMWTgMvRIDwzrlqJXBigX2jmjtoYmGF5COL1SWZWBm7292spD+RV4/7wz9dhspChhMOsmYGD70w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7G0TN2ADfy1rmYeIe4GmdgcNV1UwFvsUjY2wYjH0cE8=;
 b=ID65d6EGxghtnjWm7fS+jnG/WrAw4LK3Q3x+JAyg4CZsVBAkRMLq5CR33cFKZqjlRp0s9V5iLG6CSIF+Ie5CF1q+qr8h0KiMcNLDHV1QmTPOZeqYKZxlP4/9RaADI5mWH9saz1TWrGGL9mR3pn4hR0wT2hA2BeZ8JwZmShnMGxk=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA6PR10MB997657.namprd10.prod.outlook.com (2603:10b6:208:5df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 15:22:38 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Sun, 26 Jul 2026
 15:22:38 +0000
Message-ID: <fc7c7dc1-8bba-4142-b326-3094ffbda5b6@oracle.com>
Date: Sun, 26 Jul 2026 20:52:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0508/1276] xprtrdma: Document and assert
 reply-handler invariants
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <anna.schumaker@hammerspace.com>,
        vegard.nossum@oracle.com
References: <d2f4dd54-6741-416c-ac81-62f99833490a@oracle.com>
 <20260725192000.stable-0006@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260725192000.stable-0006@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0080.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::22) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA6PR10MB997657:EE_
X-MS-Office365-Filtering-Correlation-Id: facdb506-0982-4bff-9ea1-08deeb29ba02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+3InqxwDc8fQ1udaZvuLL5Bj4URZcCx+ihwB2AjuuOCc6cTLHy5G/vRAVEjGk4o45rVuRmFLKAY9Qbzc68JogU17rJcKy5EWJ/1TO1kcZ+djLAA3U10zXOFLW3ck/Fltbxlq+5v2CV+ENqhEMGPmfLjrPDIBkISr4wwLa25u/QiVXqPoSzzblvPMK489+uFkCnN/rmgJJo45bOEDh0CK2w0kruNVeamCiFcHO9FVVfZPVazPG6C98oqDpIKdbXie54ATfgDGiBGEykaDo0RsEX9a2G9NYdOp1UZRhEwvcTeQs06/9A1fzzm7AGkbxw1s8GFWghQU4Z2BG+ccByx3aKMfJ9ybN40cnhlOugUvmbrXBh01Epm/zwI5l4kkpJ0tbGa5wHMBWbuhZCwnKI1YYfIdqFOekZZwzoZ6gQC3rT6nqVQaLXuqe1XZkk5ya5IaJMolLs5Jy9BAPEIcuVqim59t/AdqXUfqXGXxt1lbB/+X2nlTVYzaXfBE1014AI437O0CqHMo8sD0PQBmyW8WlvoRjmnHE8OLkFrTQ10Tkw27pwivuT+subuq4hzLnpJMs2AbZHO3iuOC7JIvpVTZY+FkLD6+yXmabymJVmAqPEAEUBBAmCHygru0b1yDrJAeqhjxXIZReZolQfcl2WWX0Y0DQ6AD2Ej7VAK5Cfl4r3I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTR2VmlCK2lnRUttT29lQ0tLRzFXOVVrbkRpUVljMWU2U3VyNERFVlQrQm12?=
 =?utf-8?B?bmZtKzZzYlpkaUVvWS92Yk1aWUMyQ3oxN1RCdFNYdHlubTdWWUNUVnd1bkcr?=
 =?utf-8?B?YlY0YXdweGFrVEZiSVZFQnFDNWt4R0NEUWpKb1QzSEJxV1JxSkl0eHF5MUFU?=
 =?utf-8?B?WjZ4Wk90UlB5Vyt2Y3RtR0lTZG5vNzlFTGIzaFp3ajI2bmphZ3FMeWJpeHNv?=
 =?utf-8?B?ZmxWMjZKQ3BNYmpRUmM0aUtVM1hsMUhxZUx4S0RmSDBSOTl1ZkpaR3c2VU9T?=
 =?utf-8?B?djhzdktzYWR3a0ViQWRTRUVCRVZpQzRZTFZJeml2YzBPVnpCTnlsaVlRMDAz?=
 =?utf-8?B?UGU0MUt2Vm5WTVBvVWd3RzJlUmJwMUtaS3hVQ2l1WkVjRThIMXlCZitna0Q1?=
 =?utf-8?B?TnNUSnhrcWdxUFdIVEdiR0g1dnIwNm1nbTFjM0EwQVlVT3pyTlYyTWRtZS92?=
 =?utf-8?B?dmliSDVuYzJhU1poT2ZlNTBoUXVnMnF4NTF1NnJmbGkzYTFVQmdUanUydmhx?=
 =?utf-8?B?REFtaG9nU0U0TzIwMWE3OEN4T2IrV2RQdU1TM3hrYTgvd1hkdFh4azF3djEx?=
 =?utf-8?B?V25jNmF3Vko0ZFcyR3NyY2hGMm12OWxyc2R2QURGc1h6QXQyNHI1L0hkTm1Z?=
 =?utf-8?B?UjBpbGJtR3MwYm1PZG5zaW9nZ2VxMFNTcDFhSHpNSnR1V3l2WUxXMUprTTJq?=
 =?utf-8?B?TnZBckJYZFAwNnM5N1k5RXg2S0RzdVpiTUN4QzN1SjRXdlIyQmovand5Z0g3?=
 =?utf-8?B?WE13aU1qbElsa3k1SVlxZ3doUTN4WHdCNnh2ZjBCbDVmZG85Y0JuWUx2ckpN?=
 =?utf-8?B?MkdvbkRGOVVoZmpVRUNIYUFSZDYzRTY0Q1hpdG1xL2JSMUZOY0dKdkxWZ0ha?=
 =?utf-8?B?NzdtTko3MDh2ck85VUhyd1JEZ3ozSW9VM1ordnhzWFphYmJTNWpDQUlSRHVh?=
 =?utf-8?B?VXczNC9WbnY5dTJDb3JrQ1RoRmxrdDZhaHUzM3U1UmFZQnd3SEJKR0FOYUQ0?=
 =?utf-8?B?dVdMVmUxdDl2OGI2Y3FwSGk4blJOVnFybzI4aWJNeDV5RHZaRUlmRitXL1Qw?=
 =?utf-8?B?YXhjNWdBQ0VLSnA0UnpBTERVUVg0bUllWldReGxJczVlT0F0MDN3OEJ2c2ZC?=
 =?utf-8?B?cmJqKzhoY0w1dnROR2ZCQmZoczMyOGhhVGVDRHNSUzFxSHJCU0VRYU4yV0dC?=
 =?utf-8?B?cmVlM3puR0xKV1pla1RHTGVvM1lhbldpd1Bhd1dpQ25EUnNtbnl1ZjQwUmZN?=
 =?utf-8?B?ZmVBOHVxTUt4dHkzdmVva2ExcjFqRjVQbWpwc2dLUGFwakQ2Tjd0RDU0VFlK?=
 =?utf-8?B?QzBlSVBOZUtKaHI4YWFRaVYvaWNXYVM2NVlmSkwzaEtmS0h4OHQ5UjhQS2xE?=
 =?utf-8?B?dEE1elRjaFUrRHUwOEI3b0N1UlpHdEdjTDNHLzhEZnE1dE1PSXNIait5UU9a?=
 =?utf-8?B?YUIrdHNacGR3QW5vckZyMGNBTi9uOUYvSXBGQ05DOHJxQnlZNTQ4bEJINSs1?=
 =?utf-8?B?amVlT1RjaHhROEx6UWd5YzIvZDBXM1JpekhFSGNmN0xCUTFzV0orSCs4VmJy?=
 =?utf-8?B?RjlSWk5RZ3l4b3hWUVNDTFZwWFpuWXhnMFVERnhzOXZZdzI3a1VrNXJvNEM1?=
 =?utf-8?B?WUY4UDZJU0svcWx0ZG00VDYvbGNVRFE5WjRIL0lzOXhOWVlQMmZCQStKNlJm?=
 =?utf-8?B?d0hBRXRma2tYV3NJaXVHY0dsdFhHZzE1WXdOSDE4V2xjOHRMaE9WSHBneW1U?=
 =?utf-8?B?S2ZkYXBTL1R1ZUQ3dWlrQVBKaWNIZmxHRXRxZkQvUWtYWTJtZmx5TFpGS3VU?=
 =?utf-8?B?UTM0R3pvYWZ3T1M0eUM0Q3B0ZExCL1ljUnhSY1NpNklFcjUrbE95eWo5NEFL?=
 =?utf-8?B?aW5LL0dQZUpOenMyVEZ2WnNaOFY3VWhnQmJPUDU1QzVFWXdWTVFoZzFmVE5k?=
 =?utf-8?B?aTJwcUFUOGNOZStCWUJIa1JaNS9lUldRZ0c1eGdxM0dqYlI0amxDakkwbm9T?=
 =?utf-8?B?dlduNnJYZjFlZzZwUEtNTmdPZ2sySmEzdnV2SlRMK2dabFNHTTdJNWRNSkdL?=
 =?utf-8?B?a09Kb3hLaGZNcDlFeGc1UkIzMG9qYkdxWUtiTVNQbkhBdnFJUlphZDJVU2ds?=
 =?utf-8?B?WW5vZ2lNcFRxVWFYbmMvdmM0RytEWFlxVTllTUJnWEJ0Vk40VjBGckw1azll?=
 =?utf-8?B?SlV6NGJYMVNNUXBmdkFCMDUyZWxjdGR3d1p5d0I1M0lSTzB4TVVEdjhVUG16?=
 =?utf-8?B?d2dqbjAzVmpxRmdnL0xwcWhVMEJ6cWhtL0RpOTNPVWRDbnBBY1l2U2xIZTk1?=
 =?utf-8?B?S1FMT3NlNVlUYjUzRThWTEw1WndvazRTQklYbE1ZanpFSXZJeTZkUTR5MWVj?=
 =?utf-8?Q?MI1RLp/lJIKytCwFWWt57Nex0h6R8kwTi9I7g?=
X-Exchange-RoutingPolicyChecked:
	Ody9xuTcKrCDdqugOvDlKxnNXeWn2OSK0WYgJqUbCVukZS22W7/gORXGo8R40WXgkWzZIeJfmDl74wDC9hCCCgEIzch8kY8mpTydBWnYN30S6bGKMoLiORoP2Ae+34rWXcvkGDP1/Xh6ZnlJIXvKHCAw/kIBYE5v5IwCJf4MB8o2Xv3jQrRmqiSz8BeGyugMai3NNTy5kc7INMEe4OAFARRmu99r7A6pkK6lQTBbeVcE/oRE4GUHamkVVDmsDJIURLPahj6d1NTUOifa+vQMvJgFLvEh2nt16gqCt9X4zmXKuCScftf4PH+6A0mBQBw6SC0h+YBc7YY8M8IOHY0ddw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vR+FD8PqARBUc9JoZoJMt8haXg9s1gKJuVXSoFitDiDAl4hhRC6PBPXCXt2VmNXaEJv5m4VcM++hiea0BwxniN1gMVm2e/ZhrDhk/fJrh0j6DUDvZZpA0AzRBOh76smQ3Oa3h7GbYruYdzv24Xi3kI4xsy1dZTxb5hitccyJRWkazCj4PiDYrHG+ITxwQL2wPDcuTaZnR0OhhDKfBSpjs69aKIpRi2oCl9PyJmekHsVoVwTWopLLMdUCVQW/8rLRpxQ0r3Au76fsAowwwvkEaX4c8E1RTA9dDLRpYaUmQaXnImZsSUITMbCgWnMw0+yK5kuNuVCTHqtY07M6+a8rZ7dBmmOds4ZdTF2iBLWl9XY2ceBql75KcunewFhzcMoX7kugJzuH1Gjp0O9pkGAG+zcpzyQRGgg+yPJEdWkZPue62lGzEsXs9s24nVFQ2G5kv6qNTKIjA6jwzbUMzxsfbpoXpBSh2MLSiyLsA0JOrukV5eP+seU29Oq4NNsDWg82DaahEDmLQjaESZLGBIMWN8CYC6Ffbkr9xeTn9b7HJJTMdnr6kb5pkiDUQqq8KA6b1DLnS1m1AAvri8yL3IwrEri4ZpRBmWS4z3uQgkwMswM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: facdb506-0982-4bff-9ea1-08deeb29ba02
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 15:22:38.0984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmvGmtYGG9RlKPFAr4zv3RrpxutKwcfS8aft9BJ0dNg1CnuKo+rXLo8u4FhqtnNi8NvvDCK4PcN3xNpozqpmb4XKpvrw01Z8HomXYrwgbEnMbj3NYQij8x9eX/Bq7rzx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260156
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE1NSBTYWx0ZWRfX2wzEjpSLXmgk
 n4EjL9z5JouLkeKVEkKnCVyXpsm0SbzYZVt+88puTMTfQQPEFpqX1z0ezo3epWU4Cj1z5KP0Vhk
 Cfr+HHKFOldLvBp1jYAcvEJLKi6VBxll6LjaZqonx5dgqMJPxucA
X-Proofpoint-ORIG-GUID: wM9YoopuHVBFS_1mq4gxnROyf5TeXPew
X-Proofpoint-GUID: wM9YoopuHVBFS_1mq4gxnROyf5TeXPew
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a662641 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=1VPNnavTwzGdkEWp2PkA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE1NSBTYWx0ZWRfXwQy5DycbFN3E
 tDXSk4bS9b/lHbQXQJKEL6G/UQ6PC40vBa8Drn6g4qmFvIdn9jE4Df5ZB38hw4OWsxnGDxLtBH6
 h+EDsxmCto0BKpj2HnFZPGUYlUNOe6QrkQkgo2JZqWuEcymJIrIx1r0VexVtWIeP1O5xvDJjv/d
 kyfH+njnqZzgbY6RwAI/rSKBXNib0oeF5AWSMryJnmwDfzCFVhPGNlAuYrerym1omO/aBXHZLIA
 GNf9SvRHdRxsZ6wXOXbXxErTkLTApBV/T23DpPi6oJ3/1hLAzMpVN6OyBmYY9DvWDTs4+PF1Arb
 EKsrFQ7u5Asp6mRTQKer4cx8kB8V8ISDB83F5v88jkoHR3bDOnrNdl75mmtPR4Hml3mnqx/Gz3F
 D7tgCA947OmW8dWsC0iwgeskzweo6zm7EonA/+srqnYOdNKJ0cQkRKMFtAlmt2eqju8vnZ6AsmQ
 picIRMY41cdKTi0ow8GjjwKH8l0nJRenLR5eFxUc=

Hi Sasha,


On 26/07/26 5:34 pm, Sasha Levin wrote:
>> The new WARN_ON_ONCE() checks seem to assume the cleanup in upstream
>> commit: 2ae8e7afbc63 ("xprtrdma: Clear receive-side ownership pointers
>> on release"), but that cleanup is not in 6.12.y.
> [...]
>> So my read is that 6.12.y should take 2ae8e7afbc63 first before
>> backporting this.
> 
> Agreed, and the same broken chain was queued on 7.1, 6.18, 6.6 and 6.1
> as well. Rather than dropping the assert patch I queued the missing
> prerequisite 2ae8e7afbc63 ("xprtrdma: Clear receive-side ownership
> pointers on release") ahead of it on all five trees, so the
> WARN_ON_ONCE() probes no longer fire falsely, thanks.

Yep agreed. Particularly makes sense because we released 6.12.97/8 already.

thanks for checking.

Regards,
Harshit

> 

