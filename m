Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCD46CDB1;
	Tue,  7 May 2024 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715085702; cv=fail; b=elJ0/ApO8SkfExPPYCfSExuiCd5gqpWus1pzKN+uMxcbi3QNPXTi0LsPZxg/17vpg5F9T00TcHps8LCVQ45kGyunPJPoNYkLS12eTEI7ojSA8EgatqzjtIjEU0xmDCJJCG4Ro7Uau+b3hZNFVWPQ79XDn3MDtQic3R05/U6Lltw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715085702; c=relaxed/simple;
	bh=5tbL1vuf6Us8k9PC3Kp+dCOPb0KAhfKEs2qDb2K/G54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nOOzuhM6vdb6WX26KqZV1nBsX9SsOtYP9G7qWV1xiztqrAs+2lXUN6CJ3KETkY7wRDmA8HpCJdpWVxQvcBGg+GTkg94a64aflvcT8zKqD9/d9oNV+aI/L4Wyz7HYhpFsT6VReYH6vAax8Ga1V6s38Z/OUGi/yEXE0LeLxBfbpg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qruugF5r; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qruugF5r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uh5iB+I8YO+G1BBMCld/BDMLmLkRwcbSWLrqsBAf+J7GjFFRTLaRtQs7/N4bCBxJhqmX8qzPGKjKnGmxu0malDlgj9pQzbbKiWXGS4txMeu75buuHDN4m1SvuZhSpBwi2o2ty6muRicZ/bZ+CvKsPlMASXPnE6klVXgKHJfqlqE8SyfoFPSPRglPfCO83k/2uWR96EYfpSoe+hJ8w7qctZTt/MlC30tnZ9hh+Oh2kzOwszltdTlkD/CZhuYl10Dv4Nm8+PIeZC9q1I5jxhDe2haampACa34QDitQbSrL8VfJo1TgCWEViHyGvhYelfPxx8FxlmhEtzwB5t4fV6iP1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fa7GZdtoaNXemdY9GAq9SxTkM4qw+JoOtG/Mn9f7i3U=;
 b=fTxRLaAJknmOo5vsVUe7KjKL5pvN16F8MhL4Ed6zih/Vze4HVT4k2mS40F0pVzagJ1pW+D7wG+pWHMZNt9YYK/4M1EPS5FiVfP97oS/vAxdhEV0YPGsBfi/QLDalA4dT5H88I2huLlZwk+yxvT+jz4E2UNYlNt1r9XjePm76exAOT3VfCowTjxmHh59Fhk4g0cWnFzWyACjks9xNNZIsEPshNiQNkXCTd6h/NVQysZ7Uwcj79WKCU8eLwXSTPfTfJfxPw8kjyCO+Fjk+5WD1MI73cYMehchKXt4SKIMi67QiIYiKQwlJbiuxBR5K4yuKiUy4lFQr/nv15iwxleTYzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fa7GZdtoaNXemdY9GAq9SxTkM4qw+JoOtG/Mn9f7i3U=;
 b=qruugF5r5Z2yiT857lDhzFsKbj6q5L5UF5S4/CBl92JujYflcoO4a1Ed8xxOH6hFSH7RJLkvQr+BueWquAiFZCqKlUyBMjD8LMPNMvxy7zK1b1zRAOZT6B24KlFBqc+p6d2IrHhc6/hGYC/So1ZoH8WpKUQAHYyya/jpLVoQM5xsjPOWD5CqpYvtHhnGWIaJY/JtAVs2qiBkZVtDneBlCwCS0uUgvHo41R0EhUQMc5IR/QUQi8MwyQNnpDhjjc6fIQ/lUlBsrYDx1Aj4aSageeaObESTPO2ptlT2N96AIG4lW4Gs/Fm2izdzBbusXtl/3RlZ0qhmQX3KwoiKEydtug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9213.namprd12.prod.outlook.com (2603:10b6:408:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 12:41:37 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 12:41:37 +0000
Date: Tue, 7 May 2024 09:41:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: Build error on -next: Unexpected GOT/PLT entries detected! (was
 Re: [PATCH v9 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry)
Message-ID: <20240507124134.GN3341011@nvidia.com>
References: <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info>
X-ClientProxiedBy: BY5PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:180::37) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: b4e173c9-1f34-4d5d-6c41-08dc6e930944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wgtlGCsN1t7E4GayFHwRTlSWvc9xVHHLcwIEaQCDwqkEVuSl2jV8qO9VMAPS?=
 =?us-ascii?Q?HREKkOFsiPnAWKLm6487XO+t4nb0TSGPRCJ03yrHcyab0cqKC9QqtA+tKxBI?=
 =?us-ascii?Q?Nv/hVPB7hWeFJFoEI39waa0Co6W1WyfEG7IsUN3ZhKl3UtUK6pGFnp9jRIxl?=
 =?us-ascii?Q?qopb1HRggC7qHw2AwQQqEqfTJDyKYqCjln+3EPDEzHwApUxxApvFwG5DCVFA?=
 =?us-ascii?Q?so8wkFxGmMFkcZ1s9MIMI2nqdlt3QE+e2v8zkEhn6ywaQvQVLIG9zkIJX/aN?=
 =?us-ascii?Q?bPzglUj/04fvVv5WVZHqnRiI4o52KG2QKntXuHkLbD0Cx9G3VmbuIpuHzjdb?=
 =?us-ascii?Q?WXdW/dHnTin7LG1Z5n1X73XC+jR7GheYgozmq4hCKR2mCLtTmQQ9ltAqi9Fh?=
 =?us-ascii?Q?3DYLE2//ootg4XtnHD1rikdbjnoaRMt3+maJ2mbPKsJtLJA9UnWp9z2/gvl4?=
 =?us-ascii?Q?xM5ypSx7RlpVX8nJ4z7ALm7xvcHT4lSmtm9cDeaRVElVYQd1g0Y3mruJhNNo?=
 =?us-ascii?Q?IzUd4cjqXFJ6YGSFM6Pk1SiMFhM//3SnHtW9gjW6LLunPZg2E9HYbB4GqSnU?=
 =?us-ascii?Q?xZ6SBoByZjw3zWlqe+ee+Vz6u2OmjDQjH8cBjJWkX4YqfXNpwWpg1MXp6uSv?=
 =?us-ascii?Q?gsT1Fch14jfBktxdnXaOqoKwT26E/rs3hjpQimwTfvfnTPzAPEBtyyG6dy0z?=
 =?us-ascii?Q?QxhA+kWwbuoikRFjmRB7llQdrbxD38/wZ3YSJhxnl1KzLF/m2XhVrJJHxSIS?=
 =?us-ascii?Q?t5CyqUALjeFmLyurdJ8nkeuFwnvaVrv7PFuKyZ+LyZPoihIyCeVoxyCwZ46I?=
 =?us-ascii?Q?/vDW2/8W4idlUREn4XLOtgPNVCI4MzjNiKkRyi92mHj4WGqX8BaGKj6DVq9A?=
 =?us-ascii?Q?x0Fx/maZ7AcLAlq9r1miilZMe137LRLJu6j6TRPfvZ0rMsBqiV8026C0y85k?=
 =?us-ascii?Q?wuvjIl35T1tUQmBrbuCOhy+sL/poj363bP3q8bn4BkIzkVm0xapU0cLLt09P?=
 =?us-ascii?Q?kTnaNLqLObNbLN28sr4q6MZTUYyUSAZvyGzHcTBreJT8jY4tERFwWUgPzb5b?=
 =?us-ascii?Q?8EKFFi3HRxphapKXU+cAnB6mMx/dFtsjrW2XRz016ALa3WaYV/e0TJDl9WHK?=
 =?us-ascii?Q?Xh8bkudea42cr6lHfLwK5HMbVGcEHgSbYc75J2he4aUpfxpZFPB3qIacDnGT?=
 =?us-ascii?Q?NaIn03GJbSzH++4FGbmo7K7DenWea8Z5DQQREYYvA2OzdwAJPdhGjRmnl/xD?=
 =?us-ascii?Q?hPjDmsiF18feJtU5UEm3p+1XL+pnFvkXoOjHmsadfQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IlWeHOAdWOApeojAhZr/YdBhifP4gB10i1RMzZyHAsB8tLIlk/SSityhgi14?=
 =?us-ascii?Q?YxwpgKY7M8w7QMJy1dfnzOk/r0OK0vGN13Jd2W7ckxc9/fDyIzid21bO79cx?=
 =?us-ascii?Q?FxjruwOa9Np4+4HhMRaEeRWEA7VcTM5tutcl/+k43WL9wTTsScV00q0SgaIZ?=
 =?us-ascii?Q?c6mXr5ga2ERqatGd4BDGDGSkbDii+YPnDlKALmZquwft+MvhAXNLshXwNYop?=
 =?us-ascii?Q?vmIXj+CWx7whU9uyfHPbmo62rxOhJs/IsIf1DXuoQL93AgUHwAVXhweAObUe?=
 =?us-ascii?Q?T2g6bpenPLXb27gRJeP6MLgWWdiZnjmIfRCHmOohR7lIpbZx2DS6EfB2pIJg?=
 =?us-ascii?Q?bvbJxIOIoD+VygSn+/TA+nKUQ2/KXHVr5EOuwZ6IYxTT2ApfE6fFdL64eY7j?=
 =?us-ascii?Q?tlx/cvgT+1qlHLS4fXyTs+eEhKYRc9AGSux4Svv26f6hXhiUw43ubCO3xG4E?=
 =?us-ascii?Q?lBHA86bY8Wn8ae3VUkLK9sDl0rCtJG6h/34tknUon/dYan/pDud3nvhkaca0?=
 =?us-ascii?Q?kRCq+Gao+tBlmq8KcPMgXyMsqw7J7kJIZfSklFR7rRlYgIeLJeFEqmyV9vtA?=
 =?us-ascii?Q?yGXgUsWrSb1N8uFStPsj/tv8RVspt5aRYMSFBoCu/PewDIQxazCM/gXbidAH?=
 =?us-ascii?Q?Zhbnm2uRnnus8rmwLRCGPVTZqwBl05p1D7Oq6b6RLxQiO2bVx6T7/2UGDchd?=
 =?us-ascii?Q?0+ubvP6rMbn3Hq+khgebfxlcAcK03zo7Bo55T8sCtUXfP/dt6XdsalRYaJvL?=
 =?us-ascii?Q?hTvCybb7vmTsdTgkRouxzoUzQQj/sYWrfVFfEgd1Y4N9zhWpUhsjZKWGzOZ4?=
 =?us-ascii?Q?s5d/cB8Qz/WTOQ1NoCtvf9G2VFjsCpcQS2sA+Q/RySHPpLB5LUD73CypR66N?=
 =?us-ascii?Q?VuerXmSWw+9QMDHgKSQDOus3bJSBiy2cURI6ScBpiQINySL5VtdebtrZxi83?=
 =?us-ascii?Q?bXx3/6qtQTcAwAhD4hcA7GvuGZ2ThD1+PHNgH72l4PUVP48cblto1JPO9NcC?=
 =?us-ascii?Q?kyw0mO9qtXf1EOGbvpKqfmT3niCG7XaWkVLsm6n6dCbgy+sZQYNcQjcGtHZf?=
 =?us-ascii?Q?ZLa0ENujZN/NGk09gp37nrEpzWsNbK9KKB1eDUW7JtAEVQSVpbzEgQWMkB1q?=
 =?us-ascii?Q?wOQhX4pVR0/tP4mUUqw3BhsLZ6+5QBhUVuAeHUS7mjLhev9PqjfAPMJfC5NX?=
 =?us-ascii?Q?+941tCUcPFVJ4xlIDabumJEs0ZJ23Xbr/+yUCPkKdjT1uLuqDFRwWyqGqpeM?=
 =?us-ascii?Q?15KDLaPtJPNzbe21Kw12v+GFS690++ERqDP/sKIpKkExr9kRJQY9HtQgU0YB?=
 =?us-ascii?Q?3i9Wb5k68qY3rBZOPJ6YmVwZqtTgCTzabocgF1c5sXOg/Uyrq3etGXGp91Jt?=
 =?us-ascii?Q?LctGrs+PoHnT0+rdVmDfH52dlxSn3fVBfWd9dZ9WTvOtMfJeHl6IVq8f81aE?=
 =?us-ascii?Q?OWq47j2RXLBQSQ/NPm5rH+sT2eV+yAtTX3o1atEb2olOjnrx8YidXnUZMm58?=
 =?us-ascii?Q?+S6bc0+T0wdoYVog3AYwvg5+gQbSgiOhQ5FvXpeoQS1r1CiL0MR7BwRzwTAb?=
 =?us-ascii?Q?VlAfqO9bQCbwDYzr9sP9bomp98T4XCmkasD7zvVu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e173c9-1f34-4d5d-6c41-08dc6e930944
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 12:41:37.5373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzzvibM5/YXS5OfEy9drNzLkaqg/11I2WAPiubEkYP21bDK/sMUXufL3IF9ZBBxr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9213

On Tue, May 07, 2024 at 02:15:51PM +0200, Thorsten Leemhuis wrote:
> On 30.04.24 19:21, Jason Gunthorpe wrote:
> > Add tests for some of the more common STE update operations that we expect
> > to see, as well as some artificial STE updates to test the edges of
> > arm_smmu_write_entry. These also serve as a record of which common
> > operation is expected to be hitless, and how many syncs they require.
> > 
> > arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
> > to any other abritrary STE/CD configuration. The update requires a
> > sequence of write+sync operations with some invariants that must be held
> > true after each sync. arm_smmu_write_entry lends itself well to
> > unit-testing since the function's interaction with the STE/CD is already
> > abstracted by input callbacks that we can hook to introspect into the
> > sequence of operations. We can use these hooks to guarantee that
> > invariants are held throughout the entire update operation.
> > 
> > [...]
> >
> > +static void arm_smmu_v3_test_ste_expect_transition(
> > +	struct kunit *test, const struct arm_smmu_ste *cur,
> > +	const struct arm_smmu_ste *target, unsigned int num_syncs_expected,
> > +	bool hitless)
> > +{
> > +	struct arm_smmu_ste cur_copy = *cur;
> > [...]
> 
> Lo! My daily -next builds of vanilla kernel RPM packages for all
> current Fedora releases started all to fail today on ARM64.

Fedora enables kunit in a production kernel????

> I currently lack time to investigate this properly, so feel free to
> ignore this, maybe this is a false alarm and cause by the build
> instructions in the RPM .spec file doing something stupid.

That's surprising to me.. this has been in 0-day for months now and
it's kconfig randomizer didn't hit this combination.

> /usr/bin/make -s 'HOSTCFLAGS=-O2  -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3 \
> -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 \
> -mbranch-protection=standard -fasynchronous-unwind-tables -fstack-clash-protection   ' 'HOSTLDFLAGS=-Wl,-z,relro -Wl,--as-needed 
> -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld-errors -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 \
> -Wl,--build-id=sha1 -specs=/usr/lib/rpm/redhat/redhat-package-notes ' ARCH=arm64 'KCFLAGS= ' WITH_GCOV=0 -j4 vmlinuz.efi
> [...]
> ld: Unexpected GOT/PLT entries detected!
> ld: Unexpected run-time procedure linkages detected!
> ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_v3_test_ste_expect_transition':
> /builddir/build/BUILD/kernel-next-20240507/linux-6.9.0-0.0.next.20240507.458.vanilla.fc41.aarch64/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:144:(.text+0x6f8): undefined reference to `kunit_mem_assert_format'

It is because your .config has kunit as modular but smmu is not. I
thought the kconfig prevented that in the usual way, but I see it
doesn't work :\

Let me come up with something

Jason
