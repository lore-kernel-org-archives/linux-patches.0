Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7EB2F3C35
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661026; cv=fail; b=osOdxABDfV6UiEmHtX16BYnp0XrKDAV1mXpVTOwXffUSmB//nKVjO4IdkkhEOwvrY9ZNVFUzQSD45ezKd/+NWSXgv/XiOG5CrZhgo7qdJjR7S5IccmpAbe6yx8LX/Hxbk1p59MfqCeF0Io23HBi9wKpClgzQTJUpSgXn8QvvwAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661026; c=relaxed/simple;
	bh=VR1+tw1mZePRFXiIJPeP02LKQEen80BwxWraumrvyHk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MUAVWSFFoNuH3y3g42wwTa3LM9CtJSWUt+eyPshGgW1uqkg6rj5XIWQEgtYaWbAfrzXmnJ+qr+KYEdwhV/wytZ6+4wao2Zs60zoCiakIH7qZ5D/WivzTmQlnarbQpbKZ1mGbo7pRX0kPla68ER0Ei1VKknS1B+U5Bvx23mAAXoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o5+I/48Q; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o5+I/48Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnAoYREXym53sTUlE0gw5NQddyZvML8IjPKiNSMpttRXgO3YGfrgtT/7ISIOvao2UMrJxHu9Eq9Onfn/CVA80n0zNpt76QpGRwNIF46IpN3CcNUQGwnVCKWcwchOIwlMxb6mjULjK/iyQbR4scaTWxgeNlxJnPGVCM/4MhqICOnEdues199hQjgUjBOYN4e0lFFYRPW89pGFK+XM/zEH4Vv8n8sZVK4XxhUfuR2a7dHbraw+dU66oEg6ES8y5HjtZW3wG9g5KDPZtgdlZRPSbkhwHWB5F6KAgFA6LqfRuSUVaM9zbdUNxrW2marDUBYZp6dYoAzUetZEUyYtLlC2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtQrbUbnuiq00EpXLHYxLXaebe/Bfq03m5LKveT85/0=;
 b=GG3J+4TcExI4rCfX1QPccJbpAXWrxO/sRIx68wKPzfUkyWSdN/JrzFjGQUwZNCstN+K+zIDTADO4WMAQlFzpR1Or3AIKH2OlqqlcouxjekuoCntgUiWhgtUVoSvTTtrsyFw1ggGbciRQjFHDcYjJ9e4s/zpMJpmIKmXEK6EbpvVkkUITpc1jBEsNbGrYa+bUgMpUZ+PigRBsRk65IlqNx/jCFoOEx2wTpXA4ajabXSxsOCk1urtFxyi5XlqB4m+OePaX4AipQeza49g/HV+1k13s9uPgJDApinZVDNaK455LUNdVyswKMOsjVKKYfkjI/7oEZ8oqofRisYNf1rYkkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtQrbUbnuiq00EpXLHYxLXaebe/Bfq03m5LKveT85/0=;
 b=o5+I/48QnUxMxqWuFVl2sQ3ItXRrx6UMbfX111JGZZWxsCJmNBddd52iEqGHWnWP35C6X2pHcjQLZ3O7wbEYJxC+Ttp6syvmTYEPdmqnrPJT/FsN+Bj6pRqnE8pAolcrdr10TRC9/IfRZS4BB7vh3+YgvTiZ8c6KCxtPdLgOg+FmhwKndKKszv4BQMG7htI7KgBEM3lUkaE075m+lvJu7Y5cbeKgp4A05b037+UEJny4HwHKQdw9Wl7BitF0Gw+jUSuVR9CG1T/qmPaejfHBsFblf4DTEW95PAf157EMHYO4DVwSnDwQy2BGl1/37evQNT4siOcYyJejJlXfenJ4kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA1PR12MB6773.namprd12.prod.outlook.com (2603:10b6:806:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 16 Jul
 2025 10:16:59 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 10:16:59 +0000
Message-ID: <97b4d154-f0b0-4d09-8106-842ca1c4768a@nvidia.com>
Date: Wed, 16 Jul 2025 11:16:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/148] 5.4.296-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250715130800.293690950@linuxfoundation.org>
 <451e4d80-d033-4a7e-a874-27ab053ef249@rnnvmail203.nvidia.com>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <451e4d80-d033-4a7e-a874-27ab053ef249@rnnvmail203.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0452.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::32) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA1PR12MB6773:EE_
