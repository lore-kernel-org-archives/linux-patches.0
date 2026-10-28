Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212860;
	b=FWsPd0cHjt10K97xo5neRcp3ioaYD1yhrGeuwMK5JzmLSSyHsmfeZEMe0udbpe+LNcoY
	 EdJ1XOYKQHPbCgf2lx05NED4ZAvJqTsB+/N4XRXSrYe5wGBDx1e3dHZ3if3ecBS9Iz2u3
	 reu8IwixGl2PfPS4+7k1yRxmZ5vEXYPeLASx8tAthi9ZXfgURjc+NzSqiKzO8zIgMRHGY
	 nkOsyaBgKcvpnu8/wgFCPZhDDr2ENpgIBQeofOgvp+BkV9RdCfrpLqsFITXPJsqYJnG1I
	 bFBPA+LB+/R+WuTfTGXrA5+RU2EZZplNq0FIK0siIvL4p+k1ISauS3w27/x6ID7dL3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ruzxzXiUVA0zKE38Nn2iXdDKYqMQkOub6+CcZKrOjoI=;
	b=bCk1C70aw/G8+SGtFgsXVpfb3CJbRP30oWHDhwCso14Bavd6yUE6+swMs4KiMlbuNstn
	 ONoYMKMlyZ7AH/mgo+3sfgLl8Jq0gJtRMpm2dY3jBUKj9/f6yGmNBVfnSj2kLlroE3Kcl
	 bMxHdxUjUc4OcdrC5LgGLN+6XG0cCHdt67NfPh6n/B+fO6Ak1cKhLaaNG63+r67E9c7BY
	 PPDihplnlQ9RW+PLjLUgKnRH3tESQx89lnQXL6P8nLPmnlEWa7dt27hXVGcZYzd9prMst
	 iA4ZlFzIl7KspX91RMI3SFGgTkABQTQcOJbOd8cZgVwf3rXm8wY9jrHoGnJjjuGyFFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZPYFy2n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E6D606A331;
	Wed, 28 Oct 2026 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZPYFy2n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603E31F01828;
	Wed, 28 Oct 2026 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212859;
	bh=ruzxzXiUVA0zKE38Nn2iXdDKYqMQkOub6+CcZKrOjoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZPYFy2niBGIzJJSnd9THwNIeKsLnelNdINkaFCdfea/BRH+GlW8iaeyiIF1xrzId
	 M0UaNFjf3jM3qo/Jn+4BjSaVajH7KGCXSdRTQ6SSN/Hd51TPJvSObBMv00E9mSTN0e
	 Q77cSz9eCEwXWiSZXfrc9mHrqtqbgsyhzsdahN9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 0295/1887] serial: 8250_bcm7271: fix use-after-free in brcmuart_remove()
Date: Wed, 28 Oct 2026 17:39:51 +0100
Message-ID: <20261028170505.942845510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 189b9dc8c96ec9486482f27c1372b04a7152175e upstream.

brcmuart_handle_irq() starts priv->hrt to work around a receive-timeout
quirk of the 8250 core when hardware flow control is enabled; the timer
callback brcmuart_hrtimer_func() dereferences priv.

brcmuart_remove() cancels the hrtimer before it unregisters the port, so
a receive-timeout interrupt that arrives in between re-arms the timer.
After devm frees priv, the callback runs on freed memory.

Unregister the port before cancelling the hrtimer.
serial8250_unregister_port() shuts the port down and frees its IRQ, so
brcmuart_handle_irq() can no longer restart the timer, and the final
hrtimer_cancel() drains any timer that was armed before or during the
unregister.

This issue was found by an in-house static analysis tool.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260909084002.686911-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1153,8 +1153,8 @@ static int brcmuart_remove(struct platfo
 	struct brcmuart_priv *priv = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(priv->debugfs_dir);
-	hrtimer_cancel(&priv->hrt);
 	serial8250_unregister_port(priv->line);
+	hrtimer_cancel(&priv->hrt);
 	brcmuart_free_bufs(&pdev->dev, priv);
 	clk_disable_unprepare(priv->baud_mux_clk);
 	if (priv->dma_enabled)


