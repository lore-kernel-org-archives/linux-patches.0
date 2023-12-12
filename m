Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EB6660E5
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZHCfHQNv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvPqFOkc98lbwy49nPsPgxfuNfoitENeDeNkZT7zVCPH1VGoy+99UtgYTgdW4zJr2lZLyRhffYLzm3THTVDSK5G8/V7JeDuiz9+vaol0w1df4n1okXQxYrFntB5f5MlkD4Waq7arZxml8EwbMLVanYglB2p00y0e9gedehSsp4LrYhl7xmyix2eN3AjnAA1ApFEmePY2mZkeiGSettWV9o2bHBKAmceyC/T66uJ5UFtb6gtjZt/xW55I8d9arfIC7GUoXwA+xgKsN5zWIgPl4LRb+BRyK6RoxJIh42HGVWB+l6Hdki4RhxxDJMqUqdIo5/VFoT8a2mVtl7s0UY9p2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itq9JKmL7NfPyd3rFHrbrPUUSRTPkA65LgGoA9EsmYk=;
 b=MyOYMhByU+9SXSly4QfcpPjWctr7GTPerBUqEBvw6vlAigIzFfUVQBYHV5UAZMzLN8kZwtFzHWs0BMx5+NoJtd5jPSu5cmiq9c/iNfXuArD3+GCQM0SQBltR0YhPD7g9FBlnp8kIu7fWGAvUTcxr8xY4ogly1HbcZX+kAgnjqCne6WgvDBP7riFVD7PfO8TN8dd3imsz87U9U4zPfxr6wq0nJAcs8XKInCkQxwK+HQ3QVVJpvaf+nfaewbq+UmDaD37SnlDL76qW13tqS3IFT9O/bK/uguddytDvwsm8hrzt6iCnTALxsDRSGNVQ9ZhkW64OTHRGyWcnu7zcgmdAzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itq9JKmL7NfPyd3rFHrbrPUUSRTPkA65LgGoA9EsmYk=;
 b=ZHCfHQNvmuyX3CSbqR0Ri4kYhjkw3S93N5DYqbFYgemZAKNy6aRBW7imfOkC9hNW8hq4ycCLjvjVmyJEN7gghFijx9MKs0OOYlaGQMqvRtIya3NPs2+5BcsE5ugPlFSfxxZH7ce6aa1kDScNjU9MfEgpF8btR099OaTj0J1U04WaPdR39kiHVychBbmya/DHOwP5plYo+oyhFE62ZJ/jX/En+7e+mhZwqgRGrz1bqNMVhqX9gxH7ON3cZ4A1RxhfKQFa0bMZm0mTzYtBGzvnQawJlELDydByNmwS/XlsGNakr9q8Hx2jelkx0UbZysDYM/mFfUTgMaCQrvyt0HfAfQ==
Received: from BL1P223CA0029.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::34)
 by SJ1PR12MB6074.namprd12.prod.outlook.com (2603:10b6:a03:45f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Tue, 12 Dec
 2023 22:19:32 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:2c4:cafe::18) by BL1P223CA0029.outlook.office365.com
 (2603:10b6:208:2c4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Tue, 12 Dec 2023 22:19:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Tue, 12 Dec 2023 22:19:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 12 Dec
 2023 14:19:20 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 12 Dec 2023 14:19:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 12 Dec 2023 14:19:20 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/67] 5.4.264-rc1 review
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bb74e203-f6fd-49c3-b506-451918f4bb77@drhqmail201.nvidia.com>
Date: Tue, 12 Dec 2023 14:19:20 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|SJ1PR12MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 422dfa84-0342-4018-c293-08dbfb606a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c7UWDxXidlMngEeg5L6NTQpNOLh4RMPA9DdIvOF4/Mf8+lHwwzJ1entf2FjbN+Rx67BIoHd2qoSsKwErcnAW6g3kkKDZFLTUC+kuU7joHpqAk8lh/GVL5riMUxZxHYK7PEYQGGCXOs2qYAWjAEAUeTpG2UcVbEgPPJBFldF5q431PRRORsZpOBSntoye9oct2FUlhbYc03+nzjN7xLz7X2Aoyn97ytvLkdybXQJKficUXyGcRNSH+VynmDl7SPvh0X5bfeCtgjMe8k6kwcuJkJYF1aoETHiKrQycHRIwgzwi5un+b2JabzXWDI9uebzA/yAiwWrk8PdNOrM8rMMKDuAikOp4m7SKh6OOkZZTnhdf2JiHaKeujAg4yvEwA8Kf+ng662DOHP/HXHi8WM1X1DAb8xUSWB4mUDQf2dYPND4DetwT9ECPS81MlsbbKttW/XABfCnbI1l5NRM0crqUCPmXM+qKAL9LS81UV61jN2zfU9n/1H/vy6ISZqxIRLTwnIt3TkKA49SCx4z8Ge1Ge7VDUnTUWMUWUFA4dJTgZQrzkNEYhMjA+Gv8Q+4K2vw461s6Rzv2mHiThZk1i+kXIorI5SGqt8szWlqSqy7W5OqXhoGt83e+a6GNDgQyQ95u3aoGyej5SMfQWDiJhzZVhPiJSge3+VsmeRPI0aTuBE+u8fdGEv5saw/SF7bagEMOxvuzH3gAkI1bEQKGmlkgyuxFLnd1mFLNVSOs9IZ58SHvWV5pHztP6+OKwdg5scaDYRuuqDYXVwnlcc7On68tV6AP5WSEvG0Vv501LbBDJwE=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(136003)(346002)(230922051799003)(1800799012)(82310400011)(186009)(451199024)(64100799003)(46966006)(40470700004)(36840700001)(7636003)(47076005)(336012)(966005)(26005)(478600001)(36860700001)(41300700001)(7416002)(5660300002)(54906003)(2906002)(6916009)(426003)(70206006)(8936002)(8676002)(316002)(4326008)(70586007)(86362001)(356005)(82740400003)(31696002)(31686004)(40480700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 22:19:31.7998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 422dfa84-0342-4018-c293-08dbfb606a2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6074

On Mon, 11 Dec 2023 19:21:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.264 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.264-rc1.gz
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

Linux version:	5.4.264-rc1-g852f04d98505
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
