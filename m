Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC11DFCE
	for <patches@lists.linux.dev>; Mon, 25 Aug 2025 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756130661; cv=fail; b=ENe5Ywuz/puquv/3uu+X7UU2B7en170eFDJgfeONM9ZyQpI2tLMzKZn6IhN4PjobzmNnToVg95VbkMSQ7GNausmpxy4mbZML9tVYj/1ngcRt688017aoGQOy50tWu5CiBVJ+Rj8Es6P9S5Q66Ptcit/7fZC6Sjl+YMPU4GZuX7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756130661; c=relaxed/simple;
	bh=oSdJ++Uvet3R4f/50LOnQR0YYb0ojQ+nbBrfRsorIFQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jd9YShHeaaezzrlagOhgVaj9s1vegv6WRevaZQIxlJzkpqJ1ujC1rKjDl3fWNHTZzzO+X2ifLoEy8wsmGNOxWKN7XMRABpCjmcbqLqk60Tu01YV/rnw+mNLbmuwn5hCg+1jVsZAuobOdnJ4jgBn+j8J3oR7GUSYJv9zPPmPx85s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uATVV5qS; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uATVV5qS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rdLTageCccUOsxyCZzHk4oGgq7kbjsN+vl7NjVWNqxPKzv+tRqUi5dYJszJUUTHXjpbvcaXpA9m/GGGCRNVQzhzOk5aQIv06HLP+mdi51KX3sGVns7GewGX2AQ7DloED9xam6sPgWMZkS/jJKXKgwpIUSJDMxlguKU1Th/t+Zdm/rqqJKTTBOjshXIMN2A5T533NO1CTth4nyh3zCD5bwGob9X++euzffA9YA73HvEkyjSKJZIb38Ct8dIXoIJruItE9l7DBLNVaayXEBIiCGjTwdvFZhJZXAESGocU7mDlpuIkEuhYd28+tAQ8KAC8S+c/kzdqBhOlEnSfcHToCnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DE4y+yoCy8yD2ZFUfqQqksz4b0dZC15B4RRTxFhFK7s=;
 b=tGuo4pUolZfygxiXk4hu4whkxOFtNGSMa0Peb+Y6fqTq5EDkyQwDe7/fyaoQHJLZ8h/092RHm9QlaP+peSHByTgzFHqNcURjeh38ULuQRmGKAwl1wywwh6Y2suzIgesRnFjiGVNWKOmN8hy+ru/grZhD62tufyJRwrZGmdVptUj1BIdv06F6qpAAX+pyWwJIeqf8wsdvCOec+tF6OyEu86khdsH6udVhzEk9Tg2MQpdIUNdYciVd7TR9TjKWvKH8K5LaciOo8y4GmhsPO28H5tDr40tmYdpPfImrFOfUSbQc9uTWuHxajIEU8ZBQTZnn0qD8zl0Kl8aEaGyiuadS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE4y+yoCy8yD2ZFUfqQqksz4b0dZC15B4RRTxFhFK7s=;
 b=uATVV5qSen7DkjdB1frA19E7D+Vz4Tfgz0DTuV2KySQDq7f9Nd0UIkVnOSsWZKqhxtL70yxNbsnLISksABJpP3sqCTNXpUVXiVv426q6iOkNuDk45UjFajae5lespylA9o/rbtUkGqXQRcvUio7tojKr6V8g+fNErhbGcB29aAo=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 14:04:12 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.9009.018; Mon, 25 Aug 2025
 14:04:12 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Xiao, Jack"
	<Jack.Xiao@amd.com>, "Gao, Likun" <Likun.Gao@amd.com>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map bo
Thread-Topic: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map
 bo
Thread-Index: AQHcEEnoeq/66jWdO0Wo0/qavEppfrRzcRIw
Date: Mon, 25 Aug 2025 14:04:11 +0000
Message-ID:
 <BL1PR12MB5144F2E3EB31673E0B78B8B7F73EA@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250818124505.781598737@linuxfoundation.org>
 <20250818124524.452481295@linuxfoundation.org>
