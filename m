Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51CD204088
	for <patches@lists.linux.dev>; Mon, 16 Dec 2024 11:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734350103; cv=fail; b=XkZVrvKkG0jLmYJ4dFt5ccQULA/d9lf2TuFae2yoVKJgtGa4GSg/xqEQV/Py0ftd9nxbR4OOJEoNVf3f0Y5SHbtPVmiOm0pVTIyvtzd227d/8dSQr/nHV/07ZrdXojROcBPzdWhhBvC6tJhHiXZaABxqsH4Mkiem1QFLcD3F5HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734350103; c=relaxed/simple;
	bh=SpTAQpbdpMM687hQjrtjc1Z9ARYxqFXwHM0qAe+8kAA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jLPMGFidVPwLWxEGuPneKLKyy2GeqR+sm2MxWZGUTPJM1HoHFgakCB6kQSUcI9CIPIeAL2+7zaHEhR+mteZM0+UXYAvNX31K/3ecjmb8vDoTe89k41nfcVLtMs9aWuqoKIXW1NcCTDK0X4vYU0+CYoWbZmmKH+fZCUMTYNEBfzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iFHGGEoB; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iFHGGEoB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyW6yTYG91aiIdHs7ykAFfTHJygpymj05YCxXPzzD0hbcAOJ2JNz9u7Id2gSwcpH1AAjpwdZ1bXER3OCUw00j+7sKcw7Q25RoQDRfUzMiKTKrAbQs4XEaTM5tmDVUFhAhE5+C1t26oilYhuUbzVW6U1k+8d+RUd1k+aMwd9tLr/7vbGUut/DfMQ1tbIasF4dq/9QDBFQ3cJ3EJqZpb/Gyp4cJZkHcbYiVyNyxlsFRPOI0C0nvAW4jYQj/g7efY6UAL4c2NPFBPSo2OpwOzFXH1h8t5kYKTdwAJUSZAjfg38ToPSa8UvPxKaQWbbTJorLD5Rn4t+8QN6rYdzqUhK2iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZDbTwAXQfqKCMUoDS8Lc9hLNWk2Ts7Zc29bhcEBk40=;
 b=IJhBAdeuxPqqpfDSlFhBH1CSMHyVTzryC8gAbeHvMtKmmiImmPuaSDvrjo9RfaoSr0eYA+QAnG2QktAC49TLFvTd6H5oVvHCMcI2PolOQOWKT4TZ/WFId/fGzDEhE4mydB2p60LQdvjV07TiVbnN8t8OwckaiTMTYSPDg5qxBQIBmFpQdH7uTmZr4CGWFhGCDQFBTlt/CB74vsPZrPuiLUc3EfzkeoFOc/q3lLlKv4n+qpTaXrK7jxHLh/ZcXHCeHsdeBYBkgovpIdRx9gCxIhQCCguiWQtFul5+Cs9KzEBTrsXYiCWQmnrQ1CnP6uV14ibA5IH7+y5YTXFLX9+wCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZDbTwAXQfqKCMUoDS8Lc9hLNWk2Ts7Zc29bhcEBk40=;
 b=iFHGGEoB8FUAgI/VYh1XMwRJHS0vhPOPrY6uTbDsAPhi/GQifrF+Kd376LWt4ynAgpbV3CDRIhEWzgKgj+kxwLWpxE0qqybHeoe0i6M81OdpF+KdD7/e46Pq2qdOHR0ta+BvZusRipBd1PNQ3ahcOzY3aPZ61HjvLneoukzdnQ9RQnVF1adLPvgLunCjA8W+oTaTi3iJem3q2uTtirrKgUhkQ/8ayXiCNbsFvGS59T+9FrkyMaNBUUWiXUaJpNWW7tBpN7PoH77mBun+f8dPzkI7mSerQrHmdf1G4OIxK5IajEfvvwKloNg/Fmt6+L/1o/z8ckqtRQcGpdpAq99PcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Mon, 16 Dec
 2024 11:54:58 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%4]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 11:54:58 +0000
