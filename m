Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BE53EA9A;
	Wed,  7 Aug 2024 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042909; cv=none; b=E/oXmLu+64/6lOM7/VFzb6dL/O62Azxf7VT66CnXmrPYE/VCg3dp1dwsBGgapoq7TbFV8vUR+0NQULrI9H9hkKuWqqa/GUG/UDSGuz3NCLHlSB00lhj/+4HlM4KeAQ+epIT3ma+nTCCYEgUzUElJMn1jQ7l8EDuuwUphjO9dA5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042909; c=relaxed/simple;
	bh=y+ucpysC0nwBLeT/p00XhA5kS10clnHfPdINKTQAFsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BriKMPBRIIFuvAigAh5CS38+UT8i/POHjQmJQouxwnTIFDAvlTKv5CJ1RvQixv/8RA1bpPRtCeFuFonHljd5mLVPcQyUU1Xor9TjwRYMfrsv8zaCGWEVQ7SsQISXmwc+23b6esYxM5lLlGUDrMQA9lHGVD0PZL+Bj8hRtIZdv6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyFchj0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyFchj0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF7DC32781;
	Wed,  7 Aug 2024 15:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042909;
	bh=y+ucpysC0nwBLeT/p00XhA5kS10clnHfPdINKTQAFsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyFchj0YreB6mZ8uFlTEKeSBu7XU2x6uvdpYJqf1jzdrM4vtRL73uZonxouSc+AjK
	 ZvfFGlOCDvX7ZdzoUuTQ7RvToBiwAAxY8nhZLKfJWxacqMa7Rda5l2BFPP1dtNOhhh
	 TaRyU3Swj4qHj/tHSYIIUxRW5EhbLT73OXeyZU4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 020/123] drm/gpuvm: fix missing dependency to DRM_EXEC
Date: Wed,  7 Aug 2024 16:58:59 +0200
Message-ID: <20240807150021.473582546@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@redhat.com>

[ Upstream commit eeb1f825b5dc68047a0556e5ae86d1467920db41 ]

In commit 50c1a36f594b ("drm/gpuvm: track/lock/validate external/evicted
objects") we started using drm_exec, but did not select DRM_EXEC in the
Kconfig for DRM_GPUVM, fix this.

Cc: Christian König <christian.koenig@amd.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 50c1a36f594b ("drm/gpuvm: track/lock/validate external/evicted objects")
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240715135158.133287-1-dakr@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 359b68adafc1b..79628ff837e6f 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -253,6 +253,7 @@ config DRM_EXEC
 config DRM_GPUVM
 	tristate
 	depends on DRM
+	select DRM_EXEC
 	help
 	  GPU-VM representation providing helpers to manage a GPUs virtual
 	  address space
-- 
2.43.0



