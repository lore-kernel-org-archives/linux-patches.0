Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704643;
	b=REKngN5Sb7qcfm5I+xB75cWPVcmU1d8hHEA/M6gbkqL7kMcvmVvnw/zSU99CwN0eBCeF
	 SJpLhuwR7Oe3exo1hHaUNKxnfbIU9p+WHu7+qDVDoi/0o0TiOWWvoE+c5ZkqxCSYvEfOf
	 qPXmeoBl4I6f9nGIvh/f25ELgDwiKTpZpzIafrqhJF8F2ni1H1dJztmzgxJFR86OamFi5
	 ZHFBxhQivL77dqd493EvFncazfkU3DnLvhB5sB2QWOoyZhGtbX7H2msszozjuVkLZ5VhL
	 I7mDa05M6A7zEBhLghrpT1MYscg526vNbYKsK4hkf/xmemrFGfsnxIBDntw8yPssPpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n1jl/0BWOff/N0mLK05msSgIZ4u/33iSfHiT6ElpAWY=;
	b=DYB6OpWIyVlLsHWnfmzA4npR3WypFHKOV20vZ6lEy+MinxC6z8B93eg1xBHDH/6xWQoz
	 ekME23MdnL1WpPk5QiQbwoLjkyIynP+JRlHOvJ1PO4xwwTAw9t4SwzUvfVAWuK+5iBmeU
	 RIYgbz4JjS7N1cH+rHtpeWGpiCIx9SjASDhFkP/R+2UxN7li/I1xblnuXIBxD0WUHzpg7
	 8EXvZjVLvu44x9DdAoVFxL7v5f6EvVvi8yd7ZA8XqYrBvrbmFzxel1XUxnNyF6psyLacz
	 QljgWNajoT1K7Z2NHc6ZNfqDCHAkOIcZ+bOppnQdkXqVv58EH/1d0Ox7VVX/kb3yJcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKW90LHP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAB4606A326;
	Thu, 26 Nov 2026 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKW90LHP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE62D1F000EF;
	Thu, 26 Nov 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704643;
	bh=n1jl/0BWOff/N0mLK05msSgIZ4u/33iSfHiT6ElpAWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKW90LHPXQNTlC/xHoiJL3xmp3M8jPHCZ59yXNIthKe1wWGGxJJ/kRVoAUBJ9b2SN
	 ghaJdNy+sSCH4tAakCLJxiEfJ0tA+u6GaQCZkfKMuhFMNk0zwMsqPnfOEux7cdag9q
	 iHYBgMQG90Es0aOndJIM3NBCoIAIUR8LWLCkZIsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 149/265] mmc: meson-gx: name the limit of the CMD_CFG timeout field
Date: Thu, 26 Nov 2026 15:37:59 +0100
Message-ID: <20261126143615.491549864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,6 +123,7 @@
 #define SD_EMMC_CFG_RESP_TIMEOUT 256 /* in clock cycles */
 #define SD_EMMC_CMD_TIMEOUT 1024 /* in ms */
 #define SD_EMMC_CMD_TIMEOUT_DATA 4096 /* in ms */
+#define SD_EMMC_CMD_TIMEOUT_MAX 32768 /* in ms, 2^15: limit of CMD_CFG_TIMEOUT_MASK */
 #define SD_EMMC_CFG_CMD_GAP 16 /* in clock cycles */
 #define SD_EMMC_DESC_BUF_LEN PAGE_SIZE
 
@@ -209,7 +210,7 @@ static unsigned int meson_mmc_get_timeou
 
 	timeout = roundup_pow_of_two(timeout);
 
-	return min(timeout, 32768U); /* max. 2^15 ms */
+	return min_t(unsigned int, timeout, SD_EMMC_CMD_TIMEOUT_MAX);
 }
 
 /* For R1b the controller waits for busy to be released within this timeout. */


