Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7B713C816;
	Thu, 13 Feb 2025 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460714; cv=none; b=bcBqS1vPkZAjltHXaGA7YsyqFMZQ+M+CXXV7SoMeqlpQn4fOmu1QMH4ob1raSNZtS4iid6WV7DBY8nT0vreXtn5ef4tSfGhiX5aRxoXqDJi2QVP8guWfX7D3ZRgxjqRnwhY1kIpSqPbyEuIwgOTWpJO7RTCKKv3xrqPJAX239qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460714; c=relaxed/simple;
	bh=PL7nnoOMgrTiTeIOvK0OlSKzn0gwQRE19/H+VyAR4a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBeeZoKqQJJCmQziiFufVgl3jk9fQkny4W6NvXYC7X3FAnLFNtvKelte+aF6NNZWQxpGRQ2NCBQvdy8BL6p0Ep9WVacMRiLG5+ncdWYpzA3U/aFniiTpdsozt3o7sa/XUk63lUR63ZxCv+0nCO7xc1OKOFcitYtMwNSE6Wkt4VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJHYK6Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJHYK6Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8209C4CED1;
	Thu, 13 Feb 2025 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460714;
	bh=PL7nnoOMgrTiTeIOvK0OlSKzn0gwQRE19/H+VyAR4a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJHYK6FfAi6ddFoV4RaDAEtAaCzRVoH0/h9ePbEgjRMgyiFNiR2r7Yp2qwFjpOBFx
	 xO7v984CJG+6ysyDugrfVdWgqaWYpLey5eiWITCgjLn1ayY9qCjz+WH8DgunT/3qp7
	 ZQmaGO+DXgpeao+AKgGaubMQCz/Xxz7dxYO33iLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.6 191/273] arm64: tegra: Disable Tegra234 sce-fabric node
Date: Thu, 13 Feb 2025 15:29:23 +0100
Message-ID: <20250213142414.871970156@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1709,7 +1709,7 @@
 			compatible = "nvidia,tegra234-sce-fabric";
 			reg = <0x0 0xb600000 0x0 0x40000>;
 			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
-			status = "okay";
+			status = "disabled";
 		};
 
 		rce-fabric@be00000 {


