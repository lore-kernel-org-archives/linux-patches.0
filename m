Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E866C22688B
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 12:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738843465; cv=fail; b=VmQrmC3RuFFa9p7qgMxmCfRaz+ri9aOCMhHTocAWimtKX4Vrc2jf6uzU1zAF+vOLqC+IBrCRFWl3Ip2M0UrIsjRnWMcO/wAbrekeFCRdlOg92fXUZ5Wq//VFsmy2SBTjB3rpd5guSVPrgY+zkv0sW+hJlX0EY1thsD0eeY0SB2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738843465; c=relaxed/simple;
	bh=Ah0ydcjERILS7kj15i0KceXPrCD4zF4cb9qL6GmztQk=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WcJTKuEbVbAbMIDnH1hahTgvEfR0nUaL8OJKL8WD7b0j9ZRf76Kyu8d0OewiUQ3AUYT/nncSQYymhqaTzjKEcm4foX9ODJzglQ+qKzcqEw8uc0fj5otwUq56iMke0CZu6IXgxvMq/e4Un9mdgCGMHQjfPtmd85LHAQsWlxUiAuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bszBHoAu; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bszBHoAu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BUbSoKWX4kNGNrFUR/dh59vFOz7to4mkDU0DLBsmGBkTZnPs+eCBmb4WmYetgcPkZEK29IvXk1VbkRY7/tsRt0vDs/v25TaWP4IsvF1lC6LZaRZufBiUIK/IK8kt0QBXhPXijDLcETKs4q8uDtJbGL+PpwDMBlqCuJ1CngvjKgHQP3+w3g1F+00DRQKcp2C+Z3694jluCB3zNu8G0dhO0HwJEe4Q3mWCZzmnf11YmFxe+dw5g9pvLs1oHVSvoMSsfqu7R9lAhS4IGcI0jP3jQdi8/jZfcJxYmBEn/O2i4vPlikgeOT5dwo3Z/rU4ZSXx7rfwMa4HvIDB37SKVZVSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssJJ3cnZLWOfNzhn9JA7yLDqNFbu70tV5fVOMBARxUQ=;
 b=PZufRarontjRXC+i03mzOB3CARSXO1K7FgH1PWBOPUeVceB2+DDM6gfcQoULj9pUk3SZiaLuq2g+f8FGct/BycfGDjUV3X452/fa/4bl62UyMQ2qhxQKedsRpoZnbusCRI6AWqqAeWU9ilZLvwJLRiodB2P7lR65YGHSDjk68aQIDHKISUHL/JFq4XTMwpJw29dJJU4jrMlskpeBPMGX4Ibgp2nSvGnHlJ4+V6SMKku1+L3InWvphbUBWoDzeyN6HNhrRUJivBrsUiqRc8lYvFJclhvJblpxaIUmJAz9teyUWAjk4LFHbfMS0dTaF8dhUlPLsKLxdWJpZzD+1EZclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssJJ3cnZLWOfNzhn9JA7yLDqNFbu70tV5fVOMBARxUQ=;
 b=bszBHoAu5WOkp2bR01w0gE0JhOa34YIhHcoa6gc4iNDoGrNJ9HhQdJPD4VugzteFwK+R9YVvqWUyEcA0n6iBATgsLMJZyn2LU7QCylqydLA1k0hIieyXx36AmDK0uMn83k8HQxex5nS8o0Cx/B6HkucMeGmf/D/Hfqy2nJD9mkV4U0BqSG16M6NQ12BHDNfkVMpBGEnidnZXJqyqENeXkhTN+W63l+5rP8O5PxNwsXysJt92BnNprxPcS3gTD5PODhezSKOV27OczTITxgmJEqrPMj97rNwHoWJdeMmO2LVe/dT5cVGWv+/2i980ttO4DfVsTcGPXtMY8PY3bxvK7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by PH7PR12MB9254.namprd12.prod.outlook.com (2603:10b6:510:308::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Thu, 6 Feb
 2025 12:04:21 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8422.012; Thu, 6 Feb 2025
 12:04:21 +0000
Message-ID: <8ab5ab07-fb63-4235-bdb1-f4acbe86f8bc@nvidia.com>
Date: Thu, 6 Feb 2025 12:04:14 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250205134455.220373560@linuxfoundation.org>
 <ea698e1c-02a8-47f8-a66c-b7e649dd417f@rnnvmail205.nvidia.com>
 <b7363e74-2207-4cab-a573-bc552b901f4e@nvidia.com>
Content-Language: en-US
In-Reply-To: <b7363e74-2207-4cab-a573-bc552b901f4e@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0197.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::22) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|PH7PR12MB9254:EE_
X-MS-Office365-Filtering-Correlation-Id: 5317371e-f6e3-4c85-b8ba-08dd46a663cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MGVuOGZJRVAzMjJFQkdsWnYrRUZNUnVVOC9tYWVrK1E5VjVlc2dlRWFMMlFv?=
 =?utf-8?B?Z0w4ajZweVZNcjNmZ2ZwbnozdDhMQURRNHRiVnRqSXlMWGZUS0Z2ejFUT1px?=
 =?utf-8?B?M2JabVl0ZVMvRGN3SCtGU0hUaWNlbnIzSk5QeFNSelprb0NwVnhiZk5xMHNq?=
 =?utf-8?B?TXFIWkRaWUhQb3c4SnE4SHpGNjFoUFNxb2svaVJSdHJMSnQ1b2xJOURYVjJR?=
 =?utf-8?B?Ujd5ZTFRdnVEVGYrV0ZKcEdSeFd4VFRqMXYxMzgvUCtDdHdTVTRVRFVUNktj?=
 =?utf-8?B?WW54clRDb3g0ZlhBWXQ4ZHJpWVIwZTAvaWZqRUZuQi9ad3l3RXdCVGRtdVBy?=
 =?utf-8?B?d1VyTlE4Q1lnU3NybC9vaW1xdmhkRkhQdlZ2TG5FMUFEMDB1c2JIT0JJaDF5?=
 =?utf-8?B?ZWFmeXVEM1BaUSs4d3prVEUzRFV4SXNNS3VMMy9xZ2UweU1OdktkamZqSlk3?=
 =?utf-8?B?Tzl3TkdHcmYwaCtBd1M4MlY5RzVVNFRBMERlQjVYSlpIM01OWUM5bmhBeUVT?=
 =?utf-8?B?TG03VC84bzZJeURkS2N3QXMvb0hkRFJPbGRMcE9NZkZmc2VMbURPYnN4S1NN?=
 =?utf-8?B?YzFUS1FxK2ZzNWtzNy9iZlRBTk55OVdRMG1xZ0hzY0o5TnUxczdsNXptOTVr?=
 =?utf-8?B?UDZld2NZL3M5YnZvSC8yMXNyTFQvdklKWGpXYzIvU3kxMjB4elg4ZlNONk5n?=
 =?utf-8?B?VDQxby9XdTVLN1N6U2M4YmhjMm0vbU5pS1NJLy9hL3Y5NXFGMzhWNXdMb2Nk?=
 =?utf-8?B?MnZ4TU9QWFRUTkdpeTVTckZSK1Q4UmNtN1M3dEtORFNBYmpHRWdMaTJGelJE?=
 =?utf-8?B?U0t4d0MvNzN0SXduQ1ZoTm9QNVdhTHJTTWhZVWxDaUwzVWRkMlQrVGpVakJC?=
 =?utf-8?B?ay9oUkh1Qmt0RDFoTDdnYmo2UGt1ZGFqanVFck5Pd3paK3NPSEJCYU51bytZ?=
 =?utf-8?B?K1dCWnpoTThyRG1FbTZWVFJUWGZaY1k0MWNyUWpKMHcvb1dXUmdFcTVoNUxY?=
 =?utf-8?B?bHhCT0U0T3BGWXUzSjV0eWVVdWJOTXZUTEFNZXBSdlNDaHpITkJpZ0lOcGth?=
 =?utf-8?B?Rm12K1R2d1Q0L1dHR012MFpZWHFldjhOaHBKZ3YwZWdPbkRKMnVsTFdjaUx6?=
 =?utf-8?B?WWs2QUJGbEZkRDA3OXhUSk5OaU8rVjhXVlJnMGFvR0JqcFVyTExYQWVLSUJ6?=
 =?utf-8?B?cXVvazh0YWVYanZWdE5YSHl6cE9lQm9VODJpVVc1ejR4c0tmWXpSUjVXMXhT?=
 =?utf-8?B?Q0IvWWwvSm1uUnhTNTYwd0R3bkw3bVJTNE5NYlVWdFFBbUZFUG1nVTlUbjRq?=
 =?utf-8?B?bHNoRXFhUW1vWFM5M0x4T2Q1a3pCU1dSNzlUcTZJZjY5K2NPZmo0T1BPQVFB?=
 =?utf-8?B?eFIxWnRTRXlWR2ZaM1JSTEdGTW55VnNWUlZPZUNhYWhYNDhVM1pyak1YVkQ4?=
 =?utf-8?B?VGVPZEs5YjJYT3ZSRG1CNkhWS0NaMzlnSnA0elJ6ZjF2L3dmN0VyRDVyU0xV?=
 =?utf-8?B?Sm5uTDRkcEI1VlVDT2laRlFJSHlUcklCQWJTUnE5QSt4UEwxVS85TW9jaEtp?=
 =?utf-8?B?WmJqYnFsdlNqSkNPSmJud2Q0OGI5ODVkS1NQaHVmRFdlOXF2WE15R3NxZW4x?=
 =?utf-8?B?NHRjZXkzL2wvLzFoYlRWREx5UGtUbEhqTkpsc3VpMkRFQkNUYTBUcFJ3NXdG?=
 =?utf-8?B?VmFEaVRuWXIwdlBscktXaVdjeEcyVk00bEVyQWQxQVo3Qk5xMDc3Y0pTdWU3?=
 =?utf-8?B?U2tjTk9lNXh6R3RaYlNjMnZSZW1UYU8waDlzdVROQi9aMlJTVUlwR1JlVUI2?=
 =?utf-8?B?bnZES2krOXA2eXIxMUI2eWppVkd1Y3NNOTVERlBYSkdxM2FxM1dZQkxzUE9r?=
 =?utf-8?Q?ouBxdpC5POMOZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2FGUlkrbTQreWVJZ0MrVHlQL2xqSFJ1SS8zeVk0a2RFYjdzVWJFaWVBNEN1?=
 =?utf-8?B?ejE2TmdHS1p3eUMraWFGUklLa2JqNk4ydlpPMEtiZzNoMEg4WEVUSlBmMDRX?=
 =?utf-8?B?bGMyeHZxOGk5Vnl6M2hCYllHRnNubFV2cUU0VFptZ0hIWHNOcUNDbXg2OGla?=
 =?utf-8?B?UUpBQ0ZYbnZGZVNXYXZ0ZEdYaENxWFRjMmVreCs0K2laRTdvWlYwaC9XSmJ6?=
 =?utf-8?B?UW9ucGtPM0ROamNkTmg0KzhXSExySGhYUC9PakZCcGE5UzVFUGNMdEo4NkRs?=
 =?utf-8?B?cXpXeFZORTk1eExaN1VhTm9ObUlRTWdDVFdHV1pxRmpxNjBWdXlhVExHZUJh?=
 =?utf-8?B?bHpObTFaclluOEFYeDlrN0ZaUWFFdmZXQWtjVnRnNUVlaERPUzd0aWdpVEFV?=
 =?utf-8?B?aWdJVDdab3NSQXVTMUVaR0pWODZwQzVsdThRWlB2c3lONkJLUEs3eE1GdWRj?=
 =?utf-8?B?aStoQm8vY1p2QTFoREE2MEFFa0I3SUQ5cERwbDBKOHJhcEdWdGhBc3krYnc2?=
 =?utf-8?B?cEd1U3FYTzY2ZWlnamxKc2lEMHdIaHpwUFpMN3lkNzErOTMwS2RqakRqK3lH?=
 =?utf-8?B?dkM0VWFQK2pPNHF5SUJOSzk0Wkt5Nnl1WSs1Mk4rVkoxOWh5d3dkYWdNK3ZH?=
 =?utf-8?B?TTNhTHl5TTVCZis2dzJKZXZJbC92N2NuWmR3ZjJZSVo1WFJZQ3B1Q2RDbGlz?=
 =?utf-8?B?Vzh0TXUyZXVCQnRpUW9jWTJndWZnbVQyUnIzWTZGQXI2MW1DVi95L0dENHQ2?=
 =?utf-8?B?YkhhSzVsdWVmQUtFdWt1MnBPbW9vQXdYNUlWOG9ndjMxNFREdi9GZTMrTHpW?=
 =?utf-8?B?ZnRRZU5Rc3E5UzBOd3cvS3pzQUVCRlBRRWdVZldRR2hadFBha0hNMkpDNWR0?=
 =?utf-8?B?YzY5WUlXN2tidXZUbFpyNzdkbHFFQjk0eXdRTmhOUGpuRnYxRkhGVHk5bHZ4?=
 =?utf-8?B?eit4VW54d0paaDR4SHBWMFBNQWFjUEwvZ1RqbHlMajBZNFpEZnVJV2ZmcC9v?=
 =?utf-8?B?M0hrZzh0QlY4aURDSndiRlkrM1RHWjJsRHNlMkwzdkVXbTgrZzUyelVXNksx?=
 =?utf-8?B?L2sxMHF2TXFmYW1HNWRld1lzNk1YTE5wRUd5WWNDNGdwOW82Z290L0RyRmh2?=
 =?utf-8?B?aWlhbUdsUFRLOURGOWtVNldkSkxwc2l0QlhxZnFhT09PV04vOGxMT0dzRFpX?=
 =?utf-8?B?VmFmdWFLNFE2UGZZanQ3clZSclVBR25xSWVjTWFoQjlTRldWOXkrU0paM09t?=
 =?utf-8?B?d1JMeEttY2hZTU84QVJpM3VPZW9OZzU3VU5RMCttMStwVlN0ZUtsWk93bk1r?=
 =?utf-8?B?em1oa0Mva1hDSGdvSTVHbVBtWHg2ZjJSZkd6ZDRhN2F5anlSeTRVVXp3bDU5?=
 =?utf-8?B?U1VJQWdwazJ0bTFKSk4vRndTY1B6S3hhRHJyYlBmVVhFRkY1QUt3dUJhcER1?=
 =?utf-8?B?NlFLVUkyYmkwNDhQZjNybGJnVEt2Ym5PTStFL3lXMzJsKzZqM1hKSDZxdWVR?=
 =?utf-8?B?WUlnRTd3UFYzSzl2QnJDYWp6eUkzODRKNkJjVUtBOEZMNG9xam5TYS9DUERW?=
 =?utf-8?B?UGRxZkhXK0x5c1Jsc0pSd1JwTCs4K2hUNXFTQTZqVWV4YkxOV0M3eG5jRExz?=
 =?utf-8?B?UzloL0hVaEdzbCs1QzVpLzdxOWxDRm41czlneGMzKytiY1lrV043M2JKZTJC?=
 =?utf-8?B?L0x2N0VydXBXdmFLTlgzNVJ2M05udlRzT1IxTE43ZGNySGJSWEZLdHlkTHZ6?=
 =?utf-8?B?MXl3VTFlTlBpaWVVeE1TdkhmWDZ4YnRNalljdkxESGp0b3hjQkhOcmJXOStx?=
 =?utf-8?B?TWlLWVR0cUJNUXJoNVBFZXJadWRPZFY0a1NFcHE3d2lMUEVxeUQvWXpMRWVN?=
 =?utf-8?B?Qmp6TzV1UFVaKzM5Qy84L3g3MnJXMWNQMHlpNTJXbEc0ODBkNktjVjhkVnFS?=
 =?utf-8?B?aG9YV0xNZkJjVHRSOWpRWmpIZVBFZ3M0VXlUa0VsTTVzeFg5WTVvQW9oSFh2?=
 =?utf-8?B?R2lzbUJxT0tkay8vU1FXZXIvWWE5UlFBbU1HbjN3aUZWcE5uZ1dwUittL2hk?=
 =?utf-8?B?MFhaZllYb3hTeFc2VmtKU3QzdnFQVWZDbktvUlNRcm9LbHNJRGNZS3Jha3Zy?=
 =?utf-8?B?RzVRMkhpbjNwL21XbEhXTVJBVEUwekI4UFJkMWFFSFZKTysxVWNIK0xweDYv?=
 =?utf-8?B?dVE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5317371e-f6e3-4c85-b8ba-08dd46a663cf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 12:04:21.0979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zdahs5R5Pb5OwuKJX6+IQORlPEI0G0pEm8xy0MFaXaugAuXYQ5Mw8JsOS1BMMSdvILun8eIJNf8K9hrA6/Y4Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9254


On 06/02/2025 11:41, Jon Hunter wrote:
> Hi Greg,
> 
> On 06/02/2025 11:37, Jon Hunter wrote:
>> On Wed, 05 Feb 2025 14:35:55 +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.12.13 release.
>>> There are 590 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
>>> patch-6.12.13-rc1.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux- 
>>> stable-rc.git linux-6.12.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Failures detected for Tegra ...
>>
>> Test results for stable-v6.12:
>>      10 builds:    10 pass, 0 fail
>>      26 boots:    26 pass, 0 fail
>>      116 tests:    115 pass, 1 fail
>>
>> Linux version:    6.12.13-rc1-g9ca4cdc5e984
>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                  tegra20-ventana, tegra210-p2371-2180,
>>                  tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Test failures:    tegra194-p2972-0000: pm-system-suspend.sh
> 
> 
> I am seeing a suspend regression on both 6.12.y and 6.13.y and bisect is
> pointing to the following commit ...
> 
> # first bad commit: [ca20473b60926b94fdf58f971ccda43e866c32d1] PM: 
> sleep: core: Synchronize runtime PM status of parents and children

And 6.6.y too!

Jon

-- 
nvpublic

