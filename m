Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB907346A12
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 18:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836311; cv=fail; b=oDA61qM3einySytbrQPtQQHAqh7O9w+g+gRwGK/WX2onoESuuReMGkkiriUo9tbRetqNF4toUTpzkZfFJ8sPX8vw+OUdMxVsdY4yY2OB935qf5IB3NutOV6fFSRueqQdenc9dK3FW9/cjtjpZmPzN/KMWDKYsi12WoIvubdPugI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836311; c=relaxed/simple;
	bh=2xSnENQfpdwA9roTNR6fM7CGp+0B8/0D1gzBbdSBzGs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=eZ8u2HqvdLJuDslHYqJ8pXEoV8ggRpJTW6p3r+4q3F4Svs32ZkyiKzBKQchCmJAOtDu9PTWFPuyll3E2Vbjd5Yh5PIOBtJbeKZtT8bMDOhr5y9wNIVLIcYvGP2mNVcEZkzWvJHss2y8S5cnaa1dtrdZhb5ReadJAL/eLWPmVwV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p+PJPM+u; arc=fail smtp.client-ip=40.107.100.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p+PJPM+u"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HBoRhfTp7S0MctjJzN0cIRDIXIEhR07YqUYgJRbURJ09FWFioqo6drxO5gsdkQC2dZFJZw7OnRl+RdoNENdF3kb3yEJZKyB9YW1A5LxrV2+h9leAQq6ncAH8WiYwseQlZ1rTHPBWvBMevtWLrcd4+JNvxRR42PS+22lecjdxu63BaNqY+EL9ZmgjnxSXldDGKDK163RG0RDo+1emwhgRqdF0o7wcghASHP+C1Do86wKremMlDt+/7ARTBfFuG5HsZDCsTrsnaUhGD6dxrhxBRuWYtnGTUjlGd1F3SkQUgTKzZaGKGiXz6DjM47JufxxHcfdu0RbFLCB6kv59o/QjTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPOCRKB37fvFSzuOHETHjhH2hncFSxsEYlT5VNy0HtI=;
 b=SNs1z4nwnqJt7w4QqrUKQ5CHRGHyQdbb71E/TVF0+mSBcVdWL9ycL+/0EyeZPwWuWEMUx5GS0VD4+6y16fj1v70fU8JQ8lvZjVuAJr3XIDJ5yKVr91U9G2XLp+FDUoBPAe0SzV3SZZAJlJ8+7epG7VUNKqyOhBathvyrKf1G98MzAswTFtKNiy0Bgu5uyFYV3jkOyCWEglA7tQ2ObgX/TNpYogKbt9Z0ubMgP7Hbix89khdxiXrbpdEV16rRsVrLPxk472h1uoFA4HLTGGSYKLKtN1UczkWRWSN3mZaECb+r5YvtapTjiji/dusjDD4Fm0tNoZdMv2OEyDrgp7T0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPOCRKB37fvFSzuOHETHjhH2hncFSxsEYlT5VNy0HtI=;
 b=p+PJPM+uFMoSWmJkasOcicvdltduBWmVTWSQtbAM1uGjw+CWflsr8j9jcJteLkDKNML+/A+XMnZa316WlNwnHMq3Z3BUMcP804WjPdhgaG8QsnOMmcy4eVfUR5YKqdGjjtE5LytTPtBKKKe37F4SQ3zwxRvQskDGvjN224xyAarfHve3FlmGIQlQIl/miWtUFpD7KzJMZvKJgQ3afcF60EqPZskbJo9wvaNgTl50lesujQJbPbxywGMgF5UR7wWg8ZL5DIYj4PS/Ba+50GFKxV1nOxxYNryLy1i7RI0hVzI/R8eNZQHjyQubwLFuM8SEKSsmSIaKsYuydFH0seaYpA==
