Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618166;
	b=k+MxUTmvUfRyQXJsNg1y0Z/VQjZy9aj1cXf4H+n4k29eKDdLv+5RP++3zRK/54X40Ewk
	 3uxUag30za0B9veThrc+hKdQroPyqICoYztZP1MD87Ag01nC2AxEm6QzdRgRiO32dmLbs
	 x4XWIfXeoA1GUaVMctaCzFmGO9LyoUDvMSaJrxsR31NgW9CyjS5HQ7+c3crxGfUinDIOo
	 zCzmG8IJZakA7ENeYhdMCpCHgVDhJAuS6JWNO99LXF75MTA48Ii2fXmjSa/D5HQ46Y1xB
	 WHH9BLlR2MYqGpkLQ2Js5HKiljhSQJv+VW5VcEbOvqaL1asLeSr1ZNU0gTxJChnC0EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=icRWUV8aSnc2A7VEtdeLEnEPFpXWM1+MkJLvhfDwM4c=;
	b=ofTN/cOTOLKR7hgarvlnyZQiulGe5oENTCbeT4gGtIfc1Wx4PT7CJmwdDE2y+6Y099Az
	 OP5By3zpfqyxkYAd8+GtnmVI4qnwUBeXvrNkygGEL7ruLkEDvGcdjiuNwDbzFbXrys92z
	 ytc7FQxR5ek+cNpZnspDlaNatdkvkZWLKpZXaxS0uFnC21omT2QL6blpeeb/WmG1Qx1WE
	 k4QofA+q9Ub6HQPl1oyojrBXK77GnbxExCs5bBlHUJedNV0d/lX90wB+hQfiOqAsh7KK4
	 9X5ST9/JfvswPKnmXU4SuGIu3Wt1VZPp4Zx2qMo/pyDNfERG6dZJ1WdIjHfo97T4PQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdGL9wXk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D45606A323;
	Wed, 25 Nov 2026 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdGL9wXk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0B41F0157C;
	Wed, 25 Nov 2026 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618166;
	bh=icRWUV8aSnc2A7VEtdeLEnEPFpXWM1+MkJLvhfDwM4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdGL9wXknTxfJY/VQxGHGaXs128BuBjTM7gFBhdXBHj3sL+4qYt3iHkXmmiipQ0zo
	 SC6SvLDmKCSlGfIuAyFp6/WPqLQAH05MwrUszgT05QljHmQsJzAYSkQUyw5gKv3ukn
	 PXKm4qTp/09/Yr/gDChZggNF8i18iXhgAvyGyCvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0194/1005] Bluetooth: use assign_bit() where applicable
Date: Wed, 25 Nov 2026 15:25:32 +0100
Message-ID: <20261125143826.285666130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c4154fc34772134b0dbd14ab0134ba10b90c52cc ]

