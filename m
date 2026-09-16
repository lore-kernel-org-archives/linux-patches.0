Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67F436493A;
	Wed, 16 Sep 2026 07:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542452; cv=fail; b=tkOfi65DoruVl/7Ks3F7LeYkwbr/9B6XVwww1FMDlG4D7SKmGJenRdrkM8Qf8ODJqnUB55ICcMUyNfJCpjALTYEGjs0Qkw8oCWmcP4OTDBVC+4hT7Bg6f+QLKBBFOY6vcsftENW8FUAOjM8SUjDqs0pAdu6M1qBM/1e1k90Vth8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542452; c=relaxed/simple;
	bh=cl/V4Jf//UuRXZjL4up+Bzp94E0uBO7k8T2dhT4Fdw0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qrTw3VYRrX9tqlblklX5VQDjCuvW0tmsMDyEvInAAfwl0tKlugRYAtKYGtoJuyVbMINcByAAmUu4DlAZLwVvFF3otSeHvhBpf5gwm+I6tSoiJx+PPcOA8Ii0VHJ+HfXMXt7s1gVegXhu5EJYvxFabVNF+QbmohX1hQy8zbphwLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Twww1lWF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Czdevm3V; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Twww1lWF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Czdevm3V"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWS8n2102177;
	Wed, 16 Sep 2026 07:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IQFELiYgzLmzEGF/B5mOSiihUu95/MKaCpHm/fGAJPs=; b=
	Twww1lWFEB9XYT0f5t/THiTyzQXSJEwkgYrAJDxexhAgr586QyfixNRmgMp4hfhL
	0sXp7N+Y0HxBpEGsn+z/lp3MR3x+la7OXDHngNq40K+jLOIHqDzo3ZP7V/Ekh4rI
	MJS2uCIBCsu4KH4ISyHLngvxUFVDPqa5kz5FII/hILbTUbQAME5Nl2AMaee36qtu
	xFh6XRPynJ+9O/XJ+WLa9dNZe8WZVXeM1SRXk4ydTXvlBVPaARCaB0V09yEucOSP
	IzU3gzLRVM1krLaZH8K4OM3F4ktUTqFM+qBTFraiGBAdi75JQL05d50pB0nq7S11
	Qvt09goLNspyR0gQt5p1sQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxsbn4qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:07:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G75VqV004907;
	Wed, 16 Sep 2026 07:07:15 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011067.outbound.protection.outlook.com [40.107.208.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q7r0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:07:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XaRIuYRUrs8rW9ndFihxyt639WaRtmr9Q6ZKp2G6Yn2geWEvsFi6F4V/JYalAXnQrcg2P/kx4HZRPTKosXvYiPLEDXz53fVbmk+Y8Lj34sxBdr358vdthbgcbbW9ODKqiF19mNNu2YPCQTZFxIX6XUKzgypx9K3A3cPP+3V74T0x2zEycMrtIoq6jv4IDjyqUJObr8vDT21KfUxHTCcMqlwVqhAO8E5hlb1OvucsVWpaEC6piZTKB7N8lV3/7rYJ10jmvB/4aFxD4BDJ3dMnFBqJWdzAZzNWog7mYBZsus+TgiTDh8X+tqNJxjFam42EBxT3rMtAoTSyQrVjh57kVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQFELiYgzLmzEGF/B5mOSiihUu95/MKaCpHm/fGAJPs=;
 b=g6T6e7beRZbIODY8J0qOSa8d10ohYPjBpOWd1pUrAShssjOq8O0JO8nPAaP7g/Y+10jV0vPf7L2cjT2LBYzZKLvgrFKrf4awPDUxEM9GOVU2FDB/A0F8mfRD9lUIoVycaNYJOnFHtC3+w2s9SXamtu2eE/CQsEZKuLzNxL/14SoIBq95RWVEckeO4HELUQYT1O9p6XI3EQl7EgX4+olc8mB8zZ7UNW9BzuXXiVVkmhI2vUjGUVLMqceIlfExeZp7eXlRNEv1q/EhIh8Va7PNxDrV2KzgBvNNO8s79zPwWM+q3YsrDTOhqu1unDsf9eJXZd2kYiFI6+cviOQWPzqJTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQFELiYgzLmzEGF/B5mOSiihUu95/MKaCpHm/fGAJPs=;
 b=Czdevm3V8rKNLnlW5f6d2UBG7RhzrBx6q3F1Qq97z7MUsR5pWqw7v4KOTVtCi3bOynPN1LzOeN1CqOjZc5UQCzaaPXYSea/PhwpFG4HHzuXx5UQGqT99QAByBM4ina3IpU9QvOzPTaC/+AwVv0KIwbGd02lWSbGaJEtf2UNg7e4=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH3PPFE06E70EA4.namprd10.prod.outlook.com (2603:10b6:518:1::7d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 07:07:12 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:07:11 +0000
Message-ID: <dbf7ae11-e34a-42f0-a0b6-b95cf96a836b@oracle.com>
Date: Wed, 16 Sep 2026 12:37:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0344/1376] sched/fair: Fix overflow in
 update_tg_cfs_runnable()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Chen Yu <yu.c.chen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065615.219183517@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065615.219183517@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0242.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::12) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH3PPFE06E70EA4:EE_
