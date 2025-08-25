Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC30C1D88A4
	for <patches@lists.linux.dev>; Mon, 25 Aug 2025 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756130683; cv=fail; b=PrVnvkk53CQ7hp4dvy2YsbVRPZ64v+kXBR6xLoWjulpdNUHgrFwNvIMpH9/Fz9VbK8zTLHXbZYU/BJZlvZGpWDVQ/O9LcnnEYbUUAy3krLo4IQyflI1oKNYNdDp246NJHDuu4VqioeQXQ2kfmUkO8hC9CKBxVPhDjkP0qwBybjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756130683; c=relaxed/simple;
	bh=1Debj3l6jfuP3bpXHDQsDvfhAapZe7g2R8c59qmAOJE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tfRgMgTMkP/HQ0H+HEuaGKjkndT3jsudi6zk2WozxMBnSnUvuDq5eI0OT6epkTGPlQHL2dkgDfYUITw+axGXxGNkUoa4QpueMIWn2drMCDnVo72mvvgemDA9cq66H3JAC5N9etj6BbzRVV6PrdznEDOx/cfBwGyQL63oLOibK7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kyesxIBg; arc=fail smtp.client-ip=40.107.236.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kyesxIBg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iutz0rtkS6wOOQN74x5X5b3/EiaiEuh2HmpwdlVikd9bxQwFvfuCv8lV7fPa93FySMqAUS+9nrkr3/Z+pNqn5nHXfmbpS3vqCcUZ6zVOfI7oxSzsD76FHB7KLF8coanaD9u/HkAgNIhAbvu0FIiNZIxxrTMTyoBs7GZ6JnMaF0TGXJxQf9fNeS/NY/8AkqNFloLX/abEfaPX+rKmUW0ltGA/RE4UEdrh8LbXxRzoGUx/95hJ5QeD7+LYt2Cs/T6ADp9BxTNJ6kwFtzLDII8vaQyQjFiSfrgV5np8881GVeeJb2koMWVE1NaNa9dV/zpITGLt9oAKA8UHesL5mOF8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5V/1JMk60wDN8M7iJCAruGWgVP4IarjxOjPq3PrmUn4=;
 b=kBbvWAkggG4Muux5AnJH9IfVtCaWsp8jlEwtC7qGzVhKrUmKsm3bsiUIZ5MHDzFx61+95qtV8qYMj4siOsK1mBxEu9MEI4+w/1jdJv5uIaPHW0FGvHVGQn0RsEVL99vW2WShYP4hxjnQotdW8OHHb1mOBhMOtJeJai7XdN1TE9EDVZQM9S3phOXfGKNYv3Ru2a+4ZMmKM8pYdeVQqUkjylMLP6e1kaVA9V8ZmjUYszbzyYSY2EsTcchs2UQXztXkedjKgROK0oQEIy6EUf0KQhx8F301f1vijNbYFMQlC/b1B6wdgqk2dus4Fv8nMfBU0sBmBcQuScNeaSp8SCZfog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5V/1JMk60wDN8M7iJCAruGWgVP4IarjxOjPq3PrmUn4=;
 b=kyesxIBguqK4WvJ91PytC9+dto+XhhsFABSbm1ghepro5YoL9+toEnJV7pEP0vW+Xot4aPcuLCOvUPK80czgjyslxBqQKzgDEHhE+6qBlcRYgShwdLhHSdUnUWwOSAe+FiYjD1iLWWTzIj3Z6UfLJP2EuN6uvGlvqKMKnlsxeo4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 14:04:38 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.9009.018; Mon, 25 Aug 2025
 14:04:37 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Xiao, Jack"
	<Jack.Xiao@amd.com>, "Gao, Likun" <Likun.Gao@amd.com>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 6.15 438/515] drm/amdgpu: fix incorrect vm flags to map bo
Thread-Topic: [PATCH 6.15 438/515] drm/amdgpu: fix incorrect vm flags to map
 bo
Thread-Index: AQHcEEWtdZk3Yq8bTkqZwC+EGG1hyrRzcb4g
Date: Mon, 25 Aug 2025 14:04:37 +0000
Message-ID:
 <BL1PR12MB5144A729CC4218D2F6DCFE5FF73EA@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250818124458.334548733@linuxfoundation.org>
 <20250818124515.286695172@linuxfoundation.org>
