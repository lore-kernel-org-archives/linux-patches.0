Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8A741A507;
	Fri,  4 Sep 2026 05:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499483; cv=none; b=Rxd+SvkrY++Fc6OtkKeloeb+TJAn3gG1QyWmrmgOKbwe/LVvOBVm+uD/xSOwRoeLSH9YkZG9NvbF5cdgQk4dA44iw45y0Qk6gV2TcTWsnxWWxGxVs7S0ODKkM4891Bt4tg01BkPrzJWdwyJlNUwyFhYPSggbKVGNb1eLGgETt50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499483; c=relaxed/simple;
	bh=GVoEWA12QhFpWM/bmEfnJvwTvCn4f8Cm7T9s13qlw/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DldLbCPUIEysNLPT6Vhh05Z9+njlL4zkFKC7mU0mwzg7BKEwR6hz/vKYRHAHZxxknfk5Xrbx24qZXrRxcfWp9BddV1Cdi3v4ewdnovJkCSvo0j2WzfYvM41/TC/xhJrYcqAIb3s9AOscu6j4Gd7dxOVXNzj7/wV2vPV9TFbUelE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfO/15xi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfO/15xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D111F00A3D;
	Fri,  4 Sep 2026 05:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499482;
	bh=4nLlvFkDiyxhURXZbMWl6WcQa5mVuFkQRbkT+CvRi/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfO/15xiDEY8j4KSQxvj7rGVlgjw7PKy/hSCxIhSy/MOeQfjMwwVH0AYSdDiL9oVY
	 Qy8ZI1ADp8vP5qJNV/UQv5UTkxd3OZeshsdK3bgAjoE934+LLCi+cu/PbnL319m4sN
	 g/CFX2ELVUfKZAKDG7zVVJwL+4gNQV8QI0VhsVVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>
Subject: [PATCH 7.2 432/713] riscv: dts: spacemit: k1-milkv-jupiter: fix maximum CPU core voltage
Date: Fri,  4 Sep 2026 06:56:40 +0200
Message-ID: <20260904045813.511548297@linuxfoundation.org>
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

commit 56a77ddae794ca0516fc146f6e59bb8cdf4fd9d2 upstream.

On the Milk-V Jupiter board, the buck1 and buck2 voltage regulators,
which supply the CPU core voltage, are configured with a maximum output
voltage of 3.45V, while the highest operating point requires only
1.050V. This means that a kernel bug, OPP misconfiguration, or
privileged userspace could request a voltage above the safe operating
limit, causing possible permanent CPU damage.

Set the maximum regulator voltage to 1.050V instead.

Fixes: 7d307daa12b1 ("riscv: dts: spacemit: Define the P1 PMIC regulators for Milk-V Jupiter")
Link: https://sashiko.dev/#/message/20260728211020.1248676-2-aurelien%40aurel32.net
Cc: stable@vger.kernel.org
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729150722.1598630-3-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
index b61f5995ec77..c76b91ecb914 100644
--- a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
@@ -211,14 +211,14 @@ pmic@41 {
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



