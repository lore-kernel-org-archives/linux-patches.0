Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384F26F47A;
	Tue,  8 Apr 2025 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117095; cv=none; b=SlgCwtLoVqGQ6nWYV+G2wQpfm51lJrM4bhrr581yN8Iq//Gb38om5vyz38ZsoDvgXOhp7CcWm7asv6GO66GutQxtHcAum8k7KDBRD8ghhYBWwTiUnDglS6SdnfpEDDz5bFW6YZxTu35gzMJWUNcu5+BffJxzouio8UFOTs4sXwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117095; c=relaxed/simple;
	bh=SnpRDNiemkvEEF9rcAVKwDD19Q4RBYNrYquvlOSzjyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlMvk8hiDm5lAzdUB0n7VoZ5pkGmpXAKWaAaHSTIDmV3d/ENpxVfBxMtFM3J8uvMCE4/BTx4wWuitBl3u7boH8XBpya+3gXSnepUOt8jRY7I2fLi4ybCHyEFreavwdohf/fNO59FBnWeIY2Vx/eiOIVDXdiB0GLvlXVlKEcyG3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uiu1KFxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uiu1KFxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8721C4CEE5;
	Tue,  8 Apr 2025 12:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117095;
	bh=SnpRDNiemkvEEF9rcAVKwDD19Q4RBYNrYquvlOSzjyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uiu1KFxgc2OmFHeS8g7rupRedNsivRb6EgPmmUFQnepF/RJseHjnnsgBBaX4xCE+1
	 6OH0ZX/rDdqN33tWtWFNU1jzOT88N6jcwFbfjdl3P9EwTzZ7Wut9iUIyBURMoEGjHL
	 RTUk7e/bSbNh666K02RQe1bdxWBqKcM/6bjoc3RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 381/423] x86/Kconfig: Add cmpxchg8b support back to Geode CPUs
Date: Tue,  8 Apr 2025 12:51:47 +0200
Message-ID: <20250408104854.754782237@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 6ac43f2be982ea54b75206dccd33f4cf81bfdc39 upstream.

An older cleanup of mine inadvertently removed geode-gx1 and geode-lx
from the list of CPUs that are known to support a working cmpxchg8b.

Fixes: 88a2b4edda3d ("x86/Kconfig: Rework CONFIG_X86_PAE dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250226213714.4040853-2-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -368,7 +368,7 @@ config X86_HAVE_PAE
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_HAVE_PAE || M586TSC || M586MMX || MK6 || MK7
+	depends on X86_HAVE_PAE || M586TSC || M586MMX || MK6 || MK7 || MGEODEGX1 || MGEODE_LX
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.


