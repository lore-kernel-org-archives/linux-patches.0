Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9BA3E49E0
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784904121; cv=fail; b=XTHahRLt+1EnlY3upSUwIKcwBlDkPxj4dFYY4e/kJORDDJ24fh9ZQKcRhM1tHqpLU6hBXuOeHD+js+g4JqqzWCnhJBKKxsiyogJFtCprb7+rZLA1olxf/v6o+g9v4ccsfRWuTjur3gRb8x8QiX/hO66VOAfO1J6qcrA9hPDwtS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784904121; c=relaxed/simple;
	bh=SY/en/P8dXIEOvNlwn+dnilpNHwsbFzOz9tigH2JfQA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=on9n8w0ipNCHNbweG1kGtpXkisx2PrrkeYSllNASnjqE+UKdISJy3f5w3J55lqp973qK0yHTiRfUcaj4WWtNb2SWjs3GtFxRCvW1G7x2vK3qp+DUK4L3NjP2trptx5zEcEY/45ncjQLIYhwNtZ9CgGbNkeaCn9js6O9S1vOGkZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=PvBr7vcs; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="PvBr7vcs"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ODde151733073;
	Fri, 24 Jul 2026 14:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=CjI+LamdKYH0tqcOni44XtSDR2Nyn7LstGfo38SUiP4=; b=
	PvBr7vcsQdLnZhVtlQx/zOdq3kdzt9a7KFOXtGywB82XAu6aAHYTbTt+wH4s7H4H
	QttjlzUoNr2rv8fT0pfIXhkYPiFSjE5o3kC5xvhZLGLJXbI3iOduE/cwAZ1xy6y8
	SEIxLKmJbtVfXjfkqJoatBENztbyjk62xRzM+XqcvocQzSm23j+C3s+Wqbk1fk2r
	qLfOZ+1UZyal2YNl8RDBRQ5hpC06P8T9BaGJRdIh0yG5J5sOwrhLu7gZ3p2vMZNI
	YsAb6Rjf04yyFLUCrdOHn91vXvDrfHA9yX4OREd2Pn6dyw4NgcWHqpDvf/2IhLfe
	MoIV9gRMTlX0uLWVJZlhGw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fkdhy2uws-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 14:41:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=idafZUwnbi5VkXjUJgKqvjKWf0mswsR7w6sZiHkAyuIywcbAbV7JOpRvHo/TLVg1ewMJeqYVPewolfRnVWNozl5Q207FMXlEpmkDVTrps64HHCunyWUi1AojFWXeHfaUi7/+PPL1hnSPH2fjN87tADfHty0moKuplnkduwM480dwqxgivp+8V0QWK7b/249+LyVcjYInlu7SDVFro7XaN9e5fSOwwgUvrnoQOpwGDK7eOhJEBLdAoxJPzFYzGDFsuISfHTpFUXm30HibHWMYCdV46LpCgivZUXvsVcNYvTyUuXIRDzIjtLY89s5qnWPSh3Uv4ppxWY9lFmfsXD3F5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjI+LamdKYH0tqcOni44XtSDR2Nyn7LstGfo38SUiP4=;
 b=OghpzJAgl9THQy5WUpMU6aPrvNNUdMeFSZmDq/NSRn2WHhfwDhwVG3apk5lT/Dtcd7CyvN4KV0++ulhW4Kk7+a2Pp+4Zs7HWO2LqPCU0fVl+YucGQbl86ql07/EgbMK7yfzhQY08jkij572OV93XYImcHWrQg1Sv2jCWxJdIPMvPJbQYfmANTmTh1XzXzDHH+jTVxdXIPKiAZPmjAqALn3KUEqazoRM5rQ2lgYtYvjviyLAKQZTDLgsmb6ml83OPSrMvEisSfaFgchwpzOCv02pdxQ8iPr9v0mUyZrqb39OscJ2+t2XgFrt0JHFDIHfTUFXfXG49YMnX6UMp0PvTQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH0PR11MB5926.namprd11.prod.outlook.com (2603:10b6:510:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 14:41:42 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 14:41:40 +0000
Message-ID: <bfc12e30-d6d0-4940-a1e4-353ccf29d5ce@windriver.com>
Date: Fri, 24 Jul 2026 22:41:26 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0309/1276] ext4: validate donor file superblock early
 in EXT4_IOC_MOVE_EXT
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152453.007613078@linuxfoundation.org>
 <79f8b3b5-bbdb-415c-9211-ae1858cb5dd5@oracle.com>
 <59dae82b-5307-4018-8e17-8bd447b7271e@windriver.com>
 <2026072404-bleep-expensive-5cdd@gregkh>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <2026072404-bleep-expensive-5cdd@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::19) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH0PR11MB5926:EE_
