Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831341;
	b=FSjcJWpQ1BGNq8kUqXLPdXZYCwYYwwbR5zmJklcDJ+kXeDPq+WfVJcnUJRZJDQd4WBj2
	 UM5TmsOldYi07v+fLFYZtm8A3wEdmGHL7u4rtYQt+doiEcVE/zR4LKoWkNH5/c2iwr6AA
	 JSeFf6OSzSeqkTGLVeqdCMHk8kye7z6xvyWFAt0P45SACFsxBro+XufOXYw3P18fuwtwx
	 KbFySgng5Zb4LIEcBgNu91RCIoGUKHAm2xxXLAmHq9H7SzdnnLbObw0Zwm/KopzrWGYbm
	 o9ACp/WAIcWWeIXfT2Mhwhw81VaQFkYzb54C/EyGH56t0jqFAiqb36EnljArNnIQPiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vEvwxbNzORqcB4iT0tMwh3hrwl592w23b/Ncu6HetvQ=;
	b=u5caHYGg2TESaUXTFPWiV+W1EmCnmQClZ0ge2iDXOlAJMVtIfSES/SMBYctFI68F+IrZ
	 8nTt/EQ6mFG2S9linvBw4sKsXqC9U0ydW9BawfzeTbnGgUPKK8gGzl0/CZaUP9V+diLZO
	 EZUZgwe79QUkptO/lZ0eXg6J2Ez2mj79YSUYzBKtnkfl9wnfZIY6DP7x4Ti120aHBExm6
	 CHAtU3NotZ20iIUaHhVAVU9Q9bY/PNNTr6Q3UNnm7pqlj1k7G/38j6i6p9hVikLaA2hjG
	 uS8M9uEW4bP1BeWwnEJ53JBQHGMzV792HkzRM7k/3Cco2YNZaePOqzAjdUKqN94cndw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ta5iYEsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E942606D81A;
	Wed,  4 Nov 2026 22:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ta5iYEsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC0C1F000C1;
	Wed,  4 Nov 2026 22:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831341;
	bh=vEvwxbNzORqcB4iT0tMwh3hrwl592w23b/Ncu6HetvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ta5iYEsfyJJN1SFQSsUT4Llo0guJJGndpsW/57Ed2XguZpoG+AL/5prFT8tmnrpWz
	 quswDpmOW+iqXF3XqeQi0fNV4/Zed7wuj2x0ewFalF3MZb58+GNfvF5ROkQ47vjN2l
	 7eac7e2hBjasg3jRu98eP+uiftpvbpSQSrQcScxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Koester <j.koester@act-marketing.de>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0646/1005] ksmbd: ignore network devices of other namespaces
Date: Wed,  4 Nov 2026 16:06:19 -0500
Message-ID: <20261104211101.835253163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -589,6 +589,15 @@ static int ksmbd_netdev_event(struct not
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


