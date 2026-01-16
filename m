Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012034.outbound.protection.outlook.com [52.101.53.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E13090C6;
	Fri, 16 Jan 2026 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768583526; cv=fail; b=Iq1xY7iuVdc39K9G0cDyF1ln25OZKPLzdDx4x2FogdBauN7+LC7amzywildNLxpLO2qpGPuI96BxCHjLiXywcTyaamgbL42fLw6YIXbOC/9QtPS0H72roIXO/Bns732n8Aq4rpWW8C9LufANR9j5C8eNkB01cjgE8NQ17C6bVvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768583526; c=relaxed/simple;
	bh=0EfGKjJnCnEq7vgl2PxSPk0VwokNfjFzHsOpoFf21Vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PRiYVMM5KuugD1j8MNfx5lptGkXODUfzylqA70S9KQ7xisWO8mp/mJZKI49zSX63L/kmlnT0Nx7eQhc/IqeBmKev6b9czKDDmy+uK3EmuJa7QhF/tZXf3rioP9lNMLaPg2AN751FbFebiTfXwLHGAT9BchWkFPFaZfpj2Djhjlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j1EyANzQ; arc=fail smtp.client-ip=52.101.53.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j1EyANzQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PV6fqcpoM8u60PhaafXFI1kezFOY4IlPlhPkT+j56Z/AmNuUJmdibSoWN8+bQQVoA0X0Fxoy/iGJvryZ3U8rnpF8k8zN0xaPbx876MuqDERGKidKFuRGOFtwW3rqkAVBazlFVQTP43tuFCM0N1tpKI9r8tWcRoHkbbsU1PFswMHqeoZqv8CdA9gJNkDW784B5NPsAaqVYewmeaGftpDms1UEI69lGw11VSipDH0sRpw/3myL5j3GA3rhf3TAUN4Y+HVNx+OqgKYfJDqUBc1XcsBmu40YB2gUmpl1FySd2tbNBhRUjc433TxRC1Xs2iRUTB9B9mdolDIeBbL1gl36kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/xiAsxOao7omOsuc5CQ+rxkL1SUjDal6R0S0vPa5Zk=;
 b=rFtDi5LqvDPZm6GnXQ+XszA51XffuD9NZlguhEiy7Bj3bX43TRDHh6CM2FiP0+KjfGqH+p1T7PGOWvN3CaJ6G/gFooeKdnerclJsXcfrJsk2TS7YC5DVzhU8OKmAOPQCPn+YYKhmJEL5YNT78pDd8DV0fX72TVklqVVU2ZFJUFaVNg9M0VELnYEWkbN+QACd8/+v9eMdRFPrnv7U5IHaYkDCO05JQwhc9nW0T1keE2D3V3U4Hia/KrGQ/4kagQelUbko44+Y6mSVdVYJICVUlwi/ilVNmM0UASB3+JqpGOUSoxWXYzJCTA0pis7HHGlZGhxlguwQCMWCAFvjL2M0OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/xiAsxOao7omOsuc5CQ+rxkL1SUjDal6R0S0vPa5Zk=;
 b=j1EyANzQYPAfJQsau76XJd9I8LR7wXsIm4CH66OWgYgwEKG8frpB7N/pyqi3cgsej9vlVxpM+ex9nPeXEY2RQgjE9nagIbWSA3RVO3SyT4KtjfvOKsm6MJtkIlcrAQCXEt5L7V8FNbiLAq96eaxOWjdkXm4FLqz97LCUhfhRGuPxae5q0/sTAAbwhjzOV83awNlOwGvHZy63DTS81W5oFI73R2LeORICxZ1xNpG8/6AUeos+mxpPlKsBFuGi3TWV4GFtkTzEdSF5+JV9UriIPDxpA56R4Tbx/eqPdZuAaLDayFO9QtZvHTFk4+YQGKC2qespayddoYFRfT2Et/cCzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BN7PPF5D27497F1.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 17:12:00 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 17:11:59 +0000
Date: Fri, 16 Jan 2026 13:11:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <20260116171158.GQ961588@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
 <20260102155715.GC125162@nvidia.com>
 <aWnI3Ii3KCFmJV3/@Asurada-Nvidia>
 <20260116144120.GM961588@nvidia.com>
 <aWpuGsnyZJWTmgrf@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWpuGsnyZJWTmgrf@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:208:239::35) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BN7PPF5D27497F1:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b03491-a51c-4f9d-b3ff-08de55225ba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YyoCb9v4PqHszRoomiAkS9jatw1oe1YQqkBzW2Mo//V906AEE2BO47AaVQkr?=
 =?us-ascii?Q?wptD9JHi1JiUsarhfSB97Nhz9cr3WdNPDo7dF4zfd/w5MjC6XwVyqs7OqjkL?=
 =?us-ascii?Q?0qouxHzBxEpdWL2ExlUafvYshRNMR2qtv/yWtpu08AcjXAOvPVCbVknOwpGh?=
 =?us-ascii?Q?7UdcuTZTX5ASRwbkwPhsCMvNlHsIAk5FVSioIob4pQwveaTzVyb7hP3QoIA3?=
 =?us-ascii?Q?9MZZzLn21/nPiF8hJ+J57djJdP12RrrRI/JWYAOVtB+AoYRvUI2+MX4aqJAw?=
 =?us-ascii?Q?Kr/k5oPrNAvK7Ul7prXLOH3UkcaGdoPHfUytHjEhIsaixlBlXtzkGm3FplDr?=
 =?us-ascii?Q?cLmUb0fFtLkVqMj69ADfbLnizwCLtHhDcT4kljqrIUU/UkdEjBln/Ss8Lrrj?=
 =?us-ascii?Q?4k22fzB4+vCCw+VJMhTrMaeNRyuqBiPIfwd9pwBKEnFUqldODmjfMWBjPWUF?=
 =?us-ascii?Q?8nz0shbVjkXNUofhlj0HD1hG5ZyBhIgghPcg6zinqxI7NsexY/vKzZ30I8/L?=
 =?us-ascii?Q?ODRLl5DWV7YckBBG9Ao/OLLdi1cv4b1A6HC2EV/Sd99fhG3uR0tGnD9VEd3F?=
 =?us-ascii?Q?7NvtkZ0ARljqTyRcfQPEZuEzcqo/zX63nUqJlLhIDZuIzWACiaNmwzogCCoO?=
 =?us-ascii?Q?f298pMtmZpm6u+EqiBal8RLfWD8oLMrfAgLU3YZMUzcMfPEyMCuRTtigWkv9?=
 =?us-ascii?Q?dGAI20/x021vFlRq5wTUiMROZTleUSDDv/4lkFMm3dLmf9dnx0qc7yBdIoo4?=
 =?us-ascii?Q?PzDzSUsGFVtmyulMsSVu4uhjTmZqCD+LirvwvfrTApI2WFxNv48kL1lf29Pp?=
 =?us-ascii?Q?5aR1lwXlzXT/g/lqiuVWwPOuRvJzTdFcBlms0gI+SKsmphq8yRTaL0CZeEqt?=
 =?us-ascii?Q?Cf5c5ZA0MPWu3CKhlWq/IJM+U0oswdu/VAsK70cZ5pUPeGeM8z3qf5YgE6DK?=
 =?us-ascii?Q?m96xLaP3o/m9SecEi7HGXKq4+e6W3ecLcybtx9uBE6i1Ia6izPgiVEsCRqrT?=
 =?us-ascii?Q?QzmWveEzn4UEjfEJoys/KADipSdidYByvTNImSe+viuRX5y2FXT4iwLd8r72?=
 =?us-ascii?Q?69t9apZeTiPSbd/jBjRqEkb6LRZgnsN9k+5iHSfYt3ha/wqYJ8xPHBm+rcUY?=
 =?us-ascii?Q?sn7IH8KLQv7cdQiVd/qYBRA0aQMAbdZ9sZLfrrBkIwwMtyFVHkz9KoZLt9g+?=
 =?us-ascii?Q?GhhxZbd7kBSHPlyPpFjtzuBy5Ku/a7PeWPHiANs3KFlHaQwftjqnc0awyxqs?=
 =?us-ascii?Q?oXEe69m8G17gC8qQIyMK7MrvFPGPB1O9+qni0RZnz2wQD4kWML7oDGVS2wwC?=
 =?us-ascii?Q?PBDq1LTHbSLp6PiLm2eciQvJH2vmy3ZQr3uWGH+eGg2vbfls3qE1zUVOBedU?=
 =?us-ascii?Q?2qtcz6ReTuNaEizka9h8mPuTXP3mFEIVIl00CTYZZ/wv3TlM61XK7SVqmqq8?=
 =?us-ascii?Q?iYUMqyKn0/9NvC6xaxpkZgUUDJOtijDgl2W1B8t0o/jF2I+wsNzCrqu6LNNc?=
 =?us-ascii?Q?5Duekq1bTUqF+c0LRpGJcppdNuPcR9h31VoU9Vhpmelq4pmeoX7Pnj9VOf6y?=
 =?us-ascii?Q?Ktk5X7jhLERFbknAhHI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nSpL7p3wiCpKDA151mtp4CSsDbv7Vt51DDbDwTrdpQkn9yt0epG2cihV8KuX?=
 =?us-ascii?Q?/gsqwawe2SxQrxfSB43loHq7b5T/xXWeiDabx79af64zDv2TT6M+Qt7rDMvA?=
 =?us-ascii?Q?9GyZiVJGuI+mNnNc5o/vgE3R3ui+jM0npTD9Zl/wf8yYKHlvKxcyHQlCA7hb?=
 =?us-ascii?Q?GHxyi2dGBqm90hFae4edtbF4cbXAu/gGS/RQkeF4rHgnwQJFf2mT+80LxsOL?=
 =?us-ascii?Q?JXlO8TGmhJpduJJIzc7Z4Ka5bwqE6cEvZXwKv+tko8PDLhJdVrSr5EOP/R9S?=
 =?us-ascii?Q?skdcQVRwTZgDGRAVER3IBjntB1EE3gOjl3Hjp7Z9Dxn2dEpPptZ/pjLPeBnq?=
 =?us-ascii?Q?5eh+Glmz62F2IxBf4XehKj8nECLPbrNxegzcqo+QND1tRgJls7KSzyl9q/b+?=
 =?us-ascii?Q?kUV6yxkLrK06w2uRMfQq1/jb40VRnuyehUQIFQnRcOxvxmLJ0TOZsRsuoP+E?=
 =?us-ascii?Q?ATHqxLr8++j5aXRBYSWwJdpKIxAAS4AzyEzEtIUqfU8EHkXdOkv77hZ4o/M8?=
 =?us-ascii?Q?FBaseg3ALCvN46bBCvHXtKHQR/BEpsVska/avZI9iPwOmYxdvNRrxHq+S4q3?=
 =?us-ascii?Q?RzN2sIctJnx7n8AgjdMLhJN+kVsfU3s1dFRrixaVxqmmsad32HZ9+OkXd4zm?=
 =?us-ascii?Q?0xQPqGhCXXISo+aEDvPulqIKaB2I+KKOFuiKWXqfDtk3dT8To5rEvdGuToln?=
 =?us-ascii?Q?evgDLkdKK7tHkV29eDznyl4d6hZnyggAH6SXf0yiGYOrVPclkvxjqONz9gKo?=
 =?us-ascii?Q?Q1wlVGRWqFE7FY8wXLu76bHoyLdlc90tqDgvyTtOcUudTmgZvBa3HRwCtyH9?=
 =?us-ascii?Q?UcTGoa1YdKfClPpSqdPlimWv8K9uEhoDMAVB0EBC64Isdsx9b6hYO1CO4BM9?=
 =?us-ascii?Q?5bKCbxwm/wUpTdAGbQ8opF0iuXzSmOYaPMGBhdS/vUmgOt0BqCfZl4JCTC9k?=
 =?us-ascii?Q?AFGLuv9MI9GTwC6+gRwzgIT/gdSBCcO0K5WEs/vEwydEOo007qpx6wVj4ObD?=
 =?us-ascii?Q?izVylEuK/ud7Qkg2l+YKdsse10CitV+vGzaGSB/t4VbMTUa8nib+Z9drOjvM?=
 =?us-ascii?Q?DGmALZzMKy7qfySy45Ka9JrAmOyYIVi1L+RLLc0bS9PKZZ75/pbWK1Mogqj0?=
 =?us-ascii?Q?1hmTy7yl0btGz+Wy1UBgxJV2q7QiecMBp2M8d28udczZb0XxFpzPwMc2NfGb?=
 =?us-ascii?Q?BR6VAFUOnyaVl6WuTkPeg/E5w0g9L0obJwbISyTVLe13DYSxCVwFfTUoEbmB?=
 =?us-ascii?Q?Up6D6C5BKOfIVat2AaIlhK4CB34TBcAXLtT92SbDHLBONWSh2PqEOxBBgl75?=
 =?us-ascii?Q?4I6XYfYtvYsDzx8mvgb+OIyAjES1nengsiLtnlFHG0B33T9Hia92pjHMA7qR?=
 =?us-ascii?Q?2HESsNjSTznBphZ5b4CQk6lsbUfYkOyFN/ulPH8GAOy4muynqeeyczcLIVLK?=
 =?us-ascii?Q?HVEyeZp787z8i7QItExo1nxweCqsPH1K/EcAtld2yP2MIMGo4YVmyf+8rL19?=
 =?us-ascii?Q?hTpHyiU/0Xac2IbW1fPXCgpt6JSpclGDRElO3v3rEBJTAcPDQpS3p3Z8/XUU?=
 =?us-ascii?Q?Nw1giwutSAZRI5jvit87TjUi4cmiVdoqmYqa+Hej3Lst2oSsW3eYI8ko8OP6?=
 =?us-ascii?Q?hukiJEBbwzWxav3LLJBDQoJYPaKtWbKznCepRomHcLRJjhzzhCDZjgXVKc45?=
 =?us-ascii?Q?KyWSRYYXLM4Lj++iWBMGsQIsUbYRB8v61XBreWY1OjmOMMPaWBl3a1b5xfWs?=
 =?us-ascii?Q?JXql71LTdw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b03491-a51c-4f9d-b3ff-08de55225ba6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 17:11:58.9494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fn5zxL2CT5sryKCVgn4w8klWzf8ZYf+443l5D38roGR8BxlZlx6qm/qTR1PIa7D3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF5D27497F1

