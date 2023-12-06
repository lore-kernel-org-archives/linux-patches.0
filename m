Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136E49F66;
	Wed,  6 Dec 2023 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BlpPdMcu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wlfr4zzzuDxq6CYMIgdHBR7VC7tCpS0vIy7GFvBOIfqVzAaFqQIoBb8vYwlY1/Ma+R2b7glkFKJEYWmuc+leOKsGfvSaFynq+Brm5TGP+pszqfWZZz3DdBHaoCmnihHX0aPXzHlHXNjCw8BD08riAWuTO30GRJignvn63dOf4QwbpzacWVW0Yyc/Uy44hf4smeMwUfz3yBZtT6nB6St349kjR8BvGybEE9QsGfr4hdfUCDNVFgZ+dVDpFR3bWJyVvbyRGGz0FZUdpjsR12JNhP6IlcLmbSxVcAc755JS94mFaW4rVRUctLgk96+4lkx8kWiw5k8CMRRqFN0zUrnReQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HoDRRFaLriAMSIcRQb75wliv4+EcjymP+iY+ayLldZ8=;
 b=UONre6jOmXRHgRb4z/UiVvBa4c5IVRDn23bgKfbosdhwSCdqOCG493XAAoLTS52R3WpOu/ruErqYr4mmiYFKOeVbpUY6XDuOFQQNJCT+XprK6AxEKtcgpRY3Xbz8SVwkwDIY/HvvpofnA6jYc/oHFY1wxQ4G4tacNevPAvBL3HAIGfaDuDOXGlcz+2CvLuDqo8x6swRk2U2bQB6BIb3U8C/TCxOIRRApCB0rX2aAzV4o6JK1UBAuRGieEUY8/e9oQKn2U1Kp35elIRx6/aSX2CV3BCEKYOeGLGgwWKUlsR0+usEsSnZxH+hdvt0c7ljAJcQOT9HKJOw7kmHRfQ3JjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoDRRFaLriAMSIcRQb75wliv4+EcjymP+iY+ayLldZ8=;
 b=BlpPdMcueNdZWObCDJFqk7S5in6grPD8yY2cBTlm+6WotfBdvOBr4MfcMNDHroJR7a1x/O2bq/+XvgZhLWHm9zAeRXLGpXUd+gXmFI/V+WHZDIOD60Kgta7DZQESqsWYsEqcXo5VAZaySTnWdzdxIzrxn9abpvBpDSQSxS50Ro3+nRQ+sa5kOyaZPi2ExXbgbuFREOu+eyhDHHTi/o6hAbgdvaIN9LQN52tzy1HCcOAK1ywZ5A10G0MdZhgyk97JSBWtjrCaPONlEKVHeUt9tDwUUB2crErP/5AG7gPRtZNkoNwBBnzYC5w/6R/F7UhbU/Sj87P7Bo14+iw1ba7+tQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8806.namprd12.prod.outlook.com (2603:10b6:a03:4d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 17:28:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 02/27] iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong PASID
