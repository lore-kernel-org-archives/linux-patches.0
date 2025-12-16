Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazolkn19010001.outbound.protection.outlook.com [52.103.13.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911A232E154
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.13.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765910114; cv=fail; b=l1T7mH79vqcZGcRDXoLVJP8UT+QbPgFySVhqSHnXs98EHaynP5PoRLQlupuaS9G2aIYV8qHb+m/Ijt+W3rmUP5bVzuJaiTu71eVY+UHMOB/9308tS0a3nezPB9cAOnh/PBGqE/y+WUMkm5IdvgfHGY3+i/9Ix53r9xYA8+rCpV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765910114; c=relaxed/simple;
	bh=jFOLdtu/56E8fwChN5DIw1AhC5Lah/WSp191VuuMj2M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DfS8EPdZHXVPjqEXFpkWP0+e87Z88ipLvbVticZlq/7ojpcSrWZLXYZifc1Ygzo2yIXy7Pf0X05545iowfEP1PYZyRdcHOiV7WCL4bDMXfB4VIKM6P/JVZ3F5KO5cBoXqtU06T0o4954ehUDbtcW15WVba4RUgjYP6PATZlqqxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=HHF6BLU+; arc=fail smtp.client-ip=52.103.13.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="HHF6BLU+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iMBCMYwvQZNjYiVbvD4+z059Wa4SznjZRGma2h2ny5CVzi7qps3DmSlZYck9fsQe9XoYkpc0grkfzHOk1RK/uVemuGzjqiHjeyyfN9aw1ibeM7PI6GdBbAXcHcACDzQZQp3+fGRTEkePRq8GtoirBVP/T6PF4Idx1iE1U6HCkvxE7oiIKRMD1ADa32YhhkYtgZ9WH0E7zufpqISLZO7ySMZ+7hnNP3cfVyAr3mDVXdQImyuMgz6Oe1+k5Tv8gso9K/dy36jCk3EWHiTEE06KCSJhURfwRYeJz9+VUNw/NmaOTE8iFP3FwR9MnzYH0EKy2Kf3dqAfjo4cscYazedWwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zlmLaR+AlZ0wmDF8OZFem2dUO6DT7Ke75SZcJScwUI=;
 b=ft0FXtsAXwKgOFsYi5sc8pRTCjukuKKPY/J+kIEbiVcYlLg0guD0fUZIIEsxbJCI1K6lKSmsEVmZma/IoCcr3SZwqp0sGjyNX08e5mujCViU56f3on2vYEeRc/2oOESPzlCqnJSNRh0pp4NJTlv6+rKV+Bt/wHUTbxDRw6XbkaD7IW/iVamgiCA+IyZCMqKxBfykYww3WE9UpRB0mwdnCovDR7wMkEBl2O55kknWzF/A+B3TxzkAFkyqDgNVOafRQcNu+n4mNj775Rw1ijiNvILJ+2TKy3wlWo1ICQkziJHg8kGcWzu++REnuR3lNXEJv5VOS1IAh9OTWIdI+ShK/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zlmLaR+AlZ0wmDF8OZFem2dUO6DT7Ke75SZcJScwUI=;
 b=HHF6BLU+GxBXmc2iQj4176lLYyqaPK5rcYiiPfEzdlidiiWVlIzVHFLOfmxyeLExwcytyZcxAbmiCIbDzv9GvIFE8ZfV0/HDA654ejdM3B2AxMgsxe/2lGRbnZPZYYAL7NXEDeiEwkljVAFYnTbqilV52TxduVOy8yf1b8HmxK4fLgiwa4zxGazr3zqMsIrsjviVlyp5tOhDxQX3ZuQwunYVzm4Xq+jjiSizsMFrGEmN1ku8HWhVHL8ey6aJ2i1IxJ8lXBvw/n27CgzuzWe82myuOD+hMPxlgJK+SqYYsDnHMkmxxapmGVrGjAHHHXnzJL43/s/pMyPLTpOEIWNrTQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by MN2PR02MB6766.namprd02.prod.outlook.com (2603:10b6:208:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 18:35:10 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%3]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 18:35:10 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tianyu Lan
	<tiala@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 6.17 248/507] Drivers: hv: Allocate encrypted buffers when
 requested
