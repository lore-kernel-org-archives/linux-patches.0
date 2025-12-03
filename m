Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8252C349B13
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780647; cv=fail; b=nfk1dNGHlqNVqYZGHj8IspxZaoIx0RrMJAFl1wlC8aEYyIjrHFWpI+Xx3Sw4N/K0Hk67TwVkgk5ERhmie2mD1Y4WIyZFz/3USNjY931kcvGuj8pJOR3ifyPD1LDf8LtH9xmQk4qF0Eg+gX6yWQf53EkoRkx5JdxaqcVFXJZItYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780647; c=relaxed/simple;
	bh=9qt+4sNxrnD4y66GkbWZ0eTZMjpeJco8GXesAa0QzdI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p0AvKUAeg6/JeyzkpzKdUgSgJbSAPOC8Og1I2YhFDAI/fHuiYuVqcJ3CUiUnGNkNfx0RShxQDP6n3vgBQIa8rmuJlV6kKfYyLk81fexRohjmBdKob4ds4A3sRVWDzVgv/dEmLRPcRodBhU5Ln1CWPynx0mK0qLp0PAv2Qj6hCc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=khGDkehO; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="khGDkehO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xn6uuAjLXTpfBmgBiMvw67yLRWWgtfTVw1FeXe1jNX2cFck+RHavRVtQptBkpq5FL1UvKge5GV5n95LGSxmQKz1G2da5qd6QAhkq8XCWWG4u7tUoUprl9GXBLbnVvzHJPHbxuKi3C1KarVxsnz/5mpezdUyGY/Xe5oHSusWD9XasQZrB19MQNLsLCCrKSjS3YMU3Rt+cm9Vb9br6bRfmCzazogoIDbd1z+Ijb9sMgibdngO5F/187AOEzKohq/dFDDwS15tp7jzXt36Yy4D9HAJnsZSg1e3M6eTDYrP5iOsmwCromvnUe7CAA1LBpYB7EjgRZsOSUckHMP6dG90aqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RceLwE5QeqLgkqHtegIcj3NGS9bX7RR2/HWHCrG5MXE=;
 b=kUF4vzSUfUvaq1Ih0X3UgiIr6CnDcQUYv2/J1wk5X/aWCYoHrs0RpaZT/WS2eFLFPPUZOD39OuzI8oGjsD0sOPZT9T76J9ZJUfTYBjDVTrTaeS/HzICmCdh1c9nJgNXPAduf+dpAR5lj5dayczWJDoD6X51tDJXqAoJ5/cY0CSCd4V+5nfNobs3fp+i41B+/JTewPvTf++5kga6B9ocG45gaOa9tUm+u2c3r3BCebffDvEf9o1UuYiDBFaSrjnngHUQngs3L7dAfNwy/lMFqLgb5fL+bON0HAdNUd1mXtPOt76FCOT9bB3dHW1y4/Qxd1S3XQyThuR6S58KfJguwaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RceLwE5QeqLgkqHtegIcj3NGS9bX7RR2/HWHCrG5MXE=;
 b=khGDkehOEgaHIYoYwR1w12NZOhA1HfOs8KoiTd8k0q0ZrXx+UxMW1upiRltJOrHRit7Vq6V2aOWmVMf82tDfPhN+QSG2/ijSjjZ8z/L2x9ndYVZ56pca6uCHYH5FQd3l3mo1YxWohkjDSSZx+R0x2Tl7eiiB7ivatRK1S5UYP5I=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DS2PR12MB9749.namprd12.prod.outlook.com (2603:10b6:8:2b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 16:50:42 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 16:50:42 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 5.15 136/392] drm/amd: add more cyan skillfish PCI ids
Thread-Topic: [PATCH 5.15 136/392] drm/amd: add more cyan skillfish PCI ids
Thread-Index: AQHcZG59y711liHLf0mZNQwIbHmAMrUQIMYg
Date: Wed, 3 Dec 2025 16:50:42 +0000
Message-ID:
 <BL1PR12MB5144D48B9A9E384045157D13F7D9A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20251203152414.082328008@linuxfoundation.org>
 <20251203152419.094422510@linuxfoundation.org>
