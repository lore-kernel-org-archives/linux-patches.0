Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF591870
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718474987; cv=fail; b=PUpo+roFNK1bOxkgRnKf3lYnp55zAFCXoHhz/DvcIJ9PBl6aU0RoA8nmGV5Rh8lpOYv6ZH1kSbfi6ZFBBLEBRI/P+eFCL5WcCioTuE/GTH9K9Xy2XLrTLgjiUCPEt+TAWVwID8jlby1DpqM53hSZlfN9eDVC0Zm8HxWDYcZIrqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718474987; c=relaxed/simple;
	bh=XCnpIvC1gcUeaJBvmX73klYDh2pUsjjAGoGNa7r2C74=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jY4vcqgqSUU7zz6E4UffssY29BE+yYEFbCM8l0b4fqlEBfHDRxZboDd4ucTLFHFMGmlg5krc+qeF7OljPmrgcto+QbAz4rGRRJf85lGO9AI//owE+HtfPAn7vH6hqrjhQ7lx+Y0sjL/zP5dPKZCDyPH9Xy6nlKQyAQRhmyRqJQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hQTIubAq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GYr3SEBh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hQTIubAq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GYr3SEBh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45FFcx7b027237;
	Sat, 15 Jun 2024 18:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=VneU9nDjnGzbwbjuJKO6qA+x0riCNQNNrIcWhnRvCBY=; b=
	hQTIubAqZvV7VcZZhBiZ4Ma4QiLYDNKM8p06SpXZzwQ7ZeC5eV44AZrGFwIt9DZK
	EuWZRM8qJ9Zt14Gv83TRu3y4SOb6CXamsafiIjpN+P1qsOcNZkplOzsdTz7s4Qbe
	GtDlrT/33C/plpaA0/R2c7gcmtxYc6mHV3cvhMj7ygaVZtqvlRBdo7yfUCTeN+y2
	17pQVhaHkShAsmi4gNN1DCcBzlujbvK9TvJAIrE/HzNAT8KjdEXF2aVTeS8Jw5cH
	UJhrLhFDWAnssCXC0jeOsuX4REYFg2SQ1OJv+sa21V2cmiMdL1HiEF6YSHdP90YG
	TYE1tly4ygoPILFPUx0uew==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1j00m6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 15 Jun 2024 18:09:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45FFKuoo032868;
	Sat, 15 Jun 2024 18:09:23 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d503cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 15 Jun 2024 18:09:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtS3EP5ilRCNqYbIszH39nNBJqcboVRn0SUGJXgnZj1YWaLaXo0eclRgJsbRBN2LYn99TlJA478XGhmVhpf2/HUOyGaoYcYDfxlkEz1qiN4z+fA+uTkYXno2WwjoN897JPdCnYvsp72ODduoAAIi221uXjIVV2ESuT0urLDPzu25izQL8kyoADqUkmPntmiiEXbaGRIJRhuRFjANOxjVWepCkufbzXRHx+LQ5E6l6elZdyOFOrkp8X83vSqvNBqjRW1vWHxlEIqkmg8u21kj6AMt3/3v2QUefLEJ35CTIL54TOBh6NC/iZgcliz6ui+PHFuwa+dz9VQ+Yd4I8mLlhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VneU9nDjnGzbwbjuJKO6qA+x0riCNQNNrIcWhnRvCBY=;
 b=hW8ohFto0iKkZaZvCms5KFE928nli/ENvLHITq2muIF3f9r4oTMVQ93EJtpJVOqRkobQyanBt/QdlilhGxTkFmg8mSU0m/sD7BXWX+xjAOP9m02R1UryQqylumry+grFgXfuzGZx1WyhgkGGkNwrLBxXfPNfJ0RpYdNQHLI6FkXx+3b2KCVQP3KTAPBr3WZuPID9OgkTEisqaNNfb4MDUP4C/frbg1salDfhzwzU8MyVWfGFL3+5VxahU3uch5HfKWYCf/w29pnZxpuW0vHUZ6ccXwCTACRTyhflH+Hi7sIsyKECxiuLuUhTNXE6UxciNC5NVzhafSl9J58QeLmE3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VneU9nDjnGzbwbjuJKO6qA+x0riCNQNNrIcWhnRvCBY=;
 b=GYr3SEBh6eActDpt+1G7NT/v3iwxzlq+w39Ti6M28lbY4DHMk11oy/7Sawv15EPQUq1BxoH4dg3SOIlKEgaH4JVf6OZIA9yP5XG/6WjjcqGqICQCjOusQ8mtzILMSdkyi3pQJpaMEFS8B0wrKz9tmlnDCFZUEbfxUXCFR1Iv3qM=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CH0PR10MB7483.namprd10.prod.outlook.com (2603:10b6:610:18e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.27; Sat, 15 Jun
 2024 18:09:21 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.7677.027; Sat, 15 Jun 2024
 18:09:20 +0000
Message-ID: <596a3b8e-0d36-47bd-b3ac-68812506b307@oracle.com>
Date: Sat, 15 Jun 2024 20:09:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Kamalesh Babulal <kamalesh.babulal@oracle.com>, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        allen.lkml@gmail.com, broonie@kernel.org, acme@redhat.com,
        namhyung@kernel.org, gpavithrasha@gmail.com, irogers@google.com,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240613113302.116811394@linuxfoundation.org>
 <b6548098-de01-4ee1-87c8-6036cb1e3073@oracle.com>
 <2024061530-dress-powdery-c464@gregkh>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <2024061530-dress-powdery-c464@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR2P264CA0042.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::30) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|CH0PR10MB7483:EE_
