Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF281D0E03;
	Wed,  2 Oct 2024 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879358; cv=none; b=eUSIMTEl/YF0iN3Cn8ktbW/Hp1wPC4Zqlrt5PzpDVNsYJj92YCNdxF9Ec0L08wWmaJ9jo8vBA0fKc3IK/BMlr9K60EYzwSAXOcTczM2K9rj1URZIJjT1zJXoNA12g8gmMWIFRp0pxHSc80FBrtz/BPYxDCw15IV4LquA7bZ5IY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879358; c=relaxed/simple;
	bh=cQOapON17+CjJoK1SLVeCabOuKD/jtIF+37PwuP5K7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GahX8hUGFGfCGy3IADBfVRC7MB5kQX9Wc3dggSbrsv8Wy4X17jPx66OzdL8hnZ1xqhiwRe5KQqrNRKUfnYuo6NYA/CpHRVW+Bz3BR0JDvSeXc5W3LSoqiFg+qzjdj1xPUNfU2/AoqE+JHDfAZZG5XWrBr5+XhBM51i9pwaJZMjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpkx2y4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpkx2y4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE69C4CEC2;
	Wed,  2 Oct 2024 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879358;
	bh=cQOapON17+CjJoK1SLVeCabOuKD/jtIF+37PwuP5K7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpkx2y4IqoA7CSttoayXqwsgJH6hC58FjSQ4LHpgXDOUnTKzU/OhaMbbi/uBfgnkp
	 6Z0BZe/2LuzdB46MmYKWSUtFJ0GePZuFLZ2mfUKp1IPpcP1+VbRZbvDEVZKRouCe8V
	 7thvyt+q/ho+v0Oxybo1XHXAJN3l7TWm60hGVOv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/538] arm64: dts: exynos: exynos7885-jackpotlte: Correct RAM amount to 4GB
Date: Wed,  2 Oct 2024 14:55:29 +0200
Message-ID: <20241002125755.779272922@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -32,7 +32,7 @@ memory@80000000 {
 		device_type = "memory";
 		reg = <0x0 0x80000000 0x3da00000>,
 		      <0x0 0xc0000000 0x40000000>,
-		      <0x8 0x80000000 0x40000000>;
+		      <0x8 0x80000000 0x80000000>;
 	};
 
 	gpio-keys {
-- 
2.43.0



