Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743162D600
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185640; cv=fail; b=iCCcQjtk44DEY9tfsDXQolGvIe/roGG2/oLxEcycS6R2ujJxJMzv8vnZvnjCWLGvFgLvyCdeyVmbnomDCZp7Tb69WGKBT8PUPykvrvSrZZoZHr6/BsxfS+mQ4BYa4zU/S+KjEB1eHJgBkZFXqXSxvIaHVvqPivz8e4SKUKi8D9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185640; c=relaxed/simple;
	bh=9gSKIKjUbUM7LoyMg/RtpJhGNlQ5hMKwBO46YGGsZbg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=im6ZTCp9ktVhSSr8QGnmZI3Scd8n05e6+djjNquNI3pW4da/b3GRLnb+40NVDDW4tU+mhvqRi46JvFENCu8BEEtgzJj8x9ahzrFAx9IsvgEUWI/ESsZ2SQ7z0FBptlwXynHcRri06uJxMXd/EGMLt2GpLII9Iut37oA+J89Wo6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kbZrX6xO; arc=fail smtp.client-ip=40.107.102.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kbZrX6xO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IvIz1sFmdrW2tqvDultqW9wRih4R9+MXUZFPo/J8IkxOaDpishvsghHQkICPg9cVLXAFnP4xbGM55c1Fcxt/w82L/AmKNeNkwwpj1NPmpLH9e75yLTXOT94rMu0OQGCRGZSeGcpcwZN/dtDozNyyG6g1//iq9WvbiIqFCHw1U+z3ffDwGjbrHmd69efPvdhtNlY+z9Wv0Lrncw1dxtMr/0hkBtc12gxJ+CiNJaWbelECVQOx6HvQFkF4drflaxKNFM4VMOGo5yohO6X8Reok7rFCWNeLg4Yp+sHIVj6pQWN9wqaNDUUwulcuLNQsGIOClFu+dCNVIXFAhvKgcpGXeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3WLBOYzAOW4CAvDKQYIqLJeYawrqlsVblwOY/UaTFI=;
 b=M/OCjTQoa4+lJB/GkZIB1w6PiD8dyABLoB5hyHJ4HeCKqZN4JRrmkLVLRoFXkrgEzY/yleRUOERs6jjPPn6HuNYnwf0ir1/UEvWDzyfuINfE5GpzoU93r0BmiAc8B+vOoln4dT9gp6mzK1KMzNFUw1Cmwdozd77cahqwDMtFAqP4nTNiUX0Tb9+EbDeZbNFeAdDJ2umIRUqWTxsPcqmpDgNLT96Rr94wi315l71K1QjKnhUoP0GmMQz60U5buQ/wB3EuqJC2LaLnIxvAIGR9sdTDtlO4p4vPnomN0AQJGL7KC9fUDrPglYhw1Ge7gKbiixbVd8Es0Z8VGuARRoZr1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3WLBOYzAOW4CAvDKQYIqLJeYawrqlsVblwOY/UaTFI=;
 b=kbZrX6xOc4yGjAr4vtzmAi9B6sDUODg+mveoVX3IqdJPBQH9dAO2tBEGUxcNt7VkgrfP5+ZgfH4V7BQKyfTvOhNOBWSfwzML1zvqc0rEf+9gqjj/BmP/x5u3ezQ/Zp2cIgdKMqVA/5vaKJG5xtK9x8AEmmQWT34ariO+oD+e21N4gmLXAy8QHsppJYQG/awwnTZLfx+EOzoCuaZ0lR2j8W+GLhrLjtmf+1l9TzLRwX1yFt2fU55me+q+0CZgd9ecmqu9Y5/eMOPvdnucNhWsZo+b1Eb+rbjcp4PsmbYofOC13CeB7I1nrmX3/+9kXMOayU2HQMtemXAM8OYD9gN6wg==
