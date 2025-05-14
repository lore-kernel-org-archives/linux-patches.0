Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E131B202F60
	for <patches@lists.linux.dev>; Wed, 14 May 2025 19:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747252016; cv=fail; b=ic0sXtCuPx1Sj+2hoYRdP/9/bDKAR3yCUdn3nx1Hr1/KRX5jrLdAWWG/hVoIEDUYt/qpICh4IPnvtwYpaojjUzyRlPYwG+/2XzmRS1lz1Eik0TuTrOSyYypWuLzRgWC/ogOiLoglLflDResEuEAxKQ6QDTtSf309ay1Pvahc96c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747252016; c=relaxed/simple;
	bh=ByHj+yDctN3rTEtjWXQwckYRCf4QE3CrtHoFznEb6YE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N5lOixzamZGggliMdS2OyDEJbepi+P7JLEDd9DbCsmAPEMYIxx40uBSGbEQYTo9EVx6kH7geh24WK0kDaMWajKNiK1gcH9f6tcOkDY6eRTvmjT/AytvD0ysdwBCIBgGVCn5br28yHhEHpqyVYr/hQenlNt6YftMHOS2S7TVV9So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RFeDmMcj; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RFeDmMcj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2+CA1uJT8CGjq9lOsvYJEIk9xqugjvr/XQzAO9aswa+Zi+RFUH6O7nK75GPv5U5U/D3NZqvf2da5avc+m7Ut3aUImdtnxootqNgudwY0SRPsccygstKa8W6HnHPLIxwLzVz4qvTHUER+vTtxeyCUbG5dl0DCOUJdS/ggLLJwEPbX4OdcSBZ3EBP+qa14tEkt0vMI5lfSn+dKzZytr83BeTM7nGuIQw9V23b+aObbpTdTdeY3EWS8RfS1pKA73osVbPiM7Em0dgZ/WBQyou2vMiYpM2aWD2NI3IKvzA7eG8F+wZEHUG4wQ/7XCp4PAS+LTn17eO7BrUTf1czcRId7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByHj+yDctN3rTEtjWXQwckYRCf4QE3CrtHoFznEb6YE=;
 b=UpQ0bLg+IkV6QtQF4+cfLVEoyd7ODzZQvf80JizfgdTfFSAHEzIY5of6DOOOX07J7NjvAlUwGbgV015+Io34t7Ex1rEn48R5BNTB4BKhLn5i2/hVJMbnG8WVQF9ZNG+5D6WnlhbzC//na8aW8KX2S+kDNjDyE8y2gj3s77bJ8crUnS5Da+Ub1LYW1p2Fb+mBaISQcxRlEJf59Zjk2NHQDSsww3Ou8FcZzC/jlFVK4OcxF+h/lYawM4aK8o7h9G5BNG+J0oWxngiBOhLfQsiio9WSinnLGSoi9Y5zckNrDMmV88zzwrsQbwL6lSgPwC6wPA9167auUBeweu32AIMrLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByHj+yDctN3rTEtjWXQwckYRCf4QE3CrtHoFznEb6YE=;
 b=RFeDmMcjF69hg9zT9zOnbjD3i0r8B5Yfy42mmFaM0C+hxUdYnfglvYbWQYbZrG04UGwcpsYaOzpfA/6Jc8TOFLDRuZyLQRGyUrUDXuvdEERZ11jcuOsuy9rjFHAYc7NuuSAkYwxjK0bjq5u+7jb1j9YHcR2lc8lnOx2Rtpqija4PP/DXbi8TzXc7ThZD5NMEJIBuPxBlYzCNkWLLQknKyj8XDHfrsQN7HFaA4zYvQrl72jtyWC5Y6jTNg9M818OVZxKzAsWZeaHKJzeaOoIFTN2WiB5Z5PMd8F9cCq/VnPany9Jea3AAfFZrK9rb7T8Q7xlaWt0HeNBbLdOtSnUoDA==
