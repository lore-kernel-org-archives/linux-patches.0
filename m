Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2071.outbound.protection.outlook.com [40.107.104.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186F83BB50;
	Thu, 20 Jun 2024 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898770; cv=fail; b=RebEYr0ysKcLkwIDeidK9rAHH4InJP9FxjDahg9v3WcZtOi5TJCytejfBY1b+dGCzsNy60mCouldXRjg87mud/pcUccgNk4mLuupQPk5kyq1nwkFRSw+lD8U01OK6+DT5I4+Ww6jj20IjXokH3XLLviPiDqGpR4KCfHfnvSOu0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898770; c=relaxed/simple;
	bh=vByuGsbTxffT2rGgVRWqCJ9Bmj2UxPhEkMPgRS5zNRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p0IRv6J0gQ3CWCPeIj83BG7nUr7g7wZ08zulJ+xyVzR3H+Tq7+sCUJL46s3bcxshtA76dFSfytW9gAxe7OSSVe1Azsm8nhmJ8XI9NuXFmkJo3NA7BZg2sFsdVosvaWTW+oPqNeAcIB4JVcdVj7wp67pGQ9V1mjbRw/FEaW7vsFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=GzI402/P; arc=fail smtp.client-ip=40.107.104.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GzI402/P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dS4hv1o1IiygO654I4fQSMM/218go7sideZC1mPFRR8DW/qaUreACnqauCkqGxMxELdP8C2/JaUZ2++BgqEGLCic19DFwCqOHMY7JKq3bcDA0ZtCxA1pN9CEgfJEJfereXLlqfP6BT2dQWx5X0RR6lPNXgZrLPpJZQSZx/k06CRS6rNEAgqzSFtbVSKaSLBm7ZEgFhWwUbAsUX+QfZBhUC/9/f4QqD78K1P7Yj8JMVI56QnX/vIFEQxxay6BPixZdFOh+Afxwa5j1mPRFrrzMxEpqkbB1IhFUJCdwKKI/oNGWJLF0Vqg8ed0fQReAY0sX96z2VcnSecAYpDDK4B3pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rqunpmILdQOArDt4+ONzHyJbikgU+NS2YZreNerJaY=;
 b=bqEDebnmq1GgVsCNIKFOB4oShKeAvY0ZYjcAcSwYfmXDVCYQXBnCjdC8oblPBvmv6rTAYwCccViA3Q/dRPwaB+CG2znSSy7FvIbTRjV4nbLs4wDL9NUoe+EC1vFAfwBf/rkESys9Q7m188nsl4fqYRMx+gsMtEnpW+jWBWIM5Jp4Cgwl4M3SWn43jcpvhzG300YB9svbsFbEY5sLP4rhVf2dUvT9j3N3azmPUcvWENyKTqPEPPIfmDoxPKM5gyrlKz4GB3vqD5gDc7ACdUMui8rVghcwCzafM2I6Y3pdeS/Rl11HA8Gy3SuWscP8Lz+Zluk3t0da+lCFtKjl0oWdFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rqunpmILdQOArDt4+ONzHyJbikgU+NS2YZreNerJaY=;
 b=GzI402/PE6AaDBmFtghNa31X+atMaoAP2QsYYcWy7+k+ThTQQUpNPEpMWYIb+MUK8lcRptGlCLp5M6Viimm2CNMO/vUuJY/kXV4zBfIFVVYIRTXbaTYhwdICnk0j8NgTOh7zPwrb8RGMEXz3ctdsbsBswhT4es5Q57RqsOmk98Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by AS8PR04MB8372.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 15:52:44 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%2]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 15:52:44 +0000
Date: Thu, 20 Jun 2024 11:52:36 -0400
From: Frank Li <Frank.li@nxp.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Richard Zhu <hongxing.zhu@nxp.com>, linux-phy@lists.infradead.org,
	imx@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] phy: freescale: imx8qm-hsio: Include bitfield.h for
 FIELD_PREP