X-MS-Office365-Filtering-Correlation-Id: 00e24418-7d47-496c-ee3b-08dee991abe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ObIkyI/XAM+fieGb6ZDZ0VFgn9/kPosQGOyiZ+be3XPTj1ZQSCr8AaQ9ewl85lahbZLbcDIlKyv1f96585ESqhkhBOmg5Fd0LS2vq0ryVWNDwXAX1kAQ7K4y6LnKJh8L0Ac6DQNMC7nAsv9NMK4GFHDNAf3TEM95x/7J/qsfsWglDkgk3cXUpr4Ou0fBTni90eZbtJdSn/b6RrCeIUTf7z5f898dMg8hLt0od1LEdJy4P9clEGYVzEcur4s1y9EpZj69sGbmuM8TJoDaFspgm4VFrPiPzgiVdi51aoxCpN0mIsGDPDNnwpGBFxOAdRMZyXHPOYyjmfhqKa60RX9D49bMHBfOPUd3rP36gxbqx0+4sGovm0f68Shk7r5D8g+um6ajy+LI16jAOHnraJVlBiV1k32rAWxqavFpcr9L6OtwefGswBN85WBOpCuO05dMrmhoP41iX/c4DgEuhEm5rGkHB9KLKwJ1ET/+VDl/Nj/oHbnb3M2sG3a+eWCSgcTKAqTr5jJMRNtq/AAADFOFg3NU9kEMbJTrCfvj6G39TGbilXLx9LBYXuj6xiz87h4olkemfuf7KMKRW6t/kZBaOhWIu5+D7x4lYrsEzQgVRdLmitGbULurWoD4fZZvEqi5iuYyv724aVH/EytmvSD9vNdOlYWh2HUTq4BK6PkoHnk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUxhRFVXZDNKZEFPdTJUZWxvYU14SEVNeWFKTUVweU9zS2E5ZWtMbDQrdmVB?=
 =?utf-8?B?OHhIS1dHbzJvd050RDRCQU5mV3FwWHVOZHZBS0JBTVppZ3dWTXpScGdOSmM3?=
 =?utf-8?B?OGMwem1Bb21VWHNuYjRwQmFGdk5PWDF3a3BjNVJnS2padStIYlpMckxkOHV4?=
 =?utf-8?B?Z05aekF4aUhaVmpJV1ZmcFlyOWZhb2tOV0FkbnNSczFtWWM1SUFBTHpGK3BH?=
 =?utf-8?B?WjNOUlVjVWhCcDc0ME4vOHNPS21Pd3NFa3VrbWFJKzE2QUZMT3Zka213OFg4?=
 =?utf-8?B?Z29paUlnZDRqZ1R2MWNFTWV3VCtsWDFnbkt5cHJ0Nys0OFgrR3lDY2x3Qk11?=
 =?utf-8?B?K2R5MUk4RW4wQ2hVaVlqMkVOWFkyR1MwZS83cEIxMmovYTk2RmVnN2x3b3Uv?=
 =?utf-8?B?c0VSekE5UW5jRklHVmNpUWx3NlVHZ0ZKK0xvc3hzTmtSWnVuYTExYWE5d2hu?=
 =?utf-8?B?NU05N0cyTXJiVEVkUUxUL0JDaDF5bWVJMGpBR2hMYzlwQmhoSFhQT2R4ZFhG?=
 =?utf-8?B?bk1lamZyVTZrUTU2N2dPMmtFTWZ5b05xTlhBL09YdyttYlBpNDJrZEE5RjFl?=
 =?utf-8?B?eVpVOVpDaU5VcFA4QWoyWFFBYkEraWpLZ3Ixb0dDVXNVbkxUK0lMKytPWHVC?=
 =?utf-8?B?Y3Z4MFpPSjlEV045UjBjbDN6VGxQMTIxV3JpSmN3YnllQlU5NVAxZTEwUlJV?=
 =?utf-8?B?Rk9pRkk4OHBvaWJNUlpENVh5OGtsbEFhTHE2SGszR2g3MWJiZS9DcWJsRzdV?=
 =?utf-8?B?Ynh0WjdrUEtHKzBLaEJTc2VDeUt4QkV1VDI5aTFjeWJ2KzZocThaKzBpVGNM?=
 =?utf-8?B?N2JkVDJuTXU5ak1ncEdHUFp4aWc2K0JaQU95ZURPMUl5ZGFCbnVGU1psWTUz?=
 =?utf-8?B?cFZWVi9adGVNeWtMZXlGMDBvekJ6aXIwTlNNbGxyWTE4ZVFMT3lvZUVUL0Uz?=
 =?utf-8?B?dW1BQitUWm5SVzVManYrdEkwMyt5MWI2ZEJ2ekg1UGxnbHlXZFE2cFdrODVa?=
 =?utf-8?B?ZHZCMXJtOXJYcWJWaEZUYzZ1K3p3MkVSZHlZdzJ2cG94VHlhQVNmb1BhbE42?=
 =?utf-8?B?b3hDSjQxMXo5SjA2aU14c0hkZXNaT3JnUVk5MUdNREpjdmxoRSswTXlJbWhq?=
 =?utf-8?B?N0V6YTd0ekFUZ1dRcERyN1NrSUtveXlqc3JudHNBWlA3eTFsMmlsWU8yazhP?=
 =?utf-8?B?Qnl4QmdlY2Zrc1JLYm9XY0luTVJKSW1JN1A1YUdaUk4yaklueHUyNVZ2MmR5?=
 =?utf-8?B?eTNtZlhaTkdVWXc2YjZzKzdTVDllblA4b0hHbkdXTHRoTFJrWWdiaTVHenBr?=
 =?utf-8?B?TjVyOFpQVGQ2cWg3WG9BNHpTbVBhUzhpNVB5VXU4VGozZWFzQjVsL1hnSzRv?=
 =?utf-8?B?RW05b2h1NmVGS0hNeG5EVzdlcHoxeVhSVGdBTVM5djM3OEpMV2FsanQ1VWxN?=
 =?utf-8?B?MkJqTnBvQUhUd2dodUZHSTlybjJTSDFva0F0akZtYlBKVzRsZTBIdkp2Zit3?=
 =?utf-8?B?Y1FqZktrZjRDODgrRzRyNEtNdEl2amVqWkhCWGZKVEh4MUhmcnRyN0dMb1RE?=
 =?utf-8?B?QVBsbmFITFlOTjdJekQvUlpNOFFNZ0I5M2tSc3kvRjhPaXlBcXFldEs1aWY4?=
 =?utf-8?B?OFJXVXpKUVI0Y01yeW9JTklOR2Zzd0ZLdEtDNnEzM2NRQ1pETEpoTlpsTkdh?=
 =?utf-8?B?Z3BVQXBEdnNNQkR2RGF6TlNYNTJMVnc2bXhPQjgzN2RGc1BaQ0Y4amdWV2lS?=
 =?utf-8?B?a1crQTE3TGlZY2FGaGtuVTRwWkYxOFlWS0xiN21TR0Jwam1ZNnhrMURXTzla?=
 =?utf-8?B?eXNxTUhPMGwrUmxRczJ6R1l6ZW81Q2xzaDJsbFZNTXA2cE9RT0VVQWMwWTJ0?=
 =?utf-8?B?eUZXZEY0NjhDa2RHVGhTdkgrUWFXWkhmbUVCam95WTVWMHlTSEN0TC8yWkQw?=
 =?utf-8?B?SU1UUFBLdjZ1U0N4Q1dEVnNjc09LUVp5YzFBdEJUeFpmd1MvTUhIRGdlbnRk?=
 =?utf-8?B?dmdRTUlXTm50TFFaSVFkTmJrQUEyVU05Q1lZa0JtSlFZbHBRdmp2US82Q0dV?=
 =?utf-8?B?REE4QUY3eVZ5L2xwRHRnMysveHFIcVRkQWxBQTFCMWpRcnRsNzNaMWowdWIw?=
 =?utf-8?B?MmtZUG41UWExaklEWVI1WGJTWklNZDNraG5xdnhyWmJsSUxzMUE1ekVkK25u?=
 =?utf-8?B?WmtObitYVVVHRUJQdFE3LzE2bCtMM2tnSmY4dCtUTUdnUlU0NURtRzc3UVlC?=
 =?utf-8?B?MEFpNWtnZTIrWFgydElzSk9nTWtPbVZBZTJWOEZKOFlSTjIxTXRzSzJQbW9L?=
 =?utf-8?B?clp4OXg5QytNV0tmc2h1dC9TYitPYmRRaGVwSVM3eTRXZTE0dUUyZz09?=
