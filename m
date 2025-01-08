Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C808A192D66
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 00:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736294444; cv=fail; b=av7dwBPfxfwKrroHVzjmVsE22dgIdeNxxxRgr/gVRKSdzgyZaS34ezgXl1dHbXhC4zbO+lGtYnLRBpw/stCkWdNLvj9M47npNU9aEq6Dpl5gh8l/hZmS/usxXmk2lkRky7VFJZghb8//6/CKU7aKBdznoBIyNfQycXHuFt85Bmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736294444; c=relaxed/simple;
	bh=N05mk5ALOIbbuj552LI9oR6Ko0Q7WyKSxBvt9qUP9/s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tXNXR/Nmqt4igS1HHTz12O3IN+rqcFftLYwvXUpX1FbcYTv2Z/GlCNZiL6UDRKa23CsAia4KcXbrckfVj1H0clFmr26zilj34W3RLJMiVK8e5ZSjAYDl0hC1F37jT+K78FU84/C3UC/zxnoyuKjni04SFoxND3GEGSmoe+WEn8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pOiaaRq4; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pOiaaRq4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aty/gkZ//lxIzq0oit6a6QmOm5JJFutBpl9ypsO3OpqdSp51yd/mU4PXlU9KWeS4L8POYC+8JUW5RJoLfqjCwB6dBMQ8OV83cH107idZ5Anzdreth7p04SvVucKeXBRzbO6WaIL5XLylaNdyilw4hxcbbDFvctIf6zn9/78J2HlrmawEC+PWrOMqs2r3sEFdwrO3aCtQjyf9HyKevmlZvg2XdPL2MzrCupyf/6eEAe5udUQKlrTW1W/uauCuXOk4J8DcAc1cIhkhRFCGS1zftllNfCQ0pZ4pGPIizgvWXdu4x1t44HzhkH1b+Rn+1oM2Kj5IYjwbcGjwPKE11IUsfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3MoRiqIpO4MNTXg3kif0MyKkDAsns4MDL+8Jf0rW0A=;
 b=SAmFclO0UfTMvT9LZtB7WWC4jOD7Cz7KWbxNu9qR1gvNIkb4RanAv1qvK2EA5WSNKfuwHOqZhf0/buBVrEsOf6wuEkJtqNp/6Dq8WDxgY8ShWmUo/9CWFozyUDjPudMNPkkKtrKNq0pQwXevSqKXIzmCv4/ppG3lrjBLaHm2tsEPmSaRyBe1OgjiuesBFOng5+ld3x3a3ixQRmvE6bArUI8ykSSU8lE/lxjIdGZwhz7KhWF//cUF+kHtP838jCjl5h2NhjE5iJ1VRleJ0FXVgNcjOx1F5sMn8YiRpPXGcHMra4jT9syYGcC2idF+PTollVW5WBUdAYZACBTrlCrKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3MoRiqIpO4MNTXg3kif0MyKkDAsns4MDL+8Jf0rW0A=;
 b=pOiaaRq4YiTsK8Hw1kSPHjRJ87oPrTfKNtioe33EI35ZswIHsZUatZbF8bUMWNepLQz2JdyCTPBBd85uHbhmGwI9quNoN3RbQIK4s+o3F3ve/AIrWSf0ShZFDoOpQVCxusxDZIlNAFj/QRjtl7D8bhfc2d8zAFbsNGj8473u7t8=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by MW4PR12MB7015.namprd12.prod.outlook.com (2603:10b6:303:218::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Wed, 8 Jan
 2025 00:00:40 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%3]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 00:00:40 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Shixiong Ou
	<oushixiong@kylinos.cn>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.6 014/222] drm/radeon: Delay Connector detecting when
 HPD singals is unstable
Thread-Topic: [PATCH 6.6 014/222] drm/radeon: Delay Connector detecting when
 HPD singals is unstable
