Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054010;
	b=cepfyFBih9aAk6x/iRo9SaxS04oF2kfusZ0AafvzAzH+XnzUaneJ0mt8nxcAHqRafet4
	 HMiCHwRpwSGzOeDKYJQw4KLjJxln0qXW68+rYMI8oLbLnPRGmlHf48lSpooTIWKs9+dRq
	 m1VYX2PGIEK8wIP5S5l0mIMkNXp5SAq2qQzyP1zZKKq541aIRopwouSxo9hr8y+6OKe1o
	 DnsOKhX6KhFw/bAG99gV6pNH5mDI0HX2x9kX8lsBVgs6v4MFebhkVOOB7D9eZdOyxuzwF
	 0im5PcBvMerJWjsxBrOLW2uSS/EDZLb64B1NDqMI6gYldJ1/+wHUiD+4yJ1RfuTYh6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KxXDy8GbPl0X0mf4vfm3UaCqaYdkLNgCa85Lc3YVJZU=;
	b=lbqmTQLSNFauZR4fSZrOOkoid4kZMwJyErEyAAYHy+720Xm9KZ4TV1/kJRsZ9qHMOAlS
	 W3pRKsiDPerpKuINzulhV8Ft5GDvd33M4LVm66EXhy1ifGcGSF+Y/wFUF17UCK0dOshbZ
	 sZ11xgb8GacDJzvicCZBhcOHYoSj7A8VURCLJWnj7rn5fsZNpKcsnt29YyBNHqArz7BGf
	 quouQ4gH+VDax7eqtTrUKTn6JhnHrccwaCeqLyP8YyCKBel/PmfJbuvNr4k8ISaAsbC7j
	 MKQoVMCXvXDr/bwlfUPqIi/ImNqn6YuDNJEDHjCzfsIuJ/yP7feTfT9ueI73uyNqNaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xr4dfpPa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE72606A325;
	Thu, 19 Nov 2026 02:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xr4dfpPa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E9A1F000C4;
	Thu, 19 Nov 2026 02:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054010;
	bh=KxXDy8GbPl0X0mf4vfm3UaCqaYdkLNgCa85Lc3YVJZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xr4dfpPapCXQ/a5FeraYhWjkTac5kI2+uRz+IgcMbmNdllyUZqajGbBNUhuSSYMRf
	 FWHFMwb71JkdiGZLOHba362ELtqXs4mF82nFi4JiTCYtIAZtPPlns+Mx/cvY5C2W/A
	 X8dkBx7TwXLaTJPtov7SAALX8HenEG6UAxo3oCQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1124/2214] hwmon: (lm70) Fix rounding of negative temperatures
Date: Wed, 18 Nov 2026 15:46:40 +0100
Message-ID: <20261118150057.047990038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Ridham Khurana <khurana.ridham222@gmail.com>

[ Upstream commit eddb0aaacce4baa9d8176eb2f4bd9e99e867f8fc ]

temp1_input_show() drops the low bits of the temperature register by
dividing the raw value (raw / 32 on the LM70). These bits are not part
of the temperature: the LM70, LM71, LM74 and TMP122/TMP124 always
return some of them as 1, and the TMP125 fills them with copies of the
temperature LSB. Division rounds toward zero, so a negative temperature
with any of these bits set is reported one LSB too high.

For example, the TMP122 returns 0xffff for -0.0625 degrees C, which the
driver reports as 0. The LM70 returns 0xf39f for -25 degrees C, which
the driver reports as -24750.

Use an arithmetic right shift instead, which drops the low bits and
rounds down.

Fixes: e1a8e913f97e ("[PATCH] lm70: New hardware monitoring driver")
Fixes: a86e94dc946d ("hwmon: (lm70) Add support for LM71 and LM74")
Fixes: cd929672a9ef ("hwmon: (lm70) Add ti,tmp125 support")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260924205326.1739229-1-khurana.ridham222@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: Omitted the TMP125 hunk because TMP125 support is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm70.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index d2a60de5b8de9..0a9d7bdd0d3c1 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -90,17 +90,17 @@ static ssize_t temp1_input_show(struct device *dev,
 	 */
 	switch (p_lm70->chip) {
 	case LM70_CHIP_LM70:
-		val = ((int)raw / 32) * 250;
+		val = ((int)raw >> 5) * 250;
 		break;
 
 	case LM70_CHIP_TMP121:
 	case LM70_CHIP_TMP122:
 	case LM70_CHIP_LM74:
-		val = ((int)raw / 8) * 625 / 10;
+		val = ((int)raw >> 3) * 625 / 10;
 		break;
 
 	case LM70_CHIP_LM71:
-		val = ((int)raw / 4) * 3125 / 100;
+		val = ((int)raw >> 2) * 3125 / 100;
 		break;
 	}
 
-- 
2.53.0



