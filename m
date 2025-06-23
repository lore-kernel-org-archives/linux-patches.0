Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5C4241668;
	Mon, 23 Jun 2025 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684611; cv=none; b=Tg5MenlPJG5B756lxKuRdcGP2nPjTI1d2Lh+Ph+4P+qiTclJdYkoQ3267uaQqy/G8jlDzok6/y8En2KjBtjZI4DA50YlXsZCLvfGvk0n8eTnzpoRL4a6F2BhRmotHCWCyBgt0jeKeRJt01hO9VB7uLB0eWoMlX2SRtHKOeyTJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684611; c=relaxed/simple;
	bh=X3TIlFJDfUEuKaKaMrTOatDZZyk5JKjvubsD47jh33U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7gdrPPgh2LyredEVy8ACPKQlTrqE0wvMNkIS57xMb4YyN6BcCqyv9/2+hHh0yi3ZuUJs4VaLRiyCx/zjzvyBEUrk9YTD12ZuJrTskzlxlm4sSuNu1DlE+DY701RlqXlW6QudCQSkZhVIm80+F6LMtbFL141/oazro/bJfNGvPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxsFt05A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxsFt05A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F109C4CEEA;
	Mon, 23 Jun 2025 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684611;
	bh=X3TIlFJDfUEuKaKaMrTOatDZZyk5JKjvubsD47jh33U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxsFt05A3UWZCVsc3/xKgAGUxzj88+w9fsfU4JYcPC4qvrMXyVDDwBmVoBdT8lIZY
	 QXyXxamRrn/obIjCIJ5o8xhvGWP/OMkhXA2cXv3Soda40v4GRLJFKC0SQ8nILtOS4t
	 LlAqWKFkeWo/MZ9RGGylqzYMVOrmRloDnFIHIGyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.15 134/592] parisc/unaligned: Fix hex output to show 8 hex chars
Date: Mon, 23 Jun 2025 15:01:32 +0200
Message-ID: <20250623130703.460258717@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 213205889d5ffc19cb8df06aa6778b2d4724c887 upstream.

Change back printk format to 0x%08lx instead of %#08lx, since the latter
does not seem to reliably format the value to 8 hex chars.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.18+
Fixes: e5e9e7f222e5b ("parisc/unaligned: Enhance user-space visible output")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/unaligned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -25,7 +25,7 @@
 #define DPRINTF(fmt, args...)
 #endif
 
-#define RFMT "%#08lx"
+#define RFMT "0x%08lx"
 
 /* 1111 1100 0000 0000 0001 0011 1100 0000 */
 #define OPCODE1(a,b,c)	((a)<<26|(b)<<12|(c)<<6) 


