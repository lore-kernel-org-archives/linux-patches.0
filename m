Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B781EDA16;
	Sun, 18 May 2025 03:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747538612; cv=none; b=bBFXdDePS/S0ZO5tMzxNL/TCU5gm4Zj5PaQlOjzXwh+6nLqblgBZVMH8J2Cqvu6F5J8R0Ut66zNhCmk/M7as8PYNEJiXEvcMHR2d/lnnmZHDFQR6StPYF2dQkMpto59QiAL78MmXoYew9RFbIpCoway57lMXrbEajH1nCWRl8QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747538612; c=relaxed/simple;
	bh=lbr5wL+92LVBRR+N8Bth9V0wydnYvFssqxK7fVYkjVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRKczHaefaFL5W6x+yrgfxstPLtGCp4zHx7zgp51KWYvnD5w0GR6XTHI1u01yLseoizH7dBgi55537ZjJ7X3oku1eZyy5XQXnMyNi2m4YXfRm9/pQ6WKgNcZURG6qhmsNharipcJRlry8ZCOBAfsRNDIeqVkBiCJ4l/aybCRJsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=meZE3p9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meZE3p9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298A6C4CEEF;
	Sun, 18 May 2025 03:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747538612;
	bh=lbr5wL+92LVBRR+N8Bth9V0wydnYvFssqxK7fVYkjVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meZE3p9eCnLhNild8l3ZWxMm3y3ctSnnQcXr4k6pDoGfxRzFLLvzMwxBYoxuN4sD1
	 RuQ8RhappdiwmMm4bjcnqopZFhxEAw5xPPFuvsLHz0fI/LBsOIpYD3Fw1+ywliCAOu
	 sNExAqXCR3QgxOd+1CNDlu2NrXW9UFray86tF+valB1omW/q3qNYMZFB1fg1+SRwZL
	 T7VofNoR1uE69hj0/QESfPOI0SDUFXQNH6NlOpu/PsqAUHL4VdOWmIvyRzWRRYirUy
	 KVY5vbjnP/YN41vAYWk4C6Xiio9LiK3VqCA3nh0FT3NMJckpaO+R6mDiPMr87WC0sx
	 syId/ohwkZF1A==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: WangYuli <wangyuli@uniontech.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 1/4] spmi: Only use Hikey 970 SPMI controller driver when ARM64
Date: Sat, 17 May 2025 20:23:26 -0700
Message-ID: <20250518032330.2959766-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
In-Reply-To: <20250518032330.2959766-1-sboyd@kernel.org>
References: <20250518032330.2959766-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WangYuli <wangyuli@uniontech.com>

SPMI_HISI3670, the Hikey 970 SPMI controller driver, is only
required to use the Kirin 970 SPMI bus.

And the Kirin 970 is an ARM64-based SoC, it cannot be used on
platforms of other architectures.

Link: https://lore.kernel.org/all/b4810f476e41e7de4efdf28b42472ae4ffe7defe.1597647359.git.mchehab+huawei@kernel.org/
Reported-by: Wentao Guan <guanwentao@uniontech.com>
Closes: https://github.com/deepin-community/kernel/pull/604
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/23BAA675A75EF4F5+20250218050552.57711-1-wangyuli@uniontech.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
index 737802046314..4ee496491c74 100644
--- a/drivers/spmi/Kconfig
+++ b/drivers/spmi/Kconfig
@@ -14,6 +14,7 @@ if SPMI
 config SPMI_HISI3670
 	tristate "Hisilicon 3670 SPMI Controller"
 	select IRQ_DOMAIN_HIERARCHY
+	depends on ARM64 || COMPILE_TEST
 	depends on HAS_IOMEM
 	help
 	  If you say yes to this option, support will be included for the
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

