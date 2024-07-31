Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983231B29A7
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722442208; cv=fail; b=hURC4b9D3SFd2poTdqtHoapNM+vUfbrjeN3VANplh8CXG17TZrwzCnCGpAlcJaF+8d5x2zvocmZ3DufnBv89OYQbtS1rJUgym7gsjbRJlu79isl8gG4eP3a/A2hB9nCzLZwLgR20oO+kCmFp0L11pRVPmbwmxGcdZjiX4tHf9xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722442208; c=relaxed/simple;
	bh=D0/No8Oi6B5DzPHuTaIsLl5CvoSNx7awpGQ2H7PuNIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ixnQW3ALDBd2oCUdXmEHHXEZ/OjnR+w/+TAqKCtySZBqpBIzqAn+Ju6a4shyaXQeJMsGZXw7dSW8JU1SECDNwkQVPSnpKFHpIQNpqyA/ZghGgFW0k2Ld1UEwZgjW8cdX4t/gZxyZAsrQerkoxS88/wFEfbTB2CkUKNhmz22vHQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dUokZqrb; arc=fail smtp.client-ip=40.107.96.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dUokZqrb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a40rJ/qsrdIaMawo6MB5IXoYbkD1FbeC/65rpfSzESv61R3jUiJGvvZP8vCZbfTr8pOscB4Yyzwzd9nHxRLdt6RjHWRQHFTrvbJi7VV5Q69zY77+hu1X90XrbIU5zRkYpHudNpJs+gwJiRUoTlMXlRPghQh0ExThK2dycXlCNzV0nCKtYa1rM1okWlPJuU2Z9U55iypWKq1gepyt5poVGgjTnJY3RCrIzdmcNV27avIp/RPh183AD5SBASgfVc4tk+aiFEAJp/e37ZydX/z77tRpANvGO7VN6dNBNzUlKL+TX+8hcpyWcoJ5zVs/t3RfQiUUlIKRcbyoZSeRANvw4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KiDnVfG6K9kKau2EL1tvdeqBjLN04dTO7a88yczdFC4=;
 b=m3JpLu+Dv3aeQ+sSyWriwhnuoUi5qfTt3Pp6zLgarCd8sPCGO1EQNGT3YO0j0YYwhxx3xQyumDFfjJjUxDcin9UwY4NmBoNrcKc6+CxEVWKyKtA+6u0RFyb55bPcYeyAUyY6h3e7FTXeZ8WPgMSbA6050VQMHQ9tuqWu2V/NQsgpwbdBz4kgavkZPmXAK9uxAFy8YXKuGrKOlWaTKnC7l/2GYm+EfClfGR2c6Y6iG9GoMYo8Eoe6WIckBDAAIymcqqhJ4gw025vh8srpTO/hSMuRilIHkqF/N1a/+BVt29Zq+7Fy4oZBDugGo4Xa3DXkpSCao78pGMoNtY8wIDOdcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiDnVfG6K9kKau2EL1tvdeqBjLN04dTO7a88yczdFC4=;
 b=dUokZqrba5cLCm84vGrJwCj4EFoC8MHztT9OI1Jj9oEg29vxhIG3fJj/ZFagRYDPr4rtzEFbm4y8yE+rIN0LBdcZW6gwp5CBbL5DjCvgKYiXbhcYIyHHDzMyW4R+fPlmeYXNeVFKfwliK67EFY+WCmCP5VYKrFY0fhosoQqECy0E2A4Cu8wFbKM64U1MEGPFsUWlhdqXpt3upl7d18kHl5PSmSWLdFqVsM/rTv8tKENU/dmHikdDnLy5hSXERh0+Hjq3eN7e87iXGVON2h55YPM1sDRIYeBg2NnsPxroHqHeNVMXPQAh/65FKUDX+xxD1yCljhtfy0hsU4LcIIQzzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3341.namprd12.prod.outlook.com (2603:10b6:208:cb::18)
 by DS0PR12MB9324.namprd12.prod.outlook.com (2603:10b6:8:1b6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 31 Jul
 2024 16:10:03 +0000
Received: from MN2PR12MB3341.namprd12.prod.outlook.com
 ([fe80::d19:bd59:da0b:62be]) by MN2PR12MB3341.namprd12.prod.outlook.com
 ([fe80::d19:bd59:da0b:62be%4]) with mapi id 15.20.7807.026; Wed, 31 Jul 2024
 16:10:03 +0000
Date: Wed, 31 Jul 2024 18:09:58 +0200
From: Jiri Pirko <jiri@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 259/809] virtio_net: add support for Byte Queue
 Limits
Message-ID: <Zqph1kRQx0FU4L3I@nanopsycho.orion>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151734.824711848@linuxfoundation.org>
 <20240730153217-mutt-send-email-mst@kernel.org>
 <2024073119-gentleman-busybody-8091@gregkh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024073119-gentleman-busybody-8091@gregkh>
