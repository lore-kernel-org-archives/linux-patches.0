Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023141ADFF1
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 10:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734084188; cv=fail; b=Pr6CIjF9jBB7uegjDPCDdk+ZvELAG1QWiCRNSwBFRlcKz8hrpngYj/EIn/tSlKqrBgG3GeoE1TR8sJCOOgMLDsDskAKsybqGrTdHJyxs/3biTvW8jcZL5UcsgLigx+l//TNRss7pXvrXy3fydVM2HVbwxdWECECMIbBe6y8W2Iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734084188; c=relaxed/simple;
	bh=eQaMdsxAgEogymnecNgPDRux57jhHPSXYlrDskpyei8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QX5nzYyrAxa2ixtqepbY5RJ6pBNTuSSyhivKmjqZr6SwGuyDXEcy8vE/aN9kK0dWRYOCcIL6fGDJd9AjnFpsXYKZzMkKNszT7u4Du2/PmPUiEar5Yl9hHdOWn1crEIyAzvvmiryLU2poIv5Mmra1av2WjXLtguP6T6gHjzMeb7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kkh7t3sv; arc=fail smtp.client-ip=40.107.243.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kkh7t3sv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxS5RvQ1Bb/nil4gHSpdu+o4giD/qCZhgj2AJYzfsP9fRPxKtVa28CsLEx963IhkkeNVyezoyvvt6tfj4IDOIXR40XAIiai6vbGSd+fGA9AvXzWvc2+Ff1gAYBCdt9Zv/hpsFSa7n7ffFZm02u3vvaYJAk44QB8TJ+H7xXVBfOjI3wRuiImVqXph1XuwNN09ihWRICJOreptkHQG7Iyd1tZ5Vgv2V7MFUiJfw8PefryK6fycgP34vmnMXEhnkE+GzpfG5GXWJz4T9DsFbvVBeEUY0sSluRaghFngZc4m6us/SjGfp2WzIPEonWwJNFVhgKrRcK+K1EjEpgi6dgB2/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn3lUvxokipm/YphHeg01BoUc+f7Cj6NzZ+YaXKpK7g=;
 b=T71evEjF+n5/qt/q0Y1BAUolST8HQQO/YZegOe1FsFbQqf0twe8fXkUgD9IGHjgvXeMmXccn5QkQSbBfHhF8g3R80Pfvr35M5zniy0KLl9JHNibGeoXmcvsb8xJUj02g6fa+q5GUFflNjPI+Z7XykqQa663kTOexf4kgg04rVmfy0wtnyAzApJrhDv6URR6NMQxHAJjlQUofF3gHVhVfudCAVbtmjT+uiPLDvKLU27DjmwKm6lGZxf14dmGyugHX83tNXr0n0QIMfIWAjlw0U+tx/uoJb0V5sD4sWjgQaEWK1f54dvtjQKiv3+BES0KYJz7JHqOlKxTbBOD7OXB9wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn3lUvxokipm/YphHeg01BoUc+f7Cj6NzZ+YaXKpK7g=;
 b=Kkh7t3svuF2AhqT+l9zn7NRvfPZww1kzr2PnbAia+oudC3BWZTg4DhY1HaSmBImghaUmBpNSWXd2CgXXVgl/iCaVv5SnCMIVZeuF8tkR/2f8tG7zGzP9OdnEH9Gv+NRnuroY4apWC4uSzseBRwCTzf7PXhT/+mlX8GC6B/WspxETMfgVXWcWth2g0gu6pBuqktpXMblm4sOkhp+jzZU6zNJEkufQ5PPpsOAwT+tegW3e1flvYNesjcgcVLcR/gveuILH8ViCURTg+x8u+R7gf4fFD/x1ErSWV2zu+HQLUS0iiVdevWl356VLoSFmNtKgAhYyO6Yy0MXjmzUFSaCphg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.17; Fri, 13 Dec
 2024 10:03:02 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%2]) with mapi id 15.20.8230.016; Fri, 13 Dec 2024
 10:03:02 +0000