Date: Wed,  6 Dec 2023 13:28:08 -0400
Message-ID: <2-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8806:EE_
X-MS-Office365-Filtering-Correlation-Id: 179b6efb-2903-4646-d6b9-08dbf680c5b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CGFGZ2cK2KnG1laqQ5jp5O95UDFPZ5jGKx21/fMV9CEOtL/UZ02Hn1plfWZfEJrgjF25U62rb4aah4485wFwnFxgUT9C26AIIy26+kpanAgjNEUxraNRWdkPWMTXWU9CCg/+IBbOdbq3EW956DBuGsh5nVpg/AB1milMHPjPTX2+zZZp7+BGz9/faOtDXWA6522QC1L8OqtA7Y6JcxCfP17Khdj95cysccZsPxUO6AlVucgNJoU8HS8H6MpsUBSzPLB7oj9NZxgMB/dDagKBQ1QAbfFgjZ6Mx/Lpw44TRR2paDDFpa/7aBpYxSGgYuqOAVzmuT5QceEpZ8F0yEE5LOpAQ1W7v/tQeupItl76yWi9EpFgMLXnFQtr7Z3cwjaSUszhKxNnEL/b5qVE0q/JfTKjClkpkUPZvIu0umt2dopQ8QCpJM4mj5cANoKEcHLp8unGx6x5j4qSMAu867t27XDlorOmvHUTqDDEJivbPVegU24M7RrIkHvZ2YxAQPxLALKFSCidXLSN/ZYpPFlQMcZ0hvaxm6MYewaW/bxWNXfuJ4mNAvVGTvwI+UgIl+kKzW03tmhdQnmY+1cuxyFipLB01eoA6HpTJXf6F1EsbTk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(41300700001)(6512007)(4326008)(83380400001)(2616005)(38100700002)(8676002)(6506007)(8936002)(6666004)(4744005)(86362001)(2906002)(6486002)(478600001)(316002)(110136005)(36756003)(66476007)(66556008)(66946007)(54906003)(26005)(5660300002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DytV0HXlFmJR0zC4HVyJqE0WIK2e512TwdoWFOGdlGpd4re8ikp/AiSxuJaN?=
 =?us-ascii?Q?EPL3viYakMsrOvE4C9KoAnapwP8o589qfGhR7t8IXs55pwKfuzxKxIx99hAo?=
 =?us-ascii?Q?gcW2wVxh4RVe0yoRleD0W8pG+YPZ95iagEUcDGDR6+Usepb2CbO5f6LQ9Glo?=
 =?us-ascii?Q?1dQlMabkEJeRkyUtnMIEGcebGZPJjn5ofpTREHEzRtVrn5U6Uo5hOYmRX8Wk?=
 =?us-ascii?Q?hrQibzWSFlUqbh7A1CghahoYZ538rktRMZ51181DIyDsh6X08eUTE2tSxgOd?=
 =?us-ascii?Q?ANMoKH1RoHUobdfktJ84sNVgIBhIJX5oKtocVkZiFV5hk9k88AwWLpzkUEgv?=
 =?us-ascii?Q?NIk8Tzn7Ai1h55x2j80gv5f9/XR8xVdx1J0RgLYyxy31pkxfKL9aEsBwXkGS?=
 =?us-ascii?Q?m4RbBKCa6Anuc56GgGR26XX9gw3cZ1NZXAYhh9nvN/K/QnPTWYGS4BNeGH1u?=
 =?us-ascii?Q?R81/YKfoQKLahPEnyIzLJq3P84lTgYln6cu30ma37SVLT07Lh43PDZQ7+9QM?=
 =?us-ascii?Q?6uQ/SJKfM4yuyW9CNWA5NyXVbFvIbvlUyUNDhSnkJt1iBWQNztbfrmGhJlMc?=
 =?us-ascii?Q?suZsvcPVA/sfaheWGzJunAdU/CUVvopAlDo2ycqpdO8suNXor1T4+Bb1XAmm?=
 =?us-ascii?Q?JvwaxUhv2xeN6BEHhEJp6B4MJzPB4b6eqY3YJfpT5VvfwuhhL461w8zNsrxk?=
 =?us-ascii?Q?hd45tKxo0IvtZabihue62k1UYdv6YLA2R5Ue23GvgQbApn3GU14rRaTLwgSe?=
 =?us-ascii?Q?7kWRYqNhU+TXcGbsthJYqqTOrd0VHDzfiz7lrkHyogh5opYU1bRnyYgiMnzr?=
 =?us-ascii?Q?uENdEALtxB2frBQDTbEX0BBmg67bdr9GrOFXB9qg4F27NKv2ZBI+HG83xXOY?=
 =?us-ascii?Q?Vkg983bVDp93qmzOmLoFWjGfiln5jHmFtCDrYHsZ/torAHqk3u+uq95Zkx0B?=
 =?us-ascii?Q?VY9bzcIl/It78/oueWinCDpJ1YDza5pmhBUY7jKMZaGx2jF1wxtLBqUV+rUo?=
 =?us-ascii?Q?2wxXVz/lrZgAqnSfi/sLupBha7pk8EvXSOV10aCIwKltppCuOhmNO1XFzUZa?=
 =?us-ascii?Q?RN4YzJvlDE1dEk/lhYC/TufoGVC4nt0xz9NClwLp7lSPpN94AuE9kWAHb+k8?=
 =?us-ascii?Q?LMc6V2ADTIKLweGp8ntCEniP2QJThKbT/VMVS85yud/o2hDd/ikmVPSRHgqn?=
 =?us-ascii?Q?hgdXcSzyOROuZo85G4q2/AVEJjOEiiPhGp/mlxy4jndrA1bKxNMdm2TFHYMC?=
 =?us-ascii?Q?T8fC2QFFvn54FAnTn223P09lhqmiYJ5sGqphWOcqWyWAEWyosva4McDs7TQw?=
 =?us-ascii?Q?BFDgLL5GDmml24LAwWkEs0Mctg/8iAPkieOW/o1rsGef3nPixLONcjdCFI8Y?=
 =?us-ascii?Q?VLckA0FKl5IdE3qufedbBr+HEfPf0q1yr2rruwgedEeyjCxOoyku+/2R3Gd3?=
 =?us-ascii?Q?ucF5PTfswH533PZXDPB6sT0scvJxoCXOoU7FsXnivkmn0659A+IELl4Zt8H0?=
 =?us-ascii?Q?d171lOMloon2VGgPgKadLvUw1q1ZsTTrXjepchS9P5yDw8AgEOCnF7tmZQQo?=
 =?us-ascii?Q?BtQufpAaUsxjuPpr5dze2wV5h6M79sN+93Wlgghq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 179b6efb-2903-4646-d6b9-08dbf680c5b9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:33.8018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2HPnxKWMGVfAyFyfXE8J/r2F/m3pe7SUg9H1Y1QD9B4yH+VVw3H2y7fQFBvXz91
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8806

The SVA code is wired to assume that the SVA is programmed onto the
mm->pasid. The current core code always does this, so it is fine.

Add a check for clarity.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index bd0566381c58a9..ee3d148aafa26b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -585,6 +585,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
 
+	if (mm->pasid != id)
+		return -EINVAL;
+
 	mutex_lock(&sva_lock);
 	ret = __arm_smmu_sva_bind(dev, mm);
 	mutex_unlock(&sva_lock);
-- 
2.43.0

