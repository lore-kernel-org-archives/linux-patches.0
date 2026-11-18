Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016994;
	b=vh3MnpxY8HV76b5Gx33PBczrTrocAcQVP5zbBQv9FNhySNSU4psFAaq4ulqdFANW4yVu
	 UUFqDXneHP1lRCagLV+x4z1facyZIdGXFtGn/V4+r+WxtetOTA9st1NkLKJdBaEr5YXau
	 zYTlL8lhOFEd1f6DMgp5+haafvFcomcIvJ7nc9G1X+0kXm1tRbEmjBiw6JoUnNfMsxfFB
	 B7vx+YcET8QS9aEW6GnvXT4PWc+12z08+urPdWleRf7K5+FEcH2H/rX176iGbGc8qEtso
	 etGUrT+4VHU4F3AusXf2UALc7Aeomyw4TUaOpPCLKYVa3S4ufxEdr8VJ+Lus5ZmhYUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uv10dcKTI/+qX7nBaLQ+QKwLUqWOFG18ej9DthMqRU8=;
	b=Z/nKmF//oeL4Dw8s77ceSxAT3f1DyiddP1xJpMK/ptItAb8ZgEL7a7cK4RP1vogJdCGS
	 r2beWXRKWGOaMod7qPCC4Ybigd9nGRZdJmWUD+dP+zecHhr1Sk3krwyyoK4euHWZdR0kj
	 od/NWzy9lBKyikKcTl2A5gJkDIzhhzIrDzghxDrOA/PxpZn8QthqHS5W/1n9Kh2Zbzadn
	 aALqA5NjhXTWSiROh/S4VBUHq2Wy6yUVYwhE0E1Er27ICuq9WygJD2NXapr41FercG7kj
	 KYt5qhVz++5ozBG8ZVf5ahuvJWNnrv8glNTT8YoPnKuO4ncxToDd/EP7ajnnYzcwDNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Az61gnN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814BA606A325;
	Wed, 18 Nov 2026 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Az61gnN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DF41F000C5;
	Wed, 18 Nov 2026 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016994;
	bh=uv10dcKTI/+qX7nBaLQ+QKwLUqWOFG18ej9DthMqRU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Az61gnN89ipJARLPCh0/iVtlNQSrPixzWYFWqQWX7+QR0+4nUhIHEko8Q5O53Axo6
	 wS9fBPY6MU986RuJLVDJMXjKByWra9ysOdssbcDBP5aql9dKPlB2Lhd60x/YPyi7I8
	 F3KcNYqmqEC/dYb0iqPXxoSpxXJgbI1QXuslqrX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Sinyavin <sinyavin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0725/2651] serial: msm: select PM_OPP
Date: Wed, 18 Nov 2026 15:32:45 +0100
Message-ID: <20261118150313.971151285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index cf7dba473b203..bf680d22199b1 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -904,6 +904,7 @@ config SERIAL_JSM
 config SERIAL_MSM
 	tristate "MSM on-chip serial port support"
 	depends on ARCH_QCOM || COMPILE_TEST
+	select PM_OPP
 	select SERIAL_CORE
 
 config SERIAL_MSM_CONSOLE
-- 
2.53.0



