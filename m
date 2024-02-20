Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BA6692E9
	for <patches@lists.linux.dev>; Tue, 20 Feb 2024 13:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708434223; cv=fail; b=dZkJSSLcF14GXo1uO0O/NzKau33YYvoj73LXHSRvCJclwSMkNSv/xBAcI8eYyvg2+ZPGFWgNskdT0kt3Pa4sdIjkkH7x/J+6u81SQ0s6W3P2CADx0i7brDSDvJ31l1OQoTztlOpWQXzhoTf63+8+k2xDCwBW4/9P3jY1vwblrdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708434223; c=relaxed/simple;
	bh=iw5k7jquFtb11ajSfmUQYZHYnB9HrOlIalPJGD/hHso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TPMz+wC6ICK4LHfHdajU6R5XJrQQ0PxSSAqtpaWkmULHnn1Y4DnNWsfgytjN9jAtDmeStucSZf5nuSp9agB1hc1rMKEuWuwwgIqrRcKCdC5Up5Dpu1HZXIH4VZLBkuJn1/LNR7J8Lz8qbfnAWfzRk1yGIx5MYKLIukWVZfgJo38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dj/HW3Hv; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dj/HW3Hv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7Xiq4LyGtGGh4ULac0NsLmd1necXAH8AQ6RE82hC19Y6Y5uJxFQ+NBl27pSImcYkDINhZ/XdA++VFD1muE9N0snJxQfjx5lBl4HmEtsDpwnsdhEIr2fk1stuY8/d+fbOq6ahMUb7rQLPWsFpLcpE5BlfgamCYbAE5wCII0Z+ekhbfkgVl+WOaDoZ7KyICI/eUKMdVLwZX6n4fSbUVAhS0cNbT/FUs/EAcaMYS82RAQmYXbBGvTmJs2SlMHEOqtffnUyD78MuFFFLc/uucKFbboFWUCTgNAT88FjAFwfWX/HJiRdmSoJFSHBexwg7jtHHb9Uc4mxSWfX/FM3xUKcsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5PGigYcplkrWkRngmz2JiRXfsbgHIHwMDEus9fLb0I=;
 b=fnsSLaujjDovECKTH+nj7MIMx45M7905+1ooKCLRMY5KFsOQ/LqhQfUYTS7ZaTgSpqssmQKhMyV2uf4RtOdrllJBnhJ173+WYfzR5N6+a4jhHYobADBcKylBfBsYvIlaxSyhlHJDVC5YbyH+xe9OktmzHyAdNSD8g9ECEs9fqJPkjJ0yN/owUPioD/HXBvs/hCl5Od0xVfc2VPPvA2uje5cBM2GA/Eoh56NnVQvJROICzCRKigEUEvLMCjwnNeO7u3u96UmzBjcHuX0fPqCrycoNwJgbVao86FQ6NONRsfC/Ot1wmeHApY70AFsYUbCxkjt8OqomZz6Hx1npqzmdMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5PGigYcplkrWkRngmz2JiRXfsbgHIHwMDEus9fLb0I=;
 b=dj/HW3HvVs6DFAEXMf727xOhMfJFvnkwuhr7tLa09tEKxWO+ak4Zws5rB/itjfAmTbhehVy/+cSR8rQgySx406b35FUEnovajkiSjp/bQ1POFOnOplX+LY450Qh5Zu6Nhkissq86AMv5S9e+U5lzgO34nkzIYF7rLoJGpmXTN9jf/Y7Fuw87LkAjfa2dQcjchb9vFdd6S4YnxJUah4zC64C9t8fLuR8cXfQpulGlIx2YPX1dt2L8Q/ZMg4zW5Upp5a43lcxT3P18n9MJzzipGX8HiNhXDE0yVUX7J2BSjHcrY+SzXjhlq9PZB+HyplNY1HnR1JQtSSjCnYy+EBYCyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6938.namprd12.prod.outlook.com (2603:10b6:510:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.15; Tue, 20 Feb
 2024 13:03:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 13:03:36 +0000
Date: Tue, 20 Feb 2024 09:03:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Gerd Bayer <gbayer@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
	Sven Schnelle <svens@linux.ibm.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] s390: Use the correct count for __iowrite64_copy()
