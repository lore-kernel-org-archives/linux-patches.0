Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA3430EF6C;
	Tue, 14 Oct 2025 07:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428529; cv=fail; b=E5aNVxLFbDQYsjH7mQ9jal1K+BmQxiyfHf9CHLdgRbJiOzFF3w8X7/1jm9+Q0y+mfjr0Lq52IDRAXl9EaoWF8SqR1S7XI0iWjv4hQoTqFGT8tLrSK/YXWK9zo1iF7uP9IC/MoYmlCjnv939Upp0K92HzHQOjZBBiJu5NOdRjn6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428529; c=relaxed/simple;
	bh=E1iN4yFAn690E2rA96fuu1b52+N0/u9DPEP/EWnhKXQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qh46YXqA8ulc/K7YS4CBLjm6FmF4odC6l4H335t6PKQKDk8UHBlHnaVZ7GGECerP0JkflP5cjS/VAM9CXYIgLf9qMinbSdDb1PFx0EfYpBSOsie5qP0FJiBZYkNWubg3HVksDc5bargKf29aPY+XW3YkJG8M/CL6V3aroPhEIsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=keBPIe56; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="keBPIe56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428528; x=1791964528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E1iN4yFAn690E2rA96fuu1b52+N0/u9DPEP/EWnhKXQ=;
  b=keBPIe56PmYUsSo+4ifw2Dl4W36IaD19CwsWSY00KlXI1ux54fdhUGFg
   1BgA4p80I6+sfI5HGNxeFyt0a1jBVptBSJVxk3OSPoetCv543Xk2A+SEm
   nh0T2Ug982IhJUWcoh7LEkCkDFHEOwZdT5GSFYamkq5hNSm9dhqGdePvG
   HrWLoW6E9CWrZpEZ6IpoHCZFiHKPagZxpEGWeb4UpPKdf2rfo7014sXfK
   v+UJVd5T3Hh504lkv/8hgke10hSPfIKfxwAmgNepdaJd0Mftmery7PHz6
   jya6hxrs6t20WIDaBnXrGlKTMcW+A64xi1D00slgcGQWKNHAIurobsTjt
   A==;
X-CSE-ConnectionGUID: nm/cEylMSnSKoHXbT535gQ==
X-CSE-MsgGUID: QKkTczlnRvyziLGUo4PKCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="61790943"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="61790943"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:55:27 -0700
X-CSE-ConnectionGUID: Y7dPRMtpQyyJ8YnqUrbNhg==
X-CSE-MsgGUID: ytIh1Tw0RHC8mOv3GcR5qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="181768966"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:55:26 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:55:26 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:55:26 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.67) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:55:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzjcflMP+epJ3QdcMnNdpd+L79o23iTReDI2kTVX3ZurjFaeUV9PmTa89HiKpIh0BWab3TqPihBX499HG0r9heB8VU3DgrLISfi3Y/uZTbd37M6dKllXOkfpo2TQeOR7Djn9e00P+/J3n2BXDA/tUYX+SgcRr7PT+rmFb3AhBkQ4bGkwEJCiypspNMXOnea8zafsdAKh3vi+7ajpQmeRvnZ3twTOf42Rli9PiuYJKjNYlYZGIpRtSxzgRoA9+jz+DsxAB8WDGVHTFcLDHvd4m/7hft6T5xQRNvpQ1/Mvg8DeZI24TjB+xmucm2koLasRC1mBSA2O/5vC9Ac9UuzLpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1iN4yFAn690E2rA96fuu1b52+N0/u9DPEP/EWnhKXQ=;
 b=QXC9kxnD6Fg1IqskDUMBqFCf5csAqeeYbYbI8w7PCln5tvzBLa3TUFiSsSVedxRtEFlSTt8YQAUYjby4mj1jdKlVNzoU+UNHhRDiI3sthQ/NyUNCRjVxrSqOx2Umbz6K4jzUBphSkttp8cSCuz94fStSKL5r9TZuxVnsei2yXYTh7QGb9m1x/6EH1SnNJUlRE0r390IUFgj1XMPKYdGv4sUG6L1achnlWgFhJh1Km49swNyo8lek9Oj6r8nqiOfUK6QI9H/tCMvY92fmyV1r+rQwB2upLwadX8chTT2C/cjggLAt6iFk21gyLWCfyukqlaMZ95XMKEOQKVR6/U2AlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS4PPF8ECAFAD61.namprd11.prod.outlook.com (2603:10b6:f:fc02::3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 14 Oct
 2025 07:55:19 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:55:19 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 07/10] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
