Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF644C63A;
	Mon, 25 Mar 2024 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711376079; cv=fail; b=LWI0NLWTjJBX+r+s0RtXWxzsSFUcz1+HMqI9aWy6EMPiWHTrf81qGoU3jkIa9lV6UxsKQxReyz/usakHR53PJPLdqDAUfmhV5FJ3U89V/ERPmUGWpr46PpCdIBqdUPzcW90kYhW8GXtFh521AuohfkjgVkGRkep6aL4IC8JcSr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711376079; c=relaxed/simple;
	bh=Fl8EHn6QvUvkMp9aRwIDP4dtmWAeAMN6cJwMshNnZA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=krZ98IBKuePpo1USHPv4+NBKRq+7tnksmebeJpT9nWpr7GgydPhERsWMhm0vqAjEJrvOFp7EQHYcmqkEgihPX06edDY1Lrjw5FjflOp0QxifBF3CEj93ryI40DYSsqxpP01G7jpBdqo/Fxd5zlLDYpUa5ea9EatSY9phF8T9mIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rhNrRX0E; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rhNrRX0E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mk36TmYlHzv48g88VNb0odTttKexHCgggDSZuSoFAVJ0xeuu5BXr5u3Dp3A+zSOu5IGjM78DxO4wZUyM8AMJWWRAytMvEJLveU63oNXiaJf7TF6rsp1JLP6tVmNoLjFLBDMPM4td0K6fAGqG6wLycoTY9+FMbKo9kiIq9KTT2Q+I+Zf4+MKXg5a4cLmPhe/oxzz10pj9tNrknRBjLt7ZFixHQyKUcZKjYy1h9/e/0o8wK/o1G4lOjDdNjrWeGSE2Legto3aJ24NvIZ5ch9iy/Z+beeF5JQmr2SAY+TJaqSRwIZ6TSYPdxApoUPeryPLX2HkCIYvLMiy83XFcrDHPwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlThRXWcjX66GS1rerwIts1X+4kz8dd33aInssskCK8=;
 b=m7FXdK4EldVlRPkA73sqysPHTgtmXxWZNZV5459dxDwKu6HqVuUzTcqOPfkvQheB1Y04oiXd/ud/gLH9dEciZVb8NTPJZXupuVA/9yfjkFucUF44e2tYfYNXl53EB/oPeIjiXcY6LHxpsZGiLvY5bEXimAW+3GpMUJ5RTCPy66BBGKpJKkSrycyFUgQnSG3RhCyrwxqJRsY+86DZRb0jbNa6v/1olU2liv2/mNOmtG6gMuHUIlIuf9q0EFbMASEKUG9owBdW/znW32eB0e93DqhhBmLUiYd6jqs6loxJlTNTSQM+4Kg2VndKzKGgVHHlqQEp6kqjuSR55nKFnVc91A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlThRXWcjX66GS1rerwIts1X+4kz8dd33aInssskCK8=;
 b=rhNrRX0E8x8T4IYiDTU/PNxQ4ij05xI+jUjNgbp/lR9F/jc5MvsuTqaczuFXphbA2kzpY/0M6CXBA8voUIP7O+hnGFxjqN28neg9pY7itp45Aslpnet0JzW2G0Z5z+0x4s8vXlq2S8mhIMd3STtK+Iuw/9PnvxcZK6eAK0PZ62uWwJvttPKxIo2SUdMMzSHG9B9+PORkq3OsjSuhOfIoIVY9nOwYVlhlEK3E7rTMZLuEVUjDXhrX1a/Rcr4YDk+LLkXTjJLl2GyK4yJQi21Hwowz33BjRd4hMoxX4DM0ZsuFQrScXw/IZbuLtniVlLdCecam8bcLFou8LvxTy8Sikw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV2PR12MB5894.namprd12.prod.outlook.com (2603:10b6:408:174::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 14:14:34 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 14:14:34 +0000
Date: Mon, 25 Mar 2024 11:14:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD
 table entry
Message-ID: <20240325141433.GB110546@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf3PoRy_q7dC_SA9@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zf3PoRy_q7dC_SA9@google.com>
X-ClientProxiedBy: MN2PR15CA0005.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV2PR12MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: ca10e146-2fbb-4957-4d30-08dc4cd5e571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	77imCfTGchroVDPKT2Wy7DoJNUH1Xy8I3J4jWASOau4JFNlbnLv638lV72B7q/5g0uWEvdM76bNUN8A9vwTLJ71+C6z9VR5YDMvZ6PDTAmlUEqFGW+LgrcrgMSOdTXqcuQfkVVTkKRSvvQ8sMyO7ME2tcNT2oFgFXztr/eu7oLlR2whTHKU/kG6bpkx1Ahefth6Ws72cGjmwArG12+wDhdytW1PCuHFj0X2DfRlY40J7Cvi0eUZ159SaCDHPs9gMTHAHK0dtmQPcEt+sMxT2sCby3nqWlJGalPVwaW2nHflCb9ijSAT/p9xtDwM5Qs41ijJTNbZzPeBQCUWx7iF3SolFEFBUZIPJxB6PSXKqwc6pucR3XJBA+ZYpl0LZ3DHdHWsGZCPRwy+0dtDg6YAkjEcXtjYus9kMDl5Q+jWmGMCUSt14ysTE5wYn2OedyiSXSR52S6xnB5KdiAIp9hK8ijqaLTX87rnqqi0Fo5gaaipRSm6jxqY1sJuug+VDjfxgoMRy9uGZJXAAKDsJFNGzGgrPGE/6+HmgSpQx7JNOUoQ+G52ykhqbTSLNrdQvpF7Hdlz2Y+x96WJ2UbaSIJGp/md6bdp2Y+hoUdo3b4sR1tm9mmkjKTelMRIcPWJkGAMXLoe59ZXC5UALrz/vo0KavNXDdxnfKOdvbLQcP3+PZwM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akQ5dnhENGJiZ1VNNDY3cVZJNThVbFhQWnluTWRLUWxBdE16cS9lU3IvbWlJ?=
 =?utf-8?B?enhZSm5KaloyMmpUS1VKZlczL3RhMkVOTWpSYjcrS2MxVWdCamxQS0RNa3ox?=
 =?utf-8?B?RlQrQXE0YTN2d0J4QVNEbXhuaE1mNXFKRHdKek16bFNmdnRub0dOVGwvSklH?=
 =?utf-8?B?SHNHcnBUU0JldXZDK1JPQXBhYU13aTViNm5tYnFpbjQrd25XbE5YRm1WWDBW?=
 =?utf-8?B?OGliS1BlYzBuUGJIVDhWMFh2SWw2STNLQmxyRlJHRG9NWXJlaTBBTkdha1JI?=
 =?utf-8?B?N1ZBMHplK01yMUxSMExXdHYwZVNBdkJmc1RlVmdzVld0VFlGL3ZkbkJwcVBk?=
 =?utf-8?B?dnVORVVxa3hXWlRsV3liMjRHQ2xLSXhWQy9haGhmT2p2Q3BaWFhWeHpSaVJt?=
 =?utf-8?B?ZzkrMlVvV1pVM2JLWTZVc0trSTEyVEhwTWJYd1BSaHptL0FXNjFJNTd3aUda?=
 =?utf-8?B?V1VXbHdXUmhYZzdEZitMNTlEMEkrcVBkRmppc0lIcXFzb0pTWGJ4QjZlUFNs?=
 =?utf-8?B?SmdaR1F2UEdwR0lrQnRLWWczQ1l0RHZuQzh3Y2FFM2VmVFJsaHNKSHlhNmd2?=
 =?utf-8?B?RnphaEVvU3R1amJ5ViswY3NqY1FvYUpRa0hpY0Nab1dSNFB6SUhOWWlTTGp5?=
 =?utf-8?B?U1BpcG5GbS9LYWZsM3RUaEJCWEZjclRleGZ0UlR3Nng5OTVBd202NXJrWXBL?=
 =?utf-8?B?a1VqRkN1V0M2MVMvdWVHUnRlOVdWSVprVTNoVDdIdWQzYjFTYlc1N1k1TCtq?=
 =?utf-8?B?R05odW00MjU2Qnp5THZpbnJaa21BODZrc3RRWlRLSTdkMm8vY2N2WUV2TUZq?=
 =?utf-8?B?Nk5qOVVpbnEwMG5heURPZVkvMy9VampnS2Q4RXZudXhqSDN1T3ByRkwrcXNv?=
 =?utf-8?B?bWdubkZtdFdLUlhKYlZiQjBNWEdMR2hKYzdYOG5rci9UZS9JZXhQQ0s4SElp?=
 =?utf-8?B?SWdseDJjeEVQV1NMSEw5SHd5Q1F3VVZUZ0tkdThmTllFU3FXRnlhVWlrY3o5?=
 =?utf-8?B?S3MrZnNsOVA3ZVRKNWVYbEwwYmhncU43L0ZPc0JiOHB3RnJsaTdUM01UMUdh?=
 =?utf-8?B?c1ZjbDF5ZGVTbDVhYmc1VEw1Slc1THRORzJCTHJLOVBqNVNrNHNmMmNjVXdS?=
 =?utf-8?B?N0g5YWtjV2V3VkJIaWlxQ0w4V3k1Ym5oeGdSM1YxYmhJdVRET01qRU04Rm1h?=
 =?utf-8?B?NkRGVkpvckhlTytHY3RSV3o2cE85aW9IUjB6SDFFSkVPNjU4Uk4vQ3E2ME94?=
 =?utf-8?B?eFowSmQzUlhWaWhjUEV6b2Q3bmtmdU1ISnY5MVJTT3VmTUNNa3hER0J5SENI?=
 =?utf-8?B?Zk5ENkN6ajM4UFBMV0tUbm9wQW5BODNPZzhSK0ZFVnRFTzFCbitmWmlnT1Fq?=
 =?utf-8?B?UGhDUHo2aEVscGVWNElNdUxqbWduVUdHSWU0Sm1nR2F4dFU5Q21ZZElzRGox?=
 =?utf-8?B?ZDViY200ODZCR0tWY3FMV0lrNTU3c1Q5bk9PVkIxUGJOdnY5cDVpOUttRDZM?=
 =?utf-8?B?MFh3dE5zYmg0ZmhOU1A4d3h2QnRqR2dJR3pMVzNHUWJIb1VYakpwTDRCeWdP?=
 =?utf-8?B?eXc4QW1uN05HVnRGWnA2WENONXdpMXlQZjhORVdCNU0wMlZtWHQzMjQ5MXpU?=
 =?utf-8?B?c3BYWDVjVml6NkEzenZOMGs3VnVkWDNHVjZ5Z2EwK25NQldPOE9OVmNqU3c5?=
 =?utf-8?B?SkJTYTZ0cGs4NXRNeGNqRDZSalV0eHhqeXcvU2VLOW13T0NMVzdNQVNVOUpT?=
 =?utf-8?B?L3gxQk5PaW9QbnVPV0lrN2xLdVdEUUFnYk05QWJ2aitGbU01UXlQVStIclNC?=
 =?utf-8?B?cEVVQi9YZFEraCtKSnNCWEFZOGFQTldtWUZkN25LdEkxU09XYjFmRkZvZ3l0?=
 =?utf-8?B?VHVhcHRoY0ZRSnFBSE1xaWFXMnJVRXNZRnJQQTNJRXFvbStNMUVCLzhsTTJi?=
 =?utf-8?B?Z1FwZDJJWVRkZUFNL1pNUkptZlZUUytkdjlCUjYzUDZtKzJrYmEzUTNzS2Iv?=
 =?utf-8?B?K2VVV2ZKYngwcVNTUUtHOGJEVXdhUGF6NFFLUEo4SXhJR2h5ZzFNcWJzNlJM?=
 =?utf-8?B?ZzlaRGRYZUJLUnY4Wll2Y2ZNeVQ5Z2k3MVhjRUxSNUh0RXpPSnhwdEo2YUZm?=
 =?utf-8?Q?Mr0/XSEz/PDimIEMGkbXdMJn5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca10e146-2fbb-4957-4d30-08dc4cd5e571
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 14:14:34.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wf30l/4lOmYVqzvHgAYLO0rssIunvIcOC9UGNrvFzB8PJL2LIrzX0Vw8D6FbARR1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5894

On Fri, Mar 22, 2024 at 06:36:17PM +0000, Mostafa Saleh wrote:
> > +void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
> > +{
> > +	struct arm_smmu_cd target = {};
> > +	struct arm_smmu_cd *cdptr;
> > +
> > +	if (!master->cd_table.cdtab)
> > +		return;
> > +	cdptr = arm_smmu_get_cd_ptr(master, ssid);
> > +	if (WARN_ON(!cdptr))
> > +		return;
> 
> I don’t understand the SVA code enough, but AFAICT, arm_smmu_sva_set_dev_pasid
> can allocate the L2 CD table through arm_smmu_write_ctx_desc. 

Yes

> And if it failed
> before allocating the CD table, then remove_dev_pasid would be
> called, 

If it fails the core code should not call remove_dev_pasid() on a
domain that was never attached. There is an obscure error unwinding
issue in the core code Yi is looking to fix regarding multi-device
PASID groups, but it is not a driver issue..

> which warns here, the previous code would tolerate that, but that
> might regress on systems with panic_on_warn, so I am not sure if
> that is necessary.

Right, if it does hit it signals there is some error unwinding bug in
the core code that should be resolved.

> Otherwise, Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Jason
