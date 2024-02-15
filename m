Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E22053369;
	Thu, 15 Feb 2024 16:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708012903; cv=fail; b=EKbEYFRDwbcTw8N2vyrsKSPgZb9NxmF+dV5JsBxsU00xel4NwQljmQAAWTJZRYiUUelhveuxj8Y2ScnIrUAcEtSgIfYe5aJxVEGXao5elYK/Kid9c7AqXUvX0DvU/5mZSvjbnUZolkyWWeU2EyqfTXWO2r+j/n6JgQUKvijb7gM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708012903; c=relaxed/simple;
	bh=9+r2jikNXX7dY0PqV8wiAMBl7GumKzjQsTvdnVYc8FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bYu57dDZLnmoM/YIvQaoxNt0VpRvK5Plj8Mn7rAKQC0T1CWtYd5GiTsowNQQKLQcxqrEMluz5ZaODxVMoL+ZdDUIaB3Jk2ndzYyq2k24fd+e3PTkVPsEBFtkQYlvEyDBh6NHeqx8mnwqdGhmckmMXD0owLiFe0OgWqOEVrJaZF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YwJ8zT00; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YwJ8zT00"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoZPNoBKRlWbMEViJTxgqWTPH4xjQ288CgdmEfrDF4NbwX98G2ysqCBXJJzIF8pUjqqWK5I7jbl28xVPNPdwatjmf4vLAkOC19J5TFaCWejrMtvvJretjsF3bu29iA+2fsSWkVESggqNCPfxfFp502YYZlSbuGYSB5iujYz/9BTLf5ymQkExF0aJNu0iEAlfTvG8VAmIoJQ2eRNlIE1+v/7oNo9n6jVk52UU/6LqZKLksvl1cdEiuByZtrrUSufr4i2myBjqJF46sEna40WwH7IrEx1bfWNdOp2tA6UaOgEHioymAj5ohKmq/aWiEiPZu0CRQom8VpW042ji9mthZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4j5H4/KeqXSVo0BRjkvLtd0ydsS2KV/lCNs3Tm+IoI=;
 b=J+AE83zSVAUNbkdn/kwQSHrch4GgANsXErpBpIAChPjraSjZknBNVQYH3JUofnvbh2Ufp5RWqeSxMPLp/qmdVPorTBgiLci3Yz5cHhQS1lvGOwdMvXboiL2OJdESIKznMe9cIo9s/Ev+Rvpsk+70LsxXEUSOL+i7GPb2xd/KNPTUC0MTW2Hq0lSYpskacvrRkuRji1oEkOKNhfY17netceXevnq7aoeuv+eIAW76AWbVYO4stsEudZtbhoDKa6qSBOr1cIOn795NiTXE1IzwQ5ww/664OqftDHNCbJsv/h6FWbUYEF3g5FG+7pV906/mCCk5QkAtLJr3HnPdJoQ5hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4j5H4/KeqXSVo0BRjkvLtd0ydsS2KV/lCNs3Tm+IoI=;
 b=YwJ8zT00CqJKQRmTQsNl4chVEX5fd4Z0iFnNstphPznBNYFjwH9N6kCZ2gx9PPZSuCyEEW/HxQ1OY1c+loUX5ryVGo6MpvRU+wBodXg0ckaeCxTfIa/TmRncY3AFCN4OMsBpQlbX2ZooyWSDPDXP14/wRhQ36JuudBBuW6AWEtnXH85rCPI+kl+cOpb0xFF9SjbqX76dzyC5TfRs0eQlNRzlN8CsM4Pm9TSB+TwxvlUB598B87SvPXd3owST0rf/1kew0KyBv1JkawcOB9N6Bi60wZDldHYdQpzoX5qXQd7/i1cEcwK3kEtB6O31pXqT+4nf/sYTqwyJBrhTtk5hBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4427.namprd12.prod.outlook.com (2603:10b6:303:52::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Thu, 15 Feb
 2024 16:01:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Thu, 15 Feb 2024
 16:01:36 +0000
Date: Thu, 15 Feb 2024 12:01:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240215160135.GL1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215134952.GA690@willie-the-truck>
X-ClientProxiedBy: BLAPR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:32b::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4427:EE_
X-MS-Office365-Filtering-Correlation-Id: f6916695-729a-4be3-6558-08dc2e3f62fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	10gZxWYBBl7GiAuO2XwUjwf4G/xBa0HPULSdPqFd1tUsZeMDzSR9qHRPGqwVr06FFD9YYWrDWbPx2ml4gAmS671DeqDGFt4o0YOdYJ7oh+oWVDShZ25aBdn1rwRrR3P+HUK27D1gu6XVFI0AtXoWW23C5Dr4Zjoo3DAAQvQ2VNmd3xx15FA1I/9y9YNlJW3ovMgUp5Xp3wKS7UiKz91/McMzaXxp7DCAOemZoa51uenvk4JcNzJNsApkAncCKdCaOVcQrpj5nw3f2zFqBGwJ/3vtTTv7XWdpYQEYbCHhl69cBwK88bASZ8L0UoZ460XS8unuEHFvvPHPPvD1S7FamAXq5jFhhL7B7v9ywn8r8Le9/h0gsCL5gebPew6WqFZihRrJ+5IBnWeWC5iYQwu4mo/s0a/Ngm7EUbcOxVibF8vk6FjL3TtOQe9EUcNw9VoWcdYcFJ0k0mGCkuspQDoEO4IRT0trLlDHwactpmObzOk0Hk+BaFuk0oXcN0nuY7EE+d4P7Gg/ai2CkdVeJ++VOIHl89SwUvcVpZI1RKRxHXYJ4Tyzls+/FZq34/Zqv9rV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(2906002)(7416002)(5660300002)(26005)(2616005)(6512007)(6506007)(6486002)(1076003)(478600001)(41300700001)(316002)(83380400001)(54906003)(4326008)(6916009)(66946007)(66556008)(66476007)(8676002)(8936002)(33656002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cxEnHLXORV3yO+oxj11dXCmb1/tQfUJV2Z9JF6A3XWqyAT+gcGLsRTp31Gp9?=
 =?us-ascii?Q?OySSuYNq98VSimYz8jLeca1011a2qvmYr+JY5QJ8JR6ir/ueDJBAmbY2eTXh?=
 =?us-ascii?Q?pXT1JoWt8QY6XYZC2/NhpW1HNYl05IlBPy7MqLJSUxVxXLAx1NzoS0cALHg9?=
 =?us-ascii?Q?jULHpenCZvz/LGE5c0KPzlurqBaG1aeaxf/5Z7uXHCJlhar8vjXHl59xCTV5?=
 =?us-ascii?Q?zOjZ8ZhUOtSd5YoamFZEPnCjYT03ss0+sQCWGtcHeFYQWZa6RnBemZUGLKLl?=
 =?us-ascii?Q?5ppWQDmqYog8FKYGhGiZqyggG36HbLrVmNY3z8xcYqGvE2/5VbhwmWUIf8X8?=
 =?us-ascii?Q?+/bHMpYC+3lLk0tmlFnBPTxWkLxVC6ZilHHVxeQr2xoAxiSWLo1Go99G2+MZ?=
 =?us-ascii?Q?3SQheTkyCXuWbX0aB8za7e4/hRDEB/RMp0Z9pOpsUOePMI8WcL83T9ZVKYue?=
 =?us-ascii?Q?yq3FekaLymXWAXLtvljlCYSeA25mrdHO72+2TEeUW1ZKYitnqJmP8sgNSq0T?=
 =?us-ascii?Q?n56wu0+LaSnSPQuGTE0dWjybjQgHSuP4YJPJG4mQu3AXmKeMPLRMwxAoa+ky?=
 =?us-ascii?Q?GU3FLllCDDNhw9ppu5PODBCbjFjROtia1uSXUgtlj27vJvHdH8okM4GR+DBl?=
 =?us-ascii?Q?ZFR8Zq/zJTWpkFSDhx3ufewR+SCD4iSTh6q8b/+ezGbotoJVSSlBxb78Dppd?=
 =?us-ascii?Q?p+TtrRk6Afxu4solTe1Qm9KL/92ysDL1c19QEFtON1LoFikzHzqD6NvAU0we?=
 =?us-ascii?Q?vKrZTZOsQRoGTr7B2MnfZPSXZGDMvjgyB4n+hAySbwuyCmWGgR04PB0WvkAy?=
 =?us-ascii?Q?TJPNHvHL8Wqig1QDL7fWVA0zZpj3HqiUS5Tgb7lz0Zvd11je7rjuhs3yAtLl?=
 =?us-ascii?Q?F0k/yKbkRyp9G4oZnJ8Nja8Z2MHm01YgqfnZSqMFk+VhhJw0h8zf8NZ2eVM9?=
 =?us-ascii?Q?xx26CJ3Vs22fcyQCTfSpY/J9dcURFIidqCw/nsAtMHWawI3404dt1vy+6hl7?=
 =?us-ascii?Q?4zNJLRgNs2Pp2VNFFth7lvFaLfOwweXADJHHLIIl1NMB4Ad09lvsOjO20OYB?=
 =?us-ascii?Q?8FpSt6M5ORDl8oaGR2HCc51D8dUVe+cC2c1kBkDkdNMj83qSgSsnjsNXxAGT?=
 =?us-ascii?Q?9ZB9ErEitg2SBmjP4Rh1tRe8zCQhj6pFihGdQ9N6JGteQ+vRU4aChrR06ohI?=
 =?us-ascii?Q?yLdXVN3RSOWAL+0K5hQsGCB0wTWqt4Ir5RGSi/UlczdeKpdX1UHO+JGFfmnf?=
 =?us-ascii?Q?gjGnYGFJ0U3IWZMFKNZ3YKY/hWZwNJj/5yFbeZHZn9uZU9dmAVahnPib7FTx?=
 =?us-ascii?Q?FKZ8FAOOwYVQ16rcohjnNEVFtydJ5lvBjAqRpdZ8rAq/0JTOVhyAp4SzxmqV?=
 =?us-ascii?Q?Bt+jjg5s0lgqa6Bs7A9a9GOLuEkdGWEuhcxdx7lyJEQvYt6fmJ7vvQqkSs3Z?=
 =?us-ascii?Q?1Dp7S/r8qZxjdWcb+8uEDEGdXsrmUvXVDbgWfk+TPzvTceptYL5y1NwKs2Io?=
 =?us-ascii?Q?b2U4Zacipaiv2ihmYtyWfkBhZ/uNH2kAVb62OA6M3OHNgfs1VOwOeaBX6Ksz?=
 =?us-ascii?Q?WqZJ0CxjLp0diuRhoMXl2jNPRnGq+kb7OL4OBIEp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6916695-729a-4be3-6558-08dc2e3f62fc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 16:01:35.9905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2h9nQ8NLOB5ta6XwVMRfMZ9U6So1vcEyijGjPFLFGSbezx1xfmyahBuH/6KvXgA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4427

On Thu, Feb 15, 2024 at 01:49:53PM +0000, Will Deacon wrote:
> Hi Jason,
> 
> On Tue, Feb 06, 2024 at 11:12:38AM -0400, Jason Gunthorpe wrote:
> > As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> > been limited to only work correctly in certain scenarios that the caller
> > must ensure. Generally the caller must put the STE into ABORT or BYPASS
> > before attempting to program it to something else.
> 
> This is looking pretty good now, but I have a few comments inline.

Ok

> > @@ -48,6 +48,21 @@ enum arm_smmu_msi_index {
> >  	ARM_SMMU_MAX_MSIS,
> >  };
> >  
> > +struct arm_smmu_entry_writer_ops;
> > +struct arm_smmu_entry_writer {
> > +	const struct arm_smmu_entry_writer_ops *ops;
> > +	struct arm_smmu_master *master;
> > +};
> > +
> > +struct arm_smmu_entry_writer_ops {
> > +	unsigned int num_entry_qwords;
> > +	__le64 v_bit;
> > +	void (*get_used)(const __le64 *entry, __le64 *used);
> > +	void (*sync)(struct arm_smmu_entry_writer *writer);
> > +};
> 
> Can we avoid the indirection for now, please? I'm sure we'll want it later
> when you extend this to CDs, but for the initial support it just makes it
> more difficult to follow the flow. Should be a trivial thing to drop, I
> hope.

We can.

> > +static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> >  {
> > +	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
> > +
> > +	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
> > +	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
> > +		return;
> > +
> > +	/*
> > +	 * See 13.5 Summary of attribute/permission configuration fields for the
> > +	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
> > +	 * and S2 only.
> > +	 */
> > +	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
> > +	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
> > +	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
> > +	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> > +		     STRTAB_STE_1_S1DSS_BYPASS))
> > +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> 
> Huh, SHCFG is really getting in the way here, isn't it? 

I wouldn't say that.. It is just a complicated bit of the spec. One of
the things we recently did was to audit all the cache settings and, at
least, we then realized that SHCFG was being subtly used by S2 as
well..

Not sure if that was intentional or if it was just missed from the
spec that the S2 uses the value too.

From that perspective I view this layout of used to be valuable. It
forces the kind of reflection and rigor that I think is helpful. The
fact we found a thing to improve on by inspection is proof of this
worth to me.

> I think it also means we don't have a "hitless" transition from
> stage-2 translation -> bypass.

Hmm, I didn't notice that. The kunit passed:

[    0.511483] 1..1
[    0.511510]     KTAP version 1
[    0.511551]     # Subtest: arm-smmu-v3-kunit-test
[    0.511592]     # module: arm_smmu_v3_test
[    0.511594]     1..10
[    0.511910]     ok 1 arm_smmu_v3_write_ste_test_bypass_to_abort
[    0.512110]     ok 2 arm_smmu_v3_write_ste_test_abort_to_bypass
[    0.512386]     ok 3 arm_smmu_v3_write_ste_test_cdtable_to_abort
[    0.512631]     ok 4 arm_smmu_v3_write_ste_test_abort_to_cdtable
[    0.512874]     ok 5 arm_smmu_v3_write_ste_test_cdtable_to_bypass
[    0.513075]     ok 6 arm_smmu_v3_write_ste_test_bypass_to_cdtable
[    0.513275]     ok 7 arm_smmu_v3_write_ste_test_cdtable_s1dss_change
[    0.513466]     ok 8 arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass
[    0.513672]     ok 9 arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass
[    0.514148]     ok 10 arm_smmu_v3_write_ste_test_non_hitless

Which I see is because it did not test the S2 case...

> I'm inclined to leave it set to "use incoming" all the time; the
> only difference I can see is if you have stage-2 translation and a
> master emitting outer-shareable transactions, in which case they'd now
> be outer-shareable instead of inner-shareable, which I think is harmless.

Broadly it seems to me to make sense that the iommu would try to have
a consistent translation - that bypass and S2 use different
cachability doesn't seem great. But isn't the current S2 value of 0
"non-sharable"?

> Additionally, it looks like there's an existing buglet here in that we
> shouldn't set SHCFG if SMMU_IDR1.ATTR_TYPES_OVR == 0.

Ah because the spec says RES0.. I'll add these two into the pile of
random stuff in part 3

> > +	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> > +	switch (cfg) {
> > +	case STRTAB_STE_0_CFG_ABORT:
> > +	case STRTAB_STE_0_CFG_BYPASS:
> > +		break;
> > +	case STRTAB_STE_0_CFG_S1_TRANS:
> > +		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> > +					    STRTAB_STE_0_S1CTXPTR_MASK |
> > +					    STRTAB_STE_0_S1CDMAX);
> > +		used_bits[1] |=
> > +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> > +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> > +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> > +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> > +		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> > +		break;
> > +	case STRTAB_STE_0_CFG_S2_TRANS:
> > +		used_bits[1] |=
> > +			cpu_to_le64(STRTAB_STE_1_EATS);
> > +		used_bits[2] |=
> > +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> > +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> > +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> > +		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> > +		break;
> 
> With SHCFG fixed, can we go a step further with this and simply identify
> the live qwords directly, rather than on a field-by-field basis? I think
> we should be able to do the same "hitless" transitions you want with the
> coarser granularity.

Not naively, Michael's excellent unit test shows it.. My understanding
of your idea was roughly thus:

void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
{
	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));

	used_bits[0] = U64_MAX;
	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
		return;

	/*
	 * See 13.5 Summary of attribute/permission configuration fields for the
	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
	 * and S2 only.
	 */
	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
		     STRTAB_STE_1_S1DSS_BYPASS))
		used_bits[1] |= U64_MAX;

	used_bits[0] |= U64_MAX;
	switch (cfg) {
	case STRTAB_STE_0_CFG_ABORT:
	case STRTAB_STE_0_CFG_BYPASS:
		break;
	case STRTAB_STE_0_CFG_S1_TRANS:
		used_bits[0] |= U64_MAX;
		used_bits[1] |= U64_MAX;
		used_bits[2] |= U64_MAX;
		break;
	case STRTAB_STE_0_CFG_NESTED:
		used_bits[0] |= U64_MAX;
		used_bits[1] |= U64_MAX;
		fallthrough;
	case STRTAB_STE_0_CFG_S2_TRANS:
		used_bits[1] |= U64_MAX;
		used_bits[2] |= U64_MAX;
		used_bits[3] |= U64_MAX;
		break;

	default:
		memset(used_bits, 0xFF, sizeof(struct arm_smmu_ste));
		WARN_ON(true);
	}
}

