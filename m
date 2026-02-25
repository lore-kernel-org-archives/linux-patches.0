Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D543824A05D;
	Wed, 25 Feb 2026 01:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983025; cv=none; b=uEhmfnIF5WDqydQ2UZxCvhLwRTdceXC47FZSEJ/nF19JSv3uThLzYYRhOJpbFDvVAxL9r+QerT+mfuYPYLRO06Uv3+LHoaxj2cLt5JEYI3OK0RSTlCks/gqgTy2MaQkYS6ZbkixXKj+wvX3CW64QktPj97KzAyLjnYEHAlm0cqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983025; c=relaxed/simple;
	bh=sSq4YIGLUAZVID3wen2SsIZwLtxlmgA2qYmHCM9Ks8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0e6eBANtisD3e9ppbwUI7opOnbiJOJRNYSGUwxHpH0PlSVunUIGULLd46FjkHnM6uvZ7jvRWERkJL4yV8+8FeCD3xJ/a5wkr+puskOcggmWsTHXpsNeM5aQKnrdxRNVStJ2CXqW8i26QbUP5khjZwY6AQRyZULjqF3OEJbvHJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpxS8/vJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpxS8/vJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F0EC116D0;
	Wed, 25 Feb 2026 01:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983025;
	bh=sSq4YIGLUAZVID3wen2SsIZwLtxlmgA2qYmHCM9Ks8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpxS8/vJdqlw88AkqoQIuhQhVXPn2dZxt/Zh5+uYQ3zZiAZG8/+Fkc1thBq/402LK
	 RXXDl7w3DwoUuo689Jy92qa0lt9k1qm72VrAMQUVquzGnVmBVY2iLKk6MMV3xBX3G4
	 47CHfPHw7L7OQWBKZvmRvf7pjXAen6GtOENRjjgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 191/781] reset: canaan: k230: drop OF dependency and enable by default
Date: Tue, 24 Feb 2026 17:15:00 -0800
Message-ID: <20260225012404.333972806@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit c7a5e01e229d21e0560d78bd645b4f7398667ce4 ]

The driver doesn't use any symbols depending on CONFIG_OF, so drop the
dependency. Also, enable it by default when ARCH_CANAAN is selected.

Fixes: 360a7a647759 ("reset: canaan: add reset driver for Kendryte K230")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 6e5d6deffa7d3..52ee102621eef 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -161,7 +161,7 @@ config RESET_K210
 config RESET_K230
 	tristate "Reset controller driver for Canaan Kendryte K230 SoC"
 	depends on ARCH_CANAAN || COMPILE_TEST
-	depends on OF
+	default ARCH_CANAAN
 	help
 	  Support for the Canaan Kendryte K230 RISC-V SoC reset controller.
 	  Say Y if you want to control reset signals provided by this
-- 
2.51.0



