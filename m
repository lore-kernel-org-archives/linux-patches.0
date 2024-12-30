Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF1A19E83E
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574696; cv=fail; b=J8axt7bcOzb8GBNY+o0jg4nFcntUp69B2dav/M6SVZmNo2j2jaTkNDHc34JdyVZkgAbDirzrLlC0bEUaS2vgS9l8Jcbb1U6C+qTlTvlurIKcO6au+7+V2LBZlX4aaZ0k3r7UNJFQbJBXieCGffcbN6fecPSx5U3SUhIqcVkwtsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574696; c=relaxed/simple;
	bh=tCmP1hgNmtDkHT7cWsbbcoFi4idcE2mTs+l+/18xvAE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FaTbn87nwhTITS+QRKRgXuvOxY3Q+mCfbtm7K95Vy7Z9OWEE65eSAypcNh/AxwEwpTi2cdqFBaXfwrg9ssqN0eN+TGXO50gAFpL4EqjVZxj0tSOgdsTNV4ivawWu9JU5cX7TYLsZk1PBBS32UkYXeA7KqeDWtcmCym7+WKH0J+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bEEbFIcQ; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bEEbFIcQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXnftSdt5Z2Zepvl6bz2oEIvb6eOy6nNafqArGmf6H+1DF166JC7vhOLT7VjmZsOyPgFS56nf/9BPDjKdobsqYG8WLPHWQGp8Jrns0kJ4kVk8kIURez6asYfCC+IRT4O3LXxlORiwSDgdnEiDSoTOmfJYTsJfs6WydMh6zvK12r8G95lTXtTO3LW6bUUvjiV8TRAb6Lj2xzLF//zZpEM4irBn8go5eRXDPhD1Pgn4kv4tV900LIxTgTUAvEFQnKMdr3jjdgvvQXrV8GBzt1G063FelmmTRACGcE7O4piRqtXSQ7mfH9rQsXEwV9w7fvLQVDrF7HrwnP2eUk7yvQ7Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCK7ZTXMoYGL8SXsQvkZyI25kve4VCDmjCb5EcBLx/M=;
 b=EwpVmbXU3lWDjG1VQg7cyb/bESBeV2zamb+S3Jd9BqLXZ9KooApg7IA1X7Klg0trDrO+LkIFb/BdzenAtZMPlKXGrgMlR28wQ7PvdSeoFfpkiC4K0IagB9qC/0npOZWTrgiLiYaVRBXpqPRXTZaUCZ8sazjCPEtyOEzyYOeUeBKaK4+NgWLQJO8vpHZfCmeBHMHrNivJSlaAYHHjQrcnA9kbLjdMJ2YfVtd2thuBNf+Y3pwSO2jr6eTz9NkaZEV4GV/qtUtrDdajEKTIL7AWfX62z8QCIie6wSIiScd9LbIhE7rQt1rCoH3ZAdDEcx5+fwGUzDzJi4fsUA0MDNlGOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCK7ZTXMoYGL8SXsQvkZyI25kve4VCDmjCb5EcBLx/M=;
 b=bEEbFIcQ4zIKwgtIczSdwA94rD+etFoBfna2I6KAtDg9zJfLylrbczimBI8h0kZNdny3VsHL3/J2SF5cNjyXNb3gDgbZWcmZ+dYTnbKuA+4Ccyx//8lJ5qIYoVwKOhtFF9BhayHQ2HOqf+Sl5TrkeTO9+4llTZcRJaDfnIh6wLE=
Received: from SA1PR12MB8599.namprd12.prod.outlook.com (2603:10b6:806:254::7)
 by DS0PR12MB8246.namprd12.prod.outlook.com (2603:10b6:8:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Mon, 30 Dec
 2024 16:04:48 +0000
Received: from SA1PR12MB8599.namprd12.prod.outlook.com
 ([fe80::25da:4b98:9743:616b]) by SA1PR12MB8599.namprd12.prod.outlook.com
 ([fe80::25da:4b98:9743:616b%6]) with mapi id 15.20.8293.000; Mon, 30 Dec 2024
 16:04:48 +0000
From: "Li, Yunxiang (Teddy)" <Yunxiang.Li@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Zhang, Jesse(Jie)"
	<Jesse.Zhang@amd.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.6 71/86] drm/amdkfd: pause autosuspend when creating pdd
