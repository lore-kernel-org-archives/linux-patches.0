Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215754;
	b=qRFhhOcZ8kn75OeAWIgj5CtcPEIqQJKPAeKcizG0WI8c5xkWaYgWQOEIXyUIbtBKYXhg
	 yjpR39Br2jaI3xcgJqszAbSwDdOOhn8CMUZyMbTXbD0GCVcRt+97cjq4Vx2Pv4mQiuskk
	 y7t1wpbKH0+Gohu8XR0x/5gbIpNvuOiNqOQ6mtE1S9DBZleLEYMKFwFi0OVGSIdLP6buS
	 ED5UKPOOu8kGEaZDN8zHCOvvifXaRPf61eAz0uG2XSla7E8IKa+Am80u6JIVB3UtQZO+M
	 N2s9UUDAG5Grxj9i0ux3QyqUTX5soJaD+Nozxo/CAlyAqgEq5T2FzyYKnmzstoOPzrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCDMFA4J9U8pf3T+Ygtxm9+Ap+7+YOJzJh3wAT6sFG8=;
	b=Y5VvzNJEbJYtF0tEIl/tTopnqJASQ6eiEWCHEUGGTtRU+CbFbM6I6GoVDg88Ry1hwAdG
	 TEsNSXVBPJ6o9rNf3BF3lSAWwxstIbyQRLhXXTjUNfvrGnnCtkbyuAq0yRvEEwpDfK2qq
	 7rOreurtkfDkC46JsEYSGPpLBKkRH15CObnMe/kNQa+uDwjHXLDPG9PoNM/jpL9tsKvUP
	 2KsO5je8e5xBRsa2T5ModY+3u0+sH9BR+B1x2gnbTVQWaUMM+ACMFuiyu6D2Y12468fFr
	 n16twOlgqKFmxLVxLlGxaDM1jYBRwJlP0VJoEirdzbxdCuZF4H5IuVpRNI7u17W0tCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1vYL37K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E448606A32A;
	Wed, 28 Oct 2026 19:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1vYL37K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA13F1F01825;
	Wed, 28 Oct 2026 19:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215754;
	bh=FCDMFA4J9U8pf3T+Ygtxm9+Ap+7+YOJzJh3wAT6sFG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1vYL37KFEPcJHAXm9n5Y1RqKVqYRDLMCigrVcQJ/8mcvJ9tdBTvw7+qNa3ymKKPE
	 h2FB5hertMbI7LXF2ZDF1+YuQ4BQnNP0UXQdd76cz2hBRCKROaNwzcSURMxPf/Dz5o
	 eZAbuB+n8MoiGlMmEaZnmjY6KLcFzDfme95XP51M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1278/1887] drm/vmwgfx: reject DX_BIND_QUERY without a DX context
Date: Wed, 28 Oct 2026 17:56:14 +0100
Message-ID: <20261028170528.505650450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 55ec09c9ce10b1272802c7ab6c1be2ea0dbc68db ]

vmw_cmd_dx_bind_query() unconditionally dereferences
sw_context->dx_ctx_node->ctx.  Userspace can trigger a NULL pointer
dereference from any render-node fd by submitting an execbuf with
dx_context_handle == SVGA3D_INVALID_ID and a SVGA_3D_CMD_DX_BIND_QUERY
opcode in the command stream: dx_ctx_node is left NULL and the kernel
oopses on the assignment.  The same NULL is then re-read in
vmw_resources_reserve() via vmw_context_get_dx_query_mob().

All sibling DX handlers fail-close on a missing dx_ctx_node using
VMW_GET_CTX_NODE().  Use the same pattern here, returning -EINVAL up
front before any relocation state is published.

Fixes: 9c079b8ce8bf ("drm/vmwgfx: Adapt execbuf to the new validation api")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-3-zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index ef2ee93f5e343..1be89105fc6ef 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1282,9 +1282,13 @@ static int vmw_cmd_dx_bind_query(struct vmw_private *dev_priv,
 				 SVGA3dCmdHeader *header)
 {
 	VMW_DECLARE_CMD_VAR(*cmd, SVGA3dCmdDXBindQuery);
+	struct vmw_ctx_validation_info *ctx_node = VMW_GET_CTX_NODE(sw_context);
 	struct vmw_buffer_object *vmw_bo;
 	int ret;
 
+	if (!ctx_node)
+		return -EINVAL;
+
 	cmd = container_of(header, typeof(*cmd), header);
 
 	/*
@@ -1298,7 +1302,7 @@ static int vmw_cmd_dx_bind_query(struct vmw_private *dev_priv,
 		return ret;
 
 	sw_context->dx_query_mob = vmw_bo;
-	sw_context->dx_query_ctx = sw_context->dx_ctx_node->ctx;
+	sw_context->dx_query_ctx = ctx_node->ctx;
 	return 0;
 }
 
-- 
2.53.0



