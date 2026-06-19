Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B44C3233ED
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 12:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781871827; cv=fail; b=UrgFdqrjhfhvAlxI7hdZbtlUURLF5vsJZH+5Zl7Y3EiO4pJJtOrIo+eS+ytEe9V3jGbmUjm+0AHwx8ZL/kUIonfJpU35YKoPb4JmV1yzCKkDq4sGv931DIWrV6VDFePon//X2IxYwTmsDHpNpjFhre4bXKXDsIqX57FqF/ejTgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781871827; c=relaxed/simple;
	bh=TnOQEd7U9FxNvWLsi8gHQ6gpKuOoAVZa0AKfw7QsXxg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cXKeXfVGs0miZwdfuMfOVqStTjuSU3rmiO3KbvBhASLgM6zam3ABCaZ7To2yBOtwZb41xR8HSkVlt2v1q7vKiejTbfXjTN9HwXkEKa61CWmj6jOdzx8/jsr7dJ32vYPMMnxa9pK7hTCOTKTb6EQ/brE9j5JmlnYKgt7bUjPET4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K8UrgOSi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u08rDk97; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K8UrgOSi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u08rDk97"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ILUvRF1347429;
	Fri, 19 Jun 2026 12:23:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TNu1TwiIxa/mKDc+qEr9a7tvMrSAUefLrNd8+MvG65Y=; b=
	K8UrgOSiAW6dN9d834BFUqg7evVrS9yUEtylEEYOfup1EaRBDFmCEAL2esvKDw1L
	Ck9gn3IKCDysN6dV4arWNiLtuN50ZWkv8G7hQJhyzhY5GY7AnEHTi5wtloMFiZv+
	Q3Tj2ele0qs6p4j/VmVCPXxa60+CDLg2W7EABeibkoB0+sdlc1EoZrlhmAe2erUg
	APM32TsCn8MtffKutGzLPGljskQIYuvSa92Z9GRAXe4nSGtrgD1bYD91PtKcTtt/
	INgHxbuDnbnFXfzTb67qcBZmIhoUpbGK0ffGYGu3C2ifd8Zv1RIJe+OG1cUEFt90
	gdWh3uJTqB1Q/TOwdpGp5A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euegm42dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 12:23:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65JCNXE0025175;
	Fri, 19 Jun 2026 12:23:41 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012032.outbound.protection.outlook.com [40.107.209.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ev1bs115w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 12:23:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlTFA5EawcE4J5iG9HV8goezoikdDkNMaQVuFe7c4gQCDjLBYS+bk3egoSLC2K2BocxYkkS37FVzgEa9ICj7U//V3fBa+Ds7eHzur8vqXtqY3ReKYwci3NFWXc3X8v/evSb/CF1r5Nu3nUTPo2/wlfjEiqrBchvYWS9y8M+lOsKI9lHuVNUPPomF593gnJA+HLw4vsFxinFiDGMDZc7gIjzWeZbsnzCekfVV8/buAlA03LU8eClMrO4wkPTivNvabpIL6EnUR6Sepw6/iRFtYElqxQ4UAq5KlJOMkVkhVgNhXhzNT3UQNMAV23/6Slmm3mwj9qoaoGuTdkTGFQmxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNu1TwiIxa/mKDc+qEr9a7tvMrSAUefLrNd8+MvG65Y=;
 b=mMZ5vPKkMl6OBJaZXnXCZdfaMO0QyeYdk2BQ3UUf4xZqr6sO3yPoVXa4BOfwg/1P2ZFbF4EdynnvUG6hxSCsQLalS+hBbCLLoAIMQqZ1H3jUmLMcHH6c7rqE9eGcNOE7IfBeFdZSqxT6dpVct5O4ZNOnvOfvbZMhwO1n3TdfWOyvKu6SzS9aO/rwpXGBEXwrL4919X4oGZWcZy4biywbMYcCsU3FRvIqBJxTvuMFd6XF8fpuhVyx3BwbxsoC5J1fL4pvrCmRz6YYsQUlClhMZIZnGeIx2MUB8p6MqlMMcd9CUHK7pvWy7JhoA01gXfQ8hJ6Kno2HYcRv0oHuPWmByg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNu1TwiIxa/mKDc+qEr9a7tvMrSAUefLrNd8+MvG65Y=;
 b=u08rDk97jItzU8rSOvS8N6Rb2TmUgwTr4ep7kHAD5NTNk4eVE17bmfod4GEZVS1AQCy6EJlkXjvZrv32u8s5/gCIRKUzpV0myz2IuqImoPyePzNzEWm9wx6md3vaMmHAvg267Vi9DOsMf7lAWGW484+76zun7whzwFboV6cVOPU=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MN6PR10MB8143.namprd10.prod.outlook.com (2603:10b6:208:4f5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 12:23:05 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 12:23:05 +0000
Message-ID: <e9e46186-c70d-4cbf-9e56-2d0dd9d49eb4@oracle.com>
Date: Fri, 19 Jun 2026 17:52:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 278/411] net: qrtr: ns: Limit the total number of
 nodes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145115.910988114@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145115.910988114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::20) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MN6PR10MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: d4d59e9a-32e6-4c99-324b-08decdfd83da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|22082099003|18002099003|56012099006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	iSB7wR8s8lBxcVcqCJOCOYKsHhfTDGZhOJoJSsAO3jI8TIiT8I138YnmcL9CAOnvTmtkIAQo4M2ogVuEjn/ffcPenxkpjieyO9U3iYGnRZbXWO00hO2RiNF2QrXamZ15tJGfR/RpI0tHcwUPuAnFdVCzKInLK2iKy+0vFzG392GirneJIyR3KPMk5r+ddWNX3An9PU4TDgZkR8OxoxfqFtnz5y+qKaYOkIlOS9Qfbj5+556/JAPUJm3JHMFh/XUMoSHoAtJGToPQSekxyXlePOXpmaa4RA5GD4sSFxijEFrfWl3ru7weQsWXxiLd7OHmO2oKqSanvW+Uwll/Ieid6f5k/y1qgyIKS0u2T2mdzWh6i2XS1sIvYFQNqsyqeH7RZAqPkgQv8qhTxN3HMp3U40vlPHyxefv6kjrjplK92mFff8dPjmJSnXRCE3C+g4nEsR7U6SqOGzjKboNeuqlINlFhm19XFRZ8ox62+CkjJ9cNYTtqGltIzMQyj3PJrS95TuMW/KFWU8cVf7I9kglPrJTHGhfP52jLH2HX6pIB0B4MK+qHj5duPVDm2HE782biFUZR8oZ03AqjAFHnhOPDFQzjB3ezkSIAJR1hgZqSvORWAqgXADXzRu9ddkmDjpxY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(22082099003)(18002099003)(56012099006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXlURTZqMWdicDZueDJkZEtSTjRnSThQOXI4bXRxSmIrZnU5cTk4NDFoYVd1?=
 =?utf-8?B?QTc0ZGM3LzM5SEZkRXpwbzY2THJZblRYNHdvVi93ZWQrRGYzaC9ZVVo0MWx0?=
 =?utf-8?B?RW9oZzd5M1U4ZXg1VjNpa3h4UGx3RHAxMTVWK2o0T0FSNVFSRVFhYTA0ZzIz?=
 =?utf-8?B?TWRKY3pNODdRYzUwMGo1aW9saDFTV3p0LzVNdDN3czJZeFJnMVhMWEkrVytQ?=
 =?utf-8?B?UkszcDU4SStLMEYrODJZWC9ZaUlSa3M2bE52U0pDa3VyV3Jub0dBRUxwblov?=
 =?utf-8?B?QXRJTEhlbWErOEpxWWx5UXJWMDQzUjdoc1AzZ3ArUDgrbXNqaDE0WTJ2Z0tZ?=
 =?utf-8?B?Mm96OUhpQ2NWUzJHREEva3NNVXNKSGk3S09LWnlObnZ2WWtXdkRLTUVYU0ht?=
 =?utf-8?B?NVFRWUxIQUtTaXFjMU14dHI5ZlVSWVZXNHIvdnYrNHEyN1Z1TWlpOVJBV0pX?=
 =?utf-8?B?T0ZIV2J6c0NlMWhVTlhQM3JOekVCUjNzcGUyM1RzcFB1d0EzeEordFZNaWk3?=
 =?utf-8?B?U3AybS92eGc3bTVESGNOWmlYRGlnem1WZk5ra3JEV0kyYVpCN0gwZTFDTmcw?=
 =?utf-8?B?RkszVDVzSFAzUkhGVkpvNE5KMUZPMEdHWDhUcEw0dmJyT2Mzc2tsNWRuNTdX?=
 =?utf-8?B?bUhSa2FwK0Z5U1M2ck9NQXRGVE8yaG5Nczkwbmxud0doSERMTUc1MDB6UjBU?=
 =?utf-8?B?Skd5YjV3VXFadk96TXc3ZU94SGVSWklUdHV2ZDZBT0d0V2pXRXJGREpCdXlJ?=
 =?utf-8?B?S21DdGxaUHJHeGJzSHg3UnRJM3J0N2ZMRU5CT2RnU3ZXMzhrNXAzYzM2TTE1?=
 =?utf-8?B?aUFEaG81MFNDekR2K1E5QnlHeWF2eGxTMFpkRFNhVklOR2YzU3IwNGhReVp6?=
 =?utf-8?B?bzFoR25rai92OHgxcnBPQXk3WWZkWFVzVm4yNDVRTVQwUDdqMmdVT3h1dGRr?=
 =?utf-8?B?TVRIQXFSa2VEZk1oVHREVEtYS0FTWUt3dCt6elhlMnlLN1ZzbjA0T2dtU3M2?=
 =?utf-8?B?Y2hUY3FYQ1NFQ0xCSmZ1R1ZRWEF2TGJmYmx1a0RMRU5FT0YzMzROTnhadWF3?=
 =?utf-8?B?MTE4L3hBOVVxekFOUmxGelhxSWRCSjB0ZGw0OGdMZnNDdjRsZDRPZzY1TFR2?=
 =?utf-8?B?NHM4d2oxRmRmZ1hKTC9GdkEzblpXK0xsNjlqMDBLbmw4MGQ3Q01NTFJ2S2RZ?=
 =?utf-8?B?OXFaMHJNYkEzUEZmTXdsNDhON0t1aGpibkk0cWE3emdsOU5sc29Ld0RMaHVP?=
 =?utf-8?B?dUt0cUYwY3ZWZTdsR2RvWkdZa2xuazFOckdhUlZ6eFlTVmRXdStsSkRzUW4w?=
 =?utf-8?B?V0tvSlJGNG0wU1QzU3kwdlUvTzZmcHhNMmxVTFRLZGJiSE5peVpoZ2Y4MzFp?=
 =?utf-8?B?WHQ5OVpMZ25KR2svZ3d2ODliQWVCbUMzWU9RaklHdHVTMGtnTGQyMW85Y0t2?=
 =?utf-8?B?MEdrT1MvRFFxWWFmYnFrMkIvV1ppMllybzJCd2VFc2grSXVhMTFBRUtGeGdJ?=
 =?utf-8?B?dWw1SEd3MEJRaTNiaCtlMVFVRUQ1RytCTUhPdzFIQmxjSk9KRm9HamZlQnph?=
 =?utf-8?B?M3RQZ1VsRExsMzA3cFE3V1g3akhTNXVXQmpRL0dEbVlUbDVGc3BwT1VyYWpH?=
 =?utf-8?B?T2ZUTnNBcWQzOUx0UlJCaVYzNkk4eWovQzNnK0VkZ0YyeUdWdnNtM2xKY0Fl?=
 =?utf-8?B?SGVEUy9xUjZ2SGlqNnRIaCswa1dnWHJTVm5mVDh1WWswVVJvRmcySGZtVWg4?=
 =?utf-8?B?TWdIMnM4MG9ienJvZ2VlVWhVMGdmOGNoYkRuaVpTSGQzUWlwcDMySDQ2bGRD?=
 =?utf-8?B?eU9BWmtSQVNUNFU3UGxPKzVFaGJkcHpCM1RvL1QycXFmenVMNVZNcWJTOWFx?=
 =?utf-8?B?ZEdYbHMvNlY3SlVCVzg4WEtGRjVSelNDY2R5TlFFd0RKd3VpSGI4ZlBHczVy?=
 =?utf-8?B?LzcyZ21QbW9LTC9SQi9ReSs2UVJWUXl2Nkx2L1ViaG5iOXF6UzI3YTZNQ2Zx?=
 =?utf-8?B?MW1ka21GNWJmK05LYm93OE5IRlgzTTlIektNRDFsVm5qTUFVeVFQTUJjL0FI?=
 =?utf-8?B?Vy8yK2QxR1FrWkJmSEFVYUkxeFcxMmh5K1JiUG5TQnoyMzZhRlV4S1BlOWVC?=
 =?utf-8?B?UVFqNDJKV09mR0t0dU5jMmQwYkFqNWQ5TXBrQXpJTm1yQU5ITC9nZ1B2d0JL?=
 =?utf-8?B?UlREZ1cvSzFTZW1vMWJaRm9rWHBtUWV3SVl0RkNBQ2JtZzU2M2w0SGszQmZp?=
 =?utf-8?B?cm1RS1dscXN3a2JXb2RSVm9XblVON2paN0lnYWo3TGhTSGVFbER4aXc4WjFY?=
 =?utf-8?B?Wm5JeFhhaUlFUGlQeEZ6ODBnWFBvb2duWjlzb05tdmNyQStlRGtoUVZpR1Rz?=
 =?utf-8?Q?ocZOHgnV9LGDDJhpiQSQr7IoSKcEy8muHHA5b?=
X-Exchange-RoutingPolicyChecked:
	jn/+yW+RBvlfSdiVgprDxWJThFpUadHHksJC+89NefH6eBKFhanGRZ7EAEFfPFEhrjl7ihc/EC3JtZHad/jX1EKAS1v2oi8DNqzRa8zBCE/z+m3wK0BvK2NLFjbmaqxwmFESI4bYVCTw0TzHazjKj5QihslWH5ZNpMF7Tw+bAYMpsfSVYyxTmz7FB2JUmq2A/blsp0FR+fq+Tq4D/fVgLQxXDZKhbvNbqV2Y59ss1aIlYVHrk88ry8Bn7pnDp74TRIejIHc/GBg8KQFwZZyPpbTIero1gMvnczPPd9v8NiunIrdJgSEzvpRrAox3CZhy+EBZ9vd8s8pBgoHLYa0AIQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ju46OAHsZXqzttSRurAo86SvF1hgHcXP+M0IHJXNU5zUhiC21I57Hu7nE2O3syhVDATnor7+qrsOWruLdv74tzSuJYgFmR7hdw7hm1EEtebTyELzRMPNTPh1QXaJaKLFyoPKridxSt1OpJFz9h2rI7+UCJayJPhYnWNrgG/vcZLFL4DBcYon8D+2RkYFr826dM7PNBzSqkLwRYdJr/mMR0Jt/GIa5yFCQI2htsWI4GrV4J3U7/HPdvFVLCYv2lnoQY73BKcbg2pN6LAQMWarjStzLI8lXmOfVO1fltJI7q5bIPlObDv7icliCIjPkSjZMrf1/J8/BWW2VB52WblsfYw1mEo9UZhbbxdDiWiyr8241vrZOqTO+5FNZDd3Cxn+6uzKZr8W1e4UcpDRNZCWTxPMDV+N8GSSAh1SKLcSUAG8HzHsdFywwRkndZaS+QSQ01x9Qhyxg+azqWSYcbEa+j9uqXU35oWAkUDyam15q72mHXhOpi5JUKZmvqyZJ8Z7BbFTmbWtghAKB7+SKSKlUxluNGpzzm12aIo1aw2LtfLJY7i6lrU4llkpxNgBTcHvYTMlwyCRufHODqnr8oox3v1srWKmgfdZILId6xUgw6s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d59e9a-32e6-4c99-324b-08decdfd83da
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 12:23:05.7015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLFoPhgHk0+inULsuXzHGi0WwSJnAh5UIPpVsejuMYwGmIYRN6IMafgr3s7aAr0O4GbqGFr4SBQlkb4niYoSMw+wqhq29KK6Llh7mfEu8+D/+KVlFN2xSsqJJZ2O/88M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8143
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606190116
X-Proofpoint-GUID: Xmjv5xyBM-21oE1osQV2ZVWgShCFQP38
X-Proofpoint-ORIG-GUID: Xmjv5xyBM-21oE1osQV2ZVWgShCFQP38
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDExNiBTYWx0ZWRfX9k/PnPVdF3kL
 PDO5PxrrD7boyv5+hK+/wFzzb2GPEklghar2Cgb9MUOY6ryHntVpi9ff2rEgtjwQn09vhcyRxj1
 qYM0jILEf6hYFmuFf2KzHJGexvmRNAYynHnudn86wyyGdavoBB5fUr5rstgwry5PpJRGjLge+Fu
 BReZDEWP+Bq1eg13/6IfFWrEvXspK3Q9bL9QtzdeiqPkMPVuyoa59pCdEzIfGJDnhGedWml7XZv
 KZUPGdc4aDN8OTjMT0Z1RS8///HPn7qn3pzFz5x3mPVwyvWQ4oFtV9/k3hkGgQs2Uq6S/wZKXJs
 JH9T4K603YkRvLpMga+5SY8W6gQ9p+tos3HAGNkXl92hg8aexQkVqlfO2apZqqD/2NRRBcoR5vf
 fsvBBhwbBoX3otRnICy4uMy/C+D+EEU5zfCjzEbzwFE7Dp29y0af4vzk9IOm0AZDWKenR3z2qnF
 d+4uJ1vgQ1BfqJg3451xdEZk00LGR8SilUb3q2G0=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDExNiBTYWx0ZWRfX743ZwQSNZ5KM
 YBLmcnEer0SSltQ+9MbtMdTPU2icYo+kqM+Fy3dpAp+uX7h9LSFZvupeMhLvLeyzux+fF8K/OuI
 UJo9H0TrgWLetJFxSyGn9nmcJ6hGZiDyqvraI34A3SjsTYD7oEU5
X-Authority-Analysis: v=2.4 cv=G4Ys1dk5 c=1 sm=1 tr=0 ts=6a3534cd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=fju4ZQ20zLSiMPiTHuQA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723

Hi Sasha and Greg,

On 16/06/26 20:28, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> [ Upstream commit 27d5e84e810b0849d08b9aec68e48570461ce313 ]
> 
> Currently, the nameserver doesn't limit the number of nodes it handles.
> This can be an attack vector if a malicious client starts registering
> random nodes, leading to memory exhaustion.
> 
> Hence, limit the maximum number of nodes to 64. Note that, limit of 64 is
> chosen based on the current platform requirements. If requirement changes
> in the future, this limit can be increased.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> Link: https://patch.msgid.link/20260409-qrtr-fix-v3-4-00a8a5ff2b51@oss.qualcomm.com

I have run an AI assisted backport review and I think what it spotted it 
accurate.

Please see the analysis below:

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ dropped node_count-- hunk since ctrl_cmd_bye() has no delete_node ]

