Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8600B46A5E7;
	Tue, 21 Jul 2026 17:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655872; cv=none; b=qANES7sF/9IX6X6ltTNChzaDIHimJSaduuLwr4BBQ4EdLYgpOJWQLsBcBAR6mFmngCMFdgBD29hKcHitoShxeM238xRVEdQEmpaA3o3zZMFwWjCxv9VWY9yUwr/LQjjHWNsuXfw95k4gjWHWwKUx8aS0Ybq6+pWQ3SLjVXh4+aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655872; c=relaxed/simple;
	bh=UvBO4c8S7WwCGZ6EtwYLbQLCnRwVdGXgjeEBZ7wVyb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhAFYElW2/97UuUkBK/Xkt4bSSK3aYhCM70/l8QqTDLZhj7lKppOZrbz2ngKcUTmURVJ8iVemQxROCmzqaSMSw6q8tSImpnda5YD39pTy/34vgB4p+0XY1ttQhfSDIAJmRZQ3I5Ixr+lKNmDtNqgnlEiW6EpmX6vrGJuty+d3z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1TOAUrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1TOAUrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED87C1F00A3A;
	Tue, 21 Jul 2026 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655871;
	bh=VI78MAVAoNMJvJiC1YGCEe0sQk/UTyvFG5hkoCC7j6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1TOAUrrPParutX/hp0BUPCBGyB7AJxrHW+9QULV9LDwd+ZyJXBJ/rWBVrhltqKZh
	 qBUlXrb7LT1xNwJVST5U+bZLZtOT4zlHXck0UNPGs/vq6pvzGb5XH9lsgWaExAbVho
	 I8bKymg5bh73f5PSSriJ9rHlhZmuQ/fyhjTzWSiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0172/1611] riscv: dts: spacemit: set console baud rate on Milk-V Jupiter
Date: Tue, 21 Jul 2026 17:04:48 +0200
Message-ID: <20260721152518.768804778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 28afd39b28da3f..a01f69f202e379 100644
--- a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
@@ -18,7 +18,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = "serial0";
+		stdout-path = "serial0:115200n8";
 	};
 };
 
-- 
2.53.0



