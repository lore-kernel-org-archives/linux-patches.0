Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC4E299A86
	for <patches@lists.linux.dev>; Mon, 12 May 2025 20:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747083423; cv=fail; b=JRDaljYtj/NYbX2RSXMS6HpZ+/TThsJo8sJepQgTnSmoB5eLPjAE+MUGswFdwUZMHWrR1rzEGm5eS1H4h+nQpVi5ZJlJUgzml3ZdhosgEqgdzzN2ACbOoBXMGEswJCZ1NfVLsDFis+yYA5MU46va0ovDpxWSdBNsXSCrf+N/5AU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747083423; c=relaxed/simple;
	bh=Z1pD4uY7QA+ZR6L140Rj6AapNR4iEzDUgQHG6ugHl7I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LU9hrgKJp/GhXETgPZ8mPD6uwMfcGf0vAG5KMkPuIH/yD3evBWlExyf1cKwi6+UTMwCxEPm11s5f18WLi/ET16APfQWYVnnW2yqfkCP6bBf+Swy5zBbakGHADk+buLoYc+nHVCOGf6NaBySEmcCNmBOyIfWC/MWZI+E287RWZBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AQat28Ih; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AQat28Ih"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JE2KRJ+Ym1vjmp3TB6W63dZvdHcPZNUTm8BBfuZePBmo9qfi5QRfYkIB7Cd+sIZPsrxuMZTn5OPCsQrvkJIfmpxbVlRqsIhltXaSfpFYiKE7eVHozFKHlcDP7HhsFmY6B7khycRHixuFD49SIAYGadj17XExnIl4wql1PahF30HIacyItPjI2Ij5dXaIt8SCKsM6vLByoRIof3oI0izTJME74M0LzftPrX3eD16J+5aAr3RWEIftB1/DlyyL6VNH1OzEQA85SCp/+4RtbYpcUt4QCheKoSFWI73OLNys1rWlnh744G4KJehs28rSB9uCKfJ+G4Eg+O5NOoHy1ITjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuLHTVfJQmJ5F65wGRlZeuNA9gbnBfTxIUU+vGASnjk=;
 b=T1lLAtY2bdlVAVv8FBm6BygLWUu6wj2sYkjZSzAavfedKXa0i9JFkrt0b97ABUyFeMJ5iiUxS1H9GaQlgJRbcrUuaZdite+1fWlSoO296IJ0hCCNYQ+8TEK6UbxF+8rRaZe4DmxMrD+egt6RanrpdOzbdeRv0cwFy9jp4YjWWJ4XKgzxGxq/bMDHzMsHB5/UNGx8uSzGWhEtiif1igdjitXz0eSl6z/t4lXuw6blRxD3OLEKyCBLeKNgUmw1DFLquqqYh3F2ENqp4nklsLvtFNGzvCPduZ6hxfJiyt4MRSGaPLUlF14G53LcpXHwxlk+ccofMO89LuxuruTi+bsrJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuLHTVfJQmJ5F65wGRlZeuNA9gbnBfTxIUU+vGASnjk=;
 b=AQat28IhmpDcBDqirQH54mGReQ9/z++LUc+hspoDz2uq2RFlkS2ZwIow8j+4jT3TRBweSTuWfiHFg5Gtan2DHZWc+6ejFrW9lWVjTSlgcLol1raqpwReFSWPacRl121vx6480NWApBmdXXn6Nq/n00YjPcC5sAeAMlwbnYydauTFHUP0iEpRtKE87v6r1Ai0pF2MlZUE+44CL9ssYMAcCXLki8rirBQb798OLtvM+yyL+5vEfKb1O+8+W4CjK+8holY5kYpwOva8OJeTiEOR1kDuoRpgAsWQ08D+p32osSeD3/6FWX9vAsOCT9k3SoMcnISGxqiRQCgzetH7+tUvAw==
