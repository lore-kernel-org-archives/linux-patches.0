Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B811F3FED;
	Tue, 30 Sep 2025 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246082; cv=none; b=ilRIPCjSHEX7uSl1df/O45LzSJ9j3aHYaXT8N07o/kH0SWXgpy1cRix3Bs2M15rax2OPOKPmUzRhDD5F4rA+nok+GDREQ4qTqS+pDls7iLyCmPQ4wteI+S6PWG6E0urqq4hO6UZCn9/c1fZWT9gsn03K4YyrhFT7bijX0CB78Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246082; c=relaxed/simple;
	bh=dchsmDKZpYhTylZVKyZTYTDya5w+4qQiVvzY3JNdNUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUiqw0UJ5w3x1bfJlShcW1SM99mzAk+Fwonpte/PVuwGYzadXP65CwmLZVpu1pWnU9A9C0HaoGhL/cTTjmAY99aHXYO87BiObn001bJpUzIrNGBgU0zRa6LUHD6aVpH3jCwh9J2tWloyh4kEkJXrgbLSGRqGiyBxVjs0byW0o7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUily12u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUily12u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDFEC4CEF0;
	Tue, 30 Sep 2025 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246082;
	bh=dchsmDKZpYhTylZVKyZTYTDya5w+4qQiVvzY3JNdNUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUily12uLHMJxpQTDJJ1eFtJubJo4ta1YFX5UXtzWK4jix0F20h7DUF1q24mZWfc4
	 JuukaXsL/Btg+jY6/0gzylpcqRePcB7yrleXdC5Tuo/P1EVgqppan5kSSQsH2hSGmC
	 wQRCvV1bAw0Z0AO2C68fIO6U9a+1m79Nk4NPbcdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 47/89] ethernet: rvu-af: Remove slash from the driver name
Date: Tue, 30 Sep 2025 16:48:01 +0200
Message-ID: <20250930143823.870950179@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Malat <oss@malat.biz>

[ Upstream commit b65678cacc030efd53c38c089fb9b741a2ee34c8 ]

Having a slash in the driver name leads to EIO being returned while
reading /sys/module/rvu_af/drivers content.

Remove DRV_STRING as it's not used anywhere.

Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
Signed-off-by: Petr Malat <oss@malat.biz>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250918152106.1798299-1-oss@malat.biz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 971993586fb49..ca74bf6843369 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -21,8 +21,7 @@
 #include "rvu.h"
 #include "lmac_common.h"
 
-#define DRV_NAME	"Marvell-CGX/RPM"
-#define DRV_STRING      "Marvell CGX/RPM Driver"
+#define DRV_NAME	"Marvell-CGX-RPM"
 
 #define CGX_RX_STAT_GLOBAL_INDEX	9
 
-- 
2.51.0