X-MS-Office365-Filtering-Correlation-Id: 52465093-0923-4319-d1a1-08ddc451e61a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzhQcGllZEh4cWh5VVdJckZDMUsvYy9YeWtJOU5MY3EwVndWTURQTTJOcnNX?=
 =?utf-8?B?K29CdWRabVdobnFYZERlNHp6M2FTQTlLZDR1OEh2K3ozdjh1cUpVUnpUZ1p2?=
 =?utf-8?B?Y0MvcElRaW9HZUU1VHNsby90bEZkWUdFR1dPblJyMnhOdE8vR2xyYm03aXE2?=
 =?utf-8?B?Z1NhM0p2bmxuUHdhVVV6bEFLeWNOUWt6dFdzbjl1VkNid2FvVkFkb05mK1Nm?=
 =?utf-8?B?NFBqa2dUMGYzWDFGRklWejZ2d1B2QUk5eXRNdlU2RGZaSXNYbDJ0Wm5WREdE?=
 =?utf-8?B?N0hzeTI1blRaYnFDVHN3eENwa1lZWFhPQnlMVGl0L0dFRi9scjFxV0NJYmtQ?=
 =?utf-8?B?dk9TM2x4bEtIRWZPQkVUeVpSbHZJbXdKVkY1bUZTaFlWTHdpWTBIeW92Ym9l?=
 =?utf-8?B?TytKS1dwOXpGc0FEQlZuRWtWUWRmUldHb1hKTGhjbzQ2U29wYVU2eFRDVmcr?=
 =?utf-8?B?aWYwcmJpbGswOFUrMlBrWjM1cWtWbCttd0JnTGtUU0xMd2EvYW52K2NOSU52?=
 =?utf-8?B?UUZqVWhBejNiQnJDUDJFdUlTWWt2Nld3QWhtZGlCcFhXK05IWnNQRHBEZ2lP?=
 =?utf-8?B?d1FCbWhRY3ZYWTdZQ0s5V0NOYktCWmRobmRsZ254eUs4U1duOTJ2aEhzUzdm?=
 =?utf-8?B?YUdxbWQ0ZnYxZTRzYndabm5kR2NOUENzUGtJUm1BVGhRNUZPcHBWekhhalNB?=
 =?utf-8?B?aDZBVnlDQXh6Nzh6aUhUM1FlQzJHUG9PN2lJWTF6bWN3N056b2RyQVVCTDNW?=
 =?utf-8?B?Q3Z1Y3hQWmpQeDhpcnN3TlE1WDgzWWZmMlpmRHUxaFFxeS8wZkRXT2ZkNE1P?=
 =?utf-8?B?cmtHOTd4UURJT0F0K2hGcElPb1Fzdk1tQTUrM0ZOaE1TNUwxcnc2b0NJMVgr?=
 =?utf-8?B?ei9VMXFmLzF3TTdzYWtXdXZNZzF6dUpWeUdrNWpiSlY1NnlNNC9WczlCeG03?=
 =?utf-8?B?UkdKdGdwN0dncU1NaVpVNmFFY25pZ1BFSS9lU1JrL3o4aWhhZzZTNGxmT1Fm?=
 =?utf-8?B?WXlwNFFXQWdFbHh4K1pSVUFPNE9TeWZ6cVZsOFRwaFZmYmZTTjRkUkM2OVNL?=
 =?utf-8?B?V3g4SVhGdXo3NWpmQ1FkNCs1aDFKemM5bFNUZWxYRzhhazIyNWhMYTJ4QzV4?=
 =?utf-8?B?aENHa2R2YXhpb1JXZjIyVVVGZ2h0SW5SRW83VGk3NC80SnJlRkpNUGZnU1hB?=
 =?utf-8?B?eEU0UzFtaGozVUZvRk1oeE90MlpLUXY4RHdGWTRoWHc4SHZTVE5TbUpsUkRj?=
 =?utf-8?B?UFd3a3hMVzgvQkk3QnRaYmRwK0NpdEpHK0Q1TkRqQzR4SHRQQ2FJYmlWTlNy?=
 =?utf-8?B?RkVvelZoSjcybldqK2FQVTAvUC9uR2YvbnQ2ek5SR05qaGxFell0cUppVzZZ?=
 =?utf-8?B?ZjR6NTBRcGdaeHB6YnBiL010MHEyS3JkMDg2MTFZNWkyYmdRbkJvQnlWb3cx?=
 =?utf-8?B?Wm9rMWVERENUdHBxeVlmcG9BNkJ5djQwNmlvd0FyYVVZa0d2dlBYcXRSOVBT?=
 =?utf-8?B?a1NDMWh1S1NqUUtYL3lRTGlWeUhiT3VUdkMybTFtZWRvUXkzSHkrdHFXZ2Z4?=
 =?utf-8?B?UlZRd2pxTDQrM0owL1hKWldqNHRRdE1mQVdWZkpvQkx6dWRvZ3puVFYxZnVh?=
 =?utf-8?B?cWFDeFpEWi8xVGpUNEc3U3FvNzRrOXduRjJnZ3VTTkQwRHFjQkxwRDZabkFP?=
 =?utf-8?B?Tm5kTW5HcjQrU05DdHExd2F0Y3VwL24wNXNlais1aWZPZU1XNWorMVl3TWJk?=
 =?utf-8?B?YnZPbFNNT1Y5TjBaRmVsZ1FlN0t3L0JhREhHRGFra3NXeTJsakhmRWkrcFFn?=
 =?utf-8?B?RUVnb1ZFTWZUV255b1NPdnVsc1pjcENKV1EzVndmaE9RMHBlQWs0SnNoa25C?=
 =?utf-8?B?VWhaRVVVY2RZYWhsQjJpeFBudWp3QXhaUGF5aG1LZFN1SWcveTdHczZGVUxp?=
 =?utf-8?Q?F/GURPs4VoA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUQyRzZ6Y0EwWjkzRVBsUWx6aXhJZW1hTnZCVVVhalNyU2FVNm1zTjZuTml1?=
 =?utf-8?B?L0RnWEJVU0lSRlFwRTUraG9VNGREM01DOWhSTk9OVVYzYzMvMUtaWHpVZVBk?=
 =?utf-8?B?SkQxdUJHT0M4eHZNU1VLSVg3VEMxSmhRRzdEdmo4RUY5REdkSGNaSERhMjhn?=
 =?utf-8?B?TDZUREYyek5xUjkwOVJHM2VwT1ZUemhRVUZBaDltS0V1aTJQa1AvUHhkRFZm?=
 =?utf-8?B?blY1U2xiaFlkR2xTQURZZDlNM2RBVEQ1OVJ0QVdrY2ZMc0lqc0ZWOUxUa21O?=
 =?utf-8?B?ZUxZQUxvWWx5VW9OYjMvM1E5bndqSG5KTENlZHRXa1phQVJkeWRrQkRiL1hS?=
 =?utf-8?B?Y1F4QUtyblBTNndKRWF3T0FnOTJRNGhNZ3VhSHFFVS82ZURORUpRSFZPYmk2?=
 =?utf-8?B?Ny9VbmhoK2p0M0ZVejZyY2RZSmI0RWoxZU84dFIxR1g4SjBlcld0ZFUvT2FX?=
 =?utf-8?B?S2hlWFpldXNVNmJoZ1oyS3dqVnpEMEF5NTNUNTNVNGRMZG8yVE4yZk9pQWRO?=
 =?utf-8?B?RXNiOGV3RE5aZXozVERKWERCbUVjSHIwOGJZS1o4Z3V0K3JIOFByM241Ukxp?=
 =?utf-8?B?bkV2OHZGeGtEdTdITXB5YTRnOU1IZ3RGL2RwN1dhSjF1UE1jbW0wUmZVM0R2?=
 =?utf-8?B?UkgyemEwdUpId2pwYlRzYm42UE1aSnB5ZUxXUDJnOUJ6bVlsSWd4OWpqd1lT?=
 =?utf-8?B?YkY5czZocWludjFBcUlZVkRaRk5ONGRrSzlCYTN4Q3RMMFIwN21pdDdqRC95?=
 =?utf-8?B?WG9Fa25VNktVbW1VaUNMaEh3aFlrY3ZLeFhXdTdhTUN0Mi96K05UamZwc3pH?=
 =?utf-8?B?N0RCTjE3aWtWRFhwWDFhRkMvQjNPVG1Zak1YSTM1QXkwL0w2WHdoQ3FaOUk5?=
 =?utf-8?B?VWpNLzV6dm5PRlBGYm1NaDlpVDh1QndmYTJkQkF1MGdhNVhmYWh0S3RNOTYr?=
 =?utf-8?B?TWxsYU5hQ0FmNzhJQ1d1SUdZVWc4YUFMeENOa0JtUXcraHdmdlRNdHZsZnNx?=
 =?utf-8?B?eEc0MFlNemxoQjJpY0J0Q3M3dHBIUjMxb3VKdkMzZE9KSmdvMmRNS3Q1N2ZQ?=
 =?utf-8?B?L20wcUY2UllQQmZXZFg3Tk1YSjFYWTJFQS93bUs3eG1uckxaa0xSNWdUV1Za?=
 =?utf-8?B?bXFiUmowQXlsc3N2cFhZMFQ5YXozQzhtUGxuZW15MDAyV3BVZDVYeklHSXhs?=
 =?utf-8?B?ak9uZXRQTW1hRzY4eFdtdHJVcjFiU2NxRE52eVpKZm1ibHBKdnRycW1sb3dU?=
 =?utf-8?B?TjdCM2tBYmdoTEhBZi9jbm5KOEN5Nk94Vm1BMXdNZkVUaitVeWFhbVpxNG5P?=
 =?utf-8?B?aEl6ak4rcGJFdklCd214Mk45MG1pbUZ1V1FJR3N4OWZmVDB3WE9aMlovblFt?=
 =?utf-8?B?d2tvY1YxNUhhbm1XZHNmdTlva0pkWmtJTjlqdVNEK2VxeHlIN3RJVEM0ME11?=
 =?utf-8?B?aHlBNTJjbFpwWlZvaTBoWnJMRmxFaWZibVBWbi9xL0lwWHRlUXlJei94TzNn?=
 =?utf-8?B?Z054QTZtUVQrR1k5b281QXJRdUdpYmp4dlZja1Nxa2xnOGgyZmdpL0c2N1VM?=
 =?utf-8?B?enFBMUdxZS96Wk9YTXlsNUxFS2JnK1pBYTJiVjk1dDlVRHlmdjYxVnMrSWRF?=
 =?utf-8?B?a3owc2hpbWZOdERzMVhYWEt1cUk2aUphRXRiKzJrcHpsdU1BNjRRU3RQSFd4?=
 =?utf-8?B?RlhtdG9sVWdrSEJ1MWV3elQra0FrSGcwRnFiTlErbWpIaHZJdm96TERZVmtU?=
 =?utf-8?B?bi9sdWZxeXUzRytxcGtwSFpZRDZ6eE9RMlRDRjl4WTZnNHR3aUJDNlh3ek1I?=
 =?utf-8?B?TW85RVB5d0NwY21nem1RODg5SUE0YTduQ00wd2w5QWJ0aERmQjRyaW82cThs?=
 =?utf-8?B?NzVyVTN3Z25xeTZrcHpQVnZmUXJ4RGtuWTZPVURKSVhaZnU2M2d1bFlNRjFi?=
 =?utf-8?B?Mm10b1FIdllVMXNGOTNUZ0VObHBOa3VCMkhZK0ZPdzcwTEp1MWFGZ0ZwZlBn?=
 =?utf-8?B?WlM2UDFZTnliTlhCT0NvTFFSRzNwSHNrRWFKSS84bERSOCtLZVRHYmV2aVRn?=
 =?utf-8?B?NWpPeDhVQ3J3Y1djUXQxY1RIclJjNitPQW9sZ0FYTmQ5bFVXUmh2TkhnTHkz?=
 =?utf-8?B?c082QVkzZnlDdjJJekdHWUhOWjhOdTNubm1IcC92aHBURlNsZFdtOXpTRDFJ?=
 =?utf-8?Q?TLWw5swQs9rqz8CXgWs5Aq03vfS/4gBZ8Uu00xlLdegR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52465093-0923-4319-d1a1-08ddc451e61a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:16:58.9507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpIzGD0P47J3XDsWAMGl/a+qRx7WsrHj1fvcOQPF7HzdWf/XEWTFqnpPPqjWcQ6oEPwz+AdtWJ0hJnLkZmV8XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6773

