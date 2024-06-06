Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F90119DF41;
	Thu,  6 Jun 2024 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683480; cv=none; b=oXf24DrZxEN33G9o76V/NeYm60xwcC9p2wR3x4TGmZ6Y/lzzHdp4Sj7GVUdAmk/CShoz+Y8jLe43AVeah0MDe6c4S66/jVfu8gq0q239FQ0rQu1xSbphLUAu/8EIGGV9adRF0gyA2h4VVhg64dMo0PZyrGC5xvjdL1717yGffzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683480; c=relaxed/simple;
	bh=4E3Dds+7XeMrIgQQ0ZqDZGv1vqtTp9W0r+gpcRlGF3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd7hs0pPHSamdsT5oe6FY4VCUKPDdjUgXVQECI57Z/GsocJsn3kbqvBheaDHdkwIOAJ8jfiHPJ50kwx0OadxDXK/b0Sud8C1/MFH4uIzuQmf8pBvE8CgkbKDCJYq7Lra9fPPmNg+4TGgG4TVYtBVTyw/CvTSQa4ycN1S4v1wv30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvmFQ0VJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvmFQ0VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C916C2BD10;
	Thu,  6 Jun 2024 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683480;
	bh=4E3Dds+7XeMrIgQQ0ZqDZGv1vqtTp9W0r+gpcRlGF3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvmFQ0VJzhsQ6LikSm5bQAUxVhDI2nxy5P1JIJPPPdcjhVVORAueSvP7Euzz2qQuU
	 d9gpIYRS8H78n1mvCXhv8jn9fJKWthEZdvKJgZX3m+8U5rWyHBnH97uFAix8eQfvds
	 npiy/YYWQ89Lc3HFX8eeO5OuhjuP0MKrqlJocUuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 423/744] arm64: dts: meson: fix S4 power-controller node
Date: Thu,  6 Jun 2024 16:01:35 +0200
Message-ID: <20240606131746.038694452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 55ddea6dc9f8e..a781eabe21f04 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -61,10 +61,15 @@ xtal: xtal-clk {
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



