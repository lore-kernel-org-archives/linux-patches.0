Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3934F34D3A1
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765991883; cv=fail; b=ofDZFxceop4B6AFFJumH88h0p+j8TkhdKbyPMIdIE09g0bf9zJUAVS70QWH5uvMbWJ0mEqlwRX8mHKZ3T04HsKmKgXwsaENwXSRSPURnEHLb5MTi2bHlbQWXppIh1yfdj3Ga/ZOmplfY2qCUHSRvbmWqAXuFr+Kwq+ht3lOuyuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765991883; c=relaxed/simple;
	bh=tHcz3uh8O/ohZ8Eny5wkdAVBlH2kjapDVBZwMTNmOnA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bzT2EwPyKeAuhN0pyLfCbuf6bpIL2MYOqnep8VUYfjw8VrMrkHWSUXDOv54UQ+2UzRzVFIyZ+qMpK4YE42azoPE8qbnChs7DOXWN42WtJy3iN0sGyoBREPxHjGSAsdjmB23ld067Z/lN67zPCTMubg7ZMNLs5j3nYTdKUkcxEcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=joaSFEwD; arc=fail smtp.client-ip=52.101.46.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="joaSFEwD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtLRmeIKY3mh2IIFpJC4HOGZkLl3Un1dCWSmVn4aPLNSdXVZqhUMssb1wzxdezSgF3/Op5PahpwuaoAxtOHAXY3YzsjgfoLFi6JM/1RAFtY9u86PIcqiuBHgTiKYJjXzwObrBzbMJWJVaWVAm+nDMlDbVVzNMyKm8eAaKE0K2MOq4nTpyXxsVOgErChdD+kx4W90Djzy5Ym4Sj/dozd+cTtL3ub947lh7QI5gocDXYn7It2U5nYa6TV64+9TxnkIhhus0lNSPx3cgGrsZCciPRPNpMCWpeXbEXcAQTUsJM6tGyn72tHjOdqkc3BHds5dHntPqum2y25Nxh/FUkVIxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QT7rp44nI2ZfICD4DHMX5PgzmHMk6j0twPMPery4lN0=;
 b=LLtsbhIqJOlcx6BZWHlk8Zrv9kSx8l3PqlZcr3LzXyZ492FShe2AHY7/AfmmfSJkrcw5Xf+tY4y90BFeVjtHFopnunEothLERfxfE/7hfQ/asa4ZMFhJ/qYycGiPIBg0WQpVef10m8v6+VqzkXTbeHStm+87fesWoeYau5J3CxRZIaUejvw4ZGz6lJnN5cHTuz3gpfe8hqmn/Upjk1ooYDoqYy/4/KeSe7pE30/sN3xixMrwXRXKkPdTx4eMX3DDYKwOU/SWZ9fFDcu5h8hLb5nbRe+DdmPimXi6Srp2TXvtv1RNZqr1qtmQu2WMayaumEe7EDmgk+oH+ikmKQYxBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QT7rp44nI2ZfICD4DHMX5PgzmHMk6j0twPMPery4lN0=;
 b=joaSFEwD+4pE2eMfY3AsDpwqr1s2NWZMNNWJEJEb21t95fBORhrCtPqLa4X/TyH6oQrBNVwSMygksnT3c2KXdSvhnk0+ozDuz4dkh7CDhP0b6wZ5JJUslzDg1hn22wcfWobO48PM8+o2E9bFpUlSCjf5ftAsrvDGAaMWqwPkIUw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH7PR12MB7284.namprd12.prod.outlook.com
 (2603:10b6:510:20b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 16:44:33 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 16:44:32 +0000
Message-ID: <0d137f81-b3c0-4468-9a33-e521c6790bff@amd.com>
Date: Wed, 17 Dec 2025 10:44:29 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
 x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20251029162118.40604-1-tony.luck@intel.com>
 <aQJkIqj--nHzUzUb@agluck-desk3>
 <9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com>
 <aUH5QZ7_7WCRWY3Y@agluck-desk3>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <aUH5QZ7_7WCRWY3Y@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:5:40::24) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH7PR12MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: 13f10bfa-5c72-443a-cc02-08de3d8b8df2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?QzJwSU9WSkRmekowSXdJQ3VvcHdQenJQck9aRWJTR3ZFUDBrYVhWZmw4bnh3?=
 =?utf-8?B?dGFyMlAvOW1NZXR1UTcvWUZwQWdHZWljUkMzUEFmaTFUeVJvS1VPZFg0ZTdR?=
 =?utf-8?B?ZS9IT3pEWjVLTkZmb0VDZVc1TmlueXh1TzZRczFMTkw5ZEk5TVlzZU9FV3lY?=
 =?utf-8?B?cDViaUF5OXFJcUxFWFZ5SkkrOS9YYkpvbTFiVDR6OWthTXpCVmxRZFFIdlZB?=
 =?utf-8?B?YjZOQWcyckZJMFRTM0JJN29rQmI0WFcva3Fja3RoOWRSSkN3NWMwdmpKMkRk?=
 =?utf-8?B?andEMVQ4cWVOd3VmM1hSLzBOU3FwQmIxRjd2azBQTDUzZjd0Snh6QTBsNk9h?=
 =?utf-8?B?ODdjRndvM0l0MEg5ZkQ4bUJnQVN2S0VtQVZsQjVXb0pGWU9QQWMvVUZaTDFq?=
 =?utf-8?B?K292VjRZS0VkM2RHU20wMkVMZTIyOU1HbURwVEpoVW1vVXhXb05vMzlpK0xi?=
 =?utf-8?B?VVA5ekpVRS9aRmZQUEp6aExTQ2p0US9MVlNvRzBwa2lGU3B3U3Z6VlZZOVpH?=
 =?utf-8?B?NGdlUmNCa0haQmE0M3kzRzhUL0ZwZVo1N2J2b2tmR2FRUC9mNXZwZjBLS295?=
 =?utf-8?B?R054T0t1dkwxbllOY0pvbkVxZGx0SUR3UWJLOHJBWG1lNHM2MG9oNFVPK09o?=
 =?utf-8?B?VFZscWRyL0oyUmV0Y2R5NkxTaXM3WHovU3psR1RVQlZxbFB2cDFDdC83QVo2?=
 =?utf-8?B?dmF4MS9oTWhKZTZMNjFsU3Q2aGlkVm1OOGROZTdRdDhOdWxhYUpWaW9Kcldn?=
 =?utf-8?B?TEtlVmlkTmJ2SkJlUndUN0FRdy9JMThSV3kvY1cweERFcllMcHBiaTlpRFZr?=
 =?utf-8?B?cHIzQ3RKNjdqRjRZa2JzU3RBSUI1MmlmL0wrVUtPUDkrVzlrOEdYdGxNM1pm?=
 =?utf-8?B?Q0VaUGdGVXB2RGhHMHozMnNEb0dEaEordUhwd0FFZWNiQUlWeVlOeTkxWG11?=
 =?utf-8?B?ZElkUDRRMlhlaVhPSkZacGNyTjh4Vzd5YzVRNHJLamt3Yk5aWUNZVDBKQlFT?=
 =?utf-8?B?aUMyRXhrYlNYakQveXF1MWw5WDk2eklneVN5aTVEeS9YNEduMEZVUnFUdlZS?=
 =?utf-8?B?TkwyWnBRNEpWM1MvNmxzeGs4OXhoQ3BwTzBaUHdnRTlGdHVqTHVhUUE4ZU1B?=
 =?utf-8?B?Z2NOdWZqVW1rMEtqOVdQR3ZsaGs3TFNQMitZRllacGZ0a1Q1MDNaQU16alZN?=
 =?utf-8?B?VnF5YnNaSnJqK2RkUlRCSVVSc2FReVlRdDFGUkFlWTVIWk0zayswSWkzVlln?=
 =?utf-8?B?ZDR0N2VVelZDTGtlY0VjN29PdzNKb2J5aUFPdXc0MUhVNERZSDQvOXJjNUJk?=
 =?utf-8?B?UU1lL1E2djFLOEJzMTlwdTlDb2FlMGhFMlJweVNGQUlaY1RWM0M5bHQ5V3J1?=
 =?utf-8?B?TFNOZExmWXlTM2ovaGxLZ1Z4Z3BqbCtoaUFtN290cU9sTTd2MUxTSTNHNlFG?=
 =?utf-8?B?QlZoVXArZGpPT1FrdHBHZFJ4dmU1WmNaVHZpcHN4Q0Z3bGhkdUxQNHR5YUZy?=
 =?utf-8?B?cUt2UWNIK3RhMW9TNzI4NHhmTnJpNW5KNUM0eEV3ZFRnM1ZnL2p3U3A1YmlR?=
 =?utf-8?B?Z1UxTGVPbFloT015M3BjQjhENURycWRFV1hMdGQ4S3RQN0c4VzdxTExiUjRp?=
 =?utf-8?B?SkxKZjUvcmwvSWp1STh6ZFJWTkwrYTBnVnNGcWVabCtkQWZiLzU5Q0ZNb05M?=
 =?utf-8?B?cytWUVh0aTJ3U3JmNlU4QWQzTERBY2dyWFZ4UTlhRDExaWVLemJGSFo1VGZO?=
 =?utf-8?B?bU1JMVBLYy9rY2l1OXNSYUwrdGd1VWwzeVM1QTlCNklDR1pPd0xubkdwNG9k?=
 =?utf-8?B?SVcrc00wUE1Uc2xTUVRtWUh6alNnM2RLZWNOcjFpNVJsSFBtTUlxdktFWjV1?=
 =?utf-8?B?ejV6bmtnVDd6VTZXWVluNnB1ZnB1SnF6VnFhTFNSNTN1bEN3cm8vVW5TTGxp?=
 =?utf-8?B?b2ttdlJ5R04xMGZyUE53STFZeWd0K2hSUFNQbHpPUjZNYWFJY24yUEY4QUZl?=
 =?utf-8?B?Nlpjb3VmUkJBPT0=?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NmtsNjBJOGtZZndueTk5am1mcCtiNU9LREduY1JuY0o5VVZGdzJVZ3ZxK3ly?=
 =?utf-8?B?RUlnWUVoU2ZkaE51YTE1d2lEWUxyVkRhdzloUGpXUnNSZzJ3QWtuSUhuRlFC?=
 =?utf-8?B?YkdXdXhDYW5KT2N6WDBsdUZwbWxMemVrMWZlVlQwdVRBUzE2bXZPd2Urd1dS?=
 =?utf-8?B?b0R2MXR6amZ0ZFBNVWNxUGNhMmx1Z24zdHh5YTM5TUNkTGdUQ042WUVkTWM1?=
 =?utf-8?B?ZHQ2MHo1cGxQMUJFZW44ZEN6SDlTSmRkcEx0Z2VnMHIzNldVcUkzbXBxeFJF?=
 =?utf-8?B?RWdCb0ZFOC9tN0tRWTgyWUpucjZ2T2JmSE1icisxNWV1TldWNXhDUzM1UzFh?=
 =?utf-8?B?SFJLMU9CckFqeUZjL0piUWpvUWFucGhtUXgrZ0NoSDI4VHZWK1Bvb1o5UlNz?=
 =?utf-8?B?dmFrSEgrczVFQmtScG1TUVgwN0FKU0p3QjhtTWVabXBwTFUyV1RhREVMbmIy?=
 =?utf-8?B?RmZSYVNOT1RmNWdBeXBnWmdIUUZTempGeGJRZU94Sy8rcjJlMG0vZW5zVkt1?=
 =?utf-8?B?R1diejN1czg5YTcvdFdlU0lXZWwvWXc5b1F4bmRXbGliMTRidGtNWTZSMFl3?=
 =?utf-8?B?UzZLbDFsQkUzNXNKbWtHTkFpT0ZYL0ZlNHFNZzFJdTFwSnZ1RTJVNmFKZkNl?=
 =?utf-8?B?WEZDVWJWdXZTNG10bXZpcVdhWXNkVTlNK0hzaEgwMWtLN0ZJd0RnVjl4cHZI?=
 =?utf-8?B?R0lKUlVZM3JQZHdaY2YwbGEzWEdHRStiOTNuQkdvVjFhRHBkNzhMK2MvQ2d6?=
 =?utf-8?B?Z250b2NRbjYrYTVyUVN4MldIc0ZoY2hDVTBMbDF0YzRLVkRLelFONnVYM0NI?=
 =?utf-8?B?L1hyOVNXdENad0dRYlpsM1pSSERpYVZWY0p0NktCNjBFYUd5MFRORXU3OW83?=
 =?utf-8?B?OUYydlI5VEhCN2h2Z0VyRW8xSm01TzJTUTllZkxvaWhsNmZKQys0MWoreHEw?=
 =?utf-8?B?Mko4VWlXei9EY2thVzFuTjVTL04yTFJGdmFseEJ0dU5QMVZHcjVWVi9hMmtL?=
 =?utf-8?B?dHc2OUc3VExvVC9VakRzanY5S1FKczBxUW5EZ2JwTHpOWUFraTljeEZKS1hs?=
 =?utf-8?B?UjRlMTFMYlVWeERsUStrVnpiWDF3U0VXOHVGRkdHeDk1Y21lUGxERkw2WTh3?=
 =?utf-8?B?NUlMenVzWCt3MWpjSUswVStOZTRxTnlNSkp0dUNEbjZGRUZiNGc3RjhGM1dB?=
 =?utf-8?B?bXppenpWSXVkaGprdmdISkQyUGJVN0pWRzBKZjVpdFE0anpiYUpKTHM1Rjha?=
 =?utf-8?B?VW1oVkVpazJrRGJvRXp6MnhGZHdsNUJiRW1UekxQaXZ6V1RoWVVtWlRaeUdw?=
 =?utf-8?B?QkJ4b2hXTXJPclJOR0pCb2FPZzV3TEJGQkxHNG51eXJXV0JFeXJSTGpyak1V?=
 =?utf-8?B?ZFZhb3BwdWswZml2eHFoNTZlak5CZTdFL0d5a3BPK0JWY2NNZzBCaU1QNUQ1?=
 =?utf-8?B?YnhXbFUvWE5JZkpHM0x4NFFYTU4vSmtSVG83WHBGUDlYVmF5N1RsQlJVTDg1?=
 =?utf-8?B?RzNydHBGOHFDeE00MGt5cUJQY25uMStPVkVyQXhkdjVwbGRMc3VuVU9kejB4?=
 =?utf-8?B?R3ZTTiswY0NrZk9lN3pUYTlxY2JyTUlEVU5oSXFHTnZUU1lnMGJnb0d4bnNV?=
 =?utf-8?B?Z3lwUjBsaTJrZXNlRXl6Z2VubG95UTU1N1JDMEdIK3hOTTZ2MHEwVytNZitT?=
 =?utf-8?B?czhkWkNFMkxMQ0Jjc2dyMTBVNXJYajZ5eFpuUUFOUU8xVi9QNG4wOUZ0N1V0?=
 =?utf-8?B?MVRqVzlpTXVYMUJjaUZ3cS93alB3OTV3MXpJRGxaQ1ZsbUEyMHl1Y3FNWW9m?=
 =?utf-8?B?SWtaTW51WnpSYysrZEVvcTgwcExRS0VRNjFQTjhmQTRnSE9nNWdWUVF5QWxs?=
 =?utf-8?B?Q3Z3QTYrSXJ6TlU3ZldRQktrY3JXVEVVTXhyOGpiWkpNdHk1MUpiY0gwTU10?=
 =?utf-8?B?WWtsTEdPVi9iU0EwQjl1eVhNQ2doS05ENEdUeWE3YWVSRitDYWRWSTZEL2hJ?=
 =?utf-8?B?dVJVUUtUd0tLb0tvMHN4SlFQR1FSUDIxZXF2OGc4VzVHdmhZWTB1NVJmNFRP?=
 =?utf-8?B?cHNPUEcwVVE0RTdBamxoajVGUjFSR0d3RUxLQlROdEQ2cHR5bGZyWGdyNlE5?=
 =?utf-8?Q?6NNhGsQeV6gUlciUwUmO9SxZB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f10bfa-5c72-443a-cc02-08de3d8b8df2
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 16:44:32.7327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGI38kfTNEYy41kwPf1ttRleCsu6IloCFFYj539U97GdOoLgod8ZAVDGzjBRgO6D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7284

