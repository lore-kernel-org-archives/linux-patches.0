Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C251802A2
	for <patches@lists.linux.dev>; Tue, 14 May 2024 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715704447; cv=fail; b=RFMVyFu+VsDh4TBQFoaIIkTfAblGQ15OPsubHOSh44lFqIZV8PgHcgT5+pKSbDWt1TWQ3Vd5ubkAcM5d1suDG6niaa9VX7doZ1p4xLF4GL0lsoaPfQ3dtD8zRtuXE7WyJMIKHIR+5bhy07fdnvLCE60jluzCyLoXP1Vfs4fZxdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715704447; c=relaxed/simple;
	bh=9xtVxAeA9czrygWR8kv9mmpIcKL6ot5mbtm4Ow8phZA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nMyOgCQRncU3f1fxVV1u0psElHFCXCeE1nymbnfsWHTFSsgDeBiPWnSEY1Leam2SdvzIh/0J5HTKo3y7gwdtruedD+DnyEy/fP3cnW1grTv3EVjgnboRwk0oB+EipSr7n33FjH4olmcUlmu5/y+2pHGG3gOdN7lxLGhfNeb/rs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KofxzZGs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dZk5VnOQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KofxzZGs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dZk5VnOQ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44ECg0BM006833;
	Tue, 14 May 2024 16:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=pxH9q/nrzDCgGPHaZ5X/lk6JLYhUFLuFLUaUP8pgNpk=;
 b=KofxzZGse7aRwmmnQOV5+Dr8oh/IMZ9NmZ6PORbGnmwatBQIjzN1eulS9cKmLpCALw0p
 S2nWGDkjW4amShBW59X+PLBtxMGmPqyp0c3etFhthx9GMMFaSCGGFi6PCpOsBpPobg4a
 b5zPfdEX9BnG4S0yE2fgIjR1uVroyJ0IX9MhCTZpK/ll2SHmOaYk6ZTPCLatRekbfKym
 nkFiLZXDl8wWCcj2K4D3E17X1hZFt536XXKAElnxRxphWWINip2/7XD2S38AWLfK99ds
 tW5fv8PhSMICnuxx+TdcQ8FjpA3PKeqoBqSNa+D77CUZhdjZo9EF4oLLqxfmc0XoO2mF vA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3tx31tuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 16:33:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44EFihPB038323;
	Tue, 14 May 2024 16:33:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y24pwajyr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 16:33:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIsMwjGfHtwJ2UPe+ZxBLjyLCwAkAonWfcvEImSbz71lAc317n/7Ohwk2NmpsWZn/4mPzWTSHYf+3gvpkxv4ukiHGPwFTsGR00tGg+i/qYgmESvlqa+ua+L0xfd/BUioQE/dhcg7CHj2cE/dAKllKbA5C80WRbgoSXRNcHgQ+eyglDVGdMyIKSmdcSTshJjjcDx/bo0WvAXakOwHBQSbiUHF1i9UNphkkAGYdtCp3RoQPTXPkx07WujkKRj2+ZIjooA9OQTgP9Rg9D/UbCTjRVdKGSHs12jZ6esM7C0aXlZeTJdZSyG15DGCSfHCfM2PnClEb83Mm7yPpTDFNTRsFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxH9q/nrzDCgGPHaZ5X/lk6JLYhUFLuFLUaUP8pgNpk=;
 b=Bn0mXXZdAbDYR/dfb9gUek7Icl+z+D23BJoX2KmUFggu18qcP1zBBFMsSqdeFu1akoQVqTV7lXuWFGf8tvlZtJISp8w/ZXyYBbwFpptJQLrKnnt4Ux+qK/Dk+ezT44g9mZoCGU80l4jxEODQx428W/dmiD4N/IcVd6/B5ZdZA/XPL90yawZq0yGfc1iqseOeOnqLyYiHXxpTJKvGuwU+ekNTjmMQFPc1Q4+zACSG4XrJRf1V4YBDgR/mO8Mr2goE+jUPsm2QGW+lLPOHakuinyUsoLO/+T7ojaw0l1fttFOyQpfNNhWtrng0/YSoonEAoQ/ITtaRRVkzura3bnw+xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxH9q/nrzDCgGPHaZ5X/lk6JLYhUFLuFLUaUP8pgNpk=;
 b=dZk5VnOQZUMAQuFBgjg1hhxTn84csQu15Lg6silN+mM4BlFaWru2+wIWcKf08aXPfAPMfi29bS6impZmtQ0Vt93v89QEe1L3u03bxVtALIocz91G+C1vJiiBgKyuB6Y9nJRuC/RQEk8fer7HlIHh/RPY3oQGwE+2Gc6LzyQF+7U=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MN2PR10MB4256.namprd10.prod.outlook.com (2603:10b6:208:1db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Tue, 14 May
 2024 16:33:49 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 16:33:49 +0000
Message-ID: <540a899c-4b51-4df6-b3a4-f2e40aa0e2ca@oracle.com>
Date: Tue, 14 May 2024 22:03:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/63] 4.19.314-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240514100948.010148088@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0005.APCP153.PROD.OUTLOOK.COM (2603:1096::15) To
 PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MN2PR10MB4256:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a395609-8c4a-47fc-ede1-08dc7433a230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?YlFNNG5qNjhOa2dQMXZoUTJhMFRwQ1VmU1FLTm1oU1Z4OGFPT2RJWWtjeUdW?=
 =?utf-8?B?RDNBNDE5UmhwV25mbzN1TU13TTdTUDh5R0RFUzRnZ094bTNLNHlSZ08wcURU?=
 =?utf-8?B?UUlWdEtGM01JN2tGQUppcHZXOFhpcVJtblRvbUlsZm56U2dQZEZRSFJWaXc3?=
 =?utf-8?B?aFdDSk1ZSjVLWUNMNnp3WDVQbmE2N0VyN1B0VW9SZmRBSVFHRHNJeWhEeDJv?=
 =?utf-8?B?c2VNcTJ6RmhIV0owcXdFeFpXM2lVTVZ2Wm5PUUNhM3FYWGl6Wnl5dm5Ndkl1?=
 =?utf-8?B?NWhoWkM1cGRnck5FRmhxUlV1ZVQyUzdzYjVwN3BBblF4LzBtTjU3RGFFWUlC?=
 =?utf-8?B?ZDEyKzBEYk1qQ3hWeTZBenNzYTlqWnkyaXJtZzg2N1J0Y3NkZ1lFSXZFb1Bk?=
 =?utf-8?B?cS9HY0JmQ1MxSlN2ZEE5VE9wRW9LQlo0SDg5UFY4ZmorUE5ZblJTc2Z4STVh?=
 =?utf-8?B?anh4ODVlYXpUMzVkc0RnT1RWV2REbGVJMU5mSWMwRHVlalgyMU1hcEE5ZTQx?=
 =?utf-8?B?ZzhrbVd0YW1DYlBLb1J6eTZHNUJkYXNiM2FDN3VLd00rN1BFRzJJcldtVUlC?=
 =?utf-8?B?VFFQaFhVNmtueTZqdlFjWmQ2bHBYelZ6WlRLTjliMXhTK2F4K3U1UWhLYmxy?=
 =?utf-8?B?Z2pNUldjSjYyT05zcUZSelJxQ2t2aE81d09rQ3NYKzRsajJuQVdmalF4NzdX?=
 =?utf-8?B?dWc5TFZENFdGZ1c2aEVoUWEzWmRHYld4azlpMDJNYmtIVWlTdE5MZnExcGFU?=
 =?utf-8?B?MnJPZXFXRndlZzVjMUpwTVZRK1dGMlVqU3lUY25lR3hZMk85bDROaHo1Q2pY?=
 =?utf-8?B?dzd2aDNMQkh2MHRnZmRTaHRZL2wzeVpkZnRjNm9hdWtEcGJiQ2g3WWtKd3Bv?=
 =?utf-8?B?ankwU2xESzRPVnRZSzgyV0J5dHdEZmw4Q2o5bzlLeWZhOFM1M2tFbmZ5L0VB?=
 =?utf-8?B?UGRPUWVjcWo0VzhDSGFvMy9DNXNubHprMkJHTER1ZWw1TUNhZHFwa0xaNjdF?=
 =?utf-8?B?ZVl6QnBHYTF5UXY5bWlJOWZzbWdjd29KeWRNa2dWY253clNIUGpVQTNKeG1W?=
 =?utf-8?B?U2N6ZXdoL3hQRHhBOGdSZ3FtRnJwMTkxbG90Yk4vN2ZzMnZ2a1MwTmtQTDFk?=
 =?utf-8?B?T1JlWVcxMmhxM25oV1BIa2VmYlVZeHg5NWxpcUxFaEtkQXRnK1JVd202bDNI?=
 =?utf-8?B?TFJXM0xQV0hkV1ZqTXpiQThnRERiMCtwQ1c5eHZwSUNLNUNFY2w1d0xWcFFS?=
 =?utf-8?B?bWduL05aQVdvc0ZmQXhDNzRXbHNyT1p6NFNiajJxQnFJVlhXSWgzQjArZUNH?=
 =?utf-8?B?MFFUekQwdjBFWld5NE9ickl6NDd0Q0k3ajdnYURnTlZhZXZHb2hHYmNhM3N6?=
 =?utf-8?B?bVZYdUVDd25Hc0hydUVxMEcwbmdwaTE3RUtuaXZjTDAyRlEvUXBjbjRoSVVM?=
 =?utf-8?B?RzdGZDFPeGs1SWN5WkJZOXBBWTFMNkEzNkFCMnpVcHN0WnphVDRQa2tSTEI3?=
 =?utf-8?B?aEd2MlQ5dmphV0Y5UkNNNGppVHJISUsrSGFWMWZwcXNOdnBPY1dlZDZKbVNy?=
 =?utf-8?B?R1J3azh0ald6bk1tcVd5L2UreHZDTkFKOFBHNC9QcFc3OTE0MENNSit2bEta?=
 =?utf-8?Q?kLG8Zd17E6U4D9B9F4g+5ecYApDJx0jKCGf65AtZPMBI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RDJFeWMycWNnQVJUWlF0bWNPNFg2Vm9sVlpQajF1c2Q2YlhOeTEzN21qKzg3?=
 =?utf-8?B?Y3kyUHBZdGk1cnBWcSthZklpTlNWeUUrbjY0K0MyaTE2cnVidzRGU2ZTQjJF?=
 =?utf-8?B?czcxQzY3c0xCRG5RR0dzRU1YRm1jYmhHYzFzSGdqYVJlbkYwVWQ3S3RidHZW?=
 =?utf-8?B?TXphNkJEVld3dzc1dnMzejhVbVQvajNtcDVvbzFKK0lDaWJtL1U0SnpXTDlJ?=
 =?utf-8?B?V1M0OC9VZElnS2YrQUM2ZEdOaThTazZyZGptRWc1enZxeTJQQkR6VFd1OTVD?=
 =?utf-8?B?bFNlakczR2ZiZFJnbFJzeVRmYXpYWEF5c0hSc2J3K1RvTjFsUkw2ZGJhK1lP?=
 =?utf-8?B?U0Vjb3FuVzdxMjBDOHg2KzNVMGpTY1BKY2h2K1RTeUtkREZqVXNEM2NTMG85?=
 =?utf-8?B?VUVUejNJaHc1ZzZXaUVhYU9RVDlCV0xqcHo3VEtFbmI1NUVablp0ZGVDTWhX?=
 =?utf-8?B?YjFHTmUzYW5zWXJEKzBpU2luMWlhVitlV1YweTFYYXh6REdVR2ZTRHhrLzdF?=
 =?utf-8?B?UWZ3dDNoVHRqSnlERWJxZjVRTTVtS0c3cFBHQjBtZ09jTnE0STd6czFXQUt5?=
 =?utf-8?B?RW9JT05zNlppVjJ3ZEFUbDVLK0JzekhFdE5FZE1aSkNyMnYwZUdOMi9SSUZR?=
 =?utf-8?B?ajRBcWU4MzdCYTNTejFhV0QrbUhkUTlGakdwb2JuMUxRRS9Xb002eGhMamla?=
 =?utf-8?B?dHV4OFhueWQxZG9tV2tqZGo3cHhLN0VwZFNiMXJkRVdqdFNESStjdXAzaWJy?=
 =?utf-8?B?WmhyZXpodmljcVR6U3ZUbEpjQkZFUzAxcDMvblQ1Wk55YnU4MW5GbC8zR1hG?=
 =?utf-8?B?MVd3THNoNDdvLzgyYWpyZHhndUMrb1J4d3c3NUJsOFJGODl2d3AremNodHJF?=
 =?utf-8?B?T3BwdmRzb1VwZDcxT2xTaXlpVnRZUnBTWUZ3MGt6S2I5YWN2b2dFdURVVGpR?=
 =?utf-8?B?VU13RTNHNFdBMS9OSW5oRm9EUHBPYzlvZU9Rckp1QVdIUUFVMzF5TGFsSzYz?=
 =?utf-8?B?b3k2blE5dXkyQVZOVGNOUlVJdzNzQW5XVzl4Rms2cVhaR2MvNGlWL1B5Vmkw?=
 =?utf-8?B?Sm5kKzFBS3ArbWlUTUZLbU5henlwbGwwa0VJS1BIc0hMNzQ2ekZwcWxRSHhS?=
 =?utf-8?B?WWlGUXZwZGNXaHQ2aWk0RmJMNUhqRlBTeTJzbE45QjArZTBLZURVaHEySWV4?=
 =?utf-8?B?SERQcjBRbTE4K0o4cXhySlI0aGNtd0x6a1A0OW56dThETHJ0RWI3enYwVTBo?=
 =?utf-8?B?STY2ZzQwWS8rVmY1a1VkU1Q2Y0g0ZjIxeGxiM0p2elhkWEtia2dpZThHUXk1?=
 =?utf-8?B?ZS9VYTFPZGVuOVB5c0d3RmpWSTY2WWc4Y0MvK3dYcWhTUXE1MHdBNnhEN1Vk?=
 =?utf-8?B?a2g1bTI5TmpZMmgvOGFtWTNGUnYrc0k3OXBkTElMSFhlWExqdVk0ZVFnNk94?=
 =?utf-8?B?d1prbHRKbHFBbFhER2lkb3BORWc2cXBIdUxKVzhCK1VNN0FTTFVFc05DcmRQ?=
 =?utf-8?B?RmVVMzJXSWNxdmFCMWRnQ1NmZUtjbjRZVTdndWdpZDZFSUQ5WnJSc2k1T2pH?=
 =?utf-8?B?dDM5cHg3VjBGa2QxOGgzWnljd0xWV3RsdW80cHhxRUFiMXVrc0NlVXoxRHNB?=
 =?utf-8?B?MkZMUHJ1cUhqQklBa0ZMS1ZwakhMQ2MzcDFKTklGNDdvLzJsQWhXa0NjMzZO?=
 =?utf-8?B?YlRqSHlUMHFpY2RxRzNObGlqVkhJZkYvSEliTWxKZzZEbm44TE02MjY4Zjls?=
 =?utf-8?B?b1c3eFpVaFdiN1hCUFJDT0N6aVAyZkNyN0xsS21rY2xScktiV29PZExWSlNE?=
 =?utf-8?B?bTRlNGx2RGdRRUsrZzVydlllSzdwNVJZRDk0VDRGeEZHLzdrT0RDZkE1OVY4?=
 =?utf-8?B?bVBUMWlEb1BDNzZzY2lVWEY2UCtIc0grNUpPZjIxaUtYbHZzVHVkNkcvMW9N?=
 =?utf-8?B?NXhWRDZPd0FXdGxpV3B6ZmxQN0VML1NIeFFFenJlaUtmMzNqQjhuYll5RExp?=
 =?utf-8?B?UTBTVm94Vkw0Sm5oMkF2T0J1eUJlb2pWTjhNYXBOd0t2TzBLRStWTUhjeDB5?=
 =?utf-8?B?RDIwSkxqM2VsRW45dTVoKzZmQmxQTWxIWSswR1RQSnhVK0x2WS9sSk9VZVUv?=
 =?utf-8?B?OFFpdUdjMzdXa0FFWkVaQXU5S0c3TmcvMW5kbm9TZENyL1JReXBvVEJTVy8v?=
 =?utf-8?Q?FYlQD6xVMDAoLVBTQNImuKM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Dxgnr/++nWiBqkjYTOk8I7ZaCXk5XLkoNGF1QNkTntzVCAEOkYcRrFirZK7v4vJ9fCrnPTDycXwd1IVL9y8mwMY1yoK3zrIZlYs5ocHTTgZY6JIr6aoOgC+594nc6elDBoDE73mJbNwwcE/5O4hgIUAglya9otJJT9yAX4fVSeZpenpFunBXhDP1RCHREg/l42Ns2eGvudRq1SygCj5B4drE6QfXkAu6Bi9/gmr5CFtbFbc2NTB1b6sGCWtUhI0LhwHjzuiF9D3523ZU5OZVdTP4GuKv4f2/fbOedtw88938zmXoSHCQaBtkIii0Rtl6/6aR8bNhrYIBbmFa0RuLNk77wubug7GsOqS1qxQp5rRZjGXHvw+wH04HYR7V1K6tyol/imO0I9mLH4iMtb77P5r6rhgMO1jebPI4LDHk8hh6cu+ggYEWY0RPZvhfg/424M6H34w5PHX1GaiiC3FzzTidHeW6cSfUc0LfyzwmIobxF74ZgEXyf8B9jPpyq6vhzYpuNJVfZdqL9hxheHHCojhSVQobrEw/asS55ZxoUJvBTi1EqKr0n9Zl7UzYN3ddAutHnc0X6qpXXE6I8rf2G18y1IAD+6/PP/RyvPeCJmw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a395609-8c4a-47fc-ede1-08dc7433a230
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 16:33:49.6189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJ13M0Zjfj7mOdTfGc6btyzDt/yaBrX7hLHqEnJgzlKHb28LBoQ7jTPs4Y98kwNy1zSn6veL35P9WhWEoG0n0+o1PDmujAKG38VNq+IUfjFrqAb7PsEIZb7glIu+7wo0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4256
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_09,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405140115
X-Proofpoint-GUID: Lz4RXgXUYg2qZQF5CYLGhvByEsR_qenp
X-Proofpoint-ORIG-GUID: Lz4RXgXUYg2qZQF5CYLGhvByEsR_qenp

Hi Greg,


On 14/05/24 15:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.314 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>


Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.314-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
