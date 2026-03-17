Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC82C3EB7F1;
	Tue, 17 Mar 2026 16:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765544; cv=none; b=djJbGSqvyuZedeToYdtSprKE/hEGNbLzK52fPDnhIEiFO0jfaTG8WPuZzXos+KsaM9o5KgTodZZj6bM/BjbNzgJNLwL5XOfwBnjggT3lPvEYBbsxZA6K5sQW+ICegOCgI6Yvg+1rKmv1NkHfXX9msVwBUpnyBf6uUSGtMxj4GGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765544; c=relaxed/simple;
	bh=KrrXn/9EkxXCzfkyPsUtAQn0/5L3nMfDkiyeUJwEMng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XraDUfeZwZDwdeuxbwIfAsbwARC/cBqCd9ILmI+BDAfhkSN4f+5i2QUuMj2zUK6S5EVRsd6a3W6/5kAA95ZBpogxhWlmnpH8yQehxrz/2SWA0+q2XlEKZVPQsUiqghjkaoNZwRQYBQCIrxPFtYRsZKt2WC6fqrOX2R6DLY3eGU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pf4FmZHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pf4FmZHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17057C4CEF7;
	Tue, 17 Mar 2026 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765544;
	bh=KrrXn/9EkxXCzfkyPsUtAQn0/5L3nMfDkiyeUJwEMng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pf4FmZHujs/sRpjWAFrBh9UkUINj1XOqlRc0swflmd6lUBcqemobNBW7nG94RGUKd
	 c1N8KrqXF0toqgQjqPRE0COSJMF56qV08KhvYSKJM+yqyzFRkOE3hJ1ircg55Bhgt7
	 ved6J2NT4qXlgIiGbQAArkwICkajb+71WXpsJGjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 035/378] dt-bindings: display/msm: qcom,sm8750-mdss: Fix model typo
Date: Tue, 17 Mar 2026 17:29:52 +0100
Message-ID: <20260317163008.274542348@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 4355b13d46f696d687f42b982efed7570e03e532 ]

Fix obvious model typo (SM8650->SM8750) in the description.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Fixes: 6b93840116df ("dt-bindings: display/msm: qcom,sm8750-mdss: Add SM8750")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/707192/
Link: https://lore.kernel.org/r/20260225173419.125565-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/display/msm/qcom,sm8750-mdss.yaml       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/msm/qcom,sm8750-mdss.yaml b/Documentation/devicetree/bindings/display/msm/qcom,sm8750-mdss.yaml
index d55fda9a523e2..a38c2261ef1ac 100644
--- a/Documentation/devicetree/bindings/display/msm/qcom,sm8750-mdss.yaml
+++ b/Documentation/devicetree/bindings/display/msm/qcom,sm8750-mdss.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Krzysztof Kozlowski <krzk@kernel.org>
 
 description:
-  SM8650 MSM Mobile Display Subsystem(MDSS), which encapsulates sub-blocks like
+  SM8750 MSM Mobile Display Subsystem(MDSS), which encapsulates sub-blocks like
   DPU display controller, DSI and DP interfaces etc.
 
 $ref: /schemas/display/msm/mdss-common.yaml#
-- 
2.51.0



