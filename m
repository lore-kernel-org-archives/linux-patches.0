Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999752D7D3A;
	Fri, 17 Oct 2025 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715074; cv=none; b=YNYdKmjSCHww+P2AJ9e8jY+EZCE7ElrpQ+HPo9UA/NI383WeHOmZB1CV84s5jjviuHuzh24B/muyBjdot2TwnAjHU6ubauuATOPeqQ2adLOHSSCqoCKKCYEyBkMBeg2mZWth1xBDmvZFxzlUhkWP52hHxCf43lRw3PtjKuvY9lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715074; c=relaxed/simple;
	bh=bQ9Ip8OMrzWXaCCNueT+VYbztdbJuMkPjljbB0TVol4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDOR2gqjKebSWhT6yIS6gvtkGv/ql8/Uzoykyqun+1cQM7VFElp7HpN/ZnK0qYpYbX5P4iM/6W+GfWzVQd20cmQM6arDA0GjafybXJhYLXHYW9FwVyHssZTkN8w00VhX4RD31vKEGQMS6rAqy75K1xMzb/phsJ3EdTCOBVMUfsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui89dojH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui89dojH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C0CC4CEE7;
	Fri, 17 Oct 2025 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715073;
	bh=bQ9Ip8OMrzWXaCCNueT+VYbztdbJuMkPjljbB0TVol4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ui89dojH+3GqHIshqco1Sr/EkfM1vvQqltc1RfTInHEzd3EXuoGu2wgUbe4d4VgZv
	 R21unleg2HOprR12F5WYCyGPnhzjlJuR0ErMEH5aY5yHt0c38syNSe0Y8Z5bu2juTx
	 Zw23VfNZZBk9bSQi047OTuQ6ArVG14bSQsSSsxUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 087/371] drm/vmwgfx: Fix copy-paste typo in validation
Date: Fri, 17 Oct 2025 16:51:02 +0200
Message-ID: <20251017145205.087024385@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4d0fb71f62111..35dc94c3db399 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -638,7 +638,7 @@ void vmw_validation_drop_ht(struct vmw_validation_context *ctx)
 		hash_del_rcu(&val->hash.head);
 
 	list_for_each_entry(val, &ctx->resource_ctx_list, head)
-		hash_del_rcu(&entry->hash.head);
+		hash_del_rcu(&val->hash.head);
 
 	ctx->sw_context = NULL;
 }
-- 
2.51.0



