Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010006.outbound.protection.outlook.com [52.101.84.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082F02F363E
	for <patches@lists.linux.dev>; Tue,  3 Feb 2026 02:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770087336; cv=fail; b=sfKccLH8pN5tm3BTX/MXXLuIzJuNegA+sBPBzd8uDeYkK1V5WT+7zMx5rR0tSNhGfydfr7NzhkhBF880qOz4fpRw/iXkGno1UrZ2rqwAcKFSBABzJfSwf38b+cBLHIWWpPPd3XlfsjUO92GHH1I5imIHbGSQqwpHt9CYBgM5fN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770087336; c=relaxed/simple;
	bh=L2cKrp+uTHeZXwAzngdsQ960LDT1T2moovc/m8m2OEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LBkUk3tIslTzyCS/UE4Mlj4FHziQSZY1ljd03KfB2HNCiJHdowrXGTOF26MTZrbGgXwyeu1AKSYyBCpsVq9gtObzM1CExrzpv0ZuNXeMAgfTNUK4b5pwJFAk7/tW9vxD5F2EBYoPuUFmbmqCGmB1v1t9ZCbLP0ghQKKM0SWroks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=QgwpS9DJ; arc=fail smtp.client-ip=52.101.84.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="QgwpS9DJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r7et5FMpgqdEmDH77A868pyXV6GBvA9yTNAATu340iYjuonG0rGg40RFz4CVmIMAPiCOSuZyaJGt5ZqbDmqwZoPi19tg+SJWhs02SuvtSv/DRAPmljdkcGXJD6bfeonoHyUGQ0QaFCxWSRgYc74sYLd98csM3OVeIA+Oh3ququcMcUCotCzebc2PHthf/arw93Sm4iTyq1HWInolxrhYlrYf0lew7PDS2ATwlzo4Ivn+jWsvVdjD3RkmS8P13Z1meDFimp38rIKvVuAIulCVX59besDX03Sn7VTAduEaQVP2BTk7j2V5T0BNyllf697H5CfM05ouAtcs4AdTHtIRfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2cKrp+uTHeZXwAzngdsQ960LDT1T2moovc/m8m2OEI=;
 b=Bfj6iO/ASLD5t+hlErQD9HA0T9e+DcFpe80LYwOdDs0s2Gb2Ov3ZZOMivLubg8b5wXQBIih/s998SL1NsIqfs6Wgl2Q1Bw8p2vWrcWv4QgzNOXpM99ATmZrwccbHCR8hhmJqucv8tOCLPTLiXBbdwafuGJaNYpLwVkgzMl+bUsPUqRcedbf/FRjwb5zveQJwjYYe/YVKPic7dLjZXtlXeC4G/4YwxSHPB/jcFs+7fJ09VLL2lxhfY6/o43GaL5/+3mjSZTmGsNTZDrUv+DlPp3YqKnaekjsL28UIqva4wjuJqxwqrevt7mikYYQFJi6Cycjnq2jeGOT3oejs45gfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2cKrp+uTHeZXwAzngdsQ960LDT1T2moovc/m8m2OEI=;
 b=QgwpS9DJ0BRyx9zUuQmVwI1FCtLDPKbB/CQBQMEIY+K+OrzEvPyD5A0C+RDLIuKj2OVicnmX5PB8SizLJ1TW0OEdyF9gy5jp3daLBOj4CYwk3W1HATJFJYqmT2DFp2JfuzYHxJEswb9LUjYqLH+eSQof71gu/LHjT8MXK2O5gYX+vOJz/oKXCuWYbrZy9J0TcyaA3achmg4NSbn3aFxmExuNVRgipGS3zV2byLncEWquCnknKwC/nvj0GxQeAqnLAF3l0fHvNbFqj77VD6gy9ZbJivFVIxkb6NFf1HyF8Ye96j8uiiF2eqr9Z+vvSAb6Pk8Aw4yaX0jMteoLqd/9QA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com (2603:10a6:102:1da::15)
 by VI0PR04MB10162.eurprd04.prod.outlook.com (2603:10a6:800:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 3 Feb
 2026 02:55:31 +0000
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::4972:7eaa:b9f6:7b5e]) by PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::4972:7eaa:b9f6:7b5e%5]) with mapi id 15.20.9564.006; Tue, 3 Feb 2026
 02:55:31 +0000