In-Reply-To: <20250818124524.452481295@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-08-25T14:02:09.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DM6PR12MB4433:EE_
x-ms-office365-filtering-correlation-id: 365e4f04-13f1-4854-3b24-08dde3e044a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Qb6nsjR4duajPUC2GW/CFZxyvqzI+a2lAZZEXp/eZGLPOU5IJh77gy4IxU1Y?=
 =?us-ascii?Q?EghydEYLDFPg43ndJTGlD/x0qQXql0iVMwJpaUBsN4MWYmUFpe2YXDuYFasG?=
 =?us-ascii?Q?mSGxcTfWIC4LLjMYa8FATiik+jh8vPRTZ1LuryvozyIEiZiMezYRTxuhm1EX?=
 =?us-ascii?Q?0G4Zm+UwGyI4vpOG21eBcYzXI+lrinT5BKQsYMlHkMOGVxE7aXLnyXLdN15E?=
 =?us-ascii?Q?246c4kBJeAZvVCKpwGymh1gKLLASbmN4poGeKqFh5vJ24ZYi1SMj4neDvPyd?=
 =?us-ascii?Q?qrR4CiB2qygRKAoUF8yOu4axtcOzbX/ARpc6irLk9hv+Wu8PS9msAgG6wJ1D?=
 =?us-ascii?Q?uKCYRNB2qrD85/c455ZC6orPOxZYsMX4Ragtm4z3r1pjJmxvErRkQzbY1c59?=
 =?us-ascii?Q?zclR2KShb6yiX0L+H+W1CUuU1CAAiUfMJ/eVx0epHEu38UAIboTKgFfAo5zk?=
 =?us-ascii?Q?8WGRerhSw/Gvyv7rmthHlXC2kS4vMPfm7R+qQrxS6wSXFHR5dxjiuj7P/JSk?=
 =?us-ascii?Q?64NfmRPriHhw9t3HGQi2RLZwGJmR4IjxzdnBXoNXd1ZhdY/1apaDsT8qa210?=
 =?us-ascii?Q?hAl2odawyZsgxT1o5ltGXUlHv5Ef+cLFqJQ6wQakyExHGntJPb5SZkb/kXEI?=
 =?us-ascii?Q?2W604LTrEu0eyTnUeIuvdUQ5m79Fpu1UYyFC0cRyZZb0ocqzWXDhy5yGQ4PL?=
 =?us-ascii?Q?g/RI52Ckjdh85PBs5i7i67afnuB0xF/C/ZuhnlOBoe1Wcb9K7+3ZiAg0m4Mb?=
 =?us-ascii?Q?lNuuhnCMppZXraYy9bscp8c+D4Y0jFUUP+5n1YGwMFudtZcV4Jrcya7ZX3IW?=
 =?us-ascii?Q?KM1Prx1SpPzgQMRiPu6HREY/O/ta4LAbggpBI6L5BG3YrXXD+uo4kqjdh1kh?=
 =?us-ascii?Q?zCy4TSvmUUhIipiqhY+MvLK9PxJcxfHHIjvgthpTPObBL44mgykywsupUk0D?=
 =?us-ascii?Q?v5mYG7oHZE3TerTWBk6pnCQvMnC+y6mDOmbo3yvL9Dv8YkNfcE24CO4HVpt4?=
 =?us-ascii?Q?oNJzdhoiGCt+jGGaK8ga1uI0hVbN/ipBJ8dXyUGQxWe6AO6vZSIgVQk6ycyN?=
 =?us-ascii?Q?ysDNSFi42uNJzALf1N9+das+lSg7cHBSVIQSV8UaDmUUNke+k89bUbFSOwo3?=
 =?us-ascii?Q?Z9DHtfHil65QxRqqV9kWa9R7rvSyj2Fi8A1Xu4z1zBhbG1cxq9QGEnjsNaSo?=
 =?us-ascii?Q?YRW04I9MwgvGSKFfiKMOCqBigXRK1H0n+W1BowqniFm530qB2N7kPmZbU3Qj?=
 =?us-ascii?Q?2Qt29QHWPWOI1A0BFvTMfWh6VJFOhwwo2/dUyp5UGc+iPCo2Oq7nIOr6xSNO?=
 =?us-ascii?Q?qFXh1PDs7YhN6LuMe8rZyFo08O4dEttXFed4mhrSYswbG/Sx/6HJCt+m3+uv?=
 =?us-ascii?Q?0z74LjeTMgIcpZmAoMvwMBLTFgNj3VUanJQ1T0juwHGyKDeYf+AEiVw/1sTt?=
 =?us-ascii?Q?NznMpkRh/p7wTBMn4R8JwvhcGwiSJGyc7zvlUpebiYGIJehm6lpjAg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?q23eNiXRXRD7HtcAGHYZ6jIRhVmWqWaLmZZzUm9ALP3SGmXYyNJ+rXOayUuP?=
 =?us-ascii?Q?IeJ0WpLqFvi4WfrPJlYiSK1jKdGbaRwFMMtMGQL+qFdXMI5CTuZDw9OQ4ZGa?=
 =?us-ascii?Q?aHOa1bhsYiRj66c/VkY0qukfCemD7/ptT5pRTfSW/W8h1d8hGPi7pBVDVu1V?=
 =?us-ascii?Q?OK1nM4P/C72f74x7SAndttfUhU7gOZBW9Ny06pBCOBUseLFkVohcKjN8zIZt?=
 =?us-ascii?Q?5OsBs1YYBSFjikzZ1PzeZgfjUn5lkppj9mZry2psbAlLGmRJUjK9jf8m/Ya6?=
 =?us-ascii?Q?y8m7Qee1xIZxh1tBtppZIbW9xm6LsD058tQEiyfsgnJST7sj9ncuiT5xA0Ty?=
 =?us-ascii?Q?UNfNyxXGw8nbVdkKs3azcIkPVESnIu4V3dI3rfKkIS1mv8w6pF0cvZ6+OUNa?=
 =?us-ascii?Q?znbhZxVsSYE5g1cTbz+exViPTHvU5e+2hMbTOzd8bN0cCMzXg9pTnhE8dZUN?=
 =?us-ascii?Q?7Cgh0t6r+phXsGJDDD3RTojDxyJUG5RtQe6/LMIBzjA9qh//f6iud4BvRTv3?=
 =?us-ascii?Q?r13G7hlhi3Bz5Ggi8A3Au2xrjT6jzThAbJj2NBoJpt16+G+Uzb0wbYIbM3BT?=
 =?us-ascii?Q?MSOg8bZSMxiFHiUgv51choGGjL+DEYofUsY8SD7jXUHzlPELPxc3DCWqaU4G?=
 =?us-ascii?Q?/dr8a8me3XGPB08BluVHLPOcz2mWqpBKJjX2pGjIPrq5vrwULc6L70gupens?=
 =?us-ascii?Q?/uDR5+3eGD498YggT1ZGXyLbYvbr9cY1mhqYTZzhTdPHwPd7CI7s2y2EgFcP?=
 =?us-ascii?Q?44bg1KI55ldciRxISYhZSo9vsIRAtVcoqRVCd1clsG0y0YJYuyvAmdqs2qJG?=
 =?us-ascii?Q?EYt/JT10LmUoE8vBLOcikOW9Wd4VSiAfz1cQ5sF/5jRkEYu2pBOs5vZ2ZBB/?=
 =?us-ascii?Q?6xHKUS+OriRWN6+I23C19d71ERgoN1pVyiOFppj7eoW2xeojTb02GnupzmZA?=
 =?us-ascii?Q?oOkGTpa8VjbnnOSfKmYiPmyM6JkDIwvkJoCGJXTy6JnsLSYm4EImZx7Ss+t+?=
 =?us-ascii?Q?XL1SAT7wi9B9KnvDQmLIEwx/TEtVfBuv5U2Y8wu7u3rIUPN7OiMhbs+uGQZZ?=
 =?us-ascii?Q?bBV0FuKadp7T2jgKM+D4j+HjvNpH6lIoLaPE7nnswHY18SDFQe4wRYDYFLlT?=
 =?us-ascii?Q?QX3+mqjh0trXDulhKPd3+H9fP9gi0F79ZaMGIR1Hk3G9O3EjD3wcC8n1S7R6?=
 =?us-ascii?Q?7ap/sEatuGr4tiYa/iqr4tlYbm0pevqA7wMmssKqcAD1ksCskIzFSMVTlbTi?=
 =?us-ascii?Q?jP1oAdH2o/ls3H7FnTnndrpvbOIGCZuAaBGKTLKUxHJCXglsZURwSx4QCnIF?=
 =?us-ascii?Q?O6mSQ5dcryisjtVXZ8f6sE20SkYTucbe4h9ESST1dLJK9J6mNKk3CnUQehXS?=
 =?us-ascii?Q?ekvjQ5aLlW9w021am/9aUFp0FMsQ5vPAfLj0ng2rPLeMjIMqdn1wgA7B5gC5?=
 =?us-ascii?Q?a6A3DIaHSumMsN9E/QP7v28E6JiP+Fdco8YUuDuhf8wbTERfAovBMCtOvksc?=
 =?us-ascii?Q?AP6seyewqGUvakHiuDK1JlnPILH2XdAlwsAX6EqHz6QHaOfomNWuVxHv9oEL?=
 =?us-ascii?Q?44Onpr5l0qrtqB2Lum0=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365e4f04-13f1-4854-3b24-08dde3e044a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2025 14:04:11.9734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UBarTedUvXRxn5ngYcp8CkvzJGo/0vlhAE/ybez+3NgXN6WYjLT27dmyOB1Ogf7ZeSJzMx6Vyg+36YJaZMW14A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, August 18, 2025 8:48 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.=
