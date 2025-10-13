Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FB130BF54;
	Mon, 13 Oct 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367782; cv=none; b=VjzW2EM5+htdfxdv0Qxp6M2YtsYDhbZIgtnX9hQ1GmYeCz9Xcnb1ACuKQNT942/n9z/uv7x8HEi5J6y+zVnI/Mjf92s1WGxGvutfHrzbYegOGYDouGmyMieYH87iozXXd0+zKA5NYw8t7RpC488G5TGp52xIhwDB4zju+Sc1moQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367782; c=relaxed/simple;
	bh=PCjItww/6P8Ldd/+Xzy/ip2/7ybv7kKMbRZ2hT1/lng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhvKwiHkujjaGV/jMiROA3E++/vnVRO3ouFdpRQrmBwG0mfHKH52YMqLPQU6IRSvIWViGshnHZwB2iVj8mNBaVouIco7WGPLxfeVJdYAE61zHJ0JD3Z+2CTrUO/op24ZyF5gQ9Rz9CjC5/RPeKknMUPpAAm3VtoZOzfFIbmE7n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nz04NYjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nz04NYjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFB8C4CEE7;
	Mon, 13 Oct 2025 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367781;
	bh=PCjItww/6P8Ldd/+Xzy/ip2/7ybv7kKMbRZ2hT1/lng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nz04NYjsmWGTiWlzDC01+NU8YKUeUbQCVyQQbBhloDOhg9Eb0QtQAmaHfj2h5yg1B
	 RNB1ho5NMOtN9sLZ1xJmAyIkwjWqmNZCrMeya0Y/ORKvX7YGXNxzMYEV5ZSjZC89Ne
	 yYoacMZrCLT9LkYdgYiV0z4Y0djHP4sv+31nXGCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/196] drm/msm/dpu: fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:44:55 +0200
Message-ID: <20251013144319.076984264@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index 0a45c546b03f2..a5cd41c9224d7 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -433,7 +433,7 @@ static void _dpu_encoder_phys_wb_handle_wbdone_timeout(
 static int dpu_encoder_phys_wb_wait_for_commit_done(
 		struct dpu_encoder_phys *phys_enc)
 {
-	unsigned long ret;
+	int ret;
 	struct dpu_encoder_wait_info wait_info;
 	struct dpu_encoder_phys_wb *wb_enc = to_dpu_encoder_phys_wb(phys_enc);
 
-- 
2.51.0



