Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619395;
	b=Z+j/8bM6kAqq0c9vAXsnLOvUKZtVREvjnaVoHMiKzgfUIg7ZUguwrbZpMbcxaoDxiVv7
	 TBm327m5TPhOhR/DBWkWA1JO+WAcPA0ZOMA4Zc6GEd+P7BhL/RIb0DIPhooJXuWu5g4IN
	 nkBFMq/7NeJ7afRitDwOXvvA91kwn+rj/vxjHUdXDeIwzkE1cDi9h8SfChblpysAlwUL7
	 /o8ZIhSnL7gJay3jSY0GUFh8aShwlyT6vojbZwMFpCimqqfzD/Y1S3I18tuj41PPx+Aph
	 lYEcqmv6fP0THS2pe3+0mwb8M1YoIM+qF8l96YUGx/BhKYoOiFJcFkC7geDOKgwr9Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oWNdKFh4IvrZ5IFaqHb9KxuNrSBVDkuBG/PgkDdp4nU=;
	b=Alve6ZEmCLXsuc8zQOG60SYTzG7INauw9Zr/jbISFS/gXfsr+Eg3dfyk85BnHJZ41jtL
	 j81Xxjqe/qCPOR9ySWB4jCoKkJm+8DJTsVxoaBZG/L13aMQSaC0d7w8uJ77cN3dVEEIrx
	 2YnMyU8IXeJg+sGZd/O+oWrHorh+rQsaCkYpIOqRFXtXSMc2reT49hCfHWdlkRRJoZxjo
	 NAjigRddx6bn3TkAM32FDdKxXeibLK4q5tjPA8THt7ceQ1vkdw4vz14xjlRVwc1PLwwtt
	 OZfoNn1P23wVj3JE1jQgNWyrUVTj8D+HMx0dBaemNgd4zwrn/7GsjiliyoP2cn1Cwdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVB1LPp3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C21606A32D;
	Wed, 25 Nov 2026 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVB1LPp3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039071F000C6;
	Wed, 25 Nov 2026 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619394;
	bh=oWNdKFh4IvrZ5IFaqHb9KxuNrSBVDkuBG/PgkDdp4nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVB1LPp3p08ysxpvDkUh6IerydSRMIVS5GmDj3oKii2GRvF0TwexaF6G98f8mAhTc
	 7LGjae3JMzc3w5nx1lVakMFGM7dT4QLl/a17wFftFCTkmM6rn0ATHzvaxSPvordN2l
	 5rP8KW0tzwnS5QO3CRRP4NT1h7GKZEDQ0ZBYiFiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0581/1005] mmc: sdhci-esdhc-imx: map unsupported driver type to Type B
Date: Wed, 25 Nov 2026 15:31:59 +0100
Message-ID: <20261125143835.359083635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1142,6 +1142,20 @@ static void esdhc_reset_tuning(struct sd
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
@@ -1952,6 +1966,9 @@ static int sdhci_esdhc_imx_probe(struct
 		host->max_timeout_count = 0xF;
 	}
 
+	/* No SDHCI driver type control */
+	host->mmc_host_ops.set_ios = sdhci_esdhc_imx_set_ios;
+
 	if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING)
 		sdhci_esdhc_ops.platform_execute_tuning =
 					esdhc_executing_tuning;


