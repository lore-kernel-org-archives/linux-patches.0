Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6788F33C518;
	Mon, 26 Jan 2026 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769436857; cv=fail; b=h0UmFez4bWQvJqDe+yBXwO7xyCj7DIplNl0VjIVyI/GSAHxys36Szsug6w/wJsAbfrqLoDxaueXiKf5LY2NUoADzB+KDOxacipSPpXjzsUQEcP+dBbYZPbRGij6HcpYdhz46R8WvhlhM43vcYBnb9qQb3MGBspvuQr0h9PnKNAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769436857; c=relaxed/simple;
	bh=EfesN/rBo+ih2JQ4dWpP9ENWezfBSPl5F31RY52TDas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xcx1ok3VGqf9PvXH/Qw4v0tb0wEMAWBDa/UaUq4ivTY+0+IdpDBmHgwPtiTNy4WypAgj498M1UXD8L4egb6usMKzOgJE2QpKtLMuXBxQWzM3VtjyWDIU8v+8s+6HViYX5Sa2ny0cu2ctRvyesA0jiMC3ZHyO8ql5a0MgGjGjKCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jldx5Fcb; arc=fail smtp.client-ip=52.101.52.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jldx5Fcb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqNQ7IqS4v/8mjTZF+Kg90R8AgeWHT9J7rYs/az1CgCuCD3x4tXBTki0YWCyKL3pYZC11rpnV9UhhYkaC03/UrG/SYHjAUSwzb0v0A0qQMTLDZWT0wO4tz8cXcND0c7rVAIFeUk0kevWxgg5W7Q7V0QbBFMSyEDUy94xvPMbS8DGZCDQlTm4XbAbMvU7o9FhgoSmB5Z0qyAZI4aFQEofPORHDta2LVtp++wI2VLzrV8zAvQmRXKfqkIY0tc1W2wU8t/M78askl5FtLkju1mxwAtAo+ahzgxJCeQmNn2WkL4tjvXa07UI4JajZ4BX2pvw4g7Z4mtifbuGdlvg8oB2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LM/MqqmEXro0fa6B6RRGQTor24gQMMThBLGRvlkfWg=;
 b=aT7nG+WTf3swJDaECDe3MMGOWn3/ec2gaeN+Wx6C3Lt2Pvs4M5AmJqrRjmtS/guJigJVc51kBmN+bOJsLxFw/iIbDNXacwIx8KDNAe88xog0tVXpwPR4jdrL8j/WEykc0y1SZpfWjFCk4gFVB6P49MdYEw/CvU2BvXnkLyAzLfmbtT9pvVpj93HCgBQHgqMWAhoh4XU22z9Au5aPqWiMOjflOxE/EVH+Myi1kv05LyBPJVPH5l0taWpH0VgvM53evq1kyuepoicDyD5NLZ7oNMukpA0BNM4IEcre6STU81QCyVWmV2rQgYRNXEpALa8yFokCRDyiDAV2xVR1cdP2yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LM/MqqmEXro0fa6B6RRGQTor24gQMMThBLGRvlkfWg=;
 b=jldx5Fcbd3vnlMpG0AelvLl5SS9TZ7HChEdVCyWpduUW1I2GxVUV4t8Lfg1HD6S8m6vfDzt/dzpDgCKJPeCL21CW/Dcl74DeCYIKytz0koErMziFqb6K02RAkdQO1NPBu6eZ2qjAm14hnQuBmHhHmlIx8LLTVo3DA5hy7b/PsqkuteErI4Q+vN72pD0/cRUqXMTH/oaEH2Rwwl7l623t+XVXBRI9+nzi4IyVKN9Dpe+ffHeby09siCuCWLTdDIgX3C1UruGenwArJbziIJqOVJqITNP4Qgkhwwk53PY2CjIM/ECWonCFUCrXLdswfvKsGnrCr0UNdzRTHmRu8cFIig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4371.namprd12.prod.outlook.com (2603:10b6:5:2a3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 14:14:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 14:14:12 +0000
Date: Mon, 26 Jan 2026 10:14:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"Brost, Matthew" <matthew.brost@intel.com>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	"Dugast, Francois" <francois.dugast@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Message-ID: <20260126141411.GJ1134360@nvidia.com>
References: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
 <BN9PR11MB527689AC9554360C2339E7598C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527689AC9554360C2339E7598C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:208:23c::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: b32f38af-139f-472a-a676-08de5ce52dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EnDdl9fpE39C2NobqVDFf+VAG0V8tV2q/nhQWTiDO/r5AHIRzGQCHYIcrFDB?=
 =?us-ascii?Q?rJtRlM7Uf78MfbmYBH31OFlqoEw41O4zPW5a6/EC2ygDRvIAcTv5hYxS3BsD?=
 =?us-ascii?Q?wmQSlPJjJK4yA/tLgUT3CUbLRMvGK25NuJNqHqW19/8Ls0qRc9BtzIoxwzlO?=
 =?us-ascii?Q?enR5E8ZTrfTFKkb4xZE+Dayfal7JdoiuN//2FlxONNt9Yw94xQXDZckiykx4?=
 =?us-ascii?Q?9ZlV7nY9VN6eaHNyU4iUgA3v38kVRBlo3y4vcTUgWxwrFMhVm5X5IFXuQsfb?=
 =?us-ascii?Q?E3lw7z3gXzSZnTe/iyQGFe/U9E0goJiYE20d8NaPLpPVPcBzUdj1MWsy78gc?=
 =?us-ascii?Q?Im93FIVus5aa5uZvbP6dAy8nq6UdaFrX0WfKmJlYIf8Mj0SIbsZgsUyYoGZ3?=
 =?us-ascii?Q?GhEdd83E5+zajTf1GlbrfGesGYhjLrFw+3Qyj1r0a0aBYCM0SIOtkc9cdAdv?=
 =?us-ascii?Q?hnPnl+ZnCX0JExgGpLXg9BVwexlWaz3qO03qhr2F6lq6NWw9JnGiFVUT519N?=
 =?us-ascii?Q?gDSTCH2dqt4rf89Bw7APh9TUMeJAq4ouTmHRRou59ElfAboYhe2gHm6ga6xd?=
 =?us-ascii?Q?5hrTAg2ZDhqMTRN2q0GakDUQXPI01L4KkZuLqvj0X5W9nsYrlouKcN3bw5eu?=
 =?us-ascii?Q?cw1m0B/HLNLFfsvqF1HIbRduhXzYwGmA0uUfSuQgJd08GNm4x0uxV+smCzra?=
 =?us-ascii?Q?9GFaAajg3DIEy4cfTxtwgab7e52utZho4NvSi5Dglu0D+Qex1GXyhqCRzD9L?=
 =?us-ascii?Q?CXy0toI0IPZrzTPQBommrpcwZkH9Jqq97Swn3ryo1qBeFFhildisdhgKhmVl?=
 =?us-ascii?Q?1c9TgmhqsGg8nme27bUhfYm+DkRUlNor6STbr86CtU1M4l2Y0lG38qpWvnHk?=
 =?us-ascii?Q?bW+pzE4JMuu803DDq6q5PfcAXo+Gl2iz6At1uCEnsVBfrLH5tjgFCSGISoWN?=
 =?us-ascii?Q?queitxES6sYSevPCH74kPPWn4+MxSTKSXg9oqb7cpwhlEW4IlFEuEA2lITZM?=
 =?us-ascii?Q?5jPUndwprr0VwHWBmt0/2bueP8/2aarGtEKylM+nLzYPXrh26zdvQDfgeiQS?=
 =?us-ascii?Q?DPeOULVP7s1lg9S9DL4cT4i5qelwuwNek8ZDK9fDHxG9csW01HhMqgvuDxMJ?=
 =?us-ascii?Q?Qb4oV26N17ikgclv0QTEui0fEroAMD2Pol7TZiBj4Al2YEBkwep24AlgSdtZ?=
 =?us-ascii?Q?nT3o0NmapDbYAM0piiS+y1tkeRCJuQH9CSQzbAoD/3i7krhr6zCwiiNVLl0c?=
 =?us-ascii?Q?QbQ/AGkF6ksaP4xevAPE0cqrxx845BoKcpAXEtxzzBd4l9i2qXrOCg6l4bxH?=
 =?us-ascii?Q?JpzkcudoIkFbPdDDybxydD7n0SUGiKaoIo70dTN26owBc/+X8NCG7LCwI3L4?=
 =?us-ascii?Q?znodxGMbNzArWg64n2+5V4jQJzTb01OBCYhwoY0RN0sqBjjjI+TcfI5xODqw?=
 =?us-ascii?Q?x1M0qX6GQAD42Bu/JPi0QW+kM0aHXt1pvuAzK7Lbm8YGfqwOp8mTGlfrd9Wj?=
 =?us-ascii?Q?ZvEnQ729KcJHupqNSkquiUu57fFddu11bk9EDJ3VvaVcUE9oieK7F/fR4MeI?=
 =?us-ascii?Q?4chWkqyOfnL+c2owvwo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CTrEvg004HNRaQ5hgPO3imCdgH/XJ9vV3b4DG/TppQbOVWTzUJ5tnQIQ3r3O?=
 =?us-ascii?Q?S2qz71HzSeRULCEoe70tzejFWYMVXKbSPLgkPEv/TfCzwCvjYkpeZv4wuBB+?=
 =?us-ascii?Q?DmBIrLkBN4OY0gIr5lwt9oVbQk7kHyAL5h76QQs6OoCzamcgNxIqDHL81MOc?=
 =?us-ascii?Q?lWrQAFy1kJeDDGGwZqiwfdTQjqAMO7jMAA9uGHiTZ8guU1C6GUZJXTjaDC5Q?=
 =?us-ascii?Q?tW7wRGD2sHFps8R14SglnzToaG4Mfqeaxzoi50akqAI4fHMnTMNpJr27tpEC?=
 =?us-ascii?Q?PS0vABYG5YlHaI1S0KpBg8rNL1pCqvUOL8DxmbJddqU8myFU2agxVRJdIwd1?=
 =?us-ascii?Q?FPFUh9HCIX3+VCHh4B0+Xgb/NY9sV4yiprffz+dHoBmEpsnozat1+MVALFti?=
 =?us-ascii?Q?RmHWMJu2rXyeEeduyZuIQxff6Yyw4tF146jwLMqYwDGmoAmTOjJVryqQVG1w?=
 =?us-ascii?Q?aAG9PTBQj13LplmALZZ81AzatUY4lLj7lXRPkraDKUqueDtLP67toHJBxSiy?=
 =?us-ascii?Q?WP51mL3Vt+kEJ0i9NoBjsmOlEWjzAsgq1I5krf7YP2vBl2pNWB54z7ESrBhO?=
 =?us-ascii?Q?Gwp/jPjPMIBwYNJkgI27t9KNlY86AkonTocV4Vkum+Ufo9m+PwUIqy1TbU8X?=
 =?us-ascii?Q?TGQ0HfjOTgj/DHKSbNWuJ3ZSk3sd0n2tXkvqxc/nmzq6LR50/WAR5qtmo7GN?=
 =?us-ascii?Q?B6StlNTEeenuYrlnmPAwG79I3Pu580KT23HP3tC3asVDFTWax7m08jx0QpQw?=
 =?us-ascii?Q?oC49dkf+J0Q2e2zQ2TSDfbYsUdq96ZRyej9JZ0zsl8kTa4UbTPO4L7HPfJwm?=
 =?us-ascii?Q?IepLV2PNOS/N4D36SfFJiWxQyPX31Ha7OQ/nQInDclRp2sSJxt/X3ogAXJnR?=
 =?us-ascii?Q?3SfsVqaCOc6MPT2D3dUFJXE/wOS4/0iwBW0zp6RYwLXZEHaLelF8U3w1z5vC?=
 =?us-ascii?Q?9u1seYoAfjZKka8wrHm8soW8CYNveELMA/lqF6kfwpepFBsbmymzja4sizUc?=
 =?us-ascii?Q?2rkldZF1ai/zNK/29RFfg+7G7QEklSymrcVeA9UkfHRnl2rvNKv/2pbCJyEv?=
 =?us-ascii?Q?OBsC2st09hLE13eD5flddhNXkwOGYe1KHTwNB480Utp/+SjCLiiDZuAeGDCo?=
 =?us-ascii?Q?flyWs7Pl9AEh/Pi4QFSnsN6U0ezG5EcyNs4cgmvYMiWekAm5b6W6IFNjT+UT?=
 =?us-ascii?Q?czfX1GbMzfEfEhHxR8JVJOxmcv91vKFxZq6zOCb18bVbGiqoZY+ob+H9E6le?=
 =?us-ascii?Q?ov9hh286GOrinIAFPqSbkkubJMktqnGGXmvvucxpKtExrmy8QGyUshdvoEsE?=
 =?us-ascii?Q?gd+EmBj0+GIGUNGV7x4GZ+93PaqZuqrCAJUN/gd/bkTVoTQp6ljOYxVF3NBv?=
 =?us-ascii?Q?W84/vFtvk1HRd+lWRLkd4PBokQnlLVgZyd9DEsFTf5BxuU0cMoaiWLqQy+2U?=
 =?us-ascii?Q?S217kb8111JbGfRAOOfow4RwoOiwdW3NEXuuAtFnkCc6zgTGFnRZQ2gav+us?=
 =?us-ascii?Q?bmBGOKLCtSK2DhKCV2YMsrUG9y0h5a2ERuBfdOakkT8g2B/bT//RG9gRmLs1?=
 =?us-ascii?Q?sIU9F7neCOKKNKg9wCnqYB5lYbHZWJDhldmRTRudcEIpKtWInT0q0rm3mNIL?=
 =?us-ascii?Q?czuRH+fFOVql3li8zmmCb+DV5qYolhbgjICu05wWvoGjr9qwi4b5vX77i+iq?=
 =?us-ascii?Q?FS8KdTO49rCO+iDJkv6uyr0yM+wta9Xfw12HZ7qWtlNnCCQy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32f38af-139f-472a-a676-08de5ce52dfb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 14:14:12.4290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIOfkEi67U0zwGkn9qP4Z98GhHLgvNR9CHqBedkv/JuTNrUM/5SZJXOkewFMUFOD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4371

On Mon, Jan 26, 2026 at 07:33:21AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Sunday, January 25, 2026 5:00 AM
> > 
> > The cache flush was happening on every level across the whole range of
> > iteration, even if no leafs or tables were cleared. Instead flush only the
> > sub range that was actually written.
> > 
> > Overflushing isn't a correctness problem but it does impact the
> > performance of unmap.
> > 
> > After this series the performance compared to the original VT-d
> > implementation with cache flushing turned on is:
> > 
> > map_pages
> >    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
> >      2^12,    253,266   ,     213,227     ,   6.06
> >      2^21,    246,244   ,     221,219     ,   0.00
> >      2^30,    231,240   ,     209,217     ,   3.03
> >  256*2^12,   2604,2668  ,    2415,2540    ,   4.04
> >  256*2^21,   2495,2824  ,    2390,2734    ,  12.12
> >  256*2^30,   2542,2845  ,    2380,2718    ,  12.12
> > 
> > unmap_pages
> >    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
> >      2^12,    259,292   ,     222,251     ,  11.11
> >      2^21,    255,259   ,     227,236     ,   3.03
> >      2^30,    238,254   ,     217,230     ,   5.05
> >  256*2^12,   2751,2620  ,    2417,2437    ,   0.00
> >  256*2^21,   2461,2526  ,    2377,2423    ,   1.01
> >  256*2^30,   2498,2543  ,    2370,2404    ,   1.01
> > 
> 
> that is great!
> 
> Out of curiosity - why would an optimization in the unmap path also
> lead to better efficiency in the map path (in some cases map improves
> even more than unmap, e.g. with 256 pages)?

I cannot explain this, but it is how the test behaves on my system -
before this patch:

map_pages
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,    530,237   ,     450,207     , -117.17
     2^21,    417,231   ,     375,208     , -80.80
     2^30,    325,233   ,     275,217     , -26.26
 256*2^12,   3020,2658  ,    2599,2492    ,  -4.04
 256*2^21,   2892,2839  ,    2585,2721    ,   4.04
 256*2^30,   2794,2836  ,    2548,2712    ,   6.06

unmap_pages
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,    444,257   ,     410,230     , -78.78
     2^21,    378,244   ,     353,225     , -56.56
     2^30,    300,245   ,     281,229     , -22.22
 256*2^12,   2975,2604  ,    2536,2403    ,  -5.05
 256*2^21,   2887,2523  ,    2489,2417    ,  -2.02
 256*2^30,   2799,2525  ,    2471,2397    ,  -3.03

Perhaps it is an artifact of how the test is constructed and
subsequent maps are suffering because the cache for the already
populated levels is in a poor state due to the extra flush?

Mapping requires an atomic on the cache line so maybe that interacts
poorly with a clflush somehow?

Jason