Message-ID: <20240220130335.GL13330@nvidia.com>
References: <0-v1-9223d11a7662+1d7785-s390_iowrite64_jgg@nvidia.com>
 <20240219100850.16287-B-hca@linux.ibm.com>
 <e043af2e4351b601e9efe4944b6733ab71b1c8ad.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e043af2e4351b601e9efe4944b6733ab71b1c8ad.camel@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0213.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6938:EE_
X-MS-Office365-Filtering-Correlation-Id: 7835b3ea-e3e6-445d-a61d-08dc32145986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pCuSwEHtd+nxIrxUf4b/uD9iyvACGtHoSqgsR2Z3oq/LKnKFqQ9LPPN9kNA32FRZhN8AMTxntNJys11gOnO/6evCrQGWpjpaYJGVJ7Ckq5pqCYFw1IRNfmSvnIh0enGC0vA1eGI5XWM/dMUw6AxpKiSzMtluG54IYWD14TE6sBc+zbzBItbmlyp0tJ0kViX1k2a8RoApkWcWV4L3wLrEUWtYjIovF6DoqDp122XONAzhCnAtT+YY2xny96kpe2zqAgWM15Kzc6YDnL5F4GkMj+22wAJtWCWJL9biy2e4e0TIXd/UHYxBAwOPL8OUwykHBj5Bewb/4tU8/Tu+PKFUAo2JLZKU8833Xlbj6f/XEkxkTm7ay4zvdD0CHu5AvJ/8FE1v/DGpPQDP13YG+SFAVgoVuvloTm2FTvebwQEW4CmS33MAfX+nnR/RNgk42q+V4KxWKETzaCkWp/YN/gPpItm7Wh9DQoctOcVd9QAnQrmNveLQwQYDSKc7in+YLxK0IuQ/dMpA9cbnNFEyGFhH4hBcWZq3/VhBa0MHpzKRZ30=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lUlIqr9RK2WT5k3Z0VkIiKLu26iSrroRcKssuHt1oiMIz4Dl1PTcJZnBFWl8?=
 =?us-ascii?Q?SFsoeUj6wbKdFiaEmnxr11FQDmV5tU/c0M4ljDM+jXFDPVlOzA0VencuKbJY?=
 =?us-ascii?Q?6YpSFC1Y2cCAbOpyRStGsbyZOo7i08YtlCM5bdLvIqv1KDXncgatlC/9CgOB?=
 =?us-ascii?Q?Gwwm8IS/5S/pl03hoAXfosr6uxOvESDSQTCHhDoC6NV/BxMlfqdLY7clKkOl?=
 =?us-ascii?Q?9yrwDopUA6/NPHzMf3SiO1e6a1288YjCur9CXJIBh/Rq8OVvpaMP/1awa0lc?=
 =?us-ascii?Q?4m0Cf8RD7oIqOt47QylrquRkeozUI22DWs1Wga2mHt/6LMRgLq8N3xiP3/dZ?=
 =?us-ascii?Q?yefAEZ5WtlH5J0ggW59u+gBSDO7Mz3MbmDbzMP8HDtCmXE9iqJCX3MT4nr7r?=
 =?us-ascii?Q?qv7Z0EMF8tT4EmAKZ8V8pJT/C36+G9ALrrlYw3rViVo1NkiuP+8JJvENDU4a?=
 =?us-ascii?Q?PIBuqWjgae2ta9S74n66M4D2DJL1t/DUAV7vJ0ZlYVY1poQrWtuIgAb7R53a?=
 =?us-ascii?Q?JXTUW1Tnm7GW+coN5qDt3Km7SHwuIUNjHXkaxUFLKJxC86OMG6aDX2j88XBv?=
 =?us-ascii?Q?qfDseYiOCL4uchdNsBbrSpx+vG5zlgvEHG8BzMR+bdTPn6gKfYLJLVnbMDP3?=
 =?us-ascii?Q?P87GhIAN4W8wB24T8hanFvfPnuIbmSb4Yi0RGWqUaBP85prKTy3K6gHviN2k?=
 =?us-ascii?Q?bGC9+s7DexnvO8AqPlc1ay8mRBUf/2QqVcx56KUiJ+BxJ4vAPOBmWSPhbSpk?=
 =?us-ascii?Q?89gUEkFq0Il4cvlUP0bITWvbjGeqHKs7/ooYI2KTkj4HyQKF8Bflb7d/N1BZ?=
 =?us-ascii?Q?uAs05yk9QyjHvmzNiIzCrh1t5nsgWr+ZvMvdrYnH2ZIqDr58bKakCISYf7Eb?=
 =?us-ascii?Q?W3kzdkZDEQpqL2gFD0OPTWuh7z7tx6CYzUxQrh4Ix3BrXlBd+Xy0xCwq+S1t?=
 =?us-ascii?Q?8d5KYYwfoMYCKNJcY64aguAEAOHxVXLxciy3N3iRAfB7hv+Ckar20uXenMq9?=
 =?us-ascii?Q?TWLq7j77O8d9EO4N0VBskrHimooq7P7ryWfsLdNhqHjQjWjZxox44InZJxD8?=
 =?us-ascii?Q?siZpX6bssk3Sh5hK5QSomz4qwvmXpyZfeNt1kpuZlEPHsuHpUemJMdtaZEmK?=
 =?us-ascii?Q?1rS9PaEaZBf7gZAwS/fK4kChcnLhRwPL9R850qNUYFAUaYWtYH9PLfsyHLwH?=
 =?us-ascii?Q?PBLAKPZoOo60x886GsdRRhzbxaWYC3OaawpJTsSlPLPRorJ7lzX3rhfp6f0n?=
 =?us-ascii?Q?Mj3kGSJ177f6kmaSiyEUyqC2xH4DKs7qLmZFXrXAsbXjwPlSsQ9IwS5ih1GI?=
 =?us-ascii?Q?qGYXHwJtpEP3mcf8dBo0ZimvZB5vJ2uevxJzEWo6xa6QqqFoo4k9M2E/yaGe?=
 =?us-ascii?Q?cJttdvY5mknn7T4X0/1z5CFjvBLKFK9wQYHvY+KlAInJBOlMJs8m6smvbXsb?=
 =?us-ascii?Q?7TFnC2bqhxF/7viKO6grbp5zHAVwCEIibxoDGS48mSx9QDVPMQs6w90tNGHK?=
 =?us-ascii?Q?WdGcNNRaPgqv4YOXDlKfoAvh4eE9PbmLmvRW87FNCooiiDzdbv/w5gi6IdG6?=
 =?us-ascii?Q?q0H0m7bOCEV2Vlu2ACw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7835b3ea-e3e6-445d-a61d-08dc32145986
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 13:03:36.4450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLO/gIE2XOcRTEXit4ngYeZ6zLNfVSpFJxIz+vRgt7DEQ/hnvXaJvyzL3+uGElKz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6938

