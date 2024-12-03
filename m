Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6371F7578;
	Tue,  3 Dec 2024 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238091; cv=none; b=IrDNBH3eTsuHkqSl9d62Oa3KEoBf4QQE2IlaQ9c2W3iwhmjKZPErP+GV2JSo1yPzNp6LMzFlvCXpwW0g1eS/opVHE1NZp0C7+U0cy+oLcXBR+3eODgCbuJpicnhFHVR+Y2z4DM1SuzhN8kDj9Xf6MDLLR05VF0RD4gOh/RC6uWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238091; c=relaxed/simple;
	bh=mCX7FiaQ4NP32ZRQBhjcFBAQBxfhoaTI/SRYoSDxBFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jir/MNaVbP/9VV3iBoeUEYFXSBI3fDAyaOHs0OXw/gWEiE5chD/T47M1th0SELbdQlCr1scHmmmxGf6fq6K+oUke7k2d9Wk/neWXNWvoIAt2T19u4mufFxN+qYt9QFTS/a0ScmqDHPwAoYk8U2BN6kxCkb1jBfwszwKyIXcjQBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LG1/TJXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LG1/TJXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9804C4CECF;
	Tue,  3 Dec 2024 15:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238091;
	bh=mCX7FiaQ4NP32ZRQBhjcFBAQBxfhoaTI/SRYoSDxBFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LG1/TJXVEC8qpxdrdyyz/5SJP08wu+xszKha66DABxiIOPBxZhh2oOFpVAQXJ2E2p
	 /7LIItn7KOMwEhufuduIVY4/X4JCTJnChiRdedBxdNPmZ4GEJBd+TdNTxKSw4mp7+3
	 HDUO+7ZfiL1Dd7FOS8b4ny6AemVrI5RHoio3Hzh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 158/817] arm64: dts: qcom: x1e80100-vivobook-s15: Drop orientation-switch from USB SS[0-1] QMP PHYs
Date: Tue,  3 Dec 2024 15:35:30 +0100
Message-ID: <20241203144001.893514686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

[ Upstream commit 27344eb70c8fd60fe7c570e2e12f169ff89d2c47 ]

The orientation-switch is already set in the x1e80100 SoC dtsi,
so drop from Vivobook S15 dts.

Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241014-x1e80100-dts-drop-orientation-switch-v1-2-26afa6d4afd9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
index 530db0913f91d..7d4e039f63cf4 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
@@ -598,8 +598,6 @@ &usb_1_ss0_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
@@ -632,8 +630,6 @@ &usb_1_ss1_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
-- 
2.43.0



