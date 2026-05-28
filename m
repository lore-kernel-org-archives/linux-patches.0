Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286F434F49F;
	Thu, 28 May 2026 19:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997997; cv=none; b=AA4QKT/y0rTeFO6bf6HBONGk7qvQ1607/ArC0WMNU2b479q6qaKf5vJhYvp8q/CaE400ZdtQySGG7IxQfRVhet+S7BTraq22CuyxY89rOyCiILvTQE3SnzRT2oeyS7/NfGXbUt6gDyM2NIqKaDEfXyI6bfCTX8rmC6y5c4XzPNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997997; c=relaxed/simple;
	bh=+Oq0jAVn895IxyWiCBD6kt+O9vww6Vw25QFSEO8jxp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuG40LQwb4JZtZz+bJ5KEbtNA8bIw6t1hMas1AaLlY4t9EVRfjAG11F0pm+dskqEr9fe1rmr8SzS6QvYiy5+65m2sTkUk7c57b/BmK9ghX8G3pQAX4KFE3mXvJpwMcupaK9TLIoPD4vVvf6KdyNfH9kNPLI+gbGjKXcJW+sP360=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIvwJk21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIvwJk21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3941F000E9;
	Thu, 28 May 2026 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779997996;
	bh=oUeZ+P5lJorYmF/83Z7TtK0iiG00IUHPREMmknWp9D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIvwJk21+FLgqSxsxg80iBe5bwZOArBeaPnTbnPP/wOzl4Z2HXkNqJ46mAVKbeufH
	 WGog6tzKHpnVzBgABWJcgWYMwaNobaQhCdybFUIZGPA5Uz63PLMasUjtnv4ldflGIz
	 JXXjcgwUgGg9TygwK1ZzNexsMKgOfH7jX2/wS5AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Illia Ostapyshyn <illia@yshyn.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Hao Li <hao.li@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	Seongjun Hong <hsj0512@snu.ac.kr>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 017/461] scripts/gdb: mm: cast untyped symbols in x86_page_ops
Date: Thu, 28 May 2026 21:42:26 +0200
Message-ID: <20260528194647.366291618@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Illia Ostapyshyn <illia@yshyn.com>

commit c416aee7e7d04fec2d2d30786b3c8393108b85d2 upstream.

The symbols phys_base, _text, and _end, used in x86_page_ops are either
defined in assembly or implicitly by the linker.  Thus, they lack type
information and cause a conversion error after gdb.parse_and_eval.
Explicitly cast these expressions to unsigned long.

Link: https://lore.kernel.org/20260427142448.666117-2-illia@yshyn.com
Fixes: 55f8b4518d14 ("scripts/gdb: implement x86_page_ops in mm.py")
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.com>
Cc: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
Cc: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/mm.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index d78908f6664d..dffadccbb01d 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -40,11 +40,11 @@ class x86_page_ops():
 
         self.PAGE_OFFSET = int(gdb.parse_and_eval("page_offset_base"))
         self.VMEMMAP_START = int(gdb.parse_and_eval("vmemmap_base"))
-        self.PHYS_BASE = int(gdb.parse_and_eval("phys_base"))
+        self.PHYS_BASE = int(gdb.parse_and_eval("(unsigned long) phys_base"))
         self.START_KERNEL_map = 0xffffffff80000000
 
-        self.KERNEL_START = gdb.parse_and_eval("_text")
-        self.KERNEL_END = gdb.parse_and_eval("_end")
+        self.KERNEL_START = gdb.parse_and_eval("(unsigned long) &_text")
+        self.KERNEL_END = gdb.parse_and_eval("(unsigned long) &_end")
 
         self.VMALLOC_START = int(gdb.parse_and_eval("vmalloc_base"))
         if self.VMALLOC_START == 0xffffc90000000000:
-- 
2.54.0



