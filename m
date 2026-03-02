Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50913E0C65
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 13:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457254; cv=fail; b=sg0XysT3DHjK11lIslhl58EVzJjQNaUbZGfjRxdErTM16W8lLM7Uj6GUCBOeMfsNEbJPskHw2ViQwTZu6tTWiEzqKtmvtOpqBDW5HwmfsC65R+MJY//RYMIJMq5BtmY1bjSR3uQwajXb+orsmTSGTokhM1iFU9dSZCjiqMYhsfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457254; c=relaxed/simple;
	bh=2YL82RB6HnHV9l9Rtd/eWSRjeWh2kWoggNx+uTGI6sE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=MDtNoJCYfd0XgYYkFrH0AKGhOi5AphWccFKB83/wdEyAfAKEu/5JyNfOlL5ouuafi7EGt1lJe8kodQy6F+VWcO27uhXNqz2LZy0P1PehqYTRHpkJnADQQJkz9u1vXOHPdNyMwpx0mrGIxqTg1dmqKcrOBpKamGhrVnzd8V5oqQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IpIcvw0S; arc=fail smtp.client-ip=52.101.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IpIcvw0S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5yqHZxqAeELmKGsu8VGjhljG8bNtPgcKWVLgLF1GemiwQX1eh34Y6rQFh7mb7lywnRvw07AP0+NyBKHuEqbYyVv7/o8fINBtXGA1PHsBMeJxKAjGvsMrK51jSEOlOwTU2T2B5IL1FxbEfX0K+nITiSHFXnyQ9R6o7LH9UhpFe7hTRJ0HyWyqCB/+nrrAuGernCW9N6QCK4ISoxaRPrWwpnfCHlRIr9/1KpGZWNHtR8iRkK1H3SryusMxlBIpUCVgsbSL4fWpsWAsW68mIJGozobgatOii6KjRATK/F/fRV7uQ4IPv/A/bWPf6azZNI4Q+CDPNnnUt2p2Z8K0atLKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZylhCHE2BBpYXvJ4BMN8YHFmlUnxBo7lNXQmEsk40g=;
 b=X9goGtb5kGxN3nk08AggO+f7mmPQZFndyDES7s4WxHitmNTfzg12qQVAejzAcJk17QivvJp2V98MTbgxkYZc65jyrprHnGb7vh+Dby4rSLh9MD6MIQvW2bPg9NCUTGDHQ9QMpfYterVuTJ3PtXdUXjr3wJEWrFtMNH0X15OUq0MfNl7FLKN3X4AMv1Ronv1Sy1fkrVrMzpu3Yl7wEqHFvNOGe4D01R53BTawas1zJyZdIWN+wXxpDCatBxwWV/kUrjzl35O+Nxw/zA8pOh6S2A35yX16SuYUA36IWht4W3Ps+W1wxlwjXyeUHGnSU6agwJ55Btgj64ziehJBUvF2Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZylhCHE2BBpYXvJ4BMN8YHFmlUnxBo7lNXQmEsk40g=;
 b=IpIcvw0SlzY/4LZxqvOYU6Gid/haim++dt52VQCskf6XrCfgM/S3SW0yUw9OxLCHDBN2bTN2ldiUThphJ2ACl0YVpMarrWnAA77MavcSwaWCH0xRab4iSFAjfGB2o/M+IrB4Cem/BE0dC/gi5OzrueCB6nNozvdcfOYBKkMnz5VM6fb5jXUOGjFqVQIuOvPlcs1SBpHMvfDS3EeWmzySzFKVNv8GbZMWBHFMJW6fg40yRrCrYuxdGkYFan0+uU5zbzNXGP70anteB+qGZmZssxnwnDJtQpyCESy8jB+BQbvye9FbflrCrA3rrZ/08cRS2ms048g6kkziXJiOpbVC9g==
