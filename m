Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020258;
	b=cehGXtG/I/IS7XKjc20UvCIGrKh4Rp+P+IIk6pX8cfnCFO5mhaUrdN9KxHCID3+u7z+S
	 btphoDsiZP1BYXzHKQ+KVV5k3MPO2n/gCo8mFISX5J9oubnu9qAXFFEjZ5/Up/EB5Fo5/
	 LxQJbMFB95PzSowN0Cmp7jmIBQCKFSFVSOXhMg5D3khlQVSpTYrt1D8MqDT9eGWcl7OIm
	 7lhOgKvZIZlz5o9NdyJa+Fzg+ldf82WZ06jbp8sHCUR2k3Cth4rxViEQJwZIbBx8HjE5Y
	 2uVr+Non3RMeLKYhF7u4q6bU45iWZiJjge7QqwHYFxhOJV+dGEmrwdj3bZulSIAyHkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xpUxm6IxPPfhNsoL5v8CJ+WWGR8WUCOYO0TULNpOVQg=;
	b=Xf0g2MPkkkEpVj9gktevKUV/oZ9T9UgHH84rzGh/mYPCgWsI/eoCyucsbjy5K4+6owTv
	 mFrokCPVDTn0O52IV0NAD8S49k9xibNRGdvTCVDdRmdzLutSXVuyJv/yADi0Y92Lv7QmG
	 zjdw2u7IIAPV5XAL2hpxpLXUl5LmxB7n+T8jBVk1PhIq4HgUF6s8G4Co38bTUcTwEaFBF
	 FEtq32hYmUh1QmI9IPQxIw7I2oRBSDNILZef/R4gF3t6gE3RZjKeE1hvFsV+FwX3+DfLA
	 mTa00jWkPHxEoSXD7A095Oc0hJGSzkQGFLM/e9dkJR8B7Jz4yXm6Hv/2k38Rc5XW7Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Thnahbss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F303606A32C;
	Wed, 18 Nov 2026 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Thnahbss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956371F000C4;
	Wed, 18 Nov 2026 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020258;
	bh=xpUxm6IxPPfhNsoL5v8CJ+WWGR8WUCOYO0TULNpOVQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Thnahbss4T/VVpoiYpsogj0xEg7slv2lDPGgEPLhPXBHy8u9W9rYMtH9/bl2uyUvn
	 Sabm5GAM2dTIO0dxDFe82T4GREJ8xbKD6Huhdss4F55N4881fwFCd3LBNhlJdy38w2
	 umL+VXzWmXLP6ohmVCMnv8fmqeOFM8oFadSZV7d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1888/2651] Bluetooth: hci_sync: fix mesh adv timeout units
Date: Wed, 18 Nov 2026 15:52:08 +0100
Message-ID: <20261118150354.864434680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 8a8d51eeedebfa5aaaae7720f2fb2aa1a67b8587 ]

Mesh adv instance timeout and duration are in milliseconds, see
mesh_send_sync, hci_add_adv_instance.  hci_schedule_adv_instance_sync()
and hci_enable_ext_advertising_sync() ignore this, and scale the timeout
wrong.

Fix for mesh instances by using msecs_to_jiffies() in
hci_schedule_adv_instance_sync and fixing the scaling in
hci_enable_ext_advertising_sync.

Fixes BlueZ "Mesh - Send cancel" test failures.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Assisted-by: opencode:qwen3.8-flash-next sashiko
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5b99da7028b9d..ea75c823ac522 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1672,7 +1672,8 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance)
 	 * scheduling it.
 	 */
 	if (adv && adv->timeout) {
-		u16 duration = adv->timeout * MSEC_PER_SEC;
+		u16 duration = adv->mesh ? adv->timeout :
+					   adv->timeout * MSEC_PER_SEC;
 
 		/* Time = N * 10 ms */
 		set->duration = cpu_to_le16(duration / 10);
@@ -2103,7 +2104,8 @@ int hci_schedule_adv_instance_sync(struct hci_dev *hdev, u8 instance,
 		hdev->adv_instance_timeout = timeout;
 		queue_delayed_work(hdev->req_workqueue,
 				   &hdev->adv_instance_expire,
-				   secs_to_jiffies(timeout));
+				   adv->mesh ? msecs_to_jiffies(timeout) :
+					       secs_to_jiffies(timeout));
 	}
 
 	/* If we're just re-scheduling the same instance again then do not
-- 
2.53.0