X-MS-Office365-Filtering-Correlation-Id: a426aa0a-6325-425f-713b-08df13c1212f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|4143699003|6133799003|22082099003|18002099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	3Ufq/0rd0Vy9fVsurP9vCUHyj7XIgkIDLjSj/RyKqPnYbylFUdrMHo99LLWB5OODJ1XQUCzpvXEqN2VmW+b3iVMGnTdqkZ9mRQaAyLUQI/VdOdbaewUVSHGlqDX+MGI95GhqpH618prz5HljAqNh3S6D4zQoJI04n/jbSzxd4SfQn4TL68CeXHvfYlivDwIgOG8A3XCW++A/rv3Y9WrnwBFbuRtqudcHowqwF8extVZTeWgJPvmeRakH9ULNJXcu4TUzhdepmJWIdTUVAa4lFSQCAYoe7xRqNFF+I90T2u1QOqUp0j+ZKP2o6WRcawTRAdGfrYDQmFAVzXfOkV23/BYWU/NpYJ7MfHdNfrjP/RzJlFrbubEck+z2JkAiIkiEXxBCp9CqKo6n3h7wL6ok/ZCYy+1/G0hKvk1Ci4b3aqeoktsLlgMBo/Nhp0owQlum9y+uiaYT9y+qfVdX38ze2q/YIs42fruaj8jJre6nwKsb3Ly3x+dxNuTgBRBHZZhHBBUYreHvFoRzC/taxKVFAM/eGJPEPTTc88DQWA/O2aBGnN4gH64VKzHABD0ifH6oIe2IHYIDo3vojWtZ2ifZFZApzS/y04cu6+ht0QNCXOvJX2wODS3+cBt8i+bAZ7TZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(4143699003)(6133799003)(22082099003)(18002099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXZiNW1Ednl1ZnEzeWJUaWtTQWFpOUM1cWxHRzVHRzFXTlZPd1BzU0VNWTBD?=
 =?utf-8?B?a0tyVkFOTkpqVEwzL2NNQ1JSdUNXSXVHd2g0cnUrZXNrMXR1UEx1ekU4NjhC?=
 =?utf-8?B?OUFmbjdBWHZWdTZHNU9VRmtOVTY0S3pqT0tWOUEzTlNBbE96UUpDUkF2VDNl?=
 =?utf-8?B?Mjh1SHBSVUNYV3cyTldkL3N2aTM0NTdtT0N0a25QRW5YdHMrd3RvR1U5RnRB?=
 =?utf-8?B?b0tJUmlyYlhySExJVDFMTGpBQUpnZkRseVQrUjVXb0NXcFNCRTZUMEpEcDB0?=
 =?utf-8?B?MzlLdnAyc0MvV0NieFk0bEt0ckE3Zk52MTg1bnZpdzdxWit1QWcwUnVJd2Jz?=
 =?utf-8?B?RlBla2hUQXFta21FcnA5YVlXVStUdnJUekV6YW9pVUpCdjBsblBJd2NZcUlX?=
 =?utf-8?B?V2hoRm9tNFRud0ZXMXduWVhwcTdSYjMySkNkbGNCd1MzNWhmeHUxSFBZTkk3?=
 =?utf-8?B?ZnFaMVo3N29za1RXcTdIN0J2Z1JaOEo2UEM3ZDY4QjkwdU42MW9aODk2c3pC?=
 =?utf-8?B?SzlKY0FhK0NXME5UYjIyR20rZzcvZEN5ZTFOaGIzaU5BWFQxMklMcjJhYWk0?=
 =?utf-8?B?aWoxcmxrL0JFSVBKMXpIQ0JBd21BRHY4UWNOMkdDYzNvYmZTeGlBdkFIVENH?=
 =?utf-8?B?ajhNK0JROENxUzFTc2NiM2tORmRDbW9MNnBsM3NrTjRWRjUxSTFOa2tFOE9P?=
 =?utf-8?B?Tjg2ZVJMY09XS1hMUzBwUGJ3ZiszRnExNno0czAydHJDbXB3d3NwZDdXSVYr?=
 =?utf-8?B?UUN0d0U4V2FmS3ZVSHpPSE9vNFUvcDRPMTF4cXJpTTV1VzhrNjFFc1pkWGlh?=
 =?utf-8?B?N29oVFppNkRtN1NBcFdlaGMwcXlDVTU3aEpycFRGbXNkRnB0bUZVaHQ0QzJu?=
 =?utf-8?B?ZHZGaGJaQUV5cHV2c2lQYmoxc24rRkZJRWlDVzljanVhRzVQb1hWcVhtVWFS?=
 =?utf-8?B?cnRrWXVTQkF2ejFpL0tiWkFuYWp3WHMzaUY2M3FDYWgrU0V5VjVUcFZNSUQw?=
 =?utf-8?B?RDVncVVLdi9vaHZDWDV6b0RtellQZmRzTmFSalNlL1A3eFR5cEc3VVBwYXhn?=
 =?utf-8?B?WWJpM1lWM29NaTlZQ3U2enBueEVkR3A0VmY3RWRzNUU0azlkZzRMMVRJWTZx?=
 =?utf-8?B?QzdyNkRaVDBDSTc0R3JsRWRIS25RcTl2aWVzbi9mS282K2U5UUxvMHVja210?=
 =?utf-8?B?NlRNYTk4dnNnaVgxdXRsK3ExOE92NGd2MDkvdzlheUYxNXhldVYwUGcwaC9K?=
 =?utf-8?B?VGVQVEcxL3ZxZjRKWU8zdFV1bXczd1N5eWF5Q25VWHBqK2ZoZmJYNjNJeFg3?=
 =?utf-8?B?cEMrM2xzb25NaHFYZzhWWTM1SmdYVmwrZkpVT0tVcE9zYmRhdTFLWlZOSWJN?=
 =?utf-8?B?VEYvT1hkaXdrUC94bm1jVmo2SXpvVFcrMnpmeFJzTDN4b3I4NDlHOVNUT1Vn?=
 =?utf-8?B?aXUxRzFEUHMrOWJEcE90WDdKbDZOUk5EOWpZcDFNeklVUnlvS3AxbjlJVlRZ?=
 =?utf-8?B?M0IrM3hKcEs1Z2JxR0duc2d2Z1BoL2JWYmdjOXVocU1pVlRUL20wOGFkbXZF?=
 =?utf-8?B?KzZHbkhGQUh1UnNuVFd4aWFRak1UKzlZUmVxM0hYMDdYMjdIa292UzFaazJX?=
 =?utf-8?B?cjAxWm9zVWFvQVg3TGdDN0psYVBGLy9rVjVwaGg2b1dHOW5BR1U4YldIQnE1?=
 =?utf-8?B?R2ZDYnNDdDFjME5FRUZWUkVKOFM5TmExNjIyQjJXUXhHNXV2NkZ2RHF1L0NK?=
 =?utf-8?B?b1R3TG4ycHBBOFl2SDcvT0hsSldhWUR0WC9pVXFWeXpqcEUvQUZVeHFYN3VU?=
 =?utf-8?B?WURRMTRNVVlRTjVabWZ6SytsZ01pcGsvTEFXR2VRN3Q5dlh3akZtZFRpeEZa?=
 =?utf-8?B?WU1kb2Q5bEhaYThoalJ6Yll4V0x4NHhlUXJGejFhUGZjSUtmMDdZMWRLYyts?=
 =?utf-8?B?UDd5NGlCZzU0VlJMYkFXRWtWcS9BR3BmanB0azBzMlRIVUcwVEU5dFNHcFhK?=
 =?utf-8?B?bDB0VVF6VjgyZE5sTzV2SUJsK2wxbUJzcUVxbnZUbzhQRHdZY01rOUhOckNs?=
 =?utf-8?B?R2tnb0NCdmlGL3pWRy9qQXBDYUh6Z0JiZVIzdzBPckp6MHh4cE1hNmo1d1BT?=
 =?utf-8?B?empBSlpDenRFTDFaelpaa1Q2TTU4RWJPM0pHandSZmd6SWRrbUdibTk0bjNF?=
 =?utf-8?B?Y2M4bzVGaXNCUjkycUhmSVJXc3VJalVGUTUwMUJjRlBDbndodUpsMjFOREdP?=
 =?utf-8?B?UDlMSEV4Y3hPWGU0RWovZ2lHanpjd09PbEtwWC9xREhUMmZkR3RkbXBlUlFk?=
 =?utf-8?B?VXR5bDljaDNtVHRGTkNmRng5MjJJb1dwZ0k1T1FXMThNUHQ2VzduL082b2RM?=
 =?utf-8?Q?YzrxIYblkeh/hz9EK13mshpalp3AN8YO9XqkJ?=
X-Exchange-RoutingPolicyChecked:
	FDtxtPpYqhEXkmHUBeCAMPOpELq4vftZAhSl2cSzrVbYZrNDOEfX8h46FNIFCDIg8dX2BwxKCXMURv3ft2Zd9GO/mRj6h53iBlBsYq6H6Qo5bZ8ftax1urE3R7YeP5sBB6ciHGKq7VQMKrjMCaFv51SQ84H8iOYMMY5zcDgHQoULwRlWBLZJSxPFsjoZU0v/RRkERhZf2DsTezOErL+TEwiEMXt4mgLkD5MLZPLXVhpSAsjzPSnlcXpGW24FQAzJ9+bpsiEW/Te5nmtjyJA9NtRX5D+Mu0uvdl0PqSBvzTfxajFgLCUs3LnwODA/GECyr+Elw84zt85Lw5OE5AT9YQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MlbET/edpMvhilZ/aUrFkK84S77nq7Jz/vdAwj5sB+PdugF7KgaVFHJJVs++DB/5ofsisZKjGKVE3M8LfEVXzihHSD46qHah2pt2tHuYUVjPzvOZhCbiCKtupDtWkoJUCy8noCSSg7xaDd/+6bFezGWICDRJBJb7V2+K4uVy2iWGYkCMUzheyRDuIQO0+wpKObEpxWEQgsXghAnhT2hTRHNjApt3C8hZsiEoJOcitYvbjOwLfsiZM95MQU/eFk8O4a7HaFjsfD441opqCFLMvjZ8knlz8wnJQTRDrqYs8hSs2rElnru3TAQHTEL7sUVqx33pljETQMUltd/bEtQjCScWr3KevrrjriUmo9LmEtvJ89yldcBXgsmXwX3iHo15O0wywcQDyTb6vp7NoVR1Q3viwry21lZhlpqJX5ba99IztfnFyvQGVfMHqPwHSq02w6sHs4AzOyRav/xSBPlYM2jF0tHhjckCdqsBdsAZOpqZKq5LCSkgyo0XR1zPfxCUTQGhFcFbyYtS4bYgqDz4+jjIsG5QuHnfCjSWQHOIL0u0UJQAqHsy/FNEnTNBhYSbMxWT9X3D/KA9t4PjCwf03p49Noul43XpXrXLOSn4Nms=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a426aa0a-6325-425f-713b-08df13c1212f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:07:11.8674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 613+DZ0wVtOderndbRse2b1HabZE01VFM9Wh8z2FpKb22RsLF7zHMkOyu+f4thBWXtBm1ULrtzrpz9QWyV94h2gGHkyaL/ABnXqZADmbsMyEcmJzWtV2gmdnCoBz34kk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE06E70EA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5MSBTYWx0ZWRfX62FCQyx801rt
 DzmNuMmfAULWAxwLkUm/GPA8PtH/iKYfnEFdAVCud/tWfZkD2hqsuO9c7mwLfnlcWYJ3dAXFGMs
 13mheifwB67oaTWjhFNZJTsIJlyZYbx8dCEGlPg+pXKcH276mwltBiCGoR30nLrEjFqBi60zugm
 cpPHnVNfZrN/SPzMVV+UUtrCRl3jrbAvQTXONvQRNjs7D4DDs/+d7lnLWr4cl5kuf+Uixhu4nha
 ZKitMfYQYD98BemgzMyjP/HcDRCe7iTl0XD8B7mZKtPBDW7Q4NkQknsv0mRmp/iUrwhKouzleu3
 zWM273GkDBlkt8bEz6ZQBY57cb+ZrP5SnZ1UA2df5jaB7/jnoBJCZeojIW2AQ7ZK+e9tnSEj3pw
 oJ1bonsYWMZNH3lNobOsR8bn8/sVBnInXUD1UAsUf40Nn+id7csOdkWjU813nuIengJcc0Q7unf
 nFaEB5AWBL2iMyVYSwH/ubqmYwRfjZYeY+gouP+c=
X-Proofpoint-GUID: RxA4T1WhtHLI950mhEnyhX6ZZBEbWzUG
X-Authority-Analysis: v=2.4 cv=dY0VTnXe c=1 sm=1 tr=0 ts=6aaa4024 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=8tl-96Jq50j-D6PEjLQA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-ORIG-GUID: RxA4T1WhtHLI950mhEnyhX6ZZBEbWzUG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5MSBTYWx0ZWRfX8l45+akEKey2
 i1+v8t/phDsfX8qEor1R1qHSPy6/HrVFbWqfl/SM9bLgfa3Whb0HrXI+7NN+hn53UXx5wXuso2I
 88ltgX0zOtBKn/fvldnJFFk1lr2pACIqLm3xrljrXxU5VrBc0jdF

Hi Greg/Sasha,


On 12/09/26 12:16 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chen, Yu C <yu.c.chen@intel.com>
> 
> [ Upstream commit 4f166adb5cb0525d9e32d45729fd8f28c80acbee ]
> 
> A divide-by-zero crash is observed when running hackbench:
> 
>     [14697.488452] CPU: 112 UID: 0 PID: 124791 Comm: hackbench Not tainted 7.1.0-rc2+
>     [14697.492627] RIP: 0010:propagate_entity_load_avg+0x35f/0x3e0
>     [14697.506799]  <TASK>
>     [14697.507411]  __dequeue_task+0x2b4/0xc70
>     [14697.508677]  dequeue_task_fair+0x36/0x370
>     [14697.509047]  dequeue_task+0x101/0x2f0
>     [14697.509426]  __schedule+0x1b1/0x1a00
>     [14697.510868]  anon_pipe_read+0x3da/0x450
>     [14697.511400]  vfs_read+0x361/0x390
>     [14697.512053]  __x64_sys_read+0x19/0x30
> 
> The divide-by-zero happens here:
> 
>    if (scale_load_down(gcfs_rq->load.weight)) {
>             load_sum = div_u64(gcfs_rq->avg.load_sum,
>                                scale_load_down(gcfs_rq->load.weight));
>    }
> 
> gcfs_rq->load.weight is an insane large value and is truncated
> to the lower 32 bits by div_u64, which happen to be 0.
> 
> Using AI for investigation, the cause is a u32 overflow in
> update_tg_cfs_runnable(), and flat pickup became a victim when using
> tg_tasks():
> 
>     u32 new_sum, divider;
>     ...
>     new_sum = se->avg.runnable_avg * divider; <-- boom
> 
> The following sequence shows how this triggers the crash:
> 
>     propagate_entity_load_avg()
>       update_tg_cfs_runnable()     # u32 overflow corrupts runnable_sum
> 
>     __update_load_avg_cfs_rq()
>       ___update_load_avg()         # computes insane runnable_avg
>     update_tg_load_avg()           # propagates to tg->runnable_avg
> 
>     update_cfs_group()
>       calc_concur_shares()
>         tg_tasks()                 # long-to-int truncation, negative nr
>       reweight_entity()            # corrupted se->load.weight
>         update_load_add()          # corrupted cfs_rq->load.weight
> 
>     propagate_entity_load_avg()
>       update_tg_cfs_load()
>         div_u64()                  # divide-by-zero
> 
> Fix by widening new_sum from u32 to u64 (no need to force tg_tasks()
> to return unsigned long after this fix)
> 
> Fixes: 95246d1ec80b ("sched/pelt: Relax the sync of runnable_sum with runnable_avg")
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://patch.msgid.link/a22eea2b-4c4a-4623-9a44-d7b18c0c91c8@intel.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/sched/fair.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5a09448e22c33..4be1df2b90df0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4416,7 +4416,8 @@ static inline void
>   update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
>   {
>   	long delta_sum, delta_avg = gcfs_rq->avg.runnable_avg - se->avg.runnable_avg;
> -	u32 new_sum, divider;
> +	u64 new_sum;
> +	u32 divider;
>   
>   	/* Nothing to update */
>   	if (!delta_avg)
> @@ -4430,7 +4431,7 @@ update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cf
>   
>   	/* Set new sched_entity's runnable */
>   	se->avg.runnable_avg = gcfs_rq->avg.runnable_avg;
> -	new_sum = se->avg.runnable_avg * divider;
> +	new_sum = (u64)se->avg.runnable_avg * divider;


I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The two posted hunks widen new_sum and the multiplication to u64. The
6.12 implementation then updates the parent runnable_sum through
max_t(u32, ...), which explicitly recasts both operands to u32. The high
bits fixed by this patch are therefore discarded during propagation to
the parent cfs_rq.

Upstream code after 089d84203ad42:

     __update_sa(&cfs_rq->avg, runnable, delta_avg, delta_sum);

Downstream 6.12.y code:

     cfs_rq->avg.runnable_sum =
             max_t(u32, cfs_rq->avg.runnable_sum,
                   cfs_rq->avg.runnable_avg * PELT_MIN_DIVIDER);

The explicit downstream u32 conversion discards the widened high bits.

Upstream preserves the field type through __update_sa(), introduced by
089d84203ad42 . Maybe we need to be adding a minimal 6.12 adaptation 
that clamps the parent runnable_sum as u64 before retaining this patch. 
Thoughts?

thanks,
Harshit

>   	delta_sum = (long)new_sum - (long)se->avg.runnable_sum;
>   	se->avg.runnable_sum = new_sum;
>   

