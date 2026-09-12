Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FF647CA67;
	Sat, 12 Sep 2026 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232252; cv=none; b=ZQjTsAyj9IGOm0sJwyaKD9CFZ/SzlNweX4VsWk07VrM3dZY4d4X505yKOV0p8+N3qr46Y6oMpohCLrtarEKHX4TkNKTG97hkgxzMhH2Zm/fJ57YxkJO8QO4GVCRKqw89gyySw/LYbaDEe0e1iaEGUMHynzGeA2QaG1dcUREPuUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232252; c=relaxed/simple;
	bh=INsweksKQSseEQZ+3LUUiKJpSMdYat7g1eMGCJ5KDXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evLvuqOpLavDpZhRkSz+5slRyJELOQqEkdcSLIKD72c9xdzmvv9yfQgTCgEIUpVl31AVQolGy+bxbxEEFPFYWjiFsGu6F9Q9AK2ueeCVw4aEsVXzsgYs/x3g3s6Qv1b5aWNRM0n97GUAD+2UPAO8+Uzi6kaRdRdFbzW4I43m+44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+PGkZ4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+PGkZ4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB0C1F000FF;
	Sat, 12 Sep 2026 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232249;
	bh=HFhC8VXla0QQ7seqpRzuoGfsgs9yfOsf9H6x/zU9Ej8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+PGkZ4I22fZ23jR1ChJqPTdNmhUb9+/JNC2QubQOot/s2gi1yJkcW0gE7bW2485+
	 3UpNwZ4Y3ixnpRpbUvI9zrhiaw0pEpxjyizwElBzPBrEf0O0hLufYwANMyd8XL/Tws
	 w1SrdCuLnfQoVUAtRkfCQ35atQUxppTuBzE2sXe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1165/1191] arm64: dts: qcom: sm8550: Fix the PCI I/O port range
Date: Sat, 12 Sep 2026 09:04:53 +0200
Message-ID: <20260912065614.307955628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 565c633940312b4eea7785a0a58e1944258c47e9 ]

For 1MiB of the I/O region, the I/O ports of the legacy PCI devices are
located in the range of 0x0 to 0x100000. Hence, fix the bogus PCI addresses
(0x60200000, 0x40200000) specified in the ranges property for I/O region.

While at it, let's use the missing 0x prefix for the addresses.

Fixes: 7d1158c984d3 ("arm64: dts: qcom: sm8550: Add PCIe PHYs and controllers nodes")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-msm/7c5dfa87-41df-4ba7-b0e4-72c8386402a8@app.fastmail.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230228164752.55682-5-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index aa9c25541e900..de74499bbfd9c 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1377,8 +1377,8 @@ pcie0: pci@1c00000 {
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x60200000 0 0x60200000 0x0 0x100000>,
-				 <0x02000000 0x0 0x60300000 0 0x60300000 0x0 0x3d00000>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x60200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x60300000 0x0 0x60300000 0x0 0x3d00000>;
 			bus-range = <0x00 0xff>;
 
 			dma-coherent;
@@ -1477,8 +1477,8 @@ pcie1: pci@1c08000 {
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x40200000 0 0x40200000 0x0 0x100000>,
-				 <0x02000000 0x0 0x40300000 0 0x40300000 0x0 0x1fd00000>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x40200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x40300000 0x0 0x40300000 0x0 0x1fd00000>;
 			bus-range = <0x00 0xff>;
 
 			dma-coherent;
-- 
2.53.0



