Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624313;
	b=n5c9nDIjUY6Pfn8EGa6tI5i6kwq4Y32ffGVjHIlJtNRbzaGvM7pt2D4ET87xkPxqPtbD
	 10v22p+AXlcY+sj/UWA6YFJjg0goZQHzQ5LNGsZ3wjPYs8LUSJv2J9Em90rD174dD8lAX
	 xDG+89W5trv0uZNze7+4a4CfB3ug68MhxjbmBQ7iJunRUdFf4yVaKWLiDWefho4FzZjwa
	 M/KqFpvjqJgAfkFHlfAHEh+DsQxpt3x+vY/eUhVqRK/2Synd9TVSz+xO6sjBGeF1CWPaD
	 FeweQXwu6tEyodvRTkcnfmditO2+wtW2Gsr82n5kpWSnU3mYhIJAeIZQA9/HELcMgfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L+jWORJ0IrHC5jyqFQX0Wkck3f+ulHEARP9/OJae5oA=;
	b=4FCbL36WVToxvo72mNqV5BIRfarNy6saJOHB8kXPvsYJ5GAjob9DFJP3MKAfcK3HqSAN
	 wZlkmN7XncPyNk4sn+AD10YIneAO/pE+THKH7VIJcVvNHgFlwfBZ0EXk1zG70bMzPp6Yu
	 BjVCuMPAVbK9GxorXzjTlqB2RiMLrkhJWwfnMyLlvR4FY08hl+p8uiaGqpps/QssINl20
	 povF7fXS7m/C6bPiI9MGMixeWHoW4Sysk/rM6Gzm2/9NN3we0T2oMl21ShubVN7TKP51V
	 Wv5/eY4r3f2YIWv6SLJllRxriuaQqP9I8L7ulRCaqNg17z/+NGYJ4Jx7/k7HCSCs4Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFhPYGd0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE33E606A331;
	Wed, 25 Nov 2026 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFhPYGd0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D97E1F000C0;
	Wed, 25 Nov 2026 16:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624313;
	bh=L+jWORJ0IrHC5jyqFQX0Wkck3f+ulHEARP9/OJae5oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFhPYGd0hzodTXUuPXs/cr25w7hQlDreCeYRD3sAa8Mfv0U4lPQ5DbUXC7a16HCdr
	 fO6AlXQcMWTualUr+mJ2PFVAK1kZKyvDfNJRqr0AX3R09qPpBm/HE2fLMX+uXD27bo
	 PpPFkvW8km+iRUmSU+++/meWX97CaCls0AN06Ja4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/816] Bluetooth: hci_event: Clear explicit connect state on LE connection
Date: Wed, 25 Nov 2026 15:28:21 +0100
Message-ID: <20261125143852.737556030@linuxfoundation.org>
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
index 602b5be7eccc8..c1d1614581a29 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1450,8 +1450,9 @@ static int hci_explicit_conn_params_set(struct hci_dev *hdev,
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
index bd30c00269698..533a534d78867 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5862,6 +5862,28 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
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