X-ClientProxiedBy: VI1PR09CA0122.eurprd09.prod.outlook.com
 (2603:10a6:803:78::45) To MN2PR12MB3341.namprd12.prod.outlook.com
 (2603:10b6:208:cb::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3341:EE_|DS0PR12MB9324:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f762140-80e6-4985-0ba3-08dcb17b3c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bCuMzau/pggfw4cjAo+XOz8I7sC1V96TYH/lwi0rUtbX5725dSap29/AH30j?=
 =?us-ascii?Q?0Xv7rd5ZATY5IQkYGqynZk+FJGhQOA12ZsJy1pcE9COSad72gVgu7SXl8aUJ?=
 =?us-ascii?Q?noFYXFoqhpJan7Psc14lXtlTrPuyUH0kPwBWFIdqD7Yd+ZsJSffvBWbEy0HG?=
 =?us-ascii?Q?2YRLp/HNDnRJpcy4ArgfD/Jdz30nIaXaRnLUQVUGL+M/q0Gqo8TUmcapQpvw?=
 =?us-ascii?Q?YVMiWx0hgJcMlS60PMuYYRttyExY+hn8J3Bs7P7KbD5RSCA3nLuLCOT4729A?=
 =?us-ascii?Q?ShArN6sByZ8RPKnIJ6DnBEtCTnxPUzpCpm/u/A/8dsx0Bg78AVainGF18wU1?=
 =?us-ascii?Q?4EaSFGgdaBslpklgXBCPvunuR2wXkuCkiOWaFoJs7siDIDIWyvrKyl7gMkuw?=
 =?us-ascii?Q?a/WTexxfam2nyNXE+BF2F0TZTfXBETFHtRZsji+W2yjXvdtz0NCAFfPygF8g?=
 =?us-ascii?Q?Zdyhs38BR8BR6mS+fuf+gBFtJoK/GSyQajZ9Fzy7dtVfWd40wg2UcoN5bme3?=
 =?us-ascii?Q?g7dYKKhejECWdYsPHOpbK3khM7wtKKE+G+vhEiFzRAChDrx8uCZtdJ7sxqIz?=
 =?us-ascii?Q?FXwfkzv1+HSrWJzP62JMH2wQcYXX1SkqS3G7FPput090eqn5/o/8z4WfB0Il?=
 =?us-ascii?Q?8D1Ed2zUOa8bM1nw0IiKeywrrolLDDdR/J1Kx0rDczs0sWUZE7fuJnyb/++P?=
 =?us-ascii?Q?GiBhBgqHB+g/AHoxKAzpq8B+9gx8RlzX5xaVNz2o/fwH2yXfVy10fhFd5SJI?=
 =?us-ascii?Q?sxdYI3n6d8ahFhsgiGlZK/IF764A97QKCIC4AM1+a3kG1Plz+lG8IKtbkk+r?=
 =?us-ascii?Q?xGavoL42ODwazMbaooIqGoDsWySyyPbuxu5sfzACoi5suAlxh7ncJ1o9M9DX?=
 =?us-ascii?Q?gDNias9cX3shE52o3nLFyc0coNZ1EPL4u56jzcj7ZwEKkVk2SmfEimE6RqgR?=
 =?us-ascii?Q?YBDTQaeUJsdQxzg73b2/3Xb3UZQh7nQdvgt6TpW6VjbXbv1HqoWOw/FIxvCi?=
 =?us-ascii?Q?NF0qL+KizDtE/01T2po4VRhX1cJZWMbV3ed1Z0RZEni8378PQjKoTEzvjkR7?=
 =?us-ascii?Q?q56oW7JmGqx0+IJxZ0xVY+S6xRLy/DJzTrFtFOCK7FoGpRDuB+pk4ZpO/rLz?=
 =?us-ascii?Q?oh0puznKxSMFmh2pB89AQuy+59JzJS7f8TQSfpePOjomtTkuaWt3YQ5XQuX1?=
 =?us-ascii?Q?HHFx6QqYPK6xIq46FMF03gI6nRoD1KDMO/kusqdi9jcK6uA4fsN5QWnYTIv+?=
 =?us-ascii?Q?fQVyaiaxApP9C6WhtdbEbpMyI/yihLVeIR2tz6hmO0x99NcvLowd14LKN1n4?=
 =?us-ascii?Q?QEWjqda4vUiG2aEPR7VBY9a3wO0sLVgN+aFeefUrLYnbXA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3341.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U+nc09XSJPz7+VH02m3HA3qGZaQlx+PJ68+TbTjcTY9bxLuHqzHv2knQ+y0a?=
 =?us-ascii?Q?ykxq2ebUTA21vlJJARwq4I9YiKCCxj0pxmdwo5p/gzsNgJuTYE9fp22QuwNt?=
 =?us-ascii?Q?Xd9hBlpQk5wnWo6DoAluukRwcPMPmbM9ebUvv6812T9mZy8jdIdRUA7WAVFs?=
 =?us-ascii?Q?jjRTWC3wFZH6/WoAjUFJxx+XY4w1qQBLaFek9PGDPjDoRwcfhHN7VJkHlBFJ?=
 =?us-ascii?Q?P/JuEoulv3Vm3i/D6nr6fZRzVAruwk47LkP4h6klzOXILy0r8oGrJoXwACOJ?=
 =?us-ascii?Q?NXMs9kObe7d5XDhXQb8T7gTHDKkxBjCUAJRUPR5oARX3mxoPYYrMopRl42hs?=
 =?us-ascii?Q?4ovZDuUf+WrtD31SZC7HQNgFSNRUbYpWveT1+DbMPYLpMuy3Pnv2nbvzfYRa?=
 =?us-ascii?Q?Q8lISl9Z1yTJ5pBnKGHW8XrTYOfPcaAlwE85l0BuGnQpI6E8iGn1Ksv68//0?=
 =?us-ascii?Q?9sU70Z6TDfsfJ8BXBSJqllK/4zFjTvU8QiUrSCLhObRZSSPmnkIsLFkbpgwi?=
 =?us-ascii?Q?xP36hXBBsa1by6LJtbw+UKGuCwqezGMppq7UiaEOmZuQkAxAfrX/lKSR6tzR?=
 =?us-ascii?Q?55EMaTxAw6LzCJLe6rPvPlnTNNAp7utlM/vWp+jUtuBeaqbVIZUaCoxm0vcl?=
 =?us-ascii?Q?EOjX26XGVnvqgFZIf1/DejXJ9me5mKT3zcrwgigip4QPwqrxOzInvNcPtM8M?=
 =?us-ascii?Q?VS2yG6STF+YC/W9tLSrNz8RS9NEpnFTAX11W1aMexX0Sk+nVdFqg+ljbvIpH?=
 =?us-ascii?Q?Z/tOn1TwchBSQSEfnqVmXV/saYHAJ+Q7wPpf5saqvc7sILFI4ZRIfd5OSTWZ?=
 =?us-ascii?Q?PAVu0euZUQQJZ7TVUx5rn6xxX7KWHU0almRYPKWPfqKlum1fOqkOyPMQTS8A?=
 =?us-ascii?Q?8DaaofqWUDFAdOuDYhKQOQ5WsIpb+aiP4fC+Goln8L07CIF6IpaufMWCfLdb?=
 =?us-ascii?Q?b16oBfONFqZW+HLo+/QzNn94t+WH3cktYCVEVIAp2hOlN9l2w4Qg5YmhGsoE?=
 =?us-ascii?Q?7jL3NTMj5dgSgdDsOXcAbqMTgA+KfNoTPioY7geTe5cKypgt1y0OHUWyQsnP?=
 =?us-ascii?Q?kGS/loPJp+wqJ1X+C+zK0us4Xu6OJ+GPtG/NphMbOCVr7YlajaeoVt14Oi7/?=
 =?us-ascii?Q?JLHOGw09xuwF6QiZOl74jrP+FfRh2bIbLGXThURrwyGbcNx704vGgiVAJlcM?=
 =?us-ascii?Q?cNyU+VwhLS6DgP0z1K+MKog9Ul034KetgnZVMhxpOIatUJOysuDIHbVxdZ9W?=
 =?us-ascii?Q?N8zycQfdJkJLKyabXyEnqW/wZB/4nWhNUc4ieO5hqNerXC+BxMdv2t0vsRq6?=
 =?us-ascii?Q?C5zBx1pW1TfR+KnCngl6dHlZ7gFYPwUKTtRgQgwUIMq/TRa+06UvFj/uu159?=
 =?us-ascii?Q?atcwa1eB0HtF3s8TSPX3WlSr6WMi2vp2mdmKpIU3/H63wjMI0hzTJvxRpu4p?=
 =?us-ascii?Q?xCBAZn2h+Y1yOT5oUiaHaJS+QygG4MiaSEVsh8DT+JWck2zkU/5WtcT9W0/j?=
 =?us-ascii?Q?bvVgIbAI5lfbNC88Kbl0k/y8Aqnvz3Rh4CiFNhxHCX8Ai6HYXY93bN5/ee1T?=
 =?us-ascii?Q?cDm+0DBIer+GOP57cfz8L2UpPhAwH1TVpVW4u0zI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f762140-80e6-4985-0ba3-08dcb17b3c1b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3341.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 16:10:03.0729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCBVwnGAd+mlT6rGRdgwL3YsTM1KOzMLCxqckBtlxyTKEL/P8+SPgZKJHUpDhLAj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9324

Wed, Jul 31, 2024 at 07:46:26AM CEST, gregkh@linuxfoundation.org wrote:
>On Tue, Jul 30, 2024 at 03:33:18PM -0400, Michael S. Tsirkin wrote:
>> On Tue, Jul 30, 2024 at 05:42:15PM +0200, Greg Kroah-Hartman wrote:
>> > 6.10-stable review patch.  If anyone has any objections, please let me know.
>> 
>> Wow.
>> 
>> It's clearly a feature, not a bugfix. And a risky one, at that.
>> 
>> Applies to any stable tree.
>
>Now dropped, thanks.

I wonder, how this got into the stable queue?


>
>greg k-h
