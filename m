Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030152;
	b=Vr/B/BncB35qMo+LrXskvHpfvqqsDu0P8zsfCS6pnjua9JxwoOpvUZ1s5GptU0svNued
	 AilbZuZ9jPVrVN7iNQ7LeZBajQ5+qbhMZmRY1fjSsskYd9Kho4xg+/11MJXEpsjzek87i
	 nrQgdhgg/rPcY1LqMlPnnEhwRN0l9BdE53AvovPGnSSkWDvBlDq8nDtNhuJWBIYaOvTtu
	 2fv4rBLXWn7BioXs0IRNSVpAFkTPccwp9kTJcDhGavf6zq851mc9uBT/tTTZ8uUxMhMXB
	 59zeAlulFXSE7Z0bg9Q6XjUsVxtIsLTVV5XVCTKYIVHEXrS3pwZgaDn7WMj0NoMFRTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZrsxyuuLxc5geRGH9WkxwQfswHA/PGUdOQsJrUxf1K8=;
	b=eBxUmYYZj+cf/lH5oN40sfHrf2doNP5L2QTejPEKQakHFy9/qqJy7iw65UKgA49arTVk
	 IezJ9p3Ma+uMQ0sOjpf4+sjHRLk41D1c1FkaPTdlmx5Ne37cNBWH3NnKOrhRx0B5isJ8n
	 zbA+t0kfPj1iINKr1CHK7SvG7ZadgQt5LXn5w/xnNyflGjgdhlHTzu7lubwAy/ZdOU7ZL
	 ZrpArqOoAnPLV1s7ECoCRV6jAx/lkHbSeXRJ3f3qc1kBEhtJtjHqV4fP29Zh+OVJ/8RJS
	 AKg3HyvZEA8YEmsXYWIFmO4FfoBoMvgHzWUpLw1v+18EMXhtis2eCoay7/Qz5zuscPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9xdoNf2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1090E606BB77;
	Wed, 18 Nov 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9xdoNf2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A191F000C5;
	Wed, 18 Nov 2026 19:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030151;
	bh=ZrsxyuuLxc5geRGH9WkxwQfswHA/PGUdOQsJrUxf1K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9xdoNf23rstzCJwoWiiWQaMPTSbuUhZDZINJbvvzX4QsoBRnsKGQhpFNXEHPDa4T
	 py2xdAFAOhiJ2Bg1C1vUAhwPAmS4rwcHEOFjk85Q7cfszMujMup48GDzVppCEekIGj
	 AU8O4pCLRkx7GjDdF8eujP7x14tYH+oNWp3BRdLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0561/1756] NFS: use TCP for MOUNT when xprtsec= selects TLS
Date: Wed, 18 Nov 2026 15:44:48 +0100
Message-ID: <20261118150031.419998765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 72233aabc78cd0415c850641bc2a6e4fea23173f ]

An NFSv2 or NFSv3 text mount that specifies xprtsec= but no
mountproto= crashes in nfs_init_timeout_values():

  RIP: 0010:nfs_init_timeout_values+0x10a/0x110 [nfs]
  Call Trace:
   nfs_mount+0x1c3/0x330 [nfs]
   nfs_try_get_tree+0x1e5/0x460 [nfs]
   nfs_get_tree+0x64d/0x6d0 [nfs]
   vfs_get_tree+0x2b/0xe0
   vfs_cmd_create+0x5f/0xd0
   vfs_fsconfig_locked+0x50/0x130
   __se_sys_fsconfig+0x2f9/0x3a0

nfs_validate_transport_protocol() sets nfs_server.protocol to
XPRT_TRANSPORT_TCP_TLS when xprtsec= is present, but the switch in
nfs_set_mount_transport_protocol() has no case for that value.
mount_server.protocol stays zero, and nfs_init_timeout_values()
calls BUG() on a transport it does not recognize.

mount.nfs always appends mountproto= after probing the server's
rpcbind, so only a caller that bypasses it, such as "mount -i" or a
program that drives fsconfig() directly, reaches the crash.

Select TCP for MOUNT when the NFS transport is XPRT_TRANSPORT_TCP_TLS.
nfs_mount() requests no transport security, so MOUNT already runs
over plain TCP whenever mount.nfs supplies mountproto=tcp.

Fixes: c8407f2e560c ("NFS: Add an "xprtsec=" NFS mount option")
Signed-off-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 7e000d782e283..adff895de004c 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -372,6 +372,7 @@ static void nfs_set_mount_transport_protocol(struct nfs_fs_context *ctx)
 		ctx->mount_server.protocol = XPRT_TRANSPORT_UDP;
 		break;
 	case XPRT_TRANSPORT_TCP:
+	case XPRT_TRANSPORT_TCP_TLS:
 	case XPRT_TRANSPORT_RDMA:
 		ctx->mount_server.protocol = XPRT_TRANSPORT_TCP;
 	}
-- 
2.53.0



