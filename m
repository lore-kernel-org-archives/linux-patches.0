Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831832;
	b=sRKkc9NbCa0KIkt2Pjx+0sqAqx9oR5T/xmgT5UkiDLIpDNu0S4G0mw+QzsA/11vlxg7f
	 X5/CXGYJNXDvyxlTZH69bLZeWBlhmvcUvr9Z8uqe7y+95L+ox7qmLRObOCOLo7YB3Y9lb
	 1NasJ9i2tq1d2uWAwSBU+g+nKltfGsvOv5J3lps5cNUnOYAX768ObmgNLH010BN6a8p+P
	 UhDO+jztB0MqezQwJmtFhX5cNQaCsE2g6cbjJ2Z32ernOWA1Reb6k+7SutkrQ43H/VeJT
	 kMK4Wj/Eko3BWYILFUa5dFhmvYpAguxMMl5ilGfSXLTHrj95Uc75Pka2d81PO6MaWOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhjmAWTlr8543v3NThj2TWDmg3/wmgctIIyWkW3riwE=;
	b=XTRs86NXVDq4EkS64nTj/n5gFI5m3Mr6halpTvIHyG0EYmnwSGxeYK2BkvLIAzr75SNA
	 tb2jXRS4MwBTgt3FzvJblh8zR+tMqaw2H5POU/Cp5O3zqOHWohn7sNMi6OoQ5afWiMRzq
	 Hol3skBFYMVmvC1JzbJAv99cTZI3I+yVZWaDuMm0N2Af+W17JLkxd1Qfyh51wQtcSxw6j
	 a1PKdgRfwmf+4ms17aiN7BMyfnZ98T7H7xCFkuzV4GBzlGK0jDdZUHkElYNioEowHV5/d
	 q2xgl5wVLlHE27DfgkJFhYTF6Kox5iGlFyMfZi++93F0rpLX54e5P/UCY6gO5M7MiOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2Yqk4VY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FA6606A842;
	Wed,  4 Nov 2026 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2Yqk4VY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65701F000C1;
	Wed,  4 Nov 2026 22:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831832;
	bh=zhjmAWTlr8543v3NThj2TWDmg3/wmgctIIyWkW3riwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2Yqk4VY3oEKqcbS5+sd9RpYYMzuUUVEDZhbdMI1tnrmD5xTz0cid/j1nTtzrH/I6
	 bNRb+ZC2qxIocIEt6I7u4yEK1oul9UxthCp9WVmwnTnWmPc3TfAZUIAb5nmq8EmZS7
	 sIITy5b19RMUnRji3Y3tDzBDblqXkLndYhMRzbew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0890/1005] nfsd: dont modify a session slot when replaying its cached reply
Date: Wed,  4 Nov 2026 16:10:23 -0500
Message-ID: <20261104211108.150487156@linuxfoundation.org>
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
@@ -4661,6 +4661,7 @@ nfsd4_sequence(struct svc_rqst *rqstp, s
 		slot->sl_flags &= ~NFSD4_SLOT_CACHETHIS;
 
 	cstate->slot = slot;
+	cstate->slot_owned = true;
 	cstate->session = session;
 	cstate->clp = clp;
 
@@ -4723,7 +4724,11 @@ nfsd4_sequence_done(struct nfsd4_compoun
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
@@ -188,6 +188,7 @@ struct nfsd4_compound_state {
 	struct nfsd4_slot	*slot;
 	int			data_offset;
 	bool                    spo_must_allowed;
+	bool			slot_owned;
 	size_t			iovlen;
 	u32			minorversion;
 	__be32			status;


