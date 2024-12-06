Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B9F29A2;
	Fri,  6 Dec 2024 00:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444030; cv=fail; b=u0Z7H9BOOk6mz/b8CVoQR2GVM+pHTATRAQppq9zZgdePOF1FnFkobvEKzINPrWActygETMthQQ6+Fi9JLRJylrJuSkiQe7xMkpe8RHw3o4mXeUq/syoHdkz9h4jLeEDv5KlV6HcqbyZF/NBdQHv1Mmn4653448LiBDr15su464k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444030; c=relaxed/simple;
	bh=ykI3RGHLA0/uzw0jQnYmzVw9o2mjAZEWpoA7LhyRfdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hAr21Vdj67BtNkmvqPlcsz4tQZRPwdrFCUBA2+wwvyXhksMQ288mjoWv3FNhtDP8A/CP7v8VOSkDKqQGfkAe1XBctrP0oNAI/Hu6dnJgMFXcaRsNhWoTCOdH0L8aZRxuT5jg994n+8y3PvJYQubAT1AYntsmj74IxWqBllcfT5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j9WBOjac; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j9WBOjac"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BcJOrbp4EPrCU9jEdE1vuvz2gWFfnuyx+StpwRUo5Tamix0CbQfbJiKBrnk5oWXoN8apQIe16MDd3nKbyjxin/WCgYI9Po34qfkN0twKNC+UkSJGthK2iY/LDb28yyMLFCEWips9zlMjDT7WGE8qbF8JVnbqwg/A+L9+avmjBzmGlQL/M+/P29/9txhtEb8aW3hyAIoaP8iX9JECwXAwNglPbZnaG8GpwiAFtg5C8KBCOsonKpW49NporPEIkPR4kXVD4I6NEZuhzmDXvyA1ZtUO1SvSoLSRa+pUGPun7Y89VBbOD5ppZrwyJSFF7v79JQVeHykAhvWSCgPP4oQpfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+KzuvBDYVJ7+5pXxkEO57o+NSzoIKixg3dpiW9IMYU=;
 b=gpL7z1PLgVPktc7fMThC2imnzALqZDqnfkpYW+xrWZxa4ijR/6d1+OxO6yaDNwfLVBFi+mCj7PJ51fCL+NjEZ3hkkX16KY2Dh9K/rauWqIVkEbZPbZXXBok+2zA8pvmEMv6MugI1Yv80fcDJYBV2urMi9QMAIrMiOnt3jIxUrc9DrogGc6m5hMMc6ImWVWb7X75laR4IxrufWRwxln5ZfaZPrKBMvy8hbcYEMlUugfF7206IRnguSpPlop5/Hr0kB6GcOxYPU/lcUrP5zj+ePIxxHehXBbf/18mi2iWP2LsEFR1xSamotYYtJNx2u1FNDK2ldDFLFD5vGWqYbHfGOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+KzuvBDYVJ7+5pXxkEO57o+NSzoIKixg3dpiW9IMYU=;
 b=j9WBOjacER4RtD0uz0tu4zAXzXP1YjII9P99t6wUh+S2+NHqEJIdOHeOZnaZn67Qc2dmuDSlDz9RTFRgVdmFiWAqqqg51IqheyZ3h1jiwod0mst+AtI11om7F2wLMSaI1Rc8iiKId5Thbd+XQ9X/06+VPyLKSUZNtP3B+HJIFvpUnJ5aVw0Tj4SVYdk4cq8jni3yqa2e2MtQEV8bTP3UuMUL0kEPzAkVUtXnDy2gjR7/p/81cbqq1j0voJz3CbTlOuUNADsan8DUtdGDqLgLV9Iz9Oos1Pt8bfCL/YErnWn2dPOH0/bKoxIS3W6sofnIXmkwQp0H3/4Bf+9HX/kmTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB7496.namprd12.prod.outlook.com (2603:10b6:208:418::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Fri, 6 Dec
 2024 00:13:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:13:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH rc 1/2] iommu/amd: Put list_add/del(dev_data) back under the domain->lock
