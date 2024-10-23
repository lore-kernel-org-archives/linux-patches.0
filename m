Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C151A19AD93
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 10:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729678605; cv=fail; b=CzkcUxe9g10tLh66EgOs//yEmQDwqOzazQMt+2eJC7OPB0xv/C+yphLYoSg75T8p9jsWGHH42jvQSm3mkNp10RSB/0IiWrzOrRLgP4DClLbU3dNbm1kNXXePapdNT8U1pJNsMu0IfNF7HxICelfBrhYREumB6CvMkqC5OIlXZHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729678605; c=relaxed/simple;
	bh=59nw9zBj93R+9rvxhns0CcovcewtpTxaduGypQtCZUI=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VpdpgbbNulNIVnISqgWAAfe+g20A1vP/qpPZxYHy3hq9muprxFLn9pTequJJDTCvRlDoRzXy3F1NufYVS84sKyMqU06iiMDxmrAE/OLTNHR3e305P+gCOJH7BNCNZHygb/ET7Y0D6uqVfiM1rbwhTVb1jgQ1Uz3dHmgipWjElN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rx0p1gXz; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rx0p1gXz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZpZB/AixMdhXYQ62WMu+ed7DYoStlZeLR/g7bQZnLCbryASds7pSvIrBy4b/DCji2zfSDIRDtrpW7EgSQ+vMixTxGBeiJ92qprwOA+BWD6ebYzwua+MEg/2iQSDYjQ/1I15n6dE76YNaBy1bZQsf1hAfh3bgWgbvk2SWf85hNQoImxXC8GTcKL+vsfFe07+YJeXmf0G5M+mw0Nx9R5TLSNMLEnzYWExFZQJgIAkitFvRjvYqN0EZPkz8jw85TcxNM5EuH2Cr2yI4yHGZWEgMkluZO2vJeE/nkqo5gDzA1RGAPpZKa02SzK14WJ7Lc3AHHuZBjcUDRgiLjq979SopwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VutqH6KQ0Tpy3Cwt13Disrx/R0hEEsMKIrcw81LUUA=;
 b=NuhGSkc6KvOnyTMOlN/SOR+VK7BrvBwBErEvRx98t2ZR3tr8+YaMXf8rV7JSpC0slaYk9OhGbClzjZtzlPgIwGGscNIThV8X4ThVePdiRevd89QHWixzV4KZaPl0xmD9iqpYYNGX/bxFPAROscBVGil+cwyfM/4n8zLdzwYJqS6U23764+PidLRC+FprPjlUm9zeQsnWGIBmNfPemGsPeC5ED7EDwtKa/J3fQlqYCZlcHkIBXbL6RdAqJXbRkq12S6va/vcKXIs3MW1l5sIOljBjR9JdS52HVOZVV6IWPaOXZCBhSStrLOGph99GXXxeJ1YtUhxg2ZNWd9+snZO6cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VutqH6KQ0Tpy3Cwt13Disrx/R0hEEsMKIrcw81LUUA=;
 b=Rx0p1gXzHJQCyifowHZBxcgahJD3KGVYq3BeY0YvVc2g0tiWamnUfMdZQdf9oSV5p1BLgVP+1BVC4gzo2BzVRZpCQA4jMS3Di+z0iqg2Sip/QD0BE4c4GTAGx7Kp0kC7CEYO66UixjpiqhyM7z7d3NzcGlRfX18aFV4CwomEudJ52dMukU0luYZqHWJB+G9CLs7BLzJPcXiG1fGTdLc/pN2Ozk3bz6SiQOTGJ+jJb6VBipBpWs+PQgfgZ31i+HlzDhWEb7fReY+7kAqPT8Rm5W60pQ1Z0jFlQNtPly59n8dz2s3DWn28q/AbtchVuYaE3e94auvax3liWdkYyl8xNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by MN0PR12MB6152.namprd12.prod.outlook.com (2603:10b6:208:3c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Wed, 23 Oct
 2024 10:16:39 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8093.014; Wed, 23 Oct 2024
 10:16:39 +0000
Message-ID: <5baa9081-cf9a-461d-8fe9-4c5559547f2d@nvidia.com>
Date: Wed, 23 Oct 2024 11:16:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241021102249.791942892@linuxfoundation.org>
 <23d85d2c-553d-40fd-a1f5-3356e12160c1@rnnvmail205.nvidia.com>
 <225ee26e-e157-4f30-934b-e7a902d67257@nvidia.com>
Content-Language: en-US
In-Reply-To: <225ee26e-e157-4f30-934b-e7a902d67257@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0236.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::7) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|MN0PR12MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e0ed6d1-c0bd-4ec2-812a-08dcf34bc859
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dEdSN243a09vVUJseEJ1QWJobUVUN3dNcjBqZDNPMG9xa1Fma2lxcHJqbHhQ?=
 =?utf-8?B?ZjhvVXRrcXN3THBwYlVRNDdmUzhVQ0NHaXkybXdqTUVKSnI3U3ArWG5DalJV?=
 =?utf-8?B?cnBXaHJYSERDUFh5VTF1N3laKzUxT1hUbEJNek05cDhjRUpnc1ptTjQvdTJr?=
 =?utf-8?B?Z1FuV0pZUVpaTGJrMWp5SGJob01aMlUrdmVpOEYzZGFqWXFhaG1IL2hKQkxD?=
 =?utf-8?B?NXBXVmtFajJ0dVZ0WXVRSU9FV0MzZ1VGa0xSUjJjSW9CTlE1RlFMLzdJR2Mx?=
 =?utf-8?B?bjRMeTB6RmtTTVphcDg2S0RFM0pna2xVNDRqQ2V6Snk1SmNOY1lKVkhtZjZs?=
 =?utf-8?B?T0RGSldvUG53aml1amlYNHdybnBWVW1yQ3VxRmh0OTVGR0h5L09hSlFwMEtj?=
 =?utf-8?B?czlYN085WFRKby9XdkxVUmlNbkxXR2dTZWZxQlRlMWxYUC9OMGt3NjNHM2RC?=
 =?utf-8?B?L1lCTGJGdzR4VEVoVHIrK2RNRVluNUNWdUFrQnJYNnUwQ3ZFUncvUlVVVU5m?=
 =?utf-8?B?dlBHVnpHMGg5K1BTYUIwZU54WVRCTnMwWXJSSGUybjdwNStTdnBrdXYrZmdh?=
 =?utf-8?B?R09mQnFSVFczdVgwanF0OWZzL3F2NEhpcXEyTmVnTE5mRFZBVmorMVZiT2tx?=
 =?utf-8?B?L1ZHaUJIdWdFc0NwSThPVkZZQ3RDdUl1dEZhWFVxMWl0STBMQVlwVkt2SnNt?=
 =?utf-8?B?d3lyS0FMRy9yT3BJZlQ5QStRL3dLV2ZtZWdHUWxTUlJyd2JmRi8xRTJzRlkw?=
 =?utf-8?B?eXI0U2dzMjdoSEtIRFdVM1hjTGNSSkwyMndvdlkwMHA4RG1PR1RTTDFBTXNO?=
 =?utf-8?B?eHphbTZsOGtpb3B1aWVrRnZ0N0g3MmlqeTlycVVUVzNNaWQ3STdHdC9UT2hV?=
 =?utf-8?B?NFFGc2hFT3VCRnA1ZWJHRkRIOVVvaHpCVTc4ZGhnZHcxLzUwSHJtUkJQSi9K?=
 =?utf-8?B?aDMwTXJYNXYxSklpU3cxdzBMY0V0eVgrQkIzaEZ3UUZBdDB3NXh2UlFMRmMy?=
 =?utf-8?B?cHdES2w0ZGJxM0h2cXdUQ1BjU1loSXJiRkZhY3JSd0hTYVlEbndjV3pyOHFz?=
 =?utf-8?B?cjdKcmwxRzZOWkxGdjFZRUJUWUpMQ0U2OHhuMk5ZK0VOLzEzTXN0R01uSzY5?=
 =?utf-8?B?WDdYNENqbnBXaDF5NmVoSWllaUZmTzduWXB3MzlsNVJ5WXpIV3MyNkRWVytT?=
 =?utf-8?B?djlQK056V3RCMU9kcEtKY1BldUc0eStDOGE3NTY3RldiTVg1b3dxNk5KRVRF?=
 =?utf-8?B?ZGlITXFSQUJGUE43UDljWHh6MW5YWFVrVk0yWWFuVUUwSWhZdmgvVDFxQlo4?=
 =?utf-8?B?T3AyUkRaTjd4bXF0ZzJ5ajRiWnNWTDc3MVh5N1ZQRkptN3p2TzN0eW1YckNI?=
 =?utf-8?B?dU5EUGg4bGlRNkVCNlhJcE5TY0pTNmdsaHIrQWJoVVU5K2s2NHByWVhqRXZj?=
 =?utf-8?B?SXdGb2RacllLSjR3eHQ5amlvK1ZyU1BoUWhVT0swTTRHbE9BeTFVVVNVT20v?=
 =?utf-8?B?S0MwdlNqY3RGSzROZ0lxNEVTRjJudkxNMTJReStmb2xQdWcrTS9VUk1DaERo?=
 =?utf-8?B?SitFd3ZQcy9zTCtoQVRCd0Q3TmdBeUxORC9WV3Z2NFdjTlhWZXJxeTZKTHVy?=
 =?utf-8?B?ZFlKYUxPQ0hxL1VaZnlqREdTKzNTZERkUUVFQ1N1TFJ2YmVQbi9HSjg2R2M4?=
 =?utf-8?B?UytWY1lxUExlbFozL1VZS2RUa2g0OXlKRkdmS1lOUUlWZm1aRnhtL0ZBN0pP?=
 =?utf-8?Q?MO9lOzOb190OsD9Iq5oYLm1syhaLcCrTTpz00b1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2dCMzRjWjh0d3BMRmVIaEZUWVVmQ3pXY2MwTGNLZmJNeVd5N2k2bFlNMGJM?=
 =?utf-8?B?bmp0azJMc0I0V2pPNkx0aGlDb2lwRU9GUFNWZEdHYXRkbWFLQmlzWEgyL1JC?=
 =?utf-8?B?WmtUMVN5TTgrei9HNHRISXV2OVIzaHFURUNPcWNUc1pyaHdNQjE1MDhpVFcx?=
 =?utf-8?B?RGthZDkxTTRaM2lLREc4bGZLckVoR3d4TlgyMTcvd1U3cjdqNlEydXFHK0Fl?=
 =?utf-8?B?dHJPZFVrUXBaTTVXMlAwc1g4NFVjVWpObjE1S0NEM2VtY2p6ZnU3cGtPeHAr?=
 =?utf-8?B?bzNncVMyUmxOTzljR2tGVDZ3ZVVMK1RNQ2xwTE5OaU1Uamk4RzRCTE45MXJj?=
 =?utf-8?B?MDRFWUpzWW1KaGhGc1UzQ1U2QWd6TkhkRk1OYi9xQytrVVBQQStKUEprb0kx?=
 =?utf-8?B?bVNmU3pobnlYMGdZck5rOC9QaExsbkY3RnNSbk4yMGpnSDc1VWJ0RlhqUEZk?=
 =?utf-8?B?SHRaMWFYYlVTUnh6TVloNUFVWlYxZEdEcHREZ2hEK3hweWpTREF4Z0g2U3dt?=
 =?utf-8?B?OFhhR2t1dWVpNHB2ZlBzL3dkUSs5Z21nLzBrK2hKRzMyOXBveFN6b0ZoYlF3?=
 =?utf-8?B?SFdiL1VwT0tNak1oR0RlL05wSUJDQVB2RmlvWlIrY1BLanNVeXFFRWF0Z1do?=
 =?utf-8?B?YTZDcmxLY2FiZE8xcVpCVFJ6UTlXSWtvUEg0d2VqMjNheWd3SERMbG50WXNW?=
 =?utf-8?B?YS9pb2R6WGpVNTgvdGhDbzBrZ2tuYzVEZzhhb2w2MGVnT0tLbVhFUE1meEFT?=
 =?utf-8?B?bnYyd2tLR041dUN3TkxuWlZLZGlYNjdXLzRGbW5rakw4SVZ4S1pMYk1MUmhx?=
 =?utf-8?B?YVlEdHE3V3JHQ0kzdVNuNURMbDRhMklCb3RNTytPeG1xcGNrVXo1ZTd5c21y?=
 =?utf-8?B?MkZRSmpWYytFM2ljTWowNXYwRXJDaW9SRi9kMGV0Qlg5ZkFERldNVGxvdDRF?=
 =?utf-8?B?Y0tsQ05hT2x3S2VXZzhEMGNxWm1HKzh5N2k5TjRFQi9rdHEwUVZScWQ2SlNj?=
 =?utf-8?B?R3ZjODEveGxLQitXOUdvODRoL3BkbkNneXcvb1h2YkdnZXNHaWlkMk5oWGtK?=
 =?utf-8?B?dTBISWZOQXAxMHZmRi9iamNwQlJsNjRkNUtpakNrWFFaempHYjNNOEJPS0ht?=
 =?utf-8?B?R0QyVTJvYXUrbnhWeGhnZitVV0k1K0RiTnVFMEVTS3hCVmRlSXNrK1RWWW5y?=
 =?utf-8?B?aktRdm5zOWVrVU1scGtjR1d5eWpzV0RXUmM4YWtXNi9hbFYvaVJocDBnYkFK?=
 =?utf-8?B?ME45RmFBVVdzbWx6RWEramQ4aklCSEVoN3hLaE4wY2JYdkRqSHpKckhoZjU0?=
 =?utf-8?B?dHBxTmFSalQzakFzS3hmckFqdlNBN25pMldqSG1qS011T1JZZG5PcHZGcnJW?=
 =?utf-8?B?V3RRcGk4TnozWERiRWYxOFNMeml3LzFGZ3RKd1AraGtGRDRGZkxmOUgzY3JI?=
 =?utf-8?B?VzZNb2pXMTBqQjhBalJRZlMyczNTOXpLL24zUXFxc09sMC9Yd3U0ZDlTeUhO?=
 =?utf-8?B?RWcwaWhKUHpVdVFXWUxLU3NPNVgyanBWOTRwekVnOTRHT1E3K2hvZTVDYXpE?=
 =?utf-8?B?TkFxMzNIZFR3blI2bjVRRzlkeU1jMWxtdGgzbkhScEJ1RmdXNnBjRE5na3cy?=
 =?utf-8?B?VDJMS3pSMUtTVlNFZ2w0c1dUMmRyYjF2VWpuQlVWVVFRc2I1ckFjVm5sUmxw?=
 =?utf-8?B?TjdBRFJJU2lMcG9waThKK3lMekZUK2JYSE91dzdRVzBqSTVoTDEzdlVjTFMw?=
 =?utf-8?B?Q0NlbEdTcE1ib1hRUmo5Z2hiWThCMmk4T2VhcnRhelVadkdzeVVtaTJ1L2ZW?=
 =?utf-8?B?eU5iS3ViQ0QxUVMxT09Sbk1DK01SYkFiam1SWEw4a3daaHY4RVBuL21RdmpF?=
 =?utf-8?B?M3ZlR2FCOWxsUWk3Ty9QRTdDN0VKQVBxUi84YklqY0dnU0hCNEFMYSt1TjZn?=
 =?utf-8?B?SzRkRXVxQjZ5KzFGVGRYOXpRY1ozLzdXaS9YN2o2K1ZTMzRRRWRNU2NsaFFv?=
 =?utf-8?B?QXljYkhhbFJpd21RcEVkQW5razB3bEZKdEJjNDNjZjV5aHQ5RlZacWQ2OEFa?=
 =?utf-8?B?WW4rcUw5elhkVDZTQnF6cE1LVlhWQ1owaXR0MGZ5YVJSOTNUdElZTnJWV1VU?=
 =?utf-8?B?bXlveE9rd1l2MlMxeWZyQTRndW53MkgwNGhvRVBUR0piUlE1Tm1NRmN5bi9z?=
 =?utf-8?B?aU1nTjdSaHduekZEc0ZzbUhuSFArTlNIOTg3cWFRU05QR2tCaEFLV2dlZnhN?=
 =?utf-8?B?SXdCTmxJSkpERHpBWFlON0xVazJBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e0ed6d1-c0bd-4ec2-812a-08dcf34bc859
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 10:16:39.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTypccj/3VH748r/RIAh1pBE+IzHjmX1M1QvdfdNgiW9S2Y2BVjPENIFdie+uGpWAbLnInpx5GiiEvWQwchxCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6152

Hi Greg,

On 22/10/2024 18:58, Jon Hunter wrote:
> Hi Greg,
> 
> On 22/10/2024 18:56, Jon Hunter wrote:
>> On Mon, 21 Oct 2024 12:24:14 +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.114 release.
>>> There are 91 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Failures detected for Tegra ...
>>
>> Test results for stable-v6.1:
>>      10 builds:    10 pass, 0 fail
>>      27 boots:    26 pass, 1 fail
>>      110 tests:    110 pass, 0 fail
>>
>> Linux version:    6.1.114-rc1-g6a7f9259c323
>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                  tegra20-ventana, tegra210-p2371-2180,
>>                  tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Boot failures:    tegra30-cardhu-a04
> 
> 
> I am running a bisect to narrow this down. However, just wanted to 
> report this. Appears to be the same issue on linux-6.6.y.

Ignore this, it appears to be bogus. Both v6.1 and v6.6 failed 3 times 
while other kernels didn't. However, we are currently down to 1 
tegra30-cardhu-a04 board in the farm and that one appears to be having 
issues. I may need to drop that old entirely if we can't fix them.

Jon

-- 
nvpublic
