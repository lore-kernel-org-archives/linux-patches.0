Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5875E235BE8
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757344038; cv=fail; b=mNuJTU0nF/oVKW8l8UnjRGdFLc5/jsxY7Trw2NQiaMZ8tyUlXRCX2iVgCSaariurlyGXfXBFFh71w57gbgCaurdCT6ZPi+f0f+qshpi9BRdW9YHpW9pbnW+4n/x7L8DjLzMGjVIt/pnJOxqbxu5ZpCEShtLbG8Mf3REG1of/3t4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757344038; c=relaxed/simple;
	bh=V18+K4NXYduzhJq7sp72sMuWM3f4KjrIt7jI0GB4hBY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sw3kAJMOcBNYTJ5dSoyX7rs+RHUBGZ1Z0KnwRqhuNYpq8UfZRCypYPUABuak/HoTPFI/OnRxDsbdlQ+kVfU397SljnZIG5hgs3vPDrFFrHHzYLNJ93O4qQb1w4Ipc0Cet58zuf0KeJEpDr1srmEcN6n+K1dEMrk3xvtq1n8dvHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QrNZVnJN; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QrNZVnJN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKefdWT2uWlB1zNaAh1RkEcrq9LgJ3tyfXxUjW2oOfBVxMguxMwx2wSqZVBfWPR+gt+1yPUF7HnqxcU9XByEQc8yDxPvNm7Cdpvb3k+Y0KRQ1LkDF9e0TGLv1KIcKZal7NnYpQsia668wZDH9iJvWJjksNrfwIytTev2g+OhcF/5GNsFw4jTCHw8YWdDN0POW8pkd9oBigSjXVEYgP3BSSiCmskJKl3RJdL4ow9YJosQIBh31uCXf7QWY76YTJO1o1LXJnTrvF2qme/9RqzXEDfBjr6ZcSLjlNYRZAgSmLBttVG8Z166ADOTGb6jVoSYBml6xNr/a6ye4MxljnPdMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFCNYaA9y8IcLN9Que4/qLqauW26RR9YseSsndmkZvA=;
 b=j9GE02J6Y2n4ik1Fw6MwtQMHuhFklL/e00zM5S2GY6OCwSnA5GO/MRR8XXbQtD9T9EKCBwnP1A4bdvy6RYDTmOWajSqMvIGX6XCifVsDdLN5Izv6b1cZxKrtxRoH0k2q1IgETMrQI62hWwZHCaH1b8kDwDX3sN64tuV25IEn8CDLU6NTkYxg4ev64xqV9rJA5vf9z7n2XqBuZWWk0B07iZYsTsS6cPN5Urfsx63UCcdVHzwuV/XCtR4K9o5RI8k+E4Km1h8RKJe//+fulflUKkk04BfV6Oa0honRQe7cQCJNpeqJkGsjoxudLfshcmVTn2XTonS8b77vfoy92WGIHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFCNYaA9y8IcLN9Que4/qLqauW26RR9YseSsndmkZvA=;
 b=QrNZVnJNWLGlK0sqn9IK/SZ6IXNnFXD0Bf9bpWalvbSvzEiHD1ZE/koU343++LpVj/ZJLqCsX5lGhlxijUY4WESSRtkWyLI1LMb/1yL/4CEFSrBKzTin7t82wL9KVDJS3XkaOXQaDotmDD8K1wl3BaVnGtuFG2rArJ/hNHV1SD7zfBGlixfdeEEcHyrbpKdoTEHOWsUM8L8gPkyxuZnhwg4SooPrYBbGzj4eEycDB94K4EJovNRS7V5Zbtnwcvsb+qRwI8fQygK2rYokBA0GiBEzlfBbTq3aLt1uu8q1nVx7j1GhJvUC+p8Z+PqPZEuqq8xVRUD8hivxLrB6g4satA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB8773.namprd12.prod.outlook.com (2603:10b6:510:28d::18)
 by CYYPR12MB8922.namprd12.prod.outlook.com (2603:10b6:930:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 15:07:12 +0000
Received: from PH0PR12MB8773.namprd12.prod.outlook.com
 ([fe80::47a4:8efb:3dca:c296]) by PH0PR12MB8773.namprd12.prod.outlook.com
 ([fe80::47a4:8efb:3dca:c296%4]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 15:07:12 +0000
Message-ID: <81d7889f-b766-43d9-b263-a03725943b0e@nvidia.com>
Date: Mon, 8 Sep 2025 16:07:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.105-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250907195609.817339617@linuxfoundation.org>
 <eb90de01-bf91-46fb-ad7f-ffcbc542c431@rnnvmail204.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <eb90de01-bf91-46fb-ad7f-ffcbc542c431@rnnvmail204.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0632.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::22) To PH0PR12MB8773.namprd12.prod.outlook.com
 (2603:10b6:510:28d::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8773:EE_|CYYPR12MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: 24570837-e145-4711-76c6-08ddeee962e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzYxbmZxKzRuTXhuODdEMGh4NmlrNWtIRWp6WFN3SUErK3pDdzFzSnAzWndj?=
 =?utf-8?B?UFJhWVU2MGhuK2xrWlc4WTJqeFBkaGMvYlVtTXY5RnQ1WWgvVVNsdTRUajlw?=
 =?utf-8?B?RWQrZnB1WHdGbUloYzRYZ3BrNFJSemNYcEJFMi9NbHp3QUd6V3JVcEtzNlQ2?=
 =?utf-8?B?dTg2Ykc0cmlzSmQ2V3dNR3lZcThtcmgrNnUzSllZZUp3ZnZNOUZOZndJOENq?=
 =?utf-8?B?OWlRcS8wcythdVF1WTFlandGa0E3akhGWmRRTjJ5aDJQUk5UeHNJZmdqckxY?=
 =?utf-8?B?N2VUOXo3ZUxFVUY5RWgrQ1VVZlZVellqTS96ZWRQYVZ3NUtySUNTaTRoRlBX?=
 =?utf-8?B?V2RXUUlaZGNwYm1LRXlnUDVoMk14V0Fja3NrdmN6RFdBTjYwZWVOUFI0NEVU?=
 =?utf-8?B?eU9vS0xJS05YL21jZFNKVnlyRE5MaDJheDRaUThPWFlKVlFhV1hnWjRpbmNO?=
 =?utf-8?B?MS9CNjlYMmh1bnZXZkVmL0FHOXJudVZ3NnRiTzBoUnFuQ0pTRlZyeHlndFIr?=
 =?utf-8?B?aTlIYk5WczN4MTgxZEV4V2U5cTduMkRhRndaUXhCeENsaGtjQmdVWUFTZ3N3?=
 =?utf-8?B?dUpqOGpTTVdsWVJXby9TYldMVkZpK1IvY21SeU9zaW1DaWJMeG9JeTRZRjUr?=
 =?utf-8?B?MTJ0eXBoYjNpQXd0TFBDVzlXQVlpanljVXhDU1JpUGtZc0VOdHNnbEd4bDRh?=
 =?utf-8?B?RWpzY2EvbGlOWEJPNElTMkVycjZBVzdHMDFWRFRVaWl0THZmbVlQTDQvbkFX?=
 =?utf-8?B?Z1puUzVQMVE0UHdzU0x3TE0wMkZSaUZOaDN3WjdIVFpRNlEwUHAreEp2bGVi?=
 =?utf-8?B?Rkpld1ZnOGJGSFgvbFYyNlRRSXdQek1PcUc3QWdabXRMNlFFVDJDWktzTkVV?=
 =?utf-8?B?UFp4UXJjRzdkL1V1NkpHQnhJTXlnSzg3VE9UMEpodGJ5ZkZIWVFPTXZWdWRF?=
 =?utf-8?B?eVh6UUMvQVUzTGRUVHBySzFIOGdoSDFzYVdEL000MitIUlNmZkR3YmFIRDZv?=
 =?utf-8?B?clYwcmc0N0w5M2I3c1NFZ1VpVDlONmFRd1JseEUxbU1VZld3MFZPbGlBc3V3?=
 =?utf-8?B?Tml1eUE0TFFFT3lRQlZDbHFoT2xON3ZpUWYxbG9PTkhldEsrNDdrdjBibGZz?=
 =?utf-8?B?Rm5QYTRaemxBV011NUdubFhXeEs4blVHQnhRZ01GTFpBNVJJeXd6VzVsaTg1?=
 =?utf-8?B?QXY2ckpCUFJWUXNMUFZYMjVwS1cwazBvM2YxL0dMWVBMYkREQW1PbEdEOEw0?=
 =?utf-8?B?NHQ3a1Vadkdwenp0QkRlQTI4KzY0QTl0MDdVMmRxSVk0NFpxT0xYL25tdWZ0?=
 =?utf-8?B?UXg0YWhLU2FWbU9WODg1L2lmZDJsSjk3ZG1wYnlWZlZSY1hLZ2x0ZFRHR0Ns?=
 =?utf-8?B?bW0zVFY0UU9ScHFmb3o4R3lDR2hXb2ZtWnd1L2daYjk1dWt1UXA3RGtoRmRG?=
 =?utf-8?B?VTFPaEVzc3lxelRwZk1jVitEYkk1S2w2TzIzUFZ1VDVUNzhhWUhaN05kSURN?=
 =?utf-8?B?Q2RlMENXbGxEWS9aWmFCdHNEZlVQbTZvcWxXeDcwTFRqVTY2cnVHblMvRTVX?=
 =?utf-8?B?Q1pGSi91N0k3UUJjcjVmeDBpenlsV0dWSGRzVEM0bzB1NzQ5ci9GYXZOcGNs?=
 =?utf-8?B?WDFEeUI0K1NBSkRjNU5WRk4zL0lMYk5mUXdPbmx4Q2pCQ1I4MEtBaFJ5T2hD?=
 =?utf-8?B?eXBMbVp0UTl6Q3NhRDQzT2NPMGxNY2duNDdZQUdSUTgxTHNRaGZZUkdJVUl1?=
 =?utf-8?B?VEU5dVdpVzBTZTBkZlRRSGgrb2hWQjIybDFxZXRpWkF4ck9CYlkxcURiQ0ds?=
 =?utf-8?B?aGNKOWo4MURGaUxyMEJJTkIyNm5ESUVNSFVabVRXNEtiZlgrS3krRVAwUU1W?=
 =?utf-8?B?RGttWjVsWG53aXVqdkNBamtTekJkcXFGdCtBMmdTbkpnSmlxaWxnaEcvK1F2?=
 =?utf-8?Q?HE81wUVYC2o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXBET3RObnV5SEl5QnQxbVpnN2s3Nmo5c0xLa2FDSzFhUFhiaXV4Vzk0MHN4?=
 =?utf-8?B?UjR3L3ZiTEVJWmZhcXNCYzVVRkV6NzgvbkxXWm8xVHhvV3ZkdkZ4Qjc5RkFl?=
 =?utf-8?B?eUEyRXZ1bTJQVEZ1UzA1RXh4aEJMZ3FMbHR4bGpRUWhTbEZoNEY5SnU4Yi94?=
 =?utf-8?B?ZklYSE9ocFdqWElDN3NEUkNNN1p0R3pzckVsbVcvRjFTNGYwTUZQeStTcEZF?=
 =?utf-8?B?aWhOdUE2eGIxTm82aWt2dWUzZjZ6YkFZL1gxTTcvMy8rZFN1VWtzQTFwYlgv?=
 =?utf-8?B?V3RURG1rL0Q3RTkxYk1jbTJoSGczNWtCUldPNjIxNHpRYUUrU1JMMlV1VE5v?=
 =?utf-8?B?WklXY2tLNU5tRXMrclhRV3R4MEMxME9ISW93QXVaUkZ2Y3l5VnZxUGdkcjB1?=
 =?utf-8?B?MHNKb25UemtQTGJKalZocnRDZzd5TXNIaXdhNmdVUVY1SlFpeWI4T2tWVDZr?=
 =?utf-8?B?UHJoMlhCaWtoMEl5TXN1UFYrOTZiT3ZPQUIwdm1LRzFHZUVaL0RLZ2srNHBs?=
 =?utf-8?B?QTlieE5FYVMzaVA1OC9Pd081aWgvM2RBenBaVDYwb3Iva25BWTEvSWFBZ0M3?=
 =?utf-8?B?c2ZHOGh3RE93d204a0RMekVNSjZEVmcyMmYwcEYvRTNiN0RHUC9UVFkraGh3?=
 =?utf-8?B?MjhJV1k5TCtqdEVEVmJHbU40SkxLTUdlR3E4QVBpOWJodDBaNS80S1dBa3Jk?=
 =?utf-8?B?VEsrYi9tanhoVFBIRk5KSTZIUGFjQnJrNDlITmZaVVFaK2hheXdWUG05dXNr?=
 =?utf-8?B?K0orY0c3azd5MTRwb3BPbHFkOFNkR3RMUzUrQjBDdlQ5UWZTcEFoNDBiVGdK?=
 =?utf-8?B?ZUZqQkRkUG9FYXRFaUN2Y2w2enFHd1hWUTc0TlJqOG1LUGsrcGRUc0pYbFg5?=
 =?utf-8?B?L1VUeDhZVzRIQ1BBZXptcmxScnRNU2VhN2pRWkZjbTVWODFEbE1USGcrYXg3?=
 =?utf-8?B?dko4REg2eEs0N0FNazhReDFFOWpzd1FBbVc3cFFKa3FNendzemR3U1A2YXpW?=
 =?utf-8?B?enM0dE1neDZYQ2hnMDFnL3JBVmFHMDI2TG5aRFZFOUgxUzBSY2xpaURSQUhM?=
 =?utf-8?B?U2FHaDlBeS93SFE5ZnllYnQwWVhHNnZVaVRJdTJsOHVROHJZa3haTk5BZGpr?=
 =?utf-8?B?N3pRbGRaMUg1S1haMUpOdmNndGdYM3lWNEFpOFhiemZNeHhDSXhaZGxSeFd3?=
 =?utf-8?B?S1k2bloxaDNwL1JTZHJ1ZGxrZ1EvZEFRbXM2SlRFS3VIcFNLajVLUTB3R1U2?=
 =?utf-8?B?Y2pxSUwycDBSWUQwWG8xKzZadDhLakN4Q2tic3ZmRXA1dEpXUmo2RjFtcG1F?=
 =?utf-8?B?MERCR2c5YzZvTVhVU0k0aHJEblBxSkc2cTRyZ21ReWt6eVcxSmE3MmdnKzRL?=
 =?utf-8?B?WktYdEhuUnZtdFFET1pUSm5oUTJpNUUyQzJzTW1Mem9BTUtSMk4rcG5OYjlp?=
 =?utf-8?B?M0RMZXBXdThkUEUreG52aHdjZFMzZ2ZsVnVtZTkzQUtkSDhDUm0yTysycG45?=
 =?utf-8?B?QmJ4eTBuN2Y0QmlMTnp4L3JibEdodjU4RWZtVUNLQm9MZjZ1eGJZNVNDZ3dr?=
 =?utf-8?B?TXBBQU9wd3VnaG1ydmR5Z0FHbnFHSVB5QUpoZ1pWRWtuZUEzaEdMTUk0TE5C?=
 =?utf-8?B?M1I3UHdrS1FmN2NUb1czOU9sbThJdWU2bTRDZzh2MDZ4NFFLZTZ6Rm9RaUdn?=
 =?utf-8?B?VW8xbk8yWDd1ekhWV0lBZmJEK0p2UnZjWHBDamFOd1FIMk9zN2VwNEx3RWg1?=
 =?utf-8?B?YXdGU1Z6RWU5bVIxemlTUFZyRjI1ZzBEd2lTeFdtQWJYRCt0YWo4U3ZpMzA4?=
 =?utf-8?B?Nmw0WEQyczhwM25rOGROc01vc0p2ZW1aMWR4VG1IS1dTanRCQTlnVmlHdk9M?=
 =?utf-8?B?M28xUFhpc2Y5WXlFMVozVDJ5UE9GNkY5bUhvTVhPYlg0dXFHWStlcmloQzdP?=
 =?utf-8?B?bHNrWW5qZjJkV1hHcEdRQVdoVHdNeU9sMndNWHhKNFlmQWdlSCtCSnk4bE9z?=
 =?utf-8?B?WFV3UVJLVDQySVlTaWpmbnBzVkdlNTdjZFN6S21DckJselF4OVN2emlEKzky?=
 =?utf-8?B?bXpiN1RWNDhYcThUejc0Yzl1TXJGbk51MWZidXVBN1dUUnM3M3kvUHhzN0Rm?=
 =?utf-8?B?N09aL1ZpNUdQdlZkd21Fcnd6SjkvRmErTEtlTE9hdnU5cnNRSTF6b295VUJD?=
 =?utf-8?B?TVpXOTdrYUR4LzNqNERJaGlXMkxjekZXbTY5cktPUjlqYkV6MXJ1R3RIS1JW?=
 =?utf-8?B?TklFSUFDRTlnTWxvKzU3RjBlRm5nPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24570837-e145-4711-76c6-08ddeee962e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:07:11.6555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MchGvRcIYxWKm4ojAgOqRxW+Op12wGLIyLaBnaLLBuqqq5d6b5dMKU9uVpJf/czirCwJuyy4cyD+bFMhFhAMDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8922

Hi Greg,

On 08/09/2025 16:01, Jon Hunter wrote:
> On Sun, 07 Sep 2025 21:57:16 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.105 release.
>> There are 121 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.6:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      120 tests:	111 pass, 9 fail
> 
> Linux version:	6.6.105-rc1-g235604b18bff
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: cpu-hotplug
>                  tegra186-p2771-0000: pm-system-suspend.sh
>                  tegra194-p2972-0000: pm-system-suspend.sh
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p2371-2180: pm-system-suspend.sh
>                  tegra210-p3450-0000: cpu-hotplug


I see the same crashes for these failures as I see with v6.1.y and so I 
am assuming that it is the same issue as I have reported with v6.1.y.

Cheers
Jon

-- 
nvpublic

