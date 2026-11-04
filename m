Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826927;
	b=5YcoJ9/ToBMjv6Z/NS13QetyeNv0dNY0AiuTYEEB3/qY1AzSAwjbgvfLjY2GRRVtb7MV
	 nxi3w1XYac1JcnyzSXeiZI/rCt4C0kscDesJ3PN6NRxR0f2tGsgznGlpBrhWRtNxe+Bg6
	 9c3+gAuwfNgGR1pHpS7K1FEyfoeOChus6AgTd/9jmpT917AjtWhiTG4uX+LFFwVkyAqzY
	 VUmc6FmIi2b330Vfl+jIhRtQs0xOx1Fx4s+2IbMM9sf+ffnEM1NH4i3Avz75Pj5UvtwcR
	 sAsxVSevzUIDSJTuTIZw9Z79+oRWPFUP2ZuvMAt7HijnBttwM/NfjXpO1vQhXO/oRpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oNXEP/NNuXzMrNZAUqy0PEyOBuHduxOr08e63yzLBAg=;
	b=QOrdKdzgm1izWl2mtVXnuqNauEGS1IcPzywmdWTJ+W3ZWaAKAvOUvY96ZdrqYdbM4xN4
	 frfr2hmxVFamgqh2NABrrs/SuDoAQtVWqbUb7osnc/WX6WgZ8iGtO84oMRhXUXRgEkAk7
	 VmwQvnfdsqk/LpsaFMDiXxutr7xZ27AkdnfYc5MYiss5nPckMH5+QjnxERzT91f/Jxaqo
	 1yKAbtpdqgoy+haZKbksm3lr8ZQ19dmr7GDpHHursf2Wpoq24V0D3pvUwuAbBVQOnnrrA
	 vXWJzjEU5mMg8KFfOluyBpdZNyMeB8+BJooy0Xcg5CaOznf6BrP6RITkjaAI/uK44mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8md6R0I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551686072FA1;
	Wed,  4 Nov 2026 21:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8md6R0I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BE11F0093A;
	Wed,  4 Nov 2026 21:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826927;
	bh=oNXEP/NNuXzMrNZAUqy0PEyOBuHduxOr08e63yzLBAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8md6R0IkE2u4m+wl9eFfj6TKakUQEaAIzOG1xwansNqUUNgLYDzgQXVNJkkHkPxw
	 8gvSXwjsOgQgQDpNVX84o1bUSjBKhhHHtRKrIq5YsLkrM7RyvnW9sX+v0+j+vWL7yn
	 WN4v4ck/3WXbghUUvnlFUaXBBhAyD4y54KVK9Icg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zikang Gao <2715417602@qq.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 089/547] smb: client: do not pass a NULL buf to is_oplock_break()
Date: Wed,  4 Nov 2026 16:04:33 -0500
Message-ID: <20261104211040.757235438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Zikang Gao <2715417602@qq.com>

commit 2225ab306575e424b3dad2ee1be2521c89249d15 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    4 +++-
 fs/smb/client/smb2ops.c |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1401,12 +1401,14 @@ next_pdu:
 					mid_execute_callback(server, mids[i]);
 
 				release_mid(server, mids[i]);
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
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5397,6 +5397,7 @@ receive_encrypted_read(struct TCP_Server
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		rc = -1;
 	} else {
 		cifs_dbg(FYI, "mid found\n");
 		(*mid)->decrypted = true;


