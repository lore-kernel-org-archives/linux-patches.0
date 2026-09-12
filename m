Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A6335F184;
	Sat, 12 Sep 2026 08:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200340; cv=none; b=lnac/iKnty2JYAFpv+a1ElaHYZXsouhSjuB/7QCrvXQU20UL9Ya5uCFH8BuLao/IxT02C1FQ5aEyf8yvPSJ65eBAJQhPZW0lWbHPpiC4qIGOIHM0ImHWo0BDOR03WXIyheDkXf0Bpea9y+dcqQfqPjTEM0oW4BadOR8GQrQ4UyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200340; c=relaxed/simple;
	bh=xv5BzWGiKHGnq4GbuO5/msDnhVdbXqkDhhMdYAsmBTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EDIe6fOyFqk7dKEMqi8Y9itE2Q8LXfUKD0tpTkEm0pFOQDJIsUduB+XeFlyzf0FaJSTCjhr0K1WPGoczGRInaYbj4THzVTvGb7KE4PNzV3ACbatvcoM347Q3xQeKHkiavFG7K77oHzaQQOd1Vcn2voiUC7/nFnHFrltX5Kh9bmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALYdf8YX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALYdf8YX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679BC1F000FF;
	Sat, 12 Sep 2026 08:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200339;
	bh=DEEK6+OiTuuNluoLFAAjOIBW68FEHnZ6EVsLKP35mmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALYdf8YX2w8yiTPFoxl7CIV1Z8TH3wt0LNMcP6ex5f791mALlLE9ir4cz3k0qfAFo
	 6eX6kG9hhg3+bH3bFJ25DhiAj2qFtLrmu8iKW+wFzUtGu9cF4RS4lHSTGs7+FArArg
	 tQOf/RXbpJsOHQnWw6AvpiVHA0RId4fW7oOEX/Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0768/1815] tools/nolibc/powerpc: mark ctr and xer as clobbered by system call
Date: Sat, 12 Sep 2026 08:41:58 +0200
Message-ID: <20260912065706.935729730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9fc5a1742b0c8fb7edf066cc17fa0b18b7be623 ]

The system call can clobber the ctr and xer registers.

Make sure the compiler takes this into account.

The missing clobbers only seem to be an issue with newer compilers.

Fixes: 0cb0675ec37e ("tools/nolibc: add support for powerpc")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260727-nolibc-powerpc-clobber-v1-1-e0911cc99ce1@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-powerpc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/arch-powerpc.h b/tools/include/nolibc/arch-powerpc.h
index a1ab91d553845..dbe2e5205aaaf 100644
--- a/tools/include/nolibc/arch-powerpc.h
+++ b/tools/include/nolibc/arch-powerpc.h
@@ -26,7 +26,7 @@
  */
 
 #define _NOLIBC_SYSCALL_CLOBBERLIST \
-	"memory", "cr0", "r12", "r11", "r10", "r9"
+	"memory", "cr0", "ctr", "xer", "r12", "r11", "r10", "r9"
 
 #define __nolibc_syscall0(num)                                               \
 ({                                                                           \
-- 
2.53.0



