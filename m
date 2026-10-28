Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212152;
	b=4aN3St9eAMTZsw/c+ONrYZtaBE/mBvJrk59Yzhcdj5L+zzpy+Kx4KoqFebi1CuGr67IY
	 9rSEbILq25U6zoZ17HtcW/zyH0tGUxUKr51M/Vly6IJ7X7PlKI1B1Mf5eN5hluCAKRXQz
	 xwTCtaHyLpK2GaBYyffAduuaQQOdznT5UQlEBmizQdpRX3pSnHjfccPtahcB8qN3z+TWY
	 cUkrdiVVWkCp7LjX0i4a7WvgbfUxFxJ9Nn7eMlCqJHdWe37DRe24QK/u/ZEGF07ekFDKk
	 sS+MW/KfwRUYTpksmGXVzaJww8TJ3UlJDg9fjhli/VMw95GiQed08tXNMayR4IqMvTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ETBRbh4Wfh262JDlarSRvobZgSTN6vvRFPN8O1OZpxs=;
	b=bS9ELnUaJ+6WJDYqR1dUQjAC3tQGPFV9BVeYVoFPPEOgbPwPkG2uV1RwGJDdzT/vcxtM
	 G7fj//cHAIH5IkV6VSaDxHneZYuYaW+P4t9wo+dDUToXOYyzpjt6aJM7vPoTvTfQfWg3l
	 I/eLvrovDquS0/SFgAtuz+e8GJ2KR4XD18LSi4DihnvoVxtpB2dJmHjKNnmy6s5l/tvnK
	 GVuOSdQFxwHbSyx+3CQpWoVStkpOUDtM+qT9cqsrTV73I/bTIXZbXXt12j+QF/UocgYpp
	 bj7tIcvLUN7sZMnQ3TIcWqCm8hjTjaaTyL+Pn7vVm0K+UzBkXHepllB6ik1WOZCVMNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rmdDfQCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FC7606A32D;
	Wed, 28 Oct 2026 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rmdDfQCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C3E1F031E2;
	Wed, 28 Oct 2026 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212152;
	bh=ETBRbh4Wfh262JDlarSRvobZgSTN6vvRFPN8O1OZpxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rmdDfQCcQSQXaGUk1+G0lYjOQfwa6yqpeW6waD5T5Bin5LoRjl+ssIC/6B7zllieV
	 t/qzsuYVG8LC3nWzUYiyfzbgupHyqQgA4CUcbAnEPFzF8ogiB7VyttJdaKhh9j+eMb
	 FqzTZSW5l/6fXqceKtiODP4rFh1iwWfRX2nTGWvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0054/1887] smb: client: fix use-after-free of iface in cifs_try_adding_channels()
Date: Wed, 28 Oct 2026 17:35:50 +0100
Message-ID: <20261028170500.457054570@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit d034e836eefd7ce75e588f7031cffbeec594f5ac ]

cifs_try_adding_channels() iterates ses->iface_list with
list_for_each_entry_safe_from(), which captures the next entry
(niface) under iface_lock.  The loop body then drops iface_lock for
the whole duration of cifs_ses_add_channel().

A concurrent interface refresh (SMB3_request_interfaces() ->
parse_server_interfaces()) marks all ifaces inactive and removes and
frees any that are not re-advertised via list_del() + kref_put(),
where release_iface() is a bare kfree().  Since niface typically has
no channel holding a reference, the list reference is its last and it
can be freed inside the unlocked window.  On continue, the iterator
advance step then dereferences niface->iface_head.next, and the loop
body reads iface->rdma_capable/is_active, both on freed memory.

Fix this by never keeping an unreferenced list pointer across the
unlocked window.  Each channel attempt now re-scans the list from the
head under iface_lock, takes a kref on the selected candidate, and
passes only that referenced candidate to cifs_ses_add_channel().
weight_fulfilled still tracks selection progress, so restarting the
scan preserves the original weighted distribution and the
weight_fulfilled-before-kref_put ordering on the failure path.

Add a per-pass attempts cap so a flapping interface refresh cannot
keep the inner loop spinning within a single tries increment.

Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked list")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Acked-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ adapted calls to retain the cifs_sb argument and use cifs_dbg(VFS, ...) instead of cifs_info(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 106 ++++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 42 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index ffeb3e7d34d5c..1f1043e47c5cf 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -163,9 +163,9 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	int old_chan_count, new_chan_count;
 	int left;
 	int rc = 0;
-	int tries = 0;
+	int tries = 0, attempts;
 	size_t iface_weight = 0, iface_min_speed = 0;
