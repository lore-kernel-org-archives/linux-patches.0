Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714918DF9B
	for <patches@lists.linux.dev>; Fri, 30 Aug 2024 23:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725061276; cv=fail; b=rRbaTHVQpkej6Hosqa6ZC7qbUxB6C4RePsjPxlwtLHwjWbbFlA1kO2HPEtrsAuhdoo81AI16yJ+IppD1m8Hh9Hb+DpiOIWnGu9ccmX9y2YeSNrHJH62kQkhFEK8ZIjhbLvtd3+cm1dy8Xpt/uRk+YrWf1gqNg00njj/q6pe5nVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725061276; c=relaxed/simple;
	bh=esoIhx5bQ0a23iHn61F/p2WzTBClvzfkt6BJcs6cYu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=b1AW/43FFp1zGOvadvPUF3SUxdl5IxtTPc1lSQkc0Aj4rkRBldejERNSTvamiBFcBAUIJydIoEC+/1Mgbscbn6J807bi43pM4JpadwXtX2rCBrBhOxTGgC23eo1gNn/9DZdPF/xrMlKcehG8pXnEg5RDHtyZ4/u3Q12p8UWC/sY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XC0TqHpo; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XC0TqHpo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ocku6oBJEj1ndxnqJyHFZsgH4L9sYQ4Yg+RTEjMuhwJOXVSsfm0ZZIKI65Etmnq8n4cH2BxIuBe7CXsE0Vp/wSpOJG4bIGVbbbeoFRAJMJX4BUVbDq0mH49VCo0b2GMG1MvakrWLYIPe1g/7qOy1+1VHE8/NSPlxKFS5j0/idzGyddokes+08ifaYHthh/0vrqRbAC5cGEKpMRoHtnRvoD0ePYNJxiqrCOuYubsFfhe+HzLgU8MIg2uOXcU/1FEvlJS78y0YxGIMx+uZ2Bo2LTmdxxyLzv7nYOLSXQi84500E+SfORL8e9cRhVJEdTcdzcJuvrY9f4AcBg2JceaMqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2faB+/UH8Ri+qGFs57rftJDbbmO88EW+50dGNf5TuE=;
 b=x0vQC686m2QNV3Uq297k0thRHzj2vyGSvv7JDgv7Cl1VkroVZywADU+InRWnLiR5dd4kTUcCJM+sKBjjFNolG5eoKaaSHaOqhabzIY+U5jlRFtv6ftY/rK+/sOy/EtioqjjVTGUDjc1Otx6U3pPX3BaznZ1iZnkvje8cFbMRRg9yJfbw8uIB4BZTt8lv7VKpRuxFZi8MsqZOAC6RuX4bBtw5LpMH1Y4wb3Pef65olYoXaoWkgFEwxYNsTh1Z/3pULa49VdB25LCX33J/msz6+mKUoLYy8vNk+dZyJTro/Y62GnnpEKYjlJU/uRaCR3cJ4GX5L8BifQ6l5NQ4IOcaVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2faB+/UH8Ri+qGFs57rftJDbbmO88EW+50dGNf5TuE=;
 b=XC0TqHpoWwa4nvcSVWTdMrnEk0XkfiPrjF7iqwCLMEEF52+qf5SqmQgXeK5IS9N4as9tYJ5nhlm4iffd/Ez0x0pVW2aAjxUxduJfpdSarthGBhT7f4YNC708Y8qzhrzjAS/0XI8LGIIenRb7afMnqb+LQagKNXU7WnrlnupIfBShVC8myLJVIme6vY98aHGf699Tfx1Rt6UkRKHQdLhxlOtEaG/9qmHSvFWXDEJ0cb6eUiGM77O/WEMIIRYzy554CMi9sH28lKLCBrtniCc3Whe/IzQA94iVYKEf7HEALAY/NSorjjcSJC2cr87GMmQTsYA/9pGsdcFujo09nYQTHw==
Received: from BN0PR04CA0160.namprd04.prod.outlook.com (2603:10b6:408:eb::15)
 by PH7PR12MB5879.namprd12.prod.outlook.com (2603:10b6:510:1d7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 23:41:03 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:408:eb:cafe::3) by BN0PR04CA0160.outlook.office365.com
 (2603:10b6:408:eb::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Fri, 30 Aug 2024 23:41:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 23:41:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 16:40:46 -0700
Received: from [10.110.48.28] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 16:40:45 -0700
Message-ID: <015f481d-fd0a-48d5-a712-0df224d6d937@nvidia.com>
Date: Fri, 30 Aug 2024 16:40:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 046/139] selftests/net: fix uninitialized variables
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ignat Korchagin
	<ignat@cloudflare.com>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Willem de Bruijn
	<willemb@google.com>, Mat Martineau <martineau@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
	<kernel-team@cloudflare.com>