X-Exchange-RoutingPolicyChecked:
	YV+xvoM/F2SIMN2wYBmRuvTw5/fb91kMlA5GHTu8cS3okjyMKGEIJnvW8d2f/9PwEn4ASFJ8t+1EVevs7sX/ILU9x7OemeReMXhlqZKzV0L5WnQ72XHWNvNOa8zzJ/XNdU/NFIheQp8njhMlBlhuNHyYBXd4ERKOcj5bvqlDAq3e2JeZL3rjBV2CEvW4QgNWm4jv4jVKvHd/pZY1FvjOrg6jNnV5FYAPsCZPU6nQUHyY8NbhIQVpzeS7xwQ0ElZQ1nWvhCEvLTXyGYPPDy9iVVQ+59Z+UIDfn6u+rpmI+TEPbNAuLmo05k7o2zENC02gnlAbvuYHFHtS0KkZxa3twA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e24418-7d47-496c-ee3b-08dee991abe8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 14:41:40.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZt5YAbCMrbsWheXbwi0Z/NBskpDdWp338xr8wVw6eC0rmrQuW+hs9pA2WBmvifC20G4XZlyLr38M1EvKQjwBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5926
X-Proofpoint-GUID: NXLb3uM6ANmcr-AbQSZxbCGsyt_PLed8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEzMiBTYWx0ZWRfX5JaudrvjqA0o
 Ll5F1+rcqCgJDArIge7M1Cy2m7UAUwtn/8/IMuneXJty4EJlLVfKslQeLpyUV5V+8ZnJ14LfB2Q
 VSXNrgwBh8qWzpT6zpqw7+1eAlNlOt5EMCRnLms5/gt0G1Loc3zXhJXbMZZS9QSGw3G/nhRknTR
 DUmdy+3mbmJ16nHFbL/B7YSZvL9LFo47G0/ovQ2F+eYBjORpyRqwcWFAEfp5qEHhhEdmJaAISx/
 DdrJH17k7d4giQRzf/4CbtiNOgvsRL52kmGbdeDRCL5zXSn4WUglyAQeClr1OtJoKOBQUz7kQvv
 BrVmkGWx1ODDWoBNdvmaGjDozzUZdfBq9HoWwsjzBSCYV63ashgSGVCXSuT/xrSbtx0Rl/g/+Cr
 eXjFabZPwF2BrhfAVQk3VDGlXhi04ZCywKCdJjpunsJ0IHqeNq/U99sO8KZquCTcWZSAHvOyXEC
 e1RIWJc4wsvAHSWI69A==
