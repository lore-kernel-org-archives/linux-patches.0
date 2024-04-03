Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6B4153BF0;
	Wed,  3 Apr 2024 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167010; cv=none; b=YJmyKDpGVc0rwXNNt9F0DBuV+rYnnCtWglef6sLm6Bx5RA45IEiv9nJNzkNZU1VypYfmzBSx8K3nTQvDUaZik8L7I8WIH4oQQaYAM4z8yC6Fwxfze3P4Edr1cVBt7NpgLrAtlKN8IS/ILG3jzoNO/f9sCGEidRJQqwnYOJZ4jlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167010; c=relaxed/simple;
	bh=r8lAmK4vmfYfHEbCXw46mdA3+AOE0ZMvCldpMojuVfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRYiBlWdDtoDC9VJm8p8Jkrf04vye2O+uaO6RFqt37XR3CgSNhJMsnJXj+vFrobJe8xMfz7MVN2c/r2KsbR+D8PFGv9y2RiP2nqy7mPP3VAMjsaY6I113w7cvPntvGFh2btxcQOAzY9V6j03mgJhqGfyb+moACdepjFZuPHooQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e23WRFSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e23WRFSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA30C433C7;
	Wed,  3 Apr 2024 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167010;
	bh=r8lAmK4vmfYfHEbCXw46mdA3+AOE0ZMvCldpMojuVfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e23WRFSf5l69BT+NPzjcyDJsgKFq3pOEHF48+7mmbs2uw85xdJgHa5Cgx9lI6OjIi
	 AWk0EqRdSaXWP9fSvDq/Tu/6cdXW7olZi6GCehaZcM2MLWvc3uJUCDFog2b+gHA+bX
	 gptWvySZjREgYIPzbMmYGJgHhD1h0mWPb9pCuRbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Tejun Heo <tj@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Audra Mitchell <audra@redhat.com>
Subject: [PATCH 6.6 11/11] Revert "workqueue.c: Increase workqueue name length"
Date: Wed,  3 Apr 2024 19:56:00 +0200
Message-ID: <20240403175127.199317314@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403175126.839589571@linuxfoundation.org>
References: <20240403175126.839589571@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 43a181f8f41aca27e7454cf44a6dfbccc8b14e92 which is
commit 31c89007285d365aa36f71d8fb0701581c770a27 upstream.

The workqueue patches backported to 6.6.y caused some reported
regressions, so revert them for now.

Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Tejun Heo <tj@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Audra Mitchell <audra@redhat.com>
Link: https://lore.kernel.org/all/ce4c2f67-c298-48a0-87a3-f933d646c73b@leemhuis.info/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -108,7 +108,7 @@ enum {
 	RESCUER_NICE_LEVEL	= MIN_NICE,
 	HIGHPRI_NICE_LEVEL	= MIN_NICE,
 
-	WQ_NAME_LEN		= 32,
+	WQ_NAME_LEN		= 24,
 };
 
 /*
@@ -4673,7 +4673,6 @@ struct workqueue_struct *alloc_workqueue
 	va_list args;
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	int len;
 
 	/*
 	 * Unbound && max_active == 1 used to imply ordered, which is no longer
@@ -4700,12 +4699,9 @@ struct workqueue_struct *alloc_workqueue
 	}
 
 	va_start(args, max_active);
-	len = vsnprintf(wq->name, sizeof(wq->name), fmt, args);
+	vsnprintf(wq->name, sizeof(wq->name), fmt, args);
 	va_end(args);
 
-	if (len >= WQ_NAME_LEN)
-		pr_warn_once("workqueue: name exceeds WQ_NAME_LEN. Truncating to: %s\n", wq->name);
-
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 


