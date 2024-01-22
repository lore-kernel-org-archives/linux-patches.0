Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37B7133419;
	Tue, 23 Jan 2024 01:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971849; cv=none; b=S07Thn/aFnbeBy02DWvsOEWBXDfCIMFBXyL9UKQatLya38HSmbcjsln90F3jQ7BJR/MXeBhGg3Axt2AzW3JOs1OZhgh/1MATQM/xa9oio2j0BOqwInS0Fb2Ihm0kElFmnkS3Q0h+aT9EeKdhNSPjUIegoCWc+rnSZLMERQD1T/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971849; c=relaxed/simple;
	bh=BRdwWXwgY7MIJqQg5ceCNOBIk4jKxDarGJdVixAQQbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDYNwrVay7LlEnNZYAdCA+pu7sUKnxoV9mOsM1A3gcB6c4I0lFwviqsmpU6e0RBsOTvpx2N9mokBg/MLF6W55ptAsHO9nLtEn3PnxaF01FxIvZOStO47nkgCpNGzOQYdxAhNInSoOQ/lYmtQA27l4VzRRCu2rWatM3JcFjs0L0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oudmbxRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oudmbxRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED6BC433F1;
	Tue, 23 Jan 2024 01:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971849;
	bh=BRdwWXwgY7MIJqQg5ceCNOBIk4jKxDarGJdVixAQQbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oudmbxRC0KbQ0XbIf9h16VLWWjbvZtn0EBTNLQEr70blYI7cLYFr0DcxsiWvUYdUK
	 uVeZhPrbmpWQVHlwZDg2JIRaT5IhyTBYP0G4+HCX30E8KQxQBQzElD7vdQTsysgTiR
	 DqblGujhzJoXbqpwrrZWsIWxT7hPsNVa7xG2Ehas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederik Haxel <haxel@fzi.de>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 333/417] riscv: Fixed wrong register in XIP_FIXUP_FLASH_OFFSET macro
Date: Mon, 22 Jan 2024 15:58:21 -0800
Message-ID: <20240122235803.319686779@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



