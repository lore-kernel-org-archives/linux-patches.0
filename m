Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2243346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302057; cv=none; b=OcgGjJOs860iPJbDc375vdzhxUrywzFGqIQ9EYyZR4D3QY88HmmWKqUHys43GQlw/ibVSEszt4ppr9e/6Y6XRLCIEkFvFzkP3304cFLscTSyip6j90DQfbpxv/ugJ74478H7lv3IRNe/4731ycCaQK/7stFGjfkzdMRrTDAkD4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302057; c=relaxed/simple;
	bh=XHdBB+iTY9cn3cdjaF9uicg6SlsuL1PjAoKUX+xK7ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpqE389T64UEu2isDI+9DOiXMscSLHFna6C2rjCXIXi/PV8luXHXCfbGxqwfv0flEF+MdxMq6dHccBwBtunuWqT0lEu3pGEdLSgNgTOHZg5de7GOzzKkOb30gN0SnJIVQs6CdZlSXxhSEb/WTwQepecdkaPVE914ZKRsfeL0AyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTxK9p7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTxK9p7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD816C19423;
	Sat, 28 Feb 2026 18:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302057;
	bh=XHdBB+iTY9cn3cdjaF9uicg6SlsuL1PjAoKUX+xK7ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTxK9p7CQHygCnT26omQB8KvTr8Q764/JOpMrHtRVBORyur1f5UO4QUTCQyurQo/m
	 xFpGEAQzuLNP8Wduk7tWqQSlvD2fN3UXWuIuWB/x4Xeuc20vVjYhW1pyjtVRzCrfFy
	 W6Cs18n+hQzAXvuCkXOZDKuMvLaPD4ZAk8q37xCx/vCHytG6WSnn5r3lVFz7hXvZOI
	 LxqX6jJF7Js61GxxreEy1oRYsr+kz93ox2UkoJmf4IOGIjBpNK4OdKDylHjB8HxMlK
	 XaS7BKjgG4TpuFsUs4zr52RHY5EVt5KfI5vO4zxruzNKwQnYNV8L9zRbYUYP8He0MY
	 wx2JWuKuYHhHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Samuel Wu <wusamuel@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/283] PM: wakeup: Handle empty list in wakeup_sources_walk_start()
Date: Sat, 28 Feb 2026 13:02:55 -0500
Message-ID: <20260228180709.1583486-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Samuel Wu <wusamuel@google.com>

[ Upstream commit 75ce02f4bc9a8b8350b6b1b01872467b0cc960cc ]

In the case of an empty wakeup_sources list, wakeup_sources_walk_start()
will return an invalid but non-NULL address. This also affects wrappers
of the aforementioned function, like for_each_wakeup_source().

Update wakeup_sources_walk_start() to return NULL in case of an empty
list.

Fixes: b4941adb24c0 ("PM: wakeup: Add routine to help fetch wakeup source object.")
Signed-off-by: Samuel Wu <wusamuel@google.com>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260124012133.2451708-2-wusamuel@google.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index a917219feea62..eae81def0902a 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -280,9 +280,7 @@ EXPORT_SYMBOL_GPL(wakeup_sources_read_unlock);
  */
 struct wakeup_source *wakeup_sources_walk_start(void)
 {
-	struct list_head *ws_head = &wakeup_sources;
-
-	return list_entry_rcu(ws_head->next, struct wakeup_source, entry);
+	return list_first_or_null_rcu(&wakeup_sources, struct wakeup_source, entry);
 }
 EXPORT_SYMBOL_GPL(wakeup_sources_walk_start);
 
-- 
2.51.0

