Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98947331A46;
	Mon, 27 Oct 2025 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591899; cv=none; b=JmrJ2FlHXMyaEj6dIai4cNHvo5ynzwulS9oVWir636qAPtyTE4gvG9ibV6yb6rdnU0qdnVW7lgcNzvNG+Sukk2Oax4wREAiWjZTrAec1PUbI5q1INCezNlGZcJpx1pW8gUtY0pP83ic1oIyPOuIKdpRYDOL7+RVoPR5N96sOrM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591899; c=relaxed/simple;
	bh=XV/UpHdbAgVqXmkk3I9/L62REeZLtckzgRKD/rjn/eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqWRHmOIMbcIJQnSBQl0sZMgrWvR0dYN0qYyna3vj3V19UOunIMdBmxRSBAsdzICPHOiw1vj9gVJnwvSaNOA1F3bLGcZz1V0OZMHDMoOIbaSjIyxNiMtYnqPPA/DkxlZpSu7CQeWK5BakJC4qpr0jfXmRZPJBNhtjTaKHOWAG/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNsbrCs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNsbrCs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D909AC113D0;
	Mon, 27 Oct 2025 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591899;
	bh=XV/UpHdbAgVqXmkk3I9/L62REeZLtckzgRKD/rjn/eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNsbrCs6klm7cLQ4vP+20jjTxCim4lAlQPdOlT/5e9S2sSAfHCwnntH120wQTLlhR
	 LcsSokeBtSGYA1u95pdoZYw0/838xjsZ2rjqO2Luv37N63NjI3CqS90LM7vB+Yllg/
	 BVh1rpHm3KNYJPPLo6xDZYpsm3nmLglb/jWKITPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/123] exec: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:35:21 +0100
Message-ID: <20251027183447.503242332@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8395e7ff7b940..4d5defc2966bd 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -746,7 +746,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
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



