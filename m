Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB4F2B9C7;
	Sun,  1 Sep 2024 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208662; cv=none; b=pUUBi/kz/jNiwo558Zrj/XzEHMDO4NpUfG5+vjGMHVb6YBJkysP4NVRE8tKnGHpc1JgRtrrSaNh36y2BQsFyJjkkDSFCgqSdzWPN48PPRQfwP4l9S/rsj13LiIJLqUmcCa6Y1a2XmkKT2GO+5Xp9b3uG3hSmjbzRssXBLVIaUTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208662; c=relaxed/simple;
	bh=7kbXJUBF5oRFzlolCMPqzfzdcCkfEPHf8c+iZptqfEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF+bGna7gKZezHiJO1sK0PAE+ez0WXSL8F33XqkiEt4bMb7Z1YuJDGXeLrc6pwUYtltd3B5N6JhUgpuQzoAqKz9H9pt7cJ8j+AUpAJurBD/nG9aR841YCytjBLQf69R/gZnatZWkPxQg7XTpq0/W4Dvrq5i8InCfD+Pqxh/PSCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEgMCAHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEgMCAHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B612C4CEC3;
	Sun,  1 Sep 2024 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208662;
	bh=7kbXJUBF5oRFzlolCMPqzfzdcCkfEPHf8c+iZptqfEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEgMCAHCX10L/buNxwHs+DltYnUjI//JW5p7+rdZdR/EjKnUPRe+kQM9v3CFWFPyK
	 LD3jWamIJdCWLmON7fUpfOSv5M6BJ/idC7CGEBOOB+EagYIZoNwJ0DOKUyYCio1IL1
	 iP2RQdt45D0y+P7vsVeoWLR/WHEkgJ3erwen+/PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 126/149] arm64: dts: qcom: x1e80100-qcp: fix PCIe4 PHY supply
Date: Sun,  1 Sep 2024 18:17:17 +0200
Message-ID: <20240901160822.191648993@linuxfoundation.org>
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

commit f03dd49f884f428ba71efe23383ff842f4f15e0e upstream.

The PCIe4 PHY is powered by vreg_l3i (not vreg_l3j) on the CRD so assume
the same applies to the QCP.

Fixes: f9a9c11471da ("arm64: dts: qcom: x1e80100-qcp: Enable more support")
Cc: stable@vger.kernel.org      # 6.9
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240722095459.27437-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -459,7 +459,7 @@
 };
 
 &pcie4_phy {
-	vdda-phy-supply = <&vreg_l3j_0p8>;
+	vdda-phy-supply = <&vreg_l3i_0p8>;
 	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";


