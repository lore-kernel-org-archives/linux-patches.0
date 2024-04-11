Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8C1146D49;
	Thu, 11 Apr 2024 10:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831456; cv=none; b=HHU43gOZX+S+EistayRUEkkCPtJ7UPTw69vxZnUcE6Tk4bsq37Xccs9EA2/QG9D13aWlCbR5b4HbgKru9Jx4/qJ6xER3DICqPDer4RHdWYXIFfDELyYxJQdZfZ6OV9Xzqv8fv1pdaS6bK5hd7AWy04sZ4yf8b9fOLIXnKUNgnU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831456; c=relaxed/simple;
	bh=AznrDmZsB01ocltvXnm1LMBuraj9Gty6MlWKyV2qe8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uZpqt4sWKivtd1MAFFS0O9pk+QKNpdMdHLaeezERBZFu8kLhahZMkbI3mmOXK67oUKCLl6fMWE/GzNScTRlpLA/r6aCh4wRQlxeCICPNjnzVjnbSrtXpcaBFbteu+neE1NrPmpPFWVLpu2PPRwbfOnvclKBbtivZ/tjXui9dz/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYml3aJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYml3aJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D5FC43390;
	Thu, 11 Apr 2024 10:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831456;
	bh=AznrDmZsB01ocltvXnm1LMBuraj9Gty6MlWKyV2qe8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYml3aJNEbxonNDgTK0TDYwQMlM/xhJvY94R2FQ2wk+XJQUsl9G6y77zmqzPaQhpp
	 c6GmlzXDx8fkZ8UK2zxXTlmMFfDJrbr+xx1TfUl701I3Blc51DQ62jyuFtgsuK5xBk
	 PnnuJBQyI9/Wz/3JFqQppancrkVBfm9VlY7j2jnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VMware Graphics <linux-graphics-maintainer@vmware.com>,
	Roland Scheidegger <sroland@vmware.com>,
	Zack Rusin <zackr@vmware.com>,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/294] drm/vmwgfx/vmwgfx_cmdbuf_res: Remove unused variable ret
Date: Thu, 11 Apr 2024 11:52:58 +0200
Message-ID: <20240411095436.093960798@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 43ebfe61c3928573a5ef8d80c2f5300aa5c904c0 ]

Fixes the following W=1 kernel build warning(s):

 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c: In function ‘vmw_cmdbuf_res_revert’:
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c:162:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]

Cc: VMware Graphics <linux-graphics-maintainer@vmware.com>
Cc: Roland Scheidegger <sroland@vmware.com>
Cc: Zack Rusin <zackr@vmware.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210115181313.3431493-40-lee.jones@linaro.org
Stable-dep-of: 517621b70600 ("drm/vmwgfx: Fix possible null pointer derefence with invalid contexts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
index 44d858ce4ce7f..47b92d0c898a7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
@@ -160,7 +160,6 @@ void vmw_cmdbuf_res_commit(struct list_head *list)
 void vmw_cmdbuf_res_revert(struct list_head *list)
 {
 	struct vmw_cmdbuf_res *entry, *next;
-	int ret;
 
 	list_for_each_entry_safe(entry, next, list, head) {
 		switch (entry->state) {
@@ -168,8 +167,7 @@ void vmw_cmdbuf_res_revert(struct list_head *list)
 			vmw_cmdbuf_res_free(entry->man, entry);
 			break;
 		case VMW_CMDBUF_RES_DEL:
-			ret = drm_ht_insert_item(&entry->man->resources,
-						 &entry->hash);
+			drm_ht_insert_item(&entry->man->resources, &entry->hash);
 			list_del(&entry->head);
 			list_add_tail(&entry->head, &entry->man->list);
 			entry->state = VMW_CMDBUF_RES_COMMITTED;
-- 
2.43.0



