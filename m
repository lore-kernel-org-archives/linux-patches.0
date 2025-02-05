Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1BB1519AA;
	Wed,  5 Feb 2025 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764433; cv=none; b=H3f+ooqjuN/nHRgNTLgCkrw6mAjtJJ8L1locsjjBr2ikMrqDgy67fG7y8hlKqUXcWt5RvULCFFjLRPfWk41zCroNqN6VUr1wLCn/wFl3+dCic01p5j7ewmSLI8w1E2r7p6ljCdS9s9oLvv9VDJo3kBZmU7O7cG1Iz2DkMs/7uOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764433; c=relaxed/simple;
	bh=RKKSZsU+4Ywa95KqkGkTh5LILB4toSSx6cOMFGmyRS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpx9giF9CpL+DbdANhkVqZFJsUUtfXxYYGLZcXHQKAGZ/acENea0hHKgFR65xiz7kUSCHa/VLW9OaSL1msyYacvNfntMFAhuNC6lHjjv7XA+c2fEfxKXwVEOM5BcQxMjUBdgvy9UeR1wajbyEMk7kmHyw07CWRKDhi0KSV1nmM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZVH84Ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZVH84Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D36C4CED1;
	Wed,  5 Feb 2025 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764432;
	bh=RKKSZsU+4Ywa95KqkGkTh5LILB4toSSx6cOMFGmyRS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZVH84IpZWAetPxsr5UzsGAJK7VnJBLt3yosAmh7w/DXl/duQdrRZO62UE37U4o2K
	 +y8Tpn49QrEkY4VC5828V+Wvva15y6vzo8eFANLuWxqIQ94I7ldSyCQSUcJhKr6Vwd
	 4HbrfqQHWJbre/W/WQxeq9cCqTjFRf27mu0EooQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/590] clk: imx93: Move IMX93_CLK_END macro to clk driver
Date: Wed,  5 Feb 2025 14:37:58 +0100
Message-ID: <20250205134459.968031371@linuxfoundation.org>
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

From: Pengfei Li <pengfei.li_1@nxp.com>

[ Upstream commit 0af18ba60752e8a4ba34404c1d9a4a799da690f5 ]

IMX93_CLK_END was previously defined in imx93-clock.h to indicate
the number of clocks. However, it is not part of the ABI. For starters
it does no really appear in DTS. But what's more important - new clocks
are described later, which contradicts this define in binding header.
So move this macro to clock driver.

Signed-off-by: Pengfei Li <pengfei.li_1@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241023184651.381265-2-pengfei.li_1@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Stable-dep-of: 6a7853544482 ("clk: imx93: Add IMX93_CLK_SPDIF_IPG clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index c6a9bc8ecc1fc..c8b65146e76ea 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -15,6 +15,8 @@
 
 #include "clk.h"
 
+#define IMX93_CLK_END 202
+
 enum clk_sel {
 	LOW_SPEED_IO_SEL,
 	NON_IO_SEL,
-- 
2.39.5



