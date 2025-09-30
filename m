Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D2920E334;
	Tue, 30 Sep 2025 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245819; cv=none; b=a7dg/zQjE3yVL4vo8hs7p6u08DQwsTvgZEBOVURFI0tkp4lfR7fSGa1l7gz1Cc8T9CuSdZoVEBFE5hu9+8y3IUkn9YVejFKQPzVgKAQDLsP6S0vt4z5LXTr1fmjH3EEzIk3qqpeqXuZjyiDFVEXXWzc7a5nvMwbkY6Tx2MzFGzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245819; c=relaxed/simple;
	bh=ruSeDk8QAKnhmBorPitDalZCWmHWc6Nk/j7gx7BV87k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP8axPT2q6lqAskJarMvd+jZtVvyVKuvBdCOEVohUNauWQ3V/aT64L6rauYclGLjJTe2eQNNwAxzYh5e/ocxW+BVCl+mYeWuJYzV8vf6UAfF3poJz87wZ0mhzKkbHQVrG1HoeOaqT097FP4K99hVL9Ck8sYRHbdHxkAbpEeFCbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0fkbLkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0fkbLkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAC0C4CEF0;
	Tue, 30 Sep 2025 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245819;
	bh=ruSeDk8QAKnhmBorPitDalZCWmHWc6Nk/j7gx7BV87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0fkbLkX++Y2eMjBh+0iA8nIkuRc7Y+O5DReXb192i2a/QC/nKUhEQ2vvidJqp3fn
	 3VU4QFl8EV5CWrtD63L4bVd6Xy4erHjb3oBHI2R/WRqelyUoYQ+3pPZE4Q/884ToRo
	 6GT+kc7yyOJbnBibiBy+uX7KYxAxZcFUApXVnuWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/91] ARM: dts: kirkwood: Fix sound DAI cells for OpenRD clients
Date: Tue, 30 Sep 2025 16:47:27 +0200
Message-ID: <20250930143822.315134172@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 29341c6c18b8ad2a9a4a68a61be7e1272d842f21 ]

A previous commit changed the '#sound-dai-cells' property for the
kirkwood audio controller from 1 to 0 in the kirkwood.dtsi file,
but did not update the corresponding 'sound-dai' property in the
kirkwood-openrd-client.dts file.

This created a mismatch, causing a dtbs_check validation error where
the dts provides one cell (<&audio0 0>) while the .dtsi expects zero.

Remove the extraneous cell from the 'sound-dai' property to fix the
schema validation warning and align with the updated binding.

Fixes: e662e70fa419 ("arm: dts: kirkwood: fix error in #sound-dai-cells size")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts b/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts
index d4e0b8150a84c..cf26e2ceaaa07 100644
--- a/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts
+++ b/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts
@@ -38,7 +38,7 @@
 		simple-audio-card,mclk-fs = <256>;
 
 		simple-audio-card,cpu {
-			sound-dai = <&audio0 0>;
+			sound-dai = <&audio0>;
 		};
 
 		simple-audio-card,codec {
-- 
2.51.0



