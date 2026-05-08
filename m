Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011030.outbound.protection.outlook.com [52.101.57.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D503630B7;
	Fri,  8 May 2026 23:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778283398; cv=fail; b=cO/VzvyQWFp/Xtm/jf+qvKjDmv0w0zZyd6twJM445BHz2erPQ7JfL+chRMIBh1doArMQnIMKFdt5t/dOHe4wgY56fEyRlXU4kQF8y5qSBnkniPCSr9qzPmb0MDUXhyexj16rnhUzTFv6DMq0P3x6qrFjiU8cWFjH2pe0/BlvY0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778283398; c=relaxed/simple;
	bh=Ptxx5YH25T56pHhO55sPWtlzcjN5lc57o3BdK7Dcwjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o7NK7C/sCPdgvPo9t0uNFMT4KWoY3zf/BZNE3GXpYNhXPvLTG2hC3z4N+lwhYu6XvYhvDAlZVMntv6fUeaEwXkQTieEy9ruuzseXgV+Gm/lelpCceIFWK/xPb7FcQBt2fUsZx8XZ1xxNz7pisGrfgypzMfYm08UaevQlZraxUTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uikDvi5x; arc=fail smtp.client-ip=52.101.57.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uikDvi5x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+mdTrNaOXrzW3j6dcouwiaYLTNqiqbwPSWkcRgcKavxSULrMqPfOrWy9Kt83HoKl7qZdn+fDNy/ooy08I69MonBrl58bbVvo3VCaBQnCdyVYIMavZHi6eW2sPTNvRX1ogzAeAWeeBwgBU1wpMRyDIzkC0PfN/Y+t5ETEpF3dA3ytz8J43nn7sgKOOucYeZ3cPYSRcNEbXn9WoqhZUdH+6f9kQgzWPkuA3XSs+DtkFvn/BSKPGL8+sdsgiyBmDAzlpsCGzew6aaKupL1vthz9+KvSEnVM01HPMdsDt/53HySrKpUhh+mvaQhlZ1BP4rUBHdVOQdpf0ODlG5K6Pdh3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4FmgNUHzvHjavHMv9IGSfUd+TDYHDwTNYC7b15IgLk=;
 b=QylyNNHeAunLKO0IXHBlX+F2Qz+jkdbTZyVuPorinnKJ/2DAP8+bTXe/iw9dqRQLZ8GOgCyIkwPpf+m3ApOEwE80p7r5hkxT3+1afnQi5BMW9AMS5sP/gWmk3pVusnxZV/0WYNXjNB0dDIL2PQAeYHEnthC+RAuyY2FE66Gd8EFiGWfEBjTp/FETAcZ2VDKUc6eA4/aHFnTPDD34OCtOXg4P9JRySWhXO2W52/ZZ4vFk4BSOL8OLqCNip6N+TK9IqwwShwg2ryDyRMrnvOaDcmih/FY03oM3XHSg4WvauYoyaxYjj66ehHuVCoF588vkkAyOyYERKSLzN77FkJejUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4FmgNUHzvHjavHMv9IGSfUd+TDYHDwTNYC7b15IgLk=;
 b=uikDvi5xHxFZScwRMZER4Z6uSuZ7gXRnbYjUPCogGCNjXOXqtllo4McgrvLTmwF0kpHuGF4pBdFL1U6z8q69jzJqpJ4PVl6POLNeKcAMlDF/2PRsFJbvTslyXAXsPzQJCILrIch4XEkE8m7jqT17y2AFiUD6T9jQhzd7nm4FlC81YTdMYdh2cr5VZ6Y7/MUa6HgPJISiwYzpLhQXw2f6UDe2SKe+xdRv3gUwzjDVssOJqOGoGgHvgXCQ1oQ93pFGx8EGKh7PtTcQAppO+AhLJtjZBNmOgDPNxZ30TG3YKLJPNRiJFUpZnIx6VsXBzRPbi8BMHCQOh1RHRX5GLvzTGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Fri, 8 May
 2026 23:36:30 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 23:36:30 +0000
Date: Fri, 8 May 2026 20:36:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 6/9] iommu/arm-smmu-v3: Directly encode simple commands
Message-ID: <20260508233629.GI9254@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <6-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af3KDBt8vhClSKEF@google.com>
 <20260508173736.GH9254@nvidia.com>
 <af5C_ax1a3LbtL1Q@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af5C_ax1a3LbtL1Q@google.com>
