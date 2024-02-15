Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B9613A86E;
	Thu, 15 Feb 2024 21:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708031925; cv=fail; b=PuZaSjBYiHVxWlefk5PxtwIAynRo+8IMyxNVKz1YHuU38aWWNvOFcsA3Y6vNr6SgGsZQrWPPzQDiccngw31/vfuFBuoz2oWCt/Y6oliF+kRHEe9REfdSP79qhYnIWW6KdzlscAAvukzIQxq1tLw7+d4Y1jRApe45vUD6mDwQ2x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708031925; c=relaxed/simple;
	bh=Y6sOVa/B4kJUrsnMGjkFJZfSeM8gbyFlwh2Y+VwW9BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N5q0P1lu6ZkWAii0Wt6b1wk/Nf4DGoO6HXleL/LbbtyZmIkKuKDdGqwhvSfXwzPQBlaT2ArfnVz5ODFLuAgwKR4ZOlxMGTeds689CTSNZEp0JXgZ3T2RMWXVpAa1JzWEZUDUQ/r3AMKv6nnXWP32q15s04aENjEb98E5Nz2hV38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IsALGH4O; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IsALGH4O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSkP88hheYeUsjf7xhHnfmU7qMqAeYoS/wJ6WLLMXJE1196bmW4zZjcnb9O7HLsHjrz7nCyo9aG83UKgcJDmWWQL7GqbpL2WX9hUq2TCPQGO98VwHzBck8X7bp9TVTiL3/a3m89hAsCH9MyeSxVzybI/ZMoOk6j879Ztt7nNlAtezhFuEWBt6SIe5/lQVDq3A9ig0gAWrNLIRTRNSgq1CZeOfuHj2eUfLdOOZpdoxoR0aUk1noXYH4OU/cRZlZSS4VphIGHn5R8PiQwUQ3MFeR5lfcMDE9uBP8lRgyZKKHs+NX+gKcgIom/lhG3BsOHYKIbsrHErfxcPvG+hsVI6PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mm7H180+JqQyDHj6D6BAlIrjJk0fR6p+nRP1A4WlGaA=;
 b=KbysD064s7zr0/UHXzQKzpUGWI/OAPlfUfhDVT685u/zxBTf5UdKzYecsCIah4zCOGKgjlgpcnKDTeIz1HWwuAw+f25ZeWVrxtvMe4HKcuIU2u0vRYtge8eKECHy2gPNFvgXiDgkNjojAhbayyAjPSMOexOG4PNMaKrRXdsR/YYWq5LAkW4PCkveEQUUbHanW0kN/CtpodCUlW9VIQt4U//3vZXylDe755Rf4KaGMh4EWj6/mYXvNZC775TXUajcLloQVAzrw7KVAIrNxdySlCjxHZU3sWYxtmjvDetEephyZfeRQtBkRQbKAlqc7qYImaVisCohQj0WjxVqdSxQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mm7H180+JqQyDHj6D6BAlIrjJk0fR6p+nRP1A4WlGaA=;
 b=IsALGH4O8eqsWkN7+aHTQDMbW3jJrkYIIkvy9Q0CaSowAY9fkSTGEGWAiyi7K0IC3wletImU0TEaCUIfZ0y9YXtPpdxFRJxa17e8q1HvzlcSkwGyw9zUVdXvchwzZFXjIQG9G9Ygz2GCToMTdTMP/ZWhtGdYwEsDLIzuBrUTNuhmqji9GgA03LvOEqMe1pN3/Yive1Kz5/ADLeQajmkBFJcMbDc1jKg5v6J4PmvPiIGDkQNVQzMwwl9Vm0qP+ZwCxt4eqVtRQtCkh4uA2o3glZLNaPtBGz9X5Bu6st1Z+SrwXiWCvRti+uLhb5+SNNZk6zUDt7USB6Flu6Yc4vtMrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7466.namprd12.prod.outlook.com (2603:10b6:303:212::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 21:18:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Thu, 15 Feb 2024
 21:18:40 +0000
Date: Thu, 15 Feb 2024 17:18:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 03/17] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Message-ID: <20240215211839.GO1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <3-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuMx0w6MDWpkLne@google.com>
 <a9d10aaa-e6b1-44bd-8d7e-9e1abedf03d1@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9d10aaa-e6b1-44bd-8d7e-9e1abedf03d1@arm.com>
