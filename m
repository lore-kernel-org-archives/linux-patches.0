Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045E912C47A;
	Tue, 30 Apr 2024 11:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475165; cv=none; b=r/AjgFZJah+7HrVik++tWZyGDD7iP2uPcKDjupCu3Vl5YSvWpbqLZxMqNlNqgo/U1b2wfiJUH5V2UmQ+msSMRKndA28otvh8OTValGYxy8Iohxel/8zrCxtosagSUQfRKZDefWVyES3FB0tJpvbNbKoPmKjEyCKAA9qOJif8tqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475165; c=relaxed/simple;
	bh=IcgiUnwtddqcknfyT/2Ujznu3POqK8r6N5jQ6B1uAJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=piMQVdCvlBfHkCD9N/qoqiBa+H8CXWVykPtGwvfKXrma0LAHWD3iZoxt8hmN/Gz/KpS/LshkUNcnOxquIz/xI3HOrqKNsSiUhRSH9GoHyw2G1b9Kq4KJ8CMyC2QwYaec81WXcGMq1DzhqkqIJ9t/npy7bDoWT9BV7NMQ/Sx5eQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUjQxFYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUjQxFYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8218FC2BBFC;
	Tue, 30 Apr 2024 11:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475164;
	bh=IcgiUnwtddqcknfyT/2Ujznu3POqK8r6N5jQ6B1uAJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUjQxFYgkDn3sChpp/J+gjjeavPqZKrbAURH03OfriiqFUIHQPrqLcFDn5bbdHoLl
	 8BlqwPWs5YCfChBlIj7A4J/ArskOFuASti6un9IvkB9g11UYj85Rp1wRTDwntpqY2E
	 ogMnDsMk1jOqWpIJV2n9al5YFUY+PcJJvL7HFBCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/186] arm64: dts: mediatek: mt8195: Add missing gce-client-reg to mutex
Date: Tue, 30 Apr 2024 12:37:46 +0200
Message-ID: <20240430103058.434587668@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 3b129949184a1251e6a42db714f6d68b75fabedd ]

Add the missing mediatek,gce-client-reg property to the mutex node to
allow it to use the GCE. This prevents the "can't parse gce-client-reg
property" error from being printed and should result in better
performance.

Fixes: b852ee68fd72 ("arm64: dts: mt8195: Add display node for vdosys0")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-3-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 8fe8917daed1d..884e56f4a93bb 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -2779,6 +2779,7 @@
 			interrupts = <GIC_SPI 658 IRQ_TYPE_LEVEL_HIGH 0>;
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS0>;
 			clocks = <&vdosys0 CLK_VDO0_DISP_MUTEX0>;
+			mediatek,gce-client-reg = <&gce0 SUBSYS_1c01XXXX 0x6000 0x1000>;
 			mediatek,gce-events = <CMDQ_EVENT_VDO0_DISP_STREAM_DONE_0>;
 		};
 
-- 
2.43.0



