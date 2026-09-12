Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8115192D8A;
	Sat, 12 Sep 2026 07:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197994; cv=none; b=Suv1o+FHij3Qqwdihp1ENMK+J6M+3Op1aDkjpLMKcB9JOR4A3r7uPG3EM9ZenJZZR4dDDGZBCKu+aDfGJXGLfx+lErNhRLIldxqTOed1MrdgHJnNgcOhLomSfkLUijunoUz3zUpnI8I0sQ5YIoiuXamFYo822kfJRUq9JaBUO48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197994; c=relaxed/simple;
	bh=ukui0skWxiDgTR3d9pqzWNqd9RtjlTDd6UieXXdcwVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1eXDg0oVplWnriwE+WChI0mCiffd6G8fqZbZiZc4/pvUPcBbib8GynK9FeuDPDW+umIbU0u3jUuzkpNha+bg4QpuoXHahdT58749z0/l/RcQUSS/XvZsod6VxedsIuQURm+StShrFOXywGoIMvv6QncdBTCYGhX8ZCKb58kcOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2D19uB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2D19uB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD06B1F000FF;
	Sat, 12 Sep 2026 07:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197992;
	bh=QfDUtaRUiXmFpn8L+Sdw48Xj1PIecrQokWkz/QNGSq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2D19uB36/JWcAzY7igRZbCnKF/XOjk9KwmJ10j/NFJYhw99NWVb02mPwTJs2INB6
	 ZoN/NGDvON+l/VayFeLt6iJb7E1zAwtiw+F4vM1qHOklCGXM3wPihmn5bSIGgb5Uk1
	 7V3fKAc9m8Hzez4MiCWEj1dkIFg7CzKgXNrnInN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0290/1815] arm64: dts: mediatek: tungsten-smarc: Remove unnecessary cells
Date: Sat, 12 Sep 2026 08:34:00 +0200
Message-ID: <20260912065655.765954931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit dee885034faf7c9b265987407ab303b464ed0058 ]

Remove unnecessary address and size cells from both the disp_dsi0
and the xhci2's ethernet usb device subnode to fix a dtbs_check
warning for avoid_unnecessary_addr_size.

Fixes: 9fda4a8a479f ("arm64: dts: mediatek: add device tree for Tungsten 510 board")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8390-tungsten-smarc.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8390-tungsten-smarc.dtsi b/arch/arm64/boot/dts/mediatek/mt8390-tungsten-smarc.dtsi
index 9f5a0ec563e8c..8256279c56299 100644
--- a/arch/arm64/boot/dts/mediatek/mt8390-tungsten-smarc.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8390-tungsten-smarc.dtsi
@@ -265,8 +265,6 @@ &disp_pwm0 {
 };
 
 &disp_dsi0 {
-	#address-cells = <1>;
-	#size-cells = <0>;
 	status = "okay";
 
 	ports {
@@ -1049,8 +1047,6 @@ &xhci2 {
 	ethernet@1 {
 		compatible = "usb424,7850";
 		reg = <1>;
-		#address-cells = <1>;
-		#size-cells = <0>;
 
 		mdio {
 			#address-cells = <1>;
-- 
2.53.0



