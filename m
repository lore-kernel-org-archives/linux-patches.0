Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E69330FF08;
	Sat, 12 Sep 2026 09:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206499; cv=none; b=PCjKw4psp2atpiDbowMgjhJSlx0//Fi44XkTyCw33pPL2lXX/qDX7+gdNmJks3+V8dbI7XInT5GwjQh8xawdXfgbL/DGAV966ewyRHYo1JqjZ2QJJIfu+L9XjFYpNDb6Bh4kpSsbTtNUMTH3IesgAyA+6rlwv+K/HV2+DIYWzWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206499; c=relaxed/simple;
	bh=ZWufxzI1yXspwCDNrlzBRrEd4jtmNhlstQdndRv38ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=injW/4ym5n1cAH3rdG8S8nVGXV7vZm/rhP7VRiv4QV0eW+ZmYTDa29NLqwRq89gydQ8IGsVYQspqBh2BDI4ROnpz3WloM0Ov80daO0TGymBrtmLLCmycyo/XprrV6VMsFetG2IEdzLopJPyZ/GBS9PPl+JmLOUJw6YUy5N+DgWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyEPTWUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyEPTWUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5D71F000FF;
	Sat, 12 Sep 2026 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206498;
	bh=zh+F5ClYQ5Je4F9sfItm6e2IpCsQ3ko2tvhTQEXfUOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyEPTWUO4kwETVd2AmRIo9UxhAOSGW5wCyuobhlfCuaUVm5CkbpYsPxcv6FM1OhGD
	 eWPLFxn5Tpa24JZmOFhYBilo/wUV9KFSoXNZu5MVQx4wqssjlI3g1WGQwo2AmI03WU
	 GaFbRq09XDg9vFsJ/+O/m4cmHZNmr8AtsPg3/GY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0219/1518] arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name
Date: Sat, 12 Sep 2026 08:39:48 +0200
Message-ID: <20260912065628.443844535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit f6e65005fe55c3d09287851523de06367cbf0bc2 ]

'reg' is 0xa0000000 so the node name is missing a zero. Add it, so that
the reg and address in the node name matches.

No functional impact.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260505-sm6350-misc-v1-3-0b9efc22690c@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 8cbe068645ea9..b353de2bc37ad 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -48,7 +48,7 @@ chosen {
 
 		stdout-path = "serial0:115200n8";
 
-		framebuffer0: framebuffer@a000000 {
+		framebuffer0: framebuffer@a0000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0xa0000000 0 (2340 * 1080 * 4)>;
 			width = <1080>;
-- 
2.53.0



