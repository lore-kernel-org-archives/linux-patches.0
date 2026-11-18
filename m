Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051382;
	b=GpDpWnNGQ18E1bLsXd2RadgolMAeit7apecFqlJn0agpsK8MzU174g7BSFthQWMKspgI
	 VXqOmBDKXmLM0RegD3pzbffN8FF1ii65Ll7a1flgvcedwzoVFrz0oiDXciVmSFtz8Vw1L
	 aAj7wf0vuNKy0C/doSV9GDka2Wg+tPZPbOUM12E2MYrF6OnQbRU3B5st7BaA7qP9u25q3
	 zmwIjSSXQY5bhyqfGBIBoq5Y505laFoCMwnI0QuEyLyCi+O4gUUT+5eZkjDw4J4cM+fBQ
	 ArpszQaU6A+j3sKAFwXkL9NhcLSHfZz8pvV92sKt1C9ai/WA+VDEZL/RnYgKkEBJhUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DycvQstYxYa6fHvmGZEYkuWw4dF+je74/i2e0Pps6ow=;
	b=SF5fVb6AcfXtalqnIiGMoN3wdLYowPWTqjcfnnt9s2A/suRzJefH1VxXI7fd0KGOE810
	 Eu6jRobuYNsoWssRIq2lskED5u8dk3HT4dSVaPVVX4GO5kD67DhnGwSrqq45dLM7fXQoi
	 RGajM6qF6/lwLjh+1PiTQlH0ITNxD/adz9XTw6iWqVGfjpvsr3PiSd8AWWYBK0kkoSevK
	 /oKt7Z+9nWAfg4ziYy4UChEOlbhDYrq+DkoA6bRAmP3NmYFIkrIvhtXXE8cC21KTcCSyB
	 aU7SaqUHschi31sefwsQENjTP71xfJujmN3hZsWxJNBlG3DFnSMpu7AmdyLWNdbjNjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDiIUvTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80860606A32F;
	Thu, 19 Nov 2026 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDiIUvTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4751F000C6;
	Thu, 19 Nov 2026 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051382;
	bh=DycvQstYxYa6fHvmGZEYkuWw4dF+je74/i2e0Pps6ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDiIUvTNoAh5HpLEGukHkuySE8H5VaOkRiWO7JnCiRX+waPNEsPgZqY/0J9Dn0W92
	 GSLqXK6v4ExSguHdAH7TnPxpU6irzLoMj2VISwR/Zfn7Dg0VI4vUJ7qfJqTCcElpv5
	 ifnEQfaM1x55/xRFa+9OAJQqH6hQxRi3bADjMYkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0189/2214] Bluetooth: btrsi: Move set_bt_context after successful HCI registration
Date: Wed, 18 Nov 2026 15:31:05 +0100
Message-ID: <20261118150017.701443531@linuxfoundation.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 290a3644609526f7ac12529cd1618042fa5a32db ]

In rsi_hci_attach(), ops->set_bt_context() stores the newly allocated
h_adapter into common->bt_adapter before hci_alloc_dev() and
hci_register_dev() are called. If either of these fails, h_adapter
is freed but common->bt_adapter remains a non-NULL dangling pointer.

This causes a deterministically reachable use-after-free when the
device operates in a BT+WiFi coexistence mode and CONFIG_RSI_COEX
is enabled. The following software-only trigger paths exist:

  1. SDIO driver .remove  (rsi_disconnect)
  2. USB  driver .disconnect (rsi_disconnect)
  3. SDIO driver .shutdown (rsi_shutdown)
  4. Hibernation .freeze  (rsi_freeze)

All four paths check:
    if (IS_ENABLED(CONFIG_RSI_COEX) && coex_mode > 1 && bt_adapter)
        rsi_bt_ops.detach(bt_adapter);  // use-after-free

coex_mode is set during rsi_91x_init(), before rsi_hci_attach() is
called, and is not cleared on attach failure. Since set_bt_context()
already wrote bt_adapter before the failure, the deinit paths see a
non-NULL dangling pointer and proceed to detach it.

Fix this by moving set_bt_context() after hci_register_dev() succeeds.
On failure paths bt_adapter stays NULL, and the deinit callers correctly
skip the detach call.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
index 8646b6dd11e94..5de25c6a4dfc5 100644
--- a/drivers/bluetooth/btrsi.c
+++ b/drivers/bluetooth/btrsi.c
@@ -118,7 +118,6 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		return -ENOMEM;
 
 	h_adapter->priv = priv;
-	ops->set_bt_context(priv, h_adapter);
 	h_adapter->proto_ops = ops;
 
 	hdev = hci_alloc_dev();
@@ -148,6 +147,8 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		goto err;
 	}
 
+	ops->set_bt_context(priv, h_adapter);
+
 	return 0;
 err:
 	h_adapter->hdev = NULL;
-- 
2.53.0



