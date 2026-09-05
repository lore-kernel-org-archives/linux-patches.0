Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180A3285CBA;
	Sat,  5 Sep 2026 18:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788632881; cv=fail; b=fjBgLVZWTCk+XpW7AwPxwz4hRXjbWJ8HAMCdLqiYpv4FQiYvWsJgapOJEzwoiXK5Ol8bEL8MO8dInGBzUaz/jiEy4szhYNleO+wewAHPft/Qo6/EhYTbSoSdt65rFs31H8OGHjT3ZcqBnbmTi+qsxNFyjq5wqTPyL0ZhxvGVRX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788632881; c=relaxed/simple;
	bh=eIqmCFE5WtNKLJUxD+qjSKCJQFEm2RpBjxTi10XnLPU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U1s4xbS508RhrL8/1prGkmqraHoz70Npim/cgHImLe7VM9cTFK3G7U+nI90oMHxwtzquTyXpZkg2lwLuBhXtvweotj7+md20NB4Wy8lCf6bwDhbQ+vO3RS7zCXIYDkwo7UddEbvAzRYhBc4nbfLxPRPXaZa6kKMQ2aiQ13L8TA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=elfy4l4w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dB9gbhZd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="elfy4l4w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dB9gbhZd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685IGfqB1438711;
	Sat, 5 Sep 2026 18:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4czayK+3nEzh9h5M7b4b44+U9+dBmxV5YVc97wSjGYI=; b=
	elfy4l4woPrcW3g3h61FvSrY2noOl+n8VM+QkFdHD9L4SmtT5HxCg3OLZiTRkeOk
	tyaytR0qThRjkzxLEsNqtOVHjYQA1z7wG02AIrWEAbuKGNZXOx+bBi2jPNSml5Go
	bKkQzOdLvEUaExTJyS1cbrMxdrn3pjsb9OoI2S3W0HNrwiqmnwXkj+8GaGHJsn09
	61Ft8oSasxthAgU18xHXj7GedwLxgd/jYAE7OxlP4czdlnT+O6ZBXRhycEBILjmR
	l7E85IC5KzvQnz4y3uWgePeI6JE+B4cuujjSwbxrCuNyaAiBZw/KA4jJ5uAZPAAe
	1qMqspnng5aj1pxrEfhz8A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdercrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 18:27:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685IK5iZ027575;
	Sat, 5 Sep 2026 18:27:50 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hbcnuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 18:27:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzyJgg2BJjmULVFu+lbG/JyQfZ6/+LhjycT+8kEovRzC0kHZ+L1kmqjWhNF6Tw3Zbo8FUAf7eUY26U3+OcMH5PC5DA1Yl6voeF1hXxTLuMoLxyDYnbpVBe7xycBJgGL5+XAItI0RXlXap85J6xLwfADNT3Kk7Mh4czuh6mQkeFOUWkhKXgW6Fta6cfI/r3s2KpZzJ1f0Tg1OGlA9tWdrfjaLks+pVpSbeO+9OdXMpJiPME2OYCVGPuvCS/BQQLkONG5i9R3GVrgrXVwF+Pq9Xfklc5XEGnGr89HLXeyi1ECG/U07pFOXvr8q7sykkpJUNX0kiBrPK3n/e4joxtgczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4czayK+3nEzh9h5M7b4b44+U9+dBmxV5YVc97wSjGYI=;
 b=prCkWMv4/o4muzVAa9Ja24RCdbJ/JHymCArs5NPgXZzSZHNxLdW+peqbMpv75eYkxpWiMTm35CbtK7lA1WR86GIFKVWB4s64UG3TPP24xV1sfKPb11aVI8azSU6Ncq7Sx+4jgL8QZfNOP5FOw3bRm5B0hLll7PMxzRFmcpNY6FyVN3xMTgZgHQgCo6NuFAkhhnOtIX2UpUltjbovipeXcZ64eOIJCXwcWgkcHMu8g1gF8qZcWuy7TG0CFF6YKpMh70Oi4AhIC7NZGd2anEgz3IwTTAiRFx4uFbf1Q+jMuY57BVQARfOS9PqfNSf0Jf8M0Vi7dgRWv+SEOfilkJDS7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4czayK+3nEzh9h5M7b4b44+U9+dBmxV5YVc97wSjGYI=;
 b=dB9gbhZdhomEZhI22tmbNHfcvmCLYhVNULiWAN66CREx7k49+s0mnLudJkskt+d/RtNZS5MUTurS57PmvBM6QZPaPcV9flEUQtr9VfSGjg+FgeD6CEuhwQTkU3sn/U2JFz/Xqdg0HnmvfACmxeC3gZfPIm1L+EaefTkyI60YdxM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB7521.namprd10.prod.outlook.com (2603:10b6:8:157::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Sat, 5 Sep 2026
 18:27:46 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 18:27:46 +0000
Message-ID: <727fa752-98f7-40cd-bf3c-79b11ca551ae@oracle.com>
Date: Sat, 5 Sep 2026 23:57:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 296/403] PCI/ASPM: Avoid L0s for Realtek RTS525A
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Max Lee <max.lee@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lukas Wunner <lukas@wunner.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045741.576327723@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045741.576327723@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0099.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::17) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB7521:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c31eb2-0933-4174-d3bf-08df0b7b6208
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|6133799003|10067099003|4143699003|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MjJU+kpabmGhg1hTq3izlj+w/8vhF2gXFtURoUSf3ZW3w0eRgDM/eB00y2gEWeosfZw+sN+sY1RfdmZCq4nZ1n8OphBZ8YUUwIuwhUzUPC1Hm96+2s3vehftB9eccUyOsCfUIxzBmX3qgI/XZmQ4HIjQQfqeuAmxZsYKUrDFvfIJng6CstWjAdR5R9JREoq3oQTMhYqlPSRRq7HxmTX0y5G2iIBPWvrz9xb0PSzorQmRMFk68U+yHOZ2+YZE7iF+qlQQmS+ImEAKvsoStwBKWjvtAw80gbxUSxCdVxqfnMwBbj1WCMGjnFGEVQXe+QLcTuXAOaJCsjYzMxQvMvKeQ2BNRsDmQ3RuqzDmlagxpAPx0NTsgCVBV+sFi80XyTRAtO0+vdTAH4zIkna8wXFUHVdfh7wcBTj8KvsjO1hm7AKisv7eApkJointAc550acLSWRIQZ1yDz86FgKKnp8qg48tMec7YmFSQetFeb8p6M98FT5w2ARANV3eNX/hy9ndTnvHY1f46kV2S9F8N6pdA8stz93Y1v5QuA9oBztDurmcWOedS4Q3SiTW1RNYHQulO623NxecISRayV/5byy8y+kTOx3qoefDX+NGqbX3IQ2kDl/K/Zah9Njr3kncRUb0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(6133799003)(10067099003)(4143699003)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnZyM3owUnRzbFliWm8yY0FvVU1OVm9pdWNVNUxqajFZSVp2MUM1STl1U1Qy?=
 =?utf-8?B?WlNwUlRuQ1pwbFovdFlPZTlOcVpBbXkwckRxcmpWRTI5M082OXNhZ1dHQy96?=
 =?utf-8?B?cjZyYVFxYnR0bzFtWTVvZG1mOVpQTGZUZkdUSVBxdTVaNnNEbXVLNnI5aVNP?=
 =?utf-8?B?R252YTl3dlNqQXh6cEZ4ODdTNkdYZDBhd1FnOG1Kb0hXaWswalkvS1NGckxK?=
 =?utf-8?B?WDM3K2dCaXB2UDRKQWNLTG1oVWlQZ1NDeHNSVjU0eFd1K0pCS0RkOTI1M2xS?=
 =?utf-8?B?dnN3Q2JJMGlHY2xFMnNYc0RnMVpMQVJMQ0srNnFXZGtVR29FYzk0VXd3elo4?=
 =?utf-8?B?ZDZLNzBlUndreHpqenNJQ2RaT2c1bWRjbUNzVFZYbjl1cTROdTJBUkRmVVdr?=
 =?utf-8?B?UUQ0R3p4OHRWdUg2Vmp4WWVmMTNEWWJXUGJFTHpMN1JiQXJLUjlLNmVjSnZw?=
 =?utf-8?B?THZ4VTQ4Rm0yUXdSeE9nR0NoS25ZYXhEQlBuN1ZKWlcvbjRUQ2JKemE4U2ow?=
 =?utf-8?B?NklhaTZQVER5cXA2N0JOaFd1Z3Ztb2VXcVNaYnJXSTI5V2thWnlWalBDWmNk?=
 =?utf-8?B?WmQxN1AwS2V2SCtKMTJPYWhha0laU0NYeEN5WFI4UlIzWUJDNksyKy8wN3FZ?=
 =?utf-8?B?bDZsd0QvbklFZ1cyYlZZUytuVDVLenFFVFN0QU5ZUHUyOWYvYVlUWFROek0r?=
 =?utf-8?B?Q3pXeUkrYjRKS1U0RzF3azhtNTNRaEZjKy9xV3VicGN2cGxoZUViVllpTlB4?=
 =?utf-8?B?VlJ0cmJrQWMvcTVpZTEySUlxRWVKZWZycWs2Z1l4VHF2VHY1dFVHVHQvRkgz?=
 =?utf-8?B?OU9JRSsvc3BHODVYV2JGTjV2ZnZMUWhQTVZJVFo1cllUNm9zdG1ZSUtySWh2?=
 =?utf-8?B?K3pXQlAxOFR6VzNqYmo4bVpHeU54Qmo5QVc1bGJpRzlibmUvbGExbFl1UDNE?=
 =?utf-8?B?N1QwUnZ4YU8rRTJib3lrVmxPNzg5SmpNTTk4N01UM1pWZDJTU3ZrTUEzeU1u?=
 =?utf-8?B?MGtKdVc2eVhBTmxSZjVtZng2dnNSaUFvQzlHYzVQSytKVVpzaER0QXd4bzlo?=
 =?utf-8?B?cDR1bFhjZ1QvSm54T3NCNml4S2R3dVo0S2N4RkxSRnF2bHJETTAybDlRWWYx?=
 =?utf-8?B?K1AvNjFhTU85RHdVVHpnVzVWSVN0Rlo4RlBHbEU1MFBDSXpwdkZDMzRKVmFN?=
 =?utf-8?B?ak9EdTFlQi9KaURxWFBCQVpnb1E3MGt0TTA3SzBMZTY1dS9mTmZzSXdXb2E1?=
 =?utf-8?B?dzJ0aEpRNk1SenFBRzZrQUJlMlpxZ0x0S3ppVWZNd1YrMDB1aXAycXJIUjh4?=
 =?utf-8?B?TXJGL0xmc1BrdDZMNE54dlF0TWVPdjJYNENENndNb29HSWhZbzNKNEZsUEl5?=
 =?utf-8?B?eDlFRUZ1YW8wTE4zc3ZCM3JpSStoWE14QWRMVXZkMjNKRnlYWGtKUytZY0Z2?=
 =?utf-8?B?NE1UT3hWL1VjRUlhTXl4QWZpaHNrV3hZd2FDalZsL0NlZ0FEYzFia3JTRFlT?=
 =?utf-8?B?RU1hVS9pVjBRZ0gxbXdjb2NqMEFmSDhtaCt2Z09OQ3VyNkNoUDB3YVhsZGxM?=
 =?utf-8?B?Nis0NmliUW1oTlp6MXFjT0F6ZGVSZW9YRU5xb01GZG1OQUhGcGZkNXBNT0pw?=
 =?utf-8?B?bjYrNDMrSUt3VUsxY2hHZElQTXFCam5DcCs5QytCZFR1VEpQWHJVaEs0NkVE?=
 =?utf-8?B?TldJclNudWlCR21VTVhJcDRMN3FZc3lnaDlwUHVjOE05cTMrVm5DZHZBZytP?=
 =?utf-8?B?UFVnSXVuUlg3Q2RpRi9lZTBXWHYzaVg4aTVBOGl4WEU5QlMreEx4L2J0OHZJ?=
 =?utf-8?B?WGRZMStsQWhOOWMyWGdZcVBUS0l3dWh2eklzU2RQZkdKT0k1YnlwUk1DYW9Y?=
 =?utf-8?B?YmhINlVTZkNvRC9mNGlJMWdieHhiK1BVdkRoWjJxa0JVM1RsY1I4dmswUGJU?=
 =?utf-8?B?VHhiZWN1Vk1MeTBUL3RsSmkyVFNsVnNFbHk5OHY4RTBLQWtJeHI2dmZ2Qk92?=
 =?utf-8?B?QzlDdStXZk9MNGUxRStzTGg0Q3JHNXB1WXFtL285WVY5Kzc3M3puZGtWcTZR?=
 =?utf-8?B?RjIwMERqVE10RnhLMXlUM2t6NXJuVklNaXBpQ2lGR2grb09NMGpLTC9BVklS?=
 =?utf-8?B?bWVpTVpFRTN3UXp4NGd3NE1TRXJ6MDdBRVdKWFRtRkRibHpZd3hpcHZSbjkr?=
 =?utf-8?B?dTZ0dG1Uc0liZ1lBWTVNcy8yK1NwczBzWHRUVlRlY1dBV2Q5SlhaZHZhbGhD?=
 =?utf-8?B?TlgvRjBVVUZHT3I1a0pNVzZ3NTk2ZmlQTnhZdEJmeDZoV0VnWHE2dC9ENFpn?=
 =?utf-8?B?NWNYWmpxQ2FKR3hzVTVkN0RKaTRoUStyR2YyTlI1VHBHa2dPTVpiK1YwZFhP?=
 =?utf-8?Q?Hrw+akD8vazz24+QYS4dTMgksGPWTEYPX+7Sp?=