Received: from DS7PR03CA0086.namprd03.prod.outlook.com (2603:10b6:5:3bb::31)
 by SN7PR12MB7980.namprd12.prod.outlook.com (2603:10b6:806:341::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 18:05:04 +0000
Received: from DS2PEPF00003446.namprd04.prod.outlook.com
 (2603:10b6:5:3bb:cafe::ab) by DS7PR03CA0086.outlook.office365.com
 (2603:10b6:5:3bb::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Tue,
 2 Sep 2025 18:05:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003446.mail.protection.outlook.com (10.167.17.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 18:05:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:04:26 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:04:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 2 Sep 2025 11:04:26 -0700
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
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <40470a41-2c27-4ad9-a657-8c3f17b54024@rnnvmail205.nvidia.com>
Date: Tue, 2 Sep 2025 11:04:26 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003446:EE_|SN7PR12MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: f8e57ffd-c956-4bca-6b01-08ddea4b3e31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3R3eFVNNElFaDk1VWRZa3ZheXFCTS9FMEc3TkF0Qy96VmxUTjltRitkMFBI?=
 =?utf-8?B?T2xrZTlPQVVCa2cybExPaCtid1FOSnQwOS9CaThvVDErWmdvSUptY1BXc2V6?=
 =?utf-8?B?OUZta2hqdzI1MWhGWDRCVENyRWlWVGRHRFQvbGtVZ3cwOGhjdVluMnhQVFM5?=
 =?utf-8?B?UDBELzgwdkozVERENkNOK3BCS3hMVnl1Q21BRDJGZTg2UGh0QStRZXVMWk1D?=
 =?utf-8?B?VUxwVHlObDkwakc2aXJqbjhHYmdPSU5QREVSR0N4emFRV3dtdVlEbVVqTU1J?=
 =?utf-8?B?MmxiNHpLY2ZBTXAwbnZHVkJSRWk4OG52bm9sOU5kaDlZMUN0MnpEci94Nk84?=
 =?utf-8?B?Rkx6OGFQRUlqYnJvdmVvZlB5TkhUVVZYNFF3cnRHTk1qN3Q4elU2UlNHQVJa?=
 =?utf-8?B?R1JLVnNYSUhMVEZIODRjN0pjdVJ3MEYxV3dMWjlGakdhdHZ4UFgxY2VWZ2Mv?=
 =?utf-8?B?NDlvaTREeHVuR0c4QU5Ta3p0cG8rNGhPUk9QcXVPa2VwR2QxUnpaQ3pjK0p2?=
 =?utf-8?B?QnRxQ0hySWdIK25jWSsyVzNqMVd0d0lnaTQza09QZzhveXlaRFZGUDhBZnJo?=
 =?utf-8?B?UWV0ZHZWR01uT0F2YUREbmdvTGhQSjRhWG1WS1VzRlh6NFpFNExHTUE5NStM?=
 =?utf-8?B?d2o3OXBaV0tJNXBHMTNwVlMxeTBybzBobnNoTWNGZURteEc4NTNKQUw3Yld6?=
 =?utf-8?B?ZjBzay9BNCtSMFlaMWt5Tzg2WkxrVkprb3pOYzFXY0JJNUU0dmtjZldMRzho?=
 =?utf-8?B?ZmN2UlFEcVN5Sk1namt0YTNNQ2pFbU9aWWIzU0VBYkN3aEEyamw2SFg4WmRv?=
 =?utf-8?B?aXRndDhTY1plbGFiU292amdnMG9OVGhTRTZvc04zMWZjZ0hUZFM2alFPWHVI?=
 =?utf-8?B?S1dSUkhEKzJPSjBlczVXcmVhUjRGYVVLc2ZFdXFmOHUwL1FhdW9QdTYvWTg2?=
 =?utf-8?B?ck5NVUM4aDdVV1VzM3pDTTc3WS9FNFBGdWYrakcvdWVGVXY1Vm5XR1Y1aWgy?=
 =?utf-8?B?QzVQV0NrbEhiUFAzRVMrUDlmNm42NHY3emV6b2FRTzFRaDBRbGxqdUtwZ0Qr?=
 =?utf-8?B?VW8zVzhzaHVYSmwvbnNISit4R3Q1K0Q3YmtzdW13QnZNZHlOYmdBdW94cFVs?=
 =?utf-8?B?aUhpenVhWU5ITXVaN1gvQUVQMVZZc09qa2pCa20xRVpoQWF3cHVEaHh2ek9t?=
 =?utf-8?B?VExFMlFTdm1nSG13aXcxSk55RUJFSWVTV3cwRzdZSEdxUU1mSEpFd09GaFRt?=
 =?utf-8?B?STVsc0F0YytXSmVBZUtPVkE2TFNGdkM0Q2t5SEc2VkRaODFmaWxZTVJqdldy?=
 =?utf-8?B?WkRscWpRSVBkam0vdXFUZmhvMVR5a3JkbGpBQ0RNRXZTOFdXeVpUaWJSZmQw?=
 =?utf-8?B?NXNjL1kybkZGSnlHYVk0WDEyUTE4ejlPeFc1M1doOGZGZDF4eGVLWTVsVDU1?=
 =?utf-8?B?VEw2MXVDZ2xNaVpKVFdSUzhQMTBHYm9EcjZFTTJ0ZkY3Njl6MzBvcXVEaXBy?=
 =?utf-8?B?UlZRcTV1UE5OblBXSjlBRTgzMzdhbWdPNlVYN1FpQmhEUmRWYm0xNThzbmFi?=
 =?utf-8?B?YWlrT3BmVEwzcHBsRDk0M2hLZ3R2TXBzSDhjVUpUb3YyYlF6eWlyT1FhdGVm?=
 =?utf-8?B?dmVJSEgzTERPVUp5THhiQ01jTzVuM3RQdDZ4SS9Qb0pHVVN6YWRtYWNWSlcz?=
 =?utf-8?B?ZDFscnM5UVVCd1VKa2p4cFhJdk1PSWs2bVdHVzU2M200UDl4OGpxT0phVzZo?=
 =?utf-8?B?VGZYai9IQ0ZScEozUmNla2xnaTV0MFlwaEtkRTNMMUxkaXZiMVNRK1doMW1P?=
 =?utf-8?B?eEJRVTY3SGFLblRqQ2k3WWo2b0FHd2lTN1VzUmUrb1NuSEZ4aHVVMkd6NjVD?=
 =?utf-8?B?eU9TSHNGWHFHSDZLeHk1Z2FVZWtha0k5V1pTT0NsNy9pZ2F5bVlBQm1YRHZa?=
 =?utf-8?B?b3NpclIxZm5WcTM1K3NvT1F6OFV4cExENlY2MWJma3VrZGZNaWxCOHlHdlgx?=
 =?utf-8?B?Ylp1Nm91cWdraTVRL0hGWFVzbWx4OC91RllmckNUMkdMaEREY0V5cUo2VTJD?=
 =?utf-8?B?VmRQdDZ4Vm1pT09jVzN0S204QjY3YVdnZ1c1dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 18:05:04.0808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e57ffd-c956-4bca-6b01-08ddea4b3e31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003446.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7980

On Tue, 02 Sep 2025 15:18:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.5-rc1-g6a02da415966
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
