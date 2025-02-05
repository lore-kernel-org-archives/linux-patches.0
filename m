Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFA3146A7A;
	Wed,  5 Feb 2025 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767289; cv=none; b=MHjQPInnBjKx6B58zJ2MVlC+Dz26f1AMfoPfr5p9RrNIIYcU9tb6Jzc3RmZ3PsT6LSZRHv7w0jACtU8UXeX+8YaSL0y/X/4ycaiUzMZ65dmaD6B4PacKkcMPzTkux8WY17dT+LSGxnkuD1PAfPw5b3/ipwKPNgqaaLJIwjZReL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767289; c=relaxed/simple;
	bh=4MpwGWw4o7mmbptPaW7+DWpwYWdaCSNhHxyKaAMf5cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR8ftxEBQeh4VZGuB8zNWe3g7e+rtp2cgHy99p1mEpg9VlPAqqEBvRlJ1Kryh500UoC8mgPWiAnOdNDgHB+6rigBJ00GFOyPv67i6wMPTTXQXfk/JkYl81VIUP9g5r8bGjA07ugN6CXMzb2izrgonlB72UMVI2L3t5XIVr+Cj8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mpj2kFa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mpj2kFa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD23C4CED1;
	Wed,  5 Feb 2025 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767288;
	bh=4MpwGWw4o7mmbptPaW7+DWpwYWdaCSNhHxyKaAMf5cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mpj2kFa8QmxjdbRVIBOde1+ceMducRlQ85rBjeFhkLSQrmPqmZUQqasu/tevGXfRb
	 o6R7II8ceUHKkHZyhBdcgwdiKdjW9ET8N89F8Fh7mMuwSQQLOo8Wu9DXWWs3CHmtsT
	 SpP+aFFud1WH/0Eyz1/TS9pNn9WQmCgEq2JeSbDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 383/623] arm64: dts: qcom: sdx75: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:05 +0100
Message-ID: <20250205134510.876456470@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b8021da9ddc65fa041e12ea1e0ff2dfce5c926eb ]

The SDX75 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9181bb939984 ("arm64: dts: qcom: Add SDX75 platform and IDP board support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-9-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdx75.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdx75.dtsi b/arch/arm64/boot/dts/qcom/sdx75.dtsi
index 5f7e59ecf1ca6..68d7dbe037b6a 100644
--- a/arch/arm64/boot/dts/qcom/sdx75.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdx75.dtsi
@@ -34,7 +34,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