Thread-Topic: [PATCH v2 07/10] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
Thread-Index: AQHcFq6gkoCeMAMjT0yvLQ+OuINuR7TBklvQ
Date: Tue, 14 Oct 2025 07:55:19 +0000
Message-ID: <BL1PR11MB5271C66AF8FC9533D898AF198CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <7-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <7-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS4PPF8ECAFAD61:EE_
x-ms-office365-filtering-correlation-id: 877ce658-8167-4cab-4597-08de0af70522
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?R3yZAvX5fe8WSJlr/jC8D8tOqhlUBfbhzF4LBUQpRZk1Vu1rIDkeX2v21m4n?=
 =?us-ascii?Q?epWUF5Go0ipTKStwPRVN0EYpN3IgchgTHEAUIJni6qJNQiKPDQNEa4ru2uqM?=
 =?us-ascii?Q?6M4WL9mXHANdg6j3HsF/y6v40FgSPhiACACtz0gaVCC41k0FtSYk7V1/Td9s?=
 =?us-ascii?Q?IkJKDu6N59/t1J+jEnnu//ifPovkGTxS+Y8eB/gdbKbqlMJnSago27wm2xRw?=
 =?us-ascii?Q?agbJQGXt8HmIWnvjruntarMtMLem74CJxVcJ0IvcGJWZujNMib674piu4lGd?=
 =?us-ascii?Q?Xd7nFpKolbdmJOtD72pqEXVbHQvCH5N8NN6kh3OfjZDKZdQpaM/8r5UvWZHh?=
 =?us-ascii?Q?gZaCcT5bnHu7uabL/A4wHn5V5+REtZmpZjJGDmP2B0VlD0wg5P4dxRXpcRQy?=
 =?us-ascii?Q?js094s5me+1z/snPeOs3N6wKfCvSAPwXHKTlx2Kd6VSwDWipLc/HClro2oYh?=
 =?us-ascii?Q?7ZqZsgpBkFDX5RIFYuaPb2U2J7zZGZKmUgWXVYp3rRwzH+s7c5pEyV9wIfqf?=
 =?us-ascii?Q?jCCSdIF2+NQyFSdNMJk33vbyTy2tBi43+R50pBMdr6v+gO/z5BTZ/vFLE+ey?=
 =?us-ascii?Q?VNz7o5Wt1EzmHevCTTRQKCvRc8cOfsZkq3zMypTFzowAuCH/OeAj0RR0JFEx?=
 =?us-ascii?Q?NXy98RCBVaijS7sX6QaII4M34MX+FWz/IIUo68v+LBMfjANVOX/MKzZw4Sy7?=
 =?us-ascii?Q?LHZ+9sAjksdxmIhXeeXu+MOKuNAVE2FevmgP6fD9y37SyBYj5z1N5EX1P9Kf?=
 =?us-ascii?Q?Iv+ZKNLed+g3Ct/VQ+zOtFzJq7vPoAZX4FvTn4T8w6o9woPvZzk011OCt0oG?=
 =?us-ascii?Q?MGD+HFjXIgSc/OpQxnox6tv83Kxu9ozweoXT6Dl15GyW9FinENKLG1D+/kcr?=
 =?us-ascii?Q?ajcmL0qDyywiFZw9IBiVSKlNKR1mN8xHDSkVy75DYO9JwvxAMqOXD1bHZaNl?=
 =?us-ascii?Q?p6+GML70jb9xom4BFdYCnDyIE3p27kTOvykgm0z+mYhL7l3NA/j7CsJfwsl1?=
 =?us-ascii?Q?0YbweE18I9BaifrHmDYS9qUD/BX/I7x9CsC7u40N2wvVkb5nGL7KHdOxvAW0?=
 =?us-ascii?Q?Wr3Le35r+JTtfMoZw/ffxka30EsKhtBSbWrsd+R4LCXSumTeq/C1xvZ5r6cp?=
 =?us-ascii?Q?2pfE/Qw1axCise2ufwM2NroSn64bGcyNfV9WWWCzPZULzDpvwonythAkVAk5?=
 =?us-ascii?Q?1ot17mnqeJzdy4UxIvpls/pIRUtYn4MaywqKelvOnYq/ag3nkivazmpfj/63?=
 =?us-ascii?Q?4SIW4OxwzxBQclKmBshFABtyQUufIMvxVpvuMvFYC37I7HACHqSoUFEo7koM?=
 =?us-ascii?Q?aRYjnml8ugx/LGRS2Hw57bMBro7lzhjvLDVDa8OCTZm37XF7QQSxlNxuhFEf?=
 =?us-ascii?Q?NX44ec+TgBthC9iVZ6F12f5PQfH5dD8xBuAnybg4WJV+OAE9gsTWzcw5HU3+?=
 =?us-ascii?Q?UBN+L4bmGi9uZiPeChclq+IukYiwHscbI25qu95vjZDz/sp67pPgYhH2ddPH?=
 =?us-ascii?Q?aqJHmvAGIM1eKAv9hsNQWwATOtQ62bU3dyll?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NyYrDLuODkLduEwh8MAP7Zdx9c4oaNTZklQUv5xOuUhil5iH1FA3ETpCk01l?=
 =?us-ascii?Q?Pg5eMfY93jGLLPxbDqCjzcj8sYeqo4gJ69gwEFobHFU+e89hntpr3fpqShid?=
 =?us-ascii?Q?tMuzfLWRRGE5WG81ZdWdEiZkynGpvAFrPoDtHPWQoMjNTvg3Sw5EbLmBL5Jj?=
 =?us-ascii?Q?WRuSA5OjGq2AvHse0Ju22dQq5VYlHdG5XtYaI6dXus4YXYWaZLKnY9UaeUx2?=
 =?us-ascii?Q?A0DcVj8zDfGfD6uhDuxQgAlo+MJwaypqGY8qBlAa8J7MQdVzbPjZ2YG1b6Ub?=
 =?us-ascii?Q?uMTuxnLWehoYR4n4BXxoVRFhMrtYxcGqmwMCSKnTGfKgcAn89MY8GfD7Aywg?=
 =?us-ascii?Q?ACoDkTWg7P6+/j6b+J1fhpcNiXw5rpvxylMIjx3lbTZZnz8kZno/MdR775Ds?=
 =?us-ascii?Q?+JxPaJTqSk+miLTAjHpqsYmeuCV1LKonyHbuD0i5Je4btIafvk54yVWaI0Nr?=
 =?us-ascii?Q?Ehwu4dH15X7XBlqzo5zVMIHQd1AyTKl4ccbWSgpDDDVmql5GL29c07b1PYFr?=
 =?us-ascii?Q?iab4HpKkvq6QaT78SZLsc6daznL68R7R92h0brZRUI6jcj0YvWg986FF2KRh?=
 =?us-ascii?Q?0qHm3PTtZTBHVoLs+cvaFzgGpQZcHZAnuiZl0hlw/sapaH21ac+RC91cNBPJ?=
 =?us-ascii?Q?4OC5v+3KhBY3qlQ9I51GHeR5md76YQWN5nP8Ydp2gewratV/H7E0l6QdldTW?=
 =?us-ascii?Q?ehdmdOdAcdfgaDPxhmx6lmjt3hnRtsXiiYD0UjB/d2Ruk7VR35vHIaEsqCDi?=
 =?us-ascii?Q?uUW1szjSQVdelw0/DbdRLur0m//0kUMMFX5l+jDHyfjO9cdnUKbxsAlEkJaD?=
 =?us-ascii?Q?NnClyOo3I+za3LKAdSw8rSWCKZhRXhNuJL0LutGPg3ymimTBrtLVUgBJiJMT?=
 =?us-ascii?Q?1HrjKMLrCeWDKHGDH6MO9cdbz+3oMmyz/y7PTSr7TCbqWNdAy9N+REWYuCrD?=
 =?us-ascii?Q?6ui58iQcmipd3nFJmaE5EY7cTLy69x7mO/81pn7aAhLiaYGy955i4OXmzafw?=
 =?us-ascii?Q?8cafPnkaCzqB4CZrvKUJQehUT0coWHmUlbTQx1H72+uRRTjQmBLHL/UmC+6f?=
 =?us-ascii?Q?n1HCwZkFPUIoI6GNk06l3QhpGkDGtzDxW8VLW8s/WvWbVzDAXxRv/FOrVxEm?=
 =?us-ascii?Q?u2nHPCQEPFUIWv5sAMRK1fS/8UwaBIUrrS2b/7x7kDT49DNSfEk1AtcBoKD/?=
 =?us-ascii?Q?WVrp09QgZ1dlbCUKhngEMEhd2LRgzxx0YPM+8R6kkJI/WVZXudAGs82Rptte?=
 =?us-ascii?Q?IJbva3OyvaOMtXjfU1cbGMX0hzwQpECEaWBGjzXyyH5YkA87y/zrD0+t5kb8?=
 =?us-ascii?Q?ynZNAuI69C35blF0aLr4sAiVNz8EwbLwZQhOzrrz0ybh3n9Q0+8ESt59e3sg?=
 =?us-ascii?Q?Qx1FX6ymrXJfioe7ykc9pRu64exm0Xi9d7+zyaFgxiORdEGL50cnoXuaLWfA?=
 =?us-ascii?Q?Oy8tz03fsC8vvqZZvVqBqmWKBcTMCR/1pjdajHQwg82d2ruzOlpCWazOZycf?=
 =?us-ascii?Q?T3LEna/REhJniUYLRDzEMskSDVpHMCygUDWIBSXNWRyLFkX9fJJ8hFI24XmB?=
 =?us-ascii?Q?e2mE5eF7EHvAgZjgGLVxxgRmFj99UM3SVm7gjLG/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 877ce658-8167-4cab-4597-08de0af70522
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:55:19.2086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dDtfHoSeGl8CVTvBucwhsmANLYaaYO4V8fy9nKiw6ekMFy9j68wnJysh53YCFXwLW2YsjRxp0G+xBRpppap7ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8ECAFAD61
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:27 AM
>=20
> VT-D requires PT_FEAT_DMA_INCOHERENT for the x86 page table as well,
> implement the required SW bits and enable the feature.
>=20
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
