Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC282EEBB;
	Tue, 23 Jan 2024 00:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969513; cv=none; b=c4Tb0sOl5mbxjNUn/lYTOsB0kHF+366QyRf7uEVy6IlRNd5jtu48JsI2R6H8s/1+VrXEt/mvOoWEcfADiGM9qsZwqIFbfY1PYCy+Lv00+jGdVsWLSuDneuSnInLY4oZMmvhqsomWL+/BPCDe8mhlI1EuPUEnWgZuBsnkOB/nInY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969513; c=relaxed/simple;
	bh=uouUsG9S1W/2N2I0Bu3Ou9fjftZYy2G6UoWjoDp0J14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5pQAiPWvzH1kgwQEso52x3CL28+qV7CtiaMKVt6CucMoIcOSjuQRqlbZ8KMVludmcSaZMuvRZsHaaC2oOuaMyHm3xSuqDHKs1Fea48XbgWSudK5m1DPCunmTnpT8QpVQCCPZgVSBLyuB+DMIgimk95wD3ieNZsuvP0C6OPihOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGXhUUon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGXhUUon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CA0C433A6;
	Tue, 23 Jan 2024 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969513;
	bh=uouUsG9S1W/2N2I0Bu3Ou9fjftZYy2G6UoWjoDp0J14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGXhUUonbTkRVw+8PEoXLCcJ39WISnjnwkqAp0HeTwLcCzKLigbv7cYdrrCQL2JUl
	 lU0jQMZPrCZsqMexZYQ6XrNrrrjzv/gRgaAGrrg6aa63CVvFK54R/3kjDTu2TPpBYH
	 DRoMwhlVtjMx6XnR8EEdz3ybDnD3xQxhzHh9n7+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Liu Ying <victor.liu@nxp.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 262/641] drm/bridge: imx93-mipi-dsi: Fix a couple of building warnings
Date: Mon, 22 Jan 2024 15:52:46 -0800
Message-ID: <20240122235826.134386465@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 325b71e820b67569048c621227266783442b75ed ]

Fix a couple of building warnings on used uninitialized 'best_m' and
'best_n' local variables by initializing 'best_m' to zero and 'best_n'
to UINT_MAX.  This makes compiler happy only.  No functional change.

Fixes: ce62f8ea7e3f ("drm/bridge: imx: Add i.MX93 MIPI DSI support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311151746.f7u7dzbZ-lkp@intel.com/
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231123051807.3818342-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/imx/imx93-mipi-dsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/imx/imx93-mipi-dsi.c b/drivers/gpu/drm/bridge/imx/imx93-mipi-dsi.c
index 3ff30ce80c5b..2347f8dd632f 100644
--- a/drivers/gpu/drm/bridge/imx/imx93-mipi-dsi.c
+++ b/drivers/gpu/drm/bridge/imx/imx93-mipi-dsi.c
@@ -226,8 +226,8 @@ dphy_pll_get_configure_from_opts(struct imx93_dsi *dsi,
 	unsigned long fout;
 	unsigned long best_fout = 0;
 	unsigned int fvco_div;
-	unsigned int min_n, max_n, n, best_n;
-	unsigned long m, best_m;
+	unsigned int min_n, max_n, n, best_n = UINT_MAX;
+	unsigned long m, best_m = 0;
 	unsigned long min_delta = ULONG_MAX;
 	unsigned long delta;
 	u64 tmp;
-- 
2.43.0



