Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010007.outbound.protection.outlook.com [52.101.85.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85BE2FFF89
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 06:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656659; cv=fail; b=Bw9BoVVYAq+OyhCtjX+mQ8zT8hwJ3Ua4t20kQ+L4g17ysr1oXQukaoNZe1qrWCvWakeoelJJ9ukHY5OYTcMWN+dlYRuFLGjqNiEl+CqXY2T7qVqwJvb3RrQlYxN8+mvgzs+hIxudnNSCf2NIJuompkYYgzNVlXmk/eSP8oJdMq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656659; c=relaxed/simple;
	bh=zBwAzWsHPSSg8o+5HF3HJZDaIo5en4MdQOGd0u2b098=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SA/U4C1L/onp7/eTEd89UuzrvLtH+GBFxiBhkmYMQ7ZPTU+l3amebmuWSNdiu5Si2CAmXxDJqmr2JR3iU3GCLueEkagpoI3I4t2HcmHqpOaX9y0qq/kiNDiniL7Y+YxYnjHviYw7x72B5iGDQZk3EU+AMmS0FNLFLhUObic0D8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RDwV23Z1; arc=fail smtp.client-ip=52.101.85.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RDwV23Z1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjNj3/FI9G2heIq2PQcMUfgo7hiHj/UKxElkqLQpvE2S/4jJIkdsnM0HuDsoXads9ncJWIUwQrP3AUt9t31Okv3slapihOrewcuG1NhWZEk82YrOVu4Hbi5ZKMBzJ+cHezCKaooYOrfais35hN+P+z304oF2eiNFi2VQfEBqUaChyXLvFcp+5/upj5CePSpnDInnNzItiILV9VU/SIcTScmvHfQdtmr0dGtEPjOR/ObWce3A5j2Dnj5/XbXdFgLEsPLxlsJOYT4T1N72pbxkLObEdSyJuro1Grv+xe9aM8/SS1/qUf3rXiOx+mb/GvcpDeLVV5rzF5YRgFEdvWHf/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyBprWqcIK+e2QhohypD5h+ismaxl8P29h7DHrGLO1E=;
 b=Fsd8lkg69Hc1OgzVIJAwD+bIRPAVYRdr83zUEDe+OQq+KpzBBsntgDwoFzyUMD9NwAEzwlPcBGQavCLUXKHCkuQHWDcBA88Ffc/W6eaMIpQRhAbFEQrLvYJRdrf3XqiIk6re04gsCe4RUNxk4+RmnRhTdAyQYt7AQ6aCyX1K9R2RACR+A/AU5SLYfrNiKqNJCzQ+Yo0fkOkgCFaoM14X6IGUvPvCsjd6BOpN2VZdEjeingw4V/UcbLtQuq3+92gXvwoIycAIGSqfXcBeDil4pWu+GkXZZ02Z95jRM9teSc2Il7mIgz3D7OqvSMJQcpTEicFDa6z+U237s+RmS0Dstw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyBprWqcIK+e2QhohypD5h+ismaxl8P29h7DHrGLO1E=;
 b=RDwV23Z1dzQeVEuuV7w0g2SjRhm4ZSQUVWxWMdm20xE+92IPVbtnjOmhpvcBukIlbgQ0DO2b0jW0dK4x7luSRa5kRRetht+PtOe15E8qBlF94DOD09sLjX/XJdj6JHDPOy9v0kJKqnC5QYZhKAB5PlbUXfg4AANbtRAj83sWl6Izv7FWnVHNkRD0T2hOgs+/IczWfyL+aY02rAiSH8JGQQFDKiPRQe/pXb4ax5+x3czdP2n9choJd2UR92gKWr/P4hO0mhaVU3RkjIePuqkUJA5FCOpM/gju6Yk4HVZA4r02PAtRm6jz4pdXsm/gp+92jEgP1Wx9rQsqj5kXRDbL8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH3PR12MB8850.namprd12.prod.outlook.com (2603:10b6:610:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 06:24:15 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%7]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 06:24:15 +0000
Message-ID: <ce689597-1f9f-496e-bcf5-ac3a06d8bf74@nvidia.com>
Date: Tue, 2 Dec 2025 06:24:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/187] 5.4.302-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20251201112241.242614045@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::8) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH3PR12MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: e87de3d8-48f6-485b-e26a-08de316b6a6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkkwSVFQbjMyQVprZTFIQ0M4Y1pnc2RhMHhMeVlpL2FUT2pZVVh4UVNVUE5R?=
 =?utf-8?B?Q0xhd3REdHhZWk9LaFBHUk4zL0Znc2dYTzU0VGhHVHhZN2xURGEzWU5tZHBi?=
 =?utf-8?B?TldzNHg3Z0RwZEYxRTBhTC9ndnFSeWJSM0lWTEhHcllwemhEKzBpM0YzMkFw?=
 =?utf-8?B?SWpkZk9JVzRsVG1waXlLZWRjd2E5YjEzeVhBcTZJRmUvM3pRT3QrWkNrWDVK?=
 =?utf-8?B?ekU2dHlvN0h4VXd4OG4xSTdzTVgva3htaXBvRjZ4WUh0VVpmRzhEcFQyOTh2?=
 =?utf-8?B?TkRwd20vdE9xd2lNbnVKWWNDeXplZVVQSmxOWFAwYlR5cmR5T1F6N2gyL2NN?=
 =?utf-8?B?Z2QzMnk2UDA2VWxOalVwUlhoRTBwdkI2RTRaeTdFY3ljb1JRWU16ci93eXdl?=
 =?utf-8?B?RTkyQk14K1dPVHVQVjNWaHkvaEJxOUM0V1ZXc2VBdnE0bnJUd3UybTV3WG1H?=
 =?utf-8?B?ZWJZeDJvUUJhQlc1dy9TWS80clRnRmQvYzhvZjhWeFdyS1NGdEszUHhMYjhT?=
 =?utf-8?B?SEo1aUJ2RDZIUHJ4QWg2SDFZa3VmbHJmeFY2NmVQcjRGbDJVN3p5ZEdYUVFG?=
 =?utf-8?B?QzN6RXJ5MVVsQkV4NW4vZzFJMWxSLzNvd0tBaVlKdTA4VDZsWlBMTU4zSU82?=
 =?utf-8?B?RnNkVjVtUGtOOE1lUHdBeldyWjdMZEQyeHQ3N0s4K2htTnJGZHFLTFNKRmk2?=
 =?utf-8?B?cUd3OXZrR3NxMUZSa3ROb0svOVd5Y0tWMmw2SE4xamZEQkxDV1pFUmRST2dR?=
 =?utf-8?B?UnZvMU9MYnVxSmJNYkZIbEZ6QmVPeWZGcllIWkI4cm5CM3VHMzJGT1VWWWNp?=
 =?utf-8?B?cjY5SGNYSm9keGhNZjRJeVMyc1pPaG04U0hXVEZlOVp3N3huelpXVml1MlY0?=
 =?utf-8?B?aGtpdG9zVzJRanJIYUpoajNmSHdNd2xsMHJ6MS9MVXRicVdoNnJtRG1OKzhL?=
 =?utf-8?B?aVNqRmZPMVdVRGRxZWdtUkNkZmZjcFNGejRRSXg1a2w3L2l1bjVVSjdwd3lO?=
 =?utf-8?B?a0RMZEhTeHpCTTZCbzMyMmJpSGZCRWhpaVVHRWQwR0xhN0NJbU50Y2UxWnZK?=
 =?utf-8?B?T3pVZloxNHVkZWYvWk4zSERBWmlpMVV5TStuWHJGbFhOUDV1Y1EvRlZrZ2ky?=
 =?utf-8?B?dUREN1EzUUNOcFBrdHFOVk9sOXBrOWdHZFVYbFFkNmJzWDZiaEpmOUoxQ3R0?=
 =?utf-8?B?SkpZYjVKTmZKb2dVOG96ZnhjZ1o1Ty81V1BhTWlyYlVHQnJpbVZ6d1N0QUdW?=
 =?utf-8?B?Sk9uR1RheTY5ZkVkVDF6T1V2SGxWNHY2Y2p4WlhaOHBjbm5hUUZuQ1JPSWpF?=
 =?utf-8?B?ZHA3TFpWMDJsQW9DZkt6R3BsWTVDdWlWWmxYTVNPelJNcVpxZnpvZ2piTWNU?=
 =?utf-8?B?L0dhenovTWVnSHJXeUZBVFFVeFMyMXlTYnNYc3RFVk9XQ3VsRGVnWCtyN093?=
 =?utf-8?B?WGNuMVdvMHI0RTJtYUpNeEU5R1BMaWZ4dCtKVGVuTmR6a24xSjFRSW9TQ01u?=
 =?utf-8?B?ZmtWYlUrRG9hdXRwQi92b2xWbUNRUlpabHR0MVBweHpOdThjSlFacVpUN1pu?=
 =?utf-8?B?V1lSM1M5WmlCeGd4Nkk4dHBnemhaR2RJMGR3d1J0dHFXcFFrckYyVThITzlR?=
 =?utf-8?B?NXhucSsvMUV5eVZIWkR0OWlCdW5vRFVUR1F4SkxBZVNHb2NOWG1RUTJUeHpu?=
 =?utf-8?B?NUxTVWt1bU1IWnNnN2lYRUtYbXlyZFhXc0NHSUt2ZWpNUTVlTTNUeVV3cHFk?=
 =?utf-8?B?M2JDa2c5ajdCaHhFaUtpcFlBZ2QvbXMwdjMyV2VtTW03Q3RJWVRNd1d2N3Vw?=
 =?utf-8?B?aW00bTZtRFNPNmxTT2RqUkpIUHRGRHZCZ09nM0M0ZmtRaDN6bStvQXE0TVhR?=
 =?utf-8?B?RXFEVlRodGNYRnVVdGozOUFDUTVBVThUMDBleE8vOVZDYWMxWm10Y0llRHRV?=
 =?utf-8?B?TmtjdzlFb3pKajJaNlVmQ3dWQlB3Q1JLTWpodldvK0M5eDdKaFFFWHJkQ2pw?=
 =?utf-8?B?ZXVtWGR4bllnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDZ4cUZHWXd2S0VCeGlEeDRxeEVYamM4ZE1mdTZ0ZjQvRFdEdmhxZmtRWXo4?=
 =?utf-8?B?ZnNJcEtycG1DTmh2bllRaHg2S24vdEcxelJxenlNS25QalYwY1VFL09wT3V2?=
 =?utf-8?B?aE5CNUx6dnBSdWtZNHNKWmdiWk1QNkdac0grTjBERGJTeDhXK0UvR3ZxRXZt?=
 =?utf-8?B?M1ovNnVnRG85QkFIQVhEeld3VzNib0N3Zm9QUGUyMDBuYmozKy9PSTlXU0Rk?=
 =?utf-8?B?RHNrZjl0N2phMGo0a0FjTEVuZWJ4TE1IYmR5QTlGdkhxWkNtVlFIdUpDcU96?=
 =?utf-8?B?NzFtdTU3YUZiVy84Z1hlaWFZRjJiYjVvalVSTnZTUFJZaVNwK0JndUZJdG9O?=
 =?utf-8?B?UlBaZnZIZG10YXdxc2FDMHRwakk3elN6OWkxZmlwS3Z2OGhKenBnczBaYmVp?=
 =?utf-8?B?U3ROd1BPTDZYOStaTmU5NHVRY2pUYmo5RDhENkNMOS9vcW5NaUhRUkRMWUZy?=
 =?utf-8?B?SmlOcVQ3ZjEyaFducTAwNjVGaEJqTUJoYkc1YWU0ejhxUW9HWEkrTmVNU2xq?=
 =?utf-8?B?Z2J5ZUdWTWZmRFpLMTRMeC83TTRoR2VzbDM0UllSYmNQaFNFS2cwQ0JrdUdD?=
 =?utf-8?B?Nkc3eDUzMlJDSGd2QmJ2eGxSU1hnTEEzM1B3ZG90MU1ZbzVCQ3hmYUNqclAx?=
 =?utf-8?B?cHRHaG1YVWRhbnJQNk92Rk4zQWZvNDEvZ3gwYjJkSWdUMk9xT0VXZG14M3NI?=
 =?utf-8?B?Z0JsU1gyRlZFOXRHTXplQlQyUThabUkwcVhnUzNSOGFpSkN0bStLcTNZQUtz?=
 =?utf-8?B?aGRaV0c3OFZhUG14K3AzcjdnQXhwM1FTLytkRmt4L1Y5OFh3QzNWeFJFWkZY?=
 =?utf-8?B?NHdzem9tQ2hZUWczdEphOEZGZ0JBNVQ5MEMvdWgvb1YyZ1R2WWpXUXdaRis3?=
 =?utf-8?B?U3VRL2ZFRk44Z1hpLzFSaVVhMnk0bERRMTZ5TWFhWElncFlNT3BGOGtFczN1?=
 =?utf-8?B?WC8zZkpJQmxWV05HUVptallPNXFTY1AzRTIvQURxemdVZndZZTNwUWk2WXg3?=
 =?utf-8?B?QUFLblZlMmpoeW9YdGx6TWpUL3ZjQTdkZkE0Y0lQRG8rcGpDYXRhWTVGajc5?=
 =?utf-8?B?VEQrclMzeURJaVdRamlWZ3d2OVl5ZHFsZ1hySFdPaG12M2JoVzFYeEIyMVpV?=
 =?utf-8?B?dkJKa0oxc2hhY29UbkNwWVpSLy84cnMzL0Jwajk0TUR4UTBXUnU1aEpyaGxq?=
 =?utf-8?B?MDhnM0pjTVd3OGZhelBJTzBENFZpRVhQYk5rdWt0MzV2VWZQUmhiS2dPZkdT?=
 =?utf-8?B?Q0xmMGZ6VUc2TmxLbm9IVWZnMjl3RWJxQm8weEJDdm1tUmsxYS8rNXZZaC9w?=
 =?utf-8?B?YVJ0cFZIa1RCcU1oMW1TWDJ2N2RMenNPc2dieDcyTkppQ1B2QkgveTNUQXQ5?=
 =?utf-8?B?bWYrMHQvWFlLV0UwWWtBelZHSkZIRXU0QUREWTFDKzRHU1Uva1VjZ2oxcUx2?=
 =?utf-8?B?V2I0d1lWY0ZQdEF5VlhoMGdYZ2h0bnJRZHZBL0Frdko2dUF3NU5Wb0p5dEVl?=
 =?utf-8?B?d2QxVWg0NmNWVHNPN1Vlem45dGZ2RzZ2UWxNQk5uS0hPQnZCWWxzMWUwb2k5?=
 =?utf-8?B?bGkvY0VqTWpZTlNFdHJCcDZXL1NsT3hFUUdaYXVzRVFTK2dJbUh4eVY2WGNS?=
 =?utf-8?B?SXBtMkh0QSttZWUrcm92clVCcEZJMGlNZXhSZmNIcVRyT0FXSk43dnAwVjBl?=
 =?utf-8?B?cDlhaTJCRnlJaGhacFkwNkVUUXJwT1BVTnczVlJVM2hKM0h4TytoakE3L3F6?=
 =?utf-8?B?Zm5QcS8veXIxcldPSG01T1I5dU5CcW9TVkMrcmZjb2QxU2o2UnVjbDRqdkU1?=
 =?utf-8?B?eVkwaEM1NElnQVZvbmtKNEpYYStrdjBUYU5pNlV3MEZpRTAzMkZiNDFQRkx6?=
 =?utf-8?B?WmdWbUViaGgvbDg1RklzTmhMWkZ4cU5zRDhRSW9vb3V5VjFnQXU3QzBWK2tv?=
 =?utf-8?B?dXFWZ2g5bFQ4TVpOUHVkV0p0U28wcE1DK29xVjFtZlVjUUk5Z2FrNElrY1VE?=
 =?utf-8?B?cm9sUGM1ZFVpOXNnckxGaHlsSW1ORDZldDNXSWVwdHpWN2E4bHdXV0dtb1R0?=
 =?utf-8?B?ajFRWnJ1T0ZnbTI5K3N6L2VvZGtZMG4yaGI5OUltUUtMamxtUlZUeHBCZ3Q1?=
 =?utf-8?B?Q0l4UStVZ0thMGREZVVaV2JEOG1adWJ6SFVmajQrbGZJY0JJblJTWHFxRkp3?=
 =?utf-8?B?aDBNSUxDa1lKQVAvbWFsZzdDblJYa1IrZ3Bla2xsN2tUb2RLc3g4cXIzUDJ6?=
 =?utf-8?B?cWY5SmFTK3V2Z0JCNFpZTjJZazRBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e87de3d8-48f6-485b-e26a-08de316b6a6a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 06:24:15.1400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g3yZosihwJ6nQ8lr/KsN34hmlSmrFGSOmLGXPOjSwSNrw5H7SaViDSH5AoIw27202pAw41Dqp20rpxRfFPVgew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8850

