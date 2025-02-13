Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DEA281369;
	Thu, 13 Feb 2025 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457811; cv=none; b=Xf/ZFaBNmfR6G56yc7Tat/CbK9RpqYU2AQFhKf2El1lo+3xlgSYWoP+XeJOB1nGwK/Xsj5Jtr4H4lMXEB7yQFTr2bA1u+Gxec7tCAcRWZ7IOmRBqpisYYmLjBjFSjGdZsUkIQ3MLt6HM9S1jWDqa7bBWRrv8qHOsz0+TYOJdhz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457811; c=relaxed/simple;
	bh=urLt782zl49HJgIUOXOQ0lMelDdsma5zeO5uF9t6XgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtKJfptyAwGbt0JJ9lPqiBu+F9OsE3PV/MR7Xnvb1wnrc9ZoZ+hzDkXjrRIhKt61SA+6bVCtHukgizkpdakfrPB8U6OEPZd3eHNirXpq6Qt1RdxZ7EAY7ENOuWbuuwYX2NLBdiGtSzXIIDvQ1KrudlpP+fe9WrOTJIaLmGRtLm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM5QGMoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM5QGMoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446B9C4CED1;
	Thu, 13 Feb 2025 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457811;
	bh=urLt782zl49HJgIUOXOQ0lMelDdsma5zeO5uF9t6XgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM5QGMoSdMw+gsvCi4hA78PQ65P1OpPbl9PCzo4YqIwfsjkOirnb3L9QwuDcKRSAC
	 O5bzVmzKPeQn5URGn3/mKNS/6K/fo1Lmi/zkdY0PXS8I8ulSpaODbpQXt5pxUJHFJ3
	 UYkvZxvljxtSpzsxZZFz4kVdFGrXFZ29gpCiZN5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Maud Spierings <maud_spierings@hotmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 219/422] arm64: dts: qcom: x1e80100-asus-vivobook-s15: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:08 +0100
Message-ID: <20250213142444.988782686@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit bf5e9aa844ca74e9c202d8de2ce7390d24ec38a4 upstream.

On the X1E80100 CRD, &vreg_l3e_1p2 only powers &usb_mp_qmpphy0/1
(i.e. USBSS_3 and USBSS_4). The QMP PHYs for USB_0, USB_1 and USB_2
are actually powered by &vreg_l2j_1p2.

Since x1e80100-asus-vivobook-s15 mostly just mirrors the power supplies
from the x1e80100-crd device tree, assume that the fix also applies here.

Cc: stable@vger.kernel.org
Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Maud Spierings <maud_spierings@hotmail.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241210-x1e80100-usb-qmp-supply-fix-v1-3-0adda5d30bbd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
@@ -591,7 +591,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
 	status = "okay";
@@ -623,7 +623,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";


