Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D7E178384;
	Tue,  8 Oct 2024 12:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390779; cv=none; b=at+89G6uYZ4+1FS91rl379BbdjWeVSDrIZ5/l7pwLqdJZVJ9mbYixUW9/UZSvtuoaH32AbUmnh1ZLe4NgNLl7RXherL0nAHW5YDZLiOzjhkTQYs7SFq9PW9AyBuhnd5ALItGsvtu+fvzoQnUzlgAnNxSCVM6jDJAXdEBU6h+Nhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390779; c=relaxed/simple;
	bh=gP1ZBdtIYs/YAbwxXhvtswtwgVLSsVT/1ywKa9AhNHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCLUr/WslteSoQhQ+gE27jcLt5egWDhqgKniL5Sa0ouMpomTXb87gazPlaihTI3FMNeMTAvVF1x44ZhciEmplkEOQhDikZ6qNksqDg98JPuaY+bvfEXoCWONwlBnJRztXOcOYz9x6h1SSBcWpC50A6sCQoccarSrNEGpJd41iUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svqi9zDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svqi9zDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E44C4CEC7;
	Tue,  8 Oct 2024 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390779;
	bh=gP1ZBdtIYs/YAbwxXhvtswtwgVLSsVT/1ywKa9AhNHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svqi9zDEJaFISxpEiN8yJvwrx5sEaLBWn+HwFHxN5JRgLrsNenYvMgpDCz4arI1Wk
	 +0RVFvEtAkFZEKIcMZPV36FUUS9oEWSw28vp+95FHkn3oG/N8FvqMdPtwjapXc1gUR
	 5kyeUZIuTV5MDJ5upuc4fgA4a8j16kHaePPZzfHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 389/482] dt-bindings: clock: qcom: Add GPLL9 support on gcc-sc8180x
Date: Tue,  8 Oct 2024 14:07:32 +0200
Message-ID: <20241008115703.721985670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit 648b4bde0aca2980ebc0b90cdfbb80d222370c3d upstream.

Add the missing GPLL9 which is required for the gcc sdcc2 clock.

Fixes: 0fadcdfdcf57 ("dt-bindings: clock: Add SC8180x GCC binding")
Cc: stable@vger.kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240812-gcc-sc8180x-fixes-v2-2-8b3eaa5fb856@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/clock/qcom,gcc-sc8180x.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -248,6 +248,7 @@
 #define GCC_USB3_SEC_CLKREF_CLK					238
 #define GCC_UFS_MEM_CLKREF_EN					239
 #define GCC_UFS_CARD_CLKREF_EN					240
+#define GPLL9							241
 
 #define GCC_EMAC_BCR						0
 #define GCC_GPU_BCR						1


