Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C613630BC;
	Wed, 20 May 2026 16:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295183; cv=none; b=SWoK2eD2qOxGCuciKaFgnBos8LTrYgDRrEV3gUDCKZO5RmQEesvl0VvTBnm5+NXHsjskL8WQ9vmeZjYcqSZKNvu75qwCE1mIYs5IO3LmAVjnW07ph8+ZrZv5KsvX2/ThPRoGqa1fmnX88Ea/Vvb34Xegzu+gW2CXBD1N2/GH5qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295183; c=relaxed/simple;
	bh=ZIj1wwJ/YctL2QalRadeAIs6BYyAqMSfwrIIrNEJ+Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEQeBqIk3HH2e+Hqu8IIbirpRNdUsVVDg3k2uBGVXLtyhj2QRty+kW6aC6YUseqY1XYA63F9GERZqVe5JVrdgVLm3cBY4PMHIn8M9qkXYUwgmqEef7Yb4DUckP7lTL40DIdQ7T3GRCJzaeh3p7RHaeik0Y07ju/bMAdWtaweA70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mU66ma3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mU66ma3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313261F000E9;
	Wed, 20 May 2026 16:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295179;
	bh=ZQ/oBe4+1qQT4bFj0o3vnV5oUgDwnun7frv7WNXfu3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mU66ma3m0B0ut4CWkpKmmfP4RJMWbtUL7oBVOtm+U2wRFX/OV/iVnPXYn91Q6fqwL
	 y0us992brHgcTmavIHuEbMTROlCIpTK7ICDBHUi+2h4kEk1al7mygYT/V1QKp4/JdM
	 gEZp7B4sxEbR2s/KJ8ygqXnwsdrGZ06toxLXFs/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0321/1146] drm/msm/dpu: dont try using 2 LMs if only one DSC is available
Date: Wed, 20 May 2026 18:09:31 +0200
Message-ID: <20260520162155.463670393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b9699dd862760e642807a2bc226e4d127e35dcb7 ]

Current topology code will try using 2 LMs with just one DSC, which
breaks cases like SC7280 / Fairphone5. Forbid using 2 LMs split in such
a case.

Fixes: 1ce69c265a53 ("drm/msm/dpu: move resource allocation to CRTC")
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Closes: https://lore.kernel.org/r/DH1IKLU0YZYU.2SW4WYO7H3H4R@fairphone.com/
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcm6490-fairphone-fp5
Patchwork: https://patchwork.freedesktop.org/patch/712386/
Link: https://lore.kernel.org/r/20260317-fix-3d-dsc-v1-1-88b54f62f659@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 0f4921b1a8922..cbb7caa194c1e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1410,7 +1410,8 @@ static struct msm_display_topology dpu_crtc_get_topology(
 		topology.num_lm = 2;
 	else if (topology.num_dsc == 2)
 		topology.num_lm = 2;
-	else if (dpu_kms->catalog->caps->has_3d_merge)
+	else if (dpu_kms->catalog->caps->has_3d_merge &&
+		 topology.num_dsc == 0)
 		topology.num_lm = (mode->hdisplay > MAX_HDISPLAY_SPLIT) ? 2 : 1;
 	else
 		topology.num_lm = 1;
-- 
2.53.0



