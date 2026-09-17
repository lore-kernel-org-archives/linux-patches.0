Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050594973A1
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789675255; cv=fail; b=JJQEGQi0c7NabE1c+VEgmbEYIemO5ME+r5WFA51a6FCHaeLELwbiWEdv0lyfGyLtFAM4qmATyLUOLSBVg03DfQ6RGQ0wuqDRQ9v5Epd4nJKVideb1tHRpFokub2L28ot0oeaZY35TrJRGtpzhn/an/NQ9YShUvucXxAO9XtE0ok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789675255; c=relaxed/simple;
	bh=JYi5kuJ682vr4rCOUXRHfp2y+Z5GIKwHtV4ZmDuflhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r7B2P0hs4IykPmLQbcfOo3gAQvF39sykMgeP2Da70gXT5FtrAdkwkwUxkpt4Gt9O2V/Bg83I/YSqDjwYhx9XaaYbBk13Q0KeKBBsPwGDXkqqhF7OULUxtbhelhFKIK4VsrIl5P5fnuOo8UvW6kzU/CrGW+FhXZ3cPjWUXDZgKPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=okfGyiTs; arc=fail smtp.client-ip=40.107.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="okfGyiTs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZPYERhENCGcQoTzlhGoFcd0e049HLZedOAlHAMIG9/LQCF+TBKGqAQYlMcy7R8WUQpgIVIxUd0pl8aOPGqf7BJQ4h5ZaKhjT3gbDIpmtDgpovztpXUB38Ev/SxCeEXAmDK6MqyZkqEt9yZXGvb0G8RI1To6uubaIWn/Cjwf2RjseVNRwB/WXaMSAMKqlD74qApS+cHL3N2CBuXWLk0nQUzfyROFYpFpMINogmfaG6NhxSBAB56vEGbE7QqK63lbX29JKNg3uNQOgzhh+MlJ8Pi8pvE8sJeZHBfRw42R3HYTIOC0rItvf4pUAb7IHELuqhQfhq9c2wEjkhEEWOQGVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aSULpbotcOIiLD8O8r3GUcPpbY7ZdsYa4myXNWCcS7I=;
 b=AM9XMMNrrldWn5n4jjgQ2mfQp8rQf2yPKXfVwcLLLg0xxCf0jpcTVSV/ViQZGdFe36tpJVwnAamYdNVN417qeQWmnEUUmObsl6YZsGco7hR08alEt68RgmV341yDQMqoOJHcl/Y7BZyTwKHQDiEpjv0DhvM4PXuUL4ciSkq5x64xs2tdxtpdbBwxSGVkFC7A5NEzpdgpzixDtkZxJ81HRyhoN3V6VA/UQZYUL3hFZS/DRvKhATnM1NEayitfDLODs4s/uxE7K7HK8OZI6ZzeG+PIkMcyNYwDnFp66ciYlIHgejDA5hlDy6S3xEGhVbyu+vf0Auw41gVPvmnW67eOQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSULpbotcOIiLD8O8r3GUcPpbY7ZdsYa4myXNWCcS7I=;
 b=okfGyiTs+qG5TQqFmcrT6GeMEHh6uFte6dMIFZx5m1uRGzshxYo68therTqESqYB86pFjkD4EvtStyDmajvit5XGr6XHFSesNJIKEgGuOFSwFauH+ZutN8DeLYjDX4THRfoFCKMmufcByIcqoWog9ialSWRQylVzYuUzva0xHkM8/Ncte2quqesBNLPDDxkYSIafyg1OldI/naoT5ThQK+/NGqG58+nJBnGvwLhYU1Bcshp1SDU+KsKyNfR/whaSF7I3zGhjX0357vbvd/VPoSSlALTIAqhU8RruG2EbCriu+9fQilgQ9wGEqfYi8qhWcoeFsSrdZp6S1ruA9fPb7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB7957.namprd12.prod.outlook.com (2603:10b6:510:281::22)
 by BY5PR12MB4050.namprd12.prod.outlook.com (2603:10b6:a03:207::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 20:00:49 +0000
Received: from PH0PR12MB7957.namprd12.prod.outlook.com
 ([fe80::9251:acc2:cc63:3499]) by PH0PR12MB7957.namprd12.prod.outlook.com
 ([fe80::9251:acc2:cc63:3499%3]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 20:00:49 +0000
Date: Thu, 17 Sep 2026 23:00:39 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Flo =?iso-8859-1?Q?M=FCller?= <flo@max06.net>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] ipv6: Honor oif when choosing nexthop
 for locally generated traffic
Message-ID: <20260917200039.GA1454296@shredder>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-211-sashal@kernel.org>
 <6b4dfa7d-09c1-4717-bd4a-5bca2d984139@app.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b4dfa7d-09c1-4717-bd4a-5bca2d984139@app.fastmail.com>
X-ClientProxiedBy: TL2P290CA0026.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::13) To PH0PR12MB7957.namprd12.prod.outlook.com
 (2603:10b6:510:281::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7957:EE_|BY5PR12MB4050:EE_
X-MS-Office365-Filtering-Correlation-Id: 03483055-0450-4230-0a35-08df14f65e95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|56012099006|4143699003|10067099003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KwDLDyJJz/0++q9FTuODoq0DG7ofYFigupICdoORofN4mAbsBqHqSJ3sVEBZfI7GzmGxBMARWWl5Y3BUKwSYvpX94YprlFBJgssOywBgeZu8rL0Vq87HMcqGQxENF/lkbAxp5SU8LYVHSJrJx/aXObrYMff9mwFU1Qwr4luwFfgjRrIN2VpcSzVZp2QpF5IFd0a5OnM8mkL7Yivfa0ySfhDlzqTI0DQlKrGnrqP+Qp7ZybkwUfjOMpwe5SfZGxYvXKGh+enuXwlLO9dTTyFYF3liXOUJbWAUZooDJ9iP/lYRMzd0FzpQAGDqEq+ZSodIXwM9sjwMkjVW9lzLDVmeMfOX1r87dQp5WGhWeZpP/K/nsj65Dxdz5yepfDdXwrArADtPYpaPRS5zt1sy4kdzZx0kSWlSoLqiSMcLYO0vyHH4uHk64J80SNskPh9cr+Rx7lJawtuu/qNZlfv3Ha7Q/jQXKYNcJl/kej8ZLVrRvEksOEjY0Qx1waI8+TeQbPrkKshq2hJ/9e3we9juyJIAywJ3qJvqfbqq7Gse1ccHWchN85NDpFaBqTDOex+XW8YHQhz2CUz7r7+DjKwsI0Z+4n2Sn1M2b+9MBdS9H0DkGyY6g8wZuoDPyDf4JYJsbkFCSEqdIwNlsXRnWUuA0wmMGW6rvEJtla6dCYgTBx4Xm6I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7957.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(56012099006)(4143699003)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXpqY0MrN2Y4MmRrcHNTYXRQRVJNMkJKMWZrOWNnSmRjaWgwK3pxMzUveFEz?=
 =?utf-8?B?NTB1amdUdVdPMjNtREduQ2dFejRTSXBLZmNhQldFUFVGN0xCTnF2b0tVUUd5?=
 =?utf-8?B?aDdKTmQzK3BLZ1dxUmlFK3NMV21QUGZpZENyYVFQNTlkZFlCZUZVaW5BOGF4?=
 =?utf-8?B?WHZRQ05pVFF4T2RYa1JkVHdTd3hVVGl0QXVPeHE2bGdxK1YrMzlWZDNKL0ls?=
 =?utf-8?B?dFA3dEVmNTFPempDazBpazVWSDh5NnkvVUpXdUt1SnQ4S3FnN1NRN0p0blIv?=
 =?utf-8?B?T1B6eS8vRmtVaGhMb2RkZ0RUL3FubUlTNHFGU0RjRTVuNjJEYUtiOU96NXNW?=
 =?utf-8?B?TXB4V2syN0FuRmxaTExkeUR4WGZlZlFoTTlQbTRtNFhGckFwR2xWckZjbVpH?=
 =?utf-8?B?QXJidkM3c01VTzJaVEJtZjFBd2tXYzd4c2dvRkorVEhxVTIyZkxVWFRCU2FC?=
 =?utf-8?B?UGNQOFhDMjVEd1BEZlZ4NTRraU5rdlBLV0xrdnlETW1KL2g1THNpLzRHTnI5?=
 =?utf-8?B?Z2lxUFp5Yk5xR00wZU5NczcrUjRlVzVMTnJlSklTbXRqVnF4UXRBWVhXZTFH?=
 =?utf-8?B?TlpEQTl6MDQ5c0x5N3BSbFV6b0kreWJhQlE5YlJlUFZDV0VjdkM1a2FGbEhS?=
 =?utf-8?B?cDJ4RFpRS3YzNDJ1WkgvekZtY2ZOcmp2YkRTU0hrdEFCcTcwSUthdXh6WWRp?=
 =?utf-8?B?Y0JINVVyVGZMak96dDVIcHJESXQ0Qks0dlg5WEpsdVdLODNUMk9JSHdoVjI0?=
 =?utf-8?B?bWtUUXlIOFh1Y2hnYkRITXVUckZSdDg5ZFh6S2VMeVdJU3FoT3lObG5DU2pp?=
 =?utf-8?B?TDhLVi9IOU9BUkdNbWRWVmdvQndKbElwenNYM3p6S1owWVh3V2pVS2dnaGhF?=
 =?utf-8?B?dmhoVGx1M3pkQ2h1MFhYM0VUR21TaXpkVzdxUFhpSnFrUG9nbWtndStjTEZr?=
 =?utf-8?B?aEZ6NXJFQjg3dFZ4VG1TU203UERqdmM2VXVJRDJNTGFzYloxT3htMkdpWnJD?=
 =?utf-8?B?UjhzNG1xV09NKy9nLzlZRkFIZ3drWG1ORWhKZFFEYjYydmI1aTdmMUEzS295?=
 =?utf-8?B?R1VLZ0VQNmN5ZDFIdFJTOXBVZC83QnEyenRVODNZdmhpUzVMUDdDdUJDd0JZ?=
 =?utf-8?B?TTh0djRSbnhqK0tVRE13RHE0eWllNjdESVYxWklOZ1hCN1I5aDFHbXRnUktZ?=
 =?utf-8?B?Y3Rsc1FFcytrQmszTjk2Vy9oOGszN2VESWJacjhKaFU2TWpZS0lvL2tOMkUr?=
 =?utf-8?B?cGF4SS91dnNscTNPajZrY0lxdVhFTVErdzMrOTBjQUFnL1N0ek1uM0pwbzB3?=
 =?utf-8?B?T2lKY2JPeXN4eENHTEdKNUlJcVlRUU1TT0hITENxdU1rSXN0ajR2WDNqbU9p?=
 =?utf-8?B?RTRnY2RUS0U1QXI5S2p5VXFnZ0EybjVES0FGeXBidk9mWUhOLzF3TnB5YkdQ?=
 =?utf-8?B?dmVvZTFSV0ZqNCtXNCtFRGYrbWNTRVdVc1JuaEhldnRnelFiRkN0RElmYXhC?=
 =?utf-8?B?eDlpUHlXRVd3QjVqU0J3dVlWODZlaVFuZi9xRWZIUkdYM2VhRU85UGJCV2FG?=
 =?utf-8?B?Qmo4eFVqSHk3dEhTczMyQ2pXMXBlTkdhVUxBbzFUaU1CWDVJMXFvQU82dlJU?=
 =?utf-8?B?KzZBb29QNCtMa1FWWUxoREQxUGtnNE43WTRORFhJWGRzRkJmUlI4RHBxTTVl?=
 =?utf-8?B?WWlOVU9lMFZGL1lYZDI2Y3VjMlNsbWVwUnVvU0hVbG5mTVc5ZTlib1RWYWxp?=
 =?utf-8?B?dzl0UTJjbjJaNG9QSmMxLzJEU2ozZGw3VjRWVVZvVDhLcFJpT2UzOXN0RVo3?=
 =?utf-8?B?UHd5Z25rcC8yL1FUQW5rUHA5c25IbGFqb1hhNmdVcnMvMG9jV0dORUVIN1Zs?=
 =?utf-8?B?eUk1NDg0Y0lmYS8rVm1GazdWYkhMN1NpMW5kRlBSNEwwaG5rYkFqbFVLMVZC?=
 =?utf-8?B?SXpOZFZWZEJqbGdPQ3dNZk9VazdyWHlLc1M3MmpaVUdudlI4cXNtRTU5NU5J?=
 =?utf-8?B?ZUsyVnArU1d3TXpPSUF0TEJXbXVWYXRiK1FjSkFBT3VwUnZITmRFSVFnb0tF?=
 =?utf-8?B?a0I1ME5vQzFFdXdzdUdPeDh5NWFPazBYYnpnT3hsY1RJRUgrN3FrQ2lNWjFj?=
 =?utf-8?B?MHNsMUVTVGZYQWovTExxRGZhL1hkelg0K0x3aFJ3cFd1MllWM2tJV2szUDJG?=
 =?utf-8?B?WGt6Q3c0SWw2UHBEMmliVzNNKzZBZFc4T3Q0MVUzWlZpdE83dmNqbExqU0pX?=
 =?utf-8?B?cExJN2FZSmg2WlBSYWhZcHZ3WDE5dHFaZ2JLUGJWNTU4SnR0cHBsNXJicWxT?=
 =?utf-8?B?ejlJbEI5ZmRaUGcweDlTVmR1OFdJNEpxVVk0QlpiTmlDWGFndkZZdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03483055-0450-4230-0a35-08df14f65e95
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7957.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 20:00:49.4162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2F7OsZhgDYHfBbtwXbvt/oeNCGhfM0FvwC/hwwelGFHh77caSvbJl72WsVFDOya0UeQ5XkgHdm3iby6AIS/vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4050

On Thu, Sep 17, 2026 at 08:56:17PM +0200, Flo Müller wrote:
> On Mon, Aug 31, 2026 at 09:23:59AM -0400, Sasha Levin wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> >
> > [ Upstream commit d25e7e9d8a6c1e2afb854613e417c6aa1a28ce6f ]
> [...]
> > **Step 3.5 — Dependencies**
> > Record: Patch 2 is **standalone for classic multipath routes**
> > (reproducer in commit message). For **nexthop object** multipath, patch
> > 1/3 is also needed so `fib6_table_lookup()` picks the best-scoring
> > nexthop before path selection is skipped. Patch 1 not in tree; patch 2
> > alone does not worsen nexthop-object behavior.
> [...]
> > **Recommendation for v6.18.y:** Backport this commit. Ideally backport
> > patch 1/3 from the same series together for complete nexthop-object
> > multipath coverage; patch 2 alone is still valuable and safe for classic
> > multipath routes.
> 
> Hi Sasha,
> 
> we are the nexthop-object case from your dependency note, hit in
> production on 6.12.y, so here is a real-world data point and a request
> to carry patch 1/3 along.

Just to be clear, this report is from a kernel that lacks both patches,
right? I fetched linux-6.12.y and I can't find my patches there.

Note that I targeted both patches at net-next since they don't fix
regressions. This use case never worked correctly.

> 
> (Disclaimer: Analysis below done by AI, watched and confirmed by human)
> 
> Setup: Debian 13 host, kernel 6.12.101, dual-homed to two ToR switches
> over unnumbered eBGP (FRR). FRR installs the default route through a
> nexthop group, which is what every FRR or Cilium dual-homed host looks
> like:
> 
>   $ ip -6 route show default
>   default nhid 20 proto bgp metric 20 pref medium
>           nexthop via fe80::<tor-a> dev ens31f0np0 weight 1
>           nexthop via fe80::<tor-b> dev ens30f0np0 weight 1
>           nexthop via fe80::<tor-a> dev ens31f1np1 weight 1
>           nexthop via fe80::<tor-b> dev ens30f1np1 weight 1
> 
> The kernel's own lookup ignores the oif for this route, with and
> without a source address:
> 
>   $ ip -6 route get 2606:4700:4700::1111 oif ens31f1np1
>   2606:4700:4700::1111 from :: via fe80::<tor-b> dev ens30f1np1 \
>       proto bgp src fd00:2:1::11 metric 20 pref medium
>   $ ip -6 route get 2606:4700:4700::1111 oif ens31f1np1 from 2001:db8:a::1
>   2606:4700:4700::1111 from 2001:db8:a::1 via fe80::<tor-b> dev ens30f1np1 \
>       proto bgp src fd00:2:1::11 metric 20 pref medium

fib6_select_path() overwrites whatever fib6_table_lookup() returned and
selects a nexthop based on the calculated hash. In this case, both
hashes ended up picking the same nexthop.

> 
> Same for a socket. A test tool sends UDP on an AF_INET6/SOCK_RAW/
> IPPROTO_UDP socket with IPV6_HDRINCL and SO_BINDTODEVICE=ens31f1np1
> (root; the source address is a service address of the host, not the
> interface address). The option is accepted and readable back:
> 
>   setsockopt(SO_BINDTODEVICE, "ens31f1np1") = 0
>   getsockopt(SO_BINDTODEVICE) -> "ens31f1np1"
> 
> but the frames leave the sibling interface. tcpdump on both NICs while
> 3 packets are sent:
> 
>   ens31f1np1 (the bound device):  0 packets captured
>   ens30f1np1:                     3 packets captured
>     IP6 2001:db8:a::1.41022 > 2606:4700:4700::1111.53: ...
> 
> Impact for us: anything that pins traffic to one uplink of a dual-homed
> BGP host (per-link probes, validation of switch-side policy routing)
> silently takes another link. We lost a day to it before suspecting the
> kernel.

I don't think that it matters if you bind to a device or not. AFAICT,
with nexthop groups, 6.12.y completely ignores the oif and simply
chooses a nexthop based on the calculated hash.

> 
> From reading 6.12 route.c: with nexthop objects, fib6_table_lookup()
> returns the first nexthop of the group unless the lookup is strict, so
> the have_oif_match test that this patch adds to ip6_pol_route() only
> becomes true for nexthop groups once 484bb9d164df ("ipv6: Select best
> matching nexthop object in fib6_table_lookup()") makes the table lookup
> prefer the oif-matching nexthop. Its commit message describes it as
> preparation for this patch. For nexthop-object users this patch is
> therefore incomplete on its own; please consider queueing both:
> 
>   484bb9d164df ipv6: Select best matching nexthop object in fib6_table_lookup()
>   d25e7e9d8a6c ipv6: Honor oif when choosing nexthop for locally generated traffic
> 
>   https://patch.msgid.link/20260611154605.992528-2-idosch@nvidia.com
>   https://patch.msgid.link/20260611154605.992528-3-idosch@nvidia.com
> 
> Happy to test a 6.12.y tree with one or both applied on these hosts and
> report back.

Can you test 7.2.y? It already has both patches.
