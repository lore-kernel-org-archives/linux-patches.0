Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B41CAAE;
	Tue, 26 Mar 2024 22:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711492084; cv=fail; b=Vt7q0K+UfWgK60eXOusFBmAkweiD+hKJOULM9HvAR2t0plDqC721ZAOozbPcQxMpzVD0DinXE7mejvaLkVCNrCves806cE94VIO37d58zDu+2ZQ1w9YfDdsi1UVGvFv53AdSBClMqHmVWgtrz2W+Ycf6LObpVta/Gs2e4SfvXoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711492084; c=relaxed/simple;
	bh=Bit9vHhudz97y8w6rnHUrK6dSwQOpNYCtkcn3r3DARg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=niGlIi017vrLT6+bJj+NrTs7FbXRE6sTaZHCaqtb1cHtvysJZIn9GKNDBnqiIx65hbs4Amsqq9dN1Q8uYKW8O/NauHfP5i1VgN4/5ioov1HZdf5JTOfzXhmmGeNSzRbghFjQ8QcQ/nzItzJFgpsdvV10rl96kC12Om6PCkB+U+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ee3TkKMK; arc=fail smtp.client-ip=40.107.236.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ee3TkKMK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsqmHXbX9tgsnD/7PANP2N/noB5ihn0LoiDX9HS1I85iTWYQ4e4a79oih3ty8FPT9GRnGqqzdWDnANwDhOmr4LSaZMP59tLhOqSeOQllJH8lr5+X9Oosu1LOa10J5KkfGQfVZ2+xboX3HnV4lGul4ebRPE+2YGjefiU+GJk98+P2QfMCFgzLUlpuKihSKIl5al5kZzg234+eVXKCy7TYUI6EmE+JutIabeuYtOrBF/1HaMficDJzUJU6Oc2ay8XsPgJYW8809445hj15rN5QmvYVOxFRFpaqZkPPX0AQAU9D5lb5pyLth38dfbavs3/+PXKiQ588I6r5hDeZub2q8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PC/U7waw9fQsLqyluO6bmEOsmyQ7OCtoAON1jERZMdU=;
 b=NpQCkMXLgEGzm/1A1qQRS+KirIiCxy+Hr7LXYT8Xm6iQ+YuWuCE3t0NYnvI6luIQFCbhS+X3qgEjLY7A3K5jLtigmMWgmAIyGwoqJNrX8css8MGgdnQW15pKwCnel5U/KJEMZJXJ3xZi0yYcwlV4L34/hrfaEwYVSf0Xk9HE29EPsU2Hti9DGfLTtwk1jjDmEJhXri4mkmdzR7JuCN6og979hPdiqztTAwOfT06W8u1Ma/A4/Ulzg+Y6JT6XK1Ienq0W/Fjw7oYmUlMpHS9BOrSYXRls4y2tQK2fcosHWexB0IBNuvndziOewyIxvV993Zp1LOiKBcNGcj1DSFWXwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC/U7waw9fQsLqyluO6bmEOsmyQ7OCtoAON1jERZMdU=;
 b=ee3TkKMK36erLmr00wanwqXp9KbzeDmEafkmDKmTftRN2oBWH6HvgzJwilBCljCg6x/eyCmJ3eLaR0YbB6ecOFAKBUT8QCliLresSd4uqxzu+Ijo1DEFMZrjbVnHJH+1zwmsCxnag3rcmsPlyrrRG1wNvA3jxqVC66k8gxf9pJiEIqrVleCxaBa+w7KK1IRr4ZQaI/1yhCFMapD4Pn4pvcIUNGWes5TiB11ZIWwh01QMhHl7tuNm2hzlw2RXD0PXV7j0gZaXe1iVvgKQHIX98BqM93Qv8e4BDfEk4i515eJLBdcemncOXSVTmHRyZYwnSPg82hdAJrAk6UhQDcodtQ==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7124.namprd12.prod.outlook.com (2603:10b6:930:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 22:28:00 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 22:27:59 +0000
Date: Tue, 26 Mar 2024 19:27:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240326222758.GB946323@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7S109OKJlRVXiR@google.com>
 <20240326183055.GL6245@nvidia.com>
 <ZgMeNZP08aZu-nVe@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgMeNZP08aZu-nVe@google.com>
X-ClientProxiedBy: BL1PR13CA0096.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7124:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TtsGKxOfoe9N1J3vYTTJxvkt7hu66yTEQRkY2jGNPQW8rxOicQT7Vec4iPF0onBGKHbWPoxIo+RmqqQuN6iBFYyguFJUcnj2RMsCZ7B4o0cMA3Vw5XQwhjjUCeyg2erIYbFtNboWdwEVrKBcPfe7mKUGXofjzyItQcj8EZO2rOzOe9XWtaLrJaUUuisa2p4qI1SARYKLy5Pn0sI0YgtPVzLuHfOr2OQbbWV4FmWY02YHshOhsImj9D1jS7bdeTRDvquutriZVxxDB/TW7sjh/YS3r7ZwZZ0z+h8QO/tNEyG8ZAsae6uOSBRIPY+LN2TJZ0/Wk/izUr+PpMFTUm0PftM7l56D6cdo8HKlex40RTOv2+eKlvWodzSTt7PHFOZXmWAPNJLisEFNCz8AFUuMCgv/22R83XF6RGT5srhvGs5ZnUsbVbVLIUTOPLqmLZonrwpVl0tIL16i8HSoG9AmUTtsWjo1J19AcFmJEyYhrXC0iGwef/JqlO9B8sa5WSl6a5FDYn8evdI6aA4QSpCusg8+Jh6OLSwdzrnpDS3Bk/gLDBBMxqDDeAVH37ZCiIrs/5ksGLTmYIpx1u387DCU5U1SPY2hNjIO1xt4Zu5nT8P07rWDtd88lu5e2qci0gbMVUed6LgYpxfZOwqjTMfvgg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a5XDsRV2JVYzcyIC1Zg/JakrUKUotFgN3w7CSpasU4m7K36CCXSQO1vC8ttm?=
 =?us-ascii?Q?fCCeeTNVaqhxXU3DkwqZf68lnpPbTpH1vdd0Jp+OMF7h8A0HznuJ89MwnycD?=
 =?us-ascii?Q?I+b08fcyKLrWlWC776ha0huw5Eqe/9Se7W7YZ9JbPl0qM39VO9x1HWJW4cKX?=
 =?us-ascii?Q?p6sDV1yhDfbbffIG4PMVv5vKlv0tP/Hw5zG32EvBGNTogLHz9OfeU4sEWX1u?=
 =?us-ascii?Q?ScDjDQOEar6c+BtFjLcossU5L1kZl5RnDdbF7D6vZh71vbv97eRVBcLvPwSy?=
 =?us-ascii?Q?ZX3Wg4+fiNcq7DpNGFoUiStOqNY1HWKuZ8zbOjaGFIRwC9g4bLQsT2NwNU+M?=
 =?us-ascii?Q?xj/m+p8CMWbn0/ha674Kii12nq2gOyuX1bRhnCEiFFkiwD5MAEiy/ojeaoMl?=
 =?us-ascii?Q?iNtT7bNGqkIgP2/lb0EUkxMJgC04QBQEHY3XMSjjDjqrNhMn8VqZlMuF27ww?=
 =?us-ascii?Q?PRNubzVMTgFGW+ZG22LL8YknBReYhviRKZS2Uo5F+V9PVzWthUJ1p7bpAFPW?=
 =?us-ascii?Q?JPt2w4mMBaLiR5boXt2n6RBHeg6wwkyIHmGAxgkGikYbxMySG9PwGZ8r8vmX?=
 =?us-ascii?Q?gsmRey/vSxJKwwVwiYW0IYliR83wxey34qkiHZhDZUsbhjUrGqT+jNkl6YSY?=
 =?us-ascii?Q?BEauYoJXns2c6hXTSEO7WrvKOy4WPTdiqXXAL6H5F017uBCX3BqW/nFP1GO6?=
 =?us-ascii?Q?hmHKJpLz8lF1yLhaXWQpyfv7iW9dKWqhPnwJq6eAXg3LxZkgEM4NRyFdTBTl?=
 =?us-ascii?Q?LXh9wrOCFeTDao3z3hVmBVybMZe4WGux6krnIT+8fl/XZ/ifC0MnJJNdqoGh?=
 =?us-ascii?Q?BCB/I2/PfVRTytKsuRCzZfrq1Hd0FxbNJgAh82QgbDNKWl9DyOCtsb3iNb58?=
 =?us-ascii?Q?A6WAKMDg7mUnvdceqBInVpFIp6LK20bOw2g1cE6kAkBqNYgPrL8JvS/QT99Y?=
 =?us-ascii?Q?7kR9QuOdXMMzvyjMeQFnU50eF49YLk3Aw+0LgCKxoG7F9Zm7TR/Xcl9DuEyl?=
 =?us-ascii?Q?d5qvZzf+wVzI+fRGC/Fxafdx7s8oFkasdZ1Il6GMoiZgt3zDA8ALHQmIyGKL?=
 =?us-ascii?Q?hTKLlgqHo6m7v2cgwqTZNAG7oSq0rn+y72io2hfXcRA60n9Yw0okhzfMpM6m?=
 =?us-ascii?Q?hwter8LiJvYgMphyCJzrYeBkqzlBOS3X3zl9p82hC/gS7PUmDGN7gpzoZhWb?=
 =?us-ascii?Q?dATHe/l49PCtknwDdG+uE+IOWtwIS8RPZshOJhbf/qtYpuMId5+ggxyzZF2C?=
 =?us-ascii?Q?IcmodeFtJZIOu4OWRga67VQVDmkaQxqMLv0Cp06AhT/yr0myyKFuaVAHmgj3?=
 =?us-ascii?Q?re86krSSDGiQQfZ8xuOqX3k9lKFoEc0Uk+CyiDmOC0C+tCNgHxBNKN80xSfd?=
 =?us-ascii?Q?KryslNy70rIU64IMExNFYyPfpZ/N576m2qWw11e8Z4l0lRGkMTAwrekUTXxS?=
 =?us-ascii?Q?JYDVP+L/Xon/TR9OkfiGgpH2znLkEAuWiJhD6diwtNPvEOgeSorcw9fpEDz+?=
 =?us-ascii?Q?ixnGVMRBCA4pNPoAfPe6WO0b/MtFs23mcdbhUGclJCJLpirDSfVAq18evYnq?=
 =?us-ascii?Q?uhEBT9nCOVx6phF9a31yEk8lwkK9o9i8dUGIH35s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e914f9-e432-44d7-4134-08dc4de3fe31
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 22:27:59.9259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUaq9+koA1YcTNvN/bNwxHz1NxgZDNVSaN6ps2p62n4QaomBOSF3m9YLRbRUj0yR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7124

On Tue, Mar 26, 2024 at 07:12:53PM +0000, Mostafa Saleh wrote:
> On Tue, Mar 26, 2024 at 03:30:55PM -0300, Jason Gunthorpe wrote:
> > On Sat, Mar 23, 2024 at 01:02:15PM +0000, Mostafa Saleh wrote:
> > > > +static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > > > +{
> > > > +	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > > > +	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > > > +		return;
> > > > +	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> > > 
> > > This is a slightly different approach than what the driver does for STEs,
> > > where it explicitly sets the used bits. Is there a reason for that?
> > 
> > It is just more compact this way
> 
> IMHO, it seems too much to have this mechanism for CDs for just one
> SVA case, but I'll need to go through the whole seires first to make
> sure I am not missing anything.

It is pretty ugly if you try to do it that way. You still need to
create some ops because the entry_set should be re-used (I mean I
guess you could copy it as well). Then you have to open code the
logic. And then the EPD0 path is somewhat fragile. Something sort of
like this:

void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
			     struct arm_smmu_cd *cdptr,
			     const struct arm_smmu_cd *target)
{
	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
	struct arm_smmu_cd_writer cd_writer = {
		.writer = {
			.ops = &arm_smmu_cd_writer_ops,
			.master = master,
		},
		.ssid = ssid,
	};

	if (ssid != IOMMU_NO_PASID && cur_valid != target_valid) {
		if (cur_valid)
			master->cd_table.used_ssids--;
		else
			master->cd_table.used_ssids++;
	}

	/* Force a V=0/V=1 update*/
	__le64 update = target[0] & ~cpu_to_le64(CTXDESC_CD_0_V);
	entry_set(&cd_writer.writer, cdptr->data, &update, 0, 1);
	entry_set(&cd_writer.writer, cdptr->data, target->data, 1, NUM_ENTRY_QWORDS - 1);
	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, 1);
}

void arm_smmu_write_cd_entry_epd0(struct arm_smmu_master *master, int ssid,
				  struct arm_smmu_cd *cdptr,
				  const struct arm_smmu_cd *target)
{
	struct arm_smmu_cd_writer cd_writer = {
		.writer = {
			.ops = &arm_smmu_cd_writer_ops,
			.master = master,
		},
		.ssid = ssid,
	};

	/*
	 * Target must the EPD0 = 1 version of the existing CD entry, caller
	 * must enforce it. Assume used_ssids doesn't need updating
	 * for this reason.
	 */
	/* Update EPD0 */
	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, 1);
	/* Update everthing else */
	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, NUM_ENTRY_QWORDS - 1);
}

IMOH, at this point it is saner to have just implemented the used
function and use the mechanism robustly. Less special cases, less
fragility, less duplication.

Jason
