Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011070.outbound.protection.outlook.com [52.101.57.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F122429800
	for <patches@lists.linux.dev>; Wed, 13 May 2026 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685092; cv=fail; b=sVeJUYJb9x3Tweux1yDUa9TNwX6g151+iHfmnP61LQDA7CLKrwNI1d/Qwj32wRcR4+VVeweKqYeSD4yeughAC65+LnbA+PpoFrEdiakh9WV7E8neuBsAlLHvc3uL7XLZ6jj9IHyLF2SC140ZqjOboOy2xrCTerfvJcvTnvdRRqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685092; c=relaxed/simple;
	bh=6Xd2Im1c3U5e0TcmML3lbgGVEuzo4D6h0fVlKukuBEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Sh6pxyk/9cCxH4w3fFPKVYm1+N3+Spt67zPyUoaKSCouv3wvwrL92DCgDQ+BT6XHnWpd4sghXCP+aRmu1F4Aopos1FXhq/2Z68KswCtmIKDvi2to79T+4LMH5XJhU3EejY+LyRYDr5FLlYLareZUmt04M8/kt27aXenfJabaXdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b7j7xYmQ reason="signature verification failed"; arc=fail smtp.client-ip=52.101.57.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b7j7xYmQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cw07fsuKqgnnKBOu1ojaIXPqftfRQXQywKPXeCGsqIJ896FW65upXuAvroz/7cojoneh22EJrrJueKtMwhwwISLd7rGU1OKGjZCCXuP8MtRRaEMr9kOAm2fTzjPhXpg/mSj7Z72SaNu6XVcd7n48/sN+budTlZ0UqmX2bk2CIzQf73pHU6UKuzNy402Kav8ZL0xi2v+kW+X/RujX3Y5XcKlQVMfpF/iQOycTAsN9HLQeR8pcffjvvwm2dT5HKvgwGImh+YbpoAzcNU8eWl47HvxZ/bX7HfQHDHRJmxfWwxxCohjcR51rVwijuwCLv4QoAXx+roY1FnScf8mVwKQ23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZCdZtWDaVoJJKe9vYb/v8du9sah+etyYTG5G4wy5tE=;
 b=ypb4EhktzXn6Qiu5+pHqrwiulkU9pwXhVGwFOXHayNtdXaHDTddYPA4GO/Ucg+mgTqzw0b+vTiTr+mmkQnY6PnDmsFCB3B+X0z09Rex5rrKd2lOshiURC09GR4jf8X4BFfayLf4rNJ1YZ+Rzvd8g6+MAChnc9sJfOWq4GvXcGrbSfD0VS6uC6XUaji85q9Yea+Ngthf7tLgafUCNfdidxXaLN4oHApYO12t+QO7h0OPGsnCU2kBrZqZUilXnp6pNoeIc7YQbGW+rExu/BOeQoTztKhqesAHJEgTUqq+bNWQttdVIia95xsyxmdJGtMO6pcZrrGphPcOU0fetcQXu3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZCdZtWDaVoJJKe9vYb/v8du9sah+etyYTG5G4wy5tE=;
 b=b7j7xYmQw/23R0b5B4rObAF3tBVaTXKm0forkRZB9XaGqHY9Ry0Y7LEa809gAH/bdX4zK54Hi44r7Og47CL7uEgM5/LlYeb/c2x0YX6/j+oA71ct+0ivuzOMFcvNWA/xc+VONDqUDMGK5g/Z9WZChtikheshE+ZKCuWSpIjfO+qWrl10ZF5/K4OSaoNg0CS6a8NR9iEu3zvntep2awlNoi/1utnmUBSczWhbUt1K853wzi1It42MMwqktprSGgbX2G9EVSYdVy6koNMujTeXHKOYkOGvu1DBwvnm7b+d9zuugg40R5ImoV81izhZxqpzRgCO99NpM5Wl5ZybCyubeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS4PR12MB999077.namprd12.prod.outlook.com (2603:10b6:8:2f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 15:11:28 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 15:11:27 +0000
Date: Wed, 13 May 2026 17:11:20 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephano Cetola <stephano@cetola.net>,
	Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7.0 247/307] sched_ext: Skip tasks with stale task_rq in
 bypass_lb_cpu()
Message-ID: <agSUmB_A7tECRrtp@gpd4>
References: <20260512173940.117428952@linuxfoundation.org>
 <20260512173945.338221208@linuxfoundation.org>
 <2f509cbf-f14f-4dfc-8ba9-d53dc10e0aad@kernel.org>
 <2026051301-tusk-parcel-15ee@gregkh>
 <67725402aaddb935a94d2cd751f317e6bb844654.camel@cetola.net>
 <2026051342-canon-apply-bf42@gregkh>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026051342-canon-apply-bf42@gregkh>
X-ClientProxiedBy: ZR2P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:53::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS4PR12MB999077:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b6b0f4-d339-4b9d-478c-08deb101e7c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|11063799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZqxV00rykxxfULzP4tN9n0gq+eENV2uUj+0driMzXNPkInCe5ul9xJEwOYNvyIj8u4dIV4scgpsgEJC7XjZWMgLVF8KefQAQVm/ms/Zsa04J9Khdj7BS+wCr/rVIhP3SE2iWaB2t1MZ0Gdtld/N6bxoCf3xQiI3pTjTANN36C2NGqIaNax6eYsE8fp1JvkZBrPC+IiTdgrLwUqopA+XrL366Be+W/BFlADnObRXUgUjou8VLlKQsBLbvNtv9R5ZB0oeKuMXbTaD/VK0bLOnIaQuZ8staJhMPWSAOUZrOhzLmBXN+ExhzMysYPJ+ZFJ36Zms5oK7W0tUNjravtSBIqG9x7Vnl3jdix08I4ve5gsP6iddhw0CvklYUhU2BDLAcGI1MnBn1g2oTCK5EigOJ4tr6vverV6GNU7iuBGsIDmO8y7MOuXipVrA/BQ8zVNxwgBurzBbYozMVfPILLB6D1ap6C4RGeMf3TYx5I7/Ju1kVXXuSy1Og+W7GY75gWxn94dcSDBc2OG3J61rtWnJYaNKRYXF8Y/Fq4fb5rQpmdBncfADQkMvzbGRFx42JSqiYc0AOiP0UoBBg2RYuFZVxoeNIu93f6XYRHtMwDDGQja/PyMV4fmUBRCmQRNsrrc8d1+IJr9n5Sssdv9ijBUphbfMAimvcWbQePiiKQy4bxjuskS/eFg0rY5ArstzSKaTc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(11063799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?B4LQ/za+qiUw0bwgpGEbvlRYRtmPr4aa6ZB7f3VGfOUWHIgMOV3Sn8iP4V?=
 =?iso-8859-1?Q?38EUvyYF1oqHSJhN0ZpFRir+dKQGXF2D/FLFJYd0QqsXSbcxr2D7OGDQma?=
 =?iso-8859-1?Q?ijULqXRu/vRbmVMQxAcFhw6CfxJhhQQzF45W8ZaqpHf9trqf5pSwTIh3pA?=
 =?iso-8859-1?Q?fsE+1CD4+MCPwdW8uEuM07p+mrZRC4JnWhiiiKDF5ZIGXgHXFyG3SXKwK5?=
 =?iso-8859-1?Q?uZENU8OAvZTW9F6T/8wLaLr4h8QrR5Nma/DuTrP8r7rPSCy4LHRwCV8YrI?=
 =?iso-8859-1?Q?k8/soRm1au1ejPul6uB952wo4e8iz23uC2wp/9nWx4xa5jNpeQCJ1cMxgl?=
 =?iso-8859-1?Q?kfyaiweXF4zVic999N5FWqZcFbZcP8LO0lHFAAwFfoS+kkREgR+vWcYvv7?=
 =?iso-8859-1?Q?8Dd/h0EEUl15Cy4MD2UUcxtMFmetOkRuirNlze2MuZwJ/MF9UwPthMWmyN?=
 =?iso-8859-1?Q?8sMTP1HL+mLUQwdDTM0dyClkiGjluPFk8bCsIumZd1pvvMhm65zjiQVMCi?=
 =?iso-8859-1?Q?Yd8+WtIdAuM09cQirpoZSsFxv6gqTbx3lgUKgXU08wd8ZSzr0EUPPx3B9h?=
 =?iso-8859-1?Q?iXSMoq2atd87XQfoUDMv+cUGpI+y193eJHrqMMfNk4RV6jLoMg3TV2moSQ?=
 =?iso-8859-1?Q?vGkpqta6fa6WeLVKV8npUQlNOwGTEb5VAyFlPkOGuE0hGP8e/mDCbHqdEI?=
 =?iso-8859-1?Q?zkbbM/72ixY3ZTZjCCxCJaM2jTqMHaE0evtpsoo/l3BRhorunrwtX722gl?=
 =?iso-8859-1?Q?CfRnE4GHfLSnES53LRdlT8TNyXFdqs+ciLcVa3n52CfJn6xl+BdnVxAn2f?=
 =?iso-8859-1?Q?5CvwU1kp0iioEPFCv1q4jQp8yzQtzdCSBlz45YZayrvq5jLBV80A//02H2?=
 =?iso-8859-1?Q?m7szI5H+eZ44fekLh3kEQqESaaTMo9VQm2nu9hMI5S5MEo5fTkF9Xamt7S?=
 =?iso-8859-1?Q?2bojf0B5Cb7UQwrWdIj5gEobZuHt1h9sBITE++0dXSRZFlC8qZlvfQ0rnq?=
 =?iso-8859-1?Q?B0ML7q202wmgdbfsb7VSf5pjxGfrjntEL4J6TxQ0j2O8dZBNjuWzAkqDK+?=
 =?iso-8859-1?Q?0RbbD2p2+L0a4TcJ+u+zUTbCSfDxhavbv4llb48kcZyvx8mpn0WRdOwqTr?=
 =?iso-8859-1?Q?CrZg51r0oJvZXWqQnoQ8t9siHa1fo88bz9xsllTL2QKO0NNbnZ5o8QR3Kk?=
 =?iso-8859-1?Q?cQSQRYlbOeAggl3kHQ5D0UibITtEXlfww2adTXpj0GThUvIgftW42WniC0?=
 =?iso-8859-1?Q?kvgxeGMSjrfS1pXYzT3g/ZcTjpoun7bYVd4EoPMEo8tsfL/Qec1fwfBKpo?=
 =?iso-8859-1?Q?emdxCOlOlrbw8AdU5tiXbmwV7sNth6Ak+YLbTtdnLC3ytvpdtHWggX+GXS?=
 =?iso-8859-1?Q?ZFXqkSm1/pPXlznuqOY4aL3UcNpjptKD1FcUPLqU6pOrP5MPv0wBhCoHEF?=
 =?iso-8859-1?Q?/xvqcC5nidqOoadiYeBpHjXV0iQ9dN+jjYXczl0Ctx+xnlqG3UoXYSsNTG?=
 =?iso-8859-1?Q?1gm/x52dYdR+Ae/ybSe1nxf/JX0xU5k+adFRpYi1OK8g6eLzhShatPUOJ1?=
 =?iso-8859-1?Q?T+roXve2D9HvEDkGxfVdvXq/TUDWopJKXTlvtp4l16MD0EmR+ZUVKvRzsv?=
 =?iso-8859-1?Q?4sNZHoba2Z5vp6VI1lPxeUItmwnsAragw+/hgOQrus24jvWbRcEp9m6HcR?=
 =?iso-8859-1?Q?yCP7bmnk2jaDTm5JEyC9SSHPDhg73vNWBYAo5ZKt53ZG1qotnG6FGNkiCd?=
 =?iso-8859-1?Q?zxQ5hgGKrrjvQiyq9rqQ1Gsrh/3RDL2YPsMMm+5N5nT+xy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b6b0f4-d339-4b9d-478c-08deb101e7c6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 15:11:27.6484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PexeZKCDMNutQWhvQp/8ScsVxWKQe+/jZeMvCtzdYCA+V+ajGiGasPWbcTLUlVd1AlsVgzkx6jagA015d2aO3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB999077

Hi Greg,

On Wed, May 13, 2026 at 04:56:56PM +0200, Greg Kroah-Hartman wrote:
> On Wed, May 13, 2026 at 07:39:22AM -0700, Stephano Cetola wrote:
> > On Wed, 2026-05-13 at 13:58 +0200, Greg Kroah-Hartman wrote:
> > > 
> > > This is odd that it doesn't show up in my test builds/runs.  I'll go
> > > drop this now, and push out a -rc2, thanks!
> > > 
> > > greg k-h
> > 
> > One of my build machines was able to build 7.0.7_rc1 successfully. The
> > only difference I see is that it does not have:
> > CONFIG_SCHED_CLASS_EXT=y
> 
> Which somehow doesn't get enabled with `make allmodconfig` :(

Do you have DEBUG_INFO_BTF disabled?

I think allmodconfig selects CONFIG_DEBUG_INFO_NONE=y => CONFIG_DEBUG_INFO_BTF=n
=> CONFIG_SCHED_CLASS_EXT=n, because:

config SCHED_CLASS_EXT
...
        depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF

-Andrea
