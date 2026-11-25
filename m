Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620463;
	b=0WFcq+eBmpYNCiPFdYO6+CFSSscFJinhQuRuReRQAg/zQ5ixMegJJYllB+zUk/fS6x6Q
	 QVqRN7+KEEiUCWjJ15lr9y32qGKcJN3ljCdsKIKwwOuj2NqHrsN29PtWE3Ktc/yx1ClOm
	 +nWETzIW+BB2wFzv/h+0+odSnOr1Nk6XJ76EX5JTSXPqojoUHaghMzzeCp+rlDja6O583
	 fJgjYpowsfst51YrXW+PXwSPDCFdHjda7QWj3qEmwWTpCoySTmh/0E7+dCxw8hEOxQbDU
	 nt5wuadEGa2kMWx5So2Tdi8454CtQ/35xpXemO6fpwHkUMo+P8antQY8WPcf7+17M6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6pO2AKoyIj9FDdIQOnVzafFFlFk/f/411+yZda80Rfg=;
	b=i6/hJuLAmYgWzXr3UVNRhQNn1JKGroxwVz49hvFNQkfSTGAENUnP1TYulSZEr9nZYa7Z
	 TbFQm6VAk1b9f4fV+mwzirIDYzZ/n1U2NxP1znVKtjaab7LNUgkGafFP0fwsK3T9mryl0
	 /WB3lEAi1j3aAsAw7bD8QiEQrtjuZVpax240Jr3O7UoKXWdMTti0CvbAtlYhFeKWe5mSy
	 vWzHHtGErP9AtZCUFmcr0IQgmEDdMnGSbN6wu5z2fqX/Ik2HUl6cMdyScWLJBjJR0AFF9
	 THRJgHbEwbcTlF6T3D4gZ+YdXDgytb4oQ5gPKsRHu/4xu1LhzbAIMTOsZ/9yayuhhrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThXtxwun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABB2606A327;
	Wed, 25 Nov 2026 15:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThXtxwun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798A91F000C4;
	Wed, 25 Nov 2026 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620463;
	bh=6pO2AKoyIj9FDdIQOnVzafFFlFk/f/411+yZda80Rfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThXtxwunioxDDziz1divlKeoPed85laxCGpQRCjZGhJeuA46yWOxa+zC81Ghp3VSq
	 oKq6cgBQgYJioG4G1EmAMHURTrppIRF0xeq3I/efUp6Ql0I0VBwzQS40wjwIW37LzQ
	 DDOIYeXio/yYbN4jEXYYmcuhK/m8Rq9K+bifWdWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Uttkarsh Aggarwal <uttkarsh.aggarwal@oss.qualcomm.com>,
	Peter Chen <peter.chen@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogeurs@linuc.intel.com>
Subject: [PATCH 7.3 0924/1005] usb: typec: ucsi: Set ucsi->connector before enabling notifications
Date: Wed, 25 Nov 2026 15:37:42 +0100
Message-ID: <20261125143843.332054918@linuxfoundation.org>
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
@@ -2134,6 +2134,14 @@ static int ucsi_init(struct ucsi *ucsi)
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
@@ -2141,7 +2149,6 @@ static int ucsi_init(struct ucsi *ucsi)
 	if (ret < 0)
 		goto err_unregister;
 
-	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
 
 	mutex_lock(&ucsi->ppm_lock);
@@ -2155,6 +2162,7 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
+	ucsi->connector = NULL;
 	for (con = connector; con->port; con++)
 		ucsi_unregister_port(con);
 	for (i = 0; i < ucsi->cap.num_connectors; i++)


