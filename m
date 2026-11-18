Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016348;
	b=n2wcUtTGDnEBmu0/e1ORIMNOcVvFTalYamIq8reXfKDjyZfheX/w/HLuCzIqqghIvyd5
	 vkkHFGJn/eCosfqWSewmgXF4zt7aXsK/5TElYU1sjzBgR2oMq9INiKP7qQ7XXlAqW5qF9
	 xPB4EDhkmHRcR5fLm0de3hKO4qMZYdtvmGe6dyS3GNUW6OU46qIF5opi4eaA+rh4hg/SJ
	 6cQ7UD7hvWPiaPucBz3sttHXg3O2gQhxafEspfHbun+8fhC/+6JJZAI4NqQws/OhPNA22
	 QdQKU2P23lnnGqNje92NqyLfNR9GpQJ9YX99cqgKJK8rwPXtqjfcaQGIwWlKpXfnS3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1i7Ei4fS/wEIy7ASgaAiGIdpgbqZM6WLlpJIOUCYX4Q=;
	b=VuatzGNQLYLO+6c0guuo+7Wr9i+qp/X9inQhlU6kTSZpEzLjoMGD0dEPuEDjwMcOInQC
	 QzZ+q1N1yinoOEJzldUVgyTA7gWq+cVlXY801jeJNzmV+Sa+CMPILUdkUF4R7DQy6ufuQ
	 vDkdyn2ZxcJwvv1k9Q38NkcCR543x4gGay0LtBKPw76MAmgTfFgogLzslZX7MX02Sipv4
	 2tfHGnPt+PIM7z1y6GxkrVCBFdna6DmZI2qT0uENUtLzTLE16k8RW+MkVsGRDFXMPkyNG
	 0rLtSpGdw3gZE8/+gTwiJs5M4JNcmrkKIgsiCeFdNcrtBVoi3utOjmBxRkhqYo80nng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZovEM95Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578D0606A33F;
	Wed, 18 Nov 2026 15:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZovEM95Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2D81F000C4;
	Wed, 18 Nov 2026 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016348;
	bh=1i7Ei4fS/wEIy7ASgaAiGIdpgbqZM6WLlpJIOUCYX4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZovEM95ZPeM1gZdjOMAmOgnHEtePY0TYFDAWMA/LvZLoQf5I0w3AS7eeF/qUM6Pg/
	 +6DanmMH4F4PcGRxQ8vOVK731Sc7mh8+1Fk+zwU+0BXlmSVHWmMXO65ctebQ1nUMBZ
	 uufPeNkUa/r8qdWDNK5YbIWhBXdQrdkOxCbp1vXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0497/2651] arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock
Date: Wed, 18 Nov 2026 15:28:57 +0100
Message-ID: <20261118150305.662174267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c9b3c82c9f1f86cdb2449d47e4ca66a19159ee12 ]

The MFG_ASYNC domain, which is likely associated to the whole MFG block,
currently specifies clk26m as its domain clock. This is bogus, since the
clock is an external crystal with no controls. Also, the MFG block has
a independent CLK_TOP_AXI_MFG_IN_SEL clock, which according to the block
diagram, gates access to the hardware registers. Having this one as the
domain clock makes much more sense. This also fixes access to the MFGTOP
registers.

Change the MFG_ASYNC domain clock to CLK_TOP_AXI_MFG_IN_SEL.

Fixes: 8b6562644df9 ("arm64: dts: mediatek: Add mt8173 power domain controller")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 78c2ccd5be132..556e806b77878 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -505,7 +505,7 @@ power-domain@MT8173_POWER_DOMAIN_USB {
 				};
 				mfg_async: power-domain@MT8173_POWER_DOMAIN_MFG_ASYNC {
 					reg = <MT8173_POWER_DOMAIN_MFG_ASYNC>;
-					clocks = <&clk26m>;
+					clocks = <&topckgen CLK_TOP_AXI_MFG_IN_SEL>;
 					clock-names = "mfg";
 					#address-cells = <1>;
 					#size-cells = <0>;
-- 
2.53.0



