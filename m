Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E534A3850;
	Wed, 23 Sep 2026 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172614; cv=none; b=H1fNi3RfU85LfQ5C6WE/fQUAJvz6PnkV5YS1rbzg8jLFnqPvh+Of3IcC3AOdD/VsRSmcXZxmD8EWLU6YCK0fc90fzGcZhxSj6lHGdQlugq8qRLlrXRvVY7YSRCab7GuA0CADechnEqoC2qfLFuaw7TUf2Y3wMVYOAJ3HpFVeP48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172614; c=relaxed/simple;
	bh=YzsW/eFuTRvQEByVf3AeaYe236H9qr+/LfEf9Po8VcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihFwDR888YIg7u2azTEhyeM9jlOuPuuUBl6g0l+cs+40a5rajwFGG2tWsuTgDbuj311a0dpHP/x/YKR7a3E7c2LgE6o8mYYwZ1LJfmtIfwHjDZy+6RNKIFCz8Ez9zf6YbnIPtPY4weQlq1qIsf7g38IuQPqGjKMyd3DWNXR9u+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6C6XK/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6C6XK/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93F31F000FF;
	Wed, 23 Sep 2026 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172612;
	bh=wIPnTa5pXys36TGcaH1uTQPLpzoGcqtJgvkK/9Xxlg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6C6XK/d2H7BArPLVH70ighAWuzOBViI6zYFL+eIsTMorsH2SFWeguG6ewmfkUJ0F
	 iRXN3x7sobdz8aiUyRY/8n3NcjjpGMh4Og0tzePdb2+E1xK9WQrqO11NtdsvuA43+K
	 ulW3SSd1i4kALime8jmu5pMkwWMgaQbPP1d2gxaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <tanure@linux.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 011/438] arm64: dts: amlogic: t7: use the real UART pclk
Date: Wed, 23 Sep 2026 16:00:32 +0200
Message-ID: <20260923140645.067063002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Lucas Tanure <tanure@linux.com>

[ Upstream commit 882de800bf583dd15969836088789edbf035a944 ]

uart_a listed the 24MHz crystal for all three of its clocks because the
T7 clock controller driver did not exist when these boards were added.

That leaves the real UART bus clock without a user, so the kernel
turns it off when it disables unused clocks at the end of boot, and
the board hangs.

Update the board DTS files to point uart_a's pclk to CLKID_SYS_UART_A
instead of the dummy crystal clock.

Fixes: 4fef056588f5 ("arm64: dts: amlogic-t7-a311d2-khadas-vim4: add initial device-tree")
Fixes: 6f048cc7a635 ("arm64: dts: add board AN400")
Signed-off-by: Lucas Tanure <tanure@linux.com>
Assisted-by: Claude:claude-fable-5
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260823115335.102219-2-tanure@linux.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-an400.dts       | 2 +-
 arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-an400.dts b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-an400.dts
index cab2ee9ea0d31..ca7536f772ff1 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-an400.dts
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-an400.dts
@@ -33,7 +33,7 @@ xtal: xtal-clk {
 };
 
 &uart_a {
-	clocks = <&xtal>, <&xtal>, <&xtal>;
+	clocks = <&xtal>, <&clkc_periphs CLKID_SYS_UART_A>, <&xtal>;
 	clock-names = "xtal", "pclk", "baud";
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
index c41525a34b721..75d81ad6830df 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
@@ -266,6 +266,6 @@ &sd_emmc_c {
 
 &uart_a {
 	status = "okay";
-	clocks = <&xtal>, <&xtal>, <&xtal>;
+	clocks = <&xtal>, <&clkc_periphs CLKID_SYS_UART_A>, <&xtal>;
 	clock-names = "xtal", "pclk", "baud";
 };
-- 
2.53.0



