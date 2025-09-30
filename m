Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241561FF1C8;
	Tue, 30 Sep 2025 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244630; cv=none; b=M9s/RK4xd4cJA/K4yW2OSHfRfWS9KhtGyrz0f2fckJTlExn5+gSdMlkx7HXOZevYd7HL10SjnD+3gEaQ/d2Qbg9GNNQMzfKMN+ZixXUWMotcvGWklfmHyP43YiQ/tlljVtadrg+GkCiYlY9ODGDDTrydLyk1+q0wjFoGmBJrieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244630; c=relaxed/simple;
	bh=Oj1cr1jMAQBN1DtaC65qgN7ZohgzIqyrkEWhcpAxyiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciptVacyX+q+pwIK0/1brsPEZBnuzneWn0jD8imfuJuEqEL3/wuLsw/GGUxzeZiHJCeTZ0ayrPCWzhMjP/e932oRsvYoaYXFLg5cKquqDNvWry0xzfDEDJ9L/WWMVFwUxdzeZ1eh4FyRdhQy5cyu5/Wkwq1KJiPq3hpVkjG7Kl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=praBKhpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="praBKhpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A456AC16AAE;
	Tue, 30 Sep 2025 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244630;
	bh=Oj1cr1jMAQBN1DtaC65qgN7ZohgzIqyrkEWhcpAxyiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=praBKhpFKhRWRRcHYg7ygjN2NyQ2qzlsfakNAPS1d6Lly1U0r0sRdpTR2xBmauC7b
	 6/s3SedxCQwW8o7HyDBgfCXYvsAQc0c7jyw2aMC4kFB6v8uhPDaHaxGADSs/l3EVMN
	 O18H4TPWlQpKowunO0SYZrWUJTMs8JPyjniWIifU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 067/143] ethernet: rvu-af: Remove slash from the driver name
Date: Tue, 30 Sep 2025 16:46:31 +0200
Message-ID: <20250930143833.908048580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 442305463cc0a..21161711c579f 100644
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



