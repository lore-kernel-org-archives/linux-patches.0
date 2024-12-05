Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA2221CA0D
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733410018; cv=fail; b=NcavOZW5NRVLj5TZK6YoFTcZIlnr5A8bOQFGkIkRXztKr4gAX8xm4Vd7cO4KBzKn2+fbynPARHbvDU20Bfjsf6ME+3tefAO8HoQqkgdkc8Tle8vofksETnKz3FOPuVGCjjieDLzzhQVUzILassBY3S2HXLgIOxIIkjNFyeyeuYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733410018; c=relaxed/simple;
	bh=nflTuGHQPPwRA/i7FfJqR6hkxQzWwF4X1yPQxX9f4SQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YEla0qkwoNAPcFrpF03AoCABkvwXPk2kSe7Pq8SmR/t4BCpLX/XD8ZQzRKuwXsGTdkZvYYMyMcslZ/J18ZW8l/sib6oxQlffLgkWFQnQjo8oHVHR0A4PChG0thUAetKqtClE6fUlVBw7cRafgXwNCuN2SCd3QMnQX66NysIFRFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YDrQ7r7F; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YDrQ7r7F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kiPtk2/UtmML2DTOC/8uJ3Bkd1jzTZu/teiQ1xomQY7ID7Ih7ko7K2FhOiBTfqqpiVkUawSbgmHQUB9phTz3W60DpDUhcagSzFBBb1GJVRDeUTfv9y2uR93wfVTQuLo2SkfhCFy/Qlld5ngZKWoZzsVyz2pqKBkXFxEemuvVPvNiB/JtyZ5dFJvgCWM6jkEQzntVZXOu5KZdKcMPfT/dCcazvBLKsKycx2UQ5L7joMAGuvw9YSZfq+Fjdwc/SCSE/Hq0pF8l8rVZ81w9wb9icDEaA35G+sWMON6RAl7Wl78S6dbBvK3Nr8TX78ijyI9CRHkDaaCUP/co/UL/udwH+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQAlwqrlrE69JBfNZKHF7RZgv9iHsmAwAbAfuZDeLwk=;
 b=BnIVMpqxa3hqVY3itCS4XfaVelsWArl6ubH+JLXZLKhFl6JgzgNmNn/AFJtBS8BgMZcih4p7ThfIuvhYjvuESQmJ81AzcNsm2TTv9U5usxuwP3PYJdqEioN9q78zLiWqGgrAMS7h4VPsHv+/pr7UFAFppq8koux74cgXha6rML/85gg3cWsY0tXzpuZ1N8MdwUkzLf2PtTexmLC0nr0ysKTxCx0m95XvY7472h9kDruIfj1O6Ge2UB5hYQhbgC+8MuNwNW6/MBpC+WgTD1AXKPtMPeCA7gu6jSzXxIRbPP+3RAu6p1OkabJtt9CG9VqCqsGMt3YlRYsbvQ8msyPsCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQAlwqrlrE69JBfNZKHF7RZgv9iHsmAwAbAfuZDeLwk=;
 b=YDrQ7r7F498GJUyFwXtK1K5u+ty2tJcC0+v1pORy81ienSevD7klwD/IAGm/mmivbH04DyZKtHgwV38cruEKJkGIKeRiXSPR0DN89vDZyA1Y7WC7eNBcgpVqbkgdLMEeMhcHob7AGSZ6c+jWnZX00TJQIweEEV/dqtuytvFJFSFGF4ROedx4Fd1u4ZO1/q9tTzTLfd/6IgHWGObXEcTTFP/btDJb9twxdWGLsJuFOontihdA7QOfTmNx4Z7ATSzVbgQhRX+N1WPCuANBdMh9Fk258frp1cB73jXogTYJ3wtLAuPYhYrUzXBmjrx96YWlCOwXdE2dnO+XaoGmcqapng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by BY5PR12MB4212.namprd12.prod.outlook.com (2603:10b6:a03:202::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.15; Thu, 5 Dec
 2024 14:46:53 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%2]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 14:46:53 +0000
