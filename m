Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B791A01C6;
	Fri, 13 Jun 2025 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822088; cv=fail; b=Rh2L8+KF88PMYM6IVVFyYU8To08zzK7M0AqXXNu936prOc0rwNe/XH8Gy725QE1/+GOppceYTpNwc6dOoG0LHoyGiXK+WstfZ2pGZk/C7WqKGD7mK9xjXd3I31qfi/Usq/s2wutTtHBm3eHfzqbgWZYYHfa9ONUD/u8XOtqXzkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822088; c=relaxed/simple;
	bh=ThBTqwbMB/AgbUeJyeHGrGgvv/Zs+ws3Vrva8LeLZks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pKlPFb7gtdp7n290wHUUVoBt+akM3Vhio2EouQf0RLMw/aTJjPgk8VFdjha7HUjCvHIpfcHFM0TP7bniVS+Mh48gNV8dsj2JVB/KLdc6NQSskDXpxr3x5jzbjGmGWBmyG3inOTnHl0U9oW9sNA9pCYDaCNDuYHS1UGrmuQZKpN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aSALuL89; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aSALuL89"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aXFzIujP4vpatSU834a8WKfMpLxcSH+f8THR80FsimJ5EAPNTT5xi3UpSysswf4aR15Ub8doSZYjcggswdRL8YBVARmB4iLKoW6uVWNgqw6cW4QT6/mMMnsMoBgUiAJQLWw8rQ826saVl8oQzPWFRiR9ukFsqhUPzfkNZkWX1CO15K9ksEiADGRc7BxRoiy5h+SlqSzqmFfn+23ntbzp6Y2ssjroaclHZAQF4zaeV8cw5dh20WQW3PYKM2Gnr/QweNXvdfqTN+U07ZuGfSJXf3p55b1AL79aqTOriQgOBoP9IF87tFimO3maoCjSrex4Oq6hiBnbQwzSQALKssWSlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoEfkoh1fvaR5bJ2rLRBKfhRGfzT75fXqJgrzCMRsyU=;
 b=ezTUs3FXKEBAUWt7iuhKyYx5ynnqq89Eoy9v9GfEvSer8UeZZ7wKoOajoaHRtz7XXFhsKinqJSMjo+0P08GKp2GMolQ/+Ihq4y6JXTv5QfZm1DdzWHpdtC0Gx7+d46INroDE3N16aydUG48J1516ZMxfjw6DutNiiqG8lLU7eDUYezPCUBhKK1vjOhlP7INo7XjAG4Sd8YyndQYLCI04svtq0NM5UTy4q8QlJ0qBat6KL+vv1DO5uCSvbSonGWyivO1JYyH7LvYX06XAoXt66CVN8AkbK3uIUoZ7+2HN79M1N7F3/52D7xYt8zPSUEhRpTr85suRHdWEI4JpD5U/Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoEfkoh1fvaR5bJ2rLRBKfhRGfzT75fXqJgrzCMRsyU=;
 b=aSALuL89PJkc2+lUw+vC1esRrdZOrIidlo/r1joixVH4R52qbxhWoK8A3dAm2YHDKrjlyEaMzMv+s3PW2q3F8I+zmZ6CXhgUQyi/wurdzAGxEP+MEKyNjgL3LQhHScoTI2FewBKcS7A9W/jYOFNzYm4sBSNVusPwcNFuMXt8nRUdCueipLVAOjw9tGSSUDFVE2ELdt+hdlmZOpxuVKs8mLn3EyrpybJowp2ky0JofADmrO9LyHc/wQg81mw6dqFDtqzA4TTYOQQtEfsc8jkYnSjCGjzzxKNJx+qGJFHZfwzgIxhIWibmJqM8KYReCiWyO2hfb8mco1z3EWGhon38gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6977.namprd12.prod.outlook.com (2603:10b6:510:1b7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Fri, 13 Jun
 2025 13:41:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:41:19 +0000
Date: Fri, 13 Jun 2025 10:41:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 05/12] iommu: Introduce get_viommu_size and
 viommu_init ops
