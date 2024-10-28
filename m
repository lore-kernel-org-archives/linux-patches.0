Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7506217109B;
	Mon, 28 Oct 2024 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098047; cv=none; b=um45WNgkfXz3NNJGp/0Eu6Nv8mEUyHP6KmXWrAawEhaVh96KWzgDpXWIFaqNqQhhZ9e6Q4z1dFDO2WJKPP+DTQ3NzASGKQjAZADyqe+f5tdw2D2qDl2iENveuht/eDpwmixymFECODphsHbY/do5Q7uHc4W0MeAlO2y415ZwC9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098047; c=relaxed/simple;
	bh=M8inTOKqkacgbDrWmHhjPH/S0vHs9DFFq5EbAAMIqAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDiDH5RJDZ1mfDhqUdbbJxzJItm/ZzqgPdBlUkxgUDQpoxmhQNWEHrOJeJWj0FNxR73X4kCSUZlODBlEs5KuTKDKDPXqmlzC/yEex4ABy2VDDUx1R6qqzKGc+AwIXBrJBIX5MNtfU3SS/qsT243WTH4it6tcRuTqqZJEmWUMof4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0H6CxnS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0H6CxnS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094ECC4CEC3;
	Mon, 28 Oct 2024 06:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098047;
	bh=M8inTOKqkacgbDrWmHhjPH/S0vHs9DFFq5EbAAMIqAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0H6CxnS6fUcGOtoKFIHY/eiCXRhnIZhXfDuDyXBDaMIfyRSWZxXjNzTOct8CK8LqS
	 jlqfGgu4rUGdtQnXl43J0Gr76shUdZhHvnUUXEBL5gGRiPNYh2S8JZbJn1hwwmCvwY
	 udnNakz79NlU8+TskRYvxZtN9t/I/AD9/bgqYvOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 053/261] drm/msm/dsi: improve/fix dsc pclk calculation
Date: Mon, 28 Oct 2024 07:23:15 +0100
Message-ID: <20241028062313.345327657@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 24436a540d16ca6a523b8e5441180001c31b6b35 ]

drm_mode_vrefresh() can introduce a large rounding error, avoid it.

Fixes: 7c9e4a554d4a ("drm/msm/dsi: Reduce pclk rate for compression")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/618432/
Link: https://lore.kernel.org/r/20241007050157.26855-1-jonathan@marek.ca
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 185d7de0bf376..1205aa398e445 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -542,7 +542,7 @@ static unsigned long dsi_adjust_pclk_for_compression(const struct drm_display_mo
 
 	int new_htotal = mode->htotal - mode->hdisplay + new_hdisplay;
 
-	return new_htotal * mode->vtotal * drm_mode_vrefresh(mode);
+	return mult_frac(mode->clock * 1000u, new_htotal, mode->htotal);
 }
 
 static unsigned long dsi_get_pclk_rate(const struct drm_display_mode *mode,
-- 
2.43.0



