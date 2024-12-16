Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FEC203D77
	for <patches@lists.linux.dev>; Mon, 16 Dec 2024 11:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734349426; cv=fail; b=IBkod3Vj5mKIcIYwUqK/38BIPqBBqv/C9GJjq71JIqkU2HIHifutqJcFczeOQaalNlEi6/VsfHulJQPEExjIhRnz6egpgPwzRugywp8Dgt+4Cg2zyqmBMJy+kNDxYY4cB4JKcCVaFJxMg/qTiR5Q8gKUcF11of8AnDM2IhBE5G8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734349426; c=relaxed/simple;
	bh=TflrNTmd1SALRlpC5zbUAXWdiGJrrunK5AzYWN4lW7I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PTSj2o5R59oLId7SFV+24qZkOPGuxrQPWdbxBDI883x6LKUg+4baFsBOKX9chO50VKoXkIVQLGu63zYy4e9Bvxm3IN+n9EFqf6kVAn9jKI+G4qYTYRwoAoH278N9yzEbWtsUZAcX/VJNzY5/7fqu9YihApzqbUPfr2svwnpKk94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=moh4lp8Y; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="moh4lp8Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KOBMM3pBMpFrwMrDAOFbD/+gz+eaVwIZEw6chTzcYwhUQbE485nU2qS+5jXXiDREbZB6x5oS/K7IpVDRJfbw86QXqWAauiXbNfm49vrAaNS//p3fhHJ9o2IbTDPJ/3DH93fW4vIqYKtutqaje1QDj7HxRYlYXid5K1yVmB40Y98tiPiRFW8CdNkrOoEHHsP6iySFqOsHn7GYLgf99i3aa+2kSPCf2Tri7uS4pyB9DPHfdhc3FkuXXmufvPqG778NlMBVC/FSShWitkdMWN3q9grWefmZ/TvW3ig/HKvqGhmS977eQCGh4qjIiMajRe+FXYz+Mn2Ro18oIoK0YdguzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9RBbGB6nh3+BHU4D87ZyfIb21nN4y9mz/daBZpyDMA=;
 b=rPqCXAgFguK73QtxwV/OxXD81TWDFds82VeGQxkgdmYqPpqyyjxJSeUi4onh4zQ0dxUNWFD7r0/mCELLhExrHc56ubuC5NDhnMPfU1puDWijGBg6kfzQWL/HTVSBbOSBZUsSB83OSPvRQ6QKa3qcBxl4rdqNMDaLSUPH/koG3GzWSJiHrpLm0eQZrhW0femtt1xwkeIsSk19JnHL1sEqoiXEzIr12HTU5nF2Jn+H9fW16qusAJysHaa3x6V/RcwfS77ccYaHKWe1udb45GCbUkWfLrMSPFABkivCAg5F4C6DE0khICFBusOgW4jnS6U4LVCc6MLFQZI12LltEA3uyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9RBbGB6nh3+BHU4D87ZyfIb21nN4y9mz/daBZpyDMA=;
 b=moh4lp8Y5ZgZLVQZEy7dm5UASSpgDYSX8ufvT2dZ2ZlQ7RSY9pIxLiXolbvmsjRYQ8+CUD7bnIPOcV58LoEPFey6ROsnyWmX9tKBvHYJJzGdJnOPzBwqQyQOAn1a0QqixgzSmUWm1tvdkkoKbRjKolqjezc+eykMffUzdiWV7pMLUZRLhGvaiomLpIYTpaN8iLCRvKhBloE9N0WZyJhiuyg9kdamSmhRZC7AaZiYlkqOO7ph9zdEYwVT+Hatl6BTLakYYpINIS2Z1gtawqzZW0mpMlJTik3dq/2W0yeNHy8G6j+sKVOTv/Ah0Xv8w6k5fZtjz9aTPRObo5d2LjBcPQ==
