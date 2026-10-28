Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207448;
	b=d6VwzaBGtXIrlS5xDTSOgxCq+Kc7AT7VKHPl1mTKFNCg/MDpeiHrN9oHhsUBNLDjxsX8
	 qtph9ofBW6Q8Bppzmw3m3ZSSyay5yhmXHgF5lZ0GjrC2j4hROKaRZi8Qe/Xpp/Ya42XcX
	 nbOkrejIWxJfRTUCA7D2VZwDGwh/UCME+THDFEo41joR807wYD6hRZgBj6BC1Mejbp1O3
	 jhAKceWPL6YVpoPT6kfUiE+5UDnY1siT788aJPifz9ns19ALkMMFD3J6DTD37mtq2FyWK
	 z4DW0LwLoIWIn+YUvMAJOt0RJlhQy1KKo1z67HpUexRN6D9ztBzRcE/K0xu8tBOgCgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JbwEzX+E5OGJq5OgyjY51M31uSYlx8hJdCk/RDuOc5g=;
	b=y4RihH/eAWKI4N4HbH5gHqYHQ81sZ7MXakODHAn7xa9CWtQh63ILfWL+zf1bI9vNJJOS
	 rBvDaA90w8tysD/qF2hxoZ76UzN/nZzKwzqpvLpP00yaQIer+DKZ2WpR8Py1AsOHIH984
	 +Y3IKXd9DXucCIr14SCRol/hZPWGuoLpTM/SINdMC6di9fs8ZAHq3Hi7O+GOSQNoc36Mq
	 DR+2VTsJ7hYmRqY1Eo6lXm2FHzimnpTigtw6hkZiICekKhB9q6nBKgQMgifdCEj7GVmDo
	 2I7sL5sDsYqmIuX1R3NrXusA1t/sZQnlieZyUeORl89bovXlaUYDyu+1lWlQiZMnHig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUfNnUYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30325606A31A;
	Wed, 28 Oct 2026 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUfNnUYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A611F01825;
	Wed, 28 Oct 2026 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207448;
	bh=JbwEzX+E5OGJq5OgyjY51M31uSYlx8hJdCk/RDuOc5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUfNnUYxk7p9QjS6l6945si24cxCOLnq9T9P3M9yWHXICyRQ1UQquoMFAK0jQlD57
	 KVNoz/jCh3clpixcrsKfsSCz7eNCZtqvFSiSOdkkOpXThFACVh0YJ/jalLbVl6S8PE
	 xcrJZZVReGz484SmXzwxm/YHRy0KSC7ePOQYILsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/247] Drivers: hv: Dont reset VMBus connection state on error/exit paths
Date: Wed, 28 Oct 2026 17:57:03 +0100
Message-ID: <20261028165947.839754795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit ec31dc39e835ccde0930daccece8c492d28282fc ]

In two places, current code forces vmbus_connection.conn_state to
DISCONNECTED prior to calling vmbus_disconnect(). But vmbus_disconnect()
calls vmbus_initiate_unload(), which unloads the VMBus connection
only if the conn_state is CONNECTED. Consequently, the connection
remains and the Hyper-V host might continue to send messages or post
VMBus interrupts.

The problem was introduced in commit 74347a99e73ae ("x86/Hyper-V:
Unload vmbus channel in hv panic callback"), in that
vmbus_initiate_unload() started checking the current connection
state before doing the unload. This commit removed some occurrences
where conn_state was forced to DISCONNECTED, but these two remained,
apparently due to an oversight at the time.

Fix this by not forcing conn_state to DISCONNECTED during VMBus exit,
or if a failure occurs when establishing the connection in the first
place. Whatever value conn_state has at the time is then read by
vmbus_initiate_unload() to determine if there is a connection to
be unloaded.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hyperv/20260805205806.B5AC31F000E9@smtp.kernel.org/
Fixes: 74347a99e73ae ("x86/Hyper-V: Unload vmbus channel in hv panic callback")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 1 -
 drivers/hv/vmbus_drv.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 3cdba13b132f0..722c07ec05be4 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -340,7 +340,6 @@ int vmbus_connect(void)
 cleanup:
 	pr_err("Unable to connect to host\n");
 
-	vmbus_connection.conn_state = DISCONNECTED;
 	vmbus_disconnect();
 
 	kfree(msginfo);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 1ddbbc80cf13f..153633bda1426 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2899,7 +2899,6 @@ static void __exit vmbus_exit(void)
 
 	hv_remove_kexec_handler();
 	hv_remove_crash_handler();
-	vmbus_connection.conn_state = DISCONNECTED;
 	hv_stimer_global_cleanup();
 	vmbus_disconnect();
 	if (vmbus_irq == -1) {
-- 
2.53.0



