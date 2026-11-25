Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618154;
	b=qjbX1cIF4ekISFZ8s51dEIu7FvfYAU0nEGp0zaeA4JKJoNcsMnHUvvwKYE3tPF/mdGac
	 HjhcDLEP+1bqIVF0eiHligO8ORQ5Au9Du8gkWGVYT4hqwRj+Kid07SzjPzQG5i1woqjVd
	 EfdTucbiKLxNVeXx7L8pl4ScfQOzbzR3x+5k227ehf+8Nu0VssuP4OIpaVJlqoxpfjr6L
	 0zgWq8/KU+7jyk9nRqyXRn80+hCzRvlR5f/gXhaQmHz48a4naV6bfb0xqj6OCvV+HwI/q
	 QmzZ/BYam6M3CJhKlwyKGVUlyvVqBgw5VcZJGf6ohgK4cBp2fanPifBglpM9WA4cNJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/pLKPhNInSXHo8yP0DttnCDfGiTAlIMV1dLNPdWE4pI=;
	b=zLnLCNovK1wCRO4b1Au/31JXCX0h5FPZ4ILOOBRp2Y2lp+aVvXYvuh42//d1FmS5Edrv
	 X0l7YtJ0JPi+nGkp7rPyQwX/5OAu0ko/IVezWD2t35uBzkA4ujtNrWcuczpWzDPDeWbYd
	 AV57v/+NmF8NPP7T6a+Hh6MwFtm+kOdsnItZPSd8FE9yehNy7tLwcBIgeTJCwYjkvOLUx
	 ifCEcfQRvw2LNQRLGIub3mj7DvlLGi0Q4iXdjXDV764mJhojlBDB4ah1RYt5Z+mIdHCU3
	 JMIfg39t4OblJrDHnYoEhAR6EoL1v8y4fUeq1lPCaIbzDYzFYezKWRfONoi2i1yyuRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKspizFe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7A4606A31E;
	Wed, 25 Nov 2026 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKspizFe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8DA1F000C6;
	Wed, 25 Nov 2026 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618153;
	bh=/pLKPhNInSXHo8yP0DttnCDfGiTAlIMV1dLNPdWE4pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKspizFe6eTHCNhQv6dAuLsbGppETjxtEIweq2Bv97pn0Lad27ZOzk+xLD1cJY18D
	 C9QFZ4L7w3AGWJFGVWVEAOjEQDcLib1F4gwh18H1tlr9RNNie+OEJpBwPfEGXdEXH9
	 tW04vzlMPdP470gmcCbFx3vtoaESIbCXpv6hGKEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0190/1005] Bluetooth: hci_core: Initialize LTK before publication
Date: Wed, 25 Nov 2026 15:25:28 +0100
Message-ID: <20261125143826.191549197@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 4335849380aa1081ee9a1c2b934cbdda0961fa57 ]

hci_add_ltk() publishes a newly allocated LTK on hdev->long_term_keys
before initializing its address, type, value, authentication state,
encryption size, EDIV, and random value.  hci_find_ltk() and the debugfs
long_term_keys_show() traverse this list under RCU and can therefore see
a zero or partially initialized key before those stores complete.

The race is reachable by racing an LTK addition with another CPU looking
up or dumping long-term keys.  For example, userspace can issue
MGMT_OP_LOAD_LONG_TERM_KEYS while another process reads the corresponding
debugfs file.

Initialize all fields of a new LTK before list_add_rcu() makes it visible
to RCU readers.  Existing LTKs remain published and continue to be updated
in place.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 970d0f1b2803 ("Bluetooth: Convert LTK list to RCU")
Assisted-by: GLM-5.3 coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b285db239e6fe..a162877d1144c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1299,7 +1299,6 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		key = kzalloc_obj(*key);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->long_term_keys);
 	}
 
 	bacpy(&key->bdaddr, bdaddr);
@@ -1311,6 +1310,9 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	key->enc_size = enc_size;
 	key->type = type;
 
+	if (!old_key)
+		list_add_rcu(&key->list, &hdev->long_term_keys);
+
 	return key;
 }
 
-- 
2.53.0



