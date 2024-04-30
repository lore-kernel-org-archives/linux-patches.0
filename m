Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3159A127B70;
	Tue, 30 Apr 2024 10:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473803; cv=none; b=aUHua1C/hRpkskAGFTilx9mEUzc9Xwp7MzW33hZjoUSldh9Gd/GVpJC8G4r7E2aKaVWKKp79GbJ+EaGKK7yqX7Pk70MDqDoUY5Oob0jfNFozTtJMPhb7s6AQWLn2QIHTzV95U/Ie/YimbD4UpmdW52QIkgWmN8vFwrpVAvcOXGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473803; c=relaxed/simple;
	bh=vrcGxd1iod31I02HaCKdGpaeq4s0sWyXj/DKjvuJ3AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLeSb2yQAN6Jv8YxGuV9sh/r/k7x7sNR7tiTr1jHl+4ZVHFO+CwCBh66pcMLD+bs6cLRcu/gqxSoguqzLMZEYOV4vWDqC8tqnl9xcnH099aKRxmmIY6Vo4Gjv48KAfwdVZlQTKRwsjlM870JDVlJ+vhspsY/ogZG0cMLkADP5Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lmg07e9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lmg07e9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C6DC4AF1A;
	Tue, 30 Apr 2024 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473803;
	bh=vrcGxd1iod31I02HaCKdGpaeq4s0sWyXj/DKjvuJ3AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lmg07e9lrq3i+kVxMnyMgc3JToO7O4qbn118pFnF5qemCnfbdKyuqCQ/8NxBD2w5T
	 fhAOH5A7ZRj3FFUxxdc4Uo3uCx7FdXk6EKxJmk49FAalDcloi+SfLBLw27ADnDPI3M
	 o0toRUWI7SimhSd8pkDxAQqBHT771iy4UNZE5lI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vgupta@kernel.org>,
	Alexey Brodkin <abrodkin@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/77] ARC: [plat-hsdk]: Remove misplaced interrupt-cells property
Date: Tue, 30 Apr 2024 12:39:22 +0200
Message-ID: <20240430103042.405725384@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>

[ Upstream commit 61231eb8113ce47991f35024f9c20810b37996bf ]

"gmac" node stands for just an ordinary Ethernet controller,
which is by no means a provider of interrupts, i.e. it doesn't serve
as an interrupt controller, thus "#interrupt-cells" property doesn't
belong to it and so we remove it.

Fixes:
------------>8------------
  DTC     arch/arc/boot/dts/hsdk.dtb
arch/arc/boot/dts/hsdk.dts:207.23-235.5: Warning (interrupt_provider): /soc/ethernet@8000: '#interrupt-cells' found, but node is not an interrupt provider
arch/arc/boot/dts/hsdk.dtb: Warning (interrupt_map): Failed prerequisite 'interrupt_provider'
------------>8------------

Reported-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/hsdk.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arc/boot/dts/hsdk.dts b/arch/arc/boot/dts/hsdk.dts
index f6b6e3c9ca8aa..40a6681bae8a5 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -170,7 +170,6 @@
 		};
 
 		gmac: ethernet@8000 {
-			#interrupt-cells = <1>;
 			compatible = "snps,dwmac";
 			reg = <0x8000 0x2000>;
 			interrupts = <10>;
-- 
2.43.0



