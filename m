Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208491;
	b=xK45di4VoXhiLwFfeEGOjkfy05jdoYOr+YkXFN3BnIvKg2n+DjYtVs9avlKbtkkfx+xo
	 8oGkpiMS7j/vaHFdjGDLz4zQVibOJNBUsiyRvku4GDoBhqXvUnqa4gyVMH2vS2yI6JyUu
	 zyGIofoLTyuYUgMIVYS5fKlufalsHqBswOwdBNREtYhpO+ZBAd6BrfFrB3K8SswkojAbr
	 g7sdt45rfW8rm4S5kxWEERrg4DNQM2ZJW+IEmV++XSTwHYbuAyD6dNADjMMHhDv94jVM0
	 /4OZhO2gIs7vqJ/ZHwsAq+EjEMirxgGQAUGW208aLjiq1BJuXLCIpB9G+DL8k+4Nw6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RNNp+pLt89H5eE9561t2nCuR7J3VzaZwT/IxHF6HHNg=;
	b=BeF17gdl8K/fps8N0nTXAlpS4EQNgd++qtUqB95IqToZCbzxIQ+rORiBWfNWDUp/ef6s
	 +i3OMJFya+R1ov2srtqDBBI+UNUO2yOdkVoJ39cxfWntKYD/DtiU78TG/+bIOTl5YOVZX
	 NY7v6hjkFitiLryyggADs+oJguE4ucPOxRwcpoVCwSd2lbkH6saM30obHpbx8vhnwKQ9d
	 6D21MiroN6S6FwBOfGectDSqfvJn01eKQUwVk5Ry5iiJRu4tXK0DnNRfAN2kzgeTs3KdO
	 WyOOewQE8YbpqX+da0lNNX5hw0iVAoXEc/5idTpc0QzTnm1hojkwk2sm66Wjg5c5H5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmaRSTUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD2A606A31A;
	Wed, 28 Oct 2026 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmaRSTUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CA71F01825;
	Wed, 28 Oct 2026 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208491;
	bh=RNNp+pLt89H5eE9561t2nCuR7J3VzaZwT/IxHF6HHNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmaRSTUGM/TwDaTHpKMtuWl5JJUFfa2ApEWRb1IrZmHtdCHNdpJaicuiBOVswWIIm
	 u63Uq6bR5Gy86v6iODqU0BzF8fa+eEv7ul97I4n2wDgWYV1E6fvCuU/c+PGHN657qq
	 veaMWvOTnjz0Bhw+f+li5qGxXPn09NSyrRnlkFJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/516] smb: client: close handle after create-context parsing failure
Date: Wed, 28 Oct 2026 17:54:48 +0100
Message-ID: <20261028170006.732504722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit 566820af017e81497fb5e9d3ad6e7ffe2828bc8b ]

SMB2_open() accounts a successful CREATE response as a remote open before
parsing its create contexts.  If smb2_parse_contexts() rejects malformed
context data, SMB2_open() returns without closing the handle, leaving the
server-side handle open and num_remote_opens elevated.

Close the handle after a post-CREATE context parsing failure so the error
path releases the remote resource and balances the open count.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 56d24ae83d779..a2f1d165d8862 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2967,6 +2967,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
 				 oparms->fid->lease_key, oplock, file_info, posix);
+	if (rc)
+		SMB2_close(xid, tcon, oparms->fid->persistent_fid,
+			   oparms->fid->volatile_fid);
 
 	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
 			     oparms->create_options, oparms->desired_access);
-- 
2.53.0



