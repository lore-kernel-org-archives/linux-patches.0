Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2055.outbound.protection.outlook.com [40.107.96.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A628488
	for <patches@lists.linux.dev>; Wed, 14 May 2025 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747234346; cv=fail; b=e74SezpiMD7cwimaUxzYRtUQzV63l8yVHwPI8EFlBRNMlbFpwN1WYLt1oMgIZScok9uH5yIyNrwUSRsHH7I64UlolomjCglQlkQdkxZEl1cz12/uTCtGkbKLzu7YqEbmqd6EA8B7JTek23TaRn6L6jJuClPUZbd/kJEMspxVf+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747234346; c=relaxed/simple;
	bh=tYNATAuLNjTIXDLVKgMhfJ1yAVoGg2avLxMV2OfYxag=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rOzIjay5zlx6uH0djL3NAg7r7Vv2bOaYJIzUmzMLDHyx6aWbnRQaBhwir36fR0Y1coAVXX6UVfL/LcMi5OOVTYQkZ4pBdb91ZkrTc3NtPTKfEBkm5QBydICROFHu9qn44QNobmcvMrLUIa3Nl91+6qGO9j0d3DG++f7jsLXdr10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=of6RfwKv; arc=fail smtp.client-ip=40.107.96.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="of6RfwKv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3rWi/ryZuAFzbrRaJwXnvWJdU/7hDkeCD5jnj9XWfVmPNZAZPTKUkgM5zDxMHGEuTV4qqQlslqi2b4tux2H85fQUrSIK5L5nEdfGg3T/ahb5daW//EtVnlE6eqRUsZ6p9YoIJIAB4uxOwDahZVaDXLWL19HcaZ44u8/od42j55+Aivj8YFyNgg8j+gSCstTw//vD7CVUSN31hf/qKyamIVmFuktV4w8660cj6o0lTz9dyUeWjpcWlPVuTso2pbBA7BVvQKLHnYnHN6HajoxmZjVGqtSzloQAsrG3PLOoyOIZigQHATFnSHBxaVoclWrQuKeVxEjshv2EoYWkbcvrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0usi5mwyVn8h7URpBr/ewDyc07+DZ0ToMsz+X3HoxnI=;
 b=CPJoKi9lmuCSrb78ocWdcevDYLOcZP0nwrHSdl3UanAqWI7eFP0FqBlKG1wpxkxzucq5yYyoK1N9ZJVgZUmUGGx/yFVnGvwBGo+NeAfJCJhYlhdT/TpVIpx9CRuQeoSvwHOG86NOM5gU1q8HQ+bYEq1FO4s1fuwHVCI1okMRCpuqyj8JOC8R6lqZ4jfDaW3Vy27N7dQaMIUsLYYDDWTWj+QZNA7dztxuQOl+aS40WVVu8UPwc20oNwBDjJZq//dVbWPw0NJsCJEFlaC6wzLJs6ha6qKuT7l7heTkXUlexUyI5UMyt1XHR0AO44xHn1n7z0k1MYvPB0M7eVYbDQWS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0usi5mwyVn8h7URpBr/ewDyc07+DZ0ToMsz+X3HoxnI=;
 b=of6RfwKvuvEM2Fvd8Q5L1EbgthUMUu9FZg5vrhfdhmNs1xOpgiFxXrEsvlSf1pNoGjjGUpcRc7Zd/S4HWVPhjoaYJfdjj2lG5439zV5j948kbMYLJ+hkHgfE1APMv8+g1dv8m+b3VUopTKhn2hdTrWLQUE4cLckIKG6ipA+RZm2sU5H1wIjNRjukujtAfm2bCAlNfyTh58tZHFGklHTMKNmroE3emjcAqcuOTmYokt42COpR4OKcghvvCiVyOUmdmB4t00yNW6sBSqaLLcY11RkBQY41qqxmemMc6NhpRag8zIHSME6j0ZlcFnv3uRXZFnZbOnuyNInFhbV7qwURkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by SA3PR12MB9227.namprd12.prod.outlook.com (2603:10b6:806:398::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 14:52:21 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%3]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 14:52:21 +0000
Message-ID: <723f7ae8-bb36-4a4c-a1d8-733d131ca222@nvidia.com>
Date: Wed, 14 May 2025 10:52:17 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
To: Timur Tabi <ttabi@nvidia.com>, "ojeda@kernel.org" <ojeda@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>
Cc: "dakr@kernel.org" <dakr@kernel.org>,
 "a.hindborg@kernel.org" <a.hindborg@kernel.org>,
 "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
 "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "tmgross@umich.edu" <tmgross@umich.edu>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "alex.gaynor@gmail.com" <alex.gaynor@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "benno.lossin@proton.me" <benno.lossin@proton.me>,
 "rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>,
 "bjorn3_gh@protonmail.com" <bjorn3_gh@protonmail.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "aliceryhl@google.com" <aliceryhl@google.com>,
 Alexandre Courbot <acourbot@nvidia.com>, "gary@garyguo.net"
 <gary@garyguo.net>, Alistair Popple <apopple@nvidia.com>
References: <20250502140237.1659624-1-ojeda@kernel.org>
 <20250502140237.1659624-2-ojeda@kernel.org>
 <20250513180757.GA1295002@joelnvbox> <20250513215833.GA1353208@joelnvbox>
 <38a7d3f8-3e75-4a1f-bc93-9b301330d898@nvidia.com>
 <f4c946b2988d63a26aff2d03fe73fbfe1f52f31b.camel@nvidia.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <f4c946b2988d63a26aff2d03fe73fbfe1f52f31b.camel@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0713.namprd03.prod.outlook.com
 (2603:10b6:408:ef::28) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|SA3PR12MB9227:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cdb8b62-b701-48aa-a288-08dd92f6edf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmhoQ0MwK1h0eEpkMkQzTEYzM3p3U2FDeEtwR1FRT2RhdFRRSVpzYVZiZ0Vz?=
 =?utf-8?B?UVRWOXBGK04vNExiK01hRHJMUHBwSDcwSWNlMlVmMWpQZ2Z2TE1Jdm9iMHli?=
 =?utf-8?B?RmhkaUh2YUNnQWJsQnBtSEJhV01PTzNNL0dVK2ozcmRzWU1TZ3pGbjdoN3hr?=
 =?utf-8?B?WWtRR1hNSDhkT0xCcFVLdUF3NmhzZ01BOUFhYld6eTBOU09IbHpnUjQrcjZj?=
 =?utf-8?B?bk9kc0RtYzZFNGRhWWN0K2FLdTE4dk9seXIxb1FYWmtZWHR4c0lFRUN4czZS?=
 =?utf-8?B?YVRqLzZxUXNnM2M0N1NGRi9vcnhMM2c5M0Q1bGxWOXZPL0F6cWh5eFdWNitW?=
 =?utf-8?B?T08zcVVLOURHeTY4ZExlQm5qQkY3d21aalR3NXNmVlloanRKaWl6ZTV6Mlk5?=
 =?utf-8?B?Tm93bUs4YndZcTEyYUN6WWVvWHFWSEJuVGcrbTZkMlNCSkl5ZmJLaEx4eXUz?=
 =?utf-8?B?U1I5SHAwKzc3S3kvViszTjR2YTB6aTVjWUtvNzh4d2RJclBHNjFJeEZLWTlP?=
 =?utf-8?B?L0YrZ1VCVi8rckpUZ202TzVnbzBxcHhOWWI5Q3g1S0pocEhUR1RFMS9RVzQr?=
 =?utf-8?B?WGlIeTE3djNzU3czbXlyQ1pWem0zN1dPK2NhbndLT1p0RnJXN0YyRFdsdTMr?=
 =?utf-8?B?dXJDeFQrV0NFRFhoelVCNnpieWFid1VDNUtxRS9yVlRiZzkzTVlWY3FSejVQ?=
 =?utf-8?B?OCtBNENMdW9HdytVNEhLRTZQNThJdlN5Y1JTbDJ6WGpSVng0NThuOXFub0R2?=
 =?utf-8?B?WFRKazJkQWZLZmtHemZWWGdTd0RQOGJkWTlkSFRKYnFEMTQrTGc2aGhsWnRy?=
 =?utf-8?B?MzlhTGErblowR1N3R2kyS3NZN3Zmcmd5K0VWSkZ3L1FqVEc1TUpBK3VVVW1z?=
 =?utf-8?B?TXRKaDE5ajhZZGFBVE1rL0lhaUIwYm84b3ZSSzhLNmNEa0RnNFhjRGNNb2ta?=
 =?utf-8?B?bmdOZVpQajhDWEhGZ1pwZEphS3dJcUovcWJRUU5OT3E5SEFObEpYMlhnUnor?=
 =?utf-8?B?VThVcGU3cDNON0xaMTNMWFR5SEpYSytRSWFzS3kxbkRYOURPMUVxczFnaFQv?=
 =?utf-8?B?K1FnSGpSQ0w4WTJGZnBhdWtWcDlzT2ZWRmFVT0NxbGpZZGxEQ1o0UndpRUUy?=
 =?utf-8?B?TnlDNXdmY2RCaFFaYUwxeDR2bE9sNFBPVnlKNDZOODRxcHNPeTBLVVdjdW1X?=
 =?utf-8?B?WXRsc1pBcHQ3YXhta0t1S1o3MW1RT2w5aXB5UC9zQWx0MGpsbzczMnpvUTBo?=
 =?utf-8?B?VGJjZUY3MHlsMVc4Tm5mYlhXUDdpb1BlMzZZUU5reG44bUlsd2JyTkJBMG1r?=
 =?utf-8?B?L3ZXTFI3NDVkeTdDd3Z3OEJkQUdKUXlidXhxZFkrcWc4UmRJc2hIOElNRW1h?=
 =?utf-8?B?SW1YS3hzWHFpVG5zcVo0alhuYmhtWjZSZ0tVK0swRTZWWi9KcTJvc2ZzVmR6?=
 =?utf-8?B?dzF1WmVnTmIwdlpGa0FaUk5vNXp1MUZKZk1WRGFhSnFPZUdrZXVUTUw1RXE0?=
 =?utf-8?B?eERBbjZOWU9Jc3dwTnRIMXV1b1ZyTG1yVVhqTHlsdEI2UVV1M2FPcFlsbHpM?=
 =?utf-8?B?Tm1vazRnTGR5L25ScTJMcXJNM3lnaW56ZjRrekJtRUFJaHZqem1LcWFsanBx?=
 =?utf-8?B?NEN1VmRrMUU5bk81REcvbEFLOGVzQTNQOGRHRVZJbzkrZzl5M09SR01SaHlv?=
 =?utf-8?B?cUxXQlRtYng3K0dXMEdWbHpVT0FOcTd3bmRTZHZSbGQwazQ5U1J5ZmFXak83?=
 =?utf-8?B?Q2MrS0JMdkYzcnJ1Q3F3SVFFQzA5ak15SEhYVldwSGh0ZzFzUjhYVUVxQzd4?=
 =?utf-8?B?M045anlVTEp5VTB3TTRPd2ViN3pzTWFDQzR1Z2R3SURiQUFxNkFqc0J1enNK?=
 =?utf-8?B?Yitia0lXcWh4OHhseTl6UWsxdkdZbVdiTjBJT2lvNU92VlFPSGVtZ0ZtWUI5?=
 =?utf-8?Q?+6yuqAoJenQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkxzZ1pzd2FpZ200MGZ0M1F4dUxON2xoTVBtMlYwV1NzNktON3h3aEhGS00r?=
 =?utf-8?B?MGxHM0xVSmpuTmNSUW5qVkRhb0FwdGRqZG5rUGVVZXY4NjNpeTRqdkJDVnV2?=
 =?utf-8?B?Sjd6VHM2VnAvTjdyd0NCWUd1bVRFblV3cHJxZmFWUTVZOEhDMmVlYlArY3lF?=
 =?utf-8?B?K1BvSDZDRzVNZGlsSkhNdk5GRHJOYkd1bGpLQ0Z0L2h0d1RHTmt0VktKa3lH?=
 =?utf-8?B?R1U1NUZnbGlOaUhZZXhBNm01djU3UTEzcVFGV2tIQ3l4czZuZ3FPVWluV3Qv?=
 =?utf-8?B?SGh5MGFGazN0MnZnREs4OVVkSjM1Qm9CVmk5MHROeEk2dnZadTNLNDdYbVdr?=
 =?utf-8?B?aHZHNS9maXl3c0hJWm9RWWNCY3cyZW9WWEc0Y1lPOVB2YkpMQUo1bkRlcjc5?=
 =?utf-8?B?N00vZUpBenQzd3hGaEVuK3RnN1N5cUlDOWw0amdhRXAvUE9CUHlaOU9kaitj?=
 =?utf-8?B?QmpYVUR4Vld3SENjYTdoTHFMeTlIWWowRWlqbEtSR3QrUWxJMjJ0Znc5UjZD?=
 =?utf-8?B?YSsyT2hrSmU3SEsyS2RPakZBR1BKOVg2Q3RRNUhyWktaSDFKeVpXUVR0S0Vw?=
 =?utf-8?B?UDFiR2RpZE1lVEluKzZ4SUs1d3AralR0NnpLS3V5cGVNbStyMjdQWVpRbUtj?=
 =?utf-8?B?UWhIU3pRSHBqZ1pYeXFsMDJxOFc4aWtuY1FyWThLaUhGQytQV1RkY0dKYVVx?=
 =?utf-8?B?ZURUaWZKVU16NktHR1QrdmgvK1U3cUF1TmZXL3pkQWhDdWVLUnhhNWttNmNa?=
 =?utf-8?B?T3dTV0psVEhTQ1VRV2svMWU4Nm4wQ3VvRkRXV0lUMHdFeWJraGZPcGRmNzFs?=
 =?utf-8?B?MjBjMGtiRko3MkhyYkUxWGU0UVVFdFlLa3ZPeU9ZbjVxTkQ4eWd2ckZaNVZ3?=
 =?utf-8?B?MmpocVlBMk9tSUZhNWMxQ0ppVk9keWUzaTUyK2RPVmNGMkFrazNXSW9zVGR5?=
 =?utf-8?B?OGJNTVdvZVh4dkZUSjZTQVA0c2g5Y1NTUkFMY3d2azlTU1FxZ0lUSWJhb2VM?=
 =?utf-8?B?WlpZb1JqdUpFK0xEbXdjbVVqSkhwaGcvelYxY1ZiYkNhNmhCWVhUdm51b0ZU?=
 =?utf-8?B?clByYU50WGF1T0dRMlg1d3pyeWhIdkFBNXFSS0I2bzFBY000VU9TRlBMNENi?=
 =?utf-8?B?ZERhZi9Tbjk2bkRaMVNUK0dlYmVpOGNaZkFxQ1I5TmlrT00zQlVZcDZkdXo4?=
 =?utf-8?B?WlZKVktsMnFTNGZmMFpUQVU4dFFDZGF1TXZDUW91RXNxWG04V3AwT3VPb2Uz?=
 =?utf-8?B?N1NGeERZQ3F0YWVZMWVEaHM3eFlJREozcWhTa0lrRm9CMXc2SUhvVEppcVhu?=
 =?utf-8?B?bmVzZEZWOXBVL0EwR3loZDdQMkswOStXeUNMdFgyQllibjJuY0xJU3J4SEdZ?=
 =?utf-8?B?aDJGMnJCV1JCbUQ1TlV1dXNiaFl3WlJLdnNQTlh6NTZraDMwcnZOdXc3aFZq?=
 =?utf-8?B?NUNsT3o5ODRjRVBBSHAxZ2Z6WHZCRjB2eFo3Z0xRN25nY0ErWXpEMVpLMjA5?=
 =?utf-8?B?alZSOUQzSC9zWVRRQXFoYXlSaVUrVU1XTmxrTHQxc3d6TkIvZGhZWHJtVEJ6?=
 =?utf-8?B?VW9YRFA2YXQwejNHeU1yWlVPSDJvQURpWHJVTzVUMEloTmFnWnNWem1yczVq?=
 =?utf-8?B?K3VWQ1VhdDJUalEzLzVWMkZJVGpsL1Yyam9BYkdoRHkzeVNXK2lkMHAyS2Y1?=
 =?utf-8?B?V3NQR0FVZjExenoyV0tGbW9iTnppTy83SlZodUpTYWlreUs3emNCS1o3WmN2?=
 =?utf-8?B?N1BHcmRqd0pkdUhDNEJ0eU1PSG9oR1d5d004dGd2eUtjSS9XODJaNnUvd0RW?=
 =?utf-8?B?bWVyYlBva1ZZUldFMm8yWUdZL0pGUmhZcUF4cUlRcGpuWWlmZjNsdXlsTVpo?=
 =?utf-8?B?ZE5rS3VoMGxad2QyK215SEI5Nk05SXRJcW5vTm5PNG13ckZBbUZQdm9aZUQx?=
 =?utf-8?B?Yk5wZ1BrNGw4M2xNY1cxc0JDL3dIY3ZobEFmemRteFVQR3VHMWFqbDl3VG9D?=
 =?utf-8?B?WTZYRnJ6YlF0dzVBWlBoMGlBM3FvUWtwVGd2amNZK2V4UDYxcndHRmV6aVNt?=
 =?utf-8?B?TFgxZXQySGxyN0xJV3gzSGYwK1ZheE5FUXN3OG1CUHV2ZGY3elNib1pFSWJZ?=
 =?utf-8?Q?iA2rkZ8kFkYigpv7wXvumxNO3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cdb8b62-b701-48aa-a288-08dd92f6edf3
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 14:52:21.1122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzAzJiKFj0wt+HruMc1/5tjk4BZPHtIRjyKYPjUpJxtTdI/kk9qX93OPCr6M96BZIXFsjfR75m8djXo9cEWTlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9227



On 5/13/2025 8:43 PM, Timur Tabi wrote:
> On Tue, 2025-05-13 at 17:22 -0700, John Hubbard wrote:
>> On 5/13/25 2:58 PM, Joel Fernandes wrote:
>>> On Tue, May 13, 2025 at 02:07:57PM -0400, Joel Fernandes wrote:
>>>> On Fri, May 02, 2025 at 04:02:33PM +0200, Miguel Ojeda wrote:
>>>>> Starting with Rust 1.87.0 (expected 2025-05-15), `objtool` may report:
>> ...
>>> Btw, Danilo mentioned to me the latest Rust compiler (1.86?) does not give
>>> this warning for that patch.
>>
>> I'm sorry to burst this happy bubble, but I just upgraded to rustc 1.86 and did
>> a clean build, and I *am* setting these warnings:
> 
> I see these warnings with .c code also:
> 
>   CHK     kernel/kheaders_data.tar.xz
> drivers/media/pci/solo6x10/solo6x10-tw28.o: error: objtool: tw28_set_ctrl_val() falls through to
> next function tw28_get_ctrl_val()
> make[9]: *** [scripts/Makefile.build:203: drivers/media/pci/solo6x10/solo6x10-tw28.o] Error 1
> 
> I think it's an objtool bug and not a rustc bug.

Thanks John and Timur.
And sigh, fwiw I pulled the latest rust nightly build and I see the warning as well:

rustc --version
rustc 1.89.0-nightly (414482f6a 2025-05-13)

I am leaning more towards Timur's opinion that this is more than likely an
objtool issue.

 - Joel

