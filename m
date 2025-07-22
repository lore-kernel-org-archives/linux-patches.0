Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4CA32;
	Tue, 22 Jul 2025 14:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192983; cv=none; b=dku6JHDezVh7vJowHWJ1Fx2xH43uqBn2swoDugLwc3v/0lTim0nI5lXvNZvVJHeEv80oscpuoiVSHaRxurS6lvL5ClBu+dgNqQ8mIgTGkWx/PD5eRq3/LXbCjn8mDAd36iK28J1ntm4gU/r3BGGHtWBpAUG+DQCRPohnty0J3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192983; c=relaxed/simple;
	bh=mjFy+YILhpYIV+5pGW+9UBNdcc2iIWcFPa0N4hPxXpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVINo+6a6e+bTi2/GslgGpUfNLXDacqecT/upWtN0CpX3f1lez75rRUjducqGEQcwwBVAd0X05h2NfJMuODMOUMoeUZyZVsD7udQuscgFAw6IhrLRHdf7TxX+cVc/xfS6Ab8FJHr+GWXD6rZHgRAIkUzbRp+R+hN4Qi7YGyMVHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEQxvUdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEQxvUdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49FEC4CEEB;
	Tue, 22 Jul 2025 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192983;
	bh=mjFy+YILhpYIV+5pGW+9UBNdcc2iIWcFPa0N4hPxXpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEQxvUdM1hCc4hgTCkLi5YLBP2q6An3EFsqwb5Lf22b3Ogf+O7tmZ5JeX0J8PCq8G
	 hV56x0lB3lSOGNUv3hpkbcjdKYH3ik3rtvrOmEDwA3BSTeJ4h4ln206zF4zPeipWmf
	 MjL6IX1c0cO6npo5d+X/fA14OF6dEwzmX49M8ziU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/158] Bluetooth: hci_core: add missing braces when using macro parameters
Date: Tue, 22 Jul 2025 15:45:01 +0200
Message-ID: <20250722134345.111361909@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 730aa0245aef9..3d1d7296aed91 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -817,20 +817,20 @@ extern struct mutex hci_cb_list_lock;
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



