Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044553;
	b=4QTqxNTRFSj6yaanNgDFkmf8N4zZoFCwgpU9GYVVCvOQQwzyFI+W5g+zugZFg3FWnRaC
	 FkXZrMpPK3KJl/clKRBVUfcv2In0tcr5gwsv82r2nZVhDfOJ45GxPw2+AzP/uwYYvCeY3
	 xfYaOs22GA9QiRjWts76jtjnbCJx3QDzkQ4JAFSdhsiXc44W/p1k9rldUE1urnRM4mXf7
	 rXWIh0Vyh8GkR6ZvOw3E0rZrU298OcXc5QncVZUgxUyB8Tg0IwgxqWJvEQeabFg8XqNAF
	 ZxSvY9E8I/s5VH8kcVUmACWXCqhGu0XoKvRqsaOKAlC5E5I2NKaC4AhDw8dSoPl6e0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H5UO4VyqeBalffGbENqtr6TKWQ8P2LePSn3Hx3ka7hE=;
	b=eR21SDI3NBt2XvY3VTb6ad+q5EbucIN7KPkLJMgtDrfTIZja3FYg66koLyeCysEem4WO
	 1Flzl+mfSb4MGHoism8VudhkL+Ph2EXXUJVNLaWGj8HZqi72cEExsT+ZlFXVSAxj4q4TF
	 VEl3N+kn/Kr6/Hma3aEkm7UtPvwNwpS8IKkFm5VMMCMyL4oAWa678U1MJSrQFBL14a+xV
	 A0Cszhgl+vG2RAJfb1cpt8sUI3bBygcfxDMZ78YyYCTk37+HKxvqkLDXKNnOGLhAumUgH
	 0GXz+tMzQFnkyCVt5Vfh/mLsxKaFNO54JL8Y7q6SdgesXWDPTOBsSACoGk+/hLeMZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHuHiUPy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCAA606A31C;
	Wed, 18 Nov 2026 23:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHuHiUPy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F511F000C4;
	Wed, 18 Nov 2026 23:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044553;
	bh=H5UO4VyqeBalffGbENqtr6TKWQ8P2LePSn3Hx3ka7hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHuHiUPytwczykC0htvibfS6P9hJh1KuDfFf9KDUHLakD8P7HNLxjHGy1480/T7FW
	 uaauBFd7q7qv6xp2jvZSb3NVUTf4rHiviFL3C7DZAOjWM8fwvzHd9rAQiQIK1rrAoy
	 FTPF6YN5i4UFAfs1+aWmNDaShH8kQAp5+v9HUOcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0607/2857] nfsd: dont modify a session slot when replaying its cached reply
Date: Wed, 18 Nov 2026 15:27:21 +0100
Message-ID: <20261118150223.345414499@linuxfoundation.org>
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

From: Ameer Hamza <ameer.hamza@truenas.com>

commit 2987838317501ff67b672ac2a441fe34b7729f3d upstream.

nfsd4_sequence() claims a session slot by setting NFSD4_SLOT_INUSE
under nn->client_lock. A reply served from the slot's reply cache does
not claim it, and that distinction lived only in cstate->status, which
nfsd4_sequence() set to nfserr_replay_cache. Commit cc028a10a48c
("NFSD: Hoist status code encoding into XDR encoder functions") moved
nfsd4_proc_compound()'s cstate->status assignment below the out:
label, and the replay path's goto out was the one path that relied on
skipping it. The test in nfsd4_sequence_done() therefore no longer
identifies a replay, and every replay now stores its reply and clears
NFSD4_SLOT_INUSE as though it owned the slot.

NFSD4_SLOT_INUSE is the interlock: check_slot_seqid() rejects every
sequence id for a slot that is in use, before replay_matches_cache()
runs. A replay never sets it, so two replays can be in flight on the
same slot at once. One can read slot->sl_cred under nn->client_lock
while the other's completion frees and rebuilds it from the XDR
encoder without that lock. Two completions can also collide with each
other and release the same group_info twice. free_svc_cred() leaves
cr_uid, cr_gid and cr_flavor intact, so the reader passes every
earlier test in same_creds() and dereferences a NULL cr_group_info.
>From a 6.12.91 production server:

  BUG: kernel NULL pointer dereference, address: 0000000000000004
  CPU: 63 UID: 0 PID: 39015 Comm: nfsd
  RIP: 0010:same_creds+0x38/0xa0 [nfsd]
  RDX: 0000000000000000
  Call Trace:
   nfsd4_sequence+0x6a8/0x910 [nfsd]
   nfsd4_proc_compound+0x345/0x670 [nfsd]
   nfsd_dispatch+0x100/0x220 [nfsd]
   svc_process_common+0x311/0x700 [sunrpc]
   svc_process+0x131/0x1c0 [sunrpc]
   svc_recv+0x7ef/0x9c0 [sunrpc]
   nfsd+0xa3/0x100 [nfsd]
  Kernel panic - not syncing: Fatal exception

Since v6.14 a live session's slot table can shrink, and the unowned
store becomes a use-after-free write. nfsd4_sequence() defers the
shrink while a slot is in use, but it tests NFSD4_SLOT_INUSE, which a
replay does not set, so free_session_slots() can kfree() the slot the
replay still holds in cstate->slot.

Record the claim in cstate->slot_owned when nfsd4_sequence() accepts a
request and test that in nfsd4_sequence_done(), so only the request
that claimed the slot updates its cached reply and clears
NFSD4_SLOT_INUSE. svc_generic_init_request() zeroes the compound
response before each request, so the flag starts clear.

Fixes: cc028a10a48c ("NFSD: Hoist status code encoding into XDR encoder functions")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ameer Hamza <ameer.hamza@truenas.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260824173641.3274260-1-ameer.hamza@truenas.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    7 ++++++-
 fs/nfsd/xdr4.h      |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4158,6 +4158,7 @@ nfsd4_sequence(struct svc_rqst *rqstp, s
 		slot->sl_flags &= ~NFSD4_SLOT_CACHETHIS;
 
 	cstate->slot = slot;
+	cstate->slot_owned = true;
 	cstate->session = session;
 	cstate->clp = clp;
 
@@ -4190,7 +4191,11 @@ nfsd4_sequence_done(struct nfsd4_compoun
 	struct nfsd4_compound_state *cs = &resp->cstate;
 
 	if (nfsd4_has_session(cs)) {
-		if (cs->status != nfserr_replay_cache) {
+		/*
+		 * Only the request that claimed the slot may update its
+		 * cached reply and clear NFSD4_SLOT_INUSE.
+		 */
+		if (cs->slot_owned) {
 			nfsd4_store_cache_entry(resp);
 			cs->slot->sl_flags &= ~NFSD4_SLOT_INUSE;
 		}
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -60,6 +60,7 @@ struct nfsd4_compound_state {
 	struct nfsd4_slot	*slot;
 	int			data_offset;
 	bool                    spo_must_allowed;
+	bool			slot_owned;
 	size_t			iovlen;
 	u32			minorversion;
 	__be32			status;