Received: from BN0PR04CA0062.namprd04.prod.outlook.com (2603:10b6:408:ea::7)
 by PH0PR12MB5646.namprd12.prod.outlook.com (2603:10b6:510:143::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Mon, 2 Mar
 2026 13:14:05 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:408:ea:cafe::91) by BN0PR04CA0062.outlook.office365.com
 (2603:10b6:408:ea::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 13:13:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 13:14:05 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:47 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 2 Mar 2026 05:13:46 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 2 Mar 2026 05:13:46 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
CC: Sasha Levin <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>
References: <20260228180001.1567994-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <eee325d1-3eea-418f-9069-df3d1de88693@drhqmail201.nvidia.com>
Date: Mon, 2 Mar 2026 05:13:46 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|PH0PR12MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ee64995-1a4c-4fb5-c2b0-08de785d948e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	pQK0whsTE+G3Rqfv1tsFCFkMmhMj2Tb5SGr2YExzeADOSghwb18IBg3ONFofHJXNf5JBPUT4HoDm8pcMSNRitzY07Z7G+7E6nRkBDr9d7wH4a5aneeXDwLgcgZFtjvBiFaTSYOhD21yxSDxtG72UiS0kLC5080Y0OwHV6iD55ZBXcL0Q4tsTdWxVnUJ8+i0itkekGp0yP0yu61ubtHV99GfHTr54yYIvjkHGTWKtgwHwpBQvsFYoWadm1b+YId/f/2CLo9pzb4rw/39ccP1J3W7RjZHg0886xVnr+LkpcbMvZ6jJlOcfDECpDpHjieTcSupav9yo0lpnUXORC4fz3RO/aEMZ50qi/ld7CDaGLsSBBcd3cIv3gApCaUfN2Xm2EuPT7hI5XXfzVz/Oa0ow1WxA0imwAX9NpWaeqhXMZNaf8UCYmhupZpbFT81J9zQc77muqHtN3O4OeJfq5WJF5vnzTxKQVKP+7U/HX1fhEjg1tz6sQ0bs1KE9f/mCNoC7zCRpxUtT1b10J+9GRSDS4CW6mf42f/fhowWKm6ft/86zPum+vqVWtznSIDh6QR50tXsZcDoOMcxhWmJ6dmRfq+IUiRnJ1OsFZ34i6Bx+WFiL9S7AX8qrhMbFGqrS+dUPniDXuJ0hHgqZJHmd7AiEJTAqd4gdhpz4hwEOM59uxvxGbj4iXR2pVEDxwR084Ar8VIj4P5LQmpAO7NzjrnnmyWkqKDTzcBOyzqV/Mry+0l6QpZXZNBKQtIQOI8Ef+PUmthyRjKu/GN5u1+RFnCLdi1EI8I6WLYTIVX8Zgb65kUeqpPpwK+WWwn++iH7ybqwAA7L36xHJfmNtbqIaqsnM1Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gNqn8BPCbqS5gBBvR5P1CdMuxmKHNyJw7pLzYbWVvNgf6/NdCxFvFm+lcRkyroS7PA9ayCcOwkqUhjAWCopwY5LvlWw5GGBuvvjUd2ZtH+MoBR1FDw9KosIdKzWeBpCeH0CyMncnNXEnnd4N8T9tqZZDPEDSkli8rMN6VpMm8Gj9sBlNnP3wymfdN7XIFTGHp04mGg1DgNv86QvkCxTANqIhZc+UZ9npaxMgZtC+8URqy8AvotQwApuRar3Ais52XLkb9WzMoBRpbgG+wW6lCGVwdSzmw9kcz4oxaklQDIgYMFPurWdIv7QBE6WE3nApD+rCRiPkS7wiBsLaZjdxNhWXbhjp+grBv6b9XrKT8wqH1zFGqYeyQXRbfp5XzMidyDha87dwMbMwuSe05QQVzG+FGtpGV+hVRFlaEMPKyeg45WuDcqNOMihnzvlxt9+a
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:14:05.0863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee64995-1a4c-4fb5-c2b0-08de785d948e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5646

On Sat, 28 Feb 2026 13:00:01 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.12.75-rc1-g37057c896e0b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
