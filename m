Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90BB28C03A;
	Mon, 30 Jun 2025 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295864; cv=fail; b=OM5TnpPL2FtQ/QDW/wPs4faPATi/Q7mltngx4XajbyNTnK2onixi3Ad8pYSvRs2hboLR+zhbiupyDvPx9weeVvqZFNPugZ0JQD0EuELG48Onoz2TBav4qNG6/qtVQ/3NoAVidO4jDI5zOj0Q8j4LklGWK8WCpgojCkqExjfLmbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295864; c=relaxed/simple;
	bh=+I7k/+7kaNe4x4YkY2VIhoEKpYCneCG1gIn1Qul5q/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u+4Ay+FYj5WXDiIaOvLSJL02LCu44kt3tcW0FplAftJFpKbig3dGI1j+T/PAxsJ5YLXphoObiovJ5IYEkByPqeCrnlpppcFGNWO+VBnPCd2HzjUB2DyQd2Dz0GvXigfqgap3rIhtS2rVhdkRV0NNacDIHLm80dx45GOHdCgrS/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JFQjw6eQ; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JFQjw6eQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLTpBa2kQEU6D5EGQ/8HVx8WhRqSa+d+PdfNl1HXjvV9s28KmX3AIZnJkfmbunEqM5odW/13Izh6GEx/HxEwAeJfaN8ER+7fJV8Y0USMeITMMXUuBlTaaR+ChQFjofN2Sh6nBQQKRFwH55Jx1y0RdHOVYhCB4wfRgResmy3ICl9duX5HfZA0rRw9bkGnvjt19adglihH7nPraTyORSyFUn8JR1y7YnLHQ2Ib7jAeHmL8quRLXZaMgMeKtXyF3B09vZy8772K1jl7Ksi6CH9/752fgQ6lp8QLOshEhPAvHQtYrADZORTVJGfqFIBbS81qO1BUthD3WNCwg6CGzfYOaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UO6L0SY3CuAgTp4HI8wo3fAY7wU6PLCoScJ1mh5+Jhc=;
 b=Q/M0+m2nSoPT4tXjGRtn3uDTkJyCL9XWSmRQWctYpYKMw/1bdlDFWXArmfHFpW+oi/zFGtEQZtuvgPGH4iaiW9g512KThn8VGR61dhlrukj5nUIsBz6HI8ILJkEtikSNBXLzw+UG5ZBToLj/SBtnyDr4d37z5RfwD0K05j40kUf4JHFYiaLPYAwAux/E4Zn4dabobTYVOQap31ADtVROTjBU0UEQsnSpjhx4VJtRkZfRof7zocNp4dVSXsx2o4owLHAXXb1jC6YVZzWtSqN4IUkyBH9g4oD0bzp8N9WShoQwcLQ1CT/Nn3Ss7OfLeF/49dDwnLVI1dPOhT6i4En3fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UO6L0SY3CuAgTp4HI8wo3fAY7wU6PLCoScJ1mh5+Jhc=;
 b=JFQjw6eQsFRff0IV8ZN45UXohZwqiYYVqYfaX9G0/o9JbHUCaW7rKUA82rx3gazuSwSgu4MQdATF6c68j1wxJ8l52ghRA9vqD+qlTfrpK2WZer36cMrc+2gtXUgLSMddMwOZdClvQJtvoYU4SvcbS2ihgFjdH2YzPKoNlA//TFcYvQEbwMMSRhfvoiTvIIZ8890gMGN14asllWFpiLh6EQGTL5/k6BBboieSPpFuA0VJ2SzkNMMj4c4PlMNyIEb41gHqqSzca6rv8ecscYieL/q+Vet4BO1jO8uLOqSsn3fkocG/E7Lk+z8qEJ0ZfD9zVeSInrKhqvd6OScBVF1Y/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9127.namprd12.prod.outlook.com (2603:10b6:510:2f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:15 +0000
Date: Mon, 30 Jun 2025 12:04:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 6/7] iommu/vt-d: Split
 intel_iommu_enforce_cache_coherency()
Message-ID: <20250630150412.GZ167785@nvidia.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <6-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <BN9PR11MB52763C1B4AED06073FAF79EE8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250613131253.GA1163305@nvidia.com>
 <46253700-8b98-47e1-bde5-1bd2fd9f528b@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46253700-8b98-47e1-bde5-1bd2fd9f528b@linux.intel.com>
