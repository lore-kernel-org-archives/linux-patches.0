Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044726;
	b=vFWvmUgCTpoEjAmwxDB348Y1ZxFUrbHxxr/eUrO2hBGoeG55v2xAIEh6rwROoRVmLgVO
	 WuGq4JdFTdA1SvQHTeVzoR5C3v4vLsnriNdW1PbxWw4T8LnZdsPGvMoeqqPPs2cc+SfMK
	 lqG5KNhqW3FZlT9zoGj2B4h3unYsOSc8xLEkIzD/uOJ6VrsSLAip2yg7/TfBHkHE6fS62
	 BOumYFuvGy4lbXyBFEuUDSjto0k8cXBgM2NqzPdyPIK6wSuTnBYTh6xiLlvxca7sF5ohX
	 ajNNy66Y6L028NobpxFSL/UHQHtmDvJxDAQM2e2lqnUELj1EGDUb7KdBgdMfrHDblNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QBS7NuatB1BX4QZO30MmDKNcQ4OVoHezs/ZJUPKXsfY=;
	b=TH+xjfF2AWHfQgnRWWE7UAe5R+xPGC+9DUqWkD2kwAl5tpBMSzFPMQ231D/p1+kuYJfW
	 +hNrxK/D94sI4PN0UOBMp/NPElw+KKjx6Nu3c5LPLTFMoDjmYzWtIy5bmqqR1GX53ArD0
	 LxxIXRXy6VBEpn6L2kJnykj/ENlPI3RPkHx29tW1kvrqgylvelV3P0prs9PRm1w89ZO7T
	 j3c1/l3Cstm+YIO/2qK1UGCvEAed69KSAI1YCNrEyZMRl5JlYCL0blhbJUFscC4B2cJAp
	 O7CwJf8DdYlgpCz4UvDMar/osuXbu+Fbo09P3vUYuRMNT6MzcG+3PQUe2BmAhthKXRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMpFgTtT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F084606A31C;
	Wed, 18 Nov 2026 23:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMpFgTtT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873BE1F000C4;
	Wed, 18 Nov 2026 23:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044726;
	bh=QBS7NuatB1BX4QZO30MmDKNcQ4OVoHezs/ZJUPKXsfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMpFgTtTVeKJssozFD2ZHvZBPTfl40umsdqaZqu89YMz58nvMLwR/BPw2jnUijnbM
	 NzJJ4EczKbaRTHrr9egcZ748GevSg/pVwsLBtplFNhB3nYDotAPiJRWuS6+nIGkehm
	 9Z+mEZmNpQqp2ZsO2Fi6lmmVDGN7Pz8BQG7M946s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zikang Gao <2715417602@qq.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0668/2857] smb: client: do not pass a NULL buf to is_oplock_break()
Date: Wed, 18 Nov 2026 15:28:22 +0100
Message-ID: <20261118150225.610510178@linuxfoundation.org>
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
[ sashal: added braces around the existing NULL-MID branch to include the new assignment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 4 +++-
 fs/smb/client/smb2ops.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 157d947846d9b..f765246fa57c7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1324,12 +1324,14 @@ cifs_demultiplex_thread(void *p)
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
index 7f6c8ce168bca..17a44992667c2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5243,9 +5243,10 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_pages;
 
 	*mid = smb2_find_mid(server, buf);
-	if (*mid == NULL)
+	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
-	else {
+		rc = -1;
+	} else {
 		cifs_dbg(FYI, "mid found\n");
 		(*mid)->decrypted = true;
 		rc = handle_read_data(server, *mid, buf,
-- 
2.53.0



