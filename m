Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2743A8487
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EC8C433D6;
	Thu, 27 Oct 2022 17:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890058;
	bh=Pw2qG8ySDOSPYOREsIfj/HdA4rT7cEwRYBQGejksN/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuI+7DtWzQr3Z4x3ttcZJA1wUHfETtfrm6BCqQQQ67jaOv/RQtiL4+uW+y1JvgPb5
	 yuPywAk9YvmJOLn2a07UdhjHzl9+BCgvQiHLxE9bN9Wxsgk5072tmC8S+QDfrANsPz
	 aze/+LWBtVkwwti/edVAbsULNiU9npeGifI+TkD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seth Jenkins <sethjenkins@google.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 6.0 94/94] mm: /proc/pid/smaps_rollup: fix no vmas null-deref
Date: Thu, 27 Oct 2022 18:55:36 +0200
Message-Id: <20221027165100.996688434@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seth Jenkins <sethjenkins@google.com>

Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
seq_file") introduced a null-deref if there are no vma's in the task in
show_smaps_rollup.

Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -969,7 +969,7 @@ static int show_smaps_rollup(struct seq_
 		vma = vma->vm_next;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");


