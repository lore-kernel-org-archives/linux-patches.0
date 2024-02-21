Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C7F78B4B;
	Wed, 21 Feb 2024 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524311; cv=none; b=CxDP0KFESfD+aAhxCH8hgXRV0BGpNqkfZcPoz0As0LoQGx90Ka9MzKOBaf3C7Hb23OL+uIHNQvva+kmX2MBCmjfatEQLgdU9h/88CNKEXy+Is5K+UKV5VhlcmY8HT1kSnVd1BPySbjAuO0AKNIw8QRFaSoDw+cekhfem7OKfHuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524311; c=relaxed/simple;
	bh=AaPeamt8GGF7h3Qf1RDX6D7DqQm8j/NJXESkkGei9+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO2CKCFtLdD+qzT1ehgZdUJs5MlkGSBxWtzNPYvCjVcbWcf3WG0M0oDxIdAxffso8Za2ADhhU+8nOTALepaqDr7VuuPSB31i3u5Wlo2NpymChMOL56Ai+HQ99/tWJwytGIZXCMC6nRjZ5VIEqN4Fr4Gi0oanp/QEjwVXnWsSwqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z7AOWxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z7AOWxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAC8C433C7;
	Wed, 21 Feb 2024 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524311;
	bh=AaPeamt8GGF7h3Qf1RDX6D7DqQm8j/NJXESkkGei9+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Z7AOWxd6hZqpWIbAVDImVv/j4+ooKK+75givxCP47b8oxmpoPFs2kQvCs9GBJHUk
	 K3zPM4N6KMctWT3lhtGyB2DtmXffW3ZBYuWCtv00onnTgsbQ+QwuuanYka89X/kS7i
	 +wjYM3CEyUPITRMqKEpvN9qTRR9oSo0SFI0M+mYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/379] mfd: ti_am335x_tscadc: Fix TI SoC dependencies
Date: Wed, 21 Feb 2024 14:06:25 +0100
Message-ID: <20240221130000.995462103@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 284d16c456e5d4b143f375b8ccc4038ab3f4ee0f ]

The ti_am335x_tscadc is specific to some TI SoCs, update
the dependencies for those SoCs and compile testing.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20231220155643.445849-1-pbrobinson@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b8847ae04d93..c5c6608ccc84 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1382,6 +1382,7 @@ config MFD_DAVINCI_VOICECODEC
 
 config MFD_TI_AM335X_TSCADC
 	tristate "TI ADC / Touch Screen chip support"
+	depends on ARCH_OMAP2PLUS || ARCH_K3 || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.43.0