Thread-Topic: [PATCH 6.17 248/507] Drivers: hv: Allocate encrypted buffers
 when requested
Thread-Index: AQHcboJf4k9RHm8RdkuigSN6Ifw0t7UklpaQ
Date: Tue, 16 Dec 2025 18:35:09 +0000
Message-ID:
 <SN6PR02MB4157D6A6FF1F5037FAB1EE05D4AAA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20251216111345.522190956@linuxfoundation.org>
 <20251216111354.479243388@linuxfoundation.org>
In-Reply-To: <20251216111354.479243388@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|MN2PR02MB6766:EE_
x-ms-office365-filtering-correlation-id: 80964933-31a5-4264-7694-08de3cd1d7d1
x-ms-exchange-slblob-mailprops:
 AZnQBsB9XmqhcEBlXno9HJGOoZcx42eNleNZBJoufM/hG6FCdt8Xbvc67rFkyp+7Q1GgrRKNc4we3Mdykveh4DRKcJmcN8u+EmTvJ38W0FSpGvYgrE5WRKSbfYGYlL4VY2BOHLn3/aMlnV6mtjCHM+4rhsUrnqxh19HDJtln15Nr1eqrpmjrhoJmXcYL87hzixpC6BpGOxfUUig6ML8Tp2Gx5a50ovETebqhqz+5k/+ohhNf7Bf7hm49rLFZA8FCYDlu8V2mf5Zqif02IjUtY6YQ2w+Us+3uSwYBlc3ws3lGLsNw5ST8ynZTNnZWvFXrUUwDy7aXuX0QC5XaI120EFaKoe9SbWR/sK5hdGyORVml5oR/HGuRU3oId1O5md8bbD9SVGjGb2VUhLrfJ71xgpScEiU6e/OqoAQO3NXdy1YtacgUfiiCA9m83B7MVtYh7OB07+XmrNugXtd9utBXv8/NkaJl+y/VaQkW0EWMq/onBBMB4LHhSUDiqc1wjpCY5qBaLSSGlf422TrxjS2itawT3bVS7oLBi4wBRxoQH4Cxrwe+hAtWAHDieU+fgSoPOqnb0dvBxuJug4iIesTybUGTVobmCBdpLMy+gPzXWCRhuxjjDI5bb4tmUkvnnxd+hUgnn+fFhZurifbCl7qSJ8xrJXCZV6i5PprF+EnAVEKsU2xm7PBXbCV6vbzH4Lp13kYzwNIAjtY+7o6bcRb9+Ha6lqfOpZZKNRdYsSf5HdpCC89rGKkDGEdiJynvr4wai9IuHJrC6vU=
