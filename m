Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5733C5D91C;
	Tue, 13 Feb 2024 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707841583; cv=fail; b=BIktysTgpgDC4g2eF5KIi1Cah+3z4TAUClw8Je8JRkl3xazpa1TG7pWz36qaqJ2WUfrD3qPpj01xfr7sKM4Hb9IFgUEtH1tMwgImfmJ5pxBcjCJy3qEEW5CSpTl2LGyJpTwBGQ+7qw4hVuULcFA1cRcEzkzSfsfzsYhGYU/ich8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707841583; c=relaxed/simple;
	bh=HcKhb1n12gkfXreYe7ucOziluNEUH0DG0JiGJIOsVMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kntKVMbH+W5LDskqFMEHof8fJpA3nRaV49ne7IVM1+Z2av06/YBPcUmKLhyFyCWWgzG+9w40uuesN2TcvaXgvI/y0KLg1iT5dp64I/aFuefRZX9mwpIutdwtxrpt+C9zhplYP1O9E7tEJr3mzcXf8FmQSOPquL8YvqAYPid48ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dnCUjefq; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dnCUjefq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhOn5xrzz9U7Qpxt590oXqeoJmnrDYMOqg8aIO1uw39iE9Axf/TaU99NCZOGgo/3Q+V9aTsqmst2F7rEdGLbu1uS4AV8yO7fejmzEmEARdP4MO1VDcC90PC3YXg0KbGnqP1jQ0/gTP2zPK60/hp1+6ufdLVWcONEYQU3zo8vcaovBYZIOLh9CMw40BMC7mPCWTZvWkwp+OblIRGu+YuwzEhlNlERpJQGmC2Zff7K9TinOdA81bEo85WuBbXB2YzH81HhbeS3QFqpHQxA3mG21jgb4z9LzdiV81/TroLnJ6Dza9mnV3uDZ7w0GPm0ITNlFh4dkyy+GWGf1y6xvF7//A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kct/SRxXM6qRp/13tgcXL01ugyNZpTpZLG9Vub4DERU=;
 b=CVcvfXCWsHYmCALetRonWhAowU9n9usglTyGFhRMbem6tgh+e+lVXmBzwEaFclAiVHL89LVh6rqw26JrjRNagWLrm36rxkIxtmse+vixtHindE4reQXz21Y25MKNa9Bb7g3dIMXcq3Yi44Yvf8bPf6V7kL6h390czc+zGqO2m7BAXW7S/vnr5o6PgDl19gG1sp6p3W/FTGbQNgswVnaprGCXyAHcB+A4uJXFAuUIrQIw52EfU7iLA7Z/KakwBEC8DEF1RWSUNakIIgxLyOLHSam6xoksR8tDaYcg2Ko4cheGRPfTFRbsTFugR4X63pleGfqcFklxFTQiOdiWgbF5CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kct/SRxXM6qRp/13tgcXL01ugyNZpTpZLG9Vub4DERU=;
 b=dnCUjefqbige7g3jEdANX8yyAidVHfmVYssPW75fXKtTNA6szdaD7f6uTrw7VVE8lMT3wWSE33SS728aWggbjH4Mj4qAEkqeLqaQ16T1MB7ZuoXT2EC1UkLJnEwZuVPC4I4pbRT4x42G1Y1eQmVTtA1I2M//9y4ESEsqVCZOXeJWjuc/MRFItE4oNu/vy9xgVq5BgzbezKGl0hncrMJPYKTJ6uKg6PlUvW19oZM4qCXl+sksqpp4FRDxGe5KDnES4dBq4PjFfa2yD9rW91rVwhyZ+fo/Xz4X0f9k/hoNaN0eOCGZCw7P4zwUKuE/nvZKekpD7u/afypVpMqkzATAjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB9108.namprd12.prod.outlook.com (2603:10b6:806:37d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 13 Feb
 2024 16:26:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 16:26:17 +0000
Date: Tue, 13 Feb 2024 12:26:17 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 08/17] iommu/arm-smmu-v3: Do not change the STE twice
 during arm_smmu_attach_dev()
