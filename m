Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35826283FCF
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771010486; cv=fail; b=nXFFl/Ah0UQ4vAZRf+k0EEqG8vO0yGGgFvUPg3SGDzu71hsVXKGoQXYWqQVAYmw82/L7Tva/hHSspuybxRT1NKtTBdlmegJ3x2CYXXg7d3YuIVcc78gyXnWgArktJFCfWoNgtfh9NEFwz3UEyFPdZdt94jXte5L/3uV9mEp6COE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771010486; c=relaxed/simple;
	bh=jU5KLdfoMlD9GT54lbMNhmF8dR6HDorABeEd2Nn5FTs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PgOAyDe3lyNLKv83K7d2HqkCnNHhZ9SZuUd/LyPi5b3HUF2PSo8klWhLnBkQMUrRZ7jvnqiVvjj81KWeV9j7ehZvL23d8lTNA0TBx4PJLs2z84TagtzCOQ8vMOFumBE3AuA4E1GFCxQ/d2RE935SIZ43nBnrxzdhrL5WAfKTlBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GjD6i05R; arc=fail smtp.client-ip=40.93.194.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GjD6i05R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7iwe6izG3Ph/fKTznM/++i3wW0A1ZGFF9/PG/pYGvsTCDBDklk1cBrdzbuXc0X/YkvCexCp5SvC5XvYNMV1p97WaMWO6xej0ExPiI5qtEK3sEzUekngOVHrdrdy+m85csKOsfrnsHVnZFrKhSKvAUV4bzcV/TjJ1XjYklJ6XfO8Ym71dRXuFb9lv0tjmRDI9UtSULIR/6tv59Ysz+enB6mQ1pX/ulDKcCU5plLvdFvgbqZrEowLI4s0g6p/ZJjdkotvCO94hnYcEAg0X5j8I/bb8PbNOJXGWDQtKKh+wMeJxkTI/3Qn+LNyQJpZxbBrPHlbYy7tje6n2oTWMhA6dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8uPyYtccInClmTtVJwjyDyn7hlBxCjpDjwfuSmOV2k=;
 b=XVhp6B59MgAUNCjCeERvkbA96pwsbX4GegkcUAbk9Fo7PU1NVZ0sAP79LaEGInFVmGr+ROwLmMjPLzvafhna9h/iRoZy/kRRqxhBHqB/mO+hxjvpkexnIsSpwIHaLDgERswFRuD9Q7niZmskUQ9uA80zstzZrw6R9QIId6+xPyCmEYKH6Phovk5eqomLieVdvQcWwhOJaQgZWbfcsqmKLXMDSeYbSappoXtEW4dS41eS2Jd/jHfLzi7YZdkzBPBAtOUI/h7LkKmqgpQEGKkw2kjPEPCCzvhfxyDB5EzFRcgzfVSF5RDdw5BXBjplXtgQUbOS6gVWC4GRdH9kR753HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8uPyYtccInClmTtVJwjyDyn7hlBxCjpDjwfuSmOV2k=;
 b=GjD6i05R23CHU81bc8FmsboWkRPWMXUg8xMLQ1beZnZngkGT5+oTMrlKvmYri8cRGGzFTpe2w8714zSf5+9/Kukyq8FIwVdOf5+QCkGxdlTfck+/1Ijb1Kx32vBKEVRPnVtPkdA7DyR0qxs59gKK2NEvELMwTKDBGQIWFfS6yAZkde1XCPYN3rti4u7pSd+XDNQAB3y+bHDcSO9jQ+nzbsSfhaE2yXec8mBzEIVCjun5kToiQgweRdXxYoL9tBsKqActTIc30b/i4GA9RUzOpvSdgc0QXnDmY+LJPlkAPDLDWWsg6i4f6I5mDCCcynpduL1UQoUA8dTHorCsOBzTqw==
