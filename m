Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5717C4E3782;
	Tue, 21 Jul 2026 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656134; cv=none; b=Bq5K/zc1QIQVdXH5QO/6UoaK7yP7dwhem8cus/0DpGmqU+bzYHaQyQPmYnn9TGdP79wCQO522lKA136wALFTe4sjtIY+Oetrkh+Fu9oaGJPLnjZxzhV6crsCXK7fXmoquxuJq74ug62zX3G61SAagC1mK48IpOwgsFMGbyMjLDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656134; c=relaxed/simple;
	bh=XWttY/OEs8kprtxloNN7HwqX99wS3uIamVgfxDwNU4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXOM3R26zZd1jtpEYQrrpjOZ1bxaFaqMQZDaF5HWYwzcVd7LJOypUeiJqBO/YLRyDq8m8q22v5ipyUJTSZeCw1IuM6g0+NkKJl//EgpBmEGOFeeNy8Y9dbkHmf8o58xOcyuX7J7Im/9Ya5h9xkZhg/8JWT1sDUJNIJTUjdBH4i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0Jxjjxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0Jxjjxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841031F00A3E;
	Tue, 21 Jul 2026 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656133;
	bh=3w+rzxcc6LzxSGeextxwACzforD4dcllt7wzYdwqppI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0JxjjxksC+tJK8sk82jkmWbgPQYS9oMZv4aaYWCb66eThXiprdZrlddWi+e8Z+MH
	 w2inR5WQh2S1jIV6ptfyStbHovSx2xmvfWYd3xCv0ssbwaRenlHX1YlhRjVeHqdO+h
	 V0I3JE9nFKwL2jd3W5mcXFsomNtlwpveDcTv6QiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0271/1611] arm64: dts: st: Fix SAI addresses on stm32mp251
Date: Tue, 21 Jul 2026 17:06:27 +0200
Message-ID: <20260721152521.146447892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit fba4a31a7f3b6b29b01c83180f83e7ed4c398738 ]

The second field of SAI register addresses should be within 0x3f0 bytes
from the start of the SAI register addresses, the second field describes
the ID registers which are at that addrses. Currently, the second field
does not match RM, fix it.

Fixes: bf26d75a95f1 ("arm64: dts: st: add sai support on stm32mp251")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20260411130300.19603-1-marex@nabladev.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index a8e6e0f77b8394..e4e6f9f818d81c 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -1176,7 +1176,7 @@ spi5: spi@40280000 {
 
 			sai1: sai@40290000 {
 				compatible = "st,stm32mp25-sai";
-				reg = <0x40290000 0x4>, <0x4029a3f0 0x10>;
+				reg = <0x40290000 0x4>, <0x402903f0 0x10>;
 				ranges = <0 0x40290000 0x400>;
 				#address-cells = <1>;
 				#size-cells = <1>;
@@ -1210,7 +1210,7 @@ sai1b: audio-controller@40290024 {
 
 			sai2: sai@402a0000 {
 				compatible = "st,stm32mp25-sai";
-				reg = <0x402a0000 0x4>, <0x402aa3f0 0x10>;
+				reg = <0x402a0000 0x4>, <0x402a03f0 0x10>;
 				ranges = <0 0x402a0000 0x400>;
 				#address-cells = <1>;
 				#size-cells = <1>;
@@ -1244,7 +1244,7 @@ sai2b: audio-controller@402a0024 {
 
 			sai3: sai@402b0000 {
 				compatible = "st,stm32mp25-sai";
-				reg = <0x402b0000 0x4>, <0x402ba3f0 0x10>;
+				reg = <0x402b0000 0x4>, <0x402b03f0 0x10>;
 				ranges = <0 0x402b0000 0x400>;
 				#address-cells = <1>;
 				#size-cells = <1>;
@@ -1336,7 +1336,7 @@ usart1: serial@40330000 {
 
 			sai4: sai@40340000 {
 				compatible = "st,stm32mp25-sai";
-				reg = <0x40340000 0x4>, <0x4034a3f0 0x10>;
+				reg = <0x40340000 0x4>, <0x403403f0 0x10>;
 				ranges = <0 0x40340000 0x400>;
 				#address-cells = <1>;
 				#size-cells = <1>;
-- 
2.53.0



