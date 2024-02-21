Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1ED7BB11;
	Wed, 21 Feb 2024 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522432; cv=fail; b=Ab7Qwv5OTl6XMO53lSjRmbikhzp6SnbKsww9lYwvt33lg77WHN9velKJWCmqNU34SKiW8M1I6d6npkur5K4WWZP3McRcUlGBqu1TMcilVE1rXkOE8Y13H720yqF8ypIP8mFFc6rtxuvdePEEWXuPZRpVStMpN71XVqHUH+5xPrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522432; c=relaxed/simple;
	bh=JAsVnK+/dPbrThnRjZuwbPflQSwQ6qvlpyPkcKR/Gtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tuZchyA53IhcvugXBWEmSVjPZnLB7e112Vpt6nF2av7IU/u0dyaOUSv3v6NCkcwc14uHPUgA7wT+1nw89xcGWCWBFCwdI/FKxJweoWHlnoIl5zu+ZhM18ZhOa7pq3JGcAY1aiMFU43nHW6AiJPOvLmN+BQ3DACndKUPajfl45QA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i5uBHCxZ; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i5uBHCxZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsLSS6mu4synHkzMbOTJzGxcnbpUPiSsFchruMUrFjjj14NLMcGd2k97c9qIpn2NkM7wOhbDSRE2UsndajX8kUZBSjA3B6A49Qq1ayZT/6zlkDoRQkwO2iAbDD+7GRYyEpOH9gop4C4JabVkSz5TbG9KpJWKgbvG1IEEv03s0FUzfBSOZegJ4WpKcJKv/uA8/gTnJmVaOuyl/CE8KGkkYVUpI3kiFTQ8FxUZc52ABXl8GclBM4iwAjnHksK8YmDv74wEOmCzIK7qSp9hm7gSo2KKk4zEE2TA7BFclSUc7yqh0xtjs03/70SycUWPOZc1Ed4YGYwDfXOu5I7QGu5RGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IdVcfGhVpLmCWBvLmBjJEuTcZ8pvR7ETr5qbllc0tFQ=;
 b=Yu9WQVhYNo37fAV4aoX5GWliWEiMz2ER3WLHZIOGtQfGdND8jxaEqJHWwlrfKyAtiQDYAP/KrPbhu9oY7lPYEqmy6DxtQ2VZTz474rQmoJsWbdJXUfLw5sqG3uOCwyH5JTC179oCk46ROhDhMkMUnxY+ODxfb4FEamvz7mJaCC2rrpNmveYFpQ12vUY3SaYrHxScfWIomRfNHLVDxSaN4aR22hoVJnvqBc0Aiw5BYpHwR9kP/h36+Gz52keWwa64TK6V9tPgNY+p83SN4vn3jvOATZQIElpXTfSkHeItlqsBhWsXcoDfBMYYXKSc1eGauSkrpxfSQX+b/Ktzp9DjFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdVcfGhVpLmCWBvLmBjJEuTcZ8pvR7ETr5qbllc0tFQ=;
 b=i5uBHCxZogjYJTqHNrQGG52CmAl7RWJiPI4TrC+WgYMwrspVqtArT+qKqx0rAvIlNtP5skWHIqFWMUDbRnywL88xLS/so3+rW9O5UPxKHv7OHPTlaE1rwivKFJB0BGwHnUIR7XxrJMVmSdDTyOEfljBHOQA/pxHhoF+E4LPd9q6mb0ruEqQ005Z6f6ItWsvTwFbjiHPsyjYCZXAB0CbXhY46yi/EgtNRa4XMcDRQZu56OkODlYqmGYtbkjqYPQaL7r0bCxn1aW1v/8Z2p+QuXSJRl0eYVVEG/2csoU6hDUgPZP5hzH+R8b9N5AixbwBtmX4oqW/w2bmvECzC534mcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB6013.namprd12.prod.outlook.com (2603:10b6:408:171::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Wed, 21 Feb
 2024 13:33:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Wed, 21 Feb 2024
 13:33:48 +0000
Date: Wed, 21 Feb 2024 09:33:47 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH] iommufd: Reject non-zero data_type if no data_len is
 provided
