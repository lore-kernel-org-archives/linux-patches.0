Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020311;
	b=E71a90Achh3mKhf3ns9LIyAQXCRB3fvSi5r6g2LkkURzonbjKqb0eJxY4q/wawfOXkkU
	 ab6dXKjplZYRXLJuqROarpYqKZi0dX0dAsTX+/wS8Hia9ytTq0ykNFVNdoy6TPCSNeJIa
	 7ir17uFFAHmsFbxMKAG3WQ2kjDrADJ5NUU9rkM1p9jP1ey2a5WLEqNcvbH++YVDF91x+Z
	 SPqB9qH32qay6THd+xYAl8b2u/4X0Pa9KTXbUhTdZgG++1Ruw8oWw3FFQcy19e2E2IPwB
	 mMgApSoAXOwmQQq723moLCw4sVWhMq8JLi8wyI0ICa+ZPKO0OXAuNZtuBOFtb9s7LJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZUau8gw4seTtMb2Td90fX3q0QE+Wa2eZfidzHq7wW4s=;
	b=cwYlUIxpqhGfKEFia0vL7xc7q6wF2W/aF9PAYoFqkOBR7owusZmQeyFZ22hcRRjaqgUm
	 Y/A2mGEo+tVWNWAfbStbWnJf72IFmrRrLg69U0xpu/kQ1ho4/bILfKwg+P+N8EKHfHmwb
	 oB0Y3xgHr9M3QCD7ZsaEWVjbM2akjBHl1Ba/ZQPB0RST3AQxQfmWRlnAKRBUoAc3pw7fi
	 bpTgP0WcHM78yf5zEB0qJ/Vqjvfl1P74ZHWf2JVItgnItF6OhciX7tu2YwplaNViKtVfW
	 f2SvFl+WVa0FYFm/RwJbvBtjKHEvwPgQ5DD5mAFKF9MqosGxh5oJZIQxFVK4tCDLV+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pe8RkgR9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C1D606A32C;
	Wed, 18 Nov 2026 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pe8RkgR9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C611F000C4;
	Wed, 18 Nov 2026 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020311;
	bh=ZUau8gw4seTtMb2Td90fX3q0QE+Wa2eZfidzHq7wW4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pe8RkgR9UrbpgyA4FnExTlZcUffMRTQZ+fWeRcYjqu0Pg9LuJG3xWXrZgXr6mBHCM
	 eoF39p5NMmRQPAMNjJ9IZkjqyPKF8z+BRQaUPeE0zn8jjnpASPkvNSIaYgd7JEIib9
	 Qc0xjuYoH5xqeJlquATUOpOghLl7h1ev20I2op0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1906/2651] Bluetooth: hci_event: Fix LE link drop on remote features command status
Date: Wed, 18 Nov 2026 15:52:26 +0100
Message-ID: <20261118150355.424855830@linuxfoundation.org>
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

From: Kevin Dewald <kevin@simpleble.org>

[ Upstream commit 91638f53ff2b8234195ff27ec913e068269a28e9 ]

When the local controller supports peripheral-initiated features
exchange, the LE Read Remote Features procedure also runs for incoming
connections, and it fails with Unsupported Remote Feature (0x1a) if the
central does not support that feature. hci_le_remote_feat_complete_evt()
and hci_le_read_all_remote_features_evt() handle this and let the
connection transition into connected state.

A controller can also return that error in the Command Status event
instead. An Intel controller does so for a central that does not
support peripheral-initiated features exchange, presumably because it
already has the features of the central. hci_cs_le_read_remote_features()
and hci_cs_le_read_all_remote_features() then confirm the connection as
failed while it is still in BT_CONFIG, and the hci_conn_drop() in
le_read_features_complete() disconnects it right away:

  > HCI Event: LE Meta Event (0x3e) plen 31
      LE Enhanced Connection Complete (0x0a)
        Status: Success (0x00)
        Role: Peripheral (0x01)
  < HCI Command: LE Read Remote Used Features (0x08|0x0016) plen 2
  > HCI Event: Command Status (0x0f) plen 4
      LE Read Remote Used Features (0x08|0x0016) ncmd 1
        Status: Unsupported Remote Feature / Unsupported LMP Feature (0x1a)
  < HCI Command: Disconnect (0x01|0x0006) plen 3
        Reason: Remote User Terminated Connection (0x13)

Data the central sends afterwards is reported as:

  Bluetooth: hci0: ACL packet for unknown connection handle 3585

Handle Unsupported Remote Feature in the command status the same way as
in the complete events.

Fixes: 0fe29fd1cd77 ("Bluetooth: Read LE remote features during connection establishment")
Fixes: a106e50be74b ("Bluetooth: HCI: Add support for LL Extended Feature Set")
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kevin Dewald <kevin@simpleble.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index c9cf7f27d21b9..3ea6c06adaaf0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2989,8 +2989,25 @@ static void hci_cs_le_read_remote_features(struct hci_dev *hdev, u8 status)
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn && conn->state == BT_CONFIG)
+	if (conn && conn->state == BT_CONFIG) {
+		/* If the local controller supports peripheral-initiated
+		 * features exchange, but the remote controller does not,
+		 * then the controller may already return the error code
+		 * 0x1a for unsupported remote feature in the command
+		 * status.
+		 *
+		 * Handle it as hci_le_remote_feat_complete_evt() does and
+		 * allow the connection to transition into connected state.
+		 */
+		if (!conn->out &&
+		    status == HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE &&
+		    (hdev->le_features[0] & HCI_LE_PERIPHERAL_FEATURES)) {
+			conn->state = BT_CONNECTED;
+			status = 0x00;
+		}
+
 		hci_connect_cfm(conn, status);
+	}
 
 	hci_dev_unlock(hdev);
 }
@@ -4039,8 +4056,17 @@ static void hci_cs_le_read_all_remote_features(struct hci_dev *hdev, u8 status)
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn && conn->state == BT_CONFIG)
+	if (conn && conn->state == BT_CONFIG) {
+		/* See hci_cs_le_read_remote_features() */
+		if (!conn->out &&
+		    status == HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE &&
+		    (hdev->le_features[0] & HCI_LE_PERIPHERAL_FEATURES)) {
+			conn->state = BT_CONNECTED;
+			status = 0x00;
+		}
+
 		hci_connect_cfm(conn, status);
+	}
 
 	hci_dev_unlock(hdev);
 }
-- 
2.53.0



