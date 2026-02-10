Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3799674C14
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 06:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770703261; cv=fail; b=s/sc4CvIynQRFWC8HAVf4MZtTQEJi5ncSlxELgG4DcuVJtFSfffAzzk2B9ZrouxzEMtYuZRK4zsuJZ0Gw0tbB6B1AZwxMk7KWfqnWDIy05lbbXb0zfGkDxgcqtcUoXWglyp5fsd8LMsr5LxgD+IL70PDiETS9NDnURKr3u2FiBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770703261; c=relaxed/simple;
	bh=H+1f9q5z3KgE4EghMDQyPBfc2OmmEDQcZxnq3ClCqoE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K0fqtgTLiqY/vj5n3y/xXzf96Ri1KfgACMBOmrx1hUFua42X1SmRT9XL6baVR1zgHvtknVlAWXa5B4/+M1XlechKhr1QAPG+eHeedcdwePYW952I4cfJta49h8mizMpexg9Asb2hJXE6AlVpvXnzj/xcPqpQw6+9ngHJDTF+YLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gdI2XGmE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j8sEZ7/G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gdI2XGmE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j8sEZ7/G"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619MLAja2021213;
	Tue, 10 Feb 2026 06:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RtCPdlI0jXYy1iAiKc1nXSzMbobXTOlB4f+K4pNw2G4=; b=
	gdI2XGmEKA2oL5ofWIS+cI8nVE0sTcYpkYyuUkXQTws67ubdJ5rxnxnKpcE2P9nf
	cJmAPEw0yf2iHzeC1M1fUfBrLa9mHwk8IY0stS35c6mtsNz7c+zdSdz9x9Py4PXj
	MPD9aticPyuYwQLRmvFWoDWhIMlGWywoywIF/lEXE0r6py0gPfC+8Yx8p/8X6HDq
	d693+lKewrKvIyTZKRxpal1xURQ55Wou0Dhh6wFxqN4DsW7prtmkuFvcFfeKs8XQ
	uyV/25hESJrPdE3i4YGQIxg52+6M7x6/6DaFXZJW96rV/t8DBFGKOcjFCnQSJxgh
	wAINJPDOSCZELYVuQhpX7g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp3ccy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 06:00:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61A3ERs3000579;
	Tue, 10 Feb 2026 06:00:32 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uue3s5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 06:00:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUFmcagjPDu64SKn8fVj+fHrzVb754ehIjs6c73XAaB/IFulIxdZKuyJM7thk95OX5tAaDiq2dP5AkhE0m+AZD9O2OYvORgS0Dcixcpls/fmQf9HZLhXAuw7fvRueVGhyHvkDZ4mPFWFwfTXRHLOrzDa3HRk/N0/9hYA7LllAypn9k/i4oSMKiDgV4D6IgZ6myqz4O5Ewc2PJv+1TvDHe1uNENCUC1c3LfHav+uj/cbcFXzzOZvY3Uka2Bi63b8ftka1/JJ4T6jIdDQ+SGEYqIXlPCkZZhSDZe3sx1fhvFL+xx4fDCuDNInVWMtRxz8Eji1whk5qMS7rrXzLysagAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtCPdlI0jXYy1iAiKc1nXSzMbobXTOlB4f+K4pNw2G4=;
 b=LjVf/VpX+fh4BA3w6fSYnNBW9xP4kYQU9NMTsCswHuXHAK7L9piYOjzRArFMOrWZxqwtuz2M4Ua3mj3efWxJHc64F7RKODJLSjrHJaBJL0gdoXwgwUIxCUw1VhM2jzcezFMok5ZKszaVRdIk3jk1ti2VWn82mQMe6dITFtPW9/ltkE5Mq1eDfwWaYNCS/JxcReIwOca5Fthxztujt9S/0qDtw9pWLuVmkSjSICfioyXd3rF4sTMKphxApRoveLQOgThqhhl10z2nb+RJaVdXffjhZZKpfMGCnyqeEGqC5oO0jUWfEZaFjh2g/+RPAxxKWvErcFkAp5rXx7N87etsYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtCPdlI0jXYy1iAiKc1nXSzMbobXTOlB4f+K4pNw2G4=;
 b=j8sEZ7/GON4edEdKnncYbOw/cHY3WKqs1aY0pKuFHhR0IfrcTX+uGTlMow89Wdbt1+xBRjuphsVEnN1lnFYQnmrNejCc/y4Mk/KEP7ABMkwiURxZUQGGJuTgFblOfAthGrItpiOUooVYrPOV1S7jl4oDIrzHVKnZPZz7wMilh6Y=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BY5PR10MB4322.namprd10.prod.outlook.com (2603:10b6:a03:208::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 06:00:26 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 06:00:26 +0000
Message-ID: <40cb7c6b-e48f-417a-8d34-2498df48e360@oracle.com>
Date: Tue, 10 Feb 2026 11:30:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260209142310.204833231@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0316.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::20) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BY5PR10MB4322:EE_
X-MS-Office365-Filtering-Correlation-Id: 91552145-c633-42ce-afa8-08de6869afae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk1JZGszMUk0M3V5ZkRuYjAwbGxIc1dVZDFYdzVQVjVJVElTdmlBUVR2OGc0?=
 =?utf-8?B?OEFhQzFRUjJBMzVDN3B2a25wT2xqN01QZ0F4WVhZUHo1TVloN0l3NWJvQUdB?=
 =?utf-8?B?RlE1S25FRVNQdjZLWWtIcXZTdGx5TXlKckhDVlB4WVpsamNHZGJVOFRhcG0y?=
 =?utf-8?B?bjlJMWpkZVVIRiswQ0U3K0pwam1CTUh1RVcxYUpnYk5IMDdVOVdUWHZFS3ZW?=
 =?utf-8?B?cGhlcXF5THdQdDhtVWozRmMxMkhtU01rOUFIb3dacFpsbFRDN1RyUzJ5bEk5?=
 =?utf-8?B?K2JXREZSUnloV1J1bU9ON3pxNjROZW5Cb0FBQnQxZ0lXYXdjLzJuY1l1OTU5?=
 =?utf-8?B?aHg4UURwTWFNS1hWaXVaUGVud09Nc0tBMkVEWHN5UDEyWXloeU5najhnYks1?=
 =?utf-8?B?SVZRU25qMUxpS210U0lnaFNQaVZmNDB5SnF4TDZZR0laV0xSWmVvb3h1UFox?=
 =?utf-8?B?Q0JJYjBnNFJqczIxSEJDYlE3Mk1iZ1FPQ0hMZTdvR3dUL1I3NC9qUVM0RHZ3?=
 =?utf-8?B?S1BqRUF6M1BKK0NINHJMRzdNNFhxekl4Mlo4VnFRc0NnWlJJdFBRQkxib0Jm?=
 =?utf-8?B?clRBWGJ2WDVlNHlLcllGM1luT2hNWS9DR3EweFJ5YVAxMjJOdCt4V0pWY203?=
 =?utf-8?B?ZGUzdGx4S051S0c3MU5rVHBOWFlFOHMyRnNhVlhJL3grYkxUV0FNdm0va0Q2?=
 =?utf-8?B?UUZ2bFFEc09tbXQ3c0VZOExhUXpZazc2bzlWV1VuMUhjaW52RXNsU0xrVlJO?=
 =?utf-8?B?ZlNNSForQmFuTlYrbEZwUlBtd3Q0ZFhKUkprS3VOdnhLcmJ4NzEyYkpPT0ZN?=
 =?utf-8?B?WldIQm9jVHN3TC9FMnJCU1BwVjV5d3pkT1F3K2FxVUNheHlxUTVPZE5zekZH?=
 =?utf-8?B?V3V1cGRPSm1pRkhmTy9RMVlRQmVGeUJtQk5EV0JFY25OajJmVGltWWNIeEVS?=
 =?utf-8?B?NDZocWZrRjV5K1FiVE5SdDRWMnpndGFNUm0rUEFJOHRodVhCL0FlT1FQdkFU?=
 =?utf-8?B?clViT05vRGROOS9sVGQ1c0RuNHA0TzFoS3dzQ2tjTmx1QmZVaTV4OVA3Vmk5?=
 =?utf-8?B?d0JydHFGZGI0aWI1djB5YWk5TTRJTzFzSndGYUw4VEt5Vi95UWdIdG00RW9t?=
 =?utf-8?B?L00yd3VoRXYyZW1vZG5QMG50L3lxL3pjcUtkZm1YVWh5N2h6NDhzaDFDTWxw?=
 =?utf-8?B?VnNOVi8vcVhTbmFMVE9QR1NDNjQ0RlJaSUlndERYQjdvTWluVC92OXpxVHVk?=
 =?utf-8?B?SHV4di9Eb0lrMWNWcjNITkI4ckgwME5DbjNPa0NmN2Q5OWJuMUdzTDhwb3p2?=
 =?utf-8?B?WVo3N0pDdnZVWmJ2aDJSRTNqaStNWVY3VWVTQ0dHL2hFQ2FVQ25lNm1seGdl?=
 =?utf-8?B?ZEMrcTBKNlRSaTMzbGhRY2N5S1JKN3FrdS93cEF1a0JqU3NaUlhBNGRQd1JP?=
 =?utf-8?B?dkhGbUJoL2haUWU5ZFhMb0ZQTm5mbjlKMHhqWXpVaHRzb1Vmdk8rMmIya2NF?=
 =?utf-8?B?T3cvL2QrMGFlNHB3dll1dU5pcHg2dEk0RzVFaTBMYTN3UStlTlVTRmR3TkJX?=
 =?utf-8?B?ZTBNYUJkQ002WnE2c3RnRlFGVTZhZlRKRzlOZFlLaysyMTNMVTgrYWN3SXIz?=
 =?utf-8?B?S0lmU1hpMEJqZlhUNFRyTWE2NnNrYVBYUktsY0VWVno0OWZZSVR2Z1B6dXFa?=
 =?utf-8?B?WTI0WWI5Z3ZLVm9qZjhmb1Q5aVJsRExHOWFGOGRRQU83YnZ3eExsY1BFbHFq?=
 =?utf-8?B?Nm1FSEF2ZlkyRm9zbGtPL2Nzb1FDMkxvYTVmdEdQT0I3WXgzb3ZRTnJHMVFu?=
 =?utf-8?B?OTZ1c21ISTBxSGtYRWVXTkUyeXkzK0JFL0JLeGtWdndZUDBQQlpIaDRSUVhR?=
 =?utf-8?B?d2ZqUmtjRUVxQk05VzZSYTFXYzRwODBFQWI4NGhQTUEyNGE2QmVyQ2R2Um5M?=
 =?utf-8?B?TTdGWVhuWm9pWnV2YnNJMFFYN0dUaUtBaDhCNytBcUJUMWViTW51VExsUG1J?=
 =?utf-8?B?WTV0VUdNVDdCNDc3Y2FvcUNjN2pwc2E0ekMzbHdyZXVleDd2UlJKVXgycTRl?=
 =?utf-8?B?WUtadlBvY1JDNDhPWWl1and3MkYxUHp5SUw1YXZvUlpwRUYySTJGT3BmMGhq?=
 =?utf-8?Q?GxAY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDV4cnpSMldiVStzYzc3Z1FaV0dFWVJscExZamg2bUxzTzUyQVFwKzQxN2V6?=
 =?utf-8?B?YTY3ejI5b1FYclhZNnJWS0dZZTA2WmZ6QVE1b1QvL0xibWRHQUlIWDNuM0Ns?=
 =?utf-8?B?L1lQd3F5UVpkOVlNM2FRVnR4cDdCd1RORHhSdzFkQTQ1TVlSVjdlS3ZkeUhi?=
 =?utf-8?B?UGU3VEJaaUxhWEdHM2I2WmJvSkMrM1k3M01waTJhaGZ0UHdSWENLOFlCWUpu?=
 =?utf-8?B?TnZJd0JlVndRUjFBWS9US1RVSWdVMkxDNHpjL2tRZEpmdlgvOUdIUk1xcHE0?=
 =?utf-8?B?VTlXSzlzbkwzSkRhOW1WTlNlVTMvSVdtNlJndG1udzJSNFpuQzhoTStpKzhJ?=
 =?utf-8?B?NXRjemtHTHU5RFJjZHIxaWxBL1Q4T0Ftc0MzQlR0a2ZVbGwvaDc1Qnk1Qk5j?=
 =?utf-8?B?VGs2Q0RlNGFMbVRibmtVYkJlL0U0QVZjT21vb0RFeFlHaVNuZjdsREFPelps?=
 =?utf-8?B?VE5zUDhwajAyQ3QxS1hnUnN3RGhPbWZyQ1JiWnNCYzE2bzhBcmFGdDNHRE4w?=
 =?utf-8?B?cnBsbzNWTktnNVp5dVFxRXNEVUhyTWZXTzBhQjZqb0NLeUpsTHM5N2ZWV2Ez?=
 =?utf-8?B?STJyVGtZZUw1bDZhZ2ExWFdRTzByRmJiNnk5OWlVTUZiZEtxeTJ2VVJ1VEtz?=
 =?utf-8?B?YXYxT1J1N0FSb2gyL0dxbUo3SEJLdXVQZURzbyswWXZkMjNldXhONWRKcXh3?=
 =?utf-8?B?R05aWlVXSEdUQVZBeGRHY1diREdtTTJVZkVCMnpzUVZCY1ljc0FSTkF3OHJt?=
 =?utf-8?B?aENsNkpCY3pXVXc1R1hiUGY5SWJnVE15VXVxczMrc3lKRktxTG8xSUx3NWU4?=
 =?utf-8?B?ampZVFQvWlEwYThaSEFMeDlGY1BOQ2tMdm05OHUzbHNmYXFSUC80M01tbjUz?=
 =?utf-8?B?MkpLM2N2OUdrVWdvRzk1WS9mT1FUQ3JkYVFLbUpUQWwvWW5FeEorTlY0Zktm?=
 =?utf-8?B?U2ZXL3JKTXp6Zk5pS04xdFNGS3NCenp2elhjaGFtWHc2TDZoT00vOHAyVU9n?=
 =?utf-8?B?YXRkV0plcU13dHpKZzRpdDdhczMrL29BYkQ0ZDBJVkJGK1VUOWp0NnRVeEhF?=
 =?utf-8?B?eTdvTVkyYXFmc3JiNUZ2TlcyRHRMY0dHMjhFOGduSDYzUXV5ZmpFUTNVRW8x?=
 =?utf-8?B?cWNzVEs1ZVBMbjB3L2FWeHhpNXlyVDBoQlM5MDJodXcxaDdUZkJBMng4eHpY?=
 =?utf-8?B?WGR0KzVOQTRDWGFLSUNsYU5kVWpoZTFwdHVGUG1rQ2YwWG5DVEc3ZUk5N0VQ?=
 =?utf-8?B?aDZQMmZ6QW5RaVVwRlVISlpaMFJqa0RmUzc3TEpsUU5tVTZJb1F3aVJ5empI?=
 =?utf-8?B?a3l3bkJEbTYwQjdQeXdLVVk0QTVWcTNBYXFnUWorY25RN3FpZXJlK25uL25K?=
 =?utf-8?B?aHFNVjBxdmhzUzFyRmhKdXdYYzNjQm40R2xTRkE4dnZ4eit3ekdTWm10YTcw?=
 =?utf-8?B?ZkoyZkNmOFNoeDFZZ2JGczNPMEtqRHJLbmczblIwaGs1amsxUm8rMWFrbkdU?=
 =?utf-8?B?bHZUUEpDTHRGSXE1MGxWZ0JlNlcvM1ByNWZOY1hmS3FTZi9WZ2ZqVWtPM1FE?=
 =?utf-8?B?T0N0RDJOOHY0Q1JrQVcyUExhNzJRaGM4K1J4K0xHNjdSVjE0MjlwWUZIaHpN?=
 =?utf-8?B?K1c4STA4S2RDbm1Qc2RCTGgrYmdaTW51eWdBd3B3b2tKVHhkTHA1aks4OGsv?=
 =?utf-8?B?bFpzaDlhWUQ1QzZSNlpVREkzV0dPVlV0WmZPWWJzdGJZWDhHUGRyTC9rRDNz?=
 =?utf-8?B?c3RQNDM3VVFuVzBTUW9oMk5rTnY1cWw4anB0cjloOXFKUmZSNk9oejlEK0NF?=
 =?utf-8?B?clcyREdYNkFxUEt1TE12eTdoZVIzT3RZWEU2THFwQlJBNTIxTjhnamowL1JT?=
 =?utf-8?B?RUtKV2Q5cWpIRUhkaXhBMTdYbCsxaFFrbnJqWS92K3RPT2l3bm1Cc0lwRXoz?=
 =?utf-8?B?bFBnejVHWU9NYUlLUXRxT0srT3puUklqZXEyT3hBbk1kL2lSUjNDR01rS2FS?=
 =?utf-8?B?Mm5RcU5SVVRLR284cnJQL3UwUnBOY1FpNkZNNXJDZXBNTm1yQmMyUkRtWHBJ?=
 =?utf-8?B?Wk52QWpCN0tPZS9VUEsvMEtpQVhLbzFOWkdyRTJJcytHSDdsN1FXVjU3bi8x?=
 =?utf-8?B?RXpOcE9WUjBscXpmUjQwL1E2d3FSRGIxSHhGMnc2MnI4OFN4NjBZSVRNYmRT?=
 =?utf-8?B?SW5oYU51byt4akFVbEFhWEg4NlNMLytuVlI5VFlCRWpjQUlMZDhWaVZCc3NI?=
 =?utf-8?B?WnI4ZjJydnJtdXJ4dWZtZzA2TC9Tak5FTEZFdWJHbXNhM203UFJKcklRRG1j?=
 =?utf-8?B?dEQ5VjVVZlNiUEg4YjU0MlpzWFgzdXppTXRYK0RmVTdrekhHV3pZcmxicFRy?=
 =?utf-8?Q?Rcz0hzzL6EKRgy7ajK0V5hUb6/eQmN2w8qoW9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+o7j+u9xkbCCLlp7hWVlCPZ4x6ti9EGJWxJwZkoAjU7mDNingJYRnjwcDtFKMPfO4Y3BdgI41Apb1+hHDwHbfxkBruFKb8jUlsFYzIxVDLx1V4KjnAdGEuOZfnw1KMFThpD1RiFbqdrPexHepy8GVBgZe1WZi/7Tqzeciy51pgWGyZ7BFZHH4HQM1u/9wCLTPj7fAGNvJ7VTRMXHh1uRgXjWx/5MQZI86+ChcEm6TW7Nz9Ey1L0leGqhcJ8o/+BVuX5gIffcIyHbgdiY1jkUGxwFC0lzaMqRRXyNPB/Cwzu12S1+UxEjyCX5R3oJZjUl18n+HRu9c9/RzXQexD7I+VES33EBz5roilqACTlEx36s37C+aRUnTsqhF5/pcb83bpd+O/qgiiCf36LgP/utNGFHr/bzEl+6eUQWTAv67iUObzp+4Rr8UHXXj5wrNMukKDs8KTrxiuVbadHffPuItsfw32rKKlm89MGWBaF5jHnGI8dI7eO6+lnauLBF+uh7xVaTaoGJ8X7CZ4bmNTC4YjcV2jEjvBuQY3GNzGLlgVBPmGCuunx4gvV8xzXQMXU5/NsZQSh5EunBO/5XPjKfCjIPgAmheBLGNlXiTB/RN3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91552145-c633-42ce-afa8-08de6869afae
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 06:00:26.3682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UADSlSS4CZvIAsmxHaqodUBQc60Xb+aGEQU9RnfyZXo7Zc8mly+PDZpRumi80Cf8xniQzCj1wZp+2vfb9FW5fi8RrBRRrj3DdbcOQD5iNBmGmPjVePOj9bfJItONeLQD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100048
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA0OCBTYWx0ZWRfX+QYDdFy5kAC8
 ULzmuAp7u/MnM46nbPZwS8N7tclt8ah/sMLjsmrDa8K+GaFF6ry5ZvoKBeB9X6zHEIC6el0W6no
 dOAD9D6Zl0gh+02M4hApREGzaugA7phtcuTij9lIobbvkoycMX4kaGM0Yz+aOqcDNpa8+gxIc14
 EpjYvHIhk2RjpP6MlIeBQ8rPr2Dmig/MXBk+Nf4gyN2YY2lp6V+TIowqtm75/fikhD3BNss+jfj
 39FWGDwq5NTyMESKhPAtXoTeX7FBXsy1hiFAmJqKmWSld8OGAMMcxTVM1+xNt5BhkbDtnOdFNgg
 nL4tU7VZlWBsZnhCoBPlaMUEzHnGIQQ0mBhyMSMRkRdW1jAkAFrsNr89BLoZcINBuyHUnNw+jQh
 o9caI7X6ZIp8A5fBpKnUjG/xdGAtK+pQO11Wiv4XR6cejARlmzMM8FzQjreWtWViBvns1USpB1w
 6RVqym0scmC8gEGmJ7xGL7/EYpimDtzfKFBgJTaw=
X-Proofpoint-GUID: oboVInyZa8diJKtdHKB8EnFEt2RleM50
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=698ac98b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=NAwWG0e-j77qbkYhR88A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12148
X-Proofpoint-ORIG-GUID: oboVInyZa8diJKtdHKB8EnFEt2RleM50

Hi Greg,

On 09/02/26 19:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
