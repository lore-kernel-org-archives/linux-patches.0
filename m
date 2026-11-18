Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049866;
	b=00vzAI4lMkwjfAVHlQODZvQOs4g8MOAkygGjLJAJyA99uvZ0UI7H4c0BhOj0LAon3mv5
	 l4Kk7dwzsbshBRcygiRZeseLrSTFzR+9Luaij7wrMSLSFKp6aQH7iDSCMmv+8HF5tzjAa
	 Uy1GjBO/lMKnlbIn909v2uRRSnk9bKm4y6q95xv5XfeLUJJs6bqnuPs8OWib3/9S52EJU
	 0wmlewoJRf4EpLpMSWr+G1ejFgaY1lvsz/D1H0FZAcCGgTMonDiFlRFxXnPOwckLdknAt
	 QUc3+0A4+IZAVJ7g+6DhAQH5PDTMjDxVJTc3hY4UCDspw7QRUwIkcpBVdc0qJi1OlOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DK3Zt9OhtDvjM3WxzfAgZKTFyETws05dpci0j6ixbDw=;
	b=454AitX5sJF0bEJPCRfq5ef0KYUX0eomqZ3Pg1XzxQ4RiHeb0PtemG2MLPl+V0eZ00Ix
	 0VmE7kgEHHTmACILMFMZq7xJbvIacoPXkOPBymi31r1pRaMR34lMz2zgzC7xtHwjNFW5x
	 pCnkWFGnKnEg2Qh9J9GO+Jb7MMUuGaM9t8+6uGBX0bzkVea6KLkRjjHLzOrHwGsarPr9h
	 j9zhp6cDDsAzqa7GF+Pe/jXN9X3jiW+oevvzzIqSeuT89LnMN/39t6UdlHEcPzypdIqM/
	 9Qs7ftIJd8OjuugtOyv5H++Ahw2ykVdMZgj52SZYsMa+yBWlzNNTOmT6XfuWFXBPPTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frQ4j5FN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02591606A325;
	Thu, 19 Nov 2026 00:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frQ4j5FN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5133E1F000C7;
	Thu, 19 Nov 2026 00:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049865;
	bh=DK3Zt9OhtDvjM3WxzfAgZKTFyETws05dpci0j6ixbDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frQ4j5FNbtjxag6T/ouadj4g2PCReEgEbn+UH0GJZhgykd6lRMmR869oNyXNlou7d
	 02FNNrADjfEk921wS8mgMdqaZ54LuR7pnTjxlnT2k+9XdZmrgFQXTZiWiV0QrHvw4i
	 Pm9zfOsQ2Qid+BnHvbm+Ulhc4CIFjmIGn4FzSF/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hilda Wu <hildawu@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2505/2857] Bluetooth: btrtl: Add btrealtek data struct
Date: Wed, 18 Nov 2026 15:58:59 +0100
Message-ID: <20261118150331.750124391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Hilda Wu <hildawu@realtek.com>

[ Upstream commit 5b355944b19011011dd3fd4187444c5ff1d76ad2 ]

This patch adds a data structure for btrealtek object, and the
definition of vendor behavior flags. It also adds macros to set/test/get
the flags.

Signed-off-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 56e20c3d8ad3 ("Bluetooth: MSFT: Serialize handle map cleanup with event processing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.h | 21 +++++++++++++++++++++
 drivers/bluetooth/btusb.c |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
index 1c6282241d2d2..349d72ee571b6 100644
--- a/drivers/bluetooth/btrtl.h
+++ b/drivers/bluetooth/btrtl.h
@@ -52,6 +52,27 @@ struct rtl_vendor_config {
 	struct rtl_vendor_config_entry entry[];
 } __packed;
 
+enum {
+	REALTEK_ALT6_CONTINUOUS_TX_CHIP,
+
+	__REALTEK_NUM_FLAGS,
+};
+
+struct btrealtek_data {
+	DECLARE_BITMAP(flags, __REALTEK_NUM_FLAGS);
+};
+
+#define btrealtek_set_flag(hdev, nr)					\
+	do {								\
+		struct btrealtek_data *realtek = hci_get_priv((hdev));	\
+		set_bit((nr), realtek->flags);				\
+	} while (0)
+
+#define btrealtek_get_flag(hdev)					\
+	(((struct btrealtek_data *)hci_get_priv(hdev))->flags)
+
+#define btrealtek_test_flag(hdev, nr)	test_bit((nr), btrealtek_get_flag(hdev))
+
 #if IS_ENABLED(CONFIG_BT_RTL)
 
 struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5599f77dc6efd..b850b6835334b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3982,6 +3982,9 @@ static int btusb_probe(struct usb_interface *intf,
 		/* Override the rx handlers */
 		data->recv_event = btusb_recv_event_intel;
 		data->recv_bulk = btusb_recv_bulk_intel;
+	} else if (id->driver_info & BTUSB_REALTEK) {
+		/* Allocate extra space for Realtek device */
+		priv_size += sizeof(struct btrealtek_data);
 	}
 
 	data->recv_acl = hci_recv_frame;
-- 
2.53.0



