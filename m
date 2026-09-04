Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618EF417BCA;
	Fri,  4 Sep 2026 05:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499486; cv=none; b=I1tLl0Fs09i5BevlCGfOFKp0VsIOwtvZTNLgpLystofEK442u0nmPxaDRucUD7WJ6jpz9LgNdDmnpMN/sPpMCZt2EKQx+04sssbKradjaCT+oPwr1Jzed2uDxtwqlg4BVnqwbxBHuer1ZHvMdxSMP3oGcxcgpmiLXHikyiRtaWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499486; c=relaxed/simple;
	bh=r1Il7I/q+8L4Gyh0KkwgMbkFsINVE60tTO69QiGGJE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gL4WAHOGNJfG0f5e6rYW+EYDKVfnOIWuNPTQtiyFLwxMkBtB9T5IhVqX57OFFEY/dldFFQ+6b42HQSl/SsoxYc8GoWZO91HIhCgwAKttujUrW3nRxDpDKPK3iIgb+ZkkNxpDnFUeErPoJ6RviUUN1qiM1UtJImG4ziIUZR7J9lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOcOr3CO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOcOr3CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9981F00A3D;
	Fri,  4 Sep 2026 05:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499485;
	bh=krbZRZG6BFdEJ2FQ9D2KLvIjJCWz9zyayGcCdwyN+ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOcOr3COYLyP+RJ7WDfV/U3MeN9QdTUeq7ygk6It0OkviQSNDQcd3CWLK54jNXjo3
	 nvFAQROvfw4mGGf4IR5qeMYcAkb1nMGNFuHYFcjPECT1Q7Y+oJuUhDI79QNd3O2Iu+
	 z/JfxWxq9fjn0//cvzJzGOWRlNKLGAC/kAO6Zx28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>
Subject: [PATCH 7.2 433/713] riscv: dts: spacemit: k1-musepi-pro: fix maximum CPU core voltage
Date: Fri,  4 Sep 2026 06:56:41 +0200
Message-ID: <20260904045813.536576573@linuxfoundation.org>
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

commit f045253a03589b2616332560b4120e584342a987 upstream.

On the MusePi Pro board, the buck1 and buck2 voltage regulators, which
supply the CPU core voltage, are configured with a maximum output
voltage of 3.45V, while the highest operating point requires only
1.050V. This means that a kernel bug, OPP misconfiguration, or
privileged userspace could request a voltage above the safe operating
limit, causing possible permanent CPU damage.

Set the maximum regulator voltage to 1.050V instead.

Fixes: e2dac7c7a3a8 ("riscv: dts: spacemit: k1-musepi-pro: add PMIC and power infrastructure")
Link: https://sashiko.dev/#/message/20260728211020.1248676-2-aurelien%40aurel32.net
Cc: stable@vger.kernel.org
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729150722.1598630-5-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts b/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
index 3078ffb5cb87..246f8f2ab62b 100644
--- a/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
@@ -180,14 +180,14 @@ pmic@41 {
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



