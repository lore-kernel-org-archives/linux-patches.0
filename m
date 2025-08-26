Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A787D2BEFF0;
	Tue, 26 Aug 2025 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207180; cv=none; b=h0Zkf696ZSmLQLOP/WxKKLC5zzzVO0IJoN0WHtbIougxW3kQynoa2hwwDBUTMzW/BcBJA4qgZcxum3TBvJmM2jUiXIiOwG3ZgmslR+GDTkELOoLIGCXChSL3Tx2C6m+cL0DFT/i6WdIxY0Xi+cqFTzD0spFUDtrW43eZ32kJWXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207180; c=relaxed/simple;
	bh=+te3wUcVN1xl0NNHoFl95s6dH7J/kfmCOlcbvHLz500=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLC3iWHMfsVb23JW++M5CmOp5ftSlYmHXlMJACE0Q8b9zFRMLpikdc48u5UCi73GBeOgbYg+whLmURTrCs7xkCXJ4Jg8RlpSLc9weI6SWBxdGswi4bh/7OaFL1m5VA3cLgyMjko1vGZqZ/gWUBxYwa3Rs16TOkoEhZXsyY9sh8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAXCuQds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAXCuQds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE3C4CEF1;
	Tue, 26 Aug 2025 11:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207180;
	bh=+te3wUcVN1xl0NNHoFl95s6dH7J/kfmCOlcbvHLz500=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAXCuQdsqAREAJ1HNr9cKY9sOrfJHhImZRRE0nA1Vt5A6JxdBJUrxemP8cncAMG0+
	 CUZC57MoDDmApKxegsFznljqwUfiHcexoFaB4LGzadNupTAy1Mknaap1i14oZlBcg7
	 BtqN4xXD9hO/no/lNY6S3moTaapCjgqmMTF4WlgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.16 050/457] arm64: dts: exynos7870-j6lte: reduce memory ranges to base amount
Date: Tue, 26 Aug 2025 13:05:34 +0200
Message-ID: <20250826110938.586086480@linuxfoundation.org>
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

commit 49a27c6c392dec46c826ee586f7ec8973acaeed7 upstream.

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
Link: https://lore.kernel.org/r/20250626-exynos7870-dts-fixes-v1-3-349987874d9a@disroot.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/exynos/exynos7870-j6lte.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7870-j6lte.dts b/arch/arm64/boot/dts/exynos/exynos7870-j6lte.dts
index 61eec1aff32e..b8ce433b93b1 100644
--- a/arch/arm64/boot/dts/exynos/exynos7870-j6lte.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7870-j6lte.dts
@@ -89,7 +89,7 @@
 	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x3d800000>,
-		      <0x0 0x80000000 0x7d800000>;
+		      <0x0 0x80000000 0x40000000>;
 	};
 
 	pwrseq_mmc1: pwrseq-mmc1 {
-- 
2.50.1



