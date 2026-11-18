Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035589;
	b=B0+DG2IpmZfTXUZrvrh9bVe/S7sUW0ai4Etde0/dsK4E+e5u/4mbNI+Jnt+AKjkIyIlJ
	 zr0PM8y5hzkGPW4hfvgcG67NQiSGC8QUGsIJkvB5s8UfubuB4ncDWyO9TEqfKPk5IPDDJ
	 QaW3EpZ+i5N8+Iy2od76sRNw/IEsT79mpbKg6+ed8F0ZK2btZjhUxzIGIVBJhPPURClUi
	 q4LjSPRYMFYAqEdwxyECrGv4UCFXS/E+y+xr/mk9MGlZpV+NSogSzwokVKGn4KZgqsrCA
	 MCRwrno4oGrG5XbkvgJX5OpJQEAIDjHoCzJZAz8HvQ4qborOhv7DLakK6D3L8YR2v1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/YB0hthXBSd9Y4L3oFVockyznquRzFs969aaVz9LyWI=;
	b=MOPJTAGEg3laBR9cLcLLFDjoZ64bQtuKb23g5VSHl4KdYgSihsKp5fiPmrEzpDdWnGav
	 edGbqtqHdmjA11rff/sBXyH0UPHDoQXTvaP7pmmgXTOmbjeLnb1UiDtx/Jkc1l9XslWnT
	 qYhn5uKN51Fprtx8pD4Pqn0Mf0UnwOdRfHIgRHVA6GtgRSexwfabxeYZx2wKlCYUGusM6
	 73gSp65Atvl87avAkxeyjPgm0DThv06AHTTlDMvRCFSftpqqjhzA4/OxgglfrUPkyD6cP
	 3jVPt5i7WCW9KmbQjNz94TlTq0l9NCntyJGJzjJR6k2UgSbewsOqVBzzrMR7nXHlr3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jW1nFXDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1175606A31C;
	Wed, 18 Nov 2026 20:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jW1nFXDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139E81F000C4;
	Wed, 18 Nov 2026 20:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035589;
	bh=/YB0hthXBSd9Y4L3oFVockyznquRzFs969aaVz9LyWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jW1nFXDULznQ3D/XP3c3LayaQSd62N7oC1QuRPm15hliiKlbnHulmF/aFwTmLznF4
	 sFNYibZb4PzioYWPpzJVPJCYlGfnWv50p2JD9V/BmzJzdZKlJpHpbhf+Sodaa1W2QM
	 S8QmJVTjRo7dmEEXsf1k1S18LmvE6ozFu3yC8zk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zikang Gao <2715417602@qq.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0759/3318] smb: client: do not pass a NULL buf to is_oplock_break()
Date: Wed, 18 Nov 2026 15:23:01 +0100
Message-ID: <20261118150341.464721561@linuxfoundation.org>
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

From: Zikang Gao <2715417602@qq.com>

[ Upstream commit 2225ab306575e424b3dad2ee1be2521c89249d15 ]

receive_encrypted_read() sets *num_mids = 1 and never writes the
caller's bufs[]. Offload returns -1 with *num_mids = 0, so the
demultiplex thread skips the frame. The inline decrypt path
returns 0 even when smb2_find_mid() fails.

cifs_demultiplex_thread() then treats mids[i] == NULL as an
oplock break and calls is_oplock_break(bufs[i], server) with
bufs[i] still NULL. smb2_is_valid_oplock_break() reads
hdr.Command at offset 12 and oopses.

A large encrypted READ whose MessageId does not match is enough
to panic cifsd.

    Oops: general protection fault, probably for non-canonical address
    0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
    KASAN: null-ptr-deref in range
    [0x0000000000000008-0x000000000000000f]
    CPU: 0 PID: 100 Comm: cifsd
    RIP: smb2_is_valid_oplock_break+0xc8/0x2270 [cifs]
    cifs_demultiplex_thread
    Kernel panic - not syncing: Fatal exception

Return -1 when inline decrypt finds no mid, and skip
is_oplock_break() plus the unknown-frame dump when bufs[i]
is NULL. receive_encrypted_standard() already assigns
bufs[*num_mids].

Fixes: c42a6abe3012 ("CIFS: Add capability to decrypt big read responses")
Assisted-by: LLM
Signed-off-by: Zikang Gao <2715417602@qq.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
[ sashal: adjusted context for older MID callback and release APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 4 +++-
 fs/smb/client/smb2ops.c | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 3d0fd8bf8f352..57cecef0fc073 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1335,12 +1335,14 @@ cifs_demultiplex_thread(void *p)
 					mids[i]->callback(mids[i]);
 
 				release_mid(mids[i]);
-			} else if (server->ops->is_oplock_break &&
+			} else if (bufs[i] && server->ops->is_oplock_break &&
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
 				smb2_add_credits_from_hdr(bufs[i], server);
 				cifs_dbg(FYI, "Received oplock break\n");
 			} else {
+				if (!bufs[i])
+					continue;
 				cifs_server_dbg(VFS, "No task to wake, unknown frame received! NumMids %d\n",
 						atomic_read(&mid_count));
 				cifs_dump_mem("Received Data is: ", bufs[i],
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 336f1f77a4f58..8ba99ac5b9a3f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5051,6 +5051,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		rc = -1;
 	} else {
 		cifs_dbg(FYI, "mid found\n");
 		(*mid)->decrypted = true;
-- 
2.53.0



