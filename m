Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253C231827
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836220; cv=fail; b=EBn63KQlbesgJBNO5F2LhAC583FvPboEBn0jL1zZhqgLE32PFOA/Vb8vbcHPOjhalQvnBVCYATQJn4CMmk7lXhMlRKyTxvp0BtD4tfJF5sQOW7l9NpLCPH4odOYV4yu5ukkcQPmFmgTvnVLxU1hmM7i7HLBH3j/WyDuFGy4uad8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836220; c=relaxed/simple;
	bh=0kRA5n7f9cJp7F/+I4ngtBsc2U3klDMDkTAynw/wg6A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SrGB7WdoLm1vzU9FKkcMh2PfzVUO04oE/XX0lINURnvfl+rJ61fzVl1x8QtZznM/ECRwxvy9jpqVeznUrP16085sCPySVma5c3MGoUzNiBXQ1ybb68Aezn7X8ev280RoUzLcyTOHa3AvU/SlbOuDnKihivHFpOYtotXtU5963vA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mshRRTUl; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mshRRTUl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dip0BAacTznx7C/q0arv1zAzLrbjrSFFs4a6K2ED5AFKgUOL5xzkUOscJNfyv9b4IZ7oh0sbH96j9QAUrn4Ri1r4DJBWCDaBZYV5jYGgEWf16yF1ikaBVK7IAng4qfsU/3f7sIl2sIfMR53HwBkbPQnmUbmVlEwRgOwn1yqoEeA6M3TFwtirCpQn248uKbt29MS2fynFgnpbHpTIHdnz+xmxvbBqBgUM0ixoVjFGUNrUeV/nIJKFYnXdW8s1jyGruEo9vUxU8My/9pBL9hOV5cdTe42cr3C/+KBoNRVdorj66YmOyIiJX1jFd+UMF/RbynhOzXnhvMEiAAWj248yDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9Dt/3xeNC+H2Y2HML4RENFmYeCRbTw8Jt4jpZPIEF4=;
 b=U1BmfhAx9eX8Au1yx32P9FZrpQaqznKRQQhT3x3ar978t3PCm+mNmdUbHgfv2pT4hSPc0gNYb/SsSTPa9gbVjOqIWrmzgl+BeI/jg3hQr3+uVK/8VmVkdIXBXFA/BFVG8oCr/LYhjTSn6AU6TK3egHREvD1sVXdTYgA8aSGFhT9gTNmpZ7g8G56BSElUwfUsE+5Olmlq44iR4uQnqBZRsTZOePjbgSWCh+c4H6+AT3Fgk1GXtFVVXrDs4KPibqLYVd9EUWvbNlVBW03nA4YmGS7IJDWsccdfaqtrvLHIjhOiHWQLV14GaiH3G4nGQEDbBpoe2bY34n9+7JC1n6KKCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9Dt/3xeNC+H2Y2HML4RENFmYeCRbTw8Jt4jpZPIEF4=;
 b=mshRRTUlVKM4yEi3sftyKkiyEiqogKzlnirduzq5C8mMKPkTL/8c/YFcVeeXvOvrYN0yzClctrPZ7RK+vzFT0/KfJI0EsIBackxh2Mf0sEpqXAf05w+rrGG/ishklWLFRulvGfElJqJxU4HrdzjwspGCVis4WxNShJrpqbGnT2KmAc2pCx12roKatL890UXQ44KcU1e9SNSKSOUeA7cVNtiXnfjcN+UeMBf5WcO2MMUrrOV3gruw3AUfpceHkkoLaL1BcFCKgxRAaz84RrBo8CDT9FGqSFE0d9Ddajov2fh6iSV65m19pjiy/9AyKC28GSsW+62YFBNFTG4UpWm3wg==
