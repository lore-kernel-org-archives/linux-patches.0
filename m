Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EF31F5404;
	Tue, 21 Jan 2025 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482428; cv=none; b=nn7t8f4o9j5MHmeZdKJWMC6gmRcOPyt/qEnBYya7o9cF5cw2E+hlYlqovs9wumArD118mcpUtVV1bmQjwLT28D7lb8vIpM7oonr4HD988yMGscKYVLpU8cj75Vhqe/1Akdqu1nwsu1pfJqALwmzXR2lxOtT18/qraevBVQ3n564=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482428; c=relaxed/simple;
	bh=xCVWvfVvrm8aSv6J0awHXj7abwu+yz2QFL7QubaYuYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8g+Ah/5cgCGgzb8VGJrBoY/vFzoLQHcVtoGOvs+C2lilB9SJdZWbucuFEstZtrnPjd4wd1vwugcnoQ2mFXr8+G9NXrImDmM04KG3DG8U37dP8eL5EZXodlD0+F6jSMR7DyC2sVVm8wlGczq5q8sE8vNzGK33QBZK+wSOkxEjyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny9ft9tB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny9ft9tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3A7C4CEDF;
	Tue, 21 Jan 2025 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482428;
	bh=xCVWvfVvrm8aSv6J0awHXj7abwu+yz2QFL7QubaYuYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny9ft9tByaVmNq31ccAS53ggSh+etJpaUpwxncJeNL1uZp4+j/pbCHVrM9EdByaWL
	 5Cri+2FeIunXkqxCCaCzx6XFfsFb5j79QceFi7dlWaVoCYoMdaLoEysBMqsQ2kg3qS
	 mJ67jQR7LTkiovzV5b6DsKlC15gBbwnqGTw9SU0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/122] x86/asm: Make serialize() always_inline
Date: Tue, 21 Jan 2025 18:52:02 +0100
Message-ID: <20250121174535.844086555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit ae02ae16b76160f0aeeae2c5fb9b15226d00a4ef ]

In order to allow serialize() to be used from noinstr code, make it
__always_inline.

Fixes: 0ef8047b737d ("x86/static-call: provide a way to do very early static-call updates")
Closes: https://lore.kernel.org/oe-kbuild-all/202412181756.aJvzih2K-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241218100918.22167-1-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/special_insns.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index aec6e2d3aa1d5..98bfc097389c4 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -217,7 +217,7 @@ static inline int write_user_shstk_64(u64 __user *addr, u64 val)
 
 #define nop() asm volatile ("nop")
 
-static inline void serialize(void)
+static __always_inline void serialize(void)
 {
 	/* Instruction opcode for SERIALIZE; supported in binutils >= 2.35. */
 	asm volatile(".byte 0xf, 0x1, 0xe8" ::: "memory");
-- 
2.39.5



