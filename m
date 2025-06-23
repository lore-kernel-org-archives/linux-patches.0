Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BAD223335;
	Mon, 23 Jun 2025 21:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715805; cv=none; b=SsDI7u2z5tJYz1KCSlIxXud8DHf4Z+3VGcjpRhON46uE88bFLS11G6SO2DRlHLdtPuSzjcDONkS5+1ISOB16Vd38W4ZTVFcjiJyFe6w8Gz93jvH29mJKx2PKK/PVbnLgt2+2B/Za92BrZqaL1PLokp9E0UnLvZLK23MZzwFxhvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715805; c=relaxed/simple;
	bh=ShgV9xFjDjzzeqyVS3obLu7mSBo5LZOfXxJg4RBPzpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUU3yj7C4IlNLITEpb9uloV2VKKNeOHvjQTFLQt8EDdBWXxO2oh7+2eRC0gMlMnooyH2dYLHAoZKDWLHt9z0fM0/UzsxUnEhwxrjfl28o45w+VfGsd2FnNKaFawZOZJ7x1hqi0mhrrHFe3u0nsTgR1PPRKIxmf03hemXSxDUWMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWy6FdBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWy6FdBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80311C4CEEA;
	Mon, 23 Jun 2025 21:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715804;
	bh=ShgV9xFjDjzzeqyVS3obLu7mSBo5LZOfXxJg4RBPzpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWy6FdBgszqVYRr7ORWOY0ZGfj2Xo2HiHL0RaRYv1vZOQyQuDrudS1JuwL+Cg2K8b
	 kLmhAKJLkssVVvMTTHTbj05gCzBuBd4AXdARqjninwjfMHRUWoeihKMHJHB+Erer28
	 MDNVPm3oJjLtAT8ZGmbeiOeY4Ryyzqscf9QcUzCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/508] drm/meson: use vclk_freq instead of pixel_freq in debug print
Date: Mon, 23 Jun 2025 15:04:48 +0200
Message-ID: <20250623130651.232941735@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit faf2f8382088e8c74bd6eeb236c8c9190e61615e ]

meson_vclk_vic_supported_freq() has a debug print which includes the
pixel freq. However, within the whole function the pixel freq is
irrelevant, other than checking the end of the params array. Switch to
printing the vclk_freq which is being compared / matched against the
inputs to the function to avoid confusion when analyzing error reports
from users.

Fixes: e5fab2ec9ca4 ("drm/meson: vclk: add support for YUV420 setup")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250606221031.3419353-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_vclk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_vclk.c b/drivers/gpu/drm/meson/meson_vclk.c
index 3325580d885d0..c4123bb958e4c 100644
--- a/drivers/gpu/drm/meson/meson_vclk.c
+++ b/drivers/gpu/drm/meson/meson_vclk.c
@@ -790,9 +790,9 @@ meson_vclk_vic_supported_freq(struct meson_drm *priv,
 	}
 
 	for (i = 0 ; params[i].pixel_freq ; ++i) {
-		DRM_DEBUG_DRIVER("i = %d pixel_freq = %lluHz alt = %lluHz\n",
-				 i, params[i].pixel_freq,
-				 PIXEL_FREQ_1000_1001(params[i].pixel_freq));
+		DRM_DEBUG_DRIVER("i = %d vclk_freq = %lluHz alt = %lluHz\n",
+				 i, params[i].vclk_freq,
+				 PIXEL_FREQ_1000_1001(params[i].vclk_freq));
 		DRM_DEBUG_DRIVER("i = %d phy_freq = %lluHz alt = %lluHz\n",
 				 i, params[i].phy_freq,
 				 PHY_FREQ_1000_1001(params[i].phy_freq));
-- 
2.39.5



