Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0E51974E8;
	Thu,  6 Jun 2024 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682908; cv=none; b=Ekrts+ynNuP3mOSZWZBVN8ze+Q0z3kgoody31deSBZFDUcDPBt/e/5yymzMMR90zWCnFC7jDneY/kHerQHyuyszfrfm5xADONM5QmWUUI8XYkJ4kIcOvP5pyR1Tttrsu6QB9fDT7exDa3LRYFTyvrkylEiSDp6IQnXVKn1I7+tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682908; c=relaxed/simple;
	bh=HVJpiTLHNuSn3mcpMS6zchnd6FcP6Yi3okUi0oWtT/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHclme3+bIMSv7Of5d0G5aXY753gEDtULrYCgq8uusX9W6CPF++yEGdu9PM3EQbduZEYtNnpRBnraHThvGXCpZps3JaosryaM0nUJGBHcmm2QDiyy5cZTZAYGGQAdL3coRXvaCKER14rNKhiAsiwKrvooXKr1tuVp6b/ujGgaIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mLyoqhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mLyoqhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFCBC2BD10;
	Thu,  6 Jun 2024 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682907;
	bh=HVJpiTLHNuSn3mcpMS6zchnd6FcP6Yi3okUi0oWtT/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mLyoqhPRd2mtnMXbzbxpmccOHcYp4De2IPeUN+jLIFisX7k5QJl1YHtfbGf8SnaP
	 Inxg1aL5MPueyGgP+Gzk/VzNGW0Vh0olaCCAinX0l1dbbLqgiUaPqBGrdltFPGpbyg
	 ZbjgIY+LiuFBidIbbrvm3eCdmZOtYdr4aVzQDwkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 033/374] arm64: dts: meson: fix S4 power-controller node
Date: Thu,  6 Jun 2024 16:00:12 +0200
Message-ID: <20240606131652.928796691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit 72907de9051dc2aa7b55c2a020e2872184ac17cd ]

The power-controller module works well by adding its parent
node secure-monitor.

Fixes: 085f7a298a14 ("arm64: dts: add support for S4 power domain controller")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240412-fix-secpwr-s4-v2-1-3802fd936d77@amlogic.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index ce90b35686a21..10896f9df682d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -65,10 +65,15 @@ xtal: xtal-clk {
 		#clock-cells = <0>;
 	};
 
-	pwrc: power-controller {
-		compatible = "amlogic,meson-s4-pwrc";
-		#power-domain-cells = <1>;
-		status = "okay";
+	firmware {
+		sm: secure-monitor {
+			compatible = "amlogic,meson-gxbb-sm";
+
+			pwrc: power-controller {
+				compatible = "amlogic,meson-s4-pwrc";
+				#power-domain-cells = <1>;
+			};
+		};
 	};
 
 	soc {
-- 
2.43.0



