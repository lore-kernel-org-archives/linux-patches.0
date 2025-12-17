Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010038.outbound.protection.outlook.com [52.101.46.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794013A86C;
	Wed, 17 Dec 2025 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006079; cv=fail; b=sC+RRaEOkgQhEo2+/BfUyzWOQra09UCm/AvUZhXgF3tCFtB8zdvB8msWV5oNtoMVb/OseN3WLU9I8uweO9DvKZ16q74ZowOZFfLveaxv7uq5geKhdTA64lJF8tdJb8dpONfxKW4Rs2H0ySsfcmQnrd6eX7gX9TNpTO+6wdOBrd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006079; c=relaxed/simple;
	bh=uOhNwP07T3mGxwCCo7JwQmXbR/dvFq9e3wgGkgsQYG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mfmD6pmRkbDE6FRnos+ZviOwnnxOq1JE/+e7YQSfgHQlMMInZUM6ndw/WJhGe4j+ueAuKCSVpRXlCcq1Yv3ZYYoIgYy+UXacTKPN12d1j3Et+rdcF/eHSeCwLhjXd/IQ+LG9xbMv4Sq6xRitvDK8df1sjyYUr9B2R/7hdmPm67I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OlsNmvH0; arc=fail smtp.client-ip=52.101.46.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OlsNmvH0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MaZqE8NY8EM21LiHdtDUbJzNbOk0RW62pfW1Ds19mUf1kFR8CjD0TVWI0IU9iRCTOD9Nx4VrXJsRj1vuLwi2hiXrf4UlQUpRTi8MBUqP5NssLcbZekhtxoChR477cF54MPvjPyuhqX2K3Um/GvCzhUNwvp8sCDyKaWPymzA02xyQJT/V7GE80tGGWpkEvr57aJKvVyN73CGunZ7hWlHAUG9OVUzznjDei8YGcN2lN9LukDQgv8WoNSstryM3ko/GenHuLnHHSbNg4NPW//7msGL7rQ2lAsVhyyYwI4nYy3JOZMxA/0qUo+q8oQ7LzinhCUoyJM5Ygyzpvf+INsoAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Tb8zo26mkeWyO5fCLEEDXgV9u6LaeUAF+9OQHsD4dw=;
 b=sgT0rZKBI4e+42JkoHc2mm09drbOOzoyxJoqdZIHzt13iIxgTraWmpE5XzkE9JQI5ROBARvqj87UViVZAS+tnasiiHtFwkWZxmy2IWbG3YXzQV3fNZwm84im/NRQAGNBJMImoc1EAVBwNAEV246ckoKKc9woWH4iIVaGRxAzZEg61ePr3muIul+vDJTq4tzDRd6Tr2cYXpgh1tVt7NbvYvc2h5nkeNp9F4vs/ZI2+oeCHDZfWn4yoBK6ISZXI193Sw9nZ+YmpA9O99XpB/nLr2y4xNpnsDh9YrG902ugED92hukl8PNT5+vKymTjB2zBpT/Jp53ymbiAt/eCDUCMFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Tb8zo26mkeWyO5fCLEEDXgV9u6LaeUAF+9OQHsD4dw=;
 b=OlsNmvH0NXOv9i50PmAMthdmk4HrD5kMHkT097mkvISyZ8hUi+k2BnXTx9Cy3UW6IKo4eMN7SyuPrzCkhe49/XhzGYkQ4Bi26fZArTF9dnF+9FjwFbDZOpParCpJckPniFrZmUM+zDI9TiCB+96XCSlW1q0WZVaO38Ry9huYCoUJcGoygrPK/2jkrafaSD7D3dEPqljASvF68QLScU1izlovDZmiow5c7Nt2ghXPjeOa8a3Wtt2/6YvrtHHRegBS6iK6VtnCn7wgGAZVVsyuGtYdpvk+PomryGSNiFvkou9zMMcsRDeMTU0zokibIl43nzURk5Udkve7xhZpz99crw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 13:39:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 13:39:52 +0000
Date: Wed, 17 Dec 2025 09:39:51 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>, patches@lists.linux.dev,
	syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
Subject: Re: [PATCH] iommufd: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
Message-ID: <20251217133951.GN6079@nvidia.com>
References: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
 <0693bba1-4ed6-4243-94ac-da85e8f51846@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0693bba1-4ed6-4243-94ac-da85e8f51846@intel.com>
X-ClientProxiedBy: BL1P223CA0043.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: c36e9002-3c36-499e-796e-08de3d71c17f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?5LvDyUcxbvMFNABTzBP60vUzoMctbKtZ0TXLI/KF4GSLsYNai4j383QOBdWd?=
 =?us-ascii?Q?9FFwTHghZLoNbLjAyleEDCwqS0ZX7nCtDvkoo0luAb1ZQHENM/i+pSHi0lEO?=
 =?us-ascii?Q?FLQBi4ckxq4SPAV8Xfyp+NBUxZIpfdd68NJKNcOqrrnxqQQB43TPzO8lZVsl?=
 =?us-ascii?Q?r7bM3dT8eCvcgmmCRzK1odX8laD9+lKB+RZAn0fGkk3pD0ZdkbqKRUC96a8b?=
 =?us-ascii?Q?2HUO7ba9NFk0DKOBJYixaqhgrC1Zjt083HEfkIpvNX4EUYiVUivOgYX23uuF?=
 =?us-ascii?Q?Tf+9AAfIJwAqGSFczBOxfJKnuTN7Aa875IcJF+Gfw79w9pEkBCDSkDIWn9aL?=
 =?us-ascii?Q?NRpRB3pDjnJN6QkYd01GrAYpCpJAE51D/JspfJ/wEkWg7zqtKrt8KeQXFhDA?=
 =?us-ascii?Q?jsSJf0Be1AiEVhXbpqKXql58FrfjmH5VGN/96DetI08S4ScMuWKBWzHFiFcB?=
 =?us-ascii?Q?gJb4/7maMfqg4zuCSHYLVSsHODQdfw2tGTtJ4jM0Acupd984a6skAjqnFe7c?=
 =?us-ascii?Q?9V+Rr0Cud5c5bcS/SCpNMm1fPjcSOs0Z3BIPYVoH3SAXHC8fSxo78bgcp+Jd?=
 =?us-ascii?Q?hSvO7FufBuzsDYHicd4CO7yDjl76f8LrE4MEiS48wk6Q/lqM4TyrnfTe4k/X?=
 =?us-ascii?Q?45dw1eFsi9VYVOHamO3IJPXu92jiD5CWxNjnlB8v+dTyvv04r1gFv9Nop5PN?=
 =?us-ascii?Q?D2QWSNVuHTG9GI1szZ+PaQX6sSNhccjBstUIeEuOSyccDPFBHyXc1g276nT1?=
 =?us-ascii?Q?X/ALS4yRsGkAzVifVmp48C8vwt/HU4gnGVTSel8JU76Nl0B9btvkyTwavtIU?=
 =?us-ascii?Q?yW+fsv2Fc/6OGl8/Y6/pF8Z0GLwm3+hOg22tpERK6AjhnSBesoqgJ/SdOfMT?=
 =?us-ascii?Q?An37BJfZ3A87waCU/5agHq/QGvAcDM7u/YXSgPm7JJnc6GDvpo31pi2NT0uI?=
 =?us-ascii?Q?+VzTGczqQ/qVfZjxvNZkf3X46Pz1J6efbpE3JWEl7W+almDtEFMDIeNbWkCy?=
 =?us-ascii?Q?8I3jCYmnhprzyVUzn1F/0cQokAEtyl5tAOu2mT0f+hpjaN8y7UhGwBUcMRha?=
 =?us-ascii?Q?jvVis56LzLid5UVJaSr0ZbJhuRAv6RZh/jYfpxR09wHoSj2H3N/DMzAwIjDH?=
 =?us-ascii?Q?lOHLeHrE35ONwz/LLYtPgIZEGMbYrLDdFtccZL1qhzMooB8WrdJocpQ6bTWQ?=
 =?us-ascii?Q?X/dazitsCIYAAtYtbJrKaPS3s5t/waBJHu+2WLyt3G8TuaTIsowesPGdzeZD?=
 =?us-ascii?Q?Pw+tzfRw1rMKT2A6bnxSoLprccZ0MPOakv/Wzv5bpe18Viqd6pyOfeIY8u3n?=
 =?us-ascii?Q?vqecWp4WnrY4SoGSiJd5bHVm39gfHVv/wp7GILiZI3L/CXeqnrdOmTMKG53h?=
 =?us-ascii?Q?Mb84ytlyPugg8EAjfSYDIA9eshC2hObaWJJY8GZmxxxqXyC/n0iTU7hzODMo?=
 =?us-ascii?Q?W2kEoy7wa4kes2FTw5lV3C67Tam++S91J+xoh6Ka71GSX2yXEtHOqw=3D=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?lMAFCzi/PM/2UqEdrj0N3ItAJpZ3jzmvNOpPpkC+L5jAoKLqtAqSvXJJiq6j?=
 =?us-ascii?Q?n20JZXu+ig06ql4ju+n4COzYDrBg6gdRqA1Rnum2oxAC+S39LIdVBU8H9YZ6?=
 =?us-ascii?Q?9kleWWeR7NaQJ+VQjFlB/OYeJj9yU2sHhYeFHwn/yQGXqGFyt31AktzoCyov?=
 =?us-ascii?Q?yxZmAYySTNjnk1ZUa5V9J4LYV9CQqJ9i4y81LXBl4qjNqpRMOw537O/xA0n2?=
 =?us-ascii?Q?fk+B1XGO085pHA0+ZSLdgu4CgJD3PdXbYQzRJpBGzPIckTqBDk0RZHqLyKGg?=
 =?us-ascii?Q?bLfFHqo5XyQZRDFBn78rldzfCRh67dGtd+Pgxsk4KTWHIrb4nIbzJhstUG7K?=
 =?us-ascii?Q?AE1LmTtb02xAro2ANXaPBxljsDRT9wqWJOclfEO5jv8uq8vkzcP6h3Q0bPKv?=
 =?us-ascii?Q?bqkZFIFsvPiwqfs9R5Vx5EDB1vxBQq3EOCCSzM/RJFy/V3lpm+kYEYMW6Hf/?=
 =?us-ascii?Q?lAc0byWo58Jt0EpMUdry0mieDWuDaRjxw1ZJoAr2kZi9kwSVPdik39htrefj?=
 =?us-ascii?Q?GOan7IgoEJ3NKSy+JiFc1iRV+prL5qa/7/m5gOg/XlyCWX9u27a0zF4b4fJn?=
 =?us-ascii?Q?Dn+HC/j+rkFAkEs8tmHiQJfANWrnTVlS2tw6QGgtuT+rc8g4jl852c1bUfcC?=
 =?us-ascii?Q?4PIpBOjnTotjhnz1t4aaD2Lrjwr3gMqEirm7z7V86TcdKIIvH88OMirY2Bkc?=
 =?us-ascii?Q?tybJ+3HmTuaXa4uVv76sJvnNWXHi8sk4w/nUb7CQ5u8mzV79eCS9NZZsbNW5?=
 =?us-ascii?Q?ihKkxDSarsjhEySZWCkhfdVfFK7plBTLebEkYo8cNeh0UjyvN3F0Ws8nGf+8?=
 =?us-ascii?Q?4CP8p9kLABPShtFq82K/LCk4drp2NBWfD5gVReziyLl6PWpoeNvrhaadnPMB?=
 =?us-ascii?Q?EJPYPh5RBTeEmwGyPNbWMihlc8AwHXNcMU9jfPcGVQAWcBPefxqyFl8kfUxj?=
 =?us-ascii?Q?nJwk/whLdFbM0yvl6V2DoLjbajm44kphfZ9atne/HptASfep547j/KQ/5k5f?=
 =?us-ascii?Q?TX22/9HWSPke7djW8FOdMP3ouuEAwxrDBvqFNVdTMDQrYalGwDwad1A6qjsv?=
 =?us-ascii?Q?7GuiFDmtYzPvVaG6OGUrNTpePB7xbED47wBGO+BVZAwtlOOnqiUDkqtBwcak?=
 =?us-ascii?Q?1xDD96ksA6PEVIHHvz+JlS1JsIuCkRxOpx+A2ybeN86dVJ2zgrFTksSvSRxJ?=
 =?us-ascii?Q?e6V053BKy9pzhEH+pVO01bF2WXzdlH/fHeg5tupgQ+Xhmhn4VTJN+hKpNEeC?=
 =?us-ascii?Q?kED+IlhBAUFpRiTx0kEreLf+APAVxqZNlz9sHe0H2QaXtgAoe8+pickc/gjn?=
 =?us-ascii?Q?juTRKfZcJNnFSEThUkMFJzfRBvs/4YXnrNYk7SJSVVnvTUH+BX0PaShyhDOE?=
 =?us-ascii?Q?fkH0bpHp07K3fT+TzOy1e0syKCCvyrpGmSuUmKSLy2jzwx1NOpnuxiuVVO1f?=
 =?us-ascii?Q?oACjF7DiylG2CHDYz+9F+ECNUMtHu1Fn7o+FNQPvJeiA8mfen2ddnfVrLC57?=
 =?us-ascii?Q?Uni6/319T9Y9Wcz6LOtGAEEL4ob2fVzd+B/RTUmN1ICLZg6GQvG+vD7PWAYM?=
 =?us-ascii?Q?e19t7llcWtSS0g/tiFY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c36e9002-3c36-499e-796e-08de3d71c17f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 13:39:52.1342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeHfRpvjafXkzy47cT5r9SI1z89aOPXYlWyDUGW80a9206igniMFkqHjHZpK8vHO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989

On Wed, Dec 17, 2025 at 05:17:46PM +0800, Yi Liu wrote:
> On 2025/12/17 01:13, Jason Gunthorpe wrote:
> > syzkaller found it could overflow math in the test infrastructure and
> > cause a WARN_ON by corrupting the reserved interval tree. This only
> > effects test kernels with CONFIG_IOMMUFD_TEST.
> > 
> > Validate the user input length in the test ioctl.
> > 
> > Fixes: f4b20bb34c83 ("iommufd: Add kernel support for testing iommufd")
> > Reported-by: syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/69368129.a70a0220.38f243.008f.GAE@google.com
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   drivers/iommu/iommufd/selftest.c | 8 +++++++-
> >   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> 
> a nit: is it necessary to add another overflow test case in selftest?

No, this is just test code not actual production code..

Jason
