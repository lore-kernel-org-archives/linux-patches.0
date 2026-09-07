Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11021117.outbound.protection.outlook.com [52.101.125.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546002931F1
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 01:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.125.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788744121; cv=fail; b=NGQplmRp18twdC8EWF5Hm7lqSkSv+0GN8FC1C3z5EJRBp1XF4fzRZFxewZgXFmY/sXS/YUmJh3nvlfpQyz+ksjSL6DQ2b8sAGyLKthFJNBxs+xsvTj37t+ksj88kns64YMosjgqhw5DuKycftUVLugAPC5qAGhtcBYi/f/57p7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788744121; c=relaxed/simple;
	bh=3XRy8yDEdcu2hcvwJTDz8Wx7ZjogZkoiidS/RNVexyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CUVLPRbCkTLWsa3q2J17S/CCmQlx1SYPCi/T2pT5bzpfWe35uKwi2wQkManxKhCNOc4FM9NIYfG4D7dOamM1E0m6tW4g9qnkycEIhAFzaDngf5LlWrCDkOzdblvBZ/mFVEAwdDexkbPCZ5Orv7BgsF1ef7uFiYR1Ijaug+Ra61w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp; spf=pass smtp.mailfrom=valinux.co.jp; dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b=KKOPgSrs; arc=fail smtp.client-ip=52.101.125.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b="KKOPgSrs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2E8pYS8v5czqR2JLSg5mubuE5wRBXxi6CL1+m+XavvZq+QBHCMj43bQ9EjzVyYNX8pIacJDjFRPmUnL6JLUAIKHJVkT8SawAcFmlpzQKzj74iovHQbzIft9dOcc1GRqbk+tX7rw7e6ElNpuGmh5+ucs+9YmHO3UcF4k7yGVFvmJ0idrEBAMpnPWO8bLIEHvQd7tndE5bunabIYuvinjh2YjfMiTzHZxBbqd0YUHUdfdIUf8fLtSzBhwYx1OecAM47eg02vl+sOADNnjVmdnNMREHcH9F7SKx2VCsdztmb4aHHLxAS9av0Aqe9QtCYaoCZsKIG160AQoRFs7eQqrYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0tYvcBYtZt6ZX+och4989DlO+23OF8KBT1dN86S7DQ=;
 b=m6e+FRqieH28d3U3/80YysqjeVyHCPjWkfj6R+ILQSOsT3PJmiUGjgvG7iVufjYURbPvIuQkicpJzq3EJ2/13vn6+/ZFpFZ9xCRKl7/cEbJkGjFQXJocQpvy7ZAxdJ4+hD97uPJ8ZskFjkNYlTPKHlMOebeozIo4k3V3isHh5LfdRX2ng68ywD0Oto5A1XTT9wPUmuQkQHem64sG4iO0Ly6Z+82Cx8lwnbLEtPH1O6x217xBZFJs7r9LNZALF767KfZtUaJ+gJn85z2CLGVk6sDjT/Xs19woX0GZckePu1cg7p9oA8+WfBaALN6CbLKuh0UtjO4tySFtmoTx+o7v6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=valinux.co.jp; dmarc=pass action=none
 header.from=valinux.co.jp; dkim=pass header.d=valinux.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valinux.co.jp;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0tYvcBYtZt6ZX+och4989DlO+23OF8KBT1dN86S7DQ=;
 b=KKOPgSrs598pnl7qUQgeJzpPjhSRhuuBboWzZveaQ3dYZsk93GPHSS1jejNGKWTMPnhye9KX+8TV4KyBnMSvyronoXhifDJeHLn4/NSivmWv5tWChD4pDhvmU2y1+zLRrWtJnNYOIHrT2ugM7EPuIF1zbVfPnIP8XFAZoN7nk68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=valinux.co.jp;
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM (2603:1096:405:38f::10)
 by TYWP286MB3126.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2a0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 7 Sep
 2026 01:21:52 +0000
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32]) by TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 01:21:52 +0000
Date: Mon, 7 Sep 2026 10:21:50 +0900
From: Koichiro Den <den@valinux.co.jp>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	Dave Jiang <dave.jiang@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Jakub Kicinski <kuba@kernel.org>, Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 348/403] NTB: ntb_transport: Fail TX enqueue when
 the QP link is down
