Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FABF1FBCB2;
	Tue,  8 Apr 2025 11:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110327; cv=none; b=mrTAHHjW3+COUE3hcs6PNVaxWfSkAuoryE8Mj+ssM7qtDB7KXYfinBy6ZcXvAslpsOT78grZuG4/4jsX/MErOCNkrmQQ7wCg07fdCTuwJ6+UWQWq5htFcIlvnVvC27b/OSBl9TVpaUdWfZeTZVVMb9M0sbW9rn889bnON/WnBZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110327; c=relaxed/simple;
	bh=MPXW5i3WIf2ugdpZArDyG9IZOrs7/VN+UUjj9jnIpLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dG1jKvs9OLKdka4Jp3xIRith97jkRVOrN0X73lMY6oXn0Dr356HeRyi0jzgDzaLOKwjImK9bxdUR9dXffPl/bprZmzvSRb7JytHiRROaxMNeBlX3Q0EAnrZTb1ag87e9Oopks2dKzxH1AB1R+B1b5GqrAGcKNH4OnzvjYqGL2So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6jzhfxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6jzhfxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9C9C4CEE5;
	Tue,  8 Apr 2025 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110327;
	bh=MPXW5i3WIf2ugdpZArDyG9IZOrs7/VN+UUjj9jnIpLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6jzhfxG/RYPYp8AvBV8UT6JrhBshO6oxy5Xxg70RO94r0v+2CoAOdLu95LNiYF9t
	 rwXh+kUZC4Qd1XOBeQE6Qd3tAtMOxpZqzEnqF5lcOEnXgxP8A4CnMT+B9emkUNADTn
	 0teiNr8QD4q0WiMYbrzltP42pKJCnDyHe7Q6c19U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 023/731] x86/platform: Only allow CONFIG_EISA for 32-bit
Date: Tue,  8 Apr 2025 12:38:40 +0200
Message-ID: <20250408104914.806292149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 976ba8da2f3c2f1e997f4f620da83ae65c0e3728 ]

The CONFIG_EISA menu was cleaned up in 2018, but this inadvertently
brought the option back on 64-bit machines: ISA remains guarded by
a CONFIG_X86_32 check, but EISA no longer depends on ISA.

The last Intel machines ith EISA support used a 82375EB PCI/EISA bridge
from 1993 that could be paired with the 440FX chipset on early Pentium-II
CPUs, long before the first x86-64 products.

Fixes: 6630a8e50105 ("eisa: consolidate EISA Kconfig entry in drivers/eisa")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250226213714.4040853-11-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0e27ebd7e36a9..cf79f973023f1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -232,7 +232,7 @@ config X86
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI	if X86_64
 	select HAVE_EBPF_JIT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-	select HAVE_EISA
+	select HAVE_EISA			if X86_32
 	select HAVE_EXIT_THREAD
 	select HAVE_GUP_FAST
 	select HAVE_FENTRY			if X86_64 || DYNAMIC_FTRACE
-- 
2.39.5



