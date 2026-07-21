Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144446AA72;
	Tue, 21 Jul 2026 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648115; cv=none; b=f29z4DZ3jSb/sTNug8c6fURa25KnbINXeQw9lGpmbaZSTeqPLfIyud16E6ONrF2xski47UnPovoPelFL3Jd4XXEzWoXtj0eJYv4F7G/oMXEYeU2tDAZHZqrmx+mTjcIV2obFDLmgBEYG7F/C/h5/cOD53JE8ghTeVnI98Bm3pqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648115; c=relaxed/simple;
	bh=aJ7hMmr+EkU1q6hTbIcxdOWNU6gRUlQaiuWsUPoMXBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmxR1JVq+kI/u14xpkAeu69Db8EnCSoTIvXE8m0MtAOO8aEHaoOTQBeHA5VJJNV2FFRoeuNM4JAHncHOKNajtbOnWIm1ZBv0iYQC0381w4C0lmmGfHqlrv5KJP5vidiNaFCHymBdOvoC4NJXoQDHdPlW3QQV2NSD/KstPV/7Hlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytyavg9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytyavg9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14121F000E9;
	Tue, 21 Jul 2026 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648113;
	bh=I/wstIxOQ8cZlXsCztqH3DJJMqgiv3ux9G/4VlQCEYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ytyavg9Fo7VmHJTaI2yyRDgXj89dQAQOS6oGuoqHtoLv4JpDOdptZLVxxwUWDFYaR
	 jOufCJWhnp1e3JMHCfV74AqJnGGkpBbEt/cTB3cqgjpov4eJuwzaraddJdwNGrHuEa
	 hxikuBQQacDlYJEIlbpnQvQ7dWSz5i/daEMP/OWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0075/2077] arm64: dts: rockchip: Fix vdec register blocks order on RK3576
Date: Tue, 21 Jul 2026 16:55:48 +0200
Message-ID: <20260721152554.462652288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 63fd2f6aa402a105fa22ede6f3c35dafd64827a5 ]

When building device trees for the RK3576 based boards, DTC shows the
following complaint:

  rk3576.dtsi:1282.30-1304.5: Warning (simple_bus_reg): /soc/video-codec@27b00000: simple-bus unit address format error, expected "27b00100"

Since the video decoder support for the aforementioned SoC in mainline
driver and devicetrees hasn't been released yet (just landed in
v7.0-rc1), fix the issue by providing the register blocks using the
'link,function,cache' listing, which follows the address-based order as
shown in the vendor's datasheet and, implicitly, ensures the unit
address points to the primary register range.

Fixes: da0de806d8b4 ("arm64: dts: rockchip: Add the vdpu383 Video Decoder on rk3576")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260304-vdec-reg-order-rk3576-v5-3-7006fad42c3a@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index 28175d8200d57c..e12a2a0cfb8916 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -1281,10 +1281,10 @@ gpu: gpu@27800000 {
 
 		vdec: video-codec@27b00000 {
 			compatible = "rockchip,rk3576-vdec";
-			reg = <0x0 0x27b00100 0x0 0x500>,
-			      <0x0 0x27b00000 0x0 0x100>,
+			reg = <0x0 0x27b00000 0x0 0x100>,
+			      <0x0 0x27b00100 0x0 0x500>,
 			      <0x0 0x27b00600 0x0 0x100>;
-			reg-names = "function", "link", "cache";
+			reg-names = "link", "function", "cache";
 			interrupts = <GIC_SPI 308 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cru ACLK_RKVDEC_ROOT>, <&cru HCLK_RKVDEC>,
 				 <&cru ACLK_RKVDEC_ROOT_BAK>, <&cru CLK_RKVDEC_CORE>,
-- 
2.53.0