Hi Greg,

On 01/12/2025 11:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Dec 2025 11:22:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

...

> Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
>      mm/mempool: replace kmap_atomic() with kmap_local_page()


The above commit is causing the following build errors ...

kernel/mm/mempool.c: In function 'check_element':
kernel/mm/mempool.c:69:17: error: 'for' loop initial declarations are only allowed in C99 or C11 mode
    69 |                 for (int i = 0; i < (1 << order); i++) {
       |                 ^~~
kernel/mm/mempool.c:69:17: note: use option '-std=c99', '-std=gnu99', '-std=c11' or '-std=gnu11' to compile your code
kernel/mm/mempool.c:71:38: error: implicit declaration of function 'kmap_local_page'; did you mean 'kmap_to_page'? [-Werror=implicit-function-declaration]
    71 |                         void *addr = kmap_local_page(page + i);
       |                                      ^~~~~~~~~~~~~~~
       |                                      kmap_to_page
kernel/mm/mempool.c:71:38: warning: initialization of 'void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
kernel/mm/mempool.c:74:25: error: implicit declaration of function 'kunmap_local' [-Werror=implicit-function-declaration]
    74 |                         kunmap_local(addr);
       |                         ^~~~~~~~~~~~
kernel/mm/mempool.c: In function 'poison_element':
kernel/mm/mempool.c:103:17: error: 'for' loop initial declarations are only allowed in C99 or C11 mode
   103 |                 for (int i = 0; i < (1 << order); i++) {
       |                 ^~~
kernel/mm/mempool.c:105:38: warning: initialization of 'void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
   105 |                         void *addr = kmap_local_page(page + i);
       |                                      ^~~~~~~~~~~~~~~


I am seeing this with ARM builds using the tegra_defconfig.

Jon

-- 
nvpublic

