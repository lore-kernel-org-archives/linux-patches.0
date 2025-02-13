Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D1826B096;
	Thu, 13 Feb 2025 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459471; cv=none; b=C7zAtJbFFpsjYhvpvipZ897b1WMJplbQTB3MAXJbgfCoaixzVQ469ycC0unXfIbGXUifzAoP6R1ARXHLQRjCEKQHt7aj0oGvDbGBg0fVt9h3QFguC86C9muYs4ommvKuEBfYBOcxDtBBvjvMxIYfZnKSwoi/iTVG8NNjbzTbJrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459471; c=relaxed/simple;
	bh=jlqOnnmo+pviOK4/lnmzcs7YLe5bVbO0RMqjKaZCSFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCAVCEXxNvnGyhE9ISFU8TqsRkkJ7vIPBMNqprHFazG8QDb5cM2k0m/l1dTX6DVs8qyPkmx6H4pfEJRCCMWg0hkDZJB/GBj8nK1dYnOPeOkqZTVJIDhZrrmF0YID94o4o1OA15Y7g0j+Jif2H3s49sUE53TxjTDOBg/FAKz2KJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QjoR3ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QjoR3ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF8FC4CED1;
	Thu, 13 Feb 2025 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459470;
	bh=jlqOnnmo+pviOK4/lnmzcs7YLe5bVbO0RMqjKaZCSFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QjoR3ry7hjM+Ck7a0E3Ky3HhHpCFg/zYA9gETca5W9w96DNTxRovHMsbu2YDch4l
	 Tnt7CSPvOKYBIKbQP3pOX1kv94694X1HLuownqshITZM6uj0UTkOpVQgMkeIWmscuN
	 hpsGltRB6vm2Ri/TKFLe5ictx45vGIigZql14Sds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 242/443] arm64: dts: qcom: x1e80100-dell-xps13-9345: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:47 +0100
Message-ID: <20250213142449.954466757@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 26a1b22aaf0c6f5128f8d0242caf3d983d5a2836 upstream.

On the X1E80100 CRD, &vreg_l3e_1p2 only powers &usb_mp_qmpphy0/1
(i.e. USBSS_3 and USBSS_4). The QMP PHYs for USB_0, USB_1 and USB_2
are actually powered by &vreg_l2j_1p2.

Since x1e80100-dell-xps13-9345 mostly just mirrors the power supplies from
the x1e80100-crd device tree, assume that the fix also applies here.

Cc: stable@vger.kernel.org
Fixes: f5b788d0e8cd ("arm64: dts: qcom: Add support for X1-based Dell XPS 13 9345")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241210-x1e80100-usb-qmp-supply-fix-v1-5-0adda5d30bbd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
@@ -820,7 +820,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p9>;
 
 	status = "okay";
@@ -852,7 +852,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";


