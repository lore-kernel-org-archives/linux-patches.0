Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2042.outbound.protection.outlook.com [40.107.96.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD1C2741D1
	for <patches@lists.linux.dev>; Mon, 25 Aug 2025 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756130707; cv=fail; b=EcHabaBZAx1oMue6Q6o5cngazCdtjg/uI9xApmQS5dHESfiPN7O7ZhZ7WTKftoAklnhXuf9ludx+m92ZvPtvlG5bGWlAbZHyXor2wEZtZy5+ZL3Ybviw+U7GRDSWfdAqsQoy2tRjP0PqRtfLv3JXf7bUZYR89xg89QnDYKwCVP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756130707; c=relaxed/simple;
	bh=DEwmH4lYob2IAEi5ECh3cEYjAKDGwfNibbA9MGM4mKw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GyIxxcqoMMPVIA8S/L7iwkuiOiispwizg2h/6F+qnosu21o68h1yFMOWOEMbp1vKDed0/Rj5d0Dyt4RjFjoU3YqBqCpZ+ibhz0z1G1OXLyWnglD3cVRahgsXJX4pyJcCvzHAyW066LMRllCRN8Q2Wg4mnsZwnG05IPkBydK9E6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k6908TJt; arc=fail smtp.client-ip=40.107.96.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k6908TJt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdL46p/7yjEj8I3RWkqHEJFHSz8LlnKrVBiI0PQvr8OqN2duCNbykuaCB+qm+Y1LnVqbQ6xMHTJMWLB+NM/3IPoIgTvUJ1U1c+m80MqJMCcQ27K+iTb9nA6GY0/DhvJQgNnzw26Y2AHTmu31EyD5AHQ8nq0ZMpNES4dr52z9BN4AkdqA+F+y2r0Rk3ELLPJ0XuRg5kmRpfQtner0fTTV2/xWIlfg4hrpzHkAiAaGD985M5RTq5gmshP8G3B08PqBTcS4sISNND8yChBtpHFjRbXF+4pO4PPPHEbVfx74xi/k7YYswiMbRb6j/tpPSnj4cAYot1jzcwUftMSCYjVN8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qPWBy6BVnVjVd/4wCuHXUkBa0iURqe4LuaFmkNi5WA=;
 b=L6/ZoP+W+3yJToWlK8HOVmAjiQ1zpdTmMn85mwdXHhcIctCVlQca7/AvymARwTWJg5ZUW0Wta3Ltb2ppt9s5qYBlPRUPh7rUSg+1MOARg7ZRdMYZ+L+wF4VZnaOEG5qXRWRXtfguulGrp0pphSKh81zU0vRaiYoW4sYXx0C1HPUwhTqB5zDX+tTc27oCyvJaDEeXlcV/pH2sY+3q7yLCUmlSuHeTfMDEi6wh5dI+l1TjcDsalX5nJtYBitgZjfr4xqmSFb9wl6yYcjcuWRMbP5nPA1qzCIImwUMftNkmwcxQ9Kngk644wsYmq6/kMz3m9Rjj7cNRVdk9doNraLwdrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qPWBy6BVnVjVd/4wCuHXUkBa0iURqe4LuaFmkNi5WA=;
 b=k6908TJt2k5tjoxQIXLbwD2BmCVhgl8yyAeLwewUqHQ0EVrQ4TbYvxw9bU8sfllJYfXGqGO+tzGKzFXqvfcx2JEAAEicNHSs1HGXs7XMieeosY/in79XrM47MUlIXilqgGhV2yohURtuLWFfflynKv4bX4oco0Ox73EWMuO+xZw=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 14:05:03 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.9009.018; Mon, 25 Aug 2025
 14:05:03 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Xiao, Jack"
	<Jack.Xiao@amd.com>, "Gao, Likun" <Likun.Gao@amd.com>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 6.12 372/444] drm/amdgpu: fix incorrect vm flags to map bo
Thread-Topic: [PATCH 6.12 372/444] drm/amdgpu: fix incorrect vm flags to map
 bo
Thread-Index: AQHcEEF4FeZBFKTkgEyvZl0PxuoIj7RzceZA
Date: Mon, 25 Aug 2025 14:05:02 +0000
Message-ID:
 <BL1PR12MB514442F0417C7E257EB9D2E5F73EA@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250818124448.879659024@linuxfoundation.org>
 <20250818124502.842948106@linuxfoundation.org>
