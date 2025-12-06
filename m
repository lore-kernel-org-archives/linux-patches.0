Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780BE2FDC59;
	Sat,  6 Dec 2025 14:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029830; cv=none; b=fG5nIUTWY0XT3+k3wb8mlt21MBHj4QDwIOPSxiF3SrIytu/pen1U7zlIXfyk/V4QE3Q3r7UpTACfcQ+6AXQCvqBMqM1+0UCotGQmTN09OH20lo9l5Sejc1TwRbinMX3USRuAFK0yN7iMOVq8rXU6NQeQl0X9jQ/ezggicq8eYIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029830; c=relaxed/simple;
	bh=9ZkhCQriaUyQhO3XSy1/1/FXk4FgoAR0dLQkr/Rj9wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1G2SnpFWUfW3a3Purcu41z6ECEXW3KbVxoEEYcuZx/Pn0miKGqstMnYAMac8Zk42C1agiSzqk4b5fhmN3YM+61p/P2wTiU9sTdnhTjeHYA5BdGVs7ZniJ53dkOwL+NOxT1/DpxA/X4XNixa8jQwh7WF6OwPAxCuBUxPHaYLCv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAh7WrNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAh7WrNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687E0C4CEF5;
	Sat,  6 Dec 2025 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029830;
	bh=9ZkhCQriaUyQhO3XSy1/1/FXk4FgoAR0dLQkr/Rj9wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAh7WrNho0nflGLsQrBhAe+DCFEgQ6ngy1psG8Sy3DeGCdDMj2HYLiTV7sD+cxh6Q
	 1qOkC9K4WVXwlnmLERL4sqVEu7sicx8Sj28nNrD3iSvk/y2nDFan5Kxy9CzccuCp63
	 4v/T/578cuR5Gne4754Uydktwt7BrT+N1wMG2+Kcmd4WG+fwJsKStGBZSzZUvhI5rt
	 qLrikfGS+vyPDqpvIuaC0JAm/DQlp6rzF4qmeikc4SP+Ft3BDSNmwLyzB3OZ7UACuD
	 pUeXKfDlFGbxexch0XspOKcVyA7+CTFSDn9F9iJZIdSK1qF5CCUPpHLme4sKOfXWhl
	 CYkBSzuc8QZEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.12] gfs2: Fix "gfs2: Switch to wait_event in gfs2_quotad"
Date: Sat,  6 Dec 2025 09:02:30 -0500
Message-ID: <20251206140252.645973-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit dff1fb6d8b7abe5b1119fa060f5d6b3370bf10ac ]

Commit e4a8b5481c59a ("gfs2: Switch to wait_event in gfs2_quotad") broke
cyclic statfs syncing, so the numbers reported by "df" could easily get
completely out of sync with reality.  Fix this by reverting part of
commit e4a8b5481c59a for now.

A follow-up commit will clean this code up later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 fs/gfs2/quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 2298e06797ac3..f2df01f801b81 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1616,7 +1616,7 @@ int gfs2_quotad(void *data)
 
 		t = min(quotad_timeo, statfs_timeo);
 
-		t = wait_event_freezable_timeout(sdp->sd_quota_wait,
+		t -= wait_event_freezable_timeout(sdp->sd_quota_wait,
 				sdp->sd_statfs_force_sync ||
 				gfs2_withdrawing_or_withdrawn(sdp) ||
 				kthread_should_stop(),
-- 
2.51.0

