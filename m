Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D349A1624C5
	for <patches@lists.linux.dev>; Sat, 30 Aug 2025 13:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756560717; cv=fail; b=Q+brq9FSVCFHcSGe1mf3dP7ylDbwN29kVdgiFTnV+Vqh7Y80U0WPGt1ywcEOSLdKxJ5qVe2xCFA8AKf1A19Is4FEwkwWuz21g+Bm5hgwzFGL/JXFMT5c4pXcqHexrMIOb3yAp5nEa/aArXzHzIuUkGIKUXSdarEcbCGWw/6naeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756560717; c=relaxed/simple;
	bh=9igimOr2GgjzzDKT50pcr5D5NVJT4BYs39/b9s7nhWA=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=CbPEdO0+1dXYIsuXnInprLinPtlheUUS/Njmh8gXinREwThxunS7EMlKKZxG+0lSvo/kWhXLaep3PEsPYH6J7LMgH5iN+XpLnCmH/2DTUv8Ibn1MBWryjEJGamIWiXXhD7C/M6KUTvJoANmfwFUD8Uz0zkKSxW6tiXy3KPZI/G4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LjJ2CvGm; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LjJ2CvGm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anctA4dm3ka66i5qIjHzyGowH5xK4iOTi32NBrR4zcDvY77C93MeXOv6OhmDyNWAFlRNafUtZ633YpGlD797qq6eE8HrtXUTiyUtnmJdLIGetqk7vD6nW1Kmxqc1GXT21qwguPXe3+o4QdmiYFtqEPhmEOqy9/PNYU0U2ln4EWBFutQhbELcNbtoEreTvO4j/FTBPqZbe1tfo+mLgtQqTf+kZfsNMchvwQlTnZGdBsQrQ8n7ADc4Xq0Qnm5mcF0kAdFLJMg283SwErsEHA97NqwbCwxrgRPARSofjMB66c/pkqVnhjVN6+zQZrLqLTGXKPJnV4vgSwr6ofa8AvzWAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9igimOr2GgjzzDKT50pcr5D5NVJT4BYs39/b9s7nhWA=;
 b=lk59AUr17/b3s3VAxg7CX4eIOjC4jM9LZUJQnjgclTO3bdWeDRT8Fe1fn+swOUcrUJzCvxCn3XltA9/JXoQGer5ehgANFZ24zaqxYCOQyxIRf55BiExuedGjEPRegBbcogdS3S+dXQx68m6B/sdH5ASTZxrGgpyssQEOWxW320mbBGrtln2Sx/1Wwr3hk/pgsa6hERtLWLxHRlS9C8fkepFnd36UC4sbaVHfhba3u9gPg24fs+ZdoNGjyvWRh080JEehaOi5WWQKW9gxlbQA528NajjlAw3qR/r+JNlzxI7GGZ6qiQevQ82HERmxTBk+ngq1s6/GxU2a5OunvLVPJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9igimOr2GgjzzDKT50pcr5D5NVJT4BYs39/b9s7nhWA=;
 b=LjJ2CvGmyb30qxrVbA+ER34L3+bq0OjRT4AtOJ28H1r2UjceGtbtVENIKNd1v6v4TjWLEVb9UKOLqTBMk8h0mX49DbmXFT4H96mp2OI1FwjF5rSCdcTLkAI0g790WIqL/ydt8ubBX00ZtOxK7HQu4LeOApuF4FECNvA9S4DbMIyJFsL9dunmBdcYD4B4bTNrvsj1DNkwNI2uqKqaCdBiMOQdaPU7u0a9g1xc81Vk38hYz1N5R5935weS1BR2bMrXK8MWNKhapz3zMlaDgtJ9FY3ItgAi8s16UdzF83c5Qx+tQDgQtRjlI27EzO6De1eLrqGck5tIix/SF9bFrVeMPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by SA3PR12MB9129.namprd12.prod.outlook.com (2603:10b6:806:397::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Sat, 30 Aug
 2025 13:31:53 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99%3]) with mapi id 15.20.9052.019; Sat, 30 Aug 2025
 13:31:53 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 30 Aug 2025 22:31:48 +0900
Message-Id: <DCFSSXI4ZM5I.MANLL2G6W8FG@nvidia.com>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 1/3] rust: error: improve `Error::from_errno`
 documentation
From: "Alexandre Courbot" <acourbot@nvidia.com>
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250829192243.678079-1-ojeda@kernel.org>
 <20250829192243.678079-2-ojeda@kernel.org>
 <DCFR8DTO39D2.1RMIDS2RUJ3H9@nvidia.com>
 <CANiq72ms=aqiSm2owBqTbviJVk35CMKQZ6G0XmeR7-0fajxjqg@mail.gmail.com>
