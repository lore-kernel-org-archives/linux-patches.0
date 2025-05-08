Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F39E22D4D6
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697498; cv=fail; b=Si2B8N0ssS7qYgHe6yL6sgDIG3Ukqs5u0h9ZB+/UORRAHYQYkIur/g1Wc2/gX8d1HdkbeZ8fjGECCY1maCQfrygew3wNK0pxEX4j//nK6xmoxAuIMLIOeg+tpm8b5Mtduhp4sqWfqSMpXaQA8idjVvQMOXZOU6vRsGUZNzrclpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697498; c=relaxed/simple;
	bh=ojKw8ld323ymjQhLW595fORXvdBJpf0OEkTfw+sgXso=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F8iohjtgCWN3jvx7jUnLFcO/G4tYrIZDvlJHzvcps4vEhs0ldi+82DikWJlI/QbAWfxqSyz6o16iyMet8plFCvI9GxUwkaRHeEzlulf2I4IeamJ0K+mIhnQIeo+U+on3glB6GmoKPv6sn58T8tgaqG5o4IyO4qGKI9WsssqzKdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AaJnL8Zu; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AaJnL8Zu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OL7RLEzgMaHBrpsSpW43LAkg9KiFWN8P4BnrpoHIHotjcxkItO9VCeZrG4VPm2vBDdMDfCvgK/73PrUvdYbdPAtyKiLabPEho9mMacE9kIpZcvie5UsWCtNTtnL1WoHYWNiItZcKKTTaCCwN4TMc1HJXft5rU7R631FEn7M9sUUQLUK3hc/BhB//+HDJDeBNrNGQ8pw6lueXgCI/JNd0hVfQk7iNUPd8w64ZccIS9iKPGdgWrJTAdtkI7Be0VW4Iz1Mut1TGOgqXb8lN+e/a+uhuF7BLG4Zzi57djeAMxMzyTvvRGNnhRfJfkD0zFdhpArE1rnOp93jWAlYUIELTyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/3M+bVxtyEFFEOA76tJ8mW2ekgCtE1rZ1lihwJoUgw=;
 b=rljQxqxIQIazd7lbl+imZx061oqIxRAoxNdlI/1G3Q6Xk8ZymblOt7do9hrKdDPPAzhnoKk1BXmxDuviJYfh4FYdHFsmp+qGCK7dyZ2fUJ9t1EvhEp1Ynezrn74T+ATg6l0j2D3ov8w6xBg58+ivG6SorCmQXfdHaQhFzMxa7jO5mC/hg+uLBMErIRITsIbYWyANq6TuG7lVGcLaWjuFLlEGk6TgOTMLN/O6SJVgPLXUw6pI0yeFXlclWgMrEcsewXLbmZEuN9sz95RuzKFqFiXXJPQTiVPCROtvEcwCuuMO+Ym7Z2wGalxrIzOmrbop1FSUbttveAY4l/G7Woj/1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/3M+bVxtyEFFEOA76tJ8mW2ekgCtE1rZ1lihwJoUgw=;
 b=AaJnL8ZukmDrgic0BI+rEt9g18uBjkQR50aQ1B4prnJKZVnJy3VbKpydO7xwbS3NtYhYvOlUZf8EeSUjoIgPpTtLOh7tnchh0LIlKHTAJSt328kmhn2SF3bnvFzbJJQws8msQz1FpAPSFT3u/nsiwoG+qatXvaxZOdPYxUpq4cOy1rkwLoYeRyo7FJgF8aSDTcNtzbmCqE8vZLKM2EvviLj6LaIRthgRJFB99Uk0E+2W3GZ/tYhcU1++VM+wP9gv9ONFsAEpUpgZaa4e5UEGEuKDL67WjbZbWnci1oBBh7hQ9yxaOrmbTR3JjzZwhuurdEVIWHNYDkKT9lG97v7uOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH3PR12MB7667.namprd12.prod.outlook.com (2603:10b6:610:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 09:44:51 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 09:44:51 +0000
Message-ID: <843c2ffe-6653-4975-a818-03d4bb9e5be6@nvidia.com>
Date: Thu, 8 May 2025 10:44:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250507183759.048732653@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::19) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH3PR12MB7667:EE_
X-MS-Office365-Filtering-Correlation-Id: b9e40c79-8d29-4ac6-a7bb-08dd8e14fa7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0tCVHRzRmdUSnlXM1BLTWk5MG5oTi9MVFZxdnY1MWhTbEZWaW9lb1NPdWpE?=
 =?utf-8?B?dEszaU1yK1lneGZSQzc1Tzd5VzNCYUxjSW1IdTV3MUpsMUxKMHh5TFR2WHZI?=
 =?utf-8?B?RDMrbGtESVQxU2N0bkIwZnlyNG5heXVLZHFCSXBER2ltSTlSM2RHbjVaVW12?=
 =?utf-8?B?a0QzNE1MaUptSE1tTDVwemJyekJkbjlYRFhTV1VBVkZpcUpsN3d6RUtFZVlB?=
 =?utf-8?B?U0J0eEJVZDRoY0syUGVYNWQ5OFA0ams3OXdjdjcwRG1UdEdTQ3F2enpucUUy?=
 =?utf-8?B?NXhkTkJmTVJtT25uejdoQWFJRWc5cDlPck5ObjlLdTNYT2Rla25DT2lJVXVE?=
 =?utf-8?B?NS9sV3g0TUhaSGt6N3M4eWdod0RKcWFPVCtpQ3RjQVRNaHlucnFNQVNPREJk?=
 =?utf-8?B?MHZUd1VTSFppZDIxQ01aN3lldjBYOUI0cGxJU3lIOWpsWGtPY1NMWmJmRUcx?=
 =?utf-8?B?Z0pZYXlDNGxCTDBETjRwY0FEYkcxS2lWeFkvVTQ2WXJESkpuTURKWlBqck5V?=
 =?utf-8?B?VW9qazR2VjJIYXZOcU5kK0sxV1FkTjV5K0pDcVBaV1M4dXcvK1ZUTE45dFgw?=
 =?utf-8?B?TDZtbE9DcHRHeW1ObnlXeVZ0NDZJeFlFaVVvR0tLekJBbzBHVzFEQjROZVFh?=
 =?utf-8?B?R0RpL3NaVXNMb250d3dJOXZVSjkzNEZhRkNvUHVhMjVlL0E4eWVOeFhUYlE5?=
 =?utf-8?B?aEZTUHZVaVZmNmFQQVpHVHd1a2xUWTJkNnR3U2gyd0R0QkUzRUdkZXF1UTd2?=
 =?utf-8?B?amZyQWpIM0R5cVhvNzF3bmNVMnF3RXFyZmtKQk51bWRrQ01NSks5Wm05Ymw2?=
 =?utf-8?B?dE1nNlBLODg5cndadHJ3RzdXMVJIak5hTjJrYnpPM0MzdVNZa21tR1JZR1Mv?=
 =?utf-8?B?dGhmY2MrNTZCaUVMM1diYjBvTnpnNnU4Y2YvR0pRN1hQWi9KdlBubE1UMHdo?=
 =?utf-8?B?cTNMd0RJY2JKNmZMUE54bUd0ZzNDdXRTVEZwcHJjaHZWZStHVlpjNU41aklm?=
 =?utf-8?B?N2svMlMya25JblVYYm05U2JKTDJnc0hIaGdKK2NaZmtqMU92TDFKZlk4OWlo?=
 =?utf-8?B?TVZodWtGMU1xY2cxN3lMTEtQOVNCR21EeFFzTmtjOUNObUJxbWRuUE5YN3l5?=
 =?utf-8?B?MGhzNXAxTGRqU09JalQ4NkJzQ0dFUDJoOEdHTEE2M1FGc0dWUmFzRnZBWS9o?=
 =?utf-8?B?OU5LRmF6d1RsQVdCUERCYW9IMDVON2lMY2pPMU5rSUgzL3VvallVZDZHVmVF?=
 =?utf-8?B?SW1obU0wT3g4aEtBSFMwNGdXTmIyN3RMQXVTNDlmTytsd2RLZTdYTWsvUmY4?=
 =?utf-8?B?WjFRdE5OY2hickVCZEhLNERWQVF0c0RDMDViaTNHN0JrcmhNdW8vSGprZksx?=
 =?utf-8?B?YkJBSzV0Y2RVUU5tS1FNRVVFWGJtTUtOTElZMU9yT056ZWFIQ0lmZXNySkFm?=
 =?utf-8?B?d1ZqS0dldWtJSnV2cWxyUHhhVmc5YmhBM0R5cXJXc21lRk5XQitMcmlaMG9p?=
 =?utf-8?B?MWxIS1crMStaVk5nc2dmcTRzdTlvTGFqSTJlc2d6MzNEWVIvdm9TTGxiTmlv?=
 =?utf-8?B?VmVHZ0Q5VllDRlZOVVQ4SVBEMXJXM2VkeWM3MENFeXAxQitNMFBRUTd0di9M?=
 =?utf-8?B?b3BaZFlYc0xCWkhnRTZNdHcxa29uWXJnek5CT2xNV284Ri9BZjBXVnQ3NmY2?=
 =?utf-8?B?VTVTU1lvdXFiZUg2YWplcnB3dGhZSFB0cUVuOWRER2tvWEhqZzhTMDY2cXNO?=
 =?utf-8?B?cVZqOVNnTm56L1JoNmMxRWxNL2dkc0tPZkdmeTVHcDkrc3Y2SU55NHNDSk44?=
 =?utf-8?B?ZnBkeHNlVUJwMGtTNkRTTGVYakNpcmtqWWYwRlNOMXFrRnRuaWpVY2ovejk0?=
 =?utf-8?B?ZkRLSWxiQ2Z3eXNKOUR2N2dMWWduS2VGLzhteFAwZU00OGY1TWtCMVlzQWRk?=
 =?utf-8?Q?dmnWqS/64SY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WndBZmM0a0FwTXgweUFVVVJtYnNpdVVKb2FhRk5CbnEwdnV0SStWbFRCSFZy?=
 =?utf-8?B?b0lnTDg1d20vUnBPQTJNbnEyNms1bzNrQ29LdGgwNkpJRll6K3J5WEJQbW92?=
 =?utf-8?B?Y0JNeGR1Q0J4a3lMYVVJaXNOSUV5MzJ2ZGxkZW1CbDNUMm1oK0p4RkZJS1Ex?=
 =?utf-8?B?UHJrM1dTQzQwZ0pFZmF4N2lQOWZCRnlDcFYwVEtTTi9tazlQYmtneFNOMXJy?=
 =?utf-8?B?ZHlnbmlrYUo5Uyt5djNGT3BESmlRb1l2NkZFZnJWc0ZoaFNUcDNabW96Tm9l?=
 =?utf-8?B?eUUyR2M4N01aSVBBeC94M1NMbnpKaDIvZjNPZWI2RVdOeUdVNnNzMnpndFlp?=
 =?utf-8?B?ZSsxUVFySEZHbkNnc1Nyc0VhWDU1Z2VxY3JHQTlXNHFsSDhIbDBlSHlxcFF3?=
 =?utf-8?B?Y3Y1UHhXbHZBYzlRWVVaRFNaYlRid0xLN2ZSWTFoM2FFWit1dmtibURpQ0R5?=
 =?utf-8?B?c0RMMjVEM0lsKytUTFdGdk9GdEUvRFJDaFhoWmFaWGZVNzZtcVBZSys5MFY3?=
 =?utf-8?B?aVdUeEVvQUNyL01rNkJvOXFwT1JmU1dRaTNCVndBQ3p2WXc0OEh5Z3llb1hl?=
 =?utf-8?B?MHAya1Y0Y2FTemZBR1d0RWNWWUVaNWxjSWJRK0J2dlhqVFNzT2tNZmFTbndF?=
 =?utf-8?B?SEV4eWlwcldKQkk3a3lzY3BnTlR4L2RlWkI2NkFVQVRBZ3dSblprcVpkYUht?=
 =?utf-8?B?TUE0VjFLMjBIaUY2WVgzSkVxeDBNczAvWllCRzFwQzc1QmpTQ2dNOUFwZDA5?=
 =?utf-8?B?bGRuVjVjVmQ2SGcvRFQ5dFNNdmVYOHhPZTFmT3hVTDk4U0YxY2J3SmRrZkRk?=
 =?utf-8?B?ZGVBSUxXdGd5YmUvdU5FTDRyOVJReTA0aGthN2JPWGZRRmMxSjd3VGdlQkpC?=
 =?utf-8?B?QmJYYmpQQXFMZk03N1U5WVRoZWlmcXdVcVhxZS9XWGg0RzNJYkFpVnQraVJJ?=
 =?utf-8?B?OTNLV3lZR3VQTmpDZ1ljQ2RScmZTeFE4a0xwTndmOXhGdWkzdHl2aEMyRW5S?=
 =?utf-8?B?WkN5cG4wbHFpZzBNSFV1TWNGT2VPVVREelJxT2ZLR1ZFMFNVYUthZFdPN2Mv?=
 =?utf-8?B?Q1g1Q1ZaZ3R2MjY4M0N4NlRBME5vSk40em1tc3FlTWdXQ0Nod2cxNEc5UHVX?=
 =?utf-8?B?NDZaOTcvaHUyNktzZW5mYmo1Wks0RVE2L0RTK096T1JoRXloTnJEN3BqdTE5?=
 =?utf-8?B?enAwdVFJMTVvdCsyOTZYTzR1bXMzUHZyRGl0cW54cUZqN1FaalF5NTJvRUkr?=
 =?utf-8?B?Qkt5b2wxcnNCVlk1ZHlWUVd6dExtZ0JLVkFPeno1ZEVET3JMc0dtOWNZb2lv?=
 =?utf-8?B?NWdNMG1raWJ6dGhia1VhSThFK00yYkwwUjltZDJyOFU2VEVuemFrbUtITlQ5?=
 =?utf-8?B?aE95MVVWODBMc1NWWEFHaEhpSDczbDZoc2ZGSVh5MGlKRXJ2Nmg2Wm91RFJP?=
 =?utf-8?B?N3IvODBHRVRjV1pGNmtOenNJK2RBMnA5dDI3K2d5MEFsVVcxRzlFTkI0R05w?=
 =?utf-8?B?V3lpUmFhbDZONkh1ZVNvOStleGl0OUZuelR2ZWtkVGlKTGljTnVqYlkwRlQw?=
 =?utf-8?B?Qnh2QWlPL1RuczNMQ3AzZUQ5VTFybzhQeEhEblRXUm9GSW5iUWtKUjVOVWZ6?=
 =?utf-8?B?aHc0dVhXdTRlbDV0Y2taa0tYaExYL05DVjlMcjZWMlgwN1ZodjJ5ejcvQndh?=
 =?utf-8?B?RW9ES2o1RzJURGlESm1NQ1RGOHR3c1pxcFpqYnJmd0FLdVNveS9oZjM5TE1T?=
 =?utf-8?B?KzNuK2lyTmJSOUxFcDJZT0RDbWcrZlBEVjJBc2dSdzQ1Yk9OcSs4c21HdmFC?=
 =?utf-8?B?RjFwZU84WlFrVk5KOUJha3dibDZRZloxVTNhT25DWmNXS2Fab1NId2NVN3dR?=
 =?utf-8?B?cExuTWNmVHNkRGpMcVVSTUtySjQ5ZnBVeElYbFBOTkFSRE5HUVNzcmNaQ24r?=
 =?utf-8?B?WGZqeU9zUU1qRkZVOVNhOVJyS3ZVNXpQeFpDWjdRMzdIR1BYL2w2MTVSRytF?=
 =?utf-8?B?MUNERVlZQ1NMM3l2Uk9Qc3ZtK2lITjAwclM0Vi82TTNWcUtsOHBiTzBRUDNL?=
 =?utf-8?B?SUYwOXgrckM4YUFLZ2tKbk8yQzRJc04vTzNoM3ZCYVZ2UWZiYVNRVG1WUy90?=
 =?utf-8?B?L21vVEkxMDEyTkdqamdkcFg0bCt6THNvZUlwbkxQMWpmalhpWjk2VTNlZ3pB?=
 =?utf-8?B?eHc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e40c79-8d29-4ac6-a7bb-08dd8e14fa7f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 09:44:51.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/s+pLP3+S86W2CjQL7J2E5hZz05lvtVDNvh2o7HXYJGOeV3WR8UOnFVcAq6czZvgTJrW4YqB0yeMyDAtr0X5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7667

