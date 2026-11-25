Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622844;
	b=1BbqmSBBP/RXRXcfRNg61IBgz0FnkjrBHspFd+BQ7R9mC1Y1sb32onv3JvFMBOI//VIC
	 YQLwWthe7XhQTJCZUNf04uOxfNdtPx1Fw3pmcZ85Q/B3Tdza6uuivS5lTzEqwRJakkUAy
	 PxlzS01j2tRxQU7avTO0NP7QsckaHAHzCrGNZlFXevj+UiSGSaIBwv4PZJiKskFyCX2/n
	 4HcJgLhb7PC6aHAhIvBTOYrfYxMvYPshjtMYcpSEGdx5y5ciTNhY2OoRmvLZ89s7mX4IQ
	 SegviW453cjTCN788l8dAMXDjPxLmBDRSVUr+YiUJcat67qLjCFCpp6JKIRAB8FXfvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oQFejRdvpOMg0H8px67Nv7gbwFB5ZjPtVcMzkoSQfUk=;
	b=34BLoHoOXcAQa8UyPMcW6yCAGn2+d8WmwHTOvoI0lqNvo0dlMk+H3bF6vJNFRrjUgSKz
	 xXB5VdVO3O7OFkYadY3/tM7EOKKxOOqHN2T+L/5GjRTJVuH2c10lErr3GHnugl/I3Tby9
	 Ov2i39TPvQ6yfU0BlKwLIIHqKIUyquZUmyi7ae2M9ZTyVFEq+XEV7UDgFktvwoJTRp5aK
	 YX8XiLvUmiGCvEAsl4mIzy/D2Ex7AN0zPLNuRQOgnlWiBGDddhjTwFDy51n4LJU6TGjwS
	 CVFN5fM8PPBkUxJiJMlUqKch5IpWDZiG+Vhvda7ww4zLO00HqvnntKZnh1drSnszC4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="M/0jIp7N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D2606A31E;
	Wed, 25 Nov 2026 16:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M/0jIp7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326331F000D4;
	Wed, 25 Nov 2026 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622843;
	bh=oQFejRdvpOMg0H8px67Nv7gbwFB5ZjPtVcMzkoSQfUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/0jIp7N//PUGmGPRuKU7CmkY/8zLu+XUy69ZeegZEk8GMxi0WNobo22PuftPXgaP
	 yZA+AjptG3LGQ2dQ/jZ88eKOE+3t5LHQZlQjeHN1oiLOLIQxjAFdjcBTus4qrrYKBD
	 qdK2ARPj8kWiFtnVpkBtNmvqJdQYfjOU5g32bnrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 667/990] mmc: meson-gx: report the longest busy wait the controller can do
Date: Wed, 25 Nov 2026 15:33:54 +0100
Message-ID: <20261125143837.711701051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit 18e9f7fb05ada68d491ff49165b9644f790e0e0c upstream.

The driver does not set max_busy_timeout, so the core takes the host
for one that can wait for busy indefinitely and sends erase and cache
flush as R1b with busy timeouts of up to 60 s and 30 s. The CMD_CFG
timeout field holds at most 32768 ms, so the controller times out first.

Report 32768 ms as max_busy_timeout. The core then sizes discards to
fit and, for a longer wait, sends R1 and polls for busy itself.

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1180,6 +1180,9 @@ static int meson_mmc_probe(struct platfo
 
 	mmc->caps |= MMC_CAP_CMD23;
 
+	/* The longest busy wait the CMD_CFG timeout field can hold. */
+	mmc->max_busy_timeout = SD_EMMC_CMD_TIMEOUT_MAX;
+
 	if (mmc->caps & MMC_CAP_SDIO_IRQ)
 		mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;
 


