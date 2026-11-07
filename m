Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061491;
	b=qjh6ZtOVCUxyb07LdJZOqQ7LjREkjBZyYLjpl1jCOTbQ/vF3BKSqZfyHcKvy78XVj920
	 hDlE0w3nxfX0n9g6/F7KJ+dXEY5pA6R6tz9DdiNvnqNpy/edSKl4bf4JzldCJkSYZcHBU
	 qjJKgu5X9Nk7Vv73ShICGf09zCIcKqV4/dP1IbHD0fACbs2JSN281RgKGCyz/zuR6ZeWf
	 dQqtxRw28YF3w3W3Wucq9HqQPu/SPAHM1uT1CXi181iaCM4rvfiV74CteHvfcJb+BbDWw
	 sXSeOA4cDwYr6yryQvEZ+4MNJU31JYPL0z9EMloxeQwpIxCc7FKXOtC7/vsILZHDNiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wa3LnzwqmBq9p4tibBaIuV3aMiSiuqQVckXSXAsFNAQ=;
	b=YXnufnbHfSqragOV9koi3eeiVUZmWRf5LfibzwYKemKV+cWQnmLXNlMf+7kWINSBuXP2
	 3grRU41H85HGM1ZjAhmgUaCPb6dEUK+r2YtYbllrm28Pzz2sT3n3ZhFSmZfa/TDDkxGzB
	 0X0K5xxWai/lgwXo0o3DUpWqB/P/lyHQc6dIDh4IA+uWdBibvolXZz3nGwj5nKvdb/+hQ
	 Y25Pdrnl29DY51nNKNgXcyYKqNlE/qd/Jub07Tw21l0Jobglnhj2r/UMrl1gcweHuRWxk
	 wKvG7I2wcYeXweWwihOuvtbqIzwmSs/Wd4i7gLfD5BXxVAqRO8guaucEaURIxvJ1rXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MFeCoVP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61913606A331;
	Sat,  7 Nov 2026 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MFeCoVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C541F0089F;
	Sat,  7 Nov 2026 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061491;
	bh=wa3LnzwqmBq9p4tibBaIuV3aMiSiuqQVckXSXAsFNAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MFeCoVPW4YDx65WyAk4Y98Y95zis3y4SM7/XPdbZ8ueCJmy08jlPeJj5Sr1gC4A9
	 KqhbT/TmAMTWa58RgoIMnx9zkfkX/7tC+gY65PdT8D3HLz0IiDmoP/B0kKSgmhSQZh
	 WEInCK8QU1XuziYS3dV8muMwSMTE/hogTUPrsMjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Koester <j.koester@act-marketing.de>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0588/1536] ksmbd: ignore network devices of other namespaces
Date: Sat,  7 Nov 2026 08:43:24 -0500
Message-ID: <20261107135014.050161993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -602,6 +602,15 @@ static int ksmbd_netdev_event(struct not
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


