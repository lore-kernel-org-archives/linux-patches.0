Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6575F1519AA;
	Wed,  5 Feb 2025 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765034; cv=none; b=tDzo6fgXlKBraY3nF8dSw02o+brhns6hG5UYecA1qSH0xfHtVIQDtkuLn4Saq1iHY2xRVfNrwtp4MXbgtMwJAIE7XiosYqfRKKvhXvROgRvS5L2e9Lh9i7ORFe+vE7PyMDb3DPirn6f1++hYB154LTKHTwLaasdU6gy7vkjk8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765034; c=relaxed/simple;
	bh=4RDQNuxMYfXxtyUokhn+lSWy9jo/k9OiiLY6vFvY76M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/47V3N2Nhoentv+FTrn3W/mfMzl1XCKhnF6zjG5IvAXoeQOC6LSCky/7EHe6UkU2XkEg6yCjuLj6QyqqJFTK+hWZ2TVdo7EDvbU62hsSg8ACj6yIyK4qeMfqGvgt+LubKmxfZKqJ9sTRHJHkEB+cr5fq3J9N54B7SzYp5fSbLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz/OpGOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz/OpGOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF57DC4CED1;
	Wed,  5 Feb 2025 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765034;
	bh=4RDQNuxMYfXxtyUokhn+lSWy9jo/k9OiiLY6vFvY76M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz/OpGOm7Tsv6r1IymPHD20YKkdD/lHhKGZ9A3oGnO0XBYgUViJzFOC53GLZNzK/n
	 3ln/V89p39czwDvZ4SGCYmfY2pRngfekESs2Gkm0Rtkpea6h7uXC7d/erNu6fiDjB4
	 5cz2Hf431n4RbZ8h6HpSDJ8txCM5qSW/YLZLty/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/393] arm64: dts: qcom: msm8996-xiaomi-gemini: Fix LP5562 LED1 reg property
Date: Wed,  5 Feb 2025 14:42:25 +0100
Message-ID: <20250205134428.953894749@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 02e784c5023232c48c6ec79b52ac8929d4e4db34 ]

The LP5562 led@1 reg property should likely be set to 1 to match
the unit. Fix it.

Fixes: 4ac46b3682c5 ("arm64: dts: qcom: msm8996: xiaomi-gemini: Add support for Xiaomi Mi 5")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241006022012.366601-1-marex@denx.de
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
index f8e9d90afab00..dbad8f57f2fa3 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
@@ -64,7 +64,7 @@
 		};
 
 		led@1 {
-			reg = <0>;
+			reg = <1>;
 			chan-name = "button-backlight1";
 			led-cur = /bits/ 8 <0x32>;
 			max-cur = /bits/ 8 <0xc8>;
-- 
2.39.5



