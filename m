Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20B520B22
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739971956; cv=fail; b=SfvxDBcjX+KGCiUys+RUBWx3iQ4JiFgh7FpfQfVtL1/ZvWBNb27BhBnIzNIr+83OVhyWf/4MdW5dJueUfPQYF8niT/pIl3tDiovIPlRIq/VAaoyiejqvglI4NiFBGY+BUJH690v4M26NyyJ8ainQv6d8JlUS6dkCxly8HDQgsF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739971956; c=relaxed/simple;
	bh=BJhP5VdJN1DJ5E45Bpqlflox+btStma56Y/etQPKrkM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cCogDNWRJhCigOnJL7qUl0WuguZ7k4reatlx6JbEOSTAE1M4PPezuzrPsHyPkIEHOBX5FYIZ+psL09FVbqo6bWm3RxIw2pxNX9IVn6jrUxvBrEuHbcZh4WaYaI/VJ8Db63pF1mRbn9hcP8kBnZtCnH4ORtr0/SijtN5aaXczEZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O8oAh3Nd; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O8oAh3Nd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rntBYyNfLEW0KlBemWl+V4pyBbmQciWDmfeu3++HBZM9zWKoXc4D0GRCJhubuuuETyPw4IjNhN1MFNR2ZT0s954YXuHJ2iE4rwz5rDz077NpjHXAK3TdJhj/imvAQUkMujesdA8bW/t3osmKg411RSCKlBm31JWHOmEmOvUlOWXyouDDeD5gtZUBPtMN0gOnqvMmrCw4curH3eOBLRZJSgKYYf+MD12MVeHlvHalc5UnYNezDxhse5i3YU0NzS7T6T0DK3cIxtyeAzp4loh2g9HXYiK0WOA82b5afv7Iv0l/X4VebUNPCI7CSeh2aOY8GQrvcWzg8vE1kPgN/7fh4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkpTIEcc3mEyV8XPRn41EYPLzw9+Ki/Zu71MExxJkTs=;
 b=ZMGcNwXS0MojAjpWaBiESwjgvHCduCzFUDEbTKf4sK81AFuXyGtKcwlXGcJoowQTjlpohdRBvnus14hTG16c6YH4ubPrmG+a+xYhI/S+j18XRM0uyj5sLheKNBJ1OrldBgKKBze9UE5/y55kY6q0YZY/o/Gc53OAhtaYMaqgbCJJH+a/wwGAvRPiWP1xXW2j6ph6/Qrs3wafjTeYvz83g/petYFGCQEhFhhPtaxBI4iIQUBB0P+AaCCvqkGckBszW3PabfvLddBnATGrVJNKYm0Hi6FVgFyNYewgY7yjm0NkwbRabkPtlfC6nH7+SxfitI0sP2kRnfeIJ4qofGeZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkpTIEcc3mEyV8XPRn41EYPLzw9+Ki/Zu71MExxJkTs=;
 b=O8oAh3NdQWkyw8Gi1ASRXviJsBDVOlxLPbtsd/GoklqVTjEV8l/4KYWay2p4Fo6mvzxapSkxTPhd7hkMu4n6/mgMhOgvw/Z3r7c9GWthRwhzPV9CuWkAlPuJM+MAk6Nvw9b2nzHgbZkfdo+Kgj7zzK96L4APexhPAqyLytAv9CGmkX2O/DlgxYI7KvEplyzv1NR1PqRGI3tsfNXDHYPrvF8CWd5YTlPBETJ/2egPGtdcy2J6H3sZ9ey1le0TL+VLZnApFAaQfxpOLX60uMWkur1PYG+Zv7oLhXeHqAbejTv5lUdGyU08a7SVwvWCJkA59fbWi/mGh1zdIQ611Eu8eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by MN2PR12MB4319.namprd12.prod.outlook.com (2603:10b6:208:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 13:32:31 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 13:32:31 +0000
Message-ID: <b686ddb5-aeff-47c2-ba94-b6be9dbafcc1@nvidia.com>
Date: Wed, 19 Feb 2025 13:32:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250219082601.683263930@linuxfoundation.org>
 <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
 <9836adde-8d67-48b5-944b-1b9f107434a8@nvidia.com>
 <2025021938-prowling-semisoft-0d2b@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2025021938-prowling-semisoft-0d2b@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0003.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::10) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|MN2PR12MB4319:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed9b2d4-7e04-4249-f80f-08dd50e9dc30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1c1WUxIQngybmxjYSt2L1NWTitjK0QrL2FJVHIwNXhIRkgrTUdCdUJxNkVz?=
 =?utf-8?B?MUFQUWlvcERzTitnN2wrbmUzcGpyNXMxVkhKK0s1a0xXSXVWTWxOQmJDdEw2?=
 =?utf-8?B?TTJRWloxWk1EN01WR1llZ3JpWWlvclYvUHlxOE90ckJXT3prYk9acjBEQ01v?=
 =?utf-8?B?TEhlUlE4aGJhNkYxRXErNzdKNDlFa1lpZkhJTWNTSm04WHlGRFNjY3NRanIw?=
 =?utf-8?B?TU9PNW1aSUtDcUZHSFhqV1JBZC91clVmWVNlSzd5OXNYeTlJNFd5SFk0b2sv?=
 =?utf-8?B?RnFwbUMyTGQ2d0dYWjVabmhFQ3BLNXp3UVJrY2VjSUJHdytERHQzbWNQMFBT?=
 =?utf-8?B?WUZ2aUMraW5CQy9VamxGUnJmWVUzZCtwbmNXRElEd3Evc20yRUhqYVQrb1RB?=
 =?utf-8?B?Y0lDQjQ4UlBQaWdnajMvZnJTK3dpUGNXVWdRbFJaSVUvN0tYWGRsUXdpSUxB?=
 =?utf-8?B?bUNLc1JSRjFxaWJnblFhTDA1QmFsVUR1dytSbzhhSURUTi9FWEh1QnRhTXJT?=
 =?utf-8?B?allFa0NJNy9WQ3YwSEw5VVRheDVWbnlYNGYrUk1oa3ZITWVSUy92ZUsweGJz?=
 =?utf-8?B?UXFwNDVHZVp0U0RoZmF6Z3V1UXRyTTNZYVF5RmcwQ2MyRm4ycG14SUVsS0xv?=
 =?utf-8?B?eWV1eTFrNVp6NUs1TlBuNVc4UE13UTRSdXF5OS9aZ0ZydHFnck84cG83NXNT?=
 =?utf-8?B?UmFDaWxPc3RnZFFtT1gwWHlkaGF6V2ptOHlwMFpLS0l6cGhzNFNsLzlsUnlP?=
 =?utf-8?B?L1gySktwMFlmTCtKN25neW44UmY4dkdFUVJESkxPd3dyTXgxcVZ4U21sTlB2?=
 =?utf-8?B?MVpqY2sxSEVQcjdxa1Q1bjFmMnVUalJlblZ0UlJFNWZRNnlOSFU3TWFuN0RR?=
 =?utf-8?B?Qkx6VU0yb3JYd3ZscDhERHBNVzd0OG9KWUJoQXU3Q0d4N1ViQmJ0WXY5Slc5?=
 =?utf-8?B?ZzcxSXdjVUVSUUFiOHhONXVVRnpXZThxc1ZmVEZLUEh1cEJ0aWcySFFPSmg5?=
 =?utf-8?B?eklYR1A1R3RrOEVWcUc1cFBJT2xwc3lHMHo0VnJNeExCWVhXR01oNkplczZK?=
 =?utf-8?B?Q2NxUUwzQmg3TFFSNjFFNVdWN3NIREdDbEpTc0NuSWI0UjBZVGZVR3M0anlZ?=
 =?utf-8?B?WG9rb0ZmTHpXcFc2R1E1L21qY3EwaExOcXVYbVZQVjZUN2R1UHVhWS9BWVF4?=
 =?utf-8?B?L1BhZDM4d1psTWJSTVZ6SDRxTGcrb2daQjVjb09zL1hpOGlsUWdaVTVNVkFV?=
 =?utf-8?B?bW10Zk5qdHJQSitQd3VLL0pDWkV3UTB6cnVYU0hrVmZhZmwvdmI4UWZqcHhK?=
 =?utf-8?B?K1pqSTVPaXR4b1pEanFGbnUvVlg4MndHU0MzL1k2bkRCUVV1Y3BXOHZTWWJr?=
 =?utf-8?B?OGhiUmdhZWloY1R5VDkyQlZDcGI2Qm5tZFFNd3JtMXkxc2p0ZUI2VytlUXJq?=
 =?utf-8?B?TW5PVWxMc1ZoOVhkNHltNEFJZHpjdU05WEZ2enlKNmRzbXVKTHZCNWJKdklB?=
 =?utf-8?B?WHRuZW9BUE9TTGxMcExnak1oUkJOYlM3MGxGRTlHVFZqa2NrdDF6ZEtiY040?=
 =?utf-8?B?UWJGSW5JYVZBZjRFakJGNVdlYU9yU3BxUFZJSEo3VjVraG9Mc0t5dFZjMG1P?=
 =?utf-8?B?RFRQZUplTk5kdGd2U29IQ0ZsSCt2QXNCZVpyanVhM0kzZjd2MUJ3WFM2bDI0?=
 =?utf-8?B?Y0tudXBrMzV4djEvOXAvSllSOGVHcHd4ckdtMHl1elBhVTFnUlB4c3k3bktO?=
 =?utf-8?B?ZHZUZi84Y0FSL2hqRE9ZaGNHNkc3MjZoc0syQlNCNnA1aGZiWlhLb3JpNW9n?=
 =?utf-8?B?TE9MQzZyYTFONlYxRmV2MXdVb3ZEbzBCZGtFQTAzQVI3bjgvZm5NcDlWcW11?=
 =?utf-8?Q?IaTpL+p41AgTZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHFnelVmZmNIczVacTBiUFE1NG51SDQwZkpPZGdWVzl3K0laVnZWWUtob2VC?=
 =?utf-8?B?OVRsREN6eTFpWVBoa1IyZEJKTzdjRlc4dTdTL0MzeWJPVkRaSlVBZkhzZEtm?=
 =?utf-8?B?SmVpVER6UHQ2ampUQzdpNmFycnhIZzlmUG5ROWRPMUZGSEhQS0tMZ3J0ckRG?=
 =?utf-8?B?UGsvd0d5RUpvWFcwR3YvMFZwMXZXNzkvYU9LNDZVVVlBa3JXMXNtYkQyYVkr?=
 =?utf-8?B?eHkwZFExZjBGa09LUVcyR1YvdjUxaUIwaXJrMFNiTGd2RHNLUFNqSktQdTRX?=
 =?utf-8?B?aUliT1BkcktlVk8wSlEyZnRVNS9DVU1Ua0ZhZitsd3J4OXo5RDE4N0EreFdm?=
 =?utf-8?B?THhQbGNheit6S1k3T0w2M0pGNXIyT0lRZUJXa01FN0JGR29BajU0MENuSjc4?=
 =?utf-8?B?TTdZcDJkSFlqK0h2b1FrSTZhbXYySlFzVmI0MlFOSy9mU3ROOWM1V2VZZnk3?=
 =?utf-8?B?dG5WUldtdlJWTllqNUJqZWtNSmg1WDNvRytlYmFJTGRkWm9PZTJaVGpoN09j?=
 =?utf-8?B?RnM4NW5sWlJFRUdXV1NIL2NQc1pRa241Q1l1QktqVEMzdnNUWGVzeU9BT2Jz?=
 =?utf-8?B?OUdkRlFML092L1c5TmVXZkNEOGFEa0NTNkUvbndPajNNRGQ0R0ErUGcrS3Nn?=
 =?utf-8?B?U3g3QlVLOHdhL2tRbWtWTVcrdFJSOHcxOWYvN2NjWVUyZllnY1dpamY1STBW?=
 =?utf-8?B?VmlsT0UwWFU5UjhlYk5VcUdzOXhlcjlQQlVoZkRlRi9RWjJBWjBUazFISG56?=
 =?utf-8?B?RnR6am5VU1NFRVZmb2Y4cCtCazJ5c3d6dTllNENZSWZGODZHUlZWeWdFVThW?=
 =?utf-8?B?M2VGcm1mejE1MWU3bmIrWnovb1pMTjV3MlIwamNlTEJXV1ZJL011ckpvV2kv?=
 =?utf-8?B?RDRuTGY1UllaOFRVeVNyVXoraisrVDlYUUdtbXlxUFZSSFlSTW4zVDBlMVFC?=
 =?utf-8?B?K1llKzVvTkhJYzhHSmZsY05pQW5lZ0cyRTJrTnRRVzVURjJpSXpSeGFRSkJh?=
 =?utf-8?B?ZUhyMVFOeCtRS1ZZMTBIbW4wRHRNK1JlTHhpeEFuNEt4SnFiMlpkUjk2UUtn?=
 =?utf-8?B?OTdZOW5lb2c5QU9KZzNLL3ZwYVBsSnR4TVhUT3RLL0Y1OVNhS0NwWkViTkVz?=
 =?utf-8?B?WFprblZJditodnZVL3BXRmhkeWF5WVRCazZuSjc2QmxEdXNVTU43b2VNczFE?=
 =?utf-8?B?OFBicy9xQVoyNlBMRHhlOHVDb3hsQ21YdWp5SStqR3NiVkxnSHpvNitHbHE3?=
 =?utf-8?B?V09sdVB5MCs5MjEwVVFlQUZLc1BMMFFwcDZjYnNFOVlFd1BLL3ovcWJCWXBQ?=
 =?utf-8?B?dm1QaU9UaGp5WWY3TzY1R0t5Ylg4bHNrTDk3QlFyS0JDbXVmV2pEQXVHc2NM?=
 =?utf-8?B?U1dJZHc2MzZTQUI1UEJIYWVBajJLYkh5Q0UxMmpGTmFWampPRmF2WGh2b09Q?=
 =?utf-8?B?b3IyZVRaNXNaUXMxYjRSOHpOZTR4NDNXeE5HaE0wNVRaL3JKanpUTG5WNy8x?=
 =?utf-8?B?UzY4WFFXUkVScVlNYXJ3a2FBcU1GQmRYeXhPbW1KaHFmUFlrSlh5THZyZWdP?=
 =?utf-8?B?SUhLRGQrbXphVWtzcmNqZ21vaFFTVzMzZDBZZjNjdFlNYWZ1cGhLRjJLa3l3?=
 =?utf-8?B?S1dkcmh0N2RzaXdrQVBMSVRJTDA2L0VnclJ2ak8xZUJIZDJwNks5a1QvVk9N?=
 =?utf-8?B?S0lWQnZTb1FhY0dxWUxxMUo5OWlodkhUUVUvNjZFMXN4c3o0aDVKNHo1STBZ?=
 =?utf-8?B?ZnRZbjNJVG9lTFAweXdUOFptL1FYWWd0UFVHTmh5TUgwWWhWQm1mdkhKSWZM?=
 =?utf-8?B?RUlWS1d2cEt2VGtrM21tdXNwUlBKaWxQZ2RtbWZFb3Nkd0pNRXQ5WkE5SE9u?=
 =?utf-8?B?L1VBdmVYaVFsd1JRbWxzM1YzeGFEeVNJN1l6a1JtaVdrNlJxMEZ0MlJFeGp3?=
 =?utf-8?B?Mkd1ZE5TZ284Rk9zOGdXMUJPWVFYMjhvZDVKcFFsdEk3Sis0MWxOU1VUL1Bx?=
 =?utf-8?B?WDFNWDl4WFNtMzNyWEVNdkZ5SUdrL25Kek9SUVBPNkpDNXh0QWthM0UvTWNN?=
 =?utf-8?B?MjdhNHNrUk1Ic2g0MWZLcXRoS0J2MmdTOS9GaG9YeUpoYW5tczJ6MFFXU3U0?=
 =?utf-8?Q?4Bai6bjrjdIx2UENL1zMDSWBH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed9b2d4-7e04-4249-f80f-08dd50e9dc30
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 13:32:31.0986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 52Bh00zv4aTQEPC0V6LHw1+O99ErJ9RrXsepXmXU+ASwm/x4nzxotUrNEYoaluloqK1W3OP4dAOVF7IMRHfJ0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4319


