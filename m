Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB478332610;
	Sat, 12 Sep 2026 07:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199631; cv=none; b=WmFMPtH+yjaAp9ZQUkzPh8sM9UHEv7ep7sPRy/ns0tCg+dc1DTdPPVV4PcziFOKnT1kC2HwDQPeCdTdwV6e4RFT6gdjP+fPFW75zKbq8C5Faq1+yS7lWdvoI5UR/FkB1r6BMtKfYJfatCMoxRJ7E9uxGUsmLu4gqbhqDOnRU0c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199631; c=relaxed/simple;
	bh=h9cCyKzbKJkf3F+W9mjoDaKTKRrlZTtlO6IvEdqLI6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGbZZ1iEH3q3XEECWjP8d2EqaJI/H3NX0WnbrykOM812nRk/lWOtRm7kCRqhpHtaEEZZrGXfRh4WeNOpSwjNj8XmSMLzW+O3p3PeoMAIav+8WsWU/Kf0HoFsFWsFUrJPj5J4mBZNloLMc8qc6NYcuy3qpa3Wl1H5E4C7DeoyMVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1+9ZGna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1+9ZGna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6411F000FF;
	Sat, 12 Sep 2026 07:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199629;
	bh=Qk1uzJ0pPlnU0qPIMCKXGzYpJ0PiLpt6OZbwEZHRp7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1+9ZGnaGcTe5GaR2CNhjoyLMQQynffuZP7Qxd8HHMkc2exEtqUQWbg5RGsoyelqX
	 VwBo2FhHmuDCQUjtjH2+j8tKwYykTQSx0n+55S6RtWGq7t8Hd8PIIAvF6mB6FHSrFO
	 y+Q7kcsg9H8DGu1S2qeyXtXqvVrVAaHrVJf7fMoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Guodong Xu <docular.xu@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0623/1815] riscv: dts: spacemit: set console baud rate on K3 Pico-ITX board
Date: Sat, 12 Sep 2026 08:39:33 +0200
Message-ID: <20260912065703.505064433@linuxfoundation.org>
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

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit 788ed93b3b85baa3b5817655ce621ff1f6c300e9 ]

Because the default console's baud rate is not set, defconfig kernels do
not have any serial output on this platform. Set the baud rate to
115200, matching what is used by U-Boot etc on this platform.

Fixes: 7a6131804986 ("riscv: dts: spacemit: add K3 Pico-ITX board support")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Guodong Xu <docular.xu@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260623204431.498700-2-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index b89c1521e6649..509cebc0c9568 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -18,7 +18,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = "serial0";
+		stdout-path = "serial0:115200n8";
 	};
 
 	memory@100000000 {
-- 
2.53.0



