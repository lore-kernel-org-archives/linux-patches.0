Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9224D19A29C;
	Thu, 25 Jul 2024 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918329; cv=none; b=D3qdmQjQNk5iGmK+n/W1puUML4sYta3Czy2mGvO7SpmC+l3bCdPHmzGNgQXBQHDKyxWp6FZ5nM+QtAESeb9PH3UKIdbTWAf7BeTmuRjGEj2lnkRD2BsUA4QJDiSedvLT1qNMSpC+1ENLx7zohBtCu/aM2gJ7UHkaaxKwQFEolgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918329; c=relaxed/simple;
	bh=uioX+3JVJBQGG45Q6yXDF4ydlbWyehuXOlI5MLvgMO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfi/4Ws0yaKxaP5U1H/ZqQf5j3SbaLUZWWTY4HfDEq3x1lOxAXmskPkXNoC3I60+qIdiEPw/HW66nQq+dssOEpBHN6JD5vTU6Q19FmWCCoWX7qGYTefrCayrFf04gbPd/pCsqNSPvPAh5rXxK0ZpPxdinhiXn93/g7wfpGodwTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdeZ5Be4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdeZ5Be4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197E5C116B1;
	Thu, 25 Jul 2024 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918329;
	bh=uioX+3JVJBQGG45Q6yXDF4ydlbWyehuXOlI5MLvgMO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdeZ5Be4GbkEq5S25h/tCHWYRg96qTdm6BuGhoyBoC5VYIKVxJFTjOSGaDY0kvqgK
	 Ig48YfYYL/Dx6k+CYCRQCs6sPWKWzYwdz86ZYew26faqcYWrmfDX4n4+K9dzVOXmEf
	 T4akaXjrCW0QnTTmu+c5I5N3LkpaNekjl0Wfoywo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 17/29] arm64: dts: qcom: x1e80100-qcp: Fix the PHY regulator for PCIe 6a
Date: Thu, 25 Jul 2024 16:36:33 +0200
Message-ID: <20240725142732.463820675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit 87042003f6ea7d075784db98da6903738a38f3cf upstream.

The actual PHY regulator is L1d instead of L3j, so fix it accordingly.

Fixes: f9a9c11471da ("arm64: dts: qcom: x1e80100-qcp: Enable more support")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: stable@vger.kernel.org      # 6.9
Link: https://lore.kernel.org/r/20240530-x1e80100-dts-pcie6a-v1-2-ee17a9939ba5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -470,7 +470,7 @@
 };
 
 &pcie6a_phy {
-	vdda-phy-supply = <&vreg_l3j_0p8>;
+	vdda-phy-supply = <&vreg_l1d_0p8>;
 	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";


