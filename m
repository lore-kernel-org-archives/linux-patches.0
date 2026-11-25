Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621261;
	b=H8Y2orEUpbEuGUyGNST/lDn8D4bEKNQxYAORjGrqJmlhHo/p+e1sOyU5xE8+aFBG3/wW
	 Rx6QQ4ONGzgkrQPbVRwKxh96O6J6ZtSzSsw8wBdHL4gp0pjs7QPRSKhY/MT3Fxcd8K4yB
	 7nVi+hUjUVSEIl97ffA3MGCh2ReHQwVE6WAuSr2O8MDRpSVO+FJxO3/1eHTKegG1vIItq
	 uLSy2VQTMkuQ112zKQbfB6AccKB4iwzdGtRu249+xr0vZDJtDEUuLDrxegJd4SKBjlJvK
	 piyWWawUUMEaNPnIXyungLwjI/AUFiqbSR7KuqXKuasCD1plcjUkJK6sdz0iYp3PVhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cVQlcct+VT+lPKLLUePhofzVTZzmsqWz5tDqiV47mU=;
	b=UpYr1A0evaY1v72RP8Z6oHMzsy6mBMZKMiNWgPnqULwBQGwwsvhR6eIWC2T+3Pp0CLO0
	 Zc7i/N6vbxIqVDq+qp8DOQDXSOOOEOfepGnOuuMym+7MaUdlhcTR8UYiNA1pGOzITKW6m
	 1watxyCJ4rAydy2IIpXUnDzEua1TpW4wlS722t9msuxf9pAR8Cxj3/AJ1/QVs2XLL0TA2
	 3HsXrJwu2xPnw4lYbIYuFZ1fVUeD9aSNy/xrJFSxm3Zjfjqq7m8HUZUOvGWvljpTRcfLd
	 iBZdOnhaSEDdKrSNM3eHn1XbN+QXS2Elz9fAcyo9s0pNFClRTcAZ3UhF8+VpsvRppjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kH4DORAk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8E2606BF51;
	Wed, 25 Nov 2026 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kH4DORAk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1051F00A3E;
	Wed, 25 Nov 2026 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621260;
	bh=4cVQlcct+VT+lPKLLUePhofzVTZzmsqWz5tDqiV47mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kH4DORAkdtYwuJypbhy/3TxKhVfx7n8IZlHY0DhQkD6G4M3IJJscZE07js3jrrTch
	 p4GCMZ69QUBF/WTErAYSQ4HZj8GIk0arIL9DwZLb9q3igGO6ml6WtQ2QBq/fLD6jKM
	 YXDnfZOiyi0hgUmjxPo8tzTxHntAN+sF1DbhPF90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/990] Bluetooth: hci_core: Initialize IRK before publication
Date: Wed, 25 Nov 2026 15:25:39 +0100
Message-ID: <20261125143826.121851753@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit f0cf5a24cefeb629876bd15d668ff062c8655e28 ]

hci_add_irk() initializes the identity address and address type of a newly
allocated IRK, publishes it on hdev->identity_resolving_keys, and only then
initializes its value and RPA.  RCU readers such as hci_find_irk_by_rpa()
and the debugfs identity_resolving_keys_show() can traverse the new entry
during that window and see a zero or partially initialized IRK.

The race is reachable by racing an IRK addition with another CPU resolving
or dumping IRKs.  In particular, userspace can issue MGMT_OP_LOAD_IRKS
while another process reads the corresponding debugfs file or triggers RPA
resolution.

Initialize the IRK value and RPA before publishing a newly allocated IRK.
Existing IRKs remain published and continue to be updated in place.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: adae20cb2d20 ("Bluetooth: Convert IRK list to RCU")
Assisted-by: GLM-5.3 coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index bb5bbeefcc67e..78c4be8e7109e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1351,9 +1351,10 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			    u8 addr_type, u8 val[16], bdaddr_t *rpa)
 {
-	struct smp_irk *irk;
+	struct smp_irk *irk, *old_irk;
 
-	irk = hci_find_irk_by_addr(hdev, bdaddr, addr_type);
+	old_irk = hci_find_irk_by_addr(hdev, bdaddr, addr_type);
+	irk = old_irk;
 	if (!irk) {
 		irk = kzalloc(sizeof(*irk), GFP_KERNEL);
 		if (!irk)
@@ -1362,12 +1363,14 @@ struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		bacpy(&irk->bdaddr, bdaddr);
 		irk->addr_type = addr_type;
 
-		list_add_rcu(&irk->list, &hdev->identity_resolving_keys);
 	}
 
 	memcpy(irk->val, val, 16);
 	bacpy(&irk->rpa, rpa);
 
+	if (!old_irk)
+		list_add_rcu(&irk->list, &hdev->identity_resolving_keys);
+
 	return irk;
 }
 
-- 
2.53.0



