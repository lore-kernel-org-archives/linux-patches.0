Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011036.outbound.protection.outlook.com [52.101.65.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F683A8753
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 07:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774857591; cv=fail; b=FBRwwwjevguAnSvv/OA+fMfyS31fMqTUkK80uiVxOWUAMDqvylalj6lsxQyyDlRZXKE1zNfbFCB6McuD08sHDhsSxmhL4Gvy2rp7fPYRyca9ci3urFVX/uIIvrqkUj/nqLSD+k2k22PK9upZn6Y6DAtms7BFk/cHM9+oeRLm5o8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774857591; c=relaxed/simple;
	bh=OtWHgehMpV8nAZC5CzwGqeB++8tiSY+wmwVjjh9cCe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hCqHHU3S6mREB7UPj7V1D33qbD/fr8N7pkQkIWbIva4PfjCn2LueE9gFk5OW+OgM/ZpaDXi2Kqxd17tZ+ar5xC1jxtikkeikhInvQy28F+K0aekfxjTAeRc3ZvE0SO88LyEbfJ2YcFG6ZNoRi9DBwwV4Zv9UKwL0gWXGPeQF9Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=kfyZNvt4; arc=fail smtp.client-ip=52.101.65.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="kfyZNvt4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GrvrLW1rlhSD4fy8g/+YmqIAeIAJCHlg332HYqbgo7og3E67W8YR1Loppv6+cji3VC0ISqdI0rmFKcbmBJnTJPM+I+G7IooD4dt624+apEre2fDQDAIZwZq6wK9NbRg9j03NQaPcCRoxQHIFhGvVqrMZILzrfAAYk/GKOpdtQaz9Orwo0OgrgO7qdl1pzKj51+XAyxMXkBt8kcRYEQ5olQVqTTuSyJoKt27gDlE5Mk/OTC4Jlajn4A/xfVrecxcdYGn1mQdPpK3LZ2W4UWI8ZBP2pcFX6DEeiq/pktt8qFQPq38S66ldBQZBqx7C9wVW8IJgj5Ifd4ATJCL26HtXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyxJ0yU+BbGpUmJhHVAs8RI/YD/xkotxhDzNmowNBbU=;
 b=qW2OY7y/XEcrPOmgBYrv3GeTod+bgLQSFwtwgL/pRX7vLvorgCqYQSIoUgi2VJ/uKFpFSmPVfptdg1ohaIxw/I3L6gXXw23xHtBCcevzg7xZy9GyMWBSs12yXvk95rD6WecVpZRZ6SqPFVlsDmmITEcm/Ch0W1Zeh5cMjCmLc6GgDiIPHPY0dqSgjeSc8ov49kg9nOj903pHKHKdTwKz1tlIiO9GrYnrFkQlmevrxoXxgchx6bdj6lwtmyUfvX7E/Kf7C/pmVVbyXvEPoPRTTHhATfBVG1fhxlOYljBj/b0Bqf/uV1HeGrbKeEr6cGPyTxGShq/JejeTWcN/yV05Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyxJ0yU+BbGpUmJhHVAs8RI/YD/xkotxhDzNmowNBbU=;
 b=kfyZNvt4DWyTSvZcShiZ0TTR+4D+rv/gtNzwLjIDZxb59lpyCdE9cstlcJIKeO9AGA94bTwjmK7se3DtPoSSpaFnOe2/S3WqJLg/aRFMEcRoamCffY8kr+R62ltyRLe+YKBamnei73E3OGuWSaCJcdJJLKh0tSK4847uiitR08oaBKFHsk27GWZTLxJ0JJBK+RH1sZpyIzH4eZ+Qk18bjR9TL04b2Jw7++cLlFB47OtAAvm/XIAyaBXGXofpIh16abovhwyGYxK4/jLOxHliW+NE7sB0gJkQ4K4FgD8J+zuygYrLYgMdV1Wz4ZvEbj94ZQggo9L4oxDS1ph2DQoAEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8585.eurprd04.prod.outlook.com (2603:10a6:20b:438::13)
 by AS8PR04MB8038.eurprd04.prod.outlook.com (2603:10a6:20b:2aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 07:59:45 +0000
Received: from AM9PR04MB8585.eurprd04.prod.outlook.com
 ([fe80::f010:fca8:7ef:62f4]) by AM9PR04MB8585.eurprd04.prod.outlook.com
 ([fe80::f010:fca8:7ef:62f4%4]) with mapi id 15.20.9745.027; Mon, 30 Mar 2026
 07:59:45 +0000
Date: Mon, 30 Mar 2026 10:59:41 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, Rahul Sharma <black.hawk@163.com>
Subject: Re: [PATCH 6.1 379/481] net: enetc: allocate vf_state during PF
 probes
Message-ID: <20260330075941.tdegjkwnrghabzz3@skbuf>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260323134534.371230946@linuxfoundation.org>
 <20260330073356.GA1017537@ax162>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330073356.GA1017537@ax162>
X-ClientProxiedBy: WA2P291CA0033.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1f::13) To AM9PR04MB8585.eurprd04.prod.outlook.com
 (2603:10a6:20b:438::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8585:EE_|AS8PR04MB8038:EE_
X-MS-Office365-Filtering-Correlation-Id: f4ebcbb3-4220-4149-e4c9-08de8e324e3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|10070799003|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eKEDwHnz28Z7P+ym8FuM/hE2R12vNQj2uDufjYkcSCMORqKIOi317xcb8yr/y9xRTFwk1OVadwoImnLbPizDcxrdRGxN6HCw1pGVMUOjYoM0Z0eXz68rxhQF4SbseWaVN+ZVVcjtbBaFAHdnPXgF3n8h42Jcn7CgCyyrgNIgqxuu28uCO1N644HaVtL8VNIOWmSG8urAXetP7rhC2mIS45WbCECwEV2w+YjrC6amKcXLAer1z2w12MWbVuyrTFHL82owneGyQVC8ND95EAYtrPW1E8Y/t47u/PrGTc2eyxwdd2Y8Y4ut6SUnx9b0NwDxnpfdR4T9YHHKaOKtX0gAd1sSofKO8dDj8Pe2oVK60PMW1koK5GqefEyPcRHjvUjPCYArb09q0DOOqyySK7IHUve+ofVpAthnkCv4W5Ufl/SG2Yv0iLnm5OVEFauB6B6SO30w+v5jpzhmeY6DUbxvtkqnL5JlX7wg8syT7WFjU6ero7uXIgFe7c4K+uVCWYNpK8egGVu5NvZyxVCr644RhtLpnZcpTYgBkvTeudHdrY/r8enxGTFKPYUUlovhLEIOl1UpTSmphhucnDQSPFXHTt/uYSkcew2crKsW9AmxiT0C0J9RqNV3PlM+Mw/ptq+De/ZUTee8Mz2pi3IWXBW1YZ2i5dJuYBcbjr6O+jMG0cMlKH3wXejiip6pM+jbNKOV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8585.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(10070799003)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6stdndwKWaIhZoNaphdWMaCy19EUBXNzZddeu4PpJdf36CVIrN/jHGEA6n/Z?=
 =?us-ascii?Q?k44XN3BvL1MhjpKMo/t3LjmvxYQ5S0HeFgJgKrYMtqbO8s5d9HidwawLPw11?=
 =?us-ascii?Q?y3GOeIUk2JBUUDqxbt41kB9tnLFf5jRKSxIKFHP8n3yjh/kXfn5vrxY2Gact?=
 =?us-ascii?Q?ALxbtbae5OKxUxud5oIV/rCAQ8JLJOKv9E7AvyaSLaYEQkGefkH5oOZcaAdT?=
 =?us-ascii?Q?9mi0/j9SSz5N7vGoJl9z2ebAQJL1DSu5+n0fuMCSpLz5i7lv26LPGYdHQbFl?=
 =?us-ascii?Q?RllH12s7JXZ7JV8DTAINYI1096pMB5BISvOorcIEfuX7YMcS78D2ESwFQi2f?=
 =?us-ascii?Q?NP5SWG/fNlq/gDEfAZgTP8KbsZJRRYl4nZAkvj98s5XTUoO8NNDNPTrzdTEi?=
 =?us-ascii?Q?Ew4pKs+QCG41287RepjJ/vcdigVc23xW1sGTv8KZhiEf0A8t0xMI520ngDYr?=
 =?us-ascii?Q?osVarmFG//IGKjW67tvr9VzkKARC9p2zGsmJ9G2JanqDFigr4mB3KFyy/n7q?=
 =?us-ascii?Q?tQcS8KajylTv3iMMc6GQ0n3EHhq70+4xZYke5QxArXwXBXRVe207w1hZgZ9D?=
 =?us-ascii?Q?pstWbnKEWRu0ZMH0saiq2OL72kkrJ7HCXIC8e+hZclp39JUUMesIXdSUvOlk?=
 =?us-ascii?Q?wzc6ayEchh8/0bI4CSwpsg+mhuqaPwoSW4pzrxYWwYy/z+3NZo8OyYnAkoc5?=
 =?us-ascii?Q?eSIc6Cpm4AMB58/dYuvyd+v949B11dS8UhJnIr02wcHo9hciOFxH/IBdbiy3?=
 =?us-ascii?Q?ALfdEJJRBGcg7XsmEBVr3aWRPbXLoYYKLrrNcaCQHnKJaM+zuI6GRhLK/Ydv?=
 =?us-ascii?Q?d35JKhwGxzlU1IwGvTZk0dF4YvogXHKOr8tV7QKWHpCg50LswmPTjiqVIWXj?=
 =?us-ascii?Q?ZHe9s8PGw1e+BW58T3nUhnXj+w7nVBUuORjFQ6ZYXDP7MZ3zDp9e+wTI6XfB?=
 =?us-ascii?Q?CtMnTTGyZ1rR3qsieYWfstL07bMF8fabJPP1wtJQfov8n5X3DC8WdbIJNybm?=
 =?us-ascii?Q?OtARjTRZNAbKDyUuG0UUtLSjHuwTSK1Kt6J2EHv48ShXZGt9OyI8M5Xhtscd?=
 =?us-ascii?Q?ELu/VBS6fnZEODzHOmN6lQWY+GysEQ5UzaoYicfy6NUfgzcLEfaMjTEUxQTN?=
 =?us-ascii?Q?18gOgUmugKgKDy3gnXkz6r6+C1ceCkBhuwS/eCT14OzXOXgxgQ17tHMTTr/U?=
 =?us-ascii?Q?YNt4WAClN15cl2ubI9zz8a22ZuvLmAL2i3jUC47mh597RCIh8CFiA2sencno?=
 =?us-ascii?Q?XrLAX2InzqwLiJctsMVROio0i/HZ14ElDcMKVdKOi6zb23ag5VPW5fc3Ffkq?=
 =?us-ascii?Q?/J0K1t3uvGF6oVf0vRAZ/KF1WTRagkyFI1vMne6jguEHS4kVRIHFCfKYO5MO?=
 =?us-ascii?Q?H2qsoSaDT48X5AwToJsKp90npbHXkNpbcGvRv5ia4AX3zF8NURWpvz9JnYux?=
 =?us-ascii?Q?nPDwyVUO7vW1b4FOylv8hOWfrzvqEE9OgA5/SpCeERpoyETh9cm2Mz2lwyDX?=
 =?us-ascii?Q?qEcKOZXqA5EUHvRAgb3NXUZNgpcsmL0AdYuP0rtztJxOa+v5C9KRBha9zIC2?=
 =?us-ascii?Q?t4cEf7ML/dRfr1NQljKJ6MKrUfxrPhqCvRyrfl9sFl9F8e+rcKdjlqwQsugv?=
 =?us-ascii?Q?5sxtzHJjw07pYLeDmMPxqlV0lBVosovThr5ZfRc+3b5YZMIuMrSUU7GndqaK?=
 =?us-ascii?Q?DTMaDCdXVD+UP+3ptt2hYrpwaJnG6E0uU9iA+oGMkAn8QxxlvmmRjrWAEubU?=
 =?us-ascii?Q?bRsOwYScyj2dHzsUgrbissTYviRROxz4AaBU+Zd/pDKRSa7gPMw/GZ/XidZ5?=
X-MS-Exchange-AntiSpam-MessageData-1: b/KL3BMkvlHACuZrTkl+gC5pZjfGCntxxfM=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ebcbb3-4220-4149-e4c9-08de8e324e3f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8585.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 07:59:45.2568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOpzApOjNL86LILXYZN7MGaBoElnxWUkR7tpfuxu+KGkWfXmuLEkvrrNdPvVCW5gQFwTLaWEoceX3HeQ5H2heA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8038

Hi Nathan,

On Mon, Mar 30, 2026 at 09:33:56AM +0200, Nathan Chancellor wrote:
> On Mon, Mar 23, 2026 at 02:46:01PM +0100, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Wei Fang <wei.fang@nxp.com>
> > 
> > [ Upstream commit e15c5506dd39885cd047f811a64240e2e8ab401b ]
> > 
> > In the previous implementation, vf_state is allocated memory only when VF
> > is enabled. However, net_device_ops::ndo_set_vf_mac() may be called before
> > VF is enabled to configure the MAC address of VF. If this is the case,
> > enetc_pf_set_vf_mac() will access vf_state, resulting in access to a null
> > pointer. The simplified error log is as follows.
> > 
> > root@ls1028ardb:~# ip link set eno0 vf 1 mac 00:0c:e7:66:77:89
> > [  173.543315] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
> > [  173.637254] pc : enetc_pf_set_vf_mac+0x3c/0x80 Message from sy
> > [  173.641973] lr : do_setlink+0x4a8/0xec8
> > [  173.732292] Call trace:
> > [  173.734740]  enetc_pf_set_vf_mac+0x3c/0x80
> > [  173.738847]  __rtnl_newlink+0x530/0x89c
> > [  173.742692]  rtnl_newlink+0x50/0x7c
> > [  173.746189]  rtnetlink_rcv_msg+0x128/0x390
> > [  173.750298]  netlink_rcv_skb+0x60/0x130
> > [  173.754145]  rtnetlink_rcv+0x18/0x24
> > [  173.757731]  netlink_unicast+0x318/0x380
> > [  173.761665]  netlink_sendmsg+0x17c/0x3c8
> > 
> > Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> > Signed-off-by: Wei Fang <wei.fang@nxp.com>
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Link: https://patch.msgid.link/20241031060247.1290941-2-wei.fang@nxp.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Rahul Sharma <black.hawk@163.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/ethernet/freescale/enetc/enetc_pf.c |   18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > @@ -683,19 +683,11 @@ static int enetc_sriov_configure(struct
> >  
> >  	if (!num_vfs) {
> >  		enetc_msg_psi_free(pf);
> > -		kfree(pf->vf_state);
> >  		pf->num_vfs = 0;
> >  		pci_disable_sriov(pdev);
> >  	} else {
> >  		pf->num_vfs = num_vfs;
> >  
> > -		pf->vf_state = kcalloc(num_vfs, sizeof(struct enetc_vf_state),
> > -				       GFP_KERNEL);
> > -		if (!pf->vf_state) {
> > -			pf->num_vfs = 0;
> > -			return -ENOMEM;
> > -		}
> > -
> >  		err = enetc_msg_psi_init(pf);
> >  		if (err) {
> >  			dev_err(&pdev->dev, "enetc_msg_psi_init (%d)\n", err);
> > @@ -714,7 +706,6 @@ static int enetc_sriov_configure(struct
> >  err_en_sriov:
> >  	enetc_msg_psi_free(pf);
> >  err_msg_psi:
> > -	kfree(pf->vf_state);
> >  	pf->num_vfs = 0;
> >  
> >  	return err;
> > @@ -1322,6 +1313,12 @@ static int enetc_pf_probe(struct pci_dev
> >  	pf = enetc_si_priv(si);
> >  	pf->si = si;
> >  	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
> > +	if (pf->total_vfs) {
> > +		pf->vf_state = kcalloc(pf->total_vfs, sizeof(struct enetc_vf_state),
> > +				       GFP_KERNEL);
> > +		if (!pf->vf_state)
> > +			goto err_alloc_vf_state;
> > +	}
> >  
> >  	err = enetc_setup_mac_addresses(node, pf);
> >  	if (err)
> > @@ -1398,6 +1395,8 @@ err_alloc_si_res:
> >  err_alloc_netdev:
> >  err_device_disabled:
> >  err_setup_mac_addresses:
> > +	kfree(pf->vf_state);
> > +err_alloc_vf_state:
> >  	enetc_psi_destroy(pdev);
> >  err_psi_create:
> >  	return err;
> > @@ -1424,6 +1423,7 @@ static void enetc_pf_remove(struct pci_d
> >  	enetc_free_si_resources(priv);
> >  
> >  	free_netdev(si->ndev);
> > +	kfree(pf->vf_state);
> >  
> >  	enetc_psi_destroy(pdev);
> >  }
> 
> This results in a clang warning:
> 
>   drivers/net/ethernet/freescale/enetc/enetc_pf.c:1307:6: error: variable 'pf' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>    1307 |         if (node && !of_device_is_available(node)) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/freescale/enetc/enetc_pf.c:1398:8: note: uninitialized use occurs here
>    1398 |         kfree(pf->vf_state);
>         |               ^~
>   drivers/net/ethernet/freescale/enetc/enetc_pf.c:1307:2: note: remove the 'if' if its condition is always false
>    1307 |         if (node && !of_device_is_available(node)) {
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1308 |                 dev_info(&pdev->dev, "device is disabled, skipping\n");
>         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1309 |                 err = -ENODEV;
>         |                 ~~~~~~~~~~~~~~
>    1310 |                 goto err_device_disabled;
>         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~
>    1311 |         }
>         |         ~
>   drivers/net/ethernet/freescale/enetc/enetc_pf.c:1290:21: note: initialize the variable 'pf' to silence this warning
>    1290 |         struct enetc_pf *pf;
>         |                            ^
>         |                             = NULL
> 
> I see two options.
> 
> 1. Backport commit bfce089ddd0e ("net: enetc: remove
>    of_device_is_available() handling") and its dependent change,
>    commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled status"),
>    although I did not look to see if there are any other necessary fixes
>    or dependencies.

This may have unintended side effects for linux-6.1.y, since it affects
the entire PCI core.

> 2. Address this with a stable-only patch like:
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 99422c0b4a26..e4c8bdff68c5 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -1285,9 +1285,9 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  {
>  	struct device_node *node = pdev->dev.of_node;
>  	struct enetc_ndev_priv *priv;
> +	struct enetc_pf *pf = NULL;
>  	struct net_device *ndev;
>  	struct enetc_si *si;
> -	struct enetc_pf *pf;
>  	int err;
>  
>  	err = enetc_pf_register_with_ierb(pdev);
> @@ -1395,7 +1395,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  err_alloc_netdev:
>  err_device_disabled:
>  err_setup_mac_addresses:
> -	kfree(pf->vf_state);
> +	if (pf)
> +		kfree(pf->vf_state);
>  err_alloc_vf_state:
>  	enetc_psi_destroy(pdev);
>  err_psi_create:
> --

This is also not ideal. I will prepare a patch.
