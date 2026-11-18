Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052010;
	b=Hiw4XrMp7tkyBBPSDv4LGmv84ZIZNJ3tS88SMAzzN8bZAlZXbVg3e7gD/W5rsLpugM/2
	 Sl7hIsQcK4bb1R+ZV7p5iX9ckDa/L+UUjeH4lpRG0lzlwOKrOEM9FWuf+CT6aJJLrojm+
	 kOUqMvFCciNbMOeHoKV8zSS0lu1ehAFxhNrH1oXOLoji4i6c5bt9vUD3D7Jo8Kn/CFJF4
	 wkugsXqVZrp6GS4LCQXsgHVurC3wZ0YL+Hcxxw/fbHDuDIcUG2IkRwGP7gveViO0dlvGp
	 6FLAVdFltnkFJj9sWlESr3qH6DMcqhiGRT/VZIN769BmV/WFhJ0lF4oCGhPNF3fvueQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=blRZ0u7cgBWdV0m0AVj8ObTCxSD/VtGu1y21/U4oRIg=;
	b=m17tAkPCQflD8Lyps5famtmE+Se22PVpRCvtRLSpZdM5hd9vePnekj9YHOypdCR+pO/l
	 YjA7qkEIqSee/3RVDnAqb3icjqNJDlXU7qaMgiiuQrlc1Y3qcMbgGDDTSwCqz/8uHXy/k
	 K+1dL3XU9L00/pBEPirqFMArETSttoT/zw1OXj70FeFn/WlUmQr30TW8CbuwvMN8/wej/
	 CjuYKCmOibfJpJxJkC4ogHR0Nh5AVh0Ys+3O0f9KjU/EFS3UvDXfVtcFXFZtkDaxG1sWX
	 n7h1m4i8rFktXBhcqvSg8sKuFHJ1NezTbB/UWbauHD6UnYSClNK6siYa2/PquzxkExQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=im3oaKL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F18606A325;
	Thu, 19 Nov 2026 01:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=im3oaKL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C2C1F000C4;
	Thu, 19 Nov 2026 01:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052010;
	bh=blRZ0u7cgBWdV0m0AVj8ObTCxSD/VtGu1y21/U4oRIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=im3oaKL9FRx8z9FK65juU2rtUb5FpRF7Ssh2UXFKyVZdEswE7vpgtKJSSac7+BCcp
	 zZBlgWCWqwp8XvZ6bbCzxIzLK/hfmFzGKX4By4e7IHzloF2oKYfRaBy7DHL8BLe0P2
	 +fR1veeMFPtKu9yBuARKJ9j7NckwS+BgQTA8Ovx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Koester <j.koester@act-marketing.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0410/2214] ksmbd: ignore network devices of other namespaces
Date: Wed, 18 Nov 2026 15:34:46 +0100
Message-ID: <20261118150027.165679514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Koester <j.koester@act-marketing.de>

[ Upstream commit 1f5ce2b8b9164b3fcb93a18fe1e7b451c2fc6eea ]

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
[ sashal: Adapted the patch to the older ksmbd implementation location. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_tcp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index c0a038666ec34..ac34fc15b0c13 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -514,6 +514,15 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 	struct interface *iface;
 	int ret, found = 0;
 
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
-- 
2.53.0



