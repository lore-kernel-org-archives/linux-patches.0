Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830846;
	b=ZNCEoFImfGD1UbvtwxKfsn64e/zabf3Godhxx6PvlyGjHjIxyse8qOcCLd4MAa09jda4
	 47u2AfpuZRIm2HWIqqBhZCCpCaWyMEn7MgTxTqaKpHNw7s/IaUCqJrMrVjMQyf+ZVMjBr
	 GBuLRNmdxFgjnEJjxOFtMGfy/w4PfQmhP1Ak0pDq21kqxe7NcbZuY5BqoKIZ2PMN7kYcM
	 Ddro+9D1o0iRupvBw0IUg+DYwxhObkU8cGGq5SLMV7dphXUDvTsqF1B5QeTFYDEIFTq99
	 JXPy1EoPKCHoY6OQCkmp+RMOyr7kBI1TmTH8jaDLffeS4GAGueivHMu16DUdBUys8EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k+1dx9NERD9mNbUN3G+8RSc+7NZRkNNFDzLWp0QyIjA=;
	b=DG6OX3bpxdfon/6xzM8vZujR6uL24pPWzcqB0Sagi4qTHud3w6pRLxE7noNBL8eq2vfK
	 GvxP9tkzl+B6HbZrFpAaBcDvrnyv03oIYyemMDcf8AvHN6UL6fPZDfmOn81XAYbmHuh6/
	 KhcJE5xxrJ1UaCW8mdNCg0fQMDfd2urqglg/WxDGP3Tjry7gDgqdphqSQ0fA0ArSOqVZh
	 IzH5sC7NcQk5B3VU1mELHhmofjYNWuxXUXJiXUGO/5cJlV0PPS5zYnr1JSXoGCK6kzC/j
	 yn+ThWfc4WM9lL6hdUr2efD4gpaSMyMSzIe4qzE9i3tjpq8//S8daAyszfVEaYZANvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJd+zxzg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB751606B2D8;
	Wed,  4 Nov 2026 22:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJd+zxzg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733431F00919;
	Wed,  4 Nov 2026 22:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830845;
	bh=k+1dx9NERD9mNbUN3G+8RSc+7NZRkNNFDzLWp0QyIjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJd+zxzgoIRlgm22ViUvsnemCPFaAjoQ22fIxZPNObQ4+LpXCL/6jFbWhS2gZa/+1
	 trQ7stA44vkKEkh8F5IunShaaVdsolowmahGJ3a7ct1WdK0Z7rEZjdTkoUMlh9zgcr
	 xryasbgUpsHBl58r6IwHH4Rvwgs5XaDBzE6QfZhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0357/1005] Bluetooth: btrsi: Move set_bt_context after successful HCI registration
Date: Wed,  4 Nov 2026 16:01:30 -0500
Message-ID: <20261104211054.084800150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6c1f584c8a337..0e2894e93e82e 100644
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



