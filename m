Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036737;
	b=Bc9Aal5UKvkXKsuoRUhi1dBpZaXAVfiA5XhK/CGLnDo5Se5Unp5H8kbr4krwHfSH22rB
	 k5Ue+ii8gM2ETmsNO1bkm4KaSmFvpQoHSM2Z1vkkjW/4Vf6XCQrK73YSu3P7mE4hd8aJP
	 ufAi88zfiVq+4PkYsOaawyqM2YtA8l18S8lKzwOPAr1BpN+UuXVv2lnKbj8sZCj483tf0
	 1qKoolSxlTKIMZ3qLismiUM0rwe2vsnC8oXcgwgta14/7tosU3bO2Ww5zOeO/OK/TKYwg
	 w/UJSPAeoguZxkh1vhyVdOfVhIzeduO8i/c8OoRBmridNzRR3KV4FUyq6fT9Okv4u2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kspCzTbFe95NcLDxM400/uPOjfIzuDcIt6ob/wPCPOA=;
	b=NHfhToU2VgRlwT7NzrkL9WXgrmw2Ap2oZjY2sQoD2eFqoXUi+4frsJ7FcXYiC4flVMTQ
	 iNddbFZUgj5cAjB75bwClOiem9V8w7PaHrEjVLD17SG11bTt2Gv4/FM3ZMjysePA5sOQ/
	 FN6xswVMCC3SAeskhf81PtR+o/V1nsgaoDCJQkD8TmCuGwf9P1rNJsDhk18azYXjICVRh
	 n5JAxfxRQ6T+joQ2AJIa5AhDUeVbz4c9M2GxKkUedTBGKM0oQT4JhXxySrIa9girC+Qkb
	 PPXDUVlKN9Jl697WcFM0cf8mS4ikw3r+17vYF8wKxpk4DfW2sr/Rk6GM2BlEQWyKqFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHs2IhIn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD16A606A31C;
	Wed, 18 Nov 2026 21:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHs2IhIn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BC11F000C4;
	Wed, 18 Nov 2026 21:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036737;
	bh=kspCzTbFe95NcLDxM400/uPOjfIzuDcIt6ob/wPCPOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHs2IhInG8/PnZ/TT4w/LuKNCJUIxfKNtgZWIsTPRlNtbFbF2TQzOuTNzxd7cfHt6
	 jLaGKiVEovWDtfb7dAPtUI+YXI3KkocOqQhMwig02aYpG+GVXTypKYtLIJQI0h790S
	 k7euj85VY5xT3U+Xoj91X9Fkfx4pIpgSATfJDJ9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1167/3318] gpio: davinci: Clear interrupt status in every bank on suspend
Date: Wed, 18 Nov 2026 15:29:49 +0100
Message-ID: <20261118150355.130898443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit 800d7627f552bbf602a1736b638aee0ada3fbf87 ]

davinci_gpio_save_context() saves the registers of each 32-GPIO
register bank, but clears interrupt status only after the loop. At that
point g refers to the last bank, so pending status in all preceding
banks is left uncleared.

Move the interrupt-status write into the per-bank loop so that the
existing suspend-time clearing covers every register bank. Single-bank
controllers retain the same behavior.

Fixes: 0651a730924b ("gpio: davinci: Add support for system suspend/resume PM")
Cc: stable@vger.kernel.org
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Link: https://patch.msgid.link/20261018170622.3406158-1-sahaj123.sc@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 75107ede3bf8f..da535b0b8fb0a 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -642,10 +642,10 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
 		context->set_data = readl_relaxed(&g->set_data);
 		context->set_rising = readl_relaxed(&g->set_rising);
 		context->set_falling = readl_relaxed(&g->set_falling);
-	}
 
-	/* Clear all interrupt status registers */
-	writel_relaxed(GENMASK(31, 0), &g->intstat);
+		/* Clear stale interrupt status for this bank. */
+		writel_relaxed(GENMASK(31, 0), &g->intstat);
+	}
 }
 
 static void davinci_gpio_restore_context(struct davinci_gpio_controller *chips,
-- 
2.53.0



