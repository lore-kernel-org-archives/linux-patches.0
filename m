Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAA92EF659;
	Tue, 17 Jun 2025 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174279; cv=none; b=FqVyVx6ujGLUrtsOLXu/5J22t06KlhiQjXfTj8mmPmcEJ5zoegrEeJEkzRplXX4a9FQpp1XZJVDgKjiUFaNPdMi/1MN4N1kZ3nX0rJQGxwxX8CSu45BhbKq0EjQ/96vDkRQmIZH1a6NpTjpGPnM0RbJ7x8G7G2RipflVAZJPzfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174279; c=relaxed/simple;
	bh=c6u6ToaMp+/CumCafUOXPKIqQsxeXIQ2OpAjIfw7zIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPxj/cMcjr0bCwGZX1/dqmQ0INq4jgPaLSgVSnlnvMFwb2iHNOhKQpMNDXCs3ZqGCdcUF/kUhWprebmyNQemLHps2EttryZZrpH9WnQfKnXEtgtTYMVSmeeTRBv9vzYk/4XDkhMB4oQ+Suards9h/ikPO6uig2aIsIn3DWPUL4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzgVTdTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzgVTdTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C7DC4CEE3;
	Tue, 17 Jun 2025 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174279;
	bh=c6u6ToaMp+/CumCafUOXPKIqQsxeXIQ2OpAjIfw7zIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzgVTdTY844gURr5D+OxdnBVSEUD1pUnWXnP4oKPWW9ET6lEs60NFL1AIyIxIZC+X
	 xlfqWlWEGU7cNLpw2sGUi5sgAeVmdSHl2H6qs4zlAwLkZCPbncltHEwle5BtsswSQm
	 HmLlNaxD2gZscDwss46AOqRSfyZFwXWBxvwoneCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/356] kunit: Fix wrong parameter to kunit_deactivate_static_stub()
Date: Tue, 17 Jun 2025 17:22:32 +0200
Message-ID: <20250617152339.712546254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 772e50a76ee664e75581624f512df4e45582605a ]

kunit_deactivate_static_stub() accepts real_fn_addr instead of
replacement_addr.  In the case, it always passes NULL to
kunit_deactivate_static_stub().

Fix it.

Link: https://lore.kernel.org/r/20250520082050.2254875-1-tzungbi@kernel.org
Fixes: e047c5eaa763 ("kunit: Expose 'static stub' API to redirect functions")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/static_stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/static_stub.c b/lib/kunit/static_stub.c
index 92b2cccd5e763..484fd85251b41 100644
--- a/lib/kunit/static_stub.c
+++ b/lib/kunit/static_stub.c
@@ -96,7 +96,7 @@ void __kunit_activate_static_stub(struct kunit *test,
 
 	/* If the replacement address is NULL, deactivate the stub. */
 	if (!replacement_addr) {
-		kunit_deactivate_static_stub(test, replacement_addr);
+		kunit_deactivate_static_stub(test, real_fn_addr);
 		return;
 	}
 
-- 
2.39.5



