Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E473112A5
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369807; cv=fail; b=GseLSYkZ7IMgFn2gORylKZ8GYDaTb8G8Fj+guJ5E+OYuKx2+OF9gP1RbJIja0ZQjB6VuGkr4FqHl51A4sluY2ygpmeKqCYBg8Ti/fCs9k3lbV8qsXvFsYULPIkMC7h1fx0TrbhJ8ccHzdf6gULf1dJ62YTgsGS+/ajFKDl6tQco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369807; c=relaxed/simple;
	bh=NUWAiy4KoTiYJvPt5e2TzbTeTI8Zp0BzgFXqcZR+cII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FCEhfvaG4ZrlZm7mCEarZ/f/4xFPn+b4L8a0OdtUiR1s1PYTGPOvzgwz5nncd8ui22pJ6y9mm4tXVMH4v6WkQewm5gZfZcZTp+7Qk3O8GkHHRGYtofRTi1Gg+NMR7gYDivRmc88sUYWKFVGOs/gxQCUUZLwDRBHdQdKfmUesaPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v6MJ054N; arc=fail smtp.client-ip=40.107.209.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v6MJ054N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDG+t9mxAA3irpIiXUl5a6ggS3DyiZmzjW6AER/RYRqWjjxY6cdqq0wuE9UImkqSQ6KonqnWY8dw/UsEmNu+cr7uw0Luek2HJu6Ib6BClZb+ud92YmUuDzqqosGCDjGbFNdSics9kIGAuG4OTMKujJUZBON+zUG0pkNRuXYc3ShqZV3XljDNpk22ZRWxG6GpfqqXqriXBjr6/uDRZVifjzp5dWrLez89HsXLI5cQLOsypkmz1GdohnSwoUB7RXCwIN80iwEmN7xfCDztMHPQPjvsiWp6rz+/tLSbOjQ7CU1I3iKUF1dhKya+0yYzuX0xw04UcRMzFtHxIHYxLKUPSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4STDAb6uA5HASd5QBBGbO6JplUAkaFRaRsF460e/iCk=;
 b=Ood7SyhIExUj5m7mzb8JbnuPo/7wLmQg1rBDG+wPn/RjdIdyPNw0erBb3cm3wM6erPADbjlIsChDmj/J3lQmh52DNFLxHCK6uHVSsfV70PdBQMxp38ZhBTtw64/oXCaYEwlFhMqybJzzPEiQzh5AQBWqkm8YdsjFp6Zb+XWhW0FPx5tb3X3MbI+9uEBZRCu5MjUiV4mpTDXyxQeyAv4a40mvI2yV6fk+Vn7N+4hfqLBOHQPNB31cXExLYXKZvz83I2ASvos0W6BQ/uqMdHJepS9vHOQMc8q1WIXpoxTkTjB8Tw43jxKMNvm9EN40X2HTMlqM8r44YqHcJD4w3WyLJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4STDAb6uA5HASd5QBBGbO6JplUAkaFRaRsF460e/iCk=;
 b=v6MJ054NqF0X1MjrsW5x1anXrT2T2pgQkttjPQ2kqUEKR06oPiS9iDAFJbsw+XQF6/OZ6OpwomQ+naOjrfe3rTIppXsJu49nG5vHmfLdT4je0nY/2JoTPNacziQIJS7L3HmnkrL/U6RAUf3aMA/4ZXGxZNB1cV4h3ufHhBmRUb8=
