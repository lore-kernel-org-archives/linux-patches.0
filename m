Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035382;
	b=iuFyvoflckrXIwaYQGdCGL79vjnpGgVclBZ1supLd/aNk/Jxh5Wd1HiDOW8JDv82gf62
	 +4VBvQaIP2cyARzMjNDdMb0kJmCysmkbbf8CCjXCAriinde3GbIm0F883DWxZRSoTH1te
	 hWeqwALlI9y7Uo7MKOADXsz8Tn3bDs+vkK7p0qkAX9LlwgBz/NmyXsoyVldJEKMj9N0jW
	 Vm/l+O4qdomY5d87VyTMcMdzYSghbKcHUcp3c2QnFRFikQH79AQ/Tv2J6zqfFtxiTQdpF
	 WotLym/CFIEii/u8nfZhnXAcd4CLG9BHAAXHWYiAv/m9wXaA+Sa3oNEpstuZWSlVJPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IzC0U4XwKe7OeT0wnTiOB7I1WWKA0U8p5gJ/0uBTOAo=;
	b=0oMjGOLb9YzzRD+dTZGrv5O4naVgLXNSd7GLr8Tx3eiNEKhKFJr5AgyezWcCz8E9vi06
	 Hmbh/lfKaNJMK/aQbqwXI6KHCC2HbeVSmpG4Fcp7DeMFXD5uXBCH6ZhZZ4PcniMfb2nG0
	 SbKw0qCdUi0qAtVY+9oSSeeKy6WmuTVxoKm3vtcrEUchAS2ZtUwZfhfIEuybyT8sOazCv
	 mVCfpv5ecZqSdxIq7PxQZo3T5vULh2nWUVkEb9o38bg9gbL1jUqdd9qQ2S8hNq1NzaZmg
	 Kq6LN+wBV33OkYklKWQEpwoePvByd50l6wY+WM/kyO5bbOi40M+O1h24WOAb9QdarWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfW4lIz4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AE2606A31C;
	Wed, 18 Nov 2026 20:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfW4lIz4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798F61F000C4;
	Wed, 18 Nov 2026 20:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035382;
	bh=IzC0U4XwKe7OeT0wnTiOB7I1WWKA0U8p5gJ/0uBTOAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfW4lIz4Fn+4/CY0OoShG46xrgunKC5edMh0rFGH4puGSDWE4uvCn7IVLVYMy9S6i
	 zyxq8KXk8C/7OTRfc/GtrGkBOMcODZzaJ1Yo5gxcNNL+OkJC2QpRmzjogVci+QQcaT
	 5ro2Qwh9cVhMZCmMYmK35XXScBA10HUY4cjo8NPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0682/3318] pnfs/blocklayout: Complete a device upcall when the pipe is closed
Date: Wed, 18 Nov 2026 15:21:44 +0100
Message-ID: <20261118150338.660816189@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit 2a25cc8e984610828a526086313b8a7aeefe507d upstream.

Once blkmapd has read a whole upcall, rpc_pipe_read() unlinks the
message from every pipe list, so the purges in rpc_pipe_release()
and rpc_close_pipes() no longer reach it. bl_upcall_ops supplies no
.release_pipe callback, and bl_pipe_destroy_msg() returns without
completing the upcall because a downcall is expected to follow. A
daemon that exits between the read and the write therefore strands
its waiter: bl_resolve_deviceid() sleeps in wait_for_completion()
and never returns, and it holds nn->bl_mutex across that wait, so
every later device resolution in the net namespace blocks behind
it.

Add a .release_pipe that completes an upcall blkmapd has consumed
and left unanswered. Completing an upcall retires it, so a message
the framework has already purged is no longer in flight and is not
completed a second time here.

Fixes: fe0a9b740881 ("pnfsblock: add device operations")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-8-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/blocklayout/rpc_pipefs.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/fs/nfs/blocklayout/rpc_pipefs.c
+++ b/fs/nfs/blocklayout/rpc_pipefs.c
@@ -151,10 +151,31 @@ static void bl_pipe_destroy_msg(struct r
 	complete(&nn->bl_done);
 }
 
+/*
+ * An upcall blkmapd has consumed is off every pipe list, so the
+ * purges in rpc_pipe_release() and rpc_close_pipes() cannot reach it.
+ * No downcall can arrive once the pipe is closed; release its waiter
+ * here.
+ */
+static void bl_release_pipe(struct inode *inode)
+{
+	struct nfs_net *nn = net_generic(inode->i_sb->s_fs_info, nfs_net_id);
+	struct rpc_pipe *pipe = nn->bl_device_pipe;
+
+	spin_lock(&pipe->lock);
+	if (rpc_msg_is_inflight(&nn->bl_pipe_msg)) {
+		nn->bl_pipe_msg.copied = 0;
+		nn->bl_pipe_msg.errno = -EPIPE;
+		complete(&nn->bl_done);
+	}
+	spin_unlock(&pipe->lock);
+}
+
 static const struct rpc_pipe_ops bl_upcall_ops = {
 	.upcall		= rpc_pipe_generic_upcall,
 	.downcall	= bl_pipe_downcall,
 	.destroy_msg	= bl_pipe_destroy_msg,
+	.release_pipe	= bl_release_pipe,
 };
 
 static struct dentry *nfs4blocklayout_register_sb(struct super_block *sb,


