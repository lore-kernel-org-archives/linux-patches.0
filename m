Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478701B85C0;
	Mon, 14 Oct 2024 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917560; cv=none; b=WNdomedpcsXEa2fyuzZ9NrQS9DtbWrMupPNKgX6dUXuz5u4eSBPkKbbgb2U5Pf9PF4IzTvcm68e2SdydfOzyjzARGvAxHzJ5kjxx4D88ZSAleyHsHDFrGrYzSO+OPIgaip95EW11AD7ZuPVKOmyBYBr8to6CFqKL1sNIC1cpCGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917560; c=relaxed/simple;
	bh=u1myUPNwp5D9lp01mmwLux8i/S4A6VU+ulWOUu3xltQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe8KV9USH8L5JwJB9tsqvlDDmTP57RBPZ6qiFcv0zsZnsIZU5xRnpsp/iyqeoevQZiSijBuX9Fab8R/FR0oVU1xYorsIixbqLquapLsm4hYA0KnRoZm2bFuBxKyI3ZdDgvoV6cZi2Rwgv9zGf2bVCWWPU6lY65YYWJHfe8T//gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YR8EbcSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YR8EbcSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEB9C4CEC3;
	Mon, 14 Oct 2024 14:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917560;
	bh=u1myUPNwp5D9lp01mmwLux8i/S4A6VU+ulWOUu3xltQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YR8EbcSZrz2PRyFHglOasQVzYkJJEZBcENSdUfcLY9IOEoOvk4dIJqpkSptnZWt9l
	 OWiV4QLVic5RDKjEwyf9h97MOgMz4fawuDiZNsjyTaQMyrEj+9oxgneZt/9ep0nmLV
	 xnDvnLOZOi/c14KI2fr23MkADjL6u0nrMYEqMo0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/798] arm64: dts: exynos: exynos7885-jackpotlte: Correct RAM amount to 4GB
Date: Mon, 14 Oct 2024 16:10:23 +0200
Message-ID: <20241014141220.649932507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Virag <virag.david003@gmail.com>

[ Upstream commit d281814b8f7a710a75258da883fb0dfe1329c031 ]

All known jackpotlte variants have 4GB of RAM, let's use it all.
RAM was set to 3GB from a mistake in the vendor provided DTS file.

Fixes: 06874015327b ("arm64: dts: exynos: Add initial device tree support for Exynos7885 SoC")
Signed-off-by: David Virag <virag.david003@gmail.com>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20240713180607.147942-3-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dts b/arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dts
index 5db9a81ac7bb5..06791d4f99b89 100644
--- a/arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dts
@@ -31,7 +31,7 @@ memory@80000000 {
 		device_type = "memory";
 		reg = <0x0 0x80000000 0x3da00000>,
 		      <0x0 0xc0000000 0x40000000>,
-		      <0x8 0x80000000 0x40000000>;
+		      <0x8 0x80000000 0x80000000>;
 	};
 
 	gpio-keys {
-- 
2.43.0



