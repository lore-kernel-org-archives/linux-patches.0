Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010024.outbound.protection.outlook.com [52.101.201.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D210331E0EB;
	Tue, 16 Dec 2025 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765905221; cv=fail; b=OVLdKmiWVZcM+Mwp6mWqO6QovXux+uBSbBch8yqDZihhq80j7QDq8J+ARAoaQqJHRPskSrqV2sOzyhImEngrJMibNzWh7q2ewJ8RRTBfldf9cvA1hCr1CW9DpMf7wpPT64LUTY/Wr6bzWI37iGPCdFocZTwy3XA3iMubu/URhkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765905221; c=relaxed/simple;
	bh=q2ertb0PxXsCoPYjPhs/iKRIG3MnCiFhx87R8cYtzCE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rYI0HjRmq8xPNqNMFlCpSaBtxCXr0o3aus0Ouhh2Khfg8t13RKXHrJtCG9JuxRUocSBkrFKlCmD8/1sxZgF1KLCVUQkfnISA5F8EHHTjB1SNHPO4TVjNKlEtA7AxXMZaeUs3pxz19RC7fBDroealQzi5rvsLAy1jNSFZXrON1q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qvsVNBnd; arc=fail smtp.client-ip=52.101.201.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qvsVNBnd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVE7YH7wbMcwx6An6PnjZxaS0R/NlHLdkKskTw+/n+6/5hlML5HDwCXleACIa5bqrenzlVrN8ATUwJun6IS18xDH5w1Cw9WAhXhSyf9lwhCQcqDWdLmCwZDIGOQczTShxwSvLy6cxaYHGYUiU+VH03sEiC1ct+UvAZ8HqIxoLtJ0V/BmeZqMzZL5S1xjeZVYD6yjTl8ODJshXiW+fzCw2lgtEMFpB1qnSq3TvWBDd/JQeHg0OYItyfEwmbYKRpui1b7nZgpOCnV6WXOanRss9Es2hv4YbHVjtnYxq780IsMWZlFwKhgCQ1RLJBuIldiHUKyI0KidTh/XgOFH5hAa6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEoof7T81VdsNv+cuLlbfXyQ5Kw+R2QXe6Qchk3emF4=;
 b=X5jt9ixantGIgKQ+RW+9kVjygTopImXlcK8kXde1ku2KJcQBry/JivO/bwbrs5kdmU7dG48YnxY592m7wUHB6AgVZp1y+rwLPCvLsA9wdXUaZlL1g2HwpyBlwUMypO1NDKAAqlxQWLlyuDK8I5bOHkNHEdGasPixMB8JimAYEad6gzMaOjLQDD36z6yB837o8lk9Oc5PYNx6d9atOeE6c1Szf2EZ8jUYSw6ordcScC0MjrHZy4/Ee045ZBKGCUIbPeYTs9v4g/iVoFj2F/FJDZNQN0SXjf0KjpXqnib0saoXF5hq6OCWgG9YDNbhbcQQsMvNNTNz5q8k9EFY+ivzvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEoof7T81VdsNv+cuLlbfXyQ5Kw+R2QXe6Qchk3emF4=;
 b=qvsVNBndvJE/rCmleTpZkhAKRo0rPJpw04h/UoELaxM0aWA9t9wSwU+G/YqH0PGPXFNA5KpIr+GI1fomkPTqpEPDcD9+UwmoWUS6fQdpcmK364ICOjGUc6Dus0PsgiK/VA5I2o3DEHAekQd2/QNronxpNeGESbPzOHXq7gfqDKXw4F88MOrTxrxaRQmVTnmi+5rKCk+kVtdPCI5OGRqfrAQVApNNEmpqnPV1givfioIrcYuW/oubCW8ZbLpGQvQcHgniOFiaHUQnpOoNp/sb97+oIW8Tk5ZBThWqdycObvUJ6ncpoC2/9dZKkHz04YtYh3IUM2mmdfRFXPHPDLLufQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 17:13:33 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 17:13:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	patches@lists.linux.dev,
	syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
Subject: [PATCH] iommufd: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
Date: Tue, 16 Dec 2025 13:13:31 -0400
Message-ID: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::23) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|MN0PR12MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: d49f9b1b-5dc6-4ab9-426f-08de3cc6713f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5NJCAzWZlAwU/Y70CtghRJYiCVNwomZaZqkkhp233jAQHyv2Xm0LuyZbh361?=
 =?us-ascii?Q?h4f4znR0PjZkCR6vJmcRHA4Sto9ht2fuWhigYxc20SwOppFKZlBY1TYDysx0?=
 =?us-ascii?Q?ukdtZGpocXMxctmSJsgxJUDDRiskVUeFTuIoU79xQjHrOoJLziV/8Gomxkw2?=
 =?us-ascii?Q?ea3hYR/f/dj4XMgUX0wkObLdiILM0kC1zJkO/X0TbxjrlEd17k+9K3vR4KML?=
 =?us-ascii?Q?+Za2WlXhLHqtArsBtID/AtymqOzUoXsS90+10Bz7Y9wf/Q3EZj7Mb5G8IXx3?=
 =?us-ascii?Q?k5lU7Vx8qeZSPbv3jYgYuISbE6dBuw1x6Geh1g+vBQBxuaB6gLEbQCWE3fa+?=
 =?us-ascii?Q?oYKDf8PdaVV1F9sP/gvbxZdBcleO0NSNZGH58dN1iTxyTwD0P0bitU22X8/1?=
 =?us-ascii?Q?DE04M+xmeNLdAsj/oD1V91u4+4YIFVsm1S3Rd8qujBTiiC46vgOfLhcwhDon?=
 =?us-ascii?Q?oHnJQ9B3yJ7fuJ3flR439g7RGo8ke2VMYkvPoR//bc5tkC3s4xU4AnrwsKjU?=
 =?us-ascii?Q?lixrcFj9rKdvQpCwsdmQMyubYSWhCXN05E32nZZ9+7SHROdh7jw4NdEq7bmU?=
 =?us-ascii?Q?zO2VWCZ+n7bH03jRKxQyYInfzAZgPkSiOhWNQGwi41TXIKHpTR+7/u73NPFt?=
 =?us-ascii?Q?x8hL3COGrniWQHVv3rSq1btWpYTBq6oLKHItyQlxd2sZWVBnQ3tOW/Ich2Vz?=
 =?us-ascii?Q?X/HaQYIAYwIvKxVfHqhbfqEo6ztFbGri/decn0LmS+L2XOUs+ZR+3alLHl5j?=
 =?us-ascii?Q?uxt5/QsWBNi2wWY8CykwWNlaO1eVUXFbUaTukG11WGDP78TrEkbVdfsjcdI3?=
 =?us-ascii?Q?dmW2JdfYlUtkqBgraLt9SxyWDmhDsUDWjcGqbUYBiLzFrMrEQFV8dl3/NcPd?=
 =?us-ascii?Q?I2k4BabU64qBZny5ZjXKIY0rCsnj0/JyHauAUmCMVnwZDzS5NNF8IuTjC2UV?=
 =?us-ascii?Q?+plgJ9lnvVnp2/REKIDIyqXrtcgPA6FDcauK6KL9qe4EGQcWviZOcXY8iTlb?=
 =?us-ascii?Q?r0K6kx/cxuqFONw9rX3+yoQ0BwBNVAgsoQCHaO3yLjq5cxqPRiRM5/b3bXyo?=
 =?us-ascii?Q?Xs+rWGD3ZULbx3NLANnhMyS02Xk9b2xj0oDPt/QhwqQUKF8SIHSm//Rrb4dQ?=
 =?us-ascii?Q?vy5pQyTDv9p8Ka9Lsuwz1zeTzvtDo/vWfbJSV943FRAVNNir+THCdC3wTmh/?=
 =?us-ascii?Q?XmZcyraxtbnrgaMLPNVWGlwYdKHZS5kdMyoSGt0hYzUHiPzdcVrZxnLOlWiW?=
 =?us-ascii?Q?6QuAaYp4B5xf+vb2AklIstC3/7ZdvXZVPuaMBm6tjHNTIyTWeQq1TcGdo/hY?=
 =?us-ascii?Q?VGG0fGwGvWNsXw6Lmv8dglxLb/XZ3HZktQkfJjoWwrqEIeKFYNvJ+4GiXTWX?=
 =?us-ascii?Q?dAkMJtVTARHgcipi/QtEWplwo+uF39DlOJe9WiztBMpUhRlBsWoBGcRmkBgB?=
 =?us-ascii?Q?oU4AAboPUZ9czWx7QE8mNHw2MkH2LZcf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KfXDpCdT5+HviW3bn3uUISvx1RuzB0Sgb2JvyMNsqpMallhAdNmFFZBR8Yc+?=
 =?us-ascii?Q?rLPC6Q97UazxavOjipRQe1u3BbdLzp9EitRnkg2tR5/j2djSMtcxTFdmk1yn?=
 =?us-ascii?Q?/r5CoT2SzFiBDeFi73YYvHxxYAxP384kLD5DkHPWk3JKlCE6mfeJIRFGN4ne?=
 =?us-ascii?Q?ce1IOtALBr2/E7tuRb/10AvOLFgjXnwXG2QzLbHh6auppHGqOmBv8JnEzHJp?=
 =?us-ascii?Q?stbWN+jzlIb3BNtrsPlMzYVs1IotpVnw9QFCNQD2JViyfC6aV8rqATqygyav?=
 =?us-ascii?Q?Ve6GtB0Rdkjw7BRMg2kM1S2Oyebsu1sx0ItfKFF/YX7kZAXiNWiB55VRUSwf?=
 =?us-ascii?Q?NNnfVx+RgiZ7LxRVAS/f3Kqlx79Nf+a0md8t2Clpz4VEXk4J45y0xt6pnqC8?=
 =?us-ascii?Q?RMqTX8Sza4vasUsxaZAYyab4xE0xIm1WRwqWa8HclbtlfKlFOx6ekcCMYdmN?=
 =?us-ascii?Q?xnmrwgx2xQAxaKwixpLBiSQYIr+vWtLcZQd8SQdPSUoffzGU4fko4XwWHodX?=
 =?us-ascii?Q?An63kSDQewVrwpjYrTIXbvXXCEs34t40p88nUs4TkclYHDcnKeNGNHcldvze?=
 =?us-ascii?Q?aO4T7i8C7w2/ceL3XnxJBFr7e38qWhxUQTNCJihbUNedTcHC1EHhKv43/fGj?=
 =?us-ascii?Q?00/ihHF7yzAilSfxibCKgtJxd8npXI6uB26Vsz/gRii29J8jz2iooSMvEcN4?=
 =?us-ascii?Q?BWZUwYeJO329vV4/vhvuSrqmIXWPsgtAohPOneZStu7aN9HDT9saB3KQPnmz?=
 =?us-ascii?Q?bq/pcLw8l1aQMaTef46EvTooZYj60OdnWcQJyOAzq7CN2OmMdGrnubuuAmbL?=
 =?us-ascii?Q?6OfbhkDGYm7t6VUEKb/lT6yKLwhIKWAj9c/V0mTAmYCHKLj5as70kc+saSUO?=
 =?us-ascii?Q?LwxH77l4Xtk2L/xMRRxtByyKNPlR2z5c/c1DfxqE8x8iOe5cGz3JzYCVsQzF?=
 =?us-ascii?Q?Z1uQIapSg1eLX96dMbDxCpH0UfCHMzKg2o5+hneISCYJTVDLfY05T1sJBib3?=
 =?us-ascii?Q?We9OdCc43H0xaGUxkObZIAF+RwMhAE4beIhN9aMl8LwRDxpAaZFXy41LDh3s?=
 =?us-ascii?Q?4NyRlhRFAf7ICJycKWLObspAlx9uHvw8XqQEK3K8Zj6o6zP/JNrhhM1FwJ6b?=
 =?us-ascii?Q?U9KqC+3H17bwbMMrynH5JM+XKV5+PHoHIhuF9FC2do5qfDjwALIc/6B2FHGa?=
 =?us-ascii?Q?dlWCSRVQ1pBC3wAxOQRI7maGBhaCp5JuFb+ko0jSewnZACVQvUQcf6DASPbG?=
 =?us-ascii?Q?NuYVlAyrXLYUctMrOPhjWfOG4al3ElFFV4M4c5l0qSKE0q6LYav8Apxr+LTC?=
 =?us-ascii?Q?y/Lps1Dk4+7/IiaJYRRcgFm0/q/yhBRzKqz8jyQxFZucGV+irkwGG7cYZYAT?=
 =?us-ascii?Q?HZdHDq7f1JCv0ZpTGqRak5j5mqwIcvUnSlhzmeTn43hLZsb0wRiZ5xivhbPy?=
 =?us-ascii?Q?RstE2BCr/rM/Wqq3G50poMWzbUy387UhA7l0ciUWKs9CGO7UIacYx4k7dXD4?=
 =?us-ascii?Q?oPKB8vREOhUd8B9+RKRZXTyzoKQ7quwYqCvcfnyp/Shfq39kp8puS3CcYfFf?=
 =?us-ascii?Q?f81zgQ9F1bWgYh7EA/kYXaBeVYe/e6BspA2sKWXh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d49f9b1b-5dc6-4ab9-426f-08de3cc6713f
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 17:13:33.6568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBxq9efR5Xwl8cSciQ/JRvr1CvAmleKhdd9kY+K6MnLUjat/jlVhO3qDtvVDGJbl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031

