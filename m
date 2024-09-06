Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DAC322A;
	Fri,  6 Sep 2024 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725635191; cv=fail; b=ia1sKIXy8IKoT74Pag9d+Zdp+rpR3cqPLKd27zg0rtRLjgPP750YxVpztsg3kcFdfrX8TgEnNaeAO8hVK3ghW5kQsUH8n3gA+IvAX7q3hy3VqbbL9Yw4VSrhxNpAow4HiFZULsLWhXtcMqVplaX3Youxge8JeiCdPkUup5Fp07U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725635191; c=relaxed/simple;
	bh=9sgGeKH2Y2pwA8C+RYiElad8UJHikgsQ1/Q2uRRdCb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hVxuzoZ+yVr+ZpUY3e1XrXZkWnVFCAwhdok/evi6ENFRRDJWDM1Yhf1KS0MtT7kBUOmiwpDgcAAt2JtYGE+p65c3nZJVJONuH5lEfwKOjyoIgLhMZh9aBvt36e83BWjY3aFTOpumQaX4WXJQCrkT6llA0BHAGO2CI9dpZKRLS28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gD9RNtzU; arc=fail smtp.client-ip=40.107.102.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gD9RNtzU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wq8BN9V0ndgUL1jDtqiUAfdcY+y/8hZWi3qfqWx47O8RCqcpc/rsrivj2Q9ygnLhQEivFrSX8sfjfdU67AkizouCvjYlTxme+9MbibBPACPmR++GzbX0IDnxDp0VwBPO5lV3t+lDpzSvB84GH6mwRLJjxqroIF0hoy3qg5jd2AAe3LJ9WJltCIfrz3d8PL15Vz5tsjHr6s6SdnBZdiJSNH64ELGuEmP1I8Gv3BtJ5f4Z0x6lMN7WC1DA/a6n7MvphihmYIeui4sA/2t+zYYXGrlgvX3tcjuzYUatWnDTNeTnHocAIq4X6hhLXvtKNaK/tsZc7qn6v1pcbYY62KgWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TB7S9NsySei9ez5gU9yvwQEff2e31zea/BxFpbX4MFk=;
 b=pipB9gZPjOy0MU/Hip/TqxCuKCkpAecP0QpCj1tvqrX+HtZS7EpMCweN3nEV7HZzU2J/BptGI3g12zAu9rft7yEXp6MyYLPpz1DY43fWlACqY9sIu71cPPJ57zNVvJaquTXTQt0I2D+yopT0zkCAU5iRRuQ1U95Exr6wPnEoDG6skE5svPmwr+/fHX+93CyX6eNz7Ifpegw2gL6z8g2S/kXaiVgnCQ5B47gHm7WTUXe1uhEOl7511MsCfydoCbAxg4Wt0d0f2fDP/Sc51MhmMO1ySQC2tEw6/RMkoQe2OdipwjPLfYugx5i0OonvCpfRQnQiZ6Ccd2OFrdd9QT+85A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TB7S9NsySei9ez5gU9yvwQEff2e31zea/BxFpbX4MFk=;
 b=gD9RNtzUItLCapiRoEHXvLMsDAVwFPbBM5FMfNIG674jHJ4unmcjP6HkqK8j2ODVShjZadfi9xw7NmUJiv86hmVBhyANrTirUbNuYoYnNZcKhgBBjfU+dMYwCC1+5FCyJl8dqzSW6UJotT+41/1BEYGjuKOUp4xqRYIb83DZmq+RK63rkzvwRasgBHVSV8NSGAPi0CiX5/+6oOcLsYcCq5n6m6NyZwqHBg+nW/eGvsobZN1/NL/k5AA14UxRo8TCctedl73Z7nLgZ40lVfXJ9/Up5MQMg1iJrVYdUgOcc2yMWMPI2QQF715UkJ5Ks6GrKEoJybIgnY30iIQVV2W01g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6149.namprd12.prod.outlook.com (2603:10b6:208:3c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Fri, 6 Sep
 2024 15:06:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:06:26 +0000
Date: Fri, 6 Sep 2024 12:06:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 4/9] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_strtab_cfg
Message-ID: <20240906150625.GA987149@nvidia.com>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <4-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <20240906131917.GB16959@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906131917.GB16959@willie-the-truck>
X-ClientProxiedBy: BL1PR13CA0300.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: 9043448c-a4bb-4ec9-b966-08dcce857ac9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JjqXuhYdcoEjPoQBeiCND+JCYAiYzN1hBVEuSuRKA+vEx8enjHTCni5aw5SU?=
 =?us-ascii?Q?oDEXQtD92IAudKgsA33r0VinThTPJFKYSPUn34NXINcEmakHo205RvP8wnCG?=
 =?us-ascii?Q?rPGeWJ/iVaifLzG/2uDUyMK4ttJZkRDL15HX0ykfgYFdDL62YArkzdEXOYVz?=
 =?us-ascii?Q?6FL9zsrnZ8qKikDjhsjHDDxpRycwzPglDXLdZ+yVRwchlPZrIFHMMFJGey5o?=
 =?us-ascii?Q?Hbhq8eG6IWW69x5MT3RHmwRHWLcfLiO72IJEnJGHHoLcvppZ4HtQtPg0Zd6Y?=
 =?us-ascii?Q?GLxYyHecuMcHrUqWYL9Qz63QBcqs04b51M9y97a6kWKAtDLIYRVtCyNF78tG?=
 =?us-ascii?Q?UNzj5cvE8V8fbQS62h3dC3yrQVlF6qj8UfqVUetTsyV0otIvNqNhX84XXLYP?=
 =?us-ascii?Q?0giq4squP5foJPTtWIXdz8SkquA6fPb2TNulrrT0UrhNXDTKflIXwifUePRn?=
 =?us-ascii?Q?RwPZ5wa1i2BjHvw7VyxCrL13ZoViyP3TJKAIvrX6Hl5knXbOgKglTB42cSNR?=
 =?us-ascii?Q?dRtMVvy/MK2c8F2iudQHhWEwya4oSeAm46ZAiU8Tcj8ehGz0HQPob1yFAsgd?=
 =?us-ascii?Q?Yd9fd9y5HdlP1VOeg+ZWLRGGTwVQiTeCsn/1KajMjNk+v/bE8OC77M/P/rQN?=
 =?us-ascii?Q?ft0/WasR1mOqtXBZBILrD6JQBxIa7koQvo+gFv9k/bBq43RYZEGHNlfRsNgB?=
 =?us-ascii?Q?jDx1JHAHjo6fzv9bAh0NK6SpsJadEbYF/FJTyHiFGs902h9hVem46eshCHjK?=
 =?us-ascii?Q?e0MO732Coh4M3QSY5toIW8tp4cgdFBBHhIz7xfdz9u9XQOskZNAUBoQqgrH/?=
 =?us-ascii?Q?erknzpS+rbsPrrS9WSK14xavTZ0o2ME+Zh3fZzY3hFIGzmkIXbsJjq1ecJiQ?=
 =?us-ascii?Q?IKL1tRKSVmEo8PsmUN7H8Cb1erAkgEQMVidids+Q+d8uHDD8ixuRQKRZsAtw?=
 =?us-ascii?Q?M9Fk+cMg7ZQukMlUPeRruQFhd7WhQPZoaNzj3GmWUW2fuF1VQUxbBS5x0p11?=
 =?us-ascii?Q?eXs69oNl9ym8EH0rgd8c5vXaoPiSqkNv1LY5moezFnOH6Zz5BmmVgGr6GA13?=
 =?us-ascii?Q?w1XI+kY7pBCyyrnCBPG4CZl5uo/zaIsilR0w1aXnxz+Y8wWskXUmy2ruvHnD?=
 =?us-ascii?Q?tZSKatjhbNwxQ6I1d9fU5lZao4D/q/e+BVPdbhjBM1dnVMt8IEYgvTZWxTsw?=
 =?us-ascii?Q?V9rc/Q/D8Z5Pfh9PS6U5VgPt3shyQJ55FoC1+3hTF3yFsGbYItxeh1TsnOGf?=
 =?us-ascii?Q?qt1ylBunD1TPUF9Iy3doMen+z/gS0BxuuCG1XzPSRVJb0GfzX/oGM0Zi5WXg?=
 =?us-ascii?Q?iYgnfSCem3sCqaCpaDy0hsCprA3QDYE8zyGHDPrVVy29Cg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rEvY28QSvaLMG0Y01E5xbV+UFJBG/GmWlMjNg689vJJOQXqFRf/TdtUepn+8?=
 =?us-ascii?Q?KwKVCpa1C/bf//4s+lzniWnpBcSscrH2f5RM10tKnJ4ZtWbV23NjK2Eukyud?=
 =?us-ascii?Q?ttUdwD7r1Gz6eJWn9pUkIC8m/oiM8b0VNDp4VIvqTqJjD43GcGqF63yTiLOZ?=
 =?us-ascii?Q?uhN7jOE6VGEyovJefkis/N1HabtNjPg2x0FOWkm2sNg5ie6C3m96cC3Wt4nz?=
 =?us-ascii?Q?5KQLX7+2YH8xaWyKuag67D1DRIdyXXhNkl3onpbv9VRkpQRkk1CoTRdKL7Pj?=
 =?us-ascii?Q?2+0izawGOMZrloeQ5mo1gcdVrIPZh4ZybxzZJFZflZ1XBHee56f7nxo5sXRL?=
 =?us-ascii?Q?cUSNMI9g/OKtScJCK0hz5eG80YvaI4q80w4KsLQSic3ozOw300/tx1W8nHHJ?=
 =?us-ascii?Q?fQKQyya87xI8lefIStz6eonEVfSZ5ZfMh/J51nYDHag90V0DnZVaHI8rU/Bw?=
 =?us-ascii?Q?12M5eS5R5w0YDVkHGNE2oQlJ7Ye7VXTL9YOMiu9sFsdu2ERKs3T9hTk9nA6V?=
 =?us-ascii?Q?emseaAASHnYIZHpNycD+Ml5gCXaa7Wu50LY1/aJoGizNvkp+SjRYjPxS8P58?=
 =?us-ascii?Q?JOun3jxZo6JD0IPNKqY0p8PsfLDxsJU8r6BFID2w3aBPR7ALoX/BT+YgVal4?=
 =?us-ascii?Q?m7WL6L/QyuHzX3RV1tJleX6nfIAerauo0Rg2znF27+VaCXGjOM+QGtDU0bfz?=
 =?us-ascii?Q?VYIcKJEgu5djk1SLNZKg3LTLyb/gViDxPrhZeYtxO3vnddtpfs9z9OY3lw2k?=
 =?us-ascii?Q?X4RYQIJuu7Gcdo8CfFUh+TlYpnrxr+Bj37iARAHSe2rPGTQ9lFjc5y02vvDX?=
 =?us-ascii?Q?dYb7HCjMxZeu8xc4qx75F9rGo81AHIZN4077g0s5nRF5UMvaMphJlYefsHXu?=
 =?us-ascii?Q?9HUTFYKhPOufdhVaEF7T8W5pQZiVBha2PtKiTSUMVcnTmn2vJIQ07Fr+HSsl?=
 =?us-ascii?Q?Uwxaj1HBPHXM3xjZhc1eDk8iAMoiVL3+8EjW3HwD5dT3s097jToUNnc9kGxD?=
 =?us-ascii?Q?J5uHrDQaZkNK882ozYSbzbEOrzoTerE//PNznStHe/wjOYMYVkYf4R/qnBXD?=
 =?us-ascii?Q?GTf4ApkfKQ5ubLSRnFDn3IBZ9HryaROkOJ4cm4T4TO8iLj/Bj1scf13hqWYg?=
 =?us-ascii?Q?UZQBziz2ZFmL5+W4YwqZf0RP5Y48MjEbJQb6598yodiN6MrqB9EpbdGliQh7?=
 =?us-ascii?Q?K9b9luqKsTMDHHn3kjbZ50AOdb2391t95/f6TAs/+HzVQ4+dOTRQvHKclE+F?=
 =?us-ascii?Q?9ukQpCSG0Xwomrpnhck6gRwdxHdeyF3HuSCpNAwpsN1e9sqqlPprWiHVBdaP?=
 =?us-ascii?Q?9d5Bf7jqtZxQHAnMjK2kzmEDMmURDJCUAsBPlSvXXSHmmVsp1YjPShZGcd8a?=
 =?us-ascii?Q?i+ZEO8PgoN+kL2TPAs2wLsUfmZMln/kdUcNhUskM1wp1As1s3tPm8Eaf9eAa?=
 =?us-ascii?Q?dAPXRyFYjEoTHp6y05d7Nl7kF7piHRYjcRQJy8++eJSCpsRVPU+yqQU9eulm?=
 =?us-ascii?Q?rS2PAM0i2P1uuASV6kBaxrjwMyc0bI6F+SBREt00rodVjmXJrORy0TZS2aOE?=
 =?us-ascii?Q?t1KQ7OBuIndKoM9UPFft/suqWAH5dRSr1vY4We57?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9043448c-a4bb-4ec9-b966-08dcce857ac9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:06:26.7484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqgDRKnJF7U+J94zL0Hm6MsxGi9Q+AAId5lC/HR50zVhdnJDK1BM5mziB3OX+fj9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149

On Fri, Sep 06, 2024 at 02:19:17PM +0100, Will Deacon wrote:
> > @@ -207,10 +207,8 @@
> >  #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
> >  #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
> >  
> > -#define STRTAB_STE_DWORDS		8
> > -
> >  struct arm_smmu_ste {
> > -	__le64 data[STRTAB_STE_DWORDS];
> > +	__le64 data[8];
> >  };
> 
> As discussed before, please keep this part as-is (i.e. __le64
> data[STRTAB_STE_DWORDS])

Missed this one, sorry

Jason
