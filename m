Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B858C214813;
	Wed,  7 May 2025 19:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645143; cv=none; b=BPCmwH8XiBWMnmrxAm951N1G4sW/U9ovDwXJwVNZ4mNM2K9P47C6jK2QL2+bFeD6Pd4+mWaY/MAdZ0sXcg4VuOtxS+ehfI0KcNDESrCGlNeS9k9L9Fk5yNoRB+qcLh5oYsFuhe+sifviCdXUJrAb5QwpzeCr9+EcPcnp1D1crnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645143; c=relaxed/simple;
	bh=UZK5fAWU9oErdsqou8j1auVdvsPt+YEcIHv0gFzt79U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iddC4TkfPtKdi4ZI0NnK2Dxz06kcs0rrPxIBo+p1QVmUmlv97tjSh89eqeRW6qHAZ+6xzgLOHpooA0oY9JmskbRrFYgF5kRxYQnTapFpf/P/fOHTs+/MAHcgort2ZrpJryKQRi1pei2WlAlVCvDfUmsrAp2F0d6hR0ZJxkQWtiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIp61qpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIp61qpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F69C4CEEB;
	Wed,  7 May 2025 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645143;
	bh=UZK5fAWU9oErdsqou8j1auVdvsPt+YEcIHv0gFzt79U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIp61qpCYOuMigcFtfsgcXfdtVCX1qXzSCemY1l+oJ5Lx6dckK6mxWIqGCpM/22RK
	 lIldF1V1mNmdVTxX42lOKa49mJPkT1cDETtJGfsauJIQa332zK9CNRaFDFtb1Gy/R+
	 pUjqzBegadJfvFXli7nB0wzHFuRitB5sq1R02JLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/129] arm64: dts: st: Adjust interrupt-controller for stm32mp25 SoCs
Date: Wed,  7 May 2025 20:40:43 +0200
Message-ID: <20250507183817.829718576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit de2b2107d5a41a91ab603e135fb6e408abbee28e ]

Use gic-400 compatible and remove address-cells = <1> on aarch64

Fixes: 5d30d03aaf785 ("arm64: dts: st: introduce stm32mp25 SoCs family")
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250415111654.2103767-2-christian.bruel@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 5268a43218415..3219a8ea1e6a7 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -73,9 +73,8 @@
 	};
 
 	intc: interrupt-controller@4ac00000 {
-		compatible = "arm,cortex-a7-gic";
+		compatible = "arm,gic-400";
 		#interrupt-cells = <3>;
-		#address-cells = <1>;
 		interrupt-controller;
 		reg = <0x0 0x4ac10000 0x0 0x1000>,
 		      <0x0 0x4ac20000 0x0 0x2000>,
-- 
2.39.5



