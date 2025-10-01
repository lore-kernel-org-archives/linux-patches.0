Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012025.outbound.protection.outlook.com [40.107.209.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8C288AD;
	Wed,  1 Oct 2025 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759335927; cv=fail; b=FPY9effbBWnoeRT3YOQMWr0thoHi4Yz9B7hswulWeqYs4Pig+bWUg3kTST74mXq2fN6pnH9d38BYcavxfWNsYsnbxwYPqmmdeCs9nhxvAY39P8ge8lF66ndjgtnabTpoaJtO8OvymqNbQSJr7pz6e5h6atFKORfsh4AlmGqnsl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759335927; c=relaxed/simple;
	bh=pJ0ZnZEfGPBije5uz6V/lmQkr/KVgG+fOlTNJu+wuWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ld13dtZ38BhryI4Os65nwHCLyy39LOFpPnTNU/I5UFAwj1pDo5vqFJIDsZQjai6DWW4CEsKi4Ll3yPMKwSG3PxmbnNGqAUv3T/SVvuvWthVPcOQtHtdzHgJqYk5DxnbPTkImX+jBNMNxM2JXuXSeNiPuSd4sY0Z1i3da3sT9o5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WXMa0w7K; arc=fail smtp.client-ip=40.107.209.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WXMa0w7K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=blPSu7jz3m6h4/RBlt9Ix5PpXSPT+ffflGwdQS15Q9DxwHHmpcVgzSZTY6z56wRp2jUgOo5ylSQz1n/4DAQM9Noc6VDAq7cddtfdCEah76XKWv/jfsTSDzaXcAJVv3Mg+e5muhNAHtGjp4DgQAatCW/aR7zs+viqUjuSOVKF4WRKyyVBnjEkBcEuZFKgVdo5I6gF1tuyyYxewVfIWKVEiHe3zs5sAwGu3nDTj2UPzaFhWzq1tfTHyJfuHhpBHVcQ2OGILEXkUEiYdF6zafhgD5UEA4FB44XR8GAYGWlDE9r6yQocvGhvuRv5nYe6gVTUPpJbJl9BVrPKo/zbXm999w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mShf1bofbojjHGILbLD23PeCItzH7wyvOkGJMIGD2Gc=;
 b=QnnDlXxNU4C/QzP9vShJWDeiddFl7SOgIR/Kri6JKD8PCLRwF/tUFxNz+pQiDXbqje4NoYRcPVgCO/4zn47PSOFxxWpj1pThCCOyrlGnp+BCFnc17CZINN5INkGpswuDYAddZFTigqykjoOSfEKYvvt3ka6L1GRp2AUEe3tQkbboupWXKxQ2T0jDhqlbbdpNpiDJcR9hiZ5Dk00QrmWHZHaka/LgVzxNcEaRPXRa3YPBx3or4f9WGPh//bmkl9HMlSMLAbWtlEU2KbKnTnihict0sfa+AfcMy2nS45wdtBsYZ8OEtYsx7qzxl+ZPyBo/YuGwftIYyI8/jDiv4AL+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mShf1bofbojjHGILbLD23PeCItzH7wyvOkGJMIGD2Gc=;
 b=WXMa0w7Kz6ItS+sYXaN3J7SmVu1+LXa3TE5V0hN5CIcrm0njQa8jdN13O7X3zdqsNrUW13SUrTT+SVGxOeJUb+4D/HV5q9fqmbyPJUUih7c2B8XvFWegJ7eQ9DnT7N/wZE6S7dC6aebY8+mKYfBBQTNb1ikzygqZlQyepxklM/X9S+XpTV39HrvW1/CfGTSzWyAFBNBgJV/E1c7IRDOLTxspEOTtV63VXY/+gF/2S+es71QTl8NWHaljLqD5LcG2iPfmkt31a47mAzIIiFlCGBPyu7DU4rSjyFtkhy2hQ6lIyIMMNB+vMmBbk2ByPk8RPyoUjkbwnm19Nh7AqGTPiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CY8PR12MB8243.namprd12.prod.outlook.com (2603:10b6:930:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 16:25:21 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 16:25:18 +0000
Date: Wed, 1 Oct 2025 13:25:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <20251001162516.GE3024065@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
 <20250924214215.GR2617119@nvidia.com>
 <aNrxjkUEEUzKU+za@Asurada-Nvidia>
 <20250930121200.GG2942991@nvidia.com>
 <aNw7UVaktL6/05b8@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNw7UVaktL6/05b8@Asurada-Nvidia>
X-ClientProxiedBy: BL1PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::11) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CY8PR12MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: 896aae0b-6eeb-40f6-3bb4-08de01071c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G6omJdWDKJz23SwbpYQMUKCi3m6KMeikQn6+Gx6uy7wOjlrV87rpt3q1AnMs?=
 =?us-ascii?Q?YmLUKcGZx7DOg6epirmd9ysFhqpHCeoToN1WLJEbWBIYp6D1l7EYYzs2HsYC?=
 =?us-ascii?Q?sTcPaVnV0eFpWXgl5yS0M0Q3hbWhzC+B6qjqkYNWW/4e1FVe2y4zpKZ9raFl?=
 =?us-ascii?Q?qn7PcwLV9Mpf4W489WObYgM/EnwDNGTMpLi4T7zOZeisimR6FLfkMLK0r71A?=
 =?us-ascii?Q?w9ktxglXheGtXmZV3lY+Kx69+4zaazLqukmegget0AwZRNN0LSZqQnCGiTXf?=
 =?us-ascii?Q?QXHYQIaY9ft7AmkK8y/nsnLqWtHgn2O9CwA3Cm90mg5c899z0jAMeb2efOPj?=
 =?us-ascii?Q?eNovEFAbJQYR3UGTq0+kYStRAJ8qm+LMkXVRd/uG/bIBo9wbjm5XrGjrFfvn?=
 =?us-ascii?Q?LMrPDoaq2vpIdwDiGDLu+CxRZwiBS2hHKP7nU8S0fPfoq6sBoN7/oYahLaOm?=
 =?us-ascii?Q?sYPF8AIVYJTowHECs77sQNN196GF423LTu4Jn1WzwUHC3sXjUrtsQVKNLq9W?=
 =?us-ascii?Q?PNZxFbaU8SrrdMVxwxsgLZ0DBkUdzm+k4NuTWx+tM2U5WbyjQ+ZMQODMjGa+?=
 =?us-ascii?Q?rmHcg19CUBIXKzXzxmfoAfAmCsG0qEdalDEEtQiL+boVuL2Ne2e+mNxFwa5/?=
 =?us-ascii?Q?EuXSZRFfkXvQ68NDcwnQttoVEx0wwGvq186/Hn3NI+KNiZ8DWTD2oL2x+U+0?=
 =?us-ascii?Q?Jjb/K93zoz6DMHcLdwagZoSkhBX+jqPVuzMjmFjkVy5Zg7OcnDpTUOhNz1CF?=
 =?us-ascii?Q?ot/oMd2L+7tPSFjEhptqJkgitd3uRNFp0ubuQJN7J/ZMfMlStVCBLGQL4lYO?=
 =?us-ascii?Q?Hrdo8i568vjm4ii4+Cy7jA6jalTSPSAZLK2os/PXdlOHlofwavzsrBTjpIJF?=
 =?us-ascii?Q?P6lWqlG2SaTpOOquzSE4o9OmjtA1tvdIkaZ4b9uiCic++EHoyozYqJegyqRJ?=
 =?us-ascii?Q?dWR5MNXQwKUZSmnYvkWzs+ZMERoz3aNg8MJYDclsSFaejKTWvF2FhUgWPG/b?=
 =?us-ascii?Q?//1BziLCbQp7UITeSmP1kfSfZcEUHja/kTP8ASb0Bcu8GNDyL1kL743244Sl?=
 =?us-ascii?Q?SRywQhbOg7c3TUc/bTg+ZNQDDCJ1iSsyJVEuDKRzFLSzTzJoTNJnte46w8Jt?=
 =?us-ascii?Q?lTWKiMcpH+uEce5qg/jEb+uHVofsCZwmHFYd6Zl481BWzGA8qycNdzT9sJgG?=
 =?us-ascii?Q?XZu2VDTZi46rMCtvIpsMX32C+qbTbSRc6mrpxmt8E6MI6d2VHtXVh/CNcCVT?=
 =?us-ascii?Q?x98kp1liYc28Utundfcc9nbK7+rvr3/MLvalnNIBKUrgEsXzz++tTmdguuGv?=
 =?us-ascii?Q?U965FOwDDc9bDrDQNFG9OoWQv1rpWZ77sSCUDXV8JymhdpKTrvqJ74CdNet1?=
 =?us-ascii?Q?KsdZ2tdKUDKazyuM6uJrRg5odHzNF5slrvE2o+W5jc8+JxMM2zVGo0suDdiP?=
 =?us-ascii?Q?cuYyAwD2o0QtHBiBXdNXb74Xvx2L/jhh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S7Z7oGroLwwVU5a+GS4NxWjcKlzd+tTVJU6jRtoCatMan/tPCxMu/Ggulahm?=
 =?us-ascii?Q?UDODCb4R6eWApifos9Jm7LkZxTf393j7g/jXfunCklpq1C2RTZSlIscjlaWj?=
 =?us-ascii?Q?+W+baHCurtjN7bMd6+aw3aBIFq1wM4Xp69lpRciSPdonDrWX5H2vXKUquSSD?=
 =?us-ascii?Q?Y9DrujSh3owK9b/zDHTH2UHEMHrcycq+ggHvDIu7cGYNOgXOQhFXN0ijKUVI?=
 =?us-ascii?Q?CZIPPxEPirfznVrdTg802g1Ulkl+nH+o7b81WdY6RowwM7amLPnpSXOF+QiH?=
 =?us-ascii?Q?DDu/JggSgS7wkshNTwxQjc0YYBIKXKlKXMWN7YkO0TJJkyU2qrPcPWSCIg5Y?=
 =?us-ascii?Q?jvMC+h8ZP8VyaJLBKWLZRF6AjfX2c0TAmmvxmYBuybdu0tGkKHiPmigzvK3D?=
 =?us-ascii?Q?UnYi/GYWdlLI79aYNi20F2sAoTxpXvaVj3dEVrkKK7w3vbayLJPMNL0g/sgr?=
 =?us-ascii?Q?rWxCLt/59UuysPfYQYfxyjHpsg6btp9utDXb7E4hvUcGJHeZrOIQutjyp7O6?=
 =?us-ascii?Q?VejdrLxZSDqgNEqEIYzy9f9kdPeD0urT3Yaj+Ay11AEdm6+XRviOyfA0y6YR?=
 =?us-ascii?Q?Prh9iKLdoyzKc9hDFHwd8kI/4JGBlwr4bh8adWypyIaxFX4Z/WiUKrrgRIVa?=
 =?us-ascii?Q?AlfT+hNn4MX4KSwJuvYl+ATTK1zno/CEfOH/738Fj9OfjhpfsH3W5usLhtY+?=
 =?us-ascii?Q?/HneUDfzC5uWs8+7NAAhYo/HlwmxMyoR23AVtWFG4GU5cOs8YnAarsOlbrLc?=
 =?us-ascii?Q?RUUR28hW/FBRe/4qoNyfqFAMgmMaiTVJpNss6UQwd69aZoPyn3gFB/UagAwS?=
 =?us-ascii?Q?rB36AsK5Vzq/BeBQbWQr6umEx/lySHx87/L+ch+c5r0myW11f+//SAkKnhjR?=
 =?us-ascii?Q?ImNOGiDxCWyu9PmjfXhKhfmlJverKfJYUKaBm1k/69uYmGW+qeN2cicnkY3e?=
 =?us-ascii?Q?JNSWRc9MDenIIJqXqKTFDhq5CUknf8b6Opu5mc3f0cbPK7rVXcDFvc+B59SD?=
 =?us-ascii?Q?4iboqgp/MN4w4/xYbXJZNijltE/V9JGpw2xqFy1mtZRtzej5nn+5psmTLkxF?=
 =?us-ascii?Q?qdlEneUyECJBI7sYSOM/Rp6IRDdAKyHbZkF/Um/78xXlQclQaqHKVWSBGlIi?=
 =?us-ascii?Q?oaYQKlkP71hnLV5P7kBbnWti2+nYEjD3N3BB6gcz3DBSbecDhnfbLS0PnchN?=
 =?us-ascii?Q?GSH2rNJ+iz+VZ1Trsq7stN5ha9gX1wY8KXXafykEY3vE0IrTiAkC/rrP/nSx?=
 =?us-ascii?Q?xcfP3QLzZj5zlX2klZkv8v7afWrBFu72IxSs3+hUvZm7exFHuU2wEZZ0rRT0?=
 =?us-ascii?Q?1Ue4yuNashFdel2kvpQNopbxScFOz9PzBaKoJXdY2L82cQMPD752l+l6OO5a?=
 =?us-ascii?Q?KenUK0YZAdYAM8jnn+Da09OX7AR3+bjW8dLzWPiRTJuF/ZvgL9J+raGlNwen?=
 =?us-ascii?Q?6CGaMSZTO7ryx9jwF9+73w/Qx84aqElX/oJ8d0+55BZ0fHerz35DzgvV9iKS?=
 =?us-ascii?Q?+cPKUxSqdHA+NmYyBuR56/U6irqC2b9/K9ncaWjtFeZNMa5fc70+LqUZLA6O?=
 =?us-ascii?Q?rTm/h454NOpPuyIPi6sigVB7iJGq33/nbc3vWz/0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896aae0b-6eeb-40f6-3bb4-08de01071c26
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 16:25:18.4117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IggVzaa1FV3MnkCg9dSJrjj8UpJslf7O4Eye6jaAWWyTSQLSQC1aCOltXLbSqUvc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8243

On Tue, Sep 30, 2025 at 01:19:29PM -0700, Nicolin Chen wrote:
> I see a cleaner way of handling this is to update invs->num_invs
> inside arm_smmu_invs_unref():
> ----------------------------------------------------------------
> @@ -1209,6 +1216,13 @@ size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
>                         j++;
>                 }
>         }
> +
> +       /* The lock is required to fence concurrent ATS operations. */
> +       write_lock_irqsave(&invs->rwlock, flags);
> +       /* Trim the size by removing tailing trash entries */
> +       WRITE_ONCE(invs->num_invs, num_invs);
> +       write_unlock_irqrestore(&invs->rwlock, flags);

That seems Ok

It means the arm_smmu_invs_unref() becomes the fence that guarentees
the ATS is stopped for anything marked as trash.

Then the next steps can just be normal RCU and don't need rwlocking.

Jason
