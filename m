Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400838F5C;
	Mon,  1 Apr 2024 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987914; cv=none; b=Axgs2lG0khilq4IpltQlDD26k+26jwZVJ3u1E7V34WEBGvTfa+2D5o85/J5AFSvgxAJ7lva4ljtLxCSyCD5IESeGA9IlB407drDeR2fRIh6LjmjewfyjLIeO0zDG6iQzfozbgy9kol97OVcBJBKA4sLRsmB03DtHISykIOfQ+Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987914; c=relaxed/simple;
	bh=m09h1PYrvEyq19sckOwoEjGx9c/luudM6wS4Zs9LafY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOI1Lzvz82WXskEQfadEVubLXHyqG/4RQo1awZz5jvLUXBwIeNPz2njBcCoIPCc/sfb7adI9MbiXIxPLkGzK3q1ZNklL5YyW86a1qxXEp5oRU6hUGCrbO44uXSHlUFz7gh7lAskPxSwwEmCL3n8EUFyXGUm9ZsNliRW8fazzKLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICojvsW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICojvsW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A88C433F1;
	Mon,  1 Apr 2024 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987913;
	bh=m09h1PYrvEyq19sckOwoEjGx9c/luudM6wS4Zs9LafY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICojvsW7Xl7w4eKTK+v6YqqX1Es2Y2hcSkrX6rWdwk0J8Kee41dw1hOThoRwOq3Dn
	 TYsJiGPYCv4mukfR1Cgy3Wb0Sq9ZyLof1S44nf7blKd0hfufyR8YPKUsVfXsWD6gOS
	 vc/8Wl1K2H8seaWkByeqXLpq0CvryXItBW+SowJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 028/432] arm64: dts: qcom: sm8550-qrd: correct WCD9385 TX port mapping
Date: Mon,  1 Apr 2024 17:40:15 +0200
Message-ID: <20240401152553.972349651@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index eef811def39bc..ad3d7ac29c6dc 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
@@ -842,7 +842,7 @@ &swr2 {
 	wcd_tx: codec@0,3 {
 		compatible = "sdw20217010d00";
 		reg = <0 3>;
-		qcom,tx-port-mapping = <1 1 2 3>;
+		qcom,tx-port-mapping = <2 2 3 4>;
 	};
 };
 
-- 
2.43.0



