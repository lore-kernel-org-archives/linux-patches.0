Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062244;
	b=tZQ6NMeSn6802ro41ZlSE8D4je7TUAPzXDphEOJLBPdDAzU8NhM40m0CffvHZ2KlOpxN
	 Kj3q4ujKNWKL+LL75ehE3VGlFsJxUUDh5j52tKjpp0YZXE9mFHQzIkN2Ugojbhjv6Z1ks
	 0BywvGG77mbN2ybqGdZCBBcF9Q2k+FVU4fHkyWQmWIFSW46rLdYgM+UOcWo9rJUGQms+n
	 Jww9MFIUptiNKedE96K2ZFwe2drku9N3zP4Su+fDZnh9MU0HqT6BReYW5lwCGGqWOzVyd
	 EE0lI4JPuFWBZz0ewKwaWRFmtTg0hdJr8iwxR4kXgGzdthHjeWFSLfEcJIP+LRYVSVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBKwfuVJY2UKOkx6HAVItHtCBdy4DetI5ZHRGTR/DKU=;
	b=dnX+xGt3nRmSX0Dzb45GcWC091Yeh1lgNH2r8sJHMfi8Q7NIYr3pGJ75JS53pRcsyFuQ
	 G0KdYr97nh58QKA06Hgs6EYtxwAxDOMWfnEapBns4p2ITgEBCl8vndCWTh1kTZGjcLVAJ
	 M7RJ8eQ7+TIz3MsR9wEhnCwvEVemBIJxKh7b2qxOGkHYZTScfo+FZurLigxROxiUSUzU0
	 bVS6d/uvuqnIl0yvqdo9jwP5HNNsXGlp8aY+qI/KYne85tcuDnfHNAO0nVNHUkdE7WEUX
	 jX4AuGpVv8esgsko1bb0wAkG7bU6sfHXuqH76v4ibMVhJM1axvz8Cx0ekohRf/3HzrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0glZIYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64421606A325;
	Thu, 19 Nov 2026 04:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0glZIYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFDE1F000C4;
	Thu, 19 Nov 2026 04:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062244;
	bh=iBKwfuVJY2UKOkx6HAVItHtCBdy4DetI5ZHRGTR/DKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0glZIYMU1vqDoDWV06b94EIZogI7IAtKMkAa89r2WlYgPEIsLnYEx3MGA8wDxNAg
	 IRaI91PPttlW88gBQ6hygwwl3Y49jdHba0gDP2j9j2eGJlRqohQEDYx3JujvudJG33
	 91v0u3H/uXbvUw1Sx5MGz3q8snSe7t2Iz3zWywZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 1841/1848] drm/msm/dp: always add fail-safe mode into connector mode list
Date: Wed, 18 Nov 2026 16:04:39 +0100
Message-ID: <20261118150036.639229200@linuxfoundation.org>
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

commit d4aca422539c441a7f3fec749287b36de37d9b6b upstream.

Some of DP link compliant test expects to return fail-safe mode
if prefer detailed timing mode can not be supported by mainlink's
lane and rate after link training. Therefore add fail-safe mode
into connector mode list as backup mode. This patch fixes test
case 4.2.2.1.

Changes in v2:
-- add Fixes text string

Fixes: 4b85d405cfe9 ( "drm/msm/dp: reduce link rate if failed at link training 1")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1643066274-25814-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -207,6 +207,11 @@ int dp_panel_read_sink_caps(struct dp_pa
 		if (drm_add_modes_noedid(connector, 640, 480))
 			drm_set_preferred_mode(connector, 640, 480);
 		mutex_unlock(&connector->dev->mode_config.mutex);
+	} else {
+		/* always add fail-safe mode as backup mode */
+		mutex_lock(&connector->dev->mode_config.mutex);
+		drm_add_modes_noedid(connector, 640, 480);
+		mutex_unlock(&connector->dev->mode_config.mutex);
 	}
 
 	if (panel->aux_cfg_update_done) {


