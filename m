Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0533A1C5D46;
	Mon, 23 Jun 2025 21:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714444; cv=none; b=kUl59J0hcU9Es7FORfAmPXtZzoPb0hHLmupW7lAQJ50rKFENwBDQOQgkT+EIhSyqfVRmoT/0LdYEJNsiYzOGfPvO9dzVHlyDl6WsHxPFsScHu2/G2zOSvBMTF3pF9i2wdEhfljE+Pyd0FbK/dGs1zs0xv836BtCii8SlBBJRCwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714444; c=relaxed/simple;
	bh=j9iZBoo7Lq6DZ2wVGFmN9poIaiyEHTjJkWjZzlCLu6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n78iKMuy/TwyJM6a9P5AWesJLc7+GeFN0U5rdRiWKlUYTycCcs+f72zZI8qmsncQbhIH0+5YzRnbstDl5u2T/gV6iZRwkaBsZa3mRaqunyUvanDPljP62YO/eTmYAGAMK1tA6cxa3GsWBRjiLDdg0t24vFgK7FVXkyiKeusNig0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdbJyssG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdbJyssG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354AEC4CEEA;
	Mon, 23 Jun 2025 21:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714443;
	bh=j9iZBoo7Lq6DZ2wVGFmN9poIaiyEHTjJkWjZzlCLu6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdbJyssG8XpAxmPLKFO0hk4ykc10T+q98Z3B+5eg9iVI/6B5FPDyedtI70BNQvqDO
	 CP0DguiEP35RWeCGChJmR6RYnHwgZ8oK3faLbzyv775jLLJURYVCy8trutnMBvCyiB
	 an6nbgsTPO43thEW/CvcXGhuIn7hIkF8BT/0IriA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 110/414] parisc/unaligned: Fix hex output to show 8 hex chars
Date: Mon, 23 Jun 2025 15:04:07 +0200
Message-ID: <20250623130644.841866705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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


