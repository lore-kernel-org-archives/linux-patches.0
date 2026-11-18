Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017275;
	b=NxHWZEOB6dfnIr7o4AebQU5TYjGpyWEtQxUVFZhFxNfcOTZCgdgF3sSCmuBwFDbR2qJE
	 tIeQ72bEtx0GIWCQZlZWGElbWdyVk+zNkHMf44etPQ17zKASiKqhX8fdafE4vktiMnaQ3
	 V11qt7HQgZ4uxzVklTHm5Gik9w44lTabC5AeO6lmXnH+fDnhR/Tuj0SMovJWGTevVjmDg
	 WePa7N7zUw9zV+e3oAjco0iMg7k0pxQKvwsKeT6iwVrRncrp6+hh0pqzQa/jlMyeAXyNa
	 o9axWMZgleY9VGm6kk1CY47HNpYrivSQjdLkNrBnJ1mQBsMU/a2vF1ElxgJkbaRAnvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eHP7FQB8Jon+NJLK2m1twR0el/Els8JX2+WFmZ3RbV8=;
	b=VoZ6CkIJDfrf8Krdm3G/Cwd6+iVqzA0jL/d2bp8aFYiRWrPbspuDnAnZ0352yaob4LIc
	 jrD1K59bNzGWO65o1OFncLY2gPw8XAKsYzcRQbSXpetzvVWJa3qLishcMSbz4s3f67iS9
	 E36lYSpmWuDn08HdJTqRmMbG2E3NOD3U68QOjUjbA/eigQqM/lsag3AQlK/A/hX9hVkRc
	 QyPxVO5bwS6Pfz/HZ7OxggvLPtmXcKtCtBfMpaDQmdjtZZIlgnkbeSAuXPIPI3LzsvBih
	 3kez5hq96t6J5uupDoHr+jakPm3llwuP44ee6bbtMHFInAk1qy9qfJgWlOiMmaT+HwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBy2sLXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F825606A31C;
	Wed, 18 Nov 2026 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBy2sLXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A614B1F000C4;
	Wed, 18 Nov 2026 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017275;
	bh=eHP7FQB8Jon+NJLK2m1twR0el/Els8JX2+WFmZ3RbV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBy2sLXEdbpZx4tWlUA7oRcRSM5sOvMxU/kme7aVqzvwrD1AJvgOCdFhzchmFOXU/
	 HHfmUc/hfpWcf7Tvd0GMXzuuxorODymu36vwmovU1fvIEqGGU4jltUrxyrvOwmyT8l
	 U27fBYlGW43/jSo7lkmNIfmp+wRuqxcdn7X1lnrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0785/2651] NFS: use TCP for MOUNT when xprtsec= selects TLS
Date: Wed, 18 Nov 2026 15:33:45 +0100
Message-ID: <20261118150316.150267939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 1967de7d1dff9..a7393ff05494c 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -402,6 +402,7 @@ static void nfs_set_mount_transport_protocol(struct nfs_fs_context *ctx)
 		ctx->mount_server.protocol = XPRT_TRANSPORT_UDP;
 		break;
 	case XPRT_TRANSPORT_TCP:
+	case XPRT_TRANSPORT_TCP_TLS:
 	case XPRT_TRANSPORT_RDMA:
 		ctx->mount_server.protocol = XPRT_TRANSPORT_TCP;
 	}
-- 
2.53.0



