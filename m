Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3FE1DF99A
	for <patches@lists.linux.dev>; Sat, 30 Aug 2025 12:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756556352; cv=fail; b=lUQKB4HgDpIh37FwcZp30x0rsHVGs8/yJTdRugvAGhVaoROCYnBkvuZaiRIrOugjMqECGsH/cpRdqpaHyrd6lZlwSlCUq5uZOyyDPTEA3BzwWexF60BeAVUu3/0R3OzAnwvoZyn+xIC9qvcFGHUW32HAWfvY+kGi+ULw7i4O1OI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756556352; c=relaxed/simple;
	bh=rTbSkOMe22vFov01iq/vsPoAdEEQrPL3U2Ef/LhqADE=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=oSlNhwss66OhpmsPV0mxR+k0H/7wIxoLpuhA6oCSYKmFQhP8HM+hPcuphbhVo7nTbZ1KFkosxHaN/26wV+eMXQ5dab1m6duRZyp6tLQIs0UhAmSKIh6qsP1kkNjRdgTQQ2M/Wf3y4LQQXupvusGgu9HLda80NtG76v2B+GW4lhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nSvjfq9B; arc=fail smtp.client-ip=40.107.237.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nSvjfq9B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kEf0AqEFNpFSXCmWGXM0/EHpk+HfJi194LswkCL9EWllpiDX4p5yhgQbxBFyUUzvwFr5U9RyUqqD4RaWQggW3L67Rc4l0pE+us02wIEV58IFiEC2e/dDtxlwd5n7sFnQEhdXeEF0QpZ+6utEaxl0cLzDQzqIbpwIVVHaO7WVgoYqf4CksG5tgduCnmTHQ0/i5k3yxEwzU4JLlnojulZYLYBAK3IfyeNPEgB1QqexChKnLXBaKYt6hGbHFcMvwSfPIvJckDHuCJ6iaHK7yLkhaTDo/L1NT5xRMRAjYrdGuoFV3NBYYjmbKhcPVG2PWqCoYkmKHC1yqTl5NWuvyHBy+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rTbSkOMe22vFov01iq/vsPoAdEEQrPL3U2Ef/LhqADE=;
 b=mcuG4AH6xx5m2k8tUV3wpf0hWbbRdAAFoWZTA85boAU4/I6rguaA0blF+WmFQk/lEJiZF16wg8AD0C5Dp+60PKgUWwVVJsTdzhY+CiSXAxJhGhRC2i1m1ueF0V0Mo6XIlKR1rusV7gK5Uu7UvKTBkiEz27B4X2WEcusZBgDRngpb7xhnS3AEV0RDyw4vhQgKfdfK61nvpu/BBn1mGb9et2BqmYABheC8WuWIFO/cd2PVjVldae7gTw8zjTv8dqH90PUljJPrcmaJVGzLCyeDwhlFXVcV9tlfZG3k6DC12KwNplOLjViaBwC7/JaGwKRJvi4nsp7jamRGanPRbjplZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTbSkOMe22vFov01iq/vsPoAdEEQrPL3U2Ef/LhqADE=;
 b=nSvjfq9BduIllyXCLMaDWJ11J0/qfmtPyqXDdH6B7YnSOmyNRRZv3nXiYOmq0UHJjd8tw73t/DbWIOyGjVkI3ehyMt7GCAY3OEPELNgxOBTNHdRHIK5JLGU7L9LmWHZTTEjBU2wb4d2Xs3cgZLg2/XWz0lowqOSAmybb8P12ENcqn82xpHBDoZNYA6htrI4mJxFOaTzdtFDAQkTMEw3WEsqUViwE9X0QrCKIH7Uh/KCIvzOHaFL6vtzdiwkf7E2ZzedIiPkuWdOZK8OnGsDDoT6HAGP79ud4cT/6iv/Mpw7J/lUq9eWuZm/WVjpn0Gm2rhI+wetZJ4IIOyRAQrrjqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Sat, 30 Aug
 2025 12:19:06 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99%3]) with mapi id 15.20.9052.019; Sat, 30 Aug 2025
 12:19:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 30 Aug 2025 21:18:58 +0900
Message-Id: <DCFR95ZSYLCU.1PNOVU76VMYOS@nvidia.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 2/3] rust: error: improve `to_result` documentation
From: "Alexandre Courbot" <acourbot@nvidia.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250829192243.678079-1-ojeda@kernel.org>
 <20250829192243.678079-3-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-3-ojeda@kernel.org>
