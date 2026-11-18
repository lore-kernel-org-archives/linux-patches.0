Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035013;
	b=jCTWewpqQp1o0+rIx8UeAwrlTWU9UMQi7njDgCDZauOf0tlcdmK/KXntM1jvNWMXGZVg
	 Ho2SraGEEyRu3dD8rpnFqEWiCDBBJdv1CE0ireZz0SItAvmOUyAV/B/IrlPVRf87NsRPD
	 dEsaezKHR7TFoApOObStyvbOC3izGy93hVIFD+No6kQfH306F9Dk/3Lc3oRQUylGi3P3w
	 SBrBJwIJ/bUzfY0JnVSObSf5pghaB4lj8M0JI7nrC4C53r7i/kPgCmwdoGGRfdmdNvx09
	 l2SaZaptiawUAUTruLOfJW2NtGC8SUNoeb6yYRpn42zX3xnJ26Z4gz4DpQO1mHxmKYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MxIcWJujWzEIlnUMbT3urHj7JteFaPw2I24qOIP8Fsw=;
	b=dGCSwm3gInIYbgRjUpSqiS39/SaZdv4F25XYdoC4A63JZ4U3wSsXl2g7Sln2myjdv0wP
	 wIIvCh4jtY347LxO6zwLhIsmTEWEQTHPRRvtURf0FRcaqUOSlzWjnBKtOvOZVxHKIuegk
	 wrn4VrCVj04ad2coAk8FOH3hwqEx+Srsy/wjuP6sp29yhJFDyNd/+bkh+V5H15Ko+8Zpw
	 G6DczkKa1EOA4xpks+D0jN72CEEz1fzdocQF0miw9FwEkTzLTvw2HFEj8seqBdWNk0KOE
	 9b5RPssQDj7Z4yhqZkJKfho4Lg95vYw+yiFMQLKHCS4F4nhrS5Wja/DJD5ZqZ788+AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W16Z4eiX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6742C606A31C;
	Wed, 18 Nov 2026 20:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W16Z4eiX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC951F000C4;
	Wed, 18 Nov 2026 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035012;
	bh=MxIcWJujWzEIlnUMbT3urHj7JteFaPw2I24qOIP8Fsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W16Z4eiXCNR7hV1Su+Wrt/fk99hmEeopCGCob0odY0Tqciyxw5vyxTai9lkQi26d7
	 64bvrElp0LKhDcQzW0AW9tUpUo31AxkiC1Droc8cSNeF3JJpGGgLxD+vGaIfSKByQd
	 qbJy2zAq2lO4fVUrSMKqr1M7M6qRX7xl8ltaM/co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Koester <j.koester@act-marketing.de>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0573/3318] ksmbd: ignore network devices of other namespaces
Date: Wed, 18 Nov 2026 15:19:55 +0100
Message-ID: <20261118150334.652491295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Koester <j.koester@act-marketing.de>

commit 1f5ce2b8b9164b3fcb93a18fe1e7b451c2fc6eea upstream.

With no interface list configured, ksmbd binds every interface that
comes up. ksmbd_netdev_event() does not look at the device's namespace,
and create_socket() opens the listener in the namespace of the task
raising NETDEV_UP. A container with its own address on a bridge brings
up its interface and finds port 445 in its namespace already taken by
ksmbd, so an SMB server running inside the container fails with
"Address already in use".

Interfaces are also matched by name only, so a container's eth0 going
down would stop the listener on the host's eth0.

Only handle netdev events for devices in init_net.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Koester <j.koester@act-marketing.de>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -603,6 +603,15 @@ static int ksmbd_netdev_event(struct not
 	struct interface *iface;
 	int ret;
 
+	/*
+	 * ksmbd serves the initial namespace only. create_socket() listens in
+	 * the namespace of the task raising the event, so a container bringing
+	 * up its own interface would get a listener on its port 445, and the
+	 * name-only interface lookup would let its interfaces stop ours.
+	 */
+	if (!net_eq(dev_net(netdev), &init_net))
+		return NOTIFY_DONE;
+
 	switch (event) {
 	case NETDEV_UP:
 		if (netif_is_bridge_port(netdev))


