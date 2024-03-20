Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A7182C9B;
	Wed, 20 Mar 2024 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710959533; cv=fail; b=dLehnAZAXVSA8TWWoHSEclkJXX8YE0qK3UcmLpsQDFlqvTdIpS09Y1gI9zChcLZB3m0rR1apNxJJ3NOaruaA6n7NsF9S3XWB2PNE+uCuJrCKWpnZ01i4XvkZNhsr/I3koa7UcntoE2BdVw+C/rEm6+VqJalK0Y1UjuCzGhm7KUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710959533; c=relaxed/simple;
	bh=/aV1pBDnVDSZZTWwlazCpSeqnt0E0fBpc2YlBhs3hEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LlCtay9WRwJ4sULcHF5ZcrmJEC/iH45HMymQvwiFR2fRfuAGHzy28Tfp7cAJ2uvvRSyBc/60HGatFo3RrnJiBvbq3Qw0IxjlGjkQ4rFadMSCB1yC6AMfKsS6ge3yFnp6K8rI4sf9IBfz4AV0rZCXRWWuFXnnAWQgAvorkY4Z5DU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q8Lk1WDs; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q8Lk1WDs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvcXC4kvIoRRhokgwyHthw/GZGAf7HNuVgv/bod5eiYg30zzFfSDsXiMSumdTr6tkMXnyZnnp567xvF9/k0v7WUgKqsOlmhGZ/0T1uGJFu8MNPOaFAhSjhMyiluotDmgChJw/PomdO3ijo6b2DhnYuPoWtwLMOolLjnnqjytOEWjtPtqdYzwBQutNTWV0DdeMx8RgNjSPhRblNeM55kLKqW+9ASoEHmMKnH6V/lF//wUt6NBGEpzQTCbgwse8FbV5QjyUWHet896cEPIsz8k04aGdq0Umn4Q3YcbBat6tVxRMJ7Km0/Fo36RjFWZwPmwyxHYbx1joJXWnGlT6cDlBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JYOU3+flnTcd73Xm/B/QoaUIMiqmTIRfzdBRpIPAOM=;
 b=DsrPdrY952fWDl+JMSjdRo4qXXttAQ/yQtCrNnHNYUu0aKoNpnm73Nm3DW23kx54hhzLs99SnYUteWuOr59/WXo+JGnnqrPCiaTtLLKXrntW5laJCUb7MjSZkWOexV8o+FLHGb550xDOH3tgqvvnxa7Qx0mJHlqyTtSGvEjfDIF2KeOdNoERGZKxu8fz5ElrbljAh7fieTK6sXZmy0PLaA9Q1e7E/WVdu2RUwVv2NSivNa3PB36BtpLx+CU1GD9jhZ3sRvTbMgz9+3gfT8rO8v6j9UBMyaxjWyyslk5PGmNfofem/A528icNDQBBIQ/0lVn9nKzQp3gFsieIaX9LnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JYOU3+flnTcd73Xm/B/QoaUIMiqmTIRfzdBRpIPAOM=;
 b=Q8Lk1WDsMP96iUbEcyJ+nvcDqdAULeTFg2/4rsE1LOXEQdkhzxR0zEtP+/8AzV+PSTEUP66XvrqgOlo3E/7AyzUckVc9kk1rSYPR/ttKV6NSe9yNJS+oACWbKsvT/fDvgv718YuOK0q1QFCJ8DavHDN+78a9+N2+CMHu6sXnv9B17FtyBrzLGvR1vg5pWiY95MU8GyZHIegiWpcWCyALqOp7SkE/8Nr0/ZHPcdb+RUyvo3GeTbHk9FsaTLEYeaajHDn7yNvxbcO3FZVc4UYYmH2TSmva+majA8jmJcvTDKOpLBi7zCwOUMJpkpdv8o5P6OgA4/DQgjBpfWGenGuv2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ1PR12MB6027.namprd12.prod.outlook.com (2603:10b6:a03:48a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 18:32:06 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 18:32:05 +0000
Date: Wed, 20 Mar 2024 15:32:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 12/27] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <20240320183204.GG1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <12-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV24XKLf2Pw-CXQng0+ppMHp=3qr8vOWT=S=gTiY35kCF5Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV24XKLf2Pw-CXQng0+ppMHp=3qr8vOWT=S=gTiY35kCF5Q@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0241.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ1PR12MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: b8a86f9b-cde7-4ffa-5c7f-08dc490c0b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	y2HezsLz5sGlQkIJeduEExx71lfj0N8J+OC1lF9S6BvHtMJhcVbIZFArlMAi1rXSwPYfFrJepPUERaumwRJIXoEQnK9kKpwOJ5/N85/a4jF4RHy8k4yATQjTdtDOPPzOCM7oef7usNu6iLSp0N/z9q10lSOt6ucku6kEdqIy2EzSAu+GFyUAD8fjxw4BBDinTHEHmKqRrqtfD98wIFUaNgMbNxmdNkFns7pQ2vQSq3+fCUTPGkYuWKs+vF8atukWxAFVxj1CTR1vHmNGlumlQuxRVsDON4j3KPXrq3OVUGh8cjcIRQge2k07yjKz/7IVHXEXJTVy0mLa+11Me+7v438DlG7rUaVlWDbiJwy15EzQSoM35RiDAEwSAlrnIWaGqisvhZzRwj2E+Cju27oSUJ4XGIEXDeGAUeNdjkS44PK9g/5wkVVPS5ImqPrc3iFh6YvEunXcQ+eY+L5FWQFfOfPvIj0ZPvd5oeAQxiCX3UO+eTaNtMmHe76azJGAUjrW1NN6McQsUGbG4AfnMeQxEKtzs1sed/EnW/Y3HH9C63Mcl/WKf60SPNb3Ehckgug7rVhzYEMRKa62kBnuLvTNDEvMwZQA52OwgA5b04BuSfdmwJRW4dPdmLdLU3Z5WnOR4JgP6BVwBuNvJZ0vH4geDIIaylUMVK5bUm/bsAUYYlY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rfErmkp3DkocGEG9+FKgzt4NOXTIap4jzFnRphiw3r8EbX1fywhPM6uuXCuN?=
 =?us-ascii?Q?dDLKBB2danEO3M6Az8bJP8MdZ9ENDX1bc/vqvDE7ITSZKnKOXr+yZtOKVDUZ?=
 =?us-ascii?Q?p1VsmcoQN+yRh2/3gLCN4kEMdbhbhUhY0TlU8rYEPdxzF6dfeq2RmHR7QLfW?=
 =?us-ascii?Q?FznmelOUva9k6Ii6dtfQ6fPXT/w0oukuEG3t/Ww46Sg33HiyKx4Q0P6xztVi?=
 =?us-ascii?Q?mnr19XLFOAoXUK+TPi+qLaeeN8I0zujPrMlfAZpUbSqE5DbgFDWx+DJsDsIA?=
 =?us-ascii?Q?NABwDD4qSJdDu9EkfLgT2osTIXiN/4gqFcWDEkI5y85qWVEwX5PdaXGOUB1+?=
 =?us-ascii?Q?/qxlgaB3LXyFqCwQP8xeZrRsgTybJqaTyWSDNm2XF55OR76zculyO53n0aVf?=
 =?us-ascii?Q?0crMjRMNUvMS/I5jlgIQjji7ngJ4PK8BmwardHexIMW1YuS1e4bI647uxBVd?=
 =?us-ascii?Q?d/zeMCc2oupx8WmBl8XdEXH4WN/jtRrgEPSvww+ask+3GO3BIAgPIlBgAyji?=
 =?us-ascii?Q?zV3HIMDF0LIOJSQ4JZRuLwaRtrWmqEBW3/CLmM4C6lJnDFPxB4Zs2pdBJny1?=
 =?us-ascii?Q?rXt6RegaMJQrYp412EGdGH/5bKwPiUlJczFsSDKemCR1hDt8aCfKDQgzlN48?=
 =?us-ascii?Q?byamejPWekxgRquZYiQTbuhOId6kP25oVEVu1Np4B8IGxtSJ6WcOB3TWmemR?=
 =?us-ascii?Q?KMlgZWHHi/Bv1t/wvDNarqVMnBWzZJKRxyqrd4wwDozX3l4q+RnqPHhWqMtF?=
 =?us-ascii?Q?CRnW69X0LkETs6yqIH+O7Ln+HvAE407F8Dv5O0q4LG/3SnsFxHqNS0Slh2tg?=
 =?us-ascii?Q?CxdH7ThHcXkmbvR2sHldc1wVG3ZXl2TCYKH8BrKNzWkgubKriEb1VudlLub3?=
 =?us-ascii?Q?S9BE6d2TCV/9ec7zGEqkDhEf679jAvSf6diJUa1KTNQ1sODRH89LN/XlJlxf?=
 =?us-ascii?Q?UXZIRpL9GP8V3wdYPM6c8R4bkKprDWZVjpazjxDAhByAGB+U6V2KwrGa/Mia?=
 =?us-ascii?Q?8ix+ixa9hJWfs6t1tdw342aUUJeqYiVfWV9HJTa6W1HynpiNdWmrxezEDylg?=
 =?us-ascii?Q?/xKLrxULODEAPIqOtN22AaqrTmbAcw4VCVsPdQeP2+jES3p4SRfr29RyQUfV?=
 =?us-ascii?Q?0uHw6KJVaYoiu40l697S3pE0QsxWKd4MSfVkXjzjA25XDWYJh0VHPk55LrlT?=
 =?us-ascii?Q?8l3Lgk2+m/PAg+hLieFBujrEONe4Zyrqa7iGUrbkIqHpUSxM5tFFOQGoHzmj?=
 =?us-ascii?Q?MRUACTLpDrxsax5cgLFaMCJBmg2SmAYoV1r4d3UaU9PEYD9clwZi4fZo6yMd?=
 =?us-ascii?Q?Ac5KZUolf0p8AYUBvWGtzNc2vJDSQYjfyHcDPimfNS3lluTsidhoMglzt4xv?=
 =?us-ascii?Q?V93FGG5xZbtxV6osiXcxQfm0q79CQW2kmKCn+K2nJGgfj4OX+3T3vNDMjPw6?=
 =?us-ascii?Q?7YOXkCnyA6MPhl0twxewBUqn+L6CLkxzqXmoH8Mal7tPQqMgSNLIe+JyEoVH?=
 =?us-ascii?Q?7TPI6/1Pke5j2spJ7C4y+glQ2PixMkmHnx//nbYGwfiHH8xgocqMBoq/LsbR?=
 =?us-ascii?Q?q4jQInUlXzu3zUQdEFodAnod5Jm33XcZ/+veCM1U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a86f9b-cde7-4ffa-5c7f-08dc490c0b39
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 18:32:05.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTihfR5nt+a/46zUhIRuKUUGUgvZO1LwHyyBlyAm4MGgEWDA1SQENsKwKR0H1ozx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6027

