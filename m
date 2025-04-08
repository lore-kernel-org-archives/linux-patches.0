Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFB3224F6;
	Tue,  8 Apr 2025 11:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110619; cv=none; b=W3A1ngvyrsKC+0ZCWlEsr4CIwdOn7OyiHv4gpBw54SAmRUWzpKBgE5Mw3Ja695Rex1SGDCQxhSWTXOBFJLQP/hagdFsatlPogMDaEN6XMgMCQObdQsbLrJmfGozPWwuZv3MNprcslnDKRbW3tpEtK6mXF3LbQa6zc2MqEg0yWJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110619; c=relaxed/simple;
	bh=7qwIDPpdKr+/+asdDalQJ+Dvzsc00ZnZWe/hqaaLdLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOsBqlJqWMRbCzNHSPgawClJiA85pCPYF6rw503S/1BMsxbo5qa9HFjF5rl4y5rVKfLqB1JMu3S23DPPsMsHq5EB0F47fskBE7MLCvn2W5CWJuijG43SWOynp8jdDWP2cKvxZ7ayvH/otmsEV48v3SmhvXvy8knePGt9vdOxZtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRJxTM9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRJxTM9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04A3C4CEE5;
	Tue,  8 Apr 2025 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110619;
	bh=7qwIDPpdKr+/+asdDalQJ+Dvzsc00ZnZWe/hqaaLdLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRJxTM9ECr+gPrnUb7CMEypAjJeCzLHWJf5xdMJz1S9TAYAHs0r9iBV9VDQQMhO2F
	 gWQVR16xVsxmb6Iar5wLB0qlYoVPb+zuT1PdCBXB1qw7qqBcGW9XV4CpnYVa8So8H9
	 YypKHifjcZPky4ozAbvNvF3N5J+F4fm/1JM/Izk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 082/731] arm64: dts: mediatek: mt8173-elm: Drop pmics #address-cells and #size-cells
Date: Tue,  8 Apr 2025 12:39:39 +0200
Message-ID: <20250408104916.177909998@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit aaa0b40e157c65aaa5e0ad903675f245333381bb ]

The PMIC has child nodes for each of its functions. It is not an actual
bus and no addressing is involved.

Dropping the bogus properties fixes a DT validation error:

    arch/arm64/boot/dts/mediatek/mt8173-elm.dtb: pmic: '#address-cells', '#size-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
            from schema $id: http://devicetree.org/schemas/mfd/mediatek,mt6397.yaml#

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412212322.JTFpRD7X-lkp@intel.com/
Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250108083424.2732375-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
index b5d4b5baf4785..0d995b342d463 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
@@ -925,8 +925,6 @@
 &pwrap {
 	pmic: pmic {
 		compatible = "mediatek,mt6397";
-		#address-cells = <1>;
-		#size-cells = <1>;
 		interrupts-extended = <&pio 11 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-- 
2.39.5



