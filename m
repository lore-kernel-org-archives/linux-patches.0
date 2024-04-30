Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7064112CDB5;
	Tue, 30 Apr 2024 10:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474475; cv=none; b=MvnCCHYheeI/W1adW6x0DXnj7DuvPrW6rgg3mM8Pfce8rm8LYVqwEjRwhEWrnvm04hZXPB3PIq2TuYKg4seVAXpM/yqa3kFhK7p497qxi6/3T6xGQDtWUwZRwoILtcKLcb8pt0ing1WwwnY90z3JgM09vcH0WGWdGFhll3Y6QZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474475; c=relaxed/simple;
	bh=7FOT7C6LjNPRx+RaPdP5NjlcgCUGoODY6D7ApMH9tfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov99PgZrnpAJqEz6hklvRxDWL7ZfTnzSXSTPxg3BinorBLAdSlVhAqE8RqN87EEgT2IUOFPfG2wsXvC+AiyiEkTL16doImcUkLPI4GisfYkyroFMIrmA0hOY50cDFS66myGqVoCoTdOn88GUdS4bMW4vRK9V8chKRrwBHDPPiFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZYeBUZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZYeBUZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2394C2BBFC;
	Tue, 30 Apr 2024 10:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474475;
	bh=7FOT7C6LjNPRx+RaPdP5NjlcgCUGoODY6D7ApMH9tfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZYeBUZoTLpFQ2W1yvoph78qslFM2tEBKodnrRAy0HZa/LqPiiNKKdAHvRZGNkpck
	 S1caqpaXrNdby90ytOvTxHRUAF72Befe5mC6RmMXk7nLlkpOjLajzkjGIgIE5d2H6F
	 7OPT3a8x/pqZFh4KVneqCWTbPl+4Hp5kf45Fz2oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.8 168/228] arm64: dts: qcom: sm8450: Fix the msi-map entries
Date: Tue, 30 Apr 2024 12:39:06 +0200
Message-ID: <20240430103108.653512858@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit ecc3ac293ed15ac2536e9fde2810154486f84010 upstream.

While adding the GIC ITS MSI support, it was found that the msi-map entries
needed to be swapped to receive MSIs from the endpoint.

But later it was identified that the swapping was needed due to a bug in
the Qualcomm PCIe controller driver. And since the bug is now fixed with
commit bf79e33cdd89 ("PCI: qcom: Enable BDF to SID translation properly"),
let's fix the msi-map entries also to reflect the actual mapping in the
hardware.

Cc: stable@vger.kernel.org # 6.3: bf79e33cdd89 ("PCI: qcom: Enable BDF to SID translation properly")
Fixes: ff384ab56f16 ("arm64: dts: qcom: sm8450: Use GIC-ITS for PCIe0 and PCIe1")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240318-pci-bdf-sid-fix-v1-1-acca6c5d9cf1@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1777,12 +1777,8 @@
 			ranges = <0x01000000 0x0 0x00000000 0x0 0x60200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x60300000 0x0 0x60300000 0x0 0x3d00000>;
 
-			/*
-			 * MSIs for BDF (1:0.0) only works with Device ID 0x5980.
-			 * Hence, the IDs are swapped.
-			 */
-			msi-map = <0x0 &gic_its 0x5981 0x1>,
-				  <0x100 &gic_its 0x5980 0x1>;
+			msi-map = <0x0 &gic_its 0x5980 0x1>,
+				  <0x100 &gic_its 0x5981 0x1>;
 			msi-map-mask = <0xff00>;
 			interrupts = <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
@@ -1886,12 +1882,8 @@
 			ranges = <0x01000000 0x0 0x00000000 0x0 0x40200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x40300000 0x0 0x40300000 0x0 0x1fd00000>;
 
-			/*
-			 * MSIs for BDF (1:0.0) only works with Device ID 0x5a00.
-			 * Hence, the IDs are swapped.
-			 */
-			msi-map = <0x0 &gic_its 0x5a01 0x1>,
-				  <0x100 &gic_its 0x5a00 0x1>;
+			msi-map = <0x0 &gic_its 0x5a00 0x1>,
+				  <0x100 &gic_its 0x5a01 0x1>;
 			msi-map-mask = <0xff00>;
 			interrupts = <GIC_SPI 307 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";


