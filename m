Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA8B629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE34C433C1;
	Wed,  2 Nov 2022 03:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359732;
	bh=rWhU/SqasFIJoRXBvcjIy/bDPWGDBqbBtACBiwQelic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8RPaZrdBDL9ZM3lMoSL0G9DtgsN3CGVgDqNozZn3jCxilZ9XPZw8cB33oY1iYDbF
	 HfFNZYyqWsGHHH007HdvAmh/B+q9UPtLN3rGxWEqyEa9YJIaQUxfw4w5XJEEN9nWxU
	 jdbxtsnqVLouIdsQxZXfZrJjSat0T+UacINre4VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seth Jenkins <sethjenkins@google.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 4.19 25/78] mm: /proc/pid/smaps_rollup: fix no vmas null-deref
Date: Wed,  2 Nov 2022 03:34:10 +0100
Message-Id: <20221102022053.728324426@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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
@@ -843,7 +843,7 @@ static int show_smaps_rollup(struct seq_
 		last_vma_end = vma->vm_end;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");


