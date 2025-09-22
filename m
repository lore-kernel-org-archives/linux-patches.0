Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013007.outbound.protection.outlook.com [40.93.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082772DFF12;
	Mon, 22 Sep 2025 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758563340; cv=fail; b=EqgBX/bb07mWzza4e/SFAzdk7V3tsiOFPglq3zRkhdjYQLvZoc1HtqlybuwZH7Q+jCZXXgRukbYEheF+Lob584bsxhw21frwEoJ8hVMr7FjPQfgg0Zy6GhV81Avr9IjWJjSp2q7e5/ZVqz7HYAiHudFn7l+xzztAFp08o6s4k0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758563340; c=relaxed/simple;
	bh=Fh41peWSJUgy46tUUNIN4JC/bHcOzCjF7UKdOCJUxpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=McmO/1Xjj78MpdAXlRStme6CrpA3ryl/MrUz9QdDfpkb0Z5P+tPGvj7E7ZtjXmfc7H5mapP8EmvPIITmh8L4yu0+SjVqFVDyoEywjJUdVNTNCvad2cC6lXo1BHAugVeRz8/Wx0Cr4aYBADC8kxsQ7cHoQ6/Rl3H6vx1SEZpuUtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KEc2Khn3; arc=fail smtp.client-ip=40.93.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KEc2Khn3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fq/Pmw+u3aKubwxKUAUvUn+wg4IRsr+R8JNyaaZ0xHRIUcXA3DOehAZlipJPyouvQabp5TRSKJ3Hy3oPHJ9vX3e+fWpvtaS2yg/B3XBdWXyI2kK+6Z2CmHPBqayXodDcB6Kiv/zp9/25X/T+PkzrNvKIEI2jrd/6ua2//uJTD/A2VyzecRQWVDE/VMKySgJtLlXCC42BQb6ViKHjTj3cLNYKBpJTJuMQ2SamC5OLBLsswsJViynX4uftLxa7IlEf45XZ8jXnuE0XhU1RdwX3S7U5nEV1LGeXj3/7iUNvVZVxSKxrYSrw9IpN7J03q9tau/bxEEQ2mXDOzsqcW1BUgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJULuf0NuYSqirDol2+fHz2s1fEK1xnlVS3FG0x+rXg=;
 b=UYOmK/SlrgkL9I/UALc1y2BMrWFlBLNjsF8AQZY5UefwIdFTcRCzJb1eiLy60tHo/8bJ8S2mHpoxkqSkJfHPcOi4juEyADmNeA53BMKTr9Rk3VmL/tsjo+xSk2kPB1HmhWERz4AhKwR4RTzvloqoOToRy/24XqGIvXIqknlBv1hnQpGmd4VV+39sQWFdi9lG7Qpd+Cd9qa3XYQJP+Nfjam7BBIKrEokliD8okylY8RbdNKsb8o8056eu/X+SCamoB4i7VyBw3UOdwkVjF9/FMvzLDiWBK72HS7VA8401rtzkeo7rgHaapK1NI0YeJcGF/DtQeh9ByLhRnXInRx/mig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJULuf0NuYSqirDol2+fHz2s1fEK1xnlVS3FG0x+rXg=;
 b=KEc2Khn30zAdlqp+laWb4JAl/ckE+u9IisXKgasDPukmZ9oBzSfVLHQRGrQFkTJb5WC8UEbOkiBIhg05ZCUm42JFbkdvy6sFeokgikRAqxbOCesX3XMTz958kuy9K6FJt0sCQ7zm8A2aZSGnWfvqfUFbhFZzkByAtpXEl59RIupPbL6SsZTrKjgN8OgW8R3Xqbg1pnM3Bfa5yx8Hp9PNAXHwqATRgZNpCFIgYJMqr7jZrJ4/mLoX20iiD0/QUSJFgmwUGo88hjASEkH+6Vg0AOSUC68lnjS3J5Xg2o2y+h3qjPkzS3lLjvjooipyUhQJM4DqZUjZ2ubjx8sobKeFnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS7PR12MB9552.namprd12.prod.outlook.com (2603:10b6:8:24f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 17:48:56 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 17:48:56 +0000
Date: Mon, 22 Sep 2025 13:32:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 01/10] iommu/pages: Add support for a incoherent IOMMU
 page walker
Message-ID: <20250922163244.GH2132010@nvidia.com>
References: <1-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <debe1f51-e070-4efe-b88d-5111df9c9874@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <debe1f51-e070-4efe-b88d-5111df9c9874@linux.intel.com>
X-ClientProxiedBy: SA1P222CA0115.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::24) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS7PR12MB9552:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c781f31-50ab-423e-463d-08ddfa004d3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SXIl8PhXSL7ag71EbEZfezEZRrK1hxG0vRKaFIOj8LyATm4b19LWfM9Z7B83?=
 =?us-ascii?Q?W8R41mjcR48vMsw+fHvQVTbRG3C0gT5bxHiulD2b48WIs3UBziaq7wynQSfr?=
 =?us-ascii?Q?kYE0Of7OASOIViZF/QackpUfMGrMl2AFigSf30dohe0uCiqgnhXpC2IP0YYt?=
 =?us-ascii?Q?7QtHxO0dZ4hqY7wfznjO9mIFLjo2TugVQEEsc/TNHEkqEdQmbPSztuMOUPzw?=
 =?us-ascii?Q?kUUJojgUj6T2n8Ed31yQAIlt42jsbkLQQC/w8IAOnvIeXxxz+KRXpYU3M8rU?=
 =?us-ascii?Q?dPiRaCfcWUgRKh4slnBL/+o73PGp+hLuTupMcmEb+tZ6Wb+U4vOJa1DhQHAo?=
 =?us-ascii?Q?UXbUdrndEzEedtyhyIFW5VyB6rvlo10uYG8OCA674aUKbLj6zGnDm+qm+BB1?=
 =?us-ascii?Q?s5xONrjvv7YP9zdk2xG3mtsFjKaC8e7LU4M6Si01VjjAGm8Sg8HS9DX6RySs?=
 =?us-ascii?Q?Cs/feP6/UHKp+znw1MHZyL85t5bYAYwOp2HREnHI9VUghnLmaUNHU/W9GV80?=
 =?us-ascii?Q?T03EV4k9T9MCkgCqBY8KYu828uFlYzjS5O5SGPeF+DcPNqBmgBSwY33W2ghN?=
 =?us-ascii?Q?VDVjD+xEFLI2nHFsdCbKNFaYShOfVopjtDXRHdP9U+EaGDxGrvPAN1NPcQoJ?=
 =?us-ascii?Q?I7AR2K6NGGKcBXJHpmEUbRqy12i/QRbMqKhw5GDbvq/1TKxjstCm0S/neFPg?=
 =?us-ascii?Q?2Q6MsJWNp4VIWY7mHw3xUUQ6JGyB3vpPzXOSUhYhTIijh4MxYmDW0b8DIMBk?=
 =?us-ascii?Q?h2PPCcFCCq3cPdWUYHUCbLQhyLWveYxc/otb0LQC0pyXi4xA0/ACxIAWsP1W?=
 =?us-ascii?Q?v63OmB9vqEUxlsobG4grzQDvYtll6W3PmVwDrHmjc0kSSbm9JyaNgWdaE2kZ?=
 =?us-ascii?Q?fMoK2VLdDzTGjWkqqF6xXCJLhojBbN3YDZ2z3HTwDkGQjeBeJC4l9RvI6blR?=
 =?us-ascii?Q?mDIxYjppSumuMxmy5FKnTW7u/05NDfFZU4UHyIl/OhGCb9m5R062lrSzNdue?=
 =?us-ascii?Q?9wvTEj3vR8PBfVh3MPN8hhkZvJsr7A6b43KPmlYbiiMyorcRwLkffQpAsBEH?=
 =?us-ascii?Q?fWikbzA9vnmz92X6KpR5wieaTD+9TTjDDilw2uzcFG1He9O7IsB2VKizJwPD?=
 =?us-ascii?Q?Jm/ZfjxrA97vc/TOy2eHXmTs7TPHcyX3bPQTL+9HZNnCJwC0N0ufAaK8Bl2a?=
 =?us-ascii?Q?v44d41jZE3AuJC13/7jR7Nie4d3KWBks/ymtrZSWMw7mflvDQ/X6FgJIVrP+?=
 =?us-ascii?Q?avBQBI5uZBiiP3ZYuqW5rlOPXyXlrNLAWxvwjZMqJcVUki9bEMbCv053cAAm?=
 =?us-ascii?Q?5WJpjjb0SC5kWyCvHxU63OO5GHrab06rgyFQqz3qto3pr782kGBMMj4lrlgM?=
 =?us-ascii?Q?pOFoUTw98mNlqnPtzND4KBVBkNN2O5Hjr9edBoC8mxXUxwXwU/bsPnFaNH8Y?=
 =?us-ascii?Q?MUD/4XnkxWI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bmpqKLHNJEBOruUSYmQIOduocPyllt/8ub5/ZwR3ycwXG6KP60ufLC8dk8Ff?=
 =?us-ascii?Q?/ssQutf7NvH1q2C/vmWoifClfOlPlmJw7mKHUNGU0izoShPYS9j+A7bgxEXE?=
 =?us-ascii?Q?10axdMTZGhLt/D5wfro9amwhDdAFA/I+kT+DahgfUsCtDaGWu9ei58WnpZGS?=
 =?us-ascii?Q?VgDhHtcA47aif0LEDv765NTHHiYASn6sVEgwWeParQpPiRd7quprBMvREFLT?=
 =?us-ascii?Q?ApsYpdLtWYTCXvZHLl6UgAXjTbe7BXrc/FI079QTfy8McZBWSKSfBrs4XzR0?=
 =?us-ascii?Q?7YXYgpRW2ASA/Yz2H08d/Tt9aLdH09V/QLMksUNUQ+FN+DXACUM+NOKWUGNN?=
 =?us-ascii?Q?aStZKPCRzS8ijIOhmfM9n28etzL114tEwBxsLpfavhoADlYtCyKWVAC9zu6K?=
 =?us-ascii?Q?mZMibKPgHeAP01AB8McB3wVxQJR5F+gPLnewNvLVbpLOsw+w4Zy0qrmVCbIN?=
 =?us-ascii?Q?Zwo38g13vrGkkMES2IHLvhKJ3k+k4ImZ5n6sjpzkq/8n5KRnqjIIqeVDchlC?=
 =?us-ascii?Q?w2UVAcdvjSk9oUCNBt2CjPQX1CkLRMjE6LkH61b12ZpQaoO5/zJ9DXfoB/mB?=
 =?us-ascii?Q?96L4j4RljMTwt07KbbU2RCmDPHyCFEO/CdKI4f0NK5EGH6l1x0wpqcVrkdbR?=
 =?us-ascii?Q?auiFlejs2JhbsqTSwvgtPq51aDxiutHEYhG0mI4jCjD18VuYzzb/Qb3XIann?=
 =?us-ascii?Q?tVkxXn/Cgt5KjGvTxomZzdd2gNoaqYKrvnaeNL9J3Yq1602R3qypTg/QYTAA?=
 =?us-ascii?Q?cgkjGNrVN9OE2KEvhpI69YU7WttqovJ6i0HSLz/JkHYH5LcxvAL3CyJZq1X7?=
 =?us-ascii?Q?sd41RgfSZskXWSpeJkN7w5FI8vFVYrSJm5j/ijXASNqXz6YG4MqHUaZlXk8K?=
 =?us-ascii?Q?fnYsTMDoAS7D1pAIB4SJm93YK6KuksCVQi5N8yCE+qtJXLag0Osrr1T8kB+S?=
 =?us-ascii?Q?gqVch4lxjqATtuoZUsvK5SRbOV21+34TNnqoFasNFtlhQnbbtqUSBD9tslA/?=
 =?us-ascii?Q?JrvRyPUQqM3UqHqCispXJXrBOjCBVbRdrSfv3kCroqKRZkZySpI9QegVWNFi?=
 =?us-ascii?Q?VbK+ymNp48HALxh+Mh7ys0yrrXxkHSXD/9v4jpsO8m7iWTLCsIvkbMio+4Mu?=
 =?us-ascii?Q?hUtYEKknT/eDI+e1wC5nRWk9uTLa2dTDqKD427LeT39nJG2HOQR+ghWz4/SY?=
 =?us-ascii?Q?otWsJHc3JA0OYWZ/kwdWfIjt7+59pXPN4aCBjZ2Xsh/lu1CwUW1eoSPGWZRQ?=
 =?us-ascii?Q?k5udSkXF1PlK2777xqtr6oggU59YyHdlr6JV8nemGmAYixCd4BmWT9Y3HhCU?=
 =?us-ascii?Q?VY8UQRHvSiHQ5l0aKTV0k4TBpKYTFI2J5qM2ARAhF2bAx0opGgCyAI4vOrie?=
 =?us-ascii?Q?hPPDMn47V8b8uVXtDDhNLYq6pwyfuT9+8ep1BiViU8GDnZdrIAmaMANOk8mZ?=
 =?us-ascii?Q?p5Y9aHd8CxleeQ5ZXWIfXr0rw0BENP3Qnh8S08pkW6M8QYWsDwT94hWuDKt5?=
 =?us-ascii?Q?aaI5lYuq5nGVgfWSEd7WaD/2eA2RjqJ2aq8/sDLka06hlcacucXJfRXBDbzS?=
 =?us-ascii?Q?9JRqf9kNDUy4yP9pURJwTl7GwMnJDp/NqGUHcC8x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c781f31-50ab-423e-463d-08ddfa004d3f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 17:48:56.2363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4CYjAEZH4x6dtaGEoQBJ20vS8CAyzupMdJuN/Ql6Q9e+9+veabCsDqQ+yYxJgpD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9552

On Sun, Sep 21, 2025 at 05:54:01PM +0800, Baolu Lu wrote:
> On 8/27/2025 1:26 AM, Jason Gunthorpe wrote:
> > Some IOMMU HW cannot snoop the CPU cache when it walks the IO page tables.
> > The CPU is required to flush the cache to make changes visible to the HW.
> > 
> nit: how about make the subject like this,
> 
> iommu/pages: Add support for incoherent IOMMU page walkers

Yep

Thanks,
Jason
