Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212476;
	b=tpR1W8Lek9ig7/hEInMlJGKfg1dMpgQHbexv1f3OvsND4ey8cSWFtyVNigv91FhS6srj
	 gCxZM8Z9Ec9peJA7BdrGz2hIyKGSAaZIDaFw+oSrAEdnl2XrWCWkuHExOZf0MojLZt9HS
	 nFaCgQxYB+cYCTznlC1GcJJs4Oq6YmnXKY4BY/2MjsD9aLZrhxSA6mQpycKlPUAY3xzxD
	 dgsYTw/yRyBTEYXIVJBejlyCd5KEX9W0KZpj/2mcxwHnw3FDhTxSrMVg7zA+68LXIZgLV
	 kyLkvtfj346Quyjw32t4DzeLM3DhxVdUNNjOLjQvXQib8LSVJ8jeN+feORoJYd0pzzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=crP8Xibn81/QENx7e7gbvqrxuNeIIJGE9rbtErn5ko8=;
	b=1FWokW1i85v+38c7pp4WNWWolJgQz6Q5CTNiwdNTGGgQVp3UR9MmDLHdGyc5RDGg3aG4
	 t7TksQoAwQE4NAmsU1ybIugYOUAAxxnfttm9pVw+fNMJ7YvAwVGhOcRjn4mF/MNBFSBpE
	 7VYePdmwtot8AlVO+eBMfpl1UT2f3XCc6QIUfudSt4AmRRYPnPCd8TpBOcX/N9SMw5l8Y
	 IjjalzCNad7dlQGoWYwk60fFTP/GkLFAF8ZjlKAL26e/6RHDW8zuYD+C06V7n738L/Yav
	 eW9g/TLnM/Im4kCxrrUEU0B3tW3tSUOqv+zsZanDP0iPTcK4QY9+IEqVMRQ8bvoOLoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yuko3fdz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79EF606A31D;
	Wed, 28 Oct 2026 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yuko3fdz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C51E1F01825;
	Wed, 28 Oct 2026 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212475;
	bh=crP8Xibn81/QENx7e7gbvqrxuNeIIJGE9rbtErn5ko8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yuko3fdzK0JoN9AS8pF574UTB6MM9Fboae3zXCEKCy8/PBMnXI+OrDSGocIU9xzKc
	 GDgDVQYNu/LcmBlF0mz/nZI4JiJCePe+nyS2Biz1UDP/EULoeiAw1LP4GSNpanVqmP
	 uoNjIfIY3ivlT5/NMbxfUJ3Wo6wMdEg9/kbg9st8=
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
Subject: [PATCH 6.1 0168/1887] smb: client: close handle after create-context parsing failure
Date: Wed, 28 Oct 2026 17:37:44 +0100
Message-ID: <20261028170503.059529566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
 fs/smb/client/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 6a75d36bc5402..c50881cf4c8d7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3204,6 +3204,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
 				 oparms->fid->lease_key, oplock, file_info, posix);
+	if (rc)
+		SMB2_close(xid, tcon, oparms->fid->persistent_fid,
+			   oparms->fid->volatile_fid);
 
 	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
 			     oparms->create_options, oparms->desired_access);
-- 
2.53.0



