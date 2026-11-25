Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619407;
	b=onl8aZ5f/3hIJldV8ZBpTER6Sjs1rqL9lJJhJulqe7Wj7UtTh/PEM7Wo8/6Jbekl70eu
	 O4PgqEs4Kr+lPBAdc7fGRbEe1vflXyDqmMcmwchGSgzCs5jESvhP2YSZXjKy5pjFPdI1N
	 OnPF0jjhxHZewKVIWgdrBw6xJqgfSsKf8REv+a2NOgxVssep9fEsAehA7m1Oh9n8wG4gm
	 kEhGl0D7+Nlfph/hUTiZcZsYHTWwmF/7H2KpTpiif7c57gvTUoFIM4SkWQNxp7vLQLhSI
	 VyRTTovYUCaSLfZYY6AVfwQGJKg0Yx6SknefLmE3GYrLmUqZKIHX9hgIdlzpuwsCX6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ytWsl5Fm3smGoyTPwv4Z7FKGzwv3TICcEQWs2R6omU=;
	b=1labBzzHb9GKYCZxklsbX4DqxawxrQx/MLrY8les4CVcMCgOmkt8aI0VZvCZrEieH9xq
	 lft3q2R2UHZf5kCpVSTDjjyXI5jYho69fpezKAEoW/q9f+QdDGCq2lrOYWUJusp/A5yhZ
	 sxS9xJe7hXCwhrGWYfteIsKiEzDqL17m93kPBWIfjmyY4QotZWGInF6tEKSXD0E1WNqry
	 F0SiR+QN13NgGNLgXnCfPznKJpwHwD4gl54poUA2PTWgERjOM2V/iCk1Cdwop57ztSzYc
	 APORoszVlMjANFgOqkncVIfkAPxQccOfrjO3RPvHsv/SyZja1WuZsjfEAN6kQh+eLUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2myd4jS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BD1606A31E;
	Wed, 25 Nov 2026 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2myd4jS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35F81F000D0;
	Wed, 25 Nov 2026 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619407;
	bh=+ytWsl5Fm3smGoyTPwv4Z7FKGzwv3TICcEQWs2R6omU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2myd4jStMT7VxBp6Hu1372YH9rPTmqWe/MzI3Ch0rv/6/FSRZoPqRRi6Rm1klSUB
	 UPRZWB+0rUBhDNU83e27FmEbCQN5w657QMKeo57xgHEI1Nlq+kMs6ZqmMt3jqQmLQD
	 De3hUGhPg7OvciCpa82w5boL8AGa5TkaQrnqxcqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0585/1005] mmc: meson-gx: name the limit of the CMD_CFG timeout field
Date: Wed, 25 Nov 2026 15:32:03 +0100
Message-ID: <20261125143835.450829381@linuxfoundation.org>
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

commit e1644210d15f7f8adbe6315199b4b73bead63a2c upstream.

The data timeout is capped at a literal 32768 ms with a comment next to
it. Give the limit a name beside the other timeout constants.

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -125,6 +125,7 @@
 #define SD_EMMC_CFG_RESP_TIMEOUT 256 /* in clock cycles */
 #define SD_EMMC_CMD_TIMEOUT 1024 /* in ms */
 #define SD_EMMC_CMD_TIMEOUT_DATA 4096 /* in ms */
+#define SD_EMMC_CMD_TIMEOUT_MAX 32768 /* in ms, 2^15: limit of CMD_CFG_TIMEOUT_MASK */
 #define SD_EMMC_CFG_CMD_GAP 16 /* in clock cycles */
 #define SD_EMMC_DESC_BUF_LEN PAGE_SIZE
 
@@ -211,7 +212,7 @@ static unsigned int meson_mmc_get_timeou
 
 	timeout = roundup_pow_of_two(timeout);
 
-	return min(timeout, 32768U); /* max. 2^15 ms */
+	return min_t(unsigned int, timeout, SD_EMMC_CMD_TIMEOUT_MAX);
 }
 
 /* For R1b the controller waits for busy to be released within this timeout. */


