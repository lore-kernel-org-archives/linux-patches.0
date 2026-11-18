Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034172;
	b=pjqHlzvfVNz0pks7i2Gs0Rt0U/3E30gRTZz6pIbACtcoxsIVQY1guwDtMbLBQTStRuA3
	 hac++F04xLbc3cVg9wM0mgpAmJ1VEqJYw6q2viJMBCq20dOfXDQ2uInlVK2QLRMutZ9m3
	 /HraGFg3M4kTkShp6fSKOnSp29LpNDsLVllRiKNdWvI8gAeplt/IoXUkMUOOpL6ShvwzF
	 D14MwjteN+jnBvz9+7PIHeGNjAZSoSUc9TCxxVCwfxEnGCkRpcIgXOucV6mZTrVaYauYx
	 KJLYB7lWDHq4+zvVy5CezMMLEx9A6GnRDJqabN8zQCq25ue+ZFLtV2Q33SWtQ1TjwaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZfqSGBWCB0DwDN2vhA8/zVtQEbM/CcCOW/JQnmNVs+c=;
	b=hPJ3vCG+HiWs7ZRgCfOsoIyqU31bgKHQMgXJ70hcTL92Z01RBEZLUPSKbF+cn1xYV67l
	 smndqU58zkeI/I+Ehpo7tFsqCLeIdLVZ1WAxYxcoPllUSc805UlvF0gPm15WAGj1hZPuZ
	 le1xXPmRB9RzX0pQqIsKAC1Z0AxQyIRIwBxwFuNV+wMQn4CH0eEj/tbI1YBDPin6pLOgf
	 m+yl7DHjV/+/J6pOglSxkRDbi962fbWjjy7gsF/JijUKm4wIUX/kAAA8G88zRJk/+V83W
	 PaUwjn1jfPtp/ICJWbyoEvxJqJ3KVZl2TPmHEYXwT+i1L6tKvVshftfUpNmzJY2jSXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZxCMeQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAACE60A2609;
	Wed, 18 Nov 2026 20:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZxCMeQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D1A1F000C5;
	Wed, 18 Nov 2026 20:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034171;
	bh=ZfqSGBWCB0DwDN2vhA8/zVtQEbM/CcCOW/JQnmNVs+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZxCMeQx6IZr5LGtf6RcPmnpujN9yAmSXN5Tm7RtseoEc5yNsGemp7h8HCT48FDkw
	 W9wMMEEdZT/5KMVBJSUp1V4iqpwS+cufi/R7cIXflOzbewcaliS7jJYWZZQvwmV53g
	 g3nubbhnAbP2xH7wrZkzBuupRL7hcriy4nfOiMvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0248/3318] Bluetooth: btrsi: Move set_bt_context after successful HCI registration
Date: Wed, 18 Nov 2026 15:14:30 +0100
Message-ID: <20261118150322.721343339@linuxfoundation.org>
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
index 0c91d7635ac39..eb136488db093 100644
--- a/drivers/bluetooth/btrsi.c
+++ b/drivers/bluetooth/btrsi.c
@@ -117,7 +117,6 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		return -ENOMEM;
 
 	h_adapter->priv = priv;
-	ops->set_bt_context(priv, h_adapter);
 	h_adapter->proto_ops = ops;
 
 	hdev = hci_alloc_dev();
@@ -146,6 +145,8 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		goto err;
 	}
 
+	ops->set_bt_context(priv, h_adapter);
+
 	return 0;
 err:
 	h_adapter->hdev = NULL;
-- 
2.53.0



