Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB741F7586;
	Mon, 27 Oct 2025 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592779; cv=none; b=shJzy+ju+KCWVprNvb3M7g1GKjpilVdRbvSbEIPVcpRt/+401flA0MXFPmDY/HtUWqOIjY/f5zKfjdXcX2uwywZjnPxxPRKuIRR6HJ1uC3QSNr2o4G0pvuzvOOIWgTLYmiHQffsL7LwFwDG2SLFiDFSk3ny50UeXAsfZ6wl9sF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592779; c=relaxed/simple;
	bh=1lNGCHKUZxxZ7wixkHZXc39oR9euUs9PG2EAq6i3a2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnIQPIrUWA6T7aE/CsR91gBxts9cusnTlqsfQZ/7eFUEz2HxOBB2P3L7AdPc9kaJ/XdnN/lIdVAYKOusQta5SrRjskhts53iEb6sLkiyn3SWme4qoygEkyLwV4uY5SMB4T/26ZjsJX4UxmwaMwL9UMVXZvJzqSjcdsnxweHQuLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LU7dSZL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LU7dSZL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236C2C4CEF1;
	Mon, 27 Oct 2025 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592779;
	bh=1lNGCHKUZxxZ7wixkHZXc39oR9euUs9PG2EAq6i3a2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LU7dSZL+4T4Kwz6m4fDVxCM8UV8aIfq3Sw791YFkl+/18mVACV9ZhEBqIbfLFWspS
	 FK5BG0ishi8fUeAcARb43DJ35ROSUZYJ/UpPyFhRExYiL3eE6rK6JUvXv5SmC5NZq4
	 JGSOFfjvmX/+pt89IBbxg24bDpUx1/GAe9oOkL3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/117] exec: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:35:27 +0100
Message-ID: <20251027183453.966381048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d607943729638..030240d99ab7c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -717,7 +717,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
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



