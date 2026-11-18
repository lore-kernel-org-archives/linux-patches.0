Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059636;
	b=Vox26Gl4S0xTzHuTTtHNKDzlAuSPRD01G49sPH6hKST/OnZWNFAmdNjjlcUzUVi6YovS
	 WP3TlihcHUTCfpjuZlnIf2uNAwv7eeljd9fPX3QtXbLppOXTFRVss6uxjZhZ73Q3Kwp+d
	 YRngyATmy/+S7fzxrZ7ysUn3LJLs70BopRb0uIxklaMBOanuXWkM9aR4kogTnVevXjJ28
	 N6v7l38r7UXFw+tjmQdp3ltZ5ixovw76xoys1HNOO5a8+39upHQUeJJb0Hm4SyYSue7F3
	 OTVcOrLUr0zrlD7eDQ8KP/txP53hAU+LfTbMPT2pfrC224zP/kw6z9ydI40N2qKlrwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PpRoecmvtA7q+Ebym62pm8ok6du3+4Ve3o/NadJzDXo=;
	b=SOZfPPIN9xUT3veMSpPhDHwnZNQjDG58C5uDGyYRmFemDtfBsfCbdQprqnrtcl03wVag
	 LuImV9zyARnZnov0AK3twMjNW0VhA0Yl1b7jnhHKrlbxjNFz2D6xmZNKOx/J/F43u7J9m
	 NZfb++nxeulTVK9rbFBQG2bxVl6VPHUDHVgF6piJ7MwQvS1t17gDqEqLLyF5cSVijVXe6
	 xJKCnzH/Vf8IH7AetzDO+gY0gUkUARVR+NkHOGBl1rJNXDFuWxxihdovXoCM4I0eHckiT
	 M9jlAdb+MQEcIeeFo3lI8ii+zdm16xlreZ3JBWtnRYOSc2E7sbLx7tRDGKQuOmVmRtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PK3fYzod;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D058F60A2636;
	Thu, 19 Nov 2026 03:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PK3fYzod
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEF61F000C4;
	Thu, 19 Nov 2026 03:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059636;
	bh=PpRoecmvtA7q+Ebym62pm8ok6du3+4Ve3o/NadJzDXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PK3fYzodzhOPhRXWk6qcEZiYIZ03TA/imjWmklUN5/RPFgDlg4c/BqDdg1UDkZwM8
	 AeOWCn15c97xMdPQCLgX/Nk4ZxMQEyTNG3ReE8IiN+QuVDMdk6Sm3+8e4dBo6L+/0F
	 yonsIkFisiVV1VQTxtr03UOxPU9tuFv8yrLuWGk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Fang <f.fangjian@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0912/1848] spi: jcore: Fix trailing statements should be on next line
Date: Wed, 18 Nov 2026 15:49:10 +0100
Message-ID: <20261118145955.059520262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Jay Fang <f.fangjian@huawei.com>

[ Upstream commit 45793de7bf89fbd0fd1e2db9dda4e58a9c1395ee ]

Fix checkpatch error:

  ERROR: trailing statements should be on next line
  #85: FILE: spi-jcore.c:85:
  +	if (speed == hw->speed_hz) return;

Signed-off-by: Jay Fang <f.fangjian@huawei.com>
Link: https://lore.kernel.org/r/1616566602-13894-9-git-send-email-f.fangjian@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7db773075501 ("spi: jcore: fix divide-by-zero when speed_hz is zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-jcore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-jcore.c b/drivers/spi/spi-jcore.c
index bba10f030e33d..74c8319c29f17 100644
--- a/drivers/spi/spi-jcore.c
+++ b/drivers/spi/spi-jcore.c
@@ -82,7 +82,8 @@ static void jcore_spi_chipsel(struct spi_device *spi, bool value)
 
 static void jcore_spi_baudrate(struct jcore_spi *hw, int speed)
 {
-	if (speed == hw->speed_hz) return;
+	if (speed == hw->speed_hz)
+		return;
 	hw->speed_hz = speed;
 	if (speed >= hw->clock_freq / 2)
 		hw->speed_reg = 0;
-- 
2.53.0



