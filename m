Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7313FE2D;
	Mon,  1 Apr 2024 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986602; cv=none; b=RSH2lSRbHdhUjw5pzDl/DWg/qW63jDdNqCT5N/vKdGklNnRRW6ybUnlno7bJGxMO38EvwvpiNDd6DCTpZE2vuBKUZeYJbPKqSSkuq9Ts6k+IGKvFhBPPUdvaq15KJ+8QA4i2HsWasKa0JZudKUtj907lsr896LJeO7OtOoG1XeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986602; c=relaxed/simple;
	bh=kcJgGCVH+NTxQhtqh54cHzWiw6g+pgbnVfhdHAjuyxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7yNq5ND8qGBgeEt8EAGytg/lMwkag4gd7iv2xZmn7qTi/ocPhfQfEZO65eogmMYVg6/gRxXJczJuPtTdCdETQzvisUHWRMdh83V7sa1hOZyi9t2cv2+cfS3A9NUwN2lXCW3iWLcI7Z7/XSEpYOYkTEHkiCsnpBXV1Rq3JR0qrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqURQxbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqURQxbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF38C433F1;
	Mon,  1 Apr 2024 15:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986602;
	bh=kcJgGCVH+NTxQhtqh54cHzWiw6g+pgbnVfhdHAjuyxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqURQxbjh35kRQKSYh6B/H70bElCJET6HN8NTFSvHkv6jRY9VS4drgqLYTDB8lx85
	 cMiGWsDQ9ANYciDqqsZX8vomxzo2CB6eUWSclISFSEbtuvuj/3ISUeBh/qWZA+9M5Y
	 36na8ao4Oex60R0f9MCN3Uqsei+V+n2CYpAfl22M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 026/399] arm64: dts: qcom: sm8550-qrd: correct WCD9385 TX port mapping
Date: Mon,  1 Apr 2024 17:39:52 +0200
Message-ID: <20240401152549.944419179@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 8ca7fbd92c1b28edb5d5df7aeb8bb4886ddb9829 ]

WCD9385 audio codec TX port mapping was copied form HDK8450, but in fact
it is offset by one.  Correct it to fix recording via analogue
microphones.

Cc: stable@vger.kernel.org
Fixes: 83fae950c992 ("arm64: dts: qcom: sm8550-qrd: add WCD9385 audio-codec")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240124164505.293202-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550-qrd.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
index d401d63e5c4d2..54dfee40d6059 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
@@ -978,7 +978,7 @@ &swr2 {
 	wcd_tx: codec@0,3 {
 		compatible = "sdw20217010d00";
 		reg = <0 3>;
-		qcom,tx-port-mapping = <1 1 2 3>;
+		qcom,tx-port-mapping = <2 2 3 4>;
 	};
 };
 
-- 
2.43.0



