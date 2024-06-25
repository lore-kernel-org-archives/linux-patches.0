Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1696E149C74;
	Tue, 25 Jun 2024 09:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308501; cv=none; b=FuaOgfYOX+zWZps1rNo2EZn9oQeh3n7tVa4dxAUhj+g/MguAi9XhZgxVtUPLI6llRR2xJ1RZtyXd/LcIsYfP4mOnoKwY6br+g92rgHK0UlyxtBAAqiYDzYxONgS8M6cVJs/UdttJ3rWuUyMoVATysI9Lf0dfDZrYdLZ6MgawMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308501; c=relaxed/simple;
	bh=HlFGP8XLPtpsYUtg7XoYZkteefc1TUlOBolN+gMS68A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfPToVPQ4UpcLR8Fl2JawKzNkU62g6eSYKjgc+a/By/yItts1oxHcJ+Jh4XLet9yGXw5UpAnlLF2i6/ksrqQBF0uvTFtwATVCd6+H9mKsPxOF9sksE+OFai2h9HFu5f1EJE/CTJ7kd49IB/qLrTiLMu2BfiPaRBUJFNXhnPG3PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08tUPMHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08tUPMHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F694C32781;
	Tue, 25 Jun 2024 09:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308501;
	bh=HlFGP8XLPtpsYUtg7XoYZkteefc1TUlOBolN+gMS68A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08tUPMHhCGv+6P6LN+WOB24gI7TJXvUTgVsBxd5lrHq7DBZCqdFce+bKqn+dnsHZb
	 RcmylmbXWuZHhcfWLyiPaCjFOp6fdAGyQy6Jrd9ywO/dGVeMXRNQNEdcBrg4/W6d7+
	 dfSlj7pDht7sWTRQ9Q5i+jpI0jN1OkMultRz6rfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Paulo Goncalves <joao.goncalves@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 143/250] arm64: dts: freescale: imx8mm-verdin: Fix GPU speed
Date: Tue, 25 Jun 2024 11:31:41 +0200
Message-ID: <20240625085553.547220262@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Paulo Goncalves <joao.goncalves@toradex.com>

[ Upstream commit 08f0fa5d6aa9488f752eb5410e32636f143b3d8e ]

The GPU clock was reduced on iMX8MM SOC device tree to prevent boards
that don't support GPU overdrive from being out of specification. However,
this caused a regression in GPU speed for the Verdin iMX8MM, which does
support GPU overdrive. This patch fixes this by enabling overdrive mode
in the SOM dtsi.

Fixes: 1f794d3eed53 ("arm64: dts: imx8mm: Reduce GPU to nominal speed")
Signed-off-by: Joao Paulo Goncalves <joao.goncalves@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 6f0811587142d..64e2f83f26498 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -6,6 +6,7 @@
 #include <dt-bindings/phy/phy-imx8-pcie.h>
 #include <dt-bindings/pwm/pwm.h>
 #include "imx8mm.dtsi"
+#include "imx8mm-overdrive.dtsi"
 
 / {
 	chosen {
-- 
2.43.0



