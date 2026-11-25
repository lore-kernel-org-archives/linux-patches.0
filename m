Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624335;
	b=t4Y61uDaqM5njR84tvd0GSJxfL0LgpUXaxdCBufRYQUey5NFSUjfZtuSenl5k8Eaia6y
	 bOJQChozMErFq/GwZhZN5wy2F6iWKVjYdYZzKiC/X8dUaLmtrF4XEMjuPa6KvO6U+rJe7
	 R7yXz1m0QnkGCNURdfFFW86F0lDI/nKUUoq5ixMDOnufGu0AAXBODTbVCjts8AYyBNCBo
	 CHqy+0ZBSnCDZ95+4gt9rT0N+gBsJiqRtVGMe6uBjQtl2rFcLVOzrHibCpnRDVmlWqWFY
	 SN81HqLkK9CKHB5UD1eBZ4V64r6OTuyUFAtttEm6Z7Axlb4GYim+jrShZQXWR82QDHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TU0FkHzC4kVCl3PyJxB7HWCJvicEJ49AJIDJhV3P2Q=;
	b=TEFO4Ms371cmoFAr/xfUIdPDr0cggnPcZFvJ0zdQ/BEqMHfahDJBooaz8l0yU33ZjhoA
	 z4hnd5xwSmTgujHdcDWihFvn7qFcQqS6UzRKt6e9Cp3+Pn/WRriWevmzJnrvHo6M74UlH
	 WjcpdIa/lMxKIgnqnTWZ1B05/Esguj2PCXfeZIVvjoqOqV12xUs3wQrB6y+OhxSo7jrtj
	 F9XJbB/vsmJz9GztBjj3hK1lIbi33987OU4ssFiV87+EtlsDaeW8j03HhD7ZZiptaZOMG
	 +n0vALm5dSBMazhIFEG76hSKpYopywDB+c1d0vmWg2VRAp6YZQmCgJcZFuuK9lUfp5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4iLRMvC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1209606A33B;
	Wed, 25 Nov 2026 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4iLRMvC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F631F000C6;
	Wed, 25 Nov 2026 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624335;
	bh=2TU0FkHzC4kVCl3PyJxB7HWCJvicEJ49AJIDJhV3P2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4iLRMvCTdVLY4rmqquhmT7nUXu6yMuG+vvhm6Zvfx1g/Y5m5uPB4klOkUU1UzEVw
	 QsNqLhwQBfg5STy+KCDQOe5webIgdqOKF+2YFQZJH1ibnbI9Obnh4spqyWZl0aVFPP
	 NWCVa5u8L+joU+sgWP8AS3n95g90mdWybz4aDAbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/816] Bluetooth: mgmt: reply to cancelled mgmt commands instead of silently dropping
Date: Wed, 25 Nov 2026 15:28:27 +0100
Message-ID: <20261125143852.876524840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c883d3da19030..a9570bd4f33dd 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -303,6 +303,8 @@ static u8 mgmt_errno_status(int err)
 		return MGMT_STATUS_ALREADY_CONNECTED;
 	case -ENOTCONN:
 		return MGMT_STATUS_DISCONNECTED;
+	case -ECANCELED:
+		return MGMT_STATUS_CANCELLED;
 	}
 
 	return MGMT_STATUS_FAILED;
@@ -5652,8 +5654,18 @@ static void mgmt_remove_adv_monitor_complete(struct hci_dev *hdev,
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



