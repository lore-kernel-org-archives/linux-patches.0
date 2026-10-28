Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213297;
	b=49DQ9Pt1Op79226DcSp4TXt4iR5WDz9Awgl3E4vEoJOwGSnwJEy/ZMCNcK+scVL9x+GS
	 NK7s70ngwo9f7o2cpOHLXeuYwW3PlvU4dDDHXtN9U4M9FbM8zJpBGEIGWY6fzQWj+c9/B
	 VxUiwsVQE8SwZeil++UcWoaqeXPPgwOgBHOId3HlU3K2g7d3k8ydhHDM8ARZmk1eXKv4j
	 yCOLXfohwAiY26kHdNKDa/AaIeRXQj/3FvEW/b270bHZwbI6PLDVPDzBmYF3YR3Wl6pX6
	 80802bPrbivHT+NrzcKpnNWJmcFYl2IlaO7GltSakcGdOn5KkMapc7Ga02n4Wt/2i+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zp274jS1BS3uyb+MU91tUNeeaoMjxmhQkoIVJfdTIuE=;
	b=snGWw//ix4XPhuqQ5JLqfCPuRlzKRB+pYqUKF/nYpADj5urhAuXWzm2Jlmevng4s6CY7
	 8CAIWhE8vW7b9+bHMjYvxhnUo4Xtr9CG0BdIh9xlGqxL+JSJWA80MIrpKhzw/zcgonmtW
	 sPSxCfNexebjQMSJYDYCfgnp24joMW9/24fY0wlB6/8w2yNk6tk6qITiBQWzsdTPMPr1g
	 +QrfaIwe7aLe1Ka6yAIKScCXaxt8Uc0OBjQr9TSC5JDz/4Acm37En4oFmOstZ1URsiDDL
	 rLN/A3PhZrAfXE+pp91iO7O0gRT8Jp3LvIVg0GtKCq/OS6pz7wlpWeMa9ZKbmd5y9dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtCp7vfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33343606A31C;
	Wed, 28 Oct 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtCp7vfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A321F01825;
	Wed, 28 Oct 2026 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213297;
	bh=zp274jS1BS3uyb+MU91tUNeeaoMjxmhQkoIVJfdTIuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtCp7vfVGj1FRbaTyGLBB/kQDAOJWTpPGcWkJL0uLWaSXVcJghGz/AxHawUkr1Y3k
	 1o+ca8/rnIv4EmTGUerMeYgOVRgmwQX+79k1v3GqM9id0uquM/LTuSmuetEKZ02mae
	 vP/s2PvWNTxfj+H4LB/4ym1isihUe5GrC6YIiv7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Xinmeng <1564938642@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0456/1887] dm-snap: reject the transient exception store for snapshot-merge
Date: Wed, 28 Oct 2026 17:42:32 +0100
Message-ID: <20261028170509.608836218@linuxfoundation.org>
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

From: Ma Xinmeng <1564938642@qq.com>

commit fcbde6227fcc53c73f08c56b2539e462d545cac6 upstream.

snapshot_merge_next_chunks() calls s->store->type->prepare_merge() without
checking it. The transient store ("N") implements neither prepare_merge nor
commit_merge, and snapshot_ctr() validates those callbacks only on the handover
path (__validate_exception_handover()), so a directly constructed snapshot-merge
calls a NULL prepare_merge on resume:

  snapshot_merge_resume -> snapshot_merge_next_chunks -> prepare_merge(...)

commit_merge() is NULL for the same reason. Userspace only issues documented
device-mapper ioctls (CAP_SYS_ADMIN); this is a misconfiguration the kernel must
reject rather than oops on.

Reject the combination in snapshot_ctr() at table-load time (-EINVAL), the same
check the handover path already performs; this also covers the commit_merge()
call site, which a guard local to the prepare_merge call would miss.

Tested on Linux v6.6.157 KASAN: unpatched, the dmsetup reproducer oopses in
snapshot_merge_next_chunks(); with this patch, the table load fails with -EINVAL
and no oops. Also present on v6.6.145; still present on the linux-dm tree
(555f3d7be91a) and on torvalds/linux master (62f4c998b297) as of 2026-09-22.

Note that this is not a security bug because only root can trigger it.

Signed-off-by: Ma Xinmeng <1564938642@qq.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1306,6 +1306,20 @@ static int snapshot_ctr(struct dm_target
 		goto bad_store;
 	}
 
+	/*
+	 * snapshot-merge requires the optional prepare_merge/commit_merge
+	 * callbacks; the transient exception store does not implement them.
+	 * The handover path checks this in __validate_exception_handover(),
+	 * but a directly constructed snapshot-merge never goes through it.
+	 */
+	if (dm_target_is_snapshot_merge(ti) &&
+	    (!s->store->type->prepare_merge ||
+	     !s->store->type->commit_merge)) {
+		ti->error = "Snapshot exception store does not support snapshot-merge.";
+		r = -EINVAL;
+		goto bad_hash_tables;
+	}
+
 	argv += args_used;
 	argc -= args_used;
 


