Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B38426B098;
	Thu, 13 Feb 2025 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459545; cv=none; b=X9Q+e4paz0Au0TNoUkqQ2zZUNDqlydrWukbTZCv2uHeu45xTeC85bHHCrut6p2+E+qFdRGPXeN1WHYGX8OV/lK9N3WrN06fEn/DYIWQosIAe5cwSSGm6ybnUBteHUw5ld00fUZ8T+Cev3Rwo+B3Uud9bBXNyE197nAnOTAVF0WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459545; c=relaxed/simple;
	bh=GcW8Za9VZlLTjecky1SXN8JwNgmsaPoyrQ3hqn2dd58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDdc3nMCE+WIddG4y2Pr854VNs6RiYUYeRPZo/7JCYIlsiAGlhC8lue+kPLAa5Gqa1F79OfKdaurA9mVCuCXkQ0I04AButCVHasQxoCTHds2t+gWPLpSzLZi7rqnLS2KNlAppVIYuW0WTaI5ZxJJ7VfcEnMntOp1C2qQBjTMp14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VueNc80r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VueNc80r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808C4C4CED1;
	Thu, 13 Feb 2025 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459545;
	bh=GcW8Za9VZlLTjecky1SXN8JwNgmsaPoyrQ3hqn2dd58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VueNc80r0mNIZIOqxdcykZJbe6eHbYGWpz7sDSRZGlCBoGaxPiPkkDkpH9hH5UndL
	 LwqnU1uupLo44T+GZQoNfel4aTUqe0CaJzDOafO4JOOZEhANOcsHQEfXR9zZ4zDzi2
	 og96+cXiwA4YWyeAIYr+YbcnDOSvGxUu0el0VDPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.13 296/443] arm64: dts: mediatek: mt8183: Disable DPI display output by default
Date: Thu, 13 Feb 2025 15:27:41 +0100
Message-ID: <20250213142452.037518550@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 93a680af46436780fd64f4e856a4cfa8b393be6e upstream.

This reverts commit 377548f05bd0905db52a1d50e5b328b9b4eb049d.

Most SoC dtsi files have the display output interfaces disabled by
default, and only enabled on boards that utilize them. The MT8183
has it backwards: the display outputs are left enabled by default,
and only disabled at the board level.

Reverse the situation for the DPI output so that it follows the
normal scheme. For ease of backporting the DSI output is handled
in a separate patch.

Fixes: 009d855a26fd ("arm64: dts: mt8183: add dpi node to mt8183")
Fixes: 377548f05bd0 ("arm64: dts: mediatek: mt8183-kukui: Disable DPI display interface")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20241025075630.3917458-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi |    5 -----
 arch/arm64/boot/dts/mediatek/mt8183.dtsi       |    1 +
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -269,11 +269,6 @@
 	};
 };
 
-&dpi0 {
-	/* TODO Re-enable after DP to Type-C port muxing can be described */
-	status = "disabled";
-};
-
 &gic {
 	mediatek,broken-save-restore-fw;
 };
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1846,6 +1846,7 @@
 				 <&mmsys CLK_MM_DPI_MM>,
 				 <&apmixedsys CLK_APMIXED_TVDPLL>;
 			clock-names = "pixel", "engine", "pll";
+			status = "disabled";
 
 			port {
 				dpi_out: endpoint { };