Received: from DM4PR12MB6109.namprd12.prod.outlook.com (2603:10b6:8:ae::11) by
 CH2PR12MB4102.namprd12.prod.outlook.com (2603:10b6:610:a9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.13; Mon, 13 Oct 2025 15:36:42 +0000
Received: from DM4PR12MB6109.namprd12.prod.outlook.com
 ([fe80::680c:3105:babe:b7e1]) by DM4PR12MB6109.namprd12.prod.outlook.com
 ([fe80::680c:3105:babe:b7e1%4]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 15:36:42 +0000
From: "Guntupalli, Manikanta" <manikanta.guntupalli@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Arnd Bergmann
	<arnd@arndb.de>, Jorge Marques <jorge.marques@analog.com>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.17 209/563] i3c: fix big-endian FIFO transfers
Thread-Topic: [PATCH 6.17 209/563] i3c: fix big-endian FIFO transfers
Thread-Index: AQHcPFYUcWBygJy5jESdoUpnc19h+bTANMVA
Date: Mon, 13 Oct 2025 15:36:42 +0000
Message-ID:
 <DM4PR12MB61091C73069A211C4B0BA6868CEAA@DM4PR12MB6109.namprd12.prod.outlook.com>
References: <20251013144411.274874080@linuxfoundation.org>
 <20251013144418.857494703@linuxfoundation.org>
In-Reply-To: <20251013144418.857494703@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-10-13T15:33:27.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB6109:EE_|CH2PR12MB4102:EE_
x-ms-office365-filtering-correlation-id: b69d9d33-f016-43da-730a-08de0a6e4f11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?kBn0TNVBs+Mm0dm6aV0KWTOaUfFufpjcNKanFvrncit3CFp3RxhafIXL2mAb?=
 =?us-ascii?Q?Q1KE+r3UKADtG0cHush75+heqbBQv+36+HojSyZdo5iSCTTV4KAE/U0Z3TfL?=
 =?us-ascii?Q?KuITYRnphlTIIrajdNaxsysd7XDqSalCXh8X1gDw1QcRraW6V9AzBnuAJ2w7?=
 =?us-ascii?Q?NtM5WDcRiNGULjTj7mNc9LHdobt2FyElPzCdxNWJZi/8lxEvvgjbHt2WSwnk?=
 =?us-ascii?Q?iMtAgDZYNF75M+nd2v8rTEXJDr/ig7DqujY5LHZIsLIyBZsjMVrEoEwjWl5J?=
 =?us-ascii?Q?L2MhImIdTAFES+KAbNTnoqBMvo8dGBCQ36GMiQpNQVXB43UJpqJuoNgcFWFd?=
 =?us-ascii?Q?EAJqWfmBZuG4/Zyar3BgTgN27qchz+u72HsejzuKUxk8E4d3fois1e6Eofd0?=
 =?us-ascii?Q?V0HpJkJF1ug9sNDtBc8DRSxkSP1WyFJFbsSQ8xtt6oxuhEXmMNeF0AY5Yg9N?=
 =?us-ascii?Q?V72y9CFlvU4ZpXYHdOGHBAAzIhlY2EwRGl8oi2oV16SuIm8/wAmqUua7aZEP?=
 =?us-ascii?Q?86aPlXXZ/k5tioo9rSWZs0j0PDn3R9swa8CSMu2dLajlwYk4HD6vm2UIDKkH?=
 =?us-ascii?Q?71zWZXoyJhxq1p2Kyqm4SOH92ZKFWL9VEvr+oNo6O1syMQxnz4ig5eNG6FY+?=
 =?us-ascii?Q?xZkPmKUW0RRw/WJRm9cj2kKKYRdVhM3L5248OUmXkMeNETucaD9eLh4JhmQb?=
 =?us-ascii?Q?G6EKHREowoh4KNJJY7mXCuAvNH8IcdexCxQsz41KkHhe4bg3nwdMW97uVMGY?=
 =?us-ascii?Q?fqnRnT1oihgsBYe0WwZp9j4jd4NHQCNjxdhCfhVH0nThYPeUNUq2AH0/si5C?=
 =?us-ascii?Q?pujqYEtTJ81Hft8BIpde1LK3Y0nHJy+CpZI6edyYvfxzujSrHs0W/7IkfFK6?=
 =?us-ascii?Q?Tnv8dMPv5AMhexUAtnIyK3C7oD5Gt1yX6J+4eb8SSzKURdXqedlBTtZXhCFB?=
 =?us-ascii?Q?mv0RtylURU9/i59Vy8Sa2DX4AtT936tiZ2aWWZ76BAOlzXkgMFPEAFXRiMTG?=
 =?us-ascii?Q?lxg/QdtZO1ZrbzIMto/IFI0jA0EdPoB9jyZ+DE0MFLdcJCR7A+M9Xty7xzoc?=
 =?us-ascii?Q?nIR4GZgcLy8saGSAC8XGOASrItD4wzv53y/wVvEvK44hSI9cUxbm/KQSDpv1?=
 =?us-ascii?Q?zTR4niOVd5OrrvVGAS17E8g4mT+GufWurpQb6BU23fkNaHDdoRgyLb/wj8JY?=
 =?us-ascii?Q?9I+qpdQSEuqDZHHCk9mtzK/hf9SOw+EBHOIa29dOCeEYTaee+bdxy/gurg9y?=
 =?us-ascii?Q?QCIi328Dyvr7gk38Uy13qMwO0KMXs651JNRSj7g1qwD1J/CrQIeYjr7D7tZw?=
 =?us-ascii?Q?qL7ZI4IhZ6DApST3tsU1IIY13OTAtauXiou2L/uvNmMXdBXKcENJlyl3mkx9?=
 =?us-ascii?Q?ISjxm01bxcuYKXhjY6OfMNtf9HaRKdV9aOwdFzQUng/Og+nbKJhyrOmcSizA?=
 =?us-ascii?Q?+ozaRQUOmE/FwXD/9WTeP92KiB0z6LC+fnVQCfDrDy9Fit3hn18aWidthzb4?=
 =?us-ascii?Q?DaFJrIzHZVOoiYeHhXTVluLgPaLsyqlfdUCu/q1LC4+sPSbRU335S/c/Rw?=
 =?us-ascii?Q?=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6109.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?NbOKHEOeoFtT3Nb9Lt80ianXmc7wPQgCpNxf9glEMD6+FmVZ3sBELCPrNt9B?=
 =?us-ascii?Q?nGiLsL75FiqICAr/NJeIlzHOiZsJXpC07QKPvpMfquy1aXDHi0QuQLKWVylj?=
 =?us-ascii?Q?uCTOfypSW7RFgWF4VS21ad9GcQrbeB4HtpcgnzMo7jzI3egUAYIpylbHm5kA?=
 =?us-ascii?Q?dXJj7ew7Oz3E58+BJjtTHaIceE6OvX+Q2/hZA5KRX39N75d5uIf/j1Na+/TY?=
 =?us-ascii?Q?/ta6npZeQvE4cnzbev3Bhk7Ubl+5rtVDsSh26MhLrrOX85bXUEt6lEX7vbYk?=
 =?us-ascii?Q?CidIWHzDGGa8QKDpGEU3ka8rcu9aZCTefhn3sQHjUfgv/1xCmN8aAgjl7KKe?=
 =?us-ascii?Q?tb6AWjdLvycMReCfShCkSS9GLCUTgwEtSHyacPfSdF4Rh2F+OqlNEDcoapxh?=
 =?us-ascii?Q?t1PVGlbcjWCtDcXU0I7jbwh+np822fUGJsdX921uE6PNR1pG5V4z2t5XkSay?=
 =?us-ascii?Q?spQGQP/g9GPpMdFAlW6aJq1+71RqC8eTnjCqWhfdqCNPev88WD2ZUHKbpwA/?=
 =?us-ascii?Q?aG2V1MqmbMKHbDHG+ooZN6g5UBV+so5wXxV8xuZCKAd86D6ZcHPo0e1SsKCy?=
 =?us-ascii?Q?vu4JsUpNZnH2ZkKoYWQZwjncA0s1atB841sKiMDVGXQqSgYwpCFdrTMt/EZ4?=
 =?us-ascii?Q?w/DJB4BzjQgOnZP4sGXJXybMmxszNzf8PcDMpCkcTnQHSKmgz33/EfR2ewe2?=
 =?us-ascii?Q?9gbhJ4lyUONpJF9Hi5QzoKzeK51wsbNrlJKxTA/lqYvn1TpObdh41MYXKNH1?=
 =?us-ascii?Q?GBWThmFCl5YK8rdqFsE5v0nHS4pljfEN9wek8wJsgILfN6dNY4PD7Xqvxuho?=
 =?us-ascii?Q?NL8N4qq3+vrsNngi+SYrjYoLzn4Tk/F2RCNNj3a8BGqyFRm0pyFcjDurTC71?=
 =?us-ascii?Q?bMcjrjDLyHIC6yRFMr9hBx3ZEAVJPgo8RHixk13hXFa6AwYKzpXDf3qrVJL8?=
 =?us-ascii?Q?Q5kLNgliKJel+4mjo9a76VhOngB+Y5od1YtlUiP4WwPMjvQoW8jlurI/lwHl?=
 =?us-ascii?Q?DdUmH9XuVrkYmzUxPBrOaUFE3TmpDaNUAoHwsm6VoNxW8350/hxKoHqXpvLy?=
 =?us-ascii?Q?ePGKgroIbZiGIHVYbovtkqGt50u8cgdlpE76rKVkyjvKdf++Rc65sb7p1J30?=
 =?us-ascii?Q?9xBfxwWyNoo2fynBeYZtmaBiUtp/lTPxfiPT5nK6DazKm8OSJIGGr0HN8zE5?=
 =?us-ascii?Q?9Sn7bQxR4JWZowgpAQbyhELcKfxsQz6zviPU48vHBZA4b5YugZ6rOgaahXbZ?=
 =?us-ascii?Q?MftZRMN1iRQ6XHxYttvzJcFqH3+T2USD1ox0WYjncnDSn1Kt7lT+WIr3TNvJ?=
 =?us-ascii?Q?I6miK7Cm4FPBJE2uDJg5J9dMBzVQzKH8FsiSyhhtAG469SuKMq0tn5454Qpx?=
 =?us-ascii?Q?DGJsxtdiPRe51AIj4RtCWoodfYx4NgqYnmpbFmeXIEIA3hRMTWhEPJjJE6Md?=
 =?us-ascii?Q?000wUJNgzcPI++XG7Zb8u3vWwuqMO8cCspsDxqwEVYbBDYEuuL4kS37OcaN0?=
 =?us-ascii?Q?X2uaQToDqLTwXEcwM9ZTe1FefENLNVE58K8Mn3bJQ2asEkVsgBNb9JdkOkrQ?=
 =?us-ascii?Q?S3Tbhgf/S8naNeCZ6dA=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6109.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69d9d33-f016-43da-730a-08de0a6e4f11
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 15:36:42.2194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZCdU88FfQeIINa+mHkRA9yDBLpoQD/hdlu5dkg9no4ke0qzqO8PJMLsf7NYjomPGwQi5k82NM6y3OpCrRkCWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4102

[AMD Official Use Only - AMD Internal Distribution Only]

Hi Greg,

Please ignore this one - the next version of it has already been merged.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
h=3Dv6.18-rc1&id=3Dd6ddd9beb1a5c32acb9b80f5c2cd8b17f41371d1


Thanks,
Manikanta

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, October 13, 2025 8:11 PM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.=
dev;
> Guntupalli, Manikanta <manikanta.guntupalli@amd.com>; Arnd Bergmann
> <arnd@arndb.de>; Jorge Marques <jorge.marques@analog.com>; Alexandre
> Belloni <alexandre.belloni@bootlin.com>; Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 6.17 209/563] i3c: fix big-endian FIFO transfers
>
> 6.17-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> [ Upstream commit d6ddd9beb1a5c32acb9b80f5c2cd8b17f41371d1 ]
>
> Short MMIO transfers that are not a multiple of four bytes in size need a=
 special case
