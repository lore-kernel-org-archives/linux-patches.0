Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D72836AF;
	Wed, 28 May 2025 11:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748433435; cv=fail; b=AwEqJyN1PCCLtA15QrLLCBpN9W3+/YA+Q0qu7eNwaEa38VJZNQZuh+jk8vzP3oMj0dzAFk8BBXnVi+Ctc7duBAPBcXMmrb5uyX2ESynLeFsBDHdlu9oRZc1tV0yKmKHJMi9GDd9ou6VjCKwQlr3LwBvpDByZDRBN9V2FbV9SU04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748433435; c=relaxed/simple;
	bh=J2pl/tbdNHxmXhSJeyokXhToJlV6YyPXYzxuUcdK5bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aMnSbubhBUtDNcn/GJFyR3DWVY2hI9QiTIlJudfe8Y11v0VTcBHGh9imhs2E49ivXW3dC6r3CMFZcIoRoVayRJdT91E5jf2rAO14Ch8DCy6qejR7glOR7FNVFYQzAiEkj99hW+3ilPZ6Ubun5W48OfDUP06S8xZzHKMfseIWDIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H/hfJDvW; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H/hfJDvW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LjAVIaIyqNDbptbxKwyaBdXilSXQ0CiTitCk77uvJkV6abj7k9MDxZpp/kLKE2AMcBxfGnkO4Gv4anIntgGG/mVdh6zlxgHwWW28NZVG/gLvBnXoPbx4NR/FzvrzMg9okAbtyq2UJcXH0DvOzqW/qbN5Fm+28y338qnl0uFiqUrpgZlPSI6ZOxkzRSHt+Q9spF7WRfmLMWQlljU04bao+sZVtoKUOd0DjTwS40+RrTpLF8CzVe4MSk80M668JyEQJoaxZL3qBCE5437mwnGNdlYVC58LZVKbcgCPwzmi1LVuxSkMZjCvsbgFaxWOSeM/HNZGAszQzn9E+k89Q9YoSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uskr1FHLoSO7g/PEzdsEz/fmpy4PvxbO4VwQxWX7kIY=;
 b=fqpK5hpADegBmOXeIqg4GxCzIakC+ZXfen7OcSTfX/iMAtpqDIewAxZ+YyX6NPdEjfQv/mABUOiwhlwGNvrM81mYi9dDGAKNnYTtDqtrfEwDnfS0iYNiz8IRIApw8S3MVLG1n2hVV89x+S2LZAkYsBkrS+OaQC54Bw1QFwn+631l+Rel5eepnYwm3sLhFCX6Zs0Xu5jYFXEynzJDG3mRt3Kjlx9WGp4Li5R+umKm6l/8TUfAhSykOdF61ub9HDFaRij4WZamXwiAgwPUiXjVcSeAB7wP8IXIOFbl2QRrVTiDwCw4/5N6mWY3whRVS64wvkzNWHyptZ2rdaJ2o1pu5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uskr1FHLoSO7g/PEzdsEz/fmpy4PvxbO4VwQxWX7kIY=;
 b=H/hfJDvWGuLFfZjkwTrIaFTcTvRIvnUbKDEKCbTdlwwy6lfh6Nzl5g5pNlk5KllLgGsqll3FxtJ/kD9rlTYUN+HQBIbU0sC/2AUN6db5tuZ8ReVpc5u20G8ML+VGT5mKDLPXKGcgVf6L+T1L4OI23MSBbI8VIXOjSF/IfIF6wrSwGiocRFUAidltedZf11H5JPnvIycKQLjrDkcHMssBS6dnHCjdDMY7xeAQuDOY6f1lcxHvGTzeaaLhckjJNqMF6/7oNET51XF2WRUNM3LmG+boeG91z485VjweXs3zKzfsBlad3kVGZf/pdHYyNKZKeINdtdpFk2NjTGe8LguSLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB9445.namprd12.prod.outlook.com (2603:10b6:8:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Wed, 28 May
 2025 11:57:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8769.022; Wed, 28 May 2025
 11:57:09 +0000
Date: Wed, 28 May 2025 08:57:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH rc] iommu/amd: Fix geometry.aperture_end for V2 tables
Message-ID: <20250528115708.GQ61950@nvidia.com>
References: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
 <d5a653df-9b43-4f13-8b1b-c3268c356592@amd.com>
 <20250424140613.GR1648741@nvidia.com>
 <8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com>
