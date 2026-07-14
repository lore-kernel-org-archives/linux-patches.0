Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011025.outbound.protection.outlook.com [52.101.52.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E1121883E;
	Tue, 14 Jul 2026 13:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784036813; cv=fail; b=ULfJdhsMNsIO4/fZ8r1IhratM9y2J+kHJtsaALlygeNL3CqE2PQ2EAH3sCAbGn6dHbaHRqwigGaLpmL16IL3dqAlyEye+gIFPUUOFrvQ71QoI/x+x/afZJNe0kM+wQV4kL/3nUzwOMpqpS7Za0ENN6q50SwHq3WpI/iOdOetgEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784036813; c=relaxed/simple;
	bh=caspqDHaQqVI+qKf8ZgHPtFcNHyhVXbpPsthbTydfZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CuezMY5R2IkD9i465EOWMPmnyO4Q5C6GLrAH2gmV4DHParTAQ784m5AYIyqlSsjkzPVCibWXlQF8Q+Yx2jZRXl8L+4nfSWjd/NgGMIgxTb1Fy+0fK4lcaMMNrbBPM9JDAr+ezV8MSQKM3z1PIFGpe6k00PP0L7LqK5HFqEhYOz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kp+DdTla; arc=fail smtp.client-ip=52.101.52.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kp+DdTla"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAMgBEYea3btKdS0bW6KShId4Q84G98PQ9yQc8wY4yD0uhvlYR5Ti2BSeqOC624zKc2REnBPbPW5Sfu8G8mVHRiLX0OGksh+jwihvij0fDvHLGiysaBwcvOio/SPsW/Ps2GLWy+8OFsqQVUJMnUSMajzKn9AQNm95KyXbKnFSQ8w+io9XhcuRpNBUnBgiSGBqZU4ERfAbG8lU/iaNy8TwGlrQB+QNvaQPtSBnYPjyjtsqQEAJJpJRJl8t0b7hy1L9KfQqkWi9BDA4YnkRjq0nXfYy93qqWgPWucmEzcodNMfly/8m6Fej9+kL/cvMEbbWkwPBFMKh+IRipXEK5XuIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uO7ZcxeygHfoavLpHq/IO0JXP3gHEun1Ph7V3mLorgU=;
 b=leHbScS2uxZfeMxAjPITFHP9ORT0bQ6X3mDpMPbTAczLTPLc/QX2PtKlmBzKfaPUNFNkJOuvmPmnnb3jKFd4re8O0eor9EMxy6hldAcfSJJUE7TeMpLW0TnEa9cC12Tw5+vdcukqywwSlP3T/UYy5lSu5omC0FC42CoGpQB1a0VVKFQGJt3IFmfUf3RO6NHDjLxwI+ixflcYKM7dBsOdXn4pmZzQf+ltANus2cI45PrZV1WNIDMwntY8VQg2Ci0GNi+7AeqwjA2RoE7WdLL/Zp47uhAe45ICJrgvZlg+H3Gj6Vy3VZhMFQGJkKuPQu9zD2HvmyzOqzRpfC050ugoQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uO7ZcxeygHfoavLpHq/IO0JXP3gHEun1Ph7V3mLorgU=;
 b=Kp+DdTlaAM8IzkepRNQ8hkPThQ5MqP3n3uLLHptAschvWqJeejIxWr3eRtdb738SKk+W7CPT8nxLE3848qFSfoMUQTaYtM8DhbSDXegthUg7gcnTLLHYu63tpE3mKqBO68TgVqSZfDgoPiXnOuzwqrNLMXQaMFLoJmzRZxbd5MpgUyo1QJhckimiK5PG3KHpfzP18WiQzS7Ipdfi15K1cZAlbRYUapJm6Gx/H+frBNeEnAtS0N0cUrm6DggrAF3t4NudU4XGLLEUoMNqSeVZIBA1tFcu+uqsoixP/wgm48SL7j/pmTB9orF3aEotm7EECxC8JUoyEaYG/sWVInwiOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7233.namprd12.prod.outlook.com (2603:10b6:510:204::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.20; Tue, 14 Jul
 2026 13:46:45 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 13:46:45 +0000
Date: Tue, 14 Jul 2026 10:46:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH] iommufd/selftest: Simplify iommufd_device_remove_vdev()
Message-ID: <20260714134643.GA3695849@nvidia.com>
References: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
 <CO1PR11MB4835796C5B8DD7575E5F80908CF92@CO1PR11MB4835.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4835796C5B8DD7575E5F80908CF92@CO1PR11MB4835.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7233:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c9d0d06-cfc4-4f3c-509d-08dee1ae57ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	JuFYYnARYlL+G5VGMcGO7IXte/SMZWuPDZ6FJqN+L2dtapFxBQuZbtR8F9IcR3zAJ2Pp2yycgP2cbwLGP1cxTCnRwCE8ciOubdWVLG60exN+LkWCpnayz9IKYo2P3Lg6cZTwrYcWUJIeIke7zgK+rRphuDSU6wSn+U5TDUw87Zqby+FEQ4f0ibCWDz/CvTeVfQMlH6VTb2Z+4Osy494IVAFGuNBPMc8/H6KN44//Y8AOT194vrfC0l13RzMw93hVtarTJ9BPbSJKh0odagFU+FaLSFY61Ws2u0qsuCl3zCOJq+Hs5NWLZ4cR3/nQjPIOSkvrMBcMB7ylKY97j9RWPzMIi7BUQShN6aQo8iv0J0hGCTu/PBca2mO+eTdvg1wP1xsFQ78XgJZSLlgSYXeS8QYgFVSVy4b3wUknhV6aPk6wEFVML7d9ik59oqx1wcMMHDhKhd6MGaRf2HXNV61tUg/DO/+Ilr61jgwgM5/qVAVCUMNKCnWsr/E/KgiosZazROe2iAq5mwhebEcCISVMXG6Qp/SpgniHzdPQKWhNceljHHWIl6qAXy9EeKjmtG6sH6KWLUhG+r9QTJ+bDEMQldY2aoZKV5c+J2U2IIxAsXYoS5cnzvAwlUYOdX8AnXjW7z3VpmtDHA3r1DSLkfxnhoiiEN8xEWemQRoUmTrL/Mg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tLSsoiOHeJCHL8WS8oj4EV8ipC5dlyDdo18GqMtin9NqEAW/pIJBT3c+ii5s?=
 =?us-ascii?Q?K2EhIplkf0CxNA5di5KiE6FS1u6ipSWpgX/gnpO3weSp1pplR5Updp41JWTm?=
 =?us-ascii?Q?tfxDgMfxhv0/jmGDJr7CYctVYz+7kl2o70YLEzirBfU2lMC4Tu1VVaSsFZn0?=
 =?us-ascii?Q?ZH1VdHpQdhbCQ3WIjLz0/H4jBeGM0q9KLChfyU/YePGaJCB0AFCtsoG00/aV?=
 =?us-ascii?Q?4XTNV9l4XCRvj9o5x41raJjOrMnIpTVv1zg8+X22442NnvQKroMk0eCXMdL4?=
 =?us-ascii?Q?yK4EThcjUfveAA3OJTcFDK1JCPHrPl6n9XswnXyzFpXCDQMRatHj2WngyunA?=
 =?us-ascii?Q?OMGdb6fXQVCntsr78t1E6mjo0WTykChbZ4mWI9nNHLkwGYcmhxTgn3uJ6xb9?=
 =?us-ascii?Q?h+MifYuBFltb/YgIPUk9OsipSrIS+L5gDM6BBnVc5DtoT7UmoepLUOAtGloQ?=
 =?us-ascii?Q?kSjBeFBdOIpm1saO7bPGvLzUfVt3fnJ9AtvKUmjNeiGI2DNHVQ/wJKxHpKf2?=
 =?us-ascii?Q?D9SddQxWBi2OiJpaLoiBsNocuc8bhoEp9pbvy4u28hvRJM607V8MpmaF3+9c?=
 =?us-ascii?Q?zDHT1cEqewoVaiedzstE55KLGKVyFYZG/Ed+VROtAGlCplZpAQClLKajWjNa?=
 =?us-ascii?Q?iGuX1tV5oP5qGYEpHVwxvSdP3xmQim+cwcwghhTu2IrkcI7wyMQd6A32QNhN?=
 =?us-ascii?Q?Oxe09PtwqH3aUi+YkQg4T6BYz1rTHzQI9dTblcPXw6p5MXqbBYgohMWMW7QV?=
 =?us-ascii?Q?/5gf7bY+rgXAfXhEDyDlklVsD9LJKiGCRC4sdeejpZ0GWtWPFLwzH8IQ28t7?=
 =?us-ascii?Q?hO7vE1D/D1OlEIWpGBUI9lPyi5Gg9bVBoEN2cYi3aho6qyeMJzzis8jz1VNu?=
 =?us-ascii?Q?4VxtK8RV4FL1wMQFedLqYYeAyXishlMyaePy2/P42J1NhEdwYVkSsV1P/NNa?=
 =?us-ascii?Q?Sfym9DWSpj1TYJw8Q3SRCUA99HTOI+xQFouuG/XDxBQAkak3hL4aHHb1hbhQ?=
 =?us-ascii?Q?fld6BVMqjGXCYhSbLCXI2EeDzEQo7OhoaOrW5VFSJRrgMxGnftaBIg3Mn6cs?=
 =?us-ascii?Q?vd4OZ7kwLdxC8WqsGQBfEoFRW6BBupTnE+05YaDp7Msk1PvNWFWc4L9V/Oxi?=
 =?us-ascii?Q?glrvGy7Mzuocw+rlqRqc+02EBKZ+F8+EDyTg8EnSNom7hRusb/3MNHITCXVo?=
 =?us-ascii?Q?Ljf4DX1EHSTf5oyK+ZviK80BgOByK5MoYF5gzR0AYHDN2wFklZMiqkZaBLJy?=
 =?us-ascii?Q?JLs5ZO2IWO795CR5BGYS8oQ5O0hArMhHzdCeLE6aMuZpOa8X0bQ7+ylCy4U2?=
 =?us-ascii?Q?IYD4CrsO76fKjGzfs7UTTHx8ZC6qIiZN36wRxOb0zZc26pAz9n+AZPuiARvx?=
 =?us-ascii?Q?RWoSIfqXsSoNYgtscn6SwGycHTEo56E0aHkRik+BbumVGFB/kChu4pugQTZi?=
 =?us-ascii?Q?gMV7pceE7/2TnzHA1yx3SliZht1qV1buHSaUgkgFqXW4cnM2TVYDfg0WeGyE?=
 =?us-ascii?Q?hSUp89neN0pgCwhU9MZgh7DxP2tMznRgkv8pYzrgCyEpBXSgqfceGxYjgRDz?=
 =?us-ascii?Q?xPERLAJBWFV8VfBgpWdhIHaT65PmKVttKGXxKIDZIZQ8AJe12EphiupKu9Bq?=
 =?us-ascii?Q?fWsy3m7VfJZFRXPP9b876B5kU+P6gaFaotJ6uPBnuE4nbGFsDYHj2kevYMwf?=
 =?us-ascii?Q?QmdOPKPS4HturuqXsS7idjQ+Y5aA2kmnXh4QjPy0HOFf7lYN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9d0d06-cfc4-4f3c-509d-08dee1ae57ca
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 13:46:45.2391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZTbdlKhnYpY9bi1kWqhR+3H6qK+R+1Zw4+AtNVDl/d0dp911RmNayWnKZmVreUQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7233

On Tue, Jul 14, 2026 at 01:11:09AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, July 14, 2026 1:25 AM
> > 
> > Peiyang reports that this function indirectly includes a fault injection
> > point through iommufd_get_object() that was intended to cover the uAPI use
> > of object IDs, not in places like this that cannot fail.
> > 
> > On deeper inspection this can be written using a dedicated helper to
> > obtain a users refcount relying entirely on the xa locking instead of
> > going through the whole get/put scheme. The new helper doesn't need the
> > fault injection point.
> 
> I thought a plain refcount_inc_not_zero() in iommufd_device_remove_vdev()
> could work too, but having the new helper check xarray is more defensive.

It does seem like that would be safe alone

> > + * the object is installed in the xarray, otherwise things are racing with
> > + * a parallel destruction.
> > + */
> > +int iommufd_inc_users(struct iommufd_ctx *ictx, struct iommufd_object
> > *obj)
> 
> iommufd_try_inc_users()?

Sure

Thanks,
Jason