On Fri, Jan 16, 2026 at 08:58:02AM -0800, Nicolin Chen wrote:
> On Fri, Jan 16, 2026 at 10:41:20AM -0400, Jason Gunthorpe wrote:
> > On Thu, Jan 15, 2026 at 09:13:00PM -0800, Nicolin Chen wrote:
> > > On Fri, Jan 02, 2026 at 11:57:15AM -0400, Jason Gunthorpe wrote:
> > > > On Tue, Dec 30, 2025 at 10:52:53AM -0800, Nicolin Chen wrote:
> > > > > Hi Jason,
> > > > > 
> > > > > On Fri, Dec 19, 2025 at 01:05:51PM -0400, Jason Gunthorpe wrote:
> > > > > > +static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
> > > > > > +			    struct arm_smmu_master *master,
> > > > > > +			    struct arm_vsmmu *vsmmu,
> > > > > > +			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
> > > > > [...]
> > > > > > +	case ARM_SMMU_DOMAIN_S2:
> > > > > > +		if (smmu_domain->nest_parent) {
> > > > > > +			/* FIXME we can support attaching a nest_parent without
> > > > > > +			 * a vsmmu, but to do that we need to fix
> > > > > > +			 * arm_smmu_get_id_from_invs() to never return the vmid
> > > > > > +			 * of a vsmmu. Probably by making a
> > > > > > +			 * INV_TYPE_S2_VMID_VSMMU */
> > > > > > +			id = vsmmu->vmid;
> > > > > > +			return 0;
> > > > > > +		}
> > > > > 
> > > > > Would you mind elaborating why arm_smmu_get_id_from_invs() can't
> > > > > return vsmmu->vmid to share with a naked S2 STE?
> > > > 
> > > > A "naked" S2 domain doesn't have a pointer to the vsmmu, so it is
> > > > impossible to get vsmmu->vmid.
> > > 
> > > An S2 parent domain should be per VM. And a vSMMU on top of an S2
> > > should be per SMMU. So, it could have stored a list of vSMMUs and
> > > device attaching to a naked S2 could match its master->smmu with
> > > vSMMU->smmu in the list?
> > 
> > That would cause lifecycle problems if the vSMMU is destroyed
> > while the nake S2 is still attached and trying to use the vSMMU's
> > VMID.
> 
> Well, if vSMMU code does the same get-build-merge in vsmmu_init()
> and build-unref in vsmmu_destroy(), VMID is basically managed by
> the invalidation array. Yes, a naked S2 attachment would still use
> the shared VMID, but I think that's fine for a nesting parent?

The VMID has to be managed by the vsmmu itself, it would be a big
confusing mess any other way. There are multiple invalidation lists,
so you can't rely on that to refcount things.

Jason
