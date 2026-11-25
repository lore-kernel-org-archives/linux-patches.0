Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618233;
	b=4ycL0UYpoGx19CXmvXypj8CPk1gsxqJ0LTd0oQdeJtr9kSZjtiw+lO+FIk/p9PuJTh95
	 WC8MqTL4wFfEqTjDVRgz7i1GbPBr4SIAJz96taQpiK22ZbFSrWHe+09CmUGT2vTUPGntQ
	 WIrStqCe6ZQK9e9muzGxVdrdreTYTHxHT7p8IhLLrnsiloPIfvQ4OgojLJAELC4syULdC
	 ZzJI8h9bnyRN6JBfZoNb8ZpnG30r0wLFcuNmZSJU/7KZW84I6J0jIrzcdA0APGZQqPvHO
	 G3opmWQTgp3ZaRwgcZwA8rX+89u3AgkW9K+Ye7zChcM9O2FnO1E5LTaeAmuKzQfjGUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WFVjX/kb2cXcNMT9wGvrKPMCqpftw6yPbux46Ka3/KI=;
	b=kCyJEvDjMN01XN/Wh663iwI3LgJhg0srUkzXKNWhEb3nFBJqaM998/ohVBTu5VV7X5JH
	 jRu5nE2PeBPfei9nyRPMGjSvqwUqjWQj1BEKhUQPQBZx7gRo3qQU//GNESh3ouQ+sXHEk
	 1rgJRJyy6fQIIyY0YQSjWS4c8L9vm7tGYjn/JnWo8+a3TUmdA/ziUf1IZEp5ZaIINyTiw
	 oMFrcZ+aIEUWuierbfDkfIbqpZuycqtFe3fM85Gu0BePz0I1fB93SHnR+a6ZENR6wyRpy
	 lORtMVFKbtbLP4yZzb20TK9zQyAvDfgzWK7stvH/1CCgFsMnhNrCB9iU7U0mLWnAWAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q7B8PF/k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AC3606A323;
	Wed, 25 Nov 2026 14:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7B8PF/k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61921F000C6;
	Wed, 25 Nov 2026 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618233;
	bh=WFVjX/kb2cXcNMT9wGvrKPMCqpftw6yPbux46Ka3/KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7B8PF/k73kbZj6iFkA/9HIDXAhmWTXZBbdlizz5rPawStodGOraKfK2M0NjQQIbL
	 xz22mSatg6vXf8p87/cdScJssdviMLtWL4kFgd85B77ArPWaqIRoKwhe55Ddu3o9WO
	 6pGXEvoV/OOf7PZQbo4YzloXswJ9wxX0zH/uojqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0212/1005] Bluetooth: hci_core: Initialize advertising RPA work only once
Date: Wed, 25 Nov 2026 15:25:50 +0100
Message-ID: <20261125143826.709459890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit a7c5c18b7cc30dcd2a9ae5a0fb38378d3998417e ]

hci_add_adv_instance() also updates existing instances and calls
INIT_DELAYED_WORK() on their rpa_expired_cb every time, even when the
work is pending or running. cancel_delayed_work_sync() then no longer
finds the work, so hci_remove_adv_instance() can free the instance
under it:

  hdev->workqueue                 MGMT_OP_ADD_EXT_ADV_PARAMS
  adv_instance_rpa_expired()
                                  hci_dev_lock(hdev)
                                  hci_add_adv_instance()
                                    INIT_DELAYED_WORK()
                                  mgmt_pending_new() fails
                                  hci_remove_adv_instance()
                                    cancel_delayed_work_sync()
                                      returns without waiting
                                    kfree(adv)
                                  hci_dev_unlock(hdev)
    adv->rpa_expired = true

The work has been initialized on every update since it was added.
Initialize it only when the instance is allocated.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in adv_instance_rpa_expired+0x139/0x160
    Write of size 1 at addr ffff888108d84b2e by task kworker/u17:0/504

    Workqueue: hci0 adv_instance_rpa_expired
    Call Trace:
     adv_instance_rpa_expired+0x139/0x160

    Allocated by task 560:
     hci_add_adv_instance+0x68d/0x9d0
     add_ext_adv_params+0x4d4/0xb60
     hci_sock_sendmsg+0x128b/0x22e0

    Freed by task 594:
     kfree+0x307/0x580
     hci_remove_adv_instance+0x230/0x540
     add_ext_adv_params+0xa43/0xb60
     hci_sock_sendmsg+0x128b/0x22e0

    Last potentially related work creation:
     insert_work+0x37/0x210
     __queue_work+0xaba/0x1270
     call_timer_fn+0x171/0x500

    The buggy address belongs to the object at ffff888108d84800
     which belongs to the cache kmalloc-1k of size 1024
    The buggy address is located 814 bytes inside of
     freed 1024-byte region [ffff888108d84800, ffff888108d84c00)

Fixes: a73c046a2869 ("Bluetooth: Implement Set ADV set random address")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6778a97386c89..cfc6d3db32bb6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1700,6 +1700,9 @@ struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 		if (!adv)
 			return ERR_PTR(-ENOMEM);
 
+		INIT_DELAYED_WORK(&adv->rpa_expired_cb,
+				  adv_instance_rpa_expired);
+
 		adv->pending = true;
 		adv->instance = instance;
 
@@ -1736,8 +1739,6 @@ struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 	else
 		adv->duration = duration;
 
-	INIT_DELAYED_WORK(&adv->rpa_expired_cb, adv_instance_rpa_expired);
-
 	BT_DBG("%s for %dMR", hdev->name, instance);
 
 	return adv;
-- 
2.53.0



