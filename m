Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061707;
	b=nDeZvycXVGVyksTWI7fVojGejryQpNbX/ABIUpTX+H+khm2dtF5Dy7YOO9Kkb8rEEgjp
	 FDxjyxKIfc5MVxUjG9s+HB2lptODV2NJmaF1op1NSGfPVofGlrQ8koIKFJhcx8qZK60NF
	 L8dsw0Oi2oQoKoLAtIeNRaAMV6vYErVwz+wzRdfjGpMQUdXnCXPMpSFexATCV/uDJzlhm
	 vjkSuRlhNyL/u4Dk2kaPefh2+yp+3p9F3YyW9839gHRsPQPdMHexdesv7808DRKPxLr1O
	 KAz0bReGPGpum2tXFjE0uPMYAbiBn+bQwLd+scIOXXA6p/gyPfTiE8rUlGCWmuBwkQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tPvaEyNN/c8lfJ/xCzhfoHCsDm04+fJLjZAiYvTfRqY=;
	b=yYCCIlq4aY6isbmocSYkxMTPudiriDUXEvk3QNniByOx8XBvPcrktGaptmUNYNAtpXZ8
	 8J0MYXDREsRUT3Nm5PL1bpnR1sheDMOFqKQrXEaDfQHjqSih+ibWy3wjPJPf/Ev133Ae7
	 /vJvxIxZ9egw3eUUB3ZxTHLA9MWy3Ki5IEFCxtIee9u1I2PshtALbhtjFisKrwh2/O6Cj
	 aZpwOP8faZEiQEdQKBSeGwI4D0WAL+eNrJAoVafZCw/wC65dtZccK5q190KbsZzE/zrFL
	 ZezU3M/c5ILRJEbG1B3vNFDRHnsrUjzLyA6ludFATJTsa/6AhRUXLILaTar57RP8zng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOC9Gjdk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F70606A331;
	Sat,  7 Nov 2026 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOC9Gjdk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C06A1F0089F;
	Sat,  7 Nov 2026 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061706;
	bh=tPvaEyNN/c8lfJ/xCzhfoHCsDm04+fJLjZAiYvTfRqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOC9GjdkK4BGlg4ESi0FI0PTNt/lHnebcavBwO3jEItIx9bsRc3gdUV9c/WQu1+Kf
	 L5c4D4mujRnrA0wvpMVt+Y/SjqltFsPLATeKIVtbJR1oj4kjgSYMbbb8a6GwfJo1Wg
	 +0Rfvr9ZVrSmPB6utr8kSK+nT2ZY8rNyWxskqKvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0755/1536] pnfs/blocklayout: Complete a device upcall when the pipe is closed
Date: Sat,  7 Nov 2026 08:46:11 -0500
Message-ID: <20261107135018.738787673@linuxfoundation.org>
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
 
 static int nfs4blocklayout_register_sb(struct super_block *sb,