Received: from SN6PR16CA0056.namprd16.prod.outlook.com (2603:10b6:805:ca::33)
 by DS0PR12MB9727.namprd12.prod.outlook.com (2603:10b6:8:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.25; Mon, 12 May
 2025 20:56:56 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:805:ca:cafe::2) by SN6PR16CA0056.outlook.office365.com
 (2603:10b6:805:ca::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.23 via Frontend Transport; Mon,
 12 May 2025 20:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Mon, 12 May 2025 20:56:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 12 May
 2025 13:56:41 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 12 May
 2025 13:56:41 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 12 May 2025 13:56:40 -0700
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
Subject: Re: [PATCH 6.1 00/92] 6.1.139-rc1 review
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <076cefd5-aafd-485c-8d25-a2e61e79f6ce@rnnvmail201.nvidia.com>
Date: Mon, 12 May 2025 13:56:40 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|DS0PR12MB9727:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f3e10f-4fa7-487e-fd50-08dd919787e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eW1jcVdaTUdQcHY1c1cwa2s5UVFwcHZSc2pvOFB2elpFUGpRWjkxa3JQYXVQ?=
 =?utf-8?B?TzlYNkc0ZzlBT0h1bUNIR0NwaXhQdjkzMUhoQmh4YXdkZmZLNUlscGZhc1J1?=
 =?utf-8?B?Uk1nT0luUUM2WkYrUGg0c2dYMjdEMHNBVVlhQnZDWm4zVDF5aHc2QmpDYW84?=
 =?utf-8?B?QmZNQ3hGb3I2VWRiVFhpTHdkS2oySklUUkdiSitDUnpYWEsyaFcxaVZDcTBG?=
 =?utf-8?B?WWtKajlWL0hPc1BObkk5aDZwM2YrZGtVdU0zZmxXcmg3QktqL0FUcjIrWWYy?=
 =?utf-8?B?eG1xT1lRTWFXOCtZaFJTZk5LOEhNaXBYS1NsNjdLdW1ibm0vOUc4V21HRHR3?=
 =?utf-8?B?QVJYS1FJa1V5VUc4RjJnc1NsSXVDK01CRzMwaGZEMWlXL21kVGVLNW9aWGhL?=
 =?utf-8?B?ZEhFdFZIK0lwdVVMNHcvOGFjWExzbTVVRUFZZjZaZFdlWGE5NFl3a0pzemZK?=
 =?utf-8?B?U2dtdktqRXRzbVI3NnlWckVRMlF2NWZsSHl2UUN4ZU9xQmRMSHlMM1IvdUt0?=
 =?utf-8?B?cDJ2WVFiRE5WWGpmQWF4WE11bExzNUVuWGNTNERzaFJYUmQ1Zi9ES2YycDY1?=
 =?utf-8?B?dVdLajNpWDF1RGxUVzFsK3Z0QTRYUFhObUhKaURqQjlBVm84bUdZYnRHcW9y?=
 =?utf-8?B?VHFSNStOSXgvQ1JnY25WbmllU3p3b3ZyOUFNdG1GSFdCNDJDTUN6QmlZZnJN?=
 =?utf-8?B?ek14WkwvV3o5MjVwd21SWEpyQmk2UG4vS3VLQmNpRnhyL3JVR1BQRmhkajI0?=
 =?utf-8?B?K2RScHg1UGVJcXJXSDVSRDdFYUIyc04vVktzRkt0R3gyVmlMRUNBVGpzdXBy?=
 =?utf-8?B?V0NLY045UmxmTFVsRGFJd3I5UC9LUkc4RzcxVG5FdVZsWXNsYVMxVmhWY2hu?=
 =?utf-8?B?ZlBuV0lXVjhLKzNIM0k4WVhNcUljcFozdktiYVpKYzRHMVpXeVVHNHgrSWJF?=
 =?utf-8?B?b0hkRFp2OFYvckNrekNLMUkrZlhjTkFaaDFTYnRYdVhrOVpFUmFVa3V5Vm56?=
 =?utf-8?B?dkF3a1ZsVFdjcVBiRTRzMXE0NitYajNiZ09NMmpjUWVOQUM3ZmZYNzNneVRK?=
 =?utf-8?B?WEcyZDl5SStGVlgxTGZiY1VMTWQ3K0tJRU13S29sdDZiWGNPajZPb0oyWXhJ?=
 =?utf-8?B?djVjdXJWOTdDYk1LV1hkWTIyMTVYMjF6RUM1Um1uaDIzSC9veFBpUStnc0hr?=
 =?utf-8?B?eFdITzJEZk1QamhRdHV1dE8rdGJTT1B6aFh5UldhZWtrYkJ0clcyYm4wZGs1?=
 =?utf-8?B?RHM2dW5BYURjTWJkaGdScERjeG9ORnIwRHBtOVo0ajlzdzBjQlNOMlRTSXhr?=
 =?utf-8?B?ai9lNmthVmxYWCtVUUNrdjc2SkNIZEFXUWNwOXJ5NE1TemxWRWdCcUQ3L0Zo?=
 =?utf-8?B?Q0FwK3FTUU92SnY4SU1VQWNNdXVKNTVOUlg1U2JIdGVwbExwRzlpUS9ZQTN2?=
 =?utf-8?B?cFBKQzd0YUs5UXpUVVFYWlpIb2tiMFUvZVI3bHdvYVdHNG9QMUtFYWgrb3E5?=
 =?utf-8?B?RkQ3SlZGZEJWRTJXMHg5Y1ozYldNeERyVFRVSHFuRU8zdUNlWjVPK1BaNVVJ?=
 =?utf-8?B?WXBtWGE2TklPK1JWSlhOczkrVmJxMVJqMzIwNXZvdHRWTUJoME8vZ2tUaEFs?=
 =?utf-8?B?Ujl0UnhUeDd3NUgzcGNHTktLUWpsbDBXcU8wRmZ5Y0RodTBta1JCd3hjaTBn?=
 =?utf-8?B?bEo2cVViRUhPeVkwbmFiZEJWc1VlMUFPSVRtMnMvWFYweDd1T3JQZStRcm1E?=
 =?utf-8?B?WTJNNlhER25kMmtxTFk5RUlpTmZNNFQ2VnEyczRaOHB6VlZQbk1IajN0eksx?=
 =?utf-8?B?cFZrcFQvVWU2RjNDU290MHFKczBZOURSR1J2OUllRTFNV1gyeHI5SzBreG43?=
 =?utf-8?B?dVBQa3d6UUV0bHVSSzA3YWhLajRMRHAyOXRqNlpia0YzR1NNTjl4d3BrNkRn?=
 =?utf-8?B?R0JValZuRWxxMFZ4aUlHZzBSMkJrNzh6TGV0c1Z5ZFJNcVZZZUhCdjNyMjBo?=
 =?utf-8?B?M1VTQy90dFQwaTlVbFVjd2FEUkpETVJKc1JqV2FubDVTK2loTzYwSWxNdGFv?=
 =?utf-8?B?RHZTTlpidHhDVTV2NXlLVlFCbVAxbm1FNHpYUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 20:56:56.1463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f3e10f-4fa7-487e-fd50-08dd919787e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9727

On Mon, 12 May 2025 19:44:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.139-rc1.gz
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
    28 boots:	28 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.139-rc1-g490c91e6621e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
