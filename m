Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DC411710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0B9C433C7;
	Mon, 11 Sep 2023 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445204;
	bh=eFKKE67VGLkVvTWJUzb0woVI9Qis7y2DecCdja1Nm88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rw59T4R6xfLY+CHjKkqav7RSYh3JAa2IEnt/82YeLQ8jb9AaCd9DldcqOuXhK+wEw
	 OtgqAq66EYSrzyh0q+ZD/vWztON/JaPyjyfICso2HSRb73kczgRuPmwQ7mgKRMqysK
	 0Qzi3vJQbYtU/CMyendeGyeokuEaH0ekRnFuSUbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/600] drm/bridge: anx7625: Use common macros for HDCP capabilities
Date: Mon, 11 Sep 2023 15:44:58 +0200
Message-ID: <20230911134641.431302180@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 41639b3a8b0f1f194dfe0577d99db70613f78626 ]

The DRM DP code has macros for the DP HDCP capabilities. Use them in the
anx7625 driver instead of raw numbers.

Fixes: cd1637c7e480 ("drm/bridge: anx7625: add HDCP support")
Suggested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230710091203.1874317-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 36ec9dedadfe1..cf86cc05b7fca 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -874,11 +874,11 @@ static int anx7625_hdcp_enable(struct anx7625_data *ctx)
 	}
 
 	/* Read downstream capability */
-	ret = anx7625_aux_trans(ctx, DP_AUX_NATIVE_READ, 0x68028, 1, &bcap);
+	ret = anx7625_aux_trans(ctx, DP_AUX_NATIVE_READ, DP_AUX_HDCP_BCAPS, 1, &bcap);
 	if (ret < 0)
 		return ret;
 
-	if (!(bcap & 0x01)) {
+	if (!(bcap & DP_BCAPS_HDCP_CAPABLE)) {
 		pr_warn("downstream not support HDCP 1.4, cap(%x).\n", bcap);
 		return 0;
 	}
-- 
2.40.1