Hi Tony,

On 12/16/2025 6:28 PM, Luck, Tony wrote:
> On Wed, Nov 05, 2025 at 09:33:56AM -0600, Moger, Babu wrote:
>> Hi Tony,
>>
>> On 10/29/2025 1:59 PM, Luck, Tony wrote:
>>> I took a stab at applying the AET patches on tob of Babu's v10
>>> SDCIAE series https://lore.kernel.org/all/cover.1761090859.git.babu.moger@amd.com/
>>>
>>> There are only a couple of easy to resolve conflicts.
>>>
>>> I pushed a branch with v6.18-rc3 + SDCIAE + AET here:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git sdciae-aet
>>>
>>
>> I ran your code on my AMD system. It appears to be working fine.
>> I don't have the hardware that supports these features. It would be helpful
>> to list the resctrl interface files (files in info directory and files each
>> group) and give an example of how it looks in the system that supports these
>> features. It can be in cover letter or resctrl.rst file as well. It will
>> also help to review the code.
> 
> Reinette reminded me that I didn't provide the examples that I promised.
> 
> 
> Here's what I plan to add to the v17 cover letter. Is this enough
> detail?
> 
> -Tony
> 
> 
> Examples:
> --------
> 
> As with other resctrl monitoring features first create CTRL_MON or MON
> directories and assign the tasks of interest to the group.
> 
> Energy events:
> -------------
> 
> There are two events associated with energy consumption in the core.
> The "core_energy" event reports out directly in Joules. To compute
> power just take the difference between two samples and divide by the
> time between them. E.g.
> 
> $ cat core_energy; sleep 10; cat core_energy

