Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061820;
	b=JiV7Xzph3o9XpLPGaUlqVAPTZrFKe8zpSUhQTsdcNkjWNkq/SWk8++y+ORoNZRyoI4yc
	 EA3oq07uXToaUfpP1AJ2tMaiZKpZ5nXIsecHHfqb3x5oU/ch+/JS8+ZxQuztAWF15FIAp
	 7RsKAWmR3SXHd5FofHuPktR25IeZ2Z0q2YG1jAyZX2UPZL0I/QRvb1zKUuYj9DC88vXYF
	 Ob+wMiH/8rEWySpUJfXS/6PUM/KBeEOzU3s2u6Qps0adbSHuoETBphDFPsRNPCX/ZQKkD
	 yEdsjKNMIahQEGpcQkKJK8TNA9KSm5DvJMJd76VxLeAgteUBLtVneAwFuyECo8i11yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5wW+5Y3W1xDKrmw256ivWNMTRW+pvADvUOnpLc9gUM=;
	b=we+/H9vwp5vtJ0CRz96XRB/sU7zc2f8I/kKuDKim30T6CI+nakeTRWdeBuL9CvrvWLAD
	 cBjeDTnGrKZw6kCSdNRCC7xHxPt3SfvykhKRZUOOEi9qtwjb+svmT1UQJx3cq3yH6Q7lv
	 2hjxR/WkXR9UL68rm7bGGfT6xZDniqHqxyFcSvdYgGgGb2aSznyAvV6zKkdPYzrZgHW0u
	 Dalot5mMc/kv7ihh3aOIBV2BWRpvoLuewAZ8/wUgQYNnv6y8sIS421QIFaz8orvN2l53l
	 1eNDbutJpVhPWHGTjGiyZwyyMPPJOntllA0t4c+5k1jIvYO9KNvFvcNA2KzMLBAJXIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRGFVYJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86363606A326;
	Sat,  7 Nov 2026 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRGFVYJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224DB1F0089F;
	Sat,  7 Nov 2026 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061820;
	bh=s5wW+5Y3W1xDKrmw256ivWNMTRW+pvADvUOnpLc9gUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRGFVYJOacxszQSp6fjh2WkpfgqugU3nuOFNGX+eVYroxjHj5pvbMEkM2aaKOSDhJ
	 R4pBA7m4ZlnTk0IFkjlHdNf98PI6E8WPINm9MKZ9lsuu+oktlCGh1E4+9zbZ6954RD
	 XLXExdRJ/ofASrYaGiPodGzItf3W/bUJhfexas9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zikang Gao <2715417602@qq.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0844/1536] smb: client: do not pass a NULL buf to is_oplock_break()
Date: Sat,  7 Nov 2026 08:47:40 -0500
Message-ID: <20261107135021.255655459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
[ sashal: adjusted context for direct MID callbacks and release_mid() without a server argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 4 +++-
 fs/smb/client/smb2ops.c | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 81961a54c9f1c..eace4d1a3dce7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1318,12 +1318,14 @@ cifs_demultiplex_thread(void *p)
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
index 914bee772f304..5c083c52dca01 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5290,6 +5290,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		rc = -1;
 	} else {
 		cifs_dbg(FYI, "mid found\n");
 		(*mid)->decrypted = true;
-- 
2.53.0



