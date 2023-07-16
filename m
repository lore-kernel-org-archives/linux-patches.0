Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B9E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E83C433C9;
	Sun, 16 Jul 2023 20:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540481;
	bh=127lfjd+8xkAwA6OEa9X8oC1WvhgZTDWQiLOofoJrdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9NPUDIaWP7h6AWgz2U0Bqr/pi+OgJpl5y1CJVfirteNqEwrnzQMVamjjyUuaTCOc
	 2uZLk69IULi47EiAxhEQbjkIdDYoCFFa45MeRJfm5z9VVDRPP8zYWQhh2K5zrGD2uT
	 yIZFfeWIVibJKLXO6mWr/DN1vj8Tz6dHCsSAsYqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam.Howlett@oracle.com, torvalds@linux-foundation.org, vegard.nossum@oracle.com, stable@vger.kernel.org, Suren Baghdasaryan" <surenb@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 6.1 371/591] mm/mmap: Fix VM_LOCKED check in do_vmi_align_munmap()
Date: Sun, 16 Jul 2023 21:48:30 +0200
Message-ID: <20230716194933.518126918@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suren Baghdasaryan <surenb@google.com>

6.1 backport of the patch [1] uses 'next' vma instead of 'split' vma.
Fix the mistake.

[1] commit 606c812eb1d5 ("mm/mmap: Fix error path in do_vmi_align_munmap()")

Fixes: a149174ff8bb ("mm/mmap: Fix error path in do_vmi_align_munmap()")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2484,7 +2484,7 @@ do_mas_align_munmap(struct ma_state *mas
 			error = mas_store_gfp(&mas_detach, split, GFP_KERNEL);
 			if (error)
 				goto munmap_gather_failed;
-			if (next->vm_flags & VM_LOCKED)
+			if (split->vm_flags & VM_LOCKED)
 				locked_vm += vma_pages(split);
 
 			count++;


