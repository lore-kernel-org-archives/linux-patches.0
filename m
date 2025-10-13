Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EC530F956;
	Mon, 13 Oct 2025 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369697; cv=none; b=XZRYXs6efVUhmD25q7LO8rIXPDcPMr4PyU2cYo2IUklOkZoiAnG1ob3+P4tfhFFzwKGcBf4150adMCRK/nMLYb5l7IlxMlJf9XoHtqIMq6Q6wcg8Tq7k2cxhxdTUeL4V7uGg6bx7hFZyR/50rfzVKE902KrbNEesuDQ4gYP9Lik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369697; c=relaxed/simple;
	bh=Pq20Y1oxr1hARxPEYUTUxsPbhns0xqnnCZnN4/AIt6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szqQEWySryFpeqenBqywwT9d3TPy6x3WIR8qLOS9W9JxxeMPk0jcQXFGi0oGWqsze7o8X54UY4pntiiT65e2KdzRd6xJQKOOpJ6AyrD0lrBVVnFWTYtqmwZ3jTq2KPIZHMdoTaxS22zDlUTm7s3oKf3FFKIsQvKq9UBRyAq1Vu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYiD7XNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYiD7XNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FC2C4CEE7;
	Mon, 13 Oct 2025 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369697;
	bh=Pq20Y1oxr1hARxPEYUTUxsPbhns0xqnnCZnN4/AIt6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYiD7XNG44NJ+QotRo/wZqURnTP4P3EPr7dsdTqtTdkb6D7xgUjo1Fo7X9aEdONxW
	 Fu6KjG9rcN9bbHcKqlOGkvODoykVtlFmOM58pIypwrm/IBmFbqcY8NUjBJ38fWTF8q
	 jzo6YrNDwEs7exa6kYrg6SxfkWSV0/5bZfacpLUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 336/563] drm/msm/dpu: fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:43:17 +0200
Message-ID: <20251013144423.442505597@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 88ec0e01a880e3326794e149efae39e3aa4dbbec ]

Change 'ret' from unsigned long to int, as storing negative error codes
in an unsigned long makes it never equal to -ETIMEDOUT, causing logical
errors.

Fixes: d7d0e73f7de3 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/671100/
Link: https://lore.kernel.org/r/20250826092047.224341-1-rongqianfeng@vivo.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 56a5b596554db..46f348972a975 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -446,7 +446,7 @@ static void _dpu_encoder_phys_wb_handle_wbdone_timeout(
 static int dpu_encoder_phys_wb_wait_for_commit_done(
 		struct dpu_encoder_phys *phys_enc)
 {
-	unsigned long ret;
+	int ret;
 	struct dpu_encoder_wait_info wait_info;
 	struct dpu_encoder_phys_wb *wb_enc = to_dpu_encoder_phys_wb(phys_enc);
 
-- 
2.51.0