Received: from DM6PR13CA0030.namprd13.prod.outlook.com (2603:10b6:5:bc::43) by
 LV8PR12MB9082.namprd12.prod.outlook.com (2603:10b6:408:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 19:21:13 +0000
Received: from DS1PEPF00017097.namprd05.prod.outlook.com
 (2603:10b6:5:bc:cafe::95) by DM6PR13CA0030.outlook.office365.com
 (2603:10b6:5:bc::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Fri,
 13 Feb 2026 19:21:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF00017097.mail.protection.outlook.com (10.167.18.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Fri, 13 Feb 2026 19:21:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 11:20:47 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 11:20:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Feb 2026 11:20:46 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 00/25] 6.6.125-rc1 review
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1c090536-fe56-4eb4-b4d8-e5922ff601b3@rnnvmail205.nvidia.com>
Date: Fri, 13 Feb 2026 11:20:46 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017097:EE_|LV8PR12MB9082:EE_
X-MS-Office365-Filtering-Correlation-Id: d4c096fe-7c4c-423e-3c96-08de6b350d61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SCtBazI2WG95dVJNVEY0bHluSm5Gb3MweHMwejVZNUkyd1RKS1RITWpJV29M?=
 =?utf-8?B?VDIzbmtPK2JxK2pPOElEREEvN3pTbW92ZFdXUStBNFdDVGZQNFZGeEZRT2cr?=
 =?utf-8?B?WjFYaUNyaSs4RWk1Q2FUQVROSGVMZkp0L3Q4Q3ZMNEh6WnIwMlk1cjhQMFBN?=
 =?utf-8?B?MjVtdCtXaWhIWHplUktmeUk0bG8zYmwwZFd2bjlOcCttdXBpRXBPNHhjejUx?=
 =?utf-8?B?RW5Tb0F3QUcwQzMwakhqd2lKWlJvVTJ5UDNOU3pOdXBUblNVaG92WGFCaG1Q?=
 =?utf-8?B?U01WeDlURUZxMy9kVExJcVNtaHo0ZXYxekJXOHZZL0ZndCthMGJiOXlScFh5?=
 =?utf-8?B?dWhQUnVPN01JeitweW5xd3kveG9OaERPSC9qTUZxMjhEaUdWV0hvdG9XTHVi?=
 =?utf-8?B?QmEzTDZVN3ZqYnNqVzdrU2U4ZVhrVExpT21WakFXelkzTWIyR0VVeE9lTnZy?=
 =?utf-8?B?WlpNUWJUaC9GalY4ZGN3WHk1U2hwVmt4bk52bWZ2dUZaT1J3VzZVcW9meHIv?=
 =?utf-8?B?dWdQbm5ZVmZ1RXhVRXYyc2JQR2Y3ZlJKbXZPVWR3RnlnMWJ1YmpoQk84TDR6?=
 =?utf-8?B?cDl1U3lnZjZDTTFBVkRmd1NBUFVEU1oyYnhuRncwTVpZSWgvc2xaOVo5ZWZl?=
 =?utf-8?B?T00wbU5PMGhHdlVLQmY0dGtrdU16TE1tQXA2UnhxbUhUQmw4TWNsRkRUQ3Zw?=
 =?utf-8?B?RVo2WHg2U1h5R1gzZExIOS9WSTJBQVRYQm5VbEJiTTIvRmE5dW42MkhBMG9U?=
 =?utf-8?B?czdxMnJXNGIwREp5MU1OMzdhT2FOeXhjdEhINnJZMWV1RThkU2dJTVJUaEo1?=
 =?utf-8?B?OS9qemlyVEd1MnhDeS9EYVcvT2g3ZG9vNkQ1eWtwTWIxQy83Z3pMMjZadk9B?=
 =?utf-8?B?eUJsdFZ4ZGFuRHJzVzEwL0FsV2tHSHV1Q2lVRG5DaVI1bDUyT1lXeEdnMlZR?=
 =?utf-8?B?NVNUOUtSczZ0WGhhZmc2UHNJMzJ1K0JxMmMralB5M3pMbnNDbkx0QzJqT2Jx?=
 =?utf-8?B?KzlyOHgzWG13VGZlQVNid1pUcDUwZlQzQlFBYVRwWHFEb2RhNE14ZG83Y2Nr?=
 =?utf-8?B?TzQvenRVdmo2MHRqU1lzdmhxTkZRbkpTUWlldFF5R0pWc0JqQUJyOHpZNkI3?=
 =?utf-8?B?cFBsYm5QS3Rtdk15eEwwaHBaZVpIYXpsanN1T2llL1U2b3ZKS2xMZ1hBUVBW?=
 =?utf-8?B?ZmlqUTVmc2RXWS93Wi9SNXorNkhoV3dBcHVVamdDdEpIbHlmRzFuL0Y3eElo?=
 =?utf-8?B?SHZ6am1WbEFzL1g5UzdkZnBRQXhBSGs4bm5OT05WYTZUN2xJMEVCUFBITm5S?=
 =?utf-8?B?NGJ5WXdyd1NSaDJJNS9ONlVEcUVpc3h2eHdGY2N1OUVrcnlQNzNlczdzTWdz?=
 =?utf-8?B?bmVHZzFFTFlVZVliVnEvNjB0VTgwcmlidWhmem9mUGRvVUZmbXRRa2lBKzY4?=
 =?utf-8?B?T1hUci9jWHNPUDBLcXhISGl2N1IxREo4SVFHVllYek1vN1VUYXFsenB6Njhy?=
 =?utf-8?B?Z3BKK1VKWk9PR0hiVjhWaEJJQUM0ZldONGx2aC8vNWVIa3V4UzdncDBSN3di?=
 =?utf-8?B?TS9Xa2JuWDJVWTZxM3BPSGwxbFN3R3BhV1o0UlN6VDJSVWtHY091eVB6TE1S?=
 =?utf-8?B?cjFST3poM29ZM05MTVVNbXZUZlhWMjdKR3VJQTFINm9Ca1lMUTZDbmRXT3lI?=
 =?utf-8?B?M3VXTUpSZXQzQW4wQUlXOW1NdkpHWFJ6Z0ZvbVlxcHFnUjVoR0xOWTAya2sz?=
 =?utf-8?B?dXp5cDZ3b2llVmxMeTczYnNaY3gzaGNhTytlTjdzMmgxa1hldklPNVNvUXpk?=
 =?utf-8?B?M0JpM1NFMWtLZzMyV2VPZFUwVDcyVlB5dFA1dHJ5TFZvWDVYZnZUMmprSzky?=
 =?utf-8?B?WmpVYmduc2lTTVJVWW9zbnNQWGxsUE91ODdWdFJiaFNEWjZKY2liQU12Wlkz?=
 =?utf-8?B?K0pRd2tMYTdCb0xFWU4zMHFWekMzU0QyZnlQM3ppZ29HZEY0cDRDTHBKbmRr?=
 =?utf-8?B?d1BiUS9VR1d2eHVKR1UrWjFTMjNHR2taRUcvZTg4Ry9aZUtRZjlzMDFIbTNl?=
 =?utf-8?B?UFNGWDFaQVRBQUppVEN4ZGhNMmZsU0YwRDJhaGQvcDN1K3NHeHMrYjdXdnp5?=
 =?utf-8?B?c1NPazI4blZudlJrZytwRGtrTGR5YjlDS3BrRjVMeDkxdjV6TUVhd29renRT?=
 =?utf-8?B?Y01ndDRtb0N4VHI1aUpxdEE3Wis4TGlDbndMdllZM3VldkF5NUlRdEc1bnVR?=
 =?utf-8?B?cC80WlBIcDY5dER3UUF5Ui96NTZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yxT8FSPuJC8AimPmqi+GOSfO9ZKwea+6qwtiM4CUVDf8Hc08hO8VJYthtjlyAMthQ2P1x5/Ul+TZj6kaPA+CO8YU87VFRbHE0kI90hBzTSd/Ah7rVWZQ7ksw21/NbUCEjbCWrLuvMswvVhj+2ViPbqXLZC/52ZwC5FgOvPQZoxyeuZhez4sOk4vYrZ/igxRiiIcUpIS9wpKQ2VQqF+Eeim8nXmvgGa639TgW+gpatVi1FLtHLlBOjqDRw/zAFNiJD+8t6x8nua9LHZIiRQ9lZsXUnuTZ8Uf+DaCjgFSiI8hBr4P8gNglTnBuaRkaUqClLlKMrvAwamZiJXA6bUqmCxRGIARNzd8eov/bzMLUaC2E8N6cqrLlxQppP1cO8kdeXvWBJZT4Ii3wffApio6+880AeQbn42gRxXmcM27wCR1pnfCu5zHmDdqidZnM04P9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 19:21:13.3661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c096fe-7c4c-423e-3c96-08de6b350d61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017097.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9082

On Fri, 13 Feb 2026 14:48:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.125 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.125-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.6.125-rc1-g171da0ae441e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
