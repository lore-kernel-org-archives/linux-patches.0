Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547D632E14D;
	Fri, 17 Oct 2025 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713922; cv=none; b=A2TKdRqZBbv9HUZ/axcP6M94WP+kRERX3koCThmSUN2Xe17+yOxTbHaZwDXVWaFQgFwen5FkC907KKF04rHi/Ymtzey/Q2C1AUXcZxqQuhvdxA8SzRUES+XNa52PCEyLho1B1QQHI2vSFFA/TIaAc28upU8vTHbq/8O8VBX5XoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713922; c=relaxed/simple;
	bh=VA/T5qYnkltO+eRKczHF4pkcv/zPbBm9auJneJYRTAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC1LuA8qZa0Ar7fYvVg402jKR7wyJn/qkuVFHq/z0pOqXCtng26N5SR5xxWVbeYTldOIfRzvD/OLeSKuQG4UqFPHOjOlrm9WiBXLH9JmT3QbWfBWlnLvCR4H1Xm4GRbcqRTeXb4EFaYCuESI7nyFkjyayJGrXmyVbUpvha3ouzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iReBTUU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iReBTUU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE4AC113D0;
	Fri, 17 Oct 2025 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713922;
	bh=VA/T5qYnkltO+eRKczHF4pkcv/zPbBm9auJneJYRTAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iReBTUU+PGp2DR9yf7fFKyjoHCS8eIFuPY2piiCKCYJQlhHD/dtqYHWbGV5egw4wV
	 CaRy5F7pDilpeK4Y4cVd5IgIx5tRgljZMBhoq27fL9LWW+QUiMQn+kz6kTz2Aen09C
	 5yW8fR4S26kLarTDFscMI/korlqg/sdM9c89FZbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/201] misc: fastrpc: Add missing dev_err newlines
Date: Fri, 17 Oct 2025 16:53:48 +0200
Message-ID: <20251017145140.873642145@linuxfoundation.org>
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

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

[ Upstream commit a150c68ae6369ea65b786fefd0b8aa0b075c041a ]

Few dev_err calls are missing newlines. This can result in unrelated
lines getting appended which might make logs difficult to understand.
Add trailing newlines to avoid this.

Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240705075900.424100-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8b5b456222fd ("misc: fastrpc: Save actual DMA size in fastrpc_map structure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -325,7 +325,7 @@ static void fastrpc_free_map(struct kref
 			err = qcom_scm_assign_mem(map->phys, map->size,
 				&src_perms, &perm, 1);
 			if (err) {
-				dev_err(map->fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d",
+				dev_err(map->fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d\n",
 						map->phys, map->size, err);
 				return;
 			}
@@ -808,7 +808,7 @@ static int fastrpc_map_attach(struct fas
 		map->attr = attr;
 		err = qcom_scm_assign_mem(map->phys, (u64)map->size, &src_perms, dst_perms, 2);
 		if (err) {
-			dev_err(sess->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d",
+			dev_err(sess->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d\n",
 					map->phys, map->size, err);
 			goto map_err;
 		}
@@ -1240,7 +1240,7 @@ static bool is_session_rejected(struct f
 		 * that does not support unsigned PD offload
 		 */
 		if (!fl->cctx->unsigned_support || !unsigned_pd_request) {
-			dev_err(&fl->cctx->rpdev->dev, "Error: Untrusted application trying to offload to signed PD");
+			dev_err(&fl->cctx->rpdev->dev, "Error: Untrusted application trying to offload to signed PD\n");
 			return true;
 		}
 	}
@@ -1304,7 +1304,7 @@ static int fastrpc_init_create_static_pr
 							&src_perms,
 							fl->cctx->vmperms, fl->cctx->vmcount);
 			if (err) {
-				dev_err(fl->sctx->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d",
+				dev_err(fl->sctx->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d\n",
 					fl->cctx->remote_heap->phys, fl->cctx->remote_heap->size, err);
 				goto err_map;
 			}
@@ -1358,7 +1358,7 @@ err_invoke:
 						(u64)fl->cctx->remote_heap->size,
 						&src_perms, &dst_perms, 1);
 		if (err)
-			dev_err(fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d",
+			dev_err(fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d\n",
 				fl->cctx->remote_heap->phys, fl->cctx->remote_heap->size, err);
 	}
 err_map:


