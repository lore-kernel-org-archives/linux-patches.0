Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B3D14A4E6;
	Tue, 20 Feb 2024 21:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464439; cv=none; b=YjAudoe7PknSw87Gf+nEIUucfDsVTiQVw7HZTPIcHnvsumqyPQA0r8YgUJZKemsdFdVrpweLZ91CkIhC1SidKW1H172slt1oqAxq7+XZGapfqMgnYeKEiZFjPT/nvbfLpFUWeKZCCbm50/+JgshnYW9c6nYu9ZnBM8VnTB46/po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464439; c=relaxed/simple;
	bh=ANIGfpzaxdszfuXW+ArOG/6q1SGWB9EV9gGBhSLRde4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlAccNkaB57FhgZoyzKamXxJziLQTE8Cg30BQOVfyuNYjK3ulRmCLS+WCOwO8BEV2ZR/b6cLy6ecl/s3dTg1rtv17ske/5Ai/czaXTXL6UsxMvPYRonUoTVQFs3DuxE55Ze9gquYG4HYM8cHkfsVrGxyc/BF2H43Qa4s6P3fE44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W63erX3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W63erX3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE436C433C7;
	Tue, 20 Feb 2024 21:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464439;
	bh=ANIGfpzaxdszfuXW+ArOG/6q1SGWB9EV9gGBhSLRde4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W63erX3XEm40zbfpaHTA4zCoXfyzWgKNrjaaDjtiDTNQcwHUl+7mWIzyMU7TevMX1
	 FYy7EpduvLsXVGmbiD4FW9IYcFu4nBfQnFhOsZ6mfg8aszhe4QU9zSE43ZH9OF0zKc
	 Q8gc6UV2unXFBAhXpyBfdqHq1csAjxLPExYM6vhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Christopher Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 003/309] mm: huge_memory: dont force huge page alignment on 32 bit
Date: Tue, 20 Feb 2024 21:52:42 +0100
Message-ID: <20240220205633.217454471@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

commit 4ef9ad19e17676b9ef071309bc62020e2373705d upstream.

commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") caused two issues [1] [2] reported on 32 bit system or compat
userspace.

It doesn't make too much sense to force huge page alignment on 32 bit
system due to the constrained virtual address space.

[1] https://lore.kernel.org/linux-mm/d0a136a0-4a31-46bc-adf4-2db109a61672@kernel.org/
[2] https://lore.kernel.org/linux-mm/CAJuCfpHXLdQy1a2B6xN2d7quTYwg2OoZseYPZTRpU0eHHKD-sQ@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240118180505.2914778-1-shy828301@gmail.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Reported-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Christopher Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -37,6 +37,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
+#include <linux/compat.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -634,6 +635,9 @@ static unsigned long __thp_get_unmapped_
 	loff_t off_align = round_up(off, size);
 	unsigned long len_pad, ret;
 
+	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
+		return 0;
+
 	if (off_end <= off_align || (off_end - off_align) < size)
 		return 0;
 


