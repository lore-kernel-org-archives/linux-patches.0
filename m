Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624302;
	b=wM15ZYxYo1JTJeU/bh8A5QaSrSLebFGwppWc9eNIa/oqRb/ry7GdITMKvV3oJDgiduEK
	 pDTnLK/odu6bovwM/UwdwOe4k3CyOpzJO18VDPtRSIOoEsUmUu/9leCSlo50SERruhlYy
	 sJlSIrlNIkoejJUvlXwTKRFhS9BGhhV2Wn5yD4Jh9shI2wPorbPg88WIJRPYLU+7sSvbQ
	 okLvhlDyXiKKHZHMrpR2ijdQmlAdfAMDbk6as68UjWrWZIGQ2FUQ3+ccdbSy6SP74HJ/y
	 WJbjG/MiTiqseXANyuLz8WiyeSBwdRSmRHTHhcBGLTgFK6/e+pTjUINbQTi70YduMGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qFGG3P4wu55HFyFJZj53oXLku7eUPB113OC56ms0n2U=;
	b=gpFYOSq3E2C5QumDRLPQAMZ+L6HEVYsJIUqY2xy/agcZp1B8sKLC0CBRltGVz7Pr3hVG
	 I0UwhOV0AVDDCV/6GnMSgFcKOTCddYT4OtlhyXnud9Aur7kk1stAblihrU4BlOQWRZNfn
	 IeKwrJ5dv9EwBCnjL27MVjQQq6AzScUz4+1dZaIQF50uHOGaJbzVkpMiQYU1BbkRZtW1j
	 y/m7iZIOa05yzvJAIwryH4Wtn4sWgd84iSEw0fukrPhVxEWKuEkkkOZU6YOebafDHw861
	 04bAHKC68bW8R1iF3TDe3h2tux+rDR1gRgm5My3YFjen7FPPiayZziJKXsaIIBZFpEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6Bk7kec;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7B0606A33A;
	Wed, 25 Nov 2026 16:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6Bk7kec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF7D1F000C0;
	Wed, 25 Nov 2026 16:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624302;
	bh=qFGG3P4wu55HFyFJZj53oXLku7eUPB113OC56ms0n2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6Bk7kec5WxG1r8212BDdyQXXsgYyHqUci8l75Xoz8DUZVP2wmblh7ULlnW7A776h
	 Dm+aXWxu4sV/U3rbez0Cnc0SFXKeSEGL7QV1qjR3cbg1Z6LPUGZm0C9X4Mne5Gqbt0
	 xaLQSp4ln/TR+kPwwsH6ZBloIHUUbqpjB5nKqtpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/816] Bluetooth: hci_core: Initialize link key before publication
Date: Wed, 25 Nov 2026 15:28:17 +0100
Message-ID: <20261125143852.646347359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit ae9c8df1ffb84560ac01cbdc26cfb19027f4d25f ]

hci_add_link_key() allocates a new link key with kzalloc(), inserts it into
hdev->link_keys with list_add_rcu(), and only then initializes its address,
value, type, and PIN length.  RCU readers such as hci_find_link_key()
and the debugfs link_keys_show() do not take hci_dev_lock, so they can
traverse the new entry during that initialization window and observe
a zero or partially initialized key.

This can be triggered by racing a link-key update with another CPU looking
up or dumping keys.  In particular, userspace can issue
MGMT_OP_LOAD_LINK_KEYS while another process reads the corresponding
debugfs file.

Complete all fields of a newly allocated key before publishing it with
list_add_rcu().  Existing keys remain visible and keep their current
in-place update behavior.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 0378b5977013 ("Bluetooth: Convert link keys list to use RCU")
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5d1acf534a796..ddd0bbaf247e0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1290,7 +1290,6 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->link_keys);
 	}
 
 	BT_DBG("%s key for %pMR type %u", hdev->name, bdaddr, type);
@@ -1314,6 +1313,9 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
 	else
 		key->type = type;
 
+	if (!old_key)
+		list_add_rcu(&key->list, &hdev->link_keys);
+
 	if (persistent)
 		*persistent = hci_persistent_key(hdev, conn, type,
 						 old_key_type);
-- 
2.53.0



