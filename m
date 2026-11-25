Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622847;
	b=KddPNN9NeI5xG5c5iNVK9zN+eOGocbNYOlKyuAtsZalgG4blYbH5Ezwzlxu8hCh9/8aC
	 sBGyr9XH0trV+VLvBgBW/qPXyJ5tDEmeHBvEGFtyI3fTtzkr5PZIqqQDqjxIsFzgDjSeC
	 TqPR95R0tPiheARK6UBHAKWjeR2aA8fd8a3ayQDXv6z31/YqHl2K0R2jMukw+c3mlH6pw
	 pKjKwrqiYNI62nPgexFC6KJr0LSVmYV0RAqQmp5gAn5VUJyKke6IKPez0ozEqFN1MmWU0
	 SBeNJuJDLov9B3db6gmy05kX9RWvZNQdWA3o1bIL4XITgAc8a4iIxO9j/8cKoZOTMhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzGIjEtRc2CEcVcycNhymUr9v39YAR3CFkv18WYcDaY=;
	b=CoNjufX8zsKwEXhHC/nmHyYZtyIhHqAWT/uRPTOCApVF60j+CVoFro3aGn7bQDSP37N9
	 xR2PSS7n0xlw4p07U0rXnF2z3Pyo+Pg/YHjebgcllMlSs8xY1HjGTAvzXC5XHyTYn/dIX
	 H+OFowGmYrawh4WoSxt/KgQvja9kklYX1tWn5iqsZ9h4sFNfc8M8UsLsTviyxe2AUhawJ
	 O8A7JmhlvDbyQbB344I25oWQGpBemtLax0ysbuY1K8Pt+4C7TrrEYhkIoOCfVsr5mZB/d
	 9sX5vw97ByJm+D1gi+y/FQxFueuEiI/SI5VxlvBx/KqbdliJ4wy3/G7MEmcs18ywjWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TRKV/JGt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E81C606A329;
	Wed, 25 Nov 2026 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRKV/JGt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1081F000E6;
	Wed, 25 Nov 2026 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622847;
	bh=BzGIjEtRc2CEcVcycNhymUr9v39YAR3CFkv18WYcDaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRKV/JGttHZM5LXbnoXsAqDtCdBgDsFABdFGEeLnsW2ZfHEwSdmIcC96ssPUBCP/7
	 Qv7q38qyXtslOFHB+F6NsH5oQWoqOpg/KIg8CRx03YuYI5d25LmMviu3Ay1yyphTkR
	 K3cMfYvN4QtSMdd68rdzOTJnySIfhwYjta9dsqzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 668/990] mmc: meson-gx: name the limit of the CMD_CFG timeout field
Date: Wed, 25 Nov 2026 15:33:55 +0100
Message-ID: <20261125143837.735161731@linuxfoundation.org>
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


