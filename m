Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043452;
	b=GkePWtpAX7BBQ6XgXBEznTxHcHCg+NnITIJjSY1S/pfpnpixbtY5jemj8t1/ASZjbzY1
	 mWSAvBgb46gUlvEf3Jxh07tF/gIZmWVK40L5bqxsuuc0CmAIM/V8Wb7kJa8W5bav4RLaT
	 gKiHxMVFhOKNmQIGuQs45h1PwgJMUnTH4lcGhEne1KhtmCCp9rtPKRJ3VDiT7Ow+3Rdfr
	 tczK/RHDTQ0pUXMEHqYT5kgIeEtxxCYdrnCznlZMC8Nxi8eMFppwKxpSlvOC9GTSOvpKp
	 AVtwr7d9lYvxg3y80NKsmRwnCCXVnEHGlLO7YtsWHVRCztChZ5AIFeLPyzMnzg1MxOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dvBokTEdtnAFY9YMQkqskLqf6JMiBfdiBF6VbzxKms8=;
	b=GPRtVk0bih8jzbMCjmfJKK+g+bTFqk2E+VC6Zwx1cda7D5FP5yxRN6F58t+4RMB0S8Lx
	 dyS6BV1KpRk/d6BJllt9JOXYl81O3ZUe+RaDXkSMojp2lySLHeaExEWKk5oaa5JE7JFUz
	 d6qcbsQiu/z3L6KxzmK0tYe12JyTVnr4AMoaZVWNJe8/PIGh/Bei6Sl05yZq0/hMFac9D
	 kTt3NTi2f0w2Vr5qE4KlqweGoS4FjRGfEOI4GafpwibWtIS3FbmBGPXCT3NJ1wSn0j0Oh
	 tBUkvFJQ4z/3hv18g7fZMDn2rbWZi1cwrz53TwOrQIgcVzclm1lNm8KSCPzTyLcWFdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fC7MPbUE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197CF606A335;
	Wed, 18 Nov 2026 23:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fC7MPbUE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A311F000C4;
	Wed, 18 Nov 2026 23:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043452;
	bh=dvBokTEdtnAFY9YMQkqskLqf6JMiBfdiBF6VbzxKms8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fC7MPbUETwdPRa1Gs+Z+YKcXymeNjY6AAq34namA2H69KIhqI/vQSwnRdpIBSliaX
	 /+5GZ9hYMQFv3y+znZ/Ah9VkVdNGVFDGNDWHHknhRWAePKB2WsEuwdVyfPROztRj2V
	 T0ZO8KTY97HIpsjBbi+KKah/tYT3k/hGB1okZgO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0215/2857] Bluetooth: btrsi: Move set_bt_context after successful HCI registration
Date: Wed, 18 Nov 2026 15:20:49 +0100
Message-ID: <20261118150209.204766351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



