Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029981;
	b=iWNnVBJ66vJDEnssrDbq2F1zrACsMWDgW63rDL5W0HxrhXEcwe9iUJ8S2cAhOfnhsIuv
	 0TW8LDoIPgrzZEuFNsyR4mHtQPMxtCSXODaSNNuVyWWwulEdgAshcMeM5NNEvIq1rexZN
	 njec1PmChNA4W51llb3YDrjCThNNlU0Xd9p9qa0fQHSYVYRZ/ajIYd5HXW6+QI4efj3cK
	 HxWNhQXagKy0YZXkCgwRYPeBw8ckdRv4Lg2IcrFlCY42LL07R0NJGePFDEMkMcGeEBhfT
	 osRyZQP1gRbvuyIQR2nyOwS9edSZTG0ZLKTCttS7/ccI+3eN2p35NkGK3IXlYOfaDuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKN4UdzBi+PPayDUgKh728jxZ24ekVYnm4aSC3czkMQ=;
	b=FLmq5WrdAg+W77HF77e9058++F4aP0Z/YMF41GqXJfFI3ru/JAdzyUEkloYVpK5gRQO8
	 r3+Ya528MigbLQaf0LFlLtYR4QQzZ1gwLhDRG5t/kvIEgTelchnbP5Qi1GmSstygGnyI+
	 4zPEjtn83AXRvm1CL0pNEMBSGk4kjUjt95y9erl7qpstW/+M3OUO2BuuwsR0IHPafALVx
	 Es7/Y9ooJOzQKA55flFPdhZt5P8z8rL/1MCiAyLxIVe9dAMKiKkPnqEnLuu72VrkCDGlP
	 UKggxxkdtB36uia3SCl3eAS5ZTShMCLO2FSdX/9VMFF0wQLCIdBb+xqgZC/Q2L8esbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g/GqTaOe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8638606A31C;
	Wed, 18 Nov 2026 19:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g/GqTaOe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353D11F000C4;
	Wed, 18 Nov 2026 19:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029981;
	bh=jKN4UdzBi+PPayDUgKh728jxZ24ekVYnm4aSC3czkMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/GqTaOeaBajpV47fplevpmDqRo5x7dfouCvV7fd7FVlnd7o9xCgkRVuwnVrQP8E3
	 5mGUty325cS2IBvtm3TKuka0X9eiBy9Hkw9v9AEf6/bAwFRw8d+CyMhrDEtUIodRWa
	 EPuqtP+ojr9nkWPO+hl/2DxYma2GpWQiKQIlrBQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Sinyavin <sinyavin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0542/1756] serial: msm: select PM_OPP
Date: Wed, 18 Nov 2026 15:44:29 +0100
Message-ID: <20261118150030.717290167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Dmitry Sinyavin <sinyavin@gmail.com>

[ Upstream commit 6a8352bb4e4bfcf67fa23c49d2e0d14684ffe2e6 ]

Commit 173ebdedcd84 ("serial: msm: Use OPP table for DVFS support")
made the MSM serial driver unconditionally configure the core clock
through the OPP framework during probe.

When CONFIG_PM_OPP is disabled, devm_pm_opp_set_clkname() is a stub that
returns -EOPNOTSUPP, so every MSM serial port fails to probe. Select
PM_OPP to keep minimal configurations functional.

Fixes: 173ebdedcd84 ("serial: msm: Use OPP table for DVFS support")
Signed-off-by: Dmitry Sinyavin <sinyavin@gmail.com>
Link: https://patch.msgid.link/20260830085340.2542624-1-sinyavin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 1e92b16b6b95e..7c83e0078de01 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -894,6 +894,7 @@ config SERIAL_JSM
 config SERIAL_MSM
 	tristate "MSM on-chip serial port support"
 	depends on ARCH_QCOM || COMPILE_TEST
+	select PM_OPP
 	select SERIAL_CORE
 
 config SERIAL_MSM_CONSOLE
-- 
2.53.0



