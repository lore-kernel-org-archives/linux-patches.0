Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1785828DB7D
	for <patches@lists.linux.dev>; Tue, 13 May 2025 13:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747141645; cv=fail; b=lbigfUJ0ejgusMQofBkTsYqMOFsAdmw9mCgADZQWQPLkQlq4kNClHKdLkCGUJNZIjIPDxrXZpGkeAL7nFBqyqasveeWwQUD/Fl+slTKkkfXnJaZ5W3uzKLcSTwwgP1JzMVMj/8BvWd4wMFW6C3gb+4uhsxOljxgk9dR0TYgIGi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747141645; c=relaxed/simple;
	bh=alT5vg5s5ZYZLMITlNQ6liGCISJ/WYykexwjqAZabrQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QeY6VmthGVMN5d+sNtvO/fDDeuvYLy107AmjdSeVDkGB9sjAIRN6JKJg29/UuIWJcqRlRIZsM9ZTf5grOfPW3h0xMCn5iwmBKzviNoGAS5nklkFu9to+LGOelzbsyUa5Hc+wCLoGyt27s7ihky6yXkKktoJC7FQIIzQvzukS12o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rY/3vvAq; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rY/3vvAq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTl3NB+EnnSVTGgjYYi9eraFJXjgswrWkYWt1MsouTpjInc8l+k9BIM3a765b1lpJl88UQBNKouN+MRYF2oc7VurwhdtGRZ3enepVQdhdH14OC0ufxApmokBGr45ohhCk6iycUUZ/hfaCI7uok1vFCwUsAVRrlOVZxuC6MzhUgknR4Gy/4UeENGkxXSQlymTXFd1DP4tELl/6UZRzZegxjrJ/bulAxJ9vzG6c2uEJAJq/hh1nd6tjUnZmoWULQBFUH2d6zAeMrzIIvnDpMbHE2e7sXlEoZxLI+W1RiJ8cxBiyyZUilob87OZW+9SrB1Pgg4jzrGJJpYt3r/bPPbHig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JGMokEswvuRLMRkl1oyYuWqM0r17FwuenfGr/Wipk0=;
 b=psHyc4fRsQrG8DjcNlhshFlZflTJw6uki0aHsAJk1WQZ8BPI07QCbTaOs69qp9qd6agiJPdMeKwV8x6AeqxHqkVspKtSXnUMJDvbXcPkiW6HnOmOqdGLn6byFgjsC5UOXtyOFIU3S9oUsoRh0/zFFfn4hcHSIGmS7VRnx4//w2q8qTX2XC0zCrPdw7Db9kJ04dfE2GfX2YQiDm6Pt23j212MVfgylVcFKYyob0mjrWTTmbR6/+jM5OIbPTzZFKJ2TNVbUFKHv+g23no19ofIjdaacb/W7r7qWdfUFMYA8q5MItqLvnZ3zEz+heow05fedXXqdfK3K/rLKTc7EIwEkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JGMokEswvuRLMRkl1oyYuWqM0r17FwuenfGr/Wipk0=;
 b=rY/3vvAqJkRn/FktK8ZGm6wLWdFWLupF7aKLyx8Op/ugJNIQuKF6HFZYGjOhUeYnHnKPfYmxUlUd277rozAlk5oiSmrCtcaMRpgxJuX9URtd57JiwNzAs1ji0TFBy5kz1cEZ297N2pGjxX7oECrpsYwqc90Om5ff5Hx5/msowUE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by LV2PR12MB5917.namprd12.prod.outlook.com (2603:10b6:408:175::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Tue, 13 May
 2025 13:07:20 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 13:07:20 +0000
Message-ID: <968725b4-d12a-482b-9a03-b1f689eaf799@amd.com>
Date: Tue, 13 May 2025 08:07:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Christian Heusel <christian@heusel.eu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org,
 Alex Deucher <alexander.deucher@amd.com>, Ray Wu <ray.wu@amd.com>,
 Wayne Lin <Wayne.Lin@amd.com>
References: <20250512172044.326436266@linuxfoundation.org>
 <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0157.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::24) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|LV2PR12MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: def1bb6f-9131-41ee-3748-08dd921f181c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MjBnZk9GY09EU2VpQUduWUtlN2FPZWI4bS9qUzk1RUdBOUd3dnhUN3F3NStW?=
 =?utf-8?B?ZVNmYnBscjUyNE44SDc5UjhnSmFlMUlVYVZJejFsZWFIMUttdXZNMStYd2dL?=
 =?utf-8?B?Wm8rTzVJSUwyR1ZoNVlseUZXbW1JOUhMeEI1OXVRTDlRS3hJT3JabzVFTS95?=
 =?utf-8?B?bzlqOHlYSEIxYXgyL1QvYXVzQ0s0WkNLb3hZZG9zdlNWTlJyZlFHL2lMSW90?=
 =?utf-8?B?cUlZWjM0TzBydnA1NEZsdDJJb1hWUDBJQnd1T1hNY0VVYzJsL2w0cTlrZ2xB?=
 =?utf-8?B?WnpwSCtBblA4ajNaRWt1ZFFXQjE2QSsrTE1xNnVpTENMN1NFbXVSTStmaEpO?=
 =?utf-8?B?M0R6TjVURGp1S3pVTzZqM0wzYy80Qy9jUEdBWXZKWXBsb2dhcTY2RDJmYVcv?=
 =?utf-8?B?bXpMbjArbG93UW00Q3ZyQ2hPM1VzZVBKdEc4RHM2cm1kOHNITUhWTGo5LzAr?=
 =?utf-8?B?bWlzUFQrK3M1alJTRUNQYW1adktXS1R2R2FzbkVqcDB5aTlLNHREazZYTkVk?=
 =?utf-8?B?dmxKZUFvWkdrVTh6akJTRjBGRnJyb29Tc0QrVXhBb2ZreFl1SkVVNitiZmdo?=
 =?utf-8?B?S2haTTBoK2c4RXJjU2dwT0tNV0NHN291WWZ5ZVJZRk5HSjI3WXhONExJTDM5?=
 =?utf-8?B?UVVoZitaZWpORDFJRVJ0b0tOWWtkN3lWTGh6eTBwdSt3cHRBT0RLUGlNb0lj?=
 =?utf-8?B?SVpxQW9pSHNnQ3drUzBTSm50QXNTcUpBSkIwWFBrSzFNK0pNK3NsbFdlOFNR?=
 =?utf-8?B?RDhVOHBzWFBEV2xieWFKQXpLcGFSZnpmekd5RWo3MXgxRndUK0tlaHZKOGtl?=
 =?utf-8?B?blhBWWhacTJyS1Rjdnp3alV1WWxndnNOdjdoTUJGSE8rbVpSbkdmeEplTE0r?=
 =?utf-8?B?NGJmRVJHeW5qTUkyV1AxNXlxdHIyY1JQUUVnSTg2OGpXK1hrc2hkT3ltRDJu?=
 =?utf-8?B?dUtmK0ZCbklIVUlTVnJLamtaV3pyQldmS1JtZmwzTmQvV3VDUUdVZmJjc21o?=
 =?utf-8?B?VEdnVDQ0NVNBZUVBeEZOK1lXSE1mdGJwOVB6KzZWdWxJcFVJMmdVU1VrMjNx?=
 =?utf-8?B?SjE4WngxL20zczdtS21ENEZOYmd4bDFwV1RQZWcrc2FTM0RvTDZkV1p1aHFL?=
 =?utf-8?B?MHVJRGgvd2ZFVm1tZFN1V3A2OWhaNzBRSEYrRXdta1hUWXlUek1rTno1alpi?=
 =?utf-8?B?dkdrVS9uQnhZMWUreElsYXV0Wm1Yekt3ZFRtNUVWZHBkNW5UVGtleTV3SUk3?=
 =?utf-8?B?K0lBa2VkZVBGM0NXWEhOSTJlVEJFUzRLQWlkZS9kQUkyY0hkRGRMTUlLRWtV?=
 =?utf-8?B?TTRoaHFHWDFmTHpzVWVhN29UQnFWV3Q1RVgrK1BhYkY2ZTByTHFORVJNd0pm?=
 =?utf-8?B?dlZ3VzBYZnRpL3A5YVJmM1RydXhBTjNjcEgrcUtlMUtSOFdmSlAyZVJESkRo?=
 =?utf-8?B?cGZGTE5nbVo4Y1pUZEVJazJnamQySjd0SDZLNS9JenpRUDR2dGJXWEZuQThv?=
 =?utf-8?B?OVp1bWttZER5UUJMT0ZMN1VVMkZkblVpOGdTalE3cUpnSVlqME8vYnVkZks1?=
 =?utf-8?B?NnJZUDZybFMvRzd3ZFA5V01ONjdoNFF5RFUxY3BpcDBKaW1ETzR4ZHBsWjE3?=
 =?utf-8?B?RDZ3ZE50V3pjb3hFSENtZUd5cGpMVWpuRTF1WS9Fc3Roc0ZETDIvb3RjTnJF?=
 =?utf-8?B?cXNBWTM1diswVkpmS0JWeWYyaDhST08zeWJHSDBHZWZ3VXpwb3F2U3RvSEFz?=
 =?utf-8?B?RVZFeVVzN1NhbjRPK24yRm5jSHFTVDNEVXlNMlYvZ2FwTlZ4N3ZubmJDcFFL?=
 =?utf-8?B?cFBLUjlmbUFOVGcvdXk1TFR0ZHQzdklQYmR1QVBhTk82ZnV6SDRZOU53cU04?=
 =?utf-8?Q?zSst44FpjsLZd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cElkTnV4bW5uYm9NcVZNL28xbEtLTHV0M3l6bEdKQS9GSmJFZnJ6MWczTUVu?=
 =?utf-8?B?cVZnazhTVUtOZ2hxcVIwUEErNVZPTC9XZTdybmFKd0JTaFJxQ3RnenBhZE8x?=
 =?utf-8?B?SGpjMWlSOTk2ZTlCOGR6TVZFQ1RlWGZ1RW9uSlVUU3loSnkvck5EbU13Mlhi?=
 =?utf-8?B?MnV5aVlZSUtHNVlDWWl2a1FNY1JyTTlmMHhaOXNOdWIzNlRSRHVDaDFvNmFZ?=
 =?utf-8?B?QUdRUVdQOFg1TUttejNjZ1RzNmxjQnRzb2d1bUdYT3F0SVRObm8xcDkzYnpE?=
 =?utf-8?B?bGpONVV0MkgwT29wUWlZVldabjZsWGF6UDVoSnNsVHhrVXNPN0R6WUF1TXRP?=
 =?utf-8?B?VXFWQW1iTFE2ZTU3S0RsSEZJU003VlNYUHRSb3QwTkw1QjBiWXZZajZuMng2?=
 =?utf-8?B?eXNhSjgveG8zZkhXMlA1dDVBYUxhNGlqb1FBRGxCTGZOdjZSQUlURUgvWFQz?=
 =?utf-8?B?SVBsRkpHeWE4aklHdndDM040dlV0dHVUdTBmT2xVVytwZGl3QVh0eTVPeEE3?=
 =?utf-8?B?enlHSTArNmtHWnBSY1VHbjNvRzl5Q2JLWmdjbVgrdmVON2RLZUR1RG1BL0VW?=
 =?utf-8?B?dXo5dmNzUXRxWVJkNDlYS1M1WmlZbE1GQ0p0a3hrekdQVW0yUGhqeTcvZnUz?=
 =?utf-8?B?Sm91Wm15WU0rKzM4VVlPU0VkNWF2U2lyTnN2NVZ3N3dhaEM3aGJKdFRLeFBM?=
 =?utf-8?B?QVVSb3Qzd0dOczloek5Faml6bk9Fb1Q2Nk9jZzg1U2htVGdGR29BK2pBMm55?=
 =?utf-8?B?NFp5TzZobGhvckhrL3dZdFlkRzZJQk9ZaGFmQUtzK2Y0WkhTcXNaWUZmVmph?=
 =?utf-8?B?NTR6V0dVd1daQVRWdGdpM1cxdFAvNFQvZW5PRzAwR3VlcHZPOXFNUUEzQnJq?=
 =?utf-8?B?OVZVZVBISHBmSmp6Y2JndDJmeUJVQ1hUUUlhaTJ6RUdTcStSU3ZkanZGa09G?=
 =?utf-8?B?bllJNFM1MGpHRnFFRUJIbWtOeFU1RVk2cThBcEZ6RnpiM1FXVkp3bVRUUGVr?=
 =?utf-8?B?QTFGWW90bFRjY3JnUXhsa1lLNk1jeWU1YWFWL3l0a1Q1cm5MR1IvN1pwWHNx?=
 =?utf-8?B?QmpwTFhtVERBYWdpOXBxSFlLdmJQQXZUY3VCMzdhcmRBbmdyeWJhemQ5RzBi?=
 =?utf-8?B?UHlXOHlYSUx0ODdpQUhlK3ZBYXN3VWk0ZTVFekF4engycVAzand3V053VHBv?=
 =?utf-8?B?bUp3elBjNUg3MWRuRG9xNTl4LzBzRXYrZ2kyeW84SnBodnVVSWRlNVlaMHVr?=
 =?utf-8?B?MnBzOElvdXlQbzNLdDU3YXY0YjE2aUJCRGVGQlRNNGgzeXYwTmZuYTBPUUl0?=
 =?utf-8?B?R0N3WnB3QW1od1NCTE5uaTNzOVV1WGtDajB0RWxNRlhZTmlmZmN6RkczWXNn?=
 =?utf-8?B?MGlqTDZ2TmdVY2JLU2xtbDhoNWtQbVBsQ1N4NDZLTktRcnZ4ZVpUdHg0ZW5z?=
 =?utf-8?B?YjJVWldhM1JUTUdKa1I2Z0U3MG9Sdk9INy9DbGZqZXg4d21tRTNNTTBXMGE1?=
 =?utf-8?B?d1RMZ0swMWZDaWlQMXdVRFRaSEo4QmVhWUMwUHFvanVaT3lhRTdIc0tLVDM1?=
 =?utf-8?B?OGJiQ0ZJeE9hbFJweVdwV2JTMHpmWDlDUDhOSUNZWnRJMUpQVURvZHNvY2xJ?=
 =?utf-8?B?dmE0ak9lUnc3Uk9WM3VKSnZPREREUXR0L2JTcHEzcjdZb1ZjbktEYW9wdzJj?=
 =?utf-8?B?b1R2K0d1ODltNkpNYnNpVnZXelFUMzVRVXZYRjBROWdIaENSdC9VQitRaUxC?=
 =?utf-8?B?YlYvNklNQUJzeVRNNTFEYXR0VmNDRlJPRTRyZUY3VlhSRC9Fc3hPbS85bmwv?=
 =?utf-8?B?VUVOL2wwWDZzMUNaNDE2ZVVwdGtkdkQ4WVlHd0s0M1ZkMWJDY2ZLam9mUlJw?=
 =?utf-8?B?L3BIUGY1TFpCdlp1UjBiaHBBUmdmbFUxc1NUbXhQRzNEWnY1ZzNDNlM4elNW?=
 =?utf-8?B?eG1UYW8yT2FpMmU2TzF5UnhUdEJmSVhhenp4QUR1UGdKOWJpWHZvcHVBQ3BU?=
 =?utf-8?B?L0N1VjF3QXBxNmVRSTlZMVBKeFRlZW9kTDkvaE9udkE1YVhEdWU5QWx1dW43?=
 =?utf-8?B?V3hwZ28xVGNrcFluSmhGWng0VDRYc2NxQVZyQ0gyS2JWaFpuMWZKOUwybzZL?=
 =?utf-8?Q?P3Y8jZjaF8jtfjGvKL/ATADSq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def1bb6f-9131-41ee-3748-08dd921f181c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 13:07:20.5854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bO/vrrQGBVeudQ7PuqfAl/SeRDVW9qUzKEI+jkMnkeeJjyCyx1NA2sfx51GQLYQa0dZQXpNyBOe+s+XivUMJug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5917

On 5/12/2025 7:26 PM, Christian Heusel wrote:
> On 25/05/12 07:37PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.14.7 release.
>> There are 197 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
>> Anything received after that time might be too late.
> 
> Hello everyone,
> 
> I have noticed that the following commit produces a whole bunch of lines
> in my journal, which looks like an error for me:
> 
>> Wayne Lin <Wayne.Lin@amd.com>
>>      drm/amd/display: Fix wrong handling for AUX_DEFER case
> 
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> 
> this does not seem to be serious, i.e. the system otherwise works as
> intended but it's still noteworthy. Is there a dependency commit missing
> maybe? From the code it looks like it was meant to be this way 🤔
> 
> You can find a full journal here, with the logspammed parts in
> highlight:
> https://gist.github.com/christian-heusel/e8418bbdca097871489a31d79ed166d6#file-dmesg-log-L854-L981
> 
> Cheers,
> Chris

Here's the fix:

https://lore.kernel.org/amd-gfx/CADnq5_MrUPvFVTkMixCuhFqpEuk+cKQpXJPBBBpaVwqrTashMA@mail.gmail.com/T/#mf9e4e3b93b4b0815a3bce61a4f1f92dab08e4164

Thanks,
