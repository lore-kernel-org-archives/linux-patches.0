Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705059;
	b=owffeiTPcsc0E0CpeqOaVPX2zWLMscnxpW6xC7U2OS8XPMxbO9sZ8lNqaU8D+KRltnpT
	 TwHg6stUdQ7aIg+1B7t8W6Ds4iyAEPzi8VADKzjm0sbyJhWZAssjGSdong3LWPJlDurI6
	 0HwzaRYRXHcgtvaSWW0HT9+tUVBdmlFHqYkFhFRZa8DN8Z4rGHX6rbII/hVrd3BKpvajM
	 x25T8moDOMyDtax6qyYoofAIB+EU+0VoKP0nMqBtb4/dH6UfNAmQjkPt9g3BKQ6TWVTq3
	 OpxdgkfVAzo+HteB7sA/Wv5Oohm+NLdzEnJKeZVxPiZriiBVzzBxvPAzfrcvaUjfzzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aYehoLzGdVIelOCDcy6oxjb2D34iWwTHOPTVtEtp1LE=;
	b=tVGNiglS6R9EskiUBNsH55zgz3/jQRdggTNlx5cbebyZJdK8dOzYb0ssTRe9VWMS8Sb4
	 hAKU+kYC2ZkVDLrFGzDFKTXekuiiz+thCHF6DWH5NTdClmofmd/bUazKQSBQVdxsaI/TT
	 P76Rn4nclUpzYZXU5YMBkWCH1lllZWhT8KkH4ShN/oATHuLPQ/ysKOLh311IzCCWd2OFg
	 RzNt4LjinKYwwd/aVsveuuE/T8S5bwhwbxVUaUPfGxMSESqSVHyTLi2KpSjKgoJs3uL2s
	 I4/0fsJ05i1vr7vX4rIc5yEVbOWks0gbX+RRin33bHDnilCKa5P8uy+54mZ5bWSoufA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZMUXBU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD92606A6A0;
	Thu, 26 Nov 2026 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZMUXBU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B6D1F000E1;
	Thu, 26 Nov 2026 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705058;
	bh=aYehoLzGdVIelOCDcy6oxjb2D34iWwTHOPTVtEtp1LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZMUXBU4v1cXgBOwUPQc4eH91K9r0tKV1/O0xZPpbnkAs2zuDEIyilCDLrQCAkk3X
	 wRUM/JMu61cdozwe2glyBCBlJJpnjdMzC/bvQo5HNPfOCnm2PSHpnyZD4wwGVzFOlD
	 Jm9lnWu3y4aOqKfpSXCVrbGG1UGzvM9RndOArmhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/319] Bluetooth: hci_core: Initialize LTK before publication
Date: Thu, 26 Nov 2026 15:37:15 +0100
Message-ID: <20261126144008.249970425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index c5e4616edb04c..ee68241c1181d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2538,7 +2538,6 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->long_term_keys);
 	}
 
 	bacpy(&key->bdaddr, bdaddr);
@@ -2550,6 +2549,9 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	key->enc_size = enc_size;
 	key->type = type;
 
+	if (!old_key)
+		list_add_rcu(&key->list, &hdev->long_term_keys);
+
 	return key;
 }
 
-- 
2.53.0