On Wed, Mar 20, 2024 at 12:11:36AM +0800, Michael Shavit wrote:
> > @@ -448,19 +446,10 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
> >                 goto err_free_bond;
> >         }
> >
> > -       cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
> > -       if (!cdptr) {
> > -               ret = -ENOMEM;
> > -               goto err_put_notifier;
> > -       }
> > -       arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
> > -       arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
> > -
> > +       arm_smmu_make_sva_cd(target, master, mm, bond->smmu_mn->cd->asid);
> This can probably already move out to arm_smmu_sva_set_dev_pasid in
> this commit. Removing the arm_smmu_get_cd_ptr pre-alloc might also be
> possible if we're careful with failure of arm_smmu_set_pasid.
> This is eventually addressed in "iommu/arm-smmu-v3: Put the SVA mmu
> notifier in the smmu_domain", but that patch is already big enough as
> it is and the change fits nicely here.

Since all this bond related code is going to be deleted I didn't want
to mess with it too much, but sure it looks like this:

static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
				      struct device *dev, ioasid_t id)
{
	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
	struct mm_struct *mm = domain->mm;
	struct arm_smmu_bond *bond;
	struct arm_smmu_cd target;
	int ret;

	if (mm_get_enqcmd_pasid(mm) != id)
		return -EINVAL;

	mutex_lock(&sva_lock);
	bond = __arm_smmu_sva_bind(dev, mm);
	if (IS_ERR(bond)) {
		mutex_unlock(&sva_lock);
		return PTR_ERR(bond);
	}

	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
	if (ret) {
		list_del(&bond->list);
		arm_smmu_mmu_notifier_put(bond->smmu_mn);
		kfree(bond);
		mutex_unlock(&sva_lock);
		return ret;
	}
	mutex_unlock(&sva_lock);
	return 0;
}

Which is much closer to the final arrangment in later patches.

Jason
