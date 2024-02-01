Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38018664B;
	Thu,  1 Feb 2024 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706792570; cv=fail; b=Fdc47lb3GyL6IR8G52fD4BHJRuq5b+HZFjZEOB/BIzU//hBc10AwaGzswtiQUg7SmQePrLguIxRSknhqqzRNKK3jj4JP46tEt/cX4TKtY9rICGnJa6R1I6mbOA8NjBlKrqNOgOP4JIQZjwvssdMBG6b06eGLcB2EywOnOD+u3Fs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706792570; c=relaxed/simple;
	bh=o/VbA/LHM7/QYHKu9s7eWJadWPyfsJTHMRi3d+vC/m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UnU1iV/qwB+87N5Xlquw0Pd0sRwRhgO2rudgxDBASvYdSvTcgl+FVPbY7FfZbArZkz2pWdomqRK+CVMidya5rZytvRZ7xnCwXgNHdWHpw3dliZB6BGxbGwBZeiwB3e2GSwH7VlLXAIri5q0Z9D5fbGEiRx9CY1jBktOKOBxL2mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sWGwkCUy; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sWGwkCUy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORM1O3JamHS9JRPX6tyiJz9zOSuBDNC2f+GnwpPTnL4FsFb9BTQeINmGtqImPraLqRCgrUcj7dIoeLWlS1AqdJ33iOpFooHXeBKKKYSssU+iRR9qZY26m0XrrKdwaIfp6r11q+tArrk8DiY/3FANXzHMxaPcOOGEj1e0itwT4OV0L2oKNFxrfZkQIv6lCmfqWKmjWnck1cnb/6lIL2wvm61284V+cv5l19DZE6WdnBEBxfNPXtJffVGCRHFCnmhzU3ckgmJ7HI3opNATQ2GipQU+6fWFPeHyQZ1ATTaPm5TokAFagB/aaiPnmeCcunpYY/ZnXjigGaXSo8VFSFWbAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpqTK7Q64Z1ThjMU3zuy93eTaZ7iuuTtwXe/qr2kZy0=;
 b=bScL3tDxAuVjEKMS/eRgGzwA+rAoCD00hIs8MtMPdTWv23qqk4EV3HL0BzHReycLZ5vZ/I5O8rlGZj88IVJlpMQ+CzWOtaAcZBFuROPP08quhEOjF7sJOgtrS4Qw6NSqqDeGgNN2OJ2N0CpE+Y9TXKiXb0sQZ1dsLpzddjBcteI7/Sjem4n0/ZDGyE2y+DjVcwFpOZrqsZiugpRtsXtySWadl7fnJP4vs/ASiv7b6Hzr1JFF3N6paZSS7o/pSDep/Z3TFvq/fa0H0BIcw1NJmAf/58z7zycUiig7cp15kN63jORkKShMM7bRaetF9p4SnL8HFLyLhJx7Wkob0fpmsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpqTK7Q64Z1ThjMU3zuy93eTaZ7iuuTtwXe/qr2kZy0=;
 b=sWGwkCUytK6O+3fBXOVITmsuGAYugodSq6Ut0XGxLbiemFdQc4SJmF8f2j7AvVbwI3BL+v2xQxvGe4Ofl4ITT93GQu1wDd7sUPLXSJ8bLKxo6i9jx33ZSDwiGuPHDQDE57CWBZU3rHPjemoq05UO0ZVHm7KOUU+ESKQ9zN+4dGWL7oYZVBo0kiA/4Rry+dYYPvBh9z+zwYbyNX33o/bg6PhtyOlk9DqlDHo3tksH1M3M+BGS4oidwP94Usn2fTR+F3GnshbJC6glzSHsyWK/SqZhcWdrv61H1lyyAnhgfcbhEXbrkDtlyC0PGhDtQlHIrMpXPI23xuO6tpz3IGBO2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.11; Thu, 1 Feb
 2024 13:02:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Thu, 1 Feb 2024
 13:02:43 +0000
Date: Thu, 1 Feb 2024 09:02:42 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 02/16] iommu/arm-smmu-v3: Consolidate the STE
 generation for abort/bypass
Message-ID: <20240201130242.GO1455070@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <2-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbpb2JSgnRuHGIo-@google.com>
 <20240131144702.GJ1455070@nvidia.com>
 <ZbuBWQNEDqlFAoFi@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbuBWQNEDqlFAoFi@google.com>
