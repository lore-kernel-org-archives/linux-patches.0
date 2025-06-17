Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7CA2ECE9E;
	Tue, 17 Jun 2025 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176390; cv=none; b=deI2imXOf8JVeM1uT4cv0Sh6lJIVNynuWnH/7+xG6F4TYVb7ID64kr9pyz+pKb2VAGCZxJWYl3YPJivNbGSP/IcD4LJoD/zdv+FowoBKzAO2Mwq6PHkI3Ebu43+MYMNO/pxGLDhP4M7pjtEta79MJbnHdtK8rFZxfywCtJ6BZ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176390; c=relaxed/simple;
	bh=2vMKfV576QIvsxaRsYvHil3gtwk+07Zpzr7+Y13URv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHejbOcx2Rb8ZtiTVU0fab2lIbWmee/WKH1DZQfC90fK1wDmTNa5CHzLjugw+eRe3U0kpRHf2Ir+mhM/vIX77b2eIyGfsHePvikB5fF0efmGjTWlw0wnPiMzg7JnzhpqWzDVarfbgp+DOp2sC0Bn7/LS+j5hYoP+mu2S/azvzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2wj7Toj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2wj7Toj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAFDC4CEE3;
	Tue, 17 Jun 2025 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176389;
	bh=2vMKfV576QIvsxaRsYvHil3gtwk+07Zpzr7+Y13URv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2wj7TojF/Gwe62GRtO6daDa3JL/NBluqtqWtL9Q2UtwxbA+B2OR5e3+PNSElO2EF
	 Va26G6GNcmi7wJ1VIxZyZbefdH40rGIZjb/QdcztLgtENWVZEtFa9rtOLw1pnnZqIK
	 nrucLKsWz065RKUbDDnBzv7BMIOQK9Aa/r0vXKxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/512] arm64: dts: qcom: sdm845-starqltechn: remove excess reserved gpios
Date: Tue, 17 Jun 2025 17:23:11 +0200
Message-ID: <20250617152428.739301006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit fb5fce873b952f8b1c5f7edcabcc8611ef45ea7a ]

Starqltechn has 2 reserved gpio ranges <27 4>, <85 4>.
<27 4> is spi for eSE(embedded Secure Element).
<85 4> is spi for fingerprint.

Remove excess reserved gpio regions.

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-5-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 8a0d63bd594b3..5948b401165ce 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -418,7 +418,8 @@
 };
 
 &tlmm {
-	gpio-reserved-ranges = <0 4>, <27 4>, <81 4>, <85 4>;
+	gpio-reserved-ranges = <27 4>, /* SPI (eSE - embedded Secure Element) */
+			       <85 4>; /* SPI (fingerprint reader) */
 
 	sdc2_clk_state: sdc2-clk-state {
 		pins = "sdc2_clk";
-- 
2.39.5



