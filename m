Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010069.outbound.protection.outlook.com [52.101.84.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060EB1C8FBA
	for <patches@lists.linux.dev>; Wed, 31 Dec 2025 13:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767187917; cv=fail; b=FHg5GINF2uTfIpUW1PQ1nz/0aB4PxW0QSwvJHNNQx7TIBdiL+d+ASLc63xCVDOw7uknVgaKQPdLQrUdwQAEsp9ImZlrlhpN9AV8z2L29ZqaCB02FvBGZi/OTrZMXo7KdmKGWrmcn45hCP+Tmy7FE4mp1H15jgR/e+bWdUjxCfzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767187917; c=relaxed/simple;
	bh=f/5daIrjmAkbKtp1CTtUqhfH1QgW67ShopmV95l7xlA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MU2u0OlsCq/e30pc0DFZVSWwVjmxG4P+mDo4hmlr5ZY2BOUnIiB+34kZrBblWSAzI6VK++J4Mw3XgogaAcQNLgqMP0kOQtaLy2qcQa0SpJpVoRAAJ0nKI8/DXwtb6cICJ3xYiI7DoEtu/997x0cCDZQ4j/aln9vKjgyYfjiRAMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=NrT247sR; arc=fail smtp.client-ip=52.101.84.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="NrT247sR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jtE8ohbZcZJdaNzhNG3dPo19JSUcCfXHzTbQQr85Zjk+kPD2qamC7z1AKIxp7Sr1qonAd2Emy8LjyFxnaNHZoNrxpLxqwilxgvTUL4b4YrGkZLKYyaPVGiwMTpZkSpJJELbHdW7MHevrB61KsjAbKn/PEX2VWdv4kHxHTS7bW//fJVTRdKHIt4iBGDHyS7pkY0I/iBDioM1P7cuAjE2ywmsVcLdm5i8LwGtqiYSfcQkPbYNDNROlNZmQImwQJG8mR8NstTzVnxaZHisVG0kpaAix4Dda+mme2MlzDefz0kNV4CC0nuoc7OLFCnPEAsjEkIsj3/0qJqx16IX+Si82AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnPUZLR3RhlPSDMODDpKAhK+pynq1LjCTnuhXkCqlYU=;
 b=PYLKv1aM5xFyB4fttx6BguTEaDWlqYXPMsGpT4qhQtcA35m1WGGt9TmofglHtJSBBPP1wB1eU0HGlkFRomDywpIISHrmGuVx6VPol9iIvCEDLPy2kTYBSAvv6J2eCFA2WKNxkzjLREJezSfH/PrJZaTjLJcXpCt/lkMrQNN2ealRjuyItS57Wsq7p88VXXBFtu9h4hhLqvXNiwhaL3LUeonBuF3/Y1RwPNXRPsi3exhWTmKDQbgU+o17cXbYY8AGTRYsmqJgehe+Q6ggR5y9SPzAaT08a4UJtrE5G2bveIo9W51X9SPUbTSSjLkkkTkCeNvAkLYOZtDg/Zi772jPJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnPUZLR3RhlPSDMODDpKAhK+pynq1LjCTnuhXkCqlYU=;
 b=NrT247sRKTwAKCV94LZinpsSc1rQ8gjzUXycacInIzlknsjIZip2xS5fcwzFkCk8OSfirVyUuaRYLFFuT7cddSjqwvyvCXRMEced2hsf9bBDTU1F+EYvp1Oxr30tw/ytk29iskXbxMVePzCn5MV/52lai3i/xXupY3rZPV2RPoliM8SMbav7cuugu44LOyplhUjxf4okbgzdJoZsQKdzmWKfip42pn74mSfFWQelZXs08hQG/SpQLuefoHetZH7bhoBQUG32NVRsrRrEjzW8uGrmmjuAC2G//3uHFWbP0lFXMcv/NA9d8H/n4w2buXI5str65EGnfSUD3xNd9tg/dA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:588::19)
 by GV1PR10MB8903.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:1d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 13:31:50 +0000
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8fe1:7e71:cf4a:7408]) by AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8fe1:7e71:cf4a:7408%6]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 13:31:50 +0000
Message-ID: <2d157ae4-0b32-4e9e-8079-d3d19343e40c@siemens.com>
Date: Wed, 31 Dec 2025 14:31:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 106/626] wifi: mt76: mt7925: fix fails to enter low
 power mode in suspend state
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Felix Fietkau <nbd@nbd.name>, Quan Zhou <quan.zhou@mediatek.com>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162449.350348931@linuxfoundation.org>
From: Jan Kiszka <jan.kiszka@siemens.com>
Content-Language: en-US
Autocrypt: addr=jan.kiszka@siemens.com; keydata=
 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