And the failures:

[    0.500676]     ok 1 arm_smmu_v3_write_ste_test_bypass_to_abort
[    0.500818]     ok 2 arm_smmu_v3_write_ste_test_abort_to_bypass
[    0.501014]     ok 3 arm_smmu_v3_write_ste_test_cdtable_to_abort
[    0.501197]     ok 4 arm_smmu_v3_write_ste_test_abort_to_cdtable
[    0.501340]     # arm_smmu_v3_write_ste_test_cdtable_to_bypass: EXPECTATION FAILED at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:128
[    0.501340]     Expected test_writer.invalid_entry_written == !hitless, but
[    0.501340]         test_writer.invalid_entry_written == 1 (0x1)
[    0.501340]         !hitless == 0 (0x0)
[    0.501489]     not ok 5 arm_smmu_v3_write_ste_test_cdtable_to_bypass
[    0.501787]     # arm_smmu_v3_write_ste_test_bypass_to_cdtable: EXPECTATION FAILED at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:128
[    0.501787]     Expected test_writer.invalid_entry_written == !hitless, but
[    0.501787]         test_writer.invalid_entry_written == 1 (0x1)
[    0.501787]         !hitless == 0 (0x0)
[    0.501931]     not ok 6 arm_smmu_v3_write_ste_test_bypass_to_cdtable
[    0.502274]     ok 7 arm_smmu_v3_write_ste_test_cdtable_s1dss_change
[    0.502397]     # arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass: EXPECTATION FAILED at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:128
[    0.502397]     Expected test_writer.invalid_entry_written == !hitless, but
[    0.502397]         test_writer.invalid_entry_written == 1 (0x1)
[    0.502397]         !hitless == 0 (0x0)
[    0.502473]     # arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass: EXPECTATION FAILED at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:129
[    0.502473]     Expected test_writer.num_syncs == num_syncs_expected, but
[    0.502473]         test_writer.num_syncs == 3 (0x3)
[    0.502473]         num_syncs_expected == 2 (0x2)
[    0.502784]     not ok 8 arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass
[    0.503073]     # arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass: EXPECTATION FAILED at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:128
[    0.503073]     Expected test_writer.invalid_entry_written == !hitless, but
[    0.503073]         test_writer.invalid_entry_written == 1 (0x1)
[    0.503073]         !hitless == 0 (0x0)
[    0.503176]     # arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass: EXPECTATION FAILED at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:129
[    0.503176]     Expected test_writer.num_syncs == num_syncs_expected, but
[    0.503176]         test_writer.num_syncs == 3 (0x3)
[    0.503176]         num_syncs_expected == 2 (0x2)
[    0.503464]     not ok 9 arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass
[    0.503807]     ok 10 arm_smmu_v3_write_ste_test_non_hitless

BYPASS -> S1 requires changing overlapping bits in qword 1. The
programming sequence would look like this:

start qw[1] = SHCFG_INCOMING
      qw[1] = SHCFG_INCOMING | S1DSS
      qw[0] = S1 mode
      qw[1] = S1DSS

The two states are sharing qw[1] and BYPASS ignores all of it except
SHCFG_INCOMING. Since bypass would have its qw[1] marked as used due
to the SHCFG there is no way to express that it is not looking at the
other bits.

We'd have to really start doing really hacky things like remove the
SHCFG as a used field entirely - but I think if you do that you break
the entire logic of the design and also go backwards to having
programming that only works if STEs are constructed in certain ways.

Thanks,
Jason
