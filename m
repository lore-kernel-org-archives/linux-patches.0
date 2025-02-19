Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E431E0E11
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970410; cv=fail; b=gMMg81DA2ACmCdM3ko/GSPNVbP7SVTFMeJehk1hm9oIuWMEkCzXcG3t2qatZDNuhzYyLAViqxhH2l5NXRJzvDj+GBkRLRqFsmR+YY21Wgg+M4NSvLq/uvUJchiyffnMdxcFn+RojPnM3RXk/LdHjLabcfVYusZZUPXW7KOn9+50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970410; c=relaxed/simple;
	bh=YQvA7WGEjAmLCJVeKfnp6osIP7GKubM3cK59+OYNtm8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZFwtyOB9hVIGm/hPMqq5FxOyU9m5TYcriRWYOD6detYQm9wAA+R8fPY4wuM5G5Q16vhuKTn1HJbs0Zp7/proM7+ItKWMFQnt2x3+hCaJtBMtGVnpe50eyG2iTAklGLQ+X7BbTQYgVt2gh9j5vHyPBpZs4dD/X15WlyiMWP3KlDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2vMyCIR2; arc=fail smtp.client-ip=40.107.96.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2vMyCIR2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQztmjvsCcTEbarECOq+9569s7nOzil3iT6IPT6eUX4SaEU+F/NdEvT0Cze104PqcmtN+siqvqSY/o9Fm8WYexjQsT8og8uZO1UF2QvfH9OUTj7GPvDBQFsEX9OZaDERlU6Cs/pesThY5uNcutUvT5yQTPjQx2UWa/71DpqgvIzs4o9bI8Z4F0nWs1PBnOT35Sdf5VIe+RY0fq2tkPJoQ1Xg67KmIpEasy8nuZ0AhvzbdPT1RiJD9Hlt3wO4DgIGnhVspMFbsW03/uW3X8TTmBeE+aquEFseJhd4hWkBmk8wL1Q4KYkRsRh1TP/TIipVDkMt6pFsmxLVMRdldlM9PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iLEIAomtF1yoBf92Cbtjc9ZNk/PssRfWrWdE34QKdU=;
 b=uVTKwy4KAjA5EtuLG/gkbCVwWErYjntnuAlT/qzKarH5Ra76KdywTaAN5KRURWgiPVqoWl6OM6NV+0p/HevoU0UmEegE59ZSqs45piXmCiBKstCzyKXZgZCHNiPOG5hdm09fr18AEHg5CEag5hmGu0FkqmI3Hytobd+V+wKQaj5mcXb/LuC6TFQInR4wh35Fvnqsha7+7Z3ol91nY7uMoUMxDD60l2noVDdwD1kUdY4+in6jxJCWSwDGSj4UGakGFtWTkU9frgtkuoN+hpAuGwwAaoulT247Nkl8T/zUH3YVfihFxxAuJ3tLoEbuVgBRk+zrc28D2R53X5SIFxSLXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iLEIAomtF1yoBf92Cbtjc9ZNk/PssRfWrWdE34QKdU=;
 b=2vMyCIR2lnSvuk1rSM+x2BQ4Lnd0rn/2dSH4qvplFDFku/Hwwug7JJ/mBfyEX5WX4HHAT/uBsV3UciMoVtR1s1Pa6JnjLC2XBufaZpDpxHwki3OjQOoBYNJnEHEc006EQzD0oHhLPYPa/DfnEOlvwghTFpLPaNkU/WGXWJY/6J8=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by CY8PR12MB8362.namprd12.prod.outlook.com (2603:10b6:930:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 13:06:34 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 13:06:34 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Lazar, Lijo"
	<Lijo.Lazar@amd.com>
Subject: RE: [PATCH 6.13 117/274] drm/amdgpu: bump version for RV/PCO compute
 fix
Thread-Topic: [PATCH 6.13 117/274] drm/amdgpu: bump version for RV/PCO compute
 fix
Thread-Index: AQHbgqlRsjEHWAFAHEOpV6YomnuI1bNOmMcg
Date: Wed, 19 Feb 2025 13:06:34 +0000
Message-ID:
 <BL1PR12MB51448EAD680DD8D7EF63DC09F7C52@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082614.200745355@linuxfoundation.org>
In-Reply-To: <20250219082614.200745355@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ActionId=e389bf23-9e97-4cf5-9ebd-6d40ad406fb6;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=0;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=true;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-02-19T13:06:18Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Tag=10,
 0, 1, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|CY8PR12MB8362:EE_
x-ms-office365-filtering-correlation-id: ea46d70d-805a-4781-b21f-08dd50e63c98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1Qf7+kUvfY9E/wnKqgmH5I3CdRXyyAmnYu1XSOQmtnZAS8idoytjHSQOTVwO?=
 =?us-ascii?Q?zrXqwXX6pSPeol+ntyVW3ZuEhYbBLYyM7VvYC3p3A5VJcnb/wES9rRMMjbVa?=
 =?us-ascii?Q?XlufGwtcYxzmrNWtKpQ+pCOd+8aJgGGOPu/NFX3GFCe2KcnOFFRvp2aNDL/9?=
 =?us-ascii?Q?2F0hj7+KeJfWRwuw7DDrvgyxulegFTv8ljUlSDAvMNXlxfy7tZwmzG6nAzfU?=
 =?us-ascii?Q?BoGp4c5L4tSwT358Cb3NvoWLhAReaQTuRZ0j/mrRVp/5uAYV8nRt1QRcVycD?=
 =?us-ascii?Q?f7L2cD3RhUW+B2r0nTUxAkM/n/mGRfmC62p4Ddhr5t5aIyAzh33hyYm0RV7X?=
 =?us-ascii?Q?fETLsy/4UJ2eKjzOFs79H3S4EAoJozyGga05L95U63RKQc67suWUpv5eQPZq?=
 =?us-ascii?Q?dWnIXtxwk5+SbFXgKqFTBMr7M3jJQsudz4jRozdNybQ3Zgd2OfetsRNCmPgL?=
 =?us-ascii?Q?6Id0y7BmHxE9ghtO8ZJ21XhBmTdSiTZ/zYViqSOkMIyejmSxFTIQn0rcxWkb?=
 =?us-ascii?Q?m1grMqd6+zxswto1ifOOv0FBnDfJFBTeQn5Vz39C6jaRvphUZ15fxCQ3Wwz6?=
 =?us-ascii?Q?s+nSjeJPHRkDflhX8nU+FSQYvAQrO2kPouXQ9X87NasKu/nlRtL2xj2toGGh?=
 =?us-ascii?Q?WNgz8x4uHVj0ezWeD2tKSvoCrrQw4cx0x45G4FFTRrMn1b+yjVDZ/zOa5am3?=
 =?us-ascii?Q?FUhPyOJrT75io2tYfM328Suuhdfnl4zsU5oQg2qZZEVWQLa3Rj7GpDdATdlp?=
 =?us-ascii?Q?MX0UnDuA7J1yAKnTeFBfk975oEIle4++dM/PMxrq7ZIOQWpAnkKuPjtpKHLN?=
 =?us-ascii?Q?y93kEb3mdQom2Bp/Xt3oPMNRhOSfABi53G77HGCXpwjy73ZMQ9Rt1hAUcpgG?=
 =?us-ascii?Q?fe81YgCLrZI+R8rRfeGiNORVcf0jKkO2O8YSfl5w2IT5AC+Qu+BZHU1ZyDi2?=
 =?us-ascii?Q?vgrpOCTLNhbcg73wpPGWeMH+u31J5h1U5EgKtuDkSYhicBvB/d3kNaN2nYeM?=
 =?us-ascii?Q?QcxLrc4w8kbrLR21eYaC1fTjSUUUtO+Yu2Nt1maAqMUy4a7+LFNLlaGG295X?=
 =?us-ascii?Q?CcpGmJtiFVTLzlny3Kho19XDtR/VtfYOnBPz4zPbxiL5qNdbJIh79aMhQpxQ?=
 =?us-ascii?Q?2RWru3+pxkN7NSuy8efm5hBi3fmUex6UHws/OB2i+JCY9nmBOz2451xTgWmS?=
 =?us-ascii?Q?m72xL+yDfoa2PY5eZCQI5Qtxna8VxdK7nY7mov1m8jaeX2ZlrLWABVFtgaLw?=
 =?us-ascii?Q?kcCBXAkBIiGWcfvLfvFlRl8iUgoDXh2Eal83QQpMmsXMi25q81sjo4pAkhoZ?=
 =?us-ascii?Q?+fw0CgCPdYfjqAoylPox7vefUovqm4VpTsDz/lMiQTCAqthhDjOe6qpinSp6?=
 =?us-ascii?Q?cO7+IASqm/zwTKkhKep0ph293dfKRsZ5WnfAg7cZWMf0R2tPkjw62YT/5Obj?=
 =?us-ascii?Q?iw2mtPAPPx1XagJh0vH8ImeUhndTmUWP?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XoSLj+eRuMoPe54Rd+0Wc677CVfZ8w241JzrLaLFrBYiFqIxbt2r9N2tl/St?=
 =?us-ascii?Q?NF3rgLMOFqVFnLZe+Jx8ly8a1Q8gB4lZCYHrXQ/HJ5+9zeDDex+AXF/Z85Dp?=
 =?us-ascii?Q?M9yz9q9ovpB+Zp+HU20CDYV5eVpX+/n4rKXDhpzwNWKVvcZEm/r337+lw/Ad?=
 =?us-ascii?Q?ox2LSZjIFb+lOKGmoVGqc+mVcV+CXvGkTWnvRPpIwPnop6wmTs9z/96ckq74?=
 =?us-ascii?Q?CaxRTr6S3NaldFYQcfa3hLswsIqgvJjZ/9gIBqd+3vNMmPhUk3P+APoTexe3?=
 =?us-ascii?Q?CQOxqiyBWJMSl7+Kx4gleoGIkhP+/i7TjCIZHwnGHygvR8ozAFW1QoWKSb6m?=
 =?us-ascii?Q?LXZegtfasrPppyXKY+njm+0AR0X/YpTXgfcMDC5X7bfWMKoeeGe+B3/6hcBq?=
 =?us-ascii?Q?9QABPxKiDSSQCNBlkVZxQUqy8GdpNYFEVAbdMAN7YNEOTyDjOxqBPb0fkj1S?=
 =?us-ascii?Q?p6xvaOwRcAv073PNeFxYt0yQYOYtQow8+ShT+3ctNlbMLFFRKaGX0c480Fq9?=
 =?us-ascii?Q?MNenSQ6vcdGK2Nh/fyaLOwi4HlNOKLgP1Nwfu/+5h6nvRNQEY8/Hw8SeiLHd?=
 =?us-ascii?Q?pZUx0hl+u/ylHmwYoLtJFMQSIwElBUYsSkkZlu8U5SxlG7toodfx7wbbmmGb?=
 =?us-ascii?Q?ZaudIpK1lR8rwn2zsuYzTfMnf69OMs+SwHX/mD/VT0fKVsJawei/LEN0+uj/?=
 =?us-ascii?Q?R+jYFcfTncav+M09mEDHZfgrX0lHz0UAkaZJ3bFCS7vr1zqlGPEn4WDiEr+3?=
 =?us-ascii?Q?ZGI7wMaS6OZPFgr2nu0gWNzfm9dr2T7ogGJqs6BVsUtZoJmq+0++iS57dTua?=
 =?us-ascii?Q?4sYgdS7k4Rt4JX7ZNXftVjTg8fgnoyx2SI9o4mxBG+NEgTBgIMH1jObv5sjS?=
 =?us-ascii?Q?FgCHXwUuLtPJsDoxClea/rWQhE56a/JBXuiCG4vJ9Hu+LlGEICP/udK2c4/x?=
 =?us-ascii?Q?l+4J87v8nFx8D/NvD6rfaJUGJmzjcZQwIZeK4AQdZiu7BBpAL9jqdPzNG6ib?=
 =?us-ascii?Q?pKTl66pv8XDVceV5RU/oEdmpVp1EZ8P2JNULUbOgoiHUm/MFF97MYrvhZc65?=
 =?us-ascii?Q?RF7PFsXMAKfR/W98WfCVZdTavfSrGV9YhGaDLYCMj2LHOpUyLbr7KB+gZGdr?=
 =?us-ascii?Q?ZdzkaqsViFpugXJlbUu4G48Q6EUbUtauqcpGBy154A8bqOcUsD9zBpBjF2WU?=
 =?us-ascii?Q?FCrVdrDhzQF+lQlzKwl9sfcCwwWqPMuRf5hp/ZExc5/d7KA3uJgZW2E5WJUk?=
 =?us-ascii?Q?CQbnPxO6w3oVW2VD9U69KQU/+aR/JihJVANpDo+9Q2PMNLRn+vbPriXsFNpx?=
 =?us-ascii?Q?MW2KGRGBNXg+QoJkW/eNBQXjtHEHf//e5ODMK3Nc/w6Q5+3yYXHTs42ClPYc?=
 =?us-ascii?Q?ZtbiLKRs7CrxzzMZK3Hk02dwwtm+0HgrBLWDZKkQ2s2S3DyFsICDPnbvjvFu?=
 =?us-ascii?Q?YAV6y/3Afk8Am3pLAy/t2Zw6O+sdiJKdo4SzLZG2Puiz33TytQe+cu7pdPMh?=
 =?us-ascii?Q?nMslHJsenYXssj+AuB2tXD634qGOKKmXmpVN0a9FE4clsgT0P+IkJ3SXvjN3?=
 =?us-ascii?Q?8v8jv0g46/hy72WzHs4=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ea46d70d-805a-4781-b21f-08dd50e63c98
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 13:06:34.5470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1TPOa92pSI8iie8eQrEFX9BJw5aRoCMBKt843F7xM/38QllBxYNdQtfbJ/jw8KZDJ80RfURwUbSs6gZEdmSqxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8362

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Wednesday, February 19, 2025 3:26 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.=
dev;
> Lazar, Lijo <Lijo.Lazar@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: [PATCH 6.13 117/274] drm/amdgpu: bump version for RV/PCO compute
> fix
>
> 6.13-stable review patch.  If anyone has any objections, please let me kn=
ow.


Please drop this one from all stable trees.  It has a dependency on another=
 patch that was dropped due to needing a stable specific backport.  I'll in=
clude it with the backport.

Alex

>
> ------------------
>
> From: Alex Deucher <alexander.deucher@amd.com>
>
> commit 55ed2b1b50d029dd7e49a35f6628ca64db6d75d8 upstream.
>
> Bump the driver version for RV/PCO compute stability fix so mesa can use =
this
> check to enable compute queues on RV/PCO.
>
> Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org # 6.12.x
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> @@ -120,9 +120,10 @@
>   * - 3.58.0 - Add GFX12 DCC support
>   * - 3.59.0 - Cleared VRAM
>   * - 3.60.0 - Add
> AMDGPU_TILING_GFX12_DCC_WRITE_COMPRESS_DISABLE (Vulkan
> requirement)
> + * - 3.61.0 - Contains fix for RV/PCO compute queues
>   */
>  #define KMS_DRIVER_MAJOR     3
> -#define KMS_DRIVER_MINOR     60
> +#define KMS_DRIVER_MINOR     61
>  #define KMS_DRIVER_PATCHLEVEL        0
>
>  /*
>

