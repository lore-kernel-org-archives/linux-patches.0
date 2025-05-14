Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0CF1805A
	for <patches@lists.linux.dev>; Wed, 14 May 2025 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182164; cv=fail; b=iIFqJ/psSQLsuWeZmvzAgsrsiBoX2hGv0dctvg8P4MD6ZiZTUG0bsGflgxI/Whl7kQIsOZlb4i1FOsRidx4VNGh/nI0Q6qSCJe7ZttFdztrk+uUrd6urf1fLYpKhZEhn+ss8+x08YbbSPm6oFDokEQYeRhDOCipHh7JpjosqCoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182164; c=relaxed/simple;
	bh=nWjUKHabK+7hLqr70t1QhYkgQMFWGuOpbj6MMBnBSnA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EzDcVSvQcofHV36A5V5VkmIxPP8DQQvzDXFCsIk3uLHvB835fIYsE1lnejks5HMMLq8ZCxK00mmqF5+z+pUOQZcdr/HY4SZqR0M7t/1ZamX3X7N2iqPvzEGwI1eSFPZqg8a3G6r6K+vZ1jX0RIAOHaPy9fbv5rc8F09QNHZO3Rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VsxMCo3E; arc=fail smtp.client-ip=40.107.237.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VsxMCo3E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jWmoSOZW807MzA3VvpjTWLlVND5H4vJgl8Ex4GXyHQ5XFKz2vOI1HUgS4t1HcCGZiftA+UAddhpYPOypekWX38nyAoq5WWm44aHSZGaH/94ex1AXg45+CPiu2336rQv0MeZBrw4M9o+cndllT39dbdVJ1cqjLnCTl66kXqS2Mt+azESq+OsRYVQyeLeJ0gDVfGbHit1lIPgmUOYwQsj9/3an+l7GV49OJ3wjnNx/+L+VyGNRGqk3OL2SbDGQO4+fK9+tzDUgWyeSvV31fwtWgLDa89jg+BJJGOFV+63H36+s/QP0pmCSL/Fd5yC53CUyWZ6tRV4s6kkJ4ybQujSViA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdxiEWAclReSv/CCqiolz0c8+A0nqLnOb0W++3M8rvs=;
 b=gnKLyw9CTFYyMSFJz/CNsUx004tJBxymXw5XgStg13LzHkPMucaAREAM/yCtqgkzEY4daHt/hE+Ht2jH5yDW4ClVssmIwN5jc0fKQV5/1CuUb5KhGCZhldXggDMnKcLwKHS27TpjRBsbXkq0tjBgGYmmuFwXDe3XdZjXcWeXGzr3Th+rJDxgT2kW4RS6N0D3FcLvTmQIA6scEfSpE6q6CULTECTNwJGjC2NLOPPz5KROOC6dXKgDZuCeQdNNuQW4MFoQn0ukTaxt4Lrf0WLXz1u289c/pt6HnNV13CYUhy+6LHWXKSSE895C6SZSjX5hMrl+68id+avDcE18OgbNCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdxiEWAclReSv/CCqiolz0c8+A0nqLnOb0W++3M8rvs=;
 b=VsxMCo3ERmGWzlv5jDGoonXMEFKPqX6gJe1sXZRcVjt6U4GZ7JK9VtrB18eRPu6jHrgKKcIj1tqoeuiTdPV4m1lmQ2wh5rSKDGcOhEQqQVmhm8B6tmnXNnCPCHTTrYebsyFtI63L4rHFpHIKYfzHLE/JfTUgEw6j5MZIIGbpPfZ87JF2q9FCFcDqV9o4pvQpctfOAsjqfPuTSMzXxKz3PON4uAYlXFgj1bdp5MniHOrIl398Wy1a5jJZJLEfhhUHENG9yThPKr71PMehq9YAOrQHe8e77RNq4YMox1VcFuopcCrk38wAzBjkZfWCIdp4Z3OSJVK5m1exhLCKKHkETw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by SA1PR12MB8988.namprd12.prod.outlook.com (2603:10b6:806:38e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Wed, 14 May
 2025 00:22:37 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 00:22:37 +0000
Message-ID: <38a7d3f8-3e75-4a1f-bc93-9b301330d898@nvidia.com>
Date: Tue, 13 May 2025 17:22:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
To: Joel Fernandes <joelagnelf@nvidia.com>, Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, stable@vger.kernel.org,
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 ttabi@nvidia.com, acourbot@nvidia.com, apopple@nvidia.com
References: <20250502140237.1659624-1-ojeda@kernel.org>
 <20250502140237.1659624-2-ojeda@kernel.org>
 <20250513180757.GA1295002@joelnvbox> <20250513215833.GA1353208@joelnvbox>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20250513215833.GA1353208@joelnvbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0035.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::48) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|SA1PR12MB8988:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3f8752-43f2-4dd7-d896-08dd927d6e43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWVYSXBpMlVGeVl1SE9XSkMxcllzQWFkdXI4TTZqOGF5NEQrVTBRV1U4Ty9E?=
 =?utf-8?B?ZFdsd0dzczIzRzlJci9CenRpay9DRTBPcEN2cWRJQ3V4aVlXYzNvcUZlNCtU?=
 =?utf-8?B?YVgwR29qeEtvclZiQmdxSjNwbk05azZ4bEpvekJrcmFraGQyeWxWOHRlSmRi?=
 =?utf-8?B?RlJ6Rk5TTlZJZDIyekY5Z2x2RDgyNXY1dkdiYUhiWS9EOCttaXhkSWhhNUpv?=
 =?utf-8?B?MTgxdGRwNmRkUjlCQTNtMzhTVmpncXJnUWd6bmRmOHYvY2NIYktlTUptSzBi?=
 =?utf-8?B?RjZsWjNKVFhoZ2ZQb2hFbVdZY1psV3ZVYndDT0I4elRtWGMvM1dIYkVYRi81?=
 =?utf-8?B?elJUbHpFWVpGZkYzUlNoRFFRRGMzZWZqUzlyZHM2bmErTFJkTEtpbThYUkRr?=
 =?utf-8?B?cGExT1FZNkR4WEJ4ajJqcnpmek1BV0ZQVENPUUNBZUx1UjQvUVVmWkNERzJS?=
 =?utf-8?B?WDQ2OG4wTUdjQnlqdFoycGxrRE9tL3NaRjBnV1VjR0VuK0c0Nmw1VURVQUtm?=
 =?utf-8?B?RldlZm9tZ0RHV0dJUFZBbmowSkl3b1A3bm13Tm9HcUpJQWN1VXBkaUJxV1lR?=
 =?utf-8?B?WXVpSjdtdGt2dHpVVVArTHdKT2hmaEc3bW9kYjlBVzlCR3JVRnlyNnlzakEz?=
 =?utf-8?B?ZlBxcTVUeGg3Y1RLM3pweVhzM0d5Z0ROQ0VXNmY3OU91b3lsZGEzM3lRaGpw?=
 =?utf-8?B?cmhEUU5tNUhFUjBNYXVYbWJ6ZzhycXFRUzh2RGtPZjVQZVRqWmFDRDM5VjZo?=
 =?utf-8?B?RzhmeGtFLzZBRHdhZWVCaHVUL2dYNlRSaXhjTURuY0FRb1VJekM4cnNMY2dT?=
 =?utf-8?B?Nk55Y2tqK1JRSDVEVUVvYXU1WFNwRHo4elUydldFOFU5ZmlUN2dINEc4dHVK?=
 =?utf-8?B?U2ZhSkltWm9CdVZiUGFPRmpVcVBjbVpJaFE2UWlUNmg1RnBMNlBRcjNpOUZK?=
 =?utf-8?B?L21HVzVRNnpsN0tpZTFtdjNTS0VaNVYyRTE5RHloeHAzTkY0S25pUmJCOGtJ?=
 =?utf-8?B?V214V3dRczg1Wm5TWGE4OXRwSUJhMC9iaVdRL2hMaGRVM2Rta1RYL3NsVVMw?=
 =?utf-8?B?cm1VR3ArdzBQQ2h5Yi8vUGgrNE05WGlKb2QxR2x3M2pYUzZOeUFIZTFXSk4r?=
 =?utf-8?B?RWUyd0orTXRLNzQ3Q3FDdmJIQ3NnSlg1d3RwVjFFSllRRi9LeU0zOTEvR0RI?=
 =?utf-8?B?K2V1dU0rMnRIRTZwbTF1aXNkVkoxL2dHcEo5YUVoZnM3NzJoY0FsVjVnUUlU?=
 =?utf-8?B?OVQwV1NJb2FheVg3U3ZnNVd6b0lBUGVvTE9OS3JuU2lleHQ1MTVMZGk0K09y?=
 =?utf-8?B?MjV1Z0hyeGpLOFBZa2djaEZzTCtxNXFhN29MWm93dDVVRU5zMWZFM0NSVkJr?=
 =?utf-8?B?cTJTbGxxRThqcVZoMEJCQ0xBdXR5TnM3Y1FSclR3Mlp5TG9yZXp3UWkrSmxT?=
 =?utf-8?B?NjZjRTlSK1U2a2JxM0lyS3lZWjVJUFNhMmhHOXZxRXFaR3VhWkNIbHAvcE5t?=
 =?utf-8?B?eU1aZFZxUlJRRFBCSXhWTUpSSW1BZklMcWJpK0dUYVNIRUl4b1NEcXNsc0hD?=
 =?utf-8?B?MzM5N3NuRW14TE1SeSt5ejhyLzZtTEJRNTA4ZEs0eHZWcWFFaWFSOHhsV1U4?=
 =?utf-8?B?dFdONllXb0Q3R055bGlBRGlSaXI4L3FiUjdJVm5XOHloRWpLVmM5Ukk4ZHRZ?=
 =?utf-8?B?ZFRrUkFCQjN4UGJJOGorOWxZbHFkQjJreWxlb3JiVUp6RGRsK2dOdjRiZDJm?=
 =?utf-8?B?SXJtRjc3SVJLeFozYnlYK1Jqd2FwU0sydTVpN3FReTBDaEZja1V3QVhEOCtu?=
 =?utf-8?B?bVJWc0I5YXh2VFJyNkswVFVWNmgxVlYremlLVUJQSHIrQ0MrSDhHZFFpMVMx?=
 =?utf-8?B?TDJYWU9PcDhDdFV2RGt6QmxjLzZyYy8zZTRPNkd2SEpQcWJXMmE5eGJMdU0x?=
 =?utf-8?Q?g79NHXAsTAU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tkpla1VhRGFFUWlZWFRVemYzQWpjUlp1cWJZKy8ydDhpREtXOWhIVVRhRVV2?=
 =?utf-8?B?aDJKZWNsNm9jQWZUN2FPMC9CV29iZXo3UHZtcmg5Yy9WWVNzenFlWlRaSmhH?=
 =?utf-8?B?WXg5U0lmRUZqaWZHN0paVWRvQWtuY2o4MjdvRzNhY2RqN253OUhGcDc5a0NS?=
 =?utf-8?B?aUNHTzlSeGdaRGxpNHQyUnJrc2VtZ1RpSVlaUkJGemR6anpjNzBjTmJsWlAz?=
 =?utf-8?B?SnFWVkdBYnIzay9OS2JZS1NpS1djb1lhMlFhNklwVnVaZXNFT2lKa3lWR014?=
 =?utf-8?B?UXBUMTRVdmpRQWhMaUFZQWU3NlcxaFh1WGsxb0pBcGdvMU1nM0Q5eW5KS3Zp?=
 =?utf-8?B?Kzh2ZitDSzFuR1RPbGlsVnJrT28vbG5DdzdSL2VDRWE4MExVUE9IeURQd1Jw?=
 =?utf-8?B?MGwvejQyNVJXZ2RFUXNRckgyQ3lUNERzZ0llb203d1N4V0xGWTZJaHFNMVl1?=
 =?utf-8?B?ekxUVlUxOWFHTStrZ2FXL29SUnk0S3VYbVVsN0s4S2RIWG93MVVWeks4UHJK?=
 =?utf-8?B?K3Vxd1NJbnl4azl5clhwUTlMZHNsNk5uOVBlbU9iblY5cTJVK0s1U09Bd1k0?=
 =?utf-8?B?WjVNWTR5cDR2QXlwOGpkeG5DQWF6ckZKNHNUK0M0Mzl5N29PVVR1cE91V3FZ?=
 =?utf-8?B?M2NORTUyZnN4aUJTUUdQTHhnazRNV2N4RnkxUHBydUowcGl4elpmdVZVemFN?=
 =?utf-8?B?SEpia0R6Ym1rZGIxL0phTkd2aHFteFNyYW5lMm9JQzl5a2p3RVZ1QVJFOS9F?=
 =?utf-8?B?dWR0S0I2ZlZtWTRsdmxBZFBUOU5SMEpjMmg5Q05SdEhJTWxjQXVOMlhUL1Rt?=
 =?utf-8?B?NmtOOE5vcWZqRVZEd1BLbldiSkh5dUw3b1ExdnFOeXY4MEc2NGgxcU14ZmJV?=
 =?utf-8?B?ck8rcjE5RGUzV21NZi91WXFoZERFZEpEdTliQXd1eGdydkNMZXlsMXhMTnhM?=
 =?utf-8?B?SFlnOHZ1dTVaNFFLWWdYSWUzQmQxdC8zMXc2amZ1VzFrZ2plb01hZXFFQStN?=
 =?utf-8?B?ZzVXY1UyUkIxbG92aEdwLzJ5cGJBczlpeWJTSWZqQkU2VVFLMFpjNEhCa2p1?=
 =?utf-8?B?M0lWd0Vmd3lDR2dOa2pMckVNNTAzR0JCZFdLS2JtMXg0QktDeXhXUDdwVFd1?=
 =?utf-8?B?WDltMzBwMDZDbG5zN1BFT3ZLSXRpdmJHU2Z4TllBZnFBUTF3RGE2Qmw0aXd3?=
 =?utf-8?B?SWlyZkJVQ01Wa0hkNElxWHBhZFYxZUVzT1ZlWDMybDN1emNHV2pDZmVIdHJu?=
 =?utf-8?B?QVZiZEpzVFExeEhKcHlRNG5ocXhDRWJMaWJVQ3IxS1dBT3RlM2wySlljYmxS?=
 =?utf-8?B?b1lGTkVHcHl1czNyZU1FTzN6WXRjNVl0VEFaM0xyNUVwQ3JodzBNcFBXRXFr?=
 =?utf-8?B?L1pjcmF3a1RtY1h6NDNOa08wUmVzd1JINVFEb0JlRkVzQUtwdXF1bUxMZWZi?=
 =?utf-8?B?MG9sdDQvdU5iMXNqaUtnL0RIY2tuc055OGJtN0xiQkR2M2w2VjlBVVhjQisr?=
 =?utf-8?B?c2xFRThmMEdsemVyRjBwWE94ZUcrRTJlZ0Q0WmtFanNvam9NQU10MTZ4UWZC?=
 =?utf-8?B?cTk1MGVOcEx5R0cxTW9MeWNIenJDVVk5ZkY1anBZWWJUQ3F0b0doNVVkRzhi?=
 =?utf-8?B?bzY1WnlPaUFuTU1xcWZQZkhvOVBHYUpiQnhWcEtBTjB5OUQwcjFYcno4ZC9V?=
 =?utf-8?B?cENpdUlvRTEzdTl2VWVDNkFMYnlyU055b3g4bFd3aE9kdG8zbUMxaERialJL?=
 =?utf-8?B?QVdqZitmRlhuME4xN2JQQjdKL3FoZ1lySFhpK2FBdjdqNlR5eG5vdEZxNmR5?=
 =?utf-8?B?ZVA3eTNONXFkRmhqRkJvbys3OFVJdmo1QlI2UG5EeW9oQS9DY1loMURYeUtw?=
 =?utf-8?B?Z09qRHhTWXhOa2c2UTkyS1hEWmtkSS9EWXpEc1dtYVQyMFpraUlTUStGaDdm?=
 =?utf-8?B?RnUyYXB5eVJwQTNLN0w5NFJDdGV1cCsvalltM1U2OTZsQldhMW0rVmtPZU1D?=
 =?utf-8?B?b1lSVDZ6aTZkVzV3b2ZuTTEvQlZTSFViUEo4Ni92YUs0U1FVZEVzZXRvQmoy?=
 =?utf-8?B?OVgvUDY3ZDIwS0h6RVcwUnhEdjJZaVYwSVNqWVJseXhpditKWFZRbC84akZO?=
 =?utf-8?Q?xKTBrN89IEfSEB+TYVRUj8PBV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3f8752-43f2-4dd7-d896-08dd927d6e43
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:22:37.6806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InO5o4qfM6X5xmBkw7E4R/JRwO3ImCuCQFRQa8ANPeLVgjRUQYzBXMxCmSzv0KPnIumC7kRy31VFBlQqfNg/dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8988