syzkaller found it could overflow math in the test infrastructure and
cause a WARN_ON by corrupting the reserved interval tree. This only
effects test kernels with CONFIG_IOMMUFD_TEST.

Validate the user input length in the test ioctl.

Fixes: f4b20bb34c83 ("iommufd: Add kernel support for testing iommufd")
Reported-by: syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69368129.a70a0220.38f243.008f.GAE@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 86446e1537949a..550ff36dec3a35 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1184,14 +1184,20 @@ static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
 				     unsigned int mockpt_id,
 				     unsigned long start, size_t length)
 {
+	unsigned long last;
 	struct iommufd_ioas *ioas;
 	int rc;
 
+	if (!length)
+		return -EINVAL;
+	if (check_add_overflow(start, length - 1, &last))
+		return -EOVERFLOW;
+
 	ioas = iommufd_get_ioas(ucmd->ictx, mockpt_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 	down_write(&ioas->iopt.iova_rwsem);
-	rc = iopt_reserve_iova(&ioas->iopt, start, start + length - 1, NULL);
+	rc = iopt_reserve_iova(&ioas->iopt, start, last, NULL);
 	up_write(&ioas->iopt.iova_rwsem);
 	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;

base-commit: b80fab281349f107a07e841eb412a86e2877ae88
-- 
2.43.0

