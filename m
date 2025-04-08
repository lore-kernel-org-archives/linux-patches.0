Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F017B268685;
	Tue,  8 Apr 2025 11:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112227; cv=none; b=CHvsGCyr2fNLRoZ6YxmMTW/draRS50zIPlhO955aEF4NBAkDsQpUUm28VXPd4onaZUKmPy4PidrF3dWc3QVpbqqMm1ie5hLHqVRG08erujZO0BG2QjhZFPqIfVvtV9chFz21qMsL31+R7mPieQ0UKcltxrBXktn1lTFwABXuLXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112227; c=relaxed/simple;
	bh=o69UIHJQeyi7N7vm1sPEYwcvPRHftdZ8zzfHiRys8J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1/6IcMAbQwWC130Ml3sng+XRErH8inGmmItouRDoMzf4Tp+XTxiGYCILp+zc6aIcXZ4RLTYMZMfO8wFF6+m9hDzmYLgBhW6hh55BN2qEOlFsRBTFQcmMDIqJR4ohcanB00gUMDdh2Mas5xruKt/nf8H/jscr2XmtznkHhYjLi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeZ60iNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeZ60iNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE89C4CEE7;
	Tue,  8 Apr 2025 11:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112226;
	bh=o69UIHJQeyi7N7vm1sPEYwcvPRHftdZ8zzfHiRys8J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeZ60iNWtlW1bWeHS+CsJ/i2gPjalk2oDv5vRlF60kye7Yo7sk1BaV2wkoZcYbhgz
	 nraTsJuWHUnZoAmUoiBu6bVfkYcoMgeWbRAsyka0S/6SZ1Syskst8EWcFRoXV2/UdN
	 d4WjEPkhCK8JIT4DcaBSzeYxQgJj0t1YkfsLDHhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.14 682/731] x86/Kconfig: Add cmpxchg8b support back to Geode CPUs
Date: Tue,  8 Apr 2025 12:49:39 +0200
Message-ID: <20250408104930.131777538@linuxfoundation.org>
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


