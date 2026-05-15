Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E314DD6F3;
	Fri, 15 May 2026 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862427; cv=none; b=fUPJ9vUltYEa7K+ngrpIlK94wmXNqW5bCxQvbCpxHqQbrbLIr7ZB7xYe09JIgEqubtvs40FPlsEZiEafxkg6EH2KrYnhSLMCRb3S8RgLnOQco4f7sZYSdTxi/HrDA2hqaMAv86RHIk+SKy/n/J0okpxwGU9mYPOMKJhx8vtGYEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862427; c=relaxed/simple;
	bh=uJ3jJWiyIA/AWlPsZOkHdBd4fpK0CeYXaqeeZN+YSZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqDRndqayC4mEOcxEIljgLnViOZI18Q950pzDNyfUCwHbRMtWBCit5piuJUMHMu8/t6DfVPyBYouPuApSuiHc7sf56vJelz0xxf9TDD0EsKkE58+UcT1IphNpxgM9XBwhw3WBkMKsZUqXc2IydXoamd5+MpOVZmMtneQLHOmahA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Tn1R1q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Tn1R1q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2FCC2BCB0;
	Fri, 15 May 2026 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862427;
	bh=uJ3jJWiyIA/AWlPsZOkHdBd4fpK0CeYXaqeeZN+YSZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Tn1R1q/8t9NFmvpyA0sSiNySExC5DZJOBlE3vicX9bN1oTMYFZUNw3zLbW0edu+W
	 LRfTKkxxTjyxUm6tPew0byg49VLjLpGKcfaA0WQSB87FPYG2nxeuQt0ClehhhkUSaw
	 TBkjiIpvQxxx6g8Lbf/Tlikw/OnAEkAPnfNq3f6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 7.0 008/201] drm/msm/hdmi: Fix wrong CTRL1 register used in writing info frames
Date: Fri, 15 May 2026 17:47:06 +0200
Message-ID: <20260515154658.718568888@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

commit 8c6c93b7db42d15c6e8c2540a648d32986a04b1a upstream.

Commit 384d2b03d0a1 ("drm/msm/hdmi: make use of the drm_connector_hdmi
framework") changed the unconditional register writes in few places to
updates: read, apply mask, write.  The new code reads
REG_HDMI_INFOFRAME_CTRL1 register, applies fields/mask for
HDMI_INFOFRAME_CTRL0 register and finally writes to
HDMI_INFOFRAME_CTRL0.  This difference between CTRL1 and CTRL0 looks
unintended and may result in wrong data being written to HDMI bridge
registers.

Cc: <stable@vger.kernel.org>
Fixes: 384d2b03d0a1 ("drm/msm/hdmi: make use of the drm_connector_hdmi framework")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/711156/
Link: https://lore.kernel.org/r/20260311191620.245394-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -153,7 +153,7 @@ static int msm_hdmi_bridge_write_avi_inf
 	for (i = 0; i < ARRAY_SIZE(buf); i++)
 		hdmi_write(hdmi, REG_HDMI_AVI_INFO(i), buf[i]);
 
-	val = hdmi_read(hdmi, REG_HDMI_INFOFRAME_CTRL1);
+	val = hdmi_read(hdmi, REG_HDMI_INFOFRAME_CTRL0);
 	val |= HDMI_INFOFRAME_CTRL0_AVI_SEND |
 		HDMI_INFOFRAME_CTRL0_AVI_CONT;
 	hdmi_write(hdmi, REG_HDMI_INFOFRAME_CTRL0, val);
@@ -193,7 +193,7 @@ static int msm_hdmi_bridge_write_audio_i
 		   buffer[9] << 16 |
 		   buffer[10] << 24);
 
-	val = hdmi_read(hdmi, REG_HDMI_INFOFRAME_CTRL1);
+	val = hdmi_read(hdmi, REG_HDMI_INFOFRAME_CTRL0);
 	val |= HDMI_INFOFRAME_CTRL0_AUDIO_INFO_SEND |
 		HDMI_INFOFRAME_CTRL0_AUDIO_INFO_CONT |
 		HDMI_INFOFRAME_CTRL0_AUDIO_INFO_SOURCE |


