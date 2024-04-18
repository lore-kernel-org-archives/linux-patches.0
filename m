Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB537168B0D;
	Thu, 18 Apr 2024 16:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713456503; cv=fail; b=IOOgb862iVieAK8QAnepMA8cm+92m35uCWVUUOzA6D2O2TGxcOEsUQypAzUqgpsoYzbbZYMSTSVIgNRQTFL6z5pod55aJIUfNyE9LUbTIfqpJMWx9eR6/IPvBUqumPawUd2uWYYVN7kJymVcALsIv2Sdh5wva/ruoEIIlBvjyU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713456503; c=relaxed/simple;
	bh=ZjT05snZ3cOQfSH+FY4zFX5L7XBDlAKWTfN8Y8mCwYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QfqIU85nRtTfSDM2lPv5k09BQE403QzmfsBQ2MO+luvLzsBSjnk1EJIXmUq0ZhM/13b9AQEmnnL2Jkob+D5LN7h3YnZwoyTgF/hLYprFpMwg/Uabsy07bQTkFbUIFPQbAXvuUNGbQCm2UDwIxxDCuWm+bpCTiI4w6l5qyH9AT6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OXZn+WPv; arc=fail smtp.client-ip=40.107.236.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OXZn+WPv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLBrItLj1n/tz37zXzmCXg7sw/NznfzoAeFrrEi+9iKaUL7bmEnG5A+SH8G0lADwFgH/jQqJBWpjfsmGYtej6QP38PDucn+apu1yx4m81KrsDlfpud+aO6Q8N7R7g4pzeF5x3VaCWUkNgAqa5bzyJZAem2l6MPESNiZaMm+Fl+51lQSh5Rg57S5X2+Ey6cZktXwXMYNJppbMVef8AbVp52sKUMPrrblaedCLQ9yCDtgt1dsYYMBptFyuaqJ23ef04uLE5QvqhLfgTSw6A3UgtfJ/PZNmJrDU0m5VFImQxUVukrHJHGJEKVnj3qK23uDDrfKaO8MYafxnTB01uQuFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5R7kabeUiqdjqLl0NFW8mjEgXDgoXK0fQDGZZCM/NcI=;
 b=BTh9ZJN4z6Z6VP2rmVxwbapxn24Sc/OJPqYBYbYCsf9aVB0k5hZxZfkKPt2BVIVvCPd7JsvzUETlfTRvniCgdiPH+Ryj9e5d1A+d4c81u6BZdaCA5TeZPrr3EIK4y67H4FKxOJuMTnrS4cZhaEorbuNUEHqF1VRQIgcF3QbbB4bzV7tE+VkOL51Idjpxad1V5jwyjDMz6sYHclDD5GtSAIWvaQxiPoPp/OnpnQ5jEUBcoVeYkO1BG6qKM5PHNKlFDFzBw3un5LfPAgjYg1RjonDwOg3nREQqOlTS947NBQ4VLHosHE+jRoqC+ipxyM9ayZUM942hGJsI+BMMk3ZxCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5R7kabeUiqdjqLl0NFW8mjEgXDgoXK0fQDGZZCM/NcI=;
 b=OXZn+WPvrWLBbfMNVj10vTjDmk/gY6f6vF9vNiJY3jCoZVBZ3xflwWxpe0Osa5TyHvwrELZ+Sm+Xl4FcmZlVtumw8HWXa88FEXtb08NcnHIY50KkrRzCq2jAnB3FQcpar7BfBiw1ajiFFhOSOwaSoDfn6V4MYdx1Oq7ltEcceXXZFpXA2GDW7+o21psN1LnKpcupQJawRO1qs+E22+IMHgKrd0nxabxuZJPGQJOdtIeq9W7JseCsN7ZXapK5NEUqNAHPmABaMh1DZng+XfZDEFj4boyBuIT7FIh2HfeS9y1tyEJevKxndhBgiLHhuuWkHuIGSgdYerfhOL009MRr6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA3PR12MB7903.namprd12.prod.outlook.com (2603:10b6:806:307::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 16:08:16 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 16:08:16 +0000
Date: Thu, 18 Apr 2024 13:08:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v7 2/9] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240418160814.GA3338847@nvidia.com>
References: <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <15db91d8-be78-4aae-8715-3a992df062af@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15db91d8-be78-4aae-8715-3a992df062af@arm.com>
X-ClientProxiedBy: SN4PR0501CA0116.namprd05.prod.outlook.com
 (2603:10b6:803:42::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA3PR12MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: 61e16f07-208a-4554-3ec0-08dc5fc1c18a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3IDsFlg47Cz36xH0e7vLtdJZts9lrCm5D9iawZ8x9sssS+wCbFHAmTyHmu82JjXQ+PBvXFKanHOe9suL1wpF3K4+2hZ1yaUAF4+vJpR2pM09Mizb615g1MOiEWMwxTQOC6uGTcFUAZvv9JBNM301dY2hIRdXF9pOJjMSIrDMAbGczDUJ+w57QkzuvytxZ50B3LRxFA3oedBnWEK4sjwYNZ6lnKz8nVzrj+j1rJz1ZxSW4yJ45DfTfNDqqBNNHZaIzdcPa1g+Ha3nHLkg7vi84OPGXqk4tydC7FRwafelI7LoIMhNjOO/53d37nsQfUqRtNjpf9yM33QeIVzTFP0EXLDOIPhU5/rET+rGsNptG5y9LALTSQDghz8k1Dn0N3TJ8eor64JGnJWaQL9Wxs+rqGv51F+wquMd7f0bMiP9ldZNIWYmEMQ6R8rzl4xDLmD5EoOlHBuQXxlwyppIj5+gvo+cUYkiflRbSUqDrKWvsyimwlgr97waV16rac2EQ3jlpbntviJXC6QY7v1g8vKuKftuThMhsbbR6cRlz8rr+GX6BtF2ExmlBTgQXO87QkIgy1FwnPxC+CSrkgE9plKN4Nh4eLjxIkEFlnB4Qf+43Zf98zJQDvceoX6e3Q5jfv51myvDkKDhaJBJ13uC4Hd53o6V9VNkEmNg5+28O5m9wDM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7PtBIqqdYZhiftVCC697ugp6Xl+VuQBXs/rFI8JFpORCTRIpyV6HQuSWXf5S?=
 =?us-ascii?Q?Fik1RxIkpf+l8/wBV+/z2egbYECin8rYZE3p1NgbvGIUrg9KXgfEw5w1yUFu?=
 =?us-ascii?Q?r7annXn2ricO53NjK1doWL2xHjPRe/rvH1uTOht0u3WqMKsaQ/9EYbgnYinS?=
 =?us-ascii?Q?bxF6cJtodHvU2JubGRFV0Q/n7oLBgl772woMXnfvOIb4qDfZPAoRiCq3+Z+8?=
 =?us-ascii?Q?a0Ui5X00m0Rhf5LNqWreU0GyHQrVXn2DgLcobUeaA9/sjyiOP/9IC9jtcBlf?=
 =?us-ascii?Q?rc5sWi/dqBsTnTW4e1oakO4M5cVAfM7ZkpIUg+8uWijt9JLG5Vtk+6dzEEvC?=
 =?us-ascii?Q?FlljE1B5MZ7cv3lmg/dXtzZh59mcaE0x82IBHacAy9+XIOnRqkIBITAnQ6Ss?=
 =?us-ascii?Q?043teGGwXD78OGBkNFuZpMQZBXxn7D0tUYFH9rC7fAiiZKZJwuSK61pn/3/u?=
 =?us-ascii?Q?3/GBe+78tSUhj9bm2gb93yAWyMfGO0e5yOQ+xXJ+upJVYrjN6rHb4bxQmlhS?=
 =?us-ascii?Q?ue8r/pA9gssoCHH/1RXNw2h1y8CT69RAZSFQRJLTy7UjrXQM2LdfsThM444L?=
 =?us-ascii?Q?m+86qFR2UPJYtYjFQm2dsJgkDMWTCqoJnaYfm1GVfeYNtuUBWS355u/NusPX?=
 =?us-ascii?Q?nx2WSh05JRnPIml3Y3O9+QB1PKVPGMnULLuBVeNk2hOfkG3yFE2+dpMt9HPF?=
 =?us-ascii?Q?1z7X2U+Cw9Mc2n6iEMatwCpAgCI3vJAoHZPca+6aaAB0AbGCHh/+EMGB6c3D?=
 =?us-ascii?Q?tRYp+3sZ8GInQ8oWEvOE+YEGDgceN15wAXdwErEdPHoiV1a2JWc2DRXYjbv8?=
 =?us-ascii?Q?I5dzSkrIoDTJimdwIVKtiCZpz04kgSBNg6HPFg8N+ff5Z1KOUUE37tq+8Ufc?=
 =?us-ascii?Q?yhCL5lpSUsdlWvEoE8lKfaNDqaWzFzvYHst/+bWSK28UxaDhDIHNPNFS3NfO?=
 =?us-ascii?Q?UWF4ACGQEGHtcMayaJYbts/khhELXusdSe83d/80oNFIPIwoP74PYkvNmH2j?=
 =?us-ascii?Q?d18RxSRj26RqGY+h+3ID3jeADhN+Y5Wl0vx+RqXjEmOQQS0E7a7K3rBL0Pd1?=
 =?us-ascii?Q?h0S+dtf8qOoiXQ1NFR49OZZBGV4145MoVdmfwGFZ7xPvIIn+fwZ9EFkltDjY?=
 =?us-ascii?Q?BbrSAZ8nbU4f+fJPNQot/fwFhissM5loRcw3TOgv4xzIJTz7aNT2N2m7EqUM?=
 =?us-ascii?Q?zcg0rvAfw3VxhvdnFeLRFbvd4m22NPgi7aL1hvL7iPLRLTVj3gxic3GU1j8n?=
 =?us-ascii?Q?OaycmM7JG0bGtbC6SRTYo7D9N33z+rDBt5LZ4kifA/EZ93zTHlU68VqcYRXk?=
 =?us-ascii?Q?mkGi0AVys7UAd0tkD17j5AAW0bMs4hUX9xXrlXb/eu1vozHoSLFPoqiCfSBg?=
 =?us-ascii?Q?SbXM1v7HfH9VnadYH6dwMDU1u10x74W0VLSLeA0+JdIW76KHh2t6M6JgiWV8?=
 =?us-ascii?Q?48zZQwqW5Jv6Ctbc4wyh6AzIzls3rl09gUIf4YpKAfOE+Q53RP0CflI4oIDx?=
 =?us-ascii?Q?BaaclIEpy1zsrEl4kjZgEYNgg38acjFP123KOXqfok8GhWNxskTcerXwgc+C?=
 =?us-ascii?Q?c/UbNDKZzEuTQYfvyzc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e16f07-208a-4554-3ec0-08dc5fc1c18a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 16:08:16.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VftjrsS9RlCUSRuZRBYKUS0y5iP0ugTM4GptAOUTZr4G+tlnfcnO2AFlIdWAI/Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7903

On Thu, Apr 18, 2024 at 02:01:31PM +0100, Robin Murphy wrote:
> On 16/04/2024 8:28 pm, Jason Gunthorpe wrote:
> > CD table entries and STE's have the same essential programming sequence,
> > just with different types.
> > 
> > Have arm_smmu_write_ctx_desc() generate a target CD and call
> > arm_smmu_write_entry() to do the programming. Due to the way the target CD
> > is generated by modifying the existing CD this alone is not enough for the
> > CD callers to be freed of the ordering requirements.
> > 
> > The following patches will make the rest of the CD flow mirror the STE
> > flow with precise CD contents generated in all cases.
> > 
> > Signed-off-by: Michael Shavit <mshavit@google.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Reviewed-by: Moritz Fischer <moritzf@google.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 94 ++++++++++++++++-----
> >   1 file changed, 74 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index bf105e914d38b1..3983de90c2fa01 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -56,6 +56,7 @@ struct arm_smmu_entry_writer_ops {
> >   #define NUM_ENTRY_QWORDS 8
> >   static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
> > +static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
> >   static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
> >   	[EVTQ_MSI_INDEX] = {
> > @@ -1231,6 +1232,67 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> >   	return &l1_desc->l2ptr[idx];
> >   }
> > +struct arm_smmu_cd_writer {
> > +	struct arm_smmu_entry_writer writer;
> > +	unsigned int ssid;
> > +};
> > +
> > +static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > +{
> > +	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > +	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > +		return;
> > +	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> > +
> > +	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> 
> They're ignored if the *effective value* of EPD0 is 1, which means you also
> need to account for when EPD0 itself is ignored, or all this complication is
> essentially meaningless.

Do you mean this?

 Consistent with Armv8-A translation, the EPD0 and EPD1 fields are
 IGNORED (and their effective value is 0) if this CD is located from
 an STE with StreamWorld of any-EL2 or EL3. It is only possible for an
 EL1 (Secure or non-secure) or any-EL2-E2H stream to disable
 translation table walk sing EPD0 or EPD1.

Regardless, part of the design is that the make functions don't set
IGNORED bits and get_used only has to process what the make functions
build, not the universe of all descriptors.

In this case the make function sets EPD0 and constructs a CD that is
only valid if EPD0 is available. It also zeros the TTB0/etc values
because they are expected to be IGNORED and the code has no valid
value to provide anyhow.

The comment was intened to be read as: if EPD0 is set [by the make
function] then TTB0/etc will be IGNORED.

I will update the comment for clarity.

The complexity you are talking about must be delt with by the make
side. If we do need to support something where EPD0 doesn't work then
make functions must never set it.

Do we have a problem here? Can SVA activate and EPD0 will be ignored?
That would be a security bug.

Thanks,
Jason
