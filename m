Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DAD35965;
	Mon, 27 Oct 2025 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592297; cv=none; b=d75hBfwQ6tC0EI8VetYffQ4p1v2Sii259NUBMXaSL1BKsfvN/PZmmj0GW47Ip7jtAXgXZ0y/UOb6QfesqHars2N8ZS1GCKoMV8q2o7lvqHbXO197so0X1+TugkPniLzv27u/+lbG4YWuBWPLvZTsh2lsqG9fDNiOq7IPyBmcveI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592297; c=relaxed/simple;
	bh=kK40/124loPQRKRSt+tz83MajJEcw8JyNKOvjfJkTMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzVQ1fxrpBgNB3bnKwlD09+bnymyrMbIvKkM9r6mJkA7aXpDMnRcshvKZw+vuz4qdkPiW/tXJYi42xgz1LuGcV1fPHkvcyE4aVGmgqzBAWYwmXS5Ntb4O2WdysNGNb0yfUHFJQVA7EMiuSTvW90oHjx+3zJKTkH013y08AcRSr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeAD6qoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeAD6qoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7553CC4CEFD;
	Mon, 27 Oct 2025 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592296;
	bh=kK40/124loPQRKRSt+tz83MajJEcw8JyNKOvjfJkTMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeAD6qojrXwtNJ1VuZ1EX4aiIN+jDYYXHiA9oJ005IQdkkVx34ttO5dRELKVO7KJY
	 wvy102W3gJsO3bP1qXHpuxCqfUmBUGKxTZRWr2d/ZXaVh+HRxOUGURqlDd2RnUQqWF
	 rCnL7Iqby1xhZuVPKJtL75E4Tyv6JrWZji52tD/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/157] exec: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:35:28 +0100
Message-ID: <20251027183503.079388938@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b65af8f9a4f9b..a4d21a67723d7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -750,7 +750,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
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