On 19/02/2025 13:20, Greg Kroah-Hartman wrote:
> On Wed, Feb 19, 2025 at 01:12:41PM +0000, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 19/02/2025 13:10, Jon Hunter wrote:
>>> On Wed, 19 Feb 2025 09:25:17 +0100, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.12.16 release.
>>>> There are 230 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc1.gz
>>>> or in the git tree and branch at:
>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Failures detected for Tegra ...
>>>
>>> Test results for stable-v6.12:
>>>       10 builds:	10 pass, 0 fail
>>>       26 boots:	26 pass, 0 fail
>>>       116 tests:	115 pass, 1 fail
>>>
>>> Linux version:	6.12.16-rc1-gcf505a9aecb7
>>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>>                   tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>>                   tegra20-ventana, tegra210-p2371-2180,
>>>                   tegra210-p3450-0000, tegra30-cardhu-a04
>>>
>>> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
>>
>>
>> The following appear to have crept in again ...
>>
>> Juri Lelli <juri.lelli@redhat.com>
>>      sched/deadline: Check bandwidth overflow earlier for hotplug
>>
>> Juri Lelli <juri.lelli@redhat.com>
>>      sched/deadline: Correctly account for allocated bandwidth during hotplug
> 
> Yes, but all of them are there this time.  Are you saying none should be
> there?  Does 6.14-rc work for you with these targets?


The 1st one definitely shouldn't. That one is still under debug for 
v6.14 [0]. I can try reverting only that one and seeing if it now passes 
with the 2nd.

Thanks
Jon

[0] 
https://lore.kernel.org/linux-tegra/ba51a43f-796d-4b79-808a-b8185905638a@nvidia.com/

-- 
nvpublic

