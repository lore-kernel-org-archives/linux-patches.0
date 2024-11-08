Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4EE61FFE
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731049281; cv=fail; b=dVN0kq7w1DxgSKhP8v8Tt5OkMjkIw88URL46gLXEVFIP6zTzDCwOs2y0roMHz5q8odK5kxW1NePop0IT6MUhXM4zmWjA4Wt4UFedFnedVTcuD8nr4lKYcLfS8qezq7sCcWko1aGgPr9oF8QZRHJrfS7DcLrSoDR5oWKi0cNLRnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731049281; c=relaxed/simple;
	bh=8U/FKbrcyhVWbS2qzQwzboTG0vwj8LRVzR1rfEneBxc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aozA7cc3HJS4cC/mhsMji6dSvdsbd3appf+52Ta1nek1pt17oGrakA5tdH5xSX/foz4mlMdZa2kelF7X2DUyTh8AIgAoFQKbMFg0pRtIApbYKT7mBxCcIOv6rTv/ytJ5mlzXRbuyRTHEVIluZ7UfSjqVQ+hdAN71RuEvPuMXHO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=dPMNnvC8; arc=fail smtp.client-ip=40.107.21.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="dPMNnvC8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y10StF3H+d29s6LMnMZTkZ5MiU5arHndsy8UdDmo7TpQl3vAvBRFo3TNNxFV1kIsjVnsBXM/k4CDuxccD46kG8xFlcVGU4fimYdXUvUxS6mNhZD9Qs8iLwWgNBrrDwyRv3X+z1cX1wkW4CDTLuIVOYyGfoPzLVaqNzZNrB/cVR607XUGAcV/6n3zERbZH4L7NT2XPCf4A5DWrN6rpJ+567hKw3rlm8K/Ry8Laszt1ahkW6qq8Lgy/KNRaUFGYAHI6ulXymRNaFBDq2dIZ9CMBVELSWtaTqsLK85eqeKjg2ANsaNxNLbUsj8dqx3tOCUJk4OP6Og73//I10hOnpDjdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vt4ZdmuVgl/FEEQ5zXvzh+ISBTp1LthDFaPhJOOzgfU=;
 b=f3ow5HMDQiflk8bYQGw9BmyJxUFFjT9uJ2BtBj3DG8Xth4eW/4F/6CqDSwLqbEmmodgtrDfTIkqNRY6gpSrQpN6YZQ9ikvMeZ+hruDrYj36Ud0qtAZ6LTEgFNMkyMzCCW5D4fi9jC27YfituyJvfYBI6SVJzx04RzZpBAWOEz/ZFJpKNmkwJdp7yEl9J9DJEsX4BQjjRpy65bOVlVZnk/RItgnLH4QI9N5oXnzzJtmNOafcjWB35Yow0Wl0Sso6xh76RpkFplPkSGfQodafdICx5G5OH+m3lyif6R1h9/1OnpFFEpY0QTRGRnwWM8lY+X3Ef0z86VoA7gVM2PvUcnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt4ZdmuVgl/FEEQ5zXvzh+ISBTp1LthDFaPhJOOzgfU=;
 b=dPMNnvC8zK8qQJmFFvfHHRQ//J5snIH0B6nGQ128HTNJhJOtCaKR7/WmLTwrKkOwc3RXFoPWmb4QvRIFPhOO6KF0MdzCavePGfmKbEw+DuF4MEmWloxvgfArjZqiCkDaDiE7X6E18gez2adyvT4RP5CiZXIXje7Jx6jWNnm7zdk8zfeTdKTJZccn6d/IjPWR3e74u1p8oYuQyH3B7sIC0PoDyL85WPqlmUdc5AYW3RJ/PecBwzKvjbHsJVL2lyedRqJhmzsO7R/zy3nu7j2mE0/MZip1PkyQiyRYaZfI3OAINakFUilQqlJ141TbXLrL/e1BpTn1QmpWSoJn1LSeyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:588::19)
 by AS8PR10MB7255.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:618::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.15; Fri, 8 Nov
 2024 07:01:15 +0000
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8fe1:7e71:cf4a:7408]) by AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8fe1:7e71:cf4a:7408%5]) with mapi id 15.20.8137.018; Fri, 8 Nov 2024
 07:01:15 +0000
