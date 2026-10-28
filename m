Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214762;
	b=Vmt87vgSn2hO2DEWXELZ/YkmWlEViBhTIkMIXql9OBdXdeM/GpARg+hGQTi+7zBRmF5w
	 NGvZ4QFDkrA/xwVi8Hh0tim6N7ec58C7XW54pyBLHJL6x88lRKEex+E9i8AcOgDsjH95g
	 bOSS0VpQE/0Lb/59th/dWIX2y/D34H1/CSY2jL9SWAP4SDiE4q2u6zXbA45nxtwTPselQ
	 xIyqQp+tcnM2iuLXS5atxdbuCQ0Tirb0yGLTW3GXIn37/wDeTD4tYr+dOm+qGwMvc6vWD
	 4nhMEYIA5bjsyUVS9XJzhB/27feWDAoc7ghYnCiZUU1Zbcs55bPKAe+0hJSfDNuNsJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NBCu9LWtQea/WHpknd/cO5p4/eSPRORuqEcFP75W+I4=;
	b=ruAXfIZXtXQlkMnma8dvytvHzMRzqsFkKIZm6WD6di3F8dO0a5dcXMAB0EDGTD7x5rsz
	 0aVHM7u11ZQi3nYJvv4af/hxBvsUCPtXbV5S80xVIIhrxFhAdtXn5Jhg0GYaDWli/FTK0
	 REmnlLADrPmVhQaHtKvjRSI2iDMbFiqgOcwE/4gN4GYJXluKG2bZ3693RwFxdmAOq+YTl
	 bHsEe0STZG0pi3TsegI+MhvHmFwJt6zQddgQcbDtL5Ao4oSmIYyhhmn+yBFl0aHmb2JZ6
	 mC6A0j/XxO1XRunMPrjQ5P4mNIo15Z6Co+PFZjM81Vgh4UFiDl851pAfe0xMz6v7eAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IyVOzML;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CFE606A32D;
	Wed, 28 Oct 2026 19:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IyVOzML
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A1A1F01825;
	Wed, 28 Oct 2026 19:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214762;
	bh=NBCu9LWtQea/WHpknd/cO5p4/eSPRORuqEcFP75W+I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IyVOzMLEaY589tEoYzpeFnK+Rs735/wQyoxkeG8hwU+5Mo2mVepFy6rOkJ39/f9V
	 Ke8ohPW56aFDO7ERhYGCSqGq8uxrhJLT5pTYMBhexk6+ZKBQ9cZFRzuKqI0VjKXesw
	 SqazGvquCGXdt8Oih6ED8vDroJUNXHQ/iNPPGubc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0973/1887] Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists
Date: Wed, 28 Oct 2026 17:51:09 +0100
Message-ID: <20261028170521.551592155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 2969554bcfccb5c609f6b6cd4a014933f3a66dd0 ]

hci_cmd_sync_queue_once() needs to indicate whether a queue item was
added, so caller can know if callbacks are called, so it can avoid
leaking resources.

Change the function to return -EEXIST if queue item already exists.

Modify all callsites to handle that.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4e4eae12ee3fb..4295c803cfd4a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -811,7 +811,7 @@ int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			    void *data, hci_cmd_sync_work_destroy_t destroy)
 {
 	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
-		return 0;
+		return -EEXIST;
 
 	return hci_cmd_sync_queue(hdev, func, data, destroy);
 }
@@ -3326,6 +3326,8 @@ static int update_passive_scan_sync(struct hci_dev *hdev, void *data)
 
 int hci_update_passive_scan(struct hci_dev *hdev)
 {
+	int err;
+
 	/* Only queue if it would have any effect */
 	if (!test_bit(HCI_UP, &hdev->flags) ||
 	    test_bit(HCI_INIT, &hdev->flags) ||
@@ -3335,8 +3337,9 @@ int hci_update_passive_scan(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		return 0;
 
-	return hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
-				       NULL);
+	err = hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
+				      NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 int hci_write_sc_support_sync(struct hci_dev *hdev, u8 val)
-- 
2.53.0



