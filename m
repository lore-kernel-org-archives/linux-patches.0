Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0D535AC00
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302672; cv=none; b=GUTfhz5trWANXroTvbYqUGlRZ+sNqApyQfrChev1Ah+Uomj76RIxV6I2U4sCuYddDwm4surXYR6frwshQ+ZyjteJiVMqIgV30+td79YvIin07pJ9//+XacbHlEHkF4tl/c5vbvjZL3CQW9617G4x7yQV13VbjyMPQHoUvSIucTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302672; c=relaxed/simple;
	bh=LCgIjCPUd0q1+dFL2mZSYAhNUCwUENWBjj0fpjw5Rjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tM4BqvII0UP5T7Cl7hJqbS4rqIcl5JHuuZtgd1IfOX8TdfJ9Dfrbe/UrZSIeT7Q7dH+Uur5eXH0luBr8VxOc21MHC/Wmu37xDyz6CgaQeS+PhK2DYRlHOI6rUHCbj5oLF34tXSr6S/l+ax1/RU8V+pBp7ez60HqmJ46SLeo9kZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsGfkFa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsGfkFa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951BCC116D0;
	Sat, 28 Feb 2026 18:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302672;
	bh=LCgIjCPUd0q1+dFL2mZSYAhNUCwUENWBjj0fpjw5Rjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsGfkFa5qWz11mmwoYGw+eHBsg+NnwS+Y06oYthtSaGYmCnfL+t8+xzkFTPKnZd5l
	 JB5dXMG5fsAHP4jHfonhg7q6w8sXPxJ/XiOPNTvY5Vw//RXlus/QEkJEGfXz8kqIGI
	 1Wg8mYD4WvzEOpYLKVe8neqal5MPA70jdQjbbfG6jT7KSQ3kv8IjoFMx+XUaZ2zRLP
	 Pfg8OBIExEOJuoozXUcBQe6TIOqxrjMsTslYoqID/U8UtWsRrTAaIc0kehOmc3XI7C
	 GIpXwr6Aq+dsw6UQCToNkzcsgdnEtRhF6tpBnL/oSRvWbDs5qCgQVmlnwliTO4VWRa
	 zRrhpLKxY9CWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Samuel Wu <wusamuel@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/147] PM: wakeup: Handle empty list in wakeup_sources_walk_start()
Date: Sat, 28 Feb 2026 13:15:28 -0500
Message-ID: <20260228181736.1605592-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 8997e0227eb9d..e3b0a2db32e9b 100644
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

