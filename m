Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7348326B0A5;
	Thu, 13 Feb 2025 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459651; cv=none; b=Gz63NKdwJIiyhIQhZwAScSQkK3mc0jkzjMXa7jFBacSfSLrf4/1MV71jka0N/TBQZiszCj3Fj4JVy/RG1OhNfYS735QvkaB6ZAsXzhdj9QTOYZgH77iicBxPniEAAxFaT5F/S51fmcDv/uUUwQbDoElB01ZnDupbJ17N4Utjado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459651; c=relaxed/simple;
	bh=5iz+tUV1cj8a2Xpi+GaflYk8WuR2Utnd+hxLix8AbaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOmVmce+6IbMc7mkzpwpUzFdEPzBCI7oSms8q37XZuAQHJYDpaVJymXNiROHFxJqyI58yPFv32MqkCRXp+4Q9I3P4Uj9YR4hpHMdJjR/BqxwHbJW5qmnoX0ARklPBYOGiRL8dti9iuF5NHqicHOlEmLNnVmEFEiF3a7C7ZzIdiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWZKUxQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWZKUxQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C78C4CED1;
	Thu, 13 Feb 2025 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459651;
	bh=5iz+tUV1cj8a2Xpi+GaflYk8WuR2Utnd+hxLix8AbaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWZKUxQ5Yc/IqE0K1Hs7ulWL7GjFxBQGfqpjUFo0f3lhjmdAjx75N/69Ox0t4zMZN
	 o9VIV+jxH5tbY3KZl2RKHd7aOYL2KzPBYmhR30i/LH7EzYjXkAdt/XK3VzgY4fOk8h
	 wAZDVx0gr2otQMyUx4euAnNiUKXTIRUBHrNUoxzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.13 325/443] arm64: tegra: Fix typo in Tegra234 dce-fabric compatible
Date: Thu, 13 Feb 2025 15:28:10 +0100
Message-ID: <20250213142453.160135826@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

commit 604120fd9e9df50ee0e803d3c6e77a1f45d2c58e upstream.

The compatible string for the Tegra DCE fabric is currently defined as
'nvidia,tegra234-sce-fabric' but this is incorrect because this is the
compatible string for SCE fabric. Update the compatible for the DCE
fabric to correct the compatible string.

This compatible needs to be correct in order for the interconnect
to catch things such as improper data accesses.

Cc: stable@vger.kernel.org
Fixes: 302e154000ec ("arm64: tegra: Add node for CBB 2.0 on Tegra234")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Ivy Huang <yijuh@nvidia.com>
Reviewed-by: Brad Griffis <bgriffis@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20241218000737.1789569-2-yijuh@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3995,7 +3995,7 @@
 		};
 
 		dce-fabric@de00000 {
-			compatible = "nvidia,tegra234-sce-fabric";
+			compatible = "nvidia,tegra234-dce-fabric";
 			reg = <0x0 0xde00000 0x0 0x40000>;
 			interrupts = <GIC_SPI 381 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";