Convert open-coded if/else with set_bit/clear_bit the assign_bit API.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5d005ded2cb1 ("Bluetooth: L2CAP: Hold incoming data until encryption key size is known")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c   | 31 +++++++------------------------
 net/bluetooth/iso.c         | 15 +++------------
 net/bluetooth/l2cap_sock.c  | 22 ++++++----------------
 net/bluetooth/rfcomm/core.c |  6 ++----
 net/bluetooth/rfcomm/sock.c |  5 +----
 net/bluetooth/sco.c         | 10 ++--------
 6 files changed, 21 insertions(+), 68 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index f5c2bc77397b9..1962dccabbef1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -404,10 +404,7 @@ static u8 hci_cc_write_auth_enable(struct hci_dev *hdev, void *data,
 	if (!rp->status) {
 		__u8 param = *((__u8 *) sent);
 
-		if (param == AUTH_ENABLED)
-			set_bit(HCI_AUTH, &hdev->flags);
-		else
-			clear_bit(HCI_AUTH, &hdev->flags);
+		assign_bit(HCI_AUTH, &hdev->flags, param == AUTH_ENABLED);
 	}
 
 	if (hci_dev_test_flag(hdev, HCI_MGMT))
@@ -436,10 +433,7 @@ static u8 hci_cc_write_encrypt_mode(struct hci_dev *hdev, void *data,
 
 	param = *((__u8 *) sent);
 
-	if (param)
-		set_bit(HCI_ENCRYPT, &hdev->flags);
-	else
-		clear_bit(HCI_ENCRYPT, &hdev->flags);
+	assign_bit(HCI_ENCRYPT, &hdev->flags, param);
 
 	return rp->status;
 }
@@ -466,15 +460,9 @@ static u8 hci_cc_write_scan_enable(struct hci_dev *hdev, void *data,
 		goto done;
 	}
 
-	if (param & SCAN_INQUIRY)
-		set_bit(HCI_ISCAN, &hdev->flags);
-	else
-		clear_bit(HCI_ISCAN, &hdev->flags);
+	assign_bit(HCI_ISCAN, &hdev->flags, param & SCAN_INQUIRY);
 
-	if (param & SCAN_PAGE)
-		set_bit(HCI_PSCAN, &hdev->flags);
-	else
-		clear_bit(HCI_PSCAN, &hdev->flags);
+	assign_bit(HCI_PSCAN, &hdev->flags, param & SCAN_PAGE);
 
 done:
 	hci_dev_unlock(hdev);
@@ -4661,10 +4649,8 @@ static void hci_mode_change_evt(struct hci_dev *hdev, void *data,
 
 		if (!test_and_clear_bit(HCI_CONN_MODE_CHANGE_PEND,
 					&conn->flags)) {
-			if (conn->mode == HCI_CM_ACTIVE)
-				set_bit(HCI_CONN_POWER_SAVE, &conn->flags);
-			else
-				clear_bit(HCI_CONN_POWER_SAVE, &conn->flags);
+			assign_bit(HCI_CONN_POWER_SAVE, &conn->flags,
+				   conn->mode == HCI_CM_ACTIVE);
 		}
 
 		if (test_and_clear_bit(HCI_CONN_SCO_SETUP_PEND, &conn->flags))
@@ -4864,10 +4850,7 @@ static void hci_link_key_notify_evt(struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	if (persistent)
-		clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags);
-	else
-		set_bit(HCI_CONN_FLUSH_KEY, &conn->flags);
+	assign_bit(HCI_CONN_FLUSH_KEY, &conn->flags, !persistent);
 
 unlock:
 	hci_dev_unlock(hdev);
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 8768d9c0cf512..c1fdd9846eeb0 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1977,10 +1977,7 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (opt)
-			set_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
-		else
-			clear_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
+		assign_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags, opt);
 		break;
 
 	case BT_PKT_STATUS:
@@ -1988,10 +1985,7 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (opt)
-			set_bit(BT_SK_PKT_STATUS, &bt_sk(sk)->flags);
-		else
-			clear_bit(BT_SK_PKT_STATUS, &bt_sk(sk)->flags);
+		assign_bit(BT_SK_PKT_STATUS, &bt_sk(sk)->flags, opt);
 		break;
 
 	case BT_PKT_SEQNUM:
@@ -1999,10 +1993,7 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (opt)
-			set_bit(BT_SK_PKT_SEQNUM, &bt_sk(sk)->flags);
-		else
-			clear_bit(BT_SK_PKT_SEQNUM, &bt_sk(sk)->flags);
+		assign_bit(BT_SK_PKT_SEQNUM, &bt_sk(sk)->flags, opt);
 		break;
 
 	case BT_ISO_QOS:
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 1796929f61b86..47b0f8886fd11 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -871,15 +871,11 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 		if (opt & L2CAP_LM_SECURE)
 			chan->sec_level = BT_SECURITY_HIGH;
 
-		if (opt & L2CAP_LM_MASTER)
-			set_bit(FLAG_ROLE_SWITCH, &chan->flags);
-		else
-			clear_bit(FLAG_ROLE_SWITCH, &chan->flags);
+		assign_bit(FLAG_ROLE_SWITCH, &chan->flags,
+			   opt & L2CAP_LM_MASTER);
 
-		if (opt & L2CAP_LM_RELIABLE)
-			set_bit(FLAG_FORCE_RELIABLE, &chan->flags);
-		else
-			clear_bit(FLAG_FORCE_RELIABLE, &chan->flags);
+		assign_bit(FLAG_FORCE_RELIABLE, &chan->flags,
+			   opt & L2CAP_LM_RELIABLE);
 		break;
 
 	default:
@@ -1046,10 +1042,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			}
 		}
 
-		if (opt)
-			set_bit(FLAG_FLUSHABLE, &chan->flags);
-		else
-			clear_bit(FLAG_FLUSHABLE, &chan->flags);
+		assign_bit(FLAG_FLUSHABLE, &chan->flags, opt);
 		break;
 
 	case BT_POWER:
@@ -1065,10 +1058,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (pwr.force_active)
-			set_bit(FLAG_FORCE_ACTIVE, &chan->flags);
-		else
-			clear_bit(FLAG_FORCE_ACTIVE, &chan->flags);
+		assign_bit(FLAG_FORCE_ACTIVE, &chan->flags, pwr.force_active);
 		break;
 
 	case BT_CHANNEL_POLICY:
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 54ec1136f87ea..8a4205347c4ac 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1740,10 +1740,8 @@ static int rfcomm_recv_msc(struct rfcomm_session *s, int cr, struct sk_buff *skb
 		return 0;
 
 	if (cr) {
-		if (msc->v24_sig & RFCOMM_V24_FC && !d->cfc)
-			set_bit(RFCOMM_TX_THROTTLED, &d->flags);
-		else
-			clear_bit(RFCOMM_TX_THROTTLED, &d->flags);
+		assign_bit(RFCOMM_TX_THROTTLED, &d->flags,
+			   msc->v24_sig & RFCOMM_V24_FC && !d->cfc);
 
 		rfcomm_dlc_lock(d);
 
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index b26918dc9e9e9..3fb8b54749482 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -724,10 +724,7 @@ static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (opt)
-			set_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
-		else
-			clear_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
+		assign_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags, opt);
 
 		break;
 
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index f4a20d7b5f9cb..8be48ca9f4c5b 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1037,10 +1037,7 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (opt)
-			set_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
-		else
-			clear_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
+		assign_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags, opt);
 		break;
 
 	case BT_VOICE:
@@ -1080,10 +1077,7 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (opt)
-			set_bit(BT_SK_PKT_STATUS, &bt_sk(sk)->flags);
-		else
-			clear_bit(BT_SK_PKT_STATUS, &bt_sk(sk)->flags);
+		assign_bit(BT_SK_PKT_STATUS, &bt_sk(sk)->flags, opt);
 		break;
 
 	case BT_CODEC:
-- 
2.53.0



