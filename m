Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043776;
	b=OHJk28OafooIpo0GL2HAjI75VEyGKykxylhzvGkC7vdNpdO0ZEKcPFGg1b0WuDk0KQfo
	 A+XalkgSyR9u+jqE5CBC+akrWDmXBP+VdthHXZJXZLcv/ILkRxknIlO7HgMCtg39cNvze
	 CLzWxDkrNVSa2EVRjUJ5hEStRYg6XHNbvA8SnAs+JwXGEPV4VBbCYAGSx+El3lc+80wq/
	 i/K5VXkR6DTSGP6IrS6vI4YH2yBU/9LlNdpzfZjW/h7NZXwJgMvq2vGpWBPZ1wRf+H/My
	 MJzsiMbZOjCpuLW0M1vbzWwt5U1cUkx/G3YYWCAhCSIbyGMUbe9f8t5skwUz28xYPZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ni5v+i5OFHGg9hnu+hh0HzfT0wwuxEG9sB8PLcDDV68=;
	b=NA5Cn7A++4/Duj3E9yiyX7b4rJFEIqIaNAFlDlDycqoFcbBjIcu1bzRfMwIdnmmnrH94
	 FynkG4jwpVglCuqp7cjcSPbzLqlWFe++DkSxAU5ZpYISBZyPKpxLnJ46YNDyvveHUNiky
	 KIbNG6XLjre60NLFD8HxeLxAnig2WSm5tFiWlZUOGjgcqcFHaBKnbPEgOHodne6n0xeiT
	 BksWqQTMGimlvn2Ijf1y6vtfClNECodlmfjm3rbN16AU0tgezcWBOGrqBJ08952HI25b5
	 /qDmgHymmfXXIGstGM2AV/lC2H732yTMvHTMXR0nQ8N2rEDKn6VmaX48rMGks0cNVPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rfv84DAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD78606A31C;
	Wed, 18 Nov 2026 23:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rfv84DAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCF91F000C4;
	Wed, 18 Nov 2026 23:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043776;
	bh=Ni5v+i5OFHGg9hnu+hh0HzfT0wwuxEG9sB8PLcDDV68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rfv84DAmy9ZyNFwqUqH5d9oDkPRPnH9W3P/vtBJcaItoaJPGLX05Os/6F0CaUJKGd
	 ELzzkc/ywJckcUHtzRwPL3qW7k5MfEC8HmDtqFlb8JqyvwhksL/r6N4MBqen8trqdz
	 EMBPo2NeO9Yx2z3+dJRwZd865oCP9Seqb2hAWlOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0332/2857] jbd2: check need_resched() when skipping busy checkpoint buffers
Date: Wed, 18 Nov 2026 15:22:46 +0100
Message-ID: <20261118150213.394892068@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit f213e12ff5c9590b1034ae8da0e6d09665c772d0 ]

journal_shrink_one_cp_list() skips busy checkpoint buffers when called
with JBD2_SHRINK_BUSY_SKIP.  The continue statement on this path also
skips the need_resched() check at the end of the loop body.

Consequently, when a checkpoint list contains mostly busy buffers, the
shrinker can walk the entire list while holding journal->j_list_lock,
even when a reschedule has been requested.  Large checkpoint lists under
memory pressure can therefore cause long lock hold times and leave other
CPUs spinning on j_list_lock, resulting in soft lockups or RCU stalls.

Route the busy-buffer path through the need_resched() check so that the
shrinker can release j_list_lock and reschedule promptly, restoring
parity with the clean-buffer path, which already checks need_resched().
This does not change which checkpoint buffers are eligible for removal.

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260713102229.1598812-2-max.kellermann@ionos.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/checkpoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 36c64cf44e005..a888357a29964 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -401,7 +401,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			ret = jbd2_journal_try_remove_checkpoint(jh);
 			if (ret < 0) {
 				if (type == JBD2_SHRINK_BUSY_SKIP)
-					continue;
+					goto next;
 				break;
 			}
 		}
@@ -412,6 +412,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			break;
 		}
 
+next:
 		if (need_resched())
 			break;
 	} while (jh != last_jh);
-- 
2.53.0



