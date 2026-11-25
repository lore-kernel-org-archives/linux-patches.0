Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625569;
	b=iNqnz2JItBm0E3QVK3/9VMnSXzPOQzsv+oTmg0Vj/ijySmtCEKY/hJ8v3PXNpvVu0Wo/
	 VEI4WvSZmOLbYWNi+ODY5rXlT4UdMgUyNCdxhzOIpWD4tfWPQn050tyRZIGniboqt0ln2
	 UGJYwkMKWVueHTcVpsFF9CKb5OeMQ0z7bjxcNJH6XjFriN7Fcrv8mB2Y8L+5tMI0xE+MJ
	 AUTTqOJ/CpHQmIWSJGe3eSvL9Y67QW51+YJKWSuKETFD+OEAgDGhPF5ae4IuyjvFgqrZb
	 v893q2Djr6zLNfs9kYBJRV/4ZPZwFOg4TIOT5XqcCtGRSXGfuA3ESKa1WzGd45WPzYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qtf9OxMifHu/LHeWVlUgKchzhQVs74NBAe6iqwCod8Y=;
	b=fzI0jrDr7VkSmaUHLARx+/q3UFSZ3nYFB0goOQVbu+oYkqBAafnEnyZTzsaRL1N8cmEu
	 7QZA9JI+pqV2WEDcg2iiF3EnFR6NGAgcPfiZSawJ0CWWfTDdfO51Fh4SH81IAtfAtk8uN
	 CKHyk4jkdPMzKJKIr2MZl5L+a3s0DJd6OrL83Rhosd8HDBkIbn1MskEE+LEygvreGkpL9
	 DVVgaxc2AGjLnLJAfM6Ti6/WGjMG5uaC9YAhP/luH7yKmJgHHbZ3EogjO1JypbJpZPUYU
	 J8QkOgzkUyfiC5vFmNl6oDzuGTJv9xeYq53f72yt7abt4nF1jnc4Ukl5q7p3XUp3fkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrKqLDx6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9CC606A33A;
	Wed, 25 Nov 2026 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrKqLDx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD241F000EC;
	Wed, 25 Nov 2026 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625569;
	bh=qtf9OxMifHu/LHeWVlUgKchzhQVs74NBAe6iqwCod8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrKqLDx6j1HmLZFTpZ5QVhFIPYhXIJxXK0EZ62nl8SWV4riy3UrDeg8+pbmd7CFGi
	 /FGd4Leh54vqgcZ4yvkLlAxn1i4wuZKyw/Me1hQzZ25HEHx/Z49wU+vPg4OfAdZ0xp
	 w1eQAq9Idx6t9RUikqa8eSiujhscARrGGvZxflBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 558/816] mmc: sdhci-esdhc-imx: map unsupported driver type to Type B
Date: Wed, 25 Nov 2026 15:35:06 +0100
Message-ID: <20261125143902.101963242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

commit d35d93c2902592a84347a15deac4d67a323694c9 upstream.

Since commit 5a52c5701a67 ("mmc: core: Fix host controller programming
for fixed driver type"), the eMMC driver strength is passed directly to
mmc_set_driver_type(), which propagates the value through ios.drv_type
all the way to sdhci_set_ios().  For value 4, SDHCI correctly warns:

  mmc2: invalid driver type, default to driver type B

The host driver type has no effect on this controller: esdhc_writew_le()
never programs the driver-type field of SDHCI_HOST_CONTROL2.  Hook
set_ios() and force drv_type to the always-valid Type B, so that SDHCI
never sees an unsupported value.

Tested on i.MX8MP (usdhc3, eMMC in HS400) with
`fixed-emmc-driver-type = <4>`: the warning is gone and the HS_TIMING
register contains 0x43 as expected.

Fixes: 5a52c5701a67 ("mmc: core: Fix host controller programming for fixed driver type")
Link: https://lore.kernel.org/all/20260926122908.866-1-ian.ray@gehealthcare.com/
Cc: stable@vger.kernel.org
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1092,6 +1092,20 @@ static void esdhc_reset_tuning(struct sd
 	}
 }
 
+static void sdhci_esdhc_imx_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	/*
+	 * This controller has no driver-type control: esdhc_writew_le()
+	 * discards the driver-type field when writing SDHCI_HOST_CONTROL2.
+	 * The programmed value is therefore irrelevant, but SDHCI rejects
+	 * non-SD values such as 4 (eMMC 40 ohm, from fixed-emmc-driver-type).
+	 * Force an always-valid Type B.
+	 */
+	ios->drv_type = MMC_SET_DRIVER_TYPE_B;
+
+	sdhci_set_ios(mmc, ios);
+}
+
 static void usdhc_init_card(struct mmc_host *mmc, struct mmc_card *card)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
@@ -1766,6 +1780,9 @@ static int sdhci_esdhc_imx_probe(struct
 		host->mmc_host_ops.init_card = usdhc_init_card;
 	}
 
+	/* No SDHCI driver type control */
+	host->mmc_host_ops.set_ios = sdhci_esdhc_imx_set_ios;
+
 	if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING)
 		sdhci_esdhc_ops.platform_execute_tuning =
 					esdhc_executing_tuning;