On 5/13/25 2:58 PM, Joel Fernandes wrote:
> On Tue, May 13, 2025 at 02:07:57PM -0400, Joel Fernandes wrote:
>> On Fri, May 02, 2025 at 04:02:33PM +0200, Miguel Ojeda wrote:
>>> Starting with Rust 1.87.0 (expected 2025-05-15), `objtool` may report:
...
> Btw, Danilo mentioned to me the latest Rust compiler (1.86?) does not give
> this warning for that patch.

I'm sorry to burst this happy bubble, but I just upgraded to rustc 1.86 and did
a clean build, and I *am* setting these warnings:

$ rustc --version
rustc 1.86.0 (05f9846f8 2025-03-31) (Arch Linux rust 1:1.86.0-1)

...
  RUSTC L rust/kernel.o
rust/kernel.o: warning: objtool: _RNvMNtCsbA27Kl4nY2_6kernel6deviceNtB2_6Device10get_device() falls through to next function _RNvXs4_NtCsbA27Kl4nY2_6kernel9auxiliaryNtB5_6DeviceNtNtB7_5types16AlwaysRefCounted7inc_ref()
rust/kernel.o: warning: objtool: _RNvMs2_NtNtCsbA27Kl4nY2_6kernel2fs4fileNtB5_9LocalFile4cred() falls through to next function _RNvXs8_NtNtCsbA27Kl4nY2_6kernel2fs4fileNtB5_10BadFdErrorNtNtCs8y00iZOEpTQ_4core3fmt5Debug3fmt()

...followed by 10 or 12 more of the same "falls through" type.


> 
> Mine is on 1.85. So if anyone else other than me is suffering from this
> warning, do upgrade. :-)
> 

Looks like that might not suffice!

thanks,
-- 
John Hubbard

