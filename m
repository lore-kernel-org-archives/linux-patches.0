Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E3220E334;
	Tue, 30 Sep 2025 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245756; cv=none; b=EhkL/s5sAbh/dmAIo4nyq3R+7CT7tfGWS7AGh2BEYgENDFuSF7Fq7fHyVGfXKxPjhWNzpxS/z4SwqntQ8cTKeS/5Y+6CGKkmuj8p8ZprEiQCgRSLsFYOFGacFG5YnoWASXLtX0LmjA3jzkfbRrTWFhQ7hMpwLj18vkykov7NnRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245756; c=relaxed/simple;
	bh=9mjKj27WwIec4VGJbCIpEC/yUPjJ+jlDNYBgfsKdJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cniQOvHEHOfoRHBkSSvianMWF4CC+6E5Js12VQjZEWnN31yfNjqG5+Vs0HmcWnZO1CxRffvvD1Hk/2XizO6HEQ7cNhv5vGe3pRYuS9L4ApKvHEYQmeZld+TvCQe3XNOfRqY0A5PLhlO4bljCERVwJ2h+nguQ20domWEzzZwcFQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8af5Vf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8af5Vf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADAAC4CEF0;
	Tue, 30 Sep 2025 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245756;
	bh=9mjKj27WwIec4VGJbCIpEC/yUPjJ+jlDNYBgfsKdJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8af5Vf9maaRrvCWvN7+bBuqHotUgRkd/WFCYbbKoOgRkvtVt1xDwS3u4nJgKQo2c
	 Tq0tueeZEVV/yslqe9k/u6a3aZDua+HsDLCEsjA2cCMHYbDUMsbU5UYPxHbjfIibfd
	 rbUgFqijWODqdOjvsQdYPbow/q/sg+oESPezQWbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 40/91] ethernet: rvu-af: Remove slash from the driver name
Date: Tue, 30 Sep 2025 16:47:39 +0200
Message-ID: <20250930143822.835632352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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
index 6302990e9a5ff..729d1833a829a 100644
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



