Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFC03F23DB;
	Fri,  4 Sep 2026 05:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499492; cv=none; b=Q9qXXs3bbQDdFSBN4eFqzNINepJ0JUgtRwoTzEQwinGmUgiyyBJlMPanJsputv1cG4oTGc5uQyT5hKOrqbMynzCVbDdoMyHyzpERlELhFYZ3elxxAFW43ZkNLBuWQr3rR9mBYeLC2Ntkl7Ne/wwkqQ5HzZQ/w6cMaVoCaRtzXiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499492; c=relaxed/simple;
	bh=jkAjpbdY7HQauZPElI4cyOO/tvHoAYCmbOdcliAbO0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyaJRX9SrhS2D5W0uL29lsQ1ZRGx96AmhJy98p8/jJtLKFV9hXgTW1QYuB/gN7PjH6hSz8APcl39DO/japPicNZ76kKyss49NiqxugRNM4IPrfQ8sr8a9+zElS9Kg6AA/M63U5xQrg9NBBXujsDpOA4ccCeJREugrxLFRAZN4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+Q+qfws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+Q+qfws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E961F00ACA;
	Fri,  4 Sep 2026 05:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499491;
	bh=A90Eu3kY5GixkIrVOQkhGq8E/GPuxnnRjozVwXnc7FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+Q+qfwsmD4APNK782H1E+gpkGLsK+eT8F2x3vw/8j94RHJyyiWWH53v/MDdj+9GD
	 MMC77zrz/UYLhYqNVNnHogSolrWqxfNpGSOTko7koTd4/E/TR0Z/D4FAd9y9d2Sz2b
	 Uzuvq5MXpq6KJtc+RB8Vy1tw3O3HxmZ8lxXXHR0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>
Subject: [PATCH 7.2 435/713] riscv: dts: spacemit: k1-orangepi-rv2: fix maximum CPU core voltage
Date: Fri,  4 Sep 2026 06:56:43 +0200
Message-ID: <20260904045813.581209187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Aurelien Jarno <aurelien@aurel32.net>

commit ae0c38f0a24f95c8759b6b0eaaa5a0d36a7c6af2 upstream.

On the OrangePi RV2 board, the buck1 and buck2 voltage regulators, which
supply the CPU core voltage, are configured with a maximum output
voltage of 3.45V, while the highest operating point requires only
1.050V. This means that a kernel bug, OPP misconfiguration, or
privileged userspace could request a voltage above the safe operating
limit, causing possible permanent CPU damage.

Set the maximum regulator voltage to 1.050V instead.

Fixes: c02c047b925c ("riscv: dts: spacemit: Define the P1 PMIC regulators for OrangePi RV2")
Link: https://sashiko.dev/#/message/20260728211020.1248676-2-aurelien%40aurel32.net
Cc: stable@vger.kernel.org
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729150722.1598630-4-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts b/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
index 7c49bce427f3..b907a1396b21 100644
--- a/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
@@ -164,14 +164,14 @@ pmic@41 {
 		regulators {
 			buck1 {
 				regulator-min-microvolt = <500000>;
-				regulator-max-microvolt = <3450000>;
+				regulator-max-microvolt = <1050000>;
 				regulator-ramp-delay = <5000>;
 				regulator-always-on;
 			};
 
 			buck2 {
 				regulator-min-microvolt = <500000>;
-				regulator-max-microvolt = <3450000>;
+				regulator-max-microvolt = <1050000>;
 				regulator-ramp-delay = <5000>;
 				regulator-always-on;
 			};
-- 
2.55.0



