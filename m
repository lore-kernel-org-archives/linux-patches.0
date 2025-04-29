Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC622472AA;
	Tue, 29 Apr 2025 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945186; cv=none; b=LWlyNVgDn3ewTtiEE9eJeeI40w9Rlcdrmi15bw5PU/lfcWcSiL4pJ8jJGkEvN4wxfu3SzeBQ3zrjDCCvOLsrOxveZ6CJA4fEi6ZxGutLZQCuomYdiU6BECggLadunPc56vZ1b81hb7vqP3z9utAT5inClfZ1pWCmXIgHWBtgljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945186; c=relaxed/simple;
	bh=af+EClVFof0VuKdfe1wqWwl+8h6SqL6TayjQiatMHEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkJ12PAcsUgdnPsDO83RQ5xid1j5zKG9QgBPJVaO7z8NBLqMTucDgW2SGciSiVuQmzhDdO0ZCnnthVUqni1tIpMKFAd15YYMQeF8dBHGtCNMscPH0ZCW/LrqDwL7kwTpXEaI4CckLVoBWmInvVecioyO75+fEGZdCA30ajUm70I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojFQEMD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojFQEMD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF22C4CEF1;
	Tue, 29 Apr 2025 16:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945186;
	bh=af+EClVFof0VuKdfe1wqWwl+8h6SqL6TayjQiatMHEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojFQEMD5wICq4KWbPjbHrmhjEyhLsugBWwM/FtFEZG9YAV2isMBbzMVj/FnxYlznt
	 Njy3tV0Tv3lsirdce40MnA9537A1BFEXZrlyXWvna/msmgfn1HMOIcj3duPcVZ++4L
	 D4xRTxdLZi4n7wtSTctIWlJMBnrTf6YA2uD7d2N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/179] drm: allow encoder mode_set even when connectors change for crtc
Date: Tue, 29 Apr 2025 18:39:31 +0200
Message-ID: <20250429161050.633702989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 7e182cb4f5567f53417b762ec0d679f0b6f0039d ]

In certain use-cases, a CRTC could switch between two encoders
and because the mode being programmed on the CRTC remains
the same during this switch, the CRTC's mode_changed remains false.
In such cases, the encoder's mode_set also gets skipped.

Skipping mode_set on the encoder for such cases could cause an issue
because even though the same CRTC mode was being used, the encoder
type could have changed like the CRTC could have switched from a
real time encoder to a writeback encoder OR vice-versa.

Allow encoder's mode_set to happen even when connectors changed on a
CRTC and not just when the mode changed.

Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241211-abhinavk-modeset-fix-v3-1-0de4bf3e7c32@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index d91d6c063a1d2..70d97a7fc6864 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1225,7 +1225,7 @@ crtc_set_mode(struct drm_device *dev, struct drm_atomic_state *old_state)
 		mode = &new_crtc_state->mode;
 		adjusted_mode = &new_crtc_state->adjusted_mode;
 
-		if (!new_crtc_state->mode_changed)
+		if (!new_crtc_state->mode_changed && !new_crtc_state->connectors_changed)
 			continue;
 
 		DRM_DEBUG_ATOMIC("modeset on [ENCODER:%d:%s]\n",
-- 
2.39.5