Message-ID: <ZnRQRHWExZNqoYE0@lizhi-Precision-Tower-5810>
References: <20240620-phy-fsl-imx8qm-hsio-add-bitfield-include-v1-1-5c7c09ed87e6@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620-phy-fsl-imx8qm-hsio-add-bitfield-include-v1-1-5c7c09ed87e6@kernel.org>
X-ClientProxiedBy: SJ0PR05CA0128.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::13) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|AS8PR04MB8372:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c8359fa-8903-4478-dc1f-08dc9141064c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|366013|376011|52116011|7416011|1800799021|38350700011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FfecLhHn3tcRTRr4aAQYSnHXXV4iekMKghVr9odRnvYQq9g2mMAhHNIJKsoa?=
 =?us-ascii?Q?1Avg7MaRcntJi0pTpm3TJdM+nkrgWSQgwhx+pM5p2o0fJ3r8oNybUw4vY7qy?=
 =?us-ascii?Q?7/kgCTlVTb/IDFtXIFX77SuS/ysigMmTYbWUSg/IA3gb2dGfkIhcEj1Km+mC?=
 =?us-ascii?Q?GNmrvBidUQyVYd5dYa9XLkC3UcCFoazUwLW1pSal0zUw0kKpIZrsv38jS9qh?=
 =?us-ascii?Q?4N3MrZlT9S1pUwYd1H3WAYX6mNahHjO/HB9S2kI4O6xgFOW/l4U9MM6qmjMC?=
 =?us-ascii?Q?vE2C327GNkQ4f5VjPIDzPYvXarFhhAtXDN54+MSGvSm+EUq+8bP+2/IKrzRt?=
 =?us-ascii?Q?HsrKj47CZZZsyRlFVUTZWeR+nnYuDuUa+12Gw4sF9dQGqKAVapLcchmd9ysP?=
 =?us-ascii?Q?oZxykvVtazcdbt9AhkjiKdThmvhxGJ4p3SbpFzs98OZO5fLoeb+R4soJ32Au?=
 =?us-ascii?Q?eye6nnR9b6PbX9CPVusg1CZSldDaAfGSBxRthOVK8FFW0bKuqTxbnKzzp6Je?=
 =?us-ascii?Q?8ake/7G8y1KojpRkfaVHBRFMPgaPoMDtVoMHnar7jP0NkifTkrZlaapw6cUf?=
 =?us-ascii?Q?0WtKgvvLc8BaTLJnZ6DIalCaO8AWyJRCwCcSJBQ9SWObK3K+o2Xt61voPW2P?=
 =?us-ascii?Q?r5FV+DHTo9awmx/lX1FTad33BRUl74brrAzmAN6HpCMHNALWWmD9lnAe3Qn3?=
 =?us-ascii?Q?bKcP8rcKRCqfZYcwXMRE0vtEiL1pMZP4ePURZZTPHcF3HWIdAzTLjmnAw0I0?=
 =?us-ascii?Q?CgKEHLbbuAR3tayWySS2vfe6IQ4x46ZebWjRRnoDwQvbQkC/uOSysf5BzEI8?=
 =?us-ascii?Q?9XHAB1SMLahrpqdZgS9efyJD+AcTjHNZfWzCQ71kIwHajcO8EeZNL86hMpkN?=
 =?us-ascii?Q?OeQoLL/FBrWx0yuJqeDXtXD+j7JI0nxjlG+Xahgl30KLzJ/sIXY9Mfk9IhRX?=
 =?us-ascii?Q?Rzvwq7Ny7bABXzbTKschQYRJhBLFWed1v9Zhj3k85Y2ljyoF5B+O+7SW/Z60?=
 =?us-ascii?Q?lk1QxJxdxzbQbUiHElF+3M02xqqd2K9an/iPUatJM2Jas0bJ0YDTN2gcf9Vt?=
 =?us-ascii?Q?/MghuabQiWyFSUwMMDJ0/X0riKtZV1q5nrl+smI9LobGIo8pYvoZYaIHL4Hb?=
 =?us-ascii?Q?u1BNZ9VFuLKj/IzfZPdkCuqCGhom9oQXFgIeT2LD+7q+WuQRBd9lfChS/5gY?=
 =?us-ascii?Q?+azmy/pVK/9mdTg9wde2edoy6C73fdkbr85IZiKE6ciCI+87MTscnXi4VIuE?=
 =?us-ascii?Q?c79MT8yhrC27F5PZo5El3E+O+AucfIXSOa81Ez06BFgqqD+qI91gEoqYAU3R?=
 =?us-ascii?Q?Sx55LWGVMYh2AJD0LaaQjs9vL0TF0cdn0Kr9EKV91WctG0rrn8vSZT7hizKQ?=
 =?us-ascii?Q?lqnYvyo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(52116011)(7416011)(1800799021)(38350700011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oRsn3k7V10JcO6G8W9xhEp0GgKKfFl8gIZ4ZxHPd0RCn1nW+rfWfTntwVkwC?=
 =?us-ascii?Q?pWDK4nM3vH4C82Kc1KfAw5MJrvidih1hsn22LRFOHb5ciTPgTfKmatc2+AHC?=
 =?us-ascii?Q?TaQVeS7eJHWhkRd+vfqSU6jbWipHNQyY1b82RfObB/+qkSX8exjziYeOC81D?=
 =?us-ascii?Q?UVh1Pg5wzdRKADtmz9uHiBeOsOhB4EfEXl9Z0ackxqpIFiggjwXl6h5nDQtg?=
 =?us-ascii?Q?D57Edahp4d8in4UB+nK1A8g7GuiaKePuQKY2n69AbFOSiURmUIzZ0vaW0UVM?=
 =?us-ascii?Q?FQWpvOYSw6VJHC5JmvpEUEf9vaJ9cg8zUTIQbDDr16uyinzg5HZI0xm0x13O?=
 =?us-ascii?Q?61Ahn3FhNjazDze7O8O494YR+bbHt77XG4ZfwTDSfMqcYLVXjIHOqBYoU1jl?=
 =?us-ascii?Q?3fgnyYqtSR0E4QsR3o7Gz4O3Rdpzvrl/VIGPA8l/UmgfxMFdQ+rwhfVXpv/m?=
 =?us-ascii?Q?4bZN4dH8bNYQjoITCgVVkEk40raX62ixcyUwmj4SQeHFK7U6u9RxowHWaksx?=
 =?us-ascii?Q?XLuMypXh6bz6yUVYCtoWRowtX8qv9wwniRzYUPnxQuf9Ka9xIHL4kKeLFPss?=
 =?us-ascii?Q?PsfKr/Bc7KGn0izcFfKcNhg+1yvmlsmrZaN/i/6vrXDD8ISIHvXdmOF/xoTO?=
 =?us-ascii?Q?ys+rJazdLoEz6OqpsDUTVls2glqOa7SCpvU9eQK4MMhpy1vTYDp48Q3SI9AE?=
 =?us-ascii?Q?Sx3R+Uk/ECojl7Oq4d5cZOGrBioECD7UJnrPf7mhLl26P1sUlqRWjtlEVEKE?=
 =?us-ascii?Q?0A1t0QAA4nH8OVt6TnRo70SEjrKbfmjLVNe7LxTNY899ekRsh8Bc4oxKyI7E?=
 =?us-ascii?Q?qNfna52JpJcAm66s57hi71uxA+iSEfIzw8EnVD3pvkQeVvdqwY71gWSNW5Ha?=
 =?us-ascii?Q?VrkOanmMmitjnfN9XnNV9MBb3D6SzlrA8SQ2xiv3HnZ073fEur4m3khqSQoH?=
 =?us-ascii?Q?+avxVxZTDEPQepexVMglmRDTY54cyZdonRLF0Ur048pg0rIMJOVffVMdbN8F?=
 =?us-ascii?Q?mkOkE1pFs8UWTB5lUPxaDW6cOuMr3eop0Wm49ELVIofkPUJ2nmFyHbfRSbVa?=
 =?us-ascii?Q?cgcjD+NL3hHLS4t8KV9NpTD0FRyln2IhxpvLjDiOS1R1NkWNoXYCOxxV3qfH?=
 =?us-ascii?Q?JgwsHjMfDHQwI1bRTK+zt3efMsa654SInZKD8QcXu+2K9c5WV2oWHtUCAWls?=
 =?us-ascii?Q?SylAIrFUsnsK4xuLOZmU20r0Ddyl3AF7vqkwAUwfY9j16k4OydXNWs5ccvwz?=
 =?us-ascii?Q?8w7iVVQWnAzyMHfBn7SsfOZXgoUF1V9s5bbWsfZLl1/HVumq/6tD6jm1Dh9e?=
 =?us-ascii?Q?WxznjNKDM9MQ+hlzN6+kpT1VqYCfdRTxS5sIdQtUEO3B5024sa3gg6VvljOw?=
 =?us-ascii?Q?bXp6tx4wdZMtAkE46WexhEDcdaQhxbCpenv21ozLvOvvNiyi8vg65j1m7I9Z?=
 =?us-ascii?Q?3PTzRK0MPFGaLRrAZiqu7MMhQqpKwdKoX5jT7VlmpRwRPUl3PsriDLZPSq54?=
 =?us-ascii?Q?+Mkv5fc7VSYy9pbpBPNcyfH0bGu3ixXUjZ07VngdNxslZxJGpRFYqWN1Ux6x?=
 =?us-ascii?Q?Q+xtbOlBwW0BGrJ7Rm0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8359fa-8903-4478-dc1f-08dc9141064c
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 15:52:44.7145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIJxpa7BXB5vrBpxIV6SfhEdvCgjq488UlfX8TDbpTulGp/frwDqxIs+1uqiIJs8iYcDuHc2f2jgjGyqIZPTig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8372

On Thu, Jun 20, 2024 at 08:21:15AM -0700, Nathan Chancellor wrote:
> In various configurations/architectures, bitfield.h may not be
> transitively included, which results in a compiler error because
> FIELD_PREP is an unexpanded macro:
> 
>   drivers/phy/freescale/phy-fsl-imx8qm-hsio.c:459:8: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     459 |         val = FIELD_PREP(HSIO_MODE_MASK, val);
>         |               ^
>   1 error generated.
> 
> Include bitfield.h explicitly to fix the build.
> 
> Fixes: 82c56b6dd24f ("phy: freescale: imx8qm-hsio: Add i.MX8QM HSIO PHY driver support")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/phy/freescale/phy-fsl-imx8qm-hsio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
> index dcf9c45ff5d6..5dca93cd325c 100644
> --- a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
> +++ b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
> @@ -3,6 +3,7 @@
>   * Copyright 2024 NXP
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
> 
> ---
> base-commit: 82c56b6dd24fcdf811f2b47b72e5585c8a79b685
> change-id: 20240620-phy-fsl-imx8qm-hsio-add-bitfield-include-ab94e9b1bb1b
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
