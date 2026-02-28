Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C1936C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302309; cv=none; b=thCGd/0jB3cyYuMSkgtWpwf18iHv/TjFq/xwKGw5lNLkwzv1Y4oLjrXb4A0XpicDLvvz6widsxVusBGoqbhy317tzFUIIr7KeIXtgpqpTsbfacH/ynTbn+5UffDB0XfLSyBUiCX6CSPBtBrgs/SblwBTt2r+etRfQndLPYwdEZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302309; c=relaxed/simple;
	bh=XHdBB+iTY9cn3cdjaF9uicg6SlsuL1PjAoKUX+xK7ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWiMufPf1lvLtkthhR6YxBF4Jcyg78D9DNukZj+EwYv7XNo0x4khZsNhZY9lDurgkIrgMywFwTOmsdx7acAgO3K2fV8yTJJu/v3IcQuAIY72B61Ds7YxT0Q5iU1qZ5eCrIhAD9iWvbtptuoYiJmBRNKNACLjzBOoy8pH+GASIR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPKCsK3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPKCsK3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63D0C19425;
	Sat, 28 Feb 2026 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302309;
	bh=XHdBB+iTY9cn3cdjaF9uicg6SlsuL1PjAoKUX+xK7ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPKCsK3DztRGD6LWTDV6PqDGKE6nGMiQ2/CHJ2RsQMHFLwhMT80ZAWkH4Immcr04X
	 FLnROt/U2WidS7hRE8mQPg2d6ZRGsgkPgGBAmrRu2zFAmocY3KRc/ROWJTkYAvZf+Z
	 71Sgc+56mepuhoaA2Vm15+TjDFBaHp9xcSsfdHxqNoOWi9P0Yp5VFELviIWNeH6bGd
	 XwCV8o0DyvvT6sMPOfmf+8SHoDJmRjgNdvMF0gXHycrREqRSKN69tMD8Xb3NtsR8/1
	 44wv6vz9vf/BwY7srL5bif0XJpzZiy96/FxWhe2Nk9vatTdHFfoLeFSu8bzjWjz2d3
	 2HmfrjicSEp4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Samuel Wu <wusamuel@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/232] PM: wakeup: Handle empty list in wakeup_sources_walk_start()
Date: Sat, 28 Feb 2026 13:07:58 -0500
Message-ID: <20260228181127.1592657-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