X-ClientProxiedBy: TYCP301CA0079.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7b::15) To CH2PR12MB3990.namprd12.prod.outlook.com
 (2603:10b6:610:28::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|DM6PR12MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: 56bc868d-a134-451c-7e3b-08dde7bf6787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzhscDJXL2taeEptaytoUUdPZGVJcnpEQ3pDNEI3Zm5FR0JLdGdQMzlZamRF?=
 =?utf-8?B?bWVWU2Jud3RQeDFwa3k5dEVtczViaGsxTUVWUGFaSSsxZHhVeGlDbEs5ZHlw?=
 =?utf-8?B?cFJuWTl1NC90NS9wRFQ2aFc2bWFwVG5rZStIaVpTN2Urclk2VnJLVmZ4cWg4?=
 =?utf-8?B?ZzYra2twYy9oNVpUYUhBOGRiOWdBVjVUYk83aTdhWmljOXhSbnpkaVU5cGM0?=
 =?utf-8?B?L1BBOHg0eXJjcnpNY3ZoOFhSeHpFa1MyL1BrNjdUV3g2Tit2ZElQS2ZnQnlL?=
 =?utf-8?B?Q1JqeGNGQWlMMXdMNWxPWVQyL2ZsdGhMZ0x5bTFHR2tyK2dRSlNMaVdydnA4?=
 =?utf-8?B?aHpyTkF2V21MRFZpUzBsY3B0R3BJcFlsZkRPeTNLYjhPa1FndmcxNDdrSlR4?=
 =?utf-8?B?Y2NGREFDUWFaUXlGeWhuWm90VUZ2QmlPTGxrdEhaZHl2L0xIZXBFSDgrMXcw?=
 =?utf-8?B?S3NZdUNuNEwwL20zbC8xRU5USXhIVUY4bDRVV2l3OCtnUVh2bllJMmlnVWxm?=
 =?utf-8?B?WmwyL2gyUnM3eFkrekZBOXYxUmdFWDVJZFhaSytGRXVneG5jM3MzLzdWTVRD?=
 =?utf-8?B?QVZCREhlUk81b2s4THZadlpRc3VzaWhGU3dMNzJOVTNKL2pVdTJvWGl6U2RJ?=
 =?utf-8?B?ZnZrMjdMTGtEL25vd2cwclZUY1JTSEFuTndRVjJrTG5MazBySGthdVRhQkxS?=
 =?utf-8?B?VC9mMjBnVWFQdWQyZ29MUHVsbzh3dG1JZlgyZFVIMUFqa2diMkQ0UE93c2lj?=
 =?utf-8?B?TlhKaEo5MTIwV01MSDZPQnR5ZUpXUVpGbXRaaHpLMUFFaVphOExwOG9ZWjFj?=
 =?utf-8?B?YUlLV3pMTDdCZnFYTHJ1cEZYRCthSUs5ak9RRldaanJLQ0xxMDJPQUprVzdZ?=
 =?utf-8?B?dE9EQUl0WklNVTdTRGNFNnJpUVA0VXoxb2hSdk85dUNST3FQQjZ4dnNQRTBs?=
 =?utf-8?B?RnFKVDJqUjRYSE5peEg2VzV6cEpUb25LaDY5dmQ3OGF3cFVwcU5wTXE1TUY3?=
 =?utf-8?B?bllmUks3dW5aRUcxR01LWHQrQ05OaWl1NkhVRGtVUTNxb0ZjbkV1T2VURnZu?=
 =?utf-8?B?UisxVWVnamttMW0zSjJHaDM0ZE9vM2ZzMXpmb0pkQWg5bllGV05zSkdxNUNX?=
 =?utf-8?B?K2ZDM0QrS0NHUVNsS0hVNjRtOHdvS3MxVnBlOXpzN2tUQWRjVlMvb1VDdWVY?=
 =?utf-8?B?ekU2bWxlNzN0SFhJeXFPLzI5MnRDVkY1K2EzZk1lODR0eDcxaFBOc2NZOVJm?=
 =?utf-8?B?OSt3Z2N6Z1RoRnlTbktlSlZmNUE2Z1JDakp5dStqZ0l1aGE5LzBxcEJVL0do?=
 =?utf-8?B?Qkk3UG0vVkFTMjk3dzlDYnkxdVRsUitFc2IwSG00TjY1Q3FwQmxvREt4eWZo?=
 =?utf-8?B?bWpOdW5taG1TNkxET2V5RXdSeDlKei9rRXZwbW1iYW5KTDljeG1ndk1wSXlH?=
 =?utf-8?B?YmVYQ2c0ZzNyQVhlRHFjb3JzRGp4ZFN0R3ZzK3NmUmE2ZDZCRXZYenN0ME1S?=
 =?utf-8?B?S2ZUSFVVcWhOMCt4Mi9CUFA5NkR3a002UDhqZFZuOTNpYlRUcnRUaFNMaDhK?=
 =?utf-8?B?czl3aEY5UEZSZndaeUdYa2pVWnRuUVdhMnhpc25HSmdEVVhQY0xiaTVhczdo?=
 =?utf-8?B?MFU0V1ZFdXlaVmw5VlFsbmtLNHpQYkkzNUM3bHhRQXFDb2ptT3BiWlQycmo1?=
 =?utf-8?B?QnltSGFYMzZzU3VGZGhBTDNVd1pJSVlPaitUTXVBUlozSlRldEdhQ0tKMVFH?=
 =?utf-8?B?Mm82TjM1NU0rOTFMMmFEY2VyYjMrVURkTVF1WnpMcXRaRjkyeXlCcjNXaEV3?=
 =?utf-8?B?bWREUU02Nko0WnlDWUNVTVN3UC9hek5rVUpNQ3hMemFrMitQRVAvN0dYQ0tp?=
 =?utf-8?B?eUpwRXZUL2g1THhhZTBpdklnTlFMTkthV1ZpS01CZUgwWEswMjF0a0pMbExy?=
 =?utf-8?Q?omQQ2mH8ZMg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUdPTXJVVXh3bVhZbStyZkZYTDJhR2liRm1XNWxKNkR5M2t3cTlPakozZUds?=
 =?utf-8?B?NFl6UERrRHR6RmpYK0toWkRTMWh0alFVekNmMk1qRm00Z3pCV25SR3FrWGNw?=
 =?utf-8?B?VmZmSm5RVWRYcExxR0w2ZWtZUXpmVUt0YXdyN1czdFgzN2FKNjNtQ2dhNFF0?=
 =?utf-8?B?U2J2WjZiMWNZNzhsck1WMk80em9XNkQreFlTbWNvbTh1WEVMRzh1TUN5ZktN?=
 =?utf-8?B?OHl5TUcrbFZ1R2t5SXVoRjJIU3pnRzR1WEUvdTh2bFhnandSajRQalc0UlhJ?=
 =?utf-8?B?MlVzWmNwdWRoemt5aHV6eEhHaGp2MGNtbkxMQTZOUXZveGJhaFZpTW9qKzdz?=
 =?utf-8?B?MFVvNzF5eHlWUjdBc0Z5UjhLVEplZTNsSHY4U2JKTjQzRURLQWYydEhKZi9m?=
 =?utf-8?B?bnY0aXh0Z0ZqS1YydU9mUnBLTU9BQ2Y2WFcrVGZCSzdEQmd3c3JUZlNKMGhs?=
 =?utf-8?B?KzZxVlY1VUlWQUJQdUxubHhFYzFkdGtGSTE5SzFJbE53Qk1HRFZhRW1yZFhx?=
 =?utf-8?B?NTdhNTlKeElFMThhVzNtMjNseWFtVGttdTFGRTZtL1FYUGZMcm5lamN4OHlP?=
 =?utf-8?B?UWpGek80WGZqdHpJWndtNDBlTEVvdithM2E2TkwzZVJnODI5eUN3V1ZEelB3?=
 =?utf-8?B?c1UvNmpxRzJNRUJ3TEVRRzVpM2Y3WStzMjVkVjhFcVgzYkxaOE9JZWFMVERC?=
 =?utf-8?B?WWJMZmZiMWNNaEtBNUUzUWxkano0ZWJwS3pFb2xvQnlhMFRBb1pXZmRjRWov?=
 =?utf-8?B?Q3h6bmsrcHBPSFN5WjMvWE1PWmE5VDNjdlkrRnVGOEM2OGU0Z3k1MHlXdzVO?=
 =?utf-8?B?RWxaRURkY05Dd0J1L0RvVEFPQXRNa1lqcGwvYXpyTUY5VVhxRnVhNEtKYTRC?=
 =?utf-8?B?NkNzVUV2bS90dVNLTU1MY010SGhiY3RQTmZpS29FUURQSTZaek1qdDJVbWcx?=
 =?utf-8?B?SVJmZEd5c0ZyQmNiV0w2SzlBSHlZTENTUHc0M0wyeWxvcXFDbndoTU02d0tX?=
 =?utf-8?B?RTZXV1IwVWtrYS9KK0JXUUtrMG5mdmlDVi8xdTNveGNEckdyNG8wWGlGVDYv?=
 =?utf-8?B?ZUl0eEx6cmlPdnJ6QjB4RHk3VTlyWDF6V3hlRHRkbktFZ2cwV3k1Tk5Gendq?=
 =?utf-8?B?R0g4U0RrMHFnVk5qWldBVFB0V0oySW1YamE4eUYvVGRkSDQ2bkQzYlU0U1A2?=
 =?utf-8?B?Q1I1Unp5cWtTaTM2RWFvdWdIWjlGMXc5VlNJSEUvUnFVNndGRm5LalJOK2xP?=
 =?utf-8?B?RHYybzRta0dVNG0xc2pqR0trQzdMaWRjTHJwd0JxanowemhLcGk2c2dMUFVH?=
 =?utf-8?B?YUwxSXI5ZXZsS0w3bnEyL2hORTZNRGdRTE9yNzdjWGFRTnM1OXZ4eEdWMXl2?=
 =?utf-8?B?VHZNVjBtWHZWMnc4SVNXVW5UM0IyVkFTQW8xQmVyU2lqSGpzV3k5ZGJTeUcz?=
 =?utf-8?B?MVBWZHZZblhrSUl3c1pFblM0SWs3MzIxbi90eVh5d2dtaU1QdmFCRkNqcGxy?=
 =?utf-8?B?enViOXNmRzRDNVFEeStVN1lXQlEwL3J6Uk9hMHcrdjBiWnJ4bU1Hczl4dVFW?=
 =?utf-8?B?aUtyb2lhRmhlTXY4d25CWStnckw2dkJsTStzSitnMC9zQzFPWHFtL1Iva2F0?=
 =?utf-8?B?ZUtnelRoNWxCMzRGdjlUSEo1ZjRMS2d3bzlIQXBpMDhlcjFYRG9MTVNMSU5r?=
 =?utf-8?B?QlpFWE54Z0J1S2FKY1N5bXhoOVR4QWpnaWxxTTNtaS9EeDRhYnNEaGl1Sllo?=
 =?utf-8?B?Ri9QTys1aWt3cDRNcFNRcm1UekZMbS9EMm1VQkJpOFh4OWhhc2VhcnV6clVJ?=
 =?utf-8?B?TW42U3B6TE95ck5HVy9JMy9SWG5TaFhPN1I0NGV3TElEcVM3Vzh6RXZSMXJO?=
 =?utf-8?B?bEp0Q3A1YmtVM29RYklUa0NOV1crT3FWMUtLY1dKTjB0MVdnaDB1eFpMK0FC?=
 =?utf-8?B?N1BINDNVem05TktqaXc3Nm9ZSDBJUFR5NVdKMjBNa0JOVnVmbXdjK0ZXNEVl?=
 =?utf-8?B?cDVWaTJ4djViLzROZ1YyRnhYNjcyQVI5Wmx0R2tjN0FxMENBVGEyQWd0UXRi?=
 =?utf-8?B?QUhhVGU1djNVMXBDWFpCREswclRpZXBWQVR6aUplU29UbUpGazBMU1BiVjU3?=
 =?utf-8?B?Ry9YYXM3Y3RMTzdOcEVXRjAzQmdGdElETUNteDIwV0pXRVMxUWIwVkxIT3ow?=
 =?utf-8?Q?FenXzfaL8F/JTUhHPW5e0t0I49FMPcZslicSiJ4zlTSq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56bc868d-a134-451c-7e3b-08dde7bf6787
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2025 12:19:05.8959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKwir0t2bE2V1uDwDVsD32PnzQTlpfjE8EciJWEDdClEi6Tml5gR8mE1CwEyQDqXYCElwaFZBcb+k3gqtASprA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235

On Sat Aug 30, 2025 at 4:22 AM JST, Miguel Ojeda wrote:
> Core functions like `to_result` should have good documentation.
>
> Thus improve it, including adding an example of how to perform early
> returns with it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
