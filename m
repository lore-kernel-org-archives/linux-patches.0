Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062469;
	b=GtTorwC2R6HdEwKBLB10eme48Bwt/U9rZRJyXqMEkKft6K5jBmLgfgpXbwuTXAG8FORl
	 RMXADq3VTHrMJsv/JXRH2sIOuL+sYA9u8rrZRZd3x7thAtwcyy74cr77or7HBQwtkQcGJ
	 UQX/nsMR726sKsIfdqsMbHIfMkG9nPuS9mqv82c/BRe/+lhNhfT7L1LHYgSrtQGd7NJSI
	 Vh9TRQiwgqTUrL+5Q5GCR9jv27AcL+m5+DUF6egHjJgn8lJi/7j40K3gRtU54xBKz3M93
	 +w8mPtwyEfB+UDUQiosAY4QZV4N64z6BxAyTuNin5DTC+N7eBa7dgiLrzqUow6x7qTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mNyL9k6/7MsOxjLbmLB4dNbiOx3697ltjtpaT5zrSUw=;
	b=aSU8AP7QicuPpORCRnAREDU1mpKPWYF5GdZ39+11AXVDev+5mi8xHZx+brkcCzp0xiVW
	 e4Ku9aOJp/w4ZzDArl/gJT7dV0dAHYn1/vkBzNUNzJAY5hhP1vuKsFST5RuWRUOuG2/F3
	 INzhR9u/h/v1eoI0n6X3TO1LAyIUTZWngptuq71dlalktAv++OxD++P4aLsIlAj6klMtf
	 oP3esJXG9fiywZFKzf1a7c7TCR4UpWNa2pZ278MriELXNevkws0mZrxB60R8oRxXxXjql
	 T2oNIQHjZWF9AUGepPGaGCwP+rpPv4Upt/aOED6jYWYadHZjwNRI26nAvAA2C5GEXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQ226591;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566F7606EEBD;
	Sat,  7 Nov 2026 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQ226591
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DF01F0089F;
	Sat,  7 Nov 2026 14:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062469;
	bh=mNyL9k6/7MsOxjLbmLB4dNbiOx3697ltjtpaT5zrSUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQ226591DSdRJzfBBguhZV5eeNw7fRH/g4p81VMwR0+0C2T7hqpB1ZOP3X5bVm8Tk
	 DZFNYxqVJlEo2gHIZcanYbJvFNYkimym+A2h44fWFVjifoee0b1a/G+Zs2sCXiKYNI
	 woYMgzTygoj/pp5NfO3KjPAMs1bCI3CRvfiOxlbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1374/1536] gpio: davinci: Clear interrupt status in every bank on suspend
Date: Sat,  7 Nov 2026 08:56:30 -0500
Message-ID: <20261107135036.432232794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 6d12a65b07528..2011db9ccb4e5 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -595,10 +595,10 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
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