In-Reply-To: <CANiq72ms=aqiSm2owBqTbviJVk35CMKQZ6G0XmeR7-0fajxjqg@mail.gmail.com>
X-ClientProxiedBy: TYCP286CA0063.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::12) To CH2PR12MB3990.namprd12.prod.outlook.com
 (2603:10b6:610:28::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|SA3PR12MB9129:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c04265-3315-426b-b9f1-08dde7c994b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2ExL1JkNmJydlVQS2tGWU9za0t6emR3N0p2bC95VktqTDFKOHdZUDZlWDFJ?=
 =?utf-8?B?UGZMTStrUE85akRIejdpOTBWaHQ1dGk2SFBURWUyTzI1KzAxM1V0TjZFcU1M?=
 =?utf-8?B?ZlZTa0FPVll2SjFtU0NaYit5QUxPaUs4SW4vbEMvMEkrRmlFMHZmNVlVc25V?=
 =?utf-8?B?R0FuOTNCdnFpblBGRVB2RjA5ZWFyME9OeGxDMzRmRVVIdWpQdDYwYUFML2hw?=
 =?utf-8?B?dFptc0d2UXFYc2wzSlB3NTZBV0VYa3NYMFY5Rk1MZkw5TUJFZ2Y0T1BFV3ZP?=
 =?utf-8?B?THRVUEM2QzNtMmFaMy85SjBaOUF4S3owZm1TNERqbnM1NXgyK09qbDhDTVlo?=
 =?utf-8?B?WE9oT3FUMVd6RmdhNVprYjhPM2U3dGZzbkZDWXV2bFJhWjZ0R1dWUWRGWFVI?=
 =?utf-8?B?d04yU1NpZVpuOEVZYVI4ay9Pa0lhK1JYVHBpSS9mNEYrYndBS1E0T1J5VWww?=
 =?utf-8?B?YzRNM1FQb1dldktGcUtHK0pzemQwTXJ1VXVjaEFMRHI3KzBLcmlYL3pUTUlM?=
 =?utf-8?B?MmY0YndneEEvZlNIVWVWWVNCUGxaek16b3FkYmgyNGpKODlkL3hwTDlrY3Jw?=
 =?utf-8?B?VGVndzRzOG1VMHNQMThBQW9zcjROSWJMQUhBYllzQW5ZUTlhNmNuQjUyTktZ?=
 =?utf-8?B?aVp0dUcralVsWjBELytUbFNDd2JadTIzTGRjNFhDU2pKcHRlZDN6UWpkaFhx?=
 =?utf-8?B?YTZnNFArazhKMVdHQWNCa0R2TjhiMDZCYjhqczFDcDI3U0pFOWZ3TGw1SEJT?=
 =?utf-8?B?RU1CaksrK0dpUndCc1cxaEQ5cDFBdk9YSG0wdXBLU0pSOHZlUFFKVGdSeWtX?=
 =?utf-8?B?cU52S0dWZEg0Mkg2MjJIYXFMcEc5MCtjb0QybU1WR3lmMDYxQ1FrOWNOQk9v?=
 =?utf-8?B?THdxUXNmZzlOSW5haE9Cbk13V1NBK2N0bjBRbk0vSGRrWnJaM29QUFRsK0tU?=
 =?utf-8?B?VExqZmpIdzI3ZWFZNkJFWTc1L05qcFg1SjdzR2lpaUJhbTUrN0JMNkFMZnNH?=
 =?utf-8?B?U2syNmU0U25hTmxjWXhTN1Z5bmE0RWVXeXhMZTkyK05DY0wvYnl2a2FXRmNm?=
 =?utf-8?B?dFJjTk51cTdRZC8vK1NtYXlzQW5zU0c4TGZHMk5VUXAxQ2lUdDI1cTRqRTlx?=
 =?utf-8?B?anZLN1p1S1ZjSS9WSWg2eXllaWdRaXcyTEZ3T2dwcWd5QjQwWUFNTjBGN0Z0?=
 =?utf-8?B?bVB6eSthSTduZVB0MWltMFducnV1SUN4cmdJYjN5dG9zU284dW90a3ZpSkI3?=
 =?utf-8?B?N2tGWTlLNjJKNFRTSytZSWtyamk5MWVvYVY4RXVPREpxdUhwOEQreGFDd1N6?=
 =?utf-8?B?QTIyTExTRmU2K2dEeFFOcDJsN2hKYk83ckFhbXovck1ZN1BxZ2I2Ri9Ua0kv?=
 =?utf-8?B?YU9PZnkyOHRvbTZhaXN3dGJsL1RlTjdFdUlTbjExaGhNem9pMkZienlzWFd2?=
 =?utf-8?B?R045V0o4UGVrZXZHTGNsenpQNFI1U3pmQ1ZUNkNtTStBL3ZWVGpvejJhbFp2?=
 =?utf-8?B?RFl4b3VvWVF5VE92ZC8wV1M2WlRVQ0tCQXRGTWdYcVdXNlpMMUJES1dHVnhz?=
 =?utf-8?B?bSt3ZUFJRG5CRExWa1UzV25kTU5hU1dxdVpTNFp3WDJ4SjU4SXlrbXNPQklV?=
 =?utf-8?B?VCtpSDFjKzc3c1RGOTM3VG1vdVk0ZWxkNWN5c1l3dmYvSG1PVlJwNTcvUlo2?=
 =?utf-8?B?QmJ6QnlSOEpKVHVicFd4dkxXaDNycElMT081QUJJQStpdG9sREpCempyb2I5?=
 =?utf-8?B?enl4amx3MEtMZTYvSlVUY2lqdGVBRjBDeUJYaVMrT1ZoL2JvU2xmWE1YdmxQ?=
 =?utf-8?B?enZmL1VBUG5nYWlaUXFsazU1LzBzUWRVVXhxcE1oWDlmVkZaQzAxNnpUUFY5?=
 =?utf-8?B?MUNRVHN1bEsrcHpia2R2cUc2SmZlcTlDd3NIYVk2N2FGcUIza0FqVS96K2xu?=
 =?utf-8?Q?svZ7Y44V8MY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTl6UWlyS3hHM0Z1d1ZaeEg2TzRKb2lzMzBEcmU1WGVYQ01GeFZuTDl0TXJR?=
 =?utf-8?B?RU1FWEpIVWVwMWRrNlV3a2w3eFNabFlMRy9RQkQ4S1pnakpXRm1RaXZRM2Jo?=
 =?utf-8?B?UThnUnFESkV6aXhqUjhOMUZnSlg4SHd4WXhlQlpvcVR4SUk1NEdxbGhWVDZN?=
 =?utf-8?B?YmxsSG9MRzdRNWxDSGtCMVFMYU16SDh1cnhKOFlvc2JVem8zV3Y3RjZvOWw2?=
 =?utf-8?B?WkNOZ3lHSWNtMHNUN0VKbWZ6czN0Y1RKN1RVUFFLYlJwMjlrUUhPUUFhQ3Mz?=
 =?utf-8?B?RGx3YmtaaGtFRHVHTTUwVndPaG9KSHJHMThOUjVzU051eHR3dXFKd1hpV2dZ?=
 =?utf-8?B?dDlyOHlQRFpjTURYS1pmVUtiWnVFdGVqRFNIK29WeWVzbWRWWlB2N3lEZXRZ?=
 =?utf-8?B?WVkzbG56d3RNMWJ5dldHUVBNSDM4RDVMdTI1WVJvSkI5dEVlb2VjQTQ1K2w1?=
 =?utf-8?B?VGJ4SFYzNVBrbE1kMEZVOHp6TmFiMFVZaWdYMi83NjN3M3ZycTJZS09BOTMr?=
 =?utf-8?B?R09vZnFjZkZadmlRZEtvREk4dnNnU0RodGxBQ21QVXQwc29MZFpWMGVKQmRm?=
 =?utf-8?B?blZucytWUWhuNnFMeUhlajdUUWJCaGpGK3FmMk5LV0ptczdHWlRnZ2hKTTVB?=
 =?utf-8?B?bDlFYU9QcHdEM3Foc3F0elBrYmIzeStkVE84WlIzVHBuTGxFSGdjWGtlb3Rh?=
 =?utf-8?B?Tzdua3hjRlVuMGJObUI0aFdOYXlyZDcwbE4vUXI1aEY0Wm9WUFlNWmZnR1k5?=
 =?utf-8?B?VlA3MVBYbWRBN0xoL1dRTEQ1M3lEMU04OWIyWmphQmRBcHZsRzlDR0JlSGVF?=
 =?utf-8?B?QjN4bisvZzkxM212T1ZRc0htVE8ra0RKQ3R3bS8yNEtmbW53amhML0o1bUdp?=
 =?utf-8?B?UkRiZVJQaUZCOUNHWHp0VytqajhtNlJ4WjhPS0N3a1VFMkpkcTIwUlJiZFlI?=
 =?utf-8?B?RG5raVVHTWF3clN3RVl5QXM5bnhiRlN5U0kzUy9GWW9iNjhrQ3BxdzB3STh6?=
 =?utf-8?B?OHpjRzUxUnZ6YzhxTlBvbUdFd2hFeUpRNXppWVY4ZkljZWUrV0RHVC9zVG5I?=
 =?utf-8?B?QlZFaU9vRWhldlBIUGZtUksydWFtTWxEUFNCaDljQStTbVdLTVNNc0NSL2Fi?=
 =?utf-8?B?RFhPL2dabHFoNlRqUGIzUFkrMTZ1dW5LK29udkZDS0toWjQ0cUlweWd3RVFk?=
 =?utf-8?B?YjAvR2tBSTZZS2tIR3U1MDB1Q2RqZVZ5a2JFMEcvVHFUOXdLdUxRVnA3Q21D?=
 =?utf-8?B?VTJjOFV1WHZqZUdTMllHc2N6eXgzWC9pM0pPMUp2dkU2TGwwVkdBekNsNE1k?=
 =?utf-8?B?TlJDL2ZlTGhKS3A5YWhJQU5QSzMweVF3Mm0yclZtYU5TTVd6Yjl0S1ltbDE5?=
 =?utf-8?B?WlEwWWh6WlZhcU1uNHlZZ212WHBmUFlGTldOMGxUZlJuQjQzc3hqQUUvOVBS?=
 =?utf-8?B?K2F2K3lpWlVpNVVyMGNsWFNSYllpMXF6ZEFhNk83SS9HaWVHb2dTY2lJNDFR?=
 =?utf-8?B?OU9BWW9ONUtkYjVPY1ZMVWdlaW9QS0wvSkpyUWJ6RmtzYVZVQVhGWnRBYmxy?=
 =?utf-8?B?aHJzR0trT2V2K1I3ai9YeTNXUzBSQmZiSEUzQXlRU1RERkh1QllvTXRlVDJx?=
 =?utf-8?B?TzQ3dmtpcHBJbCtER0FDaVB6UlV5UWJ5TndDeDJoZHdyazlkaVkvODMwVDZU?=
 =?utf-8?B?K0NwVkVJcHB2MzFOb3l2aVlQMlVtdThZcjU2NVJ6cE56dlp3TkcyZW9vd0Jw?=
 =?utf-8?B?WUx6UGNaMnFta09iVGdqeTRSMDg4ZzdsWXdMZXV3bEFpakFXSHpEL05tWlla?=
 =?utf-8?B?Z3NicmxhWUxXb0dSTUFQMmhwdjlUMi84MzBHSGNwRWhMUmZMTk00cmFRc3pY?=
 =?utf-8?B?VVRtK3FEa2xsYjdEOWZwVTl3SndMeWRQR0Y4akdUL2k5NHZXSXFqWmJQNkQx?=
 =?utf-8?B?YXprV3JYRXFvVk83YVh0MTVmVTZtUGlIdUNnOUdyRkZjYU5nWStuWjRmdnNu?=
 =?utf-8?B?UXpSWXBUK0dOVjltRFRscUN5c1hlTWFjVjBmUE90Y0tmSFYvMWc3Qjc1RDE3?=
 =?utf-8?B?VUhKQ3RQWk93MjFqaUtVMVpVcDArbVM0aHdzVDQ1akQ5NnU2RmdUUTNTanB6?=
 =?utf-8?B?enB5ZXJMeE0yWWtkdnozUmZWREIrTWlvL296TVJZMGdjcnBMRVNDSHgwcTh2?=
 =?utf-8?Q?WBRj3Rs1JoOcq0dpDa1gKqELVvky+w4MV+Lae7hq44R/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c04265-3315-426b-b9f1-08dde7c994b2
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2025 13:31:53.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwiZRc4DYkF1/nhRRpdPa1BrbF4yahFWoS5ou7n03PuUbCBdhbLTElIGr7jlDRBct6waRK0aD1xAO5/uckM6wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9129

On Sat Aug 30, 2025 at 10:00 PM JST, Miguel Ojeda wrote:
> On Sat, Aug 30, 2025 at 2:18=E2=80=AFPM Alexandre Courbot <acourbot@nvidi=
a.com> wrote:
>>
>> Small nit: this leaves a tiny chance of misunderstanding that this
>> function actually expects literal negative integers. How about using
>> e.g. `bindings::EPERM` instead of `-1`?
>
> Sounds good -- or perhaps `EPERM.to_errno()`?

Looking good to me!
