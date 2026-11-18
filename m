Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057981;
	b=efFZPT5T/fcU5KKgqH6X4ZGI/qJKjzU+CjNEAH1pm3uOvK623jIRk6KBwgBAnv+vqlNs
	 hXCkyi7s7ofbg17NgohkMQNwIbqoKD8EC4DdvEIIx2UPlokw4b3Faw9XyGWAvL7NxLCz9
	 Q0lIoavsillr92iHmNPpdOwAQiS4rMcuwRE6Qf/rJQjX2OQnkr7tAP8TtnwMcabK33DOC
	 HWYsn/qxLSaXPgCvcvcQnP4dR3bRrPn4MgIoZyXrIzSXLptT6eGV610ldafa4+r+0XyOf
	 nMCZootCcFS/QqYMIZKoNltD74c7ok0gHx1iKfLE76p+AVotKf0L40qYbzMv9Z2P4PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6t7iSCWLF1tOWNhDNH8RyeL5TGll3nVDmPCSVznVgQ=;
	b=t238oLrsEvzQqxn959wMbj7Ych35opx55iF9M2u0XRLvTmuSSgUi7nh9D3id+Yl3DYui
	 kZMc1tCXjD9XfU+WOESFD32kEh7IHrIkzIp5PTiTZ+Bvxfcy48QDQsecPxtQ+Qz5yucE9
	 mr074Xluui6nipEDxnfbe+s3yt0Q+JPWvuY/Dw0nXbGtNlPDbiugJlv6UZFwSJts9JaIK
	 anvxn9TKAMpCsgFS/ytI4Yon535cgfoXoK9DHsKmEcP9vvPeHWxoj//7MRCMDg1rEX/mM
	 zVnfX6k0xBKFuDH+VUuD7Rw5p+gakpjn9milGvsfo8CA9wiYNrQchpDTThY50qM1YVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvxYd5Kc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CB0606A325;
	Thu, 19 Nov 2026 03:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvxYd5Kc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924371F000C4;
	Thu, 19 Nov 2026 03:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057980;
	bh=q6t7iSCWLF1tOWNhDNH8RyeL5TGll3nVDmPCSVznVgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvxYd5KchwjG9oOAGZ9Blka3ujFKpG7hCyVWOWf5RGjCNxG9QIdr9GV35iPcNNI9y
	 HL5t+OXf42RFRvWzimzsKtrLIL8iYlqvLcf87w8fj+kGoHldeQwpx8Ol4+mOZNSY+7
	 Pit9Ui9vKGqnHrxLcujukTBRYyYjf6Wxzt7UoVJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zikang Gao <2715417602@qq.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0324/1848] smb: client: do not pass a NULL buf to is_oplock_break()
Date: Wed, 18 Nov 2026 15:39:22 +0100
Message-ID: <20261118145925.702595117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
[ sashal: added braces around the previously unbraced mid-not-found branch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 4 +++-
 fs/cifs/smb2ops.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index db54cbbe8cc5e..6ff0eab0be81a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1191,12 +1191,14 @@ cifs_demultiplex_thread(void *p)
 					mids[i]->callback(mids[i]);
 
 				cifs_mid_q_entry_release(mids[i]);
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
 						atomic_read(&midCount));
 				cifs_dump_mem("Received Data is: ", bufs[i],
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0e95065ae0767..2fe90bcc44b84 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4946,9 +4946,10 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
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