Date: Thu,  5 Dec 2024 20:13:41 -0400
Message-ID: <1-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:208:91::37) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d9074f4-204d-4101-ed6b-08dd158ad80e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1dM3EhiECnSq4pmcAqt/xd9SgfRb6QBpBLoOQiLjBSvY3hOk6LgFj0ebYUGX?=
 =?us-ascii?Q?owkkhd0BpWygsA3Xv9m90oDZE79/mb6GzRtN4VP/HO7u+gNjPakh+s7N45mw?=
 =?us-ascii?Q?QmKedOK0NIxszAR0r5Y84USfzFEtX9e5yPeiE5bNBmfU22Ru/2wp42lz1B1O?=
 =?us-ascii?Q?IAXWi7LfwZnqK+WXi3luEOm0rs8fbIm5Udy+jJkcflTR7R8aFXYpTL+uwrGY?=
 =?us-ascii?Q?nAzSEuFy5FR3+jOnoF4YsPk+Qm459J93aCv/lNR1DTpnX5VwBJ2uLh1fjnS6?=
 =?us-ascii?Q?BAUaqUnEXcWzNU16soD+aF08efgIkT4JPrbPVRCaICR7dYrwnLc0ddOADLSm?=
 =?us-ascii?Q?AXi/t+01xDg4lFvglQ2zOiznNZrigbTTujZafpitVhLJEKRfFHvlLlxgIqPC?=
 =?us-ascii?Q?sbQbVaE546QGQrAC8KkrtJEomMHJWL5NT13dBhxOGgnUZOaK2v3tleB67nmH?=
 =?us-ascii?Q?Cvcj85IRzKRGdHuTqa9/6o4tsufVaZ9PA5PWQFWcR7573o8TSxGYKfi9VT6U?=
 =?us-ascii?Q?t30WDMG425I07OW8o3iS0yvs8wRDT7uxua6TJo8Q1ll/Vo06VdW8uQ/Kx9D8?=
 =?us-ascii?Q?h4yAEeB5M5Www1CD5MX+Y3erfwCKlaUP1WWgg+BZlwDPKORGxauSHUOYlDUV?=
 =?us-ascii?Q?MomvTspFsdfZplotVRPjfgXcesAoMPnYbiIm/Af5EF168Jo25Rfxp+nlLxph?=
 =?us-ascii?Q?DFw3Oln+4CvlNbhv4EPKnbcyFyiPXa0vHto3h/qy3mqU7Fr/MTk35u7MeuAV?=
 =?us-ascii?Q?lnfbhwm/p3J8pbLZOOF8A5OkL9UEOr5OaQ6FszS0QpX0Hb1FXAGGGcjSul09?=
 =?us-ascii?Q?o2LnhOE8VPrym1RoGxnKIrTKhUBp57k7L3lQ9zQ2OjapFHjqLhgzsLqqCi9N?=
 =?us-ascii?Q?5IOokm73cFr3zgSEzMsU+hQVGG5vcmelnX+IxiuldLnneahWyHZrUa0ijazP?=
 =?us-ascii?Q?bWH9N7SwIJcMzwRqGXiGMg7N39R6KnbsteVRQniYAJRGrk4ts4WG3V3xwGK0?=
 =?us-ascii?Q?sEQ/LzremJqnSRAWb0lXMN+7OYgMWgLo7L2ygM5diwO/LxCA2PIRoEZNu88o?=
 =?us-ascii?Q?t2Ma1xXCOxhp4mm/8xTfv3oKenzHLtMd31uxXCa0wa36l5X8hyI964XSrnK2?=
 =?us-ascii?Q?KHGCaGEOfvacN9IF6PAfB4Vn49nUf+gRwb8iaafGdvtbKQ5A3KX9klEZ7Ds1?=
 =?us-ascii?Q?olGju2RKw1raLLKWHlTJBXfAYv2Q7pPTal2qcsbRzf4Rj0WywoFdI/5Obzfq?=
 =?us-ascii?Q?bMrU9rBAIUoeNrSjVdA8bFhgSO2Pk6gatpLRjNdBFwOjyJODrAvyazilc+yv?=
 =?us-ascii?Q?dUP7JswgSDKGW4JVWASXdGG/i9vykr8ryMAP6cBKHF5CMA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ARLDL/Fy1p/Ibrc6ePkEoC6HDSmknztNfJgv+TNN+SjLdKBLTckcJAOsd8CM?=
 =?us-ascii?Q?AGNbp4G5Itkw/cZZS2l+HnfdeW0v+B+umoDLUFGhKFDmGQ9SPXHNatWnXkdV?=
 =?us-ascii?Q?Vyr9eSoypM4mFK/S3IUTofw5VWjhXSdlx7OR6/4zVeX/xxcBoKqWGVdhVmfo?=
 =?us-ascii?Q?8w8M7+cs5j7RPA7pmTLGRvDIg0WymhE5mULXVJ3jy6IfzRLfQMcmpTAkomhA?=
 =?us-ascii?Q?koaZ3/APYTqdzWrzWgOIvXCadbQBQu4h6PJQdTODyEcUNHTHbbTXSMLznr84?=
 =?us-ascii?Q?/ro0pjmgblPv+MKxNv1lZHyVe4FNArOmWl9DP1wR4P4mr4xwMMNcBb+MJXvg?=
 =?us-ascii?Q?kmWfI1+zcnsDCTWBX8xyKQb3GKCH736uhVeqAmfJc/FTNGZRKDW6iCwgfvLY?=
 =?us-ascii?Q?Suvp2mrviW975cqb+q6qjeK3BGzoEytu+lMV3x0I3CfVdmFmaoLdLSGEc1n4?=
 =?us-ascii?Q?bw2LKP5biz5Ji4TKNUqEVzYgP5ExHU50ERI1DFIYospK5YxQcb8uHWbXL63/?=
 =?us-ascii?Q?qFgfrWzstBg6ib/CgvBCrXNfWt+yBH7fq43YcGpzEb+gs5wqfcCEgveIahoc?=
 =?us-ascii?Q?IYYBnBIv2bhVcZI6bZMWRem8wI54obLRkkcMDpbgF4YRCL/RRA+vF8nk18hA?=
 =?us-ascii?Q?yLPZxir4cdy1zFbEm7KWqLIrLc9VHrSrKGxoIWjCC7J0b2mxqA/id9QVPK2y?=
 =?us-ascii?Q?RQnWH5HmIQ0nSfyaNKHZrsO88+WwiHwdhYZ1w1xxgsxCmSA90+VtdL7u7+WH?=
 =?us-ascii?Q?WCJxNLAk93SWoaSXc5KSsGxb1IFvGyGMLVxCeMO0Ei6NjpetofSE03qR1A+j?=
 =?us-ascii?Q?YKJxktSNPU7bIOHNBl/D4WSD1Gf7HGf/032Yga6U7XN+Q+jZT4I0c1VP+WGY?=
 =?us-ascii?Q?IuJItk8VplLMIuOabD0ItUxXnHVKzP5wbb51bUuSlTHmRf/AaQ5L8O/BTNaf?=
 =?us-ascii?Q?dZ/69DDdpKjA574CWg33m3mGlibEHOahYYdjabOmzE5hlzNoUcKd7VQFCFw7?=
 =?us-ascii?Q?/gPpyDNvgV5Lq6E7cy64GPj4sa1FRG/bD8WcaLbVv+tn7EKS6tRB/CqL5vDl?=
 =?us-ascii?Q?4aIsOoZCd2rxCn83eovlgOPKP4G65+wjFXoo4a9XJF5qXB7Z869o+q3qDBsB?=
 =?us-ascii?Q?IxdP7iOPGLhkCJnDw8tEwg5r7qDLQomzk1HB6abeYb2TQCSmFR4NsvKjRiLk?=
 =?us-ascii?Q?FjVNw1Qm8FBn4xIqKBPYOu2xNOnXp40KUvOnfm14hkRRBCR71129ZAJWvxO0?=
 =?us-ascii?Q?n6wJmlJVBUovh8EJV9Eo/c3dP58bjTPiaV6vk+NbzkNLgDyNBI6YauzgBV5I?=
 =?us-ascii?Q?e56ujJC9eGyOll0gEn8ceAtMACWdTsJLwKUkG7QRvm71zzRJxlwCMRprchhE?=
 =?us-ascii?Q?jMMzMOLzvEaVMKo/rkX2W9vDdIJbpR1DD3J4/TMUKcc+IS/dYjZexIZcVtaN?=
 =?us-ascii?Q?7SwxiS22xVBDUNdbgL0GWPIw26czfxkJnBLkKah3e9XIifFaM0HrJcTNH1sj?=
 =?us-ascii?Q?JjKrKNVfpGRgShFppQE6FpM5so6Rm60CXKjdQNtNC7dEZVguFL2KJ09MxA/C?=
 =?us-ascii?Q?Zg78PojHl0Mpdwp14Is+7V9e0U7jsZOZvDvvy4SH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9074f4-204d-4101-ed6b-08dd158ad80e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:13:43.2756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WCZMDSCwqnXp+ouigoDFWlWvRsEEKq8E25lBoaF3KL4wGF5Eau/VFzl7ivbSuez
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7496

