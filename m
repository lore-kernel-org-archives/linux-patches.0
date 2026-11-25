Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621301;
	b=H92Tx9zoCec4j2+qOM+/GJILDcyL6Ns2CJ/m04S3lAsXPPcTiojwGguqLxmNNwazKc89
	 RgXZCR2idwbgwyp1doPE041H+FKihILGf5uf+9fSwl+4xuuXP04HMIzqYd+ABQ48btJRF
	 Zb2AzyuIwhsF6t84qeCozWQong70HWb/WzLI1LJ3e1ZzhYC/pnqtlgSDVdxtKtS8qgUsZ
	 ja6Un62baewM7+tXAPS8/6wXfwtMKLFNq+FIFvTxWWXteJEVhu0yUO9NmJvU8mQRDHTOd
	 gLQ75i79TFHqNmMU6hJ3xRDeXoN0s62tQwzKAIZfbwfY2cksduYLlUJUp8oHtxNoUYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5lJPNiAlaZAC/cr7OK/yon0xRfO9aW509eQTVa0WTU=;
	b=HIX/zYYBujLz8vBUByfd3DeSs/oqbiIXV2Ky7qITywLNkl25QPX1njIDITfFAh2ueg0A
	 Pp2HRRfcX050W+TLvHuT0VCdB60O8eOLv8EEeJVK6saFpH8lAU6roJTk20/yxsNcUjRqS
	 vO1binUbMbp89hvmuMrW9l1OQLIkmdGoX0+SJzDk9ut1gmsyfsVgv4BOAtoMeXAZrxELd
	 BhbWp2e5bh9xde+jdmoMXoHUOYFxbA8Ed5EsA9JKKWK61fkRq0Hab0qLr76O93JFYPwZV
	 zxViQ/WqFLjkhbfENNMB5lSqieo07Z/0R//hZmnEzRjjRkiRWksOem5PM66aGFbk65g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Nzf1MLo/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3516607DE81;
	Wed, 25 Nov 2026 15:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nzf1MLo/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051FA1F000F2;
	Wed, 25 Nov 2026 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621300;
	bh=T5lJPNiAlaZAC/cr7OK/yon0xRfO9aW509eQTVa0WTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nzf1MLo/44DL7sYGE4ubrQ7c9GK1R0T5ZHzL6TQUieJp66zCjYjAoXmqY+swiwoY1
	 8Z8q/9rJTMXKeH3vCrtddYPsBhJHXCMphiuJtsyxozy/VC2M7bmD9R2yBkPn6ousrE
	 6vWuYcaUBhSD+ZDx4ZYUKAvZ+To2Lhio6pXLIdyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/990] Bluetooth: mgmt: reply to cancelled mgmt commands instead of silently dropping
Date: Wed, 25 Nov 2026 15:25:50 +0100
Message-ID: <20261125143826.380304555@linuxfoundation.org>
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

From: Shuai Zhang <shuai.zhang@oss.qualcomm.com>

[ Upstream commit c0bb764fc082672678d371c375597a6a9f614cf9 ]

The kernel sets HCI_AUTO_OFF when a controller is first registered and
starts a 2-second timer. On slower boots bluetoothd and the HCI_AUTO_OFF
timer can race: hci_power_off() is already queued while bluetoothd is
still in the middle of its adapter setup sequence. hci_cmd_sync_clear()
then cancels any pending mgmt commands with -ECANCELED, including the
MGMT_OP_REMOVE_ADV_MONITOR sent by reset_adv_monitors() early in the
setup sequence.

When auto_off=1, hci_dev_close_sync() skips __mgmt_power_off() entirely,
so there is no fallback path to reply to the cancelled commands.
mgmt_remove_adv_monitor_complete() silently returns on -ECANCELED, leaving
the command with no reply. Since bluez's mgmt queue is strictly serialised,
this stalls all subsequent commands indefinitely, leaving bluetoothd unable
to register the adapter.

Fix by mapping -ECANCELED to MGMT_STATUS_CANCELLED in mgmt_errno_status()
and replying to the cancelled command in mgmt_remove_adv_monitor_complete()
instead of returning early.

Signed-off-by: Shuai Zhang <shuai.zhang@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 7eac80614300 ("Bluetooth: MGMT: Return RFKILLED for Set Powered on a blocked controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5058fa2ed9a9b..6e49f77c363f8 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -304,6 +304,8 @@ static u8 mgmt_errno_status(int err)
 		return MGMT_STATUS_ALREADY_CONNECTED;
 	case -ENOTCONN:
 		return MGMT_STATUS_DISCONNECTED;
+	case -ECANCELED:
+		return MGMT_STATUS_CANCELLED;
 	}
 
 	return MGMT_STATUS_FAILED;
@@ -5614,8 +5616,18 @@ static void mgmt_remove_adv_monitor_complete(struct hci_dev *hdev,
 	struct mgmt_pending_cmd *cmd = data;
 	struct mgmt_cp_remove_adv_monitor *cp;
 
-	if (status == -ECANCELED)
+	/* Reply to a cancelled command so bluetoothd's serialised mgmt queue
+	 * is not blocked.
+	 */
+	if (status == -ECANCELED) {
+		cp = cmd->param;
+		rp.monitor_handle = cp->monitor_handle;
+
+		mgmt_cmd_complete(cmd->sk, cmd->hdev->id, cmd->opcode,
+				  mgmt_status(status), &rp, sizeof(rp));
+		mgmt_pending_free(cmd);
 		return;
+	}
 
 	hci_dev_lock(hdev);
 
-- 
2.53.0



