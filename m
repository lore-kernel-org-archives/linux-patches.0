Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1E6296BDF;
	Tue, 26 Aug 2025 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207118; cv=none; b=Q9EZrcHtQ3SkAr16N/C9euirY9eA+jwqrQ2ijDlvdJN5MLzQGaHReCw3krSTLFkrshCRXRKZWgiu5MLysqqmiplPSXdc+gTRLhfJBDKPDMX4EPuq9t0zOvsnhe/A9X71sU9k7h+wHmSEpG4m68rGNIj4HRqb6PMmaiOTSa+P4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207118; c=relaxed/simple;
	bh=1n0tiqhxo+Tj3EWnA1lP144UfK+PvaeaqaOPK5G3IvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJQzEGfPem4NsOOwTI1GNYtiRcMzn3jGpl5s7/TrRaXxG7MbftEayod+/pi0NybUjKvz1/oFfv5kcj5eFyFUrKdVNO7dZME9DepR56j+HVkqkYesFaHIj3DBr4VkSy2hjFx8INkji24H6g4PPg68RtdaBzNlpVK5C9o7OJFeNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12hnPREe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12hnPREe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF25C4CEF1;
	Tue, 26 Aug 2025 11:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207118;
	bh=1n0tiqhxo+Tj3EWnA1lP144UfK+PvaeaqaOPK5G3IvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12hnPREeszGb3l42iVvqKISr3J0MkE6QC7WSiWd3hvaXxAa55ZGHfEZamoduAfutg
	 cOpIePMJGIZhT9EjPz0j3HWV0gazPwndmHaSSzvEjnPs1rXkPk1VUSudOA1la9m1PV
	 25nu3cF0AxDyhzd+1FRvDTcynrTeSFiUUsoq1axU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.16 058/457] arm64: dts: exynos7870-on7xelte: reduce memory ranges to base amount
Date: Tue, 26 Aug 2025 13:05:42 +0200
Message-ID: <20250826110938.791085383@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

commit 2bdfa35a7bb6e3a319e7a290baa44720bc96e5e4 upstream.

The device is available in multiple variants with differing RAM
capacities. The memory range defined in the 0x80000000 bank exceeds the
address range of the memory controller, which eventually leads to ARM
SError crashes. Reduce the bank size to a value which is available to
all devices.

The bootloader must be responsible for identifying the RAM capacity and
editing the memory node accordingly.

Fixes: d6f3a7f91fdb ("arm64: dts: exynos: add initial devicetree support for exynos7870")
Cc: stable@vger.kernel.org # v6.16
Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Link: https://lore.kernel.org/r/20250626-exynos7870-dts-fixes-v1-2-349987874d9a@disroot.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/exynos/exynos7870-on7xelte.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7870-on7xelte.dts b/arch/arm64/boot/dts/exynos/exynos7870-on7xelte.dts
index eb97dcc41542..b1d9eff5a827 100644
--- a/arch/arm64/boot/dts/exynos/exynos7870-on7xelte.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7870-on7xelte.dts
@@ -78,7 +78,7 @@
 	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x3e400000>,
-		      <0x0 0x80000000 0xbe400000>;
+		      <0x0 0x80000000 0x80000000>;
 	};
 
 	pwrseq_mmc1: pwrseq-mmc1 {
-- 
2.50.1