The list domain->dev_list is protected by the domain->lock spinlock.
Any iteration, addition or removal must be under the lock.

Move the list_del() up into the critical section. pdom_is_sva_capable(),
and destroy_gcr3_table() do not interact with the list element.

Wrap the list_add() in a lock, it would make more sense if this was under
the same critical section as adjusting the refcounts earlier, but that
requires more complications.

Fixes: d6b47dec3684 ("iommu/amd: Reduce domain lock scope in attach device path")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3f691e1fd22ce4..23a168e229b171 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2073,6 +2073,7 @@ static int attach_device(struct device *dev,
 	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	struct pci_dev *pdev;
+	unsigned long flags;
 	int ret = 0;
 
 	mutex_lock(&dev_data->mutex);
@@ -2113,7 +2114,9 @@ static int attach_device(struct device *dev,
 
 	/* Update data structures */
 	dev_data->domain = domain;
+	spin_lock_irqsave(&domain->lock, flags);
 	list_add(&dev_data->list, &domain->dev_list);
+	spin_unlock_irqrestore(&domain->lock, flags);
 
 	/* Update device table */
 	dev_update_dte(dev_data, true);
@@ -2160,6 +2163,7 @@ static void detach_device(struct device *dev)
 	/* Flush IOTLB and wait for the flushes to finish */
 	spin_lock_irqsave(&domain->lock, flags);
 	amd_iommu_domain_flush_all(domain);
+	list_del(&dev_data->list);
 	spin_unlock_irqrestore(&domain->lock, flags);
 
 	/* Clear GCR3 table */
@@ -2168,7 +2172,6 @@ static void detach_device(struct device *dev)
 
 	/* Update data structures */
 	dev_data->domain = NULL;
-	list_del(&dev_data->list);
 
 	/* decrease reference counters - needs to happen after the flushes */
 	pdom_detach_iommu(iommu, domain);
-- 
2.43.0

