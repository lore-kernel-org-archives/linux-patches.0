Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D18170A0B
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 05:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728971459; cv=fail; b=MHB8fs99SI8qRGPVJ6c43sFncYsbFvCGLb3EiLhxMPkBkshQBrZoRPm1v7E4hUacAR3VwcjvuSlRiWDWJByLX9VzPNCorGvXF8aJ9R+6JkDEEHlLTtuldgEEYcXYTt7VxoHd0+Y6L6cmmIqeJiQkJYn+JqccUgbshbKPQJCdIpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728971459; c=relaxed/simple;
	bh=IRz1w+X+6zN5UgwZI8dzelSPB4hDZUGxRkFXm1om0ro=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JdgiuNiADhJVFPNjRFZZXICU5VdX+73hhLkjZC3y6pOkD8ndzEdca1MNRqJzgR9jVkFJL+DlD7OIpo1chrEGKKLIw9FjPvdkAJ4w5GQnnJ2mQ4sc6zWZPUhGtpT0k4fdNa28Wyq4wz6PvdrsCQfc6LXE+NH2zEs7VJLIXn1ubuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pdvdr5jk; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pdvdr5jk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lvh/o4Qmr4z18ZdGy8vVTz55f2jEZRKpRE2TxN1T2i37p/EHuznWFBeUGiNh1iXlRHI9GYf0fJiuPHiGIoqDVBbKfITYDoMaRnVedZTQfiZETQYqjkuwfZMIazlt+2sWOXye1vPyUnSRkF10BgajYhcrJEM2HExrj5AgIESS4H3VSnoAel47UXUo8qo30nq9u1lUEOSedjZI0XwHWdD+r3mPxZwgEiCvdJ9+Ooy+w/Sdps/f6tXuvv6VQxgjHntuM0Nsa7LV2oKxHKqok26yK/mMjnYfIUgZI1VgypckzWTRjUljvCuxxRq/KgAcwVBE5hhm1xCloD8/I0U35PKT+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMEPJycnbkuDQwvjADAYKmeVLUY7WhJeYy9t50VBpoE=;
 b=B2wkAEoCRzkHPEtBLe9VmDkXttUbEgMp7gSGN8Y9MbcUsoNhJiTGflSxu3KCvouOyJtMeuC9p4vm2rmFz0qbRgZ34CP6QxK2dUfnBmKB1JlTQTuJFpqSCSFIQfSD2tawHVAx7RvT66VpCVvop6nT9taOk9swugasEZVl38WHKQI4pzbRpiK/rdILSp0fvAipOnQR+609Ippp0vciuhP2yDYEjK66M0qi7nrJiKBB1tnLd9ymtGdmEGADwvKJWNsvvYhdcTh8RzHuEDbUi/JHobWsXAUDWPlWFhxGSWq/xRqKIDQsFDei+wNUcNDLf7QCocUhjUjKHT1HyKDX4IjyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMEPJycnbkuDQwvjADAYKmeVLUY7WhJeYy9t50VBpoE=;
 b=pdvdr5jkX4La2DMc6+TjPv5sSiz1x3iAST+lke7EJUY1HhMCitJXUg92Cn6VBEMPwWLg+pQK7sujGeih9DvQOYNWKxa9pWuSUiO7csN7ICLXH7be6aoAvtq0rF2Zhvuzr0YZSyvDkiy1waO3Vf1LN7aN8F1r58mky0fFgZHs/5U1kf2NbpsidxkZqGIDmmunYchxNaCe5Yo4Ln6RktiWCBsUv9v1ywitsZj8+Y07whdBLpNIj/cqXdBpN8IqY2UzxZ/BffrQEpAWlX6Jd0PEojPsI/F/yL6Crms1XyZeVK6rOykShvLFUvV7mSt/g4WuLsfkM4aA1aY7JYy0tdcSZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by IA1PR12MB9466.namprd12.prod.outlook.com (2603:10b6:208:595::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 05:50:53 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 05:50:53 +0000
Message-ID: <6a357a0c-2cbf-4205-955b-5f2866ba7829@nvidia.com>
Date: Tue, 15 Oct 2024 06:50:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20241014141217.941104064@linuxfoundation.org>
 <3ab1938a-6f6a-4664-9991-d196e684974d@nvidia.com>
Content-Language: en-US
In-Reply-To: <3ab1938a-6f6a-4664-9991-d196e684974d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0285.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::19) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|IA1PR12MB9466:EE_
X-MS-Office365-Filtering-Correlation-Id: 27547cda-caab-4ca0-1820-08dcecdd5497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnpwemRYQXFkemc5RjR0TWxGS0p4TjV1cFhuazlCYW94UEUwRU1UOG1IVTZO?=
 =?utf-8?B?QlpLUGZwWkJZOHMvYXZXWllVREkzbUJZMnAzK3NsYm1LY0J4ZUlFYythVjB1?=
 =?utf-8?B?MXlNZmZmdEFLQStXSWk2cmNpUzVrNUtZSzk3b2VESFdDemU3S05kMENhM1Av?=
 =?utf-8?B?VlpyME5tU0hQVzFhb0FFMkxKNnFXN3ZHNVh1OE10NnBsc3hxUVh5cDZWdi9l?=
 =?utf-8?B?M201NWIzbHQ4QjI1M0wzTUxwdXFraXdXR1hON3lKNlF6RXkzYVlnaVY2T1pi?=
 =?utf-8?B?TExocFpWa1QvSVdGbnZlRCtrVXlvV3d0YnA0Z2xrVkp6QjNYK1FsY1ZMVUNp?=
 =?utf-8?B?ajF3b0hSRmpYVitURE5tMHVtRmY3Z0RvamhIQ3JFRWJxOXRsdERWekJwbHNC?=
 =?utf-8?B?WnAyWC9GQjlrVlFNRFROR2tCcVlHc00rMWpQeWhLMDZNeXl6c3hhS0t6WW1t?=
 =?utf-8?B?WllPQmFQWjZJbVU2MXNFNTRNNzN1Q0ZSTUdnL2d6eXJjV21LOTN6bmFoTkl4?=
 =?utf-8?B?T2Y5Q2s4c3l2TXRaUGZiZ0EreUtyWk5PTzhNcDZzT1U4a0Jwem1SVVhkNXo5?=
 =?utf-8?B?bGxrYkJpSDN5azdqMjIvWGFyZXBTOTZrZFdwTkhZWkxsWVhVT0RXeDZVYU40?=
 =?utf-8?B?SURCMElGMjhuVk9VU1ZoNkVjdyt1K0tNb3BVaTY0OElGUUJDU1JrYS9uY2dt?=
 =?utf-8?B?d0dGVkpUczF5WHZubk4yQUJwTXZ1SHFCUzVGZWl2WVF0VzdTbGExazIyLzIx?=
 =?utf-8?B?bC9xSmpaWmxQQWk0TldLbnZZSGNJT0FqOWdUL2czaWtIQzU3TXVTSDhqbTVE?=
 =?utf-8?B?cjZ2Smtqb0ZVY0RJd2NIcFc2bTRYUVVaQ08zUER2OWo4YUkxSmk3c0I3V2Rl?=
 =?utf-8?B?SUZWazhhM0ZyYUM3bzlINkJaOFVDeEZkWE0xd3hQaWQ0V3M3Sk9nUXg1V0xM?=
 =?utf-8?B?a1hnSFVGOVJ3RXpUcTlCU3FkRnFwSEI5RWVlcXJWRUIvYmcvN1E2dzVPWHpT?=
 =?utf-8?B?Y0N3aE1KcmhBR3ZibjlQTGJ5T0dqa3ZMM21IaVU1ZXl4UFJJcmN0a2FtZkdt?=
 =?utf-8?B?eGhxWHZpeGRMRGFTVCtjWXhKb2JyVTJoWVpkYUdqcEJrNENkVStqVFcwNElO?=
 =?utf-8?B?WkZSeFJjbGNOM3N1a2w5Z05rQmZzdVJ6TlQ2MG9yckRRZkpJbEdHVVVvR1do?=
 =?utf-8?B?NHBWTS9rclVCV3JuTkkzY3c2Ty9OU09uQzZEUStJSDJ0VTZGZDAvSENWSFRk?=
 =?utf-8?B?eitPaTJJSFM3MjF1dklaY2xvMCtYTTc4eHpmaTdoZ3VtTFc3Y2NLSHNXMFRC?=
 =?utf-8?B?UzVpci9IbWVmZU8zOXl1a016UnBYdUtBWUxJQ0gyWlJxUXZZQ0Z3VkVDNzNr?=
 =?utf-8?B?TzNVUVgxdUNBVG5PdG9CM1dPVjVuNG1xZHFaL0ZNaHhMZkJuRS9kS3JweDJn?=
 =?utf-8?B?WkNYekRRUU94UXF4dzRhVTF4SHd3cTFwaEtPaTZpQ0NyaEpCcjAzL2Zhbkov?=
 =?utf-8?B?UTBtazhDSmtHdnNpY0ZtV0h0Qnk0ZUR4WEZrdTdQQklsK09CWThXZWxMZG82?=
 =?utf-8?B?SnB0M2NjS1AwTEdRaFp0RitteVdXTWMxN09oOFFobS96a2FscVRjVy9zVmw3?=
 =?utf-8?B?a0pocDV4ZmlvbXlkN0ZtaEovVnREdE9tdUlKS2dKTU5kTTNPMFRTU0ZtTHgr?=
 =?utf-8?B?ZmUxMnA5clg5TlNqTExteDFXU3NvTWhCTExxUVNHbzlLTTIxS1NtcWJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STZGSWNIRlVLa1k1MHprSmZaZmxDdnRzcTE2VzBLRnhyaTEwTE5rZURPY1Vm?=
 =?utf-8?B?S2lrZFNmSlI4eTBRamlYVmw3MlFaOHZ0YVJJWGNkeDJDR1N5OEhFQ0VGYVlL?=
 =?utf-8?B?eGYydVBDQVBzUmVxYkRrd29vZ2ZCOUJnaVNoYlpFaEI5b3A2cHc3V1RUMFVN?=
 =?utf-8?B?aGxvSkh1ZGxxOG1rYS9oUmkzTkZMdlNqNE9OYWw2K0IyejI0RjRPUGJuZFBP?=
 =?utf-8?B?cjBxaXdpczRrd0g0RlY4WExUWjFrZ1RQRmdESklhUC9rZWU1UnhtS1V0QWl5?=
 =?utf-8?B?OW1hVE84d21DMEkyaDduTnB0eklxSXMzRUJFZWU1Y1M3YUkxdTNLSkFMYUw3?=
 =?utf-8?B?RE1WZ0NEN0V3WEdZU09DZXFRT1F0QU5zVkpMSDhUVTd0dHRwaHNuOFpGWTNG?=
 =?utf-8?B?dWlnenVDUnFqaGlMRXFzdVFuUUNxNHNsb0lCaE1WbTZJeEUva21ZSkhzUk1o?=
 =?utf-8?B?QmJRN1Bid01NaDE3ZnZhMWxLU2pxalUrUzhxT2hhLzhNME9OMHFkQXhKRms1?=
 =?utf-8?B?WlpNWDRNbWE5TjZjcmVhL0lSV2xaREJhdGg3U3BXQm85Z05Vd2NCOVdFNnJX?=
 =?utf-8?B?MnlMZndBdkNESk1VeWpHdGNOaURoNHkwQjB5UmE0YTY2VnRIK3dhQnhSWktl?=
 =?utf-8?B?bkw5cFdsRUNuTWhpNnFkbkt1SGhUWHJuYXpDYllXbkxEeTU3Vk11c0U3dTUz?=
 =?utf-8?B?TTRkUHhUQ204cDkzS1RBTWRFSjUyR05ocXJERzFuQ0ZYUlJZRXFmKzBEdm82?=
 =?utf-8?B?SEJRbGFwM1hqYVhpQ3dlL0ZsSUd5TjJ2TmdlYmVGM0pKNTFHMjhpMlZKa1d3?=
 =?utf-8?B?a0ZxcmNzQ2dKamJuQWJobmNVUWVWdmRiV0x1NklXcHpVRUxTaWd3c3EvUytn?=
 =?utf-8?B?Lys2L1dLUWdnMEtoY0hVNzV0aXJOZXJocmFqZjZYTEtNdXUweitBVzZveFJL?=
 =?utf-8?B?QnA1a0pYYXRwRzRaTXZVNXM0UDkzRHdZYkN0TzRwejJiMUhqRHlJM2VhckNX?=
 =?utf-8?B?b0ZvaWJmZTZhemkxSzVqN09aTWNwd2RkRDBObm1CODl4Rjd4OHB5cmZ3UFVC?=
 =?utf-8?B?WUYvRXcycW82dHdjZWJCTTMybmVLVjY1NWNSOUpUZUcxS0Z5ckQ5bGNJOVo3?=
 =?utf-8?B?VXUyU21iakdXVG8zMWRoV2VSMU9XcEZ6cmp6cHpXUUlHdUhTTUNEVzhCeWxW?=
 =?utf-8?B?VWVwMHZaQlY3WlBxNEErd25UUHorNS9pWXRWeHE5UW0ySDBuUUhwYjd0blA4?=
 =?utf-8?B?RkZDNHJmK29IS1AzbWszTUhobHl2OTVyMlZUUGZSTUFGM1hmaU1ROVdqOFpU?=
 =?utf-8?B?SE5paTQvU3FoaG5LZjNwL1lQUmZzeCtzb3IvMXhmRkRMN2grREVQY1JkS0pU?=
 =?utf-8?B?eE14QjZzdGppOWh6aU5nbU5LSUNHRVRpL211YThXN1R4YmVoejhWaUdFMnFN?=
 =?utf-8?B?SE5YWTk1RktLdk8zN2N3ZmtsM2VZRnB2WXk3WldhelRmc0NqTEFUWDZKVXdl?=
 =?utf-8?B?SWtyTUdGcklQNDdiYmRRb0hSMERqVkR3QXh3WHdmcHJRWEJPN3VFMnR0aG9o?=
 =?utf-8?B?SGNSNHoybzRTN0E3YmxMODUrVTRaTS9EMkdlUXFrUkh1T1dpVTJBMjdsTUpL?=
 =?utf-8?B?YmNJN1B5SXl5QXo1M3B5SFV6c3BsS2kydVBVekh2bjMyL1E2bGNRbkxJbFFY?=
 =?utf-8?B?L25vRlg5ZDUwSWZOTXhmT3BuRUYxYmwzREMwcjhvMUJKb0VnSi93ODF6MFFM?=
 =?utf-8?B?NzJjclc1bSt4djdRalNHek0zanZ6ZHBtL1NGc1JVNFNlVVV2Um9QS1pMM2JL?=
 =?utf-8?B?a1hlNFNLZUhzOC9sUitsSzhnTGhlUnpCdkQxaHcrMHhpZmJLTllGTFRSTDY5?=
 =?utf-8?B?c250a2RUVHhGVlk5eDdVd01mM2Z3YkkreU00cE1KQmUzV0tiS20zd2U4MXp2?=
 =?utf-8?B?OWxBNmpCVHdnUzBLVi93Z0ZpZlBNYUg0Sldpd0o3WXc3dHR4VUl0OEZ0RFJa?=
 =?utf-8?B?YlovY2F4VGJ0QkdpWnA5ejFjdllpeGtzMnRJSk9KU0pqcWh4cXZ0RTZ6YWRK?=
 =?utf-8?B?R1dDSXlSRUlPMDlxODdscWFZZ1ZwZlNCMzZjQXYweFFYNm1Icjk5YUJ2TmpV?=
 =?utf-8?Q?wqDsOae/pVANuR9j1zqntefDZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27547cda-caab-4ca0-1820-08dcecdd5497
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 05:50:53.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FCrTjbioXkBhIKsNVP9xdneLJqVFseuR38dVX1Wi59aqOtzHYwZLw2BojbcH3EabjpBUp7edRcs+Fq59X0KGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9466


On 15/10/2024 06:31, Jon Hunter wrote:
> Hi Greg,
> 
> On 14/10/2024 15:09, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.113 release.
>> There are 798 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
> 
> ...
> 
>> Oleksij Rempel <linux@rempel-privat.de>
>>      clk: imx6ul: add ethernet refclock mux support
> 
> 
> I am seeing the following build issue for ARM multi_v7_defconfig and
> bisect is point to the commit ...

To be clear, I meant the 'above' commit.

Jon

-- 
nvpublic
