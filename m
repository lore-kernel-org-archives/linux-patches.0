Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625625;
	b=ZWq0OsLvS3IlK3tu33gXA9NqN4Q68gCt0WEY/Chkx86tMq6c6g99cqTzpacNIhqob9/5
	 TOJOGNcu4dJmY2vYlssmhsui428qUp89ADgbhMb+mRtXI6TsYTCICIZzBnB9g7epVwo3r
	 PcIiEDmED/fpa1hZJWNqWPYec5YSuSSw9/VnIySb9UYOe1zTDQnpRIgBVaLni2lp/RSbP
	 uNexGYVhUbDkyHbpqvDsioozAUYETv7a9Ms1NyeV9xFrJmdFy/t16Jw9QaFHJceIBFnhQ
	 TRP3MzhzKldwr0Nf+p8Fpiy6s8KpnqM6G+AbRgxajw+URZu8+AtEmwUuYTeu2mMNC1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nz5gjD35IhvL1gSjJptzR5iUWw9NWrZ5KED9B0g0iHs=;
	b=2ZXb+/De5MXYPR31YTLuqtDetRP7vmfsejI6NIQs6MYxe8CDQHtMhqGLixcN8G1q75Sk
	 qJLwE4oC2iNRz/aL2+0Gk2WvLcGy4f2xrSTbJBcWW33QWxK0dH7gEDubDUjtGAR1uiIZC
	 La1rHkj8TM8YFe1UjpQ5Lh7OAALQdEuS2+BohcjUTGBMOoPLO3FlBUcGibyK+Vh6RtpbG
	 FLuf6Er6g0b1bHYaIrQ6GVBZLtC1BikFStgQj0jVBIxlivU9kPKSSfAZr/ZtMtW7WnT8R
	 +/ERHEA5P1n2kThgNi750xxdWoi+kAqJEGguLEKS8Y/fSBVl0gdooSDPQE5JHOv+WqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHVxfmZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877E606A31E;
	Wed, 25 Nov 2026 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHVxfmZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B67E1F000CA;
	Wed, 25 Nov 2026 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625624;
	bh=nz5gjD35IhvL1gSjJptzR5iUWw9NWrZ5KED9B0g0iHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHVxfmZ44OrJDPkl2qREPTCXqSXdTt49U9SruvRZMPjnR+324AgBuywlG5hD5Ja6Z
	 jvbL3RLtKCHvLsG+uWP9FGOts+L1CQOIV4Uw7SMP6GU5S0wyrX9gyDz3hA7XYf+SGw
	 E57COL9aKv0mhDT0GMpV0vXoR1tsiDs4aFK505GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 561/816] mmc: meson-gx: report the longest busy wait the controller can do
Date: Wed, 25 Nov 2026 15:35:09 +0100
Message-ID: <20261125143902.168691042@linuxfoundation.org>
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
 