References: <20240709110658.146853929@linuxfoundation.org>
 <20240709110659.948165869@linuxfoundation.org>
 <8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com>
 <2024083021-cytoplasm-width-3e44@gregkh>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <2024083021-cytoplasm-width-3e44@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|PH7PR12MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c4333c-7165-48ee-4313-08dcc94d3596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHozTDZ6a2tSWVNvdWsyTWQ0T2dvNm5IMFZrSUdhQzVBV09hTGF3dGF1MDNQ?=
 =?utf-8?B?cHVEOWVUQkRPR3dtVFhKQmlQVytYU3RGTUdIN09lUWZxY2VxSkdJS1RKMnEx?=
 =?utf-8?B?a1Y1ZzBoRy8rTnNlNk81NXF2TGt2VDA5eHF5dmRqM2ExcU1RN0NKMXI4MkRI?=
 =?utf-8?B?Vkc5UlpsSG1QaHhheGZQdlB6SWE2QVJuMWxMWFVJUnNTclFYOEtXelVkNHFT?=
 =?utf-8?B?S1BzTDd1YnVnVUtpUDd4RUpROGdLL3pZNktZSkg3QzF0ZzY4bGZhRjUrak5y?=
 =?utf-8?B?cDdINVJJK0s5QWdsR0lMNGZ1ZllyYklabkdOSVlRajhvamNJNmpLTDFqWjBm?=
 =?utf-8?B?N2tNZ2hXWjNvRnNnS2NpcWE4OCtiYk9YL3dkRmRUUEhuSnJvcUpXcFo5Ulhs?=
 =?utf-8?B?YzRlZUtEWUkwdzNYK3NVdGE4TG1ueVloZm1FSkpNT0d1aFlibUtJR1RtZWxs?=
 =?utf-8?B?Mll2L3d3RWMxOGk0cE9Tci9oMXhVOUJ1cVNxUWpld0Rtd0YzdmxEbnFoSG10?=
 =?utf-8?B?MzF0U0FTRis1ZTNnWC9KS1ppNWpnR3RwdjBpWHdjUXBPMFk4NUtkS2QxNUhM?=
 =?utf-8?B?b21ybWl4ek00S3dKeWNaYTNXSnZJbWpyM1Z3NzI3SkZHemlId2J2MWZicWVa?=
 =?utf-8?B?ZzVwNmJ3RzJyVmdEMTlidTNkeGVYaFROMlUvdW0vdy9Lb3B2QysvRUY4dngw?=
 =?utf-8?B?ZGpjRWFmK1VkU0hReUFSbmNBNUdHZmtUc3F6dm00TVhpM1VubjZPbXZyWXBj?=
 =?utf-8?B?ZWZ2WGRtOHFTWjFjN0oxQ25ESS9zcVBHYmQyNVBVSEZVcytWNkluMlh4Y0Jh?=
 =?utf-8?B?Q3RwcTBtT2VBTEp5VlNLOG9wcFVoNWdwYXNrS0k4MndhVGZOdW5BYVR2QUcx?=
 =?utf-8?B?RzdxYzRsaloyU2dRR2U1TkJYRjh4Y2s4ZEJmYXpGN0R3MGIyUS9QVWxkeTFk?=
 =?utf-8?B?R3VQaUJHT2lqMWUrRDFhQkpCMm1zZHpSNXRZZVV6Q0RiUHFJNEwyZUlTOWpu?=
 =?utf-8?B?SFFmMnZRaUc1RklFbEcvaHVwekh2YnFRT3RkeEoxZXdSaDdtZlg4TjRlRzB2?=
 =?utf-8?B?bXNGYzNvd29VcXlWU2lBUjE3bmdYcVNXcHJVZ0pTNkNrZGtucnZHUGV1emdQ?=
 =?utf-8?B?NFVyaHNtVFFESjVCa05vNzBpWmVjV3FNUU9IUEc2OTZVVUhPamRMUkpBMTB1?=
 =?utf-8?B?YWN3WFNkd1FKc3E5NW9tZVE4ODVxZFEvcldSNHJHNmhSQlZYY1kzaVZtckZu?=
 =?utf-8?B?NlNlYTRWc0ptcVJtMzF5Y0dpTzFFUjhjTGh2aTlEeWxMVTJKMy9qY2VxSzkr?=
 =?utf-8?B?bW5DVTVBZTlpMDZEOHMyUVhUcGp2bXFrSmJNVU90VFpBemg3ZjB4SUFTdmk4?=
 =?utf-8?B?eHdhNVFURUp0bTM2S0JGSnFIUyt1QmJXOFpEdlI5b3g3Q3MzK05wS3F3YUxm?=
 =?utf-8?B?L1Z4UVhGeEIwTmpnWjd3LzY3VjJwZUhRZDZQR3J4cy9sMFpXOWtvY1M5Zlln?=
 =?utf-8?B?Ny9xeUFpdENIQVNrelRkamYrS2lTMEJGaG85cHF3bHNXbkFKdG5GelBhWjBW?=
 =?utf-8?B?U1FrK240cU9lSlBsR24vRG00bG1uMFQxTFpQZ0U3dUF0OVpaZzJHYmYrRUFG?=
 =?utf-8?B?aFFQUytpQXRrS1FyN250RGtSVTlaaHkzVHU1dEg5Sm5XVjc5U0JTdlZKVUMx?=
 =?utf-8?B?blpFRXN1Uk9ycjlHRzI3cEtoUnVrcDRsTXhsTUNWZFRqVnBJUUp4d3k3WXk4?=
 =?utf-8?B?eERZcUdhWVNQcVlIUWVtSzhYcUxsbmpmZ0RieEt2SXVkQ1JsZWEvSXhlcXNx?=
 =?utf-8?B?NVN5aDVGbytlRDlWRERQbi9CeGVoSGJqMGFYcVpRWU95UUNoMlRWSVdHN1FQ?=
 =?utf-8?B?NXNqUko2Z1l5NG9VNko0QWd6dVFrZWxGNUE2eUh6aTRhK1RWWVg3OS80VE1N?=
 =?utf-8?Q?S028RTXxbRFR8U3Eh2YDhujz+69kcWXl?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 23:41:02.6441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c4333c-7165-48ee-4313-08dcc94d3596
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5879