Message-ID: <c304c70e-e69e-43fd-82ae-46e964ab84b2@nvidia.com>
Date: Mon, 16 Dec 2024 11:54:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/467] 6.12.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20241213145925.077514874@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20241213145925.077514874@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0119.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::16) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: dafa3919-7fae-40e2-5e0d-08dd1dc87717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVZTQWlKZ2l5Z1loOEo2SDJSNlk3OEpTcFhMSUNKNERVUXI2aW9ZckJBMUd0?=
 =?utf-8?B?U3FuTE50VkdQY2dLbWlQN09BcVdVb0xoMTdMRnp2dlQxeWlVcjNXTXdlSjhJ?=
 =?utf-8?B?eHZaYUF4NGlmSHEyQlZHUENEMk9VMCs2eGVHQWgwMXBlTTJwYjkvTmo3aUVk?=
 =?utf-8?B?TXAvc2tKSFpocVlMN0Nyd0gyTk1JUFZ3TmluNDZMSTdnT2VwT1p1amIxek10?=
 =?utf-8?B?UFI5Q0IyM2JpNllQa1FZc0VPNExYVVhkMWg2VG8xVXdsOEZLTWNReTl2RjFR?=
 =?utf-8?B?S0ZuU1E1T2tVTnZ2V0J4eHc0d0h3bnlCUVBBUEhUNzZBakpHd3ZsamxFL1lk?=
 =?utf-8?B?QmVwelpZNGpMRlNQRm5xelZNRFdmZkN0c3V2Nk5NRmorMTllV1pTK1lQTnRX?=
 =?utf-8?B?SFdiMVlKQ1lmQ1MxNVlEeXdWQmQwUi8xMmE0eVZ3OGdlNEh4eE5hRm1GR3VU?=
 =?utf-8?B?ZVpKUFVpYXViYnVmbE9PQmRleSt6THpDQVJsUS9qMCs5R3lOQzdQWmVSTElm?=
 =?utf-8?B?L0JkUDFSb3VBVjBUdjF4bnF1N0cyQ0lrb0tsanlxUDFlelRIWEVpOEtwSnVo?=
 =?utf-8?B?ZUQ0NDdUVmtGQ1UwNlk5VHB6V1I2YUtBOEw0MVJOZEtGQ01zK01iVU80dEpL?=
 =?utf-8?B?RjdxODJWNUFRbHo1VDdycTZkbEYyWjhiQUZIOHlJa1g1OVI3ZU80cGRhOWVE?=
 =?utf-8?B?UHFORkpVbGN0QXNzR0R1Q3hrbS8rb2x3ZTRZQUo1R0xJdGhDUWpEdXpaYWNE?=
 =?utf-8?B?bmNzVmhPUUd5MVk2bng2Qi96alpsanhxRjNLTDRnTnhWTkFDVnAwcEFUOUw4?=
 =?utf-8?B?eEZISUJJSEROY1R5RlRLZHg5MHh3T3JKVkRqN3VwUzEzQ3ozWktLUGR0dHZG?=
 =?utf-8?B?Zmg3eGsxeitPNmRyd0RSVTN6QWtBQ1RaU1p5ZHlJMG9vQmtXOWdMZFVPSGdx?=
 =?utf-8?B?OFNvZkpyU2lMSHAwREdFRk5odG01d2dGK0twNHFMMnozQjhBNWhwejBudERk?=
 =?utf-8?B?S2l3WFhDSXh1L1UvZE9mbTIwTTEwQStXckUwMkJGbVlCZWs3VmxxRjFDemdD?=
 =?utf-8?B?M0grMUl3ckRjWk8wdVFra1c2N2ZMOWVpaGNOeFNaYkRubFYxUklwZ3NlVHlp?=
 =?utf-8?B?SzFhdkRXN0ZXTUtoVFk1VWRUR1hucm5mMUdNTmJ5NjBHQ3ZobTROQmpndEoy?=
 =?utf-8?B?em5PM3ptWlIvOHArWDA2SmhtUWF3ejJLUnMrOHFwZkJVcFhrMDl1K0hHME1K?=
 =?utf-8?B?b0JHdTY5QThlbWNnKzh2MDJTR0JCZGZNK2daaHRiQUl3dXRoSmZOVlMybjl6?=
 =?utf-8?B?MnNneTV6R1ZacjRvdHgxaUN5b2FCNENmcnRNQ1V4eWZyVnVjOEdZWEgwdHBS?=
 =?utf-8?B?RkZERnJVOVRBSUdyT0czT2dYT2Y1K2ErVlRubXhiTmNXanFicFVwWGZSVUVS?=
 =?utf-8?B?Qmd5bGtXdjNTNWFncGRtMlRXMzNTR1dDZy9nOGxTSEh6clF6aWR6d25zakVL?=
 =?utf-8?B?bmtYbE5pUUw3cTFiWUIzVmN0Y1V0SmRoVWg5L1lmZVUxRTJUM013Q0xVbDJr?=
 =?utf-8?B?Y0pKZzRmb3FQL1NwWVg1RU95T2FscitGSkRWbnpCTi85QnJGaVdMWVNYc3BV?=
 =?utf-8?B?c3VWSHlod3RRTDRoNGpudWVtSWNWb0FWWTlmdGE1dDBVMmdaZDJrZnpkb2g4?=
 =?utf-8?B?aDBQenVwRERONFUvUnFZMGppdlhWdUxtd1RGVDFJVkFTSGJtZDZkNU94TytT?=
 =?utf-8?B?aHF6aERZUFhDa0xnUHl4SDhnUy80R290b25DbU9BREZYMlpCVzIxVXREY0xF?=
 =?utf-8?B?dmsvbWtSckZFNkRLNWhQSnZ5RkloTkk2eDg2K1puck53VXY5Q3Vmcjcva1p5?=
 =?utf-8?Q?ffMUsRprNPMJ+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDJsa0dNdmVxTzB0UER6Mm8zS1FtTm44enQzcDhJQUlHWGpVN3pKWlVPQmhP?=
 =?utf-8?B?S0FZWlVTMlhNeFNoOEJrYXRlNnpyU0QzR0E4cm9zTnFNQy9Yb3d3empySGN0?=
 =?utf-8?B?TFpDa3ZhcWlTclpWOTdCU3RqaXpycDVKOUxmRnFuYTdUL0VQeXduSlVQQklG?=
 =?utf-8?B?aDR2UUJFaVRPbFhZNXFuZmhjUGxZSHRWdHQyOHQwYlJ4dWVNYlBvTmE2UTJk?=
 =?utf-8?B?WTJqaWF5VWFSL3orQ0tGd3c4bU0wYUtnVjdCSEFvV2t0dEV3cVUvOFEvSGRw?=
 =?utf-8?B?YUVnY3E3UU9kTW9SRE1kbjZVS29BZVBnSVg1bGFGNjFrejVJNTZzWEprOExo?=
 =?utf-8?B?YkZZd0Vkd2NCSzE3WWxEaldCTnhLRkRmNE1hL2N1aGQrb1g0RUFGTGNFUTF4?=
 =?utf-8?B?S0tBbnlPRnh2SG9vaDJGdzVaRnUrRkIvYng5djBQbGdqckliYnA0aUpCb3Jr?=
 =?utf-8?B?VWpKdTBJcWtabnMyNjQ0QUNHMnlMVmZUSEpxdVQ1K1NKTFhGejM0MzFpOW95?=
 =?utf-8?B?L2RMbE11MFQxN25FYnhpTlNuYm5Ta3g1TFdBaEIzK0M5NEV0Q2phcUVYVlAz?=
 =?utf-8?B?QTdWTkQxaHFwZzB4ZmdZNy9WdTF1ZjdTajE3L1A0a2drMVk2VG81RjFmTm1C?=
 =?utf-8?B?UUI2Ky9TdlNVUE5wa1oyZGVvQU1PbkV6aURZRDYxdjdDWW9IWlZGQk1IS1J1?=
 =?utf-8?B?QmQxUWJPbWV2bWxkODNEWTNaWHZnYm5IdHVhOGJRSi94eCtyaFVUd3VtUEJp?=
 =?utf-8?B?Q3VKYVJRcVBkMzZ5Yk5WOVlGeHJkWU8wcnZtOWpjMTh4MklhK1ZEdDZmMS80?=
 =?utf-8?B?QVZpQ2p0d3AvWjlVNVNHbFBjamxUdmtyREtUUE44RGVoenNpd2g2YzBOdmdw?=
 =?utf-8?B?aU1pNk5yS3ZYWGlid2plYWhWcHBrY1I4cEVSZVAwOTdGWERSYUFGc1pJRXJx?=
 =?utf-8?B?TXByc0xhN1pIZi9lbTFFWENEYm5QNnZ6OHNqNDJrUUU4cDlqTjh2ZXF5T0t6?=
 =?utf-8?B?bFRFcUovUjJ0UmVRcmdBdGlUU1htSE02eCtkaFk3ZXVnbEVjY1JrQVUxcEg3?=
 =?utf-8?B?Z3dDTnF0aVhOaWNnWjNrYnhoa2VqODhnK2RPMkJiNnVzZUdaQmFndWlPYnc5?=
 =?utf-8?B?VTl2SjNvcmZzOXlkM25lZytsb1QzYS9lSG9zQ3JCbDl6NFhBQWd3ZnpTa2ZG?=
 =?utf-8?B?dmJDdTROamU4UUQ3Rm5QYUcwU0p0WVVKdDMzQTA2TkRjeEVVTnNGa3lYc2h4?=
 =?utf-8?B?ZEpoT3J4NmZuRXFKRkc3NXhndWVPMHRWd0JHTmk1WEFPVitKaDRrYUNyamla?=
 =?utf-8?B?RkxYVmc4MTd0TXR4dWg0dkpmNnhrRFdtMWt4M0R3SDNZNUdGS3k2WXVubEpN?=
 =?utf-8?B?SnRLQi9SYjY2L2xIVTVMTTErZVR1WWMySjJZRkZBTlhDanp1RkFkY0s3Y2Nr?=
 =?utf-8?B?UnZmeUtBWGlNK3luVmRoQ3J1ZlFkYUxwM2pXeWl2bVBnblJjUkpoVFJCOFJu?=
 =?utf-8?B?Q3pOdWoxYXA2ajBPdEpubXYxUXVaTktkQ21NTXBvaGZCeHlGU3EyQkFhWitE?=
 =?utf-8?B?S0hTbXpJVm5PcnVrOXZZWXVIRVlma2xTN3VUK3UrZ08vTHBxYkZkclFtRDds?=
 =?utf-8?B?QXpqamVlRzJOdEtsZXh0ZHhrcEpvcXlvVktIUlQ1SUNyMjBNMHAvYjRWbndF?=
 =?utf-8?B?Q0ZzOHBLK0xVMjJPY0piTm9YcHBYb3NkTDlNZ3MyWEg0Q0lOQUh5b3lWNmk3?=
 =?utf-8?B?bHFzd3RZeGhRRUdnem1Wc2pQUFdIaUdrcDI1eVdQeXB6VFNIUS9vblJwZ3NE?=
 =?utf-8?B?ZGxPbTV2SWxyRXlMOGlURkpxcVhQdnJCYzRIRE1QbkN4R1FiQ1p2bTVlc2pw?=
 =?utf-8?B?RHJ0ZU54SzJZQ2k4NGhzaUViVHp4bHE0QURzVG5FN1RzNk44MGhFb2NScDJW?=
 =?utf-8?B?TDBsWE1DYzM0c216U0J4a2FzbUlldk5zWmhUUTFid1VIU3l5QXZaTHNEa1lq?=
 =?utf-8?B?UjRCQ0JsQ1RTWVYyS0dqV09TRjc1WDFBaDVFaHp1VDRTUGRCSUw1U3V6QTcx?=
 =?utf-8?B?dGQrS21DK3BJMmF0Y1Zxcy9Pa0RnQzB6TlRJMU5WTGtlYndCMmJucmNiSEpv?=
 =?utf-8?B?VTgxWUkrL2lJVFQzZTBxMm8wemM3MDJxend5S0s1MWdKR2tMVWsyMnBNSHpT?=
 =?utf-8?Q?8dkbjaoVx4OeBm4h/MN/t+6Bm7OSOFqrhxG8Il2sQ1co?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dafa3919-7fae-40e2-5e0d-08dd1dc87717
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 11:54:58.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTCuH0B6ckWeczfwV9mzEgeifMaRd9dH0tF0tqp5UvHdKR/RbyrwbVSQrn5lEjZqCr3r7iDCdHbxreH2K62EGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096


On 13/12/2024 15:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 467 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.12:
     10 builds:	10 pass, 0 fail
     26 boots:	26 pass, 0 fail
     116 tests:	114 pass, 2 fail

Linux version:	6.12.5-rc2-g602e3159e817
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                 tegra186-p2771-0000: tegra-audio-loopback-testsuite.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

