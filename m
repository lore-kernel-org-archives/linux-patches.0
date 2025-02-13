Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8390626B098;
	Thu, 13 Feb 2025 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459480; cv=none; b=DYtjLWtUprKpRq+dXDobZ36JwnzMsLGicIHf2h8Gi1sdcSOOGIeaW1cLcCku2pFAJjaPk8znmoQ6rdKfy08rxD5vZSxW5A+ktyrSf0GS5s3C5pjziCCVyoOx15/LCLX16CTZ5TpDlrPL2LdCjQnZeGGlRBvSuFBpNVh1IhFuEdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459480; c=relaxed/simple;
	bh=6w8JEqtc0gBdUfbRvaUe8DcboWC96k2ckVtK3f+JA80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb5vxiY/g1CgZs1y9XlyEEW22KJ0hauXiaeucNp4jyuPx8poqbMEjX0NaJh/70gNcxrlSDf4kdEdsBwD+XtClRXgZDlFFPMk2+FraxbMDI0HAaEziT8JO26VelQ4N6cj+D5aAO2vPn4kbrvBst7hgR2bshuVEQSLjfKeSD7dafc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sc/ycYeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sc/ycYeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02933C4CED1;
	Thu, 13 Feb 2025 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459480;
	bh=6w8JEqtc0gBdUfbRvaUe8DcboWC96k2ckVtK3f+JA80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sc/ycYeIBbgI2Xg3GDgAVrbVDDkkfSJ2l06MFeNfhhzQ6gGwZcgT2QS1OT/ScW/R/
	 0NJRW5Rj4vsu3ncpNKOs5mL75OcufxXSXUkjXTd8HsKA9HnUR9WgUMgATrFMDOCi2l
	 zPgqIZlIni1p5U4tPdgbeJtHKoKUUeIEyIo32b2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 245/443] arm64: dts: qcom: x1e80100-crd: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:50 +0100
Message-ID: <20250213142450.069371733@linuxfoundation.org>
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

commit 789209dd08124da448bfa7524b21049a04d98f83 upstream.

On the X1E80100 CRD, &vreg_l3e_1p2 only powers &usb_mp_qmpphy0/1
(i.e. USBSS_3 and USBSS_4). The QMP PHYs for USB_0, USB_1 and USB_2
are actually powered by &vreg_l2j_1p2.

Cc: stable@vger.kernel.org
Fixes: ae5cee8e7349 ("arm64: dts: qcom: x1e80100-crd: Fix USB PHYs regulators")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241210-x1e80100-usb-qmp-supply-fix-v1-4-0adda5d30bbd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -1187,7 +1187,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
 	status = "okay";
@@ -1219,7 +1219,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";
@@ -1251,7 +1251,7 @@
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";


