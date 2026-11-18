Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044297;
	b=TW/yPMFr9QvxLjE3R1QsZ5TK4waEgGjrGpBn+eK8/e8p1/KxTwNqaJCMsEF/s6ZwXXzr
	 sWYpZdj7lZGEdIQzxEAn7QX9Cf+ka0TUB1S1cjiAPB7FH4iq9ZFr8o0qTN8+NtPPsguv8
	 Eh/rsCfDkESZwdaj3WkIQUxBFbz1ZO3cyLcepfO50Z418hFdnsUgQxktnCMq6Dk2J2edc
	 aqVe7+mBO0IpOI1VxGfKj3CRcHIQuJePwSikaZk4sgGT0lZ/b0FtI1QiOLIaomBA/bJom
	 VRHOoQ7rmYGMCjWEexdcAOrRnmPbFSuE6KdWY1IjnBHX1znUK+4ouJ+C2IsFwGYf5/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4UjUBtU3AVhZdPQo/bhy7/3QZY0yAEOO1IVzKn+jPU=;
	b=xuBdSBLxoEJncoq5vg3C6ElgrM3Q3/MmFk6LsN5WCfO2XB9+NiGHqFwPzROd6q7Pf5m0
	 eQ0pwXIjf0aI4GHfVCR2ocl+YA79eg8QqcrcPCcEGziW1Ue+3l67Y7Gq/govoYkcr/8By
	 sSUyLi5QZJrW2cLOJ5eiY2nwyCOEtBzT+sIkSOM/E2J66Z5XUpsPY0RoQEisC2lt64RhU
	 O/NfhmfBHEkh/lYswXW895bo+7magdOjLoTiBABD9to6oncDtq10QYVaQSubtCiQxLLR0
	 x/hX/xwFjV8nv9WEQEEw2dPdWQRFqAKRgEOSs9pIGIiPahiiPdGG4pRt0ZfJyWVjTuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jYx/pNxa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B8B606A31C;
	Wed, 18 Nov 2026 23:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYx/pNxa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84871F000C5;
	Wed, 18 Nov 2026 23:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044297;
	bh=L4UjUBtU3AVhZdPQo/bhy7/3QZY0yAEOO1IVzKn+jPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYx/pNxatIMKN8L89HXq91Td2Nq4p6U8Gdvsb354ZQoZUE2sgHAR6aLVW+CZHRaMO
	 3wqi6NSHms6vmZKDBcGMN2oZ2257Gip6z96xNgSnQeYJi6l4msIhrUZr2Ox5zDNlp0
	 5tKiCIeJA8QAS5Fr4BLMV+UtXEQWWszla2lRefQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Koester <j.koester@act-marketing.de>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0514/2857] ksmbd: ignore network devices of other namespaces
Date: Wed, 18 Nov 2026 15:25:48 +0100
Message-ID: <20261118150219.971553114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -574,6 +574,15 @@ static int ksmbd_netdev_event(struct not
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