In-Reply-To: <20250818124515.286695172@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-08-25T14:04:29.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DM6PR12MB4433:EE_
x-ms-office365-filtering-correlation-id: fb2913fc-da9b-4ef3-7f49-08dde3e05408
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ooxw8AJ2Yg7YeAHYSNmn5a0fflwpTf6JnGtVG4kuUt18L47Be+8zW0tX7KWU?=
 =?us-ascii?Q?Jc+jp/BwuHOu1yUYlZI39+uZv5KAZLSIQfcQxAf4fNmSQAOn0wPft7DzzKUk?=
 =?us-ascii?Q?Y+siBhWKsxcpOqqiQ/gkiW/Z0NW8okPtezOB6a//xETRUrKbHuOGhENvkYok?=
 =?us-ascii?Q?SphfF90O0vO1bdMvJYWupxuKjmgf3zyM00hOqcqg27gp6Q8190v1K7TUgMgu?=
 =?us-ascii?Q?4XHfyS/DZDtV7oTmLR9LLpnf1XQ21XhG5Vi1Cl8yAAqeTGwPBL4WhXjQpoxs?=
 =?us-ascii?Q?ozuamhFp9d4gvY16BM9ElSGG3f5xqldt4mZpZpJdnD0ozrsukl224a2Df1pG?=
 =?us-ascii?Q?lF/dQx0oFXG8N6fdJ+b4vjaKWv+6KiN+3DzidxLudqbFLVLhgVqWmWI4QhV4?=
 =?us-ascii?Q?udlzXhlmMP2jVYaTE/VDlbyZD2FSnjYxc/I6o4QFELOIN3mPSsaAVFvT6+JY?=
 =?us-ascii?Q?b2Aw2JbEGoodNiHQH26evXvkCo3n9K0mAhHcbBFWYo/2g/7dc4Go8Lebmv9y?=
 =?us-ascii?Q?3Q6oM6zmmbuuPHN9ly8IRoxJS3zTp1wdKDt9frlXayhVj+i4BjDY/Dg/uHkr?=
 =?us-ascii?Q?med6yZobqYatDDLuDH8uncxGGFYFwl6B1CSHc7YEn9ts8gPcVMw74kWJ5yMJ?=
 =?us-ascii?Q?5LAHCwTXR6ToWyUMJyNb/glo2BxXLPDT3YX8vAaaCwkAb5iRfRBRBLVuuIwM?=
 =?us-ascii?Q?mPrHvmJCBEljadNL5U6axOS1sv5JXLp/kmI5mNSvgx0wOlP5peEqUytLZVFi?=
 =?us-ascii?Q?fDJ3lKQ3MVyisx1Mk+2V/euqOjTr/G1xxI1zVhpPxw2raO6Mp88pPuP5HFoL?=
 =?us-ascii?Q?T1ZIPCvNnpiji7J0cGzwCYcCbX7hQfNtGnNyZRaY3lalou3EQ28PXXZhcvOX?=
 =?us-ascii?Q?Gt9qNhm1lWfYRw74mvoumGYT9jcKJvrrKSdm8ALDCkO7V67+ei5fjjCRMwkW?=
 =?us-ascii?Q?xpyAtI5xj73vE8cby10QsUOAkRU0UziXun7fDJpHgbt6JappxwFB/Z3sGQRS?=
 =?us-ascii?Q?KgnPAU1MszZBe9YT2Kt6vn/mdny6IgWD0uRxcH48Iv388xUMNi+HEgCChcfR?=
 =?us-ascii?Q?YUDNmKs1EMP6AtE9o7nVnyP/7qK3ZVr2r1q9Piw5cdBc2yXo1HD3XG3yD/Rd?=
 =?us-ascii?Q?FsLgn8OCIqPPvkb3Cnd86EEn3SU3EiRDo7ufyCkRUDSgW35SM3lgCMLrNP9h?=
 =?us-ascii?Q?P7uMIUeMflUgQcoowLgPCjOPM/cr7yf+M1JOwLx0t+6zJ7w7x9sdnnUs3Fnk?=
 =?us-ascii?Q?TdmZJUZx1KJG96hGOKMwT83IZJyGbrklrFBkfk0Fpc5EozZtD1UUpBSUQ6Ki?=
 =?us-ascii?Q?Bp2HUb/1bbD2EpgTXQZvd8CX3ydNV/A1+hE8zwIMrdUDeLUjwHJcC6/IqLS+?=
 =?us-ascii?Q?P2iFDfd6PcCtnH6SIa5l7R+Zi1X8Cz2grg4WeqN6GAaW9uIPZgWioqWSVxjx?=
 =?us-ascii?Q?44zUG9i6Hk8Jq3pAxnsdv9u+VJOE0G6UP87c3yRQX3Ib/pF7+O7cJA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?M7bBICO66+RAFg80LxlZIT47ECztd569RyMzs++Cx3xVm5xPQEPFWHEF3/Z/?=
 =?us-ascii?Q?8wYqiorlCzv0EMh9Llf0AXR/dwRHBk2/nsD0fbdOkPArvXzeVXi7TdF0QoCu?=
 =?us-ascii?Q?6z5yqwRWYTDxkyru6mYybkBC++kffa+HHdd7v6FxWNJwn0wW5qfj/xKQQjul?=
 =?us-ascii?Q?se2d6OIsqtCwrZR0F7Sv8mTWqu/CIGw2ZeVgFwb+HntGLmCQCygbEPQs4lNr?=
 =?us-ascii?Q?rIOr18IqC+ixmuU72WaOs5CMQdd2BlYNKEwM7bmefW8yz0WPPYV4VeGXYkfk?=
 =?us-ascii?Q?RrLHVqhWdY8AHcdXmyO/nxR0OmEMuipFGQTJywe9rFD02L0W1OosexP9JQBc?=
 =?us-ascii?Q?KCqWW9RF5z99iqc2XToHKIi8IO2gAeoAj+ddjv2nsPJf6+HwrDknilo86wQi?=
 =?us-ascii?Q?4YGy0q/4x2Yy+s0edFNLSRxIkRS7bz3G5pPx5y46JDn8u680sDkMnIFuTtDC?=
 =?us-ascii?Q?LSeX+umLWW1BY4KSOk+5OmbHqjEabmbvR6ix5g0ZQYfmoPGCUUERqCg/gVcU?=
 =?us-ascii?Q?NVEmip36m03iWP84AMJsn9+sUUNcdRPw4N+NswpH4xP/u1BD2sme00SLXR+E?=
 =?us-ascii?Q?NBl0usFZj+dBSX3E5Kx7rl446kBFlbP4cwCwBkDNwirjQF2jhbZHD2GaFV9e?=
 =?us-ascii?Q?BCcOaUw+d7xIyGyXn6Bjd7dk2gFX9P9m7mx4yOCr41wFbGnrNaJVPtxKmTsp?=
 =?us-ascii?Q?+wjdy2hHiaWdTG/mMKuB3HNf16+dSTDSCSMh5J601DBjx2BhLbfdw9H3lgGx?=
 =?us-ascii?Q?tTd2AHTGnbcG8LAgzJ/wlSeHytC7qlkADpIj5Pd/QhZ+X4tVbbTTrg9nxTTH?=
 =?us-ascii?Q?20iUaS5DcT8etIkVTXOnMRYeE2J9AQS8JBcQlYL8BF+4zWSMRJCEv3grAae/?=
 =?us-ascii?Q?h3yXhDFN1iRQPy1R9UrKSWdIeaJaV0FDkJFHxmvFaBPmy1mlcWiL/ylL923I?=
 =?us-ascii?Q?/EYs+Sb0CcooC/8roAJMe11AWwckZ+ZxapyJRkz76Xt/HuAtD+BDQGRAnMxS?=
 =?us-ascii?Q?S6qU5HJCO/j3VWe1/8Rc5B85Gp+dmT88fGe09k2gVwwH20R4TT2BofrQk9oM?=
 =?us-ascii?Q?t/CrauUtiMmaxCzZ16inOq4FoYmU/PtxMsgLbJB3q8HEGlhtXjIX4ZLqAk2v?=
 =?us-ascii?Q?MRvXImQXBRV176ECg23UjsxGgAfIfJhNyuu27oiTFvz1LSfQ9qFuDur0t0BU?=
 =?us-ascii?Q?Hj3zotD5kVhqXr483XBc9GHHZ888mdOAC5rk41h4gsnfS5DqBnlElQvZbnv7?=
 =?us-ascii?Q?4d74K8Vnl0r1n+DZ+CUdEaOva26PQhS9Osknc/eFSjzULyMmnpkd5ZK8gFtY?=
 =?us-ascii?Q?q0xZNSeOAifNhanR9RSoeSbW+5mkLa8gELmg3xowmajjlX4isSVsrpbMPuuA?=
 =?us-ascii?Q?P185brsYJtfLKA7NBLOcCamxePB6zWrC+eB3ZbGf6EAr7sLidPUetto1Ala+?=
 =?us-ascii?Q?EvEU5YKAqQS2PYtndAHGUDnXHXCvDW6+e9m8w30DQWw2mKwXq6oKD9jATz1w?=
 =?us-ascii?Q?qSMOewuSIldcfeVUBxsYQKzJW1LzpxL/lsiCvlxeeFDMo9JtApqU3h4Z+ubx?=
 =?us-ascii?Q?K71wDrawoKSym7SkO2A=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2913fc-da9b-4ef3-7f49-08dde3e05408
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2025 14:04:37.8092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8V2RHdZaprrW2nxENCaEa7mkFN1SAsfXx0D36KWuNvmUHZdnxV5WWQzEUjazcFHAxEM49nVszGON3eH/txYaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, August 18, 2025 8:47 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.=
dev;
> Xiao, Jack <Jack.Xiao@amd.com>; Gao, Likun <Likun.Gao@amd.com>; Deucher,
> Alexander <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 6.15 438/515] drm/amdgpu: fix incorrect vm flags to map b=
o
>
> 6.15-stable review patch.  If anyone has any objections, please let me kn=
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