In-Reply-To: <20250527162449.350348931@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::18) To AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:588::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR10MB6181:EE_|GV1PR10MB8903:EE_
X-MS-Office365-Filtering-Correlation-Id: e2956b9a-d93d-4f78-93e9-08de4870f3ac
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDkwUlo0V1hJVWpTSm5tbVVGRnJOc0JmTUs4bUpEQTc1U3IvSWpBcnRlMCt4?=
 =?utf-8?B?elQzY3pOb3FnZU5vMGNCTGQweHRiL1VPRS9HQS9ja0QvaDA2RG5HSGE4Rkdp?=
 =?utf-8?B?MTFhdGZ6TmYxSmtZYndEK0s1UUtSek9ZbFluR2kvaUduZlA4THhxS2FncmhX?=
 =?utf-8?B?cU5YRGpJbVdCdms0eTQyWi9oUDBvdTJGa2llZTN4TWRSa200RDlxSzNhSUJI?=
 =?utf-8?B?UkNtbk5xbEVwN2tRbEU5RGdGR0I1QWJDNDlZRGw3aTlJakR1bWdxRXpnNTkr?=
 =?utf-8?B?WmRBdDlxK2xzRTROeU9ocDlLaDZlR3pQYW8zM0U5T3drTE1SaU00WE1EN3N4?=
 =?utf-8?B?UG1KYyt0VSt3bm5iclp4ODh0RDVVWTZZcUE3NmFpU1JXUERVa1QrM1c0bFo2?=
 =?utf-8?B?OHFwQUdnbktZVDVmZVFSanJ2dUpWczFyTmYwYWlUWDhJcjFoVk1BNjBNcWtD?=
 =?utf-8?B?S2NZbmVoVFRzNHJPT0N3blA1OGZiMWhCN1R4M2NqKzV3c2RrNnFJVGQ4eUh6?=
 =?utf-8?B?TDRadmRvRVlwcER0WXNGRndUUFFzVVpldWgwTGt3Ync1R2ZkdXQrZTRxZzhV?=
 =?utf-8?B?c25mN2tQclY0b29Vckh4TnJHeDNtRG8ySGw5b3A4Vkh0N2FJK240b0ZqSlBO?=
 =?utf-8?B?NDFhbmVkWWoybTd4dElacUZmVkd0c1IxWHNwZU1BK0pIanBwdHY3cStFRjV0?=
 =?utf-8?B?WUpvL1RnQ3YxWnNxaWNnVmlYdzlCYUYvZTZTNVo5YU85cTlsVS81MUxJdU9q?=
 =?utf-8?B?M3llNTJPc2pFUXB6VjBzVkZMc1JpTEg5b1BaL3pzZ0lTVDR1UFE2bWFXd0R2?=
 =?utf-8?B?WkVqeDB0Vno4OGV0YTBGQS9lMTF2dlFmNFdYams0WWxxNC9rdHVVeVphTklz?=
 =?utf-8?B?M0tkVkNIbngyT2FoajQrckhFQlFJNEY5b3YreS9XckFyRVlHaU0yN0EzZ3Bx?=
 =?utf-8?B?U2lUUlBFVHZKWmFQdnlCWGdHYld3bjNvQWlEK25CTnJ1ZkR3UzZCWkpwWGhV?=
 =?utf-8?B?UW53WThWT0t5MzZRYUNvRGNqSHFrU1AxYktMV2lCOWx6WityUDNsYmUrZGh6?=
 =?utf-8?B?eHZKWTQzQ1Vsb2lGajd3TEd5eHpXejF5SEduWVBDWDdKbmxsOTdxWUh1N1g5?=
 =?utf-8?B?a1dwbWYwOGJYUWY1RyszTDJyZ0srallaRnJZZ3lPOG4rZWxsQm9YS2NnbjNj?=
 =?utf-8?B?NnhSdUFrYU9xR1ovS0hBdFczbkY4aW1VNURnRGF1cXZBRXBOeStzSGRvV00w?=
 =?utf-8?B?NW1CQXBiV0JlRE82ZVZoVXRPT3p5dTVLUGZOaEhBLzVWTit2aXQ5MkdLQThu?=
 =?utf-8?B?TzhselpZOEkyQUlEUGlJdnlxSjNwMUpGSUg0NkY3QWFwVUpPZHpjOXo4QXk4?=
 =?utf-8?B?WkdoNSt5YTlNTnY0bWtCckRLbkNsMXRsVmNOR214Y1RyQytmU1pYVXZuQU1L?=
 =?utf-8?B?bjZsWnBWdWhzbW05UUsyM1hENW52a20yREkyZEJPSkFMdnFLNUxpR1dXMUIw?=
 =?utf-8?B?V0lTWGdjK3F6STVLZHFvelo2WmFhV0hYN2Zhb3pYQnJKRkU5bGliTi9qVlNv?=
 =?utf-8?B?ZmJGZE9XR0szbXJCL3RsT256aUpRdHpuR1RYL1VoaFU0YXJBTTlrcHE0alFz?=
 =?utf-8?B?SHFkaWVXQnRzbWNPRUY2SGRCS2xoRmhHczdBVi9zVmx3S0ZiQ2NXZU5lM3NR?=
 =?utf-8?B?dmRBZzZSRC85b3JUWlFQUjR0Yjh0K2Z0TkFaOEdmOHVOVWdzd1pySjBLbTdi?=
 =?utf-8?B?cmgwdDkxZkorOUdSQWVWcXBBNWgvQ2ovaUIvN2EvV2UvNGN0T1JiMjllVU4y?=
 =?utf-8?B?aWNFZlhpcFpKU3NYK0xRbmF0NVFpUHVpV0F3clRIYVpxYjRSUHhnRTdyU1Ny?=
 =?utf-8?B?cThDdFhTWXkxNWZmUUlIQjFZQlFBRVhTYW1Ub2NiUDRhMThRaXhaLzBQQU10?=
 =?utf-8?B?NmExYis2d3VuZDFZZmNPYnk5WWxQMDhVOGcwN2JvaHg2Ukt1NGtXNnRrOTlt?=
 =?utf-8?B?S2FYbTNpMXJBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVh4Y0tNT05LMnRYbkJGZ1N6ZEVxVEZCT3Y1SUNmN0FsS1pkbE5PZmVFMXZQ?=
 =?utf-8?B?QkxqN21EM05XZzVuaTdSYW9oZkRsSkljeXoxa2xMVEkrZklwcE5hWmhDWWov?=
 =?utf-8?B?NUwvUXErd09XdkRkNGdycGQ0b0k3WXRybUNKZ2RXcDZ6Q3h3eUdqdHZZUm5i?=
 =?utf-8?B?dXZLanFGd2JlUzRvRDhjUWhRdVMrUUpxSERTK2VVK0thTnJOZ2t0eVJDTmJT?=
 =?utf-8?B?WkppQ0szYWRHemxGaStxMkIzNE5VTnJLemRuMmxXTFJpQktQOGFIL1llUSsy?=
 =?utf-8?B?QkJYTlg4aHNmUnloY1krclZSeFhoQWZiNHZUaGxQOGdGK0NUZVY2ajVkUE1O?=
 =?utf-8?B?NFQyeXpjUG5ObUQ3SVEwMkZuczFocFVoV0RiTDBVUXdCeklyNmpKNVBTKzlz?=
 =?utf-8?B?aUtWZDlRTTVGajF1MVZIckJjK1hKRVJ5U1FyRlRNNlZlNVVMdUpITmQvL1Mr?=
 =?utf-8?B?K2dGd3JsTmdwWjlwbm1ydUR1WW1XRTZwVFlGcTN3Z1VHaUhmVC9lR2NhbFNH?=
 =?utf-8?B?czRxb3NjMzdkQy83a0pxNXpFTWxsSGlTNmM0MzFYaU05OXpBMk40T3l5dFE2?=
 =?utf-8?B?T3Vqcnd0OWc3WTN2UXl4dTRwSWwvbEFBZ2VGenVCQTFNd2VQTVRndnVXQWtU?=
 =?utf-8?B?UEF6QU8yUDhoTmpjWmtnc0hLdkNBVVk2UjBwU2pheGJCNmlLSEQwTGtaTUVW?=
 =?utf-8?B?NndYN2owbDVNc3NyRG9YS3dJaWU0ZlF1cUpjQktLQ09ONUowcjhtWVZvOW5K?=
 =?utf-8?B?bDFxZGh4VDFIdEtTZ1ZodGlRZXZOYzJ5UWJvdDZyVzV4ek0vOFhQc1k5Wkdv?=
 =?utf-8?B?SUhCOWxGRk1TOTAzSDI3QWd4VjVRYTltckpPbGZkakQ2amxSeThWa25JNDJ1?=
 =?utf-8?B?ZlgzQWZWSnN1c3prRHFXcWVzY2ZPb20wbGhySExvQk9xU3dRbjJZOGs3UUl1?=
 =?utf-8?B?ZEV3NkNFQ3BEaXBqN0lObmhPQTRNSmRjVHd4cEt1NzRNOW1tUnhLUjAxdlRD?=
 =?utf-8?B?WWtWSExiKzR0N0crcUI5dlNWR0RaSWYyeHhudVVaamtsS2hVVVNvMVFPRUpX?=
 =?utf-8?B?RnQ0R1l2cU5QaGhycW5PMVJZeWpSYmVjSS9WYS9tZHc5d3h0Z0FoSWNERnVR?=
 =?utf-8?B?SlV0VjJGV1ZhNml2aVMzdk1vVTcwTG5VZmdJL1dNdHBZaDlKcGRuM0luNzJK?=
 =?utf-8?B?eDB1d21yc3dkMDdhTnpsL05WM1J4UmEzY2VTZjBtc0dWMWJzQlhONGtsRVJQ?=
 =?utf-8?B?T2RPTHg3UHNYOW9VUWdaL2F1d2JnSEhRcGNLV2M1ZTYvZ291NGFkVHpqMU0z?=
 =?utf-8?B?QmRkRU8wWVNrRlJNNTZTMEF0dFphKy9sODNQWkpOdzMvUldoS1JiVEU4bTln?=
 =?utf-8?B?anErVW93L0lFY3JrTWdDaDJNKzVVUXR6OWQwRHJ1bjhxY0o2b1QxWjhJWXhw?=
 =?utf-8?B?RG8xSU9UNFdQT1NsekxMVlY0Q1Vod2FBMmtNeHY1Z0Z3YTl0Y1gvYnVDUTBy?=
 =?utf-8?B?R3oyODNUWHMwTWpFOGxjc1JpSFgvMWZGTjR1VGVRR2ErVjhFV1UweER6b3h2?=
 =?utf-8?B?elZDV3Y3RURLSzMvV1ZjRnFqTzJsOC9JZ095eVdCbE9mT3pVVG1uYnZ5RG45?=
 =?utf-8?B?Q2VFSDJDQ3QxazlSTURpZXJsOHF2M1hUMDdVbm5PbnlhUnE2MS93REFwaUc1?=
 =?utf-8?B?a0wrRWZmdnIrelRqemd5ZFdSUFI1THM1RTl4QmVLa011Z3dURU04MjVEbndi?=
 =?utf-8?B?aUcvOVBSc2FkWndNb3N6a3hmczJKUkZVb2NuTTFablA3Z0RJTWdpTTFEajM5?=
 =?utf-8?B?NkFOaU9vY2J5VW5QYWxxZTlkRjNoS3JuSVFMTDY4c0FmeFpqZ2ZMQkhhV2JM?=
 =?utf-8?B?UGpYemNQNitLRVVUSlk1UWlsaUFKNXJNRDJsOUd1bXY2d05iS1ZIa1hrcDdX?=
 =?utf-8?B?MWRhVEl0QjFxS3ltaWVjWVdLWEo0WW5aaUxCcVAyN0hIRTRibnhDeUdTTENE?=
 =?utf-8?B?UUlmMDNHYXFVemtYM0M5d2ZCd1FLNEpVVDFOcUdsZ1Y3bnV5Vms5allwVHVG?=
 =?utf-8?B?elNXelMrWlNYZEozRzRPU2d6M2toa1RVRDJ2eTJ4TTFNYnF6S0dtNjUvUlNB?=
 =?utf-8?B?MFhSTG1sck9sb1AxcUEzV0RXQ2RaaGdTdVV1YzFESlI2NkpFODduUTYwTVJv?=
 =?utf-8?B?eWhaWklSSVhBQjE5eEQ2NGd0MGNKVEdXSEJjZFl3SGtHdS9CYkFVODBiQnNH?=
 =?utf-8?B?VlhocWE3VkxlOEtsdjliTmhHempxdTZXb0x4bE9EM3JXaFRmOW8wT1paa2o0?=
 =?utf-8?B?ZkVnY2V6d1pJclNoY05HbnRJRFdJWUtIZnI0dkFHb2lLMkNkdk9Bdz09?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2956b9a-d93d-4f78-93e9-08de4870f3ac