Hi Greg,

On 16/07/2025 11:11, Jon Hunter wrote:
> On Tue, 15 Jul 2025 15:12:02 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.296 release.
>> There are 148 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v5.4:
>      10 builds:	10 pass, 0 fail
>      24 boots:	24 pass, 0 fail
>      54 tests:	53 pass, 1 fail
> 
> Linux version:	5.4.296-rc1-g53e64469ea49
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py


I am seeing the following warning ...

boot: logs: [       7.316610] WARNING KERN ------------[ cut here ]------------
boot: logs: [       7.321166] WARNING KERN WARNING: CPU: 6 PID: 80 at kernel/rcu/tree.c:2572 __call_rcu+0xf8/0x1c0
boot: logs: [       7.328690] WARNING KERN Modules linked in:
boot: logs: [       7.331710] WARNING KERN CPU: 6 PID: 80 Comm: kworker/6:1 Not tainted 5.4.296-rc1-g53e64469ea49 #1
boot: logs: [       7.339422] WARNING KERN Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
boot: logs: [       7.345850] WARNING KERN Workqueue: events_freezable mmc_rescan
boot: logs: [       7.350605] WARNING KERN pstate: 60c00009 (nZCv daif +PAN +UAO)
boot: logs: [       7.355329] WARNING KERN pc : __call_rcu+0xf8/0x1c0
boot: logs: [       7.359029] WARNING KERN lr : kfree_call_rcu+0x10/0x20
boot: logs: [       7.362980] WARNING KERN sp : ffff800011be37c0
boot: logs: [       7.366249] WARNING KERN x29: ffff800011be37c0 x28: ffff0003e9459800
boot: logs: [       7.371481] WARNING KERN x27: ffff800011771000 x26: ffff0003e9473800
boot: logs: [       7.376712] WARNING KERN x25: 0000000000000000 x24: 0000000000000001
boot: logs: [       7.381941] WARNING KERN x23: ffff0003e9474000 x22: ffff0003eb8a3680
boot: logs: [       7.387175] WARNING KERN x21: 0000000000000000 x20: ffff0003eb8a3680
boot: logs: [       7.392405] WARNING KERN x19: 0000000000000020 x18: ffffffffffffffff
boot: logs: [       7.397640] WARNING KERN x17: ffff8000116a44c8 x16: 0000acb4dd443472
boot: logs: [       7.402876] WARNING KERN x15: 0000000000000006 x14: 0720072007200720
boot: logs: [       7.408112] WARNING KERN x13: 0720072007200720 x12: 0720072007200720
boot: logs: [       7.413342] WARNING KERN x11: 0720072007200720 x10: 0720072007200720
boot: logs: [       7.418573] WARNING KERN x9 : 0000000000000000 x8 : ffff0003e9453600
boot: logs: [       7.423800] WARNING KERN x7 : 0000000000000000 x6 : 000000000000003f
boot: logs: [       7.429029] WARNING KERN x5 : 0000000000000040 x4 : ffff0003e9453400
boot: logs: [       7.434257] WARNING KERN x3 : ffff0003e9474048 x2 : 0000000000000001
boot: logs: [       7.439478] WARNING KERN x1 : 0000000000000000 x0 : 0000000000000000
boot: logs: [       7.444706] WARNING KERN Call trace:
boot: logs: [       7.447129] WARNING KERN  __call_rcu+0xf8/0x1c0
boot: logs: [       7.450473] WARNING KERN  kfree_call_rcu+0x10/0x20
boot: logs: [       7.454082] WARNING KERN  disk_expand_part_tbl+0xb4/0xf0
boot: logs: [       7.458199] WARNING KERN  rescan_partitions+0xd0/0x310
boot: logs: [       7.462167] WARNING KERN  bdev_disk_changed+0x6c/0x80
boot: logs: [       7.466035] WARNING KERN  __blkdev_get+0x39c/0x4e0
boot: logs: [       7.469668] WARNING KERN  blkdev_get+0x24/0x160
boot: logs: [       7.473022] WARNING KERN  __device_add_disk+0x2fc/0x440
boot: logs: [       7.477055] WARNING KERN  device_add_disk+0x10/0x20
boot: logs: [       7.480744] WARNING KERN  mmc_add_disk+0x28/0xf4
boot: logs: [       7.484188] WARNING KERN  mmc_blk_probe+0x210/0x620
boot: logs: [       7.487885] WARNING KERN  mmc_bus_probe+0x1c/0x30
boot: logs: [       7.491413] WARNING KERN  really_probe+0xdc/0x450
boot: logs: [       7.494939] WARNING KERN  driver_probe_device+0x54/0xf0
boot: logs: [       7.498971] WARNING KERN  __device_attach_driver+0xac/0x110
boot: logs: [       7.503349] WARNING KERN  bus_for_each_drv+0x74/0xd0
boot: logs: [       7.507130] WARNING KERN  __device_attach+0x98/0x190
boot: logs: [       7.510912] WARNING KERN  device_initial_probe+0x10/0x20
boot: logs: [       7.515025] WARNING KERN  bus_probe_device+0x90/0xa0
boot: logs: [       7.518797] WARNING KERN  device_add+0x2e8/0x600
boot: logs: [       7.522245] WARNING KERN  mmc_add_card+0x1dc/0x2c0
boot: logs: [       7.525855] WARNING KERN  mmc_attach_mmc+0xe8/0x170
boot: logs: [       7.529559] WARNING KERN  mmc_rescan+0x248/0x3a0
boot: logs: [       7.532990] WARNING KERN  process_one_work+0x1a0/0x360
boot: logs: [       7.536940] WARNING KERN  worker_thread+0x6c/0x470
boot: logs: [       7.540547] WARNING KERN  kthread+0x148/0x150
boot: logs: [       7.543733] WARNING KERN  ret_from_fork+0x10/0x18
boot: logs: [       7.547243] WARNING KERN ---[ end trace c908584b2d117b20 ]---


Bisect is pointing to the following commit ...

# first bad commit: [06949933ae1b2109cfef82bcdf70e3e09b4761bb] rcu: Return early if callback is not specified

Cheers
Jon

-- 
nvpublic

