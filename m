Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C276546A5FA;
	Tue, 21 Jul 2026 15:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648562; cv=none; b=MWTGDEmt2l7dvO6/YW1H15lGDqiPt/YXLTdliph5f/BL3EdyRn4QdwliwJU2eDOZlB9lsrOkAQUzGdEaxkAO8ULwHnVe+9dxZMgNCBCMstnzPsMeDRe6dDefHGZHDm/jeYkEvu4h3k1Ep/1pBmN0IzXXMMGq+k5xPQ0DuNcyKU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648562; c=relaxed/simple;
	bh=BMDgSAmyZYtNU4fX91YymmMYBJIx4ryCaCUMSzIh9CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a36k0WGb2ZAPiDTYxDSuR0HVVobEFuK4tVYZlFA7iTOLs+FKAeEE07iMtQrMktAKFMbT47PJa1HwI+GLOM993ABiD38Qpe/mgPJ9Pz5mKLFkr/0pbg/HJRS+8ycSW0NcqvAmzOwCZjY48rDzkTmQGKZ49hVZLpG7ecO3WWXFcOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+px2XbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+px2XbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336841F000E9;
	Tue, 21 Jul 2026 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648560;
	bh=JapX5dxqerHqtztkaNCK9J/KKdAjHOdp/aRAUhwxb6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+px2XbL7rF8ZoS+jOtnvfWGLWR4xeCWl31gJLmS62gO6wuAjymwdXBklfPnD2x7B
	 ZrDXOtYG2FRgvOJQnh2u6dLUKRu3RaBG/PRjMR6Jtd8Tw5ZespWCf/hSmdG6rFW28g
	 NeLhRbwFx7IMNS6OPYcSSOGMHrVqwoSST6i/mgy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0246/2077] riscv: dts: spacemit: set console baud rate on Milk-V Jupiter
Date: Tue, 21 Jul 2026 16:58:39 +0200
Message-ID: <20260721152558.482329331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit 4f97acb4f744f516bbe976da8282c0fe213216ff ]

Because the default console's baud rate is not set, defconfig kernels do
not have any serial output on this platform. Set the baud rate to
115200, matching what is used by U-Boot etc on this platform.

See-also: 24c12ca43b12c ("dts: spacemit: set console baud rate on bpif3")
Fixes: 5b90a3d6092d9 ("riscv: dts: spacemit: Add Milk-V Jupiter board device tree")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260519041458.3287843-2-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
index afaad59e6bce22..db98dbfadf00ff 100644
--- a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
@@ -20,7 +20,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = "serial0";
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
-- 
2.53.0



