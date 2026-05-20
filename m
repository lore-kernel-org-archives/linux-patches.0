Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA2370D7C;
	Wed, 20 May 2026 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295071; cv=none; b=mLwZPfEMtxl1wESkM3+3qQgDIV/u6sEfnqH81c8B3JT7gnv21Zc1o00NC1fg5GO7ublQ5efaH/0vSIWKtf8g9Ljzr/I2iDonLM+T2WCk/6DhLbm93YlTdRGuO2w0v+bWkAmZdS78kzb6ztuHW51JR84kBCtz6e2nTe/iGfoDdL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295071; c=relaxed/simple;
	bh=o0ipVyILlH+UG8hWuZ41CLWD9IF0F2caL9HNxRobyfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhGFBH7GRFisLORCcW5EB8YFxbBB4vEDcZNmMGYaPttx+63Wcqs9xxR38FAOnTrENmJBNxB33ziJiaKd/56YoieMHcty/yhE5/sf4Sq+jso/GshdVbzX3kdho0HIuVjkGQBk9T14PRfOLKtuI/KTL7xA4K1guBrEhCGQlghKd+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7PF92YV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7PF92YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895021F00894;
	Wed, 20 May 2026 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295069;
	bh=Ot8IeVGZYPFLTMV6frGqYUj9ixwxX6xTtV5GlTh+arA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7PF92YVWR6TkVmuPANYTaebWAf/++GsceLp6QExGRrCSmCjKjUxvvsspND16hyiv
	 9ALWtnpzwgitUX3US5ufasJQUETlzTXQe9RQ+XGaiD54SclrtCWZLQUx9VCIJrpImv
	 o6+mNHc52xhgYRQUPRcYa2XT9CUjPaqQLFEawvsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Michael Riesch <michael.riesch@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0279/1146] media: synopsys: VIDEO_DW_MIPI_CSI2RX should depend on ARCH_ROCKCHIP
Date: Wed, 20 May 2026 18:08:49 +0200
Message-ID: <20260520162154.530792896@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 942435a62d67035394340cfcbaa534145d638bf0 ]

The Synopsys DesignWare MIPI CSI-2 Receiver is currently only supported
on Rockchip RK3568 SoCs.  Hence add a dependency on ARCH_ROCKCHIP, to
prevent asking the user about this driver when configuring a kernel
without Rockchip platform support.

The dependency can be relaxed later, when adding support for appropriate
SoCs from other vendors (if any).

Fixes: 355a110040665e43 ("media: synopsys: add driver for the designware mipi csi-2 receiver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Michael Riesch <michael.riesch@collabora.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/synopsys/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/synopsys/Kconfig b/drivers/media/platform/synopsys/Kconfig
index bf2ac092fbb39..b109de2c8111c 100644
--- a/drivers/media/platform/synopsys/Kconfig
+++ b/drivers/media/platform/synopsys/Kconfig
@@ -4,6 +4,7 @@ source "drivers/media/platform/synopsys/hdmirx/Kconfig"
 
 config VIDEO_DW_MIPI_CSI2RX
 	tristate "Synopsys DesignWare MIPI CSI-2 Receiver"
+	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	depends on VIDEO_DEV
 	depends on V4L_PLATFORM_DRIVERS
 	depends on PM && COMMON_CLK
-- 
2.53.0