X-ClientProxiedBy: MN0P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 07663a37-f064-4ec6-769f-08dead5aa187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	EQl9O5mpbMzLX37dtle+DFxWL9m/Bf1T4jKKq9NsbTUo2L/B641gMT1la3MDC9akkn05N2tTaboKyO4LBVFyEmNUBsSjiZ+m7RGHz+tnThMEWyA0p3v0afNANNe8eYZdOqkKFIxO/3QxTC3g1guighOZywVe+uU3bvG3hBYQ3fcy0aMcNaBRwl+H0LGjSRe1Jo5nFKUg+HpZzenO2uYvbpvfAjIYthwSCjdZAzAqywWV8aMF5MwTOeqUZd8JzFAuG0hjj+zXtQZiiImPrQT1pofZtysFpk5hxsHA4CLfTxKFZHzoGNufIXXhU1OxODvLtZGXlF4Etrvgs80958U8YHAuloNbGWuSRLSeYg4psY4m9VLT2CTsCwWtf1lwyLGXturc4LFDLuBV1TWZcAHGtfm4W0zrdnDgXIHkkzlpgrDtdhoHRPbgwbDuuOk9pwOaejS0Z+tJkZ3ER3DVqMwAX52ckuIgksv2u1dHXngcWAJTeO/qZ3Qu0k1kKFE6AmPrtAa/9vgGVJ9K7lnA4Q3wd+QB2LBs6mz2D0f1IlBYoPquDyWPnuRfqM3lD18Cf8atsIgWMHl8zqy7QF5g4oWIHZGbsCMGTiqNKnqh5tfCwvk1nr2j+HEYD7rdnQ3+wLJ3XzwtwtKQNp5XZtj92LnPdf8ltCajc1G3IYkR4x9aQLdeEXIac6943VKxXCFMDqg/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?juQahdxJuXA1JXbbG3P+jbsUg/qyrp4Q5MlwNbE/SKiOtxr6DRCTD+RzqH5D?=
 =?us-ascii?Q?N7jA6A8rVQk74u7nahs9UZijJjfu9RD/aCZLmZSgwepf7apQrWviTBefVaLp?=
 =?us-ascii?Q?LVLCoYJdZKHQqfPdCxb+U9A+HY3VpqhLOMxKsZ6J+WiDPGfdHAjArlIchWkK?=
 =?us-ascii?Q?mtygCtMOhmbJ1v5e2MSm2w3ask+llZLwLu9fVqOg+RPEHXIKx94eF/q14r/0?=
 =?us-ascii?Q?DopK8YqBoM1OVRHdwwmddFD/Xsc0aoD4MGSB56FbdNlmNAYr0jT5wEHXvNdF?=
 =?us-ascii?Q?msaKVAbR3M+CsZ3LWqx59hlZcVlyhD1dsVS5KeGOvolPOxBUVMPkmJVvA2by?=
 =?us-ascii?Q?BmUdheKUAm/0jW67PV1diWZTQ/povpNv9z5BKUl/OATW0BLlu/lw19xluNyC?=
 =?us-ascii?Q?soYkbAEcB+c3rFUq2zEjpUKy1Lvq06YNYLiKp1PFM52hBCXCV7vFZRLGjemr?=
 =?us-ascii?Q?NrqKxJZgX4ulYlcTc0jKLtct3HYXqkRP+qk2SJj7x15ogIgZeEwv9+KcYjVc?=
 =?us-ascii?Q?w4yNB9F1ey+RYaUS/E+LTI4o7ZQo0aOAEXorEDl2faYvmHBg5Yd/Vt+P8+4L?=
 =?us-ascii?Q?64uVnZpSGCGb699Ve17+dRBjr+2bQQm3wkoEjUBbxO04/FLFqCpDe6Q9i1QM?=
 =?us-ascii?Q?UAYqGHzc5RnIfR08RGLE+Nza9HiEYUQpN6aUHGAms5e+2C9Asi0dxbiG4kAw?=
 =?us-ascii?Q?TtcOyYOUYPWo4704tHzBKNiN3ODGQFEibrKFAm3Xq8nXfhcAaOG0NW2y5xUK?=
 =?us-ascii?Q?1IPIUd5St80ZpQzsdJLmadmenGFi3fRuXFIMyuzjA1bQVqCyGFjxvFevZRnn?=
 =?us-ascii?Q?lIjTd9pDtSyrX9yj0CESZse6JwJJPLFU0TbiSc1SJ9/Is1jPtebMM/9jGS10?=
 =?us-ascii?Q?CRM8HkYvkY9TBjZRF10gx7wQ7/kcWON6Dx/0npBNzna47L19DvVlL55zPZj1?=
 =?us-ascii?Q?2EBj07wYD+9veHq6MGNW5eeqRQpfSDy0tAXPuuUnLxsOh0sNApZKvE3n7roO?=
 =?us-ascii?Q?ybYfR63FVguMfoi73aQAoJZ3xFhfDEPYL3l6ZCsMEWYtcMmBmnInCU3RrcDe?=
 =?us-ascii?Q?o2PCDPxB5QcTNKRqqQX/kkIlduGq9r9/md4TNSvfs93hDbzUhKZ48G3BF7pV?=
 =?us-ascii?Q?96D0nGPQFkyEpWo87gNF9jZthovYeYRapAqZqEyezjOEIYYtnLFWuFFv3tsz?=
 =?us-ascii?Q?9PmEgKYg34b9uS0ZYAKQNzjIr5fNBdSAa0jf6xihqXUirao8egz0WyR5RiyH?=
 =?us-ascii?Q?Ti/aOjXEPeCqDgqf1F9+45vwYJDlpWiw9d5OXHAj1O19OprfT2PFi52PRI/P?=
 =?us-ascii?Q?7TqGvJqJ8iLA7y64AjBGWhZEGI1sVOJs0RkEITzWeB/ihubK1LMyaUcm7g+C?=
 =?us-ascii?Q?Rj/vbpR+rF0MQuVOACWtFDtBjFAkpiiZw2rPWSdmdimxfh+GTZ6QSsGX5pjn?=
 =?us-ascii?Q?XQV3gO7PRW2MXAv88TZFZO3nAsrk3atrLgrrd77OaoWEPJOYfHQGxUICvZwz?=
 =?us-ascii?Q?2wkWevfLb173uT5ufPBZJhe6HjUWKiutHdr+ATHrLcvY/83ikdlinvhMTuFi?=
 =?us-ascii?Q?RiRLCHDAGlsBchP/81BPYeykCRJz6MAenBp+h+N+DcXp6mW9w9rfTwbHmBIx?=
 =?us-ascii?Q?Ei9s0EEA4TrVXZhuueyH6FM/CmtsCVDEgto0bo4uZjFvZ+py87Ejcsg/xtqV?=
 =?us-ascii?Q?X3aUFUxlRyxkefxLVuk6tfqEd6qZO3FipEyjeRZOTs02tkiU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07663a37-f064-4ec6-769f-08dead5aa187
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 23:36:30.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAEY4N+yI5rPcA+IriKKiTanWz26qQS4ttqcIPhxAJSE6vP/E8N/1cWCiP1QxHtV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622

On Fri, May 08, 2026 at 08:09:33PM +0000, Pranjal Shrivastava wrote:
> > > > +static void arm_smmu_cmdq_batch_add_cmd_p(struct arm_smmu_device *smmu,
> > > > +					  struct arm_smmu_cmdq_batch *cmds,
> > > > +					  struct arm_smmu_cmd *cmd)
> > > 
> > > Nit: Same here, why not  __arm_smmu_cmdq_batch_add_cmd? I understand
> > > that _p just means we'll aceept ptr.. but the name's kinda wonky.
> > 
> > Which becomes a fairly widly used public entry point, so I didn't want
> > to have the __
> > 
> > Though there is no external user of arm_smmu_cmdq_issue_cmd_p()
> > 
> 
> It's just that we're calling "arm_smmu_cmdq_batch_add_cmd_p" at one
> place and using `arm_smmu_make_cmd_<cmd_name>` at the other. It makes
> one think what's "_p" in issue_cmd, only to realize "_p: pointer variant
> 
> I guess I didn't like the new _p ones but I guess it's fine. Happy to
> leave it at your discretion.

I don't much care for the _p (and yes it means pointer variation) but
do like it better than __ and failed to come up with another idea :)

Thanks,
Jason
