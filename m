Received: from mx1.white.stw.pengutronix.de (mx1.white.stw.pengutronix.de [185.203.200.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C773AD528
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.200.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702225; cv=none; b=MEsh66eCDnodA6deU7X2kXQIppTuAaLu2Mr3RYIXyl2iipFWPJQlkeCYVopdFRI7IAM03PdNbaag5D5FJXHrrjQDHAzGNAJTsAPQ1z7HxfgymuGaF8Rb0plc7d+EscdPPrPwvC+yQf5wA6xsH0mtm/UG/1jiVlpWSimSPnP/s+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702225; c=relaxed/simple;
	bh=GjVjO69dViQnw0/5KtkAT/Zpz3XptW3KF1G0trXZfTk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l7ocSrnawhqc1Z+MR5pbKPSVyfPVnEwQcUpR+XnAR8PV+MIfuVb4rGrM9DQuxn9PoQZFxTDGqlXVllbsbGvuWpFEZxRntO05nmLe+rog3cknuhHzrdbiXodkQbqKfH7OOMHAfzdnoPYd6ItzM5rAAlU9UqlxjGmDrG1t8lYGoFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.200.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de (drehscheibe.grey.stw.pengutronix.de [IPv6:2a0a:edc0:0:c01:1d::a2])
	(Authenticated sender: relay-from-drehscheibe.grey.stw.pengutronix.de)
	by mx1.white.stw.pengutronix.de (Postfix) with ESMTPSA id 416B62029B6;
	Wed, 22 Jul 2026 08:36:59 +0200 (CEST)
Received: from lupine.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::4e] helo=lupine)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1wmQZf-000h5v-0b;
	Wed, 22 Jul 2026 08:36:59 +0200
Received: from pza by lupine with local (Exim 4.98.2)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1wmQZf-000000002vj-0SfN;
	Wed, 22 Jul 2026 08:36:59 +0200
Message-ID: <a64558dcb06d62931e73b638dca077ed4562779c.camel@pengutronix.de>
Subject: Re: [PATCH 6.12 1118/1276] reset: imx7: Correct polarity of MIPI
 CSI resets on i.MX8MQ
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Robby Cai <robby.cai@nxp.com>, Guoniu Zhou
	 <guoniu.zhou@oss.nxp.com>, Frank Li <Frank.Li@nxp.com>
Date: Wed, 22 Jul 2026 08:36:59 +0200
In-Reply-To: <20260721152511.013410224@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
	 <20260721152511.013410224@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Di, 2026-07-21 at 17:26 +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.

This patch also requires 6d79bb8fd2aa ("media: imx8mq-mipi-csi2:
Explicitly release reset"), but I don't see that in in the list.

It's there for 6.18-stable, but missing in the 6.12-stable (and 6.6-
stable) patchsets, I haven't looked at the older ones yet. 7.1-stable
doesn't need it because the commit is part of v7.1.

Did we tag this incorrectly?

regards
Philipp

> ------------------
>=20
> From: Robby Cai <robby.cai@nxp.com>
>=20
> commit 71827776667f4e4677a4fa806bcfb24d4b8dd9d7 upstream.
>=20
> On i.MX8MQ, the MIPI CSI reset lines are active-low and not self-clearing=
.
> Writing '0' asserts reset and it remains asserted until explicitly
> deasserted by software.
>=20
> This driver previously treated the MIPI CSI reset signals as active-high,
> which led to incorrect reset assert/deassert sequencing. This issue was
> exposed by commit 6d79bb8fd2aa ("media: imx8mq-mipi-csi2: Explicitly
> release reset").
>=20
> Fix this by reflecting the correct reset polarity and ensuring proper
> reset handling.
>=20
> Fixes: c979dbf59987 ("reset: imx7: Add support for i.MX8MQ IP block varia=
nt")
> Cc: stable@vger.kernel.org # 6d79bb8fd2aa: media: imx8mq-mipi-csi2: Expli=
citly release reset
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Robby Cai <robby.cai@nxp.com>
> Reviewed-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/reset/reset-imx7.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> --- a/drivers/reset/reset-imx7.c
> +++ b/drivers/reset/reset-imx7.c
> @@ -236,6 +236,12 @@ static int imx8mq_reset_set(struct reset
> =20
>  	case IMX8MQ_RESET_PCIE_CTRL_APPS_EN:
>  	case IMX8MQ_RESET_PCIE2_CTRL_APPS_EN:
> +	case IMX8MQ_RESET_MIPI_CSI1_CORE_RESET:
> +	case IMX8MQ_RESET_MIPI_CSI1_PHY_REF_RESET:
> +	case IMX8MQ_RESET_MIPI_CSI1_ESC_RESET:
> +	case IMX8MQ_RESET_MIPI_CSI2_CORE_RESET:
> +	case IMX8MQ_RESET_MIPI_CSI2_PHY_REF_RESET:
> +	case IMX8MQ_RESET_MIPI_CSI2_ESC_RESET:
>  	case IMX8MQ_RESET_MIPI_DSI_PCLK_RESET_N:
>  	case IMX8MQ_RESET_MIPI_DSI_ESC_RESET_N:
>  	case IMX8MQ_RESET_MIPI_DSI_DPI_RESET_N:
>=20
>=20