Message-ID: <hsqmssqtwdnsxx2m2wdeo5rby4c5j7safbtbhelzlvkitpt3nn@w5n72xrl46nr>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045742.729378177@linuxfoundation.org>
 <7da02d81-ebfe-4448-b6d1-9209cb9282fc@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7da02d81-ebfe-4448-b6d1-9209cb9282fc@oracle.com>
X-ClientProxiedBy: TY4PR01CA0023.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::16) To TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:38f::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY7P286MB7722:EE_|TYWP286MB3126:EE_
X-MS-Office365-Filtering-Correlation-Id: d5271c24-3cb0-42b0-adae-08df0c7e65be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|23010399003|366016|4143699003|10067099003|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7nLAYPt9cvYFbEtNyUk233PgO8wiHCGhqnN6GZR7UlG+jwliHTIPPQxp4BDha8EMj0Lr/EKGg0RlMJJf7atoWceAMsOmkrb/s9cjC0o2Fk7B9iyGkP9VmJy7dwPqN/T0q++JvEGz/433IvCZRBNaaXFYKZxPmadSq0sX5Dh0h1jThG7vIQSEhMeZ5ji42tQXYAvLiE6fagZx4HvI2FbR1qOpIr+XTLwi3i87Zost7JHKW3l0kMGYvGhvTeVPNVAqvmykmSEZ/gs88A+yMUtxYYtF85HYUY2p+TtjLQIVKSFcKYxb1SdW6nSPUj7Q7pRizetTLBhpmRZcAdcszZnAOwoazMMG+hfSMiCAdH75eOyB0F8BcEe1z9NIUIpFUCMJOoPbdU53D+su6c9FEPHg60JvIVapUxQIqcPAsuHrICvqG/CPzPcASybMk3sPNRXKlWiMv7neo2yqPWkZmYeQQ01WFTCPvlW7HucMjwngps4swL/JTC0re67UYyJLagJW/aNrwtZ/88NNXNNzbqBV6YI6MojLxV2IrIJz0nRnLOk+mIImIKVPjxTHu/6SEcdT0HDPcAgsP02mlveXKk2irXE+TkiX48IIWjCOV9Lni06xzQEt8WWj26/9sOszTq1I
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(23010399003)(366016)(4143699003)(10067099003)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LZ8iNtGwPuvq7f1aKZQAJmaon+ZDZGISF5uOQYncykln7pRtWdR4s3GRaIId?=
 =?us-ascii?Q?F/UoMg2yv0qh/+XZutqgf++ow6h57mPaSEAdNIm8IVNaKW1RcbExiBMiTVDJ?=
 =?us-ascii?Q?e8nlxxj1EHvsL//n++OSX+B1K1qe45ExogSt9+LS7NCJCUIFvKTY5w6bveGw?=
 =?us-ascii?Q?w1lXNs5n4FELWJpSCExTdkiFuv1QG8tuLbxQa++bwX1SH8QOzxAxqAwZLMxB?=
 =?us-ascii?Q?D9k0e4z7jYKAzClmrbHKN3+0FLseXLlLOlqc6dnPmjaAskrVdPp/zjfuophe?=
 =?us-ascii?Q?WgsUn2JSx3XY5T1A4otOZnwCwOZ1rNGCJiWIXgKF5Qez92PnIfm2r4jh6w4i?=
 =?us-ascii?Q?VbUaILpiUlj3YzDRLFbWwl0u+WNpQj1RJkB4OEPrY5X9ngEYl79LIMTYcL0b?=
 =?us-ascii?Q?gduB5FBVIm1dN9Lab9mSnAkP9QifKGSV5ixlQ4JyQkqfLAJ+yiqjvc3CLtX7?=
 =?us-ascii?Q?VPtigukpSnpjpNf7J8UqXV+yHnmOVNhB4AvPNdSykzBAKRi871glnBS96zcn?=
 =?us-ascii?Q?Pb0j9mz8ZsoW3PjT+7fmKOypcUS5PpyPz6AN9ar3A2CduGUkP0CQinv85wdO?=
 =?us-ascii?Q?A46EoySqWkjn8hfeJsL+RxwMbECBdJV8r+x5HQycxvN39jgRHZ5z0CygMpob?=
 =?us-ascii?Q?zSkAVggOMoqQUDIMS45FcM4jscfp5iiZzQ7T02kJ2BJtM13NDsA16u08mpeU?=
 =?us-ascii?Q?maXgVyrOepGl5z622MBgjTtSKno11yci1JxjmxGNJOGiIR7V4ceDtqBLOVAm?=
 =?us-ascii?Q?bV9nNFPPIujTivhSbaF0Ygj4iNT+JowuMuqQsz0MOJnnvE3dgVmSfpqe1GwV?=
 =?us-ascii?Q?mQUtUNYPECkYmZOKO2BhNzBsG2x1xNIlVkNKEH1+zcxiy/2R2FazhT2TJZaG?=
 =?us-ascii?Q?jMaeFC+pzhcNcjUXn2nt0Hf50pLGzADNs+M3y0P5rXZV4I69jZoHwtiQEaTc?=
 =?us-ascii?Q?nydjZqXy8iDnk0PIeLFerL/jG0QiVX7r5C0cYvB5IkHnxQzrcmzCNEHndIGC?=
 =?us-ascii?Q?G43m1X/Zt7Tk16eiFQMVYDxyrf7lPZc0VJpW8y0LGxKv5Q5H/SU4VAerzQgq?=
 =?us-ascii?Q?hURX3kFpi11DPx5PBYzd5OWroIngxq2rTKak7yrMVp+dz7b8RgHYJKNiVopr?=
 =?us-ascii?Q?ar2r2jgLX+knJInvEWP97XOXyWifOjv3D9YKa6E5KcT1CCTkckDAomRo+kY4?=
 =?us-ascii?Q?v17yyxbouhShcr7CrUz4wyYpMlP1HUXTpOqC3QC81ghRCHbeEM9XDGPT8b8r?=
 =?us-ascii?Q?ZRflvqzfKAKzXyH+lmjS9D86Ke9aZg6p7FdC4cjO+B2hbYDFV78Mxqne+Y13?=
 =?us-ascii?Q?5H8BbVSmqSMC/MqMMqTJMW5VaNQQxX89B3C59drJFuRV4f3Ft/3dbdxuG3Rg?=
 =?us-ascii?Q?Z2jzswF2xUlYfmNha041jJwY7WTVXWH3ZOiJdS7IzioAfOQ54zV0WdekTEbX?=
 =?us-ascii?Q?xmQbOyH8jCOMm2cV9rPL3GX0WRWZ7tZtvB1IwNk/32jEak9ARVPonTA5gWa7?=
 =?us-ascii?Q?AISNbc5+6lBSbeP0x9y1+K1SQKmZyldlsiEZsM+5f2UEVr1wRmxWMWzJgmX2?=
 =?us-ascii?Q?ZyyMudCYfnOf3Wlb9WHyON4AENcwsOvhOi0JP2YOYE+vG1LjA81xzGCdF0z6?=
 =?us-ascii?Q?lOdXYhaHE/r811+AUopn8MftoUWNe8g6U0Jya99UYKtMfrpCuyR2WG28pivf?=
 =?us-ascii?Q?63Pi+rhKrwqXRHX+CPm6BLeZ9tp03Tl8hRccQ57u2V0h0CdPBm4FSD9alZHS?=
 =?us-ascii?Q?w2TZAkk+8ndKja6VDhWSH/VZ89oHY/1QlHv7SgN6K3cHtQ+vPiud?=
