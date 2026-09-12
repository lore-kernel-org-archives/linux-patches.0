Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3CE2D8382;
	Sat, 12 Sep 2026 07:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199791; cv=none; b=h2506fW6WPjRN6r7bjPjFNdbYaV5KHEOCdw1DerZVwTUI/nQbhVS0Sv0NglYV4ErX5kFsfv0KIk1fRM+MTUNpB8lVXBv1k1NSAm6QUGoiThRxM3MPALPuQ22n0gCEJlg+ykQ0VrF2CBOkfgm8+DONPdPtOmX47C48+vvAqtMF9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199791; c=relaxed/simple;
	bh=FF8i5CxwlMuSwpfye3zmysKcb558CqatfnGlKsPvZJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMfspOb7tor/56mzlRwjItQIf2TYedXKzUusIlM7avEjQPLZiDoK45LLo8PPrcuMyKdh0GEacpMfV1NqPEEoCm2jlD6yXAXjR1Gx8hSElHtywnWrOIj+HsjEgRIVB5T3bnljXfZq1QBmMfrhD9U1yRwvhvuRbK/nFghzXlkUKEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dnft8v/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dnft8v/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23501F000FF;
	Sat, 12 Sep 2026 07:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199790;
	bh=f7vUzuNghARERKUKq9ig4U1rQKJa1iASARFrC0loRp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dnft8v/8bg+l5IExnMV6Mkg4iZDlydmVq5livuGZjOfR/OVuqfnp8TxczQpDLed3Y
	 LwqlRhvyFI+5YameBED6P4ykaEEKZKpGx5HCG5ymA1KQzxYBG6vRMc/JosSS7PYmzD
	 g5UsS8u5L34j6o/mRoYz3a0aC/QWb5mvzSNeeNZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0657/1815] riscv: dts: spacemit: Add enough deassert time for the PHY on com260 board
Date: Sat, 12 Sep 2026 08:40:07 +0200
Message-ID: <20260912065704.304275615@linuxfoundation.org>
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

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 12b0d602e8642297ec369eeb99366d37c8a3a120 ]

RTL8211F require at least 50ms deassert to guarantee the register
access, 10ms is only enough for the PHY reset.

Fixes: cfe5c91cb73c ("riscv: dts: spacemit: k3: Initial support for CoM260-IFX board")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Link: https://patch.msgid.link/20260710063314.1030249-2-inochiama@gmail.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
index a38d7b738258d..b704b537385c7 100644
--- a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
@@ -178,7 +178,7 @@ phy1: phy@1 {
 			reg = <1>;
 			reset-gpios = <&gpio 1 5 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <10000>;
-			reset-deassert-us = <10000>;
+			reset-deassert-us = <50000>;
 		};
 	};
 };
-- 
2.53.0



