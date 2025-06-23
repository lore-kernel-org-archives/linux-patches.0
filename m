Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF719223DF0;
	Mon, 23 Jun 2025 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716930; cv=none; b=YxtY0Mp96pvLIhteK3+klxqmlmbQWz2extXcd/wQRdyjXVV2z2B4ov5xaIMEO1MRFh4q6ZxVqFhBD8HtMuGhaGaSl8a4SRF0mEgehK0aVWATM/CFml4T19kcfEDJrdK6s6RwcJcJTqk9CZ9M01zanwJa17gdPKqqTKgPwgTOj+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716930; c=relaxed/simple;
	bh=u+2jIa8uslOwvNX+lzfmXfscJiQ0eWtOKtUMlz7KMio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2CL/7mNC1pCVQ335e9+JY4J3fTMEJmu/+zUrTfTNuunyd1BsLzVzVx2aswkNKQEb6AtxaXlxWWSmi7xAXXTX+lllSVi65Rwh5EOK5wl/UimsyvXL3h0qiv42N9JMlSe3I3vG0uCG964JSMxXtTR5eQ+LikuRDwDvQ3HrZR9J+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXIeToJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXIeToJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693F2C4CEEA;
	Mon, 23 Jun 2025 22:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716930;
	bh=u+2jIa8uslOwvNX+lzfmXfscJiQ0eWtOKtUMlz7KMio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXIeToJ6daWH6hEneMyxfUeds2mEUrcxsSbkAYeoO7+LCTWRNOREzh8gDwtga1Gqi
	 zEltJec74XhZw2XfnTgxHACrvEaXBd7ldrWLLk42eotgRqpw+a/Zv1c7sYxgZb8Rf5
	 gqEVF/vXkLCha1qHXbYg7HdI8Vaucil0HF3WWoqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 346/508] parisc/unaligned: Fix hex output to show 8 hex chars
Date: Mon, 23 Jun 2025 15:06:31 +0200
Message-ID: <20250623130653.860949662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -22,7 +22,7 @@
 #define DPRINTF(fmt, args...)
 #endif
 
-#define RFMT "%#08lx"
+#define RFMT "0x%08lx"
 
 /* 1111 1100 0000 0000 0001 0011 1100 0000 */
 #define OPCODE1(a,b,c)	((a)<<26|(b)<<12|(c)<<6) 