X-MS-Exchange-CrossTenant-AuthSource: AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 13:31:49.8635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDTK5LpKU12C53cqCrCQF77t4BLoX4yZn2uAhKDgS8JgtZFvFEubtkiXPp6m9D9W5Dp8bCJwFrPDZrCyFDcjGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR10MB8903

On 27.05.25 18:19, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Quan Zhou <quan.zhou@mediatek.com>
> 
> [ Upstream commit 2d5630b0c9466ac6549495828aa7dce7424a272a ]
> 
> The mt7925 sometimes fails to enter low power mode during suspend.
> This is caused by the chip firmware sending an additional ACK event
> to the host after processing the suspend command. Due to timing issues,
> this event may not reach the host, causing the chip to get stuck.
> To resolve this, the ACK flag in the suspend command is removed,
> as it is not needed in the MT7925 architecture. This prevents the
> firmware from sending the additional ACK event, ensuring the device
> can reliably enter low power mode during suspend.
> 
> Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
> Link: https://patch.msgid.link/d056938144a3a0336c3a4e3cec6f271899f32bf7.1736775666.git.quan.zhou@mediatek.com
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> index 5b14bf434df36..2396e1795fe17 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> @@ -3287,6 +3287,9 @@ int mt7925_mcu_fill_message(struct mt76_dev *mdev, struct sk_buff *skb,
>  		else
>  			uni_txd->option = MCU_CMD_UNI_EXT_ACK;
>  
> +		if (cmd == MCU_UNI_CMD(HIF_CTRL))
> +			uni_txd->option &= ~MCU_CMD_ACK;
> +
>  		goto exit;
>  	}
>  

This one breaks suspend when the mt7925 is in use, affecting
specifically Debian trixie with its 6.12 kernel. It seems this patch is
addressing issues that may have only showed up after [1]. I've applied
[1] plus its direct dependencies [2][3] on top of
ac3af695c4b001b0dfdb311f2b4cfb81b1d3d54c in 6.12, and suspends works
again here.

Looking at the whole context, I'm not sure how important also [4] is for
suspend/resume in 6.12.y. Suggestions welcome.

Jan

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8f6571ad470feb242dcef36e53f7cf1bba03780f
[2]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a0f721b8d986b62b4de316444f2b2e356d17e3b5
[3]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1b97fc8443aea01922560de9f24a6383e6eb6ae8
[4]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0e19942e6d1c735c95b40123de1d6e81dc2c128d

-- 
Siemens AG, Foundational Technologies
Linux Expert Center
