Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA44C2BE653;
	Tue, 26 Aug 2025 11:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207634; cv=none; b=pCzL1MU/k32Rok17d9KmJKRM/nJB++VE8Qx6pqb+xmKH0+tjnhchIj9+d7EUeMUa+WwVonQ6uxuVVfl5DaPJadXNfMwi6kpUZXHBrhcfqQlXSK6K5MpO+vmhRu3oNXIVbGJtQiaFvO6Kg8kOpXadbA4jbi+0HU6XGeEzcLN6VNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207634; c=relaxed/simple;
	bh=F8N0boz53m4NEFlwktTJZDORu3e189P9f4Zk8t0ZHyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VItyhJiBvsaZgJW0i1kc9yMif6YyzpfUhcVNYmR855q0rq/rnowCMkKonIhdJoopYDN8TJ4zDomiLApErZodwu8WVMaKta/l/utnEeCojPrPpVIk/mh10eXdOPNyg7wrm/VVb/y+xT3NfdYrvpKdqmXYlxS4hcV1fjUKOWGXiDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzqeVSwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzqeVSwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5AAC4CEF1;
	Tue, 26 Aug 2025 11:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207634;
	bh=F8N0boz53m4NEFlwktTJZDORu3e189P9f4Zk8t0ZHyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzqeVSwaDh/McubqPcCfPfZKgyCTQw10Enh2ChKnOUxCBDkGCjNgZsa8a8bkWZJKT
	 /ZT9QJcN5ePoyLfSjpImH2X/VSm16g4obr8KhUI3z03H6IxnvT2VrP5j4MST1UMAue
	 MLbDVygvV3oHZlHC1Umy4E3Hyp61/vmEqrq8Zqgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.16 259/457] drm/nouveau/gsp: fix mismatched alloc/free for kvmalloc()
Date: Tue, 26 Aug 2025 13:09:03 +0200
Message-ID: <20250826110943.755505792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit 989fe6771266bdb82a815d78802c5aa7c918fdfd upstream.

Replace kfree() with kvfree() for memory allocated by kvmalloc().

Compile-tested only.

Cc: stable@vger.kernel.org
Fixes: 8a8b1ec5261f ("drm/nouveau/gsp: split rpc handling out on its own")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Timur Tabi <ttabi@nvidia.com>
Acked-by: Zhi Wang <zhiw@nvidia.com>
Link: https://lore.kernel.org/r/20250813125412.96178-1-rongqianfeng@vivo.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
index 9d06ff722fea..0dc4782df8c0 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
@@ -325,7 +325,7 @@ r535_gsp_msgq_recv(struct nvkm_gsp *gsp, u32 gsp_rpc_len, int *retries)
 
 		rpc = r535_gsp_msgq_peek(gsp, sizeof(*rpc), info.retries);
 		if (IS_ERR_OR_NULL(rpc)) {
-			kfree(buf);
+			kvfree(buf);
 			return rpc;
 		}
 
@@ -334,7 +334,7 @@ r535_gsp_msgq_recv(struct nvkm_gsp *gsp, u32 gsp_rpc_len, int *retries)
 
 		rpc = r535_gsp_msgq_recv_one_elem(gsp, &info);
 		if (IS_ERR_OR_NULL(rpc)) {
-			kfree(buf);
+			kvfree(buf);
 			return rpc;
 		}
 
-- 
2.50.1