X-ClientProxiedBy: SJ0PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9127:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9fb2f9-080c-4ebe-0c06-08ddb7e760fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tgF4TYEylestq+VTvbE3kdw0ChVSee/f7AEIihChuXDPUUnJm8XBSRtDlDMj?=
 =?us-ascii?Q?nSO2Ql2WDfdGmpybVBSmgHxMr7/ai9Pl0ZSpgi/9TST9t+SAoyTGZxtWV1hG?=
 =?us-ascii?Q?C51qP2Tumt20AKlJKuqY8SXqtW7ynjzWW3a/Swp3ulqAzl08LFcyZWDu/T3d?=
 =?us-ascii?Q?NDNyYwLHKw7lCKdqh7rfG4+RDVV35BTBbUbIViMx3rNrIAnpOx0NxZ/6717H?=
 =?us-ascii?Q?Q3fnxfHK2ido5vckzTfS1KOQkp/h4/BgHICmOxSJGnJvQ9s4yvB1GoFJzsvL?=
 =?us-ascii?Q?Pb/58ECUsqcxpktUaIbkirlRRhgC4gU7laEwLJt+MoPrRG4kLRaj+1lXxcYy?=
 =?us-ascii?Q?Sd3V3qcucoCdiUiYwdEP5ed8TJjl0+EFo64481QakyrVKIU5RG/nGc27de7E?=
 =?us-ascii?Q?B/VM2WCRey+J3kiWJGioL7y6e2v2hFhKix37m2RyC7RyIs0CbwbY6kX1+Kp5?=
 =?us-ascii?Q?MGB9vDL+kyDjCkJ4E3iCO6K8pHIwNGoNcb/nznQoczCbLl6Eiydg08NGRS3I?=
 =?us-ascii?Q?b/26+SFAOewvyk1/zVsJNIVX5oPEB0ND9bbFPWjNAXNvaYPcE1FpuQe1h6EH?=
 =?us-ascii?Q?zXAwIpwBQEAha7y70kT1JY20y08jYnm8++cBrHnXKHstno+aoKINce0rOdPN?=
 =?us-ascii?Q?ABzu3c51LW4FMTbGU2ZV9XnG50u5lKFZyV4YRmIu82AZWMXfqGxfihdM0C0Z?=
 =?us-ascii?Q?42ZO+5XVtlVAMvdUj4vPKjHdkdxXRwCi/1QLiFvmtU2zTYrZdhIv4/eG3uDF?=
 =?us-ascii?Q?Lpr1Q5jmnKvhkp19qUqS8TwrfZEKi8hCDtgXAf3Hud8m54pmNjFpD9l19G42?=
 =?us-ascii?Q?gUGBkSF4kpcNV3DJmRK0DmBoHFC6io0PK0j7XV/K7/yJvgeRTGnDKWFS20UV?=
 =?us-ascii?Q?y24kiAvJqdjROXhWySRObzoT41dby9mUEBw8upTrQ5yFiPd81JwuJlb1R829?=
 =?us-ascii?Q?LHylrQWmDdZu/AJhVJIRL6R0x2TEc0Cf/p7zY/Etn6XWb3139vniiU8pSbfU?=
 =?us-ascii?Q?AA97kw4HyzfKVh87fqUg2pR7GxddbjtQ0YyE6SRe3sFzugOcr1aqdLLeZjO2?=
 =?us-ascii?Q?EoifICM07TTLjUR492KPpKwOJJ9bgaz4jldub1Y+HcxB+UW7wgNy1X7xqwed?=
 =?us-ascii?Q?HEqlQ0sSeSTBNxZB7Hpbl5erlU1CGj0CsrCtW9JNx294JwR1QLm1xLyubGUg?=
 =?us-ascii?Q?pQnFZ8CSpsgdMwNqshlAwiGGJseGvfrw8ypku4NWKnK6h9BBpsluruXgEA2w?=
 =?us-ascii?Q?LvELfFYwr7HBTXGBqwRyzsowZ3E3SDRAsgXisB80UmvnC9CalsbM4kr992FF?=
 =?us-ascii?Q?/JUWEWx5AUNOGAOLrytscSwECti86YWTIEVXwUk/WJNk4YpEqMx1F7djeh9c?=
 =?us-ascii?Q?ARvi14LD1HjZVJKt29QJrSlAHDyDVHVfj4e5ndlFoCOEWZtoRf/DsmiLUtEm?=
 =?us-ascii?Q?1Px5YtrDE5M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S9wYKRgomHY5qm1idUZjaHkvh8LPxMX1O+662XKcyzQ8GUGwWrx5rumZBLTg?=
 =?us-ascii?Q?R8ZzjVjkkbknCY4OaYSqDdVQEO9vCPJDG+Yc+g7MHBVo1eSXQkhQ7Kjvt8Jz?=
 =?us-ascii?Q?li/E1cuWrDXhGg+Krp9bWgvrYllFhEUogNDzP6hkHs//QmKlJH8UwBX/ZgZR?=
 =?us-ascii?Q?prF7ECAYq92VxeC62rQMDbCa5fE/VMjE+9MXTjoTTuAxrazCX+2ceTc1rakK?=
 =?us-ascii?Q?z4hap7sKeiCNA+HQMFp4ibV0KGFmxUa5MnS/S9O+Zc7NIseQnh9twn19nP96?=
 =?us-ascii?Q?Ahqs4ZaegC0GcygxePk8Paka9Omg8mZEp6HiHKILs9H3Lj/zKSWqUxJO3Vck?=
 =?us-ascii?Q?YvEOfNgD/S9ctMKhUJH8PeDKEOIZIdwSh6viq64QUpjA0wPM56Mw14Ckz6pJ?=
 =?us-ascii?Q?coppNhmlNHobN6rxrnP6DNLfP4UfrAo5Q92F6Mmph7F0WmA2kT/hxRCPkycT?=
 =?us-ascii?Q?nyRvKYONs4nKriIhAS3g7fu0TcCOoza7t6Ngx26OMkIjNNCBC+3dQBNQfLNe?=
 =?us-ascii?Q?QKYgA8IAAuGI6LwZPLZMRBDQG6pGwGk8emjqPr25QxD5Gvxu9gLQcFpIkP9g?=
 =?us-ascii?Q?K8Ck0JyVmCE8xFOVY5AjBhBA3EZBieAjYaV/6NhdTsmghFdRtgjYQHyNOpmI?=
 =?us-ascii?Q?ahS0pU/MV1H4zK5a6T4O3tH6U6Sl/n9f7IIpYtTxQl6rfLOy88QRP5XE4QKP?=
 =?us-ascii?Q?JkBtIcHnXF489NEwswN5ePHA2dk1rOe794F9rTnkC8dBdLbhN04pS4hEKbQI?=
 =?us-ascii?Q?ubiq+Qg/VTngd4JYWATGd1KaUHJ8vkmFrs5nV2iOdjQYhcqZnxIfk4TRdNOA?=
 =?us-ascii?Q?jQBSs+fEjagWNks1F/s0k9rS8xUGI+hk6TnRk57NzcEOLr5gY0wBlYUa1eqg?=
 =?us-ascii?Q?4uTIBeLp4nTGOevkDv/Rt7tEwzNU57/hM4JgmM7t1IgnckKBjg1paxASLmot?=
 =?us-ascii?Q?/NIKEurmUu+szP4rbrq5VdDhwrdVAWD3QPWdt6iXAB7rtfQUS4dCVlNPhWyD?=
 =?us-ascii?Q?2ZGbDAlC1fdiU/S3yvjgqaPT5sQJEC4R7gr4z5LVAo7fcy2YRCEoYTk03d3R?=
 =?us-ascii?Q?HnLhUmwodTuT75Q69AcUva51Uq/srhyJNikrUeYEEgrWO4jj4SU3HHPjUvme?=
 =?us-ascii?Q?YR3bhhwWTfck48o+g9ep/CANdmb3ROxiGjpGCgZ9slz8cBq3IhFwQ4IDvS9o?=
 =?us-ascii?Q?mo1aYHSSHnbkK1I799pIuiysG8EfaHtJTNKGWIFMxDycUGPhn8mK7E2ltqG6?=
 =?us-ascii?Q?QkMySN8fHeXFAEwftukVqrzSRrNaq1ksOOyUaeXxuCRnJY/MjQh5ncQqdLAe?=
 =?us-ascii?Q?oUecD2/UWMHQgsyhNs5Z7d839xF9FKXdsZdy152tYyxNK9W4wfwdfUGpFw1Y?=
 =?us-ascii?Q?vCT3V+XylcLyeMDDGYmkIeTWCrNk8CGDHIanqN43GZmbdqBNl31xSXbeSElT?=
 =?us-ascii?Q?dmgCWpidYg4s1/iUN1asbr+/2JeZBlaEyfz7vfkYVjrds8aunNYR/9CYiyyR?=
 =?us-ascii?Q?Ybn/u+NnvYcehIdVb/XEWLOfa/7e3In1T8z/7qrpYm4LIkymc042OIRIzzVp?=
 =?us-ascii?Q?d40HbImhbcLQWSj4CGvQl9dRDyynoBx5I0UPkDnO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9fb2f9-080c-4ebe-0c06-08ddb7e760fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:04:15.2607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ygf9scm5ajxyLGScNAhMV/Y+ITmM1Hn84hlW2Qc13u5sWgQP/wyhmtIPB9fhCWY0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9127

On Mon, Jun 30, 2025 at 02:11:09PM +0800, Baolu Lu wrote:
> On 6/13/25 21:12, Jason Gunthorpe wrote:
> > On Fri, Jun 13, 2025 at 09:56:44AM +0000, Tian, Kevin wrote:
> > > pasid_pte_config_nestd():
> > > 	if (s2_domain->force_snooping)
> > > 		pasid_set_pgsnp(pte);	
> > > 
> > > we either need set it for second level or also check set_pte_snp
> > > here.
> > Okay, I'm deleting set_pte_snp, so lets set force_snooping
> 
> Hi Jason, do you have a new version of this series? I'm planning to
> queue this for the next merge cycle.

Yes, sorry, I forgot to repost v3 with the little changes

Jason