Message-ID: <20240221133347.GT13330@nvidia.com>
References: <0-v1-9b1ea6869554+110c60-iommufd_ck_data_type_jgg@nvidia.com>
 <BN9PR11MB5276C5091996B828101A78AF8C572@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C5091996B828101A78AF8C572@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL6PEPF0001640F.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: 85db8959-d270-463f-2032-08dc32e1bbfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TBANI/CFS0AvHvkNUvWBRTCNAi0Srk8eKHF807u569kjfKGIQkhIiW545HJd0MrIoykkx7Xae/NzJcVgBNUFPbrRDwQmIRfOoRyUS1m1RMx1VyQ5HhD3tF5pTxpTxQoHpZiKG7jlDAKGUk2pNR+4Atf4/vmwszg1n+OKxxi3/IhtjFTV9qmHLwuvjeqUfB5fncSXykrMPXFANQlBwiHxrNM1ceUXjcHPbnXFAw+Hac/W3eRIROzBm1bkzApO7QYJlfSI9T08+VgTwyYwQ+C0ywDKGvnkvgSjerX1VZeQErK5PFAnDJhu7YVQedw5YI8BcTGCqF3h4X+vU0fRayumGx6PROyPIaUAKE4qBvUfKPFu/IYJtLI8bUkNu+VM9vGd/7rSCO2e2ZfYJn4/iZuJVR7fxuuLYolBQs1S581DPiM3As6fD75SbonrhF7T7CIuZ5YTnBToc/q+Cj4CyWvrrwS7HwtyMBOKNn7w7U2O30inVvq1BS1sKBXR+eGGHbWBg84tdhPMI92EJUDHv5aS+2iYuEnb1l3ZV4iUjtuE7mA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kbv5Atf0b9JUEptuhUV+qVgrGDzvV68eEjbdhvlkGYC6bVh3yRndO0LBlwvT?=
 =?us-ascii?Q?tJoCXyVfkwBCM4deVtQ+y32hyoJMSog1oxuCRXbYORzpo/Uk7rahdEijXZyV?=
 =?us-ascii?Q?VmmUwEHtDLH9a5ZFJYQy1NH4wPnm9SF6nU4cf14EQ/nXPse4r1h9mJ9wu4tJ?=
 =?us-ascii?Q?/OqOukmo254jgn09OIafTaCgP8a1m1TnbI27rTC1cHtcBJsjdG22grbtE1ke?=
 =?us-ascii?Q?IEF4ko8TXpYXb6pUhv/lEZSnziRsrdFXvOPaEoWGmnC5UilLG9teslNruiX7?=
 =?us-ascii?Q?5seSW+tcililxSf0/seEN48PV1d5D6kdvXem2dlN3QxoTrUW0clNHXEfKRhK?=
 =?us-ascii?Q?QTokNKlYQMRe0wuGoY/s/H8MWGi8+bEzGLOfzlRZysNKHd82t/fONYyVW2sB?=
 =?us-ascii?Q?D7x9fOvToN0lRGYz7EnpOsJT0pOiezVLRZtQz9cjiNZRvsdCC+hgtLA9NELh?=
 =?us-ascii?Q?ry6jT8jC9GToOzGTH2ZOYsTabuPaZwEujW37T//0rs54OWyj1bviq7Lf5F99?=
 =?us-ascii?Q?nnN5WMXk7iVgLGJ5cJ/2kiU9H/8DIWD5sXLRjoMPLCIXyOfthPZyKaJkcio8?=
 =?us-ascii?Q?ffRDYCQYg5VpaefdW2pENJt4/QRWBcW+iyA2IWKIxoYgcA17G2L10CN58jJF?=
 =?us-ascii?Q?5TxI3TMqXOvL/618XC57lEoV2ZXmEqIyAErM2nyldG/Rkd3XKUa/XZamgpV5?=
 =?us-ascii?Q?pWTxjIRNkqgSOa6FI53lnrcwC/IqyMSP7hqF+RbIycNZHi0ITBgPzz5CooE+?=
 =?us-ascii?Q?7iwlOtNQQBWeFTWFMcfh5+4EyOwxU+SrcVCgARI19vANdNMrvHN+quuNYyau?=
 =?us-ascii?Q?QP/GGcpEpVgqk52IuUeSjRCuDg8O93N7RgzN9P0qLfFITmwc3wbLHQkQ2ii/?=
 =?us-ascii?Q?dXMbQNtLLcqqY4NkM75XWYSUWcV3cq3WI+mwLDIOGT1NHajioqKf+IOqe1ZO?=
 =?us-ascii?Q?X/bJxIzpt3BuHmTURuxGzRYaqvLWNTTKwQzEPt4HTSHDwKLDpNEBW/gJW0gR?=
 =?us-ascii?Q?MWWANHzMMdMPvaHjTKobS7pERXScugjs3tAJZBxQzaErjTW9ovMm3Vz0iUHo?=
 =?us-ascii?Q?zafEonfReZkDWtSqWoMJoOm3brSU0W8BgTqMqUQWHiIzSbCQEspzRJlEAsuT?=
 =?us-ascii?Q?4CPwE9DxeVy8vLLudsYUH/bsSaZJBy7YbNAixqh9moKcGD9MushOHUJtBIJR?=
 =?us-ascii?Q?BCTL6lx6b/Y6kkKiegD6/T+g63hU5G8LMW7E7H3Syqu97bEj6jDpqnlDT1sn?=
 =?us-ascii?Q?K1bQrw/tI6+yhmT+Ii9G536p93sR736uRjdkPpeYe5XU4+Kk6qh+DdC+b0zi?=
 =?us-ascii?Q?URHyGyCWg16xZtcTiQ9VWhc4krbNRGya9HpRrnKihq3K804lKsj2hjWuoCwR?=
 =?us-ascii?Q?m10OlCwSQXbvgYGxz+8uXRLV86k0gzoJ1SIhyseTS8tiJkfXrM09mKX/krqX?=
 =?us-ascii?Q?skIctSly1Ct01xu+87Y5A+r4tvYuCB+kE1CCwG7iS14J1i34ZZDloq55xdGe?=
 =?us-ascii?Q?CN/EgV5PoeeXvnyG3BahnsbJvMJK4q9JHTur5gGUjgYxXwJq5crbhyL0SVHK?=
 =?us-ascii?Q?F27SAZgGBKTVFC/+0eXUKg7fDSyGdTM1epW9g2cA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85db8959-d270-463f-2032-08dc32e1bbfc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 13:33:48.3561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDe7mnoqSRD8TSQofdOUz+jwzMfyr7i9joeyBo1ummFNqjcxVbvIbHKGmpHlfE/g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6013

On Wed, Feb 21, 2024 at 07:11:45AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, February 21, 2024 2:44 AM
> > 
> > Since the current design doesn't forward the data_type to the driver to
> > check unless there is a data_len/uptr for a driver specific struct we
> > should check and ensure that data_type is 0 if data_len is 0. Otherwise
> > any value is permitted.
> > 
> > Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Applied to for-rc

Jason
