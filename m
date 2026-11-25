Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619401;
	b=4qQPT79erHg0XLTNeMZCbFFvTP/6+kv0gj9SMs6YzHC74UfoNCrTzp6EPeKUjUnry2XI
	 c3EYYG7/UMwu89FQmPv/GmcS3uzlrsDbf0ubxtPHUvgBJ31KTK5yeq/35k4sMwFz4USqk
	 dz5Qclc0y0f1qL+LTZznlMjITDbCvZu0EGKstQt6tBo1D7IAKsg3D/ayg4qCF0wCLz7XA
	 A4fv51dKldUC9BUvqVcPtjM8YTEy8zYsxE10fEKVwk1xPbn1krknPJUIhxA/IhGniJA5G
	 dp6OLefhARR4wiutAlb/6/Dz9Nt2ZLHX35nFIE10e6KLAHCF5lAkrNcbwW3kqtfno0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tsDjO7lNtKE9PK6eQDrSne+w4+elOQRYizGhXX/QyzA=;
	b=N+GAsaWnLtZ+UBXuu8NAAKPRy/N457jftNsEZujmlK0oR5C6VV0w3JCuJOdrtmm738IH
	 GkfmZvC6hzdxg0yd3jdbUhWNJ8ph8ITWJZWHFUBRngAnOtjTmCQr1ETdTs06gemn9Icot
	 C7ATT8J74Af+Z0zmQUy0RXCOBuaceJIDSIjYlacAbhnU1Qw3qILjdMYww9+lvjnbzpfwb
	 guf9w8A5Xd0j07vcXnnX+EgSLEKgbvDIpJKJQXbaeaq118nx94+wUOSDmyRNDmcC4soy9
	 FigpT0s1n8hRK/YdKCapWeDbqY4/xdDHLkTBKkdtdbFOlY3JgZwB1Jz8qz2CNokzT2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zVeWNq7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B14F606A323;
	Wed, 25 Nov 2026 15:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zVeWNq7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD66E1F000F2;
	Wed, 25 Nov 2026 15:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619401;
	bh=tsDjO7lNtKE9PK6eQDrSne+w4+elOQRYizGhXX/QyzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zVeWNq7wmMIXbTyXnt9oIw/MZUS4/aA2R9HQCulWmHG/fojkXqW8j+jsbn8RssPoX
	 /bZ0/MF27rRkoNB5fnFvmoMwQYu35YA4Z6E9wsTD4rUUM6djJwbe3dhk8Jncgs3vbx
	 ZkNm8D8WIGXowMP0ygfrugYmv04KbvqUGtjqpAWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0583/1005] mmc: meson-gx: honour the busy timeout for R1b commands
Date: Wed, 25 Nov 2026 15:32:01 +0100
Message-ID: <20261125143835.405171485@linuxfoundation.org>
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

From: Igor Velkov <iav@iav.lv>

commit 7e3cc541aa5855bc36e6cbffa82efc2795955a10 upstream.

For a command without data the driver programs a fixed 1024 ms into the
CMD_CFG timeout field, and for R1b the controller waits for the card to
release busy within that time. The core sends erase and cache flush as
R1b with busy timeouts of up to 60 s and 30 s, and the controller gives
up after one second:

  mmc_erase: erase error -110, status 0x0
  mmc1: cache flush error -110

Program the timeout from cmd->busy_timeout, kept between 1024 ms, the
fixed value until now, and 32768 ms, the most the field holds, and
rounded up to a power of two. The clamp comes first: MMC_IOC_CMD passes
cmd_timeout_ms from user space straight into busy_timeout, and
roundup_pow_of_two() of a value above 2^31 does not fit in unsigned
int. sdhci takes its command timeout from cmd->busy_timeout in the
same way.

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -214,6 +214,20 @@ static unsigned int meson_mmc_get_timeou
 	return min(timeout, 32768U); /* max. 2^15 ms */
 }
 
+/* For R1b the controller waits for busy to be released within this timeout. */
+static unsigned int meson_mmc_get_cmd_timeout_msecs(struct mmc_command *cmd)
+{
+	unsigned int timeout = cmd->busy_timeout;
+
+	if (!timeout)
+		return SD_EMMC_CMD_TIMEOUT;
+
+	timeout = clamp_t(unsigned int, timeout, SD_EMMC_CMD_TIMEOUT,
+			  SD_EMMC_CMD_TIMEOUT_MAX);
+
+	return roundup_pow_of_two(timeout);
+}
+
 static struct mmc_command *meson_mmc_get_next_command(struct mmc_command *cmd)
 {
 	if (cmd->opcode == MMC_SET_BLOCK_COUNT && !cmd->error)
@@ -840,7 +854,7 @@ static void meson_mmc_start_cmd(struct m
 		cmd_data = host->bounce_dma_addr & CMD_DATA_MASK;
 	} else {
 		cmd_cfg |= FIELD_PREP(CMD_CFG_TIMEOUT_MASK,
-				      ilog2(SD_EMMC_CMD_TIMEOUT));
+				      ilog2(meson_mmc_get_cmd_timeout_msecs(cmd)));
 	}
 
 	/* Last descriptor */


