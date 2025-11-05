Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42F821CFF6
	for <patches@lists.linux.dev>; Wed,  5 Nov 2025 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762356844; cv=fail; b=js6vpVRSCO0GuFUpEisl/w4OZYbXymVjEtjHGzh1tc3nfH/U0kytA8jGSW8UYSkK1AXuGeNDom4xQno9BxegL399yZPwqwTo9p0Wd4kjsLHyI7BGy/CnCKX8WmcbbtpOgN/GLc4Vi3fka2KNah9psFeqHfjJ1ZFPIkgoIhaxGX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762356844; c=relaxed/simple;
	bh=sybtUYWXsQJng7bpwEIRwVXK8GYc7EIi7gy8D3OZpU0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KsYHFJDndQlXVZPJ+e08V0p0oyvEIATbr2PkU/u8/R8dScYL8W51MYJpd8Bai3ijZkWtfHtA3aHzYF2HPDl8o1aQN4hAw/LuCkauco61uvXoo3FUnJFHQI/EiIG9nkULRfMoY1pcYfLP24X+1MGEnENkk0hST7PHW+XI8TCrRw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UXpDFyRt; arc=fail smtp.client-ip=52.101.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UXpDFyRt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OTbdj3ws4dvUdqS444/00888MFYxcAO28Ed0WrD5cJWZ0xfPs48+aZOnxXuAefsAO1JEHXI9qfJzdDRB0bxXKo3riO9C9s3fV7DrmGKpJfswb2L7S3JqbApke3OQBsxPvdEMgV/TUhnbczka5dvGkim8OJBnf1q4ZjXgBdwQGfu8QL6MgUIEd8kX1QJYhTuqQWgePNVNV05+mgcjXpJLbspYoIR7ZBkfy/6MEU6P2nG3whLBJnZ0vsXi1XeQVO/vti6URLx2X36fbPA/ry2+prifAlNyATXpnYB2bysGI6ZUqyL3raKHYb/TPF2QOQJUIiv/NpGZyhdtHepyUk7Cbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eE2gBBuiR+Nk+iaBGLZLvSallerjtsodcxgpOIxEwf4=;
 b=MwUQHE8x+PriiDgrsIALkV7XwHyzTKmWDoerpeQsYatpb8+vfCKBeGzkKuV/OEbqCzOvtj9o0ZxhKT0U+r1bbYikFcTqSu5c3Snk7MD6LO9AEeoVxOe8HfC7fIysIOvYFZ5MOHU3HM+82/wKoLIR2uKDIkQ/kk7opKdPhGZ4DpKzuOuVOG6qrw6HxGq6fodT6E5+AJYKEL4LZUzbaaSiwPbYT+v7yoIjCzUkn+qVmWlgS7cwq9wRamXojd22iXZk7BDz87aG7OmA0XCllilS1tpKDI6Fx2GN0dNnek0GuiInaRdxlL6aTQsTqFXhU1a0WG6J1M4SaYNO4Vx0avjpwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE2gBBuiR+Nk+iaBGLZLvSallerjtsodcxgpOIxEwf4=;
 b=UXpDFyRtDLQz9vBjqrAdYLPXWu7REJembx4yPxNA3H0eqEKgJhAQJcSeqIhgztvy+9BKYdWbJWipQiPQmYgaGbiplWIG8W/V/MPFPSq4BiSMZi6w06D3tJm0AIWgbXSrfSblT9ugr4ghNst4KuirxyhvSzLhdegVVBJvCmbGqIk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CH3PR12MB9171.namprd12.prod.outlook.com
 (2603:10b6:610:1a2::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Wed, 5 Nov
 2025 15:33:59 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 15:33:58 +0000
Message-ID: <9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com>
Date: Wed, 5 Nov 2025 09:33:56 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20251029162118.40604-1-tony.luck@intel.com>
 <aQJkIqj--nHzUzUb@agluck-desk3>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <aQJkIqj--nHzUzUb@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0063.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::12) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CH3PR12MB9171:EE_
