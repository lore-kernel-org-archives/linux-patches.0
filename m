Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4937032B982;
	Mon, 27 Oct 2025 18:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590864; cv=none; b=f4uwEUoSp18bGviWgVYgkW0q3q/rAg9OQ1ZiSCFuUljgUOUPe3o4xhB1BA5iVkLwvnEQJr7FlfkIeKPFMtZkVqUTe8zwSxWW/p1V2KmMda7Fg8x9SfRh0vJPtbaMbCCY6+0D2Mg9CDqKF+rQOSdSRqpEhocJZythr9BXdlN1vwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590864; c=relaxed/simple;
	bh=ZxvPCpMag+2fk2l4lKFD1FIRoJfHsUqD7L71IA2qWp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUQd9ZdyjmtyzFiVpoDKYDqfsZEj/t36eYUTRo4shQIev/eY8m+LRy06/s1vBnYrgpek32rzY72gVsjaCZWydUxEXGCrFeKb3nUAApse6I16kWKHjDpd1jS4XnrzI8iEYXYxcJUYGUN4JpMWDFekwIQDJOSfy4KGhST5u8SmrOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCs+xmpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCs+xmpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A18C113D0;
	Mon, 27 Oct 2025 18:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590864;
	bh=ZxvPCpMag+2fk2l4lKFD1FIRoJfHsUqD7L71IA2qWp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCs+xmpK3TnH9Kn4C4ce2x4YLyKKurux7CaBb9CVGVfuKOCYLGLydkXcECQjJcoOC
	 P7i7WCxiOv9IXqQE3GO4Q507JFJj+f4+J7+zOQiDMEi2B19bJa9hKSO6h5uVyzEFhF
	 HVDODkZU8VZUPg81AlF1qxCZd0pZso1Vi2V9fAc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/224] exec: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:35:18 +0100
Message-ID: <20251027183513.495374530@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit 5e088248375d171b80c643051e77ade6b97bc386 ]

In the setup_arg_pages(), ret is declared as an unsigned long.
The ret might take a negative value. Therefore, its type should
be changed to int.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20250825073609.219855-1-zhao.xichao@vivo.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5dffc67745c80..5aa0d9ec7f21b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -701,7 +701,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
 		    unsigned long stack_top,
 		    int executable_stack)
 {
-	unsigned long ret;
+	int ret;
 	unsigned long stack_shift;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = bprm->vma;
-- 
2.51.0



