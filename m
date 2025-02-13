Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FAB38389;
	Thu, 13 Feb 2025 14:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458228; cv=none; b=qPFboHAPYVZek5sR6xbI4ox/rq+3PhID7avcwgDHlibrsMeNJbt81AB33UkfTO4c0/VNhlbvVLe9MvRiWooMG8PoRWa7WXXheSjDj1544UFoR9w+wxLcCAJYXWn4uWoXpOI+GckMt2sIzHVqkPyMvoVaWt4EiVHqTpN6f6HvCqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458228; c=relaxed/simple;
	bh=CAzl3XUPHBn5Un8hMFm/e19ZJ9sBLjNROsdgKYYXS88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYl/HlkU4xNCtw9DILOEBbslPYWMcCWkzGipFMzFVNAdbxVw8z/2+c5r9OKdfGWkZfRSvFUW8sKXzZqdN/zK27QAMlESOOqJkFlcFl93LsdT1KuQQxJt5LhySlftjsGTAL4at9sk6JfbgPSG3yfQqOCefnXqyLuhrgNZxrZ0PJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltqeiszG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltqeiszG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3E8C4CED1;
	Thu, 13 Feb 2025 14:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458228;
	bh=CAzl3XUPHBn5Un8hMFm/e19ZJ9sBLjNROsdgKYYXS88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltqeiszGbws1hMF2OxVbW3QeRmYDD05EIiocPmGoru/wr336vFKc+QtFilDKjQkIB
	 NX6/MucrsAu7sdj4IdSgUDE5Bck4sLHUZrOsGPfreQOTMhtB23+Jl/akDZuWvf2n1d
	 dP+9/ZdPgWraniKZGwqBqG40YRd1MWxarq5GG3tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 297/422] arm64: tegra: Disable Tegra234 sce-fabric node
Date: Thu, 13 Feb 2025 15:27:26 +0100
Message-ID: <20250213142448.002048750@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

commit a5e6fc0a10fe280989f1367a3b4f8047c7d00ea6 upstream.

Access to safety cluster engine (SCE) fabric registers was blocked
by firewall after the introduction of Functional Safety Island in
Tegra234. After that, any access by software to SCE registers is
correctly resulting in the internal bus error. However, when CPUs
try accessing the SCE-fabric registers to print error info,
another firewall error occurs as the fabric registers are also
firewall protected. This results in a second error to be printed.
Disable the SCE fabric node to avoid printing the misleading error.
The first error info will be printed by the interrupt from the
fabric causing the actual access.

Cc: stable@vger.kernel.org
Fixes: 302e154000ec ("arm64: tegra: Add node for CBB 2.0 on Tegra234")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Ivy Huang <yijuh@nvidia.com>
Reviewed-by: Brad Griffis <bgriffis@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20241218000737.1789569-3-yijuh@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3815,7 +3815,7 @@
 			compatible = "nvidia,tegra234-sce-fabric";
 			reg = <0x0 0xb600000 0x0 0x40000>;
 			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
-			status = "okay";
+			status = "disabled";
 		};
 
 		rce-fabric@be00000 {


