Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421031C3C11
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739972877; cv=fail; b=j0IbrZntIFpfRhGKKWPuReo07nXlyCSKybipwnhf+l8XKtlZPojy3II6wLc4QD2QqArCRtPW0aSvMgdyizl6uj5jDEmXrQG6ale0Zm4nFL2dBRFh/IabBW539DtFdMtqcjO+LdMC4lZzpFblIc71RM404JyUWG1+n1i4zCD3OiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739972877; c=relaxed/simple;
	bh=RNzlmaJpyyCrO3NMmGpsCogVsDVWcGsaTyiJNBhF+QE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qHhPdZiio9Y0s1H0q8sA7ghLjtevC/EKMa2CBHGtrZzt+Wu2eya6usVxGMQeti+5dkaZOGm/JQCGCaskv7b5F8chnRVC0/8BsIMwKwOPXuW6v/5snw5fhzXwGacvHsxM8gxYKCoPKcKR3GDFaaeWzpicxmVCGz70PYCdlp79c6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MkByrD+s; arc=fail smtp.client-ip=40.107.95.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MkByrD+s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJYMrw5faKm2h5atdNil+PhIHg29NDx839yDf0j+ymMOifNXj5XwQeVcYph4ZFdipq87lv7u4LwynwxckaCQTUiW0PltyF7qsB4Q36Tb2K8MTBqPTC0w9qlWN278zg9TeOYRKpaQ5ONxSefjZDry9vSn68zQlZV+8b8eH0YH9yVPGJLZMYeKQmok5GxmEEESc8v6wbCBgR4gGl7sWeglGTPpz7J8T2Vbq+DIIeGH3w2pGt4A/9uni2Qbk/N1OtL2fpRSI2uHhltpyMoI/8vJEo4ByxW/wDJP/EcOO+pJ/Zkf+edyo/U914Jn109m/sjljyhuCBJDB350O5F9Mlz4SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNzlmaJpyyCrO3NMmGpsCogVsDVWcGsaTyiJNBhF+QE=;
 b=ca+ssGVEmyWTo47JJSUnS8qehx11ZW0uLjSJamLgbtTgn+fewBG1xAvJKoP+ADDw7/rYugAIWZGexCZ/7m0wLRkpoPVy7xUHGxU38hitSs1BlWBBKqOO7Fx/V+1F81yPZCFX2CYmUrCtZ5tBYbptDveOt4EDwNUYatCWtm982/sKt6Ut+ruJxl/UUggVyqjxOsEcTcxDoQEyHLZzQzWj1/QH7NkUdrSCMmavqvcL1JYWHvEs1FwQZpl4Fg73v0Hrlh9ljBuBWSeAPKReNNcepmdvb3/Xmyx6+axpQskoZ4/WLG1BlaIDRPZxmxc6XSbg53d3T8A7pneKk3i0mEvfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNzlmaJpyyCrO3NMmGpsCogVsDVWcGsaTyiJNBhF+QE=;
 b=MkByrD+sfc87PcgoH+LjTefnp3FqZKkLL2QBpvV/iaSbLuCPvt4SB8EjqD0cpYRf7Pu1q9qKn66jhZd739kDiyYiOrebnPTnRwUsSMmn1tYzhjSGKjcCXA1E9y6zPf7QRe0t0RHFkmt8w6hs8VdmJaKXVD0Jqk94xLZdXJ/AcQs=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL3PR12MB6474.namprd12.prod.outlook.com (2603:10b6:208:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Wed, 19 Feb
 2025 13:47:53 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 13:47:53 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Lazar, Lijo"
	<Lijo.Lazar@amd.com>, =?utf-8?B?QsWCYcW8ZWogU3pjenlnaWXFgg==?=
	<mumei6102@gmail.com>, Sergey Kovalenko <seryoga.engineering@gmail.com>
Subject: RE: [PATCH 6.12 097/230] drm/amdgpu/gfx9: manually control gfxoff for
 CS on RV
Thread-Topic: [PATCH 6.12 097/230] drm/amdgpu/gfx9: manually control gfxoff
 for CS on RV
Thread-Index: AQHbgqt9ebvu0pfV2k+Yff8WVH0c0LNOpBKg
Date: Wed, 19 Feb 2025 13:47:53 +0000
Message-ID:
 <BL1PR12MB51443E46B702589D38B7BE9DF7C52@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250219082601.683263930@linuxfoundation.org>
 <20250219082605.490351110@linuxfoundation.org>
In-Reply-To: <20250219082605.490351110@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ActionId=560dffb9-69b7-47bf-855a-255045337e1b;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=0;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=true;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-02-19T13:46:51Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Tag=10,
 0, 1, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|BL3PR12MB6474:EE_
x-ms-office365-filtering-correlation-id: e5085f32-112b-41dc-36aa-08dd50ec01ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MDA2RVhOcFJ3a1RqVlBQTE1Jc2hZamIzL2d1enlnNVpLT2lSVHlwNTJWdzQ5?=
 =?utf-8?B?VTRsbmdBSWRUZlJrNHd5T2FtR3dySGNYb0xDem1JQ3hSeTBpVlBXT2x0T2xJ?=
 =?utf-8?B?M1Vmc016UmpGOEZheVdHelM1d2hIQjduUjRUbG42Q0x6d3hINEQxWGZPZmFa?=
 =?utf-8?B?RVRQNVBXbXVsbCtpL0tFcGlueHI4bTV0Q1lHeThKZy9Dd0M0SG5ZcE8vT1Iz?=
 =?utf-8?B?OTk1dVlMTklMOFFBa1BjWmorY21GS2NRZFNPaFZpQVNxb1VySTJFMVF6RVp2?=
 =?utf-8?B?RVNoeVpiRkQ0M3pBZkFXa1JJUkw4eWdtdWhsSmt2QTZiQU5kcTVTVDU1T1JZ?=
 =?utf-8?B?KytTTlYrZnZpaDZKRVh3ZHZBa2kxcVNlNVV5eldmbUxmMENyQnlDZmkrRjlL?=
 =?utf-8?B?QTM4c0h0WnowenR5c0FkdlZ6aTVsV3YvREJjNkFuZnVJcHZoSEcydGpCOGdh?=
 =?utf-8?B?RkhLOWlwUDRuVnRzaDNPdUdqL0d6TjRSMElodGk0OHphb05xNXhvODljaWJH?=
 =?utf-8?B?dWVYMklrMmdZeGM3dFB3UWZzM2RybjNkTkQwR2t4Zkt4dGNHL0lIV0lzeU1E?=
 =?utf-8?B?MFVnYkhzSTFBUjhoRVBoVER2bkJsMTFySVNBWjhPY2hDU20xakZXZTc0Y0tP?=
 =?utf-8?B?LzhVOEpBcGwwUlVMdkxxWlF6SnZNbXcyaWF6VEkvTjlxQ1VVOE8xZmJkdzVu?=
 =?utf-8?B?czc3b3NNSjk2d1RFZDVkQ3N3OTJIakN4c0NLUGxDZ0pGYWtGL2tFb0YwWjlw?=
 =?utf-8?B?M1BKbTU4VGxJaXlXbUxLN2xwQlZZclVqVXQvKzNJdUlBRW1qKytKaktmWHVz?=
 =?utf-8?B?SzJsMG1zRmtGTEZHQ1N0ZG9pMkpIQUVZOTg0MHhGSExac3VlV3JEQU1wNkMv?=
 =?utf-8?B?dUJ1YUpMbW5rdzlvU0lDd3FucnVOaHFpWE9xaktjU21mZENMM21RcUFMZFlU?=
 =?utf-8?B?U2h3MXhucllRVW53V1BIU0ZIdGx1NWFTK3lESnNMa3J6UWdzOVUxQ0xCSS8r?=
 =?utf-8?B?Z3pWTXVEaElkVkhyb0taamRCcEd1WjJ0dDhOdkVMMXF6Z2psZ1g1bVc4NGdV?=
 =?utf-8?B?YzFiL0hGZ3hyN1l2S25qNy9HV0l5WC9HeEhJTExiYkJCdzFzL3cyeUt3VW52?=
 =?utf-8?B?QW5Ma2xjL2Q3bHJaMXRlekk4anEwWGJJblRKRWwvV2RIeStDbGZieHE2WTZT?=
 =?utf-8?B?M3VOS05IdXV1OW1UUVpyY0R4L3hqRnRhNnl0U2tCYWtBbFlMQ2tqd2I3c2dO?=
 =?utf-8?B?Z0o1TFp1MC9Ga3hZczRBNHZCUkFrdU1Da3VYTWYwM1hlR01WT2NkSjZ2aWJP?=
 =?utf-8?B?N3ZqaitUc2ZrVUovR3orZXp5UnNGZHpLMFJEOFgyY3hnRlduRVg1QXB1NTYy?=
 =?utf-8?B?UDhGN2JTd2EzRUs4M1o4eEw4RzJvaTZ6NnBGN3FGRjJEVnBxQ1MrdXFWVnRj?=
 =?utf-8?B?cTBTd1FicTFZREVSKytGWnJsZXJrbTRGUWNyaWRaem85TUNUWmNKZzlqM0N0?=
 =?utf-8?B?dGlNdXE5d2h3NFlWNHRhZWxBM1ZYT2MvRmRySHp1Q3d0azduU0d6b2Yva1Jv?=
 =?utf-8?B?RGF1RWdjL1g2dTNWNFgxbjZVN3hpRnF2UkFvSndBTTB2MEI4dklBQW55M2ZE?=
 =?utf-8?B?VXZJdDZ0a29XazM4K0NXR2NodnZxS1huME5mNnpIYVBlQXNvUEdDZXZaVk9p?=
 =?utf-8?B?Q2ZZcExpNXg0a0s3VGxSb2I3RWM1WlVldUVVL0V1SFYrVDVaUXh3ck55Q0gy?=
 =?utf-8?B?MHdEbnNQcUF2VkpRS3hiNS93bTJwMUNWcWFDcHlCTWE1ZmhDaGF6MmVFc1Vm?=
 =?utf-8?B?KzhFemxxeE5tVkc4Z1krYnlGaW9NUnVMVjJtOGxyWnlIS0orU2NDS1lFRG9C?=
 =?utf-8?Q?fdu8tGzusP0Af?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dnpUbHI3UDNNQjhKdUs4V1NJeEZCUXpmWVFzNWtVVW5PTDhyM0w1dHg0T0tJ?=
 =?utf-8?B?QmJIVzE4QXpLZ2xOU0lCano5cEUyMytVbG5QWGJRb2JDRFFDNHMzclJGcnlX?=
 =?utf-8?B?WWVHYWVPQTR2dFBHakhFSy8xRkJRZnF4bEpJemNjdW1MV1RDc1VCcDlDa0pz?=
 =?utf-8?B?dWsyYVZNd04zWlNwTS9DRmhCN3dVclpaT3dIOXgvUG5XeFhwd2p2cE0vREdh?=
 =?utf-8?B?MGlqc1I0SVliTngvVVVsRGJtRXRqMndHd3J4RVA2NUZ0U0ROU05iZkMzZ3ZY?=
 =?utf-8?B?TE54eEtKSUM4Zy8yeTcxUzEzV0F0czFJUmo2L3NqZm1rRGdEV1gvNlN4QXVn?=
 =?utf-8?B?dUIrakM4YmVtTlhSNkNXR0NKdVJ2R3MvKytxakpMSEVBVlE1V1U2UDFuVnFw?=
 =?utf-8?B?RmFzYUpVQ0p3cFZ1Zjk3dXo4bCtRcjdzNnJmTTlVUVlYaXNYTm4yRDNPUjNr?=
 =?utf-8?B?bENvejIxd2Mzd3dicEVGSEk2SHF3bWlabmR6VkEzL2dyN0xoRERudVhPZU40?=
 =?utf-8?B?bDV4SGJEcWxhU1hkL0Nrd25Hcm9jVDVFTTdOL2VPSmV0UW9QdGpqN3NRUFFQ?=
 =?utf-8?B?VDVHeGtHR1JLRXNqYnVVNU5TbFNTSDlURS83NmRMNEMzNUdmbjZVc3VkMlo1?=
 =?utf-8?B?S0sxekRNSUMxUGVUQ0VmNFdKalBLcFdJUzFXRC9LN2RzdHFwRHM1cXpsYW5H?=
 =?utf-8?B?dHJLOEVKaDk5aXRvTnRhRjMrL0N6TjJlRTg0OUdlV0xXNGxaRkVOM0pDMXZn?=
 =?utf-8?B?WStXUUxWMnd2Uml1S0h2R2hqTmh6R3ZtV056UHB3VWtHRzNkUCtEZ3BKSU1C?=
 =?utf-8?B?TjZTb0JGNy84SEFmb04zdk9KQU5nODM2djlYQnlNcWJJTUpPL0djaE00YmNh?=
 =?utf-8?B?QlZyZGZjbnZPeGdhNEc1R2lSRG5JRWlQT1pWeUdIMUZ3UkpPNWVNeXJERXVi?=
 =?utf-8?B?bXVPcnA5Qjg4N2JVdU0xRUYreXNVQzBGMi9VRERmaVBsVThjWjZyWXZpejNq?=
 =?utf-8?B?NVNpUVIxaC9OVnVKSlhEMld1L0xkaTFLZDFQWm1Zems2TWltTzgzbTQ3U0pC?=
 =?utf-8?B?WHM4ZTdXWm5mK0FITS9GWm8vTS93SjhFZytrQXJwczM3eVFsNEhpNmJtWVRn?=
 =?utf-8?B?S25TdkNONHRla1lRNndsazY1eTMxdnB0K2FFUHJ0em5yc2hoS0R6RFYwVUY5?=
 =?utf-8?B?QzhrUm5zWmFzdXNuUU9Fc1RLS1hVMVRRV0hSVFhDOXRjSmdtTHpOclk2U2JX?=
 =?utf-8?B?Kzg1VStCLzdvVGw5OEVJSk5Oamhtc1gyejh4Z3g1cit6K3MzQkV6b0U2VkIw?=
 =?utf-8?B?UFBHSmFFQklGdUFPalZuZlNBd05sc29hYi9DTzJzeDFrVmZjTFFGQmZJaS9V?=
 =?utf-8?B?SURBVm5sT0VkaDQyY25DbTltU010UkhqcklSTVZ0MUlPSkNwQ3lEdkxBL2t2?=
 =?utf-8?B?Z0tadFFuZlY4K0RjeTQ0S0tuNmxyb0wybm8xMDJENm5maFdaQ2dWZzRqN0lC?=
 =?utf-8?B?cEhibW5wREZXWERuNVJIc2RBMXR2MVo1c3hCQkZBMng4TDNPM0VEY0hnNThl?=
 =?utf-8?B?VFN6RnZzR0Y1b015S3dja2xZY1hRcXp2ZTgyL2Z0cWViVkxzcTNYYWJ2eVlo?=
 =?utf-8?B?eC95ckhkOE0vejFVbEF0NEt3dzBwM05RQU9CWVNkbkRGVkhNd3g1VEdSSVdF?=
 =?utf-8?B?c0gyNEVZRm1Uc0dSdjh2Zy9rRXJJSmxSUnRWWWVETG5wcm14Yjd2cSt2WTIr?=
 =?utf-8?B?YWpCM00zVXE2SmtyQyswQlBMWDVPa2VGSFlaczN2NWVHKzFaVDZyVDlrcVJx?=
 =?utf-8?B?T0FYUjBEanlBc0xYdEhrSEo0SzVkUWFyQkE5elpIYk1sVk96L2ljMVJwRzVi?=
 =?utf-8?B?c0I5TTM3ZER2U1NNRUp5eVlKUnFVMTdoODdwVHNxS09pRWhDTHp4ak9IUUx2?=
 =?utf-8?B?cFQrWFpZT3FOL29OdTdWTDUrYVFoUVMyRUVlU0xiZDAwa09OLzY0RG1rS3hl?=
 =?utf-8?B?THFRK0RrMmVaUkFVcVRSNTV4RGRYbEpNc2owZnoxcnFGUUU1WjZ0SmdsTzFh?=
 =?utf-8?B?NnIwT05pYXdUL3FZQ3R0ZnlHTmdMRG5pN0xWbCtRNmJUZ1U4WlJLTzlBZXdm?=
 =?utf-8?Q?f//k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5085f32-112b-41dc-36aa-08dd50ec01ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 13:47:53.2395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVns+VTlIp3EibyLTmBGpDhE9cT6pLQOiwF9FbgWByNkKPe8+zcvfioVVTr9guhT5MKa+Fe0Xc6WPW+dTKb5JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6474

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNk
YXksIEZlYnJ1YXJ5IDE5LCAyMDI1IDM6MjcgQU0NCj4gVG86IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcNCj4gQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+
OyBwYXRjaGVzQGxpc3RzLmxpbnV4LmRldjsNCj4gTGF6YXIsIExpam8gPExpam8uTGF6YXJAYW1k
LmNvbT47IELFgmHFvGVqIFN6Y3p5Z2llxYIgPG11bWVpNjEwMkBnbWFpbC5jb20+Ow0KPiBTZXJn
ZXkgS292YWxlbmtvIDxzZXJ5b2dhLmVuZ2luZWVyaW5nQGdtYWlsLmNvbT47IERldWNoZXIsIEFs
ZXhhbmRlcg0KPiA8QWxleGFuZGVyLkRldWNoZXJAYW1kLmNvbT4NCj4gU3ViamVjdDogW1BBVENI
IDYuMTIgMDk3LzIzMF0gZHJtL2FtZGdwdS9nZng5OiBtYW51YWxseSBjb250cm9sIGdmeG9mZiBm
b3IgQ1Mgb24NCj4gUlYNCj4NCj4gNi4xMi1zdGFibGUgcmV2aWV3IHBhdGNoLiAgSWYgYW55b25l
IGhhcyBhbnkgb2JqZWN0aW9ucywgcGxlYXNlIGxldCBtZSBrbm93Lg0KDQoNClBsZWFzZSBkcm9w
IHRoaXMgb25lIGFzIHdlbGwuICBJIGp1c3Qgc2VudCBhIHByb3BlciBiYWNrcG9ydCBmb3IgNi4x
MyBhbmQgNi4xMi4NCg0KQWxleA0KDQo+DQo+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPg0KPiBGcm9t
OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+DQo+IGNvbW1pdCBi
MzVlYjkxMjhlYmVlYzUzNGVlZDFjZWZkNmI5YjFiNzI4MmNmNWJhIHVwc3RyZWFtLg0KPg0KPiBX
aGVuIG1lc2Egc3RhcnRlZCB1c2luZyBjb21wdXRlIHF1ZXVlcyBtb3JlIG9mdGVuIHdlIHN0YXJ0
ZWQgc2VlaW5nIGFkZGl0aW9uYWwNCj4gaGFuZ3Mgd2l0aCBjb21wdXRlIHF1ZXVlcy4NCj4gRGlz
YWJsaW5nIGdmeG9mZiBzZWVtcyB0byBtaXRpZ2F0ZSB0aGF0LiAgTWFudWFsbHkgY29udHJvbCBn
ZnhvZmYgYW5kIGdmeCBwZyB3aXRoDQo+IGNvbW1hbmQgc3VibWlzc2lvbnMgdG8gYXZvaWQgYW55
IGlzc3VlcyByZWxhdGVkIHRvIGdmeG9mZi4gIEtGRCBhbHJlYWR5IGRvZXMgdGhlDQo+IHNhbWUg
dGhpbmcgZm9yIHRoZXNlIGNoaXBzLg0KPg0KPiB2MjogbGltaXQgdG8gY29tcHV0ZQ0KPiB2Mzog
bGltaXQgdG8gQVBVcw0KPiB2NDogbGltaXQgdG8gUmF2ZW4vUENPDQo+IHY1OiBvbmx5IHVwZGF0
ZSB0aGUgY29tcHV0ZSByaW5nX2Z1bmNzDQo+IHY2OiBEaXNhYmxlIEdGWCBQRw0KPiB2NzogYWRq
dXN0IG9yZGVyDQo+DQo+IFJldmlld2VkLWJ5OiBMaWpvIExhemFyIDxsaWpvLmxhemFyQGFtZC5j
b20+DQo+IFN1Z2dlc3RlZC1ieTogQsWCYcW8ZWogU3pjenlnaWXFgiA8bXVtZWk2MTAyQGdtYWls
LmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBTZXJnZXkgS292YWxlbmtvIDxzZXJ5b2dhLmVuZ2luZWVy
aW5nQGdtYWlsLmNvbT4NCj4gTGluazogaHR0cHM6Ly9naXRsYWIuZnJlZWRlc2t0b3Aub3JnL2Ry
bS9hbWQvLS9pc3N1ZXMvMzg2MQ0KPiBMaW5rOiBodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9y
Zy9hcmNoaXZlcy9hbWQtZ2Z4LzIwMjUtSmFudWFyeS8xMTkxMTYuaHRtbA0KPiBTaWduZWQtb2Zm
LWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+IENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnICMgNi4xMi54DQo+IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgt
SGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9n
cHUvZHJtL2FtZC9hbWRncHUvZ2Z4X3Y5XzAuYyB8ICAgMzYNCj4gKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2dmeF92
OV8wLmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvZ2Z4X3Y5XzAuYw0KPiBA
QCAtNzQxNSw2ICs3NDE1LDM4IEBAIHN0YXRpYyB2b2lkIGdmeF92OV8wX3JpbmdfZW1pdF9jbGVh
bmVyX3MNCj4gICAgICAgYW1kZ3B1X3Jpbmdfd3JpdGUocmluZywgMCk7ICAvKiBSRVNFUlZFRCBm
aWVsZCwgcHJvZ3JhbW1lZCB0byB6ZXJvICovICB9DQo+DQo+ICtzdGF0aWMgdm9pZCBnZnhfdjlf
MF9yaW5nX2JlZ2luX3VzZV9jb21wdXRlKHN0cnVjdCBhbWRncHVfcmluZyAqcmluZykgew0KPiAr
ICAgICBzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldiA9IHJpbmctPmFkZXY7DQo+ICsgICAgIHN0
cnVjdCBhbWRncHVfaXBfYmxvY2sgKmdmeF9ibG9jayA9DQo+ICsgICAgICAgICAgICAgYW1kZ3B1
X2RldmljZV9pcF9nZXRfaXBfYmxvY2soYWRldiwNCj4gQU1EX0lQX0JMT0NLX1RZUEVfR0ZYKTsN
Cj4gKw0KPiArICAgICBhbWRncHVfZ2Z4X2VuZm9yY2VfaXNvbGF0aW9uX3JpbmdfYmVnaW5fdXNl
KHJpbmcpOw0KPiArDQo+ICsgICAgIC8qIFJhdmVuIGFuZCBQQ08gQVBVcyBzZWVtIHRvIGhhdmUg
c3RhYmlsaXR5IGlzc3Vlcw0KPiArICAgICAgKiB3aXRoIGNvbXB1dGUgYW5kIGdmeG9mZiBhbmQg
Z2Z4IHBnLiAgRGlzYWJsZSBnZnggcGcgZHVyaW5nDQo+ICsgICAgICAqIHN1Ym1pc3Npb24gYW5k
IGFsbG93IGFnYWluIGFmdGVyd2FyZHMuDQo+ICsgICAgICAqLw0KPiArICAgICBpZiAoZ2Z4X2Js
b2NrICYmIGFtZGdwdV9pcF92ZXJzaW9uKGFkZXYsIEdDX0hXSVAsIDApID09DQo+IElQX1ZFUlNJ
T04oOSwgMSwgMCkpDQo+ICsgICAgICAgICAgICAgZ2Z4X3Y5XzBfc2V0X3Bvd2VyZ2F0aW5nX3N0
YXRlKGdmeF9ibG9jaywNCj4gQU1EX1BHX1NUQVRFX1VOR0FURSk7IH0NCj4gKw0KPiArc3RhdGlj
IHZvaWQgZ2Z4X3Y5XzBfcmluZ19lbmRfdXNlX2NvbXB1dGUoc3RydWN0IGFtZGdwdV9yaW5nICpy
aW5nKSB7DQo+ICsgICAgIHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2ID0gcmluZy0+YWRldjsN
Cj4gKyAgICAgc3RydWN0IGFtZGdwdV9pcF9ibG9jayAqZ2Z4X2Jsb2NrID0NCj4gKyAgICAgICAg
ICAgICBhbWRncHVfZGV2aWNlX2lwX2dldF9pcF9ibG9jayhhZGV2LA0KPiBBTURfSVBfQkxPQ0tf
VFlQRV9HRlgpOw0KPiArDQo+ICsgICAgIC8qIFJhdmVuIGFuZCBQQ08gQVBVcyBzZWVtIHRvIGhh
dmUgc3RhYmlsaXR5IGlzc3Vlcw0KPiArICAgICAgKiB3aXRoIGNvbXB1dGUgYW5kIGdmeG9mZiBh
bmQgZ2Z4IHBnLiAgRGlzYWJsZSBnZnggcGcgZHVyaW5nDQo+ICsgICAgICAqIHN1Ym1pc3Npb24g
YW5kIGFsbG93IGFnYWluIGFmdGVyd2FyZHMuDQo+ICsgICAgICAqLw0KPiArICAgICBpZiAoZ2Z4
X2Jsb2NrICYmIGFtZGdwdV9pcF92ZXJzaW9uKGFkZXYsIEdDX0hXSVAsIDApID09DQo+IElQX1ZF
UlNJT04oOSwgMSwgMCkpDQo+ICsgICAgICAgICAgICAgZ2Z4X3Y5XzBfc2V0X3Bvd2VyZ2F0aW5n
X3N0YXRlKGdmeF9ibG9jaywNCj4gQU1EX1BHX1NUQVRFX0dBVEUpOw0KPiArDQo+ICsgICAgIGFt
ZGdwdV9nZnhfZW5mb3JjZV9pc29sYXRpb25fcmluZ19lbmRfdXNlKHJpbmcpOw0KPiArfQ0KPiAr
DQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGFtZF9pcF9mdW5jcyBnZnhfdjlfMF9pcF9mdW5jcyA9
IHsNCj4gICAgICAgLm5hbWUgPSAiZ2Z4X3Y5XzAiLA0KPiAgICAgICAuZWFybHlfaW5pdCA9IGdm
eF92OV8wX2Vhcmx5X2luaXQsDQo+IEBAIC03NTkxLDggKzc2MjMsOCBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IGFtZGdwdV9yaW5nX2Z1bmNzIGdmDQo+ICAgICAgIC5lbWl0X3dhdmVfbGltaXQgPSBn
ZnhfdjlfMF9lbWl0X3dhdmVfbGltaXQsDQo+ICAgICAgIC5yZXNldCA9IGdmeF92OV8wX3Jlc2V0
X2tjcSwNCj4gICAgICAgLmVtaXRfY2xlYW5lcl9zaGFkZXIgPSBnZnhfdjlfMF9yaW5nX2VtaXRf
Y2xlYW5lcl9zaGFkZXIsDQo+IC0gICAgIC5iZWdpbl91c2UgPSBhbWRncHVfZ2Z4X2VuZm9yY2Vf
aXNvbGF0aW9uX3JpbmdfYmVnaW5fdXNlLA0KPiAtICAgICAuZW5kX3VzZSA9IGFtZGdwdV9nZnhf
ZW5mb3JjZV9pc29sYXRpb25fcmluZ19lbmRfdXNlLA0KPiArICAgICAuYmVnaW5fdXNlID0gZ2Z4
X3Y5XzBfcmluZ19iZWdpbl91c2VfY29tcHV0ZSwNCj4gKyAgICAgLmVuZF91c2UgPSBnZnhfdjlf
MF9yaW5nX2VuZF91c2VfY29tcHV0ZSwNCj4gIH07DQo+DQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0
IGFtZGdwdV9yaW5nX2Z1bmNzIGdmeF92OV8wX3JpbmdfZnVuY3Nfa2lxID0gew0KPg0KDQo=