Thread-Topic: [PATCH 6.6 71/86] drm/amdkfd: pause autosuspend when creating
 pdd
Thread-Index: AQHbWtLBSCwR1K8lVkOEjStOu2H3VLL+8WJA
Date: Mon, 30 Dec 2024 16:04:48 +0000
Message-ID:
 <SA1PR12MB85994AA4E100903782A2C8EEED092@SA1PR12MB8599.namprd12.prod.outlook.com>
References: <20241230154211.711515682@linuxfoundation.org>
 <20241230154214.412434784@linuxfoundation.org>
In-Reply-To: <20241230154214.412434784@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ActionId=f5ddb4ce-3c86-4fb0-9918-6e0579f3d501;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=0;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=true;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2024-12-30T15:57:31Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB8599:EE_|DS0PR12MB8246:EE_
x-ms-office365-filtering-correlation-id: bb0f4352-9190-41a2-3d45-08dd28ebaf5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?LjHX4twAaLRGuSwoBibH185QfEgqjPJ7buIiGRA7m9h1OR3hHnBcEZwF6UJD?=
 =?us-ascii?Q?rxvNNl5t+ljut3wrBKra/cT3+d81kk5u1Syuqia4bxr3T8heC+1SfEsu/WsF?=
 =?us-ascii?Q?AgUS9QCg4RaxkIxTIpa7/IxaL9Smmg8et8hXjO4qKXkkpC07Cj9rs/09H1+d?=
 =?us-ascii?Q?SBfIOPFo7ff3Q8c+n8/Z3G22bChqMugJ0VUavqu6500E6MjKf6m5lHbDiKZ8?=
 =?us-ascii?Q?p0+qLU1oFwE9JA7ExcIY4wfc3VLY+a2pLk4KPB7K7vT/U3Tll8PK5Lf7Ih4F?=
 =?us-ascii?Q?nNg415OkfVBzHP6uyH+KM74L8c0i9Uex9yn0UpQstOcR/qb12zOtkykcawfA?=
 =?us-ascii?Q?RsGpvPg4OD+dNKvbtNIPH6icCQuvZSIWeVTec4RRbdpjnMkLTt/xICP6A3Js?=
 =?us-ascii?Q?hv4PB3EezXdPazpXmlapqjCD2o/B9QLpJHcIU6uq1J2yzRzpJz38mEh/PNtV?=
 =?us-ascii?Q?kVYjNPS8+rzeiZuCEcyRnxQqxzZJVSub46wJj14uLDusEc+nJ/VNvHA9XBwx?=
 =?us-ascii?Q?1tnk1QcHhaaHchomF3Wg2+7fKr/NuCfBgPlLexjRrDKYdqzWb0lHsCu099da?=
 =?us-ascii?Q?tJ2W77YDFyrp25MQ3FckpBtFZvHmKkQ9FJnYN86LatILeg8/iPD83VsQrVO+?=
 =?us-ascii?Q?Hge8aszbqRGv4/+tYBBzcm3fAlt3BXBDCjjcPBy4tCiGcQXl6SpbRZaZMRvB?=
 =?us-ascii?Q?higCxlKh6g9R42iHER4t4rv5brsTAnxP2MuDnd+kH6KZjH8eXBJg2VK8HiHQ?=
 =?us-ascii?Q?nNOkx0M5pcp7kg4AurCGD/VAy+NNFFiYxUvYkiShmJTjp8kAkxDfRDbNS3yu?=
 =?us-ascii?Q?ZdaN31S3H043SWI6O/8N5gp05/cpv4Mfklqu4/zVi9o31B7dMBbVsTbPkQWS?=
 =?us-ascii?Q?chWYC5Z54hKZp6zDKK58n00iqxXR1tCsP9PZCf3S1Mkk1v3xZm/3wxkuT+kW?=
 =?us-ascii?Q?T2NUg5SAl5WYtLx5fnCq+SdLtbjXmttUaZXaR+avhBrSkQESt2YT7fbWRlL+?=
 =?us-ascii?Q?u7/rlUWXJEAti6J44xNBax3WLJHSzeIAV9lTSDaDVrZMNCbtjpdvwRokGCMB?=
 =?us-ascii?Q?ViG31bKPHWi0BHcMQ1dQp1oIa/1LWAoZgoiSQMtp7aJQ5zn8mNqU1co8lwxP?=
 =?us-ascii?Q?S+yDqiHe8v8rHsEvWnYJN83kheCjP7j2L+lJiT6Ka2Zyu6L7LzYfbo6obfqY?=
 =?us-ascii?Q?1w3iFuYusSXTeT0DRQv+CimHKS2MhBOLKM+BgtngDzsaz7PTbIXCDtM9mB3S?=
 =?us-ascii?Q?bs+uhbE0cTb+R5gnXGwzj6giYNvrJt11sKQlZdqaUj8EV48jUX7V0bzK2wn3?=
 =?us-ascii?Q?aXsMN8N01yuhcD5j6aEHSaBspqCJdg5MOTkVdag9ghy77jpoHvQjPjYqs33Y?=
 =?us-ascii?Q?Rpe33TtdvBWpr6Q+L+gAYL/8XDfUcafrPI6T0JjVL63kK/BaFA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?C/fZG8+hgVoXH/CD3EKdpEbmXy+AV2sX5di2GZwycqofQ461Qwq8itoL6ad7?=
 =?us-ascii?Q?V9TxLimB2r5uvZw60UFI1/jwXqULVwKTkLygJXgbUbR8pWGGOkXZ35Lv/DjZ?=
 =?us-ascii?Q?0aWioFsu2UCM7gQPX7gkvlhVJbk48+1QaL1xIWllWo3W3Nb9VVbQp+ALdl3h?=
 =?us-ascii?Q?urGvwDFMtX+v8OmacmURrCSzA6thiNv/5uZSY2CJSo9k0MChvO5PoGjaac/p?=
 =?us-ascii?Q?VAGzu4imRYUXFmP0zeGjpwpjxJqmJoG5BRK3L1MHbBJ6fxjOxgyLjJ8KvHrC?=
 =?us-ascii?Q?oTNgoydpLKncknne78wT3EKqUexH94uuCUVnyDujOufdt3kO3JC4381OkMTA?=
 =?us-ascii?Q?zmPwFHnkjP1xENIoy/OLn6w1tK9nVhFg0+FRNdvauLrJCduymvPNLkUzeWPd?=
 =?us-ascii?Q?VW66X4QTHcClDXuFtsVOIXdaaf0urc7UbAdM5V6++OdVog6HEpNfStQUFWAg?=
 =?us-ascii?Q?w1ZgOkP8zfK5f1d4xOUZgIF7vJ2EyZEaf6Ld+/HKG8rbUKiW0fAxKRNeE1l6?=
 =?us-ascii?Q?uMDy7DMt1jzN87gFLNnaq0UDBH33awEzjo8LJZcqe7uRTNah8EN3wTuI3HAH?=
 =?us-ascii?Q?hj7ImTUQMKnhqOjnteuuoxzvJHiSVKOytFnTnocZAUXnwPj09gBY3GnaEM6W?=
 =?us-ascii?Q?X7bPu1Uk+3NRMUVzT7QYHTGrcH7GemHVYYc3v0GPf+ER/4QSE/vBJxgKu2X3?=
 =?us-ascii?Q?jey0qj39SUqaWyiKklCvy/ROmk7ioW7RVpmM9xFO3NkVzgOdcvWxOiiB8BSx?=
 =?us-ascii?Q?sW45M2zZd73xFyi4yyNbtkHyZP/fHCGTa1/X58KBPwZ4pDiz6wxXKpJQYTWJ?=
 =?us-ascii?Q?HlTiY39Nzbv7rYwaqeJWBA3PFMhf5SWGJdXH6Sk4k/Q6b1g/7fLmVy26x17T?=
 =?us-ascii?Q?hcQC6L0ezxxwCDM2ykCgiKvttg9H8vTO5OT1rwQ8x0L1UP6ZOMlgjOs/9TRY?=
 =?us-ascii?Q?vBAZmQgPh4sP4JhuAk6P2lnIhUSMONiAa6Gn8WpO0pgqQt8tQJCrxjhFh9e2?=
 =?us-ascii?Q?NnbAp+lPbhU2pLr9U9H8WYsJ5s5l3fbDaijq1HHLG2IhNkLgBC8LG1Wbzz5D?=
 =?us-ascii?Q?b/T1uzz5U0Ud/GnAw+Wl1f2/D44q7SiCZUTgC9Rc1Ipr9912tdTO3AJRRt7E?=
 =?us-ascii?Q?qbNQirrn+bN/SxqOajUmlnzagyGAMtdlu8v0OMzs7oHKkT5/zKI5khMUezxt?=
 =?us-ascii?Q?RzkKnFZzF/oDLRVwozRogWnp1tW3pOzF0bwJ3AWg3e480yVtMViIMrzJxBrP?=
 =?us-ascii?Q?AmrKFkHgZC0tAXwaQ4Y+f8Um+RPp6NII0XLG36BibttktpR9uu7/qtbPfwxv?=
 =?us-ascii?Q?wEupaW6+bKuMhazZjnu7khn+mS9BhCH+eMc09kehwKUTTnpV/uWI7qxfeL9z?=
 =?us-ascii?Q?k1Vhpxo4HRk1NcqO4i5gSm2Z0P+06YWDPHbAfjcpnkhoLRKdy+RIikHZ9PsU?=
 =?us-ascii?Q?Mf8TMcBX0TygT3SDnWl60nCZ610u3NxjDckVSLdbyg5JGCkC4EO+g/M+LkAd?=
 =?us-ascii?Q?6bQqplgV6TYLfCWW2MsLRGQj1O073uHnXq1pXKyOuKfHT9dkPU+cZ63zRMf4?=
 =?us-ascii?Q?soeTAvYIMimOWgpRK10=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8599.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0f4352-9190-41a2-3d45-08dd28ebaf5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2024 16:04:48.1042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rNOUbjy8fd8KCIOOavgHcom22gPkcBZivrfltcl+yTNYX4fvbqui6rKsoIl9rNO7m66Tj5QNTzpsaQpgMW3sOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8246