Date: Tue, 3 Feb 2026 10:57:10 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: Re: [PATCH] Revert "clk: Respect CLK_OPS_PARENT_ENABLE during recalc"
Message-ID: <aYFkBrMthr0RfkhA@shlinux89>
References: <20260203002439.1223213-1-sboyd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203002439.1223213-1-sboyd@kernel.org>
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To PAXPR04MB8459.eurprd04.prod.outlook.com
 (2603:10a6:102:1da::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8459:EE_|VI0PR04MB10162:EE_
X-MS-Office365-Filtering-Correlation-Id: 2519720a-3359-40cb-676d-08de62cfb170
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|19092799006|7416014|376014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/f4aR+fNYrmQ4u6dBki7Vy/YXErXMNWMBAxxBHa2mrICzdc0t+HKXtGXGsM3?=
 =?us-ascii?Q?/z8+unDZsJIIermGljW6HDHYJnVXtly5M1UiQk6YlV1HS8Z6SqnMNMfUz1+P?=
 =?us-ascii?Q?FsZubaHN9C0hwjfhmK7zNJUmwAG2azez6NwgGAXkC3VFCZN+BxWZaAMp3WBB?=
 =?us-ascii?Q?Uq6gpytI1SxkTR037Ugdamwy/aPVmv0jN5Tr7xNIyvJ3aIzLB0pYxb9hy4rf?=
 =?us-ascii?Q?58tUGazLxcM1IWxsRHsX4rkWlYIwVShw5dnjOzAxdxYRDp8vnTBpFSa7geRw?=
 =?us-ascii?Q?KCxV6A5RMcOIUBd2efUmyat+LxjZ1RxUApepUVhpPzSkfg3T0o+zQE9R7tM/?=
 =?us-ascii?Q?BdrGwqSXwPUreDjOQPTSLwbOsVoKxZwRDjGLIuTgAy1paseaGskYq2cvfbZc?=
 =?us-ascii?Q?ZWZ5ykvclnyIYCR3AGDpzmhmx3dBamhwfL8BOXEDFSKiFNPmC0cibuT/Xzbs?=
 =?us-ascii?Q?chuoRn5+q25WF8shdmtPGD+DgNcaL9ylsKQ8aTM3t7+eKgIspNLVLwRUdgyc?=
 =?us-ascii?Q?pWaSo0hOmB4I/8xU7cXpPQc4msbaxHzgB8cW2R++R6BFCcvA7de7IwudUG8X?=
 =?us-ascii?Q?fZ1OXG0fDfrqTl8yVh8Rw1vDFh68gEquGBoaXo2IyI2FKzNXrNTLtvmZtZDA?=
 =?us-ascii?Q?B0e2MiUlu8pQE4ArXIEC4uQAlcEUX6rhEnBz2ChlTst9q4cWm+lkCN+6EY3L?=
 =?us-ascii?Q?8YD3k3L4JYLDeQU7yPRd0wUYo6kUqQtNUo3zK5pIHPqEB8GFlKIevi0Gs/ws?=
 =?us-ascii?Q?BEjCh8jxWf1gS+nIgxfR58RUzf7+EVY39Zx9Fi8epEo945uGBRrSX8K4m34S?=
 =?us-ascii?Q?SdPnQiTwvCjG5GnLNdhY2WqVAADPe3swZoJv6okbxd6s98n5Chmca2bWaByF?=
 =?us-ascii?Q?X8ZD9FSzLALHDH63vtGXKIARMLMigo9C7sIntOfE34WZ9pyZcZL2bvyYBzZb?=
 =?us-ascii?Q?/2aq7U0mlzvnQbtWgn3+N8suxrNgC6mdwG82eQ7J1vTHLK04cf4VY4nFkRAE?=
 =?us-ascii?Q?W7HfYCVgaqbVlTU4Hk0wecdPoKQVvcDGxF5XTvu+EbK6OavBeShbFcjhEEji?=
 =?us-ascii?Q?V2B8CEs354qvHkek6KrT+Ts8VFGXkJILo+fczP2g3OOLf5NMUBhUoIhvSL/9?=
 =?us-ascii?Q?DPZF+wLNxuuog6B+d4zLhWICiIS9teuZe1nPAqxBPaRSmY59KK7anuspkX4w?=
 =?us-ascii?Q?dR3aOFkR67dxHg1Py00mZvLwDLBGSak27PmGJ8lTdqERJgneyvZ/Xvoz6VYT?=
 =?us-ascii?Q?a0W2s2XIhKtd9cfr2MRCTpl8/0qPZkEz6xizklSfI8gUPXQ9FMCI4lx0kRIn?=
 =?us-ascii?Q?SHHnHrtcazZ9ZfUe9rmyr/+IcxGSvzzgK8lgSOtyC8Zjd6dDtx/OcjtNM1SD?=
 =?us-ascii?Q?M9OpOKeQq1CcVzs67p4AVYB4MyFwd8OBwj+krTKNKw1gi7Fdz/UzCjozGtWn?=
 =?us-ascii?Q?58+amrZclumBbMF7HseGXmvGLtZfiGajeioj9ARTJT/28MrZVIIRTiyE+Jno?=
 =?us-ascii?Q?Q5LkILaOeG50+ns6bEcRnyERFXgKWyvbFp3PXf7R78oFqILzoc/4JZlwrgWV?=
 =?us-ascii?Q?vh8Yb2u6v4edjUyucp1LSRYybVqPP/1LD6IwJ4R4tTQYrr9VNqCgvnqPYL4m?=
 =?us-ascii?Q?WJoIA3rUqeSMOoMZ5Qb3RBMi7g3VO0q25JCC3tVUf3ZX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(19092799006)(7416014)(376014)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7aiQyfx1O7LXnP9BZHQdAM1OXp2zF4GvUYWpwWnfBiauZNduNEyRWEOJStBp?=
 =?us-ascii?Q?Eau4ee0LgD1OVleBKcn7nZBDlf9O6TCYlHxW7nZf/J6MHVXvALtq36IrxZNP?=
 =?us-ascii?Q?wFU+aw02DolQS8M6G8r1KFRpSePThe1TbNGWmzHtWI7//9e470cOZMo0mbsd?=
 =?us-ascii?Q?/KxgTvSURpx3WB3tfK1DbN2BLrAwfce8GV4C9TMzZ/xqevnGcRSi64vZZHH1?=
 =?us-ascii?Q?r8VWWTczgf2L/n6QXYX8PKMiL8QFbkL/GrHdGXjhRUFJ3QfJi5XmH3w59VP4?=
 =?us-ascii?Q?Cc5tk4iqqxbiplRg8TdRxy5ALQPOuslK6jzQYAYZTCiAvpOivnRvACKZvmEd?=
 =?us-ascii?Q?y8M2lOOg71Yo+y9rgQSGC/0Td2+4XwfD3b+IiliQmrPae9uoCdIq+bOIQ5Ou?=
 =?us-ascii?Q?jmBOg6yTjNE/mn2d5VjEg43RBKYMTaPCXV1ujxR0mK6dLXfbYlTsCWDkIpCs?=
 =?us-ascii?Q?vFmSj5s8foAqNx6n4vikyY7NtMjICl4Zo+4mID37fblYCNpasPYyovbMKuCJ?=
 =?us-ascii?Q?jt33leckO5qISvsEL7lZTEyQHwVXP7jvoCFMYHO+lig1VkOs7QUCnwKY0yOf?=
 =?us-ascii?Q?MryBWDWa+LxqyJtqk4uA4jl2ef0ac4RCg1C0ny/AxquMOHxQx/t7K4W1jfoq?=
 =?us-ascii?Q?xLavMVoxdWxUky79PuoEsXEW6xchPku2F7WF5x3yKMMJGzALEDnXgXSfGfcR?=
 =?us-ascii?Q?MPNXlDKWrowXhqQeKC3YLykesKHyAVaUGYCaBbDlSKIbjby6NQHT5Sfi4EsD?=
 =?us-ascii?Q?DvQoFTxMILdArDySELYM2gJsvSEkdWzu9jnPYZwBNxmNJuy0g7SyuQYFbOyJ?=
 =?us-ascii?Q?TkKV+vNtY+hoi79L7G6LY1xTtT7gVjvsQ7oaE/+EWWiyQvjWDVCa1uowqTfP?=
 =?us-ascii?Q?6Pbm+6M5s5f0q5HWDnJz0dDkyVn3RIECEUCzqvzN2tfaJHeTVOlEA3QcfqxR?=
 =?us-ascii?Q?IOeyk+mSOVgp4BL0yDcinP01lFMfEE/aanT6lYlsVOLuWkvTkIbCsCXAl4QH?=
 =?us-ascii?Q?HXuPsZvrwHrqpkQu3B1yuFQswtxYB0a6ci3osOM3tfHd3EHFnQoVPEpl7IZz?=
 =?us-ascii?Q?M/JAhLqjGtgJmgO9y+XO+MxCJjCsCMuV4Kd0Y2hOd/WLAy0hfaJ/zEH4Qlze?=
 =?us-ascii?Q?POz6PmuYk6AEyJ79LMHyYV9V/FCXTGpIKX9UalU9npN9RHji5oelGfkuEtR3?=
 =?us-ascii?Q?G3BPhHMaox+yvXN0RGfxmUC/IVzmNZIryi2Almfj20xfezRbjzYvAIqz0xCb?=
 =?us-ascii?Q?Sn1CnQSAhNRX5mSRld6ZJKDCeGkPqq1hjvA51FizrITuPJKzjTUM+iPDyV/Y?=
 =?us-ascii?Q?WS62ELIqNMaXLm69jE1xaJHmpcMFuQFB7h8AiuOgjYay0Q3ZEprl5UZKSoZZ?=
 =?us-ascii?Q?Q5ttLiFKlfjhGE/TtKwMahLqhdoU/E0VkyUuRMjaRfyjl4PFRE0sXftJaMuN?=
 =?us-ascii?Q?b3C6TAiGgFKtsn7FY4Bp4jIYgnPLdWW9AfbvwkuRVaiYB/QTIdya643Jsmj3?=
 =?us-ascii?Q?jhOYFMuGV57m7sW7anOKEaTWWZjB4GC/EZ9X6VzEsp0V0da1EXXqSj0Kh21o?=
 =?us-ascii?Q?QO3diXfVOuocxmZbBTSxDxHsITp7TjpHQNmoVnpahmzNYTuOLwBpQKIugqXX?=
 =?us-ascii?Q?Jm3ZQMSesDcwkk41YJHZBy6nu2Q5P8vU6zGmr2zU+Hwnny3HU3cu1tskSExs?=
 =?us-ascii?Q?WA5Copu2sP2d4gWaCA6t+Z5fXV2ms73ZghMXjo8NGj8TZI8h9/fQA1Juib3z?=
 =?us-ascii?Q?NOyl7zIadw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2519720a-3359-40cb-676d-08de62cfb170
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 02:55:31.1373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6C89Ks3ZGur9Ky/A9P8TidzEXUdiXtCFnAXJwXethzVLc8yRs/E2vfkFy9VabH1ZHh/DR4TCR9+cZ8L0u/aKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB10162

On Mon, Feb 02, 2026 at 04:24:38PM -0800, Stephen Boyd wrote:
>This reverts commit 669917676e93fca5ea3c66fc9539830312bec58e.
>It's been shown to cause problems on i.MX and STM32 platforms
>where the board doesn't boot. In one case, a clk with
>CLK_IS_CRITICAL and CLK_OPS_PARENT_ENABLE is being registered
>causing the parent to be enabled, the rate recalculated, and then
>the parent is disabled causing the critical clk being registered
>to stop clocking.
>
>A fix for that would be to calculate the rate of the clk after
>enabling the critical clk itself, but that wouldn't fix another
>problem where a clk with CLK_OPS_PARENT_ENABLE is registered
>before the parent is registered. In this case the hardware access
>in the clk_ops::recalc_rate() function would fail if the parent
>is disabled.
>
>There are even more problems exposed by this patch because it
>introduces logic that disables clks earlier in system boot than
>has existed previously. Historically we've not disabled clks
>until late init (clk_disable_unused) under the assumption that
>clks have been registered enough to have a consistent view of the
>clk tree. The clk_disable_unused logic doesn't work very well
>though, leading to quite a few devices booting with
>clk_ignore_unused on the kernel command line.
>
>Long story short, disabling clks during clk registration is full
>of pitfalls. Revert this commit until a proper solution can be
>found.
>
>Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
>Closes: https://lore.kernel.org/r/6239343.lOV4Wx5bFT@steina-w
>Reported-by: Mark Brown <broonie@kernel.org>
>Closes: https://lore.kernel.org/r/036da7ce-6487-4a6e-9b15-97c6d3bcdcec@sirena.org.uk
>Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
>Cc: Brian Masney <bmasney@redhat.com>
>Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>Cc: Chen-Yu Tsai <wenst@chromium.org>
>Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Tested-by: Peng Fan <peng.fan@nxp.com>
