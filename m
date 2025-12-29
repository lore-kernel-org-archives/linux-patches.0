Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F6334C0A;
	Mon, 29 Dec 2025 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026036; cv=none; b=kslm34pXmo1IgvA32oedYyu8DhhEuiao+BzhweM4ktQS+y9wAbIltmLlwIPfyhWZvVFcCFk8hu02A0XBC913ucNWcgdHP9V4ygZZc6bh712L9isWY4x0LUAmtOLUBaceISySf6g7A+fzr2oUv5ZRR+Sx5b1COeLYvkHQDcDS3Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026036; c=relaxed/simple;
	bh=V0vXyf0inOIfAnGHNgCfIIDa4aEFWGD4051EkCswIMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM4flReEmZsUikqaFgSKXvhnmTubInI1OMlje8T/r34kb5Z+rPPsCO8j+LR2njvbamX6vYQoUMqcdUQQ62MfpjJs36CbJHDiAfg7tMtYHKtnnghbfhkTr51zLtLpaAu29hlfTFYaEbyck2VCdt1Sb6fGsHMDrp/3AhgUfjnpkuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5Y7f92w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5Y7f92w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EFAC4CEF7;
	Mon, 29 Dec 2025 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026035;
	bh=V0vXyf0inOIfAnGHNgCfIIDa4aEFWGD4051EkCswIMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5Y7f92wArhGx8InvDKAOH4ZS1tH4IvxDum0rv+p4ZJ1+OlJ6blf/ykkqxYLEJXrq
	 UglaT0XyB5WFf0IiieQL704JfMuavsDI79NRxjmpwTwsO4R9clsTgkHUZudsdOS5DP
	 D07ZbioO+Vf+NpEoJA8Uw0rbvn2x6FjCCOeuhafQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Subject: [PATCH 6.18 425/430] ARM: dts: microchip: sama7g5: fix uart fifo size to 32
Date: Mon, 29 Dec 2025 17:13:47 +0100
Message-ID: <20251229160739.952928475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@microchip.com>

commit 5654889a94b0de5ad6ceae3793e7f5e0b61b50b6 upstream.

On some flexcom nodes related to uart, the fifo sizes were wrong: fix
them to 32 data.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20251114103313.20220-2-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/microchip/sama7g5.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/microchip/sama7g5.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7g5.dtsi
@@ -824,7 +824,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};
@@ -850,7 +850,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};


