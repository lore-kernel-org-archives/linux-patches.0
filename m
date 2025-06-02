Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC31E3772;
	Mon,  2 Jun 2025 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875474; cv=none; b=iDFvO08tEP9Ni7Dr0SX+xcA4lA2ONOK+vXn3SAYxEm4KdSiw1TTEA0oeln09o/96zuOFJgax6J0LTiLWpdLrrpsoPhSomFAicjH02PCY7nM1XBi2f8cUd+bflmhW81FMRmrdWTnsPsf/BIvt8GRPGRMaB+LFw1xlwTTSx+KGN1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875474; c=relaxed/simple;
	bh=+PDqGsAoEVEP5sZbIm9iJwO4tTLnmRbxBPa5rS5UMsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwnKVD5FyUwJqmWk6iw86U7WVLw64LyxXrcnzI5Ic3vkG1yDwtLHYSMjVpLw6Htf/tzRWzjdwmOQ1SP6k+3jeolcLLMCsO3f7E9lB22Fvr579ebqEzTV56sJnRXVYsJ+GfL1Fb577k9W3WE5jaqbC9kQigoW/rtpBRBKrTk8N0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRGIQHM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRGIQHM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369A8C4CEEB;
	Mon,  2 Jun 2025 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875473;
	bh=+PDqGsAoEVEP5sZbIm9iJwO4tTLnmRbxBPa5rS5UMsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRGIQHM6I8sWeEIvvBd7qys450mrRtDeGXD0A7sd+2qOJHQGvv+5CHvkeptgNkQTS
	 14l4NQpbpO4MzHMckawK5dBSlKLz0Y6fweD4yeWdnYna7MZ52UcR3hYYAvY9VleBAz
	 eJvoqQZFkmKDpcwErwXrGln+eWu/lSsZzFFQjeyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/270] rtc: rv3032: fix EERD location
Date: Mon,  2 Jun 2025 15:47:10 +0200
Message-ID: <20250602134313.155889539@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit b0f9cb4a0706b0356e84d67e48500b77b343debe ]

EERD is bit 2 in CTRL1

Link: https://lore.kernel.org/r/20250306214243.1167692-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3032.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3032.c b/drivers/rtc/rtc-rv3032.c
index 9e6166864bd73..acae15c34d128 100644
--- a/drivers/rtc/rtc-rv3032.c
+++ b/drivers/rtc/rtc-rv3032.c
@@ -69,7 +69,7 @@
 #define RV3032_CLKOUT2_FD_MSK		GENMASK(6, 5)
 #define RV3032_CLKOUT2_OS		BIT(7)
 
-#define RV3032_CTRL1_EERD		BIT(3)
+#define RV3032_CTRL1_EERD		BIT(2)
 #define RV3032_CTRL1_WADA		BIT(5)
 
 #define RV3032_CTRL2_STOP		BIT(0)
-- 
2.39.5



