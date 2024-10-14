Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021DD1AB51B;
	Mon, 14 Oct 2024 15:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919859; cv=none; b=tB4FqSCOp7CJrbEetWf5KMw1csPqYc8l5Ex5xjzNgmDoyY2OYDvxW+584u3GcPTT+5h4toyFGJyiQIk7QeLCPT16g+k6RxaM8VvoGMTOGGhKVZDGeEQFVyL3UQQNPVm0BokwzzfrlVdVaRVRvy4CZaOSIsjdF3Gu+ntCOp/FGuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919859; c=relaxed/simple;
	bh=fCwfauCFY+fC+j6RlsYj0Z4NYMKGMZRP8sixHEMG9AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDjRHXHTyAGfQbgs5xxvL6apOCsfDs91XRfhQ3U9iBDyKWVVH1QdXjklwVQtkK32JaEBw+CUtOeBcvYnQvqY0932g8U3dKo2WL5osFAcl6hQTfn+MDjw4QSJdQ1s5t/xNX1nTF7t/YL955rYACALIgabgfOdrldbxDLL6vjjJX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tu+8ChWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tu+8ChWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643EFC4CEC3;
	Mon, 14 Oct 2024 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919858;
	bh=fCwfauCFY+fC+j6RlsYj0Z4NYMKGMZRP8sixHEMG9AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tu+8ChWXWH92jlcehpjhQ3IWnLmOLX5tPmfc5bomRB3jnvB20PGhed6AG9XXJHlQb
	 fVFsRaTMk3yI7UDtDxWbktSbkPOJqZ288Z1KREvJYKTgECflf1ZgG3tQWLKyamxeuQ
	 kc6DmtvCGsFE6GbX8LjQZv3SvUmay8nd+ImTSm6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 726/798] drm/rockchip: vop: enable VOP_FEATURE_INTERNAL_RGB on RK3066
Date: Mon, 14 Oct 2024 16:21:20 +0200
Message-ID: <20241014141246.594420070@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 6ed51ba95e27221ce87979bd2ad5926033b9e1b9 ]

The RK3066 does have RGB display output, so it should be marked as such.

Fixes: f4a6de855eae ("drm: rockchip: vop: add rk3066 vop definitions")
Cc: stable@vger.kernel.org
Signed-off-by: Val Packett <val@packett.cool>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624204054.5524-3-val@packett.cool
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
index b23c887ff4d45..c8703c1510faf 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -484,6 +484,7 @@ static const struct vop_data rk3066_vop = {
 	.output = &rk3066_output,
 	.win = rk3066_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3066_vop_win_data),
+	.feature = VOP_FEATURE_INTERNAL_RGB,
 	.max_output = { 1920, 1080 },
 };
 
-- 
2.43.0