Hi Greg,

On 07/05/2025 19:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...
  
> Stephan Gerhold <stephan.gerhold@linaro.org>
>      serial: msm: Configure correct working mode before starting earlycon

The above commit is breaking the build for ARM64 and I am seeing
the following build error ...

drivers/tty/serial/msm_serial.c: In function ‘msm_serial_early_console_setup_dm’:
drivers/tty/serial/msm_serial.c:1737:34: error: ‘MSM_UART_CR_CMD_RESET_RX’ undeclared (first use in this function); did you mean ‘UART_CR_CMD_RESET_RX’?
  1737 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
       |                                  ^~~~~~~~~~~~~~~~~~~~~~~~
       |                                  UART_CR_CMD_RESET_RX
drivers/tty/serial/msm_serial.c:1737:34: note: each undeclared identifier is reported only once for each function it appears in
drivers/tty/serial/msm_serial.c:1737:60: error: ‘MSM_UART_CR’ undeclared (first use in this function); did you mean ‘UART_CR’?
  1737 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
       |                                                            ^~~~~~~~~~~
       |                                                            UART_CR
drivers/tty/serial/msm_serial.c:1738:34: error: ‘MSM_UART_CR_CMD_RESET_TX’ undeclared (first use in this function); did you mean ‘UART_CR_CMD_RESET_TX’?
  1738 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_TX, MSM_UART_CR);
       |                                  ^~~~~~~~~~~~~~~~~~~~~~~~
       |                                  UART_CR_CMD_RESET_TX
   CC      drivers/ata/libata-transport.o
drivers/tty/serial/msm_serial.c:1739:34: error: ‘MSM_UART_CR_TX_ENABLE’ undeclared (first use in this function); did you mean ‘UART_CR_TX_ENABLE’?
  1739 |         msm_write(&device->port, MSM_UART_CR_TX_ENABLE, MSM_UART_CR);
       |                                  ^~~~~~~~~~~~~~~~~~~~~
       |                                  UART_CR_TX_ENABLE


After reverting this, the build is passing again.

Thanks!
Jon

-- 
nvpublic

