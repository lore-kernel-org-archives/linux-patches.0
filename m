Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE03A8F4;
	Tue, 23 Jan 2024 00:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969874; cv=none; b=EyABf8EF3OcdUdTUcNLbKJUDl37ck4nHxYSiRjj3UeNrpi5bf4IFpO14S0HsSJ8FS8LpLSuW+bGpHVNSMUUvXZkA6/P2qFgmNOSU8xt3H5YGmedWqCE44LzsfmdYKCmnCMI9eC+SHt9Yd0UpYbX1IC1/pa6m+zYb2n3s+SV72Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969874; c=relaxed/simple;
	bh=RuyR1dhoDyAE5wAenub33PwHN/bibOV1Wj5xxPXnvq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idX9bX1lzpakz9wGCpMR3pMAzStm2qTwRUb9ixgYm1BwnBexgAOlh0M4IlPCzZNjCr7SvVsbkVcXh/SUcY97Tv/qsl9iccRph77QaAFJx1/54g3R9lkqUvm79IlGMGWr9H305xGhdECEUqQNnfjnJb9/z0xjp4fcZdPvjW+ufnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpu5bNqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpu5bNqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6182DC433C7;
	Tue, 23 Jan 2024 00:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969873;
	bh=RuyR1dhoDyAE5wAenub33PwHN/bibOV1Wj5xxPXnvq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpu5bNqVH4/KljYs33O1Bg+gFyfVEvfhzkfRMHYQLCNqn3pY4y1kiXqdpxmBPc14m
	 rb/tiLAyngONchJP1xC66LisOQo3J6q52u0W+Bzy20NlatnBNhXdh7VNv6dhLfSMVO
	 DuyWUO3m+YEIoybGo5dIG2GDZ0XodmLHEhNE9HQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederik Haxel <haxel@fzi.de>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 498/641] riscv: Fixed wrong register in XIP_FIXUP_FLASH_OFFSET macro
Date: Mon, 22 Jan 2024 15:56:42 -0800
Message-ID: <20240122235833.645271726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederik Haxel <haxel@fzi.de>

[ Upstream commit 5daa3726410288075ba73c336bb2e80d6b06aa4d ]

During the refactoring, a bug was introduced in the rarly used
XIP_FIXUP_FLASH_OFFSET macro.

Fixes: bee7fbc38579 ("RISC-V CPU Idle Support")
Fixes: e7681beba992 ("RISC-V: Split out the XIP fixups into their own file")

Signed-off-by: Frederik Haxel <haxel@fzi.de>
Link: https://lore.kernel.org/r/20231212130116.848530-3-haxel@fzi.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/xip_fixup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/xip_fixup.h b/arch/riscv/include/asm/xip_fixup.h
index d4ffc3c37649..b65bf6306f69 100644
--- a/arch/riscv/include/asm/xip_fixup.h
+++ b/arch/riscv/include/asm/xip_fixup.h
@@ -13,7 +13,7 @@
         add \reg, \reg, t0
 .endm
 .macro XIP_FIXUP_FLASH_OFFSET reg
-	la t1, __data_loc
+	la t0, __data_loc
 	REG_L t1, _xip_phys_offset
 	sub \reg, \reg, t1
 	add \reg, \reg, t0
-- 
2.43.0



