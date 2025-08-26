Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D652248A5;
	Tue, 26 Aug 2025 11:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207110; cv=none; b=n3K/agkMcMPDmW68wSd5bI8wy8kl9k7hV47G6Ef9eqXOgEJ2yML1W41l4BMCKv8+BmN+zzas8/3fpE4yRry8nXOaLTUKW0zk2Jiy0iWpRn8WsJN1TwAKYLrUm1g0WiLDLx1w/9cU0CVs2gv3xHVBKdCtWGHh43jDWr3azonadJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207110; c=relaxed/simple;
	bh=HsK3WOmfhtUQJZa6/l4Fk+Gz9wB2CKayUsiNRsZM2Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RTh5vBSqa7dY6Zk8Mmv4Xe3QZlvOeYiSviEgd4CCLSyHd3y2Djln3RLMlfaOe1UAwWS2DruNxALgDRVrrUqTvQynqTmKNu6hbHBHmr1A8dqFbDxFsaz+62CgUu0q4iqNnUNyAQZMjNJ/SNpeHbTgd3TCLB7E3KKd1VaxidkpQnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoSE92rX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoSE92rX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9DDC4CEF1;
	Tue, 26 Aug 2025 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207110;
	bh=HsK3WOmfhtUQJZa6/l4Fk+Gz9wB2CKayUsiNRsZM2Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoSE92rXMdMYakXXgvuBKJrESihFl+8pRvX+q+KM1sz72wmTkNqmR+7hlsYReZ165
	 E3O62HabnesYcY9i+w4xji1N9OYXW1Gwk0Or9pPwd8HfGCFf2UQk3zFB1RdM5Vt2QQ
	 AuICI3549jH8UlgeaMpbHMYSkSE32/gWfChM0zPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will McVicker <willmcvicker@google.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.16 055/457] arm64: dts: exynos: gs101: ufs: add dma-coherent property
Date: Tue, 26 Aug 2025 13:05:39 +0200
Message-ID: <20250826110938.714094373@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1371,6 +1371,7 @@
 				 <&cmu_hsi2 CLK_GOUT_HSI2_SYSREG_HSI2_PCLK>;
 			clock-names = "core_clk", "sclk_unipro_main", "fmp",
 				      "aclk", "pclk", "sysreg";
+			dma-coherent;
 			freq-table-hz = <0 0>, <0 0>, <0 0>, <0 0>, <0 0>, <0 0>;
 			pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
 			pinctrl-names = "default";


