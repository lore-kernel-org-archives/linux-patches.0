Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C48820D517
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 10:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745492146; cv=fail; b=oIRHhp0VghtdsyfYdqOqa6ntUsAIYPo6R1n1r0BxoNXqxOfxE8GdFtA4yikZPSF+xCrpVE7r+IbrSQ5SYrNSaicgq1F8oDVCYX1zXTXVgRQVA2ebsp9hxkCngDjCITw51BxkiDIL/viAKro1wEoSnFOAsAGlp4jV/GpR+YV0qZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745492146; c=relaxed/simple;
	bh=hxCfhUaJ+yEkASC33yQwaab0rvly/N+w1+f+LbM0lxY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UOvNsWEm8+GjjSh320QR9H8Y0F9+PjvX9igiyM1lEvIgHj6E1ORTrgkFhpL+4eMVhFCpAYZXP3fUJ8ngrz+FnnPvd5bajWN2RN8xPHvHTDpMjtJv2NdkpdF93gysse3gAd+uWRvZMx8O4P2bmeiaRrf4h5rRfqp8PGV4unoXv88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FdnympGG; arc=fail smtp.client-ip=40.107.220.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FdnympGG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRsRBMX4jvpPtrXLa4QDL1yN6xkWVc4zmInLK1qMvD1fl2ywNpTy5QE9fsqrTNwuHjxR9S3IOTX/u8WrWWPluDKd71x9Fd7mb70IKm1utU+M3fz+3dLlb7gRSNCa6PS5mdm8R0WhUuN6/vRRwADVWjgxccT2H1E3AEzb/xBKWA1STyF/stSDSYSkYfxAXW3ZdKfIPb3sQ4ZSDZc7md0WoiI8dApqz6aofFYY6E5LwFCqSJxQRAipzUEZKXsvaDHbgfmTfu4G62dCBSVd8lPYFiCN1tMli8yMoMumKyX2pBlwpaqvC2JEzNGAbpbJpU463LLCnxD4wCRABgDe0icsUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oObTCluQN+PQJ6lJhCeTQIr+VBP8Iew112FP+oudx1I=;
 b=MkxIyJJo/J7k1/PPysHlPcDmfXEOUsNo1QMHP67ydcK9vaLh5i67y5hmyGbwnS6d10U0LsRtieaREKu63+Q+aPjGvzeUABWIiuDUmFuXaj5S9w9Lo1cldKz8UWK1xMJ/ITPtso5Ctm7SOk1eCZod/ms3cqowl6q3hwKoVYEIXFD4yg8NNbjlP4qnEFGnjnO8FmYfnajUnP0V0ESyHanc7iltLf6TGR4fMdHhUAYUXtl/V4w8BqRs+iQ5PKlpUGAGMBfcYAyBKsP4DEhBqv7bKHwNem12YhbaLRrVxGJCJjfYlD7OtUBx93amYevlZfRrWR8dAsTTto/bxkXUXIPB+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oObTCluQN+PQJ6lJhCeTQIr+VBP8Iew112FP+oudx1I=;
 b=FdnympGGpPeWQbn3EzTZP3Sp8ga46BUsxWd0pupkmpGFGAYsFhnKG+s1oEWGL0NgaZU8Pwjr6Qg54TKQdO6YuBLEFbd7uwk+CCnPeq9aZdb/o+1W5nz0Iz2eAz1gye1JhCCbRwYYoz+eRtwwNHzHpBCebLnQwfJWSiwzAHqbjikiUzQx0iB3UAml6+2uWgEAM/pRTpuiAr1PCtLW06quRiSXsdDwN5RHtXAp600A9BzRWx17X//qOgo2i/fkQHvzKjBSgHfjp1ritgoIf9UABYLkOK2MdTadobMlP1dZMVejcN9Y7j6yN3vupGUkcVFBCEz+ywkLcBuspomqLoYkJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DS0PR12MB7925.namprd12.prod.outlook.com (2603:10b6:8:14b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.36; Thu, 24 Apr
 2025 10:55:41 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8655.033; Thu, 24 Apr 2025
 10:55:41 +0000