Message-ID: <358ba32f-99f6-4a60-a25f-922a9b2273d2@siemens.com>
Date: Fri, 8 Nov 2024 08:01:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 030/245] igb: Disable threaded IRQ for igb_msix_other
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Wander Lairson Costa <wander@redhat.com>,
 Yuying Ma <yuma@redhat.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Rafal Romanowski <rafal.romanowski@intel.com>,
 Jacob Keller <jacob.e.keller@intel.com>, Simon Horman <horms@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Florian Bezdeka <florian.bezdeka@siemens.com>
References: <20241106120319.234238499@linuxfoundation.org>
 <20241106120319.970840571@linuxfoundation.org>
From: Jan Kiszka <jan.kiszka@siemens.com>
Content-Language: en-US
Autocrypt: addr=jan.kiszka@siemens.com; keydata=
 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
In-Reply-To: <20241106120319.970840571@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0207.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::16) To AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:588::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR10MB6181:EE_|AS8PR10MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: a6a02c25-178d-434d-bf06-08dcffc3230d
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDVDeE5yd3p4UjJmQUdmV3RKSkFNcjN1bm9WOVMyLyttQTluY2U0V012RHlO?=
 =?utf-8?B?bmEzY1lHSUd6NG5DbkVTVUgyWXhJMVZvQjRaVStTOWdabmhVUzI4aDBGNWNt?=
 =?utf-8?B?RDRBVHdaZnRuQ2FCMDVHOFlFVUZPdUVxR2VjZWtvcDQzZGtkczhJcTJBSDZZ?=
 =?utf-8?B?aldsYjUzc0JwTzlxQWpUR0hicEgxU0h6RVQ1NUd5YjV3ZTRaRUdxakh0eGVS?=
 =?utf-8?B?T3h4c3h2WER5SWNSQTZ5TlF1SERlNGRwOFNsTnBpK0huZFRtNUJyV2NCY3Av?=
 =?utf-8?B?UTVVaUswMjBUdS9QL01HOXViQ08xVGZLbTJ4ZVByNHUwakRITE0ydFBCTHJ1?=
 =?utf-8?B?UlR5MWNaSm02ajNDb0FSZGlRa0pqOFJQb3JTMy84VXNWVThlUWxsUFM4ZGVi?=
 =?utf-8?B?QXE4Qmh2b1ByMlU0QmdSYXNWR0VSTWJCN2IxU21uZGViRDczbzJuZjBPd05m?=
 =?utf-8?B?TkdQY1Y5bU5SQTRHRDNGWjJPTm9mZmFIOVNTTitxUTBkMDlRbCtiWUZpYmh0?=
 =?utf-8?B?TENYb216OGJoU2NQSU5GdGowK0x0OTJXOTVqN05YaVIxMEh2N0c5REQrRUsx?=
 =?utf-8?B?QldxWGhsUUw2SW1XTmVBKzluMWxxYjIzMmR4UjBTWUtvdzNMYnR4c2lwUXhY?=
 =?utf-8?B?cXJEZDgxRlgrSnVlK292WHlRaGN4c0ZmV0RPN3VFb09rUEhrTE0vbkprVkVz?=
 =?utf-8?B?a1JLZGdmS0RjTXdrYmE5NEs2M3dUUUZmeW9LQ3BpNDNqcXNWQ0lOT3YzRkN0?=
 =?utf-8?B?YndaSDBBSUZ3a2g5czVjdUE0Q0plU0VQdmNzMWZ0ZjQxdllGdEMzNGZVRzNQ?=
 =?utf-8?B?T3dnUHlGbFZ0Rk12Y09CeUFKbDRJMlVEZzRTY1FQZWRSYWMzZlQyUEdCV1lL?=
 =?utf-8?B?UlBiY2U4blRXU2xSME54SzM3K0FwbDl4UWZ1UVEzV05JM2l2TEYwMkk5NTR0?=
 =?utf-8?B?V0JzUWNYdmZQK1dRenNIRkJVMTJaM0haS3ZGb29lMjh6RXFFaE9YcUtNN2lX?=
 =?utf-8?B?ayt2bXBzanoyeTE5b3BvaE5DWHhweXhGVitVVC9odnpLc0dVYkRXOWcwTkl1?=
 =?utf-8?B?TS9ycjFjTEFIUWNaaGd1RHBnOUxIWmhjK1pXQWltK2xiNU84a1B1N3NPQitF?=
 =?utf-8?B?c3ZsajM5RHlGY2w3TWhHSEdwTWx3ZUwvcVNJRU5FbUZyNDhzR0cvb3VEMUpr?=
 =?utf-8?B?ZUdnN1hidnROMXB3ekFiUnBNTEVWMTlud21oR0toOUZyL2p1b3V4VlYxd3ll?=
 =?utf-8?B?a2Fnc3cwOU84V3NnZ3JsSitTb2EwWDE0M251TFhabzdleU85bmEwbTk1STBz?=
 =?utf-8?B?ZTZscGMvVWx3ejVYOEcxbk5Xc042RXhXNUtZNmpzYVltYUFrVjBlRVdEVnhy?=
 =?utf-8?B?dUNteHJmRDNRSU5haFgwZk5JRWIxMUpxTVc5K09jV3JHK2p6SHltUjdnOXU3?=
 =?utf-8?B?MG92aVR3Tk1iWVowRFVXQXUwcmZVUEViMXlBdVRzUTd4MjdVMzRSYVZKeG4w?=
 =?utf-8?B?VzhjbHFwTm0vcGRiRW9lUmJSMkJTZXEwS0lYVk5mOThDY1RRUkhZYUpqdUhk?=
 =?utf-8?B?RlFOcHVkQmZXQXRWbEpwVDdRY1NlbzV5ZWs2ZFFXZGt4eG00dWhpTXJ5RTdL?=
 =?utf-8?B?NVVjZFFiczFINXRybHRUNHl6MmhnYTFHQ0FRNTFVVThLTEpocktxcEN0REpk?=
 =?utf-8?B?alFKaHZxMXZndFR3UXpod2RQNFkzeXlQZzFiRmlkV25ZdFRxRXBFZ3VyYS9j?=
 =?utf-8?Q?l55KayaDDQLbqgCDlpZzopTOZGROaBSi76Px7SV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUNTM2pJK0NJK3JzTzEyb2tMNlhOZ1FXanNnRFJpMkF3dE1UTHJXUzJkcDVy?=
 =?utf-8?B?QVhtcXFOSXFWOFNKd3RwcFFwaDlyQmNQRE9nSWdPTXE4a2tVVVVDNXF4cVF5?=
 =?utf-8?B?YTNqM1BKbmptcWRYQmVEOFljUlgyRmNXWXVabG5EdysxYmlHZ1NzUTN1VmxF?=
 =?utf-8?B?UStwb0tKcng1elVUQXlYeitMTWM3Y1ZoOHY1c1habEc1VTVVa3Vab2psWEZt?=
 =?utf-8?B?Z1ZkcEp6aUVMTzBzR3ZXdWU2SEoxVldPSDBwYllVMnpycllKUW1yTXJXN0Nj?=
 =?utf-8?B?ZVh5SEFYMlV2MVdxM3hxOSs3cHQ4SjFsSDhLVTNYZkpSVnZSOVNnbTNrdWlX?=
 =?utf-8?B?QXkya3phdTFjL1k4b2JGUkc3Z0c2M3Fic3l5SWFLU082MDY4U3Y4Vm1XVEwr?=
 =?utf-8?B?cGlLbXpvTXR2bERhZWdOaVQ1bElDVkVWQ0d2Mk1UUEMxMGlBWnUyZ1ZwSTQ5?=
 =?utf-8?B?RS9KTkFwdGtxOEhkeDVXZ1JEQjA0UXlwSmcyNE9lRWltclltbmNTbUdDeUx5?=
 =?utf-8?B?YzFXZ0ZKNXFsU0VqNXN1L0R2OUZINGlSaGY5NlkxTjBXRnM4V21hNjYvUElv?=
 =?utf-8?B?aUlOY3JTQmRvV2NkWDUrNHFjc0JBd2NHVWtQdXFsSlgxYkJLWlZFWE45a3kr?=
 =?utf-8?B?em55Z1ROVktabTJ4bUJvUTBDV1RqZUdhTW5rcWxkVTdKNGFPczRUa3hDT1Ja?=
 =?utf-8?B?QVFRRlhOeW1ZNG9Cc1Urd3N6MFpKQzMrZjhiRjBSOWZCWWtFUlhxelhIcHA4?=
 =?utf-8?B?QW5BUlQrb21tWWdyVWdwMkRFWlgwYXAwdERsMG8zaVMzaWQrQ2phWjJmS3VR?=
 =?utf-8?B?L0Znb29uYS9ObHNTRjYyTHpqY2h5Y250K3R6dUhxenN5dHRwWDlwMEliOXo4?=
 =?utf-8?B?a21CTmVEaHBEY1prSmFMblFtSGJVUTkydUFlcVdiY05HU1dQVHM1ekhYZmNo?=
 =?utf-8?B?MUgwcEgvd1FKYXp4M3RmZEVyZ1dqeUxWWFFNVThQYTBKOEFYaVBQd2N5WE1E?=
 =?utf-8?B?K2dHcXA3bHVDR205dExYeE1jbDVwS2dBekUyYjEvQWxmVjJvZmNtOHRlcU9V?=
 =?utf-8?B?ZkpjRzRvZlpKWjMyM1lLaU9ZRHBVYjZXbi9JZ3ZDK25qemlQeFhpQjZrUDJt?=
 =?utf-8?B?QTNtZnA3bENvRGI3eC85OXJkbk50TEEwUmZkSWl0WUxxMmhCVnAvQjJqbVZp?=
 =?utf-8?B?ZXpBdzQ4aEdOVnFkZ3lUWnNvTVpXamtRSjFHR2dwTkJXQjhLa0NIMzEzVmEv?=
 =?utf-8?B?QThvb0dSVmVKc24vRXFVUHo2VEN3eWxxTm9oUmR0SDNRcDlDcDBGUDF3RTQ2?=
 =?utf-8?B?SldPbjZnYkh0MXV1Wmg5ckhDcXowTXl6NnlOTnhlUHprNVFtQW0zd01CeVQ3?=
 =?utf-8?B?dnV1cVZDMzQ1TlBRMjlmZE1SdERZVEdGRG9yT0F0ZWpCZUE4QkdFVVBwMDJw?=
 =?utf-8?B?NmYzL0ZscmRPUWQwTWFUOEE1QTBOb0RIM3pkOGs2bnkyZzdkcTU2NmN6a2tM?=
 =?utf-8?B?Q25jWXpLUHJ0dmpRdVpMN3BudFc4Sm1heUVreUxxWStNa3ZOZ3EzYm1IbDVT?=
 =?utf-8?B?MnFiK2U2ZWhWTDdPTFdwYVZVMUhNUCt1bUJwL1J6SXQ5OVhsTXVBcmVKK21l?=
 =?utf-8?B?N2ZXM1AyV3ZtS2ZVaG80TFBYdVBzZ21pYkxDVjErUW0xL0F3TWRaeGZJZTht?=
 =?utf-8?B?aDVOeGcvb3ZheFlGOWxNTHdIYnc1N1ZUdjduMDYxcHB0QmtFcjJLekM3ZjM1?=
 =?utf-8?B?a2pCc01pTjB4OE1uNStxYmU0RlMzeW5qdzB2ckphWThncW1Qd2RDOWEwNWpu?=
 =?utf-8?B?WmlkWjFMbnYwV0MzVXZuVG1yN0RtMEJiOENHNWtEamx2cGQ1dFh3YVdwVGEw?=
 =?utf-8?B?SXM2bjdCNVpBRis3WlhkNk1CUmtIU1AyOXRFcFhkWFVXbDluRGR0VUx4cjhF?=
 =?utf-8?B?Mi9NaU54azIrYWx2d1pBVnhjMjF2ZzNJUlFodFZIeU1FWlZLRTJmNHhmdS9u?=
 =?utf-8?B?MjBLS0VMR2RlMlV2UXhKSTkzMlBHcEgzeW9ybkxCcXVFcWlGODNhemJ5dm9y?=
 =?utf-8?B?Wk5xeXo5NU13UkZ0OE9HazZTMmhyRnlqQnZrOVA1R25VQW52cWJ1ZC96SDZ4?=
 =?utf-8?Q?8AzPEgWoKpcF+OMzSxLrSJKX6?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a02c25-178d-434d-bf06-08dcffc3230d
