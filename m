Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A0C3370F6;
	Fri, 17 Oct 2025 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713057; cv=none; b=AXCG+K441oGnnU3Z2ABh5roZ6WPcTlZPZoxXiK4z88O0eKISzaiNLGbpkOdGkvqCvd50lAiJQcA4uKBuuvVPawUULDqJLJwimp+fnYL1mieHoTGB5rf5nCfRJoO8PY48RGymc+BJOpiX0B6LF7chFgDpwikmamtmu1FZFni11E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713057; c=relaxed/simple;
	bh=ccxUa492ijo0pcI1M0muyHOHsNnBCm7tiktwjC3KqrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExpIiJ9K1CUxLDL9f6oh2AaH6cnUWrxTLa8DZUSaRcS4MMTel/bNmGo4bqoRNVQ/HzRsOnwPhK6KziJR+cjfWNgmShXYBNDgL5diFLPvS73MkHTH5sUNrwenRNERhcQjnlv/Ax333YKEBzxmbT2O9Gjsl9T16xmsMcmKZBMX68Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kN/9ph89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kN/9ph89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC98CC4CEE7;
	Fri, 17 Oct 2025 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713057;
	bh=ccxUa492ijo0pcI1M0muyHOHsNnBCm7tiktwjC3KqrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kN/9ph89BHcMLLoAahNhI4AQBGd9oHM/e8Wpx74AdZIJZxuR14O76cEMxnLpYb+eV
	 2SiKGpOaGTuOPDfc4dpbvr3564WekZXxhBczymErYINuq1FpMS5+6LXIaZH5z0ukuy
	 kEL+FQlocNwS7B2l4mDGQhSLj5vwrMarKTD8o0CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/168] drm/vmwgfx: Fix copy-paste typo in validation
Date: Fri, 17 Oct 2025 16:51:52 +0200
Message-ID: <20251017145130.239105722@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d37cf22e9caeb..27f33297fcf3e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -692,7 +692,7 @@ void vmw_validation_drop_ht(struct vmw_validation_context *ctx)
 		hash_del_rcu(&val->hash.head);
 
 	list_for_each_entry(val, &ctx->resource_ctx_list, head)
-		hash_del_rcu(&entry->hash.head);
+		hash_del_rcu(&val->hash.head);
 
 	ctx->sw_context = NULL;
 }
-- 
2.51.0



