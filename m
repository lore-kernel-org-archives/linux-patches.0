Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CB41C175A;
	Wed, 19 Feb 2025 09:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957606; cv=none; b=Gz19yVu/UAtJa8B8kHE9cmEWwN1rXCKFcN9RtnUiisojoujHobCjQetypvrVPlaEWUtsczVf5fHJD5lv2GhSJVHa3rKEL07Z6fp5k5OUNS7R+165GUg9LpCzVpp9z4LWsIsBojsVYc8PX7YsAZW82chCc1a/qugaG/uZ6/RXWbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957606; c=relaxed/simple;
	bh=CByLJuqZjbuhd8Uc4vXQwrvw7sRMgZv0xYhvUDqqPKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVJssqH2jbtctGAEmHMayLb+etV1PKUem+nk9V0lNcnVPecWg+YADhkjx9nEI+b+4fmvvmNlq/phzFBf6OcKXMVlePG6EGLe/FobKw/oF/t8UBHJTOVZeNBo0h4KjX2y1GCQymlKxu6BUSMQM5ItoeEL3TAFMMjO2d+I8i63MX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhLyrOsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhLyrOsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B55C4CED1;
	Wed, 19 Feb 2025 09:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957606;
	bh=CByLJuqZjbuhd8Uc4vXQwrvw7sRMgZv0xYhvUDqqPKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhLyrOsUROM0UZFnIjWO0xNInHZYtky0R68+SSaekTTvTfYMYjY5rrsZUzfgaWj1V
	 m1GfWG63Dcymy6POQVJK1tDnMv1f+/D9bd9/3utyEZzpA5U/kJYxyYhERr5n0XdQM9
	 Xo6fRqkZegf+2liy0spu8KkvDTXExx56AxP6/FW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.1 562/578] arm64: tegra: Fix typo in Tegra234 dce-fabric compatible
Date: Wed, 19 Feb 2025 09:29:26 +0100
Message-ID: <20250219082715.070179717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Brad Griffis <bgriffis@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -1558,7 +1558,7 @@
 		};
 
 		dce-fabric@de00000 {
-			compatible = "nvidia,tegra234-sce-fabric";
+			compatible = "nvidia,tegra234-dce-fabric";
 			reg = <0xde00000 0x40000>;
 			interrupts = <GIC_SPI 381 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";


