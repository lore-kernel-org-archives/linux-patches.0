Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC884239573;
	Tue, 26 Aug 2025 11:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208336; cv=none; b=F1m9GReQ10Gr15fAyE4X5KmwPQu+o3QfCWRL4g0sZ/0v/c1nX2xkip+dHEXD6pB6NRkrQb2iRcs51fDFWx9It6u/FNxcvWi7xc3P+s1APYGKXf7ixkFG9Ec4Lrpn6A24zGrbqu4CTWVINIgZqULuvgrmUC8MznGxW0w1Ojldxzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208336; c=relaxed/simple;
	bh=+XD3JnSFAqnylH62ix0K6PfgL1CGKhNXtZxWhhQh6Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BglrsZVmXU69GnW63dTaNkM4XcszA1Lj5HJJJai4jSS7UmA1t+rF7opVwNxtDW1JWS/Rd7WKZLdOOFGkk72EC8i873Vm8bhg2VhtGVr27ahhivMvWZ/TIwHYMsUybMeenhWOP+C0lmihcxhMuxOUO/L4gqkV4HRpfibTG+3IuRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEZOpjrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEZOpjrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C65C4CEF1;
	Tue, 26 Aug 2025 11:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208336;
	bh=+XD3JnSFAqnylH62ix0K6PfgL1CGKhNXtZxWhhQh6Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEZOpjrtjUDOiJ6bu5hXcq8GZdyzrpiE2hMyAlKGlQXEBnwiW6Y/z58/Jp9b7MrHe
	 3WFE8Os0gJv7/3gZYemo9Pzw7XUTQqu+8uGJIcYmQVI8W+pQyEOVmcWEy0LT+avVdI
	 EidUkheK0/68JRH+FivYq1cbDZTtIYOdx1aINsdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will McVicker <willmcvicker@google.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 041/322] arm64: dts: exynos: gs101: ufs: add dma-coherent property
Date: Tue, 26 Aug 2025 13:07:36 +0200
Message-ID: <20250826110916.387509362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit 4292564c71cffd8094abcc52dd4840870d05cd30 upstream.

ufs-exynos driver configures the sysreg shareability as
cacheable for gs101 so we need to set the dma-coherent
property so the descriptors are also allocated cacheable.

This fixes the UFS stability issues we have seen with
the upstream UFS driver on gs101.

Fixes: 4c65d7054b4c ("arm64: dts: exynos: gs101: Add ufs and ufs-phy dt nodes")
Cc: stable@vger.kernel.org
Suggested-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Tested-by: Will McVicker <willmcvicker@google.com>
Tested-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250314-ufs-dma-coherent-v1-1-bdf9f9be2919@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -1360,6 +1360,7 @@
 				 <&cmu_hsi2 CLK_GOUT_HSI2_SYSREG_HSI2_PCLK>;
 			clock-names = "core_clk", "sclk_unipro_main", "fmp",
 				      "aclk", "pclk", "sysreg";
+			dma-coherent;
 			freq-table-hz = <0 0>, <0 0>, <0 0>, <0 0>, <0 0>, <0 0>;
 			pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
 			pinctrl-names = "default";


