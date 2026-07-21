Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6C4265606;
	Tue, 21 Jul 2026 19:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663140; cv=none; b=Nya9ZqodN2GvkdwjczjNDDpZHcM88M3kOI8CuqTCZlorWG2FavQSFIOtFlOFoCXSKXpCD+DMCVvv4KxKXsmk0r9wkrkgxAhFTbuCdEI6PdSVenWRF398rvkVvgZ+Gt+88f0ykAAbJAQdAYvHdyRMRbKECsVY3X+Zs8VpztJdxhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663140; c=relaxed/simple;
	bh=8kZTKRWmqjvKBleO+BPZ7ieQ5n2NnY2vLpR7ggd9Pxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+jyn7C9sv/lgKqvDoQcJMaImP+Pb841bON5doEQvhEBxEZ6LC6JIycfqLchAexNxmzDMLDsgrr2LDjDT8/Wcrkuz/ch6QrHb0206yc6cjRTFnZJZK7bd4Zo8UmMznf19zViSSfz+R7/LMY6fk7O/T76kBGE33H3kiPGLM8r4Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sf5Lm4Rc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sf5Lm4Rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1ECF1F00A3A;
	Tue, 21 Jul 2026 19:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663139;
	bh=TOJX2qHFwJCYDFVOo99aZG11SnIUMRoEaGxFMByWU1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sf5Lm4RcQnjckOui3nkefQ0r/fCUFPNkgEuVdO2wrOTSpG3NlYJogigje61n/EOac
	 S2LyCz+9vOz8xYer3VQNHtmiRjvvVt/LxxHGhSeJGSI4QeNBtcNVUwkZLm607A7lB1
	 lOEXMRk1AkTSpvQf4YuYs7RDyruzrxEJqUNR3BPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0710/1276] drm/panthor: Fix potential invalid pointer deref in group_process_tiler_oom()
Date: Tue, 21 Jul 2026 17:19:13 +0200
Message-ID: <20260721152501.984230665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit b39436d0ba1571dbcda69d20ec567344b3eecfc7 ]

If heaps is an ERR_PTR(), panthor_heap_pool_put() will deref an invalid
pointer. Make sure we set it to NULL in that case.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v5-0-8836a74e0ef9@collabora.com?part=2
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-4-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 2d4dacece655f5..3e7799dd00679b 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1439,7 +1439,10 @@ static int group_process_tiler_oom(struct panthor_group *group, u32 cs_id)
 	if (unlikely(csg_id < 0))
 		return 0;
 
-	if (IS_ERR(heaps) || frag_end > vt_end || vt_end >= vt_start) {
+	if (IS_ERR(heaps)) {
+		ret = -EINVAL;
+		heaps = NULL;
+	} else if (frag_end > vt_end || vt_end >= vt_start) {
 		ret = -EINVAL;
 	} else {
 		/* We do the allocation without holding the scheduler lock to avoid
-- 
2.53.0



