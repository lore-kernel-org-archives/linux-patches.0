Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D402730CD8E;
	Mon, 13 Oct 2025 15:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369141; cv=none; b=AgcYb1onbhFwwM54OiQMuJwAR6zsR0WxuFIpyC5neS4HJYC1tY7+m2132htop02/mbsYVAYuBmDdCY40RhdfCFBRorj1bWHmzC+QKNCjew6ifDXXbW5NMkKJ28dp1idVKdZlEWLkC32OEimH02yfWUeBKRsL2XsxVnxKFQPh9PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369141; c=relaxed/simple;
	bh=vQzOsZqZ3nQGlBo7sa8cNxSUk/yIv2n3HsoXI8DvU/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDdDRUZgTQ1/2+uTmt79I3lTTF8bM8uhTQ+VwRLrE/KwSeaPC7Dbt+kuhwaBSosVRpnUPNJ0aOj8gG36+hFPQmwJHKiHwFY+DTFUa6UsMntSpBlFiVKtxvRRneWHbYr2GlBmetQqU1OiNLOxZSAuwawmXzAWcJmLKmeO+WUjfFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVlnW+7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVlnW+7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602E9C4CEFE;
	Mon, 13 Oct 2025 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369141;
	bh=vQzOsZqZ3nQGlBo7sa8cNxSUk/yIv2n3HsoXI8DvU/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVlnW+7XxPYLg5ptUMUR2sLbPEP09jBYGE50JPltIX0gg5z0TGRC45/0h+XqjF+jo
	 CSN9N6pvq1yA5Jl69YLhUZMfzZM0qINVr38eAOCxiQLXXTRWMqnJFE+YbNXZRBXzt0
	 YGPr5x5GNIXO9RQvW67gvnCxJQVzSX8JfXATIhnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kendall Willis <k-willis@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Akashdeep Kaur <a-kaur@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 143/563] arm64: dts: ti: k3-pinctrl: Fix the bug in existing macros
Date: Mon, 13 Oct 2025 16:40:04 +0200
Message-ID: <20251013144416.471793516@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akashdeep Kaur <a-kaur@ti.com>

[ Upstream commit 2e79ee4d64e9ba4a3fc90e91dfd715407efab16d ]

Currently, DS_IO_OVERRIDE_EN_SHIFT macro is not defined anywhere but
used for defining other macro.
Replace this undefined macro with valid macro. Rename the existing macro
to reflect the actual behavior.

Fixes: 325aa0f6b36e ("arm64: dts: ti: k3-pinctrl: Introduce deep sleep macros")

Reviewed-by: Kendall Willis <k-willis@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Akashdeep Kaur <a-kaur@ti.com>
Fixes: 325aa0f6b36e ("arm64: dts: ti: k3-pinctrl: Introduce deep sleep macros")
Link: https://patch.msgid.link/20250909044108.2541534-5-a-kaur@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-pinctrl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-pinctrl.h b/arch/arm64/boot/dts/ti/k3-pinctrl.h
index c0f09be8d3f94..146b780f3bd4a 100644
--- a/arch/arm64/boot/dts/ti/k3-pinctrl.h
+++ b/arch/arm64/boot/dts/ti/k3-pinctrl.h
@@ -55,8 +55,8 @@
 
 #define PIN_DS_FORCE_DISABLE		(0 << FORCE_DS_EN_SHIFT)
 #define PIN_DS_FORCE_ENABLE		(1 << FORCE_DS_EN_SHIFT)
-#define PIN_DS_IO_OVERRIDE_DISABLE	(0 << DS_IO_OVERRIDE_EN_SHIFT)
-#define PIN_DS_IO_OVERRIDE_ENABLE	(1 << DS_IO_OVERRIDE_EN_SHIFT)
+#define PIN_DS_ISO_OVERRIDE_DISABLE     (0 << ISO_OVERRIDE_EN_SHIFT)
+#define PIN_DS_ISO_OVERRIDE_ENABLE      (1 << ISO_OVERRIDE_EN_SHIFT)
 #define PIN_DS_OUT_ENABLE		(0 << DS_OUT_DIS_SHIFT)
 #define PIN_DS_OUT_DISABLE		(1 << DS_OUT_DIS_SHIFT)
 #define PIN_DS_OUT_VALUE_ZERO		(0 << DS_OUT_VAL_SHIFT)
-- 
2.51.0



