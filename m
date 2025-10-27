Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C829E314B8F;
	Mon, 27 Oct 2025 19:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592557; cv=none; b=LJfHu5BQmSfppht88T782O3aMrbyfN/V//CLp7VwNf5ulvXJtu+YXUrxTi5OnyEiAGcoTv/b3w9ozghchip8ALOZ8EDwlVYrDXHEjeRo2AaZKd3kDNJOGF8wcSuJto6Eh1xZAkwhrdKj/N2EvFbbUBKY+8WNBBJ7I5kkF6WpLrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592557; c=relaxed/simple;
	bh=ihV5q9MTLJ9YRbxhZTg1Qb+rjATeutviE6tAr2UGTLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn8zd9x8Kh+q492sLIS7/aGsumyTSSt/VaE1QYiLFefnLPEfJQbWOGX/QVR2uht0dXsZXDIDHEbE/18iXxrFcHvqTrcMAtMis+BMgu6Nj5vzNqVTUOYwtz8lehZDln2HMmwlAuzlQvcWo3MJz1FKWr32UAivQHKzY3iSGG7lQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJpFj4xv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJpFj4xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E696C4CEF1;
	Mon, 27 Oct 2025 19:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592557;
	bh=ihV5q9MTLJ9YRbxhZTg1Qb+rjATeutviE6tAr2UGTLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJpFj4xvl+ku19Qo52Tt09e8Jie9bx7GbeL/WPM0eiL2XGV0BPTYr3RADXIRH3uuy
	 zpHpRW7yL7pAhr1pJlI1NquG6w4TG4jy10uK3xPlaPYRQvIWP/640EGwebw6fgEKuJ
	 0nbvDpXSCfZYicTiERNdbTFmyV14ap4MQlJESL4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/84] exec: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:35:50 +0100
Message-ID: <20251027183438.858252914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee71a315cc51f..a7dfac338a22c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -748,7 +748,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
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