x-microsoft-antispam:
 BCL:0;ARA:14566002|8062599012|19110799012|8060799015|41001999006|13091999003|15080799012|461199028|51005399006|31061999003|40105399003|440099028|3412199025|102099032|12091999003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?g5hvg+YUXsROKfG4tpPPeuii64RYBrDMzf1W3kihBLoM2PXhQLrugu+Y5Irb?=
 =?us-ascii?Q?+lu2tozZuRQWVk/wBeR4ToTEQvxSYHQvpGvbc+0zwyezoTUMexHcjRSTt2U3?=
 =?us-ascii?Q?uVEfkJQy0W778vHNsCZVP6Sj3EiGLxGRX9ehoaoexYYSV1grrSzQ9epVxfei?=
 =?us-ascii?Q?KeQ7TQgT71wmMvg7Lyio4X/Oz54dfBH9IbJnFtEZSYIcktklfKhxWDSV0cK0?=
 =?us-ascii?Q?kSXupI1HyakDe2j4BNBQeOAT70d/5Mpwmt5H/FdfQFkxrHP96LkO58OxNRai?=
 =?us-ascii?Q?D/RZ/jS97O+IIfIzSlaH7c6ldCSw01GzKKbJNNjEqJwWzlAz8i4zanvdKlJE?=
 =?us-ascii?Q?WYM04keYzbRKVWPZfA/Din3JGs/k1K0QhcfXmjZQNN75NJzIsjXiU93i8tDw?=
 =?us-ascii?Q?JzrN5bv2OfP3kdaSB4WqdecNdqpiaZlxyl59I+hvLHEvdL8gL/DQbMB3IWhD?=
 =?us-ascii?Q?PnqvlYCjbn9qQfTpJqjQ7fiT3cNaQUmno2/buCqu2Qe87K+Y0SBISf0EcXkI?=
 =?us-ascii?Q?+IuQrT2cuJunN3ltxKqe9D2Qn1Yjr8Yhatt6Gm40C0cXBTDohLPcbjZ+pqNc?=
 =?us-ascii?Q?sq6A/3xNo35Nciv8zFIpUyoeNrIRAtcClSlv6q4S1YLwnFQ17O6D+aky3DxN?=
 =?us-ascii?Q?AT0Bl/Ixu2DPeWoR9NXtBCijApyUrRCbtKd70zjUI6znzqhu0+pcHB3SUdij?=
 =?us-ascii?Q?/G3U5EronMZQReEinGpf+YfKr3oh0T8OkrgBikRISh0eunbhrv83i/6o3gn4?=
 =?us-ascii?Q?HkIAQPRrUcNfPg64uz8Hy8USx4KmHPChn5/9tIN45ZGHFQ3iUvKG3u94hON+?=
 =?us-ascii?Q?q1yQiWGX47Y368TsrJuQko3SGpjVu4COHLrsWBwU8joiB9WKNMQU+rSgKx+T?=
 =?us-ascii?Q?EHR5hRqFKioSiIpoPNcUKt4go9VFxhgW1ogRatSxrl1Um4mLAM9+WXF2qLxA?=
 =?us-ascii?Q?zfBsOZzPg9bOnNkVV5e5bNp03aarfRIYY4tyy4GD1FrUzUogIWEXtUYXhyGB?=
 =?us-ascii?Q?sJc81SfXEBknBAzs4xXB29CP0NdJYO3dT3UesirrpXiqfjgM4ayA3do5PH5R?=
 =?us-ascii?Q?x5pZWVctiY2p3OSh3xNsl8nLBQdVHZlFPvaiYMFP3YUXqoB0JesPJUCgpK0h?=
 =?us-ascii?Q?omkOXpEiJAqHmeCKOX/CtJFc7b7IXGAIW+Cqw4O9823Mo/Q3ZJPqHo5hBX42?=
 =?us-ascii?Q?Uh+KVCwqddYbwfbP/F7/LzS+G868AerP1LDOJciuhx16/v438cuFQPKJZvyU?=
 =?us-ascii?Q?vhRwTTPoA7VhFwxN4wz5scWw18AgINOhr1qE1fY3WQ=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TFNo8WMuBBsoKRo3mMbN1hXni1xFF2QP1V2jaOlvfMCVUeCAFK/cV8fSfrNb?=
 =?us-ascii?Q?ua1972ETz3RwZEcB/ghGjNA7QzEk4nL5Cx5tXNoaK5/wNlI2NYYjvCB56ZKy?=
 =?us-ascii?Q?ISUjVm0R76XSNhsEebyrERgXmL7xtAIlPIiijOZU1Sm66E0b9NtFHYs8AdAw?=
 =?us-ascii?Q?etNb7skdUwBl1TawgHinebdUKWjhQNnisM8svWd3jYTrjzyZ0q8SmSI6GAQk?=
 =?us-ascii?Q?DyZ3RTfvjNpEH9IRZw77VjSbBqae6evRkuTJQn7q83QukL2CM77eEtIPqidr?=
 =?us-ascii?Q?31gdky2Ix36xL4WyF6FPz2Ya9lgpSdghmpgLz2iSV4dNdRqwuCdcCeeTjnb/?=
 =?us-ascii?Q?/Z4UGoQHbSn0k+nK0jgCdsHo26fekE37RDOivucEwo64Z+zmAI5LddN16Fph?=
 =?us-ascii?Q?PWzEVIe7GfwZgnyLOVA4IbomAmQSyRI+VTf8AZW4w3jUXxWoF+fyI3DAvoEX?=
 =?us-ascii?Q?30ohmgef/joHNNnySZ5ONvFeTN2w97gcoVVRzC/V8OwuMP0VEv9s1Lyt+AGF?=
 =?us-ascii?Q?kFDU7VRvfJUbk8wcpYe1arPG48ufr2z9E5mgagRF0OgZPL499nuWB2nX2var?=
 =?us-ascii?Q?0ikb46uiM4Sya5qBjvcieOzIbOJJl2aN3KjayPT3smEEu5isP70i+RnbiHKd?=
 =?us-ascii?Q?MXnShl0YhR9VWIjsrAoEYYeU8hUxiL8ssto+DQtLziSwn2AFyTpKTOgjVnmR?=
 =?us-ascii?Q?zc+3UhiIWbvHxJeWaVpzh2zuVFnvicorw/C37M5p19eGU5WyoOH+lWL1Jhk7?=
 =?us-ascii?Q?zdOXPH0QmZArctNjfgujRnr7KGB5pTwuIa2FFYI4noOB1/xPuCpjHasVF4y9?=
 =?us-ascii?Q?/R9uOTzwj8aoeufl4t2aavSywhW0iWfDNYCGoaL0f7YGz3HTb+PjcXfQn8nF?=
 =?us-ascii?Q?8j1a/DFJAtQLwoe5jbo9MCDvnLb8XpaIFQzy96Mj1o7IJ2aLx1LXl/dOOcZO?=
 =?us-ascii?Q?CtCA4HdhLzT2MxRA7omV5HNtJZes3wra/Z2ntB0fX6bHUNwtk0MnhoP6GN4I?=
 =?us-ascii?Q?AIMXr5aE1aCKk0+ZazeomQ11GkIiCmWnOgu6dp965ddPoYmajeH2NjRwboIW?=
 =?us-ascii?Q?EHn+nsYHEce+wBt8C91OSb7P6hnAezduLrk0+qIN58l5Dj9qDekP+ShfRMPP?=
 =?us-ascii?Q?b5kuOoD/Ebdd6ItVNVNnINe7XiQpgHoYL+X4UYWwk9/SRXCucLGz3QtJvVdN?=
 =?us-ascii?Q?5khetugrKXx0bqn5kzgBOYnRxTlFXdapmeOCdQSDxfAIr1dTJIa6I4SCK/w?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 80964933-31a5-4264-7694-08de3cd1d7d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2025 18:35:09.9287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6766

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> Sent: Tuesday, Decemb=
er 16, 2025 3:11 AM
>=20
> 6.17-stable review patch.  If anyone has any objections, please let me kn=
ow.