On Tue, Feb 20, 2024 at 01:22:11PM +0100, Niklas Schnelle wrote:
> On Mon, 2024-02-19 at 11:08 +0100, Heiko Carstens wrote:
> > On Fri, Feb 16, 2024 at 08:48:14PM -0400, Jason Gunthorpe wrote:
> > > The signature for __iowrite64_copy() requires the number of 64 bit
> > > quantities, not bytes. Multiple by 8 to get to a byte length before
> > > invoking zpci_memcpy_toio()
> > > 
> > > Fixes: 87bc359b9822 ("s390/pci: speed up __iowrite64_copy by using pci store block insn")
> > > Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  arch/s390/pci/pci.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> > > index 676ac74026a82b..52a44e353796c0 100644
> > > --- a/arch/s390/pci/pci.c
> > > +++ b/arch/s390/pci/pci.c
> > > @@ -252,7 +252,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
> > >  /* combine single writes by using store-block insn */
> > >  void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
> > >  {
> > > -       zpci_memcpy_toio(to, from, count);
> > > +	zpci_memcpy_toio(to, from, count * 8);
> > >  }
> > 
> > Odd, this bug is 11 years old, and there was never any bug report.
> > Is this never called, or how is this possible?
> > 
> > Niklas, would you happen to have an idea?
> 
> I did ask myself the same question when I first saw this change but
> still don't have a satisfactory answer.
> 
> As far as I can tell there is only one call that could be relevant for
> us in drivers/net/ethernet/mellanox/mlx4/en_tx.c:mlx4_bf_copy(). That
> call looks like it would be done during transmit.

I'm pretty sure a short write to even mlx4 will trigger the NIC to do
the slow path anyhow, so it would have been hidden. (assuming anyone
ever tested mlx4 on a kernel with this, it sure is old at this point)

Jason
