Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618145;
	b=D6Te4Mn3qhitUP5MeJPjCkBKveQhOWZtjrhytSkAnwgQGT2sMsrpo6JRppZ8feKDVSVp
	 LUb9ujkEF1V0cHPl83S7n4s6RRyGhIO8lLDoSGfv/n+iw9qk9FNrZgoL56moc9e6D+CQe
	 041odirvtI771ZbHBBBFik0BwxeMLKgzuveYywHPcWGzPJ7YUFZxo/m3WJtlgObXTzvE4
	 4GXHO3B4/Yg3Lax5OoREa3cANRDAm6wsTRdy2XhrJqrcXEDQ9F2nHp6zo5mHQewn1dUVR
	 WbLXGXOvkHuiMrhS01PF2idmAG1Y3WcqAXNIJE64C2FmjFBVJzd+NVWNL8GjzOBRWzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u7zE2QrQBLJSEMRwDyqEP9ZQcvViWdGid2N9AoUYHF8=;
	b=oKggNGKm0r5zz/3a4FIVIgTVO73yoIFqJkUnQl7KrXHGLz0gIhrmxPsG/csLhatnt5/y
	 VNbDATptFqReUOYYy7A4iEUbxFVyHdZHW5uEevvUcwQ9E68WKulZYWejp5ukZkRn47p65
	 FvrV2gBf+t3nBLPVOfxZ9PVuYir2P4htPnjL779B8Wn30W7lGvZ00aKfDJbLz7T4JKsEx
	 IJ8peeGqnoMdT3qgHELMhYn5sp6/mfjleK5OotRybY52SxDi3Z7OFvf1NL8RD6++oNIcd
	 6Tlk7MNl0EV5reeG9YUbrses0sytNf9sbSp0w46Dn+eqz663caRNMxfyD9X7xM0/ttA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJxBgvRc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81D606A31E;
	Wed, 25 Nov 2026 14:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJxBgvRc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE71F000CA;
	Wed, 25 Nov 2026 14:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618144;
	bh=u7zE2QrQBLJSEMRwDyqEP9ZQcvViWdGid2N9AoUYHF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJxBgvRcV6E2GFXmiQFP6b6ZQCBsPcjwzKYP6EmJBMZknal6GtWMk4FckiQumfOBA
	 +LD4FwtdQfnocmspo7Hw7ThJOax5+ssOejo5xF6pRPzJHIgez/tvHmSk7Y+rJch/Iq
	 b4YKs/hJmZiInOSE2YxZBJGXaqxVWyI+iiHVAgcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0187/1005] Bluetooth: hci_sync: Fix invalid Supervision_Timeout in LE Set Default Rate
Date: Wed, 25 Nov 2026 15:25:25 +0100
Message-ID: <20261125143826.122158673@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit fb1baa000d7a0b597ab9eb29b179b03e70e5f6ee ]

The LE Set Default Rate Parameters command is rejected with Invalid HCI
Command Parameters (0x12) because the Supervision_Timeout of 120 ms is
exactly the minimum recommended by HOGP v1.2:

  Greater than or equal to (1 + Peripheral Latency) x Subrate max x
  Connection Interval max x 2

But the Core spec treats the equality as invalid:

BLUETOOTH CORE SPECIFICATION Version 6.3 | Vol 4, Part E
7.8.158. LE Set Default Rate Parameters command

  If Connection_Interval_Max x Subrate_Max x (Max_Latency + 1) is
  greater than or equal to Supervision_Timeout x 40, the Controller
  shall return the error code Invalid HCI Command Parameters (0x12).

With the current values 0x78 x 4 x 1 = 480 >= 0x0c x 40 = 480.

Fix this by using 2 s as the default Supervision_Timeout, which is 10x
lower than the 20 s used for non-SCI connections while still well above
the minimum required, and make sure it remains above the minimum in
case interval_max is raised to match the controller's minimum supported
connection interval.

Fixes: 2f8784cfe8a9 ("Bluetooth: Add support for Shorter Connection Interval (SCI) feature")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4e5c47872c30b..b86f67ea5fddc 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4834,6 +4834,9 @@ static int hci_le_set_def_rate_sync(struct hci_dev *hdev)
 	struct hci_cp_le_set_def_rate cp;
 	u16 interval_min = 0x000a;	/* 1.25 ms */
 	u16 interval_max = 0x0078;	/* 15 ms */
+	u16 subrate_max = 0x0004;
+	u16 max_latency = 0x0000;
+	u32 supv_timeout;
 
 	if (!le_sci_capable(hdev))
 		return 0;
@@ -4858,10 +4861,31 @@ static int hci_le_set_def_rate_sync(struct hci_dev *hdev)
 	cp.interval_min = cpu_to_le16(interval_min);
 	cp.interval_max = cpu_to_le16(interval_max);
 	cp.subrate_min = cpu_to_le16(0x0001);
-	cp.subrate_max = cpu_to_le16(0x0004);
-	cp.max_latency = cpu_to_le16(0x0000);
+	cp.subrate_max = cpu_to_le16(subrate_max);
+	cp.max_latency = cpu_to_le16(max_latency);
 	cp.cont_num = cpu_to_le16(0x0001);
-	cp.supv_timeout = cpu_to_le16(0x000c);	/* 120 ms */
+
+	/* HOGP v1.2 recommends a Supervision_Timeout greater than or equal to
+	 * (1 + Max_Latency) x Subrate_Max x Connection_Interval_Max x 2, but
+	 * the Core spec treats the equality as invalid:
+	 *
+	 * BLUETOOTH CORE SPECIFICATION Version 6.3 | Vol 4, Part E
+	 * 7.8.158. LE Set Default Rate Parameters command
+	 *
+	 * If Connection_Interval_Max x Subrate_Max x (Max_Latency + 1) is
+	 * greater than or equal to Supervision_Timeout x 40, the Controller
+	 * shall return the error code Invalid HCI Command Parameters (0x12).
+	 *
+	 * So default to 2 s, 10x lower than the 20 s used for non-SCI
+	 * connections while still well above the minimum required, but make
+	 * sure it stays strictly above the minimum in case interval_max has
+	 * been raised.
+	 */
+	supv_timeout = (u32)interval_max * subrate_max * (max_latency + 1);
+	supv_timeout = supv_timeout / 40 + 1;
+	supv_timeout = clamp_t(u32, max_t(u32, supv_timeout, 0x00c8),
+			       0x000a, 0x0c80);
+	cp.supv_timeout = cpu_to_le16(supv_timeout);
 
 	/* The connection event length recommended in requests by a Peripheral
 	 * uses units of 125 us with a valid range of 0x0001 to 0x7CFF
-- 
2.53.0