Message-ID: <abe31afd-acaa-4187-8d0b-f1f1b977b929@nvidia.com>
Date: Thu, 24 Apr 2025 11:55:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250423142620.525425242@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0318.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::17) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DS0PR12MB7925:EE_
X-MS-Office365-Filtering-Correlation-Id: 03161ef5-81a8-4a70-71bb-08dd831e8e13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXVwQlBYd2tpWkZtcGFLb2Y3RXhmcno1M1Z2YjNKaUpLempmcTJsbk85SDdE?=
 =?utf-8?B?R0g4aGpicHR3R1RnUlh5OEVNUmVXQk9XS1dPOWJXcHlmWHROQXFERnFHL0JF?=
 =?utf-8?B?anRqUGUzWWJrQyt0RWhBTTFDU3F0SUdyd3VVaTMyYWFxTElzYXVuWVJDZmMz?=
 =?utf-8?B?NUpnN1lhaHU4RmRTak1XcHdJdHc4YlNmeXJuZDhjL1poRHJhd1NEOEtSa25C?=
 =?utf-8?B?cmVtaDBnT2pnbUZmQ09Ga2VzZUpoaHdGYXRSdGQ5cjN6K3NaUjRiRzdSbzBq?=
 =?utf-8?B?SlU5c1FlWklvQkp0cC8xcVRkTHNtUUxOZXZ3amNPbEhXdGY4WVRrUGJIT1Vx?=
 =?utf-8?B?Vlh1a0hmUmlrVWk3M3B4T050UEQrQWJOTU5tTy9wQjRQZXBqRHhIMzdpd21s?=
 =?utf-8?B?cmR3SCtROEdqTkI4MFVYM1lRTXdCUzJHN0E0aXluNHJSSHJ2UEpLaUQzbm1C?=
 =?utf-8?B?MTZHVUlvQlNSNlVrUVJEblhrMTR1SXVpaUlDbzFQSUJISE5lOHRIaUdHZEVW?=
 =?utf-8?B?WlVYWG1TZ24veTh4andCY0o3c0Zyb1Q0d1cyQlpxc2t2eGx0VHlOYzVsWW1H?=
 =?utf-8?B?S3VWTUNub2NaSUxVRnZEQXBRbEZsZXdjeVZ6WldpTTZqaVJnQVVDeFJxMHRP?=
 =?utf-8?B?UTRQdklQc3NkS1U0ajE1TlVsbGZWOUl6bEd6VWY5bElHNzE3MytscURlQ0tL?=
 =?utf-8?B?ZXp1dFZhVnlQZGx1Q3JvNGtNajVvbnVyajBQSEpJaG1sQ2ZqN3l4VUU5VFVu?=
 =?utf-8?B?ZHBscVRUT3hZK2ZuUUN0T2VHSWV1aGJkWFI3VFhtakpiQ29kL0V2QUJPNnFH?=
 =?utf-8?B?b3E2TmE0SSszUUcwZCtqRGR5NTJtTVVGRWhrT2N2Q2tOTm5SNEhwTWpmdXhh?=
 =?utf-8?B?TDMzZ1lhMHFtRGhJZWI2NmprRUtmZWVZVjE2aDhMaExxK3FrNTI5cnc1VURm?=
 =?utf-8?B?WG1ZMG4rdEh6WUZkM3UxZzZJdGJ1ZUM2OVJ6aU5NL1JJZ3BMZ1V2THBNT05k?=
 =?utf-8?B?dm1LRDh6dkNPcDZwN3pKTnYrN1UySjZnVGhzRmRPQjdUMnZtdUh5RVFxaUV5?=
 =?utf-8?B?dnJJaHFZaVJnNW5BOEhnS1Q4YVJjOEgxci9yZ2pmV0oybzg2NXljVHF4NUw4?=
 =?utf-8?B?aGMvaStCa3RkbWpMMVRBTmRzNWZ3MjFhQkpHb2VkbnREUE4yK0szNlpaN0V3?=
 =?utf-8?B?VVMrWW1qdWQ1NzBQTEtsNTJvLzRFVnE4K21IOVdXWlFCM0RYdHFEUEx1WCsz?=
 =?utf-8?B?Vm1Ha3Q5ek1IQkhhMlZld2o4cWJ4RkkvV0VKcVZvdzBrN2k4TDJOcnVXNlBo?=
 =?utf-8?B?ZmQrMVRlb2JDejNJWStFSDR3TjRIc2VnZE9zYk1TVW9mSVJWZnJ2ZVFmUXUr?=
 =?utf-8?B?cDZkWTdmdWFjRUFHeEpBcjViejFtai95ZEQ5cjJ2NGhyakxnb2dUYytScVZY?=
 =?utf-8?B?VDBValRRRkQyZ1N6SkMxQlE1NE9wb01VaC9CNlJTcGt5eThtUFRIRDA3SGcy?=
 =?utf-8?B?VFhjRFdKbjJ2SlppME5CSmlmNEtTdWFvaytIRjRKOVBKRVNXS0gxczh4MWxp?=
 =?utf-8?B?WjRFck1CVm1Kd1hhOEZMTGRFeXk5WE1HV0pPWVh0TS9ZYk15Sm9ZTGVUYlEz?=
 =?utf-8?B?SjZDajVUcGtYSnp5cVAzYjJoQ0RPQ1hlbEE1Qlh0ZjhyRHplMk9EZng4dUVX?=
 =?utf-8?B?RzV2T1ptL2RSQml1MFVOMGN3aWdtaTE4K0lnS3FtajZWOGhBVElVU25rTzMv?=
 =?utf-8?B?eFBQbFQ2OVJzWEZLa2xmclZsa3A2ZnNLVUpPNTliYTQxOVkvM0JBaGRkOUFu?=
 =?utf-8?B?Zm9RVE8xQklmSjBsZDRmRHZDR2xUNXlKNGQ0ZVZZdWFTNUlWRjdEV0RpVThq?=
 =?utf-8?B?RHJBUjdxRmdZZTNvSDdZSlZRMDlBTUJLQTIzcmdkZkdOcWFjcnExaW0wKy9E?=
 =?utf-8?Q?dqCSlFeohks=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b01xRmlWeENXcDhKc1hSeDZoRnRSWlVvdG9iOThldTF5L0NYTVF2Y2dGMGFy?=
 =?utf-8?B?eXR4eUhMTFNZL0NDVWE0cUlkVU5vbC9raWVMZy9iYUxEZzRneWV3UysrUk1j?=
 =?utf-8?B?K0V4NXNWQ05rdmlUT29iWkZYaFNkczV0ckltRSttSkhpT0V1dHo5b2FGaTdV?=
 =?utf-8?B?R2p4R3Zid21RYmtTR3ZUeGI2d29rdDhuV212ejhmOGFkSDM3MGI3cnZhZ0tR?=
 =?utf-8?B?cHpTWXdMcGpPZmYyb0dldi9tYzZ1bGlHRCt4MVQ0UFl5dWZRaFA0U0F3Vzd6?=
 =?utf-8?B?SXEvS05qQURaMUxBYjRsOFZ6VDR1SCtXQ09VRHRjMEJQOTFDM2pXeTVPL0tL?=
 =?utf-8?B?MW05MStyRW1lQWJoTnM1b1R0ZnJRaHUxK1g2YUN0d0QxdWlwVzlRVW1aS2d4?=
 =?utf-8?B?ZlU4eGZHSU9ZMDcxT1pCeUM5YW43WHQxbi9VWUNYcWRyZ0NsaWdaTHJzYUky?=
 =?utf-8?B?K3lCVnpLK25wTDVEOGFBell0bEsyUGpzdjBKRjFHcnplZXZOTkxYaEEwd08r?=
 =?utf-8?B?c1VpWVEwUTdiS0w4U0pldk5vcW9pRUY4cXNDMjhkQ0FNam1CYXlzSW10c2hR?=
 =?utf-8?B?bjU1ZEFVdjlOWXg5Wm9qbkdBY3dvSnlJUDFtRlVsVFhLZ3NiODlzeVkyWlZn?=
 =?utf-8?B?STR2TERhZDREVzI2aDZHczlMNDhWejAxUStXc2sxY0M5b0ZiQ2p5Q3NHRXho?=
 =?utf-8?B?WGcvZ3pMeGdIN1BtUEloLzRjS0w4SC9DbnQ1bStGTGdHNmVzR0lpSldhTEZS?=
 =?utf-8?B?WFVaY01QblFKb29QR1poSTVSZWhJeVZWOElPbndKekpNdjNWVlFDM3ZpcmpC?=
 =?utf-8?B?Sy8wS0Zxb2ZtcEJBZ0RXTUloQWhONXdOaWpQeEVsSW5UbTA2WDJJMGF3QXF0?=
 =?utf-8?B?T28yNDBOWnIxc2FhczAyeDFOREJzaTJvaytHb0dxN0pFRkpjN3pmOUdFREpU?=
 =?utf-8?B?dFVYU3pKTVFDZ01lQm0xamZWT2RweCttemhkNzM2dUdtNGNEUWJLd2t6NEsy?=
 =?utf-8?B?Y011Zkc3Skt3b1B5Uk8zU3BWNXp4MHJseGVaVnF5K1ZYMlZVQ0Q5d056dDBW?=
 =?utf-8?B?cFBUQjFUU3Z1SmwrTFNGdTRiZXBBZGRidk95WU1DdC9sQXI4K3d2YnN0UHRN?=
 =?utf-8?B?cXo2Znd1MGhzbWtjczZ5YnlFMURCamk5bHpJYXVtSWdEUGtscXFadDBHLytL?=
 =?utf-8?B?aEhqcjRKdEVBVXBYS25sK29sOG9lb003UFpuZ2tFSGlPRXBDQ2VwTVFrWkdD?=
 =?utf-8?B?TWZGeW5Obzc3eUlPbDZEcWFvbmg0c1BqVndqeFJGWnhvR2FZK2VqUHJ1Unpr?=
 =?utf-8?B?UGF4V241b3NtNnlPd0w3R2NPY2lrUytETHM3RThLRnBUem9ldlp5S1RPZWtx?=
 =?utf-8?B?RDk1YXl2UlBDTDF3cllTc25ZYy9XaUdJWkRDWnRFOTlSWCtraTcwOXBib0Mr?=
 =?utf-8?B?VVJvbG9ZK3c3ZUpWRS9OTXRJY25MZTNqa2lINnJNVWpkZE8rQnF6ZFYxK3d5?=
 =?utf-8?B?bWx1MHZLN3NmOWZxQkFMaVpzNGpBaFJwSW84Zld4Z0pjRFNoejRUdlpBaThp?=
 =?utf-8?B?ZUVLYjFMZUNMVktGVmtKbjJ4ZXVSRnJkN1VMVXkzVFJZNDkvajNkUzZUZWpy?=
 =?utf-8?B?dFdLS3c0TkFtdnFjaFF0Y1ptU1F1SUk4WXFyQ1NXN1VGRzNZRFNBVVp5Yjhv?=
 =?utf-8?B?UzZLNm5ka1dBcDBGYTdFeWVpUHZkWm01QXpMaFVMODBPVWNKVXZZSW9yN0Jj?=
 =?utf-8?B?d2MvOVBCRWRuYkd5MlpDSmV2SGcyUjNad29aeXI4WWZoTFRaa0xGQWpEMXBJ?=
 =?utf-8?B?OFBlWTl2a2c1L2grbVh2VW96ZHRwbkZJWWxnTXZmUWVtNGQ2SEtJYlVMSE9k?=
 =?utf-8?B?c3FEcnRBS0h0VTcvKzdBUDdVeGxrdGJ1NlFJbUdEQlUrOUJ6dXRQc1FnM2Mx?=
 =?utf-8?B?SW04NGFlMUwxeEFLUTBmQXpGaVhyQmpMRHQ5UHk1YW5yTWpmRXZ6UHZ0SWtI?=
 =?utf-8?B?Uld0dlFueU1EUGVPdStQTVFOeC9rVGV1M2dPd1RxeWJnM1RWcG1oRm1LR2F4?=
 =?utf-8?B?TldUYW5tcHkyMG5YVk82RGhoSXlaNitieU9JbkRZaXhjRVE0M05DeEk1QlR2?=
 =?utf-8?B?VDA0NVlyUzJCZG5BTjRpSG1kSmN5NkRNSG1NUGFCU0lGYmxjZS9jd2JaUGpM?=
 =?utf-8?B?aXc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03161ef5-81a8-4a70-71bb-08dd831e8e13
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 10:55:41.5060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqpMhr5bWy7WR/I0Qbu6KYInOiJGfREE3nia/sIsoNSfhJ9MsjYhncTv0T9LvoYaqeDOLmshoLrXmHO2SfPOMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7925


On 23/04/2025 15:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.14:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     116 tests:	115 pass, 1 fail

Linux version:	6.14.4-rc1-g86c135e93323
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