In-Reply-To: <20250818124502.842948106@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-08-25T14:04:53.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DM6PR12MB4433:EE_
x-ms-office365-filtering-correlation-id: 3243d480-f056-493e-ac87-08dde3e06328
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Jr77mF3SS/uIAPsmZaFqmA3oSaPlTv40CMyVi7n63kR+XDkIKMK7cdkH7zwH?=
 =?us-ascii?Q?qcd17WoKAIjNGn6h+MrIzMsTwqqHyKxHilyGQkelRnbRevMy0kHqjXMwvbK9?=
 =?us-ascii?Q?ekaXzakHAUFcdyNvWONKSBC3osL+RYDpg7gxUWVP0ilaRHaXQub9fcEiV/id?=
 =?us-ascii?Q?f8J5RpuTOrxN6BgrH6m9l7XokfK0fAOYuaGkprtIShQ5FWmUVxoADZWT5XCE?=
 =?us-ascii?Q?JUiADnovdIvAXTguX6xkGIKA1K/IIJh8P6cviV8ME4Jn5QmS/GWRoYmlkQEj?=
 =?us-ascii?Q?k5gXpfO3hsldxy1muo5F5UUj1oRACz5PRI5vxuRBhJgztiyYoupjDTZ+nuT3?=
 =?us-ascii?Q?iXIDO4o4VW2eDwXhl+Pkowaqhi6CRepw0cOEiFXuJ9DNOBU4cUdSv7UFkZ3d?=
 =?us-ascii?Q?j/m8prSnjwj5V2AQtTMOqS+IwpKSHBXmUGD9gr1nmDkwawIPgY60WWzmBGz3?=
 =?us-ascii?Q?DfQmVHU+sQMHCSUToiPK4JUsG7riSWW1Ifv8f5ATrSiMdCYZqfflj4KiMIME?=
 =?us-ascii?Q?aIPrhvg59YhjtIO6/cy5CF5MJba+jESKpywyuHnUl/K1j3zDgrdbwXVSLOv4?=
 =?us-ascii?Q?fIdOXdglkYUn6M8i6U5BHTuk69B4C+6ny7kbq7dE7rPnRzbeD9jgIPF4ZPfJ?=
 =?us-ascii?Q?M3ukVXFWd5uzgZPvrCH+/izgMLyMjlKuPfBtKcQuxHvqDsUGHZqCp1UFFUUj?=
 =?us-ascii?Q?igHybf0V47giUvUUT3uisTaIyjE/+vcbHBXku9nxg1rcPnVDcSYHcEsthB67?=
 =?us-ascii?Q?boEUp0HCdn6CqyX9sMqMcQChJxboIcNFACk2LRoaAmKp4pYpowHVYQsV+ddI?=
 =?us-ascii?Q?SDkIPo0kggtREk9bniEgfb8Rc2uG67LSaa0bPnRoOFeTgWbsA5nuOZYpKOPQ?=
 =?us-ascii?Q?QGMC0Sp5iO7vYN9pes0olanjBFrImoeOi58Byu/tEwVTe/qKend93RCXlGbs?=
 =?us-ascii?Q?wusUfZtbE+7XOL528lUVAIsp/SluHcIl5Y7P4/CO2I8u1vVFGyYCX1rxXpOp?=
 =?us-ascii?Q?N9ctC4HcGs8TKFPrIiUMNXPIG5bWo1h3EUKxYKor8lHngU4FgKMT8+iw9bn5?=
 =?us-ascii?Q?RlMsrv7eY8IRmPzJVGvGBJdHlkFrdHVLJ4JvIzarAYl9Fr3VBxU75ic0uJlA?=
 =?us-ascii?Q?UkafQkOWuukh5+Fm36HkjUq7iOuGdrnzApxKShomSrQtjvL7JTcaGd1DAt6V?=
 =?us-ascii?Q?PGn/9UX7mzeielSCtCe++LqUSFsnsPfoixGFteYKP9xxcf5DYX/a8D0E/z19?=
 =?us-ascii?Q?nONaULcX1kKh3UoKGUTv/ONoKoEv13rfcFE6DqiS2xNeFyaAPaKjH65lRoxZ?=
 =?us-ascii?Q?sVQS1W60ni1ohdVET84Ap6RRbGOOLFENVT3e9DtGOwaiMUe/aSv+RhnJYzEp?=
 =?us-ascii?Q?RO65ja+lm1IccC+va+2t7SE97AIPxskJy71zo89PvXvSL+8YW/H+ML0NNRWR?=
 =?us-ascii?Q?mzBNBG6chSr/bE4UPFXLljqGakva1C9OX8GkcnNOMVqVQRPNVy94rw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0T7dJlfD18ZGakbnxfXh/VIDZ/2KjWEtkFK221G/b/CGQyATPJ4UyT22seal?=
 =?us-ascii?Q?tsx9Gygv7puLR/DcKpfUKEzGhARbmYGZeGJyNFzSYfrztBBdrdQFTYKfqEpj?=
 =?us-ascii?Q?a9q8xEOlZ5r+fyrmYyDvcrYnnm4jHSSkpj2NNdQJlfCIiJ6kg/F3NSujEGfl?=
 =?us-ascii?Q?+vUqHHOmA0/zIULgAHQ8Ei3027OOg2DnKWyHOHmSCTOyy4uVCP0sZxVVqmoI?=
 =?us-ascii?Q?FHZnEe3opXV1Y3X0NKErPQIuDt99j7TG+r+XHW6y3kL3hu5IT6hlmRsVVhlh?=
 =?us-ascii?Q?gwOtctkn+v4J5ru/l+e/3pD3JGLyLunX31MpZ0IgrnRizw28e9tsQXAgZqaw?=
 =?us-ascii?Q?2y4R17ufjPqQKF2X63Gjwexn7qswTY2z7mOn5YfpXqN7dMAfNvfJnoNOxCtW?=
 =?us-ascii?Q?lLcbbK+cwrGYC4kDjXbuBP6XKgEqJhCcz7efnUGEt6xk1rgVmPE9zTfG8pni?=
 =?us-ascii?Q?cW4wHRVyPDqbTBC5HDPlR3INELU129U7R16ZWDO3+FZp3NeEBU4kq0RtvFxR?=
 =?us-ascii?Q?lI5gX9PAW3Xd/iAtkzv9ylbYayC1jLuiJdYHyXvq22SJQkUFo2cB7hXKH3Bn?=
 =?us-ascii?Q?hud7SnPIOknJ1FpSoktxgpIpbRB2TGyfhjC0zniLtFQ5qB/xfn9NC0LQEaG1?=
 =?us-ascii?Q?UXNsXwq/c0DolxmQWu3ryTG1BiLuEifC9dVr4JJPjJbx5vvY5LXuOj5bvpYV?=
 =?us-ascii?Q?/vb5r/RiwgbizU7alIcrdUZiUM3fxOrTyJecDwmvVAIc2OOODE815T0Uf0w2?=
 =?us-ascii?Q?n5GsrpENJGVom88gOMHKUGPQSN8QCNv7oLOkm+tyh+Pm0OuTbMNBlNuy5EJr?=
 =?us-ascii?Q?SWUIvYOUD3kgytGVIqN0rreej7e7b5A+lQ9fG7HaDdMQOtDIaA3R2Ypt8XGq?=
 =?us-ascii?Q?d+MLpG6VUQwtuN1XSlmo5clUBOlj4lTXVf5UOkbLuy1ipTFANS1jsJfDz0Er?=
 =?us-ascii?Q?jblaPU9YNZ0InV57lyxqh8V6tL6AfYL3JIhrUlbYuDJ+S5imDb9hh/3Xh7zq?=
 =?us-ascii?Q?Vwj6emP5kNSHF2NTc92ns7Sb6rAEXTSzPsAr7jz6KVzhkQdUgCXv3gj9RQKx?=
 =?us-ascii?Q?aNoaXxtf/jLZcPKWpNwQm8qDvrQNeKE9PnSdbHS749qgHfUKnF+GGKZeXLAi?=
 =?us-ascii?Q?mQJn+SZf++6g2ktOALGi8zDGeH7+l0JB6gOs2a8l2nva7PVAGr2zFglSmnAh?=
 =?us-ascii?Q?GrimwsSPZLc1MPxJ/zmtYM0Sbg2UbgdULrKsFo9BkntHAKykmPwIxKY7cO+0?=
 =?us-ascii?Q?cHZNcga+JEmBuKCs8/44v5FNH1eiIL37EYjNu3Z2C7JufHsANY5C149I01cU?=
 =?us-ascii?Q?clTvfR2qTirIYdj3ocxl/qGBbVXMKW87HQhFcnCbXB9TT3YP4FNJ0bdRDUY9?=
 =?us-ascii?Q?NSA/CCwn7yrL4rOj1HLUlbfRq8GdO8MaBQHugwskIiAdl0Zjt3bV/7RzlagL?=
 =?us-ascii?Q?Qpic1Nxmj7hWyMMRCM3M8emXJt8qBoFIOJixbs6gfXEc2jE/HLT7/POLTAgG?=
 =?us-ascii?Q?+Q9DRFkvCkeTqYD9nlcOYcU5BvlnYJEaxDYjap9zhZKotZgkPj2YLe1FFXW6?=
 =?us-ascii?Q?CG5LuuB08DhNRkobv9Y=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3243d480-f056-493e-ac87-08dde3e06328
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2025 14:05:03.1651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cRVbjJuDs0deKatQnm6ZSDP5taCpMzTPEZXhOV3SqcciGrJXFMgWv9jUeVnNBLxPf0dLRMH+fJsqf7l/2QGHjQ==
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
> Subject: [PATCH 6.12 372/444] drm/amdgpu: fix incorrect vm flags to map b=
o
>
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
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

