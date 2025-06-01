Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F3D2571BC;
	Sun,  1 Jun 2025 23:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821202; cv=none; b=TaN4Ky4AvdyWXjFi+A5g2gkTx6BP7S7Gz1UmsQ/d44L0dDycPoC5vQK0uDtkm3BlP5J3E6elQNau/N2AmqpXmnttqTSyRS812Rd0J7Z6cMGUxOBZnioBGvGozhI5/cpPWsqtd4XYId6OPpVl/zgdtrzoCrGtDgQJ13PBitVI3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821202; c=relaxed/simple;
	bh=6YfKX0H1CC8Q3E7OyTtXb5uF6mX/Y0slsj7eqFPJ5d0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a4BSf0jw0tYtjROs4HgfbP4OHRtgx6BwLJ+T1BRaijZlOv/+ujVs1gIPAkTiXXS/xIRr90DC/L4Vqe28W2jCnuCV2798sl96pUb5XfJMDiCvTMfYAZqpN0zTFpw9WPFLFwMOIlIqaZ9vrGi/ebH07kCRFXeod7Qp9KrxZ22KcLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qefo4VJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qefo4VJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A633EC4CEE7;
	Sun,  1 Jun 2025 23:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821201;
	bh=6YfKX0H1CC8Q3E7OyTtXb5uF6mX/Y0slsj7eqFPJ5d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qefo4VJ6hWI+808vG/2DFAPk80rD+S2g/kP1VVS6570Ap/Wi9H1OD4x3lad+tJ8QJ
	 JNP/Y4d3oUZHqV8ssbfGI7dp/7UuzgCSgVefwza/zV7MAOm8MAKRqlB26RgyIwqtc6
	 VF3VOch+wgEtaQCIanCnc319hSnA6SH5g9HGxk3SBOizvrVrgfPXDEHJvjsOJLtmNh
	 LQ629Ii74yTPbrwPy2UKk773IT9DVs0IFV8vBBQVM801PVVVNY2PptnE4g8E1D3jFL
	 DawgRdjpkwoGIKBD3K4j6Z+vwmoS/g90kYJMEIPFwqnOUVdrJTGZb85eBdlKhwJvUB
	 MzfBEaYTeyZAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	yuehaibing@huawei.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 61/66] ALSA: seq: Remove unused snd_seq_queue_client_leave_cells
Date: Sun,  1 Jun 2025 19:37:38 -0400
Message-Id: <20250601233744.3514795-61-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233744.3514795-1-sashal@kernel.org>
References: <20250601233744.3514795-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

[ Upstream commit 81ea9e92941091bb3178d49e63b13bf4df2ee46b ]

The last use of snd_seq_queue_client_leave_cells() was removed in 2018
by
commit 85d59b57be59 ("ALSA: seq: Remove superfluous
snd_seq_queue_client_leave_cells() call")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250502235219.1000429-4-linux@treblig.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

NO This commit should not be backported to stable kernel trees for
several reasons: **1. This is a code cleanup, not a bug fix** The commit
removes dead code (`snd_seq_queue_client_leave_cells()`) that hasn't
been used since 2018. The commit message explicitly states this function
was already removed from use by commit 85d59b57be59 in 2018, and this
commit is simply cleaning up the unused function definition. This is
purely a maintenance/cleanup change with no functional impact. **2. No
user-visible impact or bug being fixed** The removed function
`snd_seq_queue_client_leave_cells()` was already unused, so removing it
doesn't fix any existing bugs, security issues, or user-reported
problems. The code changes show: - Removal of the function
implementation from `sound/core/seq/seq_queue.c` (lines that iterate
through queues and call `snd_seq_prioq_leave()`) - Removal of the
function declaration from `sound/core/seq/seq_queue.h` **3. Follows
pattern of similar non-backported commits** Looking at the similar
commits provided: - **Similar Commit #1**: Removed superfluous function
call - Status: NO - **Similar Commit #2**: Removed useless function -
Status: NO - **Similar Commit #4**: Removed unused declarations -
Status: NO - **Similar Commit #5**: Code refactoring with no functional
changes - Status: NO Only **Similar Commit #3** was backported (Status:
YES), and that was because it fixed an actual race condition bug that
could cause long stalls, not because it was removing unused code. **4.
Stable tree criteria not met** Stable kernel backports should focus on:
- Important bug fixes that affect users - Security fixes - Critical
functionality issues This commit doesn't meet any of these criteria.
It's purely cosmetic code cleanup that removes dead code without
changing any runtime behavior. **5. Risk vs. benefit analysis** While
the risk of regression is minimal since the function was unused, there's
no benefit to users of stable kernels from this change. Stable trees
should minimize churn and only include changes that provide tangible
benefits to users. The commit represents good housekeeping for the
mainline kernel but doesn't provide the type of user-impacting fix that
justifies inclusion in stable kernel trees.

 sound/core/seq/seq_queue.c | 16 ----------------
 sound/core/seq/seq_queue.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/sound/core/seq/seq_queue.c b/sound/core/seq/seq_queue.c
index bc933104c3eea..da4e84839d1b2 100644
--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -585,22 +585,6 @@ void snd_seq_queue_client_leave(int client)
 
 /*----------------------------------------------------------------*/
 
-/* remove cells from all queues */
-void snd_seq_queue_client_leave_cells(int client)
-{
-	int i;
-	struct snd_seq_queue *q;
-
-	for (i = 0; i < SNDRV_SEQ_MAX_QUEUES; i++) {
-		q = queueptr(i);
-		if (!q)
-			continue;
-		snd_seq_prioq_leave(q->tickq, client, 0);
-		snd_seq_prioq_leave(q->timeq, client, 0);
-		queuefree(q);
-	}
-}
-
 /* remove cells based on flush criteria */
 void snd_seq_queue_remove_cells(int client, struct snd_seq_remove_events *info)
 {
diff --git a/sound/core/seq/seq_queue.h b/sound/core/seq/seq_queue.h
index c69105dc1a103..5f6b9c768fec2 100644
--- a/sound/core/seq/seq_queue.h
+++ b/sound/core/seq/seq_queue.h
@@ -66,7 +66,6 @@ void snd_seq_queue_client_leave(int client);
 int snd_seq_enqueue_event(struct snd_seq_event_cell *cell, int atomic, int hop);
 
 /* Remove events */
-void snd_seq_queue_client_leave_cells(int client);
 void snd_seq_queue_remove_cells(int client, struct snd_seq_remove_events *info);
 
 /* return pointer to queue structure for specified id */
-- 
2.39.5