Please use the full path (/sys/fs/resctrl/test/mon_data/xx/<file_name>).

Otherwise looks good to me.

Thanks
Babu

> 94499439.510380
> 94499607.019680
> $ bc -q
> scale=3
> (94499607.019680 - 94499439.510380) / 10
> 16.750
> 
> So 16.75 Watts in this example.
> 
> Note that different runs of the same workload may report different
> energy consumption. This happens when cores shift to different
> voltage/frequency profiles due to overall system load.
> 
> The "activity" event reports energy usage in a manner independent
> of voltage and frequency. This may be useful for developers to
> assess how modifications to a program (e.g. attaching to a library
> optimized to use AVX instructions) affect energy consumption. So
> read the "activity" at the start and end of program execution and
> compute the difference.
> 
> Perf events:
> -----------
> 
> The other telemetry events largely duplicate events available using
> "perf", but avoid of reading the perf counters on every context switch.
> This may be a significant improvement when monitoring highly multi-threaded
> applications. E.g. to find the ratio of core cycles to reference cycles:
> 
> $ cat unhalted_core_cycles unhalted_ref_cycles
> 1312249223146571
> 1660157011698276
> $ { run application here }
> $ cat unhalted_core_cycles unhalted_ref_cycles
> 1313573565617233
> 1661511224019444
> $ bc -q
> scale = 3
> (1661511224019444 - 1660157011698276) / (1313573565617233 - 1312249223146571)
> 1.022
> 
> 

