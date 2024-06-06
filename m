Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B61A3BBD;
	Thu,  6 Jun 2024 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683238; cv=none; b=LMZoQVl7uwcy7hEOxjPl+ufj3P901TiFG6kWebReNriX3eAf/yEZ3KyBi6mCSyOCcoZ9/Qh6KKXVc+I1LDoFYJW8FZBKnJUGpxLIizGamMOWLHrzodJW1ZMkO5xSjydF08fQurQfFoHO4VRBqA7ILpvgKwJhoodbl6B7Kam4gSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683238; c=relaxed/simple;
	bh=70uRE1xtpiaLtfhTTyVF7y9uUV0cZKI95A/34f+IdAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy2s7pmpwrPqUUdcbAhM4ghigiI6mOVqTFxYL4S4FXagOSxxpLiQXPD3zaL9U6HlETGabBWmp7t3TfQWPAtA0ofQJS1JNbSetmON0O17NIFgNH6rFJZYOPyA95FP0Y8OaV15tDiyRqwhgtIN1jI0ujtnjNvJ6qkiCpLyee+C+k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYUkWiao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYUkWiao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FE1C2BD10;
	Thu,  6 Jun 2024 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683238;
	bh=70uRE1xtpiaLtfhTTyVF7y9uUV0cZKI95A/34f+IdAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYUkWiaoueRMpiXdq3VTorDEGzMA/QVAWB3X4SSQqTSsiHxxRFTMW1kk0/WJ434Nw
	 aIgW5xQLGp7mE4ZJ0D4hKLxutLXFQ0lltuZAn9VItxXzVBr+DJicvRPvwFqFvaP28k
	 DH7XvGh0bJeYAqxHQto98jYvv+QKVz4uiE1uZ6sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Rob Herring <robh@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/744] dt-bindings: thermal: loongson,ls2k-thermal: Add Loongson-2K0500 compatible
Date: Thu,  6 Jun 2024 15:57:35 +0200
Message-ID: <20240606131738.296296732@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit 25c7d8472f6e90390931e93f59135478af3e5d86 ]

The thermal on the Loongson-2K0500 shares the design with the
Loongson-2K1000. Define corresponding compatible string, having the
loongson,ls2k1000-thermal as a fallback.

Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/26524a63abd2d032e4c45efe6ce3fedb46841768.1713837379.git.zhoubinbin@loongson.cn
Stable-dep-of: c8c435368577 ("dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/thermal/loongson,ls2k-thermal.yaml       | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
index b634f57cd011d..9748a479dcd4d 100644
--- a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
@@ -20,6 +20,7 @@ properties:
           - loongson,ls2k1000-thermal
       - items:
           - enum:
+              - loongson,ls2k0500-thermal
               - loongson,ls2k2000-thermal
           - const: loongson,ls2k1000-thermal
 
-- 
2.43.0



