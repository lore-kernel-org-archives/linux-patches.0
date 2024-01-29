Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D63F6FE01;
	Mon, 29 Jan 2024 17:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548480; cv=none; b=n09DCg6DE7iWziLhIYlfxaZKNxYEIcwoEsIKaz/kYUMRzR7+AUCUr9H4OVbLpYym6bJh2zO0YKMzgzuYwjGA6pZwfIZ+z0FJnX7Y9wlqAVNW0+ssqvvbyE+bYI74/1GBrszD6all1XCDnpdJn73cG0oXy91bADjkcujXT+c0J0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548480; c=relaxed/simple;
	bh=0ArKEyKmwl/3hCYPLkt7/2g6qa9G6DKvWKlhhN+OhAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmQSPgg3yLaxQfI8ZrH3aM+CTPT+T7xLLvRCuLM4LzGiEtS/wOBUsKzOUM5VBH+8sT0zJf8ucXqEyjVkVZbIT5koQsBRX9OskV4Z81UxBnXmqqdzD23qN+W4qEgbHLdxfjkDSIvNxCM9LWLYw4PrwGY/VYyqSZNTRjZEUBswmzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUY6jKh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUY6jKh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D1AC433F1;
	Mon, 29 Jan 2024 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548480;
	bh=0ArKEyKmwl/3hCYPLkt7/2g6qa9G6DKvWKlhhN+OhAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUY6jKh8NANksDLsBQqJpw3v0i5lNCAkxCqES6oMRQVqM8/UmIFCoKgz721qrM4P8
	 O/1GpbX64ri/p7cbd3KBD/EY1nTJ+Td5anlmnlyHBnmHWu+9ql3Orq8xWszMT+k4xw
	 uhNYYyXHyZ02HxdgoFyrRAplH6owuI7zhNuQmkg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 082/331] arm64: dts: qcom: sc7180: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:02:26 -0800
Message-ID: <20240129170017.333632252@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 9b956999bf725fd62613f719c3178fdbee6e5f47 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Cc: stable@vger.kernel.org      # 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2978,8 +2978,8 @@
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 8 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 9 IRQ_TYPE_LEVEL_HIGH>;
+					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


