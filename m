Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062247;
	b=e2mFzATyUEO9KBUmM/OoFyNzwq4uUWr52fx5XaiNLJuz/aFBFLBy3Jiy6sHmfLovruDf
	 UWfoPZHoG0O1UZNLBowx0y+shql99vy4Bw+wMwgOsj0rQRbVCi8X6tXU0CUoSioucW08C
	 HT71vevc6aoaDUmkc0vlDo48YcJUb71Sgq2KG05ilRtifGwjH05tz+/So7Phnvj0l5bhn
	 62LaEsUZFVS7bMZicxykiwBiK99WNwut/9vZZPUZrzpKIMgD5Rgb5dNs34xTVROkXsqg0
	 FzVA/Qo/LY3L2dHf2zIsk9cVx8kVMxsbyUj6zU2VRyfoD0I07ykZ53sj6uhAzxd/okw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xNnFuD3QfjdNLoqFFsXPqy/hzdZwlkcchHXnaR9+/hk=;
	b=pDSV6KgEJHxCVz7XNbDr75zz//pP1QJQDDVo0W6ziEnH5Gr/G0yzEeIgLYudsHgTaTmw
	 KeFolU6kkIuUQbLFLJZvpT/L5zvQYwnpTKs4ogihuFUhR5PFZcZrKAOOIZ4K66WTclVxV
	 +UmGDx5tDluDZYayDC5/ewjCyPwbxzsyF4No6irOke/EJoVs52xtuvCwVp3C/nLxyS13R
	 7ZZfT14vWwl8qjPEPigD2RaCzpz376dQuy5lbLVCEoKZwH+AVjGPTscMeDuwRy/b28h/r
	 fRyjvSJQ16ja2W1r7qlByKW2qWDyo6nEH+DPfV5CvmCS77wcJUVFk4O7JLpMXOFg5EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHqK98W7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A70606A320;
	Thu, 19 Nov 2026 04:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHqK98W7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796631F000C4;
	Thu, 19 Nov 2026 04:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062247;
	bh=xNnFuD3QfjdNLoqFFsXPqy/hzdZwlkcchHXnaR9+/hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHqK98W7k3YrvPjnW12ersESHU6WCTLhda+r/s7GGljaJ2oQ8zpz4GV2weN4hhPC4
	 yqSkWwJNh1BTOqW8v5+/1WwbSsKhJ8WbWSOh/W49iz3Dpo0f/Zp/IJWTaPnd/9zFc3
	 5CaD7bkA3ctYFZ8UsIt23pwZVH4gzH7qEdmM36w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 1842/1848] drm/msm/dp: do not stop transmitting phy test pattern during DP phy compliance test
Date: Wed, 18 Nov 2026 16:04:40 +0100
Message-ID: <20261118150036.673407618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

commit 2788b4efa60c1e03ac10a156f3fdbd3be0f9198c upstream.

At normal operation, transmit phy test pattern has to be terminated before
DP controller switch to video ready state. However during phy compliance
testing, transmit phy test pattern should not be terminated until end of
compliance test which usually indicated by unplugged interrupt.

Only stop sending the train pattern in dp_ctrl_on_stream() if we're not
doing compliance testing. We also no longer reset 'p_level' and
'v_level' within dp_ctrl_on_link() due to both 'p_level' and 'v_level'
are acquired from link status at previous dpcd read and we like to use
those level to start link training.

Changes in v2:
-- add more details commit text
-- correct Fixes

Changes in v3:
-- drop unnecessary braces

Fixes: 2e0adc765d88 ("drm/msm/dp: do not end dp link training until video is ready")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/483564/
Link: https://lore.kernel.org/r/1650995939-28467-3-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1677,8 +1677,6 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_c
 		ctrl->link->link_params.rate,
 		ctrl->link->link_params.num_lanes, ctrl->dp_ctrl.pixel_rate);
 
-	ctrl->link->phy_params.p_level = 0;
-	ctrl->link->phy_params.v_level = 0;
 
 	rc = dp_ctrl_enable_mainlink_clocks(ctrl);
 	if (rc)
@@ -1802,12 +1800,6 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp
 		}
 	}
 
-	if (!dp_ctrl_channel_eq_ok(ctrl))
-		dp_ctrl_link_retrain(ctrl);
-
-	/* stop txing train pattern to end link training */
-	dp_ctrl_clear_training_pattern(ctrl);
-
 	ret = dp_ctrl_enable_stream_clocks(ctrl);
 	if (ret) {
 		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
@@ -1819,6 +1811,12 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp
 		return 0;
 	}
 
+	if (!dp_ctrl_channel_eq_ok(ctrl))
+		dp_ctrl_link_retrain(ctrl);
+
+	/* stop txing train pattern to end link training */
+	dp_ctrl_clear_training_pattern(ctrl);
+
 	/*
 	 * Set up transfer unit values and set controller state to send
 	 * video.


