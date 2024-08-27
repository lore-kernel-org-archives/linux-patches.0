Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F03A1C4ED4;
	Tue, 27 Aug 2024 15:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771636; cv=none; b=mC19kOgIYyN5lM4tidOLTxWNVYAohV0KubQyWk83NPZzzb9TkzO08CtWG9Cep+2Jf0Y9OAhS+fP1hstz1/X0KQcrGQe3ROUk80YHLwlB+ZhQRQIWt8oVUbEc3NTgco/Ew4pc6UHjpHtsVlhEP1kfnRKK6sCgKwBMT0+9oiJJ4XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771636; c=relaxed/simple;
	bh=cOrjI6X10IM8sen43U46YfQNcVbSxXG1x2hu0TDt654=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzxHK1JedX9TamV3OJ3mE6LbhAqZLsDm/FDy2v3ZEFjwQoaszhqEJSpH6buhug2kmAGMa91EBocm6t/Z0xq7mJY+byDtJXHktBP5ULz3SWD41bHeJz5EpfQjMijdWr5pZmmNWlsPC5Spa8UFvoFRjgw2bzZlfN9CrvveKjCYol8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNc2Dbq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNc2Dbq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1987C61064;
	Tue, 27 Aug 2024 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771636;
	bh=cOrjI6X10IM8sen43U46YfQNcVbSxXG1x2hu0TDt654=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNc2Dbq3myQ5iiDzqw7jO0QZwXhebI3VskWy1yn16dncnqzQpChmNpgUmYxjI1G7g
	 z3fB2U/8F0/DihjSPG+33R7IjSFjCwGZKDwSNzRQO3gkFrYR38lF2ncg1CVKlepskA
	 sUW3UXBWRKnyI33i2y/l6JwogkzoLGj2zBBSKGxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.10 249/273] pmdomain: imx: scu-pd: Remove duplicated clocks
Date: Tue, 27 Aug 2024 16:39:33 +0200
Message-ID: <20240827143842.878585927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 50359c9c3cb3e55e840e3485f5ee37da5b2b16b6 upstream.

These clocks are already added to the list. Remove the duplicates ones.

Fixes: a67d780720ff ("genpd: imx: scu-pd: add more PDs")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240717080334.2210988-1-alexander.stein@ew.tq-group.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/scu-pd.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/pmdomain/imx/scu-pd.c
+++ b/drivers/pmdomain/imx/scu-pd.c
@@ -223,11 +223,6 @@ static const struct imx_sc_pd_range imx8
 	{ "lvds1-pwm", IMX_SC_R_LVDS_1_PWM_0, 1, false, 0 },
 	{ "lvds1-lpi2c", IMX_SC_R_LVDS_1_I2C_0, 2, true, 0 },
 
-	{ "mipi1", IMX_SC_R_MIPI_1, 1, 0 },
-	{ "mipi1-pwm0", IMX_SC_R_MIPI_1_PWM_0, 1, 0 },
-	{ "mipi1-i2c", IMX_SC_R_MIPI_1_I2C_0, 2, 1 },
-	{ "lvds1", IMX_SC_R_LVDS_1, 1, 0 },
-
 	/* DC SS */
 	{ "dc0", IMX_SC_R_DC_0, 1, false, 0 },
 	{ "dc0-pll", IMX_SC_R_DC_0_PLL_0, 2, true, 0 },