Received: from PH7P223CA0023.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::21)
 by CYXPR12MB9425.namprd12.prod.outlook.com (2603:10b6:930:dc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Wed, 9 Apr
 2025 08:00:35 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:510:338:cafe::2f) by PH7P223CA0023.outlook.office365.com
 (2603:10b6:510:338::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.34 via Frontend Transport; Wed,
 9 Apr 2025 08:00:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Wed, 9 Apr 2025 08:00:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Apr 2025
 01:00:13 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 01:00:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Apr 2025 01:00:13 -0700
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
Subject: Re: [PATCH 5.4 000/154] 5.4.292-rc1 review
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c4c2e3ac-cf38-4888-b1ed-3686d7a08bd8@drhqmail201.nvidia.com>
Date: Wed, 9 Apr 2025 01:00:13 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|CYXPR12MB9425:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b5ff47-5b4c-483f-5ca4-08dd773c9b80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVMvcVY5MlBjZVVkeDg5T3F3UEJZalFtZUpUMmdjUmFrSjhHbGkwWmhQY2py?=
 =?utf-8?B?Uy9TUzlBS0FzYTVrTGs5Zm9zNUw4NDl3OEU0R01ncXM5L2hOTGJKeGZqM2hr?=
 =?utf-8?B?YUNqRFJkWVcxc2hSSFh4Vzh0UGdSR21kSlpZVDRJWnFTaGozd2NZZFhzVTZq?=
 =?utf-8?B?VHVrQW5OOENiTDNudjZUZERPMW1VckNnSmRyVmZrRXVpWm00azVPcEk2anh1?=
 =?utf-8?B?ckRHU2pnajVsMDM5eXdhNkVlUVBMR3VHUTBqWnMvOFpvK1ExSW0vZG4xR1VO?=
 =?utf-8?B?SGU3ZkZ0Y2lWcUNuWXBDbTJzTWpsWUhxUXY0TFc0WlkyWklQR3pqRG9MTUZq?=
 =?utf-8?B?YXlwTzdBaFhrVnp5WjcwWDJ1bGV2SUtDTS81anJCb0pqN1BOWE1sSTRoNjNZ?=
 =?utf-8?B?YkxFaFBYM1FORXVNV0VrQjJwWVd6ejJ4Tk93b0hkZ1VuUGZiYVQzU2J1NEUy?=
 =?utf-8?B?QzRaWXZSaVBlc2V5NjFkbnpTZUFnUnRrbHVkMGtRWUhQZXlRMHVJUmVWMmZ3?=
 =?utf-8?B?TCtsTHgveHRkdGs4bEdKM3MrdDgyalJac1VzSHpKKzE2WHBQNjRINHRFLzhW?=
 =?utf-8?B?NUY4M0ZXc3BCeXJNV3JKTzlDekdJQ29qbzFrYXk5RUd0a2pHcmE3Wmtrekht?=
 =?utf-8?B?VEh4YWNwS3dTRFh4QWhGdnByRi9PczUvVXRHZ2l1blQ3aVF2R3dPOEtFYkF0?=
 =?utf-8?B?Q0laQUl6TjBXTW91QUtHcGxWYnhHRis2M3pHV2FLRUhNZU04cEVBS3Bzd1Ra?=
 =?utf-8?B?Rk96SVN0UVlZZ0xZUThIUk13Z240VE1xS3RmSU0yZ2V5MGlubTVXZ2tLMlI1?=
 =?utf-8?B?NmxLODQ5enVlY0k0UDV0WkpQR0pSUHE3eGJZRDZrbnhTb0FhV05Zc1VhWlRt?=
 =?utf-8?B?UG5OM1d1VlpCZVZybjJndjhHSm9zWjNYWlJQSlA2SXpSVnFueU96Q0twUXRN?=
 =?utf-8?B?cElGMXZNanpINVY5STJWZ1I0Um5yd0RiTGlMc3hGbVJwcU1sTUlOck9rUy9F?=
 =?utf-8?B?M0UvcmhHd3Y3S00xUk5yRHlNMkc4bkE4bUIyUm52cjVNTjM3bE1VU0szT3Fv?=
 =?utf-8?B?ckZGTnpZNnRoc0kwMmNtOE5NeFE1V2U0SGhDZk9uRWltT0ltZ1pocUJPZ2Ns?=
 =?utf-8?B?dzVpSjBtdkxIajhsV0NnQ1pvK1ZaS0dVcHF0bjV3WmhtNkNFZGxMSEx3UVNn?=
 =?utf-8?B?QXI5TlNXNDlhT0ZqZkFpTzMzWTRuRkEvM2xtR2FGY3BETWVZOGFEVG5iNkdw?=
 =?utf-8?B?VDE4WTdhQ3ZIQmJYeGNFSXBVTlVUaS9pNEhyVnpPaGQvNkd6TjNTS1BQaElQ?=
 =?utf-8?B?aGFGYzZRQnRiZGs3alcrTzN6NVNEdzVUVGlVdlppSzYzNmRndWlScHBLY21Y?=
 =?utf-8?B?THJYaHcvdkFLQmMxYzNycXYzWStjOFgyUVJjaWFMRDV1T2NSemZzWStJbCt3?=
 =?utf-8?B?bEs1Um1zcTVCR0pWMjgzWFpaN3d6ckVrSVdGM2NYZDRiNVNudStXcm1OWUVH?=
 =?utf-8?B?ckQzd21tMjdOaGJmbE1xY1REQzV2T3FGVE5yek9vZjdPaEJCdUY4TDc4UWdv?=
 =?utf-8?B?MWRNSzdjNEVvdFdsMjZKUVQ4QTg0b2g2V3d0Z3g0TFRWVkFUbXpZalBsNnhH?=
 =?utf-8?B?ZjBVeSsrRzBCYUpiVTl3ZWkzZEdjbVdtY2RnY1N6ek1UZTBEbGFiQ2NkMjE2?=
 =?utf-8?B?amtIdmxzVWw1OTVwSVRja0xCbW11ZWU1YXZoK29NOGIzY2NDRXdBcnJxcWE5?=
 =?utf-8?B?emJIUXFxbzBYMGhBTzZNQXY0aU90Sm9LbC9QWHZmUUtYME1UN0llbDRoUWc0?=
 =?utf-8?B?Y01Tb3lOMllHU29GQkU1Vk5rMnRCbkh5bkd1SjlUUjY3TmgyWkl5aFR3aExG?=
 =?utf-8?B?c3grYkRQa2dRYVJWK0pWRmo4eDFyU0lOMGovU1BrbWM0azFtVFZxYWRMUGc1?=
 =?utf-8?B?YTEyTjBOTUVVVHZ6cndORjhJbDBWQkxlT2pYREtoeFU0OFdBejNJQTF4SDAw?=
 =?utf-8?B?WFU3VTJaMUlzWFZjN0dqQUF3VnNnM1lOajZTQVh2S1RzWEQ0T2RrRzBwKzFl?=
 =?utf-8?B?U3NqUi9KQ0VaWXZqOTlZek00dERQeVRkUlVXUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:00:34.6164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b5ff47-5b4c-483f-5ca4-08dd773c9b80
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9425

On Tue, 08 Apr 2025 12:49:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.292 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.292-rc1.gz
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

Linux version:	5.4.292-rc1-g7a5af469195f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
