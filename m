Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011010.outbound.protection.outlook.com [40.93.194.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E6839341F;
	Fri, 16 Jan 2026 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768574491; cv=fail; b=E7yoQFWDNwH0V1YIf0NHUxFwWtyq8aD5r5sYyxtjkB41NDHNAjgHeij167k1YWlYhYwN4vFPXAIfRrFY76hkhhSx2I9vDSUg9j4rtKEWUdM/ehJDiV7XqP3NVMUj5xkuBImll8LA/SrxVtGfofq/7WWz/X4JeAfMGtorKeV3wpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768574491; c=relaxed/simple;
	bh=aSuTIsAEYU75nBw4bdUDmQGLkHLq7TwYbC9dv24wfdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eBm5EAF4oqoC2wLOj9TMKZjp8ve+7jy7L1qbtdvnMnoCPrvUVLGsNC0EYgGgeFKUKnrI4ntfmgsaThL4RKgEgSCVbo9lEkxofc7YFMZsin3sd8LdiBvyyCNgdPttJcizeDYAkyMMZgd3DaWMCmN8v1Ov2SEwwGcijIylB05jS5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t3b6n6BG; arc=fail smtp.client-ip=40.93.194.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t3b6n6BG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ci276JHGjyhvUvMv1oT9BTN1FoVaJkHqOybPAbkwqVzYLsmUujibV7uVqkgdKIpyx2OIhkv0wshmb48qJfbiATCiFSFC2Zto7gx/LiU83bjAJZIZJMVt2bx62+prn1Fgrs0Q8XIuUCc9toiL/BHl2Ovz5MF+qHuXdl4tkPvm/7x2MoAVG8Ii4fBowL7yXl/ccWFRGXdnHJOgni88pDnk/aEK8ehQkkkSeWZ0Hxkw41qgb/09MTD3gxDZabrPMHVO1HBBqHdKEA/21mIhPq+m/k8pSPBRKp8q+aaNxY4THP0bPZXEWSdhPpOCU5W0/B5ZXZD518JFh9XfKE+kujd3sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i1EmVs0VDy7m4uvQzFdTUDt+uVL+WPauNtm0VccnAg=;
 b=PHdOsWA5EvkuACY8cDKubYQCZSugbW0p48eaq6uLNysWKM8hgX8/y/cNgklnTAX9SLwthjrkTx3G9iF5IqgVEaFk5WexfiG0oKfPChKLwClJt7MQSHoBoTLkc98jz1GTrF/cWVeHTAyaSbgdpLPST7LfZvaXpWC4E9aWjn1PfrJTfvVWBflHnH9cWUektr119zxuP21Jy5b+XGy1q+x1Q4uPhjCUjF/VGyDhRoZuM2usTdAbM8CBZ5V4WEuAH9Oc9HtR//0VwwtdFym4G4u8EjVtV6FQ10nh5AemZXgWkdQOxqiviDdJtralod+nZH+ftxCuqFM+gTIF5FmFRIF4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i1EmVs0VDy7m4uvQzFdTUDt+uVL+WPauNtm0VccnAg=;
 b=t3b6n6BG3f4omayHgjf1TFT3IcYEuvwXLNq22QMujVBgzCceyv626gVskzU1968S0L+opl5pdL8L9030v+qBJI/WFemOuwVT0CZ/YJCaVmksMiqH7iPIY+i2Oyyw9VKMp8qgwMGGtHbno07hFCxC6vrXwYPWKkmlEkjFQfB4eJbhLgWd+AMtlu0hpxZ++fZ0GnBF6QkJt9Hv92FllgsQSDWp2hltiXOhQvRlAdZIZRUHma8NpYDCnqiKkwDS2+cvLDOLnBpqcuIsCVo6MsKCHeZl9vx6U/H5f6pAPtxrdy3B44u5BpvYLXYysddObR5S3nwi6p4SqrxpcOl5rVGK1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BN3PR12MB9596.namprd12.prod.outlook.com (2603:10b6:408:2cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 14:41:22 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 14:41:21 +0000
Date: Fri, 16 Jan 2026 10:41:20 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <20260116144120.GM961588@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
 <20260102155715.GC125162@nvidia.com>
 <aWnI3Ii3KCFmJV3/@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWnI3Ii3KCFmJV3/@Asurada-Nvidia>
X-ClientProxiedBy: BL1PR13CA0206.namprd13.prod.outlook.com
 (2603:10b6:208:2be::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BN3PR12MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: f09eeea2-7200-41af-5f94-08de550d50ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+/BoKFFkGofXTPRb7DKysD76rw0bDymg/N2DwrjjO5mbrUmOBNTwDoLbrVLv?=
 =?us-ascii?Q?FPaZVRTliCl+8ICRlKTdJ/0wv0uOe9bUv2ufvhVoW0IxCdb/o6Op0ACJwwCR?=
 =?us-ascii?Q?MGu53KcVX5XwuTKjc0IROTr6p6rdk1pp7PLvnAc83OtNPiqMDrT1tYk68MdN?=
 =?us-ascii?Q?PxlrROg/+7f1RBSROb/28rpGB6RcMB4gek3weVvd4Nhu+2OZxG4a2WpX1/sk?=
 =?us-ascii?Q?3ra6b9rSxbwYmq8ltSMPPH3VtMZXq51GvoqaJ7C8naArxUkHiBluXBYZTfHJ?=
 =?us-ascii?Q?N3qwpyiRcjSvdxXOkvGFRzjOPiBkx9QtEaXZEZAF2j/zJa8GPWeHNtxK2Ysl?=
 =?us-ascii?Q?ykNxAhty1CfhYqb0N9D/j99sAJLRa7v3fu/FY+qVVeXm+3EyLIIFmzu3Ojfb?=
 =?us-ascii?Q?OQNJfU/e7kEndXRQdhf7dKYSX50vUCN1q4riAjIKpF6QEoWPjOk832BBWJcg?=
 =?us-ascii?Q?EYkqvnsy/DrC4kxZBF7iXMIhSruPG3CV273WJr6dbSACOdG4eLejXZhBrfQY?=
 =?us-ascii?Q?EGFubHDipizqSHWZLDe9gJD88T8yWnulHTtNWiff9A9rucT2ehGRdRIMRfb5?=
 =?us-ascii?Q?MBe/neAQFLXtqeAR7V4Bwlw4GXm3zEWNtsccuTDHESCOSfXjq4HfNHaUtyMf?=
 =?us-ascii?Q?PA5O3As4B+UOd2MJyIoiSi/wUzafNZiHTfHBlGoHjymKJlIl1I0RPPERyCHX?=
 =?us-ascii?Q?DydVXj568pCAMESZ3kyRFVStUNVfOrMho5CC9zpJNFcQT+kzi/QEa8hF+Wxu?=
 =?us-ascii?Q?h41tYEISefWm7dWFK7uuCXlH1i9sVnPnFkwaV0TcpYbXhYKAm8VZgAA+3Yu7?=
 =?us-ascii?Q?gOdgqEGi0eTYh4lSmuYaJa92x630Bvn1cgGGrOuUk7v6ZShrS6/H7ESjc8hH?=
 =?us-ascii?Q?XuY9x9udG1x+aq7EfCP5V+qaRZwjuPBNr1E3xpipBL1dTL63AK2JezQxHlv+?=
 =?us-ascii?Q?Mq0cv7+Tr7YGD7HWWM4oJCuJhuaVkJHOG4s67xJ9jgCD2zCFMW8XevFvGnB4?=
 =?us-ascii?Q?KvAkBY4D53spFKI5H0qEDVkuKsLdnU0wumtfuP4SvCFhrYbo8mFxdkwnL5h5?=
 =?us-ascii?Q?NWbm3np+CL4ka6P6V+M6XdWkj8h9aGMEFFsESiBNAMY23pFlUmcsfxhmWnI1?=
 =?us-ascii?Q?NzoQ5Qnd8twpdWL5muBYnuMvHjKa1wbz2AoILBwXwzM/0Rsz+T2mu8SXpRXL?=
 =?us-ascii?Q?KjMXn7HRmsAWRIZhkZ11kbpaQUESXp05+wQtfFK9JmKJQi+oBEHUwjzJJPoQ?=
 =?us-ascii?Q?Li6s/nKzJKjLbTqfm8AxVoaCEHOANhrhxQj7ktaewMypbS1N897h5Fqpz8UN?=
 =?us-ascii?Q?1OLVk87ufDPrhn6NDEdwfl1Ne54RcaTLqNJPv5wej3PVQ4RL3Y0icA1mLi4Y?=
 =?us-ascii?Q?Ix5wvBVP3ZRpNrnng/iSi1icsfTINwIfNidhT2T2w9Zptiiz8bscAMoaNBti?=
 =?us-ascii?Q?5x4gT7ISSS825mDQitJZ/RwaVdZoS66JraomikvfBemo9QPgS0V9wVnX8FVk?=
 =?us-ascii?Q?MTwxyWwsSaSwWchNXJ8nT7gZGBa8IP/czO+/IHACxdI2Yqmr8sanRPX4dxuv?=
 =?us-ascii?Q?1XEV+WgSg/gsMmrLLzw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A5w1ZB/eitOroPvxwwjMhDSsI7BNcuYGAN8nJPwW/b+KPTSlIAulNMGot6WS?=
 =?us-ascii?Q?ma8HOlwSCnnmbUJp++R5WFyhCIcJbiV7XANCpyQaNB1AHVRai5PC5qAW3CzB?=
 =?us-ascii?Q?ssC6yN5gcV/FBvwNhoDHS/eP2xn4ILH7C+VRKlWqjwm7cpsc3OoYttHy1/nR?=
 =?us-ascii?Q?R43b81yZp/isHeTOttL/bGOW+KbUG57i+NuZetkLrM4lLCOa+hqPeIdwU/KE?=
 =?us-ascii?Q?9aHXxagFJSfqNuHx79sYny8D1+Qs22+HZ5huCzHKEwq3RFSIloiskc/Iu2vs?=
 =?us-ascii?Q?YTMLU1DiucYLFyAGmjiddiWUfN/Qw/qM9ce8P2Khayg3LC0t2NdrGjwEdRWM?=
 =?us-ascii?Q?z+jUwwmgpsP7jCOiQ/Q5uzrZGWW/n5nVGGSj1TpWtHLXWV23shRFqfmnbEm+?=
 =?us-ascii?Q?NNqr8Bw3GyN6FtKRzDY8H/ctEW5ULeq5Kk0caG+S9vSfWHhmNhSXt5j9sQtP?=
 =?us-ascii?Q?2PS+aRGvVJsC7IbovGCqyW6ZJtvRpgKL6qgyJMnrsRyV7SRKOybX0CB0HpXy?=
 =?us-ascii?Q?PbGjXp9p2TOTqRVqMdzJr7ncljJc4zwKkMBWW0V9mQkh1+iSwEj/A7O4KZ6T?=
 =?us-ascii?Q?pPnf3gC1iUyZSlVG5r6I1ES8bXRRM3Q4zQUU0SP6OahzeNmtOjVmcfZuX0AP?=
 =?us-ascii?Q?oeQ4EP3eVBK/OoI/IGC9a1exGrMVMv1jFsImTFvRfVID7JPlQ1u3d3J/5e24?=
 =?us-ascii?Q?9bM4AoWyx0tF8BGj4AXsuxOSq+M3Z/bf7V87rvpwjGOy+i/7Tqmy/252INUc?=
 =?us-ascii?Q?2Xf7QEPxRAvR2SuIHKm5/WHFZXE94A9lje1qPuSLKDcqZmpbd4rwsMUAfFgu?=
 =?us-ascii?Q?gVqYdQu9CwTnnCd2m2w1v49fWmHV00Dam60DjQH3N+UK85QKn2ieZXTHn80B?=
 =?us-ascii?Q?bt1uermbKNZq0Sb99JdcaY5jvowQutn/Q0tHkFaJKDF4oWqRL2nqTxrDTafL?=
 =?us-ascii?Q?qwRZ/M+tbBsb1EkfVOykdzPAneK6JFw39Foe7LS7buU0NXqxn6dv7Trf+Hsn?=
 =?us-ascii?Q?JOKWPJ0SKvLPxug8A6X6K/drE/3vrx1Kj9mkIylZy899VUcVhKZWaCbGFD5J?=
 =?us-ascii?Q?XbryFM6me21mz+dKFPfXqHQDQx45n3xYSvo403aMQKObtuC2xsCxOlie8fUg?=
 =?us-ascii?Q?AckFNL1sciMSq1qAqy+OEKkRMTcrICfHJQqAViLMeqRnyNuuGdWnkU9sR/rv?=
 =?us-ascii?Q?ERvD9IVqmMbuJdq5mmA9bsYFxP+ek2fcc1Ru/8XtGHwzKIzTgrIIuh7CCI45?=
 =?us-ascii?Q?NXlvBXTkJvM+drne0CbeXgbDNsc6+ZYOLiQpDsKH6R7jaZ+xPj7oHZYCmAYs?=
 =?us-ascii?Q?eC9Bv6zPy6pyCqF9Ghit6vvtW5g7bivp3+NPqJwUsy8sovXr5/3n+26rH9Uy?=
 =?us-ascii?Q?Cy3wBCe+LGRqOTE1sn9rDdC/HG/JGJVJoD3O7St0/8sb4iYkFEw+0VrSWOOo?=
 =?us-ascii?Q?CR7Xz5zSwVDSE7VJ140kykFsxsh2HLQjrLsnf653f6PB3IFQKbv8XSWU1jNL?=
 =?us-ascii?Q?exy6lovb85jd1g+SHz5k3InkwTYQaj1FyQpD77taxXYZDI2gLtjs3+8rE627?=
 =?us-ascii?Q?CmI8eD6BkzymthLx0KF9SkNSh8a9I3B7ngYxcQSyvz7CZQi3Hq7V3AVsxMGw?=
 =?us-ascii?Q?eJ/A51sr614dHEDi23tEczGqDkKX4XJyzsj0MexJvwN8zDRYGUJ9q0K4r/Fe?=
 =?us-ascii?Q?mjUXeOluoAxH94G4uhWc3y2drnU0smk4K6skMct4rMQpqqorsTfF7vdp1T+1?=
 =?us-ascii?Q?pjgrSHsGJQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f09eeea2-7200-41af-5f94-08de550d50ca
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 14:41:21.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYw4q2svt3yVzePNJmfYJK+pOoGn+P6rRlNU2Sver6/Q0aAdME35oFu7p5BKhhj6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9596

On Thu, Jan 15, 2026 at 09:13:00PM -0800, Nicolin Chen wrote:
> On Fri, Jan 02, 2026 at 11:57:15AM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 30, 2025 at 10:52:53AM -0800, Nicolin Chen wrote:
> > > Hi Jason,
> > > 
> > > On Fri, Dec 19, 2025 at 01:05:51PM -0400, Jason Gunthorpe wrote:
> > > > +static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
> > > > +			    struct arm_smmu_master *master,
> > > > +			    struct arm_vsmmu *vsmmu,
> > > > +			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
> > > [...]
> > > > +	case ARM_SMMU_DOMAIN_S2:
> > > > +		if (smmu_domain->nest_parent) {
> > > > +			/* FIXME we can support attaching a nest_parent without
> > > > +			 * a vsmmu, but to do that we need to fix
> > > > +			 * arm_smmu_get_id_from_invs() to never return the vmid
> > > > +			 * of a vsmmu. Probably by making a
> > > > +			 * INV_TYPE_S2_VMID_VSMMU */
> > > > +			id = vsmmu->vmid;
> > > > +			return 0;
> > > > +		}
> > > 
> > > Would you mind elaborating why arm_smmu_get_id_from_invs() can't
> > > return vsmmu->vmid to share with a naked S2 STE?
> > 
> > A "naked" S2 domain doesn't have a pointer to the vsmmu, so it is
> > impossible to get vsmmu->vmid.
> 
> An S2 parent domain should be per VM. And a vSMMU on top of an S2
> should be per SMMU. So, it could have stored a list of vSMMUs and
> device attaching to a naked S2 could match its master->smmu with
> vSMMU->smmu in the list?

That would cause lifecycle problems if the vSMMU is destroyed
while the nake S2 is still attached and trying to use the vSMMU's
VMID.

Jason