Message-ID: <20240213162617.GD1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <8-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuNcka3q3nUOpFM@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcuNcka3q3nUOpFM@google.com>
X-ClientProxiedBy: MN2PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:208:120::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB9108:EE_
X-MS-Office365-Filtering-Correlation-Id: b1d0a24f-da44-4cf3-0b78-08dc2cb08184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JsgAQSLX6GIEX/xIHUWLia+F1SMajdwyRtJSPixgYWGd8+ZFAJXl5QbFUOSWN8aKOd3i+DanbvrW8AlVxw7IhH/blYg1MSj1peCeuHEkDvEWrSzN1bR+mcThKhkNREE+0nfs5e3or+mQxsCGHdD4aYmzN7rQHYVRuA+rWiSEwySDd3zMPik5y5HsBHnqOgIs5BeZmSXqBQ7V+2SFukHQr2G67PeFyVEfQRRfHxHV68tu++b7NhwEbHXLMzbBUKzozRCkKtfkMeR4jG9h4LbNg7xx5vslbRoLCI+m4AtwtAgfVh8HI8C+lrYH7PUwWyrns/9lG7obkAORN70XhoRg/EuEWwtiPdUstAVrGnRkLLk4oce/lhRX8FQLs6MWvP/R0XFZuiUC7KPufrynz3JH6pedDIvJih9vKDraDuQ9qVeuzyCq67qlGJU7V9SaO1uWJ2MjvpqcDKB78lp6RLf/GS1FGGiZpYNqa+GFqbKfO9ecyiBsGH0NfZ6pi21BjKsfU3ctOvu3YMvBFxAuaog+f1HxEYKJnX7OQLSTFnyJ0cofj2BZLM+rHf5TAw7QdCKv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(39860400002)(376002)(366004)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(41300700001)(6486002)(2906002)(7416002)(5660300002)(66476007)(6916009)(66556008)(83380400001)(4326008)(8676002)(66946007)(8936002)(86362001)(54906003)(316002)(33656002)(1076003)(6506007)(36756003)(2616005)(26005)(6512007)(478600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JMxY4SHeBI4uQUVckloOVj+rtI9SxIl19SO4x/gE/IQEEDUanymABvxoKTIY?=
 =?us-ascii?Q?a+uLKoVDUnrlOqs6dGwFhktGGmfxqZmvRrpi8KDa2VyCqy/nzrs//OSroigx?=
 =?us-ascii?Q?xhqHMEHzvs82Z7J0yV+bww9/7QTAj9K5i+McJ/zsnmiTbN3Wld0FTJCbsJNM?=
 =?us-ascii?Q?v8/IRESW9PxepSkJdULcpDigLpValLFmZeCXhEzyi0JLODaCSSv9qrTZje8x?=
 =?us-ascii?Q?e30cjGjs+8YkkNu9bQzW89Vj/hTZfMKKT6rwr0QEO6HircxndLLg8t8V4USt?=
 =?us-ascii?Q?gXlAjUCDGoPLvEWzFSF/WWuPecm+pf+ZBZXEHkYhx2V7MVjt+iefSGkl++Ps?=
 =?us-ascii?Q?vGlJS0fmI2YBxxLGAVPZwwIB4TgOZHMzijYoB2nAT4q58W3eQCblspaC96xA?=
 =?us-ascii?Q?QTMI/l/19k9cEvHL9YujExD+JCVWM3s0GFFelXSydpwd8NflsYJ7ESAdhL9u?=
 =?us-ascii?Q?BN21waiO7itm9bR+BfXxWhf/2qWcBlRoqZI5rFYAtffGFWCdjgikf22XTqZN?=
 =?us-ascii?Q?h+tKLd/BY2k0L7dnQJ76DZGux7i+Da2g6twqWXRFumE6B68hIydJdWMFqhS9?=
 =?us-ascii?Q?eYDSZdY5HToJ5np63LoAA+v5HfcE9vmKSNQ+42vBz+hndS2Q83TL5hd3BO32?=
 =?us-ascii?Q?rGcf+MHx6uGV9RNEHo7YPMvYAI3RjLTDOxiHlbNoJNGlKCz/9HO34PQ9G5zm?=
 =?us-ascii?Q?LkQde6K6yxKcwEkz7TK36Qj/PD4Qwp5L8LMUwsrKOr1d7sr1A0NIQdWVHtXw?=
 =?us-ascii?Q?wzl3RT0mee62vvrd/7528joMOhAOr+sYyVvUqOu8UJGicFB9lIJPC6yj4pkx?=
 =?us-ascii?Q?4bYaUfTsJBac06Y1x5WuFVv9FokCaA+OkdkKGo6kI87kgYAPNH+h3x+3HBVp?=
 =?us-ascii?Q?8GHzbIEXVDHoXg4nN9N0sXTCEYDIpf1GSHr/bj/g+6RqQrNx+T/vAMntFLhA?=
 =?us-ascii?Q?+J6a79IpS6f15B6bQfK/9CbXdVEDfMJVw/dWBIH9QbvbJNmS38XPGcca0u2Y?=
 =?us-ascii?Q?rZJI6eipnEzEWK8pY07mOKrQ2DIQAd4afk/0SW/b1FHXBYMX416loLGEkoVP?=
 =?us-ascii?Q?yr2guhzEQeT/o/ld6oeVbVVNp2SzHuRRrxgIfxKtEVu3cBZPKPOG2fca1938?=
 =?us-ascii?Q?3k31dB9Yly6HEwJTfCQgxuLGMjrVJ71w4SX9TWrkwGarlYCEn7ndwo02h3N1?=
 =?us-ascii?Q?A4gKyVdbMvLtZx7GjzBmAAaWloUPS9oAA/Krbb1S1PSmlrFnQt8HRuQs2GSN?=
 =?us-ascii?Q?TPOYQcBu6h+5krWvnArSe1XjYq/fTt08nkLHw5R8KCTpewKfIZRiLRwiLK6R?=
 =?us-ascii?Q?Xd9aK+yHQfD8uWTEfZm8s9w5JnNKltCDvkKszHuK8EH68AUxllWukx40P3f/?=
 =?us-ascii?Q?6+4QDj6KtaVzPXH0e1o+F2UyxbWKT9Gqq3ftTEuVLGl3KXrhsTe9kRYIUz5K?=
 =?us-ascii?Q?6wEOWfNIcshXkwX0tAtFvu5YCtWFeIqquvGvVWfj3BQWHsVzpbpchQLdWrYO?=
 =?us-ascii?Q?ggtu2kEV3newF8+d8qf+irZm1hoqaTHQWKyt4hLZG2WIe/M0zntPeiKSAum8?=
 =?us-ascii?Q?r0TFniCKNOHJm24ny//vvcVblZf7VRMHOpq6/LTq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d0a24f-da44-4cf3-0b78-08dc2cb08184
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 16:26:17.9658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XCw2lVgazFwA1diIuwwJzHrCuTD+H+SQt5jIxGCsyh+EyjGfUithp+cJnuBlaVJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9108

On Tue, Feb 13, 2024 at 03:40:34PM +0000, Mostafa Saleh wrote:
> > @@ -2928,9 +2922,18 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
> >  static void arm_smmu_release_device(struct device *dev)
> >  {
> >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > +	struct arm_smmu_ste target;
> >  
> >  	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
> >  		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
> > +
> > +	/* Put the STE back to what arm_smmu_init_strtab() sets */
> > +	if (disable_bypass && !dev->iommu->require_direct)
> > +		arm_smmu_make_abort_ste(&target);
> > +	else
> > +		arm_smmu_make_bypass_ste(&target);
> > +	arm_smmu_install_ste_for_dev(master, &target);
> > +
> >  	arm_smmu_detach_dev(master);
> >  	arm_smmu_disable_pasid(master);
> >  	arm_smmu_remove_master(master);

> I am still reviewing patch-1 and the hitless machinery (also I think -or hope-
> this can be simplified), with the assumption that
> arm_smmu_install_ste_for_dev()/arm_smmu_write_ste() will do the right thing,
> that good looks good to me.

I'm interested if you can come up with something. Let me know if you
want to bounce some ideas.

> However, as it changes the current behavior of the driver where
> disable_bypass used to override require_direct, I am not sure if
> this would break any existing setups.

Yes, the commit message explains this. It is a little bug.

require_direct takes precedence when building the initial STE, release
should restore the STE back to how it was before probe.

I don't imagine a case where a system was fine with the STE during
boot but doesn't like that same STE during devuce hot unplug???

Jason
