Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505EE274B46;
	Sat, 12 Sep 2026 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224824; cv=none; b=Z0SXRcz5E0FVr62hYVc7AdAR+/JpZocuz3S75K9xpjwr588qkFJ+9DKwR3AvRp9P8Cip610OS0e5Sr54MLAf2BGTDRNFQoT5r+U8Pay7q6Mky0LU65+lg/KCfifEh2yQImyqNiGbVY3zPTJO4v5lvbVL1zO94KRvJs4jz/rQLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224824; c=relaxed/simple;
	bh=YJItq20d4S/oBIxmpsbqGMI+qTtOvGJpweM4Qt4n+Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHTvXVBQqqBrT91M2kk+Gm1x9lCeSJsxw11ZSjJWQ0o2Sb57DCXBPxg/F2bPJ8SemaS4OFfDHD9KCJvupbWA8VdM4R8YZU1IOIVmSbjsqqEIhw1MSlOSJH+KKSC3zTPvgdT1So/DJVMvx15KdCviXk3kO2hJcNMSoTJTjybzqQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArrInuCT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArrInuCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FA61F000FF;
	Sat, 12 Sep 2026 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224823;
	bh=xd18jl7iZ0MVtdFOswUrni8aLkVgh8GIMzq1w+oCc1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArrInuCTwKU/HiLUQz1q4ossSBzUhnlTK69CZlj7eYIkMeTG05s7hM1CZS+Z840Jn
	 dU3W8Ay/3c9N1Oa/U+M+ONsyjx0slo15rnFjRXWsMIKd7cVh5YYHegB10F/96lYR1Y
	 yF/IyZpgZsBBuZEQlan1fHxJQFoAxzBddx/yJVF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1072/1424] drm/sun4i: tcon: Set output mux for DSI and LVDS
Date: Sat, 12 Sep 2026 08:58:24 +0200
Message-ID: <20260912065631.310009255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 9c90199b39637ad94253c4fd8e7b1333ca1d3e0d ]

DSI and LVDS skip output mux setup, so TCON TOP cannot route the selected
mixer. Configure them like other channel 0 outputs.

In practice this matters for D1, where channel 0 TCONs are fed through
TCON TOP. The remaining set_mux implementations only handle TMDS and
return an error for other encoder types, as before.

Fixes: b9b52d2f4aaf ("drm/sun4i: Add support for D1 TCONs")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/7e9dad9eed2e91a79c4e1202caa8fed7c2427531.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index a1a2c845ade0c..1b710013b9cb3 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -717,9 +717,11 @@ void sun4i_tcon_mode_set(struct sun4i_tcon *tcon,
 	case DRM_MODE_ENCODER_DSI:
 		/* DSI is tied to special case of CPU interface */
 		sun4i_tcon0_mode_set_cpu(tcon, encoder, mode);
+		sun4i_tcon_set_mux(tcon, 0, encoder);
 		break;
 	case DRM_MODE_ENCODER_LVDS:
 		sun4i_tcon0_mode_set_lvds(tcon, encoder, mode);
+		sun4i_tcon_set_mux(tcon, 0, encoder);
 		break;
 	case DRM_MODE_ENCODER_NONE:
 		sun4i_tcon0_mode_set_rgb(tcon, encoder, mode);
-- 
2.53.0



