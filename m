Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E569F24728E;
	Mon, 23 Jun 2025 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686053; cv=none; b=oh6Y5ftVhXDwy5fzEx2zTvPuJ6DKA+vzqsJV4uOLeC+9NMYLlJ30dqYQgQd4pfE1xz63b8814gg3JLsHeDzP8HFuYU425B5Z/2q5lDUzLgyAo52oI84VeQfDn6zCPVdbw+i51uptw5yA9KwV0EH7C4CNuEzK3+I9cY/kIepw2Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686053; c=relaxed/simple;
	bh=lcug14flMsXGnYGRWFrlKBcG9B6jbSgIemV7NkZhrV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk3s+4sjK2CaEKqi5Gyp35Eau7AAuTSGz5vbUreQDcZ9uTrKvCbkV8BCDYE++7w75qZHSJqGm3SavYdCIqWKNb68SF0rOxpkBzNCMr2EWHv8flpWaXKVmystWoOJ/uIB/kyUKLMNPF7CCEvANi13kvEAEqBtAWlOLl+KVE2o+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MYmYATW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MYmYATW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EC3C4CEEA;
	Mon, 23 Jun 2025 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686052;
	bh=lcug14flMsXGnYGRWFrlKBcG9B6jbSgIemV7NkZhrV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MYmYATWpJzmWNh03PDFKhnUwFSduV4C5Wg8JmGKV4ayKQt+TPTfZ+qTW7tFHA+a1
	 uUtHxgU3Le4XDBykaWMmR5pj3w2+5o0PIZcextgJ2NbfZjhXiUWyrSiw4ELxeJKLRt
	 FBycoF7yQRhCUaOuSJC/+3DS5+MVLpxSD4u6BU8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/411] arm64: dts: imx8mm-beacon: Fix RTC capacitive load
Date: Mon, 23 Jun 2025 15:03:41 +0200
Message-ID: <20250623130635.316014445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 2e98d456666d63f897ba153210bcef9d78ba0f3a ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 593816fa2f35 ("arm64: dts: imx: Add Beacon i.MX8m-Mini development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
index 40f5e7a3b0644..7ed267bf9b8f4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -231,6 +231,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



