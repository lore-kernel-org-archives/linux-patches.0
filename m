Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F9227F33
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB50C433CA;
	Fri, 21 Jul 2023 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955844;
	bh=FCYbMn+CgIANMrJzpSbvGZNA2ydz+ZM6KZs4x5fwWZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqecjh91PgtnKoDjlqYtY6/0kd3sEqwF8cDpsW5NPp1ng/RKSagRSG4BC6ru3KhrT
	 in8fyaHANeUaxY7JoCXQGnk5buXBNbnZo6SighZ5Xb54Ham4zzWX5LIEr0enufOK38
	 wRRowO9CNa3yPTrunLXMiOwyxZUos0Ispikq5Txk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 015/292] drm/panel: simple: Add Powertip PH800480T013 drm_display_mode flags
Date: Fri, 21 Jul 2023 18:02:04 +0200
Message-ID: <20230721160529.465301441@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 1c519980aced3da1fae37c1339cf43b24eccdee7 ]

Add missing drm_display_mode DRM_MODE_FLAG_NVSYNC | DRM_MODE_FLAG_NHSYNC
flags. Those are used by various bridges in the pipeline to correctly
configure its sync signals polarity.

Fixes: d69de69f2be1 ("drm/panel: simple: Add Powertip PH800480T013 panel")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230615201602.565948-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 1927fef9aed67..e02249b212c2a 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -3110,6 +3110,7 @@ static const struct drm_display_mode powertip_ph800480t013_idf02_mode = {
 	.vsync_start = 480 + 49,
 	.vsync_end = 480 + 49 + 2,
 	.vtotal = 480 + 49 + 2 + 22,
+	.flags = DRM_MODE_FLAG_NVSYNC | DRM_MODE_FLAG_NHSYNC,
 };
 
 static const struct panel_desc powertip_ph800480t013_idf02  = {
-- 
2.39.2



