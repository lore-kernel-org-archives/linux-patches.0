Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013056.outbound.protection.outlook.com [40.107.162.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C408386C3E
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774858796; cv=fail; b=DHvgzORL3nF9/fbuxvPD1GNO2llh5jSanfS0rJb3C4bw3hYdDSm1r+stxnnwo2WykY50mNk2+jhsomnPl4mO0aafk4PSKWyPME4UOU7CLKw6QzpxiahLF2LrlfNtt14g7/mxDcMsXuTbeOWgsEQX2Ha55p35SHLfdsG5s4IALgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774858796; c=relaxed/simple;
	bh=BV5xTqwsrDlP4rhIIbXZ395J296/lMlT/AMpW8q/yl4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EPqpNFtmgGqWDaiIoOXwF0AZYxhx0aHypKFA+DP1EYrXVypEuUuB17RhMmzp1yyoS/cAhSPZZyZ2M3vcu5oM7ia+Lj3MEfJ/B9BDBGExPf1XKfqtRcn4OE9Cfdmb7XV7gX5BQjKCJGBzcGY6GMcFiRdFp64wfdrNUt6/l/vUE8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=L1RmPXDm; arc=fail smtp.client-ip=40.107.162.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="L1RmPXDm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rozGA1bvq1ny1WivPCFsx8sXpaGO6wNMegrGbJWWIsdRjE6areyVzJwBuA8qtr7ebfnYhnBuOfXg3k4n/vYkx9OjtEbiQ/KqIJ5xqM9UvGcL/uO8m+SquFNIDOmkKVL5pB7p6weGGfXUhAONO3qS5oCwFTn2KH6EhuG0+gbx5gfiIr1tq+fQQpQq3xKuOZGDX/8+ANreO1AF20gHWEJ7bEKPsQVXGVsngxltsJ/ZCRv/EF1J4zxcVwpYjFTaTnhK2+XDM7zslhLJYDwQxAg7OE7f64SlRest8NRIJ4AykzD3pD+xLOvtNM2wZKFFgzip0OEJdL/A0yttp1mTFQihpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyWkxMU5zf2TVgwx9DXIHgz2HeG2tegQePYDZOKRrEo=;
 b=m2boFrZpm0/2Np+mOowg/zt8TEetU1iw37f/Ow5o1zbrtNImiVvDkfKBsLpOuwwgRcKnRQv53VNPjKokUS6jKJVCLGMLVnutdedCsFe9HS9s9RvduNR5an0vMuUCLse20eYeo/xMK/8NvwD8KSTu9Wwdp1rNgBG1sYXrxyvDlFxbvXDwL/oIfJdGIAL4La5PPJz20Eina0z2t9VucyHny82P8WpUm37d5/PBlRGlmltyqZK5OCfbR2rOxsnt6YNVmeJWWZUt8xU5I7tu7mOnkajk0hoMjbSELo+b5scSwSR7GxOUmRU7U9X3ocWhXwgtVBcu5PfNd0tIwXn77EO3Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyWkxMU5zf2TVgwx9DXIHgz2HeG2tegQePYDZOKRrEo=;
 b=L1RmPXDmBw/pkczfZJUcFadLH+i+iBFk35HLnjyUWkAM8vVGPdl5NNWPraxVtcYhQPVpI3OSr9UI07ZgNQqQUt2ArCfm3XpeQr9fR5xwwLOJFgqSdEkUXI/3i99Oqe0f8cb7sO2LLNXFDRu/V1Yip+QRTwNVWAOID7NjQlnBGNsXCt1+DOiKRF/dA5F5AEbjOnDd5iwzRfaP+AmHkiisQdOOLIpSeKPSzf2JQ6BGvakuoXIB+h/JnYlV2+8WHMxkpuSvi2F99f2+Lqnlnsh7lrEJTxHxzkrOCSIjaDXthpCxwSJQohnwwkDw4yljb+CSEMLnTQYg6mdgYubOudvn/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8585.eurprd04.prod.outlook.com (2603:10a6:20b:438::13)
 by PAXPR04MB8880.eurprd04.prod.outlook.com (2603:10a6:102:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 08:19:51 +0000
Received: from AM9PR04MB8585.eurprd04.prod.outlook.com
 ([fe80::f010:fca8:7ef:62f4]) by AM9PR04MB8585.eurprd04.prod.outlook.com
 ([fe80::f010:fca8:7ef:62f4%4]) with mapi id 15.20.9745.027; Mon, 30 Mar 2026
 08:19:51 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	netdev@vger.kernel.org,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wei Fang <wei.fang@nxp.com>,
	Rahul Sharma <black.hawk@163.com>,
	linux-kernel@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1] net: enetc: fix PF !of_device_is_available() teardown path
Date: Mon, 30 Mar 2026 11:19:44 +0300
Message-ID: <20260330081944.527545-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0253.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8b::12) To AM9PR04MB8585.eurprd04.prod.outlook.com
 (2603:10a6:20b:438::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8585:EE_|PAXPR04MB8880:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a59aff-573e-413e-e1ac-08de8e351d9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024|19092799006|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RJZ1d5Yf2XFY+TdbKmPkS7VdFUIcJRrCa0kOfnvP454PPX919pSyo6AjKhpFugibYxJJoO6FtUsjQplAWphJJ5qielaFZrj2vnb9/dOL4IYpqnR0r1kXPmIsHzIzEWfAidzWnn4Kxk5JtcwmLDt4geT+M0D80FX8BjdErcs2XdFr4cw94RhZ2j0A50xvZbSEkWjlg0qB/zWXJ0Q5pBTDwfGndi+mL/sOmlcyvENjy77gcaV6pdo/kgez30eFQjHhNme5mCJTM8pJrBoqGZrJN8eR6yNCsn/sB/kpurh0bKbu/oJ7ik6JoFF55AMnxqbrR0e2lyYYGvLPyw0fNPwumEoL2S1QBJ5OP4qTCss8tLKbs7fH320ynlZchim7dzNNDbXbRa/eWWZH5ZmCREAhHPG5pJm65oYton1thlM7UKReIEo30vYSnfuC9tLJ6k3JOkA4XYz/blNJ6q7OmpwicmacppH120yKfnFEnA4X02WeEiBxc/uf2FMGQGFWnNcEkIK44CQ14LjTT5Ozo7J+3G8g7BmxjJy47alQvK304PIBmOlFn0JWH2rQ+kRyRaux0eRJdgiNOShmAaRvs8uhwaJ9xBvyeiX1xc+hrvJ/BJlkt4t5gppcvX3ETQaLnRUbsXGQ6iO/FcrKRJpaVsImJ2qnGeAbsSse+0MgWsq/wKnpTHcGlySwwGjTVIVBP7qPuMEfOpMbWxa+B7n/DuDxYFrmNsDbm30o8q3RbFPJJOLedACVgC8e2yzjVeSbScu6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8585.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024)(19092799006)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4DGxcjSiT+iXRvpERcUGV7mgQIxL38wECN3VCQ0/P1a2qh4Wu26SFlC6ALnP?=
 =?us-ascii?Q?wzbLgWZ+tkgOV9ZOg5tidCMliDCrFHT5IUtvqvmzxLBmKT8EVNksv7J1ma3l?=
 =?us-ascii?Q?eLlcEbJgZAZaeKr7Jkc/QvOilUWSaiByWsQ/ocnBFGDJ7hXYAFknxmCDR2Aj?=
 =?us-ascii?Q?eeP+irfF6cn5//UiA5+MkgF+YUcLd/WTYKfSiCgdwbWDJWk5V2+M4Gkl9pVM?=
 =?us-ascii?Q?hgIefWD463XhLPMk0tTC9+TcOIttElxsjqwjEcKErisJV5rbzPx6X+kxNg41?=
 =?us-ascii?Q?GsJ9IzYHQwPiwdfp9xtZcni7yV+boVwYUcvFVqrCEpaGSwfX0BPkEEloFjhz?=
 =?us-ascii?Q?bo7cfPAMtbV5FB8fcT9hmXwabb+hgGVDMSvLAqn6B9y0yVdDV60yEfq04tOl?=
 =?us-ascii?Q?hAVTl9lGt4Y4zy0spa8t78v3lZcW2phKd4q4d0irWf27EAJJ0DlvJJqWyFnS?=
 =?us-ascii?Q?b/3HRTvoeqz+OXY7oAkrTcc3/8/61VCiUZEu3NGeBLQwjRmXYREB2WFIDl6z?=
 =?us-ascii?Q?o5RxBpX3MBfuDjOBat7loNSy/YJv2Ygty5Q5R3gSNcnqj3lneCwRRdU5XU9K?=
 =?us-ascii?Q?rSy77NdYy8uTvYEQmInngZi8UgoLU1MWDgvX+fByOciLrGXnfrN2J7EHnGms?=
 =?us-ascii?Q?CQxA9XoatyIvDPxpjTk5CdSY1PO9jjznasHGccUlYJgPBQzyE2FNitCbgUom?=
 =?us-ascii?Q?ouuJWle5psh/zMy/fQIM5sTX9ZWGLtPFykEHJ+kENi3telPOMlnULLCgNw+7?=
 =?us-ascii?Q?RCAZcukhzkwGKh1zNlrkM+n1TNawfuLYMB9f10cN2/9uQ9xiwYoejq/scJu0?=
 =?us-ascii?Q?aGrWpN7iGP7Wit3F3471eiUv1nCsUFLZUy3tCR62K+QIyd5a3hlWMOngAUzC?=
 =?us-ascii?Q?8DAs2aKVT/MywT+MbxSDsnqQgyRtTvxyGyMoMyfZJZlA2rUdjSWaxGYr2vRK?=
 =?us-ascii?Q?gltVg8/1J7xayus1YSsO5e2096Aa7vdPDnLCIxFXRfJ+OmbTWTelfSDdYE+z?=
 =?us-ascii?Q?wZ7XMjwoFRt8ofaglq3ZOMdC4qmIv0VFDSyISB+f+ThJlyzcJrSZ7sx8mzLB?=
 =?us-ascii?Q?V9r/UKz1CDnoiZqMAo6lGBNiXJ0aT6KcFRsA7hG3qmC5BWL+4V8n3KYnqHer?=
 =?us-ascii?Q?vG7w8flREBnVtTxLyd+cZ5yj0eJleu0vsj1O6upEfXFhzW443M9soLatYmFl?=
 =?us-ascii?Q?6yL883hlmvXi9lIxRFETvV03Sie5xcaTFqd4PdIxFYwcSHqtoPTTdw1sMu7v?=
 =?us-ascii?Q?qDvIZVfTcLhzZasYKmj5nqt0w9AUFbIgd2jXmATOMIw6Edxw9ubcpncy9SxP?=
 =?us-ascii?Q?zoCigp28PgasXcOZFtVl2wIsZDNIAWICy1IixkIhlQqj02iG+lN9aoNyWc1/?=
 =?us-ascii?Q?un6yaPJ1v0QSPY6eqYUTZ0LfnojYPcJ1KoTfskjhlXYY1VhKvwHWTzXmJLn7?=
 =?us-ascii?Q?CuOBO6nfcfLTbD9wl36jDju+wVJQo+WysbKog5UZi0s2erzaW3ELoOE8upVl?=
 =?us-ascii?Q?Nk/xEq1NxjmlZUy1r4eksa5NAvLF4wDTUaKoJmI6EUfEjXTJ2gVsFoqXAFQD?=
 =?us-ascii?Q?eyeRrmIqK0L17UNbtmfVg0pBkICtS30Cc+o6U6c0hbjoyWcBlxVBaRFU9vCq?=
 =?us-ascii?Q?SPFbjbbd9l30sPhkDjBqyVQkvtZeFef+Rrqnok9//+A5PpX+QUuQvMJgIGK0?=
 =?us-ascii?Q?FZfxzxdgW/xXFwkDy3cfN1TdEciccr8wLj1NlyqUzz+zI4vwOXlbJlYi6PWn?=
 =?us-ascii?Q?ZIkuxe9l8WbQanpuWznbvjFL1HD7qgO2X6wK/RrgNDwjkf6NxxmbFuOTdHpB?=