[Public]

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, December 30, 2024 10:43
> Subject: [PATCH 6.6 71/86] drm/amdkfd: pause autosuspend when creating pd=
d

Hi Greg,

This patch caused a regression, fix is pending here https://www.mail-archiv=
e.com/amd-gfx@lists.freedesktop.org/msg116533.html

Regards,
Teddy

> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Jesse.zhang@amd.com <Jesse.zhang@amd.com>
>
> [ Upstream commit 438b39ac74e2a9dc0a5c9d653b7d8066877e86b1 ]
>
> When using MES creating a pdd will require talking to the GPU to setup th=
e relevant
> context. The code here forgot to wake up the GPU in case it was in suspen=
d, this
> causes KVM to EFAULT for passthrough GPU for example. This issue can be
> masked if the GPU was woken up by other things (e.g. opening the KMS node=
) first
> and have not yet gone to sleep.
>
> v4: do the allocation of proc_ctx_bo in a lazy fashion when the first que=
ue is created
> in a process (Felix)
>
> Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
> Reviewed-by: Yunxiang Li <Yunxiang.Li@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../drm/amd/amdkfd/kfd_device_queue_manager.c | 15 ++++++++++++
>  drivers/gpu/drm/amd/amdkfd/kfd_process.c      | 23 ++-----------------
>  2 files changed, 17 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
> b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
> index 4d9a406925e1..43fa260ddbce 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
> @@ -197,6 +197,21 @@ static int add_queue_mes(struct device_queue_manager
> *dqm, struct queue *q,
>       if (dqm->is_hws_hang)
>               return -EIO;
>
> +     if (!pdd->proc_ctx_cpu_ptr) {
> +             r =3D amdgpu_amdkfd_alloc_gtt_mem(adev,
> +                             AMDGPU_MES_PROC_CTX_SIZE,
> +                             &pdd->proc_ctx_bo,
> +                             &pdd->proc_ctx_gpu_addr,
> +                             &pdd->proc_ctx_cpu_ptr,
> +                             false);
> +             if (r) {
> +                     dev_err(adev->dev,
> +                             "failed to allocate process context bo\n");
> +                     return r;
> +             }
> +             memset(pdd->proc_ctx_cpu_ptr, 0,
> AMDGPU_MES_PROC_CTX_SIZE);
> +     }
> +
>       memset(&queue_input, 0x0, sizeof(struct mes_add_queue_input));
>       queue_input.process_id =3D qpd->pqm->process->pasid;
>       queue_input.page_table_base_addr =3D  qpd->page_table_base; diff --=
git
> a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
> b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
> index 577bdb6a9640..64346c71c62a 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
> @@ -1046,7 +1046,8 @@ static void kfd_process_destroy_pdds(struct
> kfd_process *p)
>
>               kfd_free_process_doorbells(pdd->dev->kfd, pdd);
>
> -             if (pdd->dev->kfd->shared_resources.enable_mes)
> +             if (pdd->dev->kfd->shared_resources.enable_mes &&
> +                     pdd->proc_ctx_cpu_ptr)
>                       amdgpu_amdkfd_free_gtt_mem(pdd->dev->adev,
>                                                  &pdd->proc_ctx_bo);
>               /*
> @@ -1572,7 +1573,6 @@ struct kfd_process_device
> *kfd_create_process_device_data(struct kfd_node *dev,
>                                                       struct kfd_process =
*p)
>  {
>       struct kfd_process_device *pdd =3D NULL;
> -     int retval =3D 0;
>
>       if (WARN_ON_ONCE(p->n_pdds >=3D MAX_GPU_INSTANCE))
>               return NULL;
> @@ -1596,21 +1596,6 @@ struct kfd_process_device
> *kfd_create_process_device_data(struct kfd_node *dev,
>       pdd->user_gpu_id =3D dev->id;
>       atomic64_set(&pdd->evict_duration_counter, 0);
>
> -     if (dev->kfd->shared_resources.enable_mes) {
> -             retval =3D amdgpu_amdkfd_alloc_gtt_mem(dev->adev,
> -                                             AMDGPU_MES_PROC_CTX_SIZE,
> -                                             &pdd->proc_ctx_bo,
> -                                             &pdd->proc_ctx_gpu_addr,
> -                                             &pdd->proc_ctx_cpu_ptr,
> -                                             false);
> -             if (retval) {
> -                     dev_err(dev->adev->dev,
> -                             "failed to allocate process context bo\n");
> -                     goto err_free_pdd;
> -             }
> -             memset(pdd->proc_ctx_cpu_ptr, 0,
> AMDGPU_MES_PROC_CTX_SIZE);
> -     }
> -
>       p->pdds[p->n_pdds++] =3D pdd;
>       if (kfd_dbg_is_per_vmid_supported(pdd->dev))
>               pdd->spi_dbg_override =3D pdd->dev->kfd2kgd->disable_debug_=
trap(
> @@ -1622,10 +1607,6 @@ struct kfd_process_device
> *kfd_create_process_device_data(struct kfd_node *dev,
>       idr_init(&pdd->alloc_idr);
>
>       return pdd;
> -
> -err_free_pdd:
> -     kfree(pdd);
> -     return NULL;
>  }
>
>  /**
> --
> 2.39.5
>
>