X-MS-Exchange-CrossTenant-AuthSource: AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 07:01:15.3282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ABqfkB0PwJ2koIA1e8JkZakeOj3QQD7zT8DmYX5dhUvQ9kq+5lx/z1YFi4iQLrcpjVXFSQjC+243QXUMnR1lQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB7255

On 06.11.24 13:01, Greg Kroah-Hartman wrote:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Wander Lairson Costa <wander@redhat.com>
> 
> [ Upstream commit 338c4d3902feb5be49bfda530a72c7ab860e2c9f ]
> 
> During testing of SR-IOV, Red Hat QE encountered an issue where the
> ip link up command intermittently fails for the igbvf interfaces when
> using the PREEMPT_RT variant. Investigation revealed that
> e1000_write_posted_mbx returns an error due to the lack of an ACK
> from e1000_poll_for_ack.
> 
> The underlying issue arises from the fact that IRQs are threaded by
> default under PREEMPT_RT. While the exact hardware details are not
> available, it appears that the IRQ handled by igb_msix_other must
> be processed before e1000_poll_for_ack times out. However,
> e1000_write_posted_mbx is called with preemption disabled, leading
> to a scenario where the IRQ is serviced only after the failure of
> e1000_write_posted_mbx.
> 
> To resolve this, we set IRQF_NO_THREAD for the affected interrupt,
> ensuring that the kernel handles it immediately, thereby preventing
> the aforementioned error.
> 
> Reproducer:
> 
>     #!/bin/bash
> 
>     # echo 2 > /sys/class/net/ens14f0/device/sriov_numvfs
>     ipaddr_vlan=3
>     nic_test=ens14f0
>     vf=${nic_test}v0
> 
>     while true; do
> 	    ip link set ${nic_test} mtu 1500
> 	    ip link set ${vf} mtu 1500
> 	    ip link set $vf up
> 	    ip link set ${nic_test} vf 0 vlan ${ipaddr_vlan}
> 	    ip addr add 172.30.${ipaddr_vlan}.1/24 dev ${vf}
> 	    ip addr add 2021:db8:${ipaddr_vlan}::1/64 dev ${vf}
> 	    if ! ip link show $vf | grep 'state UP'; then
> 		    echo 'Error found'
> 		    break
> 	    fi
> 	    ip link set $vf down
>     done
> 
> Signed-off-by: Wander Lairson Costa <wander@redhat.com>
> Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
> Reported-by: Yuying Ma <yuma@redhat.com>
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index f1d0881687233..b83df5f94b1f5 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -907,7 +907,7 @@ static int igb_request_msix(struct igb_adapter *adapter)
>  	int i, err = 0, vector = 0, free_vector = 0;
>  
>  	err = request_irq(adapter->msix_entries[vector].vector,
> -			  igb_msix_other, 0, netdev->name, adapter);
> +			  igb_msix_other, IRQF_NO_THREAD, netdev->name, adapter);
>  	if (err)
>  		goto err_out;
>  

This is scheduled for being reverted upstream [1]. Please drop from all 
stable queues.

(credits go to Florian for pointing me to this rt-suspicious patch)

Jan

[1] https://lore.kernel.org/all/20241104124050.22290-1-wander@redhat.com/

-- 
Siemens AG, Technology
Linux Expert Center