X-MS-Exchange-AntiSpam-MessageData-1: HFnpWrIxsp8NS4Mwi8pwxjfkeOWb1st3aLQ=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a59aff-573e-413e-e1ac-08de8e351d9f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8585.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 08:19:51.7771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwQEczQNC/lbXLXnWtlnhiPtcEc9dIf+8+1OvlHzWL7svbP3mUoPq5jJEW5n1Na7/18ga86u/jd3Pcx4VV3QoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8880

Upstream commit e15c5506dd39 ("net: enetc: allocate vf_state during PF
probes") was backported incorrectly to kernels where enetc_pf_probe()
still has to manually check whether the OF node of the PCI device is
enabled.

In kernels which contain commit bfce089ddd0e ("net: enetc: remove
of_device_is_available() handling") and its dependent change, commit
6fffbc7ae137 ("PCI: Honor firmware's device disabled status"), the
"err_device_disabled" label has disappeared. Yet, linux-6.1.y and
earlier still contains it.

The trouble is that upstream commit e15c5506dd39 ("net: enetc: allocate
vf_state during PF probes"), backported as 35668e29e979 in linux-6.1.y,
introduces new code for the err_setup_mac_addresses and err_alloc_netdev
labels which calls kfree(pf->vf_state). This code must not execute for
the err_device_disabled label, because at that stage, the pf structure
has not yet been allocated, and is an uninitialized pointer.

By moving the err_device_disabled label to undo just the previous
operation, i.e. a successful enetc_psi_create() call with
enetc_psi_destroy(), the dereference of uninitialized pf->vf_state is
avoided.

Fixes: 35668e29e979 ("net: enetc: allocate vf_state during PF probes")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-patches/20260330073356.GA1017537@ax162/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 99422c0b4a26..8cb4c759b165 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1393,10 +1393,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
-err_device_disabled:
 err_setup_mac_addresses:
 	kfree(pf->vf_state);
 err_alloc_vf_state:
+err_device_disabled:
 	enetc_psi_destroy(pdev);
 err_psi_create:
 	return err;
-- 
2.43.0

