Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F149C3F8810;
	Tue, 17 Mar 2026 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767380; cv=none; b=A85okwE6iH14d9GANLmtqF/89kUl61v2EOoLKOmnnB5OpOKjOB1jrXGAyV2ssBhRgfRyU0F2w7WD30uHhddBGbnnPHzqWhvTzpCiAzmMlhcDzfZmmrNXSm4X+lnykD3S0qePKtWU2UWs6rJjaOOzo/0fEETL+BmX2ApiR0t64Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767380; c=relaxed/simple;
	bh=EG/9xsQ2MJAGqImQUu6euAeAc4XocFAreRH9HQaQwKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTmtOsXDdL6pf6PKR0m4463cvl3+EbfcBYHjvUkYe+RX22I5S/LdOswf3hxInmqq3y/bgO7ZowKd8qrbMUVSsquT7nhespXS15H3P8Z8BkNb+lng033sXOTH5SkmQY1oUnrqoQV+9NRjkvAOT9TNl6zCNAeSpk9XSqT1DU88aLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwC2x71u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwC2x71u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B69C4CEF7;
	Tue, 17 Mar 2026 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767379;
	bh=EG/9xsQ2MJAGqImQUu6euAeAc4XocFAreRH9HQaQwKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwC2x71uA3sgcgD2wvVZZDCWLOfQMcwtvFUn0JjHwwWmwiXQOvBWgHDoBzBwoWbYM
	 6OChF7p+mzsxCByZWW6za999VoB8Z8QmV9V87TKrQjJh/YJva6uII4omT9nVNUhXxz
	 5KvFwsruQzLsxqioGFw4ddRHQpPqQWfHQC/TQD0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/333] dt-bindings: display/msm: qcom,sm8750-mdss: Fix model typo
Date: Tue, 17 Mar 2026 17:31:01 +0100
Message-ID: <20260317163000.553503841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4151f475f3bc3..14942dfbdb09b 100644
--- a/Documentation/devicetree/bindings/display/msm/qcom,sm8750-mdss.yaml
+++ b/Documentation/devicetree/bindings/display/msm/qcom,sm8750-mdss.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
 
 description:
-  SM8650 MSM Mobile Display Subsystem(MDSS), which encapsulates sub-blocks like
+  SM8750 MSM Mobile Display Subsystem(MDSS), which encapsulates sub-blocks like
   DPU display controller, DSI and DP interfaces etc.
 
 $ref: /schemas/display/msm/mdss-common.yaml#
-- 
2.51.0



