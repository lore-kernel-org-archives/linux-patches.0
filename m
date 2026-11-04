Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831374;
	b=p2HTt4b2ZhNUxbDNFKGFkF19U7qxNvmJrHp2LX6vQZsSJNmDCh/k1YDMYkxxj6z38eXx
	 mtXHTOghQXXM3tj0cooKh8Oa27sKMJ3Tx1ljBs1OzertzopoTsb73fHB+oOJk1McwxmJ9
	 gWJ97SCpTcLHKbuM+Pk+zGhxW7AQVy1Lj2v0QndmLmu/VlMYgcxDNmLK6rTASygNFQ/28
	 jgcOrViMe0uRIFHVM8Vuzi0SCbbn8TU4bUWekK7bfo44AaaN6FaRPO3Ey0xErz9cz/g24
	 7gAFVlnUgk1Owdwym+U0aYHL8JytjeFcfXm1kCjqQHqfN9DZujgXRNbuK28QhLot9aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rI5VayzvB8FbpIIUxTWH+yHzjcjyZs6rRH+mfnihxm0=;
	b=eB8fsQ09Q0Q1vCeIIRajlt3yfWtNyiA/A5MSfTZGa5nqiaC5EzvGLwaKzdPupIujcONE
	 Dkd5OgecmoR4S2CcHsV4WlRR0AFqsTLoAU+UpB6yaJbky2CUDm2k8p2lIN6jvEh49nywt
	 1OiSg0ychJt0ybEgY8mCr9Z1YfhfkpIUXDe8o+rcCwHL/CXpJUK2qe5jXPXSncRU09fGM
	 EHSKI4EaGfob1jmsXZDfbNjJLh4Y1QtmfE5XsR8USeWNdmZsipx2UC8UAy+1HO8A6g07n
	 zzSn9xyX8MQsoH+AOWVeafqHTDOvvUjZ5bruOUbG1s1XYFCuKa2cf+qFh4Zt2rvvaZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5ZF2D4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F2D606E816;
	Wed,  4 Nov 2026 22:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5ZF2D4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A371F000C1;
	Wed,  4 Nov 2026 22:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831373;
	bh=rI5VayzvB8FbpIIUxTWH+yHzjcjyZs6rRH+mfnihxm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5ZF2D4cI3PMkMZa6hhJYOQFZUx5aKW0CB3zu3c15pjs5VkZp6NHU5Tjkcfz0DxBP
	 dcB44twZcH//c1E7CdC76eEmffRhfcJwAiwMdxoRupaBzDJyoShX45Bg8ssDHzL4d6
	 yvEaoNg3xMSwUql+n3cl82yxgjX8lx4L2WJMDV7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 0665/1005] smb: client: fix use-after-free in cifs_ses_add_channel()
Date: Wed,  4 Nov 2026 16:06:38 -0500
Message-ID: <20261104211102.293301310@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

commit 031278577380e7875d95aed81a2b2bcac39be923 upstream.

The error path of cifs_ses_add_channel() calls cifs_put_tcp_session()
before cifs_chan_clear_need_reconnect().  The latter reaches
cifs_ses_get_chan_index(), which dereferences server->terminate; if
the put was the final reference, TCP_Server_Info is already freed and
this is a use-after-free.  Same put-then-use pattern as the recently
fixed sibling in commit 717e0a25036b ("cifs: Fix server use-after-free
in cifs_chan_skip_or_disable()").

Move the put last, but do not read chan->server after dropping
chan_lock: chan points into ses->chans[], and once chan_count is
decremented a concurrent add_channel can reuse the slot and overwrite
the pointer, so the put would act on the new channel's server.  Cache
the pointer under chan_lock, clear the reconnect bit and decrement
chan_count while still holding the reference, and release it after
the unlock.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: ee1d21794e55a ("cifs: handle when server stops supporting multichannel")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -621,12 +621,13 @@ cifs_ses_add_channel(struct cifs_ses *se
 
 out:
 	if (rc && chan->server) {
-		cifs_put_tcp_session(chan->server, 0);
+		struct TCP_Server_Info *pserver;
 
 		spin_lock(&ses->chan_lock);
+		pserver = chan->server;
 
 		/* we rely on all bits beyond chan_count to be clear */
-		cifs_chan_clear_need_reconnect(ses, chan->server);
+		cifs_chan_clear_need_reconnect(ses, pserver);
 		ses->chan_count--;
 		/*
 		 * chan_count should never reach 0 as at least the primary
@@ -634,6 +635,7 @@ out:
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
+		cifs_put_tcp_session(pserver, 0);
 	}
 
 	kfree(ctx->UNC);