Received: from CH2PR18CA0016.namprd18.prod.outlook.com (2603:10b6:610:4f::26)
 by DS0PR12MB9273.namprd12.prod.outlook.com (2603:10b6:8:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.17; Mon, 16 Dec
 2024 11:43:40 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:4f:cafe::53) by CH2PR18CA0016.outlook.office365.com
 (2603:10b6:610:4f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.20 via Frontend Transport; Mon,
 16 Dec 2024 11:43:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 11:43:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 16 Dec
 2024 03:43:40 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 16 Dec 2024 03:43:39 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 16 Dec 2024 03:43:39 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc2 review
In-Reply-To: <20241213150009.122200534@linuxfoundation.org>
References: <20241213150009.122200534@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <66cb808c-bb6d-4c7e-a1f5-5a9b0a185870@drhqmail202.nvidia.com>
Date: Mon, 16 Dec 2024 03:43:39 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|DS0PR12MB9273:EE_
X-MS-Office365-Filtering-Correlation-Id: 953520ea-baca-4479-5817-08dd1dc6e31f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmJzcnFXOTR0WFRsMnA4ZjFIc3hZaGFTV3ltNTBVNXBibmVtUGhGMnNqNzE1?=
 =?utf-8?B?bzBTZzJ2TUdqRW5lWHk4NzBOcUMrcVAyd2RydHJPbzJqVVFzVDRUdjJzZEN4?=
 =?utf-8?B?cDVIMk1RTm51YjhoMnF1ejUwU0tqbjNpWWhPZ0VEaytqV0JjZEJvcmxqdFVK?=
 =?utf-8?B?QzBRRlRCVEdvMWpUcHdHUWpXdkZQYlZ6empQd3ROc3Nvd2diUTgyT0xvaFFw?=
 =?utf-8?B?b0wybWNJSzFXUTVRdno3a1ZHMHFQR0RpSDd2ZkdXMGZPVUtxQjRYeHJhb1Vq?=
 =?utf-8?B?alFTclFSY2h1MlE0ME52SlVKdTFELy9nTWE0RHJpZlJNYjZhdktxOUhUb2F0?=
 =?utf-8?B?ek11UGUwL0hITWw3bkdISXl0R1ZvU1BCbFN1QmI3YlBVQWxrTHNRdVdhMHhK?=
 =?utf-8?B?KzkvaUZ3K1pVV1YzYTJ5VHZHc3ZjNWxLQ1hWeDF6N0xqSWk3SzFzS01jeFZY?=
 =?utf-8?B?aGREOHFFS0RmZUV0YTNOSmJGb0ZxbnZHY3dNV09hQVNZaU9DcTFDVGJTdjV2?=
 =?utf-8?B?SlMvMWtGdmxOREM2UGk5MVV4d2pqZG9vR01HOUt0MlZobS84YTRWUkIwOXhp?=
 =?utf-8?B?OTNtMGFaYU14RVYxNUt4Wk9SQ1dJelMydGVZa0JxcWZkeUVCaE8zcURmaG93?=
 =?utf-8?B?S2JhcGlDNy9BQ2xQNlcvNUw4dWY5QXBVdWlmK1VrZ2Z0UmM4aXY1cXI5MW5N?=
 =?utf-8?B?YmVaWW05cHJQakZseXVubmxIVDhFVmp0WlA1K3JkNExyU29GMVFvNnNPeVRi?=
 =?utf-8?B?Zi9WSTZseXV2Vld2QjkwZmZvRWlKN3h1dmJLelpvRUhBRHhweXB3ZmxIaUVw?=
 =?utf-8?B?WFUwaVh1UjZ4bTJsNXlWZFovR0NBVy9EL1dkME1lZzRoL2xGT2hoU1lEYW50?=
 =?utf-8?B?WVRmczNHcnZWbUd5TTVKTG44L0s2UWJCY2wrRGRybTJsVkx1TTc3N2FDcmh3?=
 =?utf-8?B?MjdpL0hKTS9yRnpKWFlTWXVLdzFKTzJyajUxM2dkSUY5bkNOblNveHVsd0tu?=
 =?utf-8?B?SlZjb1R0eU9hOCttYmVzUkdVcXNnbHFPMDJhcjlwdGlRT2lXZHAyTzlOQzdt?=
 =?utf-8?B?VUNubHJmcGgzZCtUTkZ0TXp3QXlSV0pKR0RyNXhnWTFVZEFEbzF6UmZTZ05w?=
 =?utf-8?B?N29yMlRIQmQ4UzlxUjV3Z2lpRjl4SFBiekV6ZWc0ZEN4RlhBbVkzbVhibkhE?=
 =?utf-8?B?TFNaS1RuaVR4S0xxd0VkTGNzUnR5SllvSnFhNkxpaS9tYk1mOEZiYXhHM2F3?=
 =?utf-8?B?bjd1YWxZR25leWxSYmp0cmJENDJrNXU1S3NpTkFuQ2VzNDV1T0k0RmViMEJU?=
 =?utf-8?B?YVJHeU1nZ2RCejhXR0IzVTZXWEwraVdaNUtjbUVCbmVhaEpvQnF4M0JidVRm?=
 =?utf-8?B?dHQ3MXJGM3VRd3RHWHl6RmMvTlJSVFFBQ3BvQjE4NXk2akRNSmNLNWMwNVFF?=
 =?utf-8?B?S050Q1AzY3A1WE4zSmpnd2J1aUhsOFRaZUtsajMrNXh6Sjh4UHNBeGlYc0Vj?=
 =?utf-8?B?U3JneFFySWdZNE9IQUxhWWgybmdIaUdnZW11VDV1ZTJQTDhSOUtMS0FWbWU3?=
 =?utf-8?B?SUJubmpCN1dObzI5cmpZOUUzRzF6dDRXTzAxcEpoWmpsaUNLWk9lQysvc3pB?=
 =?utf-8?B?M1k1NXhCNjhHYVR3a1ZUby9KREpOdS9XQW1uWDdXdk9ld1dzMWlvbEpjL2M3?=
 =?utf-8?B?SkFKK25RRCt5TloraGV1b1BRU3FHU2w3dzFmUGZ3eEVqcFEya2JFR3ZqZVNq?=
 =?utf-8?B?UGdwWkZ2R1lISVdJejEyKzE1MDAzQUxLb3VGU3FBWC93R2M4MVlORDBMRk0r?=
 =?utf-8?B?Zjdud2lTdTh1amNQelFmSDBadmg4UFlsRVlrbTZuamxVeWM2bmZZd1l4M3Qv?=
 =?utf-8?B?ZXVXbUw0a1NzQ1ExS0I3RFB2N0xJQVUwcnRNZXFQbDR0S2VsUkZMRGFOM0tz?=
 =?utf-8?B?YVJBYWRkc1VZQ0NMUC9DQktHeko2MVdPenVFRDI4OU1wajJKK1BnREg5QVpY?=
 =?utf-8?Q?0MYFs77nwUmhZtch2cqBMKRBAZk7l8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 11:43:40.6440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 953520ea-baca-4479-5817-08dd1dc6e31f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9273

On Fri, 13 Dec 2024 16:04:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.120-rc2-gcb4fbe91b7b2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
