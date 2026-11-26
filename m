Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704244;
	b=L+UzhFR8KVzgC1oTuIFobAjHMw6TYglMhzK6BaVtRV7fRGWJh3Rj3Tlm9NamixlorN52
	 xRF064Rkp3UGr+RnMrHPcb0idKTHs9n1A3euQFpcl6SWvP05jjtYZjIsMesOyMs98KKT4
	 Vv4rIl1To+g8TPiA9Xe0EjsHJH1pQza+cDAcXu5ohjLHUTSUPQHyAWrd+Fokf206PQx7r
	 HqWn02hbKnWuznVduZyRfNyeuvn9xqNC+IHZLkgWQ5mKwBMdV+OpQAMxMcdVk7dbqhINg
	 aY4LLUeZTIiRoc3Oy2bhvPpQwK7KwJSUot72hym5Ktn0sW8FC5FjBeH3/s3vmfj05gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ozh2EbnTgxl0DfwjtLaUS7/ySxndptpOmx5VUH7TQ/A=;
	b=IuiMDOwzj9TnPq/56x7EOU/NElWPrwlH0M6CJVUvqyFOpYSFf9Y2rrd8QrW38tk+uihu
	 UvtDmZnztoyf9b9BLCfIZvu0KzQ6dDvV0yRwbtJpvL/nwYuZzwLhc1HcvJzctSx8NCH8H
	 TGYtSkVY3Pk1iCuQG+a7kDi6cIAMlpJxRa1BvgvquW4kxCk6zRpmHZlZUb6QANqGUnUJD
	 jTLcZuZhe7fI5Qe56m0bdN3DD3lqHWpBIpjAzkpD9wRMOtbGnIqOm2o5bJULED2HLwfxt
	 zql2bA0Uj358qHbuU9gTBLhiWAGMJiky+RcWOGy4zGhVOElukAORjKCiJpCriRcv+oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdTqrpv9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38FD606A329;
	Thu, 26 Nov 2026 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdTqrpv9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387E21F000D3;
	Thu, 26 Nov 2026 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704243;
	bh=Ozh2EbnTgxl0DfwjtLaUS7/ySxndptpOmx5VUH7TQ/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdTqrpv96lwIIjiengQA3HCPLb5xn8V/17khTyuk1Cg1mDrzfiSYIesS8kc+pBZVU
	 y+qLBVUadOXaPjL7iTwSDj3zT0B8h40V4u+BBBcd1QpxaqT2hRjl3ASu6ghyNLWu2B
	 mgWNNBc+pVRtrboiI7weEnbUEZLjZLxZD8Lpvt98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/265] Bluetooth: hci_core: Initialize LTK before publication
Date: Thu, 26 Nov 2026 15:36:27 +0100
Message-ID: <20261126143609.071295596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index 375b2534e690c..9b297578bc01d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2526,7 +2526,6 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->long_term_keys);
 	}
 
 	bacpy(&key->bdaddr, bdaddr);
@@ -2538,6 +2537,9 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	key->enc_size = enc_size;
 	key->type = type;
 
+	if (!old_key)
+		list_add_rcu(&key->list, &hdev->long_term_keys);
+
 	return key;
 }
 
-- 
2.53.0



