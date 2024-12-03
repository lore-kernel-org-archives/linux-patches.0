Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E165336E;
	Tue,  3 Dec 2024 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240350; cv=none; b=QEtxvGSQ3NTha4Ub0kICozvrYtxQJ4xC1N7SlH0Do0UyVR/071LEtqawbMEwIlFCYbmGgjegKJ0MAdOu07Xtp7GY/AbEU1oyAsTvWIYH5wkIBU4uSNlb777bEpxznwG4N6kZ2rTJae+Xr8sZPPs4ykuT9LBnWeHcLS5VjjXRo9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240350; c=relaxed/simple;
	bh=Vtvx8CPZTan3W/CK9wUEA/uDlg07JgRd6wnNvehI+Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUsUYVYYpTjAy3mL50J250kI3m9nFS9v5B0RIFZrY84w4SuctlCzfA2XeRDvZOPHHF46XTdHZxyLkvqZvHQkAVGL5+tdiQgYmLCHGnQEBwXrJvjisJmFk0753tsXKKjwDf2vU+2iZebWHgzgnw6KjwReC5eN20wu8jfTUhMbVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKo/9VkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKo/9VkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FACC4CECF;
	Tue,  3 Dec 2024 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240350;
	bh=Vtvx8CPZTan3W/CK9wUEA/uDlg07JgRd6wnNvehI+Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKo/9VkIgPfstfa42+cAGeIsGOJJGe/7VBAsVnsDA3VADs7jzSsyiTPRm4stc4kp1
	 Uwur5JBRKlt4DYy2Ojz2fa1NnUDo8BS0e4tLwnKQOCOaT34QUNx978wMfR4WaCFoSg
	 JRz6XqXzSUjtc67ETdAB6lBd8vkmj13zz3YC11Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	kernel test robot <lkp@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/826] arm64: dts: mt8183: Add port node to dpi node
Date: Tue,  3 Dec 2024 15:37:17 +0100
Message-ID: <20241203144748.035009825@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit ec1a37b3cd0cf9a1bf88816a5342fb06e3316b34 ]

Add the port node to fix the binding schema check.

Fixes: 009d855a26fd ("arm64: dts: mt8183: add dpi node to mt8183")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409110843.Hm5W9upr-lkp@intel.com/
Link: https://lore.kernel.org/r/20240912144430.3161717-3-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 266441e999f21..0a6578aacf828 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1845,6 +1845,10 @@ dpi0: dpi@14015000 {
 				 <&mmsys CLK_MM_DPI_MM>,
 				 <&apmixedsys CLK_APMIXED_TVDPLL>;
 			clock-names = "pixel", "engine", "pll";
+
+			port {
+				dpi_out: endpoint { };
+			};
 		};
 
 		mutex: mutex@14016000 {
-- 
2.43.0



