Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625177;
	b=ojoIy/yeY5ORkpKlQT9zvWdBqrwjgblkBKcObj9RnHSXBz9O+rL76A9QW/u65eHBnzDi
	 XSYN2ldZsS8Bh/eFX20dosySywi+fZim9HqlzV7w2zRxcM8JFSuKJp21kCMxXS5ELlFp3
	 Xsm5dmqUEGyRABMfv0qqph4qhy0uAYLdSMb6nFfRsn2tg5yRrXAs/5Mod0FQYTRrSi5ms
	 HqtUDS1NmAQ1PJ6HC70djRL9cczl/pTcqYZ83KUTjigpepfAlsNPZtK1c71ua8MWr50zY
	 qFZJ9a+FOovRodckFIdLreAbJVOUK04S12R/G8RqUs1uX+Ca//qKBXrBoX0C6wuPJUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D+X56WSLqTcjPwWrw6SccSVimVbaN9S5mZGtcD41y1Q=;
	b=dDUJVBL7G8Uf8UZd7smWBRIZy1zNipkXKO8hw0Fh2CdSDhvV6qM5HRB+ImrdLtN6tN3d
	 nyvZjHS7UA2hDCCGUigBa6sfzSaJEJIwWZvubxxGUKUkeYk+bkTyF3fqLEzBUIp4LlQDM
	 ZQhQlx6EzQ+9GquzywjvOHmg0DuvzbCyfHhjKR2hPrlgyE6F3bD/8YteR36PfNAw9llCd
	 c/sxZNhkyt6zK3fTJYiofgIhOHXkq5zDc6y/azSUhZjY+XZDwoT/itd0vj4K+fV6LMh4I
	 y8aWnFqvDnTYWmdf7O9aHl9NdIsdXNpwl8UGVQbVriV2z8+7XTyYXBmPPP2Kpk1nwxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrYYHlmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB40606A323;
	Wed, 25 Nov 2026 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrYYHlmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B54A1F000C6;
	Wed, 25 Nov 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625176;
	bh=D+X56WSLqTcjPwWrw6SccSVimVbaN9S5mZGtcD41y1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrYYHlmtemlaLy7Bgj76ma3k/BKmFJNN1Phcx1Dbd0dODC0N27QAsW8X29I9plrd/
	 JD+aYCiRiiRklIVPSX9j9fTF3zKh6oHkfYGz3gr7R/W9NylpqvP35wkhj+WeQ94CUt
	 FLpwQRDSKHgKqjMCL+TwpQ2CNF8PxpbDGwBthLZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 432/816] arm64: dts: qcom: x1e78100-t14s: Mark the EC reset gpio as reserved
Date: Wed, 25 Nov 2026 15:33:00 +0100
Message-ID: <20261125143859.193215264@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 07321595ce693eea5854120869a8b1560d7b14d6 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 7d1cbe2f4985 ("arm64: dts: qcom: Add X1E78100 ThinkPad T14s Gen 6")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-3-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ sashal: Applied the one-line gpio-reserved-ranges addition to the T14s board file, since the shared include file the original patch edits doesn't exist here. ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
index 02ae736a2205d..fa7371ba601b7 100644
--- a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
+++ b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
@@ -641,6 +641,7 @@ &smb2360_1_eusb2_repeater {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <72 2>, /* Secure EC I2C connection (?) */
 			       <238 1>; /* UFS Reset */
 
-- 
2.53.0