X-ClientProxiedBy: BL1PR13CA0344.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB9445:EE_
X-MS-Office365-Filtering-Correlation-Id: 044eaab0-61ac-45b4-7c85-08dd9ddec632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HqAkNmftl9fhuFp9+cM3IQQ0reYFLqJz6ZkmYA6YtaY7gb44i2XKPMfS/2IU?=
 =?us-ascii?Q?peP+NtUkwx4eazgG+Qdi31WTjwJ5rYno7AvB6eDjg9d6SogrryyvWr9BJkVE?=
 =?us-ascii?Q?/T6GcsSBpMb8pMTtXN/lWGuJrGRFo1gX38kqZl/ZfbxnwgBZNCD3//7oGMcY?=
 =?us-ascii?Q?Cph8CYr4pKPECUfAJhVrJEze/S8ZFL2oEg9UFeuLK7anOs72znWaxqk+t5rg?=
 =?us-ascii?Q?JVQ5s8DCT/b+L/8/E11MdvoC6RwGBjgbM171jTa7qp98O+bpBsqyuao5XE3N?=
 =?us-ascii?Q?do0xmeocqX7ejVMaFmLpmngv+x0J7im3MgL4h/EPQL6VkQw5ytDQfdOb5k+7?=
 =?us-ascii?Q?SciRVfq0SczvbVXhUyQhkinyU7bdTjeEkf6HxHOzHpyAsrcjfKIvHxfjcIVM?=
 =?us-ascii?Q?3ZNQrqJ10v8S1iBjLJk+68aHkYm+p926MFs+FUae/rdrjALC5JTalyLVN10z?=
 =?us-ascii?Q?HXPLvwMeVBXUU851Pzq/htMX+YL4IvRq5N3et791ddhGi+kQN6t+a+8VEIGa?=
 =?us-ascii?Q?X+rvCPAQzYtnNgSzDiXUU/nwyl3sm7O+zlALfQ/pTlBBffCIcsx2jRiEg1XC?=
 =?us-ascii?Q?HniT7gUie4xP/Ousa4BLBoS5qt+JLjJrPzW/Jg5dPIwB7VzgtzG78DxPuiSR?=
 =?us-ascii?Q?djtd2I6zx79j6s+NmH3OKigWLfW0RwRvMr/bSEhZKeN0rSJIfTI4M19k2hAZ?=
 =?us-ascii?Q?I3KzfPYxcJ6RudPMyoKV3gb9PhGwGUjPd54z1GDAfXWNrOWloexKiBbr/IM/?=
 =?us-ascii?Q?6Gp/pAjpg5XELt/a1pN1nWIfYNe1IEUPF36kxEmiWGXgMMnNwMMBJA3msALE?=
 =?us-ascii?Q?NPuL9mM8f1trDorh1iqQrz8qvjm+HZz02ZNZagwCqObMwGhRI5p9i/of9HrE?=
 =?us-ascii?Q?GfO/dmP5AWgmA/NzMyZaRuDMcVlBtotQEVxTnvjiCQf/lhL+zvOFecOlIoCP?=
 =?us-ascii?Q?3gCSrVGB1jN1KNertdUdzzTpFs/0bvCii8vI4dKjv25CS87hC2Ok+S6dBnlZ?=
 =?us-ascii?Q?vszmECo3F0xJgaqaAMgutfPj48NR8Q7OmxBZliyxWYFvpuZAY8nKkXkwK1+J?=
 =?us-ascii?Q?6Ugt9RJ9zfT1Y7Vxoej0idfBBWqNDXG5D8RSxaGHwJ/11MyNVyHT8fKlrcMz?=
 =?us-ascii?Q?OLwu9eiUjTvqcCPUDfLn1y1kcznA/1zLOXQ/ridjm/pMNRx2yIn05xGNHXhz?=
 =?us-ascii?Q?PButFhA7cz5SpncCe3RXlnhgQBmf4/xTtAKxa1fhzpRDKUxVNeupX8pVJcyA?=
 =?us-ascii?Q?O/QFDtCBybZFP2srbr2evKRZo7JpL2dE8DgCTtMDxVsbfaFyp+6I7y94dNev?=
 =?us-ascii?Q?GmiczuLjMWLQE7JKHFCr+7daYdqquK1rFwVPpyEdiEhDQ50xBnBmtoB8GVZe?=
 =?us-ascii?Q?zShTE1Xjn4Tj1aDeABXQVpP5HMseD8y22cEjp536nGC1qpL7ybOr7vsTmxbh?=
 =?us-ascii?Q?sDCVUurStus=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KU8dXohnTq75zux2nGCB0Gjv/mbN2q7ekdirxc/OvywYFVTanGVoP5kphtjA?=
 =?us-ascii?Q?pCle/DaZjY1aaMg3i3adKpdWbt/mxYpUPG1F++uvbSum7GEB7PkjncDP4yOk?=
 =?us-ascii?Q?lb9+RgWwCR4mL53rAhOHBs+ggU1PdLVoHOOvxg1SEFEsZaxrRKYWzMrl248r?=
 =?us-ascii?Q?QdpCL2Qv6Qdb2LQDifHHxWQbrWSiHsgv3+RraqBMizPe0BaDBLTmlLc0p5Co?=
 =?us-ascii?Q?UX35rPdMYaTBnyCCwWy+K6ULoR/rFsry42WbZ0YpFk5BQ7sFGhfSKz9M7wvK?=
 =?us-ascii?Q?urIP/hGDVto+VH6PMq9hEbdso4hRFBFYyVXxVNA5f3LgvmsXSl0CP0nRbSeu?=
 =?us-ascii?Q?f/qbLdXeLG7GpXblLgLa82Yx0/3MtId6mk8TGvbUWmJZLnP+h1knKXC1DE0v?=
 =?us-ascii?Q?zcQY/gtGsn5dyOFXra0k+I13v++6uB/2DcqnBYWApAGsosRoTCg7Dd7tAYNr?=
 =?us-ascii?Q?sXLKe0KcGw0YgribOWKx4Tq6PudCqq6mQQs275pPKiqZ834R68OhxMVug9m0?=
 =?us-ascii?Q?MWBZ+v0KPl0LeA0N4MLtBFmwpbC4RfV+g67ZT0evHbFzGMOi6xkvdBYj01K7?=
 =?us-ascii?Q?EcDM1rWlSrE8t1kmowjwkVz7i3cEEiKkCb0II9bUOiymtCRXG6plJROJq9ld?=
 =?us-ascii?Q?zkPx+K1CCP9MWB9GjYLx4leXU4hPE6VtVSo3HL6+zrhqjzga9c/r8xBKFj+r?=
 =?us-ascii?Q?0KQznSTMCkhRtIwqYrSxNBKVAmFZsINq+0xjjiTO87RtfpsL2bFpcN4dksVj?=
 =?us-ascii?Q?CA+5HuPOF88sywEv7U2ZqANovvib7x8C/FxeiWQpILexvPozZfZuh8rSKw76?=
 =?us-ascii?Q?PR53G4WsIGB5w8WfMzsWWEwgabwhOZb+WXvfsmXlhYYKSv6lGCLybGSSpprA?=
 =?us-ascii?Q?qyApjJIZpODR/nFZgF314C9V9njmm051pw4EZHG9tk7AOB9mmZYnjSgeDAOP?=
 =?us-ascii?Q?/K3I5EGznZiEVBYvhriTH0LlfH1Lx05gqHDa7KsFXl6PG6fCK1+gXBHMloSE?=
 =?us-ascii?Q?YDm/3D+ZMmN7YOwUxwqF+nmSGORC2V5WErYHPXdXFqQpr0BUlHVZNodhY7qG?=
 =?us-ascii?Q?h5gqh9rz1Q+DjAPAi7dYEYoIRBhytE4IozTxW+HulzerVMQD4RydQ36uax1j?=
 =?us-ascii?Q?JwRCS3buqziDPpUkPjsjiejwJGDPEPpNpM0YBmj9Xtqpup1HgLrDvQWkHfqE?=
 =?us-ascii?Q?vj5eyCPkR5XjiZ2YPv/cKVD52AJwD70BLjC8z7cr/ZilFEFlRTvg2xulIk2J?=
 =?us-ascii?Q?m5dRGYdsxQqWVTyEDPCFBQrYfOeBvROnx/tGBXe3ONHb+YpF2fNHp9+h6Q2A?=
 =?us-ascii?Q?npj3B8T5L3l7WH+Wd7pco//RUqgSgLuofY2C4AKR41eWRK7dYxLebe0igzXk?=
 =?us-ascii?Q?06vmdsEfGL/Fl5SpH+canMIklnLOQxGcC/zTuxzy8IsJu/L5lH5mcRumhTT0?=
 =?us-ascii?Q?jQvdvkou9lbXjAndFHUdJe2JlIjC5jUEcjw9Ia49zRyqBVWfxuU2P89UXb7r?=
 =?us-ascii?Q?ZyIY0ve6wV2xXYcTgsVWsQ9DhxCiFey+v3vfUNV77YgxKuarehGiW1BoR+04?=
 =?us-ascii?Q?kXDUmNl3K6Q3yaOyXqKzzIP6TBTS8oHmWvFLhvgt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044eaab0-61ac-45b4-7c85-08dd9ddec632
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 11:57:09.2242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qEQ1ugzM04eLruPB/g4H3VCpEvifHNaUY5X2whzFMnYJUtw46eS83FYQth91ECQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9445

On Wed, May 28, 2025 at 02:17:56PM +0530, Vasant Hegde wrote:
> > Yes, it should use bit 56 for address translation, that is part of the
> > page table architecture.
> 
> I have checked with HW architects.
> 
> In DMA API mode (PASID=0), IOMMU HW does not use canonical
> addresses. 

Do you really mean PASID=0 but still using a AMDv2 table with the
GCR3? That seems wild that only PASID0 would break the normal rules
for x86 page tables...

We already know AMDv1 is different and that is documented, and it only
works on PASID0.

> It's safe to use bit 56 (5 level page table) -OR- bit 47 (4 level
> page table) for address translation (we don't need sign
> extension). 

But does it validate that the upper bits are zero or does it ignore
them? As I mentioned previously ignoring them breaks ATS.

> However when PASID is *enabled* (PASID != 0), then IOMMU
> expects canonical address bit[63-57] should match bit[56]. Otherwise
> it will abort the request.

Okay that's great at least.

But this is a pain.. Since iommu_domains don't act differently
depending on what PASID they are linked to we have to use the least
common denominator, meaning we should disable use of the top bit
entirely, and disable use of sign extension.

> I have requested spec writer to add details in the spec.

Yes please, this special behavior for PASID0 is very shocking.

Jason