X-Exchange-RoutingPolicyChecked:
	bwl/9iuCrr//pKiv1eokhx5V0Nwpdu/oCoVbEY5eZxauQ8e3wfBeY5JOQI6Mhqa3NH94m1Gzdnac02SxwtOuZuGHwoZ2N6h46ZGvzrfESpzU6wI1+W0GMOFIs0lGviJYrQ6KVaY1hG6ZZyZcQ8FTeiJPGQpoJ2vWCvhHnsDHhbbpYYro+opeDo6NVm+ulJEPGFrxQC8KLXXZyPWm/fTBkhvE7XRYl2to/rPiXocskZpWZ2VOlWQkFdpAFD0cxX4a3QU7YhEjYRKYm2OEG/H9UcBP6PYPKTrkReuzIeiNDQgvknFGevB4xJ8yIswJrEqUl0/FwZBDenF23loDr4UMBA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aCsCA3awpX/1DMulzqn03pH4al06JrQm+9oco4WG+1LngOCUCXATIAQB16vEwIEDrg/OaPG2SoT9u2UDINtVy3YXZDR43tRUQptLh7VdqCzJ8xkI1QfnIQGZyvsGHD58mqKvCzAJCKjyjzIfE758Lus2TyH1rf2nKqjrXr9JBxHR8yXcg1yVRk80i6AJg/qwAGhhdoy8VLKcouuqpIH6pSSf4kuHiIr/YwUODB0YeDaUQSn9iskK8r0LMEyhpi1ob4bk/Rebco70mRlkLRO14cH5XSKAHOF4H8yUixIKo2cBm3qmY65XcQ1uqBtvWdAkECo5cni2Ld9eV9aYvhJiyv3/LlsY8SLtfp5oNsScrIhCtuLaMFunSAZbYpTC2TYBKBZH3B5c0VNzPBH7b4Ox0PYwpzJfaYWTHXDO6yDDCsM4c4WKS9QJJFrSZSEZNqMvKs2koCpy6d8iIcid/Ag0+Rbi83h+V4+74Y2p+/p6E7Ta0j/YcYASGBt/ZlJmkhsp8EUyvQR0iA2bKSaakTB8KBrK2h+UNZbsnv9BiIvZ23ejX11PAIpEQATmp2PAXTK1aZ5KEatblfeJQ/foAtOByWDLqef+gWgq3L4qSxgFb+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c31eb2-0933-4174-d3bf-08df0b7b6208
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 18:27:46.4356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWDhKE2OtkcC1/2zNap1niCK3d7VYhwl1+NFiJzrOOA7qCpsrC4OEF8p0OR1+IRMerRBfdfaj6L0xAAudWiM0nssXUd+7GQ21jtUwxNRRN/59kf1wf4cHBQwz7akpPxE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7521
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_06,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609050204
X-Proofpoint-GUID: vsLT_MN2ifCebgTtqQx5CST5nO3GYWw7
X-Proofpoint-ORIG-GUID: vsLT_MN2ifCebgTtqQx5CST5nO3GYWw7
X-Authority-Analysis: v=2.4 cv=R94z39RX c=1 sm=1 tr=0 ts=6a9c5f27 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=bC-a23v3AAAA:8
 a=DfNHnWVPAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=ZyhuYgQryO-AXpLpt7QA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
 a=FO4_E8m0qiDe52t0p3_H:22 a=rjTVMONInIDnV1a_A2c_:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIwNiBTYWx0ZWRfX4tUoBFrNPMIC
 cNvyoa7qZx9e4TNV6F0fNJRIrmJMFjCechFBlAcm7llXcSJWDoitQbtJ3V7Kky80JSET05z/W+y
 ynuNAoK4S3eA4ZtO5DdHRP8dLkSefynU76KFwbd3afXhvrkMF2kA3IlwkoYogo+DpUOdGJVmz3O
 7mhjNK76XHyFtfZotR7xJ6sI5peu5m+hOX6a43xBtHvl9wNhBlCcG1g9fjAQ8H5I1M+XG09Pq7G
 w/wCRTTIM9FN65nPP1kKlGzpDvdm+wHZbsmZSjh5U7e2n5fz+cbdpsg7fUZuOnnH+YLEdgl7eTP
 sdl/besjRoED+OWEzm3o5HgMwCxcxZPBn7gRktlJEjtxn8wOr5STAXHagUVv49251xlYskm/Jpv
 SRpUJwscV4vZztpAs008wpxtFweIroJo0sa+rQ9mkWi7j8aD5C7eZfJ+SmpmtyYdAVNYhyk+YGg
 rWUcZAefgn+UjpJU44w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDIwNiBTYWx0ZWRfX9cIRKnXRvOYA
 uAeooifBDlkH0P432rGSQr8VPWIBLZs/xtU41vNLyno9rKrHFfMmaEYxcUqGA1ncZWLSo7k67qz
 saZ1TCgHQ1Bq61xkSuu6RsFbxjvsryVvOZSWoKd4CPsaRCryJ8jI

