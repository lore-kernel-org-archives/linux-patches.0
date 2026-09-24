Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011037.outbound.protection.outlook.com [52.101.52.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7438743304D
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 07:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235225; cv=fail; b=q7vOdDIWKJalw32lbb/3hsRk7x0VnyhYP7gKWV0UMu86pHLeTBltXy1sPHaTxffx6J1xMakDrH0hYenrNzoamMZXdyIpYWNJIa1ebw32NpWQT6bgJt9A68O9YofZfr3SpVcrQxh9PhYShKFh0566x1BqQxzwNz02Yy17kD2fifo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235225; c=relaxed/simple;
	bh=XfClV/pDP3Synub+6RvFk1tZHj8cW5i4xWwX6Y6GK3s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jvE9VCfyRdkaI509UFVl5ienldhtBDiYNzjYbE3ac+WlIfWrxvROLxBXXrQ18DZlMSwc8U/TT9uEf7gNURmQNsClhdIGAx6cS7n6OPiOk66IvSPu+tZn8uryljFxFFdFMLcDoIhdcP/fE702eDxgLjg75jhev7Fp/h7SXYpuW1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r29lsFAE; arc=fail smtp.client-ip=52.101.52.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r29lsFAE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wD0DP7lu6yqmxuKLFS/hg5aA3fBhU1N01g5Ht6LeYHRshkhByNYGYb0qhWtImUFnBBFIAt1SGo/ACCJpO7aEJKmTDmiqqJ4n9xIBMtio6ur0XMkMMWx487u01+2eLyj2ePuj4OtVatatLn0j5EXUyNHf2HP3UwGg6hRCkXYTX44w9STSZAjWBWYZXKmZScqijAUt7QRO/Uz+qiMn99hygzDnxmUpJx/MpEBMRExYi2fUSXNhfvE3EZ85sXJFAOWPoO07Qs+YnArXVId1JVaKhGfRr5acmTI6ms1zCa7T/Z6VeveM/t3ZseODICnZ33DzMYQ+hoDobJGx8ztr4/39oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZJtJLDA0bfS6GDfaWlsZv/nL10yPG10qBEFTNb6pbw=;
 b=qauiQ+6FD78ZXQI0KV2gXW6AzyDoZ1oPUckT+hbFh3awWfDar/Zzz8R8xfo5iTGHWUo/KsIlHjdyaVrWx6i+ystN+n0T3qrs1MCNhz6pzqhLbHXUqi0xotEVn5hbs+AURXNQk7Dd4yc6IYSdOdJcpqKARGPmbJkOpYTiDpOq5mXJghcUqJfNHwGdPPO1QF5t/Ah1nctb3+XS3KTzU5tCfof1TJetwphRtSqV06ATyxHqHsmMMj1LEh119K1n7XUmZnprouHUv9rl2kY9EP2PFHzNwJeSlcJ0W03Q3XayFeTS3RKmvR7CRU2ap4BfDF12VNritR1PFE7e7i59eakJUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZJtJLDA0bfS6GDfaWlsZv/nL10yPG10qBEFTNb6pbw=;
 b=r29lsFAEq4N+d/TM1QQfoY0mVKcdU7mqJ/XhvzZU0CMmsG7c+LHAJa5PnEsvmlX6RWUYQrlHMTVjGUZciwMRc3DsSiUO76l6FQT7oND/Ppxne8ThFtzn2D2QFh0RHqfv8GtYmDNMmEohk3ho7B33n6Ex0Qm8in+1gjVADTBGAqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CY5PR12MB6623.namprd12.prod.outlook.com (2603:10b6:930:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Thu, 24 Sep
 2026 07:33:38 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 07:33:38 +0000
Message-ID: <294b94da-a6e2-4d1f-8b93-31e45f0b8562@amd.com>
Date: Thu, 24 Sep 2026 09:33:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 104/438] dma-buf: Make DMABUF_DEBUG default to y on
 DEBUG_KERNEL kernels
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, stable@vger.kernel.org,
 patches@lists.linux.dev, Jianfeng Liu <liujianfeng1994@gmail.com>,
 Rob Clark <robin.clark@oss.qualcomm.com>
References: <20260923140644.756254324@linuxfoundation.org>
 <20260923140647.476063815@linuxfoundation.org>
 <20260923204146.6699-1-kmehltretter@gmail.com>
 <20260924010940-6fdce3544586@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260924010940-6fdce3544586@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::13) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CY5PR12MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: 240345ed-b1a6-41b7-0034-08df1a0e25b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|6133799003|18002099003|22082099003|11063799006|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	fjV626ZRjOpkB6mi6NF6ZWr9BNJPPmJlyvi4kJq88xqDDpAAmncloQO0GW/Kv1iU9c7bLIErw8zxw4oJD7Y6KXhPLY7/uAWt4oOv3yq3RSPXzCBEu9eUPJIPJmmTmmG6Zu6yY/SxuqzhNk72u6gTb+mBbHaUQ2RxEvWyPO7uU8aM/WTvvZ4rOIQxoWhk2O3/fwLoNmTwnePyeii1MT8qC+6rKFjkY5GL9iObHsONFcYk3oSHPTPvNapYxoFlZ1pEiAFUxSeDcOaq0+BRGtf7qnkQgC3hFIT+a/NnXQbW6BpJcG/7TEo2qI/uVebYCYg1SCTYgMc5Mn9UbbrQ6S7JDXFPh4jd5A4nXt2qbtCMbVrJ4eCW0q50ErEI1WeJTfgv2E+fSFb240sTvj6AxEgazGbqWPYYx+qJLa/zBoNzWmRDraAqWkFqTTEGnQ6ri5m00FtOEL5R1Z7fNnqPv1OEbmQso7sCk8ST7ap5AYbjuor+5UzSr8hksVgpG/Jv4OhcLJY93c5c7Qyp4dpSuaklL8lI0S2lS/BFO7d+eijaAFvfYyHzbxQympSN6C6PP/zi3T/wDSzwTDLZQ8aY1RFRPRrB07lSqtqi9qZk3VNRfNfKspyjczn9UZx5TAXtHm8NYBUERRyrR1CAbv5A3JJl39R8qaR8ZxkGdPHXQ2Q+XfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(11063799006)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rk9xQUsxcjdtcU40WlR3VWp5Nmx3WkZWVW9DNHl2eTdQNEVOVTlkSlBYSkxn?=
 =?utf-8?B?ZS94b081ZVZUTEY4ayttY0RsbG14d09PamN0QVFYK0dmWkJtcUVOZzI5R2JT?=
 =?utf-8?B?bHlFcXB1cVowc255UzY3MzQ4RHozMnpQN1NrMTNCSFppOHprZ3JhUHdxTlkx?=
 =?utf-8?B?MXZKTjRwQmlZclY4WFROd1NuVXVMRWJhZ0hGYm84NzRQM1pZdzg4OWhKcTJ3?=
 =?utf-8?B?cGZRL3hPMll0bEc0ZkhLTDE2ZGxRc3ZNSHFhUkx6b3N3eHF1WHFkSlROZzBq?=
 =?utf-8?B?UU1nR2NVWTQvK3lOdVVpcS9RMSs5UjNPdmowM0thQ2FpWFVNY2NCTnptdkVk?=
 =?utf-8?B?RXFuYzg2NjhHYXhYVzg3SnBnaEN4YzRFbHA5UkJxZHJ1SXZ3aEpjTnNHZ2hY?=
 =?utf-8?B?NE5hdFZVYktQQTFacFlFYmVOZUpNMzFhYUtyc09vUUtZYTBEbVB5L3dxalVR?=
 =?utf-8?B?am1PZlc3ayt4TXJXU3pBOTVjSjF2RFE1dzlWeXJub09UaTBvRTZ0aUFWUTlC?=
 =?utf-8?B?UGMzbXR0cFhra3BRYnhnTWVDYThOZW9rNEhDaVZKWEVsN2ZBTjZLTUV0ZHl2?=
 =?utf-8?B?eUlveWNnTW1QWU9JMHo5T3BneDVJL0pGWWgxMWJCcUIyazVLQy9kb1ZmUUF0?=
 =?utf-8?B?aTVNK2JYMmRCM0ZjYTdZcDdhT2toU0N0QThuRmhsSmxkZEkrcDdBMVdDdEJ5?=
 =?utf-8?B?L3djNGtNQkZTYklVdXI1RE5pMCtCcTV1bjdDTUY5VFRKWEY0NzltSkRBRFo5?=
 =?utf-8?B?OGRyYkRzaDB0eitQTlZWNFRUMzEzRmlyLzlDTkZMTks1RWZrZ2RtNlE1OUhM?=
 =?utf-8?B?ajE0bFFDNlQ3WTRUL0lnNTBDclF5aGJBN1dUSUttL1ZEYmRTQWliZFA4N1V5?=
 =?utf-8?B?c2hnNWlML2xZVVA1ckV3SG5BTkxIQVhUWVJaanFmWjdhRmdzN3l2ZXFhZm14?=
 =?utf-8?B?UzhiTDgrMFYzQzJaYkdKbXIwT2ZsdmljV2NEV3BnWG5tdFFrUUozZ2l6V1Bn?=
 =?utf-8?B?R1loNmJGaXA0Rk5KZXJ0d0VISjR2aWVpQjFnUUsyek55MDZ1S2xDd0M4NWhC?=
 =?utf-8?B?cmdxcFJnUm9zRlFISGFza05sMG4yNHNGc0V3VDdwUms3dWZyS3RPa3hFVGhC?=
 =?utf-8?B?d0MrYXhvMTlPYml3WTJWeXhvWUQzS1JMNEdDTEVVWkY3ZXpsd2ZHZGRqeC9C?=
 =?utf-8?B?ajUvdmtNUWpzQkFFcGFIelljT3VJS1ZWYWErMk5WcFUrTVFhc2hudW1LMVN0?=
 =?utf-8?B?NTlxZmNZRUUzODhkVnRXZUsrRzBZc3l0ZHVkblZYN2wwbkpISkNUKzZzcllJ?=
 =?utf-8?B?QStnV1lyTlBCakpKTEdzTzdCcjVzVEhjSzJyaWFRT0RRc0dDSmc2WkUraGVC?=
 =?utf-8?B?bGxIYmluQmk3SmwxTHFjaFNwSDJocjh2a2g3akxZTmdYSEZOd3VtL1ROYjJp?=
 =?utf-8?B?bDVnVUpXcUtiZ2RVRnNiNXpLRWNCVlI5YmV5alZRZWhKUXp1Q1QwRTVvYWZq?=
 =?utf-8?B?SkdERVQwd0g0c0EvMEk1cGxjeWZOQUNqWmxXZFZkVTduSzg2LyszeGRleDNi?=
 =?utf-8?B?UjJJMUpnM2RCV2dzcFNMd2VvaDA4WjN6Uk9BbFQ2UTM3VzBEeHB4bElSUzNy?=
 =?utf-8?B?RytzZ0tlMXlmRjN1UEFuenA3Z3phKzQ1TTF1dnNLMFE4dmNYZFowSW03cVdR?=
 =?utf-8?B?TWlxaFN2UUp0S0FOelgvM2xiL3RGTFVYUWkzL0QrZFZkMGtkenF4QVliNXly?=
 =?utf-8?B?aUV6bmY3c0ZYN1I3ZjFrUU1HQmZpRTZQSFE3T2xtNkpWakdnc2dUa1RWczRK?=
 =?utf-8?B?c1kwYVZZK1RCVS9MTFZpRUVDS21EcU9paEZxcGJES1FOdS81aHZmRHRtTTBU?=
 =?utf-8?B?Zjlub0xEMWxrcHpRcG56RHlGUVFOWFd2NnU1MVJDMU5lWUZTOUxNQkFoVzFX?=
 =?utf-8?B?ZEk5Vk1ZV0NpbmZ3eXJpbDA4SitFSWwvTE9QWmpjQnowUUhZQjIrcHAxQWJU?=
 =?utf-8?B?MDlXYlkzTTZlOFFPUDY2NURsNHVRRFYwUlFmN1IvZTE1N1EwVXV4Z1BXWFZF?=
 =?utf-8?B?aVhac1ZXVCtYbzRxOVJ1TjR6UzJPYzJGS3VWWDg0Tm1jNWIxRHU3VWF5M2lG?=
 =?utf-8?B?VUJ6bHRhcDhzOFhCakZ0RTJvZENVZWk0QWQrczkvdGZmRlFMWURhL29xS2kx?=
 =?utf-8?B?ZTFlTUdHTmozd1MrS0hPSktlWVlkRURQNjdNWjVqdGkrczZKS3ZSK2hZRlJV?=
 =?utf-8?B?SUkzbHJFbjRUVWtwQVI5NWJVTC9VL2U2ZnJibnlQdklVTmlXZFRFS0w5WnZh?=
 =?utf-8?Q?o16In4vWSnDCBEFWqq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240345ed-b1a6-41b7-0034-08df1a0e25b0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 07:33:38.1650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtALfcFl7+rjM5ZJZOTLEIu9qA+aZoGChq0AjpANDgEen+yvTG5pMyuX3Rb7Ng1Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6623

On 9/24/26 03:15, Sasha Levin wrote:
> On Wed, Sep 23, 2026 at 10:41:46PM +0200, Karl Mehltretter wrote:
>> I object to including this patch in 7.2.8. I authored the upstream
>> patch, but did not tag it for stable. It corrects a Kconfig default
>> and thereby enables the DMA-BUF importer checks in configurations
>> that take the DEBUG_KERNEL default.
> 
> Dropped from the 7.2 queue, so it won't be in 7.2.8.
> 

Thanks for catching this Karl and I agree completely.

That config option is for phasing out a broken approach in some DRM drivers, but not meant to be added to any stable kernel.

Regards,
Christian.