Received: from CY5PR12MB6526.namprd12.prod.outlook.com (2603:10b6:930:31::20)
 by IA1PR12MB6234.namprd12.prod.outlook.com (2603:10b6:208:3e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 14 May
 2025 19:46:49 +0000
Received: from CY5PR12MB6526.namprd12.prod.outlook.com
 ([fe80::e420:4e37:166:9c56]) by CY5PR12MB6526.namprd12.prod.outlook.com
 ([fe80::e420:4e37:166:9c56%5]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 19:46:49 +0000
From: Timur Tabi <ttabi@nvidia.com>
To: Joel Fernandes <joelagnelf@nvidia.com>, "jpoimboe@kernel.org"
	<jpoimboe@kernel.org>
CC: "gary@garyguo.net" <gary@garyguo.net>, "a.hindborg@kernel.org"
	<a.hindborg@kernel.org>, "ojeda@kernel.org" <ojeda@kernel.org>,
	"boqun.feng@gmail.com" <boqun.feng@gmail.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"tmgross@umich.edu" <tmgross@umich.edu>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.gaynor@gmail.com"
	<alex.gaynor@gmail.com>, "benno.lossin@proton.me" <benno.lossin@proton.me>,
	John Hubbard <jhubbard@nvidia.com>, "rust-for-linux@vger.kernel.org"
	<rust-for-linux@vger.kernel.org>, "bjorn3_gh@protonmail.com"
	<bjorn3_gh@protonmail.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"aliceryhl@google.com" <aliceryhl@google.com>, Alexandre Courbot
	<acourbot@nvidia.com>, "dakr@kernel.org" <dakr@kernel.org>, Alistair Popple
	<apopple@nvidia.com>
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Thread-Topic: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Thread-Index:
 AQHbxDH3Ep6RzftN7kiIvL2+4bJBKrPRG/KAgAAoPoCAAAXLgIAA7TOAgABJQICAAAkJAA==
Date: Wed, 14 May 2025 19:46:49 +0000
Message-ID: <554965650ac2aaa210028d495b06e1ede6aab74d.camel@nvidia.com>
References: <20250502140237.1659624-1-ojeda@kernel.org>
	 <20250502140237.1659624-2-ojeda@kernel.org>
	 <20250513180757.GA1295002@joelnvbox> <20250513215833.GA1353208@joelnvbox>
	 <38a7d3f8-3e75-4a1f-bc93-9b301330d898@nvidia.com>
	 <f4c946b2988d63a26aff2d03fe73fbfe1f52f31b.camel@nvidia.com>
	 <723f7ae8-bb36-4a4c-a1d8-733d131ca222@nvidia.com>
	 <grdfkevm4nnovdefhn7thydixjtdt2w2aybuvnrtot2jolyte3@pmvcv3vbmmll>
In-Reply-To: <grdfkevm4nnovdefhn7thydixjtdt2w2aybuvnrtot2jolyte3@pmvcv3vbmmll>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR12MB6526:EE_|IA1PR12MB6234:EE_
x-ms-office365-filtering-correlation-id: db3554ac-3141-4d09-2f1b-08dd93201139
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NWNJVDBuQllqTG1aWmZkcjAya3p4QmJ2YlpCNXR0ZVVZVkdBdDU1UEJQVE9B?=
 =?utf-8?B?N0ZqRytIMDUwdyttYlNpSDJ4dkJFZzhhdWNwcVQrUGYyZ2VSOU92VFFhMGF4?=
 =?utf-8?B?UVF3ZGZlQkxzZW5pUXQ4T1RMZTZ1UEdHZ1ZEVkdMRFh3d2pQckpVdFJCZFU1?=
 =?utf-8?B?TDBOTStFa1c0OVl5dEdnYWtSOGJQaURCUmVSVmJlVzdMSjFZK3MvQ2NnR2Iz?=
 =?utf-8?B?T0IvMEs2VEJPNkMwTHpLUGtDZkRtOGZhQUVLZFU0TEp0SGxsRHZRb0lOL0px?=
 =?utf-8?B?Zm1GemJYWkdNckRSWWNrTkdocDEwYm1vbEMwU3BmdFNYREJySjFTY0k2bHp4?=
 =?utf-8?B?aklrd2c0TEQ0bEZaTlF4M04vUzVHNDZxWG1lWENQM2x4S093blJKYVVrZTk3?=
 =?utf-8?B?Q0YxenpaQmIxZE90djczZW1LRmNtUTNiM0FDZXQwcFB4R2V1enVtT2xyN0Iv?=
 =?utf-8?B?dHNhN0JSS2hrL0p5ZGpoNUtSc2VkRXRLTzR3Mm54dW8zQjFUSlJzTkp5SWo1?=
 =?utf-8?B?dmMyUXlvbW9nSy9rNjR6d1htS2NWVjZjSFpkcjRIRmt0REdQQXAyUEcwME9I?=
 =?utf-8?B?TUM4MGFvMmhncVJhRnRaNjVNb0hGTlNhMlloSlUxaVpoUThFMzVvdy9Zc0ta?=
 =?utf-8?B?b0txQStUWjl5ZHVJM2VLNmhlODVaQlF5OW5MVWQ1RksvMExheWlKZlR1aE5w?=
 =?utf-8?B?QVViMWtqbW92Ni9uNUtRMHVrQlNWVGJmbFJDaytCTEIyQTY4dmhDRU5jSkVF?=
 =?utf-8?B?SUtpcmhCSUxtNjVKWmJsL0JIVHBKbGJ2Q3ZaTjdRUUVQbEpmNkVuY0FOcnBn?=
 =?utf-8?B?OVdYeWN1b1VUWHZ0SHF3QzlKUnVmbzRPd1IxUEJGcHpYRmxXLzJRSzBYdXlU?=
 =?utf-8?B?Z3Bta3ptbVl5Tzl3L2VsUzF5ZnFveGhSSk51K3o4RHJpSlU0dXdjb3BYRnEy?=
 =?utf-8?B?d0NzVWRnNFB5MktxUy9FUXVRbk1NYUhsOUQyYVVjWDlNNm9Icyt4ZDk1Q3FB?=
 =?utf-8?B?YWhsZ0JVL0RwczRwdEZTYURtZDBybndIdTVwcVUvL1dGajVtaW53bnB6M2xr?=
 =?utf-8?B?YTVrR21DZ0JCbEhlMnprWTNtRlMza056Wm5VOHZOVFkvYWxxV0tzai9XY2NP?=
 =?utf-8?B?UlY1ZTVhOGNBTmNROXNtYm9udHZjaTZORkVvdXR5aDVSL21QVC9yb0NaNUVp?=
 =?utf-8?B?WGJYSnRvbUlFQThxdE9PNUQvbzVDYzFYTWlKNU9PbzV0SjNpeXN1RXErOEh4?=
 =?utf-8?B?d0NZWVQyRzdQaUZiSG5CTDRVNDUrU0hSNHNxVmxZVHArQ01HZ1NMQUpoWnUr?=
 =?utf-8?B?OXg0UzFlTGVvREw2S2ZmUkRQYVJza3ZGQUpaWkdOaVZXNHBlbHdwT2E2NDc0?=
 =?utf-8?B?R1FWb2ZwUzdtNGVYYWg3N2pHUEVScWNxWit0VThzdnZEdjh0bmJMblc0SmpR?=
 =?utf-8?B?ZGZZT1RMWk1jeDhiNFZ4ZWJEUGkrRjZWRzk1ZnIyWVFReVNFUVN6MklMcWo3?=
 =?utf-8?B?VUJsclVBT3lCdWV5V3ZVRzlYcWwzeHROT3lqODgzcGZENXhVQThGWURMYWRn?=
 =?utf-8?B?TXhvQms2UWlBSTYwbDdydDhBd2s4enNaL084YlkrNUxsRWRhd0tJVk52akgx?=
 =?utf-8?B?NFBuSW5UZ3dqZHVxTWk3R1BYb09FZEY5Nk9FTngzbkY1R1lDK28zWkE0ek1Q?=
 =?utf-8?B?ODdLRDVXcnVId3pTRjYwUzRDcURQSDY3ejZiSDd0WEFzK2RCUkRTUS9vYitx?=
 =?utf-8?B?bmdSM1I1SlFVakQ4U0tNNXF2ZFFjbHhWUzJvNXhQMllxdXZSYVY3dEN4cXJT?=
 =?utf-8?B?SlF5dDVYK0FZbjZvMXVndXltMmszWlB0eWgrajQzUTQrYTJxNXpFQlJ0MTBi?=
 =?utf-8?B?TitjNXJlUXZ0U3BEaURYMjB6MkJvcjNPbStRL1JVRDRuTXoyMGVOd3kyZE13?=
 =?utf-8?B?cTFJdjI4ZGcyMHJHMmFyL1NQTjJXMTYxS0xhMDEyVHp5YXF3QytjNWN4WEUz?=
 =?utf-8?Q?VrEwGRXvQ9tQ5weSTMOoZPW5qk+UvE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6526.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z0lBODNwTXFBR0d1bStLTVlxVkwrWE0xR2x1emwxWjd5cEU2SlZ4L0hYMGgx?=
 =?utf-8?B?R3UvUFYyeGdLZEplRGRBVjVRYVo2TUVxR0FnOG9lTHd0bDY4d3N1QUZ5WGRl?=
 =?utf-8?B?aUtiK2cxcnViYjliVllCK1RrSmVZVVJSckhabUY4c1Exa3BsVUh4aXgvQWJN?=
 =?utf-8?B?cjdLcGhyaVN1RUFIaEFkWWJkQzR6ZlhFMktqVHdzczFvUUFNRldubld0OUN5?=
 =?utf-8?B?UDVtbjV1T1hkWDAzY2FycHp3UHA5ZkxNUWU2L1NuTUI2VENlZkx6QmphQUl5?=
 =?utf-8?B?K0txMGh6TXUveS9CUjIxLytPVVJzR0k1U2d6VVFvMEJ1RkgvczdmVjV4cTBP?=
 =?utf-8?B?MDAraGhXZ0R2eDJVRlNtRGxDNkpFVy9ick9YeE1IZmdrZXB2NDBGbXpTYlBQ?=
 =?utf-8?B?SHZKdjBJRGxYa08wclJKbkVsei9Nb05LQ3lFbU1Rck1YYjM3OGZXR1ZOYi9l?=
 =?utf-8?B?Zkx2eitKZXczUW1ZYlBYZzV2elV4RFRJL0daYkJwZ0hLeGtXYldHVHhxMVlF?=
 =?utf-8?B?SFQxNFZ2NkxJdEtHUW1wSDNrRjBYVEJvcGVJTlh3cWh2NEhOTXBoRGNSTzFX?=
 =?utf-8?B?T0lOM21kUGdkM3Mzb0hoQVc5NXM0Y2ZzSzZGWGlBL0RNeExDR2VkSmJmKzFQ?=
 =?utf-8?B?WlpRYkE4ejlrWUx4NVRHaUc3czB2d0x6MmkzTjhwNCtFL3orUVBJdGxwaUFo?=
 =?utf-8?B?dWpzWEF4YjY1bWRSbjlqZmtyTWdObWNoeTZVMktrT0pIUTRmMTFnRE55eSty?=
 =?utf-8?B?dkZqMzlvOUQzK2hZWktQR0NpaVZmT2R4cExiVFlEai9kNGNBVFlOYm1VRXpU?=
 =?utf-8?B?andZMG9pWk9KZyt6c2tpZ1hKa2ZSb05yaEd4eitvaWhrVkdGYjdyMXR6K0RB?=
 =?utf-8?B?c24vcHpQL3VlRjdpQ2xiUWwxVEdVRjR3a3pYeXRYWmF0MkhrVTRXdzhhNldz?=
 =?utf-8?B?MnJQbWdQSGNhelc3VmlDK0lBdTZDWlFBTHJJdXVYWTM4dUw0ekJZenA5SHRD?=
 =?utf-8?B?V3hXLzV6Y04wVkUrdjJMd2RWTlVhRzFiZk1zNzNxVGtHbTFGRkZkUlJVS3Rx?=
 =?utf-8?B?SFA0UXI4djM3bENVbS9wV0RnUTl1MUNURkZsRXV2cVhBN3Q5ZWhsdVNQUXFJ?=
 =?utf-8?B?c1VZMlEyc2p0QzV5clRSakRzRDRNUUFpMVQ1UkhqWUhiWmwvTFdUbEttYVJK?=
 =?utf-8?B?d1Z5bngxS3g4UUJucHpPMWx6c0lvNWNXa043U0czRnErNDBSWlZEMnlJM1Rp?=
 =?utf-8?B?UTBrcGVlcGxBWm9SRHU3NE1DZGUveTFxVW9lZXZ4eEJGQmNhMlR4T2UwSWhq?=
 =?utf-8?B?OU9oRml4OFhtYU0zUW5pTTAyY3NUSi80NTBhQmg3RFlEdzR4Q1pZTndXWWpi?=
 =?utf-8?B?Zk03YWoxTXliUWRKTURsVEtuMmdDWk5DSVdIUGZTN2tRVEJPVWp6eFVESHJj?=
 =?utf-8?B?WU9obEY4dzV5a3cxTTdtTVE2UmVRRFdzTUl3ekJrRTJnWWJrcUZURmdNem9C?=
 =?utf-8?B?MitJMVMrL01Hd3JmcjZ1ZTg5cEpuOUE3Q0kwZWRjOVVEQVZJWjkvRmE2TFRK?=
 =?utf-8?B?MkZrRStKeUdyYjBBYzB0bEhQUzNZS3h1U3ptWXh1TUhqQ1dRWlZWR2N5cjF4?=
 =?utf-8?B?Zk4wek9sV1M2RTBJVkZlUmlVcTZVMy9MMURNNXVMQ2c5VjRSZ01BYkFtTUdY?=
 =?utf-8?B?cnFGZlpzS0t0SkxOOFBpMGNsbmVDUG90SHA5R2hZYWdRaFE5aFk3Mk9xU1Ni?=
 =?utf-8?B?WlVxVm9HdGg0cW45TjZ6KzRaczFaN0M0dDNSc3hSbUhmT2FCdFRMMFNOckdW?=
 =?utf-8?B?Z2RhN3VzUFdJUVFGNVJ1Z2NwWUszMUh5TzZNVUNwZ3NWc3ZMZmZ0N2hHeHF4?=
 =?utf-8?B?bmE1ODRxRTdaRHRISVBMcDBHN0M3aVZ4QjBHTmFDOEcyanZOUEJhNVlXK2Q4?=
 =?utf-8?B?T1d0UXAxMHdYanBMOXVpaEwxekxzNEVyemk4eko1VWpmR1BycDJSb3h0TEcw?=
 =?utf-8?B?UTJxbW83RS84ZnE4ZTFMSGFSTmlOK05hNG1vSlJZOHliL0hMNGlZQW92Mnla?=
 =?utf-8?B?WUdqTXF4WlpiTGhyUjZvdnYzSWNXc3hyd0VROEtIekVnRklXcEd5eWtKYytl?=
 =?utf-8?Q?eBdGeWv9qbRS4wOyaRfsQ/z/s?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BD9861EB1421546974039BF595AE0C2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6526.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3554ac-3141-4d09-2f1b-08dd93201139
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 19:46:49.3163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rz85jl6UYevI1yU2/gkivseQoBp5iBoFi/09XnZHHvYeljdbHmav4fCpORmbjlusrJlGQfLp3mTpDunSHDQOaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6234

T24gV2VkLCAyMDI1LTA1LTE0IGF0IDEyOjE0IC0wNzAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gVGhlIGFib3ZlIHdhcm5pbmcgaXMgaW4gY29tcGxldGVseSBkaWZmZXJlbnQgY29kZSBmcm9t
IHRoZSBSdXN0IG9uZSwgc28NCj4gdGhleSdyZSBsaWtlbHkgdW5yZWxhdGVkLg0KDQpUcnVlLCBi
dXQgdGhlIGZhbGwtdGhyb3VnaCBpcyBib2d1cyBpbiB0aGUgQyBjb2RlIGFzIHdlbGwuDQoNCj4g
VGhlIGZhbGx0aHJvdWdoIHdhcm5pbmdzIGFyZSB0eXBpY2FsbHkgY2F1c2VkIGJ5IGVpdGhlciBD
bGFuZyB1bmRlZmluZWQNCj4gYmVoYXZpb3IgKHVzdWFsbHkgcG90ZW50aWFsIGRpdmlkZSBieSB6
ZXJvIG9yIG5lZ2F0aXZlIHNoaWZ0KSwgb3IgYSBjYWxsDQo+IHRvIGFuIHVuYW5ub3RhdGVkIG5v
cmV0dXJuIGZ1bmN0aW9uLg0KPiANCj4gVGltdXIsIGNhbiB5b3Ugc2hhcmUgeW91ciAuY29uZmln
IGFuZCBjb21waWxlciB2ZXJzaW9uPw0KDQouY29uZmlnOiBodHRwczovL3Bhc3RlYmluLmNvbS9p
bkRIZm1iRw0KDQp0dGFiaUB0dGFiaTp+JCBsbHZtLWNvbmZpZyAtLXZlcnNpb24NCjE4LjEuMw0K
dHRhYmlAdHRhYmk6fiQgZ2NjIC0tdmVyc2lvbg0KZ2NjIChVYnVudHUgMTQuMi4wLTR1YnVudHUy
fjI0LjA0KSAxNC4yLjANCg0KU2luY2UgSSBidWlsZCB3aXRoIExMVk09MSwgSSdtIGFzc3VtaW5n
IHRoZSBhbnN3ZXIgaXMgMTguMS4zDQo=