Thread-Index: AQHbYE7leQRj7eOuEUSY/1icDnMXsrML/1Gw
Date: Wed, 8 Jan 2025 00:00:40 +0000
Message-ID:
 <BL1PR12MB51447A9FC852D0E8DDCD6C4DF7122@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151151.141567133@linuxfoundation.org>
In-Reply-To: <20250106151151.141567133@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ActionId=b993606a-bdc8-4e12-a35f-09e612f68898;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=0;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=true;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-01-07T23:58:00Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|MW4PR12MB7015:EE_
x-ms-office365-filtering-correlation-id: bffa2db7-1081-4cb1-36ae-08dd2f777d16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?AteAJ/6FqqN6aG/4QNp/wYW+oxHoOJLAT+JBdECqRS17IMkh3v2oA4kXbs+a?=
 =?us-ascii?Q?Zwo7vYUY2ATdneXD7S31VLge7DGbThUXEvYKx/GxLP+LWzxjvk81ORjechfK?=
 =?us-ascii?Q?QgenUnsWwGoHDCySKyVTra9Db//NASoakFQJiuwM0+u8QL5QK4Ed5VGyFKs8?=
 =?us-ascii?Q?dJ0ZnoNf8Iha1mxIzpJrVbxTw1XGfWOs6/JwmI5N8/B4Gub5BWKP3LXss5nR?=
 =?us-ascii?Q?i5EzRwz1poSBccWOAT3krr+QQpnppiWVU4NsaGJiVs0b32sUQCrXBZ9yJGmD?=
 =?us-ascii?Q?J4Wc6u6SdtLwCAWAO3Sp07spfFfOeEl5cWRuQiA3PjZCMWDFFLRzoG01Pptd?=
 =?us-ascii?Q?KSu3vQ4kR9+TzMR+4LX4e2y2/ov42ZHuORXFUqyxSNA528p3c5EnUdOJD9Na?=
 =?us-ascii?Q?cwgfy8ArIJBEEwAwaL3XYHYNgdVFzCv9d3ioluCntPiVep9mXr3TQWdjLDCp?=
 =?us-ascii?Q?HIDlmh87qHDlOCTCoQ7V1hIQaC+9FRDI9xEKG6rVJrMVBpbfhS3QfbeYPfEL?=
 =?us-ascii?Q?fKOio6hurtZtwFXsLMCaSvc5YmyXAVMd765Fs58MumnwLck2BNC+HwdIfbpT?=
 =?us-ascii?Q?8rGa32gfMbHAe/6Wx6Fjl1n1hpYNEKohcELU3bu42geOvFhSvZKEEhHSQTzR?=
 =?us-ascii?Q?1NQypJoaulE7osnnTtGUC86vAeg0mrnlmNW1qWbjnRA7dKqStIpt7aO9gOc5?=
 =?us-ascii?Q?Bb08xbKwVyhMUXaXlJfzHXqUjuTv+/85acNXyAi1icrXwViGxaJhW4O/A7ww?=
 =?us-ascii?Q?j+5EVLQx6XUwkFMEKr7GvjdjyDg9b9kbkuzAYJi+3LuBH6ph+PFRtjmEKl1N?=
 =?us-ascii?Q?0IZT4VuFKTPm7DTNxaCoByRtNY6DvBg26UUZD5addo48zT3iJbWli8jkGWn3?=
 =?us-ascii?Q?L+6CabZToa8K1+t6NaXYRGJr4a3C0tccrwMiYvkQcSUHfy5x5SVxSur9pG01?=
 =?us-ascii?Q?zPxVlnoOC7JoYxPO941xyZ57F+PlKpuOKBlR91SgFXaOPENxKiyfoe8cgTvr?=
 =?us-ascii?Q?+nIVJveXml1sdZ5ga4ke/fz4qQ9ZVAYdzEK3MtpbuPM12Cn6eXaOciHZq8uk?=
 =?us-ascii?Q?utQpM3A51IwwFTIo9RL8assDMdQC5J3W/X6HhRznan0jfyq6jl4LeuNswnGa?=
 =?us-ascii?Q?7F6ODy9wvF1Iy0DbKNqJke80RspXMBz0G1ydAUw/yMsQctqCBMLosVU2Z922?=
 =?us-ascii?Q?6z5dro2KxgZ76QJbz2rTVPoXiaPZwe2Xj+LsIxCv4LkA4KkgdH3QtsaWzJ9J?=
 =?us-ascii?Q?9by9+dx0T+8V6wR+FbHo23jnjslWnplkaGmmDCM3OpAhaUwa5TZRx6v33LA0?=
 =?us-ascii?Q?NVpPW6hu+W6LxwS1Cr5NQm03B0pSmXRJQ6/EymUPrwt68MhVhvIOXetZ72Mc?=
 =?us-ascii?Q?aXeH2cZYb4iJBMkcCFC2/K3RXrZnXbrhvDoMG2oy8sQjg1sy5he6hoSWNA+B?=
 =?us-ascii?Q?wHDKkc66sZHThk6GcqFx1xY8uhZsRjqU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YGHTP3npWlIQAmGEE197sAliEsYzs3oarIph2BDJ7QIt0I2HSUvgzOsv4vz2?=
 =?us-ascii?Q?89TmSMqgjEYq612gWFgFwYVLSkeNpV40kMVTCatHlmUftbKz0ExHxPggqqav?=
 =?us-ascii?Q?hRBiKnB6i4TkAieya00nS94Y21647kX/1X/bcDN4TIy2A2Pe1OfbSr/X81qi?=
 =?us-ascii?Q?/QEtewvcuCsxrKP0CzV+2Xe4oz+X08pItipFXPrpt6XeERphxOfL9lYK2f5s?=
 =?us-ascii?Q?+dQJTYmJ5YMv/b+gbMZBlsGIkyhMia9P6TvyWlAaNMec9Ckp4QOKpcngNwwC?=
 =?us-ascii?Q?iXh77gpBGW2V6Ahark6Zx9/aK5E7FB6xOKCsuzZA6PQkGXW//118PYOYZAHP?=
 =?us-ascii?Q?1MjgGqmbiTr+g80ALHiWLzVHn/j9ZQEweal5S6u5d09bw/PgcuAEyGSBX6R1?=
 =?us-ascii?Q?okkdiCgBhv5+2GYlb/QotiOMBy8Mesyhygth+TCePijfwtVBS9WYaDlqhnbL?=
 =?us-ascii?Q?NGh27m9OcddMjgrZrz6MFexXpFkej476RZfOFC2B7KyfC8MBqNgVdkeILd9q?=
 =?us-ascii?Q?KoDleek5CY+JfxHLhI5GRP48VlVOqBMBslIomy0AME8ZMl/Lb4+6mt9SdgXg?=
 =?us-ascii?Q?BJuRoEKZoujaL7TIEe1/RiGlZOTng6QnxFSkRRHHRhW+Qviu2qG1okBFYLrE?=
 =?us-ascii?Q?o5n1n52IYk67ZKYDYkmW/DU+zi6wF+07yP5jurhOiamwN0e8qJ+27Ghfh3uM?=
 =?us-ascii?Q?naB+bCMIkKYRm7hEp1htxBnars5j286XJyaaXppvRsB6tbuIVPOVIUlHG3H/?=
 =?us-ascii?Q?927UpEGjSVn/AnjMztD7KNDrAaHSYWerOSKM4nAZkWS5Pc8iXq0lWalkLYtK?=
 =?us-ascii?Q?39X5weV7oMrY18pGksfk45jk3gDobOjpIJEotHUfBqmbq9KJ7wSkcVnuzAJb?=
 =?us-ascii?Q?nWO5d+MkYBXKm0WU7XOI2lnQPiRXsPrijFBDbNrz4DwKj5m/oMdPgaa8jYX8?=
 =?us-ascii?Q?FDXIN6V2YK+juFiWPi2hEsgu0yd9B3qWP4Tw2wb/uL/Fhct/Q93g89RRyWy9?=
 =?us-ascii?Q?Z8WHViPczyS6W8LwhcXU53dXrtZSixTIYYKsrCprMC6/Q2/MLRAaRnxY0W1X?=
 =?us-ascii?Q?tzRhZMNDP5Zt7GdOCxfqy2JQj+JlzrKnIjxtz2bdMNH5CSXKtzXoqntFFCIy?=
 =?us-ascii?Q?y0hKEUrbn3piBEucFs5Z1Di4AnHF25vzxeN8IgdYNKHv56NPDJ+GFxGg7VnS?=
 =?us-ascii?Q?+tzh9rsyGTaR3m3STuh62f5OwKXQ2dBIZ8eUdx9pu0TsRt+SiGIjOPgvvt4w?=
 =?us-ascii?Q?3I+Ityqp1ZyEYzzv034wxpB0fkBjt0KZXRTWpg5NOMXeUN2SUgyRGE8ok1Db?=
 =?us-ascii?Q?gcLTO/+Ag4MIMFObN0xuENb8CqAH6Auq3HPFa+Wa5ImmGm333lu1OGeJAFH5?=
 =?us-ascii?Q?B7rPg7+SoJcRl8kRgBvtclXrwT7jjxlOB1ciOI3UY/hMNahcw06UoOF6aDpm?=
 =?us-ascii?Q?rB/VhzFyON1F3txO6HoVSIozHJ7a4N6JUzG1dbLl2EaBvmdQ1nkHFCMorvwy?=
 =?us-ascii?Q?7Why/6mXuVzQeVdKIUKjRtWTxHGbfkBDwCvROYnLDDXgZzJwZsrZmyh6Ki9q?=
 =?us-ascii?Q?rkVuiCKSNie7VrHPKCM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bffa2db7-1081-4cb1-36ae-08dd2f777d16
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 00:00:40.2255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RaPNXDFaCzIXUiaeTbUV4V/58EvUKy2z6VMtnsFCcmb8zZ8sDKSHUt0Crev893PoQdRMkypb0WjhR4b8ENtvKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7015

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, January 6, 2025 10:14 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.=
dev;
> Shixiong Ou <oushixiong@kylinos.cn>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 6.6 014/222] drm/radeon: Delay Connector detecting when H=
PD
> singals is unstable
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Shixiong Ou <oushixiong@kylinos.cn>
>
> [ Upstream commit 949658cb9b69ab9d22a42a662b2fdc7085689ed8 ]
>
> In some causes, HPD signals will jitter when plugging in or unplugging HD=
MI.
>
> Rescheduling the hotplug work for a second when EDID may still be readabl=
e but
> HDP is disconnected, and fixes this issue.
>
> Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Stable-dep-of: 979bfe291b5b ("Revert "drm/radeon: Delay Connector detecti=
ng
> when HPD singals is unstable"")

Please drop both of these patches.  There is no need to pull back a patch j=
ust so that you can apply the revert.

Thanks,

Alex


> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/radeon/radeon_connectors.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c
> b/drivers/gpu/drm/radeon/radeon_connectors.c
> index b84b58926106..cf0114ca59a4 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -1267,6 +1267,16 @@ radeon_dvi_detect(struct drm_connector *connector,
> bool force)
>                       goto exit;
>               }
>       }
> +
> +     if (dret && radeon_connector->hpd.hpd !=3D RADEON_HPD_NONE &&
> +         !radeon_hpd_sense(rdev, radeon_connector->hpd.hpd) &&
> +         connector->connector_type =3D=3D DRM_MODE_CONNECTOR_HDMIA) {
> +             DRM_DEBUG_KMS("EDID is readable when HPD
> disconnected\n");
> +             schedule_delayed_work(&rdev->hotplug_work,
> msecs_to_jiffies(1000));
> +             ret =3D connector_status_disconnected;
> +             goto exit;
> +     }
> +
>       if (dret) {
>               radeon_connector->detected_by_load =3D false;
>               radeon_connector_free_edid(connector);
> --
> 2.39.5
>
>

