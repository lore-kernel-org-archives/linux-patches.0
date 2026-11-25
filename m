Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625977;
	b=Z+3p2RF3X4LOvMwAAMj0zCvhc7HX+hqdONMfn2XUUPd49ToWfGKLJQa/MT3XZ8IDwLFK
	 W7Q43LNdRss0V0JZFuJj5IdOVt4mtAkMnwZDq5BVQbBrNcvbsWiJ0Hk/0yiYlXRU3IhHJ
	 fqRtvapkuRxs6b+Scu6Af2L3kQ7r+GcQcmwte4mP0z2nt3inDPbK2FYMdNx1AJURr7PeZ
	 xQmO9AgbCu14NOW8fOSgV2WeCmT2ApAu1Btdy6y8+/RJEYjvE8PazdlfhMGoRT5v7Lapt
	 dmeENqoQja6nxm56yUN6viLQsHJ9WXBT8VgjozVnB3hrBQXpkKlyYOKtOW4vuYEskqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KtiCER01E2z8oGulq/oUChTHJSLimN3XqxRe+UnuEX0=;
	b=SjY++7NRUws8c0NQDiAAYBdbFRbZ2/vBX3aYaKfIYRktFhKaAWzyJ/ViiVGQURqxBE7v
	 cYs7+TuFynATk7qp+qDQuGCFiiQDww1LmKVrTfV5X5NIhxAIIhSb7dwrooeYUtC3Y7djP
	 T+Bt5wPTdscbX1519qVSuJr3Ss3DZtoZN3Kj+d4aV/3kPG+ln+0ohUviLLaFFltZJzp3E
	 f0uQsEy8dqPucfW8gJfrAj7IG4Z/sMODO9mDOCTs7MEjypKFrvsu2mIS7DT58jV4yxR5E
	 bJRXYMSirKab990Ub4XpYSzXxBT7tO7nyJPxBYkGc04o2z9ty2XujfmOWs4tX8P69vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJ7HL4Ud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1989606A321;
	Wed, 25 Nov 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJ7HL4Ud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB78A1F000D8;
	Wed, 25 Nov 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625977;
	bh=KtiCER01E2z8oGulq/oUChTHJSLimN3XqxRe+UnuEX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJ7HL4UdME3jTDBeCchyeiBjCznNryQ5DbJLGfk1CRCnd3/PlbtedjbaPkdmc+gr4
	 6q8iCb5UdWbnAwb4NDCggC1GkFUVP+kZ/zf0PGQ4nohGBhF6W2TBhN3HMKEXtxMdxm
	 IukOKLtykl+1dFESqooLz8z+r8BdezXPZh0S3N8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 690/816] smb: client: skip NULL channel in __cifs_put_smb_ses()
Date: Wed, 25 Nov 2026 15:37:18 +0100
Message-ID: <20261125143905.155446358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 8deaf64a59a263161dfc5128f8398fb3dcba4fac upstream.

cifs_chan_skip_or_disable() clears a secondary channel's slot in the
session (ses->chans[chan_index].server = NULL) without lowering
chan_count when the server stops supporting multichannel.  When the
session is later released, __cifs_put_smb_ses() walks every slot up to
chan_count and calls cifs_put_tcp_session() on it, which dereferences
the server pointer immediately, so a slot left NULL by the skip path
makes the release crash with a NULL pointer dereference.

Clearing a slot without lowering chan_count is older than
cifs_chan_skip_or_disable(): cifs_chan_update_iface() could already do
the same since commit b54034a73baf9 ("cifs: during reconnect, update
interface if necessary"), and the release loop has been unguarded
since then.  Commit 12d1e301bdfd1 ("cifs: do not let
cifs_chan_update_iface deallocate channels") later removed that
trigger, but the crash is reachable through it on older kernels.

cifs_decrease_secondary_channels() already guards the same put with
if (server).  Add the same guard to the release loop so a skipped
channel slot is left alone.

Fixes: b54034a73baf9 ("cifs: during reconnect, update interface if necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2140,7 +2140,8 @@ void __cifs_put_smb_ses(struct cifs_ses
 			kref_put(&ses->chans[i].iface->refcount, release_iface);
 			ses->chans[i].iface = NULL;
 		}
-		cifs_put_tcp_session(ses->chans[i].server, 0);
+		if (ses->chans[i].server)
+			cifs_put_tcp_session(ses->chans[i].server, 0);
 		ses->chans[i].server = NULL;
 	}
 


