Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031908;
	b=I8ur4lLE5149A2YwWf+99IYSNQ/nkA2Jj9i/bcxzcqZsqS1ooZtO/cZ/XAU/A5p+xiPe
	 OnJp4CH8u+5mW/Wo2h6nEI8T8JrsOiYiD5nd26dah530KY5KrrXph3zxkZ+k2/j20K5aP
	 kio1gQaKcnJBVZnRJOCBczs+mAdZTRpngqY1LGYHP9blSo8ttynIoxrpoXbVW66JMgNr+
	 nmnF9GcKQaJoxWGKQE6lxgYKqZO1DzAi4ATRHQkPL476eVdx6Y/QZCWOpjPXoYrZpxznb
	 BPD4FOnwTgjSJB7e/82F/QHTJi+F7Aj7sRA00DztTWsFuFD059Tb4+980Dm7i6RltCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y8urAgq+xACoJf5ZSkOdPSEzEqfCiMBdPPUuHXUhulg=;
	b=sYgpvYQVTZsH1QGBdBY6nhkM2WbG7Fcef07Bzs8aOvuRCw4lR32LNVlSg+2D9JDPO+Uf
	 89ZgT1+Djb1BUtRTKZa1fZSZErzu+Wxuc+DB9Q4ZrUjBZddI2Z6dN1QEGnD9vqqeE11s/
	 anAm5yD7qP3NkTbYCTjDaNVjtkDPZeQgO8xR7K/LZ9E2OzO1cjvrn2aqThx/Vhq2MmiI7
	 GH+0timCWrPPM28cW5tup1xHTwi2RmUlQlghuNuxdSQmZsZMeYtBfPPWEJGr0QvFHlsSQ
	 Qnwt3b/LDUOiFKSwRExXeMr5GG3JlEMjLdOqMLdkkIJnWyx0FsNzrWiboQQoeUCSqsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vm9vQoJ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C31606A32A;
	Wed, 18 Nov 2026 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vm9vQoJ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15011F000C4;
	Wed, 18 Nov 2026 19:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031908;
	bh=y8urAgq+xACoJf5ZSkOdPSEzEqfCiMBdPPUuHXUhulg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vm9vQoJ82wZaC9TytgQy5P21xfwlcjd3Tr1t5diUGd1+KKs8uQHjJmr7WFBoqBYtI
	 JhMjygpa7iSpBXgeGDcaMyU2zbm2GFUZT361MwuNvn22+5o7VS2w5MbBQd9lB7j92F
	 QS003BamfGysR0BZ6ktaB8sRKDTVlIPtILkimoVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1223/1756] Bluetooth: btusb: Make btusb_recv_{event,acl}() take struct hci_dev *
Date: Wed, 18 Nov 2026 15:55:50 +0100
Message-ID: <20261118150058.518621025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit d6d15018c8e1527841e39a6a80c60997e594ca70 ]

Both helpers currently take struct btusb_data *, which is private to
btusb.c, as parameter type as below:

  int btusb_recv_event(struct btusb_data *data, struct sk_buff *skb)
  int btusb_recv_acl(struct btusb_data *data, struct sk_buff *skb)

To allow vendor USB-transport-specific source files to share them as
well, change the type to struct hci_dev *.

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: fa96916cfd05 ("Bluetooth: btusb: Preserve event and ACL packet ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 84b1ee064f64f..50cbf9d821bac 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1207,14 +1207,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
 	spin_unlock_irqrestore(&data->rxlock, flags);
 }
 
-static int btusb_recv_event(struct btusb_data *data, struct sk_buff *skb)
+static int btusb_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
+	struct btusb_data *data = hci_get_drvdata(hdev);
+
 	if (data->intr_interval) {
 		/* Trigger dequeue immediatelly if an event is received */
 		schedule_delayed_work(&data->rx_work, 0);
 	}
 
-	return data->recv_event(data->hdev, skb);
+	return data->recv_event(hdev, skb);
 }
 
 static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
@@ -1274,7 +1276,7 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
 			}
 
 			/* Complete frame */
-			btusb_recv_event(data, skb);
+			btusb_recv_event(data->hdev, skb);
 			skb = NULL;
 		}
 	}
@@ -1285,13 +1287,15 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
 	return err;
 }
 
-static int btusb_recv_acl(struct btusb_data *data, struct sk_buff *skb)
+static int btusb_recv_acl(struct hci_dev *hdev, struct sk_buff *skb)
 {
+	struct btusb_data *data = hci_get_drvdata(hdev);
+
 	/* Only queue ACL packet if intr_interval is set as it means
 	 * force_poll_sync has been enabled.
 	 */
 	if (!data->intr_interval)
-		return data->recv_acl(data->hdev, skb);
+		return data->recv_acl(hdev, skb);
 
 	skb_queue_tail(&data->acl_q, skb);
 	schedule_delayed_work(&data->rx_work, data->intr_interval);
@@ -1346,7 +1350,7 @@ static int btusb_recv_bulk(struct btusb_data *data, void *buffer, int count)
 
 		if (!hci_skb_expect(skb)) {
 			/* Complete frame */
-			btusb_recv_acl(data, skb);
+			btusb_recv_acl(data->hdev, skb);
 			skb = NULL;
 		}
 	}
-- 
2.53.0



