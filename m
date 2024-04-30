Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594041E50A;
	Tue, 30 Apr 2024 11:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475187; cv=none; b=gs2F77XAl1kDkjTso9iYDu1f9wtZyYA3UM88WdRZka9lotrM6uOeKPqbVZpsHOLU3FYi6ljTr9N8G6kHpaKUjkK+dW+sZSeCM0ab09baAoPZrOhGNILkoK73r75WBLtG2K0LBYjvXBJpdjCHU88/ceazAqsDRSoI63SzNYkvjDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475187; c=relaxed/simple;
	bh=catForpKr/9+q4zTM5jZDWDlQ2mNsCWAItOlI56yGDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9+kuHmZo8Qjogu08cothodjVSQUjRbGNRpwdUV8Ho71+QXvScxyPd4JHIn8m7ZKUk6VCketN2G4ef5X2ZVZuzQ0F8xxJfHs8Ni1OXtG854w+RgLH1LV4KafF2YtRhSKvtycNw+gzCglsAwuHFJpjUTYIr3MZEUk0zkW/dniAUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gz7QCces; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gz7QCces"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33F6C4AF19;
	Tue, 30 Apr 2024 11:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475187;
	bh=catForpKr/9+q4zTM5jZDWDlQ2mNsCWAItOlI56yGDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gz7QCcesgmt2MtnIoN3PrYKu8c3YpEGskkP3rAdQtYduEukv7D0oaEtdWOrEsKoN/
	 mYkDujo2U6T3JUqt+N/WgtXm1ErH2Lca/HDZ75u1AYaiVa9AkqzJLGKh0v04JDHZfy
	 byjqp6gt/A82/lF0mPNKSzxaA2VS4/HRhBH6K24g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/186] arm64: dts: mediatek: mt8183-kukui: Use default min voltage for MT6358
Date: Tue, 30 Apr 2024 12:37:52 +0200
Message-ID: <20240430103058.607562601@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 296118a8dc297de47d9b3a364b9743f8446bd612 ]

The requested voltage could be lower than the minimum voltage on the
GPU OPP table when the MTK Smart Voltage Scaling (SVS) driver is
enabled, so removing the definition in mt8183-kukui to use the default
minimum voltage (500000 uV) defined in mt6358.dtsi.

Fixes: 31c6732da9d5 ("arm64: dts: mediatek: mt8183-kukui: Override vgpu/vsram_gpu constraints")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240315111621.2263159-4-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index 70becf10cacb8..d846342c1d3b2 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -405,7 +405,6 @@
 };
 
 &mt6358_vgpu_reg {
-	regulator-min-microvolt = <625000>;
 	regulator-max-microvolt = <900000>;
 
 	regulator-coupled-with = <&mt6358_vsram_gpu_reg>;
-- 
2.43.0



