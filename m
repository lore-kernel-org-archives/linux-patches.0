Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621324;
	b=PCKInWHaXX4aH2hRjmHSJqjEVOY/jw3Dqux05ipzSpy/1Gom3mGiiYutpprN5XF//ifC
	 /WNg4h4o5UEX7U2t20rC5SDXuBum0ZPTaMcZg29mGkfHlisPPjgddisIZ6Vrq7eLEJ7Gx
	 93D37O2KREU1Rz22dAYNkuFLbg5vRI3/8C/cPjL0AqS+6iuGS2C+zx3PcyjgLVuZp6jwG
	 +z8BSTo/NCFNnVySTIMLZ3vEw10LtxeETFRA6Wu+6R6c6mA3FIMvfe5zg6jzzI+QELL4E
	 MnAmWri1ppw3xBThrgE5kgNdOSLAVgR8MveQj0/Fse8WC3J3VzZ39TGY5z7E1/ocLww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/7i5UjGnaOT+BE+uu/5IstyPiBN/1Op17/3b/lBFNEU=;
	b=EceSOAh/H2mCDTm5Q/UQzMYfigu/7+s1k373oCZWgOQ6VcHc7oRsAKhCmk3Mg64k9c3F
	 dBX2m0VKmcUbP3tgzu5FT2j6Epdl3iDh9skUwVxTOTQG3hHoUQyLYPJBtLkhpNzF7c21v
	 Ikox6gKryFUn7eRX0mCDDGPgJEl3WvhK4Kk881r+fbTdQzIKkORnkr8cxoe0hyFr54kP1
	 pxFx7/2fQDfBbAnkSs3Iq+ahGrrnVUgxZBKq6SBAwOHh3zlWF2/B96qRsE1VTdsJTHREf
	 3cA3kmDtRC6teNoxmfqo/HYJU1x+9sVlPp3Y3QzRx3xM7aKil1sbmOErHoRv1y68iSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeyKgl+Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC485606B387;
	Wed, 25 Nov 2026 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeyKgl+Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E318A1F000E0;
	Wed, 25 Nov 2026 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621323;
	bh=/7i5UjGnaOT+BE+uu/5IstyPiBN/1Op17/3b/lBFNEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeyKgl+QudBwI9BvhtdhF6lmXtjVQUuygcaMt1N8UlXvLP+IYpqz6FDCoEfeAZpnN
	 ckM2NIcVg/+mN2/xcy/mqg0myWYdnqzL2vmqfKb1vQ9zGbxaHCux9uUTn8ATy7Zwxg
	 P+pglbuB3c/YdLRk3tPCmL6Z1biicrnTAYgUAUBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/990] Bluetooth: hci_core: Initialize advertising RPA work only once
Date: Wed, 25 Nov 2026 15:25:56 +0100
Message-ID: <20261125143826.520960746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index c9b8fa9a2e88a..c19a9fa19e7d3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1736,6 +1736,9 @@ struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 		if (!adv)
 			return ERR_PTR(-ENOMEM);
 
+		INIT_DELAYED_WORK(&adv->rpa_expired_cb,
+				  adv_instance_rpa_expired);
+
 		adv->pending = true;
 		adv->instance = instance;
 
@@ -1772,8 +1775,6 @@ struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 	else
 		adv->duration = duration;
 
-	INIT_DELAYED_WORK(&adv->rpa_expired_cb, adv_instance_rpa_expired);
-
 	BT_DBG("%s for %dMR", hdev->name, instance);
 
 	return adv;
-- 
2.53.0



