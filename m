Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E15C1A285;
	Mon,  2 Jun 2025 13:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872071; cv=none; b=tO5g1m/xBEQOZo2hpvzFle6r5LQW+6BepVBTtkjXHtEppJmneFRiPbRcCQyXxQMPj7wHGnqibeBiEsXHHmV9Hm82Mx/9f4a9J4JC7AR1hfwk1mzgZ9UJh3SpaFtRv7TE/Abkl+7kCF0X6fThqWNhJW2/ofFu6fMSLyD+IrzboYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872071; c=relaxed/simple;
	bh=2DgwyOr6abMc78aMfR4JuP1wJH0LVoF2dHY0RNbxV0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW2aS6nEm5kpgwbtdNvsgnyJqkzR5DuFAnCttdcmKAFX5t+0yYBlz2YnBG0mnDGnZ14s3fjpNJhVT0AVbQQyowHtMM/cAYbTRv0YjqDMZ0Af7KOrBBXR9Ezwi+eBsjCb8JV2W7W93inhQl4t5jSkJWCWrQy/i496CJovrziN0AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpllhRME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpllhRME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DABC4CEEB;
	Mon,  2 Jun 2025 13:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872070;
	bh=2DgwyOr6abMc78aMfR4JuP1wJH0LVoF2dHY0RNbxV0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpllhRMEjb+VHDkKq0u+0Mo0y4ckbeuMU/6RXrZ8+Q6Tbo98E2KjAncjWaCs7EOZD
	 cmi2l0BP8oq+7IyO27bSBPRkCfhu5IquHvR9kDh0PW7hDXyDHsjc/+UklLwyD3VVEZ
	 lDJ7dElQRSlPPmo0YEgnd2RtgoPY7kTT4+Q7ENTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.15 01/49] arm64: dts: socfpga: agilex5: fix gpio0 address
Date: Mon,  2 Jun 2025 15:46:53 +0200
Message-ID: <20250602134237.999182833@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit a6c9896e65e555d679a4bc71c3cdfce6df4b2343 upstream.

Use the correct gpio0 address for Agilex5.

Fixes: 3f7c869e143a ("arm64: dts: socfpga: agilex5: Add gpio0 node and spi dma handshake id")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
@@ -222,9 +222,9 @@
 			status = "disabled";
 		};
 
-		gpio0: gpio@ffc03200 {
+		gpio0: gpio@10c03200 {
 			compatible = "snps,dw-apb-gpio";
-			reg = <0xffc03200 0x100>;
+			reg = <0x10c03200 0x100>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			resets = <&rst GPIO0_RESET>;


