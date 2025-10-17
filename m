Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231CA217722;
	Fri, 17 Oct 2025 15:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714175; cv=none; b=PwghU0Hey3uqy1ddWBOJJJ47mnODYDS2SpB3HQY3uJTmz6WcJ/oU4BsvQwXAloVdoVERNQ8T4r+FOTem4k0jI7hdVWZuot+ouASVdYNinMm0N1RjdFgX7UBT36aUAYjz1PodoLegKyFo9+cKbh74MpoFpET23bTgmL9XyU/qW8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714175; c=relaxed/simple;
	bh=264GAyXI1g58mRvjfRWBJ7nZGkCV/911vVo79ZYFvT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moMtnrin5Ub53Kk0WzglhLdcKqvuGoBTD+tOcdLRJMMrW4UwiiUTwrcJ1m7xR2OzQKjQeKp0h5ZWA0bqylpe1o8VIcoOb8ym1u9fLzpACgqMtA2X6ZBrtu3PVBeHSydTdjSoP+zl4J/bhx7yJsK91iEllLKnniMG4nKl7uSAptc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGfrOD7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGfrOD7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E7BC113D0;
	Fri, 17 Oct 2025 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714172;
	bh=264GAyXI1g58mRvjfRWBJ7nZGkCV/911vVo79ZYFvT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGfrOD7Rpf1UQTyrvVsKEbWmMxGJ0ypUGwwgtwGU5Z7P/fvwdtvYy9TT7WSOYm7kN
	 IzBctO6yjNwPrsFVM49YVmTc3qQJRSAsOMexNTwf9GbPSATobMKIJUikUhrPJnK5r6
	 KRploiflJy++6oUVWsNq0eEMzcBJBNhBvo7LwiZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/277] drm/vmwgfx: Fix copy-paste typo in validation
Date: Fri, 17 Oct 2025 16:50:59 +0200
Message-ID: <20251017145149.047108136@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
index c18dc414a047f..80e8bbc3021d1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -639,7 +639,7 @@ void vmw_validation_drop_ht(struct vmw_validation_context *ctx)
 		hash_del_rcu(&val->hash.head);
 
 	list_for_each_entry(val, &ctx->resource_ctx_list, head)
-		hash_del_rcu(&entry->hash.head);
+		hash_del_rcu(&val->hash.head);
 
 	ctx->sw_context = NULL;
 }
-- 
2.51.0