I don't think this patch should be backported to any stable versions.

I see that it is flagged as a dependency for backporting 510164539f16 ("Dri=
vers: hv:
Free msginfo when the buffer fails to decrypt"). 510164539f16 is indeed a b=
ug fix,
but it's a minor "should never happen" memory leak, and I would be concerne=
d
about the risk introduced by this patch being pulled out of the large-ish p=
atch
series that implements a new feature.

Wei Liu -- again, override me if you think otherwise.

Michael

>=20
> ------------------
>=20
> From: Roman Kisel <romank@linux.microsoft.com>
>=20
> [ Upstream commit 0a4534bdf29a5b7f5a355c267d28dad9c40ba252 ]
>=20
> Confidential VMBus is built around using buffers not shared with
> the host.
>=20
> Support allocating encrypted buffers when requested.
>=20
> Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
> Reviewed-by: Tianyu Lan <tiala@microsoft.com>
> Reviewed-by: Michael Kelley <mhklinux@outlook.com>
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Stable-dep-of: 510164539f16 ("Drivers: hv: Free msginfo when the buffer f=
ails to decrypt")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hv/channel.c      | 49 +++++++++++++++++++++++----------------
>  drivers/hv/hyperv_vmbus.h |  3 ++-
>  drivers/hv/ring_buffer.c  |  5 ++--
>  3 files changed, 34 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 7c7c66e0dc3f2..1621b95263a5b 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -444,20 +444,23 @@ static int __vmbus_establish_gpadl(struct vmbus_cha=
nnel
> *channel,
>  		return ret;
>  	}
>=20
> -	/*
> -	 * Set the "decrypted" flag to true for the set_memory_decrypted()
> -	 * success case. In the failure case, the encryption state of the
> -	 * memory is unknown. Leave "decrypted" as true to ensure the
> -	 * memory will be leaked instead of going back on the free list.
> -	 */
> -	gpadl->decrypted =3D true;
> -	ret =3D set_memory_decrypted((unsigned long)kbuffer,
> -				   PFN_UP(size));
> -	if (ret) {
> -		dev_warn(&channel->device_obj->device,
> -			 "Failed to set host visibility for new GPADL %d.\n",
> -			 ret);
> -		return ret;
> +	gpadl->decrypted =3D !((channel->co_external_memory && type =3D=3D
> HV_GPADL_BUFFER) ||
> +		(channel->co_ring_buffer && type =3D=3D HV_GPADL_RING));
> +	if (gpadl->decrypted) {
> +		/*
> +		 * The "decrypted" flag being true assumes that
> set_memory_decrypted() succeeds.
> +		 * But if it fails, the encryption state of the memory is unknown. In =
that
> case,
> +		 * leave "decrypted" as true to ensure the memory is leaked instead of
> going back
> +		 * on the free list.
> +		 */
> +		ret =3D set_memory_decrypted((unsigned long)kbuffer,
> +					PFN_UP(size));
> +		if (ret) {
> +			dev_warn(&channel->device_obj->device,
> +				"Failed to set host visibility for new GPADL %d.\n",
> +				ret);
> +			return ret;
> +		}
>  	}
>=20
>  	init_completion(&msginfo->waitevent);
> @@ -545,8 +548,10 @@ static int __vmbus_establish_gpadl(struct vmbus_chan=
nel
> *channel,
>  		 * left as true so the memory is leaked instead of being
>  		 * put back on the free list.
>  		 */
> -		if (!set_memory_encrypted((unsigned long)kbuffer, PFN_UP(size)))
> -			gpadl->decrypted =3D false;
> +		if (gpadl->decrypted) {
> +			if (!set_memory_encrypted((unsigned long)kbuffer,
> PFN_UP(size)))
> +				gpadl->decrypted =3D false;
> +		}
>  	}
>=20
>  	return ret;
> @@ -677,12 +682,13 @@ static int __vmbus_open(struct vmbus_channel
> *newchannel,
>  		goto error_clean_ring;
>=20
>  	err =3D hv_ringbuffer_init(&newchannel->outbound,
> -				 page, send_pages, 0);
> +				 page, send_pages, 0, newchannel->co_ring_buffer);
>  	if (err)
>  		goto error_free_gpadl;
>=20
>  	err =3D hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
> -				 recv_pages, newchannel->max_pkt_size);
> +				 recv_pages, newchannel->max_pkt_size,
> +				 newchannel->co_ring_buffer);
>  	if (err)
>  		goto error_free_gpadl;
>=20
> @@ -863,8 +869,11 @@ int vmbus_teardown_gpadl(struct vmbus_channel *chann=
el,
> struct vmbus_gpadl *gpad
>=20
>  	kfree(info);
>=20
> -	ret =3D set_memory_encrypted((unsigned long)gpadl->buffer,
> -				   PFN_UP(gpadl->size));
> +	if (gpadl->decrypted)
> +		ret =3D set_memory_encrypted((unsigned long)gpadl->buffer,
> +					PFN_UP(gpadl->size));
> +	else
> +		ret =3D 0;
>  	if (ret)
>  		pr_warn("Fail to set mem host visibility in GPADL teardown %d.\n", ret=
);
>=20
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 4a01797d48513..0d969f77388ef 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -182,7 +182,8 @@ extern int hv_synic_cleanup(unsigned int cpu);
>  void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
>=20
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
> -		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
> +		       struct page *pages, u32 pagecnt, u32 max_pkt_size,
> +			   bool confidential);
>=20
>  void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
>=20
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 23ce1fb70de14..3c421a7f78c00 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -184,7 +184,8 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *cha=
nnel)
>=20
>  /* Initialize the ring buffer. */
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
> -		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
> +		       struct page *pages, u32 page_cnt, u32 max_pkt_size,
> +			   bool confidential)
>  {
>  	struct page **pages_wraparound;
>  	int i;
> @@ -208,7 +209,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ri=
ng_info,
>=20
>  	ring_info->ring_buffer =3D (struct hv_ring_buffer *)
>  		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
> -			pgprot_decrypted(PAGE_KERNEL));
> +			confidential ? PAGE_KERNEL :
> pgprot_decrypted(PAGE_KERNEL));
>=20
>  	kfree(pages_wraparound);
>  	if (!ring_info->ring_buffer)
> --
> 2.51.0
>=20
>=20

