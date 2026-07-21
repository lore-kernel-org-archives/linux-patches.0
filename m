Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2796B46AA7B;
	Tue, 21 Jul 2026 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648149; cv=none; b=sCUPAkPSKj6ej9d3WVEcYiugEkzt61MMLBhrKNkLGtVkqSH9QiFHVWAUVQ3drNW4HoDkbTFmzn8yy+KZXOQLO5f1snlQVrsNKEZiXFapLkNYYyNL5oiMOI21LvGoXdif0tSu5usJG5F4prn45Ni/adWfO2mhcs7gNlVKboNtoTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648149; c=relaxed/simple;
	bh=N44VnvrbhK+gguOlnVqL+jwqoxV85h81UCZ31GIUiZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuxKn/VnjHHNlUf9M5OFmPP4CdwbIkKrpgFU+BSsIVyIb5JXEm+GLzsgx3mJZFHfOe5X6zSpDOquijcGCN+BMDEkd0TAscNVNYJS2CRZEAxl5GOca8iDOJ9MhmZbqPbHYkK+6PjDgMHy3OzB3IlP8ZGLB+B+DF1/kIHutV8ZOkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EW0nCZdO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EW0nCZdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2BA1F000E9;
	Tue, 21 Jul 2026 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648148;
	bh=leMSUSubGzLIBwQ24FRTJOwHA2M+wykb26IDSeRG7fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EW0nCZdOv4V0lKKZdtqVJpSzpUVxEIhSElQ5EqZXceo8Cd4FYYfM6EYuMYTIjRPip
	 pYU+2vYKzcGYT0EQY1X6JzuzvAwr9HHel/MZzDZzGAflNvYhjgaDxwn6fDU2NkqTeT
	 eCmjaq/2YumJnAAekrLXEhI4hrbd6hPjm2TDegy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0083/2077] arm64: dts: qcom: sdm845-oneplus: Drop address from framebuffer node
Date: Tue, 21 Jul 2026 16:55:56 +0200
Message-ID: <20260721152554.653819945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit b379bb1470d864659ae9522b72f241a15255dce6 ]

This node has no 'reg' property, so it shouldn't have a unit address
(after '@') either

Fixes: b0d5c96e860c ("arm64: dts: qcom: sdm845-oneplus: Add framebuffer")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20260402-beryllium-fb-v4-2-46170004da28@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 6b7378cf4d493a..b0b9baf01ec292 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -72,7 +72,7 @@ chosen {
 
 		stdout-path = "serial0:115200n8";
 
-		framebuffer: framebuffer@9d400000 {
+		framebuffer: framebuffer {
 			compatible = "simple-framebuffer";
 			memory-region = <&cont_splash_mem>;
 
-- 
2.53.0