X-MS-Office365-Filtering-Correlation-Id: ceecc088-99b2-4d4d-7474-08dc8d66470a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|7416011|366013;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?UTJVeWc4U1A2ZlVIc05TUUtaSkZ4Y2tSY1lHdW9nU3F1Z2tPZnphbE1OTlhx?=
 =?utf-8?B?K2Q4dE5zUlNOUENVR09VZS91NEpHc3lBUDYrV0RrUXFhRmJleGNVaWRKdExI?=
 =?utf-8?B?YlNWTWt2VEFIVWZYMDNRU0RsSjVSMnlSQXdjdDFaQkREbEVVa3prTDJ1YXNT?=
 =?utf-8?B?NDdqeHM0K1JEQ2ttUHNTSVFlS0pObnEzOFlrL2pSS0R3dE9mSStxazh3Vmpj?=
 =?utf-8?B?S0dlSzdEQ20zR3l6WWZ2c2QxWTNpNURFS0RJeXcrOVlIL0dmMVhGZk96cks0?=
 =?utf-8?B?T0ljTlh3N3JsdmJrTkF0ZkE0eEcxUVV0cW1vTkJUdFFmMWlpWE5yVnRCREE4?=
 =?utf-8?B?a1RkS1E1RktCRVc1K0pSM0hPMnIvT1RkdklSM3JOT09oNk85WkkwcDRINnhj?=
 =?utf-8?B?TUI2a1VZR1lYZ3hpVDk2Yyt4YU9TMWkzYjZuMVd5cStEOEZ2QklCRExEcm5v?=
 =?utf-8?B?cFJpd0tObll4bG9IcmlmdG1WNmdCU05WWFRxL0VqZkg3ODNhS3JyTjltc1JP?=
 =?utf-8?B?VE9oOVJML1dTMUJrMUtmWnN1THFwUU95NWI1U3prRDNObnVXWStHUmhpTFA2?=
 =?utf-8?B?cXo0aHplL1Ezd2xoWStQdlczTmM3UkJpV0d4WWQ3d3RyZHNTcUlnc3BxNUNl?=
 =?utf-8?B?UkZ0OUdKNUNPeks3ZmxidjBHREdtcmZhL1M3NmtKSHU3T1pUN3BrUE5uU3Fx?=
 =?utf-8?B?YzZTWG04YU95WFFrWmtlTUtlRGhjN3djdS9CQWR6MEY4ZDNiTUpIeWJOSEVj?=
 =?utf-8?B?ZVN6TnQ3NksvQTl0ajg1bDRvUEJ1Mmt3YW9FR2R4RHdRUExteUlURzVKbTg1?=
 =?utf-8?B?K3RJYkVrSDVZT3Vja0FBQjY4Wm9tcy9Xa2U5bWp4RW9LT3lxTld4TWxzK0pl?=
 =?utf-8?B?c3ZMK25ocjhZZjliQkRYN3FldkJjdE5MRjVJNUFRM09CT1BrWGlhUk1heWxu?=
 =?utf-8?B?N0Jkdi82NzdSMlR5Q3ptMDBJOEgybTBacmc0aTFQSVFKVVlWSTlzTm1YZFV5?=
 =?utf-8?B?c3ZTUkxaWTdtc2xMdWdJVHord1krcXByYXhJY21jUitCbDZQQXJ0ckhtZ3kz?=
 =?utf-8?B?YjA5SmxzOEJkUitVWUl0aTFoR2d6dVJ2MU9lZWdnRlc4UW5iTDVjOUJRZUNa?=
 =?utf-8?B?TTh4WDRDVU9uVGV0RU5ac2ZERENhUFJmcExyUlFVemZBUFB3VjZrS2ZsSTNT?=
 =?utf-8?B?L3lZdWJjNU9obGVDUFpYbWVCNVhHQUdWMDFHY0ZoQndod1VVTm1pUmE1MzY3?=
 =?utf-8?B?ZzRhS0N6dW1HYjdVWHZEUUwyUXp4bnBQajYvTkRkREdqdXI4aXkzemF1Y1ZX?=
 =?utf-8?B?N2ttSWd5RlRoZVQvZVhmb0grWTJ3NDU4V2h5TTB2bkZuMkhrSDNaYlZyMU16?=
 =?utf-8?B?a2NYTHZHZ3VwRS85N3pUa0FHakNoYTQwa1B6V1FQUFRxQW9HUmNTMm5pVmhG?=
 =?utf-8?B?a296Rm5GUHpKb3pTelFnTGJ4V1JJaW5jUWxSSjh6bmEwMG14dmYyNjkvV3FR?=
 =?utf-8?B?eFNaUEtHWitkQ3F2NDNPMDZ4T0NINWM5R3F4TTVoZ3hMeStjRzhtSnM3ZVJr?=
 =?utf-8?B?aUdMVURtOCthV0VoaGVjcWZSV1NwZFhHZGszTVlWSnZsUEE4WkRlTnJIVXpI?=
 =?utf-8?B?RDZWQk01dzNmdGl2Wkg1aEd1V2UwYTREY1BjVDl2dFdlNkR3ZWNidUlDZCsx?=
 =?utf-8?B?WU51ZDE4VHFQdDR4MlM5Q0J1VnlzcFB0V1BhbWIvbllrUFFsV3VSYXJORHpZ?=
 =?utf-8?Q?Dchpwu/+bzDgpWhLW7XFmXJN5erOnR1CdijKZRm?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(7416011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VEVlNFhDZFNpQ2p4MjB3SW1GMUNxMGZ3OEVSZml2a3g4RlZLSmRkcEY1Z3B3?=
 =?utf-8?B?enVoYXdMUW1mSGRzQmJEMTR3b0txV09NRDBUQzF0RkVYSzB1OTFhekdDZTYx?=
 =?utf-8?B?U01RQllGSVRSYy9ZWDZkM2pQdUo3YWYwVjd3K3FNUGVTbzFEZnlCYjZNcTQy?=
 =?utf-8?B?bnFDbTdsVFl5d1BGOVdPWGVCSkkrdFYvSGJ4bk1sait1Z3F2N3lyZDhZN09J?=
 =?utf-8?B?amFZbFV0WGFGWEljaTVadnV5RXZzZ2l0aFFLUUE3MjhQcEd4dEVpNkZ2LzVo?=
 =?utf-8?B?dkEyQzZIWlpjMktTTm5wMEx1eGpOVUlMeW9NZll6QytWMEs5NzFPRU9VZmls?=
 =?utf-8?B?MHNDMVZWNmUxcFZzMVA3UlYzTFgvY29nMEhvb3pBd1MzWFFyd09pVlUzNmd2?=
 =?utf-8?B?U0hETnlIbjNGcGdXOFNPUlBVTnh4Mm42R2kzN2VhTEVFSEJLcy92VFBzVm94?=
 =?utf-8?B?T0NVbEVTcmlVL0VZdlJhSzRKVDRkMytSTElobDZIdmxFeW1acVFIdWZwZ0tl?=
 =?utf-8?B?Y1lxK3pVWEZOckE3QlF0MUVKWFpmRENnMitkM01leXllazljRE9lUlJWS0JM?=
 =?utf-8?B?alJuckJ3TG4yc3ZpZzNtVkpXSGJRWjVJZmJTcFRyQThLa3ZtbVMzNC9DR0RY?=
 =?utf-8?B?ZER4TElCc2U3M21MRlcwYUlTYVNOS2QyUzd4QkpGMndvVzBXcTRvR0g3NzFQ?=
 =?utf-8?B?R0FpQysxS1dGc25TTUFrcE1EL3JCKzd2VUdPRllZcUVrLzEvNlFJVjF6NEdq?=
 =?utf-8?B?eVA2RGRwT2RlbmxUTmNjSDlOdmNRVU01RVZOTEYxZ0p2SHYzSG5yOHJ4OHJo?=
 =?utf-8?B?RHJVZlNhaEh1ZVlxSU83NVY5bDRrWWgrYTBaR3M4WUJGL0R6WTV2K3h1ZGZr?=
 =?utf-8?B?WEFyRVkrQ1pJQWI2M1Jpb3FHYTlyQnRIQUVkN1NmL3dUT0szZG1WOWZsKzQ0?=
 =?utf-8?B?UkhHMTdiNTdxRVB3aTdLbGhMenBrVFUyM1pEUWhtcXhqZmkwMWl2TWdyOTAv?=
 =?utf-8?B?dXpONlcwTVVYWkZpZmtSMVJhY09GbUdoOU1uUDZtNUllcE9TaXdaNlVIdFVN?=
 =?utf-8?B?cm1ralVSYTRUeU15dFdWMkpnQlJMSXB5VWdFdmpoOFpIcS9JWVdRRUMvNmRO?=
 =?utf-8?B?WXVodGhWZG5NWCtJOHVGNW1LMEhlMDFtM24vYmpGa0JBOVFkeUY3QllwRmVq?=
 =?utf-8?B?ZURMTzlyRG5DdEhXdWJRa1JITmMwZ0tZWVBYUEo0VDV2dFJFVnpKenBiVlNV?=
 =?utf-8?B?RFhiTFUxcjFQY1NGQzhWd2l3OGo2MzM2d0JnT1c3b1lsZXBUSDhxVi84VmND?=
 =?utf-8?B?OG0vNDJGVWtnWGNpR0U4UGdvblB0U1JjcmlXRGh5M2NaQkx5QWNzMjdieFR2?=
 =?utf-8?B?d3V6MXhkQzY3Z09KVlZSbC9BQlNSTmluTXMyUWNhcUdndGdZMUNBMVoxem1h?=
 =?utf-8?B?aHpTa0ZDeEFFcUw5WTg4TE81YXJIekErTnN2Qnd2ZHF0UHhyMmVjQWwzUVN3?=
 =?utf-8?B?VG1QMGNnY3ZxeWxwdkZvTW40eE0zSGRMc2lZcG9XSldZcC9Cc2REazBkR1hI?=
 =?utf-8?B?K1BIVHM3NkpBdXI1dWlKV3lsSVVWcnNZQWl6NFJiUW9jNU1MU1Vzdk56QnJZ?=
 =?utf-8?B?MFQ1NzE0Rld6MDhXNDZLOTFVb1VqYjVURlJEVXozTWNKckd2YkNTd2dwbHln?=
 =?utf-8?B?ZHloTXNpZkpuM2N6WVBKSERSRUcwS3pJbTlEblZRMG9UVzhZZUhqYzl2WUFD?=
 =?utf-8?B?WDR1Q2VNVXE1T2tUYW1CNGxZQUtNSTU3WWVqSWE0Y0ZENFJzU0hwcTNYOGRS?=
 =?utf-8?B?WWkrZXVaVmpPdGxLM2VCYloweGtZNW9pdXArWlVONG4vSkFYTlJoWGlhSS9o?=
 =?utf-8?B?YVlCdVMxSjhBUjNibDVIYWh5NXdNNHVMRlVqNmROQ1g3WDM0ZVh4dmVIOEUz?=
 =?utf-8?B?WWh4Szl0a2hYWFMwc2xmekxYOFNSdzN5eWVlK3Y0MTJkTTkwNFpvTUJFbjJv?=
 =?utf-8?B?QzhUY2wwWlZ0bG1kM0ZkK1h5dmh6SXZNVzN6U0k5VmdUOTFTTVBCZzRIcFhP?=
 =?utf-8?B?MTRzMEtBc3liZEZPeHdHemdjeUo0bDI3SmhtNnVWRmZUUWxlVGd0OW1WRU5h?=
 =?utf-8?B?TXNmck40bXg2MmxGRHBxWHg3cXZJTXJuMk5JTlhzNktaQVdTOUFkZ29sYWh1?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9YWNX6SP3kENG2cXoHF3E4F3UGD3iK14Vv4dPFP5QjuERbOKD5CdjNrTsP+JQbl5oMar42bURzyy1QWRr5oVywNiae8sFhIEZGI2NIW+9U/fZV1Kh7bNmNslEQDZJt/UE2Y64Io0xLJKQhzWhi6v+YzzY8f7ibiVY1UXDWu4TbSbItGJwHbbP5NI6F0tnUcptWJB0cMMLgCrfn9nVfhH2ZTRkDnXO0ezK4J35SJgth8rII/M+Tk9XcjH32OY4oX6/+ZFDm48fIu2EqYkReCoo9bKrlqqQ+4GxaxHdGJnTX1Blplh7/y3fGbmPPIhWKYu7T/aDFKRqPduIQ1pHA8boFRGIqotsR6wnTiU2N6uPYKjq2nZTimHHrflwjvdfREXLqs5npsmSptRPhkXPSHcOXfT0FTzBH2jAsAQCBv2BXs3EXK8KZVfAZzQ3Shk5Eo+5t95W+3XW1R7Bwt+GjXiJ+s7bxZps5w9xcuvxvPUA9Q6tP4HqgtRIfd+iRrn9AKC53KJEt26CG/0nuft4rkV0XAEvPEDyZzy3I7Ak+2oLCHxnXhtUEds8z7UbGW9Tds4bMipmMtAV9O9K4OcuIL/UPeeTnU2QHPCi6zq+IgGBlE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceecc088-99b2-4d4d-7474-08dc8d66470a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2024 18:09:20.0854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rv5dipXet6ulCG9xJd9afGh/VPMvcLHD5ypbnywC+waANc8MzO03352krZkb1X2njuzZunsl3IPDByCRjJw69ZeGEwHEVHm3ODw55dsU7Qc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7483
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-15_14,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406150138
X-Proofpoint-GUID: iE39IXfOjnSumyWxL85D4yTXYkLPjqXV
X-Proofpoint-ORIG-GUID: iE39IXfOjnSumyWxL85D4yTXYkLPjqXV


On 15/06/2024 13:05, Greg Kroah-Hartman wrote:
> On Fri, Jun 14, 2024 at 02:10:26PM +0530, Harshit Mogalapalli wrote:
>> I think building perf while adding perf patches would help us prevent from
>> running into this issue. cd tools/perf/ ; make -j$(nproc) all
> 
> Maybe, but I can't seem to build perf at all for quite a while, so I
> doubt that anyone really cares here, right?

We're building perf and it worked before these patches. It's part of our
kernel build and we do ship the result to customers. So we care :-)

>> We can choose one of the three ways to solve this :
>>
>> 1. Drop this patch and resolve conflicts in the next patch by keeping
>> pthread_mutex_*, but this might not help future backports.
> 
> Let me just drop all of the perf patches for now from 5.15 and then I'll
> take some tested backports if really needed.

Sounds good, thanks. We'll have a look at backports.

> Otherwise, why not just use perf from the latest 6.9 tree?

We have a build pipeline that's set up to build everything from the same
source tree and it's not really feasible to mix and match versions like
that -- besides, we don't want to jump from 5.15 to 6.9 for this stuff
any more than we do for the kernel itself.

Thanks,


Vegard