X-ClientProxiedBy: MN2PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:23a::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ddc1b26-4a03-46ba-7151-08dc2e6bae43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XgeV+4BbHun7OrSjhl9DW9xHwoCebICX1tVdnsj0cQ1gaETyZA5OaJsdVIDcggLG8/11d0r3grphlBEj90X5XmHMn1wMC4qoQ98uv/NjEdm3wVf79kzw8z9D3RtxEXoFO4w6XzMYnQoCxP0cjY5NIC6SWcsWYCaDWTvrSZ+sonZH/n4nd8S25e6+4K2nwAuiPmQC5uAQXr4Nh7zivN2d8K5zurpv4w6bgxCXa+jYvYyYP+Xwynu+l38PQIg2Kzc2nzK66G/+kS4XHT3CHuKd+GL0q46jJLKMMU4MURH/RZNHbxpsZ2vUv2dVxj9IvCx9KIyI7HUJ9P+FN47RoJCnFSrEn8FLLvqONqeotu2gS2D+IgU6e7+2zoHfJ4pHNQS8gEdaBO7HrkWBmTbPvN2yGIeeIktHodWdsrQCx0l2FGiEG5md5jZVqdRbMeTgAu46SBpg7eHpWiAVwd2+WgcZqaKysKmrA6GpSO5V4x911NANaagfQ12+/POoLtFpUey9qMtQgS6rCMMrfYXyD2ElEDZ8f97gNn6BgFFDMyLH0Lgol/iRf+8bXQzPpJn19U5k
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(39860400002)(396003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(7416002)(2906002)(5660300002)(316002)(6916009)(41300700001)(86362001)(4326008)(38100700002)(66556008)(478600001)(8676002)(66946007)(8936002)(53546011)(54906003)(6486002)(6512007)(6506007)(66476007)(1076003)(83380400001)(26005)(2616005)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XSw0UeR/jUGs0YZx3l0PBjC/DIdXHvLOq5HS0q842vV3lqWXBdttmsdobREH?=
 =?us-ascii?Q?J/tqF9lZpVLrY7v7/824N29rrHebD2hWf46FFP3ofcpq8gSzys+APiiCdnYF?=
 =?us-ascii?Q?VBKqr9KqqOoO+4LlO2udHFjYyl+ED4UbWATetKr7FkJ/aaNSGJkxiPsrYvwk?=
 =?us-ascii?Q?O6xcodEZD6To4J8sEsXlEJKNuMuooUNCB7yXhAm+w+PeZxi2n9NQquyHsoPy?=
 =?us-ascii?Q?u0AUI6Ri1Iqu++0C1Dgen7WQtQZWSxB0Ota4q6fptLSRp4bGSOzbzwZtitTN?=
 =?us-ascii?Q?MiVheRGNJe3EFd501kvrcg98yriMyIy7UqU0z7IxVFBWzANk7BtYRB1e+aqG?=
 =?us-ascii?Q?MaW1B6wDsOMFFg3Nm9lPqgNjAqc97/r56UC0+50YCpdYETv/qV2v/gDlDKxc?=
 =?us-ascii?Q?3K9Gb21HS5JQr6PEUXFgci7RXkE9jhtpMATP8dEBTgTcSjniUxU4CE1U0jiC?=
 =?us-ascii?Q?cO+2ajoTCsVIeaQ+q2D5G9tEiLJ9BTirvhIQmmpr/hvQoJgpTTIRGd1/4gqV?=
 =?us-ascii?Q?KY4Khs4dS+sY4c4QFi8BgXMN3btLU7xD0FhVbEdVkaTe/vjyty0CWkIJeha/?=
 =?us-ascii?Q?1EO+q0zK0DZEz+kacJxVsr6zrHA+GD+wy9DC8JIjHKrtTSb2c76XnOonzC7P?=
 =?us-ascii?Q?W8ZSRCOh5xMD/bxWKSLJrOdwzhICW9nmZJY0htvZP45EeZDNrakMpmYfIdoF?=
 =?us-ascii?Q?zvcrpcRlSgIMpQJVQuSZ7DejfKpFvuByBEhMK3Oq/ayaYvAgRyvciXCafAD7?=
 =?us-ascii?Q?9yBbn6E8zVwDGshpyNmjxWflIHiPY6sEx+X54W/50tNV+kjxAnGUzVDVLMT2?=
 =?us-ascii?Q?0q/QxfciEU9BTe4plwd8Y9rbUymxZsrZUWgRiC7tdnDBeBdjtTP0exJzKkG2?=
 =?us-ascii?Q?M8QFRbX6XRTL3MiIKlE30V4Xn204a7kW8Mdkdu+AKJSnUgU6xIax8QmLLLR8?=
 =?us-ascii?Q?Rq67RqB+ttachhWZ6W+6Khrq9gAcpamISaLGxXANakjo9q60ETR7fb0HeERQ?=
 =?us-ascii?Q?qM/beN6qexKWvCe18rRAmTxvP/Tz8f+uCrh09418bjzsfEk93rR6IN0+nRGi?=
 =?us-ascii?Q?XY7/9KSIlRSfEDRhyTG17hQdK0KrrI0G7JVA98R0mqt1pcWmyMKX88SyIK8z?=
 =?us-ascii?Q?x4ypqX8r8r4fvfC608CnlaQ6z1f903OB7guHuzkSxI9OV016bauB0yNkFKCQ?=
 =?us-ascii?Q?sQUXFX48eUnrnH4yWHmvdiqAY2QrdfRLji6//9GiTDO6wwa7zx6sQ7zDua40?=
 =?us-ascii?Q?4mhXfhszj1Q1OESpM0P+qFUeWebfiKLzif8CCgsbMra6MPCmqEFASPLSvrIa?=
 =?us-ascii?Q?TIIruhLYPJmXMDHN5MDAzzuuU0bPgnjU+yfXN7/WOgC+Mm68ABZ9mGZJMGxM?=
 =?us-ascii?Q?dXYjiqsr+IlJgetwoGwgL4uy0uozVa9bQgRiwMe4hxui9apANIt0x85+aMi5?=
 =?us-ascii?Q?GP7qeK6wLOBDzZNPr+hiAEPzAyebwktoZfJYHMMFYSyXdcwQDead6HqrQvVl?=
 =?us-ascii?Q?axc0EGS6v1dD88ST/K6eKRiYmUfec/UUY53b9Rpm/NB+PSBSHhmXLy0P9Kod?=
 =?us-ascii?Q?coOFz/Xgs43uK0Xr6n4Rm3QJ9swBLofMZMbdOyc2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ddc1b26-4a03-46ba-7151-08dc2e6bae43
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 21:18:40.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXiz+/XNf1jw1UDNBEvj9qyhKlhz8xNWC2ymit3II7YylAHSsyhOjrG2FEBQDQTj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7466

On Thu, Feb 15, 2024 at 07:01:59PM +0000, Robin Murphy wrote:
> On 13/02/2024 3:37 pm, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Feb 06, 2024 at 11:12:40AM -0400, Jason Gunthorpe wrote:
> > > Logically arm_smmu_init_strtab() is the function that allocates and
> > > populates the stream table with the initial value of the STEs. After this
> > > function returns the stream table should be fully ready.
> > > 
> > > arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
> > > any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
> > > ensures there is no disruption to the identity mapping during boot.
> > > 
> > > Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab(), it
> > > already executes immediately after arm_smmu_init_strtab().
> > > 
> > > No functional change intended.
> > 
> > I think arm_smmu_init_strtab is quite low level to abstract FW configuration in it.
> > For example in KVM[1] we'd re-use a big part of this driver and rely on similar
> > low-level functions. But no strong opinion.
> 
> Right, the fact that RMR handling is currently based on bypass STEs is an
> implementation detail; if we ever get round to doing the strict version with
> full-on temporary pagetables, that would obviously not belong in
> init_strtab, thus I would prefer to leave the "handle RMRs" step in its
> appropriate place in the higher-level flow regardless of how it happens to
> be named and implemented today.

I will drop this patch

Jason