-	struct cifs_server_iface *iface = NULL, *niface = NULL;
+	struct cifs_server_iface *iface = NULL, *candidate = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 
 	spin_lock(&ses->chan_lock);
@@ -211,67 +211,89 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 			break;
 		}
 
-		if (!iface)
-			iface = list_first_entry(&ses->iface_list, struct cifs_server_iface,
-						 iface_head);
 		last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 					     iface_head);
 		iface_min_speed = last_iface->speed;
+		spin_unlock(&ses->iface_lock);
 
-		list_for_each_entry_safe_from(iface, niface, &ses->iface_list,
-				    iface_head) {
-			/* do not mix rdma and non-rdma interfaces */
-			if (iface->rdma_capable != ses->server->rdma)
-				continue;
-
-			/* skip ifaces that are unusable */
-			if (!iface->is_active ||
-			    (is_ses_using_iface(ses, iface) &&
-			     !iface->rss_capable))
-				continue;
+		attempts = 0;
+		while (left > 0) {
+			spin_lock(&ses->iface_lock);
 
-			/* check if we already allocated enough channels */
-			iface_weight = iface->speed / iface_min_speed;
+			/*
+			 * iface_lock must be dropped while opening a channel,
+			 * and a concurrent interface refresh may remove and
+			 * free entries during that window, so no list entry
+			 * may be kept across it without a reference.  Scan
+			 * the list from the beginning each time and only pass
+			 * a referenced candidate to cifs_ses_add_channel();
+			 * weight_fulfilled tracks the progress so that no
+			 * iface is selected beyond its weight.
+			 */
+			candidate = NULL;
+			list_for_each_entry(iface, &ses->iface_list, iface_head) {
+				/* do not mix rdma and non-rdma interfaces */
+				if (iface->rdma_capable != ses->server->rdma)
+					continue;
+
+				/* skip ifaces that are unusable */
+				if (!iface->is_active ||
+				    (is_ses_using_iface(ses, iface) &&
+				     !iface->rss_capable))
+					continue;
+
+				/* check if we already allocated enough channels */
+				iface_weight = iface->speed / iface_min_speed;
+
+				if (iface->weight_fulfilled >= iface_weight)
+					continue;
+
+				/* take ref before unlock */
+				kref_get(&iface->refcount);
+				candidate = iface;
+				break;
+			}
 
-			if (iface->weight_fulfilled >= iface_weight)
-				continue;
+			if (!candidate) {
+				/* no usable iface. reset weight_fulfilled and start over */
+				list_for_each_entry(iface, &ses->iface_list, iface_head)
+					iface->weight_fulfilled = 0;
+				spin_unlock(&ses->iface_lock);
+				break;
+			}
 
-			/* take ref before unlock */
-			kref_get(&iface->refcount);
+			attempts++;
+			if (attempts > 3 * ses->chan_max) {
+				kref_put(&candidate->refcount, release_iface);
+				spin_unlock(&ses->iface_lock);
+				break;
+			}
 
 			spin_unlock(&ses->iface_lock);
-			rc = cifs_ses_add_channel(cifs_sb, ses, iface);
+			rc = cifs_ses_add_channel(cifs_sb, ses, candidate);
 			spin_lock(&ses->iface_lock);
 
 			if (rc) {
 				cifs_dbg(VFS, "failed to open extra channel on iface:%pIS rc=%d\n",
-					 &iface->sockaddr,
+					 &candidate->sockaddr,
 					 rc);
 				/* failure to add chan should increase weight */
-				iface->weight_fulfilled++;
-				kref_put(&iface->refcount, release_iface);
+				candidate->weight_fulfilled++;
+				kref_put(&candidate->refcount, release_iface);
+				spin_unlock(&ses->iface_lock);
 				continue;
 			}
 
-			iface->num_channels++;
-			iface->weight_fulfilled++;
+			candidate->num_channels++;
+			candidate->weight_fulfilled++;
 			cifs_dbg(VFS, "successfully opened new channel on iface:%pIS\n",
-				 &iface->sockaddr);
-			break;
-		}
-
-		/* reached end of list. reset weight_fulfilled and start over */
-		if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
-			list_for_each_entry(iface, &ses->iface_list, iface_head)
-				iface->weight_fulfilled = 0;
+				 &candidate->sockaddr);
 			spin_unlock(&ses->iface_lock);
-			iface = NULL;
-			continue;
-		}
-		spin_unlock(&ses->iface_lock);
 
-		left--;
-		new_chan_count++;
+			left--;
+			new_chan_count++;
+			break;
+		}
 	}
 
 	return new_chan_count - old_chan_count;
-- 
2.53.0