X-OriginatorOrg: valinux.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: d5271c24-3cb0-42b0-adae-08df0c7e65be
X-MS-Exchange-CrossTenant-AuthSource: TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 01:21:52.4883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 7a57bee8-f73d-4c5f-a4f7-d72c91c8c111
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AjqbIyM3P4rsY+Cu4T/XM2wt9PZHbwD/SlpVXsKfUpHihz6INmURdUI0wVINvnG0KpXvTKy1+qjqILvm4nKzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB3126

On Sun, Sep 06, 2026 at 12:00:42AM +0530, Harshit Mogalapalli wrote:
> HI Greg/Sasha,
> 
> On 04/09/26 10:32 am, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Koichiro Den <den@valinux.co.jp>
> > 
> > commit 873ce713fef5dde0939220f04f3484ec86a16fba upstream.
> > 
> > Commit f195a1a6fe41 ("ntb: Drop packets when qp link is down") meant to
> > make ntb_transport_tx_enqueue() drop packets submitted while the QP link
> > is down, but it only returns 0 without consuming the packet. Zero means
> > success by this function's contract, so ntb_netdev reports NETDEV_TX_OK
> > and forgets the skb: nothing queued it, nothing frees it, and it leaks,
> > one skb for every transmit racing a link-down.
> > 
> > Return -ENOLINK instead, restoring the contract that a non-zero return
> > leaves the buffer owned by the caller. With the preceding patch,
> > ntb_netdev frees the skb on non-retryable enqueue failures and returns
> > NETDEV_TX_OK, so a packet racing with link-down is dropped without leaking
> > or entering a busy retry loop.
> > 
> > Fixes: f195a1a6fe41 ("ntb: Drop packets when qp link is down")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Koichiro Den <den@valinux.co.jp>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Link: https://patch.msgid.link/20260817053519.4135287-4-den@valinux.co.jp
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/ntb/ntb_transport.c |    3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > --- a/drivers/ntb/ntb_transport.c
> > +++ b/drivers/ntb/ntb_transport.c
> > @@ -2307,9 +2307,8 @@ int ntb_transport_tx_enqueue(struct ntb_
> >   	if (!qp || !len)
> >   		return -EINVAL;
> > -	/* If the qp link is down already, just ignore. */
> >   	if (!qp->link_is_up)
> > -		return 0;
> > +		return -ENOLINK;
> 
> I have run an AI-assisted backport review and it spotted an issue.
> 
> Upstream commit: 873ce713fef5 ("NTB: ntb_transport: Fail TX enqueue
> when the QP link is down") returns -ENOLINK when the QP link is down.
> commit: 8aaa47351db0 ("net: ntb_netdev: Fix TX busy and drop handling"),
> makes ntb_netdev treat only -EAGAIN and -EBUSY as retryable.  Permanent
> errors use:
> 
>     dev_kfree_skb_any(skb);
>     ndev->stats.tx_dropped++;
>     return NETDEV_TX_OK;
> 
> The 6.12.y caller instead sends every nonzero return to:
> 
>     ndev->stats.tx_dropped++;
>     ndev->stats.tx_errors++;
>     return NETDEV_TX_BUSY;
> 
> It neither frees the skb nor stops the queue. After commit: 6c34659c7712
> ("NTB: ntb_transport: Fail TX enqueue when the QP link is down"), -ENOLINK
> therefore becomes a permanent busy/retry path instead of the intended
> one-time drop.
> 
> I think 6.12.y misses commit: 8aaa47351db0 ("net: ntb_netdev: Fix TX
> busy and drop handling"). So we should either pull in the prerequisite or
> drop this.

Hi Harshit, Greg, Sasha, Dave,

Thanks for catching this. You're right, patch #2 of the original series:
https://lore.kernel.org/r/20260817053519.4135287-1-den@valinux.co.jp/
is missing here.

I've adapted patch #2 ("net: ntb_netdev: Fix TX busy and drop handling")
for linux-6.12.y. (Note: only build-tested.)

Would you prefer me to send the full four-patch series for 6.12.y?

Best regards,
Koichiro

--------8<--------
From b64974a682c800ebbac4d1935541b933fcca593f Mon Sep 17 00:00:00 2001
From: Koichiro Den <den@valinux.co.jp>
Date: Mon, 7 Sep 2026 09:58:58 +0900
Subject: [PATCH] net: ntb_netdev: Fix TX busy and drop handling

commit 8aaa47351db0f93a5c5297fbafdfa8bc75e8ae49 upstream.

Currently, ntb_netdev returns NETDEV_TX_BUSY for every enqueue error. It
also increments the drop and error counters while leaving the skb owned
by the qdisc, and may return BUSY with the subqueue still awake.
Retrying a permanent error cannot succeed either.

The unconditional BUSY return and premature accounting date back to the
initial driver. The error-path queue stop was later removed without
changing that return value. The current flow-control code includes a
resource check, but ntb_netdev does not honor its result before enqueue.

Honor the resource check before enqueue. For -EAGAIN and -EBUSY, stop
the subqueue, arm the existing reaper timer, and return BUSY without
touching the skb. For other errors, free the skb, increment tx_dropped,
and return NETDEV_TX_OK.

Fixes: 548c237c0a99 ("net: Add support for NTB virtual ethernet device")
Fixes: d723485cb4ca ("ntb_netdev: remove tx timeout")
Fixes: e74bfeedad08 ("NTB: Add flow control to the ntb_netdev")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260817053519.4135287-3-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[den: adapt to the single-queue implementation, as 6.12.y lacks commit:
 ee970634c777 ("net: ntb_netdev: Introduce per-queue context")]
Signed-off-by: Koichiro Den <den@valinux.co.jp>
---
 drivers/net/ntb_netdev.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 05bd6ad9c88f..86f6c17f911e 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -167,8 +167,10 @@ static int __ntb_netdev_maybe_stop_tx(struct net_device *netdev,
 static int ntb_netdev_maybe_stop_tx(struct net_device *ndev,
 				    struct ntb_transport_qp *qp, int size)
 {
-	if (netif_queue_stopped(ndev) ||
-	    (ntb_transport_tx_free_entry(qp) >= size))
+	if (netif_queue_stopped(ndev))
+		return -EBUSY;
+
+	if (ntb_transport_tx_free_entry(qp) >= size)
 		return 0;
 
 	return __ntb_netdev_maybe_stop_tx(ndev, qp, size);
@@ -211,21 +213,30 @@ static netdev_tx_t ntb_netdev_start_xmit(struct sk_buff *skb,
 	struct ntb_netdev *dev = netdev_priv(ndev);
 	int rc;
 
-	ntb_netdev_maybe_stop_tx(ndev, dev->qp, tx_stop);
+	if (unlikely(ntb_netdev_maybe_stop_tx(ndev, dev->qp, tx_stop)))
+		return NETDEV_TX_BUSY;
 
 	rc = ntb_transport_tx_enqueue(dev->qp, skb, skb->data, skb->len);
-	if (rc)
-		goto err;
+	if (rc) {
+		if (rc == -EAGAIN || rc == -EBUSY) {
+			netif_stop_queue(ndev);
+			mod_timer(&dev->tx_timer,
+				  jiffies + usecs_to_jiffies(tx_time));
+			return NETDEV_TX_BUSY;
+		}
+
+		goto drop;
+	}
 
 	/* check for next submit */
 	ntb_netdev_maybe_stop_tx(ndev, dev->qp, tx_stop);
 
 	return NETDEV_TX_OK;
 
-err:
+drop:
+	dev_kfree_skb_any(skb);
 	ndev->stats.tx_dropped++;
-	ndev->stats.tx_errors++;
-	return NETDEV_TX_BUSY;
+	return NETDEV_TX_OK;
 }
 
 static void ntb_netdev_tx_timer(struct timer_list *t)
-- 
2.51.0

--------8<--------

> 
> Thoughts?
> 
> thanks,
> Harshit
> >   	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
> >   	if (!entry) {
> > 
> > 
> > 
> 
