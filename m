Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7178143736;
	Wed, 23 Apr 2025 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420105; cv=none; b=BDmP1TehaDxXQMYfBiYtGlr2keBLzAdHomPPKYse7f1cb7+MKuTs4kEo2DBM52XyJYpmrQk8Y+BMyH4W5q1mazyat14Nd4+NLj7np88yMSapcJBy05dLj8r0dv4p8Rv1FXKd7EVnLXl19/o6+OzI0zf5P78IEeIWBRTiAU1RLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420105; c=relaxed/simple;
	bh=imMnaAbJUoAUmlgJA10AsNObMu9PGxHaAqc+NuvINZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoWx87fXxi/4YLOv4y+ZTGbJ1esAhNBfLOZiJbOpfkk8uJTy7hy0Tslhj/QXnRY1kdg7G5eaGqtLUaspPBjEFWxQfNCG72YGK7xib3y/FdPDYfyGAyFa71+hBsyCKWqoXJtsGy71a4nHvLDqlr1B1XRpffeZXWHAfKVIjYvF0IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMrBPKX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMrBPKX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA21DC4CEEB;
	Wed, 23 Apr 2025 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420105;
	bh=imMnaAbJUoAUmlgJA10AsNObMu9PGxHaAqc+NuvINZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMrBPKX7WHzUie6P9NXSmIR2wL+WjmHUbFNcZCHrbjp5YAArX6Xp5UJxB/HgyFt7S
	 iCp+UjE7nZtegU57mGEV5ix3ZfxiK0VaohOFRgG3muFKu8spA6pvR7Jf+XrdZSZSOG
	 PdEazBIgQj4fA4nX4sI8mrJyxPF5vJvS/nTJc6xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/223] i2c: atr: Fix wrong include
Date: Wed, 23 Apr 2025 16:42:52 +0200
Message-ID: <20250423142621.188357923@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 75caec0c2aa3a7ec84348d438c74cb8a2eb4de97 ]

The fwnode.h is not supposed to be used by the drivers as it
has the definitions for the core parts for different device
property provider implementations. Drop it.

Note, that fwnode API for drivers is provided in property.h
which is included here.

Fixes: a076a860acae ("media: i2c: add I2C Address Translator (ATR) support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
[wsa: reworded subject]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-atr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-atr.c b/drivers/i2c/i2c-atr.c
index 0d54d0b5e3273..5342e934aa5e4 100644
--- a/drivers/i2c/i2c-atr.c
+++ b/drivers/i2c/i2c-atr.c
@@ -8,12 +8,12 @@
  * Originally based on i2c-mux.c
  */
 
-#include <linux/fwnode.h>
 #include <linux/i2c-atr.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-- 
2.39.5



