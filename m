Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF30131BC96;
	Mon, 27 Oct 2025 19:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591602; cv=none; b=X3rKH13QrWyQbtYneY4Hz9H+aXEtEUhVmhi2zm1XN3+oeDyhc+aV5eQ93prABujZtwFCwRE61Cd4rWBc2wAoU6r8Bfw6vGFDsm0NuK2pMtIDl3sd2m4hHh91ijvZpz+9iq0R3QNyiKwoF5wINTDyUYRjJQMPSZ/pC54ipMQFWdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591602; c=relaxed/simple;
	bh=P/RtpSBVtaxrgEGKTerTNPAhoECJ40XS0bYmRzsBUVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/E5YbzkZJkF5TI8rkuCrREAvNXGLp5xrNBOhqKupWK5I+KFC0vcHbU5YBXVUMJLsyc+Zt05ZVGLZaXTyhG6LVLWQAzXC56ODqWiNkVQtmBeWCpzNzFyPq7CNaIEEbJFQQuwiSrGnlyoW2OxSwWrycpU+itytZAVi81WnIN9oFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7iZs8RE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7iZs8RE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEBCC4CEF1;
	Mon, 27 Oct 2025 19:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591601;
	bh=P/RtpSBVtaxrgEGKTerTNPAhoECJ40XS0bYmRzsBUVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7iZs8REATW6/CJclW/sXiJHADfGscvwAYntz+F28f9ES0otJJ3ixu7Pmz+3ylQjO
	 RaGqz3qy3rT93WZe1s6TiyP8SVzbgiLYimfEeNyZrDEF7jI/USdI/Bhy7YHFLra1R9
	 7ENxFZOWeVX2HWJr+4H38ShH8Ux7ZRLLTosyFqYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/332] exec: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:35:11 +0100
Message-ID: <20251027183531.659304733@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7144c541818f6..2979b458b650a 100644
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



