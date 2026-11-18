Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057524;
	b=Z6JYe9y0j11VkmRyUFOdOAdeKFUWdG07PSAixkvSIIFa6ZQwd4N4wOVBhwiYZsKudel2
	 /4w9klE1D0W8R56DBlzbg/adEfUM/5QzIG4hNLjIGtuvSxAiWbf8NuEXOh6hGMEy2cPvZ
	 /QTWqwmwtQeozL2Cof7/fCyfIUMFvJs0+ZxItwSOCSUuTofnbJfRGFTymXuz5DFaJzb6D
	 pUBf8VeOwO++NWV380pQtwClLaoItfnL27FlXW+GG6x5BNZJYxYkksWm8mugcsORytbF2
	 uVrHm3TFUuNPK/J5dtiCMXivfqLmDhC7YeuavRb4djF+Bycb/N/FA1gWHb1Lo2D1A7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aJz7SztT60KvgV+LbfeP+4Isws9dp5vtaGR7KtaCCnY=;
	b=DDwT1aODmr7HqU7BxGuf5V2OdP0GkxmYMcQCW7+z4fGwZV5oFPY0EU0lg7y4gfAJo2yZ
	 wDcM8aa+quOuPePULqHgWwSfGg4zjM2+SHMYypx94p7WJhEJ0O7YlcJGdXCGfg332/2MO
	 uFFb6OSJavqqZ9l6VqA0lyrQb2E3RJrEBKwM7NHjX4uecPq7A4fYQL5PDq14HhWrkZFTp
	 /MAWJrYjCDEMuExKwpzwrCwoL1NaPZm9c+hq+ERk5XfS8z4yZGi1M6pwzNztj3Mythzvf
	 hKUR2rsj/28eghUAcHkNikLWBE+JFuAm1cvt4U1dq81s5+wikE/u7XaGfVtGbF9SE0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YC30dhmD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9CD60A2608;
	Thu, 19 Nov 2026 03:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YC30dhmD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1651F000C4;
	Thu, 19 Nov 2026 03:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057524;
	bh=aJz7SztT60KvgV+LbfeP+4Isws9dp5vtaGR7KtaCCnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YC30dhmDduC3ITveHP4nGD0fEUxttE65HlQEAzzbWOJiDdkh04wD0hDeaiTU0jtuo
	 MI91d2Hxfb5Kbf4A+SidK6LRSxQuhRvJ+tpN/G4q+oIDCBWhW3veUCWpi40h/J+rD2
	 XRyuKLJJgC9eBMKfXH1Pb2JherYUvDUIuIgmGOPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0160/1848] Bluetooth: btrsi: Move set_bt_context after successful HCI registration
Date: Wed, 18 Nov 2026 15:36:38 +0100
Message-ID: <20261118145918.316316155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3951f7b238404..72fec7e104bbc 100644
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



