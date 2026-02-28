Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC3F37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302518; cv=none; b=J0ZzEsmajeNFeuB1yAY6g6RPp3Y7vx/ljhJqsM3kxMd6q9y6ESswP9lPya/wktcM0CtUPnJiAnHCJ2BOazbxLTzfh5/cdddE7BZNjDF10GiUdeDFxR3HiX9n47m/dbBvEZ86jA5nI+cpk3xz/bxL3u3tARVaSibFRbLsN/WTVKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302518; c=relaxed/simple;
	bh=xYSg8Pvrk7WlaWBY+WFJfPOhy4pPM4mbmWfV0sMVd9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruKs9yyRl6wAqQ4JstrJRa5i9rMlsNnzUDdeDsAx2Xt2qEHKzdQims+qrI4yoLjGEuRdRsitvprnqC/ZOmzbnBhE1tHETruwIPPl8VnHMatZsIfg5smHsgPGUpORVz0gYurGnOuhLCMIrSobkATNtkY9UyPKaohBrYqOhAFaMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zfcg6+b9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zfcg6+b9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34B7C19424;
	Sat, 28 Feb 2026 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302518;
	bh=xYSg8Pvrk7WlaWBY+WFJfPOhy4pPM4mbmWfV0sMVd9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfcg6+b93sm7zWvc3g1zXWvPFx/GhcE8E/yXzYsDyTd/9Kz6Gw7ZNxHlUYumwTiYR
	 yEyQEsh6MmuRMXqMKqLilHILkottxjZ5Bz45GQV5EksiyB0sEmnPPpCKEPTpcoZ4yj
	 TKjdUHwXhs2nohMy+ja2X6kOV8bEFt22ZjNz/N4LU38Pl2+wGjaRFCpu3rhm/Oa1PY
	 1NHzZ8NgK/OJKrHL138ZYQAH2qkakszWdbWdTn9vuRHT228ZBhq5Bk2odFZ7m1rzNN
	 jlvd9AfYAiiYQ1FxScCnfvSpF9/0nbmMqYHERIuerF4NqoQcU7cbfDxdDEQWRKJLQm
	 JC3s96LiaRaVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Samuel Wu <wusamuel@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/164] PM: wakeup: Handle empty list in wakeup_sources_walk_start()
Date: Sat, 28 Feb 2026 13:12:34 -0500
Message-ID: <20260228181505.1600663-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 8666590201c9a..4ef4c8dfd2bc7 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -285,9 +285,7 @@ EXPORT_SYMBOL_GPL(wakeup_sources_read_unlock);
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

