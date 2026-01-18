Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4712DCF46
	for <patches@lists.linux.dev>; Sun, 18 Jan 2026 12:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768738996; cv=fail; b=hyhZDLMrlAuKpqlO0Ep96OKOhLOm1IzyhbpUUHOHzYi0OSHyts7BNVS82UwJn3h1K3aAAYxZF72Sz6GvQbNoM0aZhoOcEYAMMqEskAwQI8Dn3No6op9ZTAPi8WiNdbMcSMksT9L2rvdd8UXhLJG615ZIpPBe+tK/jx0192G/l4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768738996; c=relaxed/simple;
	bh=nL6Hy3lI94F8fWe/7gQk4MpAd67npg1fcnUNQ/cp/pQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NYKNVEQr3IQ/PKVd3N6PRsdN8UOK0JJi7MBhCEZyacINqEOQ6iGmPvXw9nR5JQJHFzQaWdE4uFyaoESjQLQMLvimMKAqsDRzecBHaIL3mNBUkfBbZ/gIApQeJLNL4ArIF+4yIIjj5VZUxQKF/GtCPjeAQtyaD9aY0rqCTICSzAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=trVYZK3e; arc=fail smtp.client-ip=52.101.56.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="trVYZK3e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nWmFz1iA/rGthCCcdfJpuukoCUc6I5fylBTYdrjSoN43V4PHbArDaEvjB91VUVO2TUD8Wwx9u/iSduJlGoAEizMyliFspDS7IEE7Q1LmuozAGq/kQVJsQg5DPmru830a+uGqYdZ3XgmQo3DKviOyF4JSIDf3HwLLVh5KiWWSD3WdBUnnPN3kwX5N4foXQIj6Ll7Sx4Kvam5mDM51kuGgyeayc267h5X6CJNg56uVenu6UjDGV0lXH+vgUEjNNyM+eRPf5Xq0CS6ATfR04h3GXwZFustGv9IuAGegeGGwuWnWNtFXg1gF4R37pkxsJoN6uL6IGKx3K4EPhpoDKVyszw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKDSVUiGxVK/AnPGRhqhCCVB5tpO2AJ+H/bV3REPJZE=;
 b=O+lTQlCgOvcyTjXuqcj6i4tvyEAGK5wETxc7y3cG3n9h2qTR/s+mgfTYrkjWH6QL/vUKI7VO672VOY1s5xh7XY241VDc4JmqWSwNTZhJYVfpkdNRa+WNfj6Pddq6drREabeFPEHKenmsIqDA8EoWi1LOKIAmyKZ2sUQnFJSsn8s/+YZD547RKN1YIj8KnPIVeJZyXCEm1y6Rip20nt0mq7doVa+w4oJgxljgJ2yUbiE/vCbtkeQZk2Q2fpXY2KFg3pJZj8mHQpUiiTsCRV0+r4Z7YTh2ieCdhjynsPHfTw2k3KfmjHjZ2u0qLKn3tKuEexQvMD0potWomt36LPobvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKDSVUiGxVK/AnPGRhqhCCVB5tpO2AJ+H/bV3REPJZE=;
 b=trVYZK3etpBjhjc/CMV0Xd6Ao0vFsRaJWEgfB682afg3lWA8B0HsQxYRdtQzgN99JEmUvb24PtCUbr+gCkydbvQ9ZdgoAQzqcZjpq93K7k1VgcgT0lPpCtWcf8S1HwnsqHfmc4KZwxXak26+1RPG+NIFo/rnDLji/ag4kSTYMqd1IdH2UszF2/83c8fMFSOCIMg0YY7G2J8WMpY9/EW1Ar5v9c4WI+MuDfqDmCfEMfaMmn3U8thh171wMo9PH+UwSVumEHUFG/J6m9oWOzjp4aAnv9y0jnoWMsv32/ip18CgEARQLKCLwqDvS3KK04n9MWKAKn5RB4kH/YFNoOQ1rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7003.namprd12.prod.outlook.com (2603:10b6:806:2c0::10)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Sun, 18 Jan
 2026 12:23:12 +0000
