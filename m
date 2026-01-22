Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013069.outbound.protection.outlook.com [40.107.201.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE35346AD4;
	Thu, 22 Jan 2026 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769091173; cv=fail; b=P3Z3Ht89LJvrIlEznt8DH1OI81omJDbwmzspiQ5rgs7ToSqSZ5rW5tW/Fyi25dneM8m/d5/ORSH9hP9nSIhokru8iDgtjLumkCfIyA62GRNq1dDT0c0v7vOaHOLwz3u9aXMZZLEYYAKzMd7uf5GwF6qMstiSSpRVXkAJEM1cjQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769091173; c=relaxed/simple;
	bh=HTzJOmhMJSBpcO/nfeasf3Z+PbY3oNLcUtKUQXjj2W4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eSz7LiIDkGheWTXp2dyy+tWrSb/GGNVwYt4AgsTMpquDBX5wcnCbzOjrVYleqJmjwd9h6BrgI5TePQTGxEhFE7yvm9rxFKaKlpcGtU8ueNS7M+DiIuRh6FrdCtr+O1WqXZW5FW2pgUPW+Fek1oyG7rF14sufXoJmwbXnJE7J62Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LsBSTm+J; arc=fail smtp.client-ip=40.107.201.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LsBSTm+J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=frODclPiICyZoLhIEpPg1HURclbXbGvEtpey7es5JZdsJDxHar2zoeGhvL7bOcazfRoCgVZ0Cq58mRCB1RmySPoDMWTqoxSQTbDMjv309QA3iP4BXzhUwHgbwZCRCLZO2jb4CIcDgqwV1hXK/eb0Tpj/dVbsxekl2LM9dCdFV0/q2bnRWFjDProOCJ8tvRoLj+xkK6jsXLzZOblg4bD/vgvl/vIbMLYyNUsEftqjUKQcY19JP5h6L05gQkne5T0X0E1Ovlm245/QMZ44ymFcpab8DtdMmN1elxkr9sp2H5snG9yRCe/Sy2pPJLJlpL0dy+0j9G86+Erbs9hrm3XKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1Dt4odECtxhd0yV6f7cH/RdlrpOYRw/5tL77V0FbuY=;
 b=g5SoOWdsxRp5fkDkWH/ir27tUENAdxQNxpKzNjtZ57yMbupgnnWB8j0z/NyDxczCycjxWhDxOUFT1v3zr6sQv2V6t4US32g6+2nqNb1Vpk1pgE1VCUx99LmHwl2BL+down/MolQs8O0DOUNYhHryYWKb1ggxX9FMQjrkyfQZrFThisHBgNlMCnKo7ZKZufOmtL7zpth7Isr17g0JgGkxmODrsjBlCFTQKVRqmDP/v39jFVJa3sINJzCYiaA15mTllEs+dXyWpjUyx5ms6nMOAy/uQBwKAvL2IpGLje9tTOvC+ZVvJVRJK0GroBxTz/FZ7EI1c22BisRzNOB1pnB0FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1Dt4odECtxhd0yV6f7cH/RdlrpOYRw/5tL77V0FbuY=;
 b=LsBSTm+JoXtClYKOPK3wEaATH2YQHew1RNZDMsCzSoas47cjBbxpZDy3hsWdoX9B3cPLfSkQzm6A0UnH+c3s41KpaYK/K1IivbxXCrNZW4KtxtahIdh9XKJZCvHt/hqW3qoFGFnJZmZum1KaGApZQ4i4H0Vd0NroFl7DFYvP+96m5jJ3yAl+radoxfkvHYKHigDn8/DrKP5k4hD9m+xBbH8duRUrtm93OpeDn1gy01QiCyNJdV1zTyvUmNmD72SgKNESeSbqxcFq4wOzzt2wzRMuG//BRDQ5dCVJ1KK6dJ8Jr/9Rg98J7zkE3CPBcAM1CvO0Yma+YOWAe9He8elOgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 14:12:41 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 14:12:41 +0000
Date: Thu, 22 Jan 2026 10:12:40 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
Message-ID: <20260122141240.GM1134360@nvidia.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <e0514ec6-b428-4367-9e0d-cfb53cc64379@amd.com>
 <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
X-ClientProxiedBy: MN0PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:208:530::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV8PR12MB9715:EE_
X-MS-Office365-Filtering-Correlation-Id: a23f7c04-20d3-4e69-5242-08de59c04dcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JWeqs0gJaI8II+BoCnHEMAUkehKE6CDwtKROiIpZAUNMB2oq/nh8QpxllvyN?=
 =?us-ascii?Q?u13tMvHjZHyD2BuNWs2CpXmOcDWp4DSgbeQWd1flDPBX+ZYhyrfTcB1Vpoz4?=
 =?us-ascii?Q?mkQkZvjuc02Wbvr4yIpzjywIh1TM01f41aoeiK+vIlFGKYFGpjrXkE2UswAB?=
 =?us-ascii?Q?20S+hCgHIRvgoKfJkqzrWSUagaEMHwvZ73VenvAApwH1H8HAQzyzaEgwQ7CJ?=
 =?us-ascii?Q?4VARZWQEpYpJi/32t4Wp0BSCTDa4z1/mukPt8XFcjomrgdXvKmGrMF1T1VCw?=
 =?us-ascii?Q?2TEawaxUAeVRkd/QPww8gvn/CJbgfr90wrVj2zdYhxbiVUpa1Fk1PQJoYL2S?=
 =?us-ascii?Q?UMsFeauWkR6/693MmrLXL17/My/JCniS17940NJ0x82GCyamO5F+RMMAT+Wt?=
 =?us-ascii?Q?C2gazeJQRurZz5igiGfmIEkotQQh2Hn5NegGHuWA/Nw7L0E5a/pb9vNN/F24?=
 =?us-ascii?Q?ETRj/XYz00UKVkyRU+Ubf9dtwZcAXR3pkP5yxpFPwLXH5RTuvQVJCYtBwExE?=
 =?us-ascii?Q?NvqL/xTXurUnjWQ0hhMszniBTvxcwVpi+k03uKF8ecP+05uqgzSllbeuF30U?=
 =?us-ascii?Q?+1KA8MhvpKX0u/im72tYb7/GJ0GV6xleS/11KIetaTH0/F/DrhIPZXf5LxpA?=
 =?us-ascii?Q?gC7Ix7APeuj5xoWaiz7orYzOJUyBtNpxRQzMv5yHsCBLsbdmWPmcV0u10IBl?=
 =?us-ascii?Q?IorJX9NoGj/Pdx0F2UncKyMCzQ+B+rYq3rJuxtIQ+KprzRbdhoUgPZ08EFgZ?=
 =?us-ascii?Q?7g+WNFX+MJepWSx2JpW04k0pHjmzKnDmAeE2SETWQOORzx6AxExIJUE0OKV6?=
 =?us-ascii?Q?DynpG+kHhEJEETFcXjO7evsxx5WaB2iW1AyFaLswHaT/nhMbPdmo4aV3CVNe?=
 =?us-ascii?Q?qs4hshBLedSAopxgmZieirPaBxFv6V+Ty+U9AKaQMQjNkr8sl/WHUyUlWMR7?=
 =?us-ascii?Q?bYXQhyF1ckJFF/xOOLf1XKEQv/+SxabJ54Fi7ejVK5O5nL8ywo+SqTQHqVbX?=
 =?us-ascii?Q?HRXOCl90Z2oGx4I//7VpnYDk9UVAv4w7kXyw16dCsnFnfYiaqJrIiW3sfPkP?=
 =?us-ascii?Q?iyfq8J8UG9hJNx7dcFJDZL4Qtvn3AcT2jd/5WJuZQso98umH+ltckaphgMaY?=
 =?us-ascii?Q?jmnNHNAQ6tD+c/vUMoTKoG+2vaIUckoC6awCGnPGCWc+mNme38IH2/wFzhCR?=
 =?us-ascii?Q?ld6cvIa39RPIXi6a0yrOJA1QcjgNNpyZbmwW29M8zHJnF2ptpOxWg8lFJ58M?=
 =?us-ascii?Q?/xDqRT9tXo3fAiCLppfILHNEV0NNELplGlRBjeWnwkV+aSCbIcAiNMN50+Tu?=
 =?us-ascii?Q?GKLctdw+137DUbc1LA4AiQjRH0uaGn8vqU+DTafUzBYPjwxpRzopwn6jlJFA?=
 =?us-ascii?Q?1988isPSLX29g4i9TzSxvkmTSJsLLeZdi/F/HvIl2qisFUGno5r/EA00NcvB?=
 =?us-ascii?Q?bIagoP9IkJ3Tgsywt6BnJf+zdaWF+hww8VInC42SvWjHg8Q8QJvNkzeedEJo?=
 =?us-ascii?Q?rtlSDLS6FExhkdM0a7Wh8hfwnZnUBG1k/X5PI0m3XusG3Hj1TkPROCQZ8jfe?=
 =?us-ascii?Q?+sphb2IWOjJdNqUv9CY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EpRQotfEnTheiyVTW1B5SgbTUtA306t0mZRPIn3FODBggi53u7aCrd+5e7FV?=
 =?us-ascii?Q?SkG2Ldr0N6hhIJEjwfkSIiFEcaM6cr7SKVbMPLSiJbp9TjmyKgEB7ifC7KgR?=
 =?us-ascii?Q?WhZ6T573zccxA4CoWzMUFWJSDSGbV15uwy+3vvh4IokuBK3IiKLMrWkuwtux?=
 =?us-ascii?Q?VzY25UeOrgtr3GcISvBtoYclSo3cWlbqPLWwnD702Az2HKZCc2tM33GR6azo?=
 =?us-ascii?Q?QpgfhbkJkppuAI5kyXvaJPxbkd8RjdSRZfmmjRsF/OjykYfD4eHxirnoNwb4?=
 =?us-ascii?Q?BAPwxN8mFYRu2HCd5nOz872aRiFwUbrEWH4ZzmvdLDPofEaRwRkeoeENbALQ?=
 =?us-ascii?Q?TTITholyk9h229gxFu0sssoo0qUGvojXS+mHdzpdsVARQbkvO9ywFSxZwaTB?=
 =?us-ascii?Q?KRvzDPiYk+3mtOsDbQDueqfUsGxS3K0jnuqQo4hEM84bULn6IfubIiIozu6x?=
 =?us-ascii?Q?neR9r+hsIIb8LWzGEO2Tq2Pntx5kQNjUXcPJLM3J3l53fEMCSSBHZuK47e4H?=
 =?us-ascii?Q?kO3LGBSPi0Qio06NKSZ7Kg8HNQxKepPwpBwPmHpW+/JgeSarYg5NG54KyBg0?=
 =?us-ascii?Q?tmWHsT4ADM2iKc03QGD5S7uZWm4dOcsFpOt5nNETqeKkwK0WWhemKWVFLzxG?=
 =?us-ascii?Q?Pn4ttWxfBTmKxqihOfXfLMg1ZgVLg8KtTs0Tckeg8mYjvotpUH1k3IawekZz?=
 =?us-ascii?Q?xLqek1QiryMtqnO/M55FR07MSLWol/ehj8rwX53inmW+Y12PExiuLiIImqNZ?=
 =?us-ascii?Q?pXRlKrA96bImJj3SI+Hry8crp1gdbVD5zzNe77uI1UHcMvE3hncmF3ctLLE0?=
 =?us-ascii?Q?0MPfbV8IbJr+8b/fhQ0nQQtd9uD/1PJTSXqLaH+fCsL9UkCk9cdNaygGAAHI?=
 =?us-ascii?Q?FGQ+mR6bhN/Dl++WPg1vhaf5y3O9gnRfFhcpsgjIk2RN90e15d9Wcq64gj6Y?=
 =?us-ascii?Q?mSFz7lAIDQQf1SlXL6C4cyXhhY2CM1iNN2KPiNZN6xG8KmcVaxg+ZoCgYYep?=
 =?us-ascii?Q?2TxxPd5qFWGPmb76S9FFyGyNMcaHhOexlBbT/QjTyqU01KhpwM84IjHq64N7?=
 =?us-ascii?Q?ul7bGndhezyVbRIoh8MClPOMhhAoumcNwMB9SKQNyuRZFl12s1NjxTwDVBz5?=
 =?us-ascii?Q?dTI8lBBYI1muQ81x/AdkVdcMEA7boQyV+muUiwd5LEQsm0YKw2xmyPyNPCpU?=
 =?us-ascii?Q?VT61zF03xot7TUYkzaxRG8xR61M/KRmxIgBQzu5q9MmuJogySeep7GxLiF6g?=
 =?us-ascii?Q?uS2WLdgaE2eHv/GeYeqWyfAAQQOY0DEDaBnpnStIk5OecaBTJyqlAgwVz5Cq?=
 =?us-ascii?Q?C2MQtQLj3g/ZofsXzlA79ZCU/ewyTP0JoklnLVEn2gEdniPOfC1ZjZS1NI0P?=
 =?us-ascii?Q?/DEIaT0RcSodq8zAwFUQ5id/anlK57GBGKKGKjn5D6aPFPpBgS54Ji/uN67S?=
 =?us-ascii?Q?XBa89Dr1VGD6V/g2TUNFen64PdUy9ETlaeaw76OdGsoQ1FAtuEPckxtpUhrO?=
 =?us-ascii?Q?IViEsxNFloVRty/u7KjA56lnCe3NsaGTupZmdVzQ/pR7iJX1ndfe6OXtX6eE?=
 =?us-ascii?Q?4IC2IPZJzUe16/rTS14o8TkYo2An2ySAS2uk5r+9F1e+AnMneWcHicFK3XQF?=
 =?us-ascii?Q?Wn5ZS7JGXOkuGCV22a0p6j6pl25CFM26kwjSTECYNOiQs0Til+YOZy9Z24vi?=
 =?us-ascii?Q?v1aKGX18JWY05w5BZvjCv0IjGF5ARwF+KcFy+k32RRA5JYiqdVJQHIJUhTkA?=
 =?us-ascii?Q?wqyX/rey0A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23f7c04-20d3-4e69-5242-08de59c04dcc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 14:12:40.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rNu9goGvNZ7ebqCJTOcC6CtXQQQndH1yMoay8yBdJH3T4bPqsFbpEu6EGiEQka7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9715

On Thu, Jan 22, 2026 at 09:58:04PM +1100, Alexey Kardashevskiy wrote:
> > This issue with the RMP is no different, if you get a 2M IOPTE then
> > the HW should check the RMP and load in a 4K IOPTE to the IOTLB if
> > that is what the RMP requires.
> > That the HW doesn't do that means you have all these difficult
> > problems.
> 
> Got it. Interestingly the HW actually does that, almost. Say, for
> >=2MB IO pages it checks if RMP==2MB and puts a 2MB IO TLB entry if
> RMP==2MB, and for 4KB..1MB IO pages - a 4K IO TLB entry and RMP==4K
> check. But it does not cross the 2MB boundary in RMP. Uff :-/

Not sure I understand this limitation, how does any aligned size cross
a 2MB boundary?

Sounds like it was thought about, is it a HW bug some cases don't
work?

> on the other hand, without swiotlb, dma_map() in the guest for
> untrusted device is likely to be lot less than 2MB and going to
> share another handful of pages but this activity is not that rare
> compared to my certificates example. If only there was a way to
> somehow bundle such allocations/mappings... :-/

ARM is pushing a thing where encrypt/decrypt has to work on certain aligned
granual sizes > PAGE_SIZE, you could use that mechanism to select a 2M
size for AMD too and avoid this.

> > That's a completely grotesque solution!
> > 
> > It violates all of our software layers. The IOMMU and RMP are not
> > controled by the same software entity and you propose to have a FW
> > call that edits *both* together somehow? How is that even going to
> > work safely?
> > 
> > Can't you do things in a sequence?
> > 
> > Change the iommu from 2M to 4K, flush, then change the RMP from 2M to
> > 4K?
> 
> Sure we could unless there is ongoing DMA between "flush" and "then
> change" and then DMA will fail because of mismatching page sizes
> (that 2MB crossing thing above).

I'm confused, if the IOMMU has 4K and the RMP has 2M it doesn't work?
Then why was I told the 4k page size kernel parameter fixes
everything?

What happens if the guest puts 4K pages into it's AMDv2 table and RMP
is 2M?

> > > If I get it right, for other platforms, the entire IOMMU table is
> > > going to live in a secure space so there will be similar FW calls so
> > > it is not that different.
> > 
> > At least ARM the iommu S2 table is in secure memory and the secure FW
> > keeps it 1:1 with the KVM S2 table. So edits to the KVM automatically
> > make matching edits to the IOMMU. Only one software layer is
> > responsible for things.
?
> Does KVM talk to the host IOMMU code for that (and then the IOMMU code calls the secure world)?
> Or KVM goes straight to that secure world?

Straight to the secure world, there is no host IOMMU driver for the
secure IOMMU.

> Is the host IOMMU code aware of the content of the secure IOMMU table?

No, it isn't even aware it exist.
 
> Does 2MB->4K smashing exist on ARM at all?

Every arch has cases where larger mappings need to be reduced to
smaller ones, but ARM doesn't require synchronized coordination
between multiple tables.

Jason
