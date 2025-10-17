Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731BF3370FA;
	Fri, 17 Oct 2025 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713548; cv=none; b=F14u50VdP2LCGHIvT5hfhZOswJ8Gwlbj91+45Y/noDMw77ioCFpG/NsyAb3lD66nsNTaYcGPAFWbfbZnsyyIFvE8YJG0236btfN1RWU7F4wzPOK9M+d3lZS83jgmp0/uvG9KP942epLdq9NbOi2uq0vprdmEaIolJakEIXe47Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713548; c=relaxed/simple;
	bh=3WmymcjWFrYxK58FQhjgUH3ixEOzZt+lshKSw+ReDPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFx/ZubSWgZM3HRHiSQi3uNV9dh46ZyQ+oFzeiC9ir/5asYyyYnk9JcONB7Jx27L5/7oHU1Ody82X66sY6QntXVzeTShRX4KSGZ66R3nlRY0x9lRbzijNuZF6NF0GqXD6hOPwLUOdZEoEKxecUIaJM6mCtQ47eVuWGX/qNbbvWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oL8Mswp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oL8Mswp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26BDC4CEF9;
	Fri, 17 Oct 2025 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713548;
	bh=3WmymcjWFrYxK58FQhjgUH3ixEOzZt+lshKSw+ReDPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oL8Mswpf9HzTXFjo+WZBHCMexa2W6hBkXzIalqOv4J4mw3Kb/s/Ka2tQhJNkHqIT
	 y1xy/sRQWbn/yH8Zr2XKulLMTkxfEjWnlrysAHUH4IkmdYF3xVDeePFQ/3+76Dg0z+
	 8BXPsN9/dZPrESgM3ZXzxJIuOCYs6+ETYpH8oefQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/201] drm/vmwgfx: Fix copy-paste typo in validation
Date: Fri, 17 Oct 2025 16:51:36 +0200
Message-ID: <20251017145136.034187286@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 228c5d44dffe8c293cd2d2f0e7ea45e64565b1c4 ]

'entry' should be 'val' which is the loop iterator.

Fixes: 9e931f2e0970 ("drm/vmwgfx: Refactor resource validation hashtable to use linux/hashtable implementation.")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://lore.kernel.org/r/20250926195427.1405237-2-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
index a4a11e725d183..946f166d6fc76 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -656,7 +656,7 @@ void vmw_validation_drop_ht(struct vmw_validation_context *ctx)
 		hash_del_rcu(&val->hash.head);
 
 	list_for_each_entry(val, &ctx->resource_ctx_list, head)
-		hash_del_rcu(&entry->hash.head);
+		hash_del_rcu(&val->hash.head);
 
 	ctx->sw_context = NULL;
 }
-- 
2.51.0



