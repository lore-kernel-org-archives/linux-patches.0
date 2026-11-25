Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623588;
	b=Fotsj+xt47vRPS3C856Eaqel/B7Q7wm7PZL4Z32mqklyvK8NNciWIMjYrlZvI4QW7jCa
	 GiKZFIiAI57BeO4j723Z2CjzFbA9b1WHBGUFiAY7lfSnkgy91fZzF62hQGJOlbYjBLVMD
	 Ub7QoPSaq2wEHRZmkdxE/NsFKYMMSH9HwjLjcAfDIIFVwHF4qkixCNBtUYVQ6Wd1LiBgz
	 EhbMDXleoWzygIyF++oyEY+zrxCrunwWAcdfBWBzmW6ZwfOrL+NS7c7zA4R+/vxVsmOs/
	 hMRh8n8kmdSj8KNv34caOd+sTTox24jFEaReJlKecrAhkaMqcwZr/P1+CFYsZZyuG+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yGWdWg5F7UBEXLuK85ePRU3LvxOs1Li4aoT4k0jfTPw=;
	b=GCkSWxyYrwEsxwlQHgnDdFvyEftywN+wOaZoLWyBbFlX2tZQ3YLXzffjtqQQiRmBAxqs
	 rw+hevbcWjl71FKG1lQ+A/IdXnf0vDTxd8bxpgfPIQyrPiG8QZeYb2ibdCYfpj1aYL6lD
	 F/NKWrW9m92JBeieAfR8r238o58dfvGLSnIkJ7GEvWiqT/DO20AFLV7gWCcHbqKXWXoJR
	 S5gXtnSpZf1EojOryonQjpubtzTGpYJcSQmE6z4Q5CXqJCIoTzXYP0TiSC/0p68uha0dF
	 tblSfEceK/XhYAXNNxa4+PkWB/hCt+z3TVVCciKiShSiHCqxLe9sfnoKt9PHguEgMYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZU0tO7e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9C5606A31E;
	Wed, 25 Nov 2026 16:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZU0tO7e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1BD1F000C0;
	Wed, 25 Nov 2026 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623587;
	bh=yGWdWg5F7UBEXLuK85ePRU3LvxOs1Li4aoT4k0jfTPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZU0tO7eWuShtkHdTqgRFZgFus3bdIV2hOG4jCm1kbRQI7IyDQ7Cd/nPwua5UEILY
	 Nu7k+kobHCA6aQI1t17sfyYwLpu7ofxhb5fxlo2mhrtOb91yhu6duWx3IHbeiUyUHr
	 5bm8Krcg3Iag15ewBN2kx8utuVRTe42FqarP4rbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Uttkarsh Aggarwal <uttkarsh.aggarwal@oss.qualcomm.com>,
	Peter Chen <peter.chen@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogeurs@linuc.intel.com>
Subject: [PATCH 6.18 908/990] usb: typec: ucsi: Set ucsi->connector before enabling notifications
Date: Wed, 25 Nov 2026 15:37:55 +0100
Message-ID: <20261125143843.277735310@linuxfoundation.org>
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
@@ -2041,6 +2041,14 @@ static int ucsi_init(struct ucsi *ucsi)
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
@@ -2048,7 +2056,6 @@ static int ucsi_init(struct ucsi *ucsi)
 	if (ret < 0)
 		goto err_unregister;
 
-	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
 
 	mutex_lock(&ucsi->ppm_lock);
@@ -2062,6 +2069,7 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
+	ucsi->connector = NULL;
 	for (con = connector; con->port; con++)
 		ucsi_unregister_port(con);
 	for (i = 0; i < ucsi->cap.num_connectors; i++)


