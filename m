Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C021292C8;
	Tue, 30 Apr 2024 10:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474124; cv=none; b=goYeZuWbNLKa+aOfyHKIfZP4e8zw86SjLORlRdmM1G4+oOC/vBWDebga+iG02OlPWFeeEfwDgYiuuRY7H4CVwqlglew6nUTfCe8MBwoOF4hZjoZ+Ve801tnEsB4MGLa2g0Vh0iG6quDpB0bb5iCEk0/t0NXpQCGkjSCnfZihHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474124; c=relaxed/simple;
	bh=GmvgpxqS4UeEMHZFQiAdeChgYOjpflfFcN/RiThp4eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QipumQPrVpjWajdqtIe70/BNFU6aAia3IoSx1mqmcMOsJtb46oLV4WWPYSBS0D4yytVfgvWxhGnvP+0D/ZlPR/1uvfu3HSSQaDikr8ZEItkWzxKM8t9PLOv9tRCn8EDCqPRaWepjWpx3C+xz/MVagIS/NIpw/SZvu3zFYZ1nUDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxQwKgBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxQwKgBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9820DC2BBFC;
	Tue, 30 Apr 2024 10:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474124;
	bh=GmvgpxqS4UeEMHZFQiAdeChgYOjpflfFcN/RiThp4eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxQwKgBo2PxJiYKe6I7gZepzhMQ83VXCyxGz66FSPSQSAaejq0gw0lV8LVmQtYsYQ
	 oXdmDyyzv8ZEZIYC1yFojZSOBY/2d3wNZEu9nNl2QzZ8EAaK0ZTG5PcJyTTMfEKrFI
	 T8tEiXAwz82zS9LGPV7rbiAF7dZYH72LRic96v+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 014/228] arm64: dts: mediatek: mt8195: Add missing gce-client-reg to vpp/vdosys
Date: Tue, 30 Apr 2024 12:36:32 +0200
Message-ID: <20240430103104.227026627@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 96b0c1528ef41fe754f5d1378b1db6c098a2e33f ]

Add the missing mediatek,gce-client-reg property to the vppsys and
vdosys nodes to allow them to use the GCE. This prevents the "can't
parse gce-client-reg property" error from being printed and should
result in better performance.

Fixes: 6aa5b46d1755 ("arm64: dts: mt8195: Add vdosys and vppsys clock nodes")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-2-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index b9101662ce40d..775aeeb6ebd37 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1998,6 +1998,7 @@
 			compatible = "mediatek,mt8195-vppsys0", "syscon";
 			reg = <0 0x14000000 0 0x1000>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce1 SUBSYS_1400XXXX 0 0x1000>;
 		};
 
 		dma-controller@14001000 {
@@ -2221,6 +2222,7 @@
 			compatible = "mediatek,mt8195-vppsys1", "syscon";
 			reg = <0 0x14f00000 0 0x1000>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce1 SUBSYS_14f0XXXX 0 0x1000>;
 		};
 
 		mutex@14f01000 {
@@ -3050,6 +3052,7 @@
 			reg = <0 0x1c01a000 0 0x1000>;
 			mboxes = <&gce0 0 CMDQ_THR_PRIO_4>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce0 SUBSYS_1c01XXXX 0xa000 0x1000>;
 		};
 
 
-- 
2.43.0