X-MS-Office365-Filtering-Correlation-Id: cf363adf-1c71-4f44-6170-08de1c80bd04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UC81dHJJQ1FGejBzMkhRYnFNNGtPSmtLbUQwSlMzeUNHQjI0c2tnYkhZaEJz?=
 =?utf-8?B?c2MrZk8wTWdraXNFWjI4c2MxdE9ycU5POS9yQVBZOE50eWdRb3krdkxWa21Y?=
 =?utf-8?B?Y0dIeHlLVVpudVgwYW1TTXBGSkpCbXM3M3Y2Q2syekxuRFVKd0ZqWXNORFNB?=
 =?utf-8?B?K3BEQXcyYzJ3VlJmYTZOc0Y0bDNWaWxPMkVRd3VBdmNhQUtUb244bEJmQ3Fz?=
 =?utf-8?B?NHNNUXV1VlRSN2ppUFJ0dFI4WVgvTWRWWWx6VFFKMHpWOEdMeUkvMkM4OXNm?=
 =?utf-8?B?MHFHRnBHOUtCZWRBQVlhNjhBVXY1VTZXdy93dnBsNnFMejgvMytkM1FoZ0VK?=
 =?utf-8?B?azZPUjVCQmx6ZXd2Mmp5TVdDZ0MyeUsxa29xS05OVU5nNlRLa2ZHU041TWlJ?=
 =?utf-8?B?RnhzZ00vOVh1bTI4UDNWREZuc2JGKytVOW52OWR1U0o5NnJxK09RQjBpLzUv?=
 =?utf-8?B?QXhtWjIzOW1FdStkcjVVWDlyTWV3SUJuamE3blBQbmp6ZHNoaWVUMnIxdVVt?=
 =?utf-8?B?Zm03cnlhZzIvMGp0M3FQai8vTEJUL0xkdUFhVHFoNTY5dXVZWU54dk1oK2lD?=
 =?utf-8?B?bjZkRnN4WVdFSjdJTS9FbWMwOEwwYml3RHR1WUdUVUhraUlVeEd1ZVJ4c2pW?=
 =?utf-8?B?U09vcTFqZVF0WGZHRk1Dd3dKZWp0cU55K0FxTEJjLzNXdzVYTS8vWmhGSUJo?=
 =?utf-8?B?d3RMS3hGTFg2cFZqaS9RRzdWQk96WjVwZmJzZmhBWnRjRTBLVktKeDQzQngr?=
 =?utf-8?B?dk1IVHB6SVZ1RVgrN2w0RTErTEprNzhGa2Zhc0pITFRLbWpIUktnTHRrTEVl?=
 =?utf-8?B?V0FVVWdkSGN1bmxTaGtXVFUyejBXNVhqaVJYN1BubVliMzRwSHpZZW0zaHR2?=
 =?utf-8?B?MmtYV25HYmVDV0t0c1BBWTVRNlA0ZnJNTi9CUVVqZFNCUWZWOHplUUZTUkVo?=
 =?utf-8?B?ZzVMemtNTmozMVh5ci9PTzZvR0pWamRnMlBBZ1hobE85NUZrcEdPdER1UFNh?=
 =?utf-8?B?alN0OHZYWE5DTGRmdHF1M0MxaFBBZTdFQWVyVUJKM2wxQlhMNXMrTkFveFZw?=
 =?utf-8?B?ckF2K3lPbzgwMkhEZCtqazNxTDdIcTNxNFdHRDgxSUNNdDJvSGJMejJXcVJy?=
 =?utf-8?B?aVlRUUIzN3QwNFBpVjlybkFsTThtbTJJcnY1YW4wOVllb0I5NHh6L2pweTVi?=
 =?utf-8?B?c2pINUNOZ3N3U2crKytNVlZ2YTBXbkJDeW1oNHNvUmdrdStWclFsTE0xU1d6?=
 =?utf-8?B?QjJBaldHNG9YWGtRc0tXNDFzUVRhUjRIeFNLZkt4S3hzeHNCenozQmdwc3VI?=
 =?utf-8?B?MWZCbUJHalhVdHF2UGRQMVAyUTFLNTF4S0phN25BVG1UbVpqK1lwcnQ3ZnZR?=
 =?utf-8?B?R1ZERHloWkNTT1p3am5xOTE0dkJCc0JMNmVaRDByRW4rYXdXZG93R0JtWnFj?=
 =?utf-8?B?Y0g1Mk5wT3R4bUZqSWplR0ZFeVNrbmNsTHJ3ZnFJN0Yvb2pjeWlSQmlua3By?=
 =?utf-8?B?ZWIwK3MxQnJoUm90eWFWejdjbEgrK2R3ZjFBOXhmZWptRTdqUEFqU2NmNlk2?=
 =?utf-8?B?NUVTSXhBcGZvT0dRSlhKTEN2WUwvRVpzNzdvUVVic3pyc0p1S0gxbllPZkdE?=
 =?utf-8?B?UW5VNUE4VVhMNVZKLzh2cy9tSFBkZGx0TUg1WTdoVTV4amZ6QWYxSDFGMVRj?=
 =?utf-8?B?UUJrN3VpNVVWWVlnUWxkUngzbFhlbkVUYkV1VElkaXQrRSs3MW03T0EyZjFR?=
 =?utf-8?B?UXVTRzZuSlFRQ3dqR1lIYTlnajNHMVMzV3pRSGpWcGtXRENKN2FmY3BNSHFw?=
 =?utf-8?B?RWxJazBFajdabmVMMXpMMzJXelplbHpPUG5QOGVnaTZoVlp6ZlgwWmNWNjBN?=
 =?utf-8?B?Vm5qcWFVcVBtWkNtOVJxSXVTYjhZbFB1VjRvdzRPZVNveTI1L3lvaWFlNmlI?=
 =?utf-8?B?YkYxcTFqYnR6Wm9CejgwMU96VGpRQVR1L2pSS0dDZ3ZwNVYxbWM0aGo5Rm9x?=
 =?utf-8?B?ZVpIK0NRdS90VkR1ZjlZOWJOMHhZdUU4M1BrMkczNkY0U3NaUk12dGtyWjN0?=
 =?utf-8?Q?zDoWVN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1NEOGZ2Mjh0bndlUU9IdTM4NmxPVzdIWjE5VTMxZktxaHRmQ0h6Sjh1R2xD?=
 =?utf-8?B?cWtMT1ptaVpmaEdqcHpnand5enprRmZwbERlU1hmV080bHRZZXk2UW1FK0Ny?=
 =?utf-8?B?aTNqR0ZmSXhoKzBCc3RuaUU4ZXlpd0JYUXZuT2ovQTk1V0s2dzdMb0FDWUtr?=
 =?utf-8?B?eFlVYkVnUkl6TXNpK0gvWEFQcnNEZXdHUUI1OVFZSkFOSGx0SHRDZG9FZXBN?=
 =?utf-8?B?dXgvMlNHTENWSGdGYTJJOS9wWVpabEE1QmpSSjgzbUh6Z2lOKy8rWmhNYkVs?=
 =?utf-8?B?aEZFUktrbXlrc0YxTUh5dHI1bXF6N0l4bjZKck5jQ2d3b1JvQXlCczlsbmtG?=
 =?utf-8?B?SUNsamcvQnFITXhkcnVQZWN6Y01iTjJ0dVY5Rm8wTjFEVXc0UDJZZU1CVGJO?=
 =?utf-8?B?SnljTDZ0d3RDMW91RExNMytQcjhMbEpjNGxUckRYOWJXQzNqL1lKS0ZrNFVt?=
 =?utf-8?B?OTJ6bjhrMHJwdHFqdHk2UEdmbFkwR21HcWt5ODRxbnA4cTJqRXJXaEN3M2hV?=
 =?utf-8?B?eGxpbjh5NEVqOVYrVmxWK3JTdDh0cVhNKzNFOHNxRzNBZTk3N282ZncvaTZZ?=
 =?utf-8?B?QnZlZkNLWUdCM1ZUMURKblZCZWZLTnJ6WUpHWmpDcDFkd0ZrVzI2cnBNZEs1?=
 =?utf-8?B?Z3BoTU11bUV3bnRkZjZvVXBkTG1RZjJkOCtrZ0x6TzVFbVpaK053VHg5RXVr?=
 =?utf-8?B?Wk9xYy9yRUlPTWpzNXArN2ZuUUQ5V2Eybng2V08rbmtYTWZ1K0gwRnpwMDJD?=
 =?utf-8?B?eDRaQ0htUzZPQ0JROEVUcWxIMWVONUswZkNjZXFGMTk5RWQ3WXhLUTNUUGcy?=
 =?utf-8?B?dytKVHY4NlIyendONG1qaVBxV2FGdFlUMUczUWtDdDA2d1dZa2lqR2YyVmFK?=
 =?utf-8?B?Z0E5bU1abjVDRVh0ZUtnMWJLSlprT1NTRGFucDJhbEFJR0hnNnB5KytBaURU?=
 =?utf-8?B?a0xrMGlQVC9EQVBxUnB0SUVLUGdrNVVSbFFkdHd5M25BWGlvV2FNVHI0TXlt?=
 =?utf-8?B?SkhwNmtQZllaWUZyQUFZNEQ2MXFTQXlyYUkvTnpmOFpWV2RlV05ud3Nzdi9r?=
 =?utf-8?B?ckdDRlZCYUtScFlpUExUZllIeVUzV0JZWTNPeHpaR29tZUQzV2JmQU5iQjdS?=
 =?utf-8?B?QmYvYXkvc0w3ck1mZ1ZHQ3Z6U3g1R1RsUVlhcmVkUzh6RVRsN3ExY0ZoVFN6?=
 =?utf-8?B?V3JqTW81WEEraVlISGpVLzhxeWVQemE1Nlhpcm5ueVRNbDVWVm5wbjB1RHdJ?=
 =?utf-8?B?aGdZS1B6NzgxT3JoYzhJanFaSWxVckhOdFlsTzRLWFFxRm03Q3NYK1gyOWdK?=
 =?utf-8?B?aDZtWXlTS0dxMVVKN3IzTWdjRGl4VC9uMnJuTU9RV2IxUXh2KzlqNFhCMVhi?=
 =?utf-8?B?TWxYaVU1VFIxODc3aW1LR1VSSk5TamFNRDRIdFZuUUdLc0lMYkVrMFdtTDlC?=
 =?utf-8?B?NDB5bXU3UnpKcG1oRW5ibUlEUkFsTUdrR0NNYUtBNjU3VnJHVWZpZTFLUHk1?=
 =?utf-8?B?Ukpwd2FDODRWaFZHQ2JmcFdmUFJWMGFQOE5FT0FtVWRRY2ZOemJlMHNiUFBU?=
 =?utf-8?B?RmJsMFlNOGRmQ25yc0hWb08rdlQyalhpdE5hWWU3M1JURVhwTlNURmw3eHZi?=
 =?utf-8?B?UUpWSDVyN1o0U3d2WlJZRmpNRjZHTUoyd0o5dExpcHZKWWlnQmRrYmtidmYw?=
 =?utf-8?B?NXd5ZTJIcHBJMTRwSW0yZGJDMkNoR1gxc1A1d3dCVTc0NmxNUE9VSEVFZHIz?=
 =?utf-8?B?UmxSYTlnbXVEcnEyYXpEc1NMcW9sdnRQWk5vZWxkZkxFMmpkOHNEQzlYdzRo?=
 =?utf-8?B?L3YzMGI0cDdXYU1TajJuVkNJNGsvWjBpNUZXMUFPUllJRVJVaEdEalRmWi9i?=
 =?utf-8?B?YzhLQW1NMWtVMEs3Sk9nMFJCZi9JdURHZnlZOGUwNVhtYlQ2bFA4dE1VaWwx?=
 =?utf-8?B?NzdZcjU5T0prSkNJbi9lbUp5bGUycGtMKzUxczJhR2t6S1NqQ3R6bnlNYzUx?=
 =?utf-8?B?b3VUQmwzMDdkTFpXRGJVV05zdDZDSGkyejZlL1FmSWJ0OW1YNmg1WW5PR0lW?=
 =?utf-8?B?UFpXaHNYby9RYmZFMlZUNEJWd2drM3dqblFHUHBhR0VHYkQ5ajYxOWd4cWRv?=
 =?utf-8?Q?AFGY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf363adf-1c71-4f44-6170-08de1c80bd04
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 15:33:58.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7w3/QaKjAgJCLl3YBntmRq/Q2X5od74G06yAoyqUbSscyb82N/4zFyc5u9LlqA2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9171

Hi Tony,

On 10/29/2025 1:59 PM, Luck, Tony wrote:
> I took a stab at applying the AET patches on tob of Babu's v10
> SDCIAE series https://lore.kernel.org/all/cover.1761090859.git.babu.moger@amd.com/
> 
> There are only a couple of easy to resolve conflicts.
> 
> I pushed a branch with v6.18-rc3 + SDCIAE + AET here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git sdciae-aet
> 

I ran your code on my AMD system. It appears to be working fine.
I don't have the hardware that supports these features. It would be 
helpful to list the resctrl interface files (files in info directory and 
files each group) and give an example of how it looks in the system that 
supports these features. It can be in cover letter or resctrl.rst file 
as well. It will also help to review the code.

thanks
Babu