Message-ID: <d731bdf5-e007-4d17-843a-2af5804b6de8@nvidia.com>
Date: Thu, 5 Dec 2024 14:46:46 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241203144743.428732212@linuxfoundation.org>
 <154b3d6f-0597-4ac8-ade1-f613f03804e2@drhqmail201.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <154b3d6f-0597-4ac8-ade1-f613f03804e2@drhqmail201.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::8) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|BY5PR12MB4212:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bdcc156-b12b-48e9-e946-08dd153ba88d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THlaVE9XdVh2aCs4ajYyeVhhTldHRVllYm42S3Fick05bys0Q0lhQmk4eENk?=
 =?utf-8?B?Ni9kWTRxVnZ2MnhFNGl3NzBFU0l2c01pOEEzcmYwWDNycVExQ2pUVkFwQmE0?=
 =?utf-8?B?S1RFd1FqRnllRXFnMG40ZmFNMkZWM0RodHlCejlaTzA1UUtuTHFHR1BjdHRR?=
 =?utf-8?B?Zi9iQ3NQN0NxMzR4Y3lUZjcvZ1B6c29FakI2Q1hLVXpEbUxEVXNzRzRpTFdO?=
 =?utf-8?B?aDQ5c0taQU5ZN3ZTcFhzSWU5ZmJBeTVwNjErTHd6K0FlVElFelA2N0lTbEti?=
 =?utf-8?B?Y3FqaTF5MThha0huU0hzbVBtZFo2WCtXWVUxdGVOWHRFRmR1SlNmM204Rmk1?=
 =?utf-8?B?Q1F4cmlCREFyU3BwWFRORzRiZTVYaG5Ubm1tWGIvdFJBV0xxQlJQY2lobXBJ?=
 =?utf-8?B?WDA2bkM3M2hzbDN1ZTU0dVoxR3ZBSDhwbk5lU2plc3RNUTZXRmZSQTNSOFdD?=
 =?utf-8?B?UFpjUm15dTRldGRKMGZ3cWZldW1hTlRCQVlnNXJJczJob2JrTWRkL2FoT2RQ?=
 =?utf-8?B?UFR1anRic1Rkczc1dDVMcC8wRUVRMXZxK0M4djYwUXpvZFgraSszVjhnL01U?=
 =?utf-8?B?bEV6K1NSLzFtZ3RrMUtESDFJMW5xbFhETHZSdlpuZUdmaituMXdmRms1dndj?=
 =?utf-8?B?TkpQUUNkaGdmYURzMitqNC9jY3o1MnVGVkRLNlpFdFpJMCt5YnZIUnpIZzMv?=
 =?utf-8?B?a2ppL3pNYW1XWUhxMmtxUDNNQTNnVm4xL3BMcnJ1YUxDbnBYVlVxMG1oQ3lp?=
 =?utf-8?B?ajcvNm5oMVZXZUFFNlgxcm1yaVRGc2pLa3B3eDh6NjJIM0dQMGRWOXI1eWNG?=
 =?utf-8?B?N1Z4ejI2YmpONzViTmRiTW5NOTlqdFJhMFFMMGQrejVub3JGRmdTUUR6MjNy?=
 =?utf-8?B?K1FRbHF2T2JZYjJncVdrWnIvU0JuQ3hhUTMxM09iN2lmZFlHSEJxTnJqK2lZ?=
 =?utf-8?B?WXUvYmpCajV0dVBmdnFQVkNmOHZiWnR2ck5wK3J5M2I2SGxlSGlHNG5JOWJV?=
 =?utf-8?B?cUhDdXVnZHE2YW9hL0lLUnMxRGkvcFVzdUtKKzBRNG1YeEhmL2ZVcXNScVdu?=
 =?utf-8?B?cUNQaG9tNEtCYUZ3MXdtVlUyOXNVKzFDZVhhWjRuVnJocTNGK2pDSFc5RXRI?=
 =?utf-8?B?K3NBKzNnRzEwcHgzVWQ4YW12V3FrZ0VURXRoVWk4WnBHUHFQRU1CMFhneDNv?=
 =?utf-8?B?d0NFZEpFVjdrQTRmUTNoU0ttYlkwUDdCVlVrWHVUQWhPQTV0MEZBSDdweFFV?=
 =?utf-8?B?U044YnpnNUhpSS9pV1g0bW5hb1VaSEQvN0lVMmRxTzVQSUZUWE5WZFpKQ3Nr?=
 =?utf-8?B?UTh2bHZ0T3VWZEpHRWlzTzAwanhsb28vbDkzNXZsRitDMU9NYjNMcDBXRE9z?=
 =?utf-8?B?WlZERWEwNG5ReDJkQ3RPQnV2N1Bac3haYU54K0V3ZU1LNkljRjRFNDVvdHJO?=
 =?utf-8?B?OTBHMmtMWmEzTi9YWmU4NlZzV2FTT2UxRVlHSWxYQmtPZ2FSRWZmMUYwelNT?=
 =?utf-8?B?amVsdjVtOTM0YURDaXY5MWg5UVBHaGkvZFlWNXp4dC8vSUs5WFA5MWNjdkZm?=
 =?utf-8?B?V2cwVHg5YWYvQ2t2THZ1YWc4blZJTDJWYVhlejk1dXJOVUw0R1ZxbGZqZWRy?=
 =?utf-8?B?V0o0QVNNUzhHSEJhWXEyc1ZVSE9mNVdPUTZkdk1GdVVpc2RqVGZuUW9FdXBY?=
 =?utf-8?B?UW9qQmRSdmlMQmdFOVB2emJNRldKM0NwdkRtUVZaZSs0S0ZyRGdQZHhiQlk0?=
 =?utf-8?B?blpMK0daZTR1eUxsQ3Vtazlnd0IvQzZMZzQxdFhONUYwWDhoN0tlN2lRK1BK?=
 =?utf-8?Q?c+S9fl6KIfHR0XN7IEGBocRZbSb2+VbgJ6POI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejh3QUIzclR0R2oyQTZsa3hxSzVtekJ5eHVnTHJkd3FBaFNYMThoRDhrcWZ4?=
 =?utf-8?B?OEZzSDQwUzM4TEJGdjhMNERJMVNRcUlibEpsQUZudGF2WlVwMXVUNndqYS9l?=
 =?utf-8?B?TDdZbGVWd2pOaVNmdDd1VmF1TzRjamR6a3dzUVpXTE9CamZMdDNPSHV0cjJ2?=
 =?utf-8?B?SldnOXpmNGoxZEQveTdaU0UxZXhWV3hva3hBOWtmSlVuaHdsTWorZ0xhekdm?=
 =?utf-8?B?akp4cmRzUkN6YlhuNTBRWHpUcFBRMWdxZDk5VXhoVnBMSGo1d21HQnArZVFE?=
 =?utf-8?B?ZWtLWjY0RksyVHFlSkdjcFgraGdTTC84MTV1eU9wUEYwVnNreVIyUDMwZ2FG?=
 =?utf-8?B?V3R2K3NHOWlmdWg3a283Y2pNdjJKeUN0TmhSRTVlRStWV3NGZWNOTkc1SmNv?=
 =?utf-8?B?elJGL25pc2RZMGFnWVRRUytBcnVMRXUrVTV1S0dmOFQxOGZGeEgyRHdpKzBz?=
 =?utf-8?B?blVyc2ovVnRhQzhldHR3ekkvV0RSejdCS3FVai8zT3JqVDhyWWU3REpBdzBw?=
 =?utf-8?B?azd0TW5QdWRiRWV6bURxaVp1UXVtdW42ZlcrNjhPR0Y1T3FsdGg4NW00Z0RJ?=
 =?utf-8?B?clBUbm9qeUF4ejBYZ2IyL01YNnUwNUpnS1A2SHM2VTVnanN0cGVWZTRJRmRx?=
 =?utf-8?B?U1l4ZXVZSWh5ZStFMkdmQW5jQUdYb3pYRUZQNkh2N3dSTTZkYmhDeUFKVGJm?=
 =?utf-8?B?MDZBN05aTjdyVUtCV0h5L0d2bEoxR2l2Um5FLzhkV0hqVzFJMHNyVExnN0lo?=
 =?utf-8?B?OXE3bXhuem80bHdvQmxqaC9JVUVha09sQ0UzMkcxNkU2WmtOUUFNdExCU2Q5?=
 =?utf-8?B?azVkOTBlV0hoTkJpT2tUUzVmaDM0VnhmVUkyTWxZbGZvTmIrVjZsd0JreE5B?=
 =?utf-8?B?RzQweHYxY01rQlk4cXF1aU9XV2tnUXdoZzVDNGR0ZDBsY095M0I3MHhvM1VL?=
 =?utf-8?B?ZFNna04yQnM2bk1McFFyM3g4WTlnZmh2cnBBL1luVE1HWFY5UDgyZlQ4VEYv?=
 =?utf-8?B?dW1OUXd4TE9HMjVsNnZ1NzRTSkFBM3NkT2ovd25hSk1QK2VEd1hrM2gvVzZy?=
 =?utf-8?B?Q2xiSjNBb1BNS3UwOWlDamlmZExIT2VxbWpYMTlHVHdkSlZTczBlY25taW0r?=
 =?utf-8?B?cHd6dDF6OXNKSHRJQlcyd2FpM3hxOUJMZGFNTGZJeGM0dFNSaEc5WVZvWEJv?=
 =?utf-8?B?a25iaE84aFk2MXovbHZORTdXaHVwNTAzSEtLTVMwUnoxaExuZzRZN2VuU1pL?=
 =?utf-8?B?ZUo4by9PelYxTUpkODdxSCtBZnAxOUsvZ3ZDUE80dVBPV1RzR0FYVklzalZL?=
 =?utf-8?B?MXVFUmQ2L0xUUVVtVXlpVGNRVEhPSis2WWFCZytLNkdGcHZ6UFpTVHNRT3RE?=
 =?utf-8?B?eE1mMGpBWXJQMW0rS0E1YWxaUExtRGR3Wkc5V1ZSU2x5TUtENW01QVk4V2FY?=
 =?utf-8?B?ZWI4VnRFU29qQXYrNkRyOTZ5akhTQ1hkRzUrM3B4QU1qTjhiSnhjTnUxcDV0?=
 =?utf-8?B?Mk1pL2FEVENjMHB3Q25ubzFJLzVaYW9vc0R2d09GUFhHSXQ1STg0YkZCaFFz?=
 =?utf-8?B?c25vazRBd1VBbXlqa25qZC9RNmk1bi8wWWhWNjh4VXdyR2JuSEJuM0xaWjZN?=
 =?utf-8?B?bHgwOEV0SEt1L0JTSVk4NUtCYnppdmhSN2NCZEY3WCs3WElMRWNNZk9EMC9i?=
 =?utf-8?B?SGUya04yY1dsMFFLMllGdkZKVGJNaTduUDRjdWgvUENPaXFoSjdDVHhna093?=
 =?utf-8?B?TCs4U1dKTDFNSEhxMFVUN3JVTEpNQ0RTcjJtTHI4eU90RllhakNlNFg4dEJV?=
 =?utf-8?B?VHBwNHVwbldkT0xaOFhaU1Y0QVNYaURIMXRRMUdwczhYcG5wU3lYVHorZDRh?=
 =?utf-8?B?UXpHUFQyNkpsNEtTNk14b1Zub3VocUFPWmdEKzhVSE9PWDZzSE82R2xwM3A5?=
 =?utf-8?B?VFNVWkhuejR2cEgrajIvdlFobnNTU0tvMmp6UjNpVEJEVjQvMEkwMW5iTzdP?=
 =?utf-8?B?ZmVFZUdXb0RUTUlpSVkreUFmTExBUXlHaVBMUURNSHJCQnFtZURNSS9SWTNh?=
 =?utf-8?B?bDdWYlJKRnZ4c3hndVpQNGJ5Wkg2emt3MnZzbkd2NFhFY1VnY2I0WHQ3c1BL?=
 =?utf-8?B?Y3kwQVJteFZrUzNVeS8yTzVEVGdaTFc4aU1vWlE1eUIzVW5BMjVST3BBUXJD?=
 =?utf-8?B?WlE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bdcc156-b12b-48e9-e946-08dd153ba88d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 14:46:53.3100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7eUtR8zk72tipMQLfC0lfTHgWPxFObH7yYxEkZ5PZHxfpydx74YNGTJaMDKWPzD2uVvxz8raCs/0bCadtIofQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4212


On 05/12/2024 14:39, Jon Hunter wrote:
> On Tue, 03 Dec 2024 15:35:27 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.2 release.
>> There are 826 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.12:
>      10 builds:	10 pass, 0 fail
>      26 boots:	26 pass, 0 fail
>      116 tests:	115 pass, 1 fail
> 
> Linux version:	6.12.2-rc1-g1b3321bcbfba
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


This is a known issue in the mainline that was not caught for Linux 
v6.12. It is intermittent and so not easily caught. The good news is 
that a fix [0] has been identified and once in mainline we can backport 
for stable. It is a networking issue that is causing random test 
failures when running with NFS.

With that for this update ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

[0] 
https://lore.kernel.org/netdev/20241205091830.3719609-1-0x1207@gmail.com/

-- 
nvpublic

