Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3395B1EB;
	Wed,  1 Apr 2026 19:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775073307; cv=fail; b=i/MM6/BXrMuFPNUqck0egQD1fbr/DTSJuuKJJJ5kgH1mbbOZ0KcCIvflu7t83eTKkN+P5N97VFNGgeoVQGpOdDap/PMEFCt2oikKCUMuEHOOP4g52b7QBuMUWh5hcUY/1J63gXMQdixJYqG1XMyH6z7hDcZk0UA9hN9dN9QUmhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775073307; c=relaxed/simple;
	bh=tufhumHTM5yR27M7ROJCd29vhBy4Eo9B/yX+GypWyNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XOX6jlxw4qA/2ONox4zKYzOY3mjotJzYg0BwOf1NmIpW+MT0r+il7QGSHYGuN4tG5CqB7Dlsld8/pnWRn1jMNjnZbD5pVnNrBHg42NyvT1eCyzVTFyZ14ZiBracK2B09/X3fusWmyrYwpw9xKgukjUS62rPS8eX9jbei//BYtW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hx7HatMx; arc=fail smtp.client-ip=40.93.194.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hx7HatMx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FKrOLSQ7wKqGMv3OgQwM6Ag7uuGaNMMzIZg5Se5QYiZiI65FwCUpQMizcf2+TCkls8V+FcDMazHBBbrWKf/xSLmKccW13gLwN+TmvAt0QZYLWm+3HaKaN5zzlJ0jp98ozEwHpmL9YtrbMRxHg7cL1cadNH+R2jsDpJuS0QWe6DTxXtKzdVf+Jg6qdHjO4O7D9RBEBN9zF19oROCweGgyo8tScAqSTEWD689m75pdF0RAQtqGshuOg+I91US1TEPcMoGIYWB4cdvTEFMoHor/h0RXnKx5BnmEAW8xf1x3a3BiIBJloOqkxGuJcoXHUGZ8cf9XOwTe3jc9bXseiAcYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gJlkNSyk+EmF7plcU2aKy8XkAAmpR253uHlpKN2iUY=;
 b=jMGoVWTI/uYsWoOxBMA5Oq8TDpCFIbGkP568Q/yIxkNByYoVrI1h4sw4f1jZXC2ZIe4KCANBpTU8aMGFSGVHS1Im9pnTW1TpngBo+haGNoIbPIfJc6JQ0DNpOYDdIakujTETnfnr5TFp061Qj3glOEycWItzHmzd03A90f9plpgHyGvbkaiZPI2tE7RntCItIVSYLZm6Skj8JB8VcIaybMYdbLgOY57T+ZwF0NZ1qjKPaDXX9xGzLsVnRoAWsSMSSnG1kykllig+NjjCPuu3cSse/TB6JgzVJq7pzih/QHzfhvIxGUAW71dJ5rPKvA2zs7xRFIQ3aawsVDINQ5nyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gJlkNSyk+EmF7plcU2aKy8XkAAmpR253uHlpKN2iUY=;
 b=hx7HatMxw1O8PXK6RdksG4TiJQUX0ExQuOCZYoetEuueyfSS6K6MzykdGtfbQ2wCqearHE9VXRpJTeEb4X4DJeZaN1BH3/fMqoM1eMrSRgmWRFmkOJsuYVVWEktJuZPBTIvXR3Agdxi3TFiD+3qlrmKY1Jmg+MKG0kI50Soo9kP5oIYjBU8y/4j3tE2+ZgbWPSDQPwS0E/X6X8/q/Rti6tgXs3UkVCat6cs5hKXsnRnSlEbAtGwGQ+vjvZ+FVSIt2fwQkEovLjiMqk13dtFNFo4cf90Ojh42wzCinfrX5DObIGDbwW0F7UmtjGz/23jMxHZX/zpdK9v47oERKru7Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BN7PPF2E18BD747.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6ca) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.10; Wed, 1 Apr
 2026 19:55:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 19:55:02 +0000
Date: Wed, 1 Apr 2026 16:55:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Wei Wang <wei.w.wang@hotmail.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 2/5] iommu/amd: Pass last in through to
 build_inv_address()
