Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2FE81732
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 12:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744201933; cv=fail; b=rO4HLD/V16NfbSntRRFpWJGLDT1Dcrcu1GwMYB/30M7C2ibvTC3I/V7kzpatWQz/rMY+/eS6r/OopWFkuppyqFfpdxB9jSHCArcIiQCR6Mcwm/q+0YFzjjxK+Q2mW0dCbrowS5GjfZd7FjZmVarHZ0zwi0y7IP4yeSvmDXQt6kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744201933; c=relaxed/simple;
	bh=66qiwUvAA01qoT1aL3wTAjJS2qw0BSTCbFJ9WB3F+P4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dUDNH2PWaRBfkVl9Bzuwb3EJZ8EPEbUBWo3tXweRAZpytxNlFP0YNxqvJCRpsgICzGMIBTDcArHu7BTDvA+X6mFVuOQq8h/njkt3zsjgGicVZ9DONPKDS0anHABADPnU0iR33al06WLvdEUKemI17bmOjOxZGjHvHlcNFHuIRso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HLX3kir5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rNLeu3UN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HLX3kir5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rNLeu3UN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5397tvVj004446;
	Wed, 9 Apr 2025 12:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hCWaynb/eoSUuFQwcMH9dIFayT+3l1Vg0wONR3dWf2M=; b=
	HLX3kir5icTUILlAWdx09etQqGN002JT807woYqmZLHniSHmf3brd1hBD5HS1ydG
	2qCsyZWGA4y+zrfJOnrIedMRJ1xFj5Nz7Sl0vRUfoSNwx/yw+2Lgk+x4aBFa/g2X
	L0l8EJsxQQYY3Fju/CSR10cl2RdQ3mnRDs4TY/uKitTUfATdOecnDfyRlSgfH9ds
	DcG71PJLZ5wpNIrLqRCNUalimz2RsCA8Wnv22OgLKsvETiULzYFfchtfKPlf4Dd5
	CucAJBt5xgqKW/oXlwMk4Lud2sBNavaoE32QYQFl1dCKMQnMsS017jdkdKmen/8l
	WT7PLRaYOw3eK3TlaKpREQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tv4sy39v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 12:31:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 539CUtV6020924;
	Wed, 9 Apr 2025 12:31:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyh2eer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 12:31:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYcxzcFVemBOIgjvHL70b4XSNCYU8JavBthm6be2fPXjfj/VWR3cvE/1ZWkZP+UgAh5Xs/kMLdi78ENURFbwiN1n1gCo5Y1lKd5ksXtK4geQ/J9nSdcLpWCyI6ryePJMhAxv37WG2JxLvyKyDMmZkz4K1LyYcbk8EalnhpQ/0AkzsatBb0Q54z9qeHl326LG0lmxvLaDkbFwhZfjY9PWfZmHhCnUn4JmLP/7dbTkqR2fRuwV4uEEXn4Pyb2imEr1pNjImRjysmRS+1fxIaBuq8x5OHEK+Xn/qWl8A36f3XJff/8ELxevV+2t65lfkD5ECwf0unM7lEXcdREXBg7KqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCWaynb/eoSUuFQwcMH9dIFayT+3l1Vg0wONR3dWf2M=;
 b=ybG1VDKlWKNbX4KiJmHsmyfiGfPPvLLVDOVP62hVu5axLIHKCpE62TQqcM2et9o6NN4itSlHPzNlO4B7vepx2Gbjh3fr55XZABxJE3oce0ssxIe77IhAngqzFWlwcI6W+vtYD7sXr7P1C0xBx0znhq8GcjaJRoynT8B1IFg4sE1YTQEgzTDjF5iGmpZe8SqyZVt6vVasn9oTn10sppjJ4kkYKbyQYdBVx4o04gjRrIPaIgWRXb3U6C6/b/AD5mu9tbvdvXTbnZ7rDl9bI2pQJNKVEoHqx/6nQhPdKcCmoyWSzNt+l0h/u3TTlfssIc/w4x3YVA2WdVPdlMZuRhXEGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCWaynb/eoSUuFQwcMH9dIFayT+3l1Vg0wONR3dWf2M=;
 b=rNLeu3UNNROGKZdbLa1g1BNshP605/TUuyEINdNBd9c7UDpQmDwZ8mI9t5JLB5FZSX9GpbHQ+BBbutxjCz72ZEp4JnyAYGn9WW46eowJNj0o1Z5aE8Uzb9lzbXnmvpvBcGsBEhGzuKHbFtLbmdvVpEYWbHyrgXBvtn8ErmHBKtE=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by CH0PR10MB5068.namprd10.prod.outlook.com (2603:10b6:610:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 12:31:56 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.8632.017; Wed, 9 Apr 2025
 12:31:56 +0000
Message-ID: <634bcc25-492a-4c87-ba7c-157c358813ac@oracle.com>
Date: Wed, 9 Apr 2025 18:01:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 5.4 000/154] 5.4.292-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250408104815.295196624@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|CH0PR10MB5068:EE_
X-MS-Office365-Filtering-Correlation-Id: 40515f4a-1481-4995-7aa9-08dd776283f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RitETHhFWHRwMFdOeEpzNEZ1a1pBRXluUFVJSE9LYnJRbng4U3RWTFlzYjRM?=
 =?utf-8?B?Y2N0WWNsWW5PSTVwbXFyajhDM0c5clpBOXkxUUxWR3hvd2NJRVZEajQxMUZ0?=
 =?utf-8?B?ZThGMGRvOTJVaGhjZ3RwcFpXMTRPMDZidDFaQ2FvTVBZQ1QySTlvQWVqM2w1?=
 =?utf-8?B?S3c2cGFnTEVIeXg4M0I2d2VmYXhJRTR1S1IzalR5ZFNLclNuanJmTldGaWpi?=
 =?utf-8?B?cG5XbEN4WFMwNGFWS1NhaFNKRVlRNUFYcCt4Sm8wZ3hKRjVxOWFlZlB2bktI?=
 =?utf-8?B?MEVITThnWmJGbDAzb2IwS2JHdFpOaHFUMXU0VmQ4akkrTWhTWVhwcHUrK2dX?=
 =?utf-8?B?VkVyUU1SNXRSSTRvK1hQcjJMV21UMWl2cEo2UFJWY202MHkrZTlWY3lTNm91?=
 =?utf-8?B?R3RrblY5NTVSaGVJMjBYdHovbkpsdDZ4cVR1dUtwaGdVdytRZTlyZUN3TmNZ?=
 =?utf-8?B?SEhsWmhzdUtUQnIrTnVyYjVXTDRtaEpybE80MUVkZXpBNHMrbnBkWUxSRCsv?=
 =?utf-8?B?MEMwdWJIL0dBaEZ4ZEthZkRuL0Q0Y3JQSE84M1pRb1JxdUpHNnoxSTdmUUEv?=
 =?utf-8?B?KzVqdmVqMjNzSVhYZXJhOTR3aDBHTnNDcXFtU1ozUGhRNXY2b3UrL3RPeFlm?=
 =?utf-8?B?U1BTK1lENkw4eDVWR3V4ckZGK2cyOGNVR1E4M1NjQkROMG5kekRWaDlLNG4y?=
 =?utf-8?B?Q21YWStSNitaSkVZZ25jOVBJVEI1WmhqSHhZM1haZGJRSDBQekNHcVRPc2Nh?=
 =?utf-8?B?bGR1RjczdW5NRXliOGJad3ZJL1YrQUFveERVWjdBUUVKTTdrMlZQL3d1UEtz?=
 =?utf-8?B?czhHc2Z6RittdjZyUWhqUEh3UWFkS052VmVlUTRhaVpRM3gxOEZOK1QyNzFj?=
 =?utf-8?B?WVgyNUIxUjV2eHlWemFjUm80UEZCOWVMYWNCWStoZ0dOdmRLajU1WlozTXVk?=
 =?utf-8?B?bytiTXlPa01PbzkyWlJObnIwelgrOXJrVHRxNEVOOUNTUUZxbWdhZE1BTDN6?=
 =?utf-8?B?cUxWaVFUTkRPbzE3ZnJyQ2gzYnN5emNXYUZBeUhYVXQ0YmZMYXpVVXJQY3pu?=
 =?utf-8?B?Ym9mbHJLeVU5QmozWWhyL3ZtOE9hTDBiaXJpamJvc1dUdFl2SWpHS3RLL1c2?=
 =?utf-8?B?WVpUREh0L0czQUFjdzhxTW1KTUFtTHlOY0piOG9xNHRxV1NrUDRUbUxUUS9i?=
 =?utf-8?B?QVBUbkQ1dW9JWi95dkErVWljV3hacmR2c2lseE5NaXZkM2JGZmI2TnNXcFl0?=
 =?utf-8?B?ZkhWSWRQWDhHS0hyQ1lzc0NRc3c2VWJ5c1NadG55VUR6R0pqaStCNmwxbFox?=
 =?utf-8?B?TGVLSW5hbUR0OTBnRjdQUnZiSE5ZLzJWUUVCcGpoN21FTjFSck9aTkxwVE5y?=
 =?utf-8?B?dDM2bk55NnQzWVVUWGZLT2QxSk1WUmIxTHhGTlNMTi9tYmMrRVhVWWVhR3cy?=
 =?utf-8?B?c1ZjR3k5OGhYeUFFQTBUWkFSYjBLZlg1eFROZm11dDU0L1F6R3RkdHRHY3d5?=
 =?utf-8?B?eSt1WWRHVkRmc3NMT3FOemFrR0g3aDc1M003UllIOXE2WTd6RFcxT1FMSVdI?=
 =?utf-8?B?dzBFTmszOUw3V2hWZmsyWDRxa2dUVXEvOW9wUjNVTkdBaGxsb3NOZUJHMlpW?=
 =?utf-8?B?Y0wzVjRxQ244OGcwMnk4Z1doSXhGRU5XWk11aUpNVEZpMkw1bVdUOVNwQytE?=
 =?utf-8?B?eWEwVGtVSTFtME1uNVJlQUFhODRXOUhtVU5MVU12ZlUyTnVHNmJ4T2VJemdz?=
 =?utf-8?B?RFNYVlVxaGl0eVN3UXNsdTJWZHo5d2dNdmxIR09TZitxU052MFNmNThhT3dU?=
 =?utf-8?Q?vrkfuv5Pbdj38oQDtIjIUAu0MnYYlQi0n4zkc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUJMYXlidkJUdjFOUjN5LzlxK25ybGJzWEI5QXlpano4MXo3VFoxTjMwbGpR?=
 =?utf-8?B?UjZ1Y0hVS3NFU0d1OEFYUjYrZ0FwWmpWUFNmMkVhVzVTeTJma1VnaXEvTkFn?=
 =?utf-8?B?ZklpTEtKZlFubFBQYjJ3UkRnNjh5RlZzbFFlSSs2aGtRdmh6amFhZHU5MXFl?=
 =?utf-8?B?VC9HL3dpaVE2Y2Y0eUpId0FsSC9MaTFqSG1EK0dDMGYyS1UzYVFHSFJyUmhR?=
 =?utf-8?B?QmFpVmFBeml3VDFFd1lGN3hwb0ZVcHFYSXpjVVNnMjQ3WlFwQ0VmNENsUVJr?=
 =?utf-8?B?ZkpjYWNUL0pzNnl6eTFKNlpzSGFqVGIzUlBjUlVQcFJWNlNLU1BER1pSQXdx?=
 =?utf-8?B?ajhnMnpkNHhHQW4wUzFMaEV3TXdFZVc3eWhsYVBKd2YrTmFXZzl3UXhiNVdV?=
 =?utf-8?B?LzZvUllqT25KVmdDdUloOGtweVliUUZaSExtZnhrNDQ4MFJQMzB1WWFJWVJi?=
 =?utf-8?B?MUp6ZmdSMVZOckczZ2hEUm43TmdPbGtzbDgzZGRHcnpUSVNBdTh6R0lBNHEv?=
 =?utf-8?B?T0kybFZDeHord1hEMTlRbVJsOUxmZXM0NmN6Rjk4NFAvNFB4cmZ5K3BpNHZG?=
 =?utf-8?B?RkpLRzNTY3IrT2ExekhXczRvZHZtZUZUYW5DQVZXd3dxa2JUcFFSZWRKR1NH?=
 =?utf-8?B?d1NocExaYWNEV1FDVUx3dDhjd1FncGh5WmJxQnV1d0xERWg5U3NGalprZU5K?=
 =?utf-8?B?SUdWT2ROYUoraFM2aUF3Wm41b2wwazhMbUEwdFRpYmE3cXduU3hBU0RyYzVz?=
 =?utf-8?B?V2FmQ0lIRlNKZG1SZXZWK3U4NWlqY291bDBSSTN5dVNMYnE1ODQ5ZS9tTXpJ?=
 =?utf-8?B?VEh5N2xWVlc4ODIrUU5xRHlMMXVFNjdScVAyZWtzSGhGU1pETnNCTnVjbllH?=
 =?utf-8?B?eVlyWnpuVENlMnBibURmQWtZaDBmemJxb3ZaMDE4WG9VZnVkcjNUcUpoYXY4?=
 =?utf-8?B?Y21jV1lra2p0WWxYU2RwNS9Ra09MVFJCMTB5UzRWL3BTcWFZYkJxaXdsdmox?=
 =?utf-8?B?UTRHR3Q5eDV3ZTM2cjNGdFFKZHpOdExGMWx1Y21tQ1ZXdVpvRjZiMWVKV1lN?=
 =?utf-8?B?a3hSZTl4ZlFoZDIwb0ZvVU5LNG9nN2xSTE9QakZDZlJrL3FDRFBaeUZtSnps?=
 =?utf-8?B?YmtwRzRXNTFIbFR5bW9ZVUtjTHJONXRWbEdId1dxektlVWZ0UVcwSXU1ZXJs?=
 =?utf-8?B?b1BVc1BVczF4Y3UxSUo1S0JkaTBqTTFWUmxaNU5QOFNONGYxa093KzI0UXp0?=
 =?utf-8?B?VHgrOURuOWxILzlRNktocXJDZHVYeE5qUWdNbXVIU0dhcUNiV0NYdEJuYTRp?=
 =?utf-8?B?TlJzWXNYYk1CWFV1aFZPV2hSS2l0RmtsMHlUNytYQ2JBUytzMm5icWZJemh6?=
 =?utf-8?B?c0dDOFNpZkE1VkdCcE02azhRb2dBZHpOZDNhZUFiWEFYMEw0SE16OVRhS1hZ?=
 =?utf-8?B?Qmtqd2pNaHQ2ajZObnpVbmlzMDlXTllWb2llUG9YZkJzVzRCVHpHVEI3S2Y1?=
 =?utf-8?B?MTdBaFUyQTEwYU1jamFXNFV4bC9Sb0xXa1hOcEFqRGlDb0FKeFpqeC82UjZ0?=
 =?utf-8?B?emFkYmpwUkVxQldiR3JFenFGdENSMG9XdVR5ZjlpL2NjYzkyeXB5eXNKdFZp?=
 =?utf-8?B?bWxHNVVaVEZFaXE2dSt1T3ppU1dCNzhCOHlwUmxjb2t6dFd5NE9lMEVQT0ox?=
 =?utf-8?B?bHpLRlUxU0ZhRWpBYmRjb3hzNmVvSXhsOXRQMk52b2I3VEpDTHNjRFlaWTdz?=
 =?utf-8?B?bmVZRDRWZ2oxOFBqRFl6eEpvMFExR1ZHTXFXeHRaRE9hcnl5eW4wRHFxaUc2?=
 =?utf-8?B?Q25LbWFkdkEyRWEzWVlWeVBwY1ZWOEZTZUNObVJmdlNtcFpzcU93UnRnSlRW?=
 =?utf-8?B?MjBMdW1SY2pIalpNVE1YUjNoKzJ6ck8rNldPY0ZWQTVWVjN3cXlnQmYxTFR0?=
 =?utf-8?B?dWx5R0NJemsyT2ZRUXhzVS9iRytSZ2hnc2d2OEoxSFRFQlFMSVpVVGVmcjlL?=
 =?utf-8?B?WDU3MzQ5WWV0MDlLM0ppZVRvWkFpQm9xKzJJRTh6b2NQclNySjJTalUybEdG?=
 =?utf-8?B?SGtGWWxOak1KY05vN0JlblRwQXJsUGFleUNPbzhpN1V4WVhMbElzdzROK01p?=
 =?utf-8?B?VVpXYUhZa3hRMWkySjE2VEV2eFJMcHh3eWNRLzBXcFBCQXl5VWVOK0xKM3pP?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ls+gWEz6PXV2WjL4rJt9ZZ/AiwUwDApyt7PQ72WxzusOcf/NdtyzA4noMxKb//h1yFE6C3NSjX6OwKBDQ0r2o9uNRT6GxboxPCHtXqoMhc7kD3NhxoMDRuGLfseBeSvIlRNmD4LIGEEDolzqNXEqQ0itohkDkAUPHbkIpqLaKaNy4mtfl/0cpS/9iEDxrPFHD0L8FFYao76t9SXTD3GL+A3yg26VS3Ybo5rZFuE96nYaYKuqHNDqam2AOQ48lUPERlamUNSNshXLCuuJ9jbwnHYhsV4WLBLvoDOkX7IScGCngfeAo2PMfISfCvEw+pZU87dj3HWfHg3ciLMako1hWYxxFhZ4TEhaN21nZ/z36T1wWzuxllgDOT3d3hBIZBtGNtAlA+Dtb7CaI1qSh5vd4YEJe4kEd2hmtVx+TTxIya6sf7Gl0baVdz6XHuFhlZJlULIzB8zuM7WRj1uRHKghdWOhICqz1dz7cmnUOATOJLd45mPYZ/yPuD6qgBtR+wqCb8ZVSGEE3CPWJa7foHASxfe79qQWGnP+j1NQ5TDJXKVyAVJjF4mHdYzFDhjjauYOS0FoFMoNyG6UTnMhpgS/68zHnFOr+jkd0PC3aqM+DnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40515f4a-1481-4995-7aa9-08dd776283f2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 12:31:56.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0ASNLNaXtqDHzZDQeZ8YJRO3Ww8pKFMEP/TKiDNFyErZMco2Dp/Y4mXyzZKN7hsDwoEPZ35O8cz6QO7jgJVWp8ivdf3ZKABuyrYodBdUcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-09_04,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504090074
X-Proofpoint-ORIG-GUID: YW-uLCceliOxn39XEz7Qsy6_w1JprfJz
X-Proofpoint-GUID: YW-uLCceliOxn39XEz7Qsy6_w1JprfJz

HI Greg,

On 08-04-2025 16:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.292 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.292-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> OZKy7DuB2mQOmJgLN747FcgCIXuoSlZ-9UbBf2csrfvE9- 
> cOL7DGMQKhKYylWod_poLaTNVNImdm3RPN9IoAbRqwww$ 
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
