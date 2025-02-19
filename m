Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41621C2432;
	Wed, 19 Feb 2025 09:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956318; cv=none; b=Cx4LQ88ejl69NZr7m5G2d2Yb/2OyS1ox8WBFOIMBiewqOzBBpKUNuTURSUAtnz18LFWkDFZQBl2k01mVqSrxJ9Y/dZg5+gaAZ8ijXQT24EI9mJh6uhpB8yviQBGOvG0a8AMpYJJFBwJewSXGmaB4K8g5F+CBWF12nhhl61VgCFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956318; c=relaxed/simple;
	bh=VdPzT54V/V9peLU1mjoNJSIkW5YTzLmdE5YeH2pHkNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAvn85F6ZBvHRj30YpHqUoAiTt+B0Vsz0eqpOcN6Yf7FxBFMAyjT2Z/vccW16PScBDLVSZ5cEvzb5uDWYIgJ3u+3VPEPouIUV7d7VO/2TMjwPcADQCFyM39hHIQGGQKSBiovnrgkmewcOi7KJwiULlKNAm7UUaVNY5TaW0Qo7wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGkwa2Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGkwa2Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FE2C4CED1;
	Wed, 19 Feb 2025 09:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956317;
	bh=VdPzT54V/V9peLU1mjoNJSIkW5YTzLmdE5YeH2pHkNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGkwa2KwX+Wc0UXZZln1ELhAolOuIJquorsaP0UaCmJeiBuL+EGJgPyiYNrSr7TF2
	 0lOgRSWCPyWXQrwgY7j8J5Ii2rzpnreCIFwg8NRL8dRh5GwaTkPjQgk+4AIIhrUvyE
	 ottAOQ8BCubjOx73zSrxz+/h7eeNIJtH4kNv8QU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/578] arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A
Date: Wed, 19 Feb 2025 09:22:22 +0100
Message-ID: <20250219082658.415935687@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 2561c7d5d497b988deccc36fe5eac7fd50b937f8 ]

The Android DTB for the related MT8167 reserves 0x30000. This is likely
correct for MT8516 Android devices as well, and there's never any harm
in reserving 64KiB more.

Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-5-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 0b86863381cf3..5655f12723f14 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -144,10 +144,10 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* 128 KiB reserved for ARM Trusted Firmware (BL31) */
+		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
 		bl31_secmon_reserved: secmon@43000000 {
 			no-map;
-			reg = <0 0x43000000 0 0x20000>;
+			reg = <0 0x43000000 0 0x30000>;
 		};
 	};
 
-- 
2.39.5



