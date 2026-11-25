Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626146;
	b=iVmISbFULCbun6bWk1wKSM8p8Zp32IOHxgr7ehiSCInSdDW/sGDUWZlTrgZy1qwLJKNJ
	 dv7UftDbxsxX0irSsHEoIax4TglHrff3GJp8b4vccGzbp6SisYkUt4T5tkDtv+50lrPgX
	 ZdzkIOnKSVkdIeK4Niyl/1oD6PC2ZkN2fEhDdWtOfigPzE3USwIHXg4Ai6juOWIKxOL4S
	 dlKr9DrALxxOnlA9T7/5KQR0OGXo2V9kqKCn/63O765uzvWRtT+aiMPNv3BozjFNK3ot3
	 MMLC1Fosv81JreQwfggROUMGF5Bfg3IW8dFcLsOFwqL4u+rLBBkEa0bXdycd+SpbULA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJmk8YId4GpUwO4zv5me6z3RLEJtWWUPmpVYsiRxHiw=;
	b=Ruen7/vphss+BsA8cKctiOksMuArprZCpcGZe0T6C04nvyq4K+eizLxOVQMH2B1DMdlI
	 NF8JsCRG2LB5eg3TwVw0tqiHtu9warL4L2McJIbIUb3tHMq8fgl/gDoqzzZT9KamBy+bh
	 cg/QCkxGIY2tGgTdXeyqrRi8QuPOdbkao5WDxMmwaxtDap+85DYi39xgs8eZIJnx57FhM
	 BX+Nj3c20S4HCnt0vXx30EdiZm9SwCVT3O5hcqWAieMf3DPtA+h1TQ2O6f3+EljYzaZuc
	 25hchtFX8mI1IlsMSGR73rm0Mlt/p2gZfi0TBnWUxt4S8UYlo/VPjUvJp80UGXwtzhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDLSIXiv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6888606A31E;
	Wed, 25 Nov 2026 17:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDLSIXiv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7811F000C0;
	Wed, 25 Nov 2026 17:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626146;
	bh=PJmk8YId4GpUwO4zv5me6z3RLEJtWWUPmpVYsiRxHiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDLSIXivIMvn7IrcEggqP8i4UYB6A9eEgpi5Wykm5ubGjE0l2u3OZrLCTYRAujCdq
	 YpLhOaZnLXQG+BjkSfaPq1gQ3IoNvD8C9n2WDL08lXBgJdMus93nc6vgcJmT0VlBl3
	 0/Hi2ZDvqeJM23V+9WS05T1AacttRaTUY+Y1lZCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Uttkarsh Aggarwal <uttkarsh.aggarwal@oss.qualcomm.com>,
	Peter Chen <peter.chen@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogeurs@linuc.intel.com>
Subject: [PATCH 6.12 745/816] usb: typec: ucsi: Set ucsi->connector before enabling notifications
Date: Wed, 25 Nov 2026 15:38:13 +0100
Message-ID: <20261125143906.421361950@linuxfoundation.org>
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

From: Uttkarsh Aggarwal <uttkarsh.aggarwal@oss.qualcomm.com>

commit 5b4b83c2ffe8740f6f3e54ea4d4962a62c063ef1 upstream.

In ucsi_init(), ucsi->connector is assigned only after the
UCSI_SET_NOTIFICATION_ENABLE command completes. But once that command
is sent, the PPM is free to raise a connector change notification at
any time, which is handled through:

    ucsi_notify_common() -> ucsi_connector_change()

ucsi_connector_change() indexes into ucsi->connector to get the
connector and schedule its work item. If this notification arrives
before ucsi_init() reaches the "ucsi->connector = connector;" line,
ucsi->connector is still NULL and the driver crashes dereferencing it.

Fix this by setting ucsi->connector right after the connectors are
registered, before notifications are enabled, so it is always valid
by the time a connector change event can be delivered. Also clear
ucsi->connector in the err_unregister path so it isn't left pointing
at freed memory if a later step in ucsi_init() fails.

Fixes: 0482c34ec6f8 ("usb: ucsi: Fix ucsi->connector race")
Cc: stable <stable@kernel.org>
Signed-off-by: Uttkarsh Aggarwal <uttkarsh.aggarwal@oss.qualcomm.com>
Reviewed-by: Peter Chen <peter.chen@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogeurs@linuc.intel.com>
Link: https://patch.msgid.link/20260929092939.1806907-1-uttkarsh.aggarwal@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1868,6 +1868,14 @@ static int ucsi_init(struct ucsi *ucsi)
 			goto err_unregister;
 	}
 
+	/*
+	 * Set ucsi->connector before enabling notifications. A connector
+	 * change event can be handled as soon as the notifications are
+	 * enabled below, and ucsi_connector_change() indexes into
+	 * ucsi->connector, so it must not be NULL at that point.
+	 */
+	ucsi->connector = connector;
+
 	/* Enable all supported notifications */
 	ntfy = ucsi_get_supported_notifications(ucsi);
 	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
@@ -1875,7 +1883,6 @@ static int ucsi_init(struct ucsi *ucsi)
 	if (ret < 0)
 		goto err_unregister;
 
-	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
 
 	mutex_lock(&ucsi->ppm_lock);
@@ -1889,6 +1896,7 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
+	ucsi->connector = NULL;
 	for (con = connector; con->port; con++)
 		ucsi_unregister_port(con);
 	for (i = 0; i < ucsi->cap.num_connectors; i++)


