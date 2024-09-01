Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701981C68C;
	Sun,  1 Sep 2024 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208669; cv=none; b=IIFBKUK50gwXZ13wVjcgrkZSP2ytLL6CWL1nPw/ZNjm/HAPL3tJJw/EhsxLvgShULqOSzz45v2Y1kydjAcviFv2xwQnSHkOZ3QECZ2Kc0v5rQ47DrVEhxoz9AmtWUI98WzUz5J1aekryy7xon9W7/GMNP8WoX5hMgd/VtYIQXXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208669; c=relaxed/simple;
	bh=1SM28nTHpPHPGU+tFqlOvmAj5Gup5pgR2kpRj6aLFR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAxCCecUyJLylX9gDV6eknCipQbPdktAsJVEm/d3FXTPVrpWZ1ceOaJ/J/7ZO3XULAVEEkaGKHdsLhRr21Rq8d7smBIbv+VRzWQaTZj0qRg/omadgIdh/2zAlIom775OI393H42Iz7lcF2dhSaW8Zy549YiVBKwvuEg4cmFpjVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+LJW3sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+LJW3sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD89C4CEC3;
	Sun,  1 Sep 2024 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208669;
	bh=1SM28nTHpPHPGU+tFqlOvmAj5Gup5pgR2kpRj6aLFR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+LJW3sk2Ip6g/NgOq0ZMYA0wyLbM560NN5cfv8w1uVxhHKGfmBf0j/KnmIXJcjQ7
	 oncvie9y3BdlqNH1pjJX+2Rl28nsHqNWKWph3STZb10LvSJPsJ3rW7S7xkrqf5XOh+
	 KG2f0dihhP7CiclVn+ucq1IiPllEaLv9QvY7VrzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 128/149] arm64: dts: qcom: x1e80100: fix PCIe domain numbers
Date: Sun,  1 Sep 2024 18:17:19 +0200
Message-ID: <20240901160822.267884459@linuxfoundation.org>
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

commit f8fa1f2f6412bffa71972f9506b72992d0e6e485 upstream.

The current PCIe domain numbers are off by one and do not match the
numbers that the UEFI firmware (and Windows) uses.

Fixes: 5eb83fc10289 ("arm64: dts: qcom: x1e80100: Add PCIe nodes")
Cc: stable@vger.kernel.org	# 6.9
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240722094249.26471-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2756,7 +2756,7 @@
 
 			dma-coherent;
 
-			linux,pci-domain = <7>;
+			linux,pci-domain = <6>;
 			num-lanes = <2>;
 
 			interrupts = <GIC_SPI 773 IRQ_TYPE_LEVEL_HIGH>,
@@ -2878,7 +2878,7 @@
 
 			dma-coherent;
 
-			linux,pci-domain = <5>;
+			linux,pci-domain = <4>;
 			num-lanes = <2>;
 
 			interrupts = <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,


