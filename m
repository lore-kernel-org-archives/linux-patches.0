Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621277;
	b=u8oMQMrh1AWhcT/M3TwXG+pU4yvb8T/1J45Ds8mhPpTbtLSGvu8OWUl+fwfzNR31CZlE
	 0/kfWs6h7Xdo8IGZa9gjcOKW/oU2n95swEFRuikL25/vXzJQokxeZRrqafWliQ2a+H/eX
	 jQ1iRg5YcUdgO/XrvxLfnJiK+//TMJfwS5fnKMKQDFK3CG/9UHlwZ1dRTnbd4UnB6Dlyy
	 wSZ1QY0PlJcMeEwpomDkSKripvDoq5h0/aP4esk+ykHRtqUPKNF5h4OQ7uxzyd+TzQIB4
	 1flNX7DuJrIIx9qVd930GdXUuMeM6D4GrJpvDZ0UeZGgC2OmloqIXqw9Sw7B+SAlmCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OVILb91ABYUZ6Tzb8Ono3qTyNSL2usE6VAAnYxdmW7Y=;
	b=iAQgOX4SG/ASMKwAt1xZwsyF6QDAl5o95ZYDZ+TshE5haYgtxhlRnOgh86KVf8LLx+hk
	 6nyVzbzTTd3Uy3rYPejQjOq2St5urCbheyzqx1BTDsnSCHLsBYk2n+w8GvQBpcNw/JRlr
	 PQ1Y0b3h0GNWrxKCJzeXc/j76e6+BeQZdtiOq0kSlGJ2cqbt9AFnr2lJM/MLK7aXLlz69
	 IHLZ1KbDKLlq2i4q7Oik5f81a+a8Fl6RG9suLlwMZHACL1zb3lNmTDRLnZMvV2IihUo4T
	 qwfr1EvfNw/2COZIT3W+ASvSBb/LJztE3ni+E25vJlN1CCs74Xu6qPtLIPNGhG14KWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgDL6hjz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FD5606BF7C;
	Wed, 25 Nov 2026 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgDL6hjz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8821F00A3E;
	Wed, 25 Nov 2026 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621276;
	bh=OVILb91ABYUZ6Tzb8Ono3qTyNSL2usE6VAAnYxdmW7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgDL6hjzDh0TdBVGIHYoa2R0HEJM9L7dTXhhyP4amh9msze/2EGsiA/Yk0hRXSJc9
	 EwwHfNCIQO3OzTo+M6/hDdfIs3i+MFUWEv530X5kORC4KYbmJbLCwEdgsgYAHmETgu
	 idEzYF2eQj7LOLfoJYDXeafLfK24gXCa9fCqautA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/990] Bluetooth: hci_event: Clear explicit connect state on LE connection
Date: Wed, 25 Nov 2026 15:25:44 +0100
Message-ID: <20261125143826.237377458@linuxfoundation.org>
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

From: Kevin Dewald <kevin@simpleble.org>

[ Upstream commit f5cd268af1c6f87fb3847e98274e22b8c6324aa4 ]

Since commit 6cd29ec6ae5e ("Bluetooth: hci_sync: Wait for proper events
when connecting LE"), create_le_conn_complete() only runs once the LE
Connection Complete event has been handled, and le_conn_complete_evt()
has already removed the connection parameters from pend_le_conns by
then. hci_connect_le_scan_cleanup() looks the parameters up in
pend_le_conns, so after a successful connection it no longer clears
explicit_connect, nor deletes the parameters that were only created for
the explicit connect.

The parameters of every device connected through an explicit connect,
such as an L2CAP or ATT connect or MGMT Pair Device, are thus left with
explicit_connect set. MGMT Remove Device for all devices then keeps
them as HCI_AUTO_CONN_EXPLICIT instead of freeing them, and if the
device was set to auto-connect and is disconnected, they also stay on
pend_le_conns: the kernel keeps scanning for the device and connects to
it as soon as it advertises, although no one asked for it any more.

Do the cleanup in le_conn_complete_evt() instead, where the explicit
connect request is fulfilled: clear explicit_connect, delete the
parameters if they only existed for it, and put report parameters back
on pend_le_reports. Auto-connect parameters are added back to
pend_le_conns on disconnection, as before. Update the comment in
hci_explicit_conn_params_set() that names hci_connect_le_scan_cleanup()
as the only place deleting them.

Fixes: 6cd29ec6ae5e ("Bluetooth: hci_sync: Wait for proper events when connecting LE")
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kevin Dewald <kevin@simpleble.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c  |  5 +++--
 net/bluetooth/hci_event.c | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 32cabe83351ac..f7645dc0ad2ae 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1488,8 +1488,9 @@ static int hci_explicit_conn_params_set(struct hci_dev *hdev,
 		if (!params)
 			return -ENOMEM;
 
-		/* If we created new params, mark them to be deleted in
-		 * hci_connect_le_scan_cleanup. It's different case than
+		/* If we created new params, mark them to be deleted once the
+		 * explicit connect is done, see le_conn_complete_evt() and
+		 * hci_connect_le_scan_cleanup(). It's different case than
 		 * existing disabled params, those will stay after cleanup.
 		 */
 		params->auto_connect = HCI_AUTO_CONN_EXPLICIT;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 572f195f09c13..4be09dd9d9597 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5870,6 +5870,28 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 			hci_conn_put(params->conn);
 			params->conn = NULL;
 		}
+
+		/* An explicit connect request is complete once connected, so
+		 * clean it up here: hci_connect_le_scan_cleanup() no longer
+		 * finds the params since they have just been removed from
+		 * pend_le_conns.
+		 */
+		if (params->explicit_connect) {
+			params->explicit_connect = false;
+
+			switch (params->auto_connect) {
+			case HCI_AUTO_CONN_EXPLICIT:
+				hci_conn_params_del(hdev, &conn->dst,
+						    conn->dst_type);
+				break;
+			case HCI_AUTO_CONN_REPORT:
+				hci_pend_le_list_add(params,
+						     &hdev->pend_le_reports);
+				break;
+			default:
+				break;
+			}
+		}
 	}
 
 unlock:
-- 
2.53.0