Received: from BN1PR14CA0003.namprd14.prod.outlook.com (2603:10b6:408:e3::8)
 by BY5PR12MB4035.namprd12.prod.outlook.com (2603:10b6:a03:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 18:03:30 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::a5) by BN1PR14CA0003.outlook.office365.com
 (2603:10b6:408:e3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Tue,
 2 Sep 2025 18:03:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Tue, 2 Sep 2025 18:03:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:10 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 2 Sep 2025 11:03:09 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 2 Sep 2025 11:03:09 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/23] 5.4.298-rc1 review
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e20e2f9a-560c-4b0f-82a5-bf96642130a6@drhqmail202.nvidia.com>
Date: Tue, 2 Sep 2025 11:03:09 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|BY5PR12MB4035:EE_
X-MS-Office365-Filtering-Correlation-Id: fefc5c0b-fad5-46f5-1497-08ddea4b05fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnFqbWdQeWIrUUpYU0RpTnhlV2pIMElJK2xGcmNnVnRkazk3Z0VrYU1GaHpi?=
 =?utf-8?B?aUw1QWFLcitBR3dlTDBPTmcyMTBZMlNiNmNzQWhXU2VML0Y4TitPMjVORURB?=
 =?utf-8?B?SEliOFdVU0JIK0pndGZDcGdtZDUzR3hlcHNhK3VzTFI5aytsVUE5Sy9uVUx1?=
 =?utf-8?B?K0RFR0Y3QnM4RC8yb2V0dlprTGhib1pyWFpjeGNzTjFETDJaekRZWTJzZlRk?=
 =?utf-8?B?aDJKZXhteW0zTGFWMndjV3hpeUJiNGxKUGlsMDBCZFo1U1ZsZHJTMzFXOC9T?=
 =?utf-8?B?Z2J3MTgxZHp4cDErcDEzQ3ovbTBEanlZY09pWHVyUFlqejUveU51MUJPeUc1?=
 =?utf-8?B?UGhyTlRGYXlzSEY3dWdCYXRNaHhEM0swa1M2RTFmQkpmc0U1eXlmY2JZcytD?=
 =?utf-8?B?RTRrbEZjdlZacmoyaUErTFpKSDRNcXA4VnkxSUw2dkdXcW1VWmZGNG4waVRG?=
 =?utf-8?B?SEI2RlBuWVBVWmliY2k2YlY3ejVER2RNVEhrbTVBZ2ExSlJ6UVdpZlVLSTlj?=
 =?utf-8?B?VXZpQklBWTBGS0t4THNGVWY4dERob2RkT09sTGN5U2ZXczUzeUhRQy82TjBu?=
 =?utf-8?B?M2xPUFgwVHFsVTNHb0Y0d1FIVG9nUFFxSGJrQjYrQUV1K0pZS2l2NDRzWjR5?=
 =?utf-8?B?RDlNaEZUM0pBNnpNbklGVHc5UDZEc3lNT05BL0xKbW5ocFcyWE0yaFBtdUNx?=
 =?utf-8?B?QUlpdjJvS21jKzVjbzZOY0dEUXlEcC9tb1dITnhCZUZlRzJ2bkRIQVQ1ZGRS?=
 =?utf-8?B?WHNqdnl4WnBhZktjTUdwYzE4RFEyK2RVNHR4Z1dwYlVCdkI3Q2VheUtlZEVX?=
 =?utf-8?B?NWhaV0xCVE96bTNQaW84M0ZOanZwaG9QcDI4Z1NZYW9ZQlBIWG0wbWNiY3N2?=
 =?utf-8?B?dlFGR2ZNcFFiMjI4LzNwRjVEZS81eWhoNUgra0MrczdXOWk2bm5EbHJyRGRH?=
 =?utf-8?B?eG5wK2NrT1ZEczF1emNuMEV6NGo4dmJCbDlWdHJJUlpwQkR2NzBIeGZPdGE0?=
 =?utf-8?B?eW9WaURIcC9ISlA5b3o5UE1xUHJoenFjd1hqNDRXcWVsdHFtc1dFK2tGTjR2?=
 =?utf-8?B?dUQxU0l1RDE2MTd5Z1J0MlNjc3d5dnJxY0F0eTdmQUF3QXZTdUVUUWVnaE1O?=
 =?utf-8?B?eWhMaitsRk1ZTVVhWHA0YlJEMHAwSTR1dWdrcHlmeGMvOHQ4dXlOZ2lrNVkv?=
 =?utf-8?B?UXVpNit3RHNHcHVqSTFSQlBxd1RIS2JZNVNsMGVzSHBlTytLYmMwSDNEcS9u?=
 =?utf-8?B?TXI2UVFXN1BOUldIYVE2YTgxUWl1TW9UbFV6eGhEQStzdmJxR3NtbWZQM2xW?=
 =?utf-8?B?OEN3WWtDT3VUVjdVaVByVWx1a3pPdDJxSmh3QkNvKzN2OWd6ZGVtNWNYcG1K?=
 =?utf-8?B?ZjNGQm0rcldTS2Y5L2pyMmUzQ25Ea2NGREFTdnVIWWdNVFZ4VnhLZXEzcmh4?=
 =?utf-8?B?WGRxN2RRUmVRR2RoTW9EcGhQOVY5UXowbFlnMUVDTW1jMXA1M1B1ZWlWRXk2?=
 =?utf-8?B?eDNHaUNrRDRQSWJ0K3pPWW9BbUJsd2U3Qnc5UkZhbittd1dpeERGanNxdGtq?=
 =?utf-8?B?TnRTTUIvVkNYdHVIZU1mSGh2eVora3hrOXlQTEh2NHpTTEFBYldVNHUwRlpC?=
 =?utf-8?B?Z2pkNnFGOGY3ZURwSDcwRDA2MVJwdGVHTjNGRnZldVBzUFIxRUZSY01RMmd2?=
 =?utf-8?B?c1RIL2hKd05mUjNQS3JYWUo4NGZjT0E2eVN3MFpFMlR6R2cyNXovd2h2WW9u?=
 =?utf-8?B?ZjdieiswN0FXbmNyM2xwbVpoaVNPRGRhRFROVFZKNkQyaEVQS0FFNEg4Qm9F?=
 =?utf-8?B?dkE4aTYybDRHTjdRK0NKNDBjQ1BuTFhLN1djTzlZWFBsMWVCdWpyeDV3SU8w?=
 =?utf-8?B?MmFRekZTZ3I5WE9JUFc4by9TRzE4VGRGUEIxTzFNbnJjeDJLdEdvWXVPcWRX?=
 =?utf-8?B?THFYZ1FCSEhFWThHWmQ1cGdJYmlWdTM4ZEx2K21pRUtLY2VXUkxJTE1UT3dC?=
 =?utf-8?B?Q3FHVFFCd2lNamU5ZjYvQlU4cUNVU2FPdnQvSHBKYVRwb0QwRTRBMVVEV2Rk?=
 =?utf-8?Q?jqw2dr?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 18:03:29.8309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fefc5c0b-fad5-46f5-1497-08ddea4b05fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4035

On Tue, 02 Sep 2025 15:21:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.298 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.298-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.298-rc1-g79c1b3cebd7a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
