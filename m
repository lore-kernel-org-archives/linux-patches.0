Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DE034EF19;
	Fri, 21 Nov 2025 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733460; cv=none; b=S/iZ3hodZRgq+VtJkG1/h3YLENIQ+lr0WPiO0b6AjizwRb2nt8/Yzm4LYvD0/se4EKuwaG054Lu6CyYwgD5MYkr7GshCWQjwRUCgg1NLT3Vh7WZlRFoKz0qqO4WJuC4ndMQyDBaxzRhSlKwblPii2XJQNT3zM89OqYo1NvHbQPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733460; c=relaxed/simple;
	bh=fGjtVKYdMVSJ9m2uOdsqUzojBymU2XBofCz6UmECXCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyPSmEVwawvFTVytjH8ahTCtJ8EZZLyB+hZeqZQ4wU0bfLaq26Ri2gxdgyFF63+aXWxKhhEBOkg+47cAuP/aO4qy3yGx3QesQXlS2niGH0MOkDiQIZDNipvaSJzr9iyz36EVEP1mKedimoWJhkrRVPqWzmeFaYfFBEsEufVGe7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOH0uLaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOH0uLaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AD0C4CEF1;
	Fri, 21 Nov 2025 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733460;
	bh=fGjtVKYdMVSJ9m2uOdsqUzojBymU2XBofCz6UmECXCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOH0uLaZToXCzMpiayfPO7qlJGujAsgGnvaRqQYBSEYK+dTxoAj9JTk7nmJftQUNC
	 Bo1h4slA93HZF66F7oGQUE2p31K+XrrInSj3GnaaVKRQ0UecllozV+l7fWT2uogXSV
	 ocMbdb7pja/li4aCvcOzsC80Vz+C+UWn2wAqt3xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Alexey Charkov <alchark@gmail.com>,
	Hugh Cole-Baker <sigmaris@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 475/529] mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4
Date: Fri, 21 Nov 2025 14:12:54 +0100
Message-ID: <20251121130247.911464708@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit a28352cf2d2f8380e7aca8cb61682396dca7a991 upstream.

strbin signal delay under 0x8 configuration is not stable after massive
test. The recommandation of it should be 0x4.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Alexey Charkov <alchark@gmail.com>
Tested-by: Hugh Cole-Baker <sigmaris@gmail.com>
Fixes: 08f3dff799d4 ("mmc: sdhci-of-dwcmshc: add rockchip platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -54,7 +54,7 @@
 #define DLL_TXCLK_TAPNUM_DEFAULT	0x10
 #define DLL_TXCLK_TAPNUM_90_DEGREES	0xA
 #define DLL_TXCLK_TAPNUM_FROM_SW	BIT(24)
-#define DLL_STRBIN_TAPNUM_DEFAULT	0x8
+#define DLL_STRBIN_TAPNUM_DEFAULT	0x4
 #define DLL_STRBIN_TAPNUM_FROM_SW	BIT(24)
 #define DLL_STRBIN_DELAY_NUM_SEL	BIT(26)
 #define DLL_STRBIN_DELAY_NUM_OFFSET	16