> for the final bytes, however the existing implementation is not endian-sa=
fe and
> introduces an incorrect byteswap on big-endian kernels.
>
> This usually does not cause problems because most systems are little-endi=
an and
> most transfers are multiple of four bytes long, but still needs to be fix=
ed to avoid the
> extra byteswap.
>
> Change the special case for both i3c_writel_fifo() and i3c_readl_fifo() t=
o use non-
> byteswapping writesl() and readsl() with a single element instead of the
> byteswapping writel()/readl() that are meant for individual MMIO register=
s. As data is
> copied between a FIFO and a memory buffer, the writesl()/readsl() loops a=
re typically
> based on __raw_readl()/ __raw_writel(), resulting in the order of bytes i=
n the FIFO to
> match the order in the buffer, regardless of the CPU endianess.
>
> The earlier versions in the dw-i3c and i3c-master-cdns had a correct impl=
ementation,
> but the generic version that was recently added broke it.
>
> Fixes: 733b439375b4 ("i3c: master: Add inline i3c_readl_fifo() and i3c_wr=
itel_fifo()")
> Cc: Manikanta Guntupalli <manikanta.guntupalli@amd.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Jorge Marques <jorge.marques@analog.com>
> Link: https://lore.kernel.org/r/20250924201837.3691486-1-arnd@kernel.org
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/i3c/internals.h | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i3c/internals.h b/drivers/i3c/internals.h index
> 0d857cc68cc5d..79ceaa5f5afd6 100644
> --- a/drivers/i3c/internals.h
> +++ b/drivers/i3c/internals.h
> @@ -38,7 +38,11 @@ static inline void i3c_writel_fifo(void __iomem *addr,=
 const
> void *buf,
>               u32 tmp =3D 0;
>
>               memcpy(&tmp, buf + (nbytes & ~3), nbytes & 3);
> -             writel(tmp, addr);
> +             /*
> +              * writesl() instead of writel() to keep FIFO
> +              * byteorder on big-endian targets
> +              */
> +             writesl(addr, &tmp, 1);
>       }
>  }
>
> @@ -55,7 +59,11 @@ static inline void i3c_readl_fifo(const void __iomem *=
addr,
> void *buf,
>       if (nbytes & 3) {
>               u32 tmp;
>
> -             tmp =3D readl(addr);
> +             /*
> +              * readsl() instead of readl() to keep FIFO
> +              * byteorder on big-endian targets
> +              */
> +             readsl(addr, &tmp, 1);
>               memcpy(buf + (nbytes & ~3), &tmp, nbytes & 3);
>       }
>  }
> --
> 2.51.0
>
>

