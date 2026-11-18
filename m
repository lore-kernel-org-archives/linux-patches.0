Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044331;
	b=UfPssJnd8XEGDaBot0MgJXnapmGQkWQBhDeWwajm+5dUOqlgSVl58cIk44MzCzDX1nJB
	 JYE4XiXfkqRwwuQYNaAo3gxiY1SWKg+v0LoRxWP06mz8q7pkwZatrCWk6bMGFVpIRzPJB
	 dSlNkU8C+PRTzkYGyrHwi+uu0PkKFxBIAnSg+DPVehDMvvtdwXle9z8U5F8bYRgxoYfVJ
	 p9yMqO7MxJgi71UnrWMdsu5Gvn6xH4fbQsowOKLMN18BhE9EhVafQ5QYGEFSjLbQHc0Jq
	 yBx5SuhDtsBj44j8AG9WerYzUCER1l+gYbvmYpoCNou0x/dxdN1rfEsEy4s1TtO73ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AhpIKL6aU1YF8R2ErM9G3vZZwwwLb8QG46Ov5+Kg6aQ=;
	b=lZ0yeYqB2GY7X/p9RFphO6aozLSXUX3B6HN+BEcw2l4hQCoA5eaq2uE1XuemRQ0T/rXs
	 1bhd9b/mlm3tUJEwH6fUmKhvQ2lNl0f8fHSgS3RDDvpI8eZxA6Xpq8law+0We6HaLZFfL
	 0r8Ob5Ky0UsRxejzlp4Cuc1bIBJP4po+yp6ntdr1sjLI5GjiQjWUkGUD7JTDeFJvW/06d
	 7soEtC76AmqXtc3vrbNZLGK4lqaXsllVFTkg1nJ/pNVdQ9CChvlOEgpyacmesxMUUVf+3
	 Omy8RSQ8KjPawYoUbzS2A2TNtA3HC8plxzdFXZE8m/8CbOzQmRadcakfeYNto9bnlWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cxeaxbvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069CD606A31C;
	Wed, 18 Nov 2026 23:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cxeaxbvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0931F000C4;
	Wed, 18 Nov 2026 23:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044330;
	bh=AhpIKL6aU1YF8R2ErM9G3vZZwwwLb8QG46Ov5+Kg6aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cxeaxbvv7PsmLwNIPoBi4mCDJ8GIVsIONSEQnVIhFQtbKrY2V+FL3HfFVbQIueN7f
	 09ozAFWFmjMqqSLJ9di0Y2zPyf+jPNEvioNdfnHDpiTtwpubDWfXMBTDJwLunRs0id
	 Ddk1Ocm6+ODfU97exdWfUCQk+ATreos0W/rVxZmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 0530/2857] smb: client: fix use-after-free in cifs_ses_add_channel()
Date: Wed, 18 Nov 2026 15:26:04 +0100
Message-ID: <20261118150220.556193515@linuxfoundation.org>
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
@@ -650,12 +650,13 @@ cifs_ses_add_channel(struct cifs_sb_info
 
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
@@ -663,6 +664,7 @@ out:
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
+		cifs_put_tcp_session(pserver, 0);
 	}
 
 	free_xid(xid);


