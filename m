Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1AE2ECE93;
	Tue, 12 Aug 2025 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023338; cv=none; b=DV1hgLcBOLRdCVaBUYAG1f7tIHe8BienjqHlSAOk8BOpZk0Ss3LAFCtwhFJITglHOU1QUJeh5s+iiKgy+gASNN4YQRrxdglOnYqO+Fli0FAfiewoyLZJZJQxrx5sVse/Cj1pCPnkdHxwT7LtsDw8E3nV9rj+hoBAp4ea2pN9mQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023338; c=relaxed/simple;
	bh=z6m9ZIOzYYcchvqk75LXOmLpkPLFsXyC9FVpMXRfZ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkLRG2UtvYZfyhcI1P4+coc/hiSSJusFwaDadtWi2dFXDYCyU7dOR0mcqxdFPuZG0sjqE2W/ogAt5qc46QwU/D4DjWJj2Y/wfGGvOt9FWt0uoo7F8b+QDY+qbg0BtyPuBUO4m9DrVT/D/IFsUmAuDb83CgVggTy/+ZsI/4Rmd1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYXjkQyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYXjkQyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FCEC4CEF6;
	Tue, 12 Aug 2025 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023338;
	bh=z6m9ZIOzYYcchvqk75LXOmLpkPLFsXyC9FVpMXRfZ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYXjkQyKMqxhRHbSAZEmZl2s3j+0yUnw734J1wPXlNL1t9jP8I0OPsbsY63Z3vR88
	 sbEqukG9kvH2uF044zO4JPERC5yvDvxrWqix9ML/mrYHpHH+vgFGEgRitLcN6s2Gec
	 YNZPyBjTyVaId5f6o19JAKLzr66oqsnfT1DoM9ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 050/627] ARM: dts: vfxxx: Correctly use two tuples for timer address
Date: Tue, 12 Aug 2025 19:25:45 +0200
Message-ID: <20250812173421.235004211@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f3440dcf8b994197c968fbafe047ce27eed226e8 ]

Address and size-cells are 1 and the ftm timer node takes two address
spaces in "reg" property, so this should be in two <> tuples.  Change
has no functional impact, but original code is confusing/less readable.

Fixes: 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer node.")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/vf/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi b/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi
index 597f20be82f1..62e555bf6a71 100644
--- a/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi
+++ b/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi
@@ -603,7 +603,7 @@ usbmisc1: usb@400b4800 {
 
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
-				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				reg = <0x400b8000 0x1000>, <0x400b9000 0x1000>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH>;
 				clock-names = "ftm-evt", "ftm-src",
 					"ftm-evt-counter-en", "ftm-src-counter-en";
-- 
2.39.5



