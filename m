Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826985;
	b=gLJhCLL++ACLO80eJ6sl5Ojl8Wh/9teabccIMf6Bz7lC3nQc+lsIP/ysMqLhPOgv7FOC
	 Jmsybz45XqatK1ci4B5/oIhGrfqMXbBecCOSxSTdVJ3vpH0kPhHsq7YKlj+yxnpGoCj8O
	 6vP0AMlMFKqWSsi5RBRtok1dsFK/Kn7mLJZiT0n4KevtQ6ED+mBnJbO5uXDBP7NsW50np
	 Ucb9BRwNonQtrz7Xubopto3Hr5IuZgq0u8OFVC06ZkW+33o6P1G/hPwiOyKlYWv1fJmfw
	 Za06LemIsHUSNgWgMhlia6pDe33wr+1aHehrAbjAkHZZesiTMZsPb0BJrcqu1lqP2aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=usZlT6BiVU7o7vAgy6lzZG9f3nmSSWo1LAx0J3knv/g=;
	b=BKPOjUWrcAC/oK5jEY1E8ACzSex/pfZ3ZcAZiaNwOHwYOq7PLTpILwvriSc73S5xITic
	 /lG9K9yZfqcEh8kGR/yazHaxmXwBu3Qw8M0lkcHwFHMtHGAKTLheKOac926Sp5wJlBwu7
	 nHZhwpzq2+gc6diCOr5w/8AGp1rQlj7R2iX5EjrAwknxzUWTQ9WDmOh9yslcFKvo/ivYS
	 ZjCtXK+J3kFdW+gcVa8UcKOQABhLsn3iGhmfBMuYFOlS1qEGd8Ju3PgyGYnCafivM+mqf
	 IFaDQr0USO9D7wuYIDUYUbfLl3Op9KNTH1RG1K+e8mo7UZFB7ua/bFM0cL3yLHLX6CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqCCJlXW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D506070A8D;
	Wed,  4 Nov 2026 21:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqCCJlXW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2899A1F00A16;
	Wed,  4 Nov 2026 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826985;
	bh=usZlT6BiVU7o7vAgy6lzZG9f3nmSSWo1LAx0J3knv/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqCCJlXWnXt93HN3qfG+/huncfS+FYhSTSMWbQtQiWgRAJFBE3wMRShPTlwL1yteQ
	 ijwFumAdEvWN5ZYr0oeRrYBxdmHFqg6h4gZANdDxTotcslm+AFkfHfX597YzQwGRnv
	 pHhSuTosrsE5i0Nrjzbj8sizuuX0o3Fof63gBQMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Koester <j.koester@act-marketing.de>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 124/547] ksmbd: ignore network devices of other namespaces
Date: Wed,  4 Nov 2026 16:05:08 -0500
Message-ID: <20261104211041.712192460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -577,6 +577,15 @@ static int ksmbd_netdev_event(struct not
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


