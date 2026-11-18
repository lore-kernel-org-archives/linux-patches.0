Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048619;
	b=UTp5p5lFAVllGLwFVVtOhmNuNIQ03/Hd0jolDk1cKN+jgnwrUDHnoH/BorvVNpN7UoIx
	 fEyuuR+P/CSB15qSIVNK2u7ItjhrBzClBZPQeRw7d6xlOqRd9oP/Hja3MpMMwPBJTmCkN
	 GfenEXJ7q6l47L8VpBeDYIR+MRkWv+8ylmS2c46hkFoT0noAZcPLaQTpRfETzfL32ut2B
	 tozXKbDDxeUvoX+I0THmcCQX7hAQpFEJwnRjo7bFP3lsuomP4IrE4o3L2mUjcWunT5VgJ
	 ocikqCca11y4blwNQ3WV+3r+rZJNvT3BMUQaprNzr4kv9SaMks5tfzGzPbkPGEEpkSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pBT9cEF88n9roUxM2Kk05YibfqQNug65SoC6CsadnMU=;
	b=fO4duvoeXkbmVatumk2gnyx3Mfqm5axg53BW2ntOhAEWgrk1O3LmfXPF/daISBwN8J5u
	 xd+NvGMpuVk8oZLQhRNgX5ylg/VVfQ3I51eV212Ga4GfUYfY42b/yam19kcVhwn+teBMN
	 eIQ4UuVvg+PgfcR9zELrza03yIC/aGWydyOGMMGC+hu0nz79JxFN+rdxkV/N0Y4YNTnkL
	 sYJE7KU+2lm3ZCUgS/X6ls+6ZfsBgCowzKfdMkpuKhp08yxmyS7T7R1z9YhxCZ+A9i5RZ
	 h8IuOPWz9xgRVLVp0npQ+RCDPIe/0hMN4Ak7qFvF71HnF1jYztWtsp/XNjNyghOV6gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uOLsHe2F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48651606A32A;
	Thu, 19 Nov 2026 00:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uOLsHe2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE361F000C4;
	Thu, 19 Nov 2026 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048619;
	bh=pBT9cEF88n9roUxM2Kk05YibfqQNug65SoC6CsadnMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOLsHe2FI6zG98uRLbnGge/6krqb8qvP3Vo65NJTQots3ZzhPkaCTciRY5VhZobmH
	 lFiu4f2EjRSpaQahng4duvSYhUNzX/ZSdGgHtA728z2kKNpuIQYTYrI+2d6I5KOVzB
	 BqL7DlhkxaPLCeBnC0f6c8GtVZ4MZPB7nEDyOvyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Xin Yin <yinxin.x@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2059/2857] writeback: size foreign flushes by target wb dirty pages
Date: Wed, 18 Nov 2026 15:51:33 +0100
Message-ID: <20261118150315.549732194@linuxfoundation.org>
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

From: Xin Yin <yinxin.x@bytedance.com>

[ Upstream commit 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd ]

Foreign dirty tracking records the bdi and wb memcg IDs of recently
dirtied foreign inodes. When the source memcg needs foreign writeback,
mem_cgroup_flush_foreign() queues WB_REASON_FOREIGN_FLUSH to the
recorded target bdi_writeback.

cgroup_writeback_by_id() currently sizes this best-effort work from the
target memcg's NR_FILE_DIRTY counter. The work is scoped to one target
wb, so a memcg-wide dirty count can over-size a single-bdi flush when
the target memcg has dirty pages on other devices. It can also under-size
the flush when the target wb has dirty pages charged to other memcgs.

Over-sizing keeps the target wb busy longer and can delay later
writeback work. Under-sizing can finish before enough pages are written
back for the source memcg.

Use the target wb's WB_RECLAIMABLE counter and keep the existing 25%
headroom. This keeps the budget aligned with the writeback object being
queued.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Link: https://patch.msgid.link/20260924065443.1650126-1-yinxin.x@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 337970ba58237..f9f3ca5c5a889 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1120,7 +1120,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	struct cgroup_subsys_state *memcg_css;
 	struct bdi_writeback *wb;
 	struct wb_writeback_work *work;
-	unsigned long dirty;
+	long dirty;
 	int ret;
 
 	/* lookup bdi and memcg */
@@ -1149,16 +1149,13 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	}
 
 	/*
-	 * The caller is attempting to write out most of
-	 * the currently dirty pages.  Let's take the current dirty page
-	 * count and inflate it by 25% which should be large enough to
-	 * flush out most dirty pages while avoiding getting livelocked by
-	 * concurrent dirtiers.
-	 *
-	 * BTW the memcg stats are flushed periodically and this is best-effort
-	 * estimation, so some potential error is ok.
+	 * The caller is attempting to write out most of the target wb's
+	 * currently dirty pages.  Size the work from the wb's reclaimable pages
+	 * and inflate the count by 25%, which should be large enough to flush
+	 * out most dirty pages while avoiding getting livelocked by concurrent
+	 * dirtiers.
 	 */
-	dirty = memcg_page_state(mem_cgroup_from_css(memcg_css), NR_FILE_DIRTY);
+	dirty = wb_stat_sum(wb, WB_RECLAIMABLE);
 	dirty = dirty * 10 / 8;
 
 	/* issue the writeback work */
-- 
2.53.0



