Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF8E1E0DDC
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970379; cv=fail; b=CH7k/xV8ioUcRFYRsqBfL7tp5aczudkRqs9SUHzTbr6c54JKQku70X3ygBvPkrmv+MJzN4HvcPMU8j1bEfHXkIbAQraTS3QIAa6eLof2jbiC7055lg3XRiR1VUeq7l9yAqVET4ACl6xB0Zi37n23WyYhe3mbJzoU6VmHcq5bH5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970379; c=relaxed/simple;
	bh=Q3ghiaXexeG3mEoFNhsKdLbdyDAnZlv53sMJ3PfUkCc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=elkGTeKMrC+8Z00ipQDdepGNYy5CKqt57R6rCusge/KHLlA7Wtm/S6WJdOMe+6H+jjKPEtl1UQEVq97KhcvOE2EP0goxUd5YeK+Vc41NQ7QImNRJxRYojWAuciEJJt8IJFMKcqul0eQ7TNyArkHnZXMQxajFCfJlaVK86VcTIOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CYtePnx+; arc=fail smtp.client-ip=40.107.96.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CYtePnx+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBr5NqAImQ4Yc5mJ1xqBbNm3MxIHV68u9ACTCLUznezs0UcKTkusRNXqQhrVEk1A8bPCYVEEmasjgdiC4cAQtVOV0WN6yFQYdPBS3LEh2icLsuOI0MrHT5Xm+dxHIV7/9+2t+JHmU9xhmt8lsZDUHDzlR2oMG4tCGOPDOVTnumEcnP8PsebNRLu88JZtGqHjyRT9YtSZydOmfiqwd4hsvtixZFWAQkcd4OUnQtDqa8uwgtNpcjmEAK5NOHfRkeVQdZ1g0PybWvuJllj+VJxlxV9q8FQiYbrYhlPXnYxL9JjXUxCPTNzwGC2fWVR88RkbEcZIjXI9wERibtbJteHu0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cqon8esRIMlkxlVk0JZk4XKfoSpuHq2n02R7oGkuhVU=;
 b=MQg3W5sOlpRI+/ZKsjwjuUGYnEhMCzeYuW7mockCjLQdWy1k9Nk+4EAvvb7PibBy5SZo6OnaWfCaDjd+/RNEyAtdC2zhYNHVM5qDChCDkJtCtb0FTejUCY0XCEKNUuvkUxqabpyyI/xArTE6yeUK5JV8Lj+X+HskPYSIFWaOdNWMXl0UGX0PXT1OQkfY9e3bmzU8LjDw7RX0GQP0FD8LADCE3qX4h6PiHPGFOmY2ghHs4HMuBA/C437AZU0o+sssOYu27XkKL/kBVhYuYHEDsCtrJ1fYaPIjOEVGTtU6iUDarScXI90BwzukGYY9VcQny6RCXSzySoPXLD7D6yf7/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cqon8esRIMlkxlVk0JZk4XKfoSpuHq2n02R7oGkuhVU=;
 b=CYtePnx+FsHzK/6Ne8sovW3jAf7DD6o6GNRswL297Vb3M+F4JXXVjKNK7xfp1wrneu4M0G42SCEVZE0i+uNy48ZXr/m37FLLPyLe2APk5OT6epdqZiPe50+GyBYk1HyWLPjSvZMH/gDLTRtelYzVHegrdYWMLt0rxyAQPwhIG0k=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by CY8PR12MB8362.namprd12.prod.outlook.com (2603:10b6:930:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 13:05:59 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 13:05:59 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Lazar, Lijo"
	<Lijo.Lazar@amd.com>
Subject: RE: [PATCH 6.12 098/230] drm/amdgpu: bump version for RV/PCO compute
 fix
Thread-Topic: [PATCH 6.12 098/230] drm/amdgpu: bump version for RV/PCO compute
 fix
Thread-Index: AQHbgqt9dpJh6H0cX0SEvrTz/nq7c7NOmE7A
Date: Wed, 19 Feb 2025 13:05:59 +0000
Message-ID:
 <BL1PR12MB5144AD9C4847BB7B6E89168AF7C52@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250219082601.683263930@linuxfoundation.org>
 <20250219082605.530543710@linuxfoundation.org>
In-Reply-To: <20250219082605.530543710@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ActionId=eb39d42c-fce3-4c7d-ace5-ab8752b4fe06;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=0;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=true;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-02-19T13:04:48Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Tag=10,
 0, 1, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|CY8PR12MB8362:EE_
x-ms-office365-filtering-correlation-id: 8c19de53-bd80-492f-6d82-08dd50e62782
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?AApn/n1Z7b2JUsyAt8wV9WfH2zjh0CxM/U8uhKlLGTaLtoSHexqCArN7kkQZ?=
 =?us-ascii?Q?zsDMgCyOOlKYOtDBotu/fHsvQPY7YYiAOCRv3zQ7pQmNDIkoA7i5m8wEpEIh?=
 =?us-ascii?Q?K7oPGCkXO9Cg8z0SHb65VIiDayA0F7aG7MsNOh9P02MHBVGlkyo66sm+FK9u?=
 =?us-ascii?Q?LbUnGRFbZDPDMhUUPJkGQFkAcoTh7o7AvMJ5slWuslm1b9lT2PDD09fEmm+Y?=
 =?us-ascii?Q?gqpeVR/TzDFAVAbr/UMucfRc8lVp5vgBEm30xUfn4x1/+yBKsF8ociCVJPpr?=
 =?us-ascii?Q?PHl2nB99KPbvXNDsEO020P6AVXbb/mH0WFkkcFigR+/g5Eb2yK+RQ0QhLvGn?=
 =?us-ascii?Q?WJvWh9LX2VZIUd4PdSTXf56u6to1+8T8DUklz52HDcaWDKKjEjhfhOZ22B/g?=
 =?us-ascii?Q?GpzYuGaCyi2Gqc2jIw8W1H4v+/tODEtnumFySd+77Kjm95wImy3NqUzy36uA?=
 =?us-ascii?Q?TCcRXttBdxDKnzORVprh9YxZCmpn6mwqBEUPo4eSzoOqUo+/O9r/LAe556Oo?=
 =?us-ascii?Q?2gD9jUD0bD1DPdoVfpT4xrxDUae15es4K8r+5uPvy65qMVN1bWu4dO/ACApn?=
 =?us-ascii?Q?tDxqRfd0kvAujViLmqNzXH26qeVpwfBlbe/myqkISfbcU3DH9e9+Hx3eJk8Q?=
 =?us-ascii?Q?FelR+hMREjA7Qoo+Byfu3n85SANr13AJeBVSE7GWvs7A27BXzABbA5N5WvKu?=
 =?us-ascii?Q?XVNYN1NS0uyViiTBDKFd3dTOWlyr4RTI3FqYMaE12g1RWewqcgc3Yd6/9Fc7?=
 =?us-ascii?Q?8Ocmft2CvGnDusDe+xMyq56xIQA33nB1fupq+zbJr6UV0f+kRETWzKQHv4CO?=
 =?us-ascii?Q?ND4QLZSOGzbBvXfpBsn7kZwy2UTA+CVsakmadGJ291KPedGw04d3knHwcLgU?=
 =?us-ascii?Q?Ecz6p1/5s7d/7eQ6jwxyjnR7f3AgOfzibp9UvXfyUJICpDlEghnStk9p/C71?=
 =?us-ascii?Q?Uk3Bycl64w81htdDfKki++QMV+Z2vGE0EoQVLFONWMJFlbDKgMVr/BXMJs65?=
 =?us-ascii?Q?M0US/BOpM5i3nMSDxR6HjgZGGwk8JhFir3ASPYHrdLuI0r98A+gA3WR2XuUa?=
 =?us-ascii?Q?8ni6RFaXOz0GUVX0ptzIQF434D3i/LQBkmzsscEjWAqzwLntrXmnST/0gP53?=
 =?us-ascii?Q?tMLNLSAe6yekIlXXqFrThttlW3YU+n5IBW/KTfT5jGpcesHV0N+4wXlbM85d?=
 =?us-ascii?Q?f2GdMY/lnK+A1NVYbxVWeFprpQ111oj8BmY8PLYL8P7a/k9J+/7IoKm6JuQ7?=
 =?us-ascii?Q?1xlDk/bRqSGs+sacQ4U4jPGcxKoASux0FG5vzqDizCCPR8gZml4PdGmEuvCN?=
 =?us-ascii?Q?Dzmn6Pgs9lFP9MnfVf6ByR+SD4wjXMiaqv8J/i+EThopjgI7eutuNmNzLOYq?=
 =?us-ascii?Q?bNpt+QNcBkyosrgEg76W5rpaGpxMcLplepbX40Kz0zlY3ZeXtY3Mh990ggaH?=
 =?us-ascii?Q?bs+AOtYFcWkNM3o2RGqEYA5cBoxW4iTy?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?jJ5Zdc/x/1zzrZzHFXopZXYu9e1q4H/SWtvkCF1y5oh5HnaUe3ZEse8pqntc?=
 =?us-ascii?Q?gRKj4lnp0ZUv4YL52cLJUKlfanO5erFB4Osr9Vb/yTn3+T45M4dq/AqBw8Bw?=
 =?us-ascii?Q?5aczjEmZvxTWVCGe0yeO26rtVk3B2zPkpIugqZAhd66trVZ7dlLUQ94V84kc?=
 =?us-ascii?Q?SDOiEQUCR4YxqB+pGyn/8w0xpkk4iMUhfLsmcc53HjQDbh5Xge0ebP//Xdpz?=
 =?us-ascii?Q?uHASUPwTUFah5Jcij9nimZE/AvRk+v1eC19WJRiH5+H9o1szXp+VDzhKUOWu?=
 =?us-ascii?Q?wDfFO+IcNRt9Hd9sHdSp0n5uOMCHc2dTliMnovmLOasvmvtxO5j+8EcdRp3u?=
 =?us-ascii?Q?/+hyb6zzMPQC6A7xw2FrYFhzOA8vdT1SbX7wzMXQLFuNe1sHaDwJPIGcnAIv?=
 =?us-ascii?Q?SX3NfeielnaRh/d7ijVd4JWXX44nO9j8JBB62fRzNn62yxMqmecG37JcHteF?=
 =?us-ascii?Q?SID8FBGTYf5UiqTE9O/6Vb5XhZV4H+NYCUi4qjRW+mXAgpErHwPCeiQRYfiV?=
 =?us-ascii?Q?orgBUnF7M/KV5Vf4Iqc90mJvBLqbVRuKhhlDnTpldmhAmeoDrqjIcNmrR8fy?=
 =?us-ascii?Q?JRO+8v5Qpbz9f21X+SjxzebQPn7XS+nsuQ//+ymec7Bui3S3r7mEw9NJSb4j?=
 =?us-ascii?Q?41iLAu2KtzBcShJhrKwLpKkDgVz4eTZg8sLV9+K4jYSNqZo+wL+yP2sZSfzu?=
 =?us-ascii?Q?lRDtdGvt9bArePzJCsMcrnA65paT0AfJAKaKHmIRW4LmrX5Uner4kZiexlMp?=
 =?us-ascii?Q?DrJ6op0Xsv5BwKXkOFQlpCSqMIoWt/O/2kaWgq9j2Pjayva28TQkoy1RRdjR?=
 =?us-ascii?Q?FtnIG/pt8L8VvaJMLL2qNrQYu+cZCsISyf5PbZPDbN8kD2TF3T5vCowdSgCz?=
 =?us-ascii?Q?hS80svS+X+b+pYz+CG7F7pL4t/v6eSHulKWStTu07R8IPkVVVJP3zUwLWNzj?=
 =?us-ascii?Q?QCU2B05J5ad8mas5s42hefIn5EP6cuc3L8vJdTwyc31jqqXd0SjMIMRBo+Q7?=
 =?us-ascii?Q?1FVngTU62AT3rOmr3QweWIR06jbvErW5vPOnb4q6VUSaPR3oa8HY64VdNrPE?=
 =?us-ascii?Q?z9iSuewMNpIpqDJ/1E7N22rMQDl8/jyM7uxPONL0DK4l5DARE1yar7/0j41G?=
 =?us-ascii?Q?OaU0/ViHW7YHOS4NPN0ege3ZMv2wBoljz1DU1cSBvYbXcvXtRbF4QuZhKZAn?=
 =?us-ascii?Q?o3EXFY5FC89d5tC02nzB4jkLuBs9D2I5ORLwDpFK6uS+q+uq5JHrh21erCd3?=
 =?us-ascii?Q?FmTMoZxTBXGEpvcByFiXUABwKkNu8KVfu40FU+XuUJz+1hdfKdk5fkpYqpoO?=
 =?us-ascii?Q?eW/B9rBSQkOcgIoNc5U6GoquCxssE9/iNMgFMkbz+RXO7JeTMf/1l47rdDaX?=
 =?us-ascii?Q?ELC+MyOf0hijaT3kPqTXKIfGFUvo1PbwstNRpYF0J/6pxQSIUpWzz1X+W6F1?=
 =?us-ascii?Q?+RIUK5NnINW6HGkSM9JsvdEoeOHF7aWYkVaxVka9LJdR/J4is5oLhVV3EJzL?=
 =?us-ascii?Q?re3vNF+Gepb398d72X53CkxqnH1SDbjNFStqO8Ycqqi507YF1nAH9fO/ysBb?=
 =?us-ascii?Q?QEm4gJDihcqhyl8rxxA=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c19de53-bd80-492f-6d82-08dd50e62782
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 13:05:59.1669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rD4DaH88aONq29h9eQrFrp2pW/6tRJEmA65TARwmFyUV4PllZZBVgBg0cA67eFc+kxKJe4EqVbJ7c20p/IOrgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8362

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Wednesday, February 19, 2025 3:27 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.=
dev;
> Lazar, Lijo <Lijo.Lazar@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: [PATCH 6.12 098/230] drm/amdgpu: bump version for RV/PCO compute
> fix
>
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
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
> @@ -119,9 +119,10 @@
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

