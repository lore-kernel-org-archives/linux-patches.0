Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE602288CB;
	Tue,  8 Apr 2025 11:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112610; cv=none; b=cJEnQyOxa6GkF2W2b26gY8dyqCR0mhkA54O624egSj5QfBGeSKaIqzY1yhPJhl0w8tCTiB7xIJ6pyRKfd4ESw2mLhLf9z+sacu/nB1E50A/JbUUmebQcZWBYEuCx/ZaR/D823ty08BUBEABCvM00e+wMUNGWaOfpoQLr8qptTNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112610; c=relaxed/simple;
	bh=RQ/2qePzQFZAWic8KcynjN6m6n9F5UMMwUbqPUh86Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiQRXqeExhtm/bXp/9TBIIRRnUxEZzgR6CaNJ1/s5UuKKBTsOGy2Lznj+1NcrkvKil3+CiADuCP9vBOm0AUOpyrTdV9GqPOoCaHwaDW/CK4yMjtIjAJWyLCyIOn9gno8hHt3olf+DmD6GASSwwJgPrOvqnere6l9DyXVrF8yijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf/CVdto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf/CVdto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2039C4CEE5;
	Tue,  8 Apr 2025 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112610;
	bh=RQ/2qePzQFZAWic8KcynjN6m6n9F5UMMwUbqPUh86Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pf/CVdtowQfYd5jEWG00x3+HL3LIa0mLCnXgqj76wHrH55LDKngy7tQCbSYphCnUX
	 Aet4VBmbd+zOT0Zgtppm+XFzn9OISbXujX3hYn1L+ocN/aBCE9qeKsbIcyCYcOhZaW
	 6qe0XzhMVyy95NqurX/VMZ/r2MC36rt2mX2UTfEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/279] x86/platform: Only allow CONFIG_EISA for 32-bit
Date: Tue,  8 Apr 2025 12:48:36 +0200
Message-ID: <20250408104829.931494641@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 90ac8d84389cf..de6a66ad3fa62 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -194,7 +194,7 @@ config X86
 	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	select HAVE_EBPF_JIT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-	select HAVE_EISA
+	select HAVE_EISA			if X86_32
 	select HAVE_EXIT_THREAD
 	select HAVE_FAST_GUP
 	select HAVE_FENTRY			if X86_64 || DYNAMIC_FTRACE
-- 
2.39.5



