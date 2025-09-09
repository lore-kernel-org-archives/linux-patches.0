Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E0731CA4B
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431011; cv=fail; b=Q6rCWSlPd0gK+yvN9tNmr1sQw9uLi4S7Iy2ZwS+Wvl1JVG1NEZXcAyKlbe/ErPaXn4mz0e05fVpzJtUnROaWU1bAfHsV2OdSiusGY7GuDGSaOhUKKXe7RUiFzBDNRGUJkLnmpvTEWvWxVIHZs+nsOjyTzHNzbrZDIWBbEAfudM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431011; c=relaxed/simple;
	bh=K4OOubQMOuwZSTZgM8mmK6UVsg21daqsIqlkmYeI6Ww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tsx9gXvh6d/5X3LdyJ0/OGkv7fo0krrEFBrfdZzW320e/T3YZgnG7JnTouD3S0PVvvAMV+uZXcjP2IwHmZj/0NbJ+c9Q2dHFmMc5zIpaSviwlsKEBjimQ9zwV3k6hDXilSzWALhPcxN71uJi0faORQCnFtVx1FH14zJnJ2E8piw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YsgNEG3V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bqjTDm/Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YsgNEG3V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bqjTDm/Z"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589CPFYu003819;
	Tue, 9 Sep 2025 15:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aA+3LRj8D6IctWZW2vwwpm87seFIJWF+JVr8AZVL5+Y=; b=
	YsgNEG3VTYa6hYYvVkD1oAVbMB7VBWR/C3YBdrUO7OgRFsAYq4n9hXgMDAd3j3TN
	XNDdQgNfcp16OejG0R/167Fnhe8TpgpKPM7Dk/bQ4KR2yK46DJFk4a7quZnbTAoR
	CiGZ9RSiUhFlIpGAEE5eWIvNtQGkHvySJ5/x8WsDsr1ghB1giT2TTC2IMWZwGNxg
	iuL6kU6+f6ZNp5WzD3na//aylrpXF3maqwyowVDGWuHbrKDnIK3Qk39NUm74SLwn
	MZo3lp3FMaWgGHLtJ4ftD+V12C7TtzZ8CnW1Lgg4ie7Ox1H08s4zCxdUX1YT9ZBJ
	XbkJFDOATWC9fRi1xKULlA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1jb85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 15:16:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589FG3WI030720;
	Tue, 9 Sep 2025 15:16:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9r2p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 15:16:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PN+Aw+9MafXe7I6j4bBnA4FxhUCeTDeF55Bd5YuYkWhA5rB0b6e4f7h7RVna2qtYbvlDL3oX2PzgJ8l479t9mUFoblraTlBlcWKSGnMHsQteelS6PAIkfOJjzSVKN8D8pmukm5gSm8OhgjPVH/xDO40m/QUM/lSyxwwH3rHJXzKXQMqnTdh2qz2fnfvVrni7cpDAdpsu6fEUPl/cg/qTu1ja+2S6rwyvKg6Vx29iziypwgPrTdKBh+3yC75AA1Ju0HU/7tZoUITPsSV7bEPIauYiy7dNcNJUEtCx06egGmwkS3X1twZ42vNxf2epnr04gmziYB7EKg88dlX3kuWK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aA+3LRj8D6IctWZW2vwwpm87seFIJWF+JVr8AZVL5+Y=;
 b=BShbS5mAd5U4jNLyZOfUG1lyrgPaBQlieYSLzLNs8TBQLE3XoZJXi88Wm2peC2H/YfB62pAkhB/SsCPmrFstlhTiQQjIFVj9C7hwkOLU/oGN/9DJ91g4iqoGkPRzrwHj33Y509f87Xk1VH+esroYi3RPiWRB4IhyscllDBSMzhgba0lWGUrS4axvEJvkSj667qzRyAVbr/kkEe+cQe2PI2sd3CNXa75OXxP5YWCny4WiJN4hskWdyVJV/zR9tvwdAWGh3c1I++WqMl2C2pOCqCDSDYbfPoRFLTmu7uhgMoCE4v15/2v8sfr91rZUh0w7ta4c971+lUzI6t89eRYN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aA+3LRj8D6IctWZW2vwwpm87seFIJWF+JVr8AZVL5+Y=;
 b=bqjTDm/ZPzwRebidrBAl/JvTCDlA51D/5W/WJItGafpcXqXXWOwYXeWLs7HzKHRvkCmof3NsWXKMay7kX01yKXuzgPlwfEiRS8ZgNVWaooM4jD9y/KSAGiooRojINZyQircSnzZpV5F7kEz8JoYIGyz2upTWzSo477hGZUKScTI=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by PH3PPF476853C3F.namprd10.prod.outlook.com (2603:10b6:518:1::79b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 15:16:15 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.9073.032; Tue, 9 Sep 2025
 15:16:15 +0000
Message-ID: <2aa91402-169a-4012-87c6-fd40827e84db@oracle.com>
Date: Tue, 9 Sep 2025 20:46:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/45] 5.4.299-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250907195600.953058118@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::9) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|PH3PPF476853C3F:EE_
X-MS-Office365-Filtering-Correlation-Id: 748d4299-0d82-4a3d-822c-08ddefb3d1aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bTRkWjNJQjkzMXlXTXFvRkZzNWNMOUxhaUZ2elNCUUVEakpmOTk0NXlZQlJ1?=
 =?utf-8?B?emRIbS9nd2NqbkNSODRJcysvOVRYVmVQN3dmM1NTRHBlc0hXY0ZQSDdTR0JP?=
 =?utf-8?B?d3V6TW55aUhnR1lOSmZVcTRrcGJuNVpLOXVwZVNDN1kwVm90ZDFrRlJwU2dQ?=
 =?utf-8?B?cnQyZ3dRV21sakN2dG5uT1h1NFlyVnpwdFA1R0NsYnFxY1l0bG8xWkJLTjA0?=
 =?utf-8?B?SnRvZVNtcnAzRTZBc2ZKeWZVbFk5bkdzTXRKVjlERFhNVjRaNDkzb0p5YWJ6?=
 =?utf-8?B?RlZ1TE1RcmxQOGFteUN3T2oyOWNxakVNTXl0a1Y5ZmdjUjhHbE44cC8zcXU4?=
 =?utf-8?B?WG1BK00rUnRjdkJ6T2hNVVk3VmNEY2hqSkhUZVRvRzMrUDU3d3RFSTloa2dz?=
 =?utf-8?B?S1JZOGdGYVhQeWdsVTltVy9BcWplT3c5Mzh0NVJUa2xQQ0RIMkJPZzdNVXNP?=
 =?utf-8?B?cmFhYmlMNHlCWUJZb25ONnRualdUajh6NkRHVEFYTDF4TUFnT2VMWmswOGV2?=
 =?utf-8?B?M0FTN3ByZUhwVktVTDN1bGN6c1g2YTl2b2JoNDVIQVM3MTQzNVVBZlRRV1V0?=
 =?utf-8?B?Zll4UjkzRUtxR1kxVkJSejFhM0dUK0Z1Wit4cnArTG90MHZ6UE9Xak81N2d2?=
 =?utf-8?B?M1A3T3lDeUNvN3g4NEVYUXFnSENoS1Z6SGNwOEgvdjNaNFZLUkdmNEd5RlVP?=
 =?utf-8?B?bmFydEtSNkFNWVN4SUZzZEo2c05lL1I0bmFPTUFLQkJEQVl5NEd5dWVWRjZZ?=
 =?utf-8?B?ZVo0THUwK054R2tpeXRDbU8zT21Wb3cyaStNYXJnSURJK3pSSFhCNUhMcUcr?=
 =?utf-8?B?WW9abEdiamxJV3ZjcHNBbXdBenlHYWM1UC9URUVNRjlYRlRQN0YrNFA5RGRY?=
 =?utf-8?B?M2RJdmUyQVZQcUt0N1lwbVA2bzhYTXpXTEFjbmhQMlpyTEpYc201VlNFZnU1?=
 =?utf-8?B?YVpYby9PdUd0K0Z1bTl6RHhoQzkzcWlQbkxvU0VCdjN1cTF1YVJMWGxoSGZU?=
 =?utf-8?B?MEdpc1lUZm1KSExPYmpYZlYzMTJkK3Eva2tNSURIaW1jVWc0MU5TbEtZeVhr?=
 =?utf-8?B?blpkQmNyTnp6VzlSL1A0QlZhZUpxSHNVdlhiZVVPRlcyR3Rwb2praUd6YXFa?=
 =?utf-8?B?TDFEVXR3b0N2MXA1YllyemZwYUVZRVdqbDJuZU5zQmlBditJSGlVMmlYL0RF?=
 =?utf-8?B?USttdWRhVjJvbmtEa3ZrQnNFZUZrQkt2Vng3R3ZkcGx5TGJMRzRpa0o2Vjl2?=
 =?utf-8?B?ZDRCOGxPNDlpRnd3UkxKa3R1cGdOWnRZNWV5enRueTVPYlhpWFQzZnE4bkli?=
 =?utf-8?B?Q2dLTzF1Zlp1K0FrcG05NHRKRHZiTk5aeThiTGpQR2JmZWZZb05mVGhnd3N5?=
 =?utf-8?B?dzUwT2VvdG1vNlM3L2QycEI0eW44Zkt6cEE5Q2xxY1RreDdKek1MR3VzWUZG?=
 =?utf-8?B?RVBzSDFxM1VTL2ZteVJCQ1NCV3ZvcHpkYTllQ0FySWtobFZZTUZ3NVRMSWR3?=
 =?utf-8?B?b2QzUTRJRDYyM1lLdGxDbGxwVWpFTU5ic0s1Yzc4SWtYV0RCL0E2Z0tEdldi?=
 =?utf-8?B?a0VTV0VvbGNheGlmbXBidnRudWJRQ0J3V0JLWFR3Rm54aWgyZTBEU0NLRDVx?=
 =?utf-8?B?ZUYyMm9xRTJ5dENZZHkxWUdqOWw0akVYVHhZWUhQWVkwRUtYYUJDb0E1QWtR?=
 =?utf-8?B?aTU4eHk5cEhVdk1vWVZ3dlF3MDVLU25odkhkME9kR0FvUy9tVXpQOW45SkVG?=
 =?utf-8?B?bjJTRkRTVjV2OXRUdTV0ODNVOEhXM0NPbm5pQU5TeWZmeXFmZDZWb0t6T1Ro?=
 =?utf-8?Q?54eG8yubteyOGiHsQ7HIUaZyipV5ZR8fazWko=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjJnQ3BJdnNsQVdNcnZZd0tjQm5LRnZ1VEJWTGQyazlVYmxzTVBGNlRWYldN?=
 =?utf-8?B?K0RaYjNScklacUYvQ2dzbkNWU3hYQS9OTWpvYXFhMGlzOHduWitiLzZvZnNo?=
 =?utf-8?B?cGF5UUdidHRZWVhGUDFWeS8vMDZyV2VSMURsNXk0M05GRjJRQ3JCcDd3VVpE?=
 =?utf-8?B?M09IUTA4QmptMTlHNHJWK2ZydHg4TkkxZFh0YUpTUWtPcnhMMXBXdFdYanNt?=
 =?utf-8?B?cXR2eFZRcnI2K3NyOFRsTUhZejRRc1pIcFovSUZiWXU3RzVLRmRhZHpWdVBU?=
 =?utf-8?B?N0x6RVJYUzdDQ3Nkb2pmTDNlOUhoRkZPeWFmZEJmYVNaUDdyaEFrNE53K0Zj?=
 =?utf-8?B?RXR3K2dDdUhKNUYvWERrSmVKdlNqRW1ZbW9FS2JJU1lEUWhJVnJkUnVucFBt?=
 =?utf-8?B?VkVqRlRyMTZ2MUxtRkVJVk1rWkVyS2xwRFFTSTNRU2lHRkt6VmllNjJGbVQw?=
 =?utf-8?B?MVUybEFaTitIRTdHVTJrRWRhbGZqNVBrc2w0RW12UVNrK1pWNWFYb2s1by9r?=
 =?utf-8?B?OW1NZjBoNzJmMk5oUDdmNzhVdCs2Wk5HSU1yK1dQVkgzWGlOWllGdE1YS1o5?=
 =?utf-8?B?RmMwbFdyTnBYbkE0RVhibys3OUdIT0VnT0JCRE8zM1JvV3VlZXJZRVQ4T1Ur?=
 =?utf-8?B?c3N2YlFDR0d4eHZBYlIrUjlvdmJOUUNZYTk4M0J3ZDByS2JUMFgzWGR1ZXY4?=
 =?utf-8?B?Ymljek5Sa1M5Z1JOK0FYMm9yakd3TjIza01YY0dyM2JCUzVxQ3ZoR1Uvc3VS?=
 =?utf-8?B?dUlWVGNuR1lSczZ4aDArN0VQeStISVFtanZZNE5iVVFVajJ6a3VYT3ZZOGZF?=
 =?utf-8?B?R3ZpZGZROEdIcFVzbDA2SWs4S0RyS3V0dEFRZHcrQzJYaGRQQWZUeURvMjl2?=
 =?utf-8?B?UittWkZ6aXVHWUxsaCtVZlFsWlVaank3cUVOZVZ1VTloV1h4azV0R2xkNGRO?=
 =?utf-8?B?T0gzYmFBYUFXdFJTRzNWT2JsVyt6YWpJU01OYmcySElKVEloUk0zMzdRYlNR?=
 =?utf-8?B?b1pvak9nbUVNY2lmS3BxaFNpbUQ5V05tZEo3elcxUVdXRWtpVU9IcmxHVUp2?=
 =?utf-8?B?VmpZVEZSd1A0eUlzZmNpOG80Wm50ODMzYlBUZ0FabHVZb1M3aUJWM2tQNGRs?=
 =?utf-8?B?ZUhoYnRmeFZhSXVYVDJYZ0RqbE9CRXNKZHJLSlBBTm11RGhndGVPOHhZUUNp?=
 =?utf-8?B?RUU1ZEl2SjM3c3Y3Szh4eUI0ZzNqNkNtU2Y2cjRHODZNZ0lwSnpsZGVyMnI3?=
 =?utf-8?B?UjJuQVNadElCSEVXbzhWbGF0T1lnenlUb2liSk82R2pZZ3NlMmFyU2VQUW44?=
 =?utf-8?B?cTRldXlpYXl2TXVpcTZSZVBVcEN1Z0s0ZFhraFU2My9OTGpjcXFNb2hVQXM2?=
 =?utf-8?B?dE9LWkNUeVpqRDRyUytJbzJSNSszMGU5QStucTVFb2VsOVVWRTFiSUZxMmNF?=
 =?utf-8?B?L2pocGFNVnM0ZGc0bVRTRG40VktmczEwTzZYd3hvRjU4SEZMSkdqL3V5TFhX?=
 =?utf-8?B?MEFPUmRSTFRDRlhScTJOYmFJYnloZDNCNUxCaWY4TW1wNW4vVEttWCtrWm1W?=
 =?utf-8?B?ajk4dFcvYUc3SDJCbmFHK3U3UmxUV0QzMHhwSE9yN3RlY0JpZG5xSjgrK3Rj?=
 =?utf-8?B?MFVnN2lzb0d2blJ6MW9EbmIrWXE4NkJldHBuSzhSbGxvclRlYno0Mlp1Yk5w?=
 =?utf-8?B?YjVuRnVYZndid3kwVFdBd0l2NHFwRmpTNjJqVEhidXJ2dEo5ZFpTVzVxajFi?=
 =?utf-8?B?TXRyWXBpQlFZK3VlVFVSTGhBWUpvNjdxUUhOVElIL0JWQnhzNCtJdklGcGsx?=
 =?utf-8?B?WEljVU1KdWR3L0VHREdlczBlWjBEeWc4UjhiWjZaWU11cDU5ZURNWFBGcUFV?=
 =?utf-8?B?ZkhCRkdsN1VRcFl6RHEybk15KysyTFgxVDVOa2ZDektRWUtobWk2aXhCREV6?=
 =?utf-8?B?Z0hVYzJadDB5RGU3b242cmFGTjE0cEoxaGVzWGF2WFZ4OXJNSERvSGMwbDRD?=
 =?utf-8?B?QWdMZG5naVczeUJ6ZDlXdWVRbmpjVXpRZUxHU0dJSmlDdzk0dlB3a203ZXdV?=
 =?utf-8?B?YURucW1OcXhqdzZnbG1KYWExNWliSkJ5WWhUbkhPN0l1eTRoOU5ubG1VTWVk?=
 =?utf-8?Q?zdxx7MgBz7onMlLcPdK8RZQVJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t51A2oGdu0xxpHCp4KUaEfEVPrSQQUVP7qHc7UajVfN8VoLr9zqCFQdUugLCI4yvjXWuHYua/I3Nt3AifmhYQWtvJmLuC7xtEcd9PxrirqcKZB3Hz9TRbkM1+eQT7bAXnaqE3aPT9AEyhdBTCBdqT41E1hnBQCWxlPSda2/m53IEAMsGt/ImiUz7NcUr0r55EhXEp6h+Fj1BRs4Yf2exsyoOJloI0L+QQ6cbZlDYCWfzuz1BmdOJGWD8DW74emu+0u3VI1gJfG5rsMiCPvXhGVSZfau+sqCE+aISp/Y3IuC3gap5LlztT6VNaV2C1GVM1KAiUej3K5vvYJnaIpPxnb71hLjDF1TTm9iEJokhhKvfiRUnTqw1uGGHo1gomHIOWcidIR1SxEtxPwe9ZCafGoPbcazsvMhaZWsCWfvZhULtYY/alI+HLSL+wgQNRdy6ZkeYsTJ6yCSBpqkoHV6YWrM9i8FgUklkdY96YQWaILEsIeWpv2dODkajDT0wOwdAW9KCPpVv/CEIZx7adueKvYMZfYQq+a28dIGExknetqpU9kB5vM9eLrfkzPrM5iypSGR0wkCJzLicY0fQb/mt7pfEUENJvA7MZqCNw556Sw4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748d4299-0d82-4a3d-822c-08ddefb3d1aa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 15:16:15.4319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s25eWk9cZRTG0R3+dfw2ATToOtsVLL9HOOvJ62Jo1kUNewGxph0sCFk7f2bBuAYxrjb98QW2PWMxzaPEqZom+uAHKJmcLmPOoxT4IW+b1MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF476853C3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_02,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509090150
