Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011017.outbound.protection.outlook.com [40.93.194.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7403335B14C
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780488; cv=fail; b=BGyq87hRafHDqWuPNPFnMfJDusp8fYc9YyTm22D2crZmZK6lZZRmMTkjy6fiHMG+BHCenff1Wh5I9Lda0jwoIOp0Le030LfUzqPfoo7yfiD1dky9qx/c/Xv3m2qVuOUzZmdQsxo726ZEa+Q47vXKttwxBhWxD/bEEq3nDu1lzP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780488; c=relaxed/simple;
	bh=TkM8zVVTYksHL0sVbZRg6bcJpGv+fOkzCA7Z/4ExniY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N+yvqdOsLDhTa7Bgp5JZQ9Tw52Vwrw9fivLxPX6aQpLEMK53KUpVaOvzSsy4Q9Sjof3N0Ae/8wi9v/p2p2venafKz0RVaGiBK0yA+HNpdrtltj6v5I+WPXcjSIcPC4CEl6BSwz/LShNw4ZxJMz3uxVBZtx083HlI3lvpbmQHY0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mEft3bfv; arc=fail smtp.client-ip=40.93.194.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mEft3bfv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bDwOwveY5SXnEaq/Kz7WY7QPgYElcTDR79tc7swbKJcSznOiZwbLDakyjohzt//ua1v+BimsWa+1+7vLYdar8X/+UWmUX2yto+KVsWc0F9NNK0Z7FjgiVY3VUkvbMsrBAwMXERZoGswXajgWgpY6plJoBbnEoDJ/ahVXtpff9c0SjMfNc1jtOFMqkzFyhFuQKlOIVvQqj8tv0v0mZgS/FHOKw+ifxD4geiFotCNcfWDsZ6/7Brxa4qbOgJwDsu706UZb3zXxSxnRRu8+hzf1MDBR7eko/mQ5tWxoNWg2Zy+eD7AAeR1X0E6C5pZXEnD8GKZVbQpebt+AcvViyngREQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkM8zVVTYksHL0sVbZRg6bcJpGv+fOkzCA7Z/4ExniY=;
 b=PUI7EQchb631aEJUh5dVKV/z4Q4fBJhOsDLY+9Huhrgu8ONeeyngBBAXTNV6P0tp9XHNPQDpuuhVkyXRlXWCRzftIdXljHD4v0j6haU+gQ9uGPKmLhPs+7riqX/R4wuPXkr+UM4v545U00E3wcVPqexA5+WuhNEdZCLzpk/0r5bUkKA7NI5S7qFTJRXVBDwS837KVOFgAWxDS0Ih+DyV7nO+MZTdinHcfmn09GVAIRGOvXMPG4I0+c5VPaltXgJ1kXhNG2uyt5S8LaO601UHv++YnjzzS6iAlzi2WT6Xl5h8JEkhpdHMBtj+oN+/VfbauRDmscUe9Bq7+vgB0fYMkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkM8zVVTYksHL0sVbZRg6bcJpGv+fOkzCA7Z/4ExniY=;
 b=mEft3bfvUCXjyzJNcvLrutCaTRxHr+TR9CEUn3wgGu/pZ7Odck017vXFLLZqolQiH00rL7sGS0ib+Abar68X3K6jxxSV0Vb/BMOM5FHFpGVj8144eGmEK8uurH9NS6LWqTMqbupYYV+CWCQHRJ09jGykPjhbkMDCU/kxFcqo3q4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by MW4PR12MB7165.namprd12.prod.outlook.com (2603:10b6:303:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Wed, 3 Dec
 2025 16:48:02 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 16:48:02 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: "Koenig, Christian" <Christian.Koenig@amd.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Liang, Prike"
	<Prike.Liang@amd.com>
Subject: RE: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
Thread-Topic: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
Thread-Index: AQHcZG0WrCpRNVEwLEqyDCFmLKzAt7UQE8uAgAALkaA=
Date: Wed, 3 Dec 2025 16:48:02 +0000
Message-ID:
 <BL1PR12MB514484FA812346EB147CDE9FF7D9A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20251203152346.456176474@linuxfoundation.org>
 <20251203152351.182356193@linuxfoundation.org>
 <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
In-Reply-To: <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-12-03T16:44:42.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|MW4PR12MB7165:EE_
x-ms-office365-filtering-correlation-id: 0c676353-cb97-4aa9-a543-08de328bb940
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dFJxOXZSaDVhb3VxSW5iREcxN3grVnpJU2wyYXE2bWZFWjQyVHZOSlZxNm9Z?=
 =?utf-8?B?VDNMRUVtd2Q0RHNqZkpqblVrdmtjV2NEL0Q0NzVOM0dWVVVBVVNrK1YxWkZh?=
 =?utf-8?B?U004WmUvR1lZekVrZGVhNUFvMFk4SVhzS1lmcG82NW9kMk1KZEcvUStHQzI2?=
 =?utf-8?B?UE5Gdk5TQkJTdjUwVjV3akFLZnYyaHh3dmFPV0pIWFptb1JDc3RmTVk2Mjdy?=
 =?utf-8?B?eEZDNURCaTVjWGVPQ2R0NlVvNys1blFsRlNhbDVlMWFTYkQyWkZUR0NaRTdF?=
 =?utf-8?B?bGc5V2xaanYzRHJod0N5VHBlajF1Z1BMQk5IT01yWTVsT1djbnJjMngyektu?=
 =?utf-8?B?cGZ2MWw2VTkxbFd0N0JINStpdUplS09XSGtXTlFsY0FMOTJTaUFXaFd3QWlU?=
 =?utf-8?B?L01BOW5EMVNiVERHVUgrampaeVZqZVQwd3hpUVV4aVU0a1RWYk55Y1NjMmJK?=
 =?utf-8?B?TkhUOUNUTDRWeWhDWkMrRzRIU2ZjZXN1MWxCREFyaFBUdzdnYy9kRTdNOUdM?=
 =?utf-8?B?V2ZnVloxWkk1eDdXd0t0aklHYW9EcE9zY1BWRXQ1N1l3bTV4K1Vmdmk2ay8v?=
 =?utf-8?B?aGM1aEwzc294VkRoeTFrRjY2V2szeVE2RnROMkp4NjVLaHhYdG5NU1ZsQ1Qz?=
 =?utf-8?B?SVhZeGZTR3FrRkFYNjZRUVIxYmVST1Vnb3VXZitOUm1HaVdxb1gweEh3cG9N?=
 =?utf-8?B?K1Q0OUlWdUlad0UyOC9DQkxSL1hIVk5yRGNOYlpSaWRTQkxPcmRtbjU4bUZs?=
 =?utf-8?B?SkZ0Z3VKZ3NVZitYbFJaanZkNVZjdUlJR1krUHc5c2d0U1h2VElxY0FEc1FX?=
 =?utf-8?B?OUhXTWRLVVpBaXJSWHFWNFFZRXpXVDZKUFgvZUtCL2xlcjlTV2pmZlQ3MlhR?=
 =?utf-8?B?L0FTeG5NeHlYMThjTkNVT1M3MjNtdUxjRkQvSk1TSU9jUGpPbHBaSjFhcjJr?=
 =?utf-8?B?UGFjWGdtRXI5bmNMdS9UMWQyNUp3R3NRSjRBa3RFL1ZDRHBadVpRTkdaaEpP?=
 =?utf-8?B?QUhWM05scVhwYWFZa1JTYXQyUHZMT0xYbGJWbzJzMjRnUFhsRlpXZ2M0YnVU?=
 =?utf-8?B?Z0NKYll5eUdqV3VVODdQb0hxbW9FSlprdk1iUGhoTVVQdXplUzhkZ3plYStU?=
 =?utf-8?B?K2ZyOXgxNUxsdU5BemlrRFB6Q1VMMnNSdnJkTmJocVhzZ1A2UllBSlZENDls?=
 =?utf-8?B?Mjh2VUxpdVFOMGlGa1VXektnRlY0ZE5WcHZWR3FqVUVHTmZ1czR6Vll0SVls?=
 =?utf-8?B?OW0rUEt0eXh0N3lqdlBZRGVsVlJHUUNibnpKekVuZFJCb3ZHS1VsaHI1Skd3?=
 =?utf-8?B?M1FSNW5UUWQ0clJ1c052azB2ZHRxQ1h5OExjaEVranpZRVlQcGJ0Y3dZRGtw?=
 =?utf-8?B?Tjd3WU5pNFpKRkpYRW11ZFRsdGFTVERibVVZbzFzWUIyNENNU0RTNkFKNFhq?=
 =?utf-8?B?UklmaHNNMWVvUkVNWTQ2Z1pIQ24zTFZ4OExpcHFmQTU1YmFWTm1FeVgxU1dv?=
 =?utf-8?B?OFRFVjRqWU9vREIrd2ZhWEZUUGsyazNVUjhPQ0t5cnhJKytFTmFXUDJSOThP?=
 =?utf-8?B?WGZROTBnWFV5RlZ2RnI4SFRWajhleFNXTWxoTCs0MWY5YnI1SEFOVlQwVVU5?=
 =?utf-8?B?Q04zcGlaQkNST25vUzRPNGhvaVJOOVdzMTc0VFFLVTBDbHlndlc2Nzg5aGRV?=
 =?utf-8?B?U0pEeGptL1lvSmZuMVJVSUg2N094eXliMWhVajhKdm9CL0hIMFQwNzBuMmV4?=
 =?utf-8?B?amtqZjcrT28zMUg5cVNZenIzYXlpRGlDc05jZmhnc3hZMXQ5WTZ3ekV2OUx4?=
 =?utf-8?B?ME9vQnlKQVUvK2czTUpkVHhJTklwVHNvUU5WWmxJam9EZXhCWE9TbS9WMkR3?=
 =?utf-8?B?V292Q0xDMWxveHExMkw5N1pJalYzRWtqRnJjTGpYeUo0MGNmTVcybzczUmFp?=
 =?utf-8?B?TDNIOVM4ajVibkJRTm95bjFQTjB4N0RTa2NYc2FLQ0E5TndhMmcyNXRBM3Uv?=
 =?utf-8?B?YUF2ejdTY3FmYktZam5jSDdtblN6b3ZqSTNtc1k2WHdYdlJpeFk5eENmQlY4?=
 =?utf-8?Q?p7Z1/8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OVUySzBuR2pHdmVRcG9vdUlDTDNiTVAwL0J2eGJ3a0NXTWNXZkZTZElncFNG?=
 =?utf-8?B?anRmWVdlbU1tc0lDNzhQMDZFRGxjcVp3WVMxOFB2akl1R0lRT0tjSkRuNnBt?=
 =?utf-8?B?bVJFNWlCcysrb2VoZWNXaVBXZnNQMTkvbExNRzhseFpsWElobllqTVFnNEZr?=
 =?utf-8?B?R0NEYmgzVFlpNVpMTUtlUTlrL2NBUi9McVlNSFM4MFVSU0xyWW1uWXZ6VGlK?=
 =?utf-8?B?MENPYi9VOFhxVE5iL0VFNjVSblZOK21RNUxrblE0NHlBMTBoVFNjMi9KSmtU?=
 =?utf-8?B?MTc3N3MxRFZaSTNiNGF5SVA2NlNhSVdVbHVWTjZEUG05L1AxWmFPWWY4LzA2?=
 =?utf-8?B?eFV3dERUL3RNSk5zUXR5dVUrUWEvTzlPYmxKUFBSbk1JaGllRzREL0hWK3NU?=
 =?utf-8?B?Yk1aV0Z3d2hKNFVhSXYySlErcUtHMW5IS3kwVjVwaUt1V2hmUk1qWnh3YTd0?=
 =?utf-8?B?MnM0cW1KYm1VWWRTa2cyUzN5SWFYRGZQdjhQKzJiR0VGTzN2bnUxRTJmU04r?=
 =?utf-8?B?Nk5MU1lOenl1UDQrNldEZ0M1QTdPbktLNDBEbmFzNFBuWHpxc3VmM1BCdTdI?=
 =?utf-8?B?QjdscytPQzdLYnhGdTA2THJIODFOeVhkcEErc1J3djl4d1dITHBYZGR3Y3Mx?=
 =?utf-8?B?cXpvY2JIOWJJOTkzcjRsV2VsQ0NETUVxbmlFa3pjK0RGdW5xdmY1cHVYWTFH?=
 =?utf-8?B?aWEwdDRubm9WekdGZ1JQT2xEMXRIYmMybzBza1ZTbVJlQ0huU2tQZnRZN2hX?=
 =?utf-8?B?NDhJMDduQjBrRWN4RkJxZEgrbC9Lc2t3Z3FXRmRmNjdqNDZibU9KUElDZllC?=
 =?utf-8?B?ankyZkFmT1o4Y0xJcDczNjlDWGFnS2cyL01nZWJJL0ppdjVrYTFPeWQwRUMw?=
 =?utf-8?B?bllSOVZPV0ZETktub0JzcWl3ZVNVRVJHdGlBTXNqSlowa0MrbXc0M3BES2NH?=
 =?utf-8?B?VkF4RHNoLzdnRGFpT0c1SFQ3ZmFiMGtiMXVOWjlMWW1uSHJCVWhQSWZQNndD?=
 =?utf-8?B?NzFWTFdnQkwyV3NoR3B0TUkybmRzYWpJUlE0alZheGlBOFFtQU9ZQ0NpOW9V?=
 =?utf-8?B?SUlRdlQrRjZsVlVXRUlucERFdy82TmpPSjNuM2pQN3FaWGlRL29tZURBNEhp?=
 =?utf-8?B?OHhhOU1sdXBIUVdpdzZiMGhQU3RCMlhmempSV2UrQ0t0ZHlLd0x0SkZ5d2Na?=
 =?utf-8?B?aHNvOHY5b0w2dWFnMFZ1UTNpdGUxN2RsaUZ0TTJrZ2YybHhmcEN4SWdob1RH?=
 =?utf-8?B?YjhuTkxUMGY4U3h2ZXJkZlBwRkwra1RLWTA5SjBIZDBuUWZVeElRUEt4Qnow?=
 =?utf-8?B?bDJTcVZPTmZ2ckxSZ2o4eFNlMXNKdDFadkYwRndrTERCdGJoMkVqbk00R0d2?=
 =?utf-8?B?clR1ZDFydlJSRlloVFJSUE9Jei9YaElhOGF5emYwYlJtcDE3MEp2SWMzb3Q5?=
 =?utf-8?B?YnB0Sll1R003aHdGcnRyZG9yUENHRWpRSWUvbWw3TDc1a0NJalc3bXR0dG9i?=
 =?utf-8?B?SHUybk1xRk1TbURWckcwc2ZyRVB2RzhiZjdLZXdXMDhYbXNPMXB6ZW43alI1?=
 =?utf-8?B?dWYxdjhIQnNRWHlxQWRRbGUwUElnRDROeW5SYUdnQmVyVVdYeXpqVW1zek1s?=
 =?utf-8?B?akM3VlM0Q0ozV25ka3hDRzd0WHNsaVdqeUhxM05DTGhGSnBER0ZxWUtwU05s?=
 =?utf-8?B?eWRNNGozRVFIRTVKRFdnOVFzODVVTUdTRnZSTUd2UUY0WE1ZVE5pODdRRGJn?=
 =?utf-8?B?aHZiWm1jRlFHeUdjUTd1am1TMVEvcFM5bk0vU1ZyL2ZrWWxFeGFPWjBuVE9F?=
 =?utf-8?B?UVJkMjlYUTlxWnpnZ0tpTzhhTWNoemZqcHRReS95cEhKekNyc0RvankxbzhV?=
 =?utf-8?B?ZitUcXBZd1FqMTNaMW4vNWo5Nk43MWdXRWIxY1NwSHdJZWJ2OWZiL2FNSVJX?=
 =?utf-8?B?cVZ6N2NSbzJwTE0wb29oRlk1L2VQeUdnL1VJaUF6cUNHQUJ4QnNXcFBKbE1C?=
 =?utf-8?B?TzUzWG0zRlB0akowdi9DRVR2Z1cyZ3BCZTQyR2txcmR0WEZSZXlIbXl2eGZn?=
 =?utf-8?B?blM3c2t4Q3NRMEVFaFVVRHpqTng4RWhEMGJkNjJUb1JaVW90VW1MT204cU5w?=
 =?utf-8?Q?3wuY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c676353-cb97-4aa9-a543-08de328bb940
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 16:48:02.2836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bjyGM9xCz28+lA0GjTuULMyj/NfJPDSa3U+j/erJ7SeO6QKG1Nt0l5jtLx8MJLTmP0wRfOl1pq0kztiQi5zPSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7165

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLb2VuaWcs
IENocmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPg0KPiBTZW50OiBXZWRuZXNkYXks
IERlY2VtYmVyIDMsIDIwMjUgMTE6MDMgQU0NCj4gVG86IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3Jl
Z2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Ow0KPiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBwYXRjaGVzQGxpc3RzLmxpbnV4LmRldjsgTGlhbmcsIFByaWtlIDxQcmlrZS5MaWFuZ0BhbWQu
Y29tPjsgRGV1Y2hlciwNCj4gQWxleGFuZGVyIDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPg0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIDYuMTcgMTI5LzE0Nl0gZHJtL2FtZGdwdTogYXR0YWNoIHRs
YiBmZW5jZSB0byB0aGUgUFRzDQo+IHVwZGF0ZQ0KPg0KPiBPaCwgd2FpdCBhIHNlY29uZCwgdGhh
dCBvbmUgc2hvdWxkIGNsZWFybHkgKm5vdCogYmUgYmFja3BvcnRlZCENCj4NCj4gQEFsZXggb3Ig
ZG8gd2UgaGF2ZSB1c2VycXVldWUgc3VwcG9ydCB3b3JraW5nIG9uIDYuMTc/IEkgZG9uJ3QgdGhp
bmsgc28uDQo+DQoNClllcywgdXNlcnEgc3VwcG9ydCBpcyBhdmFpbGFibGUgaW4gNi4xNy4gIFRo
YXQgc2FpZCwgdGhpcyBwYXRjaCBkaWQgZW5kIHVwIGNhdXNpbmcgYSByZWdyZXNzaW9uIG9uIFNJ
IHBhcnRzLiAgSSd2ZSBnb3QgYSBmaXggZm9yIHRoYXQgd2hpY2ggd2lsbCBsYW5kIHNvb24uDQoN
CkFsZXgNCg0KPiBSZWdhcmRzLA0KPiBDaHJpc3RpYW4uDQo+DQo+IE9uIDEyLzMvMjUgMTY6Mjgs
IEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gPiA2LjE3LXN0YWJsZSByZXZpZXcgcGF0Y2gu
ICBJZiBhbnlvbmUgaGFzIGFueSBvYmplY3Rpb25zLCBwbGVhc2UgbGV0IG1lIGtub3cuDQo+ID4N
Cj4gPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4gPg0KPiA+IEZyb206IFByaWtlIExpYW5nIDxQcmlr
ZS5MaWFuZ0BhbWQuY29tPg0KPiA+DQo+ID4gY29tbWl0IGI0YTdmNGU3YWQyYjEyMGE5NGYzMTEx
ZjkyYTExNTIwMDUyYzc2MmQgdXBzdHJlYW0uDQo+ID4NCj4gPiBFbnN1cmUgdGhlIHVzZXJxIFRM
QiBmbHVzaCBpcyBlbWl0dGVkIG9ubHkgYWZ0ZXIgdGhlIFZNIHVwZGF0ZQ0KPiA+IGZpbmlzaGVz
IGFuZCB0aGUgUFQgQk9zIGhhdmUgYmVlbiBhbm5vdGF0ZWQgd2l0aCBib29ra2VlcGluZyBmZW5j
ZXMuDQo+ID4NCj4gPiBTdWdnZXN0ZWQtYnk6IENocmlzdGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5r
b2VuaWdAYW1kLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQcmlrZSBMaWFuZyA8UHJpa2UuTGlh
bmdAYW1kLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFu
LmtvZW5pZ0BhbWQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFu
ZGVyLmRldWNoZXJAYW1kLmNvbT4gKGNoZXJyeSBwaWNrZWQNCj4gPiBmcm9tIGNvbW1pdCBmMzg1
NGUwNGI3MDhkNzMyNzZjNDQ4ODIzMWE4YmQ2NmQzMGI0NjcxKQ0KPiA+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+ID4gU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9ncHUvZHJtL2Ft
ZC9hbWRncHUvYW1kZ3B1X3ZtLmMgfCAgICAyICstDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gLS0tIGEvZHJpdmVycy9ncHUvZHJt
L2FtZC9hbWRncHUvYW1kZ3B1X3ZtLmMNCj4gPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2Ft
ZGdwdS9hbWRncHVfdm0uYw0KPiA+IEBAIC0xMDU2LDcgKzEwNTYsNyBAQCBhbWRncHVfdm1fdGxi
X2ZsdXNoKHN0cnVjdCBhbWRncHVfdm1fdXBkDQo+ID4gICAgIH0NCj4gPg0KPiA+ICAgICAvKiBQ
cmVwYXJlIGEgVExCIGZsdXNoIGZlbmNlIHRvIGJlIGF0dGFjaGVkIHRvIFBUcyAqLw0KPiA+IC0g
ICBpZiAoIXBhcmFtcy0+dW5sb2NrZWQgJiYgdm0tPmlzX2NvbXB1dGVfY29udGV4dCkgew0KPiA+
ICsgICBpZiAoIXBhcmFtcy0+dW5sb2NrZWQpIHsNCj4gPiAgICAgICAgICAgICBhbWRncHVfdm1f
dGxiX2ZlbmNlX2NyZWF0ZShwYXJhbXMtPmFkZXYsIHZtLCBmZW5jZSk7DQo+ID4NCj4gPiAgICAg
ICAgICAgICAvKiBNYWtlcyBzdXJlIG5vIFBEL1BUIGlzIGZyZWVkIGJlZm9yZSB0aGUgZmx1c2gg
Ki8NCj4gPg0KPiA+DQoNCg==