Received: from SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b]) by SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b%4]) with mapi id 15.20.9520.010; Sun, 18 Jan 2026
 12:23:11 +0000
Message-ID: <444c7da9-bc80-4c13-bfd4-3859556f89b6@nvidia.com>
Date: Sun, 18 Jan 2026 14:23:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 183/451] ethtool: Avoid overflowing userspace buffer
 on stats query
To: Ben Hutchings <ben@decadent.org.uk>, Paolo Abeni <pabeni@redhat.com>
Cc: patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable <stable@vger.kernel.org>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164237.523595757@linuxfoundation.org>
 <188e82d04a1d73b08044831678066b2e5e5f9c3a.camel@decadent.org.uk>
 <5f6519fc-adf1-4418-beef-251e4a930e48@nvidia.com>
 <5ba33a1ce95dfa2fd2bb828b9c3eac82c2ae1111.camel@decadent.org.uk>
From: Gal Pressman <gal@nvidia.com>
Content-Language: en-US
In-Reply-To: <5ba33a1ce95dfa2fd2bb828b9c3eac82c2ae1111.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::7)
 To SA0PR12MB7003.namprd12.prod.outlook.com (2603:10b6:806:2c0::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7003:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: fa4828c2-e24a-46e3-6ac2-08de568c58a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWR4cnpHd1lsUFJaMFplcS8xZEp1MmtJZ0RmWGVjWTkvZUJVUTJTSndmVzNM?=
 =?utf-8?B?eGs0U2NpYk9XVHY0S1E0ZWQ4dmlhNXFPV0JsaEFXNmNaeExQT2Z0TlBaY1Q5?=
 =?utf-8?B?WjRLZ0JqV05VVVdnUWJHclZ4QkltYmZONVE2Vnhoc3JCaHpWWVlRRkJTb2R6?=
 =?utf-8?B?WDcwSE1PajBSb0I1anlla1NJaVpQTUtuKzhSZGltajBsa3p4bnFScUZqU3NK?=
 =?utf-8?B?VlJnQXBmWjJGSUgzakZ4QWt6d0NNOVIrVk52SHFlZSt0U1RhTlBSNkdzVThV?=
 =?utf-8?B?V0VSR0ZtMGxROW1tL1JMRkNUZEFQWFdPM21mVkJsYmRzMlJ1STFkMEpkQXFK?=
 =?utf-8?B?Q21hZjRnRHExWjh0UWtnQ2NTQ2c1d2RqTkR2TGFVNTY0Y0hZT3kzL1IwTUI3?=
 =?utf-8?B?SjVRY05OSktNK1JTaVR6VEF3UUdnVVYzdDdDUEtTNzl5aXBsOTRISTZkZkVm?=
 =?utf-8?B?aEJORVl6QU9tcTVRdkpvMnZzS0loU1ByU08zeHJ4TGJIZEIvK0xhUFJyeUhS?=
 =?utf-8?B?eHJPOGVORUxzL0tMbEROZnNMTUFaSjFpVS9Da1VHVjlRYWxOc1RjWFZRRWIv?=
 =?utf-8?B?bGY4WlNJbXhDMUwvNmNkMFVxNTg1OWpqZlFqUW9pYzFqRVZrZGtRWnZTWkR6?=
 =?utf-8?B?WDZMWTN0ZlhmOE1mWkxuam5UMitiMThvd1AvM3hRNXZBb3g1eXY4RElMVnFC?=
 =?utf-8?B?NWZYZDVjcHFnMndRVkVHRmd0YVBnVlpZTnlpL0xublVJTEpZWncyMFJ5UU40?=
 =?utf-8?B?ZFYrVkJobVJrQm5tcllqUkw1NHkwaURRYkRVZTZpVXhkNzdUaHhYM3hFeWVx?=
 =?utf-8?B?SmN3V01HNDNidVVDVGNFT1grNmtubTQxeUtzOHQvdFBOS2hkVjRFMWlRRG1l?=
 =?utf-8?B?LzltUS9TeWtBM0hZNUNOTnlGZXViY1B5dVpVZW1JcDJJOGVBNWRuU0Y1NURT?=
 =?utf-8?B?czF4MDdmMHZzUU9LSEVtSzhwZHZiMFFvUUZRRythNUhHQUdVMGpsZEx4bHhY?=
 =?utf-8?B?OXdtcGE3a2s2THhwdmFaVUxxNjZYT2ZCQ2U3MjdkbTIxWUJhYWM0VnhzYXBz?=
 =?utf-8?B?QnR1TTRkNU1BMndlZFdaS3RkQk8wb3JZMWdidUlOZ2xrUDJFa0tNcnFZTlFX?=
 =?utf-8?B?dFdiRHAwVFh6UDZvM1BwNHU1MjhnVnlnNVB4WXV6K0lYeFdXQ0hOdU1laWQ1?=
 =?utf-8?B?SzJyTU9TRWMrdzV5R1gzOWdHRURMNXd1bkVwV1A3UHF0cGtndkI5R3lTQkZm?=
 =?utf-8?B?YTU2VHc0ZjMyL25ZQmRZM0ppeFZlZjF4L1hpQ0N5R3E3dDNiVGtnNDZtYVQ3?=
 =?utf-8?B?b1h3UnVFTFF4NkZEcGcweFZOZVdzMzlJdDIyNnFzMExNejRSQU4yZWpYcDc2?=
 =?utf-8?B?OVhQNE95aCtNZ2RscmtJTG1Yb3oxcVI4S2k5amtHMVBBQ05PaXorZVRKOVh3?=
 =?utf-8?B?b0oxanFscS9lTzZoMWZmTzhXdEp3SUxHdnlWY0J1dG9KVnkraS9FMnBxR0Yx?=
 =?utf-8?B?Z2R5ay96ajZNVVQ4bnBlTUQ4ck90eWtVSyt2TjB3ODN2S3JQa3RzTkk5em5q?=
 =?utf-8?B?c2lSbWFadnU1WFdoT0swTlJOSzFjQkd0UU4zamdNZHkyVnVoSTdYdC94djdi?=
 =?utf-8?B?dHZNL0cwaVNKWFByc1Q2OXdkaDhMVFNxVExRdllDZXBBeG81MGlXT0oyZDZn?=
 =?utf-8?B?S0k0dTlUZEljR00vTjN3STVCYkVMRXJ2RlcrZU5nZndFdUduNkQvN3hkUk1m?=
 =?utf-8?B?eDRDaVN3S1FETFNxL2dkcGFER0VBSkduRG4rcGFxNkdCSTRyVEtiQk1oRjl5?=
 =?utf-8?B?VWV0VUlvSThIblczbWYxRzdza3o3aHRhSzJtMEoxSnRhWFFPdFVRYy95c2c2?=
 =?utf-8?B?RGN6dmMzQ1NhRlFURHJDRmI0QXZOSFlIL05NZ3N1WnR3MnVXckhjY3lwNFpK?=
 =?utf-8?B?STBVUFJJbTZWLzltNU1Tb1NQVHpxcGd2cmZWMldFc2tKaTRJTmhmc09CN1FR?=
 =?utf-8?B?ZkIyYjA3b1R5WmFKUllWVW0rdFNvVDBjV002dFJvNG5lM0R2WGZJcnRudFhy?=
 =?utf-8?B?YTU2NmlrNXQwMXEyOU5YaVhwK1h5NDg2V0ZKdTVURndmSkxOVXJCQ2JIMC9q?=
 =?utf-8?Q?vATo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7003.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MU51Y2Iyd3ZGcDQ3ZkN2eEFKVTkxZGZXQmUwNEh6NEhBeGxMby9WczRoNWVR?=
 =?utf-8?B?ejhaN3ZtWDhRNlBpQVdSaE8zWUxqK1Q0R3NRRllGbWZOdzFmczRhOXJpU2hr?=
 =?utf-8?B?a3JwR0pxcmdWV1pwZFN5aDJqaDVUOWJiVGw3MnBkRHdSS0xlUnhMWW5LZkFw?=
 =?utf-8?B?STNhQUdPS0wxMWgwdW43L2pubEp3SzhXUTdLMTJJZjhRK2l2YmpvSXgxWXdD?=
 =?utf-8?B?S0lwb2pta2RRaHFTVUdhVWVra05WSmlJa2RjaHplVGJ4bG1OY2V5M1h5YS9v?=
 =?utf-8?B?Zk5zclhGSU8rVU5IekhuRmY5WUx1N0VqaXVaeERsRWFGSlRpVnc2QitTc3k4?=
 =?utf-8?B?SGpHOHN4U3cvVW1YamM3ZmdOV1Y5cUVlblFJK2ZJWnFUOGVoWmdRWXZyZzdF?=
 =?utf-8?B?MGNRWTdLWkN2aW9aUHl6TDFWdzQ4clhTWEdoTkdQNDU1cUtJUHkvQU1MRTR4?=
 =?utf-8?B?ZjZzZDRWMDRWMVdVajJnVmJQQUFVaUtTRDczNnZOaUYrV3NMWXAxTC9RNmxW?=
 =?utf-8?B?dEg1cEh4Z0tnbmxSODI0S1VqeVB3eW9TVFBTcDlhQmpBUmgwTkRwTzBORFBu?=
 =?utf-8?B?aHlCTGgwSkgyOE5DOUMxUk51ZmQ1OG5FQ0FQOHhWbEpXSTlTS1ZrTzRrejV5?=
 =?utf-8?B?NU1tTVFkNGkwR2ROVFdsQklJTzJuV2Zjc0hOai9BT0dOSFpBWjRZRm1tb1R5?=
 =?utf-8?B?MWN4UEtXRDBWUzNiNU9CSlZ1U3c4bVRpL283OTVveExtRWMxMWtFSnZETGNj?=
 =?utf-8?B?VHlxcmxSVGlsV2pKeUdDeXdESCtPakgxWU5YMFI5QVBiVm56ZlFxK0lxZWlB?=
 =?utf-8?B?NmJqN0lCVGJMTVFJdWNmdThHTEhDYUFadlU3M3NaLzMzazhTSkxIM1hHRis1?=
 =?utf-8?B?aXpjQ2NjYzJmZEh1Z2ZURTM1YjFCUUZPUjd4U2d1M0RLZmNYS2ZEaDB3cnR5?=
 =?utf-8?B?M0kwVmVUYWgxeWJRVDhYK3A1emE4Mnc5OXc5RkN4YjhhclBVZkR2T2I0aTk2?=
 =?utf-8?B?bFQ3RHQyeTFPbVdXZ2E5V09vVlpaTVRucSs0T3l0UzVvQlY0TnlPS01wMjlm?=
 =?utf-8?B?dm5tTjFvait1LzJuOXFMNEhZMitiK3pyRjRVKytDTUo4d3JtOUljV0piTTB4?=
 =?utf-8?B?eE5uT1I3bHoyNGg1VW1VZFJSUmd1OXVhN1FWd1k4c2JaMUE2S21XbWpUd3Ev?=
 =?utf-8?B?MFJhNEYyM2YwRnVicmNkNFBNRDRLaXlUY0wvbW9ZbDRQRW12d2pOZHlLdzU0?=
 =?utf-8?B?bjhFT1Y5dXowYUtqdHBrMU5oRjNBWFZoWUZLbEtoYU5TZjBrZlpUODNHMmQr?=
 =?utf-8?B?VlRFN3lWY3JhMVBxUDl6SmtnNkk3N0VyeE8xc05keTNGTlRmeXFHenRoQkM1?=
 =?utf-8?B?M2xJTDhIUkJtcmZjZ2NWV2lTODFtNEZYa0hwK3E0M0lxTU1ieHJnbmI5MWZB?=
 =?utf-8?B?eXJSM0p3L1Vvb0dFVjVWTjVGQjlrbG8zNkUwZStETXpzQUp6aWZWbXZiTlF0?=
 =?utf-8?B?MGs1QkpsdGw1bTh2b0dXejBORUtCSkt4NmNNdG1KajJscXFMeGdvQXVoQVgz?=
 =?utf-8?B?Z2c2c1FjNldORE80T3pvSXFkR1RJaEMySGJTL0Qxcmh3Ry9mb1FCZUNkYWsr?=
 =?utf-8?B?NnQ2U2Y2bGNsaSs4dzFBNWhnVzJzTDE1WksvYy9EZVhWZzBCc1R6MnpDMGMr?=
 =?utf-8?B?UG0xOHVsSmpmVExZQ1poSCt0aGRMMVdMTTZvTlFHdGYvMDhuYmNYYjZJbzAx?=
 =?utf-8?B?UnVHM0ZHaE4vNnZHbkNkaTJkWlVRYytDV2xXcU0yS3BVMERsTkRvdTgzMDZL?=
 =?utf-8?B?RHd3SUV6ODU5d01peHhuTXpGem81dmxEZHUwS3ZBTzF3cERwK1JIZEliWHA5?=
 =?utf-8?B?V3hMVjVoUUxXSktlakdnemF4Z0tiRXRROVJ3WCtWZ2ZKYVNNVURxUCtpMlJC?=
 =?utf-8?B?cUIvWnRoL2QwajZNNmdNd2pkR3BKUXlSTStGbmhzQS9mUmRNZW1iaDJJbTFr?=
 =?utf-8?B?amVCaDJiU2NhN3lQN29nUlBNVGVDQXBKMEFDWFUzOWJNMmlEVDR5LzBGalZX?=
 =?utf-8?B?b1I2S2dBUnRUZjkvTHcvTHVxRCtQVjBtN3VoMVlqTlBqbGt0a0MzV2RmZFJP?=
 =?utf-8?B?Y2VvTkN2QnFhb29IRTRySE1TazZXQWFrS2dQU3crL0ZtdlVXaXZOd29XSTRK?=
 =?utf-8?B?RlhkWVhlUjlDNUFQZ254VTFmRVJLaFhXeEU2RGxBMmRZRU5SL3oxTDErTnNt?=
 =?utf-8?B?RENMNkFVRUtBNWt3M1ZWcXVjY3JWcU1uSUs5WDFwMzVRcmZjMGhqaXdMYlpE?=
 =?utf-8?Q?0exoGBCPhz3nLvmU+s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4828c2-e24a-46e3-6ac2-08de568c58a0
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7003.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 12:23:11.8233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFSm9Ii/sKWidkeYLdOCHSo8hfial+wNQHh3Zf8k3LgfQt1oVt+Qjo3ruVv6ehIR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520

On 18/01/2026 13:11, Ben Hutchings wrote:
> On Sun, 2026-01-18 at 09:30 +0200, Gal Pressman wrote:
>> On 17/01/2026 21:58, Ben Hutchings wrote:
> [...]
>>> Everything else I could find with Debian codesearch does seem to
>>> initialise ethtool_gstrings::len and ethtool_stats::n_stats as you
>>> expect, though.
>>>
>>> This change should be documented in include/uapi/linux/ethtool.h, which
>>> currently specifies these fields as output only.
>>
>> Indeed:
>> https://lore.kernel.org/all/20260115060544.481550-1-gal@nvidia.com/
> 
> Thank you.  Please add:
> 
>     Fixes: 7b07be1ff1cb ("ethtool: Avoid overflowing userspace buffer on stats query")
> 
> so that the documentation update will also get into the stable kernel
> branches.

Sorry, this was merged already..