X-Proofpoint-ORIG-GUID: vEW7FVfyWfqkBvyqmzTmbN7mEWzc1axz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX44PLPN5+pso5
 ZwcUO6dwk+fE57d5R6P2HWPCOEU+6YKJ75jmoaPIGLx9DCg9pBa+NsHbzO17gmUdZESUIRt64vd
 9PofWACGYmmFxroCpbnEIdjLiYK/qt3R8Y6evlhXF6aRjeCGCjnyeSz++oRMJUE+3tUlFRP3bZ7
 ceFKQQKpElzHsifev24L/Wl/jEScWziuTTmzSbeq2iA/eeKEtw0FKprR8W1t70kaYeSx/B6enut
 okRbO+4rbAzrjYXnT5e6vRnJ6sxLxAz79lMzE1sxpCG3CZmr9D4JymMBi3GswXlbbSrXAUADyON
 OHruausQgQKQDWTR+Tpsg3zwUf63DLgHlhLG1QEFAmOPsXCWhy+aJJoo57IDGRnW+g2B5szu//l
 u4PxgtH0
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c044c3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: vEW7FVfyWfqkBvyqmzTmbN7mEWzc1axz

Hi Greg,

On 9/8/2025 1:27 AM, Greg Kroah-Hartman wrote:
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.299-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> PONJiXxRvlcT9OU_jrsR0DdIWqAIVYqaLfLaeQdn4dJ6FFKQc094nFJyiFzexOhLx9OYb29xxdPKTxC2A40n5dcibg$ 
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

