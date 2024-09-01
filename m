Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D7D1C68C;
	Sun,  1 Sep 2024 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208659; cv=none; b=lXtYeRJMfDmjRbew2iG8athRs1/AlidjCYtEj01Qi+jTrw6Eg99gI5KmOhkfNKeZ7ySQsnaTqiGd9gM1J5Z4+SQr17zltl5nHft6YF8EMWHr4nGMmLzLgYoNcT7zGYywJJzYdQ4//vUf7ZSFRI+np2S+0otxn1cFYDNOwgkD/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208659; c=relaxed/simple;
	bh=OToiNimeUX2JiA9pwAa5c3KZtsaSooSvQ3q8mRlnYM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIIO0tne8lP1XAV9uo6/ApLflRc3sTzCunlVn2hLSDhQbVneiW3Jy+E9OtM6RvVtT8LayLgUAwFLK/gH5gOduy9O6/8PEF4aqNWwe9d2rKYZYkpbLNJ2sZZqBX+IU2IF6ena7GTMDXjFZdj5F8aMRIVf3TcjYYRmaQs/AcJbAdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIaCaFaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIaCaFaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07418C4CEC3;
	Sun,  1 Sep 2024 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208659;
	bh=OToiNimeUX2JiA9pwAa5c3KZtsaSooSvQ3q8mRlnYM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIaCaFazSF5dh4IklZaKbuRGyPJu/JsX/yj5XL4057iMP+HIfOXSdOlZ1KRLeocbJ
	 f68ZZJP9U6gtag9l5kufxNW5ovS0POml9xxiMskHxQ/GUGqwPCeXwFcfXLHThkPK2U
	 FtALnrQ14Zgjp487WB9cY3Lf9u+ZJQYoohBikRUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 125/149] arm64: dts: qcom: x1e80100-crd: fix PCIe4 PHY supply
Date: Sun,  1 Sep 2024 18:17:16 +0200
Message-ID: <20240901160822.152902278@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 30f593fa0088b89f479f7358640687b3cbca93d4 upstream.

The PCIe4 PHY is powered by vreg_l3i (not vreg_l3j).

Fixes: d7e03cce0400 ("arm64: dts: qcom: x1e80100-crd: Enable more support")
Cc: stable@vger.kernel.org	# 6.9
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240722094249.26471-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -648,7 +648,7 @@
 };
 
 &pcie4_phy {
-	vdda-phy-supply = <&vreg_l3j_0p8>;
+	vdda-phy-supply = <&vreg_l3i_0p8>;
 	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";