X-Proofpoint-ORIG-GUID: NXLb3uM6ANmcr-AbQSZxbCGsyt_PLed8
X-Authority-Analysis: v=2.4 cv=T7m8ifKQ c=1 sm=1 tr=0 ts=6a6379a9 cx=c_pps
 a=NjM7+/ez9qG7m02rljsF/A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=SKsLz4BtRYM5tR5lpnkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEzMiBTYWx0ZWRfX6LfzhT+IsJ3x
 dFHuQd0xG312VP/tcCaZagHpnYp6ZFG9cdF5bWFp7SCtxbLzVIKzm4L907pyCVfAvDCAHobXOLV
 v7UeSwQht6JxdALbYdToEQDvgPSxg+S49kRollMttF8GrVwrMTV5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240132

On 7/24/2026 10:20 PM, Greg Kroah-Hartman wrote:
> On Fri, Jul 24, 2026 at 10:06:39PM +0800, Zhou, Yun wrote:
>> On 7/24/2026 9:02 PM, Harshit Mogalapalli wrote:
>>> On 21/07/26 8:42 pm, Greg Kroah-Hartman wrote:
>>>           fdput(donor);
>>>
>>> Thus the new cross-superblock return bypasses fdput(). In particular,
>>> when the caller has a shared files_struct, fdget() obtains a counted
>>> file reference, which is then leaked on this path.
>>>
>>> I think the stable patch needs a small branch-specific adjustment:
>>> set err = -EXDEV and goto mext_out instead of returning directly.
>>> Thoughts? or we need to drop this and redo this again. I think impact is
>>> mostly a leak/DoS risk but I still think we need to get this fixed.
>>>
>>
>> You're right. The fix is simply:
>>
>>     if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb) {
>>        err = -EXDEV;
>>        goto mext_out;
>>     }
> 
> Great, can someone send a fixup patch for this?
> 

I've sent the fixed backport as "[PATCH 6.12.y] ext4: validate donor
file superblock early in EXT4_IOC_MOVE_EXT" to you.

BR,
Yun