On 8/30/24 4:06 AM, Greg Kroah-Hartman wrote:
> On Thu, Jul 11, 2024 at 04:31:45PM +0100, Ignat Korchagin wrote:
>> Hi,
>>> On 9 Jul 2024, at 12:09, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>
>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: John Hubbard <jhubbard@nvidia.com>
>>>
>>> [ Upstream commit eb709b5f6536636dfb87b85ded0b2af9bb6cd9e6 ]
>>>
>>> When building with clang, via:
>>>
>>>     make LLVM=1 -C tools/testing/selftest
>>>
>>> ...clang warns about three variables that are not initialized in all
>>> cases:
>>>
>>> 1) The opt_ipproto_off variable is used uninitialized if "testname" is
>>> not "ip". Willem de Bruijn pointed out that this is an actual bug, and
>>> suggested the fix that I'm using here (thanks!).
>>>
>>> 2) The addr_len is used uninitialized, but only in the assert case,
>>>    which bails out, so this is harmless.
>>>
>>> 3) The family variable in add_listener() is only used uninitialized in
>>>    the error case (neither IPv4 nor IPv6 is specified), so it's also
>>>    harmless.
>>>
>>> Fix by initializing each variable.
>>>
>>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>>> Acked-by: Mat Martineau <martineau@kernel.org>
>>> Link: https://lore.kernel.org/r/20240506190204.28497-1-jhubbard@nvidia.com
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>> tools/testing/selftests/net/gro.c                 | 3 +++
>>> tools/testing/selftests/net/ip_local_port_range.c | 2 +-
>>> tools/testing/selftests/net/mptcp/pm_nl_ctl.c     | 2 +-
>>> 3 files changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
>>> index 30024d0ed3739..b204df4f33322 100644
>>> --- a/tools/testing/selftests/net/gro.c
>>> +++ b/tools/testing/selftests/net/gro.c
>>> @@ -113,6 +113,9 @@ static void setup_sock_filter(int fd)
>>> next_off = offsetof(struct ipv6hdr, nexthdr);
>>> ipproto_off = ETH_HLEN + next_off;
>>>
>>> + /* Overridden later if exthdrs are used: */
>>> + opt_ipproto_off = ipproto_off;
>>> +
>>
>> This breaks selftest compilation on 6.6, because opt_ipproto_off is not
>> defined in the first place in 6.6
> 
> So should it be reverted or fixed up?

It should be fixed up. And that's what we already did, last month:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=6b05ad408f09a1b30dc279d35b1cd238361dc856


thanks,
-- 
John Hubbard
NVIDIA

> 
> Can you send a patch doing either one of these?
> 
> thanks,
> 
> greg k-h

