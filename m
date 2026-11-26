Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705503;
	b=BGX1zGPPLeTNq+WA+FrqRxGF1q7R9mhpOdOMlgjxIFHMS2fie+L+Z2v8cgbNQOzgrQlZ
	 4cDmrd636t5I1aBO54hA6Zuz+4SxTC++0eMaGK/VdjditcvsetAYcqZi2nIvheVG9smhN
	 wjRKHa8l7fLynMcVYCcpxU39tD1Zkk1kT6YfeCN6EQrUW1RT6ZTKkF4w/G4RNP8v3G6UM
	 uIlveDHMe570turfGR/j2wiKTHjBP1ZON1UnzcYefKspfyhzBJNSu4B4eGc2Yz3qFBEMG
	 F67xFwm29cpzT2hqIs2IShvpHLvOwrdHy8kT+xMpoLnbwRQPpKm1C4shtf1CVhiuUpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PtheW4PEnV1W7VnhZUhL4kEcUpQqT9NIfYR2DnZ48i8=;
	b=FMgXBHxLlhOTkvSr6ccw7596C/GcBaTLgJmykg1sk6rnYstM2CEUnCQZK70Qyt5CLXds
	 oajngcV3OGW0QRZ5lkjqcsRR5Hw+PtgI5422ydctWepiie9oy1vPg37UH45eEHAhIGXV6
	 02qhXzh3A6ZBOG4n1a/vXD9tOBdRcQhKXkWt5EAbf4OEAzIgnYryOvXYrdlj9+K6d5X0l
	 ehNYYr6MYXUgrFd16Xel6uC3zAp2qnN5vEdaV3xHj3H6KnR/0N5miW/CWr4LxiP2EcxsO
	 2vHQhfxA1cYjqSxoQxytBgMVReJgD3JHIBAoHvd9lso/W9KNgh5TA4nHEZYeSmpDy9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qYH0/VJT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E60606A329;
	Thu, 26 Nov 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYH0/VJT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19421F000D2;
	Thu, 26 Nov 2026 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705502;
	bh=PtheW4PEnV1W7VnhZUhL4kEcUpQqT9NIfYR2DnZ48i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYH0/VJTWHCKhCTJxFKvpj9zERuroVRivo4mx3AaoMmkXpf8xSvlQY8lZbqK2G55b
	 LDg6C3BVwVSHFRyqW3mGbwT8MUOfxDhhDwGGS0CTBq1JoNavQNHu2w9Oxc2UPD8VSf
	 iHLqx8iqQblSKQo/59nhZhEgzZmGUzrjEu85UbvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 175/319] mmc: meson-gx: report busy from DAT0 alone
Date: Thu, 26 Nov 2026 15:39:03 +0100
Message-ID: <20261126144010.696050092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit 318fdb75f4dc9d18ae621b9fb25eb11160c95649 upstream.

meson_mmc_card_busy() reports busy only while DAT0..3 are all low. A
busy card drives DAT0 low and leaves DAT1..3 to the pull-ups, and the
callback is defined as "Check if the card is pulling dat[0] low". So a
busy card is reported free, and the core, which prefers card_busy over
CMD13 in mmc_busy_cb(), stops polling after CMD6 and erase at once. The
controller hides this on R1b commands, where it waits for busy itself.
Once max_busy_timeout is reported, the core sends the longer waits, the
120 s BKOPS and 240 s sanitize switches among them, as R1 and has only
the polling left.

Look at DAT0 only, as sdhci_card_busy() does. The checks around the
voltage switch in mmc_set_uhs_voltage() still hold: the card drives
DAT0..3 low together after CMD11 and keeps them low together on
failure.

Fixes: 186cd8b7f586 ("mmc: meson-gx: implement card_busy callback")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1086,8 +1086,8 @@ static int meson_mmc_card_busy(struct mm
 
 	regval = readl(host->regs + SD_EMMC_STATUS);
 
-	/* We are only interrested in lines 0 to 3, so mask the other ones */
-	return !(FIELD_GET(STATUS_DATI, regval) & 0xf);
+	/* The card signals busy on DAT0 alone. */
+	return !(FIELD_GET(STATUS_DATI, regval) & BIT(0));
 }
 
 static int meson_mmc_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)


