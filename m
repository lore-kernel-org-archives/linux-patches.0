Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF2229403;
	Tue, 23 Jan 2024 01:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974736; cv=none; b=buIMGqs1LYowSRepQW79fxc4iy4VvPslgWPS0iER2P+jECS9QEJUvuIgnTAbr0KtRO/BPE7xEsYzF5pG/PrXAo7gVfRCQvMDK8FiHlg8kcH2+7f/FAC7IxjVnvFRraxvB+sQ1F1yFsAmOwah2+9u/oTta/LGw+mUXOoF5/5132s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974736; c=relaxed/simple;
	bh=GuM/VoSM3B4dLuiw+gEG1pDSIVhdVAdnrue+FPy8WeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4LHyhrMdPJxwHdsGci+kuiiBwlOMY/N2MoOoieHhorBP8+NNsxfJRQg/A3+rfCC91iPc7eyGbiodQZlHqG4cmQUkSHUYeutc+Zv3P4POhY0+XjrPciuXHjwOZr3QU2m/oh0wK8PdaV1gcVmvSCpMnUyjklF1wOU6H4i2BZG5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+fZTkPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+fZTkPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE3EC433C7;
	Tue, 23 Jan 2024 01:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974736;
	bh=GuM/VoSM3B4dLuiw+gEG1pDSIVhdVAdnrue+FPy8WeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+fZTkPRLw5Cf9DQtBycWAKRo0isLyBlucO7q5+5Qh8CO9FV/Sli6JrGic40huHQu
	 gzlRbI93BRhb2AdXVsV59ECNwYONyT1fUrkIjYi2iZ6umId2v6IP8MBJ1DI7p1iOn5
	 sT1VSaQNpEDW2+uvcx1SHjBSQVFyTwvZZYWErWss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/583] arm64: dts: mediatek: mt8186: Fix alias prefix for ovl_2l0
Date: Mon, 22 Jan 2024 15:53:20 -0800
Message-ID: <20240122235816.634085395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 6ed159e499bc2ebedf94c9086244220824e71672 ]

The alias prefix for ovl_2l (2 layer overlay) is "ovl-2l", not "ovl_2l".

Fix this.

Fixes: 7e07d3322de2 ("arm64: dts: mediatek: mt8186: Add display nodes")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20231130074032.913511-4-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index df0c04f2ba1d..021397671099 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -22,7 +22,7 @@ / {
 
 	aliases {
 		ovl0 = &ovl0;
-		ovl_2l0 = &ovl_2l0;
+		ovl-2l0 = &ovl_2l0;
 		rdma0 = &rdma0;
 		rdma1 = &rdma1;
 	};
-- 
2.43.0