dev;
> Xiao, Jack <Jack.Xiao@amd.com>; Gao, Likun <Likun.Gao@amd.com>; Deucher,
> Alexander <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map b=
o
>
> 6.16-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Jack Xiao <Jack.Xiao@amd.com>
>
> [ Upstream commit 040bc6d0e0e9c814c9c663f6f1544ebaff6824a8 ]
>
> It should use vm flags instead of pte flags to specify bo vm attributes.
>
> Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate file"=
)

I accidently tagged this with the wrong fixes tag.  This patch should not g=
o to anything other than 6.17.  Sorry for the confusion.  Please revert for=
 older kernels.

Thanks,

Alex


> Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
> Reviewed-by: Likun Gao <Likun.Gao@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (cherry picked fr=
om
> commit b08425fa77ad2f305fe57a33dceb456be03b653f)
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
> index 02138aa55793..dfb6cfd83760 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
> @@ -88,8 +88,8 @@ int amdgpu_map_static_csa(struct amdgpu_device *adev,
> struct amdgpu_vm *vm,
>       }
>
>       r =3D amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
> -                          AMDGPU_PTE_READABLE |
> AMDGPU_PTE_WRITEABLE |
> -                          AMDGPU_PTE_EXECUTABLE);
> +                          AMDGPU_VM_PAGE_READABLE |
> AMDGPU_VM_PAGE_WRITEABLE |
> +                          AMDGPU_VM_PAGE_EXECUTABLE);
>
>       if (r) {
>               DRM_ERROR("failed to do bo_map on static CSA, err=3D%d\n", =
r);
> --
> 2.50.1
>
>

