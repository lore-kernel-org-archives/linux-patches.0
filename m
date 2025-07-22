Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B297B2ED14C;
	Tue, 22 Jul 2025 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193731; cv=none; b=AW9v2K4e7dDdRXRYf+k8N1a8A8Th60fV8keNtt0vc2jurDiDFCpOyCQvIZw1Md2+L6H+VH75kxQVLPlga0Dd3q3xo6++V6JkDR3Jtqc2gMtoYlDHKZr42iCRDiEf886bP5LcLDlvQT5iJfaGwBYGOHdgDtCmJ5MZI7dzGJjM53A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193731; c=relaxed/simple;
	bh=Em3yKPLIiaWbAonSyxXmYbReDndBNx9p1+Ats8TJZqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2w2y22pZUxEPvOuZ481plmVDckVETDRHm/X3wxZgbu6jGQvLN0eUItazjuip9Zbo6TDddJc8rYKXrodGgwBqk4GiFQrPIb9VmcqB9VgknaYy9M5JYCQI4GHXHYhdwUGIz3TR/YCj9kn3k8ocJeU/+TSx4Yi5lfSa9Glw51nHXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eG/YsrOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eG/YsrOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B08C4CEEB;
	Tue, 22 Jul 2025 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193731;
	bh=Em3yKPLIiaWbAonSyxXmYbReDndBNx9p1+Ats8TJZqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG/YsrODO2IYA1PAD48+qvKrvl0U0dX+f0BZq9xWHNqt/uqce99Jesdrzy9rkdkmc
	 3kmtkHGMQd+Try/qPnivbhJIkYeY6gzwp1mRkmwY9vLflIJ1bdQwJJYTbJjV3YsYDH
	 iczt9t+7aTBG43JpVDOu7mLQXqRIOVyLccApz/eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 138/187] Bluetooth: hci_core: add missing braces when using macro parameters
Date: Tue, 22 Jul 2025 15:45:08 +0200
Message-ID: <20250722134350.888761773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit cdee6a4416b2a57c89082929cc60e2275bb32a3a ]

Macro parameters should always be put into braces when accessing it.

Fixes: 4fc9857ab8c6 ("Bluetooth: hci_sync: Add check simultaneous roles support")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 08cc5db8240ed..f7f7e1974dddb 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -825,20 +825,20 @@ extern struct mutex hci_cb_list_lock;
 #define hci_dev_test_and_clear_flag(hdev, nr)  test_and_clear_bit((nr), (hdev)->dev_flags)
 #define hci_dev_test_and_change_flag(hdev, nr) test_and_change_bit((nr), (hdev)->dev_flags)
 
-#define hci_dev_clear_volatile_flags(hdev)			\
-	do {							\
-		hci_dev_clear_flag(hdev, HCI_LE_SCAN);		\
-		hci_dev_clear_flag(hdev, HCI_LE_ADV);		\
-		hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);\
-		hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);	\
-		hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);	\
+#define hci_dev_clear_volatile_flags(hdev)				\
+	do {								\
+		hci_dev_clear_flag((hdev), HCI_LE_SCAN);		\
+		hci_dev_clear_flag((hdev), HCI_LE_ADV);			\
+		hci_dev_clear_flag((hdev), HCI_LL_RPA_RESOLUTION);	\
+		hci_dev_clear_flag((hdev), HCI_PERIODIC_INQ);		\
+		hci_dev_clear_flag((hdev), HCI_QUALITY_REPORT);		\
 	} while (0)
 
 #define hci_dev_le_state_simultaneous(hdev) \
-	(!test_bit(HCI_QUIRK_BROKEN_LE_STATES, &hdev->quirks) && \
-	 (hdev->le_states[4] & 0x08) &&	/* Central */ \
-	 (hdev->le_states[4] & 0x40) &&	/* Peripheral */ \
-	 (hdev->le_states[3] & 0x10))	/* Simultaneous */
+	(!test_bit(HCI_QUIRK_BROKEN_LE_STATES, &(hdev)->quirks) && \
+	 ((hdev)->le_states[4] & 0x08) &&	/* Central */ \
+	 ((hdev)->le_states[4] & 0x40) &&	/* Peripheral */ \
+	 ((hdev)->le_states[3] & 0x10))		/* Simultaneous */
 
 /* ----- HCI interface to upper protocols ----- */
 int l2cap_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr);
-- 
2.39.5



