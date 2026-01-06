Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0215D33C18C;
	Tue,  6 Jan 2026 17:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720612; cv=none; b=RrDKhwvp+Yz1YILQNdfcOTFKHzmmRrdrGZKaEOsrRjVQpQc/kuCmv+p3S95FK8f4jhaftlfWJE4QEI/+qXF2dH1sYYNU+BmIBVCCKf2fuJc0oAcM5VVTheZoMrsn7zZAqo0ky+TjYi+Gz/bDl7MyHIKF1c9IL2Emve0dD7td7Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720612; c=relaxed/simple;
	bh=C/midlt9gN99fhrx5QhXnB8sDlBofmh8Q4FgCC8Bnq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhv3ASqxEcZ63+/VNLHFo3ETSf2amBz3UUv01G3mMOi9LEJho2oF9gDBruhiun0lUqSbj32xK+nLRvy2a7skzWaieXiJye+6ir10ZpG16Q7lhe4u9iIWHxwU3o70y72HigUD6Ntub1mkWBsNGdAIfDqA60R2I/2xSSd9O9yV5H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5jftEQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5jftEQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630DAC16AAE;
	Tue,  6 Jan 2026 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720611;
	bh=C/midlt9gN99fhrx5QhXnB8sDlBofmh8Q4FgCC8Bnq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5jftEQ6Z3oO2AGtuzSA8SZ4IBwcCRjsFG3fMfoo8eWYdVR4g28Ekt3GJ50vyMTru
	 Vgn/V/LTIC9HIeCDMRcZU2UqWQSebTqn3PCFt2aV14OkaHlUcF/sGwbqw7UCN8F3yg
	 ONtSl8mN3oYgDr5ejQKjOJxaDmgom3zSY40aan+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Subject: [PATCH 6.12 290/567] ARM: dts: microchip: sama5d2: fix spi flexcom fifo size to 32
Date: Tue,  6 Jan 2026 18:01:12 +0100
Message-ID: <20260106170502.060463331@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@microchip.com>

commit 7d5864dc5d5ea6a35983dd05295fb17f2f2f44ce upstream.

Unlike standalone spi peripherals, on sama5d2, the flexcom spi have fifo
size of 32 data. Fix flexcom/spi nodes where this property is wrong.

Fixes: 6b9a3584c7ed ("ARM: dts: at91: sama5d2: Add missing flexcom definitions")
Cc: stable@vger.kernel.org # 5.8+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20251114140225.30372-1-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/microchip/sama5d2.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/microchip/sama5d2.dtsi
+++ b/arch/arm/boot/dts/microchip/sama5d2.dtsi
@@ -568,7 +568,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(12))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -639,7 +639,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(14))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -851,7 +851,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(16))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -922,7 +922,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(18))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -994,7 +994,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(20))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 


