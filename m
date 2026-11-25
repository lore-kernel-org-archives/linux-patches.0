Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619405;
	b=FEwZ4Upzyppi5Yoz573550stC4yn7WcG8TClSwp5T6bQZgSXz/gu/ZOR/IRbsSjD4IQu
	 vbJnblXRKi6q1UpIy3WqPAvSmkl3huljNAkGaR6OEkGAJkWm3cqGpqro60wZKMH6wlP1f
	 EtaZ4wrkcdNbvJugC1J69QdQkkEJ67JCmYxMy1vJjkD60CTd1W8IVJAHGSEqtEShN3BEd
	 fe8eR0mG5dqaMDqj+DZXi9o4NKB6XC51TJYDkqJMCfZP6izQlwPaeH4kJLLS4ThORT58u
	 GD6tOY58cQVG05QuSmEtl6gFUVVRJ6biK0YJXEF5gWpSCc5g4aUY0+ZxoxJmbPThgeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4CocGV3xXiO1kO/66OvnRzlKbowDP9+il9kKuGp9Rhc=;
	b=gbhg17yMkVyf9hocvUKihB39QVu4lt4cIHXnJ3TVS0ix06seo0kOLlKss1CzLHsrBnSW
	 R04pI4ZHFKsn9rikokbsfXFQuzbBeIBKT5fCs2U+iuqH05VTlpY8AReb75wcF2VJMw/y3
	 g6MEWsu8x6haC2lkf5GECxqHsKRFuik0NvkpioOni2W4bGFXkv3b5enlS+dck0uMbpLi9
	 qw0jd0fZ6fiJUJ582+UDoFZz4Tsl2U6xw67sX7aJ1n0ALKVRwNeY94fG3WSf5xrSrKttV
	 qGNn6A7JCEvJyTLMcEQfrib7qO8Pd1bnO23Z2J86vWAspBjcQtWTeLul+JNdPsP4cNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZpRd7E8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFFA606A329;
	Wed, 25 Nov 2026 15:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZpRd7E8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DF31F000D4;
	Wed, 25 Nov 2026 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619404;
	bh=4CocGV3xXiO1kO/66OvnRzlKbowDP9+il9kKuGp9Rhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZpRd7E8juecTfQCYv8VmZXD+tjtKsLpPYzuQsO6PPpwYrRE5eAk5tkDWEifRf2BL
	 irEnVf8LUtrGCAEAuUFX8tzxa/KND3T4sqAozavNmQy4sCIYoRwhzlKCgJwcm9YFTH
	 3YfyH6/Yz9vDuAZFskCDHrvaO9UTNW9g+3OuiPd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0584/1005] mmc: meson-gx: report the longest busy wait the controller can do
Date: Wed, 25 Nov 2026 15:32:02 +0100
Message-ID: <20261125143835.428297864@linuxfoundation.org>
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
 