X-ClientProxiedBy: MN2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:208:23e::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: abeebc7b-60f4-41e8-cb67-08dc2326145c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZVEzWj9jlr0hehJIh23x2FWM0fuZ+7az6xk0u8+Qu/QFDb4y0hIVaewAq29X5PUYCfqz7TYw6aaq6ljEoz+oqpfipy22ks1fLm9rFBge41P7Fr8HjBj3XpkLIcinLRJ2ulfTPV9y8UxMCgxT855Uy+HP99e98pNtBvkTu5BHJfFWqcXOfgMnmYVEwhu8LCDfnGJLakq72OOlzSdmprZnpRd/7q4knqeqxL0WyV45cvfclbckA6m5+LbNQrVZYbLeWm7j6VbRaHyk48KMifX/e3jxyKavPK2woueo5hyto5eeOFto4fIYX4vhBpNRrd9xeOJ2xJJl5NATtLYUiv3ndPx6TIKi9XR/2CntjgQX3gNdv8dPNVkGn8ji0z5gNngWNFEYAJdh/jShJgTTr0lJtcwM5k8Bf1ODxxmwFYQrvxpudEkFMmsL8Kh98sr4Mj5za6NibN+abDqFGBOorvCdisqHh32PwJzpjdUdG6qPVQX1J210yjq3zXbQjiqCcD9X454m1HQxEfI8yxkq9HOFr8V1RxOfRiBU7vwpKWgUVoMxmDUJVQezuI5idQHML5uV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(39860400002)(376002)(396003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(83380400001)(6512007)(38100700002)(26005)(2616005)(1076003)(5660300002)(4326008)(8676002)(8936002)(7416002)(2906002)(478600001)(6486002)(6506007)(54906003)(66476007)(66946007)(6916009)(316002)(66556008)(41300700001)(86362001)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QU05czVjZ0Jzb3duZXlSM0xCOERRVWZGdGNXODJqT3BHSGlxTExtZkJzQmYx?=
 =?utf-8?B?ZWR5VldRUmRmTWtrQ21MWW9hTndISWNCRXIrZmpML1V6YWdyQmFnZ28xVGxz?=
 =?utf-8?B?OFBLbENUdGxTaW14emdUaW1FdUZOVGxLaExHQmVJVjREbUNObVZmMTc2QnNv?=
 =?utf-8?B?R25zY081OW14RXN6cDhlOTVObDBJTFZhVlAzYjNaN2RIeTJ1ZlB3MXU3cmR6?=
 =?utf-8?B?RU9ncmRUa2lZWjA2SmRNMW40cFpVcW5ORTBMSCtNVmZuY29BRkl5ODM5dGkz?=
 =?utf-8?B?TGFRRG1Ub01wK2Y2MXIvaEJtZ3lWYllNcmhHRVFjakRxczlUSU1GS3BVM1dy?=
 =?utf-8?B?V1JYMXZGQ1Vlc1djd1BsSFN2UVU0VnpVanZRMVlKc2hlQmJWeDBhYkw2djBD?=
 =?utf-8?B?K1dUVW9FZ1lNakdIZXNnNytPMkl4SHJtK2J0REE2WmRuUmRTLy9JMFQwSDNW?=
 =?utf-8?B?K1l3SUdVK01aRHduZEF2OWhrVEhOTkVQeHpnczR5OElOMWhxZW5LZGFkNHJE?=
 =?utf-8?B?eCthVVB6dFM3WlNaT1NGVmhnWThJSWJyb1k1Z2xSNy9CbDQzK2JXZVdveHJK?=
 =?utf-8?B?eWd4bzBwSkZhbHBRM08zMjhOZmZDSlpRQU8yTTNxNHZSQmRBUkxyVDBEckRT?=
 =?utf-8?B?OTA1TWRFTzJNQUhsUDV1MHliQjY1WVZINDZoQTNoTTBpZkUyVm16QWFqbXlN?=
 =?utf-8?B?VXE2andpZWk1VXZ3eWxnd0RYVHhRNWxBb0J4dGxDWE4rd3FuYytzMXlkSkpo?=
 =?utf-8?B?NlZlQ3c5N010NE9uTzNkNHMxemlXTzJsRThid0ZIbGFwOVVzcE4ybStNM1Mr?=
 =?utf-8?B?eVg5S1ZYSGRBRkJpS3ZhTDhmUitIN1ZHUk50azZjTWhBdzZCTGJ3aEtQSmgz?=
 =?utf-8?B?YkxTYy9HbnlGUVNzaXBuN1hBNHprR1ovb2V2cWN6Z0svejRHYkFJbGU0cWln?=
 =?utf-8?B?alEweU5SQ2EveXJ2Z0RxL3dDQzJNbmxqYVdHWGpYM2M4Yi82VmhVVm5HdGpU?=
 =?utf-8?B?VDZJRHE3d3RMM2NNU296QnhuckFBRkJqRk5NTWs3QzdWYVhBOGtWbWEyTWRi?=
 =?utf-8?B?ME9xemFhKzR6bk9EdEtCVVBDZERHcU80eEVaMTlCNmhRWW5vbHUwbnZwVjhI?=
 =?utf-8?B?MG9ESUsrU1RUVDMxdTk1bDhVQlROSjFETEpYb3lMT25pajFWbXo3NDJtTVda?=
 =?utf-8?B?SXRLQjlCUXBDSndnRXVRR3g0TnVMWmxuYk9aMWdyZzVGR0hMaFFDQi9LaWlu?=
 =?utf-8?B?eVIxWnlobGpEQ2hmWkEzQWkyamIyVUQ5SEFMRzFNeVh3OGNrME1IQlpiQnFS?=
 =?utf-8?B?c0paTXpEVXl3WE5pb3VOSFRFWC9raGlRNHVRSXpITGVUb1ZiUkwxcUZtb3VW?=
 =?utf-8?B?clFyQ3B1K0R4RndEcDIrMUlpMGJBS0Y3Vyt5OHBWbTNFSEN5aW5jZDI4eW9U?=
 =?utf-8?B?a1pHcWZyVEtxbU5pK2JWY0QxSllacVpTUEdXdUJWUTE3RVJPM1RGeVB0YkZS?=
 =?utf-8?B?QStwNmRPU3FJYm5KV2NUazZOOFA2bkxiekdBYldaWTUyOTVlQ0FRT2ZCcm5K?=
 =?utf-8?B?TXRQb0tiZGJOZVJGNzR2WmxXcFkyd1k2Z1NFbVhBcld2TGFsVmNpVXpmSnFi?=
 =?utf-8?B?cHJDYVQyek1sU0lSSUNOOUxBamRPZkNOamJuTFVQdEpMdWVTQUZ4amp6WU5u?=
 =?utf-8?B?Y3VCZ1R4Y1dQczFyd21yc2JOYUFodTBTM0F1emxNL0JONVZyRGVha0EyQlpL?=
 =?utf-8?B?a3FTdy8ybzBTdmd5SFFlQU56NEV3ZXJMTjZjbSsxM1V4SGJ0bnFhbzBBUW8v?=
 =?utf-8?B?MHRMTXRVVUxtUU5LL2x4cHUxbi9ON3U4VC93d2RVVk42R01yRGhlTmI3cFFk?=
 =?utf-8?B?NWYxUTluQ29rUGZ1cUVjb0plOXZyeVIxMjAxOGVXUjZYeFNNSmxvRWFTWUFa?=
 =?utf-8?B?TlFGSjgzdnJSaUh0cXdiRHJPcC9NUW5mYXVWZlNhQWhVbGVaMHN4OFRkVEhR?=
 =?utf-8?B?amdJQW1OTGYyK28wbjVpdWl3SWtWQzlSaDJxOEpEQ1RZcmRGM3ZMN29hYWRo?=
 =?utf-8?B?aVpDaUVac3dUMjFzU2FOMDZsYTFsS1owa0lwT1lpVllLM2ZnZVVCaTNMSU0z?=
 =?utf-8?Q?nTzcaX/we/2GCj/6R0Hsiu+ZW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abeebc7b-60f4-41e8-cb67-08dc2326145c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 13:02:43.8672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ko3UB+30kYVuZQegsHhCVWNW2lUw2hy7OzcHMdZ9ZA0AY8KIetgvxjrNPOJmjSKh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270

On Thu, Feb 01, 2024 at 11:32:41AM +0000, Mostafa Saleh wrote:
> On Wed, Jan 31, 2024 at 10:47:02AM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 31, 2024 at 02:40:24PM +0000, Mostafa Saleh wrote:
> > > > +static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
> > > > +{
> > > > +	memset(target, 0, sizeof(*target));
> > > 
> > > I see this can be used with the actual STE. Although this is done at init, but
> > > briefly making the STE abort from “arm_smmu_make_bypass_ste”, seems a bit
> > > fragile to me, in case we use this in the future in different scenarios, it
> > > might break the hitless assumption. But no strong opinion though.
> > 
> > At init time, when that case happens, the STE table hasn't been
> > installed in the HW yet. This is why that specific code path has been
> > directly manipulating the STE and does not call the normal update path
> > with the sync'ing.
> > 
> > It is perhaps subtle that is why it is a different flow.
> > 
> > (this is also why I moved the function order as it was a bit obscure
> > to see that indeed all this stuff was sequenced right and we were not
> > updating a live STE improperly)
> 
> I agree, this is not an issue, but it was just confusing when I first read it
> as “arm_smmu_make_bypass_ste” would make the STE transiently unavailable, and
> I had to go and check the usage. Maybe we can add a comment to clarify how this
> function is expected to be used.

I added this remark:

@@ -1592,6 +1592,10 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
        arm_smmu_write_ste(master, sid, dst, &target);
 }
 
+/*
+ * This can safely directly manipulate the STE memory without a sync sequence
+ * because the STE table has not been installed in the SMMU yet.
+ */
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
                                      unsigned int nent)
 {
@@ -3971,6 +3975,10 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
                                continue;
                        }
 
+                       /*
+                        * STE table is not programmed to HW, see
+                        * arm_smmu_init_bypass_stes()
+                        */
                        arm_smmu_make_bypass_ste(
                                arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
                }

Jason