In-Reply-To: <20251203152419.094422510@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-12-03T16:49:52.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DS2PR12MB9749:EE_
x-ms-office365-filtering-correlation-id: c3af08f8-eae8-4025-df12-08de328c1876
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?tfiANwoZfPLytWBfFK4RQqu0Oiyilk/q6z2bdC/44sZadTkp4Y6NWNRUCJa/?=
 =?us-ascii?Q?wt4q+90Urc6oXWm5ZyQS7AznTQmoF2imRzms+AQqdU0QA9GoN1jQlLLSrz6v?=
 =?us-ascii?Q?3Di6Ut4x09ycw+Y3hGl9otOMnYsMBxsugjfvea0ApVA/QCsLYdUi1PPaQh16?=
 =?us-ascii?Q?TG9sxLTjzIGKGDNHo0yUf2BlEeJjCE7wEXbb7SGkLYAx3pTO0rW2vQuxPWjB?=
 =?us-ascii?Q?u3Eizxs4Yw8mvR2oorT48x+NlxnTfQErTicbmvHNvsMNHx3Y9TppMGW5y8Qi?=
 =?us-ascii?Q?d8zFQ318S1SgsBR7toGuOJzbrW13J0AJu5uaIjpzV7pRunrjUgzBnmzBENVO?=
 =?us-ascii?Q?aW8xh/Gaymw9iKe9Appo0/11yjOpvT6Ozgp9tVGcmmH+Imo7heuG2T7N6/AD?=
 =?us-ascii?Q?u94cC+FZMIVYu12e9thzImzkNULXyXScUlwNpWuLGNbO7Eym7kHaMU5B6VKu?=
 =?us-ascii?Q?amF1o5SH3WAp53Hi1Oq0jfEi3T+ik/nbUsZ4loSGSxTDi+S5MkBR9yCGL0r7?=
 =?us-ascii?Q?uzL+BUc0FxJn+CgELcngSkT7G/NeVav62JwUmec2EopsteF/BZoBCeeCoMJU?=
 =?us-ascii?Q?Y40bbtbBkiV455XN3QuY1z3Q0EDNyMJROCuUHhSv8U2r48db9bnisu/kUr52?=
 =?us-ascii?Q?vLDzAP2AgAY4NdBB+KJxKDC9qA9bnMRnlzO/ZqPnXou9Cir+IHnhjBuV7xTh?=
 =?us-ascii?Q?uvx8ChyrS8lQ9HLa8katSR20uM6zenFncj/k1ocOaIikEYFrVhB+ckS0tsCw?=
 =?us-ascii?Q?p3Qo9p+GB3DJdv9QSLLNaDXw8lvJn04j5sPTgdYgAufs0rXnnB+2Be8g6U9t?=
 =?us-ascii?Q?fmReOnfgXLif+Aog5v3ABk9YV8QfmPpxsonQuuYRPCwXoTh9vO7g7eLMj5Aa?=
 =?us-ascii?Q?fpP+sT277GB0f6dek9JCl3v+xUHaVj5wm2qosNeUQvq1FAoCZPwcxZnHjNlS?=
 =?us-ascii?Q?QdBBfJW5hxuxOy+0u3UtscWWvf9bDf2+sWkBOBz0/SSbCGysldcyfCuGJ/ky?=
 =?us-ascii?Q?l3ukuR+IZjSdl1xZF/tOK6U91oPho0sS0Ht6hBq5FeAN2m0eqyvEKafOc/Kv?=
 =?us-ascii?Q?aFRLRPimUfP8ZHc2FL0faEPKtaYxTMGaIn2rEEB85EU0WfTHIpOG7lDNx9uv?=
 =?us-ascii?Q?cU1hqPvW07uRHIt6/YQekWuXaaccCStnuozInWVQ1ppcP03+hFll60Rj603f?=
 =?us-ascii?Q?1ZzykW9+gO6W2CVIh1sG2KbSpLM39kjyC5rYAUd3xC9gveXnjc0XOrAGZP3G?=
 =?us-ascii?Q?SnGLNrzuN8RkRnWHejLiEaPGOfEmALBhYgv1MHPKyxgderpLei4ldsGJLPX7?=
 =?us-ascii?Q?QBvBodP7zOV7BHwcgoZMfldgf92ZzgZ/xAzJZncZxp0aZG8oav0S+occWhd9?=
 =?us-ascii?Q?/Q4iRym5jLw0CXsoH1sc8O7uBHF8cbhz3se2wIdPi1MGSwtnDEA2GR4JijBm?=
 =?us-ascii?Q?oLckPvxlSF1HE7m7HY945pzUlfqqr/s6O7t6OVJJvw3PDPkCbvwUHkBS0IqT?=
 =?us-ascii?Q?RylpFy3ndfW3PoA9rEHq2rHIq4dxEP6LoL/x?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yPkk8uRK6Ouw/0eZXLHU7b/NdRgD7U2Wz2K/oWWjZvL49hg/efNPu1MjC/E3?=
 =?us-ascii?Q?ss1EguUIaIrqPoXkgfTJyBRf0HNC0mh4WO8BKb1lvjSyCPXg9V1GG59V+rqk?=
 =?us-ascii?Q?uLfx+ApqK5FzTwkGFIG419PPv5PgQmXYIH5oTuwxZgy/P+16oJKKdtKlDqFK?=
 =?us-ascii?Q?lWYQdncjHrqVK3DwvXC6E3leXuyG7tefZxVyMOmU6yAD6tL4GJF/fKy3Kx15?=
 =?us-ascii?Q?cxst+awv3PXqUKQvwQB7Dk9mnSmhSlmJEXys1W3UhLYDyHejnB/ZUzPw+n16?=
 =?us-ascii?Q?eTmfQMj/cIrD3Y47mQRDgLUGSRyWKza+reC6t973YDOwk23yJNvKewuD43PW?=
 =?us-ascii?Q?v68DLSRCHs3hTm88j+X0CG2YRnZMMS+gftZgW8BBO2LsYIbLNZ9BdS7Eh5ll?=
 =?us-ascii?Q?HrzYu8pqaaitdCH2IaC1eyUEnie3CMicCJBLiQLFN95lITkwvKq+LUWozfbn?=
 =?us-ascii?Q?MxankVqm/ZbHgRhNEQsY7jAGaASKthttGtIuAKgtw2i1YZNd9MQUjfhra7y7?=
 =?us-ascii?Q?URWX6Qg5tB6CmW8+N38g6W9ZcIDovCfAKhK1gCr6e2oHO01BT7Em0vK6kCjk?=
 =?us-ascii?Q?2IIJPxCfC6P7Wk38cGTnmvpdyTpc41UAzKV/5/APJ8d1xNg7Rw4YIZMy2hLJ?=
 =?us-ascii?Q?MlpgjwfPY5C4eIH8CaFBM80+bGoCeiZju9/IiLYGKgZM9KfLBzjflyyB0n4N?=
 =?us-ascii?Q?Sd5VrHhpOxlHxe5ytQOkHbsznehyYQkozN5nXUU2GH9mgXUKPSxFwu22+O4H?=
 =?us-ascii?Q?uiYOTDocJOuB0aIcJYCgP85AEp+adw4mi5nqZ+Y+P2NjsYOMtDpU+hzUG73z?=
 =?us-ascii?Q?M00OuVI/ky4c4Hbr2MEtF5HyO8cryjGtoJYF4+4JIynv3DXPpyep0WeJcB/8?=
 =?us-ascii?Q?d7YZ/9X0Zy4CkggqNQmftXXCGJh2QL6P47nQVuezDl1L/J2G+6yJmE/lUDAj?=
 =?us-ascii?Q?wmrY51+uOwxztsUCbWszBeLIDV5DdfY86qgRQdQr9vO1QGkeqFaHl8xJEyg7?=
 =?us-ascii?Q?bMBu5FzrLsUMNDeyxXWNkkxO4AU8c+kd3BbyzkmmeNf9Ok6t1RtDb0OCFube?=
 =?us-ascii?Q?vaeEMbSMpYscj/oSp8g57M88x8RnsoaLHbuAPQlbt518wsh0ViLEeCgWkm9g?=
 =?us-ascii?Q?6nRmWdpbq1yXNoVzEaqeblwUaXvBEUc3E/Z5Puy04EAurohWimrFWmOdBKbq?=
 =?us-ascii?Q?O8OjT5fKJJFwim5sRY0nGdnUlpvRDVXniZWvhiiojrPDxj6cSHn4sa0z5Y0Z?=
 =?us-ascii?Q?n7g0mpwnoAMUQjemjquNaQCEGLnO3UzvXErCmhoPfHRzh5GEPvBy90CNDoWN?=
 =?us-ascii?Q?sVqvXYZ8GTjkz/G9ZN7w/EIMPZ/6m6rNlk0KLHbTWuLza9DWq6vtBXELyncD?=
 =?us-ascii?Q?38xBhE/shYf1O4EVK23xR4t84IA+eS3hYDDkJlYS6SOe8REsfus5Wyg0+1tc?=
 =?us-ascii?Q?NQViDL5RT8C+ZdLFNdkXT1xzSDKfpM+dj8EN43z2RSMqFEg2FVqlA6ZkSwzc?=
 =?us-ascii?Q?x4jVDZ+DUzjT6OlDKDyEg/q5z9+IG7kmDnvLvtBz2t1HnFSnQIN2CaeVLPIG?=
 =?us-ascii?Q?uzeIYg4wcPiEJs+PMSg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c3af08f8-eae8-4025-df12-08de328c1876
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 16:50:42.0356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YsoWDE/kxJ9swy0g6PstcaLh/mNR+5vlMenIhsbcR2diopag5AkdKZVNbl0nDiH+YRxImcULMOoSZ4It/FPdug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9749

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Wednesday, December 3, 2025 10:25 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> patches@lists.linux.dev; Deucher, Alexander <Alexander.Deucher@amd.com>;
> Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 5.15 136/392] drm/amd: add more cyan skillfish PCI ids
>
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Alex Deucher <alexander.deucher@amd.com>
>
> [ Upstream commit 1e18746381793bef7c715fc5ec5611a422a75c4c ]
>
> Add additional PCI IDs to the cyan skillfish family.
>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

There is no need to backport this patch to stable. It depends on a bunch of=
 changes which are not in older kernels.  Please drop for stable.

Alex


> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> index adcf3adc5ca51..7abcb5db9ae26 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> @@ -1942,6 +1942,11 @@ static const struct pci_device_id pciidlist[] =3D =
{
>       {0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
>
>       /* CYAN_SKILLFISH */
> +     {0x1002, 0x13DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> CHIP_CYAN_SKILLFISH|AMD_IS_APU},
> +     {0x1002, 0x13F9, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> CHIP_CYAN_SKILLFISH|AMD_IS_APU},
> +     {0x1002, 0x13FA, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> CHIP_CYAN_SKILLFISH|AMD_IS_APU},
> +     {0x1002, 0x13FB, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> CHIP_CYAN_SKILLFISH|AMD_IS_APU},
> +     {0x1002, 0x13FC, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> CHIP_CYAN_SKILLFISH|AMD_IS_APU},
>       {0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> CHIP_CYAN_SKILLFISH|AMD_IS_APU},
>
>       /* BEIGE_GOBY */
> --
> 2.51.0
>
>