Message-ID: <aea1f173-65f4-4482-9064-751e5eb7591a@nvidia.com>
Date: Fri, 13 Dec 2024 10:02:55 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/321] 5.4.287-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20241212144229.291682835@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0216.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::23) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|IA0PR12MB8862:EE_
X-MS-Office365-Filtering-Correlation-Id: 821fc043-f087-4e3c-9efb-08dd1b5d54c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXNsWU5aS3E3clFGc0NOemVGSTZRZmVMSGk2VE4xOGlvemFvTVFqdUFpamts?=
 =?utf-8?B?bHJQK3k1dENtU3p0Q21CT0w5M3hBODRDeHJObXFlVUtYRjR1akZoN2g0QzU4?=
 =?utf-8?B?UnlPeHZycFdRd29uT0hEUkxYMjArdVlKKy9hWVVIL2Q4WVQzZDFwQVpTSlZK?=
 =?utf-8?B?MFRGM3A1RWNjRU5laG5mUngyS1U1aFl6ZHZpUCtXVnY2NGFzUm5Id21rWmMy?=
 =?utf-8?B?OHNLaVVYdDJoT3JZb2k5NG1qNjB4bE5jOGFDOGQ4bC84ckhrUHJTMkxNSExG?=
 =?utf-8?B?VDFKemJRZEs5WnlQRmtVOUZDY2xXWmVBM0VoVWJKK2JhY0ZTOGx5K2pMdTRo?=
 =?utf-8?B?MkU4dXA0YjdKaVhrZGU5S0FHTktIR01YMk43dXN0NHE3S2xiQS9vQW16bU1F?=
 =?utf-8?B?VjN1T24yTk13V0l0d0dabUE2Z3FWeHM2Yk81Q3FRRndUM3hTdXhIYVk4c013?=
 =?utf-8?B?dXAwRmJLaHdXWm1RV2htL29UdGZwOU1uWE0ybXIrakhXenZGZEc2bkx3ZG1J?=
 =?utf-8?B?VUs1amxBQlhMMW5PN2x0ZnR1TEMzWU5zSFdMaFdWRkhqRTE5L1VWc0VWTzFQ?=
 =?utf-8?B?WWRuM1FjY1hsVmppYU9hb3oyT2pqdzhIVDZ4RXAyTWNJN1ZxcktObWNrUmZp?=
 =?utf-8?B?TUtkR2hOeWhxdGRwb3VGRUVtWWtsNjlWQ2V3UmErZEthTThkclp1VGFtaUwz?=
 =?utf-8?B?TURHelZzZWl1dU1uZGdsZUova3lhdlFHcWluSUllc0ZQL09lWGNkWjBicHQ5?=
 =?utf-8?B?ZVZscUFVdG1rSmpMZTBVZVZBOFRreTEwRTdaQXdjMHJZUzJrZ0N4N1ZxNEVq?=
 =?utf-8?B?QjEyZngycVp2cyt6NzhRY2p6emFuZmlqK3hocWIyMXRQVSttWHFKQVUvOUM4?=
 =?utf-8?B?bFh3UkhaUkZDaFFmYXplSVR5MTVxdkhxNGNNNWxmbk91c250RXJkTmcrNTAz?=
 =?utf-8?B?VmZIODNCZnRQckxkalc2NDRvd1pDWGE3K1c0ME9WUVJMaWExa2tZVTVXcXBh?=
 =?utf-8?B?RUk0S1A3c0RYN2FCSXVwNkdEY0dnL2EzREpjOGJCWmYybmhCclNTQk41QVpJ?=
 =?utf-8?B?enBLS3hNVXNWNS9RTVR6TEFoREpxRzZGOTRzOHNCRjZnYkVHaDdDby9CV0FG?=
 =?utf-8?B?T3hkK0hGN0t2empTY1R2NXdUR21CaW1Za21LNnlxdVEycTFsUDA0VlZDSHZo?=
 =?utf-8?B?RVhhaXE3MjB6b0NXRjFZcDB4Qno3K3JxT0ZrcXowMUkzcUhlVnZVc3VkVHdm?=
 =?utf-8?B?c3UyUFhGOVAwTTNRRmJSZmNzaThiSXlxaFVieVJ4a01MbUhBSXJlaUpkcDI0?=
 =?utf-8?B?dXY4N0hzRkNoTzBGdk5FZ3h4aWRRc1dLTnNEM0hicko3VEs4S3lIVk5VMlNs?=
 =?utf-8?B?NnVnM0FDSnVMSENaMytrUVRsLy9yajB4aE1hL0RIOTZFZGRZckd5VUM1VVJH?=
 =?utf-8?B?RHFqZ3hnUmtiVnJkQVdaeWpWcUpKdFRZNEJNWEdKMWlvUXFJdjgxTTllRDJ2?=
 =?utf-8?B?NWJhS0FmVDNjSEFxQ0lRMlBWa3pGWGRURDFWWGNwVXJ0OU81OWI3d2dhNDR5?=
 =?utf-8?B?M3dGVTFBVW4wSEg1c3poMjhITFFlZmhucC9zMUU5OGJDbkwvWkhoSEs1LzNt?=
 =?utf-8?B?WWtObS9NMml0RnFvazlDTmtnWnJ1SmFxWGZ6a1pUWTVjQndWSXVXSFhvbWpX?=
 =?utf-8?B?aEw1UUlWSm5wdEgwanpHQ09oY21rTTNmQmxqRjRnMCtrRVpvS0NnY2JwMCto?=
 =?utf-8?B?L3ZabStpNktBNEhKbmlLQzRNenZodW5INkJraG44RUtNR3Y2eDROSXFaeG9u?=
 =?utf-8?Q?O5/repRLxKeApSy/Gw2/1uHgkKKTxfUSXASfg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmRnRTFkZDFIRy9PWVdlMWdvZmVVMkFGQ3ZBQ3ZOdTJSY2VsOW5KcW9XS3U3?=
 =?utf-8?B?Tk5oSW1iQmxEN2N4bDZwTDRWWGtVY1ZiNFU3K2IzTko5dmVqYU5yUk9DTUUw?=
 =?utf-8?B?dTVMbGYyNkorWXhXSk55bGUvT0lhSmtzZ0Vaa29NQTRMaWxaTEtHWS8vQ0g0?=
 =?utf-8?B?cy8wRXNsT3h2enJKVDhONWRsd1hHNDBhVndPWHgxcjJDVUlPbnMzeGMvWWdE?=
 =?utf-8?B?SWxDU0JINHJHMHQxZk9nSG80S1UyM1BVV0d6QUIzU0U3ZGl2blprRFVXQzly?=
 =?utf-8?B?Qmo3dThWM3lKc0dqTFdCZjErVDFJa2ttNGc1MDZabmR5WXpLZDNTSWNIVTE4?=
 =?utf-8?B?MnIrSG90R092TUt6OUlPSkRINUZiOERKVldSdEFWUkRnT2VRV2k1RlgvZ1hx?=
 =?utf-8?B?bWtVeSsrVEwyQjR2NXVSYmhrTXAyZlgrK1R3endLaVQ2MWh4R01KaEtJWXU3?=
 =?utf-8?B?OTNwRExXS1BzeW5xc0RPajJPK2hoL1Iva2RCcmpsaTJvOGpMVFdJSWRRQ2xv?=
 =?utf-8?B?QkJESzEvSWtSaDFIb0p3UUVhNXRKTUg0N3k2OGNRNW9tZGdYNXFJNm5PdW1Z?=
 =?utf-8?B?b3JQQ2REODMvRWR4dHlaU1pmM1c2VEVIZmlGM0ZwelNQU20xbGRwVk45STRQ?=
 =?utf-8?B?dnM2U211Ykx6TEFlRUcvYUI5YzBxRnhZbmUxcnhnZ0F4MnFMdjVVdUZSZUR1?=
 =?utf-8?B?TjJYRlRzTnVCRVp0SUN0ZXI4L1Z4WFk4cE9NcDRYUU02NEJQanhnZVA5T3pH?=
 =?utf-8?B?Zmw0dTI3dGc2RHpvUFVNL282NmQrc0lhaktxRGdZcTE4djROMlExTlVwYjNC?=
 =?utf-8?B?OWJTL1d2V21BVjNGSWRpYXRHUkJYQ1RDODcrUFA1K0tjTHF4MEQ0L2pKRkdY?=
 =?utf-8?B?M2ZYaVkwcS9PZHFRYUNZZU1lR2dXRGJCcy8zeWJTbHg2bXM3ZzFlNDEyY3V5?=
 =?utf-8?B?cW9oUTNlb01PTjNha0JxeVBESDlLRk5xSUh1YW5FUGxQS09OWWhqa2VvNkJE?=
 =?utf-8?B?aDRvelB5MXlLVVArZEZvWEppcitHcnkydjhNYWcvcU9XOFFFbGhIakdvRXA0?=
 =?utf-8?B?UjZaam9yYStzaXhuelRXQkV3SE4xaU03QnhyRU9pbDM1MXNtc2FpTm1aRmpE?=
 =?utf-8?B?eDJnMUhxUTNyTkVIbUU1SGNGK1ExNEprMENaWFZDNFVCcU1KemdMZWRyOXkz?=
 =?utf-8?B?V1J0VWlkOE9qWEJEVGFmWk00bFA2MVYvQ1phc2FXWlU3eEtDUkVVcjNidjRw?=
 =?utf-8?B?SkN0bXJjaUZWWVMrOVdwZWJpbVNvN1JMRFNJdW5RRUFCOW9qSVhJdG5Zbklp?=
 =?utf-8?B?VG9KYWtVcE9xdjVQQ2hrOWRmdUlRR2U0Mnd6TkZFUjFiV2d5MEZMN1RmdEF6?=
 =?utf-8?B?ZnpiTHVFWDJnaUd1dUI2dGQweWdYT1lRdjRyVFdkcTR2THZ4czhuVGd5RS9w?=
 =?utf-8?B?TFNjamZRbDlNY1d1ZXhBclUxT3JVaENVNFdHaG92TFA2cHJodGNxaDZWZTZZ?=
 =?utf-8?B?OENYUE5jcTIyWnRQZHpUZmJhZkY1bXV5SklDd0hDek5mS3Y5a29vcmtrRHF2?=
 =?utf-8?B?OFE5S3dmWExUdWJTRGlQejNIbkdaU0hvVlE4RDVZN09yWjRJc0dZbWhrZDY3?=
 =?utf-8?B?RTJvRmVJNHJPeGVkRFk0ZmtBLzBwYW1GalVxZVBRcXU3MTcweWhvb0JmTGY1?=
 =?utf-8?B?eGdKUEVNWFYreDZKWHNjY1VaeHB0cjJ1RVFNUGZRTDlBb2xIN05ybWkxZTdF?=
 =?utf-8?B?UENkK1dSSFJzdlJCdWtoY3F2b21tNHR1VEp2TG1FbldqMW5wRElUVDhWNnAx?=
 =?utf-8?B?bDFSZUdGSXVjaHRLNmdxdU9pdW9CQmY2MUEvV2JrUTBrbG5QSGVBcnhkTXcv?=
 =?utf-8?B?V1REelJrWTlCVWRiOFFEZjFKdEpKV1lWTzVlUm1HZmlXVUlQUUFnbDVHV3Jk?=
 =?utf-8?B?QTF1ak9iL0VhQ3pQRDRXNHFBS0hReUZ6Y2hQZndFODZaWmUxMFVvS1Vha3NK?=
 =?utf-8?B?eTlscHZlTzh0UndZSkhjdUU1WTJqbm1BUUN6ZXNZb2JXMVltTnJ3RjlwRHJQ?=
 =?utf-8?B?eTVUK29hZkp4V2tkdkNhTlJBRG5IKzM5WUhCY0tiZnFXWGtCZDFnTWFQTzQ0?=
 =?utf-8?B?NURPekFtZ0RBYkdheWEzVXFJQWhJeG0vS3FWVXc1eGdUalArMlJkbHV0dE0v?=
 =?utf-8?Q?0EWKChiH+Zp8O8oTmijX2u45E0cEtD0ZlNWPKLHXde6Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821fc043-f087-4e3c-9efb-08dd1b5d54c7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 10:03:02.7073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZKJhDrB7vAEGTVIawDmUhlWm12v511tkHxkgM4CSdJ588VJ4LRD688fiCS7eeov9eGLVCYAz0+aVJGAmpqC4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862


On 12/12/2024 14:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Builds failing for ARM ...

Test results for stable-v5.4:
     10 builds:	7 pass, 3 fail
     18 boots:	18 pass, 0 fail
     39 tests:	39 pass, 0 fail

Linux version:	5.4.287-rc1-g3612365cb6b2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra30-cardhu-a04

Builds failed:	arm+multi_v7


Same build issue already reported by others.

Jon

-- 
nvpublic