Message-ID: <20250613134117.GD1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0440.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fc8226b-2c5c-4508-d036-08ddaa7ff9e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5CIHuoklU9Ago2BhmYSvKno/Vqag1zJSf8BWhFDHNVa/rycFY8y1OqRxAFMi?=
 =?us-ascii?Q?PJ1TMJO+xAr6j/FWzRK302E3ZtepXOXzySmzVYectptcW6pLhoBn+x4YvUii?=
 =?us-ascii?Q?whaN/ZtXPppCeKbBMmJnSdPfdH4VgmY5+5rmZYe7SeQlrd0L4iI3/vUiO3A1?=
 =?us-ascii?Q?45n5KEGp8RHXlqsZ02VWP5BaMH/ZShs/nldM1j0JyEVBa4YndyLwehMAZVDN?=
 =?us-ascii?Q?9g5cEP4AW2GD6n3USeZHRHWinEWyQMTbbH7DBiOt81f1KH8epPFh+wfbp3ab?=
 =?us-ascii?Q?X/2DnbWInDGTMXNmYOP3fUuiTxdlAvP9U8YIDRFAueaczCZI4tjyUrbPWiaV?=
 =?us-ascii?Q?G7wyFnIbCZrj/dc6szGzolXivO5AhPVXMKVmiZ7Fzq3l+DpdO0MrgK8t6qOt?=
 =?us-ascii?Q?tYOgfvUxNYTNVVTY+cpNpBdL9Cxk34BxuNr/jtEdKlSu/iobcDTRAEZpl+Uk?=
 =?us-ascii?Q?McAnNoD+lb8inimNosxsaepYrQkm84iFZ1baM5wBJDmUT4IZ+9YcCnl3WQ1f?=
 =?us-ascii?Q?5iIu6n9VX4VExrg1RGE5xnMR/wUFuYyNIywWBFzKVJdXQT9eytHrkYyFdGOd?=
 =?us-ascii?Q?oi9nCqmk34MEK7tQkvzGVXgQDIwzNAdl9Vm6mvkY7h6TZUOgtniHH4KWzr4l?=
 =?us-ascii?Q?Y2XYyKrMmaawK2ffSbEuSwhaOw5wzy75Ku43IBiIrpRBeClYN/VComn5vs9D?=
 =?us-ascii?Q?xMnd/oC0ROJmXxZQOPVwQWlIzAQgLGKZc0fbGdHgZ9FwrErxg38ToaNV6Yky?=
 =?us-ascii?Q?J7/C/T/+Un/SjrpwBl7iEoi9ImkeZ/jdHrKBvE35/v/yZQvw0DQtXl5syzfi?=
 =?us-ascii?Q?4O2laacXe1pEnuNf3Mx7nP84BCTFs++HQ9Zdcz9FMvocOXCUyOPXpWFPbLwV?=
 =?us-ascii?Q?GhYvewSwbFQqvcI+bjcovDTUOlMpufGOgCppanfdf/uZ0NjV8k19i35P7qqR?=
 =?us-ascii?Q?sCJc/McPl+w8IxP5qCgCoVMBGXGE01hBqo6PaLElSBbDWZk03ubsr3yAiOVP?=
 =?us-ascii?Q?CbqW+1tM3dSYz+DTeBsEuOp6SxHxeAwRLpFKRCbzQj94AnyASTC1te3Ww91N?=
 =?us-ascii?Q?rNPK3k+m+7lk3ur6sUqVaG6iEVHLbjRfAqJ10TOQ93Zl1n7+zYYX4905Y62J?=
 =?us-ascii?Q?j16aDUcNwzp1/P6miQYta0aE9nld9Nx3DoUZ/SteiAaXqNHQOOBc/Z1i0K62?=
 =?us-ascii?Q?bukShtTBhc1s/E6e9LqDesyzlQTouaMwae949ahBzvIIThcHVesmXn+nSEuz?=
 =?us-ascii?Q?P2QJIbkM1qdXogP7EmGAmik5GnJXfU26iJtc5O+orm/1vqrpvC/mkqCbysUc?=
 =?us-ascii?Q?gPVCABaqRGsIpbV7XObZ3bVdlC3sKRgoccKHEhEcRnbzQ+DI0CPj90jtxa1O?=
 =?us-ascii?Q?6RX7znCwAa8D1/B6rN2XwOI6j+3Rluw+LHWyjrWsfs3lb87Bzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OjQVFcVx2Mhwb98xlBmqhqbP8+diFfPLmo2T5lOWRVWrsV/zKuk9kELHiSeQ?=
 =?us-ascii?Q?uVtL7aE1S5LJGJ9/A5H5T34bHsFV4ffnjtkgfT0p3WjDwve40awQUxlyFedM?=
 =?us-ascii?Q?URDx0dQly9GzWXZYNItmKcqMQ+B5zdDeRaCmXbLoYCXyNM2IubPf3YJM/CYi?=
 =?us-ascii?Q?CwGmp7kooik2v6RHGUFnD5fXQTA9VilwaoF0GuI/iXjh7KZqJJURXNsgJ/rp?=
 =?us-ascii?Q?HWFLsjgkwb5cyTp68JhXvkcTOkbxITXnYYRLFnnozdASUfI/VMPvyDn0T/YC?=
 =?us-ascii?Q?incUAueXM+n4T79JZw0uWHjqTxLHiO6VGAppOuH7uCkrX3NZXzbhaBr8TeWM?=
 =?us-ascii?Q?/M0WTPLXJvN8rdVGDnqgu9YXtxk3ZbOzKwh8+uGwi186QYtFBPl8YgcyjPw1?=
 =?us-ascii?Q?DbG9sSePH8gSnFrgGy4Lec5aqUW5EmuPz050oVonulI0Vt6acMMgTe6tLeaD?=
 =?us-ascii?Q?fPCOU4x+Gz6lZZw6s6lAxDzWi1Xem7Y6vnHU3PhblBaVlqF3evZsI8+VDZ5t?=
 =?us-ascii?Q?dkR8o1TtVM54/x5ccOZHtetTPSJnB1vU8ZOkdV9P9G1bbm/zuZZ1KuaxTh6B?=
 =?us-ascii?Q?utBQMdR5WY6G4fwlz0FoJeOPJYRSw/5WYk+Ent7Bapeumly0G3hdb0WO8Sw9?=
 =?us-ascii?Q?MPdFSXQ8ZkkFqPsOVOgpHXfiN787j5qHyvG8UoIWsPKp5NH4Fpt5JYfhGWo+?=
 =?us-ascii?Q?L7v/RJStrIYbVzA2Ky9A501mxtNDoJkJjxyJjYpfBpSmKq+9EC7LwfOrvOXO?=
 =?us-ascii?Q?cvrxlhfOHFy+o4WELb69jtlVcbi1LV8zw7Bc2UTcIYjOfRbzvXIrWmmZTiv8?=
 =?us-ascii?Q?oWurtAQHq7rOusvjSPfqj6a5qUr4QFPqyoIRIP80zI1fNHqlmcj07ow1+l/R?=
 =?us-ascii?Q?Ae/PsywMm9K9X4bPdORP8+HhWdTO9i2Er5tAmHwFINgjCEcNdLMMO43Iv8ob?=
 =?us-ascii?Q?R94G0Cj3rv81ftT8x5pffvlTwOJ1IkczsKfILCyU+yvNg5x4Oj63VdecPSUu?=
 =?us-ascii?Q?a10YALMliYQdXt3TJTIntejvmuDpnZ1dxdjiygZPubhtSd1ZN6dBTCD8BIdB?=
 =?us-ascii?Q?4lCCVQTM++QvBk0ub9hUUlANpN2uORS+ZeJ1KzFDA9DTqgbqGzX5CBEb0hZC?=
 =?us-ascii?Q?ZKTHIK6zsSMBq0ACkouY3I1e6TF+zZQkateR9IQUC7VVH1t6n3LHWmyGrUFw?=
 =?us-ascii?Q?0Nz/5H6xzf8kxPXYBYR0+01XKn504Zz7xt0PhwF+SDmQhGBO6uJzAJoKxWf3?=
 =?us-ascii?Q?qK+a8Lkj6c9yWXcoSjKJLvLl7F6xHSX4gYjgM1gPncmw0t8hb9YoXfmAGM29?=
 =?us-ascii?Q?AOLw9Wz3tgjqRw8ljUb6qhqdmE6gQ50LGZuOQUuNdi/m5kdQ6VfTsrSh6qXf?=
 =?us-ascii?Q?XsaimnqwB7CnPPXlcCAE5xQALmHAVG8ojVUPYqauGzj93g683a2KjJYqoBVV?=
 =?us-ascii?Q?H9UwslmrP+/k9KdcupPsWzl+macou4RcfknikJ5UkKtFTCBCENcqvjFUElNE?=
 =?us-ascii?Q?xPdhQApAhI3vd97E/sHo7X602TWY0a8RUgIUHpkbdNV7g8Lgid9g/jb5a1nz?=
 =?us-ascii?Q?nReTaVN8S6mJp2hdsYFG2ntzF/eJ3j4SERIRSNVn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc8226b-2c5c-4508-d036-08ddaa7ff9e1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:41:19.0094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7f9tnTAO3UGZIDALwnE+6X1DsvmTCQ30DCdf7LozQFNY7ImCCt4vsgQj4Cg0vKn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6977

On Mon, Jun 09, 2025 at 10:13:28AM -0700, Nicolin Chen wrote:
> @@ -654,6 +665,10 @@ struct iommu_ops {
>  
>  	int (*def_domain_type)(struct device *dev);
>  
> +	int (*get_viommu_size)(enum iommu_viommu_type viommu_type,
> +			       struct device *dev, size_t *viommu_size);

I'd return the size in a size_t instead of using an output
pointer. Make 0 mean not supported..

Jason
