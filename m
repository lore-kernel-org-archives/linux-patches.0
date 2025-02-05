Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB01152E02;
	Wed,  5 Feb 2025 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763881; cv=none; b=eik7MXLAqR0Ouag9JWAfq1e0rM+l8z2zMzv3kS4I39Bsoe/BGybb75Z2fUnvTNxN/A34+iXZv2Q/oX/7bUlsOFJP+pDF/atXJ0sSIKXdc/6E5Ngwkepw5NtoGiDXSNPb9PfG8DTHwQTJaKgfLwDs58yu8G73tBblx3VOjZwkxjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763881; c=relaxed/simple;
	bh=9BXap00Nst3PuQiILwNI1UC5wlYJMH4VDegeOFDixag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMTMXA3kDNikuomW5TlwKAvRkF/0P28bVvrjgfLnnnspX88HZ35yALmxbdVbmJn0rO0pdCk8R1rjDZ0LZhobTFZA5D2UkyPgtXPnv/LsYdSxJk7BG3uuhzVU2ymZ1YEAzmGrT/xCTPdK8PLmUeGdO75XjkfyeX0ZwUxbJidGPCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7VHPwB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7VHPwB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A20C4CED1;
	Wed,  5 Feb 2025 13:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763881;
	bh=9BXap00Nst3PuQiILwNI1UC5wlYJMH4VDegeOFDixag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7VHPwB6jh4o30cPA8OO4SHo7gYFdA3n8txUHCM3arbOUWgUHl7/V5hZ4Dtje/jkY
	 k+CCdJFBW+Y24EoeJwBhLAdiZedqtdxA2DNgk9MJsuENY6PHr98LwUWRPvNkgf++Vb
	 RAAb4f5UJII4j0ATSmpmKgoywFXaPtUs6noIEvIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/590] drm/bridge: it6505: Change definition of AUX_FIFO_MAX_SIZE
Date: Wed,  5 Feb 2025 14:37:04 +0100
Message-ID: <20250205134457.898346921@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit c14870218c14532b0f0a7805b96a4d3c92d06fb2 ]

The hardware AUX FIFO is 16 bytes
Change definition of AUX_FIFO_MAX_SIZE to 16

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-1-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 008d86cc562af..cf891e7677c0e 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -300,7 +300,7 @@
 #define MAX_CR_LEVEL 0x03
 #define MAX_EQ_LEVEL 0x03
 #define AUX_WAIT_TIMEOUT_MS 15
-#define AUX_FIFO_MAX_SIZE 32
+#define AUX_FIFO_MAX_SIZE 16
 #define PIXEL_CLK_DELAY 1
 #define PIXEL_CLK_INVERSE 0
 #define ADJUST_PHASE_THRESHOLD 80000
-- 
2.39.5