Message-ID: <20260401195501.GE310919@nvidia.com>
References: <2-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <SI2PR01MB4393461E48F8CE929313A1A8DC52A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SI2PR01MB4393461E48F8CE929313A1A8DC52A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: BLAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:208:32b::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BN7PPF2E18BD747:EE_
X-MS-Office365-Filtering-Correlation-Id: 480b816c-1650-4e9b-6850-08de90288fcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|3613699012|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AAUUT4lqnXOWD8IqB1Jn23E5mRNV189vVywxDCCco7fV2PPrlfBECGKvEMhrlM5Y7S3RplmhFPyaWO/BecLdd7AreQAit6JVaMrTfuwoqSx43IHQmM4nCV684p2DRDZ0zPFzPzR5di5hADNEOf8aN9kPwvNuqgQuQzN8s/1EPued1+QUQJ6KY1Bp4VFmvUh76FTXZW0IeY2nbPhgHjUPNY0Ur01uCAHk6zItaAD3dgYWy4Kh8Abfu3IoPaApptNUzMJB+zQ2sQsC/OhCQ6nJuSagUitJxgTBq9M58ze4N2aadWgQuhXIYelxBjxT8cfnMPlegLSUug9W3QtnIMXOHz2BV1oa3zykVcBW/8V5L6UOKY5nG7+rPJ113Sxy9wgytXWrX+XpH2HVEJLR4JJAeB1BCJXRT/ns9KOMp4SGZLPYemNhRx73ZaLZDBFHAWqnpwX2Y4AcmcVIS6fKRIPypsB4PK0D+WQ6IkSPchxmeprGAgPLFGjGf8jh5lvI6E742m1AN8VtuaOq3j0eJgfS8k2i+fUrFVO89YcHnHKZt7bDVGOaO/f5DKIJ5tC3cT8bL3on7KVsmpF80jjUyMPbJE0IlfsKdMCl88KkiOGotZ2vNAP9R9CMZ0UNB3/PXx+ot7IeZu9j+SP+mytIU+1iHLh7RZmXq9dptCGdqDXQHY5Bg8DOMM1yhVJ9sUQne7FOOD5myZzsabkEHekiPy/3hufNyvHvUbQhT1HIXTzF8lvx2+Y4YIZVmyuq0Sx7+yu+yGukkmGrSaeVR4pCFGYNKY7hfut3xNtqu/FUtIyUBPk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(3613699012)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2Y2Ky96L1N0TUsxd1NGYkJJVThSZGFPUnRYSGJKNW5nVkNTTzNoTjl5emdQ?=
 =?utf-8?B?azFVK2xOTGgwRzcyUmhpNkFld1lJQmcycFVWdWtGbVE0NktQQXcwSTlsbk13?=
 =?utf-8?B?V3NkLzBXYnh6cnZ0SVUwTDM0UWoyRHE2R25KYjV5Z29vWkZDSkRiT3NPbXZF?=
 =?utf-8?B?ZittYlA3UnI4bzdwcWptTjhUdnpDLzVrTXhwTWRrZ096Zm52bzhhdzdaVjk3?=
 =?utf-8?B?Uk14TFNOZGpLQnc4enFGRnpOZ2JvNFhueWtkWHR1NzZXOGVwQVRncFdLSU5O?=
 =?utf-8?B?SU1Ea2JVUTFISGpRYUF6SlNydHdiVC9Hbzl0MlFHSmVtcXIwWlFyNDI1KzB5?=
 =?utf-8?B?bWZZSGw1OGVlZm5XZ3dkYkkvdEhybmcrNzhRb3ZzaTNhc1lTRVpQQWw1aVJt?=
 =?utf-8?B?bCtQR0xVM0JuWWl6SEdFMWlILy9YOUROM0tLZ01EZitzUjRhM1dhZkNYZnVE?=
 =?utf-8?B?Q0RrL1Z2bFB5N290SmdaQllQOHU3WWVEUWIwb2EyYlhreCsybnp5KzRaK09z?=
 =?utf-8?B?QXFkeThaRWhvZ01lUjYzU2dZcXVXOXVWTGFEb3F4TFlXRHZWVzFPSHNjcXly?=
 =?utf-8?B?Q0ZxUzNWR0xGWkt0Vk9FMGZ5Ni9haDI1S3ltYlp4YjNadTBXK0plV0I5KzQv?=
 =?utf-8?B?MlYyUTlzUHU4MjROc2duUnBHeGUwSjlsc2hmRFNNT2FRV0Z6RUk3SW9RdUsy?=
 =?utf-8?B?ZjBXa1N4eEMzWkt1WU1VV0ZsT0ZTU1JoQk9zMEZ5QURwcm10ZWhMVnJrUXpo?=
 =?utf-8?B?TEx1ZHd1cEhaOTd4WXNmaGhUL0x0WWtTKytRamh0RXFDTDZ2a2ZWejhMZWtN?=
 =?utf-8?B?TnZBTmRNWWh3WFNtVWdPeVV5VjNyS1dUUHoxa1ZYZm5OZ1NuRGpveHJuaHl3?=
 =?utf-8?B?am1LWDJWckhsS0pYRFhSY1pHN3BnQ3ZLaXREVThFbnRoVkQyUjlKNkRaRzRx?=
 =?utf-8?B?NXlPRHNpak5Qb2taQ0o3RkRqRVZ0QU1QSXBCNElLalNxNythOEpvM2pYUWdX?=
 =?utf-8?B?RFBnYUczTndyRkxTRlZyNk96U2c3Vm9sQVFTajJQNTZqelhFSW5sZ01jQkNq?=
 =?utf-8?B?RlNGVjhtRUl2ajdTcTAxaFRKU0hiT0FKWjV1YUlQN2dyZEQ4dzRDajFjMXN2?=
 =?utf-8?B?cXBNTEdNSlRUUklMTkJFM1VkNUh5MWV0KzZmRDV4dkpzWFd3SWVWZzRJVWJM?=
 =?utf-8?B?M1BxVnFmRjBnSnBjTEJadGdLODJVOHBhU0RPMTVOUXpwZWIyNnZvUlJOY3Bs?=
 =?utf-8?B?NXdEMitkamQ4THZJUFQ4dWUwZXRON29uK1hlUDZVR0oxRmJJcGx0STBBaTJJ?=
 =?utf-8?B?dmN3UXRWY3pVRVJBWlJoMFpMa29DMTBianhmQVIyZG5ERUYyWXZST3ZiRmZV?=
 =?utf-8?B?QVJiTHB1Sld4aHMwMTI2cHY2bUoxMS96Y2lva2RiWSs4cExmTTlTMjN6MUx5?=
 =?utf-8?B?UjZQVzlObUFWMk56bG0vVFZFMlZLNm5YZldiUnNkM3VYbjdiaFhNT3VYbFpL?=
 =?utf-8?B?NXRhTFdpZ0VqdEZONld5ZTU2OW9QeUM3ZDFwVWVwejJMb2lseFRFTGNNbHNv?=
 =?utf-8?B?d2I3c3F2UGdNdlJwWXNwem4vVkh1YUZuUlJudjhTQ1BFemtWTUorZ1RpMEt6?=
 =?utf-8?B?TmIzWFRkU28vZXpYYjN4dlRSQWxqMnlXeSs3d3VnYllCTEh0TlhUME9EZkpW?=
 =?utf-8?B?Vm1vY3BwOXNscDhmMGFuc2NrZi9SRVdiY1JJenBKZnE3b0hhNEozWktBRHJI?=
 =?utf-8?B?TWd1UDErM3kyaXU4cVJNQnR4WExKU2pRaTR0MjdQWFNLTnRTbC9Walc0WEcx?=
 =?utf-8?B?SGtDajhqM1NOT1JRb2NSVDdCYUlzVm1LQnMxRlNDODNpQWpHYWMrdkwzR2JP?=
 =?utf-8?B?TW9nampCTWgzcC9ZakN0a3dOcDYzN1BzNVczY0pNVjRNVDZTcTZWYTR3eXA5?=
 =?utf-8?B?VGZENWZVcEM4cElwQTFrY0pBdlZxQ3RlZ1Q3emRtYkFxRTlqdU9wM3BPYlZN?=
 =?utf-8?B?Ym5HSUtJRHVrSUcwcEhVZUI0aU5qR2hyWFNWT2duTThDb1FIc2RycGQ4NU4r?=
 =?utf-8?B?Lzk5RnFxbHpJL043bkZTWmsrRVJ5VGpHanVzUjNlRHJiVjBKMmV0bG5VRENM?=
 =?utf-8?B?bGJHMGZiMW5kUk5sTGhqR05zalpJMjdTVzIxVk1XaHp0ZXFJU2FqV0NEOGdM?=
 =?utf-8?B?dXpreHUzWWU1b0JkNkUrd21YOU5YdTJFbnJQcU5tM0lPRGpOQnZrN0kvVGdZ?=
 =?utf-8?B?Y1ArYS84ZGRROGkxa0FNaUFUUThDcCtWWGRvMHVaejJVSjZYMExWVHhZTTZ1?=
 =?utf-8?Q?0B6TiYgRNygzPBqzq7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480b816c-1650-4e9b-6850-08de90288fcf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 19:55:02.2487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUqsTO40rzbDW3hFaB6FM3I7ShUwf1iXvx52WIV54tQdF8VX43UuP2Rpm2Fmcsur
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF2E18BD747

