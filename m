Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35FD1E00B0;
	Wed,  6 Nov 2024 12:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896489; cv=none; b=cXrCNYiyjtjzZ1g1JLJt0RhCSDofIzL6zbi0WmMH/rOGN9L+8uFBpurTLDWu1QNzAP2NQMrX7xcGBpWtq4ESMh+C2C6XHqqp5hSq+/cys4VDr2oS/9Ik2u2lcGDDhg7kDY7D7ZBRatku1dtCPIWkvL8C3TYT9onI6yMCA3JqSEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896489; c=relaxed/simple;
	bh=riixdz2zUTqr4BK/DPN16lttERMF9iBdtKtU3YmffOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvJqalIyZ7NC2WUud9YFuNg2ZDvCPm0bA6pMhOghjKMPH5ATeJsf1hn5tj9SOq/gCPHkljkE+2PV84VgpVrQTOwXdi2F08x9Sr19F5WuN4aCCUr53etJZRJvzJ1YI74yKDnBEq+tJ1ztCze0HJDus9e/0WnetMckKP8Gy/Rd1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrvXoR4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrvXoR4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25997C4CED3;
	Wed,  6 Nov 2024 12:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896489;
	bh=riixdz2zUTqr4BK/DPN16lttERMF9iBdtKtU3YmffOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrvXoR4uJLOb41Tu1X0bmze/ivwqE8fM9b8f/xjBAve3IhU3JagwXGPLqSR2g0cdg
	 xsicUJd/8SWbWXGfBhx4DHzds6f6dViT+H6FsssPj5AGwhJn2azmBeR/x6oesLCt1R
	 wIJbdPcUymrnwaxQhaayevzCIc6Hju2W505mEd+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 219/245] arm64: dts: qcom: x1e80100: Add Broadcast_AND region in LLCC block
Date: Wed,  6 Nov 2024 13:04:32 +0100
Message-ID: <20241106120324.647368502@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit 80fe25fcc605209b707583e3337e3cd40b7ed0bf upstream.

Add missing Broadcast_AND region to the LLCC block for x1e80100,
as the LLCC version on this platform is 4.1 and it provides the region.

This also fixes the following error caused by the missing region:

[    3.797768] qcom-llcc 25000000.system-cache-controller: error -EINVAL: invalid resource (null)

This error started showing up only after the new regmap region called
Broadcast_AND that has been added to the llcc-qcom driver.

Cc: stable@vger.kernel.org # 6.11: 055afc34fd21: soc: qcom: llcc: Add regmap for Broadcast_AND region
Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241014-x1e80100-dts-llcc-add-broadcastand_region-v2-1-5ee6ac128627@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -5700,7 +5700,8 @@
 			      <0 0x25a00000 0 0x200000>,
 			      <0 0x25c00000 0 0x200000>,
 			      <0 0x25e00000 0 0x200000>,
-			      <0 0x26000000 0 0x200000>;
+			      <0 0x26000000 0 0x200000>,
+			      <0 0x26200000 0 0x200000>;
 			reg-names = "llcc0_base",
 				    "llcc1_base",
 				    "llcc2_base",
@@ -5709,7 +5710,8 @@
 				    "llcc5_base",
 				    "llcc6_base",
 				    "llcc7_base",
-				    "llcc_broadcast_base";
+				    "llcc_broadcast_base",
+				    "llcc_broadcast_and_base";
 			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
 		};
 


