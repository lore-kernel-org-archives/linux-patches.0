Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831936;
	b=g3vnGfDCxPIzFbt4ASFY0DyDkAK65ihy88iwv7RKM0YRaZUZNuMeGn6VD3Jy0w/YTPei
	 Plc7OsW9jGDbH/a+seHpPuYXL4Y8wzGANH3SXi8tEi4+e41sY772KooYGiJDNW6pYRdf5
	 156nt+di78to2W9LdL2WVQ6pD73DY7loGu2N9qRgySKARU0QxWWqqx6wcYWrumhqPffVw
	 qwehEChlZy89MiwmnMwHuVM0pgPD2N69zzWhC5+FaVNc35uyS1P94+QMKjZ5ln2958Btd
	 fNfCJ/OFo2Q13Q8l7oMrV9ZppoB6vVVrFVkfC8Xa931tIpgTTqyUYi3ZrBZirGrQeKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0xZ78QHlNrGPrYTmUysK/WGIlOS7DCqotoQoh7/jRo=;
	b=mjRVYQqHVntkr/8urM45LmrdxlsFsmlDDv94Wl0I05h21ykWQd4Yj+aTHz3dAlzlrG94
	 DEKt+S+FG6owACK512jZNgYpIueHrsMXX9yVx0+FJw5PzEYiGaCjbpCZU/T7HcrPsZ/mh
	 sKgMZBvKjKUEkH44D7mjZEMYGuH/LRrLq1NbOzfJO7hq0Tl89seBaabKj3NjjzlvD7Rnt
	 jSWoy0LA30c8E3oOolf1viRvOpLooT2Q+GtleQmSYCYzeO41oHwNw9k7PVJijjp+dGX9z
	 ks0BUTBITvDHeb1VXhzc3O+NFuHGpDuC9CgtaY8a5JMJuEAOkZ7+xsamPn5AJtaqT8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyC2Ah8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2ED606A328;
	Wed,  4 Nov 2026 22:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyC2Ah8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6754E1F000C1;
	Wed,  4 Nov 2026 22:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831935;
	bh=I0xZ78QHlNrGPrYTmUysK/WGIlOS7DCqotoQoh7/jRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyC2Ah8FaiNa77bFHFv74izY+3Lw2pNKasl5uc28k2gq3bi/5h5F7VtUIah1/xP9f
	 DZb4GW2kFSGWkuhcLt8MIDAvdt6XlTW+RfhKXmmVnliFvPoJ6gaJ7Zz8mOwa6mSjp8
	 aD73iRwxbPTZ6HmLQDNHLVmbVZUWeBX8isOPOzKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zikang Gao <2715417602@qq.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0982/1005] smb: client: do not pass a NULL buf to is_oplock_break()
Date: Wed,  4 Nov 2026 16:11:55 -0500
Message-ID: <20261104211110.553210933@linuxfoundation.org>
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
[ sashal: Adjusted context to retain the existing one-argument mid_execute_callback() and release_mid() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c | 4 +++-
 fs/smb/client/smb2ops.c | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e908d522920c8..ca71026799e0c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1400,12 +1400,14 @@ cifs_demultiplex_thread(void *p)
 					mid_execute_callback(mids[i]);
 
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
index 5ad3804826d9a..702e32e0e51ad 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5357,6 +5357,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		rc = -1;
 	} else {
 		cifs_dbg(FYI, "mid found\n");
 		(*mid)->decrypted = true;
-- 
2.53.0



