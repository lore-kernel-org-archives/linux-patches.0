Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F2114AD0B;
	Tue, 23 Jan 2024 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969242; cv=none; b=ljl25MHx32t+g/0NqYsMEnLa/Q6Lf3gZVBxLuIImIaeN7BY8XhbC1oJBVOpyRueZwiVEWygwhoOnVTDMWZG1GU5gdJm6s9GTjcOxdJVJXgTQosp9gXX7KjtGNl7SA7M+Cc2WQp6rh107QUqe+T1NtJehXgFzBBcL3QoQ7ovXHvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969242; c=relaxed/simple;
	bh=q6RFGMb7BrJS+g3qCQmrRLt+ogDvflSA+HsnrhXIl74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gf6puf/RUuXJOgeuWe+sIrS9wUDCXYD69o+QL1Hs7E499JJRqIfsOBQ8nkNvRnRY59+onOLipKogyPg7UvMeW8avn144+FRPYC8kLGpvT2iw5AxIyr08XKQ0Plr/IKH5/Doszx691zZ8KdxElhgqqnkbn50Z6+T45VMAN48Wgdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwIX+x0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwIX+x0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F305C433C7;
	Tue, 23 Jan 2024 00:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969242;
	bh=q6RFGMb7BrJS+g3qCQmrRLt+ogDvflSA+HsnrhXIl74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwIX+x0OsXN/X7+27xOU2psyahyJSer5OQdX64IuzmR8RRVhc5OjN+yKpHh6OFbnz
	 Xj9I+8MekBrmjtPObvD8M9HD86oFlZzLZN3vFJIRO8AKCy/PHNg7jgQY16UEBgGjPy
	 3B8RDIxpRAy9zc9rWHo3DO68igCkhNsfRKjTV/8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 121/641] arm64: dts: qcom: sm8450: correct TX Soundwire clock
Date: Mon, 22 Jan 2024 15:50:25 -0800
Message-ID: <20240122235821.837123555@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

[ Upstream commit 20e886590a310665244a354e3b693b881544edec ]

The TX Soundwire controller should take clock from TX macro codec, not
VA macro codec clock, otherwise the clock stays disabled.  This looks
like a copy-paste issue, because the SC8280xp code uses here correctly
clock from TX macro.  The VA macro clock is already consumed by TX macro
codec, thus it won't be disabled by this change.

Fixes: 14341e76dbc7 ("arm64: dts: qcom: sm8450: add Soundwire and LPASS")
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231129140537.161720-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 1783fa78bdbc..dc904ccb3d6c 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2309,7 +2309,7 @@ swr2: soundwire-controller@33b0000 {
 				     <GIC_SPI 520 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "core", "wakeup";
 
-			clocks = <&vamacro>;
+			clocks = <&txmacro>;
 			clock-names = "iface";
 			label = "TX";
 
-- 
2.43.0



