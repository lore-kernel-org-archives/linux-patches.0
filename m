Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209196;
	b=BfEUxfaER1DUinG6gHEMKCSo4gxQJn9ah/hGgNuptK6P02K4eAZ1AxgglejfxUwcH7Fg
	 gXiustDWMs4U3ZIhhOcJIA7SpTGeUiszGxIFo04X3TfB4BSF5I86827GFe1KwRXUbBEiw
	 MZ3G1QucLnsdUxYkDjV5FKOH+PU7Gvn4AjOX77G0rTMobXPSonrKHKVrKa4UfMwAXcR8e
	 1UEWPW0yd0vtaeOtU0SDspF5b2zJuIAYMvq3eXVxZzZRBfpBrt6vDln4qZ05WvAX5G3ZQ
	 a3S/Mb4aqWMZQ5fEb6Pm6bxatRm04s7o6OEDSua3hwB+I2tCbMo0l0C9MgLjF0Lx+8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+RD6fbbA1nLuC5rCf1RCJ6aeMYisNTZrPKRAc4WKO5I=;
	b=1oOXFGUG1tpgvF8OO5nLsacb+ZKuRrJqrW6mz3or5b/DHNvyN13dokeeKtu0xTa+hkI9
	 CkJOnoyQgIO8YcSZHiNzVjd00DfVepnmE1N7iH0KgH4Tk5/R2xlf5PH8CT8eVeo6LlpNQ
	 LCoz1nmUC++8UEJo/5AplNC7VGjEm7aucL7PGGkx6xOH2QDkZDTa7u6Ovxd/uTEBnJaQD
	 BZ9CgJcyc/P4+t1skQCZIGFfpox5asWzxttc11/IqpvMgT4TNIi2HLvWLm9RtDNVCnju5
	 3jI6tby8hjROIpbzbhow8bzREgWDpnZHNfQXNmuWNP5hi6jLNgfKu0tL7ZtYOltjMeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UOeNd02v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CE1606A321;
	Wed, 28 Oct 2026 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UOeNd02v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FF51F01825;
	Wed, 28 Oct 2026 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209196;
	bh=+RD6fbbA1nLuC5rCf1RCJ6aeMYisNTZrPKRAc4WKO5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOeNd02vS/hNxFUBpbMxvv0+DgVY65Z9iYozD5WtDoEClZQzmKETqML6p5dc2R8K+
	 NeYuQLdSiGADnOGlVRg+rrl5OjZeYziCrjSi9NN5cNUdNfz0/NvUh8bGSW8IoLnPw9
	 DQs6vdfI3Sss/J/i/8MxSZItQqr0r3RYofIIz5n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ira Weiny <ira.weiny@intel.com>,
	"Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Helge Deller <deller@gmx.de>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Kees Cook <keescook@chromium.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tony Luck <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/516] highmem: round down the address passed to kunmap_flush_on_unmap()
Date: Wed, 28 Oct 2026 17:58:59 +0100
Message-ID: <20261028170012.649771961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 88d7b12068b95731c280af8ce88e8ee9561f96de upstream.

We already round down the address in kunmap_local_indexed() which is the
other implementation of __kunmap_local().  The only implementation of
kunmap_flush_on_unmap() is PA-RISC which is expecting a page-aligned
address.  This may be causing PA-RISC to be flushing the wrong addresses
currently.

Link: https://lkml.kernel.org/r/20230126200727.1680362-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 298fa1ad5571 ("highmem: Provide generic variant of kmap_atomic*")
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ 5.10 has no include/linux/highmem-internal.h and no
  kmap_local API, so __kunmap_local() does not exist. Therefore,
  I applied the __kunmap_atomic() hunk to include/linux/highmem.h ]
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/highmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 5f7cd58db4780..a2a252a93d760 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -218,7 +218,7 @@ static inline void __kunmap_atomic(void *addr)
 	 * handles re-enabling faults and preemption
 	 */
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 }
 
-- 
2.53.0