Hi Greg/Sasha,


On 04/09/26 10:31 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Max Lee <max.lee@canonical.com>
> 
> commit ec3d987fcaf92516d13ee18c305c82281557046d upstream.
> 
> The Realtek RTS525A PCIe card reader reports an AER Correctable Replay
> Timer Timeout storm when ASPM L0s is enabled on its link.  On an affected
> HP ZBook Power 16 inch G11, the Root Port received tens of millions of AER
> interrupts from the RTS525A even when the rtsx_pci driver was blacklisted
> and the endpoint was not enabled by a driver.
> 
> For example:
> 
>    pcieport 0000:00:1c.6: AER: Multiple Correctable error message received from 0000:58:00.0
>    rtsx_pci 0000:58:00.0: PCIe Bus Error: severity=Correctable, type=Data Link Layer, (Transmitter ID)
>    rtsx_pci 0000:58:00.0:   device [10ec:525a] error status/mask=00001000/00006000
>    rtsx_pci 0000:58:00.0:    [12] Timeout
>    pcieport 0000:00:1c.6: AER: Correctable error message received from 0000:58:00.0
> 
> Testing with OS-native AER control showed that disabling only L0s on the
> RTS525A link stops new AER interrupt and counter growth while leaving L1
> enabled.  Disabling L1, L1 substates, or Clock PM alone did not stop the
> storm.
> 
> Prevent the broken L0s configuration by removing L0s from the RTS525A
> advertised ASPM capability.  This avoids enabling the non-working ASPM
> state instead of masking the resulting AER Replay Timer Timeout reports.
> 
> Signed-off-by: Max Lee <max.lee@canonical.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Lukas Wunner <lukas@wunner.de>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://patch.msgid.link/20260707021527.639611-1-max.lee@canonical.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/pci/quirks.c |    3 +++
>   1 file changed, 3 insertions(+)
> 
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2503,6 +2503,9 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
>   DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0s);
>   DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0s);
>   
> +/* Realtek RTS525A generates a Replay Timer Timeout storm when L0s is enabled. */
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_REALTEK, 0x525a, quirk_disable_aspm_l0s);
> +

^^^^


I have run an AI-assisted backport review and spotted an issue.

Upstream commit: ec3d987fcaf9 ("PCI/ASPM: Avoid L0s for Realtek 
RTS525A") disables L0s before ASPM initialization using cached
capabilities.

On 6.12.y, the HEADER quirk calls:

     pci_disable_link_state(dev, PCIE_LINK_STATE_L0S);

At this point link_state does not exist, so the call returns -EINVAL and 
L0s remains enabled.

The required support comes from commit: 4495bffd86ba, commit:
575b98e39d81, and commit: 30579eebba6a. None is present in 6.12.y.

Without those prerequisites or a 6.12-specific fix, I would suggest
dropping commit: dbccca7f5d2f ("PCI/ASPM: Avoid L0s for Realtek
RTS525A"). Thoughts?


thanks,
Harshit
>   static void quirk_disable_aspm_l0s_l1(struct pci_dev *dev)
>   {
>   	pci_info(dev, "Disabling ASPM L0s/L1\n");
> 
> 
> 

