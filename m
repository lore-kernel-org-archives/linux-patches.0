Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEC51B3942;
	Mon, 23 Dec 2024 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970044; cv=none; b=mizj6ZORVzzQPvyh/2avQ+vCERROtAbn+V21ei0pzqinhpfikBf/zW9PaoUE6gTSHebH0wEYY0bzKYgqQ9w6SFf7PhB2VIObS0rESh+N5za3lX/Pt1F7hyvX7Y1Fn3VRYxacYAMsbH8YLVUPRqKcEg3WbrotXQSRO12T+ucFdJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970044; c=relaxed/simple;
	bh=IMKBBwt2Hn9xoZXoq5LjlqVMpajwo+uHZX1hB5gHb4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSzBUFh/8Qh34/kue2TNv1rj7RV3R0grW/IWCDOP7ecNZYUOcSB5TgXF0axrb0XVSrjKwwWjhJwZlyge7XUXPE0iKWdGGq0gOd/0uZXahgjDPdGLvj8VqA/S1gQsZABRuYuAcbZFdXdWk5Fhh7IFU4ztbb1bidjeWHWqvr/Z5MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvV9ZUfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvV9ZUfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF52C4CED4;
	Mon, 23 Dec 2024 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970043;
	bh=IMKBBwt2Hn9xoZXoq5LjlqVMpajwo+uHZX1hB5gHb4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvV9ZUfL4KPx5U4u/CEMqPXxS8IEhBN/hNmlMuRTIm7zVJYwBGQRk4G1p7a/APe5F
	 x6AgMDEQXBR9kHoKFTSM4MqSVBwVjJTsWUE/0IDmgBN4Q2TEXfFj+ltD2jeKT8H2mW
	 UEWyoXSd43PIflVPA9Qh/ym/YHk2hC9omsdY/fto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 128/160] accel/ivpu: Fix general protection fault in ivpu_bo_list()
Date: Mon, 23 Dec 2024 16:58:59 +0100
Message-ID: <20241223155413.732331420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 4b2efb9db0c22a130bbd1275e489b42c02d08050 upstream.

Check if ctx is not NULL before accessing its fields.

Fixes: 37dee2a2f433 ("accel/ivpu: Improve buffer object debug logs")
Cc: stable@vger.kernel.org # v6.8
Reviewed-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210130939.1575610-2-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -406,7 +406,7 @@ static void ivpu_bo_print_info(struct iv
 	mutex_lock(&bo->lock);
 
 	drm_printf(p, "%-9p %-3u 0x%-12llx %-10lu 0x%-8x %-4u",
-		   bo, bo->ctx->id, bo->vpu_addr, bo->base.base.size,
+		   bo, bo->ctx ? bo->ctx->id : 0, bo->vpu_addr, bo->base.base.size,
 		   bo->flags, kref_read(&bo->base.base.refcount));
 
 	if (bo->base.pages)


