Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620211;
	b=Tz6pTUKZMOUjCU/iCc9eX0Lo6yDfTKSTE3h0vV/aKz6ch/1ANdb50T9tcAhmB734ns/c
	 EWjqJMuNJ892D6gXV+AiT8ssQMJEdodcjB/r1QUO3mMjxI6HyFCZcqjCTHVOoDVAjX+XE
	 /qamAcTi4JrDgrfn8pLLZ3fhRzD1WlAVZvxACZ0Y1pGPe+prCHSbBa/DSXUhnbeWmCfed
	 yunFtIaVX0YBSVLo65qQ0vEvgSgDXs14PVDnJwQTpDuoNAoZqD/kPu+jnUqE5ywNnGKso
	 1afN9r2MaZ1h6PQAJkb1/fB37wCDs1Wl8osVi0goTiTBdmXCsClXkLO6LjtdfLBF89w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9zZMwYEZlW0eRh10fAjPYCANRU0cX0H8sYKzq9m5F4=;
	b=Uv08D94m1yZduHQh3HTsWB7VF7u/woFQt2LAjlVtgV5Hvz8RVb0UpGgAgjbWu0s1ZG0a
	 7lRUXjmIjqoZnYGXn1n+FDODPeFXITbNZAm5Ppsn5TKuPaXdUf0cKVYVXwXLZj2qvVZGt
	 zRLMTXidY+9TkJuQuJcO8hmgojbAFea4mFmej0ISUY6rK/8u8m5Mn9FrLVyjSc4dIiwQP
	 YstGGmGc139soEQpMzNDu5Mvf7dcpxjRVMqmJc1jXsAMCFxaTBEZ7yPsyx9hBpib20Z9H
	 hTZ6XKvnMdhFC+zxViv5dhggSwUzOcOtAg0ISY7KZD83CWANFcy83FkIMF4116yuznQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqzQrQDd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7071F606A32A;
	Wed, 25 Nov 2026 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqzQrQDd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693AA1F000CF;
	Wed, 25 Nov 2026 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620210;
	bh=U9zZMwYEZlW0eRh10fAjPYCANRU0cX0H8sYKzq9m5F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqzQrQDd2lUntUXp9HXTe6z/Vd/5SFtj9M1xP1gYJdXCeG/QeF+kzzxnmEoOEFoBc
	 MIkM/jQdzZT7MkNuec0eNbXyQsUqGUSIr2Jaie2pkLlFoPGq2qLxvVxTmTzUrCqoQB
	 KbuHHwzsXBOfH2GXITUOsPG0bvUeOrDSECC9xbb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0846/1005] smb: client: skip NULL channel in __cifs_put_smb_ses()
Date: Wed, 25 Nov 2026 15:36:24 +0100
Message-ID: <20261125143841.530988525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -2179,7 +2179,8 @@ void __cifs_put_smb_ses(struct cifs_ses
 			kref_put(&ses->chans[i].iface->refcount, release_iface);
 			ses->chans[i].iface = NULL;
 		}
-		cifs_put_tcp_session(ses->chans[i].server, 0);
+		if (ses->chans[i].server)
+			cifs_put_tcp_session(ses->chans[i].server, 0);
 		ses->chans[i].server = NULL;
 	}
 


