Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CAD1D04B0;
	Wed,  2 Oct 2024 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875532; cv=none; b=SXRCCW71/U0JQt1mbsHwSWCRMWhPYVANvsnj8UPjlOwmGhxWW8dJNeot1bEn4IT/F4F2hV5D4Sd3TyHqQp5MHVqPDuZbhEtcQL0us2QmD39GZC4f2Z1py7XfDTh5m/i8oER94gTchK/MfZJZ6Q1KKDpIOU1yDyDyT+pCjyoGlWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875532; c=relaxed/simple;
	bh=jv/IILCe8K2E1ouyFuKs1kYxAOXc3g+CB9ClyDjNtc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5W1R43nETd3ZOG2UM98jK5rRJlINgn9FZzUxup9wkQBTcwa4v8QY9qS9i4ja2BTGoVMiZsV//KRsKdnVmjA4N3bzy5rBPnJyft1DNhwLHgbulXtshK5is2xvSMhMGEYKBHtZDHr0ZcXHRKVXzJBlRq3RlYnhSCwLXJdSoz3QWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC3Ba6fH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC3Ba6fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C012C4CEC5;
	Wed,  2 Oct 2024 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875532;
	bh=jv/IILCe8K2E1ouyFuKs1kYxAOXc3g+CB9ClyDjNtc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC3Ba6fHglawb0sFxoqT1BSuA6qZpPDzwQr4ivLe5+54LEjp5pTbhOOXi2j3nuN41
	 /x1fYRwBP1LmdN/54SB0VCBlRAsPVDBqRK/jL80X6mHhcs2o/72dErM7bB8wPxUojE
	 1maMOErzMwIKMiBkUa3hBCdiUnlIkPsEANyxlqGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 134/695] arm64: dts: exynos: exynos7885-jackpotlte: Correct RAM amount to 4GB
Date: Wed,  2 Oct 2024 14:52:12 +0200
Message-ID: <20241002125827.836451862@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 47a389d9ff7d7..9d74fa6bfed9f 100644
--- a/arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dts
@@ -32,7 +32,7 @@
 		device_type = "memory";
 		reg = <0x0 0x80000000 0x3da00000>,
 		      <0x0 0xc0000000 0x40000000>,
-		      <0x8 0x80000000 0x40000000>;
+		      <0x8 0x80000000 0x80000000>;
 	};
 
 	gpio-keys {
-- 
2.43.0



