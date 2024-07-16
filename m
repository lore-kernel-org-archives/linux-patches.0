Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ADB19B59C;
	Tue, 16 Jul 2024 15:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144937; cv=none; b=LhUAwKN4TRXPM8vV9EBWR8zGQUCqSHl6noIM9uZ4WKFT+HsNb1V3rBpUc3wCpuJiDg8qqnA/KhkfL6lZuSuVxZB/bnjt/2swzJ5cvNxy9Fl//oAWuWhUPThgiV/3oRTJhJOr1CeTcvB1wzjPI6ngnlf9AgCHbUMI6ACINYNvBuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144937; c=relaxed/simple;
	bh=ljNyt4AEDAkX7GW9SIrE7eTQpv0CYk33ibptlsaUcOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCN0B498VDvGIwbMlLF+HI9DcTWM1KWAypdLZD0YIyE8+LAVmRDjHa1hUfx3k5TC6ALwZGlMFv3XUxbbCfccBWWNABQk5YZblonYmTWNffmMY9DzDI8cOVXIPcAIpl4QV6Y9+qtzPq+UwDQhStt70BRGWw+0w3SykWepVMj2XhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVNrP1zU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVNrP1zU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CDBC116B1;
	Tue, 16 Jul 2024 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144937;
	bh=ljNyt4AEDAkX7GW9SIrE7eTQpv0CYk33ibptlsaUcOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVNrP1zUabtTpRBY3kOXDd+x+MBytE4IWWrYRUGyQTulhPGEpqU/P5n+ok5wCMvsX
	 JRZQFee6dDZLvJoy1f+DpvLWPSXL+mNIqX3S6K5Sl8H4Bky0QqxVRdEa/9qtW9c1xp
	 CalLSYLBKZfxJrzYP8p3dKoSzBeNLF1kHumHf6bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 045/143] arm64: dts: qcom: sc8180x: Fix LLCC reg property again
Date: Tue, 16 Jul 2024 17:30:41 +0200
Message-ID: <20240716152757.721091047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 3df1627d8370a9c420b49743976b3eeba32afbbc ]

Commit '74cf6675c35e ("arm64: dts: qcom: sc8180x: Fix LLCC reg
property")' transitioned the SC8180X LLCC node to describe each memory
region individually, but did not include all the regions.

The result is that Linux fails to find the last regions, so extend the
definition to cover all the blocks.

This also corrects the related DeviceTree validation error.

Fixes: 74cf6675c35e ("arm64: dts: qcom: sc8180x: Fix LLCC reg property")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240525-sc8180x-llcc-reg-fixup-v1-1-0c13d4ea94f2@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 053f7861c3cec..b594938c757bf 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2608,11 +2608,14 @@
 
 		system-cache-controller@9200000 {
 			compatible = "qcom,sc8180x-llcc";
-			reg = <0 0x09200000 0 0x50000>, <0 0x09280000 0 0x50000>,
-			      <0 0x09300000 0 0x50000>, <0 0x09380000 0 0x50000>,
-			      <0 0x09600000 0 0x50000>;
+			reg = <0 0x09200000 0 0x58000>, <0 0x09280000 0 0x58000>,
+			      <0 0x09300000 0 0x58000>, <0 0x09380000 0 0x58000>,
+			      <0 0x09400000 0 0x58000>, <0 0x09480000 0 0x58000>,
+			      <0 0x09500000 0 0x58000>, <0 0x09580000 0 0x58000>,
+			      <0 0x09600000 0 0x58000>;
 			reg-names = "llcc0_base", "llcc1_base", "llcc2_base",
-				    "llcc3_base", "llcc_broadcast_base";
+				    "llcc3_base", "llcc4_base", "llcc5_base",
+				    "llcc6_base", "llcc7_base",  "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.43.0



