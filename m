Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9C33446C0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301648; cv=none; b=arBIR3tsZvuw9t6H4MoamxSZUw4JuX2rxKmxYbFCsfXcAjzw/7DypSGv15z8BcZEBxJuZM2jzwVVLx8wpvEOHSTPNezLUqOhsfmKzDdyBLCoNp0Cs/MmctlYyMR6IO3Gts0+MzDzXzxiXxoEbf3cCDpiefQok2/FFZ0eHImSsAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301648; c=relaxed/simple;
	bh=fwaCvxdgVdYG4mJevpwrmm6Jo29s1sHiWJIHEYHBjHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVIlLGx0JjZSJRVLizJFRv6WVo8w+bhwANNWrmwlwTdMZVIYLnYAwaMGI5KsgL64OCpw78wI7wRHRBwU/YvfGwzWDqUx2w7hnIgWJaanJktZSXDabHGIZZgUaIQW9H3oRg24fWEe2c8Rc9eNEI0eay/gb2Dwta2TBg0o+On2Vv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGPyvsF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGPyvsF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0F7C19423;
	Sat, 28 Feb 2026 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301647;
	bh=fwaCvxdgVdYG4mJevpwrmm6Jo29s1sHiWJIHEYHBjHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGPyvsF1PsDTT+QpZ2KMdOhCFGep5SnQMwbEbFy2HXodf18VpZR83QWj1m0gQ/6D3
	 ZTuL+pUvja6gwpnzePd4C3aJdwDzFZbV9kwlAP97Zm8Upe8SJ7j3FfiuB3D6nmSPhU
	 G+LumScta0r8KAQptXaQa/fqRMV2wbxZLFYxGbMX6k8amFfgTEvn7LDf0ajmt6FhMW
	 5Qv7x+IvLNqXQX8AuQtYcDdh79y2ywqsFrUNc06J3KohqXVfq/PCMMfcyYvxlPvOf1
	 Y/3TXu3MsCYQhQ/WNDHnUk8APgxgydiPa+MG9TFi5/d62Itw4jNj88GwevY98JCMrR
	 x6okui17yNCvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Samuel Wu <wusamuel@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/385] PM: wakeup: Handle empty list in wakeup_sources_walk_start()
Date: Sat, 28 Feb 2026 12:54:25 -0500
Message-ID: <20260228180011.1568201-43-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 752b417e81290..706cd556a0d69 100644
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