I think that is added in PATCH 276/411

Upstream 27d5e84e810b increments node_count on successful node creation 
and then decrements it in ctrl_cmd_bye():

delete_node:
         xa_erase(&nodes, from->sq_node);
         kfree(node);
         node_count--;

         return ret;

The 5.15.y backport has the limit and the node_count++ on insert, but 
its ctrl_cmd_bye() delete path still only does:

delete_node:
         xa_erase(&nodes, from->sq_node);
         kfree(node);

         return ret;

So every BYE deletion frees the node but leaves node_count elevated. 
After enough create/delete churn, QRTR nameservice may likely hit the 
64-node limit even though the nodes were erased and freed.

I think 5.15.y just needs the missing node_count-- after kfree(node) in
ctrl_cmd_bye(), thoughts?

Thanks,
Harshit



> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/qrtr/ns.c |   17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -75,6 +75,16 @@ struct qrtr_node {
>    */
>   #define QRTR_NS_MAX_LOOKUPS 64
>   
> +/* Max nodes, server, lookup limits are chosen based on the current platform
> + * requirements. If the requirement changes in the future, these values can be
> + * increased.
> + */
> +#define QRTR_NS_MAX_NODES   64
> +#define QRTR_NS_MAX_SERVERS 256
> +#define QRTR_NS_MAX_LOOKUPS 64
> +
> +static u8 node_count;
> +
>   static struct qrtr_node *node_get(unsigned int node_id)
>   {
>   	struct qrtr_node *node;
> @@ -83,6 +93,11 @@ static struct qrtr_node *node_get(unsign
>   	if (node)
>   		return node;
>   
> +	if (node_count >= QRTR_NS_MAX_NODES) {
> +		pr_err_ratelimited("QRTR clients exceed max node limit!\n");
> +		return NULL;
> +	}
> +
>   	/* If node didn't exist, allocate and insert it to the tree */
>   	node = kzalloc(sizeof(*node), GFP_KERNEL);
>   	if (!node)
> @@ -96,6 +111,8 @@ static struct qrtr_node *node_get(unsign
>   		return NULL;
>   	}
>   
> +	node_count++;
> +
>   	return node;
>   }
>   
> 
> 
> 

