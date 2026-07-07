Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD903859FD;
	Tue,  7 Jul 2026 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783447699; cv=fail; b=bnhpaT53Ri9TJg99279lmfCZxNX/LnfCPIky2+uWo3DZ9oL1B7DnV+Tjo7Ap9GhHb/EhK5XV+DY75qRan7CzfHsd5AE/5EdU4EOUJu6doXwIhk0WA0Z+iGrgcXfZ1ROCIFAMXUmqcjfY0Q/Z/Gox4ZBoiYvYp0qrKbYlMiEKW3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783447699; c=relaxed/simple;
	bh=RC3dNlBAR6ONOLfeHygyeiD6qTZffC37EqkdFP+33q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BhI2Pkop2zNV0VtLSRCOfC9TN6QYAPXUtcGcfSarK/7TitpZKdoV9qIdjFH333EjNwafcRRnOJA2u2L7uyZmmTbe99JIqw4Q2FS39Zhs/kPOSwZImNvqQ7w4A6sOCfskklidQEK+3LSQwRJA5w/GcBtzd4sOvUSKFCwmPcTxe74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sEmit50N; arc=fail smtp.client-ip=40.93.201.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sEmit50N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jO3ibcj6SoxqdQgD1nPbYQDeSRgl2JGp/oba3bRnIpM+r9BncGp243rXGqmbT924c238FmTjni02WiWsWcYijzcbQtlar57JPZi95Wx+aKef+BiY8w/Lg4FpiOG6fOqb6IAcM5EAYXuiUfIHCInAjzM6lhPo4L5cYNZzWAohg4UfLVAnKTnFuap5VP8RN04TvTImd1pWEwWFdAABKHQ80lxoDFz0oEAy1S0Vn2TR0cR9HE6Tq0iuMgXRZWiPwS5rn0PeRP/QI9mPY/nKyApNpMJLTF7d8XtJNBEA9B3xMuI4td8h6CxDTav6nKnHchW4eMCKgebPT+SZoJOBEowYWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RC3dNlBAR6ONOLfeHygyeiD6qTZffC37EqkdFP+33q4=;
 b=Izfh8xsQWE6gqNxfCyg7dMp/Hgw5ICL7REqSCP7i8FSDXWoML50d+Lkunx9Q+jZdxAJK6d9LfUmQOJjHWJQUWRdDbxf4AYER2c8clySgsK/UHWhyCNrmizYmq/G+fx6LL9MLMd0fD8Jm+2wypLiRBxGfdbiYAFjl+gtwk3uHpsjjSP4MxGib1P3OQutQwCVf6Jjd5MQMKqn6Bi68oUmyeTeDjfnpyyBz/TmlH9DxMHzVyZg6yrTFXUGa0CeDvoFzwCEVDn9AyPWdovUoEKmkjE8NZD1k9UzLkbyviO4lVCn+MsSe+0vpwd1G/FQqmFDLU3yL1DAOsC7MgTANKZeKPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RC3dNlBAR6ONOLfeHygyeiD6qTZffC37EqkdFP+33q4=;
 b=sEmit50N2cQY9lyMNTrRxts9J4pBmNR7w0dKtlKDIjARkxHhoR/BwZFQtjLecDc9u4R/RcVZZZFyYiuWqu61CSgjfhj0uGnecSnAWGHuT3Jh3ebBxAJEAdXRhAxvA/snKw5dzbS7Lq/xIUnhbSh5SWDI11PDC6n787jm4TPG5dZZ0tqc/ad7C/v4RBRbNKvbjRLZCgzUrp5aUk2B0w5p4qQuXW8huF90hcaMGR3UmUglz+8HLdnpH2dlNqDB3Qng5xVKeGf7vR/LjuFqwTArpwqK7PXAa63gLDs1phjT+lIXP6YxOKJbL9gIwqSkLg8rcInZboxIiiwwgw4QWQ5swA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7286.namprd12.prod.outlook.com (2603:10b6:303:22f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 18:08:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 18:08:12 +0000
Date: Tue, 7 Jul 2026 15:08:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <20260707180811.GB226829@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzh9qFEfi2umwDW@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akzh9qFEfi2umwDW@google.com>
X-ClientProxiedBy: YT4PR01CA0426.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7286:EE_
X-MS-Office365-Filtering-Correlation-Id: 258faf90-318c-4d7d-6a93-08dedc52b554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|1800799024|376014|22082099003|4143699003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	i7h3cWwlF2f1lnA9H8gtgbSdAnAoRVdRSe5gMnI3ZW1YD6qetqP1bnQhXb7oAS0qADa8c8BOlOipI8zoz70s/0nU94oNLvgyjFhxvNYcSN4GD2YTVh2Xr47uwzHmh7AX+Jgj52GSIhCYC4MuoMyU72t4AwIo+FaE0jnTYgjQe0TYXC7idQp7Vue84gOQoMvLl172h+j+ChD/UEky4/c2tV4qBdOeQi8hu9wPY5kmUPKT/SEYxw4rvtFoYR5voR4xduAtpb6SMX3M+ZkuHfSkrROUQK5YyPmfx+JRjHcgmitz1D9bsvaNWGg5v6lWrtZEWzG+0f4EXDv1AP6nmdnSN+lIuvl9AFsta/kLWPeNCvRl7Z/q9FmYl9Xgfj+OWmX2X9HW+c8tmvkeGjd/hPQucj2TsUs2I9ZIymqQ3gUjOH01Py8dpBYYz3fQyDgpMR5qj1lt5tPJuR75kzO3pb3N0cnYTcP44tfppCoQQK73tahUvYCKmnThn0vxGAroXOz5JPaCNxIgQm++auD8sepxe/HXuYJrTvDQPk1kKMUb/KEjxTL5Zruwah7IezezPbAym6KAKokdyDpxwuOEZGBYmdKguFn4ZmDnR164vhz/oYb+KRAk3nGBiNjMcITFBE5UTMGYkFxq7R418qvI5LpqLc1bHC5u1fIdxpUBCGvs0Ho=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(1800799024)(376014)(22082099003)(4143699003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVlTN3NwVWNnVjI5aVN3Nk9hcDlPblBoNTlrcW9mWk9jTVNWS1JuNFRkOStr?=
 =?utf-8?B?NnlrekpYbnh2RXliNnhkdkY1OHBFY1RaVEwrVXJDWFB3WnRZRnhXNDA5ZTNK?=
 =?utf-8?B?RFh5TWVsOFE2ZXhvbDUwZkVyZ2czd3J4blIwaFc2OHpWd3dvL0ZZSXRjS1hi?=
 =?utf-8?B?VUpEcGtvUE8yc294cmkvL0E5MkVHQkU1M1pFellMOHJMMW5pazBxVEw0WFNt?=
 =?utf-8?B?dmxTeXJqY3F1MnlWQ093QnNQZEhZbkpvZVh6a2ErTFNJcG0rT0RPL1l4SU9p?=
 =?utf-8?B?K1pwbmEvamhqR0FKUmw5cVpJZittZnFpWkhBVW1oNGNBQWxJNUN6enBPVFFW?=
 =?utf-8?B?RVlBcXozSml0aGNraFRMRHdCU1ZhKzQvWGR4Q3kybTFrZUxaaEJ0ektPRHpk?=
 =?utf-8?B?dEIvZS9ycUdQQlhqQzRYN2VNTVZOMWk5S3loUlVOZ05vZHVkcmFmQ2JUOVkx?=
 =?utf-8?B?Si9mWFE5U0VKbjhsdjJzQ3Z1TGRETXNua0c3U1N6ZmVlVXRtemtLQmN4TmxI?=
 =?utf-8?B?RHptSS82YzJ6V2UrNGtwaGNNcS8yemYvK1NPeXA3RUFKTUVJTkVTZUVxYUFu?=
 =?utf-8?B?NlNzdncrWGVHTDZpekorS0w0ZUduYSszL1FWU241VXplRVo2dkxYTjZvTnhq?=
 =?utf-8?B?dzlYS3oya3l6Q213OGlXbUdsaXNPODYxYkRkN0h2ajFaZUpBR1lINGQxVkt3?=
 =?utf-8?B?K25XdFhDZE9BUUNTd0dXQzd1dG11cUErWFBpa2pzbFZOWDVnOTkzYnB2MFU3?=
 =?utf-8?B?aThUdHJKdGNRTHNTWnRlbzNaQnhib3h2OG83S1hRSC9EMFBPQTFIcjlyUVcr?=
 =?utf-8?B?QzJFY0RiN1FFSEZ4T1NybnNvYWxTcjdjN0JGWUVXM1NHa0VwVENIY2NDN2p3?=
 =?utf-8?B?eXU5L2szUjlzM253N2IrQjg2N08wMDVHOUJjMUE4RG1UWWRuS1k5cGhHUjFa?=
 =?utf-8?B?Q3FQbTlPNk5GcitwaDlvcUpHTnFTVnBsVjhEekVBQ1M5SjZkdW9BRFo4dTI1?=
 =?utf-8?B?dlhFbWhUZHEzSGlCK0VWQTNieWdvRG4xcUtRR0JTb1hURHVLZG1BR2FhNGFl?=
 =?utf-8?B?R09YRVZKM2dxTHIraEJHN01PczBCL253d0EveGpjeWdsaDcvcHBsbnlsYWhp?=
 =?utf-8?B?RUxmOUdNMmZEMDNGTlFRVzloeHoyUDZDNUl6QVJBZFc2SkMxMVJaQXh5ZWM0?=
 =?utf-8?B?bHlQVi9reWtUQ1BnNEJxeEVLUUtnRnpDRWRxL01OdzR6L1pJR2dpY1A5OVBz?=
 =?utf-8?B?MTlneUVpNHhjNWhzbnhjbTlwdmNGWDZDeDlhWDg0RFp5OUpxUHE2QmdIekJi?=
 =?utf-8?B?TmdPOGxSMTJkc2R3TWRzK0JWaFFVbGJHVEdpMnZjQjd3cmhLQ1J3aVFQVnl5?=
 =?utf-8?B?QUQ5emtWVndMSHp4bmt2cENvTk1uYktVS2RzMGFINGJTQ1BocUE3U01NWG4w?=
 =?utf-8?B?WjJiQ0Z3cjE5azNFZ3krQjdWNVZYSm5OZ25BRXV5NkhXdFcvbUg3QmJDSGpl?=
 =?utf-8?B?TlFvbGNwaXB4cHI3b2MrWTUybk1iUmRhZlFmdlQ5KzFOUEZCQ1ppazdFK2VD?=
 =?utf-8?B?T2E3eUlldDJyNUd6bEJ2eUU2MkorOUpMajVrUE9pNkRzb1NOejA0ZjVoKzhX?=
 =?utf-8?B?U1UvYVhYb05XQko0MkRjWjFLNklFcnY4c25RRjN1ODJTZk5LVTZBNkdNcHd4?=
 =?utf-8?B?d1dZeGN1SFZyd2ZpY3o1K25OOWJHaXRYbjQ4ZTV4RFcrRmd5bE9nUVR0K2xS?=
 =?utf-8?B?d3h4M3NROVh5SEVrQXNhcGluQnBFK2RmKzZieklVTFg3aXI2ejY1ekw0VHNy?=
 =?utf-8?B?b3JoR2VxM1p6bjhEVlNZZ25QTWFtdXhMWUNMRjZwOUFpbExuRGxJN3VpOXBD?=
 =?utf-8?B?dDJ6WW0waDRRQzJ5OHVxYmVjNHlxc0VWMEVsa1RyTWc4Yi9uNkdLRGdTQmgz?=
 =?utf-8?B?QUp5N2h1WXAxaEprbjBUanNqQmp3eHF6ZWo4VlE4clZMaldBWEIrNmorZTZJ?=
 =?utf-8?B?allLelFIWFNIS215a3lNaGxPa3pXUTJhanRJSEJvdXdweFlZT21KMmdYRnd5?=
 =?utf-8?B?NE9uSU1xVGFlcmNuM3lmaHhSc2FBSEYyeFVRN2hzMyt3eUJjd3FNMG52RHZn?=
 =?utf-8?B?ZXpLQWlxM0t0U0NiQ2wwUTJmYkxKMmxSTTYxb3B6MER2SmtVUGlVVHVQWU1P?=
 =?utf-8?B?VllKMy8zNFBqVFlsbnRiMzFzbGVkZERJRWp2QTdKUEE0TVIza0xtYlFRR1NX?=
 =?utf-8?B?ZklFSUJ4WXNWcEMycE1hK0s3em93Nzd2UGMxK0JPWGNGWWtSaFZvanU4N1Qz?=
 =?utf-8?Q?GbuLXvqlILT5VBo0Ab?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258faf90-318c-4d7d-6a93-08dedc52b554
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 18:08:12.2801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7UdSQ7VESj6LDDIUi7H+WXJWAN5oo1mH9YrLCdOs4UPOsy9Ul5MZpBnhvfzs087
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7286

On Tue, Jul 07, 2026 at 11:24:38AM +0000, Mostafa Saleh wrote:

> The smmu_domain is only used for the tgsz_lg2, can’t we add that
> directly instead? Decoupling the invalidation form the domain would
> make it easier for KVM to re-use the code.

Sure, done

Jason