On Mon, Mar 30, 2026 at 04:03:38PM +0800, Wei Wang wrote:
> On 3/27/26 11:23 PM, Jason Gunthorpe wrote:
> > This is the trivial call chain below amd_iommu_domain_flush_pages().
> > 
> > Cases that are doing a full invalidate will pass a last of U64_MAX.
> > 
> > This avoids converting between size and last, and type confusion with
> > size_t, unsigned long and u64 all being used in different places along
> > the driver's invalidation path. Consistently use u64 in the internals.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   drivers/iommu/amd/amd_iommu.h |  2 +-
> >   drivers/iommu/amd/iommu.c     | 56 +++++++++++++++++------------------
> >   drivers/iommu/amd/pasid.c     |  2 +-
> >   3 files changed, 29 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
> > index 1342e764a5486d..ef4ebecb003494 100644
> > --- a/drivers/iommu/amd/amd_iommu.h
> > +++ b/drivers/iommu/amd/amd_iommu.h
> > @@ -90,7 +90,7 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
> >   void amd_iommu_domain_flush_pages(struct protection_domain *domain,
> >   				  u64 address, size_t size);
> >   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
> > -				     ioasid_t pasid, u64 address, size_t size);
> > +				     ioasid_t pasid, u64 address, u64 last);
> 
> Using “addr_start/addr_last” or “start/last” would be more symmetrical and
> intuitive.

Okay, it doesn't make the diff look to bad!

Jason
