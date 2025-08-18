Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0924321F42;
	Mon, 18 Aug 2025 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524623; cv=none; b=PtmZlHGyBhxHCsLPL6hZfId1YTgkRGI9E4PH8LbX3NKgZBoYU4ZP5arbE1jdUrnGQ39naRd4yJBsoUVuCdlhmK1fftUgxfhQVxT3UM4PEbui8c5ykXhwt12tOOnoXRYn76Hn53X2Wr534nIiJfKqcOyWD6ASrd+VojRFnEjitCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524623; c=relaxed/simple;
	bh=QwvEOUAwghWURNZOUZctuIuhSqqfYYDVeRvJN0AMUXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzpNXMjTW0hUyYlqT2gzYzLrYk566audM2I+DPY0+mJCpMqvCOZm1RA7p6PS2kNglgC9Dt8AGfYGT+8sbyE1AGs4tsFuiluftQbU5ELQ4pjBdw/NF5mnEoHGM4SciNfpExil2MoInbUlLU3VYivxr4N/XnPEs6pEsSH4zRseD5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Hf8anQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Hf8anQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A19C113D0;
	Mon, 18 Aug 2025 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524623;
	bh=QwvEOUAwghWURNZOUZctuIuhSqqfYYDVeRvJN0AMUXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Hf8anQyjCmwdPZaMEFcSKHh35FJa4H2MZwzBckLjSCxqxV2Lelwb30xdMHvdimj6
	 N/5NbjTeFPHfnjCdc8hptD42lXBLeS/lyFLX3SOGKnPaqMNG56IgilTZZZouXEnROP
	 crq3Ax404bGHy/VES01EHyCWKb6LEHcW2lkwnKGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.16 013/570] arm64: dts: ti: k3-j722s-evm: Fix USB gpio-hog level for Type-C
Date: Mon, 18 Aug 2025 14:40:00 +0200
Message-ID: <20250818124506.293954277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 65ba2a6e77e9e5c843a591055789050e77b5c65e upstream.

According to the "GPIO Expander Map / Table" section of the J722S EVM
Schematic within the Evaluation Module Design Files package [0], the
GPIO Pin P05 located on the GPIO Expander 1 (I2C0/0x23) has to be pulled
down to select the Type-C interface. Since commit under Fixes claims to
enable the Type-C interface, update the property within "p05-hog" from
"output-high" to "output-low", thereby switching from the Type-A
interface to the Type-C interface.

[0]: https://www.ti.com/lit/zip/sprr495

Cc: stable@vger.kernel.org
Fixes: 485705df5d5f ("arm64: dts: ti: k3-j722s: Enable PCIe and USB support on J722S-EVM")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20250623100657.4082031-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -634,7 +634,7 @@
 			/* P05 - USB2.0_MUX_SEL */
 			gpio-hog;
 			gpios = <5 GPIO_ACTIVE_LOW>;
-			output-high;
+			output-low;
 		};
 
 		p01_hog: p01-hog {


