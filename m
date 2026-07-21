Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458DC3955F4;
	Tue, 21 Jul 2026 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649360; cv=none; b=PcKjuig2J738oAvc3nY7rBXTnmiyQv99/XYxCcOfy+i2/G6y8ll+rr93YVEPGZ/v+fhA4K9OeaTVGG1qXex0BItlYVDNooe5gH1GOFXSbk/V0GMg6FfxFfEX+O3/CI558IoGPtJumoOr7z1LsCVElxZIn7FPzvyS3yaG/f9hCXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649360; c=relaxed/simple;
	bh=MiNG3p7ze17j1M8ghPQStEGtZ2xaeKb3AxD4J3nu9Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdFqOsQpVo3QsZHIsr1eXy0WVOT9Ia0poOXi6YKTCLW2KOePnvtTuBacJFa+OGTk1R8jVHKRT6+L9DVauVBZDMSvBNrgGPTWe1pR2Wv/sllqL3VzUl+fJhRUknueGboBuTFXAX6scwJeXCM+M+DDfK5iZksudj0fj5jGxsggOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiPEMj+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiPEMj+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CCB1F000E9;
	Tue, 21 Jul 2026 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649358;
	bh=qDp4GGE7TCdQ1OmoI9Pn1VhCSae4hG2p6SBztH+7S9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiPEMj+jWWHWd+DrYWRbuCqiRXV46EFswd5Au32+ElVOzqQqCKuWbYnDeGoIV9m6E
	 zWfI5XOItwz1bDZGLd5KGC5PMzdqjnsyBklMx5pCxR6IJhB8TBDh1+hDN7/SWe4+4B
	 QXb50I93jY6tWs5yU5b/LvOC/IA9dlDYP/lmHyuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0505/2077] arm64: dts: lx2162a-clearfog: use rev2 SoC dtsi
Date: Tue, 21 Jul 2026 17:02:58 +0200
Message-ID: <20260721152604.725192697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 13a37b30e464503515625ba891018aec0264c7d2 ]

LX2160A and LX2162A are different packages of the same silicon. While
LX2160A had two revisions, LX2162A was released later based on LX2160A
revision 2.

Commit a8fe6c8dfc40 ("arm64: dts: fsl-lx2160a: add rev2 support") has added
a new soc dtsi for revision 2.

Update LX2162A Clearfog description to use revision 2 dtsi.

Fixes: 5093b190f9ce ("arm64: dts: freescale: Add support for LX2162 SoM & Clearfog Board") # no-stable
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts b/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
index 9d50d3e2761da5..f95e9c19bfc758 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
@@ -6,7 +6,7 @@
 
 /dts-v1/;
 
-#include "fsl-lx2160a.dtsi"
+#include "fsl-lx2160a-rev2.dtsi"
 #include "fsl-lx2162a-sr-som.dtsi"
 
 / {
-- 
2.53.0



