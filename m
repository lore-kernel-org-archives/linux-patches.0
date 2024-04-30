Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2051812C805;
	Tue, 30 Apr 2024 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476458; cv=none; b=kKfUyl6t1BEV3jNCXCGcrYgu7OKUNBTMJWCv+zuENWiiECAp85S+50Dm/ZZnpiVvXMPYKs1zC+qn8HGTsqmELvymXfOx/WDLTjU6HaH7tRfmvOoslAQBL9HlcS9yEvAMmZ//W/zLLYUqoXEs5aN6SdV/fdKv3vw8pt2rpMPivRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476458; c=relaxed/simple;
	bh=Z26HW/UxJeGNid644wjLBtXLMSWWx5u8NJVtKwNMc0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=plF8N8Ux+zWfmjZEoOZwl6EaV3fSZVhxxmMCBaBr5Gh3V53VVhE0fXZEc6cPbvTtRPnh2oY2CzWnNcPgdu+Dsu65NNTmW3dqKrcM7NRp30eTj0GIWTu/DNG9FA7YC5GbeEViY3KO4u3TTNcvC7e+aRiWK8b/tzw+enSqcEg4B8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2RFk7IT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2RFk7IT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F64C2BBFC;
	Tue, 30 Apr 2024 11:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476458;
	bh=Z26HW/UxJeGNid644wjLBtXLMSWWx5u8NJVtKwNMc0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2RFk7IThjyPh30mhCH7CsVVXphmzcIgt/EzwbQJvp/PMqMONy46Ji05kbxhzZHJ4
	 T8lW+ZNsGge4AOASxP2n8VRBSnIy+VPfPAQfvSUZMY96Ct2KBxpqdTPKXWu0jyyMyj
	 o7kEyqPiKTrjntmLZdYrfKiUhW9aF1004MlO/WNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/110] arm64: dts: mediatek: mt8192: Add missing gce-client-reg to mutex
Date: Tue, 30 Apr 2024 12:39:40 +0200
Message-ID: <20240430103047.902630587@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 00bcc8810d9dd69d3899a4189e2f3964f263a600 ]

Add the missing mediatek,gce-client-reg property to the mutex node to
allow it to use the GCE. This prevents the "can't parse gce-client-reg
property" error from being printed and should result in better
performance.

Fixes: b4b75bac952b ("arm64: dts: mt8192: Add display nodes")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-1-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 4ed8a0f187583..7ecba8c7262da 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -1240,6 +1240,7 @@
 			reg = <0 0x14001000 0 0x1000>;
 			interrupts = <GIC_SPI 252 IRQ_TYPE_LEVEL_HIGH 0>;
 			clocks = <&mmsys CLK_MM_DISP_MUTEX0>;
+			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x1000 0x1000>;
 			mediatek,gce-events = <CMDQ_EVENT_DISP_STREAM_DONE_ENG_EVENT_0>,
 					      <CMDQ_EVENT_DISP_STREAM_DONE_ENG_EVENT_1>;
 			power-domains = <&spm MT8192_POWER_DOMAIN_DISP>;
-- 
2.43.0



